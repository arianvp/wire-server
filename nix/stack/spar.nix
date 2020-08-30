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
      identifier = { name = "spar"; version = "0.1"; };
      license = "AGPL-3.0-only";
      copyright = "(c) 2018 Wire Swiss GmbH";
      maintainer = "Wire Swiss GmbH <backend@wire.com>";
      author = "Wire Swiss GmbH";
      homepage = "";
      url = "";
      synopsis = "User Service for SSO (Single Sign-On) provisioning and authentication.";
      description = "See README.md";
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
          (hsPkgs."aeson" or (errorHandler.buildDepError "aeson"))
          (hsPkgs."aeson-pretty" or (errorHandler.buildDepError "aeson-pretty"))
          (hsPkgs."aeson-qq" or (errorHandler.buildDepError "aeson-qq"))
          (hsPkgs."base" or (errorHandler.buildDepError "base"))
          (hsPkgs."base64-bytestring" or (errorHandler.buildDepError "base64-bytestring"))
          (hsPkgs."bilge" or (errorHandler.buildDepError "bilge"))
          (hsPkgs."binary" or (errorHandler.buildDepError "binary"))
          (hsPkgs."brig-types" or (errorHandler.buildDepError "brig-types"))
          (hsPkgs."bytestring" or (errorHandler.buildDepError "bytestring"))
          (hsPkgs."bytestring-conversion" or (errorHandler.buildDepError "bytestring-conversion"))
          (hsPkgs."case-insensitive" or (errorHandler.buildDepError "case-insensitive"))
          (hsPkgs."cassandra-util" or (errorHandler.buildDepError "cassandra-util"))
          (hsPkgs."containers" or (errorHandler.buildDepError "containers"))
          (hsPkgs."cookie" or (errorHandler.buildDepError "cookie"))
          (hsPkgs."cryptonite" or (errorHandler.buildDepError "cryptonite"))
          (hsPkgs."data-default" or (errorHandler.buildDepError "data-default"))
          (hsPkgs."email-validate" or (errorHandler.buildDepError "email-validate"))
          (hsPkgs."errors" or (errorHandler.buildDepError "errors"))
          (hsPkgs."exceptions" or (errorHandler.buildDepError "exceptions"))
          (hsPkgs."extended" or (errorHandler.buildDepError "extended"))
          (hsPkgs."extra" or (errorHandler.buildDepError "extra"))
          (hsPkgs."galley-types" or (errorHandler.buildDepError "galley-types"))
          (hsPkgs."ghc-prim" or (errorHandler.buildDepError "ghc-prim"))
          (hsPkgs."hscim" or (errorHandler.buildDepError "hscim"))
          (hsPkgs."http-api-data" or (errorHandler.buildDepError "http-api-data"))
          (hsPkgs."http-client" or (errorHandler.buildDepError "http-client"))
          (hsPkgs."http-client-tls" or (errorHandler.buildDepError "http-client-tls"))
          (hsPkgs."http-media" or (errorHandler.buildDepError "http-media"))
          (hsPkgs."http-types" or (errorHandler.buildDepError "http-types"))
          (hsPkgs."imports" or (errorHandler.buildDepError "imports"))
          (hsPkgs."insert-ordered-containers" or (errorHandler.buildDepError "insert-ordered-containers"))
          (hsPkgs."interpolate" or (errorHandler.buildDepError "interpolate"))
          (hsPkgs."lens" or (errorHandler.buildDepError "lens"))
          (hsPkgs."metrics-core" or (errorHandler.buildDepError "metrics-core"))
          (hsPkgs."metrics-wai" or (errorHandler.buildDepError "metrics-wai"))
          (hsPkgs."mtl" or (errorHandler.buildDepError "mtl"))
          (hsPkgs."network-uri" or (errorHandler.buildDepError "network-uri"))
          (hsPkgs."optparse-applicative" or (errorHandler.buildDepError "optparse-applicative"))
          (hsPkgs."prometheus-client" or (errorHandler.buildDepError "prometheus-client"))
          (hsPkgs."raw-strings-qq" or (errorHandler.buildDepError "raw-strings-qq"))
          (hsPkgs."retry" or (errorHandler.buildDepError "retry"))
          (hsPkgs."saml2-web-sso" or (errorHandler.buildDepError "saml2-web-sso"))
          (hsPkgs."scientific" or (errorHandler.buildDepError "scientific"))
          (hsPkgs."servant" or (errorHandler.buildDepError "servant"))
          (hsPkgs."servant-multipart" or (errorHandler.buildDepError "servant-multipart"))
          (hsPkgs."servant-server" or (errorHandler.buildDepError "servant-server"))
          (hsPkgs."servant-swagger" or (errorHandler.buildDepError "servant-swagger"))
          (hsPkgs."string-conversions" or (errorHandler.buildDepError "string-conversions"))
          (hsPkgs."swagger2" or (errorHandler.buildDepError "swagger2"))
          (hsPkgs."text" or (errorHandler.buildDepError "text"))
          (hsPkgs."text-latin1" or (errorHandler.buildDepError "text-latin1"))
          (hsPkgs."time" or (errorHandler.buildDepError "time"))
          (hsPkgs."tinylog" or (errorHandler.buildDepError "tinylog"))
          (hsPkgs."transformers" or (errorHandler.buildDepError "transformers"))
          (hsPkgs."types-common" or (errorHandler.buildDepError "types-common"))
          (hsPkgs."unordered-containers" or (errorHandler.buildDepError "unordered-containers"))
          (hsPkgs."uri-bytestring" or (errorHandler.buildDepError "uri-bytestring"))
          (hsPkgs."uuid" or (errorHandler.buildDepError "uuid"))
          (hsPkgs."wai" or (errorHandler.buildDepError "wai"))
          (hsPkgs."wai-middleware-prometheus" or (errorHandler.buildDepError "wai-middleware-prometheus"))
          (hsPkgs."wai-utilities" or (errorHandler.buildDepError "wai-utilities"))
          (hsPkgs."warp" or (errorHandler.buildDepError "warp"))
          (hsPkgs."wire-api" or (errorHandler.buildDepError "wire-api"))
          (hsPkgs."x509" or (errorHandler.buildDepError "x509"))
          (hsPkgs."xml-conduit" or (errorHandler.buildDepError "xml-conduit"))
          (hsPkgs."yaml" or (errorHandler.buildDepError "yaml"))
          ];
        buildable = true;
        modules = [
          "Paths_spar"
          "Spar/API"
          "Spar/API/Swagger"
          "Spar/API/Types"
          "Spar/API/Util"
          "Spar/App"
          "Spar/Data"
          "Spar/Data/Instances"
          "Spar/Error"
          "Spar/Intra/Brig"
          "Spar/Intra/Galley"
          "Spar/Options"
          "Spar/Orphans"
          "Spar/Run"
          "Spar/Scim"
          "Spar/Scim/Auth"
          "Spar/Scim/Swagger"
          "Spar/Scim/Types"
          "Spar/Scim/User"
          "Spar/Types"
          ];
        hsSourceDirs = [ "src" ];
        };
      exes = {
        "spar" = {
          depends = [
            (hsPkgs."HsOpenSSL" or (errorHandler.buildDepError "HsOpenSSL"))
            (hsPkgs."aeson" or (errorHandler.buildDepError "aeson"))
            (hsPkgs."aeson-pretty" or (errorHandler.buildDepError "aeson-pretty"))
            (hsPkgs."aeson-qq" or (errorHandler.buildDepError "aeson-qq"))
            (hsPkgs."base" or (errorHandler.buildDepError "base"))
            (hsPkgs."base64-bytestring" or (errorHandler.buildDepError "base64-bytestring"))
            (hsPkgs."bilge" or (errorHandler.buildDepError "bilge"))
            (hsPkgs."binary" or (errorHandler.buildDepError "binary"))
            (hsPkgs."brig-types" or (errorHandler.buildDepError "brig-types"))
            (hsPkgs."bytestring" or (errorHandler.buildDepError "bytestring"))
            (hsPkgs."bytestring-conversion" or (errorHandler.buildDepError "bytestring-conversion"))
            (hsPkgs."case-insensitive" or (errorHandler.buildDepError "case-insensitive"))
            (hsPkgs."cassandra-util" or (errorHandler.buildDepError "cassandra-util"))
            (hsPkgs."containers" or (errorHandler.buildDepError "containers"))
            (hsPkgs."cookie" or (errorHandler.buildDepError "cookie"))
            (hsPkgs."cryptonite" or (errorHandler.buildDepError "cryptonite"))
            (hsPkgs."data-default" or (errorHandler.buildDepError "data-default"))
            (hsPkgs."email-validate" or (errorHandler.buildDepError "email-validate"))
            (hsPkgs."errors" or (errorHandler.buildDepError "errors"))
            (hsPkgs."exceptions" or (errorHandler.buildDepError "exceptions"))
            (hsPkgs."extended" or (errorHandler.buildDepError "extended"))
            (hsPkgs."extra" or (errorHandler.buildDepError "extra"))
            (hsPkgs."galley-types" or (errorHandler.buildDepError "galley-types"))
            (hsPkgs."ghc-prim" or (errorHandler.buildDepError "ghc-prim"))
            (hsPkgs."hscim" or (errorHandler.buildDepError "hscim"))
            (hsPkgs."http-api-data" or (errorHandler.buildDepError "http-api-data"))
            (hsPkgs."http-client" or (errorHandler.buildDepError "http-client"))
            (hsPkgs."http-client-tls" or (errorHandler.buildDepError "http-client-tls"))
            (hsPkgs."http-media" or (errorHandler.buildDepError "http-media"))
            (hsPkgs."http-types" or (errorHandler.buildDepError "http-types"))
            (hsPkgs."imports" or (errorHandler.buildDepError "imports"))
            (hsPkgs."insert-ordered-containers" or (errorHandler.buildDepError "insert-ordered-containers"))
            (hsPkgs."interpolate" or (errorHandler.buildDepError "interpolate"))
            (hsPkgs."lens" or (errorHandler.buildDepError "lens"))
            (hsPkgs."metrics-core" or (errorHandler.buildDepError "metrics-core"))
            (hsPkgs."metrics-wai" or (errorHandler.buildDepError "metrics-wai"))
            (hsPkgs."mtl" or (errorHandler.buildDepError "mtl"))
            (hsPkgs."network-uri" or (errorHandler.buildDepError "network-uri"))
            (hsPkgs."optparse-applicative" or (errorHandler.buildDepError "optparse-applicative"))
            (hsPkgs."prometheus-client" or (errorHandler.buildDepError "prometheus-client"))
            (hsPkgs."raw-strings-qq" or (errorHandler.buildDepError "raw-strings-qq"))
            (hsPkgs."retry" or (errorHandler.buildDepError "retry"))
            (hsPkgs."saml2-web-sso" or (errorHandler.buildDepError "saml2-web-sso"))
            (hsPkgs."scientific" or (errorHandler.buildDepError "scientific"))
            (hsPkgs."servant" or (errorHandler.buildDepError "servant"))
            (hsPkgs."servant-multipart" or (errorHandler.buildDepError "servant-multipart"))
            (hsPkgs."servant-server" or (errorHandler.buildDepError "servant-server"))
            (hsPkgs."servant-swagger" or (errorHandler.buildDepError "servant-swagger"))
            (hsPkgs."spar" or (errorHandler.buildDepError "spar"))
            (hsPkgs."string-conversions" or (errorHandler.buildDepError "string-conversions"))
            (hsPkgs."swagger2" or (errorHandler.buildDepError "swagger2"))
            (hsPkgs."text" or (errorHandler.buildDepError "text"))
            (hsPkgs."text-latin1" or (errorHandler.buildDepError "text-latin1"))
            (hsPkgs."time" or (errorHandler.buildDepError "time"))
            (hsPkgs."tinylog" or (errorHandler.buildDepError "tinylog"))
            (hsPkgs."transformers" or (errorHandler.buildDepError "transformers"))
            (hsPkgs."types-common" or (errorHandler.buildDepError "types-common"))
            (hsPkgs."unordered-containers" or (errorHandler.buildDepError "unordered-containers"))
            (hsPkgs."uri-bytestring" or (errorHandler.buildDepError "uri-bytestring"))
            (hsPkgs."uuid" or (errorHandler.buildDepError "uuid"))
            (hsPkgs."wai" or (errorHandler.buildDepError "wai"))
            (hsPkgs."wai-middleware-prometheus" or (errorHandler.buildDepError "wai-middleware-prometheus"))
            (hsPkgs."wai-utilities" or (errorHandler.buildDepError "wai-utilities"))
            (hsPkgs."warp" or (errorHandler.buildDepError "warp"))
            (hsPkgs."wire-api" or (errorHandler.buildDepError "wire-api"))
            (hsPkgs."x509" or (errorHandler.buildDepError "x509"))
            (hsPkgs."xml-conduit" or (errorHandler.buildDepError "xml-conduit"))
            (hsPkgs."yaml" or (errorHandler.buildDepError "yaml"))
            ];
          buildable = true;
          modules = [ "Paths_spar" ];
          hsSourceDirs = [ "exec" ];
          mainPath = [ "Main.hs" ];
          };
        "spar-integration" = {
          depends = [
            (hsPkgs."HsOpenSSL" or (errorHandler.buildDepError "HsOpenSSL"))
            (hsPkgs."MonadRandom" or (errorHandler.buildDepError "MonadRandom"))
            (hsPkgs."QuickCheck" or (errorHandler.buildDepError "QuickCheck"))
            (hsPkgs."aeson" or (errorHandler.buildDepError "aeson"))
            (hsPkgs."aeson-pretty" or (errorHandler.buildDepError "aeson-pretty"))
            (hsPkgs."aeson-qq" or (errorHandler.buildDepError "aeson-qq"))
            (hsPkgs."async" or (errorHandler.buildDepError "async"))
            (hsPkgs."base" or (errorHandler.buildDepError "base"))
            (hsPkgs."base64-bytestring" or (errorHandler.buildDepError "base64-bytestring"))
            (hsPkgs."bilge" or (errorHandler.buildDepError "bilge"))
            (hsPkgs."binary" or (errorHandler.buildDepError "binary"))
            (hsPkgs."brig-types" or (errorHandler.buildDepError "brig-types"))
            (hsPkgs."bytestring" or (errorHandler.buildDepError "bytestring"))
            (hsPkgs."bytestring-conversion" or (errorHandler.buildDepError "bytestring-conversion"))
            (hsPkgs."case-insensitive" or (errorHandler.buildDepError "case-insensitive"))
            (hsPkgs."cassandra-util" or (errorHandler.buildDepError "cassandra-util"))
            (hsPkgs."containers" or (errorHandler.buildDepError "containers"))
            (hsPkgs."cookie" or (errorHandler.buildDepError "cookie"))
            (hsPkgs."cryptonite" or (errorHandler.buildDepError "cryptonite"))
            (hsPkgs."data-default" or (errorHandler.buildDepError "data-default"))
            (hsPkgs."email-validate" or (errorHandler.buildDepError "email-validate"))
            (hsPkgs."errors" or (errorHandler.buildDepError "errors"))
            (hsPkgs."exceptions" or (errorHandler.buildDepError "exceptions"))
            (hsPkgs."extended" or (errorHandler.buildDepError "extended"))
            (hsPkgs."extra" or (errorHandler.buildDepError "extra"))
            (hsPkgs."galley-types" or (errorHandler.buildDepError "galley-types"))
            (hsPkgs."ghc-prim" or (errorHandler.buildDepError "ghc-prim"))
            (hsPkgs."hscim" or (errorHandler.buildDepError "hscim"))
            (hsPkgs."hspec" or (errorHandler.buildDepError "hspec"))
            (hsPkgs."hspec-discover" or (errorHandler.buildDepError "hspec-discover"))
            (hsPkgs."hspec-wai" or (errorHandler.buildDepError "hspec-wai"))
            (hsPkgs."http-api-data" or (errorHandler.buildDepError "http-api-data"))
            (hsPkgs."http-client" or (errorHandler.buildDepError "http-client"))
            (hsPkgs."http-client-tls" or (errorHandler.buildDepError "http-client-tls"))
            (hsPkgs."http-media" or (errorHandler.buildDepError "http-media"))
            (hsPkgs."http-types" or (errorHandler.buildDepError "http-types"))
            (hsPkgs."imports" or (errorHandler.buildDepError "imports"))
            (hsPkgs."insert-ordered-containers" or (errorHandler.buildDepError "insert-ordered-containers"))
            (hsPkgs."interpolate" or (errorHandler.buildDepError "interpolate"))
            (hsPkgs."lens" or (errorHandler.buildDepError "lens"))
            (hsPkgs."lens-aeson" or (errorHandler.buildDepError "lens-aeson"))
            (hsPkgs."metrics-core" or (errorHandler.buildDepError "metrics-core"))
            (hsPkgs."metrics-wai" or (errorHandler.buildDepError "metrics-wai"))
            (hsPkgs."mtl" or (errorHandler.buildDepError "mtl"))
            (hsPkgs."network-uri" or (errorHandler.buildDepError "network-uri"))
            (hsPkgs."optparse-applicative" or (errorHandler.buildDepError "optparse-applicative"))
            (hsPkgs."prometheus-client" or (errorHandler.buildDepError "prometheus-client"))
            (hsPkgs."random" or (errorHandler.buildDepError "random"))
            (hsPkgs."raw-strings-qq" or (errorHandler.buildDepError "raw-strings-qq"))
            (hsPkgs."retry" or (errorHandler.buildDepError "retry"))
            (hsPkgs."saml2-web-sso" or (errorHandler.buildDepError "saml2-web-sso"))
            (hsPkgs."scientific" or (errorHandler.buildDepError "scientific"))
            (hsPkgs."servant" or (errorHandler.buildDepError "servant"))
            (hsPkgs."servant-client" or (errorHandler.buildDepError "servant-client"))
            (hsPkgs."servant-multipart" or (errorHandler.buildDepError "servant-multipart"))
            (hsPkgs."servant-server" or (errorHandler.buildDepError "servant-server"))
            (hsPkgs."servant-swagger" or (errorHandler.buildDepError "servant-swagger"))
            (hsPkgs."silently" or (errorHandler.buildDepError "silently"))
            (hsPkgs."spar" or (errorHandler.buildDepError "spar"))
            (hsPkgs."stm" or (errorHandler.buildDepError "stm"))
            (hsPkgs."string-conversions" or (errorHandler.buildDepError "string-conversions"))
            (hsPkgs."swagger2" or (errorHandler.buildDepError "swagger2"))
            (hsPkgs."text" or (errorHandler.buildDepError "text"))
            (hsPkgs."text-latin1" or (errorHandler.buildDepError "text-latin1"))
            (hsPkgs."time" or (errorHandler.buildDepError "time"))
            (hsPkgs."tinylog" or (errorHandler.buildDepError "tinylog"))
            (hsPkgs."transformers" or (errorHandler.buildDepError "transformers"))
            (hsPkgs."types-common" or (errorHandler.buildDepError "types-common"))
            (hsPkgs."unordered-containers" or (errorHandler.buildDepError "unordered-containers"))
            (hsPkgs."uri-bytestring" or (errorHandler.buildDepError "uri-bytestring"))
            (hsPkgs."uuid" or (errorHandler.buildDepError "uuid"))
            (hsPkgs."wai" or (errorHandler.buildDepError "wai"))
            (hsPkgs."wai-extra" or (errorHandler.buildDepError "wai-extra"))
            (hsPkgs."wai-middleware-prometheus" or (errorHandler.buildDepError "wai-middleware-prometheus"))
            (hsPkgs."wai-utilities" or (errorHandler.buildDepError "wai-utilities"))
            (hsPkgs."warp" or (errorHandler.buildDepError "warp"))
            (hsPkgs."warp-tls" or (errorHandler.buildDepError "warp-tls"))
            (hsPkgs."wire-api" or (errorHandler.buildDepError "wire-api"))
            (hsPkgs."x509" or (errorHandler.buildDepError "x509"))
            (hsPkgs."xml-conduit" or (errorHandler.buildDepError "xml-conduit"))
            (hsPkgs."xml-hamlet" or (errorHandler.buildDepError "xml-hamlet"))
            (hsPkgs."xml-lens" or (errorHandler.buildDepError "xml-lens"))
            (hsPkgs."yaml" or (errorHandler.buildDepError "yaml"))
            (hsPkgs."zauth" or (errorHandler.buildDepError "zauth"))
            ];
          buildable = true;
          modules = [
            "Test/LoggingSpec"
            "Test/MetricsSpec"
            "Test/Spar/APISpec"
            "Test/Spar/AppSpec"
            "Test/Spar/DataSpec"
            "Test/Spar/Intra/BrigSpec"
            "Test/Spar/Scim/AuthSpec"
            "Test/Spar/Scim/UserSpec"
            "Util"
            "Util/Core"
            "Util/Scim"
            "Util/Types"
            "Paths_spar"
            ];
          hsSourceDirs = [ "test-integration" ];
          mainPath = [ "Spec.hs" ];
          };
        "spar-schema" = {
          depends = [
            (hsPkgs."HsOpenSSL" or (errorHandler.buildDepError "HsOpenSSL"))
            (hsPkgs."aeson" or (errorHandler.buildDepError "aeson"))
            (hsPkgs."aeson-pretty" or (errorHandler.buildDepError "aeson-pretty"))
            (hsPkgs."aeson-qq" or (errorHandler.buildDepError "aeson-qq"))
            (hsPkgs."base" or (errorHandler.buildDepError "base"))
            (hsPkgs."base64-bytestring" or (errorHandler.buildDepError "base64-bytestring"))
            (hsPkgs."bilge" or (errorHandler.buildDepError "bilge"))
            (hsPkgs."binary" or (errorHandler.buildDepError "binary"))
            (hsPkgs."brig-types" or (errorHandler.buildDepError "brig-types"))
            (hsPkgs."bytestring" or (errorHandler.buildDepError "bytestring"))
            (hsPkgs."bytestring-conversion" or (errorHandler.buildDepError "bytestring-conversion"))
            (hsPkgs."case-insensitive" or (errorHandler.buildDepError "case-insensitive"))
            (hsPkgs."cassandra-util" or (errorHandler.buildDepError "cassandra-util"))
            (hsPkgs."containers" or (errorHandler.buildDepError "containers"))
            (hsPkgs."cookie" or (errorHandler.buildDepError "cookie"))
            (hsPkgs."cryptonite" or (errorHandler.buildDepError "cryptonite"))
            (hsPkgs."data-default" or (errorHandler.buildDepError "data-default"))
            (hsPkgs."email-validate" or (errorHandler.buildDepError "email-validate"))
            (hsPkgs."errors" or (errorHandler.buildDepError "errors"))
            (hsPkgs."exceptions" or (errorHandler.buildDepError "exceptions"))
            (hsPkgs."extended" or (errorHandler.buildDepError "extended"))
            (hsPkgs."extra" or (errorHandler.buildDepError "extra"))
            (hsPkgs."galley-types" or (errorHandler.buildDepError "galley-types"))
            (hsPkgs."ghc-prim" or (errorHandler.buildDepError "ghc-prim"))
            (hsPkgs."hscim" or (errorHandler.buildDepError "hscim"))
            (hsPkgs."http-api-data" or (errorHandler.buildDepError "http-api-data"))
            (hsPkgs."http-client" or (errorHandler.buildDepError "http-client"))
            (hsPkgs."http-client-tls" or (errorHandler.buildDepError "http-client-tls"))
            (hsPkgs."http-media" or (errorHandler.buildDepError "http-media"))
            (hsPkgs."http-types" or (errorHandler.buildDepError "http-types"))
            (hsPkgs."imports" or (errorHandler.buildDepError "imports"))
            (hsPkgs."insert-ordered-containers" or (errorHandler.buildDepError "insert-ordered-containers"))
            (hsPkgs."interpolate" or (errorHandler.buildDepError "interpolate"))
            (hsPkgs."lens" or (errorHandler.buildDepError "lens"))
            (hsPkgs."metrics-core" or (errorHandler.buildDepError "metrics-core"))
            (hsPkgs."metrics-wai" or (errorHandler.buildDepError "metrics-wai"))
            (hsPkgs."mtl" or (errorHandler.buildDepError "mtl"))
            (hsPkgs."network-uri" or (errorHandler.buildDepError "network-uri"))
            (hsPkgs."optparse-applicative" or (errorHandler.buildDepError "optparse-applicative"))
            (hsPkgs."prometheus-client" or (errorHandler.buildDepError "prometheus-client"))
            (hsPkgs."raw-strings-qq" or (errorHandler.buildDepError "raw-strings-qq"))
            (hsPkgs."retry" or (errorHandler.buildDepError "retry"))
            (hsPkgs."saml2-web-sso" or (errorHandler.buildDepError "saml2-web-sso"))
            (hsPkgs."scientific" or (errorHandler.buildDepError "scientific"))
            (hsPkgs."servant" or (errorHandler.buildDepError "servant"))
            (hsPkgs."servant-multipart" or (errorHandler.buildDepError "servant-multipart"))
            (hsPkgs."servant-server" or (errorHandler.buildDepError "servant-server"))
            (hsPkgs."servant-swagger" or (errorHandler.buildDepError "servant-swagger"))
            (hsPkgs."spar" or (errorHandler.buildDepError "spar"))
            (hsPkgs."string-conversions" or (errorHandler.buildDepError "string-conversions"))
            (hsPkgs."swagger2" or (errorHandler.buildDepError "swagger2"))
            (hsPkgs."text" or (errorHandler.buildDepError "text"))
            (hsPkgs."text-latin1" or (errorHandler.buildDepError "text-latin1"))
            (hsPkgs."time" or (errorHandler.buildDepError "time"))
            (hsPkgs."tinylog" or (errorHandler.buildDepError "tinylog"))
            (hsPkgs."transformers" or (errorHandler.buildDepError "transformers"))
            (hsPkgs."types-common" or (errorHandler.buildDepError "types-common"))
            (hsPkgs."unordered-containers" or (errorHandler.buildDepError "unordered-containers"))
            (hsPkgs."uri-bytestring" or (errorHandler.buildDepError "uri-bytestring"))
            (hsPkgs."uuid" or (errorHandler.buildDepError "uuid"))
            (hsPkgs."wai" or (errorHandler.buildDepError "wai"))
            (hsPkgs."wai-middleware-prometheus" or (errorHandler.buildDepError "wai-middleware-prometheus"))
            (hsPkgs."wai-utilities" or (errorHandler.buildDepError "wai-utilities"))
            (hsPkgs."warp" or (errorHandler.buildDepError "warp"))
            (hsPkgs."wire-api" or (errorHandler.buildDepError "wire-api"))
            (hsPkgs."x509" or (errorHandler.buildDepError "x509"))
            (hsPkgs."xml-conduit" or (errorHandler.buildDepError "xml-conduit"))
            (hsPkgs."yaml" or (errorHandler.buildDepError "yaml"))
            ];
          buildable = true;
          modules = [
            "V0"
            "V1"
            "V2"
            "V3"
            "V4"
            "V5"
            "V6"
            "V7"
            "V8"
            "V9"
            "Paths_spar"
            ];
          hsSourceDirs = [ "schema/src" ];
          mainPath = [ "Main.hs" ];
          };
        };
      tests = {
        "spec" = {
          depends = [
            (hsPkgs."HsOpenSSL" or (errorHandler.buildDepError "HsOpenSSL"))
            (hsPkgs."QuickCheck" or (errorHandler.buildDepError "QuickCheck"))
            (hsPkgs."aeson" or (errorHandler.buildDepError "aeson"))
            (hsPkgs."aeson-pretty" or (errorHandler.buildDepError "aeson-pretty"))
            (hsPkgs."aeson-qq" or (errorHandler.buildDepError "aeson-qq"))
            (hsPkgs."base" or (errorHandler.buildDepError "base"))
            (hsPkgs."base64-bytestring" or (errorHandler.buildDepError "base64-bytestring"))
            (hsPkgs."bilge" or (errorHandler.buildDepError "bilge"))
            (hsPkgs."binary" or (errorHandler.buildDepError "binary"))
            (hsPkgs."brig-types" or (errorHandler.buildDepError "brig-types"))
            (hsPkgs."bytestring" or (errorHandler.buildDepError "bytestring"))
            (hsPkgs."bytestring-conversion" or (errorHandler.buildDepError "bytestring-conversion"))
            (hsPkgs."case-insensitive" or (errorHandler.buildDepError "case-insensitive"))
            (hsPkgs."cassandra-util" or (errorHandler.buildDepError "cassandra-util"))
            (hsPkgs."containers" or (errorHandler.buildDepError "containers"))
            (hsPkgs."cookie" or (errorHandler.buildDepError "cookie"))
            (hsPkgs."cryptonite" or (errorHandler.buildDepError "cryptonite"))
            (hsPkgs."data-default" or (errorHandler.buildDepError "data-default"))
            (hsPkgs."email-validate" or (errorHandler.buildDepError "email-validate"))
            (hsPkgs."errors" or (errorHandler.buildDepError "errors"))
            (hsPkgs."exceptions" or (errorHandler.buildDepError "exceptions"))
            (hsPkgs."extended" or (errorHandler.buildDepError "extended"))
            (hsPkgs."extra" or (errorHandler.buildDepError "extra"))
            (hsPkgs."galley-types" or (errorHandler.buildDepError "galley-types"))
            (hsPkgs."ghc-prim" or (errorHandler.buildDepError "ghc-prim"))
            (hsPkgs."hscim" or (errorHandler.buildDepError "hscim"))
            (hsPkgs."hspec" or (errorHandler.buildDepError "hspec"))
            (hsPkgs."hspec-discover" or (errorHandler.buildDepError "hspec-discover"))
            (hsPkgs."http-api-data" or (errorHandler.buildDepError "http-api-data"))
            (hsPkgs."http-client" or (errorHandler.buildDepError "http-client"))
            (hsPkgs."http-client-tls" or (errorHandler.buildDepError "http-client-tls"))
            (hsPkgs."http-media" or (errorHandler.buildDepError "http-media"))
            (hsPkgs."http-types" or (errorHandler.buildDepError "http-types"))
            (hsPkgs."imports" or (errorHandler.buildDepError "imports"))
            (hsPkgs."insert-ordered-containers" or (errorHandler.buildDepError "insert-ordered-containers"))
            (hsPkgs."interpolate" or (errorHandler.buildDepError "interpolate"))
            (hsPkgs."lens" or (errorHandler.buildDepError "lens"))
            (hsPkgs."lens-aeson" or (errorHandler.buildDepError "lens-aeson"))
            (hsPkgs."metrics-core" or (errorHandler.buildDepError "metrics-core"))
            (hsPkgs."metrics-wai" or (errorHandler.buildDepError "metrics-wai"))
            (hsPkgs."mtl" or (errorHandler.buildDepError "mtl"))
            (hsPkgs."network-uri" or (errorHandler.buildDepError "network-uri"))
            (hsPkgs."optparse-applicative" or (errorHandler.buildDepError "optparse-applicative"))
            (hsPkgs."prometheus-client" or (errorHandler.buildDepError "prometheus-client"))
            (hsPkgs."raw-strings-qq" or (errorHandler.buildDepError "raw-strings-qq"))
            (hsPkgs."retry" or (errorHandler.buildDepError "retry"))
            (hsPkgs."saml2-web-sso" or (errorHandler.buildDepError "saml2-web-sso"))
            (hsPkgs."scientific" or (errorHandler.buildDepError "scientific"))
            (hsPkgs."servant" or (errorHandler.buildDepError "servant"))
            (hsPkgs."servant-multipart" or (errorHandler.buildDepError "servant-multipart"))
            (hsPkgs."servant-server" or (errorHandler.buildDepError "servant-server"))
            (hsPkgs."servant-swagger" or (errorHandler.buildDepError "servant-swagger"))
            (hsPkgs."spar" or (errorHandler.buildDepError "spar"))
            (hsPkgs."string-conversions" or (errorHandler.buildDepError "string-conversions"))
            (hsPkgs."swagger2" or (errorHandler.buildDepError "swagger2"))
            (hsPkgs."text" or (errorHandler.buildDepError "text"))
            (hsPkgs."text-latin1" or (errorHandler.buildDepError "text-latin1"))
            (hsPkgs."time" or (errorHandler.buildDepError "time"))
            (hsPkgs."tinylog" or (errorHandler.buildDepError "tinylog"))
            (hsPkgs."transformers" or (errorHandler.buildDepError "transformers"))
            (hsPkgs."types-common" or (errorHandler.buildDepError "types-common"))
            (hsPkgs."unordered-containers" or (errorHandler.buildDepError "unordered-containers"))
            (hsPkgs."uri-bytestring" or (errorHandler.buildDepError "uri-bytestring"))
            (hsPkgs."uuid" or (errorHandler.buildDepError "uuid"))
            (hsPkgs."wai" or (errorHandler.buildDepError "wai"))
            (hsPkgs."wai-middleware-prometheus" or (errorHandler.buildDepError "wai-middleware-prometheus"))
            (hsPkgs."wai-utilities" or (errorHandler.buildDepError "wai-utilities"))
            (hsPkgs."warp" or (errorHandler.buildDepError "warp"))
            (hsPkgs."wire-api" or (errorHandler.buildDepError "wire-api"))
            (hsPkgs."x509" or (errorHandler.buildDepError "x509"))
            (hsPkgs."xml-conduit" or (errorHandler.buildDepError "xml-conduit"))
            (hsPkgs."yaml" or (errorHandler.buildDepError "yaml"))
            ];
          buildable = true;
          modules = [
            "Arbitrary"
            "Test/Spar/APISpec"
            "Test/Spar/DataSpec"
            "Test/Spar/Intra/BrigSpec"
            "Test/Spar/ScimSpec"
            "Test/Spar/TypesSpec"
            "Paths_spar"
            ];
          hsSourceDirs = [ "test" ];
          mainPath = [ "Spec.hs" ];
          };
        };
      };
    } // rec {
    src = (pkgs.lib).mkDefault ./services/spar;
    }