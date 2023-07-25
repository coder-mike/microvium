// See microvium.c for design notes.
#pragma once

#include "stdbool.h"
#include "stdint.h"
#include "assert.h"
#include "string.h"
#include "stdlib.h"

#include "microvium.h"
#include "microvium_port.h"
#include "microvium_bytecode.h"
#include "microvium_opcodes.h"

// WIP: Need to bump this to version 8 for the change to function headers
#define MVM_ENGINE_VERSION 7
#define MVM_EXPECTED_PORT_FILE_VERSION 1
// Note: MVM_BYTECODE_VERSION is at the top of `microvium_bytecode.h`

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
 */
typedef mvm_Value Value;

static inline bool Value_isShortPtr(Value value) { return (value & 1) == 0; }
static inline bool Value_isBytecodeMappedPtrOrWellKnown(Value value) { return (value & 3) == 1; }
static inline bool Value_isVirtualInt14(Value value) { return (value & 3) == 3; }
static inline bool Value_isVirtualUInt12(Value value) { return (value & 0xC003) == 3; }
static inline bool Value_isVirtualUInt8(Value value) { return (value & 0xFC03) == 3; }

/**
 * ShortPtr
 *
 * Hungarian prefix: sp
 *
 * A ShortPtr is a 16-bit **non-nullable** reference which references into GC
 * memory, but not to data memory or bytecode.
 *
 * Note: To avoid confusion of when to use different kinds of null values,
 * ShortPtr should be considered non-nullable. When null is required, use
 * VM_VALUE_NULL for consistency, which is not defined as a short pointer.
 *
 * The GC assumes that anything with a low bit 0 is a non-null pointer into GC
 * memory (it does not do null checking on these, since this is a hot loop).
 *
 * Note: At runtime, pointers _to_ GC memory must always be encoded as
 * `ShortPtr` or indirectly through a BytecodeMappedPtr to a global variable.
 * This is because the GC assumes (for efficiency reasons) only values with the
 * lower bit `0` need to be traced/moved.
 *
 * A ShortPtr is interpreted one of 3 ways depending on the context:
 *
 *   1. On 16-bit architectures (when MVM_NATIVE_POINTER_IS_16_BIT is set),
 *      while the script is running, ShortPtr can be a native pointer, allowing
 *      for fast access. On other architectures, ShortPtr is encoded as an
 *      offset from the beginning of the virtual heap.
 *
 *   2. On non-16-bit architectures (when MVM_NATIVE_POINTER_IS_16_BIT is not
 *      set), ShortPtr is an offset into the allocation buckets. Access is
 *      linear time to the number of buckets, but the buckets are compacted
 *      together during a GC cycle so the number should typically be 1 or low.
 *
 *   3. In the hibernating GC heap, in the snapshot, ShortPtr is treated as an
 *      offset into the bytecode image, but always an offset back into the
 *      GC-RAM section. See `loadPointers`
 *
 * TODO: Rather than just MVM_NATIVE_POINTER_IS_16_BIT, we could better serve
 * small 32-bit devices by having a "page" #define that is added to ShortPtr to
 * get the real address. This is because on ARM architectures, the RAM pointers
 * are mapped to a higher address space.
 *
 * A ShortPtr must never exist in a ROM slot, since they need to have a
 * consistent representation in all cases, and ROM slots are not visited by
 * `loadPointers`. Also short pointers are used iff they point to GC memory,
 * which is subject to relocation and therefore cannot be referenced from an
 * immutable medium.
 *
 * If the lowest bit of the `ShortPtr` is 0 (i.e. points to an even boundary),
 * then the `ShortPtr` is also a valid `Value`.
 *
 * NULL short pointers are only allowed in some special circumstances, but are
 * mostly not valid.
 */
typedef uint16_t ShortPtr;

