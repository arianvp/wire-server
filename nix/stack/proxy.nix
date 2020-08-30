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
      identifier = { name = "proxy"; version = "0.9.0"; };
      license = "AGPL-3.0-only";
      copyright = "(c) 2017 Wire Swiss GmbH";
      maintainer = "Wire Swiss GmbH <backend@wire.com>";
      author = "Wire Swiss GmbH";
      homepage = "";
      url = "";
      synopsis = "";
      description = "3rd party proxy";
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
          (hsPkgs."base" or (errorHandler.buildDepError "base"))
          (hsPkgs."bilge" or (errorHandler.buildDepError "bilge"))
          (hsPkgs."bytestring" or (errorHandler.buildDepError "bytestring"))
          (hsPkgs."case-insensitive" or (errorHandler.buildDepError "case-insensitive"))
          (hsPkgs."configurator" or (errorHandler.buildDepError "configurator"))
          (hsPkgs."data-default" or (errorHandler.buildDepError "data-default"))
          (hsPkgs."exceptions" or (errorHandler.buildDepError "exceptions"))
          (hsPkgs."extended" or (errorHandler.buildDepError "extended"))
          (hsPkgs."http-client" or (errorHandler.buildDepError "http-client"))
          (hsPkgs."http-client-tls" or (errorHandler.buildDepError "http-client-tls"))
          (hsPkgs."http-reverse-proxy" or (errorHandler.buildDepError "http-reverse-proxy"))
          (hsPkgs."http-types" or (errorHandler.buildDepError "http-types"))
          (hsPkgs."imports" or (errorHandler.buildDepError "imports"))
          (hsPkgs."lens" or (errorHandler.buildDepError "lens"))
          (hsPkgs."metrics-wai" or (errorHandler.buildDepError "metrics-wai"))
          (hsPkgs."mtl" or (errorHandler.buildDepError "mtl"))
          (hsPkgs."network" or (errorHandler.buildDepError "network"))
          (hsPkgs."optparse-applicative" or (errorHandler.buildDepError "optparse-applicative"))
          (hsPkgs."prometheus-client" or (errorHandler.buildDepError "prometheus-client"))
          (hsPkgs."retry" or (errorHandler.buildDepError "retry"))
          (hsPkgs."text" or (errorHandler.buildDepError "text"))
          (hsPkgs."tinylog" or (errorHandler.buildDepError "tinylog"))
          (hsPkgs."tls" or (errorHandler.buildDepError "tls"))
          (hsPkgs."transformers" or (errorHandler.buildDepError "transformers"))
          (hsPkgs."types-common" or (errorHandler.buildDepError "types-common"))
          (hsPkgs."unliftio-core" or (errorHandler.buildDepError "unliftio-core"))
          (hsPkgs."wai" or (errorHandler.buildDepError "wai"))
          (hsPkgs."wai-predicates" or (errorHandler.buildDepError "wai-predicates"))
          (hsPkgs."wai-routing" or (errorHandler.buildDepError "wai-routing"))
          (hsPkgs."wai-utilities" or (errorHandler.buildDepError "wai-utilities"))
          (hsPkgs."warp" or (errorHandler.buildDepError "warp"))
          (hsPkgs."yaml" or (errorHandler.buildDepError "yaml"))
          ];
        buildable = true;
        modules = [
          "Paths_proxy"
          "Main"
          "Proxy/API"
          "Proxy/API/Public"
          "Proxy/Env"
          "Proxy/Options"
          "Proxy/Proxy"
          "Proxy/Run"
          ];
        hsSourceDirs = [ "src" ];
        };
      exes = {
        "proxy" = {
          depends = [
            (hsPkgs."base" or (errorHandler.buildDepError "base"))
            (hsPkgs."extended" or (errorHandler.buildDepError "extended"))
            (hsPkgs."imports" or (errorHandler.buildDepError "imports"))
            (hsPkgs."proxy" or (errorHandler.buildDepError "proxy"))
            (hsPkgs."types-common" or (errorHandler.buildDepError "types-common"))
            ];
          buildable = true;
          modules = [ "Paths_proxy" ];
          mainPath = [ "src/Main.hs" ] ++ (pkgs.lib).optional (flags.static) "";
          };
        };
      };
    } // rec {
    src = (pkgs.lib).mkDefault ./services/proxy;
    }