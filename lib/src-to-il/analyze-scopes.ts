import { IL } from '../../lib';
import { assertUnreachable, hardAssert, isNameString, notUndefined, unexpected } from '../utils';
import { compileError, featureNotSupported, SourceCursor, visitingNode } from './common';
import * as B from './supported-babel-types';
import { traverseAST } from './traverse-ast';

// TODO: These types contain a lot of optional fields that would go away if we used discriminated unions

export interface ScopesInfo {
  scopes: Map<ScopeNode, VariableScopeInfo>;
  references: Map<B.Identifier, VariableReferenceInfo>;
  bindings: Map<VariableBindingNode, BindingInfo>;
  root: VariableScopeInfo;
  freeVariables: Set<string>;
}

// A variable slot in a scope (VariableScopeInfo)
export interface BindingInfo {
  // The lexical construct that defines the binding
  kind:
    | 'param'
    | 'var'
    | 'const'
    | 'let'
    | 'function'
    | 'import'   // Variable created by an `import` statement
  name: string;
  node: VariableBindingNode;
  readonly: boolean;
  // Set to true if the variable is accessed at all (locally)
  used?: boolean;
  // Set to true if the variable is accessed by LoadScoped rather than LoadVar.
  closureAllocated?: boolean;
  // Variable index in the local stack frame or closure (depending on
  // closureAllocated).
  slotIndex?: number;
  // True if the variable is declared at the module level
  isModuleLevel?: boolean;
  // If the variable is a module-level variable
  moduleVariableKind?:
    | 'exported'  // Variable is part of this module's module-object
    | 'imported'  // Variable is part of another module's module-object
    | 'local'     // Variable is at the module level but is not part of a module object because it's not imported or exported
  // If the moduleVariableKind is 'imported', then `importedFrom` is the module specifier from which the module is imported
  importedFrom?: string;
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
  functionIsClosure?: boolean;
  // needs a heap-allocated scope for variables shared between itself and it's
  // child closures. If this is true, the function prelude will have a ScopePush
  // instruction.
  allocateClosureScope?: boolean;
  // If allocateClosureScope is true, this will specify the number of variables
  // that must be allocated in the closure scope. This includes variables in
  // nested lexical blocks.
  closureVariableCount?: number;
  // More for debug purposes, but this is a list of references (identifiers)
  // directly contained within the scope.
  references: VariableReferenceInfo[];
}

