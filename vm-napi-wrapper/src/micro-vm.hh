#pragma once

#include <memory>
#include <map>
#include <napi.h>
#include "../../vm/vm.h"

class MicroVM : public Napi::ObjectWrap<MicroVM> {
public:
    MicroVM(const Napi::CallbackInfo&);
    MicroVM::~MicroVM();
    static Napi::Function GetClass(Napi::Env);
private:
    static vm_TeError resolveImportHandler(vm_HostFunctionID hostFunctionID, void* context, vm_TfHostFunction* out_hostFunction);
    static vm_TeError hostFunctionHandler(vm_VM* vm, vm_HostFunctionID hostFunctionID, vm_Value* result, vm_Value* args, uint8_t argCount);

    vm_VM* vm;
    uint8_t* bytecode;
    Napi::FunctionReference resolveImport;
    std::map<vm_HostFunctionID, Napi::FunctionReference> importTable;
};
