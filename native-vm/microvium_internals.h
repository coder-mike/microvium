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
 * Hungarian prefix: v
 *
 * Internally, the name `Value` refers to `mvm_Value`
 *
 * The Microvium Value type is 16 bits with a 1 or 2 bit discriminator in the
 * lowest bits:
 *
 *  - If the lowest bit is `0`, interpret the value as a `ShortPtr`.
 *  - If the lowest bits are `11`, interpret the high 14-bits as a signed 14 bit
 *    integer. The Value is an `VirtualInt14`
 *  - If the lowest bits are `01`, interpret the high 15-bits as a
 *    `BytecodeMappedPtr` or a well-known value.
 */
typedef mvm_Value Value;

inline bool Value_isShortPtr(Value value) { return (value & 1) == 0; }
inline bool Value_isBytecodeMappedPtr(Value value) { return (value & 3) == 1; }
inline bool Value_isVirtualInt14(Value value) { return (value & 3) == 3; }

/**
 * Hungarian prefix: sp
 *
 * A ShortPtr is a 16-bit **non-nullable** reference which can refer to GC
 * memory, but not to data memory or bytecode.
 *
 * Note: To avoid confusion of when to use different kinds of null values,
 * ShortPtr should be considered non-nullable. When null is required, use
 * VM_VALUE_NULL for consistency, which is not a short pointer.
 *
 * Note: Aty runtime, pointers _to_ GC must always be encoded as `ShortPtr`
 * (never `BytecodeMappedPtr`). Conversely, pointers to data memory must never
 * be encoded as `ShortPtr`. This is to improve efficiency of the GC, since it
 * can assume that only values with the lower bit `0` need to be traced/moved.
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
 * Hungarian prefix: `dp` (because BytecodeMappedPtr is generally used as a
 * DynamicPtr)
 *
 * A `BytecodeMappedPtr` is a 16-bit reference to something in ROM or RAM.
 *
 * It is interpreted as an offset into the bytecode image. If the offset points
 * to the BCS_HANDLES region of the bytecode image, the `BytecodeMappedPtr` is
 * treated as a reference to the corresponding allocation in GC memory
 * (referenced by the handle). If the offset points to the BCS_ROM section of
 * bytecode, it is interpreted as pointing to that ROM allocation or function.
 *
 * A `BytecodeMappedPtr` is only a pointer type and is not defined to encode the
 * well-known values or null.
 */
typedef uint16_t BytecodeMappedPtr;

/**
 * Hungarian prefix: `dp`
 *
 * A `Value` that is a pointer. I.e. its lowest bits are not `11` and it does
 * not encode a well-known value. Can be one of:
 *
 *  - `ShortPtr`
 *  - `BytecodeMappedPtr`
 *  - `VM_VALUE_NULL`
 *
 * Note that the only valid representation of null for this point is
 * `VM_VALUE_NULL`, not 0.
 */
typedef Value DynamicPtr;

/**
 * Hungarian prefix: none
 *
 * A `DynamicPtr` which is known to only point to ROM
 */
typedef Value RomPtr;

/**
 * Hungarian prefix: `vi`
 *
 * A 14-bit signed integer represented in the high 14 bits of a 16-bit Value,
 * with the low 2 bits set to the bits `11`, as per the `Value` type.
 */
typedef Value VirtualInt14;

/**
 * Hungarian prefix: `lp`
 *
 * A nullable-pointer that can reference bytecode and RAM in the same address
 * space. Not necessarily 16-bit.
 *
 * The null representation for LongPtr is assumed to be 0.
 *
 * Values of this type are only managed through macros in the port file, never
 * directly, since the exact type depends on the architecture.
 *
 * See description of MVM_LONG_PTR_TYPE
 */
typedef MVM_LONG_PTR_TYPE LongPtr;

#define READ_FIELD_2(longPtr, structType, fieldName) \
  LongPtr_read2(LongPtr_add(longPtr, OFFSETOF(structType, fieldName)))

#define READ_FIELD_1(longPtr, structType, fieldName) \
  LongPtr_read1(LongPtr_add(longPtr, OFFSETOF(structType, fieldName)))

