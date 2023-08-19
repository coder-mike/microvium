# Async Await

Terms:

- **await-call**: a function call whose result is immediately awaited.
- **void-call**: a function call whose result is not used at all.
- **normal call**: any other function call.

Basically:

- If you `await-call` or `void-call` a function, the callee will be notified via the `cpsCallback` register so it won't generate a promise.
- It will instead use continuation-passing-style (CPS) and the callee will call the callback defined in the `cpsCallback` register.

## CPS Protocol

  1. The caller passes a callback via the `cpsCallback` register
    - Or `undefined` to indicate a non-CPS caller (normal call)
    - Or `deleted` to indicate no-callback (void call), along with the flag `AF_VOID_CALLED`. The `deleted` value is used generally as a poison value for `cpsCallback` to indicate that the register doesn't hold a callback for the current frame.
    - The callback has the signature `(isSuccess, value)`.

  2. The callee will synchronously return `deleted` to indicate an asynchronous return value.
    - When it hits its first suspension point.
    - Or returns before encountering any suspension points.

  3. The callee will asynchronously call the callback when it completes.
    - It will call the callback exactly once
    - It will call the callback only from the job queue.

All async functions are implemented internally using CPS, and then the engine will automatically provide adapters at runtime to convert between CPS and promises where necessary.

## Closure structure:

Async functions are implemented using the closure machinery. The closure structure is as follows:

  - `scope[0]: continuation` - pointer to the continuation function bytecode.
  - `scope[1]: callbackOrPromise` - a pointer to the caller continuation, promise, or `null` if void-called.
  - Async closure variables - any variables that the compiler identifies as being used by nested functions inside the async functions.
  - Async local variables and stack to be preserved at await points. At least the number of slots required for the deepest await point. Includes catch targets that were saved to the stack using `StartTry` before an await point.
  - Plus the normal parent scope pointer, if required.

## Stack structure

  - `var[0]` - synchronous return value (promise, or elided promise designated by `deleted`, or just `undefined` if resumed off the job queue).
  - `var[1-2]` - top-level catch block target.

## Opcodes

  - `AsyncStart` - at the entry of an async function
  - `Await` and `AwaitCall` - at `await` points.
  - `AsyncResume` - after `await` points to re-establish async state.
  - `AsyncReturn` - at the end of an async function or when the user has a `return`, to clean up after `AsyncStart`
  - `AsyncComplete` - schedule all the callbacks referenced by `scope[1]: callbackOrPromise` to be called on the job queue.

## Preserving the stack

The new `Await` and `AsyncResume` instructions automatically preserve and restore the stack when suspending and resuming the async function. The `Await` instruction knows the stack depth dynamically, and the `AsyncResume` instruction is statically compiled to know the stack depth (i.e. how many values to copy out of the closure and into the stack).

Only the stack after `var[2]` is preserved. `var[0-2]` include the return value and the top-level catch block target, which do not need to be preserved since they're reconstructed.


## Catch blocks

The stack preserved by `Await` and restored by `AsyncResume` includes the catch blocks that are kept inline in the stack. Catch blocks are stored as a linked list. Each catch block is 2 slots, one that references the code address to handle the catch and the other that references the parent catch block.

The semantics of these have been modified so that the parent reference is relative rather than absolute, so that they still make sense when restored if the absolute stack level is different (i.e. when resumed from the job queue).

Because catch blocks can now be referenced by heap-allocated values (i.e. catch targets persisted to async closures), catch blocks are now 4-byte aligned and have a continuation header so that they're valid addressable entities. This is the same header as used for resume points (see the next section) even though a catch block is not an async resume point as such (it was just convenient since both catch blocks and resume points are addressable entities that are parts of a larger addressable entity (the function)).

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
- `VM_OP3_ASYNC_RESUME` opcode with an arg for the number of slots to restore on the stack

The padding is so that the resume instruction is 4-byte aligned and can be referenced by a bytecode pointer.

The function header makes the resume point callable.

In addition to the `TC_REF_FUNCTION` type-code in the function header, it also includes:

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

The back-pointer is used when decoding to find the containing function. Note that the decoder finds things in ROM by following pointers to those things, not by iterating the ROM space.

At runtime, the back-pointer is used to find the required max stack height of the function, which is needed for asserting that the stack is big enough to restore the stack frame when the continuation is called (and may in future be used for dynamically-expanding the stack).

### Await and AwaitCall

The `AwaitCall` instruction is emitted if the awaited expression is a function call. This instruction synthesizes the callback and passes it to the callee in the `cpsCallback` register and then delegates to the normal call machinery to perform the call.

If the callee is an async function, it will accept the callback in the `cpsCallback` register and return `deleted` to represent an elided promise. The caller will continue on the `Await` instruction which will see the value `deleted` and know that the callee accepted the callback.

If the callee is not an async function, it will return a normal return value (anything except `deleted`) and the caller's `Await` instruction will do a promise-await (Microvium does not support awaiting non-promises). A promise-await subscribes the current closure (i.e. the async continuation) to the given promise.

