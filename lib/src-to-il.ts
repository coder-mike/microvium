import * as babylon from '@babel/parser';
import * as B from '@babel/types';
import * as IL from './il';
import * as VM from './virtual-machine-types';
import { unexpected, assertUnreachable, invalidOperation, assert, isNameString, entries, stringifyIdentifier, notUndefined, notNull, notImplemented } from './utils';
import { isUInt16 } from './runtime-types';
import { ModuleSpecifier } from '../lib';

const outputStackDepthComments = false;

// Emits code that pushes a value to the stack
type LazyValue = (cur: Cursor) => void;
type Procedure = (cur: Cursor) => void;

interface Context {
  filename: string;
  nextBlockID: number;
  moduleScope: ModuleScope;
}

interface ModuleScope {
  type: 'ModuleScope';
  moduleObject: ModuleVariable;
  runtimeDeclaredVariables: Set<string>;
  moduleVariables: { [name: string]: ModuleVariable | ImportedVariable };
  globalVariables: { [name: string]: GlobalVariable };
  moduleImports: { [variableName: string]: ModuleSpecifier };
}

type Variable =
  | ModuleVariable
  | ImportedVariable
  | GlobalVariable
  | LocalVariable

/**
 * A variable that is declared at the module scope.
 */
interface ModuleVariable {
  type: 'ModuleVariable';
  declarationType: 'Variable' | 'Function';
  // ID to use when accessing the runtime variable table. Note that this is not
  // necessarily the same as the "name" used in bindings. Also, there may be
  // multiple bindings (ModuleScope.moduleVariables) to the same variable, if
  // there are aliases (particularly relevant with import and export
  // declarations).
  id: string;
  readonly: boolean;
  // Note: exported variables are stored in the module object, not locally
  exported: boolean;
}

/**
 * Variable that is global to all modules (declared externally to the user code)
 */
interface GlobalVariable {
  type: 'GlobalVariable';
  used: boolean;
  id: string;
  readonly: boolean;
}

/**
 * Variable imported from another module
 */
interface ImportedVariable {
  type: 'ImportedVariable';
  sourceModuleObjectID: string; // Variable name of the module object
  propertyName: string; // Property to access on the module object
  readonly: boolean;
}

/**
 * A variable that is local to the function or entry code
 */
interface LocalVariable {
  type: 'LocalVariable';
  index: number;
  readonly: boolean;
}

interface LocalScope {
  type: 'LocalScope';
  parentScope: LocalScope | ModuleScope;
  localVariables: { [name: string]: LocalVariable };
}

interface ValueAccessor {
  store: (cur: Cursor, value: LazyValue) => void;
  load: LazyValue;
}

// Tells us where we're inserting into the IL
interface Cursor {
  ctx: Context;
  scope: LocalScope;
  unit: IL.Unit;
  func: IL.Function;
  block: IL.Block;
  node: B.Node;
  stackDepth: number;
  sourceLoc: { line: number; column: number; };
  commentNext?: string[];
}

function moveCursor(cur: Cursor, toLocation: Cursor): void {
  Object.assign(cur, toLocation);
}

export function compileScript(filename: string, scriptText: string, globals: string[]): IL.Unit {
  let file: B.File;
  try {
    file = babylon.parse(scriptText, {
      sourceType: 'module' ,
      plugins: ['nullishCoalescingOperator', 'numericSeparator']
    });
  } catch (e) {
    if (e.loc) {
      throw new SyntaxError(`${
        e.message
      }\n      at (${
        filename
      }:${
        e.loc.line
      }:${
        e.loc.column
      })`);
    }
    throw e;
  }
  const entryBlock: IL.Block = {
    id: 'entry',
    expectedStackDepthAtEntry: 0,
    operations: []
  }
  const entryFunction: IL.Function = {
    type: 'Function',
    sourceFilename: filename,
    id: '#entry',
    entryBlockID: 'entry',
    maxStackDepth: 0,
    blocks: {
      ['entry']: entryBlock
    }
  };
  const unit: IL.Unit = {
    sourceFilename: filename,
    functions: { [entryFunction.id]: entryFunction },
    moduleVariables: [],
    freeVariables: [],
    entryFunctionID: entryFunction.id,
    moduleImports: Object.create(null),
  };
  const moduleScope: ModuleScope = {
    type: 'ModuleScope',
    runtimeDeclaredVariables: new Set<string>(),
    moduleObject: undefined as any, // Filled in later
    moduleVariables: Object.create(null),
    globalVariables: Object.create(null),
    moduleImports: unit.moduleImports
  };

  for (const g of globals) {
    if (g in moduleScope.globalVariables) {
      return invalidOperation('Duplicate global');
    }
    moduleScope.globalVariables[g] = { type: 'GlobalVariable', id: g, used: false, readonly: false };
  }

  const moduleVariables = moduleScope.moduleVariables;
  const ctx: Context = {
    filename,
    nextBlockID: 1,
    moduleScope
  };
  // Local scope for entry function
  const entryFunctionScope: LocalScope = {
    type: 'LocalScope',
    localVariables: Object.create(null),
    parentScope: moduleScope
  }
  const cur: Cursor = {
    ctx,
    sourceLoc: { line: 0, column: 0 },
    scope: entryFunctionScope,
    stackDepth: 0,
    node: file,
    unit: unit,
    func: unit.functions[unit.entryFunctionID],
    block: entryBlock
  }
  const program = file.program;
  const body = program.body;
  const functionsToCompile: B.FunctionDeclaration[] = [];

  // Load module object which is passed as an argument to the entry function
  addOp(cur, 'LoadArg', indexOperand(0));
  moduleScope.moduleObject = {
    type: 'ModuleVariable',
    id: 'exports',
    declarationType: 'Variable',
    readonly: true,
    exported: false
  };
  addOp(cur, 'StoreGlobal', nameOperand('exports'));
  moduleScope.moduleVariables['exports'] = moduleScope.moduleObject;
  moduleScope.runtimeDeclaredVariables.add(moduleScope.moduleObject.id);

  // Get a list of functions that need to be compiled
  for (const statement of body) {
    let func: B.FunctionDeclaration;
    let exported: boolean;
    if (statement.type === 'FunctionDeclaration') {
      func = statement;
      exported = false;
    } else if (statement.type === 'ExportNamedDeclaration' && statement.declaration && statement.declaration.type === 'FunctionDeclaration') {
      func = statement.declaration;
      exported = true;
    } else {
      continue;
    }
    functionsToCompile.push(func);
    if (!func.id) return unexpected();
    const functionName = func.id.name;
    if (!isNameString(functionName)) {
      return compileError(cur, `Invalid identifier: ${JSON.stringify(functionName)}`);
    }
    if (functionName in moduleVariables) {
      return compileError(cur, `Duplicate declaration with name: "${functionName}"`);
    }
    const privateVariable: ModuleVariable = {
      type: 'ModuleVariable',
      declarationType: 'Function',
      id: functionName,
      readonly: true,
      exported: false // See below
    };
    moduleScope.moduleVariables[functionName] = privateVariable;
    if (exported) {
      // Exported functions have two variables. One represents the function code
      // itself, and the other is a reference value on the module object. The
      // reference value on the module object is not visible to module code.
      const exportedVariable: ModuleVariable = {
        type: 'ModuleVariable',
        declarationType: 'Function',
        id: functionName,
        readonly: true,
        exported: true
      };
      getModuleVariableAccessor(cur, exportedVariable)
        .store(cur, getModuleVariableAccessor(cur, privateVariable).load)
    }
  }

  for (const statement of body) {
    if (statement.type !== 'FunctionDeclaration') {
      compileModuleStatement(cur, statement);
    }
  }

  // Functions are compiled at the end, they may have code that references
  // variables declared in the module scope after the declaration of the
  // function itself.
  for (const func of functionsToCompile) {
    compileFunction(cur, func);
  }

  addOp(cur, 'Literal', literalOperand(undefined));
  addOp(cur, 'Return');

  computeMaximumStackDepth(entryFunction);

  unit.moduleVariables = [...moduleScope.runtimeDeclaredVariables];

  unit.freeVariables = [...Object.values(moduleScope.globalVariables)]
    .filter(v => v.used)
    .map(v => v.id);

  return unit;
}

