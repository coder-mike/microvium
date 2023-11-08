# Microvium Reference Documentation

This documentation is a work-in-progress. Please request anything you would like to have added to this documentation.

## Terminology

- **Host** - Refers to the code which embeds the VM, such as the microcontroller device, Microvium compiler CLI, browser, or node.js (the latter two using [@microvium/runtime](https://www.npmjs.com/package/@microvium/runtime)).

- **Guest** - The JavaScript code being executed by the Microvium virtual machine.

- [**Ephemerals**](#ephemerals) - host objects or functions which are only available at compile time.


## Compiler CLI


### Install

Install npm on your system (this comes bundled when you install [node.js](https://nodejs.org/en/download)). Then run the following command to install the `microvium` compiler CLI.

```
npm install -g microvium
```


### Usage

To compile a script, pass it to the CLI. For example:

```sh
microvium my-script.js
```

In Microvium, compilation is actually the process of running the script at compile time and snapshotting its final state to a binary file to be deployed to the runtime environment. See [Concepts](./concepts.md).

Full options can be found with `microvium --help`, which shows the following:

```
usage: microvium [-h] [-v] [-e "script"] [-s FILENAME] [--no-snapshot]
                 [--map-file FILENAME] [--output-disassembly] [--generate-lib]
                 [--generate-port] [--output-bytes] [--output-il]
                 [--output-source-map]
                 [input [input ...]]

Microvium - A compact, embeddable scripting engine for microcontrollers for
executing small scripts written in a subset of JavaScript.

Positional arguments:
  input                 Input file to run

Optional arguments:
  -h, --help            Show this help message and exit.
  -v, --version         Show program's version number and exit.
  -e "script", --eval "script"
                        Evaluate the given script text and output snapshot
  -s FILENAME, --snapshot FILENAME
                        Snapshot filename to use for output
  --no-snapshot         Do not output a snapshot file
  --map-file FILENAME   Generate map file (human-readable disassembly of
                        snapshot bytecode)
  --output-disassembly  Output disassembly of snapshot bytecode file
  --generate-lib        Interactively generate C runtime engine library
  --generate-port       Interactively generate microvium port file
                        (microvium_port.h)
  --output-bytes        Output bytecode as comma-separated hex, suitable for
                        use in a C constant
  --output-il           Output debug IL for each module
  --output-source-map   Output file that maps bytecode offsets to source code
                        locations
```


## Ephemerals

I've used the term *ephemerals* to refer to object references from the guest to the host which are not associated with an import identifier. These object references are not preserved when snapshotting the VM. Trying to use one of these references from a restored snapshot will result in the runtime error `MVM_E_DETACHED_EPHEMERAL`.

Currently only the compile-time engine supports live ephemerals, so another way to think of ephemerals is as references to compile-time host objects which are unavailable at runtime.


## Builtin Globals

These globals are baked into the engine:

- `Infinity`
- `NaN`
- `undefined`
- `Number.isNaN`

These globals are available only at compile-time (they are [ephemerals](#ephemerals)):

- `console.log`
- `vmImport`
- `vmExport`
- `JSON.parse`
- `JSON.stringify`
- [`globalThis`](#globalthis)


### `globalThis`

`globalThis` is a host object at compile time which is a Proxy for the global variables of the VM. It is an [ephemeral](#ephemerals), meaning that it cannot be used at runtime.

`globalThis` can be used at compile-time to add variables to the global scope, which makes them available to all modules. For example:

```js
globalThis.myVariable = "some value";

// Now myVariable can be used in any module
console.log(myVariable);
```

### `vmImport(id, defaultValue?)`

Compile-time only. See [ephemeral](#ephemerals).

A guest can call `vmImport` at compile time to get a reference to the corresponding host function identified by the given `id`. On each host on which the guest is restored, the reference will be reconnected to whatever function has the associated ID in that host. When a snapshot is restored at runtime, all the previously-imported functions will be resolved in the new runtime host.

IDs must be integers in the range `0` to `65535`.

The `defaultValue` argument is optional and denotes a fallback value to use if the current host does not provide the specified import. Currently only the compile-time host uses the `defaultValue`. When restoring a snapshot on the runtime host, all imports must be satisfied or there will be an `MVM_E_UNRESOLVED_IMPORT` error.

The `defaultValue` can be used to provide a compile-time implementation of a function that you only expect to be exposed by the runtime host. For example:

```js
const ephemeralConsoleLog = console.log;
console.log = vmImport(27, ephemeralConsoleLog);
```

The default `console.log` is [ephemeral](#ephemerals) and so won't work at runtime. You can bind it to a runtime import using `vmImport`, and optionally supply the default value such as the original ephemeral `console.log` to use when the function is called at compile time.

It's up to the hosts to provide a stable implementation of the imported function across multiple environments.


## String Operations

Strings support the following operations:

- `s.length` gives the string length
- `s1 + s2` concatenates strings
- `s[n]` gets the nth UTF16 code-point, subject to unicode support (see corresponding section below)
- `MicroviumCompileTime.defineStringMethod` defines a method that can be called on strings.
- `s.myMethod()` accesses a method on the string prototype, subject to the existence of the string prototype. See corresponding section below.
- Template strings can be used but not with custom tags

### Unicode Support

The compile-time engine has full unicode support and uses UTF16 internally to store strings. The runtime (WIP)

### MicroviumCompileTime.defineStringMethod

WIP: I haven't actually decided the final design here.

For memory efficiency, the string prototype object is not included by default, since it would occupy memory even for people who don't use it.

To create the string prototype object, simply access it at compile time. It is created lazily when you access it and then will persist to runtime. For example:

```js
// At compile-time
MicroviumCompileTime.defineStringMethod('myMethod', s => s.length * 10);

function atRuntime() {
  const s = 'abc';
  s.myMethod(); // Returns 30
}
```

String prototype methods are not invoked in a spec-compliant way, because the `this` value will be the string primitive itself.