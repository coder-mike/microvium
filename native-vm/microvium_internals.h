#pragma once
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

#define VM_BYTECODE_VERSION 1

#if VM_SAFE_MODE
#define VM_ASSERT(vm, predicate) do { if (!(predicate)) VM_FATAL_ERROR(vm, VM_E_ASSERTION_FAILED); } while (false)
#else
#define VM_ASSERT(vm, predicate)
#endif

// Offset of field in a struct
#define OFFSETOF(TYPE, ELEMENT) ((size_t)&(((TYPE *)0)->ELEMENT))

#define VM_ALLOCATION_BUCKET_SIZE 256
#define VM_GC_ALLOCATION_UNIT     2    // Don't change
#define VM_GC_MIN_ALLOCATION_SIZE (VM_GC_ALLOCATION_UNIT * 2)
// TODO(high): I'm fairly sure the snapshot output doesn't offset the addresses
// Note: this cannot be changed, because the initial data section is allowed to
// hold references into the heap, and it needs have the correct offset.
#define VM_ADDRESS_SPACE_START    0x10   // Offset so that pointers around null are recognizable (should be small)

#define VM_TAG_MASK               0xC000 // The tag is the top 2 bits
#define VM_VALUE_MASK             0x3FFF // The value is the remaining 14 bits
#define VM_VALUE_SIGN_BIT         0x2000 // Sign bit used for signed numbers

#define VM_VALUE_UNSIGNED         0x0000
#define VM_VALUE_SIGNED           0x2000
#define VM_SIGN_EXTENTION         0xC000
#define VM_OVERFLOW_BIT           0x4000

// TODO(low): I think these should be inline functions rather than macros
#define VM_VALUE_OF(v) ((v) & VM_VALUE_MASK)
#define VM_TAG_OF(v) ((v) & VM_TAG_MASK)
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

#define VM_NOT_IMPLEMENTED(vm) (VM_FATAL_ERROR(vm, VM_E_NOT_IMPLEMENTED), -1)

// An error corresponding to an internal inconsistency in the VM. Such an error
// cannot be caused by incorrect usage of the VM. In safe mode, this function
// should terminate the application. If not in safe mode, it is assumed that
// this function will never be invoked.
#define VM_UNEXPECTED_INTERNAL_ERROR(vm) (VM_FATAL_ERROR(vm, VM_E_UNEXPECTED), -1)

#define VM_VALUE_OF_DYNAMIC(v) ((void*)((vm_TsDynamicHeader*)v + 1))
#define VM_DYNAMIC_TYPE(v) (((vm_TsDynamicHeader*)v)->type)

#define VM_MAX_INT14 0x1FFF
#define VM_MIN_INT14 (-0x2000)

#if VM_SAFE_MODE
#define VM_EXEC_SAFE_MODE(code) code
#define VM_SAFE_CHECK_NOT_NULL(v) do { if ((v) == NULL) return VM_E_UNEXPECTED; } while (false)
#else
#define VM_EXEC_SAFE_MODE(code)
#define VM_SAFE_CHECK_NOT_NULL(v)
#endif


#define VM_READ_BC_AT(pTarget, offset, size, pBytecode) \
  VM_READ_PROGMEM(pTarget, VM_PROGMEM_P_ADD((pBytecode), offset), size);
#define VM_READ_BC_FIELD(pTarget, fieldName, structOffset, structType, pBytecode) \
  VM_READ_BC_AT(pTarget, structOffset + OFFSETOF(structType, fieldName), sizeof (*pTarget), pBytecode);
#define VM_READ_BC_HEADER_FIELD(pTarget, fieldName, pBytecode) \
  VM_READ_BC_FIELD(pTarget, fieldName, 0, vm_TsBytecodeHeader, pBytecode);

