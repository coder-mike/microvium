# Concepts

MicroVM consists of two engines:

 1. A *compact* engine to run script code on a microcontroller
 2. A *comprehensive* engine to run script desktop

These two engines come with different tradeoffs and a typical workflow will use both engines:

### Compact Engine

This engine is implemented in portable C code, designed to be compiled into a larger native project such as firmware on a microcontroller.

Features and limitations of the compact engine:

 - Designed for performance and memory efficiency
 - The engine implementation is small
 - Only supports address spaces up to 16kB (a virtual machine cannot allocate more than 16kB of RAM or ROM)
 - The state of a VM running on the compact engine cannot be snapshotted to a file
 - The engine can load an existing snapshot (saved by the *comprehensive engine*)
 - Cannot load modules or parse source text

### Comprehensive Engine

The Comprehensive Engine is designed to run on a desktop-class machine, such as a build machine or server environment. The main features of the Comprehensive Engine over the Compact Engine are:

 1. The ability to parse source text and import modules
 2. The ability to capture snapshots to file. These snapshots can then later be resumed on the compact engine (or another comprehensive engine).

![./doc/images/comprehensive-engine.svg](./doc/images/comprehensive-engine.svg)

Other things that make Comprehensive Engine different from the Compact Engine:

 - Implemented in JavaScript and designed to run on node.js, not an embedded device.
 - The host can give the VM access to desktop-specific APIs, such as the file system and databases.

A typical workflow will use the Comprehensive Engine to execute the source text as far as is required to import dependencies and perform initialization, and then download a snapshot of this VM to the target MCU device to be resumed on the compact VM.

A snapshot is a compact binary representation of the state (code and data) of a virtual machine at a single point in time.
