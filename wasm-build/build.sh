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


$CC -o /tmp/microvium.o -c ../native-vm/microvium.c
$CC -o /tmp/allocator.o -c allocator.c
$CC -o /tmp/clib.o -c clib/clib.c

wasm-ld-15 \
	--no-entry \
	--export-all \
	--lto-O3 \
	--allow-undefined \
	--import-memory \
	-o microvium.wasm \
	/tmp/microvium.o \
	/tmp/clib.o \
	/tmp/allocator.o

# Requires `npm install -g wat-wasm``
wasm2wat microvium.wasm