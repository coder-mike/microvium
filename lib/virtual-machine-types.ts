import * as IL from './il';
import { VirtualMachine } from './virtual-machine';
import { ModuleSourceText } from '../lib';

export const VM_OIS_PROMISE_STATUS = 2;
export const VM_OIS_PROMISE_OUT = 3;
export const VM_OIS_PROTO_SLOT_MAGIC_KEY = 2;
export const VM_OIS_PROTO_SLOT_COUNT = 3;
export const VM_PROMISE_STATUS_PENDING = IL.numberValue(-1);
export const VM_PROMISE_STATUS_RESOLVED = IL.numberValue(-2);
export const VM_PROMISE_STATUS_REJECTED = IL.numberValue(-3);
export const VM_PROTO_SLOT_MAGIC_KEY_VALUE = IL.numberValue(-0x2000);

export type GlobalSlotID = string;

export type PropertyKey = string;
export type Index = number;

export type ResolveFFIImport = (hostFunctionID: IL.HostFunctionID) => HostFunctionHandler | undefined;

export type ModuleResolver = (moduleSource: ModuleRelativeSource) => ModuleObject;

export type ModuleObject = IL.ReferenceValue<IL.ObjectAllocation> | IL.EphemeralObjectValue;

/** Identifies a module relative to an importing module */
export type ModuleRelativeSource = string;

export type ImportHook = (source: ModuleRelativeSource) => ModuleObject | undefined;

export type Frame = InternalFrame | ExternalFrame;

export interface InternalFrame {
  type: 'InternalFrame';
  frameNumber: number; // 1 for first frame
  args: IL.Value[];
  scope: IL.Value;
  block: IL.Block;
  callerFrame: Frame | undefined;
  filename?: string;
  func: Function;
  nextOperationIndex: number;
  operationBeingExecuted: IL.Operation;
  variables: IL.Value[];
  isVoidCall: boolean;
}

// Indicates where control came from external code
export interface ExternalFrame {
  type: 'ExternalFrame';
  frameNumber: number; // 1 for first frame
  callerFrame: Frame | undefined;
  result: IL.Value;
}

export interface VirtualMachineOptions {
  // Function called before every operation
  trace?: (operation: IL.Operation) => void;
  // If set to false, numeric operations on 32-bit signed integers will result
  // in 32-bit signed integer results, except for division
  overflowChecks?: boolean;
  debugConfiguration?: { port: number };
  executionFlags?: IL.ExecutionFlag[];
  noLib?: boolean;
  // For debug purposes: output the IL of every compiled unit
  outputIL?: boolean;
}

export interface GlobalDefinitions {
  [name: string]: GlobalDefinition;
}

export type GlobalDefinition = (vm: VirtualMachine) => Handle<IL.Value>;

export type MetaID<T = any> = number;

export interface GlobalSlot {
  value: IL.Value;
  indexHint?: number; // Lower indexes are accessed more efficiently in the the C VM
}

export interface HostFunctionHandler {
  call(args: IL.Value[]): IL.Value | void;
  unwrap(): any;
}

export interface HostObjectHandler {
  get(obj: IL.Value, key: PropertyKey | Index): IL.Value;
  set(obj: IL.Value, key: PropertyKey | Index, value: IL.Value): void;
  keys(obj: IL.Value): Array<PropertyKey | Index>;
  unwrap(): any;
}

// Handles are used when we want to reference-count a value rather than expose
// it to the GC. Generally, `Handle<T>` means that the variable holds ownership.
export interface Handle<T extends IL.Value = IL.Value> {
  value: T;
  addRef(): Handle<T>;
  release(): T;
}

export interface Function extends IL.Function {
  moduleHostContext: any; // Provided by the host when the module is loaded
}

export interface ModuleSource {
  /** Microvium source text for the module */
  sourceText: ModuleSourceText;

  /** If specified, the debugFilename will appear in stack traces and facilitate
   * breakpoints in the source text. */
  debugFilename?: string;

  /** If specified, this allows the module to have its own nested imports. The
   * imports can either resolve to an object (e.g. a module in the host) or to
   * module source text to be evaluated in Microvium */
  importDependency?: ImportHook
}