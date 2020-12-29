import * as babylon from '@babel/parser';
import * as B from '@babel/types';
import * as IL from './il';
import { unexpected, assertUnreachable, invalidOperation, hardAssert, isNameString, entries, stringifyIdentifier, notUndefined, notNull, notImplemented, CompileError, MicroviumSyntaxError, uniqueName } from './utils';
import { isUInt16 } from './runtime-types';
import { ModuleSpecifier } from '../lib';
import { noCase } from "no-case";
import { minOperandCount } from './il-opcodes';

const outputStackDepthComments = false;

// Emits code that pushes a value to the stack
type LazyValue = (cur: Cursor) => void;
type Procedure = (cur: Cursor) => void;

type SupportedStatement =
  | B.IfStatement
  | B.BlockStatement
  | B.ExpressionStatement
  | B.WhileStatement
  | B.DoWhileStatement
  | B.VariableDeclaration
  | B.ForStatement
  | B.ReturnStatement
  | B.FunctionDeclaration
  | B.ExportNamedDeclaration
  | B.SwitchStatement
  | B.BreakStatement
  | SupportedLoopStatement

type SupportedLoopStatement =
  | B.WhileStatement
  | B.DoWhileStatement
  | B.ForStatement

type SupportedModuleStatement =
  | SupportedStatement
  | B.ImportDeclaration

type SupportedExpression =
  | B.BooleanLiteral
  | B.NumericLiteral
  | B.StringLiteral
  | B.NullLiteral
  | B.Identifier
  | B.BinaryExpression
  | B.UpdateExpression
  | B.UnaryExpression
  | B.AssignmentExpression
  | B.LogicalExpression
  | B.CallExpression
  | B.MemberExpression
  | B.ArrayExpression
  | B.ObjectExpression
  | B.ConditionalExpression
  | B.ThisExpression
  | B.ArrowFunctionExpression
  | B.TemplateLiteral

type SupportedNode =
  | B.Program
  | B.VariableDeclarator
  | B.ObjectProperty
  | SupportedModuleStatement
  | SupportedExpression

// The context is state shared between all cursors in the unit. The cursors are
// what's passed around to the code generators, and the context holds shared
// state that can be used from anywhere that has a cursor.
interface Context {
  filename: string;
  nextBlockID: number; // Mutable counter for numbering blocks
  moduleScope: ModuleScope;
  scopeInfo: ScopesInfo;
}

// A variable slot in a scope (VariableScopeInfo)
interface BindingInfo {
  used?: boolean;
  closureAllocated?: boolean;
  // Variable index in the local stack frame or closure (depending on
  // closureAllocated). Note: if the containing `VariableScopeInfo` has
  // `requiresParentSlot`, then the slots are physically shifted right in the
  // closure array to make room for the parent reference, and so a slotIndex of
  // `0` should be treated as an array slot of `1`, etc.
  slotIndex?: number;
}

interface VariableScopeInfo {
  // The 'module' scope is the root scope of the module. 'function' scopes are
  // the root scopes of the respected functions. 'block' scopes are scopes
  // nested in a function or module by the existence of a block
  scopeKind: 'module' | 'function' | 'block';
  // For debug purposes, if the scope is for a function
  _funcName?: string;
  // Variables in the given scope
  bindings: { [name: string]: BindingInfo };
  // The outer scope
  parent?: VariableScopeInfo;
  // Nested scopes in this scope
  children: VariableScopeInfo[];
  // True if the scope info is for a function (see scopeKind) and the function
  // (or a child of the function) references variables from its parent (or
  // parent's parent, etc)
  isClosure?: boolean; // WIP
  // True if the scope info is for a function (see scopeKind) and the function
  // needs a heap-allocated scope for variables shared between the local
  // function and it's child closures
  allocateClosureScope?: boolean; // WIP
  // If allocateClosureScope is true, this will specify the number of variables
  // that must be allocated in the closure scope. This includes variables in
  // nested lexical blocks, and a slot of the `parentReference` (WIP)
  closureVariableCount?: number;
  // For function scopes, this contains information about the reference from the
  // child to the parent scope.
  parentReference: BindingInfo;
  // More for debug purposes, but this is a list of references (identifiers)
  // directly contained within the scope.
  references: VariableReferenceInfo[];
}

interface VariableReferenceInfo {
  // For debug purposes
  _name: string;
  binding: BindingInfo;
  // Note: free variables (globals) do not have a `VariableReferenceInfo`
  referenceKind:
    | 'local'       // Can be local closure or local stack, depending on the binding's closureAllocated flag
    | 'outer-scope' // Variable can be accessed in an outer closure scope
  // If the referenceKind is 'outer-scope', an `outerScopeHops` value of 0
  // indicates the direct parent scope, an `outerScopeHops` value of 1 indicates
  // parent's parent, etc.
  outerScopeHops?: number;
  // The scope in which the variable reference occurs
  nearestScope: VariableScopeInfo;
  // The scope of the variable declaration (an ancestor of the nearestScope)
  targetScope: VariableScopeInfo;
}

type ScopeNode = B.Program | B.FunctionDeclaration | B.ArrowFunctionExpression | B.Block;

