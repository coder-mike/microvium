# Async Await

Terms:

- **await-call**: a function call whose result is immediately awaited.
- **void-call**: a function call whose result is not used at all.
- **normal call**: any other function call.

Basically:

- If you `await-call` or `void-call` a function, the callee will be notified via the `cpsCallback` register so it won't generate a promise.
- It will instead use continuation-passing-style (CPS) and call the callback defined in the `cpsCallback` register.

## CPS Protocol

  1. The caller passes a callback via the `cpsCallback` register
    - Or `undefined` to indicate a non-CPS caller (normal call)
    - Or `deleted` to indicate no-callback (void call), along with the flag `AF_VOID_CALLED`. The `deleted` value is used generally as a poison value for `cpsCallback` to indicate that the register doesn't hold a callback for the current frame.
    - The callback has the signature `(isSuccess, value)`.

  2. The callee will synchronously return `deleted` to indicate an asynchronous return value.
    - When it hits its first suspension point
    - Or returns before encountering any suspension points.

  3. The callee will asynchronously call the callback when it completes.
    - It will call the callback exactly once
    - It will call the callback only from the job queue or when the job queue is empty.

All async functions are implemented internally using CPS, and then the engine will automatically provide adapters at runtime to convert between CPS and promises where necessary.

## Closure structure:

Async functions are implemented using the closure machinery. The closure structure is as follows:

  - `scope[0]: continuation` - pointer to the continuation function bytecode.
  - `scope[1]: callback` - a pointer to the caller continuation or `null` if void-called.
  - Async closure variables - any variables that the compiler identifies as being used by nested functions inside the async functions. WIP: does this include all variables? it would be cheaper to just have all variables in the async function marked as closure variables because then they don't need to be copied.
  - Async local variables and stack to be preserved at await points. At least the number of slots required for the deepest await point.
  - Plus the normal parent scope pointer, if required.

## Stack structure

  - `var[0]` - synchronous return value (promise, or elided promise designated by `deleted`, or just `undefined` if resumed off the job queue).
  - `var[1-2]` - top-level catch block target.

## Opcodes

  - `AsyncStart` - at the entry of an async function
  - `Await` and `AwaitCall` - at `await` points.
  - `AsyncResume` - after `await` points to re-establish async state.
  - `AsyncReturn` - at the end of an async function or when the user has a `return`, to clean up after `AsyncStart`

## Preserving the stack

The new `Await` and `AsyncResume` instructions automatically preserve and restore the stack when suspending and resuming the async function. The `Await` instruction knows the stack depth dynamically, and the `AsyncResume` instruction is statically compiled to know the stack depth (i.e. how many values to copy out of the closure and into the stack).

Only the stack after `var[2]` is preserved. `var[0-2]` include the return value and the top-level catch block target, which do not need to be preserved since they're reconstructed.

## Catch blocks

The stack preserved by `Await` and restored by `AsyncResume` includes the catch blocks that are kept inline in the stack. Catch blocks are stored as a linked list. Each catch block is 2 slots, one that references the code address to handle the catch and the other that references the parent catch block. The semantics of these have been modified so that the parent reference is relative rather than absolute, so that they still make sense when restored if the absolute stack level is different (i.e. when resumed from the job queue).

Async functions are compiled to always have an implicit top-level catch block in `var[1-2]`, which is used to handle any exceptions that are thrown from the async function and reroute them to the CPS callback. This not part of what's preserved by `Await`.

At an `Await` point then, the engine unwinds the async catch stack by simply setting the current catch target to the target in `var[1-2]`. At the `AsyncResume` point, the engine push a top-level catch block into `var[1-2]` before restoring the rest of the stack frame. The other blocks in the stack frame will be correct relative to this new top-level block because its position is consistent.

## Await Points

At each `await` point in the async function, the compiler emits an `Await` instruction, optionally preceded by an `AwaitCall` instruction if the awaited expression is a function call. The structure looks like this:

- `AwaitCall` (optional)
- `Await`
- `AsyncResume`

In the bytecode, the `AsyncResume` instruction is emitted as:

- 0-3 bytes padding
- 2 byte function header
- VM_OP3_ASYNC_RESUME opcode with an arg for the number of slots to restore on the stack

The padding is so that the resume instr is 4-byte aligned and can be referenced by a bytecode pointer.

