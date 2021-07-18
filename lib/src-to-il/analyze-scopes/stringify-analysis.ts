import { assertUnreachable, defineFormat as withFormat, notUndefined, stringifyGeneric, stringifyIdentifier, stringifyStringLiteral, unexpected } from '../../utils';
import { Binding, BlockScope, FunctionScope, ModuleScope, Scope, AnalysisModel, Slot } from '.';
import { FunctionLikeScope } from './analysis-model';

export function stringifyAnalysis(scopeInfo: AnalysisModel) {
  return `${
    `[this module slot] ${scopeInfo.thisModuleSlot.name}`
  }\n${
    [...scopeInfo.freeVariables]
      .map(v => `[free var] ${stringifyIdentifier(v)}`)
      .join('\n')
  }\n${
    scopeInfo.moduleImports
      .map(v => `[import slot] ${v.slot.name} [from ${stringifyStringLiteral(v.source)}]`)
      .join('\n')
  }\n${
    scopeInfo.exportedBindings
      .map(v => `[export binding] ${v.name} [in slot] ${stringifySlot(v.slot)}`)
      .join('\n')
  }\n${
    scopeInfo.globalSlots
      .map(g => `[global slot] ${g.name}`)
      .join('\n')
  }\n${
    stringifyScope(scopeInfo.moduleScope, '')
  }`
}

function stringifyScope(scope: Scope, indent: string): string {
  switch (scope.type) {
    case 'ModuleScope': return stringifyModuleScope(scope, indent);
    case 'FunctionScope': return stringifyFunctionScope(scope, indent);
    case 'BlockScope': return stringifyBlockScope(scope, indent);
    default: return assertUnreachable(scope);
  }
}

function stringifyModuleScope(scope: ModuleScope, indent: string) {
  return `${indent}module ${stringifyGeneric({
    ilFunctionId: scope.ilFunctionId,
    functionIsClosure: scope.functionIsClosure,
    varDeclarations: scope.varDeclarations,
    prologue: scope.prologue,
    closureSlots: scope.closureSlots?.map(s => withFormat(stringifySlot(s))),
    children: scope.children.map(c => withFormat(indent => stringifyScope(c, indent))),
  }, indent)}`
}

function stringifyFunctionScope(scope: FunctionScope, indent: string) {
  return `${indent}${
    scope.functionIsClosure ? 'closure ' : ''
  }function ${
    scope.funcName ?? '<anonymous>'
  } {${
    scope.closureSlots
      ? `\n${indent}[closure scope ${notUndefined(scope.closureSlots.length)} slots]`
      : ''
  }${
    stringifyScopeVariables(scope, indent)
  }\n${indent}}`
}

function stringifyBlockScope(scope: BlockScope, indent: string) {
  return `${indent}block {${
    stringifyScopeVariables(scope, indent)
  }\n${indent}}`
}

function stringifyScopeVariables(scope: Scope, indent: string) {
  return Object.entries(scope.bindings)
    .map(([k, v]) => `\n${indent}${stringifyBinding(k, v, indent)}`)
    .join('')
}

function stringifyBinding(name: string, binding: Binding, indent: string) {
  let s = `${indent}${binding.kind} ${stringifyIdentifier(binding.name)}`;
  if (binding.isDeclaredReadonly) s = `readonly ${s}`;
  if (binding.isWrittenTo) s = `writable ${s}`;
  if (binding.slot?.type === 'GlobalSlot') s = `global ${s}`;
  if (binding.slot?.type === 'ClosureSlot') s = `closure ${s}`;
  if (binding.slot?.type === 'LocalSlot') s = `local ${s}`;
  if (binding.isExported) s = `export ${s}`;
  return s;
}

function stringifySlot(slot?: Slot): string {
  if (!slot) return '<no slot>';
  switch (slot.type) {
    case 'ArgumentSlot': return `[arg slot] ${slot.argIndex}`;
    case 'ClosureSlot': return `[closure slot] ${slot.index}`;
    case 'GlobalSlot': return `[global slot] ${slot.name}`;
    case 'LocalSlot': return `[local slot] ${slot.index}`;
    case 'ModuleImportExportSlot': return `[import/export slot] ${slot.propertyName} [in] ${stringifySlot(slot.moduleNamespaceObjectSlot)}`;
    default: return assertUnreachable(slot);
  }
}