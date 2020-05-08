#pragma once

#include <memory>
#include <map>
#include <napi.h>
#include "../native-vm/microvium.h"
#include "Value.hh"

namespace VM {

class Microvium: public Napi::ObjectWrap<Microvium> {
public:
  static void Init(Napi::Env env, Napi::Object exports);
  Microvium(const Napi::CallbackInfo&);
  ~Microvium();

  Napi::Value resolveExport(const Napi::CallbackInfo&);
  Napi::Value getUndefined(const Napi::CallbackInfo&);
  Napi::Value call(const Napi::CallbackInfo&);

  static void setCoverageCallback(const Napi::CallbackInfo&);
  static Napi::FunctionReference coverageCallback;

  static Napi::FunctionReference constructor;
private:
  static mvm_TeError resolveImportHandler(mvm_HostFunctionID hostFunctionID, void* context, mvm_TfHostFunction* out_hostFunction);
  static mvm_TeError hostFunctionHandler(mvm_VM* vm, mvm_HostFunctionID hostFunctionID, mvm_Value* result, mvm_Value* args, uint8_t argCount);

  mvm_VM* vm;
  uint8_t* bytecode;
  Napi::FunctionReference resolveImport;
  std::unique_ptr<Napi::Error> error;
  std::map<mvm_HostFunctionID, Napi::FunctionReference> importTable;
};

} // namespace VM
