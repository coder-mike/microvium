#pragma once

#include "stdbool.h"
#include "stdint.h"
#include "assert.h"
#include "string.h"
#include "stdlib.h"
#include "setjmp.h"

#include "microvium.h"
#include "microvium_port.h"
#include "microvium_bytecode.h"
#include "microvium_opcodes.h"

typedef mvm_VM VM;
typedef mvm_TeError TeError;

/**
 * Internally, the name `Value` refers to `mvm_Value`
 *
 * The Microvium Value type is 16 bits with a 1 or 2 bit discriminator in the
 * lowest bits:
 *
 *  - If the lowest bit is `0`, interpret the value as a `ShortPtr`.
 *  - If the lowest bits are `11`, interpret the high 14-bits as a signed 14 bit
 *    integer.
 *  - If the lowest bits are `01`, interpret the high 15-bits as a
 *    `BytecodeMappedPtr` or a well-known value. WIP change the well-known
 *    values to have these bits.
 */
typedef mvm_Value Value;

inline bool Value_isShortPtr(Value value) { return (value & 1) == 0; }
inline bool Value_isBytecodeMappedPtr(Value value) { return (value & 3) == 1; }
inline bool Value_isInt14(Value value) { return (value & 3) == 3; }

/**
 * A ShortPtr is a 16-bit value which can refer to GC memory, but not to data
 * memory or bytecode.
 *
 * Note: Pointers _to_ GC must always be encoded as `ShortPtr` (never
 * `BytecodeMappedPtr`). Conversely, pointers to data memory must never be
 * encoded as `ShortPtr`. This is to improve efficiency of the GC, since it can
 * assume that only values with the lower bit `0` need to be traced/moved.
 *
 * On 16-bit architectures, ShortPtr can be a native pointer, allowing for fast
 * access. On other architectures, ShortPtr is encoded as a `BytecodeMappedPtr`.
 *
 * If the lowest bit of the `ShortPtr` is 0 (i.e. points to an even boundary),
 * then the `ShortPtr` is also a valid `Value`.
 *
 * NULL short pointers are only allowed in some special circumstances, but are
 * mostly not valid.
 */
#if MVM_NATIVE_POINTER_IS_16_BIT
  typedef void* ShortPtr;
#else
  typedef uint16_t ShortPtr;
#endif

/**
 * A `BytecodeMappedPtr` is a 16-bit reference to something in ROM or RAM.
 *
 * It is treated as an offset into the bytecode image. If the offset points to
 * the _data_ region of the bytecode image, the `BytecodeMappedPtr` is treated
 * as a reference to the corresponding RAM data. If the offset points passed the
 * beginning of the heap section of the bytecode, it is treated as a pointer to
 * the corresponding region of GC memory. Otherwise it is treated as a pointer
 * to the corresponding ROM data in bytecode.
 *
 * A `BytecodeMappedPtr` is a pointer type and is not defined to encode the
 * well-known values.
 */
typedef uint16_t BytecodeMappedPtr;

/**
 * A `Value` that is a pointer. I.e. its lowest bits are not `11` and it does
 * not encode a well-known value.
 */
typedef uint16_t DynamicPtr;

/**
 * A pointer that can reference bytecode and RAM in the same address space. Not
 * necessarily 16-bit.
 *
 * Values of this type are only managed through macros in the port file, never
 * directly, since the exact type depends on the architecture.
 *
 * See description of MVM_LONG_PTR_TYPE
 */
typedef MVM_LONG_PTR_TYPE LongPtr;

inline LongPtr LongPtr_new(void* p) {
  return MVM_LONG_PTR_NEW(p);
}

#define READ_FIELD_2(longPtr, structType, fieldName) \
  LongPtr_read2(LongPtr_add(longPtr, OFFSETOF(structType, fieldName)))

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

#define VM_TAG_MASK               0xC000 // The tag is the top 2 bits
#define VM_VALUE_MASK             0x3FFF // The value is the remaining 14 bits
#define VM_VALUE_SIGN_BIT         0x2000 // Sign bit used for signed numbers

#define VM_VALUE_UNSIGNED         0x0000
#define VM_VALUE_SIGNED           0x2000
#define VM_SIGN_EXTENTION         0xC000
#define VM_OVERFLOW_BIT           0x4000

