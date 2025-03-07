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

module Brig.User.API.Auth
  ( routesPublic,
    routesInternal,
  )
where

import Brig.API.Error
import Brig.API.Handler
import qualified Brig.API.User as User
import Brig.App (AppIO)
import Brig.Phone
import Brig.Types.Intra (ReAuthUser, reAuthPassword)
import Brig.Types.User.Auth
import qualified Brig.User.Auth as Auth
import qualified Brig.User.Auth.Cookie as Auth
import qualified Brig.ZAuth as ZAuth
import qualified Data.ByteString as BS
import Data.ByteString.Conversion
import Data.Either.Combinators (leftToMaybe, rightToMaybe)
import Data.Id
import Data.List1 (List1)
import qualified Data.List1 as List1
import Data.Predicate
import qualified Data.Swagger.Build.Api as Doc
import qualified Data.ZAuth.Token as ZAuth
import Imports
import Network.HTTP.Types.Status
import Network.Wai (Response)
import Network.Wai.Predicate
import qualified Network.Wai.Predicate as P
import qualified Network.Wai.Predicate.Request as R
import Network.Wai.Routing
import Network.Wai.Utilities.Error ((!>>))
import Network.Wai.Utilities.Request (JsonRequest, jsonRequest)
import Network.Wai.Utilities.Response (empty, json)
import Network.Wai.Utilities.Swagger (document)
import qualified Network.Wai.Utilities.Swagger as Doc
import Wire.API.User.Auth as Public
import Wire.Swagger as Doc (pendingLoginError)

routesPublic :: Routes Doc.ApiBuilder Handler ()
routesPublic = do
  post "/access" (continue renewH) $
    accept "application" "json"
      .&. tokenRequest
  document "POST" "newAccessToken" $ do
    Doc.summary "Obtain an access tokens for a cookie."
    Doc.notes
      "You can provide only a cookie or a cookie and token. \
      \Every other combination is invalid. \
      \Access tokens can be given as query parameter or authorisation \
      \header, with the latter being preferred."
    Doc.returns (Doc.ref Public.modelAccessToken)
    Doc.parameter Doc.Header "cookie" Doc.bytes' $ do
      Doc.description "The 'zuid' cookie header"
      Doc.optional
    Doc.parameter Doc.Header "Authorization" Doc.bytes' $ do
      Doc.description "The access-token as 'Authorization' header."
      Doc.optional
    Doc.parameter Doc.Query "access_token" Doc.bytes' $ do
      Doc.description "The access-token as query parameter."
      Doc.optional
    Doc.errorResponse badCredentials

  post "/login/send" (continue sendLoginCodeH) $
    jsonRequest @Public.SendLoginCode
  document "POST" "sendLoginCode" $ do
    Doc.summary "Send a login code to a verified phone number."
    Doc.notes
      "This operation generates and sends a login code. \
      \A login code can be used only once and times out after \
      \10 minutes. Only one login code may be pending at a time."
    Doc.body (Doc.ref Public.modelSendLoginCode) $
      Doc.description "JSON body"
    Doc.returns (Doc.ref Public.modelLoginCodeResponse)
    Doc.response 200 "Login code sent." Doc.end
    Doc.errorResponse invalidPhone
    Doc.errorResponse passwordExists
    Doc.errorResponse' loginCodePending Doc.pendingLoginError

  post "/login" (continue loginH) $
    jsonRequest @Public.Login
      .&. def False (query "persist")
      .&. accept "application" "json"
  document "POST" "login" $ do
    Doc.summary "Authenticate a user to obtain a cookie and first access token."
    Doc.notes "Logins are throttled at the server's discretion."
    Doc.body (Doc.ref Public.modelLogin) $
      Doc.description
        "The optional label can later be used to delete all \
        \cookies matching this label (cf. /cookies/remove)."
    Doc.parameter Doc.Query "persist" (Doc.bool $ Doc.def False) $ do
      Doc.description "Request a persistent cookie instead of a session cookie."
      Doc.optional
    Doc.errorResponse badCredentials
    Doc.errorResponse accountSuspended
    Doc.errorResponse accountPending
    Doc.errorResponse loginsTooFrequent

  post "/access/logout" (continue logoutH) $
    accept "application" "json" .&. tokenRequest
  document "POST" "logout" $ do
    Doc.summary "Log out in order to remove a cookie from the server."
    Doc.notes
      "Calling this endpoint will effectively revoke the given cookie \
      \and subsequent calls to /access with the same cookie will \
      \result in a 403."
    Doc.parameter Doc.Header "cookie" Doc.bytes' $
      Doc.description "The 'zuid' cookie header"
    Doc.parameter Doc.Header "Authorization" Doc.bytes' $ do
      Doc.description "The access-token as 'Authorization' header."
      Doc.optional
    Doc.parameter Doc.Query "access_token" Doc.bytes' $ do
      Doc.description "The access-token as query parameter."
      Doc.optional
    Doc.errorResponse badCredentials

  get "/cookies" (continue listCookiesH) $
    header "Z-User"
      .&. opt (query "labels")
      .&. accept "application" "json"
  document "GET" "getCookies" $ do
    Doc.summary "Retrieve the list of cookies currently stored for the user."
    Doc.returns (Doc.ref Public.modelCookieList)
    Doc.parameter Doc.Query "labels" Doc.bytes' $ do
      Doc.description "Filter by label (comma-separated list)"
      Doc.optional

  post "/cookies/remove" (continue rmCookiesH) $
    header "Z-User"
      .&. jsonRequest @Public.RemoveCookies
  document "POST" "rmCookies" $ do
    Doc.summary "Revoke stored cookies."
    Doc.body (Doc.ref Public.modelRemoveCookies) Doc.end
    Doc.errorResponse badCredentials