#define VM_BOTTOM_OF_STACK(vm) ((uint16_t*)(vm->stack + 1))
#define VM_TOP_OF_STACK(vm) (VM_BOTTOM_OF_STACK(vm) + VM_STACK_SIZE / 2)
#define VM_IS_UNSIGNED(v) ((v & VM_VALUE_SIGN_BIT) == VM_VALUE_UNSIGNED)
#define VM_SIGN_EXTEND(v) (VM_IS_UNSIGNED(v) ? v : (v | VM_SIGN_EXTENTION))

typedef struct vm_TsBytecodeHeader {
  uint8_t bytecodeVersion; // VM_BYTECODE_VERSION
  uint8_t headerSize;
  uint16_t bytecodeSize;
  uint16_t crc; // CCITT16 (header and data, of everything after the CRC)
  uint16_t requiredEngineVersion;
  uint32_t requiredFeatureFlags;
  uint16_t globalVariableCount;
  uint16_t dataMemorySize; // Includes global variables // TODO(low): I don't think this is useful.
  uint16_t initialDataOffset;
  uint16_t initialDataSize; // Data memory that is not covered by the initial data is zero-filled
  uint16_t initialHeapOffset;
  uint16_t initialHeapSize;
  uint16_t gcRootsOffset; // Points to a table of pointers to GC roots in data memory (to use in addition to the global variables as roots)
  uint16_t gcRootsCount;
  uint16_t importTableOffset; // vm_TsImportTableEntry
  uint16_t importTableSize;
  uint16_t exportTableOffset; // vm_TsExportTableEntry
  uint16_t exportTableSize;
  uint16_t shortCallTableOffset; // vm_TsShortCallTableEntry
  uint16_t shortCallTableSize;
  uint16_t stringTableOffset; // Alphabetical index of UNIQUED_STRING values
  uint16_t stringTableSize;
} vm_TsBytecodeHeader;

typedef enum vm_TeTypeCode {
  // Note: only type code values in the range 0-15 can be used as the types for
  // allocations, since the allocation header allows 4 bits for the type
  VM_TC_BOXED          = 0x0, // Value type boxed in an allocation
  VM_TC_VIRTUAL        = 0x1, // Allocation with VTable reference

  VM_TC_INT32          = 0x2,
  VM_TC_DOUBLE         = 0x3,
  VM_TC_STRING         = 0x4, // UTF8-encoded string
  VM_TC_UNIQUED_STRING = 0x5, // A string whose address uniquely identifies its contents
  VM_TC_PROPERTY_LIST  = 0x6, // Object represented as linked list of properties
  VM_TC_LIST           = 0x7, // Array represented as linked list
  VM_TC_ARRAY          = 0x8, // Array represented as contiguous block of memory
  VM_TC_FUNCTION       = 0x9, // Local function
  VM_TC_HOST_FUNC      = 0xA, // External function by index in import table
  VM_TC_BIG_INT        = 0xB, // Reserved
  VM_TC_SYMBOL         = 0xC, // Reserved

  // Well-known values
  VM_TC_UNDEFINED     = 0x10,
  VM_TC_NULL          = 0x11,
  VM_TC_TRUE          = 0x12,
  VM_TC_FALSE         = 0x13,
  VM_TC_EMPTY_STRING  = 0x14,
  VM_TC_NAN           = 0x15,
  VM_TC_INF           = 0x16,
  VM_TC_NEG_INF       = 0x17,
  VM_TC_NEG_ZERO      = 0x18,
  VM_TC_DELETED       = 0x19, // Placeholder for properties and list items that have been deleted

  // Value types
  VM_TC_INT14         = 0x20,
  VM_TC_POINTER       = 0x21,

  // Virtual types
  VM_TC_STRUCT        = 0x31,
} vm_TeTypeCode;

// Tag values
typedef enum vm_TeValueTag {
  VM_TAG_INT    = 0x0000,
  VM_TAG_GC_P   = 0x4000,
  VM_TAG_DATA_P = 0x8000,
  VM_TAG_PGM_P  = 0xC000,
} vm_TeValueTag;