The function header makes the resume point callable.

In addition to the `TC_REF_FUNCTION` type-code in the function header also includes:

1. A bit to indicate that this callable value is actually a continuation.
2. An 11-bit back-pointer to the containing async function's header.

The 11-bit back-pointer is counted in quad-words, so it allows the resume point to be up to 8kB away from the beginning of its containing async function.

```js
// encode-snapshot.ts
const functionHeaderWord = 0
  | TeTypeCode.TC_REF_FUNCTION << 12 // TypeCode
  | 1 << 11 // Flag to indicate continuation function
  | backDistance >> 2 // Encodes number of quad-words to go back to find the original function
```

The back-pointer is used when decoding to find the original function. Note that the decoder finds things in ROM by following pointers to those things, not by iterating the ROM space.

At runtime, the back-pointer is used to find the required max stack height of the function, which is needed for asserting that the stack is big enough to restore the stack frame when the continuation is called (and may in future be used for dynamically-expanding the stack).

### Await and AwaitCall

The `AwaitCall` instruction is emitted if the awaited expression is a function call. This instruction synthesizes the callback and passes it to the callee in the `cpsCallback` register and then delegates to the normal call machinery to perform the call.

If the callee is an async function, it will accept the callback in the `cpsCallback` register and return `deleted` to represent an elided promise. The caller will continue on the `Await` instruction which will see the value `deleted` and know that the callee accepted the callback.

If the callee is not an async function, it will return a normal return value (anything except `deleted`) and the caller's `Await` instruction will then have to perform a proper `Await`.

A proper `Await` involves:

1. Promoting the return value to a promise if it isn't already.
2. Converting the current closure to a continuation (i.e. setting `slot[0]` to the continuation function bytecode). Note that `Await` is not always preceded by `AwaitCall` so we can't rely on that already having been done.
3. Subscribe the continuation to the promise.

