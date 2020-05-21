/*
IL is a data format for virtual machine state.
*/
import { unexpected, assertUnreachable, assert } from "./utils";
import { isUInt16, UInt8 } from './runtime-types';
import { ModuleSpecifier } from "./virtual-machine-types";

export const MAX_INDEX = 0x3FFF;
export const MAX_COUNT = 0x3FFF;

export type HostFunctionID = number; // 16-bit unsigned
export type FunctionID = string;
export type BlockID = string;
export type GlobalVariableName = string;
export type ModuleVariableName = string;
export type AllocationID = number;
export type EphemeralFunctionID = number | string;
export type EphemeralObjectID = number | string;

export interface Unit {
  sourceFilename: string;
  functions: { [id: string]: Function };
  entryFunctionID: string;
  moduleVariables: ModuleVariableName[];
  freeVariables: string[];
  moduleImports: { [variableName: string]: ModuleSpecifier };
}

// Note: `stackChange` is a number describing how much the stack is expected to
// change after executing the operation.
export const opcodes = {
  'ArrayNew':    { operands: [                              ], stackChange: 1                     },
  'BinOp':       { operands: ['OpOperand'                   ], stackChange: -1                    },
  'Branch':      { operands: ['LabelOperand', 'LabelOperand'], stackChange: -1                    },
  'Call':        { operands: ['CountOperand'                ], stackChange: callStackChange       },
  'Decr':        { operands: [                              ], stackChange: 0                     },
  'Dup':         { operands: [                              ], stackChange: 1                     },
  'Incr':        { operands: [                              ], stackChange: 0                     },
  'Jump':        { operands: ['LabelOperand'                ], stackChange: 0                     },
  'Literal':     { operands: ['LiteralOperand'              ], stackChange: 1                     },
  'LoadArg':     { operands: ['IndexOperand'                ], stackChange: 1                     },
  'LoadGlobal':  { operands: ['NameOperand'                 ], stackChange: 1                     },
  'LoadVar':     { operands: ['IndexOperand'                ], stackChange: 1                     },
  'Nop':         { operands: ['CountOperand'                ], stackChange: 0                     },
  'ObjectGet':   { operands: [                              ], stackChange: -1                    },
  'ObjectNew':   { operands: [                              ], stackChange: 1                     },
  'ObjectSet':   { operands: [                              ], stackChange: -3                    },
  'Pop':         { operands: ['CountOperand'                ], stackChange: popStackChange        },
  'Return':      { operands: [                              ], stackChange: 1                     },
  'StoreGlobal': { operands: ['NameOperand'                 ], stackChange: -1                    },
  'StoreVar':    { operands: ['IndexOperand'                ], stackChange: -1                    },
  'UnOp':        { operands: ['OpOperand'                   ], stackChange: 0                     },
};

export interface Function {
  type: 'Function';
  sourceFilename: string;
  id: FunctionID;
  maxStackDepth: number;
  entryBlockID: string;
  blocks: { [id: string]: Block }
  comments?: string[];
}

export interface Block {
  id: BlockID;
  expectedStackDepthAtEntry: number;
  operations: Operation[];
  comments?: string[];
}

export type Operation =
  | CallOperation
  | ReturnOperation
  | ArrayNewOperation
  | OtherOperation

export interface OperationBase {
  opcode: Opcode;
  sourceLoc: { line: number; column: number; };
  operands: Operand[];
  comments?: string[];
  stackDepthBefore: number;
  stackDepthAfter: number;
  /*
   * Optional annotations used by the bytecode emitter to choose specific
   * bytecode instructions
   */
  staticInfo?: any;
}

export interface CallOperation extends OperationBase {
  opcode: 'Call';
  staticInfo?: {
    shortCall: boolean;
    target: ValueEncoding;
  }
}

export interface ArrayNewOperation extends OperationBase {
  opcode: 'ArrayNew';
  staticInfo?: {
    minCapacity: UInt8;
  }
}

export interface ReturnOperation extends OperationBase {
  opcode: 'Return';
  staticInfo?: {
    // If `false`, the return operation will not pop the target from the stack
    targetIsOnTheStack: boolean;
    // If `true`, the return operation will not pop the return value from the
    // stack, and will instead just return "undefined"
    returnUndefined: boolean;
  }
}

export interface OtherOperation extends OperationBase {
  opcode: 'BinOp' | 'Branch' | 'Decr' | 'Dup' | 'Incr' | 'Jump' | 'Literal' | 'LoadArg' | 'LoadGlobal' | 'LoadVar' | 'Nop' | 'ObjectGet' | 'ObjectNew' | 'ObjectSet' | 'Pop' | 'StoreGlobal' | 'StoreVar' | 'UnOp';
}

// This is currently used to elide the target on function calls, but could be
// extended to other scenarios
export type ValueEncoding =
  | StaticEncoding
  | DynamicEncoding

export interface StaticEncoding {
  type: 'StaticEncoding';
  value: Value;
}

export interface DynamicEncoding {
  type: 'DynamicEncoding';
}

export type ExportID = number;
export const ExportID = (exportID: number) => {
  assert(isUInt16(exportID));
  return exportID;
};

export const dynamicEncoding = Object.freeze<DynamicEncoding>({ type: 'DynamicEncoding' });

/**
 * Amount the stack changes for a call operation
 */
