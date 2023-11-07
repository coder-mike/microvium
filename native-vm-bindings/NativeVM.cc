#include <map>
#include <napi.h>
#include <stdexcept>
#include "NativeVM.hh"
#include "misc.hh"
#include "error_descriptions.hh"

using namespace VM;

// Using RAII to define a scope in which we know the result pointer for a host call
struct ResultPointerScope {
  mvm_Value* prevValue;
  mvm_Value*& ref_;
  ResultPointerScope(mvm_Value*& save, mvm_Value* pResult): prevValue(save), ref_(save) {
    save = pResult;
  }
  ~ResultPointerScope() { ref_ = prevValue; }
};

Napi::FunctionReference NativeVM::constructor;
Napi::FunctionReference NativeVM::coverageCallback;

void NativeVM::Init(Napi::Env env, Napi::Object exports) {
  Napi::Function ctr = DefineClass(env, "NativeVM", {
    NativeVM::InstanceMethod("resolveExport", &NativeVM::resolveExport),
    NativeVM::InstanceMethod("uint8ArrayFromBytes", &NativeVM::uint8ArrayFromBytes),
    NativeVM::InstanceMethod("typeOf", &NativeVM::typeOf),
    NativeVM::InstanceMethod("call", &NativeVM::call),
    NativeVM::InstanceAccessor("undefined", &NativeVM::getUndefined, nullptr),
    NativeVM::StaticMethod("setCoverageCallback", &NativeVM::setCoverageCallback),
    NativeVM::InstanceMethod("newBoolean", &NativeVM::newBoolean),
    NativeVM::InstanceMethod("newNumber", &NativeVM::newNumber),
    NativeVM::InstanceMethod("newString", &NativeVM::newString),
    NativeVM::InstanceMethod("runGC", &NativeVM::runGC),
    NativeVM::InstanceMethod("createSnapshot", &NativeVM::createSnapshot),
    NativeVM::InstanceMethod("getMemoryStats", &NativeVM::getMemoryStats),
    NativeVM::InstanceMethod("asyncStart", &NativeVM::asyncStart),
    NativeVM::InstanceMethod("stopAfterNInstructions", &NativeVM::stopAfterNInstructions),
    NativeVM::InstanceMethod("getInstructionCountRemaining", &NativeVM::getInstructionCountRemaining),
    NativeVM::StaticValue("MVM_PORT_INT32_OVERFLOW_CHECKS", Napi::Boolean::New(env, MVM_PORT_INT32_OVERFLOW_CHECKS)),
  });
  constructor = Napi::Persistent(ctr);
  exports.Set(Napi::String::New(env, "NativeVM"), ctr);
  constructor.SuppressDestruct();
}

NativeVM::NativeVM(const Napi::CallbackInfo& info) :
  ObjectWrap(info), vm(nullptr), pResult(nullptr), env(info.Env())
{
  Napi::Env env = info.Env();
  if (info.Length() < 2) {
    Napi::Error::New(env, "Wrong number of arguments")
      .ThrowAsJavaScriptException();
    return;
  }

  if (!info[0].IsBuffer()) {
    Napi::TypeError::New(env, "Expected first argument to be a buffer")
      .ThrowAsJavaScriptException();
    return;
  }

  if (!info[1].IsFunction()) {
    Napi::TypeError::New(env, "Expected second argument to be a function")
      .ThrowAsJavaScriptException();
    return;
  }

  Napi::Buffer<uint8_t> bytecodeBuffer = info[0].As<Napi::Buffer<uint8_t>>();
  size_t bytecodeLength = bytecodeBuffer.ByteLength();
  this->bytecode = new uint8_t[bytecodeLength];
  memcpy(this->bytecode, bytecodeBuffer.Data(), bytecodeLength);

  this->resolveImport.Reset(info[1].As<Napi::Function>(), 1);

  mvm_TeError err = mvm_restore(&this->vm, this->bytecode, bytecodeLength, this, NativeVM::resolveImportHandler);
  if (err != MVM_E_SUCCESS) {
    if (this->error) {
      std::unique_ptr<Napi::Error> err(std::move(this->error));
      err->ThrowAsJavaScriptException();
      return;
    }
    throwVMError(env, err);
    return;
  }
}

Napi::Value NativeVM::getUndefined(const Napi::CallbackInfo& info) {
  return VM::Value::wrap(vm, mvm_undefined);
}

Napi::Value NativeVM::newBoolean(const Napi::CallbackInfo& info) {
  if (info.Length() < 1) {
    return VM::Value::wrap(vm, mvm_newBoolean(false));
  }
  auto arg = info[0];
  return VM::Value::wrap(vm, mvm_newBoolean(arg.ToBoolean().Value()));
}

