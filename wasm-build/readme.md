# WASM Build

Note: although I'm on Windows, I'm using WSL (Ubuntu) to build because the installation instructions for Clang seems simpler on Ubuntu.

The WASM build of Microvium uses **Clang** directly, not Emscripten, Emscripten apparently adds a bunch of extra stuff, and I wanted to keep the build output small (that's what Microvium's all about!). But also, Microvium is much more efficient if it can be compiled to execute in a single, pre-defined page of RAM, and I felt that this would be easier to control with Clang than with Emscripten.

The steps here are inspired by [https://github.com/ern0/howto-wasm-minimal](https://github.com/ern0/howto-wasm-minimal).


## Environment Setup

I used this command to install llvm:

```sh
sudo bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)"
```

I also installed clang using `sudo apt install clang`. Honestly I'm not sure if this is required.


## Building

```sh
cd wasm-build
./build.sh
```
