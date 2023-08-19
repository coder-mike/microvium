# Async-await in Microvium

## Limitations

Async-await should "just work" in Microvium in most cases, but with some limitations:

- Promises do not have a `then` or `catch`. You can only use `await`.
- Microvium does not have `Promise.all`, `Promise.any`, or `Promise.race`.
- You cannot `await` a non-promise in Microvium.


## RAM Efficiency

The most efficient use of async-await in Microvium is the following, in descending order:

- If you call an async function and immediately `await` the resulting promise (e.g. `await myAsyncFunc()`), the promise will be elided and the called async function base a base size of just 6 bytes (plus 2 bytes for each variable or stack slot required by the async function).

- If you call an async function and bind the result to a variable or parameter (e.g. `promise = myAsyncFunc()`), the promise is not elided and the called async function has a base size of 16 bytes.

- If you create a new promise with `new Promise((resolve, reject) => ...)`, Microvium creates the promise object along with the `resolve` and `reject` functions, which totals 26 bytes. This is the least-efficient way to use promises -- you should generally prefer defining async functions.


## Host Async Functions

You can implement an async function in your C host by calling `mvm_asyncStart` right at the beginning of your C handler function. For example:

```c
mvm_TeError myAsyncFunc(mvm_VM* vm, mvm_HostFunctionID id, mvm_Value* pResult, mvm_Value* pArgs, uint8_t argCount) {
  mvm_Value callback = mvm_asyncStart(vm, pResult);
  // ...
}
```

The `result` here passed to `mvm_asyncStart` allows `mvm_asyncStart` to synchronously return a Promise to the caller, as async functions in JavaScript must do. The returned `callback` is a JavaScript function which when called with arguments `(isSuccess, resultOrError)` will either resolve or reject the aforementioned promise, depending on whether `isSuccess` is true or false. If `isSuccess` is true then `resultOrError` should be the asynchronous result that the promise will resolve to. If `isSuccess` is false then `resultOrError` should be the error you want to throw.

The function `mvm_asyncStart` may elide the promise if it determines that the caller is immediately awaiting the resulting promise. You use it the same way, so this elision is invisible to you, except that the RAM usage is different. The same efficiencies discussed in the previous section apply here: a host async function which is directly awaited will take 6 bytes of VM memory, but one where the resulting promise is assigned to a variable will use 16 bytes because the promise cannot be elided.

There is also a further optimization if the the caller does not use the result at all, for example calling `mvm_asyncStart()` as a statement rather than an expression. In this case, both the promise and callback closure are elided (requiring no VM memory) and the `callback` returned from `mvm_asyncStart` will perform a no-op when called.

Warning: some of the machinery for promises is only compiled into the bytecode if the compiled JS itself uses async-await in some way (e.g. the promise prototype object). If you get an error `MVM_E_ASYNC_WITHOUT_AWAIT` from the VM, it's because the JavaScript user code is invoking an async function and trying to store the resulting promise, but the bytecode was not compiled with promise support because the JavaScript has no `async` functions or `await` points. Simply awaiting the returned promise at any point will fix this error.