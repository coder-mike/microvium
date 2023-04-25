#include "Value.hh"

#include <stdexcept>

#include "misc.hh"

Napi::FunctionReference VM::Value::constructor;

void VM::Value::Init(Napi::Env env, Napi::Object exports) {
  Napi::Function ctr = DefineClass(env, "Value", {
    VM::Value::InstanceMethod("toString", &VM::Value::toString),
    VM::Value::InstanceMethod("toBoolean", &VM::Value::toBoolean),
    VM::Value::InstanceMethod("toNumber", &VM::Value::toNumber),
    VM::Value::InstanceMethod("uint8ArrayToBytes", &VM::Value::uint8ArrayToBytes),
    VM::Value::InstanceAccessor("type", &VM::Value::getType, nullptr),
    VM::Value::InstanceAccessor("value", &VM::Value::getValue, nullptr)
  });
  constructor = Napi::Persistent(ctr);
  constructor.SuppressDestruct();
  // Note: the constructor is not exposed to the surface API
}

Napi::Object VM::Value::wrap(mvm_VM* vm, mvm_Value value) {
  auto resultWrapper = Value::constructor.New({});
  auto unwrapped = Value::Unwrap(resultWrapper);
  mvm_initializeHandle(vm, &unwrapped->_handle);
  mvm_handleSet( &unwrapped->_handle, value);
  unwrapped->_vm = vm;
  return resultWrapper;
}

bool VM::Value::isVMValue(Napi::Value value) {
  if (!value.IsObject()) return false;
  auto obj = value.As<Napi::Object>();
  if (!(obj.InstanceOf(VM::Value::constructor.Value()))) {
    return false;
  }
  return true;
}

mvm_Value VM::Value::unwrap(Napi::Value value) {
  auto funcArgObject = value.As<Napi::Object>();
  auto funcArgValue = VM::Value::Unwrap(funcArgObject);
  mvm_Value result = funcArgValue->_handle._value;
  return result;
}

VM::Value::Value(const Napi::CallbackInfo& info) : ObjectWrap(info), _vm(nullptr) {
}

VM::Value::~Value() {
  if (_vm) mvm_releaseHandle(_vm, &_handle);
}

Napi::Value VM::Value::toString(const Napi::CallbackInfo& info) {
  auto env = info.Env();
  mvm_Value value = mvm_handleGet(&_handle);

  size_t size;
  const char* s = (const char*)mvm_toStringUtf8(_vm, value, &size);

  return Napi::String::New(env, s, size);
}

Napi::Value VM::Value::toNumber(const Napi::CallbackInfo& info) {
  auto env = info.Env();
  mvm_Value value = mvm_handleGet(&_handle);

  double d = mvm_toFloat64(_vm, value);

  return Napi::Number::New(env, d);
}

Napi::Value VM::Value::toBoolean(const Napi::CallbackInfo& info) {
  auto env = info.Env();
  mvm_Value value = mvm_handleGet(&_handle);

  bool b = mvm_toBool(_vm, value);

  return Napi::Boolean::New(env, b);
}

Napi::Value VM::Value::uint8ArrayToBytes(const Napi::CallbackInfo& info) {
  auto env = info.Env();
  mvm_Value value = mvm_handleGet(&_handle);

  uint8_t* data;
  size_t size;
  mvm_TeError err = mvm_uint8ArrayToBytes(_vm, value, &data, &size);

  if (err != MVM_E_SUCCESS) {
    throwVMError(env, err);
    return env.Undefined();
  }

  auto buffer = Napi::Buffer<uint8_t>::Copy(info.Env(), data, size);

  return buffer;
}

Napi::Value VM::Value::getType(const Napi::CallbackInfo& info) {
  mvm_TeType type = mvm_typeOf(_vm, _handle._value);
  return Napi::Number::New(info.Env(), type);
}

Napi::Value VM::Value::getValue(const Napi::CallbackInfo& info) {
  return Napi::Number::New(info.Env(), _handle._value);
}
