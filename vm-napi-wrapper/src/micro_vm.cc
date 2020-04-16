#include <map>
#include <napi.h>
#include "micro-vm.hh"

// TODO: Read the V8 embed docs: https://v8.dev/docs/embed
// TODO: There are a million warnings when compiling the native module
// TODO: This might be a cleaner way to debug https://medium.com/@atulanand94/debugging-nodejs-c-addons-using-vs-code-27e9940fc3ad
// TODO: Document the debug workflow for the project
// TODO: Consolidate the types for these native bindings with the other VM and with the runtime types.

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
  { VM_E_COPY_ACROSS_BUCKET_BOUNDARY, "VM_E_COPY_ACROSS_BUCKET_BOUNDARY" },
  { VM_E_FUNCTION_NOT_FOUND, "VM_E_FUNCTION_NOT_FOUND" },
  { VM_E_INVALID_HANDLE, "VM_E_INVALID_HANDLE" },
  { VM_E_STACK_OVERFLOW, "VM_E_STACK_OVERFLOW" },
  { VM_E_UNRESOLVED_IMPORT, "VM_E_UNRESOLVED_IMPORT" },
  { VM_E_ATTEMPT_TO_WRITE_TO_ROM, "VM_E_ATTEMPT_TO_WRITE_TO_ROM" },
  { VM_E_INVALID_ARGUMENTS, "VM_E_INVALID_ARGUMENTS" },
  { VM_E_TYPE_ERROR, "VM_E_TYPE_ERROR" },
  { VM_E_TARGET_NOT_CALLABLE, "VM_E_TARGET_NOT_CALLABLE" },
};

vm_TeError MicroVM::resolveImportHandler(vm_HostFunctionID hostFunctionID, void* context, vm_TfHostFunction* out_hostFunction) {
  MicroVM* self = (MicroVM*)context;
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

  // TODO: What happens on a failed import? When the host throws? What cleans up?
  return VM_E_SUCCESS;
}

vm_TeError MicroVM::hostFunctionHandler(vm_VM* vm, vm_HostFunctionID hostFunctionID, vm_Value* result, vm_Value* args, uint8_t argCount) {
  vm_TeError err;

  MicroVM* self = (MicroVM*)vm_getContext(vm);
  auto handlerIter = self->importTable.find(hostFunctionID);
  if (handlerIter == self->importTable.end()) {
    // This should never happen because the bytecode should resolve all its
    // imports upfront, so they should be in the import table.
    return VM_E_FUNCTION_NOT_FOUND;
  }

  auto& handler(handlerIter->second);
  auto& env(handler.Env());

  std::vector<napi_value> innerArgs;

  for (int i = 0; i < argCount; i++) {
    auto arg = args[i];
    // TODO: Refactor into separate function
    vm_TeType type = vm_typeOf(vm, arg);
    switch (type) {
      case VM_T_STRING: {
        size_t messageSize;
        err = vm_stringSizeUtf8(vm, arg, &messageSize);
        if (err != VM_E_SUCCESS) return err;
        std::string message(messageSize, '\0');
        err = vm_stringReadUtf8(vm, &message[0], arg, messageSize);
        innerArgs.push_back(Napi::String::New(env, message));
      }
      default: return VM_E_NOT_IMPLEMENTED;
    }
  }

  auto resultValue = handler.Call(innerArgs);

  // TODO: Refactor into separate function
  switch (resultValue.Type()) {
    case napi_undefined: {
      vm_setUndefined(vm, result);
      break;
    }
    case napi_null: return VM_E_NOT_IMPLEMENTED;
    case napi_boolean: return VM_E_NOT_IMPLEMENTED;
    case napi_number: return VM_E_NOT_IMPLEMENTED;
    case napi_string: return VM_E_NOT_IMPLEMENTED;
    case napi_symbol: return VM_E_NOT_IMPLEMENTED;
    case napi_object: return VM_E_NOT_IMPLEMENTED;
    case napi_function: return VM_E_NOT_IMPLEMENTED;
    case napi_external: return VM_E_NOT_IMPLEMENTED;
    default: return VM_E_UNEXPECTED;
  }

  return VM_E_SUCCESS;
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

  vm_TeError err = vm_restore(&this->vm, this->bytecode, this, MicroVM::resolveImportHandler);
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
