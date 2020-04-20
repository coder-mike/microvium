#include "microvium.h"

#include "microvium_internals.h"
#include "math.h"

static void vm_readMem(vm_VM* vm, void* target, vm_Pointer source, uint16_t size);
static void vm_writeMem(vm_VM* vm, vm_Pointer target, void* source, uint16_t size);

static bool vm_isHandleInitialized(vm_VM* vm, const vm_Handle* handle);
static void* vm_deref(vm_VM* vm, vm_Value pSrc);
static inline vm_Value vm_makeValue(uint16_t tag, uint16_t value);
static inline void vm_checkReleaseStack(vm_VM* vm);
static vm_TeError vm_run(vm_VM* vm);
static void vm_push(vm_VM* vm, uint16_t value);
static uint16_t vm_pop(vm_VM* vm);
static vm_TeError vm_setupCallFromExternal(vm_VM* vm, vm_Value func, vm_Value* args, uint8_t argCount);
static vm_Value vm_binOp1(vm_VM* vm, vm_TeBinOp1 op, vm_Value left, vm_Value right);
static vm_Value vm_binOp2(vm_VM* vm, vm_TeBinOp2 op, vm_Value left, vm_Value right);
static vm_Value vm_unOp(vm_VM* vm, vm_TeUnOp op, vm_Value arg);
static vm_Value vm_convertToString(vm_VM* vm, vm_Value value);
static vm_Value vm_concat(vm_VM* vm, vm_Value left, vm_Value right);
static vm_Value vm_convertToNumber(vm_VM* vm, vm_Value value);
static vm_Value vm_addNumbersSlow(vm_VM* vm, vm_Value left, vm_Value right);
static vm_TeTypeCode vm_deepTypeOf(vm_VM* vm, vm_Value value);
static bool vm_isString(vm_VM* vm, vm_Value value);
static VM_DOUBLE vm_readDouble(vm_VM* vm, vm_TeTypeCode type, vm_Value value);
static int32_t vm_readInt32(vm_VM* vm, vm_TeTypeCode type, vm_Value value);
static inline vm_HeaderWord vm_readHeaderWord(vm_VM* vm, vm_Pointer pAllocation);
static inline uint16_t vm_readUInt16(vm_VM* vm, vm_Pointer p);
static vm_TeError vm_resolveExport(vm_VM* vm, vm_VMExportID id, vm_Value* result);
static void vm_abortRun(vm_VM* vm, vm_TeError errorCode);
static inline vm_TfHostFunction* vm_getResolvedImports(vm_VM* vm);
static inline uint16_t vm_getResolvedImportCount(vm_VM* vm);
static vm_TeTypeCode vm_shallowTypeCode(vm_Value value);
static vm_TeError vm_stringSizeUtf8(vm_VM* vm, vm_Value stringValue, size_t* out_size);
static void gc_createNextBucket(vm_VM* vm, uint16_t bucketSize);
static vm_Value gc_allocate(vm_VM* vm, uint16_t sizeBytes, vm_TeTypeCode typeCode, uint16_t headerVal2, void** out_target);
static void gc_markAllocation(uint16_t* markTable, GO_t p, uint16_t size);
static void gc_traceValue(vm_VM* vm, uint16_t* markTable, vm_Value value, uint16_t* pTotalSize);
static inline void gc_updatePointer(vm_VM* vm, uint16_t* pWord, uint16_t* markTable, uint16_t* offsetTable);
static inline bool gc_isMarked(uint16_t* markTable, vm_Pointer ptr);
static void gc_freeGCMemory(vm_VM* vm);
static void gc_readMem(vm_VM* vm, void* target, GO_t src, uint16_t size);
static void* gc_deref(vm_VM* vm, GO_t pSrc);

const vm_Value vm_undefined = VM_VALUE_UNDEFINED;
const vm_Value vm_null = VM_VALUE_NULL;

static inline vm_TeTypeCode vm_typeCodeFromHeaderWord(vm_HeaderWord headerWord) {
  return headerWord >> 12;
}

static inline uint16_t vm_paramOfHeaderWord(vm_HeaderWord headerWord) {
  return headerWord & 0xFFF;
}

static inline vm_Value vm_unbox(vm_VM* vm, vm_Pointer boxed) {
  return vm_readUInt16(vm, boxed);
}

static vm_TeTypeCode vm_shallowTypeCode(vm_Value value) {
  uint16_t tag = VM_TAG_OF(value);
  if (tag == VM_TAG_INT) return VM_TC_INT14;
  if (tag == VM_TAG_PGM_P) {
    if (value < VM_VALUE_MAX_WELLKNOWN)
      return value - VM_TAG_PGM_P;
  }
  return VM_TC_POINTER;
}

vm_TeError vm_restore(vm_VM** result, VM_PROGMEM_P pBytecode, size_t bytecodeSize, void* context, vm_TfResolveImport resolveImport) {
  #if VM_SAFE_MODE
    uint16_t x = 0x4243;
    bool isLittleEndian = ((uint8_t*)&x)[0] == 0x43;
    VM_ASSERT(NULL, isLittleEndian);
  #endif
  // TODO(low): CRC validation on input code

  vm_TeError err = VM_E_SUCCESS;
  vm_VM* vm = NULL;

  // Bytecode size field is located at the second word
  if (bytecodeSize < 4) return VM_E_INVALID_BYTECODE;
  uint16_t expectedBytecodeSize;
  VM_READ_BC_HEADER_FIELD(&expectedBytecodeSize, bytecodeSize, pBytecode);
  if (bytecodeSize != expectedBytecodeSize) return VM_E_INVALID_BYTECODE;
  uint8_t headerSize;
  VM_READ_BC_HEADER_FIELD(&headerSize, headerSize, pBytecode);
  if (bytecodeSize < headerSize) return VM_E_INVALID_BYTECODE;
  // For the moment we expect an exact header size
  if (headerSize != sizeof (vm_TsBytecodeHeader)) return VM_E_INVALID_BYTECODE;

  uint8_t bytecodeVersion;
  VM_READ_BC_HEADER_FIELD(&bytecodeVersion, bytecodeVersion, pBytecode);
  if (bytecodeVersion != VM_BYTECODE_VERSION) return VM_E_INVALID_BYTECODE;

  uint16_t importTableOffset;
  uint16_t importTableSize;
  uint16_t dataMemorySize;
  VM_READ_BC_HEADER_FIELD(&dataMemorySize, dataMemorySize, pBytecode);
  VM_READ_BC_HEADER_FIELD(&importTableOffset, importTableOffset, pBytecode);
  VM_READ_BC_HEADER_FIELD(&importTableSize, importTableSize, pBytecode);

  uint16_t importCount = importTableSize / sizeof (vm_TsImportTableEntry);

  size_t allocationSize = sizeof(vm_VM) +
    sizeof(vm_TfHostFunction) * importCount +  // Import table
    dataMemorySize; // Data memory (globals)
  vm = malloc(allocationSize);
  if (!vm) {
    err = VM_E_MALLOC_FAIL;
    goto EXIT;
  }
  #if VM_SAFE_MODE
    memset(vm, 0, allocationSize);
  #else
    memset(vm, 0, sizeof (vm_VM));
  #endif
  vm_TfHostFunction* resolvedImports = vm_getResolvedImports(vm);
  vm->context = context;
  vm->pBytecode = pBytecode;
  vm->dataMemory = (void*)(resolvedImports + importCount);

  // Resolve imports (linking)
  vm_TfHostFunction* resolvedImport = resolvedImports;
  for (int i = 0; i < importCount; i++) {
    uint16_t importTableEntry = importTableOffset + i * sizeof (vm_TsImportTableEntry);
    vm_HostFunctionID hostFunctionID;
    VM_READ_BC_FIELD(&hostFunctionID, hostFunctionID, importTableEntry, vm_TsImportTableEntry, pBytecode);
    vm_TfHostFunction handler = NULL;
    err = resolveImport(hostFunctionID, context, &handler);
    if (err != VM_E_SUCCESS) goto EXIT;
    if (!handler) {
      err = VM_E_UNRESOLVED_IMPORT;
      goto EXIT;
    }
    *resolvedImport++ = handler;
  }

  // The GC is empty to start
  gc_freeGCMemory(vm);

  // Initialize data
  uint16_t initialDataOffset;
  uint16_t initialDataSize;
  VM_READ_BC_HEADER_FIELD(&initialDataOffset, initialDataOffset, pBytecode);
  VM_READ_BC_HEADER_FIELD(&initialDataSize, initialDataSize, pBytecode);
  uint16_t* dataMemory = vm->dataMemory;
  VM_ASSERT(vm, initialDataSize <= dataMemorySize);
  VM_READ_PROGMEM(dataMemory, VM_PROGMEM_P_ADD(pBytecode, initialDataOffset), initialDataSize);

  // Initialize heap
  uint16_t initialHeapOffset;
  uint16_t initialHeapSize;
  VM_READ_BC_HEADER_FIELD(&initialHeapOffset, initialHeapOffset, pBytecode);
  VM_READ_BC_HEADER_FIELD(&initialHeapSize, initialHeapSize, pBytecode);
  if (initialHeapSize) {
    gc_createNextBucket(vm, initialHeapSize);
    VM_ASSERT(vm, !vm->gc_lastBucket->prev); // Only one bucket
    uint8_t* heapStart = vm->pAllocationCursor;
    VM_READ_PROGMEM(heapStart, VM_PROGMEM_P_ADD(pBytecode, initialHeapOffset), initialHeapSize);
    vm->gc_allocationCursor += initialHeapSize;
    vm->pAllocationCursor += initialHeapSize;
  }

EXIT:
  if (err != VM_E_SUCCESS) {
    *result = NULL;
    if (vm) {
      free(vm);
      vm = NULL;
    }
  }
  *result = vm;
  return err;
}

