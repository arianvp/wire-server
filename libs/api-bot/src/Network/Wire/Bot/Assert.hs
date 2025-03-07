{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE OverloadedStrings #-}

-- This file is part of the Wire Server implementation.
--
-- Copyright (C) 2020 Wire Swiss GmbH <opensource@wire.com>
--
-- This program is free software: you can redistribute it and/or modify it under
-- the terms of the GNU Affero General Public License as published by the Free
-- Software Foundation, either version 3 of the License, or (at your option) any
-- later version.
--
-- This program is distributed in the hope that it will be useful, but WITHOUT
-- ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
-- FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
-- details.
--
-- You should have received a copy of the GNU Affero General Public License along
-- with this program. If not, see <https://www.gnu.org/licenses/>.

module Network.Wire.Bot.Assert where

import Data.Id (ConvId, UserId)
import Data.Qualified (qUnqualified)
import qualified Data.Set as Set
import Imports
import Network.Wire.Bot.Monad
import Network.Wire.Client.API.Conversation
import Network.Wire.Client.API.Push
import Network.Wire.Client.API.User

assertConvCreated ::
  (HasCallStack, MonadBotNet m) =>
  ConvId ->
  -- | The creator of the conversation.
  Bot ->
  -- | The other users in the conversation.
  [Bot] ->
  m ()
assertConvCreated c b bs = do
  let everyone = b : bs
  forM_ bs $ \u ->
    let others = Set.fromList . filter (/= botId u) . map botId $ everyone
     in assertEvent u TConvCreate (convCreate (botId u) others)
  where
    convCreate self others = \case
      EConvCreate e ->
        let cnv = convEvtData e
            mems = cnvMembers cnv
            omems = Set.fromList (map (qUnqualified . omQualifiedId) (cmOthers mems))
         in cnvId cnv == c
              && convEvtFrom e == botId b
              && cnvType cnv == RegularConv
              && memId (cmSelf mems) == self
              && omems == others
      _ -> False

awaitOtrMessage ::
  MonadBotNet m =>
  ConvId ->
  (Bot, BotClient) -> -- Sender
  (Bot, BotClient) -> -- Recipient
  m (Maybe (ConvEvent OtrMessage))
awaitOtrMessage c (from, fc) (to, tc) =
  awaitEvent to TConvOtrMessageAdd assertion >>= \case
    Just (EOtrMessage m) -> return (Just m)
    _ -> return Nothing
  where
    assertion (EOtrMessage evt) =
      let e = convEvtData evt
       in convEvtConv evt == c
            && convEvtFrom evt == botId from
            && otrSender e == botClientId fc
            && otrRecipient e == botClientId tc
    assertion _ = False

-- | Check that given users have received the event about some other users
-- joining a conversation.
assertMembersJoined ::
  (HasCallStack, MonadBotNet m) =>
  -- | Who should've received the event
  [Bot] ->
  -- | Users who have (presumably) joined
  Maybe (ConvEvent SimpleMembers) ->
  m ()
assertMembersJoined _ Nothing = return ()
assertMembersJoined bs (Just e) = forM_ bs $ \b ->
  assertEvent b TConvMemberJoin memAdd
  where
    memAdd (EMemberJoin e') = e == e'
    memAdd _ = False

-- | Check that given users have received the event about some other users
-- leaving a conversation.
assertMembersLeft ::
  (HasCallStack, MonadBotNet m) =>
  -- | Who should've received the event
  [Bot] ->
  -- | Users who have (presumably) left
  Maybe (ConvEvent UserIdList) ->
  m ()
assertMembersLeft _ Nothing = return ()
assertMembersLeft bs (Just e) = forM_ bs $ \b ->
  assertEvent b TConvMemberLeave memRem
  where
    memRem (EMemberLeave e') = e == e'
    memRem _ = False

assertConnectRequested :: (HasCallStack, MonadBotNet m) => Bot -> Bot -> m ()
assertConnectRequested from to =
  assertEvent to TUserConnection $
    connStatus (botId to) (botId from) Pending

assertConnectAccepted :: (HasCallStack, MonadBotNet m) => Bot -> Bot -> m ()
assertConnectAccepted from to = do
  assertEvent to TConvMemberJoin $ memberJoined (botId from) (botId to)
  assertEvent to TUserConnection $ connStatus (botId to) (botId from) Accepted

-------------------------------------------------------------------------------
-- Event matchers

connStatus :: UserId -> UserId -> Relation -> Event -> Bool
connStatus from to rel = \case
  EConnection c _ ->
    ucFrom c == from
      && ucTo c == to
      && ucStatus c == rel
  _ -> False

memberJoined :: UserId -> UserId -> Event -> Bool
memberJoined from other = \case
  EMemberJoin m ->
    null (toList (fmap smId $ mMembers (convEvtData m)) \\ [other, from])
      && convEvtFrom m == from
  _ -> False
