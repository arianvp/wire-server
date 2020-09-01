let
  sources = import ./sources.nix;
in
import sources.nixpkgs {
  overlays = [
    (self: _: { niv = (import sources.niv { pkgs = self; }).niv; })
    (import ./overlays/wire-server.nix)
  ] ++ (import sources."haskell.nix" {}).overlays;
}
