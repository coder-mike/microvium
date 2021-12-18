// Copyright 2020 Michael Hunter. Part of the Microvium project. Links to full code at https://microvium.com for license details.

/*
 * Microvium Bytecode Interpreter
 *
 * Version: {{version}}
 *
 * This file contains the Microvium virtual machine C implementation.
 *
 * The key functions are mvm_restore() and mvm_call(), which perform the
 * initialization and run loop respectively.
 *
 * I've written Microvium in C because lots of embedded projects for small
 * processors are written in pure-C, and so integration for them will be easier.
 * Also, there are a surprising number of C++ compilers in the embedded world
 * that deviate from the standard, and I don't want to be testing on all of them
 * individually.
 *
 * For the moment, I'm keeping Microvium all in one file for usability. Users
 * can treat this file as a black box that contains the VM, and there's only one
 * file they need to have built into their project in order to have Microvium
 * running. The build process also pulls in the dependent header files, so
 * there's only one header file and it's the one that users of Microvium need to
 * see. Certain compilers and optimization settings also do a better job when
 * related functions are co-located the same compilation unit.
 *
 * User-facing functions and definitions are all prefixed with `mvm_` to
 * namespace them separately from other functions in their project, some of
 * which use the prefix `vm_` and some without a prefix. (TODO: this should be
 * consolidated)
 */

#include "microvium.h"

#include <ctype.h>
#include <stdlib.h>

#include "microvium_internals.h"
#include "math.h"

// A CALL instruction saves the current registers to the stack. I'm calling this
// the "frame boundary" since it is a fixed-size sequence of words that marks
// the boundary between stack frames. The shape of this saved state is coupled
// to a few different places in the engine, so I'm versioning it here in case I
// need to make changes
#define VM_FRAME_BOUNDARY_VERSION 2

// The number of words between one call stack frame and the next (i.e. the
// number of saved registers during a CALL)
#define VM_FRAME_BOUNDARY_SAVE_SIZE_WORDS 4

static inline mvm_HostFunctionID vm_getHostFunctionId(VM*vm, uint16_t hostFunctionIndex);
static TeError vm_createStackAndRegisters(VM* vm);
static TeError vm_requireStackSpace(VM* vm, uint16_t* pStackPointer, uint16_t sizeRequiredInWords);
static void vm_push(VM* vm, uint16_t value);
static uint16_t vm_pop(VM* vm);
static Value vm_convertToString(VM* vm, Value value);
static Value vm_concat(VM* vm, Value left, Value right);
static TeTypeCode deepTypeOf(VM* vm, Value value);
static bool vm_isString(VM* vm, Value value);
static int32_t vm_readInt32(VM* vm, TeTypeCode type, Value value);
static TeError vm_resolveExport(VM* vm, mvm_VMExportID id, Value* result);
static inline mvm_TfHostFunction* vm_getResolvedImports(VM* vm);
static void gc_createNextBucket(VM* vm, uint16_t bucketSize, uint16_t minBucketSize);
static void* gc_allocateWithHeader(VM* vm, uint16_t sizeBytes, TeTypeCode typeCode);
static void gc_freeGCMemory(VM* vm);
static Value vm_allocString(VM* vm, size_t sizeBytes, void** data);
static TeError getProperty(VM* vm, Value objectValue, Value propertyName, Value* propertyValue);
static TeError setProperty(VM* vm, Value objectValue, Value propertyName, Value propertyValue);
static TeError toPropertyName(VM* vm, Value* value);
static Value toInternedString(VM* vm, Value value);
static uint16_t vm_stringSizeUtf8(VM* vm, Value str);
static bool vm_ramStringIsNonNegativeInteger(VM* vm, Value str);
static TeError toInt32Internal(mvm_VM* vm, mvm_Value value, int32_t* out_result);
static void sanitizeArgs(VM* vm, Value* args, uint8_t argCount);
static void loadPtr(VM* vm, uint8_t* heapStart, Value* pValue);
static inline uint16_t vm_getAllocationSizeExcludingHeaderFromHeaderWord(uint16_t headerWord);
static inline LongPtr LongPtr_add(LongPtr lp, int16_t offset);
static inline uint16_t LongPtr_read2_aligned(LongPtr lp);
static inline uint16_t LongPtr_read2_unaligned(LongPtr lp);
static void memcpy_long(void* target, LongPtr source, size_t size);
static void loadPointers(VM* vm, void* heapStart);
static inline ShortPtr ShortPtr_encode(VM* vm, void* ptr);
static inline uint8_t LongPtr_read1(LongPtr lp);
static LongPtr DynamicPtr_decode_long(VM* vm, DynamicPtr ptr);
static inline int16_t LongPtr_sub(LongPtr lp1, LongPtr lp2);
static inline uint16_t readAllocationHeaderWord(void* pAllocation);
static inline uint16_t readAllocationHeaderWord_long(LongPtr pAllocation);
static inline void* gc_allocateWithConstantHeader(VM* vm, uint16_t header, uint16_t sizeIncludingHeader);
static inline uint16_t makeHeaderWord(VM* vm, TeTypeCode tc, uint16_t size);
static int memcmp_long(LongPtr p1, LongPtr p2, size_t size);
static LongPtr getBytecodeSection(VM* vm, mvm_TeBytecodeSection id, LongPtr* out_end);
static inline void* LongPtr_truncate(LongPtr lp);
static inline LongPtr LongPtr_new(void* p);
static inline uint16_t* getBottomOfStack(vm_TsStack* stack);
static inline uint16_t* getTopOfStackSpace(vm_TsStack* stack);
static inline void* getBucketDataBegin(TsBucket* bucket);
static uint16_t getBucketOffsetEnd(TsBucket* bucket);
static uint16_t getSectionSize(VM* vm, mvm_TeBytecodeSection section);
static Value vm_intToStr(VM* vm, int32_t i);
static Value vm_newStringFromCStrNT(VM* vm, const char* s);
static TeError vm_validatePortFileMacros(MVM_LONG_PTR_TYPE lpBytecode, mvm_TsBytecodeHeader* pHeader);
static LongPtr vm_toStringUtf8_long(VM* vm, Value value, size_t* out_sizeBytes);
static LongPtr vm_findScopedVariable(VM* vm, uint16_t index);
static Value vm_cloneFixedLengthArray(VM* vm, Value arr);

static const char PROTO_STR[] = "__proto__";
static const char LENGTH_STR[] = "length";

#define GC_ALLOCATE_TYPE(vm, type, typeCode) \
  (type*)gc_allocateWithConstantHeader(vm, makeHeaderWord(vm, typeCode, sizeof (type)), 2 + sizeof (type))

#if MVM_SUPPORT_FLOAT
static int32_t mvm_float64ToInt32(MVM_FLOAT64 value);
#endif

const Value mvm_undefined = VM_VALUE_UNDEFINED;
const Value vm_null = VM_VALUE_NULL;

static inline uint16_t getAllocationSize(void* pAllocation) {
  CODE_COVERAGE(12); // Hit
  return vm_getAllocationSizeExcludingHeaderFromHeaderWord(((uint16_t*)pAllocation)[-1]);
}


static inline uint16_t getAllocationSize_long(LongPtr lpAllocation) {
  CODE_COVERAGE_UNTESTED(514); // Not hit
  uint16_t headerWord = LongPtr_read2_aligned(LongPtr_add(lpAllocation, -2));
  return vm_getAllocationSizeExcludingHeaderFromHeaderWord(headerWord);
}

static inline mvm_TeBytecodeSection sectionAfter(VM* vm, mvm_TeBytecodeSection section) {
  CODE_COVERAGE(13); // Hit
  VM_ASSERT(vm, section < BCS_SECTION_COUNT - 1);
  return (mvm_TeBytecodeSection)((uint8_t)section + 1);
}

static inline TeTypeCode vm_getTypeCodeFromHeaderWord(uint16_t headerWord) {
  CODE_COVERAGE(1); // Hit
  // The type code is in the high byte because it's the byte that occurs closest
  // to the allocation itself, potentially allowing us in future to omit the
  // size in the allocation header for some kinds of allocations.
  return (TeTypeCode)(headerWord >> 12);
}

static inline uint16_t makeHeaderWord(VM* vm, TeTypeCode tc, uint16_t size) {
  CODE_COVERAGE(210); // Hit
  VM_ASSERT(vm, size <= MAX_ALLOCATION_SIZE);
  VM_ASSERT(vm, tc <= 0xF);
  return ((tc << 12) | size);
}

static inline VirtualInt14 VirtualInt14_encode(VM* vm, int16_t i) {
  CODE_COVERAGE(14); // Hit
  VM_ASSERT(vm, (i >= VM_MIN_INT14) && (i <= VM_MAX_INT14));
  return VIRTUAL_INT14_ENCODE(i);
}

static inline int16_t VirtualInt14_decode(VM* vm, VirtualInt14 viInt) {
  CODE_COVERAGE(16); // Hit
  VM_ASSERT(vm, Value_isVirtualInt14(viInt));
  return (int16_t)viInt >> 2;
}

static void setHeaderWord(VM* vm, void* pAllocation, TeTypeCode tc, uint16_t size) {
  CODE_COVERAGE(36); // Hit
  ((uint16_t*)pAllocation)[-1] = makeHeaderWord(vm, tc, size);
}

// Returns the allocation size, excluding the header itself
static inline uint16_t vm_getAllocationSizeExcludingHeaderFromHeaderWord(uint16_t headerWord) {
  CODE_COVERAGE(2); // Hit
  // Note: The header size is measured in bytes and not words mainly to account
  // for string allocations, which would be inconvenient to align to word
  // boundaries.
  return headerWord & 0xFFF;
}

#if MVM_SAFE_MODE
static bool Value_encodesBytecodeMappedPtr(Value value) {
  CODE_COVERAGE(37); // Hit
  return ((value & 3) == 1) && value >= VM_VALUE_WELLKNOWN_END;
}
#endif // MVM_SAFE_MODE

static inline uint16_t getSectionOffset(LongPtr lpBytecode, mvm_TeBytecodeSection section) {
  CODE_COVERAGE(38); // Hit
  LongPtr lpSection = LongPtr_add(lpBytecode, OFFSETOF(mvm_TsBytecodeHeader, sectionOffsets) + section * 2);
  uint16_t offset = LongPtr_read2_aligned(lpSection);
  return offset;
}

#if MVM_SAFE_MODE
static inline uint16_t vm_getResolvedImportCount(VM* vm) {
  CODE_COVERAGE(41); // Hit
  uint16_t importTableSize = getSectionSize(vm, BCS_IMPORT_TABLE);
  uint16_t importCount = importTableSize / sizeof(vm_TsImportTableEntry);
  return importCount;
}
#endif // MVM_SAFE_MODE

#if MVM_SAFE_MODE
/**
 * Returns true if the value is a pointer which points to ROM. Null is not a
 * value that points to ROM.
 */
static bool DynamicPtr_isRomPtr(VM* vm, DynamicPtr dp) {
  CODE_COVERAGE(39); // Hit
  VM_ASSERT(vm, !Value_isVirtualInt14(dp));

  if (dp == VM_VALUE_NULL) {
    CODE_COVERAGE_UNTESTED(47); // Not hit
    return false;
  }

  if (Value_isShortPtr(dp)) {
    CODE_COVERAGE_UNTESTED(52); // Not hit
    return false;
  }
  CODE_COVERAGE(91); // Hit

  VM_ASSERT(vm, Value_encodesBytecodeMappedPtr(dp));
  VM_ASSERT(vm, sectionAfter(vm, BCS_ROM) < BCS_SECTION_COUNT);

  uint16_t offset = dp >> 1;

  return (offset >= getSectionOffset(vm->lpBytecode, BCS_ROM))
    & (offset < getSectionOffset(vm->lpBytecode, sectionAfter(vm, BCS_ROM)));
}
#endif // MVM_SAFE_MODE

TeError mvm_restore(mvm_VM** result, LongPtr lpBytecode, size_t bytecodeSize_, void* context, mvm_TfResolveImport resolveImport) {
  // Note: these are declared here because some compilers give warnings when "goto" bypasses some variable declarations
  mvm_TfHostFunction* resolvedImports;
  uint16_t importTableOffset;
  LongPtr lpImportTableStart;
  LongPtr lpImportTableEnd;
  mvm_TfHostFunction* resolvedImport;
  LongPtr lpImportTableEntry;
  uint16_t initialHeapOffset;
  uint16_t initialHeapSize;

  CODE_COVERAGE(3); // Hit

  if (MVM_PORT_VERSION != MVM_EXPECTED_PORT_FILE_VERSION) {
    return MVM_E_PORT_FILE_VERSION_MISMATCH;
  }

  #if MVM_SAFE_MODE
    uint16_t x = 0x4243;
    bool isLittleEndian = ((uint8_t*)&x)[0] == 0x43;
    VM_ASSERT(NULL, isLittleEndian);
    VM_ASSERT(NULL, sizeof (ShortPtr) == 2);
  #endif

  TeError err = MVM_E_SUCCESS;
  VM* vm = NULL;

  // Bytecode size field is located at the second word
  if (bytecodeSize_ < sizeof (mvm_TsBytecodeHeader)) {
    CODE_COVERAGE_ERROR_PATH(21); // Not hit
    return MVM_E_INVALID_BYTECODE;
  }
  mvm_TsBytecodeHeader header;
  memcpy_long(&header, lpBytecode, sizeof header);

  // Note: the restore function takes an explicit bytecode size because there
  // may be a size inherent to the medium from which the bytecode image comes,
  // and we don't want to accidentally read past the end of this space just
  // because the header apparently told us we could (since we could be reading a
  // corrupt header).
  uint16_t bytecodeSize = header.bytecodeSize;
  if (bytecodeSize != bytecodeSize_) {
    CODE_COVERAGE_ERROR_PATH(240); // Not hit
    return MVM_E_INVALID_BYTECODE;
  }

  uint16_t expectedCRC = header.crc;
  if (!MVM_CHECK_CRC16_CCITT(LongPtr_add(lpBytecode, 8), (uint16_t)bytecodeSize - 8, expectedCRC)) {
    CODE_COVERAGE_ERROR_PATH(54); // Not hit
    return MVM_E_BYTECODE_CRC_FAIL;
  }

  if (bytecodeSize < header.headerSize) {
    CODE_COVERAGE_ERROR_PATH(241); // Not hit
    return MVM_E_INVALID_BYTECODE;
  }

  if (header.bytecodeVersion != MVM_BYTECODE_VERSION) {
    CODE_COVERAGE_ERROR_PATH(430); // Not hit
    return MVM_E_INVALID_BYTECODE;
  }

  if (MVM_ENGINE_VERSION < header.requiredEngineVersion) {
    CODE_COVERAGE_ERROR_PATH(247); // Not hit
    return MVM_E_REQUIRES_LATER_ENGINE;
  }

  uint32_t featureFlags = header.requiredFeatureFlags;;
  if (MVM_SUPPORT_FLOAT && !(featureFlags & (1 << FF_FLOAT_SUPPORT))) {
    CODE_COVERAGE_ERROR_PATH(180); // Not hit
    return MVM_E_BYTECODE_REQUIRES_FLOAT_SUPPORT;
  }

  err = vm_validatePortFileMacros(lpBytecode, &header);
  if (err) return err;

  uint16_t importTableSize = header.sectionOffsets[sectionAfter(vm, BCS_IMPORT_TABLE)] - header.sectionOffsets[BCS_IMPORT_TABLE];
  uint16_t importCount = importTableSize / sizeof (vm_TsImportTableEntry);

  uint16_t globalsSize = header.sectionOffsets[sectionAfter(vm, BCS_GLOBALS)] - header.sectionOffsets[BCS_GLOBALS];

  size_t allocationSize = sizeof(mvm_VM) +
    sizeof(mvm_TfHostFunction) * importCount +  // Import table
    globalsSize; // Globals
  vm = (VM*)malloc(allocationSize);
  if (!vm) {
    CODE_COVERAGE_ERROR_PATH(139); // Not hit
    err = MVM_E_MALLOC_FAIL;
    goto LBL_EXIT;
  }
  #if MVM_SAFE_MODE
    memset(vm, 0xCC, allocationSize);
  #endif
  memset(vm, 0, sizeof (mvm_VM));
  resolvedImports = vm_getResolvedImports(vm);
  vm->context = context;
  vm->lpBytecode = lpBytecode;
  vm->globals = (void*)(resolvedImports + importCount);

  importTableOffset = header.sectionOffsets[BCS_IMPORT_TABLE];
  lpImportTableStart = LongPtr_add(lpBytecode, importTableOffset);
  lpImportTableEnd = LongPtr_add(lpImportTableStart, importTableSize);
  // Resolve imports (linking)
  resolvedImport = resolvedImports;
  lpImportTableEntry = lpImportTableStart;
  while (lpImportTableEntry < lpImportTableEnd) {
    CODE_COVERAGE(431); // Hit
    mvm_HostFunctionID hostFunctionID = READ_FIELD_2(lpImportTableEntry, vm_TsImportTableEntry, hostFunctionID);
    lpImportTableEntry = LongPtr_add(lpImportTableEntry, sizeof (vm_TsImportTableEntry));
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
  memcpy_long(vm->globals, getBytecodeSection(vm, BCS_GLOBALS, NULL), globalsSize);

  // Initialize heap
  initialHeapOffset = header.sectionOffsets[BCS_HEAP];
  initialHeapSize = bytecodeSize - initialHeapOffset;
  vm->heapSizeUsedAfterLastGC = initialHeapSize;
  vm->heapHighWaterMark = initialHeapSize;

  if (initialHeapSize) {
    CODE_COVERAGE(435); // Hit
    gc_createNextBucket(vm, initialHeapSize, initialHeapSize);
    VM_ASSERT(vm, !vm->pLastBucket->prev); // Only one bucket
    uint16_t* heapStart = getBucketDataBegin(vm->pLastBucket);
    memcpy_long(heapStart, LongPtr_add(lpBytecode, initialHeapOffset), initialHeapSize);
    vm->pLastBucket->pEndOfUsedSpace = (uint16_t*)((intptr_t)vm->pLastBucket->pEndOfUsedSpace + initialHeapSize);

    // The running VM assumes the invariant that all pointers to the heap are
    // represented as ShortPtr (and no others). We only need to call
    // `loadPointers` if there is an initial heap at all, otherwise there
    // will be no pointers to it.
    loadPointers(vm, heapStart);
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
 * More precisely, it translates ShortPtr from their offset form to their native
 * pointer form.
 */
static void loadPtr(VM* vm, uint8_t* heapStart, Value* pValue) {
  CODE_COVERAGE(140); // Hit
  Value value = *pValue;

  // We're only translating short pointers
  if (!Value_isShortPtr(value)) {
    CODE_COVERAGE(144); // Hit
    return;
  }
  CODE_COVERAGE(167); // Hit

  uint16_t offset = value;

  uint8_t* p = heapStart + offset;

  *pValue = ShortPtr_encode(vm, p);
}

static inline uint16_t getBytecodeSize(VM* vm) {
  CODE_COVERAGE_UNTESTED(168); // Not hit
  LongPtr lpBytecodeSize = LongPtr_add(vm->lpBytecode, OFFSETOF(mvm_TsBytecodeHeader, bytecodeSize));
  return LongPtr_read2_aligned(lpBytecodeSize);
}

static LongPtr getBytecodeSection(VM* vm, mvm_TeBytecodeSection id, LongPtr* out_end) {
  CODE_COVERAGE(170); // Hit
  LongPtr lpBytecode = vm->lpBytecode;
  LongPtr lpSections = LongPtr_add(lpBytecode, OFFSETOF(mvm_TsBytecodeHeader, sectionOffsets));
  LongPtr lpSection = LongPtr_add(lpSections, id * 2);
  uint16_t offset = LongPtr_read2_aligned(lpSection);
  LongPtr result = LongPtr_add(lpBytecode, offset);
  if (out_end) {
    CODE_COVERAGE(171); // Hit
    uint16_t endOffset;
    if (id == BCS_SECTION_COUNT - 1) {
      endOffset = getBytecodeSize(vm);
    } else {
      LongPtr lpNextSection = LongPtr_add(lpSection, 2);
      endOffset = LongPtr_read2_aligned(lpNextSection);
    }
    *out_end = LongPtr_add(lpBytecode, endOffset);
  } else {
    CODE_COVERAGE(172); // Hit
  }
  return result;
}

static uint16_t getSectionSize(VM* vm, mvm_TeBytecodeSection section) {
  CODE_COVERAGE(174); // Hit
  uint16_t sectionStart = getSectionOffset(vm->lpBytecode, section);
  uint16_t sectionEnd;
  if (section == BCS_SECTION_COUNT - 1) {
    CODE_COVERAGE_UNTESTED(175); // Not hit
    sectionEnd = getBytecodeSize(vm);
  } else {
    CODE_COVERAGE(177); // Hit
    VM_ASSERT(vm, section < BCS_SECTION_COUNT);
    sectionEnd = getSectionOffset(vm->lpBytecode, sectionAfter(vm, section));
  }
  VM_ASSERT(vm, sectionEnd >= sectionStart);
  return sectionEnd - sectionStart;
}

/**
 * Called at startup to translate all the pointers that point to GC memory into
 * ShortPtr for efficiency and to maintain invariants assumed in other places in
 * the code.
 */
static void loadPointers(VM* vm, void* heapStart) {
  CODE_COVERAGE(178); // Hit
  uint16_t n;
  uint16_t* p;

  // Roots in global variables
  uint16_t globalsSize = getSectionSize(vm, BCS_GLOBALS);
  p = vm->globals;
  n = globalsSize / 2;
  TABLE_COVERAGE(n ? 1 : 0, 2, 179); // Hit 1/2
  while (n--) {
    loadPtr(vm, heapStart, p++);
  }

  // Pointers in heap memory
  p = (uint16_t*)heapStart;
  VM_ASSERT(vm, vm->pLastBucketEndCapacity == vm->pLastBucket->pEndOfUsedSpace);
  uint16_t* heapEnd = vm->pLastBucketEndCapacity;
  while (p < heapEnd) {
    CODE_COVERAGE(181); // Hit
    uint16_t header = *p++;
    uint16_t size = vm_getAllocationSizeExcludingHeaderFromHeaderWord(header);
    uint16_t words = (size + 1) / 2;
    TeTypeCode tc = vm_getTypeCodeFromHeaderWord(header);

    if (tc < TC_REF_DIVIDER_CONTAINER_TYPES) { // Non-container types
      CODE_COVERAGE_UNTESTED(182); // Not hit
      p += words;
      continue;
    } // Else, container types
    CODE_COVERAGE(183); // Hit

    while (words--) {
      if (Value_isShortPtr(*p))
        loadPtr(vm, heapStart, p);
      p++;
    }
  }
}

void* mvm_getContext(VM* vm) {
  return vm->context;
}

static const Value smallLiterals[] = {
  /* VM_SLV_UNDEFINED */    VM_VALUE_DELETED,
  /* VM_SLV_UNDEFINED */    VM_VALUE_UNDEFINED,
  /* VM_SLV_NULL */         VM_VALUE_NULL,
  /* VM_SLV_FALSE */        VM_VALUE_FALSE,
  /* VM_SLV_TRUE */         VM_VALUE_TRUE,
  /* VM_SLV_INT_MINUS_1 */  VIRTUAL_INT14_ENCODE(-1),
  /* VM_SLV_INT_0 */        VIRTUAL_INT14_ENCODE(0),
  /* VM_SLV_INT_1 */        VIRTUAL_INT14_ENCODE(1),
  /* VM_SLV_INT_2 */        VIRTUAL_INT14_ENCODE(2),
  /* VM_SLV_INT_3 */        VIRTUAL_INT14_ENCODE(3),
  /* VM_SLV_INT_4 */        VIRTUAL_INT14_ENCODE(4),
  /* VM_SLV_INT_5 */        VIRTUAL_INT14_ENCODE(5),
};
#define smallLiteralsSize (sizeof smallLiterals / sizeof smallLiterals[0])

/**
 * Public API to call into the VM to run the given function with the given
 * arguments (also contains the run loop).
 *
 * Control returns from `mvm_call` either when it hits an error or when it
 * executes a RETURN instruction within the called function.
 */
TeError mvm_call(VM* vm, Value targetFunc, Value* out_result, Value* args, uint8_t argCount) {

  // -------------------------------- Definitions -----------------------------

  #define CACHE_REGISTERS() do { \
    lpProgramCounter = reg->lpProgramCounter; \
    pFrameBase = reg->pFrameBase; \
    pStackPointer = reg->pStackPointer; \
  } while (false)

  #define FLUSH_REGISTER_CACHE() do { \
    reg->lpProgramCounter = lpProgramCounter; \
    reg->pFrameBase = pFrameBase; \
    reg->pStackPointer = pStackPointer; \
  } while (false)

  #define READ_PGM_1(target) do { \
    target = LongPtr_read1(lpProgramCounter);\
    lpProgramCounter = LongPtr_add(lpProgramCounter, 1); \
  } while (false)

  #define READ_PGM_2(target) do { \
    target = LongPtr_read2_unaligned(lpProgramCounter); \
    lpProgramCounter = LongPtr_add(lpProgramCounter, 2); \
  } while (false)

  // Push the current registers onto the call stack
  #define PUSH_REGISTERS() do { \
    VM_ASSERT(vm, VM_FRAME_BOUNDARY_VERSION == 2); \
    PUSH((uint16_t)pStackPointer - (uint16_t)pFrameBase); \
    PUSH(reg->scope); \
    PUSH(reg->argCountAndFlags); \
    PUSH((uint16_t)LongPtr_sub(lpProgramCounter, vm->lpBytecode)); \
  } while (false)

  // Inverse of PUSH_REGISTERS
  #define POP_REGISTERS() do { \
    VM_ASSERT(vm, VM_FRAME_BOUNDARY_VERSION == 2); \
    lpProgramCounter = LongPtr_add(vm->lpBytecode, POP()); \
    reg->argCountAndFlags = POP(); \
    reg->scope = POP(); \
    pStackPointer--; \
    pFrameBase = (uint16_t*)((uint8_t*)pStackPointer - *pStackPointer); \
    reg->pArgs = pFrameBase - VM_FRAME_BOUNDARY_SAVE_SIZE_WORDS - (uint8_t)reg->argCountAndFlags; \
  } while (false)

  // Reinterpret reg1 as 8-bit signed
  #define SIGN_EXTEND_REG_1() reg1 = (uint16_t)((int16_t)((int8_t)reg1))

  #define PUSH(v) *(pStackPointer++) = (v)
  #define POP() (*(--pStackPointer))
  #define INSTRUCTION_RESERVED() VM_ASSERT(vm, false)

  // ------------------------------ Common Variables --------------------------

  VM_SAFE_CHECK_NOT_NULL(vm);
  if (argCount) VM_SAFE_CHECK_NOT_NULL(args);

  TeError err = MVM_E_SUCCESS;

  // These are cached values of `vm->stack->reg`, for quick access. Note: I've
  // chosen only the most important registers to be cached here, in the hope
  // that the C compiler will promote these eagerly to the CPU registers,
  // although it may choose not to.
  register uint16_t* pFrameBase;
  register uint16_t* pStackPointer;
  register LongPtr lpProgramCounter;

  // These are general-purpose scratch "registers". Note: probably the compiler
  // would be fine at performing register allocation if we didn't have specific
  // register variables, but having them explicit forces us to think about what
  // state is being used and designing the code to minimize it.
  register uint16_t reg1;
  register uint16_t reg2;
  register uint16_t reg3;

  uint16_t* globals;
  vm_TsRegisters* reg;

  #if MVM_DONT_TRUST_BYTECODE
    LongPtr maxProgramCounter;
    LongPtr minProgramCounter = getBytecodeSection(vm, BCS_ROM, &maxProgramCounter);
  #endif

  #if MVM_SAFE_MODE
    pFrameBase = 0;
    pStackPointer = 0;
    lpProgramCounter = 0;
    reg1 = 0;
    reg2 = 0;
    reg3 = 0;
  #endif

  // ------------------------------ Initialization ---------------------------

  CODE_COVERAGE(4); // Hit

  // Create the call stack if it doesn't exist
  if (!vm->stack) {
    CODE_COVERAGE(230); // Hit
    err = vm_createStackAndRegisters(vm);
    if (err != MVM_E_SUCCESS) {
      goto LBL_EXIT;
    }
  } else {
    CODE_COVERAGE_UNTESTED(232); // Not hit
  }

  globals = vm->globals;
  reg = &vm->stack->reg;

  // Copy the state of the VM registers into the logical variables for quick access
  CACHE_REGISTERS();

  // ---------------------- Push host arguments to the stack ------------------

  // 254 is the maximum because we also push the `this` value implicitly
  if (argCount > 254) {
    CODE_COVERAGE(15); // Hit
    return MVM_E_TOO_MANY_ARGUMENTS;
  } else {
    CODE_COVERAGE_ERROR_PATH(220); // Hit
  }

  vm_requireStackSpace(vm, pStackPointer, argCount + 1 + VM_FRAME_BOUNDARY_SAVE_SIZE_WORDS);
  PUSH(VM_VALUE_UNDEFINED); // Push `this` pointer of undefined
  TABLE_COVERAGE(argCount ? 1 : 0, 2, 513); // Hit 1/2
  reg1 = argCount;
  while (reg1--) {
    PUSH(*args++);
  }

  // ---------------------------- Call target function ------------------------

  reg1 /* argCountAndFlags */ = (argCount + 1) | AF_CALLED_FROM_HOST; // +1 for the `this` value
  reg2 /* target */ = targetFunc;
  goto LBL_CALL;

  // --------------------------------- Run Loop ------------------------------

  // This forms the start of the run loop
  //
  // Some useful debug watches:
  //
  //   - Program counter: /* pc */ (uint8_t*)lpProgramCounter - (uint8_t*)vm->lpBytecode
  //                      /* pc */ (uint8_t*)vm->stack->reg.lpProgramCounter - (uint8_t*)vm->lpBytecode
  //
  //   - Stack height (in words): /* sp */ (uint16_t*)pStackPointer - (uint16_t*)(vm->stack + 1)
  //                              /* sp */ (uint16_t*)vm->stack->reg.pStackPointer - (uint16_t*)(vm->stack + 1)
  //
  //   - Frame base (in words): /* bp */ (uint16_t*)pFrameBase - (uint16_t*)(vm->stack + 1)
  //                            /* bp */ (uint16_t*)vm->stack->reg.pFrameBase - (uint16_t*)(vm->stack + 1)
  //
  //   - Arg count:             /* argc */ (uint8_t)vm->stack->reg.argCountAndFlags
  //   - First 4 arg values:    /* args */ vm->stack->reg.pArgs,4
  //
  // Notes:
  //
  //   - The value of VM_VALUE_UNDEFINED is 0x001
  //   - If a value is _odd_, interpret it as a bytecode address by dividing by 2
  //

