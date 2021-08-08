import { assertUnreachable, notUndefined, defineContext, mapEmplace } from '../../utils';
import { Binding, BlockScope, FunctionScope, ModuleScope, Scope, AnalysisModel, Slot } from '.';
import { block, inline, list, Stringifiable, stringify, text, renderKey } from 'stringify-structured';
import { FunctionLikeScope, PrologueStep, Reference, ScopeBase } from './analysis-model';

const sections = (...s: any[]) => list('; ', s, { multiLineJoiner: '\n', skipEmpty: true });
const subsections = (...s: any[]) => list('; ', s, { multiLineJoiner: '', skipEmpty: true });
const items = (content: Iterable<any>, render: (c: any) => any) =>
list('; ', [...content].map(render), { multiLineJoiner: '', skipEmpty: true });

interface Context {
  bindingIds: Map<Binding, string>;
  nextBindingId: number;
}

const context = defineContext<Context>();

const newContext = (): Context => ({
  bindingIds: new Map<Binding, string>(),
  nextBindingId: 0,
})

const getBindingId = (binding: Binding) =>
  mapEmplace(context.value.bindingIds, binding, {
    insert: () => `binding_${++context.value.nextBindingId}`
  });

export function stringifyAnalysis(analysis: AnalysisModel) {
  return context.use(newContext(), () =>
    stringify(renderAnalysis(analysis), { wrapWidth: 60 })
  )
}

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
    ),

    renderScopeBindings(scope),

    renderReferencesSection(scope.references),

    renderPrologue(scope.prologue),

    ...scope.children.map(c => renderScope(c))
  )
}

function renderReferencesSection(references: Reference[]) {
  if (references.length) {
    return block`references { ${
      items(references, renderReference)
    } }`
  } else {
    return text`No references`;
  }
}


function renderReference(reference: Reference) {
  let s: any;
  switch (reference.resolvesTo.type) {
    case 'Binding': {
      s = inline`@ ${renderKey(getBindingId(reference.resolvesTo.binding))}`;
      break;
    }
    case 'FreeVariable': {
      s = inline`@ free ${renderKey(reference.resolvesTo.name)}`;
      break;
    }
    case 'RootLevelThis': {
      s = inline`@ root-level \`this\``;
      break;
    }
    default: assertUnreachable(reference.resolvesTo);
  }

  if (reference.access.type === 'ClosureSlotAccess') {
    s = inline`${s} using relative slot index ${reference.access.relativeIndex}`;
  }

  s = inline`${renderKey(reference.name)} ${s}`;

  return s;
}

function renderPrologue(prologue: PrologueStep[]) {
  return block`prologue { ${
    list('; ', prologue.map(renderPrologueStep), { multiLineJoiner: '' })
  } }`
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
    case 'InitParameter': return inline`arg[${step.argIndex}] -> ${renderSlotReference(step.slot)}`
    case 'InitThis': return inline`this -> ${renderSlotReference(step.slot)}`
    default: return assertUnreachable(step);
  }
}

function renderSlotReference(slot: Slot) {
  switch (slot.type) {
    case 'ClosureSlot': return inline`scoped[${slot.index}]`;
    case 'LocalSlot': return inline`local[${slot.index}]`;
    case 'ArgumentSlot': return inline`arg[${slot.argIndex}]`;
    case 'GlobalSlot': return inline`global[${slot.name}]`;
    case 'ModuleImportExportSlot': return inline`importExport[${renderKey(slot.moduleNamespaceObjectSlot.name)}.${renderKey(slot.propertyName)}]`;
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
        inline`epiloguePopCount: ${scope.epiloguePopCount}`,
        renderScopeBindings(scope),
        renderPrologue(scope.prologue),
        renderReferencesSection(scope.references),
        ...scope.children.map(c => renderScope(c))
      )
    } }`
  }`
}

function renderScopeBindings(scope: ScopeBase): Stringifiable {
  return block`bindings { ${
    list('; ', Object.values(scope.bindings).map(renderBinding))
  } }`;
}

function renderBinding(binding: Binding): Stringifiable {
  let s: any = inline`${text`${binding.kind}`} ${binding.name} # ${text`${getBindingId(binding)}`}`;
  if (binding.isDeclaredReadonly) s = inline`readonly ${s}`;
  if (binding.isWrittenTo) s = inline`writable ${s}`;
  if (binding.isExported) s = inline`export ${s}`;

  if (binding.slot) {
    s = inline`${s} @ ${renderSlotReference(binding.slot)}`;
  }

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