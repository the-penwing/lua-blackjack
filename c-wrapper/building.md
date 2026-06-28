# Building the Game

## Requirements

- **C compiler** (gcc or clang is often included with Linux and OSX based systems)
- **xxd** (Available from most package managers)
- **Lua 5.5.0 source**

## Setup (One-Time)

Download and extract Lua 5.5.0 to the same folder as the repository:

```bash
curl -L -R -O https://www.lua.org/ftp/lua-5.5.0.tar.gz
tar zxf lua-5.5.0.tar.gz
```

Your directory structure should look like this
```
├── lua-5.5.0/
└── lua-blackjack
    ├── c-wrapper/
    │   ├── blackjack-cli.c
    │   └── building.md
    ├── src/
    │   └── blackjack.lua
    ├── README.md
    └── LICENSE
```

## Manual Build

### Run these commands inside the ``c-wrapper`` directory:

1. **Compile to bytecode**

```bash
luac -s -o blackjack.luac ../src/blackjack.lua
```

2. **Convert bytecode to C header**

```bash
xxd -i blackjack.luac blackjack.h
```

3. **Build Lua headers**

```bash
cd ../../lua-5.5.0
make all
cd ../lua-blackjack/c-wrapper
```

4. **Compile the game**

```bash
mkdir -p bin
gcc -O2 \
  -I ../../lua-5.5.0/src \
  -L ../../lua-5.5.0/src \
  -o bin/blackjack-cli \
  blackjack-cli.c \
  -llua -lm
```

Binary is built at `bin/blackjack-cli`.
