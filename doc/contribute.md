# Contributing

Contact me, [Mike](mailto:mike@coder-mike.com), if you want to join the development team.

Note: This project requires [cmake](https://cmake.org) to be installed and on the PATH, and requires that `node.js` is installed with support for compilation of native modules (for me, this was a flag on installation).

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