LBL_DO_NEXT_INSTRUCTION:
  CODE_COVERAGE(59); // Hit

  // This is not required for execution but is intended for diagnostics,
  // required by mvm_getCurrentAddress.
  reg->lpProgramCounter = lpProgramCounter;

  // Check we're within range
  #if MVM_DONT_TRUST_BYTECODE
  if ((lpProgramCounter < minProgramCounter) || (lpProgramCounter >= maxProgramCounter)) {
    VM_INVALID_BYTECODE(vm);
  }
  #endif

  // Check breakpoints
  #if MVM_INCLUDE_DEBUG_CAPABILITY
    if (vm->pBreakpoints) {
      TsBreakpoint* pBreakpoint = vm->pBreakpoints;
      uint16_t currentBytecodeAddress = LongPtr_sub(lpProgramCounter, vm->lpBytecode);
      do {
        if (pBreakpoint->bytecodeAddress == currentBytecodeAddress) {
          FLUSH_REGISTER_CACHE();
          mvm_TfBreakpointCallback breakpointCallback = vm->breakpointCallback;
          if (breakpointCallback)
            breakpointCallback(vm, currentBytecodeAddress);
          CACHE_REGISTERS();
          break;
        }
        pBreakpoint = pBreakpoint->next;
      } while (pBreakpoint);
    }
  #endif // MVM_INCLUDE_DEBUG_CAPABILITY

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
      TABLE_COVERAGE(reg1, smallLiteralsSize, 448); // Hit 11/12

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
      CODE_COVERAGE(61); // Hit
    LBL_OP_LOAD_VAR:
      reg1 = pStackPointer[-reg1 - 1];
      if (reg1 == VM_VALUE_DELETED) {
        err = MVM_E_TDZ_ERROR;
        goto LBL_EXIT;
      }
      goto LBL_TAIL_PUSH_REG1;

/* ------------------------------------------------------------------------- */
/*                            VM_OP_LOAD_SCOPED_1                            */
/*   Expects:                                                                */
/*     reg1: variable index                                                  */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP_LOAD_SCOPED_1):
      CODE_COVERAGE(62); // Hit
      LongPtr lpVar;
    LBL_OP_LOAD_SCOPED:
      lpVar = vm_findScopedVariable(vm, reg1);
      reg1 = LongPtr_read2_aligned(lpVar);
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
      goto LBL_CALL_SHORT;
    }

/* ------------------------------------------------------------------------- */
/*                               VM_OP_FIXED_ARRAY_NEW_1                     */
/*   Expects:                                                                */
/*     reg1: length of new fixed-length-array                                */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP_FIXED_ARRAY_NEW_1): {
      CODE_COVERAGE_UNTESTED(134); // Not hit
      goto LBL_FIXED_ARRAY_NEW;
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
/*                                VM_OP_CALL_5                               */
/*   Expects:                                                                */
/*     reg1: argCount                                                        */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP_CALL_5): {
      CODE_COVERAGE_UNTESTED(72); // Not hit
      // Uses 16 bit literal for function offset
      READ_PGM_2(reg2);
      reg3 /* scope */ = VM_VALUE_UNDEFINED;
      goto LBL_CALL_BYTECODE_FUNC;
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
/*                           VM_OP_STORE_SCOPED_1                            */
/*   Expects:                                                                */
/*     reg1: variable index                                                  */
/*     reg2: value to store                                                  */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP_STORE_SCOPED_1): {
      CODE_COVERAGE(74); // Hit
      LongPtr lpVar;
    LBL_OP_STORE_SCOPED:
      lpVar = vm_findScopedVariable(vm, reg1);
      Value* pVar = (Value*)LongPtr_truncate(lpVar);
      // It would be an illegal operation to write to a closure variable stored in ROM
      VM_BYTECODE_ASSERT(vm, lpVar == LongPtr_new(pVar));
      *pVar = reg2;
      goto LBL_DO_NEXT_INSTRUCTION;
    }

/* ------------------------------------------------------------------------- */
/*                            VM_OP_ARRAY_GET_1                              */
/*   Expects:                                                                */
/*     reg1: item index (4-bit)                                             */
/*     reg2: reference to array                                              */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP_ARRAY_GET_1): {
      CODE_COVERAGE_UNTESTED(75); // Not hit
      Value propValue;
      Value propName = VirtualInt14_encode(vm, reg1);
      err = getProperty(vm, reg2, propName, &propValue);
      reg1 = propValue;
      if (err != MVM_E_SUCCESS) goto LBL_EXIT;
      goto LBL_TAIL_PUSH_REG1;
    }

/* ------------------------------------------------------------------------- */
/*                            VM_OP_ARRAY_SET_1                              */
/*   Expects:                                                                */
/*     reg1: item index (4-bit)                                              */
/*     reg2: value to store                                                  */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP_ARRAY_SET_1): {
      CODE_COVERAGE_UNTESTED(76); // Not hit
      reg3 = POP(); // array/object reference
      Value propName = VirtualInt14_encode(vm, reg1);
      err = setProperty(vm, reg3, propName, reg2);
      if (err != MVM_E_SUCCESS) {
        CODE_COVERAGE_UNTESTED(125); // Not hit
        goto LBL_EXIT;
      } else {
        CODE_COVERAGE_UNTESTED(126); // Not hit
      }
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
/*                             LBL_OP_LOAD_ARG                               */
/*   Expects:                                                                */
/*     reg1: argument index                                                  */
/* ------------------------------------------------------------------------- */
LBL_OP_LOAD_ARG: {
  CODE_COVERAGE(32); // Hit
  reg2 /* argCountAndFlags */ = reg->argCountAndFlags;
  if (reg1 /* argIndex */ < (uint8_t)reg2 /* argCount */) {
    CODE_COVERAGE(64); // Hit
    reg1 /* result */ = reg->pArgs[reg1 /* argIndex */];
  } else {
    CODE_COVERAGE_UNTESTED(65); // Not hit
    reg1 = VM_VALUE_UNDEFINED;
  }
  goto LBL_TAIL_PUSH_REG1;
}

/* ------------------------------------------------------------------------- */
/*                               LBL_CALL_SHORT                               */
/*   Expects:                                                                */
/*     reg1: index into short-call table                                     */
/* ------------------------------------------------------------------------- */

LBL_CALL_SHORT: {
  CODE_COVERAGE_UNTESTED(173); // Not hit
  LongPtr lpShortCallTable = getBytecodeSection(vm, BCS_SHORT_CALL_TABLE, NULL);
  LongPtr lpShortCallTableEntry = LongPtr_add(lpShortCallTable, reg1 * sizeof (vm_TsShortCallTableEntry));

  #if MVM_SAFE_MODE
    LongPtr lpShortCallTableEnd;
    getBytecodeSection(vm, BCS_SHORT_CALL_TABLE, &lpShortCallTableEnd);
    VM_ASSERT(vm, lpShortCallTableEntry < lpShortCallTableEnd);
  #endif

  reg2 /* target */ = LongPtr_read2_aligned(lpShortCallTableEntry);
  lpShortCallTableEntry = LongPtr_add(lpShortCallTableEntry, 2);

  // Note: reg1 holds the new argCountAndFlags, but the flags are zero in this situation
  reg1 /* argCountAndFlags */ = LongPtr_read1(lpShortCallTableEntry);

  reg3 /* scope */ = VM_VALUE_UNDEFINED;

  // The high bit of function indicates if this is a call to the host
  bool isHostCall = reg2 & 1;

  if (isHostCall) {
    CODE_COVERAGE_UNTESTED(67); // Not hit
    goto LBL_CALL_HOST_COMMON;
  } else {
    CODE_COVERAGE_UNTESTED(68); // Not hit
    reg2 >>= 1;
    goto LBL_CALL_BYTECODE_FUNC;
  }
} // LBL_CALL_SHORT

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

    MVM_CASE_CONTIGUOUS (VM_OP1_RETURN): {
      CODE_COVERAGE(107); // Hit
      reg1 = POP();
      goto LBL_RETURN;
    }

    MVM_CASE_CONTIGUOUS (VM_OP1_RETURN_UNDEFINED): {
      CODE_COVERAGE_UNTESTED(106); // Not hit
      reg1 = VM_VALUE_UNDEFINED;
      goto LBL_RETURN;
    }

/* ------------------------------------------------------------------------- */
/*                                 VM_OP1_CLOSURE_NEW                        */
/*   Expects:                                                                */
/*     reg3: vm_TeOpcodeEx1                                                  */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP1_CLOSURE_NEW): {
      CODE_COVERAGE(599); // Hit

      TsClosure* pClosure = gc_allocateWithHeader(vm, sizeof (TsClosure), TC_REF_CLOSURE);
      pClosure->scope = reg->scope; // Capture the current scope
      pClosure->target = POP();

      reg1 = ShortPtr_encode(vm, pClosure);
      goto LBL_TAIL_PUSH_REG1;
    }

/* ------------------------------------------------------------------------- */
/*                          VM_OP1_RESERVED_CLASS_NEW                        */
/*   Expects:                                                                */
/*     Nothing                                                               */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP1_RESERVED_CLASS_NEW): {
      CODE_COVERAGE_UNTESTED(347); // Not hit

      return VM_NOT_IMPLEMENTED(vm);
    }

/* ------------------------------------------------------------------------- */
/*                                 VM_OP1_SCOPE_PUSH                         */
/*   Expects:                                                                */
/*     Nothing                                                               */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP1_SCOPE_PUSH): {
      CODE_COVERAGE(605); // Hit
      READ_PGM_1(reg1); // Scope variable count
      reg2 = (reg1 + 1) * 2; // Scope array size, including 1 slot for parent reference
      uint16_t* newScope = gc_allocateWithHeader(vm, reg2, TC_REF_FIXED_LENGTH_ARRAY);
      uint16_t* p = newScope;
      *p++ = reg->scope; // Reference to parent
      while (reg1--)
        *p++ = VM_VALUE_UNDEFINED; // Initial variable values
      // Add to the scope chain
      reg->scope = ShortPtr_encode(vm, newScope);
      goto LBL_DO_NEXT_INSTRUCTION;
    }

/* ------------------------------------------------------------------------- */
/*                              VM_OP1_LOAD_ARG_COUNT                        */
/*   Expects:                                                                */
/*     Nothing                                                               */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP1_LOAD_ARG_COUNT): {
      CODE_COVERAGE_UNTESTED(607); // Not hit
      reg1 = reg->argCountAndFlags & 0xFF;
      goto LBL_TAIL_PUSH_REG1;
    }

/* ------------------------------------------------------------------------- */
/*                              VM_OP1_POP                                   */
/*   Expects:                                                                */
/*     Nothing                                                               */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP1_POP): {
      CODE_COVERAGE(138); // Hit
      pStackPointer--;
      goto LBL_DO_NEXT_INSTRUCTION;
    }

/* ------------------------------------------------------------------------- */
/*                              VM_OP1_OBJECT_NEW                            */
/*   Expects:                                                                */
/*     (nothing)                                                             */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP1_OBJECT_NEW): {
      CODE_COVERAGE(112); // Hit
      TsPropertyList* pObject = GC_ALLOCATE_TYPE(vm, TsPropertyList, TC_REF_PROPERTY_LIST);
      reg1 = ShortPtr_encode(vm, pObject);
      pObject->dpNext = VM_VALUE_NULL;
      pObject->dpProto = VM_VALUE_NULL;
      goto LBL_TAIL_PUSH_REG1;
    }

