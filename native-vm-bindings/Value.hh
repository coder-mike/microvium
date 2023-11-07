#pragma once

#include <napi.h>
#include "../native-vm/microvium.h"

namespace VM {

class Value: public Napi::ObjectWrap<Value> {
public:
  static void Init(Napi::Env env, Napi::Object exports);
  static Napi::Object wrap(mvm_VM* vm, mvm_Value value);
  static bool isVMValue(Napi::Value value);
  static mvm_Value unwrap(Napi::Value value);

  Value(const Napi::CallbackInfo&);
  Value(const Value&) = delete;
  Value(Value&&) = delete;
  Value & operator=(const Value&) = delete;
  ~Value();

  Napi::Value toString(const Napi::CallbackInfo&);
  Napi::Value toNumber(const Napi::CallbackInfo&);
  Napi::Value toBoolean(const Napi::CallbackInfo&);
  Napi::Value uint8ArrayToBytes(const Napi::CallbackInfo&);
  Napi::Value getType(const Napi::CallbackInfo&);
  Napi::Value getRaw(const Napi::CallbackInfo&);

  static Napi::FunctionReference constructor;

  mvm_VM* _vm;
  mvm_Handle _handle;
};

} // namespace VM
