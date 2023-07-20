import * as IL from './il';
import * as VM from './virtual-machine-types';
import _, { Dictionary } from 'lodash';
import { SnapshotIL } from "./snapshot-il";
import { notImplemented, invalidOperation, uniqueName, unexpected, assertUnreachable, hardAssert, notUndefined, entries, stringifyIdentifier, fromEntries, mapObject, mapMap, Todo, RuntimeError, arrayOfLength } from "./utils";
import { compileScript, computeMaximumStackDepth, indexOperand } from "./src-to-il/src-to-il";
import { stringifyFunction, stringifyAllocation, stringifyValue, stringifyUnit } from './stringify-il';
import deepFreeze from 'deep-freeze';
import { SnapshotClass } from './snapshot';
import { SynchronousWebSocketServer } from './synchronous-ws-server';
import { isSInt32, isUInt8, mvm_TeType } from './runtime-types';
import { encodeSnapshot } from './encode-snapshot';
import { maxOperandCount, minOperandCount } from './il-opcodes';
export * from "./virtual-machine-types";
import fs from 'fs';

interface DebuggerInstrumentationState {
  debugServer: SynchronousWebSocketServer;
  breakpointsByFilePath: Dictionary<Breakpoint[]>;
  /**
   * starting: Initial state of the VM until the first instruction is run
   * step: Running but will break on the next instruction
   * continue: Running but will break on next breakpoint
   * paused: Not running instructions
   */
  executionState: 'starting' | 'step' | 'continue' | 'paused';
  /**
   * For continue, we don't want to stay on the current line, so we need to
   * keep track of the last line we paused at and make sure we don't pause there
   * again
   */
  lastExecutedLine?: number;
}

interface StackTraceFrame {
  filePath: string;
  line: number;
  column: number;
}

/** Essentially a copy of DebugProtocol.SourceBreakpoint */
interface Breakpoint {
  line: number;
  column?: number;
  condition?: string;
  hitCondition?: string;
  logMessage?: string;
}

/** Essentially a copy of DebugProtocol.Scope's required props */
interface DebugScope {
  /** Name of the scope such as 'Arguments', 'Locals', or 'Registers'. This string is shown in the UI as is and can be translated. */
  name: string;
  /** The variables of this scope can be retrieved by passing the value of variablesReference to the VariablesRequest. */
  variablesReference: number
  /** If true, the number of variables in this scope is large or expensive to retrieve. */
  expensive: boolean;
}

enum ScopeVariablesReference {
  GLOBALS = 1,
  FRAME = 2,
  OPERATION = 3
};

export class VirtualMachine {
  private opts: VM.VirtualMachineOptions;
  private allocations = new Map<IL.AllocationID, IL.Allocation>();
  private nextHeapID = 1;
  private globalVariables = new Map<IL.GlobalVariableName, VM.GlobalSlotID>();
  private globalSlots = new Map<VM.GlobalSlotID, VM.GlobalSlot>();
  private hostFunctions = new Map<IL.HostFunctionID, VM.HostFunctionHandler>();
  private catchTarget: IL.StackDepthValue | IL.UndefinedValue = IL.undefinedValue;
  private frame: VM.Frame | undefined;
  private exception: IL.Value | undefined;
  private functions = new Map<IL.FunctionID, VM.Function>();
  private exports = new Map<IL.ExportID, IL.Value>();
  // Ephemeral functions are functions that are only relevant in the current
  // epoch, and will throw as "not available" in the next epoch (after
  // snapshotting).
  private ephemeralFunctions = new Map<IL.EphemeralFunctionID, VM.HostFunctionHandler>();
  private ephemeralObjects = new Map<IL.EphemeralObjectID, VM.HostObjectHandler>();
  private nextEphemeralFunctionNumericID = 0;
  private nextEphemeralObjectNumericID = 0;
  // Handles are values declared outside the VM that add to the reachability
  // graph of the VM (because they're reachable externally)
  private handles = new Set<VM.Handle<IL.Value>>();

  private moduleCache = new Map<VM.ModuleSource, VM.ModuleObject>();

  private debuggerInstrumentation: DebuggerInstrumentationState | undefined;
  private builtins: {
    arrayPrototype: IL.Value
  }

  public constructor(
    resumeFromSnapshot: SnapshotIL | undefined,
    private resolveFFIImport: VM.ResolveFFIImport,
    opts: VM.VirtualMachineOptions,
    debugServer?: SynchronousWebSocketServer
  ) {
    this.opts = {
      overflowChecks: true,
      executionFlags: [IL.ExecutionFlag.FloatSupport],
      ...opts
    };
    if (this.opts.overflowChecks) {
      this.opts.executionFlags?.push(IL.ExecutionFlag.CompiledWithOverflowChecks);
    }

    if (resumeFromSnapshot) {
      return notImplemented();
    }

    if (debugServer) {
      this.debuggerInstrumentation = {
        debugServer,
        breakpointsByFilePath: {},
        executionState: 'starting'
      };
      this.doDebuggerInstrumentation();
    }

    this.builtins = {
      arrayPrototype: IL.nullValue,
    };

    this.addBuiltinGlobals();
  }

  public evaluateModule(moduleSource: VM.ModuleSource) {
    let moduleObject = this.moduleCache.get(moduleSource);
    if (moduleObject) {
      return moduleObject;
    }
    moduleObject = this.newObject();
    this.moduleCache.set(moduleSource, moduleObject);

    const filename = moduleSource.debugFilename || '<no file>';
    const { unit } = compileScript(filename, moduleSource.sourceText);

    if (this.opts.outputIL && moduleSource.debugFilename && !moduleSource.debugFilename.startsWith('<') /* E.g. <builtins> */) {
      fs.writeFileSync(moduleSource.debugFilename + '.il', stringifyUnit(unit, {
        commentSourceLocations: true,
        showComments: true,
        showStackDepth: true,
        showVariableNameHints: true,
      }));
    }

    const importDependency = moduleSource.importDependency || (_specifier => undefined);

    // A mapping from the name the unit uses to refer to an external module to
    // the name we actually give it.
    const moduleImports = new Map<IL.ModuleVariableName, VM.GlobalSlotID>();

    // Transitively import the dependencies
    for (const { variableName, source: specifier } of unit.moduleImports) {
      // `importDependency` takes a module specifier and returns the
      // corresponding module object. It likely does so by in turn calling
      // `evaluateModule` for the dependency.
      const dependency = importDependency(specifier);
      if (!dependency) {
        throw new Error(`Cannot find module ${stringifyIdentifier(specifier)}`)
      }

      if (variableName !== undefined) {
        // Assign the module object reference to a global slot. References from
        // the imported unit to the dependent module will be translated to point
        // to this slot. It's not ideal that each importer creates it's own
        // imported slots, but things get a bit complicated because dependencies
        // are not necessarily IL modules (e.g. they could be ephemeral objects),
        // and we have to get the ordering right with circular dependencies. I
        // tried it and the additional complexity makes me uncomfortable.
        const slotID = uniqueName(specifier, n => this.globalSlots.has(n));
        this.globalSlots.set(slotID, { value: dependency });
        moduleImports.set(variableName, slotID);
      }
    }

    const loadedUnit = this.loadUnit(unit, filename, moduleImports, undefined);

    this.pushFrame({
      type: 'ExternalFrame',
      frameNumber: this.frame ? this.frame.frameNumber + 1 : 1,
      callerFrame: this.frame,
      result: IL.undefinedValue
    });

    // Set up the call
    this.callCommon(loadedUnit.entryFunction, [moduleObject]);
    // Execute
    this.run();
    this.popFrame();

    return moduleObject;
  }

  public createSnapshotIL(): SnapshotIL {
    if (this.frame !== undefined) {
      return invalidOperation('Cannot create a snapshot while the VM is active');
    }

    // We clone the following because, at least in general, the garbage
    // collection may mutate them (for example freeing up unused allocations).
    // The garbage collection is more aggressive than normal since it doesn't
    // take into account global variables or handles (because these don't
    // survive snapshotting), so we clone to avoid disrupting the VM state,
    // which could technically be used further after the snapshot.
    const allocations = _.clone(this.allocations);
    const globalSlots = _.clone(this.globalSlots);
    const frame = _.clone(this.frame);
    const exports = _.clone(this.exports);
    const hostFunctions = _.clone(this.hostFunctions);
    const functions = _.clone(this.functions);
    const builtins = _.clone(this.builtins);

    // Global variables do not transfer across to the snapshot (only global slots)
    const globalVariables = new Map<IL.GlobalVariableName, VM.GlobalSlotID>();
    // We don't include any handles in the snapshot
    const handles = new Set<VM.Handle<IL.Value>>();
    // The elements in the module cache are only reachable by the corresponding
    // sources, which are not available to the resumed snapshot
    const moduleCache = new Map<VM.ModuleSource, VM.ModuleObject>();

    // Perform a GC cycle to clean up, so only reachable things are left. Note
    // that the implementation of the GC does not modify values (e.g. for
    // pointer updates), it only deletes shallow items in these tables.
    garbageCollect({
      globalVariables,
      globalSlots,
      frame,
      handles,
      exports,
      moduleCache,
      allocations,
      hostFunctions,
      functions,
      builtins
    });

    const snapshot: SnapshotIL = {
      globalSlots,
      functions,
      exports,
      allocations,
      flags: new Set<IL.ExecutionFlag>(this.opts.executionFlags),
      builtins
    };

    return deepFreeze(_.cloneDeep(snapshot)) as any;
  }

  public createSnapshot(): SnapshotClass {
    const snapshotInfo = this.createSnapshotIL();
    const { snapshot } = encodeSnapshot(snapshotInfo, false);
    return snapshot;
  }

  public ephemeralFunction(handler: VM.HostFunctionHandler, nameHint?: string): IL.Value {
    const id: IL.EphemeralFunctionID = nameHint
      ? uniqueName(nameHint, n => this.ephemeralFunctions.has(n))
      : this.nextEphemeralFunctionNumericID++;

    this.ephemeralFunctions.set(id, handler);
    return {
      type: 'EphemeralFunctionValue',
      value: id
    }
  }

  public ephemeralObject(handler: VM.HostObjectHandler, nameHint?: string): IL.Value {
    const id: IL.EphemeralObjectID = nameHint
      ? uniqueName(nameHint, n => this.ephemeralObjects.has(n))
      : this.nextEphemeralObjectNumericID++;

    this.ephemeralObjects.set(id, handler);
    return {
      type: 'EphemeralObjectValue',
      value: id
    }
  }

  public unwrapEphemeralFunction(ephemeral: IL.EphemeralFunctionValue) {
    const handler = this.ephemeralFunctions.get(ephemeral.value);
    return handler && handler.unwrap();
  }

  public unwrapEphemeralObject(ephemeral: IL.EphemeralObjectValue) {
    const handler = this.ephemeralObjects.get(ephemeral.value);
    return handler && handler.unwrap();
  }

  public vmExport(exportID: IL.ExportID, value: IL.Value): void {
    if (this.exports.has(exportID)) {
      return this.runtimeError(`Duplicate export ID: ${exportID}`);
    }
    this.exports.set(exportID, value);
  }

  public vmImport(hostFunctionID: IL.HostFunctionID, hostImplementation?: VM.HostFunctionHandler): IL.HostFunctionValue {
    if (!this.hostFunctions.has(hostFunctionID)) {
      hostImplementation = hostImplementation || {
        call(args: IL.Value[]): IL.Value | void {
          throw new Error(`Host implementation not provided for imported ID ${hostFunctionID}`);
        },
        unwrap(): any {
          return undefined;
        }
      }
      this.hostFunctions.set(hostFunctionID, hostImplementation);
    }
    return {
      type: 'HostFunctionValue',
      value: hostFunctionID
    };
  }

