# Microvium

An ultra-compact, embeddable scripting engine for microcontrollers for executing a small subset of the JavaScript language.

**Note: THIS PROJECT IS pre-ALPHA, but please feel free to try it out and send me any issues you have with it so I can work through the kinks!**

Take a look at [my blog](https://coder-mike.com/behind-microvium/) if you're interested in some of the behind-the-scenes thought processes and design decisions, and to stay updated with new developments.

See also [microvium.com](https://microvium.com/) where an installer can be downloaded (for Windows only).

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

Microvium is optimized for platforms with a 16-bit pointer size. On 32-bit or 64-bit platforms, there is extra overhead in mapping the 16-bit Microvium address space to the larger allocation space.

Only a [subset of JavaScript](./doc/supported-language.md) is currently supported, and for supported features there are some deviations from the ECMAScript standard. Microvium at the moment is somewhat like a dynamically-typed variant of C.

## Docs

  - [Getting Started](./doc/getting-started.md)
  - [Concepts](./doc/concepts.md)
  - [Contribute](./doc/contribute.md)

## Contributing

Check out [./doc/contribute.md](./doc/contribute.md).
