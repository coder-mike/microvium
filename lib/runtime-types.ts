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
};

export enum ivm_TeTypeCode {
  // Note: only type code values in the range 0-15 can be used as the types for
  // allocations, since the allocation header allows 4 bits for the type

  // TODO: Prefix the reference types with TC_REF_

  // TC_NONE is used for allocations which are never addressable by a vm_Value,
  // and so their type will never be checked. This is only for internal data
  // structures.
  TC_NONE           = 0x0,

  // TODO: I think we can get rid of "virtual" and instead explicitly say "struct" or "class"
  TC_STRUCT         = 0x1, // Allocation with VTable reference

  TC_INT32          = 0x2,
  TC_DOUBLE         = 0x3,

  /**
   * UTF8-encoded string that may or may not be unique.
   *
   * If a TC_STRING is in bytecode, it is because it encodes a value that is
   * illegal as a property index in Microvium (i.e. it encodes an integer).
   *
   */
  TC_STRING         = 0x4,

  /**
   * A string whose address uniquely identifies its contents, and does not
   * encode an integer in the range 0 to 0x1FFF
   */
  TC_UNIQUE_STRING  = 0x6,

  TC_PROPERTY_LIST  = 0x7, // Object represented as linked list of properties
  TC_LIST           = 0x8, // Array represented as linked list
  TC_TUPLE          = 0x9, // Array represented as contiguous block of memory
  TC_FUNCTION       = 0xA, // Local function
  TC_HOST_FUNC      = 0xB, // External function by index in import table
  TC_BIG_INT        = 0xC, // Reserved
  TC_SYMBOL         = 0xD, // Reserved
  TC_RESERVED_1     = 0xE, // Reserved
  TC_RESERVED_2     = 0xF, // Reserved

  // Well-known values
  TC_UNDEFINED     = 0x10,
  TC_NULL          = 0x11,
  TC_TRUE          = 0x12,
  TC_FALSE         = 0x13,
  // TODO I'm thinking of getting rid of the special cases for floating point,
  // since the floating point library or hardware support should already handle
  // these
  TC_NAN           = 0x15,
  TC_NEG_ZERO      = 0x18,

  TC_DELETED       = 0x19, // Placeholder for properties and list items that have been deleted or holes in arrays

  // Value types
  TC_INT14         = 0x20,
};


// 4-bit enum
export enum vm_TeOpcode {
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
}

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

export const VM_RETURN_FLAG_POP_FUNCTION = (1 << 0)
export const VM_RETURN_FLAG_UNDEFINED =    (1 << 1)

// 4-bit enum
export enum vm_TeOpcodeEx1 {
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
  VM_OP2_OBJECT_NEW          = 0xD,
};

// 4-bit enum
export enum vm_TeOpcodeEx2 {
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
  VM_OP2_CALL_3              = 0xC, // (+ 8-bit arg count. target is dynamic)
};

// 4-bit enum
export enum vm_TeOpcodeEx3 {
  VM_OP3_CALL_2              = 0x0, // (+ 16-bit function offset + 8-bit arg count)
  VM_OP3_JUMP_2              = 0x1, // (+ 16-bit signed offset)
  VM_OP3_BRANCH_2            = 0x2, // (+ 16-bit signed offset)
  VM_OP3_LOAD_LITERAL        = 0x3, // (+ 16-bit value)
  VM_OP3_LOAD_GLOBAL_3       = 0x4, // (+ 16-bit global variable index)
  VM_OP3_STORE_GLOBAL_3      = 0x5, // (+ 16-bit global variable index)
  VM_OP3_OBJECT_GET_2        = 0x4, // (+ 16-bit uniqued string reference)
  VM_OP3_OBJECT_SET_2        = 0x5, // (+ 16-bit uniqued string reference)
};

// 8-bit enum
export enum vm_TeOpcodeEx4 {
  VM_OP4_CALL_DETACHED_EPHEMERAL = 0x0, // (No parameters) Represents the calling of an ephemeral that existed in a previous epoch
};

// 4-bit enum
export enum vm_TeBinOp1 {
  VM_BOP1_ADD            = 0x0,

  VM_BOP1_SUBTRACT       = 0x1,
  VM_BOP1_MULTIPLY       = 0x2,
  VM_BOP1_DIVIDE         = 0x3,
  VM_BOP1_REMAINDER      = 0x4,
  VM_BOP1_POWER          = 0x5,

  VM_BOP1_SHR_ARITHMETIC = 0x6,
  VM_BOP1_SHR_BITWISE    = 0x7,
  VM_BOP1_SHL            = 0x8,
  VM_BOP1_BITWISE_OR     = 0x9,
  VM_BOP1_BITWISE_AND    = 0xA,
  VM_BOP1_BITWISE_XOR    = 0xB,
};

// 4-bit enum
export enum vm_TeBinOp2 {
  VM_BOP2_LESS_THAN      = 0x0,
  VM_BOP2_GREATER_THAN   = 0x1,
  VM_BOP2_LESS_EQUAL     = 0x2,
  VM_BOP2_GREATER_EQUAL  = 0x3,

  VM_BOP2_EQUAL          = 0x4,
  VM_BOP2_NOT_EQUAL      = 0x5,

  VM_BOP2_AND            = 0x6,
  VM_BOP2_OR             = 0x7,
};

// 4-bit enum
export enum vm_TeUnOp {
  VM_UOP_NEGATE           = 0x0,
  VM_UOP_UNARY_PLUS       = 0x1,

  VM_UOP_LOGICAL_NOT      = 0x2,

  VM_UOP_BITWISE_NOT      = 0x3,
};

// 4-bit enum
export enum vm_TeSmallLiteralValue {
  VM_SLV_NULL            = 0x0,
  VM_SLV_UNDEFINED       = 0x1,
  VM_SLV_FALSE           = 0x2,
  VM_SLV_TRUE            = 0x3,
  VM_SLV_EMPTY_STRING    = 0x4,
  VM_SLV_INT_0           = 0x5,
  VM_SLV_INT_1           = 0x6,
  VM_SLV_INT_2           = 0x7,
  VM_SLV_INT_MINUS_1     = 0x8,
};

// Tag values
export enum vm_TeValueTag {
  VM_TAG_INT    =  0x0000,
  VM_TAG_GC_P   =  0x4000,
  VM_TAG_DATA_P =  0x8000,
  VM_TAG_PGM_P  =  0xC000,
};

export enum vm_TeWellKnownValues {
  VM_VALUE_UNDEFINED     = (vm_TeValueTag.VM_TAG_PGM_P | ivm_TeTypeCode.TC_UNDEFINED),
  VM_VALUE_NULL          = (vm_TeValueTag.VM_TAG_PGM_P | ivm_TeTypeCode.TC_NULL),
  VM_VALUE_TRUE          = (vm_TeValueTag.VM_TAG_PGM_P | ivm_TeTypeCode.TC_TRUE),
  VM_VALUE_FALSE         = (vm_TeValueTag.VM_TAG_PGM_P | ivm_TeTypeCode.TC_FALSE),
  VM_VALUE_NAN           = (vm_TeValueTag.VM_TAG_PGM_P | ivm_TeTypeCode.TC_NAN),
  VM_VALUE_NEG_ZERO      = (vm_TeValueTag.VM_TAG_PGM_P | ivm_TeTypeCode.TC_NEG_ZERO),
  VM_VALUE_DELETED       = (vm_TeValueTag.VM_TAG_PGM_P | ivm_TeTypeCode.TC_DELETED),
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
