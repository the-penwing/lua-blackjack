# Lua Blackjack

Simple blackjack game written in lua over a weekend.

<img src="./ai-free-badge.svg" width="150">

## Playing the Game

There are 3 ways to install / play the game

- [Running via Lua 5.5.0](#running-via-lua)
- [Nix](#nix)
- [Building the C Wrapper](./c-wrapper/building.md)

### Running via Lua

Requirements

- Lua 5.5 in your path
- src/blackjack.lua on your system

```bash
lua ./blackjack.lua
```

(Some systems require you to use `lua5.5`)

### Nix

**Install**

```bash
nix profile add github:the-penwing/lua-blackjack
blackjack
```

**Uninstall**

```bash
nix profile remove blackjack
```

**Run Without Installation**

```bash
nix run github:the-penwing/lua-blackjack
```

#### Using the Flake (Optional)

1. **Add the game to your ``flake.nix`` inputs:**

```nix
inputs = {
  nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  blackjack-cli.url = "github:the-penwing/lua-blackjack";
};
```

2. **Pass ``inputs.blackjack-cli`` to your outputs and add the package to your system or or home-manager profile:**

```nix
outputs = { self, nixpkgs, blackjack-cli, ... }: {
  # Example Flake Config
  nixosConfigurations."your-hostname" = nixpkgs.lib.nixosSystem {
    inherit system;
    modules = [
      ({ pkgs, ... }: {
        enviroment.systemPackages = [
          blackjack-cli.packages.${system}.default
        ];
      })
    ];
  };
};
```
