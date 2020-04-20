#pragma once

#include <stdbool.h>
#include <stdint.h>
#include "microvium_port.h"

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

/**
 * A handle holds a value that must not be garbage collected.
 */
typedef struct vm_Handle { struct vm_Handle* _next; vm_Value _value; } vm_Handle;

#ifdef __cplusplus
extern "C" {
#endif

/** Restore the state of a virtual machine from a snapshot */
vm_TeError vm_restore(vm_VM** result, VM_PROGMEM_P snapshotBytecode, size_t bytecodeSize, void* context, vm_TfResolveImport resolveImport);
void vm_free(vm_VM* vm);

vm_TeError vm_call(vm_VM* vm, vm_Value func, vm_Value* out_result, vm_Value* args, uint8_t argCount);

void* vm_getContext(vm_VM* vm);

void vm_initializeHandle(vm_VM* vm, vm_Handle* handle); // Handle must be released by vm_releaseHandle
void vm_cloneHandle(vm_VM* vm, vm_Handle* target, const vm_Handle* source); // Target must be released by vm_releaseHandle
vm_TeError vm_releaseHandle(vm_VM* vm, vm_Handle* handle);
static inline vm_Value vm_handleGet(vm_Handle* handle) { return handle->_value; }
static inline void vm_handleSet(vm_Handle* handle, vm_Value value) { handle->_value = value; }

/**
 * Roughly like the `typeof` operator in JS, except with distinct values for
 * null and arrays
 */
vm_TeType vm_typeOf(vm_VM* vm, vm_Value value);

/**
 * Converts the value to a string encoded as UTF-8.
 *
 * @param out_sizeBytes Returns the length of the string in bytes.
 * @return A pointer to the string data in VM memory.
 *
 * Note: for convenience, the returned data has an extra null character appended
 * to the end of it, so that the result is directly usable in printf, strcpy,
 * etc. The returned size in bytes is the size of the original string data,
 * excluding the extra null.
 *
 * The string data itself is permitted to contain nulls or any other data. For
 * example, if the string value is "abc\0", the size returned is "4", and the
 * returned pointer points to the data "abc\0\0" (i.e. with the extra safety
 * null beyond the user-provided data).
 *
 * The memory pointed to by the return value is transient: it is only guaranteed
 * to exist until the next garbage collection cycle. See
 * [memory-management.md](https://github.com/coder-mike/microvium/blob/master/doc/native-vm/memory-management.md)
 * for details.
 */
const char* vm_toStringUtf8(vm_VM* vm, vm_Value value, size_t* out_sizeBytes);

bool vm_toBool(vm_VM* vm, vm_Value value);

extern const vm_Value vm_undefined;
extern const vm_Value vm_null;
vm_Value vm_newBoolean(bool value);
vm_Value vm_newInt32(vm_VM* vm, int32_t value);
vm_Value vm_newString(vm_VM* vm, const char* valueUtf8, size_t sizeBytes);
vm_Value vm_newDouble(vm_VM* vm, VM_DOUBLE value);

/**
 * Resolves (finds) the values exported by the VM, identified by ID.
 *
 * @param ids An array of `count` IDs to look up.
 * @param results An array of `count` output values that result from each
 * lookup
 *
 * Note: Exports are immutable (shallow immutable), so they don't need to be
 * captured by a vm_Handle. In typical usage, exports will each be function
 * values, but any value type is valid.
 */
vm_TeError vm_resolveExports(vm_VM* vm, const vm_VMExportID* ids, vm_Value* results, uint8_t count);

/** Run the garbage collector to free up memory. (Can only be executed when the VM is idle) */
void vm_runGC(vm_VM* vm);

#ifdef __cplusplus
}
#endif