/**
 * Bytecode-mapped Pointer
 *
 * If `b` is a BytecodeMappedPtr then `b & 0xFFFE` is treated as an offset into
 * the bytecode address space, and its meaning depends on where in the bytecode
 * image it points:
 *
 *
 * 1. If the offset points to the BCS_ROM section of bytecode, it is interpreted
 *    as pointing to that ROM allocation or function.
 *
 * 2. If the offset points to the BCS_GLOBALS region of the bytecode image, the
 *    `BytecodeMappedPtr` is treated being a reference to the allocation
 *    referenced by the corresponding global variable.
 *
 * This allows ROM Values, such as literal, exports, and builtins, to reference
 * RAM allocations. *Note*: for the moment, behavior is not defined if the
 * corresponding global has non-pointer contents, such as an Int14 or well-known
 * value. In future this may be explicitly allowed.
 *
 * A `BytecodeMappedPtr` is only a pointer type and is not defined to encode the
 * well-known values or null.
 *
 * Note that in practice, BytecodeMappedPtr is not used anywhere except in
 * decoding DynamicPtr.
 *
 * See `BytecodeMappedPtr_decode_long`
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
  LongPtr_read2_aligned(LongPtr_add(longPtr, OFFSETOF(structType, fieldName)))

#define READ_FIELD_1(longPtr, structType, fieldName) \
  LongPtr_read1(LongPtr_add(longPtr, OFFSETOF(structType, fieldName)))

// NOTE: In no way are assertions meant to be present in production. They're
// littered everywhere on the assumption that they consume no overhead.
#if MVM_SAFE_MODE
  #define VM_ASSERT(vm, predicate) do { if (!(predicate)) MVM_FATAL_ERROR(vm, MVM_E_ASSERTION_FAILED); } while (false)
#else
  #define VM_ASSERT(vm, predicate)
#endif

#ifndef __has_builtin
  #define __has_builtin(x) 0
#endif

// Offset of field in a struct
#define OFFSETOF(TYPE, ELEMENT) ((uint16_t)(uintptr_t)&(((TYPE *)0)->ELEMENT))

// Maximum size of an allocation (4kB)
#define MAX_ALLOCATION_SIZE 0xFFF

// This is the only valid way of representing NaN
#define VM_IS_NAN(v) ((v) == VM_VALUE_NAN)
// This is the only valid way of representing infinity
#define VM_IS_INF(v) ((v) == VM_VALUE_INF)
// This is the only valid way of representing -infinity
#define VM_IS_NEG_INF(v) ((v) == VM_VALUE_NEG_INF)
// This is the only valid way of representing negative zero
#define VM_IS_NEG_ZERO(v) ((v) == VM_VALUE_NEG_ZERO)

#define VM_NOT_IMPLEMENTED(vm) MVM_FATAL_ERROR(vm, MVM_E_NOT_IMPLEMENTED)
#define VM_RESERVED(vm) MVM_FATAL_ERROR(vm, MVM_E_UNEXPECTED)

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
#define VM_ASSERT_UNREACHABLE(vm) MVM_FATAL_ERROR(vm, MVM_E_UNEXPECTED)
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

// TODO: The example port file sets to 1 because we want it enabled in the
// tests. But really we should have a separate test port file.
#ifndef MVM_VERY_EXPENSIVE_MEMORY_CHECKS
#define MVM_VERY_EXPENSIVE_MEMORY_CHECKS 0
#endif

#ifndef MVM_DONT_TRUST_BYTECODE
#define MVM_DONT_TRUST_BYTECODE 0
#endif

#ifndef MVM_SWITCH
#define MVM_SWITCH(tag, upper) switch (tag)
#endif

#ifndef MVM_CASE
#define MVM_CASE(value) case value
#endif

// Allocation headers on functions are different. Nothing needs the allocation
// size specifically, so the 12 size bits are repurposed.
/** Flag bit to indicate continuation vs normal func. (1 = continuation) */
#define VM_FUNCTION_HEADER_CONTINUATION_FLAG 0x0800
/** (Continuations only) Mask of number of quad-words that the continuation is
 * behind its containing function */
