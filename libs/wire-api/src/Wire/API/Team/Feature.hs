{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE StrictData #-}

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

module Wire.API.Team.Feature
  ( TeamFeatureName (..),
    TeamFeatureStatus,
    TeamFeatureAppLockConfig (..),
    TeamFeatureStatusValue (..),
    FeatureHasNoConfig,
    EnforceAppLock (..),
    KnownTeamFeatureName (..),
    TeamFeatureStatusNoConfig (..),
    TeamFeatureStatusWithConfig (..),
    deprecatedFeatureName,
    defaultAppLockStatus,

    -- * Swagger
    typeTeamFeatureName,
    typeTeamFeatureStatusValue,
    modelTeamFeatureStatusNoConfig,
    modelTeamFeatureStatusWithConfig,
    modelTeamFeatureAppLockConfig,
    modelForTeamFeature,
  )
where

import Control.Lens ((.~), (?~))
import Data.Aeson
import qualified Data.Attoparsec.ByteString as Parser
import Data.ByteString.Conversion (FromByteString (..), ToByteString (..), toByteString')
import Data.HashMap.Strict.InsOrd
import Data.Kind (Constraint)
import Data.Proxy
import Data.String.Conversions (cs)
import Data.Swagger hiding (name)
import qualified Data.Swagger.Build.Api as Doc
import Data.Swagger.Declare (Declare)
import qualified Data.Text as T
import qualified Data.Text.Encoding as T
import Deriving.Aeson
import Imports
import Test.QuickCheck.Arbitrary (arbitrary)
import Wire.API.Arbitrary (Arbitrary, GenericUniform (..))

----------------------------------------------------------------------
-- TeamFeatureName

-- | If you add a constructor here, you need to visit (at least) 4 places that are not caught
-- by ghc errors:
--
-- * libs/wire-api/test/unit/Test/Wire/API/Roundtrip/Aeson.hs:198 (calls to 'testRoundTrip')
-- * services/galley/src/Galley/API/Internal.hs:179: (calls to 'mkFeatureGetAndPutRoute')
-- * services/galley/src/Galley/API/Public.hs:465: (calls to 'mkFeatureGetAndPutRoute')
-- * services/galley/src/Galley/API/Teams/Features.hs:106: (calls ot 'getStatus')
--
-- Using something like '[minBound..]' on those expressions would require dependent types.  We
-- could generate exhaustive lists of those calls using TH, along the lines of:
--
-- @
-- forAllTeamFeatureNames ::
--   ExpQ {- [forall (a :: TeamFeatureName). b] -} ->
--   ExpQ {- [b] -}
-- forAllTeamFeatureNames =
--   error
--     "...  and then somehow turn the values from '[minBound..]' into \
--     \type applications in the syntax tree"
-- @
--
-- But that seems excessive.  Let's wait for dependent types to be ready in ghc!
data TeamFeatureName
  = TeamFeatureLegalHold
  | TeamFeatureSSO
  | TeamFeatureSearchVisibility
  | TeamFeatureValidateSAMLEmails
  | TeamFeatureDigitalSignatures
  | TeamFeatureAppLock
  deriving stock (Eq, Show, Ord, Generic, Enum, Bounded, Typeable)
  deriving (Arbitrary) via (GenericUniform TeamFeatureName)

class KnownTeamFeatureName (a :: TeamFeatureName) where
  knownTeamFeatureName :: TeamFeatureName

instance KnownTeamFeatureName 'TeamFeatureLegalHold where knownTeamFeatureName = TeamFeatureLegalHold

instance KnownTeamFeatureName 'TeamFeatureSSO where knownTeamFeatureName = TeamFeatureSSO

instance KnownTeamFeatureName 'TeamFeatureSearchVisibility where knownTeamFeatureName = TeamFeatureSearchVisibility

instance KnownTeamFeatureName 'TeamFeatureValidateSAMLEmails where knownTeamFeatureName = TeamFeatureValidateSAMLEmails

instance KnownTeamFeatureName 'TeamFeatureDigitalSignatures where knownTeamFeatureName = TeamFeatureDigitalSignatures

instance KnownTeamFeatureName 'TeamFeatureAppLock where knownTeamFeatureName = TeamFeatureAppLock

instance FromByteString TeamFeatureName where
  parser =
    Parser.takeByteString >>= \b ->
      case T.decodeUtf8' b of
        Left e -> fail $ "Invalid TeamFeatureName: " <> show e
        Right "legalhold" -> pure TeamFeatureLegalHold
        Right "sso" -> pure TeamFeatureSSO
        Right "searchVisibility" -> pure TeamFeatureSearchVisibility
        Right "search-visibility" -> pure TeamFeatureSearchVisibility
        Right "validateSAMLemails" -> pure TeamFeatureValidateSAMLEmails
        Right "validate-saml-emails" -> pure TeamFeatureValidateSAMLEmails
        Right "digitalSignatures" -> pure TeamFeatureDigitalSignatures
        Right "digital-signatures" -> pure TeamFeatureDigitalSignatures
        Right "appLock" -> pure TeamFeatureAppLock
        Right t -> fail $ "Invalid TeamFeatureName: " <> T.unpack t

instance ToByteString TeamFeatureName where
  builder TeamFeatureLegalHold = "legalhold"
  builder TeamFeatureSSO = "sso"
  builder TeamFeatureSearchVisibility = "searchVisibility"
  builder TeamFeatureValidateSAMLEmails = "validateSAMLemails"
  builder TeamFeatureDigitalSignatures = "digitalSignatures"
  builder TeamFeatureAppLock = "appLock"

deprecatedFeatureName :: TeamFeatureName -> Maybe ByteString
deprecatedFeatureName TeamFeatureSearchVisibility = Just "search-visibility"
deprecatedFeatureName TeamFeatureValidateSAMLEmails = Just "validate-saml-emails"
deprecatedFeatureName TeamFeatureDigitalSignatures = Just "digital-signatures"
deprecatedFeatureName _ = Nothing

typeTeamFeatureName :: Doc.DataType
typeTeamFeatureName = Doc.string . Doc.enum $ cs . toByteString' <$> [(minBound :: TeamFeatureName) ..]

----------------------------------------------------------------------
-- TeamFeatureStatusValue

data TeamFeatureStatusValue
  = TeamFeatureEnabled
  | TeamFeatureDisabled
  deriving stock (Eq, Show, Generic)
  deriving (Arbitrary) via (GenericUniform TeamFeatureStatusValue)

typeTeamFeatureStatusValue :: Doc.DataType
typeTeamFeatureStatusValue =
  Doc.string $
    Doc.enum
      [ "enabled",
        "disabled"
      ]

instance ToJSON TeamFeatureStatusValue where
  toJSON = \case
    TeamFeatureEnabled -> String "enabled"
    TeamFeatureDisabled -> String "disabled"

instance FromJSON TeamFeatureStatusValue where
  parseJSON = withText "TeamFeatureStatusValue" $ \case
    "enabled" -> pure TeamFeatureEnabled
    "disabled" -> pure TeamFeatureDisabled
    x -> fail $ "unexpected status type: " <> T.unpack x

instance ToByteString TeamFeatureStatusValue where
  builder TeamFeatureEnabled = "enabled"
  builder TeamFeatureDisabled = "disabled"

instance FromByteString TeamFeatureStatusValue where
  parser =
    Parser.takeByteString >>= \b ->
      case T.decodeUtf8' b of
        Right "enabled" -> pure TeamFeatureEnabled
        Right "disabled" -> pure TeamFeatureDisabled
        Right t -> fail $ "Invalid TeamFeatureStatusValue: " <> T.unpack t
        Left e -> fail $ "Invalid TeamFeatureStatusValue: " <> show e

----------------------------------------------------------------------
-- TeamFeatureStatus

type family TeamFeatureStatus (a :: TeamFeatureName) :: * where
  TeamFeatureStatus 'TeamFeatureLegalHold = TeamFeatureStatusNoConfig
  TeamFeatureStatus 'TeamFeatureSSO = TeamFeatureStatusNoConfig
  TeamFeatureStatus 'TeamFeatureSearchVisibility = TeamFeatureStatusNoConfig
  TeamFeatureStatus 'TeamFeatureValidateSAMLEmails = TeamFeatureStatusNoConfig
  TeamFeatureStatus 'TeamFeatureDigitalSignatures = TeamFeatureStatusNoConfig
  TeamFeatureStatus 'TeamFeatureAppLock = TeamFeatureStatusWithConfig TeamFeatureAppLockConfig

type FeatureHasNoConfig (a :: TeamFeatureName) = (TeamFeatureStatus a ~ TeamFeatureStatusNoConfig) :: Constraint

-- if you add a new constructor here, don't forget to add it to the swagger (1.2) docs in "Wire.API.Swagger"!
modelForTeamFeature :: TeamFeatureName -> Doc.Model
modelForTeamFeature TeamFeatureLegalHold = modelTeamFeatureStatusNoConfig
modelForTeamFeature TeamFeatureSSO = modelTeamFeatureStatusNoConfig
modelForTeamFeature TeamFeatureSearchVisibility = modelTeamFeatureStatusNoConfig
modelForTeamFeature TeamFeatureValidateSAMLEmails = modelTeamFeatureStatusNoConfig
modelForTeamFeature TeamFeatureDigitalSignatures = modelTeamFeatureStatusNoConfig
modelForTeamFeature name@TeamFeatureAppLock = modelTeamFeatureStatusWithConfig name modelTeamFeatureAppLockConfig

----------------------------------------------------------------------
-- TeamFeatureStatusNoConfig

newtype TeamFeatureStatusNoConfig = TeamFeatureStatusNoConfig
  { tfwoStatus :: TeamFeatureStatusValue
  }
  deriving newtype (Eq, Show, Generic, Typeable, Arbitrary)

modelTeamFeatureStatusNoConfig :: Doc.Model
modelTeamFeatureStatusNoConfig = Doc.defineModel "TeamFeatureStatusNoConfig" $ do
  Doc.description $ "Configuration for a team feature that has no configuration"
  Doc.property "status" typeTeamFeatureStatusValue $ Doc.description "status"

declareNamedSchemaFeatureNoConfig :: f -> Declare (Definitions Schema) NamedSchema
declareNamedSchemaFeatureNoConfig _ =
  pure $
    NamedSchema (Just "TeamFeatureStatus") $
      mempty
        & properties .~ (fromList [("status", Inline statusValue)])
        & required .~ ["status"]
        & type_ ?~ SwaggerObject
        & description ?~ "whether a given team feature is enabled"
  where
    statusValue =
      mempty
        & enum_ ?~ [String "enabled", String "disabled"]

instance ToSchema TeamFeatureStatusNoConfig where
  declareNamedSchema = declareNamedSchemaFeatureNoConfig

instance FromJSON TeamFeatureStatusNoConfig where
  parseJSON = withObject "TeamFeatureStatus" $ \ob ->
    TeamFeatureStatusNoConfig <$> ob .: "status"

instance ToJSON TeamFeatureStatusNoConfig where
  toJSON (TeamFeatureStatusNoConfig status) = object ["status" .= status]

----------------------------------------------------------------------
-- TeamFeatureStatusWithConfig

data TeamFeatureStatusWithConfig (cfg :: *) = TeamFeatureStatusWithConfig
  { tfwcStatus :: TeamFeatureStatusValue,
    tfwcConfig :: cfg
  }
  deriving stock (Eq, Show, Generic, Typeable)

instance Arbitrary cfg => Arbitrary (TeamFeatureStatusWithConfig cfg) where
  arbitrary = TeamFeatureStatusWithConfig <$> arbitrary <*> arbitrary

modelTeamFeatureStatusWithConfig :: TeamFeatureName -> Doc.Model -> Doc.Model
modelTeamFeatureStatusWithConfig name cfgModel = Doc.defineModel (cs $ show name) $ do
  Doc.description $ "Status and config of " <> (cs $ show name)
  Doc.property "status" typeTeamFeatureStatusValue $ Doc.description "status"
  Doc.property "config" (Doc.ref cfgModel) $ Doc.description "config"

instance FromJSON cfg => FromJSON (TeamFeatureStatusWithConfig cfg) where
  parseJSON = withObject "TeamFeatureStatus" $ \ob ->
    TeamFeatureStatusWithConfig <$> ob .: "status" <*> ob .: "config"

instance ToJSON cfg => ToJSON (TeamFeatureStatusWithConfig cfg) where
  toJSON (TeamFeatureStatusWithConfig status config) = object ["status" .= status, "config" .= config]

----------------------------------------------------------------------
-- TeamFeatureAppLockConfig

data TeamFeatureAppLockConfig = TeamFeatureAppLockConfig
  { applockEnforceAppLock :: EnforceAppLock,
    applockInactivityTimeoutSecs :: Int32
  }
  deriving stock (Eq, Show, Generic)

deriving via (GenericUniform TeamFeatureAppLockConfig) instance Arbitrary TeamFeatureAppLockConfig

-- (we're still using the swagger1.2 swagger for this, but let's just keep it around, we may use it later.)
instance ToSchema TeamFeatureAppLockConfig where
  declareNamedSchema _ =
    pure $
      NamedSchema (Just "TeamFeatureAppLockConfig") $
        mempty
          & type_ .~ Just SwaggerObject
          & properties .~ configProperties
          & required .~ ["enforceAppLock", "inactivityTimeoutSecs"]
    where
      configProperties :: InsOrdHashMap Text (Referenced Schema)
      configProperties =
        fromList
          [ ("enforceAppLock", Inline (toSchema (Proxy @Bool))),
            ("inactivityTimeoutSecs", Inline (toSchema (Proxy @Int)))
          ]

newtype EnforceAppLock = EnforceAppLock Bool
  deriving stock (Eq, Show, Ord, Generic)
  deriving newtype (FromJSON, ToJSON, Arbitrary)

modelTeamFeatureAppLockConfig :: Doc.Model
modelTeamFeatureAppLockConfig =
  Doc.defineModel "TeamFeatureAppLockConfig" $ do
    Doc.property "enforceAppLock" Doc.bool' $ Doc.description "enforceAppLock"
    Doc.property "inactivityTimeoutSecs" Doc.int32' $ Doc.description ""

deriving via
  (StripCamel "applock" TeamFeatureAppLockConfig)
  instance
    ToJSON TeamFeatureAppLockConfig

deriving via
  (StripCamel "applock" TeamFeatureAppLockConfig)
  instance
    FromJSON TeamFeatureAppLockConfig

defaultAppLockStatus :: TeamFeatureStatusWithConfig TeamFeatureAppLockConfig
defaultAppLockStatus =
  TeamFeatureStatusWithConfig
    TeamFeatureEnabled
    (TeamFeatureAppLockConfig (EnforceAppLock False) 60)

----------------------------------------------------------------------
-- internal

data LowerCaseFirst

instance StringModifier LowerCaseFirst where
  getStringModifier (x : xs) = toLower x : xs
  getStringModifier [] = []

type StripCamel str =
  CustomJSON
    '[FieldLabelModifier (StripPrefix str, LowerCaseFirst)]
