# Closures

WIP: This is outdated

The type `TsClosure` struct is introduced as a more meaty function type, intended to implement closures and classes (functions with properties, such as `foo.prototype`). See comments [microvium_internals.h](../../native-vm/microvium_internals.h).

The implementation of closures in VM comes in two parts:

  1. Closure _scopes_ are heap-allocated locations for local variables
  2. Closure functions (or just "closures") are function-types that implicitly capture the current closure scope upon creation.

Scopes are created with the `ScopePush` instruction. Given a literal number of variables, it adds a new scope to the end of the current scope chain. Each scope is realized as a fixed-length array, and references its parent through the first element in the array while keeping the others for variables.

Variables in the current scope can be accessed by the instructions `LoadScoped` and `StoreScoped`, given the variable index as a literal value. If the index exceeds the length the current scope, it "overflows" to the next scope in the scope chain, thus allowing access to any outer scope with just the one instruction.

In the C VM, the global variables are treated implicitly as if they are the last scope, thus global variables are accessed with `LOAD_SCOPED` and `STORE_SCOPED`.

There are 3 instructions to create closures (`VM_OP1_CLOSURE_NEW_1` etc) depending on the number of fields you want to add to the closure. See [microvium_opcodes.h](../../native-vm/microvium_opcodes.h). The 4-field closure is this-capturing, which has different semantics to the others and would only be used in the case of arrow functions.

The `ClosureNew` IL instruction takes a `fieldCount` literal parameter that should be 1, 2 or 3 to indicate the corresponding C instruction. See `operationClosureNew` in [virtual-machine.ts](../../lib/virtual-machine.ts) for the semantics.

Function objects that need to support properties need to be implemented at the machine level as closures with a `props` field that points to an object that collects all the properties. Technically this should include all functions, since any _could_ obtain properties, but I think reality is that it's a very rarely-used language feature to assign properties to functions, so likely the property support will only be used for the special case of `prototype` property used for classes (which I have yet to implement).

On the front-end, the main challenge is the scope analysis. See `calculateScopes` in [src-to-il.ts](../../lib/src-to-il.ts) for details. This function basically calculates which functions need closures allocated, what the closures look like, and how to manifest each variable reference.

The result of the scope analysis is a set of weak maps that hold additional metadata about various lexical constructs like variables and functions. It gets attached to the ctx that gets passed around during the bytecode emission phase.

  - Some emitted functions must allocate a local **closure scope** for storing variables
  - Some function expressions (and similarly for declarations) must evaluate by constructing a **new closure**
  - Variable declarations may write to a closure slot instead of just pushing a new variable.
  - Variable references may need to read/write using `LoadScoped` and `StoreScoped` if the variable is closure-allocated.

## Simple Example

Consider the following example:

```js
function makeIncrementor() {
  let x = 1;
  return () => x++;
}
```

The arrow function does not need any closure slots of its own. It only needs to access its parent closure scope.

The parent function is the opposite: the parent does not need to be a closure itself since it captures nothing of its surroundings, but it needs to allocate a closure scope to hold `x`.

The following things need to be different (from the non-closure case) for this example for closures to work:

  - The emitter for `makeIncrementor` needs to identify directly-nested functions (declarations or expressions) and emit IL functions for each of these. The IDs of these need to be globally unique.

  - The `makeIncrementor` prologue needs to allocate a closure scope (`SCOPE_PUSH`) with 1 slot for `x`.

  - The declaration and initializer `let x = 1;` does not push to the local stack, but instead writes `1` to the corresponding scoped slot.

  - The code of the lambda expression body `x++` through analysis can be seen not to use the `this` value, so the lambda does not need to be capturing.

  - The lambda expression `() => x++` evaluates (to a closure) by the following IL sequence:
    1. `Literal()` to push a reference to the target function IL by the earlier-generated ID
    2. `ClosureNew(1)` to create a 2-field closure that captures the current scope and the given reference





















