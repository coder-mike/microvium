#include "WeakRef.hh"

Napi::FunctionReference WeakRef::constructor;

void WeakRef::Init(Napi::Env env, Napi::Object exports) {
  Napi::Function ctr = DefineClass(env, "Value", {
    WeakRef::InstanceMethod("deref", &WeakRef::deref)
  });
  constructor = Napi::Persistent(ctr);
  exports.Set(Napi::String::New(env, "WeakRef"), ctr);
  constructor.SuppressDestruct();
}

WeakRef::WeakRef(const Napi::CallbackInfo& info) : ObjectWrap(info) {
  Napi::Env env = info.Env();
  if (info.Length() < 1) {
    Napi::TypeError::New(env, "Expected 1 argument")
      .ThrowAsJavaScriptException();
    return;
  }

  if (!info[0].IsObject()) {
    Napi::TypeError::New(env, "Expected object argument")
      .ThrowAsJavaScriptException();
    return;
  }

  this->inner.Reset(info[0].As<Napi::Object>(), 0u);
}

Napi::Value WeakRef::deref(const Napi::CallbackInfo& info) {
  if (this->inner.IsEmpty())
    return info.Env().Undefined();
  return this->inner.Value();
}

WeakRef::~WeakRef() {
}