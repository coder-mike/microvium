import * as babylon from '@babel/parser';
import * as B from './supported-babel-types';
import * as IL from '../il';
import { unexpected, assertUnreachable, hardAssert, isNameString, entries, notUndefined, notImplemented, MicroviumSyntaxError } from '../utils';
import { isUInt16 } from '../runtime-types';
import { minOperandCount } from '../il-opcodes';
import { analyzeScopes, AnalysisModel, SlotAccessInfo, PrologueStep, BlockScope, Scope } from './analyze-scopes';
import { compileError, compileErrorIfReachable, featureNotSupported, internalCompileError, SourceCursor, visitingNode } from './common';

const outputStackDepthComments = false;

type Procedure = (cur: Cursor) => void;

// The context is state shared between all cursors in the unit. The cursors are
// what's passed around to the code generators, and the context holds shared
// state that can be used from anywhere that has a cursor.
interface Context {
  filename: string;
  nextBlockID: number; // Mutable counter for numbering blocks
  scopeAnalysis: AnalysisModel;
}

interface ScopeStack {
  helper: ScopeHelper;
  scope: Scope;
  parent: ScopeStack | undefined;
}

interface Cursor extends SourceCursor {
  ctx: Context;
  breakScope: BreakScope | undefined;
  scopeStack: ScopeStack | undefined;
  unit: IL.Unit;
  func: IL.Function;
  block: IL.Block;
  node: B.Node;
  stackDepth: number;
  commentNext?: string[];
  unreachable?: true;
}

interface ScopeHelper {
  leaveScope(cur: Cursor): void;
}

// Essentially represents an R-Value
interface LazyValue {
  /** Emits code that pushes the value to the stack. Generally only valid within
   * the function in which the LazyValue was created, since the emitted sequence
   * could include references to values on the stack. */
  load(cur: Cursor): void;
}

// Essentially represents an L-Value (i.e. a slot)
interface ValueAccessor extends LazyValue {
  store: (cur: Cursor, value: LazyValue) => void;
}

interface BreakScope {
  statement: B.SupportedLoopStatement | B.SwitchStatement;
  breakToTarget: IL.Block;
  scope: Scope | undefined;
  parent: BreakScope | undefined;
}

// The labels pointing to each predeclared block
const predeclaredBlocks = new WeakMap<IL.Block, IL.LabelOperand[]>();

// There are some syntactic representations that are compiled using a special meaning
const specialForms = new Set(['$$MicroviumNopInstruction']);

function moveCursor(cur: Cursor, toLocation: Cursor): void {
  Object.assign(cur, toLocation);
}

export function compileScript(filename: string, scriptText: string): {
  unit: IL.Unit,
  scopeAnalysis: AnalysisModel
} {
  const file = parseToAst(filename, scriptText);

  const scopeAnalysis = analyzeScopes(file, filename);

  const ctx: Context = {
    filename,
    // Global counter for generating block IDs. I'm not sure why I made this
    // global, but I suspect one advantage is when looking at the IL, it's easy
    // to jump to a label
    nextBlockID: 1,
    scopeAnalysis: scopeAnalysis
  };

  const unit: IL.Unit = {
    sourceFilename: filename,
    functions: { },
    moduleVariables: scopeAnalysis.globalSlots.map(s => s.name),
    freeVariables: [...scopeAnalysis.freeVariables].filter(x => !specialForms.has(x)),
    entryFunctionID: undefined as any, // Filled out later
    moduleImports: Object.create(null),
  };

  const cur: Cursor = {
    ctx,
    filename,
    breakScope: undefined,
    scopeStack: undefined,
    stackDepth: 0,
    node: file,
    unit,
    // This is one of the few places where we're not actually in a function yet
    func: undefined as any,
    block: undefined as any
  }

  // # Imports
  // Note that imports don't require any IL to be emitted (e.g. a `require`
  // call) since the imported modules are just loaded automatically at load
  // time.
  unit.moduleImports = scopeAnalysis.moduleImports.map(({ slot, source }) => ({
    variableName: slot.name,
    specifier: source
  }));

  // Entry function
  const entryFunc = compileEntryFunction(cur, file.program);
  unit.entryFunctionID = entryFunc.id

  // Compile all functions
  for (const func of scopeAnalysis.functions)
    compileFunction(cur, func.node);

  return { unit, scopeAnalysis };
}

