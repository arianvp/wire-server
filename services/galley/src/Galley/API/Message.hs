module Galley.API.Message where

import Control.Lens
import Data.Domain (Domain)
import Data.Id (ClientId, ConnId, ConvId, UserId)
import Data.Json.Util (UTCTimeMillis, toBase64Text, toUTCTimeMillis)
import Data.List1 (singleton)
import qualified Data.Map as Map
import Data.Map.Lens (toMapOf)
import Data.Proxy
import Data.Qualified (Qualified (..), partitionRemote)
import Data.SOP (I (..), htrans, unI)
import qualified Data.Set as Set
import Data.Set.Lens
import Data.Time.Clock (UTCTime, getCurrentTime)
import Galley.API.LegalHold.Conflicts (guardQualifiedLegalholdPolicyConflicts)
import Galley.API.Util (runFederatedBrig, runUnionT, throwUnion, viewFederationDomain)
import Galley.App
import qualified Galley.Data as Data
import Galley.Data.Services as Data
import qualified Galley.External as External
import qualified Galley.Intra.Client as Intra
import Galley.Intra.Push
import Galley.Intra.User
import Galley.Options (optSettings, setIntraListing)
import qualified Galley.Types.Clients as Clients
import Galley.Types.Conversations.Members
import Gundeck.Types.Push.V2 (RecipientClients (..))
import Imports
import Servant.API (Union, WithStatus (..))
import UnliftIO.Async
import Wire.API.ErrorDescription as ErrorDescription
import Wire.API.Event.Conversation
import qualified Wire.API.Federation.API.Brig as FederatedBrig
import Wire.API.Message
import qualified Wire.API.Message as Public
import Wire.API.Routes.Public.Galley as Public
import Wire.API.Team.LegalHold
import Wire.API.User.Client
import Wire.API.UserMap (UserMap (..))

data UserType = User | Bot

userToProtectee :: UserType -> UserId -> LegalholdProtectee
userToProtectee User user = ProtectedUser user
userToProtectee Bot _ = UnprotectedBot

data QualifiedMismatch = QualifiedMismatch
  { qmMissing :: QualifiedUserClients,
    qmRedundant :: QualifiedUserClients,
    qmDeleted :: QualifiedUserClients
  }
  deriving (Show, Eq)

type QualifiedRecipientSet = Set (Domain, UserId, ClientId)

mkQualifiedMismatch ::
  QualifiedRecipientSet -> QualifiedRecipientSet -> QualifiedRecipientSet -> QualifiedMismatch
mkQualifiedMismatch missing redundant deleted =
  QualifiedMismatch
    (mkQualifiedUserClients missing)
    (mkQualifiedUserClients redundant)
    (mkQualifiedUserClients deleted)

mkQualifiedUserClients :: QualifiedRecipientSet -> QualifiedUserClients
mkQualifiedUserClients =
  QualifiedUserClients
    . Set.foldr (\(d, u, c) -> Map.insertWith (Map.unionWith Set.union) d (Map.singleton u (Set.singleton c))) Map.empty

mkMessageSendingStatus :: UTCTimeMillis -> QualifiedMismatch -> QualifiedUserClients -> MessageSendingStatus
mkMessageSendingStatus time mismatch failures =
  MessageSendingStatus
    { mssTime = time,
      mssMissingClients = qmMissing mismatch,
      mssRedundantClients = qmRedundant mismatch,
      mssDeletedClients = qmDeleted mismatch,
      mssFailedToSend = failures
    }

clientMismatchStrategyApply :: ClientMismatchStrategy -> QualifiedRecipientSet -> QualifiedRecipientSet
clientMismatchStrategyApply MismatchReportAll = id
clientMismatchStrategyApply MismatchIgnoreAll = const mempty
clientMismatchStrategyApply (MismatchReportOnly users) =
  Set.filter (\(d, u, _) -> Set.member (Qualified u d) users)
clientMismatchStrategyApply (MismatchIgnoreOnly users) =
  Set.filter (\(d, u, _) -> not (Set.member (Qualified u d) users))

