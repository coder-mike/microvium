/*
 * This file contains the Microvium virtual machine C implementation.
 *
 * For the moment, I'm keeping it all in one file for usability. User's can
 * treat this file as a black box that contains the VM, and there's only one
 * file they need to have built into their project in order to have Microvium
 * running.
 *
 * The two interfaces to this file are:
 *
 *   1. `microvium.h`, which is the interface from the user side (how to use the
 *      VM)
 *   2. `microvium_bytecode.h` which contains types related to the bytecode
 *      format.
 *
 * User-facing functions and definitions are all prefixed with `mvm_` to
 * namespace them separately from other functions in their project.
 *
 * Internal functions and definitions don't require a prefix, but for legacy
 * reasons, many have a `vm_` prefix. Perhaps this should be `ivm_` for
 * "internal VM".
 */

#include "microvium.h"

#include <ctype.h>
#include <stdlib.h>



/* TODO(low): I think this unit should be refactored:

1. Create a new header file called `vm_bytecode.h`. The VM has two interfaces to
   the outside world: byte front-end, represented in microvium.h, and the bytecode
   interface represented in vm_bytecode.

2. Move all definitions out of here and into either microvium.c or vm_bytecode.h,
   depending on whether they're internal to the implementation of the engine or
   whether they represent the bytecode interface.

3. We should probably refactor the macros into static const values and inline
   functions, and let the optimizer sort things out.

*/

#include "stdbool.h"
#include "stdint.h"
#include "assert.h"
#include "string.h"
#include "stdlib.h"
#include "setjmp.h"

#include "microvium.h"
#include "microvium_port.h"


#include "stdint.h"

typedef struct mvm_TsBytecodeHeader {
  /* TODO: I think the performance of accessing this header would improve
  slightly if the offsets were stored as auto-relative-offsets. My reasoning is
  that we don't need to keep the pBytecode pointer for the second lookup. But
  it's maybe worth doing some tests.
  */
  uint8_t bytecodeVersion; // VM_BYTECODE_VERSION
  uint8_t headerSize;
  uint16_t bytecodeSize; // Including header
  uint16_t crc; // CCITT16 (header and data, of everything after the CRC)
  uint16_t requiredEngineVersion;
  uint32_t requiredFeatureFlags;
  uint16_t globalVariableCount;
  uint16_t gcRootsOffset; // Points to a table of pointers to GC roots in data memory (to use in addition to the global variables as roots)
  uint16_t gcRootsCount;
  uint16_t importTableOffset; // vm_TsImportTableEntry
  uint16_t importTableSize;
  uint16_t exportTableOffset; // vm_TsExportTableEntry
  uint16_t exportTableSize;
  uint16_t shortCallTableOffset; // vm_TsShortCallTableEntry
  uint16_t shortCallTableSize;
  uint16_t stringTableOffset; // Alphabetical index of UNIQUED_STRING values (TODO: Check these are always generated at 2-byte alignment)
  uint16_t stringTableSize;
  uint16_t arrayProtoPointer; // Pointer to array prototype
  uint16_t initialDataOffset; // Note: the initial-data section MUST be second-last in the bytecode file
  uint16_t initialDataSize;
  uint16_t initialHeapOffset; // Note: the initial heap MUST be the last thing in the bytecode file, since it's the only thing that changes size from one snapshot to the next on the native VM.
  uint16_t initialHeapSize;
} mvm_TsBytecodeHeader;

typedef enum mvm_TeFeatureFlags {
  FF_FLOAT_SUPPORT = 0,
} mvm_TeFeatureFlags;




/*
Microvium categorizes operations into groups based on common features. The first
nibble of an instruction is its vm_TeOpcode. This is followed by 4 bits which
can either be interpreted as a data parameter or as another opcode (e.g.
vm_TeOpcodeEx1). I call the first nibble the "primary opcode" and the second
nibble is the "secondary opcode".

There are a number of possible secondary opcodes, and each group has common
preparation logic across the group. Preparation logic means the code that runs
before the operation. For example, many operations require popping a value off
the stack before operating on the value. The VM implementation is more compact
if the pop code is common to all instructions that do the pop.

Operations can have different "follow through" logic grouped arbitrarily, since
the implementation of all instructions requires a "jump", those that have common
follow through logic simply jump to the same follow through without additional
cost, which eventually lands up back at the loop start. So the instruction
grouping does not need to cater for follow through logic, only preparation
logic.

To keep operation commonality as seamlessly as possible, the VM implementation
use 16-bit "registers", which have overloaded meaning depending on the context:

  - `reg1`
    - Initially holds the zero-extended 4-bit secondary nibble
    - Operations that load an 8- or 16-bit literal will overwrite `reg1` with
      the literal.
    - "Pure" operations use reg1 as the first popped operand (none of the pure
      operations have an embedded literal). "Pure" are what I'm calling
      operations whose entire effect is to pop some operands off the stack,
      operate on them, and push a result back onto the stack. For example,
      `ADD`.
    - `reg1` is also used as the "result" value for the common push-result tail
      logic
  - `reg2`
    - used as the second popped value of binary operations
    - used as the value to store, store-like operations
  - `reg3`
    - can be used arbitrarily by operations and does not have a common meaning

Additionally, the number operations have variations that work on 32 or 64 bit
values. These have their own local/ephemeral registers:

  - `reg1I`: the value of the reg1 register unpacked to a `uint32_t`
  - `reg2I`: the value of the reg2 register unpacked to a `uint32_t`
  - `reg1F`: the value of the reg1 register unpacked to a `double`
  - `reg2F`: the value of the reg2 register unpacked to a `double`

Operation groups and their corresponding preparation logic

  - vm_TeOpcodeEx1:
    - The prep does not read a literal (all these instructions are single-byte).
    - The prep pops 0, 1, or 2 values from the stack depending on the
      instruction range

  - vm_TeOpcodeEx2:
    - Prep reads 8-bit literal into reg1
      - Two separate instruction ranges specify whether to sign extend or not.
    - Two instruction ranges specify whether the prep will also pop an arg into
      reg2.

  - vm_TeOpcodeEx3:
    - Prep reads a 16-bit value from byte stream into reg1. This can be
      interpreted as either signed or unsigned by the particular instruction.
    - A sub-range within the instruction specifies whether an argument is popped
      from the stack.

  - vm_TeNumberOp:
    - These are all dual-implementation instructions which have both 32 and 64
      bit implementations.
    - Prep pops one or two values off the stack and reads them into reg1 and
      reg2 respectively. The choice of 1 or 2 depends on the sub-range. If
      popping one value, the second is left as zero.
    - Prep unpacks to either int32 or float64 depending on the corresponding
      data types.
    - The operations can dispatch to a different tail/follow through routine
      depending on whether they overflow or not.

  - vm_TeBitwiseOp:
    - These operations all operate on 32-bit integers and produce 32-bit integer
      results.
    - Prep pops one or two values off the stack and reads them into reg1 and
      reg2 respectively. The choice of 1 or 2 depends on the sub-range. If
      popping one value, the second is left as zero.
    - Prep unpacks reg1 and reg2 to int32

Follow-through/tail routines:

  - Push float (reg1F)
  - Push int32 (reg1I)
  - Push 16-bit result (reg1)

*/

// 4-bit enum
typedef enum vm_TeOpcode {
  VM_OP_LOAD_SMALL_LITERAL  = 0x0, // (+ 4-bit vm_TeSmallLiteralValue)
  VM_OP_LOAD_VAR_1          = 0x1, // (+ 4-bit variable index relative to stack pointer)
  VM_OP_LOAD_GLOBAL_1       = 0x2, // (+ 4-bit global variable index)
  VM_OP_LOAD_ARG_1          = 0x3, // (+ 4-bit arg index)
  VM_OP_CALL_1              = 0x4, // (+ 4-bit index into short-call table)
  VM_OP_EXTENDED_1          = 0x5, // (+ 4-bit vm_TeOpcodeEx1)
  VM_OP_EXTENDED_2          = 0x6, // (+ 4-bit vm_TeOpcodeEx2)
  VM_OP_EXTENDED_3          = 0x7, // (+ 4-bit vm_TeOpcodeEx3)

  VM_OP_DIVIDER_1, // <-- ops after this point pop at least one argument (reg2)

  VM_OP_POP                 = 0x8, // (+ 4-bit arg count of things to pop)
  VM_OP_STORE_VAR_1         = 0x9, // (+ 4-bit variable index relative to stack pointer)
  VM_OP_STORE_GLOBAL_1      = 0xA, // (+ 4-bit global variable index)
  VM_OP_STRUCT_GET_1        = 0xB, // (+ 4-bit field index)
  VM_OP_STRUCT_SET_1        = 0xC, // (+ 4-bit field index)
  VM_OP_NUM_OP              = 0xD, // (+ 4-bit vm_TeNumberOp)
  VM_OP_BIT_OP              = 0xE, // (+ 4-bit vm_TeBitwiseOp)

  VM_OP_END
} vm_TeOpcode;

#define VM_RETURN_FLAG_POP_FUNCTION (1 << 0)
#define VM_RETURN_FLAG_UNDEFINED    (1 << 1)

typedef enum vm_TeOpcodeEx1 {
  VM_OP1_RETURN_1                = 0x0,
  VM_OP1_RETURN_2                = 0x0 | VM_RETURN_FLAG_POP_FUNCTION,
  VM_OP1_RETURN_3                = 0x0 | VM_RETURN_FLAG_UNDEFINED,
  VM_OP1_RETURN_4                = 0x0 | VM_RETURN_FLAG_POP_FUNCTION | VM_RETURN_FLAG_UNDEFINED,

  VM_OP1_OBJECT_NEW              = 0x4,

  VM_OP1_DIVIDER_1, // <-- ops after this point are treated as having 2 arguments

  // boolean -> boolean
  VM_OP1_LOGICAL_NOT             = 0x5,

  // (object, prop) -> any
  VM_OP1_OBJECT_GET_1            = 0x6, // (field ID is dynamic)

  // (string, string) -> string
  // (number, number) -> number
  VM_OP1_ADD                     = 0x7,

  // (any, any) -> boolean
  VM_OP1_EQUAL                   = 0x8,
  VM_OP1_NOT_EQUAL               = 0x9,

  // (object, prop, any) -> void
  VM_OP1_OBJECT_SET_1            = 0xA, // (field ID is dynamic)

  VM_OP1_END
} vm_TeOpcodeEx1;

// All of these operations are implemented with an 8-bit literal embedded into
// the instruction. The literal is stored in reg1.
typedef enum vm_TeOpcodeEx2 {
  VM_OP2_BRANCH_1            = 0x0, // (+ 8-bit signed offset)

  VM_OP2_STORE_ARG           = 0x1, // (+ 8-bit unsigned arg index)
  VM_OP2_STORE_GLOBAL_2      = 0x2, // (+ 8-bit unsigned global variable index)
  VM_OP2_STORE_VAR_2         = 0x3, // (+ 8-bit unsigned variable index relative to stack pointer)
  VM_OP2_STRUCT_GET_2        = 0x4, // (+ 8-bit unsigned field index)
  VM_OP2_STRUCT_SET_2        = 0x5, // (+ 8-bit unsigned field index)

  VM_OP2_DIVIDER_1, // <-- ops before this point pop from the stack into reg2

  VM_OP2_JUMP_1              = 0x6, // (+ 8-bit signed offset)
  VM_OP2_CALL_HOST           = 0x7, // (+ 8-bit arg count + 8-bit unsigned index into resolvedImports)
  VM_OP2_CALL_3              = 0x8, // (+ 8-bit unsigned arg count. Target is dynamic)
  VM_OP2_CALL_2              = 0x9, // (+ 8-bit arg count + 16-bit function offset)

  VM_OP2_LOAD_GLOBAL_2       = 0xA, // (+ 8-bit unsigned global variable index)
  VM_OP2_LOAD_VAR_2          = 0xB, // (+ 8-bit unsigned variable index relative to stack pointer)
  VM_OP2_LOAD_ARG_2          = 0xC, // (+ 8-bit unsigned arg index)

  VM_OP2_RETURN_ERROR        = 0xD, // (+ 8-bit mvm_TeError)

  VM_OP2_ARRAY_NEW           = 0xE, // (+ 8-bit capacity count)

  VM_OP2_END
} vm_TeOpcodeEx2;

// These instructions all have an embedded 16-bit literal value
typedef enum vm_TeOpcodeEx3 {
  VM_OP3_JUMP_2              = 0x0, // (+ 16-bit signed offset)
  VM_OP3_LOAD_LITERAL        = 0x1, // (+ 16-bit value)
  VM_OP3_LOAD_GLOBAL_3       = 0x2, // (+ 16-bit global variable index)

  VM_OP3_DIVIDER_1, // <-- ops after this point pop an argument into reg2

  VM_OP3_BRANCH_2            = 0x3, // (+ 16-bit signed offset)
  VM_OP3_STORE_GLOBAL_3      = 0x4, // (+ 16-bit global variable index)

  VM_OP3_OBJECT_GET_2        = 0x5, // (+ 16-bit string reference)
  VM_OP3_OBJECT_SET_2        = 0x6, // (+ 16-bit string reference)

  VM_OP3_END
} vm_TeOpcodeEx3;


// Number operations. These are operations which take one or two arguments from
// the stack and coerce them to numbers. Each of these will have two
// implementations: one for 32-bit int, and one for 64-bit float.
typedef enum vm_TeNumberOp {

  // (number, number) -> boolean
  VM_NUM_OP_LESS_THAN        = 0x0,
  VM_NUM_OP_GREATER_THAN     = 0x1,
  VM_NUM_OP_LESS_EQUAL       = 0x2,
  VM_NUM_OP_GREATER_EQUAL    = 0x3,

  // (number, number) -> number
  VM_NUM_OP_ADD_NUM          = 0x4,
  VM_NUM_OP_SUBTRACT         = 0x5,
  VM_NUM_OP_MULTIPLY         = 0x6,
  VM_NUM_OP_DIVIDE           = 0x7,
  VM_NUM_OP_DIVIDE_AND_TRUNC = 0x8, // Implemented in code as `x / y | 0`
  VM_NUM_OP_REMAINDER        = 0x9,
  VM_NUM_OP_POWER            = 0xA,

  VM_NUM_OP_DIVIDER, // <-- ops after this point are unary

  // number -> number
  VM_NUM_OP_NEGATE           = 0xB,
  VM_NUM_OP_UNARY_PLUS       = 0xC,

  VM_NUM_OP_END
} vm_TeNumberOp;

// Bitwise operations:
typedef enum vm_TeBitwiseOp {
  // (bits, bits) -> bits
  VM_BIT_OP_SHR_ARITHMETIC = 0x0, // Aka signed shift right. Aka sign-propagating right shift.
  VM_BIT_OP_SHR_LOGICAL    = 0x1, // Aka unsigned shift right. Aka zero-fill right shift.
  VM_BIT_OP_SHL            = 0x2, // Shift left

  VM_BIT_OP_END_OF_SHIFT_OPERATORS, // <-- ops before this point need their operand in the 0-32 range

  VM_BIT_OP_OR             = 0x3,
  VM_BIT_OP_AND            = 0x4,
  VM_BIT_OP_XOR            = 0x5,

  VM_BIT_OP_DIVIDER_2, // <-- ops after this point are unary

  // bits -> bits
  VM_BIT_OP_NOT            = 0x6,

  VM_BIT_OP_END
} vm_TeBitwiseOp;

// 4-bit enum
typedef enum vm_TeSmallLiteralValue {
  VM_SLV_NULL            = 0x0,
  VM_SLV_UNDEFINED       = 0x1,
  VM_SLV_FALSE           = 0x2,
  VM_SLV_TRUE            = 0x3,
  VM_SLV_INT_0           = 0x4,
  VM_SLV_INT_1           = 0x5,
  VM_SLV_INT_2           = 0x6,
  VM_SLV_INT_MINUS_1     = 0x7,
} vm_TeSmallLiteralValue;



#define VM_BYTECODE_VERSION 1

#if MVM_SAFE_MODE
#define VM_ASSERT(vm, predicate) do { if (!(predicate)) MVM_FATAL_ERROR(vm, MVM_E_ASSERTION_FAILED); } while (false)
#else
#define VM_ASSERT(vm, predicate)
#endif

#ifndef __has_builtin
#define __has_builtin(x) 0
#endif

// Offset of field in a struct
#define OFFSETOF(TYPE, ELEMENT) ((size_t)&(((TYPE *)0)->ELEMENT))

#define VM_ALLOCATION_BUCKET_SIZE 256 // TODO Why isn't this in the port file?
#define VM_GC_ALLOCATION_UNIT     2   // Don't change
#define VM_GC_MIN_ALLOCATION_SIZE (VM_GC_ALLOCATION_UNIT * 2)

/* TODO: I think it would be better to use the lower 2 bits for the tag, and
 * then keep allocations aligned to 4-byte boundaries, thus giving us 64kB of
 * memory in each region. For devices with 16-bit address spaces, this would
 * mean that a pointer can actually point directly to the target memory without
 * need for a translation, which would be very efficient. Then the 4 tags could
 * be:
 *
 *   - 00: A 14-bit int
 *   - 01: A native pointer (GC, data, or bytecode)
 *   - 10: A pointer to data memory (e.g. from bytecode which can't be updated)
 *   - 11: A pointer to bytecode memory
 *
 * The only complexity is that in that mode, a translation is required during
 * load time to change all the pointers in initial data to be native pointers,
 * but since we have a roots table, this shouldn't be difficult.
 *
 * ----------------
 *
 * I've been thinking about this further. I don't like the idea of requiring RAM
 * allocations to be 4-byte aligned, since it makes int32s 8 bytes instead of 6
 * bytes, which is a significant increase. And in general, most things in
 * Microvium are naturally 2-byte aligned. So my new thought is this:
 *
 *   1. If the lowest bit is 0, interpret the value as a native 16-bit pointer
 *      (in words)
 *   2. If the lowest bits are 01, interpret the value as a bytecode pointer in
 *      double-words. If the bytecode pointer points to the region of bytecode
 *      corresponding to initial data, it is interpretted as a pointer to the
 *      corresponding region in RAM.
 *   3. If the lowest bits are 11, interpret the value as a 14-bit integer
 *
 * This has the advantage that all address spaces are 64 kB, so it's easy to
 * understand and explain to users. The rules are simply that "the bytecode
 * cannot exceed 64 kB" and "RAM usage cannot exceed more than 64 kB". Native
 * pointers are first-class, which will speed up the GC and data access in
 * general. Especially for the GC, it's useful that a single bit completely
 * distinguishes values that must be traced from those which need not be, and
 * those which need to be traced can be done without any further manipulation of
 * the pointer.
 *
 * Just to add to this thought further: when I implement this, I'd like to see
 * if it's easy to build it on an abstraction layer that allows us to compile a
 * 32-bit machine in future. In other words, that all the memory operations are
 * abstracted through a common macro interface, which we can switch out for
 * different architectures. But certainly my niche at the moment will be 16-bit
 * machines. But actually my niche is probably for small programs, so this is
 * not something I want to prioritize.
 *
 * --------------------
 *
 * This comment is becoming an essay. What I wanted to add is that the above
 * proposal for native pointers makes it quite difficult to cache the forwarding
 * addresses and mark bits for garbage collection, since the address space is
 * the full 64kB even when only a small amount is allocated, and it's used in a
 * non-linear fashion.
 *
 * It's probably not unreasonable to clear a mark bit in the header word, if the
 * limit of 2047 bytes for allocation size does not apply to long arrays.
 *
 * Forwarding addresses are more difficult though. We could keep the same table
 * like we have now, but we'd have to do a reverse translation of the native
 * address to the allocation offset.
 *
 * A solution I don't like would be to make the heap fully parseable and use a
 * 4-byte allocation header, using 15-bits for the forwarding pointer and 1-bit
 * for the mark bit. This would be efficient but I really don't like the bulk it
 * would imply.
 */

#define VM_TAG_MASK               0xC000 // The tag is the top 2 bits
#define VM_VALUE_MASK             0x3FFF // The value is the remaining 14 bits
#define VM_VALUE_SIGN_BIT         0x2000 // Sign bit used for signed numbers

#define VM_VALUE_UNSIGNED         0x0000
#define VM_VALUE_SIGNED           0x2000
#define VM_SIGN_EXTENTION         0xC000
#define VM_OVERFLOW_BIT           0x4000

// TODO(low): I think these should be inline functions rather than macros
#define VM_VALUE_OF(v) ((v) & VM_VALUE_MASK)
#define VM_TAG_OF(v) ((TeValueTag)((v) & VM_TAG_MASK))
#define VM_IS_INT14(v) (VM_TAG_OF(v) == VM_TAG_INT)
#define VM_IS_GC_P(v) (VM_TAG_OF(v) == VM_TAG_GC_P)
#define VM_IS_DATA_P(v) (VM_TAG_OF(v) == VM_TAG_DATA_P)
#define VM_IS_PGM_P(v) (VM_TAG_OF(v) == VM_TAG_PGM_P)

// This is the only valid way of representing NaN
#define VM_IS_NAN(v) ((v) == VM_VALUE_NAN)
// This is the only valid way of representing infinity
#define VM_IS_INF(v) ((v) == VM_VALUE_INF)
// This is the only valid way of representing -infinity
#define VM_IS_NEG_INF(v) ((v) == VM_VALUE_NEG_INF)
// This is the only valid way of representing negative zero
#define VM_IS_NEG_ZERO(v) ((v) == VM_VALUE_NEG_ZERO)

#define VM_NOT_IMPLEMENTED(vm) (MVM_FATAL_ERROR(vm, MVM_E_NOT_IMPLEMENTED), -1)
#define VM_RESERVED(vm) (MVM_FATAL_ERROR(vm, MVM_E_UNEXPECTED), -1)

// An error corresponding to an internal inconsistency in the VM. Such an error
// cannot be caused by incorrect usage of the VM. In safe mode, this function
// should terminate the application. If not in safe mode, it is assumed that
// this function will never be invoked.
#define VM_UNEXPECTED_INTERNAL_ERROR(vm) (MVM_FATAL_ERROR(vm, MVM_E_UNEXPECTED), -1)

#define VM_VALUE_OF_DYNAMIC(v) ((void*)((TsAllocationHeader*)v + 1))
#define VM_DYNAMIC_TYPE(v) (((TsAllocationHeader*)v)->type)

#define VM_MAX_INT14 0x1FFF
#define VM_MIN_INT14 (-0x2000)

#if MVM_SAFE_MODE
#define VM_EXEC_SAFE_MODE(code) code
#define VM_SAFE_CHECK_NOT_NULL(v) do { if ((v) == NULL) return MVM_E_UNEXPECTED; } while (false)
#define VM_SAFE_CHECK_NOT_NULL_2(v) do { if ((v) == NULL) { MVM_FATAL_ERROR(vm, MVM_E_UNEXPECTED); return NULL; } } while (false)
#define VM_ASSERT_UNREACHABLE(vm) (MVM_FATAL_ERROR(vm, MVM_E_UNEXPECTED), -1)
#else
#define VM_EXEC_SAFE_MODE(code)
#define VM_SAFE_CHECK_NOT_NULL(v)
#define VM_SAFE_CHECK_NOT_NULL_2(v)
#define VM_ASSERT_UNREACHABLE(vm)
#endif

#if MVM_DONT_TRUST_BYTECODE
// TODO: I think I need to do an audit of all the assertions and errors in the code, and make sure they're categorized correctly as bytecode errors or not
#define VM_INVALID_BYTECODE(vm) MVM_FATAL_ERROR(vm, MVM_E_INVALID_BYTECODE)
#else
#define VM_INVALID_BYTECODE(vm)
#endif

#define VM_READ_BC_1_AT(offset, pBytecode) MVM_READ_PROGMEM_1(MVM_PROGMEM_P_ADD((pBytecode), offset));
#define VM_READ_BC_2_AT(offset, pBytecode) MVM_READ_PROGMEM_2(MVM_PROGMEM_P_ADD((pBytecode), offset));
#define VM_READ_BC_4_AT(offset, pBytecode) MVM_READ_PROGMEM_4(MVM_PROGMEM_P_ADD((pBytecode), offset));
#define VM_READ_BC_8_AT(offset, pBytecode) MVM_READ_PROGMEM_8(MVM_PROGMEM_P_ADD((pBytecode), offset));
#define VM_READ_BC_N_AT(pTarget, offset, size, pBytecode) MVM_READ_PROGMEM_N(pTarget, MVM_PROGMEM_P_ADD((pBytecode), offset), size);

#define VM_READ_BC_1_FIELD(fieldName, structOffset, structType, pBytecode) VM_READ_BC_1_AT(structOffset + OFFSETOF(structType, fieldName), pBytecode);
#define VM_READ_BC_2_FIELD(fieldName, structOffset, structType, pBytecode) VM_READ_BC_2_AT(structOffset + OFFSETOF(structType, fieldName), pBytecode);

#define VM_READ_BC_1_HEADER_FIELD(fieldName, pBytecode) VM_READ_BC_1_FIELD(fieldName, 0, mvm_TsBytecodeHeader, pBytecode);
#define VM_READ_BC_2_HEADER_FIELD(fieldName, pBytecode) VM_READ_BC_2_FIELD(fieldName, 0, mvm_TsBytecodeHeader, pBytecode);

