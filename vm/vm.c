#include "vm.h"

#include "vm_internals.h"
#include "math.h"

// TODO: I think all the VM_UNEXPECTED_INTERNAL_ERROR and similar error calls should
// have individual error codes so we can diagnose problems. Also, we need to
// cleanly separate user-caused errors from internal errors from bytecode
// errors.

// TODO: I think the implementation is still in transition between having the
// allocation header before vs after the allocation pointer target.

static void vm_readMem(vm_VM* vm, void* target, vm_Pointer_t source, VM_SIZE_T size);
static void vm_writeMem(vm_VM* vm, vm_Pointer_t target, void* source, VM_SIZE_T size);

static bool vm_isHandleInitialized(vm_VM* vm, vm_GCHandle* handle);
static vm_TeError gc_createNextBucket(vm_VM* vm, uint16_t bucketSize);
static GO_t gc_allocate(vm_VM* vm, uint16_t size);
static GO_t gc_createNextBucketAndAllocate(vm_VM* vm, uint16_t size);
static void gc_markAllocation(uint16_t* markTable, GO_t p, uint16_t size);
static void gc_traceWord(vm_VM* vm, uint16_t* markTable, uint16_t word, uint8_t typecode, uint16_t* pTotalSize);
static inline void gc_updatePointer(vm_VM* vm, uint16_t* pWord, uint16_t* markTable, uint16_t* offsetTable);
static inline uint16_t* vm_dataMemory(vm_VM* vm);
static void gc_freeGCMemory(vm_VM* vm);
static void gc_readMem(vm_VM* vm, void* target, GO_t src, uint16_t size);
static void* gc_deref(vm_VM* vm, vm_Value pSrc);
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
static vm_Value vm_addNumbers(vm_VM* vm, vm_Value left, vm_Value right);
static vm_TeTypeCode vm_typeOf(vm_VM* vm, vm_Value value);
static vm_Value vm_newDouble(vm_VM* vm, VM_DOUBLE value);
static vm_Value vm_newInt32(vm_VM* vm, int32_t value);
static bool vm_valueToBool(vm_VM* vm, vm_Value value);
static bool vm_isString(vm_VM* vm, vm_Value value);
static VM_DOUBLE vm_readDouble(vm_VM* vm, vm_TeTypeCode type, vm_Value value);
static int32_t vm_readInt32(vm_VM* vm, vm_TeTypeCode type, vm_Value value);
static inline vm_Value vm_makeGC_P(GO_t v);
static inline uint16_t vm_readHeaderWord(vm_VM* vm, vm_Pointer_t pAllocation);

vm_TeError vm_create(vm_VM** result, VM_PROGMEM_P bytecode, void* context, vm_TsHostFunctionTableEntry* hostFunctions, size_t hostFunctionCount) {
  #if VM_SAFE_MODE
    uint16_t x = 0x4243;
    bool isLittleEndian = ((uint8_t*)&x)[0] == 0x43;
    VM_ASSERT(isLittleEndian);
  #endif

  vm_TeError err = VM_E_SUCCESS;
  vm_VM* vm = NULL;

  uint16_t dataMemorySize;
  uint16_t importTableOffset;
  uint16_t importTableSize;
  VM_READ_BC_HEADER_FIELD(&dataMemorySize, dataMemorySize, bytecode);
  VM_READ_BC_HEADER_FIELD(&importTableOffset, importTableOffset, bytecode);
  VM_READ_BC_HEADER_FIELD(&importTableSize, importTableSize, bytecode);

  uint16_t importCount = importTableSize / sizeof (vm_TsHostFunctionTableEntry);

  vm = malloc(sizeof (vm_VM) +
    sizeof (vm_TfHostFunction) * importCount +  // Import table
    dataMemorySize // Data memory (globals)
  );
  if (!vm) {
    err = VM_E_MALLOC_FAIL;
    goto EXIT;
  }
  memset(vm, 0, sizeof (vm_VM) + dataMemorySize);
  vm->context = context;
  vm->resolvedImports = (void*)(vm + 1);
  vm->pBytecode = bytecode;
  vm->dataMemory = (void*)(vm->resolvedImports + importCount);

  // Resolve imports (linking)
  for (int i = 0; i < importCount; i++) {
    uint16_t importTableEntry = importTableOffset + i * sizeof (vm_TsImportTableEntry);
    vm_HostFunctionID hostFunctionID;
    VM_READ_BC_FIELD(&hostFunctionID, hostFunctionID, importTableEntry, vm_TsImportTableEntry, bytecode);
    vm_TfHostFunction handler = NULL;
    for (uint16_t i2 = 0; i2 < hostFunctionCount; i2++) {
      if (hostFunctions[i2].hostFunctionID == hostFunctionID) {
        handler = hostFunctions[i2].handler;
        break;
      }
    }
    if (!handler) {
      err = VM_E_UNRESOLVED_IMPORT;
      goto EXIT;
    }
    vm->resolvedImports[i] = handler;
  }

  // The GC is empty to start
  gc_freeGCMemory(vm);

  // Initialize data
  uint16_t initialDataOffset;
  uint16_t initialDataSize;
  VM_READ_BC_HEADER_FIELD(&initialDataOffset, initialDataOffset, bytecode);
  VM_READ_BC_HEADER_FIELD(&initialDataSize, initialDataSize, bytecode);
  uint16_t* dataMemory = vm_dataMemory(vm);
  VM_READ_PROGMEM(dataMemory, VM_PROGMEM_P_ADD(bytecode, initialDataOffset), initialDataSize);
  assert(initialDataSize <= dataMemorySize);

  // Initialize heap
  uint16_t initialHeapOffset;
  uint16_t initialHeapSize;
  VM_READ_BC_HEADER_FIELD(&initialHeapOffset, initialHeapOffset, bytecode);
  VM_READ_BC_HEADER_FIELD(&initialHeapSize, initialHeapSize, bytecode);
  if (initialHeapSize) {
    err = gc_createNextBucket(vm, initialHeapSize);
    if (err != VM_E_SUCCESS) goto EXIT;
    VM_ASSERT(!vm->gc_lastBucket->prev); // Only one bucket
    uint8_t* heapStart = (uint8_t *)(vm->gc_lastBucket + 1);
    VM_READ_PROGMEM(heapStart, VM_PROGMEM_P_ADD(bytecode, initialHeapOffset), initialHeapSize);
    vm->gc_allocationCursor += initialHeapSize;
  }

EXIT:
  if (err != VM_E_SUCCESS) {
    *result = NULL;
    if (vm) {
      free(vm);
      vm = NULL;
    }
  }
  return err;
}

