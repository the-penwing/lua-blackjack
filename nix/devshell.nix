{pkgs}:
pkgs.mkShell {
  name = "lua-blackjack";
  nativeBuildInputs = [pkgs.lua5_5];
}