#define VM_BOTTOM_OF_STACK(vm) ((uint16_t*)(vm->stack + 1))
#define VM_TOP_OF_STACK(vm) (VM_BOTTOM_OF_STACK(vm) + MVM_STACK_SIZE / 2)
#define VM_IS_UNSIGNED(v) ((v & VM_VALUE_SIGN_BIT) == VM_VALUE_UNSIGNED)
#define VM_SIGN_EXTEND(v) (VM_IS_UNSIGNED(v) ? v : (v | VM_SIGN_EXTENTION))

#ifndef CODE_COVERAGE
/*
 * A set of macros for manual code coverage analysis (because the off-the-shelf
 * tools appear to be quite expensive). This should be overwritten in the port
 * file for the unit tests. Each instance of this macro should occur on its own
 * line. The unit tests can dumbly scan the source text for instances of this
 * macro to establish what code paths _should_ be hit. Each instance should have
 * its own unique numeric ID.
 *
 * If the ID is omitted or a non-integer placeholder (e.g. "x"), the script `npm
 * run update-coverage-markers` will fill in a valid ID.
 *
 * Explicit IDs are used instead of line numbers because a previous analysis
 * remains roughly correct even after the code has changed.
 */
#define CODE_COVERAGE(id)
#define CODE_COVERAGE_UNTESTED(id)
#define CODE_COVERAGE_UNIMPLEMENTED(id)
#define CODE_COVERAGE_ERROR_PATH(id)

/**
 * In addition to recording code coverage, it's useful to have information about
 * the coverage information for table entries. Code and tables can be
 * alternative representations of the same thing. For example, a lookup table
 * can be represented as a switch statement. However, only the switch statement
 * form typically shows up in code coverage analysis. With Microvium coverage
 * analysis, tables are covered as well.
 *
 * If the ID is omitted or a non-integer placeholder (e.g. "x"), the script `npm
 * run update-coverage-markers` will fill in a valid ID.
 *
 * @param indexInTable The runtime expression for the case that is actually hit.
 * @param tableSize The size of the table (can be a runtime expression)
 * @param id A unique numeric ID to uniquely identify the marker
 */
#define TABLE_COVERAGE(indexInTable, tableSize, id)
#endif

#ifndef MVM_SUPPORT_FLOAT
#define MVM_SUPPORT_FLOAT 1
#endif

#ifndef MVM_PORT_INT32_OVERFLOW_CHECKS
#define MVM_PORT_INT32_OVERFLOW_CHECKS 1
#endif

#ifndef MVM_SAFE_MODE
#define MVM_SAFE_MODE 0
#endif

#ifndef MVM_DONT_TRUST_BYTECODE
#define MVM_DONT_TRUST_BYTECODE 0
#endif

#ifndef MVM_SWITCH_CONTIGUOUS
#define MVM_SWITCH_CONTIGUOUS(tag, upper) switch (tag)
#endif

#ifndef MVM_CASE_CONTIGUOUS
#define MVM_CASE_CONTIGUOUS(value) case value
#endif

// Internally, we don't need to use the mvm prefix for these common types
typedef mvm_Value Value;
typedef mvm_VM VM;
typedef mvm_TeError TeError;

/**
 * Type code indicating the type of data.
 *
 * This enumeration is divided into reference types (TC_REF_) and value types
 * (TC_VAL_). Reference type codes are used on allocations, whereas value type
 * codes are never used on allocations. The space for the type code in the
 * allocation header is 4 bits, so there are up to 16 reference types and these
 * must be the first 16 types in the enumeration.
 *
 * Value types are for the values that can be represented within the 16-bit
 * mvm_Value without interpreting it as a pointer.
 */
typedef enum TeTypeCode {
  // Note: only type code values in the range 0-15 can be used as the types for
  // allocations, since the allocation header allows 4 bits for the type

  /* --------------------------- Reference types --------------------------- */

  // TC_REF_NONE is used for allocations which are never addressable by a vm_Value,
  // and so their type will never be checked. This is only for internal data
  // structures.
  TC_REF_NONE           = 0x0,

  TC_REF_INT32          = 0x1, // 32-bit signed integer
  TC_REF_FLOAT64        = 0x2, // 64-bit float

  /**
   * UTF8-encoded string that may or may not be unique.
   *
   * Note: If a TC_REF_STRING is in bytecode, it is because it encodes a value
   * that is illegal as a property index in Microvium (i.e. it encodes an
   * integer).
   */
  TC_REF_STRING         = 0x3,

  /**
   * A string whose address uniquely identifies its contents, and does not
   * encode an integer in the range 0 to 0x1FFF
   */
  TC_REF_UNIQUE_STRING  = 0x4,

  TC_REF_PROPERTY_LIST  = 0x5, // TsPropertyList - Object represented as linked list of properties

  TC_REF_ARRAY          = 0x6, // TsArray
  TC_REF_RESERVED_0     = 0x7, // Reserved for some kind of sparse or fixed-length array in future if needed
  TC_REF_FUNCTION       = 0x8, // Local function
  TC_REF_HOST_FUNC      = 0x9, // External function by index in import table

  // Structs are objects with a fixed set of fields, and the field keys are
  // stored separately to the field values. Structs have a 4-byte header, which
  // consists of the normal 2-byte header, preceded by a 2-byte pointer to the
  // struct metadata. The metadata lists the keys, while the struct allocation
  // lists the values. The first value is at the pointer target.
  TC_REF_STRUCT         = 0xA,

  TC_REF_BIG_INT        = 0xB, // Reserved
  TC_REF_SYMBOL         = 0xC, // Reserved
  TC_REF_RESERVED_1     = 0xD, // Reserved
  TC_REF_RESERVED_2     = 0xE, // Reserved
  TC_REF_RESERVED_3     = 0xF, // Reserved

  /* ----------------------------- Value types ----------------------------- */
  TC_VAL_INT14         = 0x10,
  TC_VAL_UNDEFINED     = 0x11,
  TC_VAL_NULL          = 0x12,
  TC_VAL_TRUE          = 0x13,
  TC_VAL_FALSE         = 0x14,
  TC_VAL_NAN           = 0x15,
  TC_VAL_NEG_ZERO      = 0x16,
  TC_VAL_DELETED       = 0x17, // Placeholder for properties and list items that have been deleted or holes in arrays
  TC_VAL_STR_LENGTH    = 0x18, // The string "length"
  TC_VAL_STR_PROTO     = 0x19, // The string "__proto__"

  TC_END,
} TeTypeCode;

// Tag values
typedef enum TeValueTag {
  VM_TAG_INT    = 0x0000,
  VM_TAG_GC_P   = 0x4000,
  VM_TAG_DATA_P = 0x8000,
  VM_TAG_PGM_P  = 0xC000,
} TeValueTag;

// Note: VM_VALUE_NAN must be used instead of a pointer to a double that has a
// NaN value (i.e. the values must be normalized to use the following table).
// Operations will assume this canonical form.

// Some well-known values
typedef enum vm_TeWellKnownValues {
  VM_VALUE_UNDEFINED     = (VM_TAG_PGM_P | (int)TC_VAL_UNDEFINED),
  VM_VALUE_NULL          = (VM_TAG_PGM_P | (int)TC_VAL_NULL),
  VM_VALUE_TRUE          = (VM_TAG_PGM_P | (int)TC_VAL_TRUE),
  VM_VALUE_FALSE         = (VM_TAG_PGM_P | (int)TC_VAL_FALSE),
  VM_VALUE_NAN           = (VM_TAG_PGM_P | (int)TC_VAL_NAN),
  VM_VALUE_NEG_ZERO      = (VM_TAG_PGM_P | (int)TC_VAL_NEG_ZERO),
  VM_VALUE_DELETED       = (VM_TAG_PGM_P | (int)TC_VAL_DELETED),
  VM_VALUE_STR_LENGTH    = (VM_TAG_PGM_P | (int)TC_VAL_STR_LENGTH),
  VM_VALUE_STR_PROTO     = (VM_TAG_PGM_P | (int)TC_VAL_STR_PROTO),

  VM_VALUE_WELLKNOWN_END,
} vm_TeWellKnownValues;

// Note: These offsets don't include the tag
typedef uint16_t DO_t; // Offset into data memory space
typedef uint16_t GO_t; // Offset into garbage collected memory space
typedef uint16_t BO_t; // Offset into bytecode (pgm/ROM) memory space

/**
 * A pointer into one of the memory spaces, including the corresponding tag.
 *
 * Use the hungarian prefix vp when declaring values or paramters that are
 * intended to be pointers.
 *
 * Pointers are values that can generically refer into any address space.
 * Unfortunately, Microvium is designed to un in environments where bytecode is
 * stored non-locally, such as arduino where flash memory is a completely
 * separate address space. So, it is not assumed that there is a native pointer
 * that can homogenously refer to any memory address. Instead, we use the same
 * format as the mvm_Value, with a 2-bit tag indicating what kind of pointer it
 * is. Access to these pointers needs to be done indirectly, such as through
 * `vm_readUInt16` and similar methods;
 */
typedef mvm_Value Pointer;

typedef struct TsArray {
  Pointer data;
  uint16_t length;
  uint16_t capacity;
} TsArray;

typedef uint16_t vm_HeaderWord;
typedef struct vm_TsStack vm_TsStack;

typedef struct TsPropertyList {
  Pointer first; // TsPropertyCell or 0
} TsPropertyList;

// Note: cells do not have an allocation header
typedef struct TsPropertyCell {
  Pointer next; // TsPropertyCell or 0
  Value key; // TC_VAL_INT14 or TC_REF_UNIQUE_STRING
  Value value;
} TsPropertyCell;

typedef struct vm_TsBucket {
  Pointer vpAddressStart;
  struct vm_TsBucket* prev;
} vm_TsBucket;

struct mvm_VM {
  uint16_t* dataMemory;
  MVM_PROGMEM_P pBytecode;

  // Start of the last bucket of GC memory
  vm_TsBucket* pLastBucket;
  // End of the last bucket of GC memory
  Pointer vpBucketEnd;
  // Where to allocate next GC allocation
  Pointer vpAllocationCursor;
  uint8_t* pAllocationCursor;
  // Handles - values to treat as GC roots
  mvm_Handle* gc_handles;

  vm_TsStack* stack;
  Pointer uniqueStrings; // Linked list of unique strings in GC memory (excludes those in ROM)
  // We need this in RAM because it can point to GC memory which moves
  Pointer arrayProto;

  void* context;
};

typedef struct TsUniqueStringCell {
  Pointer next;
  Value str;
} TsUniqueStringCell;

typedef struct vm_TsExportTableEntry {
  mvm_VMExportID exportID;
  mvm_Value exportValue;
} vm_TsExportTableEntry;

typedef union vm_TsShortCallTableEntry {
  // If `function` high-bit is set, the `function` is an index into the
  // resolvedImports table. If `function` high-bit is not set, `function` is an
  // offset to a local function in the bytecode
  uint16_t function;
  uint8_t argCount;
} vm_TsShortCallTableEntry;

typedef struct vm_TsRegisters {
  uint16_t* pFrameBase;
  uint16_t* pStackPointer;
  BO_t programCounter;
  uint16_t argCount;
} vm_TsRegisters;

struct vm_TsStack {
  // Allocate registers along with the stack, because these are needed at the same time (i.e. while the VM is active)
  vm_TsRegisters reg;
  // ... (stack memory) ...
};

typedef struct TsAllocationHeader {
  /* 4 least-significant-bits are the type code (TeTypeCode) */
  uint16_t headerData;
} TsAllocationHeader;

typedef struct vm_TsFunctionHeader {
  // Note: The vm_TsFunctionHeader _starts_ at the target of the function
  // pointer, but there may be an additional TsAllocationHeader _preceding_ the
  // pointer target.
  uint8_t maxStackDepth;
} vm_TsFunctionHeader;

typedef struct vm_TsImportTableEntry {
  mvm_HostFunctionID hostFunctionID;
} vm_TsImportTableEntry;

#define GC_TRACE_STACK_COUNT 20

typedef struct vm_TsGCCollectionState {
  VM* vm;
  uint16_t requiredHeapSize;
  uint8_t* pMarkTable;
  uint8_t* pPointersUpdatedTable;
  uint16_t* pAdjustmentTable;
  uint16_t* pTraceStackItem;
  uint16_t* pTraceStackEnd;
} vm_TsGCCollectionState;


#include "math.h"

static void vm_readMem(VM* vm, void* target, Pointer source, uint16_t size);
static void vm_writeMem(VM* vm, Pointer target, void* source, uint16_t size);

// Number of words on the stack required for saving the caller state
#define VM_FRAME_SAVE_SIZE_WORDS 3

static const Pointer vpGCSpaceStart = 0x4000;

static bool vm_isHandleInitialized(VM* vm, const mvm_Handle* handle);
static void* vm_deref(VM* vm, Value pSrc);
static TeError vm_run(VM* vm);
static void vm_push(VM* vm, uint16_t value);
static uint16_t vm_pop(VM* vm);
static TeError vm_setupCallFromExternal(VM* vm, Value func, Value* args, uint8_t argCount);
static Value vm_convertToString(VM* vm, Value value);
static Value vm_concat(VM* vm, Value left, Value right);
static TeTypeCode deepTypeOf(VM* vm, Value value);
static bool vm_isString(VM* vm, Value value);
static int32_t vm_readInt32(VM* vm, TeTypeCode type, Value value);
static inline vm_HeaderWord vm_readHeaderWord(VM* vm, Pointer pAllocation);
static uint16_t vm_readUInt16(VM* vm, Pointer p);
static void vm_writeUInt16(VM* vm, Pointer p, Value value);
static TeError vm_resolveExport(VM* vm, mvm_VMExportID id, Value* result);
static inline mvm_TfHostFunction* vm_getResolvedImports(VM* vm);
static inline uint16_t vm_getResolvedImportCount(VM* vm);
static void gc_createNextBucket(VM* vm, uint16_t bucketSize);
static Value gc_allocateWithHeader(VM* vm, uint16_t sizeBytes, TeTypeCode typeCode, void** out_target);
static Pointer gc_allocateWithoutHeader(VM* vm, uint16_t sizeBytes, void** out_pTarget);
static void gc_markAllocation(vm_TsGCCollectionState* gc, GO_t p, uint16_t size);
static void gc_traceValue(vm_TsGCCollectionState* gc, Value value);
static void gc_traceValueOnNewTraceStack(vm_TsGCCollectionState* gc, Value value);
static void gc_updatePointer(vm_TsGCCollectionState* gc, Value* pValue);
static inline bool gc_isMarked(uint8_t* pMarkTable, Pointer ptr);
static void gc_freeGCMemory(VM* vm);
static void* gc_deref(VM* vm, Pointer vp);
static Value vm_allocString(VM* vm, size_t sizeBytes, void** data);
static TeError getProperty(VM* vm, Value objectValue, Value propertyName, Value* propertyValue);
static TeError setProperty(VM* vm, Value objectValue, Value propertyName, Value propertyValue);
static TeError toPropertyName(VM* vm, Value* value);
static Value toUniqueString(VM* vm, Value value);
static int memcmp_pgm(void* p1, MVM_PROGMEM_P p2, size_t size);
static MVM_PROGMEM_P pgm_deref(VM* vm, Pointer vp);
static uint16_t vm_stringSizeUtf8(VM* vm, Value str);
static bool vm_stringIsNonNegativeInteger(VM* vm, Value str);
static TeError toInt32Internal(mvm_VM* vm, mvm_Value value, int32_t* out_result);
static void sanitizeArgs(VM* vm, Value* args, uint8_t argCount);

#define GC_USE_ADJUSTMENT_LOOKUP 1

#if GC_USE_ADJUSTMENT_LOOKUP
// See scripts/generate-adjustment-lookup.js
static const int8_t adjustmentLookup[2][16] = { {8,7,5,4,3,2,4,3,1,0,2,1,4,3,1,0}, {0,-1,1,0,3,2,0,-1,5,4,2,1,0,-1,1,0} };
#endif // GC_USE_ADJUSTMENT_LOOKUP

#if MVM_SUPPORT_FLOAT
static int32_t mvm_float64ToInt32(MVM_FLOAT64 value);
#endif

const Value mvm_undefined = VM_VALUE_UNDEFINED;
const Value vm_null = VM_VALUE_NULL;

static inline TeTypeCode vm_getTypeCodeFromHeaderWord(vm_HeaderWord headerWord) {
  CODE_COVERAGE(1); // Hit
  // The type code is in the high byte because it's the byte that occurs closest
  // to the allocation itself, potentially allowing us in future to omit the
  // size in the allocation header for some kinds of allocations.
  return (TeTypeCode)(headerWord >> 12);
}

// Returns the allocation size, excluding the header itself
static inline uint16_t vm_getAllocationSizeExcludingHeaderFromHeaderWord(vm_HeaderWord headerWord) {
  CODE_COVERAGE(2); // Hit
  return headerWord & 0xFFF;
}

TeError mvm_restore(mvm_VM** result, MVM_PROGMEM_P pBytecode, size_t bytecodeSize, void* context, mvm_TfResolveImport resolveImport) {
  CODE_COVERAGE(3); // Hit

  mvm_TfHostFunction* resolvedImports;
  mvm_TfHostFunction* resolvedImport;
  uint16_t* dataMemory;
  MVM_PROGMEM_P pImportTableStart;
  MVM_PROGMEM_P pImportTableEnd;
  MVM_PROGMEM_P pImportTableEntry;
  BO_t initialHeapOffset;
  uint16_t initialHeapSize;

  #if MVM_SAFE_MODE
    uint16_t x = 0x4243;
    bool isLittleEndian = ((uint8_t*)&x)[0] == 0x43;
    VM_ASSERT(NULL, isLittleEndian);
  #endif

  TeError err = MVM_E_SUCCESS;
  VM* vm = NULL;

  // Bytecode size field is located at the second word
  if (bytecodeSize < 4) {
    CODE_COVERAGE_ERROR_PATH(21); // Not hit
    return MVM_E_INVALID_BYTECODE;
  }
  uint16_t expectedBytecodeSize = VM_READ_BC_2_HEADER_FIELD(bytecodeSize, pBytecode);
  if (bytecodeSize != expectedBytecodeSize) {
    CODE_COVERAGE_ERROR_PATH(240); // Not hit
    return MVM_E_INVALID_BYTECODE;
  }

  uint16_t expectedCRC = VM_READ_BC_2_HEADER_FIELD(crc, pBytecode);
  if (!MVM_CHECK_CRC16_CCITT(MVM_PROGMEM_P_ADD(pBytecode, 6), (uint16_t)bytecodeSize - 6, expectedCRC)) {
    CODE_COVERAGE_ERROR_PATH(54); // Not hit
    return MVM_E_BYTECODE_CRC_FAIL;
  }

  uint8_t headerSize = VM_READ_BC_1_HEADER_FIELD(headerSize, pBytecode);
  if (bytecodeSize < headerSize) {
    CODE_COVERAGE_ERROR_PATH(241); // Not hit
    return MVM_E_INVALID_BYTECODE;
  }

  // For the moment we expect an exact header size
  if (headerSize != sizeof (mvm_TsBytecodeHeader)) {
    CODE_COVERAGE_ERROR_PATH(242); // Not hit
    return MVM_E_INVALID_BYTECODE;
  }

  uint8_t bytecodeVersion = VM_READ_BC_1_HEADER_FIELD(bytecodeVersion, pBytecode);
  if (bytecodeVersion != VM_BYTECODE_VERSION) {
    CODE_COVERAGE_ERROR_PATH(430); // Not hit
    return MVM_E_INVALID_BYTECODE;
  }

  uint32_t featureFlags;
  VM_READ_BC_N_AT(&featureFlags, OFFSETOF(mvm_TsBytecodeHeader, requiredFeatureFlags), 4, pBytecode);
  if (MVM_SUPPORT_FLOAT && !(featureFlags & (1 << FF_FLOAT_SUPPORT))) {
    CODE_COVERAGE_ERROR_PATH(180); // Not hit
    return MVM_E_BYTECODE_REQUIRES_FLOAT_SUPPORT;
  }

  uint16_t importTableOffset = VM_READ_BC_2_HEADER_FIELD(importTableOffset, pBytecode);
  uint16_t importTableSize = VM_READ_BC_2_HEADER_FIELD(importTableSize, pBytecode);
  uint16_t initialDataOffset = VM_READ_BC_2_HEADER_FIELD(initialDataOffset, pBytecode);
  uint16_t initialDataSize = VM_READ_BC_2_HEADER_FIELD(initialDataSize, pBytecode);

  uint16_t importCount = importTableSize / sizeof (vm_TsImportTableEntry);

  size_t allocationSize = sizeof(mvm_VM) +
    sizeof(mvm_TfHostFunction) * importCount +  // Import table
    initialDataSize; // Data memory (globals)
  vm = malloc(allocationSize);
  if (!vm) {
    err = MVM_E_MALLOC_FAIL;
    goto LBL_EXIT;
  }
  #if MVM_SAFE_MODE
    memset(vm, 0, allocationSize);
  #else
    memset(vm, 0, sizeof (mvm_VM));
  #endif
  resolvedImports = vm_getResolvedImports(vm);
  vm->context = context;
  vm->pBytecode = pBytecode;
  vm->dataMemory = (void*)(resolvedImports + importCount);
  vm->uniqueStrings = VM_VALUE_NULL;
  vm->arrayProto = VM_READ_BC_2_HEADER_FIELD(arrayProtoPointer, pBytecode);

  pImportTableStart = MVM_PROGMEM_P_ADD(pBytecode, importTableOffset);
  pImportTableEnd = MVM_PROGMEM_P_ADD(pImportTableStart, importTableSize);
  // Resolve imports (linking)
  resolvedImport = resolvedImports;
  pImportTableEntry = pImportTableStart;
  while (pImportTableEntry < pImportTableEnd) {
    CODE_COVERAGE(431); // Hit
    mvm_HostFunctionID hostFunctionID = MVM_READ_PROGMEM_2(pImportTableEntry);
    pImportTableEntry = MVM_PROGMEM_P_ADD(pImportTableEntry, sizeof (vm_TsImportTableEntry));
    mvm_TfHostFunction handler = NULL;
    err = resolveImport(hostFunctionID, context, &handler);
    if (err != MVM_E_SUCCESS) {
      CODE_COVERAGE_ERROR_PATH(432); // Not hit
      goto LBL_EXIT;
    }
    if (!handler) {
      CODE_COVERAGE_ERROR_PATH(433); // Not hit
      err = MVM_E_UNRESOLVED_IMPORT;
      goto LBL_EXIT;
    } else {
      CODE_COVERAGE(434); // Hit
    }
    *resolvedImport++ = handler;
  }

  // The GC is empty to start
  gc_freeGCMemory(vm);

  // Initialize data
  dataMemory = vm->dataMemory;
  VM_READ_BC_N_AT(dataMemory, initialDataOffset, initialDataSize, pBytecode);

  // Initialize heap
  initialHeapOffset = VM_READ_BC_2_HEADER_FIELD(initialHeapOffset, pBytecode);
  initialHeapSize = VM_READ_BC_2_HEADER_FIELD(initialHeapSize, pBytecode);
  if (initialHeapSize) {
    CODE_COVERAGE(435); // Hit
    gc_createNextBucket(vm, initialHeapSize);
    VM_ASSERT(vm, !vm->pLastBucket->prev); // Only one bucket
    uint8_t* heapStart = vm->pAllocationCursor;
    VM_READ_BC_N_AT(heapStart, initialHeapOffset, initialHeapSize, pBytecode);
    vm->vpAllocationCursor += initialHeapSize;
    vm->pAllocationCursor += initialHeapSize;
  } else {
    CODE_COVERAGE_UNTESTED(436); // Not hit
  }

LBL_EXIT:
  if (err != MVM_E_SUCCESS) {
    CODE_COVERAGE_ERROR_PATH(437); // Not hit
    *result = NULL;
    if (vm) {
      free(vm);
      vm = NULL;
    } else {
      CODE_COVERAGE_ERROR_PATH(438); // Not hit
    }
  } else {
    CODE_COVERAGE(439); // Hit
  }
  *result = vm;
  return err;
}

void* mvm_getContext(VM* vm) {
  return vm->context;
}

static const Value smallLiterals[] = {
  /* VM_SLV_NULL */         VM_VALUE_NULL,
  /* VM_SLV_UNDEFINED */    VM_VALUE_UNDEFINED,
  /* VM_SLV_FALSE */        VM_VALUE_FALSE,
  /* VM_SLV_TRUE */         VM_VALUE_TRUE,
  /* VM_SLV_INT_0 */        VM_TAG_INT | 0,
  /* VM_SLV_INT_1 */        VM_TAG_INT | 1,
  /* VM_SLV_INT_2 */        VM_TAG_INT | 2,
  /* VM_SLV_INT_MINUS_1 */  VM_TAG_INT | ((uint16_t)(-1) & VM_VALUE_MASK),
};
#define smallLiteralsSize (sizeof smallLiterals / sizeof smallLiterals[0])