void* vm_getContext(vm_VM* vm) {
  return vm->context;
}

static vm_TeError vm_run(vm_VM* vm) {
  assert(vm);
  assert(vm->stack);

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
    if (VM_IS_INT(value)) result = value != 0; \
    else if (value == VM_VALUE_TRUE) result = true; \
    else if (value == VM_VALUE_FALSE) result = false; \
    else result = vm_valueToBool(vm, value); \
  } while (false)

  #define READ_PGM(pTarget) do { \
    VM_READ_PROGMEM(pTarget, programCounter, sizeof (*pTarget)); \
    programCounter = VM_PROGMEM_P_ADD(programCounter,sizeof (*pTarget) ); \
  } while (false)

  #define PUSH(v) *(pStackPointer++) = v
  #define POP() (*(--pStackPointer))
  #define INSTRUCTION_RESERVED() assert(false)

  vm_TsRegisters* reg = &vm->stack->reg;
  uint16_t* bottomOfStack = VM_BOTTOM_OF_STACK(vm);
  VM_PROGMEM_P pBytecode = vm->pBytecode;
  vm_TeError err = VM_E_SUCCESS;

  register VM_PROGMEM_P programCounter;
  register uint16_t* pStackPointer;
  register uint16_t* pFrameBase;
  register uint16_t argCount;
  CACHE_REGISTERS();

  vm_Value result;
  // TODO: I think we need unit tests that explicitly test that every instruction is implemented and has the correct behavior

  while (true) {
    uint8_t d;
    READ_PGM(&d);
    uint8_t n1 = d >> 4;
    uint8_t n2 = d & 0xF;
    int16_t n3s;
    uint16_t n3u;
    uint16_t n4u;
    switch (n1) {
      case VM_OP_LOAD_SMALL_LITERAL: { // (+ 4-bit vm_TeSmallLiteralValue)
        vm_Value v = VM_VALUE_UNDEFINED;
        switch (n2) {
          case VM_SLV_NULL        : v = VM_VALUE_NULL; break;
          case VM_SLV_UNDEFINED   : v = VM_VALUE_UNDEFINED; break;
          case VM_SLV_FALSE       : v = VM_VALUE_FALSE; break;
          case VM_SLV_TRUE        : v = VM_VALUE_TRUE; break;
          case VM_SLV_EMPTY_STRING: v = VM_VALUE_EMPTY_STRING; break;
          case VM_SLV_INT_0       : v = VM_TAG_INT | 0; break;
          case VM_SLV_INT_1       : v = VM_TAG_INT | 1; break;
          case VM_SLV_INT_2       : v = VM_TAG_INT | 2; break;
          case VM_SLV_INT_MINUS_1 : v = VM_TAG_INT | ((uint16_t)(-1) & VM_VALUE_MASK); break;
          default: VM_UNEXPECTED_INTERNAL_ERROR(); break;
        }
        PUSH(v);
        break;
      }

      case VM_OP_LOAD_VAR_1: PUSH(pStackPointer[-n2 - 1]); break;
      case VM_OP_STORE_VAR_1: pStackPointer[-n2 - 2] = POP(); break;
      case VM_OP_LOAD_GLOBAL_1: PUSH(vm->dataMemory[n2]); break;
      case VM_OP_STORE_GLOBAL_1: vm->dataMemory[n2] = POP(); break;
      case VM_OP_LOAD_ARG_1: PUSH(n2 < argCount ? pFrameBase[- 3 - argCount + n2] : VM_VALUE_UNDEFINED); break;

      case VM_OP_CALL_1: { // (+ 4-bit index into short-call table)
        uint16_t shortCallTableOffset;
        VM_READ_BC_HEADER_FIELD(&shortCallTableOffset, shortCallTableOffset, pBytecode);
        uint16_t shortCallTableEntry = shortCallTableOffset + n2 * sizeof (vm_TsShortCallTableEntry);
        uint16_t function;
        uint8_t callArgCount;
        VM_READ_BC_FIELD(&callArgCount, argCount, shortCallTableEntry, vm_TsShortCallTableEntry, pBytecode);
        VM_READ_BC_FIELD(&function, function, shortCallTableEntry, vm_TsShortCallTableEntry, pBytecode);

        // The high bit of function indicates if this is a call to the host
        bool isHostCall = function & 0x8000;
        function = function & 0x7FFF;

        if (isHostCall) {
          n3u = function;
          n4u = callArgCount;
          goto CALL_HOST_COMMON;
        } else {
          n3u = function;
          n4u = callArgCount;
          goto CALL_COMMON;
        }

        break;
      }

      case VM_OP_BINOP_1: {
        vm_Value right = POP();
        vm_Value left = POP();
        result = VM_VALUE_UNDEFINED;
        switch (n2) {
          case VM_BOP1_ADD: {
            if (((left & VM_TAG_MASK) == VM_TAG_INT) && ((right & VM_TAG_MASK) == VM_TAG_INT)) {
              result = left + right;
              if (result & VM_OVERFLOW_BIT) goto BIN_OP_1_SLOW;
            }
          }
          case VM_BOP1_SUBTRACT: VM_NOT_IMPLEMENTED(); break;
          case VM_BOP1_MULTIPLY: VM_NOT_IMPLEMENTED(); break;
          case VM_BOP1_DIVIDE_INT: VM_NOT_IMPLEMENTED(); break;
          case VM_BOP1_DIVIDE_FLOAT: VM_NOT_IMPLEMENTED(); break;
          case VM_BOP1_SHR_ARITHMETIC: VM_NOT_IMPLEMENTED(); break;
          case VM_BOP1_SHR_BITWISE: VM_NOT_IMPLEMENTED(); break;
          case VM_BOP1_SHL: VM_NOT_IMPLEMENTED(); break;
          default: VM_UNEXPECTED_INTERNAL_ERROR(); break;
        }
        PUSH(result);
        break;
      BIN_OP_1_SLOW:
        FLUSH_REGISTER_CACHE();
        result = vm_binOp1(vm, n2, left, right);
        CACHE_REGISTERS();
        PUSH(result);
        break;
      }

      case VM_OP_BINOP_2: {
        vm_Value right = POP();
        vm_Value left = POP();
        result = VM_VALUE_UNDEFINED;
        switch (n2) {
          case VM_BOP2_LESS_THAN: VM_NOT_IMPLEMENTED(); break;
          case VM_BOP2_GREATER_THAN: VM_NOT_IMPLEMENTED(); break;
          case VM_BOP2_LESS_EQUAL: VM_NOT_IMPLEMENTED(); break;
          case VM_BOP2_GREATER_EQUAL: VM_NOT_IMPLEMENTED(); break;
          case VM_BOP2_EQUAL: VM_NOT_IMPLEMENTED(); break;
          case VM_BOP2_NOT_EQUAL: VM_NOT_IMPLEMENTED(); break;
          case VM_BOP2_AND: VM_NOT_IMPLEMENTED(); break;
          case VM_BOP2_OR: VM_NOT_IMPLEMENTED(); break;
          default: VM_UNEXPECTED_INTERNAL_ERROR(); break;
        }
        PUSH(result);
        break;
      //BIN_OP_2_SLOW:
        FLUSH_REGISTER_CACHE();
        result = vm_binOp2(vm, n2, left, right);
        CACHE_REGISTERS();
        PUSH(result);
        break;
      }

      case VM_OP_UNOP: {
        vm_Value arg = POP();
        result = VM_VALUE_UNDEFINED;
        switch (n2) {
          case VM_OP_NEGATE: {
            // TODO: This needs to handle the overflow case of -(-2000)
            VM_NOT_IMPLEMENTED();
            if (!VM_IS_INT(arg)) goto UN_OP_SLOW;
            result = (-VM_SIGN_EXTEND(arg)) & VM_VALUE_MASK;
            break;
          }
          case VM_OP_LOGICAL_NOT: {
            bool b;
            VALUE_TO_BOOL(b, arg);
            result = b ? VM_VALUE_FALSE : VM_VALUE_TRUE;
            break;
          }
          case VM_OP_BITWISE_NOT: VM_NOT_IMPLEMENTED(); break;
          default: VM_UNEXPECTED_INTERNAL_ERROR(); break;
        }
        break;
      UN_OP_SLOW:
        FLUSH_REGISTER_CACHE();
        result = vm_unOp(vm, n2, arg);
        CACHE_REGISTERS();
        PUSH(result);
        break;
      }

      case VM_OP_STRUCT_GET_1: INSTRUCTION_RESERVED(); break;
      case VM_OP_STRUCT_SET_1: INSTRUCTION_RESERVED(); break;

      case VM_OP_EXTENDED_1: {
        switch (n2) {
          case VM_OP1_RETURN_1:
          case VM_OP1_RETURN_2:
          case VM_OP1_RETURN_3:
          case VM_OP1_RETURN_4: {
            if (n2 & VM_RETURN_FLAG_UNDEFINED) result = VM_VALUE_UNDEFINED;
            else result = POP();

            uint16_t popArgCount = argCount;

            // Restore caller state
            programCounter = VM_PROGMEM_P_ADD(pBytecode, POP());
            argCount = POP();
            pFrameBase = bottomOfStack + POP();

            // Pop arguments
            pStackPointer -= popArgCount;
            // Pop function reference
            if (n2 & VM_RETURN_FLAG_POP_FUNCTION) (void)POP();

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

          default: VM_UNEXPECTED_INTERNAL_ERROR(); break;
        }
        break;
      }

      case VM_OP_EXTENDED_2: {
        // n3 is 8-bit
        uint8_t t;
        READ_PGM(&t);
        programCounter = VM_PROGMEM_P_ADD(programCounter, 1);
        n3s = (int8_t)t; // Sign extend
        n3u = t; // Zero extend
        switch (n2) {
          case VM_OP2_BRANCH_1: goto BRANCH_COMMON;
          case VM_OP2_JUMP_1: goto JUMP_COMMON;

          case VM_OP2_CALL_HOST: {
            READ_PGM(&t);
            n4u = t;
            CALL_HOST_COMMON /* n3u: functionIndex, n4u: callArgCount */: {
              uint16_t functionIndex = n3u;
              uint8_t callArgCount = (uint8_t)n4u;

              // Save caller state
              PUSH(pFrameBase - bottomOfStack);
              PUSH(argCount);
              PUSH((uint16_t)VM_PROGMEM_P_SUB(programCounter, pBytecode));

              // Set up new frame
              pFrameBase = pStackPointer;
              argCount = n4u;
              programCounter = pBytecode; // "null" (signifies that we're outside the VM)

              vm_TfHostFunction hostFunction = vm->resolvedImports[functionIndex];
              vm_Value result;
              vm_Value* args = pStackPointer - 3 - callArgCount;

              FLUSH_REGISTER_CACHE();
              err = hostFunction(vm, &result, args, callArgCount);
              if (err != VM_E_SUCCESS) goto EXIT;
              CACHE_REGISTERS();

              // Restore caller state
              programCounter = VM_PROGMEM_P_ADD(pBytecode, POP());
              argCount = POP();
              pFrameBase = bottomOfStack + POP();

              // Pop arguments
              pStackPointer -= callArgCount;

              PUSH(result);
              break;
            }
          }

          case VM_OP2_LOAD_GLOBAL_2: VM_NOT_IMPLEMENTED(); break;
          case VM_OP2_STORE_GLOBAL_2: VM_NOT_IMPLEMENTED(); break;
          case VM_OP2_LOAD_VAR_2: VM_NOT_IMPLEMENTED(); break;
          case VM_OP2_STORE_VAR_2: VM_NOT_IMPLEMENTED(); break;
          case VM_OP2_STRUCT_GET_2: INSTRUCTION_RESERVED(); break;
          case VM_OP2_STRUCT_SET_2: INSTRUCTION_RESERVED(); break;
          case VM_OP2_LOAD_ARG_2: INSTRUCTION_RESERVED(); break;
          case VM_OP2_STORE_ARG: INSTRUCTION_RESERVED(); break;
          case VM_OP2_CALL_3: INSTRUCTION_RESERVED(); break;
          default: VM_UNEXPECTED_INTERNAL_ERROR(); break;
        }
        break;
      }

      case VM_OP_EXTENDED_3: {
        // n3 is 16-bit
        READ_PGM(&n3u);
        n3s = (int16_t)n3u;
        programCounter = VM_PROGMEM_P_ADD(programCounter, 2);
        switch (n2) {
          case VM_OP3_CALL_2: {
            uint8_t callArgCount;
            READ_PGM(&callArgCount);
            n4u = callArgCount;
            CALL_COMMON /* n3u: functionOffset, n4u: callArgCount */: {
              uint16_t functionOffset = n4u;
              callArgCount = (uint8_t)n4u;

              uint8_t maxStackDepth;
              VM_READ_BC_FIELD(&maxStackDepth, maxStackDepth, functionOffset, vm_TsFunctionHeader, pBytecode);
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
              programCounter = VM_PROGMEM_P_ADD(pBytecode, functionOffset + sizeof (vm_TsFunctionHeader));

              break;
            }
          }


          case VM_OP3_JUMP_2:
          JUMP_COMMON:
            programCounter = VM_PROGMEM_P_ADD(programCounter, n3s);
            break;

          case VM_OP3_BRANCH_2: {
            BRANCH_COMMON: {
              vm_Value predicate = POP();
              bool isTruthy;
              VALUE_TO_BOOL(isTruthy, predicate);
              if (isTruthy) programCounter = VM_PROGMEM_P_ADD(programCounter, n3s);
              break;
            }
          }
          case VM_OP3_LOAD_LITERAL: VM_NOT_IMPLEMENTED(); break;
          case VM_OP3_LOAD_GLOBAL_3: VM_NOT_IMPLEMENTED(); break;
          case VM_OP3_STORE_GLOBAL_3: VM_NOT_IMPLEMENTED(); break;
          default: VM_UNEXPECTED_INTERNAL_ERROR(); break;
        }
        break;
      }

      default: VM_UNEXPECTED_INTERNAL_ERROR(); break;
    }
  }

EXIT:
  FLUSH_REGISTER_CACHE();
  return err;
}