/* ------------------------------------------------------------------------- */
/*                               VM_OP1_LOGICAL_NOT                          */
/*   Expects:                                                                */
/*     (nothing)                                                             */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP1_LOGICAL_NOT): {
      CODE_COVERAGE(113); // Hit
      reg2 = POP(); // value to negate
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
      if (Value_isVirtualUInt12(reg1) && Value_isVirtualUInt12(reg2)) {
        CODE_COVERAGE(116); // Hit
        reg1 = reg1 + reg2 - VirtualInt14_encode(vm, 0);
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
      CODE_COVERAGE(122); // Hit
      if (mvm_equal(vm, reg1, reg2)) {
        CODE_COVERAGE(483); // Hit
        reg1 = VM_VALUE_TRUE;
      } else {
        CODE_COVERAGE(484); // Hit
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
        CODE_COVERAGE(123); // Hit
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
        CODE_COVERAGE_UNTESTED(265); // Not hit
        goto LBL_EXIT;
      } else {
        CODE_COVERAGE(322); // Hit
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

  // Convert second operand to a int32 (or the only operand if it's a unary op)
  if (toInt32Internal(vm, reg2, &reg2I) != MVM_E_SUCCESS) {
    CODE_COVERAGE(442); // Hit
    // If we failed to convert to int32, then we need to process the operation as a float
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
/*                             VM_OP2_BRANCH_1                               */
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
/*                             VM_OP2_STORE_ARG                              */
/*   Expects:                                                                */
/*     reg1: unsigned index of argument in which to store                    */
/*     reg2: value to store                                                  */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP2_STORE_ARG): {
      CODE_COVERAGE_UNTESTED(131); // Not hit
      #if MVM_DONT_TRUST_BYTECODE
        // The ability to write to argument slots is intended as an optimization
        // feature to elide the parameter variable slots and instead use the
        // argument slots directly. But this only works if the optimizer can
        // prove that unprovided parameters are never written to (or that all
        // parameters are satisfied by arguments). If you don't trust the
        // optimizer, it's possible the callee attempts to write to the
        // caller-provided argument slots that don't exist.
        if (reg1 >= (uint8_t)reg->argCountAndFlags) {
          err = MVM_E_INVALID_BYTECODE;
          goto LBL_EXIT;
        }
      #endif
      reg->pArgs[reg1] = reg2;
      goto LBL_DO_NEXT_INSTRUCTION;
    }

/* ------------------------------------------------------------------------- */
/*                             VM_OP2_STORE_SCOPED_2                         */
/*   Expects:                                                                */
/*     reg1: unsigned index of global in which to store                      */
/*     reg2: value to store                                                  */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP2_STORE_SCOPED_2): {
      CODE_COVERAGE_UNTESTED(132); // Not hit
      goto LBL_OP_STORE_SCOPED;
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
/*                             VM_OP2_JUMP_1                                 */
/*   Expects:                                                                */
/*     reg1: signed 8-bit offset to branch to, encoded in 16-bit unsigned    */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP2_JUMP_1): {
      CODE_COVERAGE(136); // Hit
      SIGN_EXTEND_REG_1();
      goto LBL_JUMP_COMMON;
    }

/* ------------------------------------------------------------------------- */
/*                             VM_OP2_CALL_HOST                              */
/*   Expects:                                                                */
/*     reg1: arg count                                                       */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP2_CALL_HOST): {
      CODE_COVERAGE_UNTESTED(137); // Not hit
      // Put function index into reg2
      READ_PGM_1(reg2);
      // Note: reg1 is the argCount and also argCountAndFlags, because the flags
      // are all zero in this case. In particular, the target is specified as an
      // instruction literal, so `AF_PUSHED_FUNCTION` is false.
      goto LBL_CALL_HOST_COMMON;
    }

/* ------------------------------------------------------------------------- */
/*                             VM_OP2_CALL_3                                */
/*   Expects:                                                                */
/*     reg1: arg count                                                       */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP2_CALL_3): {
      CODE_COVERAGE(142); // Hit

      reg1 /* argCountAndFlags */ |= AF_PUSHED_FUNCTION;
      reg2 /* target */ = pStackPointer[-(int16_t)(uint8_t)reg1 - 1]; // The function was pushed before the arguments

      goto LBL_CALL;
    }


/* ------------------------------------------------------------------------- */
/*                             VM_OP2_CALL_6                              */
/*   Expects:                                                                */
/*     reg1: index into shortcall table                                      */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP2_CALL_6): {
      CODE_COVERAGE_UNTESTED(145); // Not hit
      goto LBL_CALL_SHORT;
    }

/* ------------------------------------------------------------------------- */
/*                             VM_OP2_LOAD_SCOPED_2                          */
/*   Expects:                                                                */
/*     reg1: unsigned closure scoped variable index                          */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP2_LOAD_SCOPED_2): {
      CODE_COVERAGE_UNTESTED(146); // Not hit
      goto LBL_OP_LOAD_SCOPED;
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
      TsArray* arr = GC_ALLOCATE_TYPE(vm, TsArray, TC_REF_ARRAY);
      reg1 = ShortPtr_encode(vm, arr);

      arr->viLength = VirtualInt14_encode(vm, 0);
      arr->dpData = VM_VALUE_NULL;

      if (capacity) {
        uint16_t* pData = gc_allocateWithHeader(vm, capacity * 2, TC_REF_FIXED_LENGTH_ARRAY);
        arr->dpData = ShortPtr_encode(vm, pData);
        uint16_t* p = pData;
        uint16_t n = capacity;
        while (n--)
          *p++ = VM_VALUE_DELETED;
      }

      goto LBL_TAIL_PUSH_REG1;
    }

/* ------------------------------------------------------------------------- */
/*                               VM_OP1_FIXED_ARRAY_NEW_2                    */
/*   Expects:                                                                */
/*     reg1: Fixed-array length (8-bit)                                      */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP2_FIXED_ARRAY_NEW_2): {
      CODE_COVERAGE_UNTESTED(135); // Not hit
      goto LBL_FIXED_ARRAY_NEW;
    }

  } // End of vm_TeOpcodeEx2 switch

  // All cases should jump to whatever tail they intend. Nothing should get here
  VM_ASSERT_UNREACHABLE(vm);

} // End of LBL_OP_EXTENDED_2


/* ------------------------------------------------------------------------- */
/*                             LBL_FIXED_ARRAY_NEW                           */
/*   Expects:                                                                */
/*     reg1: length of fixed-array to create                                 */
/* ------------------------------------------------------------------------- */

LBL_FIXED_ARRAY_NEW: {
  uint16_t* arr = gc_allocateWithHeader(vm, reg1 * 2, TC_REF_FIXED_LENGTH_ARRAY);
  uint16_t* p = arr;
  // Note: when reading a DELETED value from the array, it will read as
  // `undefined`. When fixed-length arrays are used to hold closure values, the
  // `DELETED` value can be used to represent the TDZ.
  while (reg1--)
    *p++ = VM_VALUE_DELETED;
  reg1 = ShortPtr_encode(vm, arr);
  goto LBL_TAIL_PUSH_REG1;
}

/* ------------------------------------------------------------------------- */
/*                             LBL_OP_EXTENDED_3                             */
/*   Expects:                                                                */
/*     reg1: vm_TeOpcodeEx3                                                  */
/* ------------------------------------------------------------------------- */

LBL_OP_EXTENDED_3: {
  CODE_COVERAGE(150); // Hit
  reg3 = reg1;

  // Most Ex-3 instructions have a 16-bit parameter
  if (reg3 >= VM_OP3_DIVIDER_1) {
    CODE_COVERAGE(603); // Hit
    READ_PGM_2(reg1);
  } else {
    CODE_COVERAGE(606); // Hit
  }

  if (reg3 >= VM_OP3_DIVIDER_2) {
    CODE_COVERAGE(151); // Hit
    reg2 = POP();
  } else {
    CODE_COVERAGE(152); // Hit
  }

  VM_ASSERT(vm, reg3 < VM_OP3_END);
  MVM_SWITCH_CONTIGUOUS (reg3, (VM_OP3_END - 1)) {

/* ------------------------------------------------------------------------- */
/*                             VM_OP3_POP_N                                  */
/*   Expects:                                                                */
/*     Nothing                                                               */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP3_POP_N): {
      CODE_COVERAGE(602); // Hit
      READ_PGM_1(reg1);
      while (reg1--)
        (void)POP();
      goto LBL_DO_NEXT_INSTRUCTION;
    }

/* -------------------------------------------------------------------------*/
/*                             VM_OP3_SCOPE_POP                             */
/*   Pops the top closure scope off the scope stack                         */
/*                                                                          */
/*   Expects:                                                               */
/*     Nothing                                                              */
/* -------------------------------------------------------------------------*/

    MVM_CASE_CONTIGUOUS (VM_OP3_SCOPE_POP): {
      CODE_COVERAGE(634); // Hit
      reg1 = reg->scope;
      VM_ASSERT(vm, reg1 != VM_VALUE_UNDEFINED);
      LongPtr lpArr = DynamicPtr_decode_long(vm, reg1);
      #if MVM_SAFE_MODE
        uint16_t headerWord = readAllocationHeaderWord_long(lpArr);
        VM_ASSERT(vm, vm_getTypeCodeFromHeaderWord(headerWord) == TC_REF_FIXED_LENGTH_ARRAY);
        uint16_t arrayLength = vm_getAllocationSizeExcludingHeaderFromHeaderWord(headerWord) / 2;
        VM_ASSERT(vm, arrayLength >= 1);
      #endif
      reg1 = LongPtr_read2_aligned(lpArr);
      reg->scope = reg1;
      goto LBL_DO_NEXT_INSTRUCTION;
    }

/* ------------------------------------------------------------------------- */
/*                             VM_OP3_SCOPE_CLONE                            */
/*                                                                           */
/*   Clones the top closure scope (which must exist) and sets it as the      */
/*   new scope                                                               */
/*                                                                           */
/*   Expects:                                                                */
/*     Nothing                                                               */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP3_SCOPE_CLONE): {
      CODE_COVERAGE(635); // Hit

      Value oldScope = reg->scope;
      VM_ASSERT(vm, oldScope != VM_VALUE_UNDEFINED);
      Value newScope = vm_cloneFixedLengthArray(vm, oldScope);
      reg->scope = newScope;

      goto LBL_DO_NEXT_INSTRUCTION;
    }

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
      CODE_COVERAGE(155); // Hit
      reg1 = globals[reg1];
      goto LBL_TAIL_PUSH_REG1;
    }

/* ------------------------------------------------------------------------- */
/*                             VM_OP3_LOAD_SCOPED_3                          */
/*   Expects:                                                                */
/*     reg1: scoped variable index                                           */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP3_LOAD_SCOPED_3): {
      CODE_COVERAGE_UNTESTED(600); // Not hit
      goto LBL_OP_LOAD_SCOPED;
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
      CODE_COVERAGE(157); // Hit
      globals[reg1] = reg2;
      goto LBL_DO_NEXT_INSTRUCTION;
    }

/* ------------------------------------------------------------------------- */
/*                             VM_OP3_STORE_SCOPED_3                         */
/*   Expects:                                                                */
/*     reg1: scoped variable index                                           */
/*     reg2: value to store                                                  */
/* ------------------------------------------------------------------------- */

    MVM_CASE_CONTIGUOUS (VM_OP3_STORE_SCOPED_3): {
      CODE_COVERAGE_UNTESTED(601); // Not hit
      goto LBL_OP_STORE_SCOPED;
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
/*                             VM_OP3_OBJECT_SET_2                           */
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
    lpProgramCounter = LongPtr_add(lpProgramCounter, (int16_t)reg1);
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
  lpProgramCounter = LongPtr_add(lpProgramCounter, (int16_t)reg1);
  goto LBL_DO_NEXT_INSTRUCTION;
}

/* ------------------------------------------------------------------------- */
/*                                                                           */
/*                                  LBL_RETURN                               */
/*                                                                           */
/*   Return from the current frame                                           */
/*                                                                           */
/*   Expects:                                                                */
/*     reg1: the return value                                                */
/* ------------------------------------------------------------------------- */
LBL_RETURN: {
  CODE_COVERAGE(105); // Hit

  // Pop variables
  pStackPointer = pFrameBase;

  // Save argCountAndFlags from this frame
  reg3 = reg->argCountAndFlags;

  // Restore caller state
  POP_REGISTERS();

  goto LBL_POP_ARGS;
}

/* ------------------------------------------------------------------------- */
/*                                                                           */
/*                                LBL_POP_ARGS                               */
/*                                                                           */
/*   The second part of a "RETURN". Assumes that we're already in the        */
/*   caller stack frame by this point.                                       */
/*                                                                           */
/*   Expects:                                                                */
/*     reg1: returning result                                                */
/*     reg3: argCountAndFlags for callee frame                               */
/* ------------------------------------------------------------------------- */
LBL_POP_ARGS: {
  // Pop arguments
  pStackPointer -= (uint8_t)reg3;

  // Pop function reference
  if (reg3 & AF_PUSHED_FUNCTION) {
    CODE_COVERAGE(108); // Hit
    (void)POP();
  } else {
    CODE_COVERAGE_UNTESTED(109); // Not hit
  }

  // Called from the host?
  if (reg3 & AF_CALLED_FROM_HOST) {
    CODE_COVERAGE(221); // Not hit
    goto LBL_RETURN_TO_HOST;
  } else {
    CODE_COVERAGE(111); // Hit
    goto LBL_TAIL_PUSH_REG1;
  }
}

/* ------------------------------------------------------------------------- */
/*                                                                           */
/*                            LBL_RETURN_TO_HOST                             */
/*                                                                           */
/*   Return control to the host                                              */
/*                                                                           */
/*   This is after popping the arguments                                     */
/*                                                                           */
/*   Expects:                                                                */
/*     reg1: the return value                                                */
/* ------------------------------------------------------------------------- */
LBL_RETURN_TO_HOST: {
  CODE_COVERAGE(110); // Hit

  // Provide the return value to the host
  if (out_result) {
    *out_result = reg1;
  }

  // If the stack is empty, we can free it. It may not be empty if this is a
  // reentrant call, in which case there would be other frames below this one.
  if (pStackPointer == getBottomOfStack(vm->stack)) {
    CODE_COVERAGE_UNTESTED(222); // Not hit
    free(vm->stack);
    vm->stack = NULL;

    // Return directly instead of going through LBL_EXIT because now the
    // registers are deallocated.
    return MVM_E_SUCCESS;
  } else {
    CODE_COVERAGE_UNTESTED(223); // Hit

    goto LBL_EXIT;
  }

}
/* ------------------------------------------------------------------------- */
/*                                                                           */
/*                                    LBL_CALL                               */
/*                                                                           */
/*   Performs a dynamic call to a given function value                       */
/*                                                                           */
/*   Expects:                                                                */
/*     reg1: argCountAndFlags for the new frame                              */
/*     reg2: target function value to call                                   */
/* ------------------------------------------------------------------------- */
LBL_CALL: {
  CODE_COVERAGE(224); // Hit

  reg3 /* scope */ = VM_VALUE_UNDEFINED;

  while (true) {
    TeTypeCode tc = deepTypeOf(vm, reg2 /* target */);
    if (tc == TC_REF_FUNCTION) {
      CODE_COVERAGE(141); // Hit
      // The following trick of assuming the function offset is just
      // `target >>= 1` is only true if the function is in ROM.
      VM_ASSERT(vm, DynamicPtr_isRomPtr(vm, reg2 /* target */));
      reg2 >>= 1;
      goto LBL_CALL_BYTECODE_FUNC;
    } else if (tc == TC_REF_HOST_FUNC) {
      CODE_COVERAGE(143); // Hit
      LongPtr lpHostFunc = DynamicPtr_decode_long(vm, reg2 /* target */);
      reg2 = READ_FIELD_2(lpHostFunc, TsHostFunc, indexInImportTable);
      goto LBL_CALL_HOST_COMMON;
    } else if (tc == TC_REF_CLOSURE) {
      CODE_COVERAGE(598); // Hit
      LongPtr lpClosure = DynamicPtr_decode_long(vm, reg2 /* target */);
      reg2 /* target */ = READ_FIELD_2(lpClosure, TsClosure, target);

      // Scope
      reg3 /* scope */ = READ_FIELD_2(lpClosure, TsClosure, scope);

      // Redirect the call to closure target
      continue;
    } else {
      CODE_COVERAGE_UNTESTED(264); // Not hit
      // Other value types are not callable
      err = MVM_E_TYPE_ERROR_TARGET_IS_NOT_CALLABLE;
      goto LBL_EXIT;
    }
  }
}

/* ------------------------------------------------------------------------- */
/*                          LBL_CALL_HOST_COMMON                             */
/*   Expects:                                                                */
/*     reg1: argCountAndFlags                                                */
/*     reg2: index in import table                                           */
/* ------------------------------------------------------------------------- */
LBL_CALL_HOST_COMMON: {
  CODE_COVERAGE(162); // Hit

  // Note: the interface with the host doesn't include the `this` pointer as the
  // first argument, so `args` points to the *next* argument.
  reg3 /* argCount */ = (uint8_t)reg1 - 1;

  // Note: I'm not calling `FLUSH_REGISTER_CACHE` here, even though control is
  // leaving the `run` function. One reason is that control is _also_ leaving
  // the current function activation, and the local registers states have no use
  // to the callee. The other reason is that it's "safer" and cheaper to keep
  // the activation state local, rather than flushing it to the shared space
  // `vm->stack->reg` where it could be trashed indirectly by the callee (see
  // the earlier comment in this block).
  //
  // The only the exception to this is the stack pointer, which is obviously
  // shared between the caller and callee
  reg->pStackPointer = pStackPointer;

  VM_ASSERT(vm, reg2 < vm_getResolvedImportCount(vm));
  mvm_TfHostFunction hostFunction = vm_getResolvedImports(vm)[reg2];
  mvm_HostFunctionID hostFunctionID = vm_getHostFunctionId(vm, reg2);
  Value result = VM_VALUE_UNDEFINED;

  /*
  Note: this subroutine does not call PUSH_REGISTERS to save the frame boundary.
  Calls to the host can be thought of more like machine instructions than
  distinct CALL operations in this sense, since they operate within the frame of
  the caller.

  This needs to work even if the host in turn calls the VM again during the call
  out to the host. When the host calls the VM again, it will push a new stack
  frame.
  */

  #if (MVM_SAFE_MODE)
    vm_TsRegisters regCopy = *reg;
  #endif

  // Call the host function
  err = hostFunction(vm, hostFunctionID, &result, pStackPointer - reg3, reg3);

  if (err != MVM_E_SUCCESS) goto LBL_EXIT;

  // The host function should not have left the stack unbalanced. A failure here
  // is not really a problem with the host since the Microvium C API doesn't
  // give the host access to the stack anyway.
  VM_ASSERT(vm, pStackPointer == reg->pStackPointer);

  #if (MVM_SAFE_MODE)
    /*
    The host function should leave the VM registers in the same state.

    `pStackPointer` can be modified temporarily because the host may call back
    into the VM, but it should be restored again by the time the host returns,
    otherwise the stack is unbalanced.

    The other registers (e.g. lpProgramCounter) should only be modified by
    bytecode instructions, which can be if the host calls back into the VM. But
    if the host calls back into the VM, it will go through LBL_CALL which
    performs a PUSH_REGISTERS to save the previous machine state, and then will
    restore the machine state when it returns.

    This check is also what confirms that we don't need a FLUSH_REGISTER_CACHE
    and CACHE_REGISTERS around the host call, since the host doesn't modify or
    use these registers, even if it calls back into the VM (with the exception
    of the stack pointer which is used but restored again afterward).

    Why do I care about this optimization? In part because typical Microvium
    scripts that I've seen tend to make a _lot_ of host calls, treating host
    functions roughly like a special-purpose instruction set and the script
    decides the sequence of instructions.
    */
    VM_ASSERT(vm, memcmp(&regCopy, reg, sizeof regCopy) == 0);
  #endif

  reg3 = reg1; // Callee argCountAndFlags
  reg1 = result;

  goto LBL_POP_ARGS;
}

/* ------------------------------------------------------------------------- */
/*                         LBL_CALL_BYTECODE_FUNC                            */
/*                                                                           */
/*   Calls a bytecode function                                               */
/*                                                                           */
/*   Expects:                                                                */
/*     reg1: new argCountAndFlags                                            */
/*     reg2: offset of target function in bytecode                           */
/*     reg3: scope, if reg1 & AF_SCOPE, else unused                          */
/* ------------------------------------------------------------------------- */
LBL_CALL_BYTECODE_FUNC: {
  CODE_COVERAGE(163); // Hit

  uint8_t maxStackDepth;
  READ_PGM_1(maxStackDepth);

  err = vm_requireStackSpace(vm, pStackPointer, maxStackDepth + VM_FRAME_BOUNDARY_SAVE_SIZE_WORDS);
  if (err != MVM_E_SUCCESS) {
    goto LBL_EXIT;
  }

  uint16_t* newPArgs = pStackPointer - (uint8_t)reg1;

  // Save old registers to the stack
  PUSH_REGISTERS();

  // Set up new frame
  pFrameBase = pStackPointer;
  reg->argCountAndFlags = reg1;
  reg->scope = reg3;
  reg->pArgs = newPArgs;
  lpProgramCounter = LongPtr_add(vm->lpBytecode, reg2);

  goto LBL_DO_NEXT_INSTRUCTION;
} // End of LBL_CALL_BYTECODE_FUNC

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

  MVM_FLOAT64 reg1F;
  if (reg1) reg1F = mvm_toFloat64(vm, reg1);
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
} // End of mvm_call


void mvm_free(VM* vm) {
  CODE_COVERAGE_UNTESTED(166); // Not hit
  gc_freeGCMemory(vm);
  VM_EXEC_SAFE_MODE(memset(vm, 0, sizeof(*vm)));
  free(vm);
}

/**
 * @param sizeBytes Size in bytes of the allocation, *excluding* the header
 * @param typeCode The type code to insert into the header
 */
static void* gc_allocateWithHeader(VM* vm, uint16_t sizeBytes, TeTypeCode typeCode) {
  uint16_t* p;
  uint16_t* end;

  CODE_COVERAGE(184); // Hit
  TsBucket* pBucket;
  const uint16_t sizeIncludingHeader = (sizeBytes + 3) & 0xFFFE;
  // + 2 bytes header, round up to 2-byte boundary
  VM_ASSERT(vm, (sizeIncludingHeader & 1) == 0);

  // Minimum allocation size is 4 bytes, because that's the size of a
  // tombstone. Note that nothing in code will attempt to allocate less,
  // since even a 1-char string (+null terminator) is a 4-byte allocation.
  VM_ASSERT(vm, sizeIncludingHeader >= 4);

RETRY:
  pBucket = vm->pLastBucket;
  if (!pBucket) {
    CODE_COVERAGE_UNTESTED(185); // Not hit
    goto GROW_HEAP_AND_RETRY;
  }
  p = pBucket->pEndOfUsedSpace;
  end = (uint16_t*)((intptr_t)p + sizeIncludingHeader);
  if (end > vm->pLastBucketEndCapacity) {
    CODE_COVERAGE(186); // Hit
    goto GROW_HEAP_AND_RETRY;
  }
  pBucket->pEndOfUsedSpace = end;

  // Write header
  *p++ = makeHeaderWord(vm, typeCode, sizeBytes);

  return p;

GROW_HEAP_AND_RETRY:
  CODE_COVERAGE(187); // Hit
  gc_createNextBucket(vm, MVM_ALLOCATION_BUCKET_SIZE, sizeIncludingHeader);
  goto RETRY;
}

