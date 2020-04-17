# Getting Started

## Installing Toolchain

### Step 1: Install Node.js

Install [Node.js](https://nodejs.org/en/download/).

 - Note that Node.js needs to be installed with the tools for building native modules ([see the note at the bottom of this page](#Requires-Tools-for-Native-Modules)), which can be as simple as checking the right box on installation.

### Step 2: Install MicroVM

TODO: This example doesn't work yet.

For simple cases, the builtin MicroVM runtime environment may be sufficient. To install this, run:

```sh
npm install -g microvm
```

To check that the install worked, run a simple script:

```sh
microvm -e "console.log('Hello, World!')"
```

If successful, this should print `"Hello, World!"` to the terminal and output a `snapshot.mvm-bc` file representing the state of the VM at completion. (The `-e` argument tells MicroVM to evaluate the argument as source text).

## Hello World (Node.js Host)

For a Node.js host using MicroVM as a library.

```js
import { MicroVM } from 'microvm';

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

## Appendix

### Requires Tools for Native Modules

Note: this project requires that node was installed with the optional extensions for [building C++ packages](https://napi.inspiredware.com/getting-started/tools.html). On Windows, this can be done by checking the corresponding box at installation:

![./images/node-install-native.png](./images/node-install-native.png)