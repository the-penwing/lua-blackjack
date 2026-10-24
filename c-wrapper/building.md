# Building the Game

## Requirements

- **C compiler** (gcc or clang is often included with Linux and OSX based systems)
- **xxd** (Available from most package managers)
- **Teal** (Available from luarocks or some package managers)
- **Lua 5.3.6 source**

## Setup (One-Time)

Download and extract Lua 5.3.6 to the same folder as the repository:

```bash
curl -L -R -O https://www.lua.org/ftp/lua-5.3.6.tar.gz
tar zxf lua-5.3.6.tar.gz
```

Your directory structure should look like this

```
├── lua-5.3.6/
└── lua-blackjack
    ├── c-wrapper/
    │   ├── blackjack-cli.c
    │   └── building.md
    ├── src/
    │   └── blackjack.tl
    ├── README.md
    └── LICENSE
```

## Manual Build

### Run these commands inside the `c-wrapper` directory:

1. **Transpile to Lua**

```bash
tl gen ../src/blackjack.tl
```

2. **Compile to bytecode**

```bash
luac -s -o blackjack.luac blackjack.lua
```

3. **Convert bytecode to C header**

```bash
xxd -i blackjack.luac blackjack.h
```

4. **Build Lua headers**

```bash
cd ../../lua-5.3.6
make all
cd ../lua-blackjack/c-wrapper
```

5. **Compile the game**

```bash
mkdir -p bin
gcc -O2 \
  -I ../../lua-5.3.6/src \
  -L ../../lua-5.3.6/src \
  -o bin/blackjack-cli \
  blackjack-cli.c \
  -llua -lm
```

Binary is built at `bin/blackjack-cli`.
