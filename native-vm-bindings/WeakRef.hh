#pragma once

#include <napi.h>

/*
Node doesn't yet have built-in WeakRef support, and the only shim I could find
is out of date and crashes.
*/
class WeakRef: public Napi::ObjectWrap<WeakRef> {
public:
  static void Init(Napi::Env env, Napi::Object exports);

  WeakRef(const Napi::CallbackInfo&);
  WeakRef(const WeakRef&) = delete;
  WeakRef(WeakRef&&) = delete;
  WeakRef & operator=(const WeakRef&) = delete;
  ~WeakRef();

  Napi::Value deref(const Napi::CallbackInfo&);

  static Napi::FunctionReference constructor;

  Napi::ObjectReference inner;
};


