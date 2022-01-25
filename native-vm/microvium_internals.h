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

#define MVM_ENGINE_VERSION 2
#define MVM_EXPECTED_PORT_FILE_VERSION 1

#define MVM_POINTER_CHECKING MVM_SAFE_MODE

typedef mvm_VM VM;
typedef mvm_TeError TeError;

/**
 * mvm_Value
 *
 * Hungarian prefix: v
 *
 * Internally, the name `Value` refers to `mvm_Value`
 *
 * The Microvium Value type is 16 bits with a 1 or 2 bit discriminator in the
 * lowest bits:
 *
 *  - If the lowest bit is `0`, interpret the value as a `ShortPtr`. Note that
 *    in a snapshot bytecode file, a ShortPtr is measured relative to the
 *    beginning of the RAM section of the file.
 *  - If the lowest bits are `11`, interpret the high 14-bits as a signed 14 bit
 *    integer. The Value is an `VirtualInt14`
 *  - If the lowest bits are `01`, interpret the high 15-bits as a
 *    `BytecodeMappedPtr` or a well-known value.
 *
 * TODO: I considered requiring that bytecode pointers are 4-byte aligned so
 * that we can address up to 64kB of ROM, but I couldn't stomach the extra
 * required padding. A pathological case would be a table of 32-bit integers. It
 * would currently require 8 bytes per integer (4-byte integer + 2 byte header +
 * 2 byte pointer) and this would increase to 10 bytes per integer. Actually,
 * now that I say it, perhaps this isn't too bad, since this is pretty much the
 * worse possible case I can think of and it only adds 25% more ROM requirement
 * while doubling the possible ROM size. Also remember that most programs take
 * more ROM than RAM, hence why MCUs have so much more ROm than RAM, so having
 * the balance the other way is a bit weird.
 */
typedef mvm_Value Value;

static inline bool Value_isShortPtr(Value value) { return (value & 1) == 0; }
static inline bool Value_isBytecodeMappedPtrOrWellKnown(Value value) { return (value & 3) == 1; }
static inline bool Value_isVirtualInt14(Value value) { return (value & 3) == 3; }
static inline bool Value_isVirtualUInt12(Value value) { return (value & 0xC003) == 3; }


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

#if MVM_DONT_TRUST_BYTECODE || MVM_SAFE_MODE
// TODO: I think I need to do an audit of all the assertions and errors in the code, and make sure they're categorized correctly as bytecode errors or not
#define VM_INVALID_BYTECODE(vm) MVM_FATAL_ERROR(vm, MVM_E_INVALID_BYTECODE)
#define VM_BYTECODE_ASSERT(vm, condition) do { if (!(condition)) VM_INVALID_BYTECODE(vm); } while (false)
#else
#define VM_INVALID_BYTECODE(vm)
#define VM_BYTECODE_ASSERT(vm, condition)
#endif

#ifndef CODE_COVERAGE
/*
 * A set of macros for manual code coverage analysis (because the off-the-shelf
 * tools appear to be quite expensive). This should be overridden in the port
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

  TC_REF_FUNCTION       = 0x5, // TsBytecodeFunc
  TC_REF_HOST_FUNC      = 0x6, // TsHostFunc

  TC_REF_RESERVED_1B     = 0x7, // Reserved
  TC_REF_SYMBOL         = 0x8, // Reserved

  /* --------------------------- Container types --------------------------- */
  TC_REF_DIVIDER_CONTAINER_TYPES, // <--- Marker. Types after or including this point but less than 0x10 are container types

  TC_REF_CLASS          = 0x9, // TsClass
  TC_REF_VIRTUAL        = 0xA, // TsVirtual
  TC_REF_INTERNAL_CONTAINER = 0xB, // Non-user-facing container type (used for interned strings)
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

// TODO: I think the values in this table were meant to be shifted left by `1`
// (or multiplied by `2`), not shifted left by `1`.

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
 * The `target` must reference a function, either a local function or host (it
 * cannot itself be a TsClosure). This will be what is called when the closure
 * is called. If it's an invalid type, the error is the same as if calling that
 * type directly.
 *
 * The closure keeps a reference to the outer `scope`. The machine semantics for
 * a `CALL` of a `TsClosure` is to set `scope` register to the scope of the
 * `TsClosure`, which is then accessible via the `VM_OP_LOAD_SCOPED_1` and
 * `VM_OP_STORE_SCOPED_1` instructions. The `VM_OP1_CLOSURE_NEW` instruction
 * automatically captures the current `scope` register in a new `TsClosure`.
 *
 * Scopes are created using `VM_OP1_SCOPE_PUSH` using the type
 * `TC_REF_FIXED_LENGTH_ARRAY`, with one extra slot for the reference to the
 * outer scope. An instruction like `VM_OP_LOAD_SCOPED_1` accepts an index into
 * the slots in the scope chain (see `vm_findScopedVariable`)
 *
 * By convension, the caller passes `this` by the first argument. If the closure
 * body wants to access the caller's `this` then it just access the first
 * argument. If the body wants to access the outer scope's `this` then it parent
 * must copy the `this` argument into the closure scope and the child can access
 * it via `VM_OP_LOAD_SCOPED_1`, the same as would be done for any closed-over
 * parameter.
 */
typedef struct TsClosure {
  Value scope;
  Value target; // Function type
} TsClosure;

