# Microvium vs Cesanta mJS

A comparison of Microvium and [Cesanta mJS](https://github.com/cesanta/mjs). I'll try to be as honest as possible but of course I may be unintentionally a bit biased. Please let me know of any inaccuracies or misrepresentations.

mJS is the most similar engine to Microvium in terms of capability and intent, so it's an interesting comparison.

Or skip to the [Conclusion and Summary](#conclusion-and-summary) at the end.

## Size

Size is important because both Microvium and mJS are designed to fit into small spaces as one of their key features.

mJS say:

  > That makes mJS fit into less than 50k of flash space (!) and less than 1k of RAM (!!). That is hard to beat.
  (https://mongoose-os.com/blog/mjs-a-new-approach-to-embedded-scripting/)

I've verified that mJS compiles to [46,729 bytes of flash](../rubbish/2022-05-23-compiling-mjs/build.sh) when targeting an nRF52, which is an ARM Cortex M4 device (similar to the Cortex M0 that I've used for the size tests of Microvium).

The last time I measured the size of Microvium, it uses about 8 to 16kB of flash space when compiled for a 32-bit ARM Cortex M0. This puts it about 3-6 times smaller than mJS.

In terms of RAM, Microvium uses 36B of RAM per VM, plus whatever heap memory the VM uses and whatever VM stack size you configure (the default stack size is 256B).

The default 256B stack size in Microvium is roughly the equivalent room to a 1kB stack size in mJS since Microvium slots are a quarter of the size (see next section).

The stack and virtual registers are only allocated while the VM is actively running a function, so the space can be used by the rest of the firmware when the VM is idle. The minimum idle RAM required by a VM is actually only 22B.

See [size-tests.md](../size-test/size-tests.md) and [memory-usage.md](../doc/native-host/memory-usage.md).


### Slot size

mJS uses a 64-bit slot size, which is half of XS's 128-bit (16-byte) slot size, but still 4-times larger than Microvium's 16-bit slot size. This means that for smaller values, like small integers or booleans, or the values `undefined` or `null`, Microvium will take 16-bits while mJS will take 64-bits.

But on the other hand, larger integers (> 4095), small strings, etc, mJS will handle them more compactly and efficiently because the values are inline. A floating point value like `1.5` will take 8 bytes in mJS but but 12 bytes in Microvium. And the integer `1_000_000` will take 8 bytes of RAM in both mJS and Microvium, but Microvium incurs GC overhead for this value.

Depending on the type of script you have, the 16-bit slot size of Microvium might mean a lot less RAM usage for your VM. I've seen scripts with lots of top level variables that are representing basic counters and flags, and these will generally 4x larger in mJS than Microvium.

### Object properties

Every property on an object in mJS takes 18-24 bytes (`mjs_property` + allocation header).

In Microvium, each new property added to an object takes 10 bytes initially (`TsPropertyCell` + allocation header) and is compacted to 4 bytes after a GC cycle (property lists are compacted from a linked-list format to a contiguous format during garbage collection).

### Garbage collector and managed heap

mJS uses a mark-sweep garbage collector while Microvium uses a mark-compact collector (but compacts into a new memory allocation rather than the original memory block, so in some ways it's more like a semispace collector). They both have their advantages and disadvantages.

The mark-compact collector for Microvium was chosen because mainly because it's "compact". No space is lost to heap fragmentation. Every collection cycle is in a sense performing a "defragmentation" to squeeze out all the unused space.

Both mJS and Microvium allocate memory from the host in chunks (using `calloc`/`malloc`). Microvium compacts the chunks together into one chunk during a GC collection cycle (since each chunk incurs additional overhead) while mJS does not.

Overall, this might make Microvium better in scenarios where the script uses less of the device memory and you want to keep it "out of the way" (consuming as little memory as possible) while mJS may be better if your script is consuming a lot of the available memory on the device.

### Stack size

When making a function call, the VM will save the current state of the registers to the stack before transferring control to the called function. This happens during each function call, so it's a fixed overhead for each stack frame.

In Microvium, this overhead is 8 bytes. In mJS, it looks like it's 40 bytes. Stack frames are very short lived though, so don't put too much weight on this difference.

Microvium completely frees the whole stack memory when control returns to the host.

### Upper size limit

Microvium is limited to 64kB. More precisely, a Microvium snapshot cannot exceed 64kB, and the VM RAM and ROM sections cannot individually exceed 64kB (excluding the engine itself). The device itself can have any amount of memory -- Microvium will run fine on a desktop machine for example -- but the VM cannot exceed 64kB.

As far as I can tell, mJS has no size limitations.

## Porting and Platform Requirements

mJS comes with built-in support for a number of platforms. It will try to auto-detect or you can configure manually by defining `CS_PLATFORM`. Have a look to see if your platform is supported.

Microvium doesn't support specific platforms but instead provides a single consolidated `port` file that you configure according to your needs, with the default port file being one that "just works" on platforms with a standard C runtime but may be suboptimal on yours.

Something to note is that mJS `mjs_exec_file` and its builtin `load` function require file system access (they use `fopen` etc).

## Standard Library

Both Microvium and mJS claim to *not* have a standard library, but mJS comes with a few additional functions baked in, such as `JSON.parse`. Microvium doesn't really come with any built-in functions.

## Language Features

mJS has a list of "restrictions" on their main page. As far as I can tell, these are very similar to those of Microvium, with the notable exceptions that Microvium supports closures (nested functions and arrow functions) and ES6 modules, while mJS does not.

### Closures

Closures are not just a minor incremental feature. Possibly as much as half of the development time on Microvium was spent implementing closures and doing it "the Microvium way" (making them compact and efficient on small devices). Closures are important:

  - Idiomatic JavaScript code often involves callbacks, which are much less convenient if nested functions are not supported.

  - Closures are more efficient than objects. Access to a local variable (in a closure or not) is O(1) time, and variables consume 2 bytes each. Compared to object properties which are accessed in O(n) time (where `n` is the number of properties) and each property takes many bytes.

  - If your script is a finite state machine (reacting to external events by changing internal state), the code is much neater if you define each state as a function and have a global variable reference the current state (reference the current function to call when events are received).

  - Closures are at the heart of functional-style programming, which has many benefits of its own.

### Modules

Module support in mJS and Microvium is very different, and worth considering when choosing between them.

Microvium supports [ES6 modules](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Modules), with the `import` and `export` syntax. These do not incur any runtime overhead on the device -- the modules are loaded and linked at compile time.

mJS does not have ES6 modules. It has a built-in function called `load` which the JS script can call, to which you pass a filename argument and reads the file and evaluates the script. The global variables of the script become part of the global variables of the caller -- there is no module separation like there is in ES6 modules.

`load` is a runtime operation. Your device needs to support `fopen` and `fread` for mJS's `load` to work, and loading incurs runtime overhead while it reads and parses the file.

If you want ES6 modules, then Microvium is better. If you want runtime script evaluation, then mJS is better.

## Parser/compiler

The compiler for mJS is written in C and compiled into the project.

Microvium's compiler is written in TypeScript and is completely separate.

If you need to be able to run the parser at runtime, then mJS is the only way to go.

On the other hand, if you don't need the parser at runtime, it's more efficient to pre-compile bytecode and send the bytecode to the device. I think this is more streamlined in Microvium than mJS since this is the only way to do it in Microvium.

## Ease of use

### Engine integration

The Microvium engine is deployed as a single `microvium.c` file with a single `microvium.h` header. I think the same is true for mJS with `mjs.h` and `mjs.c`, but I don't see the documentation stating that.

### Documentation

Microvium has a [Getting Started Guide](getting-started.md) which details the whole process from start to finish of how to get a JS script running in your C program. The `getting-started.md` guide is part of the regression test suite for Microvium (the test harness literally copies the snippets of code out of the markdown file and runs them) to make sure that what it says will work will actually work.

As far as have found, there is no equivalent getting-started documentation for mJS. There is a fair amount of information in the readme, but no step-by-step instructions on what to do to get something working, and the details of it are unclear to me.

Microvium and mJS both seem to document their API in the header file (`microvium.h` and `mjs.h` respectively).

## Snapshotting

Snapshotting -- the ability to capture the state of the VM to a file and resume it later or somewhere else -- is baked into the heart of Microvium. There is no equivalent in mJS. If snapshotting is something useful or important to your application, then go with Microvium. It could be used in a variety of ways:

  - Occasionally saving the state of a VM to persistent storage to be robust against power failures or persistent over reboots.

  - Interacting a VM on a server before downloading it to a device (e.g. calling functions in the VM to set up its initial state).

## Compile-time code

In Microvium, you can write compile-time code alongside runtime code (this is really also an effect of the snapshotting feature), allowing you to pre-run the initialization code before the script ever reaches the device. This has 2 effects:

  1. When the script runs on the device, it's already in an initialized state and so there is no boot-up time -- the "cold start" time of a Microvium VM is very fast. This is especially relevant if the script needs to generate any lookup tables or other compute-expensive operations -- these operations will run at compile time instead of runtime.

  2. The initialization code may access other project files on the development machine or build server, allowing it to do things like reading dependent configuration files or writing code-generated files to be used in other places.


## C Interrop (FFI)

mJS makes a point of saying that it requires "no glue code". As long as your C function has a signature that's one of a set of pre-supported signatures, you can use syntax like `ffi('double floor(double)')` to get a reference to the C function.

Microvium does not have this, but Microvium's snapshotting feature means that you could write a similar `ffi` library yourself in JavaScript (and maybe this will be built-in in future). The reason this is possible is because the top-level Microvium code has access to the host on the compiler's machine, so the JavaScript code can code-generate glue code at compile time and then still use the returned references at runtime (see [concepts.md](C:\Projects\microvium\doc\concepts.md)).

This is more powerful than mJS's FFI because it can really work with arbitrary C signatures, and it can be customized more easily (e.g. code-generating logging and metrics at the FFI boundary). However, it is of course a "do-it-yourself" exercise at this point, so mJS is better out-of-the-box in this regard.

Note however that mJS supports passing object and function values across the FFI boundary, whereas Microvium does not.


## Maturity and Active Development

I don't see any development on mJS in the last 5 years, while Microvium is still under active development and getting new features and bug fixes.

On the flip side, Microvium is new on the block and may not be as stable initially than mJS. If you use Microvium, please report any issues on the [github issues page](https://github.com/coder-mike/microvium/issues).

## License

Microvium is currently licensed under the MIT license, while mJS is under GPLv2. Microvium is currently free for commercial use, while mJS is not.

# Conclusion and Summary

  - Microvium is well suited to smaller devices. It has a smaller footprint in both RAM and ROM but also an upper limit of 64kB (of VM size). If your scripts may exceed 64kB of RAM or ROM, you may need to switch to an engine like mJS instead. Bear in mind though that the equivalent JS code could potentially consume many times as much RAM when running mJS, so a 64kB Microvium VM may consume 200+ kB if run on mJS.

  - Microvium has a number of features that mJS doesn't have: closures (nested functions), ES6 modules, and snapshotting.

  - mJS has a number of builtin functions that Microvium doesn't have - most notably `print`, `ffi`, `s2o`, `JSON.stringify`, `JSON.parse` and `Object.create`

  - Microvium only runs the parser at compile time, while mJS has the parser available at compile time and runtime.

  - The mJS FFI layer may be quicker to get started on.

  - It may be easier to get started with the documentation in Microvium

  - Microvium is under active development and getting new features and fixes over time. mJS is more stable and has not had new development in many years.