-- A Venn diagram of words in this function:
--
--                +-----------------------------------+
--                |                                   |
--    +---------->|                 +-----------------+--------------------+
--    |           |                 |                 |                    | <------+
--    |           |                 |                 |   Deleted Clients  |        |
--    |           |                 |                 |                    |        |
-- Expected       |                 |                 |                    |   Recipients
-- Clients        |  Missing        | Valid           |       Extra        |
--                |  Clients        | Clients         +-------Clients------+----------+
--                |                 |                 |                    |          |
--                |                 |                 |                    |          |
--                |                 |                 |       Redundant Clients     <------- Sender Client
--                |                 |                 |                    |          |
--                |                 |                 |                    |          |
--                |                 |                 |                    |          |
--                |                 +--------------------------------------+----------+
--                |                                   |
--                +-----------------------------------+
checkMessageClients ::
  -- | Sender
  (Domain, UserId, ClientId) ->
  -- | Participants of the conversation
  --
  -- When the set of clients for a given user is empty, that means the user is
  -- present in the conversation, but has no clients at all, and this is a
  -- valid state.
  Map (Domain, UserId) (Set ClientId) ->
  -- | Provided recipients and ciphertexts
  Map (Domain, UserId, ClientId) ByteString ->
  -- | Subset of missing clients to report
  ClientMismatchStrategy ->
  (Bool, Map (Domain, UserId, ClientId) ByteString, QualifiedMismatch)
checkMessageClients sender participantMap recipientMap mismatchStrat =
  let participants = setOf ((itraversed <. folded) . withIndex . to (\((d, u), c) -> (d, u, c))) participantMap
      expected = Set.delete sender participants
      expectedUsers :: Set (Domain, UserId) = Map.keysSet participantMap

      recipients = Map.keysSet recipientMap
      -- Whoever is expected but not in recipients is missing.
      missing = Set.difference expected recipients
      -- Whoever is in recipient but not expected is extra.
      extra = Set.difference recipients expected
      -- The clients which belong to users who are expected are considered deleted.
      deleted =
        Set.delete sender -- the sender is never deleted
          . Set.filter (\(d, u, _) -> Set.member (d, u) expectedUsers)
          $ extra
      -- The clients which are extra but not deleted, must belong to users which
      -- are not in the convesation and hence considered redundant.
      redundant = Set.difference extra deleted
      -- The clients which are both recipients and expected are considered valid.
      valid = Set.intersection recipients expected
      validMap = Map.restrictKeys recipientMap valid
      -- Resolve whether the message is valid using client mismatch strategy
      reportedMissing = clientMismatchStrategyApply mismatchStrat missing
   in ( Set.null reportedMissing,
        validMap,
        mkQualifiedMismatch reportedMissing redundant deleted
      )

getRemoteClients :: ConvId -> Galley (Map (Domain, UserId) (Set ClientId))
getRemoteClients convId = do
  remoteMembers <- Data.lookupRemoteMembers convId
  fmap mconcat -- concatenating maps is correct here, because their sets of keys are disjoint
    . pooledMapConcurrentlyN 8 (uncurry getRemoteClientsFromDomain)
    . partitionRemote
    . map rmId
    $ remoteMembers
  where
    getRemoteClientsFromDomain :: Domain -> [UserId] -> Galley (Map (Domain, UserId) (Set ClientId))
    getRemoteClientsFromDomain domain uids = do
      let rpc = FederatedBrig.getUserClients FederatedBrig.clientRoutes (FederatedBrig.GetUserClients uids)
      Map.mapKeys (domain,) . fmap (Set.map pubClientId) . userMap <$> runFederatedBrig domain rpc