static TeError vm_run(VM* vm) {
  CODE_COVERAGE(4); // Hit

  #define CACHE_REGISTERS() do { \
    vm_TsRegisters* reg = &vm->stack->reg; \
    programCounter = MVM_PROGMEM_P_ADD(vm->pBytecode, reg->programCounter); \
    argCount = reg->argCount; \
    pFrameBase = reg->pFrameBase; \
    pStackPointer = reg->pStackPointer; \
  } while (false)

  #define FLUSH_REGISTER_CACHE() do { \
    vm_TsRegisters* reg = &vm->stack->reg; \
    reg->programCounter = (BO_t)MVM_PROGMEM_P_SUB(programCounter, vm->pBytecode); \
    reg->argCount = argCount; \
    reg->pFrameBase = pFrameBase; \
    reg->pStackPointer = pStackPointer; \
  } while (false)

  #define READ_PGM_1(target) do { \
    target = MVM_READ_PROGMEM_1(programCounter);\
    programCounter = MVM_PROGMEM_P_ADD(programCounter, 1); \
  } while (false)

  #define READ_PGM_2(target) do { \
    target = MVM_READ_PROGMEM_2(programCounter); \
    programCounter = MVM_PROGMEM_P_ADD(programCounter, 2); \
  } while (false)

  // Reinterpret reg1 as 8-bit signed
  #define SIGN_EXTEND_REG_1() reg1 = (uint16_t)((int16_t)((int8_t)reg1))

  #define PUSH(v) *(pStackPointer++) = (v)
  #define POP() (*(--pStackPointer))
  #define INSTRUCTION_RESERVED() VM_ASSERT(vm, false)

  VM_SAFE_CHECK_NOT_NULL(vm);
  VM_SAFE_CHECK_NOT_NULL(vm->stack);

  uint16_t* dataMemory = vm->dataMemory;
  TeError err = MVM_E_SUCCESS;

  uint16_t* pFrameBase;
  uint16_t argCount; // Of active function
  register MVM_PROGMEM_P programCounter;
  register uint16_t* pStackPointer;
  register uint16_t reg1 = 0;
  register uint16_t reg2 = 0;
  register uint16_t reg3 = 0;

  CACHE_REGISTERS();

  #if MVM_DONT_TRUST_BYTECODE
    uint16_t bytecodeSize = VM_READ_BC_2_HEADER_FIELD(bytecodeSize, vm->pBytecode);
    uint16_t stringTableOffset = VM_READ_BC_2_HEADER_FIELD(stringTableOffset, vm->pBytecode);
    uint16_t stringTableSize = VM_READ_BC_2_HEADER_FIELD(stringTableSize, vm->pBytecode);

    VM_ASSERT(vm, stringTableSize <= 0x7FFF);
    // It's an implementation detail that no code starts before the end of the string table
    MVM_PROGMEM_P minProgramCounter = MVM_PROGMEM_P_ADD(vm->pBytecode, ((intptr_t)stringTableOffset + stringTableSize));
    MVM_PROGMEM_P maxProgramCounter = MVM_PROGMEM_P_ADD(vm->pBytecode, bytecodeSize);
  #endif

// This forms the start of the run loop
LBL_DO_NEXT_INSTRUCTION:
  CODE_COVERAGE(59); // Hit

  // Check we're within range
  #if MVM_DONT_TRUST_BYTECODE
  if ((programCounter < minProgramCounter) || (programCounter >= maxProgramCounter)) {
    VM_INVALID_BYTECODE(vm);
  }
  #endif

  // Instruction bytes are divided into two nibbles
  READ_PGM_1(reg3);
  reg1 = reg3 & 0xF;
  reg3 = reg3 >> 4;

  if (reg3 >= VM_OP_DIVIDER_1) {
    CODE_COVERAGE(428); // Hit
    reg2 = POP();
  } else {
    CODE_COVERAGE(429); // Hit
  }

  VM_ASSERT(vm, reg3 < VM_OP_END);
  MVM_SWITCH_CONTIGUOUS(reg3, (VM_OP_END - 1)) {

/* ------------------------------------------------------------------------- */
/*                         VM_OP_LOAD_SMALL_LITERAL                          */
/*   Expects:                                                                */
/*     reg1: small literal ID                                                */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS(VM_OP_LOAD_SMALL_LITERAL): {
      CODE_COVERAGE(60); // Hit
      TABLE_COVERAGE(reg1, smallLiteralsSize, 448); // Hit 8/8

      #if MVM_DONT_TRUST_BYTECODE
      if (reg1 >= smallLiteralsSize) {
        err = MVM_E_INVALID_BYTECODE;
        goto LBL_EXIT;
      }
      #endif
      reg1 = smallLiterals[reg1];
      goto LBL_TAIL_PUSH_REG1;
    }

/* ------------------------------------------------------------------------- */
/*                             VM_OP_LOAD_VAR_1                              */
/*   Expects:                                                                */
/*     reg1: variable index                                                  */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP_LOAD_VAR_1):
    LBL_OP_LOAD_VAR:
      CODE_COVERAGE(61); // Hit
      reg1 = pStackPointer[-reg1 - 1];
      goto LBL_TAIL_PUSH_REG1;

/* ------------------------------------------------------------------------- */
/*                            VM_OP_LOAD_GLOBAL_1                            */
/*   Expects:                                                                */
/*     reg1: variable index                                                  */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP_LOAD_GLOBAL_1):
    LBL_OP_LOAD_GLOBAL:
      CODE_COVERAGE(62); // Hit
      reg1 = dataMemory[reg1];
      goto LBL_TAIL_PUSH_REG1;

/* ------------------------------------------------------------------------- */
/*                             VM_OP_LOAD_ARG_1                              */
/*   Expects:                                                                */
/*     reg1: argument index                                                  */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP_LOAD_ARG_1):
      CODE_COVERAGE(63); // Hit
      goto LBL_OP_LOAD_ARG;

/* ------------------------------------------------------------------------- */
/*                               VM_OP_CALL_1                                */
/*   Expects:                                                                */
/*     reg1: index into short-call table                                     */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP_CALL_1): {
      CODE_COVERAGE_UNTESTED(66); // Not hit
      goto LBL_OP_CALL_1;
    }

/* ------------------------------------------------------------------------- */
/*                             VM_OP_EXTENDED_1                              */
/*   Expects:                                                                */
/*     reg1: vm_TeOpcodeEx1                                                  */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP_EXTENDED_1):
      CODE_COVERAGE(69); // Hit
      goto LBL_OP_EXTENDED_1;

/* ------------------------------------------------------------------------- */
/*                             VM_OP_EXTENDED_2                              */
/*   Expects:                                                                */
/*     reg1: vm_TeOpcodeEx2                                                  */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP_EXTENDED_2):
      CODE_COVERAGE(70); // Hit
      goto LBL_OP_EXTENDED_2;

/* ------------------------------------------------------------------------- */
/*                             VM_OP_EXTENDED_3                              */
/*   Expects:                                                                */
/*     reg1: vm_TeOpcodeEx3                                                  */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP_EXTENDED_3):
      CODE_COVERAGE(71); // Hit
      goto LBL_OP_EXTENDED_3;

/* ------------------------------------------------------------------------- */
/*                                VM_OP_POP                                  */
/*   Expects:                                                                */
/*     reg1: pop count - 1                                                   */
/*     reg2: unused value already popped off the stack                       */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP_POP): {
      CODE_COVERAGE(72); // Hit
      pStackPointer -= reg1;
      goto LBL_DO_NEXT_INSTRUCTION;
    }

/* ------------------------------------------------------------------------- */
/*                             VM_OP_STORE_VAR_1                             */
/*   Expects:                                                                */
/*     reg1: variable index relative to stack pointer                        */
/*     reg2: value to store                                                  */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP_STORE_VAR_1): {
      CODE_COVERAGE(73); // Hit
    LBL_OP_STORE_VAR:
      // Note: the value to store has already been popped off the stack at this
      // point. The index 0 refers to the slot currently at the top of the
      // stack.
      pStackPointer[-reg1 - 1] = reg2;
      goto LBL_DO_NEXT_INSTRUCTION;
    }

/* ------------------------------------------------------------------------- */
/*                           VM_OP_STORE_GLOBAL_1                            */
/*   Expects:                                                                */
/*     reg1: variable index                                                  */
/*     reg2: value to store                                                  */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP_STORE_GLOBAL_1): {
      CODE_COVERAGE(74); // Hit
    LBL_OP_STORE_GLOBAL:
      dataMemory[reg1] = reg2;
      goto LBL_DO_NEXT_INSTRUCTION;
    }

/* ------------------------------------------------------------------------- */
/*                            VM_OP_STRUCT_GET_1                             */
/*   Expects:                                                                */
/*     reg1: field index                                                     */
/*     reg2: struct reference                                                */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP_STRUCT_GET_1): {
      CODE_COVERAGE_UNTESTED(75); // Not hit
    LBL_OP_STRUCT_GET:
      INSTRUCTION_RESERVED();
      goto LBL_DO_NEXT_INSTRUCTION;
    }

/* ------------------------------------------------------------------------- */
/*                            VM_OP_STRUCT_SET_1                             */
/*   Expects:                                                                */
/*     reg1: field index                                                     */
/*     reg2: value to store                                                  */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP_STRUCT_SET_1): {
      CODE_COVERAGE_UNTESTED(76); // Not hit
    LBL_OP_STRUCT_SET:
      INSTRUCTION_RESERVED();
      goto LBL_DO_NEXT_INSTRUCTION;
    }

/* ------------------------------------------------------------------------- */
/*                              VM_OP_NUM_OP                                 */
/*   Expects:                                                                */
/*     reg1: vm_TeNumberOp                                                   */
/*     reg2: first popped operand                                            */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP_NUM_OP): {
      CODE_COVERAGE(77); // Hit
      goto LBL_OP_NUM_OP;
    } // End of case VM_OP_NUM_OP

/* ------------------------------------------------------------------------- */
/*                              VM_OP_BIT_OP                                 */
/*   Expects:                                                                */
/*     reg1: vm_TeBitwiseOp                                                  */
/*     reg2: first popped operand                                            */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP_BIT_OP): {
      CODE_COVERAGE(92); // Hit
      goto LBL_OP_BIT_OP;
    }

  } // End of primary switch

  // All cases should loop explicitly back
  VM_ASSERT_UNREACHABLE(vm);

/* ------------------------------------------------------------------------- */
/*                             LBL_OP_LOAD_ARG                              */
/*   Expects:                                                                */
/*     reg1: argument index                                                  */
/* ------------------------------------------------------------------------- */
LBL_OP_LOAD_ARG: {
  CODE_COVERAGE(32); // Hit
  if (reg1 < argCount) {
    CODE_COVERAGE(64); // Hit
    reg1 = pFrameBase[-3 - (int16_t)argCount + reg1];
  } else {
    CODE_COVERAGE_UNTESTED(65); // Not hit
    reg1 = VM_VALUE_UNDEFINED;
  }
  goto LBL_TAIL_PUSH_REG1;
}

/* ------------------------------------------------------------------------- */
/*                               LBL_OP_CALL_1                               */
/*   Expects:                                                                */
/*     reg1: index into short-call table                                     */
/* ------------------------------------------------------------------------- */

LBL_OP_CALL_1: {
  CODE_COVERAGE_UNTESTED(173); // Not hit
  MVM_PROGMEM_P pBytecode = vm->pBytecode;
  BO_t shortCallTableOffset = VM_READ_BC_2_HEADER_FIELD(shortCallTableOffset, pBytecode);
  MVM_PROGMEM_P shortCallTableEntry = MVM_PROGMEM_P_ADD(pBytecode, shortCallTableOffset + reg1 * sizeof (vm_TsShortCallTableEntry));

  #if MVM_SAFE_MODE
    uint16_t shortCallTableSize = VM_READ_BC_2_HEADER_FIELD(shortCallTableOffset, pBytecode);
    MVM_PROGMEM_P shortCallTableEnd = MVM_PROGMEM_P_ADD(pBytecode, shortCallTableOffset + shortCallTableSize);
    VM_ASSERT(vm, shortCallTableEntry < shortCallTableEnd);
  #endif

  uint16_t tempFunction = MVM_READ_PROGMEM_2(shortCallTableEntry);
  shortCallTableEntry = MVM_PROGMEM_P_ADD(shortCallTableEntry, 2);
  uint8_t tempArgCount = MVM_READ_PROGMEM_1(shortCallTableEntry);

  // The high bit of function indicates if this is a call to the host
  bool isHostCall = tempFunction & 0x8000;
  tempFunction = tempFunction & 0x7FFF;

  reg1 = tempArgCount;

  if (isHostCall) {
    CODE_COVERAGE_UNTESTED(67); // Not hit
    reg2 = tempFunction;
    reg3 = 0; // Indicates that a function pointer was not pushed onto the stack to make this call
    goto LBL_CALL_HOST_COMMON;
  } else {
    CODE_COVERAGE_UNTESTED(68); // Not hit
    reg2 = tempFunction;
    goto LBL_CALL_COMMON;
  }
} // LBL_OP_CALL_1

/* ------------------------------------------------------------------------- */
/*                              LBL_OP_BIT_OP                                */
/*   Expects:                                                                */
/*     reg1: vm_TeBitwiseOp                                                  */
/*     reg2: first popped operand                                            */
/* ------------------------------------------------------------------------- */
LBL_OP_BIT_OP: {
  int32_t reg1I = 0;
  int32_t reg2I = 0;
  int8_t reg2B = 0;

  reg3 = reg1;

  // Convert second operand to an int32
  reg2I = mvm_toInt32(vm, reg2);

  // If it's a binary operator, then we pop a second operand
  if (reg3 < VM_BIT_OP_DIVIDER_2) {
    CODE_COVERAGE(117); // Hit
    reg1 = POP();
    reg1I = mvm_toInt32(vm, reg1);

    // If we're doing a shift operation, the operand is in the 0-32 range
    if (reg3 < VM_BIT_OP_END_OF_SHIFT_OPERATORS) {
      reg2B = reg2I & 0x1F;
    }
  } else {
    CODE_COVERAGE(118); // Hit
  }

  VM_ASSERT(vm, reg3 < VM_BIT_OP_END);
  MVM_SWITCH_CONTIGUOUS (reg3, (VM_BIT_OP_END - 1)) {
    MVM_CASE_CONTIGUOUS(VM_BIT_OP_SHR_ARITHMETIC): {
      CODE_COVERAGE(93); // Hit
      reg1I = reg1I >> reg2B;
      break;
    }
    MVM_CASE_CONTIGUOUS(VM_BIT_OP_SHR_LOGICAL): {
      CODE_COVERAGE(94); // Hit
      // Cast the number to unsigned int so that the C interprets the shift
      // as unsigned/logical rather than signed/arithmetic.
      reg1I = (int32_t)((uint32_t)reg1I >> reg2B);
      #if MVM_SUPPORT_FLOAT && MVM_PORT_INT32_OVERFLOW_CHECKS
        // This is a rather annoying edge case if you ask me, since all
        // other bitwise operations yield signed int32 results every time.
        // If the shift is by exactly zero units, then negative numbers
        // become positive and overflow the signed-32 bit type. Since we
        // don't have an unsigned 32 bit type, this means they need to be
        // extended to floats.
        // https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Bitwise_Operators#Signed_32-bit_integers
        if ((reg2B == 0) & (reg1I < 0)) {
          reg1 = mvm_newNumber(vm, (MVM_FLOAT64)((uint32_t)reg1I));
          goto LBL_TAIL_PUSH_REG1;
        }
      #endif // MVM_PORT_INT32_OVERFLOW_CHECKS
      break;
    }
    MVM_CASE_CONTIGUOUS(VM_BIT_OP_SHL): {
      CODE_COVERAGE(95); // Hit
      reg1I = reg1I << reg2B;
      break;
    }
    MVM_CASE_CONTIGUOUS(VM_BIT_OP_OR): {
      CODE_COVERAGE(96); // Hit
      reg1I = reg1I | reg2I;
      break;
    }
    MVM_CASE_CONTIGUOUS(VM_BIT_OP_AND): {
      CODE_COVERAGE(97); // Hit
      reg1I = reg1I & reg2I;
      break;
    }
    MVM_CASE_CONTIGUOUS(VM_BIT_OP_XOR): {
      CODE_COVERAGE(98); // Hit
      reg1I = reg1I ^ reg2I;
      break;
    }
    MVM_CASE_CONTIGUOUS(VM_BIT_OP_NOT): {
      CODE_COVERAGE(99); // Hit
      reg1I = ~reg2I;
      break;
    }
  }

  CODE_COVERAGE(101); // Hit
  // Convert the result from a 32-bit integer
  reg1 = mvm_newInt32(vm, reg1I);
  goto LBL_TAIL_PUSH_REG1;
} // End of LBL_OP_BIT_OP

/* ------------------------------------------------------------------------- */
/*                             LBL_OP_EXTENDED_1                             */
/*   Expects:                                                                */
/*     reg1: vm_TeOpcodeEx1                                                  */
/* ------------------------------------------------------------------------- */

LBL_OP_EXTENDED_1: {
  CODE_COVERAGE(102); // Hit

  reg3 = reg1;

  if (reg3 >= VM_OP1_DIVIDER_1) {
    CODE_COVERAGE(103); // Hit
    reg2 = POP();
    reg1 = POP();
  } else {
    CODE_COVERAGE(104); // Hit
  }

  VM_ASSERT(vm, reg3 <= VM_OP1_END);
  MVM_SWITCH_CONTIGUOUS (reg3, VM_OP1_END - 1) {

/* ------------------------------------------------------------------------- */
/*                              VM_OP1_RETURN_x                              */
/*   Expects: -                                                              */
/*     reg1: vm_TeOpcodeEx1                                                  */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP1_RETURN_1):
    MVM_CASE_CONTIGUOUS (VM_OP1_RETURN_2):
    MVM_CASE_CONTIGUOUS (VM_OP1_RETURN_3):
    MVM_CASE_CONTIGUOUS (VM_OP1_RETURN_4): {
      CODE_COVERAGE(105); // Hit
      // reg2 is used for the result
      if (reg1 & VM_RETURN_FLAG_UNDEFINED) {
        CODE_COVERAGE_UNTESTED(106); // Not hit
        reg2 = VM_VALUE_UNDEFINED;
      } else {
        CODE_COVERAGE(107); // Hit
        reg2 = POP();
      }

      // reg3 is the original arg count
      reg3 = argCount;

      // Pop variables/parameters
      pStackPointer = pFrameBase;

      // Restore caller state
      programCounter = MVM_PROGMEM_P_ADD(vm->pBytecode, POP());
      argCount = POP();
      pFrameBase = VM_BOTTOM_OF_STACK(vm) + POP();

      // Pop arguments
      pStackPointer -= reg3;
      // Pop function reference
      if (reg1 & VM_RETURN_FLAG_POP_FUNCTION) {
        CODE_COVERAGE(108); // Hit
        (void)POP();
      } else {
        CODE_COVERAGE_UNTESTED(109); // Not hit
      }

      // Push result
      PUSH(reg2);

      if (programCounter == vm->pBytecode) {
        CODE_COVERAGE(110); // Hit
        goto LBL_EXIT;
      } else {
        CODE_COVERAGE(111); // Hit
      }
      goto LBL_DO_NEXT_INSTRUCTION;
    }

/* ------------------------------------------------------------------------- */
/*                              VM_OP1_OBJECT_NEW                            */
/*   Expects: -                                                              */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP1_OBJECT_NEW): {
      CODE_COVERAGE(112); // Hit
      TsPropertyList* pObject;
      reg1 = gc_allocateWithHeader(vm, sizeof (TsPropertyList), TC_REF_PROPERTY_LIST, (void**)&pObject);
      pObject->first = 0;
      goto LBL_TAIL_PUSH_REG1;
    }

/* ------------------------------------------------------------------------- */
/*                               VM_OP1_LOGICAL_NOT                          */
/*   Expects: -                                                              */
/*     reg1: erroneously popped value                                        */
/*     reg2: value to operate on (popped from stack)                         */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP1_LOGICAL_NOT): {
      CODE_COVERAGE(113); // Hit
      // This operation is grouped as a binary operation, but it actually
      // only uses one operand, so we need to push the other back onto the
      // stack.
      PUSH(reg1);
      reg1 = mvm_toBool(vm, reg2) ? VM_VALUE_FALSE : VM_VALUE_TRUE;
      goto LBL_TAIL_PUSH_REG1;
    }

/* ------------------------------------------------------------------------- */
/*                              VM_OP1_OBJECT_GET_1                          */
/*   Expects: -                                                              */
/*     reg1: objectValue                                                     */
/*     reg2: propertyName                                                    */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP1_OBJECT_GET_1): {
      CODE_COVERAGE(114); // Hit
      Value propValue;
      err = getProperty(vm, reg1, reg2, &propValue);
      reg1 = propValue;
      if (err != MVM_E_SUCCESS) goto LBL_EXIT;
      goto LBL_TAIL_PUSH_REG1;
    }

/* ------------------------------------------------------------------------- */
/*                                 VM_OP1_ADD                                */
/*   Expects: -                                                              */
/*     reg1: left operand                                                    */
/*     reg2: right operand                                                   */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP1_ADD): {
      CODE_COVERAGE(115); // Hit
      // Special case for adding unsigned 12 bit numbers, for example in most
      // loops. 12 bit unsigned addition does not require any overflow checks
      if (((reg1 & 0xF000) == 0) && ((reg2 & 0xF000) == 0)) {
        CODE_COVERAGE(116); // Hit
        reg1 = reg1 + reg2;
        goto LBL_TAIL_PUSH_REG1;
      } else {
        CODE_COVERAGE(119); // Hit
      }
      if (vm_isString(vm, reg1) || vm_isString(vm, reg2)) {
        CODE_COVERAGE(120); // Hit
        reg1 = vm_convertToString(vm, reg1);
        reg2 = vm_convertToString(vm, reg2);
        reg1 = vm_concat(vm, reg1, reg2);
        goto LBL_TAIL_PUSH_REG1;
      } else {
        CODE_COVERAGE(121); // Hit
        // Interpret like any of the other numeric operations
        PUSH(reg1);
        reg1 = VM_NUM_OP_ADD_NUM;
        goto LBL_OP_NUM_OP;
      }
    }

/* ------------------------------------------------------------------------- */
/*                                 VM_OP1_EQUAL                              */
/*   Expects: -                                                              */
/*     reg1: left operand                                                    */
/*     reg2: right operand                                                   */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP1_EQUAL): {
      CODE_COVERAGE_UNTESTED(122); // Not hit
      if (mvm_equal(vm, reg1, reg2)) {
        CODE_COVERAGE_UNTESTED(483); // Not hit
        reg1 = VM_VALUE_TRUE;
      } else {
        CODE_COVERAGE_UNTESTED(484); // Not hit
        reg1 = VM_VALUE_FALSE;
      }
      goto LBL_TAIL_PUSH_REG1;
    }

/* ------------------------------------------------------------------------- */
/*                                 VM_OP1_NOT_EQUAL                          */
/*   Expects: -                                                              */
/*     reg1: left operand                                                    */
/*     reg2: right operand                                                   */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP1_NOT_EQUAL): {
      if(mvm_equal(vm, reg1, reg2)) {
        CODE_COVERAGE_UNTESTED(123); // Not hit
        reg1 = VM_VALUE_FALSE;
      } else {
        CODE_COVERAGE(485); // Hit
        reg1 = VM_VALUE_TRUE;
      }
      goto LBL_TAIL_PUSH_REG1;
    }

/* ------------------------------------------------------------------------- */
/*                                 VM_OP1_OBJECT_SET_1                       */
/*   Expects: -                                                              */
/*     reg1: property name                                                   */
/*     reg2: value                                                           */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP1_OBJECT_SET_1): {
      CODE_COVERAGE(124); // Hit
      reg3 = POP(); // object
      err = setProperty(vm, reg3, reg1, reg2);
      if (err != MVM_E_SUCCESS) {
        CODE_COVERAGE_UNTESTED(125); // Not hit
        goto LBL_EXIT;
      } else {
        CODE_COVERAGE(126); // Hit
      }
      goto LBL_DO_NEXT_INSTRUCTION;
    }

  } // End of VM_OP_EXTENDED_1 switch

  // All cases should jump to whatever tail they intend. Nothing should get here
  VM_ASSERT_UNREACHABLE(vm);

} // End of LBL_OP_EXTENDED_1

