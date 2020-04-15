#include <map>
#include <napi.h>
#include "micro-vm.hh"

using namespace Napi;

extern "C" void vm_error(vm_VM * vm, vm_TeError e) {
  printf("VM ERROR %i\n", e);
}

std::map<vm_TeError, std::string> errorDescriptions = {
  { VM_E_SUCCESS, "VM_E_SUCCESS" },
  { VM_E_UNEXPECTED, "VM_E_UNEXPECTED" },
  { VM_E_MALLOC_FAIL, "VM_E_MALLOC_FAIL" },
  { VM_E_ALLOCATION_TOO_LARGE, "VM_E_ALLOCATION_TOO_LARGE" },
  { VM_E_INVALID_ADDRESS, "VM_E_INVALID_ADDRESS" },
  { VM_E_COPY_ACCROSS_BUCKET_BOUNDARY, "VM_E_COPY_ACCROSS_BUCKET_BOUNDARY" },
  { VM_E_FUNCTION_NOT_FOUND, "VM_E_FUNCTION_NOT_FOUND" },
  { VM_E_INVALID_HANDLE, "VM_E_INVALID_HANDLE" },
  { VM_E_STACK_OVERFLOW, "VM_E_STACK_OVERFLOW" },
  { VM_E_UNRESOLVED_IMPORT, "VM_E_UNRESOLVED_IMPORT" },
  { VM_E_ATTEMPT_TO_WRITE_TO_ROM, "VM_E_ATTEMPT_TO_WRITE_TO_ROM" },
  { VM_E_INVALID_ARGUMENTS, "VM_E_INVALID_ARGUMENTS" },
  { VM_E_TYPE_ERROR, "VM_E_TYPE_ERROR" },
  { VM_E_TARGET_NOT_CALLABLE, "VM_E_TARGET_NOT_CALLABLE" },
};

vm_TeError MicroVM::resolveImport(vm_HostFunctionID hostFunctionID, void* context, vm_TfHostFunction* out_hostFunction) {
  MicroVM* vm = (MicroVM*)context;

  return VM_E_UNRESOLVED_IMPORT;
}

MicroVM::MicroVM(const Napi::CallbackInfo& info)
  : ObjectWrap(info), vm(nullptr)
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

  Napi::Buffer<uint8_t> bytecodeBuffer = info[0].As<Napi::Buffer<uint8_t>>();
  size_t bytecodeLength = bytecodeBuffer.ByteLength();
  this->bytecode = new uint8_t[bytecodeLength];
  memcpy(this->bytecode, bytecodeBuffer.Data(), bytecodeLength);

  vm_TeError err = vm_restore(&this->vm, this->bytecode, this, resolveImport);
  if (err != VM_E_SUCCESS) {
    auto errorDescription = errorDescriptions.find(err);
    if (errorDescription != errorDescriptions.end()) {
      Napi::Error::New(env, errorDescription->second)
        .ThrowAsJavaScriptException();
    } else {
      Napi::Error::New(env, std::string("VM error code: ") + std::to_string(err))
        .ThrowAsJavaScriptException();
    }
    return;
  }
}

MicroVM::~MicroVM() {
  if (this->vm) {
    vm_free(this->vm);
    this->vm = nullptr;
  }
}

Napi::Function MicroVM::GetClass(Napi::Env env) {
  return DefineClass(env, "MicroVM", {
  });
}

Napi::Object Init(Napi::Env env, Napi::Object exports) {
  Napi::String name = Napi::String::New(env, "MicroVM");
  exports.Set(name, MicroVM::GetClass(env));
  return exports;
}

NODE_API_MODULE(addon, Init)
