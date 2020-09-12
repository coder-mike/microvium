/*
IL is a data format for virtual machine state.
*/
import { unexpected, hardAssert } from "./utils";
import { isUInt16, UInt8 } from './runtime-types';
import { ModuleSpecifier } from "./virtual-machine-types";
import { opcodes, Opcode } from "./il-opcodes";
export { opcodes, Opcode } from "./il-opcodes";

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

export interface Function {
  type: 'Function';
  sourceFilename?: string;
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
  operands: Operand[];
  stackDepthBefore: number;
  stackDepthAfter: number;

  sourceLoc?: { filename: string, line: number; column: number; };
  comments?: string[];
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
    target?: Value;
  }
}

export interface ArrayNewOperation extends OperationBase {
  opcode: 'ArrayNew';
  staticInfo?: {
    minCapacity: UInt8;
    fixedLength: boolean;
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
  opcode: 'BinOp' | 'Branch' | 'Jump' | 'Literal' | 'LoadArg' | 'LoadGlobal' | 'LoadVar' | 'Nop' | 'ObjectGet' | 'ObjectNew' | 'ObjectSet' | 'Pop' | 'StoreGlobal' | 'StoreVar' | 'UnOp';
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
  hardAssert(isUInt16(exportID));
  return exportID;
};

export const dynamicEncoding = Object.freeze<DynamicEncoding>({ type: 'DynamicEncoding' });



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

export const undefinedValue: UndefinedValue = Object.freeze({
  type: 'UndefinedValue',
  value: undefined
});

export const nullValue: NullValue = Object.freeze({
  type: 'NullValue',
  value: null
});

export const falseValue: BooleanValue = Object.freeze({
  type: 'BooleanValue',
  value: false
});

export const trueValue: BooleanValue = Object.freeze({
  type: 'BooleanValue',
  value: true
});

export const numberValue = (n: number): NumberValue => Object.freeze({
  type: 'NumberValue',
  value: n
});

export const stringValue = (s: string): StringValue => Object.freeze({
  type: 'StringValue',
  value: s
});

export const emptyString = stringValue('');

export const functionValue = (functionID: FunctionID): FunctionValue => Object.freeze({
  type: 'FunctionValue',
  value: functionID
});

export const hostFunctionValue = (hostFunctionID: HostFunctionID): HostFunctionValue => Object.freeze({
  type: 'HostFunctionValue',
  value: hostFunctionID
});

export const referenceValue = (allocationID: AllocationID): ReferenceValue => Object.freeze({
  type: 'ReferenceValue',
  value: allocationID
});

export type Allocation =
  | ArrayAllocation
  | ObjectAllocation

export interface AllocationBase {
  type: Allocation['type'];
  allocationID: AllocationID;
  memoryRegion?: 'rom' | 'gc';
}

export interface ArrayAllocation extends AllocationBase {
  type: 'ArrayAllocation';
  // Set to true if the length will never change
  lengthIsFixed?: boolean;
  items: (Value | undefined)[]; // Undefined marks elisions/holes
}

export interface ObjectAllocation extends AllocationBase {
  type: 'ObjectAllocation';
  // Set to true if the set of property names will never change
  keysAreFixed?: boolean;
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
  CompiledWithOverflowChecks = 1,
}

export function calcDynamicStackChangeOfOp(operation: Operation) {
  const meta = opcodes[operation.opcode];
  let stackChange = meta.stackChange;
  if (typeof stackChange === 'function')
    stackChange = stackChange(operation);
  return stackChange;
}

// The static stack change gives you stack depth at the instruction that follows
// statically (physically) rather than the one that follows dynamically (from
// runtime control flow). This is the same as the dynamic stack depth except in
// the case of control flow instructions for which these diverge.
export function calcStaticStackChangeOfOp(operation: Operation) {
  // Control flow operations
  switch (operation.opcode) {
    case 'Return': return -1; // Return pops the result off the stack
    case 'Branch': return -1; // Pops predicate off the stack
    case 'Jump': return 0;
    case 'Call': return calcDynamicStackChangeOfOp(operation) + 1; // Includes the pushed return value
    default: return calcDynamicStackChangeOfOp(operation);
  }
}