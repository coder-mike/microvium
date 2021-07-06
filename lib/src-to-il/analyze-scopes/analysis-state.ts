import { ScopeNode, Scope, VariableReferenceInfo, Binding, FunctionScope, BindingNode, ImportSpecifier, ModuleSlot, ReferencingNode } from "./analysis-model";
import * as B from '../supported-babel-types';
import { SourceCursor } from "../common";

export interface AnalysisState {
  file: B.File;
  cur: SourceCursor;
  scopes: Map<ScopeNode, Scope>;
  references: Map<ReferencingNode, VariableReferenceInfo>;
  freeVariableNames: Set<string>;
  bindingIsClosureAllocated: Set<Binding>;
  importBindingInfo: Map<Binding, { source: string, specifier: ImportSpecifier }>;
  exportedBindings: Map<Binding, B.ExportNamedDeclaration>;
  functionInfo: Map<FunctionScope, B.SupportedFunctionNode>;
  bindings: Map<BindingNode, Binding>;
  thisModuleSlot: ModuleSlot;
  importedModuleNamespaceSlots: Map<string, ModuleSlot>;

  // Function declarations have a `this` binding (which translates to the first
  // IL parameter). Arrow functions do not (they fall back to their parent's
  // `this` binding)
  thisBindingByScope: Map<FunctionScope, Binding>;
}