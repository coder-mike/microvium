import { assertUnreachable, notUndefined, stringifyIdentifier, unexpected } from '../../utils';
import { Binding, BlockScope, FunctionScope, ModuleScope, Scope, AnalysisModel, Slot } from '.';
import { block, inline, list, Stringifiable, stringify, text, renderKey, stringifyString } from 'stringify-structured';
import { ClosureSlot, FunctionLikeScope, LocalSlot, PrologueStep, ScopeBase } from './analysis-model';

export function stringifyAnalysis(analysis: AnalysisModel) {
  return stringify(renderAnalysis(analysis), { wrapWidth: 60 });
}

const sections = (...s: any[]) => list('; ', s, { multiLineJoiner: '\n', skipEmpty: true });
const subsections = (...s: any[]) => list('; ', s, { multiLineJoiner: '', skipEmpty: true });
const items = (content: Iterable<any>, render: (c: any) => any) =>
  list('; ', [...content].map(render), { multiLineJoiner: '', skipEmpty: true });

function renderAnalysis(analysis: AnalysisModel): Stringifiable {
  return sections(
    subsections(
      inline`[this module slot] ${analysis.thisModuleSlot.name}`,

      items(analysis.freeVariables, v => inline`[free var] ${v}`),

      items(analysis.moduleImports, v => inline`[import slot] ${v.slot.name} [from] ${v.source}`),

      items(analysis.exportedBindings, v => inline`[export binding] ${v.name} [in slot] ${renderSlot(v.slot)}`),

      items(analysis.globalSlots, g => inline`[global slot] ${g.name}`),
    ),

    renderScope(analysis.moduleScope)
  )
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
  return inline`module with entry ${
    text`${scope.functionIsClosure ? 'closure ' : ''}`
  }${scope.ilFunctionId} ${
    block`{ ${
      renderFunctionLikeBody(scope)
    } }`
  }`;
}

function renderFunctionLikeBody(scope: FunctionLikeScope) {
  return sections(
    subsections(
      scope.closureSlots
        ? text`[closure scope with ${notUndefined(scope.closureSlots.length)} slots]`
        : text`[no closure scope]`,

      inline`[${scope.varDeclarations.length} var declarations]`,

      renderScopeVariables(scope),
    ),

    renderPrologue(scope.prologue),

    ...scope.children.map(c => renderScope(c))
  )
}

function renderPrologue(prologue: PrologueStep[]) {
  return list('; ', prologue.map(renderPrologueStep), { multiLineJoiner: '' });
}

function renderPrologueStep(step: PrologueStep) {
  switch (step.type) {
    case 'ScopePush': return inline`new scope[${step.slotCount}]`;
    case 'InitFunctionDeclaration':
      return inline`func ${step.functionId} -> ${renderSlotReference(step.slot)}${
        step.functionIsClosure ? text` [capture scope]` : text``
      }`
    case 'InitVarDeclaration': return inline`new var -> ${renderSlotReference(step.slot)}`
    case 'InitLexicalDeclaration': return inline`new let -> ${renderSlotReference(step.slot)}`;
    case 'InitParameter': return inline`Param ${step.argIndex} -> ${renderSlotReference(step.slot)}`
    case 'InitThis': return inline`this -> ${renderSlotReference(step.slot)}`
    default: return assertUnreachable(step);
  }
}

function renderSlotReference(slot: LocalSlot | ClosureSlot) {
  switch (slot.type) {
    case 'ClosureSlot': return inline`scoped[${slot.index}]`;
    case 'LocalSlot': return inline`local[${slot.index}]`;
    default: return assertUnreachable(slot);
  }
}

function renderFunctionScope(scope: FunctionScope): Stringifiable {
  return inline`${
    text`${scope.functionIsClosure ? 'closure ' : ''}`
  }function ${
    renderKey(scope.funcName ?? '<anonymous>')
  } as ${scope.ilFunctionId} ${
    block`{ ${
      renderFunctionLikeBody(scope)
    } }`
  }`
}

function renderBlockScope(scope: BlockScope): Stringifiable {
  return inline`block ${
    block`{ ${
      sections(
        renderScopeVariables(scope),
        ...scope.children.map(c => renderScope(c))
      )
    } }`
  }`
}

function renderScopeVariables(scope: ScopeBase): Stringifiable {
  return list('; ', Object.values(scope.bindings).map(renderBinding))
}

function renderBinding(binding: Binding): Stringifiable {
  let s = `${binding.kind} ${stringifyString(binding.name)}`;
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