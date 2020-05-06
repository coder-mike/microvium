/*
 * This file contains the Microvium virtual machine C implementation.
 *
 * For the moment, I'm keeping it all in one file for usability. User's can
 * treat this file as a black box that contains the VM, and there's only one
 * file they need to have built into their project in order to have Microvium
 * running.
 *
 * The two interfaces to this file are:
 *
 *   1. `microvium.h`, which is the interface from the user side (how to use the
 *      VM)
 *   2. `microvium_bytecode.h` which contains types related to the bytecode
 *      format.
 *
 * User-facing functions and definitions are all prefixed with `mvm_` to
 * namespace them separately from other functions in their project.
 *
 * Internal functions and definitions don't require a prefix, but for legacy
 * reasons, many have a `vm_` prefix. Perhaps this should be `ivm_` for
 * "internal VM".
 */

#include "microvium.h"

#include <ctype.h>

#include "microvium_internals.h"
#include "math.h"

static void vm_readMem(VM* vm, void* target, vm_Pointer source, uint16_t size);
static void vm_writeMem(VM* vm, vm_Pointer target, void* source, uint16_t size);

// Number of words on the stack required for saving the caller state
#define VM_FRAME_SAVE_SIZE_WORDS 3

static const vm_Pointer vpGCSpaceStart = 0x4000;

// TODO: I think we can remove `vm_` from the internal methods and use `mvm_` for the external
static bool vm_isHandleInitialized(VM* vm, const mvm_Handle* handle);
static void* vm_deref(VM* vm, Value pSrc);
static TeError vm_run(VM* vm);
static void vm_push(VM* vm, uint16_t value);
static uint16_t vm_pop(VM* vm);
static TeError vm_setupCallFromExternal(VM* vm, Value func, Value* args, uint8_t argCount);
static Value vm_binOp1Slow(VM* vm, vm_TeBinOp1 op, Value left, Value right);
static Value vm_binOp2(VM* vm, vm_TeBinOp2 op, Value left, Value right);
static Value vm_unOp(VM* vm, vm_TeUnOp op, Value arg);
static Value vm_convertToString(VM* vm, Value value);
static Value vm_concat(VM* vm, Value left, Value right);
static Value vm_convertToNumber(VM* vm, Value value);
static Value vm_addNumbersSlow(VM* vm, Value left, Value right);
static ivm_TeTypeCode deepTypeOf(VM* vm, Value value);
static bool vm_isString(VM* vm, Value value);
static VM_DOUBLE vm_readDouble(VM* vm, ivm_TeTypeCode type, Value value);
static int32_t vm_readInt32(VM* vm, ivm_TeTypeCode type, Value value);
static inline vm_HeaderWord vm_readHeaderWord(VM* vm, vm_Pointer pAllocation);
static inline uint16_t vm_readUInt16(VM* vm, vm_Pointer p);
static TeError vm_resolveExport(VM* vm, mvm_VMExportID id, Value* result);
static inline mvm_TfHostFunction* vm_getResolvedImports(VM* vm);
static inline uint16_t vm_getResolvedImportCount(VM* vm);
static ivm_TeTypeCode shallowTypeOf(Value value);
static void gc_createNextBucket(VM* vm, uint16_t bucketSize);
static Value gc_allocate(VM* vm, uint16_t sizeBytes, ivm_TeTypeCode typeCode, uint16_t headerVal2, void** out_target);
static void gc_markAllocation(uint16_t* markTable, GO_t p, uint16_t size);
static void gc_traceValue(VM* vm, uint16_t* markTable, Value value, uint16_t* pTotalSize);
static inline void gc_updatePointer(VM* vm, uint16_t* pWord, uint16_t* markTable, uint16_t* offsetTable);
static inline bool gc_isMarked(uint16_t* markTable, vm_Pointer ptr);
static void gc_freeGCMemory(VM* vm);
static void* gc_deref(VM* vm, vm_Pointer vp);
static Value vm_allocString(VM* vm, size_t sizeBytes, void** data);
static TeError getProperty(VM* vm, Value objectValue, Value propertyName, Value* propertyValue);
static TeError toPropertyName(VM* vm, Value* value);
static Value toUniqueString(VM* vm, Value value);
static int memcmp_pgm(void* p1, VM_PROGMEM_P p2, size_t size);
static VM_PROGMEM_P pgm_deref(VM* vm, vm_Pointer vp);
static uint16_t vm_stringSizeUtf8(VM* vm, Value str);
static Value uintToStr(VM* vm, uint16_t i);
static bool vm_stringIsNonNegativeInteger(VM* vm, Value str);

const Value mvm_undefined = VM_VALUE_UNDEFINED;
const Value vm_null = VM_VALUE_NULL;

static inline ivm_TeTypeCode vm_typeCodeFromHeaderWord(vm_HeaderWord headerWord) {
  return (ivm_TeTypeCode)(headerWord >> 12);
}

static inline uint16_t vm_paramOfHeaderWord(vm_HeaderWord headerWord) {
  return headerWord & 0xFFF;
}

static inline Value vm_unbox(VM* vm, vm_Pointer boxed) {
  return vm_readUInt16(vm, boxed);
}

// Returns the type information obtainable without dereferencing
static ivm_TeTypeCode shallowTypeOf(Value value) {
  uint16_t tag = VM_TAG_OF(value);
  if (tag == VM_TAG_INT) return TC_INT14;
  if (tag == VM_TAG_PGM_P) {
    if (value < VM_VALUE_MAX_WELLKNOWN)
      return (ivm_TeTypeCode)(value - VM_TAG_PGM_P);
  }
  return TC_POINTER;
}

TeError mvm_restore(mvm_VM** result, VM_PROGMEM_P pBytecode, size_t bytecodeSize, void* context, mvm_TfResolveImport resolveImport) {
  mvm_TfHostFunction* resolvedImports;
  mvm_TfHostFunction* resolvedImport;
  uint16_t* dataMemory;
  VM_PROGMEM_P pImportTableStart;
  VM_PROGMEM_P pImportTableEnd;
  VM_PROGMEM_P pImportTableEntry;
  BO_t initialDataOffset;
  BO_t initialHeapOffset;
  uint16_t initialDataSize;
  uint16_t initialHeapSize;

  #if VM_SAFE_MODE
    uint16_t x = 0x4243;
    bool isLittleEndian = ((uint8_t*)&x)[0] == 0x43;
    VM_ASSERT(NULL, isLittleEndian);
  #endif
  // TODO(low): CRC validation on input code

  TeError err = MVM_E_SUCCESS;
  VM* vm = NULL;

  // Bytecode size field is located at the second word
  if (bytecodeSize < 4) return MVM_E_INVALID_BYTECODE;
  uint16_t expectedBytecodeSize = VM_READ_BC_2_HEADER_FIELD(bytecodeSize, pBytecode);
  if (bytecodeSize != expectedBytecodeSize) return MVM_E_INVALID_BYTECODE;
  uint8_t headerSize = VM_READ_BC_1_HEADER_FIELD(headerSize, pBytecode);
  if (bytecodeSize < headerSize) return MVM_E_INVALID_BYTECODE;
  // For the moment we expect an exact header size
  if (headerSize != sizeof (mvm_TsBytecodeHeader)) return MVM_E_INVALID_BYTECODE;

  uint8_t bytecodeVersion = VM_READ_BC_1_HEADER_FIELD(bytecodeVersion, pBytecode);
  if (bytecodeVersion != VM_BYTECODE_VERSION) return MVM_E_INVALID_BYTECODE;

  uint16_t dataMemorySize = VM_READ_BC_2_HEADER_FIELD(dataMemorySize, pBytecode);
  uint16_t importTableOffset = VM_READ_BC_2_HEADER_FIELD(importTableOffset, pBytecode);
  uint16_t importTableSize = VM_READ_BC_2_HEADER_FIELD(importTableSize, pBytecode);

  uint16_t importCount = importTableSize / sizeof (vm_TsImportTableEntry);

  size_t allocationSize = sizeof(mvm_VM) +
    sizeof(mvm_TfHostFunction) * importCount +  // Import table
    dataMemorySize; // Data memory (globals)
  vm = malloc(allocationSize);
  if (!vm) {
    err = MVM_E_MALLOC_FAIL;
    goto EXIT;
  }
  #if VM_SAFE_MODE
    memset(vm, 0, allocationSize);
  #else
    memset(vm, 0, sizeof (mvm_VM));
  #endif
  resolvedImports = vm_getResolvedImports(vm);
  vm->context = context;
  vm->pBytecode = pBytecode;
  vm->dataMemory = (void*)(resolvedImports + importCount);
  vm->uniqueStrings = VM_VALUE_NULL;

  pImportTableStart = VM_PROGMEM_P_ADD(pBytecode, importTableOffset);
  pImportTableEnd = VM_PROGMEM_P_ADD(pImportTableStart, importTableSize);
  // Resolve imports (linking)
  resolvedImport = resolvedImports;
  pImportTableEntry = pImportTableStart;
  while (pImportTableEntry < pImportTableEnd) {
    mvm_HostFunctionID hostFunctionID = VM_READ_PROGMEM_2(pImportTableEntry);
    pImportTableEntry = VM_PROGMEM_P_ADD(pImportTableEntry, sizeof (vm_TsImportTableEntry));
    mvm_TfHostFunction handler = NULL;
    err = resolveImport(hostFunctionID, context, &handler);
    if (err != MVM_E_SUCCESS) goto EXIT;
    if (!handler) {
      err = MVM_E_UNRESOLVED_IMPORT;
      goto EXIT;
    }
    *resolvedImport++ = handler;
  }

  // The GC is empty to start
  gc_freeGCMemory(vm);

  // Initialize data
  initialDataOffset = VM_READ_BC_2_HEADER_FIELD(initialDataOffset, pBytecode);
  initialDataSize = VM_READ_BC_2_HEADER_FIELD(initialDataSize, pBytecode);
  dataMemory = vm->dataMemory;
  VM_ASSERT(vm, initialDataSize <= dataMemorySize);
  VM_READ_BC_N_AT(dataMemory, initialDataOffset, initialDataSize, pBytecode);

  // Initialize heap
  initialHeapOffset = VM_READ_BC_2_HEADER_FIELD(initialHeapOffset, pBytecode);
  initialHeapSize = VM_READ_BC_2_HEADER_FIELD(initialHeapSize, pBytecode);
  if (initialHeapSize) {
    gc_createNextBucket(vm, initialHeapSize);
    VM_ASSERT(vm, !vm->pLastBucket->prev); // Only one bucket
    uint8_t* heapStart = vm->pAllocationCursor;
    VM_READ_BC_N_AT(heapStart, initialHeapOffset, initialHeapSize, pBytecode);
    vm->vpAllocationCursor += initialHeapSize;
    vm->pAllocationCursor += initialHeapSize;
  }

EXIT:
  if (err != MVM_E_SUCCESS) {
    *result = NULL;
    if (vm) {
      free(vm);
      vm = NULL;
    }
  }
  *result = vm;
  return err;
}

void* mvm_getContext(VM* vm) {
  return vm->context;
}

