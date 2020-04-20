#include <map>
#include <napi.h>
#include "MicroVM.hh"
#include "misc.hh"

using namespace VM;

Napi::FunctionReference MicroVM::constructor;

void MicroVM::Init(Napi::Env env, Napi::Object exports) {
  Napi::Function ctr = DefineClass(env, "MicroVM", {
    MicroVM::InstanceMethod("resolveExport", &MicroVM::resolveExport),
    MicroVM::InstanceMethod("call", &MicroVM::call),
    MicroVM::InstanceAccessor("undefined", &MicroVM::getUndefined, nullptr),
  });
  constructor = Napi::Persistent(ctr);
  exports.Set(Napi::String::New(env, "MicroVM"), ctr);
  constructor.SuppressDestruct();
}

MicroVM::MicroVM(const Napi::CallbackInfo& info) : ObjectWrap(info), vm(nullptr)
{
  Napi::Env env = info.Env();
  if (info.Length() < 2) {
    Napi::TypeError::New(env, "Wrong number of arguments")
      .ThrowAsJavaScriptException();
    return;
  }

  if (!info[0].IsBuffer()) {
    Napi::TypeError::New(env, "Expected first argument to be a buffer")
      .ThrowAsJavaScriptException();
    return;
  }

  if (!info[1].IsFunction()) {
    Napi::TypeError::New(env, "Expected first argument to be a buffer")
      .ThrowAsJavaScriptException();
    return;
  }

  Napi::Buffer<uint8_t> bytecodeBuffer = info[0].As<Napi::Buffer<uint8_t>>();
  size_t bytecodeLength = bytecodeBuffer.ByteLength();
  this->bytecode = new uint8_t[bytecodeLength];
  memcpy(this->bytecode, bytecodeBuffer.Data(), bytecodeLength);

  this->resolveImport.Reset(info[1].As<Napi::Function>(), 1);

  vm_TeError err = vm_restore(&this->vm, this->bytecode, bytecodeLength, this, MicroVM::resolveImportHandler);
  if (err != VM_E_SUCCESS) {
    if (this->error) {
      std::unique_ptr<Napi::Error> err(std::move(this->error));
      err->ThrowAsJavaScriptException();
      return;
    }
    throwVMError(env, err);
    return;
  }
}

Napi::Value MicroVM::getUndefined(const Napi::CallbackInfo& info) {
  return VM::Value::wrap(vm, vm_undefined);
}

Napi::Value MicroVM::call(const Napi::CallbackInfo& info) {
  vm_TeError err;
  auto env = info.Env();

  if (info.Length() < 2) {
    Napi::TypeError::New(env, "Expected 2 arguments")
      .ThrowAsJavaScriptException();
    return env.Undefined();
  }

  auto funcArg = info[0];
  if (!VM::Value::isVMValue(funcArg)) {
    Napi::TypeError::New(env, "Expected first argument to be a MicroVM `Value`")
      .ThrowAsJavaScriptException();
    return env.Undefined();
  }
  vm_Value funcArgVMValue = VM::Value::unwrap(funcArg);

  auto argsArg = info[1];
  if (!argsArg.IsArray()) {
    Napi::TypeError::New(env, "Expected second argument to be an array of MicroVM `Value`s")
      .ThrowAsJavaScriptException();
    return env.Undefined();
  }
  auto argsArray = argsArg.As<Napi::Array>();
  auto argsLength = argsArray.Length();
  std::vector<vm_Value> args;
  for (uint32_t i = 0; i < argsLength; i++) {
    auto argsItem = argsArray.Get(i);
    if (!VM::Value::isVMValue(argsItem)) { // TODO(low): Test arguments
      Napi::TypeError::New(env, "Expected second argument to be an array of MicroVM `Value`s")
        .ThrowAsJavaScriptException();
      return env.Undefined();
    }
    vm_Value argValue = VM::Value::unwrap(argsItem);
    args.push_back(argValue);
  }

  vm_Value result;
  if (args.size())
    err = vm_call(vm, funcArgVMValue, &result, &args[0], args.size());
  else
    err = vm_call(vm, funcArgVMValue, &result, nullptr, 0);
  if (err != VM_E_SUCCESS) {
    if (this->error) {
      std::unique_ptr<Napi::Error> err(std::move(this->error));
      err->ThrowAsJavaScriptException();
      return env.Undefined();
    }
    throwVMError(env, err);
    return env.Undefined();
  }

  return VM::Value::wrap(vm, result);
}

