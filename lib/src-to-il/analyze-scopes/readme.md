# Analyze Scopes

The idea is that `analyzeScopes` does some front-loading of some of the analysis required by `src-to-il` for the output emission.

Before Microvium supported closures, all the analysis was done on the fly in the output pass in `src-to-il` as it traversed the AST, which was nice and simple.

The introduction of closures made this more complicated because when we encounter a variable declaration, we don't know whether that variable should be emitted as a local variable or a closure-scoped variable, without first iterating through all the nested functions to see how the variable is used, so we can't do the closure analysis and output in a single pass. The solution was to introduce some analysis passes first, which is what `analyzeScopes` does.

`analyzeScopes` analyzes the AST and returns a pure data output format containing all the required information to emit IL for declarations and references.

`analyzeScopes` traverses the AST. When it encounters an AST node that represents a new scope (e.g. a function or block), it pushes the scope to a stack and records the variable bindings in that scope. When it encounters a variable reference AST node (e.g. identifier), it searches for the corresponding binding in the current scope stack and links the two.

Based on the relationship between the references and bindings, we can answer the questions:

  - Is the variable used? Local variables that aren't used do not need slots at all
  - Is the variable accessed by a nested function? (i.e. it needs to be closure allocated)
  - Is the variable assigned to? (a parameter which is unassigned can be emitted as a `LoadArg` rather than a parameter slot)


## Passes

`analyzeScope` performs multiple passes.

### Pass 1: Find scopes and bindings

  - Finds functions, variables, and references.

  - Resolves references to their corresponding bindings.

  - Marks bindings as `isUsed` if they're accessed at all by any references

  - Marks bindings as `isClosureAllocated` if they're accessed by nested functions

  - Marks bindings as `isWrittenTo` if they're accessed as an LValue in an assignment

  - Computes unique IDs for all functions in the unit (including nested and anonymous functions)

### Pass 2: Compute Slots

  - Allocates slots for all the used bindings

    - `GlobalSlot` at the module level to allocate unique names to all the root-level variables and functions

    - `ClosureSlot` at the function level to allocate a unique slot index for each variable in the function that needs to be closure-allocated

    - `LocalSlot` at the function or block level to assign a unique index for non-closure-allocated local variables

  - Computes initializations for slots (`ScopeBase.prologue`)

    - Arguments that need to be copied to parameter slots

    - `let` and `const` declarations which need to be initialized to the TDZ value `Deleted`

    - Nested functions (in the module, function, or block level) that need to be loaded into variables slots, possibly with their own closure scope binding

### Pass 3: Compute Accessors

Computes `SlotAccessInfo` for all references (_references_ are AST nodes of type `ReferencingNode` that refer to some value by name).

The previous pass decided where all the variables should go. Pass 3 decides how each reference should be compiled such that it can read or write to the previously-allocated variables.

For simple local variables, this is easy. Local variable number `4` can be accessed simply using `LoadVar(4)` or `StoreVar(4)`, which is described using the `LocalSlotAccess` type.

However, there are more complicated cases. The `LoadScoped` instruction takes a "relative index". When the instruction is executed at runtime, the index operand is first used to index into the current closure scope. If the index exceeds the bounds of the current closure scope, it will "overflow" into the next outer scope, and can do this repeatedly to reference any variable in the scope chain using a single instruction and single index.

To support this, the analysis output model separates the concept of a `Slot` from a `SlotAccessInfo`, with the former describing a slot on the stack or global variable, and the latter describing information about a reference and says how to resolve that reference at runtime (i.e. information needed to emit the IL instructions to access the reference).

For something like a local variable slot, the information contained in a `LocalSlot` and `LocalSlotAccess` are identical, since the IL to access local slots are invariant to the referencing location. However, `ClosureSlot` and `ClosureSlotAccess` hold different information, since closure slots are accessed differently depending on the location of the referencing instruction relative to the slot location.

Furthermore `SlotAccessInfo` can represent RValues that are _like_ slots but not really. For example, `ConstUndefinedAccess` is like accessing a readonly slot that always returns `undefined` and will be emitted using a `Literal(undefined)` instruction.

Some slots implicitly exist rather than being associated with bindings. For example, free variables and arguments. These do not need to be "allocated" at runtime and there is no corresponding `Slot` or `Binding` in the analysis model.

Another example is `this` at the root scope or nested inside a arrow functions:

```js
console.log(this);
const foo = () => console.log(this);
const bar = () => () => console.log(this);
```