// Similar to compileFunction but deals with module-level statements
function compileEntryFunction(cur: Cursor, program: B.Program) {
  const ctx = cur.ctx;
  const funcInfo = ctx.scopeAnalysis.moduleScope;

  const entryFunction: IL.Function = {
    type: 'Function',
    sourceFilename: cur.filename,
    id: '#entry',
    entryBlockID: 'entry',
    maxStackDepth: 0,
    blocks: {}
  };

  cur.unit.functions[entryFunction.id] = entryFunction;

  const entryBlock: IL.Block = {
    id: 'entry',
    expectedStackDepthAtEntry: 0,
    operations: []
  }
  entryFunction.blocks[entryBlock.id] = entryBlock;

  const bodyCur: Cursor = {
    ctx: cur.ctx,
    filename: cur.ctx.filename,
    breakScope: undefined,
    scopeStack: undefined,
    stackDepth: 0,
    node: program,
    unit: cur.unit,
    func: entryFunction,
    block: entryBlock
  };

  // Load module object which is passed as an argument to the entry function
  addOp(bodyCur, 'LoadArg', indexOperand(0));
  addOp(bodyCur, 'StoreGlobal', nameOperand(ctx.scopeAnalysis.thisModuleSlot.name));

  // Note: unlike compileFunction, here we don't need to compile hoisted
  // functions and variable declarations because they're bound to module-level
  // variables which aren't tied to the lifetime of the entry function. This
  // applies even to `let` bindings and bindings in nested blocks.

  compilePrologue(bodyCur, funcInfo.prologue);

  // General root-level code
  for (const statement of program.body) {
    compileModuleStatement(bodyCur, statement);
  }

  addOp(bodyCur, 'Literal', literalOperand(undefined));
  addOp(bodyCur, 'Return');

  computeMaximumStackDepth(entryFunction);

  return entryFunction;
}

export function parseToAst(filename: string, scriptText: string) {
  hardAssert(typeof scriptText === 'string');
  try {
    return babylon.parse(scriptText, {
      sourceType: 'module' ,
      plugins: ['nullishCoalescingOperator', 'numericSeparator']
    });
  } catch (e) {
    throw !e.loc ? e : new MicroviumSyntaxError(`${e.message}\n      at (${filename}:${e.loc.line}:${e.loc.column})`);
  }
}

export function compileModuleStatement(cur: Cursor, statement: B.Statement) {
  const statement_ = statement as B.SupportedModuleStatement;
  compilingNode(cur, statement_);
  switch (statement_.type) {
    case 'VariableDeclaration': return compileModuleVariableDeclaration(cur, statement_, false);
    case 'ExportNamedDeclaration': return compileExportNamedDeclaration(cur, statement_);
    // These are hoisted so they're not compiled here
    case 'ImportDeclaration': return;
    case 'FunctionDeclaration': return;
    default:
      // This assignment should give a type error if the above switch hasn't covered all the SupportedModuleStatement cases
      const normalStatement: B.SupportedStatement = statement_;
      compileStatement(cur, normalStatement);
      break;
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
    /* Functions are hoisted and have a value immediately, so they're
    initialized early in the entry function. */
  } else {
    return compileError(cur, `Not supported: export of ${declaration.type}`);
  }
}

export function compileModuleVariableDeclaration(cur: Cursor, decl: B.VariableDeclaration, exported: boolean) {
  /*
  Example:

      let x = 5;

  These are variable declarations at the root scope of the module, which are
  added to the `Unit.moduleVariables` list (if they're not imported or
  exported).

  */
  for (const d of decl.declarations) {
    compilingNode(cur, d);
    if (d.id.type !== 'Identifier') {
      return compileError(cur, 'Only simple variable declarations are supported.')
    }
    const variableName = d.id.name;
    if (!isNameString(variableName)) {
      return compileError(cur, `Invalid variable identifier: "${variableName}"`);
    }

    const init = d.init;

    const initialValue: LazyValue = init
      ? LazyValue(cur => compileExpression(cur, init))
      : LazyValue(cur => addOp(cur, 'Literal', literalOperand(undefined)));

    const slot = accessVariable(cur, d.id, { forInitialization: true });

    slot.store(cur, initialValue);
  }
}

function LazyValue(load: (cur: Cursor) => void) {
  return { load };
}

