import * as IL from './il';
import * as VM from './virtual-machine-types';
import { Snapshot } from "./snapshot";
import { notImplemented, invalidOperation, uniqueName, unexpected, assertUnreachable, assert, notUndefined, entries, stringifyIdentifier } from "./utils";
import { compileScript } from "./src-to-il";
import fs from 'fs-extra';
import { stringifyFunction } from './stringify-il';

export * from "./virtual-machine-types";

export class VirtualMachine {
  private opts: VM.VirtualMachineOptions;
  private heap = new Map<VM.AllocationID, VM.Allocation>();
  private nextHeapID = 1;
  private globalVariables: { [name: string]: VM.Value } = Object.create(null);
  private externalFunctions = new Map<string, VM.ExternalFunctionHandler>();
  private moduleScopes = new Map<string, VM.ModuleScope>();
  private frame: VM.Frame | undefined;
  // Anchors are values declared outside the VM that add to the reachability
  // graph of the VM (because they're reachable externally)
  private anchors = new Set<VM.Anchor<VM.Value>>();

  constructor (resumeFromSnapshot?: Snapshot | undefined, opts: VM.VirtualMachineOptions = {}) {
    this.opts = opts;

    if (resumeFromSnapshot) {
      return notImplemented();
    }
  }

  public async importFile(filename: string) {
    const sourceText = await fs.readFile(filename, 'utf-8');
    return this.importModuleSourceText(sourceText, filename);
  }

  public importModuleSourceText(sourceText: string, sourceFilename: string) {
    const globalVariableNames = Object.keys(this.globalVariables);
    const unit = compileScript(sourceFilename, sourceText, globalVariableNames);
    const loadedUnit = this.loadUnit(unit, sourceFilename, undefined);
    this.pushFrame({
      type: 'ExternalFrame',
      callerFrame: this.frame,
      result: IL.undefinedValue
    });
    const moduleObject = this.createObject();
    this.callCommon(undefined, loadedUnit.entryFunction, [moduleObject.value]);
    // While we're executing an IL function
    while (this.frame && this.frame.type !== 'ExternalFrame') {
      this.step();
    }
    this.popFrame();

    return moduleObject;
  }

  public createSnapshot(): Snapshot {
    return notImplemented();
  }

  public defineGlobal(name: string, value: VM.Anchor<VM.Value>) {
    this.globalVariables[name] = value.release();
  }

  public defineGlobals(globals: { [name: string]: VM.Anchor<VM.Value> }) {
    for (const [name, value] of Object.entries(globals)) {
      this.defineGlobal(name, value);
      delete globals[name];
    }
  }

  readonly undefinedValue: IL.UndefinedValue = Object.freeze({
    type: 'UndefinedValue',
    value: undefined
  });

  readonly nullValue: IL.NullValue = Object.freeze({
    type: 'NullValue',
    value: null
  });

  private loadUnit(unit: IL.Unit, nameHint: string, moduleHostContext?: any): { entryFunction: VM.FunctionValue } {
    const missingGlobals = unit.globalImports
      .filter(g => !(g in this.globalVariables))
    if (missingGlobals.length > 0) {
      return invalidOperation(`Unit cannot be loaded because of missing required globals: ${missingGlobals.join(', ')}`);
    }
    const moduleID = uniqueName(nameHint, n => this.moduleScopes.has(n));
    const moduleScope: VM.ModuleScope = {
      moduleID: moduleID,
      moduleVariables: Object.create(null),
      functions: new Map<string, IL.Function>(),
      moduleHostContext: moduleHostContext
    };
    this.moduleScopes.set(moduleID, moduleScope);
    for (const func of Object.values(unit.functions)) {
      moduleScope.functions.set(func.id, func);
      const functionReference: VM.FunctionValue = {
        type: 'FunctionValue',
        functionID: func.id,
        moduleID: moduleID
      };
      moduleScope.moduleVariables[func.id] = functionReference;
    }
    for (const v of unit.moduleVariables) {
      moduleScope.moduleVariables[v] = IL.undefinedValue;
    }
    return {
      entryFunction: {
        type: 'FunctionValue',
        functionID: unit.entryFunctionID,
        moduleID: moduleID
      }
    };
  }

