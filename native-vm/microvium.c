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
#include <stdlib.h>

#include "microvium_internals.h"
#include "math.h"

// Number of words on the stack required for saving the caller state
#define VM_FRAME_SAVE_SIZE_WORDS 3

static bool vm_isHandleInitialized(VM* vm, const mvm_Handle* handle);
static TeError vm_run(VM* vm);
static void vm_push(VM* vm, uint16_t value);
static uint16_t vm_pop(VM* vm);
static TeError vm_setupCallFromExternal(VM* vm, Value func, Value* args, uint8_t argCount);
static Value vm_convertToString(VM* vm, Value value);
static Value vm_concat(VM* vm, Value left, Value right);
static TeTypeCode deepTypeOf(VM* vm, Value value);
static bool vm_isString(VM* vm, Value value);
static int32_t vm_readInt32(VM* vm, TeTypeCode type, Value value);
static TeError vm_resolveExport(VM* vm, mvm_VMExportID id, Value* result);
static inline mvm_TfHostFunction* vm_getResolvedImports(VM* vm);
static inline uint16_t vm_getResolvedImportCount(VM* vm);
static void gc_createNextBucket(VM* vm, uint16_t bucketSize);
static void* gc_allocateWithHeader2(VM* vm, uint16_t sizeBytes, TeTypeCode typeCode);
static void gc_traceValue(vm_TsGCCollectionState* gc, Value value);
static void gc_traceValueOnNewTraceStack(vm_TsGCCollectionState* gc, Value value);
static void gc_updatePointer(vm_TsGCCollectionState* gc, Value* pValue);
static void gc_freeGCMemory(VM* vm);
static Value vm_allocString(VM* vm, size_t sizeBytes, void** data);
static TeError getProperty(VM* vm, Value objectValue, Value propertyName, Value* propertyValue);
static TeError setProperty(VM* vm, Value objectValue, Value propertyName, Value propertyValue);
static TeError toPropertyName(VM* vm, Value* value);
static Value toUniqueString(VM* vm, Value value);
static uint16_t vm_stringSizeUtf8(VM* vm, Value str);
static bool vm_stringIsNonNegativeInteger(VM* vm, Value str);
static TeError toInt32Internal(mvm_VM* vm, mvm_Value value, int32_t* out_result);
static void sanitizeArgs(VM* vm, Value* args, uint8_t argCount);
static void loadPtr(VM* vm, uint8_t* heapStart, uint16_t initialHeapOffset, Value* pValue);

#if MVM_SUPPORT_FLOAT
static int32_t mvm_float64ToInt32(MVM_FLOAT64 value);
#endif

const Value mvm_undefined = VM_VALUE_UNDEFINED;
const Value vm_null = VM_VALUE_NULL;

static inline uint16_t getAllocationHeader(void* pAllocation) {
  return ((uint16_t*)pAllocation)[-1];
}

static inline uint16_t getAllocationSize(void* pAllocation) {
  return vm_getAllocationSizeExcludingHeaderFromHeaderWord(((uint16_t*)pAllocation)[-1]);
}

static inline TeTypeCode vm_getTypeCodeFromHeaderWord(uint16_t headerWord) {
  CODE_COVERAGE(1); // Hit
  // The type code is in the high byte because it's the byte that occurs closest
  // to the allocation itself, potentially allowing us in future to omit the
  // size in the allocation header for some kinds of allocations.
  return (TeTypeCode)(headerWord >> 12);
}

static inline uint16_t makeHeaderWord(VM* vm, TeTypeCode tc, uint16_t size) {
  CODE_COVERAGE_UNTESTED(210); // Not hit
  VM_ASSERT(vm, size <= MAX_ALLOCATION_SIZE);
  VM_ASSERT(vm, tc <= 0xF);
  return ((tc << 12) | size);
}

static inline VirtualInt14 VirtualInt14_encode(VM* vm, int16_t i) {
  VM_ASSERT(vm, (i >= -0x2000) && (i < 0x1FFF));
  return ((uint16_t)i << 2) | 3;
}

static inline int16_t VirtualInt14_decode(VM* vm, VirtualInt14 viInt) {
  VM_ASSERT(vm, Value_isVirtualInt14(viInt));
  return (int16_t)viInt >> 2;
}

static void setHeaderWord(VM* vm, void* pAllocation, TeTypeCode tc, uint16_t size) {
  ((uint16_t*)pAllocation)[-1] = makeHeaderWord(vm, tc, size);
}

// Returns the allocation size, excluding the header itself
static inline uint16_t vm_getAllocationSizeExcludingHeaderFromHeaderWord(uint16_t headerWord) {
  CODE_COVERAGE(2); // Hit
  return headerWord & 0xFFF;
}

TeError mvm_restore(mvm_VM** result, LongPtr pBytecode, size_t bytecodeSize, void* context, mvm_TfResolveImport resolveImport) {
  CODE_COVERAGE(3); // Hit

  mvm_TfHostFunction* resolvedImports;
  mvm_TfHostFunction* resolvedImport;
  void* dataMemory;
  LongPtr pImportTableStart;
  LongPtr pImportTableEnd;
  LongPtr pImportTableEntry;
  uint16_t initialHeapOffset;
  uint16_t initialHeapSize;

  #if MVM_SAFE_MODE
    uint16_t x = 0x4243;
    bool isLittleEndian = ((uint8_t*)&x)[0] == 0x43;
    VM_ASSERT(NULL, isLittleEndian);
    VM_ASSERT(NULL, sizeof (ShortPtr) == 2);
  #endif

  TeError err = MVM_E_SUCCESS;
  VM* vm = NULL;

  // Bytecode size field is located at the second word
  if (bytecodeSize < 4) {
    CODE_COVERAGE_ERROR_PATH(21); // Not hit
    return MVM_E_INVALID_BYTECODE;
  }
  uint16_t expectedBytecodeSize = VM_READ_BC_2_HEADER_FIELD(bytecodeSize, pBytecode);
  if (bytecodeSize != expectedBytecodeSize) {
    CODE_COVERAGE_ERROR_PATH(240); // Not hit
    return MVM_E_INVALID_BYTECODE;
  }

  uint16_t expectedCRC = VM_READ_BC_2_HEADER_FIELD(crc, pBytecode);
  if (!MVM_CHECK_CRC16_CCITT(MVM_LONG_PTR_ADD(pBytecode, 6), (uint16_t)bytecodeSize - 6, expectedCRC)) {
    CODE_COVERAGE_ERROR_PATH(54); // Not hit
    return MVM_E_BYTECODE_CRC_FAIL;
  }

  uint8_t headerSize = VM_READ_BC_1_HEADER_FIELD(headerSize, pBytecode);
  if (bytecodeSize < headerSize) {
    CODE_COVERAGE_ERROR_PATH(241); // Not hit
    return MVM_E_INVALID_BYTECODE;
  }

  // For the moment we expect an exact header size
  if (headerSize != sizeof (mvm_TsBytecodeHeader)) {
    CODE_COVERAGE_ERROR_PATH(242); // Not hit
    return MVM_E_INVALID_BYTECODE;
  }

  uint8_t bytecodeVersion = VM_READ_BC_1_HEADER_FIELD(bytecodeVersion, pBytecode);
  if (bytecodeVersion != MVM_BYTECODE_VERSION) {
    CODE_COVERAGE_ERROR_PATH(430); // Not hit
    return MVM_E_INVALID_BYTECODE;
  }

  uint32_t featureFlags;
  VM_READ_BC_N_AT(&featureFlags, OFFSETOF(mvm_TsBytecodeHeader, requiredFeatureFlags), 4, pBytecode);
  if (MVM_SUPPORT_FLOAT && !(featureFlags & (1 << FF_FLOAT_SUPPORT))) {
    CODE_COVERAGE_ERROR_PATH(180); // Not hit
    return MVM_E_BYTECODE_REQUIRES_FLOAT_SUPPORT;
  }

  uint16_t importTableOffset = VM_READ_BC_2_HEADER_FIELD(importTableOffset, pBytecode);
  uint16_t importTableSize = VM_READ_BC_2_HEADER_FIELD(importTableSize, pBytecode);
  uint16_t initialDataOffset = VM_READ_BC_2_HEADER_FIELD(initialDataOffset, pBytecode);
  uint16_t initialDataSize = VM_READ_BC_2_HEADER_FIELD(initialDataSize, pBytecode);

  uint16_t importCount = importTableSize / sizeof (vm_TsImportTableEntry);

  size_t allocationSize = sizeof(mvm_VM) +
    sizeof(mvm_TfHostFunction) * importCount +  // Import table
    initialDataSize; // Data memory (globals)
  vm = (VM*)malloc(allocationSize);
  if (!vm) {
    err = MVM_E_MALLOC_FAIL;
    goto LBL_EXIT;
  }
  #if MVM_SAFE_MODE
    memset(vm, 0, allocationSize);
  #else
    memset(vm, 0, sizeof (mvm_VM));
  #endif
  resolvedImports = vm_getResolvedImports(vm);
  vm->context = context;
  vm->pBytecode = pBytecode;
  vm->dataMemory = (void*)(resolvedImports + importCount);

  // Builtins
  memcpy_long(&vm->builtins, LongPtr_add(pBytecode, OFFSETOF(mvm_TsBytecodeHeader, builtins)), sizeof vm->builtins);

  pImportTableStart = MVM_LONG_PTR_ADD(pBytecode, importTableOffset);
  pImportTableEnd = MVM_LONG_PTR_ADD(pImportTableStart, importTableSize);
  // Resolve imports (linking)
  resolvedImport = resolvedImports;
  pImportTableEntry = pImportTableStart;
  while (pImportTableEntry < pImportTableEnd) {
    CODE_COVERAGE(431); // Hit
    mvm_HostFunctionID hostFunctionID = MVM_READ_LONG_PTR_2(pImportTableEntry);
    pImportTableEntry = MVM_LONG_PTR_ADD(pImportTableEntry, sizeof (vm_TsImportTableEntry));
    mvm_TfHostFunction handler = NULL;
    err = resolveImport(hostFunctionID, context, &handler);
    if (err != MVM_E_SUCCESS) {
      CODE_COVERAGE_ERROR_PATH(432); // Not hit
      goto LBL_EXIT;
    }
    if (!handler) {
      CODE_COVERAGE_ERROR_PATH(433); // Not hit
      err = MVM_E_UNRESOLVED_IMPORT;
      goto LBL_EXIT;
    } else {
      CODE_COVERAGE(434); // Hit
    }
    *resolvedImport++ = handler;
  }

  // The GC is empty to start
  gc_freeGCMemory(vm);

  // Initialize data
  dataMemory = vm->dataMemory;
  VM_READ_BC_N_AT(dataMemory, initialDataOffset, initialDataSize, pBytecode);

  // Initialize heap
  initialHeapOffset = VM_READ_BC_2_HEADER_FIELD(initialHeapOffset, pBytecode);
  initialHeapSize = VM_READ_BC_2_HEADER_FIELD(initialHeapSize, pBytecode);
  vm->heapSizeUsedAfterLastGC = initialHeapSize;

  if (initialHeapSize) {
    CODE_COVERAGE(435); // Hit
    gc_createNextBucket(vm, initialHeapSize);
    VM_ASSERT(vm, !vm->pLastBucket2->prev); // Only one bucket
    uint8_t* heapStart = vm->pAllocationCursor2;
    VM_READ_BC_N_AT(heapStart, initialHeapOffset, initialHeapSize, pBytecode);
    vm->pAllocationCursor2 += initialHeapSize;

    loadPointers(vm, heapStart, initialHeapOffset);
  } else {
    CODE_COVERAGE_UNTESTED(436); // Not hit
  }

LBL_EXIT:
  if (err != MVM_E_SUCCESS) {
    CODE_COVERAGE_ERROR_PATH(437); // Not hit
    *result = NULL;
    if (vm) {
      free(vm);
      vm = NULL;
    } else {
      CODE_COVERAGE_ERROR_PATH(438); // Not hit
    }
  } else {
    CODE_COVERAGE(439); // Hit
  }
  *result = vm;
  return err;
}

/**
 * Translates a pointer from its serialized form to its runtime form.
 *
 * More precisely, it returns a ShortPtr iff the value is a BytecodeMappedPtr
 * which maps to GC memory.
 */
static void loadPtr(VM* vm, uint8_t* heapStart, uint16_t initialHeapOffset, Value* pValue) {
  Value value = *pValue;

  if (!Value_encodesBytecodeMappedPtr(value))
    return;

  uint16_t offset = value >> 1;

  if (offset < initialHeapOffset)
    return;

  uint8_t* p = heapStart + (offset - initialHeapOffset);

  *pValue = ShortPtr_encode(vm, p);
}

/**
 * Called at startup to translate all the pointers that point to GC memory into
 * ShortPtr for efficiency.
 */
static void loadPointers(VM* vm, uint8_t* heapStart, uint16_t initialHeapOffset) {
  uint16_t n;
  uint16_t* p;

  // Roots in global variables
  n = VM_READ_BC_2_HEADER_FIELD(globalVariableCount, vm->pBytecode);
  p = (uint16_t*)vm->dataMemory;
  while (n--) {
    loadPtr(vm, heapStart, initialHeapOffset, p++);
  }

  // Builtin roots
  n = sizeof (TsBuiltinRoots) / 2;
  p = (uint16_t*)&vm->builtins;
  while (n--) {
    loadPtr(vm, heapStart, initialHeapOffset, p++);
  }

  // Roots in data memory
  {
    uint16_t gcRootsOffset = VM_READ_BC_2_HEADER_FIELD(gcRootsOffset, vm->pBytecode);
    uint16_t n = VM_READ_BC_2_HEADER_FIELD(gcRootsCount, vm->pBytecode);

    LongPtr pTableEntry = LongPtr_add(vm->pBytecode, gcRootsOffset);
    uint16_t* dataMemory = (uint16_t*)vm->dataMemory;
    while (n--) {
      // The table entry in program memory gives us an offset in data memory
      uint16_t dataOffsetWords = LongPtr_read2(pTableEntry);
      pTableEntry = LongPtr_add(pTableEntry, 2);
      uint16_t* dataValue = &dataMemory[dataOffsetWords];
      loadPtr(vm, heapStart, initialHeapOffset, dataValue);
    }
  }

  // Pointers in heap memory
  p = heapStart;
  uint16_t* heapEnd = vm->pAllocationCursor2;
  while (p < heapEnd) {
    uint16_t header = *p++;
    uint16_t size = vm_getAllocationSizeExcludingHeaderFromHeaderWord(header);
    uint16_t words = (size + 1) / 2;
    TeTypeCode tc = vm_getTypeCodeFromHeaderWord(header);

    if (tc < TC_REF_DIVIDER_CONTAINER_TYPES) { // Non-container types
      p += words;
      continue;
    } // Else, container types

    while (words--) {
      if (Value_isBytecodeMappedPtr(*p))
        loadPtr(vm, heapStart, initialHeapOffset, p);
      p++;
    }
  }
}

void* mvm_getContext(VM* vm) {
  return vm->context;
}

static const Value smallLiterals[] = {
  /* VM_SLV_NULL */         VM_VALUE_NULL,
  /* VM_SLV_UNDEFINED */    VM_VALUE_UNDEFINED,
  /* VM_SLV_FALSE */        VM_VALUE_FALSE,
  /* VM_SLV_TRUE */         VM_VALUE_TRUE,
  /* VM_SLV_INT_0 */        VM_INT_VALUE(0),
  /* VM_SLV_INT_1 */        VM_INT_VALUE(1),
  /* VM_SLV_INT_2 */        VM_INT_VALUE(2),
  /* VM_SLV_INT_MINUS_1 */  VM_INT_VALUE(-1),
};
#define smallLiteralsSize (sizeof smallLiterals / sizeof smallLiterals[0])


static TeError vm_run(VM* vm) {
  CODE_COVERAGE(4); // Hit

  #define CACHE_REGISTERS() do { \
    vm_TsRegisters* reg = &vm->stack->reg; \
    programCounter = reg->programCounter2; \
    argCount = reg->argCount; \
    pFrameBase = reg->pFrameBase; \
    pStackPointer = reg->pStackPointer; \
  } while (false)

  #define FLUSH_REGISTER_CACHE() do { \
    vm_TsRegisters* reg = &vm->stack->reg; \
    reg->programCounter2 = programCounter; \
    reg->argCount = argCount; \
    reg->pFrameBase = pFrameBase; \
    reg->pStackPointer = pStackPointer; \
  } while (false)

  #define READ_PGM_1(target) do { \
    target = MVM_READ_LONG_PTR_1(programCounter);\
    programCounter = MVM_LONG_PTR_ADD(programCounter, 1); \
  } while (false)

  #define READ_PGM_2(target) do { \
    target = MVM_READ_LONG_PTR_2(programCounter); \
    programCounter = MVM_LONG_PTR_ADD(programCounter, 2); \
  } while (false)

  // Reinterpret reg1 as 8-bit signed
  #define SIGN_EXTEND_REG_1() reg1 = (uint16_t)((int16_t)((int8_t)reg1))

  #define PUSH(v) *(pStackPointer++) = (v)
  #define POP() (*(--pStackPointer))
  #define INSTRUCTION_RESERVED() VM_ASSERT(vm, false)

  VM_SAFE_CHECK_NOT_NULL(vm);
  VM_SAFE_CHECK_NOT_NULL(vm->stack);

  uint16_t* globals = (uint16_t*)vm->dataMemory;
  TeError err = MVM_E_SUCCESS;

  uint16_t* pFrameBase;
  uint16_t argCount; // Of active function
  register LongPtr programCounter;
  register uint16_t* pStackPointer;
  register uint16_t reg1 = 0;
  register uint16_t reg2 = 0;
  register uint16_t reg3 = 0;

  CACHE_REGISTERS();

  #if MVM_DONT_TRUST_BYTECODE
    uint16_t bytecodeSize = VM_READ_BC_2_HEADER_FIELD(bytecodeSize, vm->pBytecode);
    uint16_t stringTableOffset = VM_READ_BC_2_HEADER_FIELD(stringTableOffset, vm->pBytecode);
    uint16_t stringTableSize = VM_READ_BC_2_HEADER_FIELD(stringTableSize, vm->pBytecode);

    VM_ASSERT(vm, stringTableSize <= 0x7FFF);
    // It's an implementation detail that no code starts before the end of the string table
    LongPtr minProgramCounter = MVM_LONG_PTR_ADD(vm->pBytecode, ((intptr_t)stringTableOffset + stringTableSize));
    LongPtr maxProgramCounter = MVM_LONG_PTR_ADD(vm->pBytecode, bytecodeSize);
  #endif

// This forms the start of the run loop
LBL_DO_NEXT_INSTRUCTION:
  CODE_COVERAGE(59); // Hit

  // Check we're within range
  #if MVM_DONT_TRUST_BYTECODE
  if ((programCounter < minProgramCounter) || (programCounter >= maxProgramCounter)) {
    VM_INVALID_BYTECODE(vm);
  }
  #endif

  // Instruction bytes are divided into two nibbles
  READ_PGM_1(reg3);
  reg1 = reg3 & 0xF;
  reg3 = reg3 >> 4;

  if (reg3 >= VM_OP_DIVIDER_1) {
    CODE_COVERAGE(428); // Hit
    reg2 = POP();
  } else {
    CODE_COVERAGE(429); // Hit
  }

  VM_ASSERT(vm, reg3 < VM_OP_END);
  MVM_SWITCH_CONTIGUOUS(reg3, (VM_OP_END - 1)) {

/* ------------------------------------------------------------------------- */
/*                         VM_OP_LOAD_SMALL_LITERAL                          */
/*   Expects:                                                                */
/*     reg1: small literal ID                                                */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS(VM_OP_LOAD_SMALL_LITERAL): {
      CODE_COVERAGE(60); // Hit
      TABLE_COVERAGE(reg1, smallLiteralsSize, 448); // Hit 8/8

      #if MVM_DONT_TRUST_BYTECODE
      if (reg1 >= smallLiteralsSize) {
        err = MVM_E_INVALID_BYTECODE;
        goto LBL_EXIT;
      }
      #endif
      reg1 = smallLiterals[reg1];
      goto LBL_TAIL_PUSH_REG1;
    }

/* ------------------------------------------------------------------------- */
/*                             VM_OP_LOAD_VAR_1                              */
/*   Expects:                                                                */
/*     reg1: variable index                                                  */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP_LOAD_VAR_1):
    LBL_OP_LOAD_VAR:
      CODE_COVERAGE(61); // Hit
      reg1 = pStackPointer[-reg1 - 1];
      goto LBL_TAIL_PUSH_REG1;