void vm_free(vm_VM* vm) {
  gc_freeGCMemory(vm);
  VM_EXEC_SAFE_MODE(memset(vm, 0, sizeof*(vm)));
  free(vm);
}

// Note: size is measured in allocation units
static GO_t gc_allocate(vm_VM* vm, uint16_t size) {
  // TODO: The common thing to do with allocated memory is to write to it, so it
  // would be useful to track an "actual" pointer as well

  // Note: this is still valid when the bucket is null
  GO_t result = vm->gc_allocationCursor;
  GO_t endOfResult = result + size;
  if (endOfResult > vm->gc_bucketEnd) {
    return gc_createNextBucketAndAllocate(vm, size);
  }
  vm->gc_allocationCursor = endOfResult;
  return result;
}

// Note: size is the size of the allocation, not the bucket
static GO_t gc_createNextBucketAndAllocate(vm_VM* vm, uint16_t size) {
  uint16_t bucketSize = VM_ALLOCATION_BUCKET_SIZE;
  if (size > bucketSize) {
    bucketSize = size;
    return 0;
  }
  if (!gc_createNextBucket(vm, bucketSize)) return 0;

  GO_t result = vm->gc_allocationCursor;
  GO_t endOfResult = result + size;
  vm->gc_allocationCursor = endOfResult;
  return result;
}