  public resolveExport(exportID: IL.ExportID): IL.Value {
    if (!this.exports.has(exportID)) {
      return invalidOperation(`Export not found: ${exportID}`);
    }
    return this.exports.get(exportID)!;
  }

  public setArrayPrototype(value: IL.Value) {
    this.builtins.arrayPrototype = value;
  }

  public importHostFunction(hostFunctionID: IL.HostFunctionID): IL.HostFunctionValue {
    let hostFunc = this.hostFunctions.get(hostFunctionID);
    if (!hostFunc) {
      hostFunc = this.resolveFFIImport(hostFunctionID);
      this.hostFunctions.set(hostFunctionID, hostFunc);
    }
    return {
      type: 'HostFunctionValue',
      value: hostFunctionID
    };
  }

  /**
   * "Relocates" a unit into the global "address space". I.e. remaps all its
   * global and function IDs to unique IDs in the VM, and remaps all its import
   * references to the corresponding resolve imports.
   *
   * @see evaluateModule
   */
  private loadUnit(
    unit: IL.Unit,
    unitNameHint: string,
    // Given a variable name used by the unit to refer to an imported module,
    // what actual global slot holds a reference to that module?
    importResolutions: Map<IL.ModuleVariableName, VM.GlobalSlotID>,
    moduleHostContext?: any
  ): { entryFunction: IL.FunctionValue } {
    const self = this;

    const missingGlobals = unit.freeVariables
      .filter(g => !this.globalVariables.has(g))

    if (missingGlobals.length > 0) {
      return invalidOperation(`Unit cannot be loaded because of missing required globals: ${missingGlobals.join(', ')}`);
    }

    // IDs are remapped when loading into the shared namespace of this VM
    const remappedFunctionIDs = new Map<IL.FunctionID, IL.FunctionID>();
    const newFunctionIDs = new Set<IL.FunctionID>();

    // Allocation slots for all the module-level variables, including functions
    const moduleVariableResolutions = new Map<IL.ModuleVariableName, VM.GlobalSlotID>();
    for (const moduleVariable of unit.moduleVariables) {
      const slotID = uniqueName(moduleVariable, n => this.globalSlots.has(n));
      this.globalSlots.set(slotID, { value: IL.undefinedValue });
      moduleVariableResolutions.set(moduleVariable, slotID);
    }

    // Note: I used to prefix the name hints with the filename. I've stopped
    // doing this because I think that the name will mostly only be inspected in
    // situations where the meaning is obvious without the filename. By removing
    // it, the generated IL is much cleaner to read. This is especially useful
    // when manually inspecting test cases and output.

    // Calculate new function IDs
    for (const func of Object.values(unit.functions)) {
      const newFunctionID = uniqueName(func.id, n => this.functions.has(n) || newFunctionIDs.has(n));
      remappedFunctionIDs.set(func.id, newFunctionID);
      newFunctionIDs.add(newFunctionID);
    }

    // Functions implementations
    for (const func of Object.values(unit.functions)) {
      const newFunctionID = notUndefined(remappedFunctionIDs.get(func.id));
      const imported = importFunction(func);
      this.functions.set(newFunctionID, imported);
    }

    return {
      entryFunction: {
        type: 'FunctionValue',
        value: notUndefined(remappedFunctionIDs.get(unit.entryFunctionID))
      }
    };

    function importFunction(func: IL.Function): VM.Function {
      return {
        ...func,
        id: notUndefined(remappedFunctionIDs.get(func.id)),
        moduleHostContext,
        blocks: mapObject(func.blocks, importBlock)
      };
    }

    function importBlock(block: IL.Block): IL.Block {
      return {
        ...block,
        operations: block.operations.map(importOperation)
      };
    }

    function importOperation(operation: IL.Operation): IL.Operation {
      switch (operation.opcode) {
        case 'LoadGlobal': return importGlobalOperation(operation);
        case 'StoreGlobal': return importGlobalOperation(operation);
        case 'Literal': return importLiteralOperation(operation);
        default: return operation;
      }
    }

    function importLiteralOperation(operation: IL.Operation): IL.Operation {
      const operand: IL.Operand = operation.operands[0] ?? self.ilError('Literal operation must have 1 operand');
      if (operand.type !== 'LiteralOperand') return self.ilError('Literal operation must be have a literal operand');
      const literal = operand.literal;
      if (literal.type === 'FunctionValue') {
        const oldFunctionId = literal.value;
        const newFunctionId = remappedFunctionIDs.get(oldFunctionId) ?? self.ilError(`Literal operation refers to function \`${oldFunctionId}\` which is not defined`);
        return {
          ...operation,
          operands: [{
            type: 'LiteralOperand',
            literal: {
              ...literal,
              value: newFunctionId
            }
          }]
        }
      } else if (literal.type === 'ReferenceValue') {
        // Like with functions, we can theoretically import a unit's
        // "allocations" into the VM's allocations, with mapping table analogous
        // to `remappedFunctionIDs` to get new allocation IDs. Then literal that
        // reference allocations must also be remapped.
        return notImplemented('Reference literals');
      } else {
        return operation;
      }
    }

    function importGlobalOperation(operation: IL.Operation): IL.Operation {
      hardAssert(operation.operands.length === 1);
      const [nameOperand] = operation.operands;
      if (nameOperand.type !== 'NameOperand') return invalidOperation('Malformed IL');
      // Resolve the name to a global slot
      const slotID = moduleVariableResolutions.get(nameOperand.name)
        || importResolutions.get(nameOperand.name)
        || self.globalVariables.get(nameOperand.name)
      if (!slotID) {
        return invalidOperation(`Could not resolve variable: ${nameOperand.name}`);
      };
      return {
        ...operation,
        operands: [{
          type: 'NameOperand',
          name: slotID
        }]
      }
    }
  }

  private run() {
    const instr = this.debuggerInstrumentation;
    while (this.frame && this.frame.type !== 'ExternalFrame') {
      this.operationBeingExecuted = this.block.operations[this.nextOperationIndex];

      const filePath = this.frame.filename;
      if (this.operationBeingExecuted.sourceLoc) {
        const { line: srcLine, column: srcColumn } = this.operationBeingExecuted.sourceLoc;

        if (instr && filePath) {
          const pauseBecauseOfEntry = instr.executionState === 'starting';
          const pauseBecauseOfStep = instr.executionState === 'step';

          const breakpointsOfFile = instr.breakpointsByFilePath[filePath] || [];
          const pauseBecauseOfBreakpoint = breakpointsOfFile.some(bp => {
            if (instr.executionState === 'continue') {
              return bp.line === srcLine && instr.lastExecutedLine !== srcLine;
            }
            if (instr.executionState === 'step') {
              return bp.line === srcLine && (!bp.column || bp.column === srcColumn);
            }
            return false;
          });

          if (pauseBecauseOfEntry) {
            this.sendToDebugClient({ type: 'from-app:stop-on-entry' });
            instr.executionState = 'paused';
          } else if (pauseBecauseOfBreakpoint) {
            this.sendToDebugClient({ type: 'from-app:stop-on-breakpoint' });
            instr.executionState = 'paused';
          } else if (pauseBecauseOfStep) {
            this.sendToDebugClient({ type: 'from-app:stop-on-step' });
            instr.executionState = 'paused';
          }

          console.log('paused bc of entry:', pauseBecauseOfEntry);
          while (instr.executionState === 'paused') {
            console.log('Before waiting for message');
            const messageStr = instr.debugServer.receiveSocketEvent() || unexpected();
            const message = JSON.parse(messageStr);
            console.log('Received:', messageStr);
            if (message.type === 'from-debugger:step-request') {
              instr.executionState = 'step';
            }
            if (message.type === 'from-debugger:continue-request') {
              instr.executionState = 'continue';
            }
          }
        }
        if (instr) {
          instr.lastExecutedLine = srcLine;
        }
      } else {
        if (instr) {
          instr.lastExecutedLine = undefined;
        }
      }
      this.step();
    }
  }

  public runFunction(func: IL.CallableValue, args: IL.Value[]): IL.Value | IL.Exception {
    this.pushFrame({
      type: 'ExternalFrame',
      frameNumber: this.frame ? this.frame.frameNumber + 1 : 1,
      callerFrame: this.frame,
      result: IL.undefinedValue
    });
    this.callCommon(func, args);
    this.run();
    if (this.exception) {
      hardAssert(this.frame === undefined);
      const exception = this.exception ?? unexpected();
      this.exception = undefined;
      return { type: 'Exception', exception }
    }
    if (this.frame === undefined || this.frame.type !== 'ExternalFrame') {
      return unexpected();
    }
    // Result of module script
    const result = this.frame.result;
    this.popFrame();
    return result;
  }

  private sendToDebugClient(message: { type: string, data?: any }) {
    if (this.debuggerInstrumentation) {
      console.log(`To debug client: ${JSON.stringify(message)}`);
      this.debuggerInstrumentation.debugServer.send(JSON.stringify(message));
    }
  }

  private setupDebugServerListener(cb: (message: { type: string, data?: any }) => void) {
    if (this.debuggerInstrumentation) {
      this.debuggerInstrumentation.debugServer.on('message', messageStr => {
        cb(JSON.parse(messageStr));
      });
    }
  }

