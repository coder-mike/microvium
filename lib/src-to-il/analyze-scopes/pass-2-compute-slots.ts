import { unexpected, uniqueName, assertUnreachable, hardAssert } from "../../utils";
import { visitingNode, compileError } from "../common";
import { ModuleScope, ModuleSlot, Binding, Slot, FunctionScope, ClosureSlot, Scope } from "./analysis-model";
import { AnalysisState } from "./analysis-state";

export function pass2_computeSlots(state: AnalysisState) {
  /*
  This function calculates the size of each closure scope, and the index of
  each variable in the closure scope.

  Closure scopes are associated with functions, not lexical scopes, so
  multiple lexical scopes can live in the same closure scope. Originally I
  thought that these could stack up such that the same slot could be reused by
  multiple lexical variables if they existed in different blocks. However,
  since closure variables outlive the execution of their block, this doesn't
  make sense.

  The new algorithm just just assigns a new slot for each variable.
  */

  const {
    scopes,
    file,
    cur,
    freeVariableNames,
    importedModuleNamespaceSlots,
    importBindingInfo,
    exportedBindings,
    bindingIsClosureAllocated,
    functionInfo,
    thisBindingByScope,
    bindings,
  } = state;

  const root = scopes.get(file.program) || unexpected();
  visitingNode(cur, file);
  if (root.type !== 'ModuleScope') unexpected();
  computeModuleSlots(root);

  function computeModuleSlots(moduleScope: ModuleScope) {
    moduleScope.moduleSlots = [];

    const slotNames = new Set<string>();
    const newModuleSlot = (nameHint: string): ModuleSlot => {
      // Note: the generated names can't conflict with existing module names
      // OR free variable names since we use the same IL instruction to load
      // both.
      const name = uniqueName(nameHint, n => slotNames.has(n) || freeVariableNames.has(n));
      slotNames.add(name);
      const slot: ModuleSlot = { type: 'ModuleSlot', name };
      moduleScope.moduleSlots.push(slot);
      return slot;
    };

    // WIP: since ModuleScope now also has ilParameters, it might make sense
    // to have `thisModuleSlot` as an IL parameter with a module-level slot as
    // its target.
    state.thisModuleSlot = newModuleSlot('thisModule');

    const getImportedModuleNamespaceSlot = (moduleSource: string) => {
      let slot = importedModuleNamespaceSlots.get(moduleSource);
      if (!slot) {
        slot = newModuleSlot(moduleSource);
        importedModuleNamespaceSlots.set(moduleSource, slot);
      }
      return slot;
    };

    // Root-level bindings
    for (const binding of Object.values(moduleScope.bindings)) {
      if (binding.isUsed)
        binding.slot = computeModuleSlot(binding);
    }

    // Compute entry-function slots (this will skip any bindings that already
    // have slots assigned, such as module slots)
    computeFunctionSlots(moduleScope);

    function computeModuleSlot(binding: Binding): Slot {
      if (importBindingInfo.has(binding)) {
        return computeImportBindingSlot(binding);
      } else if (exportedBindings.has(binding)) {
        return computeExportBindingSlot(binding);
      } else {
        return newModuleSlot(binding.name);
      }
    }

    function computeImportBindingSlot(binding: Binding): Slot {
      const { source, specifier } = importBindingInfo.get(binding) ?? unexpected();
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
      const exportedDeclaration = exportedBindings.get(binding) ?? unexpected();
      // WIP Does this cover both exported variables and function declarations? Would be good to add some unit tests
      if (exportedDeclaration.source || exportedDeclaration.specifiers.length) {
        return unexpected();
      }
      return {
        type: 'ModuleImportExportSlot',
        moduleNamespaceObjectSlot: state.thisModuleSlot,
        propertyName: binding.name
      }
    }
  }

  // Note: this function takes either FunctionScope or ModuleScope because it
  // is also used to compute slots for the entry function. Essentially, we
  // treat the module as a special kind of function that also has module
  // slots.
  function computeFunctionSlots(functionScope: FunctionScope | ModuleScope) {
    const closureSlots: ClosureSlot[] = [];
    functionScope.localSlots = [];

    const getLocalSlot = (index: number) =>
      functionScope.localSlots[index] ??= { type: 'LocalSlot', index };

    const nextLocalSlot = () => getLocalSlot(functionScope.localSlots.length);

    const nextClosureSlot = () => {
      const slot: ClosureSlot = { type: 'ClosureSlot', index: closureSlots.length };
      closureSlots.push(slot);
      // The function's closureSlots are undefined until we need at least one slot
      functionScope.closureSlots = closureSlots;
      return slot;
    };

    /*
    The `ilParameterInitializations` describes how the prelude of the function
    should initialize the parameter slots, if at all.

    Some parameters can be directly read as arguments using `LoadArg`, if the
    parameter is never assigned to.
    */
    functionScope.ilParameterInitializations = [];

    if (functionScope.type === 'FunctionScope') {
      // Function declarations introduce a new lexical `this` into scope,
      // whereas arrow functions do not (the lexical this falls through to the
      // parent).
      const thisBinding = thisBindingByScope.get(functionScope);

      if (thisBinding) {
        const isClosureAllocated = bindingIsClosureAllocated.has(thisBinding);

        // The `this` binding is never writtenTo, so it never needs to be copied
        // into a local variable slot. But if it's used by a child (e.g. arrow
        // function) then it needs initialization to copy it from `LoadArg` to
        // `StoreScoped`.
        hardAssert(!thisBinding.isWrittenTo);
        if (isClosureAllocated) {
          const slot = nextClosureSlot();
          functionScope.ilParameterInitializations.push({
            argIndex: 0,
            slot: {
              type: 'ClosureSlotAccess',
              relativeIndex: slot.index
            }
          });
        }
      }

      // Compute slots for the named parameters of the function
      const functionNode = functionInfo.get(functionScope) ?? unexpected();
      for (const [paramI, param] of functionNode.params.entries()) {
        visitingNode(cur, param);
        // The first pass already checked this
        if (param.type !== 'Identifier') unexpected();

        const binding = bindings.get(param) ?? unexpected();
        // We only need slots for named parameters
        if (binding.isUsed) {
          // Note: `LoadArg(0)` always refers to the caller-passed `this` value
          const argIndex = paramI + 1;

          if (bindingIsClosureAllocated.has(binding)) {
            binding.slot = nextClosureSlot();
            functionScope.ilParameterInitializations.push({
              argIndex,
              slot: {
                type: 'ClosureSlotAccess',
                relativeIndex: binding.slot.index
              }
            })
          } else if (binding.isWrittenTo) {
            // In this case, the binding is writable but not in the closure
            // scope. We need an initializer to copy the initial argument value
            // into the parameter slot
            binding.slot = nextLocalSlot();
            functionScope.ilParameterInitializations.push({
              argIndex,
              slot: {
                type: 'LocalSlotAccess',
                index: binding.slot.index
              }
            })
          } else {
            // In this case, the parameter is used but never mutated so it can
            // directly use LoadArg. We don't need any new
            // ilParameterInitializations because the arguments are already in
            // these slots when the function runs
            binding.slot = { type: 'ArgumentSlot', argIndex };
          }
        } else {
          // In this case, the parameter is completely unused, so we don't need
          // any slot for it
        }
      }
    }

    // Recurse tree
    computeFunctionSlotsInner(functionScope, functionScope.localSlots.length);

    function computeFunctionSlotsInner(inner: Scope, localSlotsUsed: number) {
      for (const binding of Object.values(inner.bindings)) {
        if (!binding.isUsed) continue;

        // The ModuleScope is mostly like a function scope, but with the
        // root-level slots being module slots or import/export slots. So the
        // way I've structured the code is that computeModuleSlots assigns
        // those module-specific slots and then computeFunctionSlots assigns
        // everything left at the module level. So here we can skip bindings
        // that already have a slot assigned.
        if (binding.slot) continue;

        if (bindingIsClosureAllocated.has(binding)) {
          binding.slot = nextClosureSlot();
        } else {
          const index = localSlotsUsed++;
          // Note that variables from multiple successive blocks can share the same local slot
          binding.slot = getLocalSlot(index);
        }
      }

      for (const child of inner.children) {
        switch (child.type) {
          // Blocks within the function still correspond to function slots
          case 'BlockScope': computeFunctionSlotsInner(child, localSlotsUsed); break;
          case 'FunctionScope': computeFunctionSlots(child); break;
          case 'ModuleScope': unexpected();
          default: assertUnreachable(child);
        }
      }
    }
  }
}