static vm_TeError gc_createNextBucket(vm_VM* vm, uint16_t bucketSize) {
  vm_TsBucket* bucket = malloc(bucketSize + sizeof(vm_TsBucket));
  if (!bucket) return VM_E_MALLOC_FAIL;
  #if VM_SAFE_MODE
    memset(bucket, 0, bucketSize + sizeof(vm_TsBucket));
  #endif
  bucket->prev = vm->gc_lastBucket;
  bucket->addressStart = vm->gc_bucketEnd;
  vm->gc_allocationCursor = vm->gc_bucketEnd;
  vm->gc_bucketEnd += bucketSize;
  vm->gc_lastBucket = bucket;
  return VM_E_SUCCESS;
}

static void gc_markAllocation(uint16_t* markTable, vm_Pointer_t p, uint16_t size) {
  if (VM_TAG_OF(p) != VM_TAG_GC_P) return;
  uint16_t offset = VM_VALUE_OF(p);

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

static void gc_freeGCMemory(vm_VM* vm) {
  while (vm->gc_lastBucket) {
    vm_TsBucket* prev = vm->gc_lastBucket->prev;
    free(vm->gc_lastBucket);
    vm->gc_lastBucket = prev;
  }
  vm->gc_bucketEnd = VM_ADDRESS_SPACE_START;
  vm->gc_allocationCursor = VM_ADDRESS_SPACE_START;
}

static void gc_traceWord(vm_VM* vm, uint16_t* markTable, uint16_t word, uint16_t* pTotalSize) {
  uint16_t tag = word & VM_TAG_MASK;
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

  uint16_t pAllocation = word;
  if (gc_isMarked(pAllocation)) return; // TODO: implement gc_isMarked

  uint16_t headerWord = vm_readHeaderWord(vm, pAllocation);
  vm_TeTypeCode typeCode = headerWord >> 12;
  uint16_t headerData = headerWord & 0xFFF;

  VM_SIZE_T allocationSize; // Including header
  uint8_t headerSize = 2;
  switch (typeCode) {
    case VM_TC_REF: {
      gc_markAllocation(markTable, pAllocation - 2, 4);
      vm_Value value = vm_readUInt16(vm, pAllocation);
      // TODO: This shouldn't be recursive. It shouldn't use the C stack
      gc_traceWord(vm, markTable, value, pTotalSize);
      return;
    }
    case VM_TC_VIRTUAL: return VM_NOT_IMPLEMENTED();
    case VM_TC_INT24: allocationSize = 4; headerSize = 1; break;

    case VM_TC_STRING:
    case VM_TC_UNIQUED_STRING:
    case VM_TC_BIG_INT:
    case VM_TC_SYMBOL:
    case VM_TC_EXT_FUNC:
    case VM_TC_INT32:
    case VM_TC_DOUBLE:
      allocationSize = 2 + headerData; break;

    case VM_TC_PROPERTY_LIST: {
      uint16_t propCount = headerData;
      gc_markAllocation(markTable, pAllocation - 2, 4);
      vm_Pointer_t pCell = vm_readUInt16(vm, pAllocation);
      while (propCount--) {
        gc_markAllocation(markTable, pCell, 6);
        vm_Pointer_t next = vm_readUInt16(vm, pCell + 0);
        vm_Value key = vm_readUInt16(vm, pCell + 2);
        vm_Value value = vm_readUInt16(vm, pCell + 4);

        // TODO: This shouldn't be recursive. It shouldn't use the C stack
        gc_traceWord(vm, markTable, key, pTotalSize);
        gc_traceWord(vm, markTable, value, pTotalSize);

        pCell = next;
      }
      return;
    }

    case VM_TC_LIST: {
      uint16_t itemCount = headerData;
      gc_markAllocation(markTable, pAllocation - 2, 4);
      vm_Pointer_t pCell = vm_readUInt16(vm, pAllocation);
      while (itemCount--) {
        gc_markAllocation(markTable, pCell, 6);
        vm_Pointer_t next = vm_readUInt16(vm, pCell + 0);
        vm_Value value = vm_readUInt16(vm, pCell + 2);

        // TODO: This shouldn't be recursive. It shouldn't use the C stack
        gc_traceWord(vm, markTable, value, pTotalSize);

        pCell = next;
      }
      return;
    }

    case VM_TC_ARRAY: {
      uint16_t itemCount = headerData;
      // Need to mark before recursing
      allocationSize = 2 + itemCount * 2;
      gc_markAllocation(markTable, pAllocation - 2, allocationSize);
      vm_Pointer_t pItem = pAllocation;
      while (itemCount--) {
        vm_Value item = vm_readUInt16(vm, pItem);
        pItem += 2;
        // TODO: This shouldn't be recursive. It shouldn't use the C stack
        gc_traceWord(vm, markTable, item, pTotalSize);
      }
      return;
    }

    case VM_TC_FUNCTION: {
      // It shouldn't get here because functions are only stored in ROM (see
      // note at the beginning of this function)
      VM_UNEXPECTED_INTERNAL_ERROR();
      return;
    }
  }
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
    bool isMarked = markBits & mask;
    if (inAllocation) {
      if (isMarked) inAllocation = false;
    } else {
      if (isMarked) {
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
    vm_error(vm, VM_E_MALLOC_FAIL);
    return;
  }
  uint16_t* adjustmentTable = (uint16_t*)temp;
  uint16_t* markTable = (uint16_t*)(temp + adjustmentTableSize);
  uint16_t* markTableEnd = (uint16_t*)((uint8_t*)markTable + markTableSize);

  VM_ASSERT(((intptr_t)adjustmentTable & 1) == 0); // Needs to be 16-bit aligned for the following algorithm to work

  memset(markTable, 0, markTableSize);
  VM_EXEC_SAFE_MODE(memset(adjustmentTable, 0, adjustmentTableSize));

  // -- Mark Phase--

  uint16_t totalSize = 0;

  // Mark Global Variables
  {
    uint16_t globalVariableCount;
    VM_READ_BC_HEADER_FIELD(&globalVariableCount, globalVariableCount, vm->pBytecode);

    uint16_t* p = vm_dataMemory(vm);
    while (globalVariableCount--)
      gc_traceWord(vm, markTable, *p++, &totalSize);
  }

  // Mark other roots in data memory
  {
    uint16_t gcRootsOffset;
    uint16_t gcRootsCount;
    VM_READ_BC_HEADER_FIELD(&gcRootsOffset, gcRootsOffset, vm->pBytecode);
    VM_READ_BC_HEADER_FIELD(&gcRootsCount, gcRootsCount, vm->pBytecode);

    VM_PROGMEM_P pTableEntry = VM_PROGMEM_P_ADD(vm->pBytecode, gcRootsOffset);
    uint16_t* p = vm_dataMemory(vm);
    while (gcRootsCount--) {
      uint16_t dataOffsetWords;
      // The table entry in program memory gives us an offset in data memory
      VM_READ_PROGMEM(&dataOffsetWords, pTableEntry, sizeof dataOffsetWords);
      uint16_t dataValue = vm_dataMemory(vm)[dataOffsetWords];
      gc_traceWord(vm, markTable, dataValue, &totalSize);
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
      bool isMarked = (*pMark) & mask;
      if (inAllocation) {
        if (isMarked) inAllocation = false;
      } else {
        if (isMarked) {
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

  // TODO: Pointer update: global variables
  // TODO: Pointer update: roots variables
  // TODO: Pointer update: recursion

  {
    uint16_t* p = vm_dataMemory(vm);
    while (true) {
      uint8_t layoutEntry;
      VM_READ_PROGMEM(&layoutEntry, pLayoutEntry, sizeof layoutEntry);
      if (!layoutEntry) continue;
      vm_TePointerTypeCode typeCode1 = layoutEntry >> 4;
      vm_TePointerTypeCode typeCode2 = layoutEntry & 0x0F;

      if (typeCode1 == VM_PTC_END) break;
      gc_updatePointer(vm, p++, markTable, adjustmentTable);
      if (typeCode2 == VM_PTC_END) break;
      gc_updatePointer(vm, p++, markTable, adjustmentTable);

      pLayoutEntry = VM_PROGMEM_P_ADD(pLayoutEntry, 1);
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
  if (!gc_createNextBucket(vm, totalSize)) return;

  {
    VM_ASSERT(vm->gc_lastBucket && !vm->gc_lastBucket->prev); // Only one bucket
    uint16_t* source = (uint16_t*)(first + 1); // Start just after the header
    uint16_t* sourceEnd = (uint16_t*)((uint8_t*)source + first->addressStart/*size*/);
    uint16_t* target = (uint16_t*)(vm->gc_lastBucket + 1); // Start just after the header
    uint16_t* pMark = &markTable[VM_ADDRESS_SPACE_START / VM_GC_ALLOCATION_UNIT / 16];
    uint16_t mask = 0x8000 >> ((VM_ADDRESS_SPACE_START / VM_GC_ALLOCATION_UNIT) & 0xF);
    uint16_t markBits = *pMark++;
    bool copying = false;
    while (first) {
      bool isMarked = markBits & mask;
      if (copying) {
        *target++ = *source++;
        if (isMarked) copying = false;
      } else {
        if (isMarked) {
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

static inline uint16_t* vm_dataMemory(vm_VM* vm) {
  return (uint16_t*)(vm + 1); // Data starts right after the header
}

static void* gc_deref(vm_VM* vm, uint16_t addr) {
  VM_ASSERT(addr & VM_VALUE_MASK);
  #if VM_SAFE_MODE
    if (addr >= vm->gc_allocationCursor) {
      vm_error(vm, VM_E_INVALID_ADDRESS);
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
      vm_error(vm, VM_E_INVALID_ADDRESS);
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

static void* vm_deref(vm_VM* vm, vm_Value pSrc) {
  uint16_t addr = VM_VALUE_OF(pSrc);
  switch (VM_TAG_OF(pSrc)) {
    case VM_TAG_GC_P: return gc_deref(vm, addr);
    case VM_TAG_DATA_P: return vm_dataDeref(vm, addr);
    default: VM_UNEXPECTED_INTERNAL_ERROR();
  }
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
  VM_ASSERT(vm_typeOf(vm, func) == VM_TC_FUNCTION);

  if (!vm->stack) {
    vm_TsStack* stack = malloc(sizeof (vm_TsStack) + VM_STACK_SIZE);
    if (!stack) return VM_E_MALLOC_FAIL;
    memset(&stack->reg, 0, sizeof stack->reg);
    vm_TsRegisters* reg = &stack->reg;
    uint16_t* bottomOfStack = (uint16_t*)(stack + 1);
    reg->programCounter = 0;
    reg->pFrameBase = bottomOfStack;
    reg->pStackPointer = bottomOfStack;
    reg->argCount = 0;
    vm->stack = stack;
  }

  vm_TsStack* stack = vm->stack;
  uint16_t* bottomOfStack = (uint16_t*)(stack + 1);
  vm_TsRegisters* reg = &stack->reg;

  VM_ASSERT(reg->programCounter == 0); // Assert that we're outside the VM at the moment

  BO_t functionOffset = VM_VALUE_OF(func);
  uint8_t maxStackDepth;
  VM_READ_BC_FIELD(&maxStackDepth, maxStackDepth, functionOffset, vm_TsFunctionHeader, vm->pBytecode);
  if (vm->stack->reg.pStackPointer + maxStackDepth > VM_TOP_OF_STACK(vm)) {
    return VM_E_STACK_OVERFLOW;
  }

  vm_push(vm, func);
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

  uint16_t functionTableEntry = exportTableOffset;
  for (int i = 0; i < exportTableSize; i++) {
    vm_VMExportID exportID;
    VM_READ_BC_FIELD(&exportID, exportID, functionTableEntry, vm_TsFunctionTableEntry, pBytecode);
    if (exportID == id) {
      uint16_t functionOffset;
      VM_READ_BC_FIELD(&functionOffset, functionOffset, functionTableEntry, vm_TsFunctionTableEntry, pBytecode);
      *result = vm_makeValue(functionOffset, VM_TAG_PGM_P);
      return VM_E_SUCCESS;
    }
    functionTableEntry += sizeof (vm_TsFunctionTableEntry);
  }

  *result = VM_VALUE_UNDEFINED;
  return VM_E_FUNCTION_NOT_FOUND;
}

vm_TeError vm_resolveExports(vm_VM* vm, vm_VMExportID* id, vm_Value* result, uint8_t count) {
  vm_TeError err = VM_E_SUCCESS;
  while (count--) {
    vm_TeError tempErr = vm_resolveExport(vm, *id++, result++);
    if (tempErr != VM_E_SUCCESS)
      err = tempErr;
  }
  return err;
}

void vm_initializeGCHandle(vm_VM* vm, vm_GCHandle* handle) {
  VM_ASSERT(!vm_isHandleInitialized(vm, handle));
  handle->_next = vm->gc_handles;
  vm->gc_handles = handle;
  handle->_value = VM_VALUE_UNDEFINED;
}

void vm_cloneGCHandle(vm_VM* vm, vm_GCHandle* target, vm_GCHandle* source) {
  VM_ASSERT(!vm_isHandleInitialized(vm, source));
  vm_initializeGCHandle(vm, target);
  target->_value = source->_value;
}

vm_TeError vm_releaseGCHandle(vm_VM* vm, vm_GCHandle* handle) {
  vm_GCHandle** h = &vm->gc_handles;
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

static bool vm_isHandleInitialized(vm_VM* vm, vm_GCHandle* handle) {
  vm_GCHandle* h = vm->gc_handles;
  while (h) {
    if (h == handle) {
      return true;
    }
    h = h->_next;
  }
  return false;
}

static inline vm_Value vm_makeValue(uint16_t tag, uint16_t value) {
  VM_ASSERT(!(value & VM_TAG_MASK));
  VM_ASSERT(!(tag & VM_VALUE_MASK));
  return tag | value;
}

static vm_Value vm_binOp1(vm_VM* vm, vm_TeBinOp1 op, vm_Value left, vm_Value right) {
  switch (op) {
    case VM_BOP1_ADD: {
      if (vm_isString(vm, left) || vm_isString(vm, right)) {
        left = vm_convertToString(vm, left);
        right = vm_convertToString(vm, right);
        return vm_concat(vm, left, right);
      } else {
        left = vm_convertToNumber(vm, left);
        right = vm_convertToNumber(vm, right);
        return vm_addNumbers(vm, left, right);
      }
    }
    case VM_BOP1_SUBTRACT: return VM_NOT_IMPLEMENTED();
    case VM_BOP1_MULTIPLY: return VM_NOT_IMPLEMENTED();
    case VM_BOP1_DIVIDE_INT: return VM_NOT_IMPLEMENTED();
    case VM_BOP1_DIVIDE_FLOAT: return VM_NOT_IMPLEMENTED();
    case VM_BOP1_SHR_ARITHMETIC: return VM_NOT_IMPLEMENTED();
    case VM_BOP1_SHR_BITWISE: return VM_NOT_IMPLEMENTED();
    case VM_BOP1_SHL: return VM_NOT_IMPLEMENTED();
    default: return VM_UNEXPECTED_INTERNAL_ERROR();
  }
}

static vm_Value vm_binOp2(vm_VM* vm, vm_TeBinOp2 op, vm_Value left, vm_Value right) {
  switch (op) {
    case VM_BOP2_LESS_THAN: return VM_NOT_IMPLEMENTED();
    case VM_BOP2_GREATER_THAN: return VM_NOT_IMPLEMENTED();
    case VM_BOP2_LESS_EQUAL: return VM_NOT_IMPLEMENTED();
    case VM_BOP2_GREATER_EQUAL: return VM_NOT_IMPLEMENTED();
    case VM_BOP2_EQUAL: return VM_NOT_IMPLEMENTED();
    case VM_BOP2_NOT_EQUAL: return VM_NOT_IMPLEMENTED();
    case VM_BOP2_AND: return VM_NOT_IMPLEMENTED();
    case VM_BOP2_OR: return VM_NOT_IMPLEMENTED();
    default: return VM_UNEXPECTED_INTERNAL_ERROR();
  }
}

static vm_Value vm_convertToString(vm_VM* vm, vm_Value value) {
  return VM_NOT_IMPLEMENTED();
}

static vm_Value vm_concat(vm_VM* vm, vm_Value left, vm_Value right) {
  return VM_NOT_IMPLEMENTED();
}

static vm_Value vm_convertToNumber(vm_VM* vm, vm_Value value) {
  uint16_t tag = value & VM_TAG_MASK;
  if (tag == VM_TAG_INT) return value;

  vm_TeTypeCode type = vm_typeOf(vm, value);
  switch (type) {
    case VM_TC_WELL_KNOWN:
      switch (value) {
        case VM_VALUE_UNDEFINED: return 0;
        case VM_VALUE_NULL: return 0;
        case VM_VALUE_TRUE: return 1;
        case VM_VALUE_FALSE: return 0;
        case VM_VALUE_EMPTY_STRING: return 0;
        case VM_VALUE_NAN: return value;
        case VM_VALUE_INF: return value;
        case VM_VALUE_NEG_INF: return value;
        case VM_VALUE_NEG_ZERO: return value;
        default: return VM_UNEXPECTED_INTERNAL_ERROR();
      }
    case VM_TC_INT14: return value;
    case VM_TC_INT32: return value;
    case VM_TC_DOUBLE: return value;
    case VM_TC_STRING: return VM_NOT_IMPLEMENTED();
    case VM_TC_PROPERTY_LIST: return VM_VALUE_NAN;
    case VM_TC_STRUCT: return VM_VALUE_NAN;
    case VM_TC_LIST: return VM_VALUE_NAN;
    case VM_TC_ARRAY: return VM_VALUE_NAN;
    case VM_TC_FUNCTION: return VM_VALUE_NAN;

    default: return VM_UNEXPECTED_INTERNAL_ERROR();
  }
}

static vm_Value vm_addNumbers(vm_VM* vm, vm_Value left, vm_Value right) {
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

  vm_TeTypeCode leftType = vm_typeOf(vm, left);
  vm_TeTypeCode rightType = vm_typeOf(vm, right);

  // At this point, all the special cases have been handled
  VM_ASSERT((leftType != VM_TC_WELL_KNOWN) && (rightType != VM_TC_WELL_KNOWN));

  // If either is a double, then we need to perform double arithmetic
  if ((leftType == VM_TC_DOUBLE) || (rightType == VM_TC_DOUBLE)) {
    VM_DOUBLE leftDouble = vm_readDouble(vm, leftType, left);
    VM_DOUBLE rightDouble = vm_readDouble(vm, rightType, right);
    VM_DOUBLE result = leftDouble + rightDouble;
    return vm_newDouble(vm, result);
  } else {
    int32_t leftInt32 = vm_readInt32(vm, left, leftType);
    int32_t rightInt32 = vm_readInt32(vm, right, rightType);
    int32_t result = leftInt32 + rightInt32;
    bool overflowed = (uint32_t)result < (uint32_t)leftInt32;
    if (overflowed)
      return vm_newDouble(vm, (VM_DOUBLE)leftInt32 + (VM_DOUBLE)rightInt32);
    return vm_newInt32(vm, result);
  }
}

static vm_TeTypeCode vm_typeOf(vm_VM* vm, vm_Value value) {
  switch (VM_TAG_OF(value)) {
    case VM_TAG_INT: return VM_TC_INT14;
    case VM_TAG_GC_P: return ((vm_TsDynamicHeader*)gc_deref(vm, value))->type;
    case VM_TAG_DATA_P: return ((vm_TsDynamicHeader*)vm_dataDeref(vm, value))->type;
    case VM_TAG_PGM_P: {
      BO_t offset = VM_VALUE_OF(value);
      if (offset <= VM_VALUE_MAX_WELLKNOWN) return VM_TC_WELL_KNOWN;
      vm_TsDynamicHeader header;
      VM_READ_BC_AT(&header, offset, sizeof header, vm->pBytecode);
      return header.type;
    }
    default: {
      VM_UNEXPECTED_INTERNAL_ERROR();
      return 0;
    }
  }
}

static void vm_readPointedToValue(vm_VM* vm, void* target, vm_Value source, uint16_t size) {
  switch (VM_TAG_OF(source)) {
    case VM_TAG_INT: VM_UNEXPECTED_INTERNAL_ERROR(); break;
    case VM_TAG_GC_P: memcpy(target, VM_VALUE_OF_DYNAMIC(gc_deref(vm, source)), size);
    case VM_TAG_DATA_P: memcpy(target, VM_VALUE_OF_DYNAMIC(vm_dataDeref(vm, source)), size);
    case VM_TAG_PGM_P: {
      BO_t headerOffset = VM_VALUE_OF(source);
      if (headerOffset <= VM_VALUE_MAX_WELLKNOWN) VM_UNEXPECTED_INTERNAL_ERROR();
      #if VM_SAFE_MODE
        vm_TsDynamicHeader header;
        VM_READ_BC_AT(&header, headerOffset, sizeof header, vm->pBytecode);
        if (size > header.size) VM_UNEXPECTED_INTERNAL_ERROR();
      #endif
      BO_t valueOffset = headerOffset + sizeof (vm_TsDynamicHeader);
      VM_READ_BC_AT(&target, valueOffset, size, vm->pBytecode);
    }
    default: VM_UNEXPECTED_INTERNAL_ERROR();
  }
}

static vm_Value vm_newDouble(vm_VM* vm, VM_DOUBLE value) {
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

  GO_t goResult = gc_allocate(vm, sizeof (vm_TsDynamicHeader) + sizeof (VM_DOUBLE));
  vm_TsDynamicHeader* pResult = gc_deref(vm, goResult);
  pResult->size = sizeof (VM_DOUBLE);
  pResult->type = VM_TC_DOUBLE;
  VM_DOUBLE* resultValue = VM_VALUE_OF_DYNAMIC(pResult);
  *resultValue = value;

  return vm_makeGC_P(goResult);
}

static vm_Value vm_newInt32(vm_VM* vm, int32_t value) {
  if ((value >= VM_MIN_INT14) && (value <= VM_MAX_INT14)) {
    return value | VM_TAG_INT;
  }

  GO_t goResult = gc_allocate(vm, sizeof (vm_TsDynamicHeader) + sizeof (int32_t));
  vm_TsDynamicHeader* pResult = gc_deref(vm, goResult);
  pResult->size = sizeof (VM_DOUBLE);
  pResult->type = VM_TC_INT32;
  int32_t* resultValue = VM_VALUE_OF_DYNAMIC(pResult);
  *resultValue = value;

  return vm_makeGC_P(value);
}

static bool vm_valueToBool(vm_VM* vm, vm_Value value) {
  vm_TeTypeCode type = vm_typeOf(vm, value);
  switch (type) {
    case VM_TC_WELL_KNOWN: return VM_NOT_IMPLEMENTED();
    case VM_TC_INT14: return VM_NOT_IMPLEMENTED();
    case VM_TC_INT32: return VM_NOT_IMPLEMENTED();
    case VM_TC_DOUBLE: return VM_NOT_IMPLEMENTED();
    case VM_TC_STRING: return VM_NOT_IMPLEMENTED();
    case VM_TC_PROPERTY_LIST: return VM_NOT_IMPLEMENTED();
    case VM_TC_STRUCT: return VM_NOT_IMPLEMENTED();
    case VM_TC_LIST: return VM_NOT_IMPLEMENTED();
    case VM_TC_ARRAY: return VM_NOT_IMPLEMENTED();
    case VM_TC_FUNCTION: return VM_NOT_IMPLEMENTED();
    default: return VM_UNEXPECTED_INTERNAL_ERROR();
  }
}

static bool vm_isString(vm_VM* vm, vm_Value value) {
  if (value == VM_VALUE_EMPTY_STRING) return true;
  if (vm_typeOf(vm, value) == VM_TC_STRING) return true;
  return false;
}

/** Reads a numeric value that is a subset of a double */
static VM_DOUBLE vm_readDouble(vm_VM* vm, vm_TeTypeCode type, vm_Value value) {
  if (type == VM_TC_INT14) return (VM_DOUBLE)value;
  if (type == VM_TC_INT32) return (VM_DOUBLE)vm_readInt32(vm, type, value);
  if (type == VM_TC_DOUBLE) {
    VM_DOUBLE result;
    vm_readPointedToValue(vm, &result, value, sizeof result);
    return result;
  }
  if (type == VM_TC_WELL_KNOWN) {
    switch (value) {
      case VM_VALUE_NAN: return VM_DOUBLE_NAN;
      case VM_VALUE_INF: return INFINITY;
      case VM_VALUE_NEG_INF: return -INFINITY;
      case VM_VALUE_NEG_ZERO: return -0.0;
    }
  }
  return VM_UNEXPECTED_INTERNAL_ERROR();
}

static inline vm_Value vm_makeGC_P(GO_t v) {
  VM_ASSERT(!VM_TAG_OF(v));
  return v | VM_TAG_GC_P;
}

/** Reads a numeric value that is a subset of a 32-bit integer */
static int32_t vm_readInt32(vm_VM* vm, vm_TeTypeCode type, vm_Value value) {
  if (type == VM_TC_INT14) return value;
  if (type == VM_TC_INT32) {
    int32_t result;
    vm_readPointedToValue(vm, &result, value, sizeof result);
    return result;
  }
  return VM_UNEXPECTED_INTERNAL_ERROR();
}

static vm_Value vm_unOp(vm_VM* vm, vm_TeUnOp op, vm_Value arg) {
  return VM_NOT_IMPLEMENTED();
}

static void vm_push(vm_VM* vm, uint16_t value) {
  *(vm->stack->reg.pStackPointer++) = value;
}

static uint16_t vm_pop(vm_VM* vm) {
  return *(--vm->stack->reg.pStackPointer);
}

static inline uint16_t vm_readUInt16(vm_VM* vm, vm_Pointer_t p) {
  uint16_t result;
  vm_readMem(vm, &result, p, sizeof(result));
  return result;
}

static inline uint16_t vm_readHeaderWord(vm_VM* vm, vm_Pointer_t pAllocation) {
  return vm_readUInt16(vm, pAllocation - 2);
}

static void vm_readMem(vm_VM* vm, void* target, vm_Pointer_t source, VM_SIZE_T size) {
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
      VM_READ_BC_AT(target, addr, size, vm->pBytecode);
      break;
    }
    default: VM_UNEXPECTED_INTERNAL_ERROR();
  }
}

static void vm_writeMem(vm_VM* vm, vm_Pointer_t target, void* source, VM_SIZE_T size) {
  uint16_t addr = VM_VALUE_OF(target);
  switch (VM_TAG_OF(target)) {
    case VM_TAG_GC_P: {
      uint8_t* sourceAddress = gc_deref(vm, source);
      memcpy(sourceAddress, target, size);
      break;
    }
    case VM_TAG_DATA_P: {
      memcpy((uint8_t*)vm->dataMemory + addr, target, size);
      break;
    }
    case VM_TAG_PGM_P: {
      vm_error(vm, VM_E_ATTEMPT_TO_WRITE_TO_ROM);
      break;
    }
    default: VM_UNEXPECTED_INTERNAL_ERROR();
  }
}