  private doDebuggerInstrumentation() {
    while (true) {
      console.log('Waiting for a debug session to start');
      // Block until a client connects
      const messageStr = this.debuggerInstrumentation!.debugServer.receiveSocketEvent() || unexpected();
      const message = JSON.parse(messageStr);
      if (message.type === 'from-debugger:start-session') {
        break;
      }
    }

    this.setupDebugServerListener(message => {
      console.log('non-blocking message:', message);
      switch (message.type) {
        case 'from-debugger:stack-request': {
          if (!this.frame || this.frame.type === 'ExternalFrame') {
            // TODO | HIGH | Raf: Document why encountering an external frame is
            // an unexpected case
            return unexpected(`frame is ${JSON.stringify(this.frame, null, 2)}`);
          }

          const stackTraceFrames: StackTraceFrame[] = [];
          let frame: VM.Frame | undefined = this.frame;
          while (frame !== undefined) {
            if (frame.type === 'InternalFrame') {
              stackTraceFrames.push({
                filePath: frame.filename || '<unknown>',
                line: frame.operationBeingExecuted.sourceLoc?.line || 0,
                column: frame.operationBeingExecuted.sourceLoc?.column || 0
              });
            } else {
              stackTraceFrames.push({
                filePath: '<external file>',
                // Do Babel-emitted source lines and columns start with 1? If so,
                // then 0, 0 makes sense as an external location
                line: 0,
                column: 0
              });
            }
            frame = frame.callerFrame;
          }
          this.sendToDebugClient({ type: 'from-app:stack', data: stackTraceFrames });
          break;
        }
        case 'from-debugger:set-and-verify-breakpoints': {
          // TODO Verification (e.g. breakpoints on whitespace)
          const { filePath, breakpoints } = message.data;
          console.log('SET-AND-VERIFY-BREAKPOINTS');
          console.log(JSON.stringify({ filePath, breakpoints }, null, 2));
          if (this.debuggerInstrumentation) {
            this.debuggerInstrumentation.breakpointsByFilePath[filePath] = breakpoints;
            this.sendToDebugClient({
              type: 'from-app:verified-breakpoints',
              data: breakpoints
            })
          }
          break;
        }
        case 'from-debugger:get-breakpoints': {
          const { filePath } = message.data;
          console.log('GET BREAKPOINTS');
          console.log(JSON.stringify({ filePath }), null, 2);
          if (this.debuggerInstrumentation) {
            this.sendToDebugClient({
              type: 'from-app:breakpoints',
              data: {
                breakpoints: this.debuggerInstrumentation.breakpointsByFilePath[filePath] || []
              }
            });
          }
          break;
        }
        case 'from-debugger:scopes-request': {
          console.log('GET SCOPES');
          if (this.debuggerInstrumentation) {
            const scopes: DebugScope[] = [{
              name: 'Globals',
              variablesReference: ScopeVariablesReference.GLOBALS,
              expensive: false
            }, {
              name: 'Current Frame',
              variablesReference: ScopeVariablesReference.FRAME,
              expensive: false
            }, {
              name: 'Current Operation',
              variablesReference: ScopeVariablesReference.OPERATION,
              expensive: false
            }]
            this.sendToDebugClient({ type: 'from-app:scopes', data: scopes });
          }
          break;
        }
        case 'from-debugger:variables-request': {
          const refType = message.data as ScopeVariablesReference;
          const outputChannel = `from-app:variables:ref:${refType}`;
          switch (refType) {
            case ScopeVariablesReference.GLOBALS:
              const globalEntries = [...this.globalVariables.entries()];
              const globals = _(globalEntries)
                .map(([name, id]) => ({ name, value: this.globalSlots.get(id) }))
                .filter(({ value }) => value !== undefined)
                .map(({ name, value }) => ({
                  name,
                  value: DebuggerHelpers.stringifyILValue(value!.value),
                  // See the `DebuggerProtocol.Variable` type. For now, to
                  // simplify, variables don't reference other variables
                  variablesReference: 0
                }))
                .value();
              return this.sendToDebugClient({ type: outputChannel, data: globals });

            case ScopeVariablesReference.FRAME:
              let frameVariables: any[] = [];
              if (!this.frame || this.frame.type === 'ExternalFrame') {
                frameVariables = [];
              } else {
                frameVariables = _(this.frame.variables)
                  .map((variable, index) => ({
                    name: DebuggerHelpers.displayInternals(`Frame Variable ${index}`),
                    value: DebuggerHelpers.stringifyILValue(variable),
                    variablesReference: 0
                  }))
                  .value();
              }
              return this.sendToDebugClient({ type: outputChannel, data: frameVariables });

            case ScopeVariablesReference.OPERATION:
              let operationVariables: any[] = [];
              if (!this.frame || this.frame.type === 'ExternalFrame') {
                operationVariables = [];
              } else {
                const operation = this.operationBeingExecuted;
                operationVariables = [{
                  name: DebuggerHelpers.displayInternals('Opcode'),
                  value: operation.opcode, variablesReference: 0
                },
                ...operation.operands.map((operand, index) => ({
                  name: DebuggerHelpers.displayInternals(`Operand ${index}`),
                  value: JSON.stringify(operand),
                  // See the `DebuggerProtocol.VariablePresentationHint` type
                  presentationHint: 'data',
                  variablesReference: 0,
                }))];
              }
              return this.sendToDebugClient({ type: outputChannel, data: operationVariables });

            default:
              return [];
          }
        }
      }
    });

    console.log('INSTRUMENTATION SETUP DONE');
  }

  /** Create a new handle, starting at ref-count 1. Needs to be released with a call to `release` */
  createHandle<T extends IL.Value>(value: T): VM.Handle<T> {
    let refCount = 1;
    const handle: VM.Handle<T> = {
      get value(): T {
        if (refCount <= 0) {
          return invalidOperation('Handle value has been released');
        }
        return value;
      },
      addRef: () => {
        if (refCount <= 0) {
          return invalidOperation('Handle value has been released');
        }
        refCount++;
        return handle;
      },
      release: () => {
        if (refCount <= 0) {
          return invalidOperation('Handle value has been released');
        }
        const result = value;
        if (--refCount === 0) {
          this.handles.delete(handle)
          value = undefined as any;
        }
        return result;
      }
    };
    this.handles.add(handle);
    return handle;
  }

  /**
   * Gets the moduleContext provided to `runUnit` or `loadUnit` when the active
   * function was loaded.
   */
  callerModuleHostContext(): any {
    if (!this.frame || this.frame.type !== 'InternalFrame') {
      return invalidOperation('Module context not accessible when no module is active.')
    }
    return this.frame.func.moduleHostContext;
  }

  private dispatchOperation(operation: IL.Operation, operands: any[]) {
    const method = (this as any)[`operation${operation.opcode}`] as globalThis.Function;
    if (!method) {
      return notImplemented(`Opcode not implemented in compile-time VM: "${operation.opcode}"`)
    }
    if (operands.length < minOperandCount(operation.opcode)) {
      return unexpected(`Operation does not provide enough operands`);
    }
    if (method.length !== maxOperandCount(operation.opcode)) {
      return unexpected(`Opcode "${operation.opcode}" in compile-time VM is implemented with incorrect number of opcodes (${method.length} instead of expected ${maxOperandCount(operation.opcode)}).`);
    }

    // Writing these out explicitly so that we get type errors if we add new operators
    switch (operation.opcode) {
      case 'ArrayGet'     : return this.operationArrayGet(operands[0]);
      case 'ArrayNew'     : return this.operationArrayNew();
      case 'ArraySet'     : return this.operationArraySet(operands[0]);
      case 'BinOp'        : return this.operationBinOp(operands[0]);
      case 'Branch'       : return this.operationBranch(operands[0], operands[1]);
      case 'Call'         : return this.operationCall(operands[0]);
      case 'ClassCreate'  : return this.operationClassCreate();
      case 'ClosureNew'   : return this.operationClosureNew();
      case 'EndTry'       : return this.operationEndTry();
      case 'Jump'         : return this.operationJump(operands[0]);
      case 'Literal'      : return this.operationLiteral(operands[0]);
      case 'LoadArg'      : return this.operationLoadArg(operands[0]);
      case 'LoadGlobal'   : return this.operationLoadGlobal(operands[0]);
      case 'LoadScoped'   : return this.operationLoadScoped(operands[0]);
      case 'LoadReg'      : return this.operationLoadReg(operands[0]);
      case 'LoadVar'      : return this.operationLoadVar(operands[0]);
      case 'New'          : return this.operationNew(operands[0]);
      case 'Nop'          : return this.operationNop(operands[0]);
      case 'ObjectGet'    : return this.operationObjectGet();
      case 'ObjectKeys'   : return this.operationObjectKeys();
      case 'ObjectNew'    : return this.operationObjectNew();
      case 'ObjectSet'    : return this.operationObjectSet();
      case 'Pop'          : return this.operationPop(operands[0]);
      case 'Return'       : return this.operationReturn();
      case 'ScopeClone'   : return this.operationScopeClone();
      case 'ScopeDiscard' : return this.operationScopeDiscard();
      case 'ScopeNew'     : return this.operationScopeNew(operands[0]);
      case 'ScopePop'     : return this.operationScopePop();
      case 'ScopePush'    : return this.operationScopePush(operands[0]);
      case 'StartTry'     : return this.operationStartTry(operands[0]);
      case 'StoreGlobal'  : return this.operationStoreGlobal(operands[0]);
      case 'StoreScoped'  : return this.operationStoreScoped(operands[0]);
      case 'StoreVar'     : return this.operationStoreVar(operands[0]);
      case 'Throw'        : return this.operationThrow();
      case 'TypeCodeOf'   : return this.operationTypeCodeOf();
      case 'Uint8ArrayNew': return this.operationUint8ArrayNew();
      case 'UnOp'         : return this.operationUnOp(operands[0]);
      default: return assertUnreachable(operation);
    }
  }

  private step() {
    const op = this.operationBeingExecuted;
    this.nextOperationIndex++;
    if (!op) {
      return this.ilError('Did not expect to reach end of block without a control instruction (Branch, Jump, or Return).');
    }
    const operationMeta = IL.opcodes[op.opcode];
    if (!operationMeta) {
      return this.ilError(`Unknown opcode "${op.opcode}".`);
    }
    if (op.operands.length < minOperandCount(op.opcode)) {
      return this.ilError(`Expected ${operationMeta.operands.length} operands to operation \`${op.opcode}\`, but received ${op.operands.length} operands.`);
    }
    const stackDepthBeforeOp = this.variables.length;
    if (op.stackDepthBefore !== undefined && stackDepthBeforeOp !== op.stackDepthBefore) {
      return this.ilError(`Stack depth before opcode "${op.opcode}" is expected to be ${op.stackDepthBefore} but is actually ${stackDepthBeforeOp}`);
    }
    // Note: for the moment, optional operands are always trailing, so they'll just be omitted
    const operands = op.operands.map((o, i) =>
      this.resolveOperand(o, operationMeta.operands[i] as IL.OperandType));
    this.opts.trace && this.opts.trace(op);
    this.dispatchOperation(op, operands);
    // If we haven't returned to the outside world, then we can check the stack balance
    // Note: we don't look at the stack balance for Call instructions because they create a completely new stack of variables.
    if (this.frame && this.frame.type === 'InternalFrame'
      && op.opcode !== 'Call'
      && op.opcode !== 'New'
      && op.opcode !== 'Return'
      && op.opcode !== 'Throw'
      && op.opcode !== 'EndTry'
    ) {
      const stackDepthAfter = this.variables.length;
      if (op.stackDepthAfter !== undefined && stackDepthAfter !== op.stackDepthAfter) {
        return this.ilError(`Stack depth after opcode "${op.opcode}" is expected to be ${op.stackDepthAfter} but is actually ${stackDepthAfter}`);
      }
      const stackChange = stackDepthAfter - stackDepthBeforeOp;
      const expectedStackChange = IL.calcDynamicStackChangeOfOp(op);
      if (expectedStackChange !== undefined && stackChange !== expectedStackChange) {
        return this.ilError(`Expected opcode "${op.opcode}" to change the stack by ${expectedStackChange} slots, but instead it changed by ${stackChange}`);
      }
    }
  }

  private resolveOperand(operand: IL.Operand, expectedType: IL.OperandType) {
    switch (expectedType) {
      case 'LabelOperand':
        if (operand.type !== 'LabelOperand') {
          return this.ilError('Expected label operand');
        }
        return operand.targetBlockId;
      case 'CountOperand':
        if (operand.type !== 'CountOperand') {
          return this.ilError('Expected count operand');
        }
        return operand.count;
      case 'IndexOperand':
        if (operand.type !== 'IndexOperand') {
          return this.ilError('Expected index operand');
        }
        return operand.index;
      case 'NameOperand':
        if (operand.type !== 'NameOperand') {
          return this.ilError('Expected name operand');
        }
        return operand.name;
      case 'LiteralOperand':
        if (operand.type !== 'LiteralOperand') {
          return this.ilError('Expected literal operand');
        }
        return operand.literal;
      case 'OpOperand':
        if (operand.type !== 'OpOperand') {
          return this.ilError('Expected sub-operation operand');
        }
        return operand.subOperation;
      default: assertUnreachable(expectedType);
    }
  }

  private operationArrayNew() {
    this.push(this.newArray());
  }

