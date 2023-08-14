# What I would do differently

Notes about what I might do if I were to re-do Microvium from scratch.

## 32-bit

The first thing is that I would make it 32-bit, with a 32-bit slot size. This would:

1. Unlock much larger heap sizes.
2. Improve performance on 32-bit platforms. Especially related to address mapping.
3. Simplify a lot of the code and make it cleaner.

I think 16-bit was the right size to start with because it targets a niche and avoids making enemies in the 32-bit space, and because the RAM footprint is so incredibly low with a 16-bit slot size.

## No separate compile-time VM

I would consider just having one VM and use it at compile time or runtime.

## No "Futures" in the snapshot encoder

Rather do multiple passes. Futures are so hard to debug.

## No HTML output from snapshot encoder

Although it's helped a few times for debugging, it's not worth the complexity. Or at least I would structure it differently -- maybe a plaintext file and then each sequence of output bytes can have an associated string.

## Safe-Value

GC issues are a pain. I would seriously consider using a `mvm_SafeValue` instead of `mvm_Value` as the default type for values. An `mvm_SafeValue` would compile as a struct under safe mode, but a naked `mvm_Value` under unsafe mode. The struct would embed the current `vm->gc_potentialCycleNumber`. And then in various places that use the value, it can check that a GC collection couldn't have occurred since the value was loaded. This should be used in the API as well. Basically it should be prolific -- everywhere that uses `mvm_Value` should use `mvm_SafeValue` instead, except for values in actual VM slots on the stack or heap.

## Standardize function parameter types

This idea needs thought, but there's an issue in the Microvium internals that sometimes pointers are passed as `mvm_Value` and sometimes as C pointers. This makes it more difficult to write code because when I want to do something basic like "read the header of this allocation", I need to figure out what function takes the input that I have and use that. Or there are multiple versions of the same function that take different types. For example

- `vm_getAllocationSizeExcludingHeaderFromHeaderWord`
- `vm_getAllocationSize`
- `vm_getAllocationSize_long`

- `vm_getAllocationType`
- `vm_getTypeCodeFromHeaderWord`
- `deepTypeOf`

Probably the code would be a lot simpler if everything was passed as `mvm_Value`. Functions that are expecting pointer values can just assert that the `mvm_Value` is a pointer. This also works well with the above-mentioned `mvm_SafeValue` idea.

A 32-bit slot size would also help with this because we wouldn't need long and short pointers, and because we wouldn't need to be as concerned about the efficiency gains of caching the conversion from value to pointer because pointers would be the same binary structure as values (in non-safe mode).

## Standardized function prefix

This is a bit of a mess -- some internal functions in Microvium have no prefix and some are prefixed with `vm_`. It doesn't matter to the user because they're all `static` and so invisible to the linker, but this should be made consistent.

I agree with the choice to have a different prefix for the API functions (`mvm_`) than the internal functions (`vm_`).

## Deep and shallow references

We have functions like `deepTypeOf` that support being given a value that is a reference to a global handle and then dereferencing the extra layer of indirection.

A more consistent approach might be to translate immediately pointers when reading the a slot. To make this efficient, in a 32-bit system, we could dedicate an entire tag to indirect pointers, or pointers from ROM. So maybe the following tags:

- `0b00` - 32-bit RAM pointer, for GC-traceable pointers
- `0b01` - 30-bit integer
- `0b10` - Bytecode pointer (32-bit)
- `0b11` - Indirect pointer from ROM to RAM via handle (32-bit)

We can afford the extra tag in 32-bit because we have 32 bits to play with and because RAM value alignment will be 4-byte instead of 2-byte.

The bytecode pointer type is still useful because it allows the bytecode to be located anywhere in the address space.

Another idea would be instead of using a bytecode pointer, to use an auto-relative pointer. This would have the benefit that decoding it would not require referencing the global location of the bytecode. So references from bytecode to bytecode would be naturally position independent.

(Note: I've actually proposed 2 different things in this section. One is to avoid having to deal with handle indirection in most places by converting values eagerly. The other is to have a universal way of dealing indirection everywhere so there's no need to distinguish deep/shallow operations).

## Don't change: `MVM_VERY_EXPENSIVE_MEMORY_CHECKS`

Just noting that this feature is a life saver. If I do a re-write, this needs to go in early and be foundational. Even consider improving this.

## Not using futures for the snapshot encoder

The futures are hard to debug. I think the code cohesion that they bring is good, but I think it would be better to use a POD type that represents the future operation rather than closures. I think it would make it easier to debug because you can actually see or dump the future operations.

For example, the code that encodes a function body can output a buffer of bytes and then an array of linking information that says how to provide substitutions when the concrete addresses of other functions are known. Currently the linking information is implied by the set of futures attached to the buffer, but I think it would be better to use a POD type.

Something that worked well that I wouldn't change is that each future substitution needs some kind of debug context identifier that can be used to trace back the origin of the future substitution. But this may be less important if we're not using closures.

## No test artifacts in the repo

It worked well at the beginning to have test output in the repo because it was kinda like I didn't need to write out the test output by hand. But the issue is now that every time I make a small change to the emitter (IL or bytecode), the IL and/or disassembly of every test case lands up in the git diff.

It stopped being useful because I never actually look at it anymore, even when debugging.

It might be tolerable to have one or two files like this, but to do it automatically for all the end-to-end tests is a terrible idea.

## Don't change: stable addresses in allocator

Something that really worked well is having an allocator in the C++ project that produces deterministic addresses on each run. Among other things, it means that memory corruption issues are 100% reproducible. Data breakpoints remain valid. You can note down pointers from one run and they're still the same on another run.

## Don't change: tombstone being type 0

Having the tombstone as type zero and the type code in the high nibble of the header means that most random words are not valid headers, which makes catching corruption errors much easier.