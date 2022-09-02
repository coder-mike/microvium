# Microvium

[![License](https://img.shields.io/badge/license-MIT-green.svg)](./LICENSE)

Microvium is a tiny JavaScript engine ([less than 16kB compiled size](./doc/native-host/memory-usage.md)) for microcontrollers for running a small but useful subset of the JavaScript language. The runtime engine is portable C code and easy to integrate.

Microvium takes the unique approach partially running the JS code at build time and deploying a snapshot, which leads to a number of advantages over other embedded JavaScript engines. See [concepts.md](./doc/concepts.md).

Take a look at [my blog (coder-mike.com)](https://coder-mike.com/behind-microvium/) and [Twitter account (@microvium)](https://twitter.com/microvium) if you're interested in some of the behind-the-scenes thought processes and design decisions, and to stay updated with new developments.

See also [microvium.com](https://microvium.com/) where an installer can be downloaded (for Windows only, at this time, and this is a bit out of date -- but contact me if you want the updated version).

## Install and Get Started

Check out the [Getting Started](./doc/getting-started.md) tutorial which **explains the concepts**, **gives some examples**, and shows how to get set up.

## Features

See also [the set of supported language features](./doc/supported-language.md).

  - Run high-level scripts on an MCU (bare metal or RTOS).
  - The runtime engine is implemented in pure C and doesn't use any I/O functions such as `fopen` or `printf`.
  - Run the same script code on small microcontrollers and desktop-class machines (ideal for IoT applications with shared logic between device and server) -- the runtime engine is available as a C unit and as a node.js library.
  - Run JavaScript on very small devices, requiring less than 16 kB ROM and 64 B of idle RAM depending on the platform and enabled features (for more details, [see here](./doc/native-host/memory-usage.md)).
  - Script code is completely sand-boxed and isolated for security and safety.

There are a few similar alternatives floating around but Microvium takes a unique approach (see [Alternatives](./doc/alternatives.md)).

## Limitations

A Microvium VM cannot exceed 64 kB of ROM and/or RAM.

There is no standard library and only a [subset of JavaScript](./doc/supported-language.md) is currently supported.

## Usage

Microvium can be used in 3 ways:

  1. `npm install -g microvium` globally will install a CLI that runs microvium scripts (and by default produces a snapshot of the final state, in case you want to deploy it)

  2. `npm install microvium` will install Microvium as an npm library with TypeScript definitions. This is useful if you want to run Microvium on a custom node.js host and control the snapshotting and host API yourself.

  3. Integrate `microvium.c` into your C or C++ project to resume execution of a snapshot.

See [Getting Started](./doc/getting-started.md) which walks you through all 3 of these.

## Docs

  - [Getting Started](./doc/getting-started.md)
  - [Concepts](./doc/concepts.md)
  - [Contribute](./doc/contribute.md)

## Contributing

Check out [./doc/contribute.md](./doc/contribute.md).
