import { assertUnreachable, hardAssert, isNameString, notUndefined, unexpected, uniqueName } from '../utils';
import { compileError, featureNotSupported, SourceCursor, visitingNode } from './common';
import * as B from './supported-babel-types';
import { traverseAST } from './traverse-ast';

export interface ScopesInfo {
  scopes: Map<ScopeNode, Scope>;
  references: Map<B.Identifier, VariableReferenceInfo>;
  bindings: Map<BindingNode, Binding>;

  // Root-level scope of the scope tree
  moduleScope: ModuleScope;

  // The names of free variables not bound to any module-level variable
  freeVariables: string[];

  // The slot created for the module namespace object of the current module
  thisModuleSlot: ModuleSlot;

  // The slots generated for all the import namespace objects
  moduleImports: { slot: ModuleSlot, specifier: string }[];
}

export type Scope =
  | ModuleScope
  | FunctionScope
  | BlockScope

export type Slot =
  | ModuleSlot
  | ClosureSlot
  | LocalSlot
  | ModuleImportExportSlot

// An IL variable slot at the module level
export interface ModuleSlot {
  type: 'ModuleSlot';
  name: string;
}

// An IL variable slot at the module level
export interface ClosureSlot {
  type: 'ClosureSlot';
  index: number;
}

// An IL variable in the local function
export interface LocalSlot {
  type: 'LocalSlot';
  index: number;
}

// A slot for an exported or imported binding
export interface ModuleImportExportSlot {
  type: 'ModuleImportExportSlot';
  moduleNamespaceObjectSlot: ModuleSlot;
  propertyName: string;
}

export interface ScopeBase {
  // Variables in the given scope. For hoisted variables and function
  // declarations, these will appear as bindings at the function level even if
  // they've been declared physically in nested blocks.
  bindings: { [name: string]: Binding };
  // Nested scopes in this scope
  children: Scope[];
  // More for debug purposes, but this is a list of references (identifiers)
  // directly contained within the scope.
  references: VariableReferenceInfo[];
}

export interface FunctionScope extends ScopeBase {
  type: 'FunctionScope';

  // The function name, or undefined if the function is anonymous
  funcName?: string;

  // The outer scope
  parent: Scope;

  // The parameters of the function will need to be copied from the arguments
  // into slots that match other references that access the parameters.
  //
  // Note that the first ilParameter is the `this` value. The second ilParamter
  // is the first user-provided paramter.
  //
  // Note that parameters are mutable, whereas arguments are not, since you
  // can't guarantee what count of arguments are actually provided. Note that
  // for efficiency, the parameter slots always start at index zero and are
  // contiguous.
  ilParameterInitializations: ParameterInitializations[];

  // Local variable slots to allocate for this function, including for nested
  // function declarations and hoisted variables
  localSlots: LocalSlot[];

  // True if the function (or a child of the function) references variables from
  // its parent (or parent's parent, etc). This does not necessarily mean that
  // it needs to have its own closure scope.
  functionIsClosure: boolean;

  // The closure slots to allocate for this function, or undefined if the
  // function needs no closure slots.
  closureSlots?: ClosureSlot[];
}

export interface ModuleScope extends ScopeBase {
  type: 'ModuleScope';

  // The outer scope
  parent: undefined;

  // Slots that need to be allocated at the module level. Note that there may be
  // more slots than bindings since some slots do not correspond to
  // user-declared variables. Also note that the names of slots do not need to
  // correspond to the names of variables, since the algorithm needs to find
  // unique names and the namespace includes undeclared variables.
  moduleSlots: ModuleSlot[];

  // These properties are like those of "FunctionScope" and apply to the entry
  // function of the module
  ilParameterInitializations: ParameterInitializations[];
  functionIsClosure: boolean;
  localSlots: LocalSlot[];
  closureSlots?: ClosureSlot[];
}

// See also `compileParam`
export interface ParameterInitializations {
  argIndex: number;
  parameterLocation: 'ClosureSlot' | 'LocalSlot';
  slotIndex: number;
}

