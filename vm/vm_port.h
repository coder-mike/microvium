#pragma once

#include <stdbool.h>
#include <string.h>

#define VM_STACK_SIZE 256

// Offset of field in a struct
#define OFFSETOF(TYPE, ELEMENT) ((size_t)&(((TYPE *)0)->ELEMENT))

#define VM_DOUBLE double
#define VM_DOUBLE_NAN ((double)(INFINITY * 0.0))

#define VM_SAFE_MODE 1

#define VM_PROGMEM_P void*
#define VM_PROGMEM_P_ADD(p, s) ((void*)((uint8_t*)p + (uint16_t)s))
#define VM_PROGMEM_P_SUB(p2, p1) ((size_t)((uint8_t*)p2 - (uint8_t*)p1))
#define VM_READ_PROGMEM(pTarget, pSource, size) memcpy(pTarget, pSource, size)
#define VM_SIZE_T uint8_t

#define VM_PACKED_STRUCT
// #define VM_PACKED_STRUCT __attribute__((__packed__))

#if VM_SAFE_MODE
#define VM_ASSERT(predicate) assert(predicate)
#else
#define VM_ASSERT(predicate)
#endif