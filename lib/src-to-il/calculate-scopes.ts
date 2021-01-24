import { hardAssert, notUndefined, unexpected } from '../utils';
import { compileError, SourceCursor, visitingNode } from './common';
import * as B from './supported-babel-types';
import { traverseAST } from './traverse-ast';

// A variable slot in a scope (VariableScopeInfo)
export interface BindingInfo {
  kind: 'param' | 'var' | 'const' | 'let' | 'function';
  name: string;
  node: VariableBindingNode;
  readonly: boolean;
  // Set to true if the variable is accessed at all (locally)
  used?: boolean;
  // Set to true if the variable is accessed by LoadScoped rather than LoadVar.
  closureAllocated?: boolean;
  // Variable index in the local stack frame or closure (depending on
  // closureAllocated). WIP: This no longer needs to be shifted-by-1 to account for the parent slot
  slotIndex?: number;
}

export interface VariableScopeInfo {
  // The 'module' scope is the root scope of the module. 'function' scopes are
  // the root scopes of the respected functions. 'block' scopes are scopes
  // nested in a function or module by the existence of a block
  scopeKind: 'module' | 'function' | 'block';
  // For debug purposes, if the scope is for a function
  _funcName?: string;
  // Variables in the given scope
  bindings: { [name: string]: BindingInfo };
  // The outer scope. Note that the top-level scope is the `module` scope, which
  // has a parent of `undefined`.
  parent?: VariableScopeInfo;
  // Nested scopes in this scope
  children: VariableScopeInfo[];
  // True if the scope info is for a function (see scopeKind) and the function
  // True if the scope info is for a function (see scopeKind) and the function
  // (or a child of the function) references variables from its parent (or
  // parent's parent, etc). This does not necessarily mean that it needs to have
  // its own closure scope.
  functionIsClosure?: boolean; // WIP
  // needs a heap-allocated scope for variables shared between itself and it's
  // child closures. If this is true, the function prelude will have a ScopePush
  // instruction. // WIP
  allocateClosureScope?: boolean; // WIP
  // If allocateClosureScope is true, this will specify the number of variables
  // that must be allocated in the closure scope. This includes variables in
  // nested lexical blocks. (WIP)
  closureVariableCount?: number;
  // More for debug purposes, but this is a list of references (identifiers)
  // directly contained within the scope.
  references: VariableReferenceInfo[];
}

export interface VariableReferenceInfo {
  // For debug purposes
  _name: string;
  // The referenced variable is in the current function
  isInLocalFunction: boolean;
  // Note: free variables (globals) do not have a `VariableReferenceInfo`
  referenceKind:
    | 'stack'       // Local variable (or parameter) on the stack
    | 'closure'     // Variable in a closure scope (local or parent)
    | 'module'      // Variable is declared at the module level
    | 'free'        // Variable is not found in the scope chain (it must be global or a mistake)

  // The referenced binding, unless the variable is a free variable
  binding?: BindingInfo;
  // The index to use for load and store operations for this variable if it is a 'stack' or a 'closure' variable
  index?: number;
  // The scope in which the variable reference occurs
  nearestScope: VariableScopeInfo;
  // The scope containing the binding (an ancestor of the nearestScope), unless the variable is a free variable
  targetScope?: VariableScopeInfo;
}

export type ScopeNode = B.Program | B.SupportedFunctionNode | B.Block;

export type VariableBindingNode =
  | B.VariableDeclarator // For variable declarations
  | B.FunctionDeclaration // For function declarations
  | B.Identifier // For parameters

export interface ScopesInfo {
  scopes: Map<ScopeNode, VariableScopeInfo>;
  references: Map<B.Identifier, VariableReferenceInfo>;
  bindings: Map<VariableBindingNode, BindingInfo>;
  root: VariableScopeInfo;
}

