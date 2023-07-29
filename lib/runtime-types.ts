import { hardAssert } from "./utils";

export type UInt4 = number;
export type UInt8 = number;
export type UInt7 = number;
export type UInt12 = number;
export type UInt14 = number;
export type UInt16 = number;
export type UInt32 = number;
export type SInt4 = number;
export type SInt8 = number;
export type SInt12 = number;
export type SInt14 = number;
export type SInt16 = number;
export type SInt32 = number;

export const UInt4 = (n: UInt4): UInt4 => (hardAssert(isUInt4(n)), n);
export const UInt7 = (n: UInt7): UInt8 => (hardAssert(isUInt7(n)), n);
export const UInt8 = (n: UInt8): UInt8 => (hardAssert(isUInt8(n)), n);
export const UInt12 = (n: UInt12): UInt12 => (hardAssert(isUInt12(n)), n);
export const UInt14 = (n: UInt14): UInt14 => (hardAssert(isUInt14(n)), n);
export const UInt16 = (n: UInt16): UInt16 => (hardAssert(isUInt16(n)), n);
export const UInt32 = (n: UInt32): UInt32 => (hardAssert(isUInt32(n)), n);
export const SInt8 = (n: SInt8): SInt8 => (hardAssert(isSInt8(n)), n);
export const SInt14 = (n: SInt14): SInt14 => (hardAssert(isSInt14(n)), n);
export const SInt16 = (n: SInt16): SInt16 => (hardAssert(isSInt16(n)), n);
export const SInt32 = (n: SInt32): SInt32 => (hardAssert(isSInt32(n)), n);

export type mvm_Value = UInt16;
export type vm_Reference = mvm_Value;
export type vm_VMExportID = UInt16;
export type vm_HostFunctionID = UInt16;