// TODO(low): I think these should be inline functions rather than macros
// WIP deprecated
#define VM_VALUE_OF(v) ((v) & VM_VALUE_MASK)
// WIP deprecated
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
  // allocations, since the allocation header allows 4 bits for the type. Types
  // 0-8 are non-container types, 0xC-F are container types (9-B reserved).
  // Every word in a container must be a `Value`. No words in a non-container
  // can be a `Value` (the GC uses this to distinguish whether an allocation may
  // contain pointers, and the signature of each word). Note that buffer-like
  // types would not count as containers by this definition.

  /* --------------------------- Reference types --------------------------- */

  // WIP The snapshot encoder needs to be updated to use the new type
  // definitions

  // A type used during garbage collection. Allocations of this type have a
  // single 16-bit forwarding pointer in the allocation.
  TC_REF_TOMBSTONE      = 0x0,

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

  TC_REF_FUNCTION       = 0x5, // Local function
  TC_REF_HOST_FUNC      = 0x6, // External function by index in import table


  TC_REF_BIG_INT        = 0x7, // Reserved
  TC_REF_SYMBOL         = 0x8, // Reserved

  TC_REF_DIVIDER_CONTAINER_TYPES, // <--- Marker. Types after or including this point but less than 0x10 are container types

  TC_REF_RESERVED_1     = 0x9, // Reserved
  TC_REF_RESERVED_2     = 0xA, // Reserved
  TC_REF_RESERVED_3     = 0xB, // Reserved

  TC_REF_PROPERTY_LIST  = 0xC, // TsPropertyList - Object represented as linked list of properties
  TC_REF_ARRAY          = 0xD, // TsArray
  TC_REF_RESERVED_0     = 0xE, // Reserved for some kind of sparse or fixed-length array in future if needed
  // Structs are objects with a fixed set of fields, and the field keys are
  // stored separately to the field values. Structs have a 4-byte header, which
  // consists of the normal 2-byte header, preceded by a 2-byte pointer to the
  // struct metadata. The metadata lists the keys, while the struct allocation
  // lists the values. The first value is at the pointer target.
  TC_REF_STRUCT         = 0xF,

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

// WIP deprecated
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

// WIP deprecated
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
 * Unfortunately, Microvium is designed to run in environments where bytecode is
 * stored non-locally, such as arduino where flash memory is a completely
 * separate address space. So, it is not assumed that there is a native pointer
 * that can homogenously refer to any memory address. Instead, we use the same
 * format as the mvm_Value, with a 2-bit tag indicating what kind of pointer it
 * is. Access to these pointers needs to be done indirectly, such as through
 * `vm_readUInt16` and similar methods;
 */
typedef mvm_Value Pointer; // WIP deprecated

typedef struct TsArray {
  ShortPtr pData2;
  uint16_t length;
  uint16_t capacity;
} TsArray;

typedef uint16_t vm_HeaderWord;
typedef struct vm_TsStack vm_TsStack;

/**
 * Used to represent JavaScript objects.
 *
 * The `proto` pointer points to the prototype of the object.
 *
 * Properties on object are stored in a linked list of groups. Each group has a
 * `next` pointer to the next group. When assinging to a new property, rather
 * than resizing a group, the VM will just append a new group to the list (a
 * group with just the one new property).
 *
 * Only the `proto` field of the first group of properties in an object is used.
 *
 * The garbage collector compacts multiple groups into one large one, so it
 * doesn't matter that appending a single property requires a whole new set
 * group on its own or that they have unused proto properties.
 *
 */
// WIP this structure has changed -- update dependencies
typedef struct TsPropertyList2 {
  DynamicPtr next; // TsPropertyList or 0, containing further appended properties
  Value proto; // Note: the protype is only meaningful on the first in the list
  /*
  Followed by N of these pairs to fill up the allocation size:
    Value key; // TC_VAL_INT14 or TC_REF_UNIQUE_STRING
    Value value;
   */
} TsPropertyList2;

typedef struct vm_TsBucket { // WIP Deprecated
  Pointer vpAddressStart;
  struct vm_TsBucket* prev;
} vm_TsBucket;

typedef struct vm_TsBucket2 {
  uint16_t offsetStart; // The number of bytes in the heap before this bucket
  struct vm_TsBucket2* prev;
  /* ...data */
} vm_TsBucket2;

struct mvm_VM {
  uint16_t* dataMemory;
  LongPtr pBytecode;

  // Start of the last bucket of GC memory
  vm_TsBucket* pLastBucket; // WIP deprecated
  vm_TsBucket2* pLastBucket2;
  // End of the last bucket of GC memory
  Pointer vpBucketEnd; // WIP deprecated
  uint8_t* pLastBucketEnd2;
  // Where to allocate next GC allocation
  Pointer vpAllocationCursor; // WIP deprecated
  uint8_t* pAllocationCursor; // WIP deprecated
  void* pAllocationCursor2;
  // Handles - values to treat as GC roots
  mvm_Handle* gc_handles;
  uint16_t heapSizeUsedAfterLastGC;

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

typedef struct gc2_TsGCCollectionState {
  VM* vm;
  uint16_t* writePtr;
  vm_TsBucket2* firstBucket;
  vm_TsBucket2* lastBucket;
  uint16_t* lastBucketEnd;
  uint16_t lastBucketOffsetStart;
} gc2_TsGCCollectionState;

#define TOMBSTONE_HEADER ((TC_REF_TOMBSTONE << 12) | 2)
