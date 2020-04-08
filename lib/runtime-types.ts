export type UInt4 = number;
export type UInt8 = number;
export type UInt12 = number;
export type UInt14 = number;
export type UInt16 = number;
export type UInt32 = number;
export type Int4 = number;
export type Int8 = number;
export type Int12 = number;
export type Int14 = number;
export type Int16 = number;
export type Int32 = number;

export type vm_Value = UInt16;
export type vm_Reference = vm_Value;
export type vm_VMExportID = UInt16;

// 4-bit enum
export enum vm_TeOpcode {
  VM_OP_LOAD_SMALL_LITERAL  = 0x0, // (+ 4-bit vm_TeSmallLiteralValue)

  VM_OP_LOAD_VAR_1          = 0x1, // (+ 4-bit variable index relative to stack pointer)
  VM_OP_STORE_VAR_1         = 0x2, // (+ 4-bit variable index relative to stack pointer)

  VM_OP_LOAD_GLOBAL_1       = 0x3, // (+ 4-bit global variable index)
  VM_OP_STORE_GLOBAL_1      = 0x4, // (+ 4-bit global variable index)

  VM_OP_LOAD_ARG_1          = 0x5, // (+ 4-bit arg index)

  VM_OP_CALL_1              = 0x6, // (+ 4-bit index into short-call table)

  VM_OP_BINOP_1             = 0x7, // (+ 4-bit vm_TeBinOp1)
  VM_OP_BINOP_2             = 0x8, // (+ 4-bit vm_TeBinOp2)
  VM_OP_UNOP                = 0x9, // (+ 4-bit vm_TeUnOp)

  VM_OP_STRUCT_GET_1        = 0xA, // (+ 4-bit field index)
  VM_OP_STRUCT_SET_1        = 0xB, // (+ 4-bit field index)

  VM_OP_EXTENDED_1          = 0xC, // (+ 4-bit vm_TeOpcodeEx1)
  VM_OP_EXTENDED_2          = 0xD, // (+ 4-bit vm_TeOpcodeEx2)
  VM_OP_EXTENDED_3          = 0xE, // (+ 4-bit vm_TeOpcodeEx3)
};

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

// 4-bit enum
export enum vm_TeBinOp1 {
  VM_BOP1_ADD            = 0x0,
  VM_BOP1_SUBTRACT       = 0x1,
  VM_BOP1_MULTIPLY       = 0x2,
  VM_BOP1_DIVIDE_INT     = 0x3,
  VM_BOP1_DIVIDE_FLOAT   = 0x4,
  VM_BOP1_SHR_ARITHMETIC = 0x5,
  VM_BOP1_SHR_BITWISE    = 0x6,
  VM_BOP1_SHL            = 0x7,
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
  VM_OP_NEGATE           = 0x0,
  VM_OP_LOGICAL_NOT      = 0x1,
  VM_OP_BITWISE_NOT      = 0x2,
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
  VM_VALUE_UNDEFINED    = vm_TeValueTag.VM_TAG_PGM_P | 0,
  VM_VALUE_NULL         = vm_TeValueTag.VM_TAG_PGM_P | 1,
  VM_VALUE_TRUE         = vm_TeValueTag.VM_TAG_PGM_P | 2,
  VM_VALUE_FALSE        = vm_TeValueTag.VM_TAG_PGM_P | 3,
  VM_VALUE_EMPTY_STRING = vm_TeValueTag.VM_TAG_PGM_P | 4,
  VM_VALUE_NAN          = vm_TeValueTag.VM_TAG_PGM_P | 5,
  VM_VALUE_INF          = vm_TeValueTag.VM_TAG_PGM_P | 6,
  VM_VALUE_NEG_INF      = vm_TeValueTag.VM_TAG_PGM_P | 7,
  VM_VALUE_NEG_ZERO     = vm_TeValueTag.VM_TAG_PGM_P | 8,
  VM_VALUE_DELETED      = vm_TeValueTag.VM_TAG_PGM_P | 9, // Placeholder for properties and list items that have been deleted
};

export enum vm_TeMetaType {
  VM_MT_STRUCT  = 0x1,
};

export enum vm_TeTypeCode {
  VM_TC_CELL           = 0x0, // Boxed value
  VM_TC_VIRTUAL        = 0x1, // Allocation with VTable reference
  VM_TC_INT24          = 0x2,
  VM_TC_INT32          = 0x3,
  VM_TC_DOUBLE         = 0x4,
  VM_TC_STRING         = 0x5, // UTF8-encoded string
  VM_TC_UNIQUED_STRING = 0x6, // A string whose address uniquely identifies its contents
  VM_TC_PROPERTY_LIST  = 0x7, // Object represented as linked list of properties
  VM_TC_LIST           = 0x8, // Array represented as linked list
  VM_TC_ARRAY          = 0x9, // Array represented as contiguous block of memory
  VM_TC_FUNCTION       = 0xA, // Local function
  VM_TC_EXT_FUNC       = 0xB, // External function by index in import table
  VM_TC_BIG_INT        = 0xC, // Reserved
  VM_TC_SYMBOL         = 0xD, // Reserved

  // Value types
  VM_TC_WELL_KNOWN    = 0x10,
  VM_TC_INT14         = 0x11,
};

export function isUInt4(value: number): boolean {
  return (value | 0) === value
    && value >= 0
    && value <= 0xF;
}

export function isInt8(value: number): boolean {
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

export function isInt14(value: number): boolean {
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

export function isInt16(value: number): boolean {
  return (value | 0) === value
    && value >= -0x8000
    && value <= 0x7FFF;
}

export function isInt32(value: number): boolean {
  return (value | 0) === value;
}