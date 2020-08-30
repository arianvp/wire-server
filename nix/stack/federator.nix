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
      identifier = { name = "federator"; version = "1.0.0"; };
      license = "AGPL-3.0-only";
      copyright = "(c) 2020 Wire Swiss GmbH";
      maintainer = "Wire Swiss GmbH <backend@wire.com>";
      author = "Wire Swiss GmbH";
      homepage = "";
      url = "";
      synopsis = "Federation Service";
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
      "library" = {
        depends = [
          (hsPkgs."QuickCheck" or (errorHandler.buildDepError "QuickCheck"))
          (hsPkgs."aeson" or (errorHandler.buildDepError "aeson"))
          (hsPkgs."base" or (errorHandler.buildDepError "base"))
          (hsPkgs."bilge" or (errorHandler.buildDepError "bilge"))
          (hsPkgs."bytestring-conversion" or (errorHandler.buildDepError "bytestring-conversion"))
          (hsPkgs."data-default" or (errorHandler.buildDepError "data-default"))
          (hsPkgs."email-validate" or (errorHandler.buildDepError "email-validate"))
          (hsPkgs."errors" or (errorHandler.buildDepError "errors"))
          (hsPkgs."exceptions" or (errorHandler.buildDepError "exceptions"))
          (hsPkgs."extended" or (errorHandler.buildDepError "extended"))
          (hsPkgs."imports" or (errorHandler.buildDepError "imports"))
          (hsPkgs."lens" or (errorHandler.buildDepError "lens"))
          (hsPkgs."metrics-core" or (errorHandler.buildDepError "metrics-core"))
          (hsPkgs."metrics-wai" or (errorHandler.buildDepError "metrics-wai"))
          (hsPkgs."resourcet" or (errorHandler.buildDepError "resourcet"))
          (hsPkgs."servant" or (errorHandler.buildDepError "servant"))
          (hsPkgs."servant-mock" or (errorHandler.buildDepError "servant-mock"))
          (hsPkgs."servant-server" or (errorHandler.buildDepError "servant-server"))
          (hsPkgs."servant-swagger" or (errorHandler.buildDepError "servant-swagger"))
          (hsPkgs."string-conversions" or (errorHandler.buildDepError "string-conversions"))
          (hsPkgs."text" or (errorHandler.buildDepError "text"))
          (hsPkgs."tinylog" or (errorHandler.buildDepError "tinylog"))
          (hsPkgs."types-common" or (errorHandler.buildDepError "types-common"))
          (hsPkgs."uuid" or (errorHandler.buildDepError "uuid"))
          (hsPkgs."wai" or (errorHandler.buildDepError "wai"))
          (hsPkgs."wai-utilities" or (errorHandler.buildDepError "wai-utilities"))
          (hsPkgs."warp" or (errorHandler.buildDepError "warp"))
          (hsPkgs."wire-api" or (errorHandler.buildDepError "wire-api"))
          (hsPkgs."wire-api-federation" or (errorHandler.buildDepError "wire-api-federation"))
          ];
        buildable = true;
        modules = [
          "Paths_federator"
          "Federator/API"
          "Federator/App"
          "Federator/Impl"
          "Federator/Options"
          "Federator/Run"
          "Federator/Types"
          ];
        hsSourceDirs = [ "src" ];
        };
      exes = {
        "federator" = {
          depends = [
            (hsPkgs."QuickCheck" or (errorHandler.buildDepError "QuickCheck"))
            (hsPkgs."aeson" or (errorHandler.buildDepError "aeson"))
            (hsPkgs."base" or (errorHandler.buildDepError "base"))
            (hsPkgs."bilge" or (errorHandler.buildDepError "bilge"))
            (hsPkgs."bytestring-conversion" or (errorHandler.buildDepError "bytestring-conversion"))
            (hsPkgs."data-default" or (errorHandler.buildDepError "data-default"))
            (hsPkgs."email-validate" or (errorHandler.buildDepError "email-validate"))
            (hsPkgs."errors" or (errorHandler.buildDepError "errors"))
            (hsPkgs."exceptions" or (errorHandler.buildDepError "exceptions"))
            (hsPkgs."extended" or (errorHandler.buildDepError "extended"))
            (hsPkgs."federator" or (errorHandler.buildDepError "federator"))
            (hsPkgs."imports" or (errorHandler.buildDepError "imports"))
            (hsPkgs."lens" or (errorHandler.buildDepError "lens"))
            (hsPkgs."metrics-core" or (errorHandler.buildDepError "metrics-core"))
            (hsPkgs."metrics-wai" or (errorHandler.buildDepError "metrics-wai"))
            (hsPkgs."resourcet" or (errorHandler.buildDepError "resourcet"))
            (hsPkgs."servant" or (errorHandler.buildDepError "servant"))
            (hsPkgs."servant-mock" or (errorHandler.buildDepError "servant-mock"))
            (hsPkgs."servant-server" or (errorHandler.buildDepError "servant-server"))
            (hsPkgs."servant-swagger" or (errorHandler.buildDepError "servant-swagger"))
            (hsPkgs."string-conversions" or (errorHandler.buildDepError "string-conversions"))
            (hsPkgs."text" or (errorHandler.buildDepError "text"))
            (hsPkgs."tinylog" or (errorHandler.buildDepError "tinylog"))
            (hsPkgs."types-common" or (errorHandler.buildDepError "types-common"))
            (hsPkgs."uuid" or (errorHandler.buildDepError "uuid"))
            (hsPkgs."wai" or (errorHandler.buildDepError "wai"))
            (hsPkgs."wai-utilities" or (errorHandler.buildDepError "wai-utilities"))
            (hsPkgs."warp" or (errorHandler.buildDepError "warp"))
            (hsPkgs."wire-api" or (errorHandler.buildDepError "wire-api"))
            (hsPkgs."wire-api-federation" or (errorHandler.buildDepError "wire-api-federation"))
            ];
          buildable = true;
          modules = [ "Paths_federator" ];
          hsSourceDirs = [ "exec" ];
          mainPath = [ "Main.hs" ];
          };
        };
      };
    } // rec {
    src = (pkgs.lib).mkDefault ./services/federator;
    }