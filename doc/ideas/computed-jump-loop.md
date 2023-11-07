# Computed Jump Loop

https://eli.thegreenplace.net/2012/07/12/computed-goto-for-efficient-dispatch-tables

The Microvium instruction set doesn't fit well with this for 2 reasons:

1. There are some 4-bit opcodes (like `VM_OP_LOAD_ARG_1`), some 8-bit, and some 16-bit (anything in `vm_TeOpcodeEx4`).
2. The opcodes are grouped for commonality in their preprocessing.

But I'm thinking that computed-goto could still be used, with a slight variation:

- Have a 256-byte mapping table that maps from the bytecode byte to the corresponding "instruction index". For example, `0x00` to `0x0F` are all for `VM_OP_LOAD_SMALL_LITERAL` so they would all map to the same instruction index.

- Have a smaller mapping table from instruction index to the target label, from which the instruction loop can perform a computed jump.

- Have a mapping table from the instruction index to a set of flags that indicate sub-instructions to perform. Either a set of flags like "bit 2 means pop the stack before running the instruction" or an index into another computed jump table that represents the operation preprocessing required.

There are about 100 distinct instructions in Microvium. If I was to guess 10 different common preprocessing options. Then we may have tables like this:

- 256x1 -> mapping from bytecode byte to instruction index
- 100x1 -> mapping from instruction index to preprocessor index
- 10x4 -> mapping from preprocessor index to preprocessor handler
- 100x4 -> mapping from instruction index to instruction handler

That's 256 + 100 + 40 + 400 = 796 bytes.

The 4-byte label pointers could theoretically be reduced to 2 bytes considering that the whole function is less than 64kB, so labels could be relative to the start of the function. Then we're looking at 576 bytes of tables.

Going the other direction, it may be more efficient to just have a single 256x4 dispatch table. This would cost more in terms of code size, but might be much faster. It's hard to say.

It's not clear at this stage whether a dispatch loop of so many steps would be worth it or not. It would be interesting to try it out and see.

Before doing that, it might be worth profiling some real JavaScript code on Microvium and see where it spends most of its time.