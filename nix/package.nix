{pkgs}:
pkgs.stdenv.mkDerivation {
  pname = "lua-blackjack";
  version = "0.1.0";

  src = pkgs.lib.fileset.toSource {
    root = ../.;
    fileset = pkgs.lib.fileset.unions [
      ../src
    ];
  };

  nativeBuildInputs = [pkgs.makeWrapper];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/lua-blackjack $out/bin
    cp -r src/* $out/share/lua-blackjack/

    makeWrapper ${pkgs.lua5_5}/bin/lua $out/bin/lua-blackjack \
      --add-flags "$out/share/lua-blackjack/blackjack.lua" \
      --set LUA_PATH "$out/share/lua-blackjack/?.lua;$out/share/lua-blackjack/?/init.lua;;"
  '';

  meta = {
    description = "A CLI Blackjack Game - written in Lua over a weekend";
    license = pkgs.lib.licenses.agpl3Only;
    maintainers = [
      {
        name = "Ben van Leeuwen";
        email = "benvanleeuwen01@gmail.com";
        github = "the-penwing";
      }
    ];
  };
}