static const Value smallLiterals[] = {
  /* VM_SLV_NULL */         VM_VALUE_NULL,
  /* VM_SLV_UNDEFINED */    VM_VALUE_UNDEFINED,
  /* VM_SLV_FALSE */        VM_VALUE_FALSE,
  /* VM_SLV_TRUE */         VM_VALUE_TRUE,
  /* VM_SLV_INT_0 */        VM_TAG_INT | 0,
  /* VM_SLV_INT_1 */        VM_TAG_INT | 1,
  /* VM_SLV_INT_2 */        VM_TAG_INT | 2,
  /* VM_SLV_INT_MINUS_1 */  VM_TAG_INT | ((uint16_t)(-1) & VM_VALUE_MASK),
};


static TeError vm_run(VM* vm) {
  // These "parameters" are different parts of the source instruction
  uint8_t param1;
  uint8_t param2;
  uint8_t u8Param3;
  int16_t s16Param3;
  uint16_t u16Param3;

  uint16_t callTargetFunctionOffset;
  uint16_t callTargetHostFunctionIndex;
  uint8_t callArgCount;
  int16_t branchOffset;
  int16_t jumpOffset;
  uint16_t result;
  uint16_t u16Temp1;
  uint8_t u8Temp1;

  VM_SAFE_CHECK_NOT_NULL(vm);
  VM_SAFE_CHECK_NOT_NULL(vm->stack);

  #define CACHE_REGISTERS() do { \
    programCounter = VM_PROGMEM_P_ADD(pBytecode, reg->programCounter); \
    argCount = reg->argCount; \
    pFrameBase = reg->pFrameBase; \
    pStackPointer = reg->pStackPointer; \
  } while (false)

  #define FLUSH_REGISTER_CACHE() do { \
    reg->programCounter = (BO_t)VM_PROGMEM_P_SUB(programCounter, pBytecode); \
    reg->argCount = argCount; \
    reg->pFrameBase = pFrameBase; \
    reg->pStackPointer = pStackPointer; \
  } while (false)

  #define VALUE_TO_BOOL(result, value) do { \
    if (VM_IS_INT14(value)) result = value != 0; \
    else if (value == VM_VALUE_TRUE) result = true; \
    else if (value == VM_VALUE_FALSE) result = false; \
    else result = mvm_toBool(vm, value); \
  } while (false)

  #define READ_PGM_1() ( \
    u8Temp1 = VM_READ_PROGMEM_1(programCounter), \
    programCounter = VM_PROGMEM_P_ADD(programCounter, 1), \
    u8Temp1 \
  )

  #define READ_PGM_2() ( \
    u16Temp1 = VM_READ_PROGMEM_2(programCounter), \
    programCounter = VM_PROGMEM_P_ADD(programCounter, 2), \
    u16Temp1 \
  )

  #define PUSH(v) *(pStackPointer++) = v
  #define POP() (*(--pStackPointer))
  #define INSTRUCTION_RESERVED() VM_ASSERT(vm, false)

  // TODO(low): I'm not sure that these variables should be cached for the whole duration of vm_run rather than being calculated on demand
  vm_TsRegisters* reg = &vm->stack->reg;
  uint16_t* bottomOfStack = VM_BOTTOM_OF_STACK(vm);
  VM_PROGMEM_P pBytecode = vm->pBytecode;
  uint16_t* dataMemory = vm->dataMemory;
  TeError err = MVM_E_SUCCESS;

  uint16_t* pFrameBase;
  uint16_t argCount;
  register VM_PROGMEM_P programCounter;
  register uint16_t* pStackPointer;

  CACHE_REGISTERS();

  VM_EXEC_SAFE_MODE(
    uint16_t bytecodeSize = VM_READ_BC_2_HEADER_FIELD(bytecodeSize, vm->pBytecode);
    uint16_t stringTableOffset = VM_READ_BC_2_HEADER_FIELD(stringTableOffset, vm->pBytecode);
    uint16_t stringTableSize = VM_READ_BC_2_HEADER_FIELD(stringTableSize, vm->pBytecode);

    // It's an implementation detail that no code starts before the end of the string table
    VM_PROGMEM_P minProgramCounter = VM_PROGMEM_P_ADD(vm->pBytecode, (stringTableOffset + stringTableSize));
    VM_PROGMEM_P maxProgramCounter = VM_PROGMEM_P_ADD(vm->pBytecode, bytecodeSize);
  )

  // TODO(low): I think we need unit tests that explicitly test that every
  // instruction is implemented and has the correct behavior. I'm thinking the
  // way to do this would be to just replace all operation implementation with
  // some kind of abort, and then progressively re-enable the individually when
  // test cases hit them.

  while (true) {
    uint8_t temp = READ_PGM_1();
    param2 = temp & 0xF;
    param1 = (temp >> 4) & 0xF;
    VM_ASSERT(vm, param1 < VM_OP_END);
    SWITCH_CONTIGUOUS(param1, (VM_OP_END - 1)) {
      CASE_CONTIGUOUS (VM_OP_LOAD_SMALL_LITERAL):
        if (param2 >= sizeof smallLiterals / sizeof smallLiterals[0]) {
          return VM_UNEXPECTED_INTERNAL_ERROR(vm);
        }
        result = smallLiterals[param2];
        goto PUSH_RESULT;

      CASE_CONTIGUOUS (VM_OP_LOAD_VAR_1):
        result = pStackPointer[-param2 - 1];
        goto PUSH_RESULT;

      CASE_CONTIGUOUS (VM_OP_STORE_VAR_1):
        result = POP();
        pStackPointer[-param2 - 2] = result;
        break;

      CASE_CONTIGUOUS (VM_OP_LOAD_GLOBAL_1):
        result = dataMemory[param2];
        goto PUSH_RESULT;

      CASE_CONTIGUOUS (VM_OP_STORE_GLOBAL_1):
        result = POP();
        dataMemory[param2] = result;
        break;

      CASE_CONTIGUOUS (VM_OP_LOAD_ARG_1):
        if (param2 < argCount)
          result = pFrameBase[-3 - (int16_t)argCount + param2];
        else
          result = VM_VALUE_UNDEFINED;
        goto PUSH_RESULT;

      CASE_CONTIGUOUS (VM_OP_POP):
        pStackPointer -= param2;
        break;

      CASE_CONTIGUOUS (VM_OP_CALL_1): { // (+ 4-bit index into short-call table)
        {
          BO_t shortCallTableOffset = VM_READ_BC_2_HEADER_FIELD(shortCallTableOffset, pBytecode);
          VM_PROGMEM_P shortCallTableEntry = VM_PROGMEM_P_ADD(pBytecode, shortCallTableOffset + param2 * sizeof (vm_TsShortCallTableEntry));

          #if VM_SAFE_MODE
            uint16_t shortCallTableSize = VM_READ_BC_2_HEADER_FIELD(shortCallTableOffset, pBytecode);
            VM_PROGMEM_P shortCallTableEnd = VM_PROGMEM_P_ADD(pBytecode, shortCallTableOffset + shortCallTableSize);
            VM_ASSERT(vm, shortCallTableEntry < shortCallTableEnd);
          #endif

          uint16_t tempFunction = VM_READ_PROGMEM_2(shortCallTableEntry);
          shortCallTableEntry = VM_PROGMEM_P_ADD(shortCallTableEntry, 2);
          uint8_t tempArgCount = VM_READ_PROGMEM_1(shortCallTableEntry);


          // The high bit of function indicates if this is a call to the host
          bool isHostCall = tempFunction & 0x8000;
          tempFunction = tempFunction & 0x7FFF;

          callArgCount = tempArgCount;

          if (isHostCall) {
            callTargetHostFunctionIndex = tempFunction;
            goto CALL_HOST_COMMON;
          } else {
            callTargetFunctionOffset = tempFunction;
            goto CALL_COMMON;
          }
          break;
        }

        /*
        * CALL_HOST_COMMON
        *
        * Expects:
        *   callTargetHostFunctionIndex: index in import table,
        *   callArgCount: argument count
        */
        CALL_HOST_COMMON: {
          // Save caller state
          PUSH(pFrameBase - bottomOfStack);
          PUSH(argCount);
          PUSH((uint16_t)VM_PROGMEM_P_SUB(programCounter, pBytecode));

          // Set up new frame
          pFrameBase = pStackPointer;
          argCount = callArgCount;
          programCounter = pBytecode; // "null" (signifies that we're outside the VM)

          VM_ASSERT(vm, callTargetHostFunctionIndex < vm_getResolvedImportCount(vm));
          mvm_TfHostFunction hostFunction = vm_getResolvedImports(vm)[callTargetHostFunctionIndex];
          Value result = VM_VALUE_UNDEFINED;
          Value* args = pStackPointer - 3 - callArgCount;

          uint16_t importTableOffset = VM_READ_BC_2_HEADER_FIELD(importTableOffset, pBytecode);

          uint16_t importTableEntry = importTableOffset + callTargetHostFunctionIndex * sizeof (vm_TsImportTableEntry);
          mvm_HostFunctionID hostFunctionID = VM_READ_BC_2_AT(importTableEntry, pBytecode);

          FLUSH_REGISTER_CACHE();
          err = hostFunction(vm, hostFunctionID, &result, args, callArgCount);
          if (err != MVM_E_SUCCESS) goto EXIT;
          CACHE_REGISTERS();

          // Restore caller state
          programCounter = VM_PROGMEM_P_ADD(pBytecode, POP());
          argCount = POP();
          pFrameBase = bottomOfStack + POP();

          // Pop arguments
          pStackPointer -= callArgCount;

          // Pop function pointer
          (void)POP();
          // TODO(high): Not all host call operation will push the function
          // onto the stack, so it's invalid to just pop it here. A clean
          // solution may be to have a "flags" register which specifies things
          // about the current context, one of which will be whether the
          // function was called by pushing it onto the stack. This gets rid
          // of some of the different RETURN opcodes we have

          PUSH(result);
          break;
        }

        /*
        * CALL_COMMON
        *
        * Expects:
        *   callTargetFunctionOffset: offset of target function in bytecode
        *   callArgCount: number of arguments
        */
        CALL_COMMON: {
          uint16_t programCounterToReturnTo = (uint16_t)VM_PROGMEM_P_SUB(programCounter, pBytecode);
          programCounter = VM_PROGMEM_P_ADD(pBytecode, callTargetFunctionOffset);

          uint8_t maxStackDepth = READ_PGM_1();
          if (pStackPointer + (maxStackDepth + VM_FRAME_SAVE_SIZE_WORDS) > VM_TOP_OF_STACK(vm)) {
            err = MVM_E_STACK_OVERFLOW;
            goto EXIT;
          }

          // Save caller state (VM_FRAME_SAVE_SIZE_WORDS)
          PUSH(pFrameBase - bottomOfStack);
          PUSH(argCount);
          PUSH(programCounterToReturnTo);

          // Set up new frame
          pFrameBase = pStackPointer;
          argCount = callArgCount;

          break;
        }
      }


      CASE_CONTIGUOUS (VM_OP_STRUCT_GET_1): INSTRUCTION_RESERVED(); break;
      CASE_CONTIGUOUS (VM_OP_STRUCT_SET_1): INSTRUCTION_RESERVED(); break;

      CASE_CONTIGUOUS (VM_OP_BINOP_1): {
        Value right = POP();
        Value left = POP();
        result = VM_VALUE_UNDEFINED;
        VM_ASSERT(vm, param2 < VM_BOP1_END);
        SWITCH_CONTIGUOUS (param2, (VM_BOP1_END - 1)) {
          CASE_CONTIGUOUS (VM_BOP1_ADD): {
            if (((left & VM_TAG_MASK) == VM_TAG_INT) && ((right & VM_TAG_MASK) == VM_TAG_INT)) {
              result = left + right;
              if ((result & VM_OVERFLOW_BIT) == 0) break;
            }
            goto BIN_OP_1_SLOW;
          }
          CASE_CONTIGUOUS (VM_BOP1_SUBTRACT): VM_NOT_IMPLEMENTED(vm); break;
          CASE_CONTIGUOUS (VM_BOP1_MULTIPLY): VM_NOT_IMPLEMENTED(vm); break;
          CASE_CONTIGUOUS (VM_BOP1_DIVIDE): VM_NOT_IMPLEMENTED(vm); break;
          CASE_CONTIGUOUS (VM_BOP1_SHR_ARITHMETIC): VM_NOT_IMPLEMENTED(vm); break;
          CASE_CONTIGUOUS (VM_BOP1_SHR_BITWISE): VM_NOT_IMPLEMENTED(vm); break;
          CASE_CONTIGUOUS (VM_BOP1_SHL): VM_NOT_IMPLEMENTED(vm); break;
          CASE_CONTIGUOUS (VM_BOP1_REMAINDER): VM_NOT_IMPLEMENTED(vm); break;
          CASE_CONTIGUOUS (VM_BOP1_BITWISE_AND): VM_NOT_IMPLEMENTED(vm); break;
          CASE_CONTIGUOUS (VM_BOP1_BITWISE_OR): VM_NOT_IMPLEMENTED(vm); break;
          CASE_CONTIGUOUS (VM_BOP1_BITWISE_XOR): VM_NOT_IMPLEMENTED(vm); break;
        }
        goto PUSH_RESULT;
      BIN_OP_1_SLOW:
        FLUSH_REGISTER_CACHE();
        result = vm_binOp1Slow(vm, (vm_TeBinOp1)param2, left, right);
        CACHE_REGISTERS();
        goto PUSH_RESULT;
      }
      CASE_CONTIGUOUS (VM_OP_BINOP_2): {
        Value right = POP();
        Value left = POP();
        result = VM_VALUE_UNDEFINED;
        VM_ASSERT(vm, param2 < VM_BOP2_END);
        SWITCH_CONTIGUOUS (param2, (VM_BOP2_END - 1)) {
          CASE_CONTIGUOUS (VM_BOP2_LESS_THAN): VM_NOT_IMPLEMENTED(vm); break;
          CASE_CONTIGUOUS (VM_BOP2_GREATER_THAN): VM_NOT_IMPLEMENTED(vm); break;
          CASE_CONTIGUOUS (VM_BOP2_LESS_EQUAL): VM_NOT_IMPLEMENTED(vm); break;
          CASE_CONTIGUOUS (VM_BOP2_GREATER_EQUAL): VM_NOT_IMPLEMENTED(vm); break;
          CASE_CONTIGUOUS (VM_BOP2_EQUAL): VM_NOT_IMPLEMENTED(vm); break;
          CASE_CONTIGUOUS (VM_BOP2_NOT_EQUAL): VM_NOT_IMPLEMENTED(vm); break;
        }
        PUSH(result);
        break;
      //BIN_OP_2_SLOW:
        FLUSH_REGISTER_CACHE();
        result = vm_binOp2(vm, (vm_TeBinOp2)param2, left, right);
        CACHE_REGISTERS();
        PUSH(result);
        break;
      }

      CASE_CONTIGUOUS (VM_OP_UNOP): {
        Value arg = POP();
        result = VM_VALUE_UNDEFINED;
        VM_ASSERT(vm, param2 < VM_UOP_END);
        SWITCH_CONTIGUOUS (param2, (VM_UOP_END - 1)) {
          CASE_CONTIGUOUS (VM_UOP_NEGATE): {
            // TODO(feature): This needs to handle the overflow case of -(-2000)
            VM_NOT_IMPLEMENTED(vm);
            if (!VM_IS_INT14(arg)) goto UN_OP_SLOW;
            result = (-VM_SIGN_EXTEND(arg)) & VM_VALUE_MASK;
            break;
          }
          CASE_CONTIGUOUS (VM_UOP_LOGICAL_NOT): {
            bool b;
            VALUE_TO_BOOL(b, arg);
            result = b ? VM_VALUE_FALSE : VM_VALUE_TRUE;
            break;
          }
          CASE_CONTIGUOUS (VM_UOP_BITWISE_NOT): VM_NOT_IMPLEMENTED(vm); break;
        }
        break;
      UN_OP_SLOW:
        FLUSH_REGISTER_CACHE();
        result = vm_unOp(vm, (vm_TeUnOp)param2, arg);
        CACHE_REGISTERS();
        PUSH(result);
        break;
      }

      CASE_CONTIGUOUS (VM_OP_EXTENDED_1): {
        VM_ASSERT(vm, param2 <= VM_OP1_EXTENDED_4);
        SWITCH_CONTIGUOUS (param2, VM_OP1_EXTENDED_4) {
          CASE_CONTIGUOUS (VM_OP1_RETURN_1):
          CASE_CONTIGUOUS (VM_OP1_RETURN_2):
          CASE_CONTIGUOUS (VM_OP1_RETURN_3):
          CASE_CONTIGUOUS (VM_OP1_RETURN_4): {
            if (param2 & VM_RETURN_FLAG_UNDEFINED) result = VM_VALUE_UNDEFINED;
            else result = POP();

            uint16_t popArgCount = argCount;

            // Pop variables/parameters
            pStackPointer = pFrameBase;

            // Restore caller state
            programCounter = VM_PROGMEM_P_ADD(pBytecode, POP());
            argCount = POP();
            pFrameBase = bottomOfStack + POP();

            // Pop arguments
            pStackPointer -= popArgCount;
            // Pop function reference
            if (param2 & VM_RETURN_FLAG_POP_FUNCTION) (void)POP();

            PUSH(result);

            if (programCounter == pBytecode) goto EXIT;
            break;
          }

          CASE_CONTIGUOUS (VM_OP1_OBJECT_GET_1): {
            Value propertyName = POP();
            Value objectValue = POP();
            Value propertyValue;
            err = getProperty(vm, objectValue, propertyName, &propertyValue);
            if (err != MVM_E_SUCCESS) goto EXIT;
            PUSH(propertyValue);
            break;
          }
          CASE_CONTIGUOUS (VM_OP1_OBJECT_SET_1): INSTRUCTION_RESERVED(); break;
          CASE_CONTIGUOUS (VM_OP1_ASSERT): INSTRUCTION_RESERVED(); break;
          CASE_CONTIGUOUS (VM_OP1_NOT_IMPLEMENTED): INSTRUCTION_RESERVED(); break;
          CASE_CONTIGUOUS (VM_OP1_ILLEGAL_OPERATION): INSTRUCTION_RESERVED(); break;
          CASE_CONTIGUOUS (VM_OP1_PRINT): INSTRUCTION_RESERVED(); break;
          CASE_CONTIGUOUS (VM_OP1_ARRAY_GET): INSTRUCTION_RESERVED(); break;
          CASE_CONTIGUOUS (VM_OP1_ARRAY_SET): INSTRUCTION_RESERVED(); break;

          CASE_CONTIGUOUS (VM_OP1_EXTENDED_4): {
            // 1-byte instruction parameter
            uint8_t b = READ_PGM_1();
            switch (b) {
              case VM_OP4_CALL_DETACHED_EPHEMERAL: {
                VM_NOT_IMPLEMENTED(vm);
                break;
              }
              default: VM_UNEXPECTED_INTERNAL_ERROR(vm); break;
            }
          }
        }
        break;
      }
      CASE_CONTIGUOUS (VM_OP_EXTENDED_2): {
        // All the ex-2 instructions have an 8-bit parameter
        u8Param3 = READ_PGM_1();
        VM_ASSERT(vm, param2 < VM_OP2_END);
        SWITCH_CONTIGUOUS (param2, (VM_OP2_END - 1)) {
          CASE_CONTIGUOUS (VM_OP2_BRANCH_1): {
            branchOffset = (int8_t)u8Param3; // Sign extend
            goto BRANCH_COMMON;

            /*
             * BRANCH_COMMON
             *
             * Expects:
             *   - branchOffset: the amount to jump by if the predicate is truthy
             */
            BRANCH_COMMON: {
              Value predicate = POP();
              bool isTruthy;
              VALUE_TO_BOOL(isTruthy, predicate);
              if (isTruthy) programCounter = VM_PROGMEM_P_ADD(programCounter, branchOffset);
              break;
            }
          }
          CASE_CONTIGUOUS (VM_OP2_JUMP_1): {
            jumpOffset = (int8_t)u8Param3; // Sign extend
            goto JUMP_COMMON;

            /*
             * JUMP_COMMON
             *
             * Expects:
             *   - jumpOffset: the amount to jump by
             */
            JUMP_COMMON: {
              programCounter = VM_PROGMEM_P_ADD(programCounter, jumpOffset);
              break;
            }
          }

          CASE_CONTIGUOUS (VM_OP2_CALL_HOST): {
            callTargetHostFunctionIndex = u8Param3;
            callArgCount = READ_PGM_1();
            goto CALL_HOST_COMMON;
          }

          CASE_CONTIGUOUS (VM_OP2_LOAD_GLOBAL_2): VM_NOT_IMPLEMENTED(vm); break;
          CASE_CONTIGUOUS (VM_OP2_STORE_GLOBAL_2): VM_NOT_IMPLEMENTED(vm); break;
          CASE_CONTIGUOUS (VM_OP2_LOAD_VAR_2): VM_NOT_IMPLEMENTED(vm); break;
          CASE_CONTIGUOUS (VM_OP2_STORE_VAR_2): VM_NOT_IMPLEMENTED(vm); break;
          CASE_CONTIGUOUS (VM_OP2_STRUCT_GET_2): INSTRUCTION_RESERVED(); break;
          CASE_CONTIGUOUS (VM_OP2_STRUCT_SET_2): INSTRUCTION_RESERVED(); break;
          CASE_CONTIGUOUS (VM_OP2_LOAD_ARG_2): INSTRUCTION_RESERVED(); break;
          CASE_CONTIGUOUS (VM_OP2_STORE_ARG): INSTRUCTION_RESERVED(); break;

          CASE_CONTIGUOUS (VM_OP2_CALL_3): {
            callArgCount = u8Param3;

            // The function was pushed before the arguments
            Value functionValue = pStackPointer[-callArgCount - 1];

            ivm_TeTypeCode typeCode = shallowTypeOf(functionValue);
            if (typeCode != TC_POINTER) {
              err = MVM_E_TARGET_NOT_CALLABLE;
              goto EXIT;
            }

            uint16_t headerWord = vm_readHeaderWord(vm, functionValue);
            typeCode = vm_typeCodeFromHeaderWord(headerWord);
            if (typeCode == TC_FUNCTION) {
              VM_ASSERT(vm, VM_IS_PGM_P(functionValue));
              callTargetFunctionOffset = VM_VALUE_OF(functionValue);
              goto CALL_COMMON;
            }

            if (typeCode == TC_HOST_FUNC) {
              callTargetHostFunctionIndex = vm_readUInt16(vm, functionValue);
              goto CALL_HOST_COMMON;
            }

            err = MVM_E_TARGET_NOT_CALLABLE;
            goto EXIT;
          }
        }
        break;
      }
      CASE_CONTIGUOUS (VM_OP_EXTENDED_3):  {
        // Ex-3 instructions have a 16-bit parameter, which may be interpretted as signed or unsigned
        u16Param3 = READ_PGM_2();
        s16Param3 = (int16_t)u16Param3;
        VM_ASSERT(vm, param2 < VM_OP3_END);
        SWITCH_CONTIGUOUS (param2, (VM_OP3_END - 1)) {
          CASE_CONTIGUOUS (VM_OP3_CALL_2): {
            callTargetFunctionOffset = u16Param3;
            // This call instruction has an additional 8 bits for the argument count.
            callArgCount = READ_PGM_1();
            goto CALL_COMMON;
          }

          CASE_CONTIGUOUS (VM_OP3_JUMP_2): {
            jumpOffset = s16Param3;
            goto JUMP_COMMON;
          }

          CASE_CONTIGUOUS (VM_OP3_BRANCH_2): {
            branchOffset = s16Param3;
            goto BRANCH_COMMON;
          }

          CASE_CONTIGUOUS (VM_OP3_LOAD_LITERAL): {
            PUSH(u16Param3);
            break;
          }

          CASE_CONTIGUOUS (VM_OP3_LOAD_GLOBAL_3): VM_NOT_IMPLEMENTED(vm); break;
          CASE_CONTIGUOUS (VM_OP3_STORE_GLOBAL_3): VM_NOT_IMPLEMENTED(vm); break;
        }
        break;
      }
    }
    continue;
  PUSH_RESULT:
    PUSH(result);
    continue;
  }

