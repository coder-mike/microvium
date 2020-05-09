import { assert } from "./utils";

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

export const UInt4 = (n: UInt4): UInt4 => (assert(isUInt4(n)), n);
export const UInt8 = (n: UInt8): UInt8 => (assert(isUInt8(n)), n);
export const UInt12 = (n: UInt12): UInt12 => (assert(isUInt12(n)), n);
export const UInt14 = (n: UInt14): UInt14 => (assert(isUInt14(n)), n);
export const UInt16 = (n: UInt16): UInt16 => (assert(isUInt16(n)), n);
export const UInt32 = (n: UInt32): UInt32 => (assert(isUInt32(n)), n);
export const SInt8 = (n: SInt8): SInt8 => (assert(isSInt8(n)), n);
export const SInt14 = (n: SInt14): SInt14 => (assert(isSInt14(n)), n);
export const SInt16 = (n: SInt16): SInt16 => (assert(isSInt16(n)), n);
export const SInt32 = (n: SInt32): SInt32 => (assert(isSInt32(n)), n);

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
 * Value types are for the values that can be represented within the 16-bit
 * mvm_Value without interpreting it as a pointer.
 */
export enum TeTypeCode {
  // Note: only type code values in the range 0-15 can be used as the types for
  // allocations, since the allocation header allows 4 bits for the type

  /* --------------------------- Reference types --------------------------- */

  // TC_REF_NONE is used for allocations which are never addressable by a vm_Value,
  // and so their type will never be checked. This is only for internal data
  // structures.
  TC_REF_NONE           = 0x0,

  TC_REF_INT32          = 0x1, // 32-bit signed integer
  TC_REF_FLOAT64         = 0x2, // 64-bit float

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

  TC_REF_PROPERTY_LIST  = 0x5, // Object represented as linked list of properties
  TC_REF_LIST           = 0x6, // Array represented as linked list
  TC_REF_TUPLE          = 0x7, // Array represented as contiguous block of memory
  TC_REF_FUNCTION       = 0x8, // Local function
  TC_REF_HOST_FUNC      = 0x9, // External function by index in import table
  // Structs are records with a fixed set of fields, and the field keys are
  // stored separately (TODO: Some work is required on refining these).
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
}

// Tag values
export enum vm_TeValueTag {
  VM_TAG_INT    =  0x0000,
  VM_TAG_GC_P   =  0x4000,
  VM_TAG_DATA_P =  0x8000,
  VM_TAG_PGM_P  =  0xC000,
};

export enum vm_TeWellKnownValues {
  VM_VALUE_UNDEFINED     = (vm_TeValueTag.VM_TAG_PGM_P | TeTypeCode.TC_VAL_UNDEFINED),
  VM_VALUE_NULL          = (vm_TeValueTag.VM_TAG_PGM_P | TeTypeCode.TC_VAL_NULL),
  VM_VALUE_TRUE          = (vm_TeValueTag.VM_TAG_PGM_P | TeTypeCode.TC_VAL_TRUE),
  VM_VALUE_FALSE         = (vm_TeValueTag.VM_TAG_PGM_P | TeTypeCode.TC_VAL_FALSE),
  VM_VALUE_NAN           = (vm_TeValueTag.VM_TAG_PGM_P | TeTypeCode.TC_VAL_NAN),
  VM_VALUE_NEG_ZERO      = (vm_TeValueTag.VM_TAG_PGM_P | TeTypeCode.TC_VAL_NEG_ZERO),
  VM_VALUE_DELETED       = (vm_TeValueTag.VM_TAG_PGM_P | TeTypeCode.TC_VAL_DELETED),
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
