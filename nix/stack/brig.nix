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
    flags = {};
    package = {
      specVersion = "1.12";
      identifier = { name = "brig"; version = "1.35.0"; };
      license = "AGPL-3.0-only";
      copyright = "(c) 2017 Wire Swiss GmbH";
      maintainer = "Wire Swiss GmbH <backend@wire.com>";
      author = "Wire Swiss GmbH";
      homepage = "";
      url = "";
      synopsis = "User Service";
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
          (hsPkgs."HaskellNet" or (errorHandler.buildDepError "HaskellNet"))
          (hsPkgs."HaskellNet-SSL" or (errorHandler.buildDepError "HaskellNet-SSL"))
          (hsPkgs."HsOpenSSL" or (errorHandler.buildDepError "HsOpenSSL"))
          (hsPkgs."HsOpenSSL-x509-system" or (errorHandler.buildDepError "HsOpenSSL-x509-system"))
          (hsPkgs."MonadRandom" or (errorHandler.buildDepError "MonadRandom"))
          (hsPkgs."aeson" or (errorHandler.buildDepError "aeson"))
          (hsPkgs."amazonka" or (errorHandler.buildDepError "amazonka"))
          (hsPkgs."amazonka-dynamodb" or (errorHandler.buildDepError "amazonka-dynamodb"))
          (hsPkgs."amazonka-ses" or (errorHandler.buildDepError "amazonka-ses"))
          (hsPkgs."amazonka-sns" or (errorHandler.buildDepError "amazonka-sns"))
          (hsPkgs."amazonka-sqs" or (errorHandler.buildDepError "amazonka-sqs"))
          (hsPkgs."async" or (errorHandler.buildDepError "async"))
          (hsPkgs."attoparsec" or (errorHandler.buildDepError "attoparsec"))
          (hsPkgs."auto-update" or (errorHandler.buildDepError "auto-update"))
          (hsPkgs."base" or (errorHandler.buildDepError "base"))
          (hsPkgs."base-prelude" or (errorHandler.buildDepError "base-prelude"))
          (hsPkgs."base16-bytestring" or (errorHandler.buildDepError "base16-bytestring"))
          (hsPkgs."base64-bytestring" or (errorHandler.buildDepError "base64-bytestring"))
          (hsPkgs."bilge" or (errorHandler.buildDepError "bilge"))
          (hsPkgs."bloodhound" or (errorHandler.buildDepError "bloodhound"))
          (hsPkgs."brig-types" or (errorHandler.buildDepError "brig-types"))
          (hsPkgs."bytestring" or (errorHandler.buildDepError "bytestring"))
          (hsPkgs."bytestring-conversion" or (errorHandler.buildDepError "bytestring-conversion"))
          (hsPkgs."cassandra-util" or (errorHandler.buildDepError "cassandra-util"))
          (hsPkgs."conduit" or (errorHandler.buildDepError "conduit"))
          (hsPkgs."containers" or (errorHandler.buildDepError "containers"))
          (hsPkgs."cookie" or (errorHandler.buildDepError "cookie"))
          (hsPkgs."cryptobox-haskell" or (errorHandler.buildDepError "cryptobox-haskell"))
          (hsPkgs."currency-codes" or (errorHandler.buildDepError "currency-codes"))
          (hsPkgs."data-default" or (errorHandler.buildDepError "data-default"))
          (hsPkgs."data-timeout" or (errorHandler.buildDepError "data-timeout"))
          (hsPkgs."directory" or (errorHandler.buildDepError "directory"))
          (hsPkgs."dns" or (errorHandler.buildDepError "dns"))
          (hsPkgs."dns-util" or (errorHandler.buildDepError "dns-util"))
          (hsPkgs."either" or (errorHandler.buildDepError "either"))
          (hsPkgs."enclosed-exceptions" or (errorHandler.buildDepError "enclosed-exceptions"))
          (hsPkgs."errors" or (errorHandler.buildDepError "errors"))
          (hsPkgs."exceptions" or (errorHandler.buildDepError "exceptions"))
          (hsPkgs."extended" or (errorHandler.buildDepError "extended"))
          (hsPkgs."extra" or (errorHandler.buildDepError "extra"))
          (hsPkgs."filepath" or (errorHandler.buildDepError "filepath"))
          (hsPkgs."fsnotify" or (errorHandler.buildDepError "fsnotify"))
          (hsPkgs."galley-types" or (errorHandler.buildDepError "galley-types"))
          (hsPkgs."geoip2" or (errorHandler.buildDepError "geoip2"))
          (hsPkgs."gundeck-types" or (errorHandler.buildDepError "gundeck-types"))
          (hsPkgs."hashable" or (errorHandler.buildDepError "hashable"))
          (hsPkgs."html-entities" or (errorHandler.buildDepError "html-entities"))
          (hsPkgs."http-client" or (errorHandler.buildDepError "http-client"))
          (hsPkgs."http-client-openssl" or (errorHandler.buildDepError "http-client-openssl"))
          (hsPkgs."http-types" or (errorHandler.buildDepError "http-types"))
          (hsPkgs."imports" or (errorHandler.buildDepError "imports"))
          (hsPkgs."iproute" or (errorHandler.buildDepError "iproute"))
          (hsPkgs."iso639" or (errorHandler.buildDepError "iso639"))
          (hsPkgs."lens" or (errorHandler.buildDepError "lens"))
          (hsPkgs."lens-aeson" or (errorHandler.buildDepError "lens-aeson"))
          (hsPkgs."lifted-base" or (errorHandler.buildDepError "lifted-base"))
          (hsPkgs."metrics-core" or (errorHandler.buildDepError "metrics-core"))
          (hsPkgs."metrics-wai" or (errorHandler.buildDepError "metrics-wai"))
          (hsPkgs."mime" or (errorHandler.buildDepError "mime"))
          (hsPkgs."mime-mail" or (errorHandler.buildDepError "mime-mail"))
          (hsPkgs."monad-control" or (errorHandler.buildDepError "monad-control"))
          (hsPkgs."mtl" or (errorHandler.buildDepError "mtl"))
          (hsPkgs."multihash" or (errorHandler.buildDepError "multihash"))
          (hsPkgs."mwc-random" or (errorHandler.buildDepError "mwc-random"))
          (hsPkgs."network" or (errorHandler.buildDepError "network"))
          (hsPkgs."network-conduit-tls" or (errorHandler.buildDepError "network-conduit-tls"))
          (hsPkgs."network-uri" or (errorHandler.buildDepError "network-uri"))
          (hsPkgs."optparse-applicative" or (errorHandler.buildDepError "optparse-applicative"))
          (hsPkgs."pem" or (errorHandler.buildDepError "pem"))
          (hsPkgs."polysemy" or (errorHandler.buildDepError "polysemy"))
          (hsPkgs."prometheus-client" or (errorHandler.buildDepError "prometheus-client"))
          (hsPkgs."proto-lens" or (errorHandler.buildDepError "proto-lens"))
          (hsPkgs."random-shuffle" or (errorHandler.buildDepError "random-shuffle"))
          (hsPkgs."resource-pool" or (errorHandler.buildDepError "resource-pool"))
          (hsPkgs."resourcet" or (errorHandler.buildDepError "resourcet"))
          (hsPkgs."retry" or (errorHandler.buildDepError "retry"))
          (hsPkgs."ropes" or (errorHandler.buildDepError "ropes"))
          (hsPkgs."safe" or (errorHandler.buildDepError "safe"))
          (hsPkgs."scientific" or (errorHandler.buildDepError "scientific"))
          (hsPkgs."scrypt" or (errorHandler.buildDepError "scrypt"))
          (hsPkgs."semigroups" or (errorHandler.buildDepError "semigroups"))
          (hsPkgs."singletons" or (errorHandler.buildDepError "singletons"))
          (hsPkgs."smtp-mail" or (errorHandler.buildDepError "smtp-mail"))
          (hsPkgs."sodium-crypto-sign" or (errorHandler.buildDepError "sodium-crypto-sign"))
          (hsPkgs."split" or (errorHandler.buildDepError "split"))
          (hsPkgs."ssl-util" or (errorHandler.buildDepError "ssl-util"))
          (hsPkgs."statistics" or (errorHandler.buildDepError "statistics"))
          (hsPkgs."stomp-queue" or (errorHandler.buildDepError "stomp-queue"))
          (hsPkgs."string-conversions" or (errorHandler.buildDepError "string-conversions"))
          (hsPkgs."swagger" or (errorHandler.buildDepError "swagger"))
          (hsPkgs."tagged" or (errorHandler.buildDepError "tagged"))
          (hsPkgs."template" or (errorHandler.buildDepError "template"))
          (hsPkgs."text" or (errorHandler.buildDepError "text"))
          (hsPkgs."text-icu-translit" or (errorHandler.buildDepError "text-icu-translit"))
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
          (hsPkgs."vault" or (errorHandler.buildDepError "vault"))
          (hsPkgs."vector" or (errorHandler.buildDepError "vector"))
          (hsPkgs."wai" or (errorHandler.buildDepError "wai"))
          (hsPkgs."wai-extra" or (errorHandler.buildDepError "wai-extra"))
          (hsPkgs."wai-middleware-gunzip" or (errorHandler.buildDepError "wai-middleware-gunzip"))
          (hsPkgs."wai-predicates" or (errorHandler.buildDepError "wai-predicates"))
          (hsPkgs."wai-routing" or (errorHandler.buildDepError "wai-routing"))
          (hsPkgs."wai-utilities" or (errorHandler.buildDepError "wai-utilities"))
          (hsPkgs."warp" or (errorHandler.buildDepError "warp"))
          (hsPkgs."wire-api" or (errorHandler.buildDepError "wire-api"))
          (hsPkgs."yaml" or (errorHandler.buildDepError "yaml"))
          (hsPkgs."zauth" or (errorHandler.buildDepError "zauth"))
          ];
        buildable = true;
        modules = [
          "Paths_brig"
          "Brig/API"
          "Brig/API/Client"
          "Brig/API/Connection"
          "Brig/API/Error"
          "Brig/API/Handler"
          "Brig/API/IdMapping"
          "Brig/API/Internal"
          "Brig/API/Properties"
          "Brig/API/Public"
          "Brig/API/Types"
          "Brig/API/User"
          "Brig/API/Util"
          "Brig/App"
          "Brig/AWS"
          "Brig/AWS/SesNotification"
          "Brig/AWS/Types"
          "Brig/Budget"
          "Brig/Calling"
          "Brig/Calling/API"
          "Brig/Calling/Internal"
          "Brig/Code"
          "Brig/Data/Activation"
          "Brig/Data/Blacklist"
          "Brig/Data/Client"
          "Brig/Data/Connection"
          "Brig/Data/IdMapping"
          "Brig/Data/Instances"
          "Brig/Data/LoginCode"
          "Brig/Data/PasswordReset"
          "Brig/Data/Properties"
          "Brig/Data/Types"
          "Brig/Data/User"
          "Brig/Data/UserKey"
          "Brig/Email"
          "Brig/Index/Eval"
          "Brig/Index/Migrations"
          "Brig/Index/Migrations/Types"
          "Brig/Index/Options"
          "Brig/InternalEvent/Process"
          "Brig/InternalEvent/Types"
          "Brig/IO/Intra"
          "Brig/IO/Intra/IdMapping"
          "Brig/IO/Journal"
          "Brig/Locale"
          "Brig/Options"
          "Brig/Password"
          "Brig/Phone"
          "Brig/PolyLog"
          "Brig/Provider/API"
          "Brig/Provider/DB"
          "Brig/Provider/Email"
          "Brig/Provider/RPC"
          "Brig/Provider/Template"
          "Brig/Queue"
          "Brig/Queue/Stomp"
          "Brig/Queue/Types"
          "Brig/RPC"
          "Brig/Run"
          "Brig/SMTP"
          "Brig/Team/API"
          "Brig/Team/DB"
          "Brig/Team/Email"
          "Brig/Team/Template"
          "Brig/Team/Util"
          "Brig/Template"
          "Brig/Unique"
          "Brig/User/API/Auth"
          "Brig/User/API/Search"
          "Brig/User/Auth"
          "Brig/User/Auth/Cookie"
          "Brig/User/Auth/Cookie/Limit"
          "Brig/User/Auth/DB/Cookie"
          "Brig/User/Auth/DB/Instances"
          "Brig/User/Email"
          "Brig/User/Event"
          "Brig/User/Event/Log"
          "Brig/User/Handle"
          "Brig/User/Handle/Blacklist"
          "Brig/User/Phone"
          "Brig/User/Search/Index"
          "Brig/User/Search/Index/Types"
          "Brig/User/Template"
          "Brig/Whitelist"
          "Brig/ZAuth"
          "Main"
          ];
        hsSourceDirs = [ "src" ];
        };
      exes = {
        "brig" = {
          depends = [
            (hsPkgs."HsOpenSSL" or (errorHandler.buildDepError "HsOpenSSL"))
            (hsPkgs."base" or (errorHandler.buildDepError "base"))
            (hsPkgs."brig" or (errorHandler.buildDepError "brig"))
            (hsPkgs."directory" or (errorHandler.buildDepError "directory"))
            (hsPkgs."imports" or (errorHandler.buildDepError "imports"))
            (hsPkgs."optparse-applicative" or (errorHandler.buildDepError "optparse-applicative"))
            (hsPkgs."types-common" or (errorHandler.buildDepError "types-common"))
            ];
          buildable = true;
          modules = [ "Paths_brig" ];
          mainPath = [ "src/Main.hs" ];
          };
        "brig-index" = {
          depends = [
            (hsPkgs."base" or (errorHandler.buildDepError "base"))
            (hsPkgs."brig" or (errorHandler.buildDepError "brig"))
            (hsPkgs."imports" or (errorHandler.buildDepError "imports"))
            (hsPkgs."optparse-applicative" or (errorHandler.buildDepError "optparse-applicative"))
            (hsPkgs."tinylog" or (errorHandler.buildDepError "tinylog"))
            ];
          buildable = true;
          modules = [ "Paths_brig" ];
          mainPath = [ "index/src/Main.hs" ];
          };
        "brig-integration" = {
          depends = [
            (hsPkgs."HsOpenSSL" or (errorHandler.buildDepError "HsOpenSSL"))
            (hsPkgs."aeson" or (errorHandler.buildDepError "aeson"))
            (hsPkgs."async" or (errorHandler.buildDepError "async"))
            (hsPkgs."attoparsec" or (errorHandler.buildDepError "attoparsec"))
            (hsPkgs."base" or (errorHandler.buildDepError "base"))
            (hsPkgs."bilge" or (errorHandler.buildDepError "bilge"))
            (hsPkgs."bloodhound" or (errorHandler.buildDepError "bloodhound"))
            (hsPkgs."brig" or (errorHandler.buildDepError "brig"))
            (hsPkgs."brig-types" or (errorHandler.buildDepError "brig-types"))
            (hsPkgs."bytestring" or (errorHandler.buildDepError "bytestring"))
            (hsPkgs."bytestring-conversion" or (errorHandler.buildDepError "bytestring-conversion"))
            (hsPkgs."cargohold-types" or (errorHandler.buildDepError "cargohold-types"))
            (hsPkgs."case-insensitive" or (errorHandler.buildDepError "case-insensitive"))
            (hsPkgs."cassandra-util" or (errorHandler.buildDepError "cassandra-util"))
            (hsPkgs."containers" or (errorHandler.buildDepError "containers"))
            (hsPkgs."cookie" or (errorHandler.buildDepError "cookie"))
            (hsPkgs."data-timeout" or (errorHandler.buildDepError "data-timeout"))
            (hsPkgs."exceptions" or (errorHandler.buildDepError "exceptions"))
            (hsPkgs."extra" or (errorHandler.buildDepError "extra"))
            (hsPkgs."filepath" or (errorHandler.buildDepError "filepath"))
            (hsPkgs."galley-types" or (errorHandler.buildDepError "galley-types"))
            (hsPkgs."gundeck-types" or (errorHandler.buildDepError "gundeck-types"))
            (hsPkgs."http-client" or (errorHandler.buildDepError "http-client"))
            (hsPkgs."http-client-tls" or (errorHandler.buildDepError "http-client-tls"))
            (hsPkgs."http-types" or (errorHandler.buildDepError "http-types"))
            (hsPkgs."imports" or (errorHandler.buildDepError "imports"))
            (hsPkgs."lens" or (errorHandler.buildDepError "lens"))
            (hsPkgs."lens-aeson" or (errorHandler.buildDepError "lens-aeson"))
            (hsPkgs."metrics-wai" or (errorHandler.buildDepError "metrics-wai"))
            (hsPkgs."mime" or (errorHandler.buildDepError "mime"))
            (hsPkgs."network" or (errorHandler.buildDepError "network"))
            (hsPkgs."options" or (errorHandler.buildDepError "options"))
            (hsPkgs."optparse-applicative" or (errorHandler.buildDepError "optparse-applicative"))
            (hsPkgs."pem" or (errorHandler.buildDepError "pem"))
            (hsPkgs."proto-lens" or (errorHandler.buildDepError "proto-lens"))
            (hsPkgs."random" or (errorHandler.buildDepError "random"))
            (hsPkgs."retry" or (errorHandler.buildDepError "retry"))
            (hsPkgs."safe" or (errorHandler.buildDepError "safe"))
            (hsPkgs."semigroups" or (errorHandler.buildDepError "semigroups"))
            (hsPkgs."string-conversions" or (errorHandler.buildDepError "string-conversions"))
            (hsPkgs."tasty" or (errorHandler.buildDepError "tasty"))
            (hsPkgs."tasty-cannon" or (errorHandler.buildDepError "tasty-cannon"))
            (hsPkgs."tasty-hunit" or (errorHandler.buildDepError "tasty-hunit"))
            (hsPkgs."temporary" or (errorHandler.buildDepError "temporary"))
            (hsPkgs."text" or (errorHandler.buildDepError "text"))
            (hsPkgs."time" or (errorHandler.buildDepError "time"))
            (hsPkgs."tinylog" or (errorHandler.buildDepError "tinylog"))
            (hsPkgs."types-common" or (errorHandler.buildDepError "types-common"))
            (hsPkgs."types-common-aws" or (errorHandler.buildDepError "types-common-aws"))
            (hsPkgs."types-common-journal" or (errorHandler.buildDepError "types-common-journal"))
            (hsPkgs."unix" or (errorHandler.buildDepError "unix"))
            (hsPkgs."unliftio" or (errorHandler.buildDepError "unliftio"))
            (hsPkgs."unordered-containers" or (errorHandler.buildDepError "unordered-containers"))
            (hsPkgs."uri-bytestring" or (errorHandler.buildDepError "uri-bytestring"))
            (hsPkgs."uuid" or (errorHandler.buildDepError "uuid"))
            (hsPkgs."vector" or (errorHandler.buildDepError "vector"))
            (hsPkgs."wai" or (errorHandler.buildDepError "wai"))
            (hsPkgs."wai-extra" or (errorHandler.buildDepError "wai-extra"))
            (hsPkgs."wai-route" or (errorHandler.buildDepError "wai-route"))
            (hsPkgs."wai-utilities" or (errorHandler.buildDepError "wai-utilities"))
            (hsPkgs."warp" or (errorHandler.buildDepError "warp"))
            (hsPkgs."warp-tls" or (errorHandler.buildDepError "warp-tls"))
            (hsPkgs."wire-api" or (errorHandler.buildDepError "wire-api"))
            (hsPkgs."yaml" or (errorHandler.buildDepError "yaml"))
            (hsPkgs."zauth" or (errorHandler.buildDepError "zauth"))
            ];
          buildable = true;
          modules = [
            "API/Calling"
            "API/IdMapping"
            "API/Metrics"
            "API/Provider"
            "API/RichInfo/Util"
            "API/Search"
            "API/Search/Util"
            "API/Settings"
            "API/Team"
            "API/Team/Util"
            "API/User"
            "API/User/Account"
            "API/User/Auth"
            "API/User/Client"
            "API/User/Connection"
            "API/User/Handles"
            "API/User/PasswordReset"
            "API/User/Property"
            "API/User/RichInfo"
            "API/User/Util"
            "Index/Create"
            "Util"
            "Util/AWS"
            "Paths_brig"
            ];
          hsSourceDirs = [ "test/integration" ];
          mainPath = [ "Main.hs" ];
          };
        "brig-schema" = {
          depends = [
            (hsPkgs."base" or (errorHandler.buildDepError "base"))
            (hsPkgs."cassandra-util" or (errorHandler.buildDepError "cassandra-util"))
            (hsPkgs."directory" or (errorHandler.buildDepError "directory"))
            (hsPkgs."extended" or (errorHandler.buildDepError "extended"))
            (hsPkgs."imports" or (errorHandler.buildDepError "imports"))
            (hsPkgs."optparse-applicative" or (errorHandler.buildDepError "optparse-applicative"))
            (hsPkgs."raw-strings-qq" or (errorHandler.buildDepError "raw-strings-qq"))
            (hsPkgs."text" or (errorHandler.buildDepError "text"))
            (hsPkgs."tinylog" or (errorHandler.buildDepError "tinylog"))
            (hsPkgs."types-common" or (errorHandler.buildDepError "types-common"))
            ];
          buildable = true;
          modules = [
            "V10"
            "V11"
            "V12"
            "V13"
            "V14"
            "V15"
            "V16"
            "V17"
            "V18"
            "V19"
            "V20"
            "V21"
            "V22"
            "V23"
            "V24"
            "V25"
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
            "V38"
            "V39"
            "V40"
            "V41"
            "V42"
            "V43"
            "V44"
            "V45"
            "V46"
            "V47"
            "V48"
            "V49"
            "V50"
            "V51"
            "V52"
            "V53"
            "V54"
            "V55"
            "V56"
            "V57"
            "V58"
            "V59"
            "V60_AddFederationIdMapping"
            "V61_team_invitation_email"
            "V9"
            "Paths_brig"
            ];
          hsSourceDirs = [ "schema/src" ];
          mainPath = [ "Main.hs" ];
          };
        };
      tests = {
        "brig-tests" = {
          depends = [
            (hsPkgs."aeson" or (errorHandler.buildDepError "aeson"))
            (hsPkgs."base" or (errorHandler.buildDepError "base"))
            (hsPkgs."bloodhound" or (errorHandler.buildDepError "bloodhound"))
            (hsPkgs."brig" or (errorHandler.buildDepError "brig"))
            (hsPkgs."brig-types" or (errorHandler.buildDepError "brig-types"))
            (hsPkgs."dns" or (errorHandler.buildDepError "dns"))
            (hsPkgs."dns-util" or (errorHandler.buildDepError "dns-util"))
            (hsPkgs."imports" or (errorHandler.buildDepError "imports"))
            (hsPkgs."polysemy" or (errorHandler.buildDepError "polysemy"))
            (hsPkgs."retry" or (errorHandler.buildDepError "retry"))
            (hsPkgs."tasty" or (errorHandler.buildDepError "tasty"))
            (hsPkgs."tasty-hunit" or (errorHandler.buildDepError "tasty-hunit"))
            (hsPkgs."tinylog" or (errorHandler.buildDepError "tinylog"))
            (hsPkgs."types-common" or (errorHandler.buildDepError "types-common"))
            (hsPkgs."unliftio" or (errorHandler.buildDepError "unliftio"))
            (hsPkgs."uri-bytestring" or (errorHandler.buildDepError "uri-bytestring"))
            (hsPkgs."uuid" or (errorHandler.buildDepError "uuid"))
            (hsPkgs."wire-api" or (errorHandler.buildDepError "wire-api"))
            ];
          buildable = true;
          modules = [
            "Test/Brig/Calling"
            "Test/Brig/Calling/Internal"
            "Test/Brig/User/Search/Index/Types"
            "Paths_brig"
            ];
          hsSourceDirs = [ "test/unit" ];
          mainPath = [ "Main.hs" ];
          };
        };
      };
    } // rec {
    src = (pkgs.lib).mkDefault ./services/brig;
    }