/* ------------------------------------------------------------------------- */
/*                            VM_OP_LOAD_GLOBAL_1                            */
/*   Expects:                                                                */
/*     reg1: variable index                                                  */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP_LOAD_GLOBAL_1):
    LBL_OP_LOAD_GLOBAL:
      CODE_COVERAGE(62); // Hit
      reg1 = globals[reg1];
      goto LBL_TAIL_PUSH_REG1;

/* ------------------------------------------------------------------------- */
/*                             VM_OP_LOAD_ARG_1                              */
/*   Expects:                                                                */
/*     reg1: argument index                                                  */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP_LOAD_ARG_1):
      CODE_COVERAGE(63); // Hit
      goto LBL_OP_LOAD_ARG;

/* ------------------------------------------------------------------------- */
/*                               VM_OP_CALL_1                                */
/*   Expects:                                                                */
/*     reg1: index into short-call table                                     */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP_CALL_1): {
      CODE_COVERAGE_UNTESTED(66); // Not hit
      goto LBL_OP_CALL_1;
    }

/* ------------------------------------------------------------------------- */
/*                             VM_OP_EXTENDED_1                              */
/*   Expects:                                                                */
/*     reg1: vm_TeOpcodeEx1                                                  */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP_EXTENDED_1):
      CODE_COVERAGE(69); // Hit
      goto LBL_OP_EXTENDED_1;

/* ------------------------------------------------------------------------- */
/*                             VM_OP_EXTENDED_2                              */
/*   Expects:                                                                */
/*     reg1: vm_TeOpcodeEx2                                                  */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP_EXTENDED_2):
      CODE_COVERAGE(70); // Hit
      goto LBL_OP_EXTENDED_2;

/* ------------------------------------------------------------------------- */
/*                             VM_OP_EXTENDED_3                              */
/*   Expects:                                                                */
/*     reg1: vm_TeOpcodeEx3                                                  */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP_EXTENDED_3):
      CODE_COVERAGE(71); // Hit
      goto LBL_OP_EXTENDED_3;

/* ------------------------------------------------------------------------- */
/*                                VM_OP_POP                                  */
/*   Expects:                                                                */
/*     reg1: pop count - 1                                                   */
/*     reg2: unused value already popped off the stack                       */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP_POP): {
      CODE_COVERAGE(72); // Hit
      pStackPointer -= reg1;
      goto LBL_DO_NEXT_INSTRUCTION;
    }

/* ------------------------------------------------------------------------- */
/*                             VM_OP_STORE_VAR_1                             */
/*   Expects:                                                                */
/*     reg1: variable index relative to stack pointer                        */
/*     reg2: value to store                                                  */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP_STORE_VAR_1): {
      CODE_COVERAGE(73); // Hit
    LBL_OP_STORE_VAR:
      // Note: the value to store has already been popped off the stack at this
      // point. The index 0 refers to the slot currently at the top of the
      // stack.
      pStackPointer[-reg1 - 1] = reg2;
      goto LBL_DO_NEXT_INSTRUCTION;
    }

/* ------------------------------------------------------------------------- */
/*                           VM_OP_STORE_GLOBAL_1                            */
/*   Expects:                                                                */
/*     reg1: variable index                                                  */
/*     reg2: value to store                                                  */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP_STORE_GLOBAL_1): {
      CODE_COVERAGE(74); // Hit
    LBL_OP_STORE_GLOBAL:
      globals[reg1] = reg2;
      goto LBL_DO_NEXT_INSTRUCTION;
    }

/* ------------------------------------------------------------------------- */
/*                            VM_OP_STRUCT_GET_1                             */
/*   Expects:                                                                */
/*     reg1: field index                                                     */
/*     reg2: struct reference                                                */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP_STRUCT_GET_1): {
      CODE_COVERAGE_UNTESTED(75); // Not hit
    LBL_OP_STRUCT_GET:
      INSTRUCTION_RESERVED();
      goto LBL_DO_NEXT_INSTRUCTION;
    }

/* ------------------------------------------------------------------------- */
/*                            VM_OP_STRUCT_SET_1                             */
/*   Expects:                                                                */
/*     reg1: field index                                                     */
/*     reg2: value to store                                                  */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP_STRUCT_SET_1): {
      CODE_COVERAGE_UNTESTED(76); // Not hit
    LBL_OP_STRUCT_SET:
      INSTRUCTION_RESERVED();
      goto LBL_DO_NEXT_INSTRUCTION;
    }

/* ------------------------------------------------------------------------- */
/*                              VM_OP_NUM_OP                                 */
/*   Expects:                                                                */
/*     reg1: vm_TeNumberOp                                                   */
/*     reg2: first popped operand                                            */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP_NUM_OP): {
      CODE_COVERAGE(77); // Hit
      goto LBL_OP_NUM_OP;
    } // End of case VM_OP_NUM_OP

/* ------------------------------------------------------------------------- */
/*                              VM_OP_BIT_OP                                 */
/*   Expects:                                                                */
/*     reg1: vm_TeBitwiseOp                                                  */
/*     reg2: first popped operand                                            */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP_BIT_OP): {
      CODE_COVERAGE(92); // Hit
      goto LBL_OP_BIT_OP;
    }

  } // End of primary switch

  // All cases should loop explicitly back
  VM_ASSERT_UNREACHABLE(vm);

/* ------------------------------------------------------------------------- */
/*                             LBL_OP_LOAD_ARG                              */
/*   Expects:                                                                */
/*     reg1: argument index                                                  */
/* ------------------------------------------------------------------------- */
LBL_OP_LOAD_ARG: {
  CODE_COVERAGE(32); // Hit
  if (reg1 < argCount) {
    CODE_COVERAGE(64); // Hit
    reg1 = pFrameBase[-3 - (int16_t)argCount + reg1];
  } else {
    CODE_COVERAGE_UNTESTED(65); // Not hit
    reg1 = VM_VALUE_UNDEFINED;
  }
  goto LBL_TAIL_PUSH_REG1;
}

/* ------------------------------------------------------------------------- */
/*                               LBL_OP_CALL_1                               */
/*   Expects:                                                                */
/*     reg1: index into short-call table                                     */
/* ------------------------------------------------------------------------- */

LBL_OP_CALL_1: {
  CODE_COVERAGE_UNTESTED(173); // Not hit
  LongPtr pBytecode = vm->pBytecode;
  uint16_t shortCallTableOffset = VM_READ_BC_2_HEADER_FIELD(shortCallTableOffset, pBytecode);
  LongPtr shortCallTableEntry = MVM_LONG_PTR_ADD(pBytecode, shortCallTableOffset + reg1 * sizeof (vm_TsShortCallTableEntry));

  #if MVM_SAFE_MODE
    uint16_t shortCallTableSize = VM_READ_BC_2_HEADER_FIELD(shortCallTableOffset, pBytecode);
    LongPtr shortCallTableEnd = MVM_LONG_PTR_ADD(pBytecode, shortCallTableOffset + shortCallTableSize);
    VM_ASSERT(vm, shortCallTableEntry < shortCallTableEnd);
  #endif

  uint16_t tempFunction = MVM_READ_LONG_PTR_2(shortCallTableEntry);
  shortCallTableEntry = MVM_LONG_PTR_ADD(shortCallTableEntry, 2);
  uint8_t tempArgCount = MVM_READ_PROGMEM_1(shortCallTableEntry);

  // The high bit of function indicates if this is a call to the host
  bool isHostCall = tempFunction & 0x8000;
  tempFunction = tempFunction & 0x7FFF;

  reg1 = tempArgCount;

  if (isHostCall) {
    CODE_COVERAGE_UNTESTED(67); // Not hit
    reg2 = tempFunction;
    reg3 = 0; // Indicates that a function pointer was not pushed onto the stack to make this call
    goto LBL_CALL_HOST_COMMON;
  } else {
    CODE_COVERAGE_UNTESTED(68); // Not hit
    reg2 = tempFunction;
    goto LBL_CALL_COMMON;
  }
} // LBL_OP_CALL_1

/* ------------------------------------------------------------------------- */
/*                              LBL_OP_BIT_OP                                */
/*   Expects:                                                                */
/*     reg1: vm_TeBitwiseOp                                                  */
/*     reg2: first popped operand                                            */
/* ------------------------------------------------------------------------- */
LBL_OP_BIT_OP: {
  int32_t reg1I = 0;
  int32_t reg2I = 0;
  int8_t reg2B = 0;

  reg3 = reg1;

  // Convert second operand to an int32
  reg2I = mvm_toInt32(vm, reg2);

  // If it's a binary operator, then we pop a second operand
  if (reg3 < VM_BIT_OP_DIVIDER_2) {
    CODE_COVERAGE(117); // Hit
    reg1 = POP();
    reg1I = mvm_toInt32(vm, reg1);

    // If we're doing a shift operation, the operand is in the 0-32 range
    if (reg3 < VM_BIT_OP_END_OF_SHIFT_OPERATORS) {
      reg2B = reg2I & 0x1F;
    }
  } else {
    CODE_COVERAGE(118); // Hit
  }

  VM_ASSERT(vm, reg3 < VM_BIT_OP_END);
  MVM_SWITCH_CONTIGUOUS (reg3, (VM_BIT_OP_END - 1)) {
    MVM_CASE_CONTIGUOUS(VM_BIT_OP_SHR_ARITHMETIC): {
      CODE_COVERAGE(93); // Hit
      reg1I = reg1I >> reg2B;
      break;
    }
    MVM_CASE_CONTIGUOUS(VM_BIT_OP_SHR_LOGICAL): {
      CODE_COVERAGE(94); // Hit
      // Cast the number to unsigned int so that the C interprets the shift
      // as unsigned/logical rather than signed/arithmetic.
      reg1I = (int32_t)((uint32_t)reg1I >> reg2B);
      #if MVM_SUPPORT_FLOAT && MVM_PORT_INT32_OVERFLOW_CHECKS
        // This is a rather annoying edge case if you ask me, since all
        // other bitwise operations yield signed int32 results every time.
        // If the shift is by exactly zero units, then negative numbers
        // become positive and overflow the signed-32 bit type. Since we
        // don't have an unsigned 32 bit type, this means they need to be
        // extended to floats.
        // https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Bitwise_Operators#Signed_32-bit_integers
        if ((reg2B == 0) & (reg1I < 0)) {
          reg1 = mvm_newNumber(vm, (MVM_FLOAT64)((uint32_t)reg1I));
          goto LBL_TAIL_PUSH_REG1;
        }
      #endif // MVM_PORT_INT32_OVERFLOW_CHECKS
      break;
    }
    MVM_CASE_CONTIGUOUS(VM_BIT_OP_SHL): {
      CODE_COVERAGE(95); // Hit
      reg1I = reg1I << reg2B;
      break;
    }
    MVM_CASE_CONTIGUOUS(VM_BIT_OP_OR): {
      CODE_COVERAGE(96); // Hit
      reg1I = reg1I | reg2I;
      break;
    }
    MVM_CASE_CONTIGUOUS(VM_BIT_OP_AND): {
      CODE_COVERAGE(97); // Hit
      reg1I = reg1I & reg2I;
      break;
    }
    MVM_CASE_CONTIGUOUS(VM_BIT_OP_XOR): {
      CODE_COVERAGE(98); // Hit
      reg1I = reg1I ^ reg2I;
      break;
    }
    MVM_CASE_CONTIGUOUS(VM_BIT_OP_NOT): {
      CODE_COVERAGE(99); // Hit
      reg1I = ~reg2I;
      break;
    }
  }

  CODE_COVERAGE(101); // Hit
  // Convert the result from a 32-bit integer
  reg1 = mvm_newInt32(vm, reg1I);
  goto LBL_TAIL_PUSH_REG1;
} // End of LBL_OP_BIT_OP

/* ------------------------------------------------------------------------- */
/*                             LBL_OP_EXTENDED_1                             */
/*   Expects:                                                                */
/*     reg1: vm_TeOpcodeEx1                                                  */
/* ------------------------------------------------------------------------- */

LBL_OP_EXTENDED_1: {
  CODE_COVERAGE(102); // Hit

  reg3 = reg1;

  if (reg3 >= VM_OP1_DIVIDER_1) {
    CODE_COVERAGE(103); // Hit
    reg2 = POP();
    reg1 = POP();
  } else {
    CODE_COVERAGE(104); // Hit
  }

  VM_ASSERT(vm, reg3 <= VM_OP1_END);
  MVM_SWITCH_CONTIGUOUS (reg3, VM_OP1_END - 1) {

/* ------------------------------------------------------------------------- */
/*                              VM_OP1_RETURN_x                              */
/*   Expects:                                                                */
/*     reg1: vm_TeOpcodeEx1                                                  */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP1_RETURN_1):
    MVM_CASE_CONTIGUOUS (VM_OP1_RETURN_2):
    MVM_CASE_CONTIGUOUS (VM_OP1_RETURN_3):
    MVM_CASE_CONTIGUOUS (VM_OP1_RETURN_4): {
      CODE_COVERAGE(105); // Hit
      // reg2 is used for the result
      if (reg1 & VM_RETURN_FLAG_UNDEFINED) {
        CODE_COVERAGE_UNTESTED(106); // Not hit
        reg2 = VM_VALUE_UNDEFINED;
      } else {
        CODE_COVERAGE(107); // Hit
        reg2 = POP();
      }

      // reg3 is the original arg count
      reg3 = argCount;

      // Pop variables/parameters
      pStackPointer = pFrameBase;

      // Restore caller state
      programCounter = MVM_LONG_PTR_ADD(vm->pBytecode, POP());
      argCount = POP();
      pFrameBase = VM_BOTTOM_OF_STACK(vm) + POP();

      // Pop arguments
      pStackPointer -= reg3;
      // Pop function reference
      if (reg1 & VM_RETURN_FLAG_POP_FUNCTION) {
        CODE_COVERAGE(108); // Hit
        (void)POP();
      } else {
        CODE_COVERAGE_UNTESTED(109); // Not hit
      }

      // Push result
      PUSH(reg2);

      if (programCounter == vm->pBytecode) {
        CODE_COVERAGE(110); // Hit
        goto LBL_EXIT;
      } else {
        CODE_COVERAGE(111); // Hit
      }
      goto LBL_DO_NEXT_INSTRUCTION;
    }

/* ------------------------------------------------------------------------- */
/*                              VM_OP1_OBJECT_NEW                            */
/*   Expects:                                                                */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP1_OBJECT_NEW): {
      CODE_COVERAGE(112); // Hit
      TsPropertyList2* pObject = (TsPropertyList2*)gc_allocateWithHeader2(vm, sizeof (TsPropertyList2), TC_REF_PROPERTY_LIST);
      reg1 = ShortPtr_encode(vm, pObject);
      pObject->dpNext = VM_VALUE_NULL;
      pObject->dpProto = VM_VALUE_NULL;
      goto LBL_TAIL_PUSH_REG1;
    }

/* ------------------------------------------------------------------------- */
/*                               VM_OP1_LOGICAL_NOT                          */
/*   Expects:                                                                */
/*     reg1: erroneously popped value                                        */
/*     reg2: value to operate on (popped from stack)                         */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP1_LOGICAL_NOT): {
      CODE_COVERAGE(113); // Hit
      // This operation is grouped as a binary operation, but it actually
      // only uses one operand, so we need to push the other back onto the
      // stack.
      PUSH(reg1);
      reg1 = mvm_toBool(vm, reg2) ? VM_VALUE_FALSE : VM_VALUE_TRUE;
      goto LBL_TAIL_PUSH_REG1;
    }

/* ------------------------------------------------------------------------- */
/*                              VM_OP1_OBJECT_GET_1                          */
/*   Expects:                                                                */
/*     reg1: objectValue                                                     */
/*     reg2: propertyName                                                    */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP1_OBJECT_GET_1): {
      CODE_COVERAGE(114); // Hit
      Value propValue;
      err = getProperty(vm, reg1, reg2, &propValue);
      reg1 = propValue;
      if (err != MVM_E_SUCCESS) goto LBL_EXIT;
      goto LBL_TAIL_PUSH_REG1;
    }

/* ------------------------------------------------------------------------- */
/*                                 VM_OP1_ADD                                */
/*   Expects:                                                                */
/*     reg1: left operand                                                    */
/*     reg2: right operand                                                   */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP1_ADD): {
      CODE_COVERAGE(115); // Hit
      // Special case for adding unsigned 12 bit numbers, for example in most
      // loops. 12 bit unsigned addition does not require any overflow checks
      if (((reg1 & 0xF000) == 0) && ((reg2 & 0xF000) == 0)) {
        CODE_COVERAGE(116); // Hit
        reg1 = reg1 + reg2;
        goto LBL_TAIL_PUSH_REG1;
      } else {
        CODE_COVERAGE(119); // Hit
      }
      if (vm_isString(vm, reg1) || vm_isString(vm, reg2)) {
        CODE_COVERAGE(120); // Hit
        reg1 = vm_convertToString(vm, reg1);
        reg2 = vm_convertToString(vm, reg2);
        reg1 = vm_concat(vm, reg1, reg2);
        goto LBL_TAIL_PUSH_REG1;
      } else {
        CODE_COVERAGE(121); // Hit
        // Interpret like any of the other numeric operations
        PUSH(reg1);
        reg1 = VM_NUM_OP_ADD_NUM;
        goto LBL_OP_NUM_OP;
      }
    }

/* ------------------------------------------------------------------------- */
/*                                 VM_OP1_EQUAL                              */
/*   Expects:                                                                */
/*     reg1: left operand                                                    */
/*     reg2: right operand                                                   */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP1_EQUAL): {
      CODE_COVERAGE_UNTESTED(122); // Not hit
      if (mvm_equal(vm, reg1, reg2)) {
        CODE_COVERAGE_UNTESTED(483); // Not hit
        reg1 = VM_VALUE_TRUE;
      } else {
        CODE_COVERAGE_UNTESTED(484); // Not hit
        reg1 = VM_VALUE_FALSE;
      }
      goto LBL_TAIL_PUSH_REG1;
    }

/* ------------------------------------------------------------------------- */
/*                                 VM_OP1_NOT_EQUAL                          */
/*   Expects:                                                                */
/*     reg1: left operand                                                    */
/*     reg2: right operand                                                   */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP1_NOT_EQUAL): {
      if(mvm_equal(vm, reg1, reg2)) {
        CODE_COVERAGE_UNTESTED(123); // Not hit
        reg1 = VM_VALUE_FALSE;
      } else {
        CODE_COVERAGE(485); // Hit
        reg1 = VM_VALUE_TRUE;
      }
      goto LBL_TAIL_PUSH_REG1;
    }

/* ------------------------------------------------------------------------- */
/*                                 VM_OP1_OBJECT_SET_1                       */
/*   Expects:                                                                */
/*     reg1: property name                                                   */
/*     reg2: value                                                           */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP1_OBJECT_SET_1): {
      CODE_COVERAGE(124); // Hit
      reg3 = POP(); // object
      err = setProperty(vm, reg3, reg1, reg2);
      if (err != MVM_E_SUCCESS) {
        CODE_COVERAGE_UNTESTED(125); // Not hit
        goto LBL_EXIT;
      } else {
        CODE_COVERAGE(126); // Hit
      }
      goto LBL_DO_NEXT_INSTRUCTION;
    }

  } // End of VM_OP_EXTENDED_1 switch

  // All cases should jump to whatever tail they intend. Nothing should get here
  VM_ASSERT_UNREACHABLE(vm);

} // End of LBL_OP_EXTENDED_1

