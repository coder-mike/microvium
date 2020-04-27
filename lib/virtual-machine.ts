import * as IL from './il';
import * as VM from './virtual-machine-types';
import _ from 'lodash';
import { SnapshotInfo, encodeSnapshot } from "./snapshot-info";
import { notImplemented, invalidOperation, uniqueName, unexpected, assertUnreachable, assert, notUndefined, entries, stringifyIdentifier, fromEntries, mapObject, mapMap, Todo } from "./utils";
import { compileScript } from "./src-to-il";
import { stringifyFunction, stringifyAllocation, stringifyValue } from './stringify-il';
import deepFreeze from 'deep-freeze';
import { Snapshot } from './snapshot';
import * as fs from 'fs-extra';
import { ModuleSource, ModuleSourceText } from '../lib';
export * from "./virtual-machine-types";

export class VirtualMachine {
  private opts: VM.VirtualMachineOptions;
  private allocations = new Map<IL.AllocationID, IL.Allocation>();
  private nextHeapID = 1;
  private globalVariables = new Map<IL.GlobalVariableName, VM.GlobalSlotID>();
  private globalSlots = new Map<VM.GlobalSlotID, VM.GlobalSlot>();
  private hostFunctions = new Map<IL.HostFunctionID, VM.HostFunctionHandler>();
  private frame: VM.Frame | undefined;
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

  public constructor (
    resumeFromSnapshot: SnapshotInfo | undefined,
    private resolveFFIImport: VM.ResolveFFIImport,
    opts: VM.VirtualMachineOptions
  ) {
    this.opts = opts;

    if (resumeFromSnapshot) {
      return notImplemented();
    }
  }

  public module(moduleSource: ModuleSource) {
    const globalVariableNames = [...this.globalVariables.keys()];
    const filename = moduleSource.debugFilename || '<no file>';
    const unit = compileScript(filename, moduleSource.sourceText, globalVariableNames);
    const loadedUnit = this.loadUnit(unit, filename, undefined);
    this.pushFrame({
      type: 'ExternalFrame',
      callerFrame: this.frame,
      result: IL.undefinedValue
    });
    const moduleObject = this.newObject(); // TODO: Modules
    // Set up the call
    this.callCommon(this.undefinedValue, loadedUnit.entryFunction, [moduleObject]);
    // While we're executing an IL function
    while (this.frame && this.frame.type !== 'ExternalFrame') {
      this.step();
    }
    this.popFrame();

    return moduleObject;
  }

  public createSnapshotInfo(): SnapshotInfo {
    const snapshot: SnapshotInfo = {
      globalSlots: this.globalSlots,
      functions: this.functions,
      exports: this.exports,
      allocations: this.allocations,
    };

    return deepFreeze(_.cloneDeep(snapshot)) as any;
  }

  public createSnapshot(): Snapshot {
    const snapshotInfo = this.createSnapshotInfo();
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
    const unwrapped = this.ephemeralFunctions.get(ephemeral.value);
    return unwrapped;
  }

  public unwrapEphemeralObject(ephemeral: IL.EphemeralObjectValue) {
    const unwrapped = this.ephemeralObjects.get(ephemeral.value);
    return unwrapped;
  }

  public exportValue(exportID: IL.ExportID, value: IL.Value): void {
    if (this.exports.has(exportID)) {
      return invalidOperation(`Duplicate export ID: ${exportID}`);
    }
    this.exports.set(exportID, value);
  }

  public resolveExport(exportID: IL.ExportID): IL.Value {
    if (!this.exports.has(exportID)) {
      return invalidOperation(`Export not found: ${exportID}`);
    }
    return this.exports.get(exportID)!;
  }

  public readonly undefinedValue: IL.UndefinedValue = Object.freeze({
    type: 'UndefinedValue',
    value: undefined
  });

  public readonly nullValue: IL.NullValue = Object.freeze({
    type: 'NullValue',
    value: null
  });

