# Diagnosing Issues

If you're using Microvium and you're running into issues, there are a few things that can help with diagnosis.

## MVM_SAFE_MODE

If you can afford the cost, enable `MVM_SAFE_MODE` and `MVM_DONT_TRUST_BYTECODE` in the port file. This will just help to find any issues in the engine itself.

If you're encountering an issue with garbage collection, enabling `MVM_VERY_EXPENSIVE_MEMORY_CHECKS` in extreme situations may help, but is not recommended most of the time.

See the example port file for descriptions of all these defines.

## MVM_ALL_ERRORS_FATAL

In the port file, if you set `#define MVM_ALL_ERRORS_FATAL 1`, then Microvium will call the fatal error handler as soon as it encounters an issue. If you set a breakpoint in the fatal error handler (`MVM_FATAL_ERROR`), you will be able to see where the problem is occurring.

## JavaScript Breakpoints

Microvium does not support a full debugger yet. But if you set `MVM_INCLUDE_DEBUG_CAPABILITY` to `1` in the port file, the Microvium C API will give you `mvm_dbg_setBreakpoint` and `mvm_dbg_setBreakpointCallback`, which you can use to tell Microvium to call the callback each time the given breakpoint address in the bytecode is encountered.

You can find the bytecode addresses to use by looking at the disassembly, as in the following section. A valid breakpoint address is the address of any instruction in the disassembly bytecode.

## Outputting Snapshot Disassembly (Map File)

If you compile a script with the CLI using the option `--output-disassembly`, Microvium will give you the disassembly view of the whole the bytecode image. This view shows the addresses down the left column, then the sizes of each object in the image (all in hexadecimal), and what it is.

## Outputting IL

If you suspect that the compiler is giving issues, the CLI option `--output-il` outputs diagnostic IL that it's generated for each input file, as well as IL for the final snapshot (before encoding it to binary bytecode).

## Post an issue on GitHub

If you post an issue on GitHub, I'll try to help you diagnose your issue, whether it's in your code or in Microvium. It really helps if you provide a full minimal working example that demonstrates the problem, if possible.