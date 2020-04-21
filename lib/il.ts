import * as VM from './virtual-machine-types';
import { unexpected, assertUnreachable } from "./utils";

export const MAX_INDEX = 0x3FFF;
export const MAX_COUNT = 0x3FFF;

export type FunctionID = string;
export type BlockID = string;
export type GlobalVariableName = string;
export type ModuleVariableName = string;

export interface Unit {
  sourceFilename: string;
  functions: { [id: string]: Function };
  entryFunctionID: string;
  moduleVariables: ModuleVariableName[];
  globalImports: string[];
}

// Note: `stackChange` is a number describing how much the stack is expected to
// change after executing the operation.
export const opcodes = {
  'ArrayGet':    { operands: [                              ], stackChange: -1                    },
  'ArrayNew':    { operands: [                              ], stackChange: 1                     },
  'ArraySet':    { operands: [                              ], stackChange: -3                    },
  'BinOp':       { operands: ['OpOperand'                   ], stackChange: -1                    },
  'Branch':      { operands: ['LabelOperand', 'LabelOperand'], stackChange: -1                    },
  'Call':        { operands: ['CountOperand'                ], stackChange: callStackChange       },
  'CallMethod':  { operands: ['NameOperand', 'CountOperand' ], stackChange: callMethodStackChange },
  'Decr':        { operands: [                              ], stackChange: 0                     },
  'Dup':         { operands: [                              ], stackChange: 1                     },
  'Incr':        { operands: [                              ], stackChange: 0                     },
  'Jump':        { operands: ['LabelOperand'                ], stackChange: 0                     },
  'Literal':     { operands: ['LiteralOperand'              ], stackChange: 1                     },
  'LoadArg':     { operands: ['IndexOperand'                ], stackChange: 1                     },
  'LoadGlobal':  { operands: ['NameOperand'                 ], stackChange: 1                     },
  'LoadVar':     { operands: ['IndexOperand'                ], stackChange: 1                     },
  'Nop':         { operands: ['CountOperand'                ], stackChange: 0                     },
  'ObjectGet':   { operands: ['NameOperand'                 ], stackChange: 0                     },
  'ObjectNew':   { operands: [                              ], stackChange: 1                     },
  'ObjectSet':   { operands: ['NameOperand'                 ], stackChange: -2                    },
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
  | OtherOperation

export interface OperationBase {
  opcode: Opcode;
  sourceLoc: { line: number; column: number; };
  operands: Operand[];
  comments?: string[];
  expectedStackDepthBefore: number;
  expectedStackDepthAfter: number;
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
  opcode: 'ArrayGet' | 'ArrayNew' | 'ArraySet' | 'BinOp' | 'Branch' | 'CallMethod' | 'Decr' | 'Dup' | 'Incr' | 'Jump' | 'Literal' | 'LoadArg' | 'LoadGlobal' | 'LoadVar' | 'Nop' | 'ObjectGet' | 'ObjectNew' | 'ObjectSet' | 'Pop' | 'StoreGlobal' | 'StoreVar' | 'UnOp';
}

export type ValueEncoding =
  | StaticEncoding
  | DynamicEncoding

export interface StaticEncoding {
  type: 'StaticEncoding';
  value: VM.Value;
}

export interface DynamicEncoding {
  type: 'DynamicEncoding';
}

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
 * Amount the stack changes for a CallMethod operation
 */
function callMethodStackChange(op: Operation): number {
  if (op.opcode !== 'CallMethod') {
    return unexpected('Expected `CallMethod` operation');
  }
  if (op.operands.length !== 2) {
    return unexpected('Invalid operands to `CallMethod` operation');
  }
  const argCountOperand = op.operands[1];
  if (argCountOperand.type !== 'CountOperand') {
    return unexpected('Invalid operands to `CallMethod` operation');
  }
  const argCount = argCountOperand.count;
  // Adds one value to the stack (the return value). Pops all the arguments off
  // the stack, and pops object references off the stack.
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