// NOTE: In no way are assertions meant to be present in production. They're
// littered everwhere on the assumption that they consume no overhead.
#if MVM_SAFE_MODE
  #define VM_ASSERT(vm, predicate) do { if (!(predicate)) MVM_FATAL_ERROR(vm, MVM_E_ASSERTION_FAILED); } while (false)
#else
  #define VM_ASSERT(vm, predicate)
#endif

#ifndef __has_builtin
  #define __has_builtin(x) 0
#endif

// Offset of field in a struct
#define OFFSETOF(TYPE, ELEMENT) ((uint16_t)&(((TYPE *)0)->ELEMENT))

// Allocation
#define MAX_ALLOCATION_SIZE 0xFFF

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

#define VM_READ_BC_1_AT(offset, lpBytecode) MVM_READ_LONG_PTR_1(MVM_LONG_PTR_ADD((lpBytecode), (offset)));
#define VM_READ_BC_2_AT(offset, lpBytecode) MVM_READ_LONG_PTR_2(MVM_LONG_PTR_ADD((lpBytecode), (offset)));

#define VM_READ_BC_1_FIELD(fieldName, structOffset, structType, lpBytecode) VM_READ_BC_1_AT(structOffset + OFFSETOF(structType, fieldName), lpBytecode);
#define VM_READ_BC_2_FIELD(fieldName, structOffset, structType, lpBytecode) VM_READ_BC_2_AT(structOffset + OFFSETOF(structType, fieldName), lpBytecode);

#define VM_READ_BC_1_HEADER_FIELD(fieldName, lpBytecode) VM_READ_BC_1_FIELD(fieldName, 0, mvm_TsBytecodeHeader, lpBytecode);
#define VM_READ_BC_2_HEADER_FIELD(fieldName, lpBytecode) VM_READ_BC_2_FIELD(fieldName, 0, mvm_TsBytecodeHeader, lpBytecode);

#define VM_BOTTOM_OF_STACK(vm) ((uint16_t*)(vm->stack + 1))
#define VM_TOP_OF_STACK(vm) (VM_BOTTOM_OF_STACK(vm) + MVM_STACK_SIZE / 2)
#define VM_IS_UNSIGNED(v) ((v & VM_VALUE_SIGN_BIT) == VM_VALUE_UNSIGNED)
#define VM_SIGN_EXTEND(v) (VM_IS_UNSIGNED(v) ? v : (v | VM_SIGN_EXTENTION))

#define VM_INT_VALUE(i) (Value)((i << 2) | 3)

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
  TC_REF_HOST_FUNC      = 0x6, // TsHostFunc


  TC_REF_BIG_INT        = 0x7, // Reserved
  TC_REF_SYMBOL         = 0x8, // Reserved

  /* --------------------------- Container types --------------------------- */
  TC_REF_DIVIDER_CONTAINER_TYPES, // <--- Marker. Types after or including this point but less than 0x10 are container types

  TC_REF_RESERVED_1     = 0x9, // Reserved
  TC_REF_RESERVED_2     = 0xA, // Reserved
  TC_REF_INTERNAL_CONTAINER = 0xB, // Non-user-facing container type

  TC_REF_PROPERTY_LIST  = 0xC, // TsPropertyList - Object represented as linked list of properties
  TC_REF_ARRAY          = 0xD, // TsArray
  TC_REF_FIXED_LENGTH_ARRAY = 0xE, // TsFixedLengthArray
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

// Note: VM_VALUE_NAN must be used instead of a pointer to a double that has a
// NaN value (i.e. the values must be normalized to use the following table).
// Operations will assume this canonical form.

