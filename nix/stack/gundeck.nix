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
      identifier = { name = "gundeck"; version = "1.45.0"; };
      license = "AGPL-3.0-only";
      copyright = "(c) 2017 Wire Swiss GmbH";
      maintainer = "Wire Swiss GmbH <backend@wire.com>";
      author = "Wire Swiss GmbH";
      homepage = "";
      url = "";
      synopsis = "Push Notification Hub";
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
          (hsPkgs."aeson" or (errorHandler.buildDepError "aeson"))
          (hsPkgs."amazonka" or (errorHandler.buildDepError "amazonka"))
          (hsPkgs."amazonka-sns" or (errorHandler.buildDepError "amazonka-sns"))
          (hsPkgs."amazonka-sqs" or (errorHandler.buildDepError "amazonka-sqs"))
          (hsPkgs."async" or (errorHandler.buildDepError "async"))
          (hsPkgs."attoparsec" or (errorHandler.buildDepError "attoparsec"))
          (hsPkgs."auto-update" or (errorHandler.buildDepError "auto-update"))
          (hsPkgs."base" or (errorHandler.buildDepError "base"))
          (hsPkgs."base64-bytestring" or (errorHandler.buildDepError "base64-bytestring"))
          (hsPkgs."bilge" or (errorHandler.buildDepError "bilge"))
          (hsPkgs."bytestring" or (errorHandler.buildDepError "bytestring"))
          (hsPkgs."bytestring-conversion" or (errorHandler.buildDepError "bytestring-conversion"))
          (hsPkgs."case-insensitive" or (errorHandler.buildDepError "case-insensitive"))
          (hsPkgs."cassandra-util" or (errorHandler.buildDepError "cassandra-util"))
          (hsPkgs."conduit" or (errorHandler.buildDepError "conduit"))
          (hsPkgs."containers" or (errorHandler.buildDepError "containers"))
          (hsPkgs."data-default" or (errorHandler.buildDepError "data-default"))
          (hsPkgs."enclosed-exceptions" or (errorHandler.buildDepError "enclosed-exceptions"))
          (hsPkgs."errors" or (errorHandler.buildDepError "errors"))
          (hsPkgs."exceptions" or (errorHandler.buildDepError "exceptions"))
          (hsPkgs."extended" or (errorHandler.buildDepError "extended"))
          (hsPkgs."extra" or (errorHandler.buildDepError "extra"))
          (hsPkgs."gundeck-types" or (errorHandler.buildDepError "gundeck-types"))
          (hsPkgs."http-client" or (errorHandler.buildDepError "http-client"))
          (hsPkgs."http-client-tls" or (errorHandler.buildDepError "http-client-tls"))
          (hsPkgs."http-types" or (errorHandler.buildDepError "http-types"))
          (hsPkgs."imports" or (errorHandler.buildDepError "imports"))
          (hsPkgs."lens" or (errorHandler.buildDepError "lens"))
          (hsPkgs."lens-aeson" or (errorHandler.buildDepError "lens-aeson"))
          (hsPkgs."lifted-base" or (errorHandler.buildDepError "lifted-base"))
          (hsPkgs."metrics-core" or (errorHandler.buildDepError "metrics-core"))
          (hsPkgs."metrics-wai" or (errorHandler.buildDepError "metrics-wai"))
          (hsPkgs."monad-control" or (errorHandler.buildDepError "monad-control"))
          (hsPkgs."mtl" or (errorHandler.buildDepError "mtl"))
          (hsPkgs."network-uri" or (errorHandler.buildDepError "network-uri"))
          (hsPkgs."optparse-applicative" or (errorHandler.buildDepError "optparse-applicative"))
          (hsPkgs."prometheus-client" or (errorHandler.buildDepError "prometheus-client"))
          (hsPkgs."psqueues" or (errorHandler.buildDepError "psqueues"))
          (hsPkgs."redis-io" or (errorHandler.buildDepError "redis-io"))
          (hsPkgs."resourcet" or (errorHandler.buildDepError "resourcet"))
          (hsPkgs."retry" or (errorHandler.buildDepError "retry"))
          (hsPkgs."safe-exceptions" or (errorHandler.buildDepError "safe-exceptions"))
          (hsPkgs."semigroups" or (errorHandler.buildDepError "semigroups"))
          (hsPkgs."singletons" or (errorHandler.buildDepError "singletons"))
          (hsPkgs."split" or (errorHandler.buildDepError "split"))
          (hsPkgs."swagger" or (errorHandler.buildDepError "swagger"))
          (hsPkgs."text" or (errorHandler.buildDepError "text"))
          (hsPkgs."text-format" or (errorHandler.buildDepError "text-format"))
          (hsPkgs."time" or (errorHandler.buildDepError "time"))
          (hsPkgs."tinylog" or (errorHandler.buildDepError "tinylog"))
          (hsPkgs."tls" or (errorHandler.buildDepError "tls"))
          (hsPkgs."transformers" or (errorHandler.buildDepError "transformers"))
          (hsPkgs."transformers-base" or (errorHandler.buildDepError "transformers-base"))
          (hsPkgs."types-common" or (errorHandler.buildDepError "types-common"))
          (hsPkgs."unliftio" or (errorHandler.buildDepError "unliftio"))
          (hsPkgs."unliftio-core" or (errorHandler.buildDepError "unliftio-core"))
          (hsPkgs."unordered-containers" or (errorHandler.buildDepError "unordered-containers"))
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
          (hsPkgs."yaml" or (errorHandler.buildDepError "yaml"))
          ];
        buildable = true;
        modules = [
          "Paths_gundeck"
          "Gundeck/API"
          "Gundeck/API/Error"
          "Gundeck/API/Internal"
          "Gundeck/API/Public"
          "Gundeck/Aws"
          "Gundeck/Aws/Arn"
          "Gundeck/Aws/Sns"
          "Gundeck/Client"
          "Gundeck/Env"
          "Gundeck/Instances"
          "Gundeck/Monad"
          "Gundeck/Notification"
          "Gundeck/Notification/Data"
          "Gundeck/Options"
          "Gundeck/Presence"
          "Gundeck/Presence/Data"
          "Gundeck/Push"
          "Gundeck/Push/Data"
          "Gundeck/Push/Native"
          "Gundeck/Push/Native/Serialise"
          "Gundeck/Push/Native/Types"
          "Gundeck/Push/Websocket"
          "Gundeck/React"
          "Gundeck/Run"
          "Gundeck/ThreadBudget"
          "Gundeck/ThreadBudget/Internal"
          "Gundeck/Util"
          "Gundeck/Util/DelayQueue"
          "Gundeck/Util/Redis"
          "Main"
          ];
        hsSourceDirs = [ "src" ];
        };
      exes = {
        "gundeck" = {
          depends = [
            (hsPkgs."HsOpenSSL" or (errorHandler.buildDepError "HsOpenSSL"))
            (hsPkgs."base" or (errorHandler.buildDepError "base"))
            (hsPkgs."extended" or (errorHandler.buildDepError "extended"))
            (hsPkgs."gundeck" or (errorHandler.buildDepError "gundeck"))
            (hsPkgs."gundeck-types" or (errorHandler.buildDepError "gundeck-types"))
            (hsPkgs."imports" or (errorHandler.buildDepError "imports"))
            (hsPkgs."lens" or (errorHandler.buildDepError "lens"))
            (hsPkgs."metrics-wai" or (errorHandler.buildDepError "metrics-wai"))
            (hsPkgs."transformers" or (errorHandler.buildDepError "transformers"))
            (hsPkgs."types-common" or (errorHandler.buildDepError "types-common"))
            (hsPkgs."uuid" or (errorHandler.buildDepError "uuid"))
            ];
          buildable = true;
          modules = [ "Paths_gundeck" ];
          mainPath = [ "src/Main.hs" ] ++ (pkgs.lib).optional (flags.static) "";
          };
        "gundeck-integration" = {
          depends = [
            (hsPkgs."HUnit" or (errorHandler.buildDepError "HUnit"))
            (hsPkgs."HsOpenSSL" or (errorHandler.buildDepError "HsOpenSSL"))
            (hsPkgs."QuickCheck" or (errorHandler.buildDepError "QuickCheck"))
            (hsPkgs."aeson" or (errorHandler.buildDepError "aeson"))
            (hsPkgs."async" or (errorHandler.buildDepError "async"))
            (hsPkgs."base" or (errorHandler.buildDepError "base"))
            (hsPkgs."base16-bytestring" or (errorHandler.buildDepError "base16-bytestring"))
            (hsPkgs."bilge" or (errorHandler.buildDepError "bilge"))
            (hsPkgs."brig-types" or (errorHandler.buildDepError "brig-types"))
            (hsPkgs."bytestring" or (errorHandler.buildDepError "bytestring"))
            (hsPkgs."bytestring-conversion" or (errorHandler.buildDepError "bytestring-conversion"))
            (hsPkgs."cassandra-util" or (errorHandler.buildDepError "cassandra-util"))
            (hsPkgs."containers" or (errorHandler.buildDepError "containers"))
            (hsPkgs."exceptions" or (errorHandler.buildDepError "exceptions"))
            (hsPkgs."extended" or (errorHandler.buildDepError "extended"))
            (hsPkgs."gundeck" or (errorHandler.buildDepError "gundeck"))
            (hsPkgs."gundeck-types" or (errorHandler.buildDepError "gundeck-types"))
            (hsPkgs."http-client" or (errorHandler.buildDepError "http-client"))
            (hsPkgs."http-client-tls" or (errorHandler.buildDepError "http-client-tls"))
            (hsPkgs."imports" or (errorHandler.buildDepError "imports"))
            (hsPkgs."lens" or (errorHandler.buildDepError "lens"))
            (hsPkgs."lens-aeson" or (errorHandler.buildDepError "lens-aeson"))
            (hsPkgs."mtl" or (errorHandler.buildDepError "mtl"))
            (hsPkgs."network" or (errorHandler.buildDepError "network"))
            (hsPkgs."network-uri" or (errorHandler.buildDepError "network-uri"))
            (hsPkgs."optparse-applicative" or (errorHandler.buildDepError "optparse-applicative"))
            (hsPkgs."random" or (errorHandler.buildDepError "random"))
            (hsPkgs."retry" or (errorHandler.buildDepError "retry"))
            (hsPkgs."safe" or (errorHandler.buildDepError "safe"))
            (hsPkgs."stm" or (errorHandler.buildDepError "stm"))
            (hsPkgs."tagged" or (errorHandler.buildDepError "tagged"))
            (hsPkgs."tasty" or (errorHandler.buildDepError "tasty"))
            (hsPkgs."tasty-hunit" or (errorHandler.buildDepError "tasty-hunit"))
            (hsPkgs."text" or (errorHandler.buildDepError "text"))
            (hsPkgs."time" or (errorHandler.buildDepError "time"))
            (hsPkgs."tinylog" or (errorHandler.buildDepError "tinylog"))
            (hsPkgs."transformers" or (errorHandler.buildDepError "transformers"))
            (hsPkgs."types-common" or (errorHandler.buildDepError "types-common"))
            (hsPkgs."unordered-containers" or (errorHandler.buildDepError "unordered-containers"))
            (hsPkgs."uuid" or (errorHandler.buildDepError "uuid"))
            (hsPkgs."vector" or (errorHandler.buildDepError "vector"))
            (hsPkgs."websockets" or (errorHandler.buildDepError "websockets"))
            (hsPkgs."yaml" or (errorHandler.buildDepError "yaml"))
            ];
          buildable = true;
          modules = [ "API" "Metrics" "TestSetup" "Paths_gundeck" ];
          hsSourceDirs = [ "test/integration" ];
          mainPath = [ "Main.hs" ];
          };
        "gundeck-schema" = {
          depends = [
            (hsPkgs."base" or (errorHandler.buildDepError "base"))
            (hsPkgs."cassandra-util" or (errorHandler.buildDepError "cassandra-util"))
            (hsPkgs."extended" or (errorHandler.buildDepError "extended"))
            (hsPkgs."imports" or (errorHandler.buildDepError "imports"))
            (hsPkgs."optparse-applicative" or (errorHandler.buildDepError "optparse-applicative"))
            (hsPkgs."raw-strings-qq" or (errorHandler.buildDepError "raw-strings-qq"))
            (hsPkgs."text" or (errorHandler.buildDepError "text"))
            (hsPkgs."tinylog" or (errorHandler.buildDepError "tinylog"))
            (hsPkgs."types-common" or (errorHandler.buildDepError "types-common"))
            ];
          buildable = true;
          modules = [ "V1" "V2" "V3" "V4" "V5" "V6" "V7" "V8" "Paths_gundeck" ];
          hsSourceDirs = [ "schema/src" ];
          mainPath = [ "Main.hs" ] ++ (pkgs.lib).optional (flags.static) "";
          };
        };
      tests = {
        "gundeck-tests" = {
          depends = [
            (hsPkgs."HsOpenSSL" or (errorHandler.buildDepError "HsOpenSSL"))
            (hsPkgs."MonadRandom" or (errorHandler.buildDepError "MonadRandom"))
            (hsPkgs."QuickCheck" or (errorHandler.buildDepError "QuickCheck"))
            (hsPkgs."aeson" or (errorHandler.buildDepError "aeson"))
            (hsPkgs."aeson-pretty" or (errorHandler.buildDepError "aeson-pretty"))
            (hsPkgs."amazonka" or (errorHandler.buildDepError "amazonka"))
            (hsPkgs."async" or (errorHandler.buildDepError "async"))
            (hsPkgs."base" or (errorHandler.buildDepError "base"))
            (hsPkgs."base64-bytestring" or (errorHandler.buildDepError "base64-bytestring"))
            (hsPkgs."bytestring" or (errorHandler.buildDepError "bytestring"))
            (hsPkgs."containers" or (errorHandler.buildDepError "containers"))
            (hsPkgs."exceptions" or (errorHandler.buildDepError "exceptions"))
            (hsPkgs."extended" or (errorHandler.buildDepError "extended"))
            (hsPkgs."filepath" or (errorHandler.buildDepError "filepath"))
            (hsPkgs."gundeck" or (errorHandler.buildDepError "gundeck"))
            (hsPkgs."gundeck-types" or (errorHandler.buildDepError "gundeck-types"))
            (hsPkgs."imports" or (errorHandler.buildDepError "imports"))
            (hsPkgs."lens" or (errorHandler.buildDepError "lens"))
            (hsPkgs."metrics-wai" or (errorHandler.buildDepError "metrics-wai"))
            (hsPkgs."mtl" or (errorHandler.buildDepError "mtl"))
            (hsPkgs."multiset" or (errorHandler.buildDepError "multiset"))
            (hsPkgs."network-uri" or (errorHandler.buildDepError "network-uri"))
            (hsPkgs."quickcheck-instances" or (errorHandler.buildDepError "quickcheck-instances"))
            (hsPkgs."quickcheck-state-machine" or (errorHandler.buildDepError "quickcheck-state-machine"))
            (hsPkgs."random" or (errorHandler.buildDepError "random"))
            (hsPkgs."scientific" or (errorHandler.buildDepError "scientific"))
            (hsPkgs."string-conversions" or (errorHandler.buildDepError "string-conversions"))
            (hsPkgs."tasty" or (errorHandler.buildDepError "tasty"))
            (hsPkgs."tasty-hunit" or (errorHandler.buildDepError "tasty-hunit"))
            (hsPkgs."tasty-quickcheck" or (errorHandler.buildDepError "tasty-quickcheck"))
            (hsPkgs."text" or (errorHandler.buildDepError "text"))
            (hsPkgs."time" or (errorHandler.buildDepError "time"))
            (hsPkgs."tinylog" or (errorHandler.buildDepError "tinylog"))
            (hsPkgs."transformers" or (errorHandler.buildDepError "transformers"))
            (hsPkgs."tree-diff" or (errorHandler.buildDepError "tree-diff"))
            (hsPkgs."types-common" or (errorHandler.buildDepError "types-common"))
            (hsPkgs."unordered-containers" or (errorHandler.buildDepError "unordered-containers"))
            (hsPkgs."uuid" or (errorHandler.buildDepError "uuid"))
            (hsPkgs."vector" or (errorHandler.buildDepError "vector"))
            (hsPkgs."wai-utilities" or (errorHandler.buildDepError "wai-utilities"))
            ];
          buildable = true;
          modules = [
            "DelayQueue"
            "Json"
            "MockGundeck"
            "Native"
            "Push"
            "ThreadBudget"
            "Paths_gundeck"
            ];
          hsSourceDirs = [ "test/unit" ];
          mainPath = [ "Main.hs" ];
          };
        };
      benchmarks = {
        "gundeck-bench" = {
          depends = [
            (hsPkgs."HsOpenSSL" or (errorHandler.buildDepError "HsOpenSSL"))
            (hsPkgs."aeson" or (errorHandler.buildDepError "aeson"))
            (hsPkgs."amazonka" or (errorHandler.buildDepError "amazonka"))
            (hsPkgs."base" or (errorHandler.buildDepError "base"))
            (hsPkgs."bytestring" or (errorHandler.buildDepError "bytestring"))
            (hsPkgs."criterion" or (errorHandler.buildDepError "criterion"))
            (hsPkgs."extended" or (errorHandler.buildDepError "extended"))
            (hsPkgs."gundeck" or (errorHandler.buildDepError "gundeck"))
            (hsPkgs."gundeck-types" or (errorHandler.buildDepError "gundeck-types"))
            (hsPkgs."imports" or (errorHandler.buildDepError "imports"))
            (hsPkgs."random" or (errorHandler.buildDepError "random"))
            (hsPkgs."text" or (errorHandler.buildDepError "text"))
            (hsPkgs."time" or (errorHandler.buildDepError "time"))
            (hsPkgs."types-common" or (errorHandler.buildDepError "types-common"))
            (hsPkgs."unordered-containers" or (errorHandler.buildDepError "unordered-containers"))
            (hsPkgs."uuid" or (errorHandler.buildDepError "uuid"))
            ];
          buildable = true;
          modules = [ "Paths_gundeck" ];
          hsSourceDirs = [ "test/bench" ];
          };
        };
      };
    } // rec {
    src = (pkgs.lib).mkDefault ./services/gundeck;
    }