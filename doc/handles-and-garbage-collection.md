# Handles and Garbage Collection

## Summary

- An `mvm_Value` may internally describe a pointer into the Microvium heap.
- Microvium uses a compacting heap, meaning that allocations on the heap may move during a garbage collection (GC) cycle and so the `mvm_Value` may need to be updated accordingly.
- In a C/C++ host, use `mvm_Handle` to wrap an `mvm_Value` at any time where there might be a garbage collection cycle.
- A garbage collection cycle can happen whenever a Microvium API function is called, since most API calls can cause the VM to allocate heap memory and add GC pressure.
- `mvm_initializeHandle` adds the handle to a linked list, so the handle memory itself must not move.
- Handles also prevent the garbage collector from freeing the allocation that the `mvm_Value` points to, if there are no other references to it.

### Use handles in the following situations:

- When passing multiple arguments to a JavaScript function, the process of creating the each argument may trigger a GC cycle that trashes the previous arguments.
  - First initialize a handle for each argument (`mvm_initializeHandle`).
  - Then create the value for each argument (`mvm_handleSet`). Each successive argument created has the potential to trigger a GC that changes the value of the previous arguments.
  - Then copy all the values into an arguments array (`mvm_handleGet`) to give to the VM.
  - Then call the VM `mvm_call`.
  - Then release all the handles (`mvm_releaseHandle`)
- Long-lived `mvm_Value`, such as C/C++ globals.

### You don't need to use handles for:

Although it's always safe to wrap a valid `mvm_Value` in a handle, it's not necessary in the following situations:

- Values returned from `mvm_resolveExports`.
- Values that are immediately passed to a Microvium API function and never used again.
  - For example, the result value of `mvm_call` does not need a handle if the only thing you do with it is subsequently pass it to `mvm_toStringUtf8`.
  - If passing only one argument to `mvm_call`
- The following JavaScript values do not need handles (but are safe to put in handles):
  - `undefined` (`mvm_undefined`)
  - `null` (`mvm_null`)
  - `true` (`mvm_newBoolean(true)`)
  - `false` (`mvm_newBoolean(false)`)
  - Integers in the range `-8192` to `8191` (created by `mvm_newInt32`)

## Garbage Collection Basics

JavaScript is a garbage collected language, meaning that the developer does not need to allocate and deallocate memory for objects. Instead, the JavaScript engine manages memory allocation and deallocation automatically.

Objects are freed automatically by doing a reachability analysis on the object graph. An object is defined as "reachable" if it is referenced by a global variable (in JavaScript), or transitively referenced by another reachable object (which might itself be reachable by a global variable). Any object which is not reachable is subject to be freed. Global variables in this case are called "roots" of the object graph. Other examples of roots are local variables on the stack, job queues, and *handles*, which are the main focus of this document.

There are different types of garbage collector algorithms. Microvium uses an algorithm that moves memory allocations to be adjacent to each other to avoid fragmentation and reduce idle memory use. This means that the address of objects in Microvium are subject to change at any point where a garbage collection cycle might happen. This means that some care must be taken when referencing a Microvium object from a C/C++ host.

This applies not only to objects, but almost any JavaScript type, such as functions, strings, or even numbers, since any of these are potentially allocated on the garbage-collected heap.

As a rule of thumb, you may assume that a garbage collection cycle can happen at any time that Microvium has control. That is, when any of its API functions are called.

You can see more details about Microvium's collector [here](https://coder-mike.com/blog/2020/07/08/new-garbage-collector/).

## Microvium's `mvm_Value` type

You may have noticed that Microvium's `mvm_Value` is simply a typedef of `uint16_t`. In many cases, this `uint16_t` can be interpreted as an offset into the Microvium heap. In particular, you can interpret it as an offset into the Microvium heap if the value is even (i.e. the low bit is zero). So if you see an `mvm_Value` of `12` then this means the value is a pointer to position `12` in the Microvium heap. Note: This is an internal detail and is subject to change.

If the `mvm_Value` is odd (if the low bit is `1`), it could be any number of other things which I won't go into here. One value you may see particularly often is the value `1` which represents the JavaScript value `undefined`.

Since an `mvm_Value` may be a pointer to the Microvium heap, and we know that Microvium may reorganize the heap or free the object at any time, we need to use a *handle* to reference it from C/C++ code.

## Handles

The `mvm_Handle` type is a linked list node that wraps an `mvm_Value`. `mvm_initializeHandle` adds the handle to Microvium's handle linked list, making it reachable to Microvium's garbage collector. Any time a GC cycle is triggered, Microvium will traverse all the handles to ensure that the allocations they reference are not freed, and to update the address if the allocation has moved.

Handles should be released again with `mvm_releaseHandle` when they are no longer needed. This removes them from Microvium's linked list.

Get and set the inner value of a handle using `mvm_handleGet` and `mvm_handleSet` respectively.