EXIT:
  FLUSH_REGISTER_CACHE();
  return err;
}

void mvm_free(VM* vm) {
  gc_freeGCMemory(vm);
  VM_EXEC_SAFE_MODE(memset(vm, 0, sizeof(*vm)));
  free(vm);
}

/**
 * @param sizeBytes Size in bytes of the allocation, *excluding* the header
 * @param typeCode The type code to insert into the header
 * @param headerVal2 A custom 12-bit value to use in the header. Often this will be the size, or length, etc.
 * @param out_result Output VM-Pointer. Target is after allocation header.
 * @param out_target Output native pointer to region after the allocation header.
 */
// TODO: I think it would make sense to consolidate headerVal2 and sizeBytes
static Value gc_allocate(VM* vm, uint16_t sizeBytes, ivm_TeTypeCode typeCode, uint16_t headerVal2, void** out_pTarget) {
  uint16_t allocationSize;
RETRY:
  allocationSize = sizeBytes + 2; // 2 byte header
  // Round up to 2-byte boundary
  allocationSize = (allocationSize + 1) & 0xFFFE;
  // Minimum allocation size is 4 bytes
  if (allocationSize < 4) allocationSize = 4;
  // Note: this is still valid when the bucket is null
  vm_Pointer vpAlloc = vm->vpAllocationCursor;
  void* pAlloc = vm->pAllocationCursor;
  vm_Pointer endOfResult = vpAlloc + allocationSize;
  // Out of space?
  if (endOfResult > vm->vpBucketEnd) {
    // Allocate a new bucket
    uint16_t bucketSize = VM_ALLOCATION_BUCKET_SIZE;
    if (allocationSize > bucketSize)
      bucketSize = allocationSize;
    gc_createNextBucket(vm, bucketSize);
    // This must succeed the second time because we've just allocated a bucket at least as big as it needs to be
    goto RETRY;
  }
  vm->vpAllocationCursor = endOfResult;
  vm->pAllocationCursor += allocationSize;

  // Write header
  VM_ASSERT(vm, (headerVal2 & ~0xFFF) == 0);
  VM_ASSERT(vm, (typeCode & ~0xF) == 0);
  vm_HeaderWord headerWord = (typeCode << 12) | headerVal2;
  *((vm_HeaderWord*)pAlloc) = headerWord;

  *out_pTarget = (uint8_t*)pAlloc + 2; // Skip header
  return vpAlloc + 2;
}