/* ------------------------------------------------------------------------- */
/*                              VM_OP_NUM_OP                                 */
/*   Expects:                                                                */
/*     reg1: vm_TeNumberOp                                                   */
/*     reg2: first popped operand                                            */
/* ------------------------------------------------------------------------- */
LBL_OP_NUM_OP: {
  CODE_COVERAGE(25); // Hit

  int32_t reg1I = 0;
  int32_t reg2I = 0;

  reg3 = reg1;

  // If it's a binary operator, then we pop a second operand
  if (reg3 < VM_NUM_OP_DIVIDER) {
    CODE_COVERAGE(440); // Hit
    reg1 = POP();

    if (toInt32Internal(vm, reg1, &reg1I) != MVM_E_SUCCESS) {
      CODE_COVERAGE(444); // Hit
      #if MVM_SUPPORT_FLOAT
      goto LBL_NUM_OP_FLOAT64;
      #endif // MVM_SUPPORT_FLOAT
    } else {
      CODE_COVERAGE(445); // Hit
    }
  } else {
    CODE_COVERAGE(441); // Hit
    reg1 = 0;
  }

  // Convert second operand to a int32
  if (toInt32Internal(vm, reg2, &reg2I) != MVM_E_SUCCESS) {
    CODE_COVERAGE(442); // Hit
    #if MVM_SUPPORT_FLOAT
    goto LBL_NUM_OP_FLOAT64;
    #endif // MVM_SUPPORT_FLOAT
  } else {
    CODE_COVERAGE(443); // Hit
  }

  VM_ASSERT(vm, reg3 < VM_NUM_OP_END);
  MVM_SWITCH_CONTIGUOUS (reg3, (VM_NUM_OP_END - 1)) {
    MVM_CASE_CONTIGUOUS(VM_NUM_OP_LESS_THAN): {
      CODE_COVERAGE(78); // Hit
      reg1 = reg1I < reg2I;
      goto LBL_TAIL_PUSH_REG1_BOOL;
    }
    MVM_CASE_CONTIGUOUS(VM_NUM_OP_GREATER_THAN): {
      CODE_COVERAGE(79); // Hit
      reg1 = reg1I > reg2I;
      goto LBL_TAIL_PUSH_REG1_BOOL;
    }
    MVM_CASE_CONTIGUOUS(VM_NUM_OP_LESS_EQUAL): {
      CODE_COVERAGE(80); // Hit
      reg1 = reg1I <= reg2I;
      goto LBL_TAIL_PUSH_REG1_BOOL;
    }
    MVM_CASE_CONTIGUOUS(VM_NUM_OP_GREATER_EQUAL): {
      CODE_COVERAGE(81); // Hit
      reg1 = reg1I >= reg2I;
      goto LBL_TAIL_PUSH_REG1_BOOL;
    }
    MVM_CASE_CONTIGUOUS(VM_NUM_OP_ADD_NUM): {
      CODE_COVERAGE(82); // Hit
      #if MVM_SUPPORT_FLOAT && MVM_PORT_INT32_OVERFLOW_CHECKS
        #if __has_builtin(__builtin_add_overflow)
          if (__builtin_add_overflow(reg1I, reg2I, &reg1I)) {
            goto LBL_NUM_OP_FLOAT64;
          }
        #else // No builtin overflow
          int32_t result = reg1I + reg2I;
          // Check overflow https://blog.regehr.org/archives/1139
          if (((reg1I ^ result) & (reg2I ^ result)) < 0) goto LBL_NUM_OP_FLOAT64;
          reg1I = result;
        #endif // No builtin overflow
      #else // No overflow checks
        reg1I = reg1I + reg2I;
      #endif
      break;
    }
    MVM_CASE_CONTIGUOUS(VM_NUM_OP_SUBTRACT): {
      CODE_COVERAGE(83); // Hit
      #if MVM_SUPPORT_FLOAT && MVM_PORT_INT32_OVERFLOW_CHECKS
        #if __has_builtin(__builtin_sub_overflow)
          if (__builtin_sub_overflow(reg1I, reg2I, &reg1I)) {
            goto LBL_NUM_OP_FLOAT64;
          }
        #else // No builtin overflow
          reg2I = -reg2I;
          int32_t result = reg1I + reg2I;
          // Check overflow https://blog.regehr.org/archives/1139
          if (((reg1I ^ result) & (reg2I ^ result)) < 0) goto LBL_NUM_OP_FLOAT64;
          reg1I = result;
        #endif // No builtin overflow
      #else // No overflow checks
        reg1I = reg1I - reg2I;
      #endif
      break;
    }
    MVM_CASE_CONTIGUOUS(VM_NUM_OP_MULTIPLY): {
      CODE_COVERAGE(84); // Hit
      #if MVM_SUPPORT_FLOAT && MVM_PORT_INT32_OVERFLOW_CHECKS
        #if __has_builtin(__builtin_mul_overflow)
          if (__builtin_mul_overflow(reg1I, reg2I, &reg1I)) {
            goto LBL_NUM_OP_FLOAT64;
          }
        #else // No builtin overflow
          // There isn't really an efficient way to determine multiplied
          // overflow on embedded devices without accessing the hardware
          // status registers. The fast shortcut here is to just assume that
          // anything more than 14-bit multiplication could overflow a 32-bit
          // integer.
          if (VM_IS_INT14(reg1) && VM_IS_INT14(reg2)) {
            reg1I = reg1I * reg2I;
          } else {
            goto LBL_NUM_OP_FLOAT64;
          }
        #endif // No builtin overflow
      #else // No overflow checks
        reg1I = reg1I * reg2I;
      #endif
      break;
    }
    MVM_CASE_CONTIGUOUS(VM_NUM_OP_DIVIDE): {
      CODE_COVERAGE(85); // Hit
      #if MVM_SUPPORT_FLOAT
        // With division, we leave it up to the user to write code that
        // performs integer division instead of floating point division, so
        // this instruction is always the case where they're doing floating
        // point division.
        goto LBL_NUM_OP_FLOAT64;
      #else // !MVM_SUPPORT_FLOAT
        err = MVM_E_OPERATION_REQUIRES_FLOAT_SUPPORT;
        goto LBL_EXIT;
      #endif
    }
    MVM_CASE_CONTIGUOUS(VM_NUM_OP_DIVIDE_AND_TRUNC): {
      CODE_COVERAGE(86); // Hit
      if (reg2I == 0) {
        reg1I = 0;
        break;
      }
      reg1I = reg1I / reg2I;
      break;
    }
    MVM_CASE_CONTIGUOUS(VM_NUM_OP_REMAINDER): {
      CODE_COVERAGE(87); // Hit
      if (reg2I == 0) {
        CODE_COVERAGE(26); // Hit
        reg1 = VM_VALUE_NAN;
        goto LBL_TAIL_PUSH_REG1;
      }
      CODE_COVERAGE(90); // Hit
      reg1I = reg1I % reg2I;
      break;
    }
    MVM_CASE_CONTIGUOUS(VM_NUM_OP_POWER): {
      CODE_COVERAGE(88); // Hit
      #if MVM_SUPPORT_FLOAT
        // Maybe in future we can we implement an integer version.
        goto LBL_NUM_OP_FLOAT64;
      #else // !MVM_SUPPORT_FLOAT
        err = MVM_E_OPERATION_REQUIRES_FLOAT_SUPPORT;
        goto LBL_EXIT;
      #endif
    }
    MVM_CASE_CONTIGUOUS(VM_NUM_OP_NEGATE): {
      CODE_COVERAGE(89); // Hit
      #if MVM_SUPPORT_FLOAT && MVM_PORT_INT32_OVERFLOW_CHECKS
        // Note: Zero negates to negative zero, which is not representable as an int32
        if ((reg2I == INT32_MIN) || (reg2I == 0)) goto LBL_NUM_OP_FLOAT64;
      #endif
        reg1I = -reg2I;
      break;
    }
    MVM_CASE_CONTIGUOUS(VM_NUM_OP_UNARY_PLUS): {
      reg1I = reg2I;
      break;
    }
  } // End of switch vm_TeNumberOp for int32

  // Convert the result from a 32-bit integer
  reg1 = mvm_newInt32(vm, reg1I);
  goto LBL_TAIL_PUSH_REG1;
} // End of case LBL_OP_NUM_OP

/* ------------------------------------------------------------------------- */
/*                             LBL_OP_EXTENDED_2                             */
/*   Expects:                                                                */
/*     reg1: vm_TeOpcodeEx2                                                  */
/* ------------------------------------------------------------------------- */

LBL_OP_EXTENDED_2: {
  CODE_COVERAGE(127); // Hit
  reg3 = reg1;

  // All the ex-2 instructions have an 8-bit parameter. This is stored in
  // reg1 for consistency with 4-bit and 16-bit literal modes
  READ_PGM_1(reg1);

  // Some operations pop an operand off the stack. This goes into reg2
  if (reg3 < VM_OP2_DIVIDER_1) {
    CODE_COVERAGE(128); // Hit
    reg2 = POP();
  } else {
    CODE_COVERAGE(129); // Hit
  }

  VM_ASSERT(vm, reg3 < VM_OP2_END);
  MVM_SWITCH_CONTIGUOUS (reg3, (VM_OP2_END - 1)) {

/* ------------------------------------------------------------------------- */
/*                             VM_OP2_BRANCH_1                              */
/*   Expects:                                                                */
/*     reg1: signed 8-bit offset to branch to, encoded in 16-bit unsigned    */
/*     reg2: condition to branch on                                          */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP2_BRANCH_1): {
      CODE_COVERAGE(130); // Hit
      SIGN_EXTEND_REG_1();
      goto LBL_BRANCH_COMMON;
    }

/* ------------------------------------------------------------------------- */
/*                             VM_OP2_STORE_ARG                             */
/*   Expects:                                                                */
/*     reg1: unsigned index of argument in which to store                    */
/*     reg2: value to store                                                  */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP2_STORE_ARG): {
      CODE_COVERAGE_UNTESTED(131); // Not hit
      VM_NOT_IMPLEMENTED(vm);
      goto LBL_DO_NEXT_INSTRUCTION;
    }

/* ------------------------------------------------------------------------- */
/*                             VM_OP2_STORE_GLOBAL_2                        */
/*   Expects:                                                                */
/*     reg1: unsigned index of global in which to store                      */
/*     reg2: value to store                                                  */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP2_STORE_GLOBAL_2): {
      CODE_COVERAGE_UNTESTED(132); // Not hit
      goto LBL_OP_STORE_GLOBAL;
    }

/* ------------------------------------------------------------------------- */
/*                             VM_OP2_STORE_VAR_2                            */
/*   Expects:                                                                */
/*     reg1: unsigned index of variable in which to store, relative to SP    */
/*     reg2: value to store                                                  */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP2_STORE_VAR_2): {
      CODE_COVERAGE_UNTESTED(133); // Not hit
      goto LBL_OP_STORE_VAR;
    }

/* ------------------------------------------------------------------------- */
/*                             VM_OP2_STRUCT_GET_2                          */
/*   Expects:                                                                */
/*     reg1: unsigned index of field                                         */
/*     reg2: reference to struct                                             */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP2_STRUCT_GET_2): {
      CODE_COVERAGE_UNTESTED(134); // Not hit
      goto LBL_OP_STRUCT_GET;
    }

/* ------------------------------------------------------------------------- */
/*                             VM_OP2_STRUCT_SET_2                          */
/*   Expects:                                                                */
/*     reg1: unsigned index of field                                         */
/*     reg2: value to store                                                  */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP2_STRUCT_SET_2): {
      CODE_COVERAGE_UNTESTED(135); // Not hit
      goto LBL_OP_STRUCT_SET;
    }

/* ------------------------------------------------------------------------- */
/*                             VM_OP2_JUMP_1                                */
/*   Expects:                                                                */
/*     reg1: signed 8-bit offset to branch to, encoded in 16-bit unsigned    */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP2_JUMP_1): {
      CODE_COVERAGE(136); // Hit
      SIGN_EXTEND_REG_1();
      goto LBL_JUMP_COMMON;
    }

/* ------------------------------------------------------------------------- */
/*                             VM_OP2_CALL_HOST                             */
/*   Expects:                                                                */
/*     reg1: arg count                                                       */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP2_CALL_HOST): {
      CODE_COVERAGE_UNTESTED(137); // Not hit
      // Function index is in reg2
      READ_PGM_1(reg2);
      reg3 = 0; // Indicate that function pointer is static (was not pushed onto the stack)
      goto LBL_CALL_HOST_COMMON;
    }

/* ------------------------------------------------------------------------- */
/*                             VM_OP2_CALL_3                                */
/*   Expects:                                                                */
/*     reg1: arg count                                                       */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP2_CALL_3): {
      CODE_COVERAGE(138); // Hit
      // The function was pushed before the arguments
      Value functionValue = pStackPointer[-reg1 - 1];

      // Functions can only be bytecode memory, so if it's not in bytecode then it's not a function
      if (!VM_IS_PGM_P(functionValue)) {
        CODE_COVERAGE_ERROR_PATH(139); // Not hit
        err = MVM_E_TARGET_NOT_CALLABLE;
        goto LBL_EXIT;
      } else {
        CODE_COVERAGE(140); // Hit
      }

      uint16_t headerWord = vm_readHeaderWord(vm, functionValue);
      TeTypeCode typeCode = vm_getTypeCodeFromHeaderWord(headerWord);
      if (typeCode == TC_REF_FUNCTION) {
        CODE_COVERAGE(141); // Hit
        VM_ASSERT(vm, VM_IS_PGM_P(functionValue));
        reg2 = VM_VALUE_OF(functionValue);
        goto LBL_CALL_COMMON;
      } else {
        CODE_COVERAGE(142); // Hit
      }

      if (typeCode == TC_REF_HOST_FUNC) {
        CODE_COVERAGE(143); // Hit
        reg2 = vm_readUInt16(vm, functionValue);
        reg3 = 1; // Indicates that function pointer was pushed onto the stack to make this call
        goto LBL_CALL_HOST_COMMON;
      } else {
        CODE_COVERAGE_ERROR_PATH(144); // Not hit
      }

      err = MVM_E_TARGET_NOT_CALLABLE;
      goto LBL_EXIT;
    }

/* ------------------------------------------------------------------------- */
/*                             VM_OP2_CALL_2                                */
/*   Expects:                                                                */
/*     reg1: arg count                                                       */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP2_CALL_2): {
      CODE_COVERAGE_UNTESTED(145); // Not hit
      // Uses 16 bit literal for function offset
      READ_PGM_2(reg2);
      goto LBL_CALL_COMMON;
    }

/* ------------------------------------------------------------------------- */
/*                             VM_OP2_LOAD_GLOBAL_2                         */
/*   Expects:                                                                */
/*     reg1: unsigned global variable index                                  */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP2_LOAD_GLOBAL_2): {
      CODE_COVERAGE(146); // Hit
      goto LBL_OP_LOAD_GLOBAL;
    }

/* ------------------------------------------------------------------------- */
/*                              VM_OP2_LOAD_VAR_2                           */
/*   Expects:                                                                */
/*     reg1: unsigned variable index relative to stack pointer               */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP2_LOAD_VAR_2): {
      CODE_COVERAGE_UNTESTED(147); // Not hit
      goto LBL_OP_LOAD_VAR;
    }

/* ------------------------------------------------------------------------- */
/*                              VM_OP2_LOAD_ARG_2                           */
/*   Expects:                                                                */
/*     reg1: unsigned variable index relative to stack pointer               */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP2_LOAD_ARG_2): {
      CODE_COVERAGE_UNTESTED(148); // Not hit
      VM_NOT_IMPLEMENTED(vm);
      goto LBL_DO_NEXT_INSTRUCTION;
    }

/* ------------------------------------------------------------------------- */
/*                              VM_OP2_RETURN_ERROR                         */
/*   Expects:                                                                */
/*     reg1: mvm_TeError                                                     */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP2_RETURN_ERROR): {
      CODE_COVERAGE_ERROR_PATH(149); // Not hit
      err = (TeError)reg1;
      goto LBL_EXIT;
    }

/* ------------------------------------------------------------------------- */
/*                              VM_OP2_ARRAY_NEW                             */
/*   reg1: Array capacity                                                    */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP2_ARRAY_NEW): {
      CODE_COVERAGE(100); // Hit

      // Allocation size excluding header
      uint16_t capacity = reg1;

      uint16_t* pAlloc;
      TABLE_COVERAGE(capacity ? 1 : 0, 2, 371); // Hit 2/2
      // Allocation both the array root allocation and data allocation at the same time
      reg1 = gc_allocateWithoutHeader(vm, 2 + sizeof (TsArray) + (intptr_t)capacity * 2, (void**)&pAlloc);
      // The size in the header is always 6 bytes, because this is actually 2 allocations in one
      *pAlloc++ = (TC_REF_ARRAY << 12) | (sizeof (TsArray));
      reg1 += 2;

      Pointer dataP = capacity ? reg1 + sizeof(TsArray) : 0;
      *pAlloc++ = dataP;
      *pAlloc++ = 0; // length
      *pAlloc++ = capacity; // capacity
      while (capacity--)
        *pAlloc++ = VM_VALUE_DELETED;

      goto LBL_TAIL_PUSH_REG1;
    }

  } // End of vm_TeOpcodeEx2 switch

  // All cases should jump to whatever tail they intend. Nothing should get here
  VM_ASSERT_UNREACHABLE(vm);

} // End of LBL_OP_EXTENDED_2

/* ------------------------------------------------------------------------- */
/*                             LBL_OP_EXTENDED_3                             */
/*   Expects:                                                                */
/*     reg1: vm_TeOpcodeEx3                                                  */
/* ------------------------------------------------------------------------- */

LBL_OP_EXTENDED_3:  {
  CODE_COVERAGE(150); // Hit
  reg3 = reg1;

  // Ex-3 instructions have a 16-bit parameter
  READ_PGM_2(reg1);

  if (reg3 >= VM_OP3_DIVIDER_1) {
    CODE_COVERAGE(151); // Hit
    reg2 = POP();
  } else {
    CODE_COVERAGE(152); // Hit
  }

  VM_ASSERT(vm, reg3 < VM_OP3_END);
  MVM_SWITCH_CONTIGUOUS (reg3, (VM_OP3_END - 1)) {

/* ------------------------------------------------------------------------- */
/*                             VM_OP3_JUMP_2                                 */
/*   Expects:                                                                */
/*     reg1: signed offset                                                   */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP3_JUMP_2): {
      CODE_COVERAGE(153); // Hit
      goto LBL_JUMP_COMMON;
    }

/* ------------------------------------------------------------------------- */
/*                             VM_OP3_LOAD_LITERAL                           */
/*   Expects:                                                                */
/*     reg1: literal value                                                   */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP3_LOAD_LITERAL): {
      CODE_COVERAGE(154); // Hit
      goto LBL_TAIL_PUSH_REG1;
    }

/* ------------------------------------------------------------------------- */
/*                             VM_OP3_LOAD_GLOBAL_3                          */
/*   Expects:                                                                */
/*     reg1: global variable index                                           */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP3_LOAD_GLOBAL_3): {
      CODE_COVERAGE_UNTESTED(155); // Not hit
      goto LBL_OP_LOAD_GLOBAL;
    }

/* ------------------------------------------------------------------------- */
/*                             VM_OP3_BRANCH_2                               */
/*   Expects:                                                                */
/*     reg1: signed offset                                                   */
/*     reg2: condition                                                       */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP3_BRANCH_2): {
      CODE_COVERAGE(156); // Hit
      goto LBL_BRANCH_COMMON;
    }

/* ------------------------------------------------------------------------- */
/*                             VM_OP3_STORE_GLOBAL_3                         */
/*   Expects:                                                                */
/*     reg1: global variable index                                           */
/*     reg2: value to store                                                  */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP3_STORE_GLOBAL_3): {
      CODE_COVERAGE_UNTESTED(157); // Not hit
      goto LBL_OP_STORE_GLOBAL;
    }

/* ------------------------------------------------------------------------- */
/*                             VM_OP3_OBJECT_GET_2                           */
/*   Expects:                                                                */
/*     reg1: property key value                                              */
/*     reg2: object value                                                    */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP3_OBJECT_GET_2): {
      CODE_COVERAGE_UNTESTED(158); // Not hit
      VM_NOT_IMPLEMENTED(vm);
      goto LBL_DO_NEXT_INSTRUCTION;
    }

/* ------------------------------------------------------------------------- */
/*                             VM_OP3_OBJECT_SET_2                          */
/*   Expects:                                                                */
/*     reg1: property key value                                              */
/*     reg2: value                                                           */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP3_OBJECT_SET_2): {
      CODE_COVERAGE_UNTESTED(159); // Not hit
      VM_NOT_IMPLEMENTED(vm);
      goto LBL_DO_NEXT_INSTRUCTION;
    }

  } // End of vm_TeOpcodeEx3 switch
  // All cases should jump to whatever tail they intend. Nothing should get here
  VM_ASSERT_UNREACHABLE(vm);
} // End of LBL_OP_EXTENDED_3

/* ------------------------------------------------------------------------- */
/*                             LBL_BRANCH_COMMON                             */
/*   Expects:                                                                */
/*     reg1: signed 16-bit amount to jump by if the condition is truthy      */
/*     reg2: condition to branch on                                          */
/* ------------------------------------------------------------------------- */
LBL_BRANCH_COMMON: {
  CODE_COVERAGE(160); // Hit
  if (mvm_toBool(vm, reg2)) {
    programCounter = MVM_PROGMEM_P_ADD(programCounter, (int16_t)reg1);
  }
  goto LBL_DO_NEXT_INSTRUCTION;
}

/* ------------------------------------------------------------------------- */
/*                             LBL_JUMP_COMMON                               */
/*   Expects:                                                                */
/*     reg1: signed 16-bit amount to jump by                                 */
/* ------------------------------------------------------------------------- */
LBL_JUMP_COMMON: {
  CODE_COVERAGE(161); // Hit
  programCounter = MVM_PROGMEM_P_ADD(programCounter, (int16_t)reg1);
  goto LBL_DO_NEXT_INSTRUCTION;
}

/* ------------------------------------------------------------------------- */
/*                          LBL_CALL_HOST_COMMON                             */
/*   Expects:                                                                */
/*     reg1: reg1: argument count                                            */
/*     reg2: index in import table                                           */
/*     reg3: flag indicating whether function pointer is pushed or not       */
/* ------------------------------------------------------------------------- */
LBL_CALL_HOST_COMMON: {
  CODE_COVERAGE(162); // Hit
  MVM_PROGMEM_P pBytecode = vm->pBytecode;
  // Save caller state
  PUSH((uint16_t)(pFrameBase - VM_BOTTOM_OF_STACK(vm)));
  PUSH(argCount);
  PUSH((uint16_t)MVM_PROGMEM_P_SUB(programCounter, pBytecode));

  // Set up new frame
  pFrameBase = pStackPointer;
  argCount = reg1 - 1; // Argument count does not include the "this" pointer, since host functions are never methods and we don't have an ABI for communicating `this` pointer values
  programCounter = pBytecode; // "null" (signifies that we're outside the VM)

  VM_ASSERT(vm, reg2 < vm_getResolvedImportCount(vm));
  mvm_TfHostFunction hostFunction = vm_getResolvedImports(vm)[reg2];
  Value result = VM_VALUE_UNDEFINED;
  Value* args = pStackPointer - 2 - reg1; // Note: this skips the `this` pointer
  VM_ASSERT(vm, argCount < 256);
  sanitizeArgs(vm, args, (uint8_t)argCount);

  uint16_t importTableOffset = VM_READ_BC_2_HEADER_FIELD(importTableOffset, pBytecode);

  uint16_t importTableEntry = importTableOffset + reg2 * sizeof (vm_TsImportTableEntry);
  mvm_HostFunctionID hostFunctionID = VM_READ_BC_2_AT(importTableEntry, pBytecode);

  FLUSH_REGISTER_CACHE();
  VM_ASSERT(vm, argCount < 256);
  err = hostFunction(vm, hostFunctionID, &result, args, (uint8_t)argCount);
  if (err != MVM_E_SUCCESS) goto LBL_EXIT;
  CACHE_REGISTERS();

  // Restore caller state
  programCounter = MVM_PROGMEM_P_ADD(pBytecode, POP());
  argCount = POP();
  pFrameBase = VM_BOTTOM_OF_STACK(vm) + POP();

  // Pop arguments (including `this` pointer)
  pStackPointer -= reg1;

  // Pop function pointer
  if (reg3)
    (void)POP();

  PUSH(result);
  goto LBL_DO_NEXT_INSTRUCTION;
} // End of LBL_CALL_HOST_COMMON

/* ------------------------------------------------------------------------- */
/*                             LBL_CALL_COMMON                               */
/*   Expects:                                                                */
/*     reg1: number of arguments                                             */
/*     reg2: offset of target function in bytecode                           */
/* ------------------------------------------------------------------------- */
LBL_CALL_COMMON: {
  CODE_COVERAGE(163); // Hit
  MVM_PROGMEM_P pBytecode = vm->pBytecode;
  uint16_t programCounterToReturnTo = (uint16_t)MVM_PROGMEM_P_SUB(programCounter, pBytecode);
  programCounter = MVM_PROGMEM_P_ADD(pBytecode, reg2);

  uint8_t maxStackDepth;
  READ_PGM_1(maxStackDepth);
  if (pStackPointer + ((intptr_t)maxStackDepth + VM_FRAME_SAVE_SIZE_WORDS) > VM_TOP_OF_STACK(vm)) {
    err = MVM_E_STACK_OVERFLOW;
    goto LBL_EXIT;
  }

  // Save caller state (VM_FRAME_SAVE_SIZE_WORDS)
  PUSH((uint16_t)(pFrameBase - VM_BOTTOM_OF_STACK(vm)));
  PUSH(argCount);
  PUSH(programCounterToReturnTo);

  // Set up new frame
  pFrameBase = pStackPointer;
  argCount = reg1;

  goto LBL_DO_NEXT_INSTRUCTION;
} // End of LBL_CALL_COMMON

