# Memory Management

See also: [./memory-usage.md](./memory-usage.md).

## Garbage Collection in Microvium

Microvium has a _managed heap_, meaning that memory allocations inside the Microvium virtual machine are automatically freed by a _garbage collector_ when they're no longer needed.

The GC (garbage collector) in Microvium is a stop-and-copy compacting collector, also called a semispace collector (this implementation detail may change in future without notice). During collection, it requests a new block of memory from the host, and copies reachable allocations from the original memory pool into the new pool contiguously.

This kind of collector has fast, constant-time allocation performance, just incrementing a free pointer forwards every time new memory is needed. Collection cycles are relatively slow, but the collection time is only proportional to the number and size of living objects. Unreachable objects do not contribute to the collection cycle duration since the collector only spends copying living objects to the new space and then dismisses the whole old space at once.

See also, [New Garbage Collector](https://coder-mike.com/2020/07/new-garbage-collector/), for some pretty animations.

## Handles: References from C into Microvium

(Note: this is a different thing to handles in the snapshot)

When the host (C code) holds a reference to an object in Microvium, the GC needs to know not to free that object. The GC also needs to be able to move that object to a different memory location during compaction, without creating a dangling pointer in the host. This is achieved through the use of _handles_.

A handle is a data structure owned by the host, which holds a value that the GC knows about. This is represented by the type `mvm_Handle`.

Each handle is a node in a linked list of handles associated with a virtual machine. When the GC runs, it will traverse the linked list of handles and treat the value embedded in each handle as being reachable (the handle values form roots of the reachability graph).

Handles are added to the linked list for a virtual machine by calling `mvm_initializeHandle`, and must be removed again when no longer needed by calling `mvm_releaseHandle`.

## When to use a handle?

Handles are relatively expensive and not always required. The GC abides by the following rules to help reduce the number of handles required:

  - The GC will never run a collection cycle while the virtual machine does not have control. Microvium is single-threaded, and even if the GC were to run in a separate thread in future, the guarantee is that collection will be suspended while the host has control. However, the garbage collector is allowed to run at any time while the VM has control.

  - Values passed as arguments to a host function are already reachable by the GC for the duration of the call, and do not need to have handles during this time. If the host needs to persist an argument beyond the lifetime of the called function, it must create a handle.

  - Values retrieved by resolving an export (`mvm_resolveExports`) are always reachable, since exports are stored in ROM. These do not need to be rooted by handles.

  - Values of type `undefined`, `null`, and `boolean` never have references, and so do not need to be protected as handles. Note that all other types _may_ have references. For example, 32-bit integers are stored internally as a pointer to a 32-bit memory allocation, and the GC needs to keep track of these.

The Microvium C API does not enforce the use of handles, because it cannot know the intended lifetime of the values in question. It is up to the host implementation to correctly apply the use of handles according to these rules.

In particular, take note of the `vm_newX` API functions which create new values in the VM. The return values of these functions are not anchored by the GC, and so care must be taken to

## Copying and moving `mvm_Value` values

`mvm_Value` is a 16-bit type that may directly embed a value, or may reference an allocation in the GC heap. It's safe to copy/assign instances of `mvm_Value` without risk of tearing, since it's a fixed-size type. However, be aware that every instance of a `mvm_Value` that is not within a registered `mvm_Handle` is subject to become invalid at the time of garbage collection (e.g. it may become a dangling pointer).

## Handles in Node.js hosts

There is no need to manually track handles in Node.js hosts. The node native module wraps a handle for every value. Node.js has it's own GC which frees these values, including their handles.