Either way, `Await` will also preserve the stack and unwind the top-level catch block. See [Preserving the stack](#preserving-the-stack). The await knows the stack depth dynamically.

## Interaction with C host

The VM can call async functions in the host. The host implements an async function by calling `mvm_asyncStart` (see `microvium.h`).

If the caller is an await-call, `mvm_asyncStart` basically returns the callback from the `cpsCallback` register. Otherwise, it creates a promise and a new callback that resolves/rejects the promise.

`mvm_asyncStart` is also given a pointer to the synchronous return value, which it will either set to the constructed promise or to `deleted` if the promise is elided.

## Void calls

At the top of an await chain there must be a call operation that does not await. In order not to construct a promise for this call, there is a flag (`AF_VOID_CALLED`) that tells the callee that the return value is not expected. To save on instructions in the instruction set, this flag is encoded as the high bit in the arg-count of a normal Call instruction.

The `Return` instruction also observes this flag and will not push a return value to the stack if the caller signalled a void call.

WIP: I feel very uncomfortable with having a flag inside the 8-byte arg count, because it's very likely that I'll forget that it's there and use `(uint8_t)argCountAndFlags` to get the arg count. It can stay in the opcode like that, but when the opcode is executed, the flag should probably be extracted to a runtime flag in the high bits. This won't be difficult to do and I think it's worth doing.


## VM_VALUE_NO_OP_FUNC

The "well-known value" `VM_VALUE_NO_OP_FUNC` is a callable type that returns `undefined`.

It's not a built-in because it cannot be statically determined whether it's needed or not, and it would be wasteful to always include it. We also cannot synthesize a function on the fly because the program counter points to ROM.

This is used in the following places:

- `mvm_asyncStart` returns this if the caller is a void call.
- The `AsyncReturn` operation detects if the callback is `VM_VALUE_NO_OP_FUNC` and if so, it doesn't schedule it on the job queue.

Honestly, when I look at this design now, I think it would have been worth the few extra bytes to just have a built-in for this. The extra well-known value adds overhead to every operation that discriminates on type. A built-in function would be about 6 bytes in the bytecode. Actually, when I search the codebase, there aren't that many occurrences of `NO_OP_FUNC` so the cost on the engine is not too high at the moment. Mostly just in the conversion to int, to bool, and to string (and the call operation).


## Job Queue

With async-await, Microvium now has a job queue defined by the `jobQueue` machine register. There is only one queue and it corresponds to the promise job queue in the spec, since Microvium has no other jobs at present.

The job queue is executed at the end of the bottom `mvm_call`. This is to keep the API simple and intuitive. Microvium works like a state machine where `mvm_call` is used to pass a new "event" to the state machine, and then it changes state. It never does anything except when called.

The register as 3 states:

1. `undefined` indicates no jobs.
2. Pointer to a function: indicates a single job.
3. Pointer to a doubly-linked list of multiple jobs.

Timers can be implemented on top of this by invoking `mvm_call` when the timer expires, calling some VM function that expires the timer directly (does not need to hit the job queue at all). The Microvium API is single-threaded, so if multiple things can happen simultaneously in the host then these need to be serialized by the host (e.g. RTOS queue).

### Builtin: `BIN_ASYNC_COMPLETE`

The async features brings a new builtin `BIN_ASYNC_COMPLETE` to the engine. The CTVM will garbage collect this builtin before snapshotting if there are no async functions in the program.

This builtin is used to create closures for the job queue that complete an async function (resolve or reject it) by calling the callback with `(isSuccess, value)`.

These closures have 4 slots:

1. Reference to the bytecode of `BIN_ASYNC_COMPLETE`
2. isSuccess
3. Result/error value
4. The parent reference, which is used to access the async callback to invoke.


## Builtin: `BIN_ASYNC_CATCH_BLOCK`

At the entry of each async function and at each resume point, the engine will push a catch block to the stack to handle and redirect exceptions to the callback. The logic for the catch handler is always the same so, it's described by the common builtin `BIN_ASYNC_CATCH_BLOCK`. This is a function but it's not called -- it's only used as a catch target.

This IL sequence constructs a new closure which wraps `BIN_ASYNC_COMPLETE` and pushes it to the job queue.


## Compiler static analysis

The static analysis for async-await is a pain. The biggest issue is that the closure allocated for an async function depends on the stack depth at the await points in that function, because that affects the number of slots that need to be preserved. But the stack depth is not known at the time of the static analysis, it's only known as the IL is being emitted, which is necessarily after the static analysis that defines that IL.

The crude solution I've gone with for the MVP is to run the compiler twice if the unit contains any `Await` instructions. The first time, the stack depth at the await points will be absent and so the closure sizes and closure indexing of all nested functions may be wrong. The second time, it uses the stack depths of the await points as calculated from the first time, so the closures should be correct.

I don't know a clean alternative.

## Promises

A promise in Microvium is an object that inherits from the builtin promise prototype.

A promise has 2 internal slots:

  - A `VM_OIS_PROMISE_STATUS` which is:
    - `VM_PROMISE_STATUS_PENDING`
    - `VM_PROMISE_STATUS_RESOLVED`
    - `VM_PROMISE_STATUS_REJECTED`
  - A `VM_OIS_PROMISE_OUT` which is:
    - If the status is `VM_PROMISE_STATUS_PENDING`, it contains either:
      - `undefined` to indicate no callbacks
      - a function, to indicate a single callback
      - an array to indicate multiple callbacks
    - If the status is `VM_PROMISE_STATUS_RESOLVED`, `VM_OIS_PROMISE_OUT` contains the asynchronous return value.
    - If the status is `VM_PROMISE_STATUS_REJECTED`, `VM_OIS_PROMISE_OUT` contains the error.

To subscribe to a promise, Microvium uses the following logic:

  1. If the `VM_OIS_PROMISE_STATUS` is `VM_PROMISE_STATUS_PENDING`:
    1. If `VM_OIS_PROMISE_OUT` is undefined, set `VM_OIS_PROMISE_OUT` to the subscriber.
    2. Else if `VM_OIS_PROMISE_OUT` is not an array, set it to an array of one element where the element is the value in `VM_OIS_PROMISE_OUT`.
    3. Add the subscriber to the array.
  2. If the `VM_OIS_PROMISE_STATUS` is resolved:
    1. Create a closure that calls the subscriber with the result in `VM_OIS_PROMISE_OUT`.
    2. Add the closure to the job queue
  3. If the `VM_OIS_PROMISE_STATUS` is `VM_PROMISE_STATUS_REJECTED`:
    1. Create a closure that calls the subscriber with the error in `VM_OIS_PROMISE_OUT`.
    2. Add the closure to the job queue.
