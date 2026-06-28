{
  description = "blackjack-cli - Blackjack For The Terminal";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        packages.default = pkgs.callPackage ./default.nix {};
        packages.blackjack-cli = self.packages.${system}.default;
      }
    )
    // {
      # Allow this flake to be used as an input
      overlays.default = final: prev: {
        blackjack-cli = final.callPackage ./default.nix {};
      };
    };
}