static void gc_createNextBucket(VM* vm, uint16_t bucketSize) {
  size_t allocSize = sizeof (vm_TsBucket) + bucketSize;
  vm_TsBucket* bucket = malloc(allocSize);
  if (!bucket) {
    VM_FATAL_ERROR(vm, MVM_E_MALLOC_FAIL);
    return;
  }
  #if VM_SAFE_MODE
    memset(bucket, 0x7E, allocSize);
  #endif
  bucket->prev = vm->pLastBucket;
  // Note: we start the next bucket at the allocation cursor, not at what we
  // previously called the end of the previous bucket
  bucket->vpAddressStart = vm->vpAllocationCursor;
  vm->pAllocationCursor = (uint8_t*)(bucket + 1);
  vm->vpBucketEnd = vm->vpAllocationCursor + bucketSize;
  vm->pLastBucket = bucket;
}

static void gc_markAllocation(uint16_t* markTable, vm_Pointer p, uint16_t size) {
  if (VM_TAG_OF(p) != VM_TAG_GC_P) return;
  GO_t offset = VM_VALUE_OF(p);

  // Start bit
  uint16_t pWords = offset / VM_GC_ALLOCATION_UNIT;
  uint16_t slotOffset = pWords >> 4;
  uint8_t bitOffset = pWords & 15;
  markTable[slotOffset] |= 0x8000 >> bitOffset;

  // End bit
  pWords += (size / VM_GC_ALLOCATION_UNIT) - 1;
  slotOffset = pWords >> 4;
  bitOffset = pWords & 15;
  markTable[slotOffset] |= 0x8000 >> bitOffset;
}

static inline bool gc_isMarked(uint16_t* markTable, vm_Pointer ptr) {
  // VM_ASSERT(vm, VM_IS_GC_P(ptr));
  GO_t offset = VM_VALUE_OF(ptr);
  uint16_t pWords = offset / VM_GC_ALLOCATION_UNIT;
  uint16_t slotOffset = pWords >> 4;
  uint8_t bitOffset = pWords & 15;
  return markTable[slotOffset] & (0x8000 >> bitOffset);
}

static void gc_freeGCMemory(VM* vm) {
  while (vm->pLastBucket) {
    vm_TsBucket* prev = vm->pLastBucket->prev;
    free(vm->pLastBucket);
    vm->pLastBucket = prev;
  }
  vm->vpBucketEnd = vpGCSpaceStart;
  vm->vpAllocationCursor = vpGCSpaceStart;
  vm->pAllocationCursor = NULL;
}

static void gc_traceValue(VM* vm, uint16_t* markTable, Value value, uint16_t* pTotalSize) {
  uint16_t tag = value & VM_TAG_MASK;
  if (tag == VM_TAG_INT) return;
  /*
  # Pointers in Program Memory

  Program memory can contain pointers. For example, it's valid for bytecode to
  have a VM_OP3_LOAD_LITERAL instruction with a pointer literal parameter.
  However, pointers to GC memory must themselves be mutable, since GC memory can
  move during compaction. Thus, pointers in program memory can only ever
  reference data memory or other allocations in program memory. Pointers in data
  memory, as with everything in data memory, are in fixed locations. These are
  treated as GC roots and do not need to be referenced by values in program
  memory (see below).

  # Pointers in Data Memory

  Data memory is broadly divided into two sections:

   1. Global variables
   2. Heap allocations

  All global variables are treated as GC roots.

  The heap allocations in data memory are permanent and fixed in size and
  structure, unlike allocations in the GC heap. Members of these allocations
  that can be pointers must be recorded in the gcRoots table so that the GC can
  find them.
  */
  if (tag == VM_TAG_PGM_P) return;

  vm_Pointer pAllocation = value;
  if (gc_isMarked(markTable, pAllocation)) return;

  vm_HeaderWord headerWord = vm_readHeaderWord(vm, pAllocation);
  ivm_TeTypeCode typeCode = vm_typeCodeFromHeaderWord(headerWord);
  uint16_t headerData = vm_paramOfHeaderWord(headerWord);

  uint16_t allocationSize; // Including header
  uint8_t headerSize = 2;
  switch (typeCode) {
    case TC_STRUCT: allocationSize = 0; VM_NOT_IMPLEMENTED(vm); break;

    case TC_STRING:
    case TC_UNIQUE_STRING:
    case TC_BIG_INT:
    case TC_SYMBOL:
    case TC_HOST_FUNC:
    case TC_INT32:
    case TC_DOUBLE:
      allocationSize = 2 + headerData; break;

    case TC_PROPERTY_LIST: {
      uint16_t propCount = headerData;
      gc_markAllocation(markTable, pAllocation - 2, 4);
      vm_Pointer pCell = vm_readUInt16(vm, pAllocation);
      while (propCount--) {
        gc_markAllocation(markTable, pCell, 6);
        vm_Pointer next = vm_readUInt16(vm, pCell + 0);
        Value key = vm_readUInt16(vm, pCell + 2);
        Value value = vm_readUInt16(vm, pCell + 4);

        // TODO(low): This shouldn't be recursive. It shouldn't use the C stack
        gc_traceValue(vm, markTable, key, pTotalSize);
        gc_traceValue(vm, markTable, value, pTotalSize);

        pCell = next;
      }
      return;
    }

    case TC_LIST: {
      uint16_t itemCount = headerData;
      gc_markAllocation(markTable, pAllocation - 2, 4);
      vm_Pointer pCell = vm_readUInt16(vm, pAllocation);
      while (itemCount--) {
        gc_markAllocation(markTable, pCell, 6);
        vm_Pointer next = vm_readUInt16(vm, pCell + 0);
        Value value = vm_readUInt16(vm, pCell + 2);

        // TODO(low): This shouldn't be recursive. It shouldn't use the C stack
        gc_traceValue(vm, markTable, value, pTotalSize);

        pCell = next;
      }
      return;
    }

    case TC_TUPLE: {
      uint16_t itemCount = headerData;
      // Need to mark before recursing
      allocationSize = 2 + itemCount * 2;
      gc_markAllocation(markTable, pAllocation - 2, allocationSize);
      vm_Pointer pItem = pAllocation;
      while (itemCount--) {
        Value item = vm_readUInt16(vm, pItem);
        pItem += 2;
        // TODO(low): This shouldn't be recursive. It shouldn't use the C stack
        gc_traceValue(vm, markTable, item, pTotalSize);
      }
      return;
    }

    case TC_FUNCTION: {
      // It shouldn't get here because functions are only stored in ROM (see
      // note at the beginning of this function)
      VM_UNEXPECTED_INTERNAL_ERROR(vm);
      return;
    }

    default: {
      VM_UNEXPECTED_INTERNAL_ERROR(vm);
      return;
    }
  }
  // Round up to nearest word
  allocationSize = (allocationSize + 3) & 0xFFFE;
  // Allocations can't be smaller than 2 words
  if (allocationSize < 4) allocationSize = 4;

  gc_markAllocation(markTable, pAllocation - headerSize, allocationSize);
  (*pTotalSize) += allocationSize;
}