function callStackChange(op: Operation): number {
  if (op.opcode !== 'Call') {
    return unexpected('Expected `Call` operation');
  }
  if (op.operands.length !== 1) {
    return unexpected('Invalid operands to `Call` operation');
  }
  const argCountOperand = op.operands[0];
  if (argCountOperand.type !== 'CountOperand') {
    return unexpected('Invalid operands to `Call` operation');
  }
  const argCount = argCountOperand.count;
  // Adds one value to the stack (the return value). Pops all the arguments off
  // the stack, and pops the function reference off the stack.
  return 1 - argCount - 1;
}

/**
 * Amount the stack changes for a pop operation
 */
function popStackChange(op: Operation): number {
  if (op.opcode !== 'Pop') {
    return unexpected('Expected `Pop` operation');
  }
  if (op.operands.length !== 1) {
    return unexpected('Invalid operands to `Pop` operation');
  }
  const popCountOperand = op.operands[0];
  if (popCountOperand.type !== 'CountOperand') {
    return unexpected('Invalid operands to `Pop` operation');
  }
  const popCount = popCountOperand.count;
  return -popCount;
}

export type Opcode = keyof typeof opcodes;

// Similar to `Value` but doesn't support arrays and objects at this time, and can reference a LabelOperand
export type Operand =
  | LabelOperand
  | NameOperand
  | CountOperand
  | LiteralOperand
  | IndexOperand
  | OpOperand

export type OperandType = Operand['type'];

export interface LabelOperand {
  type: 'LabelOperand';
  targetBlockID: string;
}

export interface NameOperand {
  type: 'NameOperand';
  name: string;
}

export interface CountOperand {
  type: 'CountOperand';
  count: number;
}

export interface LiteralOperand {
  type: 'LiteralOperand';
  literal: Value;
}

export interface IndexOperand {
  type: 'IndexOperand';
  index: number;
}

export interface OpOperand {
  type: 'OpOperand';
  subOperation: string;
}

export type Value =
  | UndefinedValue
  | NullValue
  | BooleanValue
  | NumberValue
  | StringValue
  | FunctionValue
  | HostFunctionValue
  | ReferenceValue<Allocation>
  | EphemeralFunctionValue
  | EphemeralObjectValue

export interface ReferenceValue<T extends Allocation = Allocation> {
  type: 'ReferenceValue';
  value: AllocationID;
}

export interface FunctionValue {
  type: 'FunctionValue';
  value: FunctionID;
}

export interface HostFunctionValue {
  type: 'HostFunctionValue';
  value: HostFunctionID; // Identifier of host function in the host function table
}

export interface UndefinedValue {
  type: 'UndefinedValue';
  value: undefined;
}

export interface NullValue {
  type: 'NullValue';
  value: null;
}

export interface BooleanValue {
  type: 'BooleanValue';
  value: boolean;
}

export interface NumberValue {
  type: 'NumberValue';
  value: number;
}

export interface StringValue {
  type: 'StringValue';
  value: string;
}

export type LiteralValueType = boolean | number | string | undefined | null;

export type BinOpCode =
  |  "+"
  |  "-"
  |  "/"
  |  "DIVIDE_AND_TRUNC" // For special form `x / y | 0`
  |  "%"
  |  "*"
  |  "**"
  |  "&"
  |  "|"
  |  ">>"
  |  ">>>"
  |  "<<"
  |  "^"
  //|  "==" (not allowed)
  |  "==="
  // |  "!=" (not allowed)
  |  "!=="
  // |  "in"
  // |  "instanceof"
  |  ">"
  |  "<"
  |  ">="
  |  "<="

export type UnOpCode =
  | "-"
  | "+"
  | "!"
  | "~"
  //| "typeof"
  //| "void"
  //| "delete"

export function isNameOperand(value: Operand): value is NameOperand {
  return value.type === 'NameOperand';
}

export function isLabelOperand(value: Operand): value is LabelOperand {
  return value.type === 'LabelOperand';
}

export function isLiteralOperand(value: Operand): value is LiteralOperand {
  return value.type === 'LiteralOperand';
}

export const undefinedValue: UndefinedValue = {
  type: 'UndefinedValue',
  value: undefined
}

export const nullValue: NullValue = {
  type: 'NullValue',
  value: null
}

export type Allocation =
  | ArrayAllocation
  | ObjectAllocation

export interface AllocationBase {
  type: Allocation['type'];
  allocationID: AllocationID;
  memoryRegion?: 'rom' | 'data' | 'gc';
}

export interface ArrayAllocation extends AllocationBase {
  type: 'ArrayAllocation';
  // Set to true if the length will never change
  lengthIsFixed?: boolean;
  items: Value[];
}

export interface ObjectAllocation extends AllocationBase {
  type: 'ObjectAllocation';
  // Set to true if the set of property names will never change
  keysAreFixed?: boolean;
  // The set of properties that won't change
  immutableProperties?: Set<PropertyKey>;
  properties: ObjectProperties;
}

export type ObjectProperties = { [key: string]: Value };

export interface EphemeralFunctionValue {
  type: 'EphemeralFunctionValue';
  value: EphemeralFunctionID; // Identifier of ephemeral function in the ephemeral function table
}

export interface EphemeralObjectValue {
  type: 'EphemeralObjectValue';
  value: EphemeralObjectID; // Identifier of ephemeral object in the ephemeral object table
}

export enum ExecutionFlag {
  FloatSupport = 0,
}