void* vm_getContext(vm_VM* vm) {
  return vm->context;
}

static vm_TeError vm_run(vm_VM* vm) {
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
    else result = vm_toBool(vm, value); \
  } while (false)

  #define READ_PGM(pTarget, size) do { \
    VM_READ_PROGMEM(pTarget, programCounter, size); \
    programCounter = VM_PROGMEM_P_ADD(programCounter, size); \
  } while (false)

  #define PUSH(v) *(pStackPointer++) = v
  #define POP() (*(--pStackPointer))
  #define INSTRUCTION_RESERVED() VM_ASSERT(vm, false)

  // TODO(low): I'm not sure that these variables should be cached for the whole duration of vm_run rather than being calculated on demand
  vm_TsRegisters* reg = &vm->stack->reg;
  uint16_t* bottomOfStack = VM_BOTTOM_OF_STACK(vm);
  VM_PROGMEM_P pBytecode = vm->pBytecode;
  vm_TeError err = VM_E_SUCCESS;

  register VM_PROGMEM_P programCounter;
  register uint16_t* pStackPointer;
  register uint16_t* pFrameBase;
  register uint16_t argCount;
  CACHE_REGISTERS();

  VM_EXEC_SAFE_MODE(
    vm->pBytecode;
    uint16_t bytecodeSize;
    uint16_t stringTableSize;
    uint16_t stringTableOffset;
    VM_READ_BC_HEADER_FIELD(&bytecodeSize, bytecodeSize, vm->pBytecode);
    VM_READ_BC_HEADER_FIELD(&stringTableOffset, stringTableOffset, vm->pBytecode);
    VM_READ_BC_HEADER_FIELD(&stringTableSize, stringTableSize, vm->pBytecode);

    // It's an implementation detail that no code starts before the end of the string table
    VM_PROGMEM_P minProgramCounter = VM_PROGMEM_P_ADD(vm->pBytecode, (stringTableOffset + stringTableSize));
    VM_PROGMEM_P maxProgramCounter = VM_PROGMEM_P_ADD(vm->pBytecode, bytecodeSize);
  )

  // TODO(low): I think we need unit tests that explicitly test that every instruction is implemented and has the correct behavior

  while (true) {
    // Set to a "bad" value in case we accidentally use it
    VM_EXEC_SAFE_MODE({
      param1 = 0x7F;
      param2 = 0x7F;
      u8Param3 = 0x7F;
      s16Param3 = 0x7FFF;
      u16Param3 = 0x7FFF;
      callTargetFunctionOffset = 0x7FFF;
      callTargetHostFunctionIndex = 0x7FFF;
      callArgCount = 0x7F;
      branchOffset = 0x7F;
      jumpOffset = 0x7FFF;
    })

    // Check that we're still in range of the bytecode
    VM_ASSERT(vm, programCounter >= minProgramCounter);
    VM_ASSERT(vm, programCounter < maxProgramCounter);

    uint8_t temp;
    READ_PGM(&temp, 1);
    param1 = temp >> 4;
    param2 = temp & 0xF;

    switch (param1) {
      case VM_OP_LOAD_SMALL_LITERAL: { // (+ 4-bit vm_TeSmallLiteralValue)
        vm_Value v;
        switch (param2) {
          case VM_SLV_NULL        : v = VM_VALUE_NULL; break;
          case VM_SLV_UNDEFINED   : v = VM_VALUE_UNDEFINED; break;
          case VM_SLV_FALSE       : v = VM_VALUE_FALSE; break;
          case VM_SLV_TRUE        : v = VM_VALUE_TRUE; break;
          case VM_SLV_EMPTY_STRING: v = VM_VALUE_EMPTY_STRING; break;
          case VM_SLV_INT_0       : v = VM_TAG_INT | 0; break;
          case VM_SLV_INT_1       : v = VM_TAG_INT | 1; break;
          case VM_SLV_INT_2       : v = VM_TAG_INT | 2; break;
          case VM_SLV_INT_MINUS_1 : v = VM_TAG_INT | ((uint16_t)(-1) & VM_VALUE_MASK); break;
          default: VM_UNEXPECTED_INTERNAL_ERROR(vm); break;
        }
        PUSH(v);
        break;
      }

      case VM_OP_LOAD_VAR_1: PUSH(pStackPointer[-param2 - 1]); break;
      case VM_OP_STORE_VAR_1: pStackPointer[-param2 - 2] = POP(); break;
      case VM_OP_LOAD_GLOBAL_1: PUSH(vm->dataMemory[param2]); break; // TODO(low): Range checking on globals
      case VM_OP_STORE_GLOBAL_1: vm->dataMemory[param2] = POP(); break;
      case VM_OP_LOAD_ARG_1: PUSH(param2 < argCount ? pFrameBase[- 3 - argCount + param2] : VM_VALUE_UNDEFINED); break;

      case VM_OP_POP: {
        uint8_t popCount = param2;
        pStackPointer -= popCount;
        break;
      }

      case VM_OP_CALL_1: { // (+ 4-bit index into short-call table)
        uint16_t shortCallTableOffset;
        VM_READ_BC_HEADER_FIELD(&shortCallTableOffset, shortCallTableOffset, pBytecode);
        uint16_t shortCallTableEntry = shortCallTableOffset + param2 * sizeof (vm_TsShortCallTableEntry);
        uint8_t tempArgCount;
        uint16_t tempFunction;
        VM_READ_BC_FIELD(&tempArgCount, argCount, shortCallTableEntry, vm_TsShortCallTableEntry, pBytecode);
        VM_READ_BC_FIELD(&tempFunction, function, shortCallTableEntry, vm_TsShortCallTableEntry, pBytecode);

        // The high bit of function indicates if this is a call to the host
        bool isHostCall = tempFunction & 0x8000;
        tempFunction = tempFunction & 0x7FFF;

        callArgCount = tempArgCount;

        if (isHostCall) {
          callTargetHostFunctionIndex = tempFunction;
          goto CALL_HOST_COMMON;

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
            vm_TfHostFunction hostFunction = vm_getResolvedImports(vm)[callTargetHostFunctionIndex];
            vm_Value result = VM_VALUE_UNDEFINED;
            vm_Value* args = pStackPointer - 3 - callArgCount;

            uint16_t importTableOffset;
            VM_READ_BC_HEADER_FIELD(&importTableOffset, importTableOffset, pBytecode);

            uint16_t importTableEntry = importTableOffset + callTargetHostFunctionIndex * sizeof (vm_TsImportTableEntry);
            vm_HostFunctionID hostFunctionID;
            VM_READ_BC_FIELD(&hostFunctionID, hostFunctionID, importTableEntry, vm_TsImportTableEntry, pBytecode);

            FLUSH_REGISTER_CACHE();
            err = hostFunction(vm, hostFunctionID, &result, args, callArgCount);
            if (err != VM_E_SUCCESS) goto EXIT;
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
        } else {
          callTargetFunctionOffset = tempFunction;
          goto CALL_COMMON;

          /*
           * CALL_COMMON
           *
           * Expects:
           *   callTargetFunctionOffset: offset of target function in bytecode
           *   callArgCount: number of arguments
           */
          CALL_COMMON: {
            uint8_t maxStackDepth;
            VM_READ_BC_FIELD(&maxStackDepth, maxStackDepth, callTargetFunctionOffset, vm_TsFunctionHeader, pBytecode);
            if (pStackPointer + maxStackDepth > VM_TOP_OF_STACK(vm)) {
              err = VM_E_STACK_OVERFLOW;
              goto EXIT;
            }

            // Save caller state
            PUSH(pFrameBase - bottomOfStack);
            PUSH(argCount);
            PUSH((uint16_t)VM_PROGMEM_P_SUB(programCounter, pBytecode));

            // Set up new frame
            pFrameBase = pStackPointer;
            argCount = callArgCount;
            programCounter = VM_PROGMEM_P_ADD(pBytecode, callTargetFunctionOffset + sizeof (vm_TsFunctionHeader));

            break;
          }
        }

        break;
      }

      case VM_OP_BINOP_1: {
        vm_Value right = POP();
        vm_Value left = POP();
        result = VM_VALUE_UNDEFINED;
        switch (param2) {
          case VM_BOP1_ADD: {
            if (((left & VM_TAG_MASK) == VM_TAG_INT) && ((right & VM_TAG_MASK) == VM_TAG_INT)) {
              result = left + right;
              if (result & VM_OVERFLOW_BIT) goto BIN_OP_1_SLOW;
            }
          }
          case VM_BOP1_SUBTRACT: VM_NOT_IMPLEMENTED(vm); break;
          case VM_BOP1_MULTIPLY: VM_NOT_IMPLEMENTED(vm); break;
          case VM_BOP1_DIVIDE_INT: VM_NOT_IMPLEMENTED(vm); break;
          case VM_BOP1_DIVIDE_FLOAT: VM_NOT_IMPLEMENTED(vm); break;
          case VM_BOP1_SHR_ARITHMETIC: VM_NOT_IMPLEMENTED(vm); break;
          case VM_BOP1_SHR_BITWISE: VM_NOT_IMPLEMENTED(vm); break;
          case VM_BOP1_SHL: VM_NOT_IMPLEMENTED(vm); break;
          case VM_BOP1_REMAINDER: VM_NOT_IMPLEMENTED(vm); break;
          default: VM_UNEXPECTED_INTERNAL_ERROR(vm); break;
        }
        PUSH(result);
        break;
      BIN_OP_1_SLOW:
        FLUSH_REGISTER_CACHE();
        result = vm_binOp1(vm, param2, left, right);
        CACHE_REGISTERS();
        PUSH(result);
        break;
      }

      case VM_OP_BINOP_2: {
        vm_Value right = POP();
        vm_Value left = POP();
        result = VM_VALUE_UNDEFINED;
        switch (param2) {
          case VM_BOP2_LESS_THAN: VM_NOT_IMPLEMENTED(vm); break;
          case VM_BOP2_GREATER_THAN: VM_NOT_IMPLEMENTED(vm); break;
          case VM_BOP2_LESS_EQUAL: VM_NOT_IMPLEMENTED(vm); break;
          case VM_BOP2_GREATER_EQUAL: VM_NOT_IMPLEMENTED(vm); break;
          case VM_BOP2_EQUAL: VM_NOT_IMPLEMENTED(vm); break;
          case VM_BOP2_NOT_EQUAL: VM_NOT_IMPLEMENTED(vm); break;
          case VM_BOP2_AND: VM_NOT_IMPLEMENTED(vm); break;
          case VM_BOP2_OR: VM_NOT_IMPLEMENTED(vm); break;
          default: VM_UNEXPECTED_INTERNAL_ERROR(vm); break;
        }
        PUSH(result);
        break;
      //BIN_OP_2_SLOW:
        FLUSH_REGISTER_CACHE();
        result = vm_binOp2(vm, param2, left, right);
        CACHE_REGISTERS();
        PUSH(result);
        break;
      }

      case VM_OP_UNOP: {
        vm_Value arg = POP();
        result = VM_VALUE_UNDEFINED;
        switch (param2) {
          case VM_OP_NEGATE: {
            // TODO(feature): This needs to handle the overflow case of -(-2000)
            VM_NOT_IMPLEMENTED(vm);
            if (!VM_IS_INT14(arg)) goto UN_OP_SLOW;
            result = (-VM_SIGN_EXTEND(arg)) & VM_VALUE_MASK;
            break;
          }
          case VM_OP_LOGICAL_NOT: {
            bool b;
            VALUE_TO_BOOL(b, arg);
            result = b ? VM_VALUE_FALSE : VM_VALUE_TRUE;
            break;
          }
          case VM_OP_BITWISE_NOT: VM_NOT_IMPLEMENTED(vm); break;
          default: VM_UNEXPECTED_INTERNAL_ERROR(vm); break;
        }
        break;
      UN_OP_SLOW:
        FLUSH_REGISTER_CACHE();
        result = vm_unOp(vm, param2, arg);
        CACHE_REGISTERS();
        PUSH(result);
        break;
      }

      case VM_OP_STRUCT_GET_1: INSTRUCTION_RESERVED(); break;
      case VM_OP_STRUCT_SET_1: INSTRUCTION_RESERVED(); break;

      case VM_OP_EXTENDED_1: {
        switch (param2) {
          case VM_OP1_RETURN_1:
          case VM_OP1_RETURN_2:
          case VM_OP1_RETURN_3:
          case VM_OP1_RETURN_4: {
            if (param2 & VM_RETURN_FLAG_UNDEFINED) result = VM_VALUE_UNDEFINED;
            else result = POP();

            uint16_t popArgCount = argCount;

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

          case VM_OP1_OBJECT_GET_1: INSTRUCTION_RESERVED(); break;
          case VM_OP1_OBJECT_SET_1: INSTRUCTION_RESERVED(); break;
          case VM_OP1_ASSERT: INSTRUCTION_RESERVED(); break;
          case VM_OP1_NOT_IMPLEMENTED: INSTRUCTION_RESERVED(); break;
          case VM_OP1_ILLEGAL_OPERATION: INSTRUCTION_RESERVED(); break;
          case VM_OP1_PRINT: INSTRUCTION_RESERVED(); break;
          case VM_OP1_ARRAY_GET: INSTRUCTION_RESERVED(); break;
          case VM_OP1_ARRAY_SET: INSTRUCTION_RESERVED(); break;

          case VM_OP1_EXTENDED_4: {
            // 1-byte instruction parameter
            uint8_t b;
            READ_PGM(&b, 1);
            switch (b) {
              case VM_OP4_CALL_DETACHED_EPHEMERAL: {
                VM_NOT_IMPLEMENTED(vm);
                break;
              }
              default: VM_UNEXPECTED_INTERNAL_ERROR(vm); break;
            }
          }

          default: VM_UNEXPECTED_INTERNAL_ERROR(vm); break;
        }
        break;
      }

      case VM_OP_EXTENDED_2: {
        // All the ex-2 instructions have an 8-bit parameter
        uint8_t temp;
        READ_PGM(&temp, 1);
        u8Param3 = temp;
        switch (param2) {
          case VM_OP2_BRANCH_1: {
            branchOffset = (int8_t)u8Param3; // Sign extend
            goto BRANCH_COMMON;

            /*
             * BRANCH_COMMON
             *
             * Expects:
             *   - branchOffset: the amount to jump by if the predicate is truthy
             */
            BRANCH_COMMON: {
              vm_Value predicate = POP();
              bool isTruthy;
              VALUE_TO_BOOL(isTruthy, predicate);
              if (isTruthy) programCounter = VM_PROGMEM_P_ADD(programCounter, branchOffset);
              break;
            }
          }
          case VM_OP2_JUMP_1: {
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

          case VM_OP2_CALL_HOST: {
            callTargetHostFunctionIndex = u8Param3;

            uint8_t t;
            READ_PGM(&t, 1);
            callArgCount = t;

            goto CALL_HOST_COMMON;
          }

          case VM_OP2_LOAD_GLOBAL_2: VM_NOT_IMPLEMENTED(vm); break;
          case VM_OP2_STORE_GLOBAL_2: VM_NOT_IMPLEMENTED(vm); break;
          case VM_OP2_LOAD_VAR_2: VM_NOT_IMPLEMENTED(vm); break;
          case VM_OP2_STORE_VAR_2: VM_NOT_IMPLEMENTED(vm); break;
          case VM_OP2_STRUCT_GET_2: INSTRUCTION_RESERVED(); break;
          case VM_OP2_STRUCT_SET_2: INSTRUCTION_RESERVED(); break;
          case VM_OP2_LOAD_ARG_2: INSTRUCTION_RESERVED(); break;
          case VM_OP2_STORE_ARG: INSTRUCTION_RESERVED(); break;

          case VM_OP2_CALL_3: {
            callArgCount = u8Param3;

            // The function was pushed before the arguments
            vm_Value functionValue = pStackPointer[-callArgCount - 1];

            vm_TeTypeCode typeCode = vm_shallowTypeCode(functionValue);
            if (typeCode != VM_TC_POINTER) {
              err = VM_E_TARGET_NOT_CALLABLE;
              goto EXIT;
            }

            uint16_t headerWord = vm_readHeaderWord(vm, functionValue);
            typeCode = vm_typeCodeFromHeaderWord(headerWord);
            if (typeCode == VM_TC_FUNCTION) {
              VM_ASSERT(vm, VM_IS_PGM_P(functionValue));
              callTargetFunctionOffset = VM_VALUE_OF(functionValue);
              goto CALL_COMMON;
            }

            if (typeCode == VM_TC_HOST_FUNC) {
              callTargetHostFunctionIndex = vm_readUInt16(vm, functionValue);
              goto CALL_HOST_COMMON;
            }

            err = VM_E_TARGET_NOT_CALLABLE;
            goto EXIT;
          }

          default: VM_UNEXPECTED_INTERNAL_ERROR(vm); break;
        }
        break;
      }

      case VM_OP_EXTENDED_3: {
        // Ex-3 instructions have a 16-bit parameter, which may be interpretted as signed or unsigned
        READ_PGM(&u16Param3, 2);
        s16Param3 = (int16_t)u16Param3;
        switch (param2) {
          case VM_OP3_CALL_2: {
            callTargetFunctionOffset = u16Param3;
            // This call instruction has an additional 8 bits for the argument count.
            uint8_t temp;
            READ_PGM(&temp, 1);
            callArgCount = temp;
            goto CALL_COMMON;
          }

          case VM_OP3_JUMP_2: {
            jumpOffset = s16Param3;
            goto JUMP_COMMON;
          }

          case VM_OP3_BRANCH_2: {
            branchOffset = s16Param3;
            goto BRANCH_COMMON;
          }

          case VM_OP3_LOAD_LITERAL: {
            PUSH(u16Param3);
            break;
          }

          case VM_OP3_LOAD_GLOBAL_3: VM_NOT_IMPLEMENTED(vm); break;
          case VM_OP3_STORE_GLOBAL_3: VM_NOT_IMPLEMENTED(vm); break;
          default: VM_UNEXPECTED_INTERNAL_ERROR(vm); break;
        }
        break;
      }

      default: VM_UNEXPECTED_INTERNAL_ERROR(vm); break;
    }
  }

EXIT:
  FLUSH_REGISTER_CACHE();
  return err;
}

void vm_free(vm_VM* vm) {
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
static vm_Value gc_allocate(vm_VM* vm, uint16_t sizeBytes, vm_TeTypeCode typeCode, uint16_t headerVal2, void** out_pTarget) {
  uint16_t allocationSize;
RETRY:
  allocationSize = sizeBytes + 2; // 2 byte header
  // Round up to 2-byte boundary
  allocationSize = (allocationSize + 1) & 0xFFFE;
  // Minimum allocation size is 4 bytes
  if (allocationSize < 4) allocationSize = 4;
  // Note: this is still valid when the bucket is null
  GO_t allocOffset = vm->gc_allocationCursor;
  void* pAlloc = vm->pAllocationCursor;
  GO_t endOfResult = allocOffset + allocationSize;
  // Out of space?
  if (endOfResult > vm->gc_bucketEnd) {
    // Allocate a new bucket
    uint16_t bucketSize = VM_ALLOCATION_BUCKET_SIZE;
    if (allocationSize > bucketSize)
      bucketSize = allocationSize;
    gc_createNextBucket(vm, bucketSize);
    // This must succeed the second time because we've just allocated a bucket at least as big as it needs to be
    goto RETRY;
  }
  vm->gc_allocationCursor = endOfResult;
  vm->pAllocationCursor += allocationSize;

  // Write header
  VM_ASSERT(vm, headerVal2 & 0xFFF);
  vm_HeaderWord headerWord = (typeCode << 12) | headerVal2;
  *((vm_HeaderWord*)pAlloc) = headerWord;

  *out_pTarget = (uint8_t*)pAlloc + 2; // Skip header
  return (allocOffset + 2) | VM_TAG_PGM_P;
}

static void gc_createNextBucket(vm_VM* vm, uint16_t bucketSize) {
  size_t allocSize = sizeof(vm_TsBucket) + bucketSize;
  vm_TsBucket* bucket = malloc(allocSize);
  if (!bucket) {
    VM_FATAL_ERROR(vm, VM_E_MALLOC_FAIL);
    return;
  }
  #if VM_SAFE_MODE
    memset(bucket, 0, allocSize);
  #endif
  bucket->prev = vm->gc_lastBucket;
  bucket->addressStart = vm->gc_bucketEnd;
  vm->gc_allocationCursor = vm->gc_bucketEnd;
  vm->pAllocationCursor = (uint8_t*)(bucket + 1);
  vm->gc_bucketEnd += bucketSize;
  vm->gc_lastBucket = bucket;
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
  VM_ASSERT(vm, VM_IS_GC_P(ptr));
  GO_t offset = VM_VALUE_OF(ptr);
  uint16_t pWords = offset / VM_GC_ALLOCATION_UNIT;
  uint16_t slotOffset = pWords >> 4;
  uint8_t bitOffset = pWords & 15;
  return markTable[slotOffset] & (0x8000 >> bitOffset);
}

static void gc_freeGCMemory(vm_VM* vm) {
  while (vm->gc_lastBucket) {
    vm_TsBucket* prev = vm->gc_lastBucket->prev;
    free(vm->gc_lastBucket);
    vm->gc_lastBucket = prev;
  }
  vm->gc_bucketEnd = VM_ADDRESS_SPACE_START;
  vm->gc_allocationCursor = VM_ADDRESS_SPACE_START;
  vm->pAllocationCursor = NULL;
}

static void gc_traceValue(vm_VM* vm, uint16_t* markTable, vm_Value value, uint16_t* pTotalSize) {
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
  vm_TeTypeCode typeCode = vm_typeCodeFromHeaderWord(headerWord);
  uint16_t headerData = vm_paramOfHeaderWord(headerWord);

  uint16_t allocationSize; // Including header
  uint8_t headerSize = 2;
  switch (typeCode) {
    case VM_TC_BOXED: {
      gc_markAllocation(markTable, pAllocation - 2, 4);
      vm_Value value = vm_readUInt16(vm, pAllocation);
      // TODO(low): This shouldn't be recursive. It shouldn't use the C stack
      gc_traceValue(vm, markTable, value, pTotalSize);
      return;
    }
    case VM_TC_VIRTUAL: allocationSize = 0; VM_NOT_IMPLEMENTED(vm); break;

    case VM_TC_STRING:
    case VM_TC_UNIQUED_STRING:
    case VM_TC_BIG_INT:
    case VM_TC_SYMBOL:
    case VM_TC_HOST_FUNC:
    case VM_TC_INT32:
    case VM_TC_DOUBLE:
      allocationSize = 2 + headerData; break;

    case VM_TC_PROPERTY_LIST: {
      uint16_t propCount = headerData;
      gc_markAllocation(markTable, pAllocation - 2, 4);
      vm_Pointer pCell = vm_readUInt16(vm, pAllocation);
      while (propCount--) {
        gc_markAllocation(markTable, pCell, 6);
        vm_Pointer next = vm_readUInt16(vm, pCell + 0);
        vm_Value key = vm_readUInt16(vm, pCell + 2);
        vm_Value value = vm_readUInt16(vm, pCell + 4);

        // TODO(low): This shouldn't be recursive. It shouldn't use the C stack
        gc_traceValue(vm, markTable, key, pTotalSize);
        gc_traceValue(vm, markTable, value, pTotalSize);

        pCell = next;
      }
      return;
    }

    case VM_TC_LIST: {
      uint16_t itemCount = headerData;
      gc_markAllocation(markTable, pAllocation - 2, 4);
      vm_Pointer pCell = vm_readUInt16(vm, pAllocation);
      while (itemCount--) {
        gc_markAllocation(markTable, pCell, 6);
        vm_Pointer next = vm_readUInt16(vm, pCell + 0);
        vm_Value value = vm_readUInt16(vm, pCell + 2);

        // TODO(low): This shouldn't be recursive. It shouldn't use the C stack
        gc_traceValue(vm, markTable, value, pTotalSize);

        pCell = next;
      }
      return;
    }

    case VM_TC_TUPLE: {
      uint16_t itemCount = headerData;
      // Need to mark before recursing
      allocationSize = 2 + itemCount * 2;
      gc_markAllocation(markTable, pAllocation - 2, allocationSize);
      vm_Pointer pItem = pAllocation;
      while (itemCount--) {
        vm_Value item = vm_readUInt16(vm, pItem);
        pItem += 2;
        // TODO(low): This shouldn't be recursive. It shouldn't use the C stack
        gc_traceValue(vm, markTable, item, pTotalSize);
      }
      return;
    }

    case VM_TC_FUNCTION: {
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

static inline void gc_updatePointer(vm_VM* vm, uint16_t* pWord, uint16_t* markTable, uint16_t* offsetTable) {
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
void vm_runGC(vm_VM* vm) {
  if (!vm->gc_lastBucket) return; // Nothing allocated

  uint16_t markTableSize = (vm->gc_bucketEnd + (VM_GC_ALLOCATION_UNIT * 8 - 1)) / (VM_GC_ALLOCATION_UNIT * 8);
  markTableSize = (markTableSize + 1) & 0xFFFE; // Round up to even boundary
  uint16_t adjustmentTableSize = markTableSize + 2;
  uint8_t* temp = malloc(markTableSize + adjustmentTableSize);
  if (!temp) {
    VM_FATAL_ERROR(vm, VM_E_MALLOC_FAIL);
    return;
  }
  uint16_t* adjustmentTable = (uint16_t*)temp;
  uint16_t* markTable = (uint16_t*)(temp + adjustmentTableSize);
  uint16_t* markTableEnd = (uint16_t*)((uint8_t*)markTable + markTableSize);

  VM_ASSERT(vm, ((intptr_t)adjustmentTable & 1) == 0); // Needs to be 16-bit aligned for the following algorithm to work

  memset(markTable, 0, markTableSize);
  VM_EXEC_SAFE_MODE(memset(adjustmentTable, 0, adjustmentTableSize));

  // -- Mark Phase--

  uint16_t totalSize = 0;

  // Mark Global Variables
  {
    uint16_t globalVariableCount;
    VM_READ_BC_HEADER_FIELD(&globalVariableCount, globalVariableCount, vm->pBytecode);

    uint16_t* p = vm->dataMemory;
    while (globalVariableCount--)
      gc_traceValue(vm, markTable, *p++, &totalSize);
  }

  // Mark other roots in data memory
  {
    uint16_t gcRootsOffset;
    uint16_t gcRootsCount;
    VM_READ_BC_HEADER_FIELD(&gcRootsOffset, gcRootsOffset, vm->pBytecode);
    VM_READ_BC_HEADER_FIELD(&gcRootsCount, gcRootsCount, vm->pBytecode);

    VM_PROGMEM_P pTableEntry = VM_PROGMEM_P_ADD(vm->pBytecode, gcRootsOffset);
    uint16_t* p = vm->dataMemory;
    while (gcRootsCount--) {
      uint16_t dataOffsetWords;
      // The table entry in program memory gives us an offset in data memory
      VM_READ_PROGMEM(&dataOffsetWords, pTableEntry, sizeof dataOffsetWords);
      uint16_t dataValue = vm->dataMemory[dataOffsetWords];
      gc_traceValue(vm, markTable, dataValue, &totalSize);
      VM_PROGMEM_P_ADD(pTableEntry, 2);
    }
  }

  if (totalSize == 0) {
    // Everything is freed
    gc_freeGCMemory(vm);
    free(temp);
    return;
  }

  GO_t allocatedSize = vm->gc_allocationCursor - VM_ADDRESS_SPACE_START;
  // If the allocated size is taking up less than 25% more than the used size,
  // then don't collect.
  if (allocatedSize < totalSize * 5 / 4) {
    free(temp);
    return;
  }

  // Create adjustment table
  {
    uint16_t mask = 0x8000;
    uint16_t* pMark = markTable;
    uint16_t adjustment = -VM_ADDRESS_SPACE_START;
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
    uint16_t globalVariableCount;
    VM_READ_BC_HEADER_FIELD(&globalVariableCount, globalVariableCount, vm->pBytecode);

    while (globalVariableCount--) {
      gc_updatePointer(vm, p++, markTable, adjustmentTable);
    }
  }

  // Compact phase

  // Temporarily reverse the linked list to make it easier to parse forwards
  // during compaction. Also, we'll change the addressStart field to hold the
  // size.
  vm_TsBucket* first;
  {
    vm_TsBucket* bucket = vm->gc_lastBucket;
    GO_t endOfBucket = vm->gc_bucketEnd;
    vm_TsBucket* next = NULL;
    while (bucket) {
      uint16_t size = endOfBucket - bucket->addressStart;
      endOfBucket = bucket->addressStart;
      bucket->addressStart/*size*/ = size;
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
  vm->gc_allocationCursor = VM_ADDRESS_SPACE_START;
  vm->gc_bucketEnd = VM_ADDRESS_SPACE_START;
  vm->gc_lastBucket = NULL;
  gc_createNextBucket(vm, totalSize);

  {
    VM_ASSERT(vm, vm->gc_lastBucket && !vm->gc_lastBucket->prev); // Only one bucket
    uint16_t* source = (uint16_t*)(first + 1); // Start just after the header
    uint16_t* sourceEnd = (uint16_t*)((uint8_t*)source + first->addressStart/*size*/);
    uint16_t* target = (uint16_t*)(vm->gc_lastBucket + 1); // Start just after the header
    if (!target) {
      VM_UNEXPECTED_INTERNAL_ERROR(vm);
      return;
    }
    uint16_t* pMark = &markTable[VM_ADDRESS_SPACE_START / VM_GC_ALLOCATION_UNIT / 16];
    uint16_t mask = 0x8000 >> ((VM_ADDRESS_SPACE_START / VM_GC_ALLOCATION_UNIT) & 0xF);
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
        uint16_t size = first->addressStart/*size*/;
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

  free(temp);
}

static void* gc_deref(vm_VM* vm, GO_t addr) {
  VM_ASSERT(vm, addr & VM_VALUE_MASK);
  #if VM_SAFE_MODE
    if (addr >= vm->gc_allocationCursor) {
      VM_FATAL_ERROR(vm, VM_E_INVALID_ADDRESS);
      return NULL;
    }
  #endif

  // Find the right bucket
  vm_TsBucket* bucket = vm->gc_lastBucket;
  GO_t bucketEnd = vm->gc_bucketEnd;
  while (bucket && (bucket->addressStart > addr)) {
    bucketEnd = bucket->addressStart;
    bucket = bucket->prev;
  }

  #if VM_SAFE_MODE
    if (!bucket) {
      VM_FATAL_ERROR(vm, VM_E_INVALID_ADDRESS);
      return NULL;
    }
  #endif

  uint8_t* bucketData = ((uint8_t*)(bucket + 1));
  uint8_t* p = bucketData + (addr - bucket->addressStart);
  return p;
}

static void* vm_dataDeref(vm_VM* vm, DO_t addr) {
  return (uint8_t*)vm->dataMemory + addr;
}

static void gc_readMem(vm_VM* vm, void* target, GO_t src, uint16_t size) {
  uint8_t* sourceAddress = gc_deref(vm, src);
  uint8_t* p = target;
  while (size--) {
    *p++ = *sourceAddress++;
  }
}

// A function call invoked by the host
vm_TeError vm_call(vm_VM* vm, vm_Value func, vm_Value* out_result, vm_Value* args, uint8_t argCount) {
  vm_TeError err;
  *out_result = VM_VALUE_UNDEFINED;

  vm_setupCallFromExternal(vm, func, args, argCount);

  // Run the machine until it hits the corresponding return instruction. The
  // return instruction pops the arguments off the stack and pushes the returned
  // value.
  err = vm_run(vm);
  if (err != VM_E_SUCCESS) return err;

  *out_result = vm_pop(vm);

  // Release the stack if we hit the bottom
  if (vm->stack->reg.pStackPointer == VM_BOTTOM_OF_STACK(vm)) {
    free(vm->stack);
    vm->stack = NULL;
  }

  return VM_E_SUCCESS;
}

static vm_TeError vm_setupCallFromExternal(vm_VM* vm, vm_Value func, vm_Value* args, uint8_t argCount) {
  VM_ASSERT(vm, vm_deepTypeOf(vm, func) == VM_TC_FUNCTION);

  // There is no stack if this is not a reentrant invocation
  if (!vm->stack) {
    // This is freed again at the end of vm_call
    vm_TsStack* stack = malloc(sizeof (vm_TsStack) + VM_STACK_SIZE);
    if (!stack) return VM_E_MALLOC_FAIL;
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
  uint8_t maxStackDepth;
  VM_READ_BC_FIELD(&maxStackDepth, maxStackDepth, functionOffset, vm_TsFunctionHeader, vm->pBytecode);
  // TODO(low): Since we know the max stack depth for the function, we could actually grow the stack dynamically rather than allocate it fixed size.
  if (vm->stack->reg.pStackPointer + maxStackDepth > VM_TOP_OF_STACK(vm)) {
    return VM_E_STACK_OVERFLOW;
  }

  vm_push(vm, func); // We need to push the function because the corresponding RETURN instruction will pop it. The actual value is not used.
  vm_Value* arg = &args[0];
  for (int i = 0; i < argCount; i++)
    vm_push(vm, *arg++);

  // Save caller state
  vm_push(vm, reg->pFrameBase - bottomOfStack);
  vm_push(vm, reg->argCount);
  vm_push(vm, reg->programCounter);

  // Set up new frame
  reg->pFrameBase = reg->pStackPointer;
  reg->argCount = argCount;
  reg->programCounter = functionOffset + sizeof (vm_TsFunctionHeader);

  return VM_E_SUCCESS;
}

vm_TeError vm_resolveExport(vm_VM* vm, vm_VMExportID id, vm_Value* result) {
  VM_PROGMEM_P pBytecode = vm->pBytecode;
  uint16_t exportTableOffset;
  uint16_t exportTableSize;
  VM_READ_BC_HEADER_FIELD(&exportTableOffset, exportTableOffset, pBytecode);
  VM_READ_BC_HEADER_FIELD(&exportTableSize, exportTableSize, pBytecode);

  uint16_t exportTableEntry = exportTableOffset;
  for (int i = 0; i < exportTableSize; i++) {
    vm_VMExportID exportID;
    VM_READ_BC_FIELD(&exportID, exportID, exportTableEntry, vm_TsExportTableEntry, pBytecode);
    if (exportID == id) {
      uint16_t exportValue;
      VM_READ_BC_FIELD(&exportValue, exportValue, exportTableEntry, vm_TsExportTableEntry, pBytecode);
      *result = exportValue;
      return VM_E_SUCCESS;
    }
    exportTableEntry += sizeof (vm_TsExportTableEntry);
  }

  *result = VM_VALUE_UNDEFINED;
  return VM_E_FUNCTION_NOT_FOUND;
}

vm_TeError vm_resolveExports(vm_VM* vm, const vm_VMExportID* idTable, vm_Value* resultTable, uint8_t count) {
  vm_TeError err = VM_E_SUCCESS;
  while (count--) {
    vm_TeError tempErr = vm_resolveExport(vm, *idTable++, resultTable++);
    if (tempErr != VM_E_SUCCESS)
      err = tempErr;
  }
  return err;
}

void vm_initializeHandle(vm_VM* vm, vm_Handle* handle) {
  VM_ASSERT(vm, !vm_isHandleInitialized(vm, handle));
  handle->_next = vm->gc_handles;
  vm->gc_handles = handle;
  handle->_value = VM_VALUE_UNDEFINED;
}

void vm_cloneHandle(vm_VM* vm, vm_Handle* target, const vm_Handle* source) {
  VM_ASSERT(vm, !vm_isHandleInitialized(vm, source));
  vm_initializeHandle(vm, target);
  target->_value = source->_value;
}

vm_TeError vm_releaseHandle(vm_VM* vm, vm_Handle* handle) {
  vm_Handle** h = &vm->gc_handles;
  while (*h) {
    if (*h == handle) {
      *h = handle->_next;
      handle->_value = VM_VALUE_UNDEFINED;
      handle->_next = NULL;
      return VM_E_SUCCESS;
    }
    h = &((*h)->_next);
  }
  handle->_value = VM_VALUE_UNDEFINED;
  handle->_next = NULL;
  return VM_E_INVALID_HANDLE;
}

static bool vm_isHandleInitialized(vm_VM* vm, const vm_Handle* handle) {
  vm_Handle* h = vm->gc_handles;
  while (h) {
    if (h == handle) {
      return true;
    }
    h = h->_next;
  }
  return false;
}

static inline vm_Value vm_makeValue(uint16_t tag, uint16_t value) {
  VM_ASSERT(vm, !(value & VM_TAG_MASK));
  VM_ASSERT(vm, !(tag & VM_VALUE_MASK));
  return tag | value;
}

static vm_Value vm_binOp1(vm_VM* vm, vm_TeBinOp1 op, vm_Value left, vm_Value right) {
  switch (op) {
    case VM_BOP1_ADD: {
      // Fast case
      if (VM_IS_INT14(left) && VM_IS_INT14(right)) {
        uint16_t result = left + right;
        // If not overflowed
        if (VM_IS_INT14(result))
          return result;
        // Otherwise... continue on the slow paths
      }

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
    case VM_BOP1_DIVIDE_INT: return VM_NOT_IMPLEMENTED(vm);
    case VM_BOP1_DIVIDE_FLOAT: return VM_NOT_IMPLEMENTED(vm);
    case VM_BOP1_SHR_ARITHMETIC: return VM_NOT_IMPLEMENTED(vm);
    case VM_BOP1_SHR_BITWISE: return VM_NOT_IMPLEMENTED(vm);
    case VM_BOP1_SHL: return VM_NOT_IMPLEMENTED(vm);
    case VM_BOP1_REMAINDER: return VM_NOT_IMPLEMENTED(vm);
    default: return VM_UNEXPECTED_INTERNAL_ERROR(vm);
  }
}

static vm_Value vm_binOp2(vm_VM* vm, vm_TeBinOp2 op, vm_Value left, vm_Value right) {
  switch (op) {
    case VM_BOP2_LESS_THAN: return VM_NOT_IMPLEMENTED(vm);
    case VM_BOP2_GREATER_THAN: return VM_NOT_IMPLEMENTED(vm);
    case VM_BOP2_LESS_EQUAL: return VM_NOT_IMPLEMENTED(vm);
    case VM_BOP2_GREATER_EQUAL: return VM_NOT_IMPLEMENTED(vm);
    case VM_BOP2_EQUAL: return VM_NOT_IMPLEMENTED(vm);
    case VM_BOP2_NOT_EQUAL: return VM_NOT_IMPLEMENTED(vm);
    case VM_BOP2_AND: return VM_NOT_IMPLEMENTED(vm);
    case VM_BOP2_OR: return VM_NOT_IMPLEMENTED(vm);
    default: return VM_UNEXPECTED_INTERNAL_ERROR(vm);
  }
}

static vm_Value vm_convertToString(vm_VM* vm, vm_Value value) {
  vm_TeTypeCode type = vm_deepTypeOf(vm, value);

  switch (type) {
    case VM_TAG_INT: return VM_NOT_IMPLEMENTED(vm);
    case VM_TC_INT32: return VM_NOT_IMPLEMENTED(vm);
    case VM_TC_DOUBLE: return VM_NOT_IMPLEMENTED(vm);
    case VM_TC_STRING: return value;
    case VM_TC_UNIQUED_STRING: return value;
    case VM_TC_PROPERTY_LIST: return VM_NOT_IMPLEMENTED(vm);
    case VM_TC_LIST: return VM_NOT_IMPLEMENTED(vm);
    case VM_TC_TUPLE: return VM_NOT_IMPLEMENTED(vm);
    case VM_TC_FUNCTION: return VM_NOT_IMPLEMENTED(vm);
    case VM_TC_HOST_FUNC: return VM_NOT_IMPLEMENTED(vm);
    case VM_TC_BIG_INT: return VM_NOT_IMPLEMENTED(vm);
    case VM_TC_SYMBOL: return VM_NOT_IMPLEMENTED(vm);
    case VM_TC_UNDEFINED: return VM_NOT_IMPLEMENTED(vm);
    case VM_TC_NULL: return VM_NOT_IMPLEMENTED(vm);
    case VM_TC_TRUE: return VM_NOT_IMPLEMENTED(vm);
    case VM_TC_FALSE: return VM_NOT_IMPLEMENTED(vm);
    case VM_TC_EMPTY_STRING: return value;
    case VM_TC_NAN: return VM_NOT_IMPLEMENTED(vm);
    case VM_TC_INF: return VM_NOT_IMPLEMENTED(vm);
    case VM_TC_NEG_INF: return VM_NOT_IMPLEMENTED(vm);
    case VM_TC_NEG_ZERO: return VM_NOT_IMPLEMENTED(vm);
    case VM_TC_DELETED: return VM_NOT_IMPLEMENTED(vm);
    case VM_TC_STRUCT: return VM_NOT_IMPLEMENTED(vm);
    default: return VM_UNEXPECTED_INTERNAL_ERROR(vm);
  }
}

static vm_Value vm_concat(vm_VM* vm, vm_Value left, vm_Value right) {
  return VM_NOT_IMPLEMENTED(vm);
}

static vm_Value vm_convertToNumber(vm_VM* vm, vm_Value value) {
  uint16_t tag = value & VM_TAG_MASK;
  if (tag == VM_TAG_INT) return value;

  vm_TeTypeCode type = vm_deepTypeOf(vm, value);
  switch (type) {
    case VM_TC_INT32: return value;
    case VM_TC_DOUBLE: return value;
    case VM_TC_STRING: return VM_NOT_IMPLEMENTED(vm);
    case VM_TC_UNIQUED_STRING: return VM_NOT_IMPLEMENTED(vm);
    case VM_TC_PROPERTY_LIST: return VM_VALUE_NAN;
    case VM_TC_LIST: return VM_VALUE_NAN;
    case VM_TC_TUPLE: return VM_VALUE_NAN;
    case VM_TC_FUNCTION: return VM_VALUE_NAN;
    case VM_TC_HOST_FUNC: return VM_VALUE_NAN;
    case VM_TC_BIG_INT: return VM_NOT_IMPLEMENTED(vm);
    case VM_TC_SYMBOL: return VM_NOT_IMPLEMENTED(vm);
    case VM_TC_UNDEFINED: return 0;
    case VM_TC_NULL: return 0;
    case VM_TC_TRUE: return 1;
    case VM_TC_FALSE: return 0;
    case VM_TC_EMPTY_STRING: return 0;
    case VM_TC_NAN: return value;
    case VM_TC_INF: return value;
    case VM_TC_NEG_INF: return value;
    case VM_TC_NEG_ZERO: return value;
    case VM_TC_DELETED: return 0;
    case VM_TC_STRUCT: return VM_VALUE_NAN;
    default: return VM_UNEXPECTED_INTERNAL_ERROR(vm);
  }
}

static vm_Value vm_addNumbersSlow(vm_VM* vm, vm_Value left, vm_Value right) {
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

  vm_TeTypeCode leftType = vm_deepTypeOf(vm, left);
  vm_TeTypeCode rightType = vm_deepTypeOf(vm, right);

  // If either is a double, then we need to perform double arithmetic
  if ((leftType == VM_TC_DOUBLE) || (rightType == VM_TC_DOUBLE)) {
    VM_DOUBLE leftDouble = vm_readDouble(vm, leftType, left);
    VM_DOUBLE rightDouble = vm_readDouble(vm, rightType, right);
    VM_DOUBLE result = leftDouble + rightDouble;
    return vm_newDouble(vm, result);
  }

  VM_ASSERT(vm, (leftType == VM_TC_INT32) || (rightType == VM_TC_INT32));

  int32_t leftInt32 = vm_readInt32(vm, left, leftType);
  int32_t rightInt32 = vm_readInt32(vm, right, rightType);
  int32_t result = leftInt32 + rightInt32;
  bool overflowed32 = (uint32_t)result < (uint32_t)leftInt32;
  if (overflowed32)
    return vm_newDouble(vm, (VM_DOUBLE)leftInt32 + (VM_DOUBLE)rightInt32);
  return vm_newInt32(vm, result);
}

/* Returns the deep type of the value, looking through pointers and boxing */
static vm_TeTypeCode vm_deepTypeOf(vm_VM* vm, vm_Value value) {
  vm_TeValueTag tag = VM_TAG_OF(value);
  if (tag == VM_TAG_INT)
    return VM_TC_INT14;

  // Check for "well known" values such as VM_TC_UNDEFINED
  if (tag == VM_TAG_PGM_P && value < VM_VALUE_MAX_WELLKNOWN)
    return VM_VALUE_OF(value);

  // Else, value is a pointer. The type of a pointer value is the type of the value being pointed to
  vm_HeaderWord headerWord = vm_readHeaderWord(vm, value);
  vm_TeTypeCode typeCode = vm_typeCodeFromHeaderWord(headerWord);

  // The type of a boxed value is the type of the value being boxed.
  if (typeCode == VM_TC_BOXED) {
    vm_Value inner;
    vm_readMem(vm, &inner, value, 2);
    return vm_deepTypeOf(vm, inner);
  }

  // The type of a virtual value is the type code stored in the metadata table
  if (typeCode == VM_TC_VIRTUAL) {
    uint16_t metadataPointer = vm_paramOfHeaderWord(headerWord) - 1;
    uint8_t innerTypeCode;
    VM_READ_BC_AT(&innerTypeCode, metadataPointer, sizeof innerTypeCode, vm->pBytecode);
    return innerTypeCode;
  }

  return typeCode;
}

vm_Value vm_newDouble(vm_VM* vm, VM_DOUBLE value) {
  if (isnan(value)) return VM_VALUE_NAN;
  if (value == INFINITY) return VM_VALUE_INF;
  if (value == -INFINITY) return VM_VALUE_NEG_INF;
  if (value == -0.0) return VM_VALUE_NEG_ZERO;

  // Doubles are very expensive to compute, so at every opportunity, we'll check
  // if we can coerce back to an integer
  int32_t valueAsInt = (int32_t)value;
  if (value == (VM_DOUBLE)valueAsInt) {
    return vm_newInt32(vm, valueAsInt);
  }

  double* pResult;
  vm_Value resultValue = gc_allocate(vm, sizeof (VM_DOUBLE), VM_TC_DOUBLE, sizeof (VM_DOUBLE), &pResult);
  *pResult = value;

  return resultValue;
}

vm_Value vm_newInt32(vm_VM* vm, int32_t value) {
  if ((value >= VM_MIN_INT14) && (value <= VM_MAX_INT14))
    return value | VM_TAG_INT;

  // Int32
  int32_t* pResult;
  vm_Value resultValue = gc_allocate(vm, sizeof (int32_t), VM_TC_INT32, sizeof (int32_t), &pResult);
  *pResult = value;

  return resultValue;
}

bool vm_toBool(vm_VM* vm, vm_Value value) {
  uint16_t tag = value & VM_TAG_MASK;
  if (tag == VM_TAG_INT) return value != 0;

  vm_TeTypeCode type = vm_deepTypeOf(vm, value);
  switch (type) {
    case VM_TC_INT32: {
      // Int32 can't be zero, otherwise it would be encoded as an int14
      VM_ASSERT(vm, vm_readInt32(vm, type, value) != 0);
      return false;
    }
    case VM_TC_DOUBLE: {
      // Double can't be zero, otherwise it would be encoded as an int14
      VM_ASSERT(vm, vm_readDouble(vm, type, value) != 0);
      return false;
    }
    case VM_TC_UNIQUED_STRING:
    case VM_TC_STRING: {
      // Strings are non-empty, otherwise they should be VM_TC_EMPTY_STRING
      #if VM_SAFE_MODE
      size_t size;
      vm_TeError err = vm_stringSizeUtf8(vm, value, &size);
      if (err) VM_UNEXPECTED_INTERNAL_ERROR(vm);
      VM_ASSERT(vm, size != 0);
      #endif
      return true;
    }
    case VM_TC_PROPERTY_LIST: return true;
    case VM_TC_LIST: return true;
    case VM_TC_TUPLE: return true;
    case VM_TC_FUNCTION: return true;
    case VM_TC_HOST_FUNC: return true;
    case VM_TC_BIG_INT: return VM_NOT_IMPLEMENTED(vm);
    case VM_TC_SYMBOL: return true;
    case VM_TC_UNDEFINED: return false;
    case VM_TC_NULL: return false;
    case VM_TC_TRUE: return true;
    case VM_TC_FALSE: return false;
    case VM_TC_EMPTY_STRING: return false;
    case VM_TC_NAN: return false;
    case VM_TC_INF: return true;
    case VM_TC_NEG_INF: return true;
    case VM_TC_NEG_ZERO: return false;
    case VM_TC_DELETED: return false;
    case VM_TC_STRUCT: return true;
    default: return VM_UNEXPECTED_INTERNAL_ERROR(vm);
  }
}

static bool vm_isString(vm_VM* vm, vm_Value value) {
  if (value == VM_VALUE_EMPTY_STRING) return true;
  if (vm_deepTypeOf(vm, value) == VM_TC_STRING) return true;
  return false;
}

/** Reads a numeric value that is a subset of a double */
static VM_DOUBLE vm_readDouble(vm_VM* vm, vm_TeTypeCode type, vm_Value value) {
  switch (type) {
    case VM_TC_INT14: { return (VM_DOUBLE)value; }
    case VM_TC_INT32: { return (VM_DOUBLE)vm_readInt32(vm, type, value); }
    case VM_TC_DOUBLE: {
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
static int32_t vm_readInt32(vm_VM* vm, vm_TeTypeCode type, vm_Value value) {
  if (type == VM_TC_INT14) return value;
  if (type == VM_TC_INT32) {
    int32_t result;
    vm_readMem(vm, &result, value, sizeof result);
    return result;
  }
  return VM_UNEXPECTED_INTERNAL_ERROR(vm);
}

static vm_Value vm_unOp(vm_VM* vm, vm_TeUnOp op, vm_Value arg) {
  return VM_NOT_IMPLEMENTED(vm);
}

static void vm_push(vm_VM* vm, uint16_t value) {
  *(vm->stack->reg.pStackPointer++) = value;
}

static uint16_t vm_pop(vm_VM* vm) {
  return *(--vm->stack->reg.pStackPointer);
}

static inline uint16_t vm_readUInt16(vm_VM* vm, vm_Pointer p) {
  uint16_t result;
  vm_readMem(vm, &result, p, sizeof(result));
  return result;
}

static inline vm_HeaderWord vm_readHeaderWord(vm_VM* vm, vm_Pointer pAllocation) {
  return vm_readUInt16(vm, pAllocation - 2);
}

static void vm_readMem(vm_VM* vm, void* target, vm_Pointer source, uint16_t size) {
  uint16_t addr = VM_VALUE_OF(source);
  switch (VM_TAG_OF(source)) {
    case VM_TAG_GC_P: {
      VM_ASSERT(vm, source > VM_VALUE_MAX_WELLKNOWN);
      uint8_t* sourceAddress = gc_deref(vm, source);
      memcpy(target, sourceAddress, size);
      break;
    }
    case VM_TAG_DATA_P: {
      memcpy(target, (uint8_t*)vm->dataMemory + addr, size);
      break;
    }
    case VM_TAG_PGM_P: {
      VM_READ_BC_AT(target, addr, size, vm->pBytecode);
      break;
    }
    default: VM_UNEXPECTED_INTERNAL_ERROR(vm);
  }
}

static void vm_writeMem(vm_VM* vm, vm_Pointer target, void* source, uint16_t size) {
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
      VM_FATAL_ERROR(vm, VM_E_ATTEMPT_TO_WRITE_TO_ROM);
      break;
    }
    default: VM_UNEXPECTED_INTERNAL_ERROR(vm);
  }
}

static inline vm_TfHostFunction* vm_getResolvedImports(vm_VM* vm) {
  return (vm_TfHostFunction*)(vm + 1); // Starts right after the header
}

static inline uint16_t vm_getResolvedImportCount(vm_VM* vm) {
  uint16_t importTableSize;
  VM_READ_BC_HEADER_FIELD(&importTableSize, importTableSize, vm->pBytecode);
  uint16_t importCount = importTableSize / sizeof(vm_TsImportTableEntry);
  return importCount;
}

vm_TeType vm_typeOf(vm_VM* vm, vm_Value value) {
  vm_TeTypeCode type = vm_deepTypeOf(vm, value);
  switch (type) {
    case VM_TC_UNDEFINED:
    case VM_TC_DELETED:
      return VM_T_UNDEFINED;

    case VM_TC_NULL:
      return VM_T_NULL;

    case VM_TC_TRUE:
    case VM_TC_FALSE:
      return VM_T_BOOLEAN;

    case VM_TC_INT14:
    case VM_TC_DOUBLE:
    case VM_TC_INT32:
    case VM_TC_NAN:
    case VM_TC_INF:
    case VM_TC_NEG_INF:
    case VM_TC_NEG_ZERO:
      return VM_T_NUMBER;

    case VM_TC_STRING:
    case VM_TC_UNIQUED_STRING:
    case VM_TC_EMPTY_STRING:
      return VM_T_STRING;

    case VM_TC_LIST:
    case VM_TC_TUPLE:
      return VM_T_ARRAY;

    case VM_TC_PROPERTY_LIST:
    case VM_TC_STRUCT:
      return VM_T_OBJECT;

    case VM_TC_FUNCTION:
    case VM_TC_HOST_FUNC:
      return VM_T_FUNCTION;

    case VM_TC_BIG_INT:
      return VM_T_BIG_INT;
    case VM_TC_SYMBOL:
      return VM_T_SYMBOL;

    default: return VM_UNEXPECTED_INTERNAL_ERROR(vm);
  }
}

const char* vm_toStringUtf8(vm_VM* vm, vm_Value value, size_t* out_sizeBytes) {
  value = vm_convertToString(vm, value);

  if (value == VM_VALUE_EMPTY_STRING)
    return "";

  vm_HeaderWord headerWord = vm_readHeaderWord(vm, value);
  vm_TeTypeCode typeCode = vm_typeCodeFromHeaderWord(headerWord);
  if (typeCode == VM_TC_BOXED) return vm_toStringUtf8(vm, vm_unbox(vm, value), out_sizeBytes);

  VM_ASSERT(vm, (typeCode == VM_TC_STRING) || (typeCode == VM_TC_UNIQUED_STRING));

  uint16_t sourceSize = vm_paramOfHeaderWord(headerWord);

  *out_sizeBytes = sourceSize - 1; // Without the extra safety null-terminator

  // If the string is program memory, we have to allocate a copy of it in data
  // memory because program memory is not necessarily addressable
  if (VM_IS_PGM_P(value)) {
    char* data;
    gc_allocate(vm, sourceSize, VM_TC_STRING, sourceSize, &data);
    vm_readMem(vm, data, value, sourceSize);
    return data;
  } else {
    return vm_deref(vm, value);
  }
}

vm_Value vm_newBoolean(bool source) {
  return source ? VM_VALUE_TRUE : VM_VALUE_FALSE;
}

vm_Value vm_makeString(vm_VM* vm, const char* sourceUtf8, size_t sizeBytes) {
  if (sizeBytes == 0) return VM_VALUE_EMPTY_STRING;
  char* data;
  // Note: allocating 1 extra byte for the extra null terminator, but size in header is exact
  vm_Value value = gc_allocate(vm, sizeBytes + 1, VM_TC_STRING, sizeBytes, &data);
  memcpy(data, sourceUtf8, sizeBytes + 1);
  return value;
}

static void* vm_deref(vm_VM* vm, vm_Value pSrc) {
  uint16_t tag = VM_TAG_OF(pSrc);
  uint16_t offset = VM_VALUE_OF(pSrc);
  if (tag == VM_TAG_GC_P) return gc_deref(vm, offset);
  if (tag == VM_TAG_DATA_P) return (uint8_t*)vm->dataMemory + offset;
  // Program pointers (and integers) are not dereferenceable, so it shouldn't get here.
  VM_UNEXPECTED_INTERNAL_ERROR(vm);
  return NULL;
}

static vm_TeError vm_stringSizeUtf8(vm_VM* vm, vm_Value stringValue, size_t* out_size) {
  *out_size = 0;
  vm_TeTypeCode typeCode = vm_shallowTypeCode(stringValue);
  if (typeCode == VM_VALUE_EMPTY_STRING) {
    *out_size = 0;
    return VM_E_SUCCESS;
  }
  if (typeCode == VM_TC_POINTER) {
    vm_HeaderWord headerWord = vm_readHeaderWord(vm, stringValue);
    typeCode = vm_typeCodeFromHeaderWord(headerWord);
    if ((typeCode == VM_TC_STRING) || typeCode == VM_TC_UNIQUED_STRING) {
      *out_size = vm_paramOfHeaderWord(headerWord);
      return VM_E_SUCCESS;
    }
  }
  if (typeCode == VM_TC_BOXED)
    return vm_stringSizeUtf8(vm, vm_unbox(vm, stringValue), out_size);
  return VM_E_TYPE_ERROR;
}