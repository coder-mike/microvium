/*
IL is a data format for virtual machine state.
*/
import { hardAssert, notUndefined, unexpected } from "./utils";
import { isUInt16, UInt8 } from './runtime-types';
import { ModuleRelativeSource } from "./virtual-machine-types";
import { opcodes, Opcode } from "./il-opcodes";
export { opcodes, Opcode, RegName } from "./il-opcodes";

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

  // The names of all the free variables referenced by the unit. At load time,
  // these are resolved to the corresponding named global variables in the VM.
  freeVariables: string[];

  // The IL will access the given module-level variable name when it wants to
  // access the corresponding module object. It's up to the loading/linking
  // process to resolve the actual global slot ID associated with this. The
  // imports ordered according to their appearance in the code. The variableName
  // will be undefined if the module is only imported for its side effects.
  moduleImports: Array<{ variableName?: ModuleVariableName, source: ModuleRelativeSource }>;
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

  // Information about the expected stack depth before and after, used for
  // validation as the machine runs.
  stackDepthBefore: number;
  stackDepthAfter: number | undefined;

  nameHint?: string;

  sourceLoc?: OperationSourceLoc;
  comments?: string[];
  /*
   * Optional annotations used by the bytecode emitter to choose specific
   * bytecode instructions
   */
  staticInfo?: any;
}

export interface OperationSourceLoc {
  filename: string;
  line: number; // Start at 1
  column: number; // Start at 0, I think
}

export interface CallOperation extends OperationBase {
  opcode: 'Call';
  // TODO: This model is flawed, because the semantics of the operation change
  // according to the optional static info. The existence of the static info
  // invalidates the `VirtualMachine`'s definition of the behavior. The static
  // information should be embedded as "real" data. Also, for calls
  // specifically, it would be relatively easy for the analysis pass to identify
  // many cases where the target is known.
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
}

