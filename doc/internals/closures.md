# Closures

Note: this design has changed a lot since its inception, so some documentation you may find to be out of date and there may be some technical debt around the naming of things.

This document talks about the runtime implementation of closures (i.e. the engine capability and instruction set). See also [Closure Embedding](closure-embedding.md) which talks more about the static analysis side.

## Structure

A closure is a mutable container type with the type code `TC_REF_CLOSURE` and any number of slots. The first and the last slot in this container are special:

  1. The first slot may hold a function pointer (in this document, I refer to this as the `target`). (optional)
  2. The last slot may hold a reference to the a parent closure (in this document, I refer to this as the `parentScope`). (optional)

Any number of other slots may exist for user-defined variables. The special first and last slots are optional if the closure is never used as a function or its parent is never accessed.

Note: a closure that's not "used as a function" is not really a "closure" by the strict definition, but it's convenient in the engine to use the same type for both closures and environment records, since a lot of the time the two can be combined (See [Closure Embedding](closure-embedding.md)).

## Calling Behavior

When a closure is called, the closure becomes the currently-active closure (`vm_TsRegisters::closure`) and control goes to the `target` function as if the target function were instead called. The previous scope is saved on the stack along with the other registers. When the function returns, the previous scope is restored.

When a non-closure function is called, the `closure` register is set to `deleted` (`VM_VALUE_DELETED`) -- this is the value reserved for `TDZ` variables.

Closures can only be called from bytecode by `VM_OP2_CALL_3`, or by the host, via the shared implementation in `LBL_CALL`.

Closures can't participate in "short calls" (single-byte call instructions). However, note that static analysis could potentially remove the need for runtime closures in some cases since the stack-accessing instructions (e.g. `VM_OP2_LOAD_VAR_2`) can legally access variables in caller frames.

## Accessing Scoped Variables

Variables in the scope chain are accessed by the `LOAD_SCOPED` and `STORE_SCOPED` instructions which take a literal index to the scoped variable being accessed. These access the slots in the currently-active `closure` (the one pointed to by `vm_TsRegisters::closure`), or "overflow" to the `parentScope`, recursively. I've called this "recursive overflow" the "waterfall" indexing.

This waterfall indexing allows for very compact instructions to access any scope variable. For example, `VM_OP_LOAD_SCOPED_1` and `VM_OP_STORE_SCOPED_1` are single-byte instructions that can read and write to up to the closest 16 scoped variables over any level of nesting, which probably covers a large proportion of real-world closure variable access.

Note that because there is no distinction between closures and environment records, closures are able to modify themselves if needed (e.g. redirect a closure to point to a different function). This is the basis of the design of async-await.

## Creating Closures and Scopes

Closures are created using `VM_OP1_CLOSURE_NEW` or `VM_OP1_SCOPE_PUSH`. Historically, closures and scopes were separate and these two operations respectively created closures and scopes. However, now that they have been unified, these are just two different ways of creating closures with slightly different semantics:

  - `VM_OP1_CLOSURE_NEW` creates a zero-variable closure with only 2 slots -- the `target` function pointer (popped off the stack) and the `parentScope` (from the current `closure` register). This instruction does not change the current closure register. The newly created closure is pushed to the stack.

  - `VM_OP1_SCOPE_PUSH` creates a closure with N slots, where N is a literal embedded in the instruction. The last slot is automatically set to the value of the current `closure` register. The closure register is then set to the new closure. The new closure is not pushed to the stack. The term "push" in this instruction refers to pushing to the scope chain, not the call stack.

`VM_OP1_SCOPE_PUSH` is used at the entry to functions or blocks that contain closure-accessed variables. `VM_OP1_CLOSURE_NEW` is used at the site of non-embedded function declarations create an empty closure that refers to the current scope.

## Lexical Scopes

Lexical scopes (blocks) have a shorter lifetime than the current function. At the beginning of a lexical scope in the bytecode, a `VM_OP1_SCOPE_PUSH` instruction will be emitted. A corresponding `VM_OP3_SCOPE_POP` will be emitted at the end of the scope.

## For-loops

In JS, for-loops like `for (let i = 0; i < n; i++)` have quite complicated behavior in terms of the spec. Each iteration of the loop creates a new scope, but the variable `i` is copied from one scope to the next. Solely for this purpose, the instruction `VM_OP3_SCOPE_CLONE` exists to create a new scope at the same level with a copy of all the variables in the previous scope.

## Analysis and Optimization

Scopes and closures are expensive, relatively speaking. They require heap allocations which creates GC pressure. For this reason, local and global variables are typically not stored in scopes but are rather stored on the stack. `LOAD_VAR_*` and `STORE_VAR_*` are instructions that do this.

There is some quite complicated analysis in `lib/src-to-il/analyze-scopes` that tries to decide which variables should be local variables or closure-captured variables ("scoped" variables).

See [lib/src-to-il/analyze-scopes/readme.md](../../lib/src-to-il/analyze-scopes/readme.md) for more details.

