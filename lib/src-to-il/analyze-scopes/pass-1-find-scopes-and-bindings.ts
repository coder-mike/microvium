import { notUndefined, unexpected, assertUnreachable, hardAssert, isNameString } from "../../utils";
import { visitingNode, compileError, featureNotSupported, SourceCursor } from "../common";
import { traverseAST } from "../traverse-ast";
import { Scope, VariableReferenceInfo, Binding, FunctionScope, ScopeNode, ModuleScope, BlockScope, BindingNode, ImportSpecifier, ScopesInfo } from "./analysis-model";
import * as B from '../supported-babel-types';
import { AnalysisState } from "./analysis-state";

export function pass1_findScopesAndBindings({
  file,
  cur,
  scopes,
  references,
  freeVariableNames,
  bindingIsClosureAllocated,
  importBindingInfo,
  exportedBindings,
  functionInfo,
  bindings,
  thisBindingByScope,
}: AnalysisState) {
  /*
  (See analyzeScopes for a description of this pass)

  This function is implemented as a single tree-traversal pass using
  `traverseAST`. It maintains a `scopeStack` to keep track of what lexical scope
  the cursor is in. When it encounters a new scope AST node (e.g. function or
  block scope), it will push the scope onto the stack and enumerate the local
  bindings. When it encounters a reference node (e.g. a variable or parameter
  reference), it iterates up the stack to find the binding or falls back to
  creating a free variable (`freeVariableNames`).

  A `this` reference can either resolve to a local argument (if using the
  caller-passed this) or to the `this` value in the parent (if using lexical
  this, as in arrow functions). The `this` value in the parent may again resolve
  to a parameter or to _its_ parent's `this` value, etc.
  */

  const scopeStack: Scope[] = [];
  const currentScope = () => notUndefined(scopeStack[scopeStack.length - 1]);

  inner(file.program);

  function inner(node_: B.Node) {
    const node = node_ as B.Program | B.SupportedStatement | B.SupportedExpression;
    visitingNode(cur, node);
    switch (node.type) {
      // Scope nodes
      case 'Program': return createModuleScope(node);
      case 'FunctionDeclaration': return createFunctionDeclarationScope(node);
      case 'ArrowFunctionExpression': return createArrowFunctionScope(node);
      case 'BlockStatement': return createBlockScope(node);

      // Reference nodes
      case 'Identifier': return createVariableReference(node);
      case 'ThisExpression': return createVariableReference(node);

      // Other
      case 'AssignmentExpression': return handleAssignmentExpression(node);

      default:
        traverseAST(cur, node, inner);
    }

    function handleAssignmentExpression(node: B.AssignmentExpression) {
      inner(node.left);
      inner(node.right);

      // This is basically to determine which slots need to be mutable. The main
      // reason for this is to decide which parameters need to be copied into
      // local slots.
      if (node.left.type === 'Identifier') {
        const reference = references.get(node.left) ?? unexpected();
        const binding = reference.binding;
        binding && (binding.isWrittenTo = true);
      }
    }

    function createModuleScope(node: B.Program) {
      const scope = pushModuleScope(node);
      const statements = node.body;

      findImportsAndExports(node);

      for (const statement of statements) {
        findHoistedVariables(statement);
      }

      // Lexical variables are also found upfront because nested functions can
      // reference variables that are declared further down than the nested
      // function (TDZ). (But `findLexicalVariables` isn't recursive)
      findLexicalVariables(statements);

      // Iterate through the function/program body to find variable usage
      for (const statement of statements) {
        inner(statement);
      }

      popScope(scope);
    }

    function createFunctionDeclarationScope(node: B.FunctionDeclaration) {
      const scope = pushFunctionScope(node, false);
      scope.funcName = node.id?.name;
      createParameterBindings(node.params);
      const statements = node.body.body;

      statements.forEach(findHoistedVariables);

      // Lexical variables are also found upfront because nested functions can
      // reference variables that are declared further down than the nested
      // function (TDZ). (But `findLexicalVariables` isn't recursive)
      findLexicalVariables(statements);

      // Iterate through the body to find variable usage
      statements.forEach(inner);

      popScope(scope);
    }

    function createArrowFunctionScope(node: B.ArrowFunctionExpression) {
      const scope = pushFunctionScope(node, true);
      createParameterBindings(node.params);
      const body = node.body;

      if (body.type === 'BlockStatement') {
        const statements = body.body;
        statements.forEach(findHoistedVariables);

        // Lexical variables are also found upfront because nested functions can
        // reference variables that are declared further down than the nested
        // function (TDZ). (But `findLexicalVariables` isn't recursive)
        findLexicalVariables(statements);

        statements.forEach(inner);
      } else {
        /* Note: Arrow functions with expression bodies do not have any hoisted variables */
        inner(body);
      }

      popScope(scope);
    }

    function createBlockScope(node: B.BlockStatement) {
      // Creates a lexical scope
      const scope = pushBlockScope(node);
      // Here we don't need to populate the hoisted variables because they're
      // already populated by the containing function/program
      findLexicalVariables(node.body);
      for (const statement of node.body) {
        inner(statement);
      }
      popScope(scope);
    }

    function createVariableReference(node: B.Identifier | B.ThisExpression) {
      const name = node.type === 'Identifier' ? node.name : '#this';
      const binding = node.type === 'Identifier'
        ? findBinding(name)
        : findThisBinding();

      if (binding) {
        binding.isUsed = true;
        const currentFunction = containingFunction(currentScope());
        const bindingFunction = containingFunction(binding.scope);
        const isInLocalFunction = bindingFunction === currentFunction;

        // Note that this includes block-scoped variables for blocks at the root level
        const mustBeClosureAllocated = !isInLocalFunction && binding.scope.type !== 'ModuleScope';
        if (mustBeClosureAllocated) {
          if (!currentFunction) unexpected();
          bindingIsClosureAllocated.add(binding);
          markClosureChain(currentFunction, bindingFunction);
        }
        const reference: VariableReferenceInfo = {
          name: name,
          identifier: node,
          binding,
          isInLocalFunction,
          nearestScope: currentScope(),
          access: undefined as any // Will be populated in a later phase
        };
        references.set(node, reference);
        currentScope().references.push(reference);
      } else { // Binding not found
        if (node.type === 'ThisExpression') {
          // The `this` expression must evaluate to undefined
          const reference: VariableReferenceInfo = {
            name: name,
            identifier: node,
            isInLocalFunction: false,
            nearestScope: currentScope(),
            access: { type: 'UndefinedAccess' }
          };
          references.set(node, reference);
          currentScope().references.push(reference);
        } else {
          // Free variable reference
          const reference: VariableReferenceInfo = {
            name: name,
            identifier: node,
            isInLocalFunction: false,
            nearestScope: currentScope(),
            access: undefined as any // Will be populated in a later phase
          };
          freeVariableNames.add(name);
          references.set(node, reference);
          currentScope().references.push(reference);
        }
      }
    }

    function findBinding(name: string): Binding | undefined {
      // Loop through the scope stack starting from the inner-most and working
      // out until we find it
      for (let i = scopeStack.length - 1; i >= 0; i--) {
        const scope = scopeStack[i];
        const binding = scope.bindings[name];
        if (binding) {
          return binding;
        }
      }
      // If a binding is not found, it's a free variable (a reference to a global)
      return undefined;
    }

    function findThisBinding(): Binding | undefined {
      // Loop through the scope stack starting from the inner-most and working
      // out until we find it
      for (let i = scopeStack.length - 1; i >= 0; i--) {
        const scope = scopeStack[i];
        const binding = scope.type === 'FunctionScope' && thisBindingByScope.get(scope);
        if (binding) {
          return binding;
        }
      }
      // If a binding is not found, it's a free variable (a reference to a global)
      return undefined;
    }

    // Mark all the functions from referencingFunction (inclusive) to
    // bindingFunction (exclusive) as needing to be closures (because they
    // access their outer scope). Note that "undefined" here refers to the
    // module scope.
    function markClosureChain(
      referencingFunction: FunctionScope | undefined,
      bindingFunction: FunctionScope | undefined
    ) {
      let cursor = referencingFunction;
      while (cursor !== bindingFunction) {
        if (!cursor) unexpected();
        cursor.functionIsClosure = true;
        cursor = containingFunction(cursor.parent);
      }
    }

    // Returns the innermost function containing or equal to the given scope,
    // or undefined if the given scope is not within a function (e.g. it's at
    // the model level)
    function containingFunction(scope: Scope): FunctionScope | undefined {
      let current: Scope | undefined = scope;
      while (current !== undefined && current.type !== 'FunctionScope')
        current = current.parent;
      return current;
    }
  }

  // This function looks for var and function declarations for a variable scope
  // (program- or function-level) and creates bindings for them in the current
  // scope.
  function findHoistedVariables(
    statement: B.Statement
  ) {
    traverse(statement);

    function traverse(node_: B.Node) {
      const node = node_ as B.SupportedNode;
      switch (node.type) {
        case 'ExportNamedDeclaration':
        case 'ImportDeclaration':
          break; // Handled separately
        case 'VariableDeclaration': {
          // This function is only looking for hoisted variables
          if (node.kind === 'var') {
            bindVariableDeclaration(node);
          }
          break;
        }
        case 'FunctionDeclaration': {
          if (node.id) {
            bindFunctionDeclaration(node);
          }
          break;
        }
        case 'ArrowFunctionExpression':
          break;
        default:
          // We don't want to recurse into nested functions accidentally
          if (B.isFunctionNode(node)) assertUnreachable(node);

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
  ) {
    for (const statement of statements) {
      if (statement.type === 'ExportNamedDeclaration' || statement.type === 'ImportDeclaration')
        continue; // Handled separately

      visitingNode(cur, statement);
      if (statement.type === 'VariableDeclaration' && statement.kind !== 'var') {
        hardAssert(statement.kind === 'const' || statement.kind === 'let');

        for (const declaration of statement.declarations) {
          const id = declaration.id;
          if (id.type !== 'Identifier') {
            visitingNode(cur, id);
            return compileError(cur, 'Syntax not supported')
          }
          const name = id.name;

          createBindingAndSelfReference(name, statement.kind, declaration);
        }
      }
    }
  }

  function bindFunctionDeclaration(node: B.FunctionDeclaration) {
    const id = node.id ?? unexpected();
    const name = id.name;
    return createBindingAndSelfReference(name, 'function', node);
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
    for (const specifier of statement.specifiers) {
      visitingNode(cur, specifier);
      const localName = specifier.local.name;
      const binding = createBindingAndSelfReference(localName, 'import', specifier);
      importBindingInfo.set(binding, {
        source: statement.source.value,
        specifier
      });
    }
  }

  function bindNamedExports(statement: B.ExportNamedDeclaration) {
    if (statement.source || statement.specifiers.length) {
      return compileError(cur, 'Only simple export syntax is supported')
    }
    const declaration = statement.declaration;
    if (!declaration) {
      // Older versions of babel didn't seem to allow for a null declaration,
      // so I'm thinking maybe it's to support a new language feature. I
      // haven't looked into it. (Note: this might be to support `export { x
      // as y }` syntax)
      return featureNotSupported(cur, 'Expected a declaration');
    }
    let bindings: Binding[];
    if (declaration.type === 'VariableDeclaration') {
      bindings = bindVariableDeclaration(declaration);
    } else if (declaration.type === 'FunctionDeclaration') {
      bindings = [bindFunctionDeclaration(declaration)];
    } else {
      return compileError(cur, `Not supported: export of ${declaration.type}`);
    }
    bindings.forEach(b => exportedBindings.set(b, statement));
  }

  function bindVariableDeclaration(decl: B.VariableDeclaration) {
    const bindings: Binding[] = [];
    for (const node of decl.declarations) {
      if (node.id.type !== 'Identifier') {
        return compileError(cur, 'Only simple variable declarations are supported.')
      }
      const name = node.id.name;
      if (!isNameString(name)) {
        return compileError(cur, `Invalid variable identifier: "${name}"`);
      }

      const binding = createBindingAndSelfReference(name, 'var', node);
      bindings.push(binding);
    }
    return bindings;
  }

  function pushModuleScope(node: ScopeNode) {
    const scope: ModuleScope = {
      type: 'ModuleScope',
      bindings: Object.create(null),
      children: [],
      references: [],
      parent: undefined,
      moduleSlots: undefined as any, // Will be populated in a subsequent pass
      localSlots: undefined as any, // Will be populated in a subsequent pass  (WIP)
      ilParameterInitializations: undefined as any, // Added separately (WIP)
      functionIsClosure: false,
    };
    pushScope(node, scope);
    return scope;
  }

  function pushFunctionScope(node: B.SupportedFunctionNode, hasThisBinding: boolean) {
    const scope: FunctionScope = {
      type: 'FunctionScope',
      funcName: node.type === 'FunctionDeclaration' ? node.id?.name : undefined,
      bindings: Object.create(null),
      children: [],
      references: [],
      parent: currentScope(),
      localSlots: undefined as any, // Will be populated in a subsequent pass
      ilParameterInitializations: undefined as any, // Added separately
      // Assume the function is not a closure until we find a free variable
      // that references the outer scope
      functionIsClosure: false,
    };

    if (hasThisBinding) {
      const thisBinding = createBinding('#this', 'this', undefined);
      thisBindingByScope.set(scope, thisBinding);
    }

    pushScope(node, scope);

    functionInfo.set(scope, node);
    return scope;
  }

  function pushBlockScope(node: ScopeNode) {
    const scope: BlockScope = {
      type: 'BlockScope',
      bindings: Object.create(null),
      children: [],
      references: [],
      parent: currentScope()
    };
    pushScope(node, scope);
    return scope;
  }

  function pushScope(node: ScopeNode, scope: Scope) {
    const parent = scopeStack[scopeStack.length - 1]; // Can be undefined
    scopes.set(node, scope);
    parent && parent.children.push(scope);
    scopeStack.push(scope);
  }

  function popScope(scope: Scope) {
    hardAssert(scopeStack[scopeStack.length - 1] === scope);
    scopeStack.pop();
  }

  function createParameterBindings(params: (B.FunctionDeclaration | B.ArrowFunctionExpression)['params']) {
    for (const param of params) {
      if (param.type !== 'Identifier')
        return compileError(cur, 'Not supported');
      createBindingAndSelfReference(param.name, 'param', param);
    }
  }

  function createBindingAndSelfReference(name: string, kind: Binding['kind'], node: BindingNode) {
    const binding = createBinding(name, kind, node);

    const selfReference = getDeclarationSelfReference(node)

    if (selfReference) {
      references.set(selfReference, {
        name: name,
        identifier: selfReference,
        isInLocalFunction: true,
        nearestScope: currentScope(),
        binding: binding,
        access: undefined as any // Will be populated in a later phase
      })
    }

    return binding;

    function getDeclarationSelfReference(node: BindingNode): B.Identifier | undefined {
      switch (node.type) {
        case 'FunctionDeclaration': return node.id ?? undefined;
        case 'Identifier': return node;
        case 'VariableDeclarator':
          return node.id.type === 'Identifier'
            ? node.id
            : undefined;
        case 'ImportDefaultSpecifier': return node.local;
        case 'ImportSpecifier': return node.local;
        case 'ImportNamespaceSpecifier': return node.local;
        default:
          return assertUnreachable(node);
      }
    }
  }

  function createBinding(name: string, kind: Binding['kind'], node?: BindingNode) {
    const readonly = kind === 'const';

    const scope = currentScope();
    const scopeBindings = scope.bindings;

    const isLexical = kind === 'let' || kind === 'const';

    if (isLexical && name in scopeBindings) {
      return compileError(cur, `Variable "${name}" already declared in scope`)
    }

    const binding: Binding = {
      kind,
      name,
      // We do slot assignment in a separate pass
      slot: undefined as any,
      scope: currentScope(),
      node,
      readonly,
      // By default we assume that the binding is unused, until we find a
      // usage (a reference to the binding)
      isUsed: false,
      // Assume by default that the variable is not written to,
      isWrittenTo: false,
    };

    scopeBindings[name] = binding;
    binding.node && bindings.set(binding.node, binding);

    return binding;
  }
}