// See microvium.c for design notes.
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
inline bool Value_isBytecodeMappedPtrOrWellKnown(Value value) { return (value & 3) == 1; }
inline bool Value_isVirtualInt14(Value value) { return (value & 3) == 3; }
inline bool Value_isVirtualUInt12(Value value) { return (value & 0xC003) == 3; }

/**
 * Short Pointer
 *
 * Hungarian prefix: sp
 *
 * A ShortPtr is a 16-bit **non-nullable** reference which can refer to GC
 * memory, but not to data memory or bytecode.
 *
 * Note: To avoid confusion of when to use different kinds of null values,
 * ShortPtr should be considered non-nullable. When null is required, use
 * VM_VALUE_NULL for consistency, which is not defined as a short pointer.
 *
 * Note: At runtime, pointers _to_ GC memory must always be encoded as
 * `ShortPtr` or indirectly through a BytecodeMappedPtr to a global variable.
 * This is to improve efficiency of the GC, since it can assume that only values
 * with the lower bit `0` need to be traced/moved.
 *
 * On 16-bit architectures, while the script is running, ShortPtr can be a
 * native pointer, allowing for fast access. On other architectures, ShortPtr is
 * encoded as an offset from the beginning of the virtual heap.
 *
 * Note: the bytecode image is independent of target architecture, and always
 * stores ShortPtr as an offset from the beginning of the virtual heap. If the
 * runtime representation is a native pointer, the translation occurs in
 * `loadPointers`.
 *
 * A ShortPtr must never exist in a ROM slot, since they need to have a
 * consistent representation in all cases, and ROM slots are not visited by
 * `loadPointers`. Also because short pointers are used iff they point to GC
 * memory, which is subject to relocation and therefore cannot be referenced
 * from an immutable medium.
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
 * Bytecode-mapped Pointer
 *
 * Hungarian prefix: `dp` (because BytecodeMappedPtr is generally used as a
 * DynamicPtr)
 *
 * A `BytecodeMappedPtr` is a 16-bit reference to something in ROM or RAM. It is
 * interpreted as an offset into the bytecode image, and its interpretation
 * depends where in the image it points to.
 *
 * If the offset points to the BCS_ROM section of bytecode, it is interpreted as
 * pointing to that ROM allocation or function.
 *
 * If the offset points to the BCS_GLOBALS region of the bytecode image, the
 * `BytecodeMappedPtr` is treated being a reference to the allocation referenced
 * by the corresponding global variable. This allows ROM Values, such as
 * literal, exports, and builtins, to reference RAM allocations. *Note*: for the
 * moment, behavior is not defined if the corresponding global has non-pointer
 * contents, such as an Int14 or well-known value. In future this may be
 * explicitly allowed.
 *
 * A `BytecodeMappedPtr` is only a pointer type and is not defined to encode the
 * well-known values or null.
 */
typedef uint16_t BytecodeMappedPtr;

/**
 * Dynamic Pointer
 *
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
 * ROM Pointer
 *
 * Hungarian prefix: none
 *
 * A `DynamicPtr` which is known to only point to ROM
 */
typedef Value RomPtr;

