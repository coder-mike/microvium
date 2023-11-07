import { unexpected, assertUnreachable, hardAssert, uniqueNameInSet } from "../../utils";
import { visitingNode } from "../common";
import { ModuleScope, GlobalSlot, Binding, Slot, FunctionScope, ClosureSlot, Scope, LocalSlot, SlotAccessInfo, EpilogueStep, ClassScope, BlockScope } from "./analysis-model";
import { AnalysisState } from "./analysis-state";

export function pass2_computeSlots({
  file,
  cur,
  importedModuleNamespaceSlots,
  importBindings,
  model,
  awaitStackDepths,
}: AnalysisState) {
  /*
  This function calculates the size of each closure scope, and the index of each
  variable in the closure scope.

  The structure of this implementation is:

      computeModuleSlots
        computeFunctionSlots
          computeBlockLikeSlots

  For the module, `computeModuleSlots` deals with global variables and
  import/exports before deferring to `computeFunctionSlots` which deals with all
  remaining function-level declarations before in turn deferring to
  `computeBlockLikeSlots` for all the lexical declarations (for the module
  scope). `computeBlockLikeSlots` then recurses on the children scopes, which
  may be functions or blocks.
  */

  const { scopes, globalSlots, freeVariables } = model;

  const root = scopes.get(file.program) || unexpected();
  visitingNode(cur, file);
  if (root.type !== 'ModuleScope') unexpected();
  // Recurse the tree starting at the root
  computeModuleSlots(root);

  function computeModuleSlots(moduleScope: ModuleScope) {
    const globalSlotNames = new Set([...freeVariables]);
    const newGlobalSlot = (nameHint: string): GlobalSlot => {
      // Note: the generated names can't conflict with existing module names
      // OR free variable names since we use the same IL instruction to load
      // both.
      const name = uniqueNameInSet(nameHint, globalSlotNames);
      const slot: GlobalSlot = { type: 'GlobalSlot', name };
      globalSlots.push(slot);
      return slot;
    };

    // TODO: It would make a lot of sense if the "thisModule" slot was also just
    // an external linking reference, like with imports
    model.thisModuleSlot = newGlobalSlot('thisModule');

    const getImportedModuleNamespaceSlot = (source: string) => {
      let slot = importedModuleNamespaceSlots.get(source);
      if (!slot) {
        const name = uniqueNameInSet(source, globalSlotNames);
        slot = { type: 'GlobalSlot', name };
        importedModuleNamespaceSlots.set(source, slot);
        model.moduleImports.set(source, slot);
      }
      return slot;
    };

    // Root-level bindings
    for (const binding of Object.values(moduleScope.bindings)) {
      binding.slot = computeModuleSlot(binding);
    }

    // Compute entry-function slots (this will skip any bindings that already
    // have slots assigned, such as module slots)
    computeFunctionSlots(moduleScope);

    return;

    function computeModuleSlot(binding: Binding): Slot | undefined {
      if (importBindings.has(binding)) {
        return computeImportBindingSlot(binding);
      } else if (binding.isExported) {
        return computeExportBindingSlot(binding);
      } else if (binding.isAccessedByNestedFunction) {
        // Note: We only need to allocate a global slot if the variable is
        // accessed by a nested function, otherwise it can just be a local
        // variable in the module entry function
        return newGlobalSlot(binding.name);
      } else {
        // Fall back to normal function variable behavior
        return undefined;
      }
    }

    function computeImportBindingSlot(binding: Binding): Slot {
      const { source, specifier } = importBindings.get(binding) ?? unexpected();
      const moduleNamespaceObjectSlot = getImportedModuleNamespaceSlot(source);

      switch (specifier.type) {
        // import x as y from 'z'
        case 'ImportSpecifier':
          return {
            type: 'ModuleImportExportSlot',
            moduleNamespaceObjectSlot,
            propertyName:
              specifier.imported.type === 'Identifier' ? specifier.imported.name :
              specifier.imported.type === 'StringLiteral' ? specifier.imported.value :
              assertUnreachable(specifier.imported)
          };

        // import * as y from 'z';
        case 'ImportNamespaceSpecifier':
          return moduleNamespaceObjectSlot;

        // import y from 'z';
        case 'ImportDefaultSpecifier':
          return {
            type: 'ModuleImportExportSlot',
            moduleNamespaceObjectSlot,
            propertyName: 'default'
          };

        default: assertUnreachable(specifier);
      }
    }

    function computeExportBindingSlot(binding: Binding): Slot {
      return {
        type: 'ModuleImportExportSlot',
        moduleNamespaceObjectSlot: model.thisModuleSlot,
        propertyName: binding.name
      }
    }
  }

  // Note: this function takes either FunctionScope or ModuleScope because it
  // is also used to compute slots for the entry function. Essentially, we
  // treat the module as a special kind of function that also has module
  // slots.
  function computeFunctionSlots(functionScope: FunctionScope | ModuleScope | ClassScope) {
    let stackDepth = 0;

    const pushLocalSlot = (debugName: string): LocalSlot => ({ type: 'LocalSlot', index: stackDepth++, debugName });

    const nextClosureSlot = (debugName: string) => {
      functionScope.closureSlots = functionScope.closureSlots ?? [];
      const slot: ClosureSlot = { type: 'ClosureSlot', index: functionScope.closureSlots.length, debugName };
      functionScope.closureSlots.push(slot);
      return slot;
    };

    // Compute slots for nested functions and variables and recurse
    computeBlockLikeSlots(functionScope, nextClosureSlot);

    // Compute slots in a block-like scope (including lexical slots in a
    // function, but not things like parameter slots or `var` declarations which
    // are handled at the function level)
    function computeBlockLikeSlots(
      blockScope: Scope,
      nextClosureSlotInParent: (debugName: string) => ClosureSlot
    ) {
      /*
       * Note: this function actually deals with function scopes as well, since
       * the function body is like a block.
       *
       * Within a block, there are slots for:
       *
       *  - nested function declarations (which are hoisted to the beginning of
       *    the block, not necessarily the beginning of the containing function)
       *  - lexical bindings (let and const)
       *  - exception binding, if the block is a catch handler
       */

      if (blockScope.isAsyncFunction) {
        // Synchronous return value (engine assumes this is the first slot in the frame)
        stackDepth === 0 || unexpected();
        pushLocalSlot('syncReturnValue');

        // Space for async catch target. This will physically be realized with
        // the AsyncStart instruction.
        stackDepth += 2;

        // Function pointer that continues the current async function
        nextClosureSlot('async-continuation');
        // The engine machinery always assumes the continuation is the first slot
        hardAssert(functionScope.closureSlots?.length === 1);

        // Function pointer that references the callback to invoke when the current async function completes.
        nextClosureSlot('async-callback');

        // If we know the stack depth at all the await points, we use that to
        // calculate how many slots need to be reserved to preserve the stack
        // at the await points.
        if (awaitStackDepths) {
          let maxStackDepthAtAwait = undefined;
          for (const awaitExpr of functionScope.awaitExpressions) {
            const line = awaitExpr.loc?.start.line ?? unexpected();
            const col = (awaitExpr.loc?.start.column ?? unexpected()) + 1;
            const depthAtAwait = awaitStackDepths.get(`${line}:${col}`) ?? unexpected();
            if (maxStackDepthAtAwait === undefined || depthAtAwait > maxStackDepthAtAwait) {
              maxStackDepthAtAwait = depthAtAwait;
            }
          }
          // It's possible that there are no await points
          if (maxStackDepthAtAwait !== undefined) {
            // Local slot 0 is the async return value, and slots 1 and 2 are
            // reserved for the async catch target. So the stack depth at the
            // await points should be 3. The await statements only need to
            // preserve the slots above these since the AsyncStart and
            // AsyncResume instructions set up the first 3 slots. The `-1` is
            // because the top of the stack holds the awaited value, which is
            // not part of what is preserved to the closure when the async
            // function is suspended.
            hardAssert(stackDepth === 3);
            const slotsRequired = maxStackDepthAtAwait - stackDepth - 1;
            for (let i = 0; i < slotsRequired; i++) {
              nextClosureSlot(`await-save-${i}`);
            }
          }
        }
      } else {
        // Note: can only use closure embedding in non-async functions, because
        // the async callback uses the same slot number (0) as embedded
        // closures.

        // The first nested function under this scope, with the same lifetime as
        // this scope, can be embedded in this scope.
        // See [Closure Embedding](../../../doc/internals/closure-embedding.md)
        const embeddingFunction = blockScope.embeddingCandidates.find(f => f.functionIsClosure);
        if (embeddingFunction) {
          // Reserve the first slot for the function pointer for this closure
          const embeddedClosureSlot = nextClosureSlotInBlockOrParent(`embedded-closure:${embeddingFunction.funcName ?? 'anonymous'}`);
          blockScope.embeddedChildClosure = embeddingFunction;
          embeddingFunction.embeddedInParentSlot = embeddedClosureSlot;
        }
      }

      computeIlParameterSlots(blockScope, nextClosureSlotInBlockOrParent, pushLocalSlot);

      const isTryScope = 'isTryScope' in blockScope && blockScope.isTryScope;
      const stackDepthBeforeStartTry = stackDepth;

      if (isTryScope) {
        blockScope.prologue.push({ type: 'StartTry' });
        stackDepth += 2;
      }

      const blockStartStackDepth = stackDepth;
      let expectedVariablePopCount = 0;

      const isCatchScope = 'isCatchScope' in blockScope && blockScope.isCatchScope;
      if (isCatchScope) {
        blockScope.prologue.push({ type: 'DummyPushException' })
        // The catch exception slot needs to be first because the `throw`
        // instruction pushes it onto the stack.
        if ('catchExceptionBinding' in blockScope) {
          const binding = blockScope.catchExceptionBinding!;

          // Allocate a slot for the exception variable. Note: if the exception
          // will be local, then `nextBlockLocalOrClosureSlot` increments the
          // stack depth to value that `throw` results in anyway, so we don't need
          // to add or subtract to `stackDepth` to compensate for the `throw`. If
          // the exception will be closure-allocated,
          // `nextBlockLocalOrClosureSlot` will not increment the stack depth so
          // it will be one slot lower than the actual entry to the `catch`, but
          // then we do the `InitCatchParam` below which pops exception into the
          // closure slot, thus bringing the stack depth to the correct value.
          binding.slot = nextBlockLocalOrClosureSlot(binding, binding.name);

          // The binding will either be a local or closure slot. If it's local
          // then it's already populated by the `throw` operation (which pushes
          // the exception to the top of the stack). If it's a closure-scoped
          // slot, we need to pop it off the top of the stack and put it into the
          // closure scope.
          if (binding.slot.type === 'ClosureSlot') {
            blockScope.prologue.push({
              type: 'InitCatchParam',
              slot: accessSlotForInitialization(binding.slot)
            })
          } else {
            hardAssert(binding.slot.type === 'LocalSlot');
            expectedVariablePopCount++;
          }
        } else {
          // Else, there is no binding, so we need to pop the catch parameter to
          // discard it
          blockScope.prologue.push({ type: 'DiscardCatchParam' })
        }
      }

      // Hoisted var declarations.
      //
      // Note: most var declarations will hoisted to the function level, but var
      // declarations inside a `catch` block are only hoisted as far as the
      // catch, not the function.
      for (const binding of blockScope.varDeclarations) {
        // Var declarations at the module level may already have global slots allocated
        if (binding.slot) continue;

        hardAssert(binding.kind === 'var');
        binding.slot = nextFunctionLocalOrClosureSlot(binding, binding.name);
        if (binding.slot) {
          blockScope.prologue.push({
            type: 'InitVarDeclaration',
            slot: accessSlotForInitialization(binding.slot)
          })
          if (binding.slot.type === 'LocalSlot') {
            expectedVariablePopCount++
          }
        }
      }

      // Nested function declarations
      for (const decl of blockScope.nestedFunctionDeclarations) {
        const { binding, func } = decl;

        // Function declarations at the module level may already have global slots allocated
        if (!binding.slot) {
          binding.slot = nextBlockLocalOrClosureSlot(binding, binding.name);
        }

        const functionInfo = model.scopes.get(func) ?? unexpected();
        if (functionInfo.type !== 'FunctionScope') unexpected();
        const functionId = functionInfo.ilFunctionId;

        if (binding.slot) {
          blockScope.prologue.push({
            type: 'InitFunctionDeclaration',
            functionId,
            closureType: functionInfo.functionIsClosure
              ? functionInfo.embeddedInParentSlot
                ? 'embedded'
                : 'non-embedded'
              : 'none',
            slot: accessSlotForInitialization(binding.slot)
          });
          if (binding.slot.type === 'LocalSlot') {
            expectedVariablePopCount++
          }
        }
      }

      // Lexical declarations
      for (const binding of blockScope.lexicalDeclarations) {
        // Lexical declarations at the module level may already have global slots allocated
        if (binding.slot) continue;

        binding.slot = nextBlockLocalOrClosureSlot(binding, binding.name);
        // Note: closure slots are already initialized when the scope is created
        if (binding.slot && binding.slot.type === 'LocalSlot') {
          blockScope.prologue.push({
            type: 'InitLexicalDeclaration',
            slot: accessSlotForInitialization(binding.slot),
            nameHint: binding.name,
          });
          expectedVariablePopCount++
        }
      }

      for (const child of blockScope.children) {
        switch (child.type) {
          case 'BlockScope': computeBlockLikeSlots(child, nextClosureSlotInBlockOrParent); break;
          case 'FunctionScope':
          case 'ClassScope':
            computeFunctionSlots(child); break;
          case 'ModuleScope': unexpected();
          default: assertUnreachable(child);
        }
      }

      // The parent reference slot is the last slot in the closure
      if (blockScope.closureSlots && blockScope.accessesParentScope) {
        nextClosureSlotInBlock('parent-reference');
      }

      // Now that all the slots have been computed, we know if there are any
      // closure slots that need to be created in the prologue
      if (blockScope.closureSlots) {
        blockScope.closureSlots.length >= 1 || unexpected();
        const slotCount = blockScope.closureSlots.length;
        if (blockScope.isAsyncFunction) {
          blockScope.prologue.unshift({
            type: 'AsyncStart',
            slotCount,
            captureParent: Boolean(blockScope.accessesParentScope)
          });
        } else /* not async function */ {
          if (blockScope.accessesParentScope) {
            blockScope.prologue.unshift({ type: 'ScopePush', slotCount })
            // Note: not required during a return because the return will restore the caller's scope.
            blockScope.epilogue.push({ type: 'ScopePop', requiredDuringReturn: false });
          } else {
            blockScope.prologue.unshift({ type: 'ScopeNew', slotCount })
            // Note: not required during a return because the return will restore the caller's scope.
            blockScope.epilogue.push({ type: 'ScopeDiscard', requiredDuringReturn: false })
          }
        }
      }

      // Note: we don't need to pop variables off the stack in a `try` block
      // because the `EndTry` already truncates the stack to the right level.
      if (blockScope.type === 'BlockScope' && !isTryScope) {
        const count = stackDepth - blockStartStackDepth;
        hardAssert(count === expectedVariablePopCount)
        if (count) {
          blockScope.epilogue.push({ type: 'Pop', requiredDuringReturn: false, count });
        }
      }

      stackDepth = blockStartStackDepth;

      if (isTryScope) {
        blockScope.epilogue.push({
          type: 'EndTry',
          requiredDuringReturn: true,
          stackDepthAfter: stackDepthBeforeStartTry
        })
        stackDepth = stackDepthBeforeStartTry;
      }

      function nextBlockLocalOrClosureSlot(binding: Binding, debugName: string): LocalSlot | ClosureSlot {
        hardAssert(!binding.slot);

        if (binding.isAccessedByNestedFunction) {
          return nextClosureSlotInBlockOrParent(debugName);
        } else {
          // Note that variables from multiple successive blocks can share the same local slot
          return pushLocalSlot(debugName);
        }
      }

      function nextClosureSlotInBlockOrParent(debugName: string): ClosureSlot {
        // If this is a block with the same lifetime as its parent block or
        // function, we can optimize by storing variables in the parent
        if (blockScope.sameInstanceCountAsParent) {
          return nextClosureSlotInParent(debugName);
        } else {
          return nextClosureSlotInBlock(debugName);
        }
      }

      function nextClosureSlotInBlock(debugName: string) {
        blockScope.closureSlots = blockScope.closureSlots ?? [];
        const slot: ClosureSlot = { type: 'ClosureSlot', index: blockScope.closureSlots.length, debugName };
        blockScope.closureSlots.push(slot);
        return slot;
      }
    }

    function nextFunctionLocalOrClosureSlot(binding: Binding, debugName: string): LocalSlot | ClosureSlot {
      hardAssert(!binding.slot);

      if (binding.isAccessedByNestedFunction) {
        return nextClosureSlot(debugName);
      } else {
        // Note that variables from multiple successive blocks can share the same local slot
        return pushLocalSlot(debugName);
      }
    }
  }
}

