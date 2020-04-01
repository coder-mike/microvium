#pragma once

#include <stdbool.h>
#include <stdint.h>
#include "vm_port.h"

typedef uint16_t vm_Value;
typedef uint16_t vm_VMFunctionID;
typedef uint16_t vm_HostFunctionID;

typedef enum vm_TeError {
  VM_E_SUCCESS,
  VM_E_UNEXPECTED,
  VM_E_MALLOC_FAIL,
  VM_E_ALLOCATION_TOO_LARGE,
  VM_E_INVALID_ADDRESS,
  VM_E_COPY_ACCROSS_BUCKET_BOUNDARY,
  VM_E_FUNCTION_NOT_FOUND,
  VM_E_INVALID_HANDLE,
  VM_E_STACK_OVERFLOW,
  VM_E_UNRESOLVED_IMPORT,
} vm_TeError;

typedef struct vm_VM vm_VM;

typedef vm_TeError (*vm_TfHostFunction)(vm_VM* vm, vm_Value* result, vm_Value* args, uint8_t argCount);

typedef struct vm_TsHostFunctionTableEntry {
  vm_HostFunctionID hostFunctionID;
  vm_TfHostFunction handler;
} vm_TsHostFunctionTableEntry;


typedef struct vm_GCHandle { struct vm_GCHandle* _next; vm_Value _value; } vm_GCHandle;


#ifdef __cplusplus
extern "C" {
#endif

vm_TeError vm_create(vm_VM** result, VM_PROGMEM_P bytecode, void* context, vm_TsHostFunctionTableEntry* hostFunctions, size_t hostFunctionCount);
void* vm_getContext(vm_VM* vm);
vm_TeError vm_call(vm_VM* vm, vm_Value func, vm_Value* out_result, vm_Value* args, uint8_t argCount);
void vm_free(vm_VM* vm);

void vm_initializeGCHandle(vm_VM* vm, vm_GCHandle* handle); // Must be released by vm_releaseGCHandle
void vm_cloneGCHandle(vm_VM* vm, vm_GCHandle* target, vm_GCHandle* source); // Must be released by vm_releaseGCHandle
vm_TeError vm_releaseGCHandle(vm_VM* vm, vm_GCHandle* handle);
static inline vm_Value* vm_handleValue(vm_VM* vm, vm_GCHandle* handle) { return &handle->_value; }

void vm_setUndefined(vm_VM* vm, vm_Value* handle);
void vm_setNull(vm_VM* vm, vm_Value* handle);
void vm_setBoolean(vm_VM* vm, vm_Value* handle, bool value);
void vm_setInt(vm_VM* vm, vm_Value* handle, int32_t value);
void vm_setString(vm_VM* vm, vm_Value* handle, const char* value);
vm_TeError vm_findFunction(vm_VM* vm, vm_VMFunctionID id, vm_Value* result);

/** Run the garbage collector to free up memory. (Can only be executed when the VM is idle) */
void vm_runGC(vm_VM* vm);

// Must be implemented by host
void vm_error(vm_VM* vm, vm_TeError e);

#ifdef __cplusplus
}
#endif
