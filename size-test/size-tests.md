# Size Test

This compiles Microvium for a generic ARM architecture as a size comparison, used for quoting the size of Microvium in documentation and blogs etc.

Here I'm compiling for a Cortex M0 architecture where the SRAM is all mapped to the physical address range 0x2000xxxx, because this is a real processor I have with me and the fact that it's 32-bit makes it a better comparison to other JavaScript engines that also typically quote their size as compiled for 32-bit.

Run `build.sh` to run the tests. This uses the ARM GCC compiler which it assumes is on the path.

# Learnings (2022-05-23)

## Minimal Size

As of today the engine compiles to 7,348 bytes. That's about minimal:

  - Compiled with space optimization `-Os`
  - Compiled for the Thumb instruction set
  - No float support (floats in JavaScript are 64-bit, which is expensive)
  - No 32-bit overflow checks (32-bit numbers will wrap around instead of being promoted to float)
  - No assertions and other checks
  - Note that this does not include any linked capability such as the standard library or bootstrapping code.

This is still a reasonable mode to compile in. If I say that Microvium requires "at least 8kB of flash" then this is what I'm referring to.

## Compiling with O3

If I use `-O3` instead of `-Os` for optimization, the size goes up from 7,348 to 13,546 bytes. That's a significant jump indeed.

## What's the contribution of pointer translation?

If I change the `MVM_RAM_PAGE_ADDR` to 0 (which would not actually run on a Cortex M0 since the SRAM is not in that address range), the size drops from 13546 to 12886, saving about 5%. This gives a rough picture of how much flash overhead is being used for pointer translation from 16-bit to 32-bit pointers. It's not that much, so I'm pretty pleased about that. The rest of the following tests have `MVM_RAM_PAGE_ADDR` set to `0x20000000` and `O3`.

## Cost of features?

If I enable `MVM_SUPPORT_FLOAT` the size goes up to 14894.

If I enable `MVM_PORT_INT32_OVERFLOW_CHECKS` as well as float, the size goes up to 15206.

If I enable `MVM_INCLUDE_SNAPSHOT_CAPABILITY` and `MVM_INCLUDE_DEBUG_CAPABILITY` as well, it's 15998 bytes.

If I enable `MVM_SAFE_MODE` and `MVM_DONT_TRUST_BYTECODE` as well, the size goes up to `22978`. This is not a mode I would typically compile it in but it's good to know that the size is still within reasons.


## Ram usage

This doesn't test the RAM usage, but the RAM usage is more predictable. See [memory-usage.md](../doc/native-host/memory-usage.md).


## Conclusion

When quoting the size of Microvium, it's not incorrect to say that it requires at least 8kB of flash -- that is, if you have less than 8kB of spare flash space, Microvium will not fit, and if you have more than 8kB of flash space then Microvium might fit, depending on your situation.

Being unable to predict what settings people are using, it would be more fair to quote 8-16kB.

I'll hopefully be adding more features to Microvium in future, which will also bump the space requirements up a little bit more.

This is of course just the size of the engine. If you're actually buying a device, you probably want at least 32kB of flash and 1kB of RAM.