export function compileModuleStatement(cur: Cursor, statement: B.Statement) {
  switch (statement.type) {
    case 'VariableDeclaration':
      compilingNode(cur, statement);
      compileModuleVariableDeclaration(cur, statement, false);
      break;
    case 'ExportNamedDeclaration':
      compilingNode(cur, statement);
      compileExportNamedDeclaration(cur, statement);
      break;
    case 'ExportDefaultDeclaration':
      compilingNode(cur, statement);
      return compileError(cur, 'Syntax not supported');
    case 'ExportAllDeclaration':
      compilingNode(cur, statement);
      return compileError(cur, 'Syntax not supported');
    case 'ImportDeclaration':
      compilingNode(cur, statement);
      compileImportDeclaration(cur, statement);
      break;
    default:
      compileStatement(cur, statement);
      break;
  }
}

export function compileImportDeclaration(cur: Cursor, statement: B.ImportDeclaration) {
  const moduleImports = cur.ctx.moduleScope.moduleImports;

  const sourcePath = statement.source.value;

  const importedModuleVariable: ModuleVariable = {
    type: 'ModuleVariable',
    declarationType: 'Variable',
    exported: false,
    id: `#${sourcePath}`,
    readonly: false
  };

  // Note: The same path specifier will refer to the same import variable
  moduleImports[importedModuleVariable.id] = sourcePath;

  const moduleVariables = cur.ctx.moduleScope.moduleVariables;

  for (const specifier of statement.specifiers) {
    compilingNode(cur, specifier);
    switch (specifier.type) {
      case 'ImportNamespaceSpecifier': {
        const name = specifier.local.name;
        if (name in moduleVariables) {
          return compileError(cur, `Duplicate module-level identifier: "${name}"`);
        }
        if (!isNameString(name)) {
          return compileError(cur, `Invalid identifier: ${JSON.stringify(name)}`);
        }
        moduleVariables[name] = importedModuleVariable;
        break;
      }
      case 'ImportDefaultSpecifier': {
        const name = specifier.local.name;
        const variable: ImportedVariable = {
          type: 'ImportedVariable',
          sourceModuleObjectID: importedModuleVariable.id,
          propertyName: 'default',
          readonly: false
        };
        if (name in moduleVariables) {
          return compileError(cur, `Duplicate module-level identifier: "${name}"`);
        }
        if (!isNameString(name)) {
          return compileError(cur, `Invalid identifier: ${JSON.stringify(name)}`);
        }
        moduleVariables[name] = variable;
        break;
      }
      case 'ImportSpecifier': {
        const name = specifier.local.name;
        const variable: ImportedVariable = {
          type: 'ImportedVariable',
          sourceModuleObjectID: importedModuleVariable.id,
          propertyName: specifier.imported.name,
          readonly: false
        };
        if (name in moduleVariables) {
          return compileError(cur, `Duplicate module-level identifier: "${name}"`);
        }
        if (!isNameString(name)) {
          return compileError(cur, `Invalid identifier: ${JSON.stringify(name)}`);
        }
        moduleVariables[name] = variable;
        break;
      }
      default: return assertUnreachable(specifier);
    }
  }
}

export function compileExportNamedDeclaration(cur: Cursor, statement: B.ExportNamedDeclaration) {
  if (statement.source || statement.specifiers.length) {
    return compileError(cur, 'Only simple export syntax is supported')
  }
  const declaration = statement.declaration;
  if (declaration.type === 'VariableDeclaration') {
    compileModuleVariableDeclaration(cur, declaration, true);
  } else if (declaration.type === 'FunctionDeclaration') {
    /* Handled separately */
  } else {
    return compileError(cur, `Not supported: export of ${declaration.type}`);
  }
}