/**
 * Int14 encoded as a Value
 *
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
 * The reference type range is subdivided into containers or non-containers. The
 * GC uses this distinction to decide whether the body of the allocation should
 * be interpreted as `Value`s (i.e. may contain pointers). To minimize the code,
 * either ALL words in a container are `Value`s, or none.
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
   * encode an integer in the range 0 to 0x1FFF.
   *
   * To keep property lookup efficient, Microvium requires that strings used as
   * property keys can be compared using pointer equality. This requires that
   * there is only one instance of each of those strings (see
   * https://en.wikipedia.org/wiki/String_interning).
   *
   * A string with the type code TC_REF_INTERNED_STRING means that it exists in
   * one of the interning tables (either the one in ROM or the one in RAM). Not
   * all strings are interned, because it would be expensive if every string
   * concatenation resulted in a search of the intern table and possibly a new
   * entry (imagine if every JSON string landed up in the table!).
   *
   * In practice we do this:
   *
   *  - All valid non-index property keys in ROM are interned. If a string is in ROM but it is not interned, the engine can conclude that it is not a valid property key or it is an index.
   *  - Strings constructed in RAM are only interned when they're used to access properties.
   */
  TC_REF_INTERNED_STRING  = 0x4,

  TC_REF_FUNCTION       = 0x5, // Local function
  TC_REF_HOST_FUNC      = 0x6, // TsHostFunc

  TC_REF_BIG_INT        = 0x7, // Reserved
  TC_REF_SYMBOL         = 0x8, // Reserved

  /* --------------------------- Container types --------------------------- */
  TC_REF_DIVIDER_CONTAINER_TYPES, // <--- Marker. Types after or including this point but less than 0x10 are container types

  TC_REF_RESERVED_1     = 0x9, // Reserved
  TC_REF_RESERVED_2     = 0xA,
  TC_REF_INTERNAL_CONTAINER = 0xB, // Non-user-facing container type
  TC_REF_PROPERTY_LIST  = 0xC, // TsPropertyList - Object represented as linked list of properties
  TC_REF_ARRAY          = 0xD, // TsArray
  TC_REF_FIXED_LENGTH_ARRAY = 0xE, // TsFixedLengthArray
  TC_REF_CLOSURE        = 0xF, // TsClosure

  /* ----------------------------- Value types ----------------------------- */
  TC_VAL_UNDEFINED     = 0x10,
  TC_VAL_INT14         = 0x11,
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
  VM_VALUE_UNDEFINED     = (((int)TC_VAL_UNDEFINED - 0x10) << 2) | 1,
  VM_VALUE_NULL          = (((int)TC_VAL_NULL - 0x10) << 2) | 1,
  VM_VALUE_TRUE          = (((int)TC_VAL_TRUE - 0x10) << 2) | 1,
  VM_VALUE_FALSE         = (((int)TC_VAL_FALSE - 0x10) << 2) | 1,
  VM_VALUE_NAN           = (((int)TC_VAL_NAN - 0x10) << 2) | 1,
  VM_VALUE_NEG_ZERO      = (((int)TC_VAL_NEG_ZERO - 0x10) << 2) | 1,
  VM_VALUE_DELETED       = (((int)TC_VAL_DELETED - 0x10) << 2) | 1,
  VM_VALUE_STR_LENGTH    = (((int)TC_VAL_STR_LENGTH - 0x10) << 2) | 1,
  VM_VALUE_STR_PROTO     = (((int)TC_VAL_STR_PROTO - 0x10) << 2) | 1,

  VM_VALUE_WELLKNOWN_END,
} vm_TeWellKnownValues;

#define VIRTUAL_INT14_ENCODE(i) ((uint16_t)((i << 2) | 3))

