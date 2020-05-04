#include "error_descriptions.hh"
#include "misc.hh"

void throwVMError(const Napi::Env& env, vm_TeError err) {
  auto errorDescription = errorDescriptions.find(err);
  if (errorDescription != errorDescriptions.end()) {
    Napi::Error::New(env, errorDescription->second)
      .ThrowAsJavaScriptException();
  } else {
    Napi::Error::New(env, std::string("VM error code: ") + std::to_string(err))
      .ThrowAsJavaScriptException();
  }
}
