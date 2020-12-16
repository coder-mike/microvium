# Getting Started

## Overview

Before we jump in, I want to explain that a typical use of Microvium will involve running a Microvium script on a desktop machine first, then snapshotting it, downloading the snapshot to a microcontroller target, and finally restoring (resuming) the snapshot on the target. See [concepts.md](concepts.md) for more details.

This guide will lead you through the steps to achieve this, building up to the grand finale of running the snapshot on your target C host. Even if you only intend to use Microvium on MCUs (microcontrollers), it will help to follow this guide all the way through, since the concepts in Node.js and MCUs are similar.

The full source code for this guide is available at [./test/getting-started/code](../test/getting-started/code).

## Step 1: Install Node.js

Install [Node.js](https://nodejs.org/en/download/), the platform on which the Microvium CLI runs.

## Install the Microvium CLI

Run the following terminal command to install the Microvium CLI tool:

```sh
npm install -g microvium
```

To check that the install worked, run a simple script:

```sh
microvium --eval "console.log('Hello, World!')"
```

If successful, this should print `"Hello, World!"` to the terminal. This script is running locally, not on a microcontroller.

Congratulations! You've just executed your first Microvium script.

The `--eval` argument tells Microvium to _evaluate_ the argument as source text, similar to [Node.js's `--eval` option](https://blog.risingstack.com/mastering-the-node-js-cli-command-line-options/#evalore).

The CLI provides a default runtime environment for the script, including the `console.log` function used above.

## Run a script

Create a new script file in your favorite IDE or editor:

<!-- Script 1.hello-world.mvm.js -->
```js
// script.mvm.js
console.log('Hello, World!');
```

The file extension `.mvm.js` is recommended and is short for "Microvium JavaScript". The `mvm` part is optional but useful when mixing code for a node host and an embedded host in the same probject.

Run the script with the following command:

```sh
microvium script.mvm.js
```

This runs the script, printing "Hello, World!" to the terminal, and then outputs a snapshot of the final state of the virtual machine to `script.mvm-bc`. The file extension `mvm-bc` stands for "Microvium bytecode", and this file encapsulates all the loaded data and functions within the virtual machine at the time when the script finished running. Later in this introduction, we will see how to use a snapshot.

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

This starts a Node.js application which in turn runs the Microvium script. The advantage of doing this instead of using the Microvium CLI is to provide a custom API to the script, using the power of Node.js to implement it. In this example, the API exposed to the script has the function `print` (but not `console.log` or anything else, because we didn't provide it).


## Making a Snapshot with the CLI

A foundational principle in Microvium is the ability to the snapshot the state of the virtual machine so that it can be restored and resumed later in another environment.

The Microvium engine implementation for MCUs has _no ability to parse source text_, since it is designed particularly for small MCUs with only a few kB of RAM and ROM, and no space to store source text or parsers, nor processing power to perform the parsing at runtime. But the desktop Microvium implementation has full text parsing ability.

The way to get a script onto a microcontroller is to first run virtual machine on a desktop computer (or backend build server, etc), where it has access to the script source text and other resources it may need to pre-load, and then to snapshot the VM after it has finished loading. The snapshot can subsequently be copied to the target device, where it can resume execution where it left off.

So, let's create a snapshot.

First, create a script file with the following content:

<!-- Script script.mvm.js -->
```js
// script.mvm.js
console.log = vmImport(1);
function sayHello() {
  console.log('Hello, World!');
}
vmExport(1234, sayHello);
```

Then, run the above script with the following command:

```sh
microvium script.mvm.js
```

When this script runs, the script invokes `vmExport`, which registers that the `sayHello` function value within the virtual machine can be _found_ by the host using the numeric identifier `1234` in this case. This allows a host to later call the function.

Note that the numeric export identifers must be integers in the range 0-65535 (i.e. unsigned 16-bit integers).

## Restoring a Snapshot in Node.js

To call the `sayHello` function, let's create a new Node.js host that resumes the VM from the snapshot:

<!-- Script 4.restoring-a-snapshot.js -->
```js
// host.js
const { Microvium, Snapshot } = require('microvium');

// Load the snapshot from file
const snapshot = Snapshot.fromFileSync('script.mvm-bc');

// Restore the virtual machine from the snapshot
const vm = Microvium.restore(snapshot, {
  [1]: console.log
});

// Locate the function with ID 1234. This is the `sayHello` function that the script exported
const sayHello = vm.resolveExport(1234);

// Call the `sayHello` function in the script
sayHello(); // "Hello, World!"
```

Run the above script with `node host.js` as before.

The following animated diagram illustrates the concept of capturing a virtual machine and restoring it later. Note that although the depiction of the VM state and snapshot here only shows the source code, the actual snapshot includes the full working state of the virtual machine.

![https://youtu.be/8Lct7Ak1taQ](./images/snapshot.gif)
([https://youtu.be/8Lct7Ak1taQ](https://youtu.be/8Lct7Ak1taQ))

Note that the script and the host need to agree on the ID `1234` as a way to identify the `sayHello` function as part of the script's API.

## Restoring a Snapshot in C

This section will take you through creating the above host in C instead of Node.js. The details of this may vary depending on the compiler you're using. If you're targeting an MCU, you may want to incorporate these changes directly into your existing firmware project, which will require some sensible adaptation of these instructions.

If any of this is confusing, please don't hesitate to raise an issue [on GitHub](https://github.com/coder-mike/microvium/issues) -- I want to make this guide as easy to understand as possible, and it will help if people submit their confusion so I can improve on it.

See [here](../test/getting-started/code) for the full example of this source code (including all the examples in the document).

### Step 1: Create a project

Create a new, empty directory for this project.

### Step 2: Add the Microvium source files

Copy the Microvium C source files from the [./dist-c](../dist-c) directory of the Microvium github repository into your C project. This includes the following files:

  - `microvium.c`: the source code for the microvium engine, depending only on the C standard library and the port file (discussed below)
  - `microvium.h`: the microvium header file that your C project will include so that it can interact with the microvium engine.
  - `microvium_port_example.h`: this file is not used by Microvium, but is an example to get started with creating your own port file to adapt microvium to your target architecture (more on this in the next subsection).

You should preferably put the Microvium source files in their own subfolder of your project and structured in such a way that you can paste over them at any time when there are updates to Microvium for bug fixes and new features. If you need to make any changes to the Microvium source files themselves, consider rather submitting a bug report or feature request [on GitHub](https://github.com/coder-mike/microvium/issues), otherwise you lose your changes when upgrade Microvium down the line.

### Step 3: Create a port file

Microvium is written in such a way that it should be portable to many different architectures and scenarios. One way it achieves this is by accessing platform-specific features through a _port file_. This is a header file which `microvium.c` `#include`s but which _you_ write for your specific project. Microvium tries to `#include` it using the exact name `microvium_port.h` so you need to create the file with exactly this name and have it accessible in one of the project "include" directories.

Luckily, you don't need to write the port file from scratch. An example port file is accessible at [./dist-c/microvium_port_example.h](../dist-c/microvium_port_example.h).

For this tutorial, copy the file [microvium_port_example.h](../dist-c/microvium_port_example.h) into the root of your project directory and rename it to `microvium_port.h`. If you're compiling for an MCU, you may want to read through the file and make tweaks and adjustments to suit your architecture, but if you're compiling for a desktop computer, you can leave the port file contents exactly as provided by the example.

### Step 4: Some source code for your project

Now we're set up to have some project code that actually uses Microvium. Create a C file called `main.c` (or whatever you choose to call it) with [the following code](../test/getting-started/code/5.restoring-a-snapshot-in-c.c):

<!-- Script 5.restoring-a-snapshot-in-c.c -->
```c
// main.c
#include <stdlib.h>
#include <stdio.h>
#include <assert.h>

#include "microvium.h"

// A function in the host (this file) for the VM to call
#define IMPORT_PRINT 1

// A function exported by VM to for the host to call
const mvm_VMExportID SAY_HELLO = 1234;

mvm_TeError resolveImport(mvm_HostFunctionID id, void*, mvm_TfHostFunction* out);
mvm_TeError print(mvm_VM* vm, mvm_HostFunctionID funcID, mvm_Value* result, mvm_Value* args, uint8_t argCount);

int main() {
  mvm_TeError err;
  mvm_VM* vm;
  uint8_t* snapshot;
  mvm_Value sayHello;
  mvm_Value result;
  FILE* snapshotFile;
  long snapshotSize;

  // Read the bytecode from file
  snapshotFile = fopen("script.mvm-bc", "rb");
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

  // Clean up
  mvm_runGC(vm, true);

  return 0;
}

/*
 * This function is called by `mvm_restore` to search for host functions
 * imported by the VM based on their ID. Given an ID, it needs to pass back
 * a pointer to the corresponding C function to be used by the VM.
 */
mvm_TeError resolveImport(mvm_HostFunctionID funcID, void* context, mvm_TfHostFunction* out) {
  if (funcID == IMPORT_PRINT) {
    *out = print;
    return MVM_E_SUCCESS;
  }
  return MVM_E_UNRESOLVED_IMPORT;
}

mvm_TeError print(mvm_VM* vm, mvm_HostFunctionID funcID, mvm_Value* result, mvm_Value* args, uint8_t argCount) {
  assert(argCount == 1);
  printf("%s\n", mvm_toStringUtf8(vm, args[0], NULL));
  return MVM_E_SUCCESS;
}
```

Compile the project with your favorite compiler and run the output. It should print `"Hello, World!"`.