typedef struct TsArray {
 /*
  * Note: the capacity of the array is the length of the TsFixedLengthArray
  * pointed to by dpData, or 0 if dpData is VM_VALUE_NULL. The logical length
  * of the array is determined by viLength.
  *
  * Note: If dpData is not null, it must be a unique pointer (it must be the
  * only pointer that points to that allocation)
  *
  * Note: for arrays in GC memory, their dpData must point to GC memory as well
  *
  * Note: Values in dpData that are beyond the logical length MUST be filled
  * with VM_VALUE_DELETED.
  */

  DynamicPtr dpData; // Points to TsFixedLengthArray
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
 * `next` pointer to the next group (list). When assigning to a new property,
 * rather than resizing a group, the VM will just append a new group to the list
 * (a group with just the one new property).
 *
 * Only the `proto` field of the first group of properties in an object is used.
 *
 * The garbage collector compacts multiple groups into one large one, so it
 * doesn't matter that appending a single property requires a whole new group on
 * its own or that they have unused proto properties.
 */
typedef struct TsPropertyList {
  // Note: if the property list is in GC memory, then dpNext must also point to
  // GC memory, but dpProto can point to any memory (e.g. a prototype stored in
  // ROM).

  // Note: in the serialized form, the next pointer must be null
  DynamicPtr dpNext; // TsPropertyList* or VM_VALUE_NULL, containing further appended properties
  DynamicPtr dpProto; // Note: the protype is only meaningful on the first in the list
  /*
  Followed by N of these pairs to the end of the allocated size:
    Value key; // TC_VAL_INT14 or TC_REF_INTERNED_STRING
    Value value;
   */
} TsPropertyList;

/**
 * A property list with a single property. See TsPropertyList for description.
 */
typedef struct TsPropertyCell /* extends TsPropertyList */ {
  TsPropertyList base;
  Value key; // TC_VAL_INT14 or TC_REF_INTERNED_STRING
  Value value;
} TsPropertyCell;

/**
 * A closure is a function-like type that has access to an outer lexical scope
 * (other than the globals, which are already accessible by any function).
 *
 * The `TsClosure` type is dynamically sized, and can be 4, 6, or 8 bytes,
 * including 2, 3, or 4 fields respectively, with the later fields being
 * optional.
 *
 * The closure keeps a reference to the outer `scope`. The VM doesn't actually
 * care what type the `scope` has -- it will simply be used as the `scope`
 * register value when the closure is called.
 *
 * The `target` must reference a function, either a local function or host (it
 * cannot itself be a TsClosure). This will be what is called when the closure
 * is called. If it's an invalid type, the error is the same as if calling that
 * type directly.
 *
 * The `props` is optional. It allows the closure to act like an object.
 * Property access on the closure is delegated to the object referenced by
 * `props`. It's legal to omit props or set props to null only if it is known
 * that there is no property access on the closure.
 *
 * The `this_` value is optional. If present and not `undefined`, it will be
 * used as the value of the `this_` machine register.
 */
typedef struct TsClosure {
  Value target;
  Value scope;
  DynamicPtr props; /* WIP check usage */ // TsPropertyList or VM_VALUE_NULL
  Value this_;
} TsClosure;

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

typedef struct TsBucket {
  uint16_t offsetStart; // The number of bytes in the heap before this bucket
  struct TsBucket* prev;
  struct TsBucket* next;
  /* Note: pEndOfUsedSpace used to be on the VM struct, rather than per-bucket.
   * The main reason it's useful to have it on each bucket is in the hot GC-loop
   * which needs to check if it's caught up with the write cursor in to-space or
   * check if it's hit the end of the bucket. Without this value being in each
   * bucket, the calculation to find the end of the bucket is expensive.
   *
   * Note that for the last bucket, `pEndOfUsedSpace` doubles up as the write
   * cursor, since it's only recording the *used* space. The *capacity* of each
   * bucket is not recorded, but the capacity of the *last* bucket is recorded
   * in `pLastBucketEndCapacity` (on the VM and GC structures).  */
  uint16_t* pEndOfUsedSpace;

  /* ...data */
} TsBucket;

typedef struct TsBreakpoint {
  struct TsBreakpoint* next;
  uint16_t bytecodeAddress;
} TsBreakpoint;

struct mvm_VM {
  uint16_t* globals;
  LongPtr lpBytecode;

  // Last bucket of GC memory
  TsBucket* pLastBucket;
  // End of the capacity of the last bucket of GC memory
  uint16_t* pLastBucketEndCapacity;
  // Handles - values to treat as GC roots
  mvm_Handle* gc_handles;
  uint16_t heapSizeUsedAfterLastGC;

  vm_TsStack* stack;

  #if MVM_GENERATE_DEBUG_CAPABILITY
  TsBreakpoint* pBreakpoints;
  mvm_TfBreakpointCallback breakpointCallback;
  #endif // MVM_GENERATE_DEBUG_CAPABILITY

  void* context;
};

typedef struct TsInternedStringCell { // TC_REF_INTERNAL_CONTAINER
  ShortPtr spNext;
  Value str;
} TsInternedStringCell;

// Possible values for the `flags` machine register
typedef enum vm_TeActivationFlags {
  // Note: these flags start at bit 8 because they use the same word as the argument count

  // Indicates if there is an active closure `scope`. If this flag is set, the
  // next CALL operation will push the `scope` to the call stack to save it. If
  // it is not set, a `LOAD_SCOPE` instruction will return `undefined`.
  AF_SCOPE = 1 << 8,

  // Indicates if there is an active `this` reference. If not set, then `this`
  // is treated as `undefined`. If it is set, then the next `CALL` operation
  // will push the `this` value to the stack to preserve it.
  AF_THIS = 1 << 9,

  // Flag to indicate if the most-recent CALL operation involved a stack-based
  // function target (as opposed to a literal function target). If this is set,
  // then the next RETURN instruction will also pop the function reference off
  // the stack.
  AF_PUSHED_FUNCTION = 1 << 10,

  // Flag to indicate that a RETURN from this point should go back to the host
  AF_CALLED_FROM_EXTERNAL = 1 << 11
} vm_TeActivationFlags;

typedef struct vm_TsRegisters {
  uint16_t* pFrameBase;
  uint16_t* pStackPointer;
  LongPtr lpProgramCounter;
  uint16_t argCountAndFlags; // Lower 8 bits are argument count, upper 8 bits are vm_TeActivationFlags
  Value scope; // Outer scope of closure if AF_SCOPE is set, else 0 (WIP initial conditions)
  Value this_; // Current value of `this` if AF_THIS is set, else 0 (WIP initial conditions)
} vm_TsRegisters;

struct vm_TsStack {
  // Allocate registers along with the stack, because these are needed at the same time (i.e. while the VM is active)
  vm_TsRegisters reg;
  // Note: the stack grows upwards (towards higher addresses)
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

typedef struct gc_TsGCCollectionState {
  VM* vm;
  TsBucket* firstBucket;
  TsBucket* lastBucket;
  uint16_t* lastBucketEndCapacity;
} gc_TsGCCollectionState;

#define TOMBSTONE_HEADER ((TC_REF_TOMBSTONE << 12) | 2)