Napi::Value NativeVM::uint8ArrayFromBytes(const Napi::CallbackInfo& info) {
  auto env = info.Env();
  auto arg = info[0];
    if (!arg.IsBuffer()) {
    Napi::TypeError::New(env, "Expected argument of newUint8Array to be a buffer")
      .ThrowAsJavaScriptException();
    return env.Undefined();
  }
  Napi::Buffer<uint8_t> buffer = arg.As<Napi::Buffer<uint8_t>>();
  size_t size = buffer.ByteLength();

  mvm_Value result = mvm_uint8ArrayFromBytes(vm, buffer.Data(), size);
  return VM::Value::wrap(vm, result);
}

Napi::Value NativeVM::getMemoryStats(const Napi::CallbackInfo& info) {
  mvm_TsMemoryStats stats;
  mvm_getMemoryStats(vm, &stats);
  auto env = info.Env();
  auto result = Napi::Object::New(env);
  result.Set("totalSize", Napi::Number::New(env, stats.totalSize));
  result.Set("fragmentCount", Napi::Number::New(env, stats.fragmentCount));
  result.Set("coreSize", Napi::Number::New(env, stats.coreSize));
  result.Set("importTableSize", Napi::Number::New(env, stats.importTableSize));
  result.Set("globalVariablesSize", Napi::Number::New(env, stats.globalVariablesSize));
  result.Set("registersSize", Napi::Number::New(env, stats.registersSize));
  result.Set("stackHeight", Napi::Number::New(env, stats.stackHeight));
  result.Set("stackAllocatedCapacity", Napi::Number::New(env, stats.stackAllocatedCapacity));
  result.Set("stackHighWaterMark", Napi::Number::New(env, stats.stackHighWaterMark));
  result.Set("virtualHeapUsed", Napi::Number::New(env, stats.virtualHeapUsed));
  result.Set("virtualHeapHighWaterMark", Napi::Number::New(env, stats.virtualHeapHighWaterMark));
  result.Set("virtualHeapAllocatedCapacity", Napi::Number::New(env, stats.virtualHeapAllocatedCapacity));
  return result;
}

Napi::Value NativeVM::asyncStart(const Napi::CallbackInfo& info) {
  auto env = info.Env();
  if (!pResult) {
    Napi::Error::New(env, "vm.asyncStart can only be called from within a host function that is called from the VM").ThrowAsJavaScriptException();
    return env.Undefined();
  }

  mvm_Value callback = mvm_asyncStart(vm, pResult);
  pResult = nullptr; // No longer let the user set the result
  return VM::Value::wrap(vm, callback);
}

Napi::Value NativeVM::stopAfterNInstructions(const Napi::CallbackInfo& info) {

  Napi::Env env = info.Env();
  if (info.Length() < 1) {
    Napi::Error::New(env, "Expected argument `n`")
      .ThrowAsJavaScriptException();
    return env.Undefined();
  }

  auto arg = info[0];
  if (!arg.IsNumber()) {
    Napi::TypeError::New(env, "Expected argument `n` to be a number")
      .ThrowAsJavaScriptException();
    return env.Undefined();
  }

  auto n = arg.ToNumber().Int32Value();

  mvm_stopAfterNInstructions(vm, n);

  return env.Undefined();
}

Napi::Value NativeVM::getInstructionCountRemaining(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();

  int32_t n = mvm_getInstructionCountRemaining(vm);

  return Napi::Number::New(env, n);
}

Napi::Value NativeVM::typeOf(const Napi::CallbackInfo& info) {
  auto env = info.Env();
  auto arg = info[0];
  if (!VM::Value::isVMValue(arg)) {
    Napi::TypeError::New(env, "Expected first argument to be a NativeVM `Value`")
      .ThrowAsJavaScriptException();
    return env.Undefined();
  }
  mvm_Value argUnwrapped = VM::Value::unwrap(arg);
  mvm_TeType typeCode = mvm_typeOf(vm, argUnwrapped);
  return Napi::Number::New(env, typeCode);
}

Napi::Value NativeVM::newString(const Napi::CallbackInfo& info) {
  auto env = info.Env();
  if (info.Length() < 1) {
    Napi::TypeError::New(env, "Expected a string argument")
      .ThrowAsJavaScriptException();
    return env.Undefined();
  }
  auto arg = info[0];
  auto s = arg.ToString().Utf8Value();
  return VM::Value::wrap(vm, mvm_newString(vm, &s[0], s.size()));
}