Arrow functions do not create a `this` binding but instead use the parent's `this` binding. The `this` binding at the root scope is taken to be `undefined`. No slot needs to actually exist for this root-level `this` value.

## Specific cases

### Parameters and arguments

There are a number of different ways that parameters can be emitted

```js
foo();
function foo(a, b, c, d) {
  console.log(a);      /* LoadArg          */
  b++;                 /* LoadVar/StoreVar */
  console.log(b);      /* LoadVar          */
  const bar = () => c; /* LoadScoped       */
                       /* `d` is not used  */
}
```

In the above example:

  - Parameter `a` is the typical case. A reference to `a` can resolve just as `LoadArg` which directly gets the value from the argument list, or `undefined` if the argument is not passed.

  - Parameter `b` is the case where the parameter value is mutated during the function. This is not the same as mutating the argument (note in the example that `foo()` is called without any arguments), so there is no `StoreArg` opcode in the instruction set. Rather, the prologue of the function must create a local variable which is a copy of the provided argument. All further access to `b` is then computed on the local variable.

  - Parameter `c` is the case where a parameter is accessed from a nested function, and so must be closure-allocated. Like in the case with `b`, this requires that the function prologue make a copy of the argument, but unlike `b`, the copy is stored in the closure scope (`StoreScoped`). All further accesses to `b` (read or write) then actually accesses the closure slot.

  - Parameter `d` is the case where a parameter isn't used at all. This is treated the same as `a` (i.e. we don't need a local variable slot or any function prologue for initialization) except that obviously there are no references to compile.

Pass 1 identifies parameter bindings as part of the function scope. It also determines:

  - Which parameters are used or not
  - Whether a parameter is written to or not
  - Whether a parameter is accessed from a nested function

Pass 2 creates slots for parameters which are used.

  - If the parameter needs to be closure-allocated, it allocates the slot in the closure scope
  - Otherwise, if the parameter is ever written to, it allocates it in a local variable slot
  - Otherwise, if the parameter is used at all, it allocates an `ArgumentSlot`
  - Otherwise, no slot is required

