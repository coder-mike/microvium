#pragma once

#include <memory>
#include <napi.h>
#include "../../vm/vm.h"

class MicroVM : public Napi::ObjectWrap<MicroVM> {
public:
    MicroVM(const Napi::CallbackInfo&);
    MicroVM::~MicroVM();
    static Napi::Function GetClass(Napi::Env);
private:
    static vm_TeError resolveImport(vm_HostFunctionID hostFunctionID, void* context, vm_TfHostFunction* out_hostFunction);

    vm_VM* vm;
    uint8_t* bytecode;
};
