import { Binding, FunctionScope, ImportSpecifier, GlobalSlot, AnalysisModel } from "./analysis-model";
import * as B from '../supported-babel-types';
import { SourceCursor } from "../common";

export interface AnalysisState {
  model: AnalysisModel;

  file: B.File;
  cur: SourceCursor;
  importBindings: Map<Binding, { source: string, specifier: ImportSpecifier }>;
  functionInfo: Map<FunctionScope, B.SupportedFunctionNode>;
  thisModuleSlot: GlobalSlot;
  importedModuleNamespaceSlots: Map<string, GlobalSlot>;
}