export function compileModuleVariableDeclaration(cur: Cursor, decl: B.VariableDeclaration, exported: boolean) {
  const moduleScope = cur.ctx.moduleScope;
  const moduleVariables = moduleScope.moduleVariables;
  const moduleVariableIDs = moduleScope.runtimeDeclaredVariables;
  for (const d of decl.declarations) {
    compilingNode(cur, d);
    if (d.id.type !== 'Identifier') {
      return compileError(cur, 'Only simple variable declarations are supported.')
    }
    const variableName = d.id.name;
    if (!isNameString(variableName)) {
      return compileError(cur, `Invalid variable identifier: "${variableName}"`);
    }
    if (variableName in moduleVariables) {
      return compileError(cur, `Duplicate variable declaration: "${variableName}"`);
    }

    const init = d.init;
    const initialValue: LazyValue = init
      ? cur => compileExpression(cur, init)
      : cur => addOp(cur, 'Literal', literalOperand(undefined));

    const variable: ModuleVariable = {
      type: 'ModuleVariable',
      declarationType: 'Variable',
      id: variableName,
      readonly: false, // Starts out writable so we can set the initial value
      exported
    };

    getModuleVariableAccessor(cur, variable).store(cur, initialValue);

    variable.readonly = decl.kind === 'const';

    moduleVariables[variableName] = variable;
    // If the variable is exported, it's part of the module object, not part of the runtime declared variables
    if (!exported) {
      moduleVariableIDs.add(variable.id);
    }
  }
}

export function compileFunction(cur: Cursor, func: B.FunctionDeclaration) {
  const entryBlock: IL.Block = {
    id: 'entry',
    expectedStackDepthAtEntry: 0,
    operations: []
  }
  if (!func.id) return unexpected();
  const id = func.id.name;
  if (!isNameString(id)) {
    return compileError(cur, `Invalid function identifier: "${id}`);
  }
  const funcIL: IL.Function = {
    type: 'Function',
    sourceFilename: cur.unit.sourceFilename,
    id,
    entryBlockID: 'entry',
    maxStackDepth: 0,
    blocks: {
      ['entry']: entryBlock
    }
  };
  const functionScope: LocalScope = {
    type: 'LocalScope',
    localVariables: Object.create(null),
    parentScope: cur.ctx.moduleScope
  }
  const bodyCur: Cursor = {
    ctx: {
      filename: cur.ctx.filename,
      nextBlockID: 1,
      moduleScope: cur.ctx.moduleScope
    },
    sourceLoc: cur.sourceLoc,
    scope: functionScope,
    stackDepth: 0,
    node: func.body,
    unit: cur.unit,
    func: funcIL,
    block: entryBlock
  };

  if (funcIL.id in cur.unit.functions) {
    return compileError(cur, `Duplicate function declaration with name "${funcIL.id}"`);
  }
  cur.unit.functions[funcIL.id] = funcIL;

  // Copy arguments into parameter slots
  for (const [index, param] of func.params.entries()) {
    compileParam(bodyCur, param, index);
  }

  // Body of function
  for (const statement of func.body.body) {
    compileStatement(bodyCur, statement);
  }

  // Pop parameters off the stack

  addOp(bodyCur, 'Literal', literalOperand(undefined));
  addOp(bodyCur, 'Return');

  computeMaximumStackDepth(funcIL);
}

export function compileExpressionStatement(cur: Cursor, statement: B.ExpressionStatement): void {
  compileExpression(cur, statement.expression);
  // Pop the result of the expression off the stack
  addOp(cur, 'Pop', countOperand(1));
}

export function compileReturnStatement(cur: Cursor, statement: B.ReturnStatement): void {
  if (statement.argument) {
    compileExpression(cur, statement.argument);
  } else {
    addOp(cur, 'Literal', literalOperand(undefined));
  }
  addOp(cur, 'Return');
}


export function compileForStatement(cur: Cursor, statement: B.ForStatement): void {
  const scope = startScope(cur);

  // Init
  if (!statement.init) return unexpected();
  compilingNode(cur, statement.init);
  if (statement.init.type === 'VariableDeclaration') {
    compileVariableDeclaration(cur, statement.init);
  } else {
    compileExpression(cur, statement.init);
    addOp(cur, 'Pop', countOperand(1));
  }

  const [loopBlock, loopCur] = createBlock(cur, cur.stackDepth, cur.scope);
  if (!statement.test) return unexpected();
  compileExpression(loopCur, statement.test);
  const [bodyBlock, bodyCur] = createBlock(loopCur, loopCur.stackDepth - 1, loopCur.scope);
  compileStatement(bodyCur, statement.body);
  if (!statement.update) return unexpected();
  compileExpression(bodyCur, statement.update);
  addOp(bodyCur, 'Pop', countOperand(1)); // Expression result not used
  const [terminateBlock, terminateBlockCur] = createBlock(bodyCur, bodyCur.stackDepth, bodyCur.scope);

  // Jump into loop from initializer
  addOp(cur, 'Jump', labelOfBlock(loopBlock));

  // Branch after test
  addOp(loopCur, 'Branch', labelOfBlock(bodyBlock), labelOfBlock(terminateBlock));

  // Loop back at end of body
  addOp(bodyCur, 'Jump', labelOfBlock(loopBlock));

  moveCursor(cur, terminateBlockCur);
  scope.endScope();
}

export function compileWhileStatement(cur: Cursor, statement: B.WhileStatement): void {
  const [testBlock, testCur] = createBlock(cur, cur.stackDepth, cur.scope);
  addOp(cur, 'Jump', labelOfBlock(testBlock));
  compileExpression(testCur, statement.test);
  const [bodyBlock, bodyCur] = createBlock(cur, cur.stackDepth, cur.scope);
  compileStatement(bodyCur, statement.body);
  const [exitBlock, exitCur] = createBlock(cur, cur.stackDepth, cur.scope);
  addOp(testCur, 'Branch', labelOfBlock(bodyBlock), labelOfBlock(exitBlock));
  addOp(bodyCur, 'Jump', labelOfBlock(testBlock));
  moveCursor(cur, exitCur);
}

export function compileDoWhileStatement(cur: Cursor, statement: B.DoWhileStatement): void {
  const [body, bodyCur] = createBlock(cur, cur.stackDepth, cur.scope);
  compileStatement(bodyCur, statement.body);
  compileExpression(bodyCur, statement.test);
  const [after, afterCur] = createBlock(bodyCur, cur.stackDepth, cur.scope);
  addOp(cur, 'Jump', labelOfBlock(body));
  addOp(bodyCur, 'Branch', labelOfBlock(body), labelOfBlock(after));
  moveCursor(cur, afterCur);
}