  private runFunction(func: VM.FunctionValue, ...args: VM.Value[]): VM.Anchor<VM.Value> {
    this.pushFrame({
      type: 'ExternalFrame',
      callerFrame: this.frame,
      result: IL.undefinedValue
    });
    this.callCommon(undefined, func, args);
    while (this.frame && this.frame.type !== 'ExternalFrame') {
      this.step();
    }
    if (this.frame === undefined || this.frame.type !== 'ExternalFrame') {
      return unexpected();
    }
    // Result of module script
    const result = this.createAnchor(this.frame.result);
    this.popFrame();
    return result;
  }

  createAnchor<T extends VM.Value>(value: T): VM.Anchor<T> {
    let refCount = 1;
    const anchor: VM.Anchor<T> = {
      get value(): T {
        if (refCount <= 0) {
          return invalidOperation('Anchor value has been released');
        }
        return value;
      },
      addRef: () => {
        if (refCount <= 0) {
          return invalidOperation('Anchor value has been released');
        }
        refCount++;
        return anchor;
      },
      release: () => {
        if (refCount <= 0) {
          return invalidOperation('Anchor value has been released');
        }
        const result = value;
        if (--refCount === 0) {
          this.anchors.delete(anchor)
          value = undefined as any;
        }
        return result;
      }
    };
    this.anchors.add(anchor);
    return anchor;
  }

