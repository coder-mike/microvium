#include "Value.hh"

#include <stdexcept>

#include "misc.hh"

Napi::FunctionReference VM::Value::constructor;

void VM::Value::Init(Napi::Env env, Napi::Object exports) {
  Napi::Function ctr = DefineClass(env, "Value", {
    VM::Value::InstanceMethod("toString", &VM::Value::toString),
    VM::Value::InstanceAccessor("type", &VM::Value::getType, nullptr)
  });
  constructor = Napi::Persistent(ctr);
  constructor.SuppressDestruct();
  // Note: the constructor is not exposed to the surface API
}

Napi::Object VM::Value::wrap(vm_VM* vm, vm_Value value) {
  auto resultWrapper = Value::constructor.New({});
  auto unwrapped = Value::Unwrap(resultWrapper);
  vm_initializeHandle(vm, &unwrapped->_handle);
  vm_handleSet( &unwrapped->_handle, value);
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

vm_Value VM::Value::unwrap(Napi::Value value) {
  auto funcArgObject = value.As<Napi::Object>();
  auto funcArgValue = VM::Value::Unwrap(funcArgObject);
  vm_Value result = funcArgValue->_handle._value;
  return result;
}

VM::Value::Value(const Napi::CallbackInfo& info) : ObjectWrap(info), _vm(nullptr) {
}

VM::Value::~Value() {
  if (_vm) vm_releaseHandle(_vm, &_handle);
}

Napi::Value VM::Value::toString(const Napi::CallbackInfo& info) {
  auto env = info.Env();
  vm_Value value = vm_handleGet(&_handle);

  size_t size;
  const char* s = vm_toStringUtf8(_vm, value, &size);

  return Napi::String::New(env, s, size);
}

Napi::Value VM::Value::getType(const Napi::CallbackInfo& info) {
  vm_TeType type = vm_typeOf(_vm, _handle._value);
  return Napi::Number::New(info.Env(), type);
}