/* ------------------------------------------------------------------------- */
/*                              VM_OP_NUM_OP                                 */
/*   Expects:                                                                */
/*     reg1: vm_TeNumberOp                                                   */
/*     reg2: first popped operand                                            */
/* ------------------------------------------------------------------------- */
LBL_OP_NUM_OP: {
  CODE_COVERAGE(25); // Hit

  int32_t reg1I = 0;
  int32_t reg2I = 0;

  reg3 = reg1;

  // If it's a binary operator, then we pop a second operand
  if (reg3 < VM_NUM_OP_DIVIDER) {
    CODE_COVERAGE(440); // Hit
    reg1 = POP();

    if (toInt32Internal(vm, reg1, &reg1I) != MVM_E_SUCCESS) {
      CODE_COVERAGE(444); // Hit
      #if MVM_SUPPORT_FLOAT
      goto LBL_NUM_OP_FLOAT64;
      #endif // MVM_SUPPORT_FLOAT
    } else {
      CODE_COVERAGE(445); // Hit
    }
  } else {
    CODE_COVERAGE(441); // Hit
    reg1 = 0;
  }

  // Convert second operand to a int32
  if (toInt32Internal(vm, reg2, &reg2I) != MVM_E_SUCCESS) {
    CODE_COVERAGE(442); // Hit
    #if MVM_SUPPORT_FLOAT
    goto LBL_NUM_OP_FLOAT64;
    #endif // MVM_SUPPORT_FLOAT
  } else {
    CODE_COVERAGE(443); // Hit
  }

  VM_ASSERT(vm, reg3 < VM_NUM_OP_END);
  MVM_SWITCH_CONTIGUOUS (reg3, (VM_NUM_OP_END - 1)) {
    MVM_CASE_CONTIGUOUS(VM_NUM_OP_LESS_THAN): {
      CODE_COVERAGE(78); // Hit
      reg1 = reg1I < reg2I;
      goto LBL_TAIL_PUSH_REG1_BOOL;
    }
    MVM_CASE_CONTIGUOUS(VM_NUM_OP_GREATER_THAN): {
      CODE_COVERAGE(79); // Hit
      reg1 = reg1I > reg2I;
      goto LBL_TAIL_PUSH_REG1_BOOL;
    }
    MVM_CASE_CONTIGUOUS(VM_NUM_OP_LESS_EQUAL): {
      CODE_COVERAGE(80); // Hit
      reg1 = reg1I <= reg2I;
      goto LBL_TAIL_PUSH_REG1_BOOL;
    }
    MVM_CASE_CONTIGUOUS(VM_NUM_OP_GREATER_EQUAL): {
      CODE_COVERAGE(81); // Hit
      reg1 = reg1I >= reg2I;
      goto LBL_TAIL_PUSH_REG1_BOOL;
    }
    MVM_CASE_CONTIGUOUS(VM_NUM_OP_ADD_NUM): {
      CODE_COVERAGE(82); // Hit
      #if MVM_SUPPORT_FLOAT && MVM_PORT_INT32_OVERFLOW_CHECKS
        #if __has_builtin(__builtin_add_overflow)
          if (__builtin_add_overflow(reg1I, reg2I, &reg1I)) {
            goto LBL_NUM_OP_FLOAT64;
          }
        #else // No builtin overflow
          int32_t result = reg1I + reg2I;
          // Check overflow https://blog.regehr.org/archives/1139
          if (((reg1I ^ result) & (reg2I ^ result)) < 0) goto LBL_NUM_OP_FLOAT64;
          reg1I = result;
        #endif // No builtin overflow
      #else // No overflow checks
        reg1I = reg1I + reg2I;
      #endif
      break;
    }
    MVM_CASE_CONTIGUOUS(VM_NUM_OP_SUBTRACT): {
      CODE_COVERAGE(83); // Hit
      #if MVM_SUPPORT_FLOAT && MVM_PORT_INT32_OVERFLOW_CHECKS
        #if __has_builtin(__builtin_sub_overflow)
          if (__builtin_sub_overflow(reg1I, reg2I, &reg1I)) {
            goto LBL_NUM_OP_FLOAT64;
          }
        #else // No builtin overflow
          reg2I = -reg2I;
          int32_t result = reg1I + reg2I;
          // Check overflow https://blog.regehr.org/archives/1139
          if (((reg1I ^ result) & (reg2I ^ result)) < 0) goto LBL_NUM_OP_FLOAT64;
          reg1I = result;
        #endif // No builtin overflow
      #else // No overflow checks
        reg1I = reg1I - reg2I;
      #endif
      break;
    }
    MVM_CASE_CONTIGUOUS(VM_NUM_OP_MULTIPLY): {
      CODE_COVERAGE(84); // Hit
      #if MVM_SUPPORT_FLOAT && MVM_PORT_INT32_OVERFLOW_CHECKS
        #if __has_builtin(__builtin_mul_overflow)
          if (__builtin_mul_overflow(reg1I, reg2I, &reg1I)) {
            goto LBL_NUM_OP_FLOAT64;
          }
        #else // No builtin overflow
          // There isn't really an efficient way to determine multiplied
          // overflow on embedded devices without accessing the hardware
          // status registers. The fast shortcut here is to just assume that
          // anything more than 14-bit multiplication could overflow a 32-bit
          // integer.
          if (Value_isVirtualInt14(reg1) && Value_isVirtualInt14(reg2)) {
            reg1I = reg1I * reg2I;
          } else {
            goto LBL_NUM_OP_FLOAT64;
          }
        #endif // No builtin overflow
      #else // No overflow checks
        reg1I = reg1I * reg2I;
      #endif
      break;
    }
    MVM_CASE_CONTIGUOUS(VM_NUM_OP_DIVIDE): {
      CODE_COVERAGE(85); // Hit
      #if MVM_SUPPORT_FLOAT
        // With division, we leave it up to the user to write code that
        // performs integer division instead of floating point division, so
        // this instruction is always the case where they're doing floating
        // point division.
        goto LBL_NUM_OP_FLOAT64;
      #else // !MVM_SUPPORT_FLOAT
        err = MVM_E_OPERATION_REQUIRES_FLOAT_SUPPORT;
        goto LBL_EXIT;
      #endif
    }
    MVM_CASE_CONTIGUOUS(VM_NUM_OP_DIVIDE_AND_TRUNC): {
      CODE_COVERAGE(86); // Hit
      if (reg2I == 0) {
        reg1I = 0;
        break;
      }
      reg1I = reg1I / reg2I;
      break;
    }
    MVM_CASE_CONTIGUOUS(VM_NUM_OP_REMAINDER): {
      CODE_COVERAGE(87); // Hit
      if (reg2I == 0) {
        CODE_COVERAGE(26); // Hit
        reg1 = VM_VALUE_NAN;
        goto LBL_TAIL_PUSH_REG1;
      }
      CODE_COVERAGE(90); // Hit
      reg1I = reg1I % reg2I;
      break;
    }
    MVM_CASE_CONTIGUOUS(VM_NUM_OP_POWER): {
      CODE_COVERAGE(88); // Hit
      #if MVM_SUPPORT_FLOAT
        // Maybe in future we can we implement an integer version.
        goto LBL_NUM_OP_FLOAT64;
      #else // !MVM_SUPPORT_FLOAT
        err = MVM_E_OPERATION_REQUIRES_FLOAT_SUPPORT;
        goto LBL_EXIT;
      #endif
    }
    MVM_CASE_CONTIGUOUS(VM_NUM_OP_NEGATE): {
      CODE_COVERAGE(89); // Hit
      #if MVM_SUPPORT_FLOAT && MVM_PORT_INT32_OVERFLOW_CHECKS
        // Note: Zero negates to negative zero, which is not representable as an int32
        if ((reg2I == INT32_MIN) || (reg2I == 0)) goto LBL_NUM_OP_FLOAT64;
      #endif
        reg1I = -reg2I;
      break;
    }
    MVM_CASE_CONTIGUOUS(VM_NUM_OP_UNARY_PLUS): {
      reg1I = reg2I;
      break;
    }
  } // End of switch vm_TeNumberOp for int32

  // Convert the result from a 32-bit integer
  reg1 = mvm_newInt32(vm, reg1I);
  goto LBL_TAIL_PUSH_REG1;
} // End of case LBL_OP_NUM_OP

/* ------------------------------------------------------------------------- */
/*                             LBL_OP_EXTENDED_2                             */
/*   Expects:                                                                */
/*     reg1: vm_TeOpcodeEx2                                                  */
/* ------------------------------------------------------------------------- */

LBL_OP_EXTENDED_2: {
  CODE_COVERAGE(127); // Hit
  reg3 = reg1;

  // All the ex-2 instructions have an 8-bit parameter. This is stored in
  // reg1 for consistency with 4-bit and 16-bit literal modes
  READ_PGM_1(reg1);

  // Some operations pop an operand off the stack. This goes into reg2
  if (reg3 < VM_OP2_DIVIDER_1) {
    CODE_COVERAGE(128); // Hit
    reg2 = POP();
  } else {
    CODE_COVERAGE(129); // Hit
  }

  VM_ASSERT(vm, reg3 < VM_OP2_END);
  MVM_SWITCH_CONTIGUOUS (reg3, (VM_OP2_END - 1)) {

/* ------------------------------------------------------------------------- */
/*                             VM_OP2_BRANCH_1                              */
/*   Expects:                                                                */
/*     reg1: signed 8-bit offset to branch to, encoded in 16-bit unsigned    */
/*     reg2: condition to branch on                                          */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP2_BRANCH_1): {
      CODE_COVERAGE(130); // Hit
      SIGN_EXTEND_REG_1();
      goto LBL_BRANCH_COMMON;
    }

/* ------------------------------------------------------------------------- */
/*                             VM_OP2_STORE_ARG                             */
/*   Expects:                                                                */
/*     reg1: unsigned index of argument in which to store                    */
/*     reg2: value to store                                                  */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP2_STORE_ARG): {
      CODE_COVERAGE_UNTESTED(131); // Not hit
      VM_NOT_IMPLEMENTED(vm);
      goto LBL_DO_NEXT_INSTRUCTION;
    }

/* ------------------------------------------------------------------------- */
/*                             VM_OP2_STORE_GLOBAL_2                        */
/*   Expects:                                                                */
/*     reg1: unsigned index of global in which to store                      */
/*     reg2: value to store                                                  */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP2_STORE_GLOBAL_2): {
      CODE_COVERAGE_UNTESTED(132); // Not hit
      goto LBL_OP_STORE_GLOBAL;
    }

/* ------------------------------------------------------------------------- */
/*                             VM_OP2_STORE_VAR_2                            */
/*   Expects:                                                                */
/*     reg1: unsigned index of variable in which to store, relative to SP    */
/*     reg2: value to store                                                  */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP2_STORE_VAR_2): {
      CODE_COVERAGE_UNTESTED(133); // Not hit
      goto LBL_OP_STORE_VAR;
    }

/* ------------------------------------------------------------------------- */
/*                             VM_OP2_STRUCT_GET_2                          */
/*   Expects:                                                                */
/*     reg1: unsigned index of field                                         */
/*     reg2: reference to struct                                             */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP2_STRUCT_GET_2): {
      CODE_COVERAGE_UNTESTED(134); // Not hit
      goto LBL_OP_STRUCT_GET;
    }

/* ------------------------------------------------------------------------- */
/*                             VM_OP2_STRUCT_SET_2                          */
/*   Expects:                                                                */
/*     reg1: unsigned index of field                                         */
/*     reg2: value to store                                                  */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP2_STRUCT_SET_2): {
      CODE_COVERAGE_UNTESTED(135); // Not hit
      goto LBL_OP_STRUCT_SET;
    }

/* ------------------------------------------------------------------------- */
/*                             VM_OP2_JUMP_1                                */
/*   Expects:                                                                */
/*     reg1: signed 8-bit offset to branch to, encoded in 16-bit unsigned    */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP2_JUMP_1): {
      CODE_COVERAGE(136); // Hit
      SIGN_EXTEND_REG_1();
      goto LBL_JUMP_COMMON;
    }

/* ------------------------------------------------------------------------- */
/*                             VM_OP2_CALL_HOST                             */
/*   Expects:                                                                */
/*     reg1: arg count                                                       */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP2_CALL_HOST): {
      CODE_COVERAGE_UNTESTED(137); // Not hit
      // Function index is in reg2
      READ_PGM_1(reg2);
      reg3 = 0; // Indicate that function pointer is static (was not pushed onto the stack)
      goto LBL_CALL_HOST_COMMON;
    }

/* ------------------------------------------------------------------------- */
/*                             VM_OP2_CALL_3                                */
/*   Expects:                                                                */
/*     reg1: arg count                                                       */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP2_CALL_3): {
      CODE_COVERAGE(138); // Hit
      // The function was pushed before the arguments
      Value functionValue = pStackPointer[-reg1 - 1];

      // Functions can only be bytecode memory, so if it's not in bytecode then it's not a function
      if (!VM_IS_PGM_P(functionValue)) {
        CODE_COVERAGE_ERROR_PATH(139); // Not hit
        err = MVM_E_TARGET_NOT_CALLABLE;
        goto LBL_EXIT;
      } else {
        CODE_COVERAGE(140); // Hit
      }

      uint16_t headerWord = vm_readHeaderWord(vm, functionValue);
      TeTypeCode typeCode = vm_getTypeCodeFromHeaderWord(headerWord);
      if (typeCode == TC_REF_FUNCTION) {
        CODE_COVERAGE(141); // Hit
        VM_ASSERT(vm, VM_IS_PGM_P(functionValue));
        reg2 = VM_VALUE_OF(functionValue);
        goto LBL_CALL_COMMON;
      } else {
        CODE_COVERAGE(142); // Hit
      }

      if (typeCode == TC_REF_HOST_FUNC) {
        CODE_COVERAGE(143); // Hit
        reg2 = vm_readUInt16(vm, functionValue);
        reg3 = 1; // Indicates that function pointer was pushed onto the stack to make this call
        goto LBL_CALL_HOST_COMMON;
      } else {
        CODE_COVERAGE_ERROR_PATH(144); // Not hit
      }

      err = MVM_E_TARGET_NOT_CALLABLE;
      goto LBL_EXIT;
    }

/* ------------------------------------------------------------------------- */
/*                             VM_OP2_CALL_2                                */
/*   Expects:                                                                */
/*     reg1: arg count                                                       */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP2_CALL_2): {
      CODE_COVERAGE_UNTESTED(145); // Not hit
      // Uses 16 bit literal for function offset
      READ_PGM_2(reg2);
      goto LBL_CALL_COMMON;
    }

/* ------------------------------------------------------------------------- */
/*                             VM_OP2_LOAD_GLOBAL_2                         */
/*   Expects:                                                                */
/*     reg1: unsigned global variable index                                  */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP2_LOAD_GLOBAL_2): {
      CODE_COVERAGE(146); // Hit
      goto LBL_OP_LOAD_GLOBAL;
    }

/* ------------------------------------------------------------------------- */
/*                              VM_OP2_LOAD_VAR_2                           */
/*   Expects:                                                                */
/*     reg1: unsigned variable index relative to stack pointer               */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP2_LOAD_VAR_2): {
      CODE_COVERAGE_UNTESTED(147); // Not hit
      goto LBL_OP_LOAD_VAR;
    }

/* ------------------------------------------------------------------------- */
/*                              VM_OP2_LOAD_ARG_2                           */
/*   Expects:                                                                */
/*     reg1: unsigned variable index relative to stack pointer               */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP2_LOAD_ARG_2): {
      CODE_COVERAGE_UNTESTED(148); // Not hit
      VM_NOT_IMPLEMENTED(vm);
      goto LBL_DO_NEXT_INSTRUCTION;
    }

/* ------------------------------------------------------------------------- */
/*                              VM_OP2_RETURN_ERROR                         */
/*   Expects:                                                                */
/*     reg1: mvm_TeError                                                     */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP2_RETURN_ERROR): {
      CODE_COVERAGE_ERROR_PATH(149); // Not hit
      err = (TeError)reg1;
      goto LBL_EXIT;
    }

/* ------------------------------------------------------------------------- */
/*                              VM_OP2_ARRAY_NEW                             */
/*   reg1: Array capacity                                                    */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP2_ARRAY_NEW): {
      CODE_COVERAGE(100); // Hit

      // Allocation size excluding header
      uint16_t capacity = reg1;

      TABLE_COVERAGE(capacity ? 1 : 0, 2, 371); // Hit 2/2
      TsArray* arr = gc_allocateWithHeader2(vm, sizeof (TsArray), TC_REF_ARRAY);
      reg1 = ShortPtr_encode(vm, arr);

      arr->viLength = VirtualInt14_encode(vm, 0);
      arr->dpData2 = VM_VALUE_NULL;

      if (capacity) {
        uint16_t* pData = gc_allocateWithHeader2(vm, capacity * 2, TC_REF_FIXED_LENGTH_ARRAY);
        arr->dpData2 = ShortPtr_encode(vm, pData);
        #if MVM_SAFE_MODE
          uint16_t* p = arrayDataBegin(arr);
          while (capacity--)
            *p++ = VM_VALUE_DELETED;
        #endif // MVM_SAFE_MODE
      }

      goto LBL_TAIL_PUSH_REG1;
    }

  } // End of vm_TeOpcodeEx2 switch

  // All cases should jump to whatever tail they intend. Nothing should get here
  VM_ASSERT_UNREACHABLE(vm);

} // End of LBL_OP_EXTENDED_2

/* ------------------------------------------------------------------------- */
/*                             LBL_OP_EXTENDED_3                             */
/*   Expects:                                                                */
/*     reg1: vm_TeOpcodeEx3                                                  */
/* ------------------------------------------------------------------------- */

LBL_OP_EXTENDED_3:  {
  CODE_COVERAGE(150); // Hit
  reg3 = reg1;

  // Ex-3 instructions have a 16-bit parameter
  READ_PGM_2(reg1);

  if (reg3 >= VM_OP3_DIVIDER_1) {
    CODE_COVERAGE(151); // Hit
    reg2 = POP();
  } else {
    CODE_COVERAGE(152); // Hit
  }

  VM_ASSERT(vm, reg3 < VM_OP3_END);
  MVM_SWITCH_CONTIGUOUS (reg3, (VM_OP3_END - 1)) {

/* ------------------------------------------------------------------------- */
/*                             VM_OP3_JUMP_2                                 */
/*   Expects:                                                                */
/*     reg1: signed offset                                                   */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP3_JUMP_2): {
      CODE_COVERAGE(153); // Hit
      goto LBL_JUMP_COMMON;
    }

/* ------------------------------------------------------------------------- */
/*                             VM_OP3_LOAD_LITERAL                           */
/*   Expects:                                                                */
/*     reg1: literal value                                                   */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP3_LOAD_LITERAL): {
      CODE_COVERAGE(154); // Hit
      goto LBL_TAIL_PUSH_REG1;
    }

/* ------------------------------------------------------------------------- */
/*                             VM_OP3_LOAD_GLOBAL_3                          */
/*   Expects:                                                                */
/*     reg1: global variable index                                           */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP3_LOAD_GLOBAL_3): {
      CODE_COVERAGE_UNTESTED(155); // Not hit
      goto LBL_OP_LOAD_GLOBAL;
    }

/* ------------------------------------------------------------------------- */
/*                             VM_OP3_BRANCH_2                               */
/*   Expects:                                                                */
/*     reg1: signed offset                                                   */
/*     reg2: condition                                                       */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP3_BRANCH_2): {
      CODE_COVERAGE(156); // Hit
      goto LBL_BRANCH_COMMON;
    }

/* ------------------------------------------------------------------------- */
/*                             VM_OP3_STORE_GLOBAL_3                         */
/*   Expects:                                                                */
/*     reg1: global variable index                                           */
/*     reg2: value to store                                                  */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP3_STORE_GLOBAL_3): {
      CODE_COVERAGE_UNTESTED(157); // Not hit
      goto LBL_OP_STORE_GLOBAL;
    }

/* ------------------------------------------------------------------------- */
/*                             VM_OP3_OBJECT_GET_2                           */
/*   Expects:                                                                */
/*     reg1: property key value                                              */
/*     reg2: object value                                                    */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP3_OBJECT_GET_2): {
      CODE_COVERAGE_UNTESTED(158); // Not hit
      VM_NOT_IMPLEMENTED(vm);
      goto LBL_DO_NEXT_INSTRUCTION;
    }

