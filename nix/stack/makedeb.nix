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
      identifier = { name = "makedeb"; version = "0.3.0"; };
      license = "AGPL-3.0-only";
      copyright = "(c) 2017 Wire Swiss GmbH";
      maintainer = "Wire Swiss GmbH <backend@wire.com>";
      author = "Wire Swiss GmbH";
      homepage = "";
      url = "";
      synopsis = "Create debian archives with dpkg-deb.";
      description = "A simple wrapper around dpkg-deb.";
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
          (hsPkgs."base" or (errorHandler.buildDepError "base"))
          (hsPkgs."directory" or (errorHandler.buildDepError "directory"))
          (hsPkgs."filepath" or (errorHandler.buildDepError "filepath"))
          (hsPkgs."imports" or (errorHandler.buildDepError "imports"))
          (hsPkgs."optparse-applicative" or (errorHandler.buildDepError "optparse-applicative"))
          (hsPkgs."shelly" or (errorHandler.buildDepError "shelly"))
          (hsPkgs."system-filepath" or (errorHandler.buildDepError "system-filepath"))
          (hsPkgs."text" or (errorHandler.buildDepError "text"))
          (hsPkgs."transformers" or (errorHandler.buildDepError "transformers"))
          ];
        buildable = true;
        modules = [
          "Paths_makedeb"
          "Main"
          "System/MakeDeb"
          "System/MakeDeb/FileUtils"
          ];
        hsSourceDirs = [ "src" ];
        };
      exes = {
        "makedeb" = {
          depends = [
            (hsPkgs."base" or (errorHandler.buildDepError "base"))
            (hsPkgs."imports" or (errorHandler.buildDepError "imports"))
            (hsPkgs."makedeb" or (errorHandler.buildDepError "makedeb"))
            (hsPkgs."optparse-applicative" or (errorHandler.buildDepError "optparse-applicative"))
            ];
          buildable = true;
          modules = [ "Paths_makedeb" ];
          mainPath = [ "src/Main.hs" ];
          };
        };
      };
    } // rec {
    src = (pkgs.lib).mkDefault ./tools/makedeb;
    }