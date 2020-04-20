#include "Value.hh"
#include "MicroVM.hh"
#include "WeakRef.hh"

#include <napi.h>

// TODO(low): Read the V8 embed docs: https://v8.dev/docs/embed

// TODO(low): There are a million warnings when compiling the native module

Napi::Object Init(Napi::Env env, Napi::Object exports) {
  VM::MicroVM::Init(env, exports);
  VM::Value::Init(env, exports);
  WeakRef::Init(env, exports);

  return exports;
}

NODE_API_MODULE(addon, Init)
