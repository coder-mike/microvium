#pragma once

#include <memory>
#include <map>
#include <napi.h>
#include "../native-vm/microvium.h"
#include "Value.hh"

namespace VM {

class NativeVM: public Napi::ObjectWrap<NativeVM> {
public:
  static void Init(Napi::Env env, Napi::Object exports);
  NativeVM(const Napi::CallbackInfo&);
  ~NativeVM();

  Napi::Value resolveExport(const Napi::CallbackInfo&);
  Napi::Value uint8ArrayFromBytes(const Napi::CallbackInfo&);
  Napi::Value typeOf(const Napi::CallbackInfo&);
  Napi::Value getUndefined(const Napi::CallbackInfo&);
  Napi::Value call(const Napi::CallbackInfo&);
  Napi::Value newBoolean(const Napi::CallbackInfo&);
  Napi::Value newString(const Napi::CallbackInfo&);
  Napi::Value newNumber(const Napi::CallbackInfo&);
  void runGC(const Napi::CallbackInfo&);
  Napi::Value createSnapshot(const Napi::CallbackInfo&);
  Napi::Value getMemoryStats(const Napi::CallbackInfo&);
  Napi::Value asyncStart(const Napi::CallbackInfo&);

  void fatalError(int error);
  Napi::Value stopAfterNInstructions(const Napi::CallbackInfo&);
  Napi::Value getInstructionCountRemaining(const Napi::CallbackInfo&);

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
  // Pointer to result slot for currently-running host function (if any, otherwise NULL)
  mvm_Value* pResult;
  Napi::Env env;
};

} // namespace VM