// Slow fallback for gc_allocateWithConstantHeader
static void* gc_allocateWithConstantHeaderSlow(VM* vm, uint16_t header) {
  CODE_COVERAGE(188); // Hit
  uint16_t size = vm_getAllocationSizeExcludingHeaderFromHeaderWord(header);
  TeTypeCode tc = vm_getTypeCodeFromHeaderWord(header);
  return gc_allocateWithHeader(vm, size, tc);
}

/*
 * This function is like gc_allocateWithHeader except that it's optimized for
 * situations where:
 *
 *   1. The header can be precomputed to a C constant, rather than assembling it
 *      from the size and type
 *   2. The size is known to be a multiple of 2 and at least 2 bytes
 *
 * This is more efficient in some cases because it has fewer checks and
 * preprocessing to do. This function can probably be inlined in some cases.
 *
 * Note: the size is passed separately rather than computed from the header
 * because this function is optimized for cases where the size is known at
 * compile time (and even better if this function is inlined).
 */
static inline void* gc_allocateWithConstantHeader(VM* vm, uint16_t header, uint16_t sizeIncludingHeader) {
  uint16_t* p;
  uint16_t* end;

  CODE_COVERAGE(189); // Hit
  VM_ASSERT(vm, sizeIncludingHeader % 2 == 0);
  VM_ASSERT(vm, sizeIncludingHeader >= 4);
  VM_ASSERT(vm, vm_getAllocationSizeExcludingHeaderFromHeaderWord(header) == sizeIncludingHeader - 2);

  TsBucket* pBucket = vm->pLastBucket;
  if (!pBucket) {
    CODE_COVERAGE_UNTESTED(190); // Not hit
    goto SLOW;
  }
  p = pBucket->pEndOfUsedSpace;
  end = (uint16_t*)((intptr_t)p + sizeIncludingHeader);
  if (end > vm->pLastBucketEndCapacity) {
    CODE_COVERAGE(191); // Hit
    goto SLOW;
  }
  pBucket->pEndOfUsedSpace = end;
  *p++ = header;
  return p;

SLOW:
  CODE_COVERAGE(192); // Hit
  return gc_allocateWithConstantHeaderSlow(vm, header);
}

// Looks for a variable in the closure scope chain, bottoming out in the pool of
// globals. It's plausible that scope records be stored in ROM in some optimized
// cases, so this returns a long pointer.
static LongPtr vm_findScopedVariable(VM* vm, uint16_t varIndex) {
  /*
    Closure scopes are arrays, with the first slot in the array being a
    reference to the outer scope
   */
  Value scope = vm->stack->reg.scope;
  while (scope != VM_VALUE_UNDEFINED)
  {
    LongPtr lpArr = DynamicPtr_decode_long(vm, scope);
    uint16_t headerWord = readAllocationHeaderWord_long(lpArr);
    VM_ASSERT(vm, vm_getTypeCodeFromHeaderWord(headerWord) == TC_REF_FIXED_LENGTH_ARRAY);
    uint16_t arrayLength = vm_getAllocationSizeExcludingHeaderFromHeaderWord(headerWord) / 2;
    // Each scope has 1 slot at the beginning reserved for the link to the parent/outer scope
    uint16_t varCount = arrayLength - 1;

    if (varIndex < varCount) {
      uint16_t arrayIndex = varIndex + 1;
      return LongPtr_add(lpArr, arrayIndex * 2);
    } else {
      varIndex -= varCount;
      // The first slot of each scope is the link to its parent
      VM_ASSERT(vm, arrayLength >= 1);
      scope = LongPtr_read2_aligned(lpArr);
    }
  }

  // Otherwise, the variable is a global
  VM_BYTECODE_ASSERT(vm, varIndex < getSectionSize(vm, BCS_GLOBALS) / 2);
  Value* pGlobalVar = &vm->globals[varIndex];

  return LongPtr_new(pGlobalVar);
}

static inline void* getBucketDataBegin(TsBucket* bucket) {
  CODE_COVERAGE(193); // Hit
  return (void*)(bucket + 1);
}

/** The used heap size, excluding spare capacity in the last block, but
 * including any uncollected garbage. */
static uint16_t getHeapSize(VM* vm) {
  TsBucket* lastBucket = vm->pLastBucket;
  if (lastBucket) {
    CODE_COVERAGE(194); // Hit
    return getBucketOffsetEnd(lastBucket);
  } else {
    CODE_COVERAGE(195); // Hit
    return 0;
  }
}

void mvm_getMemoryStats(VM* vm, mvm_TsMemoryStats* r) {
  CODE_COVERAGE(627); // Hit
  VM_ASSERT(NULL, vm != NULL);
  VM_ASSERT(vm, r != NULL);

  memset(r, 0, sizeof *r);

  // Core size
  r->coreSize = sizeof(VM);
  r->fragmentCount++;

  // Import table size
  r->importTableSize = getSectionSize(vm, BCS_IMPORT_TABLE) / sizeof (vm_TsImportTableEntry) * sizeof(mvm_TfHostFunction);

  // Global variables size
  r->globalVariablesSize = getSectionSize(vm, BCS_IMPORT_TABLE);

  r->stackHighWaterMark = vm->stackHighWaterMark;

  r->virtualHeapHighWaterMark = vm->heapHighWaterMark;

  // Running Parameters
  vm_TsStack* stack = vm->stack;
  if (stack) {
    CODE_COVERAGE(628); // Hit
    r->fragmentCount++;
    vm_TsRegisters* reg = &stack->reg;
    r->registersSize = sizeof *reg;
    r->stackHeight = (uint8_t*)reg->pStackPointer - (uint8_t*)getBottomOfStack(vm->stack);
    r->stackAllocatedCapacity = MVM_STACK_SIZE;
  }

  // Heap Stats
  TsBucket* pLastBucket = vm->pLastBucket;
  size_t heapOverheadSize = 0;
  if (pLastBucket) {
    CODE_COVERAGE(629); // Hit
    TsBucket* b;
    for (b = pLastBucket; b; b = b->prev) {
      r->fragmentCount++;
      heapOverheadSize += sizeof (TsBucket); // Extra space for bucket header
    }
    r->virtualHeapUsed = getHeapSize(vm);
    if (r->virtualHeapUsed > r->virtualHeapHighWaterMark)
      r->virtualHeapHighWaterMark = r->virtualHeapUsed;
    r->virtualHeapAllocatedCapacity = pLastBucket->offsetStart + (uint16_t)vm->pLastBucketEndCapacity - (uint16_t)getBucketDataBegin(pLastBucket);
  }

  // Total size
  r->totalSize =
    r->coreSize +
    r->importTableSize +
    r->globalVariablesSize +
    r->registersSize +
    r->stackAllocatedCapacity +
    r->virtualHeapAllocatedCapacity +
    heapOverheadSize;
}

/**
 * Expand the VM heap by allocating a new "bucket" of memory from the host.
 *
 * @param bucketSize The ideal size of the contents of the new bucket
 * @param minBucketSize The smallest the bucketSize can be reduced and still be valid
 */
static void gc_createNextBucket(VM* vm, uint16_t bucketSize, uint16_t minBucketSize) {
  CODE_COVERAGE(7); // Hit
  uint16_t heapSize = getHeapSize(vm);

  if (bucketSize < minBucketSize) {
    CODE_COVERAGE_UNTESTED(196); // Not hit
    bucketSize = minBucketSize;
  }

  VM_ASSERT(vm, minBucketSize <= bucketSize);

  // If this tips us over the top of the heap, then we run a collection
  if (heapSize + bucketSize > MVM_MAX_HEAP_SIZE) {
    CODE_COVERAGE_UNTESTED(197); // Not hit
    mvm_runGC(vm, false);
    heapSize = getHeapSize(vm);
  }

  // Can't fit?
  if (heapSize + minBucketSize > MVM_MAX_HEAP_SIZE) {
    CODE_COVERAGE_ERROR_PATH(5); // Not hit
    MVM_FATAL_ERROR(vm, MVM_E_OUT_OF_MEMORY);
  }

  // Can fit, but only by chopping the end off the new bucket?
  if (heapSize + bucketSize > MVM_MAX_HEAP_SIZE) {
    CODE_COVERAGE_UNTESTED(6); // Not hit
    bucketSize = MVM_MAX_HEAP_SIZE - heapSize;
  }

  size_t allocSize = sizeof (TsBucket) + bucketSize;
  TsBucket* bucket = malloc(allocSize);
  if (!bucket) {
    CODE_COVERAGE_ERROR_PATH(198); // Not hit
    MVM_FATAL_ERROR(vm, MVM_E_MALLOC_FAIL);
  }
  #if MVM_SAFE_MODE
    memset(bucket, 0x7E, allocSize);
  #endif
  bucket->prev = vm->pLastBucket;
  bucket->next = NULL;
  bucket->pEndOfUsedSpace = getBucketDataBegin(bucket);

  TABLE_COVERAGE(bucket->prev ? 1 : 0, 2, 11); // Hit 2/2

  // Note: we start the next bucket at the allocation cursor, not at what we
  // previously called the end of the previous bucket
  bucket->offsetStart = heapSize;
  vm->pLastBucketEndCapacity = (uint16_t*)((intptr_t)bucket->pEndOfUsedSpace + bucketSize);
  if (vm->pLastBucket) {
    CODE_COVERAGE(199); // Hit
    vm->pLastBucket->next = bucket;
  } else {
    CODE_COVERAGE(200); // Hit
  }
  vm->pLastBucket = bucket;
}

static void gc_freeGCMemory(VM* vm) {
  CODE_COVERAGE(10); // Hit
  TABLE_COVERAGE(vm->pLastBucket ? 1 : 0, 2, 201); // Hit 1/2
  while (vm->pLastBucket) {
    CODE_COVERAGE_UNTESTED(169); // Not hit
    TsBucket* prev = vm->pLastBucket->prev;
    free(vm->pLastBucket);
    TABLE_COVERAGE(prev ? 1 : 0, 2, 202); // Not hit
    vm->pLastBucket = prev;
  }
  vm->pLastBucketEndCapacity = NULL;
}

#if MVM_INCLUDE_SNAPSHOT_CAPABILITY
/**
 * Given a pointer `ptr` into the heap, this returns the equivalent offset from
 * the start of the heap (0 meaning that `ptr` points to the beginning of the
 * heap).
 *
 * This is used in 2 places:
 *
 *   1. On a 32-bit machine, this is used to get a 16-bit equivalent encoding for ShortPtr
 *   2. On any machine, this is used in serializePtr for creating snapshots
 */
static uint16_t pointerOffsetInHeap(VM* vm, TsBucket* pLastBucket, void* ptr) {
  CODE_COVERAGE(203); // Hit
  /*
   * This algorithm iterates through the buckets in the heap backwards. Although
   * this is technically linear cost, in reality I expect that the pointer will
   * be found in the very first searched bucket almost all the time. This is
   * because the GC compacts everything into a single bucket, and because the
   * most recently bucket is also likely to be the most frequently accessed.
   *
   * See ShortPtr_decode for more description
   */
  TsBucket* bucket = pLastBucket;
  while (bucket) {
    // Note: using `<=` here because the pointer is permitted to point to the
    // end of the heap.
    if ((ptr >= (void*)bucket) && (ptr <= (void*)bucket->pEndOfUsedSpace)) {
      CODE_COVERAGE(204); // Hit
      uint16_t offsetInBucket = (uint16_t)((intptr_t)ptr - (intptr_t)getBucketDataBegin(bucket));
      VM_ASSERT(vm, offsetInBucket < 0x8000);
      uint16_t offsetInHeap = bucket->offsetStart + offsetInBucket;

      // It isn't strictly necessary that all short pointers are 2-byte aligned,
      // but it probably indicates a mistake somewhere if a short pointer is not
      // 2-byte aligned, since `Value` cannot be a `ShortPtr` unless it's 2-byte
      // aligned.
      VM_ASSERT(vm, (offsetInHeap & 1) == 0);

      VM_ASSERT(vm, offsetInHeap < getHeapSize(vm));

      return offsetInHeap;
    } else {
      CODE_COVERAGE(205); // Hit
    }

    bucket = bucket->prev;
  }

  // A failure here means we're trying to encode a pointer that doesn't map
  // to something in GC memory, which is a mistake.
  MVM_FATAL_ERROR(vm, MVM_E_UNEXPECTED);
  return 0;
}
#endif // MVM_INCLUDE_SNAPSHOT_CAPABILITY

#if MVM_NATIVE_POINTER_IS_16_BIT
  static inline void* ShortPtr_decode(VM* vm, ShortPtr ptr) {
    return (void*)ptr;
  }
  static inline ShortPtr ShortPtr_encode(VM* vm, void* ptr) {
    return (ShortPtr)ptr;
  }
  static inline ShortPtr ShortPtr_encodeInToSpace(gc_TsGCCollectionState* gc, void* ptr) {
    return (ShortPtr)ptr;
  }
#else // !MVM_NATIVE_POINTER_IS_16_BIT
  static void* ShortPtr_decode(VM* vm, ShortPtr shortPtr) {
    CODE_COVERAGE(206); // Hit

    // It isn't strictly necessary that all short pointers are 2-byte aligned,
    // but it probably indicates a mistake somewhere if a short pointer is not
    // 2-byte aligned, since `Value` cannot be a `ShortPtr` unless it's 2-byte
    // aligned. Among other things, this catches VM_VALUE_NULL.
    VM_ASSERT(vm, (shortPtr & 1) == 0);

    // The shortPtr is treated as an offset into the heap
    uint16_t offsetInHeap = shortPtr;
    VM_ASSERT(vm, offsetInHeap < getHeapSize(vm));

    /*
    Note: this is a linear search through the buckets, but a redeeming factor is
    that GC compacts the heap into a single bucket, so the number of buckets is
    small at any one time. Also, most-recently-allocated data are likely to be
    in the last bucket and accessed fastest. Also, the representation of the
    function is only needed on more powerful platforms. For 16-bit platforms,
    the implementation of ShortPtr_decode is a no-op.
    */

    TsBucket* bucket = vm->pLastBucket;
    while (true) {
      // All short pointers must map to some memory in a bucket, otherwise the pointer is corrupt
      VM_ASSERT(vm, bucket != NULL);

      if (offsetInHeap >= bucket->offsetStart) {
        CODE_COVERAGE(207); // Hit
        uint16_t offsetInBucket = offsetInHeap - bucket->offsetStart;
        void* result = (void*)((intptr_t)getBucketDataBegin(bucket) + offsetInBucket);
        return result;
      } else {
        CODE_COVERAGE(208); // Hit
      }
      bucket = bucket->prev;
    }
  }

  /**
   * Like ShortPtr_encode except conducted against an arbitrary bucket list.
   *
   * Used internally by ShortPtr_encode and ShortPtr_encodeinToSpace.
   */
  static inline ShortPtr ShortPtr_encode_generic(VM* vm, TsBucket* pLastBucket, void* ptr) {
    CODE_COVERAGE(209); // Hit
    return pointerOffsetInHeap(vm, pLastBucket, ptr);
  }

  // Encodes a pointer as pointing to a value in the current heap
  static inline ShortPtr ShortPtr_encode(VM* vm, void* ptr) {
    CODE_COVERAGE(211); // Hit
    return ShortPtr_encode_generic(vm, vm->pLastBucket, ptr);
  }

  // Encodes a pointer as pointing to a value in the _new_ heap (tospace) during
  // an ongoing garbage collection.
  static inline ShortPtr ShortPtr_encodeInToSpace(gc_TsGCCollectionState* gc, void* ptr) {
    CODE_COVERAGE(212); // Hit
    return ShortPtr_encode_generic(gc->vm, gc->lastBucket, ptr);
  }
#endif

#if MVM_SAFE_MODE // (This is only used in safe mode at the moment
static bool Value_isBytecodeMappedPtr(Value value) {
  CODE_COVERAGE(213); // Hit
  return Value_isBytecodeMappedPtrOrWellKnown(value) && (value >= VM_VALUE_WELLKNOWN_END);
}
#endif // MVM_SAFE_MODE

static LongPtr BytecodeMappedPtr_decode_long(VM* vm, BytecodeMappedPtr ptr) {
  CODE_COVERAGE(214); // Hit

  // BytecodeMappedPtr values are treated as offsets into a bytecode image
  uint16_t offsetInBytecode = ptr;

  LongPtr lpBytecode = vm->lpBytecode;
  LongPtr lpTarget = LongPtr_add(lpBytecode, offsetInBytecode);

  // A BytecodeMappedPtr can either point to ROM or via a global variable to
  // RAM. Here to discriminate the two, we're assuming the handles section comes
  // first
  VM_ASSERT(vm, BCS_ROM < BCS_GLOBALS);
  uint16_t globalsOffset = getSectionOffset(lpBytecode, BCS_GLOBALS);

  if (offsetInBytecode < globalsOffset) { // Points to ROM section?
    CODE_COVERAGE(215); // Hit
    VM_ASSERT(vm, offsetInBytecode >= getSectionOffset(lpBytecode, BCS_ROM));
    VM_ASSERT(vm, offsetInBytecode < getSectionOffset(lpBytecode, sectionAfter(vm, BCS_ROM)));
    VM_ASSERT(vm, (ptr & 1) == 0);

    // The pointer just references ROM
    return lpTarget;
  } else { // Else, must point to RAM via a global variable
    CODE_COVERAGE(216); // Hit
    VM_ASSERT(vm, offsetInBytecode >= getSectionOffset(lpBytecode, BCS_GLOBALS));
    VM_ASSERT(vm, offsetInBytecode < getSectionOffset(lpBytecode, sectionAfter(vm, BCS_GLOBALS)));
    VM_ASSERT(vm, (ptr & 1) == 0);

    // This line of code is more for ceremony, so we have a searchable reference to mvm_TsROMHandleEntry
    uint8_t globalVariableIndex = (offsetInBytecode - globalsOffset) / 2;

    Value handleValue = vm->globals[globalVariableIndex];

    // Handle values are only allowed to be pointers or NULL. I'm allowing a
    // BytecodeMappedPtr to reflect back into the bytecode space because it
    // would allow some copy-on-write scenarios.
    VM_ASSERT(vm, Value_isBytecodeMappedPtr(handleValue) ||
      Value_isShortPtr(handleValue) ||
      (handleValue == VM_VALUE_NULL));

    return DynamicPtr_decode_long(vm, handleValue);
  }
}

static LongPtr DynamicPtr_decode_long(VM* vm, DynamicPtr ptr) {
  CODE_COVERAGE(217); // Hit

  if (Value_isShortPtr(ptr))  {
    CODE_COVERAGE(218); // Hit
    return LongPtr_new(ShortPtr_decode(vm, ptr));
  }

  if (ptr == VM_VALUE_NULL) {
    CODE_COVERAGE(219); // Hit
    return LongPtr_new(NULL);
  }
  CODE_COVERAGE(242); // Hit

  // This function is for decoding pointers, so if this isn't a pointer then
  // there's a problem.
  VM_ASSERT(vm, !Value_isVirtualInt14(ptr));

  // At this point, it's not a short pointer, so it must be a bytecode-mapped
  // pointer
  VM_ASSERT(vm, Value_encodesBytecodeMappedPtr(ptr));

  return BytecodeMappedPtr_decode_long(vm, ptr >> 1);
}

/*
 * Decode a DynamicPtr when the target is known to live in natively-addressable
 * memory (i.e. heap memory). If the target might be in ROM, use
 * DynamicPtr_decode_long.
 */
static void* DynamicPtr_decode_native(VM* vm, DynamicPtr ptr) {
  CODE_COVERAGE(253); // Hit
  LongPtr lp = DynamicPtr_decode_long(vm, ptr);
  void* p = LongPtr_truncate(lp);
  // Assert that the resulting native pointer is equivalent to the long pointer.
  // I.e. that we didn't lose anything in the truncation (i.e. that it doesn't
  // point to ROM).
  VM_ASSERT(vm, LongPtr_new(p) == lp);
  return p;
}

