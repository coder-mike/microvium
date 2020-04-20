#pragma once

#include <memory>
#include <map>
#include <napi.h>
#include "../native-vm/microvium.h"
#include "Value.hh"

namespace VM {

class MicroVM: public Napi::ObjectWrap<MicroVM> {
public:
  static void Init(Napi::Env env, Napi::Object exports);
  MicroVM(const Napi::CallbackInfo&);
  ~MicroVM();

  Napi::Value resolveExport(const Napi::CallbackInfo&);
  Napi::Value getUndefined(const Napi::CallbackInfo&);
  Napi::Value call(const Napi::CallbackInfo&);

  static Napi::FunctionReference constructor;
private:
  static vm_TeError resolveImportHandler(vm_HostFunctionID hostFunctionID, void* context, vm_TfHostFunction* out_hostFunction);
  static vm_TeError hostFunctionHandler(vm_VM* vm, vm_HostFunctionID hostFunctionID, vm_Value* result, vm_Value* args, uint8_t argCount);

  vm_VM* vm;
  uint8_t* bytecode;
  Napi::FunctionReference resolveImport;
  std::unique_ptr<Napi::Error> error;
  std::map<vm_HostFunctionID, Napi::FunctionReference> importTable;
};

} // namespace VM