  /**
   * Gets the moduleContext provided to `runUnit` or `loadUnit` when the active
   * function was loaded.
   */
  callerModuleHostContext(): any {
    if (!this.frame || this.frame.type !== 'InternalFrame') {
      return invalidOperation('Module context not accessible when no module is active.')
    }
    const moduleScope = this.moduleScopes.get(this.frame.moduleID);
    if (!moduleScope) return unexpected();
    return moduleScope.moduleHostContext;
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
      case 'LoadModVar' : return this.operationLoadModVar(operands[0]);
      case 'LoadVar'    : return this.operationLoadVar(operands[0]);
      case 'ObjectGet'  : return this.operationObjectGet(operands[0]);
      case 'ObjectNew'  : return this.operationObjectNew();
      case 'ObjectSet'  : return this.operationObjectSet(operands[0]);
      case 'Pop'        : return this.operationPop(operands[0]);
      case 'Return'     : return this.operationReturn();
      case 'StoreGlobal': return this.operationStoreGlobal(operands[0]);
      case 'StoreModVar': return this.operationStoreModVar(operands[0]);
      case 'StoreVar'   : return this.operationStoreVar(operands[0]);
      case 'UnOp'       : return this.operationUnOp(operands[0]);
      default: return assertUnreachable(operation.opcode);
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
    if (stackDepthBeforeOp !== op.expectedStackDepthBefore) {
      return this.ilError(`Stack depth before opcode "${op.opcode}" is expected to be ${op.expectedStackDepthBefore} but is actually ${stackDepthBeforeOp}`);
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
      if (stackDepthAfter !== op.expectedStackDepthAfter) {
        return this.ilError(`Stack depth after opcode "${op.opcode}" is expected to be ${op.expectedStackDepthAfter} but is actually ${stackDepthAfter}`);
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
    this.push(this.allocate<VM.ArrayAllocation>({
      type: 'ArrayAllocation',
      value: []
    }));
  }

  private operationArrayGet() {
    const index = this.popIndex();
    const array = this.popArray(o => `Cannot use array indexer on value of type "${this.getType(o)}"`);
    if (index.value >= 0 && index.value < array.value.length) {
      const item = array.value[index.value];
      this.push(item);
    } else {
      this.push(IL.undefinedValue);
    }
  }

  private operationArraySet() {
    const value = this.pop();
    const index = this.popIndex();
    const array = this.popArray(o => `Cannot use array indexer on value of type "${this.getType(o)}"`);
    if (index.value < 0 || index.value >= IL.MAX_COUNT) {
      return this.runtimeError(`Array index out of range: ${index.value}`);
    }
    if (array.value.length < index.value) {
      // Fill in intermediate values if the array has expanded
      for (let i = array.value.length; i <= index.value; i++) {
        array.value.push(IL.undefinedValue);
      }
    }
    array.value[index.value] = value;
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
    const args: VM.Value[] = [];
    for (let i = 0; i < argCount; i++) {
      args.unshift(this.pop());
    }
    const callTarget = this.pop();
    if (callTarget.type !== 'FunctionValue' && callTarget.type !== 'ExternalFunctionValue') {
      return this.runtimeError('Calling uncallable target');
    }

    return this.callCommon(undefined, callTarget, args);
  }

  private operationCallMethod(methodName: string, argCount: number) {
    const args: VM.Value[] = [];
    for (let i = 0; i < argCount; i++) {
      args.unshift(this.pop());
    }
    const objectReference = this.popReference(() => 'Expected object or array');
    const object = this.dereference(objectReference);
    if (object.type === 'ObjectAllocation') {
      if (!(methodName in object.value)) {
        return this.runtimeError(`Object does not contain method "${methodName}"`);
      }
      const method = object.value[methodName];
      if (method.type !== 'FunctionValue' && method.type !== 'ExternalFunctionValue') {
        return this.runtimeError(`Object.${methodName} is not a function`);
      }
      this.callCommon(objectReference, method, args);
    } else if (object.type === 'ArrayAllocation') {
      if (methodName === 'length') {
        return this.runtimeError('`Array.length` is not a function');
      } else if (methodName === 'push') {
        object.value.push(...args);
        // Result of method call
        this.push(IL.undefinedValue);
        return;
      } else {
        return this.runtimeError(`Array method not supported: "${methodName}"`);
      }
    } else {
      return this.runtimeError('Attempt to invoke function on non-objects');
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

  private operationLiteral(value: VM.Value) {
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
    const globalVariables = this.globalVariables;
    if (name in globalVariables) {
      this.push(globalVariables[name]);
      return;
    }
    return this.ilError(`Access to undefined global variable: "${name}"`);
  }

  private operationLoadModVar(name: string) {
    const moduleVariables = this.getModuleScope().moduleVariables;
    if (name in moduleVariables) {
      this.push(moduleVariables[name]);
      return;
    }
    return this.ilError(`Access to undefined module variable: "${name}"`);
  }

  private operationLoadVar(index: number) {
    if (index >= this.variables.length) {
      return this.ilError(`Access to variable index out of range: "${index}"`);
    }
    this.push(this.variables[index]);
  }

  private operationObjectNew() {
    this.push(this.allocate<VM.ObjectAllocation>({
      type: 'ObjectAllocation',
      value: Object.create(null)
    }));
  }

  private operationObjectGet(propertyName: string) {
    const objectReference = this.popReference(value => this.runtimeError(`Cannot access property "${propertyName}" on value of type ${this.getType(value)}`));
    const object = this.dereference(objectReference);
    const value = this.getProperty(object, propertyName);
    this.push(value);
  }

  private operationObjectSet(propertyName: string) {
    const value = this.pop();
    const objectReference = this.popReference(value => this.runtimeError(`Cannot access property "${propertyName}" on value of type ${this.getType(value)}`));
    this.setProperty(objectReference, propertyName, value);
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

  private operationStoreGlobal(name: string) {
    const value = this.pop();
    const globals = this.globalVariables;
    if (!(name in globals)) {
      return this.ilError(`Access to undeclared global variable: "${name}"`);
    }
    globals[name] = value;
  }

  private operationStoreModVar(name: string) {
    const value = this.pop();
    const moduleVariables = this.getModuleScope().moduleVariables;
    if (!(name in moduleVariables)) {
      return this.ilError(`Access to undeclared module variable: "${name}"`);
    }
    moduleVariables[name] = value;
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

  public isTruthy(value: VM.Value): boolean {
    switch (value.type) {
      case 'UndefinedValue':
      case 'NullValue':
      case 'BooleanValue':
      case 'NumberValue':
      case 'StringValue':
        return !!value.value;
      case 'ReferenceValue': return true;
      case 'FunctionValue': return true;
      case 'ExternalFunctionValue': return true;
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

  private popArray(errorMessage: (value: VM.Value) => string): VM.ArrayAllocation {
    const arrayReference = this.popReference(errorMessage);
    const array = this.heap.get(arrayReference.value);
    if (!array) return unexpected();
    if (array.type !== 'ArrayAllocation') {
      return this.runtimeError(errorMessage(arrayReference));
    }
    return array;
  }

  private popReference(errorMessage: (value: VM.Value) => string): VM.ReferenceValue<VM.Allocation> {
    const reference = this.pop();
    if (reference.type !== 'ReferenceValue') {
      return this.runtimeError(errorMessage(reference));
    }
    return reference;
  }

  private popIndex(): IL.NumberValue {
    const index = this.pop();
    if (index.type !== 'NumberValue' || (index.value | 0) !== index.value) {
      return this.runtimeError('Indexing array with non-integer');
    }
    if (index.value < 0 || index.value > IL.MAX_INDEX) {
      return this.runtimeError(`Index of value ${index.value} exceeds maximum index range.`);
    }
    return index;
  }

  private push(value: VM.Value) {
    assert(value !== undefined);
    this.variables.push(value);
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

  public convertToString(value: VM.Value): string {
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
      case 'ExternalFunctionValue': return 'Function';
      case 'NullValue': return 'null';
      case 'UndefinedValue': return 'undefined';
      case 'NumberValue': return value.value.toString();
      case 'StringValue': return value.value;
      default: assertUnreachable(value);
    }
  }

  private convertToNumber(value: VM.Value): number {
    switch (value.type) {
      case 'ReferenceValue': return NaN;
      case 'BooleanValue': return value.value ? 1 : 0;
      case 'FunctionValue': return NaN;
      case 'ExternalFunctionValue': return NaN;
      case 'NullValue': return 0;
      case 'UndefinedValue': return NaN;
      case 'NumberValue': return value.value;
      case 'StringValue': return parseFloat(value.value);
      default: assertUnreachable(value);
    }
  }

  public areValuesEqual(value1: VM.Value, value2: VM.Value): boolean {
    // Functions are special because they're identified by module and function ID
    if (value1.type === 'FunctionValue') {
      if (value2.type !== 'FunctionValue') {
        return false;
      }
      // The moduleID and functionID together uniquely define the function identity
      return value1.moduleID === value2.moduleID && value1.functionID === value2.functionID;
    } else if (value2.type === 'FunctionValue') {
      return false;
    }

    // It happens to be the case that all our types compare equal if the inner
    // value is equal
    return value1.value === value2.value;
  }

  private callCommon(object: VM.ReferenceValue<VM.ObjectAllocation> | undefined, funcValue: VM.FunctionValue | VM.ExternalFunctionValue, args: VM.Value[]) {
    if (funcValue.type === 'ExternalFunctionValue') {
      if (!this.frame) {
        return unexpected();
      }
      const extFunc = this.externalFunctions.get(funcValue.value);
      if (!extFunc) {
        return this.runtimeError(`External function "${funcValue.value}" not linked`);
      }
      // Anchor temporarily because the called function can run a garbage collection
      const anchoredArgs = args.map(a => this.createAnchor(a));
      const anchoredObject = object && this.createAnchor(object);
      const anchoredFunc = this.createAnchor(funcValue);
      const resultAnchor = extFunc(object, funcValue, args);
      const resultValue = resultAnchor ? resultAnchor.release() : IL.undefinedValue;
      anchoredArgs.forEach(a => a.release());
      anchoredObject && anchoredObject.release();
      anchoredFunc.release();
      if (!this.frame) {
        return unexpected();
      }
      if (this.frame.type === 'InternalFrame') {
        this.push(resultValue);
      } else {
        this.frame.result = resultValue;
      }
    } else {
      const module = notUndefined(this.moduleScopes.get(funcValue.moduleID));
      const func = notUndefined(module.functions.get(funcValue.functionID));
      const block = func.blocks[func.entryBlockID];
      this.pushFrame({
        type: 'InternalFrame',
        callerFrame: this.frame,
        filename: func.sourceFilename,
        func: func,
        moduleID: funcValue.moduleID,
        block,
        nextOperationIndex: 0,
        operationBeingExecuted: block.operations[0],
        variables: [],
        args: args,
        object: object
      });
    }
  }

  private getType(value: VM.Value): string {
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
      case 'ExternalFunctionValue': return 'function';
      default: return assertUnreachable(value);
    }
  }

  private get internalFrame(): VM.InternalFrame {
    if (!this.frame || this.frame.type !== 'InternalFrame') {
      return unexpected();
    }
    return this.frame;
  }

  convertToNativePOD(value: VM.Value): any {
    switch (value.type) {
      case 'UndefinedValue':
      case 'NullValue':
      case 'BooleanValue':
      case 'NumberValue':
      case 'StringValue':
        return value.value;
      case 'FunctionValue':
      case 'ExternalFunctionValue':
        return invalidOperation(`Cannot convert ${value.type} to POD`)
      case 'ReferenceValue':
        const allocation = this.dereference(value);
        switch (allocation.type) {
          case 'ArrayAllocation': return allocation.value.map(v => this.convertToNativePOD(v));
          case 'ObjectAllocation':
            const result = Object.create(null);
            for (const k of Object.keys(value.value)) {
              result[k] = this.convertToNativePOD(allocation.value[k]);
            }
            return result;
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
        lines.push('at <external>');
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


  public stringValue(value: string): IL.StringValue {
    return {
      type: 'StringValue',
      value
    }
  }

  public createObject(): VM.Anchor<VM.ReferenceValue<VM.ObjectAllocation>> {
    return this.createAnchor(this.newObject());
  }

  private newObject(): VM.ReferenceValue<VM.ObjectAllocation> {
    return this.allocate<VM.ObjectAllocation>({
      type: 'ObjectAllocation',
      value: Object.create(null)
    });
  }

  private getModuleScope() {
    const moduleName = this.moduleName;
    const moduleScope = this.moduleScopes.get(moduleName);
    if (!moduleScope) return unexpected();
    return moduleScope;
  }

  private allocate<T extends VM.Allocation>(value: Omit<T, 'allocationID'>): VM.ReferenceValue<T> {
    const allocationID = this.nextHeapID++;
    const allocation: VM.Allocation = {
      ...value,
      allocationID
    } as any;
    this.heap.set(allocationID, allocation);
    return {
      type: 'ReferenceValue',
      value: allocationID
    };
  }

  public dereference<T extends VM.Allocation>(value: VM.ReferenceValue<T>): T {
    const allocationID = value.value;
    const allocation = this.heap.get(allocationID);
    if (!allocation) return unexpected(`Could not find allocation with ID ${allocationID}`);
    return allocation as T;
  }

  public garbageCollect() {
    class ModuleReachability {
      public reachableVariables = new Set<string>();
      public reachableFunctions = new Set<string>();
      constructor (
        public module: VM.ModuleScope
      ) { }
    }

    const valueIsReachable = (value: VM.Value) => {
      if (value.type === 'FunctionValue') {
        const moduleID = value.moduleID;
        let module = reachableModules.get(moduleID);
        if (!module) {
          module = new ModuleReachability (notUndefined(this.moduleScopes.get(value.moduleID)));
          reachableModules.set(moduleID, module);
        }
        const func = notUndefined(module.module.functions.get(value.functionID));
        functionIsReachable(module, func);
        return;
      } else if (value.type === 'ExternalFunctionValue') {
        reachableExternalFunctions.add(value.value);
        return;
      }
      if (value.type !== 'ReferenceValue') {
        return;
      }
      const allocation = this.dereference(value);
      if (reachableAllocations.has(allocation)) {
        // Already visited
        return;
      }
      reachableAllocations.add(allocation);
      switch (allocation.type) {
        case 'ArrayAllocation': return allocation.value.forEach(valueIsReachable);
        case 'ObjectAllocation': return [...Object.values(allocation.value)].forEach(valueIsReachable);
        default: return assertUnreachable(allocation);
      }
    };

    const frameIsReachable = (frame: VM.Frame) => {
      if (frame.type === 'ExternalFrame') {
        valueIsReachable(frame.result);
        return;
      }
      frame.args.forEach(valueIsReachable);
      frame.variables.forEach(valueIsReachable);
      frame.object && valueIsReachable(frame.object);
    };

    const functionIsReachable = (module: ModuleReachability, func: IL.Function) => {
      if (module.reachableFunctions.has(func.id)) {
        // Already visited
        return;
      }
      module.reachableFunctions.add(func.id);
      for (const block of Object.values(func.blocks)) {
        for (const op of block.operations) {
          if (op.opcode === 'LoadModVar') {
            const nameOperand = op.operands[0];
            if (nameOperand.type !== 'NameOperand') {
              return unexpected();
            }
            const name = nameOperand.name;
            module.reachableVariables.add(name);
            const moduleVariable = module.module.moduleVariables[name];
            valueIsReachable(moduleVariable);
          } else if (op.opcode === 'LoadGlobal') {
            const nameOperand = op.operands[0];
            if (nameOperand.type !== 'NameOperand') {
              return unexpected();
            }
            const name = nameOperand.name;
            reachableGlobalVariables.add(name);
            const globalVariable = this.globalVariables[name];
            valueIsReachable(globalVariable);
          }
        }
      }
    };

    const reachableAllocations = new Set<VM.Allocation>();
    const reachableGlobalVariables = new Set<string>();
    const reachableExternalFunctions = new Set<string>();
    const reachableModules = new Map<string, ModuleReachability>();

    // Note: global and module variables are reachable indirectly through function code (see functionIsReachable)
    // // Roots in global variables
    // for (const globalVariable of Object.values(this.globalVariables)) {
    //   valueIsReachable(globalVariable);
    // }

    // // Roots in module variables
    // for (const module of this.moduleScopes.values()) {
    //   for (const moduleVariable of Object.values(module.moduleVariables)) {
    //     valueIsReachable(moduleVariable);
    //   }
    // }

    // Roots on the stack
    let frame: VM.Frame | undefined = this.frame;
    while (frame) {
      frameIsReachable(frame);
      frame = frame.callerFrame;
    }

    // Roots in anchors
    for (const anchor of this.anchors) {
      valueIsReachable(anchor.value);
    }

    // Sweep allocations
    for (const [i, a] of this.heap) {
      if (!reachableAllocations.has(a)) {
        this.heap.delete(i);
      }
    }

    // Sweep global variables
    for (const globalVariableID of Object.keys(this.globalVariables)) {
      if (!reachableGlobalVariables.has(globalVariableID)) {
        delete this.globalVariables[globalVariableID];
      }
    }

    // Sweep external functions
    for (const extID of this.externalFunctions.keys()) {
      if (!reachableExternalFunctions.has(extID)) {
        this.externalFunctions.delete(extID);
      }
    }

    // Sweep modules
    for (const [moduleID, module] of this.moduleScopes) {
      const reachability = reachableModules.get(moduleID);
      if (!reachability) {
        this.moduleScopes.delete(moduleID);
        continue;
      }
      // Sweep module variables
      for (const variableID of Object.keys(module.moduleVariables)) {
        if (!reachability.reachableVariables.has(variableID)) {
          delete module.moduleVariables[variableID];
        }
      }
      // Sweep module functions
      for (const functionID of module.functions.keys()) {
        if (!reachability.reachableFunctions.has(functionID)) {
          module.functions.delete(functionID);
        }
      }
    }
  }

  stringifyState() {
    return `${
      entries(this.globalVariables)
        .map(([k, v]) => `global ${stringifyIdentifier(k)} = ${this.stringifyValue(v)};`)
        .join('\n')
    }\n\n${
      [...this.anchors]
        .map(v => `anchor ${this.stringifyValue(v.value)};`)
        .join('\n')
    }\n\n${
      entries(this.moduleScopes)
        .map(([k, v]) => `module ${stringifyIdentifier(k)} ${this.stringifyModule(v)}`)
        .join('\n\n')
    }\n\n${
      entries(this.heap)
        .map(([k, v]) => `allocation${k} = ${this.stringifyAllocation(v)};`)
        .join('\n\n')
    }`;
  }

  stringifyAllocation(allocation: VM.Allocation): string {
    switch (allocation.type) {
      case 'ArrayAllocation':
        return `[${allocation.value
          .map(v => `\n  ${this.stringifyValue(v)},`)
          .join('')
        }\n]`;
      case 'ObjectAllocation':
        return `{${entries(allocation.value)
          .map(([k, v]) => `\n  ${stringifyIdentifier(k)}: ${this.stringifyValue(v)},`)
          .join('')
        }\n}`;
      default: return assertUnreachable(allocation);
    }
  }

  stringifyModule(module: VM.ModuleScope): string {
    return `{${
      entries(module.moduleVariables)
        .map(([k, v]) => `\n  var ${stringifyIdentifier(k)} = ${this.stringifyValue(v)};`)
        .join('')
    }\n${
      entries(module.functions)
        .map(([k, v]) => `\n  ${stringifyFunction(v, '  ')}`)
        .join('\n')
    }\n}`
  }

  stringifyValue(value: VM.Value): string {
    switch (value.type) {
      case 'UndefinedValue': return 'undefined';
      case 'NullValue': return 'null';
      case 'BooleanValue':
      case 'NumberValue':
      case 'StringValue': return JSON.stringify(value.value);
      case 'ExternalFunctionValue': return `external function ${stringifyIdentifier(value.value)}`;
      case 'FunctionValue': return `function ${stringifyIdentifier(value.moduleID)}.${stringifyIdentifier(value.functionID)}`;
      case 'ReferenceValue': return `allocation${value.value}`;
      default: return assertUnreachable(value);
    }
  }

  registerExternalFunction(nameHint: string, handler: VM.ExternalFunctionHandler): VM.Anchor<VM.ExternalFunctionValue> {
    const id = uniqueName(nameHint, n => this.externalFunctions.has(n));
    this.externalFunctions.set(id, handler);
    return this.createAnchor({
      type: 'ExternalFunctionValue',
      value: id
    });
  }


  getProperty(object: VM.Allocation, propertyName: string): VM.Value {
    if (object.type === 'ArrayAllocation') {
      if (propertyName === 'length') {
        return this.numberValue(object.value.length);
      } else if (propertyName === 'push') {
        return this.runtimeError('Array.push can only be accessed as a function call.')
      } else {
        return this.runtimeError(`Array.${propertyName} is not a valid array property.`)
      }
    } else if (object.type === 'ObjectAllocation') {
      if (propertyName in object.value) {
        return object.value[propertyName];
      } else {
        return IL.undefinedValue;
      }
    } else {
      return this.runtimeError(`Cannot access property "${propertyName}" on value of type ${this.getType(object)}`);
    }
  }

  setProperty(objectReference: VM.ReferenceValue<VM.Allocation>, propertyName: string, value: VM.Value) {
    const object = this.dereference(objectReference);
    if (object.type === 'ArrayAllocation') {
      const array = object.value;
      // Assigning an array length resizes the array
      if (propertyName === 'length') {
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
      object.value[propertyName] = value;
    } else {
      return this.runtimeError(`Cannot access property "${propertyName}" on value of type ${this.getType(object)}`);
    }
  }

  getState() {
    return {
      heap: this.heap,
      globalVariables: this.globalVariables,
      externalFunctions: this.externalFunctions,
      moduleScopes: this.moduleScopes,
      anchors: this.anchors
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
  private get moduleName() { return this.internalFrame.moduleID; }
  private get nextOperationIndex() { return this.internalFrame.nextOperationIndex; }
  private get object() { return this.internalFrame.object; }
  private get operationBeingExecuted() { return this.internalFrame.operationBeingExecuted; }
  private get variables() { return this.internalFrame.variables; }
  private set args(value: VM.Value[]) { this.internalFrame.args = value; }
  private set block(value: IL.Block) { this.internalFrame.block = value; }
  private set callerFrame(value: VM.Frame | undefined) { this.internalFrame.callerFrame = value; }
  private set filename(value: string) { this.internalFrame.filename = value; }
  private set func(value: IL.Function) { this.internalFrame.func = value; }
  private set moduleName(value: string) { this.internalFrame.moduleID = value; }
  private set nextOperationIndex(value: number) { this.internalFrame.nextOperationIndex = value; }
  private set object(value: VM.ReferenceValue<VM.ObjectAllocation> | undefined) { this.internalFrame.object = value; }
  private set operationBeingExecuted(value: IL.Operation) { this.internalFrame.operationBeingExecuted = value; }
  private set variables(value: VM.Value[]) { this.internalFrame.variables = value; }
}