/* ------------------------------------------------------------------------- */
/*                             LBL_NUM_OP_FLOAT64                            */
/*   Expects:                                                                */
/*     reg1: left operand (second pop), or zero for unary ops                */
/*     reg2: right operand (first pop), or single operand for unary ops      */
/*     reg3: vm_TeNumberOp                                                   */
/* ------------------------------------------------------------------------- */
#if MVM_SUPPORT_FLOAT
LBL_NUM_OP_FLOAT64: {
  CODE_COVERAGE_UNIMPLEMENTED(447); // Hit

  // It's a little less efficient to convert 2 operands even for unary
  // operators, but this path is slow anyway and it saves on code space if we
  // don't check.
  MVM_FLOAT64 reg1F = mvm_toFloat64(vm, reg1);
  MVM_FLOAT64 reg2F = mvm_toFloat64(vm, reg2);

  VM_ASSERT(vm, reg3 < VM_NUM_OP_END);
  MVM_SWITCH_CONTIGUOUS (reg3, (VM_NUM_OP_END - 1)) {
    MVM_CASE_CONTIGUOUS(VM_NUM_OP_LESS_THAN): {
      CODE_COVERAGE(449); // Hit
      reg1 = reg1F < reg2F;
      goto LBL_TAIL_PUSH_REG1_BOOL;
    }
    MVM_CASE_CONTIGUOUS(VM_NUM_OP_GREATER_THAN): {
      CODE_COVERAGE(450); // Hit
      reg1 = reg1F > reg2F;
      goto LBL_TAIL_PUSH_REG1_BOOL;
    }
    MVM_CASE_CONTIGUOUS(VM_NUM_OP_LESS_EQUAL): {
      CODE_COVERAGE(451); // Hit
      reg1 = reg1F <= reg2F;
      goto LBL_TAIL_PUSH_REG1_BOOL;
    }
    MVM_CASE_CONTIGUOUS(VM_NUM_OP_GREATER_EQUAL): {
      CODE_COVERAGE(452); // Hit
      reg1 = reg1F >= reg2F;
      goto LBL_TAIL_PUSH_REG1_BOOL;
    }
    MVM_CASE_CONTIGUOUS(VM_NUM_OP_ADD_NUM): {
      CODE_COVERAGE(453); // Hit
      reg1F = reg1F + reg2F;
      break;
    }
    MVM_CASE_CONTIGUOUS(VM_NUM_OP_SUBTRACT): {
      CODE_COVERAGE(454); // Hit
      reg1F = reg1F - reg2F;
      break;
    }
    MVM_CASE_CONTIGUOUS(VM_NUM_OP_MULTIPLY): {
      CODE_COVERAGE(455); // Hit
      reg1F = reg1F * reg2F;
      break;
    }
    MVM_CASE_CONTIGUOUS(VM_NUM_OP_DIVIDE): {
      CODE_COVERAGE(456); // Hit
      reg1F = reg1F / reg2F;
      break;
    }
    MVM_CASE_CONTIGUOUS(VM_NUM_OP_DIVIDE_AND_TRUNC): {
      CODE_COVERAGE(457); // Hit
      reg1F = mvm_float64ToInt32((reg1F / reg2F));
      break;
    }
    MVM_CASE_CONTIGUOUS(VM_NUM_OP_REMAINDER): {
      CODE_COVERAGE(458); // Hit
      reg1F = fmod(reg1F, reg2F);
      break;
    }
    MVM_CASE_CONTIGUOUS(VM_NUM_OP_POWER): {
      CODE_COVERAGE(459); // Hit
      if (!isfinite(reg2F) && ((reg1F == 1.0) || (reg1F == -1.0))) {
        reg1 = VM_VALUE_NAN;
        goto LBL_TAIL_PUSH_REG1;
      }
      reg1F = pow(reg1F, reg2F);
      break;
    }
    MVM_CASE_CONTIGUOUS(VM_NUM_OP_NEGATE): {
      CODE_COVERAGE(460); // Hit
      reg1F = -reg2F;
      break;
    }
    MVM_CASE_CONTIGUOUS(VM_NUM_OP_UNARY_PLUS): {
      CODE_COVERAGE(461); // Hit
      reg1F = reg2F;
      break;
    }
  } // End of switch vm_TeNumberOp for float64

  // Convert the result from a float
  reg1 = mvm_newNumber(vm, reg1F);
  goto LBL_TAIL_PUSH_REG1;
} // End of LBL_NUM_OP_FLOAT64
#endif // MVM_SUPPORT_FLOAT

LBL_TAIL_PUSH_REG1_BOOL:
  CODE_COVERAGE(489); // Hit
  reg1 = reg1 ? VM_VALUE_TRUE : VM_VALUE_FALSE;
  goto LBL_TAIL_PUSH_REG1;

LBL_TAIL_PUSH_REG1:
  CODE_COVERAGE(164); // Hit
  PUSH(reg1);
  goto LBL_DO_NEXT_INSTRUCTION;

LBL_EXIT:
  CODE_COVERAGE(165); // Hit
  FLUSH_REGISTER_CACHE();
  return err;
} // End of vm_run


void mvm_free(VM* vm) {
  CODE_COVERAGE_UNTESTED(166); // Not hit
  gc_freeGCMemory(vm);
  VM_EXEC_SAFE_MODE(memset(vm, 0, sizeof(*vm)));
  free(vm);
}

/**
 * @param sizeBytes Size in bytes of the allocation, *excluding* the header
 * @param typeCode The type code to insert into the header
 * @param out_result Output VM-Pointer. Target is after allocation header.
 * @param out_target Output native pointer to region after the allocation header.
 */
static Value gc_allocateWithHeader(VM* vm, uint16_t sizeBytes, TeTypeCode typeCode, void** out_pTarget) {
  /*
  Note: The allocation has a 2-byte header, which has the size (excluding
  header) and 4-bit type field.
  */
  CODE_COVERAGE(5); // Hit
  uint16_t allocationSize;
RETRY:
  allocationSize = sizeBytes + 2; // 2 byte header
  // Round up to 2-byte boundary
  allocationSize = (allocationSize + 1) & 0xFFFE;
  // Minimum allocation size is 4 bytes
  if (allocationSize < 4) allocationSize = 4;
  // Note: this is still valid when the bucket is null
  Pointer vpAlloc = vm->vpAllocationCursor;
  void* pAlloc = vm->pAllocationCursor;
  Pointer endOfResult = vpAlloc + allocationSize;
  // Out of space?
  if (endOfResult > vm->vpBucketEnd) {
    CODE_COVERAGE(167); // Hit
    // Allocate a new bucket
    uint16_t bucketSize = VM_ALLOCATION_BUCKET_SIZE;
    if (allocationSize > bucketSize) {
      CODE_COVERAGE_UNTESTED(168); // Not hit
      bucketSize = allocationSize;
    }
    gc_createNextBucket(vm, bucketSize);
    // This must succeed the next time because we've just allocated a bucket at least as big as it needs to be
    goto RETRY;
  }
  vm->vpAllocationCursor = endOfResult;
  vm->pAllocationCursor += allocationSize;

  // Write header
  VM_ASSERT(vm, (sizeBytes & ~0xFFF) == 0);
  VM_ASSERT(vm, (typeCode & ~0xF) == 0);
  vm_HeaderWord headerWord = (typeCode << 12) | sizeBytes;
  *((vm_HeaderWord*)pAlloc) = headerWord;

  *out_pTarget = (uint8_t*)pAlloc + 2; // Skip header
  return vpAlloc + 2;
}

/**
 * Allocate raw GC data.
 */
static Pointer gc_allocateWithoutHeader(VM* vm, uint16_t sizeBytes, void** out_pTarget) {
  CODE_COVERAGE(6); // Hit
  // For the sake of flash size, I'm just implementing this in terms of the one
  // that allocates with a header, which is going to be the more commonly used
  // function anyway.
  void* p;
  Pointer vp = gc_allocateWithHeader(vm, sizeBytes - 2, (TeTypeCode)0, &p);
  *out_pTarget = (uint16_t*)p - 1;
  return vp - 2;
}

static void gc_createNextBucket(VM* vm, uint16_t bucketSize) {
  CODE_COVERAGE(7); // Hit
  size_t allocSize = sizeof (vm_TsBucket) + bucketSize;
  vm_TsBucket* bucket = malloc(allocSize);
  if (!bucket) {
    MVM_FATAL_ERROR(vm, MVM_E_MALLOC_FAIL);
  }
  #if MVM_SAFE_MODE
    memset(bucket, 0x7E, allocSize);
  #endif
  bucket->prev = vm->pLastBucket;
  if (bucket->prev)
    CODE_COVERAGE(501); // Hit
  else
    CODE_COVERAGE(502); // Hit
  // Note: we start the next bucket at the allocation cursor, not at what we
  // previously called the end of the previous bucket
  bucket->vpAddressStart = vm->vpAllocationCursor;
  vm->pAllocationCursor = (uint8_t*)(bucket + 1); // Start allocating after bucket header
  vm->vpBucketEnd = vm->vpAllocationCursor + bucketSize;
  vm->pLastBucket = bucket;
}

static void gc_markAllocation(vm_TsGCCollectionState* gc, Pointer p, uint16_t size) {
  CODE_COVERAGE(8); // Hit
  if (VM_TAG_OF(p) != VM_TAG_GC_P) return;

  VM_ASSERT(gc->vm, !gc_isMarked(gc->pMarkTable, p));
  gc->requiredHeapSize += size;

  GO_t allocationOffsetBytes = VM_VALUE_OF(p);

  // Note: I'm using 0x80 as the "0th" bit because it appears on the left-hand-side in a debugger.

  // Start bit
  uint16_t markBitIndex = allocationOffsetBytes / 2; // Every 2 bytes of allocation space is another mark bit
  uint16_t markTableIndex = markBitIndex / 8; // Identify which byte to mark
  uint8_t bitOffsetInMarkByte = markBitIndex & 7; // Identify which bit in the byte to mark
  gc->pMarkTable[markTableIndex] |= 0x80 >> bitOffsetInMarkByte;

  // End bit
  /*
   * Note: it's valid for an allocation to have an odd size. A 3-byte allocation
   * is treated the same as a 4-byte allocation, since it would be allocated with
   * a 1-byte padding.
   */
  VM_ASSERT(vm, size >= 3);
  if (size % 2 == 0)
    CODE_COVERAGE(496); // Hit
  if (size % 2 == 1)
    CODE_COVERAGE_UNTESTED(497); // Not hit
  markBitIndex += (size - 1) / 2;
  markTableIndex = markBitIndex / 8;
  bitOffsetInMarkByte = markBitIndex & 7;
  gc->pMarkTable[markTableIndex] |= 0x80 >> bitOffsetInMarkByte;
}

static inline bool gc_isMarked(uint8_t* pMarkTable, Pointer ptr) {
  CODE_COVERAGE(9); // Hit
  VM_ASSERT(vm, VM_IS_GC_P(ptr));
  GO_t allocationOffsetBytes = VM_VALUE_OF(ptr);
  uint16_t markBitIndex = allocationOffsetBytes / 2;
  uint16_t markTableIndex = markBitIndex / 8;
  uint8_t bitOffsetInMarkByte = markBitIndex & 7;
  return pMarkTable[markTableIndex] & (0x80 >> bitOffsetInMarkByte);
}

static void gc_freeGCMemory(VM* vm) {
  CODE_COVERAGE(10); // Hit
  while (vm->pLastBucket) {
    CODE_COVERAGE_UNTESTED(169); // Not hit
    vm_TsBucket* prev = vm->pLastBucket->prev;
    free(vm->pLastBucket);
    vm->pLastBucket = prev;
  }
  vm->vpBucketEnd = vpGCSpaceStart;
  vm->vpAllocationCursor = vpGCSpaceStart;
  vm->pAllocationCursor = NULL;
}

// This function pushes the pointer into the trace stack, if the value is a GC
// pointer and if the target hasn't been marked. This function does not mark the
// target, because marking requires taking a look at the object, which is
// something best done at the same time we iterate the fields of the object.
static void gc_traceValue(vm_TsGCCollectionState* gc, Value value) {
  uint16_t tag = value & VM_TAG_MASK;
  // We only trace pointers to GC memory. Objects in data memory are not collectable,
  // and pointers *from* data memory are already recorded as GC roots.
  if (tag != VM_TAG_GC_P) {
    CODE_COVERAGE(170); // Hit
    return;
  }

  Pointer pAllocation = value;

  // If the allocation is already marked, then we're done
  if (gc_isMarked(gc->pMarkTable, pAllocation)) {
    CODE_COVERAGE_UNTESTED(172); // Not hit
    return;
  }

  // We want to push the item into the trace-stack to be traced later, but if
  // we're out of space in the current stack, then we create a new on and trace
  // on that one.
  if (gc->pTraceStackItem == gc->pTraceStackEnd) {
    CODE_COVERAGE(201); // Hit
    gc_traceValueOnNewTraceStack(gc, value);
  } else {
    CODE_COVERAGE(407); // Hit
    *gc->pTraceStackItem++ = value;
  }
}

// This is called by gc_traceValue as a fallback when we run out of trace stack
// and need extend it before tracing further
static void gc_traceValueOnNewTraceStack(vm_TsGCCollectionState* gc, Value value) {
  CODE_COVERAGE(11); // Hit

  // We only expect this function to be called when we're out of space in the
  // previous trace stack. Also, when this function restores the original value
  // of pTraceStackItem at the end of this function, it assumes that it had the
  // value of oldTraceStackEnd.
  VM_ASSERT(gc->vm, gc->pTraceStackItem == gc->pTraceStackEnd);

  // The tracing uses a depth-first search, which requires a stack. The stack
  // and current index in the stack are shared among the GC functions
  uint16_t traceStack[GC_TRACE_STACK_COUNT];
  traceStack[0] = value; // The first item in the stack
  uint16_t* oldTraceStackEnd = gc->pTraceStackEnd; // This will be restored at the end of gc_traceValueOnNewTraceStack
  TABLE_COVERAGE(oldTraceStackEnd ? 1 : 0, 2, 490); // Hit 1/2
  gc->pTraceStackItem = &traceStack[1]; // The next item in the stack
  gc->pTraceStackEnd = &traceStack[GC_TRACE_STACK_COUNT];

  /*
  # Pointers in Program Memory

  Program memory can contain pointers. For example, it's valid for bytecode to
  have a VM_OP3_LOAD_LITERAL instruction with a pointer literal parameter.
  However, pointers to GC memory must themselves be mutable, since GC memory can
  move during compaction. Thus, pointers in program memory can only ever
  reference data memory or other allocations in program memory. Pointers in data
  memory, as with everything in data memory, are in fixed locations. These are
  treated as GC roots and do not need to be referenced by values in program
  memory (see below).

  # Pointers in Data Memory

  Data memory is broadly divided into two sections:

   1. Global variables
   2. Heap allocations

  All global variables are treated as GC roots.

  The heap allocations in data memory are permanent and fixed in size and
  structure, unlike allocations in the GC heap. Members of these allocations
  that can be pointers must be recorded in the gcRoots table so that the GC can
  find them.
  */

  // While there are items on the stack to be processed
  while (gc->pTraceStackItem != traceStack) {
    uint8_t itemIndex = gc->pTraceStackItem - traceStack;
    TABLE_COVERAGE(itemIndex - 1 ? 1 : 0, 2, 491); // Hit 2/2
    // Pop item off stack
    uint16_t pAllocation = *(--(gc->pTraceStackItem));

    vm_HeaderWord headerWord = vm_readHeaderWord(gc->vm, pAllocation);
    TeTypeCode typeCode = vm_getTypeCodeFromHeaderWord(headerWord);
    uint16_t allocationSize = vm_getAllocationSizeExcludingHeaderFromHeaderWord(headerWord);

    // Adjust for header
    allocationSize += 2;
    pAllocation -= 2;

    // Structs have an additional 2-bytes in their header
    if (typeCode == TC_REF_STRUCT) {
      CODE_COVERAGE_UNTESTED(174); // Not hit
      allocationSize += 2;
      pAllocation -= 2;
    } else {
      CODE_COVERAGE(492); // Hit
    }

    // Functions are only stored in ROM, so they should never be hit for
    // collection (see note at the beginning of this function)
    VM_ASSERT(vm, typeCode != TC_REF_FUNCTION);

    // Need to mark parent before recursing on children
    gc_markAllocation(gc, pAllocation, allocationSize);

    if (typeCode == TC_REF_ARRAY) {
      CODE_COVERAGE(178); // Hit
      Pointer dataP = vm_readUInt16(gc->vm, pAllocation + 2);
      if (dataP) {
        CODE_COVERAGE(493); // Hit
        uint16_t itemCount = vm_readUInt16(gc->vm, pAllocation + 4);

        gc_markAllocation(gc, dataP, itemCount * 2);
        uint16_t* pItem = gc_deref(gc->vm, dataP);
        while (itemCount--) {
          CODE_COVERAGE(179); // Hit
          Value item = *pItem++;
          gc_traceValue(gc, item);
        }
      } else {
        CODE_COVERAGE(494); // Hit
      }
    } else if (typeCode == TC_REF_STRUCT) {
      CODE_COVERAGE_UNIMPLEMENTED(177); // Not hit
    } else if (typeCode == TC_REF_PROPERTY_LIST) {
      CODE_COVERAGE(175); // Hit
      Pointer pCell = vm_readUInt16(gc->vm, pAllocation + 2);
      while (pCell) {
        gc_markAllocation(gc, pCell, 6);
        Pointer next = vm_readUInt16(gc->vm, pCell + 0);
        Value key = vm_readUInt16(gc->vm, pCell + 2);
        Value value = vm_readUInt16(gc->vm, pCell + 4);

        gc_traceValue(gc, key);
        gc_traceValue(gc, value);

        pCell = next;
      }
    }
  } // End of while

  // Restore original trace-stack (since the function we're in could be invoked from an earlier overlow)
  gc->pTraceStackEnd = oldTraceStackEnd;
  gc->pTraceStackItem = oldTraceStackEnd;
}

static bool gc_pointersInObjectAreUpdated(vm_TsGCCollectionState* gc, Pointer ptr) {
  CODE_COVERAGE(512); // Hit
  VM_ASSERT(vm, VM_IS_GC_P(ptr));

  GO_t allocationOffsetBytes = VM_VALUE_OF(ptr);
  uint16_t bitIndex = allocationOffsetBytes / 2;
  uint16_t tableIndex = bitIndex / 8;
  uint8_t bitOffsetInEntry = bitIndex & 7;
  return gc->pPointersUpdatedTable[tableIndex] & (0x80 >> bitOffsetInEntry);
}

static void gc_setPointersInObjectAreUpdated(vm_TsGCCollectionState* gc, Pointer ptr) {
  CODE_COVERAGE(513); // Hit
  VM_ASSERT(vm, VM_IS_GC_P(ptr));

  GO_t allocationOffsetBytes = VM_VALUE_OF(ptr);
  uint16_t bitIndex = allocationOffsetBytes / 2;
  uint16_t tableIndex = bitIndex / 8;
  uint8_t bitOffsetInEntry = bitIndex & 7;
  gc->pPointersUpdatedTable[tableIndex] |= (0x80 >> bitOffsetInEntry);
}

// Must be called with an *un-updated* pointer. It will update it, and then traverse
static void gc_updatePointerRecursive(vm_TsGCCollectionState* gc, Value* pValue) {
  CODE_COVERAGE(514); // Hit
  Value ptr = *pValue;

  if (!VM_IS_GC_P(ptr)) {
    CODE_COVERAGE(181); // Hit
    return;
  }

  gc_updatePointer(gc, pValue);
  ptr = *pValue;
  void* p = gc_deref(gc->vm, ptr);

  if (gc_pointersInObjectAreUpdated(gc, ptr)) {
    CODE_COVERAGE_UNTESTED(515); // Not hit
    return;
  }
  gc_setPointersInObjectAreUpdated(gc, ptr);

  vm_HeaderWord headerWord = vm_readHeaderWord(gc->vm, ptr);
  TeTypeCode typeCode = vm_getTypeCodeFromHeaderWord(headerWord);

  VM_ASSERT(vm, typeCode != TC_REF_FUNCTION);

  if (typeCode == TC_REF_ARRAY) {
    CODE_COVERAGE(506); // Hit
    gc_updatePointer(gc, p);
    Pointer dataP = *(Pointer*)p;
    if (dataP) {
      CODE_COVERAGE(507); // Hit
      uint16_t itemCount = vm_readUInt16(gc->vm, ptr + 2);

      uint16_t* pItem = gc_deref(gc->vm, dataP);
      while (itemCount--) {
        CODE_COVERAGE(508); // Hit
        gc_updatePointerRecursive(gc, pItem);
        pItem++;
      }
    } else {
      CODE_COVERAGE(509); // Hit
    }
  } else if (typeCode == TC_REF_STRUCT) {
    CODE_COVERAGE_UNIMPLEMENTED(510); // Not hit
  } else if (typeCode == TC_REF_PROPERTY_LIST) {
    CODE_COVERAGE(511); // Hit
    gc_updatePointer(gc, p);
    Pointer pCell = *(Pointer*)p;
    while (pCell) {
      TsPropertyCell* cell = gc_deref(gc->vm, pCell);

      gc_updatePointerRecursive(gc, &cell->key);
      gc_updatePointerRecursive(gc, &cell->value);

      pCell = cell->next;
    }
  }
}

static void gc_updatePointer(vm_TsGCCollectionState* gc, Pointer* pPtr) {
  CODE_COVERAGE(12); // Hit
  Pointer ptr = *pPtr;

  if (!VM_IS_GC_P(ptr)) {
    CODE_COVERAGE(516); // Hit
    return;
  }

  VM_ASSERT(vm, VM_IS_GC_P(ptr));

  GO_t allocationOffsetBytes = ptr & VM_VALUE_MASK;
  uint16_t markBitIndex = allocationOffsetBytes / VM_GC_ALLOCATION_UNIT;
  uint16_t markTableIndex = markBitIndex / 8;
  uint8_t bitOffsetInMarkByte = markBitIndex & 7;

  uint16_t adjustmentTableIndex = markTableIndex; // The two tables have corresponding entries
  uint16_t adjustment = gc->pAdjustmentTable[adjustmentTableIndex];
  TABLE_COVERAGE(adjustment ? 1 : 0, 2, 498); // Hit 2/2
  uint16_t markBits = gc->pMarkTable[markTableIndex];
  uint8_t mask = 0x80;
  // The adjustment table is coarse, since there is only one adjustment word for
  // every 8 allocated words. Unless the pointer exactly aligns to this 8-word
  // boundary, we need to tweak the adjustment word by looking at the mark bits.
  #if GC_USE_ADJUSTMENT_LOOKUP
    markBits = markBits | (0xFF >> bitOffsetInMarkByte);
    // Need to look up twice because the lookup is only big enough to index by nibble
    adjustment += adjustmentLookup[adjustment & 1][markBits >> 4];
    adjustment += adjustmentLookup[adjustment & 1][markBits & 0xF];
    adjustment &= 0xFFFE;
  #else // !GC_USE_ADJUSTMENT_LOOKUP
    bool inAllocation = adjustment & 0x0001;
    adjustment = adjustment & 0xFFFE;
    TABLE_COVERAGE(inAllocation, 2, 183); // Not hit
    while (bitOffsetInMarkByte--) {
      CODE_COVERAGE_UNTESTED(182); // Not hit
      // If the word is marked
      if (markBits & mask) {
        CODE_COVERAGE_UNTESTED(195); // Not hit
        if (inAllocation) {
          CODE_COVERAGE_UNTESTED(196); // Not hit
          inAllocation = false;
        } else {
          CODE_COVERAGE_UNTESTED(199); // Not hit
          inAllocation = true;
        }
      } else {
        CODE_COVERAGE_UNTESTED(198); // Not hit
        if (inAllocation) {
          CODE_COVERAGE_UNTESTED(197); // Not hit
        } else {
          CODE_COVERAGE_UNTESTED(200); // Not hit
          adjustment += VM_GC_ALLOCATION_UNIT;
        }
      }
      mask >>= 1;
    }
  #endif // GC_USE_ADJUSTMENT_LOOKUP

  *pPtr -= adjustment;
}