export interface OtherOperation extends OperationBase {
  opcode:
    | 'ArrayGet'
    | 'ArraySet'
    | 'AsyncComplete'
    | 'AsyncResume'
    | 'AsyncReturn'
    | 'AsyncStart'
    | 'Await'
    | 'AwaitCall'
    | 'BinOp'
    | 'Branch'
    | 'ClassCreate'
    | 'ClosureNew'
    | 'EndTry'
    | 'EnqueueJob'
    | 'Jump'
    | 'Literal'
    | 'LoadArg'
    | 'LoadGlobal'
    | 'LoadReg'
    | 'LoadScoped'
    | 'LoadVar'
    | 'New'
    | 'Nop'
    | 'ObjectGet'
    | 'ObjectKeys'
    | 'ObjectNew'
    | 'ObjectSet'
    | 'Pop'
    | 'ScopeClone'
    | 'ScopeDiscard'
    | 'ScopeNew'
    | 'ScopePop'
    | 'ScopeSave'
    | 'ScopePush'
    | 'StartTry'
    | 'StoreGlobal'
    | 'StoreScoped'
    | 'StoreVar'
    | 'Throw'
    | 'TypeCodeOf'
    | 'Uint8ArrayNew'
    | 'UnOp'
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
  | FlagOperand

export type OperandType = Operand['type'];

export interface LabelOperand {
  type: 'LabelOperand';
  targetBlockId: string;
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

export interface FlagOperand {
  type: 'FlagOperand';
  flag: boolean;
}

export interface OpOperand {
  type: 'OpOperand';
  subOperation: string;
}

export interface Exception {
  type: 'Exception';
  exception: Value;
}

export type Value =
  | DeletedValue
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
  | ClassValue
  | ProgramAddressValue
  | ClassValue
  | NoOpFunction
  | ResumePoint

export type CallableValue =
  | FunctionValue
  | HostFunctionValue
  | EphemeralFunctionValue
  | NoOpFunction
  | ReferenceValue<ClosureAllocation>
  | ResumePoint

// Represents a function that does nothing except return `undefined`
export interface NoOpFunction {
  type: 'NoOpFunction';
}

export interface ClassValue {
  type: 'ClassValue';
  constructorFunc: Value; // Function
  staticProps: Value; // Object
}

export interface ReferenceValue<T extends Allocation = Allocation> {
  type: 'ReferenceValue';
  value: AllocationID;
}

export interface FunctionValue {
  type: 'FunctionValue';
  value: FunctionID;
}

// Like FunctionValue but doesn't need to point to only the start of a function
export interface ResumePoint {
  type: 'ResumePoint';
  address: ProgramAddressValue;
}

export interface HostFunctionValue {
  type: 'HostFunctionValue';
  value: HostFunctionID; // Identifier of host function in the host function table
}

// A deleted value represents a hole in an array or variable in the TDZ
export interface DeletedValue {
  type: 'DeletedValue';
  value: undefined;
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

/**
 * The IL equivalent of a bytecode address. It points to a particular block in
 * a particular function
 */
export interface ProgramAddressValue {
  type: 'ProgramAddressValue';
  funcId: FunctionID;
  blockId: BlockID;
  operationIndex: number;
}

/**
 * The IL equivalent of a pointer to a position on the stack.
 */
export interface StackDepthValue {
  type: 'StackDepthValue';
  // The current frame number, where 0 indicates no frame, 1 indicates we're in
  // the first frame, etc.
  frameNumber: number;
  // If the current frame is an InternalFrame, then the variableDepth is the
  // number of variables in the frame.
  variableDepth: number;
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
  | "typeof"
  | "typeCodeOf"
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

export const deletedValue: DeletedValue = Object.freeze({
  type: 'DeletedValue',
  value: undefined
});

export const noOpFunction: NoOpFunction = Object.freeze({
  type: 'NoOpFunction'
});

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
  | ClosureAllocation
  | Uint8ArrayAllocation

export interface AllocationBase {
  type: Allocation['type'];
  allocationID: AllocationID;
  memoryRegion?: 'rom' | 'gc';
}

export type ArrayElement = Value | undefined; // Undefined marks elisions/holes in the array

export interface ArrayAllocation extends AllocationBase {
  type: 'ArrayAllocation';
  // Set to true if the length will never change
  lengthIsFixed?: boolean;
  items: ArrayElement[];
}

export interface ClosureAllocation extends AllocationBase {
  type: 'ClosureAllocation';
  // Note: Slot 0 is special because it points to the parent closure/scope while
  // slot 1 is special because it points to the closure function IL, if the
  // closure is executable.
  slots: Value[];
}

export interface Uint8ArrayAllocation extends AllocationBase {
  type: 'Uint8ArrayAllocation';
  bytes: number[];
}

export interface ObjectAllocation extends AllocationBase {
  type: 'ObjectAllocation';
  prototype: Value; // NullValue or a a reference to another object
  // Set to true if the set of property names will never change
  keysAreFixed?: boolean;
  internalSlots: Value[]; // Note: first two internal slots are always missing, to match runtime engine behavior where the first 2 slots represent dpNext and dpProto
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
    stackChange = stackChange(...operation.operands);
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
    case 'AsyncReturn': return -1; // Return pops the result off the stack
    case 'Branch': return -1; // Pops predicate off the stack
    case 'Jump': return 0;
    case 'Call': {
      const forCall = calcDynamicStackChangeOfOp(operation) ?? unexpected(); // Arguments popped from stack
      const isVoidCall = operation.operands[1] as FlagOperand;
      hardAssert(isVoidCall.type === 'FlagOperand');
      const forReturn = isVoidCall.flag ? 0 : 1; // Return value pushed to the stack
      return forCall + forReturn;
    }
    case 'AwaitCall': {
      const forCall = calcDynamicStackChangeOfOp(operation) ?? unexpected(); // Arguments popped from stack
      const forReturn = 1;
      return forCall + forReturn;
    }
    case 'New': return notUndefined(calcDynamicStackChangeOfOp(operation)) + 1; // Includes the pushed return value
    default: return calcDynamicStackChangeOfOp(operation);
  }
}