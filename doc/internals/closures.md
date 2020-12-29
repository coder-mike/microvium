# Closures

The type `TsClosure` struct is introduced as a more meaty function type, intended to implement closures and classes (functions with properties, such as `foo.prototype`). See comments [microvium_internals.h](../../native-vm/microvium_internals.h).

There are 3 instructions to create closures (`VM_OP1_CLOSURE_NEW_1` etc) depending on the number of fields you want to add to the closure. See [microvium_opcodes.h](../../native-vm/microvium_opcodes.h) The 4-field closure is this-capturing, which has different semantics to the others and would only be used in the case of arrow functions.

There is also a new instruction `VM_OP1_LOAD_SCOPE` which pushes the local scope value. Calling a closure will update the `scope` register to the captured scope. `VM_OP1_LOAD_SCOPE` should only be used in a function that has a scope (i.e. one that was called via a closure).

The `ClosureNew` IL instruction takes a `fieldCount` literal parameter that should be 2, 3 or 4 to indicate the corresponding C instruction. See `operationClosureNew` in [virtual-machine.ts](../../lib/virtual-machine.ts) for the semantics.

Function objects that need to support properties need to be implemented at the machine level as closures with a `props` field that points to an object that collects all the properties. Technically this should include all functions, since any _could_ obtain properties, but I think reality is that it's a very rarely-used language feature to assign properties to functions, so likely the property support will only be used for the special case of `prototype` property used for classes (which I have yet to implement).

On the front-end, the main challenge is the scope analysis. See `calculateScopes` in [src-to-il.ts](../../lib/src-to-il.ts) for details. This function basically calculates which functions need closures allocated, what the closures look like, and how to manifest each variable reference.

The result of the scope analysis is attached to the ctx that gets passed around during the bytecode emission phase.

  - Emitted functions can allocate closures where necessary.
  - Variable declarations may write to a closure slot instead of just pushing a new variable.
  - Variable references will emit instructions that may traverse the closure chain.

Consider the following example:

```js
function makeIncrementor() {
  let x = 1;
  return () => x++;
}
```

The arrow function does not need any closure slots of its own. It only needs to access its parent closure scope.

The parent function is the opposite: the parent does not need to be a closure itself since it captures nothing of its surroundings, but it needs to allocate a closure scope to hold `x`.



