Either way, `Await` will also preserve the stack and unwind the top-level catch block. See [Preserving the stack](#preserving-the-stack). The await knows the stack depth dynamically.

## Interaction with C host

The VM can call async functions in the host. The host implements an async function by calling `mvm_asyncStart` (see `microvium.h`).

If the caller is an await-call, `mvm_asyncStart` basically returns the callback from the `cpsCallback` register (actually a wrapper around it -- see below). Otherwise, it creates a promise and a new callback that resolves/rejects the promise.

More accurately, `mvm_asyncStart` returns a callback constructed by the builtin `asyncHostCallback` (`BIN_ASYNC_HOST_CALLBACK`) which has bytecode that ultimately invokes the `AsyncComplete` (`VM_OP4_ASYNC_COMPLETE`) operation, having the effect of scheduling all the callbacks (either the single callback if CPS, or the callbacks contained in the promise).

If the host function was not invoked using CPS (await-call or void-call) then `mvm_asyncStart` has the effect of instantiating a promise.

`mvm_asyncStart` is also given a pointer to the synchronous return value, which it will either set to the constructed promise or to `deleted` if the promise is elided.

Internally, the `AsyncStart` (`VM_OP4_ASYNC_START`) opcode has essentially the same effect as `mvm_asyncStart` but with fewer checks (see `mvm_asyncStartUnsafe`). A key difference is that `mvm_asyncStart` will always return a callback, whereas internal async functions can deal natively with calling-back a promise (settling the promise). If `mvm_asyncStart` does create a promise, it wraps it in a callback that settles the promise.

## Void calls

At the top of an await chain there must be a call operation that does not await. In order not to construct a promise for this call, there is a flag (`AF_VOID_CALLED`) that tells the callee that the return value is not expected. To save on instructions in the instruction set, this flag is encoded as the high bit in the arg-count of a normal Call instruction.

The `Return` instruction also observes this flag and will not push a return value to the stack if the caller signalled a void call.


## VM_VALUE_NO_OP_FUNC

The "well-known value" `VM_VALUE_NO_OP_FUNC` is a callable type that has no associated bytecode and always just returns `undefined`.

It's not a built-in because it cannot be statically determined whether it's needed or not, and it would be wasteful to always include it as a builtin. We also cannot synthesize a function on the fly because the program counter points to ROM.

This is used in the following places:

- `mvm_asyncStart` returns this if the caller is a void call.
- The `AsyncComplete` operation detects if the callback is `VM_VALUE_NO_OP_FUNC` and if so, it doesn't schedule it on the job queue.


## Job Queue

With async-await, Microvium now has a job queue defined by the `jobQueue` machine register. There is only one queue and it corresponds to the promise job queue in the spec, since Microvium has no other jobs at present.

The job queue is executed at the end of the bottom-most `mvm_call` (`mvm_call` may be invoked reentrantly). This is to keep the API simple and intuitive (the host does not need to separately pump the job queue). Microvium works like a state machine where `mvm_call` is used to pass a new "event" to the state machine, and then it changes state. It never does anything except when called.

The `jobQueue` register has 3 states:

1. `undefined` indicates no jobs.
2. Pointer to a function: indicates a single job.
3. Pointer to a doubly-linked list of multiple jobs (actually a cycle, not a list).

The 3rd state, where there are multiple jobs, is implemented as a double-linked cycle where the `jobQueue` register points to the **first** node, but the `previous` pointer of the first node points to the **last** node. This allows O(1) access to both the beginning and end of the queue with only one register.

The hot path with jobs is expected to be case 2 where only a single job is queued. E.g. a cascade of await-calls will be resolved one at a time, with each enqueuing the callee continuation when it finishes. In this hot path, there is no allocation of linked-list nodes so it's fairly efficient (although there is still the allocation of the job closure itself).

Timers can be theoretically implemented on top of this queuing mechanism by invoking `mvm_call` when the timer expires, calling some VM function that expires the timer directly (does not need to hit the job queue at all). The Microvium API is single-threaded, so if multiple things can happen simultaneously in the host then these need to be serialized by the host (e.g. RTOS queue).


## Builtin: `BIN_ASYNC_CATCH_BLOCK`

At the entry of each async function and at each resume point, the engine will push a catch block to the stack to handle and redirect exceptions to the callback. The logic for the catch handler is always the same so, it's described by the common builtin `BIN_ASYNC_CATCH_BLOCK`. This is a function but it's not called -- it's only used as a catch target.

This IL sequence constructs a new closure which wraps `BIN_ASYNC_COMPLETE` and pushes it to the job queue.


## Compiler static analysis

The static analysis for async-await is a pain. The biggest issue is that the closure allocated for an async function depends on the stack depth at the await points in that function, because that affects the number of slots that need to be preserved. But the stack depth is not known at the time of the static analysis, it's only known as the IL is being emitted, which is necessarily after the static analysis that defines that IL.

The crude solution I've gone with for the MVP is to run the compiler twice if the unit contains any `Await` instructions. The first time, the stack depth at the await points will be absent and so the closure sizes and closure indexing of all nested functions may be wrong. The second time, it uses the stack depths of the await points as calculated from the first time, so the closures should be correct.

I don't know a clean alternative.


## Promises

A promise in Microvium is an object that inherits from the builtin promise prototype.

Microvium does not support user code constructing an object with an arbitrary prototype, like `Object.create`, so it's impossible for a user to create an object that inherits from the promise prototype that is not a promise. So Microvium uses the prototype as a strong brand check, to know if an object is a promise. The strong brand check is required because promises have internal slots for their status.

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

With 2 internal slots, a Promise is 10 bytes. The user code can add further properties if it wishes.

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

A user may create their own Promises with `new Promise((resolve, reject) => ...)`. These promises are also created with the same 2 internal slots. This required a new feature which is that objects that are "special prototypes" -- like the promise prototype, being used for a brand check of derived objects that have internal slots -- have their own internal slots which encode the number of internal slots of the derive type. In summary: the `Promise.prototype` object has an internal slot that has the count of the number of internal slots that a `Promise` should have, as well as their initial values.

When constructing a promise using `new Promise`, the builtin promise constructor, the `resolve` and `reject` closures are constructed using a similar layout to async functions themselves, and reuse the `AsyncComplete` machinery to settle the constructed promise. The `resolve` and `reject` closures reference separate bytecode functions that set up the context for `AsyncComplete`.