static inline void gc_updatePointer(VM* vm, uint16_t* pWord, uint16_t* markTable, uint16_t* offsetTable) {
  uint16_t word = *pWord;
  uint16_t tag = word & VM_TAG_MASK;

  if (tag != VM_TAG_GC_P) return;

  GO_t ptr = word & VM_VALUE_MASK;
  uint16_t pWords = ptr / VM_GC_ALLOCATION_UNIT;
  uint16_t slotOffset = pWords >> 4;
  uint8_t bitOffset = pWords & 15;

  uint16_t offset = offsetTable[slotOffset];
  bool inAllocation = offset & 0x0001;
  offset = offset & 0xFFFE;
  uint16_t markBits = markTable[slotOffset];
  uint16_t mask = 0x8000;
  while (bitOffset--) {
    bool gc_isMarked = markBits & mask;
    if (inAllocation) {
      if (gc_isMarked) inAllocation = false;
    } else {
      if (gc_isMarked) {
        inAllocation = true;
      } else {
        offset += VM_GC_ALLOCATION_UNIT;
      }
    }
    mask >>= 1;
  }

  *pWord -= offset;
}

// Run a garbage collection cycle
void vm_runGC(VM* vm) {
  if (!vm->pLastBucket) return; // Nothing allocated

  uint16_t allocatedSize = vm->vpAllocationCursor - vpGCSpaceStart;
  // The mark table has 1 mark bit for each 16-bit allocation unit (word) in GC
  // space, and we round up to the nearest whole byte
  uint16_t markTableSize = (allocatedSize + 15) / 16;
  // The adjustment table has one 16-bit adjustment word for every 16 mark bits.
  // It says how much a pointer at that position should be adjusted for
  // compaction.
  uint16_t adjustmentTableSize = markTableSize + 2; // TODO: Can remove the extra 2?
  // We allocate the mark table and adjustment table at the same time for
  // efficiency. The allocation size here is 1/8th the size of the heap memory
  // allocated. So a 2 kB heap requires a 256 B allocation here.
  uint8_t* temp = malloc(markTableSize + adjustmentTableSize);
  if (!temp) {
    VM_FATAL_ERROR(vm, MVM_E_MALLOC_FAIL);
    return;
  }
  // The adjustment table is first because it needs to be 16-bit aligned
  uint16_t* adjustmentTable = (uint16_t*)temp;
  uint16_t* markTable = (uint16_t*)(temp + adjustmentTableSize); // TODO: I'm worried about the efficiency of accessing these as words
  uint16_t* markTableEnd = (uint16_t*)((uint8_t*)markTable + markTableSize);

  VM_ASSERT(vm, ((intptr_t)adjustmentTable & 1) == 0); // Needs to be 16-bit aligned for the following algorithm to work

  memset(markTable, 0, markTableSize);
  VM_EXEC_SAFE_MODE(memset(adjustmentTable, 0, adjustmentTableSize));

  // -- Mark Phase--

  uint16_t totalSize = 0;

  // Mark Global Variables
  {
    uint16_t globalVariableCount = VM_READ_BC_2_HEADER_FIELD(globalVariableCount, vm->pBytecode);

    uint16_t* p = vm->dataMemory;
    while (globalVariableCount--)
      gc_traceValue(vm, markTable, *p++, &totalSize);
  }

  // Mark other roots in data memory
  {
    uint16_t gcRootsOffset = VM_READ_BC_2_HEADER_FIELD(gcRootsOffset, vm->pBytecode);
    uint16_t gcRootsCount = VM_READ_BC_2_HEADER_FIELD(gcRootsCount, vm->pBytecode);

    VM_PROGMEM_P pTableEntry = VM_PROGMEM_P_ADD(vm->pBytecode, gcRootsOffset);
    while (gcRootsCount--) {
      // The table entry in program memory gives us an offset in data memory
      uint16_t dataOffsetWords = VM_READ_PROGMEM_2(pTableEntry);
      uint16_t dataValue = vm->dataMemory[dataOffsetWords];
      gc_traceValue(vm, markTable, dataValue, &totalSize);
      pTableEntry = VM_PROGMEM_P_ADD(pTableEntry, 2);
    }
  }

  if (totalSize == 0) {
    // Everything is freed
    gc_freeGCMemory(vm);
    goto EXIT;
  }

  // If the allocated size is taking up less than 25% more than the used size,
  // then don't collect.
  if (allocatedSize < totalSize * 5 / 4) {
    goto EXIT;
  }

  // Create adjustment table
  {
    uint16_t mask = 0x8000;
    uint16_t* pMark = markTable;
    uint16_t adjustment = 0;
    adjustmentTable[0] = adjustment & 0xFFFE;
    uint16_t* pAdjustment = &adjustmentTable[1];
    bool inAllocation = false;
    while (pMark < markTableEnd) {
      bool gc_isMarked = (*pMark) & mask;
      if (inAllocation) {
        if (gc_isMarked) inAllocation = false;
      } else {
        if (gc_isMarked) {
          inAllocation = true;
        } else {
          adjustment += VM_GC_ALLOCATION_UNIT;
        }
      }
      mask >>= 1;
      if (!mask) {
        *pAdjustment++ = adjustment | (inAllocation ? 1 : 0);
        pMark++;
        mask = 0x8000;
      }
    }
  }

  // TODO(med): Pointer update: global variables
  // TODO(med): Pointer update: roots variables
  // TODO(med): Pointer update: recursion

  // Update global variables
  {
    uint16_t* p = vm->dataMemory;
    uint16_t globalVariableCount = VM_READ_BC_2_HEADER_FIELD(globalVariableCount, vm->pBytecode);

    while (globalVariableCount--) {
      gc_updatePointer(vm, p++, markTable, adjustmentTable);
    }
  }

  // Compact phase

  // Temporarily reverse the linked list to make it easier to parse forwards
  // during compaction. Also, we'll change the vpAddressStart field to hold the
  // size.
  vm_TsBucket* first;
  {
    vm_TsBucket* bucket = vm->pLastBucket;
    vm_Pointer vpEndOfBucket = vm->vpBucketEnd;
    vm_TsBucket* next = NULL;
    while (bucket) {
      uint16_t size = vpEndOfBucket - bucket->vpAddressStart;
      vpEndOfBucket = bucket->vpAddressStart; // TODO: I don't remember what this is for. Please comment.
      bucket->vpAddressStart/*size*/ = size;
      vm_TsBucket* prev = bucket->prev;
      bucket->prev/*next*/ = next;
      next = bucket;
      bucket = prev;
    }
    first = next;
  }

  /*
  This is basically a semispace collector. It allocates a completely new
  region and does a full copy of all the memory from the old region into the
  new.
  */
  vm->vpAllocationCursor = vpGCSpaceStart;
  vm->vpBucketEnd = vpGCSpaceStart;
  vm->pLastBucket = NULL;
  gc_createNextBucket(vm, totalSize);

  {
    VM_ASSERT(vm, vm->pLastBucket && !vm->pLastBucket->prev); // Only one bucket (the new one)
    uint16_t* source = (uint16_t*)(first + 1); // Start just after the header
    uint16_t* sourceEnd = (uint16_t*)((uint8_t*)source + first->vpAddressStart/*size*/);
    uint16_t* target = (uint16_t*)(vm->pLastBucket + 1); // Start just after the header
    if (!target) {
      VM_UNEXPECTED_INTERNAL_ERROR(vm);
      return;
    }
    uint16_t* pMark = markTable;
    uint16_t mask = 0x8000;
    uint16_t markBits = *pMark++;
    bool copying = false;
    while (first) {
      bool gc_isMarked = markBits & mask;
      if (copying) {
        *target++ = *source++;
        if (gc_isMarked) copying = false;
      } else {
        if (gc_isMarked) {
          copying = true;
          *target++ = *source++;
        } else {
          source++;
        }
      }

      if (source >= sourceEnd) {
        vm_TsBucket* next = first->prev/*next*/;
        uint16_t size = first->vpAddressStart/*size*/;
        free(first);
        if (!next) break; // Done with compaction
        source = (uint16_t*)(next + 1); // Start after the header
        sourceEnd = (uint16_t*)((uint8_t*)source + size);
        first = next;
      }

      mask >>= 1;
      if (!mask) {
        mask = 0x8000;
        markBits = *pMark++;
      }
    }
  }
EXIT:
  free(temp);
}

static void* gc_deref(VM* vm, vm_Pointer vp) {
  VM_ASSERT(vm, (vp >= vpGCSpaceStart) && (vp <= vm->vpAllocationCursor));

  // Find the right bucket
  vm_TsBucket* pBucket = vm->pLastBucket;
  VM_SAFE_CHECK_NOT_NULL_2(pBucket);
  while (vp < pBucket->vpAddressStart) {
    pBucket = pBucket->prev;
    VM_SAFE_CHECK_NOT_NULL_2(pBucket);
  }

  // This would be more efficient if buckets had some kind of "offset" field which took into account all of this
  uint8_t* bucketData = ((uint8_t*)(pBucket + 1));
  uint8_t* p = bucketData + (vp - pBucket->vpAddressStart);
  return p;
}

// A function call invoked by the host
TeError mvm_call(VM* vm, Value func, Value* out_result, Value* args, uint8_t argCount) {
  TeError err;
  if (out_result)
    *out_result = VM_VALUE_UNDEFINED;

  vm_setupCallFromExternal(vm, func, args, argCount);

  // Run the machine until it hits the corresponding return instruction. The
  // return instruction pops the arguments off the stack and pushes the returned
  // value.
  err = vm_run(vm);
  if (err != MVM_E_SUCCESS) return err;

  if (out_result)
    *out_result = vm_pop(vm);

  // Release the stack if we hit the bottom
  if (vm->stack->reg.pStackPointer == VM_BOTTOM_OF_STACK(vm)) {
    free(vm->stack);
    vm->stack = NULL;
  }

  return MVM_E_SUCCESS;
}

static TeError vm_setupCallFromExternal(VM* vm, Value func, Value* args, uint8_t argCount) {
  VM_ASSERT(vm, deepTypeOf(vm, func) == TC_FUNCTION);

  // There is no stack if this is not a reentrant invocation
  if (!vm->stack) {
    // This is freed again at the end of mvm_call
    vm_TsStack* stack = malloc(sizeof (vm_TsStack) + VM_STACK_SIZE);
    if (!stack) return MVM_E_MALLOC_FAIL;
    memset(stack, 0, sizeof *stack);
    vm_TsRegisters* reg = &stack->reg;
    // The stack grows upward. The bottom is the lowest address.
    uint16_t* bottomOfStack = (uint16_t*)(stack + 1);
    reg->pFrameBase = bottomOfStack;
    reg->pStackPointer = bottomOfStack;
    vm->stack = stack;
  }

  vm_TsStack* stack = vm->stack;
  uint16_t* bottomOfStack = (uint16_t*)(stack + 1);
  vm_TsRegisters* reg = &stack->reg;

  VM_ASSERT(vm, reg->programCounter == 0); // Assert that we're outside the VM at the moment

  VM_ASSERT(vm, VM_TAG_OF(func) == VM_TAG_PGM_P);
  BO_t functionOffset = VM_VALUE_OF(func);
  uint8_t maxStackDepth = VM_READ_BC_1_AT(functionOffset, vm->pBytecode);
  // TODO(low): Since we know the max stack depth for the function, we could actually grow the stack dynamically rather than allocate it fixed size.
  if (vm->stack->reg.pStackPointer + (maxStackDepth + VM_FRAME_SAVE_SIZE_WORDS) > VM_TOP_OF_STACK(vm)) {
    return MVM_E_STACK_OVERFLOW;
  }

  vm_push(vm, func); // We need to push the function because the corresponding RETURN instruction will pop it. The actual value is not used.
  Value* arg = &args[0];
  for (int i = 0; i < argCount; i++)
    vm_push(vm, *arg++);

  // Save caller state (VM_FRAME_SAVE_SIZE_WORDS)
  vm_push(vm, reg->pFrameBase - bottomOfStack);
  vm_push(vm, reg->argCount);
  vm_push(vm, reg->programCounter);

  // Set up new frame
  reg->pFrameBase = reg->pStackPointer;
  reg->argCount = argCount;
  reg->programCounter = functionOffset + sizeof (vm_TsFunctionHeader);

  return MVM_E_SUCCESS;
}

