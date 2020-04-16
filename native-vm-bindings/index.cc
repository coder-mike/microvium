#include "Value.hh"
#include "MicroVM.hh"

#include <napi.h>

// TODO: Read the V8 embed docs: https://v8.dev/docs/embed

// TODO: There are a million warnings when compiling the native module

// TODO: This might be a cleaner way to debug https://medium.com/@atulanand94/debugging-nodejs-c-addons-using-vs-code-27e9940fc3ad

// TODO: I think probably the native part of the project should be merged with
// the main project, since they share a lot of commonality and can probably even
// have the same API. It's probably also worth starting to think about how the
// entry point to the node library will look.

// TODO: Document the debug workflow for the project

// TODO: More clearly document the installation instructions with node-gyp (maybe run through them in a clean virtualbox or something)

// TODO: Consolidate the types for these native bindings with the other VM and with the runtime types.

Napi::Object Init(Napi::Env env, Napi::Object exports) {
  VM::MicroVM::Init(env, exports);
  VM::Value::Init(env, exports);

  return exports;
}

NODE_API_MODULE(addon, Init)