MicroVM::~MicroVM() {
  if (this->vm) {
    vm_free(this->vm);
    this->vm = nullptr;
  }
}

vm_TeError MicroVM::resolveImportHandler(vm_HostFunctionID hostFunctionID, void* context, vm_TfHostFunction* out_hostFunction) {
  MicroVM* self = (MicroVM*)context;
  try {
    auto env = self->resolveImport.Env();
    auto global = env.Global();
    auto result = self->resolveImport.Call(global, {
      Napi::Number::New(env, hostFunctionID)
    });

    if (!result.IsFunction()) {
      Napi::TypeError::New(env, "Resolved import handler must be a function")
        .ThrowAsJavaScriptException();
      return VM_E_HOST_ERROR;
    }

    auto hostFunction = result.As<Napi::Function>();

    self->importTable[hostFunctionID] = Napi::Persistent(hostFunction);

    // All host calls go through a common handler
    *out_hostFunction = &MicroVM::hostFunctionHandler;

    return VM_E_SUCCESS;
  }
  catch (Napi::Error& e) {
    self->error.reset(new Napi::Error(e));
    return VM_E_HOST_ERROR;
  }
  catch (...) {
    return VM_E_HOST_ERROR;
  }

}

vm_TeError MicroVM::hostFunctionHandler(vm_VM* vm, vm_HostFunctionID hostFunctionID, vm_Value* result, vm_Value* args, uint8_t argCount) {
  MicroVM* self = (MicroVM*)vm_getContext(vm);
  auto handlerIter = self->importTable.find(hostFunctionID);
  if (handlerIter == self->importTable.end()) {
    // This should never happen because the bytecode should resolve all its
    // imports upfront, so they should be in the import table.
    return VM_E_FUNCTION_NOT_FOUND;
  }

  auto& handler(handlerIter->second);
  auto env(handler.Env());

  auto innerArgs = Napi::Array::New(env);

  for (uint32_t i = 0; i < argCount; i++) {
    auto arg = args[i];
    innerArgs.Set(i, VM::Value::wrap(vm, arg));
  }

  auto obj = env.Undefined(); // Reserved for later use
  auto resultValue = handler.Call(env.Global(), { obj, innerArgs });

  if (!VM::Value::isVMValue(resultValue)) {
    return VM_E_HOST_RETURNED_INVALID_VALUE;
  }
  *result = VM::Value::unwrap(resultValue);

  return VM_E_SUCCESS; // TODO(high): Error handling -- catch exceptions?
}

Napi::Value MicroVM::resolveExport(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();

  if (info.Length() < 1) {
    Napi::TypeError::New(env, "Expected exportID argument")
      .ThrowAsJavaScriptException();
    return env.Undefined();
  }

  auto exportIDArgument = info[0];

  if (!exportIDArgument.IsNumber()) {
    Napi::TypeError::New(env, "Expected exportID to be a number")
      .ThrowAsJavaScriptException();
    return env.Undefined();
  }

  auto exportIDNumber = exportIDArgument.ToNumber();
  auto exportIDInt32 = exportIDNumber.Int32Value();
  if ((exportIDInt32 < 0) || (exportIDInt32 > 0xFFFF)) {
    Napi::TypeError::New(env, "exportID out of range") // TODO(high): It seems I've copy-pasted type errors everywhere instead of using the correct error type
      .ThrowAsJavaScriptException();
    return env.Undefined();
  }

  vm_VMExportID exportID = exportIDInt32;
  vm_Value result;
  vm_TeError err = vm_resolveExports(vm, &exportID, &result, 1);
  if (err != VM_E_SUCCESS) {
    throwVMError(env, err);
    return env.Undefined();
  }

  return VM::Value::wrap(vm, result);
}
