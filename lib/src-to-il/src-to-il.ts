import * as babylon from '@babel/parser';
import * as B from './supported-babel-types';
import * as IL from '../il';
import { unexpected, assertUnreachable, hardAssert, isNameString, entries, notUndefined, notImplemented, MicroviumSyntaxError } from '../utils';
import { isUInt16 } from '../runtime-types';
import { minOperandCount } from '../il-opcodes';
import { analyzeScopes, AnalysisModel, SlotAccessInfo, PrologueStep, BlockScope, Scope } from './analyze-scopes';
import { compileError, compileErrorIfReachable, featureNotSupported, internalCompileError, SourceCursor, visitingNode } from './common';
import { formatSourceLoc } from '../stringify-il';

const outputStackDepthComments = false;

type Procedure = (cur: Cursor) => void;

// The context is state shared between all cursors in the unit. The cursors are
// what's passed around to the code generators, and the context holds shared
// state that can be used from anywhere that has a cursor.
interface Context {
  filename: string;
  nextBlockID: number; // Mutable counter for numbering blocks
  scopeAnalysis: AnalysisModel;
  // Map from source location of `await` to the stack depth at that point
  // (before awaiting), or undefined if that information is not yet known.
  // Source location stored as `line:column` starting at 1:0 I think.
  awaitStackDepths?: Map<string, number>;
}

interface ScopeStack {
  helper: ScopeHelper;
  scope: Scope;
  parent: ScopeStack | undefined;

  // If the scope is a try block, the catchTarget is the corresponding catch
  // block and the stackDepth is the depth before the try (i.e. the depth of the
  // catch target in the stack)
  catchTarget?: IL.Block;
  stackDepth?: number;
}

interface Cursor extends SourceCursor {
  ctx: Context;
  breakScope: BreakScope | undefined;
  scopeStack: ScopeStack | undefined;
  unit: IL.Unit;
  func: IL.Function;
  block: IL.Block;
  node: B.Node;
  endOfNode?: boolean; // For things like blocks, it helps to know if we're doing the epilog
  stackDepth: number;
  commentNext?: string[];
  reachable: boolean; // Reachability (resets to `true` at the start of the next block)
}

interface ScopeHelper {
  leaveScope(cur: Cursor, currentOperation: 'break' | 'return' | 'normal'): void;
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

/**
 * Compile the given source code.
 *
 * Note: if opts.awaitStackDepths is only used internally (this function
 * recursively calls itself).
 */
export function compileScript(
  filename: string,
  scriptText: string,
  opts?: { awaitStackDepths?: Map<string, number> }
): {
  unit: IL.Unit,
  scopeAnalysis: AnalysisModel
} {
  const file = parseToAst(filename, scriptText);

  const scopeAnalysis = analyzeScopes(file, filename, opts?.awaitStackDepths);

  const ctx: Context = {
    filename,
    // Global counter for generating block IDs. I'm not sure why I made this
    // global, but I suspect one advantage is when looking at the IL, it's easy
    // to jump to a label
    nextBlockID: 1,
    scopeAnalysis: scopeAnalysis,
    awaitStackDepths: opts?.awaitStackDepths,
  };

  const unit: IL.Unit = {
    sourceFilename: filename,
    functions: { },
    moduleVariables: scopeAnalysis.globalSlots.map(s => s.name),
    freeVariables: [...scopeAnalysis.freeVariables].filter(x => !specialForms.has(x)),
    entryFunctionID: undefined as any, // Filled out later
    moduleImports: [],
  };

  const cur: Cursor = {
    ctx,
    filename,
    breakScope: undefined,
    scopeStack: undefined,
    stackDepth: 0,
    reachable: true,
    node: file,
    unit,
    // This is one of the few places where we're not actually in a function yet
    func: undefined as any,
    block: undefined as any,
  }

  // # Imports
  // Note that imports don't require any IL to be emitted (e.g. a `require`
  // call) since the imported modules are just loaded automatically at load
  // time.
  for (const statement of file.program.body) {
    if (statement.type === 'ImportDeclaration') {
      compilingNode(cur, statement);
      const source = statement.source.value;
      const info = scopeAnalysis.moduleImports.get(source);
      unit.moduleImports.push({
        variableName: info?.name,
        source: statement.source.value
      });
    }
  }

  // Entry function
  const entryFunc = compileEntryFunction(cur, file.program);
  unit.entryFunctionID = entryFunc.id;

  // If there was no stack depth information for the await points, we can now
  // calculate it by walking the emitted IL
  if (!opts?.awaitStackDepths) {
    const awaitPoints = findAwaitPoints(unit);
    // If there are no await points, then the resulting IL is synchronous and so
    // the fact that we didn't have await stack depths is not a problem.
    // Otherwise, we run the whole compiler again with the await stack depths.
    // It's kinda ridiculous to run the compiler twice on the same unit but it's
    // a quick and reliable way to get to MVP and we can optimize later.
    if (awaitPoints.length !== 0) {
      const awaitStackDepths = new Map<string, number>();
      for (const awaitPoint of awaitPoints) {
        // Note: the location is not unique across multiple files, but we're
        // only using it as a key within a single file here. It's an awkward key
        // to use but it's the only thing in the output that currently
        // identifies which await point we're talking about.
        const loc = awaitPoint.sourceLoc ?? unexpected();
        const locStr = `${loc.line}:${loc.column + 1}`;
        const stackDepth = awaitPoint.stackDepthBefore ?? unexpected();
        awaitStackDepths.set(locStr, stackDepth);
      }
      return compileScript(filename, scriptText, { awaitStackDepths });
    }
  }

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
    reachable: true,
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
    bodyCur.commentNext = undefined;
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
    case 'VariableDeclaration': return compileModuleVariableDeclaration(cur, statement_);
    case 'ExportNamedDeclaration': return compileExportNamedDeclaration(cur, statement_);
    case 'FunctionDeclaration': return compileFunction(cur, statement_);
    // Import declarations are hoisted so they're not compiled here
    case 'ImportDeclaration': return;
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
    compileModuleVariableDeclaration(cur, declaration);
  } else if (declaration.type === 'FunctionDeclaration') {
    compileFunction(cur, declaration);
  } else if (declaration.type === 'ClassDeclaration') {
    compileClassDeclaration(cur, declaration);
  } else {
    return compileError(cur, `Not supported: export of ${declaration.type}`);
  }
}