routesInternal :: Routes a Handler ()
routesInternal = do
  -- galley can query this endpoint at the right moment in the LegalHold flow
  post "/i/legalhold-login" (continue legalHoldLoginH) $
    jsonRequest @LegalHoldLogin
      .&. accept "application" "json"

  post "/i/sso-login" (continue ssoLoginH) $
    jsonRequest @SsoLogin
      .&. def False (query "persist")
      .&. accept "application" "json"

  get "/i/users/login-code" (continue getLoginCodeH) $
    accept "application" "json"
      .&. param "phone"

  get "/i/users/:uid/reauthenticate" (continue reAuthUserH) $
    capture "uid"
      .&. jsonRequest @ReAuthUser

-- Handlers

sendLoginCodeH :: JsonRequest Public.SendLoginCode -> Handler Response
sendLoginCodeH req = do
  json <$> (sendLoginCode =<< parseJsonBody req)

sendLoginCode :: Public.SendLoginCode -> Handler Public.LoginCodeTimeout
sendLoginCode (Public.SendLoginCode phone call force) = do
  checkWhitelist (Right phone)
  c <- Auth.sendLoginCode phone call force !>> sendLoginCodeError
  return $ Public.LoginCodeTimeout (pendingLoginTimeout c)

getLoginCodeH :: JSON ::: Phone -> Handler Response
getLoginCodeH (_ ::: phone) = json <$> getLoginCode phone

getLoginCode :: Phone -> Handler Public.PendingLoginCode
getLoginCode phone = do
  code <- lift $ Auth.lookupLoginCode phone
  maybe (throwStd loginCodeNotFound) return code

reAuthUserH :: UserId ::: JsonRequest ReAuthUser -> Handler Response
reAuthUserH (uid ::: req) = do
  reAuthUser uid =<< parseJsonBody req
  return empty

reAuthUser :: UserId -> ReAuthUser -> Handler ()
reAuthUser uid body = do
  User.reauthenticate uid (reAuthPassword body) !>> reauthError

loginH :: JsonRequest Public.Login ::: Bool ::: JSON -> Handler Response
loginH (req ::: persist ::: _) = do
  lift . tokenResponse =<< flip login persist =<< parseJsonBody req

login :: Public.Login -> Bool -> Handler (Auth.Access ZAuth.User)
login l persist = do
  let typ = if persist then PersistentCookie else SessionCookie
  Auth.login l typ !>> loginError

ssoLoginH :: JsonRequest SsoLogin ::: Bool ::: JSON -> Handler Response
ssoLoginH (req ::: persist ::: _) = do
  lift . tokenResponse =<< flip ssoLogin persist =<< parseJsonBody req