  private operationUint8ArrayNew() {
    const lengthValue = this.pop();
    if (lengthValue.type !== 'NumberValue') {
      this.runtimeError('New Uint8Array must be created with integer length');
    }
    const length = lengthValue.value;
    if ((length | 0) !== length) {
      this.runtimeError('New Uint8Array must be created with integer length');
    }
    if (length < 0 || length > 0xFFF-3) {
      this.runtimeError('Uint8Array length out of range');
    }
    this.push(this.newUint8Array(length));
  }

  private operationArrayGet(index: number) {
    const pArray = this.pop();
    if (pArray.type !== 'ReferenceValue') return this.ilError('Using ArrayGet on a non-array');
    const array = this.dereference(pArray);
    if (array.type !== 'ArrayAllocation') return this.ilError('Using ArrayGet on a non-array');
    array.lengthIsFixed || this.ilError('Using ArrayGet on variable-length-array');
    index >= 0 && index < array.items.length || this.ilError('ArrayGet index out of bounds');
    let value = array.items[index];
    // Holes in the array
    if (value === undefined) value = IL.undefinedValue;
    this.push(value);
  }

  private operationArraySet(index: number) {
    const value = this.pop();
    const pArray = this.pop();
    if (pArray.type !== 'ReferenceValue') return this.ilError('Using ArraySet on a non-array');
    const array = this.dereference(pArray);
    if (array.type !== 'ArrayAllocation') return this.ilError('Using ArraySet on a non-array');
    array.lengthIsFixed || this.ilError('Using ArraySet on variable-length-array');
    index >= 0 && index < array.items.length || this.ilError('ArraySet index out of bounds');
    array.items[index] = value;
  }

  private operationBinOp(op_: string) {
    const op = op_ as IL.BinOpCode;
    let right = this.pop();
    let left = this.pop();
    switch (op) {
      case '+': {
        if (left.type === 'StringValue' || right.type === 'StringValue') {
          // String concatenation
          const leftStr = this.convertToString(left);
          const rightStr = this.convertToString(right);
          this.pushString(leftStr + rightStr);
        } else {
          // Arithmetic addition
          const leftNum = this.convertToNumber(left);
          const rightNum = this.convertToNumber(right);
          let result = leftNum + rightNum;
          if (this.opts.overflowChecks === false && isSInt32(leftNum) && isSInt32(rightNum)) {
            result = result | 0;
          }
          this.pushNumber(result);
        }
        break;
      }
      case '-':
      case '/':
      case 'DIVIDE_AND_TRUNC':
      case '%':
      case '*':
      case '**':
      case '&':
      case '|':
      case '>>':
      case '>>>':
      case '<<':
      case '^':
      {
        const leftNum = this.convertToNumber(left);
        const rightNum = this.convertToNumber(right);
        let result: number;
        switch (op) {
          case '-': result = leftNum - rightNum; break;
          case '/': result = leftNum / rightNum; break;
          case 'DIVIDE_AND_TRUNC': result = leftNum / rightNum | 0; break;
          case '%': result = leftNum % rightNum; break;
          case '*': result = leftNum * rightNum; break;
          case '**': result = leftNum ** rightNum; break;
          case '&': result = leftNum & rightNum; break;
          case '|': result = leftNum | rightNum; break;
          case '>>': result = leftNum >> rightNum; break;
          case '>>>': result = leftNum >>> rightNum; break;
          case '<<': result = leftNum << rightNum; break;
          case '^': result = leftNum ^ rightNum; break;
          default: return assertUnreachable(op);
        }
        // Overflow checking changes the semantics of the language
        if (this.opts.overflowChecks === false && op !== '/' && op !== '%' && isSInt32(leftNum) && isSInt32(rightNum)) {
          result = result | 0;
        }
        this.pushNumber(result);
        break;
      }
      case '>':
      case '<':
      case '>=':
      case '<=':
      {
        const leftNum = this.convertToNumber(left);
        const rightNum = this.convertToNumber(right);
        let result: boolean;
        switch (op) {
          case '>': result = leftNum > rightNum; break;
          case '<': result = leftNum < rightNum; break;
          case '>=': result = leftNum >= rightNum; break;
          case '<=': result = leftNum <= rightNum; break;
          default: return assertUnreachable(op);
        }
        this.pushBoolean(result);
        break;
      }
      case '!==': {
        this.pushBoolean(!this.areValuesEqual(left, right));
        break;
      }
      case '===': {
        this.pushBoolean(this.areValuesEqual(left, right));
        break;
      }
      default: return assertUnreachable(op);
    }
  }

  private operationBranch(trueTargetBlockID: string, falseTargetBlockID: string) {
    const condition = this.pop();
    if (this.isTruthy(condition)) {
      this.operationJump(trueTargetBlockID);
    } else {
      this.operationJump(falseTargetBlockID);
    }
  }

  private operationNew(argCount: number) {
    if (argCount < 1) this.ilError('The new operation always needs at least one argument for the `this` value.')
    const args: IL.Value[] = [];
    for (let i = 0; i < argCount; i++) {
      args.unshift(this.pop());
    }
    const class_ = this.pop();
    if (class_.type !== 'ClassValue') {
      this.runtimeError(`Can only use \`new\` on classes, not ${this.getType(class_)}`);
    }
    let prototype = this.getProperty(class_.staticProps, IL.stringValue('prototype'));
    if (this.typeCodeOf(prototype) !== mvm_TeType.VM_T_OBJECT &&
      this.typeCodeOf(prototype) !== mvm_TeType.VM_T_CLASS
    ) {
      prototype = IL.nullValue;
    }
    // The first argument is the `this` value
    args[0] = this.newObject(prototype);

    const constructorFunc = class_.constructorFunc;
    if (constructorFunc.type !== 'FunctionValue' &&
      constructorFunc.type !== 'HostFunctionValue' &&
      !this.isClosure(constructorFunc)
    ) {
      this.ilError('A class constructor must always be a function');
    }

    this.callCommon(constructorFunc, args);
  }

  isClosure(value: IL.Value): value is IL.ReferenceValue<IL.ClosureAllocation> {
    return value.type === 'ReferenceValue' && this.dereference(value).type === 'ClosureAllocation';
  }

  private operationCall(argCount: number) {
    const args: IL.Value[] = [];
    for (let i = 0; i < argCount; i++) {
      args.unshift(this.pop());
    }
    if (this.operationBeingExecuted.opcode !== 'Call') return unexpected();
    // For the moment, I'm making the assumption that the VM doesn't execute IL
    // that's already been through the optimizer, since normally that's the last
    // step before bytecode. We may need to change this in future.
    hardAssert(!this.operationBeingExecuted.staticInfo);
    const callTarget = this.pop();
    if (!this.isCallableValue(callTarget)) {
      return this.runtimeError(`Calling uncallable target (${this.getType(callTarget)})`);
    }

    return this.callCommon(callTarget, args);
  }

  isCallableValue(value: IL.Value): value is IL.CallableValue {
    return (
      value.type === 'FunctionValue' ||
      value.type === 'HostFunctionValue' ||
      value.type === 'EphemeralFunctionValue' ||
      this.isClosure(value)
    )
  }

  private operationJump(targetBlockId: string) {
    this.block = this.func.blocks[targetBlockId];
    if (!this.block) {
      return this.ilError(`Undefined target block: "${targetBlockId}".`)
    }
    this.nextOperationIndex = 0;
  }

  private operationLiteral(value: IL.Value) {
    this.push(value);
  }

  private operationLoadArg(index: number) {
    if (index < 0) {
      return this.ilError(`Illegal argument index: ${index}`);
    }
    if (index >= this.args.length) {
      this.pushUndefined();
    } else {
      this.push(this.args[index]);
    }
  }

  private operationLoadGlobal(name: string) {
    const value = this.globalSlots.get(name);
    if (value === undefined) {
      return this.ilError(`Access to undefined global variable slot: "${name}"`);
    }
    this.push(value.value);
  }

  private operationLoadScoped(index: number) {
    const [arr, i] = this.findScopedVariable(index);
    // Note: if arr[i] is undefined, it is a "hole" in the physical array, which
    // corresponds to the TDZ
    const item = arr[i] ?? unexpected();
    if (item.type === 'DeletedValue')
      return this.runtimeError("Access of variable before its declaration (TDZ)");
    this.push(item);
  }

  private findScopedVariable(index: number): [IL.Value[], number] {
    let pScope = this.closure;
    let localIndexInScope = index;
    while (pScope.type !== 'DeletedValue') {
      if (pScope.type !== 'ReferenceValue') return unexpected();
      const scope = this.dereference(pScope);
      if (scope.type !== 'ClosureAllocation') return unexpected();
      const scopeLength = scope.slots.length;
      if (localIndexInScope < scopeLength) {
        return [scope.slots, localIndexInScope];
      } else {
        // Check parent in scope chain
        pScope = scope.slots[scope.slots.length - 1] ?? unexpected();
        localIndexInScope -= scopeLength;
      }
    }
    this.ilError(`Referencing invalid scoped variable index ${index}`);
  }

  public globalGet(name: string): IL.Value {
    const slotID = this.globalVariables.get(name);
    if (!slotID) {
      return IL.undefinedValue;
    }
    return notUndefined(this.globalSlots.get(slotID)).value;
  }

  public globalSet(name: string, value: IL.Value): void {
    let slotID = this.globalVariables.get(name);
    if (!slotID) {
      slotID = uniqueName('global:' + name, n => this.globalSlots.has(n));
      this.globalVariables.set(name, slotID);
      this.globalSlots.set(slotID, { value: IL.undefinedValue });
    }
    notUndefined(this.globalSlots.get(slotID)).value = value;
  }

  private operationLoadReg(name: string) {
    switch (name) {
      case 'closure': return this.push(this.closure);
      default: unexpected();
    }
  }

  private operationLoadVar(index: number) {
    if (index >= this.variables.length) {
      return this.ilError(`Access to variable index out of range: "${index}"`);
    }
    const value = this.variables[index];
    if (!value || value.type === 'DeletedValue') {
      return this.runtimeError('TDZ Error: Variable accessed before its declaration');
    }
    this.push(value);
  }

  private operationNop(count: number) {
    /* Do nothing */
  }

  // Note: `ObjectNew` is for creating object literals, but `New` is for
  // instantiating classes
  private operationObjectNew() {
    this.push(this.newObject());
  }

  private operationObjectGet() {
    const propertyName = this.pop();
    const objectValue = this.pop();
    const value = this.getProperty(objectValue, propertyName);
    this.push(value);
  }

  private operationObjectKeys() {
    const objectValue = this.pop();
    const keys = this.objectKeys(objectValue);
    this.push(keys);
  }

  private operationObjectSet() {
    const value = this.pop();
    const propertyName = this.pop();
    const objectValue = this.pop();
    this.setProperty(objectValue, propertyName, value);
  }

  private operationClassCreate() {
    const staticProps = this.pop();
    const constructorFunc = this.pop();
    if (staticProps.type !== 'ReferenceValue') unexpected();
    if (this.dereference(staticProps).type !== 'ObjectAllocation') unexpected();
    if (constructorFunc.type !== 'FunctionValue' &&
      constructorFunc.type !== 'HostFunctionValue' &&
      !this.isClosure(constructorFunc)
    ) {
      this.ilError('A class constructor must always be a function');
    }
    this.push({
      type: 'ClassValue',
      staticProps,
      constructorFunc,
    })
  }

  private operationClosureNew() {
    const newScope = this.allocate<IL.ClosureAllocation>({
      type: 'ClosureAllocation',
      slots: [
        this.pop(),   // Function target
        this.closure, // Parent scope
      ]
    });
    this.push(newScope);
  }