export function compileBlockStatement(cur: Cursor, statement: B.BlockStatement): void {
  // Create a new scope for variables within the block
  const scope = startScope(cur);
  for (const s of statement.body) {
    compileStatement(cur, s);
  }
  scope.endScope();
}

export function compileIfStatement(cur: Cursor, statement: B.IfStatement): void {
  if (statement.alternate) {
    // Expression leaves the test result at the top of the stack
    compileExpression(cur, statement.test);

    // The -1 is because the branch instruction pops a value off the stack
    const [consequent, consequentCur] = createBlock(cur, cur.stackDepth - 1, cur.scope);
    compileStatement(consequentCur, statement.consequent);

    const [alternate, alternateCur] = createBlock(cur, cur.stackDepth - 1, cur.scope);
    compileStatement(alternateCur, statement.alternate);

    const [after, afterCur] = createBlock(cur, cur.stackDepth - 1, cur.scope);

    addOp(cur, 'Branch', labelOfBlock(consequent), labelOfBlock(alternate));
    addOp(consequentCur, 'Jump', labelOfBlock(after));
    addOp(alternateCur, 'Jump', labelOfBlock(after));
    moveCursor(cur, afterCur);
  } else {
    // Expression leaves the test result at the top of the stack
    compileExpression(cur, statement.test);

    const [consequent, consequentCur] = createBlock(cur, cur.stackDepth - 1, cur.scope);
    compileStatement(consequentCur, statement.consequent);

    const [after, afterCur] = createBlock(cur, cur.stackDepth - 1, cur.scope);

    addOp(cur, 'Branch', labelOfBlock(consequent), labelOfBlock(after));
    addOp(consequentCur, 'Jump', labelOfBlock(after));
    moveCursor(cur, afterCur);
  }
}

/**
 * Creates a block and returns a cursor at the start of the block
 */
function createBlock(cur: Cursor, stackDepth: number, scope: LocalScope): [IL.Block, Cursor] {
  const block: IL.Block = {
    id: `block${cur.ctx.nextBlockID++}`,
    expectedStackDepthAtEntry: stackDepth,
    operations: []
  };
  if (cur.commentNext) {
    block.comments = cur.commentNext;
    cur.commentNext = undefined;
  }
  cur.func.blocks[block.id] = block;
  const blockCursor: Cursor = {
    sourceLoc: cur.sourceLoc,
    scope: scope,
    ctx: cur.ctx,
    func: cur.func,
    node: cur.node,
    stackDepth,
    unit: cur.unit,
    block
  };
  return [block, blockCursor];
}

function compileError(cur: Cursor, message: string): never {
  if (!cur.node.loc) return unexpected();
  throw new Error(`${
    message
  }\n      at ${cur.node.type} (${
    cur.ctx.filename
  }:${
    cur.node.loc.start.line
  }:${
    cur.node.loc.start.column
  })`);
}

/**
 * An error resulting from the internal compiler code, not a user mistake
 */
function internalCompileError(cur: Cursor, message: string): never {
  if (!cur.node.loc) return unexpected();
  throw new Error(`Internal compile error: ${
    message
  }\n      at ${cur.node.type} (${
    cur.ctx.filename
  }:${
    cur.node.loc.start.line
  }:${
    cur.node.loc.start.column
  })`);
}

function addOp(cur: Cursor, opcode: IL.Opcode, ...operands: IL.Operand[]) {
  const meta = IL.opcodes[opcode];
  for (const [i, expectedType] of meta.operands.entries()) {
    const operand = operands[i];
    if (operand.type !== expectedType) {
      return internalCompileError(cur, `Expected operand of type "${expectedType}" but received "${operand.type}", for opcode "${opcode}"`)
    }
    switch (operand.type) {
      case 'NameOperand': break;
      case 'IndexOperand': {
        if (operand.index < 0 || operand.index > IL.MAX_INDEX) {
          return internalCompileError(cur, `Index out of range: ${operand.index}`);
        }
        break;
      }
      case 'CountOperand': {
        if (operand.count < 0 || operand.count > IL.MAX_COUNT) {
          return internalCompileError(cur, `Count out of range: ${operand.count}`);
        }
        break;
      }
    }
  }
  if (operands.length !== meta.operands.length) {
    return internalCompileError(cur, `Incorrect number of operands to operation with opcode "${opcode}"`);
  }
  const operation: IL.Operation = {
    opcode,
    operands,
    sourceLoc: cur.sourceLoc,
    stackDepthBefore: cur.stackDepth,
    stackDepthAfter: undefined as any // Assign later
  };
  if (outputStackDepthComments) {
    addCommentToNextOp(cur, `stackDepth = ${cur.stackDepth}`);
  }
  if (cur.commentNext) {
    operation.comments = cur.commentNext;
    cur.commentNext = undefined;
  }
  cur.block.operations.push(operation);
  let stackChange = meta.stackChange;
  if (typeof stackChange === 'function')
    stackChange = stackChange(operation);
  cur.stackDepth += stackChange;
  operation.stackDepthAfter = cur.stackDepth;

  if (opcode === 'Jump') {
    const target = operation.operands[0];
    if (target.type !== 'LabelOperand') {
      return unexpected();
    }
    const targetBlock = cur.func.blocks[target.targetBlockID];
    if (targetBlock.expectedStackDepthAtEntry !== operation.stackDepthAfter) {
      return internalCompileError(cur, `Jumping from stack depth of ${operation.stackDepthAfter} to block with stack depth of ${targetBlock.expectedStackDepthAtEntry}`);
    }
  } else if (opcode === 'Branch') {
    const targetTrue = operation.operands[0];
    const targetFalse = operation.operands[1];
    if (targetTrue.type !== 'LabelOperand') {
      return unexpected();
    }
    if (targetFalse.type !== 'LabelOperand') {
      return unexpected();
    }
    const targetBlockTrue = cur.func.blocks[targetTrue.targetBlockID];
    if (targetBlockTrue.expectedStackDepthAtEntry !== operation.stackDepthAfter) {
      return internalCompileError(cur, `Branching (true branch) from stack depth of ${operation.stackDepthAfter} to block with stack depth of ${targetBlockTrue.expectedStackDepthAtEntry}`);
    }
    const targetBlockFalse = cur.func.blocks[targetTrue.targetBlockID];
    if (targetBlockTrue.expectedStackDepthAtEntry !== operation.stackDepthAfter) {
      return internalCompileError(cur, `Branching (false branch) from stack depth of ${operation.stackDepthAfter} to block with stack depth of ${targetBlockTrue.expectedStackDepthAtEntry}`);
    }
  }
}

