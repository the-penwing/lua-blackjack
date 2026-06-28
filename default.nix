{
  pkgs,
  lib,
  stdenv,
  target ? null,
  sdkRoot ? null,
  ...
}: let
  isWindows = lib.hasInfix "windows" targetName;
  targetName =
    if target != null
    then target
    else stdenv.hostPlatform.config;
  binarySuffix =
    if isWindows
    then ".exe"
    else "";
in
  stdenv.mkDerivation (finalAttrs: (
    {
      pname = "blackjack-cli";
      version = "0.1.0";

      src = ./.;

      nativeBuildInputs = with pkgs; [
        zig
        lua5_5
        xxd
        coreutils
        gnumake
      ];

      buildPhase = ''
            runHook preBuild

            mkdir -p .build
            cp c-wrapper/blackjack-cli.c .build/
            cp src/blackjack.lua .build/

            cd .build

            luac -s -o blackjack.luac blackjack.lua
            xxd -i blackjack.luac > blackjack.h

            # Fast track: Copy the pre-fetched source directory directly instead of untarring
            mkdir -p lua
            tar -xf ${pkgs.lua5_5.src} --strip-components=1 -C lua
            chmod -R +w lua/
            # -O3 for maximum execution speed, -s to completely strip binary sizes
            ZIG_FLAGS="-O3 -s"
            if [ -n "''${target-}" ]; then
              ZIG_FLAGS="$ZIG_FLAGS -target $target"
            fi

            # Specific flag requirement for the 32-bit iSH target
            if [[ "$target" == "x86-linux-musl" ]]; then
              ZIG_FLAGS="$ZIG_FLAGS -mcpu=i686"
            fi

            if [ -n "''${sdkRoot-}" ]; then
              ZIG_FLAGS="$ZIG_FLAGS -isysroot $sdkRoot"
              ZIG_FLAGS="$ZIG_FLAGS -mmacosx-version-min=11.0"
            fi

            echo "Generating temporary Makefile for parallel Lua compilation..."
            cat << 'EOF' > lua/src/Makefile
        SRCS = lapi.c lcode.c lctype.c ldebug.c ldo.c ldump.c lfunc.c lgc.c llex.c \
               lmem.c lobject.c lopcodes.c lparser.c lstate.c lstring.c ltable.c ltm.c \
               lundump.c lvm.c lzio.c lauxlib.c lbaselib.c lcorolib.c ldblib.c liolib.c \
               lmathlib.c loadlib.c loslib.c lstrlib.c ltablib.c lutf8lib.c linit.c
        OBJS = $(SRCS:.c=.o)

        all: liblua.a

        %.o: %.c
        	zig cc $(ZIG_FLAGS) -c $< -o $@

        liblua.a: $(OBJS)
        	zig ar rcs liblua.a $(OBJS)
        EOF

            echo "Building static Lua core for $targetName in parallel..."
            export ZIG_FLAGS
            make -C lua/src -j8

            echo "Linking blackjack-cli..."
            LINK_FLAGS="-lm"
            if [[ "$ZIG_FLAGS" == *"windows"* ]]; then
              LINK_FLAGS="-lws2_32"
            fi
            if [[ "$ZIG_FLAGS" == *"musl"* ]]; then
              LINK_FLAGS="-static -lm"
            fi

            zig cc $ZIG_FLAGS -I lua/src -o "blackjack-cli${binarySuffix}" blackjack-cli.c lua/src/liblua.a $LINK_FLAGS

            # Land back in root source folder so Nix tears down the phase cleanly
            cd ..

            runHook postBuild
      '';
      installPhase = ''
        mkdir -p $out/bin
        mv .build/blackjack-cli${binarySuffix} $out/bin/
      '';
    }
    // (lib.optionalAttrs (target != null) {inherit target;})
    // (lib.optionalAttrs (sdkRoot != null) {inherit sdkRoot;})
  ))
