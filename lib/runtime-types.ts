import { hardAssert } from "./utils";

export type UInt4 = number;
export type UInt8 = number;
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
  MVM_E_SUCCESS,
  MVM_E_UNEXPECTED,
  MVM_E_MALLOC_FAIL,
  MVM_E_ALLOCATION_TOO_LARGE,
  MVM_E_INVALID_ADDRESS,
  MVM_E_COPY_ACROSS_BUCKET_BOUNDARY,
  MVM_E_FUNCTION_NOT_FOUND,
  MVM_E_INVALID_HANDLE,
  MVM_E_STACK_OVERFLOW,
  MVM_E_UNRESOLVED_IMPORT,
  MVM_E_ATTEMPT_TO_WRITE_TO_ROM,
  MVM_E_INVALID_ARGUMENTS,
  MVM_E_TYPE_ERROR,
  MVM_E_TARGET_NOT_CALLABLE,
  MVM_E_HOST_ERROR,
  MVM_E_NOT_IMPLEMENTED,
  MVM_E_HOST_RETURNED_INVALID_VALUE,
  MVM_E_ASSERTION_FAILED,
  MVM_E_INVALID_BYTECODE,
  MVM_E_UNRESOLVED_EXPORT,
  MVM_E_RANGE_ERROR,
  MVM_E_DETACHED_EPHEMERAL,
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
};

export enum mvm_TeType {
  VM_T_UNDEFINED,
  VM_T_NULL,
  VM_T_BOOLEAN,
  VM_T_NUMBER,
  VM_T_STRING,
  VM_T_BIG_INT,
  VM_T_SYMBOL,
  VM_T_FUNCTION,
  VM_T_OBJECT,
  VM_T_ARRAY,
};

export enum mvm_TeBuiltins {
  BIN_UNIQUE_STRINGS,
  BIN_ARRAY_PROTO,

  BIN_BUILTIN_COUNT
};

export enum vm_TeWellKnownValues {
  VM_VALUE_UNDEFINED     = (TeTypeCode.TC_VAL_UNDEFINED << 2) | 1,
  VM_VALUE_NULL          = (TeTypeCode.TC_VAL_NULL << 2) | 1,
  VM_VALUE_TRUE          = (TeTypeCode.TC_VAL_TRUE << 2) | 1,
  VM_VALUE_FALSE         = (TeTypeCode.TC_VAL_FALSE << 2) | 1,
  VM_VALUE_NAN           = (TeTypeCode.TC_VAL_NAN << 2) | 1,
  VM_VALUE_NEG_ZERO      = (TeTypeCode.TC_VAL_NEG_ZERO << 2) | 1,
  VM_VALUE_DELETED       = (TeTypeCode.TC_VAL_DELETED << 2) | 1,
  VM_VALUE_STR_LENGTH    = (TeTypeCode.TC_VAL_STR_LENGTH << 2) | 1,
  VM_VALUE_STR_PROTO     = (TeTypeCode.TC_VAL_STR_PROTO << 2) | 1,

  VM_VALUE_WELLKNOWN_END
};

export function isUInt4(value: number): boolean {
  return (value | 0) === value
    && value >= 0
    && value <= 0xF;
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
   * List of host function IDs which are called by the VM. References from the
   * VM to host functions are represented as indexes into this table. These IDs
   * are resolved to their corresponding host function pointers when a VM is
   * restored.
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
   * To make the representation of function calls in IL more compact, up to 16
   * of the most frequent function calls are listed in this table, including the
   * function target and the argument count.
   *
   * See VM_OP_CALL_1
   */
  // WIP make sure that this table is padded
  BCS_SHORT_CALL_TABLE,

  /**
   * Builtins
   *
   * Table of `Value`s that need to be directly identifyable by the engine, such
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
  // WIP update encoder/decoder
  // WIP make sure that this table is padded
  BCS_BUILTINS,

  /**
   * Unique String Table
   *
   * To keep property lookup efficient, Microvium requires that strings used as
   * property keys can be compared using pointer equality. This requires that
   * there is only one instance of each string. This table is the alphabetical
   * listing of all the strings in ROM (or at least, all those which are valid
   * property keys). See also TC_REF_UNIQUE_STRING.
   *
   * There may be two string tables: one in ROM and one in RAM. The latter is
   * required in general if the program might use arbitrarily-computed strings.
   * For efficiency, the ROM string table is contiguous and sorted, to allow for
   * binary searching, while the RAM string table is a linked list for
   * efficiency in appending (expected to be used only occasionally).
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
