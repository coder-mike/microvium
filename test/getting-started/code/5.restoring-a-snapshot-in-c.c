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