export interface VariableReferenceInfo {
  // For debug purposes
  _name: string;
  identifier: B.Identifier;
  // The referenced variable is in the current function
  isInLocalFunction: boolean;
  // Note: free variables (globals) do not have a `VariableReferenceInfo`
  referenceKind:
    | 'stack'        // Local variable (or parameter) on the stack
    | 'closure'      // Variable in a closure scope (local or parent)
    | 'module'       // Variable is declared at the module level
    | 'free'         // Variable is not found in the scope chain (it must be global or a mistake)

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
  | B.ImportSpecifier | B.ImportDefaultSpecifier | B.ImportNamespaceSpecifier // For imports

/*
This does analysis of scopes and variables.

  - Resolve identifiers to their corresponding declarations (bindings).
  - Calculate how many variables are in each scope and assign indexes to each of them.
  - Compute closure information
*/
export function analyzeScopes(file: B.File, filename: string): ScopesInfo {
  const scopes = new Map<ScopeNode, VariableScopeInfo>();
  const references = new Map<B.Identifier, VariableReferenceInfo>();
  const bindings = new Map<VariableBindingNode, BindingInfo>();
  const freeVariables = new Set<string>();

  const cur: SourceCursor = { filename, node: file };

  findScopesAndVariables(file.program);
  computeReferenceKinds();
  computeSlots();
  computeLookupIndexes();

  const root = scopes.get(file.program) || unexpected();

  return {
    scopes,
    references,
    bindings,
    root,
    freeVariables
  };

  // This is the function used to iterate the AST
  function findScopesAndVariables(node_: B.Node): void {
    const scopeStack: VariableScopeInfo[] = [];
    const currentScope = () => notUndefined(scopeStack[scopeStack.length - 1]);

    inner(node_);

    function inner(node_: B.Node) {
      const node = node_ as B.Program | B.SupportedStatement | B.SupportedExpression;
      visitingNode(cur, node);
      switch (node.type) {
        case 'Program': {
          const scope = pushScope(node, 'module');
          const statements = node.body;

          findImportsAndExports(node);

          for (const statement of statements) {
            findHoistedVariables(statement, true);
          }

          // Lexical variables are also found upfront because nested functions can
          // reference variables that are declared further down than the nested
          // function (TDZ). (But `findLexicalVariables` isn't recursive)
          findLexicalVariables(statements, true);

          // Iterate through the function/program body to find variable usage
          for (const statement of statements) {
            findScopesAndVariables(statement);
          }

          popScope(scope);
          break;
        }
        case 'FunctionDeclaration': {
          const scope = pushScope(node, 'function');
          scope._funcName = node.id?.name;
          createParameterBindings(node.params);
          const statements = node.body.body;

          statements.forEach(s => findHoistedVariables(s, false));

          // Lexical variables are also found upfront because nested functions can
          // reference variables that are declared further down than the nested
          // function (TDZ). (But `findLexicalVariables` isn't recursive)
          findLexicalVariables(statements, false);

          // Iterate through the body to find variable usage
          statements.forEach(findScopesAndVariables);

          popScope(scope);
          break;
        }
        case 'ArrowFunctionExpression': {
          const scope = pushScope(node, 'function');
          createParameterBindings(node.params);
          const body = node.body;

          if (body.type === 'BlockStatement') {
            const statements = body.body;
            statements.forEach(s => findHoistedVariables(s, false));

            // Lexical variables are also found upfront because nested functions can
            // reference variables that are declared further down than the nested
            // function (TDZ). (But `findLexicalVariables` isn't recursive)
            findLexicalVariables(statements, false);

            statements.forEach(findScopesAndVariables);
          } else {
            /* Note: Arrow functions with expression bodies do not have any hoisted variables */
            findScopesAndVariables(body);
          }

          popScope(scope);
          break;
        }
        case 'BlockStatement': {
          // Creates a lexical scope
          const scope = pushScope(node, 'block');
          // Here we don't need to populate the hoisted variables because they're
          // already populated by the containing function/program
          findLexicalVariables(node.body, false);
          for (const statement of node.body) {
            findScopesAndVariables(statement);
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
                identifier: node,
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
              identifier: node,
              isInLocalFunction: false,
              referenceKind: 'free',
              nearestScope: currentScope()
            };
            freeVariables.add(variableName);
            references.set(node, reference);
            currentScope().references.push(reference);
          }
          break;
        }
        default:
          traverseAST(cur, node, findScopesAndVariables);
      }
    }

    // This function looks for var and function declarations for a variable scope
    // (program- or function-level) and creates bindings for them in the current
    // scope.
    function findHoistedVariables(
      statement: B.Statement,
      isModuleLevel: boolean
    ) {
      traverse(statement);

      // Module-level variables that are exported are found using
      // findImportsAndExports, so if they're found here then they're "local" to
      // the current module
      const moduleVariableKind: BindingInfo['moduleVariableKind'] | undefined =
        isModuleLevel ? 'local' : undefined;

      function traverse(node_: B.Node) {
        const node = node_ as B.SupportedNode;
        switch (node.type) {
          case 'ExportNamedDeclaration':
          case 'ImportDeclaration':
            break; // Handled separately
          case 'VariableDeclaration': {
            // This function is only looking for hoisted variables
            if (node.kind === 'var') {
              bindVariableDeclaration(node, isModuleLevel, moduleVariableKind);
            }
            break;
          }
          case 'FunctionDeclaration': {
            if (node.id) {
              bindFunctionDeclaration(node, isModuleLevel, moduleVariableKind);
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
    function findLexicalVariables(
      statements: B.Statement[],
      isModuleLevel: boolean
    ) {
      // Module-level variables that are exported are found using
      // findImportsAndExports, so if they're found here then they're "local" to
      // the current module
      const moduleVariableKind: BindingInfo['moduleVariableKind'] | undefined =
        isModuleLevel ? 'local' : undefined;

      for (const statement of statements) {
        if (statement.type === 'ExportNamedDeclaration' || statement.type === 'ImportDeclaration')
        continue; // Handled separately

        visitingNode(cur, statement);
        if (statement.type === 'VariableDeclaration' && statement.kind !== 'var') {
          for (const declaration of statement.declarations) {
            const id = declaration.id;
            if (id.type !== 'Identifier') {
              visitingNode(cur, id);
              return compileError(cur, 'Syntax not supported')
            }
            const name = id.name;
            createBinding({
              kind: statement.kind,
              node: declaration,
              readonly: statement.kind === 'const',
              name,
              isModuleLevel,
              moduleVariableKind
            });
          }
        }
      }
    }

    function bindFunctionDeclaration(
      node: B.FunctionDeclaration,
      isModuleLevel: boolean,
      moduleVariableKind: BindingInfo['moduleVariableKind'] | undefined
    ) {
      const id = node.id ?? unexpected();
      const name = id.name;
      createBinding({
        kind: 'function',
        name,
        node,
        readonly: false,
        isModuleLevel,
        moduleVariableKind,
      });
    }

    function findImportsAndExports(program: B.Program) {
      for (const statement of program.body) {
        visitingNode(cur, statement);

        switch (statement.type) {
          case 'ExportNamedDeclaration': return bindNamedExports(statement);
          case 'ImportDeclaration': return createImportBindings(statement);
        }
      }
    }

    function createImportBindings(statement: B.ImportDeclaration) {
      const sourcePath = statement.source.value;

      for (const specifier of statement.specifiers) {
        visitingNode(cur, specifier);
        const name = specifier.local.name;


        createBinding({
          name,
          kind: 'import',
          importedFrom: sourcePath,
          node: specifier,
          readonly: false,
          isModuleLevel: true,
          moduleVariableKind: 'imported'
        })
      }
    }

    function bindNamedExports(statement: B.ExportNamedDeclaration) {
      if (statement.source || statement.specifiers.length) {
        return compileError(cur, 'Only simple export syntax is supported')
      }
      const declaration = statement.declaration;
      if (!declaration) {
        // Older versions of babel didn't seem to allow for a null declaration, so
        // I'm thinking maybe it's to support a new language feature. I haven't
        // looked into it.
        return featureNotSupported(cur, 'Expected a declaration');
      }
      const isModuleLevel = true;
      const moduleVariableKind: BindingInfo['moduleVariableKind'] = 'exported';
      if (declaration.type === 'VariableDeclaration') {
        bindVariableDeclaration(declaration, isModuleLevel, moduleVariableKind);
      } else if (declaration.type === 'FunctionDeclaration') {
        bindFunctionDeclaration(declaration, isModuleLevel, moduleVariableKind);
      } else {
        return compileError(cur, `Not supported: export of ${declaration.type}`);
      }
    }

    function bindVariableDeclaration(
      decl: B.VariableDeclaration,
      isModuleLevel: boolean,
      moduleVariableKind: BindingInfo['moduleVariableKind'] | undefined
    ) {
      const readonly = decl.kind === 'const';
      const kind = decl.kind;

      for (const node of decl.declarations) {
        if (node.id.type !== 'Identifier') {
          return compileError(cur, 'Only simple variable declarations are supported.')
        }
        const name = node.id.name;
        if (!isNameString(name)) {
          return compileError(cur, `Invalid variable identifier: "${name}"`);
        }

        createBinding({
          name,
          readonly,
          kind,
          node,
          isModuleLevel,
          moduleVariableKind,
        });
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

    function createParameterBindings(params: (B.FunctionDeclaration | B.ArrowFunctionExpression)['params']) {
      for (const param of params) {
        if (param.type !== 'Identifier')
          return compileError(cur, 'Not supported');
        createBinding({
          kind: 'param',
          node: param,
          name: param.name,
          readonly: false,
        });
      }
    }

    function createBinding(binding: BindingInfo) {
        hardAssert(binding.readonly === (binding.kind === 'const'))

        const scope = currentScope();
      const scopeBindings = scope.bindings;
      const { name, kind, node } = binding;

      const isLexical = kind === 'let' || kind === 'const';

      if (isLexical && name in scopeBindings) {
        return compileError(cur, `Variable "${name}" already declared in scope`)
      }

      scopeBindings[name] = binding;
      bindings.set(binding.node, binding);

      const selfReference = getDeclarationSelfReference(node)


      if (selfReference) {
        references.set(selfReference, {
          _name: name,
          referenceKind: undefined as any, // See computeReferenceKinds
          identifier: selfReference,
          isInLocalFunction: true,
          nearestScope: currentScope(),
          targetScope: currentScope(),
          binding: binding,
        })
      }

      function getDeclarationSelfReference(node: BindingInfo['node']): B.Identifier | undefined {
        switch (node.type) {
          case 'FunctionDeclaration': return node.id ?? undefined;
          case 'Identifier': return node;
          case 'VariableDeclarator':
            return node.id.type === 'Identifier'
              ? node.id
              : undefined;
          case 'ImportDefaultSpecifier': return node.
            case 'ImportDefaultSpecifier':
          default:
            return assertUnreachable(node);
        }
      }
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
}