function labelOfBlock(block: IL.Block): IL.LabelOperand {
  return {
    type: 'LabelOperand',
    targetBlockID: block.id
  }
}

function literalOperand(value: IL.LiteralValueType): IL.LiteralOperand {
  return {
    type: 'LiteralOperand',
    literal: literalOperandValue(value)
  }
}

function countOperand(count: number): IL.CountOperand {
  return {
    type: 'CountOperand',
    count
  }
}

function indexOperand(index: number): IL.IndexOperand {
  return {
    type: 'IndexOperand',
    index
  }
}

function nameOperand(name: string): IL.NameOperand {
  return {
    type: 'NameOperand',
    name
  }
}

function opOperand(subOperation: string): IL.OpOperand {
  return {
    type: 'OpOperand',
    subOperation
  }
}

function literalOperandValue(value: IL.LiteralValueType): IL.Value {
  if (value === null) {
    return IL.nullValue;
  }
  switch (typeof value) {
    case 'undefined': return IL.undefinedValue;
    case 'boolean': return { type: 'BooleanValue', value };
    case 'number': return { type: 'NumberValue', value };
    case 'string': return { type: 'StringValue', value };
    default: return assertUnreachable(value);
  }
}

export function compileStatement(cur: Cursor, statement: B.Statement) {
  compilingNode(cur, statement);

  if (compileNopSpecialForm(cur, statement)) {
    return;
  }

  switch (statement.type) {
    case 'IfStatement': return compileIfStatement(cur, statement);
    case 'BlockStatement': return compileBlockStatement(cur, statement);
    case 'ExpressionStatement': return compileExpressionStatement(cur, statement);
    case 'WhileStatement': return compileWhileStatement(cur, statement);
    case 'DoWhileStatement': return compileDoWhileStatement(cur, statement);
    case 'VariableDeclaration': return compileVariableDeclaration(cur, statement);
    case 'ForStatement': return compileForStatement(cur, statement);
    case 'ReturnStatement': return compileReturnStatement(cur, statement);
    default: return compileError(cur, `Statement of type "${statement.type}" not supported.`);
  }
}

export function compileExpression(cur: Cursor, expression: B.Expression) {
  compilingNode(cur, expression);
  switch (expression.type) {
    case 'BooleanLiteral':
    case 'NumericLiteral':
    case 'StringLiteral':
      return addOp(cur, 'Literal', literalOperand(expression.value));
    case 'NullLiteral': return addOp(cur, 'Literal', literalOperand(null));
    case 'Identifier': return compileIdentifier(cur, expression);
    case 'BinaryExpression': return compileBinaryExpression(cur, expression);
    case 'UpdateExpression': return compileUpdateExpression(cur, expression);
    case 'UnaryExpression': return compileUnaryExpression(cur, expression);
    case 'AssignmentExpression': return compileAssignmentExpression(cur, expression);
    case 'LogicalExpression': return compileLogicalExpression(cur, expression);
    case 'CallExpression': return compileCallExpression(cur, expression);
    case 'MemberExpression': return compileMemberExpression(cur, expression);
    case 'ArrayExpression': return compileArrayExpression(cur, expression);
    case 'ObjectExpression': return compileObjectExpression(cur, expression);
    case 'ConditionalExpression': return compileConditionalExpression(cur, expression);
    default: return compileError(cur, `Expression of type "${expression.type}" not supported.`);
  }
}

export function compileConditionalExpression(cur: Cursor, expression: B.ConditionalExpression) {
  // Expression leaves the test result at the top of the stack
  compileExpression(cur, expression.test);

  // The -1 is because the branch instruction pops a value off the stack
  const [consequent, consequentCur] = createBlock(cur, cur.stackDepth - 1, cur.scope);
  compileExpression(consequentCur, expression.consequent);

  const [alternate, alternateCur] = createBlock(cur, cur.stackDepth - 1, cur.scope);
  compileExpression(alternateCur, expression.alternate);

  // The stack depth is the same as when we have the "test" result on the stack,
  // because the consequent and alternate paths both pop the test and push the
  // result.
  const [after, afterCur] = createBlock(cur, cur.stackDepth, cur.scope);

  addOp(cur, 'Branch', labelOfBlock(consequent), labelOfBlock(alternate));
  addOp(consequentCur, 'Jump', labelOfBlock(after));
  addOp(alternateCur, 'Jump', labelOfBlock(after));
  moveCursor(cur, afterCur);
}

export function compileArrayExpression(cur: Cursor, expression: B.ArrayExpression) {
  addOp(cur, 'ArrayNew');
  for (const element of expression.elements) {
    if (!element) {
      return compileError(cur, 'Expected array element');
    }
    if (element.type === 'SpreadElement') {
      return compileError(cur, 'Spread syntax not supported');
    }
    addOp(cur, 'Dup');
    compileExpression(cur, element);
    addOp(cur, 'CallMethod', nameOperand('push'), countOperand(1));
    addOp(cur, 'Pop', countOperand(1));
  }
}

export function compileObjectExpression(cur: Cursor, expression: B.ObjectExpression) {
  addOp(cur, 'ObjectNew');
  const objectVariableIndex = cur.stackDepth - 1;
  for (const property of expression.properties) {
    if (property.type === 'SpreadElement') {
      return compileError(cur, 'Spread syntax not supported');
    }
    if (property.type === 'ObjectMethod') {
      return compileError(cur, 'Object methods are not supported');
    }
    if (property.computed || property.key.type !== 'Identifier') {
      return compileError(cur, 'Object properties must be simple identifiers');
    }
    addOp(cur, 'LoadVar', indexOperand(objectVariableIndex));
    addOp(cur, 'Literal', literalOperand(property.key.name));
    if (!B.isExpression(property.value)) return unexpected();
    compileExpression(cur, property.value);
    addOp(cur, 'ObjectSet');
  }
}