export enum mvm_TeError {
  /*  0 */ MVM_E_SUCCESS,
  /*  1 */ MVM_E_UNEXPECTED,
  /*  2 */ MVM_E_MALLOC_FAIL,
  /*  3 */ MVM_E_ALLOCATION_TOO_LARGE,
  /*  4 */ MVM_E_INVALID_ADDRESS,
  /*  5 */ MVM_E_COPY_ACROSS_BUCKET_BOUNDARY,
  /*  6 */ MVM_E_FUNCTION_NOT_FOUND,
  /*  7 */ MVM_E_INVALID_HANDLE,
  /*  8 */ MVM_E_STACK_OVERFLOW,
  /*  9 */ MVM_E_UNRESOLVED_IMPORT,
  /* 10 */ MVM_E_ATTEMPT_TO_WRITE_TO_ROM,
  /* 11 */ MVM_E_INVALID_ARGUMENTS,
  /* 12 */ MVM_E_TYPE_ERROR,
  /* 13 */ MVM_E_TARGET_NOT_CALLABLE,
  /* 14 */ MVM_E_HOST_ERROR,
  /* 15 */ MVM_E_NOT_IMPLEMENTED,
  /* 16 */ MVM_E_HOST_RETURNED_INVALID_VALUE,
  /* 17 */ MVM_E_ASSERTION_FAILED,
  /* 18 */ MVM_E_INVALID_BYTECODE,
  /* 19 */ MVM_E_UNRESOLVED_EXPORT,
  /* 20 */ MVM_E_RANGE_ERROR,
  /* 21 */ MVM_E_DETACHED_EPHEMERAL,
  /* 22 */ MVM_E_TARGET_IS_NOT_A_VM_FUNCTION,
  /* 23 */ MVM_E_FLOAT64,
  /* 24 */ MVM_E_NAN,
  /* 25 */ MVM_E_NEG_ZERO,
  /* 26 */ MVM_E_OPERATION_REQUIRES_FLOAT_SUPPORT,
  /* 27 */ MVM_E_BYTECODE_CRC_FAIL,
  /* 28 */ MVM_E_BYTECODE_REQUIRES_FLOAT_SUPPORT,
  /* 29 */ MVM_E_PROTO_IS_READONLY, // The __proto__ property of objects and arrays is not mutable
  /* 30 */ MVM_E_SNAPSHOT_TOO_LARGE, // The resulting snapshot does not fit in the 64kB boundary
  /* 31 */ MVM_E_MALLOC_MUST_RETURN_POINTER_TO_EVEN_BOUNDARY,
  /* 32 */ MVM_E_ARRAY_TOO_LONG,
  /* 33 */ MVM_E_OUT_OF_MEMORY, // Allocating a new block of memory from the host causes it to exceed MVM_MAX_HEAP_SIZE
  /* 34 */ MVM_E_TOO_MANY_ARGUMENTS, // Exceeded the maximum number of arguments for a function (255)
  /* 35 */ MVM_E_REQUIRES_LATER_ENGINE, // Please update your microvium.h and microvium.c files
  /* 36 */ MVM_E_PORT_FILE_VERSION_MISMATCH, // Please migrate your port file to the required version
  /* 37 */ MVM_E_PORT_FILE_MACRO_TEST_FAILURE, // Something in microvium_port.h doesn't behave as expected
  /* 38 */ MVM_E_EXPECTED_POINTER_SIZE_TO_BE_16_BIT, // MVM_NATIVE_POINTER_IS_16_BIT is 1 but pointer size is not 16-bit
  /* 39 */ MVM_E_EXPECTED_POINTER_SIZE_NOT_TO_BE_16_BIT, // MVM_NATIVE_POINTER_IS_16_BIT is 0 but pointer size is 16-bit
  /* 40 */ MVM_E_TYPE_ERROR_TARGET_IS_NOT_CALLABLE, // The script tried to call something that wasn't a function
  /* 41 */ MVM_E_TDZ_ERROR, // The script tried to access a local variable before its declaration
  /* 42 */ MVM_E_MALLOC_NOT_WITHIN_RAM_PAGE, // See instructions in example port file at the defitions MVM_USE_SINGLE_RAM_PAGE and MVM_RAM_PAGE_ADDR
  /* 43 */ MVM_E_INVALID_ARRAY_INDEX, // Array indexes must be integers in the range 0 to 8191
  /* 44 */ MVM_E_UNCAUGHT_EXCEPTION, // The script threw an exception with `throw` that was wasn't caught before returning to the host
  /* 45 */ MVM_E_FATAL_ERROR_MUST_KILL_VM, // Please make sure that MVM_FATAL_ERROR does not return, or bad things can happen. (Kill the process, the thread, or use longjmp)
  /* 46 */ MVM_E_OBJECT_KEYS_ON_NON_OBJECT, // Can only use Reflect.ownKeys on plain objects (not functions, arrays, or other values)
  /* 47 */ MVM_E_INVALID_UINT8_ARRAY_LENGTH, // Either non-numeric or out-of-range argument for creating a Uint8Array
  /* 48 */ MVM_E_CAN_ONLY_ASSIGN_BYTES_TO_UINT8_ARRAY, // Value assigned to index of Uint8Array must be an integer in the range 0 to 255
  /* 49 */ MVM_E_WRONG_BYTECODE_VERSION, // The version of bytecode is different to what the engine supports
  /* 50 */ MVM_E_USING_NEW_ON_NON_CLASS, // The `new` operator can only be used on classes
  /* 51 */ MVM_E_REQUIRES_ACTIVE_VM, // The given operation requires that the VM has active calls on the stack
  /* 52 */ MVM_E_ASYNC_START_ERROR, // mvm_asyncStart must be called exactly once at the beginning of a host function that is called from JS
};


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
export enum TeTypeCode {
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
};

export enum mvm_TeType {
  VM_T_UNDEFINED   = 0,
  VM_T_NULL        = 1,
  VM_T_BOOLEAN     = 2,
  VM_T_NUMBER      = 3,
  VM_T_STRING      = 4,
  VM_T_FUNCTION    = 5,
  VM_T_OBJECT      = 6,
  VM_T_ARRAY       = 7,
  VM_T_UINT8_ARRAY = 8,
  VM_T_CLASS       = 9,
  VM_T_SYMBOL      = 10, // Reserved
  VM_T_BIG_INT     = 11, // Reserved

