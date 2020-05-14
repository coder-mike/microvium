# Getting Started

Note: even if you only intend to use Microvium on MCUs (microcontrollers), it will help to follow this guide all the way through, since the concepts in Node.js and MCUs are similar.

The full source code for this guide is available at [./test/getting-started/code](../test/getting-started/code).

## Install Node.js

Install [Node.js](https://nodejs.org/en/download/).

## Install the Microvium CLI

Run the following command to install the Microvium CLI tool:

```sh
npm install -g microvium
```

To check that the install worked, run a simple script:

```sh
microvium --no-snapshot --eval "console.log('Hello, World!')"
```

If successful, this should print `"Hello, World!"` to the terminal.

Congratulations! You've just executed your first Microvium script.

The `--eval` argument tells Microvium to _evaluate_ the argument as source text, similar to [Node.js's `--eval` option](https://blog.risingstack.com/mastering-the-node-js-cli-command-line-options/#evalore). The `--no-snapshot` option tells Microvium not to output a snapshot file of the final VM state (more on this later).

Note: the package name is `microvium` on npm, but you can refer to it in the CLI using either the command `microvium` or `mvm` for short.

The CLI provides a default runtime environment for the script, including the `log` function to log to the console.

## Run a script

Create a new script file in your favorite IDE or editor:

<!-- Script 1.hello-world.mvms -->
```js
// script.mvms
console.log('Hello, World!');
```

The file extension `.mvms` is recommended and stands for "Microvium script".

Run the script with the following command:

```sh
mvm script.mvms
```

This runs the script, printing "Hello, World!" to the terminal, and then outputs a snapshot of the final state of the virtual machine to `snapshot.mvm-bc`. The file extension `mvm-bc` stands for "Microvium bytecode", and this file encapsulates all the loaded data and functions within the virtual machine at the time when the script finished running. Later in this introduction, we will see how to use a snapshot.

## Hello World (with a custom Node.js host)

Running a script from the CLI, as we did above, is useful in many cases. But a lot of the time, you may want to run a script with a custom host so that you can provide your own API to the script. Here, we use the word "host" to mean "the application that needs to run a script", or "the system that is being controlled by the script", depending on how the script is intended to be used.

Setting up a custom host in Node.js is easy. Create a new directory for your Node.js project, and run the following command in the directory to install Microvium as a package dependency:

```sh
npm install microvium
```

Then create a new Node.js source file called `host.js` (or any name of your choice) with the following content:

<!-- Script 2.with-custom-host.js -->
```js
// host.js
const Microvium = require('microvium');

const vm = Microvium.create();

// Create a "print" function in the global scope that refers to this lambda function in the host
vm.globalThis.print = s => console.log(s);

// Run some module source code
vm.evaluateModule({ sourceText: 'print("Hello, World!");' }); // Prints "Hello, World!" to the console
```

Run the Node.js host file with the following command:

```sh
node host.js
```

This starts a Node.js application which in turn runs the Microvium script. The advantage of doing this instead of using the Microvium CLI is to provide a custom API to the script, using the power of Node.js to implement it. In this example, the API exposed to the script has the function `print` (but not `log` or anything else).

The custom API can be used to facilitate preloading of necessary dependencies and data within the Microvium script itself, while running in a context that has access to database and file resources.

## Making a Snapshot with the CLI

A foundational principle in Microvium is the ability to the snapshot the state of the virtual machine so that it can be restored and resumed later in another environment.

The Microvium implementation for MCUs has _no ability to parse source text_, since it is designed particularly for small MCUs with only a few kB of RAM or ROM, and no space to store source text or parsers, nor processing power to perform the parsing at runtime. But the desktop Microvium implementation has full text parsing ability.

The way to get a script onto a microcontroller is to first run virtual machine on a desktop computer (or backend build server, etc), where it has access to the script source text and other resources it may need to pre-load, and then to snapshot the VM after it has finished loading. The snapshot can subsequently be copied to the target device, where it can resume execution where it left off.

So, let's create a snapshot.

First, create a script file with the following content:

<!-- Script 3.making-a-snapshot.mvms -->
```js
// script.mvms
function sayHello() {
  console.log('Hello, World!');
}
vmExport(1234, sayHello);
```

Then, run this script with the following commend:

```sh
mvm script.mvms
```

When this script runs, the script invokes `vmExport`, which registers that the `sayHello` function value within the virtual machine can be _found_ by the host using the numeric identifier `1234` in this case. This allows a host to later call the function.

Note that the numeric export identifers must be integers in the range 0-65535 (i.e. unsigned 16-bit integers). This is for performance reasons.

## Restoring a Snapshot in Node.js

To call the `sayHello` function, let's create a new Node.js host that resumes the VM from the snapshot:

<!-- Script 4.restoring-a-snapshot.js -->
```js
// host.js
const { Microvium, Snapshot } = require('microvium');

// Load the snapshot from file
const snapshot = Snapshot.fromFileSync('snapshot.mvm-bc');

// Restore the virtual machine from the snapshot
const vm = Microvium.restore(snapshot);

// Locate the function with ID 1234. This is the `sayHello` function that the script exported
const sayHello = vm.resolveExport(1234);

// Call the `sayHello` function in the script
sayHello(); // "Hello, World!"
```

Run the above script with `node host.js` as before.

[Here's an animated diagram](https://youtu.be/8Lct7Ak1taQ) to illustrate the concept of capturing a virtual machine and restoring it later. Note that although the depiction of the VM state and snapshot here only shows the source code, the actual snapshot includes the full working state of the virtual machine.

![https://youtu.be/8Lct7Ak1taQ](./images/snapshot.gif)


Note that the script and the host need to agree on the ID `1234` as a way to identify the `sayHello` function as part of the script's API.

## Restoring a Snapshot in C

This section will take you through creating the above host in C instead of Node.js. The details of this may vary depending on the compiler you're using. If you're targeting an MCU, you may want to incorporate these changes directly into your existing firmware project, which will require some sensible adaptation of these instructions.

### Step 1: Create a project

Create a new, empty directory for this project.

### Step 2: Add the Microvium source files

Copy the Microvium source files from the [./dist-c](../dist-c) directory of the microvium github repository into your C project. These should be in their own folder and structured in such a way that you can paste over them at any time when there are updates to Microvium for bug fixes and new features. If you need to make any changes to the Microvium source files, consider submitting a bug report or feature request [on GitHub](https://github.com/coder-mike/microvium/issues). This includes the following files:

  - `microvium.c`: the source code for the microvium engine, depending only on C standard library dependencies and the port file (discussed below)
  - `microvium.h`: the microvium header file that your C project will include so that it can interact with the microvium engine.

### Step 3: Create a port file

Microvium is written in such a way that it should be portable to many different architectures and scenarios. One way it achieves this, is by accessing platform-specific features through a _port file_. This is a header file which `microvium.c` `#include`s but which _you_ write for your specific project. Microvium tries to `#include` it using the exact name `microvium_port.h` so you need to create the file with exactly this name and have it accessible in one of the project include directories.

Luckily, you don't need to write the port file from scratch. An example port file is accessible at [./dist-c/microvium_port_example.h](../dist-c/microvium_port_example.h), which will suffice for most desktop environments and thus work for this tutorial.

Copy the file [microvium_port_example.h](../dist-c/microvium_port_example.h) into the root of your project directory and rename it to `microvium_port.h`.

### Step 4: Some source code for your project

Now we're set up to have some project code that actually uses Microvium. Create a C file called `main.c` (or whatever you choose to call it) with [the following code](../test/getting-started/code/5.restoring-a-snapshot-in-c.c):

<!-- Script 5.restoring-a-snapshot-in-c.c -->
```c
// main.c
#include <stdlib.h>
#include <stdio.h>
#include <assert.h>

#include "microvium.h"

// Function imported from host (this file) for the VM to call
#define IMPORT_PRINT 0xFFFE

// Function exported by VM to for the host (this file) to call
const mvm_VMExportID SAY_HELLO = 1234;

mvm_TeError resolveImport(mvm_HostFunctionID id, void*, mvm_TfHostFunction* out);

int main() {
  mvm_TeError err;
  mvm_VM* vm;
  uint8_t* snapshot;
  mvm_Value sayHello;
  mvm_Value result;
  FILE* snapshotFile;
  long snapshotSize;

  // Read the bytecode from file
  snapshotFile = fopen("snapshot.mvm-bc", "rb");
  fseek(snapshotFile, 0L, SEEK_END);
  snapshotSize = ftell(snapshotFile);
  rewind(snapshotFile);
  snapshot = (uint8_t*)malloc(snapshotSize);
  fread(snapshot, 1, snapshotSize, snapshotFile);
  fclose(snapshotFile);

  // Restore the VM from the snapshot
  err = mvm_restore(&vm, snapshot, snapshotSize, NULL, resolveImport);
  if (err != MVM_E_SUCCESS) return err;

  // Find the "sayHello" function exported by the VM
  err = mvm_resolveExports(vm, &SAY_HELLO, &sayHello, 1);
  if (err != MVM_E_SUCCESS) return err;

  // Call "sayHello"
  err = mvm_call(vm, sayHello, &result, NULL, 0);
  if (err != MVM_E_SUCCESS) return err;

  return 0;
}

mvm_TeError print(mvm_VM* vm, mvm_HostFunctionID funcID, mvm_Value* result, mvm_Value* args, uint8_t argCount) {
  assert(argCount == 1);
  printf("%s\n", mvm_toStringUtf8(vm, args[0], NULL));
  return MVM_E_SUCCESS;
}

mvm_TeError resolveImport(mvm_HostFunctionID funcID, void* context, mvm_TfHostFunction* out) {
  switch (funcID) {
    case IMPORT_PRINT: *out = print; break;
    default: return MVM_E_UNRESOLVED_IMPORT;
  }
  return MVM_E_SUCCESS;
}
```

Compile the project with your favorite compiler and run the output. It should print `"Hello, World!"`.