/* ------------------------------------------------------------------------- */
/*                             VM_OP3_OBJECT_SET_2                          */
/*   Expects:                                                                */
/*     reg1: property key value                                              */
/*     reg2: value                                                           */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP3_OBJECT_SET_2): {
      CODE_COVERAGE_UNTESTED(159); // Not hit
      VM_NOT_IMPLEMENTED(vm);
      goto LBL_DO_NEXT_INSTRUCTION;
    }

  } // End of vm_TeOpcodeEx3 switch
  // All cases should jump to whatever tail they intend. Nothing should get here
  VM_ASSERT_UNREACHABLE(vm);
} // End of LBL_OP_EXTENDED_3

/* ------------------------------------------------------------------------- */
/*                             LBL_BRANCH_COMMON                             */
/*   Expects:                                                                */
/*     reg1: signed 16-bit amount to jump by if the condition is truthy      */
/*     reg2: condition to branch on                                          */
/* ------------------------------------------------------------------------- */
LBL_BRANCH_COMMON: {
  CODE_COVERAGE(160); // Hit
  if (mvm_toBool(vm, reg2)) {
    programCounter = MVM_LONG_PTR_ADD(programCounter, (int16_t)reg1);
  }
  goto LBL_DO_NEXT_INSTRUCTION;
}

/* ------------------------------------------------------------------------- */
/*                             LBL_JUMP_COMMON                               */
/*   Expects:                                                                */
/*     reg1: signed 16-bit amount to jump by                                 */
/* ------------------------------------------------------------------------- */
LBL_JUMP_COMMON: {
  CODE_COVERAGE(161); // Hit
  programCounter = MVM_LONG_PTR_ADD(programCounter, (int16_t)reg1);
  goto LBL_DO_NEXT_INSTRUCTION;
}

/* ------------------------------------------------------------------------- */
/*                          LBL_CALL_HOST_COMMON                             */
/*   Expects:                                                                */
/*     reg1: reg1: argument count                                            */
/*     reg2: index in import table                                           */
/*     reg3: flag indicating whether function pointer is pushed or not       */
/* ------------------------------------------------------------------------- */
LBL_CALL_HOST_COMMON: {
  CODE_COVERAGE(162); // Hit
  LongPtr pBytecode = vm->pBytecode;
  // Save caller state
  PUSH((uint16_t)(pFrameBase - VM_BOTTOM_OF_STACK(vm)));
  PUSH(argCount);
  PUSH((uint16_t)MVM_LONG_PTR_SUB(programCounter, pBytecode));

  // Set up new frame
  pFrameBase = pStackPointer;
  argCount = reg1 - 1; // Argument count does not include the "this" pointer, since host functions are never methods and we don't have an ABI for communicating `this` pointer values
  programCounter = pBytecode; // "null" (signifies that we're outside the VM)

  VM_ASSERT(vm, reg2 < vm_getResolvedImportCount(vm));
  mvm_TfHostFunction hostFunction = vm_getResolvedImports(vm)[reg2];
  Value result = VM_VALUE_UNDEFINED;
  Value* args = pStackPointer - 2 - reg1; // Note: this skips the `this` pointer
  VM_ASSERT(vm, argCount < 256);
  sanitizeArgs(vm, args, (uint8_t)argCount);

  uint16_t importTableOffset = VM_READ_BC_2_HEADER_FIELD(importTableOffset, pBytecode);

  uint16_t importTableEntry = importTableOffset + reg2 * sizeof (vm_TsImportTableEntry);
  mvm_HostFunctionID hostFunctionID = VM_READ_BC_2_AT(importTableEntry, pBytecode);

  FLUSH_REGISTER_CACHE();
  VM_ASSERT(vm, argCount < 256);
  err = hostFunction(vm, hostFunctionID, &result, args, (uint8_t)argCount);
  if (err != MVM_E_SUCCESS) goto LBL_EXIT;
  CACHE_REGISTERS();

  // Restore caller state
  programCounter = MVM_LONG_PTR_ADD(pBytecode, POP());
  argCount = POP();
  pFrameBase = VM_BOTTOM_OF_STACK(vm) + POP();

  // Pop arguments (including `this` pointer)
  pStackPointer -= reg1;

  // Pop function pointer
  if (reg3)
    (void)POP();

  PUSH(result);
  goto LBL_DO_NEXT_INSTRUCTION;
} // End of LBL_CALL_HOST_COMMON

/* ------------------------------------------------------------------------- */
/*                             LBL_CALL_COMMON                               */
/*   Expects:                                                                */
/*     reg1: number of arguments                                             */
/*     reg2: offset of target function in bytecode                           */
/* ------------------------------------------------------------------------- */
LBL_CALL_COMMON: {
  CODE_COVERAGE(163); // Hit
  LongPtr pBytecode = vm->pBytecode;
  uint16_t programCounterToReturnTo = (uint16_t)MVM_LONG_PTR_SUB(programCounter, pBytecode);
  programCounter = MVM_LONG_PTR_ADD(pBytecode, reg2);

  uint8_t maxStackDepth;
  READ_PGM_1(maxStackDepth);
  if (pStackPointer + ((intptr_t)maxStackDepth + VM_FRAME_SAVE_SIZE_WORDS) > VM_TOP_OF_STACK(vm)) {
    err = MVM_E_STACK_OVERFLOW;
    goto LBL_EXIT;
  }

  // Save caller state (VM_FRAME_SAVE_SIZE_WORDS)
  PUSH((uint16_t)(pFrameBase - VM_BOTTOM_OF_STACK(vm)));
  PUSH(argCount);
  PUSH(programCounterToReturnTo);

  // Set up new frame
  pFrameBase = pStackPointer;
  argCount = reg1;

  goto LBL_DO_NEXT_INSTRUCTION;
} // End of LBL_CALL_COMMON

/* ------------------------------------------------------------------------- */
/*                             LBL_NUM_OP_FLOAT64                            */
/*   Expects:                                                                */
/*     reg1: left operand (second pop), or zero for unary ops                */
/*     reg2: right operand (first pop), or single operand for unary ops      */
/*     reg3: vm_TeNumberOp                                                   */
/* ------------------------------------------------------------------------- */
#if MVM_SUPPORT_FLOAT
LBL_NUM_OP_FLOAT64: {
  CODE_COVERAGE_UNIMPLEMENTED(447); // Hit

  // It's a little less efficient to convert 2 operands even for unary
  // operators, but this path is slow anyway and it saves on code space if we
  // don't check.
  MVM_FLOAT64 reg1F = mvm_toFloat64(vm, reg1);
  MVM_FLOAT64 reg2F = mvm_toFloat64(vm, reg2);

  VM_ASSERT(vm, reg3 < VM_NUM_OP_END);
  MVM_SWITCH_CONTIGUOUS (reg3, (VM_NUM_OP_END - 1)) {
    MVM_CASE_CONTIGUOUS(VM_NUM_OP_LESS_THAN): {
      CODE_COVERAGE(449); // Hit
      reg1 = reg1F < reg2F;
      goto LBL_TAIL_PUSH_REG1_BOOL;
    }
    MVM_CASE_CONTIGUOUS(VM_NUM_OP_GREATER_THAN): {
      CODE_COVERAGE(450); // Hit
      reg1 = reg1F > reg2F;
      goto LBL_TAIL_PUSH_REG1_BOOL;
    }
    MVM_CASE_CONTIGUOUS(VM_NUM_OP_LESS_EQUAL): {
      CODE_COVERAGE(451); // Hit
      reg1 = reg1F <= reg2F;
      goto LBL_TAIL_PUSH_REG1_BOOL;
    }
    MVM_CASE_CONTIGUOUS(VM_NUM_OP_GREATER_EQUAL): {
      CODE_COVERAGE(452); // Hit
      reg1 = reg1F >= reg2F;
      goto LBL_TAIL_PUSH_REG1_BOOL;
    }
    MVM_CASE_CONTIGUOUS(VM_NUM_OP_ADD_NUM): {
      CODE_COVERAGE(453); // Hit
      reg1F = reg1F + reg2F;
      break;
    }
    MVM_CASE_CONTIGUOUS(VM_NUM_OP_SUBTRACT): {
      CODE_COVERAGE(454); // Hit
      reg1F = reg1F - reg2F;
      break;
    }
    MVM_CASE_CONTIGUOUS(VM_NUM_OP_MULTIPLY): {
      CODE_COVERAGE(455); // Hit
      reg1F = reg1F * reg2F;
      break;
    }
    MVM_CASE_CONTIGUOUS(VM_NUM_OP_DIVIDE): {
      CODE_COVERAGE(456); // Hit
      reg1F = reg1F / reg2F;
      break;
    }
    MVM_CASE_CONTIGUOUS(VM_NUM_OP_DIVIDE_AND_TRUNC): {
      CODE_COVERAGE(457); // Hit
      reg1F = mvm_float64ToInt32((reg1F / reg2F));
      break;
    }
    MVM_CASE_CONTIGUOUS(VM_NUM_OP_REMAINDER): {
      CODE_COVERAGE(458); // Hit
      reg1F = fmod(reg1F, reg2F);
      break;
    }
    MVM_CASE_CONTIGUOUS(VM_NUM_OP_POWER): {
      CODE_COVERAGE(459); // Hit
      if (!isfinite(reg2F) && ((reg1F == 1.0) || (reg1F == -1.0))) {
        reg1 = VM_VALUE_NAN;
        goto LBL_TAIL_PUSH_REG1;
      }
      reg1F = pow(reg1F, reg2F);
      break;
    }
    MVM_CASE_CONTIGUOUS(VM_NUM_OP_NEGATE): {
      CODE_COVERAGE(460); // Hit
      reg1F = -reg2F;
      break;
    }
    MVM_CASE_CONTIGUOUS(VM_NUM_OP_UNARY_PLUS): {
      CODE_COVERAGE(461); // Hit
      reg1F = reg2F;
      break;
    }
  } // End of switch vm_TeNumberOp for float64

  // Convert the result from a float
  reg1 = mvm_newNumber(vm, reg1F);
  goto LBL_TAIL_PUSH_REG1;
} // End of LBL_NUM_OP_FLOAT64
#endif // MVM_SUPPORT_FLOAT

LBL_TAIL_PUSH_REG1_BOOL:
  CODE_COVERAGE(489); // Hit
  reg1 = reg1 ? VM_VALUE_TRUE : VM_VALUE_FALSE;
  goto LBL_TAIL_PUSH_REG1;

LBL_TAIL_PUSH_REG1:
  CODE_COVERAGE(164); // Hit
  PUSH(reg1);
  goto LBL_DO_NEXT_INSTRUCTION;

LBL_EXIT:
  CODE_COVERAGE(165); // Hit
  FLUSH_REGISTER_CACHE();
  return err;
} // End of vm_run


void mvm_free(VM* vm) {
  CODE_COVERAGE_UNTESTED(166); // Not hit
  gc_freeGCMemory(vm);
  VM_EXEC_SAFE_MODE(memset(vm, 0, sizeof(*vm)));
  free(vm);
}

/*
 * Grow the heap and allocate a particular size onto it
 */
static void* gc_growAndAllocate(VM* vm, uint16_t sizeBytes) {
  // WIP Coverage
  VM_ASSERT(vm, (sizeBytes & 1) == 0);
  VM_ASSERT(vm, sizeBytes >= 4);
  // WIP
  VM_NOT_IMPLEMENTED(vm);
}

/*
 * Allocate a raw block of memory in the GC, where sizeBytes is already a
 * multiple of 2 and larger than or equal to 4
 */
static inline void* gc_allocateUnsafe2(VM* vm, uint16_t sizeBytes) {
  // WIP Coverage
  VM_ASSERT(vm, (sizeBytes & 1) == 0);
  VM_ASSERT(vm, sizeBytes >= 4);
  uint8_t* p = vm->pAllocationCursor2;
  uint8_t* end = p + sizeBytes;
  if (end > vm->pLastBucketEnd2)
    return gc_growAndAllocate(vm, sizeBytes);
  vm->pAllocationCursor2 = end;
  return p;
}

/**
 * @param sizeBytes Size in bytes of the allocation, *excluding* the header
 * @param typeCode The type code to insert into the header
 * @param out_result Output VM-Pointer. Target is after allocation header.
 * @param out_target Output native pointer to region after the allocation header.
 */
static void* gc_allocateWithHeader2(VM* vm, uint16_t sizeBytes, TeTypeCode typeCode) {
  uint16_t allocationSize = sizeBytes + 2; // 2 byte header
  // Round up to 2-byte boundary
  allocationSize = (allocationSize + 1) & 0xFFFE;
  // Minimum allocation size is 4 bytes
  if (allocationSize < 4) allocationSize = 4;
  void* pAlloc = gc_allocateUnsafe2(vm, allocationSize);

  // Write header
  uint16_t headerWord = makeHeaderWord(vm, typeCode, sizeBytes);
  *((uint16_t*)pAlloc) = headerWord;

  void* p = (uint8_t*)pAlloc + 2; // Skip header

  return p;
}

/**
 * Allocate raw GC data.
 */
static void* gc_allocateWithoutHeader2(VM* vm, uint16_t sizeBytes) {
  CODE_COVERAGE(6); // Hit
  // Round up to 2-byte boundary
  sizeBytes = (sizeBytes + 1) & 0xFFFE;
  // Minimum allocation size is 4 bytes
  if (sizeBytes < 4) sizeBytes = 4;

  return gc_allocateUnsafe2(vm, sizeBytes);
}

static inline uint8_t* getBucketDataBegin(TsBucket2* bucket) {
  return (void*)(bucket + 1);
}

/** The used heap size, excluding spare capacity in the last block, but
 * including any uncollected garbage. */
static uint16_t getHeapSize(VM* vm) {
  TsBucket2* lastBucket = vm->pLastBucket2;
  if (lastBucket)
    return lastBucket->offsetStart + (vm->pAllocationCursor2 - getBucketDataBegin(lastBucket));
  else
    return 0;
}

static void gc_createNextBucket(VM* vm, uint16_t bucketSize) {
  CODE_COVERAGE(7); // Hit
  size_t allocSize = sizeof (TsBucket2) + bucketSize;
  TsBucket2* bucket = malloc(allocSize);
  if (!bucket) {
    MVM_FATAL_ERROR(vm, MVM_E_MALLOC_FAIL);
  }
  #if MVM_SAFE_MODE
    memset(bucket, 0x7E, allocSize);
  #endif
  bucket->prev = vm->pLastBucket2;
  if (bucket->prev)
    CODE_COVERAGE(501); // Hit
  else
    CODE_COVERAGE(502); // Hit

  uint16_t offsetStart = getHeapSize(vm);

  // Note: we start the next bucket at the allocation cursor, not at what we
  // previously called the end of the previous bucket
  bucket->offsetStart = offsetStart;
  vm->pAllocationCursor2 = getBucketDataBegin(bucket);
  vm->pLastBucketEnd2 = vm->pAllocationCursor2 + bucketSize;
  vm->pLastBucket2 = bucket;
}

static void gc_freeGCMemory(VM* vm) {
  CODE_COVERAGE(10); // Hit
  while (vm->pLastBucket2) {
    CODE_COVERAGE_UNTESTED(169); // Not hit
    TsBucket2* prev = vm->pLastBucket2->prev;
    free(vm->pLastBucket2);
    vm->pLastBucket2 = prev;
  }
  vm->pLastBucketEnd2 = NULL;
  vm->pAllocationCursor2 = NULL;
}

/**
 * Given a pointer `ptr` into the heap, this returns the equivalent offset from
 * the start of the heap (0 meaning that `ptr` points to the beginning of the
 * heap).
 *
 * This is used in 2 places:
 *
 *   1. On a 32-bit machine, this is used to get a 16-bit equivalent encoding for ShortPtr
 *   2. On any machine, this is used in ShortPtr_to_BytecodeMappedPtr for creating snapshots
 */
static uint16_t pointerOffsetInHeap(VM* vm, TsBucket2* pLastBucket, void* allocationCursor, void* ptr) {
  // See ShortPtr_decode for more description

  TsBucket2* bucket = pLastBucket;
  void* bucketDataEnd = allocationCursor;
  void* bucketData = getBucketDataBegin(bucket);
  while (true) {
    // A failure here means we're trying to encode a pointer that doesn't map
    // to something in GC memory, which is a mistake.
    VM_ASSERT(vm, bucket != NULL);

    if ((ptr >= bucketData && (ptr < bucketDataEnd))) {
      uint16_t offsetInBucket = (uint16_t)((intptr_t)ptr - (intptr_t)bucketData);
      uint16_t result = offsetInBucket - bucket->offsetStart;

      // It isn't strictly necessary that all short pointers are 2-byte aligned,
      // but it probably indicates a mistake somewhere if a short pointer is not
      // 2-byte aligned, since `Value` cannot be a `ShortPtr` unless it's 2-byte
      // aligned.
      VM_ASSERT(vm, (result & 1) == 0);

      VM_ASSERT(vm, result < getHeapSize(vm));

      return result;
    }

    TsBucket2* prev = bucket->prev;
    VM_ASSERT(vm, prev);
    uint16_t prevBucketSize = bucket->offsetStart - prev->offsetStart;
    bucketData = getBucketDataBegin(prev);
    bucketDataEnd = (void*)((intptr_t)bucketData + prevBucketSize);
    bucket = bucket->prev;
  }
}

#if MVM_NATIVE_POINTER_IS_16_BIT
  static inline void* ShortPtr_decode(VM* vm, ShortPtr ptr) {
    return ptr;
  }
  static inline ShortPtr ShortPtr_encode(VM* vm, void* ptr) {
    return ptr;
  }
  static inline ShortPtr ShortPtr_encodeInToSpace(gc2_TsGCCollectionState* gc, void* ptr) {
    return ptr;
  }
#else // !MVM_NATIVE_POINTER_IS_16_BIT
  static void* ShortPtr_decode(VM* vm, ShortPtr shortPtr) {
    // It isn't strictly necessary that all short pointers are 2-byte aligned,
    // but it probably indicates a mistake somewhere if a short pointer is not
    // 2-byte aligned, since `Value` cannot be a `ShortPtr` unless it's 2-byte
    // aligned. Among other things, this catches VM_VALUE_NULL.
    VM_ASSERT(vm, (shortPtr & 1) == 0);

    /*
    Note: this is a linear search through the buckets, but a redeeming factor is
    that GC compacts the heap into a single bucket, so the number of buckets is
    small at any one time. Also, most-recently-allocated data are likely to be
    in the last bucket and accessed fastest. Also, the representation of the
    function is only needed on more powerful platforms. For 16-bit platforms,
    the implementation of ShortPtr_decode is a no-op.
    */

    TsBucket2* bucket = vm->pLastBucket2;
    while (true) {
      // All short pointers must map to some memory in a bucket, otherwise the pointer is corrupt
      VM_ASSERT(vm, bucket != NULL);

      if (shortPtr >= bucket->offsetStart) {
        uint16_t offsetInBucket = shortPtr - bucket->offsetStart;
        void* result = (uint8_t*)getBucketDataBegin(bucket) + offsetInBucket;
        VM_ASSERT(vm, result < vm->pAllocationCursor2);
        return result;
      }
      bucket = bucket->prev;
    }
  }

  /**
   * Like ShortPtr_encode except conducted against an arbitrary bucket list.
   *
   * Used internally by ShortPtr_encode and ShortPtr_encodeinToSpace.
   */
  static inline ShortPtr ShortPtr_encode_generic(VM* vm, TsBucket2* pLastBucket, void* allocationCursor, void* ptr) {
    return pointerOffsetInHeap(vm, pLastBucket, allocationCursor, ptr);
  }

  // Encodes a pointer as pointing to a value in the current heap
  static inline ShortPtr ShortPtr_encode(VM* vm, void* ptr) {
    return ShortPtr_encode_generic(vm, vm->pLastBucket2, vm->pAllocationCursor2, ptr);
  }

  // Encodes a pointer as pointing to a value in the _new_ heap (tospace) during
  // an ongoing garbage collection.
  static inline ShortPtr ShortPtr_encodeInToSpace(gc2_TsGCCollectionState* gc, void* ptr) {
    return ShortPtr_encode_generic(gc->vm, gc->lastBucket, gc->writePtr, ptr);
  }
#endif

