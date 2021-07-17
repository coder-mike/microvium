import { IL } from '../../../lib';
import * as B from '../supported-babel-types';

// WIP: I think I should go through all the fields in the analysis model and
// check which aren't needed anymore

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
  // unique names and the namespace includes undeclared variables.
  globalSlots: GlobalSlot[];

  // The slot created for the module namespace object of the current module
  thisModuleSlot: GlobalSlot;

  // The slots generated for all the import namespace objects
  // WIP : used?
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
  // Variables in the given scope. For hoisted variables and function
  // declarations, these will appear as bindings at the function level even if
  // they've been declared physically in nested blocks.
  bindings: { [name: string]: Binding };

  // Nested scopes in this scope
  children: Scope[];

  prologue: PrologueStep[];

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

export interface FunctionLikeScope extends ScopeBase {
  type: 'FunctionScope' | 'ModuleScope';

  ilFunctionId: IL.FunctionID;

  // The outer scope
  parent: Scope | undefined;

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
  // `ilParameterInitializations` is used to emit the function prologue IL
  // directly after and closure scope exists (if needed) and before any user
  // statements are executed.
  //
  // Computed during pass 2
  // WIP: This could be replaced in favor of `prologue`
  // ilParameterInitializations: ParameterInitialization[];

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

// Steps that need to be compiled at the beginning of a function
export type PrologueStep =
  | { type: 'ScopePush', slotCount: number }
  | { type: 'InitFunctionDeclaration', slot: PrologueStepTargetSlot, functionId: string, functionIsClosure: boolean }
  | { type: 'InitVarDeclaration', slot: PrologueStepTargetSlot }
  | { type: 'InitLexicalDeclaration', slot: PrologueStepTargetSlot }
  | { type: 'InitParameter', slot: PrologueStepTargetSlot, argIndex: number }
  | { type: 'InitThis', slot: PrologueStepTargetSlot }

export type PrologueStepTargetSlot = LocalSlot | ClosureSlot;

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

export interface ModuleScope extends FunctionLikeScope {
  type: 'ModuleScope';

  // The outer scope
  parent: undefined;
}

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

export interface BlockScope extends ScopeBase {
  type: 'BlockScope';
  // The outer scope
  parent: Scope;
  epiloguePopCount: number;
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

  /** False by default, and true if a reference to the binding is found */
  isUsed: boolean;

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
  isInLocalFunction: boolean; // WIP do we need this?

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
  | GlobalSlotAccess
  | ModuleImportExportSlotAccess
  | ClosureSlotAccess
  | LocalSlotAccess
  | ArgumentSlotAccess
  | ConstUndefinedAccess

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
  argIndex: number;
}

// A value that always reads as `undefined`
export interface ConstUndefinedAccess {
  type: 'ConstUndefinedAccess';
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
