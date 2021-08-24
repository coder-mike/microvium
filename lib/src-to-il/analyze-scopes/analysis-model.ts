import { IL } from '../../../lib';
import * as B from '../supported-babel-types';

/**
 * The output model of `analyzeScopes()`
 */
export interface AnalysisModel {
  /**
   * All functions in the unit, including nested and arrow functions but not the
   * module entry function.
   */
  functions: FunctionScope[];

  // These are lookups that answer "how do I compile this AST node?"
  scopes: Map<ScopeNode, Scope>;
  references: Map<ReferencingNode, Reference>;
  bindings: Map<BindingNode, Binding>;

  // Root-level scope of the scope tree
  moduleScope: ModuleScope;

  // The names of free variables not bound to any module-level variable
  freeVariables: Set<string>;

  // Slots that need to be allocated at the module level (i.e. global variables
  // that are not shared with other modules). Note that there may be more slots
  // than bindings since some slots do not correspond to user-declared variables
  // (e.g. there is a `thisModule` slot which keeps a copy of the module object
  // that was passed into the entry function and is used to access imports and
  // exports from the module). Also note that the names of slots do not need to
  // correspond to the names of variables, since the algorithm needs to find
  // unique names and the namespace includes undeclared variables. Imported
  // module namespace objects do not appear in this list since they're "shared"
  // slots and will be resolved at link time from AnalysisModel.moduleImports.
  globalSlots: GlobalSlot[];

  // The slot created for the module namespace object of the current module
  thisModuleSlot: GlobalSlot;

  // The slots generated for all the import namespace objects
  moduleImports: { slot: GlobalSlot, source: string }[];

  exportedBindings: Binding[];
}

export type Scope =
  | ModuleScope
  | FunctionScope
  | BlockScope

export type Slot =
  | GlobalSlot
  | ClosureSlot
  | LocalSlot
  | ArgumentSlot
  | ModuleImportExportSlot

// An IL variable slot at the module level
export interface GlobalSlot {
  type: 'GlobalSlot';
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

// References an IL-level argument (accessible by LoadArg)
export interface ArgumentSlot {
  type: 'ArgumentSlot';
  argIndex: number;
}

// References an IL-level argument (accessible by LoadArg)
export interface ModuleImportExportSlot {
  type: 'ModuleImportExportSlot';
  moduleNamespaceObjectSlot: GlobalSlot;
  propertyName: string;
}

export interface ScopeBase {
  node: ScopeNode;

  // Variables in the given scope. For hoisted variables and function
  // declarations, these will appear as bindings at the function level even if
  // they've been declared physically in nested blocks.
  bindings: { [name: string]: Binding };

  // Nested scopes in this scope
  children: Scope[];

  prologue: PrologueStep[];

  epiloguePopCount: number;

  // More for debug purposes, but this is a list of references (identifiers)
  // directly contained within the scope.
  references: Reference[];

  // The function prologue also needs to initialize the slots for nested function
  // declarations. These need actual slots in the general case because they may
  // be closure objects.
  nestedFunctionDeclarations: NestedFunctionDeclaration[];

  // Let and const bindings
  lexicalDeclarations: Binding[];
}

export interface BlockScope extends ScopeBase {
  type: 'BlockScope';

  /**
   * False if the block can be multiply-instantiated relative to its parent, as
   * in the case with loop bodies. This is used during analysis. If this is
   * true, variables in the block can share the closure slot in the parent's
   * closure scope. If it's false, then the block needs its own closure scope if
   * there are any closure-scoped variables.
   */
  sameLifetimeAsParent: boolean;

  /** The outer scope */
  parent: Scope;
}

export interface FunctionLikeScope extends ScopeBase {
  type: 'FunctionScope' | 'ModuleScope';

  ilFunctionId: IL.FunctionID;

  // The outer scope
  parent: Scope | undefined;

  // True if the function (or a child of the function) references variables from
  // its parent (or parent's parent, etc). This does not necessarily mean that
  // it needs to have its own closure scope, but just that when the parent
  // initializes the variable binding for the function declaration that the
  // function value is initialized as a closure (with the `ClosureNew`
  // instruction).
  functionIsClosure: boolean;

  // The closure slots to allocate for this function, or undefined if the
  // function needs no closure slots.
  closureSlots?: ClosureSlot[];

