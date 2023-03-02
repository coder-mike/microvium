/**
 * @file
 *
 * This is a minimalist heap implementation to use a fixed-size 64kB block. It's
 * assumed that this chunk of memory is pre-allocated at address 0.
 *
 * Each block has a 2-byte block header that holds the size of the block
 * (including header) or null to indicate the terminating block. The low bit of
 * the header indicates whether the block is used or not - 0 means free.
 */

#include "allocator.h"

#include <stdint.h>
#include <stdbool.h>

#include "../native-vm/microvium_internals.h"

#define ALLOCATOR_START_ADDR ((void*)ALLOCATOR_PAGE)
static void* const allocatorStartAddr = ALLOCATOR_START_ADDR;

#define WORD_AT(vm, offset) (*((uint16_t*)((intptr_t)ALLOCATOR_START_ADDR + offset)))

// Bit of a hack
#define assert(x) VM_ASSERT(0, x)

void allocator_init(void* ramStart, size_t ramSize) {
  // This allocator has been design to use exactly one page of memory, starting
  // at a fixed address which is page-aligned.
  assert(ramStart == ALLOCATOR_START_ADDR);
  assert(ramSize == 0x10000);

  memset(allocatorStartAddr, 0, 0x10000);

  WORD_AT(vm, 0x0) = 0xFFFE; // First bucket
  WORD_AT(vm, 0xFFFE) = 0; // Terminates link list of allocations

  allocator_checkHeap();
}

void allocator_deinit() {
}

void* allocator_malloc(size_t size) {
  // allocator_checkHeap();

  void* result = NULL;
  // The needed of the block needed. Blocks have even sizes since the last bit is
  // used as a flag. Blocks have an extra 2 bytes for their header
  uint16_t needed = (size + 3) & 0xFFFE;
  if (needed < size) goto EXIT; // Size overflowed

  uint16_t* p = &WORD_AT(vm, 0x0);
  uint16_t* prevUnused = NULL;
  while (*p) {
    uint16_t header = *p;
    bool used = header & 1;
    uint16_t blockSize = header & 0xFFFE;
    if (!used) {
      // 2 contiguous blocks are free. Combine them.
      if (prevUnused) {
        blockSize += *prevUnused;
        p = prevUnused; // Try the previous block again, now that it's bigger
        *p = blockSize;
        prevUnused = NULL;
      }

      if (blockSize >= needed) { // Big enough?
        uint16_t remainingSize = blockSize - needed;
        if (remainingSize >= 64) {
          // Break the block up
          uint16_t* nextBlock = (uint16_t*)((intptr_t)p + needed);
          *p = needed;
          *nextBlock = remainingSize;
        }
        *p |= 1;
        p += 1;
        memset(p, 0xDA, needed - 2);
        result = p;
        goto EXIT;
      } else { // Not used but not big enough
        prevUnused = p;
      }
    } else {
      prevUnused = NULL;
    }
    p = (uint16_t*)((intptr_t)p + blockSize);
  }
EXIT:
  allocator_checkHeap();
  return result;
}

void allocator_free(void* ptr) {
  assert((intptr_t)ptr - (intptr_t)ALLOCATOR_START_ADDR < 0x10000);
  uint16_t* p = (uint16_t*)ptr;
  p--; // Go to header
  assert((*p & 1) == 1); // Check that it's not already freed
  *p &= 0xFFFE; // Flag it to be unused
  uint16_t size = *p;
  memset(p + 1, 0xDB, size - 2);
  allocator_checkHeap();
}

void allocator_checkHeap() {
  uint16_t* start = &WORD_AT(vm, 0x0);
  uint16_t* end = &WORD_AT(vm, 0xFFFE);
  uint16_t* p = start;
  while (*p) {
    assert((p >= start) && (p <= end));
    p = (uint16_t*)((intptr_t)p + (*p & 0xFFFE));
  }
  assert(p == end);
}