  private operationStartTry(catchBlockId: string) {
    const stackDepth = this.stackPointer;
    this.push(this.catchTarget);
    this.push(this.addressOfBlock(catchBlockId));
    this.catchTarget = stackDepth;
  }

  private addressOfBlock(blockId: string): IL.ProgramAddressValue {
    hardAssert(blockId in this.func.blocks);
    return {
      type: 'ProgramAddressValue',
      funcId: this.func.id,
      blockId,
      operationIndex: 0
    }
  }

  private operationEndTry() {
    const catchTarget = this.catchTarget;
    if (catchTarget.type === 'UndefinedValue') return this.ilError('EndTry when there is no catch block');

    hardAssert(catchTarget.frameNumber === this.stackPointer.frameNumber);

    // Unwind the stack variables
    while (this.stackPointer.variableDepth > catchTarget.variableDepth + 2) {
      this.pop();
    }
    hardAssert(this.stackPointer.variableDepth === catchTarget.variableDepth + 2);

    const programAddress = this.pop();
    const previousCatch = this.pop();

    if (previousCatch.type !== 'StackDepthValue' && previousCatch.type !== 'UndefinedValue') {
      return this.ilError('EndTry stack imbalance');
    }
    hardAssert(programAddress.type === 'ProgramAddressValue');

    this.catchTarget = previousCatch;
  }

  private operationPop(count: number) {
    hardAssert(isUInt8(count));
    while (count--)
      this.pop();
  }

  private operationScopePush(slotCount: number) {
    const { newScope, slots } = this.createScope(slotCount);
    // The last slot is a reference to the parent scope
    slots[slots.length - 1] = this.closure;
    this.closure = newScope;
  }

  private operationScopeNew(slotCount: number) {
    const { newScope } = this.createScope(slotCount);
    this.closure = newScope;
  }

  private createScope(slotCount: number) {
    const slots: IL.Value[] = [];
    for (let i = 0; i < slotCount; i++)
      slots.push(IL.deletedValue);

    // A closure without any slots doesn't make sense
    if (slotCount < 1) this.ilError('Unexpected closure slot count');

    const newScope = this.allocate<IL.ClosureAllocation>({
      type: 'ClosureAllocation',
      slots
    });

    return { newScope, slots };
  }

  private operationScopePop() {
    if (this.closure.type !== 'ReferenceValue') return this.ilError('Expected a reference to a closure scope');
    const oldScope = this.dereference(this.closure);
    if (oldScope.type !== 'ClosureAllocation') return this.ilError('Expected a reference to a closure scope');
    const outerScope = oldScope.slots[oldScope.slots.length - 1];
    if (!outerScope) return this.ilError("Expected a reference to a closure scope which can't have less than 1 slot");
    if (outerScope.type !== 'ReferenceValue' && outerScope.type !== 'UndefinedValue') return this.ilError('Invalid scope chain');
    this.closure = outerScope;
  }

  private operationScopeDiscard() {
    if (this.closure.type !== 'ReferenceValue') return this.ilError('Expected a reference to a closure scope');
    this.closure = IL.undefinedValue;
  }

  private operationScopeClone() {
    if (this.closure.type !== 'ReferenceValue') return this.ilError('Expected a reference to a closure scope');
    const oldScope = this.dereference(this.closure);
    if (oldScope.type !== 'ClosureAllocation') return this.ilError('Expected a reference to a closure scope');
    const newScope = this.allocate<IL.ClosureAllocation>({
      type: 'ClosureAllocation',
      slots: [...oldScope.slots]
    });
    this.closure = newScope;
  }

  private operationReturn() {
    const result = this.pop();
    if (!this.callerFrame) {
      return this.ilError('Returning from non-function context')
    }
    this.frame = this.callerFrame;

    // Result of call
    if (this.frame.type === 'InternalFrame') {
      this.push(result);
    } else {
      this.frame.result = result;
    }
  }

  private operationTypeCodeOf() {
    const value = this.pop();
    const typeCode = this.typeCodeOf(value);
    this.pushNumber(typeCode);
  }

  private operationThrow() {
    const exception = this.pop();
    const catchTarget = this.catchTarget;

    if (catchTarget.type === 'UndefinedValue') {
      this.exception = exception;
      // Unwind stack
      while (this.frame) {
        this.popFrame();
      }
      return;
    }

    // Unwind the stack frames
    while (this.stackPointer.frameNumber > catchTarget.frameNumber) {
      this.popFrame();
    }
    hardAssert(this.stackPointer.frameNumber === catchTarget.frameNumber);

    // Unwind the stack variables
    while (this.stackPointer.variableDepth > catchTarget.variableDepth + 2) {
      this.pop();
    }
    hardAssert(this.stackPointer.variableDepth === catchTarget.variableDepth + 2);

    const catchTargetAddress = this.pop();
    const previousCatch = this.pop();

    if (previousCatch.type !== 'StackDepthValue' && previousCatch.type !== 'UndefinedValue') {
      return this.ilError('EndTry stack imbalance');
    }
    if (catchTargetAddress.type !== 'ProgramAddressValue') {
      return this.ilError('Invalid program address of catch block')
    }

    // Push the exception to the stack
    this.push(exception);

    this.catchTarget = previousCatch;

    this.nextProgramCounter = catchTargetAddress;
  }

  private operationStoreGlobal(slotID: string) {
    const value = this.pop();
    const slot = this.globalSlots.get(slotID);
    if (!slot) return this.ilError('Invalid slot ID: ' + slotID);
    slot.value = value;
  }

  private operationStoreScoped(index: number) {
    const value = this.pop();
    const [arr, i] = this.findScopedVariable(index);
    arr[i] = value;
  }

  private operationStoreVar(index: number) {
    const value = this.pop();
    if (index >= this.variables.length) {
      return this.ilError(`Access to variable index out of range: "${index}"`);
    }
    this.variables[index] = value;
  }

  private operationUnOp(op_: string) {
    const op = op_ as IL.UnOpCode;
    let operand = this.pop();
    switch (op) {
      case '!': this.pushBoolean(!this.isTruthy(operand)); break;
      case '+': this.pushNumber(this.convertToNumber(operand)); break;
      case '-': {
        const n = this.convertToNumber(operand);
        let result = -n;
        if (this.opts.overflowChecks === false && isSInt32(n))
          result = n | 0;
        this.pushNumber(result);
        break;
      }
      case '~': this.pushNumber(~this.convertToNumber(operand)); break;
      case 'typeof': this.pushString(this.typeOf(operand)); break;
      case 'typeCodeOf': this.pushNumber(this.typeCodeOf(operand)); break;
      default: return assertUnreachable(op);
    }
  }

  public typeOf(value: IL.Value): string {
    switch (value.type) {
      case 'DeletedValue': return 'undefined';
      case 'UndefinedValue': return 'undefined';
      case 'NullValue': return 'object';
      case 'BooleanValue': return 'boolean';
      case 'NumberValue': return 'number';
      case 'StringValue': return 'string';
      case 'FunctionValue': return 'function';
      case 'HostFunctionValue': return 'function';
      case 'EphemeralFunctionValue': return 'function';
      case 'EphemeralObjectValue': return 'object';
      case 'ProgramAddressValue': return '';
      case 'StackDepthValue': return '';
      case 'ClassValue': return 'function';
      case 'ReferenceValue':
        const alloc = this.dereference(value);
        switch (alloc.type) {
          case 'ObjectAllocation': return 'object';
          case 'ArrayAllocation': return 'object';
          case 'Uint8ArrayAllocation': return 'object';
          case 'ClosureAllocation': return 'function';
          default: return assertUnreachable(alloc);
        }
      default: return assertUnreachable(value);
    }
  }

  public typeCodeOf(value: IL.Value): number {
    switch (value.type) {
      case 'DeletedValue': return mvm_TeType.VM_T_UNDEFINED;
      case 'UndefinedValue': return mvm_TeType.VM_T_UNDEFINED;
      case 'NullValue': return mvm_TeType.VM_T_NULL;
      case 'BooleanValue': return mvm_TeType.VM_T_BOOLEAN;
      case 'NumberValue': return mvm_TeType.VM_T_NUMBER;
      case 'StringValue': return mvm_TeType.VM_T_STRING;
      case 'FunctionValue': return mvm_TeType.VM_T_FUNCTION;
      case 'HostFunctionValue': return mvm_TeType.VM_T_FUNCTION;
      case 'EphemeralFunctionValue': return mvm_TeType.VM_T_FUNCTION;
      case 'EphemeralObjectValue': return mvm_TeType.VM_T_OBJECT;
      case 'ClassValue': return mvm_TeType.VM_T_CLASS;
      case 'ProgramAddressValue': return this.ilError('Cannot use typeCodeOf a program address');
      case 'StackDepthValue': this.ilError('Cannot use typeCodeOf a stack address');
      case 'ReferenceValue':
        const alloc = this.dereference(value);
        switch (alloc.type) {
          case 'ObjectAllocation': return mvm_TeType.VM_T_OBJECT;
          case 'ArrayAllocation': return mvm_TeType.VM_T_ARRAY;
          case 'Uint8ArrayAllocation': return mvm_TeType.VM_T_UINT8_ARRAY;
          case 'ClosureAllocation': return mvm_TeType.VM_T_FUNCTION;
          default: return assertUnreachable(alloc);
        }
      default: return assertUnreachable(value);
    }
  }

  public isTruthy(value: IL.Value): boolean {
    switch (value.type) {
      case 'UndefinedValue':
      case 'NullValue':
      case 'BooleanValue':
      case 'NumberValue':
      case 'StringValue':
        return !!value.value;
      case 'ReferenceValue': return true;
      case 'FunctionValue': return true;
      case 'HostFunctionValue': return true;
      case 'EphemeralFunctionValue': return true;
      case 'EphemeralObjectValue': return true;
      case 'ClassValue': return true;
      // Deleted values should be converted to "undefined" (or a TDZ error) upon reading them
      case 'DeletedValue': return unexpected();
      // The user shouldn't have access to these values
      case 'ProgramAddressValue': return unexpected();
      case 'StackDepthValue': return unexpected();
      default: assertUnreachable(value);
    }
  }

  // An error that represents an invalid action in user code
  private runtimeError(message: string): never {
    throw new RuntimeError(`VM runtime error: ${message}\n      at (${this.filename}:${this.operationBeingExecuted.sourceLoc?.line}:${this.operationBeingExecuted.sourceLoc?.column})`);
  }

  /**
   * An error that likely occurs because of malformed IL
   * @param message
   */
  private ilError(message: string): never {
    if (this.frame && this.operationBeingExecuted) {
      throw new Error(`VM IL error: ${message}\n      at (${this.currentSourceLocation})`);
    } else {
      throw new Error(`VM IL error: ${message}`);
    }
  }

  get currentSourceLocation(): string | undefined {
    const operation = this.operationBeingExecuted;
    if (!operation) return undefined;
    const sourceLoc = operation.sourceLoc;
    const line = sourceLoc?.line;
    const col = sourceLoc ? sourceLoc.column + 1 : undefined;
    return `${this.filename}:${line}:${col}`;
  }

  private pop() {
    const value = this.variables.pop();
    if (!value) {
      return this.ilError('Stack unbalanced');
    }
    return value;
  }

  private checkIndexValue(index: number) {
    if ((index | 0) !== index) {
      return this.runtimeError('Indexing array with non-integer');
    }
    if (index < 0 || index > IL.MAX_INDEX) {
      return this.runtimeError(`Index of value ${index} exceeds maximum index range.`);
    }
  }

