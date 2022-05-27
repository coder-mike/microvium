# Microvium Concepts

Microvium is designed fundamentally around the concept of _snapshotting_, which here is the ability to take the running state of a JavaScript virtual machine (VM), including all of the loaded modules, functions, variables and object states, and persist it as data (for example, in a file, database, or flash storage on a microcontroller), and then to _restore_ the running VM from the snapshot at a later time to continue executing it, possibly in a completely different environment.

A special case of this general idea is the ability to start running a Microvium virtual machine on a desktop-class computer (e.g. development machine or backend server), where it has access to more advanced features, and then transfer an image (snapshot) of the running virtual machine to a target microcontroller where it is resumed and the firmware can access its exported API.

![./images/snapshot2.gif](./images/snapshot2.gif)

## Why Snapshotting?

Snapshotting is not just a cool feature of Microvium, it is foundational to the way you use Microvium. While the virtual machine is running in a desktop-class environment, it has access to features that aren't available on a Microcontroller, such as:

  1. The ability to _import source code_ files and modules.

  2. Access to host-provided resources which may include database and filesystem access (where appropriate and granted). For example, to load configuration data.

  3. The ability to programmatically code-generate or parse any useful supporting files, such C API headers, etc.

This approach has a few major advantages over alternative approaches:

  - **Runtime performance**: the program has already run through its initialization stages by the time it gets snapshotted, so when it starts executing for the first time on the MCU target, the VM can pick up immediately where it left off at compile time rather than wasting time on startup initialization.

  - **Ease of use**: compared to the way you use other bundlers and compilers, the snapshotting paradigm requires no external configuration files to tell it what to compile. See [Snapshotting vs Bundling](https://coder-mike.com/2020/05/snapshotting-vs-bundling/).

  - **Configuration**: by really running the script at compile time, the compile-time host is allowed to call any methods in the JS app, such as to inject configuration parameters.

  - **FFI**: by really running the script at compile time, the script, if permitted, may write output files as a side effect of the compilation process, which may be used to auto-generate FFI "glue code".

For a specific example of snapshotting in action, see the [Getting Started](./getting-started.md) guide.

## There are actually two implementations of the Microvium Engine

  1. One implementation in portable C code, optimized for embedded MCU targets, running very [lightweight on memory](./native-host/memory-usage.md) and with a small program footprint for particularly constrained devices. This is the version of Microvium you get when you integrate `microvium.c` [into your project](./getting-started.md#restoring-a-snapshot-in-c).

  2. The other implementation is designed to run on desktop-like environments, providing access to advanced features such as source code parsing and integration with existing Node.js modules. This engine is implemented on top of Node.js and [offers a CLI](./getting-started.md#install-the-microvium-cli) for executing Microvium scripts, as well as [an npm library](./getting-started.md#hello-world-with-a-custom-nodejs-host) for running Microvium scripts within an existing Node.js application or in situations where you want to provide a host.