#define VM_FUNCTION_HEADER_BACK_POINTER_MASK 0x07FF
/** (Normal funcs only) Mask of required stack height in words */
#define VM_FUNCTION_HEADER_STACK_HEIGHT_MASK 0x00FF

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
  TC_REF_TOMBSTONE          = 0x0,

  TC_REF_INT32              = 0x1, // 32-bit signed integer
  TC_REF_FLOAT64            = 0x2, // 64-bit float

  /**
   * UTF8-encoded string that may or may not be unique.
   *
   * Note: If a TC_REF_STRING is in bytecode, it is because it encodes a value
   * that is illegal as a property index in Microvium (i.e. it encodes an
   * integer).
   */
  TC_REF_STRING             = 0x3,

  /**
   * TC_REF_INTERNED_STRING
   *
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
   *  - All valid non-index property keys in ROM are interned. If a string is in
   *    ROM but it is not interned, the engine can conclude that it is not a
   *    valid property key or it is an index.
   *  - Strings constructed in RAM are only interned when they're used to access
   *    properties.
   */
  TC_REF_INTERNED_STRING    = 0x4,

  TC_REF_FUNCTION           = 0x5, // TsBytecodeFunc
  TC_REF_HOST_FUNC          = 0x6, // TsHostFunc

  TC_REF_UINT8_ARRAY        = 0x7, // Byte buffer
  TC_REF_SYMBOL             = 0x8, // Reserved: Symbol

  /* --------------------------- Container types --------------------------- */
  TC_REF_DIVIDER_CONTAINER_TYPES,  // <--- Marker. Types after or including this point but less than 0x10 are container types

  TC_REF_CLASS              = 0x9, // TsClass
  TC_REF_VIRTUAL            = 0xA, // Reserved: TsVirtual
  TC_REF_RESERVED_1         = 0xB, // Reserved
  TC_REF_PROPERTY_LIST      = 0xC, // TsPropertyList - Object represented as linked list of properties
  TC_REF_ARRAY              = 0xD, // TsArray
  TC_REF_FIXED_LENGTH_ARRAY = 0xE, // TsFixedLengthArray
  TC_REF_CLOSURE            = 0xF, // TsClosure (see description on struct)

  /* ----------------------------- Value types ----------------------------- */
  TC_VAL_INT14              = 0x10,

  TC_VAL_UNDEFINED          = 0x11,
  TC_VAL_NULL               = 0x12,
  TC_VAL_TRUE               = 0x13,
  TC_VAL_FALSE              = 0x14,
  TC_VAL_NAN                = 0x15,
  TC_VAL_NEG_ZERO           = 0x16,
  TC_VAL_DELETED            = 0x17, // Placeholder for properties and list items that have been deleted or holes in arrays
  TC_VAL_STR_LENGTH         = 0x18, // The string "length"
  TC_VAL_STR_PROTO          = 0x19, // The string "__proto__"

  /**
   * TC_VAL_NO_OP_FUNC
   *
   * Represents a function that does nothing and returns undefined.
   *
   * This is required by async-await for the case where you void-call an async
   * function and it needs to synthesize a dummy callback that does nothing,
   * particularly for a host async function to call back.
   */
  TC_VAL_NO_OP_FUNC         = 0x1A,

  TC_END,
} TeTypeCode;

// Note: VM_VALUE_NAN must be used instead of a pointer to a double that has a
// NaN value (i.e. the values must be normalized to use the following table).
// Operations will assume this canonical form.

// Note: the `(... << 2) | 1` is so that these values don't overlap with the
// ShortPtr or BytecodeMappedPtr address spaces.


// Some well-known values
typedef enum vm_TeWellKnownValues {
  // Note: well-known values share the bytecode address space, so we can't have
  // too many here before user-defined allocations start to become unreachable.
  // The first addressable user allocation in a bytecode image is around address
  // 0x2C (measured empirically -- see test `1.empty-export`) if the image has
  // one export and one string in the string table, which means the largest
  // well-known-value can be the prior address `0x2C-4=0x28` (encoded as a
  // bytecode pointer will be 0x29), corresponding to type-code 0x1B.

  VM_VALUE_UNDEFINED     = (((int)TC_VAL_UNDEFINED - 0x11) << 2) | 1, // = 1
  VM_VALUE_NULL          = (((int)TC_VAL_NULL - 0x11) << 2) | 1,
  VM_VALUE_TRUE          = (((int)TC_VAL_TRUE - 0x11) << 2) | 1,
  VM_VALUE_FALSE         = (((int)TC_VAL_FALSE - 0x11) << 2) | 1,
  VM_VALUE_NAN           = (((int)TC_VAL_NAN - 0x11) << 2) | 1,
  VM_VALUE_NEG_ZERO      = (((int)TC_VAL_NEG_ZERO - 0x11) << 2) | 1,
  VM_VALUE_DELETED       = (((int)TC_VAL_DELETED - 0x11) << 2) | 1,
  VM_VALUE_STR_LENGTH    = (((int)TC_VAL_STR_LENGTH - 0x11) << 2) | 1,
  VM_VALUE_STR_PROTO     = (((int)TC_VAL_STR_PROTO - 0x11) << 2) | 1,
  VM_VALUE_NO_OP_FUNC    = (((int)TC_VAL_NO_OP_FUNC - 0x11) << 2) | 1,

  VM_VALUE_WELLKNOWN_END,
} vm_TeWellKnownValues;