static LongPtr BytecodeMappedPtr_decode_long(VM* vm, BytecodeMappedPtr ptr) {
  // BytecodeMappedPtr values are treated as offsets into a bytecode image
  uint16_t offsetInBytecode = ptr;

  LongPtr pBytecode = vm->pBytecode;
  uint16_t dataOffset = VM_READ_BC_2_HEADER_FIELD(initialDataOffset, pBytecode);

  if (offsetInBytecode < dataOffset) {
    // The pointer just references ROM
    return LongPtr_add(pBytecode, offsetInBytecode);
  }

  uint16_t initialHeapOffset = VM_READ_BC_2_HEADER_FIELD(initialDataOffset, pBytecode);

  // Note: BytecodeMappedPtr cannot point to GC memory. Values that need to
  // point to GC memory will use ShortPtr. But I'm still reserving the space
  // mapping to the heap because it might be useful in future.
  VM_ASSERT(vm, offsetInBytecode < initialHeapOffset);

  VM_ASSERT(vm, (ptr & 1) == 0);
  uint16_t offsetInDataMemory = offsetInBytecode - dataOffset;
  void* dataP = (void*)((intptr_t)vm->dataMemory + offsetInDataMemory);
  return LongPtr_new(dataP);
}

static LongPtr DynamicPtr_decode_long(VM* vm, DynamicPtr ptr) {
  if (Value_isShortPtr(ptr))
    return LongPtr_new(ShortPtr_decode(vm, ptr));

  if (ptr == VM_VALUE_NULL)
    return NULL;

  VM_ASSERT(vm, !Value_isVirtualInt14(ptr));

  VM_ASSERT(vm, Value_encodesBytecodeMappedPtr(ptr));
  return BytecodeMappedPtr_decode_long(vm, ptr >> 1);
}

static void* DynamicPtr_decode(VM* vm, RamPtr ptr) {
  if (Value_isShortPtr(ptr))
    return ShortPtr_decode(vm, ptr);

  if (ptr == VM_VALUE_NULL)
    return NULL;

  VM_ASSERT(vm, !Value_isVirtualInt14(ptr));
  VM_ASSERT(vm, Value_encodesBytecodeMappedPtr(ptr));

  uint16_t dataOffset = VM_READ_BC_2_HEADER_FIELD(initialDataOffset, vm->pBytecode);

  #if MVM_SAFE_MODE
    uint16_t initialHeapOffset = VM_READ_BC_2_HEADER_FIELD(initialDataOffset, vm->pBytecode);
    VM_ASSERT(vm, ptr >= dataOffset);
    VM_ASSERT(vm, ptr < initialHeapOffset);
  #endif

  return (uint8_t*)vm->dataMemory + (ptr - dataOffset);
}

/**
 * Returns true if the value is a pointer which points to ROM. Null is not a
 * value that points to ROM.
 */
static bool DynamicPtr_isRomPtr(VM* vm, DynamicPtr dp) {
  VM_ASSERT(vm, !Value_isVirtualInt14(dp));

  if (dp == VM_VALUE_NULL)
    return false;

  if (Value_isShortPtr(dp))
    return false;

  VM_ASSERT(vm, Value_encodesBytecodeMappedPtr(dp));

  uint16_t dataOffset = VM_READ_BC_2_HEADER_FIELD(initialDataOffset, vm->pBytecode);

  #if MVM_SAFE_MODE
    uint16_t initialHeapOffset = VM_READ_BC_2_HEADER_FIELD(initialDataOffset, vm->pBytecode);
    VM_ASSERT(vm, dp < initialHeapOffset);
  #endif

  return dp < dataOffset;
}

// I'm using inline wrappers around the port macros because I want to add a
// layer of type safety.
static inline LongPtr LongPtr_add(LongPtr lp, uint16_t offset) {
  return MVM_LONG_PTR_ADD(lp, offset);
}
static inline int16_t LongPtr_sub(LongPtr lp1, LongPtr lp2) {
  return MVM_LONG_PTR_SUB(lp1, lp2);
}
static inline uint16_t LongPtr_read2(LongPtr lp) {
  return MVM_READ_LONG_PTR_2(lp);
}
/*
 * When mutating
 */
static inline void* LongPtr_truncate(LongPtr lp) {
  return MVM_LONG_PTR_TRUNCATE(lp);
}

static void gc2_newBucket(gc2_TsGCCollectionState* gc, uint16_t newSpaceSize) {
  // WIP Add code coverage markers
  TsBucket2* pBucket = (TsBucket2*)malloc(sizeof (TsBucket2) + newSpaceSize);
  if (!pBucket) {
    MVM_FATAL_ERROR(vm, MVM_E_MALLOC_FAIL);
    return;
  }
  uint16_t* pDataInBucket = (uint16_t*)(pBucket + 1);
  if (((intptr_t)pDataInBucket) & 1) {
    MVM_FATAL_ERROR(vm, MVM_E_MALLOC_MUST_RETURN_POINTER_TO_EVEN_BOUNDARY);
    return;
  }
  pBucket->offsetStart = gc->lastBucketOffsetStart + (gc->lastBucketEnd - gc->writePtr);
  pBucket->prev = gc->lastBucket;
  // WIP Add code coverage markers for first case vs other cases
  if (!gc->firstBucket)
    gc->firstBucket = pBucket;
  gc->lastBucket = pBucket;
  gc->writePtr = pDataInBucket;
  gc->lastBucketOffsetStart = pBucket->offsetStart;
  gc->lastBucketEnd = (uint16_t*)((intptr_t)pDataInBucket + newSpaceSize);
}

static void gc2_processValue(gc2_TsGCCollectionState* gc, Value* pValue) {
  uint16_t* writePtr;

  VM* vm = gc->vm;

  Value value = *pValue;
  // WIP Add code coverage markers

  // Note: only short pointer values are allowed to point to GC memory
  if (!Value_isShortPtr(value)) return;

  uint16_t* pSrc = (uint16_t*)ShortPtr_decode(vm, value);
  if (!pSrc) return;

  uint16_t headerWord = pSrc[-1];

  // If there's a tombstone, then we've already collected this allocation
  if (headerWord == TOMBSTONE_HEADER) {
    value = pSrc[0];
  } else { // Otherwise, we need to move the allocation
  LBL_MOVE_ALLOCATION:
    writePtr = gc->writePtr;
    uint16_t size = vm_getAllocationSizeExcludingHeaderFromHeaderWord(headerWord);
    uint16_t words = (size + 3) / 2; // Rounded up, including header

    // Check we have space
    if (writePtr + words > gc->lastBucketEnd) {
      uint16_t newBucketSize = words * 2;
      if (newBucketSize < MVM_ALLOCATION_BUCKET_SIZE)
        newBucketSize = MVM_ALLOCATION_BUCKET_SIZE;

      gc2_newBucket(gc, newBucketSize);

      goto LBL_MOVE_ALLOCATION;
    }

    // Write the header
    *writePtr++ = headerWord;
    words--;

    // The new pointer points here, after the header
    value = ShortPtr_encodeInToSpace(gc, writePtr);

    uint16_t* pOld = pSrc;
    uint16_t* pNew = writePtr;

    // Copy the allocation body
    while (words--)
      *writePtr++ = *pSrc++;

    // Dynamic arrays and property lists are compacted here
    TeTypeCode tc = vm_getTypeCodeFromHeaderWord(headerWord);
    if (tc == TC_REF_ARRAY) {
      TsArray* arr = (TsArray*)pNew;
      DynamicPtr dpData2 = arr->dpData2;
      if (dpData2 != VM_VALUE_NULL) {
        VM_ASSERT(vm, Value_isShortPtr(dpData2));

        // Note: this decodes the pointer against fromspace
        TsFixedLengthArray* pData = ShortPtr_decode(vm, dpData2);

        uint16_t len = VirtualInt14_decode(vm, arr->viLength);
        #if MVM_SAFE_MODE
          uint16_t headerWord = getAllocationHeader(pData);
          uint16_t dataTC = vm_getTypeCodeFromHeaderWord(headerWord);
          // Note: because dpData2 is a unique pointer, we can be sure that it
          // hasn't already been moved in response to some other reference to
          // it (it's not a tombstone yet).
          VM_ASSERT(vm, dataTC == TC_REF_FIXED_LENGTH_ARRAY);
          uint16_t dataSize = vm_getAllocationSizeExcludingHeaderFromHeaderWord(headerWord);
          uint16_t capacity = dataSize / 2;
          VM_ASSERT(vm, len <= capacity);
        #endif
        // We just truncate the fixed-length-array to match the programmed
        // length of the dynamic array, which is necessarily equal or less than
        // its previous value. The GC will copy the data later and update the
        // data pointer as it would normally do when following pointers.
        setHeaderWord(vm, pData, TC_REF_FIXED_LENGTH_ARRAY, len * 2);
      }
    } else if (tc == TC_REF_PROPERTY_LIST) {
      TsPropertyList2* props = (TsPropertyList2*)pNew;

      Value dpNext = props->dpNext;

      // If the object has children (detached extensions to the main
      // allocation), we take this opportunity to compact them into the parent
      // allocation to save space and improve access performance.
      if (dpNext != VM_VALUE_NULL) {
        // Note: The "root" property list counts towards the total but its
        // fields do not need to be copied because it's already copied, above
        uint16_t headerWord = getAllocationHeader(props);
        uint16_t allocationSize = vm_getAllocationSizeExcludingHeaderFromHeaderWord(headerWord);
        uint16_t totalPropCount = (allocationSize - sizeof(TsPropertyList2)) / 4;

        do {
          // Note: while `next` is not strictly a ShortPtr in general, when used
          // within GC allocations it will never point to an allocation in ROM
          // or data memory, since it's only used to extend objects with new
          // properties.
          VM_ASSERT(vm, Value_isShortPtr(dpNext));
          TsPropertyList2* child = (TsPropertyList2*)ShortPtr_decode(vm, dpNext);

          uint16_t headerWord = getAllocationHeader(child);
          uint16_t allocationSize = vm_getAllocationSizeExcludingHeaderFromHeaderWord(headerWord);
          uint16_t childPropCount = (allocationSize - sizeof(TsPropertyList2)) / 4;

          totalPropCount += childPropCount;
          uint16_t* pField = &child->keyValues[0];

          // Copy the child fields directly into the parent
          while (childPropCount--) {
            *writePtr++ = *pField++; // key
            *writePtr++ = *pField++; // value
          }
          dpNext = child->dpNext;
        } while (dpNext != VM_VALUE_NULL);

        // We've collapsed all the lists into one, so let's adjust the header
        uint16_t newSize = sizeof (TsPropertyList2) + totalPropCount * 2;
        if (newSize > MAX_ALLOCATION_SIZE) {
          MVM_FATAL_ERROR(vm, MVM_E_ALLOCATION_TOO_LARGE);
          return;
        }

        setHeaderWord(vm, props, TC_REF_PROPERTY_LIST, newSize);
        props->dpNext = VM_VALUE_NULL;
      }
    }

    gc->writePtr = writePtr;

    pOld[-1] = TOMBSTONE_HEADER;
    pOld[0] = value; // Forwarding pointer
  }
  *pValue = value;
}

void mvm_runGC2(VM* vm, bool squeeze) {
  // WIP Add code coverage markers

  // TODO: Honestly, we should make it possible to collect at any time (even
  // with an active stack), and then add some heuristics to trigger collection
  // if we use a lot of space.

  /*
  This is a semispace collection model based on Cheney's algorithm
  https://en.wikipedia.org/wiki/Cheney%27s_algorithm. It collects by moving
  reachable allocations from the fromspace to the tospace and then releasing the
  fromspace. It starts by moving allocations reachable by the roots, and then
  iterates through moved allocations, checking the pointers therein, moving the
  allocations they reference.

  When an object is moved, the space it occupied is changed to a tombstone
  (TC_REF_TOMBSTONE) which contains a forwarding pointer. When a pointer in
  tospace is seen to point to an allocation in fromspace, if the fromspace
  allocation is a tombstone then the pointer can be updated to the forwarding
  pointer.

  This algorithm relies on allocations in tospace each have a header. Some
  allocations, such as property cells, don't have a header, but will only be
  found in fromspace. When copying objects into tospace, the detached property
  cells are merged into the object's head allocation.

  Note: all pointer _values_ are only processed once each (since their
  corresponding container is only processed once). This means that fromspace and
  tospace can be treated as distinct spaces. An unprocessed pointer is
  interpretted in terms of _fromspace_. Forwarding pointers and pointers in
  processed allocations always reference _tospace_.
  */
  uint16_t n;
  uint16_t* p;

  // A collection of variables shared by GC routines
  gc2_TsGCCollectionState gc;
  memset(&gc, 0, sizeof gc);
  gc.vm = vm;

  uint16_t* beginningOfToSpace = NULL;

  // We don't know how big the heap needs to be, so we just allocate the same
  // amount of space as used last time and then expand as-needed
  uint16_t estimatedSize = vm->heapSizeUsedAfterLastGC;

  if (estimatedSize) {
    gc2_newBucket(&gc, estimatedSize);
    beginningOfToSpace = gc.writePtr;
  }

  // Roots in global variables
  n = VM_READ_BC_2_HEADER_FIELD(globalVariableCount, vm->pBytecode);
  p = (uint16_t*)vm->dataMemory;
  while (n--) {
    gc2_processValue(&gc, p++);
  }

  // Builtin roots
  n = sizeof (TsBuiltinRoots) / 2;
  p = (uint16_t*)&vm->builtins;
  while (n--) {
    gc2_processValue(vm, p++);
  }

  // Roots in data memory
  {
    uint16_t gcRootsOffset = VM_READ_BC_2_HEADER_FIELD(gcRootsOffset, vm->pBytecode);
    uint16_t n = VM_READ_BC_2_HEADER_FIELD(gcRootsCount, vm->pBytecode);

    LongPtr pTableEntry = LongPtr_add(vm->pBytecode, gcRootsOffset);
    uint16_t* dataMemory = (uint16_t*)vm->dataMemory;
    while (n--) {
      // The table entry in program memory gives us an offset in data memory
      uint16_t dataOffsetWords = LongPtr_read2(pTableEntry);
      pTableEntry = LongPtr_add(pTableEntry, 2);
      uint16_t* dataValue = &dataMemory[dataOffsetWords];
      gc2_processValue(&gc, dataValue);
    }
  }

  // Now we process moved allocations to make sure objects they point to are
  // also moved, and to update pointers to reference the new space
  p = beginningOfToSpace;
  // WIP: This loop incorrectly assumes that to-space is a single block
  while (p != gc.writePtr) {
    uint16_t header = *p++;
    uint16_t size = vm_getAllocationSizeExcludingHeaderFromHeaderWord(header);
    uint16_t words = (size + 1) / 2;
    TeTypeCode tc = vm_getTypeCodeFromHeaderWord(header);

    if (tc < TC_REF_DIVIDER_CONTAINER_TYPES) { // Non-container types
      p += words;
      continue;
    } // Else, container types

    while (words--) {
      if (Value_isShortPtr(*p))
        gc2_processValue(&gc, p);
      p++;
    }
  }

  // Release old heap
  TsBucket2* oldBucket = vm->pLastBucket2;
  while (oldBucket) {
    TsBucket2* prev = oldBucket->prev;
    free(oldBucket);
    oldBucket = prev;
  }

  uint16_t finalUsedSize = gc.lastBucketOffsetStart + (gc.lastBucketEnd - gc.writePtr);

  vm->pLastBucket2 = gc.lastBucket;
  vm->pLastBucketEnd2 = gc.lastBucketEnd;
  vm->pAllocationCursor2 = (uint8_t*)gc.writePtr;
  vm->heapSizeUsedAfterLastGC = finalUsedSize;

  if (squeeze && (finalUsedSize != estimatedSize)) {
    /*
    Note: The most efficient way to calculate the exact size needed for the heap
    is actually to run a collection twice. The collection algorithm itself is
    almost as efficient as any size-counting algorithm in terms of running time
    since it needs to iterate the whole reachability graph and all the pointers
    contained therein. But having a distinct size-counting algorithm is less
    efficient in terms of the amount of code-space (ROM) used, since it must
    duplicate much of the logic to parse the heap. It also needs to keep
    separate flags to know what it's already counted or not, and these flags
    would presumably take up space in the headers that isn't otherwise needed.

    Furthermore, it's suspected that a common case is where the VM is repeatedly
    used to perform the same calculation, such as a "tick" or "check" function,
    that has no side effect most of the time, and leaving the heap the same size
    efficient in these cases because you would need to do 2 passes over the heap
    after each collection. Using an explicit counting algorithm would be less
    (count + collect) even when the estimated size would be correct 90% of the
    time.

    In conclusion, I decided that the best way to "squeeze" the heap is to just
    run the collection twice. The first time will give us the exact size, and
    then if that's different to what we estimated then we perform the collection
    again, now with the exact size, so that there is no unused space mallocd
    from the host, and no unnecessary mallocs from the host.
    */
    return mvm_runGC2(vm, false);
  }
}

// A function call invoked by the host
TeError mvm_call(VM* vm, Value func, Value* out_result, Value* args, uint8_t argCount) {
  CODE_COVERAGE(15); // Hit

  TeError err;
  if (out_result) {
    CODE_COVERAGE(220); // Hit
    *out_result = VM_VALUE_UNDEFINED;
  } else {
    CODE_COVERAGE_UNTESTED(221); // Not hit
  }

  vm_setupCallFromExternal(vm, func, args, argCount);

  // Run the machine until it hits the corresponding return instruction. The
  // return instruction pops the arguments off the stack and pushes the returned
  // value.
  err = vm_run(vm);

  if (err != MVM_E_SUCCESS) {
    CODE_COVERAGE_ERROR_PATH(222); // Not hit
    return err;
  } else {
    CODE_COVERAGE(223); // Hit
  }

  if (out_result) {
    CODE_COVERAGE(224); // Hit
    *out_result = vm_pop(vm);
  } else {
    CODE_COVERAGE_UNTESTED(225); // Not hit
  }

  // Release the stack if we hit the bottom
  if (vm->stack->reg.pStackPointer == VM_BOTTOM_OF_STACK(vm)) {
    CODE_COVERAGE(226); // Hit
    free(vm->stack);
    vm->stack = NULL;
  } else {
    CODE_COVERAGE_UNTESTED(227); // Not hit
  }

  return MVM_E_SUCCESS;
}

static TeError vm_setupCallFromExternal(VM* vm, Value func, Value* args, uint8_t argCount) {
  int i;

  if (deepTypeOf(vm, func) != TC_REF_FUNCTION) {
    CODE_COVERAGE_ERROR_PATH(228); // Not hit
    return MVM_E_TARGET_IS_NOT_A_VM_FUNCTION;
  } else {
    CODE_COVERAGE(229); // Hit
  }

  // There is no stack if this is not a reentrant invocation
  if (!vm->stack) {
    CODE_COVERAGE(230); // Hit
    // This is freed again at the end of mvm_call
    vm_TsStack* stack = malloc(sizeof (vm_TsStack) + MVM_STACK_SIZE);
    if (!stack) {
      CODE_COVERAGE_ERROR_PATH(231); // Not hit
      return MVM_E_MALLOC_FAIL;
    }
    memset(stack, 0, sizeof *stack);
    vm_TsRegisters* reg = &stack->reg;
    // The stack grows upward. The bottom is the lowest address.
    uint16_t* bottomOfStack = (uint16_t*)(stack + 1);
    reg->pFrameBase = bottomOfStack;
    reg->pStackPointer = bottomOfStack;
    vm->stack = stack;
  } else {
    CODE_COVERAGE_UNTESTED(232); // Not hit
  }

  vm_TsStack* stack = vm->stack;
  uint16_t* bottomOfStack = (uint16_t*)(stack + 1);
  vm_TsRegisters* reg = &stack->reg;

  VM_ASSERT(vm, reg->programCounter2 == 0); // Assert that we're outside the VM at the moment

  VM_ASSERT(vm, Value_encodesBytecodeMappedPtr(func));
  LongPtr pFunc = DynamicPtr_decode_long(vm, func);
  uint8_t maxStackDepth = LongPtr_read2(pFunc);
  // TODO(low): Since we know the max stack depth for the function, we could actually grow the stack dynamically rather than allocate it fixed size.
  if (vm->stack->reg.pStackPointer + ((intptr_t)maxStackDepth + VM_FRAME_SAVE_SIZE_WORDS) > VM_TOP_OF_STACK(vm)) {
    CODE_COVERAGE_ERROR_PATH(233); // Not hit
    return MVM_E_STACK_OVERFLOW;
  }

  vm_push(vm, func); // We need to push the function because the corresponding RETURN instruction will pop it. The actual value is not used.
  vm_push(vm, VM_VALUE_UNDEFINED); // Push `this` pointer of undefined, to match the internal ABI
  Value* arg = &args[0];
  for (i = 0; i < argCount; i++)
    vm_push(vm, *arg++);

  // Save caller state (VM_FRAME_SAVE_SIZE_WORDS)
  vm_push(vm, (uint16_t)(reg->pFrameBase - bottomOfStack));
  vm_push(vm, reg->argCount);
  vm_push(vm, LongPtr_sub(reg->programCounter2, vm->pBytecode));

  // Set up new frame
  reg->pFrameBase = reg->pStackPointer;
  reg->argCount = argCount + 1; // +1 for the `this` pointer
  reg->programCounter2 = LongPtr_add(pFunc, sizeof (vm_TsFunctionHeader));

  return MVM_E_SUCCESS;
}