  VM_T_END,
};

export enum mvm_TeBuiltins {
  BIN_INTERNED_STRINGS,
  BIN_ARRAY_PROTO,
  BIN_STR_PROTOTYPE, // If the string "prototype" is interned, this builtin points to it.
  BIN_ASYNC_COMPLETE, // A function used to construct a closure for the job queue to complete async operations
  BIN_ASYNC_CATCH_BLOCK, // A block, bundled as a function, for the root try-catch in async functions
  BIN_ASYNC_HOST_CALLBACK, // Bytecode to use as the callback for host async operations

  BIN_BUILTIN_COUNT
};

export enum vm_TeWellKnownValues {
  VM_VALUE_UNDEFINED     = ((TeTypeCode.TC_VAL_UNDEFINED - 0x11) << 2) | 1,
  VM_VALUE_NULL          = ((TeTypeCode.TC_VAL_NULL - 0x11) << 2) | 1,
  VM_VALUE_TRUE          = ((TeTypeCode.TC_VAL_TRUE - 0x11) << 2) | 1,
  VM_VALUE_FALSE         = ((TeTypeCode.TC_VAL_FALSE - 0x11) << 2) | 1,
  VM_VALUE_NAN           = ((TeTypeCode.TC_VAL_NAN - 0x11) << 2) | 1,
  VM_VALUE_NEG_ZERO      = ((TeTypeCode.TC_VAL_NEG_ZERO - 0x11) << 2) | 1,
  VM_VALUE_DELETED       = ((TeTypeCode.TC_VAL_DELETED - 0x11) << 2) | 1,
  VM_VALUE_STR_LENGTH    = ((TeTypeCode.TC_VAL_STR_LENGTH - 0x11) << 2) | 1,
  VM_VALUE_STR_PROTO     = ((TeTypeCode.TC_VAL_STR_PROTO - 0x11) << 2) | 1,
  VM_VALUE_NO_OP_FUNC    = ((TeTypeCode.TC_VAL_NO_OP_FUNC - 0x11) << 2) | 1,

  VM_VALUE_WELLKNOWN_END
};

export function isUInt4(value: number): boolean {
  return (value | 0) === value
    && value >= 0
    && value <= 0xF;
}

export function isUInt7(value: number): boolean {
  return (value | 0) === value
    && value >= 0
    && value <= 0x7F;
}

export function isSInt8(value: number): boolean {
  return (value | 0) === value
    && value >= -0x80
    && value <= 0x7F;
}

export function isUInt8(value: number): boolean {
  return (value | 0) === value
    && value >= 0
    && value <= 0xFF;
}

export function isUInt12(value: number): boolean {
  return (value | 0) === value
    && value >= 0
    && value <= 0xFFF;
}

export function isSInt14(value: number): boolean {
  return (value | 0) === value
    && value >= -0x2000
    && value <= 0x1FFF;
}

export function isUInt14(value: number): boolean {
  return (value | 0) === value
    && value >= 0x0000
    && value <= 0x3FFF;
}

export function isUInt16(value: number): boolean {
  return (value | 0) === value
    && value >= 0
    && value <= 0xFFFF;
}

export function isSInt16(value: number): boolean {
  return (value | 0) === value
    && value >= -0x8000
    && value <= 0x7FFF;
}

export function isSInt32(value: number): boolean {
  return (value | 0) === value;
}


export function isUInt32(value: number): boolean {
  return typeof value === 'number'
    && Math.round(value) === value
    && value >= 0
    && value <= 0xFFFF_FFFF
}

// These sections appear in the bytecode in the order they appear in this
// enumeration.
export enum mvm_TeBytecodeSection {
  /**
   * Import Table
   *
   * List of host function IDs (vm_TsImportTableEntry) which are called by the
   * VM. References from the VM to host functions are represented as indexes
   * into this table. These IDs are resolved to their corresponding host
   * function pointers when a VM is restored.
   */
  BCS_IMPORT_TABLE,

