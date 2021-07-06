import { VariableReferenceInfo, SlotAccessInfo } from "./analysis-model";
import { unexpected, hardAssert, assertUnreachable } from "../../utils";
import { AnalysisState } from "./analysis-state";

export function pass3_computeSlotAccessors(state: AnalysisState) {
  /*
  The instructions LoadScoped and StoreScoped take a _relative_ index, that in
  some sense "overflows" from the current scope into the parent scope. This
  function computes the relative indices.
  */

  const {
    references,
  } = state;

  for (const reference of references.values()) {
    reference.access = getAccessForReference(reference);
  }

  function getAccessForReference(reference: VariableReferenceInfo): SlotAccessInfo {
    // In some cases, earlier passes can determine the access method more
    // accurately (search for `UndefinedAccess`)
    if (reference.access) {
      return reference.access;
    }

    const binding = reference.binding;

    // If there's no binding then this is a free variable
    if (!binding) {
      return {
        type: 'GlobalSlotAccess',
        name: reference.name
      };
    }

    const slot = binding.slot;
    // Slots are only undefined if there's no reference. But of course, we've
    // found this binding from a reference so it shouldn't be undefined.
    if (!slot) unexpected();

    switch (slot.type) {
      case 'LocalSlot': return { type: 'LocalSlotAccess', index: slot.index };
      case 'ModuleSlot': return { type: 'GlobalSlotAccess', name: slot.name };
      case 'ArgumentSlot': return { type: 'ArgumentSlotAccess', index: slot.argIndex };
      case 'ModuleImportExportSlot': return {
        type: 'ModuleImportExportSlotAccess',
        moduleNamespaceObjectSlotName: slot.moduleNamespaceObjectSlot.name,
        propertyName: slot.propertyName
      }
      case 'ClosureSlot': {
        // Start at the nearest scope and work backwards
        let scope = reference.nearestScope;
        const targetScope = binding.scope;
        let relativeIndex = 0;
        // While we're not in the scope containing the variable, move to the parent scope
        while (scope !== targetScope) {
          if (scope.type === 'FunctionScope') {
            if (scope.closureSlots) {
              relativeIndex += scope.closureSlots.length;
            }
            // In order for us to hop from the child to the parent function,
            // we'll need to have a reference to the parent scope at runtime,
            // which means the function we're hopping from must itself be a
            // closure.
            hardAssert(scope.functionIsClosure);
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