#include <stdint.h>

#include "../native-vm/microvium.h"

// Variables in memory that can be used by the embedder for any purpose, e.g.
// for output parameters
void* generalPurpose1;
uint16_t generalPurpose2;
uint16_t generalPurpose3;

extern mvm_TeError invokeHost(mvm_VM* vm, mvm_HostFunctionID hostFunctionID, mvm_Value* result, mvm_Value* args, uint8_t argCount);
extern void importRequired(mvm_HostFunctionID hostFunctionID);

mvm_TeError resolveImport(mvm_HostFunctionID hostFunctionID, void* context, mvm_TfHostFunction* out_hostFunction) {
  importRequired(hostFunctionID);
  // All exports resolve to `invokeHost`
  *out_hostFunction = &invokeHost;
  return MVM_E_SUCCESS;
}

const mvm_TfResolveImport pResolveImport = &resolveImport;