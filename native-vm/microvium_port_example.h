/*

# Instructions

Make a copy of this file and name it exactly `microvium_port.h`. Put the copy somewhere
in your project where it is accessible by a `#include "microvium_port.h"` directive.

Customize your copy of the port file with platform-specific configurations.

The recommended workflow is to keep the vm source files separate from your
custom port file, so that you can update the vm source files regularly with bug
fixes and improvement from the original github or npm repository.

*/
#pragma once

#include <stdbool.h>
#include <string.h>
#include <assert.h>
#include <stdint.h>

/**
 * The version of the port interface that this file is implementing.
 */
#define MVM_PORT_VERSION 1

/**
 * Number of bytes to use for the stack.
 *
 * Note: the that stack is fixed-size, even though the heap grows dynamically
 * as-needed.
 */
#define MVM_STACK_SIZE 256

/**
 * When more space is needed for the VM heap, the VM will malloc blocks with a
 * minimum of this size from the host.
 *
 * Note that the VM can also allocate blocks larger than this. It will do so if
 * it needs a larger contiguous space than will fit in a standard block, and
 * also during heap compaction (`runGC`) where it defragments the heap into as
 * few mallocd blocks as possible to make access more efficient.
 */
#define MVM_ALLOCATION_BUCKET_SIZE 256

/**
 * The maximum size of the virtual heap before an MVM_E_OUT_OF_MEMORY error is
 * given.
 *
 * When the VM reaches this level, it will first try to perform a garbage
 * collection cycle. If a GC cycle does not free enough memory, a fatal
 * MVM_E_OUT_OF_MEMORY error is given.
 *
 * Note: this is the space in the virtual heap (the amount consumed by
 * allocations in the VM), not the physical space mallocd from the host, the
 * latter of which can peak at roughly twice the virtual space during a garbage
 * collection cycle in the worst case.
 */
#define MVM_MAX_HEAP_SIZE 1024

/**
 * Set to 1 if a `void*` pointer is natively 16-bit (e.g. if compiling for
 * 16-bit architectures). This allows some optimizations since then a native
 * pointer can fit in a Microvium value slot.
 */
#define MVM_NATIVE_POINTER_IS_16_BIT 0
/**
 * Set to 1 to compile in support for floating point operations (64-bit). This
 * adds significant cost in smaller devices, but is required if you want the VM
 * to be compliant with the ECMAScript standard.
 *
 * When float support is disabled, operations on floats will throw.
 */
#define MVM_SUPPORT_FLOAT 1

/**
 * Set to 1 to enable overflow checking for 32 bit integers in compliance with
 * ES262 standard. If set to 0, then operations on 32-bit integers have
 * wrap-around behavior. Wrap around behavior is faster and the Microvium
 * runtime is smaller.
 */
#define MVM_PORT_INT32_OVERFLOW_CHECKS 0

#if MVM_SUPPORT_FLOAT

/**
 * The type to use for double-precision floating point. Note that anything other
 * than an IEEE 754 double-precision float is not compliant with the ECMAScript
 * spec and results may not always be as expected. Also remember that the
 * bytecode is permitted to have floating point literals embedded in it, and
 * these must match the exact format specification used here if doubles are to
 * persist correctly across a snapshot.
 *
 * Note that on some embedded systems, the `double` type is actually 32-bit, so
 * this may need to be `long double` or whatever the equivalent 64-bit type is
 * on your system.
 */
#define MVM_FLOAT64 double

/**
 * Value to use for NaN
 */
#define MVM_FLOAT64_NAN ((MVM_FLOAT64)(INFINITY * 0.0))

#endif // MVM_SUPPORT_FLOAT

/**
 * Set to `1` to enable additional internal consistency checks, or `0` to
 * disable them. Note that consistency at the API boundary is always checked,
 * regardless of this setting. Consistency checks make the VM *significantly*
 * bigger and slower, and are really only intended for testing.
 */
#define MVM_SAFE_MODE 1

/**
 * Set to `1` to do extra validation checks of bytecode while executing. This is
 * _beyond_ the basic version and CRC checks that are done upon loading, and
 * should only be enabled if you expect bugs in the bytecode compiler.
 */
#define MVM_DONT_TRUST_BYTECODE 1

/**
 * A long pointer is a type that can refer to either ROM or RAM. It is not size
 * restricted.
 *
 * On architectures where bytecode is directly addressable with a normal
 * pointer, this can just be `void*` (e.g. 32-bit architectures). On
 * architectures where bytecode can be addressed with a special pointer, this
 * might be something like `__data20 void*` (MSP430). On Harvard architectures
 * such as AVR8 where ROM and RAM are in different address spaces,
 * `MVM_LONG_PTR_TYPE` can be some integer type such as `uint32_t`, where you
 * use part of the value to distinguish which address space and part of the
 * value as the actual pointer value.
 *
 * The chosen representation/encoding of `MVM_LONG_PTR_TYPE` must be an integer
 * or pointer type, such that `0`/`NULL` represents the null pointer.
 *
 * Microvium doesn't access data through pointers of this type directly -- it
 * does so through macro operations in this port file.
 */