/**
 * (at the time of this writing, this is just a placeholder type)
 *
 * This type is to provide [non-compliant] support for ECMAScript classes.
 * Rather than classes being a real "function" with a `prototype` property,
 * they're just instances of `TsClass` with a `prototype` field. The
 * `.prototype` is not accessible to user code as a property as it would
 * normally be in JS. This could be thought of as "classes light" feature,
 * providing a useful-but-non-compliant implementation of the classes feature of
 * JS.
 *
 * The planned semantics here is that the class can be invoked (maybe via a
 * `NEW` instruction, or maybe just by `CALL` if we wanted to save an opcode)
 * and it will implicitly create a new object instance whose `__proto__` is the
 * `prototype` field of the class, and then invoke the `constructor` with the
 * new object as its first argument.
 */
typedef struct TsClass {
  Value prototype;
  Value constructor; // Function type
  Value staticProps;
} TsClass;

/**
 * TsVirtual (at the time of this writing, this is just a placeholder type)
 *
 * This is a placeholder for an idea to have something like a "low-level proxy"
 * type. See my private notes for details (if you have access to them). The
 * `type` and `state` fields correspond roughly to the "handler" and "target"
 * fields respectively in a normal ES `Proxy`.
 */
typedef struct TsVirtual {
  Value state;
  Value type;
} TsVirtual;

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

struct mvm_VM { // 22 B
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

  uint16_t stackHighWaterMark;
  uint16_t heapHighWaterMark;

  #if MVM_INCLUDE_DEBUG_CAPABILITY
  TsBreakpoint* pBreakpoints;
  mvm_TfBreakpointCallback breakpointCallback;
  #endif // MVM_INCLUDE_DEBUG_CAPABILITY

  #if MVM_POINTER_CHECKING
  /*
  A counter that increments every time the GC _could have_ run. This includes
  all situations where a new allocation is created, and also whenever control is
  passed to the host (WIP) since the host can manually trigger a GC
  */
  uint16_t gcPotentialRunCounter;
  // The allocation mask has 1 bit for every 16 bits of GC memory, where the bit
  // is 1 if an allocation starts at that location in memory (used for pointer
  // checking)
  // WIP Initialize at construction
  // WIP Populate during GC
  uint8_t* gcAllocationMask;
  uint16_t gcAllocationMaskSize;
  #endif

  void* context;
};

typedef struct TsInternedStringCell { // TC_REF_INTERNAL_CONTAINER
  ShortPtr spNext;
  Value str;
} TsInternedStringCell;

// Possible values for the `flags` machine register
typedef enum vm_TeActivationFlags {
  // Note: these flags start at bit 8 because they use the same word as the argument count

  // Flag to indicate if the most-recent CALL operation involved a stack-based
  // function target (as opposed to a literal function target). If this is set,
  // then the next RETURN instruction will also pop the function reference off
  // the stack.
  AF_PUSHED_FUNCTION = 1 << 9,

  // Flag to indicate that returning from the current frame should return to the host
  AF_CALLED_FROM_HOST = 1 << 10
} vm_TeActivationFlags;

/**
 * This struct is malloc'd from the host when the host calls into the VM
 */
typedef struct vm_TsRegisters { // 20 B
  #if MVM_SAFE_MODE
    // This will be true if the VM is operating on the local variables rather
    // than the shared vm_TsRegisters structure.
    bool usingCachedRegisters;
  #endif
  uint16_t* pFrameBase;
  uint16_t* pStackPointer;
  LongPtr lpProgramCounter;
  // Note: I previously used to infer the location of the arguments based on the
  // number of values PUSHed by a CALL instruction to preserve the activation
  // state (i.e. 3 words). But now that distance is dynamic, so we need and
  // explicit register.
  Value* pArgs;
  uint16_t argCountAndFlags; // Lower 8 bits are argument count, upper 8 bits are vm_TeActivationFlags
  Value scope; // Closure scope
} vm_TsRegisters;

/**
 * This struct is malloc'd from the host when the host calls into the VM and
 * freed when the VM finally returns to the host. This struct embeds both the
 * working registers and the call stack in the same allocation since they are
 * needed at the same time and it's more efficient to do a single malloc where
 * possible.
 */
struct vm_TsStack {
  // Allocate registers along with the stack, because these are needed at the same time (i.e. while the VM is active)
  vm_TsRegisters reg;
  // Note: the stack grows upwards (towards higher addresses)
  // ... (stack memory) ...
};

typedef struct TsAllocationHeader {
  /* 4 least-significant-bits are the type code (TeTypeCode). Remaining 12 bits
  are the allocation size, excluding the size of the header itself, in bytes
  (measured in bytes so that we can represent the length of strings exactly).
  See also `vm_getAllocationSizeExcludingHeaderFromHeaderWord` */
  uint16_t headerData;
} TsAllocationHeader;

typedef struct TsBytecodeFunc {
  uint8_t maxStackDepth;
  /* Follwed by the bytecode bytes */
} TsBytecodeFunc;

typedef struct vm_TsImportTableEntry {
  mvm_HostFunctionID hostFunctionID;
  /*
  Note: I considered having a `paramCount` field in the header since a common
  scenario would be copying the arguments into the parameter slots. However,
  most parameters are not actually mutated in a function, so the LOAD_ARG
  instruction could just be used directly to get the parameter value (if the
  optimizer can detect such cases).
  */
} vm_TsImportTableEntry;

#define GC_TRACE_STACK_COUNT 20

typedef struct gc_TsGCCollectionState {
  VM* vm;
  TsBucket* firstBucket;
  TsBucket* lastBucket;
  uint16_t* lastBucketEndCapacity;
} gc_TsGCCollectionState;

#define TOMBSTONE_HEADER ((TC_REF_TOMBSTONE << 12) | 2)
