#include <iostream>
#include <fstream>
#include <vector>

#include "../vm_internals.h"

#include "../vm.h"

vm_TsBytecodeHeader dummy; // Prevent debugger discarding this structure

struct HostFunction {
  vm_HostFunctionID hostFunctionID;
  vm_TfHostFunction hostFunction;
};

struct Context {
  std::vector<std::string> logEntries;
};

static vm_TeError print(vm_VM* vm, vm_HostFunctionID hostFunctionID, vm_Value* result, vm_Value* args, uint8_t argCount) {
  // TODO(high): I need to give some thought to the semantics of imports in terms of signatures for the SI. The export signatures probably need to be in the bytecode
  vm_TeError err;
  Context* context = (Context*)vm_getContext(vm);
  if (argCount != 1) return VM_E_INVALID_ARGUMENTS;
  vm_Value messageArg = args[0];
  if (vm_typeOf(vm, messageArg) != VM_T_STRING) return VM_E_INVALID_ARGUMENTS;
  size_t messageSize;
  err = vm_stringSizeUtf8(vm, messageArg, &messageSize);
  if (err != VM_E_SUCCESS) return err;
  std::string message(messageSize, '\0');
  err = vm_stringReadUtf8(vm, &message[0], messageArg, messageSize);
  if (err != VM_E_SUCCESS) return err;

  context->logEntries.push_back(message);

  return VM_E_SUCCESS;
}

const HostFunction hostFunctions[] = {
  { 1, print }
};

constexpr size_t hostFunctionCount = sizeof hostFunctions / sizeof hostFunctions[0];

extern "C" void vm_error(vm_VM * vm, vm_TeError e) {
  printf("VM ERROR %i\n", e);
}

vm_TeError resolveImport(vm_HostFunctionID hostFunctionID, void* context, vm_TfHostFunction* out_hostFunction) {
  for (uint16_t i2 = 0; i2 < hostFunctionCount; i2++) {
    if (hostFunctions[i2].hostFunctionID == hostFunctionID) {
      *out_hostFunction = hostFunctions[i2].hostFunction;
      return VM_E_SUCCESS;
    }
  }
  return VM_E_UNRESOLVED_IMPORT;
}

constexpr int VM_EXPORT_INDEX_RUN = 0;
constexpr int VM_EXPORT_ID_RUN = 42;

const vm_VMExportID exportIDs[] = { VM_EXPORT_ID_RUN };
constexpr vm_Value vmExportCount = sizeof exportIDs / sizeof exportIDs[0];

int main()
{
  // Read bytecode file
  std::ifstream bytecodeFile("../../test/end-to-end/artifacts/hello-world/2.post-gc.mvm-bc", std::ios::binary | std::ios::ate);
  if (!bytecodeFile.is_open()) return 1;
  std::streamsize bytecodeSize = bytecodeFile.tellg();
  uint8_t* bytecode = new uint8_t[(size_t)bytecodeSize];
  bytecodeFile.seekg(0, std::ios::beg);
  if (!bytecodeFile.read((char*)bytecode, bytecodeSize)) return 1;

  // Create VM
  Context* context = new Context;
  vm_VM* vm;
  vm_TeError err = vm_restore(&vm, bytecode, context, resolveImport);
  if (err != VM_E_SUCCESS) return err;

  // Resolve VM Exports
  vm_Value exports[vmExportCount];
  err = vm_resolveExports(vm, exportIDs, exports, vmExportCount);
  if (err != VM_E_SUCCESS) return err;

  // Invoke exported function
  vm_Value run = exports[VM_EXPORT_INDEX_RUN];
  vm_Value result;
  err = vm_call(vm, run, &result, nullptr, 0);
  if (err != VM_E_SUCCESS) return err;

  // vm_runGC(vm);
  vm_free(vm);
  vm = nullptr;
  return 0;
}