  varDeclarations: Binding[];
}

export interface ModuleScope extends FunctionLikeScope {
  type: 'ModuleScope';

  // The outer scope
  parent: undefined;
}


export interface FunctionScope extends FunctionLikeScope {
  type: 'FunctionScope';

  node: B.SupportedFunctionNode;

  // The function name, or undefined if the function is anonymous
  funcName?: string;

  // The outer scope
  parent: Scope;

  // Function declarations have a `this` binding (which translates to the first
  // IL parameter). Arrow functions do not (they fall back to their parent's
  // `this` binding)
  thisBinding?: Binding;

  parameterBindings: Binding[];
}
// Steps that need to be compiled at the beginning of a function
export type PrologueStep =
  | { type: 'ScopePush', slotCount: number }
  | { type: 'InitFunctionDeclaration', slot: SlotAccessInfo, functionId: string, functionIsClosure: boolean }
  | { type: 'InitVarDeclaration', slot: SlotAccessInfo }
  | { type: 'InitLexicalDeclaration', slot: SlotAccessInfo }
  | { type: 'InitParameter', slot: SlotAccessInfo, argIndex: number }
  | { type: 'InitThis', slot: SlotAccessInfo }

// See also `compileParam`
export interface ParameterInitialization {
  // Index to `LoadArg` from
  argIndex: number;
  // Slot to store to (as accessed relative to the function prologue)
  slot: SlotAccessInfo;
}

// See also `compileNestedFunctionDeclaration` (WIP)
export interface NestedFunctionDeclaration {
  func: B.FunctionDeclaration;
  binding: Binding;
}

// This gives information about variables and parameters in the script in a
// particular scope. Note that not all slots are associated with variable
// bindings. For example, there is a global slot associated with the current
// module object, but this is not declared by the user's script.
export interface Binding {
  scope: Scope;

  // The lexical construct that defines the binding
  kind:
    | 'param'
    | 'var'
    | 'const'
    | 'let'
    | 'this'
    | 'function'
    | 'import'   // Variable created by an `import` statement

  /** The name to which the variable is bound (the declared variable, function or parameter name) */
  name: string;

  /** The slot in which to store the variable. If the variable is not used, the slot can be undefined */
  slot?: Slot;

  /** The variable declaration AST node. Note that `this` bindings don't have a node */
  node?: BindingNode;

  /** Syntactically readonly. E.g. `const` */
  isDeclaredReadonly: boolean;

  /** Is this part of an `export` statement? */
  isExported: boolean;

  /**
   * True if some assignment operation targets this variable (beyond just
   * initialization)
   *
   * This is intended for use in parameter optimization. If a parameter is not
   * assigned to, then the argument slot (`LoadArg`) can be used directly.
   */
  isWrittenTo: boolean;

  isAccessedByNestedFunction: boolean;

  // For bindings that correspond to physical declarations, the self-reference
  // references the binding from the perspective of location of the declaration
  selfReference?: Reference;
}

export interface Reference {
  name: string;
  // Is the referenced variable is in the current function?
  isInLocalFunction: boolean;

  // What the reference points to
  resolvesTo:
    | { type: 'Binding', binding: Binding }
    | { type: 'FreeVariable', name: string }
    | { type: 'RootLevelThis' }

  // How to read/write the variable
  access: SlotAccessInfo;

  /**
   * The scope in which the variable reference occurs
   *
   * Pass 3 uses this to count the the number of slots between a reference and
   * its target closure slot, to generate the relative indexes.
   */
  nearestScope: Scope;
}

/*
 * Describes how to access a variable.
 *
 * Note that how to access it depends on the context, since closure slot indexes
 * are relative.
 */
export type SlotAccessInfo =
  | GlobalSlot
  | ModuleImportExportSlot
  | LocalSlot
  | ArgumentSlot
  | ClosureSlotAccess
  | ConstUndefinedAccess

// Access using LoadScoped/StoreScoped
export interface ClosureSlotAccess {
  type: 'ClosureSlotAccess';
  relativeIndex: number;
}

// A value that always reads as `undefined`
export interface ConstUndefinedAccess {
  type: 'ConstUndefinedAccess';
}

export type ScopeNode = B.Program | B.SupportedFunctionNode | B.Block | B.ForStatement;

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
