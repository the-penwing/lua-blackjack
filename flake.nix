{
  description = "Multi-architecture cross-compilation pipeline for Blackjack CLI";

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
        pkgs = import nixpkgs {inherit system;};

        # Automatically grab the SDK path from the host machine's environment
        envSdkRoot = builtins.getEnv "SDKROOT";
        macOsSdk =
          if envSdkRoot != ""
          then envSdkRoot
          else null;

        # Helper function to spawn architecture-specific derivations
        makeTarget = target: sdk:
          pkgs.callPackage ./default.nix {
            inherit target;
            sdkRoot = sdk;
          };
      in {
        packages = {
          # Individual Architecture Matrix Targets
          linux-x86_64 = makeTarget "x86_64-linux-gnu" null;
          linux-arm64 = makeTarget "aarch64-linux-gnu" null;
          linux-x86_64-musl = makeTarget "x86_64-linux-musl" null;
          linux-arm64-musl = makeTarget "aarch64-linux-musl" null;
          linux-x86-musl = makeTarget "x86-linux-musl" null;

          macos-x86_64 = makeTarget "x86_64-macos" macOsSdk;
          macos-arm64 = makeTarget "aarch64-macos" macOsSdk;

          windows-x86_64 = makeTarget "x86_64-windows-gnu" null;
          windows-arm64 = makeTarget "aarch64-windows-gnu" null;

          # Default package to build/run on the host system natively
          default = makeTarget system null;

          # Mega-target linkFarm to evaluate and compile all 9 targets in parallel
          all = pkgs.linkFarm "blackjack-all-targets" [
            {
              name = "linux-x86_64";
              path = self.packages.${system}.linux-x86_64;
            }
            {
              name = "linux-arm64";
              path = self.packages.${system}.linux-arm64;
            }
            {
              name = "linux-x86_64-musl";
              path = self.packages.${system}.linux-x86_64-musl;
            }
            {
              name = "linux-arm64-musl";
              path = self.packages.${system}.linux-arm64-musl;
            }
            {
              name = "linux-x86-musl";
              path = self.packages.${system}.linux-x86-musl;
            }
            {
              name = "macos-x86_64";
              path = self.packages.${system}.macos-x86_64;
            }
            {
              name = "macos-arm64";
              path = self.packages.${system}.macos-arm64;
            }
            {
              name = "windows-x86_64";
              path = self.packages.${system}.windows-x86_64;
            }
            {
              name = "windows-arm64";
              path = self.packages.${system}.windows-arm64;
            }
          ];
        };

        # Defines what happens when a user types 'nix run'
        apps.default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/blackjack-cli";
        };

        # DevShell environment for raw local hacking
        devShells.default = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            zig
            lua5_5
            xxd
            gnumake
          ];
          shellHook = ''
            echo "⚡ Blackjack cross-compilation shell active ⚡"
            echo "SDKROOT detected: ${
              if macOsSdk != null
              then macOsSdk
              else "None (macOS targets will fail to link)"
            }"
          '';
        };
      }
    );
}
