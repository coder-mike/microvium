#pragma once

#include <stdbool.h>
#include <string.h>
#include <stdint.h>

#include "allocator.h"

#define MVM_PORT_VERSION 1

/*
These settings are for WASM build. In WASM, memory is allocated in "pages",
where each page is 64kB. For efficiency, this build of Microvium assumes that
we're only using the first page of memory, so it's similar to having an MCU with
64kB of RAM. But this does mean that an application can't really exceed about
32kB of RAM, since during a GC collection, the memory is copied (as in a
semi-space collector).

This WASM library will use 2 pages in total: the first page is the RAM, and the
second page is the "flash" memory, for the snapshot.

Since memory is pre-allocated in WASM, and can only go up in pages, this means
that WASM Microvium will only use exactly 2 pages of memory - no more and no
less.
*/

#define MVM_STACK_SIZE 0x1000

#define MVM_ALLOCATION_BUCKET_SIZE 0x800

// Leaving some space for the stack, globals, etc.
#define MVM_MAX_HEAP_SIZE 0xE000

// The first page is be used for RAM, so there is no offset (most efficient)
#define MVM_USE_SINGLE_RAM_PAGE 1
#define MVM_RAM_PAGE_ADDR 0

#define MVM_MALLOC allocator_malloc
#define MVM_FREE allocator_free

extern void mvm_fatalError(int e);
#define MVM_FATAL_ERROR(vm, e) (mvm_fatalError(e))

#define MVM_LONG_PTR_TYPE void*