  importHostFunction(hostFunctionID: IL.HostFunctionID): IL.HostFunctionValue {
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

  // Note: the compiler currently assumes that globals are only defined upon creation
  private defineGlobal(name: string, value: IL.Value) {
    if (this.globalVariables.has(name)) {
      return invalidOperation(`Duplicate global variable: "${name}"`);
    }
    const slotID = uniqueName('global:' + name, n => this.globalSlots.has(n));
    this.globalSlots.set(slotID, { value });
    this.globalVariables.set(name, slotID);
  }

  private defineGlobals(globals: { [name: string]: IL.Value }) {
    for (const [name, value] of Object.entries(globals)) {
      this.defineGlobal(name, value);
      delete globals[name];
    }
  }

  private loadUnit(unit: IL.Unit, unitNameHint: string, moduleHostContext?: any): { entryFunction: IL.FunctionValue } {
    const self = this;
    const missingGlobals = unit.freeVariables
      .filter(g => !(g in this.globalVariables))
    if (missingGlobals.length > 0) {
      return invalidOperation(`Unit cannot be loaded because of missing required globals: ${missingGlobals.join(', ')}`);
    }

    // IDs are remapped when loading into the shared namespace of this VM
    const remappedFunctionIDs = new Map<IL.FunctionID, IL.FunctionID>();

    // Allocation slots for all the module-level variables, including functions
    const moduleVariables = new Map<IL.ModuleVariableName, VM.GlobalSlotID>();
    for (const moduleVariable of unit.moduleVariables) {
      const slotID = uniqueName(unitNameHint + ':' + moduleVariable, n => this.globalSlots.has(n));
      this.globalSlots.set(slotID, { value: this.undefinedValue });
      moduleVariables.set(moduleVariable, slotID);
    }

    // Function forward declarations
    for (const func of Object.values(unit.functions)) {
      const newFunctionID = uniqueName(unitNameHint + ':' + func.id, n => this.functions.has(n));
      remappedFunctionIDs.set(func.id, newFunctionID);
      const functionReference: IL.FunctionValue = {
        type: 'FunctionValue',
        value: newFunctionID
      };

      // Binding function to the global variable
      const slotID = uniqueName(unitNameHint + ':' + func.id, n => this.globalSlots.has(n));
      this.globalSlots.set(slotID, { value: functionReference });
      moduleVariables.set(func.id, slotID);
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
        default: return operation;
      }
    }

    function importGlobalOperation(operation: IL.Operation): IL.Operation {
      assert(operation.operands.length === 1);
      const [nameOperand] = operation.operands;
      if (nameOperand.type !== 'NameOperand') return invalidOperation('Malformed IL');
      // Resolve the name
      const slotID = moduleVariables.get(nameOperand.name)
        || self.globalVariables.get(nameOperand.name);
      if (!slotID) {
        return invalidOperation(`Could not resolve global variable: ${nameOperand.name}`);
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

  public runFunction(func: IL.FunctionValue, ...args: IL.Value[]): IL.Value {
    this.pushFrame({
      type: 'ExternalFrame',
      callerFrame: this.frame,
      result: IL.undefinedValue
    });
    this.callCommon(this.undefinedValue, func, args);
    while (this.frame && this.frame.type !== 'ExternalFrame') {
      this.step();
    }
    if (this.frame === undefined || this.frame.type !== 'ExternalFrame') {
      return unexpected();
    }
    // Result of module script
    const result = this.frame.result;
    this.popFrame();
    return result;
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
    if (operands.length !== method.length) {
      return unexpected(`Opcode "${operation.opcode}" in compile-time VM is implemented with incorrect number of opcodes (${method.length} instead of expected ${operands.length}).`);
    }
    // Writing these out explicitly so that we get type errors if we add new operators
    switch (operation.opcode) {
      case 'ArrayGet'   : return this.operationArrayGet();
      case 'ArrayNew'   : return this.operationArrayNew();
      case 'ArraySet'   : return this.operationArraySet();
      case 'BinOp'      : return this.operationBinOp(operands[0]);
      case 'Branch'     : return this.operationBranch(operands[0], operands[1]);
      case 'Call'       : return this.operationCall(operands[0]);
      case 'CallMethod' : return this.operationCallMethod(operands[0], operands[1]);
      case 'Decr'       : return this.operationDecr();
      case 'Dup'        : return this.operationDup();
      case 'Incr'       : return this.operationIncr();
      case 'Jump'       : return this.operationJump(operands[0]);
      case 'Literal'    : return this.operationLiteral(operands[0]);
      case 'LoadArg'    : return this.operationLoadArg(operands[0]);
      case 'LoadGlobal' : return this.operationLoadGlobal(operands[0]);
      case 'LoadVar'    : return this.operationLoadVar(operands[0]);
      case 'Nop'        : return this.operationNop(operands[0]);
      case 'ObjectGet'  : return this.operationObjectGet(operands[0]);
      case 'ObjectNew'  : return this.operationObjectNew();
      case 'ObjectSet'  : return this.operationObjectSet(operands[0]);
      case 'Pop'        : return this.operationPop(operands[0]);
      case 'Return'     : return this.operationReturn();
      case 'StoreGlobal': return this.operationStoreGlobal(operands[0]);
      case 'StoreVar'   : return this.operationStoreVar(operands[0]);
      case 'UnOp'       : return this.operationUnOp(operands[0]);
      default: return assertUnreachable(operation);
    }
  }

  private step() {
    const op = this.block.operations[this.nextOperationIndex];
    this.operationBeingExecuted = op;
    this.nextOperationIndex++;
    if (!op) {
      return this.ilError('Did not expect to reach end of block without a control instruction (Branch, Jump, or Return).');
    }
    const operationMeta = IL.opcodes[op.opcode];
    if (!operationMeta) {
      return this.ilError(`Unknown opcode "${op.opcode}".`);
    }
    if (op.operands.length !== operationMeta.operands.length) {
      return this.ilError(`Expected ${operationMeta.operands.length} operands to operation \`${op.opcode}\`, but received ${op.operands.length} operands.`);
    }
    const stackDepthBeforeOp = this.variables.length;
    if (stackDepthBeforeOp !== op.stackDepthBefore) {
      return this.ilError(`Stack depth before opcode "${op.opcode}" is expected to be ${op.stackDepthBefore} but is actually ${stackDepthBeforeOp}`);
    }
    const operands = op.operands.map((o, i) =>
      this.resolveOperand(o, operationMeta.operands[i] as IL.OperandType));
    this.opts.trace && this.opts.trace(op);
    this.dispatchOperation(op, operands);
    // If we haven't returned to the outside world, then we can check the stack balance
    // Note: we don't look at the stack balance for Call instructions because they create a completely new stack of variables.
    if (this.frame && this.frame.type === 'InternalFrame'
      && op.opcode !== 'Call'
      && op.opcode !== 'CallMethod'
      && op.opcode !== 'Return'
    ) {
      const stackDepthAfter = this.variables.length;
      if (stackDepthAfter !== op.stackDepthAfter) {
        return this.ilError(`Stack depth after opcode "${op.opcode}" is expected to be ${op.stackDepthAfter} but is actually ${stackDepthAfter}`);
      }
      const stackChange = stackDepthAfter - stackDepthBeforeOp;
      let expectedStackChange = operationMeta.stackChange;
      if (typeof expectedStackChange === 'function') {
        expectedStackChange = expectedStackChange(op);
      }
      if (stackChange !== expectedStackChange) {
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
        return operand.targetBlockID;
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
    this.push(this.allocate<IL.ArrayAllocation>({
      type: 'ArrayAllocation',
      lengthIsFixed: false,
      items: []
    }));
  }

  private operationArrayGet() {
    const index = this.pop();
    const array = this.pop();
    const item = this.arrayGetItem(array, index);
    this.push(item);
  }

  public arrayGetItem(arrayValue: IL.Value, indexValue: IL.Value): IL.Value {
    // The array set syntax is essentially a computed property set, but for
    // internal types, we only accept its use on arrays. But for ephemeral
    // objects, there's no distinction between arrays and objects
    if (arrayValue.type === 'EphemeralObjectValue') {
      const ephemeralObjectID = arrayValue.value;
      const ephemeraObject = notUndefined(this.ephemeralObjects.get(ephemeralObjectID));
      let key: VM.PropertyKey | VM.Index;
      if (indexValue.type === 'StringValue' || indexValue.type === 'NumberValue') {
        key = indexValue.value;
      } else {
        // For the moment, it's safer for scripts to get an error here, even if
        // it's not strictly compliant. I can make it more compliant in future.
        return this.runtimeError('Invalid array index: ' + this.convertToString(indexValue));
        // key = this.convertToString(indexValue);
      }
      return ephemeraObject.get(arrayValue, key);
    }
    if (arrayValue.type !== 'ReferenceValue') return this.runtimeError('Array access on non-array');
    const array = this.dereference(arrayValue);
    if (array.type !== 'ArrayAllocation') return this.runtimeError('Array access on non-array');
    const index = this.unwrapIndexValue(indexValue);
    if (index >= 0 && index < array.items.length) {
      return array.items[index];
    } else {
      return this.undefinedValue;
    }
  }

  public arraySetItem(arrayValue: IL.Value, indexValue: IL.Value, value: IL.Value) {
    // The array set syntax is essentially a computed property set, but for
    // internal types, we only accept its use on arrays. But for ephemeral
    // objects, there's no distinction between arrays and objects
    if (arrayValue.type === 'EphemeralObjectValue') {
      const ephemeralObjectID = arrayValue.value;
      const ephemeraObject = notUndefined(this.ephemeralObjects.get(ephemeralObjectID));
      let key: VM.PropertyKey | VM.Index;
      if (indexValue.type === 'StringValue' || indexValue.type === 'NumberValue') {
        key = indexValue.value;
      } else {
        // For the moment, it's safer for scripts to get an error here, even if
        // it's not strictly compliant. I can make it more compliant in future.
        return this.runtimeError('Invalid array index: ' + this.convertToString(indexValue));
        // key = this.convertToString(indexValue);
      }
      ephemeraObject.set(arrayValue, key, value);
      return;
    }
    if (arrayValue.type !== 'ReferenceValue') return this.runtimeError('Array access on non-array');
    const array = this.dereference(arrayValue);
    if (array.type !== 'ArrayAllocation') return this.runtimeError('Array access on non-array');
    const index = this.unwrapIndexValue(indexValue);
    if (array.items.length < index) {
      // Fill in intermediate values if the array has expanded
      for (let i = array.items.length; i <= index; i++) {
        array.items.push(IL.undefinedValue);
      }
    }
    array.items[index] = value;
  }

  private operationArraySet() {
    const value = this.pop();
    const index = this.pop();
    const array = this.pop();
    this.arraySetItem(array, index, value);
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
          this.pushNumber(leftNum + rightNum);
        }
        break;
      }
      case '-':
      case '/':
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
    const predicate = this.pop();
    if (this.isTruthy(predicate)) {
      this.operationJump(trueTargetBlockID);
    } else {
      this.operationJump(falseTargetBlockID);
    }
  }

  private operationCall(argCount: number) {
    const args: IL.Value[] = [];
    for (let i = 0; i < argCount; i++) {
      args.unshift(this.pop());
    }
    if (this.operationBeingExecuted.opcode !== 'Call') return unexpected();
    const callTarget = this.pop();
    if (callTarget.type !== 'FunctionValue' && callTarget.type !== 'HostFunctionValue' && callTarget.type !== 'EphemeralFunctionValue') {
      return this.runtimeError('Calling uncallable target');
    }

    return this.callCommon(this.undefinedValue, callTarget, args);
  }

  private operationCallMethod(methodName: string, argCount: number) {
    const args: IL.Value[] = [];
    for (let i = 0; i < argCount; i++) {
      args.unshift(this.pop());
    }
    const objectValue = this.pop();
    if (objectValue.type === 'EphemeralObjectValue') {
      const method = this.objectGetProperty(objectValue, methodName);
      if (method.type !== 'FunctionValue' && method.type !== 'HostFunctionValue' && method.type !== 'EphemeralFunctionValue') {
        return this.runtimeError(`Object.${methodName} is not a function`);
      }
      this.callCommon(objectValue, method, args);
    } else {
      if (objectValue.type !== 'ReferenceValue') return this.runtimeError('Attempt to invoke method on non-object');
      const object = this.dereference(objectValue);
      if (object.type === 'ObjectAllocation') {
        if (!(methodName in object.properties)) {
          return this.runtimeError(`Object does not contain method "${methodName}"`);
        }
        const method = object.properties[methodName];
        if (method.type !== 'FunctionValue' && method.type !== 'HostFunctionValue' && method.type !== 'EphemeralFunctionValue') {
          return this.runtimeError(`Object.${methodName} is not a function`);
        }
        this.callCommon(objectValue, method, args);
      } else if (object.type === 'ArrayAllocation') {
        if (methodName === 'length') {
          return this.runtimeError('`Array.length` is not a function');
        } else if (methodName === 'push') {
          object.items.push(...args);
          // Result of method call
          this.push(IL.undefinedValue);
          return;
        } else {
          return this.runtimeError(`Array method not supported: "${methodName}"`);
        }
      } else {
        return this.runtimeError('Attempt to invoke method on non-object');
      }
    }
  }

  private operationDecr() {
    const value = this.pop();
    this.pushNumber(this.convertToNumber(value) - 1);
  }

  private operationDup() {
    // Duplicate top variable
    return this.operationLoadVar(this.variables.length - 1);
  }

  private operationIncr() {
    const value = this.pop();
    this.pushNumber(this.convertToNumber(value) + 1);
  }

  private operationJump(targetBlockID: string) {
    this.block = this.func.blocks[targetBlockID];
    if (!this.block) {
      return this.ilError(`Undefined target block: "${targetBlockID}".`)
    }
    this.block
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

  public globalGet(name: string): IL.Value {
    const slotID = this.globalVariables.get(name);
    if (!slotID) {
      return this.undefinedValue;
    }
    return notUndefined(this.globalSlots.get(slotID)).value;
  }

  public globalSet(name: string, value: IL.Value): void {
    let slotID = this.globalVariables.get(name);
    if (!slotID) {
      slotID = uniqueName('global:' + name, n => this.globalSlots.has(n));
      this.globalVariables.set(name, slotID);
      this.globalSlots.set(slotID, { value: this.undefinedValue });
    }
    notUndefined(this.globalSlots.get(slotID)).value = value;
  }

  private operationLoadVar(index: number) {
    if (index >= this.variables.length) {
      return this.ilError(`Access to variable index out of range: "${index}"`);
    }
    this.push(this.variables[index]);
  }

  private operationNop(count: number) {
    /* Do nothing */
  }

  private operationObjectNew() {
    this.push(this.newObject());
  }

  private operationObjectGet(propertyName: string) {
    const objectValue = this.pop();
    const value = this.objectGetProperty(objectValue, propertyName);
    this.push(value);
  }

  private operationObjectSet(propertyName: string) {
    const value = this.pop();
    const objectValue = this.pop();
    this.objectSetProperty(objectValue, propertyName, value);
  }

  private operationPop(count: number) {
    while (count--) {
      this.pop();
    }
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

  private operationStoreGlobal(slotID: string) {
    const value = this.pop();
    const slot = this.globalSlots.get(slotID);
    if (!slot) return this.ilError('Invalid slot ID: ' + slotID);
    slot.value = value;
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
      case '-': this.pushNumber(-this.convertToNumber(operand)); break;
      case '~': this.pushNumber(~this.convertToNumber(operand)); break;
      default: return assertUnreachable(op);
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
      default: assertUnreachable(value);
    }
  }

  // An error that represents an invalid action in user code
  private runtimeError(message: string): never {
    throw new Error(`VM runtime error: ${message}\n      at (${this.filename}:${this.operationBeingExecuted.sourceLoc.line}:${this.operationBeingExecuted.sourceLoc.column})`);
  }

  /**
   * An error that likely occurs because of malformed IL
   * @param message
   */
  private ilError(message: string): never {
    const operation = this.operationBeingExecuted;
    if (operation) {
      const sourceLoc = operation.sourceLoc;
      throw new Error(`VM IL error: ${message}\n      at (${this.filename}:${sourceLoc.line}:${sourceLoc.column})`);
    } else {
      throw new Error(`VM IL error: ${message}`);
    }
  }

  private pop() {
    const value = this.variables.pop();
    if (!value) {
      return this.ilError('Stack unbalanced');
    }
    return value;
  }

  private unwrapIndexValue(index: IL.Value): number {
    if (index.type !== 'NumberValue' || (index.value | 0) !== index.value) {
      return this.runtimeError('Indexing array with non-integer');
    }
    if (index.value < 0 || index.value > IL.MAX_INDEX) {
      return this.runtimeError(`Index of value ${index.value} exceeds maximum index range.`);
    }
    return index.value;
  }

  private push(value: IL.Value) {
    assert(value !== undefined);
    this.variables.push(value);
    assert(this.variables.length <= this.func.maxStackDepth);
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

  private pushNull() {
    this.push(IL.nullValue);
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
          case 'ArrayAllocation': return 'Array';
          case 'ObjectAllocation': return 'Object';
          default: return assertUnreachable(allocation);
        }
      }
      case 'BooleanValue': return value.value ? 'true' : 'false';
      case 'FunctionValue': return 'Function';
      case 'HostFunctionValue': return 'Function';
      case 'EphemeralFunctionValue': return 'Function';
      case 'EphemeralObjectValue': return 'Object';
      case 'NullValue': return 'null';
      case 'UndefinedValue': return 'undefined';
      case 'NumberValue': return value.value.toString();
      case 'StringValue': return value.value;
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
      case 'NullValue': return 0;
      case 'UndefinedValue': return NaN;
      case 'NumberValue': return value.value;
      case 'StringValue': return parseFloat(value.value);
      default: assertUnreachable(value);
    }
  }

  public areValuesEqual(value1: IL.Value, value2: IL.Value): boolean {
    // It happens to be the case that all our types compare equal if the inner
    // value is equal
    return value1.type === value2.type && value1.value === value2.value;
  }

  private callCommon(
    object: IL.ReferenceValue<IL.ObjectAllocation> | IL.EphemeralObjectValue | IL.UndefinedValue,
    funcValue: IL.FunctionValue | IL.HostFunctionValue | IL.EphemeralFunctionValue,
    args: IL.Value[]
  ) {
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
      const handledObject = object && this.createHandle(object);
      const handledFunc = this.createHandle(funcValue);

      const resultHandle = extFunc(object, args);

      const resultValue = resultHandle ||  IL.undefinedValue;
      handledArgs.forEach(a => a.release());
      handledObject && handledObject.release();
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
      const handledObject = object && this.createHandle(object);
      const handledFunc = this.createHandle(funcValue);

      const resultHandle = func(object, args);

      const resultValue = resultHandle || IL.undefinedValue;
      handledArgs.forEach(a => a.release());
      handledObject && handledObject.release();
      handledFunc.release();
      if (!this.frame) {
        return unexpected();
      }
      if (this.frame.type === 'InternalFrame') {
        this.push(resultValue);
      } else {
        this.frame.result = resultValue;
      }
    } else {
      assert(funcValue.type === 'FunctionValue');
      const func = notUndefined(this.functions.get(funcValue.value));
      const block = func.blocks[func.entryBlockID];
      this.pushFrame({
        type: 'InternalFrame',
        callerFrame: this.frame,
        filename: func.sourceFilename,
        func: func,
        block,
        nextOperationIndex: 0,
        operationBeingExecuted: block.operations[0],
        variables: [],
        args: args,
        object: object
      });
    }
  }

  private getType(value: IL.Value): string {
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
          default: assertUnreachable(allocationType);
        }
      case 'FunctionValue': return 'function';
      case 'HostFunctionValue': return 'function';
      case 'EphemeralFunctionValue': return 'function';
      case 'EphemeralObjectValue': return 'object';
      default: return assertUnreachable(value);
    }
  }

  private get internalFrame(): VM.InternalFrame {
    if (!this.frame || this.frame.type !== 'InternalFrame') {
      return unexpected();
    }
    return this.frame;
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
        return invalidOperation(`Cannot convert ${value.type} to POD`)
      case 'ReferenceValue':
        const allocation = this.dereference(value);
        switch (allocation.type) {
          case 'ArrayAllocation': return allocation.items.map(v => this.convertToNativePOD(v));
          case 'ObjectAllocation': {
            const result = Object.create(null);
            for (const k of Object.keys(value.value)) {
              result[k] = this.convertToNativePOD(allocation.properties[k]);
            }
            return result;
          }
          default: assertUnreachable(allocation);
        }
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
        lines.push(`at ${frame.func.id} (${frame.filename}:${loc.line}:${loc.column})`);
      }
      frame = frame.callerFrame;
    }
    return lines
      .map(l => `      ${l}`)
      .join('\n');
  }

  public numberValue(value: number): IL.NumberValue {
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

  public newObject(): IL.ReferenceValue<IL.ObjectAllocation> {
    return this.allocate<IL.ObjectAllocation>({
      type: 'ObjectAllocation',
      properties: Object.create(null)
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
    const self = this;

    const reachableFunctions = new Set<string>();
    const reachableAllocations = new Set<IL.Allocation>();
    const reachableGlobalSlots = new Set<VM.GlobalSlotID>();
    const reachableHostFunctions = new Set<IL.HostFunctionID>();

    // TODO(high): I'm getting a segfault when these aren't collected.
    // Global variable roots
    for (const slotID of this.globalVariables.values()) {
      const slot = notUndefined(this.globalSlots.get(slotID));
      reachableGlobalSlots.add(slotID);
      valueIsReachable(slot.value);
    }

    // Roots on the stack
    let frame: VM.Frame | undefined = this.frame;
    while (frame) {
      frameIsReachable(frame);
      frame = frame.callerFrame;
    }

    // Roots in handles
    for (const handle of this.handles) {
      valueIsReachable(handle.value);
    }

    // Roots in exports
    for (const e of this.exports.values()) {
      valueIsReachable(e);
    }

    // Sweep allocations
    for (const [i, a] of this.allocations) {
      if (!reachableAllocations.has(a)) {
        this.allocations.delete(i);
      }
    }

    // Sweep global variables
    /* Note: technically, unused global variables might become used later when
     * further imports are done, so they shouldn't strictly be collected.
     * However, in practical terms, the collection is expected to happen after
     * all the imports are complete, at least for the moment, and it's useful to
     * clear unused globals because they'll handle a lot of infrastructure that
     * is only needed at compile time. */
    for (const slotID of this.globalSlots.keys()) {
      if (!reachableGlobalSlots.has(slotID)) {
        const slotIDToDelete = slotID;
        this.globalSlots.delete(slotIDToDelete);
        for (const [globalVariableName, globalVariableSlotID] of this.globalVariables.entries()) {
          if (globalVariableSlotID === slotIDToDelete) {
            this.globalVariables.delete(globalVariableName);
          }
        }
      }
    }

    // Sweep host functions
    for (const extID of this.hostFunctions.keys()) {
      if (!reachableHostFunctions.has(extID)) {
        this.hostFunctions.delete(extID);
      }
    }

    // Sweep functions
    for (const functionID of this.functions.keys()) {
      if (!reachableFunctions.has(functionID)) {
        this.functions.delete(functionID);
      }
    }

    function valueIsReachable(value: IL.Value) {
      if (value.type === 'FunctionValue') {
        const func = notUndefined(self.functions.get(value.value));
        functionIsReachable(func);
        return;
      } else if (value.type === 'HostFunctionValue') {
        reachableHostFunctions.add(value.value);
        return;
      } else if (value.type === 'ReferenceValue') {
        const allocation = self.dereference(value);
        if (reachableAllocations.has(allocation)) {
          // Already visited
          return;
        }
        reachableAllocations.add(allocation);
        switch (allocation.type) {
          case 'ArrayAllocation': return allocation.items.forEach(valueIsReachable);
          case 'ObjectAllocation': return [...Object.values(allocation.properties)].forEach(valueIsReachable);
          default: return assertUnreachable(allocation);
        }
      }
    }

    function frameIsReachable(frame: VM.Frame) {
      if (frame.type === 'ExternalFrame') {
        valueIsReachable(frame.result);
        return;
      }
      frame.args.forEach(valueIsReachable);
      frame.variables.forEach(valueIsReachable);
      frame.object && valueIsReachable(frame.object);
    }

    function functionIsReachable(func: VM.Function) {
      if (reachableFunctions.has(func.id)) {
        // Already visited
        return;
      }
      reachableFunctions.add(func.id);
      for (const block of Object.values(func.blocks)) {
        for (const op of block.operations) {
          if (op.opcode === 'LoadGlobal') {
            const nameOperand = op.operands[0];
            if (nameOperand.type !== 'NameOperand') return unexpected();
            const name = nameOperand.name;
            reachableGlobalSlots.add(name);
            const globalVariable = notUndefined(self.globalSlots.get(name));
            valueIsReachable(globalVariable.value);
          } else if (op.opcode === 'Literal') {
            const [valueOperand] = op.operands;
            if (valueOperand.type !== 'LiteralOperand') return unexpected();
            valueIsReachable(valueOperand.literal);
          }
        }
      }
    }
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


  objectGetProperty(objectValue: IL.Value, propertyName: string): IL.Value {
    if (objectValue.type === 'EphemeralObjectValue') {
      const ephemeralObjectID = objectValue.value;
      const ephemeralObject = notUndefined(this.ephemeralObjects.get(ephemeralObjectID));
      return ephemeralObject.get(objectValue, propertyName);
    }
    if (objectValue.type !== 'ReferenceValue') {
      return this.runtimeError(`Cannot access property "${propertyName}" on value of type ${this.getType(objectValue)}`);
    }
    const object = this.dereference(objectValue);
    if (object.type === 'ArrayAllocation') {
      if (propertyName === 'length') {
        return this.numberValue(object.items.length);
      } else if (propertyName === 'push') {
        return this.runtimeError('Array.push can only be accessed as a function call.')
      } else {
        return this.runtimeError(`Array.${propertyName} is not a valid array property.`)
      }
    } else if (object.type === 'ObjectAllocation') {
      if (propertyName in object.properties) {
        return object.properties[propertyName];
      } else {
        return this.undefinedValue;
      }
    } else {
      return this.runtimeError(`Cannot access property "${propertyName}" on value of type ${this.getType(object)}`);
    }
  }

  objectSetProperty(objectValue: IL.Value, propertyName: string, value: IL.Value) {
    if (objectValue.type === 'EphemeralObjectValue') {
      const ephemeralObjectID = objectValue.value;
      const ephemeralObject = notUndefined(this.ephemeralObjects.get(ephemeralObjectID));
      ephemeralObject.set(objectValue, propertyName, value);
    }
    if (objectValue.type !== 'ReferenceValue') {
      return this.runtimeError(`Cannot access property "${propertyName}" on value of type ${this.getType(objectValue)}`);
    }
    const object = this.dereference(objectValue);
    if (object.type === 'ArrayAllocation') {
      const array = object.items;
      // Assigning an array length resizes the array
      if (propertyName === 'length') {
        if (object.lengthIsFixed) {
          return this.runtimeError(`Length of array is immutable`);
        }
        if (value.type !== 'NumberValue') {
          return this.runtimeError(`Array.length needs to be a number (received type "${this.getType(value)}")`);
        }
        const newLength = value.value;
        if ((value.value | 0) !== newLength) {
          return this.runtimeError(`Array.length needs be an integer (received value ${newLength})`);
        }
        if (newLength < 0 || newLength >= IL.MAX_COUNT) {
          return this.runtimeError(`Array.length overflow (${newLength})`);
        }
        if (newLength > array.length) {
          // Clear new values in the array
          for (let i = array.length; i < newLength; i++) {
            array.push(IL.undefinedValue);
          }
        } else {
          // Just shorten the array
          array.length = newLength;
        }
      } else if (propertyName === 'push') {
        return this.runtimeError('Array.push can only be accessed as a function call.')
      }
    } else if (object.type === 'ObjectAllocation') {
      if (object.immutableProperties && object.immutableProperties.has(propertyName)) {
        return this.runtimeError(`Property "${propertyName}" is immutable`);
      }
      object.properties[propertyName] = value;
    } else {
      return this.runtimeError(`Cannot access property "${propertyName}" on value of type ${this.getType(object)}`);
    }
  }

  pushFrame(frame: VM.Frame) {
    frame.callerFrame = this.frame;
    this.frame = frame;
  }

  popFrame(): VM.Frame {
    const result = this.frame;
    if (result === undefined) {
      return invalidOperation('Frame stack underflow')
    }
    this.frame = result.callerFrame;
    return result;
  }

  // Frame properties
  private get args() { return this.internalFrame.args; }
  private get block() { return this.internalFrame.block; }
  private get callerFrame() { return this.internalFrame.callerFrame; }
  private get filename() { return this.internalFrame.filename; }
  private get func() { return this.internalFrame.func; }
  private get nextOperationIndex() { return this.internalFrame.nextOperationIndex; }
  private get object() { return this.internalFrame.object; }
  private get operationBeingExecuted() { return this.internalFrame.operationBeingExecuted; }
  private get variables() { return this.internalFrame.variables; }
  private set args(value: IL.Value[]) { this.internalFrame.args = value; }
  private set block(value: IL.Block) { this.internalFrame.block = value; }
  private set callerFrame(value: VM.Frame | undefined) { this.internalFrame.callerFrame = value; }
  private set filename(value: string) { this.internalFrame.filename = value; }
  private set func(value: VM.Function) { this.internalFrame.func = value; }
  private set nextOperationIndex(value: number) { this.internalFrame.nextOperationIndex = value; }
  private set object(value: IL.ReferenceValue<IL.ObjectAllocation> | IL.EphemeralObjectValue | IL.UndefinedValue) { this.internalFrame.object = value; }
  private set operationBeingExecuted(value: IL.Operation) { this.internalFrame.operationBeingExecuted = value; }
  private set variables(value: IL.Value[]) { this.internalFrame.variables = value; }
}