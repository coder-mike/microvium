/*
 * This is an allocator (heap implementation) that just pre-allocates a full
 * 64kB page from the OS (currently only Windows) and then implements
 * malloc/free within that 64kB page.
 *
 * The reason for this is twofold:
 *
 *   1. For debugging purposes. It's helpful if the VM memory is always at the
 *      same address, and aligned such that the ShortPtr values directly reflect
 *      the machine address.
 *
 *   2. It emulates something like an ARM 32-bit architecture where there may be
 *      less than 64kB of RAM but it's all in the same memory page (generally).
 */

#pragma once

#include <stddef.h>

#define ALLOCATOR_HIGH_BITS 0x5555

#ifdef __cplusplus
extern "C" {
#endif

void allocator_init();
void allocator_deinit();
void* allocator_malloc(size_t size);
void allocator_free(void* ptr);
void allocator_checkHeap();

#ifdef __cplusplus
} //extern "C"
#endif