export function compileMemberExpression(cur: Cursor, expression: B.MemberExpression) {
  if (expression.object.type === 'Super') {
    return compileError(cur, 'Illegal use of reserved word "super" in this context');
  }
  compileExpression(cur, expression.object);
  if (expression.computed) {
    // Like `array[index]`
    compileExpression(cur, expression.property);
    addOp(cur, 'ObjectGet');
  } else {
    // Like `object.property`
    if (expression.property.type !== 'Identifier') {
      // I don't think his can be anything other than an identifier?
      return compileError(cur, 'Unexpected accessor form');
    }
    addOp(cur, 'Literal', literalOperand(expression.property.name));
    addOp(cur, 'ObjectGet');
  }
}

export function compileCallExpression(cur: Cursor, expression: B.CallExpression) {
  const callee = expression.callee;
  if (callee.type === 'Super') {
    return compileError(cur, 'Reserved word "super" invalid in this context');
  }

  if (callee.type === 'MemberExpression' && !callee.computed) {
    // Method calls are invoked on the object
    compileExpression(cur, callee.object);
  } else {
    if (!B.isExpression(callee)) return unexpected();
    compileExpression(cur, callee);
  }
  for (const arg of expression.arguments) {
    compilingNode(cur, arg);
    if (arg.type === 'SpreadElement') {
      return compileError(cur, 'Unsupported syntax');
    }
    if (!B.isExpression(arg)) return unexpected();
    compileExpression(cur, arg);
  }

  if (callee.type === 'MemberExpression' && !callee.computed) {
    if (callee.property.type !== 'Identifier') {
      return compileError(cur, 'Method call needs to use simple identifier for method name');
    }
    const methodName = callee.property.name;
    addOp(cur, 'CallMethod', nameOperand(methodName), countOperand(expression.arguments.length));
  } else {
    addOp(cur, 'Call', countOperand(expression.arguments.length));
  }
}

export function compileLogicalExpression(cur: Cursor, expression: B.LogicalExpression) {
  if (expression.operator === '&&' || expression.operator === '||') {
    compileExpression(cur, expression.left);
    addOp(cur, 'LoadVar', indexOperand(cur.stackDepth - 1)); // Duplicate as result if falsy
    const [rightBlock, rightCur] = createBlock(cur, cur.stackDepth - 1, cur.scope);
    // If we get as far as evaluating the right, it means the result is not the
    // left, so pop the duplicate-left-value off the stack
    addOp(rightCur, 'Pop', countOperand(1));
    compileExpression(rightCur, expression.right);
    const [endBlock, endCur] = createBlock(rightCur, rightCur.stackDepth, rightCur.scope);
    addOp(rightCur, 'Jump', labelOfBlock(endBlock));
    if (expression.operator === '&&') {
      // Short circuit && -- if left is truthy, result is right, else result is left
      addOp(cur, 'Branch', labelOfBlock(rightBlock), labelOfBlock(endBlock));
    } else {
      // Short circuit || -- if left is truthy, result is left, else result is right
      addOp(cur, 'Branch', labelOfBlock(endBlock), labelOfBlock(rightBlock));
    }
    moveCursor(cur, endCur);
    cur.stackDepth = endCur.stackDepth;
  } else if (expression.operator === '??') {
    return notImplemented();
  } else {
    return assertUnreachable(expression.operator);
  }
}

export function compileAssignmentExpression(cur: Cursor, expression: B.AssignmentExpression) {
  if (expression.left.type === 'RestElement' ||
      expression.left.type === 'AssignmentPattern' ||
      expression.left.type === 'ArrayPattern' ||
      expression.left.type === 'ObjectPattern' ||
      expression.left.type === 'TSParameterProperty'
  ) {
    return compileError(cur, `Syntax not supported: ${expression.left.type}`);
  }
  if (expression.operator === '=') {
    const left = resolveLValue(cur, expression.left);
    compileExpression(cur, expression.right);
    const valueIndex = cur.stackDepth - 1;
    const value: LazyValue =
      cur => addOp(cur, 'LoadVar', indexOperand(valueIndex));
    left.store(cur, value);
  } else {
    const left = resolveLValue(cur, expression.left);
    left.load(cur);
    compileExpression(cur, expression.right);
    const operator = getBinOpFromAssignmentExpression(cur, expression.operator);
    addOp(cur, 'BinOp', opOperand(operator));
    const valueIndex = cur.stackDepth - 1;
    const value: LazyValue =
      cur => addOp(cur, 'LoadVar', indexOperand(valueIndex));
    left.store(cur, value);
  }
}

function getBinOpFromAssignmentExpression(cur: Cursor, operator: B.AssignmentExpression['operator']): IL.BinOpCode {
  switch (operator) {
    case '=': return unexpected();
    case '%=': return '%';
    case '&=': return '&';
    case '*=': return '*';
    case '+=': return '+';
    case '-=': return '-';
    case '/=': return '/';
    case '<<=': return '<<';
    case '>>=': return '>>';
    case '>>>=': return '>>>';
    case '^=': return '^';
    case '|=': return '|';
    default: notImplemented(operator);
  }
}

export function resolveLValue(cur: Cursor, lVal: B.LVal): ValueAccessor {
  if (lVal.type === 'Identifier') {
    const variableName = lVal.name;
    const variable = findVariable(cur, variableName);
    switch (variable.type) {
      case 'LocalVariable': return getLocalVariableAccessor(cur, variable);
      case 'GlobalVariable': return getGlobalVariableAccessor(cur, variable);
      case 'ModuleVariable': return getModuleVariableAccessor(cur, variable);
      case 'ImportedVariable': return getImportedVariableAccessor(cur, variable);
      default: assertUnreachable(variable);
    }
  } else if (lVal.type === 'MemberExpression') {
    const object: LazyValue = cur => compileExpression(cur, lVal.object);
    // Computed properties are like a[0], and are only used for array access within the context of Microvium
    if (lVal.computed) {
      const property: LazyValue = cur => compileExpression(cur, lVal.property);
      return getObjectMemberAccessor(cur, object, property);
    } else {
      if (lVal.property.type !== 'Identifier') {
        return compileError(cur, 'Property names must be simple identifiers');
      }
      const propName = lVal.property.name;
      const property: LazyValue = cur => addOp(cur, 'Literal', literalOperand(propName));
      return getObjectMemberAccessor(cur, object, property);
    }
  } else {
    return compileError(cur, `Feature not supported: "${lVal.type}"`);
  }
}