// Some well-known values
typedef enum vm_TeWellKnownValues {
  VM_VALUE_UNDEFINED     = ((int)TC_VAL_UNDEFINED << 2) | 1,
  VM_VALUE_NULL          = ((int)TC_VAL_NULL << 2) | 1,
  VM_VALUE_TRUE          = ((int)TC_VAL_TRUE << 2) | 1,
  VM_VALUE_FALSE         = ((int)TC_VAL_FALSE << 2) | 1,
  VM_VALUE_NAN           = ((int)TC_VAL_NAN << 2) | 1,
  VM_VALUE_NEG_ZERO      = ((int)TC_VAL_NEG_ZERO << 2) | 1,
  VM_VALUE_DELETED       = ((int)TC_VAL_DELETED << 2) | 1,
  VM_VALUE_STR_LENGTH    = ((int)TC_VAL_STR_LENGTH << 2) | 1,
  VM_VALUE_STR_PROTO     = ((int)TC_VAL_STR_PROTO << 2) | 1,

  VM_VALUE_WELLKNOWN_END = ((int)TC_VAL_STR_PROTO << 2) | 1,
} vm_TeWellKnownValues;

typedef struct TsArray {
  // Note: the capacity of the array is the length of the TsFixedLengthArray
  // pointed to by dpData2. The logical length of the array is determined by
  // viLength.
  //
  // Note: dpData2 must be a unique pointer (it must be the only pointer that
  // points to that allocation)
  //
  // Note: for arrays in GC memory, their dpData2 must point to GC memory as
  // well
  //
  // Note: Values in dpData2 that are beyond the logical length MUST be filled
  // with VM_VALUE_DELETED.

  DynamicPtr dpData2; // Points to TsFixedLengthArray
  VirtualInt14 viLength;
} TsArray;

typedef struct TsFixedLengthArray {
  // Note: the length of the fixed-length-array is determined by the allocation header
  Value items[1];
} TsFixedLengthArray;

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
  // Note: if the property list is in GC memory, then dpNext must also point to
  // GC memory, but dpProto can point to any memory (e.g. a prototype stored in
  // ROM).

  // Note: in the serialized form, the next pointer must be null
  DynamicPtr dpNext; // TsPropertyList* or VM_VALUE_NULL, containing further appended properties
  DynamicPtr dpProto; // Note: the protype is only meaningful on the first in the list
  /*
  Followed by N of these pairs to fill up the allocation size:
    Value key; // TC_VAL_INT14 or TC_REF_UNIQUE_STRING
    Value value;
   */
} TsPropertyList2;

typedef struct TsPropertyCell /* extends TsPropertyList2 */ {
  TsPropertyList2 base;
  Value key; // TC_VAL_INT14 or TC_REF_UNIQUE_STRING
  Value value;
} TsPropertyCell;

// External function by index in import table
typedef struct TsHostFunc {
  // Note: TC_REF_HOST_FUNC is not a container type, so it's fields are not
  // traced by the GC.
  //
  // Note: most host function reference can be optimized to not require this
  // allocation -- they can use VM_OP2_CALL_HOST directly. This allocation is
  // only required then the reference to host function is ambiguous or there are
  // calls to more than 256 host functions.
  uint16_t indexInImportTable;
} TsHostFunc;

typedef struct TsBucket2 {
  uint16_t offsetStart; // The number of bytes in the heap before this bucket
  struct TsBucket2* prev;
  struct TsBucket2* next;
  /* ...data */
} TsBucket2;

struct mvm_VM {
  uint16_t* globals;
  LongPtr lpBytecode;

  // Start of the last bucket of GC memory
  TsBucket2* pLastBucket2;
  // End of the last bucket of GC memory
  uint8_t* pLastBucketEnd2;
  // Where to allocate next GC allocation
  uint8_t* pAllocationCursor2;
  // Handles - values to treat as GC roots
  mvm_Handle* gc_handles;
  uint16_t heapSizeUsedAfterLastGC;

  vm_TsStack* stack;

  void* context;
};

typedef struct TsUniqueStringCell { // TC_REF_INTERNAL_CONTAINER
  ShortPtr spNext;
  Value str;
} TsUniqueStringCell;

typedef struct vm_TsRegisters {
  uint16_t* pFrameBase;
  uint16_t* pStackPointer;
  LongPtr programCounter2;
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
  TsBucket2* firstBucket;
  TsBucket2* lastBucket;
  uint16_t* lastBucketEnd;
  uint16_t lastBucketOffsetStart;
} gc2_TsGCCollectionState;

#define TOMBSTONE_HEADER ((TC_REF_TOMBSTONE << 12) | 2)