// I'm using inline wrappers around the port macros because I want to add a
// layer of type safety.
static inline LongPtr LongPtr_new(void* p) {
  CODE_COVERAGE(284); // Hit
  return MVM_LONG_PTR_NEW(p);
}
static inline void* LongPtr_truncate(LongPtr lp) {
  CODE_COVERAGE(332); // Hit
  return MVM_LONG_PTR_TRUNCATE(lp);
}
static inline LongPtr LongPtr_add(LongPtr lp, int16_t offset) {
  CODE_COVERAGE(333); // Hit
  return MVM_LONG_PTR_ADD(lp, offset);
}
static inline int16_t LongPtr_sub(LongPtr lp1, LongPtr lp2) {
  CODE_COVERAGE(334); // Hit
  return (int16_t)(MVM_LONG_PTR_SUB(lp1, lp2));
}
static inline uint8_t LongPtr_read1(LongPtr lp) {
  CODE_COVERAGE(335); // Hit
  return (uint8_t)(MVM_READ_LONG_PTR_1(lp));
}
// Read a 16-bit value from a long pointer, if the target is 16-bit aligned
static inline uint16_t LongPtr_read2_aligned(LongPtr lp) {
  CODE_COVERAGE(336); // Hit
  // Expect an even boundary. Weird things happen on some platforms if you try
  // to read unaligned memory through aligned instructions.
  VM_ASSERT(0, ((uint16_t)lp & 1) == 0);
  return (uint16_t)(MVM_READ_LONG_PTR_2(lp));
}
// Read a 16-bit value from a long pointer, if the target is not 16-bit aligned
static inline uint16_t LongPtr_read2_unaligned(LongPtr lp) {
  CODE_COVERAGE(626); // Hit
  return (uint32_t)(MVM_READ_LONG_PTR_1(lp)) |
    ((uint32_t)(MVM_READ_LONG_PTR_1((MVM_LONG_PTR_ADD(lp, 1)))) << 8);
}
static inline uint32_t LongPtr_read4(LongPtr lp) {
  // We don't often read 4 bytes, since the word size for microvium is 2 bytes.
  // When we do need to, I think it's safer to just read it as 2 separate words
  // since we don't know for sure that we're not executing on a 32 bit machine
  // that can't do unaligned access. All memory in microvium is at least 16-bit
  // aligned, with the exception of bytecode instructions, but those do not
  // contain 32-bit literals.
  CODE_COVERAGE(337); // Hit
  return (uint32_t)(MVM_READ_LONG_PTR_2(lp)) |
    ((uint32_t)(MVM_READ_LONG_PTR_2((MVM_LONG_PTR_ADD(lp, 2)))) << 16);
}

static uint16_t getBucketOffsetEnd(TsBucket* bucket) {
  CODE_COVERAGE(338); // Hit
  return bucket->offsetStart + (uint16_t)bucket->pEndOfUsedSpace - (uint16_t)getBucketDataBegin(bucket);
}

static uint16_t gc_getHeapSize(gc_TsGCCollectionState* gc) {
  CODE_COVERAGE(351); // Hit
  TsBucket* pLastBucket = gc->lastBucket;
  if (pLastBucket) {
    CODE_COVERAGE(352); // Hit
    return getBucketOffsetEnd(pLastBucket);
  } else {
    CODE_COVERAGE(355); // Hit
    return 0;
  }
}

static void gc_newBucket(gc_TsGCCollectionState* gc, uint16_t newSpaceSize, uint16_t minNewSpaceSize) {
  CODE_COVERAGE(356); // Hit
  uint16_t heapSize = gc_getHeapSize(gc);

  if (newSpaceSize < minNewSpaceSize) {
    CODE_COVERAGE_UNTESTED(357); // Not hit
    newSpaceSize = minNewSpaceSize;
  } else {
    CODE_COVERAGE(358); // Hit
  }

  // Since this is during a GC, it should be impossible for us to need more heap
  // than is allowed, since the original heap should never have exceeded the
  // MVM_MAX_HEAP_SIZE.
  VM_ASSERT(vm, heapSize + minNewSpaceSize <= MVM_MAX_HEAP_SIZE);

  // Can fit, but only by chopping the end off the new bucket?
  if (heapSize + newSpaceSize > MVM_MAX_HEAP_SIZE) {
    CODE_COVERAGE_UNTESTED(8); // Not hit
    newSpaceSize = MVM_MAX_HEAP_SIZE - heapSize;
  } else {
    CODE_COVERAGE(360); // Hit
  }

  TsBucket* pBucket = (TsBucket*)malloc(sizeof (TsBucket) + newSpaceSize);
  if (!pBucket) {
    CODE_COVERAGE_ERROR_PATH(376); // Not hit
    MVM_FATAL_ERROR(vm, MVM_E_MALLOC_FAIL);
    return;
  }
  pBucket->next = NULL;
  uint16_t* pDataInBucket = (uint16_t*)(pBucket + 1);
  if (((intptr_t)pDataInBucket) & 1) {
    CODE_COVERAGE_ERROR_PATH(377); // Not hit
    MVM_FATAL_ERROR(vm, MVM_E_MALLOC_MUST_RETURN_POINTER_TO_EVEN_BOUNDARY);
    return;
  }
  pBucket->offsetStart = heapSize;
  pBucket->prev = gc->lastBucket;
  pBucket->pEndOfUsedSpace = getBucketDataBegin(pBucket);
  if (!gc->firstBucket) {
    CODE_COVERAGE(392); // Hit
    gc->firstBucket = pBucket;
  } else {
    CODE_COVERAGE(393); // Hit
  }
  if (gc->lastBucket) {
    CODE_COVERAGE(394); // Hit
    gc->lastBucket->next = pBucket;
  } else {
    CODE_COVERAGE(395); // Hit
  }
  gc->lastBucket = pBucket;
  gc->lastBucketEndCapacity = (uint16_t*)((intptr_t)pDataInBucket + newSpaceSize);
}

static void gc_processShortPtrValue(gc_TsGCCollectionState* gc, Value* pValue) {
  CODE_COVERAGE(407); // Hit

  uint16_t* writePtr;
  const Value spSrc = *pValue;
  VM* const vm = gc->vm;

  uint16_t* const pSrc = (uint16_t*)ShortPtr_decode(vm, spSrc);
  // ShortPtr is defined as not encoding null
  VM_ASSERT(vm, pSrc != NULL);

  const uint16_t headerWord = pSrc[-1];

  // If there's a tombstone, then we've already collected this allocation
  if (headerWord == TOMBSTONE_HEADER) {
    CODE_COVERAGE_UNTESTED(464); // Not hit
    *pValue = pSrc[0];
    return;
  } else {
    CODE_COVERAGE(465); // Hit
  }
  // Otherwise, we need to move the allocation

LBL_MOVE_ALLOCATION:
  // Note: the variables before this point are `const` because an allocation
  // movement can be aborted half way and tried again (in particular, see the
  // property list compaction). It's only right at the end of this function
  // where the writePtr is "committed" to the gc structure.

  VM_ASSERT(vm, gc->lastBucket != NULL);
  writePtr = gc->lastBucket->pEndOfUsedSpace;
  uint16_t size = vm_getAllocationSizeExcludingHeaderFromHeaderWord(headerWord);
  uint16_t words = (size + 3) / 2; // Rounded up, including header

  // Check we have space
  if (writePtr + words > gc->lastBucketEndCapacity) {
    CODE_COVERAGE(466); // Hit
    uint16_t minRequiredSpace = words * 2;
    gc_newBucket(gc, MVM_ALLOCATION_BUCKET_SIZE, minRequiredSpace);

    goto LBL_MOVE_ALLOCATION;
  } else {
    CODE_COVERAGE(467); // Hit
  }

  // Write the header
  *writePtr++ = headerWord;
  words--;

  uint16_t* pOld = pSrc;
  uint16_t* pNew = writePtr;

  // Copy the allocation body
  uint16_t* readPtr = pSrc;
  while (words--)
    *writePtr++ = *readPtr++;

  // Dynamic arrays and property lists are compacted here
  TeTypeCode tc = vm_getTypeCodeFromHeaderWord(headerWord);
  if (tc == TC_REF_ARRAY) {
    CODE_COVERAGE(468); // Hit
    TsArray* arr = (TsArray*)pNew;
    DynamicPtr dpData = arr->dpData;
    if (dpData != VM_VALUE_NULL) {
      CODE_COVERAGE(469); // Hit
      VM_ASSERT(vm, Value_isShortPtr(dpData));

      // Note: this decodes the pointer against fromspace
      TsFixedLengthArray* pData = ShortPtr_decode(vm, dpData);

      uint16_t len = VirtualInt14_decode(vm, arr->viLength);
      #if MVM_SAFE_MODE
        uint16_t headerWord = readAllocationHeaderWord(pData);
        uint16_t dataTC = vm_getTypeCodeFromHeaderWord(headerWord);
        // Note: because dpData is a unique pointer, we can be sure that it
        // hasn't already been moved in response to some other reference to
        // it (it's not a tombstone yet).
        VM_ASSERT(vm, dataTC == TC_REF_FIXED_LENGTH_ARRAY);
        uint16_t dataSize = vm_getAllocationSizeExcludingHeaderFromHeaderWord(headerWord);
        uint16_t capacity = dataSize / 2;
        VM_ASSERT(vm, len <= capacity);
      #endif

      if (len > 0) {
        CODE_COVERAGE(470); // Hit
        // We just truncate the fixed-length-array to match the programmed
        // length of the dynamic array, which is necessarily equal or less than
        // its previous value. The GC will copy the data later and update the
        // data pointer as it would normally do when following pointers.
        setHeaderWord(vm, pData, TC_REF_FIXED_LENGTH_ARRAY, len * 2);
      } else {
        CODE_COVERAGE_UNTESTED(472); // Not hit
        // Or if there's no length, we can remove the data altogether.
        arr->dpData = VM_VALUE_NULL;
      }
    } else {
      CODE_COVERAGE(473); // Hit
    }
  } else if (tc == TC_REF_PROPERTY_LIST) {
    CODE_COVERAGE(474); // Hit
    TsPropertyList* props = (TsPropertyList*)pNew;

    Value dpNext = props->dpNext;

    // If the object has children (detached extensions to the main
    // allocation), we take this opportunity to compact them into the parent
    // allocation to save space and improve access performance.
    if (dpNext != VM_VALUE_NULL) {
      CODE_COVERAGE(478); // Hit
      // Note: The "root" property list counts towards the total but its
      // fields do not need to be copied because it's already copied, above
      uint16_t headerWord = readAllocationHeaderWord(props);
      uint16_t allocationSize = vm_getAllocationSizeExcludingHeaderFromHeaderWord(headerWord);
      uint16_t totalPropCount = (allocationSize - sizeof(TsPropertyList)) / 4;

      do {
        // Note: while `next` is not strictly a ShortPtr in general, when used
        // within GC allocations it will never point to an allocation in ROM
        // or data memory, since it's only used to extend objects with new
        // properties.
        VM_ASSERT(vm, Value_isShortPtr(dpNext));
        TsPropertyList* child = (TsPropertyList*)ShortPtr_decode(vm, dpNext);

        uint16_t headerWord = readAllocationHeaderWord(child);
        uint16_t allocationSize = vm_getAllocationSizeExcludingHeaderFromHeaderWord(headerWord);
        uint16_t childPropCount = (allocationSize - sizeof(TsPropertyList)) / 4;
        totalPropCount += childPropCount;

        uint16_t* end = writePtr + childPropCount;
        // Check we have space for the new properties
        if (end > gc->lastBucketEndCapacity) {
          CODE_COVERAGE_UNTESTED(479); // Not hit
          // If we don't have space, we need to revert and try again. The
          // "revert" isn't explict. It depends on the fact that the gc.writePtr
          // hasn't been committed yet, and no mutations have been applied to
          // the source memory (i.e. the tombstone hasn't been written yet).
          uint16_t minRequiredSpace = sizeof (TsPropertyList) + totalPropCount * 4;
          gc_newBucket(gc, MVM_ALLOCATION_BUCKET_SIZE, minRequiredSpace);
          goto LBL_MOVE_ALLOCATION;
        } else {
          CODE_COVERAGE(480); // Hit
        }

        uint16_t* pField = (uint16_t*)(child + 1);

        // Copy the child fields directly into the parent
        while (childPropCount--) {
          *writePtr++ = *pField++; // key
          *writePtr++ = *pField++; // value
        }
        dpNext = child->dpNext;
        TABLE_COVERAGE(dpNext ? 1 : 0, 2, 490); // Hit 1/2
      } while (dpNext != VM_VALUE_NULL);

      // We've collapsed all the lists into one, so let's adjust the header
      uint16_t newSize = sizeof (TsPropertyList) + totalPropCount * 4;
      if (newSize > MAX_ALLOCATION_SIZE) {
        CODE_COVERAGE_ERROR_PATH(491); // Not hit
        MVM_FATAL_ERROR(vm, MVM_E_ALLOCATION_TOO_LARGE);
        return;
      }

      setHeaderWord(vm, props, TC_REF_PROPERTY_LIST, newSize);
      props->dpNext = VM_VALUE_NULL;
    }
  } else {
    CODE_COVERAGE(492); // Hit
  }

  // Commit the move (grow the target heap and add the tombstone)

  gc->lastBucket->pEndOfUsedSpace = writePtr;

  ShortPtr spNew = ShortPtr_encodeInToSpace(gc, pNew);

  pOld[-1] = TOMBSTONE_HEADER;
  pOld[0] = spNew; // Forwarding pointer

  *pValue = spNew;
}

static inline void gc_processValue(gc_TsGCCollectionState* gc, Value* pValue) {
  // Note: only short pointer values are allowed to point to GC memory,
  // and we only need to follow references that go to GC memory.
  if (Value_isShortPtr(*pValue)) {
    CODE_COVERAGE(446); // Hit
    gc_processShortPtrValue(gc, pValue);
  } else {
    CODE_COVERAGE(463); // Hit
  }
}

void mvm_runGC(VM* vm, bool squeeze) {
  CODE_COVERAGE(593); // Hit

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

  uint16_t heapSize = getHeapSize(vm);
  if (heapSize > vm->heapHighWaterMark)
    vm->heapHighWaterMark = heapSize;

  // A collection of variables shared by GC routines
  gc_TsGCCollectionState gc;
  memset(&gc, 0, sizeof gc);
  gc.vm = vm;

  // We don't know how big the heap needs to be, so we just allocate the same
  // amount of space as used last time and then expand as-needed
  uint16_t estimatedSize = vm->heapSizeUsedAfterLastGC;

  if (estimatedSize) {
    CODE_COVERAGE(493); // Hit
    gc_newBucket(&gc, estimatedSize, 0);
  } else {
    CODE_COVERAGE_UNTESTED(494); // Not hit
  }

  // Roots in global variables
  uint16_t globalsSize = getSectionSize(vm, BCS_GLOBALS);
  p = vm->globals;
  n = globalsSize / 2;
  TABLE_COVERAGE(n ? 1 : 0, 2, 495); // Hit 1/2
  while (n--)
    gc_processValue(&gc, p++);

  // Roots in gc_handles
  mvm_Handle* handle = vm->gc_handles;
  TABLE_COVERAGE(handle ? 1 : 0, 2, 496); // Hit 2/2
  while (handle) {
    gc_processValue(&gc, &handle->_value);
    TABLE_COVERAGE(handle->_next ? 1 : 0, 2, 497); // Hit 2/2
    handle = handle->_next;
  }

  // Roots on the stack
  vm_TsStack* stack = vm->stack;
  if (stack) {
    CODE_COVERAGE_UNTESTED(498); // Not hit
    vm_TsRegisters* reg = &stack->reg;
    uint16_t* beginningOfStack = getBottomOfStack(stack);
    uint16_t* beginningOfFrame = reg->pFrameBase;
    uint16_t* endOfFrame = reg->pStackPointer;

    // Loop through frames
    do {
      VM_ASSERT(vm, beginningOfFrame > beginningOfStack);
      // Loop through words in frame
      p = beginningOfFrame;
      while (p != endOfFrame) {
        VM_ASSERT(vm, p < endOfFrame);
        gc_processValue(&gc, p++);
      }

      // The following statements assume a particular stack shape
      VM_ASSERT(vm, VM_FRAME_BOUNDARY_VERSION == 2);

      // Skip over the registers that are saved during a CALL instruction
      endOfFrame = beginningOfFrame - 4;

      // The first thing saved during a CALL is the size of the preceeding frame
      beginningOfFrame = (uint16_t*)((uint8_t*)endOfFrame - *endOfFrame);

      TABLE_COVERAGE(beginningOfFrame == beginningOfStack ? 1 : 0, 2, 499); // Not hit
    } while (beginningOfFrame != beginningOfStack);
  } else {
    CODE_COVERAGE(500); // Hit
  }

  // Now we process moved allocations to make sure objects they point to are
  // also moved, and to update pointers to reference the new space

  TsBucket* bucket = gc.firstBucket;
  TABLE_COVERAGE(bucket ? 1 : 0, 2, 501); // Hit 1/2
  // Loop through buckets
  while (bucket) {
    uint16_t* p = (uint16_t*)getBucketDataBegin(bucket);

    // Loop through allocations in bucket. Note that this loop will hit exactly
    // the end of the bucket even when there are multiple buckets, because empty
    // space in a bucket is truncated when a new one is created (in
    // gc_processValue)
    while (p != bucket->pEndOfUsedSpace) { // Hot loop
      VM_ASSERT(vm, p < bucket->pEndOfUsedSpace);
      uint16_t header = *p++;
      uint16_t size = vm_getAllocationSizeExcludingHeaderFromHeaderWord(header);
      uint16_t words = (size + 1) / 2;

      // Note: we're comparing the header words here to compare the type code.
      // The RHS here is constant
      if (header < (uint16_t)(TC_REF_DIVIDER_CONTAINER_TYPES << 12)) { // Non-container types
        CODE_COVERAGE(502); // Hit
        p += words;
        continue;
      } else {
        // Else, container types
        CODE_COVERAGE(505); // Hit
      }

      while (words--) { // Hot loop
        if (Value_isShortPtr(*p))
          gc_processValue(&gc, p);
        p++;
      }
    }

    // Go to next bucket
    bucket = bucket->next;
    TABLE_COVERAGE(bucket ? 1 : 0, 2, 506); // Hit 2/2
  }

  // Release old heap
  TsBucket* oldBucket = vm->pLastBucket;
  TABLE_COVERAGE(oldBucket ? 1 : 0, 2, 507); // Hit 1/2
  while (oldBucket) {
    TsBucket* prev = oldBucket->prev;
    free(oldBucket);
    oldBucket = prev;
  }

  // Adopt new heap
  vm->pLastBucket = gc.lastBucket;
  vm->pLastBucketEndCapacity = gc.lastBucketEndCapacity;

  uint16_t finalUsedSize = getHeapSize(vm);
  vm->heapSizeUsedAfterLastGC = finalUsedSize;

  if (squeeze && (finalUsedSize != estimatedSize)) {
    CODE_COVERAGE(508); // Hit
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
    that has no side effect most of the time but allocates a lot of unreachable
    garbage during its "working out". With this implementation would only run
    the GC once each time, since the estimated size would be correct most of the
    time.

    In conclusion, I decided that the best way to "squeeze" the heap is to just
    run the collection twice. The first time will tell us the exact size, and
    then if that's different to what we estimated then we perform the collection
    again, now with the exact target size, so that there is no unused space
    mallocd from the host, and no unnecessary mallocs from the host.
    */
    mvm_runGC(vm, false);
  } else {
    CODE_COVERAGE(509); // Hit
  }
}

/**
 * Create the call VM call stack and registers
 */
TeError vm_createStackAndRegisters(VM* vm) {
  CODE_COVERAGE(225); // Not hit
  // This is freed again at the end of mvm_call. Note: the allocated
  // memory includes the registers, which are part of the vm_TsStack
  // structure
  vm_TsStack* stack = malloc(sizeof (vm_TsStack) + MVM_STACK_SIZE);
  if (!stack) {
    CODE_COVERAGE_ERROR_PATH(231); // Not hit
    return MVM_E_MALLOC_FAIL;
  }
  vm->stack = stack;
  vm_TsRegisters* reg = &stack->reg;
  memset(reg, 0, sizeof *reg);
  // The stack grows upward. The bottom is the lowest address.
  uint16_t* bottomOfStack = getBottomOfStack(stack);
  reg->pFrameBase = bottomOfStack;
  reg->pStackPointer = bottomOfStack;
  reg->lpProgramCounter = vm->lpBytecode; // This is essentially treated as a null value
  reg->argCountAndFlags = 0;
  VM_ASSERT(vm, reg->pArgs == 0);
  VM_ASSERT(vm, reg->scope == 0);

  return MVM_E_SUCCESS;
}

static inline uint16_t* getBottomOfStack(vm_TsStack* stack) {
  CODE_COVERAGE(510); // Hit
  return (uint16_t*)(stack + 1);
}

static inline uint16_t* getTopOfStackSpace(vm_TsStack* stack) {
  CODE_COVERAGE(511); // Hit
  return getBottomOfStack(stack) + MVM_STACK_SIZE / 2;
}

#if MVM_DEBUG
// Some utility functions, mainly to execute in the debugger (could also be copy-pasted as expressions in some cases)
uint16_t dbgStackDepth(VM* vm) {
  return (uint16_t*)vm->stack->reg.pStackPointer - (uint16_t*)(vm->stack + 1);
}
uint16_t* dbgStack(VM* vm) {
  return (uint16_t*)(vm->stack + 1);
}
uint16_t dbgPC(VM* vm) {
  return (uint16_t)((intptr_t)vm->stack->reg.lpProgramCounter - (intptr_t)vm->lpBytecode);
}
#endif // MVM_DEBUG

/**
 * Checks that we have enough stack space for the given size, and updates the
 * high water mark.
 */
static TeError vm_requireStackSpace(VM* vm, uint16_t* pStackPointer, uint16_t sizeRequiredInWords) {
  uint16_t* pStackHighWaterMark = pStackPointer + ((intptr_t)sizeRequiredInWords);
  if (pStackHighWaterMark > getTopOfStackSpace(vm->stack)) {
    CODE_COVERAGE_ERROR_PATH(233); // Not hit

    // TODO(low): Since we know the max stack depth for the function, we could
    // actually grow the stack dynamically rather than allocate it fixed size.
    // Actually, it seems likely that we could allocate the VM stack on the C
    // stack, since it's a fixed-size structure anyway.
    //
    // (A way to do the allocation on the stack would be to perform a nested
    // call to mvm_call, and the allocation can be at the begining of mvm_call).
    // Otherwise we could just malloc, which has the advantage of simplicity and
    // we can grow the stack at any time.
    //
    // Rather than a segmented stack, it might also be simpler to just grow the
    // stack size and copy across old data. This has the advantage of keeping
    // the GC simple.
    return MVM_E_STACK_OVERFLOW;
  }

  // Stack high-water mark
  uint16_t stackHighWaterMark = (uint16_t)((intptr_t)pStackHighWaterMark - (intptr_t)getBottomOfStack(vm->stack));
  if (stackHighWaterMark > vm->stackHighWaterMark) {
    vm->stackHighWaterMark = stackHighWaterMark;
  }

  return MVM_E_SUCCESS;
}

