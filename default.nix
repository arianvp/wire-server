{
  # Fetch haskell.nix and import its default.nix
  haskellNix ? import (builtins.fetchTarball "https://github.com/input-output-hk/haskell.nix/archive/3250b6cc7b9502fbf89de5f535214cd8f6326205.tar.gz") {}

  # haskell.nix provides access to the nixpkgs pins which are used by our CI,
  # hence you will be more likely to get cache hits when using these.
  # But you can also just use your own, e.g. '<nixpkgs>'.
, nixpkgsSrc ? haskellNix.sources.nixpkgs-2003

  # haskell.nix provides some arguments to be passed to nixpkgs, including some
  # patches and also the haskell.nix functionality itself as an overlay.
, nixpkgsArgs ? haskellNix.nixpkgsArgs

  # import nixpkgs with overlays
, pkgs ? import nixpkgsSrc nixpkgsArgs
, sources ? import ./nix/sources.nix
, gitignore ? import sources.gitignore { inherit (pkgs) lib; }
}:

pkgs.haskell-nix.stackProject {
  src = gitignore.gitignoreSource ./.;
  # 'cleanGit' cleans a source directory based on the files known by git
  ignorePackageYaml = true;

  modules = [ { packages.types-common-journal.components.library.build-tools = [ pkgs.protobuf ]; } ];

  stack-sha256 = "01wz591llbi8fdzlk34g6ikv3kid8fyc938848lmz2k6zv0z6cdq";
  materialized = ./nix/stack;
}