TeError vm_resolveExport(VM* vm, mvm_VMExportID id, Value* result) {
  VM_PROGMEM_P pBytecode = vm->pBytecode;
  uint16_t exportTableOffset = VM_READ_BC_2_HEADER_FIELD(exportTableOffset, pBytecode);
  uint16_t exportTableSize = VM_READ_BC_2_HEADER_FIELD(exportTableSize, pBytecode);

  VM_PROGMEM_P exportTable = VM_PROGMEM_P_ADD(vm->pBytecode, exportTableOffset);
  VM_PROGMEM_P exportTableEnd = VM_PROGMEM_P_ADD(exportTable, exportTableSize);

  // See vm_TsExportTableEntry
  VM_PROGMEM_P exportTableEntry = exportTable;
  while (exportTableEntry < exportTableEnd) {
    mvm_VMExportID exportID = VM_READ_PROGMEM_2(exportTableEntry);
    if (exportID == id) {
      VM_PROGMEM_P pExportvalue = VM_PROGMEM_P_ADD(exportTableEntry, 2);
      mvm_VMExportID exportValue = VM_READ_PROGMEM_2(pExportvalue);
      *result = exportValue;
      return MVM_E_SUCCESS;
    }
    exportTableEntry = VM_PROGMEM_P_ADD(exportTableEntry, sizeof (vm_TsExportTableEntry));
  }

  *result = VM_VALUE_UNDEFINED;
  return MVM_E_UNRESOLVED_EXPORT;
}

TeError mvm_resolveExports(VM* vm, const mvm_VMExportID* idTable, Value* resultTable, uint8_t count) {
  TeError err = MVM_E_SUCCESS;
  while (count--) {
    TeError tempErr = vm_resolveExport(vm, *idTable++, resultTable++);
    if (tempErr != MVM_E_SUCCESS)
      err = tempErr;
  }
  return err;
}

void mvm_initializeHandle(VM* vm, mvm_Handle* handle) {
  VM_ASSERT(vm, !vm_isHandleInitialized(vm, handle));
  handle->_next = vm->gc_handles;
  vm->gc_handles = handle;
  handle->_value = VM_VALUE_UNDEFINED;
}

void vm_cloneHandle(VM* vm, mvm_Handle* target, const mvm_Handle* source) {
  VM_ASSERT(vm, !vm_isHandleInitialized(vm, source));
  mvm_initializeHandle(vm, target);
  target->_value = source->_value;
}

TeError mvm_releaseHandle(VM* vm, mvm_Handle* handle) {
  mvm_Handle** h = &vm->gc_handles;
  while (*h) {
    if (*h == handle) {
      *h = handle->_next;
      handle->_value = VM_VALUE_UNDEFINED;
      handle->_next = NULL;
      return MVM_E_SUCCESS;
    }
    h = &((*h)->_next);
  }
  handle->_value = VM_VALUE_UNDEFINED;
  handle->_next = NULL;
  return MVM_E_INVALID_HANDLE;
}

static bool vm_isHandleInitialized(VM* vm, const mvm_Handle* handle) {
  mvm_Handle* h = vm->gc_handles;
  while (h) {
    if (h == handle) {
      return true;
    }
    h = h->_next;
  }
  return false;
}

static Value vm_binOp1Slow(VM* vm, vm_TeBinOp1 op, Value left, Value right) {
  switch (op) {
    case VM_BOP1_ADD: {
      if (vm_isString(vm, left) || vm_isString(vm, right)) {
        left = vm_convertToString(vm, left);
        right = vm_convertToString(vm, right);
        return vm_concat(vm, left, right);
      } else {
        left = vm_convertToNumber(vm, left);
        right = vm_convertToNumber(vm, right);
        return vm_addNumbersSlow(vm, left, right);
      }
    }
    case VM_BOP1_SUBTRACT: return VM_NOT_IMPLEMENTED(vm);
    case VM_BOP1_MULTIPLY: return VM_NOT_IMPLEMENTED(vm);
    case VM_BOP1_DIVIDE: return VM_NOT_IMPLEMENTED(vm);
    case VM_BOP1_SHR_ARITHMETIC: return VM_NOT_IMPLEMENTED(vm);
    case VM_BOP1_SHR_BITWISE: return VM_NOT_IMPLEMENTED(vm);
    case VM_BOP1_SHL: return VM_NOT_IMPLEMENTED(vm);
    case VM_BOP1_BITWISE_OR: return VM_NOT_IMPLEMENTED(vm);
    case VM_BOP1_BITWISE_AND: return VM_NOT_IMPLEMENTED(vm);
    case VM_BOP1_BITWISE_XOR: return VM_NOT_IMPLEMENTED(vm);
    case VM_BOP1_REMAINDER: return VM_NOT_IMPLEMENTED(vm);
    default: return VM_UNEXPECTED_INTERNAL_ERROR(vm);
  }
}

static Value vm_binOp2(VM* vm, vm_TeBinOp2 op, Value left, Value right) {
  switch (op) {
    case VM_BOP2_LESS_THAN: return VM_NOT_IMPLEMENTED(vm);
    case VM_BOP2_GREATER_THAN: return VM_NOT_IMPLEMENTED(vm);
    case VM_BOP2_LESS_EQUAL: return VM_NOT_IMPLEMENTED(vm);
    case VM_BOP2_GREATER_EQUAL: return VM_NOT_IMPLEMENTED(vm);
    case VM_BOP2_EQUAL: return VM_NOT_IMPLEMENTED(vm);
    case VM_BOP2_NOT_EQUAL: return VM_NOT_IMPLEMENTED(vm);
    default: return VM_UNEXPECTED_INTERNAL_ERROR(vm);
  }
}

static Value vm_convertToString(VM* vm, Value value) {
  ivm_TeTypeCode type = deepTypeOf(vm, value);

  switch (type) {
    case VM_TAG_INT: return VM_NOT_IMPLEMENTED(vm);
    case TC_INT32: return VM_NOT_IMPLEMENTED(vm);
    case TC_DOUBLE: return VM_NOT_IMPLEMENTED(vm);
    case TC_STRING: return value;
    case TC_UNIQUE_STRING: return value;
    case TC_PROPERTY_LIST: return VM_NOT_IMPLEMENTED(vm);
    case TC_LIST: return VM_NOT_IMPLEMENTED(vm);
    case TC_TUPLE: return VM_NOT_IMPLEMENTED(vm);
    case TC_FUNCTION: return VM_NOT_IMPLEMENTED(vm);
    case TC_HOST_FUNC: return VM_NOT_IMPLEMENTED(vm);
    case TC_BIG_INT: return VM_NOT_IMPLEMENTED(vm);
    case TC_SYMBOL: return VM_NOT_IMPLEMENTED(vm);
    case TC_UNDEFINED: return VM_NOT_IMPLEMENTED(vm);
    case TC_NULL: return VM_NOT_IMPLEMENTED(vm);
    case TC_TRUE: return VM_NOT_IMPLEMENTED(vm);
    case TC_FALSE: return VM_NOT_IMPLEMENTED(vm);
    case TC_NAN: return VM_NOT_IMPLEMENTED(vm);
    case TC_INF: return VM_NOT_IMPLEMENTED(vm);
    case TC_NEG_INF: return VM_NOT_IMPLEMENTED(vm);
    case TC_NEG_ZERO: return VM_NOT_IMPLEMENTED(vm);
    case TC_DELETED: return VM_NOT_IMPLEMENTED(vm);
    case TC_STRUCT: return VM_NOT_IMPLEMENTED(vm);
    default: return VM_UNEXPECTED_INTERNAL_ERROR(vm);
  }
}

static Value vm_concat(VM* vm, Value left, Value right) {
  size_t leftSize = 0;
  const char* leftStr = mvm_toStringUtf8(vm, left, &leftSize);
  size_t rightSize = 0;
  const char* rightStr = mvm_toStringUtf8(vm, right, &rightSize);
  uint8_t* data;
  Value value = vm_allocString(vm, leftSize + rightSize, (void**)&data);
  memcpy(data, leftStr, leftSize);
  memcpy(data + leftSize, rightStr, rightSize);
  return value;
}

static Value vm_convertToNumber(VM* vm, Value value) {
  uint16_t tag = value & VM_TAG_MASK;
  if (tag == VM_TAG_INT) return value;

  ivm_TeTypeCode type = deepTypeOf(vm, value);
  switch (type) {
    case TC_INT32: return value;
    case TC_DOUBLE: return value;
    case TC_STRING: return VM_NOT_IMPLEMENTED(vm);
    case TC_UNIQUE_STRING: return VM_NOT_IMPLEMENTED(vm);
    case TC_PROPERTY_LIST: return VM_VALUE_NAN;
    case TC_LIST: return VM_VALUE_NAN;
    case TC_TUPLE: return VM_VALUE_NAN;
    case TC_FUNCTION: return VM_VALUE_NAN;
    case TC_HOST_FUNC: return VM_VALUE_NAN;
    case TC_BIG_INT: return VM_NOT_IMPLEMENTED(vm);
    case TC_SYMBOL: return VM_NOT_IMPLEMENTED(vm);
    case TC_UNDEFINED: return 0;
    case TC_NULL: return 0;
    case TC_TRUE: return 1;
    case TC_FALSE: return 0;
    case TC_NAN: return value;
    case TC_INF: return value;
    case TC_NEG_INF: return value;
    case TC_NEG_ZERO: return value;
    case TC_DELETED: return 0;
    case TC_STRUCT: return VM_VALUE_NAN;
    default: return VM_UNEXPECTED_INTERNAL_ERROR(vm);
  }
}

