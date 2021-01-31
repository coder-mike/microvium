import { assertUnreachable, notUndefined, stringifyIdentifier, unexpected } from '../utils';
import { BindingInfo, ScopesInfo, VariableReferenceInfo, VariableScopeInfo } from './analyze-scopes';

export function stringifyScopes(scopeInfo: ScopesInfo) {
  const { root, freeVariables } = scopeInfo;

  return `${
    stringifyFreeVariables(freeVariables)
  }\n${
    stringifyScope(root, '')
  }`
}

function stringifyFreeVariables(freeVariables: Set<string>) {
  return [...freeVariables]
    .map(stringifyIdentifier)
    .map(v => `free var ${v}`)
    .join('\n');
}

function stringifyScope(scope: VariableScopeInfo, indent: string) {
  switch (scope.scopeKind) {
    case 'module': return stringifyModuleScope(scope, indent);
    case 'function': return stringifyFunctionScope(scope, indent);
    case 'block': return stringifyBlockScope(scope, indent);
    default: return assertUnreachable(scope.scopeKind);
  }
}

function stringifyModuleScope(scope: VariableScopeInfo, indent: string) {
  return `${indent}module {${
    stringifyScopeVariables(scope, indent)
  }\n${indent}}`
}

function stringifyFunctionScope(scope: VariableScopeInfo, indent: string) {
  return `${indent}${
    scope.functionIsClosure ? 'closure ' : ''
  }function ${
    scope._funcName ?? '<anonymous>'
  } {${
    scope.allocateClosureScope
      ? `\n${indent}[closure scope ${notUndefined(scope.closureVariableCount)} slots]`
      : ''
  }${
    stringifyScopeVariables(scope, indent)
  }\n${indent}}`
}

function stringifyBlockScope(scope: VariableScopeInfo, indent: string) {
  return `${indent}block {${
    stringifyScopeVariables(scope, indent)
  }\n${indent}}`
}

function stringifyScopeVariables(scope: VariableScopeInfo, indent: string) {
  return Object.entries(scope.bindings)
    .map(([k, v]) => `\n${indent}${stringifyBinding(k, v, indent)}`)
    .join('')
}

function stringifyBinding(name: string, binding: BindingInfo, indent: string) {
  let s = `${binding.kind} ${stringifyIdentifier(binding.name)}`;
  if (binding.closureAllocated) s = `closed ${s}`;
  if (binding.readonly) s = `readonly ${s}`;
  if (binding.isModuleLevel) s = `module ${s}`;
  if (binding.moduleVariableKind) s = `${binding.moduleVariableKind} ${s}`;
  if (!binding.used) s = `unused ${s}`;
  if (binding.importedFrom) s = `${s} from ${stringifyIdentifier(binding.importedFrom)}`;
  return s;
}