ssoLogin :: SsoLogin -> Bool -> Handler (Auth.Access ZAuth.User)
ssoLogin l persist = do
  let typ = if persist then PersistentCookie else SessionCookie
  Auth.ssoLogin l typ !>> loginError

legalHoldLoginH :: JsonRequest LegalHoldLogin ::: JSON -> Handler Response
legalHoldLoginH (req ::: _) = do
  lift . tokenResponse =<< legalHoldLogin =<< parseJsonBody req

legalHoldLogin :: LegalHoldLogin -> Handler (Auth.Access ZAuth.LegalHoldUser)
legalHoldLogin l = do
  let typ = PersistentCookie -- Session cookie isn't a supported use case here
  Auth.legalHoldLogin l typ !>> legalHoldLoginError

logoutH :: JSON ::: Maybe (Either (List1 ZAuth.UserToken) (List1 ZAuth.LegalHoldUserToken)) ::: Maybe (Either ZAuth.AccessToken ZAuth.LegalHoldAccessToken) -> Handler Response
logoutH (_ ::: ut ::: at) = empty <$ logout ut at

-- TODO: add legalhold test checking cookies are revoked (/access/logout is called) when legalhold device is deleted.
logout ::
  Maybe (Either (List1 ZAuth.UserToken) (List1 ZAuth.LegalHoldUserToken)) ->
  Maybe (Either ZAuth.AccessToken ZAuth.LegalHoldAccessToken) ->
  Handler ()
logout Nothing Nothing = throwStd authMissingCookieAndToken
logout Nothing (Just _) = throwStd authMissingCookie
logout (Just _) Nothing = throwStd authMissingToken
logout (Just (Left _)) (Just (Right _)) = throwStd authTokenMismatch
logout (Just (Right _)) (Just (Left _)) = throwStd authTokenMismatch
logout (Just (Left ut)) (Just (Left at)) = Auth.logout ut at !>> zauthError
logout (Just (Right ut)) (Just (Right at)) = Auth.logout ut at !>> zauthError

listCookiesH :: UserId ::: Maybe (List Public.CookieLabel) ::: JSON -> Handler Response
listCookiesH (u ::: ll ::: _) = json <$> lift (listCookies u ll)

listCookies :: UserId -> Maybe (List Public.CookieLabel) -> AppIO Public.CookieList
listCookies u ll = do
  Public.CookieList <$> Auth.listCookies u (maybe [] fromList ll)

rmCookiesH :: UserId ::: JsonRequest Public.RemoveCookies -> Handler Response
rmCookiesH (uid ::: req) = do
  empty <$ (rmCookies uid =<< parseJsonBody req)

rmCookies :: UserId -> Public.RemoveCookies -> Handler ()
rmCookies uid (Public.RemoveCookies pw lls ids) = do
  Auth.revokeAccess uid pw ids lls !>> authError

renewH :: JSON ::: Maybe (Either (List1 ZAuth.UserToken) (List1 ZAuth.LegalHoldUserToken)) ::: Maybe (Either ZAuth.AccessToken ZAuth.LegalHoldAccessToken) -> Handler Response
renewH (_ ::: ut ::: at) = lift . either tokenResponse tokenResponse =<< renew ut at

-- | renew access for either:
-- * a user with user token and optional access token, or
-- * a legalhold user with legalhold user token and optional legalhold access token.
--
-- Other combinations of provided inputs will cause an error to be raised.
renew ::
  Maybe (Either (List1 ZAuth.UserToken) (List1 ZAuth.LegalHoldUserToken)) ->
  Maybe (Either ZAuth.AccessToken ZAuth.LegalHoldAccessToken) ->
  Handler (Either (Auth.Access ZAuth.User) (Auth.Access ZAuth.LegalHoldUser))
renew = \case
  Nothing ->
    const $ throwStd authMissingCookie
  (Just (Left userTokens)) ->
    -- normal UserToken, so we want a normal AccessToken
    fmap Left . renewAccess userTokens <=< matchingOrNone leftToMaybe
  (Just (Right legalholdUserTokens)) ->
    -- LegalholdUserToken, so we want a LegalholdAccessToken
    fmap Right . renewAccess legalholdUserTokens <=< matchingOrNone rightToMaybe
  where
    renewAccess uts mat =
      Auth.renewAccess uts mat !>> zauthError
    matchingOrNone :: (a -> Maybe b) -> Maybe a -> Handler (Maybe b)
    matchingOrNone matching = traverse $ \accessToken ->
      case matching accessToken of
        Just m -> pure m
        Nothing -> throwStd authTokenMismatch