function getObjectMemberAccessor(cur: Cursor, object: LazyValue, property: LazyValue): ValueAccessor {
  return {
    load(cur: Cursor) {
      object(cur);
      property(cur);
      addOp(cur, 'ObjectGet');
    },
    store(cur: Cursor, value: LazyValue) {
      object(cur);
      property(cur);
      value(cur);
      addOp(cur, 'ObjectSet');
    }
  }
}

function getLocalVariableAccessor(cur: Cursor, variable: LocalVariable): ValueAccessor {
  return {
    load(cur: Cursor) {
      addOp(cur, 'LoadVar', indexOperand(variable.index));
    },
    store(cur: Cursor, value: LazyValue) {
      if (variable.readonly) {
        return compileError(cur, 'Cannot assign to constant');
      }
      value(cur);
      addOp(cur, 'StoreVar', indexOperand(variable.index));
    }
  };
}

function getImportedVariableAccessor(cur: Cursor, variable: ImportedVariable): ValueAccessor {
  return {
    load(cur: Cursor) {
      addOp(cur, 'LoadGlobal', nameOperand(variable.sourceModuleObjectID));
      addOp(cur, 'Literal', literalOperand(variable.propertyName));
      addOp(cur, 'ObjectGet');
    },
    store(cur: Cursor, value: LazyValue) {
      if (variable.readonly) {
        return compileError(cur, 'Cannot assign to constant');
      }
      addOp(cur, 'LoadGlobal', nameOperand(variable.sourceModuleObjectID));
      addOp(cur, 'Literal', literalOperand(variable.propertyName));
      value(cur);
      addOp(cur, 'ObjectSet');
    }
  };
}

function getGlobalVariableAccessor(cur: Cursor, variable: GlobalVariable): ValueAccessor {
  return {
    load(cur: Cursor) {
      addOp(cur, 'LoadGlobal', nameOperand(variable.id));
    },
    store(cur: Cursor, value: LazyValue) {
      if (variable.readonly) {
        return compileError(cur, 'Cannot assign to constant');
      }
      variable.used = true;
      value(cur);
      addOp(cur, 'StoreGlobal', nameOperand(variable.id));
    }
  }
}

function getModuleVariableAccessor(cur: Cursor, variable: ModuleVariable): ValueAccessor {
  // Exported variables are accessed as properties on the module object
  if (variable.exported) {
    const moduleScope = cur.ctx.moduleScope;
    const moduleObject = getModuleVariableAccessor(cur, moduleScope.moduleObject);
    const propName = variable.id;
    const property: LazyValue = cur => addOp(cur, 'Literal', literalOperand(propName));
    return getObjectMemberAccessor(cur, moduleObject.load, property);
  } else {
    return {
      load(cur: Cursor) {
        addOp(cur, 'LoadGlobal', nameOperand(variable.id));
      },
      store(cur: Cursor, value: LazyValue) {
        if (variable.readonly) {
          return compileError(cur, 'Cannot assign to constant');
        }
        value(cur);
        addOp(cur, 'StoreGlobal', nameOperand(variable.id));
      }
    }
  }
}

export function compileUnaryExpression(cur: Cursor, expression: B.UnaryExpression) {
  if (!expression.prefix) {
    return compileError(cur, 'Not supported');
  }
  let unOpCode = getUnOpCode(cur, expression.operator);
  // Special case for negative numbers, we just fold the negative straight into the literal
  if (unOpCode === '-' && expression.argument.type === 'NumericLiteral') {
    return addOp(cur, 'Literal', literalOperand(-expression.argument.value));
  }
  compileExpression(cur, expression.argument);
  addOp(cur, 'UnOp', opOperand(unOpCode));
}

function getUnOpCode(cur: Cursor, operator: B.UnaryExpression['operator']) {
  if (operator === "typeof" || operator === "void" || operator === "delete") {
    return compileError(cur, `Operator not supported: "${operator}"`);
  }
  return operator;
}

export function compileUpdateExpression(cur: Cursor, expression: B.UpdateExpression) {
  if (expression.argument.type !== 'Identifier') {
    return compileError(cur, `Operator ${expression.operator} can only be used on simple identifiers, as in \`i++\``);
  }

  let updaterOp: Procedure;
  switch (expression.operator) {
    case '++': updaterOp = cur => addOp(cur, 'Incr'); break;
    case '--': updaterOp = cur => addOp(cur, 'Decr'); break;
    default: updaterOp = assertUnreachable(expression.operator);
  }

  const accessor = resolveLValue(cur, expression.argument);
  accessor.load(cur);
  if (expression.prefix) {
    // If used as a prefix operator, the result of the expression is the value *after* we increment it
    updaterOp(cur);
    const indexOfValue = cur.stackDepth - 1;
    const valueToStore: LazyValue = cur => addOp(cur, 'LoadVar', indexOperand(indexOfValue));
    accessor.store(cur, valueToStore);
  } else {
    // If used as a suffix, the result of the expression is the value *before* we increment it
    addOp(cur, 'Dup');
    updaterOp(cur);
    const indexOfValue = cur.stackDepth - 1;
    const valueToStore: LazyValue = cur => addOp(cur, 'LoadVar', indexOperand(indexOfValue));
    accessor.store(cur, valueToStore);
    addOp(cur, 'Pop', countOperand(1));
  }
}

export function compileBinaryExpression(cur: Cursor, expression: B.BinaryExpression) {
  const binOpCode = getBinOpCode(cur, expression.operator);

  // Special form for integer division `x / y | 0`
  if (binOpCode === '|'
    && expression.left.type === 'BinaryExpression'
    && expression.left.operator === '/'
    && expression.right.type === 'NumericLiteral'
    && expression.right.value === 0
  ) {
    compileExpression(cur, expression.left.left);
    compileExpression(cur, expression.left.right);
    addOp(cur, 'BinOp', opOperand('DIVIDE_AND_TRUNC'));
    return;
  }

  compileExpression(cur, expression.left);
  compileExpression(cur, expression.right);
  addOp(cur, 'BinOp', opOperand(binOpCode));
}

