#pragma once

#include <napi.h>
#include "../native-vm/microvium.h"

namespace VM {

class Value: public Napi::ObjectWrap<Value> {
public:
  static void Init(Napi::Env env, Napi::Object exports);
  static Napi::Object wrap(vm_VM* vm, vm_Value value);
  static bool isVMValue(Napi::Value value);
  static vm_Value unwrap(Napi::Value value);

  Value(const Napi::CallbackInfo&);
  ~Value();

  Napi::Value toString(const Napi::CallbackInfo&);
  Napi::Value getType(const Napi::CallbackInfo&);

  static Napi::FunctionReference constructor;

  vm_VM* _vm;
  vm_Handle _handle;
};

} // namespace VM
