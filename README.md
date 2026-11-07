# Lua Blackjack

Simple blackjack game written in lua over a weekend.

<img src="./ai-free-badge.svg" width="150">

## Playing the Game

There are 3 ways to install / play the game

- [Running via Lua](#running-via-lua)
- [Nix](#nix)
- [Building the C Wrapper](./c-wrapper/building.md)

### Running via Lua

Requirements

- Lua 5.3 in your path
- Teal in your path (`luarocks install tl`)

```shell
git clone https://github.com/the-penwing/lua-blackjack.git
cd lua-blackjack
tl run src/blackjack.tl
```

### Nix

**Install**

```shell
nix profile add github:the-penwing/lua-blackjack
blackjack
```

**Uninstall**

```shell
nix profile remove blackjack
```

**Run Without Installation**

```shell
nix run github:the-penwing/lua-blackjack
```

#### Using the Flake (Optional)

1. **Add the game to your `flake.nix` inputs:**

```nix
inputs = {
  nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  blackjack-cli.url = "github:the-penwing/lua-blackjack";
};
```

2. **Pass `inputs.lua-blackjack` to your outputs and add the package to your system or or home-manager profile:**

```nix
outputs = { self, nixpkgs, lua-blackjack, ... }: {
  # Example Flake Config
  nixosConfigurations."your-hostname" = nixpkgs.lib.nixosSystem {
    inherit system;
    modules = [
      ({ pkgs, ... }: {
        enviroment.systemPackages = [
          lua-blackjack.packages.${system}.default
        ];
      })
    ];
  };
};
```
