// main.c
#include <stdio.h>
#include <assert.h>

#include "microvium.h"

// Function imported from host (this file) for the VM to call
const vm_HostFunctionID IMPORT_PRINT = 0xFFFE;

// Function exported by VM to for the host (this file) to call
const vm_ExportID SAY_HELLO = 1234;

mvm_TeError resolveImport(vm_HostFunctionID id, void*, vm_TfHostFunction* out);

int main() {
  mvm_TeError err;
  mvm_VM* vm;
  const uint8_t* snapshot;
  mvm_Value sayHello;
  mvm_Value result;
  FILE* snapshotFile;
  long snapshotSize;

  // Read the bytecode from file
  snapshotFile = fopen("snapshot.mvm-bc", "rb");
  fseek(snapshotFile, 0L, SEEK_END);
  snapshotSize = ftell(snapshotFile);
  rewind(fp);
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

mvm_TeError print(mvm_VM* vm, vm_HostFunctionID, mvm_Value* result, mvm_Value* args, uint8_t argCount) {
  assert(argCount == 1);
  printf("%s\n", mvm_toStringUtf8(vm, args[0], NULL);
  return MVM_E_SUCCESS;
}

mvm_TeError resolveImport(vm_HostFunctionID id, void* context, vm_TfHostFunction* out) {
  switch (id) {
    case IMPORT_PRINT: *out = print; break;
    default: return MVM_E_UNRESOLVED_IMPORT;
  }
  return MVM_E_SUCCESS;
}