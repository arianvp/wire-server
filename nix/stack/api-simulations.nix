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
      identifier = { name = "api-simulations"; version = "0.4.2"; };
      license = "AGPL-3.0-only";
      copyright = "";
      maintainer = "Wire Swiss GmbH <backend@wire.com>";
      author = "Wire Swiss GmbH";
      homepage = "";
      url = "";
      synopsis = "(Internal) Wire API simulations";
      description = "(Internal) Wire API simulations using bots (automated users and clients).";
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
          (hsPkgs."aeson" or (errorHandler.buildDepError "aeson"))
          (hsPkgs."api-bot" or (errorHandler.buildDepError "api-bot"))
          (hsPkgs."api-client" or (errorHandler.buildDepError "api-client"))
          (hsPkgs."base" or (errorHandler.buildDepError "base"))
          (hsPkgs."bytestring" or (errorHandler.buildDepError "bytestring"))
          (hsPkgs."bytestring-conversion" or (errorHandler.buildDepError "bytestring-conversion"))
          (hsPkgs."cereal" or (errorHandler.buildDepError "cereal"))
          (hsPkgs."containers" or (errorHandler.buildDepError "containers"))
          (hsPkgs."errors" or (errorHandler.buildDepError "errors"))
          (hsPkgs."exceptions" or (errorHandler.buildDepError "exceptions"))
          (hsPkgs."imports" or (errorHandler.buildDepError "imports"))
          (hsPkgs."lens" or (errorHandler.buildDepError "lens"))
          (hsPkgs."split" or (errorHandler.buildDepError "split"))
          (hsPkgs."text" or (errorHandler.buildDepError "text"))
          (hsPkgs."types-common" or (errorHandler.buildDepError "types-common"))
          ];
        buildable = true;
        modules = [ "Paths_api_simulations" "Network/Wire/Simulations" ];
        hsSourceDirs = [ "lib/src" ];
        };
      exes = {
        "api-loadtest" = {
          depends = [
            (hsPkgs."api-bot" or (errorHandler.buildDepError "api-bot"))
            (hsPkgs."api-client" or (errorHandler.buildDepError "api-client"))
            (hsPkgs."api-simulations" or (errorHandler.buildDepError "api-simulations"))
            (hsPkgs."base" or (errorHandler.buildDepError "base"))
            (hsPkgs."bytestring" or (errorHandler.buildDepError "bytestring"))
            (hsPkgs."bytestring-conversion" or (errorHandler.buildDepError "bytestring-conversion"))
            (hsPkgs."containers" or (errorHandler.buildDepError "containers"))
            (hsPkgs."data-default-class" or (errorHandler.buildDepError "data-default-class"))
            (hsPkgs."exceptions" or (errorHandler.buildDepError "exceptions"))
            (hsPkgs."extended" or (errorHandler.buildDepError "extended"))
            (hsPkgs."http-client" or (errorHandler.buildDepError "http-client"))
            (hsPkgs."http-client-tls" or (errorHandler.buildDepError "http-client-tls"))
            (hsPkgs."imports" or (errorHandler.buildDepError "imports"))
            (hsPkgs."metrics-core" or (errorHandler.buildDepError "metrics-core"))
            (hsPkgs."mime" or (errorHandler.buildDepError "mime"))
            (hsPkgs."monad-control" or (errorHandler.buildDepError "monad-control"))
            (hsPkgs."mwc-random" or (errorHandler.buildDepError "mwc-random"))
            (hsPkgs."optparse-applicative" or (errorHandler.buildDepError "optparse-applicative"))
            (hsPkgs."retry" or (errorHandler.buildDepError "retry"))
            (hsPkgs."split" or (errorHandler.buildDepError "split"))
            (hsPkgs."text" or (errorHandler.buildDepError "text"))
            (hsPkgs."tinylog" or (errorHandler.buildDepError "tinylog"))
            (hsPkgs."transformers" or (errorHandler.buildDepError "transformers"))
            (hsPkgs."types-common" or (errorHandler.buildDepError "types-common"))
            (hsPkgs."unliftio" or (errorHandler.buildDepError "unliftio"))
            (hsPkgs."uuid" or (errorHandler.buildDepError "uuid"))
            ];
          buildable = true;
          modules = [
            "Network/Wire/Simulations/LoadTest"
            "Paths_api_simulations"
            ];
          hsSourceDirs = [ "loadtest/src" ];
          mainPath = [ "Main.hs" ];
          };
        "api-smoketest" = {
          depends = [
            (hsPkgs."api-bot" or (errorHandler.buildDepError "api-bot"))
            (hsPkgs."api-client" or (errorHandler.buildDepError "api-client"))
            (hsPkgs."api-simulations" or (errorHandler.buildDepError "api-simulations"))
            (hsPkgs."base" or (errorHandler.buildDepError "base"))
            (hsPkgs."bytestring" or (errorHandler.buildDepError "bytestring"))
            (hsPkgs."bytestring-conversion" or (errorHandler.buildDepError "bytestring-conversion"))
            (hsPkgs."containers" or (errorHandler.buildDepError "containers"))
            (hsPkgs."data-default-class" or (errorHandler.buildDepError "data-default-class"))
            (hsPkgs."exceptions" or (errorHandler.buildDepError "exceptions"))
            (hsPkgs."http-client" or (errorHandler.buildDepError "http-client"))
            (hsPkgs."http-client-tls" or (errorHandler.buildDepError "http-client-tls"))
            (hsPkgs."imports" or (errorHandler.buildDepError "imports"))
            (hsPkgs."lens" or (errorHandler.buildDepError "lens"))
            (hsPkgs."mime" or (errorHandler.buildDepError "mime"))
            (hsPkgs."optparse-applicative" or (errorHandler.buildDepError "optparse-applicative"))
            (hsPkgs."retry" or (errorHandler.buildDepError "retry"))
            (hsPkgs."split" or (errorHandler.buildDepError "split"))
            (hsPkgs."text" or (errorHandler.buildDepError "text"))
            (hsPkgs."tinylog" or (errorHandler.buildDepError "tinylog"))
            (hsPkgs."transformers" or (errorHandler.buildDepError "transformers"))
            (hsPkgs."types-common" or (errorHandler.buildDepError "types-common"))
            (hsPkgs."unliftio" or (errorHandler.buildDepError "unliftio"))
            (hsPkgs."unordered-containers" or (errorHandler.buildDepError "unordered-containers"))
            (hsPkgs."uuid" or (errorHandler.buildDepError "uuid"))
            ];
          buildable = true;
          modules = [
            "Network/Wire/Simulations/SmokeTest"
            "Paths_api_simulations"
            ];
          hsSourceDirs = [ "smoketest/src" ];
          mainPath = [ "Main.hs" ];
          };
        };
      };
    } // rec {
    src = (pkgs.lib).mkDefault ./tools/api-simulations;
    }