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

/**
 * Set to `1` to enable additional internal consistency checks, or `0` to
 * disable them. Note that consistency at the API boundary is always checked,
 * regardless of this setting. Consistency checks make the VM bigger and slower.
 */
#define MVM_SAFE_MODE 1

/**
 * The type to use for a program-memory pointer -- a pointer to where bytecode
 * is stored.
 *
 * Note: This does not need to be an actual pointer type. The VM only uses it
 * through the subsequent VM_PROGMEM_P_x macros.
 */
#define MVM_PROGMEM_P const void*

/**
 * Set this to `1` if program memory (ROM) is directly addressable using a
 * common pointer `const void*`, as opposed to requiring special logic. This
 * enables certain optimizations
 */
// TODO: Use this
#define MVM_PROGMEM_P_IS_POINTER 1

/**
 * Add an offset `s` in bytes onto a program pointer `p`. The result must be a
 * MVM_PROGMEM_P.
 *
 * The maximum offset that will be passed is 16-bit.
 *
 * Offset may be negative
 */
#define MVM_PROGMEM_P_ADD(p, s) ((void*)((uint8_t*)p + (int16_t)s))

/**
 * Subtract two program pointers to get an offset. The result must be a signed
 * 16-bit integer.
 */
#define MVM_PROGMEM_P_SUB(p2, p1) ((int16_t)((uint8_t*)p2 - (uint8_t*)p1))

/**
 * Read program memory of a given size in bytes from the source to the target
 */
#define MVM_READ_PROGMEM_N(pTarget, pSource, size) memcpy(pTarget, pSource, size)
#define MVM_READ_PROGMEM_1(pSource) (*((uint8_t*)pSource))
#define MVM_READ_PROGMEM_2(pSource) (*((uint16_t*)pSource))
#define MVM_READ_PROGMEM_4(pSource) (*((uint32_t*)pSource))
#define MVM_READ_PROGMEM_8(pSource) (*((uint64_t*)pSource))


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
 * executing after MVM_FATAL_ERROR.
 */
#define MVM_FATAL_ERROR(vm, e) (assert(false), exit(e))

// These macros are mainly for MSP430 optimization using the `__even_in_range` intrinsic
#define MVM_SWITCH_CONTIGUOUS(tag, upper) switch (tag)
#define MVM_CASE_CONTIGUOUS(value) case value
