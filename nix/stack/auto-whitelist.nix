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
      identifier = { name = "auto-whitelist"; version = "1.0.0"; };
      license = "AGPL-3.0-only";
      copyright = "(c) 2018 Wire Swiss GmbH";
      maintainer = "Wire Swiss GmbH <backend@wire.com>";
      author = "Wire Swiss GmbH";
      homepage = "";
      url = "";
      synopsis = "Backfill service tables";
      description = "";
      buildType = "Simple";
      isLocal = true;
      detailLevel = "FullDetails";
      licenseFiles = [];
      dataDir = "";
      dataFiles = [];
      extraSrcFiles = [];
      extraTmpFiles = [];
      extraDocFiles = [];
      };
    components = {
      exes = {
        "auto-whitelist" = {
          depends = [
            (hsPkgs."attoparsec" or (errorHandler.buildDepError "attoparsec"))
            (hsPkgs."base" or (errorHandler.buildDepError "base"))
            (hsPkgs."brig-types" or (errorHandler.buildDepError "brig-types"))
            (hsPkgs."bytestring" or (errorHandler.buildDepError "bytestring"))
            (hsPkgs."bytestring-conversion" or (errorHandler.buildDepError "bytestring-conversion"))
            (hsPkgs."cassandra-util" or (errorHandler.buildDepError "cassandra-util"))
            (hsPkgs."extended" or (errorHandler.buildDepError "extended"))
            (hsPkgs."extra" or (errorHandler.buildDepError "extra"))
            (hsPkgs."galley-types" or (errorHandler.buildDepError "galley-types"))
            (hsPkgs."imports" or (errorHandler.buildDepError "imports"))
            (hsPkgs."lens" or (errorHandler.buildDepError "lens"))
            (hsPkgs."mtl" or (errorHandler.buildDepError "mtl"))
            (hsPkgs."optparse-applicative" or (errorHandler.buildDepError "optparse-applicative"))
            (hsPkgs."text" or (errorHandler.buildDepError "text"))
            (hsPkgs."time" or (errorHandler.buildDepError "time"))
            (hsPkgs."tinylog" or (errorHandler.buildDepError "tinylog"))
            (hsPkgs."types-common" or (errorHandler.buildDepError "types-common"))
            (hsPkgs."unliftio" or (errorHandler.buildDepError "unliftio"))
            (hsPkgs."uuid" or (errorHandler.buildDepError "uuid"))
            ];
          buildable = true;
          modules = [ "Options" "Work" "Paths_auto_whitelist" ];
          hsSourceDirs = [ "src" ];
          mainPath = [ "Main.hs" ];
          };
        };
      };
    } // rec {
    src = (pkgs.lib).mkDefault ./tools/db/auto-whitelist;
    }