  private push(value: IL.Value) {
    hardAssert(value !== undefined);
    this.variables.push(value);
    hardAssert(this.variables.length <= this.func.maxStackDepth);
  }

  private pushString(value: string) {
    this.push({
      type: 'StringValue',
      value
    })
  }

  private pushUndefined() {
    this.push(IL.undefinedValue)
  }

  private pushNumber(value: number) {
    this.push({
      type: 'NumberValue',
      value
    })
  }

  private pushBoolean(value: boolean) {
    this.push({
      type: 'BooleanValue',
      value
    })
  }

  public convertToString(value: IL.Value): string {
    switch (value.type) {
      case 'ReferenceValue': {
        const allocation = this.dereference(value);
        switch (allocation.type) {
          case 'ArrayAllocation': return '[Array]';
          case 'ObjectAllocation': return '[Object]';
          case 'Uint8ArrayAllocation': return '[Object]';
          case 'ClosureAllocation': return '[Function]';
          default: return assertUnreachable(allocation);
        }
      }
      case 'BooleanValue': return value.value ? 'true' : 'false';
      case 'FunctionValue': return '[Function]';
      case 'HostFunctionValue': return '[Function]';
      case 'EphemeralFunctionValue': return '[Function]';
      case 'ClassValue': return '[Class]';
      case 'EphemeralObjectValue': return '[Object]';
      case 'NullValue': return 'null';
      case 'UndefinedValue': return 'undefined';
      case 'NumberValue': return value.value.toString();
      case 'StringValue': return value.value;
      // Deleted values should be converted to "undefined" (or a TDZ error) upon reading them
      case 'DeletedValue': return unexpected();
      // The user shouldn't have access to these values
      case 'ProgramAddressValue': return unexpected();
      case 'StackDepthValue': return unexpected();

      default: assertUnreachable(value);
    }
  }

  private convertToNumber(value: IL.Value): number {
    switch (value.type) {
      case 'ReferenceValue': return NaN;
      case 'BooleanValue': return value.value ? 1 : 0;
      case 'FunctionValue': return NaN;
      case 'HostFunctionValue': return NaN;
      case 'EphemeralFunctionValue': return NaN;
      case 'EphemeralObjectValue': return NaN;
      case 'ClassValue': return NaN;
      case 'NullValue': return 0;
      case 'UndefinedValue': return NaN;
      case 'NumberValue': return value.value;
      case 'StringValue': return +value.value;
      // Deleted values should be converted to "undefined" (or a TDZ error) upon reading them
      case 'DeletedValue': return unexpected();
      // The user shouldn't have access to these values
      case 'ProgramAddressValue': return unexpected();
      case 'StackDepthValue': return unexpected();
      default: assertUnreachable(value);
    }
  }

  public areValuesEqual(value1: IL.Value, value2: IL.Value): boolean {
    if (value1.type !== value2.type) return false;

    if (value1.type === 'ClassValue') {
      return this.areValuesEqual(value1.constructorFunc, (value2 as IL.ClassValue).constructorFunc)
        && this.areValuesEqual(value1.staticProps, (value2 as IL.ClassValue).staticProps)
    }

    // Some internal types that should never be compared
    if (value1.type === 'StackDepthValue' || value1.type === 'ProgramAddressValue' ||
      value2.type === 'StackDepthValue' || value2.type === 'ProgramAddressValue'
    ) {
        return unexpected();
    }


    // It happens to be the case that all other types compare equal if the inner
    // value is equal
    return value1.value === (value2 as typeof value1).value;
  }

  private callCommon(funcValue: IL.CallableValue, args: IL.Value[]) {
    if (funcValue.type === 'HostFunctionValue') {
      if (!this.frame) {
        return unexpected();
      }
      const extFunc = this.hostFunctions.get(funcValue.value);
      if (!extFunc) {
        return this.runtimeError(`External function "${funcValue.value}" not linked`);
      }
      // Handle temporarily because the called function can run a garbage collection and these values are not on the VM stack
      const handledArgs = args.map(a => this.createHandle(a));
      const handledFunc = this.createHandle(funcValue);

      const resultHandle = extFunc.call(args);

      const resultValue = resultHandle || IL.undefinedValue;
      handledArgs.forEach(a => a.release());
      handledFunc.release();
      if (!this.frame) {
        return unexpected();
      }
      if (this.frame.type === 'InternalFrame') {
        this.push(resultValue);
      } else {
        this.frame.result = resultValue;
      }
    } else if (funcValue.type === 'EphemeralFunctionValue') {
      if (!this.frame) {
        return unexpected();
      }
      const func = this.ephemeralFunctions.get(funcValue.value);
      if (!func) {
        return this.runtimeError(`Ephemeral function "${funcValue.value}" not linked`);
      }
      // Handle temporarily because the called function can run a garbage collection and these values are not on the VM stack
      const handledArgs = args.map(a => this.createHandle(a));
      const handledFunc = this.createHandle(funcValue);

      const resultHandle = func.call(args);

      const resultValue = resultHandle || IL.undefinedValue;
      handledArgs.forEach(a => a.release());
      handledFunc.release();
      if (!this.frame) {
        return unexpected();
      }
      if (this.frame.type === 'InternalFrame') {
        this.push(resultValue);
      } else {
        this.frame.result = resultValue;
      }
    } else if (funcValue.type === 'FunctionValue') {
      const func = notUndefined(this.functions.get(funcValue.value));
      const block = func.blocks[func.entryBlockID];
      this.pushFrame({
        type: 'InternalFrame',
        frameNumber: this.frame ? this.frame.frameNumber + 1 : 1,
        callerFrame: this.frame,
        scope: IL.deletedValue,
        filename: func.sourceFilename,
        func: func,
        block,
        nextOperationIndex: 0,
        operationBeingExecuted: block.operations[0],
        variables: [],
        args: args
      });
    } else if (this.isClosure(funcValue)) {
      const closure = this.dereference(funcValue);
      const funcTargetValue = closure.slots[0];
      if (funcTargetValue.type !== 'FunctionValue') {
        // For the moment, I'm assuming that closures point to IL functions
        return notImplemented('Closures referencing non-IL targets');
      }
      const func = notUndefined(this.functions.get(funcTargetValue.value));
      const block = func.blocks[func.entryBlockID];
      this.pushFrame({
        type: 'InternalFrame',
        frameNumber: this.frame ? this.frame.frameNumber + 1 : 1,
        callerFrame: this.frame,
        scope: funcValue,
        filename: func.sourceFilename,
        func: func,
        block,
        nextOperationIndex: 0,
        operationBeingExecuted: block.operations[0],
        variables: [],
        args: args
      });
    } else {
      assertUnreachable(funcValue);
    }
  }

  // This is similar to `typeOf` in that it returns a string, but it provides
  // more granular types than `typeOf`, for the purposes of debug/error
  // messages.
  public getType(value: IL.Value): string {
    switch (value.type) {
      case 'UndefinedValue': return 'undefined';
      case 'NullValue': return 'null';
      case 'BooleanValue': return 'boolean';
      case 'NumberValue': return 'number';
      case 'StringValue': return 'string';
      case 'ReferenceValue':
        const allocationType = this.dereference(value).type;
        switch (allocationType) {
          case 'ObjectAllocation': return 'object';
          case 'ArrayAllocation': return 'array';
          case 'Uint8ArrayAllocation': return 'Uint8Array';
          case 'ClosureAllocation': return 'closure';
          default: assertUnreachable(allocationType);
        }
      case 'FunctionValue': return 'function';
      case 'HostFunctionValue': return 'function';
      case 'ClassValue': return 'class';
      case 'EphemeralFunctionValue': return 'function';
      case 'EphemeralObjectValue': return 'object';
      // Deleted values should be converted to "undefined" (or a TDZ error) upon reading them
      case 'DeletedValue': return unexpected();
      // The user shouldn't have access to these values
      case 'ProgramAddressValue': return unexpected();
      case 'StackDepthValue': return unexpected();
      default: return assertUnreachable(value);
    }
  }

  private get internalFrame(): VM.InternalFrame {
    if (!this.frame || this.frame.type !== 'InternalFrame') {
      return unexpected();
    }
    return this.frame;
  }

  private get closure() {
    return this.internalFrame.scope;
  }

  private set closure(value: IL.Value) {
    this.internalFrame.scope = value;
  }

  // Used for debugging and testing
  convertToNativePOD(value: IL.Value): any {
    switch (value.type) {
      case 'UndefinedValue':
      case 'NullValue':
      case 'BooleanValue':
      case 'NumberValue':
      case 'StringValue':
        return value.value;
      case 'FunctionValue':
      case 'HostFunctionValue':
      case 'EphemeralFunctionValue':
      case 'EphemeralObjectValue':
      case 'ClassValue':
        return invalidOperation(`Cannot convert ${value.type} to POD`)
      case 'ReferenceValue':
        const allocation = this.dereference(value);
        switch (allocation.type) {
          case 'ArrayAllocation': return allocation.items.map(v => v ? this.convertToNativePOD(v) : undefined);
          case 'ObjectAllocation': {
            const result = Object.create(null);
            for (const k of Object.keys(value.value)) {
              result[k] = this.convertToNativePOD(allocation.properties[k]);
            }
            return result;
          }
          case 'Uint8ArrayAllocation': {
            return allocation.bytes;
          }
          case 'ClosureAllocation': {
            return invalidOperation(`Cannot convert ${allocation.type} to POD`)
          }
          default: assertUnreachable(allocation);
        }
      // Deleted values should be converted to "undefined" (or a TDZ error) upon reading them
      case 'DeletedValue': return unexpected();
      // The user shouldn't have access to these values
      case 'ProgramAddressValue': return unexpected();
      case 'StackDepthValue': return unexpected();
      default:
        return assertUnreachable(value);
    }
  }

  getStackAsString(): string {
    let frame: VM.Frame | undefined = this.frame;
    const lines: string[] = [];
    while (frame) {
      if (frame.type === 'ExternalFrame') {
        // lines.push('at <external>');
      } else {
        const op = frame.operationBeingExecuted;
        const loc = op.sourceLoc;
        lines.push(`at ${frame.func.id} (${frame.filename}:${loc?.line}:${loc?.column})`);
      }
      frame = frame.callerFrame;
    }
    return lines
      .map(l => `      ${l}`)
      .join('\n');
  }

  public numberValue(value: number): IL.NumberValue {
    typeof value === 'number' || unexpected();
    return {
      type: 'NumberValue',
      value
    }
  }

  public booleanValue(value: boolean): IL.BooleanValue {
    return {
      type: 'BooleanValue',
      value
    }
  }

  public stringValue(value: string): IL.StringValue {
    return {
      type: 'StringValue',
      value
    }
  }

  public newObject(prototype: IL.Value = IL.nullValue): IL.ReferenceValue<IL.ObjectAllocation> {
    return this.allocate<IL.ObjectAllocation>({
      type: 'ObjectAllocation',
      prototype,
      properties: Object.create(null)
    });
  }

  public newArray({ fixedLength }: { fixedLength: boolean } = { fixedLength: false }): IL.ReferenceValue<IL.ArrayAllocation> {
    return this.allocate<IL.ArrayAllocation>({
      type: 'ArrayAllocation',
      items: [],
      lengthIsFixed: fixedLength
    });
  }

  public newUint8Array(length: number): IL.ReferenceValue<IL.Uint8ArrayAllocation> {
    return this.allocate<IL.Uint8ArrayAllocation>({
      type: 'Uint8ArrayAllocation',
      bytes: [...new Array(length)].map(() => 0)
    });
  }

