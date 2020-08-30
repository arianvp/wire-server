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
      identifier = { name = "find-undead"; version = "1.0.0"; };
      license = "AGPL-3.0-only";
      copyright = "(c) 2020 Wire Swiss GmbH";
      maintainer = "Wire Swiss GmbH <backend@wire.com>";
      author = "Wire Swiss GmbH";
      homepage = "";
      url = "";
      synopsis = "Backfill billing_team_member table";
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
        "find-undead" = {
          depends = [
            (hsPkgs."aeson" or (errorHandler.buildDepError "aeson"))
            (hsPkgs."base" or (errorHandler.buildDepError "base"))
            (hsPkgs."bloodhound" or (errorHandler.buildDepError "bloodhound"))
            (hsPkgs."brig-types" or (errorHandler.buildDepError "brig-types"))
            (hsPkgs."cassandra-util" or (errorHandler.buildDepError "cassandra-util"))
            (hsPkgs."conduit" or (errorHandler.buildDepError "conduit"))
            (hsPkgs."containers" or (errorHandler.buildDepError "containers"))
            (hsPkgs."galley-types" or (errorHandler.buildDepError "galley-types"))
            (hsPkgs."http-client" or (errorHandler.buildDepError "http-client"))
            (hsPkgs."imports" or (errorHandler.buildDepError "imports"))
            (hsPkgs."lens" or (errorHandler.buildDepError "lens"))
            (hsPkgs."optparse-applicative" or (errorHandler.buildDepError "optparse-applicative"))
            (hsPkgs."text" or (errorHandler.buildDepError "text"))
            (hsPkgs."time" or (errorHandler.buildDepError "time"))
            (hsPkgs."tinylog" or (errorHandler.buildDepError "tinylog"))
            (hsPkgs."types-common" or (errorHandler.buildDepError "types-common"))
            (hsPkgs."unliftio" or (errorHandler.buildDepError "unliftio"))
            (hsPkgs."uuid" or (errorHandler.buildDepError "uuid"))
            ];
          buildable = true;
          modules = [ "Options" "Work" "Paths_find_undead" ];
          hsSourceDirs = [ "src" ];
          mainPath = [ "Main.hs" ];
          };
        };
      };
    } // rec {
    src = (pkgs.lib).mkDefault ./tools/db/find-undead;
    }