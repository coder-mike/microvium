# Microvium vs EmbedVM

[EmbedVM](https://embedvm.com/) is a very compact scripting engine for microcontrollers. This page summarizes the tradeoffs between the two so you can make an informed decision about which to use.

I intend to be as unbiased as possible. If you disagree with any of these points, please create a GitHub issue to discuss.

## Maturity and Maintenance

EmbedVM has been around a long time, but is no longer maintained. According to the commit history, the project was started in 2011 and remains largely unmodified since 2013, except for a Makefile change in 2017. The project not gaining any more features, but its main feature is its simplicity and size, so it wouldn't make sense for it to get new features. The concept behind EmbedVM is pretty simple and you can likely maintain it yourself if it requires any tweaks.

Microvium is in a usable state but still under development. As of this writing, it is not used in any major projects and so if you adopt it, you will be doing so at some level of risk.

## Portability

Both the EmbedVM and Microvium runtime engines are written in C.

EmbedVM gains portability by being simple enough that you can modify the implementation yourself. Be aware that it uses a non-standard GCC extension for [case ranges](https://www.geeksforgeeks.org/using-range-switch-case-cc/) in its main switch statement.

Microvium has complicated internals but gets portability through a "port file" -- a C header file with macro definitions that you tweak according to your architecture and use case. Microvium does not use non-standard features of C and so the internals should never need to be tweaked. If there is a problem with the Microvium implementation, create a GitHub issue.

## License

Both EmbedVM and Microvium essentially have the same open-source license terms for the compiler and runtime engine, allowing you to use and modify it without restriction as long as the license file is copied with the code.

Microvium has an optional additional component which is under development, [Microvium Boost](https://coder-mike.com/2020/06/microvium-boost/), which provides an optimization pass to make the bytecode more compact. Microvium Boost will be closed-source.

## Simplicity

The EmbedVM API and implementation is simpler than Microvium's. If you intend to maintain the source code yourself

## Memory Model

Both Microvium and EmbedVM are 16-bit VMs, meaning that they can only address a theoretical maximum of 64kB of memory.

The memory space for EmbedVM is a single homogenous 64kB space which is abstracted through `mem_read` and `mem_write` function calls to the host, which you need to implement yourself, completely abstracting the underlying memory.

Unlike EmbedVM, Microvium is garbage collected (GC). It has 4 memory spaces:

  1. Stack space (unlimited size)
  2. RAM space (up to 64kB)
  3. ROM space (up to 64kB)

It also has the additional restriction that the bytecode image cannot exceed 64kB.

In total, Microvium can address more memory than EmbedVM (for example, a program using 64kB ROM can allocate an additional 64kB of RAM at runtime, having a total of 128kB of addressable memory).

A Microvium ROM image can be stored in an external memory space if desired, like with EmbedVM. Unlike EmbedVM, RAM in Microvium must be local, addressable RAM.

Both EmbedVM and Microvium will run fine on 32-bit or 64-bit hosts, but this will not increase the size of the memory addressable to the script.

## Language and feature set

The biggest advantage of Microvium over EmbedVM is the feature set. Many of the [supported language features](./supported-language.md) of Microvium are not available in EmbedVM. Microvium is based on a subset of JavaScript, and brings the following JavaScript features which EmbedVM does not have:

  - [Integers larger than 16-bit](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number). Up to 32-bit integers are supported with high performance, after which the value will overflow to a 64-bit float (if floats are enabled for the engine).
  - Strings and real booleans
  - Objects and arrays
  - First-class module support (`import`/`export`) without using an external preprocessor.
  - Nested functions and closures

In addition to the language features, Microvium supports the [snapshotting concept](./concepts.md) which allows the script to be partially evaluated at compile time. This feature can be used to pre-compute lookup tables, or to bring in external resources at compile time. This can greatly improve your workflow.

## Documentation

EmbedVM does not have language documentation (it's marked as a 10-year-old TODO). It uses a non-standard language, so you can't refer to any external documentation either. But the language is simple and relatively easy to understand from the examples included with the source code, it's not going to change over time.

Microvium has more documentation, including a [getting-started guide](./getting-started.md) to get up and running quickly. The getting-started guide executed as part of the automated regression tests (the tests pull out the example code from the guide and execute it), to make sure that it doesn't fall out of date and that steps always work.

Microvium implements a subset of the JavaScript language, so if a feature [exists in Microvium](./supported-language.md), its semantics roughly follow those documented on JavaScript sites and forums.

## Size

The EmbedVM engine claims to be about 3kB in size. The Microvium engine is about 16kB when compiled to a 16-bit device, so it's significantly larger.

While I have not measured it, an empty bytecode file for EmbedVM is likely to be smaller than for Microvium. An empty bytecode file in Microvium is about 64 bytes.

While I have not measured it, more complicated scripts are likely to be more compact in Microvium than in EmbedVM since the engine is more powerful and can do more with a single instruction.

EmbedVM does not have any implicit RAM usage (other than the C call stack when you call it), and instead it's up to you how much RAM you want to dedicate to it. Microvium dynamically scales the RAM usage according to what it needs, with a minimum of 20 bytes per virtual machine.

See [memory-usage.md](./native-host/memory-usage.md) for more details.

## Performance

No scripting engine will likely be very performant on a microcontroller. For performance-critical tasks, it will likely be better to code natively.

While I have not benchmarked it, Microvium is likely to be slower than EmbedVM for many types of scripts because Microvium is doing more work to manage dynamic typing and different memory spaces. Some tasks might be more efficient in Microvium because their representation in EmbedVM's limited feature set may be unwieldy.




