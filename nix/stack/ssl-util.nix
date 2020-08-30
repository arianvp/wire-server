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
      identifier = { name = "ssl-util"; version = "0.1.0"; };
      license = "AGPL-3.0-only";
      copyright = "(c) 2018 Wire Swiss GmbH";
      maintainer = "Wire Swiss GmbH <backend@wire.com>";
      author = "Wire Swiss GmbH";
      homepage = "";
      url = "";
      synopsis = "SSL-related utilities";
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
          (hsPkgs."base" or (errorHandler.buildDepError "base"))
          (hsPkgs."byteable" or (errorHandler.buildDepError "byteable"))
          (hsPkgs."bytestring" or (errorHandler.buildDepError "bytestring"))
          (hsPkgs."http-client" or (errorHandler.buildDepError "http-client"))
          (hsPkgs."imports" or (errorHandler.buildDepError "imports"))
          (hsPkgs."network" or (errorHandler.buildDepError "network"))
          (hsPkgs."time" or (errorHandler.buildDepError "time"))
          ];
        buildable = true;
        modules = [ "Paths_ssl_util" "Ssl/Util" ];
        hsSourceDirs = [ "src" ];
        };
      };
    } // rec {
    src = (pkgs.lib).mkDefault ./libs/ssl-util;
    }