// Run a garbage collection cycle
void mvm_runGC(VM* vm) {
  // TODO: Array compaction?
  CODE_COVERAGE(13); // Hit
  if (!vm->pLastBucket) {
    CODE_COVERAGE_UNTESTED(189); // Not hit
    return; // Nothing allocated
  }

  uint16_t allocatedSize = vm->vpAllocationCursor - vpGCSpaceStart;

  // The mark table has 1 mark bit for each allocated word in GC space
  uint16_t markTableCount = (allocatedSize + 15) / 16;
  uint16_t markTableSize = markTableCount * sizeof (uint8_t); // Each mark table entry is 1 byte
  TABLE_COVERAGE(markTableSize > 2 ? 1 : 0, 2, 253); // Hit 2/2

  // The adjustment table has one 16-bit adjustment word for every 8 mark bits.
  // It says how much a pointer at that position should be adjusted by during
  // compaction. The +1 is because there is a path where the calculation of the
  // adjustment table generates an extra word.
  uint16_t adjustmentTableCount = markTableCount + 1;
  uint16_t adjustmentTableSize = adjustmentTableCount * sizeof (uint16_t);

  // The pointersUpdated table marks whether the pointers in a given object have
  // been updated, given that object's location in to-space.
  uint16_t pointersUpdatedTableCount = markTableCount;
  uint16_t pointersUpdatedTableSize = pointersUpdatedTableCount * sizeof (uint8_t);

  // We allocate everything at the same time for efficiency. The allocation
  // size here is 1/8th the size of the heap memory allocated. So a
  // 2 kB heap requires a 256 B allocation here.
  void* temp = malloc(sizeof(vm_TsGCCollectionState) + adjustmentTableSize + markTableSize + pointersUpdatedTableSize);
  if (!temp) {
    MVM_FATAL_ERROR(vm, MVM_E_MALLOC_FAIL);
  }
  vm_TsGCCollectionState* gc = (vm_TsGCCollectionState*)temp;
  uint16_t* pAdjustmentTable = (uint16_t*)(gc + 1); // Adjustment table is first because it needs to be 2-byte aligned
  uint8_t* pMarkTable = (uint8_t*)(pAdjustmentTable + adjustmentTableCount);
  uint8_t* pMarkTableBytesEnd = pMarkTable + markTableCount;
  uint8_t* pPointersUpdatedTable = pMarkTableBytesEnd;

  gc->vm = vm;
  gc->requiredHeapSize = 0;
  gc->pMarkTable = pMarkTable;
  gc->pAdjustmentTable = pAdjustmentTable;
  gc->pPointersUpdatedTable = pPointersUpdatedTable;
  gc->pTraceStackItem = NULL;
  gc->pTraceStackEnd = NULL;

  VM_ASSERT(vm, ((intptr_t)pAdjustmentTable & 1) == 0); // Needs to be 16-bit aligned for the following algorithm to work

  // Clear all the mark bits
  memset(pMarkTable, 0, markTableSize);

  // Clear all the pointer-updated bits
  memset(pPointersUpdatedTable, 0, pointersUpdatedTableSize);

  // The adjustment table will be computed later, but if we're running in safe
  // mode then let's clear it to some value that will be mostly likely to expose
  // issues (in a consistent way).
  VM_EXEC_SAFE_MODE(memset(pAdjustmentTable, 0xCD, adjustmentTableSize));

  // -- Mark Phase--

  // Mark roots in global variables
  {
    uint16_t globalVariableCount = VM_READ_BC_2_HEADER_FIELD(globalVariableCount, vm->pBytecode);

    uint16_t* pGlobalVariable = vm->dataMemory;
    while (globalVariableCount--) {
      CODE_COVERAGE(190); // Hit
      gc_traceValue(gc, *pGlobalVariable++);
    }
  }

  // Mark other roots in data memory
  {
    uint16_t gcRootsOffset = VM_READ_BC_2_HEADER_FIELD(gcRootsOffset, vm->pBytecode);
    uint16_t gcRootsCount = VM_READ_BC_2_HEADER_FIELD(gcRootsCount, vm->pBytecode);

    MVM_PROGMEM_P pTableEntry = MVM_PROGMEM_P_ADD(vm->pBytecode, gcRootsOffset);
    while (gcRootsCount--) {
      CODE_COVERAGE_UNTESTED(191); // Not hit
      // The table entry in program memory gives us an offset in data memory
      uint16_t dataOffsetWords = MVM_READ_PROGMEM_2(pTableEntry);
      uint16_t dataValue = vm->dataMemory[dataOffsetWords];
      gc_traceValue(gc, dataValue);
      pTableEntry = MVM_PROGMEM_P_ADD(pTableEntry, 2);
    }
  }

  // Array prototype
  gc_traceValue(gc, vm->arrayProto);

  if (gc->requiredHeapSize == 0) {
    CODE_COVERAGE_UNTESTED(192); // Not hit
    // Everything is freed
    gc_freeGCMemory(vm);
    goto LBL_EXIT;
  }

  // Decide whether to continue with the collection or not, based on the space it will save
  if (!(MVM_PORT_GC_ALLOW_COMPACTION(((uint32_t)allocatedSize), ((uint32_t)gc->requiredHeapSize)))) {
    CODE_COVERAGE(193); // Hit
    goto LBL_EXIT;
  }

  // Create adjustment table
  {
    /*
    Note: the LSb of each entry in the adjustment table indicates if the
    corresponding address is inside an allocation. The adjustmentLookup table
    has deltas to this bit pre-baked.
    */
    uint8_t* pMarkTableEntry = &pMarkTable[0];
    pAdjustmentTable[0] = 0; // There is no adjustment required at the beginning of the heap
    uint16_t* pAdjustmentTableEntry = &pAdjustmentTable[1];
    uint16_t adjustment = 0;
    #if GC_USE_ADJUSTMENT_LOOKUP
      while (pMarkTableEntry < pMarkTableBytesEnd) {
        uint8_t markBits = *pMarkTableEntry++;
        // Need to look up twice because the table is only big enough to index by nibble
        adjustment += adjustmentLookup[adjustment & 1][markBits >> 4];
        adjustment += adjustmentLookup[adjustment & 1][markBits & 0xF];
        *pAdjustmentTableEntry++ = adjustment;
      }
    #else // !GC_USE_ADJUSTMENT_LOOKUP
      uint8_t mask = 0x80;
      bool inAllocation = false;
      while (pMarkTableEntry < pMarkTableBytesEnd) {
        CODE_COVERAGE_UNTESTED(194); // Not hit

        // If the word is marked
        if ((*pMarkTableEntry) & mask) {
          CODE_COVERAGE_UNTESTED(184); // Not hit
          if (inAllocation) {
            CODE_COVERAGE_UNTESTED(185); // Not hit
            inAllocation = false;
          } else {
            CODE_COVERAGE_UNTESTED(186); // Not hit
            inAllocation = true;
          }
        } else {
          CODE_COVERAGE_UNTESTED(187); // Not hit
          if (inAllocation) {
            CODE_COVERAGE_UNTESTED(188); // Not hit
          } else {
            CODE_COVERAGE_UNTESTED(495); // Not hit
            adjustment += VM_GC_ALLOCATION_UNIT;
          }
        }

        mask >>= 1;
        // Overflow?
        if (!mask) {
          CODE_COVERAGE_UNTESTED(171); // Not hit
          mask = 0x80; // Reset the mask to the first bit
          pMarkTableEntry++; // Move to the next entry in the mark table
          *pAdjustmentTableEntry++ = adjustment | (inAllocation ? 1 : 0);
        }
        else {
          CODE_COVERAGE_UNTESTED(202); // Not hit
        }
      }
    #endif // GC_USE_ADJUSTMENT_LOOKUP
  }

  // Compact phase

  // Temporarily reverse the linked list to make it easier to parse forwards
  // during compaction. Also, we'll repurpose the vpAddressStart field to hold
  // the size.
  vm_TsBucket* firstBucket;
  {
    CODE_COVERAGE(204); // Hit
    vm_TsBucket* bucket = vm->pLastBucket;
    Pointer vpEndOfBucket = vm->vpAllocationCursor; // Using the allocation cursor as the end of the last bucket, because the rest of the space us unused
    vm_TsBucket* next = NULL; // The bucket that comes after the current bucket in the *reversed* list
    while (bucket) {
      CODE_COVERAGE(205); // Hit
      uint16_t size = vpEndOfBucket - bucket->vpAddressStart;
      vpEndOfBucket = bucket->vpAddressStart;
      bucket->vpAddressStart/*size*/ = size;
      vm_TsBucket* prev = bucket->prev; // The bucket that comes before the current bucket in the *un-reversed* list
      bucket->prev/*next*/ = next;
      next = bucket;
      bucket = prev;
      if (bucket)
        CODE_COVERAGE(499); // Hit
      else
        CODE_COVERAGE(500); // Hit
    }
    firstBucket = next;
  }

  /*
  This is a semispace collector. It allocates a completely new region and does a
  full copy of all the memory from the old region into the new.
  */
  vm->vpAllocationCursor = vpGCSpaceStart;
  vm->vpBucketEnd = vpGCSpaceStart;
  vm->pLastBucket = NULL;
  gc_createNextBucket(vm, gc->requiredHeapSize);

  {
    VM_ASSERT(vm, vm->pLastBucket && !vm->pLastBucket->prev); // Only one bucket (the new one)
    uint16_t* source = (uint16_t*)(firstBucket + 1); // Start just after the header
    uint16_t* sourceBucketEnd = (uint16_t*)((uint8_t*)source + firstBucket->vpAddressStart/*size*/);
    uint16_t* target = (uint16_t*)(vm->pAllocationCursor);
    if (!target) {
      CODE_COVERAGE_ERROR_PATH(206); // Not hit
      VM_UNEXPECTED_INTERNAL_ERROR(vm);
      return;
    } else {
      CODE_COVERAGE(207); // Hit
    }
    uint8_t* pMarkTableEntry = pMarkTable;
    uint8_t mask = 0x80;
    uint8_t markBits = *pMarkTableEntry++;
    bool copying = false;
    vm_TsBucket* bucket = firstBucket;
    uint16_t sourceAddr = vpGCSpaceStart;
    uint16_t targetAddr = vpGCSpaceStart;
    while (bucket) {
      CODE_COVERAGE(208); // Hit
      bool gc_isMarked = markBits & mask;

      if (copying || gc_isMarked) {
        CODE_COVERAGE(209); // Hit
        *target++ = *source;
        targetAddr += 2;
      }

      if (gc_isMarked) {
        copying = !copying;
      }

      source++;
      sourceAddr += 2;

      // Go to next bucket?
      if (source >= sourceBucketEnd) {
        CODE_COVERAGE(213); // Hit
        VM_ASSERT(vm, source == sourceBucketEnd);
        vm_TsBucket* next = bucket->prev/*next*/;
        free(bucket);
        if (!next) {
          CODE_COVERAGE(214); // Hit
          break; // Done with compaction
        } else {
          CODE_COVERAGE(215); // Hit
        }
        bucket = next;
        source = (uint16_t*)(bucket + 1); // Start after the header
        uint16_t size = bucket->vpAddressStart/*size*/;
        sourceBucketEnd = (uint16_t*)((uint8_t*)source + size);
      }

      mask >>= 1;
      if (!mask) {
        CODE_COVERAGE(216); // Hit
        mask = 0x80;
        markBits = *pMarkTableEntry++;
      } else {
        CODE_COVERAGE(217); // Hit
      }
    }
    VM_ASSERT(vm, sourceAddr == vpGCSpaceStart + allocatedSize);
    VM_ASSERT(vm, targetAddr == vpGCSpaceStart + gc->requiredHeapSize);

    vm->vpAllocationCursor = vpGCSpaceStart + gc->requiredHeapSize;
  }

  // Pointer update: global variables
  {
    uint16_t* p = vm->dataMemory;
    uint16_t globalVariableCount = VM_READ_BC_2_HEADER_FIELD(globalVariableCount, vm->pBytecode);

    while (globalVariableCount--) {
      CODE_COVERAGE(203); // Hit
      gc_updatePointerRecursive(gc, p++);
    }
  }

  // Pointer udpate: GC roots
  {
    uint16_t gcRootsOffset = VM_READ_BC_2_HEADER_FIELD(gcRootsOffset, vm->pBytecode);
    uint16_t gcRootsCount = VM_READ_BC_2_HEADER_FIELD(gcRootsCount, vm->pBytecode);

    MVM_PROGMEM_P pTableEntry = MVM_PROGMEM_P_ADD(vm->pBytecode, gcRootsOffset);
    while (gcRootsCount--) {
      CODE_COVERAGE_UNTESTED(505); // Not hit
      // The table entry in program memory gives us an offset in data memory
      uint16_t dataOffsetWords = MVM_READ_PROGMEM_2(pTableEntry);
      uint16_t* dataValue = &vm->dataMemory[dataOffsetWords];
      gc_updatePointerRecursive(gc, dataValue);
      pTableEntry = MVM_PROGMEM_P_ADD(pTableEntry, 2);
    }
  }

  // Pointer update: arrayProtoPointer
  gc_updatePointerRecursive(gc, &vm->arrayProto);

LBL_EXIT:
  CODE_COVERAGE(218); // Hit
  free(temp);
}

static void* gc_deref(VM* vm, Pointer vp) {
  CODE_COVERAGE(14); // Hit

  VM_ASSERT(vm, (vp >= vpGCSpaceStart) && (vp <= vm->vpAllocationCursor));

  // Find the right bucket
  vm_TsBucket* pBucket = vm->pLastBucket;
  VM_SAFE_CHECK_NOT_NULL_2(pBucket);
  while (vp < pBucket->vpAddressStart) {
    CODE_COVERAGE(219); // Hit
    pBucket = pBucket->prev;
    VM_SAFE_CHECK_NOT_NULL_2(pBucket);
  }

  // This would be more efficient if buckets had some kind of "offset" field which took into account all of this
  uint8_t* bucketData = ((uint8_t*)(pBucket + 1));
  uint8_t* p = bucketData + (vp - pBucket->vpAddressStart);
  return p;
}

// A function call invoked by the host
TeError mvm_call(VM* vm, Value func, Value* out_result, Value* args, uint8_t argCount) {
  CODE_COVERAGE(15); // Hit

  TeError err;
  if (out_result) {
    CODE_COVERAGE(220); // Hit
    *out_result = VM_VALUE_UNDEFINED;
  } else {
    CODE_COVERAGE_UNTESTED(221); // Not hit
  }

  vm_setupCallFromExternal(vm, func, args, argCount);

  // Run the machine until it hits the corresponding return instruction. The
  // return instruction pops the arguments off the stack and pushes the returned
  // value.
  err = vm_run(vm);

  if (err != MVM_E_SUCCESS) {
    CODE_COVERAGE_ERROR_PATH(222); // Not hit
    return err;
  } else {
    CODE_COVERAGE(223); // Hit
  }

  if (out_result) {
    CODE_COVERAGE(224); // Hit
    *out_result = vm_pop(vm);
  } else {
    CODE_COVERAGE_UNTESTED(225); // Not hit
  }

  // Release the stack if we hit the bottom
  if (vm->stack->reg.pStackPointer == VM_BOTTOM_OF_STACK(vm)) {
    CODE_COVERAGE(226); // Hit
    free(vm->stack);
    vm->stack = NULL;
  } else {
    CODE_COVERAGE_UNTESTED(227); // Not hit
  }

  return MVM_E_SUCCESS;
}

static TeError vm_setupCallFromExternal(VM* vm, Value func, Value* args, uint8_t argCount) {
  int i;

  if (deepTypeOf(vm, func) != TC_REF_FUNCTION) {
    CODE_COVERAGE_ERROR_PATH(228); // Not hit
    return MVM_E_TARGET_IS_NOT_A_VM_FUNCTION;
  } else {
    CODE_COVERAGE(229); // Hit
  }

  // There is no stack if this is not a reentrant invocation
  if (!vm->stack) {
    CODE_COVERAGE(230); // Hit
    // This is freed again at the end of mvm_call
    vm_TsStack* stack = malloc(sizeof (vm_TsStack) + MVM_STACK_SIZE);
    if (!stack) {
      CODE_COVERAGE_ERROR_PATH(231); // Not hit
      return MVM_E_MALLOC_FAIL;
    }
    memset(stack, 0, sizeof *stack);
    vm_TsRegisters* reg = &stack->reg;
    // The stack grows upward. The bottom is the lowest address.
    uint16_t* bottomOfStack = (uint16_t*)(stack + 1);
    reg->pFrameBase = bottomOfStack;
    reg->pStackPointer = bottomOfStack;
    vm->stack = stack;
  } else {
    CODE_COVERAGE_UNTESTED(232); // Not hit
  }

  vm_TsStack* stack = vm->stack;
  uint16_t* bottomOfStack = (uint16_t*)(stack + 1);
  vm_TsRegisters* reg = &stack->reg;

  VM_ASSERT(vm, reg->programCounter == 0); // Assert that we're outside the VM at the moment

  VM_ASSERT(vm, VM_TAG_OF(func) == VM_TAG_PGM_P);
  BO_t functionOffset = VM_VALUE_OF(func);
  uint8_t maxStackDepth = VM_READ_BC_1_AT(functionOffset, vm->pBytecode);
  // TODO(low): Since we know the max stack depth for the function, we could actually grow the stack dynamically rather than allocate it fixed size.
  if (vm->stack->reg.pStackPointer + ((intptr_t)maxStackDepth + VM_FRAME_SAVE_SIZE_WORDS) > VM_TOP_OF_STACK(vm)) {
    CODE_COVERAGE_ERROR_PATH(233); // Not hit
    return MVM_E_STACK_OVERFLOW;
  }

  vm_push(vm, func); // We need to push the function because the corresponding RETURN instruction will pop it. The actual value is not used.
  vm_push(vm, VM_VALUE_UNDEFINED); // Push `this` pointer of undefined, to match the internal ABI
  Value* arg = &args[0];
  for (i = 0; i < argCount; i++)
    vm_push(vm, *arg++);

  // Save caller state (VM_FRAME_SAVE_SIZE_WORDS)
  vm_push(vm, (uint16_t)(reg->pFrameBase - bottomOfStack));
  vm_push(vm, reg->argCount);
  vm_push(vm, reg->programCounter);

  // Set up new frame
  reg->pFrameBase = reg->pStackPointer;
  reg->argCount = argCount + 1; // +1 for the `this` pointer
  reg->programCounter = functionOffset + sizeof (vm_TsFunctionHeader);

  return MVM_E_SUCCESS;
}

TeError vm_resolveExport(VM* vm, mvm_VMExportID id, Value* result) {
  CODE_COVERAGE(17); // Hit
  MVM_PROGMEM_P pBytecode = vm->pBytecode;
  uint16_t exportTableOffset = VM_READ_BC_2_HEADER_FIELD(exportTableOffset, pBytecode);
  uint16_t exportTableSize = VM_READ_BC_2_HEADER_FIELD(exportTableSize, pBytecode);

  MVM_PROGMEM_P exportTable = MVM_PROGMEM_P_ADD(vm->pBytecode, exportTableOffset);
  MVM_PROGMEM_P exportTableEnd = MVM_PROGMEM_P_ADD(exportTable, exportTableSize);

  // See vm_TsExportTableEntry
  MVM_PROGMEM_P exportTableEntry = exportTable;
  while (exportTableEntry < exportTableEnd) {
    CODE_COVERAGE(234); // Hit
    mvm_VMExportID exportID = MVM_READ_PROGMEM_2(exportTableEntry);
    if (exportID == id) {
      CODE_COVERAGE(235); // Hit
      MVM_PROGMEM_P pExportvalue = MVM_PROGMEM_P_ADD(exportTableEntry, 2);
      mvm_VMExportID exportValue = MVM_READ_PROGMEM_2(pExportvalue);
      *result = exportValue;
      return MVM_E_SUCCESS;
    } else {
      CODE_COVERAGE_UNTESTED(236); // Not hit
    }
    exportTableEntry = MVM_PROGMEM_P_ADD(exportTableEntry, sizeof (vm_TsExportTableEntry));
  }

  *result = VM_VALUE_UNDEFINED;
  return MVM_E_UNRESOLVED_EXPORT;
}

TeError mvm_resolveExports(VM* vm, const mvm_VMExportID* idTable, Value* resultTable, uint8_t count) {
  CODE_COVERAGE(18); // Hit
  TeError err = MVM_E_SUCCESS;
  while (count--) {
    CODE_COVERAGE(237); // Hit
    TeError tempErr = vm_resolveExport(vm, *idTable++, resultTable++);
    if (tempErr != MVM_E_SUCCESS) {
      CODE_COVERAGE_ERROR_PATH(238); // Not hit
      err = tempErr;
    } else {
      CODE_COVERAGE(239); // Hit
    }
  }
  return err;
}

void mvm_initializeHandle(VM* vm, mvm_Handle* handle) {
  CODE_COVERAGE(19); // Hit
  VM_ASSERT(vm, !vm_isHandleInitialized(vm, handle));
  handle->_next = vm->gc_handles;
  vm->gc_handles = handle;
  handle->_value = VM_VALUE_UNDEFINED;
}

void vm_cloneHandle(VM* vm, mvm_Handle* target, const mvm_Handle* source) {
  CODE_COVERAGE_UNTESTED(20); // Not hit
  VM_ASSERT(vm, !vm_isHandleInitialized(vm, source));
  mvm_initializeHandle(vm, target);
  target->_value = source->_value;
}

TeError mvm_releaseHandle(VM* vm, mvm_Handle* handle) {
  // This function doesn't contain coverage markers because node hits this path
  // non-deterministically.
  mvm_Handle** h = &vm->gc_handles;
  while (*h) {
    if (*h == handle) {
      *h = handle->_next;
      handle->_value = VM_VALUE_UNDEFINED;
      handle->_next = NULL;
      return MVM_E_SUCCESS;
    }
    h = &((*h)->_next);
  }
  handle->_value = VM_VALUE_UNDEFINED;
  handle->_next = NULL;
  return MVM_E_INVALID_HANDLE;
}

static bool vm_isHandleInitialized(VM* vm, const mvm_Handle* handle) {
  CODE_COVERAGE(22); // Hit
  mvm_Handle* h = vm->gc_handles;
  while (h) {
    CODE_COVERAGE(243); // Hit
    if (h == handle) {
      CODE_COVERAGE_UNTESTED(244); // Not hit
      return true;
    } else {
      CODE_COVERAGE(245); // Hit
    }
    h = h->_next;
  }
  return false;
}

static Value vm_convertToString(VM* vm, Value value) {
  CODE_COVERAGE(23); // Hit
  TeTypeCode type = deepTypeOf(vm, value);

  switch (type) {
    case VM_TAG_INT: {
      CODE_COVERAGE_UNTESTED(246); // Not hit
      return VM_NOT_IMPLEMENTED(vm);
    }
    case TC_REF_INT32: {
      CODE_COVERAGE_UNTESTED(247); // Not hit
      return VM_NOT_IMPLEMENTED(vm);
    }
    case TC_REF_FLOAT64: {
      CODE_COVERAGE_UNTESTED(248); // Not hit
      return VM_NOT_IMPLEMENTED(vm);
    }
    case TC_REF_STRING: {
      CODE_COVERAGE(249); // Hit
      return value;
    }
    case TC_REF_UNIQUE_STRING: {
      CODE_COVERAGE(250); // Hit
      return value;
    }
    case TC_REF_PROPERTY_LIST: {
      CODE_COVERAGE_UNTESTED(251); // Not hit
      return VM_NOT_IMPLEMENTED(vm);
    }
    case TC_REF_ARRAY: {
      CODE_COVERAGE_UNTESTED(252); // Not hit
      return VM_NOT_IMPLEMENTED(vm);
    }
    case TC_REF_FUNCTION: {
      CODE_COVERAGE_UNTESTED(254); // Not hit
      return VM_NOT_IMPLEMENTED(vm);
    }
    case TC_REF_HOST_FUNC: {
      CODE_COVERAGE_UNTESTED(255); // Not hit
      return VM_NOT_IMPLEMENTED(vm);
    }
    case TC_REF_BIG_INT: {
      CODE_COVERAGE_UNTESTED(256); // Not hit
      return VM_NOT_IMPLEMENTED(vm);
    }
    case TC_REF_SYMBOL: {
      CODE_COVERAGE_UNTESTED(257); // Not hit
      return VM_NOT_IMPLEMENTED(vm);
    }
    case TC_VAL_UNDEFINED: {
      CODE_COVERAGE_UNTESTED(258); // Not hit
      return VM_NOT_IMPLEMENTED(vm);
    }
    case TC_VAL_NULL: {
      CODE_COVERAGE_UNTESTED(259); // Not hit
      return VM_NOT_IMPLEMENTED(vm);
    }
    case TC_VAL_TRUE: {
      CODE_COVERAGE_UNTESTED(260); // Not hit
      return VM_NOT_IMPLEMENTED(vm);
    }
    case TC_VAL_FALSE: {
      CODE_COVERAGE_UNTESTED(261); // Not hit
      return VM_NOT_IMPLEMENTED(vm);
    }
    case TC_VAL_NAN: {
      CODE_COVERAGE_UNTESTED(262); // Not hit
      return VM_NOT_IMPLEMENTED(vm);
    }
    case TC_VAL_NEG_ZERO: {
      CODE_COVERAGE_UNTESTED(263); // Not hit
      return VM_NOT_IMPLEMENTED(vm);
    }
    case VM_VALUE_STR_LENGTH: {
      CODE_COVERAGE_UNTESTED(266); // Not hit
      return value;
    }
    case VM_VALUE_STR_PROTO: {
      CODE_COVERAGE_UNTESTED(267); // Not hit
      return value;
    }
    case TC_VAL_DELETED: {
      CODE_COVERAGE_UNTESTED(264); // Not hit
      return VM_NOT_IMPLEMENTED(vm);
    }
    case TC_REF_STRUCT: {
      CODE_COVERAGE_UNTESTED(265); // Not hit
      return VM_NOT_IMPLEMENTED(vm);
    }
    default: return VM_UNEXPECTED_INTERNAL_ERROR(vm);
  }
}

static Value vm_concat(VM* vm, Value left, Value right) {
  CODE_COVERAGE(24); // Hit
  size_t leftSize = 0;
  const char* leftStr = mvm_toStringUtf8(vm, left, &leftSize);
  size_t rightSize = 0;
  const char* rightStr = mvm_toStringUtf8(vm, right, &rightSize);
  uint8_t* data;
  Value value = vm_allocString(vm, leftSize + rightSize, (void**)&data);
  memcpy(data, leftStr, leftSize);
  memcpy(data + leftSize, rightStr, rightSize);
  return value;
}

/* Returns the deep type of the value, looking through pointers and boxing */
static TeTypeCode deepTypeOf(VM* vm, Value value) {
  CODE_COVERAGE(27); // Hit
  TeValueTag tag = VM_TAG_OF(value);
  if (tag == VM_TAG_INT) {
    CODE_COVERAGE(295); // Hit
    return TC_VAL_INT14;
  }

  // Check for "well known" values such as TC_VAL_UNDEFINED
  if (tag == VM_TAG_PGM_P && value < VM_VALUE_WELLKNOWN_END) {
    CODE_COVERAGE(296); // Hit
    // Well known types have a value that matches the corresponding type code
    return (TeTypeCode)VM_VALUE_OF(value);
  } else {
    CODE_COVERAGE(297); // Hit
  }

  // Else, value is a pointer. The type of a pointer value is the type of the value being pointed to
  vm_HeaderWord headerWord = vm_readHeaderWord(vm, value);
  TeTypeCode typeCode = vm_getTypeCodeFromHeaderWord(headerWord);

  return typeCode;
}