TeError vm_resolveExport(VM* vm, mvm_VMExportID id, Value* result) {
  CODE_COVERAGE(17); // Hit
  LongPtr pBytecode = vm->pBytecode;
  uint16_t exportTableOffset = VM_READ_BC_2_HEADER_FIELD(exportTableOffset, pBytecode);
  uint16_t exportTableSize = VM_READ_BC_2_HEADER_FIELD(exportTableSize, pBytecode);

  LongPtr exportTable = MVM_LONG_PTR_ADD(vm->pBytecode, exportTableOffset);
  LongPtr exportTableEnd = MVM_LONG_PTR_ADD(exportTable, exportTableSize);

  // See vm_TsExportTableEntry
  LongPtr exportTableEntry = exportTable;
  while (exportTableEntry < exportTableEnd) {
    CODE_COVERAGE(234); // Hit
    mvm_VMExportID exportID = MVM_READ_LONG_PTR_2(exportTableEntry);
    if (exportID == id) {
      CODE_COVERAGE(235); // Hit
      LongPtr pExportvalue = MVM_LONG_PTR_ADD(exportTableEntry, 2);
      mvm_VMExportID exportValue = MVM_READ_LONG_PTR_2(pExportvalue);
      *result = exportValue;
      return MVM_E_SUCCESS;
    } else {
      CODE_COVERAGE_UNTESTED(236); // Not hit
    }
    exportTableEntry = MVM_LONG_PTR_ADD(exportTableEntry, sizeof (vm_TsExportTableEntry));
  }

  *result = VM_VALUE_UNDEFINED;
  return MVM_E_UNRESOLVED_EXPORT;
}

TeError mvm_resolveExports(VM* vm, const mvm_VMExportID* idTable, Value* resultTable, uint8_t count) {
  CODE_COVERAGE(18); // Hit
  TeError err = MVM_E_SUCCESS;
  while (count--) {
    CODE_COVERAGE(237); // Hit
    TeError tempErr = vm_resolveExport(vm, *idTable++, resultTable++);
    if (tempErr != MVM_E_SUCCESS) {
      CODE_COVERAGE_ERROR_PATH(238); // Not hit
      err = tempErr;
    } else {
      CODE_COVERAGE(239); // Hit
    }
  }
  return err;
}

void mvm_initializeHandle(VM* vm, mvm_Handle* handle) {
  CODE_COVERAGE(19); // Hit
  VM_ASSERT(vm, !vm_isHandleInitialized(vm, handle));
  handle->_next = vm->gc_handles;
  vm->gc_handles = handle;
  handle->_value = VM_VALUE_UNDEFINED;
}

void vm_cloneHandle(VM* vm, mvm_Handle* target, const mvm_Handle* source) {
  CODE_COVERAGE_UNTESTED(20); // Not hit
  VM_ASSERT(vm, !vm_isHandleInitialized(vm, source));
  mvm_initializeHandle(vm, target);
  target->_value = source->_value;
}

TeError mvm_releaseHandle(VM* vm, mvm_Handle* handle) {
  // This function doesn't contain coverage markers because node hits this path
  // non-deterministically.
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
  CODE_COVERAGE(22); // Hit
  mvm_Handle* h = vm->gc_handles;
  while (h) {
    CODE_COVERAGE(243); // Hit
    if (h == handle) {
      CODE_COVERAGE_UNTESTED(244); // Not hit
      return true;
    } else {
      CODE_COVERAGE(245); // Hit
    }
    h = h->_next;
  }
  return false;
}

static Value vm_convertToString(VM* vm, Value value) {
  CODE_COVERAGE(23); // Hit
  TeTypeCode type = deepTypeOf(vm, value);

  switch (type) {
    case TC_VAL_INT14: {
      CODE_COVERAGE_UNTESTED(246); // Not hit
      return VM_NOT_IMPLEMENTED(vm);
    }
    case TC_REF_INT32: {
      CODE_COVERAGE_UNTESTED(247); // Not hit
      return VM_NOT_IMPLEMENTED(vm);
    }
    case TC_REF_FLOAT64: {
      CODE_COVERAGE_UNTESTED(248); // Not hit
      return VM_NOT_IMPLEMENTED(vm);
    }
    case TC_REF_STRING: {
      CODE_COVERAGE(249); // Hit
      return value;
    }
    case TC_REF_UNIQUE_STRING: {
      CODE_COVERAGE(250); // Hit
      return value;
    }
    case TC_REF_PROPERTY_LIST: {
      CODE_COVERAGE_UNTESTED(251); // Not hit
      return VM_NOT_IMPLEMENTED(vm);
    }
    case TC_REF_ARRAY: {
      CODE_COVERAGE_UNTESTED(252); // Not hit
      return VM_NOT_IMPLEMENTED(vm);
    }
    case TC_REF_FUNCTION: {
      CODE_COVERAGE_UNTESTED(254); // Not hit
      return VM_NOT_IMPLEMENTED(vm);
    }
    case TC_REF_HOST_FUNC: {
      CODE_COVERAGE_UNTESTED(255); // Not hit
      return VM_NOT_IMPLEMENTED(vm);
    }
    case TC_REF_BIG_INT: {
      CODE_COVERAGE_UNTESTED(256); // Not hit
      return VM_NOT_IMPLEMENTED(vm);
    }
    case TC_REF_SYMBOL: {
      CODE_COVERAGE_UNTESTED(257); // Not hit
      return VM_NOT_IMPLEMENTED(vm);
    }
    case TC_VAL_UNDEFINED: {
      CODE_COVERAGE_UNTESTED(258); // Not hit
      return VM_NOT_IMPLEMENTED(vm);
    }
    case TC_VAL_NULL: {
      CODE_COVERAGE_UNTESTED(259); // Not hit
      return VM_NOT_IMPLEMENTED(vm);
    }
    case TC_VAL_TRUE: {
      CODE_COVERAGE_UNTESTED(260); // Not hit
      return VM_NOT_IMPLEMENTED(vm);
    }
    case TC_VAL_FALSE: {
      CODE_COVERAGE_UNTESTED(261); // Not hit
      return VM_NOT_IMPLEMENTED(vm);
    }
    case TC_VAL_NAN: {
      CODE_COVERAGE_UNTESTED(262); // Not hit
      return VM_NOT_IMPLEMENTED(vm);
    }
    case TC_VAL_NEG_ZERO: {
      CODE_COVERAGE_UNTESTED(263); // Not hit
      return VM_NOT_IMPLEMENTED(vm);
    }
    case VM_VALUE_STR_LENGTH: {
      CODE_COVERAGE_UNTESTED(266); // Not hit
      return value;
    }
    case VM_VALUE_STR_PROTO: {
      CODE_COVERAGE_UNTESTED(267); // Not hit
      return value;
    }
    case TC_VAL_DELETED: {
      CODE_COVERAGE_UNTESTED(264); // Not hit
      return VM_NOT_IMPLEMENTED(vm);
    }
    case TC_REF_STRUCT: {
      CODE_COVERAGE_UNTESTED(265); // Not hit
      return VM_NOT_IMPLEMENTED(vm);
    }
    default: return VM_UNEXPECTED_INTERNAL_ERROR(vm);
  }
}

