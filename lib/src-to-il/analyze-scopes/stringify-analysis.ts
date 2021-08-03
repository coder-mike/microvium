import { assertUnreachable, notUndefined, stringifyIdentifier, stringifyStringLiteral, unexpected } from '../../utils';
import { Binding, BlockScope, FunctionScope, ModuleScope, Scope, AnalysisModel, Slot } from '.';
import { block, inline, list, Stringifiable, stringify, text } from 'stringify-structured';

export function stringifyAnalysis(analysis: AnalysisModel) {
  return stringify(renderAnalysis(analysis));
}

function renderAnalysis(analysis: AnalysisModel): Stringifiable {
  return list('; ', [
    { key: '[this module slot]', value: stringifyStringLiteral(analysis.thisModuleSlot.name) },

    ...[...analysis.freeVariables]
      .map(v => inline`[free var] ${v}`),

    ...analysis.moduleImports
      .map(v => inline`[import slot] ${v.slot.name} [from] ${v.source}`),

    ...analysis.exportedBindings
      .map(v => inline`[export binding] ${v.name} [in slot] ${renderSlot(v.slot)}`),

    ...analysis.globalSlots
      .map(g => inline`[global slot] ${g.name}`),

    renderScope(analysis.moduleScope)
  ])
}

function renderScope(scope: Scope): Stringifiable {
  switch (scope.type) {
    case 'ModuleScope': return renderModuleScope(scope);
    case 'FunctionScope': return renderFunctionScope(scope);
    case 'BlockScope': return renderBlockScope(scope);
    default: return assertUnreachable(scope);
  }
}

function renderModuleScope(scope: ModuleScope): Stringifiable {
  return inline`module ${{
    ilFunctionId: scope.ilFunctionId,
    functionIsClosure: scope.functionIsClosure,
    varDeclarations: scope.varDeclarations,
    prologue: scope.prologue,
    closureSlots: scope.closureSlots?.map(renderSlot),
    children: scope.children.map(c => renderScope(c)),
  }}`
}

function renderFunctionScope(scope: FunctionScope): Stringifiable {
  return inline`${
    text`${scope.functionIsClosure ? 'closure ' : ''}`
  }function ${
    text`${scope.funcName ?? '<anonymous>'}`
  } ${
    block`{${
      scope.closureSlots
        ? text`[closure scope ${notUndefined(scope.closureSlots.length)} slots]`
        : ''
    }}`
  }${
    renderScopeVariables(scope)
  }}`
}

function renderBlockScope(scope: BlockScope): Stringifiable {
  return block`block {${
    renderScopeVariables(scope)
  }}`
}

function renderScopeVariables(scope: Scope): Stringifiable {
  return list('; ', Object.values(scope.bindings).map(renderBinding))
}

function renderBinding(binding: Binding): Stringifiable {
  let s = `${binding.kind} ${stringifyIdentifier(binding.name)}`;
  if (binding.isDeclaredReadonly) s = `readonly ${s}`;
  if (binding.isWrittenTo) s = `writable ${s}`;
  if (binding.slot?.type === 'GlobalSlot') s = `global ${s}`;
  if (binding.slot?.type === 'ClosureSlot') s = `closure ${s}`;
  if (binding.slot?.type === 'LocalSlot') s = `local ${s}`;
  if (binding.isExported) s = `export ${s}`;
  return text`${s}`;
}

function renderSlot(slot?: Slot): Stringifiable {
  if (!slot) return text`<no slot>`;
  switch (slot.type) {
    case 'ArgumentSlot': return inline`[arg slot] ${slot.argIndex}`;
    case 'ClosureSlot': return inline`[closure slot] ${slot.index}`;
    case 'GlobalSlot': return inline`[global slot] ${slot.name}`;
    case 'LocalSlot': return inline`[local slot] ${slot.index}`;
    case 'ModuleImportExportSlot': return inline`[import/export slot] ${slot.propertyName} [in] ${renderSlot(slot.moduleNamespaceObjectSlot)}`;
    default: return assertUnreachable(slot);
  }
}