TeError vm_resolveExport(VM* vm, mvm_VMExportID id, Value* result) {
  CODE_COVERAGE(17); // Hit

  LongPtr exportTableEnd;
  LongPtr exportTable = getBytecodeSection(vm, BCS_EXPORT_TABLE, &exportTableEnd);

  // See vm_TsExportTableEntry
  LongPtr exportTableEntry = exportTable;
  while (exportTableEntry < exportTableEnd) {
    CODE_COVERAGE(234); // Hit
    mvm_VMExportID exportID = LongPtr_read2_aligned(exportTableEntry);
    if (exportID == id) {
      CODE_COVERAGE(235); // Hit
      LongPtr pExportvalue = LongPtr_add(exportTableEntry, 2);
      mvm_VMExportID exportValue = LongPtr_read2_aligned(pExportvalue);
      *result = exportValue;
      return MVM_E_SUCCESS;
    } else {
      CODE_COVERAGE_UNTESTED(236); // Not hit
    }
    exportTableEntry = LongPtr_add(exportTableEntry, sizeof (vm_TsExportTableEntry));
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

#if MVM_SAFE_MODE
static bool vm_isHandleInitialized(VM* vm, const mvm_Handle* handle) {
  CODE_COVERAGE(22); // Hit
  mvm_Handle* h = vm->gc_handles;
  while (h) {
    CODE_COVERAGE(243); // Hit
    if (h == handle) {
      CODE_COVERAGE_UNTESTED(244); // Not hit
      return true;
    }
    else {
      CODE_COVERAGE(245); // Hit
    }
    h = h->_next;
  }
  return false;
}
#endif // MVM_SAFE_MODE

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

static Value vm_convertToString(VM* vm, Value value) {
  CODE_COVERAGE(23); // Hit
  TeTypeCode type = deepTypeOf(vm, value);
  const char* constStr;

  switch (type) {
    case TC_VAL_INT14:
    case TC_REF_INT32: {
      CODE_COVERAGE(246); // Hit
      int32_t i = vm_readInt32(vm, type, value);
      return vm_intToStr(vm, i);
    }
    case TC_REF_FLOAT64: {
      CODE_COVERAGE_UNTESTED(248); // Not hit
      return VM_NOT_IMPLEMENTED(vm);
    }
    case TC_REF_STRING: {
      CODE_COVERAGE(249); // Hit
      return value;
    }
    case TC_REF_INTERNED_STRING: {
      CODE_COVERAGE(250); // Hit
      return value;
    }
    case TC_REF_PROPERTY_LIST: {
      CODE_COVERAGE_UNTESTED(251); // Not hit
      return VM_NOT_IMPLEMENTED(vm);
    }
    case TC_REF_CLOSURE: {
      CODE_COVERAGE_UNTESTED(365); // Not hit
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
    case TC_REF_RESERVED_1B: {
      CODE_COVERAGE_UNTESTED(256); // Not hit
      return VM_NOT_IMPLEMENTED(vm);
    }
    case TC_REF_CLASS: {
      CODE_COVERAGE_UNTESTED(596); // Not hit
      return VM_NOT_IMPLEMENTED(vm);
    }
    case TC_REF_VIRTUAL: {
      CODE_COVERAGE_UNTESTED(597); // Not hit
      return VM_NOT_IMPLEMENTED(vm);
    }
    case TC_REF_SYMBOL: {
      CODE_COVERAGE_UNTESTED(257); // Not hit
      return VM_NOT_IMPLEMENTED(vm);
    }
    case TC_VAL_UNDEFINED: {
      CODE_COVERAGE(258); // Hit
      constStr = "undefined";
      break;
    }
    case TC_VAL_NULL: {
      CODE_COVERAGE(259); // Hit
      constStr = "null";
      break;
    }
    case TC_VAL_TRUE: {
      CODE_COVERAGE(260); // Hit
      constStr = "true";
      break;
    }
    case TC_VAL_FALSE: {
      CODE_COVERAGE(261); // Hit
      constStr = "false";
      break;
    }
    case TC_VAL_NAN: {
      CODE_COVERAGE_UNTESTED(262); // Not hit
      constStr = "NaN";
      break;
    }
    case TC_VAL_NEG_ZERO: {
      CODE_COVERAGE(263); // Hit
      constStr = "0";
      break;
    }
    case TC_VAL_STR_LENGTH: {
      CODE_COVERAGE(266); // Hit
      return value;
    }
    case TC_VAL_STR_PROTO: {
      CODE_COVERAGE_UNTESTED(267); // Not hit
      return value;
    }
    case TC_VAL_DELETED: {
      return VM_UNEXPECTED_INTERNAL_ERROR(vm);
    }
    default: return VM_UNEXPECTED_INTERNAL_ERROR(vm);
  }

  return vm_newStringFromCStrNT(vm, constStr);
}

static Value vm_intToStr(VM* vm, int32_t i) {
  CODE_COVERAGE(618); // Hit
  static const char strMinInt[] = "-2147483648";
  char buf[12]; // Up to 11 digits plus a minus sign
  char* cur = &buf[sizeof buf];
  bool negative = false;
  if (i < 0) {
    CODE_COVERAGE(619); // Hit
    // Special case for this value because `-i` overflows.
    if (i == (int32_t)0x80000000) {
      CODE_COVERAGE(621); // Hit
      return vm_newStringFromCStrNT(vm, strMinInt);
    } else {
      CODE_COVERAGE(622); // Hit
    }
    negative = true;
    i = -i;
  }
  else {
    CODE_COVERAGE(620); // Hit
    negative = false;
  }
  do {
    *--cur = '0' + i % 10;
    i /= 10;
  } while (i);

  if (negative) {
    *--cur = '-';
  }

  return mvm_newString(vm, cur, &buf[sizeof buf] - cur);
}

static Value vm_concat(VM* vm, Value left, Value right) {
  CODE_COVERAGE(24); // Hit
  size_t leftSize = 0;
  LongPtr lpLeftStr = vm_toStringUtf8_long(vm, left, &leftSize);
  size_t rightSize = 0;
  LongPtr lpRightStr = vm_toStringUtf8_long(vm, right, &rightSize);
  uint8_t* data;
  Value value = vm_allocString(vm, leftSize + rightSize, (void**)&data);
  memcpy_long(data, lpLeftStr, leftSize);
  memcpy_long(data + leftSize, lpRightStr, rightSize);
  return value;
}

/* Returns the deep type of the value, looking through pointers and boxing */
static TeTypeCode deepTypeOf(VM* vm, Value value) {
  CODE_COVERAGE(27); // Hit

  if (Value_isShortPtr(value)) {
    CODE_COVERAGE(0); // Hit
    void* p = ShortPtr_decode(vm, value);
    uint16_t headerWord = readAllocationHeaderWord(p);
    TeTypeCode typeCode = vm_getTypeCodeFromHeaderWord(headerWord);
    return typeCode;
  } else {
    CODE_COVERAGE(515); // Hit
  }

  if (Value_isVirtualInt14(value)) {
    CODE_COVERAGE(295); // Hit
    return TC_VAL_INT14;
  } else {
    CODE_COVERAGE(516); // Hit
  }

  VM_ASSERT(vm, Value_isBytecodeMappedPtrOrWellKnown(value));

  // Check for "well known" values such as TC_VAL_UNDEFINED
  if (value < VM_VALUE_WELLKNOWN_END) {
    CODE_COVERAGE(296); // Hit
    return (TeTypeCode)((value >> 2) + 0x10);
  } else {
    CODE_COVERAGE(297); // Hit
  }

  LongPtr p = DynamicPtr_decode_long(vm, value);
  uint16_t headerWord = readAllocationHeaderWord_long(p);
  TeTypeCode typeCode = vm_getTypeCodeFromHeaderWord(headerWord);

  return typeCode;
}

#if MVM_SUPPORT_FLOAT
int32_t mvm_float64ToInt32(MVM_FLOAT64 value) {
  CODE_COVERAGE(486); // Hit
  if (isfinite(value)) {
    CODE_COVERAGE(487); // Hit
    return (int32_t)value;
  } else {
    CODE_COVERAGE(488); // Hit
    return 0;
  }
}

Value mvm_newNumber(VM* vm, MVM_FLOAT64 value) {
  CODE_COVERAGE(28); // Hit
  if (isnan(value)) {
    CODE_COVERAGE(298); // Hit
    return VM_VALUE_NAN;
  } else {
    CODE_COVERAGE(517); // Hit
  }

  if (value == -0.0) {
    CODE_COVERAGE(299); // Hit
    return VM_VALUE_NEG_ZERO;
  } else {
    CODE_COVERAGE(518); // Hit
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

  MVM_FLOAT64* pResult = GC_ALLOCATE_TYPE(vm, MVM_FLOAT64, TC_REF_FLOAT64);
  *pResult = value;

  return ShortPtr_encode(vm, pResult);
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

  int32_t* pResult = GC_ALLOCATE_TYPE(vm, int32_t, TC_REF_INT32);
  *pResult = value;

  return ShortPtr_encode(vm, pResult);
}

bool mvm_toBool(VM* vm, Value value) {
  CODE_COVERAGE(30); // Hit

  TeTypeCode type = deepTypeOf(vm, value);
  switch (type) {
    case TC_VAL_INT14: {
      CODE_COVERAGE(304); // Hit
      return value != VirtualInt14_encode(vm, 0);
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
    case TC_REF_INTERNED_STRING:
    case TC_REF_STRING: {
      CODE_COVERAGE(307); // Hit
      return vm_stringSizeUtf8(vm, value) != 0;
    }
    case TC_REF_PROPERTY_LIST: {
      CODE_COVERAGE(308); // Hit
      return true;
    }
    case TC_REF_CLOSURE: {
      CODE_COVERAGE_UNTESTED(372); // Not hit
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
    case TC_REF_RESERVED_1B: {
      CODE_COVERAGE_UNTESTED(313); // Not hit
      return VM_RESERVED(vm);
    }
    case TC_REF_SYMBOL: {
      CODE_COVERAGE_UNTESTED(314); // Not hit
      return true;
    }
    case TC_REF_CLASS: {
      CODE_COVERAGE_UNTESTED(604); // Not hit
      return VM_RESERVED(vm);
    }
    case TC_REF_VIRTUAL: {
      CODE_COVERAGE_UNTESTED(609); // Not hit
      return VM_RESERVED(vm);
    }
    case TC_REF_INTERNAL_CONTAINER: {
      CODE_COVERAGE_UNTESTED(610); // Not hit
      return VM_RESERVED(vm);
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
    case TC_VAL_STR_LENGTH: {
      CODE_COVERAGE_UNTESTED(268); // Not hit
      return true;
    }
    case TC_VAL_STR_PROTO: {
      CODE_COVERAGE_UNTESTED(269); // Not hit
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
    (deepType == TC_REF_INTERNED_STRING) ||
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
    LongPtr target = DynamicPtr_decode_long(vm, value);
    int32_t result = (int32_t)LongPtr_read4(target);
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

static inline uint16_t readAllocationHeaderWord_long(LongPtr pAllocation) {
  CODE_COVERAGE(519); // Hit
  return LongPtr_read2_aligned(LongPtr_add(pAllocation, -2));
}

static inline uint16_t readAllocationHeaderWord(void* pAllocation) {
  CODE_COVERAGE(520); // Hit
  return ((uint16_t*)pAllocation)[-1];
}

static inline mvm_TfHostFunction* vm_getResolvedImports(VM* vm) {
  CODE_COVERAGE(40); // Hit
  return (mvm_TfHostFunction*)(vm + 1); // Starts right after the header
}

static inline mvm_HostFunctionID vm_getHostFunctionId(VM*vm, uint16_t hostFunctionIndex) {
  LongPtr lpImportTable = getBytecodeSection(vm, BCS_IMPORT_TABLE, NULL);
  LongPtr lpImportTableEntry = LongPtr_add(lpImportTable, hostFunctionIndex * sizeof (vm_TsImportTableEntry));
  return LongPtr_read2_aligned(lpImportTableEntry);
}

mvm_TeType mvm_typeOf(VM* vm, Value value) {
  CODE_COVERAGE(42); // Hit
  TeTypeCode type = deepTypeOf(vm, value);
  // TODO: This should be implemented as a lookup table, not a switch. Actually,
  // there may be some other switches that should also be converted to lookups.
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
    case TC_REF_INTERNED_STRING:
    case TC_VAL_STR_LENGTH:
    case TC_VAL_STR_PROTO: {
      CODE_COVERAGE(343); // Hit
      return VM_T_STRING;
    }

    case TC_REF_ARRAY: {
      CODE_COVERAGE_UNTESTED(344); // Not hit
      return VM_T_ARRAY;
    }

    case TC_REF_PROPERTY_LIST: {
      CODE_COVERAGE_UNTESTED(345); // Not hit
      return VM_T_OBJECT;
    }

    case TC_REF_CLOSURE: {
      CODE_COVERAGE(346); // Hit
      return VM_T_FUNCTION;
    }

    case TC_REF_FUNCTION: {
      CODE_COVERAGE(594); // Hit
      return VM_T_FUNCTION;
    }

    case TC_REF_HOST_FUNC: {
      CODE_COVERAGE_UNTESTED(595); // Not hit
      return VM_T_FUNCTION;
    }

    case TC_REF_CLASS: {
      CODE_COVERAGE_UNTESTED(613); // Not hit
      return VM_T_FUNCTION;
    }

    case TC_REF_VIRTUAL: {
      CODE_COVERAGE_UNTESTED(614); // Not hit
      VM_NOT_IMPLEMENTED(vm);
      return 0;
    }

    case TC_REF_SYMBOL: {
      CODE_COVERAGE_UNTESTED(348); // Not hit
      return VM_T_SYMBOL;
    }

    default: VM_UNEXPECTED_INTERNAL_ERROR(vm); return VM_T_UNDEFINED;
  }
}

LongPtr vm_toStringUtf8_long(VM* vm, Value value, size_t* out_sizeBytes) {
  CODE_COVERAGE(43); // Hit
  value = vm_convertToString(vm, value);

  TeTypeCode typeCode = deepTypeOf(vm, value);

  if (typeCode == TC_VAL_STR_PROTO) {
    CODE_COVERAGE_UNTESTED(521); // Not hit
    *out_sizeBytes = sizeof PROTO_STR - 1;
    return LongPtr_new((void*)&PROTO_STR);
  } else {
    CODE_COVERAGE(522); // Hit
  }

  if (typeCode == TC_VAL_STR_LENGTH) {
    CODE_COVERAGE(523); // Hit
    *out_sizeBytes = sizeof LENGTH_STR - 1;
    return LongPtr_new((void*)&LENGTH_STR);
  } else {
    CODE_COVERAGE(524); // Hit
  }

  VM_ASSERT(vm, (typeCode == TC_REF_STRING) || (typeCode == TC_REF_INTERNED_STRING));

  LongPtr lpTarget = DynamicPtr_decode_long(vm, value);
  uint16_t headerWord = readAllocationHeaderWord_long(lpTarget);
  uint16_t sourceSize = vm_getAllocationSizeExcludingHeaderFromHeaderWord(headerWord);

  if (out_sizeBytes) {
    CODE_COVERAGE(349); // Hit
    *out_sizeBytes = sourceSize - 1; // Without the extra safety null-terminator
  } else {
    CODE_COVERAGE_UNTESTED(350); // Not hit
  }

  return lpTarget;
}

const char* mvm_toStringUtf8(VM* vm, Value value, size_t* out_sizeBytes) {
  CODE_COVERAGE(623); // Hit
  /*
   * Note: I previously had this function returning a long pointer, but this
   * tripped someone up because they passed the result directly to printf, which
   * on MSP430 apparently doesn't support arbitrary long pointers (data20
   * pointers). Now I just copy it locally.
   */

  size_t size; // Size excluding a null terminator
  LongPtr lpTarget = vm_toStringUtf8_long(vm, value, &size);
  if (out_sizeBytes)
    *out_sizeBytes = size;

  void* pTarget = LongPtr_truncate(lpTarget);
  // Is the string in local memory?
  if (LongPtr_new(pTarget) == lpTarget) {
    CODE_COVERAGE(624); // Hit
    return (const char*)pTarget;
  } else {
    CODE_COVERAGE_UNTESTED(625); // Not hit
    // Allocate a new string in local memory (with additional null terminator)
    vm_allocString(vm, size, &pTarget);
    memcpy_long(pTarget, lpTarget, size);

    return (const char*)pTarget;
  }
}

Value mvm_newBoolean(bool source) {
  CODE_COVERAGE_UNTESTED(44); // Not hit
  return source ? VM_VALUE_TRUE : VM_VALUE_FALSE;
}

Value vm_allocString(VM* vm, size_t sizeBytes, void** out_pData) {
  CODE_COVERAGE(45); // Hit
  if (sizeBytes < 3)
    TABLE_COVERAGE(sizeBytes, 3, 525); // Hit 2/3
  if (sizeBytes > 0x3FFF - 1) {
    CODE_COVERAGE_ERROR_PATH(353); // Not hit
    MVM_FATAL_ERROR(vm, MVM_E_ALLOCATION_TOO_LARGE);
  } else {
    CODE_COVERAGE(354); // Hit
  }
  // Note: allocating 1 extra byte for the extra null terminator
  char* pData = gc_allocateWithHeader(vm, (uint16_t)sizeBytes + 1, TC_REF_STRING);
  *out_pData = pData;
  // Null terminator
  pData[sizeBytes] = '\0';
  return ShortPtr_encode(vm, pData);
}

// New string from null-terminated
static Value vm_newStringFromCStrNT(VM* vm, const char* s) {
  size_t len = strlen(s);
  return mvm_newString(vm, s, len);
}

Value mvm_newString(VM* vm, const char* sourceUtf8, size_t sizeBytes) {
  CODE_COVERAGE(46); // Hit
  void* data;
  Value value = vm_allocString(vm, sizeBytes, &data);
  memcpy(data, sourceUtf8, sizeBytes);
  return value;
}

static Value getBuiltin(VM* vm, mvm_TeBuiltins builtinID) {
  CODE_COVERAGE(526); // Hit
  LongPtr lpBuiltins = getBytecodeSection(vm, BCS_BUILTINS, NULL);
  LongPtr lpBuiltin = LongPtr_add(lpBuiltins, (int16_t)(builtinID * sizeof (Value)));
  Value value = LongPtr_read2_aligned(lpBuiltin);
  return value;
}

/**
 * If the value is a handle, this returns a pointer to the global variable
 * referenced by the handle. Otherwise, this returns NULL.
 */
static inline Value* getHandleTargetOrNull(VM* vm, Value value) {
  CODE_COVERAGE_UNTESTED(527); // Not hit
  if (!Value_isBytecodeMappedPtrOrWellKnown(value)) {
    CODE_COVERAGE_UNTESTED(528); // Not hit
    return NULL;
  } else {
    CODE_COVERAGE_UNTESTED(529); // Not hit
  }
  uint16_t globalsOffset = getSectionOffset(vm->lpBytecode, BCS_GLOBALS);
  uint16_t globalsEndOffset = getSectionOffset(vm->lpBytecode, sectionAfter(vm, BCS_GLOBALS));
  if ((value < globalsOffset) || (value >= globalsEndOffset)) {
    CODE_COVERAGE_UNTESTED(530); // Not hit
    return NULL;
  } else {
    CODE_COVERAGE_UNTESTED(531); // Not hit
  }
  uint16_t globalIndex = (value - globalsOffset) / 2;
  return &vm->globals[globalIndex];
}

/**
 * Assigns to the slot pointed to by lpTarget
 *
 * If lpTarget points to a handle, then the corresponding global variable is
 * mutated. Otherwise, the target is directly mutated.
 *
 * This is used to synthesize mutation of slots in ROM, such as exports,
 * builtins, and properties of ROM objects. Such logically-mutable slots *must*
 * hold a value that is a BytecodeMappedPtr to a global variable that holds the
 * mutable reference.
 *
 * The function works transparently on RAM or ROM slots.
 */
// TODO: probably SetProperty should use this, so it works on ROM-allocated
// objects/arrays. Probably a good candidate for TDD.
static void setSlot_long(VM* vm, LongPtr lpSlot, Value value) {
  CODE_COVERAGE_UNTESTED(532); // Not hit
  Value slotContents = LongPtr_read2_aligned(lpSlot);
  // Work out if the target slot is actually a handle.
  Value* handleTarget = getHandleTargetOrNull(vm, slotContents);
  if (handleTarget) {
    CODE_COVERAGE_UNTESTED(533); // Not hit
    // Set the corresponding global variable
    *handleTarget = value;
    return;
  } else {
    CODE_COVERAGE_UNTESTED(534); // Not hit
  }
  // Otherwise, for the mutation must be valid, the slot must be in RAM.

  // We never mutate through a long pointer, because anything mutable must be in
  // RAM and anything in RAM must be addressable by a short pointer
  Value* pSlot = LongPtr_truncate(lpSlot);

  // Check the truncation hasn't lost anything. If this fails, the slot could be
  // in ROM. If this passes, the slot
  VM_ASSERT(vm, LongPtr_new(pSlot) == lpSlot);

  // The compiler must never produce bytecode that is able to attempt to write
  // to the bytecode image itself, but just to catch mistakes, here's an
  // assertion to make sure it doesn't write to bytecode. In a properly working
  // system (compiler + engine), this assertion isn't needed
  VM_ASSERT(vm, (lpSlot < vm->lpBytecode) ||
    (lpSlot >= LongPtr_add(vm->lpBytecode, getBytecodeSize(vm))));

  *pSlot = value;
}

static void setBuiltin(VM* vm, mvm_TeBuiltins builtinID, Value value) {
  CODE_COVERAGE_UNTESTED(535); // Not hit
  LongPtr lpBuiltins = getBytecodeSection(vm, BCS_BUILTINS, NULL);
  LongPtr lpBuiltin = LongPtr_add(lpBuiltins, (int16_t)(builtinID * sizeof (Value)));
  setSlot_long(vm, lpBuiltin, value);
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
        VM_NOT_IMPLEMENTED(vm);
        return MVM_E_NOT_IMPLEMENTED;
      }
      LongPtr lpPropertyList = DynamicPtr_decode_long(vm, objectValue);
      DynamicPtr dpProto = READ_FIELD_2(lpPropertyList, TsPropertyList, dpProto);

      while (lpPropertyList) {
        uint16_t headerWord = readAllocationHeaderWord_long(lpPropertyList);
        uint16_t size = vm_getAllocationSizeExcludingHeaderFromHeaderWord(headerWord);
        uint16_t propCount = (size - sizeof (TsPropertyList)) / 4;

        LongPtr p = LongPtr_add(lpPropertyList, sizeof (TsPropertyList));
        while (propCount--) {
          Value key = LongPtr_read2_aligned(p);
          p = LongPtr_add(p, 2);
          Value value = LongPtr_read2_aligned(p);
          p = LongPtr_add(p, 2);

          if (key == vPropertyName) {
            CODE_COVERAGE(361); // Hit
            *vPropertyValue = value;
            return MVM_E_SUCCESS;
          } else {
            CODE_COVERAGE(362); // Hit
          }
        }

        DynamicPtr dpNext = READ_FIELD_2(lpPropertyList, TsPropertyList, dpNext);
         // Move to next group, if there is one
        if (dpNext != VM_VALUE_NULL) {
          CODE_COVERAGE(536); // Hit
          lpPropertyList = DynamicPtr_decode_long(vm, dpNext);
        } else { // Otherwise try read from the prototype
          CODE_COVERAGE(537); // Hit
          lpPropertyList = DynamicPtr_decode_long(vm, dpProto);
          if (lpPropertyList) {
            CODE_COVERAGE_UNTESTED(538); // Not hit
            dpProto = READ_FIELD_2(lpPropertyList, TsPropertyList, dpProto);
          } else {
            CODE_COVERAGE(539); // Hit
          }
        }
      }

      *vPropertyValue = VM_VALUE_UNDEFINED;
      return MVM_E_SUCCESS;
    }
    // TODO: TC_REF_FIXED_LENGTH_ARRAY
    case TC_REF_ARRAY: {
      CODE_COVERAGE(363); // Hit
      LongPtr lpArr = DynamicPtr_decode_long(vm, objectValue);
      Value viLength = READ_FIELD_2(lpArr, TsArray, viLength);
      VM_ASSERT(vm, Value_isVirtualInt14(viLength));
      uint16_t length = VirtualInt14_decode(vm, viLength);
      if (vPropertyName == VM_VALUE_STR_LENGTH) {
        CODE_COVERAGE(274); // Hit
        VM_ASSERT(vm, Value_isVirtualInt14(viLength));
        *vPropertyValue = viLength;
        return MVM_E_SUCCESS;
      } else if (vPropertyName == VM_VALUE_STR_PROTO) {
        CODE_COVERAGE(275); // Hit
        *vPropertyValue = getBuiltin(vm, BIN_ARRAY_PROTO);
        return MVM_E_SUCCESS;
      } else {
        CODE_COVERAGE(276); // Hit
      }
      // Array index
      if (Value_isVirtualInt14(vPropertyName)) {
        CODE_COVERAGE(277); // Hit
        uint16_t index = VirtualInt14_decode(vm, vPropertyName);
        DynamicPtr dpData = READ_FIELD_2(lpArr, TsArray, dpData);
        LongPtr lpData = DynamicPtr_decode_long(vm, dpData);
        if (index >= length) {
          CODE_COVERAGE(283); // Hit
          *vPropertyValue = VM_VALUE_UNDEFINED;
          return MVM_E_SUCCESS;
        } else {
          CODE_COVERAGE(328); // Hit
        }
        // We've already checked if the value exceeds the length, so lpData
        // cannot be null and the capacity must be at least as large as the
        // length of the array.
        VM_ASSERT(vm, lpData);
        VM_ASSERT(vm, length * 2 <= vm_getAllocationSizeExcludingHeaderFromHeaderWord(readAllocationHeaderWord_long(lpData)));
        Value value = LongPtr_read2_aligned(LongPtr_add(lpData, index * 2));
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

      Value arrayProto = getBuiltin(vm, BIN_ARRAY_PROTO);
      if (arrayProto != VM_VALUE_NULL) {
        CODE_COVERAGE(396); // Hit
        return getProperty(vm, arrayProto, vPropertyName, vPropertyValue);
      } else {
        CODE_COVERAGE_UNTESTED(397); // Not hit
        *vPropertyValue = VM_VALUE_UNDEFINED;
        return MVM_E_SUCCESS;
      }
    }
    default: return MVM_E_TYPE_ERROR;
  }
}

static void growArray(VM* vm, TsArray* arr, uint16_t newLength, uint16_t newCapacity) {
  CODE_COVERAGE(293); // Hit
  VM_ASSERT(vm, newCapacity >= newLength);
  if (newCapacity > MAX_ALLOCATION_SIZE / 2) {
    CODE_COVERAGE_ERROR_PATH(540); // Not hit
    MVM_FATAL_ERROR(vm, MVM_E_ARRAY_TOO_LONG);
  }
  VM_ASSERT(vm, newCapacity != 0);

  uint16_t* pNewData = gc_allocateWithHeader(vm, newCapacity * 2, TC_REF_FIXED_LENGTH_ARRAY);
  // Copy values from the old array
  DynamicPtr dpOldData = arr->dpData;
  uint16_t oldCapacity = 0;
  if (dpOldData != VM_VALUE_NULL) {
    CODE_COVERAGE(294); // Hit
    LongPtr lpOldData = DynamicPtr_decode_long(vm, dpOldData);

    uint16_t oldDataHeader = readAllocationHeaderWord_long(lpOldData);
    uint16_t oldSize = vm_getAllocationSizeExcludingHeaderFromHeaderWord(oldDataHeader);
    VM_ASSERT(vm, (oldSize & 1) == 0);
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
  arr->dpData = ShortPtr_encode(vm, pNewData);
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
        VM_NOT_IMPLEMENTED(vm);
        return MVM_E_NOT_IMPLEMENTED;
      } else {
        CODE_COVERAGE(541); // Hit
      }

      // Note: while objects in general can be in ROM, objects which are
      // writable must always be in RAM.

      TsPropertyList* pPropertyList = DynamicPtr_decode_native(vm, vObjectValue);

      while (true) {
        CODE_COVERAGE(367); // Hit
        uint16_t headerWord = readAllocationHeaderWord(pPropertyList);
        uint16_t size = vm_getAllocationSizeExcludingHeaderFromHeaderWord(headerWord);
        uint16_t propCount = (size - sizeof (TsPropertyList)) / 4;

        uint16_t* p = (uint16_t*)(pPropertyList + 1);
        while (propCount--) {
          Value key = *p++;

          // We can do direct comparison because the strings have been interned,
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
          CODE_COVERAGE(542); // Hit
          pPropertyList = DynamicPtr_decode_native(vm, dpNext);
        } else {
          CODE_COVERAGE(543); // Hit
          break;
        }
      }
      // If we reach the end, then this is a new property. We add new properties
      // by just appending a new TsPropertyList onto the linked list. The GC
      // will compact these into the head later.
      TsPropertyCell* pNewCell = GC_ALLOCATE_TYPE(vm, TsPropertyCell, TC_REF_PROPERTY_LIST);
      ShortPtr spNewCell = ShortPtr_encode(vm, pNewCell);
      pNewCell->base.dpNext = VM_VALUE_NULL;
      pNewCell->base.dpProto = VM_VALUE_NULL; // Not used because this is a child cell, but still needs a value because the GC sees it.
      pNewCell->key = vPropertyName;
      pNewCell->value = vPropertyValue;

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

      TsArray* arr = DynamicPtr_decode_native(vm, vObjectValue);
      VirtualInt14 viLength = arr->viLength;
      VM_ASSERT(vm, Value_isVirtualInt14(viLength));
      uint16_t oldLength = VirtualInt14_decode(vm, viLength);
      DynamicPtr dpData = arr->dpData;
      uint16_t* pData = NULL;
      uint16_t oldCapacity = 0;
      if (dpData != VM_VALUE_NULL) {
        CODE_COVERAGE(544); // Hit
        VM_ASSERT(vm, Value_isShortPtr(dpData));
        pData = DynamicPtr_decode_native(vm, dpData);
        uint16_t dataSize = getAllocationSize(pData);
        oldCapacity = dataSize / 2;
      } else {
        CODE_COVERAGE(545); // Hit
      }

      // If the property name is "length" then we'll be changing the length
      if (vPropertyName == VM_VALUE_STR_LENGTH) {
        CODE_COVERAGE(282); // Hit

        if (!Value_isVirtualInt14(vPropertyValue))
          MVM_FATAL_ERROR(vm, MVM_E_TYPE_ERROR);
        uint16_t newLength = VirtualInt14_decode(vm, vPropertyValue);

        if (newLength < oldLength) { // Making array smaller
          CODE_COVERAGE(176); // Hit
          // pData will not be null because oldLength must be more than 1 for it to get here
          VM_ASSERT(vm, pData);
          // Wipe array items that aren't reachable
          uint16_t count = oldLength - newLength;
          uint16_t* p = &pData[newLength];
          while (count--)
            *p++ = VM_VALUE_DELETED;

          arr->viLength = VirtualInt14_encode(vm, newLength);
          return MVM_E_SUCCESS;
        } else if (newLength == oldLength) {
          CODE_COVERAGE_UNTESTED(546); // Not hit
          /* Do nothing */
        } else if (newLength <= oldCapacity) { // Array is getting bigger, but still less than capacity
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
        uint16_t index = VirtualInt14_decode(vm, vPropertyName);

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

        // By this point, the array should have expanded as necessary
        dpData = arr->dpData;
        VM_ASSERT(vm, dpData != VM_VALUE_NULL);
        VM_ASSERT(vm, Value_isShortPtr(dpData));
        pData = DynamicPtr_decode_native(vm, dpData);
        #if MVM_SAFE_MODE
          if (!pData) {
            VM_ASSERT(vm, false);
            return MVM_E_ASSERTION_FAILED;
          }
        #endif // MVM_SAFE_MODE

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
    default: return MVM_E_TYPE_ERROR;
  }
}

/** Converts the argument to either an TC_VAL_INT14 or a TC_REF_INTERNED_STRING, or gives an error */
static TeError toPropertyName(VM* vm, Value* value) {
  CODE_COVERAGE(50); // Hit
  // Property names in microvium are either integer indexes or non-integer interned strings
  TeTypeCode type = deepTypeOf(vm, *value);
  switch (type) {
    // These are already valid property names
    case TC_VAL_INT14: {
      CODE_COVERAGE(279); // Hit
      if (VirtualInt14_decode(vm, *value) < 0) {
        CODE_COVERAGE_UNTESTED(280); // Not hit
        return MVM_E_RANGE_ERROR;
      }
      CODE_COVERAGE(281); // Hit
      return MVM_E_SUCCESS;
    }
    case TC_REF_INTERNED_STRING: {
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

      // Note: In Microvium at the moment, it's illegal to use an integer-valued
      // string as a property name. If the string is in bytecode, it will only
      // have the type TC_REF_STRING if it's a number and is illegal.
      if (!Value_isShortPtr(*value)) {
        return MVM_E_TYPE_ERROR;
      }

      if (vm_ramStringIsNonNegativeInteger(vm, *value)) {
        CODE_COVERAGE_ERROR_PATH(378); // Not hit
        return MVM_E_TYPE_ERROR;
      } else {
        CODE_COVERAGE_UNTESTED(379); // Not hit
      }

      // Strings need to be converted to interned strings in order to be valid
      // property names. This is because properties are searched by reference
      // equality.
      *value = toInternedString(vm, *value);
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

// Converts a TC_REF_STRING to a TC_REF_INTERNED_STRING
// TODO: Test cases for this function
static Value toInternedString(VM* vm, Value value) {
  CODE_COVERAGE_UNTESTED(51); // Not hit
  VM_ASSERT(vm, deepTypeOf(vm, value) == TC_REF_STRING);

  // TC_REF_STRING values are always in GC memory. If they were in flash, they'd
  // already be TC_REF_INTERNED_STRING.
  char* pStr1 = DynamicPtr_decode_native(vm, value);
  uint16_t str1Size = getAllocationSize(pStr1);

  LongPtr lpStr1 = LongPtr_new(pStr1);
  // Note: the sizes here include the null terminator
  if ((str1Size == sizeof PROTO_STR) && (memcmp_long(lpStr1, LongPtr_new((void*)&PROTO_STR), sizeof PROTO_STR) == 0)) {
    CODE_COVERAGE_UNTESTED(547); // Not hit
    return VM_VALUE_STR_PROTO;
  } else if ((str1Size == sizeof LENGTH_STR) && (memcmp_long(lpStr1, LongPtr_new((void*)&LENGTH_STR), sizeof LENGTH_STR) == 0)) {
    CODE_COVERAGE_UNTESTED(548); // Not hit
    return VM_VALUE_STR_LENGTH;
  } else {
    CODE_COVERAGE_UNTESTED(549); // Not hit
  }

  LongPtr lpBytecode = vm->lpBytecode;

  // We start by searching the string table for interend strings that are baked
  // into the ROM. These are stored alphabetically, so we can perform a binary
  // search.

  uint16_t stringTableOffset = getSectionOffset(vm->lpBytecode, BCS_STRING_TABLE);
  uint16_t stringTableSize = getSectionOffset(vm->lpBytecode, sectionAfter(vm, BCS_STRING_TABLE)) - stringTableOffset;
  int strCount = stringTableSize / sizeof (Value);

  int first = 0;
  int last = strCount;
  int middle = (first + last) / 2;

  while (first <= last) {
    CODE_COVERAGE_UNTESTED(381); // Not hit
    uint16_t str2Offset = stringTableOffset + middle * 2;
    Value vStr2 = LongPtr_read2_aligned(LongPtr_add(lpBytecode, str2Offset));
    LongPtr lpStr2 = DynamicPtr_decode_long(vm, vStr2);
    uint16_t header = readAllocationHeaderWord_long(lpStr2);
    TeTypeCode tc = vm_getTypeCodeFromHeaderWord(header);
    VM_ASSERT(vm, tc == TC_REF_INTERNED_STRING);
    uint16_t str2Size = vm_getAllocationSizeExcludingHeaderFromHeaderWord(header);
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

  // At this point, we haven't found the interned string in the bytecode. We
  // need to check in RAM. Now we're comparing an in-RAM string against other
  // in-RAM strings. We're looking for an exact match, not performing a binary
  // search with inequality comparison, since the linked list of interned
  // strings in RAM is not sorted.
  Value vInternedStrings = getBuiltin(vm, BIN_INTERNED_STRINGS);
  VM_ASSERT(vm, (vInternedStrings == VM_VALUE_NULL) || Value_isShortPtr(vInternedStrings));
  Value spCell = vInternedStrings;
  while (spCell != VM_VALUE_NULL) {
    CODE_COVERAGE_UNTESTED(388); // Not hit
    VM_ASSERT(vm, Value_isShortPtr(spCell));
    TsInternedStringCell* pCell = ShortPtr_decode(vm, spCell);
    Value vStr2 = pCell->str;
    char* pStr2 = ShortPtr_decode(vm, vStr2);
    uint16_t str2Header = readAllocationHeaderWord(pStr2);
    uint16_t str2Size = vm_getAllocationSizeExcludingHeaderFromHeaderWord(str2Header);

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
    } else {
      CODE_COVERAGE_UNTESTED(550); // Not hit
    }
    spCell = pCell->spNext;
    TABLE_COVERAGE(spCell ? 1 : 0, 2, 551); // Not hit
  }

  // If we get here, it means there was no matching interned string already
  // existing in ROM or RAM. We upgrade the current string to a
  // TC_REF_INTERNED_STRING, since we now know it doesn't conflict with any existing
  // existing interned strings.
  setHeaderWord(vm, pStr1, TC_REF_INTERNED_STRING, str1Size);

  // Add the string to the linked list of interned strings
  TsInternedStringCell* pCell = GC_ALLOCATE_TYPE(vm, TsInternedStringCell, TC_REF_INTERNAL_CONTAINER);
  // Push onto linked list2
  pCell->spNext = vInternedStrings;
  pCell->str = value;
  setBuiltin(vm, BIN_INTERNED_STRINGS, ShortPtr_encode(vm, pCell));

  return value;
}

static int memcmp_long(LongPtr p1, LongPtr p2, size_t size) {
  CODE_COVERAGE_UNTESTED(471); // Not hit
  return MVM_LONG_MEM_CMP(p1, p2, size);
}

static void memcpy_long(void* target, LongPtr source, size_t size) {
  CODE_COVERAGE(9); // Hit
  MVM_LONG_MEM_CPY(target, source, size);
}

/** Size of string excluding bonus null terminator */
static uint16_t vm_stringSizeUtf8(VM* vm, Value stringValue) {
  CODE_COVERAGE(53); // Hit
  LongPtr lpStr = DynamicPtr_decode_long(vm, stringValue);
  uint16_t headerWord = readAllocationHeaderWord_long(lpStr);
  TeTypeCode typeCode = vm_getTypeCodeFromHeaderWord(headerWord);
  if (typeCode == TC_VAL_STR_PROTO) {
    CODE_COVERAGE_UNTESTED(552); // Not hit
    return 9;
  } else {
    CODE_COVERAGE(553); // Hit
  }
  if (typeCode == TC_VAL_STR_LENGTH) return 6;
  VM_ASSERT(vm, (typeCode == TC_REF_STRING) || (typeCode == TC_REF_INTERNED_STRING));
  return vm_getAllocationSizeExcludingHeaderFromHeaderWord(headerWord) - 1;
}

/**
 * Checks if a string contains only decimal digits (and is not empty). May only
 * be called on TC_REF_STRING and only those in GC memory.
 */
static bool vm_ramStringIsNonNegativeInteger(VM* vm, Value str) {
  CODE_COVERAGE_UNTESTED(55); // Not hit
  VM_ASSERT(vm, deepTypeOf(vm, str) == TC_REF_STRING);

  char* pStr = ShortPtr_decode(vm, str);

  // Length excluding bonus null terminator
  uint16_t len = getAllocationSize(pStr) - 1;
  char* p = pStr;
  if (!len) {
    CODE_COVERAGE_UNTESTED(554); // Not hit
    return false;
  } else {
    CODE_COVERAGE_UNTESTED(555); // Not hit
  }
  while (len--) {
    CODE_COVERAGE_UNTESTED(398); // Not hit
    if (!isdigit(*p++)) {
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
    MVM_CASE_CONTIGUOUS(TC_REF_INTERNED_STRING): {
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
      CODE_COVERAGE(408); // Hit
      return MVM_E_NAN;
    }
    MVM_CASE_CONTIGUOUS(TC_REF_HOST_FUNC): {
      CODE_COVERAGE_UNTESTED(409); // Not hit
      return MVM_E_NAN;
    }
    MVM_CASE_CONTIGUOUS(TC_REF_CLOSURE): {
      CODE_COVERAGE_UNTESTED(410); // Not hit
      return MVM_E_NAN;
    }
    MVM_CASE_CONTIGUOUS(TC_REF_RESERVED_1B): {
      CODE_COVERAGE_UNTESTED(411); // Not hit
      VM_RESERVED(vm); break;
    }
    MVM_CASE_CONTIGUOUS(TC_REF_VIRTUAL): {
      CODE_COVERAGE_UNTESTED(632); // Not hit
      VM_RESERVED(vm); break;
    }
    MVM_CASE_CONTIGUOUS(TC_REF_CLASS): {
      CODE_COVERAGE_UNTESTED(633); // Not hit
      return MVM_E_NAN;
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
    default:
      VM_ASSERT_UNREACHABLE(vm);
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
    CODE_COVERAGE(421); // Hit
    return 0;
  } else if (err == MVM_E_NEG_ZERO) {
    CODE_COVERAGE_UNTESTED(422); // Not hit
    return 0;
  } else {
    CODE_COVERAGE_UNTESTED(423); // Not hit
  }

  VM_ASSERT(vm, deepTypeOf(vm, value) == TC_REF_FLOAT64);
  #if MVM_SUPPORT_FLOAT
    return (int32_t)mvm_toFloat64(vm, value);
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
  LongPtr lpFloat = DynamicPtr_decode_long(vm, value);
  MVM_FLOAT64 f;
  memcpy_long(&f, lpFloat, sizeof f);
  return f;
}
#endif // MVM_SUPPORT_FLOAT

// See implementation of mvm_equal for the meaning of each
typedef enum TeEqualityAlgorithm {
  EA_NONE,
  EA_COMPARE_PTR_VALUE_AND_TYPE,
  EA_COMPARE_NON_PTR_TYPE,
  EA_COMPARE_REFERENCE,
  EA_NOT_EQUAL,
  EA_COMPARE_STRING,
} TeEqualityAlgorithm;

static const TeEqualityAlgorithm equalityAlgorithmByTypeCode[TC_END] = {
  EA_NONE,                       // TC_REF_TOMBSTONE          = 0x0
  EA_COMPARE_PTR_VALUE_AND_TYPE, // TC_REF_INT32              = 0x1
  EA_COMPARE_PTR_VALUE_AND_TYPE, // TC_REF_FLOAT64            = 0x2
  EA_COMPARE_STRING,             // TC_REF_STRING             = 0x3
  EA_COMPARE_STRING,             // TC_REF_INTERNED_STRING    = 0x4
  EA_COMPARE_REFERENCE,          // TC_REF_FUNCTION           = 0x5
  EA_COMPARE_PTR_VALUE_AND_TYPE, // TC_REF_HOST_FUNC          = 0x6
  EA_COMPARE_PTR_VALUE_AND_TYPE, // TC_REF_BIG_INT            = 0x7
  EA_COMPARE_REFERENCE,          // TC_REF_SYMBOL             = 0x8
  EA_NONE,                       // TC_REF_RESERVED_1         = 0x9
  EA_NONE,                       // TC_REF_RESERVED_2         = 0xA
  EA_NONE,                       // TC_REF_INTERNAL_CONTAINER = 0xB
  EA_COMPARE_REFERENCE,          // TC_REF_PROPERTY_LIST      = 0xC
  EA_COMPARE_REFERENCE,          // TC_REF_ARRAY              = 0xD
  EA_COMPARE_REFERENCE,          // TC_REF_FIXED_LENGTH_ARRAY = 0xE
  EA_COMPARE_REFERENCE,          // TC_REF_CLOSURE            = 0xF
  EA_COMPARE_NON_PTR_TYPE,       // TC_VAL_INT14              = 0x10
  EA_COMPARE_NON_PTR_TYPE,       // TC_VAL_UNDEFINED          = 0x11
  EA_COMPARE_NON_PTR_TYPE,       // TC_VAL_NULL               = 0x12
  EA_COMPARE_NON_PTR_TYPE,       // TC_VAL_TRUE               = 0x13
  EA_COMPARE_NON_PTR_TYPE,       // TC_VAL_FALSE              = 0x14
  EA_NOT_EQUAL,                  // TC_VAL_NAN                = 0x15
  EA_COMPARE_NON_PTR_TYPE,       // TC_VAL_NEG_ZERO           = 0x16
  EA_NONE,                       // TC_VAL_DELETED            = 0x17
  EA_COMPARE_STRING,             // TC_VAL_STR_LENGTH         = 0x18
  EA_COMPARE_STRING,             // TC_VAL_STR_PROTO          = 0x19
};

bool mvm_equal(mvm_VM* vm, mvm_Value a, mvm_Value b) {
  CODE_COVERAGE(462); // Hit

  TeTypeCode aType = deepTypeOf(vm, a);
  TeTypeCode bType = deepTypeOf(vm, b);
  TeEqualityAlgorithm algorithmA = equalityAlgorithmByTypeCode[aType];
  TeEqualityAlgorithm algorithmB = equalityAlgorithmByTypeCode[bType];

  TABLE_COVERAGE(algorithmA, 6, 556); // Hit 4/6
  TABLE_COVERAGE(algorithmB, 6, 557); // Hit 4/6
  TABLE_COVERAGE(aType, TC_END, 558); // Hit 5/26
  TABLE_COVERAGE(bType, TC_END, 559); // Hit 6/26

  // If the values aren't even in the same class of comparison, they're not
  // equal. In particular, strings will not be equal to non-strings.
  if (algorithmA != algorithmB) {
    CODE_COVERAGE(560); // Hit
    return false;
  } else {
    CODE_COVERAGE(561); // Hit
  }

  if (algorithmA == EA_NOT_EQUAL) {
    CODE_COVERAGE(562); // Hit
    return false; // E.g. comparing NaN
  } else {
    CODE_COVERAGE(563); // Hit
  }

  if (a == b) {
    CODE_COVERAGE(564); // Hit
    return true;
  } else {
    CODE_COVERAGE(565); // Hit
  }

  switch (algorithmA) {
    case EA_COMPARE_REFERENCE: {
      // Reference equality comparison assumes that two values with different
      // locations in memory must be different values, since their identity is
      // their address. Since we've already checked `a == b`, this must be false.
      return false;
    }
    case EA_COMPARE_NON_PTR_TYPE: {
      // Non-pointer types are those like Int14 and the well-known values
      // (except NaN). These can just be compared with `a == b`, which we've
      // already done.
      return false;
    }

    case EA_COMPARE_STRING: {
      // Strings are a pain to compare because there are edge cases like the
      // fact that the string "length" _may_ be represented by
      // VM_VALUE_STR_LENGTH rather than a pointer to a string (or it may be a
      // TC_REF_STRING). To keep the code concise, I'm fetching a pointer to the
      // string data itself and then comparing that. This is the only equality
      // algorithm that doesn't check the type. It makes use of the check for
      // `algorithmA != algorithmB` from earlier and the fact that only strings
      // compare with this algorithm, which means we won't get to this point
      // unless both `a` and `b` are strings.
      if (a == b) {
        CODE_COVERAGE_UNTESTED(566); // Not hit
        return true;
      } else {
        CODE_COVERAGE(567); // Hit
      }
      size_t sizeA;
      size_t sizeB;
      LongPtr lpStrA = vm_toStringUtf8_long(vm, a, &sizeA);
      LongPtr lpStrB = vm_toStringUtf8_long(vm, b, &sizeB);
      bool result = (sizeA == sizeB) && memcmp_long(lpStrA, lpStrB, (uint16_t)sizeA);
      TABLE_COVERAGE(result ? 1 : 0, 2, 568); // Hit 1/2
      return result;
    }

    /*
    Compares two values that are both pointer values that point to non-reference
    types (e.g. int32). These will be equal if the value pointed to has the same
    type, the same size, and the raw data pointed to is the same.
    */
    case EA_COMPARE_PTR_VALUE_AND_TYPE: {
      CODE_COVERAGE_UNTESTED(475); // Not hit

      if (a == b) {
        CODE_COVERAGE_UNTESTED(569); // Not hit
        return true;
      } else {
        CODE_COVERAGE_UNTESTED(570); // Not hit
      }
      if (aType != bType) {
        CODE_COVERAGE_UNTESTED(571); // Not hit
        return false;
      } else {
        CODE_COVERAGE_UNTESTED(572); // Not hit
        }

      LongPtr lpA = DynamicPtr_decode_long(vm, a);
      LongPtr lpB = DynamicPtr_decode_long(vm, b);
      uint16_t aHeaderWord = readAllocationHeaderWord_long(lpA);
      uint16_t bHeaderWord = readAllocationHeaderWord_long(lpB);
      // If the header words are different, the sizes or types are different
      if (aHeaderWord != bHeaderWord) {
        CODE_COVERAGE_UNTESTED(476); // Not hit
        return false;
      } else {
        CODE_COVERAGE_UNTESTED(477); // Not hit
      }
      uint16_t size = vm_getAllocationSizeExcludingHeaderFromHeaderWord(aHeaderWord);
      if (memcmp_long(lpA, lpB, size) == 0) {
        CODE_COVERAGE_UNTESTED(481); // Not hit
        return true;
      } else {
        CODE_COVERAGE_UNTESTED(482); // Not hit
        return false;
      }
    }

    default: {
      VM_ASSERT_UNREACHABLE(vm);
      return false;
    }
  }
}

bool mvm_isNaN(mvm_Value value) {
  CODE_COVERAGE_UNTESTED(573); // Not hit
  return value == VM_VALUE_NAN;
}

static void sanitizeArgs(VM* vm, Value* args, uint8_t argCount) {
  CODE_COVERAGE(574); // Hit
  /*
  It's important that we don't leak object pointers into the host because static
  analysis optimization passes need to be able to perform unambiguous alias
  analysis, and we don't yet have a standard ABI for allowing the host to
  interact with objects in a way that works with these kinds of optimizers
  (maybe in future).
  */
  Value* arg = args;
  while (argCount--) {
    CODE_COVERAGE(575); // Hit
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

#if MVM_INCLUDE_SNAPSHOT_CAPABILITY

// Opposite of loadPtr. Called during snapshotting
static void serializePtr(VM* vm, Value* pv) {
  CODE_COVERAGE(576); // Hit
  Value v = *pv;
  if (!Value_isShortPtr(v)) {
    CODE_COVERAGE(577); // Hit
    return;
  } else {
    CODE_COVERAGE(578); // Hit
  }
  void* p = ShortPtr_decode(vm, v);

  // Pointers are encoded as an offset in the heap
  uint16_t offsetInHeap = pointerOffsetInHeap(vm, vm->pLastBucket, p);

  // The lowest bit must be zero so that this is tagged as a "ShortPtr".
  VM_ASSERT(vm, (offsetInHeap & 1) == 0);

  *pv = offsetInHeap;
}

// The opposite of `loadPointers`
static void serializePointers(VM* vm, mvm_TsBytecodeHeader* bc) {
  CODE_COVERAGE(579); // Hit
  // CAREFUL! This function mutates `bc`, not `vm`.

  uint16_t n;
  uint16_t* p;

  uint16_t heapOffset = bc->sectionOffsets[BCS_HEAP];
  uint16_t heapSize = bc->bytecodeSize - heapOffset;

  uint16_t* pGlobals = (uint16_t*)((uint8_t*)bc + bc->sectionOffsets[BCS_GLOBALS]);
  uint16_t* heapMemory = (uint16_t*)((uint8_t*)bc + heapOffset);

  // Roots in global variables
  uint16_t globalsSize = bc->sectionOffsets[BCS_GLOBALS + 1] - bc->sectionOffsets[BCS_GLOBALS];
  p = pGlobals;
  n = globalsSize / 2;
  TABLE_COVERAGE(n ? 1 : 0, 2, 580); // Hit 1/2
  while (n--) {
    serializePtr(vm, p++);
  }

  // Pointers in heap memory
  p = heapMemory;
  uint16_t* heapEnd = (uint16_t*)((uint8_t*)heapMemory + heapSize);
  while (p < heapEnd) {
    CODE_COVERAGE(581); // Hit
    uint16_t header = *p++;
    uint16_t size = vm_getAllocationSizeExcludingHeaderFromHeaderWord(header);
    uint16_t words = (size + 1) / 2;
    TeTypeCode tc = vm_getTypeCodeFromHeaderWord(header);

    if (tc < TC_REF_DIVIDER_CONTAINER_TYPES) { // Non-container types
      CODE_COVERAGE(582); // Hit
      p += words;
      continue;
    } else {
      // Else, container types
      CODE_COVERAGE(583); // Hit
    }

    while (words--) {
      if (Value_isShortPtr(*p))
        serializePtr(vm, p);
      p++;
    }
  }
}

void* mvm_createSnapshot(mvm_VM* vm, size_t* out_size) {
  CODE_COVERAGE(503); // Hit
  if (out_size)
    *out_size = 0;

  uint16_t heapOffset = getSectionOffset(vm->lpBytecode, BCS_HEAP);
  uint16_t heapSize = getHeapSize(vm);

  // This assumes that the heap is the last section in the bytecode. Since the
  // heap is the only part of the bytecode image that changes size, we can just
  // calculate the new bytecode size as follows
  VM_ASSERT(vm, BCS_HEAP == BCS_SECTION_COUNT - 1);
  uint32_t bytecodeSize = (uint32_t)heapOffset + heapSize;

  if (bytecodeSize > 0xFFFF) {
    CODE_COVERAGE_ERROR_PATH(584); // Not hit
    MVM_FATAL_ERROR(vm, MVM_E_SNAPSHOT_TOO_LARGE);
  } else {
    CODE_COVERAGE(585); // Hit
  }

  mvm_TsBytecodeHeader* pNewBytecode = malloc(bytecodeSize);
  if (!pNewBytecode) return NULL;

  // The globals and heap are the last parts of the image because they're the
  // only mutable sections
  VM_ASSERT(vm, BCS_GLOBALS == BCS_SECTION_COUNT - 2);
  uint16_t sizeOfConstantPart = getSectionOffset(vm->lpBytecode, BCS_GLOBALS);

  // The first part of the snapshot doesn't change between executions (except
  // some header fields, which we'll update later).
  memcpy_long(pNewBytecode, vm->lpBytecode, sizeOfConstantPart);

  // Snapshot the globals memory
  uint16_t sizeOfGlobals = getSectionSize(vm, BCS_GLOBALS);
  memcpy((uint8_t*)pNewBytecode + pNewBytecode->sectionOffsets[BCS_GLOBALS], vm->globals, sizeOfGlobals);

  // Snapshot heap memory

  TsBucket* pBucket = vm->pLastBucket;
  // Start at the end of the heap and work backwards, because buckets are linked
  // in reverse order. (Edit: actually, they're also linked forwards now, but I
  // might retract that at some point so I'll leave this with the backwards
  // iteration).
  uint8_t* pHeapStart = (uint8_t*)pNewBytecode + pNewBytecode->sectionOffsets[BCS_HEAP];
  uint8_t* pTarget = pHeapStart + heapSize;
  uint16_t cursor = heapSize;
  TABLE_COVERAGE(pBucket ? 1 : 0, 2, 586); // Hit 1/2
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
  pNewBytecode->bytecodeSize = bytecodeSize;

  // Convert pointers-to-RAM into their corresponding serialized form
  serializePointers(vm, pNewBytecode);

  uint16_t crcStartOffset = OFFSETOF(mvm_TsBytecodeHeader, crc) + sizeof pNewBytecode->crc;
  uint16_t crcSize = bytecodeSize - crcStartOffset;
  void* pCrcStart = (uint8_t*)pNewBytecode + crcStartOffset;
  pNewBytecode->crc = MVM_CALC_CRC16_CCITT(pCrcStart, crcSize);

  if (out_size) {
    CODE_COVERAGE(587); // Hit
    *out_size = bytecodeSize;
  }
  return (void*)pNewBytecode;
}
#endif // MVM_INCLUDE_SNAPSHOT_CAPABILITY

#if MVM_INCLUDE_DEBUG_CAPABILITY

void mvm_dbg_setBreakpoint(VM* vm, uint16_t bytecodeAddress) {
  CODE_COVERAGE_UNTESTED(588); // Not hit

  // These checks on the bytecode address are assertions rather than user faults
  // because the address is probably not manually computed by a user, it's
  // derived from some kind of debug symbol file. In a production environment,
  // setting a breakpoint on an address that's never executed (e.g. because it's
  // not executable) is not a VM failure.
  VM_ASSERT(vm, bytecodeAddress >= getSectionOffset(vm->lpBytecode, BCS_ROM));
  VM_ASSERT(vm, bytecodeAddress < getSectionOffset(vm->lpBytecode, sectionAfter(vm, BCS_ROM)));

  mvm_dbg_removeBreakpoint(vm, bytecodeAddress);
  TsBreakpoint* breakpoint = malloc(sizeof (TsBreakpoint));
  if (!breakpoint) {
    MVM_FATAL_ERROR(vm, MVM_E_MALLOC_FAIL);
    return;
  }
  breakpoint->bytecodeAddress = bytecodeAddress;
  // Add to linked-list
  breakpoint->next = vm->pBreakpoints;
  vm->pBreakpoints = breakpoint;
}

void mvm_dbg_removeBreakpoint(VM* vm, uint16_t bytecodeAddress) {
  CODE_COVERAGE_UNTESTED(589); // Not hit

  TsBreakpoint** ppBreakpoint = &vm->pBreakpoints;
  TsBreakpoint* pBreakpoint = *ppBreakpoint;
  while (pBreakpoint) {
    if (pBreakpoint->bytecodeAddress == bytecodeAddress) {
      CODE_COVERAGE_UNTESTED(590); // Not hit
      // Remove from linked list
      *ppBreakpoint = pBreakpoint->next;
      free(pBreakpoint);
      pBreakpoint = *ppBreakpoint;
    } else {
      CODE_COVERAGE_UNTESTED(591); // Not hit
      ppBreakpoint = &pBreakpoint->next;
      pBreakpoint = *ppBreakpoint;
    }
  }
}

void mvm_dbg_setBreakpointCallback(mvm_VM* vm, mvm_TfBreakpointCallback cb) {
  CODE_COVERAGE_UNTESTED(592); // Not hit
  // It doesn't strictly need to be null, but is probably a mistake if it's not.
  VM_ASSERT(vm, vm->breakpointCallback == NULL);
  vm->breakpointCallback = cb;
}

#endif // MVM_INCLUDE_DEBUG_CAPABILITY

/**
 * Test out the LONG_PTR macros provided in the port file. lpBytecode should
 * point to actual bytecode, whereas pHeader should point to a local copy that's
 * been validated.
 */
static TeError vm_validatePortFileMacros(MVM_LONG_PTR_TYPE lpBytecode, mvm_TsBytecodeHeader* pHeader) {
  uint32_t x1 = 0x12345678;
  uint32_t x2 = 0x12345678;
  uint32_t x3 = 0x87654321;
  uint32_t x4 = 0x99999999;
  uint32_t* px1 = &x1;
  uint32_t* px2 = &x2;
  uint32_t* px3 = &x3;
  uint32_t* px4 = &x4;
  MVM_LONG_PTR_TYPE lpx1 = MVM_LONG_PTR_NEW(px1);
  MVM_LONG_PTR_TYPE lpx2 = MVM_LONG_PTR_NEW(px2);
  MVM_LONG_PTR_TYPE lpx3 = MVM_LONG_PTR_NEW(px3);
  MVM_LONG_PTR_TYPE lpx4 = MVM_LONG_PTR_NEW(px4);

  if (!((MVM_LONG_PTR_TRUNCATE(lpx1)) == px1)) goto LBL_FAIL;
  if (!((MVM_READ_LONG_PTR_1(lpx1)) == 0x78)) goto LBL_FAIL;
  if (!((MVM_READ_LONG_PTR_2(lpx1)) == 0x5678)) goto LBL_FAIL;
  if (!((MVM_READ_LONG_PTR_1((MVM_LONG_PTR_ADD(lpx1, 1)))) == 0x56)) goto LBL_FAIL;
  if (!((MVM_LONG_PTR_SUB((MVM_LONG_PTR_ADD(lpx1, 3)), lpx1)) == 3)) goto LBL_FAIL;
  if (!((MVM_LONG_PTR_SUB(lpx1, (MVM_LONG_PTR_ADD(lpx1, 3)))) == -3)) goto LBL_FAIL;
  if (!((MVM_LONG_MEM_CMP(lpx1, lpx2, 4)) == 0)) goto LBL_FAIL;
  if (!((MVM_LONG_MEM_CMP(lpx1, lpx3, 4)) > 0)) goto LBL_FAIL;
  if (!((MVM_LONG_MEM_CMP(lpx1, lpx4, 4)) < 0)) goto LBL_FAIL;

  MVM_LONG_MEM_CPY(px4, lpx3, 4);
  if (!(x4 == 0x87654321)) goto LBL_FAIL;
  x4 = 0x99999999;

  // The above tests were testing the case of using a long pointer to point to
  // local RAM. We need to also test that everything works when point to the
  // actual bytecode. lpBytecode and pHeader should point to data of the same
  // value but in different address spaces (ROM and RAM respectively).

  if (!((MVM_READ_LONG_PTR_1(lpBytecode)) == pHeader->bytecodeVersion)) goto LBL_FAIL;
  if (!((MVM_READ_LONG_PTR_2(lpBytecode)) == *((uint16_t*)pHeader))) goto LBL_FAIL;
  if (!((MVM_READ_LONG_PTR_1((MVM_LONG_PTR_ADD(lpBytecode, 2)))) == pHeader->requiredEngineVersion)) goto LBL_FAIL;
  if (!((MVM_LONG_PTR_SUB((MVM_LONG_PTR_ADD(lpBytecode, 3)), lpBytecode)) == 3)) goto LBL_FAIL;
  if (!((MVM_LONG_PTR_SUB(lpBytecode, (MVM_LONG_PTR_ADD(lpBytecode, 3)))) == -3)) goto LBL_FAIL;
  if (!((MVM_LONG_MEM_CMP(lpBytecode, (MVM_LONG_PTR_NEW(pHeader)), 8)) == 0)) goto LBL_FAIL;

  if (MVM_NATIVE_POINTER_IS_16_BIT && (sizeof(void*) != 2)) return MVM_E_EXPECTED_POINTER_SIZE_TO_BE_16_BIT;
  if ((!MVM_NATIVE_POINTER_IS_16_BIT) && (sizeof(void*) == 2)) return MVM_E_EXPECTED_POINTER_SIZE_NOT_TO_BE_16_BIT;

  return MVM_E_SUCCESS;

LBL_FAIL:
  return MVM_E_PORT_FILE_MACRO_TEST_FAILURE;
}

uint16_t mvm_getCurrentAddress(VM* vm) {
  vm_TsStack* stack = vm->stack;
  if (!stack) return 0; // Not currently running
  LongPtr lpProgramCounter = stack->reg.lpProgramCounter;
  LongPtr lpBytecode = vm->lpBytecode;
  uint16_t address = (uint16_t)MVM_LONG_PTR_SUB(lpProgramCounter, lpBytecode);
  return address;
}

static Value vm_cloneFixedLengthArray(VM* vm, Value arr) {
  LongPtr lpSource = DynamicPtr_decode_long(vm, arr);
  uint16_t headerWord = readAllocationHeaderWord_long(lpSource);
  VM_ASSERT(vm, vm_getTypeCodeFromHeaderWord(headerWord) == TC_REF_FIXED_LENGTH_ARRAY);
  uint16_t size = vm_getAllocationSizeExcludingHeaderFromHeaderWord(headerWord);
  uint16_t* newScope = gc_allocateWithHeader(vm, size, TC_REF_FIXED_LENGTH_ARRAY);

  uint16_t* pTarget = newScope;
  while (size) {
    *pTarget++ = LongPtr_read2_aligned(lpSource);
    lpSource = LongPtr_add(lpSource, 2);
    size -= 2;
  }

  return ShortPtr_encode(vm, newScope);
}