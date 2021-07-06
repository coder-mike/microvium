import * as B from '../supported-babel-types';

/** The output model of `analyzeScopes()` */
export interface ScopesInfo {
  scopes: Map<ScopeNode, Scope>;
  references: Map<ReferencingNode, VariableReferenceInfo>;
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
  | ArgumentSlot
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

// A readonly slot accessed by `LoadArg`
export interface ArgumentSlot {
  type: 'ArgumentSlot';
  argIndex: number;
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

  // At least some of the parameters of the function will need to be copied from
  // the arguments into other slots such as local variable slots or closure
  // slots, if they're mutated or accessed by nested functions.
  //
  // Note that the first argument is the `this` value. The second argument is
  // the first user-provided paramter, etc. But not all arguments have
  // corresponding "parameter initializations" since it depends if they're
  // mutated or accessed from nested functions.
  //
  // Note that the order is important here. The expectation is that
  // `ilParameterInitializations` is used to emit the function prelude IL
  // directly after and closure scope exists (if needed) and before any user
  // statements are executed.
  ilParameterInitializations: ParameterInitialization[];

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
  ilParameterInitializations: ParameterInitialization[];
  functionIsClosure: boolean;
  localSlots: LocalSlot[];
  closureSlots?: ClosureSlot[];
}

// See also `compileParam`
export interface ParameterInitialization {
  // Index to `LoadArg` from
  argIndex: number;
  // Slot to store to (as accessed relative to the function prelude)
  slot: LocalSlotAccess | ClosureSlotAccess;
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
    | 'this'
    | 'function'
    | 'import'   // Variable created by an `import` statement
  // The name to which the variable is bound (the declared variable, function or parameter name)
  name: string;
  isUsed: boolean;
  // The slot in which to store the variable. If the variable is not used, the slot can be undefined
  slot?: Slot;
  scope: Scope;
  // The variable declaration AST node. Note that `this` bindings don't have a node
  node?: BindingNode;
  readonly: boolean; // Syntactically readonly. E.g. `const`

  /**
   * True if some assignment operation targets this variable (beyond just
   * initialization)
   *
   * This is intended for use in parameter optimization. If a parameter is not
   * assigned to, then the argument slot (`LoadArg`) can be used directly.
   */
  isWrittenTo: boolean;
  // closureAllocated: boolean;
}

export interface VariableReferenceInfo {
  name: string;
  identifier: ReferencingNode; // WIP do we need this?
  // Is the referenced variable is in the current function?
  isInLocalFunction: boolean; // WIP do we need this?
  // The referenced binding, unless the variable is a free variable
  binding?: Binding;
  // How to read/write the variable
  access: SlotAccessInfo;
  // The scope in which the variable reference occurs
  nearestScope: Scope; // WIP do we need this?
}

/*
 * Describes how to access a variable.
 *
 * Note that how to access it depends on the context, since closure slot indexes
 * are relative.
 */
export type SlotAccessInfo =
  | GlobalSlotAccess
  | ModuleImportExportSlotAccess
  | ClosureSlotAccess
  | LocalSlotAccess
  | ArgumentSlotAccess
  | UndefinedAccess

// Access using LoadGlobal/StoreGlobal
export interface GlobalSlotAccess {
  type: 'GlobalSlotAccess';
  name: string;
}
// Access using ObjectGet/ObjectSet
export interface ModuleImportExportSlotAccess {
  type: 'ModuleImportExportSlotAccess';
  moduleNamespaceObjectSlotName: string;
  propertyName: string;
}

// Access using LoadScoped/StoreScoped
export interface ClosureSlotAccess {
  type: 'ClosureSlotAccess';
  relativeIndex: number;
}

// Access using LoadVar/StoreVar
export interface LocalSlotAccess {
  type: 'LocalSlotAccess';
  index: number;
}

// Access using LoadArg
export interface ArgumentSlotAccess {
  type: 'ArgumentSlotAccess';
  index: number;
}

// A value that always reads as `undefined`
export interface UndefinedAccess {
  type: 'UndefinedAccess';
}

export type ScopeNode = B.Program | B.SupportedFunctionNode | B.Block;

export type BindingNode =
  | B.VariableDeclarator // For variable declarations
  | B.FunctionDeclaration // For function declarations
  | B.Identifier // For parameters
  | B.ImportSpecifier | B.ImportDefaultSpecifier | B.ImportNamespaceSpecifier // For imports

export type ReferencingNode =
  | B.Identifier
  | B.ThisExpression

export type ImportSpecifier =
  | B.ImportSpecifier
  | B.ImportDefaultSpecifier
  | B.ImportNamespaceSpecifier;