export interface BlockScope extends ScopeBase {
  type: 'BlockScope';
  // The outer scope
  parent: Scope;
}

// This gives information about variables and parameters in the script in a
// particular scope. Note that not all slots are associated with variable
// bindings. For example, there is a global slot associated with the current
// module object, but this is not declared by the user's script.
export interface Binding {
  // The lexical construct that defines the binding
  kind:
    | 'param'
    | 'var'
    | 'const'
    | 'let'
    | 'function'
    | 'import'   // Variable created by an `import` statement
  // The name bound to (the declared variable, function or parameter name)
  name: string;
  isUsed: boolean;
  // The slot in which to store the variable. If the variable is not used, the slot can be undefined
  slot?: Slot;
  scope: Scope;
  node: BindingNode;
  readonly: boolean;
  // closureAllocated: boolean;
}

export interface VariableReferenceInfo {
  name: string;
  identifier: B.Identifier; // WIP do we need this?
  // Is the referenced variable is in the current function?
  isInLocalFunction: boolean; // WIP do we need this?
  // The referenced binding, unless the variable is a free variable
  binding?: Binding;
  // How to read/write the variable
  access: SlotAccessInfo;
  // The scope in which the variable reference occurs
  nearestScope: Scope; // WIP do we need this?
}

export type SlotAccessInfo =
  | FreeVariableSlotAccess
  | ModuleSlotAccess
  | ModuleImportExportSlotAccess
  | ClosureSlotAccess
  | LocalSlotAccess

export interface FreeVariableSlotAccess {
  type: 'FreeVariableSlotAccess';
  name: string;
}

export interface ModuleSlotAccess {
  type: 'ModuleSlotAccess';
  name: string; // WIP: when we generate new module slot names, we need to make sure they don't conflict with referenced global variable names
}

export interface ModuleImportExportSlotAccess {
  type: 'ModuleImportExportSlotAccess';
  moduleNamespaceObjectSlotName: string;
  propertyName: string;
}

export interface ClosureSlotAccess {
  type: 'ClosureSlotAccess';
  relativeIndex: number;
}

export interface LocalSlotAccess {
  type: 'LocalSlotAccess';
  index: number;
}

export type ScopeNode = B.Program | B.SupportedFunctionNode | B.Block;

export type BindingNode =
  | B.VariableDeclarator // For variable declarations
  | B.FunctionDeclaration // For function declarations
  | B.Identifier // For parameters
  | B.ImportSpecifier | B.ImportDefaultSpecifier | B.ImportNamespaceSpecifier // For imports

type ImportSpecifier = B.ImportSpecifier | B.ImportDefaultSpecifier | B.ImportNamespaceSpecifier;

