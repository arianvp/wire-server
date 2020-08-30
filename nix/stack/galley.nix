{ system
  , compiler
  , flags
  , pkgs
  , hsPkgs
  , pkgconfPkgs
  , errorHandler
  , config
  , ... }:
  {
    flags = { static = false; };
    package = {
      specVersion = "1.12";
      identifier = { name = "galley"; version = "0.83.0"; };
      license = "AGPL-3.0-only";
      copyright = "(c) 2017 Wire Swiss GmbH";
      maintainer = "Wire Swiss GmbH <backend@wire.com>";
      author = "Wire Swiss GmbH";
      homepage = "";
      url = "";
      synopsis = "Conversations";
      description = "";
      buildType = "Simple";
      isLocal = true;
      detailLevel = "FullDetails";
      licenseFiles = [ "LICENSE" ];
      dataDir = "";
      dataFiles = [];
      extraSrcFiles = [];
      extraTmpFiles = [];
      extraDocFiles = [];
      };
    components = {
      "library" = {
        depends = [
          (hsPkgs."HsOpenSSL" or (errorHandler.buildDepError "HsOpenSSL"))
          (hsPkgs."HsOpenSSL-x509-system" or (errorHandler.buildDepError "HsOpenSSL-x509-system"))
          (hsPkgs."QuickCheck" or (errorHandler.buildDepError "QuickCheck"))
          (hsPkgs."aeson" or (errorHandler.buildDepError "aeson"))
          (hsPkgs."amazonka" or (errorHandler.buildDepError "amazonka"))
          (hsPkgs."amazonka-sqs" or (errorHandler.buildDepError "amazonka-sqs"))
          (hsPkgs."async" or (errorHandler.buildDepError "async"))
          (hsPkgs."attoparsec" or (errorHandler.buildDepError "attoparsec"))
          (hsPkgs."base" or (errorHandler.buildDepError "base"))
          (hsPkgs."base64-bytestring" or (errorHandler.buildDepError "base64-bytestring"))
          (hsPkgs."bilge" or (errorHandler.buildDepError "bilge"))
          (hsPkgs."brig-types" or (errorHandler.buildDepError "brig-types"))
          (hsPkgs."bytestring" or (errorHandler.buildDepError "bytestring"))
          (hsPkgs."bytestring-conversion" or (errorHandler.buildDepError "bytestring-conversion"))
          (hsPkgs."case-insensitive" or (errorHandler.buildDepError "case-insensitive"))
          (hsPkgs."cassandra-util" or (errorHandler.buildDepError "cassandra-util"))
          (hsPkgs."cereal" or (errorHandler.buildDepError "cereal"))
          (hsPkgs."containers" or (errorHandler.buildDepError "containers"))
          (hsPkgs."currency-codes" or (errorHandler.buildDepError "currency-codes"))
          (hsPkgs."data-default" or (errorHandler.buildDepError "data-default"))
          (hsPkgs."enclosed-exceptions" or (errorHandler.buildDepError "enclosed-exceptions"))
          (hsPkgs."errors" or (errorHandler.buildDepError "errors"))
          (hsPkgs."exceptions" or (errorHandler.buildDepError "exceptions"))
          (hsPkgs."extended" or (errorHandler.buildDepError "extended"))
          (hsPkgs."extra" or (errorHandler.buildDepError "extra"))
          (hsPkgs."galley-types" or (errorHandler.buildDepError "galley-types"))
          (hsPkgs."gundeck-types" or (errorHandler.buildDepError "gundeck-types"))
          (hsPkgs."http-client" or (errorHandler.buildDepError "http-client"))
          (hsPkgs."http-client-openssl" or (errorHandler.buildDepError "http-client-openssl"))
          (hsPkgs."http-client-tls" or (errorHandler.buildDepError "http-client-tls"))
          (hsPkgs."http-types" or (errorHandler.buildDepError "http-types"))
          (hsPkgs."imports" or (errorHandler.buildDepError "imports"))
          (hsPkgs."insert-ordered-containers" or (errorHandler.buildDepError "insert-ordered-containers"))
          (hsPkgs."lens" or (errorHandler.buildDepError "lens"))
          (hsPkgs."lifted-base" or (errorHandler.buildDepError "lifted-base"))
          (hsPkgs."metrics-wai" or (errorHandler.buildDepError "metrics-wai"))
          (hsPkgs."monad-control" or (errorHandler.buildDepError "monad-control"))
          (hsPkgs."mtl" or (errorHandler.buildDepError "mtl"))
          (hsPkgs."optparse-applicative" or (errorHandler.buildDepError "optparse-applicative"))
          (hsPkgs."pem" or (errorHandler.buildDepError "pem"))
          (hsPkgs."prometheus-client" or (errorHandler.buildDepError "prometheus-client"))
          (hsPkgs."proto-lens" or (errorHandler.buildDepError "proto-lens"))
          (hsPkgs."protobuf" or (errorHandler.buildDepError "protobuf"))
          (hsPkgs."raw-strings-qq" or (errorHandler.buildDepError "raw-strings-qq"))
          (hsPkgs."resourcet" or (errorHandler.buildDepError "resourcet"))
          (hsPkgs."retry" or (errorHandler.buildDepError "retry"))
          (hsPkgs."safe" or (errorHandler.buildDepError "safe"))
          (hsPkgs."safe-exceptions" or (errorHandler.buildDepError "safe-exceptions"))
          (hsPkgs."semigroups" or (errorHandler.buildDepError "semigroups"))
          (hsPkgs."servant" or (errorHandler.buildDepError "servant"))
          (hsPkgs."servant-server" or (errorHandler.buildDepError "servant-server"))
          (hsPkgs."servant-swagger" or (errorHandler.buildDepError "servant-swagger"))
          (hsPkgs."singletons" or (errorHandler.buildDepError "singletons"))
          (hsPkgs."split" or (errorHandler.buildDepError "split"))
          (hsPkgs."ssl-util" or (errorHandler.buildDepError "ssl-util"))
          (hsPkgs."stm" or (errorHandler.buildDepError "stm"))
          (hsPkgs."string-conversions" or (errorHandler.buildDepError "string-conversions"))
          (hsPkgs."swagger" or (errorHandler.buildDepError "swagger"))
          (hsPkgs."swagger2" or (errorHandler.buildDepError "swagger2"))
          (hsPkgs."text" or (errorHandler.buildDepError "text"))
          (hsPkgs."text-format" or (errorHandler.buildDepError "text-format"))
          (hsPkgs."time" or (errorHandler.buildDepError "time"))
          (hsPkgs."tinylog" or (errorHandler.buildDepError "tinylog"))
          (hsPkgs."tls" or (errorHandler.buildDepError "tls"))
          (hsPkgs."transformers" or (errorHandler.buildDepError "transformers"))
          (hsPkgs."transformers-base" or (errorHandler.buildDepError "transformers-base"))
          (hsPkgs."types-common" or (errorHandler.buildDepError "types-common"))
          (hsPkgs."types-common-journal" or (errorHandler.buildDepError "types-common-journal"))
          (hsPkgs."unliftio" or (errorHandler.buildDepError "unliftio"))
          (hsPkgs."unliftio-core" or (errorHandler.buildDepError "unliftio-core"))
          (hsPkgs."unordered-containers" or (errorHandler.buildDepError "unordered-containers"))
          (hsPkgs."uri-bytestring" or (errorHandler.buildDepError "uri-bytestring"))
          (hsPkgs."uuid" or (errorHandler.buildDepError "uuid"))
          (hsPkgs."vector" or (errorHandler.buildDepError "vector"))
          (hsPkgs."wai" or (errorHandler.buildDepError "wai"))
          (hsPkgs."wai-extra" or (errorHandler.buildDepError "wai-extra"))
          (hsPkgs."wai-middleware-gunzip" or (errorHandler.buildDepError "wai-middleware-gunzip"))
          (hsPkgs."wai-predicates" or (errorHandler.buildDepError "wai-predicates"))
          (hsPkgs."wai-routing" or (errorHandler.buildDepError "wai-routing"))
          (hsPkgs."wai-utilities" or (errorHandler.buildDepError "wai-utilities"))
          (hsPkgs."warp" or (errorHandler.buildDepError "warp"))
          (hsPkgs."wire-api" or (errorHandler.buildDepError "wire-api"))
          (hsPkgs."zauth" or (errorHandler.buildDepError "zauth"))
          ];
        buildable = true;
        modules = [
          "Paths_galley"
          "Galley/API"
          "Galley/API/Clients"
          "Galley/API/Create"
          "Galley/API/CustomBackend"
          "Galley/API/Error"
          "Galley/API/IdMapping"
          "Galley/API/Internal"
          "Galley/API/LegalHold"
          "Galley/API/Mapping"
          "Galley/API/Public"
          "Galley/API/Query"
          "Galley/API/Swagger"
          "Galley/API/TeamNotifications"
          "Galley/API/Teams"
          "Galley/API/Update"
          "Galley/API/Util"
          "Galley/App"
          "Galley/Aws"
          "Galley/Data"
          "Galley/Data/CustomBackend"
          "Galley/Data/IdMapping"
          "Galley/Data/Instances"
          "Galley/Data/LegalHold"
          "Galley/Data/Queries"
          "Galley/Data/SearchVisibility"
          "Galley/Data/Services"
          "Galley/Data/TeamFeatures"
          "Galley/Data/TeamNotifications"
          "Galley/Data/Types"
          "Galley/External"
          "Galley/External/LegalHoldService"
          "Galley/Intra/Client"
          "Galley/Intra/IdMapping"
          "Galley/Intra/Journal"
          "Galley/Intra/Push"
          "Galley/Intra/Spar"
          "Galley/Intra/Team"
          "Galley/Intra/User"
          "Galley/Intra/Util"
          "Galley/Options"
          "Galley/Queue"
          "Galley/Run"
          "Galley/Types/Clients"
          "Galley/Validation"
          "Main"
          ];
        hsSourceDirs = [ "src" ];
        };
      exes = {
        "galley" = {
          depends = [
            (hsPkgs."HsOpenSSL" or (errorHandler.buildDepError "HsOpenSSL"))
            (hsPkgs."base" or (errorHandler.buildDepError "base"))
            (hsPkgs."extended" or (errorHandler.buildDepError "extended"))
            (hsPkgs."galley" or (errorHandler.buildDepError "galley"))
            (hsPkgs."galley-types" or (errorHandler.buildDepError "galley-types"))
            (hsPkgs."imports" or (errorHandler.buildDepError "imports"))
            (hsPkgs."raw-strings-qq" or (errorHandler.buildDepError "raw-strings-qq"))
            (hsPkgs."safe" or (errorHandler.buildDepError "safe"))
            (hsPkgs."ssl-util" or (errorHandler.buildDepError "ssl-util"))
            (hsPkgs."types-common" or (errorHandler.buildDepError "types-common"))
            (hsPkgs."wire-api" or (errorHandler.buildDepError "wire-api"))
            ];
          buildable = true;
          modules = [ "Paths_galley" ];
          mainPath = [ "src/Main.hs" ] ++ (pkgs.lib).optional (flags.static) "";
          };
        "galley-integration" = {
          depends = [
            (hsPkgs."HsOpenSSL" or (errorHandler.buildDepError "HsOpenSSL"))
            (hsPkgs."HsOpenSSL-x509-system" or (errorHandler.buildDepError "HsOpenSSL-x509-system"))
            (hsPkgs."QuickCheck" or (errorHandler.buildDepError "QuickCheck"))
            (hsPkgs."aeson" or (errorHandler.buildDepError "aeson"))
            (hsPkgs."aeson-qq" or (errorHandler.buildDepError "aeson-qq"))
            (hsPkgs."amazonka" or (errorHandler.buildDepError "amazonka"))
            (hsPkgs."amazonka-sqs" or (errorHandler.buildDepError "amazonka-sqs"))
            (hsPkgs."async" or (errorHandler.buildDepError "async"))
            (hsPkgs."base" or (errorHandler.buildDepError "base"))
            (hsPkgs."base64-bytestring" or (errorHandler.buildDepError "base64-bytestring"))
            (hsPkgs."bilge" or (errorHandler.buildDepError "bilge"))
            (hsPkgs."brig-types" or (errorHandler.buildDepError "brig-types"))
            (hsPkgs."bytestring" or (errorHandler.buildDepError "bytestring"))
            (hsPkgs."bytestring-conversion" or (errorHandler.buildDepError "bytestring-conversion"))
            (hsPkgs."cassandra-util" or (errorHandler.buildDepError "cassandra-util"))
            (hsPkgs."cereal" or (errorHandler.buildDepError "cereal"))
            (hsPkgs."containers" or (errorHandler.buildDepError "containers"))
            (hsPkgs."cookie" or (errorHandler.buildDepError "cookie"))
            (hsPkgs."currency-codes" or (errorHandler.buildDepError "currency-codes"))
            (hsPkgs."data-default-class" or (errorHandler.buildDepError "data-default-class"))
            (hsPkgs."data-timeout" or (errorHandler.buildDepError "data-timeout"))
            (hsPkgs."errors" or (errorHandler.buildDepError "errors"))
            (hsPkgs."exceptions" or (errorHandler.buildDepError "exceptions"))
            (hsPkgs."extended" or (errorHandler.buildDepError "extended"))
            (hsPkgs."galley" or (errorHandler.buildDepError "galley"))
            (hsPkgs."galley-types" or (errorHandler.buildDepError "galley-types"))
            (hsPkgs."gundeck-types" or (errorHandler.buildDepError "gundeck-types"))
            (hsPkgs."hspec" or (errorHandler.buildDepError "hspec"))
            (hsPkgs."http-client" or (errorHandler.buildDepError "http-client"))
            (hsPkgs."http-client-openssl" or (errorHandler.buildDepError "http-client-openssl"))
            (hsPkgs."http-client-tls" or (errorHandler.buildDepError "http-client-tls"))
            (hsPkgs."http-types" or (errorHandler.buildDepError "http-types"))
            (hsPkgs."imports" or (errorHandler.buildDepError "imports"))
            (hsPkgs."lens" or (errorHandler.buildDepError "lens"))
            (hsPkgs."lens-aeson" or (errorHandler.buildDepError "lens-aeson"))
            (hsPkgs."metrics-wai" or (errorHandler.buildDepError "metrics-wai"))
            (hsPkgs."mtl" or (errorHandler.buildDepError "mtl"))
            (hsPkgs."network" or (errorHandler.buildDepError "network"))
            (hsPkgs."optparse-applicative" or (errorHandler.buildDepError "optparse-applicative"))
            (hsPkgs."pem" or (errorHandler.buildDepError "pem"))
            (hsPkgs."proto-lens" or (errorHandler.buildDepError "proto-lens"))
            (hsPkgs."protobuf" or (errorHandler.buildDepError "protobuf"))
            (hsPkgs."quickcheck-instances" or (errorHandler.buildDepError "quickcheck-instances"))
            (hsPkgs."raw-strings-qq" or (errorHandler.buildDepError "raw-strings-qq"))
            (hsPkgs."retry" or (errorHandler.buildDepError "retry"))
            (hsPkgs."safe" or (errorHandler.buildDepError "safe"))
            (hsPkgs."servant-swagger" or (errorHandler.buildDepError "servant-swagger"))
            (hsPkgs."ssl-util" or (errorHandler.buildDepError "ssl-util"))
            (hsPkgs."string-conversions" or (errorHandler.buildDepError "string-conversions"))
            (hsPkgs."tagged" or (errorHandler.buildDepError "tagged"))
            (hsPkgs."tasty" or (errorHandler.buildDepError "tasty"))
            (hsPkgs."tasty-cannon" or (errorHandler.buildDepError "tasty-cannon"))
            (hsPkgs."tasty-hunit" or (errorHandler.buildDepError "tasty-hunit"))
            (hsPkgs."text" or (errorHandler.buildDepError "text"))
            (hsPkgs."time" or (errorHandler.buildDepError "time"))
            (hsPkgs."tinylog" or (errorHandler.buildDepError "tinylog"))
            (hsPkgs."tls" or (errorHandler.buildDepError "tls"))
            (hsPkgs."transformers" or (errorHandler.buildDepError "transformers"))
            (hsPkgs."types-common" or (errorHandler.buildDepError "types-common"))
            (hsPkgs."types-common-journal" or (errorHandler.buildDepError "types-common-journal"))
            (hsPkgs."unix" or (errorHandler.buildDepError "unix"))
            (hsPkgs."unliftio" or (errorHandler.buildDepError "unliftio"))
            (hsPkgs."unordered-containers" or (errorHandler.buildDepError "unordered-containers"))
            (hsPkgs."uri-bytestring" or (errorHandler.buildDepError "uri-bytestring"))
            (hsPkgs."uuid" or (errorHandler.buildDepError "uuid"))
            (hsPkgs."wai" or (errorHandler.buildDepError "wai"))
            (hsPkgs."wai-extra" or (errorHandler.buildDepError "wai-extra"))
            (hsPkgs."wai-route" or (errorHandler.buildDepError "wai-route"))
            (hsPkgs."wai-utilities" or (errorHandler.buildDepError "wai-utilities"))
            (hsPkgs."warp" or (errorHandler.buildDepError "warp"))
            (hsPkgs."warp-tls" or (errorHandler.buildDepError "warp-tls"))
            (hsPkgs."wire-api" or (errorHandler.buildDepError "wire-api"))
            (hsPkgs."yaml" or (errorHandler.buildDepError "yaml"))
            ];
          buildable = true;
          modules = [
            "API"
            "API/CustomBackend"
            "API/IdMapping"
            "API/MessageTimer"
            "API/Roles"
            "API/SQS"
            "API/Teams"
            "API/Teams/Feature"
            "API/Teams/LegalHold"
            "API/Util"
            "API/Util/TeamFeature"
            "TestHelpers"
            "TestSetup"
            "Paths_galley"
            ];
          hsSourceDirs = [ "test/integration" ];
          mainPath = [ "Main.hs" ];
          };
        "galley-migrate-data" = {
          depends = [
            (hsPkgs."base" or (errorHandler.buildDepError "base"))
            (hsPkgs."cassandra-util" or (errorHandler.buildDepError "cassandra-util"))
            (hsPkgs."conduit" or (errorHandler.buildDepError "conduit"))
            (hsPkgs."containers" or (errorHandler.buildDepError "containers"))
            (hsPkgs."exceptions" or (errorHandler.buildDepError "exceptions"))
            (hsPkgs."extended" or (errorHandler.buildDepError "extended"))
            (hsPkgs."galley-types" or (errorHandler.buildDepError "galley-types"))
            (hsPkgs."imports" or (errorHandler.buildDepError "imports"))
            (hsPkgs."lens" or (errorHandler.buildDepError "lens"))
            (hsPkgs."optparse-applicative" or (errorHandler.buildDepError "optparse-applicative"))
            (hsPkgs."raw-strings-qq" or (errorHandler.buildDepError "raw-strings-qq"))
            (hsPkgs."safe" or (errorHandler.buildDepError "safe"))
            (hsPkgs."ssl-util" or (errorHandler.buildDepError "ssl-util"))
            (hsPkgs."text" or (errorHandler.buildDepError "text"))
            (hsPkgs."time" or (errorHandler.buildDepError "time"))
            (hsPkgs."tinylog" or (errorHandler.buildDepError "tinylog"))
            (hsPkgs."types-common" or (errorHandler.buildDepError "types-common"))
            (hsPkgs."unliftio" or (errorHandler.buildDepError "unliftio"))
            (hsPkgs."wire-api" or (errorHandler.buildDepError "wire-api"))
            ];
          buildable = true;
          modules = [
            "Galley/DataMigration"
            "Galley/DataMigration/Types"
            "V1_BackfillBillingTeamMembers"
            "Paths_galley"
            ];
          hsSourceDirs = [ "migrate-data/src" ];
          mainPath = [ "Main.hs" ] ++ (pkgs.lib).optional (flags.static) "";
          };
        "galley-schema" = {
          depends = [
            (hsPkgs."base" or (errorHandler.buildDepError "base"))
            (hsPkgs."cassandra-util" or (errorHandler.buildDepError "cassandra-util"))
            (hsPkgs."extended" or (errorHandler.buildDepError "extended"))
            (hsPkgs."imports" or (errorHandler.buildDepError "imports"))
            (hsPkgs."optparse-applicative" or (errorHandler.buildDepError "optparse-applicative"))
            (hsPkgs."raw-strings-qq" or (errorHandler.buildDepError "raw-strings-qq"))
            (hsPkgs."safe" or (errorHandler.buildDepError "safe"))
            (hsPkgs."ssl-util" or (errorHandler.buildDepError "ssl-util"))
            (hsPkgs."text" or (errorHandler.buildDepError "text"))
            (hsPkgs."tinylog" or (errorHandler.buildDepError "tinylog"))
            (hsPkgs."wire-api" or (errorHandler.buildDepError "wire-api"))
            ];
          buildable = true;
          modules = [
            "V20"
            "V21"
            "V22"
            "V23"
            "V24"
            "V25"
            "V26"
            "V27"
            "V28"
            "V29"
            "V30"
            "V31"
            "V32"
            "V33"
            "V34"
            "V35"
            "V36"
            "V37"
            "V38_CreateTableBillingTeamMember"
            "V39"
            "V40_CreateTableDataMigration"
            "V41_TeamNotificationQueue"
            "V42_TeamFeatureValidateSamlEmails"
            "V43_TeamFeatureDigitalSignatures"
            "V44_AddRemoteIdentifiers"
            "V45_AddFederationIdMapping"
            "Paths_galley"
            ];
          hsSourceDirs = [ "schema/src" ];
          mainPath = [ "Main.hs" ] ++ (pkgs.lib).optional (flags.static) "";
          };
        };
      tests = {
        "galley-types-tests" = {
          depends = [
            (hsPkgs."base" or (errorHandler.buildDepError "base"))
            (hsPkgs."containers" or (errorHandler.buildDepError "containers"))
            (hsPkgs."extended" or (errorHandler.buildDepError "extended"))
            (hsPkgs."galley" or (errorHandler.buildDepError "galley"))
            (hsPkgs."galley-types" or (errorHandler.buildDepError "galley-types"))
            (hsPkgs."http-types" or (errorHandler.buildDepError "http-types"))
            (hsPkgs."imports" or (errorHandler.buildDepError "imports"))
            (hsPkgs."lens" or (errorHandler.buildDepError "lens"))
            (hsPkgs."raw-strings-qq" or (errorHandler.buildDepError "raw-strings-qq"))
            (hsPkgs."safe" or (errorHandler.buildDepError "safe"))
            (hsPkgs."ssl-util" or (errorHandler.buildDepError "ssl-util"))
            (hsPkgs."tasty" or (errorHandler.buildDepError "tasty"))
            (hsPkgs."tasty-hunit" or (errorHandler.buildDepError "tasty-hunit"))
            (hsPkgs."types-common" or (errorHandler.buildDepError "types-common"))
            (hsPkgs."wai" or (errorHandler.buildDepError "wai"))
            (hsPkgs."wai-predicates" or (errorHandler.buildDepError "wai-predicates"))
            (hsPkgs."wire-api" or (errorHandler.buildDepError "wire-api"))
            ];
          buildable = true;
          modules = [ "Test/Galley/API" "Paths_galley" ];
          hsSourceDirs = [ "test/unit" ];
          mainPath = [ "Main.hs" ];
          };
        };
      };
    } // rec {
    src = (pkgs.lib).mkDefault ./services/galley;
    }