// Note: `cur` is the cursor in the parent body (module entry function or parent function)
export function compileFunction(cur: Cursor, func: B.SupportedFunctionNode): IL.Function {
  compilingNode(cur, func);

  const entryBlock: IL.Block = {
    id: 'entry',
    expectedStackDepthAtEntry: 0,
    operations: []
  }

  if (func.generator) {
    return featureNotSupported(cur, `Generators not supported.`);
  }

  const funcInfo = cur.ctx.scopeAnalysis.scopes.get(func) ?? unexpected();
  if (funcInfo.type !== 'FunctionScope') return unexpected();

  const funcIL: IL.Function = {
    type: 'Function',
    sourceFilename: cur.unit.sourceFilename,
    id: funcInfo.ilFunctionId,
    entryBlockID: 'entry',
    maxStackDepth: 0,
    blocks: {
      ['entry']: entryBlock
    }
  };

  const bodyCur: Cursor = {
    ctx: cur.ctx,
    filename: cur.ctx.filename,
    breakScope: undefined,
    scopeStack: undefined,
    stackDepth: 0,
    node: func.body,
    unit: cur.unit,
    func: funcIL,
    block: entryBlock
  };

  cur.unit.functions[funcIL.id] = funcIL;

  compilePrologue(bodyCur, funcInfo.prologue);

  // Body of function (may be an expression if the function is an arrow function)
  const body = func.body;
  if (body.type === 'BlockStatement') {
    compileStatement(bodyCur, body);
    addOp(bodyCur, 'Literal', literalOperand(undefined));
    addOp(bodyCur, 'Return');
  } else {
    compileExpression(bodyCur, body);
    addOp(bodyCur, 'Return');
  }

  computeMaximumStackDepth(funcIL);

  return funcIL;
}

