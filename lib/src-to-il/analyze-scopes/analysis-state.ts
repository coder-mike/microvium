import { Binding, ImportSpecifier, GlobalSlot, AnalysisModel } from "./analysis-model";
import * as B from '../supported-babel-types';
import { SourceCursor } from "../common";

export interface AnalysisState {
  model: AnalysisModel;

  file: B.File;
  cur: SourceCursor;
  importBindings: Map<Binding, { source: string, specifier: ImportSpecifier }>;
  importedModuleNamespaceSlots: Map<string, GlobalSlot>;
  // Map from source location of `await` to the stack depth at that point
  // (before awaiting), or undefined if that information is not yet known.
  awaitStackDepths?: Map<string, number>;
}