postQualifiedOtrMessage :: UserType -> UserId -> Maybe ConnId -> ConvId -> Public.QualifiedNewOtrMessage -> Galley (Union Public.PostOtrResponses)
postQualifiedOtrMessage senderType sender mconn convId msg = runUnionT $ do
  alive <- Data.isConvAlive convId
  localDomain <- viewFederationDomain
  now <- liftIO getCurrentTime
  let nowMillis = toUTCTimeMillis now
  -- TODO: Test this, fix this, make it a parameters
  senderDomain <- viewFederationDomain
  let senderClient = qualifiedNewOtrSender msg
  unless alive $ do
    Data.deleteConversation convId
    throwUnion ErrorDescription.convNotFound

  -- get local clients
  localMembers <- Data.members convId
  let localMemberIds = memId <$> localMembers
      localMemberMap :: Map UserId LocalMember
      localMemberMap = Map.fromList (map (\mem -> (memId mem, mem)) localMembers)
  isInternal <- view $ options . optSettings . setIntraListing
  localClients <-
    lift $
      if isInternal
        then Clients.fromUserClients <$> Intra.lookupClients localMemberIds
        else Data.lookupClients localMemberIds
  let qualifiedLocalClients =
        Map.mapKeys (localDomain,)
          . makeUserMap (Set.fromList (map memId localMembers))
          . Clients.toMap
          $ localClients

  -- check if the sender is part of the conversation
  -- FUTUREWORK: handle remote sender
  when (not (Map.member sender localMemberMap)) $ do
    throwUnion ErrorDescription.convNotFound

  -- check if the sender client exists (as one of the clients in the conversation)
  -- FUTUREWORK: handle remote sender
  unless (Set.member senderClient (Map.findWithDefault mempty (senderDomain, sender) qualifiedLocalClients)) $ do
    throwUnion ErrorDescription.unknownClient

  qualifiedRemoteClients <- lift $ getRemoteClients convId

  let (sendMessage, validMessages, mismatch) =
        checkMessageClients
          (senderDomain, sender, qualifiedNewOtrSender msg)
          (qualifiedLocalClients <> qualifiedRemoteClients)
          (flattenMap $ qualifiedNewOtrRecipients msg)
          (qualifiedNewOtrClientMismatchStrategy msg)
      otrResult = mkMessageSendingStatus nowMillis mismatch mempty
  unless sendMessage $ do
    lift $ guardQualifiedLegalholdPolicyConflicts (userToProtectee senderType sender) (qmMissing mismatch)
    throwUnion $ WithStatus @412 otrResult
  let qualifiedConv = Qualified convId localDomain
      qualifiedSender = Qualified sender senderDomain
      localValidMessages = Map.mapKeys (\(_, u, c) -> (u, c)) $ Map.filterWithKey (\(d, _, _) _ -> localDomain == d) validMessages
      metadata = qualifiedNewOtrMetadata msg
      events =
        localValidMessages & reindexed snd itraversed
          %@~ newMessageEvent
            qualifiedConv
            qualifiedSender
            (Public.qualifiedNewOtrSender msg)
            (Public.qualifiedNewOtrData msg)
            now
      pushes =
        events & itraversed
          %@~ newMessagePush localDomain localMemberMap mconn metadata
  lift $ runMessagePush convId (pushes ^. traversed)
  throwUnion $ WithStatus @201 otrResult
  where
    makeUserMap :: Set UserId -> Map UserId (Set ClientId) -> Map UserId (Set ClientId)
    makeUserMap keys = (<> Map.fromSet (const mempty) keys)

flatten :: Map Domain (Map UserId (Set ClientId)) -> Set (Domain, UserId, ClientId)
flatten =
  setOf $
    (itraversed <.> itraversed <. folded)
      . withIndex
      . to (\((d, u), c) -> (d, u, c))

flattenMap :: QualifiedOtrRecipients -> Map (Domain, UserId, ClientId) ByteString
flattenMap (QualifiedOtrRecipients (QualifiedUserClientMap m)) =
  toMapOf (reindexed (\(d, (u, c)) -> (d, u, c)) (itraversed <.> itraversed <.> itraversed)) m

data MessagePush = MessagePush
  { userPushes :: [Push],
    botPushes :: [(BotMember, Event)]
  }

instance Semigroup MessagePush where
  MessagePush us1 bs1 <> MessagePush us2 bs2 = MessagePush (us1 <> us2) (bs1 <> bs2)

instance Monoid MessagePush where
  mempty = MessagePush mempty mempty

newUserPush :: Push -> MessagePush
newUserPush p = MessagePush {userPushes = pure p, botPushes = mempty}

newBotPush :: BotMember -> Event -> MessagePush
newBotPush b e = MessagePush {userPushes = mempty, botPushes = pure (b, e)}

runMessagePush :: ConvId -> MessagePush -> Galley ()
runMessagePush cnv mp = do
  pushSome (userPushes mp)
  void . forkIO $ do
    gone <- External.deliver (botPushes mp)
    mapM_ (deleteBot cnv . botMemId) gone

