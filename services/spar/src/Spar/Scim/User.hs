{-# LANGUAGE DataKinds #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE InstanceSigs #-}
{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE NamedFieldPuns #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE ViewPatterns #-}
{-# OPTIONS_GHC -Wno-orphans #-}

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

-- For @instance UserDB Spar@

-- | Doing operations with users via SCIM.
--
-- Provides a 'Scim.Class.User.UserDB' instance.
module Spar.Scim.User
  ( -- * Internals (for testing)
    validateScimUser',
    synthesizeScimUser,
    toScimStoredUser',
    mkUserRef,
  )
where

import Brig.Types.Common (Email (..), fromEmail, parseEmail)
import Brig.Types.Intra (AccountStatus)
import Brig.Types.User (ManagedBy (..), Name (..), User (..))
import qualified Brig.Types.User as BT
import Control.Lens ((^.))
import Control.Monad.Except (MonadError, throwError)
import Control.Monad.Trans.Maybe (MaybeT (MaybeT), runMaybeT)
import Crypto.Hash (Digest, SHA256, hashlazy)
import qualified Data.Aeson as Aeson
import Data.Handle (Handle (Handle), parseHandle)
import Data.Id (Id (Id), UserId, idToText)
import Data.Json.Util (UTCTimeMillis, fromUTCTimeMillis, toUTCTimeMillis)
import Data.Misc ((<$$>))
import Data.String.Conversions (cs)
import qualified Data.Text as Text
import qualified Data.UUID.V4 as UUID
import Imports
import Network.URI (URI, parseURI)
import qualified SAML2.WebSSO as SAML
import Spar.App (Spar, getUser, sparCtxOpts, validateEmailIfExists, wrapMonadClient)
import qualified Spar.Data as Data
import qualified Spar.Intra.Brig as Brig
import Spar.Scim.Auth ()
import qualified Spar.Scim.Types as ST
import Spar.Types (IdP, ScimTokenInfo (..), derivedOpts, derivedOptsScimBaseURI, richInfoLimit)
import qualified System.Logger.Class as Log
import qualified URI.ByteString as URIBS
import qualified Web.Scim.Class.User as Scim
import qualified Web.Scim.Filter as Scim
import qualified Web.Scim.Handler as Scim
import qualified Web.Scim.Schema.Common as Scim
import qualified Web.Scim.Schema.Error as Scim
import qualified Web.Scim.Schema.ListResponse as Scim
import qualified Web.Scim.Schema.Meta as Scim
import qualified Web.Scim.Schema.ResourceType as Scim
import qualified Web.Scim.Schema.User as Scim
import qualified Web.Scim.Schema.User as Scim.User (schemas)
import qualified Wire.API.User.Identity as Id
import qualified Wire.API.User.RichInfo as RI

----------------------------------------------------------------------------
-- UserDB instance

instance Scim.UserDB ST.SparTag Spar where
  getUsers ::
    ScimTokenInfo ->
    Maybe Scim.Filter ->
    Scim.ScimHandler Spar (Scim.ListResponse (Scim.StoredUser ST.SparTag))
  getUsers _ Nothing = do
    throwError $ Scim.badRequest Scim.TooMany (Just "Please specify a filter when getting users.")
  getUsers ScimTokenInfo {stiTeam, stiIdP} (Just filter') = do
    mIdpConfig <- maybe (pure Nothing) (lift . wrapMonadClient . Data.getIdPConfig) stiIdP
    case filter' of
      Scim.FilterAttrCompare (Scim.AttrPath schema attrName _subAttr) Scim.OpEq (Scim.ValString val)
        | Scim.isUserSchema schema -> do
          x <- runMaybeT $ case attrName of
            "username" -> do
              handle <- MaybeT . pure . parseHandle . Text.toLower $ val
              brigUser <- MaybeT . lift . Brig.getBrigUserByHandle $ handle
              guard $ userTeam brigUser == Just stiTeam
              lift $ synthesizeStoredUser brigUser
            "externalid" -> do
              uref <- mkUserRef mIdpConfig (pure val)
              uid <- do
                MaybeT $
                  uref
                    & either
                      ((userId <$$>) . lift . Brig.getBrigUserByEmail)
                      (lift . wrapMonadClient . Data.getSAMLUser)
              brigUser <- MaybeT . lift . Brig.getBrigUser $ uid
              guard $ userTeam brigUser == Just stiTeam
              lift $ synthesizeStoredUser brigUser
            _ -> throwError (Scim.badRequest Scim.InvalidFilter (Just "Unsupported attribute"))
          pure $ Scim.fromList (toList x)
        | otherwise -> throwError $ Scim.badRequest Scim.InvalidFilter (Just "Unsupported schema")
      _ -> throwError $ Scim.badRequest Scim.InvalidFilter (Just "Operation not supported")

  getUser ::
    ScimTokenInfo ->
    UserId ->
    Scim.ScimHandler Spar (Scim.StoredUser ST.SparTag)
  getUser ScimTokenInfo {stiTeam} uid = do
    let notfound = Scim.notFound "User" (idToText uid)
    brigUser <- lift (Brig.getBrigUser uid) >>= maybe (throwError notfound) pure
    unless (userTeam brigUser == Just stiTeam) (throwError notfound)
    synthesizeStoredUser brigUser

  postUser ::
    ScimTokenInfo ->
    Scim.User ST.SparTag ->
    Scim.ScimHandler Spar (Scim.StoredUser ST.SparTag)
  postUser tokinfo user = createValidScimUser tokinfo =<< validateScimUser tokinfo user

  putUser ::
    ScimTokenInfo ->
    UserId ->
    Scim.User ST.SparTag ->
    Scim.ScimHandler Spar (Scim.StoredUser ST.SparTag)
  putUser tokinfo uid newScimUser =
    updateValidScimUser tokinfo uid =<< validateScimUser tokinfo newScimUser

  deleteUser :: ScimTokenInfo -> UserId -> Scim.ScimHandler Spar ()
  deleteUser = deleteScimUser

----------------------------------------------------------------------------
-- User creation and validation

-- | Validate a raw SCIM user record and extract data that we care about. See also:
-- 'ValidScimUser''.
validateScimUser ::
  forall m.
  (m ~ Scim.ScimHandler Spar) =>
  -- | Used to decide what IdP to assign the user to
  ScimTokenInfo ->
  Scim.User ST.SparTag ->
  m ST.ValidScimUser
validateScimUser tokinfo user = do
  mIdpConfig <- tokenInfoToIdP tokinfo
  richInfoLimit <- lift $ asks (richInfoLimit . sparCtxOpts)
  validateScimUser' mIdpConfig richInfoLimit user

tokenInfoToIdP :: ScimTokenInfo -> Scim.ScimHandler Spar (Maybe IdP)
tokenInfoToIdP ScimTokenInfo {stiIdP} = do
  maybe (pure Nothing) (lift . wrapMonadClient . Data.getIdPConfig) stiIdP

-- | Validate a handle (@userName@).
validateHandle :: MonadError Scim.ScimError m => Text -> m Handle
validateHandle txt = case parseHandle txt of
  Just h -> pure h
  Nothing ->
    throwError $
      Scim.badRequest
        Scim.InvalidValue
        (Just (txt <> "is not a valid Wire handle"))

-- | Map the SCIM data on the spar and brig schemata, and throw errors if the SCIM data does
-- not comply with the standard / our constraints. See also: 'ValidScimUser'.
--
-- Checks like "is this handle claimed already?" are not performed. Only schema checks.
--
-- __Mapped fields:__
--
--   * @userName@ is mapped to our 'userHandle'.
--
--   * @displayName@ is mapped to our 'userDisplayName'. We don't use the @name@ field, as it
--     provides a rather poor model for names.
--
--   * The @externalId@ is used to construct a 'SAML.UserRef'. If it looks like an email
--     address, the constructed 'SAML.UserRef' will have @nameid-format:emailAddress@,
--     otherwise the format will be @unspecified@.
--
-- FUTUREWORK: We may need to make the SAML NameID type derived from the available SCIM data
-- configurable on a per-team basis in the future, to accomodate different legal uses of
-- @externalId@ by different teams.
--
-- __Emails and phone numbers:__ we'd like to ensure that only verified emails and phone
-- numbers end up in our database, and implementing verification requires design decisions
-- that we haven't made yet. We store them in our SCIM blobs, but don't syncronize them with
-- Brig. See <https://github.com/wireapp/wire-server/pull/559#discussion_r247466760>.
validateScimUser' ::
  forall m.
  (MonadError Scim.ScimError m) =>
  -- | IdP that the resulting user will be assigned to
  Maybe IdP ->
  -- | Rich info limit
  Int ->
  Scim.User ST.SparTag ->
  m ST.ValidScimUser
validateScimUser' midp richInfoLimit user = do
  uref <- mkUserRef midp (Scim.externalId user)
  handl <- validateHandle . Text.toLower . Scim.userName $ user
  -- FUTUREWORK: 'Scim.userName' should be case insensitive; then the toLower here would
  -- be a little less brittle.
  uname <- do
    let err = throwError . Scim.badRequest Scim.InvalidValue . Just . cs
    either err pure $ Brig.mkUserName (Scim.displayName user) uref
  richInfo <- validateRichInfo (Scim.extra user ^. ST.sueRichInfo)
  let active = Scim.active user
  pure $ ST.ValidScimUser uref handl uname richInfo (fromMaybe True active)
  where
    -- Validate rich info (@richInfo@). It must not exceed the rich info limit.
    validateRichInfo :: RI.RichInfo -> m RI.RichInfo
    validateRichInfo richInfo = do
      let sze = RI.richInfoSize richInfo
      when (sze > richInfoLimit) $
        throwError $
          ( Scim.badRequest
              Scim.InvalidValue
              ( Just . cs $
                  show [RI.richInfoMapURN, RI.richInfoAssocListURN]
                    <> " together exceed the size limit: max "
                    <> show richInfoLimit
                    <> " characters, but got "
                    <> show sze
              )
          )
            { Scim.status = Scim.Status 413
            }
      pure richInfo

-- | Given an 'externalId' and an 'IdP', construct a 'SAML.UserRef'.
--
-- This is needed primarily in 'validateScimUser', but also in 'updateValidScimUser' to
-- recover the 'SAML.UserRef' of the scim user before the update from the database.
mkUserRef ::
  forall m.
  (MonadError Scim.ScimError m) =>
  Maybe IdP ->
  Maybe Text ->
  m (Either Email SAML.UserRef)
mkUserRef _ Nothing = do
  throwError $
    Scim.badRequest
      Scim.InvalidValue
      (Just "externalId is required for SAML users")
mkUserRef Nothing (Just extid) = do
  let err =
        Scim.badRequest
          Scim.InvalidValue
          (Just "externalId must be a valid email or a valid SAML NameID")
  maybe (throwError err) (pure . Left) $ parseEmail extid
mkUserRef (Just idp) (Just extid) = do
  let issuer = idp ^. SAML.idpMetadata . SAML.edIssuer
  subject <- validateSubject extid
  pure . Right $ SAML.UserRef issuer subject
  where
    -- Validate a subject ID (@externalId@).
    validateSubject :: Text -> m SAML.NameID
    validateSubject txt = do
      unameId :: SAML.UnqualifiedNameID <- do
        let eEmail = SAML.mkUNameIDEmail txt
            unspec = SAML.mkUNameIDUnspecified txt
        pure . either (const unspec) id $ eEmail
      case SAML.mkNameID unameId Nothing Nothing Nothing of
        Right nameId -> pure nameId
        Left err ->
          throwError $
            Scim.badRequest
              Scim.InvalidValue
              (Just $ "Can't construct a subject ID from externalId: " <> Text.pack err)

-- | Creates a SCIM User.
--
-- User is created in Brig first, and then in SCIM and SAML.
--
-- Rationale: If brig user creation fails halfway, we don't have SCIM records that
-- point to inactive users. This stops people from logging in into inactive users.
--
-- We only allow SCIM users that authenticate via SAML. (This is by no means necessary,
-- though. It can be relaxed to allow creating users with password authentication if that is a
-- requirement.)
createValidScimUser ::
  forall m.
  (m ~ Scim.ScimHandler Spar) =>
  ScimTokenInfo ->
  ST.ValidScimUser ->
  m (Scim.StoredUser ST.SparTag)
createValidScimUser ScimTokenInfo {stiTeam} vsu@(ST.ValidScimUser uref handl mbName richInfo active) = do
  -- ensure uniqueness constraints of all affected identifiers.
  -- if we crash now, retry POST will just work
  for_ uref assertUserRefUnused
  assertHandleUnused handl
  -- if we crash now, retry POST will just work, or user gets told the handle
  -- is already in use and stops POSTing

  buid <- lift $ do
    -- Generate a UserId will be used both for scim user in spar and for brig.
    buid <- Id <$> liftIO UUID.nextRandom
    _ <- Brig.createBrigUser (either (const Nothing) Just uref) buid stiTeam mbName ManagedByScim
    -- If we crash now, we have an active user that cannot login. And can not
    -- be bound this will be a zombie user that needs to be manually cleaned
    -- up.  We should consider making setUserHandle part of createUser and
    -- making it transactional.  If the user redoes the POST A new standalone
    -- user will be created
    Brig.setBrigUserHandle buid handl
    pure buid

  -- FUTUREWORK(arianvp): Get rid of manual lifting. Needs to be SCIM instances for ExceptT
  -- This is the pain and the price you pay for the horribleness called MTL
  storedUser <- lift . toScimStoredUser buid $ synthesizeScimUser vsu

  -- If we crash now,  a POST retry will fail with 409 user already exists.
  -- Azure at some point will retry with GET /Users?filter=userName eq handle
  -- and then issue a PATCH containing the rich info and the externalId
  lift $ Brig.setBrigUserRichInfo buid richInfo
  -- If we crash now, same as above, but the PATCH will only contain externalId

  -- FUTUREWORK(arianvp): these two actions we probably want to make transactional
  lift . wrapMonadClient $ Data.writeScimUserTimes storedUser
  for_ uref (lift . wrapMonadClient . (`Data.insertSAMLUser` buid))

  lift $ validateEmailIfExists buid uref

  -- TODO(fisx): suspension has yet another race condition: if we don't reach the following
  -- line, the user will be active.
  -- TODO(fisx): what happens with suspended users that have emails?  should emails still be
  -- validated?  will that work on suspended users?  (i think it won't, but i haven't
  -- checked.)
  lift $
    Brig.getStatus buid >>= \old -> do
      let new = ST.scimActiveFlagToAccountStatus old (Just active)
      when (new /= old) $ Brig.setStatus buid new
  pure storedUser

updateValidScimUser ::
  forall m.
  (m ~ Scim.ScimHandler Spar) =>
  ScimTokenInfo ->
  UserId ->
  ST.ValidScimUser ->
  m (Scim.StoredUser ST.SparTag)
updateValidScimUser tokinfo uid newScimUser = do
  -- TODO: how do we get this safe w.r.t. race conditions / crashes?

  -- construct old and new user values with metadata.
  oldScimStoredUser :: Scim.StoredUser ST.SparTag <-
    Scim.getUser tokinfo uid
  oldValidScimUser :: ST.ValidScimUser <-
    validateScimUser tokinfo . Scim.value . Scim.thing $ oldScimStoredUser
  (`assertUserRefNotUsedElsewhere` uid) `traverse_` (newScimUser ^. ST.vsuUserRef)
  assertHandleNotUsedElsewhere uid (newScimUser ^. ST.vsuHandle)
  if oldValidScimUser == newScimUser
    then pure oldScimStoredUser
    else do
      newScimStoredUser :: Scim.StoredUser ST.SparTag <-
        lift $ updScimStoredUser (synthesizeScimUser newScimUser) oldScimStoredUser
      -- update 'SAML.UserRef' on spar (also delete the old 'SAML.UserRef' if it exists and
      -- is different from the new one)
      let eNewUref = newScimUser ^. ST.vsuUserRef
      eOldUref <- do
        let extid :: Maybe Text
            extid = Scim.externalId . Scim.value . Scim.thing $ oldScimStoredUser
        idp <- tokenInfoToIdP tokinfo
        mkUserRef idp extid

      -- handle 'SAML.UserRef' changes
      when (eOldUref /= eNewUref) . lift $ do
        let forOldUref :: SAML.UserRef -> Spar ()
            forOldUref uref = do
              wrapMonadClient $ Data.deleteSAMLUser uref

            forNewUref :: SAML.UserRef -> Spar ()
            forNewUref uref = do
              wrapMonadClient $ Data.insertSAMLUser uref uid
              Brig.setBrigUserUserRef uid uref

            forOldAndNewEmail :: Email -> Email -> Spar ()
            forOldAndNewEmail = do
              -- if old and new email match, do nothing.  if they don't, call brig for email
              -- change procedure.
              undefined

            urefToEmail :: SAML.UserRef -> Email
            urefToEmail = undefined

        case (eOldUref, eNewUref) of
          (Left oldEmail, Left newEmail) -> do
            forOldAndNewEmail oldEmail newEmail
          (Left oldEmail, Right newUref) -> do
            forNewUref newUref
            forOldAndNewEmail oldEmail (urefToEmail newUref)
          (Right oldUref, Left newEmail) -> do
            forOldUref oldUref
            forOldAndNewEmail (urefToEmail oldUref) newEmail
          (Right oldUref, Right newUref) -> do
            forOldUref oldUref
            forNewUref newUref
            forOldAndNewEmail (urefToEmail oldUref) (urefToEmail newUref)

      -- recover old scim user
      oldScimUser :: ST.ValidScimUser <- do
        -- the old scim user from our db is already validated, but this also reconstructs the
        -- 'ValidScimUser' that we need here.
        validateScimUser tokinfo . Scim.value . Scim.thing $ oldScimStoredUser

      -- handles changes in name, handle, richinfo.
      lift $ do
        when (newScimUser ^. ST.vsuName /= oldScimUser ^. ST.vsuName) $ do
          Brig.setBrigUserName uid (newScimUser ^. ST.vsuName)

        when (oldScimUser ^. ST.vsuHandle /= newScimUser ^. ST.vsuHandle) $ do
          Brig.setBrigUserHandle uid (newScimUser ^. ST.vsuHandle)

        when (oldScimUser ^. ST.vsuRichInfo /= newScimUser ^. ST.vsuRichInfo) $ do
          Brig.setBrigUserRichInfo uid (newScimUser ^. ST.vsuRichInfo)

      -- handle change in status
      lift $
        Brig.getStatusMaybe uid >>= \case
          Nothing -> pure ()
          Just old -> do
            let new = ST.scimActiveFlagToAccountStatus old (Just $ newScimUser ^. ST.vsuActive)
            when (new /= old) $ Brig.setStatus uid new

      -- store new user value to scim_user table (spar). (this must happen last, so in case
      -- of crash the client can repeat the operation and it won't be considered a noop.)
      lift . wrapMonadClient $ Data.writeScimUserTimes newScimStoredUser
      pure newScimStoredUser

toScimStoredUser ::
  UserId ->
  Scim.User ST.SparTag ->
  Spar (Scim.StoredUser ST.SparTag)
toScimStoredUser uid usr = do
  SAML.Time (toUTCTimeMillis -> now) <- SAML.getNow
  (createdAt, lastUpdatedAt) <- fromMaybe (now, now) <$> wrapMonadClient (Data.readScimUserTimes uid)
  baseuri <- asks $ derivedOptsScimBaseURI . derivedOpts . sparCtxOpts
  pure $ toScimStoredUser' createdAt lastUpdatedAt baseuri uid usr

toScimStoredUser' ::
  HasCallStack =>
  UTCTimeMillis ->
  UTCTimeMillis ->
  URIBS.URI ->
  UserId ->
  Scim.User ST.SparTag ->
  Scim.StoredUser ST.SparTag
toScimStoredUser' createdAt lastChangedAt baseuri uid usr =
  Scim.WithMeta meta $
    Scim.WithId uid $
      usr {Scim.User.schemas = ST.userSchemas}
  where
    mkLocation :: String -> URI
    mkLocation pathSuffix = convURI $ baseuri SAML.=/ cs pathSuffix
      where
        convURI uri = fromMaybe err . parseURI . cs . URIBS.serializeURIRef' $ uri
          where
            err = error $ "internal error: " <> show uri
    meta =
      Scim.Meta
        { Scim.resourceType = Scim.UserResource,
          Scim.created = fromUTCTimeMillis createdAt,
          Scim.lastModified = fromUTCTimeMillis lastChangedAt,
          Scim.version = calculateVersion uid usr,
          -- TODO: it looks like we need to add this to the HTTP header.
          -- https://tools.ietf.org/html/rfc7644#section-3.14
          Scim.location = Scim.URI . mkLocation $ "/Users/" <> cs (idToText uid)
        }

updScimStoredUser ::
  forall m.
  (SAML.HasNow m) =>
  Scim.User ST.SparTag ->
  Scim.StoredUser ST.SparTag ->
  m (Scim.StoredUser ST.SparTag)
updScimStoredUser usr storedusr = do
  SAML.Time (toUTCTimeMillis -> now) <- SAML.getNow
  pure $ updScimStoredUser' now usr storedusr

updScimStoredUser' ::
  UTCTimeMillis ->
  Scim.User ST.SparTag ->
  Scim.StoredUser ST.SparTag ->
  Scim.StoredUser ST.SparTag
updScimStoredUser' now usr (Scim.WithMeta meta (Scim.WithId scimuid _)) =
  Scim.WithMeta meta' (Scim.WithId scimuid usr)
  where
    meta' =
      meta
        { Scim.lastModified = fromUTCTimeMillis now,
          Scim.version = calculateVersion scimuid usr
        }

deleteScimUser ::
  ScimTokenInfo -> UserId -> Scim.ScimHandler Spar ()
deleteScimUser ScimTokenInfo {stiTeam} uid = do
  mbBrigUser <- lift (Brig.getBrigUser uid)
  case mbBrigUser of
    Nothing -> do
      -- double-deletion gets you a 404.
      throwError $ Scim.notFound "user" (idToText uid)
    Just brigUser -> do
      -- FUTUREWORK: currently it's impossible to delete the last available team owner via SCIM
      -- (because that owner won't be managed by SCIM in the first place), but if it ever becomes
      -- possible, we should do a check here and prohibit it.
      unless (userTeam brigUser == Just stiTeam) $
        -- users from other teams get you a 404.
        throwError $
          Scim.notFound "user" (idToText uid)
      for_ (BT.userSSOId brigUser) $ \ssoId -> do
        uref <- either logThenServerError pure $ Brig.fromUserSSOId ssoId
        lift . wrapMonadClient $ Data.deleteSAMLUser uref
      lift . wrapMonadClient $ Data.deleteScimUserTimes uid
      lift $ Brig.deleteBrigUser uid
      return ()
  where
    logThenServerError :: String -> Scim.ScimHandler Spar b
    logThenServerError err = do
      lift $ Log.err (Log.msg err)
      throwError $ Scim.serverError "Server Error"

----------------------------------------------------------------------------
-- Utilities

-- | Calculate resource version (currently only for 'Scim.User's).
--
-- Spec: <https://tools.ietf.org/html/rfc7644#section-3.14>.
--
-- A version is an /opaque/ string that doesn't need to conform to any format. The only
-- guarantee we have to give is that different resources will have different versions.
--
-- Note: we use weak ETags for versions because we get no guarantees from @aeson@ that its
-- JSON rendering will remain stable between releases, and therefore we can't satisfy the
-- requirements of strong ETags ("same resources have the same version").
calculateVersion ::
  UserId ->
  Scim.User ST.SparTag ->
  Scim.ETag
calculateVersion uid usr = Scim.Weak (Text.pack (show h))
  where
    h :: Digest SHA256
    h = hashlazy (Aeson.encode (Scim.WithId uid usr))

-- |
-- Check that the UserRef is not taken.
--
-- ASSUMPTION: every scim user has a 'SAML.UserRef', and the `SAML.NameID` in it corresponds
-- to a single `externalId`.
assertUserRefUnused :: SAML.UserRef -> Scim.ScimHandler Spar ()
assertUserRefUnused userRef = do
  mExistingUserId <- lift $ getUser userRef
  unless (isNothing mExistingUserId) $
    throwError Scim.conflict {Scim.detail = Just "externalId is already taken"}

-- |
-- Check that the UserRef is not taken any user other than the passed 'UserId'
-- (it is also acceptable if it is not taken by anybody).
--
-- ASSUMPTION: every scim user has a 'SAML.UserRef', and the `SAML.NameID` in it corresponds
-- to a single `externalId`.
assertUserRefNotUsedElsewhere :: SAML.UserRef -> UserId -> Scim.ScimHandler Spar ()
assertUserRefNotUsedElsewhere userRef wireUserId = do
  mExistingUserId <- lift $ getUser userRef
  unless (mExistingUserId `elem` [Nothing, Just wireUserId]) $ do
    throwError Scim.conflict {Scim.detail = Just "externalId does not match UserId"}

assertHandleUnused :: Handle -> Scim.ScimHandler Spar ()
assertHandleUnused = assertHandleUnused' "userName is already taken"

assertHandleUnused' :: Text -> Handle -> Scim.ScimHandler Spar ()
assertHandleUnused' msg hndl = do
  lift (Brig.checkHandleAvailable hndl) >>= \case
    True -> pure ()
    False -> throwError Scim.conflict {Scim.detail = Just msg}

assertHandleNotUsedElsewhere :: UserId -> Handle -> Scim.ScimHandler Spar ()
assertHandleNotUsedElsewhere uid hndl = do
  musr <- lift $ Brig.getBrigUser uid
  unless ((userHandle =<< musr) == Just hndl) $
    assertHandleUnused' "userName does not match UserId" hndl

-- | Helper function that translates a given brig user into a 'Scim.StoredUser', with some
-- effects like updating the 'ManagedBy' field in brig and storing creation and update time
-- stamps.
--
-- FUTUREWORK: race condition: if a team invitation is accepted while being updated, the
-- update may create a bogus invitation, and the user may not be upgraded.
synthesizeStoredUser :: User -> Scim.ScimHandler Spar (Scim.StoredUser ST.SparTag)
synthesizeStoredUser usr = do
  let uid = userId usr

  let readState :: Spar (RI.RichInfo, AccountStatus, Maybe (UTCTimeMillis, UTCTimeMillis), URIBS.URI)
      readState = do
        richInfo <- Brig.getBrigUserRichInfo uid
        accStatus <- Brig.getStatus (BT.userId usr)
        accessTimes <- wrapMonadClient (Data.readScimUserTimes uid)
        baseuri <- asks $ derivedOptsScimBaseURI . derivedOpts . sparCtxOpts
        pure (richInfo, accStatus, accessTimes, baseuri)

  let writeState :: Maybe (UTCTimeMillis, UTCTimeMillis) -> ManagedBy -> Scim.StoredUser ST.SparTag -> Spar ()
      writeState oldAccessTimes managedBy storedUser = do
        when (isNothing oldAccessTimes) $ do
          wrapMonadClient $ Data.writeScimUserTimes storedUser
        when (managedBy /= ManagedByScim) $ do
          Brig.setBrigUserManagedBy uid ManagedByScim

  (richInfo, accStatus, accessTimes, baseuri) <- lift readState
  SAML.Time (toUTCTimeMillis -> now) <- lift SAML.getNow
  let (createdAt, lastUpdatedAt) = fromMaybe (now, now) accessTimes

  handle <- lift $ Brig.giveDefaultHandle usr

  urefOrEmail :: Either Email SAML.UserRef <- do
    let sso :: Maybe Id.UserSSOId = Id.ssoIdentity <=< userIdentity $ usr
        email :: Maybe Email = Id.emailIdentity <=< userIdentity $ usr
    case (sso, email) of
      (Just (Brig.fromUserSSOId -> Right it), _) -> pure $ Right it
      (Nothing, Just it) -> pure $ Left it
      -- the following should not happen.
      (Just _, _) ->
        throwError $ Scim.serverError "found brig user with corrupted saml saml credentials."
      (Nothing, Nothing) -> do
        throwError $ Scim.serverError "found user in brig with no email and no saml credentials."

  let name = userDisplayName usr
      managedBy = BT.userManagedBy usr

  storedUser <-
    synthesizeStoredUser'
      uid
      urefOrEmail
      name
      handle
      richInfo
      accStatus
      createdAt
      lastUpdatedAt
      baseuri
  lift $ writeState accessTimes managedBy storedUser
  pure storedUser

synthesizeStoredUser' ::
  UserId ->
  Either Email SAML.UserRef ->
  Name ->
  Handle ->
  RI.RichInfo ->
  AccountStatus ->
  UTCTimeMillis ->
  UTCTimeMillis ->
  URIBS.URI ->
  MonadError Scim.ScimError m => m (Scim.StoredUser ST.SparTag)
synthesizeStoredUser' uid uref dname handle richInfo accStatus createdAt lastUpdatedAt baseuri = do
  let scimUser :: Scim.User ST.SparTag
      scimUser =
        synthesizeScimUser
          ST.ValidScimUser
            { ST._vsuUserRef = uref,
              ST._vsuHandle = handle, -- 'Maybe' there is one in @usr@, but we want to type checker to make sure this exists.
              ST._vsuName = dname,
              ST._vsuRichInfo = richInfo,
              ST._vsuActive = ST.scimActiveFlagFromAccountStatus accStatus
            }

  pure $ toScimStoredUser' createdAt lastUpdatedAt baseuri uid scimUser

synthesizeScimUser :: ST.ValidScimUser -> Scim.User ST.SparTag
synthesizeScimUser info =
  let Handle userName = info ^. ST.vsuHandle
   in (Scim.empty ST.userSchemas userName (ST.ScimUserExtra (info ^. ST.vsuRichInfo)))
        { Scim.externalId = either (Just . fromEmail) (Brig.urefToExternalId) $ info ^. ST.vsuUserRef,
          Scim.displayName = Just $ fromName (info ^. ST.vsuName),
          Scim.active = Just $ info ^. ST.vsuActive
        }

{- TODO: might be useful later.
~~~~~~~~~~~~~~~~~~~~~~~~~

-- | Parse a name from a user profile into an SCIM name (Okta wants given
-- name and last name, so we break our names up to satisfy Okta).
--
-- TODO: use the same algorithm as Wire clients use.
toScimName :: Name -> Scim.Name
toScimName (Name name) =
  Scim.Name
    { Scim.formatted = Just name
    , Scim.givenName = Just first
    , Scim.familyName = if Text.null rest then Nothing else Just rest
    , Scim.middleName = Nothing
    , Scim.honorificPrefix = Nothing
    , Scim.honorificSuffix = Nothing
    }
  where
    (first, Text.drop 1 -> rest) = Text.breakOn " " name

-- | Convert from the Wire phone type to the SCIM phone type.
toScimPhone :: Phone -> Scim.Phone
toScimPhone (Phone phone) =
  Scim.Phone
    { Scim.typ = Nothing
    , Scim.value = Just phone
    }

-- | Convert from the Wire email type to the SCIM email type.
toScimEmail :: Email -> Scim.Email
toScimEmail (Email eLocal eDomain) =
  Scim.Email
    { Scim.typ = Nothing
    , Scim.value = Scim.EmailAddress2
        (unsafeEmailAddress (encodeUtf8 eLocal) (encodeUtf8 eDomain))
    , Scim.primary = Just True
    }

-}

-- Note [error handling]
-- ~~~~~~~~~~~~~~~~~
--
-- FUTUREWORK: There are two problems with error handling here:
--
-- 1. We want all errors originating from SCIM handlers to be thrown as SCIM
--    errors, not as Spar errors. Currently errors thrown from things like
--    'getTeamMembers' will look like Spar errors and won't be wrapped into
--    the 'ScimError' type. This might or might not be important, depending
--    on what is expected by apps that use the SCIM interface.
--
-- 2. We want generic error descriptions in response bodies, while still
--    logging nice error messages internally. The current messages might
--    be giving too many internal details away.
