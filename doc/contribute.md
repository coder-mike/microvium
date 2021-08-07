# Contributing

Contact me, [Mike](mailto:mike@coder-mike.com), if you want to join the development team (which is currently just me!).

PRs are welcome, but for anything substantial, talk to me before you start working on it so we're in agreement about the best approach. There is a list of things that need doing in [./todo](../todo).

## Spec compliance

Microvium intentionally does not conform completely to the TC39 [ECMAScript-262 spec](https://www.ecma-international.org/publications-and-standards/standards/ecma-262/) at this time. The intention is to first support a "useful subset" of the ECMAScript spec, and then to implement a spec-compliant compiler as another transpiration layer on top of that down the line (if Microvium becomes successful enough to warrant the work it will require).

The rule-of-thumb for what I want to support in the base compiler is "simple scripts in Microvium should have the same behavior when run in V8".

## Prerequisites

This project requires [cmake](https://cmake.org) to be installed and on the PATH, and requires that `node.js` is installed with support for compilation of native modules (for me, this was a flag on installation).

## Development Workflow

A suggested pre-commit git hook is as follows:

```sh
#!/bin/sh
set -e
npm run check-for-wip
npm test
```

Then if you have anything you need to remember to change before committing, put a `// WIP` comment on it, and the hook will catch it if you accidentally forget about it. The `check-for-wip` script also catches cases where `testOnly: true` or `test.only` has accidentally been left on a specific test case.

Note: if you add a debug watch to evaluate `TraceFile.flushAll`, then the `TraceFile` outputs will all be up to date every time you breakpoint.

The tests in [test/end-to-end/tests](../test/end-to-end/tests) are the most comprehensive and are where the majority of new features should be tested. The directory consists of a number of self-testing microvium scripts, with metadata in a header comment to control the testing framework (TODO: document this). These tests run on both the JS- and C-implementations of the VM, so they allow testing both at once.

The project is structured best for dividing work into small changes that go from tests-passing to tests-still-passing. If you make a make a change that breaks the tests, it's not just the commit hook that will get in your way, but the fact that all the intermediate and auto-generated files will show up in your git diff.

## VS Code

I use VS Code for development.

`tasks.json` has been set up such that `ctrl+shift+B` will run the TSC compiler continuously in the background. This is useful if working on the TypeScript side of things but will not automatically build the C++ side of things.

`launch.json` has been set up such that the `Mocha All` launch profile will run the mocha tests. The mocha tests use `ts-node/register` so they run directly from the TypeScript files rather than the JS output. There is also a `no-ts.mocharc.json` which can used from the `Mocha All No-TS` launch profile, which will debug the JS output files. The experience should be similar. The latter might be faster because there's no compilation involved (and can be used if you're running the background build task with `ctrl+shift+B`).

You can debug a subset of the unit tests by temporarily adding something like `"-g", "scope-analysis"` (if you're debugging `scope-analysis` for example) to the `args` of the chosen launch configuration. For the `end-to-end` tests, you can also add `testOnly: true` or `skip: true` to the test input file yaml header to control which tests mocha will run.

## Project Structure

A subset of the directory tree is as follows, drawing attention to the most important files:

```
  cli.ts                      Entry point when Microvium is run as a CLI
  lib.ts                      Entry point when Microvium is imported as an npm module
  lib/                        The meat of the Microvium compiler and compile-time VM in TypeScript
    src-to-il.ts              First phase of compilation
    il.ts                     Specification of internal IL format
    virtual-machine.ts        Compile-time VM
    encode-snapshot.ts        Final stage of the Microvium compiler, which outputs bytecode from IL
    native-vm.ts              TypeScript wrapper around the native C virtual machine
  native-vm-bindings/         [N-API](https://nodejs.org/api/n-api.html) bindings for TS code to call the C VM
  test/                       Regression tests that exercise both the TS and C code.
    getting-started/          Tests for the [getting-started](./getting-started.md) tutorial.
    end-to-end/tests/         Self-testing Microvium scripts. This is where the majority of test coverage is.
  native-vm/                  Source code for embedded VM implementation
    microvium.c               _The_ implementation of the embedded VM
    microvium.h               The _public_ header for `#including` Microvium. Carefully curated and documented!
    microvium_port_example.h  A _public_ example port file for configuring Microvium for a target environment
```

As mentioned elsewhere, Microvium has two implementations of the VM. The [TS implementation](../lib/virtual-machine.ts) is strictly "compile time" (i.e. before the first snapshot), and executes high level IL (not bytecode). The [C implementation] (../native-vm/microvium.c) is the "runtime" VM (after the first snapshot). The C implementation is available to JS/TS by means of [N-API](https://nodejs.org/api/n-api.html) bindings and is used by `Microvium.restore` to run a VM from bytecode. This is also used by the unit tests since they can run the same tests automatically on both VM implementations.

## Debugging Native Code

I'm debugging the C/C++ code in Windows in Visual Studio Community Edition (if the version matters, I'm using Visual Studio 2019, version 16.7, with "Desktop development with C++" enabled during install).

### Debug Node.js Native Bindings

To debug the node native bindings:

  1. Open the corresponding VS project file in the `build` dir. E.g. `./build/binding.sln`.

  2. Run the unit tests in the node.js debugger in VSCode, with a breakpoint before the binding code is used

  3. In VS use "attach to process" to attach to the stopped node process (I just filter the processes on "node" and select all of them, and it seems to figure it out).

  4. Then set a breakpoint in VS on the particular binding code you care about.

  5. Then continue execution in VSCode, and the breakpoint in VS should get hit, and you can step through.

Note that the bindings need to be built with the `--debug` flag.

There is a VS project under `./native-vm-vs-project` which compiles and runs the VS (`node-gyp build --debug`). This flag is used by the npm scripts `build`, `rebuild`, and `test`.

Probably, there should not be bindings in the `./prebuilds` directory. I don't know what [node-gyp-build](https://github.com/prebuild/node-gyp-build) will do if there are prebuilds and debug builds both available.


### Debug the Native VM

The above process for debugging the bindings is a bit cumbersome and I try to avoid doing it where possible. For debugging the native VM itself, I run it directly in Visual Studio. There is a VS project under `./native-vm-vs-project` which imports a bytecode file and runs it. Just tweak `project.cpp` so it imports the bytecode file you care about.

### Deployment

See [doc/deployment.md](./deployment.md)


## General Design Philosophy

A major distinguishing characteristic of Microvium is its small footprint on embedded devices, so any change that adds to the footprint is heavily scrutinized, and every byte is counted. This particularly applies to RAM usage, but also the engine size and bytecode size. When adding new language features, it's better to have the compiler lower these features to the existing IL where possible.


## Coverage Markers

In the [C implementation](../native-vm/microvium.c), you'll see macro calls like

```c
CODE_COVERAGE(230); // Hit
```

These macros conditionally compile in code coverage analysis for the unit tests. These should be placed on basically every code path that can sensibly be followed. You can add one without an ID as follows:

```c
CODE_COVERAGE_UNTESTED();
```

Then run the script:

```sh
npm run update-coverage-markers
```

This scans the C code for these coverage markers (they must appear on their own line) and updates them with an ID and the hit comment.

When the unit tests run, they automatically update the markers to say whether the marker is hit or not.

There are a few different forms of the marker:

### CODE_COVERAGE(id)

This form will prompt the unit tests to give an error if the marker isn't hit during the unit tests (if it isn't hit, it's considered to be a regression).

### CODE_COVERAGE_UNTESTED(id)

This form will not give an error if it isn't, but will still count towards the coverage statistics. The unit tests will automatically promote this to `CODE_COVERAGE(id)` on a test run where this is hit.

There are some variations on `CODE_COVERAGE_UNTESTED` with similar behavior but intended for different situations: `CODE_COVERAGE_UNIMPLEMENTED` and `CODE_COVERAGE_ERROR_PATH`. These indicate paths that we don't expect to be taken (yet), but specify different reasons, for the sake of getting a clearer view of the codebase (e.g. what's left to test vs what's left to implement or what will likely never be tested).

### TABLE_COVERAGE(indexInTable, tableSize, id))

As described [at the macro declaration](../native-vm/microvium_internals.h#L251), this allows coverage testing to also cover variable value cases.