#define VIRTUAL_INT14_ENCODE(i) ((uint16_t)(((unsigned int)(i) << 2) | 3))

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
 *
 * Note: at one stage, I thought that objects could be treated like arrays and
 * just expand geometrically rather than as linked lists. This would work, but
 * then like dynamic arrays they would need to be 2 allocations instead of 1
 * because we can't find all the references to the object each time it grows.
 *
 * Something I've thought of, but not considered too deeply yet, is the
 * possibility of implementing objects in terms of dynamic arrays, to reuse the
 * machinery of dynamic arrays in terms of growing and compacting. This could
 * potentially make the engine smaller.
 */
typedef struct TsPropertyList {
  // Note: if the property list is in GC memory, then dpNext must also point to
  // GC memory, but dpProto can point to any memory (e.g. a prototype stored in
  // ROM).

  // Note: in the serialized form, the next pointer must be null
  DynamicPtr dpNext; // TsPropertyList* or VM_VALUE_NULL, containing further appended properties
  DynamicPtr dpProto; // Note: the prototype is only meaningful on the first in the list
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
 * A TsClosure (TC_REF_CLOSURE) is a function-like (callable) container that is
 * overloaded to represent both closures and/or their variable environments.
 *
 * See also [closures](../doc/internals/closures.md)
 *
 * The first and last slots in a closure are special:
 *
 *   1. The first slot is the function `target`. If a CALL operation is executed
 *      on a closure then the call is delegated to the function in the first
 *      slot. It's permissable to use this slot for other purposes if the
 *      closure will never be called.
 *
 *   2. The last slot is the `parentScope`. If the index provided to
 *      `LoadScoped` or `StoreScoped` overflow the current closure then they
 *      automatically index into the parent scope, recursively up the chain.
 *      It's permissible to use this slot for custom purposes if the bytecode
 *      will not try to access variables from a parent scope.
 *
 * The minimum closure size is 1 slot. This could happen if neither the function
 * slot nor parent slot are used, and the scope contains a single variable.
 *
 * The bytecode instructions LoadScoped and StoreScoped write to the slots of
 * the _current closure_ (TsRegisters.closure).
 *
 * The instruction VM_OP1_CLOSURE_NEW creates a closure with exactly 2 slots,
 * where the first second is populated from the current closure.
 *
 * The instruction VM_OP1_SCOPE_PUSH creates a closure with any number of slots
 * and no function pointer, and sets it as the current closure. From there, the
 * IL can set it's own function pointer using `StoreScoped`.
 */
typedef struct TsClosure {
  Value target; // function
  /* followed optionally by other variables, and finally by a pointer to the
  parent scope if needed */
} TsClosure;

/**
 * This type is to provide support for a subset of the ECMAScript classes
 * feature. Classes can be instantiated using `new`, but it is illegal to call
 * them directly. Similarly, `new` doesn't work on arbitrary function.
 */
typedef struct TsClass {
  Value constructorFunc; // Function type
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

/*
  Minimum size:
    - 6 pointers + 1 long pointer + 4 words
    - = 24B on 16bit
    - = 36B on 32bit.

  Maximum size (on 64-bit machine):
    - 9 pointers + 4 words
    - = 80 bytes on 64-bit machine

  See also the unit tests called "minimal-size"

*/
struct mvm_VM {
  uint16_t* globals;
  LongPtr lpBytecode;
  vm_TsStack* stack;

  // Last bucket of GC memory
  TsBucket* pLastBucket;
  // End of the capacity of the last bucket of GC memory
  uint16_t* pLastBucketEndCapacity;
  // Handles - values to treat as GC roots
  mvm_Handle* gc_handles;

  void* context;

  #if MVM_INCLUDE_DEBUG_CAPABILITY
  TsBreakpoint* pBreakpoints;
  mvm_TfBreakpointCallback breakpointCallback;
  #endif // MVM_INCLUDE_DEBUG_CAPABILITY

  uint16_t heapSizeUsedAfterLastGC;
  uint16_t stackHighWaterMark;
  uint16_t heapHighWaterMark;

  #if MVM_VERY_EXPENSIVE_MEMORY_CHECKS
  // Amount to shift the heap over during each collection cycle
  uint8_t gc_heap_shift;
  #endif

  #if MVM_SAFE_MODE
  // A number that increments at every possible opportunity for a GC cycle
  uint8_t gc_potentialCycleNumber;
  #endif // MVM_SAFE_MODE
};

typedef struct TsInternedStringCell {
  ShortPtr spNext;
  Value str;
} TsInternedStringCell;

// Possible values for the `flags` machine register
typedef enum vm_TeActivationFlags {
  // This is not an activation flag, but I'm putting it in this enum because it
  // shares the same bit space as the flags.
  AF_ARG_COUNT_MASK = 0x7F,

  // Note: these flags start at bit 8 because they use the same word as the
  // argument count and the high byte is used for flags, with the exception of
  // AF_VOID_CALLED which is in the first byte because the flag is bundled with
  // the argument count during a call operation.

  // Set to 1 in the current activation frame if the caller call site is a void
  // call (does not use the response). Note: this flag is in the high bit of the
  // first byte, unlike the other bits which are in the second byte. See above
  // for description.
  AF_VOID_CALLED = 1 << 7,

  // Flag to indicate if the most-recent CALL operation involved a stack-based
  // function target (as opposed to a literal function target). If this is set,
  // then the next RETURN instruction will also pop the function reference off
  // the stack.
  AF_PUSHED_FUNCTION = 1 << 8,

  // Flag to indicate that returning from the current frame should return to the host
  AF_CALLED_FROM_HOST = 1 << 9,
} vm_TeActivationFlags;

/**
 * This struct is malloc'd from the host when the host calls into the VM
 */
typedef struct vm_TsRegisters { // 26 B on 32-bit machine
  uint16_t* pFrameBase;
  uint16_t* pStackPointer;
  LongPtr lpProgramCounter;
  // Note: I previously used to infer the location of the arguments based on the
  // number of values PUSHed by a CALL instruction to preserve the activation
  // state (i.e. 3 words). But now that distance is dynamic, so we need and
  // explicit register.
  Value* pArgs;
  uint16_t argCountAndFlags; // Lower 8 bits are argument count, upper 8 bits are vm_TeActivationFlags
  Value closure; // Closure scope
  uint16_t catchTarget; // 0 if no catch block

  /**
   * Contains the asynchronous callback for the call of the current activation
   * record.
   *
   * - VM_VALUE_UNDEFINED - Normal call (no callback)
   * - VM_VALUE_DELETED - (poison value) value no longer holds the callback for
   *   the current activation (value has been trashed or consumed)
   * - Pointer to function - Directly after AsyncCall operation
   */
  Value cpsCallback;

  /**
   * The (promise) job queue, for scheduling async callbacks. One of 4 states:
   *
   *   - Unallocated (no registers) - no jobs
   *   - `undefined` means there are no promise jobs enqueued. The reason not to
   *     use `NULL` (0) is because this value is reachable by the garbage
   *     collector and so making it a consistent JavaScript value makes sense.
   *   - A function value: indicates there is only one job in the queue, and the
   *     `jobQueue` register points directly to it.
   *   - A fixed-length array of 3 values: a tuple of `[prev, job, next]` as a
   *     doubly-linked list node. Except that instead of a list, it forms a
   *     cycle, so that the back of the "list" can be reached in `O(1)` time as
   *     as the `prev` of the first item, without needing a second register to
   *     point to the back of the list.
   */
  Value jobQueue;

  #if MVM_SAFE_MODE
  // This will be true if the VM is operating on the local variables rather
  // than the shared vm_TsRegisters structure.
  uint8_t usingCachedRegisters;
  uint8_t _reserved; // My compiler seems to pad this out anyway
  #endif

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
  /* Followed by the bytecode bytes */
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

// A CALL instruction saves the current registers to the stack. I'm calling this
// the "frame boundary" since it is a fixed-size sequence of words that marks
// the boundary between stack frames. The shape of this saved state is coupled
// to a few different places in the engine, so I'm versioning it here in case I
// need to make changes
#define VM_FRAME_BOUNDARY_VERSION 2

// The number of words between one call stack frame and the next (i.e. the
// number of saved registers during a CALL)
#define VM_FRAME_BOUNDARY_SAVE_SIZE_WORDS 4

static inline mvm_HostFunctionID vm_getHostFunctionId(VM*vm, uint16_t hostFunctionIndex);
static TeError vm_createStackAndRegisters(VM* vm);
static TeError vm_requireStackSpace(VM* vm, uint16_t* pStackPointer, uint16_t sizeRequiredInWords);
static Value vm_convertToString(VM* vm, Value value);
static Value vm_concat(VM* vm, Value* left, Value* right);
static TeTypeCode deepTypeOf(VM* vm, Value value);
static bool vm_isString(VM* vm, Value value);
static int32_t vm_readInt32(VM* vm, TeTypeCode type, Value value);
static TeError vm_resolveExport(VM* vm, mvm_VMExportID id, Value* result);
static inline mvm_TfHostFunction* vm_getResolvedImports(VM* vm);
static void gc_createNextBucket(VM* vm, uint16_t bucketSize, uint16_t minBucketSize);
static void* gc_allocateWithHeader(VM* vm, uint16_t sizeBytes, TeTypeCode typeCode);
static void gc_freeGCMemory(VM* vm);
static Value vm_allocString(VM* vm, size_t sizeBytes, void** data);
static TeError getProperty(VM* vm, Value* pObjectValue, Value* pPropertyName, Value* out_propertyValue);
static TeError setProperty(VM* vm, Value* pOperands);
static TeError toPropertyName(VM* vm, Value* value);
static void toInternedString(VM* vm, Value* pValue);
static uint16_t vm_stringSizeUtf8(VM* vm, Value str);
static bool vm_ramStringIsNonNegativeInteger(VM* vm, Value str);
static TeError toInt32Internal(mvm_VM* vm, mvm_Value value, int32_t* out_result);
static inline uint16_t vm_getAllocationSizeExcludingHeaderFromHeaderWord(uint16_t headerWord);
static inline LongPtr LongPtr_add(LongPtr lp, int16_t offset);
static inline uint16_t LongPtr_read2_aligned(LongPtr lp);
static inline uint16_t LongPtr_read2_unaligned(LongPtr lp);
static void memcpy_long(void* target, LongPtr source, size_t size);
static void loadPointers(VM* vm, uint8_t* heapStart);
static inline ShortPtr ShortPtr_encode(VM* vm, void* ptr);
static inline uint8_t LongPtr_read1(LongPtr lp);
static LongPtr DynamicPtr_decode_long(VM* vm, DynamicPtr ptr);
static inline int16_t LongPtr_sub(LongPtr lp1, LongPtr lp2);
static inline uint16_t readAllocationHeaderWord(void* pAllocation);
static inline uint16_t readAllocationHeaderWord_long(LongPtr pAllocation);
static inline void* gc_allocateWithConstantHeader(VM* vm, uint16_t header, uint16_t sizeIncludingHeader);
static inline uint16_t vm_makeHeaderWord(VM* vm, TeTypeCode tc, uint16_t size);
static int memcmp_long(LongPtr p1, LongPtr p2, size_t size);
static LongPtr getBytecodeSection(VM* vm, mvm_TeBytecodeSection id, LongPtr* out_end);
static inline void* LongPtr_truncate(VM* vm, LongPtr lp);
static inline LongPtr LongPtr_new(void* p);
static inline uint16_t* getBottomOfStack(vm_TsStack* stack);
static inline uint16_t* getTopOfStackSpace(vm_TsStack* stack);
static inline void* getBucketDataBegin(TsBucket* bucket);
static uint16_t getBucketOffsetEnd(TsBucket* bucket);
static uint16_t getSectionSize(VM* vm, mvm_TeBytecodeSection section);
static Value vm_intToStr(VM* vm, int32_t i);
static Value vm_newStringFromCStrNT(VM* vm, const char* s);
static TeError vm_validatePortFileMacros(MVM_LONG_PTR_TYPE lpBytecode, mvm_TsBytecodeHeader* pHeader);
static LongPtr vm_toStringUtf8_long(VM* vm, Value value, size_t* out_sizeBytes);
static LongPtr vm_findScopedVariable(VM* vm, uint16_t index);
static Value vm_cloneContainer(VM* vm, Value* pArr);
static Value vm_safePop(VM* vm, Value* pStackPointerAfterDecr);
static LongPtr vm_getStringData(VM* vm, Value value);
static inline VirtualInt14 VirtualInt14_encode(VM* vm, int16_t i);
static inline TeTypeCode vm_getTypeCodeFromHeaderWord(uint16_t headerWord);
static bool DynamicPtr_isRomPtr(VM* vm, DynamicPtr dp);
static inline void vm_checkValueAccess(VM* vm, uint8_t potentialCycleNumber);
static inline uint16_t vm_getAllocationSize(void* pAllocation);
static inline uint16_t vm_getAllocationSize_long(LongPtr lpAllocation);
static inline TeTypeCode vm_getAllocationType(void* pAllocation);
static inline mvm_TeBytecodeSection vm_sectionAfter(VM* vm, mvm_TeBytecodeSection section);
static void* ShortPtr_decode(VM* vm, ShortPtr shortPtr);
static TeError vm_newError(VM* vm, TeError err);
static void* vm_malloc(VM* vm, size_t size);
static void vm_free(VM* vm, void* ptr);
static inline uint16_t* getTopOfStackSpace(vm_TsStack* stack);
static inline Value* getHandleTargetOrNull(VM* vm, Value value);
static TeError vm_objectKeys(VM* vm, Value* pObject);
static mvm_TeError vm_uint8ArrayNew(VM* vm, Value* slot);
static Value getBuiltin(VM* vm, mvm_TeBuiltins builtinID);
static uint16_t* vm_scopePushOrNew(VM* vm, int slotCount, bool captureParent);
static inline Value vm_encodeBytecodeOffsetAsPointer(VM* vm, uint16_t offset);
static void vm_enqueueJob(VM* vm, Value jobClosure);
static Value vm_dequeueJob(VM* vm);
static void* DynamicPtr_decode_native(VM* vm, DynamicPtr ptr);

#if MVM_SAFE_MODE
static inline uint16_t vm_getResolvedImportCount(VM* vm);
#endif // MVM_SAFE_MODE

static const Value smallLiterals[] = {
  /* VM_SLV_UNDEFINED */    VM_VALUE_DELETED,
  /* VM_SLV_UNDEFINED */    VM_VALUE_UNDEFINED,
  /* VM_SLV_NULL */         VM_VALUE_NULL,
  /* VM_SLV_FALSE */        VM_VALUE_FALSE,
  /* VM_SLV_TRUE */         VM_VALUE_TRUE,
  /* VM_SLV_INT_MINUS_1 */  VIRTUAL_INT14_ENCODE(-1),
  /* VM_SLV_INT_0 */        VIRTUAL_INT14_ENCODE(0),
  /* VM_SLV_INT_1 */        VIRTUAL_INT14_ENCODE(1),
  /* VM_SLV_INT_2 */        VIRTUAL_INT14_ENCODE(2),
  /* VM_SLV_INT_3 */        VIRTUAL_INT14_ENCODE(3),
  /* VM_SLV_INT_4 */        VIRTUAL_INT14_ENCODE(4),
  /* VM_SLV_INT_5 */        VIRTUAL_INT14_ENCODE(5),
};
#define smallLiteralsSize (sizeof smallLiterals / sizeof smallLiterals[0])

static const char PROTO_STR[] = "__proto__";
static const char LENGTH_STR[] = "length";

static const char TYPE_STRINGS[] =
  "undefined\0boolean\0number\0string\0function\0object\0symbol\0bigint";
// 0          10       18      25      32        41      48      55

// Character offsets into TYPE_STRINGS
static const uint8_t typeStringOffsetByType[VM_T_END] = {
  0 , /* VM_T_UNDEFINED   */
  41, /* VM_T_NULL        */
  10, /* VM_T_BOOLEAN     */
  18, /* VM_T_NUMBER      */
  25, /* VM_T_STRING      */
  32, /* VM_T_FUNCTION    */
  41, /* VM_T_OBJECT      */
  41, /* VM_T_ARRAY       */
  41, /* VM_T_UINT8_ARRAY */
  32, /* VM_T_CLASS       */
  48, /* VM_T_SYMBOL      */
  55, /* VM_T_BIG_INT     */
};

// TeTypeCode -> mvm_TeType
static const uint8_t typeByTC[TC_END] = {
  VM_T_END,         /* TC_REF_TOMBSTONE          */
  VM_T_NUMBER,      /* TC_REF_INT32              */
  VM_T_NUMBER,      /* TC_REF_FLOAT64            */
  VM_T_STRING,      /* TC_REF_STRING             */
  VM_T_STRING,      /* TC_REF_INTERNED_STRING    */
  VM_T_FUNCTION,    /* TC_REF_FUNCTION           */
  VM_T_FUNCTION,    /* TC_REF_HOST_FUNC          */
  VM_T_UINT8_ARRAY, /* TC_REF_UINT8_ARRAY        */
  VM_T_SYMBOL,      /* TC_REF_SYMBOL             */
  VM_T_CLASS,       /* TC_REF_CLASS              */
  VM_T_END,         /* TC_REF_VIRTUAL            */
  VM_T_END,         /* TC_REF_RESERVED_1         */
  VM_T_OBJECT,      /* TC_REF_PROPERTY_LIST      */
  VM_T_ARRAY,       /* TC_REF_ARRAY              */
  VM_T_ARRAY,       /* TC_REF_FIXED_LENGTH_ARRAY */
  VM_T_FUNCTION,    /* TC_REF_CLOSURE            */
  VM_T_NUMBER,      /* TC_VAL_INT14              */
  VM_T_UNDEFINED,   /* TC_VAL_UNDEFINED          */
  VM_T_NULL,        /* TC_VAL_NULL               */
  VM_T_BOOLEAN,     /* TC_VAL_TRUE               */
  VM_T_BOOLEAN,     /* TC_VAL_FALSE              */
  VM_T_NUMBER,      /* TC_VAL_NAN                */
  VM_T_NUMBER,      /* TC_VAL_NEG_ZERO           */
  VM_T_UNDEFINED,   /* TC_VAL_DELETED            */
  VM_T_STRING,      /* TC_VAL_STR_LENGTH         */
  VM_T_STRING,      /* TC_VAL_STR_PROTO          */
  VM_T_FUNCTION,    /* TC_VAL_NO_OP_FUNC         */
};

#define GC_ALLOCATE_TYPE(vm, type, typeCode) \
  (type*)gc_allocateWithConstantHeader(vm, vm_makeHeaderWord(vm, typeCode, sizeof (type)), 2 + sizeof (type))

#if MVM_SUPPORT_FLOAT
static int32_t mvm_float64ToInt32(MVM_FLOAT64 value);
#endif

// MVM_LOCAL declares a local variable whose value would become invalidated if
// the GC performs a cycle. All access to the local should use MVM_GET_LOCAL AND
// MVM_SET_LOCAL. This only needs to be used for pointer values or values that
// might hold a pointer.
#if MVM_SAFE_MODE
#define MVM_LOCAL(type, varName, initial) type varName ## Value = initial; uint8_t _ ## varName ## PotentialCycleNumber = vm->gc_potentialCycleNumber
#define MVM_GET_LOCAL(varName) (vm_checkValueAccess(vm, _ ## varName ## PotentialCycleNumber), varName ## Value)
#define MVM_SET_LOCAL(varName, value) varName ## Value = value; _ ## varName ## PotentialCycleNumber = vm->gc_potentialCycleNumber
#else
#define MVM_LOCAL(type, varName, initial) type varName = initial
#define MVM_GET_LOCAL(varName) (varName)
#define MVM_SET_LOCAL(varName, value) varName = value
#endif // MVM_SAFE_MODE

// Various things require the registers (vm->stack->reg) to be up to date
#define VM_ASSERT_NOT_USING_CACHED_REGISTERS(vm) \
  VM_ASSERT(vm, !vm->stack || !vm->stack->reg.usingCachedRegisters)

/**
 * (this used to be in the port file but I've moved it out because the semantics
 * may be confusing and are difficult to communicate clearly. See
 * https://github.com/coder-mike/microvium/issues/47)
 *
 * Set to 1 to enable overflow checking for 32 bit integers in compliance with
 * the ECMAScript standard (ES262).
 *
 * If set to 0, then operations on 32-bit signed integers have wrap-around
 * (overflow) behavior, like the typical runtime behavior when adding 32-bit
 * signed integers in C.
 *
 * Explanation: Microvium tries to use 32-bit integer arithmetic where possible,
 * because it's more efficient than the standard 64-bit floating point
 * operations, especially on small microcontrollers. To give the appearance of
 * 64-bit floating point, Microvium needs to check when the result of such
 * operations overflows the 32-bit range and needs to be re-calculated using
 * proper 64-bit floating point operations. These overflow checks can be
 * disabled to improve performance and reduce engine size.
 *
 * Example: `2_000_000_000 + 2_000_000_000` will add to:
 *
 *   - `4_000_000_000` if `MVM_PORT_INT32_OVERFLOW_CHECKS` is `1`
 *   - `-294_967_296` if `MVM_PORT_INT32_OVERFLOW_CHECKS` is `0`
 *
 */
#ifndef MVM_PORT_INT32_OVERFLOW_CHECKS
#define MVM_PORT_INT32_OVERFLOW_CHECKS 1
#endif
