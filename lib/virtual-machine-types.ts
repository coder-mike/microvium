import * as IL from './il';
import { assert, stringifyIdentifier, assertUnreachable, entries, notUndefined, unexpected } from './utils';
import { isUInt16 } from './runtime-types';
import { VirtualMachine } from './virtual-machine';

export type GlobalSlotID = string;

export type PropertyKey = string;
export type Index = number;

export type ExportID = number;
export const ExportID = (exportID: number) => {
  assert(isUInt16(exportID));
  return exportID;
};

export type ResolveFFIImport = (hostFunctionID: HostFunctionID) => HostFunctionHandler;

export type ModuleResolver = (moduleSpecifier: ModuleSpecifier) => ModuleObject;

export type ModuleObject = ReferenceValue<ObjectAllocation> | EphemeralObjectValue;

export type ModuleSpecifier = string;

/*
 * Note: We only require references where reference-semantics are observable,
 * which is with arrays and objects. However, functions also have the property
 * that they can recursively reference themselves, making it hard to dump to the
 * console if we need to, so it's convenient to treat functions as reference
 * types.
 */

export type Value =
  | IL.Value
  | FunctionValue
  | HostFunctionValue
  | EphemeralFunctionValue
  | EphemeralObjectValue
  | ReferenceValue<Allocation>

export type Frame = InternalFrame | ExternalFrame;

export interface InternalFrame {
  type: 'InternalFrame';
  args: Value[];
  block: IL.Block;
  callerFrame: Frame | undefined;
  filename: string;
  func: Function;
  nextOperationIndex: number;
  object: ReferenceValue<ObjectAllocation> | EphemeralObjectValue | IL.UndefinedValue;
  operationBeingExecuted: IL.Operation;
  variables: Value[];
}

// Indicates where control came from external code
export interface ExternalFrame {
  type: 'ExternalFrame';
  callerFrame: Frame | undefined;
  result: Value;
}

export type HostFunctionID = number; // 16-bit unsigned
export type EphemeralFunctionID = number | string;
export type EphemeralObjectID = number | string;

export interface FunctionValue {
  type: 'FunctionValue';
  value: IL.FunctionID;
}

export interface HostFunctionValue {
  type: 'HostFunctionValue';
  value: HostFunctionID; // Identifier of host function in the host function table
}

export interface EphemeralFunctionValue {
  type: 'EphemeralFunctionValue';
  value: EphemeralFunctionID; // Identifier of ephemeral function in the ephemeral function table
}

export interface EphemeralObjectValue {
  type: 'EphemeralObjectValue';
  value: EphemeralObjectID; // Identifier of ephemeral object in the ephemeral object table
}

export interface ReferenceValue<T extends Allocation> {
  type: 'ReferenceValue';
  value: AllocationID;
}

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

export interface VirtualMachineOptions {
  // Function called before every operation
  trace?: (operation: IL.Operation) => void;
}

export interface GlobalDefinitions {
  [name: string]: GlobalDefinition;
}

export type GlobalDefinition = (vm: VirtualMachine) => Handle<Value>;

export type AllocationID = number;

export type MetaID<T = any> = number;

export interface GlobalSlot {
  value: Value;
  indexHint?: number; // Lower indexes are accessed more efficiently in the the C VM
}

export type Allocation =
  | ArrayAllocation
  | ObjectAllocation

export type HostFunctionHandler = (object: Value, args: Value[]) => Value | void;

export interface HostObjectHandler {
  get(obj: Value, key: PropertyKey | Index): Value;
  set(obj: Value, key: PropertyKey | Index, value: Value): void;
}

// Handles are used when we want to reference-count a value rather than expose
// it to the GC. Generally, `Handle<T>` means that the variable holds ownership.
export interface Handle<T extends Value = Value> {
  value: T;
  addRef(): Handle<T>;
  release(): T;
}

export interface Function extends IL.Function {
  moduleHostContext: any; // Provided by the host when the module is loaded
}