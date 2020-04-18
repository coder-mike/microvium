# Contributing

Contact me, [Mike](mailto:mike@coder-mike.com), if you want to join the development team.

## Development Workflow

A suggested pre-commit git hook is as follows:

```sh
#!/bin/sh
set -e
npm run check-for-wip
npm test
```

Then if you have anything you need to remember to change before committing, put a `// WIP` comment on it, and the hook will catch it if you accidentally forget about it.

Note: if you add a debug watch to evaluate `TraceFile.flushAll`, then the `TraceFile` outputs will all be up to date every time you breakpoint.

## Debugging Native Code

I'm debugging the C/C++ code in Windows in Visual Studio.


### Debug Node.js Native Bindings

To debug the node native bindings:

  1. open the corresponding VS project file in the `build` dir. E.g. `./build/binding.sln`.

  2. Run the unit tests in the node.js debugger in VSCode, with a breakpoint before the binding code is used

  3. In VS use "attach to process" to attach to the stopped node process (I just filter the processes on "node" and select all of them, and it seems to figure it out).

  4. Then set a breakpoint in VS on the particular binding code you care about.

  5. Then continue execution in VSCode, and the breakpoint in VS should get hit, and you can step through.

Note that the bindings need to be built with the `--debug` flag.

There is a VS project under `./native-vm-vs-project` which compiles and runs the VS (`node-gyp build --debug`). This flag is used by the npm scripts `build`, `rebuild`, and `test`.

Probably, there should not be bindings in the `./prebuilds` directory. I don't know what [node-gyp-build](https://github.com/prebuild/node-gyp-build) will do if there are prebuilds and debug builds both available.


### Debug the Native VM

The above process for debugging the bindings is a bit cumbersome and I try to avoid doing it where possible. For debugging the native VM itself, I run it directly in Visual Studio. There is a VS project under `./native-vm-vs-project` which imports a bytecode file and runs it. Just tweak `project.cpp` so it imports the bytecode file you care about.