-- Utilities
--

-- | A predicate that captures user and access tokens for a request handler.
tokenRequest ::
  forall r.
  (R.HasCookies r, R.HasHeaders r, R.HasQuery r) =>
  Predicate
    r
    P.Error
    ( Maybe (Either (List1 ZAuth.UserToken) (List1 ZAuth.LegalHoldUserToken))
        ::: Maybe (Either ZAuth.AccessToken ZAuth.LegalHoldAccessToken)
    )
tokenRequest = opt (userToken ||| legalHoldUserToken) .&. opt (accessToken ||| legalHoldAccessToken)
  where
    userToken = cookieErr @ZAuth.User <$> cookies "zuid"
    legalHoldUserToken = cookieErr @ZAuth.LegalHoldUser <$> cookies "zuid"
    accessToken = parse @ZAuth.Access <$> (tokenHeader .|. tokenQuery)
    legalHoldAccessToken = parse @ZAuth.LegalHoldAccess <$> (tokenHeader .|. tokenQuery)
    --
    tokenHeader :: r -> Result P.Error ByteString
    tokenHeader = bearer <$> header "authorization"
    --
    tokenQuery :: r -> Result P.Error ByteString
    tokenQuery = query "access_token"
    --
    cookieErr :: ZAuth.UserTokenLike u => Result P.Error (List1 (ZAuth.Token u)) -> Result P.Error (List1 (ZAuth.Token u))
    cookieErr x@Okay {} = x
    cookieErr (Fail x) = Fail (setMessage "Invalid user token" (P.setStatus status403 x))
    --
    -- Extract the access token from the Authorization header.
    bearer :: Result P.Error ByteString -> Result P.Error ByteString
    bearer (Fail x) = Fail x
    bearer (Okay _ b) =
      let (prefix, suffix) = BS.splitAt 7 b
       in if prefix == "Bearer "
            then return suffix
            else
              Fail
                ( setReason
                    TypeError
                    (setMessage "Invalid authorization scheme" (err status403))
                )
    --
    -- Parse the access token
    parse :: ZAuth.AccessTokenLike a => Result P.Error ByteString -> Result P.Error (ZAuth.Token a)
    parse (Fail x) = Fail x
    parse (Okay _ b) = case fromByteString b of
      Nothing ->
        Fail
          ( setReason
              TypeError
              (setMessage "Invalid access token" (err status403))
          )
      Just t -> return t

tokenResponse :: ZAuth.UserTokenLike u => Auth.Access u -> AppIO Response
tokenResponse (Auth.Access t Nothing) = pure $ json t
tokenResponse (Auth.Access t (Just c)) = Auth.setResponseCookie c (json t)

-- | Internal utilities: These functions are nearly copies verbatim from the original
-- project: https://gitlab.com/twittner/wai-predicates/-/blob/develop/src/Network/Wai/Predicate.hs#L106-112
-- I will still make an upstream PR but would not like to block this PR because of
-- it. Main difference: the original stops after finding the first valid cookie which
-- is a problem if clients send more than 1 cookie and one of them happens to be invalid
-- We should also be dropping this in favor of servant which will make this redundant
cookies :: (R.HasCookies r, FromByteString a) => ByteString -> Predicate r P.Error (List1 a)
cookies k r =
  case R.lookupCookie k r of
    [] -> Fail . addLabel "cookie" $ notAvailable k
    cc ->
      case mapMaybe fromByteString cc of
        [] -> (Fail . addLabel "cookie" . typeError k $ "Failed to get zuid cookies")
        (x : xs) -> return $ List1.list1 x xs

notAvailable :: ByteString -> P.Error
notAvailable k = e400 & setReason NotAvailable . setSource k
{-# INLINE notAvailable #-}

typeError :: ByteString -> ByteString -> P.Error
typeError k m = e400 & setReason TypeError . setSource k . setMessage m
{-# INLINE typeError #-}
