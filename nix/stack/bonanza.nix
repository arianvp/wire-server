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
      identifier = { name = "bonanza"; version = "3.6.0"; };
      license = "AGPL-3.0-only";
      copyright = "";
      maintainer = "Wire Swiss GmbH <backend@wire.com>";
      author = "Wire Swiss GmbH";
      homepage = "";
      url = "";
      synopsis = "Log Processing.";
      description = "Parsing, transforming, and forwarding of log data.";
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
          (hsPkgs."attoparsec" or (errorHandler.buildDepError "attoparsec"))
          (hsPkgs."base" or (errorHandler.buildDepError "base"))
          (hsPkgs."base16-bytestring" or (errorHandler.buildDepError "base16-bytestring"))
          (hsPkgs."base64-bytestring" or (errorHandler.buildDepError "base64-bytestring"))
          (hsPkgs."bifunctors" or (errorHandler.buildDepError "bifunctors"))
          (hsPkgs."binary" or (errorHandler.buildDepError "binary"))
          (hsPkgs."bytestring" or (errorHandler.buildDepError "bytestring"))
          (hsPkgs."bytestring-conversion" or (errorHandler.buildDepError "bytestring-conversion"))
          (hsPkgs."cereal" or (errorHandler.buildDepError "cereal"))
          (hsPkgs."cereal-conduit" or (errorHandler.buildDepError "cereal-conduit"))
          (hsPkgs."conduit" or (errorHandler.buildDepError "conduit"))
          (hsPkgs."conduit-extra" or (errorHandler.buildDepError "conduit-extra"))
          (hsPkgs."containers" or (errorHandler.buildDepError "containers"))
          (hsPkgs."ekg-core" or (errorHandler.buildDepError "ekg-core"))
          (hsPkgs."exceptions" or (errorHandler.buildDepError "exceptions"))
          (hsPkgs."hs-GeoIP" or (errorHandler.buildDepError "hs-GeoIP"))
          (hsPkgs."http-client" or (errorHandler.buildDepError "http-client"))
          (hsPkgs."http-types" or (errorHandler.buildDepError "http-types"))
          (hsPkgs."imports" or (errorHandler.buildDepError "imports"))
          (hsPkgs."lens" or (errorHandler.buildDepError "lens"))
          (hsPkgs."lens-aeson" or (errorHandler.buildDepError "lens-aeson"))
          (hsPkgs."mtl" or (errorHandler.buildDepError "mtl"))
          (hsPkgs."network" or (errorHandler.buildDepError "network"))
          (hsPkgs."optparse-applicative" or (errorHandler.buildDepError "optparse-applicative"))
          (hsPkgs."protobuf" or (errorHandler.buildDepError "protobuf"))
          (hsPkgs."resourcet" or (errorHandler.buildDepError "resourcet"))
          (hsPkgs."scientific" or (errorHandler.buildDepError "scientific"))
          (hsPkgs."snappy" or (errorHandler.buildDepError "snappy"))
          (hsPkgs."snappy-framing" or (errorHandler.buildDepError "snappy-framing"))
          (hsPkgs."text" or (errorHandler.buildDepError "text"))
          (hsPkgs."time" or (errorHandler.buildDepError "time"))
          (hsPkgs."types-common" or (errorHandler.buildDepError "types-common"))
          (hsPkgs."unordered-containers" or (errorHandler.buildDepError "unordered-containers"))
          (hsPkgs."vector" or (errorHandler.buildDepError "vector"))
          ];
        buildable = true;
        modules = [
          "Paths_bonanza"
          "Bonanza/Anon"
          "Bonanza/App"
          "Bonanza/Geo"
          "Bonanza/Metrics"
          "Bonanza/Parser/CommonLog"
          "Bonanza/Parser/Internal"
          "Bonanza/Parser/IP"
          "Bonanza/Parser/Journald"
          "Bonanza/Parser/Netstrings"
          "Bonanza/Parser/Nginz"
          "Bonanza/Parser/Rkt"
          "Bonanza/Parser/Socklog"
          "Bonanza/Parser/Svlogd"
          "Bonanza/Parser/Time"
          "Bonanza/Parser/Tinylog"
          "Bonanza/Streaming/Binary"
          "Bonanza/Streaming/Kibana"
          "Bonanza/Streaming/Parser"
          "Bonanza/Streaming/Protobuf"
          "Bonanza/Streaming/Snappy"
          "Bonanza/Types"
          ];
        hsSourceDirs = [ "src" ];
        };
      exes = {
        "bonanza" = {
          depends = [
            (hsPkgs."base" or (errorHandler.buildDepError "base"))
            (hsPkgs."bonanza" or (errorHandler.buildDepError "bonanza"))
            (hsPkgs."bytestring" or (errorHandler.buildDepError "bytestring"))
            (hsPkgs."conduit" or (errorHandler.buildDepError "conduit"))
            (hsPkgs."conduit-extra" or (errorHandler.buildDepError "conduit-extra"))
            (hsPkgs."imports" or (errorHandler.buildDepError "imports"))
            (hsPkgs."text" or (errorHandler.buildDepError "text"))
            ];
          buildable = true;
          modules = [ "Paths_bonanza" ];
          mainPath = [ "main/Main.hs" ];
          };
        "kibana-raw" = {
          depends = [
            (hsPkgs."aeson" or (errorHandler.buildDepError "aeson"))
            (hsPkgs."base" or (errorHandler.buildDepError "base"))
            (hsPkgs."bytestring" or (errorHandler.buildDepError "bytestring"))
            (hsPkgs."clock" or (errorHandler.buildDepError "clock"))
            (hsPkgs."conduit" or (errorHandler.buildDepError "conduit"))
            (hsPkgs."conduit-extra" or (errorHandler.buildDepError "conduit-extra"))
            (hsPkgs."cryptonite" or (errorHandler.buildDepError "cryptonite"))
            (hsPkgs."imports" or (errorHandler.buildDepError "imports"))
            (hsPkgs."optparse-applicative" or (errorHandler.buildDepError "optparse-applicative"))
            (hsPkgs."text" or (errorHandler.buildDepError "text"))
            (hsPkgs."time" or (errorHandler.buildDepError "time"))
            ];
          buildable = true;
          modules = [ "Paths_bonanza" ];
          mainPath = [ "main/KibanaRaw.hs" ];
          };
        "kibanana" = {
          depends = [
            (hsPkgs."async" or (errorHandler.buildDepError "async"))
            (hsPkgs."base" or (errorHandler.buildDepError "base"))
            (hsPkgs."bytestring" or (errorHandler.buildDepError "bytestring"))
            (hsPkgs."conduit" or (errorHandler.buildDepError "conduit"))
            (hsPkgs."conduit-extra" or (errorHandler.buildDepError "conduit-extra"))
            (hsPkgs."containers" or (errorHandler.buildDepError "containers"))
            (hsPkgs."errors" or (errorHandler.buildDepError "errors"))
            (hsPkgs."http-client" or (errorHandler.buildDepError "http-client"))
            (hsPkgs."http-client-tls" or (errorHandler.buildDepError "http-client-tls"))
            (hsPkgs."http-conduit" or (errorHandler.buildDepError "http-conduit"))
            (hsPkgs."imports" or (errorHandler.buildDepError "imports"))
            (hsPkgs."optparse-applicative" or (errorHandler.buildDepError "optparse-applicative"))
            (hsPkgs."stm" or (errorHandler.buildDepError "stm"))
            (hsPkgs."text" or (errorHandler.buildDepError "text"))
            ];
          buildable = true;
          modules = [ "Paths_bonanza" ];
          mainPath = [ "main/Kibanana.hs" ];
          };
        };
      tests = {
        "bonanza-tests" = {
          depends = [
            (hsPkgs."QuickCheck" or (errorHandler.buildDepError "QuickCheck"))
            (hsPkgs."aeson" or (errorHandler.buildDepError "aeson"))
            (hsPkgs."attoparsec" or (errorHandler.buildDepError "attoparsec"))
            (hsPkgs."base" or (errorHandler.buildDepError "base"))
            (hsPkgs."bonanza" or (errorHandler.buildDepError "bonanza"))
            (hsPkgs."bytestring" or (errorHandler.buildDepError "bytestring"))
            (hsPkgs."conduit" or (errorHandler.buildDepError "conduit"))
            (hsPkgs."conduit-extra" or (errorHandler.buildDepError "conduit-extra"))
            (hsPkgs."http-types" or (errorHandler.buildDepError "http-types"))
            (hsPkgs."imports" or (errorHandler.buildDepError "imports"))
            (hsPkgs."lens" or (errorHandler.buildDepError "lens"))
            (hsPkgs."scientific" or (errorHandler.buildDepError "scientific"))
            (hsPkgs."tasty" or (errorHandler.buildDepError "tasty"))
            (hsPkgs."tasty-quickcheck" or (errorHandler.buildDepError "tasty-quickcheck"))
            (hsPkgs."text" or (errorHandler.buildDepError "text"))
            (hsPkgs."time" or (errorHandler.buildDepError "time"))
            (hsPkgs."vector" or (errorHandler.buildDepError "vector"))
            ];
          buildable = true;
          modules = [
            "Test/Bonanza/Arbitrary"
            "Test/Bonanza/Parser"
            "Test/Bonanza/Streaming"
            "Paths_bonanza"
            ];
          hsSourceDirs = [ "test/unit" ];
          mainPath = [ "Main.hs" ];
          };
        };
      };
    } // rec {
    src = (pkgs.lib).mkDefault ./tools/bonanza;
    }