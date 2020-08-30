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
      identifier = { name = "stern"; version = "1.7.2"; };
      license = "AGPL-3.0-only";
      copyright = "(c) 2017 Wire Swiss GmbH";
      maintainer = "Wire Swiss GmbH <backend@wire.com>";
      author = "Wire Swiss GmbH";
      homepage = "";
      url = "";
      synopsis = "";
      description = "Backoffice facade";
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
          (hsPkgs."aeson" or (errorHandler.buildDepError "aeson"))
          (hsPkgs."attoparsec" or (errorHandler.buildDepError "attoparsec"))
          (hsPkgs."base" or (errorHandler.buildDepError "base"))
          (hsPkgs."bilge" or (errorHandler.buildDepError "bilge"))
          (hsPkgs."brig-types" or (errorHandler.buildDepError "brig-types"))
          (hsPkgs."bytestring" or (errorHandler.buildDepError "bytestring"))
          (hsPkgs."bytestring-conversion" or (errorHandler.buildDepError "bytestring-conversion"))
          (hsPkgs."containers" or (errorHandler.buildDepError "containers"))
          (hsPkgs."data-default" or (errorHandler.buildDepError "data-default"))
          (hsPkgs."errors" or (errorHandler.buildDepError "errors"))
          (hsPkgs."exceptions" or (errorHandler.buildDepError "exceptions"))
          (hsPkgs."extended" or (errorHandler.buildDepError "extended"))
          (hsPkgs."galley-types" or (errorHandler.buildDepError "galley-types"))
          (hsPkgs."gundeck-types" or (errorHandler.buildDepError "gundeck-types"))
          (hsPkgs."hashable" or (errorHandler.buildDepError "hashable"))
          (hsPkgs."http-client" or (errorHandler.buildDepError "http-client"))
          (hsPkgs."http-types" or (errorHandler.buildDepError "http-types"))
          (hsPkgs."imports" or (errorHandler.buildDepError "imports"))
          (hsPkgs."lens" or (errorHandler.buildDepError "lens"))
          (hsPkgs."metrics-wai" or (errorHandler.buildDepError "metrics-wai"))
          (hsPkgs."mtl" or (errorHandler.buildDepError "mtl"))
          (hsPkgs."optparse-applicative" or (errorHandler.buildDepError "optparse-applicative"))
          (hsPkgs."semigroups" or (errorHandler.buildDepError "semigroups"))
          (hsPkgs."split" or (errorHandler.buildDepError "split"))
          (hsPkgs."swagger" or (errorHandler.buildDepError "swagger"))
          (hsPkgs."text" or (errorHandler.buildDepError "text"))
          (hsPkgs."text-format" or (errorHandler.buildDepError "text-format"))
          (hsPkgs."time" or (errorHandler.buildDepError "time"))
          (hsPkgs."tinylog" or (errorHandler.buildDepError "tinylog"))
          (hsPkgs."transformers" or (errorHandler.buildDepError "transformers"))
          (hsPkgs."types-common" or (errorHandler.buildDepError "types-common"))
          (hsPkgs."unliftio" or (errorHandler.buildDepError "unliftio"))
          (hsPkgs."unordered-containers" or (errorHandler.buildDepError "unordered-containers"))
          (hsPkgs."uuid" or (errorHandler.buildDepError "uuid"))
          (hsPkgs."wai" or (errorHandler.buildDepError "wai"))
          (hsPkgs."wai-extra" or (errorHandler.buildDepError "wai-extra"))
          (hsPkgs."wai-predicates" or (errorHandler.buildDepError "wai-predicates"))
          (hsPkgs."wai-routing" or (errorHandler.buildDepError "wai-routing"))
          (hsPkgs."wai-utilities" or (errorHandler.buildDepError "wai-utilities"))
          (hsPkgs."warp" or (errorHandler.buildDepError "warp"))
          (hsPkgs."wire-api" or (errorHandler.buildDepError "wire-api"))
          (hsPkgs."yaml" or (errorHandler.buildDepError "yaml"))
          ];
        buildable = true;
        modules = [
          "Paths_stern"
          "Main"
          "Stern/API"
          "Stern/API/Predicates"
          "Stern/App"
          "Stern/Intra"
          "Stern/Options"
          "Stern/Swagger"
          "Stern/Types"
          ];
        hsSourceDirs = [ "src" ];
        };
      exes = {
        "stern" = {
          depends = [
            (hsPkgs."base" or (errorHandler.buildDepError "base"))
            (hsPkgs."extended" or (errorHandler.buildDepError "extended"))
            (hsPkgs."imports" or (errorHandler.buildDepError "imports"))
            (hsPkgs."stern" or (errorHandler.buildDepError "stern"))
            (hsPkgs."types-common" or (errorHandler.buildDepError "types-common"))
            (hsPkgs."unliftio" or (errorHandler.buildDepError "unliftio"))
            ];
          buildable = true;
          modules = [ "Paths_stern" ];
          mainPath = [ "src/Main.hs" ] ++ (pkgs.lib).optional (flags.static) "";
          };
        };
      };
    } // rec {
    src = (pkgs.lib).mkDefault ./tools/stern;
    }