// Note: VM_VALUE_NAN must be used instead of a pointer to a double that has a
// NaN value (i.e. the values must be normalized to use the following table).
// Operations will assume this canonical form.

// Some well-known values
typedef enum vm_TeWellKnownValues {
  VM_VALUE_UNDEFINED     = (VM_TAG_PGM_P | VM_TC_UNDEFINED),
  VM_VALUE_NULL          = (VM_TAG_PGM_P | VM_TC_NULL),
  VM_VALUE_TRUE          = (VM_TAG_PGM_P | VM_TC_TRUE),
  VM_VALUE_FALSE         = (VM_TAG_PGM_P | VM_TC_FALSE),
  VM_VALUE_EMPTY_STRING  = (VM_TAG_PGM_P | VM_TC_EMPTY_STRING),
  VM_VALUE_NAN           = (VM_TAG_PGM_P | VM_TC_NAN),
  VM_VALUE_INF           = (VM_TAG_PGM_P | VM_TC_INF),
  VM_VALUE_NEG_INF       = (VM_TAG_PGM_P | VM_TC_NEG_INF),
  VM_VALUE_NEG_ZERO      = (VM_TAG_PGM_P | VM_TC_NEG_ZERO),
  VM_VALUE_DELETED       = (VM_TAG_PGM_P | VM_TC_DELETED),
  VM_VALUE_MAX_WELLKNOWN,
} vm_TeWellKnownValues;

// Note: These offsets don't include the tag
typedef uint16_t GO_t; // Offset into garbage collected (managed heap) space
typedef uint16_t DO_t; // Offset into data memory space
typedef uint16_t BO_t; // Offset into bytecode (pgm) memory space

// Pointer into one of the memory spaces, including the corresponding tag
typedef vm_Value vm_Pointer;
typedef uint16_t vm_HeaderWord;
typedef struct vm_TsStack vm_TsStack;

// 4-bit enum
typedef enum vm_TeOpcode {
  VM_OP_LOAD_SMALL_LITERAL  = 0x0, // (+ 4-bit vm_TeSmallLiteralValue)

  VM_OP_LOAD_VAR_1          = 0x1, // (+ 4-bit variable index relative to stack pointer)
  VM_OP_STORE_VAR_1         = 0x2, // (+ 4-bit variable index relative to stack pointer)

  VM_OP_LOAD_GLOBAL_1       = 0x3, // (+ 4-bit global variable index)
  VM_OP_STORE_GLOBAL_1      = 0x4, // (+ 4-bit global variable index)

  VM_OP_LOAD_ARG_1          = 0x5, // (+ 4-bit arg index)

  VM_OP_POP                 = 0x6, // (+ 4-bit arg count of things to pop)
  VM_OP_CALL_1              = 0x7, // (+ 4-bit index into short-call table)

  VM_OP_STRUCT_GET_1        = 0x8, // (+ 4-bit field index)
  VM_OP_STRUCT_SET_1        = 0x9, // (+ 4-bit field index)

  VM_OP_BINOP_1             = 0xA, // (+ 4-bit vm_TeBinOp1)
  VM_OP_BINOP_2             = 0xB, // (+ 4-bit vm_TeBinOp2)
  VM_OP_UNOP                = 0xC, // (+ 4-bit vm_TeUnOp)

  VM_OP_EXTENDED_1          = 0xD, // (+ 4-bit vm_TeOpcodeEx1)
  VM_OP_EXTENDED_2          = 0xE, // (+ 4-bit vm_TeOpcodeEx2)
  VM_OP_EXTENDED_3          = 0xF, // (+ 4-bit vm_TeOpcodeEx3)
} vm_TeOpcode;

#define VM_RETURN_FLAG_POP_FUNCTION (1 << 0)
#define VM_RETURN_FLAG_UNDEFINED    (1 << 1)

