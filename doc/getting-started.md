# Getting Started

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
// script.js
log('Hello, World!');
```

Run the script with the following command line:

```sh
microvm script.js
```

This runs the script and then outputs a snapshot of the final state of the vm to `snapshot.mvm-bc`. The file extension `mvm-bc` stands for "MicroVM bytecode", and this file encapsulates all the loaded data and functions within the virtual machine. Later in this introduction, we will see how to use a snapshot.



## Hello World (with a custom Node.js host)

For a Node.js host using MicroVM as a library.

```js
import { MicroVM } from '@coder-mike/micro-vm';

const vm = MicroVM.create();

// Create a print function in the global scope
vm.global.print = s => console.log(s);

// Run some module source code
vm.importSourceText('print("Hello, World!");'); // Prints "Hello, World!" to the console
```

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
