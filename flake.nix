{
  description = "Haskell development shell";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs =
    {
      self,
      flake-utils,
      nixpkgs,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        inherit (pkgs) haskellPackages;
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with haskellPackages; [
            cabal-install
            ghc
            hoogle
            cabal2nix
          ];
        };
      }
    );
}