// 4-bit enum
typedef enum vm_TeOpcodeEx1 {
  VM_OP1_RETURN_1            = 0x0,
  VM_OP1_RETURN_2            = 0x0 | VM_RETURN_FLAG_POP_FUNCTION,
  VM_OP1_RETURN_3            = 0x0 | VM_RETURN_FLAG_UNDEFINED,
  VM_OP1_RETURN_4            = 0x0 | VM_RETURN_FLAG_POP_FUNCTION | VM_RETURN_FLAG_UNDEFINED,
  VM_OP1_OBJECT_GET_1        = 0x4, // (field ID is dynamic)
  VM_OP1_OBJECT_SET_1        = 0x5, // (field ID is dynamic)
  VM_OP1_ASSERT              = 0x6,
  VM_OP1_NOT_IMPLEMENTED     = 0x7,
  VM_OP1_ILLEGAL_OPERATION   = 0x8,
  VM_OP1_PRINT               = 0x9, // For development purposes
  VM_OP1_ARRAY_GET           = 0xA,
  VM_OP1_ARRAY_SET           = 0xB,
  VM_OP1_EXTENDED_4          = 0xC, // (+ 8-bit vm_TeOpcodeEx4)
} vm_TeOpcodeEx1;

// 4-bit enum
typedef enum vm_TeOpcodeEx2 {
  VM_OP2_BRANCH_1            = 0x0, // (+ 8-bit signed offset)
  VM_OP2_JUMP_1              = 0x1, // (+ 8-bit signed offset)
  VM_OP2_CALL_HOST           = 0x2, // (+ 8-bit index into resolvedImports + 8-bit arg count)
  VM_OP2_LOAD_GLOBAL_2       = 0x3, // (+ 8-bit global variable index)
  VM_OP2_STORE_GLOBAL_2      = 0x4, // (+ 8-bit global variable index)
  VM_OP2_LOAD_VAR_2          = 0x5, // (+ 8-bit variable index relative to stack pointer)
  VM_OP2_STORE_VAR_2         = 0x6, // (+ 8-bit variable index relative to stack pointer)
  VM_OP2_STRUCT_GET_2        = 0x7, // (+ 8-bit field index)
  VM_OP2_STRUCT_SET_2        = 0x8, // (+ 8-bit field index)
  VM_OP2_LOAD_ARG_2          = 0x9, // (+ 8-bit arg index)
  VM_OP2_STORE_ARG           = 0xA, // (+ 8-bit arg index)
  VM_OP2_CALL_3              = 0xC, // (+ 8-bit arg count. Target is dynamic)
} vm_TeOpcodeEx2;

// 4-bit enum
typedef enum vm_TeOpcodeEx3 {
  VM_OP3_CALL_2              = 0x0, // (+ 16-bit function offset + 8-bit arg count)
  VM_OP3_JUMP_2              = 0x1, // (+ 16-bit signed offset)
  VM_OP3_BRANCH_2            = 0x2, // (+ 16-bit signed offset)
  VM_OP3_LOAD_LITERAL        = 0x3, // (+ 16-bit value)
  VM_OP3_LOAD_GLOBAL_3       = 0x4, // (+ 16-bit global variable index)
  VM_OP3_STORE_GLOBAL_3      = 0x5, // (+ 16-bit global variable index)
  VM_OP3_OBJECT_GET_2        = 0x4, // (+ 16-bit uniqued string reference)
  VM_OP3_OBJECT_SET_2        = 0x5, // (+ 16-bit uniqued string reference)
} vm_TeOpcodeEx3;

// 8-bit enum
typedef enum vm_TeOpcodeEx4 {
  VM_OP4_CALL_DETACHED_EPHEMERAL = 0x0, // (No parameters) Represents the calling of an ephemeral that existed in a previous epoch
} vm_TeOpcodeEx4;