export function compileModuleVariableDeclaration(cur: Cursor, decl: B.VariableDeclaration) {
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

// This does not add any IL at `cur`. It just creates a new ILFunction (in the
// unit) corresponding to the `func` AST. The choice was made to call
// `compileFunction` at the point in the AST where we encounter the function,
// because certain functions may need to be context-aware. E.g. class
// constructors need to be aware of property initializers.
//
// Note: `cur` is the cursor in the parent body (module entry function or parent
// function). This function creates its own `bodyCur` that points to the
// beginning of the new IL function code.
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

  if (cur.commentNext) {
    funcIL.comments = cur.commentNext;
    cur.commentNext = undefined;
  }

  const bodyCur: Cursor = {
    ctx: cur.ctx,
    filename: cur.ctx.filename,
    breakScope: undefined,
    scopeStack: undefined,
    stackDepth: 0,
    reachable: true,
    node: func,
    unit: cur.unit,
    func: funcIL,
    block: entryBlock
  };

  cur.unit.functions[funcIL.id] = funcIL;

  // Compile scope prologue
  const scope = enterScope(bodyCur, funcInfo);

  // Body of function (may be an expression if the function is an arrow function)
  const body = func.body;
  if (body.type === 'BlockStatement') {
    compileBlockStatement(bodyCur, body);
    addOp(bodyCur, 'Literal', literalOperand(undefined));
  } else {
    compileExpression(bodyCur, body);
  }

  if (funcInfo.isAsyncFunction) {
    addOp(bodyCur, 'AsyncReturn');
  } else {
    addOp(bodyCur, 'Return');
  }

  scope.leaveScope(bodyCur, 'return');

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
      case 'ScopeNew': {
        addOp(cur, 'ScopeNew', countOperand(step.slotCount));
        break;
      }
      case 'AsyncStart': {
        addOp(cur, 'AsyncStart', countOperand(step.slotCount), flagOperand(step.captureParent));
        break;
      }
      case 'InitFunctionDeclaration': {
        const value = LazyValue(cur => {
          addOp(cur, 'Literal', functionLiteralOperand(step.functionId));
          if (step.closureType === 'embedded') {
            // Store the function pointer in the first closure slot, to make the
            // function properly executable.
            addOp(cur, 'StoreScoped', indexOperand(0));
            addOp(cur, 'LoadReg', nameOperand('closure'));
          } else if (step.closureType === 'non-embedded') {
            addOp(cur, 'ClosureNew');
          } else {
            hardAssert(step.closureType === 'none');
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
          }).nameHint = step.nameHint;
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
      case 'InitCatchParam': {
        // This is a bit of a hack, but since the value is already at the top of
        // the stack (by the throw operation), we only need to emit the
        // instructions to save it. So the load instructions are a no-op. This
        // will be fine as long as we never have an `initializeSlot` that needs
        // to push other stuff onto the stack before the value, such as an
        // object reference (e.g. if we ever needed to store the catch param in
        // an object, for some weird reason). But in this case, that doesn't
        // make sense.
        const value = LazyValue(() => {});
        // This step is completely omitted if the slot is a local slot, since
        // the `throw` will put it in the right place anyway.
        hardAssert(step.slot.type === 'ClosureSlotAccess')
        initializeSlot(step.slot, value);
        break;
      }
      case 'DiscardCatchParam': {
        addOp(cur, 'Pop', countOperand(1));
        break;
      }
      case 'DummyPushException': {
        // The catch block starts with an additional value on the stack. This
        // value is already on the stack, but I'm artificially pretending it's
        // part of the prologue (you can imagine that `throw` jumps to the block
        // *before* pushing the exception to the stack, so this approach is
        // still sensible) so that the block can maintain the invariant that the
        // exit stack depth is the same as the entry stack depth, and that the
        // epilogue pops as much as the prologue pushes. This is important
        // because `enterScope` and `leaveScope` calculate automatically how
        // many variables to pop off the stack and checks that the stack has the
        // same depth at exit as at entry.
        cur.stackDepth++;
        break;
      }
      case 'StartTry': {
        addOp(cur, 'StartTry', labelOfBlock(cur.scopeStack?.catchTarget ?? unexpected()));
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
  // Special case: a function call as a statement is compiled as a void call, so
  // that the result is never pushed in the first place. Apart from saving on
  // the Pop instruction, the runtime can perform other optimizations if it
  // knows that the result is never used. In particular, async functions do not
  // need to synthesize a return Promise if they're void-called.
  if (statement.expression.type === 'CallExpression') {
    compileCallExpression(cur, statement.expression, true, false);
    /* No Pop */
    return;
  }

  compileExpression(cur, statement.expression);
  // Pop the result of the expression off the stack
  addOp(cur, 'Pop', countOperand(1));
}

export function compileReturnStatement(cur: Cursor, statement: B.ReturnStatement): void {
  // Making a copy of the cursor, like with `break`, since the flow is completely broken by a return
  const tempCur = { ...cur }
  cur.reachable = false;

  // Execute all the relevant block epilogues
  while (tempCur.scopeStack?.scope.type === 'BlockScope' || tempCur.scopeStack?.scope.type === 'ModuleScope') {
    hardAssert(tempCur.scopeStack !== undefined);
    tempCur.scopeStack!.helper.leaveScope(tempCur, 'return');
  }

  compilingNode(tempCur, statement);
  if (statement.argument) {
    compileExpression(tempCur, statement.argument);
  } else {
    addOp(tempCur, 'Literal', literalOperand(undefined));
  }

  const func = getContainingFunction(cur);
  if (func === undefined) unexpected();
  compilingNode(tempCur, statement);
  if (func.isAsyncFunction) {
    addOp(tempCur, 'AsyncReturn');
  } else {
    addOp(tempCur, 'Return');
  }
}

export function compileThrowStatement(cur: Cursor, statement: B.ThrowStatement): void {
  compileExpression(cur, statement.argument);
  addOp(cur, 'Throw');
  // The rest of the block is unreachable
  cur.reachable = false;
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

  // Note: the terminateBlock contains the epilogue for the `for`, including
  // popping the loop variable or closure scope. So breaking to `statement` (the
  // for loop) does not exit the loop itself
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
  scope.leaveScope(cur, 'normal'); // Also compiles the epilog
}

export function compileBlockEpilogue(cur: Cursor, block: BlockScope, currentOperation: 'break' | 'return' | 'normal') {
  for (const step of block.epilogue) {
    if (currentOperation === 'return' && !step.requiredDuringReturn) {
      continue;
    }
    switch (step.type) {
      case 'Pop': {
        // Pop extra local variables off the stack
        addOp(cur, 'Pop', countOperand(step.count));
        break;
      }
      case 'EndTry': {
        const op = addOp(cur, 'EndTry');
        // EndTry unwinds the stack
        cur.stackDepth = step.stackDepthAfter;
        op.stackDepthAfter = step.stackDepthAfter;
        break;
      }
      case 'ScopePop': {
        // Pop the top closure scope
        addOp(cur, 'ScopePop');
        break;
      }
      case 'ScopeDiscard': {
        // Drop the top (only) closure
        addOp(cur, 'ScopeDiscard');
        break;
      }
      default: {
        assertUnreachable(step);
      }
    }
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

export function compileBlockStatement(cur: Cursor, statement: B.BlockStatement, opts?: { catchTarget?: IL.Block, stackDepth?: number }): void {
  const scopeInfo = cur.ctx.scopeAnalysis.scopes.get(statement) ?? unexpected() as BlockScope;

  // Compile scope prologue
  const scope = enterScope(cur, scopeInfo, opts);

  const ambientDepth = cur.stackDepth;

  // Find and compile functions
  for (const s of statement.body) {
    if (s.type === 'FunctionDeclaration') {
      compileFunction(cur, s);
    }
  }

  for (const s of statement.body) {
    hardAssert(cur.stackDepth === ambientDepth)
    if (!cur.reachable) break;
    compileStatement(cur, s);
  }

  scope.leaveScope(cur, 'normal');
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
    reachable: true,
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
  cur.ctx

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
      case 'FlagOperand': {
        if (operand.flag !== true && operand.flag !== false) {
          return internalCompileError(cur, `Flag operand incorrect: ${operand.flag}`);
        }
        break;
      }
    }
  }

  if (operands.length < minOperandCount(opcode)) {
    return internalCompileError(cur, `Incorrect number of operands to operation with opcode "${opcode}"`);
  }
  const nodeLoc = notUndefined(cur.node.loc);
  const loc = cur.endOfNode ? nodeLoc.end : nodeLoc.start;
  const opcode_: IL.Operation['opcode'] = opcode;
  const operation: IL.Operation = {
    opcode: opcode_ as any, // Getting rid of weird TypeScript error
    operands,
    sourceLoc: { filename: cur.filename, line: loc.line, column: loc.column },
    stackDepthBefore: cur.stackDepth,
    stackDepthAfter: undefined as any // Assign later
  };
  if (!cur.reachable) return operation; // Don't add to block
  if (outputStackDepthComments) {
    cur.commentNext = [`stackDepth = ${cur.stackDepth}`];
  }
  if (cur.commentNext) {
    operation.comments = cur.commentNext;
    cur.commentNext = undefined;
  }
  cur.block.operations.push(operation);

  if (opcode !== 'EndTry') {
    const stackChange = IL.calcStaticStackChangeOfOp(operation);
    cur.stackDepth += stackChange ?? unexpected();
  } else {
    // A bit of a hack. The caller will set the stack depth
    cur.stackDepth = undefined as any;
  }

  // console.log(`Stack is ${cur.stackDepth} after ${stringifyOperation(operation)} at ${cur.filename}:${loc.line}:${loc.column} in block ${cur.block.id}`);
  if (cur.stackDepth < 0) internalCompileError(cur, 'Stack imbalance');
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

export function labelOfBlock(block: IL.Block): IL.LabelOperand {
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

export function literalOperand(value: IL.LiteralValueType): IL.LiteralOperand {
  return {
    type: 'LiteralOperand',
    literal: literalOperandValue(value)
  }
}

// Note: better to use labelOfBlock if you can, but there are some places this manual form is convenient.
export function labelOperand(targetBlockId: IL.BlockID): IL.LabelOperand {
  return {
    type: 'LabelOperand',
    targetBlockId
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

export function countOperand(count: number): IL.CountOperand {
  return {
    type: 'CountOperand',
    count
  }
}

export function flagOperand(flag: boolean): IL.FlagOperand {
  return {
    type: 'FlagOperand',
    flag
  }
}

export function indexOperand(index: number): IL.IndexOperand {
  return {
    type: 'IndexOperand',
    index
  }
}

export function nameOperand(name: string): IL.NameOperand {
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
  if (!cur.reachable) return;

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
    case 'FunctionDeclaration': return; // Hoisted to block level
    case 'ExportNamedDeclaration': return compileError(cur, 'Named export declarations not supported');
    case 'ClassDeclaration': return compileClassDeclaration(cur, statement);
    default: return compileErrorIfReachable(cur, statement);
  }
}

// Note: `cur` is the cursor in the parent body (module entry function or parent function)
export function compileClassDeclaration(cur: Cursor, classDecl: B.ClassDeclaration) {
  if (classDecl.superClass) compileError(cur, 'Extends not supported', classDecl.superClass);
  if (classDecl.decorators) compileError(cur, 'Decorators not supported', classDecl.decorators?.[0]);

  const createClass = LazyValue(cur => {
    // Push the constructor
    compileClassConstructor(cur, classDecl);
    // Create an object for the static props. Note: we can't actually populate the
    // static props yet until the class has been bound to the name, since static
    // property initializers are allowed to refer to the class itself.
    addOp(cur, 'ObjectNew').nameHint = 'static props';
    // Create the class (tuple of constructor and props)
    addOp(cur, 'ClassCreate').nameHint = classDecl.id.name;
  });

  // We need to assign to a variable early, because a lot of the initializers to
  // come are allowed to have side effects.
  const classSlot = accessVariable(cur, classDecl.id, { forInitialization: true });
  classSlot.store(cur, createClass);

  // Static "prototype" property
  const createClassPrototype = LazyValue(cur => compileClassPrototype(cur, classDecl));
  getObjectMemberAccessor(cur, classSlot, 'prototype').store(cur, createClassPrototype);

  const fields = classDecl.body.body.filter(B.isClassField);

  // Computed class keys are not supported because the order of evaluation is
  // difficult to get right. Even for something as simple as methods, computed
  // keys are able to "see" the current state of the class variable, so the
  // order that we evaluate everything becomes much more important.
  for (const field of fields) {
    if (field.computed) {
      featureNotSupported(cur, 'Computed class keys', field.key)
    }
  }

  // Static methods
  for (const field of fields) {
    // Note: Non-static members are built in `compileClassPrototype`
    if (field.static && field.type === 'ClassMethod') {
      const key = getFieldKey(field);
      const method = compileClassMethod(cur, field);
      getObjectMemberAccessor(cur, classSlot, key).store(cur, method);
    }
  }

  // Static properties
  for (const field of fields) {
    // Note: Non-static members are built in `compileClassPrototype`
    if (field.static && field.type === 'ClassProperty') {
      const key = getFieldKey(field);
      const value = LazyValue(cur => field.value
        ? compileExpression(cur, field.value)
        : addOp(cur, 'Literal', literalOperand(undefined))
      )
      getObjectMemberAccessor(cur, classSlot, key).store(cur, value);
    }
  }
}

function compileClassPrototype(cur: Cursor, classDecl: B.ClassDeclaration) {
  !classDecl.superClass || featureNotSupported(cur, 'class inheritance', classDecl.superClass);
  const stackPositionOfPrototype = cur.stackDepth;
  addOp(cur, 'ObjectNew');
  const prototype = getSlotAccessor(cur, { type: 'LocalSlot', index: stackPositionOfPrototype, debugName: '' }, false, `${classDecl.id.name}.prototype`)

  const fields = classDecl.body.body.filter(B.isClassField);

  // Class methods
  for (const field of fields) {
    if (field.static) continue; // Static fields are handled separately

    if (field.type === 'ClassMethod') {
      // The constructor is compiled separately
      if (B.isConstructor(field)) continue;
      const method = compileClassMethod(cur, field);
      getObjectMemberAccessor(cur, prototype, getFieldKey(field)).store(cur, method)
    } else if (field.type === 'ClassProperty') {
      // Class properties are put on the instance, not the prototype
    } else {
      featureNotSupported(cur, (field as any).type, field);
    }
  }
}

export function getFieldKey(field: B.ClassMethod | B.ClassProperty): LazyValue {
  return LazyValue(cur => {
    if (field.computed) {
      compileExpression(cur, field.key);
    } else {
      // I think non-computed keys will always be identifiers
      if (field.key.type !== 'Identifier') unexpected();
      addOp(cur, 'Literal', literalOperand(field.key.name));
    }
  })
}

export function compileClassMethod(cur: Cursor, field: B.ClassMethod) {
  if (field.kind === 'get' || field.kind === 'set') {
    featureNotSupported(cur, 'Getters and setters not supported in Microvium', field);
  }

  if (field.async) {
    featureNotSupported(cur, 'Async methods not supported in Microvium', field);
  }

  if (field.generator) {
    featureNotSupported(cur, 'Generator methods not supported in Microvium', field);
  }

  // The constructor is treated separately to the other class methods
  if (field.kind === 'constructor') {
    return unexpected();
  }

  return LazyValue(cur => compileGeneralFunctionExpression(cur, field));
}

export function compileClassConstructor(cur: Cursor, classDecl: B.ClassDeclaration) {
  const entryBlock: IL.Block = {
    id: 'entry',
    expectedStackDepthAtEntry: 0,
    operations: []
  }

  const classInfo = cur.ctx.scopeAnalysis.scopes.get(classDecl) ?? unexpected();
  if (classInfo.type !== 'ClassScope') unexpected();
  const constructorInfo = classInfo.physicalConstructorScope;

  const constructorIL: IL.Function = {
    type: 'Function',
    sourceFilename: cur.unit.sourceFilename,
    id: constructorInfo.ilFunctionId,
    entryBlockID: 'entry',
    maxStackDepth: 0,
    blocks: {
      ['entry']: entryBlock
    }
  };
  cur.unit.functions[constructorIL.id] = constructorIL;

  if (cur.commentNext) {
    constructorIL.comments = cur.commentNext;
    cur.commentNext = undefined;
  }

  const bodyCur: Cursor = {
    ctx: cur.ctx,
    filename: cur.ctx.filename,
    breakScope: undefined,
    scopeStack: undefined,
    stackDepth: 0,
    reachable: true,
    node: classDecl,
    unit: cur.unit,
    func: constructorIL,
    block: entryBlock
  };

  compileClassConstructorBody(bodyCur, classDecl);
  computeMaximumStackDepth(constructorIL);

  // Back in the declaring scope, we push a reference to the function
  addOp(cur, 'Literal', functionLiteralOperand(constructorIL.id));

  if (constructorInfo.functionIsClosure) {
    // I don't think the static analysis will ever embed a constructor closure (TODO: Check this)
    hardAssert(!constructorInfo.embeddedInParentSlot);
    addOp(cur, 'ClosureNew');
  }
}

function compileClassConstructorBody(cur: Cursor, classDecl: B.ClassDeclaration) {
  const classInfo = cur.ctx.scopeAnalysis.scopes.get(classDecl) ?? unexpected();
  if (classInfo.type !== 'ClassScope') unexpected();
  const fields = classDecl.body.body.filter(B.isClassField);

  // Compile prologue
  const physicalConstructorScope = enterScope(cur, classInfo.physicalConstructorScope);

  // The instance itself at this point
  const inst = LazyValue(cur => addOp(cur, 'LoadArg', indexOperand(0)))
  // Compile pre-constructor field assignments
  for (const field of fields) {
    if (field.type === 'ClassProperty') {
      if (field.computed) {
        // I'm not supporting this at the moment because to keep to the spec we
        // would need to compute the key at the time the class is declared, but
        // then keep the key in a slot until the time that the class is
        // instantiated. I don't want to deal with slot assignment for such an
        // edge case.
        //
        // This ordering restriction also applies to static class properties.
        // All the class member keys must be calculated before any static
        // property initializers are evaluated, meaning we need to allocate
        // slots for their results.
        featureNotSupported(cur, 'Class properties with computed names.', field.key);
      }

      // We're only looking at instance properties here. Static properties are
      // dealt with in the class declaration itself.
      if (field.static) continue;

      // If the field is not computed (as asserted above), then it must be an identifier
      if (field.key.type !== 'Identifier') unexpected();
      const value = LazyValue(cur => field.value
        ? compileExpression(cur, field.value)
        : addOp(cur, 'Literal', literalOperand(undefined))
      )
      getObjectMemberAccessor(cur, inst, field.key.name).store(cur, value);
    } else if (field.type === 'ClassMethod') {
      // Class methods are declared on the prototype during the declaration, not
      // in the constructor.
    } else unexpected();
  }

  // Body of constructor
  const ctor = classDecl.body.body.find(B.isConstructor);

  if (ctor) {
    if (ctor.type !== 'ClassMethod') unexpected();
    const info = cur.ctx.scopeAnalysis.scopes.get(ctor) ?? unexpected();
    info === classInfo.virtualConstructorScope || unexpected();
    // Prologue, including parameter bindings
    const virtualConstructorScope = enterScope(cur, info);
    const body = ctor.body;
    compileBlockStatement(cur, body);
    virtualConstructorScope.leaveScope(cur, 'normal');
  }

  // By default, the constructor returns the constructed object, which is the
  // first parameter passed to the function. This is the default behavior but of
  // course the user code can also `return` whatever it likes.
  addOp(cur, 'LoadArg', indexOperand(0));
  addOp(cur, 'Return');

  physicalConstructorScope.leaveScope(cur, 'return');
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
  const tryBody = statement.block;
  const catchBody = statement.handler;
  if (catchBody.param && catchBody.param.type !== 'Identifier') {
    compilingNode(cur, catchBody.param);
    return compileError(cur, 'Only simple binding supported in catch statement');
  }

  const catchBlock = predeclareBlock();
  const after = predeclareBlock();

  const stackDepth = cur.stackDepth;
  compileBlockStatement(cur, tryBody, { catchTarget: catchBlock, stackDepth })
  addOp(cur, 'Jump', labelOfBlock(after));

  const catchCur = createBlock(cur, catchBlock);
  compileBlockStatement(catchCur, catchBody.body);
  addOp(catchCur, 'Jump', labelOfBlock(after));

  const afterCur = createBlock(catchCur, after);
  moveCursor(cur, afterCur);
}

function cloneCursor(cur: Cursor): Cursor {
  return { ...cur, commentNext: undefined }
}

export function compileBreakStatement(cur: Cursor, statement: B.BreakStatement) {
  if (statement.label) {
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
    tempCur.scopeStack!.helper.leaveScope(tempCur, 'break');
  }

  compilingNode(cur, statement);
  addOp(tempCur, 'Jump', labelOfBlock(breakScope.breakToTarget));

  // The rest of the block is unreachable
  cur.reachable = false
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
  if (!cur.reachable) return;
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
    case 'CallExpression': return compileCallExpression(cur, expression, false, false);
    case 'NewExpression': return compileNewExpression(cur, expression);
    case 'MemberExpression': return compileMemberExpression(cur, expression);
    case 'ArrayExpression': return compileArrayExpression(cur, expression);
    case 'ObjectExpression': return compileObjectExpression(cur, expression);
    case 'ConditionalExpression': return compileConditionalExpression(cur, expression);
    case 'ThisExpression': return compileThisExpression(cur, expression);
    case 'ArrowFunctionExpression': return compileArrowFunctionExpression(cur, expression);
    case 'FunctionExpression': return compileFunctionExpression(cur, expression);
    case 'TemplateLiteral': return compileTemplateLiteral(cur, expression);
    case 'AwaitExpression': return compileAwaitExpression(cur, expression);
    case 'ClassExpression': return featureNotSupported(cur, 'class expressions');
    default: return compileErrorIfReachable(cur, expression);
  }
}

export function compileAwaitExpression(cur: Cursor, expression: B.AwaitExpression) {
  if (expression.argument.type === 'CallExpression') {
    // Await-call operation
    compileCallExpression(cur, expression.argument, false, true);
  } else {
    compileExpression(cur, expression.argument);
  }

  if (cur.ctx.awaitStackDepths) {
    // Check the stack depth from the previous run matches this run, since the
    // analysis assumes that the stack depth is the same for each run even though
    // the closure size changes in the second run.
    const loc = `${expression.loc?.start.line}:${expression.loc!.start.column + 1}`;
    hardAssert(cur.ctx.awaitStackDepths.get(loc) === cur.stackDepth);
  }
  compilingNode(cur, expression);
  addOp(cur, 'Await');

  // Look for the closest catch block in the same function
  let scope = cur.scopeStack;
  while (scope && !scope.catchTarget && scope.parent && scope.parent.scope.type !== 'FunctionScope') {
    scope = scope.parent;
  }
  if (!scope?.catchTarget) scope = undefined; // No catch block found in the same function
  hardAssert(!scope || (scope.catchTarget && scope.stackDepth));
  // Either we found a catch block, or we just use the default catch block in
  // the async function which is in slots 1 and 2.
  const catchTargetDepth = scope?.stackDepth ?? 1;

  // The number of slots that need to be copied out of the closure into the call
  // stack. Note that the `Await` instruction itself has a stack change value of
  // -1, meaning that `cur.stackDepth` here does not include the value to be
  // awaited, nor the result of awaiting that value.
  const restoreSlotCount = cur.stackDepth
    - 1 // synchronous return value in var[0]
    - 2 // catch target

  // The "catchTarget" operand is the number of slots we have to go back
  // relative to the current stack depth to find the closest catch target after
  // resuming the async function. For example, if there are no other slots on
  // the stack then the current stack depth is 3 and the catch target is in slot
  // 1, so the `catchTarget` variable will be `2` to indicate that the catch
  // target is 2 slots behind the stack pointer.
  const catchTarget = cur.stackDepth - catchTargetDepth;
  hardAssert(catchTarget >= 2); // Needs to be at least 2 slots back because a catch target consumes 2 slots.

  const resumeOp = addOp(cur, 'AsyncResume', countOperand(restoreSlotCount), countOperand(catchTarget));
  resumeOp.stackDepthBefore = 0; // Bit of a hack, but we expect the stack to be empty when we resume the async function
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
  if (functionScopeInfo.type !== 'FunctionScope' && functionScopeInfo.type) unexpected();

  // Push reference to target
  addOp(cur, 'Literal', functionLiteralOperand(functionScopeInfo.ilFunctionId));

  // If the function does not need to be a closure, then the above literal
  // reference is sufficient. If the function needs to be a closure, we need to
  // bind the scope.
  if (functionScopeInfo.functionIsClosure) {
    if (functionScopeInfo.embeddedInParentSlot) {
      // Store the function pointer in the first closure slot, to make the
      // function properly executable.
      addOp(cur, 'StoreScoped', indexOperand(0));
      addOp(cur, 'LoadReg', nameOperand('closure'));
    } else {
      addOp(cur, 'ClosureNew');
    }
  }

  compileFunction(cur, expression);
}

/** Returns a LazyValue of the value current at the top of the stack */
function valueAtTopOfStack(cur: Cursor): LazyValue {
  const indexOfValue = cur.stackDepth - 1;
  return LazyValue(cur => addOp(cur, 'LoadVar', indexOperand(indexOfValue)));
}

export function compileThisExpression(cur: Cursor, expression: B.ThisExpression) {
  const ref = cur.ctx.scopeAnalysis.references.get(expression) ?? unexpected();
  getSlotAccessor(cur, ref.access, true, 'this').load(cur);
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
    // TODO: It would be pretty easy to add support for methods and computed
    // property names here.
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

export function compileNewExpression(cur: Cursor, expression: B.NewExpression) {
  const callee = expression.callee;
  if (callee.type === 'Super') {
    return compileError(cur, 'Reserved word "super" invalid in this context');
  }
  if (callee.type === 'V8IntrinsicIdentifier') {
    return compileError(cur, 'Intrinsics not supported');
  }

  compileExpression(cur, callee);

  // Placeholder for `this`. The value is not used, but the `New` instruction
  // will use this slot for the constructed object
  addOp(cur, 'Literal', literalOperand(undefined));

  for (const arg of expression.arguments) {
    if (!B.isExpression(arg)) compileError(cur, 'Argument must be an expression', arg);
    compileExpression(cur, arg);
  }

  addOp(cur, 'New', countOperand(expression.arguments.length + 1)); // +1 is for the object reference
}

export function compileCallExpression(cur: Cursor, expression: B.CallExpression, isVoidCall: boolean, isAwaitCall: boolean) {
  const callee = expression.callee;
  if (callee.type === 'Super') {
    return compileError(cur, 'Reserved word "super" invalid in this context');
  }
  // Where to put the result of the call
  const indexOfResult = cur.stackDepth;
  const finalStackLevel = cur.stackDepth + (isVoidCall ? 0 : 1);

  if (callee.type === 'MemberExpression') {
    // Reserve a slot for the function reference, since this needs to be first in a Call operation
    const indexOfFunctionReference = cur.stackDepth;
    addOp(cur, 'Literal', literalOperand(undefined));

    const indexOfObjectReference = cur.stackDepth;
    compileExpression(cur, callee.object); // The first IL parameter is the object instance
    // Fetch the property on the object that represents the function to be called
    compileDup(cur);
    if (callee.computed) {
      compileExpression(cur, callee.property);
    } else {
      const property = callee.property;
      // Since the callee property is not computed, I expect it to be an identifier
      if (property.type !== 'Identifier') unexpected('Expected an identifier');
      addOp(cur, 'Literal', literalOperand(property.name));
    }
    addOp(cur, 'ObjectGet');
    addOp(cur, 'StoreVar', indexOperand(indexOfFunctionReference));
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

  const ilArgCount = expression.arguments.length + 1; // +1 is for the object reference

  if (isAwaitCall) {
    addOp(cur, 'AwaitCall', countOperand(ilArgCount));
  } else {
    addOp(cur, 'Call', countOperand(ilArgCount), flagOperand(isVoidCall));
  }

  if (cur.stackDepth > finalStackLevel) {
    // Await-calls can't be followed by anything else before the Await
    // instruction.
    hardAssert(!isAwaitCall);

    if (!isVoidCall) {
      // Some things need to be popped off the stack, but we need the result to be underneath them
      addOp(cur, 'StoreVar', indexOperand(indexOfResult));
    }
    const remainingToPop = cur.stackDepth - finalStackLevel;
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
    // Note: an easy way to support this is by a transpiler plugin (https://babeljs.io/docs/en/babel-plugin-proposal-nullish-coalescing-operator)
    featureNotSupported(cur, 'Nullish coalescing operator', expression)
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

function getObjectMemberAccessor(cur: Cursor, object: LazyValue, property: string | LazyValue): ValueAccessor {
  const propertyKey = typeof property === 'string'
    ? LazyValue(cur => addOp(cur, 'Literal', literalOperand(property)))
    : property;

  return {
    load(cur: Cursor) {
      object.load(cur);
      propertyKey.load(cur);
      addOp(cur, 'ObjectGet');
    },
    store(cur: Cursor, value: LazyValue) {
      object.load(cur);
      propertyKey.load(cur);
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
      case 'Binding': return getSlotAccessor(cur, reference.access, resolvesTo.binding.isDeclaredReadonly && !opts?.forInitialization, resolvesTo.binding.name);
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
export function getSlotAccessor(cur: Cursor, slotAccess: SlotAccessInfo, readonly: boolean = false, nameHint?: string): ValueAccessor {
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
          const op = addOp(cur, 'LoadVar', indexOperand(slotAccess.index));
          op.nameHint = nameHint;
        },
        store(cur: Cursor, value: LazyValue) {
          hardAssert(slotAccess.index < cur.stackDepth);

          if (readonly) {
            return compileError(cur, 'Cannot assign to constant');
          }

          value.load(cur);
          const op = addOp(cur, 'StoreVar', indexOperand(slotAccess.index));
          op.nameHint = nameHint;
        }
      };
    }

    case 'ClosureSlotAccess': {
      return {
        load(cur: Cursor) {
          const op = addOp(cur, 'LoadScoped', indexOperand(slotAccess.relativeIndex));
          op.nameHint = nameHint;
        },
        store(cur: Cursor, value: LazyValue) {
          value.load(cur);
          const op = addOp(cur, 'StoreScoped', indexOperand(slotAccess.relativeIndex));
          op.nameHint = nameHint;
        }
      }
    }

    case 'ConstUndefinedAccess': return getConstantAccessor(undefined);

    case 'ArgumentSlot': {
      return {
        load(cur: Cursor) {
          const op = addOp(cur, 'LoadArg', indexOperand(slotAccess.argIndex));
          op.nameHint = nameHint;
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
  let updaterOp: Procedure;
  switch (expression.operator) {
    case '++': updaterOp = cur => compileIncr(cur); break;
    case '--': updaterOp = cur => compileDecr(cur); break;
    default: updaterOp = assertUnreachable(expression.operator);
  }

  let accessor: ValueAccessor;
  const argument = expression.argument;

  if (argument.type === 'Identifier') {
    // Simple variable increment like i++
    accessor = accessVariable(cur, argument);
  } else if (argument.type === 'MemberExpression') {
    // Member increment like `this.x.b.c++`

    // Note: this is implemented in a kinda "cheating" way because the whole
    // object expression is used twice. So I'm checking that it doesn't have any
    // side effects. Microvium doesn't support property getters and setters, so
    // the property access itself doesn't have side effects unless it's
    // computed, so this checks that there are no computed accesses. A more
    // general implementation that doesn't have this restriction would
    // necessarily involve using a temporary on the stack, but I don't have time
    // right now to deal with that and it probably won't add a ton of value to
    // the engine. It would be nice to deal with though,

    // TODO: it would be good to revisit this and get it working in the general
    // case. E.g. for cases like `x[i++]++`.

    if (argument.computed) featureNotSupported(cur, 'Member access with computed key', argument.property)
    // It doesn't make sense for a non-computed property to be anything but an identifier
    if (argument.property.type !== 'Identifier') unexpected();

    const propertyName = argument.property.name;
    let object = argument.object;
    while (object.type === 'MemberExpression') {
      if (object.computed) featureNotSupported(cur, 'Member access with computed key', object.property)
      object = object.object;
    }
    // The LHS should bottom out at a variable or `this` access
    if (object.type !== 'Identifier' && object.type !== 'ThisExpression') {
      return featureNotSupported(cur, `Member access on computed expression`, object)
    }

    accessor = getObjectMemberAccessor(cur,
      LazyValue(cur => compileExpression(cur, argument.object)),
      LazyValue(cur => addOp(cur, 'Literal', literalOperand(propertyName)))
    )
  } else {
    return featureNotSupported(cur, `Not supported as the target of an increment/decrement: ${argument.type}`, argument)
  }

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
  // If it's already associated, we don't want to repeat the side effects of
  // this function (i.e. associating comments)
  if (cur.node === node) {
    return;
  }
  // Note: there can be multiple nodes that precede the generation of an
  // instruction, and this just uses the comment from the last node, which seems
  // "good enough"
  if (node.leadingComments) {
    cur.commentNext = node.leadingComments.map(c => c.value.trim());
  }
  visitingNode(cur, node);
}

export function compilingEndOfNode(cur: Cursor, node: B.Node) {
  cur.node = node;
  cur.endOfNode = true;
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

    const slot = accessVariable(cur, d.id, { forInitialization: true });
    const initialValue = LazyValue(cur => d.init
      ? compileExpression(cur, d.init)
      : addOp(cur, 'Literal', literalOperand(undefined))
    );
    slot.store(cur, initialValue);
  }
}

function enterScope(cur: Cursor, scope: Scope, opts?: { catchTarget?: IL.Block, stackDepth?: number }): ScopeHelper {
  const stackDepthAtEntry = cur.stackDepth;

  const helper: ScopeHelper = {
    leaveScope(cur: Cursor, currentOperation: 'break' | 'return' | 'normal') {
      if (currentOperation === 'normal') {
        scope.node && compilingEndOfNode(cur, scope.node);
      }
      if (cur.reachable) {
        // Expecting the stack to be balanced
        if (currentOperation !== 'return') {
          hardAssert(cur.stackDepth === stackDepthAfterProlog);
        }

        // Note: I'm only compiling the epilogue for block-level scopes because
        // function scopes already pop everything at runtime when they `return`,
        // except EndTry which should not be at the function level
        if (scope.type === 'BlockScope') {
          compileBlockEpilogue(cur, scope, currentOperation);

          // Check that we're back to the entry stack depth
          if (currentOperation !== 'return') {
            hardAssert(cur.stackDepth === stackDepthAtEntry)
          }
        } else {
          hardAssert(scope.epilogue.every(step => step.type !== 'EndTry'))
        }
      } else {
        // This is a hack. The end of the block is unreachable, so it shouldn't
        // matter what the stack depth is, but for all the things that are
        // checking for a balanced stack, they will care that we restore the
        // original stack depth
        cur.stackDepth = stackDepthAtEntry;
      }

      // Pop scope stack
      hardAssert(cur.scopeStack === newScopeStack);
      cur.scopeStack = cur.scopeStack!.parent;
    }
  };

  const newScopeStack: ScopeStack = { helper, scope, parent: cur.scopeStack, catchTarget: opts?.catchTarget, stackDepth: opts?.stackDepth ?? cur.stackDepth }
  // Push scope stack
  cur.scopeStack = newScopeStack;

  scope.node && compilingNode(cur, scope.node);
  compilePrologue(cur, scope.prologue);

  const stackDepthAfterProlog = cur.stackDepth;

  return helper;
}

export function computeMaximumStackDepth(func: IL.Function) {
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

function getContainingFunction(cur: Cursor) {
  let scope = cur.scopeStack;
  while (scope && scope.scope.type === 'BlockScope') {
    scope = scope.parent;
  }
  return scope?.scope;
}

function findAwaitPoints(unit: IL.Unit) {
  const awaitPoints: IL.Operation[] = [];
  for (const func of Object.values(unit.functions)) {
    for (const block of Object.values(func.blocks)) {
      for (const op of block.operations) {
        if (op.opcode === 'Await') {
          awaitPoints.push(op);
        }
      }
    }
  }
  return awaitPoints;
}