#include "Value.hh"

#include <stdexcept>

#include "misc.hh"

Napi::FunctionReference VM::Value::constructor;

void VM::Value::Init(Napi::Env env, Napi::Object exports) {
  Napi::Function ctr = DefineClass(env, "Value", {
    VM::Value::InstanceMethod("asString", &VM::Value::asString),
    VM::Value::InstanceAccessor("type", &VM::Value::getType, nullptr)
  });
  constructor = Napi::Persistent(ctr);
  constructor.SuppressDestruct();
  // Note: the constructor is not exposed to the surface API
}

Napi::Object VM::Value::wrap(vm_VM* vm, vm_Value value) {
  auto resultWrapper = Value::constructor.New({});
  auto unwrapped = Value::Unwrap(resultWrapper);
  vm_initializeGCHandle(vm, &unwrapped->_handle);
  *vm_handleValue(vm, &unwrapped->_handle) = value;
  unwrapped->_vm = vm;
  return resultWrapper;
}

bool VM::Value::isVMValue(Napi::Value value) {
  if (!value.IsObject()) return false;
  auto obj = value.As<Napi::Object>();
  if (!(obj.InstanceOf(VM::Value::constructor.Value()))) { // TODO: Is there a more robust way of checking that an object is really associated with this value?
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
  if (_vm) vm_releaseGCHandle(_vm, &_handle);
}


Napi::Value VM::Value::asString(const Napi::CallbackInfo& info) {
  vm_TeError err;
  auto env = info.Env();
  auto& value = _handle._value;
  if (vm_typeOf(_vm, value) != VM_T_STRING) {
    Napi::TypeError::New(env, "Value is not a string")
      .ThrowAsJavaScriptException();
    return env.Undefined();
  }

  size_t stringSize;
  err = vm_stringSizeUtf8(_vm, value, &stringSize);
  if (err != VM_E_SUCCESS) {
    throwVMError(info.Env(), err);
    return info.Env().Undefined();
  }

  std::string s(stringSize, '\0');
  err = vm_stringReadUtf8(_vm, &s[0], value, stringSize);
  if (err != VM_E_SUCCESS) {
    throwVMError(info.Env(), err);
    return info.Env().Undefined();
  }

  return Napi::String::New(env, s);
}

Napi::Value VM::Value::getType(const Napi::CallbackInfo& info) {
  vm_TeType type = vm_typeOf(_vm, _handle._value);
  return Napi::Number::New(info.Env(), type);
}