static Value vm_concat(VM* vm, Value left, Value right) {
  CODE_COVERAGE(24); // Hit
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

/* Returns the deep type of the value, looking through pointers and boxing */
static TeTypeCode deepTypeOf(VM* vm, Value value) {
  CODE_COVERAGE(27); // Hit

  if (Value_isShortPtr(value)) {
    CODE_COVERAGE_UNTESTED(0);
    void* p = ShortPtr_decode(vm, value);
    uint16_t headerWord = readHeaderWord(p);
    TeTypeCode typeCode = vm_getTypeCodeFromHeaderWord(headerWord);
    return typeCode;
  }

  if (Value_isVirtualInt14(value)) {
    CODE_COVERAGE(295); // Hit
    return TC_VAL_INT14;
  }

  VM_ASSERT(vm, Value_isBytecodeMappedPtr(value));

  // Check for "well known" values such as TC_VAL_UNDEFINED
  if (value < VM_VALUE_WELLKNOWN_END) {
    CODE_COVERAGE(296); // Hit
    return (TeTypeCode)(value >> 2);
  } else {
    CODE_COVERAGE(297); // Hit
  }

  LongPtr p = DynamicPtr_decode_long(vm, value);
  uint16_t headerWord = readHeaderWord_long(vm, p);
  TeTypeCode typeCode = vm_getTypeCodeFromHeaderWord(headerWord);

  return typeCode;
}

#if MVM_SUPPORT_FLOAT
int32_t mvm_float64ToInt32(MVM_FLOAT64 value) {
  CODE_COVERAGE(486); // Hit
  if (isfinite(value)) {
    CODE_COVERAGE(487); // Hit
    return (int32_t)value;
  }
  else {
    CODE_COVERAGE(488); // Hit
    return 0;
  }
}

Value mvm_newNumber(VM* vm, MVM_FLOAT64 value) {
  CODE_COVERAGE(28); // Hit
  if (isnan(value)) {
    CODE_COVERAGE(298); // Hit
    return VM_VALUE_NAN;
  }
  if (value == -0.0) {
    CODE_COVERAGE(299); // Hit
    return VM_VALUE_NEG_ZERO;
  }

  // Doubles are very expensive to compute, so at every opportunity, we'll check
  // if we can coerce back to an integer
  int32_t valueAsInt = mvm_float64ToInt32(value);
  if (value == (MVM_FLOAT64)valueAsInt) {
    CODE_COVERAGE(300); // Hit
    return mvm_newInt32(vm, valueAsInt);
  } else {
    CODE_COVERAGE(301); // Hit
  }

  MVM_FLOAT64* pResult;
  Value resultValue = gc_allocateWithHeader(vm, sizeof (MVM_FLOAT64), TC_REF_FLOAT64, (void**)&pResult);
  *pResult = value;

  return resultValue;
}
#endif // MVM_SUPPORT_FLOAT

Value mvm_newInt32(VM* vm, int32_t value) {
  CODE_COVERAGE(29); // Hit
  if ((value >= VM_MIN_INT14) && (value <= VM_MAX_INT14)) {
    CODE_COVERAGE(302); // Hit
    return VirtualInt14_encode(vm, value);
  } else {
    CODE_COVERAGE(303); // Hit
  }

  // Int32

  int32_t* pResult = gc_allocateWithHeader2(vm, sizeof (int32_t), TC_REF_INT32);
  *pResult = value;

  return ShortPtr_encode(vm, pResult);
}

bool mvm_toBool(VM* vm, Value value) {
  CODE_COVERAGE(30); // Hit

  TeTypeCode type = deepTypeOf(vm, value);
  switch (type) {
    case TC_VAL_INT14: {
      CODE_COVERAGE(304); // Hit
      return value != 0;
    }
    case TC_REF_INT32: {
      CODE_COVERAGE_UNTESTED(305); // Not hit
      // Int32 can't be zero, otherwise it would be encoded as an int14
      VM_ASSERT(vm, vm_readInt32(vm, type, value) != 0);
      return false;
    }
    case TC_REF_FLOAT64: {
      CODE_COVERAGE_UNTESTED(306); // Not hit
      #if MVM_SUPPORT_FLOAT
        // Double can't be zero, otherwise it would be encoded as an int14
        VM_ASSERT(vm, mvm_toFloat64(vm, value) != 0);
      #endif
      return false;
    }
    case TC_REF_UNIQUE_STRING:
    case TC_REF_STRING: {
      CODE_COVERAGE(307); // Hit
      return vm_stringSizeUtf8(vm, value) != 0;
    }
    case TC_REF_PROPERTY_LIST: {
      CODE_COVERAGE(308); // Hit
      return true;
    }
    case TC_REF_ARRAY: {
      CODE_COVERAGE(309); // Hit
      return true;
    }
    case TC_REF_FUNCTION: {
      CODE_COVERAGE_UNTESTED(311); // Not hit
      return true;
    }
    case TC_REF_HOST_FUNC: {
      CODE_COVERAGE_UNTESTED(312); // Not hit
      return true;
    }
    case TC_REF_BIG_INT: {
      CODE_COVERAGE_UNTESTED(313); // Not hit
      return VM_RESERVED(vm);
    }
    case TC_REF_SYMBOL: {
      CODE_COVERAGE_UNTESTED(314); // Not hit
      return true;
    }
    case TC_VAL_UNDEFINED: {
      CODE_COVERAGE(315); // Hit
      return false;
    }
    case TC_VAL_NULL: {
      CODE_COVERAGE(316); // Hit
      return false;
    }
    case TC_VAL_TRUE: {
      CODE_COVERAGE(317); // Hit
      return true;
    }
    case TC_VAL_FALSE: {
      CODE_COVERAGE(318); // Hit
      return false;
    }
    case TC_VAL_NAN: {
      CODE_COVERAGE_UNTESTED(319); // Not hit
      return false;
    }
    case TC_VAL_NEG_ZERO: {
      CODE_COVERAGE_UNTESTED(320); // Not hit
      return false;
    }
    case TC_VAL_DELETED: {
      CODE_COVERAGE_UNTESTED(321); // Not hit
      return false;
    }
    case VM_VALUE_STR_LENGTH: {
      CODE_COVERAGE_UNTESTED(268); // Not hit
      return true;
    }
    case VM_VALUE_STR_PROTO: {
      CODE_COVERAGE_UNTESTED(269); // Not hit
      return true;
    }
    case TC_REF_STRUCT: {
      CODE_COVERAGE_UNTESTED(322); // Not hit
      return true;
    }
    default: return VM_UNEXPECTED_INTERNAL_ERROR(vm);
  }
}

static bool vm_isString(VM* vm, Value value) {
  CODE_COVERAGE(31); // Hit
  TeTypeCode deepType = deepTypeOf(vm, value);
  if (
    (deepType == TC_REF_STRING) ||
    (deepType == TC_REF_UNIQUE_STRING) ||
    (deepType == TC_VAL_STR_PROTO) ||
    (deepType == TC_VAL_STR_LENGTH)
  ) {
    CODE_COVERAGE(323); // Hit
    return true;
  } else {
    CODE_COVERAGE(324); // Hit
    return false;
  }
}

/** Reads a numeric value that is a subset of a 32-bit integer */
static int32_t vm_readInt32(VM* vm, TeTypeCode type, Value value) {
  CODE_COVERAGE(33); // Hit
  if (type == TC_VAL_INT14) {
    CODE_COVERAGE(330); // Hit
    return VirtualInt14_decode(vm, value);
  } else if (type == TC_REF_INT32) {
    CODE_COVERAGE(331); // Hit
    int32_t result;
    vm_readMem(vm, &result, value, sizeof result);
    return result;
  } else {
    return VM_UNEXPECTED_INTERNAL_ERROR(vm);
  }
}

static void vm_push(VM* vm, uint16_t value) {
  CODE_COVERAGE(34); // Hit
  *(vm->stack->reg.pStackPointer++) = value;
}

static uint16_t vm_pop(VM* vm) {
  CODE_COVERAGE(35); // Hit
  return *(--vm->stack->reg.pStackPointer);
}

static inline uint16_t readHeaderWord_long(LongPtr pAllocation) {
  return LongPtr_read2(LongPtr_add(pAllocation, -2));
}

static inline uint16_t readHeaderWord(void* pAllocation) {
  return ((uint16_t*)pAllocation)[-1];
}

static inline mvm_TfHostFunction* vm_getResolvedImports(VM* vm) {
  CODE_COVERAGE(40); // Hit
  return (mvm_TfHostFunction*)(vm + 1); // Starts right after the header
}

static inline uint16_t vm_getResolvedImportCount(VM* vm) {
  CODE_COVERAGE(41); // Hit
  uint16_t importTableSize = VM_READ_BC_2_HEADER_FIELD(importTableSize, vm->pBytecode);
  uint16_t importCount = importTableSize / sizeof(vm_TsImportTableEntry);
  return importCount;
}

mvm_TeType mvm_typeOf(VM* vm, Value value) {
  CODE_COVERAGE(42); // Hit
  TeTypeCode type = deepTypeOf(vm, value);
  // TODO: This should be implemented as a lookup table, not a switch
  switch (type) {
    case TC_VAL_UNDEFINED:
    case TC_VAL_DELETED: {
      CODE_COVERAGE(339); // Hit
      return VM_T_UNDEFINED;
    }

    case TC_VAL_NULL: {
      CODE_COVERAGE_UNTESTED(340); // Not hit
      return VM_T_NULL;
    }

    case TC_VAL_TRUE:
    case TC_VAL_FALSE: {
      CODE_COVERAGE(341); // Hit
      return VM_T_BOOLEAN;
    }

    case TC_VAL_INT14:
    case TC_REF_FLOAT64:
    case TC_REF_INT32:
    case TC_VAL_NAN:
    case TC_VAL_NEG_ZERO: {
      CODE_COVERAGE(342); // Hit
      return VM_T_NUMBER;
    }

    case TC_REF_STRING:
    case TC_REF_UNIQUE_STRING:
    case TC_VAL_STR_LENGTH:
    case TC_VAL_STR_PROTO: {
      CODE_COVERAGE(343); // Hit
      return VM_T_STRING;
    }

    case TC_REF_ARRAY: {
      CODE_COVERAGE_UNTESTED(344); // Not hit
      return VM_T_ARRAY;
    }

    case TC_REF_PROPERTY_LIST:
    case TC_REF_STRUCT: {
      CODE_COVERAGE_UNTESTED(345); // Not hit
      return VM_T_OBJECT;
    }

    case TC_REF_FUNCTION:
    case TC_REF_HOST_FUNC: {
      CODE_COVERAGE(346); // Hit
      return VM_T_FUNCTION;
    }

    case TC_REF_BIG_INT: {
      CODE_COVERAGE_UNTESTED(347); // Not hit
      return VM_T_BIG_INT;
    }
    case TC_REF_SYMBOL: {
      CODE_COVERAGE_UNTESTED(348); // Not hit
      return VM_T_SYMBOL;
    }

    default: VM_UNEXPECTED_INTERNAL_ERROR(vm); return VM_T_UNDEFINED;
  }
}

const char* mvm_toStringUtf8(VM* vm, Value value, size_t* out_sizeBytes) {
  CODE_COVERAGE(43); // Hit
  value = vm_convertToString(vm, value);

  uint16_t headerWord = vm_readHeaderWord(vm, value);
  TeTypeCode typeCode = vm_getTypeCodeFromHeaderWord(headerWord);

  if (typeCode == TC_VAL_STR_PROTO) {
    *out_sizeBytes = 9;
    return "__proto__";
  }

  if (typeCode == TC_VAL_STR_LENGTH) {
    *out_sizeBytes = 6;
    return "length";
  }

  VM_ASSERT(vm, (typeCode == TC_REF_STRING) || (typeCode == TC_REF_UNIQUE_STRING));

  uint16_t sourceSize = vm_getAllocationSizeExcludingHeaderFromHeaderWord(headerWord);

  if (out_sizeBytes) {
    CODE_COVERAGE(349); // Hit
    *out_sizeBytes = sourceSize - 1; // Without the extra safety null-terminator
  } else {
    CODE_COVERAGE_UNTESTED(350); // Not hit
  }

  // If the string is program memory, we have to allocate a copy of it in data
  // memory because program memory is not necessarily addressable
  // TODO: There should be a flag to suppress this when it isn't needed
  if (VM_IS_PGM_P(value)) {
    CODE_COVERAGE(351); // Hit
    void* data;
    gc_allocateWithHeader(vm, sourceSize, TC_REF_STRING, &data);
    vm_readMem(vm, data, value, sourceSize);
    return data;
  } else {
    CODE_COVERAGE(352); // Hit
    return vm_deref(vm, value);
  }
}

Value mvm_newBoolean(bool source) {
  CODE_COVERAGE_UNTESTED(44); // Not hit
  return source ? VM_VALUE_TRUE : VM_VALUE_FALSE;
}

Value vm_allocString(VM* vm, size_t sizeBytes, void** data) {
  CODE_COVERAGE(45); // Hit
  if (sizeBytes > 0x3FFF - 1) {
    CODE_COVERAGE_ERROR_PATH(353); // Not hit
    MVM_FATAL_ERROR(vm, MVM_E_ALLOCATION_TOO_LARGE);
  } else {
    CODE_COVERAGE(354); // Hit
  }
  // Note: allocating 1 extra byte for the extra null terminator
  Value value = gc_allocateWithHeader(vm, (uint16_t)sizeBytes + 1, TC_REF_STRING, data);
  // Null terminator
  ((char*)(*data))[sizeBytes] = '\0';
  return value;
}

Value mvm_newString(VM* vm, const char* sourceUtf8, size_t sizeBytes) {
  CODE_COVERAGE_UNTESTED(46); // Not hit
  void* data;
  Value value = vm_allocString(vm, sizeBytes, &data);
  memcpy(data, sourceUtf8, sizeBytes);
  return value;
}

static TeError getProperty(VM* vm, Value objectValue, Value vPropertyName, Value* vPropertyValue) {
  CODE_COVERAGE(48); // Hit

  toPropertyName(vm, &vPropertyName);
  TeTypeCode type = deepTypeOf(vm, objectValue);
  switch (type) {
    case TC_REF_PROPERTY_LIST: {
      CODE_COVERAGE(359); // Hit
      if (vPropertyName == VM_VALUE_STR_PROTO) {
        CODE_COVERAGE_UNIMPLEMENTED(326); // Not hit
        return VM_NOT_IMPLEMENTED(vm);
      }
      LongPtr lpPropertyList = DynamicPtr_decode_long(vm, objectValue);
      DynamicPtr dpProto = READ_FIELD_2(lpPropertyList, TsPropertyList2, dpProto);

      while (lpPropertyList) {
        // WIP Don't forget to add the header to all property list "cells"
        uint16_t headerWord = readHeaderWord_long(lpPropertyList);
        uint16_t size = vm_getAllocationSizeExcludingHeaderFromHeaderWord(headerWord);
        uint16_t propCount = (size - sizeof (TsPropertyList2)) / 4;

        LongPtr p = LongPtr_add(lpPropertyList, sizeof (TsPropertyList2));
        while (propCount--) {
          Value key = LongPtr_read2(p);
          p = LongPtr_add(p, 2);
          Value value = LongPtr_read2(p);
          p = LongPtr_add(p, 2);

          if (key == vPropertyName) {
            CODE_COVERAGE(361); // Hit
            *vPropertyValue = value;
            return MVM_E_SUCCESS;
          } else {
            CODE_COVERAGE(362); // Hit
          }
        }

        DynamicPtr dpNext = READ_FIELD_2(lpPropertyList, TsPropertyList2, dpNext);
         // Move to next group, if there is one
        if (dpNext != VM_VALUE_NULL) {
          lpPropertyList = DynamicPtr_decode_long(vm, dpNext);
        } else { // Otherwise try read from the prototype
          lpPropertyList = DynamicPtr_decode_long(vm, dpProto);
          // Compute the *next* prototype
          dpProto = READ_FIELD_2(lpPropertyList, TsPropertyList2, dpProto);
        }
      }

      *vPropertyValue = VM_VALUE_UNDEFINED;
      return MVM_E_SUCCESS;
    }
    case TC_REF_ARRAY: {
      CODE_COVERAGE(363); // Hit
      // WIP: I'm curious about the machine code generated for this
      LongPtr lpArr = DynamicPtr_decode_long(vm, objectValue);
      Value viLength = READ_FIELD_2(lpArr, TsArray, viLength);
      VM_ASSERT(vm, Value_isVirtualInt14(viLength));
      uint16_t length = VirtualInt14_decode(vm, viLength);
      if (vPropertyName == VM_VALUE_STR_LENGTH) {
        CODE_COVERAGE(274); // Hit
        VM_ASSERT(vm, Value_isVirtualInt14(length));
        *vPropertyValue = length;
        return MVM_E_SUCCESS;
      } else if (vPropertyName == VM_VALUE_STR_PROTO) {
        CODE_COVERAGE(275); // Hit
        *vPropertyValue = vm->builtins.dpArrayProto2;
        return MVM_E_SUCCESS;
      } else {
        CODE_COVERAGE(276); // Hit
      }
      // Array index
      if (Value_isVirtualInt14(vPropertyName)) {
        CODE_COVERAGE(277); // Hit
        uint16_t index = VirtualInt14_decode(vm, vPropertyName);
        DynamicPtr dpData = READ_FIELD_2(lpArr, TsArray, dpData2);
        LongPtr lpData = DynamicPtr_decode_long(vm, dpData);
        VM_ASSERT(vm, index >= 0);
        if (index >= length) {
          CODE_COVERAGE(283); // Hit
          *vPropertyValue = VM_VALUE_UNDEFINED;
          return MVM_E_SUCCESS;
        } else {
          CODE_COVERAGE(328); // Hit
        }
        Value value = LongPtr_read2(LongPtr_add(lpData, index * 2));
        if (value == VM_VALUE_DELETED) {
          CODE_COVERAGE(329); // Hit
          value = VM_VALUE_UNDEFINED;
        } else {
          CODE_COVERAGE(364); // Hit
        }
        *vPropertyValue = value;
        return MVM_E_SUCCESS;
      }
      CODE_COVERAGE(278); // Hit

      Value arrayProto = vm->builtins.dpArrayProto2;
      if (arrayProto != VM_VALUE_NULL) {
        CODE_COVERAGE(396); // Hit
        return getProperty(vm, arrayProto, vPropertyName, vPropertyValue);
      } else {
        CODE_COVERAGE_UNTESTED(397); // Not hit
        *vPropertyValue = VM_VALUE_UNDEFINED;
        return MVM_E_SUCCESS;
      }
    }
    case TC_REF_STRUCT: {
      CODE_COVERAGE_UNIMPLEMENTED(365); // Not hit
      return VM_NOT_IMPLEMENTED(vm);
    }
    default: return MVM_E_TYPE_ERROR;
  }
}

static void growArray(VM* vm, TsArray* arr, uint16_t newLength, uint16_t newCapacity) {
  CODE_COVERAGE(293); // Hit
  VM_ASSERT(vm, newCapacity >= newLength);
  if (newCapacity > MAX_ALLOCATION_SIZE / 2)
    MVM_FATAL_ERROR(vm, MVM_E_ARRAY_TOO_LONG);
  VM_ASSERT(vm, newCapacity != 0);

  uint16_t* pNewData = gc_allocateWithHeader2(vm, newCapacity * 2, TC_REF_FIXED_LENGTH_ARRAY);
  // Copy values from the old array
  DynamicPtr dpOldData = arr->dpData2;
  uint16_t oldCapacity = 0;
  if (dpOldData != VM_VALUE_NULL) {
    CODE_COVERAGE(294); // Hit
    VM_ASSERT(vm, VirtualInt14_decode(vm, arr->viLength) != 0);

    LongPtr lpOldData = DynamicPtr_decode_long(vm, dpOldData);

    uint16_t oldDataHeader = readHeaderWord_long(lpOldData);
    uint16_t oldSize = vm_getAllocationSizeExcludingHeaderFromHeaderWord(oldDataHeader);
    VM_ASSERT(vm, oldSize & 2 == 0);
    oldCapacity = oldSize / 2;

    memcpy_long(pNewData, lpOldData, oldSize);
  } else {
    CODE_COVERAGE(310); // Hit
  }
  CODE_COVERAGE(325); // Hit
  VM_ASSERT(vm, newCapacity >= oldCapacity);
  // Fill in the rest of the memory as holes
  uint16_t* p = &pNewData[oldCapacity];
  uint16_t* end = &pNewData[newCapacity];
  while (p != end) {
    *p++ = VM_VALUE_DELETED;
  }
  arr->dpData2 = ShortPtr_encode(vm, pNewData);
  arr->viLength = VirtualInt14_encode(vm, newLength);
}

static TeError setProperty(VM* vm, Value vObjectValue, Value vPropertyName, Value vPropertyValue) {
  CODE_COVERAGE(49); // Hit

  toPropertyName(vm, &vPropertyName);
  TeTypeCode type = deepTypeOf(vm, vObjectValue);
  switch (type) {
    case TC_REF_PROPERTY_LIST: {
      CODE_COVERAGE(366); // Hit
      if (vPropertyName == VM_VALUE_STR_PROTO) {
        CODE_COVERAGE_UNIMPLEMENTED(327); // Not hit
        return VM_NOT_IMPLEMENTED(vm);
      }

      // Note: while objects in general can be in ROM, objects which are
      // writable must always be in RAM.

      TsPropertyList2* pPropertyList = DynamicPtr_decode(vm, vObjectValue);

      while (true) {
        CODE_COVERAGE(367); // Hit
        uint16_t headerWord = readHeaderWord(pPropertyList);
        uint16_t size = vm_getAllocationSizeExcludingHeaderFromHeaderWord(headerWord);
        uint16_t propCount = (size - sizeof (TsPropertyList2)) / 4;

        uint16_t* p = &pPropertyList->keyValues[0];
        while (propCount--) {
          Value key = *p++;

          // We can do direct comparison because the strings have been uniqued,
          // and numbers are represented in a normalized way.
          if (key == vPropertyName) {
            CODE_COVERAGE(368); // Hit
            *p = vPropertyValue;
            return MVM_E_SUCCESS;
          } else {
            // Skip to next property
            p++;
            CODE_COVERAGE(369); // Hit
          }
        }

        DynamicPtr dpNext = pPropertyList->dpNext;
        // Move to next group, if there is one
        if (dpNext != VM_VALUE_NULL) {
          pPropertyList = DynamicPtr_decode(vm, dpNext);
        } else {
          break;
        }
      }
      // If we reach the end, then this is a new property. We add new properties
      // by just appending a new TsPropertyList onto the linked list. The GC
      // will compact these into the head later.
      TsPropertyList2* pNewCell = gc_allocateWithHeader2(vm, sizeof (TsPropertyList2) + 4, TC_REF_PROPERTY_LIST);
      ShortPtr spNewCell = ShortPtr_encode(vm, pNewCell);
      pNewCell->dpNext = VM_VALUE_NULL;
      pNewCell->dpProto = VM_VALUE_NULL; // Not used
      pNewCell->keyValues[0] = vPropertyName;
      pNewCell->keyValues[1] = vPropertyValue;

      // Attach to linked list. This needs to be a long-pointer write because we
      // don't know if the original property list was in data memory.
      //
      // Note: `pPropertyList` currently points to the last property list in
      // the chain.
      pPropertyList->dpNext = spNewCell;

      return MVM_E_SUCCESS;
    }
    case TC_REF_ARRAY: {
      CODE_COVERAGE(370); // Hit

      // Note: while objects in general can be in ROM, objects which are
      // writable must always be in RAM.

      TsArray* arr = DynamicPtr_decode(vm, vObjectValue);
      VirtualInt14 viLength = arr->viLength;
      VM_ASSERT(vm, Value_isVirtualInt14(viLength));
      uint16_t oldLength = VirtualInt14_decode(vm, viLength);
      DynamicPtr dpData2 = arr->dpData2;

      VM_ASSERT(vm, Value_isShortPtr(dpData2));
      uint16_t* pData = DynamicPtr_decode(vm, dpData2);

      // If the property name is "length" then we'll be changing the length
      if (vPropertyName == VM_VALUE_STR_LENGTH) {
        CODE_COVERAGE(282); // Hit
        uint16_t dataSize = getAllocationSize(dpData2);
        uint16_t oldCapacity = dataSize / 2;

        if (!Value_isVirtualInt14(vPropertyValue))
          MVM_FATAL_ERROR(vm, MVM_E_TYPE_ERROR);
        uint16_t newLength = VirtualInt14_decode(vm, vPropertyValue);

        if (newLength <= oldLength) { // Making array smaller
          CODE_COVERAGE(176); // Hit

          // Wipe array items that aren't reachable
          uint16_t count = oldLength - newLength;
          uint16_t* p = &pData[newLength];
          while (count--)
            *p++ = VM_VALUE_DELETED;

          arr->viLength = VirtualInt14_encode(vm, newLength);
          return MVM_E_SUCCESS;
        } else if (newLength < oldCapacity) {
          CODE_COVERAGE(287); // Hit

          // We can just overwrite the length field. Note that the newly
          // uncovered memory is already filled with VM_VALUE_DELETED
          arr->viLength = VirtualInt14_encode(vm, newLength);
          return MVM_E_SUCCESS;
        } else { // Make array bigger
          CODE_COVERAGE(288); // Hit
          // I'll assume that direct assignments to the length mean that people
          // know exactly how big the array should be, so we don't add any
          // extra capacity
          uint16_t newCapacity = newLength;
          growArray(vm, arr, newLength, newCapacity);
          return MVM_E_SUCCESS;
        }
      } else if (vPropertyName == VM_VALUE_STR_PROTO) { // Writing to the __proto__ property
        CODE_COVERAGE_UNTESTED(289); // Not hit
        // We could make this read/write in future
        return MVM_E_PROTO_IS_READONLY;
      } else if (Value_isVirtualInt14(vPropertyName)) { // Array index
        CODE_COVERAGE(285); // Hit
        uint16_t index = vPropertyName;
        VM_ASSERT(vm, index >= 0);

        uint16_t dataSize = getAllocationSize(dpData2);
        uint16_t oldCapacity = dataSize / 2;

        // Need to expand the array?
        if (index >= oldLength) {
          CODE_COVERAGE(290); // Hit
          uint16_t newLength = index + 1;
          if (index < oldCapacity) {
            CODE_COVERAGE(291); // Hit
            // The length changes to include the value. The extra slots are
            // already filled in with holes from the original allocation.
            arr->viLength = VirtualInt14_encode(vm, newLength);
          } else {
            CODE_COVERAGE(292); // Hit
            // We expand the capacity more aggressively here because this is the
            // path used when we push into arrays or just assign values to an
            // array in a loop.
            uint16_t newCapacity = oldCapacity * 2;
            if (newCapacity < 4) newCapacity = 4;
            if (newCapacity < newLength) newCapacity = newLength;
            growArray(vm, arr, newLength, newCapacity);
          }
        } // End of array expansion

        // Write the item to memory
        pData[index] = vPropertyValue;

        return MVM_E_SUCCESS;
      }
      CODE_COVERAGE(286); // Hit

      // JavaScript doesn't seem to throw by default when you set properties on
      // immutable objects. Here, I'm just treating the array as if it were
      // immutable with respect to non-index properties, and so here I'm just
      // ignoring the write.
      return MVM_E_SUCCESS;
    }
    case TC_REF_STRUCT: {
      CODE_COVERAGE_UNIMPLEMENTED(372); // Not hit
      return VM_NOT_IMPLEMENTED(vm);
    }
    default: return MVM_E_TYPE_ERROR;
  }
}

/** Converts the argument to either an TC_VAL_INT14 or a TC_REF_UNIQUE_STRING, or gives an error */
static TeError toPropertyName(VM* vm, Value* value) {
  CODE_COVERAGE(50); // Hit
  // Property names in microvium are either integer indexes or non-integer unique strings
  TeTypeCode type = deepTypeOf(vm, *value);
  switch (type) {
    // These are already valid property names
    case TC_VAL_INT14: {
      CODE_COVERAGE(279); // Hit
      if (*value < 0) {
        CODE_COVERAGE_UNTESTED(280); // Not hit
        return MVM_E_RANGE_ERROR;
      }
      CODE_COVERAGE(281); // Hit
      return MVM_E_SUCCESS;
    }
    case TC_REF_UNIQUE_STRING: {
      CODE_COVERAGE(373); // Hit
      return MVM_E_SUCCESS;
    }

    case TC_REF_INT32: {
      CODE_COVERAGE_ERROR_PATH(374); // Not hit
      // 32-bit numbers are out of the range of supported array indexes
      return MVM_E_RANGE_ERROR;
    }

    case TC_REF_STRING: {
      CODE_COVERAGE_UNTESTED(375); // Not hit

      // In Microvium at the moment, it's illegal to use an integer-valued
      // string as a property name. If the string is in bytecode, it will only
      // have the type TC_REF_STRING if it's a number and is illegal.
      if (VM_IS_PGM_P(*value)) {
        CODE_COVERAGE_ERROR_PATH(376); // Not hit
        return MVM_E_TYPE_ERROR;
      } else {
        CODE_COVERAGE_UNTESTED(377); // Not hit
      }

      // Strings which have all digits are illegal as property names
      if (vm_stringIsNonNegativeInteger(vm, *value)) {
        CODE_COVERAGE_ERROR_PATH(378); // Not hit
        return MVM_E_TYPE_ERROR;
      } else {
        CODE_COVERAGE_UNTESTED(379); // Not hit
      }

      // Strings need to be converted to unique strings in order to be valid
      // property names. This is because properties are searched by reference
      // equality.
      *value = toUniqueString(vm, *value);
      return MVM_E_SUCCESS;
    }

    case TC_VAL_STR_LENGTH: {
      CODE_COVERAGE(272); // Hit
      return MVM_E_SUCCESS;
    }

    case TC_VAL_STR_PROTO: {
      CODE_COVERAGE(273); // Hit
      return MVM_E_SUCCESS;
    }
    default: {
      CODE_COVERAGE_ERROR_PATH(380); // Not hit
      return MVM_E_TYPE_ERROR;
    }
  }
}

// Converts a TC_REF_STRING to a TC_REF_UNIQUE_STRING
// TODO: Test cases for this function
static Value toUniqueString(VM* vm, Value value) {
  CODE_COVERAGE_UNTESTED(51); // Not hit
  VM_ASSERT(vm, deepTypeOf(vm, value) == TC_REF_STRING);

  // TC_REF_STRING values are always in GC memory. If they were in flash, they'd
  // already be TC_REF_UNIQUE_STRING.
  char* pStr1 = DynamicPtr_decode(vm, value);
  uint16_t str1Size = getAllocationSize(vm, value);

  static const char PROTO_STR[] = "__proto__";
  static const char LENGTH_STR[] = "length";
  LongPtr lpStr1 = LongPtr_new(pStr1);
  if ((str1Size == sizeof PROTO_STR) && (memcmp_long(lpStr1, LongPtr_new(PROTO_STR), sizeof PROTO_STR) == 0))
    return VM_VALUE_STR_PROTO;
  if ((str1Size == sizeof LENGTH_STR) && (memcmp_long(lpStr1, LongPtr_new(LENGTH_STR), sizeof LENGTH_STR) == 0))
    return VM_VALUE_STR_LENGTH;

  LongPtr pBytecode = vm->pBytecode;

  // We start by searching the string table for unique strings that are baked
  // into the ROM. These are stored alphabetically, so we can perform a binary
  // search.

  uint16_t stringTableOffset = VM_READ_BC_2_HEADER_FIELD(stringTableOffset, pBytecode);
  uint16_t stringTableSize = VM_READ_BC_2_HEADER_FIELD(stringTableSize, pBytecode);
  int strCount = stringTableSize / sizeof (Value);

  int first = 0;
  int last = strCount;
  int middle = (first + last) / 2;

  while (first <= last) {
    CODE_COVERAGE_UNTESTED(381); // Not hit
    uint16_t str2Offset = stringTableOffset + middle * 2;
    Value vStr2 = VM_READ_BC_2_AT(str2Offset, pBytecode);
    VM_ASSERT(vm, VM_IS_PGM_P(vStr2));
    uint16_t str2Size = getAllocationSize(vm, vStr2);
    LongPtr lpStr2 = DynamicPtr_decode_long(vm, vStr2);
    int compareSize = str1Size < str2Size ? str1Size : str2Size;
    int c = memcmp_long(lpStr1, lpStr2, compareSize);

    // If they compare equal for the range that they have in common, we check the length
    if (c == 0) {
      CODE_COVERAGE_UNTESTED(382); // Not hit
      if (str1Size < str2Size) {
        CODE_COVERAGE_UNTESTED(383); // Not hit
        c = -1;
      } else if (str1Size > str2Size) {
        CODE_COVERAGE_UNTESTED(384); // Not hit
        c = 1;
      } else {
        CODE_COVERAGE_UNTESTED(385); // Not hit
        // Exact match
        return vStr2;
      }
    }

    // c is > 0 if the string we're searching for comes after the middle point
    if (c > 0) {
      CODE_COVERAGE_UNTESTED(386); // Not hit
      first = middle + 1;
    } else {
      CODE_COVERAGE_UNTESTED(387); // Not hit
      last = middle - 1;
    }

    middle = (first + last) / 2;
  }

  // At this point, we haven't found the unique string in the bytecode. We need
  // to check in RAM. Now we're comparing an in-RAM string against other in-RAM
  // strings. We're looking for an exact match, not performing a binary search
  // with inequality comparison, since the linked list of unique strings in RAM
  // is not sorted.
  DynamicPtr spCell = vm->builtins.spUniqueStrings;
  while (spCell != VM_VALUE_NULL) {
    CODE_COVERAGE_UNTESTED(388); // Not hit
    VM_ASSERT(vm, Value_isShortPtr(spCell));
    TsUniqueStringCell* pCell = ShortPtr_decode(vm, spCell);
    Value vStr2 = pCell->str;
    uint16_t str2Header = vm_readHeaderWord(vm, vStr2);
    int str2Size = vm_getAllocationSizeExcludingHeaderFromHeaderWord(str2Header);
    char* pStr2 = ShortPtr_decode(vm, vStr2);

    // The sizes have to match for the strings to be equal
    if (str2Size == str1Size) {
      CODE_COVERAGE_UNTESTED(389); // Not hit
      // Note: we use memcmp instead of strcmp because strings are allowed to
      // have embedded null terminators.
      int c = memcmp(pStr1, pStr2, str1Size);
      // Equal?
      if (c == 0) {
        CODE_COVERAGE_UNTESTED(390); // Not hit
        return vStr2;
      } else {
        CODE_COVERAGE_UNTESTED(391); // Not hit
      }
    }
    spCell = pCell->spNext;
  }

  // If we get here, it means there was no matching unique string already
  // existing in ROM or RAM. We upgrade the current string to a
  // TC_REF_UNIQUE_STRING, since we now know it doesn't conflict with any existing
  // existing unique strings.
  setHeaderWord(vm, pStr1, TC_REF_UNIQUE_STRING, str1Size);

  // Add the string to the linked list of unique strings
  TsUniqueStringCell* pCell = gc_allocateWithHeader2(vm, sizeof (TsUniqueStringCell), TC_REF_INTERNAL_CONTAINER);
  // Push onto linked list2
  pCell->spNext = vm->builtins.spUniqueStrings;
  pCell->str = value;
  vm->builtins.spUniqueStrings = ShortPtr_encode(vm, pCell);

  return value;
}

static int memcmp_long(LongPtr p1, LongPtr p2, uint16_t size) {
  CODE_COVERAGE_UNTESTED(471); // Not hit
  return MVM_LONG_MEM_CMP(p1, p2, size);
}

static void memcpy_long(void* target, LongPtr source, uint16_t size) {
  CODE_COVERAGE_UNTESTED(471); // Not hit
  MVM_LONG_MEM_CPY(target, source, size);
}

/** Size of string excluding bonus null terminator */
static uint16_t vm_stringSizeUtf8(VM* vm, Value stringValue) {
  CODE_COVERAGE(53); // Hit
  uint16_t headerWord = vm_readHeaderWord(vm, stringValue);
  TeTypeCode typeCode = vm_getTypeCodeFromHeaderWord(headerWord);
  if (typeCode == TC_VAL_STR_PROTO) return 9;
  if (typeCode == TC_VAL_STR_LENGTH) return 6;
  VM_ASSERT(vm, (typeCode == TC_REF_STRING) || (typeCode == TC_REF_UNIQUE_STRING));
  return vm_getAllocationSizeExcludingHeaderFromHeaderWord(headerWord) - 1;
}

/**
 * Checks if a string contains only decimal digits (and is not empty). May only
 * be called on TC_REF_STRING and only those in GC memory.
 */
static bool vm_stringIsNonNegativeInteger(VM* vm, Value str) {
  CODE_COVERAGE_UNTESTED(55); // Not hit
  VM_ASSERT(vm, deepTypeOf(vm, str) == TC_REF_STRING);
  VM_ASSERT(vm, VM_IS_GC_P(str));

  char* data = gc_deref(vm, str);
  // Length excluding bonus null terminator
  uint16_t len = (((uint16_t*)data)[-1] & 0xFFF) - 1;
  if (!len) return false;
  while (len--) {
    CODE_COVERAGE_UNTESTED(398); // Not hit
    if (!isdigit(*data++)) {
      CODE_COVERAGE_UNTESTED(399); // Not hit
      return false;
    } else {
      CODE_COVERAGE_UNTESTED(400); // Not hit
    }
  }
  return true;
}

TeError toInt32Internal(mvm_VM* vm, mvm_Value value, int32_t* out_result) {
  CODE_COVERAGE(56); // Hit
  // TODO: when the type codes are more stable, we should convert these to a table.
  *out_result = 0;
  TeTypeCode type = deepTypeOf(vm, value);
  MVM_SWITCH_CONTIGUOUS(type, TC_END - 1) {
    MVM_CASE_CONTIGUOUS(TC_VAL_INT14):
    MVM_CASE_CONTIGUOUS(TC_REF_INT32): {
      CODE_COVERAGE(401); // Hit
      *out_result = vm_readInt32(vm, type, value);
      return MVM_E_SUCCESS;
    }
    MVM_CASE_CONTIGUOUS(TC_REF_FLOAT64): {
      CODE_COVERAGE(402); // Hit
      return MVM_E_FLOAT64;
    }
    MVM_CASE_CONTIGUOUS(TC_REF_STRING): {
      CODE_COVERAGE_UNIMPLEMENTED(403); // Not hit
      VM_NOT_IMPLEMENTED(vm); break;
    }
    MVM_CASE_CONTIGUOUS(TC_REF_UNIQUE_STRING): {
      CODE_COVERAGE_UNIMPLEMENTED(404); // Not hit
      VM_NOT_IMPLEMENTED(vm); break;
    }
    MVM_CASE_CONTIGUOUS(TC_VAL_STR_LENGTH): {
      CODE_COVERAGE_UNIMPLEMENTED(270); // Not hit
      VM_NOT_IMPLEMENTED(vm); break;
    }
    MVM_CASE_CONTIGUOUS(TC_VAL_STR_PROTO): {
      CODE_COVERAGE_UNIMPLEMENTED(271); // Not hit
      VM_NOT_IMPLEMENTED(vm); break;
    }
    MVM_CASE_CONTIGUOUS(TC_REF_PROPERTY_LIST): {
      CODE_COVERAGE(405); // Hit
      return MVM_E_NAN;
    }
    MVM_CASE_CONTIGUOUS(TC_REF_ARRAY): {
      CODE_COVERAGE_UNTESTED(406); // Not hit
      return MVM_E_NAN;
    }
    MVM_CASE_CONTIGUOUS(TC_REF_FUNCTION): {
      CODE_COVERAGE_UNTESTED(408); // Not hit
      return MVM_E_NAN;
    }
    MVM_CASE_CONTIGUOUS(TC_REF_HOST_FUNC): {
      CODE_COVERAGE_UNTESTED(409); // Not hit
      return MVM_E_NAN;
    }
    MVM_CASE_CONTIGUOUS(TC_REF_STRUCT): {
      CODE_COVERAGE_UNTESTED(410); // Not hit
      return MVM_E_NAN;
    }
    MVM_CASE_CONTIGUOUS(TC_REF_BIG_INT): {
      CODE_COVERAGE_UNTESTED(411); // Not hit
      VM_RESERVED(vm); break;
    }
    MVM_CASE_CONTIGUOUS(TC_REF_SYMBOL): {
      CODE_COVERAGE_UNTESTED(412); // Not hit
      return MVM_E_NAN;
    }
    MVM_CASE_CONTIGUOUS(TC_VAL_UNDEFINED): {
      CODE_COVERAGE(413); // Hit
      return MVM_E_NAN;
    }
    MVM_CASE_CONTIGUOUS(TC_VAL_NULL): {
      CODE_COVERAGE(414); // Hit
      break;
    }
    MVM_CASE_CONTIGUOUS(TC_VAL_TRUE): {
      CODE_COVERAGE_UNTESTED(415); // Not hit
      *out_result = 1; break;
    }
    MVM_CASE_CONTIGUOUS(TC_VAL_FALSE): {
      CODE_COVERAGE_UNTESTED(416); // Not hit
      break;
    }
    MVM_CASE_CONTIGUOUS(TC_VAL_NAN): {
      CODE_COVERAGE(417); // Hit
      return MVM_E_NAN;
    }
    MVM_CASE_CONTIGUOUS(TC_VAL_NEG_ZERO): {
      CODE_COVERAGE(418); // Hit
      return MVM_E_NEG_ZERO;
    }
    MVM_CASE_CONTIGUOUS(TC_VAL_DELETED): {
      CODE_COVERAGE_UNTESTED(419); // Not hit
      return MVM_E_NAN;
    }
  }
  return MVM_E_SUCCESS;
}

int32_t mvm_toInt32(mvm_VM* vm, mvm_Value value) {
  CODE_COVERAGE(57); // Hit
  int32_t result;
  TeError err = toInt32Internal(vm, value, &result);
  if (err == MVM_E_SUCCESS) {
    CODE_COVERAGE(420); // Hit
    return result;
  } else if (err == MVM_E_NAN) {
    CODE_COVERAGE_UNTESTED(421); // Not hit
    return 0;
  } else if (err == MVM_E_NEG_ZERO) {
    CODE_COVERAGE_UNTESTED(422); // Not hit
    return 0;
  } else {
    CODE_COVERAGE_UNTESTED(423); // Not hit
  }

  VM_ASSERT(vm, deepTypeOf(vm, value) == TC_REF_FLOAT64);
  #if MVM_SUPPORT_FLOAT
    MVM_FLOAT64 f;
    vm_readMem(vm, &f, value, sizeof f);
    return (int32_t)f;
  #else // !MVM_SUPPORT_FLOAT
    // If things were compiled correctly, there shouldn't be any floats in the
    // system at all
    return 0;
  #endif
}

#if MVM_SUPPORT_FLOAT
MVM_FLOAT64 mvm_toFloat64(mvm_VM* vm, mvm_Value value) {
  CODE_COVERAGE(58); // Hit
  int32_t result;
  TeError err = toInt32Internal(vm, value, &result);
  if (err == MVM_E_SUCCESS) {
    CODE_COVERAGE(424); // Hit
    return result;
  } else if (err == MVM_E_NAN) {
    CODE_COVERAGE(425); // Hit
    return MVM_FLOAT64_NAN;
  } else if (err == MVM_E_NEG_ZERO) {
    CODE_COVERAGE(426); // Hit
    return -0.0;
  } else {
    CODE_COVERAGE(427); // Hit
  }

  VM_ASSERT(vm, deepTypeOf(vm, value) == TC_REF_FLOAT64);
  MVM_FLOAT64 f;
  vm_readMem(vm, &f, value, sizeof f);
  return f;
}
#endif // MVM_SUPPORT_FLOAT

bool mvm_equal(mvm_VM* vm, mvm_Value a, mvm_Value b) {
  CODE_COVERAGE(462); // Hit

  // TODO: Negative zero equality

  if (a == VM_VALUE_NAN) {
    CODE_COVERAGE(16); // Hit
    return false;
  }

  if (a == b) {
    CODE_COVERAGE_UNTESTED(463); // Not hit
    return true;
  }

  TeTypeCode aType = deepTypeOf(vm, a);
  TeTypeCode bType = deepTypeOf(vm, b);
  if (aType != bType) {
    CODE_COVERAGE(464); // Hit
    return false;
  }

  TABLE_COVERAGE(aType, TC_END, 465); // Not hit

  // Some types compare with value equality, so we do memory equality check
  if ((aType == TC_REF_INT32) || (aType == TC_REF_FLOAT64) || (aType == TC_REF_BIG_INT)) {
    CODE_COVERAGE_UNTESTED(475); // Not hit
    uint16_t aHeaderWord = vm_readHeaderWord(vm, a);
    uint16_t bHeaderWord = vm_readHeaderWord(vm, b);
    // If the header words are different, the sizes are different
    if (aHeaderWord != bHeaderWord) {
      CODE_COVERAGE_UNTESTED(476); // Not hit
      return false;
    }
    CODE_COVERAGE_UNTESTED(477); // Not hit
    uint16_t size = vm_getAllocationSizeExcludingHeaderFromHeaderWord(aHeaderWord);
    if (memcmp_long(vm, a, b, size) == 0) {
      CODE_COVERAGE_UNTESTED(481); // Not hit
      return true;
    } else {
      CODE_COVERAGE_UNTESTED(482); // Not hit
      return false;
    }
  } else {
    // All other types compare with reference equality, which we've already checked
    return false;
  }
}

bool mvm_isNaN(mvm_Value value) {
  return value == VM_VALUE_NAN;
}

static void sanitizeArgs(VM* vm, Value* args, uint8_t argCount) {
  /*
  It's important that we don't leak object pointers into the host because static
  analysis optimization passes need to be able to perform unambiguous alias
  analysis, and we don't yet have a standard ABI for allowing the host to
  interact with objects in a way that works with these kinds of optimizers
  (maybe in future).
  */
  Value* arg = args;
  while (argCount--) {
    VM_ASSERT(vm, *arg != VM_VALUE_DELETED);
    mvm_TeType type = mvm_typeOf(vm, *arg);
    if (
      (type == VM_T_FUNCTION) ||
      (type == VM_T_OBJECT) ||
      (type == VM_T_ARRAY)
    ) {
      *arg = VM_VALUE_UNDEFINED;
    }
    arg++;
  }
}

#if MVM_GENERATE_SNAPSHOT_CAPABILITY

static BytecodeMappedPtr BytecodeMappedPtr_encode(VM* vm, void* p) {
  uint16_t offsetInHeap = pointerOffsetInHeap(vm, vm->pLastBucket2, vm->pAllocationCursor2, p);
  uint16_t bytecodeHeapOffset = VM_READ_BC_2_HEADER_FIELD(initialHeapOffset, vm->pBytecode);
  uint16_t offsetInBytecode = bytecodeHeapOffset + offsetInHeap;
  VM_ASSERT(vm, (offsetInBytecode & 1) == 0);
  VM_ASSERT(vm, offsetInBytecode <= 0x7FFF);
  return (offsetInBytecode << 1) | 1;
}

// Opposite of loadPtr
static void serializePtr(VM* vm, Value* pv) {
  Value v = *pv;
  if (!Value_isShortPtr(v))
    return;
  void* p = ShortPtr_decode(vm, v);
  BytecodeMappedPtr dp = BytecodeMappedPtr_encode(vm, p);
  *pv = dp;
}

// The opposite of `loadPointers`
static void serializePointers(VM* vm, mvm_TsBytecodeHeader* bc) {
  // CAREFUL! This function mutates `bc`, not `vm`.

  uint16_t n;
  uint16_t* p;

  uint16_t heapOffset = bc->initialHeapOffset;

  uint16_t* dataMemory = (uint16_t*)((uint8_t*)bc + bc->initialDataOffset);
  uint16_t* heapMemory = (uint16_t*)((uint8_t*)bc + bc->initialHeapOffset);

  // Roots in global variables
  n = bc->globalVariableCount;
  p = dataMemory;
  while (n--) {
    serializePtr(vm, p++);
  }

  // Roots in data memory
  {
    uint16_t gcRootsOffset = bc->gcRootsOffset;
    uint16_t n = bc->gcRootsCount;

    uint16_t* pTableEntry = (uint16_t*)((uint8_t*)bc + gcRootsOffset);
    while (n--) {
      // The table entry in program memory gives us an offset in data memory
      uint16_t dataOffsetWords = LongPtr_read2(pTableEntry);
      pTableEntry = LongPtr_add(pTableEntry, 2);
      uint16_t* pDataValue = &dataMemory[dataOffsetWords];
      serializePtr(vm, pDataValue);
    }
  }

  // Builtins
  n = sizeof (mvm_Builtins) / 2;
  p = (uint16_t*)&bc->builtins;
  while (n--) {
    serializePtr(vm, p++);
  }

  // Pointers in heap memory
  p = heapMemory;
  uint16_t* heapEnd = (uint16_t*)((uint8_t*)heapMemory + bc->initialHeapSize);
  while (p < heapEnd) {
    uint16_t header = *p++;
    uint16_t size = vm_getAllocationSizeExcludingHeaderFromHeaderWord(header);
    uint16_t words = (size + 1) / 2;
    TeTypeCode tc = vm_getTypeCodeFromHeaderWord(header);

    if (tc < TC_REF_DIVIDER_CONTAINER_TYPES) { // Non-container types
      p += words;
      continue;
    } // Else, container types

    while (words--) {
      if (Value_isShortPtr(*p))
        serializePtr(vm, p);
      p++;
    }
  }
}

void* mvm_createSnapshot(mvm_VM* vm, size_t* out_size) {
  CODE_COVERAGE(503); // Hit
  *out_size = 0;
  /*
  This function works by just adjusting the original bytecode file, replacing
  the heap and updating the globals.
  */
  uint16_t originalBytecodeSize = VM_READ_BC_2_HEADER_FIELD(bytecodeSize, vm->pBytecode);
  uint16_t originalHeapSize = VM_READ_BC_2_HEADER_FIELD(initialHeapSize, vm->pBytecode);
  uint16_t dataSize = VM_READ_BC_2_HEADER_FIELD(initialDataSize, vm->pBytecode);
  uint16_t heapSize = getHeapSize(vm);
  uint32_t bytecodeSize = originalBytecodeSize - originalHeapSize + heapSize;
  if (bytecodeSize > 0xFFFF) {
    MVM_FATAL_ERROR(vm, MVM_E_SNAPSHOT_TOO_LARGE);
  }

  mvm_TsBytecodeHeader* result = malloc(bytecodeSize);
  // The first part of the snapshot doesn't change between executions (except
  // some header fields, which we'll update later).
  uint16_t sizeOfConstantPart = bytecodeSize - heapSize - dataSize;
  VM_READ_BC_N_AT(result, 0, sizeOfConstantPart, vm->pBytecode);

  // Snapshot data memory
  memcpy((uint8_t*)result + result->initialDataOffset, vm->dataMemory, dataSize);

  // Snapshot heap memory

  TsBucket2* pBucket = vm->pLastBucket2;
  // Start at the end of the heap and work backwards, because buckets are linked in reverse order
  uint8_t* heapStart = (uint8_t*)result + result->initialHeapOffset;
  uint8_t* pTarget = heapStart + heapSize;
  uint16_t cursor = heapSize;
  while (pBucket) {
    CODE_COVERAGE(504); // Hit
    uint16_t offsetStart = pBucket->offsetStart;
    uint16_t bucketSize = cursor - offsetStart;
    uint8_t* pBucketData = getBucketDataBegin(pBucket);

    pTarget -= bucketSize;
    memcpy(pTarget, pBucketData, bucketSize);

    cursor = offsetStart;
    pBucket = pBucket->prev;
  }

  // Update header fields
  result->initialHeapSize = heapSize;
  result->bytecodeSize = bytecodeSize;

  // Update builtins
  memcpy(&result->builtins, &vm->builtins, sizeof result->builtins);

  serializePointers(vm, result);

  result->crc = MVM_CALC_CRC16_CCITT(((void*)&result->requiredEngineVersion), ((uint16_t)bytecodeSize - 6));

  *out_size = bytecodeSize;
  return (void*)result;
}
#endif // MVM_GENERATE_SNAPSHOT_CAPABILITY