static Value vm_addNumbersSlow(VM* vm, Value left, Value right) {
  if (VM_IS_NAN(left) || VM_IS_NAN(right)) return VM_VALUE_NAN;
  else if (VM_IS_INF(left))
    if (VM_IS_NEG_INF(right)) return VM_VALUE_NAN;
    else return VM_VALUE_INF;
  else if (VM_IS_NEG_INF(left))
    if (VM_IS_INF(right)) return VM_VALUE_NAN;
    else return VM_VALUE_NEG_INF;
  else if (VM_IS_INF(right)) return VM_VALUE_INF;
  else if (VM_IS_NEG_INF(right)) return VM_VALUE_NEG_INF;
  else if (VM_IS_NEG_ZERO(left))
    if (VM_IS_NEG_ZERO(right)) return VM_VALUE_NEG_ZERO;
    else return right;
  else if (VM_IS_NEG_ZERO(right)) return left;

  ivm_TeTypeCode leftType = deepTypeOf(vm, left);
  ivm_TeTypeCode rightType = deepTypeOf(vm, right);

  // If either is a double, then we need to perform double arithmetic
  if ((leftType == TC_DOUBLE) || (rightType == TC_DOUBLE)) {
    VM_DOUBLE leftDouble = vm_readDouble(vm, leftType, left);
    VM_DOUBLE rightDouble = vm_readDouble(vm, rightType, right);
    VM_DOUBLE result = leftDouble + rightDouble;
    return mvm_newDouble(vm, result);
  }

  VM_ASSERT(vm, (leftType == TC_INT32) || (rightType == TC_INT32));

  int32_t leftInt32 = vm_readInt32(vm, leftType, left);
  int32_t rightInt32 = vm_readInt32(vm, rightType, right);
  int32_t result = leftInt32 + rightInt32;
  bool overflowed32 = (uint32_t)result < (uint32_t)leftInt32;
  if (overflowed32)
    return mvm_newDouble(vm, (VM_DOUBLE)leftInt32 + (VM_DOUBLE)rightInt32);
  return mvm_newInt32(vm, result);
}

/* Returns the deep type of the value, looking through pointers and boxing */
static ivm_TeTypeCode deepTypeOf(VM* vm, Value value) {
  TeValueTag tag = VM_TAG_OF(value);
  if (tag == VM_TAG_INT)
    return TC_INT14;

  // Check for "well known" values such as TC_UNDEFINED
  if (tag == VM_TAG_PGM_P && value < VM_VALUE_MAX_WELLKNOWN) {
    // Well known types have a value that matches the corresponding type code
    return (ivm_TeTypeCode)VM_VALUE_OF(value);
  }

  // Else, value is a pointer. The type of a pointer value is the type of the value being pointed to
  vm_HeaderWord headerWord = vm_readHeaderWord(vm, value);
  ivm_TeTypeCode typeCode = vm_typeCodeFromHeaderWord(headerWord);

  return typeCode;
}

Value mvm_newDouble(VM* vm, VM_DOUBLE value) {
  if (isnan(value)) return VM_VALUE_NAN;
  if (value == INFINITY) return VM_VALUE_INF;
  if (value == -INFINITY) return VM_VALUE_NEG_INF;
  if (value == -0.0) return VM_VALUE_NEG_ZERO;

  // Doubles are very expensive to compute, so at every opportunity, we'll check
  // if we can coerce back to an integer
  int32_t valueAsInt = (int32_t)value;
  if (value == (VM_DOUBLE)valueAsInt) {
    return mvm_newInt32(vm, valueAsInt);
  }

  double* pResult;
  Value resultValue = gc_allocate(vm, sizeof (VM_DOUBLE), TC_DOUBLE, sizeof (VM_DOUBLE), (void**)&pResult);
  *pResult = value;

  return resultValue;
}

Value mvm_newInt32(VM* vm, int32_t value) {
  if ((value >= VM_MIN_INT14) && (value <= VM_MAX_INT14))
    return value | VM_TAG_INT;

  // Int32
  int32_t* pResult;
  Value resultValue = gc_allocate(vm, sizeof (int32_t), TC_INT32, sizeof (int32_t), (void**)&pResult);
  *pResult = value;

  return resultValue;
}

bool mvm_toBool(VM* vm, Value value) {
  uint16_t tag = value & VM_TAG_MASK;
  if (tag == VM_TAG_INT) return value != 0;

  ivm_TeTypeCode type = deepTypeOf(vm, value);
  switch (type) {
    case TC_INT32: {
      // Int32 can't be zero, otherwise it would be encoded as an int14
      VM_ASSERT(vm, vm_readInt32(vm, type, value) != 0);
      return false;
    }
    case TC_DOUBLE: {
      // Double can't be zero, otherwise it would be encoded as an int14
      VM_ASSERT(vm, vm_readDouble(vm, type, value) != 0);
      return false;
    }
    case TC_UNIQUE_STRING:
    case TC_STRING: {
      return vm_stringSizeUtf8(vm, value) != 0;
    }
    case TC_PROPERTY_LIST: return true;
    case TC_LIST: return true;
    case TC_TUPLE: return true;
    case TC_FUNCTION: return true;
    case TC_HOST_FUNC: return true;
    case TC_BIG_INT: return VM_NOT_IMPLEMENTED(vm);
    case TC_SYMBOL: return true;
    case TC_UNDEFINED: return false;
    case TC_NULL: return false;
    case TC_TRUE: return true;
    case TC_FALSE: return false;
    case TC_NAN: return false;
    case TC_INF: return true;
    case TC_NEG_INF: return true;
    case TC_NEG_ZERO: return false;
    case TC_DELETED: return false;
    case TC_STRUCT: return true;
    default: return VM_UNEXPECTED_INTERNAL_ERROR(vm);
  }
}

static bool vm_isString(VM* vm, Value value) {
  ivm_TeTypeCode deepType = deepTypeOf(vm, value);
  if ((deepType == TC_STRING) || (deepType == TC_UNIQUE_STRING)) return true;
  return false;
}

/** Reads a numeric value that is a subset of a double */
static VM_DOUBLE vm_readDouble(VM* vm, ivm_TeTypeCode type, Value value) {
  switch (type) {
    case TC_INT14: { return (VM_DOUBLE)value; }
    case TC_INT32: { return (VM_DOUBLE)vm_readInt32(vm, type, value); }
    case TC_DOUBLE: {
      VM_DOUBLE result;
      vm_readMem(vm, &result, value, sizeof result);
      return result;
    }
    case VM_VALUE_NAN: return VM_DOUBLE_NAN;
    case VM_VALUE_INF: return INFINITY;
    case VM_VALUE_NEG_INF: return -INFINITY;
    case VM_VALUE_NEG_ZERO: return -0.0;

    // vm_readDouble is only valid for numeric types
    default: return VM_UNEXPECTED_INTERNAL_ERROR(vm);
  }
}

/** Reads a numeric value that is a subset of a 32-bit integer */
static int32_t vm_readInt32(VM* vm, ivm_TeTypeCode type, Value value) {
  if (type == TC_INT14) return value;
  if (type == TC_INT32) {
    int32_t result;
    vm_readMem(vm, &result, value, sizeof result);
    return result;
  }
  return VM_UNEXPECTED_INTERNAL_ERROR(vm);
}

static Value vm_unOp(VM* vm, vm_TeUnOp op, Value arg) {
  return VM_NOT_IMPLEMENTED(vm);
}

static void vm_push(VM* vm, uint16_t value) {
  *(vm->stack->reg.pStackPointer++) = value;
}

static uint16_t vm_pop(VM* vm) {
  return *(--vm->stack->reg.pStackPointer);
}

static inline uint16_t vm_readUInt16(VM* vm, vm_Pointer p) {
  uint16_t result; // TODO: This can be much faster
  vm_readMem(vm, &result, p, sizeof(result));
  return result;
}

static inline vm_HeaderWord vm_readHeaderWord(VM* vm, vm_Pointer pAllocation) {
  return vm_readUInt16(vm, pAllocation - 2);
}

// TODO: Audit uses of this, since it's a slow function
static void vm_readMem(VM* vm, void* target, vm_Pointer source, uint16_t size) {
  uint16_t addr = VM_VALUE_OF(source);
  switch (VM_TAG_OF(source)) {
    case VM_TAG_GC_P: {
      uint8_t* sourceAddress = gc_deref(vm, source);
      memcpy(target, sourceAddress, size);
      break;
    }
    case VM_TAG_DATA_P: {
      memcpy(target, (uint8_t*)vm->dataMemory + addr, size);
      break;
    }
    case VM_TAG_PGM_P: {
      VM_ASSERT(vm, source > VM_VALUE_MAX_WELLKNOWN);
      VM_READ_BC_N_AT(target, addr, size, vm->pBytecode);
      break;
    }
    default: VM_UNEXPECTED_INTERNAL_ERROR(vm);
  }
}

static void vm_writeMem(VM* vm, vm_Pointer target, void* source, uint16_t size) {
  switch (VM_TAG_OF(target)) {
    case VM_TAG_GC_P: {
      uint8_t* targetAddress = gc_deref(vm, target);
      memcpy(targetAddress, source, size);
      break;
    }
    case VM_TAG_DATA_P: {
      uint16_t addr = VM_VALUE_OF(target);
      memcpy((uint8_t*)vm->dataMemory + addr, source, size);
      break;
    }
    case VM_TAG_PGM_P: {
      VM_FATAL_ERROR(vm, MVM_E_ATTEMPT_TO_WRITE_TO_ROM);
      break;
    }
    default: VM_UNEXPECTED_INTERNAL_ERROR(vm);
  }
}

static inline mvm_TfHostFunction* vm_getResolvedImports(VM* vm) {
  return (mvm_TfHostFunction*)(vm + 1); // Starts right after the header
}

static inline uint16_t vm_getResolvedImportCount(VM* vm) {
  uint16_t importTableSize = VM_READ_BC_2_HEADER_FIELD(importTableSize, vm->pBytecode);
  uint16_t importCount = importTableSize / sizeof(vm_TsImportTableEntry);
  return importCount;
}

mvm_TeType mvm_typeOf(VM* vm, Value value) {
  ivm_TeTypeCode type = deepTypeOf(vm, value);
  // TODO: This should be implemented as a lookup table, not a switch
  switch (type) {
    case TC_UNDEFINED:
    case TC_DELETED:
      return VM_T_UNDEFINED;

    case TC_NULL:
      return VM_T_NULL;

    case TC_TRUE:
    case TC_FALSE:
      return VM_T_BOOLEAN;

    case TC_INT14:
    case TC_DOUBLE:
    case TC_INT32:
    case TC_NAN:
    case TC_INF:
    case TC_NEG_INF:
    case TC_NEG_ZERO:
      return VM_T_NUMBER;

    case TC_STRING:
    case TC_UNIQUE_STRING:
      return VM_T_STRING;

    case TC_LIST:
    case TC_TUPLE:
      return VM_T_ARRAY;

    case TC_PROPERTY_LIST:
    case TC_STRUCT:
      return VM_T_OBJECT;

    case TC_FUNCTION:
    case TC_HOST_FUNC:
      return VM_T_FUNCTION;

    case TC_BIG_INT:
      return VM_T_BIG_INT;
    case TC_SYMBOL:
      return VM_T_SYMBOL;

    default: VM_UNEXPECTED_INTERNAL_ERROR(vm); return VM_T_UNDEFINED;
  }
}