#if MVM_SUPPORT_FLOAT
int32_t mvm_float64ToInt32(MVM_FLOAT64 value) {
  CODE_COVERAGE(486); // Hit
  if (isfinite(value)) {
    CODE_COVERAGE(487); // Hit
    return (int32_t)value;
  }
  else {
    CODE_COVERAGE(488); // Hit
    return 0;
  }
}

Value mvm_newNumber(VM* vm, MVM_FLOAT64 value) {
  CODE_COVERAGE(28); // Hit
  if (isnan(value)) {
    CODE_COVERAGE(298); // Hit
    return VM_VALUE_NAN;
  }
  if (value == -0.0) {
    CODE_COVERAGE(299); // Hit
    return VM_VALUE_NEG_ZERO;
  }

  // Doubles are very expensive to compute, so at every opportunity, we'll check
  // if we can coerce back to an integer
  int32_t valueAsInt = mvm_float64ToInt32(value);
  if (value == (MVM_FLOAT64)valueAsInt) {
    CODE_COVERAGE(300); // Hit
    return mvm_newInt32(vm, valueAsInt);
  } else {
    CODE_COVERAGE(301); // Hit
  }

  MVM_FLOAT64* pResult;
  Value resultValue = gc_allocateWithHeader(vm, sizeof (MVM_FLOAT64), TC_REF_FLOAT64, (void**)&pResult);
  *pResult = value;

  return resultValue;
}
#endif // MVM_SUPPORT_FLOAT

Value mvm_newInt32(VM* vm, int32_t value) {
  CODE_COVERAGE(29); // Hit
  if ((value >= VM_MIN_INT14) && (value <= VM_MAX_INT14)) {
    CODE_COVERAGE(302); // Hit
    return (value & VM_VALUE_MASK) | VM_TAG_INT;
  } else {
    CODE_COVERAGE(303); // Hit
  }

  // Int32
  int32_t* pResult;
  Value resultValue = gc_allocateWithHeader(vm, sizeof (int32_t), TC_REF_INT32, (void**)&pResult);
  *pResult = value;

  return resultValue;
}

bool mvm_toBool(VM* vm, Value value) {
  CODE_COVERAGE(30); // Hit

  TeTypeCode type = deepTypeOf(vm, value);
  switch (type) {
    case TC_VAL_INT14: {
      CODE_COVERAGE(304); // Hit
      return value != 0;
    }
    case TC_REF_INT32: {
      CODE_COVERAGE_UNTESTED(305); // Not hit
      // Int32 can't be zero, otherwise it would be encoded as an int14
      VM_ASSERT(vm, vm_readInt32(vm, type, value) != 0);
      return false;
    }
    case TC_REF_FLOAT64: {
      CODE_COVERAGE_UNTESTED(306); // Not hit
      #if MVM_SUPPORT_FLOAT
        // Double can't be zero, otherwise it would be encoded as an int14
        VM_ASSERT(vm, mvm_toFloat64(vm, value) != 0);
      #endif
      return false;
    }
    case TC_REF_UNIQUE_STRING:
    case TC_REF_STRING: {
      CODE_COVERAGE(307); // Hit
      return vm_stringSizeUtf8(vm, value) != 0;
    }
    case TC_REF_PROPERTY_LIST: {
      CODE_COVERAGE(308); // Hit
      return true;
    }
    case TC_REF_ARRAY: {
      CODE_COVERAGE(309); // Hit
      return true;
    }
    case TC_REF_FUNCTION: {
      CODE_COVERAGE_UNTESTED(311); // Not hit
      return true;
    }
    case TC_REF_HOST_FUNC: {
      CODE_COVERAGE_UNTESTED(312); // Not hit
      return true;
    }
    case TC_REF_BIG_INT: {
      CODE_COVERAGE_UNTESTED(313); // Not hit
      return VM_RESERVED(vm);
    }
    case TC_REF_SYMBOL: {
      CODE_COVERAGE_UNTESTED(314); // Not hit
      return true;
    }
    case TC_VAL_UNDEFINED: {
      CODE_COVERAGE(315); // Hit
      return false;
    }
    case TC_VAL_NULL: {
      CODE_COVERAGE(316); // Hit
      return false;
    }
    case TC_VAL_TRUE: {
      CODE_COVERAGE(317); // Hit
      return true;
    }
    case TC_VAL_FALSE: {
      CODE_COVERAGE(318); // Hit
      return false;
    }
    case TC_VAL_NAN: {
      CODE_COVERAGE_UNTESTED(319); // Not hit
      return false;
    }
    case TC_VAL_NEG_ZERO: {
      CODE_COVERAGE_UNTESTED(320); // Not hit
      return false;
    }
    case TC_VAL_DELETED: {
      CODE_COVERAGE_UNTESTED(321); // Not hit
      return false;
    }
    case VM_VALUE_STR_LENGTH: {
      CODE_COVERAGE_UNTESTED(268); // Not hit
      return true;
    }
    case VM_VALUE_STR_PROTO: {
      CODE_COVERAGE_UNTESTED(269); // Not hit
      return true;
    }
    case TC_REF_STRUCT: {
      CODE_COVERAGE_UNTESTED(322); // Not hit
      return true;
    }
    default: return VM_UNEXPECTED_INTERNAL_ERROR(vm);
  }
}

static bool vm_isString(VM* vm, Value value) {
  CODE_COVERAGE(31); // Hit
  TeTypeCode deepType = deepTypeOf(vm, value);
  if (
    (deepType == TC_REF_STRING) ||
    (deepType == TC_REF_UNIQUE_STRING) ||
    (deepType == TC_VAL_STR_PROTO) ||
    (deepType == TC_VAL_STR_LENGTH)
  ) {
    CODE_COVERAGE(323); // Hit
    return true;
  } else {
    CODE_COVERAGE(324); // Hit
    return false;
  }
}

/** Reads a numeric value that is a subset of a 32-bit integer */
static int32_t vm_readInt32(VM* vm, TeTypeCode type, Value value) {
  CODE_COVERAGE(33); // Hit
  if (type == TC_VAL_INT14) {
    CODE_COVERAGE(330); // Hit
    if (value >= 0x2000) { // Negative
      CODE_COVERAGE(91); // Hit
      return value - 0x4000;
    }
    else {
      CODE_COVERAGE(446); // Hit
      return value;
    }
  } else if (type == TC_REF_INT32) {
    CODE_COVERAGE(331); // Hit
    int32_t result;
    vm_readMem(vm, &result, value, sizeof result);
    return result;
  } else {
    return VM_UNEXPECTED_INTERNAL_ERROR(vm);
  }
}

static void vm_push(VM* vm, uint16_t value) {
  CODE_COVERAGE(34); // Hit
  *(vm->stack->reg.pStackPointer++) = value;
}

static uint16_t vm_pop(VM* vm) {
  CODE_COVERAGE(35); // Hit
  return *(--vm->stack->reg.pStackPointer);
}

static void vm_writeUInt16(VM* vm, Pointer p, Value value) {
  CODE_COVERAGE(36); // Hit
  vm_writeMem(vm, p, &value, sizeof value);
}


static uint16_t vm_readUInt16(VM* vm, Pointer p) {
  CODE_COVERAGE(332); // Hit
  uint16_t result;
  vm_readMem(vm, &result, p, sizeof(result));
  return result;
}

static inline vm_HeaderWord vm_readHeaderWord(VM* vm, Pointer pAllocation) {
  CODE_COVERAGE(37); // Hit
  return vm_readUInt16(vm, pAllocation - 2);
}

// TODO: Audit uses of this, since it's a slow function
static void vm_readMem(VM* vm, void* target, Pointer source, uint16_t size) {
  CODE_COVERAGE(38); // Hit
  uint16_t addr = VM_VALUE_OF(source);
  switch (VM_TAG_OF(source)) {
    case VM_TAG_GC_P: {
      CODE_COVERAGE(333); // Hit
      uint8_t* sourceAddress = gc_deref(vm, source);
      memcpy(target, sourceAddress, size);
      break;
    }
    case VM_TAG_DATA_P: {
      CODE_COVERAGE_UNTESTED(334); // Not hit
      memcpy(target, (uint8_t*)vm->dataMemory + addr, size);
      break;
    }
    case VM_TAG_PGM_P: {
      CODE_COVERAGE(335); // Hit
      VM_ASSERT(vm, source > VM_VALUE_WELLKNOWN_END);
      VM_READ_BC_N_AT(target, addr, size, vm->pBytecode);
      break;
    }
    default: VM_UNEXPECTED_INTERNAL_ERROR(vm);
  }
}

static void vm_writeMem(VM* vm, Pointer target, void* source, uint16_t size) {
  CODE_COVERAGE(39); // Hit
  switch (VM_TAG_OF(target)) {
    case VM_TAG_GC_P: {
      CODE_COVERAGE(336); // Hit
      uint8_t* targetAddress = gc_deref(vm, target);
      memcpy(targetAddress, source, size);
      break;
    }
    case VM_TAG_DATA_P: {
      CODE_COVERAGE_UNTESTED(337); // Not hit
      uint16_t addr = VM_VALUE_OF(target);
      memcpy((uint8_t*)vm->dataMemory + addr, source, size);
      break;
    }
    case VM_TAG_PGM_P: {
      CODE_COVERAGE_ERROR_PATH(338); // Not hit
      MVM_FATAL_ERROR(vm, MVM_E_ATTEMPT_TO_WRITE_TO_ROM);
      break;
    }
    default: VM_UNEXPECTED_INTERNAL_ERROR(vm);
  }
}

static inline mvm_TfHostFunction* vm_getResolvedImports(VM* vm) {
  CODE_COVERAGE(40); // Hit
  return (mvm_TfHostFunction*)(vm + 1); // Starts right after the header
}

static inline uint16_t vm_getResolvedImportCount(VM* vm) {
  CODE_COVERAGE(41); // Hit
  uint16_t importTableSize = VM_READ_BC_2_HEADER_FIELD(importTableSize, vm->pBytecode);
  uint16_t importCount = importTableSize / sizeof(vm_TsImportTableEntry);
  return importCount;
}

mvm_TeType mvm_typeOf(VM* vm, Value value) {
  CODE_COVERAGE(42); // Hit
  TeTypeCode type = deepTypeOf(vm, value);
  // TODO: This should be implemented as a lookup table, not a switch
  switch (type) {
    case TC_VAL_UNDEFINED:
    case TC_VAL_DELETED: {
      CODE_COVERAGE(339); // Hit
      return VM_T_UNDEFINED;
    }

    case TC_VAL_NULL: {
      CODE_COVERAGE_UNTESTED(340); // Not hit
      return VM_T_NULL;
    }

    case TC_VAL_TRUE:
    case TC_VAL_FALSE: {
      CODE_COVERAGE(341); // Hit
      return VM_T_BOOLEAN;
    }

    case TC_VAL_INT14:
    case TC_REF_FLOAT64:
    case TC_REF_INT32:
    case TC_VAL_NAN:
    case TC_VAL_NEG_ZERO: {
      CODE_COVERAGE(342); // Hit
      return VM_T_NUMBER;
    }

    case TC_REF_STRING:
    case TC_REF_UNIQUE_STRING:
    case TC_VAL_STR_LENGTH:
    case TC_VAL_STR_PROTO: {
      CODE_COVERAGE(343); // Hit
      return VM_T_STRING;
    }

    case TC_REF_ARRAY: {
      CODE_COVERAGE_UNTESTED(344); // Not hit
      return VM_T_ARRAY;
    }

    case TC_REF_PROPERTY_LIST:
    case TC_REF_STRUCT: {
      CODE_COVERAGE_UNTESTED(345); // Not hit
      return VM_T_OBJECT;
    }

    case TC_REF_FUNCTION:
    case TC_REF_HOST_FUNC: {
      CODE_COVERAGE(346); // Hit
      return VM_T_FUNCTION;
    }

    case TC_REF_BIG_INT: {
      CODE_COVERAGE_UNTESTED(347); // Not hit
      return VM_T_BIG_INT;
    }
    case TC_REF_SYMBOL: {
      CODE_COVERAGE_UNTESTED(348); // Not hit
      return VM_T_SYMBOL;
    }

    default: VM_UNEXPECTED_INTERNAL_ERROR(vm); return VM_T_UNDEFINED;
  }
}

const char* mvm_toStringUtf8(VM* vm, Value value, size_t* out_sizeBytes) {
  CODE_COVERAGE(43); // Hit
  value = vm_convertToString(vm, value);

  vm_HeaderWord headerWord = vm_readHeaderWord(vm, value);
  TeTypeCode typeCode = vm_getTypeCodeFromHeaderWord(headerWord);

  if (typeCode == TC_VAL_STR_PROTO) {
    *out_sizeBytes = 9;
    return "__proto__";
  }

  if (typeCode == TC_VAL_STR_LENGTH) {
    *out_sizeBytes = 6;
    return "length";
  }

  VM_ASSERT(vm, (typeCode == TC_REF_STRING) || (typeCode == TC_REF_UNIQUE_STRING));

  uint16_t sourceSize = vm_getAllocationSizeExcludingHeaderFromHeaderWord(headerWord);

  if (out_sizeBytes) {
    CODE_COVERAGE(349); // Hit
    *out_sizeBytes = sourceSize - 1; // Without the extra safety null-terminator
  } else {
    CODE_COVERAGE_UNTESTED(350); // Not hit
  }

  // If the string is program memory, we have to allocate a copy of it in data
  // memory because program memory is not necessarily addressable
  // TODO: There should be a flag to suppress this when it isn't needed
  if (VM_IS_PGM_P(value)) {
    CODE_COVERAGE(351); // Hit
    void* data;
    gc_allocateWithHeader(vm, sourceSize, TC_REF_STRING, &data);
    vm_readMem(vm, data, value, sourceSize);
    return data;
  } else {
    CODE_COVERAGE(352); // Hit
    return vm_deref(vm, value);
  }
}

Value mvm_newBoolean(bool source) {
  CODE_COVERAGE_UNTESTED(44); // Not hit
  return source ? VM_VALUE_TRUE : VM_VALUE_FALSE;
}

Value vm_allocString(VM* vm, size_t sizeBytes, void** data) {
  CODE_COVERAGE(45); // Hit
  if (sizeBytes > 0x3FFF - 1) {
    CODE_COVERAGE_ERROR_PATH(353); // Not hit
    MVM_FATAL_ERROR(vm, MVM_E_ALLOCATION_TOO_LARGE);
  } else {
    CODE_COVERAGE(354); // Hit
  }
  // Note: allocating 1 extra byte for the extra null terminator
  Value value = gc_allocateWithHeader(vm, (uint16_t)sizeBytes + 1, TC_REF_STRING, data);
  // Null terminator
  ((char*)(*data))[sizeBytes] = '\0';
  return value;
}

Value mvm_newString(VM* vm, const char* sourceUtf8, size_t sizeBytes) {
  CODE_COVERAGE_UNTESTED(46); // Not hit
  void* data;
  Value value = vm_allocString(vm, sizeBytes, &data);
  memcpy(data, sourceUtf8, sizeBytes);
  return value;
}

static void* vm_deref(VM* vm, Value pSrc) {
  CODE_COVERAGE(47); // Hit
  uint16_t tag = VM_TAG_OF(pSrc);
  if (tag == VM_TAG_GC_P) {
    CODE_COVERAGE(355); // Hit
    return gc_deref(vm, pSrc);
  } else {
    CODE_COVERAGE_UNTESTED(356); // Not hit
  }
  if (tag == VM_TAG_DATA_P) {
    CODE_COVERAGE_UNTESTED(357); // Not hit
    return (uint8_t*)vm->dataMemory + VM_VALUE_OF(pSrc);
  } else {
    CODE_COVERAGE_UNTESTED(358); // Not hit
  }
  // Program pointers (and integers) are not dereferenceable, so it shouldn't get here.
  VM_UNEXPECTED_INTERNAL_ERROR(vm);
  return NULL;
}

static TeError getProperty(VM* vm, Value objectValue, Value propertyName, Value* propertyValue) {
  CODE_COVERAGE(48); // Hit

  toPropertyName(vm, &propertyName);
  TeTypeCode type = deepTypeOf(vm, objectValue);
  switch (type) {
    case TC_REF_PROPERTY_LIST: {
      CODE_COVERAGE(359); // Hit
      if (propertyName == VM_VALUE_STR_PROTO) {
        CODE_COVERAGE_UNIMPLEMENTED(326); // Not hit
        return VM_NOT_IMPLEMENTED(vm);
      }
      Pointer pCell = vm_readUInt16(vm, objectValue);
      while (pCell) {
        CODE_COVERAGE(360); // Hit
        TsPropertyCell cell;
        vm_readMem(vm, &cell, pCell, sizeof cell);
        // We can do direct comparison because the strings have been uniqued,
        // and numbers are represented in a normalized way.
        if (cell.key == propertyName) {
          CODE_COVERAGE(361); // Hit
          *propertyValue = cell.value;
          return MVM_E_SUCCESS;
        } else {
          CODE_COVERAGE(362); // Hit
        }
        pCell = cell.next;
      }
      *propertyValue = VM_VALUE_UNDEFINED;
      return MVM_E_SUCCESS;
    }
    case TC_REF_ARRAY: {
      CODE_COVERAGE(363); // Hit
      uint16_t length = vm_readUInt16(vm, objectValue + 2);
      if (propertyName == VM_VALUE_STR_LENGTH) {
        CODE_COVERAGE(274); // Hit
        VM_ASSERT(vm, VM_IS_INT14(length));
        *propertyValue = length;
        return MVM_E_SUCCESS;
      } else if (propertyName == VM_VALUE_STR_PROTO) {
        CODE_COVERAGE(275); // Hit
        *propertyValue = vm->arrayProto;
        return MVM_E_SUCCESS;
      } else {
        CODE_COVERAGE(276); // Hit
      }
      // Array index
      if (VM_IS_INT14(propertyName)) {
        CODE_COVERAGE(277); // Hit
        uint16_t index = propertyName;
        Pointer data = vm_readUInt16(vm, objectValue);
        VM_ASSERT(vm, index >= 0);
        if (index >= length) {
          CODE_COVERAGE(283); // Hit
          *propertyValue = VM_VALUE_UNDEFINED;
          return MVM_E_SUCCESS;
        } else {
          CODE_COVERAGE(328); // Hit
        }
        uint16_t value = vm_readUInt16(vm, data + index * 2);
        if (value == VM_VALUE_DELETED) {
          CODE_COVERAGE(329); // Hit
          value = VM_VALUE_UNDEFINED;
        } else {
          CODE_COVERAGE(364); // Hit
        }
        *propertyValue = value;
        return MVM_E_SUCCESS;
      }
      CODE_COVERAGE(278); // Hit

      Pointer arrayProto = vm->arrayProto;
      if (arrayProto != VM_VALUE_NULL) {
        CODE_COVERAGE(396); // Hit
        return getProperty(vm, arrayProto, propertyName, propertyValue);
      } else {
        CODE_COVERAGE_UNTESTED(397); // Not hit
        *propertyValue = VM_VALUE_UNDEFINED;
        return MVM_E_SUCCESS;
      }
    }
    case TC_REF_STRUCT: {
      CODE_COVERAGE_UNIMPLEMENTED(365); // Not hit
      return VM_NOT_IMPLEMENTED(vm);
    }
    default: return MVM_E_TYPE_ERROR;
  }
}

static void growArray(VM* vm, TsArray* arr, uint16_t newLength, uint16_t newCapacity) {
  CODE_COVERAGE(293); // Hit
  uint16_t* pTarget;
  Pointer newData = gc_allocateWithoutHeader(vm, newCapacity * 2, (void*)&pTarget);
  // Copy values from the old array
  if (arr->data) {
    CODE_COVERAGE(294); // Hit
    VM_ASSERT(vm, arr->length != 0);
    vm_readMem(vm, pTarget, arr->data, arr->capacity * 2);
  } else {
    CODE_COVERAGE(310); // Hit
    VM_ASSERT(vm, arr->capacity == 0);
  }
  CODE_COVERAGE(325); // Hit
  // Fill in the rest of the memory as holes
  pTarget += arr->capacity;
  for (uint16_t i = arr->capacity; i < newCapacity; i++) {
    *pTarget++ = VM_VALUE_DELETED;
  }
  arr->data = newData;
  arr->length = newLength;
  arr->capacity = newCapacity;
}

static TeError setProperty(VM* vm, Value objectValue, Value propertyName, Value propertyValue) {
  CODE_COVERAGE(49); // Hit

  toPropertyName(vm, &propertyName);
  TeTypeCode type = deepTypeOf(vm, objectValue);
  switch (type) {
    case TC_REF_PROPERTY_LIST: {
      CODE_COVERAGE(366); // Hit
      if (propertyName == VM_VALUE_STR_PROTO) {
        CODE_COVERAGE_UNIMPLEMENTED(327); // Not hit
        return VM_NOT_IMPLEMENTED(vm);
      }
      Pointer vppCell = objectValue + OFFSETOF(TsPropertyList, first);
      Pointer vpCell = vm_readUInt16(vm, vppCell);
      while (vpCell) {
        CODE_COVERAGE(367); // Hit
        Value key = vm_readUInt16(vm, vpCell + OFFSETOF(TsPropertyCell, key));
        // We can do direct comparison because the strings have been uniqued,
        // and numbers are represented in a normalized way.
        if (key == propertyName) {
          CODE_COVERAGE(368); // Hit
          vm_writeUInt16(vm, vpCell + OFFSETOF(TsPropertyCell, value), propertyValue);
          return MVM_E_SUCCESS;
        } else {
          CODE_COVERAGE(369); // Hit
        }
        vppCell = vpCell + OFFSETOF(TsPropertyCell, next);
        vpCell = vm_readUInt16(vm, vppCell);
      }
      // If we reach the end, then this is a new property
      TsPropertyCell* pNewCell;
      Pointer vpNewCell = gc_allocateWithoutHeader(vm, sizeof (TsPropertyCell), (void**)&pNewCell);
      pNewCell->key = propertyName;
      pNewCell->value = propertyValue;
      pNewCell->next = 0;
      vm_writeUInt16(vm, vppCell, vpNewCell);
      return MVM_E_SUCCESS;
    }
    case TC_REF_ARRAY: {
      CODE_COVERAGE(370); // Hit

      // SetProperty on an array means the array cannot be in ROM
      if (VM_IS_PGM_P(objectValue)) {
        VM_INVALID_BYTECODE(vm);
      }

      TsArray* arr = vm_deref(vm, objectValue);

      if (propertyName == VM_VALUE_STR_LENGTH) {
        CODE_COVERAGE(282); // Hit
        uint16_t newLength = propertyValue;

        // Either making the array smaller, or sizing it less than the capacity
        if (newLength <= arr->length) {
          CODE_COVERAGE(176); // Hit

          // Wipe array items that aren't reachable
          uint16_t count = arr->length - newLength;
          uint16_t* p = vm_deref(vm, arr->data);
          p += newLength;
          while (count--)
            *p++ = VM_VALUE_DELETED;

          arr->length = newLength;
          return MVM_E_SUCCESS;
        } else if (newLength < arr->capacity) {
          CODE_COVERAGE(287); // Hit

          // We can just overwrite the length field. Note that the newly
          // uncovered memory is already filled with VM_VALUE_DELETED
          arr->length = newLength;
          return MVM_E_SUCCESS;
        } else { // Make array bigger
          CODE_COVERAGE(288); // Hit
          // I'll assume that direct assignments to the length mean that people
          // know exactly how big the array should be, so we don't add any
          // extra capacity
          uint16_t newCapacity = newLength;
          growArray(vm, arr, newLength, newCapacity);
          return MVM_E_SUCCESS;
        }
      }
      if (propertyName == VM_VALUE_STR_PROTO) {
        CODE_COVERAGE_UNTESTED(289); // Not hit
        return MVM_E_PROTO_IS_READONLY;
      }
      CODE_COVERAGE(284); // Hit

      // Array index
      if (VM_IS_INT14(propertyName)) {
        CODE_COVERAGE(285); // Hit
        uint16_t index = propertyName;
        VM_ASSERT(vm, index >= 0);
        // Need to expand the array?
        if (index >= arr->length) {
          CODE_COVERAGE(290); // Hit
          uint16_t newLength = index + 1;
          if (index < arr->capacity) {
            CODE_COVERAGE(291); // Hit
            // The length changes to include the value. The extra slots are
            // already filled in with holes from the original allocation.
            arr->length = newLength;
          } else {
            CODE_COVERAGE(292); // Hit
            // We expand the capacity more aggressively here because this is the
            // path used when we push into arrays or just assign values to an
            // array in a loop.
            uint16_t newCapacity = arr->capacity * 2;
            if (newCapacity < 4) newCapacity = 4;
            if (newCapacity < newLength) newCapacity = newLength;
            growArray(vm, arr, newLength, newCapacity);
          }
        }
        // Write the item to memory
        vm_writeUInt16(vm, arr->data + index * 2, propertyValue);
        return MVM_E_SUCCESS;
      }
      CODE_COVERAGE(286); // Hit

      // JavaScript doesn't seem to throw by default when you set properties on
      // immutable objects. Here, I'm just treating the array as if it were
      // immutable with respect to non-index properties, and so here I'm just
      // ignoring the write.
      return MVM_E_SUCCESS;
    }
    case TC_REF_STRUCT: {
      CODE_COVERAGE_UNIMPLEMENTED(372); // Not hit
      return VM_NOT_IMPLEMENTED(vm);
    }
    default: return MVM_E_TYPE_ERROR;
  }
}

