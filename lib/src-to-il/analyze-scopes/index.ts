import { unexpected } from '../../utils';
import * as B from '../supported-babel-types';
import { ScopesInfo, ScopeNode, Scope, VariableReferenceInfo, Binding, FunctionScope, BindingNode, ModuleSlot } from './analysis-model';
import { AnalysisState } from './analysis-state';
import { pass1_findScopesAndBindings } from './pass-1-find-scopes-and-bindings';
import { pass2_computeSlots } from './pass-2-compute-slots';
import { pass3_computeSlotAccessors } from './pass-3-compute-accessors';

export * from './analysis-model';

/*
This does analysis of scopes and variables.

  - Resolve identifiers to their corresponding declarations (bindings).
  - Calculate how many variables are in each scope and assign indexes to each of
    them.
  - Compute closure information

In some ways, this basically returns a declarative representation of how all the
variables declarations and references must be emitted (including things like
parameters and function declarations).
*/
export function analyzeScopes(file: B.File, filename: string): ScopesInfo {
  /*
  This function works in 3 passes with a "blackboard" design pattern. Each pass
  populates or uses information from the `analysisState` model which contains
  both intermediate information and final output information
  */

  const analysisState: AnalysisState = {
    file,
    cur: { filename, node: file },
    scopes: new Map<ScopeNode, Scope>(),
    references: new Map<B.Identifier, VariableReferenceInfo>(),
    freeVariableNames: new Set<string>(),
    bindingIsClosureAllocated: new Set<Binding>(),
    importBindingInfo: new Map<Binding, { source: string, specifier: B.ImportSpecifier }>(),
    exportedBindings: new Map<Binding, B.ExportNamedDeclaration>(),
    functionInfo: new Map<FunctionScope, B.SupportedFunctionNode>(),
    bindings: new Map<BindingNode, Binding>(),
    thisModuleSlot: undefined as any,// Populated in pass2_computeSlots
    importedModuleNamespaceSlots: new Map<string, ModuleSlot>(), // Populated in pass2_computeSlots
    thisBindingByScope: new Map<FunctionScope, Binding>()
  };

  /*
  # Pass 1: Find scopes and bindings

  Iterate the AST and build up a hierarchy of scopes and their bindings
  (`ScopeBase.bindings`), and calculate references from variable identifiers to
  the corresponding binding. This also marks which variables need to be
  closure-allocated (via the `bindingIsClosureAllocated` set) and which
  functions need to be closures. The scopes from this pass are only partially
  populated.
  */
  pass1_findScopesAndBindings(analysisState);
  const root = analysisState.scopes.get(file.program) || unexpected();

  /*
  # Pass 2: Compute slots

  Generate slots for all used bindings, based on metadata collected from the
  first pass. This needs to be a second pass because we can't predict ahead of
  time in a single pass which variables will need to be closure-allocated.
  */
  pass2_computeSlots(analysisState);

  /*
  # Pass 3: Compute slot accessors

  A reference from a variable name to a corresponding slot in a closure scope
  will need to be emitted as `LoadScoped` with an operand of the relative index
  of the slot. This can only be computed now that we have all the slot
  information calculated.
  */
  pass3_computeSlotAccessors(analysisState);


  if (root.type !== 'ModuleScope') return unexpected();

  return {
    scopes: analysisState.scopes,
    references: analysisState.references,
    bindings: analysisState.bindings,
    moduleScope: root,
    freeVariables: [...analysisState.freeVariableNames],
    thisModuleSlot: analysisState.thisModuleSlot,
    moduleImports: [...analysisState.importedModuleNamespaceSlots]
      .map(([specifier, slot]) => ({ slot, specifier }))
  };
}