export function compilePrologue(cur: Cursor, prolog: PrologueStep[]) {
  for (const step of prolog) {
    switch (step.type) {
      case 'ScopePush': {
        addOp(cur, 'ScopePush', countOperand(step.slotCount));
        break;
      }
      case 'InitFunctionDeclaration': {
        const value = LazyValue(cur => {
          addOp(cur, 'Literal', functionLiteralOperand(step.functionId));
          if (step.functionIsClosure) {
            // Capture the current scope in the function value
            addOp(cur, 'ClosureNew');
          }
        })
        initializeSlot(step.slot, value);
        break;
      }
      case 'InitVarDeclaration': {
        const value = LazyValue(cur => addOp(cur, 'Literal', literalOperand(undefined)));
        initializeSlot(step.slot, value);
        break;
      }
      case 'InitLexicalDeclaration': {
        const value = LazyValue(cur => {
          addOp(cur, 'Literal', {
            type: 'LiteralOperand',
            literal: IL.deletedValue
          });
        })
        initializeSlot(step.slot, value);
        break;
      }
      case 'InitParameter': {
        const value = LazyValue(cur => addOp(cur, 'LoadArg', indexOperand(step.argIndex)));
        initializeSlot(step.slot, value);
        break;
      }
      case 'InitThis': {
        const value = LazyValue(cur => addOp(cur, 'LoadArg', indexOperand(0)));
        initializeSlot(step.slot, value);
        break;
      }
      default: assertUnreachable(step);
    }
  }

  function initializeSlot(slot: SlotAccessInfo, value: LazyValue) {
    // In the special case of a local slot, the prologue is ordered such that
    // the slot is in the correct place already so there is no work to do.
    if (slot.type === 'LocalSlot') {
      hardAssert(cur.stackDepth === slot.index);
      value.load(cur);
    } else {
      getSlotAccessor(cur, slot).store(cur, value);
    }
  }
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

export function compileThrowStatement(cur: Cursor, statement: B.ThrowStatement): void {
  compileExpression(cur, statement.argument);
  addOp(cur, 'Throw');
  cur.unreachable = true;
}

export function compileForStatement(cur: Cursor, statement: B.ForStatement): void {
  const loopBlock = predeclareBlock();
  const terminateBlock = predeclareBlock();
  const bodyBlock = predeclareBlock();

  const forBlockScope = notUndefined(cur.ctx.scopeAnalysis.scopes.get(statement)) as BlockScope;
  hardAssert(forBlockScope.type === 'BlockScope');

  const hasClosureScope = !!forBlockScope.closureSlots;

  // Init
  if (!statement.init) return notImplemented('for-loop without initializer');
  const scope = enterScope(cur, forBlockScope); // Also compiles the prolog
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

  // Loop test expression
  if (!statement.test) return notImplemented('for-loop without test expression');
  compileExpression(loopCur, statement.test);
  // Branch after test
  addOp(loopCur, 'Branch', labelOfBlock(bodyBlock), labelOfBlock(terminateBlock));

  // Body
  const bodyCur = createBlock(loopCur, bodyBlock);
  compileStatement(bodyCur, statement.body);

  // If any loop variables are closed over, we need to clone the loop variable
  // closure scope so that each iteration of the loop has a fresh copy of the
  // loop variable for its inner closure to remember. This happens before the
  // update expression because we want the current iteration to "remember" its
  // state before it changed in the update.
  if (hasClosureScope) {
    addOp(bodyCur, 'ScopeClone');
  }

  if (!statement.update) return notImplemented('for-loop without update expression');
  compileExpression(bodyCur, statement.update);
  addOp(bodyCur, 'Pop', countOperand(1)); // Expression result not used
  // Loop back at end of body
  addOp(bodyCur, 'Jump', labelOfBlock(loopBlock));

  const terminateBlockCur = createBlock(bodyCur, terminateBlock);

  moveCursor(cur, terminateBlockCur);

  popBreakScope(cur, statement);
  scope.leaveScope(cur); // Also compiles the epilog
}

export function compileBlockEpilogue(cur: Cursor, block: BlockScope) {
  // Pop extra local variables off the stack
  if (block.epiloguePopCount > 0) {
    addOp(cur, 'Pop', countOperand(block.epiloguePopCount));
  }
  // Pop the top closure scope
  if (block.epiloguePopScope) {
    addOp(cur, 'ScopePop');
  }
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
  const scopeInfo = cur.ctx.scopeAnalysis.scopes.get(statement) as BlockScope;

  // Compile scope prologue
  const scope = enterScope(cur, scopeInfo);

  for (const s of statement.body) {
    if (cur.unreachable) break;
    compileStatement(cur, s);
  }

  scope.leaveScope(cur);
}

export function compileIfStatement(cur: Cursor, statement: B.IfStatement): void {
  if (statement.alternate) {
    const consequent = predeclareBlock();
    const alternate = predeclareBlock();
    const after = predeclareBlock();

    // Test and branch
    compileExpression(cur, statement.test);
    compilingNode(cur, statement);
    addOp(cur, 'Branch', labelOfBlock(consequent), labelOfBlock(alternate));

    // Consequent block
    const consequentCur = createBlock(cur, consequent);
    compileStatement(consequentCur, statement.consequent);
    compilingNode(consequentCur, statement.consequent);
    addOp(consequentCur, 'Jump', labelOfBlock(after));

    // Alternate block
    const alternateCur = createBlock(cur, alternate);
    compileStatement(alternateCur, statement.alternate);
    compilingNode(alternateCur, statement);
    addOp(alternateCur, 'Jump', labelOfBlock(after));

    // After block
    const afterCur = createBlock(consequentCur, after);

    moveCursor(cur, afterCur);
  } else {
    const consequent = predeclareBlock();
    const after = predeclareBlock();

    // Test and branch
    compileExpression(cur, statement.test);
    compilingNode(cur, statement.test);
    addOp(cur, 'Branch', labelOfBlock(consequent), labelOfBlock(after));

    // Consequent block
    const consequentCur = createBlock(cur, consequent);
    compileStatement(consequentCur, statement.consequent);
    compilingNode(consequentCur, statement.consequent);
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
    dependentLabels.forEach(l => l.targetBlockId = block.id);
    predeclaredBlocks.delete(predeclaredBlock);
  }

  if (cur.commentNext) {
    block.comments = cur.commentNext;
    cur.commentNext = undefined;
  }
  cur.func.blocks[block.id] = block;
  const blockCursor: Cursor = {
    filename: cur.filename,
    breakScope: cur.breakScope,
    scopeStack: cur.scopeStack,
    ctx: cur.ctx,
    func: cur.func,
    node: cur.node,
    stackDepth: cur.stackDepth,
    unit: cur.unit,
    block
  };
  return blockCursor;
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
  const loc = notUndefined(cur.node.loc).start;
  const opcode_: IL.Operation['opcode'] = opcode;
  const operation: IL.Operation = {
    opcode: opcode_ as any, // Getting rid of weird TypeScript error
    operands,
    sourceLoc: { filename: cur.filename, line: loc.line, column: loc.column },
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
  const stackChange = IL.calcStaticStackChangeOfOp(operation) ?? unexpected();

  cur.stackDepth += stackChange;
  operation.stackDepthAfter = cur.stackDepth;

  if (opcode === 'Jump') {
    const target = operation.operands[0];
    if (target.type !== 'LabelOperand') {
      return unexpected();
    }
    // Note: targetBlockId can be undefined if the block is predeclared (see predeclared blocks)
    if (target.targetBlockId) {
      const targetBlock = cur.func.blocks[target.targetBlockId];
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
    // Note: targetBlockId can be undefined if the block is predeclared (see predeclared blocks)
    if (targetTrue.targetBlockId !== undefined) {
      const targetBlockTrue = cur.func.blocks[targetTrue.targetBlockId];
      if (targetBlockTrue.expectedStackDepthAtEntry !== operation.stackDepthAfter) {
        return internalCompileError(cur, `Branching (true branch) from stack depth of ${operation.stackDepthAfter} to block with stack depth of ${targetBlockTrue.expectedStackDepthAtEntry}`);
      }
    }
    if (targetFalse.targetBlockId !== undefined) {
      const targetBlockFalse = cur.func.blocks[targetFalse.targetBlockId];
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
    targetBlockId: block.id
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

function functionLiteralOperand(functionId: IL.FunctionID): IL.LiteralOperand {
  return {
    type: 'LiteralOperand',
    literal: {
      type: 'FunctionValue',
      value: functionId
    }
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

  const statement = statement_ as B.SupportedStatement;

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
    case 'ThrowStatement': return compileThrowStatement(cur, statement);
    case 'SwitchStatement': return compileSwitchStatement(cur, statement);
    case 'BreakStatement': return compileBreakStatement(cur, statement);
    case 'TryStatement': return compileTryStatement(cur, statement);
    case 'FunctionDeclaration': return; // Function declarations are hoisted
    case 'ExportNamedDeclaration': return notImplemented(); // Need to look into what to do here
    default: return compileErrorIfReachable(cur, statement);
  }
}

export function compileTryStatement(cur: Cursor, statement: B.TryStatement) {
  if (statement.finalizer) {
    compilingNode(cur, statement.finalizer);
    return compileError(cur, 'Not supported: finally');
  }

  if (!statement.handler) {
    // If we supported `finally` then the catch is optional, but a try on its
    // own doesn't make sense.
    return compileError(cur, 'Missing catch clause in try..catch');
  }

  const catcher = statement.handler;
  if (catcher.param && catcher.param.type !== 'Identifier') {
    compilingNode(cur, catcher.param);
    return compileError(cur, 'Only simple binding supported in catch statement');
  }

  const tryBlock = predeclareBlock();
  const catchBlock = predeclareBlock();
  const after = predeclareBlock();

  const tryCur = createBlock(cur, tryBlock);
  addOp(tryCur, 'StartTry', labelOfBlock(catchBlock));
  // WIP: push a scope so that the epilog can call EndTry
  compileStatement(tryCur, statement.block);
  // WIP: scope pop
  addOp(tryCur, 'EndTry');
  addOp(tryCur, 'Jump', labelOfBlock(after));

  const catchInfo = cur.ctx.scopeAnalysis.scopes.get(catcher.body) ?? unexpected();
  if (catchInfo.type !== 'BlockScope') return unexpected();

  // The catch block starts with an additional value on the stack
  cur.stackDepth++;
  const catchCur = createBlock(cur, catchBlock);
  if (catcher.param) {
    // Slot for exception value
    const slot: SlotAccessInfo = catchInfo.catchExceptionSlot ?? unexpected();

    if (slot.type === 'LocalSlot') {
      // Special case for optimization. If the binding doesn't need to be in a
      // closure slot then the analysis should have allocated it in the slot
      // it's already in from the `throw` so that the assignment is a no-op
      hardAssert(slot.index === catchCur.stackDepth - 1);
      // WIP We still need to pop this local binding at the end of the block as part of the block epilog
    } else {
      // Otherwise the exception is probably in a closure (this assert is just
      // because I expect it to be, not because I require it to be)
      hardAssert(slot.type === 'ClosureSlotAccess');
      const exceptionValue = valueAtTopOfStack(catchCur);
      getSlotAccessor(catchCur, slot).store(catchCur, exceptionValue);
      addOp(catchCur, 'Pop');
    }
  } else {
    addOp(catchCur, 'Pop'); // Pop the exception off the stack because it isn't being used
  }

  const afterCur = createBlock(tryCur, after);
  moveCursor(cur, afterCur);
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

  // Create a copy of the cursor. This is in a sense because we're "branching"
  // off. But more practically speaking, `compileBreakStatement` is being called
  // from some nested statement and the original cursor still needs to unwind as
  // it would normally.
  const tempCur = { ...cur };

  // Execute all the block epilogues (popping closure scopes etc)
  while (tempCur.scopeStack?.scope !== breakScope.scope) {
    hardAssert(tempCur.scopeStack !== undefined);
    tempCur.scopeStack!.helper.leaveScope(tempCur);
  }

  addOp(tempCur, 'Jump', labelOfBlock(breakScope.breakToTarget));
}

function pushBreakScope(cur: Cursor, statement: B.SupportedLoopStatement | B.SwitchStatement, breakToTarget: IL.Block): BreakScope {
  const breakScope: BreakScope = {
    breakToTarget,
    parent: cur.breakScope,
    statement,
    scope: cur.scopeStack?.scope
  };
  cur.breakScope = breakScope;
  return breakScope;
}

function popBreakScope(cur: Cursor, statement: B.SupportedLoopStatement | B.SwitchStatement) {
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
  const expression = expression_ as B.SupportedExpression;

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
    case 'FunctionExpression': return compileFunctionExpression(cur, expression);
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
  compileGeneralFunctionExpression(cur, expression);
}

export function compileFunctionExpression(cur: Cursor, expression: B.FunctionExpression) {
  compileGeneralFunctionExpression(cur, expression);
}

/** Compiles a function and returns a lazy sequence of instructions to reference the value locally */
function compileGeneralFunctionExpression(cur: Cursor, expression: B.SupportedFunctionNode) {
  const functionScopeInfo = cur.ctx.scopeAnalysis.scopes.get(expression) ?? unexpected();
  if (functionScopeInfo.type !== 'FunctionScope') unexpected();

  // Push reference to target
  addOp(cur, 'Literal', functionLiteralOperand(functionScopeInfo.ilFunctionId));

  // If the function does not need to be a closure, then the above literal
  // reference is sufficient. If the function needs to be a closure, we need to
  // bind the scope.
  if (functionScopeInfo.functionIsClosure) {
    addOp(cur, 'ClosureNew');
  }
}

/** Returns a LazyValue of the value current at the top of the stack */
function valueAtTopOfStack(cur: Cursor): LazyValue {
  const indexOfValue = cur.stackDepth - 1;
  return LazyValue(cur => addOp(cur, 'LoadVar', indexOperand(indexOfValue)));
}

export function compileThisExpression(cur: Cursor, expression: B.ThisExpression) {
  const ref = cur.ctx.scopeAnalysis.references.get(expression) ?? unexpected();
  getSlotAccessor(cur, ref.access).load(cur);
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
    // Awkwardly, the `this` reference must be the first parameter, which must
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
    const left = accessVariable(cur, expression.left);
    compileExpression(cur, expression.right);
    const value = valueAtTopOfStack(cur);
    left.store(cur, value);
  } else {
    const left = accessVariable(cur, expression.left);
    left.load(cur);
    compileExpression(cur, expression.right);
    const operator = getBinOpFromAssignmentExpression(cur, expression.operator);
    addOp(cur, 'BinOp', opOperand(operator));
    const value = valueAtTopOfStack(cur);
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

function getObjectMemberAccessor(cur: Cursor, object: LazyValue, property: LazyValue): ValueAccessor {
  return {
    load(cur: Cursor) {
      object.load(cur);
      property.load(cur);
      addOp(cur, 'ObjectGet');
    },
    store(cur: Cursor, value: LazyValue) {
      object.load(cur);
      property.load(cur);
      value.load(cur);
      addOp(cur, 'ObjectSet');
    }
  }
}

/**
 * Returns an accessor for the given variable reference.
 *
 * For convenience, this also handles the case where the reference is a member
 * expression.
 *
 * Note: In the current design, all variables are referenced by an identifier
 * node in the AST. The instructions used to read or write to a variable change
 * depending on where it is accessed *from*, which is why this takes the
 * identifier referencing the node and not the variable node. In particular, the
 * `LoadScoped` and `StoreScoped` instructions for accessing closure variables
 * accept an index operand relative to the current frame.
 */
function accessVariable(cur: Cursor, variableReference: B.LVal, opts?: { forInitialization?: boolean }): ValueAccessor {
  if (variableReference.type === 'Identifier') {
    const reference = cur.ctx.scopeAnalysis.references.get(variableReference) ?? unexpected();
    const resolvesTo = reference.resolvesTo;
    switch (resolvesTo.type) {
      case 'Binding': return getSlotAccessor(cur, reference.access, resolvesTo.binding.isDeclaredReadonly && !opts?.forInitialization);
      case 'FreeVariable': return getGlobalAccessor(resolvesTo.name);
      case 'RootLevelThis': return getConstantAccessor(undefined);
      default: assertUnreachable(resolvesTo);
    }
  }

  if (variableReference.type === 'MemberExpression') {
    const object = LazyValue(cur => compileExpression(cur, variableReference.object));
    // Computed properties are like a[0], and are only used for array access within the context of Microvium
    if (variableReference.computed) {
      const property = LazyValue(cur => compileExpression(cur, variableReference.property));
      return getObjectMemberAccessor(cur, object, property);
    } else {
      if (variableReference.property.type !== 'Identifier') {
        return compileError(cur, 'Property names must be simple identifiers');
      }
      const propName = variableReference.property.name;
      const property = LazyValue(cur => addOp(cur, 'Literal', literalOperand(propName)));
      return getObjectMemberAccessor(cur, object, property);
    }
  }

  return compileError(cur, `Feature not supported: "${variableReference.type}"`);
}

export function getGlobalAccessor(name: string): ValueAccessor {
  return {
    load(cur: Cursor) {
      addOp(cur, 'LoadGlobal', nameOperand(name));
    },
    store(cur: Cursor, value: LazyValue) {
      value.load(cur);
      addOp(cur, 'StoreGlobal', nameOperand(name));
    }
  }
}

/** Given SlotAccessInfo, this produces a ValueAccessor that encapsulates the IL
 * sequences required to read or write to the given slot.  */
export function getSlotAccessor(cur: Cursor, slotAccess: SlotAccessInfo, readonly: boolean = false): ValueAccessor {
  switch (slotAccess.type) {
    case 'GlobalSlot': {
      return {
        load(cur: Cursor) {
          addOp(cur, 'LoadGlobal', nameOperand(slotAccess.name));
        },
        store(cur: Cursor, value: LazyValue) {
          if (readonly) {
            return compileError(cur, 'Cannot assign to constant');
          }
          value.load(cur);
          addOp(cur, 'StoreGlobal', nameOperand(slotAccess.name));
        }
      }
    }

    case 'ModuleImportExportSlot': {
      const object = getSlotAccessor(cur, slotAccess.moduleNamespaceObjectSlot);
      const propertyName = LazyValue(cur => addOp(cur, 'Literal', literalOperand(slotAccess.propertyName)));
      const propertySlot = getObjectMemberAccessor(cur, object, propertyName);
      return propertySlot;
    }

    case 'LocalSlot': {
      return {
        load(cur: Cursor) {
          hardAssert(slotAccess.index < cur.stackDepth);
          addOp(cur, 'LoadVar', indexOperand(slotAccess.index));
        },
        store(cur: Cursor, value: LazyValue) {
          hardAssert(slotAccess.index < cur.stackDepth);

          if (readonly) {
            return compileError(cur, 'Cannot assign to constant');
          }

          value.load(cur);
          addOp(cur, 'StoreVar', indexOperand(slotAccess.index));
        }
      };
    }

    case 'ClosureSlotAccess': {
      return {
        load(cur: Cursor) {
          addOp(cur, 'LoadScoped', indexOperand(slotAccess.relativeIndex));
        },
        store(cur: Cursor, value: LazyValue) {
          value.load(cur);
          addOp(cur, 'StoreScoped', indexOperand(slotAccess.relativeIndex));
        }
      }
    }

    case 'ConstUndefinedAccess': return getConstantAccessor(undefined);

    case 'ArgumentSlot': {
      return {
        load(cur: Cursor) {
          addOp(cur, 'LoadArg', indexOperand(slotAccess.argIndex));
        },
        store: () => unexpected()
      }
    }

    default: return assertUnreachable(slotAccess);
  }
}

function getConstantAccessor(constant: IL.LiteralValueType): ValueAccessor {
  return {
    load(cur: Cursor) {
      addOp(cur, 'Literal', literalOperand(constant));
    },
    store: () => unexpected()
  }
}

export function compileUnaryExpression(cur: Cursor, expression: B.UnaryExpression) {
  if (!expression.prefix) {
    return compileError(cur, 'Not supported');
  }
  const operator = expression.operator;

  if (operator === 'throw') {
    // I don't even know what a `throw` unary expression is. We support a
    // ThrowStatement which is not an expression
    return featureNotSupported(cur, 'throw expression');
  }

  if (operator === "void" || operator === "delete") {
    return compileError(cur, `Operator not supported: "${operator}"`);
  }

  let unOpCode: IL.UnOpCode = operator;
  // Special case for negative numbers, we just fold the negative straight into the literal
  if (unOpCode === '-' && expression.argument.type === 'NumericLiteral') {
    return addOp(cur, 'Literal', literalOperand(-expression.argument.value));
  }
  compileExpression(cur, expression.argument);
  addOp(cur, 'UnOp', opOperand(unOpCode));
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

  const accessor = accessVariable(cur, expression.argument);
  accessor.load(cur);
  if (expression.prefix) {
    // If used as a prefix operator, the result of the expression is the value *after* we increment it
    updaterOp(cur);
    const valueToStore = valueAtTopOfStack(cur);
    accessor.store(cur, valueToStore);
  } else {
    // If used as a suffix, the result of the expression is the value *before* we increment it
    compileDup(cur);
    updaterOp(cur);
    const valueToStore = valueAtTopOfStack(cur);
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
    accessVariable(cur, expression).load(cur);
  }
}

// Note: the difference between visitingNode and compilingNode is that
// visitingNode can be called during analysis passes (e.g. scope analysis) that
// don't actually emit IL, whereas `compilingNode` should be called right before
// actual IL is emitted for the particular syntax construction. The
// `compilingNode` function accumulates the comments that will be "dumped" onto
// the next IL instruction to be emitted.
export function compilingNode(cur: Cursor, node: B.Node) {
  // Note: there can be multiple nodes that precede the generation of an
  // instruction, and this just uses the comment from the last node, which seems
  // "good enough"
  if (node.leadingComments) {
    cur.commentNext = node.leadingComments.map(c => c.value.trim());
  }
  visitingNode(cur, node);
}

export function compileVariableDeclaration(cur: Cursor, decl: B.VariableDeclaration) {
  /*
  Note: variable declarations are non-compliant in Microvium. A declaration like
  ` var x = 5;` is compiled just `Literal(5)`, which leaves the value `5` at the
  top of the stack as the variable slot. This is non-compliant because it means
  local variable slots don't exist before their declaration (violates TDZ
  rules).
  */
  for (const d of decl.declarations) {
    compilingNode(cur, d);

    if (d.id.type !== 'Identifier') {
      return compileError(cur, 'Only simple variable declarations are supported.')
    }

    var slot = accessVariable(cur, d.id, { forInitialization: true });
    var initialValue = LazyValue(cur => d.init
      ? compileExpression(cur, d.init)
      : addOp(cur, 'Literal', literalOperand(undefined))
    );
    slot.store(cur, initialValue);
  }
}

function enterScope(cur: Cursor, scope: Scope): ScopeHelper {
  const stackDepthAtStart = cur.stackDepth;

  const helper: ScopeHelper = {
    leaveScope(cur: Cursor) {
      if (!cur.unreachable) {
        // Variables can be declared during the block. We need to clean them off the stack
        const variableCount = cur.stackDepth - stackDepthAtStart;
        hardAssert(scope.epiloguePopCount === variableCount);

        // Pop scope stack
        hardAssert(cur.scopeStack?.helper === helper);
        cur.scopeStack = cur.scopeStack!.parent;

        if (scope.type === 'BlockScope') {
          compileBlockEpilogue(cur, scope);
        }
      }
    }
  };

  // Push scope stack
  cur.scopeStack = { helper, scope, parent: cur.scopeStack };

  compilingNode(cur, scope.node);
  compilePrologue(cur, scope.prologue);

  return helper;
}

function computeMaximumStackDepth(func: IL.Function) {
  let maxStackDepth = 0;
  for (const [_blockID, block] of entries(func.blocks)) {
    for (const op of block.operations) {
      if (op.stackDepthBefore > maxStackDepth) maxStackDepth = op.stackDepthBefore;
      if (op.stackDepthAfter && op.stackDepthAfter > maxStackDepth) maxStackDepth = op.stackDepthAfter;
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
  if (callee.name !== '$$MicroviumNopInstruction') return false;
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