/** Converts the argument to either an TC_VAL_INT14 or a TC_REF_UNIQUE_STRING, or gives an error */
static TeError toPropertyName(VM* vm, Value* value) {
  CODE_COVERAGE(50); // Hit
  // Property names in microvium are either integer indexes or non-integer unique strings
  TeTypeCode type = deepTypeOf(vm, *value);
  switch (type) {
    // These are already valid property names
    case TC_VAL_INT14: {
      CODE_COVERAGE(279); // Hit
      if (*value < 0) {
        CODE_COVERAGE_UNTESTED(280); // Not hit
        return MVM_E_RANGE_ERROR;
      }
      CODE_COVERAGE(281); // Hit
      return MVM_E_SUCCESS;
    }
    case TC_REF_UNIQUE_STRING: {
      CODE_COVERAGE(373); // Hit
      return MVM_E_SUCCESS;
    }

    case TC_REF_INT32: {
      CODE_COVERAGE_ERROR_PATH(374); // Not hit
      // 32-bit numbers are out of the range of supported array indexes
      return MVM_E_RANGE_ERROR;
    }

    case TC_REF_STRING: {
      CODE_COVERAGE_UNTESTED(375); // Not hit

      // In Microvium at the moment, it's illegal to use an integer-valued
      // string as a property name. If the string is in bytecode, it will only
      // have the type TC_REF_STRING if it's a number and is illegal.
      if (VM_IS_PGM_P(*value)) {
        CODE_COVERAGE_ERROR_PATH(376); // Not hit
        return MVM_E_TYPE_ERROR;
      } else {
        CODE_COVERAGE_UNTESTED(377); // Not hit
      }

      // Strings which have all digits are illegal as property names
      if (vm_stringIsNonNegativeInteger(vm, *value)) {
        CODE_COVERAGE_ERROR_PATH(378); // Not hit
        return MVM_E_TYPE_ERROR;
      } else {
        CODE_COVERAGE_UNTESTED(379); // Not hit
      }

      // Strings need to be converted to unique strings in order to be valid
      // property names. This is because properties are searched by reference
      // equality.
      *value = toUniqueString(vm, *value);
      return MVM_E_SUCCESS;
    }

    case TC_VAL_STR_LENGTH: {
      CODE_COVERAGE(272); // Hit
      return MVM_E_SUCCESS;
    }

    case TC_VAL_STR_PROTO: {
      CODE_COVERAGE(273); // Hit
      return MVM_E_SUCCESS;
    }
    default: {
      CODE_COVERAGE_ERROR_PATH(380); // Not hit
      return MVM_E_TYPE_ERROR;
    }
  }
}

// Converts a TC_REF_STRING to a TC_REF_UNIQUE_STRING
// TODO: Test cases for this function
static Value toUniqueString(VM* vm, Value value) {
  CODE_COVERAGE_UNTESTED(51); // Not hit
  VM_ASSERT(vm, deepTypeOf(vm, value) == TC_REF_STRING);
  VM_ASSERT(vm, VM_IS_GC_P(value));

  // TC_REF_STRING values are always in GC memory. If they were in flash, they'd
  // already be TC_REF_UNIQUE_STRING.
  char* str1Data = (char*)gc_deref(vm, value);
  uint16_t str1Header = vm_readHeaderWord(vm, value);
  int str1Size = vm_getAllocationSizeExcludingHeaderFromHeaderWord(str1Header);

  if (strcmp(str1Data, "__proto__") == 0) return VM_VALUE_STR_PROTO;
  if (strcmp(str1Data, "length") == 0) return VM_VALUE_STR_LENGTH;

  MVM_PROGMEM_P pBytecode = vm->pBytecode;

  // We start by searching the string table for unique strings that are baked
  // into the ROM. These are stored alphabetically, so we can perform a binary
  // search.

  BO_t stringTableOffset = VM_READ_BC_2_HEADER_FIELD(stringTableOffset, pBytecode);
  uint16_t stringTableSize = VM_READ_BC_2_HEADER_FIELD(stringTableSize, pBytecode);
  int strCount = stringTableSize / sizeof (Value);

  int first = 0;
  int last = strCount;
  int middle = (first + last) / 2;

  while (first <= last) {
    CODE_COVERAGE_UNTESTED(381); // Not hit
    BO_t str2Offset = stringTableOffset + middle * 2;
    Value str2Value = VM_READ_BC_2_AT(str2Offset, pBytecode);
    VM_ASSERT(vm, VM_IS_PGM_P(str2Value));
    uint16_t str2Header = vm_readHeaderWord(vm, str2Value);
    int str2Size = vm_getAllocationSizeExcludingHeaderFromHeaderWord(str2Header);
    MVM_PROGMEM_P str2Data = pgm_deref(vm, str2Value);
    int compareSize = str1Size < str2Size ? str1Size : str2Size;
    // TODO: this function can probably be simplified if it uses vm_memcmp
    int c = memcmp_pgm(str1Data, str2Data, compareSize);

    // If they compare equal for the range that they have in common, we check the length
    if (c == 0) {
      CODE_COVERAGE_UNTESTED(382); // Not hit
      if (str1Size < str2Size) {
        CODE_COVERAGE_UNTESTED(383); // Not hit
        c = -1;
      } else if (str1Size > str2Size) {
        CODE_COVERAGE_UNTESTED(384); // Not hit
        c = 1;
      } else {
        CODE_COVERAGE_UNTESTED(385); // Not hit
        // Exact match
        return str2Value;
      }
    }

    // c is > 0 if the string we're searching for comes after the middle point
    if (c > 0) {
      CODE_COVERAGE_UNTESTED(386); // Not hit
      first = middle + 1;
    } else {
      CODE_COVERAGE_UNTESTED(387); // Not hit
      last = middle - 1;
    }

    middle = (first + last) / 2;
  }

  // At this point, we haven't found the unique string in the bytecode. We need
  // to check in RAM. Now we're comparing an in-RAM string against other in-RAM
  // strings, so it's using gc_deref instead of pgm_deref, and memcmp instead of
  // memcmp_pgm. Also, we're looking for an exact match, not performing a binary
  // search with inequality comparison, since the linked list of unique strings
  // in RAM is not sorted.
  Pointer vpCell = vm->uniqueStrings;
  TsUniqueStringCell* pCell;
  while (vpCell != VM_VALUE_NULL) {
    CODE_COVERAGE_UNTESTED(388); // Not hit
    pCell = gc_deref(vm, vpCell);
    Value str2Value = pCell->str;
    uint16_t str2Header = vm_readHeaderWord(vm, str2Value);
    int str2Size = vm_getAllocationSizeExcludingHeaderFromHeaderWord(str2Header);
    MVM_PROGMEM_P str2Data = gc_deref(vm, str2Value);

    // The sizes have to match for the strings to be equal
    if (str2Size == str1Size) {
      CODE_COVERAGE_UNTESTED(389); // Not hit
      // Note: we use memcmp instead of strcmp because strings are allowed to
      // have embedded null terminators.
      int c = memcmp(str1Data, str2Data, str1Size);
      // Equal?
      if (c == 0) {
        CODE_COVERAGE_UNTESTED(390); // Not hit
        return str2Value;
      } else {
        CODE_COVERAGE_UNTESTED(391); // Not hit
      }
    }
    vpCell = pCell->next;
  }

  // If we get here, it means there was no matching unique string already
  // existing in ROM or RAM. We upgrade the current string to a
  // TC_REF_UNIQUE_STRING, since we now know it doesn't conflict with any existing
  // existing unique strings.
  str1Header = str1Size | (TC_REF_UNIQUE_STRING << 12);
  ((uint16_t*)str1Data)[-1] = str1Header; // Overwrite the header

  // Add the string to the linked list of unique strings
  int cellSize = sizeof (TsUniqueStringCell);
  vpCell = gc_allocateWithHeader(vm, cellSize, TC_REF_NONE, (void**)&pCell);
  // Push onto linked list
  pCell->next = vm->uniqueStrings;
  pCell->str = value;
  vm->uniqueStrings = vpCell;

  return value;

  // TODO: We need the GC to collect unique strings from RAM
}

// Same semantics as [memcmp](http://www.cplusplus.com/reference/cstring/memcmp/)
// but the second argument is a program memory pointer
static int memcmp_pgm(void* p1, MVM_PROGMEM_P p2, size_t size) {
  CODE_COVERAGE_UNTESTED(52); // Not hit
  while (size) {
    CODE_COVERAGE_UNTESTED(392); // Not hit
    char c1 = *((uint8_t*)p1);
    char c2 = MVM_READ_PROGMEM_1(p2);
    p1 = (void*)((uint8_t*)p1 + 1);
    p2 = MVM_PROGMEM_P_ADD(p2, 1);
    size--;
    if (c1 == c2) {
      CODE_COVERAGE_UNTESTED(393); // Not hit
      continue;
    } else if (c1 < c2) {
      CODE_COVERAGE_UNTESTED(394); // Not hit
      return -1;
    } else {
      CODE_COVERAGE_UNTESTED(395); // Not hit
      return 1;
    }
  }
  // If it's got this far, then all the bytes are equal
  return 0;
}

// Same semantics as [memcmp](http://www.cplusplus.com/reference/cstring/memcmp/)
// but operates on just program memory pointers
static int memcmp_pgm2(MVM_PROGMEM_P p1, MVM_PROGMEM_P p2, size_t size) {
  CODE_COVERAGE_UNTESTED(466); // Not hit
  while (size) {
    CODE_COVERAGE_UNTESTED(467); // Not hit
    char c1 = MVM_READ_PROGMEM_1(p1);
    char c2 = MVM_READ_PROGMEM_1(p2);
    p1 = MVM_PROGMEM_P_ADD(p1, 1);
    p2 = MVM_PROGMEM_P_ADD(p2, 1);
    size--;
    if (c1 == c2) {
      CODE_COVERAGE_UNTESTED(468); // Not hit
      continue;
    } else if (c1 < c2) {
      CODE_COVERAGE_UNTESTED(469); // Not hit
      return -1;
    } else {
      CODE_COVERAGE_UNTESTED(470); // Not hit
      return 1;
    }
  }
  // If it's got this far, then all the bytes are equal
  return 0;
}

// Same semantics as [memcmp](http://www.cplusplus.com/reference/cstring/memcmp/)
// but for VM pointers
static int vm_memcmp(VM* vm, Pointer a, Pointer b, uint16_t size) {
  CODE_COVERAGE_UNTESTED(471); // Not hit
  if (VM_IS_PGM_P(a)) {
    CODE_COVERAGE_UNTESTED(472); // Not hit
    if (VM_IS_PGM_P(b)) {
      CODE_COVERAGE_UNTESTED(473); // Not hit
      return memcmp_pgm2(pgm_deref(vm, a), pgm_deref(vm, b), size);
    } else {
      CODE_COVERAGE_UNTESTED(474); // Not hit
      return -memcmp_pgm(vm_deref(vm, b), pgm_deref(vm, a), size);
    }
  } else {
    CODE_COVERAGE_UNTESTED(478); // Not hit
    if (VM_IS_PGM_P(b)) {
      CODE_COVERAGE_UNTESTED(479); // Not hit
      return memcmp_pgm(vm_deref(vm, a), pgm_deref(vm, b), size);
    } else {
      CODE_COVERAGE_UNTESTED(480); // Not hit
      return memcmp(vm_deref(vm, a), vm_deref(vm, a), size);
    }
  }
}

static MVM_PROGMEM_P pgm_deref(VM* vm, Pointer vp) {
  VM_ASSERT(vm, VM_IS_PGM_P(vp));
  return MVM_PROGMEM_P_ADD(vm->pBytecode, VM_VALUE_OF(vp));
}

/** Size of string excluding bonus null terminator */
static uint16_t vm_stringSizeUtf8(VM* vm, Value stringValue) {
  CODE_COVERAGE(53); // Hit
  vm_HeaderWord headerWord = vm_readHeaderWord(vm, stringValue);
  TeTypeCode typeCode = vm_getTypeCodeFromHeaderWord(headerWord);
  if (typeCode == TC_VAL_STR_PROTO) return 9;
  if (typeCode == TC_VAL_STR_LENGTH) return 6;
  VM_ASSERT(vm, (typeCode == TC_REF_STRING) || (typeCode == TC_REF_UNIQUE_STRING));
  return vm_getAllocationSizeExcludingHeaderFromHeaderWord(headerWord) - 1;
}

/**
 * Checks if a string contains only decimal digits (and is not empty). May only
 * be called on TC_REF_STRING and only those in GC memory.
 */
static bool vm_stringIsNonNegativeInteger(VM* vm, Value str) {
  CODE_COVERAGE_UNTESTED(55); // Not hit
  VM_ASSERT(vm, deepTypeOf(vm, str) == TC_REF_STRING);
  VM_ASSERT(vm, VM_IS_GC_P(str));

  char* data = gc_deref(vm, str);
  // Length excluding bonus null terminator
  uint16_t len = (((uint16_t*)data)[-1] & 0xFFF) - 1;
  if (!len) return false;
  while (len--) {
    CODE_COVERAGE_UNTESTED(398); // Not hit
    if (!isdigit(*data++)) {
      CODE_COVERAGE_UNTESTED(399); // Not hit
      return false;
    } else {
      CODE_COVERAGE_UNTESTED(400); // Not hit
    }
  }
  return true;
}

TeError toInt32Internal(mvm_VM* vm, mvm_Value value, int32_t* out_result) {
  CODE_COVERAGE(56); // Hit
  // TODO: when the type codes are more stable, we should convert these to a table.
  *out_result = 0;
  TeTypeCode type = deepTypeOf(vm, value);
  MVM_SWITCH_CONTIGUOUS(type, TC_END - 1) {
    MVM_CASE_CONTIGUOUS(TC_VAL_INT14):
    MVM_CASE_CONTIGUOUS(TC_REF_INT32): {
      CODE_COVERAGE(401); // Hit
      *out_result = vm_readInt32(vm, type, value);
      return MVM_E_SUCCESS;
    }
    MVM_CASE_CONTIGUOUS(TC_REF_FLOAT64): {
      CODE_COVERAGE(402); // Hit
      return MVM_E_FLOAT64;
    }
    MVM_CASE_CONTIGUOUS(TC_REF_STRING): {
      CODE_COVERAGE_UNIMPLEMENTED(403); // Not hit
      VM_NOT_IMPLEMENTED(vm); break;
    }
    MVM_CASE_CONTIGUOUS(TC_REF_UNIQUE_STRING): {
      CODE_COVERAGE_UNIMPLEMENTED(404); // Not hit
      VM_NOT_IMPLEMENTED(vm); break;
    }
    MVM_CASE_CONTIGUOUS(TC_VAL_STR_LENGTH): {
      CODE_COVERAGE_UNIMPLEMENTED(270); // Not hit
      VM_NOT_IMPLEMENTED(vm); break;
    }
    MVM_CASE_CONTIGUOUS(TC_VAL_STR_PROTO): {
      CODE_COVERAGE_UNIMPLEMENTED(271); // Not hit
      VM_NOT_IMPLEMENTED(vm); break;
    }
    MVM_CASE_CONTIGUOUS(TC_REF_PROPERTY_LIST): {
      CODE_COVERAGE(405); // Hit
      return MVM_E_NAN;
    }
    MVM_CASE_CONTIGUOUS(TC_REF_ARRAY): {
      CODE_COVERAGE_UNTESTED(406); // Not hit
      return MVM_E_NAN;
    }
    MVM_CASE_CONTIGUOUS(TC_REF_FUNCTION): {
      CODE_COVERAGE_UNTESTED(408); // Not hit
      return MVM_E_NAN;
    }
    MVM_CASE_CONTIGUOUS(TC_REF_HOST_FUNC): {
      CODE_COVERAGE_UNTESTED(409); // Not hit
      return MVM_E_NAN;
    }
    MVM_CASE_CONTIGUOUS(TC_REF_STRUCT): {
      CODE_COVERAGE_UNTESTED(410); // Not hit
      return MVM_E_NAN;
    }
    MVM_CASE_CONTIGUOUS(TC_REF_BIG_INT): {
      CODE_COVERAGE_UNTESTED(411); // Not hit
      VM_RESERVED(vm); break;
    }
    MVM_CASE_CONTIGUOUS(TC_REF_SYMBOL): {
      CODE_COVERAGE_UNTESTED(412); // Not hit
      return MVM_E_NAN;
    }
    MVM_CASE_CONTIGUOUS(TC_VAL_UNDEFINED): {
      CODE_COVERAGE(413); // Hit
      return MVM_E_NAN;
    }
    MVM_CASE_CONTIGUOUS(TC_VAL_NULL): {
      CODE_COVERAGE(414); // Hit
      break;
    }
    MVM_CASE_CONTIGUOUS(TC_VAL_TRUE): {
      CODE_COVERAGE_UNTESTED(415); // Not hit
      *out_result = 1; break;
    }
    MVM_CASE_CONTIGUOUS(TC_VAL_FALSE): {
      CODE_COVERAGE_UNTESTED(416); // Not hit
      break;
    }
    MVM_CASE_CONTIGUOUS(TC_VAL_NAN): {
      CODE_COVERAGE(417); // Hit
      return MVM_E_NAN;
    }
    MVM_CASE_CONTIGUOUS(TC_VAL_NEG_ZERO): {
      CODE_COVERAGE(418); // Hit
      return MVM_E_NEG_ZERO;
    }
    MVM_CASE_CONTIGUOUS(TC_VAL_DELETED): {
      CODE_COVERAGE_UNTESTED(419); // Not hit
      return MVM_E_NAN;
    }
  }
  return MVM_E_SUCCESS;
}

int32_t mvm_toInt32(mvm_VM* vm, mvm_Value value) {
  CODE_COVERAGE(57); // Hit
  int32_t result;
  TeError err = toInt32Internal(vm, value, &result);
  if (err == MVM_E_SUCCESS) {
    CODE_COVERAGE(420); // Hit
    return result;
  } else if (err == MVM_E_NAN) {
    CODE_COVERAGE_UNTESTED(421); // Not hit
    return 0;
  } else if (err == MVM_E_NEG_ZERO) {
    CODE_COVERAGE_UNTESTED(422); // Not hit
    return 0;
  } else {
    CODE_COVERAGE_UNTESTED(423); // Not hit
  }

  VM_ASSERT(vm, deepTypeOf(vm, value) == TC_REF_FLOAT64);
  #if MVM_SUPPORT_FLOAT
    MVM_FLOAT64 f;
    vm_readMem(vm, &f, value, sizeof f);
    return (int32_t)f;
  #else // !MVM_SUPPORT_FLOAT
    // If things were compiled correctly, there shouldn't be any floats in the
    // system at all
    return 0;
  #endif
}

#if MVM_SUPPORT_FLOAT
MVM_FLOAT64 mvm_toFloat64(mvm_VM* vm, mvm_Value value) {
  CODE_COVERAGE(58); // Hit
  int32_t result;
  TeError err = toInt32Internal(vm, value, &result);
  if (err == MVM_E_SUCCESS) {
    CODE_COVERAGE(424); // Hit
    return result;
  } else if (err == MVM_E_NAN) {
    CODE_COVERAGE(425); // Hit
    return MVM_FLOAT64_NAN;
  } else if (err == MVM_E_NEG_ZERO) {
    CODE_COVERAGE(426); // Hit
    return -0.0;
  } else {
    CODE_COVERAGE(427); // Hit
  }

  VM_ASSERT(vm, deepTypeOf(vm, value) == TC_REF_FLOAT64);
  MVM_FLOAT64 f;
  vm_readMem(vm, &f, value, sizeof f);
  return f;
}
#endif // MVM_SUPPORT_FLOAT

bool mvm_equal(mvm_VM* vm, mvm_Value a, mvm_Value b) {
  CODE_COVERAGE(462); // Hit

  // TODO: Negative zero equality

  if (a == VM_VALUE_NAN) {
    CODE_COVERAGE(16); // Hit
    return false;
  }

  if (a == b) {
    CODE_COVERAGE_UNTESTED(463); // Not hit
    return true;
  }

  TeTypeCode aType = deepTypeOf(vm, a);
  TeTypeCode bType = deepTypeOf(vm, b);
  if (aType != bType) {
    CODE_COVERAGE(464); // Hit
    return false;
  }

  TABLE_COVERAGE(aType, TC_END, 465); // Not hit

  // Some types compare with value equality, so we do memory equality check
  if ((aType == TC_REF_INT32) || (aType == TC_REF_FLOAT64) || (aType == TC_REF_BIG_INT)) {
    CODE_COVERAGE_UNTESTED(475); // Not hit
    vm_HeaderWord aHeaderWord = vm_readHeaderWord(vm, a);
    vm_HeaderWord bHeaderWord = vm_readHeaderWord(vm, b);
    // If the header words are different, the sizes are different
    if (aHeaderWord != bHeaderWord) {
      CODE_COVERAGE_UNTESTED(476); // Not hit
      return false;
    }
    CODE_COVERAGE_UNTESTED(477); // Not hit
    uint16_t size = vm_getAllocationSizeExcludingHeaderFromHeaderWord(aHeaderWord);
    if (vm_memcmp(vm, a, b, size) == 0) {
      CODE_COVERAGE_UNTESTED(481); // Not hit
      return true;
    } else {
      CODE_COVERAGE_UNTESTED(482); // Not hit
      return false;
    }
  } else {
    // All other types compare with reference equality, which we've already checked
    return false;
  }
}

bool mvm_isNaN(mvm_Value value) {
  return value == VM_VALUE_NAN;
}

static void sanitizeArgs(VM* vm, Value* args, uint8_t argCount) {
  /*
  It's important that we don't leak object pointers into the host because static
  analysis optimization passes need to be able to perform unambiguous alias
  analysis, and we don't yet have a standard ABI for allowing the host to
  interact with objects in a way that works with these kinds of optimizers
  (maybe in future).
  */
  Value* arg = args;
  while (argCount--) {
    VM_ASSERT(vm, *arg != VM_VALUE_DELETED);
    mvm_TeType type = mvm_typeOf(vm, *arg);
    if (
      (type == VM_T_FUNCTION) ||
      (type == VM_T_OBJECT) ||
      (type == VM_T_ARRAY)
    ) {
      *arg = VM_VALUE_UNDEFINED;
    }
    arg++;
  }
}

#if MVM_GENERATE_SNAPSHOT_CAPABILITY
void* mvm_createSnapshot(mvm_VM* vm, size_t* out_size) {
  CODE_COVERAGE(503); // Hit
  *out_size = 0;
  /*
  This function works by just adjusting the original bytecode file, replacing
  the heap and updating the globals.
  */
  uint16_t originalBytecodeSize = VM_READ_BC_2_HEADER_FIELD(bytecodeSize, vm->pBytecode);
  uint16_t originalHeapSize = VM_READ_BC_2_HEADER_FIELD(initialHeapSize, vm->pBytecode);
  uint16_t dataSize = VM_READ_BC_2_HEADER_FIELD(initialDataSize, vm->pBytecode);
  uint16_t heapSize = vm->vpAllocationCursor - vpGCSpaceStart;
  uint32_t bytecodeSize = originalBytecodeSize - originalHeapSize + heapSize;
  if (bytecodeSize > 0xFFFF) {
    MVM_FATAL_ERROR(vm, MVM_E_SNAPSHOT_TOO_LARGE);
  }

  mvm_TsBytecodeHeader* result = malloc(bytecodeSize);
  // The first part of the snapshot doesn't change between executions (except
  // some header fields, which we'll update later).
  uint16_t sizeOfConstantPart = bytecodeSize - heapSize - dataSize;
  VM_READ_BC_N_AT(result, 0, sizeOfConstantPart, vm->pBytecode);

  // Snapshot data memory
  memcpy((uint8_t*)result + result->initialDataOffset, vm->dataMemory, dataSize);

  // Snapshot heap memory

  vm_TsBucket* bucket = vm->pLastBucket;
  // Start at the end of the heap and work backwards, because buckets are linked in reverse order
  uint8_t* pTarget = (uint8_t*)result + result->initialHeapOffset + heapSize;
  Pointer cursor = vm->vpAllocationCursor;
  while (bucket) {
    CODE_COVERAGE(504); // Hit
    uint16_t bucketSize = cursor - bucket->vpAddressStart;
    uint8_t* bucketData = (uint8_t*)(bucket + 1);

    pTarget -= bucketSize;
    memcpy(pTarget, bucketData, bucketSize);

    cursor -= bucketSize;
    bucket = bucket->prev;
  }

  // Update header fields
  result->initialHeapSize = heapSize;
  result->bytecodeSize = bytecodeSize;
  result->arrayProtoPointer = vm->arrayProto;
  result->crc = MVM_CALC_CRC16_CCITT(((void*)&result->requiredEngineVersion), ((uint16_t)bytecodeSize - 6));

  *out_size = bytecodeSize;
  return (void*)result;
}
#endif // MVM_GENERATE_SNAPSHOT_CAPABILITY
