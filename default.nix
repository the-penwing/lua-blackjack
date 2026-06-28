{
  pkgs,
  lib,
  stdenv,
  ...
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "blackjack-cli";
  version = "0.1.0";

  src = ./.;

  nativeBuildInputs = with pkgs; [
    zig
    lua5_5
    xxd
    coreutils
  ];
  buildInputs = with pkgs; [
    coreutils
    lua5_5
  ];

  buildPhase = ''
    mkdir .build
    cp c-wrapper/blackjack.c .build
    cp src/blackjack.lua .build
    cd .build
    luac -s -o blackjack.luac blackjack.lua
    xxd -i blackjack.luac blackjack.h
    zig cc -O2 -I ${pkgs.lua5_5}/include -L ${pkgs.lua5_5}/lib -o blackjack blackjack.c -llua -lm
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv blackjack $out/bin/blackjack-cli
  '';

  meta = {
    description = "Blackjack in The Terminal";
    homepage = "github.com/the-penwing/lua-blackjack";
    license = lib.licenses.mit;
  };
})
