#!/bin/bash
set -e

CC="clang \
	--target=wasm32 \
	-nostdlib \
	-O3 \
	-I . \
	-I ./clib -Werror \
	-nostdlib \
	-mbulk-memory"


$CC -o build/microvium.o -c ../native-vm/microvium.c
$CC -o build/allocator.o -c allocator.c
$CC -o build/clib.o -c clib/clib.c

wasm-ld-15 \
	--no-entry \
	--export-all \
	--lto-O3 \
	--allow-undefined \
	--import-memory \
	--Map microvium.map \
	-o microvium.wasm \
	--global-base=0 \
	build/allocator.o \
	build/microvium.o \
	build/clib.o

# Requires `npm install -g wat-wasm``
wasm2wat microvium.wasm