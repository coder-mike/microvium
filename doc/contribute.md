# Contributing

Contact me, [Mike](mailto:mike@coder-mike.com), if you want to join the development team.

Note: This project requires [cmake](https://cmake.org) to be installed and on the PATH.

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
