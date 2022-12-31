# Contributing

Contact me, [Mike](mailto:mike@coder-mike.com), if you want to join the development team (which is currently just me!).

PRs are welcome, but for anything substantial, talk to me before you start working on it so we're in agreement about the best approach. There is a list of things that need doing in [./todo](../todo).

## Get going

Prerequisites:

  - Node and npm, with native modules support enabled at install time
  - [ARM GNU Toolchain](https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/downloads). The build workflow just uses this to check the size of Microvium as compiled for Cortex M0 (see [size-test/build.sh](size-test/build.sh)), so we can see how it creeps up as new features are added.
  - On Windows, Visual Studio (or at least msbuild) is required to compile and debug the node native module. There is also a VS project I use for debugging. The versions are a bit tricky (see later in this doc)
  - Let me know if you land up needing anything else or add it to this doc

Steps:

  - Clone the repo
  - Run `npm install`. This should install dependencies like TypeScript and ts-node locally in the repo.
  - Run `npm build`
  - Run `npm test`

## What needs doing?

See [todo](../todo). Talk to me before doing anything major because I might already have designs or partial progress on some of these things.

## Test and build scripts

Note: the `mocha` tests also exercise the native virtual machine, but not all test scripts will first build the native code.

The tests generate a lot of artifacts that are checked into the repo. These are compared against the `expected` to make sure the tests are passing. If you manually inspect the output and it appears to be what you expect, you can run `npm run approve` to update the expected files to match the output files, so that the tests pass.

There are two workflows I use, depending on whether I'm developing just the TypeScript code or also the native code:

### Just TS code

  1. Run the full build at least once (`npm run build`) to compile the native code.

  2. Run the default build task in VSCode (ctrl+shift+B), which runs typescript continuously in the background (or use the script `npm run build:watch`)

  3. Each time you make a change, run the tests using the script `npm run test:js`. This runs the JS rather than TS code (it does not use ts-node) and so is faster than `npm run test:ts` but requires that you have the build-watch running in the background. Also, error printouts with `npm run test:js` point to the JS file instead of the TS file. You can also run `npx mocha --config=ts.mocharc.json --fgrep=xyz` to run a specific test case.

### Native and TS code

TODO: Document this. Probably the same as above but having to run `build:native` in between each test cycle.


## Spec compliance

Microvium intentionally does not conform completely to the TC39 [ECMAScript-262 spec](https://www.ecma-international.org/publications-and-standards/standards/ecma-262/) at this time. The intention is to first support a "useful subset" of the ECMAScript spec, and then to implement a spec-compliant compiler as another transpiration layer on top of that down the line (if Microvium becomes successful enough to warrant the work it will require).

The rule-of-thumb for what I want to support in the base compiler is "simple scripts in Microvium should have the same behavior when run in V8".

## Prerequisites for windows development

  - [cmake](https://cmake.org) to be installed and on the PATH
  - **Native modules** support for node.js (checked as an option during installation of node.js)
  - Visual Studio with C++ support
    - For me, `cmake` seems to default to Visual Studio 2019 on my machine, so I have that installed. `cmake` is used by the "getting-started" unit tests to automate the build process.
    - I use the latest VS (2022 at the time of this writing) for running and debugging the `native-vm-vs-project`
    - Native module support in node.js automatically installs its own MSBuild for whatever version it needs (so you may land up with 3 versions of MSBuild on your machine)

## Development Workflow

A suggested pre-commit git hook is as follows:

```sh
#!/bin/sh
set -e
npm run check-for-wip
npm test
```

Then if you have anything you need to remember to change before committing, put a `// WIP` comment on it, and the hook will catch it if you accidentally forget about it. The `check-for-wip` script also catches cases where `testOnly: true` or `test.only` has accidentally been left on a specific test case.

Bonus: if you add a debug watch to evaluate `TraceFile.flushAll`, then the `TraceFile` outputs will all be up to date every time you breakpoint.

The tests in [test/end-to-end/tests](../test/end-to-end/tests) are the most comprehensive and are where the majority of new features should be tested. The directory consists of a number of self-testing microvium scripts, with metadata in a header comment to control the testing framework (TODO: document this). These tests run on both the JS- and C-implementations of the VM, so they allow testing both at once.

The project is structured best for dividing work into small changes that go from tests-passing to tests-still-passing. If you make a change that breaks the tests, it's not just the commit hook that will get in your way, but the fact that all the intermediate and auto-generated files will show up in your git diff.

To run just a subset of the unit tests, you can use a command like:

```sh
npm run test:js -- -g scope-analysis
```

### Debugging `VirtualMachine`

When you're stopped on an instruction, you can inspect the current source code position using
`VirtualMachine.currentSourceLocation`.

## VS Code

I use VS Code for development.

`tasks.json` has been set up such that `ctrl+shift+B` will run the TSC compiler continuously in the background. This is useful if working on the TypeScript side of things but will not automatically build the C++ side of things.

`launch.json` has been set up such that the `Mocha All` launch profile will run the mocha tests. The mocha tests run the JS files, not the TS files, so you need to build the TS files beforehand, e.g. by running the background build task with `ctrl+shift+B`.

You can debug a subset of the unit tests by temporarily adding something like `"-g", "scope-analysis"` (if you're debugging `scope-analysis` for example) to the `args` of the chosen launch configuration (Edit: I think the update to use mocharc.json has broken this ability. Can anyone fix it for me?). For the `end-to-end` tests, you can also add `testOnly: true` or `skip: true` to the test input file yaml header to control which tests mocha will run.

Note: debugging the native VM is different. See the section later.

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

I'm debugging the C/C++ code in Windows in Visual Studio Community Edition (if the version matters, I'm using Visual Studio 2019, version 2019 (16.7), with "Desktop development with C++" enabled during install).

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

The above process for debugging the bindings is a bit cumbersome and I try to avoid doing it where possible. For debugging the native VM itself, I run it directly in Visual Studio.

 - There is a VS project under `./native-vm-vs-project` which executes the end-to-end tests (just the native part).
 - Set the variable `runOnlyTest` in `project.cpp` to control which test runs, or set to the empty string to run them all.
 - This assumes that the bytecode has already been compiled, so it's only useful to debug here if you've already run the tests in VS code and seen that they're failing on the native side (by which time, the bytecode artifact is already emitted).

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