  private allocate<T extends IL.Allocation>(value: Omit<T, 'allocationID'>): IL.ReferenceValue<T> {
    const allocationID = this.nextHeapID++;
    const allocation: IL.Allocation = {
      ...value,
      allocationID
    } as any;
    this.allocations.set(allocationID, allocation);
    return {
      type: 'ReferenceValue',
      value: allocationID
    };
  }

  public dereference<T extends IL.Allocation>(value: IL.ReferenceValue<T>): T {
    const allocationID = value.value;
    const allocation = this.allocations.get(allocationID);
    if (!allocation) return unexpected(`Could not find allocation with ID ${allocationID}`);
    return allocation as T;
  }

  public garbageCollect() {
    garbageCollect({
      globalVariables: this.globalVariables,
      globalSlots: this.globalSlots,
      frame: this.frame,
      handles: this.handles,
      exports: this.exports,
      moduleCache: this.moduleCache,
      allocations: this.allocations,
      hostFunctions: this.hostFunctions,
      functions: this.functions,
      builtins: this.builtins
    });
  }

  stringifyState() {
    return `${
      entries(this.globalVariables)
        .map(([k, v]) => `global ${stringifyIdentifier(k)} = &slot ${stringifyIdentifier(v)};`)
        .join('\n')
    }\n\n${
      entries(this.exports)
        .map(([k, v]) => `export ${k} = ${stringifyValue(v)};`)
        .join('\n')
    }\n\n${
      entries(this.globalSlots)
        .map(([k, v]) => `slot ${stringifyIdentifier(k)} = ${stringifyValue(v.value)};`)
        .join('\n')
    }\n\n${
      [...this.handles]
        .map(v => `handle ${stringifyValue(v.value)};`)
        .join('\n')
    }\n\n${
      entries(this.functions)
        .map(([, v]) => stringifyFunction(v, ''))
        .join('\n\n')
    }\n\n${
      entries(this.allocations)
        .map(([k, v]) => `allocation ${k} = ${stringifyAllocation(v)};`)
        .join('\n\n')
    }`;
  }

  getProperty(objectValue: IL.Value, propertyNameValue: IL.Value): IL.Value {
    const propertyName = this.toPropertyName(propertyNameValue);

    if (objectValue.type === 'EphemeralObjectValue') {
      const ephemeralObjectID = objectValue.value;
      const ephemeralObject = notUndefined(this.ephemeralObjects.get(ephemeralObjectID));
      return ephemeralObject.get(objectValue, propertyName);
    }

    if (objectValue.type === 'ClassValue') {
      return this.getProperty(objectValue.staticProps, propertyNameValue);
    }

    if (objectValue.type !== 'ReferenceValue') {
      return this.runtimeError(`Cannot access property "${propertyName}" on value of type "${this.getType(objectValue)}"`);
    }

    const object = this.dereference(objectValue);

    if (object.type === 'Uint8ArrayAllocation') {
      if (propertyName === 'length') {
        return this.numberValue(object.bytes.length);
      } else if (propertyName === '__proto__') {
        return this.runtimeError('Prototype of Uint8Array is not accessible in Microvium');
      }
      if (typeof propertyName !== 'number' || (propertyName | 0) !== propertyName) {
        return this.runtimeError('Invalid index into Uint8Array');
      }
      this.checkIndexValue(propertyName)

      if (propertyName < 0 || propertyName >= object.bytes.length) {
        return IL.undefinedValue;
      }

      return this.numberValue(object.bytes[propertyName] ?? unexpected());
    }

    if (object.type === 'ArrayAllocation') {
      const array = object;
      if (propertyName === 'length') {
        return this.numberValue(array.items.length);
      } else if (propertyName === '__proto__') {
        return this.builtins.arrayPrototype;
      } else if (typeof propertyName === 'number') {
        const index = propertyName;
        this.checkIndexValue(index);
        if (index >= 0 && index < array.items.length) {
          const value = array.items[index];
          if (value) {
            // Holes are represented as holes, not as deleted values
            hardAssert(value.type !== 'DeletedValue');
            return value;
          } else {
            return IL.undefinedValue;
          }
        } else {
          return IL.undefinedValue;
        }
      } else {
        if (this.builtins.arrayPrototype.type !== 'NullValue') {
          return this.getProperty(this.builtins.arrayPrototype, propertyNameValue);
        }
        return IL.undefinedValue;
      }
    }

    if (object.type === 'ObjectAllocation') {
      if (propertyName === '__proto__') {
        return object.prototype;
      }
      let obj: IL.ObjectAllocation | undefined = object;
      while (obj) {
        const props = obj.properties;
        if (propertyName in props) {
          const value = props[propertyName];
          // Holes are represented as holes, not as deleted values
          hardAssert(value.type !== 'DeletedValue');
          return value;
        }
        const prototype: IL.Value = obj.prototype;
        if (prototype.type === 'NullValue') {
          obj = undefined;
        } else if (prototype.type === 'ReferenceValue') {
          const prototypeValue: IL.Allocation = this.dereference(prototype);
          if (prototypeValue.type !== 'ObjectAllocation') {
            this.ilError(`Expected object prototype: ${this.getType(prototype)}`);
          }
          obj = prototypeValue;
        } else {
          this.ilError(`Unexpected object prototype: ${this.getType(prototype)}`);
        }
      }
      return IL.undefinedValue;
    }

    return this.runtimeError(`Cannot access property "${propertyName}" on value of type "${this.getType(objectValue)}"`);
  }

  objectKeys(objectValue: IL.Value): IL.Value {
    // Note: Microvium does not support ObjectKeys on arrays
    if (this.getType(objectValue) !== 'object') {
      return this.runtimeError(`Cannot get object keys from value of type "${this.getType(objectValue)}"`);
    }

    let keys: Array<VM.PropertyKey | VM.Index>;

    if (objectValue.type === 'EphemeralObjectValue') {
      const ephemeralObjectID = objectValue.value;
      const ephemeralObject = notUndefined(this.ephemeralObjects.get(ephemeralObjectID));
      keys = ephemeralObject.keys(objectValue);
    } else {
      if (objectValue.type !== 'ReferenceValue') unexpected();
      const object = this.dereference(objectValue);
      if (object.type !== 'ObjectAllocation') unexpected();
      keys = Reflect.ownKeys(object.properties) as string[];
    }

    const result = this.newArray({ fixedLength: true });
    for (let i = 0; i < keys.length; i++) {
      const key = keys[i];
      const value = typeof key === 'string' ? this.stringValue(key) : this.numberValue(key);
      this.setProperty(result, this.numberValue(i), value);
    }

    return result;
  }

  private toPropertyName(propertyNameValue: IL.Value): VM.PropertyKey | VM.Index {
    // TODO: This condition is too weak. A value like `3.1` can't be used as a property name
    if (propertyNameValue.type === 'StringValue' || propertyNameValue.type === 'NumberValue') {
      return propertyNameValue.value;
    } else {
      // Property indexes in Microvium are limited to numbers or strings. We
      // don't automatically coerce to a string.
      return this.runtimeError('Property index must be a number or a string')
    }
  }

  setProperty(objectValue: IL.Value, propertyNameValue: IL.Value, value: IL.Value): void {
    hardAssert(value.type !== 'DeletedValue');
    const propertyName = this.toPropertyName(propertyNameValue);
    if (objectValue.type === 'EphemeralObjectValue') {
      const ephemeralObjectID = objectValue.value;
      const ephemeralObject = notUndefined(this.ephemeralObjects.get(ephemeralObjectID));
      ephemeralObject.set(objectValue, propertyName, value);
      return;
    }

    if (objectValue.type === 'ClassValue') {
      return this.setProperty(objectValue.staticProps, propertyNameValue, value);
    }

    if (objectValue.type !== 'ReferenceValue') {
      return this.runtimeError(`Cannot access property "${propertyName}" on value of type "${this.getType(objectValue)}"`);
    }
    const object = this.dereference(objectValue);

    if (object.type === 'Uint8ArrayAllocation') {
      if (propertyName === 'length') {
        this.runtimeError('Uint8Array cannot be resized')
      } else if (propertyName === '__proto__') {
        return this.runtimeError('Prototype of Uint8Array is not accessible in Microvium');
      }
      if (typeof propertyName !== 'number' || (propertyName | 0) !== propertyName) {
        return this.runtimeError('Invalid index into Uint8Array');
      }
      this.checkIndexValue(propertyName)

      if (propertyName < 0 && propertyName >= object.bytes.length) {
        return this.runtimeError(`Uint8Array index out of bounds (${propertyName})`)
      }

      if (value.type !== 'NumberValue' || (value.value & 0xFF) !== value.value) {
        return this.runtimeError(`Cannot assign non-byte to element of Uint8Array`)
      }

      object.bytes[propertyName] = value.value;
      return;
    }


    if (object.type === 'ArrayAllocation') {
      const array = object.items;
      // Assigning an array length resizes the array
      if (propertyName === 'length') {
        if (value.type !== 'NumberValue') {
          return this.runtimeError(`Invalid array length: ${stringifyValue(value)}`);
        }
        if (object.lengthIsFixed) {
          return this.runtimeError(`Cannot set length of fixed-length array: ${stringifyValue(value)}`);
        }
        const newLength = value.value;
        this.checkIndexValue(newLength);
        array.length = newLength;
      } else if (typeof propertyName === 'number') {
        const index = propertyName;
        this.checkIndexValue(index);
        if (index > array.length && object.lengthIsFixed) {
          return this.runtimeError(`Cannot assign past the end of fixed-length array: ${stringifyValue(value)}`);
        }
        array[index] = value;
      } else if (propertyName === '__proto__') {
        return this.runtimeError('Illegal access of Array.__proto__');
      } else {
        // JavaScript doesn't seem to throw by default when you set properties
        // on immutable objects. Here, I'm just treating the array as if it were
        // immutable with respect to non-index properties, and so here I'm just
        // ignoring the write.
        return;
      }

      return;
    }

    if (object.type === 'ObjectAllocation') {
      if (propertyName === '__proto__') {
        return this.runtimeError('Microvium prototype references are not mutable');
      }
      object.properties[propertyName] = value;

      return;
    }

    return this.runtimeError(`Cannot access property "${propertyName}" on value of type "${this.getType(objectValue)}"`);
  }

  private pushFrame(frame: VM.Frame) {
    frame.callerFrame = this.frame;
    this.frame = frame;
  }

  private popFrame(): VM.Frame {
    const result = this.frame;
    if (result === undefined) {
      return invalidOperation('Frame stack underflow')
    }
    this.frame = result.callerFrame;
    return result;
  }

