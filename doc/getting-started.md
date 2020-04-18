# Getting Started

Note: even if you only intend to use MicroVM on microcontrollers, it will help to follow this introduction all the way through since the concepts in Node.js and microcontrollers are similar.

## Install Node.js

Install [Node.js](https://nodejs.org/en/download/).

## Install the MicroVM CLI

For simple cases, the builtin MicroVM runtime environment may be sufficient. Run the following command to install the MicroVM cli tool:

```sh
npm install -g @coder-mike/micro-vm
```

To check that the install worked, run a simple script:

```sh
microvm --no-snapshot -e "log('Hello, World!')"
```

If successful, this should print `"Hello, World!"` to the terminal. (The `-e` argument tells MicroVM to evaluate the argument as source text, and the `--no-snapshot` option tells MicroVM not to output a snapshot file of the final VM state).

The CLI provides a default runtime environment for the script, including the `log` function to log to the console (in this stage of development of MicroVM, the `log` function is the only function exposed!).

## Run a script

Create a script:

```js
// script.mvm
log('Hello, World!');
```

Run the script with the following command line:

```sh
microvm script.mvm
```

This runs the script and then outputs a snapshot of the final state of the vm to `snapshot.mvm-bc`. The file extension `mvm-bc` stands for "MicroVM bytecode", and this file encapsulates all the loaded data and functions within the virtual machine. Later in this introduction, we will see how to use a snapshot.

## Hello World (with a custom Node.js host)

Running a script from the CLI is useful in some cases, but a lot of the time you will want to run a script with a custom host. Here, we use the word "host" to mean "the application that needs to run a script", or "the system that is being controlled by the script", depending on how the script is intended to be used.

Setting up a custom host in Node.js is easy. Create a new directory for the host, and run the following command to install MicroVM as a package dependency:

```sh
npm install @coder-mike/micro-vm
```

Then create a new Node.js source file called `host.js` (or any name of your choice) as follows:

```js
// host.js
const { MicroVM } = require('@coder-mike/micro-vm');

const vm = MicroVM.create();

// Create a "print" function in the global scope that refers to this lambda function in the host
vm.global.print = s => console.log(s);

// Run some module source code
vm.importSourceText('print("Hello, World!");'); // Prints "Hello, World!" to the console
```

Run the Node.js host file with the following command:

```sh
node host.js
```

This starts a Node.js application which in turn runs the MicroVM script. The advantage of doing this is to provide a custom API to the script, using the power of Node.js to implement it. In this example, the API exposed to the script has the function `print` (but not `log` or anything else).

The custom API can be used to facilitate preloading of necessary dependencies and data within the MicroVM script itself, while running in a context that has access to database and file resources.

## Making a Snapshot with the CLI

A foundational principle in MicroVM is the ability to snapshot. The MicroVM implementation for microcontrollers has _no ability to parse source text_, since it is designed particularly for small MCUs with only a few kB of RAM or ROM, and no space to store source text or parsers, nor processing power to perform the parsing at runtime.

The solution that MicroVM employs is the ability to persist a _snapshot_ of a virtual machine which _already has all the source text parsed and loaded_, and any heavy initialization already completed, and then downloading this snapshot to the target microcontroller device to be resumed there (in a context where it no longer needs to perform any source code parsing).

<!-- TODO: Insert graphic -->

To make a snapshot useful, we need to export a function from script so that it can be called later. Create the following script file with an export:

```js

// script.mvm

function sayHello() {
  log('Hello, World!');
}
vmExport(1234, sayHello);

```

Run this script with:

```sh
microvm script.mvm
```

When this script runs, the script invokes `vmExport`, which registers that a value within the virtual machine (the `sayHello` function) can be _found_ by the host using the numeric identifier `1234` in this case.

Note that numeric identifers must be integers in the range 0-65535 (i.e. unsigned 16-bit integers). This is for performance reasons.

## Restoring a Snapshot in Node.js

To call the `sayHello` function, let's create a new Node.js host that resumes the VM from the snapshot:

<!-- TODO: Test this -->
```js
// host.js
const { MicroVM } = require('@coder-mike/micro-vm');

// Load the snapshot from file
const snapshot = Snapshot.fromFileSync('snapshot.mvm-bc');

// Restore the virtual machine from the snapshot
const vm = MicroVM.restore(snapshot, MicroVM.defaultEnvironment);

// Locate the function with ID 1234. This is the `sayHello` function that the script exported
const sayHello = vm.resolveExport(1234);

// Call the `sayHello` function in the script
sayHello(); // "Hello, World!"
```

Note that the script and the host need to agree on the ID `1234` as a way to identify the `sayHello` function as part of the script's API.

## Integrating C Code

  1. Copy the VM source files from the [./native-vm](https://github.com/coder-mike/micro-vm/tree/master/native-vm) directory into your C project, ideally in their own subfolder.

  2. Create a `vm_port.h` file to specify platform-specific configurations for the VM. Read [vm_port_example.h](https://github.com/coder-mike/micro-vm/blob/master/native-vm/vm_port_example.h) for more information.

  3. TODO

## Hello-World (C Host)

```c
#include <stdio.h>
#include <assert.h>
#include "vm.h"

// Function imported from host (this file) for the VM to call
const vm_HostFunctionID IMPORT_PRINT = 1;

// Function exported by VM to for the host (this file) to call
const vm_ExportID SAY_HELLO = 1;

vm_TeError resolveImport(vm_HostFunctionID id, void*, vm_TfHostFunction* out);

int main() {
  vm_TeError err;
  vm_VM* vm;
  const uint8_t* snapshot;
  vm_Value sayHello;
  vm_Value result;

  snapshot = /* get snapshot bytecode from somewhere */;

  // Restore the VM from the snapshot
  err = vm_restore(&vm, snapshot, NULL, resolveImport);
  if (err != VM_E_SUCCESS) return err;

  // Find the "sayHello" function exported by the VM
  err = vm_resolveExports(vm, &SAY_HELLO, &sayHello, 1);
  if (err != VM_E_SUCCESS) return err;

  // Call "sayHello"
  err = vm_call(vm, sayHello, &result, NULL, 0);
  if (err != VM_E_SUCCESS) return err;

  return 0;
}

vm_TeError print(vm_VM* vm, vm_HostFunctionID, vm_Value* result, vm_Value* args, uint8_t argCount) {
  // This example assumes that the argument to `print` is a string
  assert(argCount == 1);
  assert(vm_typeOf(vm, arg[0]) == VM_T_STRING);

  char message[20];
  vm_TeError err = vm_stringReadUtf8(vm, &message, arg[0], sizeof message);
  if (err != VM_E_SUCCESS) return err;
  message[19] = '\0';

  printf("%s\n", message);

  return VM_E_SUCCESS;
}

vm_TeError resolveImport(vm_HostFunctionID id, void*, vm_TfHostFunction* out) {
  switch (id) {
    case IMPORT_PRINT: *out = print; break;
    default: return VM_E_UNRESOLVED_IMPORT;
  }
  return VM_E_SUCCESS;
}
```