newMessageEvent :: Qualified ConvId -> Qualified UserId -> ClientId -> ByteString -> UTCTime -> ClientId -> ByteString -> Event
newMessageEvent convId sender senderClient dat time recieverClient cipherText =
  Event OtrMessageAdd convId sender time . EdOtrMessage $
    OtrMessage
      { otrSender = senderClient,
        otrRecipient = recieverClient,
        otrCiphertext = toBase64Text cipherText,
        otrData = Just $ toBase64Text dat
      }

newMessagePush ::
  Ord k =>
  Domain ->
  Map k LocalMember ->
  Maybe ConnId ->
  MessageMetadata ->
  (k, ClientId) ->
  Event ->
  MessagePush
newMessagePush localDomain members mconn mm (k, client) e = fromMaybe mempty $ do
  member <- Map.lookup k members
  newBotMessagePush member <|> newUserMessagePush member
  where
    newBotMessagePush :: LocalMember -> Maybe MessagePush
    newBotMessagePush member = newBotPush <$> newBotMember member <*> pure e
    newUserMessagePush :: LocalMember -> Maybe MessagePush
    newUserMessagePush member =
      fmap newUserPush $
        newConversationEventPush localDomain e [memId member]
          <&> set pushConn mconn
            . set pushNativePriority (mmNativePriority mm)
            . set pushRoute (bool RouteDirect RouteAny (mmNativePush mm))
            . set pushTransient (mmTransient mm)
            . set (pushRecipients . traverse . recipientClients) (RecipientClientsSome (singleton client))

data MessageMetadata = MessageMetadata
  { mmNativePush :: Bool,
    mmTransient :: Bool,
    mmNativePriority :: Maybe Priority,
    mmData :: ByteString
  }
  deriving (Eq, Ord, Show)

qualifiedNewOtrMetadata :: Public.QualifiedNewOtrMessage -> MessageMetadata
qualifiedNewOtrMetadata msg =
  MessageMetadata
    { mmNativePush = Public.qualifiedNewOtrNativePush msg,
      mmTransient = Public.qualifiedNewOtrTransient msg,
      mmNativePriority = Public.qualifiedNewOtrNativePriority msg,
      mmData = Public.qualifiedNewOtrData msg
    }

-- unqualified

legacyClientMismatchStrategy :: Domain -> Maybe [UserId] -> Maybe Public.IgnoreMissing -> Maybe Public.ReportMissing -> ClientMismatchStrategy
legacyClientMismatchStrategy localDomain (Just uids) _ _ =
  MismatchReportOnly (Set.fromList (map (`Qualified` localDomain) uids))
legacyClientMismatchStrategy _ Nothing (Just IgnoreMissingAll) _ = MismatchIgnoreAll
legacyClientMismatchStrategy localDomain Nothing (Just (IgnoreMissingList uids)) _ =
  MismatchIgnoreOnly (Set.map (`Qualified` localDomain) uids)
legacyClientMismatchStrategy _ Nothing Nothing (Just ReportMissingAll) = MismatchReportAll
legacyClientMismatchStrategy localDomain Nothing Nothing (Just (ReportMissingList uids)) =
  MismatchReportOnly (Set.map (`Qualified` localDomain) uids)
legacyClientMismatchStrategy _ Nothing Nothing Nothing = MismatchReportAll

class Unqualify a b where
  unqualify :: Domain -> a -> b

instance Unqualify a a where
  unqualify _ = id

instance
  Unqualify a b =>
  Unqualify (WithStatus c a) (WithStatus c b)
  where
  unqualify domain (WithStatus x) = WithStatus (unqualify domain x)

instance Unqualify MessageSendingStatus ClientMismatch where
  unqualify domain status =
    ClientMismatch
      { cmismatchTime = mssTime status,
        missingClients = unqualify domain (mssMissingClients status),
        redundantClients = unqualify domain (mssRedundantClients status),
        deletedClients = unqualify domain (mssDeletedClients status)
      }

instance Unqualify QualifiedUserClients UserClients where
  unqualify domain =
    UserClients
      . Map.findWithDefault mempty domain
      . qualifiedUserClients

instance Unqualify (Union PostOtrResponses) (Union PostOtrResponsesUnqualified) where
  unqualify domain = htrans (Proxy @Unqualify) $ I . unqualify domain . unI