function computeIlParameterSlots(
  scope: Scope,
  nextClosureSlot: (debugName: string) => ClosureSlot,
  pushLocalSlot: (debugName: string) => LocalSlot
) {
  // Function declarations introduce a new lexical `this` into scope,
  // whereas arrow functions do not (the lexical this falls through to the
  // parent).
  const thisBinding = scope.thisBinding;

  if (thisBinding) {
    // The `this` binding is never writtenTo, so it never needs to be copied
    // into a local variable slot. But if it's used by a child (e.g. arrow
    // function) then it needs initialization to copy it from `LoadArg` to
    // `StoreScoped`.
    hardAssert(!thisBinding.isWrittenTo);
    if (thisBinding.isAccessedByNestedFunction || (scope.isAsyncFunction && thisBinding.isUsed)) {
      thisBinding.slot = nextClosureSlot('this');
      scope.prologue.push({
        type: 'InitThis',
        slot: accessSlotForInitialization(thisBinding.slot)
      });
    } else {
      // Here, there's no need for initialization
      // (ilParameterInitializations) since it won't be copied into a
      // parameter slot.
      thisBinding.slot = {
        type: 'ArgumentSlot',
        argIndex: 0
      }
    }
  }

  // Note: this function is actually called at the block level, not the function
  // level, but most blocks will have an empty parameter bindings list. The
  // exception to the rule is constructor functions which are functions in the
  // source text but manifest as *blocks* inside a larger "physical constructor
  // functions" inside the IL.

  // Compute slots for the named parameters of the function
  for (const [paramI, binding] of scope.parameterBindings.entries()) {
    // Note: `LoadArg(0)` always refers to the caller-passed `this` value
    const argIndex = paramI + 1;
    if (binding.isAccessedByNestedFunction || scope.isAsyncFunction) {
      binding.slot = nextClosureSlot(binding.name);
      scope.prologue.push({
        type: 'InitParameter',
        argIndex,
        slot: accessSlotForInitialization(binding.slot)
      })
    } else if (binding.isWrittenTo) {
      // In this case, the binding is writable but not in the closure
      // scope. We need an initializer to copy the initial argument value
      // into the parameter slot
      binding.slot = pushLocalSlot(binding.name);
      scope.prologue.push({
        type: 'InitParameter',
        argIndex,
        slot: binding.slot
      })
    } else {
      // In this case, the parameter is used but never mutated so it can
      // directly use LoadArg. We don't need any new prologue steps
      // because the arguments are already in these slots when the
      // function runs
      binding.slot = { type: 'ArgumentSlot', argIndex };
    }
  }
}

/**
 * Gives an accessor for a slot for the purposes of initializing the slot.
 */
function accessSlotForInitialization(slot: Slot): SlotAccessInfo {
  if (slot.type === 'ClosureSlot') {
    return {
      type: 'ClosureSlotAccess',
      relativeIndex: slot.index
    }
  }
  return slot;
}