import * as IL from './il';
import { assert, stringifyIdentifier, assertUnreachable, entries, notUndefined, unexpected } from './utils';
import { isUInt16 } from './runtime-types';
import { VirtualMachine } from './virtual-machine';
import { ModuleSourceText } from '../lib';

export type GlobalSlotID = string;

export type PropertyKey = string;
export type Index = number;

export type ResolveFFIImport = (hostFunctionID: IL.HostFunctionID) => HostFunctionHandler;

export type ModuleResolver = (moduleSpecifier: ModuleSpecifier) => ModuleObject;

export type ModuleObject = IL.ReferenceValue<IL.ObjectAllocation> | IL.EphemeralObjectValue;

export type ModuleSpecifier = string;

export type ImportHook = (specifier: ModuleSpecifier) => ModuleObject | undefined;

export type Frame = InternalFrame | ExternalFrame;

export interface InternalFrame {
  type: 'InternalFrame';
  args: IL.Value[];
  block: IL.Block;
  callerFrame: Frame | undefined;
  filename: string;
  func: Function;
  nextOperationIndex: number;
  operationBeingExecuted: IL.Operation;
  variables: IL.Value[];
}

// Indicates where control came from external code
export interface ExternalFrame {
  type: 'ExternalFrame';
  callerFrame: Frame | undefined;
  result: IL.Value;
}

export interface VirtualMachineOptions {
  // Function called before every operation
  trace?: (operation: IL.Operation) => void;
  // If set to false, numeric operations on 32-bit signed integers will result
  // in 32-bit signed integer results, except for division
  overflowChecks?: boolean;
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