It was convenient to implement this using an `ArgumentSlot`, even though arguments a bit different to other slot types (the underlying runtime slot may not exist at all, if the argument wasn't passed by the caller, and the argument slot is read-only). This is because it means that all parameter references can consistently reference a `Binding`, and that all used bindings can consistently have an associated `Slot`. For parameters, the slot is either `LocalSlot`, `ClosureSlot`, or `ArgumentSlot`. If we didn't have an `ArgumentSlot`, then either there would be bindings without a slot, or parameter references without a binding, which isn't consistent with the general pattern.

Pass 2 also populates prolog steps for each new parameter slot, which describes how the slot should be initialized. I.e. describes how argument values should be copied into either local variables or closure slots.

Pass 3 calculates accessors using the same logic as for variables in general, with the additional consideration that accessors may directly reference argument slots instead of local variable slots.

### This

The Microvium runtime engine has no understanding of `this`. Rather, as a "calling convention", the compiler emits code that uses the first IL parameter as the `this` parameter (and the second parameter at the IL level is the first user-declared parameter, etc).

`this` at the global level just resolves to `undefined`.

```js
this;         // 1. Literal(undefined)

() => this;   // 2. Literal(undefined)

function foo() {
  this;       // 3. LoadArg(0)
  () => this; // 4. LoadScoped(0)
}
```

In terms of the analysis, function _declarations_ have a `thisBinding`, whereas arrow functions and function expressions do not. The binding uses the special name `#this`, since it's an impossible variable name for a declared variable. This enables the `this` binding to be part of the normal set of bindings for a function scope.

When a `this` expression is found, it uses the normal variable reference lookup mechanics to find the `#this` binding and possibly mark the binding as needing to be closure-allocated. If no `#this` binding is found, the reference resolves to `root-level-this`.

If the function is `this`-binding and the `this` must be closure allocated, pass 2 adds an `InitThis` step to the prologue to read the `this` value out of the first argument and put it in the corresponding slot.


### Let and Const Variables

```js
function foo() {
  let a;      // Local variable slot
  {
    let b1;   // Shares a local slot index with b2
  }
  {
    let b2;   // Shares a local slot index with b1
  }
  {
    () => c1; // Closes over c1
    let c1;   // Does _not_ share a slot index with c2
  }
  {
    () => c2; // Closes over c2
    let c2;   // Does _not_ share a slot index with c1
  }
}
```

Pass 1 finds `let` and `const` declarations and creates the corresponding `Binding`s at the block-granularity. It also finds references to these declarations and thus determines all the properties about these bindings, including whether they should be closure-allocated.

Pass 2 computes indices for each declaration. For closure-allocated variables, each variable gets a distinct index, starting after the indexes for closure-allocated parameters (in the case of functions). For non-closure-allocated variables within blocks, variables in sibling blocks can share the same slot index, since the slots from one block are released (popped) at the end of the block.

### Var Variables

`var` variables work similarly to `let` and `const` variables except they're hoisted to the function or module scope.

Pass 1 populates the `varDeclarations` variable for each function and analyses their usage.

Pass 2 looks at the `varDeclarations` and generates the right prologue steps to create the variable slots, either locally or in the closure scope.

Pass 3 looks at the references found in pass 1 and determines how those should be compiled to access to the slots from pass 2.

### Function Declarations

Pass 1:

  - Finds nested functions at the block level and creates `Binding`s for them

  - Finds references to the nested functions and so marks the bindings as used (`isUsed`) and possibly closure-allocated (`isClosureAllocated`), the same as for any bindings

  - Finds references from child function scopes to bindings in parent functions scopes and marks the intermediate functions as `functionIsClosure` since they will need to capture their parent's scope.

### Module-level Variables

For module level variables and function declarations which are not imported or exported, pass 1 handles these the same as local variables, finding the bindings and attaching them to the respective scope.

Where module variables differ is in pass 2, where `computeModuleSlots` will manifest slots for root-level declarations as `ModuleSlots` rather than as local or closure variables, if they.

I wasn't sure about this choice, but the main reason I went with it is for efficiency:

  1. Functions at the root scope do not need to be closures, even though they close over module-scoped variables

  2. Therefore, we don't need an entry function prologue to initialize the closures

  3. And the VM uses less memory because it doesn't need the extra scope and closures for nested functions. And performance increases a little.

  4. Similarly, there is less GC time wasted on these allocations that will never be collected

  5. Minor point: many programers consider root-level variables to be "global variables" in a sense. If we report the number of global variables in a snapshot, it makes sense that it includes the root-level variables in modules.

The way it's implemented, this doesn't apply to lexical variables or function declarations that are nested in blocks.

```js
let w; // This is a local variable in the entry function
console.log(w); // LoadVar
let x; // This is a true global variable because it's accessed by a nested function
console.log(w); // LoadGlobal
{
  var y; // This is also a true global since it's hoisted to the module scope
  let z; // This is a closure-scoped variable that will be collected when `f` is collected
  let f = () => z; // `z` accessed using LoadScoped
  let g = () => x; // `x` accessed using LoadGlobal
}
// `g` and `h` are not closure since the only closes over globals
let h = () => x; // `x` accessed using LoadGlobal
```

In terms of code structure `computeModuleSlots` generates global variables for the module-scoped bindings and then calls `computeFunctionSlots` which creates local slots for the "remaining" slots


### Free Variables

Free variables of the module (references to global variables that aren't within the module) are found in pass 1. They have no corresponding bindings in the lexical scope stack and so pass 1 populates the `resolvesTo` property of the `Reference` according to just a `FreeVariable`.

Both free variables and module variables are accessed by the `LoadGlobal` IL instruction, so module variable names can theoretically clash with free variables. Some module variables are synthetic (they are slots without a corresponding binding), such as the `thisModuleSlot` and similarly for slots corresponding to imported module namespaces. These synthetic module slots have names which are calculated such that they don't clash with any free variable names (part of pass 2). Free variable names can't be renamed (without a lot of work) since the name is used as an inter-module identity at link time.

This is another reason why it's useful to have a multi-pass analysis, since we can only generate names for module slots once we know the names of all the free variables that are accessed within the unit, so these are necessarily different passes.


### Imports and Exports

Pass 1 creates bindings for all declarations, including imported and exported bindings.

```js
export const x = 5; // `x` is a binding within the module scope
import y as z from './yModule'; // `z` is a binding within the module scope
```

Pass 1 populates a transient `Map` (`importBindings`) that enumerates each imported variable binding and the corresponding source module specifier (e.g. `./yModule` in the above example).

Pass 2 computes a unique `GlobalSlot` for each imported module specifier and a `ModuleImportExportSlot` for each binding. It also creates the `thisModuleSlot` (which the entry function will write the current module object to).

In the above example, the binding `y` has a `ModuleImportExportSlot` which references a synthetic global slot for `./yModule` and the name `z`.

Pass 3 computes the accessors for references to these bindings, which are just `ModuleImportExportSlotAccess` with reference to the global slot name and the property. E.g. the global slot named `yModule` and the property name `y`.