Napi::Value NativeVM::newNumber(const Napi::CallbackInfo& info) {
  auto env = info.Env();
  if (info.Length() < 1) {
    Napi::TypeError::New(env, "Expected a number argument")
      .ThrowAsJavaScriptException();
    return env.Undefined();
  }
  auto arg = info[0];
  auto n = arg.ToNumber().DoubleValue();
  return VM::Value::wrap(vm, mvm_newNumber(vm, n));
}

void NativeVM::runGC(const Napi::CallbackInfo& info) {
  // auto env = info.Env();
  bool squeeze = false;
  if (info.Length() >= 1) {
    squeeze = info[0].ToBoolean().Value();
  }
  mvm_runGC(this->vm, squeeze);
}

Napi::Value NativeVM::createSnapshot(const Napi::CallbackInfo& info) {
  size_t size;
  uint8_t* bytecode = (uint8_t*)mvm_createSnapshot(this->vm, &size);
  auto buffer = Napi::Buffer<uint8_t>::Copy(info.Env(), bytecode, size);
  free(bytecode);
  return buffer;
}

Napi::Value NativeVM::call(const Napi::CallbackInfo& info) {
  mvm_TeError err;
  auto env = info.Env();

  if (info.Length() < 2) {
    Napi::Error::New(env, "Expected 2 arguments")
      .ThrowAsJavaScriptException();
    return env.Undefined();
  }

  auto funcArg = info[0];
  if (!VM::Value::isVMValue(funcArg)) {
    Napi::TypeError::New(env, "Expected first argument to be a NativeVM `Value`")
      .ThrowAsJavaScriptException();
    return env.Undefined();
  }
  mvm_Value funcArgVMValue = VM::Value::unwrap(funcArg);

  auto argsArg = info[1];
  if (!argsArg.IsArray()) {
    Napi::TypeError::New(env, "Expected second argument to be an array of NativeVM `Value`s")
      .ThrowAsJavaScriptException();
    return env.Undefined();
  }
  auto argsArray = argsArg.As<Napi::Array>();
  auto argsLength = argsArray.Length();
  std::vector<mvm_Value> args;
  for (uint32_t i = 0; i < argsLength; i++) {
    auto argsItem = argsArray.Get(i);
    if (!VM::Value::isVMValue(argsItem)) {
      Napi::TypeError::New(env, "Expected second argument to be an array of NativeVM `Value`s")
        .ThrowAsJavaScriptException();
      return env.Undefined();
    }
    mvm_Value argValue = VM::Value::unwrap(argsItem);
    args.push_back(argValue);
  }

  mvm_Value result;
  if (args.size())
    err = mvm_call(vm, funcArgVMValue, &result, &args[0], args.size());
  else
    err = mvm_call(vm, funcArgVMValue, &result, nullptr, 0);
  if (err != MVM_E_SUCCESS) {
    if (this->error) {
      std::unique_ptr<Napi::Error> err(std::move(this->error));
      err->ThrowAsJavaScriptException();
      return env.Undefined();
    }
    if (err == MVM_E_UNCAUGHT_EXCEPTION) {
      // TODO: I actually want to be throwing the result, not the error wrapper, but I couldn't figure out how to do that.
      //assert(false);
      //auto exception = VM::Value::wrap(vm, result);
      //napi_throw(_env, exception);
      //throw exception;
      auto errStr = mvm_toStringUtf8(vm, result, NULL);
      Napi::Error::New(env, errStr).ThrowAsJavaScriptException();
      return env.Undefined();
    }
    throwVMError(env, err);
    return env.Undefined();
  }

  return VM::Value::wrap(vm, result);
}

NativeVM::~NativeVM() {
  if (this->vm) {
    mvm_free(this->vm);
    this->vm = nullptr;
  }
}

mvm_TeError NativeVM::resolveImportHandler(mvm_HostFunctionID hostFunctionID, void* context, mvm_TfHostFunction* out_hostFunction) {
  NativeVM* self = (NativeVM*)context;
  try {
    auto env = self->resolveImport.Env();
    auto global = env.Global();
    auto result = self->resolveImport.Call(global, {
      Napi::Number::New(env, hostFunctionID)
    });

    if (!result.IsFunction()) {
      Napi::TypeError::New(env, "Resolved import handler must be a function")
        .ThrowAsJavaScriptException();
      return MVM_E_HOST_ERROR;
    }

    auto hostFunction = result.As<Napi::Function>();

    self->importTable[hostFunctionID] = Napi::Persistent(hostFunction);

    // All host calls go through a common handler
    *out_hostFunction = &NativeVM::hostFunctionHandler;

    return MVM_E_SUCCESS;
  }
  catch (Napi::Error& e) {
    self->error.reset(new Napi::Error(e));
    return MVM_E_HOST_ERROR;
  }
  catch (...) {
    return MVM_E_HOST_ERROR;
  }
}

