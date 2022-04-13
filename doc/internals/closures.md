# Closures

See comments on `TsClosure` in [microvium_internals.h](../../native-vm/microvium_internals.h) for more more technical details.

## Structure

A closure is internally simply a `TsClosure` struct with a `scope` and a `target` function.

A closure takes 8 bytes in total: 4 bytes on the heap for the aforementioned fields, 2 bytes for the allocation header (with type code `TC_REF_CLOSURE`), and 2 bytes for a pointer to it.

Closures are immutable. Copying a closure value is just copying the 16 bit pointer to the closure.

Scopes can be stored in ROM, such as if the closure existed before the snapshot was taken. The scoped-variable access mechanism is able to traverse a scope chain that is partially in ROM and partially in RAM.

## Calling Behavior

When a closure is called, the `scope` becomes the currently-active scope (`vm_TsRegisters::scope`) and control goes to the `target` function as if the target function were also called. The previous scope is saved on the stack along with the other registers. When the function returns, the previous scope is restored.

When a non-closure function is called, the `scope` register is set to undefined (`VM_VALUE_UNDEFINED`).

Closures can only be called from bytecode by `VM_OP2_CALL_3`, or by the host, via the shared implementation in `LBL_CALL`.

Closures can't participate in "short calls" (single-byte call instructions). However, note that static analysis could potentially remove the need for runtime closures in some cases since the stack-accessing instructions (e.g. `VM_OP2_LOAD_VAR_2`) can legally access variables in caller frames.

## Accessing Scoped Variables

Closures bind a scope chain `scope` which is a pointer to a fixed-length array (`TC_REF_FIXED_LENGTH_ARRAY`) on the heap. The first slot in each scope is a pointer to the parent scope or `VM_VALUE_UNDEFINED` to indicate a root-level scope.

Variables in the scope chain are accessed by the `LOAD_SCOPED_*` and `STORE_SCOPE_*` instructions which take a literal index to the scoped variable being accessed.

  - Index 1 is the first usable scope variable, since the first slot in the fixed-length array is reserved for the parent scope pointer.

  - If the index exceeds the length of the fixed-length array, it implicitly "overflows" to the parent scope.

  - This allows for very compact instructions to access any scope variable. In particular, `VM_OP_LOAD_SCOPED_1` and `VM_OP_STORE_SCOPED_1` are single-byte instructions that can read and write to up to the closest 16 scoped variables over any level of nesting, which probably covers a large proportion of real-world closure variable access.

## Creating Closures and Scopes

Closures are created by `VM_OP1_CLOSURE_NEW` and bind the current scope as the closure scope. It pops the `target` function off the stack and pushes the new "target" that will get the `scope` register set when it is called. This the parent lexical scope, since `VM_OP1_CLOSURE_NEW` is called in the parent function when initializing and binding the child function instance.

At the entry to a function, you can think of the `scope` register as pointing to the parent scope, which it can access by `LOAD_SCOPED_*` etc. For a function to have its own scope, the 2-byte `VM_OP1_SCOPE_PUSH` instruction pushes a new scope array of the given slot count to the scope stack, setting it as the new `scope` register value.

## Lexical Scopes

Lexical scopes have a shorter lifetime than the current function. At the beginning of a lexical scope in the bytecode, a `VM_OP1_SCOPE_PUSH` instruction will be emitted. A corresponding `VM_OP3_SCOPE_POP` will be emitted at the end of the scope.

## For-loops

In JS, for-loops like `for (let i = 0; i < n; i++)` have quite complicated behavior in terms of the spec. Each iteration of the loop creates a new scope, but the variable `i` is copied from one scope to the next. Solely for this purpose, the instruction `VM_OP3_SCOPE_CLONE` exists to create a new scope at the same level with a copy of all the variables in the previous scope.

## Analysis and Optimization

Scopes and closures are expensive, relatively speaking. They require heap allocations which creates GC pressure. For this reason, local and global variables are typically not stored in scopes but are rather stored on the stack. `LOAD_VAR_*` and `STORE_VAR_*` are instructions that do this.

There is some quite complicated analysis in `lib/src-to-il/analyze-scopes` that tries to decide which variables should be local variables or closure-captured variables ("scoped" variables).

See [lib/src-to-il/analyze-scopes/readme.md](../../lib/src-to-il/analyze-scopes/readme.md) for more details.