  /**
   * A list of immutable `vm_TsExportTableEntry` that the VM exports, mapping
   * export IDs to their corresponding VM Value. Mostly these values will just
   * be function pointers.
   */
  // TODO: We need to test what happens if we export numbers and objects
  BCS_EXPORT_TABLE,

  /**
   * Short Call Table. Table of vm_TsShortCallTableEntry.
   *
   * To make the representation of function calls in IL more compact, up to 256
   * of the most frequent function calls are listed in this table, including the
   * function target and the argument count.
   *
   * See `LBL_CALL_SHORT`
   */
  BCS_SHORT_CALL_TABLE,

  /**
   * Builtins
   *
   * See `mvm_TeBuiltins`
   *
   * Table of `Value`s that need to be directly identifiable by the engine, such
   * as the Array prototype.
   *
   * These are not copied into RAM, they are just constant values like the
   * exports, but like other values in ROM they are permitted to hold mutable
   * values by pointing (as BytecodeMappedPtr) to the corresponding global
   * variable slot.
   *
   * Note: at one point, I had these as single-byte offsets into the global
   * variable space, but this made the assumption that all accessible builtins
   * are also mutable, which is probably not true. The new design makes the
   * opposite assumption: most builtins will be immutable at runtime (e.g.
   * nobody changes the array prototype), so they can be stored in ROM and
   * referenced by immutable Value pointers, making them usable but not
   * consuming RAM at all. It's the exception rather than the rule that some of
   * these may be mutable and require indirection through the global slot table.
   */
  BCS_BUILTINS,

  /**
   * Interned Strings Table
   *
   * To keep property lookup efficient, Microvium requires that strings used as
   * property keys can be compared using pointer equality. This requires that
   * there is only one instance of each string (see
   * https://en.wikipedia.org/wiki/String_interning). This table is the
   * alphabetical listing of all the strings in ROM (or at least, all those
   * which are valid property keys). See also TC_REF_INTERNED_STRING.
   *
   * There may be two string tables: one in ROM and one in RAM. The latter is
   * required in general if the program might use arbitrarily-computed strings
   * as property keys. For efficiency, the ROM string table is contiguous and
   * sorted, to allow for binary searching, while the RAM string table is a
   * linked list for efficiency in appending (expected to be used only
   * occasionally).
   */
  BCS_STRING_TABLE,

  /**
   * Functions and other immutable data structures.
   *
   * While the whole bytecode is essentially "ROM", only this ROM section
   * contains addressable allocations.
   */
  BCS_ROM,

  /**
   * Globals
   *
   * One `Value` entry for the initial value of each global variable. The number
   * of global variables is determined by the size of this section.
   *
   * This section will be copied into RAM at startup (restore).
   *
   * Note: the global slots are used both for global variables and for "handles"
   * (these are different to the user-defined handles for referencing VM objects
   * from user space). Handles allow ROM allocations to reference RAM
   * allocations, even though the ROM can't be updated when the RAM allocation
   * moves during a GC collection. A handle is a slot in the "globals" space,
   * where the slot itself is pointed to by a ROM value and it points to the
   * corresponding RAM value. During a GC cycle, the RAM value may move and the
   * handle slot is updated, but the handle slot itself doesn't move. See
   * `offsetToDynamicPtr` in `encode-snapshot.ts`.
   *
   * The handles appear as the *last* global slots, and will generally not be
   * referenced by `LOAD_GLOBAL` instructions.
   */
  BCS_GLOBALS,

  /**
   * Heap Section: heap allocations.
   *
   * This section is copied into RAM when the VM is restored. It becomes the
   * initial value of the GC heap. It contains allocations that are mutable
   * (like the DATA section) but also subject to garbage collection.
   *
   * Note: the heap must be at the end, because it is the only part that changes
   * size from one snapshot to the next. There is code that depends on this
   * being the last section because the size of this section is computed as
   * running to the end of the bytecode image.
   */
  BCS_HEAP,

  BCS_SECTION_COUNT,
};