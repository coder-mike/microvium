# Microvium

An ultra-compact, embeddable scripting engine for microcontrollers for executing a small subset of the JavaScript language.

I started this project as an alternative to something like [EmbedVM](https://embedvm.com/), for running scripted behavior on small microcontrollers. Microvium is larger than EmbedVM but in return it's much more powerful (see [microvium-vs-embedvm.md](microvium-vs-embedvm.md) for details). See also the [alternatives](#alternatives) section below.

Take a look at [my blog](https://coder-mike.com/behind-microvium/) if you're interested in some of the behind-the-scenes thought processes and design decisions, and to stay updated with new developments. Or for more granular updates, follow me on Twitter at [@microvium](https://twitter.com/microvium).

See also [microvium.com](https://microvium.com/) where an installer can be downloaded (for Windows only, at this time).

## Install and Get Started

Check out the [Getting Started](./doc/getting-started.md) tutorial which **explains the concepts**, **gives some examples**, and shows how to get set up.

## Features

  - Run high-level scripts on an MCU (bare metal or RTOS)
  - Runs JavaScript on very small devices, as small as 1 kB of RAM and 16 kB of ROM (for more details, [see here](./doc/native-host/memory-usage.md)).
  - Run the same script code on small microcontrollers and desktop-class machines (ideal for IoT applications with shared logic between device and server) -- the engine is available as a C unit and as a node.js library.
  - Script code is completely sand-boxed and isolated for security and safety
  - Persist the state of a virtual machine to a database or file and restore it later**
  - Run the scripts on your custom host API for your particular application
  - Execute out of non-addressable ROM (e.g. serial flash)

**There is a separate implementation of the virtual machine for microcontrollers vs desktop-class machines, which support different features. Check out the [Concepts](./doc/concepts.md) page for more detail.

## Limitations

In the current design, a VM cannot exceed 64 kB of combined ROM and RAM usage (excluding the engine itself).

Microvium is heavily optimized for memory usage and portability over speed.

Microvium is optimized for platforms with a 16-bit pointer size. On 32-bit or 64-bit platforms, there is extra overhead in mapping the 16-bit Microvium address space to the larger allocation space. Microvium virtual memory size is capped at 64kB regardless of the platform.

Only a [subset of JavaScript](./doc/supported-language.md) is currently supported, and for supported features there are some deviations from the ECMAScript standard. Microvium at the moment is somewhat like a dynamically-typed variant of C.

The FFI does not yet facilitate the passing of complex structures. Only simple types such as `int`, `double`, `bool`, and `string`.

## Docs

  - [Getting Started](./doc/getting-started.md)
  - [Concepts](./doc/concepts.md)
  - [Contribute](./doc/contribute.md)

## Alternatives

Some alternatives to consider to run scripts on microcontrollers:

  - [EmbedVM](https://embedvm.com) - the most compact scripting engine I've come across. See also [microvium-vs-embedvm.md](microvium-vs-embedvm.md).
  - [Moddable XS](https://github.com/Moddable-OpenSource/moddable) - the most complete JavaScript engine. Moddable are the only company to participate in the TC39 JavaScript language committee alongside Google, Apple, Microsoft, Mozilla and others, deciding the fate of the JS language.
  - [Cesanta mJS](https://github.com/cesanta/mjs) - the most similar to Microvium in their objective to run a subset of ES6 in the smallest space possible.
  - [MicroPython](https://micropython.org/)
  - [Duktape](https://duktape.org/)
  - [Espruino](https://www.espruino.com/)
  - [JerryScript](https://jerryscript.net/)
  - [MuJS](https://mujs.com/)
  - [eLua](http://www.eluaproject.net/)

The different options have different pros and cons. Microvium's key features amongst the crowd are:

  - [Small size and RAM usage](./doc/native-host/memory-usage.md)
  - Easy to [get started](https://microvium.com/getting-started/).
    - No third-party tools need to be installed, no environment variables need to be set up.
    - Runtime engine is a single, self-contained, portable `.c` file
    - No need to clone the Microvium repo or get stuck into its source code (if you're on Windows, just use [the Windows installer](https://microvium.com/download/))
  - [Its snapshotting mechanism](./doc/concepts.md) for pre-compiling the source code before sending it to the device. This is in contrast to solutions which require extra metadata/manifest files to describe which files to compile etc, or to solutions which run a full interpreter on the device at the cost of extra runtime overhead.
  - Out-of-the-box support for ES6 modules (`import` and `export`) so script code can be divided into multiple files.
  - Portability
  - Documentation

## Contributing

Check out [./doc/contribute.md](./doc/contribute.md).
