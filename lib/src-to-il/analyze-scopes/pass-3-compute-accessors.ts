import { Reference, SlotAccessInfo } from "./analysis-model";
import { unexpected, hardAssert, assertUnreachable } from "../../utils";
import { AnalysisState } from "./analysis-state";

export function pass3_computeSlotAccessors(state: AnalysisState) {
  /*
  The instructions LoadScoped and StoreScoped take a _relative_ index, that in
  some sense "overflows" from the current scope into the parent scope. This
  function computes the relative indices.
  */

  const {
    model: { references },
  } = state;

  for (const reference of references.values()) {
    reference.access = getAccessForReference(reference);
  }

  function getAccessForReference(reference: Reference): SlotAccessInfo {
    hardAssert(!reference.access)

    const resolvesTo = reference.resolvesTo;

    if (resolvesTo.type === 'FreeVariable') {
      return {
        type: 'GlobalSlot',
        name: resolvesTo.name,
      }
    }

    if (resolvesTo.type === 'RootLevelThis') {
      // A `this` reference that hits the root scope without finding a binding must just be represented as `undefined`
      return {
        type: 'ConstUndefinedAccess'
      }
    }

    // Otherwise, the reference resolves to a binding
    const binding = resolvesTo.binding;
    hardAssert(binding);

    // All bindings must have slots if they are used, and we're in this function
    // because the binding is used (it has a reference to it). Note that the
    // definition of "used" here is quite conservative. In the current
    // implementation, all bindings with a self-reference are considered to be
    // "used" since they have a reference to themselves. The only bindings that
    // can be "unused" are the parameters
    const slot = binding.slot;
    if (!slot) unexpected();

    switch (slot.type) {
      case 'LocalSlot': return slot;
      case 'GlobalSlot': return slot;
      case 'ArgumentSlot': return slot;
      case 'ModuleImportExportSlot': return slot;
      case 'ClosureSlot': {
        // Start at the nearest scope and work backwards
        let scope = reference.nearestScope;
        const targetScope = binding.scope;

        let relativeIndex = 0;

        // While we're not in the scope containing the variable, move to the parent scope
        while (scope !== targetScope) {
          if (!scope.sameInstanceCountAsParent) {
            if (scope.closureSlots) {
              relativeIndex += scope.closureSlots.length;
            }
            // In order for us to hop from the child to the parent function,
            // we'll need to have a reference to the parent scope at runtime,
            // which means the function we're hopping from must itself be a
            // closure.
            hardAssert(scope.type !== 'FunctionScope' || scope.functionIsClosure);
          }
          scope = scope.parent || unexpected();
        }
        relativeIndex += slot.index;

        return {
          type: 'ClosureSlotAccess',
          relativeIndex
        }
      }
      default: assertUnreachable(slot);
    }
  }
}