function getBinOpCode(cur: Cursor, operator: B.BinaryExpression['operator']): IL.BinOpCode {
  if (operator === 'instanceof' || operator === 'in') {
    return compileError(cur, `Operator not supported: "${operator}"`);
  }
  if (operator === '==') {
    return compileError(cur, 'Use `===` instead of `==`');
  }
  if (operator === '!=') {
    return compileError(cur, 'Use `!==` instead of `!=`');
  }
  return operator;
}

export function compileIdentifier(cur: Cursor, expression: B.Identifier) {
  // Undefined is treated as a special identifier in this language
  if (expression.name === 'undefined') {
    addOp(cur, 'Literal', literalOperand(undefined))
  } else {
    resolveLValue(cur, expression).load(cur);
  }
}

function findVariable(cur: Cursor, identifierName: string): Variable {
  let scope: LocalScope | ModuleScope = cur.scope;
  while (scope.type === 'LocalScope') {
    const localVars = scope.localVariables;
    if ((identifierName in localVars)) {
      return localVars[identifierName];
    }
    scope = scope.parentScope;
  }
  if ((identifierName in scope.moduleVariables)) {
    return scope.moduleVariables[identifierName];
  }
  if ((identifierName in scope.globalVariables)) {
    return scope.globalVariables[identifierName];
  }
  return compileError(cur, `Undefined identifier: "${identifierName}"`);
}

export function compileParam(cur: Cursor, param: B.LVal, index: number) {
  compilingNode(cur, param);
  if (param.type !== 'Identifier') {
    return compileError(cur, 'Only simple parameters are supported.');
  }
  // Parameters can be assigned to, so they are essentially variables. The
  // number of parameters does not necessarily match the number of arguments
  // provided at runtime, so we can't use the arguments as these parameters.
  const paramVariableIndex = cur.stackDepth;
  addOp(cur, 'LoadArg', indexOperand(index));
  const paramName = param.name;
  const vars = cur.scope.localVariables;
  if (paramName in vars) {
    return compileError(cur, `Duplicate identifier: "${paramName}"`);
  }
  vars[paramName] = {
    type: 'LocalVariable',
    index: paramVariableIndex,
    readonly: false
  };
}

export function compilingNode(cur: Cursor, node: B.Node) {
  if (node.leadingComments) {
    for (const comment of node.leadingComments) {
      addCommentToNextOp(cur, comment.value.trim());
    }
  }
  cur.node = node;
  cur.sourceLoc = notNull(node.loc).start;
}

function addCommentToNextOp(cur: Cursor, comment: string) {
  if (!cur.commentNext) {
    cur.commentNext = [];
  }
  cur.commentNext.push(comment);
}

export function compileVariableDeclaration(cur: Cursor, decl: B.VariableDeclaration) {
  const scope = cur.scope;
  for (const d of decl.declarations) {
    compilingNode(cur, d);
    if (d.id.type !== 'Identifier') {
      return compileError(cur, 'Only simple variable declarations are supported.')
    }
    const variableIndex = cur.stackDepth;
    if (d.init) {
      // Variables are just slots on the stack. When the expression is
      // evaluated, it will "leave behind" this slot.
      compileExpression(cur, d.init);
    } else {
      // No initializer, to put `undefined` on the stack as a placeholder for
      // the variable.
      addOp(cur, 'Literal', literalOperand(undefined));
    }
    const variableName = d.id.name;
    if (!isNameString(variableName)) {
      return compileError(cur, `Invalid variable identifier: "${variableName}"`);
    }
    const variables = scope.localVariables;
    if (variableName in variables) {
      return compileError(cur, `Duplicate variable declaration: "${variableName}"`)
    }
    variables[variableName] = {
      type: 'LocalVariable',
      index: variableIndex,
      readonly: decl.kind === 'const'
    };
  }
}

function allocateVariable(cur: Cursor, variableName: string) {
  cur.stackDepth
}

function startScope(cur: Cursor) {
  const scope: LocalScope = {
    type: 'LocalScope',
    localVariables: Object.create(null),
    parentScope: cur.scope
  };
  const origScope = cur.scope;
  cur.scope = scope;
  const stackDepthAtStart = cur.stackDepth;
  return {
    endScope() {
      // Variables can be declared during the block. We need to clean them off the stack
      const variableCount = Object.keys(scope.localVariables).length;
      // We expect the stack to have grown by the number of variables added
      if (cur.stackDepth - stackDepthAtStart !== variableCount) {
        return unexpected('Stack unbalanced');
      }
      if (variableCount > 0) {
        addOp(cur, 'Pop', countOperand(variableCount));
      }
      cur.scope = origScope;
    }
  };
}

function isModuleVariable(variable: Variable): variable is ModuleVariable {
  return variable.type === 'ModuleVariable';
}

function computeMaximumStackDepth(func: IL.Function) {
  let maxStackDepth = 0;
  for (const [_blockID, block] of entries(func.blocks)) {
    for (const op of block.operations) {
      if (op.stackDepthBefore > maxStackDepth) maxStackDepth = op.stackDepthBefore;
      if (op.stackDepthAfter > maxStackDepth) maxStackDepth = op.stackDepthAfter;
    }
  }
  func.maxStackDepth = maxStackDepth;
}

function compileNopSpecialForm(cur: Cursor, statement: B.Statement): boolean {
  if (statement.type !== 'ExpressionStatement') return false;
  const expression = statement.expression;
  if (expression.type !== 'CallExpression') return false;
  const callee = expression.callee;
  const args = expression.arguments;
  if (callee.type != 'Identifier') return false;
  if (callee.name !== '$$InternalNOPInstruction') return false;
  if (args.length !== 1) return false;
  const sizeArg = args[0];
  if (sizeArg.type !== 'NumericLiteral') return false;
  if (args.length !== 1) return false;
  const nopSize = sizeArg.value;
  if (!isUInt16(nopSize) || nopSize < 2) {
    return compileError(cur, 'Invalid NOP size: ' + nopSize);
  }
  addOp(cur, 'Nop', countOperand(nopSize));
  return true;
}