#define MVM_LONG_PTR_TYPE void*

/**
 * Convert a normal pointer to a long pointer
 */
#define MVM_LONG_PTR_NEW(p) ((MVM_LONG_PTR_TYPE)p)

/**
 * Truncate a long pointer to a normal pointer.
 *
 * This will only be invoked on pointers to VM RAM data.
 */
#define MVM_LONG_PTR_TRUNCATE(p) ((void*)p)

/**
 * Add an offset `s` in bytes onto a long pointer `p`. The result must be a
 * MVM_LONG_PTR_TYPE.
 *
 * The maximum offset that will be passed is 16-bit.
 *
 * Offset may be negative
 */
#define MVM_LONG_PTR_ADD(p, s) ((void*)((uint8_t*)p + (intptr_t)s))

/**
 * Subtract two long pointers to get an offset. The result must be a signed
 * 16-bit integer.
 */
#define MVM_LONG_PTR_SUB(p2, p1) ((int16_t)((uint8_t*)p2 - (uint8_t*)p1))

/*
 * Read memory of 1, 2, or 4 bytes from the long-pointer source to the target
 */
#define MVM_READ_LONG_PTR_1(lpSource) (*((uint8_t*)lpSource))
#define MVM_READ_LONG_PTR_2(lpSource) (*((uint16_t*)lpSource))
#define MVM_READ_LONG_PTR_4(lpSource) (*((uint32_t*)lpSource))

/**
 * Reference to an implementation of memcmp where p1 and p2 are LONG_PTR
 */
#define MVM_LONG_MEM_CMP(p1, p2, size) memcmp(p1, p2, size)

/**
 * Reference to an implementation of memcpy where `source` is a LONG_PTR
 */
#define MVM_LONG_MEM_CPY(target, source, size) memcpy(target, source, size)

/**
 * This is invoked when the virtual machine encounters a critical internal error
 * and execution of the VM should halt.
 *
 * Note that API-level errors are communicated via returned error codes from
 * each of the API functions and will not trigger a fatal error.
 *
 * Note: if malloc fails, this is considered a fatal error since many embedded
 * systems cannot safely continue when they run out of memory.
 *
 * If you need to halt the VM without halting the host, consider running the VM
 * in a separate RTOS thread, or using setjmp/longjmp to escape the VM without
 * returning to it. Either way, the VM should not be allowed to continue
 * executing after MVM_FATAL_ERROR (control should not return).
 */
#define MVM_FATAL_ERROR(vm, e) (assert(false), exit(e))

// These macros are mainly for MSP430 optimization using the `__even_in_range` intrinsic
#define MVM_SWITCH_CONTIGUOUS(tag, upper) switch (tag)
#define MVM_CASE_CONTIGUOUS(value) case value

/**
 * An expression that should evaluate to false if the GC compaction should be
 * skipped.
 *
 * @param preCompactionSize The number of bytes that microvium has mallocd from
 * the host for its heap.
 * @param postCompactionSize The number of bytes on the heap that will be
 * remaining if a compaction is performed.
 *
 * This is used by `mvm_runGC`. When the GC runs, it adds up how much the of
 * allocated space is actually needed, and then uses this expression to
 * determine whether a compaction should be run. The compaction time is
 * proportional to the pre-compaction size.
 */
#define MVM_PORT_GC_ALLOW_COMPACTION(preCompactionSize, postCompactionSize) postCompactionSize < preCompactionSize * 3 / 4

/**
 * Macro that evaluates to true if the CRC of the given data matches the
 * expected value. Note that this is evaluated against the bytecode, so lpData
 * needs to be a long pointer type. If you don't want the overhead of validating
 * the CRC, just return `true`.
 */
#define MVM_CHECK_CRC16_CCITT(lpData, size, expected) (crc16(lpData, size) == expected)

static uint16_t crc16(MVM_LONG_PTR_TYPE lp, uint16_t size) {
  uint16_t r = 0xFFFF;
  while (size--)
  {
    r  = (uint8_t)(r >> 8) | (r << 8);
    r ^= MVM_READ_LONG_PTR_1(lp);
    lp =  MVM_LONG_PTR_ADD(lp, 1);
    r ^= (uint8_t)(r & 0xff) >> 4;
    r ^= (r << 8) << 4;
    r ^= ((r & 0xff) << 4) << 1;
  }
  return r;
}

/**
 * Set to 1 to compile in the ability to generate snapshots (mvm_createSnapshot)
 */
#define MVM_GENERATE_SNAPSHOT_CAPABILITY 1

/**
 * Set to 1 to compile support for the debug API (mvm_dbg_*)
 */
#define MVM_GENERATE_DEBUG_CAPABILITY 1

#if MVM_GENERATE_SNAPSHOT_CAPABILITY
/**
 * Calculate the CRC. This is only used when generating snapshots.
 *
 * Unlike MVM_CHECK_CRC16_CCITT, pData here is a pointer to RAM.
 */
#define MVM_CALC_CRC16_CCITT(pData, size) (crc16(pData, size))
#endif // MVM_GENERATE_SNAPSHOT_CAPABILITY
