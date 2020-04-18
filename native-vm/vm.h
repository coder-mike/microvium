#pragma once

#include <stdbool.h>
#include <stdint.h>
#include "vm_port.h"

typedef uint16_t vm_Value;
typedef uint16_t vm_VMExportID;
typedef uint16_t vm_HostFunctionID;

typedef enum vm_TeError {
  VM_E_SUCCESS,
  VM_E_UNEXPECTED,
  VM_E_MALLOC_FAIL,
  VM_E_ALLOCATION_TOO_LARGE,
  VM_E_INVALID_ADDRESS,
  VM_E_COPY_ACROSS_BUCKET_BOUNDARY,
  VM_E_FUNCTION_NOT_FOUND,
  VM_E_INVALID_HANDLE,
  VM_E_STACK_OVERFLOW,
  VM_E_UNRESOLVED_IMPORT,
  VM_E_ATTEMPT_TO_WRITE_TO_ROM,
  VM_E_INVALID_ARGUMENTS,
  VM_E_TYPE_ERROR,
  VM_E_TARGET_NOT_CALLABLE,
  VM_E_HOST_ERROR,
  VM_E_NOT_IMPLEMENTED,
  VM_E_HOST_RETURNED_INVALID_VALUE,
  VM_E_ASSERTION_FAILED,
  VM_E_INVALID_BYTECODE,
} vm_TeError;

typedef enum vm_TeType {
  VM_T_UNDEFINED,
  VM_T_NULL,
  VM_T_BOOLEAN,
  VM_T_NUMBER,
  VM_T_STRING,
  VM_T_BIG_INT,
  VM_T_SYMBOL,
  VM_T_FUNCTION,
  VM_T_OBJECT,
  VM_T_ARRAY,
} vm_TeType;

typedef struct vm_VM vm_VM;

typedef vm_TeError (*vm_TfHostFunction)(vm_VM* vm, vm_HostFunctionID hostFunctionID, vm_Value* result, vm_Value* args, uint8_t argCount);

typedef vm_TeError (*vm_TfResolveImport)(vm_HostFunctionID hostFunctionID, void* context, vm_TfHostFunction* out_hostFunction);

typedef struct vm_GCHandle { struct vm_GCHandle* _next; vm_Value _value; } vm_GCHandle;

#ifdef __cplusplus
extern "C" {
#endif

/** Restore the state of a virtual machine from a snapshot */
vm_TeError vm_restore(vm_VM** result, VM_PROGMEM_P snapshotBytecode, size_t bytecodeSize, void* context, vm_TfResolveImport resolveImport);
void vm_free(vm_VM* vm);

vm_TeError vm_call(vm_VM* vm, vm_Value func, vm_Value* out_result, vm_Value* args, uint8_t argCount);

void* vm_getContext(vm_VM* vm);

void vm_initializeGCHandle(vm_VM* vm, vm_GCHandle* handle); // Handle must be released by vm_releaseGCHandle
void vm_cloneGCHandle(vm_VM* vm, vm_GCHandle* target, const vm_GCHandle* source); // Target must be released by vm_releaseGCHandle
vm_TeError vm_releaseGCHandle(vm_VM* vm, vm_GCHandle* handle);
static inline vm_Value* vm_handleValue(vm_VM* vm, vm_GCHandle* handle) { return &handle->_value; }

/**
 * Roughly like the `typeof` operator in JS, except with distinct values for
 * null and arrays
 */
vm_TeType vm_typeOf(vm_VM* vm, vm_Value value);

/**
 * Returns the size of a VM string in bytes when encoded as UTF-8.
 *
 * Note: This doesn't include a null terminator unless the original string has a
 * null terminator, e.g. `print('Hello, World!\0')`
 *
 * Note: Strings are internally encoded as UTF-8, so this function does not
 * perform any transcoding.
 *
 * Returns VM_E_TYPE_ERROR if the value is a not a string.
 */
vm_TeError vm_stringSizeUtf8(vm_VM* vm, vm_Value stringValue, size_t* out_size);

/**
 * Reads the data from a VM string, encoding it as UTF-8.
 *
 * Returns VM_E_TYPE_ERROR if the value is a not a string.
 *
 * Note: This doesn't include a null terminator unless the original string has a
 * null terminator, e.g. `print('Hello, World!\0')`
 *
 * If size does not match, the result will be padded or truncated accordingly.
 *
 * Note: Strings are internally encoded as UTF-8, so this function does not
 * perform any transcoding.
 */
vm_TeError vm_stringReadUtf8(vm_VM* vm, char* target, vm_Value stringValue, size_t size);

void vm_setUndefined(vm_VM* vm, vm_Value* target);
void vm_setNull(vm_VM* vm, vm_Value* target);
void vm_setBoolean(vm_VM* vm, vm_Value* target, bool source);
void vm_setInt32(vm_VM* vm, vm_Value* target, int32_t source);
void vm_setStringUtf8(vm_VM* vm, vm_Value* target, const char* sourceUtf8);

/**
 * Resolves (finds) the values exported by the VM, identified by ID.
 *
 * @param idTable An array of `count` IDs to look up.
 * @param resultTable An array of `count` output values that result from each
 * lookup
 *
 * Note: Exports are immutable (shallow immutable), so they don't need to be
 * captured by a vm_GCHandle. In typical usage, exports will each be function
 * values, but any value type is valid.
 */
// TODO: Is it actually worth it to pass in a whole table, instead of just
// exposing an API that resolves a single export? It should be up to the caller
// how the cache the results. A goal should be creating an API that's easy to
// understand.
vm_TeError vm_resolveExports(vm_VM* vm, const vm_VMExportID* idTable, vm_Value* resultTable, uint8_t count);

/** Run the garbage collector to free up memory. (Can only be executed when the VM is idle) */
void vm_runGC(vm_VM* vm);

// Must be implemented by host
// TODO: I think this should be done purely by returning error codes
void vm_error(vm_VM* vm, vm_TeError e);

#ifdef __cplusplus
}
#endif
