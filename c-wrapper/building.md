# Building the Game

## Requirements

- **C compiler** (gcc, clang, or zig cc)
- **Lua 5.5.0 source**

## Setup (One-Time)

Download and extract Lua 5.5.0:

```bash
curl -L -R -O https://www.lua.org/ftp/lua-5.5.0.tar.gz
tar zxf lua-5.5.0.tar.gz
```

## Manual Build

### 1. Compile to bytecode

```bash
luac -s -o blackjack.luac blackjack.lua
```

### 2. Convert bytecode to C header

```bash
xxd -i blackjack.luac blackjack.h
```

### 3. Build Lua library

```bash
cd ../lua-5.5.0
make all
cd ../c-wrapper
```

### 4. Compile the game

```bash
mkdir -p bin
gcc -O2 \
  -I ../lua-5.5.0/src \
  -L ../lua-5.5.0/src \
  -o bin/blackjack \
  blackjack.c \
  -llua -lm
```

Binary is at `bin/blackjack`.