const char* mvm_toStringUtf8(VM* vm, Value value, size_t* out_sizeBytes) {
  value = vm_convertToString(vm, value);

  vm_HeaderWord headerWord = vm_readHeaderWord(vm, value);
  ivm_TeTypeCode typeCode = vm_typeCodeFromHeaderWord(headerWord);

  VM_ASSERT(vm, (typeCode == TC_STRING) || (typeCode == TC_UNIQUE_STRING));

  uint16_t sourceSize = vm_paramOfHeaderWord(headerWord);

  if (out_sizeBytes) {
    *out_sizeBytes = sourceSize - 1; // Without the extra safety null-terminator
  }

  // If the string is program memory, we have to allocate a copy of it in data
  // memory because program memory is not necessarily addressable
  // TODO: There should be a flag to suppress this when it isn't needed
  if (VM_IS_PGM_P(value)) {
    void* data;
    gc_allocate(vm, sourceSize, TC_STRING, sourceSize, &data);
    vm_readMem(vm, data, value, sourceSize);
    return data;
  } else {
    return vm_deref(vm, value);
  }
}

Value mvm_newBoolean(bool source) {
  return source ? VM_VALUE_TRUE : VM_VALUE_FALSE;
}

Value vm_allocString(VM* vm, size_t sizeBytes, void** data) {
  if (sizeBytes > 0x3FFF - 1) {
    VM_FATAL_ERROR(vm, MVM_E_ALLOCATION_TOO_LARGE);
  }
  // Note: allocating 1 extra byte for the extra null terminator
  Value value = gc_allocate(vm, (uint16_t)sizeBytes + 1, TC_STRING, (uint16_t)sizeBytes + 1, data);
  // Null terminator
  ((char*)(*data))[sizeBytes] = '\0';
  return value;
}

Value mvm_newString(VM* vm, const char* sourceUtf8, size_t sizeBytes) {
  void* data;
  Value value = vm_allocString(vm, sizeBytes, &data);
  memcpy(data, sourceUtf8, sizeBytes);
  return value;
}

static void* vm_deref(VM* vm, Value pSrc) {
  uint16_t tag = VM_TAG_OF(pSrc);
  if (tag == VM_TAG_GC_P) return gc_deref(vm, pSrc);
  if (tag == VM_TAG_DATA_P) return (uint8_t*)vm->dataMemory + VM_VALUE_OF(pSrc);
  // Program pointers (and integers) are not dereferenceable, so it shouldn't get here.
  VM_UNEXPECTED_INTERNAL_ERROR(vm);
  return NULL;
}

static TeError getProperty(VM* vm, Value objectValue, Value propertyName, Value* propertyValue) {
  toPropertyName(vm, &propertyName);
  ivm_TeTypeCode type = deepTypeOf(vm, objectValue);
  switch (type) {
    case TC_PROPERTY_LIST: {

      return VM_NOT_IMPLEMENTED(vm);
      break;
    }
    case TC_LIST: return VM_NOT_IMPLEMENTED(vm);
    case TC_TUPLE: return VM_NOT_IMPLEMENTED(vm);
    case TC_STRUCT: return VM_NOT_IMPLEMENTED(vm);
    default: return MVM_E_TYPE_ERROR;
  }
  return MVM_E_SUCCESS;
}

/** Converts the argument to either an TC_INT14 or a TC_UNIQUE_STRING, or gives an error */
static TeError toPropertyName(VM* vm, Value* value) {
  // Property names in microvium are either integer indexes or non-integer unique strings
  ivm_TeTypeCode type = deepTypeOf(vm, *value);
  switch (type) {
    // These are already valid property names
    case TC_INT14:
    case TC_UNIQUE_STRING:
      return MVM_E_SUCCESS;

    case TC_INT32:
      // 32-bit numbers are out of the range of supported array indexes
      return MVM_E_RANGE_ERROR;

    case TC_STRING: {
      // In Microvium at the moment, it's illegal to use an integer-valued
      // string as a property name. If the string is in bytecode, it will only
      // have the type TC_STRING if it's a number and is illegal.
      if (VM_IS_PGM_P(*value))
        return MVM_E_TYPE_ERROR;

      // Strings which have all digits are illegal as property names
      if (vm_stringIsNonNegativeInteger(vm, *value))
        return MVM_E_TYPE_ERROR;

      // Strings need to be converted to unique strings in order to be valid
      // property names. This is because properties are searched by reference
      // equality.
      *value = toUniqueString(vm, *value);
      return MVM_E_SUCCESS;
    }
    default:
      return MVM_E_TYPE_ERROR;
  }
}

// Converts a TC_STRING to a TC_UNIQUE_STRING
// TODO: Test cases for this function
static Value toUniqueString(VM* vm, Value value) {
  VM_ASSERT(vm, deepTypeOf(vm, value) == TC_STRING);
  VM_ASSERT(vm, VM_IS_GC_P(value));

  // TC_STRING values are always in GC memory. If they were in flash, they'd
  // already be TC_UNIQUE_STRING.
  char* str1Data = (char*)gc_deref(vm, value);
  uint16_t str1Header = vm_readHeaderWord(vm, value);
  int str1Size = vm_paramOfHeaderWord(str1Header);

  VM_PROGMEM_P pBytecode = vm->pBytecode;

  // We start by searching the string table for unique strings that are baked
  // into the ROM. These are stored alphabetically, so we can perform a binary
  // search.

  BO_t stringTableOffset = VM_READ_BC_2_HEADER_FIELD(stringTableOffset, pBytecode);
  uint16_t stringTableSize = VM_READ_BC_2_HEADER_FIELD(stringTableSize, pBytecode);
  BO_t stringTableEnd = stringTableOffset + stringTableSize;
  int strCount = stringTableSize / sizeof (Value);

  int first = 0;
  int last = strCount;
  int middle = (first + last) / 2;

  while (first <= last) {
    BO_t str2Offset = stringTableOffset + middle * 2;
    Value str2Value = VM_READ_BC_2_AT(str2Offset, pBytecode);
    VM_ASSERT(vm, VM_IS_PGM_P(str2Value));
    uint16_t str2Header = vm_readHeaderWord(vm, str2Value);
    int str2Size = vm_paramOfHeaderWord(str2Header);
    VM_PROGMEM_P str2Data = pgm_deref(vm, str2Value);
    int compareSize = str1Size < str2Size ? str1Size : str2Size;
    int c = memcmp_pgm(str1Data, str2Data, compareSize);

    // If they compare equal for the range that they have in common, we check the length
    if (c == 0) {
      if (str1Size < str2Size)
        c = -1;
      else if (str1Size > str2Size)
        c = 1;
      else {
        // Exact match
        return str2Value;
      }
    }

    // c is > 0 if the string we're searching for comes after the middle point
    if (c > 0) first = middle + 1;
    else last = middle - 1;

    middle = (first + last) / 2;
  }

  // At this point, we haven't found the unique string in the bytecode. We need
  // to check in RAM. Now we're comparing an in-RAM string against other in-RAM
  // strings, so it's using gc_deref instead of pgm_deref, and memcmp instead of
  // memcmp_pgm. Also, we're looking for an exact match, not performing a binary
  // search with inequality comparison, since the linked list of unique strings
  // in RAM is not sorted.
  vm_Pointer vpCell = vm->uniqueStrings;
  TsUniqueStringCell* pCell;
  while (vpCell != VM_VALUE_NULL) {
    pCell = gc_deref(vm, vpCell);
    Value str2Value = pCell->str;
    uint16_t str2Header = vm_readHeaderWord(vm, str2Value);
    int str2Size = vm_paramOfHeaderWord(str2Header);
    VM_PROGMEM_P str2Data = gc_deref(vm, str2Value);

    // The sizes have to match for the strings to be equal
    if (str2Size == str1Size) {
      // Note: we use memcmp instead of strcmp because strings are allowed to
      // have embedded null terminators.
      int c = memcmp(str1Data, str2Data, str1Size);
      // Equal?
      if (c == 0) {
        return str2Value;
      }
    }
    vpCell = pCell->next;
  }

  // If we get here, it means there was no matching unique string already
  // existing in ROM or RAM. We upgrade the current string to a
  // TC_UNIQUE_STRING, since we now know it doesn't conflict with any existing
  // existing unique strings.
  str1Header = str1Size | (TC_UNIQUE_STRING << 12);
  ((uint16_t*)str1Data)[-1] = str1Header; // Overwrite the header

  // Add the string to the linked list of unique strings
  int cellSize = sizeof (TsUniqueStringCell);
  vpCell = gc_allocate(vm, cellSize, TC_NONE, cellSize, (void**)&pCell);
  // Push onto linked list
  pCell->next = vm->uniqueStrings;
  pCell->str = value;
  vm->uniqueStrings = vpCell;

  return value;

  // TODO: We need the GC to collect unique strings from RAM
}

// Same semantics as [memcmp](http://www.cplusplus.com/reference/cstring/memcmp/)
// but the second argument is a program memory pointer
static int memcmp_pgm(void* p1, VM_PROGMEM_P p2, size_t size) {
  while (size) {
    char c1 = *((uint8_t*)p1);
    char c2 = VM_READ_PROGMEM_1(p2);
    p1 = (void*)((uint8_t*)p1 + 1);
    p2 = VM_PROGMEM_P_ADD(p2, 1);
    size--;
    if (c1 == c2) continue;
    else if (c1 < c2) return -1;
    else return 1;
  }
  // If it's got this far, then all the bytes are equal
  return 0;
}

static VM_PROGMEM_P pgm_deref(VM* vm, vm_Pointer vp) {
  VM_ASSERT(vm, VM_IS_PGM_P(vp));
  return VM_PROGMEM_P_ADD(vm->pBytecode, VM_VALUE_OF(vp));
}

/** Size of string excluding bonus null terminator */
static uint16_t vm_stringSizeUtf8(VM* vm, Value stringValue) {
  vm_HeaderWord headerWord = vm_readHeaderWord(vm, stringValue);
  #if VM_SAFE_MODE
    ivm_TeTypeCode typeCode = vm_typeCodeFromHeaderWord(headerWord);
    VM_ASSERT(vm, (typeCode == TC_STRING) || (typeCode == TC_UNIQUE_STRING));
  #endif
  return vm_paramOfHeaderWord(headerWord) - 1;
}

static Value uintToStr(VM* vm, uint16_t n) {
  char buf[8];
  char* c = &buf[sizeof buf];
  // Null terminator
  c--; *c = 0;
  // Convert to string
  // TODO: Test this
  while (n) {
    c--;
    *c = n % 10;
    n /= 10;
  }
  if (c < buf) VM_UNEXPECTED_INTERNAL_ERROR(vm);

  uint8_t len = (uint8_t)(buf + sizeof buf - c);
  char* data;
  // Allocation includes the null terminator
  Value result = gc_allocate(vm, len, TC_STRING, len, (char**)&data);
  memcpy(data, c, len);

  return result;
}

/**
 * Checks if a string contains only decimal digits (and is not empty). May only
 * be called on TC_STRING and only those in GC memory.
 */
static bool vm_stringIsNonNegativeInteger(VM* vm, Value str) {
  VM_ASSERT(vm, deepTypeOf(vm, str) == TC_STRING);
  VM_ASSERT(vm, VM_IS_GC_P(str));

  char* data = gc_deref(vm, str);
  // Length excluding bonus null terminator
  uint16_t len = (((uint16_t*)data)[-1] & 0xFFF) - 1;
  if (!len) return false;
  while (len--) {
    if (!isdigit(*data++))
      return false;
  }
  return true;
}