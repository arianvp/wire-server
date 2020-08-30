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
      specVersion = "1.24";
      identifier = { name = "types-common-journal"; version = "0.1.0"; };
      license = "AGPL-3.0-only";
      copyright = "(c) 2017 Wire Swiss GmbH";
      maintainer = "Wire Swiss GmbH <backend@wire.com>";
      author = "Wire Swiss GmbH";
      homepage = "";
      url = "";
      synopsis = "Shared protobuf type definitions.";
      description = "Shared protobuf type definitions for journaling.";
      buildType = "Custom";
      isLocal = true;
      setup-depends = [
        (hsPkgs.buildPackages.Cabal or (pkgs.buildPackages.Cabal or (errorHandler.buildToolDepError "Cabal")))
        (hsPkgs.buildPackages.base or (pkgs.buildPackages.base or (errorHandler.buildToolDepError "base")))
        (hsPkgs.buildPackages.proto-lens-setup or (pkgs.buildPackages.proto-lens-setup or (errorHandler.buildToolDepError "proto-lens-setup")))
        ];
      detailLevel = "FullDetails";
      licenseFiles = [ "LICENSE" ];
      dataDir = "";
      dataFiles = [];
      extraSrcFiles = [ "proto/TeamEvents.proto" "proto/UserEvents.proto" ];
      extraTmpFiles = [];
      extraDocFiles = [];
      };
    components = {
      "library" = {
        depends = [
          (hsPkgs."base" or (errorHandler.buildDepError "base"))
          (hsPkgs."bytestring" or (errorHandler.buildDepError "bytestring"))
          (hsPkgs."imports" or (errorHandler.buildDepError "imports"))
          (hsPkgs."proto-lens-runtime" or (errorHandler.buildDepError "proto-lens-runtime"))
          (hsPkgs."time" or (errorHandler.buildDepError "time"))
          (hsPkgs."types-common" or (errorHandler.buildDepError "types-common"))
          (hsPkgs."uuid" or (errorHandler.buildDepError "uuid"))
          ];
        build-tools = [
          (hsPkgs.buildPackages.proto-lens-protoc or (pkgs.buildPackages.proto-lens-protoc or (errorHandler.buildToolDepError "proto-lens-protoc")))
          ];
        buildable = true;
        modules = [
          "Paths_types_common_journal"
          "Data/Proto"
          "Data/Proto/Id"
          "Proto/TeamEvents"
          "Proto/TeamEvents_Fields"
          "Proto/UserEvents"
          "Proto/UserEvents_Fields"
          ];
        hsSourceDirs = [ "src" ];
        };
      };
    } // rec {
    src = (pkgs.lib).mkDefault ./libs/types-common-journal;
    }