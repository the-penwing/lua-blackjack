{pkgs}:
pkgs.mkShell {
  name = "lua-blackjack";
  nativeBuildInputs = [pkgs.lua5_3 pkgs.lua53Packages.tl];
}