/*
This does analysis of scopes and variables.

  - Resolve identifiers to their corresponding declarations (bindings).
  - Calculate how many variables are in each scope and assign indexes to each of them.
  - Compute closure information
*/
export function analyzeScopes(file: B.File, filename: string): ScopesInfo {
  /*
  Note: the code in this function is organized into a nested hierarchy for
  organizational purposes only. The only closure variables used are those in the
  root function here.
  */
  const scopes = new Map<ScopeNode, Scope>();
  const references = new Map<B.Identifier, VariableReferenceInfo>();
  const bindings = new Map<BindingNode, Binding>();
  const freeVariableNames = new Set<string>();
  const bindingIsClosureAllocated = new Set<Binding>();
  const importBindingInfo = new Map<Binding, { source: string, specifier: ImportSpecifier }>();
  const functionInfo = new Map<FunctionScope, B.SupportedFunctionNode>();
  const exportedBindings = new Map<Binding, B.ExportNamedDeclaration>();
  let thisModuleSlot: ModuleSlot = undefined as any; // Populated in computeSlots
  const importedModuleNamespaceSlots = new Map<string, ModuleSlot>(); // Populated in computeSlots

  const cur: SourceCursor = { filename, node: file };

  // 1. Iterate the AST and build up a hierarchy of scopes and their bindings,
  //    and calculate references from variable identifiers to the corresponding
  //    binding. This also marks which variables need to be closure-allocated
  //    and which functions need to be closures.
  findScopesAndVariables(file.program);

  // 2. Generate slots for all used bindings
  computeSlots();

  // 3. Calculate relative indexes for closure variable lookups and other
  //    accessors
  computeLookupIndexes();

  const root = scopes.get(file.program) || unexpected();
  if (root.type !== 'ModuleScope') return unexpected();

  return {
    scopes,
    references,
    bindings,
    moduleScope: root,
    freeVariables: [...freeVariableNames],
    thisModuleSlot,
    moduleImports: [...importedModuleNamespaceSlots]
      .map(([specifier, slot]) => ({ slot, specifier }))
  };

  function findScopesAndVariables(node_: B.Node): void {
    const scopeStack: Scope[] = [];
    const currentScope = () => notUndefined(scopeStack[scopeStack.length - 1]);

    inner(node_);

    function inner(node_: B.Node) {
      const node = node_ as B.Program | B.SupportedStatement | B.SupportedExpression;
      visitingNode(cur, node);
      switch (node.type) {
        case 'Program': return createModuleScope(node);
        case 'FunctionDeclaration': return createFunctionDeclarationScope(node);
        case 'ArrowFunctionExpression': return createArrowFunctionScope(node);
        case 'BlockStatement': return createBlockScope(node);
        case 'Identifier': return createVariableReference(node);
        default:
          traverseAST(cur, node, findScopesAndVariables);
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
          findScopesAndVariables(statement);
        }

        popScope(scope);
      }

      function createFunctionDeclarationScope(node: B.FunctionDeclaration) {
        const scope = pushFunctionScope(node);
        scope.funcName = node.id?.name;
        createParameterBindings(node.params);
        const statements = node.body.body;

        statements.forEach(findHoistedVariables);

        // Lexical variables are also found upfront because nested functions can
        // reference variables that are declared further down than the nested
        // function (TDZ). (But `findLexicalVariables` isn't recursive)
        findLexicalVariables(statements);

        // Iterate through the body to find variable usage
        statements.forEach(findScopesAndVariables);

        popScope(scope);
      }

      function createArrowFunctionScope(node: B.ArrowFunctionExpression) {
        const scope = pushFunctionScope(node);
        createParameterBindings(node.params);
        const body = node.body;

        if (body.type === 'BlockStatement') {
          const statements = body.body;
          statements.forEach(findHoistedVariables);

          // Lexical variables are also found upfront because nested functions can
          // reference variables that are declared further down than the nested
          // function (TDZ). (But `findLexicalVariables` isn't recursive)
          findLexicalVariables(statements);

          statements.forEach(findScopesAndVariables);
        } else {
          /* Note: Arrow functions with expression bodies do not have any hoisted variables */
          findScopesAndVariables(body);
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
          findScopesAndVariables(statement);
        }
        popScope(scope);
      }

      function createVariableReference(node: B.Identifier) {
        const name = node.name;
        const binding = findBinding(name);
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
        } else {
          // Else, it's a free variable reference
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

    function pushFunctionScope(node: B.SupportedFunctionNode) {
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
      };

      scopeBindings[name] = binding;
      bindings.set(binding.node, binding);

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

      function getDeclarationSelfReference(node: Binding['node']): B.Identifier | undefined {
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
  }

  function computeSlots() {
    /*
    This function calculates the size of each closure scope, and the index of
    each variable in the closure scope.

    Closure scopes are associated with functions, not lexical scopes, so
    multiple lexical scopes can live in the same closure scope. Originally I
    thought that these could stack up such that the same slot could be reused by
    multiple lexical variables if they existed in different blocks. However,
    since closure variables outlive the execution of their block, this doesn't
    make sense.

    The new algorithm just just assigns a new slot for each variable.
    */

    const root = scopes.get(file.program) || unexpected();
    visitingNode(cur, file);
    if (root.type !== 'ModuleScope') unexpected();
    computeModuleSlots(root);

    function computeModuleSlots(moduleScope: ModuleScope) {
      moduleScope.moduleSlots = [];

      const slotNames = new Set<string>();
      const newModuleSlot = (nameHint: string): ModuleSlot => {
        // Note: the generated names can't conflict with existing module names
        // OR free variable names since we use the same IL instruction to load
        // both.
        const name = uniqueName(nameHint, n => slotNames.has(n) || freeVariableNames.has(n));
        slotNames.add(name);
        const slot: ModuleSlot = { type: 'ModuleSlot', name };
        moduleScope.moduleSlots.push(slot);
        return slot;
      };

      // WIP: since ModuleScope now also has ilParameters, it might make sense
      // to have `thisModuleSlot` as an IL parameter with a module-level slot as
      // its target.
      thisModuleSlot = newModuleSlot('thisModule');

      const getImportedModuleNamespaceSlot = (moduleSource: string) => {
        let slot = importedModuleNamespaceSlots.get(moduleSource);
        if (!slot) {
          slot = newModuleSlot(moduleSource);
          importedModuleNamespaceSlots.set(moduleSource, slot);
        }
        return slot;
      };

      // Root-level bindings
      for (const binding of Object.values(moduleScope.bindings)) {
        if (binding.isUsed)
          binding.slot = computeModuleSlot(binding);
      }

      // Compute entry-function slots (this will skip any bindings that already
      // have slots assigned, such as module slots)
      computeFunctionSlots(moduleScope);

      function computeModuleSlot(binding: Binding): Slot {
        if (importBindingInfo.has(binding)) {
          return computeImportBindingSlot(binding);
        } else if (exportedBindings.has(binding)) {
          return computeExportBindingSlot(binding);
        } else {
          return newModuleSlot(binding.name);
        }
      }

      function computeImportBindingSlot(binding: Binding): Slot {
        const { source, specifier } = importBindingInfo.get(binding) ?? unexpected();
        const moduleNamespaceObjectSlot = getImportedModuleNamespaceSlot(source);

        switch (specifier.type) {
          // import x as y from 'z'
          case 'ImportSpecifier':
            return {
              type: 'ModuleImportExportSlot',
              moduleNamespaceObjectSlot,
              propertyName:
                specifier.imported.type === 'Identifier' ? specifier.imported.name :
                specifier.imported.type === 'StringLiteral' ? specifier.imported.value :
                assertUnreachable(specifier.imported)
            };

          // import * as y from 'z';
          case 'ImportNamespaceSpecifier':
            return moduleNamespaceObjectSlot;

          // import y from 'z';
          case 'ImportDefaultSpecifier':
            return {
              type: 'ModuleImportExportSlot',
              moduleNamespaceObjectSlot,
              propertyName: 'default'
            };

          default: assertUnreachable(specifier);
        }
      }

      function computeExportBindingSlot(binding: Binding): Slot {
        const exportedDeclaration = exportedBindings.get(binding) ?? unexpected();
        // WIP Does this cover both exported variables and function declarations? Would be good to add some unit tests
        if (exportedDeclaration.source || exportedDeclaration.specifiers.length) {
          return unexpected();
        }
        return {
          type: 'ModuleImportExportSlot',
          moduleNamespaceObjectSlot: thisModuleSlot,
          propertyName: binding.name
        }
      }
    }

    // Note: this function takes either FunctionScope or ModuleScope because it
    // is also used to compute slots for the entry function. Essentially, we
    // treat the module as a special kind of function that also has module
    // slots.
    function computeFunctionSlots(functionScope: FunctionScope | ModuleScope) {
      const closureSlots: ClosureSlot[] = [];
      functionScope.localSlots = [];

      const getLocalSlot = (index: number) =>
        functionScope.localSlots[index] ??= { type: 'LocalSlot', index };

      const nextLocalSlot = () => getLocalSlot(functionScope.localSlots.length);

      functionScope.ilParameterInitializations = [];

      if (functionScope.type === 'FunctionScope') {
        // The first IL parameter is the `this` value
        functionScope.ilParameterInitializations.push({
          argIndex: 0,
          // WIP: err.. I need to think about how to handle `this`
          parameterSlot: nextLocalSlot()
        });

        // The remaining IL parameters correspond to the named parameters of the function
        const functionNode = functionInfo.get(functionScope) ?? unexpected();
        for (const [paramI, param] of functionNode.params.entries()) {
          visitingNode(cur, param);
          if (param.type !== 'Identifier')
            return compileError(cur, 'Only simple named parameters supported');

          functionScope.ilParameterInitializations.push({
            argIndex: paramI + 1,
            parameterSlot: nextLocalSlot()
          })
        }
      }

      // Recurse tree
      computeFunctionSlotsInner(functionScope, functionScope.localSlots.length);

      function computeFunctionSlotsInner(inner: Scope, localSlotsUsed: number) {
        for (const binding of Object.values(inner.bindings)) {
          if (!binding.isUsed) continue;

          // The ModuleScope is mostly like a function scope, but with the
          // root-level slots being module slots or import/export slots. So the
          // way I've structured the code is that computeModuleSlots assigns
          // those module-specific slots and then computeFunctionSlots assigns
          // everything left at the module level. So here we can skip bindings
          // that already have a slot assigned.
          if (binding.slot) continue;

          if (bindingIsClosureAllocated.has(binding)) {
            binding.slot = { type: 'ClosureSlot', index: closureSlots.length };
            closureSlots.push(binding.slot);
            functionScope.closureSlots = closureSlots;
          } else {
            const index = localSlotsUsed++;
            // Note that variables from multiple successive blocks can share the same local slot
            binding.slot = getLocalSlot(index);
          }
        }

        for (const child of inner.children) {
          switch (child.type) {
            // Blocks within the function still correspond to function slots
            case 'BlockScope': computeFunctionSlotsInner(child, localSlotsUsed); break;
            case 'FunctionScope': computeFunctionSlots(child); break;
            case 'ModuleScope': unexpected();
            default: assertUnreachable(child);
          }
        }
      }
    }
  }

  function computeLookupIndexes() {
    /*
    The instructions LoadScoped and StoreScoped take a _relative_ index, that in
    some sense "overflows" from the current scope into the parent scope. This
    function computes the relative indices.
    */

    for (const reference of references.values()) {
      reference.access = getAccessForReference(reference);
    }

    function getAccessForReference(reference: VariableReferenceInfo): SlotAccessInfo {
      const binding = reference.binding;

      // If there's no binding then this is a free variable
      if (!binding) {
        return {
          type: 'FreeVariableSlotAccess',
          name: reference.name
        };
      }

      const slot = binding.slot;
      // Slots are only undefined if there's no reference. But of course, we've
      // found this binding from a reference so it shouldn't be undefined.
      if (!slot) unexpected();

      switch (slot.type) {
        case 'LocalSlot': return { type: 'LocalSlotAccess', index: slot.index };
        case 'ModuleSlot': return { type: 'ModuleSlotAccess', name: slot.name };
        case 'ModuleImportExportSlot': return {
          type: 'ModuleImportExportSlotAccess',
          moduleNamespaceObjectSlotName: slot.moduleNamespaceObjectSlot.name,
          propertyName: slot.propertyName
        }
        case 'ClosureSlot': {
          // Start at the nearest scope and work backwards
          let scope = reference.nearestScope;
          const targetScope = binding.scope;
          let relativeIndex = 0;
          // While we're not in the scope containing the variable, move to the parent scope
          while (scope !== targetScope) {
            if (scope.type === 'FunctionScope') {
              if (scope.closureSlots) {
                relativeIndex += scope.closureSlots.length;
              }
              // In order for us to hop from the child to the parent function,
              // we'll need to have a reference to the parent scope at runtime,
              // which means the function we're hopping from must itself be a
              // closure.
              hardAssert(scope.functionIsClosure);
            }
            scope = scope.parent || unexpected();
          }
          relativeIndex += slot.index;
          return {
            type: 'ClosureSlotAccess',
            relativeIndex
          }
        }
        default: assertUnreachable(slot);
      }
    }
  }
}