interface ScopesInfo {
  scopes: Map<ScopeNode, VariableScopeInfo>;
  references: Map<B.Identifier, VariableReferenceInfo>;
  root: VariableScopeInfo;
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

interface ClosureVariable {
  type: 'ClosureVariable';
  index: number;
}

// Scope of the entry function
// WIP: not used?
interface RootScope {
  type: 'RootScope';
  parentScope: ModuleScope;
  localVariables: { [name: string]: LocalVariable | ClosureVariable };
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

interface BreakScope {
  statement: SupportedLoopStatement | B.SwitchStatement;
  breakToTarget: IL.Block;
  parent: BreakScope | undefined;
}

// Tells us where we're inserting into the IL
interface Cursor {
  ctx: Context;
  // TODO: I think some of this information should possibly be in the Context rather than the Cursor
  scope: LocalScope;
  breakScope: BreakScope | undefined;
  unit: IL.Unit;
  func: IL.Function;
  block: IL.Block;
  node: B.Node;
  stackDepth: number;
  sourceLoc: { filename: string; line: number; column: number; };
  commentNext?: string[];
  unreachable?: true;
}

// The labels pointing to each predeclared block
const predeclaredBlocks = new Map<IL.Block, IL.LabelOperand[]>();

function moveCursor(cur: Cursor, toLocation: Cursor): void {
  Object.assign(cur, toLocation);
}

export function compileScript(filename: string, scriptText: string, globals: string[]): IL.Unit {
  let file: B.File;
  hardAssert(typeof scriptText === 'string');
  try {
    file = babylon.parse(scriptText, {
      sourceType: 'module' ,
      plugins: ['nullishCoalescingOperator', 'numericSeparator']
    });
  } catch (e) {
    if (e.loc) {
      throw new MicroviumSyntaxError(`${
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

  const ctx: Context = {
    filename,
    nextBlockID: 1,
    moduleScope,
    scopeInfo: undefined as any, // Will be filled in at a later pass
  };
  // Local scope for entry function
  const entryFunctionScope: LocalScope = {
    type: 'LocalScope',
    localVariables: Object.create(null),
    parentScope: moduleScope
  }
  const cur: Cursor = {
    ctx,
    sourceLoc: Object.freeze({ filename, line: 0, column: 0 }),
    scope: entryFunctionScope,
    breakScope: undefined,
    stackDepth: 0,
    node: file,
    unit: unit,
    func: unit.functions[unit.entryFunctionID],
    block: entryBlock
  }

  // TODO(closures)
  ctx.scopeInfo = calculateScopes(cur, file);
  // console.log(ctx.scopeInfo.root);

  // This is a bit of a hack. The `compilingNode` function is really only
  // designed to handle a single pass of the AST, since it accumulates comments
  // to append to the next outputted IL instruction. The `calculateScopes`
  // function performs an initial pass, and now we need to reset the state so
  // the last comments from the first pass don't land up on the first statement
  // of the second pass. Since it's only related to commenting, I figure this is
  // a fairly benign hack.
  cur.commentNext = undefined;

  for (const g of globals) {
    if (g in moduleScope.globalVariables) {
      return invalidOperation('Duplicate global');
    }
    moduleScope.globalVariables[g] = { type: 'GlobalVariable', id: g, used: false, readonly: false };
  }

  const moduleVariables = moduleScope.moduleVariables;

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
  // TODO: This doesn't look like it'll find functions in nested lexical blocks
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
    // WIP: I'm confused about this. I would think that local references to
    // local functions (within the module) should be able to directly load a
    // literal reference to the function, rather than accessing through some
    // global variable.
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
  const statement_ = statement as SupportedModuleStatement;
  compilingNode(cur, statement_);
  switch (statement_.type) {
    case 'VariableDeclaration': return compileModuleVariableDeclaration(cur, statement_, false);
    case 'ExportNamedDeclaration': return compileExportNamedDeclaration(cur, statement_);
    case 'ImportDeclaration': return compileImportDeclaration(cur, statement_);
    default:
      // This assignment should give a type error if the above switch hasn't covered all the SupportedModuleStatement cases
      const normalStatement: SupportedStatement = statement_;
      compileStatement(cur, normalStatement);
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
        const imported = specifier.imported;
        if (imported.type !== 'Identifier') {
          return featureNotSupported(cur, 'Expected an identifier');
        }
        const variable: ImportedVariable = {
          type: 'ImportedVariable',
          sourceModuleObjectID: importedModuleVariable.id,
          propertyName: imported.name,
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
  if (!declaration) {
    // Older versions of babel didn't seem to allow for a null declaration, so
    // I'm thinking maybe it's to support a new language feature. I haven't
    // looked into it.
    return featureNotSupported(cur, 'Expected a declaration');
  }
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

// Note: `cur` is the cursor in the parent body (module entry function or parent function)
export function compileFunction(cur: Cursor, func: B.FunctionDeclaration): IL.Function {
  compilingNode(cur, func);

  const entryBlock: IL.Block = {
    id: 'entry',
    expectedStackDepthAtEntry: 0,
    operations: []
  }
  if (!func.id) return unexpected();
  if (!isNameString(func.id.name)) {
    return compileError(cur, `Invalid function identifier: "${func.id.name}`);
  }
  // WIP: when the function value is assigned to the global variable, it's probably not using the right ID anymore
  const id = uniqueName(func.id.name, n => n in cur.unit.functions);

  if (func.generator) {
    return featureNotSupported(cur, `Generators not supported.`);
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
    ctx: cur.ctx,
    sourceLoc: cur.sourceLoc,
    scope: functionScope,
    breakScope: undefined,
    stackDepth: 0,
    node: func.body,
    unit: cur.unit,
    func: funcIL,
    block: entryBlock
  };

  cur.unit.functions[funcIL.id] = funcIL;

  // TODO: Hoisting of variables.
  //
  // Not all variables need to be hoisted. Closure variables are implicitly
  // hoisted because they're all allocated at the same time, but we'll need to
  // implement TDZ behavior at some point. Stack variables only need to be
  // hoisted if there is code that accesses them before the point of
  // declaration. The advantage of not hoisting a variable is that we don't need
  // to separately assign it the value `undefined` and then assign it later in
  // the initializer.

  // Allocate the closure scope
  const scopeInfo = cur.ctx.scopeInfo.scopes.get(func) ?? unexpected();
  hardAssert(scopeInfo.scopeKind === 'function');
  if (scopeInfo.allocateClosureScope) {
    // WIP consolidate this with arrow functions
    const slotCount = scopeInfo.closureVariableCount ?? unexpected();
    const arrayNew = addOp(bodyCur, 'ArrayNew');
    arrayNew.staticInfo = {
      fixedLength: true,
      minCapacity: slotCount,
    };
    // Assign link to parent scope
    if (scopeInfo.referencesParent) {
      compileDup(bodyCur);
      addOp(bodyCur, 'LoadReg', nameOperand('Scope'));
      // The parent reference is stored in slot 0
      addOp(bodyCur, 'ObjectSet', literalOperand(0));
    }
  }

  if (scopeInfo.isClosure) {
    scopeInfo.closureVariableCount
    addOp(cur, 'Literal', literalOperand(undefined)); // scope
    addOp(cur, 'Literal', literalOperand(undefined)); // props
    addOp(cur, 'Literal', literalOperand(undefined)); // this
    addOp(cur, 'ClosureNew', countOperand(4));
    return notImplemented();
  }

  // Nested closures
  for (const nestedFunc of findNestedFunctions(func)) {
    notImplemented();
  }

  // Copy arguments into parameter slots
  for (const [index, param] of func.params.entries()) {
    compileParam(bodyCur, param, index + 1); // +1 to skip over `this` reference
  }

  // Body of function
  for (const statement of func.body.body) {
    compileStatement(bodyCur, statement);
  }

  // Pop parameters off the stack

  addOp(bodyCur, 'Literal', literalOperand(undefined));
  addOp(bodyCur, 'Return');

  computeMaximumStackDepth(funcIL);

  return funcIL;
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
  cur.unreachable = true;
}

export function compileForStatement(cur: Cursor, statement: B.ForStatement): void {
  const loopBlock = predeclareBlock();
  const terminateBlock = predeclareBlock();
  const bodyBlock = predeclareBlock();

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

  pushBreakScope(cur, statement, terminateBlock);

  // Jump into loop from initializer

  addOp(cur, 'Jump', labelOfBlock(loopBlock));
  const loopCur = createBlock(cur, loopBlock);
  if (!statement.test) return unexpected();
  compileExpression(loopCur, statement.test);
  // Branch after test
  addOp(loopCur, 'Branch', labelOfBlock(bodyBlock), labelOfBlock(terminateBlock));

  // Body
  const bodyCur = createBlock(loopCur, bodyBlock);
  compileStatement(bodyCur, statement.body);
  if (!statement.update) return unexpected();
  compileExpression(bodyCur, statement.update);
  addOp(bodyCur, 'Pop', countOperand(1)); // Expression result not used
  // Loop back at end of body
  addOp(bodyCur, 'Jump', labelOfBlock(loopBlock));

  const terminateBlockCur = createBlock(bodyCur, terminateBlock);

  moveCursor(cur, terminateBlockCur);

  popBreakScope(cur, statement);
  scope.endScope();
}

export function compileWhileStatement(cur: Cursor, statement: B.WhileStatement): void {
  const exitBlock = predeclareBlock();
  const testBlock = predeclareBlock();
  const bodyBlock = predeclareBlock();

  pushBreakScope(cur, statement, exitBlock);

  // Jump into loop
  addOp(cur, 'Jump', labelOfBlock(testBlock));

  // Test block
  const testCur = createBlock(cur, testBlock);
  compileExpression(testCur, statement.test);
  addOp(testCur, 'Branch', labelOfBlock(bodyBlock), labelOfBlock(exitBlock));

  // Body block
  const bodyCur = createBlock(cur, bodyBlock);
  compileStatement(bodyCur, statement.body);
  addOp(bodyCur, 'Jump', labelOfBlock(testBlock));

  // Exit block
  const exitCur = createBlock(cur, exitBlock);

  moveCursor(cur, exitCur);
  popBreakScope(cur, statement);
}

export function compileDoWhileStatement(cur: Cursor, statement: B.DoWhileStatement): void {
  const after = predeclareBlock();
  const body = predeclareBlock();

  pushBreakScope(cur, statement, after);

  // Jump into loop
  addOp(cur, 'Jump', labelOfBlock(body));

  // Loop body
  const bodyCur = createBlock(cur, body);
  compileStatement(bodyCur, statement.body);
  compileExpression(bodyCur, statement.test);
  addOp(bodyCur, 'Branch', labelOfBlock(body), labelOfBlock(after));

  // After block
  const afterCur = createBlock(bodyCur, after);

  moveCursor(cur, afterCur);
  popBreakScope(cur, statement);
}

export function compileBlockStatement(cur: Cursor, statement: B.BlockStatement): void {
  // Create a new scope for variables within the block
  const scope = startScope(cur);
  for (const s of statement.body) {
    if (cur.unreachable) break;
    compileStatement(cur, s);
  }
  scope.endScope();
}

export function compileIfStatement(cur: Cursor, statement: B.IfStatement): void {
  if (statement.alternate) {
    const consequent = predeclareBlock();
    const alternate = predeclareBlock();
    const after = predeclareBlock();

    // Test and branch
    compileExpression(cur, statement.test);
    addOp(cur, 'Branch', labelOfBlock(consequent), labelOfBlock(alternate));

    // Consequent block
    const consequentCur = createBlock(cur, consequent);
    compileStatement(consequentCur, statement.consequent);
    addOp(consequentCur, 'Jump', labelOfBlock(after));

    // Alternate block
    const alternateCur = createBlock(cur, alternate);
    compileStatement(alternateCur, statement.alternate);
    addOp(alternateCur, 'Jump', labelOfBlock(after));

    // After block
    const afterCur = createBlock(consequentCur, after);

    moveCursor(cur, afterCur);
  } else {
    const consequent = predeclareBlock();
    const after = predeclareBlock();

    // Test and branch
    compileExpression(cur, statement.test);
    addOp(cur, 'Branch', labelOfBlock(consequent), labelOfBlock(after));

    // Consequent block
    const consequentCur = createBlock(cur, consequent);
    compileStatement(consequentCur, statement.consequent);
    addOp(consequentCur, 'Jump', labelOfBlock(after));

    // After block
    const afterCur = createBlock(cur, after);

    moveCursor(cur, afterCur);
  }
}

/**
 * Pre-declare a block to be created by createBlock. This doesn't return a
 * cursor because you can't append to the block until you properly "create it".
 *
 * The block returned from this is just a placeholder that's suitable for
 * `labelOfBlock`.
 *
 * This is used because the order that we call createBlock affects the order of
 * placement in the bytecode, and we sometimes want to have a forward-reference
 * to a block that we only want to create later.
 *
 * Every call to predeclareBlock should be matched with a corresponding call to
 * createBlock. createBlock will go back and update all the LabelOperands that
 * reference the block.
 */
function predeclareBlock(): IL.Block {
  const block = {} as IL.Block;
  predeclaredBlocks.set(block, []);
  return block;
}

/**
 * Creates a block and returns a cursor at the start of the block
 *
 * @param cur The cursor from which the block follows (typically the cursor just after a branch of jump statement)
 * @param predeclaredBlock Predeclaration of the block (see predeclareBlock)
 */
function createBlock(cur: Cursor, predeclaredBlock: IL.Block): Cursor {
  let block: IL.Block = {
    id: `block${cur.ctx.nextBlockID++}`,
    expectedStackDepthAtEntry: cur.stackDepth,
    operations: []
  };

  if (predeclaredBlock) {
    const dependentLabels = predeclaredBlocks.get(predeclaredBlock) ?? unexpected();
    // Assume the object identity of the predeclaredBlock
    Object.assign(predeclaredBlock, block);
    block = predeclaredBlock;
    // Update all the labels that point to this block
    dependentLabels.forEach(l => l.targetBlockID = block.id);
    predeclaredBlocks.delete(predeclaredBlock);
  }

  if (cur.commentNext) {
    block.comments = cur.commentNext;
    cur.commentNext = undefined;
  }
  cur.func.blocks[block.id] = block;
  const blockCursor: Cursor = {
    sourceLoc: cur.sourceLoc,
    scope: cur.scope,
    breakScope: cur.breakScope,
    ctx: cur.ctx,
    func: cur.func,
    node: cur.node,
    stackDepth: cur.stackDepth,
    unit: cur.unit,
    block
  };
  return blockCursor;
}

function compileError(cur: Cursor, message: string): never {
  if (!cur.node.loc) return unexpected();
  throw new CompileError(`${
    message
  }\n      at ${cur.node.type} (${
    cur.ctx.filename
  }:${
    cur.node.loc.start.line
  }:${
    cur.node.loc.start.column
  })`);
}

function featureNotSupported(cur: Cursor, message: string): never {
  return compileError(cur, message);
}

function compileErrorIfReachable(cur: Cursor, value: never): never {
  const v = value as any;
  const type = typeof v === 'object' && v !== null ? v.type : undefined;
  const message = type ? `Not supported: ${noCase(type)}` : 'Not supported';
  compileError(cur, message);
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

function addOp(cur: Cursor, opcode: IL.Opcode, ...operands: IL.Operand[]): IL.Operation {
  const meta = IL.opcodes[opcode];
  for (const [i, expectedType] of meta.operands.entries()) {
    const operand = operands[i];
    if (!operand && expectedType.endsWith('?')) {
      continue;
    }
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

  if (operands.length < minOperandCount(opcode)) {
    return internalCompileError(cur, `Incorrect number of operands to operation with opcode "${opcode}"`);
  }
  const operation: IL.Operation = {
    opcode,
    operands,
    sourceLoc: cur.sourceLoc,
    stackDepthBefore: cur.stackDepth,
    stackDepthAfter: undefined as any // Assign later
  };
  if (cur.unreachable) return operation; // Don't add to block
  if (outputStackDepthComments) {
    cur.commentNext = [`stackDepth = ${cur.stackDepth}`];
  }
  if (cur.commentNext) {
    operation.comments = cur.commentNext;
    cur.commentNext = undefined;
  }
  cur.block.operations.push(operation);
  const stackChange = IL.calcStaticStackChangeOfOp(operation);
  cur.stackDepth += stackChange;
  operation.stackDepthAfter = cur.stackDepth;

  if (opcode === 'Jump') {
    const target = operation.operands[0];
    if (target.type !== 'LabelOperand') {
      return unexpected();
    }
    // Note: targetBlockID can be undefined if the block is predeclared (see predeclared blocks)
    if (target.targetBlockID) {
      const targetBlock = cur.func.blocks[target.targetBlockID];
      if (targetBlock.expectedStackDepthAtEntry !== operation.stackDepthAfter) {
        return internalCompileError(cur, `Jumping from stack depth of ${operation.stackDepthAfter} to block with stack depth of ${targetBlock.expectedStackDepthAtEntry}`);
      }
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
    // Note: targetBlockID can be undefined if the block is predeclared (see predeclared blocks)
    if (targetTrue.targetBlockID !== undefined) {
      const targetBlockTrue = cur.func.blocks[targetTrue.targetBlockID];
      if (targetBlockTrue.expectedStackDepthAtEntry !== operation.stackDepthAfter) {
        return internalCompileError(cur, `Branching (true branch) from stack depth of ${operation.stackDepthAfter} to block with stack depth of ${targetBlockTrue.expectedStackDepthAtEntry}`);
      }
    }
    if (targetFalse.targetBlockID !== undefined) {
      const targetBlockFalse = cur.func.blocks[targetFalse.targetBlockID];
      if (targetBlockFalse.expectedStackDepthAtEntry !== operation.stackDepthAfter) {
        return internalCompileError(cur, `Branching (false branch) from stack depth of ${operation.stackDepthAfter} to block with stack depth of ${targetBlockFalse.expectedStackDepthAtEntry}`);
      }
    }
  }

  return operation;
}

function labelOfBlock(block: IL.Block): IL.LabelOperand {
  const labelOperand: IL.LabelOperand = {
    type: 'LabelOperand',
    // Note: ID can be undefined here if if the block is predeclared. It would
    // then be filled out later when createBlock is called.
    targetBlockID: block.id
  };
  const predeclaredBlockLabels = predeclaredBlocks.get(block);
  if (predeclaredBlockLabels) {
    predeclaredBlockLabels.push(labelOperand)
  }
  return labelOperand;
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

function opOperand(subOperation: IL.BinOpCode | IL.UnOpCode): IL.OpOperand {
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

export function compileStatement(cur: Cursor, statement_: B.Statement) {
  if (cur.unreachable) return;

  const statement = statement_ as SupportedStatement;

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
    case 'SwitchStatement': return compileSwitchStatement(cur, statement);
    case 'BreakStatement': return compileBreakStatement(cur, statement);
    case 'FunctionDeclaration': return; // Function declarations are hoisted
    case 'ExportNamedDeclaration': return notImplemented(); // Need to look into what to do here
    default: return compileErrorIfReachable(cur, statement);
  }
}

export function compileBreakStatement(cur: Cursor, expression: B.BreakStatement) {
  if (expression.label) {
    return compileError(cur, 'Not supported: labelled break statement')
  }
  const breakScope = cur.breakScope;
  if (!breakScope) {
    return compileError(cur, 'No valid break target identified')
  }
  hardAssert(breakScope.breakToTarget);
  addOp(cur, 'Jump', labelOfBlock(breakScope.breakToTarget));
}

function pushBreakScope(cur: Cursor, statement: SupportedLoopStatement | B.SwitchStatement, breakToTarget: IL.Block): BreakScope {
  const breakScope: BreakScope = {
    breakToTarget,
    parent: cur.breakScope,
    statement
  };
  cur.breakScope = breakScope;
  return breakScope;
}

function popBreakScope(cur: Cursor, statement: SupportedLoopStatement | B.SwitchStatement) {
  if (!cur.breakScope) return unexpected();
  hardAssert(cur.breakScope.statement === statement);
  cur.breakScope = cur.breakScope.parent;
}

export function compileSwitchStatement(cur: Cursor, statement: B.SwitchStatement) {

  // Predeclarations for all the blocks
  const testBlocks = statement.cases.map(predeclareBlock);
  const consequentBlocks = statement.cases.map(predeclareBlock);
  const breakBlock = predeclareBlock();

  compileExpression(cur, statement.discriminant);

  // While in the switch statement, `break` statements go to the break block
  pushBreakScope(cur, statement, breakBlock);

  // Jump to first test block
  const firstBlock = testBlocks[0] ?? breakBlock;
  addOp(cur, 'Jump', labelOfBlock(firstBlock));

  let testBlockNum = 0;
  let consequentIndex = 0;
  let generatedDefaultCase = false;
  let generateDefaultCase: (() => void) | undefined;

  // Loop through all the tests first. I'm laying down the blocks basically in
  // the order I want them in ROM
  for (const switchCase of statement.cases) {
    const { test } = switchCase;
    const consequentBlock = consequentBlocks[consequentIndex];

    // Note: the test will be null if this is a "default" case
    if (test) {
      const thisTestCur = createBlock(cur, testBlocks[testBlockNum]);
      const nextTestBlock = testBlocks[testBlockNum + 1] ?? breakBlock;

      // Perform the test on a duplicate of the discriminant
      compileDup(thisTestCur);
      compileExpression(thisTestCur, test);
      addOp(thisTestCur, 'BinOp', opOperand('==='));
      addOp(thisTestCur, 'Branch', labelOfBlock(consequentBlock), labelOfBlock(nextTestBlock));

      testBlockNum++;
    } else {
      // If there's an existing default case it's a compile error (I'm not sure
      // if Babel already filters this case)
      if (generatedDefaultCase) {
        compilingNode(cur, switchCase);
        return compileError(cur, 'Duplicate `default` block in switch statement');
      }
      generatedDefaultCase = true;

      // We only generate the default case at the end, just because I want to
      // keep the blocks in the order in which they're executed.
      generateDefaultCase = () => {
        // If there is a default case, it needs to be tested last
        const thisTestCur = createBlock(cur, testBlocks[testBlocks.length - 1]);

        // Unconditional branch to consequent
        addOp(thisTestCur, 'Jump', labelOfBlock(consequentBlock));
      }
    }
    consequentIndex++;
  }

  generateDefaultCase && generateDefaultCase();

  // Loop through all the consequents
  consequentIndex = 0;
  for (const { consequent } of statement.cases) {
    const consequentBlockCur = createBlock(cur, consequentBlocks[consequentIndex]);

    for (const statement of consequent) {
      compileStatement(consequentBlockCur, statement);
    }

    // Fall through from one consequent to the next or break out of the switch
    const nextConsequentBlock = consequentBlocks[consequentIndex + 1] ?? breakBlock;
    addOp(consequentBlockCur, 'Jump', labelOfBlock(nextConsequentBlock));

    consequentIndex++;
  }

  // The break block needs to perform the matching `pop` of the original test
  // value. This can't be done in the consequents because each falls into the
  // next (and it would be more instructions)
  const breakBlockCur = createBlock(cur, breakBlock);
  addOp(breakBlockCur, 'Pop', countOperand(1));

  moveCursor(cur, breakBlockCur);
  popBreakScope(cur, statement);
}

export function compileExpression(cur: Cursor, expression_: B.Expression | B.PrivateName) {
  if (cur.unreachable) return;
  const expression = expression_ as SupportedExpression;

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
    case 'ThisExpression': return compileThisExpression(cur, expression);
    case 'ArrowFunctionExpression': return compileArrowFunctionExpression(cur, expression);
    case 'TemplateLiteral': return compileTemplateLiteral(cur, expression);
    default: return compileErrorIfReachable(cur, expression);
  }
}

export function compileTemplateLiteral(cur: Cursor, expression: B.TemplateLiteral) {
  /*
  This is for a plain template literal, without the tag. For example
  `abc${expr}xyz`.

  Basically I treat this as equivalent to a series of string concatenations.
  */

  // The quasis seems to be the string parts
  // I don't know under what circumstances the `cooked` field will not be populated
  const strings = expression.quasis.map(s => s.value.cooked ?? unexpected());
  const expressions = expression.expressions;

  // I think there will always be one more string literal than expression.
  if (strings.length !== expressions.length + 1)
    unexpected();

  // I think there will always be at least one string part
  const firstString = strings[0] ?? unexpected();
  addOp(cur, 'Literal', literalOperand(firstString));

  for (let i = 0; i < expressions.length; i++) {
    const expression = expressions[i];
    // I don't know why these TSTypes would be valid "expressions"
    if (B.isTSType(expression)) {
      return featureNotSupported(cur, 'Expected expression');
    }
    compileExpression(cur, expression);
    addOp(cur, 'BinOp', opOperand('+'));

    const s = strings[i + 1];
    if (s !== undefined && s !== '') {
      addOp(cur, 'Literal', literalOperand(s));
      addOp(cur, 'BinOp', opOperand('+'));
    }
  }
}

export function compileArrowFunctionExpression(cur: Cursor, expression: B.ArrowFunctionExpression) {
  // Arrow functions are not hoisted, so they're instantiated when the
  // expression is encountered.

  // Push reference to target
  addOp(cur, 'Literal', {
    type: 'LiteralOperand',
    literal: {
      type: 'FunctionValue',
      value: functionID
    }
  });


  return notImplemented();
}

export function compileThisExpression(cur: Cursor, expression: B.ThisExpression) {
  // The first argument is the `this` argument
  addOp(cur, 'LoadArg', indexOperand(0));
}

export function compileConditionalExpression(cur: Cursor, expression: B.ConditionalExpression) {
  const consequent = predeclareBlock();
  const alternate = predeclareBlock();
  const after = predeclareBlock();

  // Expression leaves the test result at the top of the stack
  compileExpression(cur, expression.test);
  addOp(cur, 'Branch', labelOfBlock(consequent), labelOfBlock(alternate));

  // The -1 is because the branch instruction pops a value off the stack
  const consequentCur = createBlock(cur, consequent);
  compileExpression(consequentCur, expression.consequent);
  addOp(consequentCur, 'Jump', labelOfBlock(after));

  const alternateCur = createBlock(cur, alternate);
  compileExpression(alternateCur, expression.alternate);
  addOp(alternateCur, 'Jump', labelOfBlock(after));

  // The stack depth is the same as when we have the "test" result on the stack,
  // because the consequent and alternate paths both pop the test and push the
  // result.
  const afterCur = createBlock(alternateCur, after);

  moveCursor(cur, afterCur);
}

export function compileArrayExpression(cur: Cursor, expression: B.ArrayExpression) {
  const indexOfArrayInstance = cur.stackDepth;
  const op = addOp(cur, 'ArrayNew');
  op.staticInfo = {
    minCapacity: expression.elements.length
  };
  let endsInElision = false;
  for (const [i, element] of expression.elements.entries()) {
    if (!element) {
      endsInElision = true;
      // Missing elements are just elisions. It's safe not to assign them
      continue;
    }
    endsInElision = false;
    if (element.type === 'SpreadElement') {
      return compileError(cur, 'Spread syntax not supported');
    }
    addOp(cur, 'LoadVar', indexOperand(indexOfArrayInstance));
    addOp(cur, 'Literal', literalOperand(i));
    compileExpression(cur, element);
    addOp(cur, 'ObjectSet');
  }
  // If the array literal ends in an elision, then we need to update the length
  // manually.
  if (endsInElision) {
    addOp(cur, 'LoadVar', indexOperand(indexOfArrayInstance));
    addOp(cur, 'Literal', literalOperand('length'));
    addOp(cur, 'Literal', literalOperand(expression.elements.length));
    addOp(cur, 'ObjectSet');
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
  if (expression.computed) { // Like `array[index]`

    const property = expression.property;
    if (property.type === 'PrivateName')
      return featureNotSupported(cur, 'Private names not supported')
    compileExpression(cur, property);
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
  // Where to put the result of the call
  const indexOfResult = cur.stackDepth;

  if (callee.type === 'MemberExpression' && !callee.computed) {
    const indexOfObjectReference = cur.stackDepth;
    compileExpression(cur, callee.object); // The first IL parameter is the object instance
    // Fetch the property on the object that represents the function to be called
    compileDup(cur);
    const property = callee.property;
    // Since the callee property is not computed, I expect it to be an identifier
    if (property.type !== 'Identifier')
      return unexpected('Expected an identifier');
    addOp(cur, 'Literal', literalOperand(property.name));
    addOp(cur, 'ObjectGet');
    // Awkwardly, the `this` reference must be the first paramter, which must
    // come after the function reference
    addOp(cur, 'LoadVar', indexOperand(indexOfObjectReference));
  } else {
    if (!B.isExpression(callee)) return unexpected();
    compileExpression(cur, callee);
    addOp(cur, 'Literal', literalOperand(undefined)); // Object reference is "undefined" if it's not a method call
  }

  for (const arg of expression.arguments) {
    compilingNode(cur, arg);
    if (arg.type === 'SpreadElement') {
      return compileError(cur, 'Unsupported syntax');
    }
    if (!B.isExpression(arg)) return unexpected();
    compileExpression(cur, arg);
  }

  addOp(cur, 'Call', countOperand(expression.arguments.length + 1)); // +1 is for the object reference

  if (cur.stackDepth > indexOfResult + 1) {
    // Some things need to be popped off the stack, but we need the result to be underneath them
    addOp(cur, 'StoreVar', indexOperand(indexOfResult));
    const remainingToPop = cur.stackDepth - (indexOfResult + 1);
    if (remainingToPop) {
      addOp(cur, 'Pop', countOperand(remainingToPop));
    }
  }
}

function compileDup(cur: Cursor) {
  addOp(cur, 'LoadVar', indexOperand(cur.stackDepth - 1));
}

export function compileLogicalExpression(cur: Cursor, expression: B.LogicalExpression) {
  if (expression.operator === '&&' || expression.operator === '||') {
    const rightBlock = predeclareBlock();
    const endBlock = predeclareBlock();

    compileExpression(cur, expression.left);
    compileDup(cur);
    if (expression.operator === '&&') {
      // Short circuit && -- if left is truthy, result is right, else result is left
      addOp(cur, 'Branch', labelOfBlock(rightBlock), labelOfBlock(endBlock));
    } else {
      // Short circuit || -- if left is truthy, result is left, else result is right
      addOp(cur, 'Branch', labelOfBlock(endBlock), labelOfBlock(rightBlock));
    }

    const rightCur = createBlock(cur, rightBlock);
    // If we get as far as evaluating the right, it means the result is not the
    // left, so pop the duplicate-left-value off the stack
    addOp(rightCur, 'Pop', countOperand(1));
    compileExpression(rightCur, expression.right);
    addOp(rightCur, 'Jump', labelOfBlock(endBlock));

    const endCur = createBlock(rightCur, endBlock);

    moveCursor(cur, endCur);
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

function getUnOpCode(cur: Cursor, operator: B.UnaryExpression['operator']): IL.UnOpCode {
  if (operator === "typeof" || operator === "void" || operator === "delete" || operator === "throw") {
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
    case '++': updaterOp = cur => compileIncr(cur); break;
    case '--': updaterOp = cur => compileDecr(cur); break;
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
    compileDup(cur);
    updaterOp(cur);
    const indexOfValue = cur.stackDepth - 1;
    const valueToStore: LazyValue = cur => addOp(cur, 'LoadVar', indexOperand(indexOfValue));
    accessor.store(cur, valueToStore);
    addOp(cur, 'Pop', countOperand(1));
  }
}

function compileIncr(cur: Cursor) {
  // Note: this is not the JS ++ operator, it's just a sequence of operations
  // that increments the slot at the top of the stack
  addOp(cur, 'Literal', literalOperand(1));
  addOp(cur, 'BinOp', opOperand('+'));
}

function compileDecr(cur: Cursor) {
  // Note: this is not the JS ++ operator, it's just a sequence of operations
  // that decrements the slot at the top of the stack
  addOp(cur, 'Literal', literalOperand(1));
  addOp(cur, 'BinOp', opOperand('-'));
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
  // Note: there can be multiple nodes that precede the generation of an
  // instruction, and this just uses the comment from the last node, which seems
  // "good enough"
  if (node.leadingComments) {
    cur.commentNext = node.leadingComments.map(c => c.value.trim());
  }
  cur.node = node;
  cur.sourceLoc = Object.freeze({
    filename: cur.sourceLoc.filename,
    ...notNull(node.loc).start
  });
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
      if (!cur.unreachable) {
        // Variables can be declared during the block. We need to clean them off the stack
        const variableCount = Object.keys(scope.localVariables).length;
        // We expect the stack to have grown by the number of variables added
        if (cur.stackDepth - stackDepthAtStart !== variableCount) {
          return unexpected('Stack unbalanced');
        }
        if (variableCount > 0) {
          addOp(cur, 'Pop', countOperand(variableCount));
        }
      }
      cur.scope = origScope;
    }
  };
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

function* findNestedFunctions(func: B.FunctionDeclaration) {
  yield* findInBlock(func.body);

  function* findInBlock(block: B.BlockStatement): IterableIterator<B.FunctionDeclaration> {
    for (const statement of block.body) {
      yield* findInStatement(statement);
    }
  }

  function* findInStatement(statement: B.Statement): IterableIterator<B.FunctionDeclaration> {
    switch (statement.type) {
      case 'FunctionDeclaration': yield statement; break;
      case 'BlockStatement': yield* findInBlock(statement); break;
      case 'IfStatement':
        yield* findInStatement(statement.consequent);
        if (statement.alternate)
          yield* findInStatement(statement.alternate);
        break;
      case 'WhileStatement':
      case 'ForInStatement':
      case 'ForOfStatement':
      case 'DoWhileStatement':
        yield* findInStatement(statement.body);
        break;
      case 'TryStatement':
        yield* findInStatement(statement.block);
        if (statement.handler) yield* findInStatement(statement.handler.body);
        if (statement.finalizer) yield* findInStatement(statement.finalizer);
        break;
    }
  }
}

function calculateScopes(cur: Cursor, file: B.File): ScopesInfo {
  /*
  This function does scope analysis for the purpose of generating closures.

    - Calculates lexical scope hierarchy (ScopesInfo.scopes)
    - Finds the variables in each scope (VariableScopeInfo.bindings)
    - For function-level scopes, it calculates:
      - Whether the function needs a closure (VariableScopeInfo.allocateClosure)
      - How many closure-allocated variables are required (VariableScopeInfo.closureVariableCount)
      - Whether the closure needs a reference to the parent closure (VariableScopeInfo.requiresParentSlot)
    - For each variable reference, it calculates the "path" to its slot, either local or in some linked closure

  */

  const scopes = new Map<ScopeNode, VariableScopeInfo>();
  const references = new Map<B.Identifier, VariableReferenceInfo>();
  const scopeStack: VariableScopeInfo[] = [];
  const currentScope = () => notUndefined(scopeStack[scopeStack.length - 1]);

  detectClosures(file.program);
  const root = scopes.get(file.program) || unexpected();

  computeSlots();
  computeHops();

  return {
    scopes,
    references,
    root
  };

  function computeSlots() {
    /*
    This function calculates the size of each closure allocation, and the index
    of each variable in the closure
    */

    hardAssert(root.scopeKind === 'module');
    for (const child of root.children) {
      if (child.scopeKind === 'function') {
        computeFunctionSlots(child);
      }
    }

    function computeFunctionSlots(scope: VariableScopeInfo) {
      hardAssert(scope.scopeKind === 'function');
      scope.closureVariableCount = computeBlockSlots(scope, 0, 0);
    }

    function computeBlockSlots(scope: VariableScopeInfo, heapVariableIndex: number, stackVariableIndex: number): number {
      hardAssert(scope.scopeKind === 'block' || scope.scopeKind === 'function');

      for (const binding of Object.values(scope.bindings)) {
        if (binding.closureAllocated) {
          binding.slotIndex = heapVariableIndex++;
        } else {
          binding.slotIndex = stackVariableIndex++;
        }
      }

      let closureVariableCount = heapVariableIndex;

      for (const child of scope.children) {
        if (child.scopeKind === 'function') {
          computeFunctionSlots(child);
        } else {
          closureVariableCount = Math.max(closureVariableCount, computeBlockSlots(child, heapVariableIndex, stackVariableIndex));
        }
      }

      return closureVariableCount;
    }
  }

  function computeHops() {
    // This function computes the number of closure hops required to get to the
    // value of a variable. This should correspond to the number of `ArrayGet`
    // instructions to emit to get the parent scope from the current scope.
    for (const reference of references.values()) {
      if (reference.referenceKind === 'outer-scope') {
        const { nearestScope, targetScope } = reference;
        let scope = nearestScope;
        let hops = 0;
        while (scope !== targetScope) {
          if (scope.allocateClosureScope) {
            // In order for us to hop from the child to the parent, we'll need
            // to have a reference to the parent at runtime.
            scope.referencesParent = true;
            hops++;
          }
          scope = scope.parent || unexpected();
        }
        reference.outerScopeHops = hops;
      }
    }
  }

  function createBinding(name: string, isLexical: boolean) {
    const scope = currentScope();
    const bindings = scope.bindings;
    if (isLexical && name in bindings) {
      return compileError(cur, `Variable "${name}" already declared in scope`)
    }
    bindings[name] = {};
  }

  function createParameterBindings(params: (B.FunctionDeclaration | B.ArrowFunctionExpression)['params']) {
    for (const param of params) {
      if (param.type !== 'Identifier')
        return compileError(cur, 'Not supported');
      createBinding(param.name, false);
    }
  }

  // This is the function used to iterate the AST
  function detectClosures(node_: B.Node): void {
    const node = node_ as B.Program | SupportedStatement | SupportedExpression;
    compilingNode(cur, node);
    switch (node.type) {
      case 'Program': {
        const scope = pushScope(node, 'module');
        const statements = node.body;

        for (const statement of statements) {
          findHoistedVariables(statement);
        }

        // Lexical variables are also found upfront because nested functions can
        // reference variables that are declared further down than the nested
        // function (TDZ). (But `findLexicalVariables` isn't recursive)
        findLexicalVariables(statements);

        // Iterate through the function/program body to find variable usage
        for (const statement of statements) {
          detectClosures(statement);
        }

        popScope(scope);
        break;
      }
      case 'FunctionDeclaration': {
        const scope = pushScope(node, 'function');
        scope._funcName = node.id?.name;
        createParameterBindings(node.params);
        const statements = node.body.body;

        statements.forEach(findHoistedVariables);

        // Lexical variables are also found upfront because nested functions can
        // reference variables that are declared further down than the nested
        // function (TDZ). (But `findLexicalVariables` isn't recursive)
        findLexicalVariables(statements);

        // Iterate through the body to find variable usage
        statements.forEach(detectClosures);

        popScope(scope);
        break;
      }
      case 'ArrowFunctionExpression': {
        const scope = pushScope(node, 'function');
        createParameterBindings(node.params);
        const body = node.body;

        if (body.type === 'BlockStatement') {
          const statements = body.body;
          statements.forEach(findHoistedVariables);

          // Lexical variables are also found upfront because nested functions can
          // reference variables that are declared further down than the nested
          // function (TDZ). (But `findLexicalVariables` isn't recursive)
          findLexicalVariables(statements);

          statements.forEach(detectClosures);
        } else {
          /* Note: Arrow functions with expression bodies do not have any hoisted variables */
          detectClosures(body);
        }

        popScope(scope);
        break;
      }
      case 'BlockStatement': {
        // Creates a lexical scope
        const scope = pushScope(node, 'block');
        // Here we don't need to populate the hoisted variables because they're
        // already populated by the containing function/program
        findLexicalVariables(node.body);
        for (const statement of node.body) {
          detectClosures(statement);
        }
        popScope(scope);
        break;
      }
      case 'Identifier': {
        // Note: identifiers here are always variable references. See
        // description of traverseAST.
        const variableName = node.name;
        // We loop through the scope stack backwards, starting at inner-most and
        // going outward. Some scope layers are created by nested blocks within
        // a function, so we're not necessarily leaving the local function when
        // we traverse to the outer lexical scope.
        let isInLocalFunction = true;
        let isFreeVariable = true;
        // Look for the variable
        for (let i = scopeStack.length - 1; i >= 0; i--) {
          const scope = scopeStack[i];
          const binding = scope.bindings[variableName];
          if (binding) {
            binding.used = true;
            if (!isInLocalFunction && scope.scopeKind !== 'module') {
              binding.closureAllocated = true;
              scope.allocateClosureScope = true;
            }
            const reference: VariableReferenceInfo = {
              _name: variableName,
              binding,
              referenceKind: isInLocalFunction ? 'local' : 'outer-scope',
              nearestScope: currentScope(),
              targetScope: scope
            };
            references.set(node, reference);
            currentScope().references.push(reference);
            isFreeVariable = false;
            break;
          }
          if (scope.scopeKind === 'function') {
            // After this point, the variable is not in the local function
            isInLocalFunction = false;
          }
        }
        break;
      }
      default:
        traverseAST(cur, node, detectClosures);
    }
  }

  function pushScope(node: ScopeNode, scopeKind: VariableScopeInfo['scopeKind']): VariableScopeInfo {
    const parent = scopeStack[scopeStack.length - 1]; // Can be undefined
    const scope: VariableScopeInfo = {
      bindings: Object.create(null),
      scopeKind,
      children: [],
      parent,
      references: []
    };
    scopes.set(node, scope);
    parent && parent.children.push(scope);
    scopeStack.push(scope);
    return scope;
  }

  function popScope(scope: VariableScopeInfo) {
    hardAssert(scopeStack[scopeStack.length - 1] === scope);
    scopeStack.pop();
  }

  // This function looks for var and function declarations for a variable scope
  // (program- or function-level)
  function findHoistedVariables(statement: B.Statement) {
    switch (statement.type) {
      case 'VariableDeclaration': {
        if (statement.kind === 'var') {
          for (const declaration of statement.declarations) {
            const id = declaration.id;
            if (id.type !== 'Identifier') {
              compilingNode(cur, id);
              compileError(cur, 'Syntax not supported')
            }
            const name = id.name;
            createBinding(name, false);
          }
        }
        break;
      }
      case 'FunctionDeclaration': {
        if (statement.id) {
          const id = statement.id;
          const name = id.name;
          createBinding(name, false);
        }
        break;
      }
      case 'BlockStatement': {
        for (const s of statement.body) {
          findHoistedVariables(s);
        }
        break;
      }
      case 'ExportNamedDeclaration': {
        findHoistedVariables(statement.declaration ?? unexpected());
        break;
      }
    }
  }

  // This function looks for let and const declarations for lexical scope. It
  // does not look recursively because these kinds of declarations are not
  // hoisted out of nested blocks.
  function findLexicalVariables(statements: B.Statement[]) {
    for (const statement of statements) {
      if (statement.type === 'VariableDeclaration' && statement.kind !== 'var') {
        for (const declaration of statement.declarations) {
          const id = declaration.id;
          if (id.type !== 'Identifier') {
            compilingNode(cur, id);
            compileError(cur, 'Syntax not supported')
          }
          const name = id.name;
          createBinding(name, true);
        }
      }
    }
  }
}

/*
 * I tried using `@babel/traverse` but I find that the type signatures are not
 * strong enough to do what I want to do, and it seemed not to give much control
 * over whether to iterate deeper or not at any particular node. This
 * `traverseAST` function is my solution. It's a function which simply calls the
 * callback for each child of the given node. It's not recursive -- it requires
 * that the callback call traverseAST if it wishes to traverse deeper. This
 * gives full control to the callback about when to traverse vs when to override
 * the traversal with custom behavior.
 *
 * The intended way to use this is for the callback to be a function with a
 * switch statement to define special handling for chosen node types, and then a
 * `default` path that calls traverseAST.
 *
 * The cursor is just used for reporting errors.
 *
 * Note: In the case of identifiers, this function only calls `f` if the
 * identifer is a variable reference. For example, in the member expression
 * `o.p`, `o` is a variable reference, but `p` is not. In `var v`, `v` is not a
 * variable reference -- it is considered part of the variable declaration. The
 * reason for this is so that the tag `Identifier` does not need context to
 * understand.
 */
function traverseAST(cur: Cursor, node: B.Node, f: (node: B.Node) => void) {
  const n = node as SupportedNode;
  compilingNode(cur, node);
  switch (n.type) {
    case 'ArrayExpression': return n.elements.forEach(e => e && f(e));
    case 'AssignmentExpression': return f(n.left), f(n.right);
    case 'BinaryExpression': return f(n.left), f(n.right);
    case 'BlockStatement': return n.body.forEach(f);
    case 'CallExpression': return f(n.callee), n.arguments.forEach(f);
    case 'ConditionalExpression': return f(n.test), f(n.consequent), f(n.alternate);
    case 'DoWhileStatement': return f(n.test), f(n.body);
    case 'ExpressionStatement': return f(n.expression);
    case 'ForStatement': return n.init && f(n.init), n.test && f(n.test), n.update && f(n.update), f(n.body);
    case 'IfStatement': return f(n.test), f(n.consequent), n.alternate && f(n.alternate);
    case 'LogicalExpression': return f(n.left), f(n.right);
    case 'ObjectExpression': return n.properties.forEach(f);
    case 'Program': return n.body.forEach(f);
    case 'ReturnStatement': return n.argument && f(n.argument);
    case 'UnaryExpression': return f(n.argument);
    case 'UpdateExpression': return f(n.argument);
    case 'VariableDeclaration': return n.declarations.forEach(f);
    case 'WhileStatement': return f(n.test), f(n.body);
    case 'ExportNamedDeclaration': return f(n.declaration ?? unexpected());
    case 'ObjectProperty': return (n.computed ? f(n.key) : undefined), f(n.value);
    case 'TemplateLiteral': return n.expressions.forEach(f);

    case 'ImportDeclaration': return;
    case 'Identifier': return;
    case 'StringLiteral': return;
    case 'ThisExpression': return;
    case 'BooleanLiteral': return;
    case 'NullLiteral': return;
    case 'NumericLiteral': return;
    case 'BreakStatement': return;

    case 'SwitchStatement': {
      f(n.discriminant);
      for (const { test, consequent } of n.cases) {
        test && f(test);
        consequent.forEach(f);
      }
      break;
    }

    case 'MemberExpression': {
      f(n.object);
      // Note: if the member access is of the form `o.p` then `p` here is not
      // iterated because the identifier `p` is in the scope of `o`. In the case
      // of `o[p]`, `p` is a variable reference to the corresponding variable in
      // the scope that the expression is executing.
      if (n.computed) {
        f(n.property)
      }
      return;
    }

    case 'VariableDeclarator': {
      // Note: variable IDs are intentionally not iterated, because contexts that
      // use the ID will not be looking to visit "Identifier" nodes but rather
      // just "VariableDeclarator" nodes.
      n.init && f(n.init);
      return;
    }

    case 'ArrowFunctionExpression':
    case 'FunctionDeclaration': {
      for (const param of n.params) {
        if (param.type !== 'Identifier') {
          // Note: for non-identifier parameters, we would need to recurse on
          // the initializers, but no the identifiers (for the same reason as noted above for VariableDeclarator)
          return compileError(cur, 'Not supported');
        }
      }
      return f(n.body);
    }

    default:
      compileErrorIfReachable(cur, n);
  }
}