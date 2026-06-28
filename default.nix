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
  ];
  buildInputs = with pkgs; [
    lua5_5
    coreutils
  ];

  buildPhase = ''
    luac -s -o blackjack.luac blackjack.lua
    xxd -i blackjack.luac blackjack_bytecode.h
    zig cc -O2 -I ${pkgs.lua5_5}/include -L ${pkgs.lua5_5}/lib -o blackjack blackjack.c -llua -lm
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv blackjack $out/bin/blackjack
  '';

  meta = {
    description = "Blackjack in the terminal";
    homepage = "github.com/the-penwing/lua-blackjack";
    license = lib.licenses.mit;
  };
})