// 4-bit enum
typedef enum vm_TeBinOp1 {
  VM_BOP1_ADD            = 0x0,
  VM_BOP1_SUBTRACT       = 0x1,
  VM_BOP1_MULTIPLY       = 0x2,
  VM_BOP1_DIVIDE_INT     = 0x3,
  VM_BOP1_DIVIDE_FLOAT   = 0x4,
  VM_BOP1_SHR_ARITHMETIC = 0x5,
  VM_BOP1_SHR_BITWISE    = 0x6,
  VM_BOP1_SHL            = 0x7,
  VM_BOP1_REMAINDER      = 0x8,
} vm_TeBinOp1;

// 4-bit enum
typedef enum vm_TeBinOp2 {
  VM_BOP2_LESS_THAN      = 0x0,
  VM_BOP2_GREATER_THAN   = 0x1,
  VM_BOP2_LESS_EQUAL     = 0x2,
  VM_BOP2_GREATER_EQUAL  = 0x3,
  VM_BOP2_EQUAL          = 0x4,
  VM_BOP2_NOT_EQUAL      = 0x5,
  VM_BOP2_AND            = 0x6,
  VM_BOP2_OR             = 0x7,
} vm_TeBinOp2;

// 4-bit enum
typedef enum vm_TeUnOp {
  VM_OP_NEGATE           = 0x0,
  VM_OP_LOGICAL_NOT      = 0x1,
  VM_OP_BITWISE_NOT      = 0x2,
} vm_TeUnOp;

// 4-bit enum
typedef enum vm_TeSmallLiteralValue {
  VM_SLV_NULL            = 0x0,
  VM_SLV_UNDEFINED       = 0x1,
  VM_SLV_FALSE           = 0x2,
  VM_SLV_TRUE            = 0x3,
  VM_SLV_EMPTY_STRING    = 0x4,
  VM_SLV_INT_0           = 0x5,
  VM_SLV_INT_1           = 0x6,
  VM_SLV_INT_2           = 0x7,
  VM_SLV_INT_MINUS_1     = 0x8,
} vm_TeSmallLiteralValue;

// Up to 16 codes
typedef enum vm_TePointerTypeCode {
  VM_PTC_NONE = 0,
  VM_PTC_INT32 = 1,
  VM_PTC_STRING = 2,
  VM_PTC_DYNAMIC = 3,
  VM_PTC_END = 0xF,
} vm_TePointerTypeCode;

typedef struct vm_TsBucket {
  GO_t addressStart;
  struct vm_TsBucket* prev;
} vm_TsBucket;

typedef struct vm_VM {
  void* context;

  VM_PROGMEM_P pBytecode;

  // Start of the last bucket of GC memory
  vm_TsBucket* gc_lastBucket;
  // End of the last bucket of GC memory
  GO_t gc_bucketEnd;
  // Where to allocate next GC allocation
  GO_t gc_allocationCursor;
  uint8_t* pAllocationCursor;
  // Handles - values to treat as GC roots
  vm_Handle* gc_handles;

  vm_TsStack* stack;
  uint16_t* dataMemory;
} vm_VM;

typedef struct vm_TsExportTableEntry {
  vm_VMExportID exportID;
  vm_Value exportValue;
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

typedef struct vm_TsStack {
  // Allocate registers along with the stack, because these are needed at the same time (i.e. while the VM is active)
  vm_TsRegisters reg;
  // ... (stack memory) ...
} vm_TsStack;

typedef struct vm_TsDynamicHeader {
  /* 4 least-significant-bits are the type code (vm_TeTypeCode)
   */
  uint16_t headerData;
} vm_TsDynamicHeader;

typedef struct vm_TsFunctionHeader {
  // Note: The vm_TsFunctionHeader _starts_ at the target of the function
  // pointer, but there may be an additional vm_TsDynamicHeader _preceding_ the
  // pointer target.
  uint8_t maxStackDepth;
} vm_TsFunctionHeader;

typedef struct vm_TsImportTableEntry {
  vm_HostFunctionID hostFunctionID;
} vm_TsImportTableEntry;

