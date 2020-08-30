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
      identifier = { name = "wire-api"; version = "0.1.0"; };
      license = "AGPL-3.0-only";
      copyright = "(c) 2020 Wire Swiss GmbH";
      maintainer = "Wire Swiss GmbH <backend@wire.com>";
      author = "Wire Swiss GmbH";
      homepage = "";
      url = "";
      synopsis = "";
      description = "API types of the Wire collaboration platform";
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
          (hsPkgs."QuickCheck" or (errorHandler.buildDepError "QuickCheck"))
          (hsPkgs."aeson" or (errorHandler.buildDepError "aeson"))
          (hsPkgs."attoparsec" or (errorHandler.buildDepError "attoparsec"))
          (hsPkgs."base" or (errorHandler.buildDepError "base"))
          (hsPkgs."base64-bytestring" or (errorHandler.buildDepError "base64-bytestring"))
          (hsPkgs."bytestring" or (errorHandler.buildDepError "bytestring"))
          (hsPkgs."bytestring-conversion" or (errorHandler.buildDepError "bytestring-conversion"))
          (hsPkgs."case-insensitive" or (errorHandler.buildDepError "case-insensitive"))
          (hsPkgs."cassandra-util" or (errorHandler.buildDepError "cassandra-util"))
          (hsPkgs."containers" or (errorHandler.buildDepError "containers"))
          (hsPkgs."cryptonite" or (errorHandler.buildDepError "cryptonite"))
          (hsPkgs."currency-codes" or (errorHandler.buildDepError "currency-codes"))
          (hsPkgs."email-validate" or (errorHandler.buildDepError "email-validate"))
          (hsPkgs."errors" or (errorHandler.buildDepError "errors"))
          (hsPkgs."exceptions" or (errorHandler.buildDepError "exceptions"))
          (hsPkgs."extra" or (errorHandler.buildDepError "extra"))
          (hsPkgs."generic-random" or (errorHandler.buildDepError "generic-random"))
          (hsPkgs."hashable" or (errorHandler.buildDepError "hashable"))
          (hsPkgs."hostname-validate" or (errorHandler.buildDepError "hostname-validate"))
          (hsPkgs."imports" or (errorHandler.buildDepError "imports"))
          (hsPkgs."iproute" or (errorHandler.buildDepError "iproute"))
          (hsPkgs."iso3166-country-codes" or (errorHandler.buildDepError "iso3166-country-codes"))
          (hsPkgs."iso639" or (errorHandler.buildDepError "iso639"))
          (hsPkgs."lens" or (errorHandler.buildDepError "lens"))
          (hsPkgs."memory" or (errorHandler.buildDepError "memory"))
          (hsPkgs."mime" or (errorHandler.buildDepError "mime"))
          (hsPkgs."network-uri" or (errorHandler.buildDepError "network-uri"))
          (hsPkgs."pem" or (errorHandler.buildDepError "pem"))
          (hsPkgs."protobuf" or (errorHandler.buildDepError "protobuf"))
          (hsPkgs."quickcheck-instances" or (errorHandler.buildDepError "quickcheck-instances"))
          (hsPkgs."random" or (errorHandler.buildDepError "random"))
          (hsPkgs."safe" or (errorHandler.buildDepError "safe"))
          (hsPkgs."string-conversions" or (errorHandler.buildDepError "string-conversions"))
          (hsPkgs."swagger" or (errorHandler.buildDepError "swagger"))
          (hsPkgs."text" or (errorHandler.buildDepError "text"))
          (hsPkgs."time" or (errorHandler.buildDepError "time"))
          (hsPkgs."transformers" or (errorHandler.buildDepError "transformers"))
          (hsPkgs."types-common" or (errorHandler.buildDepError "types-common"))
          (hsPkgs."unordered-containers" or (errorHandler.buildDepError "unordered-containers"))
          (hsPkgs."uri-bytestring" or (errorHandler.buildDepError "uri-bytestring"))
          (hsPkgs."uuid" or (errorHandler.buildDepError "uuid"))
          ];
        buildable = true;
        modules = [
          "Paths_wire_api"
          "Wire/API/Arbitrary"
          "Wire/API/Asset"
          "Wire/API/Asset/V3"
          "Wire/API/Asset/V3/Resumable"
          "Wire/API/Call/Config"
          "Wire/API/Connection"
          "Wire/API/Conversation"
          "Wire/API/Conversation/Bot"
          "Wire/API/Conversation/Code"
          "Wire/API/Conversation/Member"
          "Wire/API/Conversation/Role"
          "Wire/API/Conversation/Typing"
          "Wire/API/CustomBackend"
          "Wire/API/Event/Conversation"
          "Wire/API/Event/Team"
          "Wire/API/Message"
          "Wire/API/Message/Proto"
          "Wire/API/Notification"
          "Wire/API/Properties"
          "Wire/API/Provider"
          "Wire/API/Provider/Bot"
          "Wire/API/Provider/External"
          "Wire/API/Provider/Service"
          "Wire/API/Provider/Service/Tag"
          "Wire/API/Push/Token"
          "Wire/API/Push/V2/Token"
          "Wire/API/Swagger"
          "Wire/API/Team"
          "Wire/API/Team/Conversation"
          "Wire/API/Team/Feature"
          "Wire/API/Team/Invitation"
          "Wire/API/Team/LegalHold"
          "Wire/API/Team/LegalHold/External"
          "Wire/API/Team/Member"
          "Wire/API/Team/Permission"
          "Wire/API/Team/Role"
          "Wire/API/Team/SearchVisibility"
          "Wire/API/User"
          "Wire/API/User/Activation"
          "Wire/API/User/Auth"
          "Wire/API/User/Client"
          "Wire/API/User/Client/Prekey"
          "Wire/API/User/Handle"
          "Wire/API/User/Identity"
          "Wire/API/User/Password"
          "Wire/API/User/Profile"
          "Wire/API/User/RichInfo"
          "Wire/API/User/Search"
          ];
        hsSourceDirs = [ "src" ];
        };
      tests = {
        "wire-api-tests" = {
          depends = [
            (hsPkgs."aeson" or (errorHandler.buildDepError "aeson"))
            (hsPkgs."aeson-qq" or (errorHandler.buildDepError "aeson-qq"))
            (hsPkgs."base" or (errorHandler.buildDepError "base"))
            (hsPkgs."bytestring-conversion" or (errorHandler.buildDepError "bytestring-conversion"))
            (hsPkgs."containers" or (errorHandler.buildDepError "containers"))
            (hsPkgs."imports" or (errorHandler.buildDepError "imports"))
            (hsPkgs."lens" or (errorHandler.buildDepError "lens"))
            (hsPkgs."tasty" or (errorHandler.buildDepError "tasty"))
            (hsPkgs."tasty-expected-failure" or (errorHandler.buildDepError "tasty-expected-failure"))
            (hsPkgs."tasty-hunit" or (errorHandler.buildDepError "tasty-hunit"))
            (hsPkgs."tasty-quickcheck" or (errorHandler.buildDepError "tasty-quickcheck"))
            (hsPkgs."types-common" or (errorHandler.buildDepError "types-common"))
            (hsPkgs."unordered-containers" or (errorHandler.buildDepError "unordered-containers"))
            (hsPkgs."wire-api" or (errorHandler.buildDepError "wire-api"))
            ];
          buildable = true;
          modules = [
            "Test/Wire/API/Call/Config"
            "Test/Wire/API/Roundtrip/Aeson"
            "Test/Wire/API/Roundtrip/ByteString"
            "Test/Wire/API/Team/Member"
            "Test/Wire/API/User"
            "Test/Wire/API/User/RichInfo"
            "Paths_wire_api"
            ];
          hsSourceDirs = [ "test/unit" ];
          mainPath = [ "Main.hs" ];
          };
        };
      };
    } // rec {
    src = (pkgs.lib).mkDefault ./libs/wire-api;
    }