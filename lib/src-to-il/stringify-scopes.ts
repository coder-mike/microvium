import { assertUnreachable, notUndefined, stringifyIdentifier, unexpected } from '../utils';
import { Binding, BlockScope, FunctionScope, ModuleScope, Scope, ScopesInfo } from './analyze-scopes';

export function stringifyScopes(scopeInfo: ScopesInfo) {
  const { moduleScope, freeVariables } = scopeInfo;

  return `${
    stringifyFreeVariables(freeVariables)
  }\n${
    stringifyScope(moduleScope, '')
  }`
}

function stringifyFreeVariables(freeVariables: string[]) {
  return freeVariables
    .map(stringifyIdentifier)
    .map(v => `free var ${v}`)
    .join('\n');
}

function stringifyScope(scope: Scope, indent: string) {
  switch (scope.type) {
    case 'ModuleScope': return stringifyModuleScope(scope, indent);
    case 'FunctionScope': return stringifyFunctionScope(scope, indent);
    case 'BlockScope': return stringifyBlockScope(scope, indent);
    default: return assertUnreachable(scope);
  }
}

function stringifyModuleScope(scope: ModuleScope, indent: string) {
  return `${indent}module {${
    stringifyScopeVariables(scope, indent)
  }\n${indent}}`
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
  let s = `${binding.kind} ${stringifyIdentifier(binding.name)}`;
  if (binding.readonly) s = `readonly ${s}`;
  if (binding.isWrittenTo) s = `writable ${s}`;
  if (!binding.isUsed) s = `unused ${s}`;
  return s;
}