/*
This does analysis of scopes and variables.

  - Resolve identifiers to their corresponding declarations (bindings).
  - Calculate how many variables are in each scope and assign indexes to each of them.
  - Compute closure information
*/
export function calculateScopes(file: B.File, filename: string): ScopesInfo {
  const scopes = new Map<ScopeNode, VariableScopeInfo>();
  const references = new Map<B.Identifier, VariableReferenceInfo>();
  const bindings = new Map<VariableBindingNode, BindingInfo>();
  const scopeStack: VariableScopeInfo[] = [];
  const currentScope = () => notUndefined(scopeStack[scopeStack.length - 1]);
  const cur: SourceCursor = { filename, node: file };

  detectClosures(file.program);
  computeReferenceKinds();
  computeSlots();
  computeLookupIndexes();

  const root = scopes.get(file.program) || unexpected();

  return {
    scopes,
    references,
    bindings,
    root
  };

  // This is the function used to iterate the AST
  function detectClosures(node_: B.Node): void {
    const node = node_ as B.Program | B.SupportedStatement | B.SupportedExpression;
    visitingNode(cur, node);
    switch (node.type) {
      case 'Program': {
        const scope = pushScope(node, 'module');
        const statements = node.body;

        for (const statement of statements) {
          findHoistedVariables(statement);
        }

        // Lexical variables are also found upfront because nested functions can
        // reference variables that are declared further down than the nested
        // function (TDZ). (But `findLexicalVariables` isn't recursive)
        findLexicalVariables(statements);

        // Iterate through the function/program body to find variable usage
        for (const statement of statements) {
          detectClosures(statement);
        }

        popScope(scope);
        break;
      }
      case 'FunctionDeclaration': {
        const scope = pushScope(node, 'function');
        scope._funcName = node.id?.name;
        createParameterBindings(node.params);
        const statements = node.body.body;

        statements.forEach(findHoistedVariables);

        // Lexical variables are also found upfront because nested functions can
        // reference variables that are declared further down than the nested
        // function (TDZ). (But `findLexicalVariables` isn't recursive)
        findLexicalVariables(statements);

        // Iterate through the body to find variable usage
        statements.forEach(detectClosures);

        popScope(scope);
        break;
      }
      case 'ArrowFunctionExpression': {
        const scope = pushScope(node, 'function');
        createParameterBindings(node.params);
        const body = node.body;

        if (body.type === 'BlockStatement') {
          const statements = body.body;
          statements.forEach(findHoistedVariables);

          // Lexical variables are also found upfront because nested functions can
          // reference variables that are declared further down than the nested
          // function (TDZ). (But `findLexicalVariables` isn't recursive)
          findLexicalVariables(statements);

          statements.forEach(detectClosures);
        } else {
          /* Note: Arrow functions with expression bodies do not have any hoisted variables */
          detectClosures(body);
        }

        popScope(scope);
        break;
      }
      case 'BlockStatement': {
        // Creates a lexical scope
        const scope = pushScope(node, 'block');
        // Here we don't need to populate the hoisted variables because they're
        // already populated by the containing function/program
        findLexicalVariables(node.body);
        for (const statement of node.body) {
          detectClosures(statement);
        }
        popScope(scope);
        break;
      }
      case 'Identifier': {
        // Note: identifiers here are always variable references. See
        // description of traverseAST.
        const variableName = node.name;
        // We loop through the scope stack backwards, starting at inner-most and
        // going outward. Some scope layers are created by nested blocks within
        // a function, so we're not necessarily leaving the local function when
        // we traverse to the outer lexical scope.
        let isInLocalFunction = true;
        let foundInScopeStack = false;
        // Look for the variable
        for (let i = scopeStack.length - 1; i >= 0; i--) {
          const scope = scopeStack[i];
          const binding = scope.bindings[variableName];
          if (binding) {
            foundInScopeStack = true;
            binding.used = true;
            if (!isInLocalFunction && scope.scopeKind !== 'module') {
              binding.closureAllocated = true;
              scope.allocateClosureScope = true;
            }
            const reference: VariableReferenceInfo = {
              _name: variableName,
              binding,
              isInLocalFunction,
              referenceKind: undefined as any, // See computeReferenceKinds
              nearestScope: currentScope(),
              targetScope: scope
            };
            references.set(node, reference);
            currentScope().references.push(reference);
            break;
          }
          if (scope.scopeKind === 'function') {
            // After this point, the variable is not in the local function
            isInLocalFunction = false;
          }
        }
        // Else, it's a free variable reference
        if (!foundInScopeStack) {
          const reference: VariableReferenceInfo = {
            _name: variableName,
            isInLocalFunction: false,
            referenceKind: 'free',
            nearestScope: currentScope()
          };
          references.set(node, reference);
          currentScope().references.push(reference);
        }
        break;
      }
      default:
        traverseAST(cur, node, detectClosures);
    }
  }

  function computeSlots() {
    /*
    This function calculates the size of each closure scope, and the index of
    each variable in the closure scope.

    Closure scopes are associated with functions, not lexical scopes, so
    multiple lexical scopes can live in the same closure scope. The algorithm
    treats each closure scope as a kind of "stack", with new lexical blocks
    adding new variables to the end of the scope, and then the end of each
    lexical block "popping" them off again so the slots can be used by the next
    lexical scope.
    */
    const root = scopes.get(file.program) || unexpected();
    visitingNode(cur, file);
    hardAssert(root.scopeKind === 'module');
    for (const child of root.children) {
      if (child.scopeKind === 'function') {
        computeFunctionSlots(child);
      }
    }

    function computeFunctionSlots(scope: VariableScopeInfo) {
      hardAssert(scope.scopeKind === 'function');
      scope.closureVariableCount = computeBlockSlots(scope, 0, 0);
    }

    function computeBlockSlots(scope: VariableScopeInfo, heapVariableIndex: number, stackVariableIndex: number): number {
      hardAssert(scope.scopeKind === 'block' || scope.scopeKind === 'function');

      // Count up all the root-level bindings
      for (const binding of Object.values(scope.bindings)) {
        if (binding.closureAllocated) {
          binding.slotIndex = heapVariableIndex++;
        } else {
          binding.slotIndex = stackVariableIndex++;
        }
      }

      // This is the "high water mark", giving us the maximum size of scope we need
      let closureVariableCount = heapVariableIndex;

      for (const child of scope.children) {
        if (child.scopeKind === 'function') {
          computeFunctionSlots(child);
        } else {
          closureVariableCount = Math.max(closureVariableCount, computeBlockSlots(child, heapVariableIndex, stackVariableIndex));
        }
      }

      return closureVariableCount;
    }
  }

  function computeLookupIndexes() {
    /*
    The instructions LoadScoped and StoreScoped take a _relative_ index, that in
    some sense "overflows" from the current scope into the parent scope. This
    function computes the relative indices.
    */

    for (const reference of references.values()) {
      switch (reference.referenceKind) {
        case 'stack': {
          const binding = reference.binding ?? unexpected();
          reference.index = binding.slotIndex;
          break;
        }
        case 'closure': {
          const binding = reference.binding ?? unexpected();
          const { nearestScope, targetScope } = reference;
          let scope = nearestScope;
          let index = 0;
          // While we're not in the scope containing the variable, move to the parent scope
          while (scope !== targetScope) {
            if (scope.scopeKind === 'function') {
              if (scope.allocateClosureScope) {
                index += scope.closureVariableCount ?? unexpected();
              }
              // In order for us to hop from the child to the parent function,
              // we'll need to have a reference to the parent scope at runtime,
              // which means the function we're hopping from must itself be a
              // closure.
              scope.functionIsClosure = true;
            }
            scope = scope.parent || unexpected();
          }
          index += binding.slotIndex ?? unexpected();
          reference.index = index;
          break;
        }
        case 'module': {
          /* module-level variables use names rather than indexes */
          break;
        }
        case 'free': {
          /* Free variables (globals) are identified by name, not index */
          break;
        }
      }
    }
  }

  function createBinding(kind: BindingInfo['kind'], node: VariableBindingNode, name: string, isLexical: boolean) {
    const scope = currentScope();
    const scopeBindings = scope.bindings;
    if (isLexical && name in scopeBindings) {
      return compileError(cur, `Variable "${name}" already declared in scope`)
    }
    const readonly = kind === 'const';
    const binding: BindingInfo = { kind, readonly, name, node };
    scopeBindings[name] = binding;
    bindings.set(node, binding);
  }

  function createParameterBindings(params: (B.FunctionDeclaration | B.ArrowFunctionExpression)['params']) {
    for (const param of params) {
      if (param.type !== 'Identifier')
        return compileError(cur, 'Not supported');
      createBinding('param', param, param.name, false);
    }
  }



  function computeReferenceKinds() {
    for (const ref of references.values()) {
      if (ref.binding) {
        const binding = ref.binding;
        const targetScope = ref.targetScope ?? unexpected();
        if (targetScope.scopeKind === 'module') {
          ref.referenceKind = 'module';
        } else if (binding.closureAllocated) {
          ref.referenceKind = 'closure';
        } else {
          hardAssert(ref.isInLocalFunction);
          ref.referenceKind = 'stack';
        }
      } else {
        hardAssert(ref.referenceKind === 'free');
      }
    }
  }

  function pushScope(node: ScopeNode, scopeKind: VariableScopeInfo['scopeKind']): VariableScopeInfo {
    const parent = scopeStack[scopeStack.length - 1]; // Can be undefined
    const scope: VariableScopeInfo = {
      bindings: Object.create(null),
      scopeKind,
      children: [],
      parent,
      references: []
    };
    scopes.set(node, scope);
    parent && parent.children.push(scope);
    scopeStack.push(scope);
    return scope;
  }

  function popScope(scope: VariableScopeInfo) {
    hardAssert(scopeStack[scopeStack.length - 1] === scope);
    scopeStack.pop();
  }

  // This function looks for var and function declarations for a variable scope
  // (program- or function-level) and creates bindings for them in the current
  // scope.
  function findHoistedVariables(statement: B.Statement) {
    traverse(statement);

    function traverse(node_: B.Node) {
      const node = node_ as B.SupportedNode;
      switch (node.type) {
        case 'VariableDeclaration': {
          if (node.kind === 'var') {
            for (const declaration of node.declarations) {
              const id = declaration.id;
              if (id.type !== 'Identifier') {
                visitingNode(cur, id);
                compileError(cur, 'Syntax not supported')
              }
              const name = id.name;
              createBinding('var', declaration, name, false);
            }
          }
          break;
        }
        case 'FunctionDeclaration': {
          if (node.id) {
            const id = node.id;
            const name = id.name;
            createBinding('function', node, name, false);
          }
          break;
        }
        case 'ArrowFunctionExpression':
          break;
        default:
          traverseAST(cur, node, traverse);
          break;
      }
    }
  }

  // This function looks for let and const declarations for lexical scope. It
  // does not look recursively because these kinds of declarations are not
  // hoisted out of nested blocks.
  function findLexicalVariables(statements: B.Statement[]) {
    for (const statement of statements) {
      if (statement.type === 'VariableDeclaration' && statement.kind !== 'var') {
        for (const declaration of statement.declarations) {
          const id = declaration.id;
          if (id.type !== 'Identifier') {
            visitingNode(cur, id);
            compileError(cur, 'Syntax not supported')
          }
          const name = id.name;
          createBinding(statement.kind, declaration, name, true);
        }
      }
    }
  }
}