mvm_TeError NativeVM::hostFunctionHandler(mvm_VM* vm, mvm_HostFunctionID hostFunctionID, mvm_Value* pResult, mvm_Value* args, uint8_t argCount) {
  NativeVM* self = (NativeVM*)mvm_getContext(vm);

  // While the host function is active, we have access to
  ResultPointerScope resultPointerScope(self->pResult, pResult);

  auto handlerIter = self->importTable.find(hostFunctionID);
  if (handlerIter == self->importTable.end()) {
    // This should never happen because the bytecode should resolve all its
    // imports upfront, so they should be in the import table.
    return MVM_E_FUNCTION_NOT_FOUND;
  }

  auto& handler(handlerIter->second);
  auto env(handler.Env());

  auto innerArgs = Napi::Array::New(env);

  for (uint32_t i = 0; i < argCount; i++) {
    auto arg = args[i];
    innerArgs.Set(i, VM::Value::wrap(vm, arg));
  }

  auto resultValue = handler.Call(env.Global(), { innerArgs });

  if (!VM::Value::isVMValue(resultValue)) {
    return MVM_E_HOST_RETURNED_INVALID_VALUE;
  }

  // Note: will be null if `asyncStart` has written to the return value instead
  if (self->pResult != nullptr) {
    *pResult = VM::Value::unwrap(resultValue);
  }

  return MVM_E_SUCCESS; // TODO(high): Error handling -- catch exceptions?
}

Napi::Value NativeVM::resolveExport(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();

  if (info.Length() < 1) {
    Napi::Error::New(env, "Expected exportID argument")
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
    Napi::RangeError::New(env, "exportID out of range")
      .ThrowAsJavaScriptException();
    return env.Undefined();
  }

  mvm_VMExportID exportID = exportIDInt32;
  mvm_Value result;
  mvm_TeError err = mvm_resolveExports(vm, &exportID, &result, 1);
  if (err != MVM_E_SUCCESS) {
    throwVMError(env, err);
    return env.Undefined();
  }

  return VM::Value::wrap(vm, result);
}

void NativeVM::setCoverageCallback(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();

  if (info.Length() < 1) {
    Napi::Error::New(env, "Expected callback argument")
      .ThrowAsJavaScriptException();
    return;
  }

  auto callbackArgument = info[0];

  if (callbackArgument.IsUndefined()) {
    coverageCallback.Reset();
    return;
  }

  if (!callbackArgument.IsFunction()) {
    Napi::TypeError::New(env, "Expected callback to be a function or undefined")
      .ThrowAsJavaScriptException();
    return;
  }

  auto func = callbackArgument.As<Napi::Function>();

  coverageCallback.Reset(func, 1);
}

void NativeVM::fatalError(int error) {
  std::string errorMessage = "Microvium error code " + std::to_string(error);
  // Find the error description from the map
  mvm_TeError errCode = static_cast<mvm_TeError>(error);
  auto it = errorDescriptions.find(errCode);
  if (it != errorDescriptions.end()) {
    // Create the error message
    errorMessage = errorMessage + ": " + it->second;
  }

  // At one point I tried to throw this as a JavaScript exception, but there are
  // issues with reentrancy and having the VM in a consistent state, so now we
  // just terminate the host process by throwing a C++ exception.
  throw std::runtime_error(errorMessage);
  // Napi::Error::New(env, errorMessage).ThrowAsJavaScriptException();
}

// Called by VM
extern "C" void codeCoverage(int id, int mode, int indexInTable, int tableSize, int line) {
  if (!NativeVM::coverageCallback) return;

  try {
    auto env = NativeVM::coverageCallback.Env();
    auto global = env.Global();
    NativeVM::coverageCallback.Call(global, {
      Napi::Number::New(env, id),
      Napi::Number::New(env, mode),
      Napi::Number::New(env, indexInTable),
      Napi::Number::New(env, tableSize),
      Napi::Number::New(env, line),
    });
  }
  catch (...) {
    MVM_FATAL_ERROR(nullptr, 1);
  }
}

extern "C" void fatalError(void* vm_, int error) {
  mvm_VM* vm = (mvm_VM*)vm_;
  // If there's no VM then we don't know how to throw the error
  if (!vm) {
    assert(false);
    exit(error);
  }

  NativeVM* self = (NativeVM*)mvm_getContext(vm);
  self->fatalError(error);
}