  addBuiltinGlobals() {
    // Note: VirtualMachineFriendly also adds its own globals. The globals here
    // are ones that require custom IL.

    // Note: if we add more globals, then this needs refactoring

    /* Reflect.ownKeys uses the custom IL instruction `ObjectKeys` which can't
    be generated syntactically. Hopefully there aren't too many cases like this
    in future. */
    const obj_Reflect = this.newObject()
    this.globalSet('Reflect', obj_Reflect)
    this.setProperty(obj_Reflect, this.stringValue('ownKeys'), this.importCustomILFunction('Reflect.ownKeys', {
      entryBlockID: 'entry',
      blocks: {
        'entry': {
          id: 'entry',
          expectedStackDepthAtEntry: 0,
          operations: [
            // The first arg is the `this` value, and the second is the object
            { opcode: 'LoadArg', operands: [indexOperand(1)], stackDepthBefore: 0, stackDepthAfter: 1 },
            { opcode: 'ObjectKeys', operands: [], stackDepthBefore: 1, stackDepthAfter: 1 },
            { opcode: 'Return', operands: [], stackDepthBefore: 1, stackDepthAfter: 0 },
          ]
        }
      }
    }));

    /* Microvium.newUint8Array uses the custom IL instruction `Uint8ArrayNew`
    which can't be generated syntactically. */
    const obj_Microvium = this.newObject()
    this.globalSet('Microvium', obj_Microvium)
    this.setProperty(obj_Microvium, this.stringValue('newUint8Array'), this.importCustomILFunction('Microvium.newUint8Array', {
      entryBlockID: 'entry',
      blocks: {
        'entry': {
          id: 'entry',
          expectedStackDepthAtEntry: 0,
          operations: [
            // The first arg is the `this` value, and the second is the object
            { opcode: 'LoadArg', operands: [indexOperand(1)], stackDepthBefore: 0, stackDepthAfter: 1 },
            { opcode: 'Uint8ArrayNew', operands: [], stackDepthBefore: 1, stackDepthAfter: 1 },
            { opcode: 'Return', operands: [], stackDepthBefore: 1, stackDepthAfter: 0 },
          ]
        }
      }
    }));


    this.setProperty(obj_Microvium, this.stringValue('typeCodeOf'), this.importCustomILFunction('typeCodeOf', {
      entryBlockID: 'entry',
      blocks: {
        'entry': {
          id: 'entry',
          expectedStackDepthAtEntry: 0,
          operations: [
            // The first arg is the `this` value, and the second is the object
            { opcode: 'LoadArg', operands: [indexOperand(1)], stackDepthBefore: 0, stackDepthAfter: 1 },
            { opcode: 'TypeCodeOf', operands: [], stackDepthBefore: 1, stackDepthAfter: 1 },
            { opcode: 'Return', operands: [], stackDepthBefore: 1, stackDepthAfter: 0 },
          ]
        }
      }
    }));
  }

  importCustomILFunction(nameHint: string, il: Pick<VM.Function, 'entryBlockID' | 'blocks'>): IL.FunctionValue {
    const funID_ownKeys = uniqueName('Reflect_ownKeys', n => this.functions.has(n))
    const fun_ownKeys: VM.Function = {
      type: 'Function',
      id: funID_ownKeys,
      maxStackDepth: undefined as any,
      moduleHostContext: undefined,  // Populated later
      ...il
    }
    computeMaximumStackDepth(fun_ownKeys);
    this.functions.set(funID_ownKeys, fun_ownKeys);
    return {
      type: 'FunctionValue',
      value: funID_ownKeys
    }
  }

  /**
   * Gets a value that represents the current depth in the stack. In the native
   * VM, this can be a single number measuring the number of slots relative to
   * the base of the stack.
   *
   * This is used for SetJmp to mark the current position in the stack so it can
   * be restored later.
   */
  private get stackPointer(): IL.StackDepthValue {
    const variableDepth = (this.frame && this.frame.type === 'InternalFrame')
      ? this.frame.variables.length
      : 0;

    return {
      type: 'StackDepthValue',
      frameNumber: this.frame ? this.frame.frameNumber + 1 : 1,
      variableDepth
    }
  }

  private get nextProgramCounter(): IL.ProgramAddressValue {
    return {
      type: 'ProgramAddressValue',
      funcId: this.func.id,
      blockId: this.block.id,
      operationIndex: this.nextOperationIndex,
    }
  }

  private set nextProgramCounter(value: IL.ProgramAddressValue) {
    this.func = this.functions.get(value.funcId) ?? unexpected();
    this.block = this.func.blocks[value.blockId] ?? unexpected();
    this.nextOperationIndex = value.operationIndex;
  }

  // Frame properties
  private get args() { return this.internalFrame.args; }
  private get block() { return this.internalFrame.block; }
  private get callerFrame() { return this.internalFrame.callerFrame; }
  private get filename() { return this.internalFrame.filename; }
  private get func() { return this.internalFrame.func; }
  private get nextOperationIndex() { return this.internalFrame.nextOperationIndex; }
  private get operationBeingExecuted() { return this.internalFrame.operationBeingExecuted; }
  private get variables() { return this.internalFrame.variables; }
  private set args(value: IL.Value[]) { this.internalFrame.args = value; }
  private set block(value: IL.Block) { this.internalFrame.block = value; }
  private set callerFrame(value: VM.Frame | undefined) { this.internalFrame.callerFrame = value; }
  private set filename(value: string | undefined) { this.internalFrame.filename = value; }
  private set func(value: VM.Function) { this.internalFrame.func = value; }
  private set nextOperationIndex(value: number) { this.internalFrame.nextOperationIndex = value; }
  private set operationBeingExecuted(value: IL.Operation) { this.internalFrame.operationBeingExecuted = value; }
  private set variables(value: IL.Value[]) { this.internalFrame.variables = value; }
}

function garbageCollect({
  globalVariables,
  globalSlots,
  frame,
  handles,
  exports,
  moduleCache,
  allocations,
  hostFunctions,
  functions,
  builtins
}: {
  globalVariables: Map<IL.GlobalVariableName, VM.GlobalSlotID>,
  globalSlots: Map<VM.GlobalSlotID, VM.GlobalSlot>,
  frame: VM.Frame | undefined,
  handles: Set<VM.Handle<IL.Value>>,
  exports: Map<IL.ExportID, IL.Value>,
  moduleCache: Map<VM.ModuleSource, VM.ModuleObject>,
  allocations: Map<IL.AllocationID, IL.Allocation>,
  hostFunctions: Map<IL.HostFunctionID, VM.HostFunctionHandler>,
  functions: Map<IL.FunctionID, VM.Function>,
  builtins: { [name: string]: IL.Value }
}) {
  const reachableFunctions = new Set<string>();
  const reachableAllocations = new Set<IL.Allocation>();
  const reachableGlobalSlots = new Set<VM.GlobalSlotID>();
  const reachableHostFunctions = new Set<IL.HostFunctionID>();

  // Global variable roots
  for (const slotID of globalVariables.values()) {
    const slot = notUndefined(globalSlots.get(slotID));
    reachableGlobalSlots.add(slotID);
    markValueIsReachable(slot.value);
  }

  // Roots on the stack
  while (frame) {
    frameIsReachable(frame);
    frame = frame.callerFrame;
  }

  // Roots in handles
  for (const handle of handles) {
    markValueIsReachable(handle.value);
  }

  // Roots in exports
  for (const e of exports.values()) {
    markValueIsReachable(e);
  }

  // Roots in imports
  for (const moduleObjectValue of moduleCache.values()) {
    markValueIsReachable(moduleObjectValue);
  }

  // Roots in the builtins
  for (const builtin of Object.values(builtins)) {
    markValueIsReachable(builtin);
  }

  // Sweep allocations
  for (const [i, a] of allocations) {
    if (!reachableAllocations.has(a)) {
      allocations.delete(i);
    }
  }

  for (const slotID of globalSlots.keys()) {
    if (!reachableGlobalSlots.has(slotID)) {
      const slotIDToDelete = slotID;
      globalSlots.delete(slotIDToDelete);
    }
  }

  // Sweep host functions
  for (const extID of hostFunctions.keys()) {
    if (!reachableHostFunctions.has(extID)) {
      hostFunctions.delete(extID);
    }
  }

  // Sweep functions
  for (const functionID of functions.keys()) {
    if (!reachableFunctions.has(functionID)) {
      functions.delete(functionID);
    }
  }

  function markValueIsReachable(value: IL.Value) {
    switch (value.type) {
      case 'FunctionValue': {
        const func = notUndefined(functions.get(value.value));
        functionIsReachable(func);
        break;
      }
      case 'HostFunctionValue': {
        reachableHostFunctions.add(value.value);
        break;
      }
      case 'ReferenceValue': {
        allocationIsReachable(value.value);
        break;
      }
      case 'ClassValue': {
        markValueIsReachable(value.constructorFunc);
        markValueIsReachable(value.staticProps);
        break;
      }

      // Listing these explicitly so that we get a compile error if we add new types later
      case 'DeletedValue':
      case 'UndefinedValue':
      case 'NullValue':
      case 'BooleanValue':
      case 'NumberValue':
      case 'StringValue':
      case 'EphemeralFunctionValue':
      case 'EphemeralObjectValue':
      case 'ProgramAddressValue':
      case 'StackDepthValue':
        break;


      default: assertUnreachable(value);
    }
  }

  function allocationIsReachable(allocationID: IL.AllocationID) {
    const allocation = notUndefined(allocations.get(allocationID));
    if (reachableAllocations.has(allocation)) {
      // Already visited
      return;
    }
    reachableAllocations.add(allocation);
    switch (allocation.type) {
      case 'ArrayAllocation': return allocation.items.forEach(markValueIsReachable);
      case 'ObjectAllocation': return [...Object.values(allocation.properties)].forEach(markValueIsReachable);
      case 'Uint8ArrayAllocation': return; // Entries are POD bytes
      case 'ClosureAllocation': return allocation.slots.forEach(markValueIsReachable);
      default: return assertUnreachable(allocation);
    }
  }

  function frameIsReachable(frame: VM.Frame) {
    if (frame.type === 'ExternalFrame') {
      markValueIsReachable(frame.result);
      return;
    }
    frame.args.forEach(markValueIsReachable);
    frame.variables.forEach(markValueIsReachable);
    markValueIsReachable(frame.scope);
  }

  function functionIsReachable(func: VM.Function) {
    if (reachableFunctions.has(func.id)) {
      // Already visited
      return;
    }
    reachableFunctions.add(func.id);
    for (const block of Object.values(func.blocks)) {
      for (const op of block.operations) {
        if (op.opcode === 'LoadGlobal' || op.opcode === 'StoreGlobal') {
          const nameOperand = op.operands[0];
          if (nameOperand.type !== 'NameOperand') return unexpected();
          const name = nameOperand.name;
          reachableGlobalSlots.add(name);
          const globalVariable = notUndefined(globalSlots.get(name));
          markValueIsReachable(globalVariable.value);
        } else if (op.opcode === 'Literal') {
          const [valueOperand] = op.operands;
          if (valueOperand.type !== 'LiteralOperand') return unexpected();
          markValueIsReachable(valueOperand.literal);
        }
      }
    }
  }
}

// TODO | MED | Raf: Possibly move this to some other file and remove the class
// wrapper
class DebuggerHelpers {
  static stringifyILValue(value: IL.Value) {
    switch (value.type) {
      case 'EphemeralFunctionValue':
        return DebuggerHelpers.displayInternals(`Ephemeral Function ${value.value}`);
      case 'EphemeralObjectValue':
        return DebuggerHelpers.displayInternals(`Ephemeral Object ${value.value}`);
      case 'FunctionValue':
        return DebuggerHelpers.displayInternals(`Function ${value.value}`);
      case 'HostFunctionValue':
        return DebuggerHelpers.displayInternals(`Host Function ${value.value}`);
      case 'ReferenceValue':
        return DebuggerHelpers.displayInternals(`Allocation ${value.value}`);
      case 'NumberValue':
      case 'BooleanValue':
      case 'StringValue':
      case 'NullValue':
        return 'null';
      case 'UndefinedValue':
        return 'undefined';
      default:
        return unexpected(`global slot: ${JSON.stringify(value)}`);
    }
  }

  static displayInternals(content: string) {
    return `[[ ${content} ]]`;
  }
}