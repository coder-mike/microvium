/*
 * Instead of accessing pointers directly, Microvium goes through this memory
 * abstraction layer. When running natively on a 16-bit device without
 * MVM_SAFE_MODE, most of these operations should compile down to simple machine
 * instructions. But when running in MVM_SAFE_MODE, pointers are represented as
 * structs and extra checking is done to avoid dangling pointers.
 */
#pragma once


#if MVM_POINTER_CHECKING
typedef enum vm_TeMemoryRegion {
  MVM_MR_NULL,
  MVM_MR_GC,
  MVM_MR_BYTECODE,
  MVM_MR_GLOBALS,
  MVM_MR_C_CONST,
  MVM_MR_UNKNOWN, // May be host memory
} vm_TeMemoryRegion;
#endif

#pragma message ("X3")

/*
 * ---------------------------------- LongPtr --------------------------------
 *
 * Hungarian prefix: `lp`
 *
 * A nullable-pointer that can reference bytecode and RAM in the same address
 * space. Not necessarily 16-bit.
 *
 * The null representation for LongPtr is assumed to be 0.
 *
 * Values of this type are only managed through macros in the port file, never
 * directly, since the exact type depends on the architecture.
 *
 * See description of MVM_LONG_PTR_TYPE
 */
#if !MVM_POINTER_CHECKING
  typedef MVM_LONG_PTR_TYPE LongPtr;
#else
  typedef struct LongPtr {
    MVM_LONG_PTR_TYPE target;

    vm_TeMemoryRegion targetRegion;
    // The value of vm->gcPotentialRunCounter at the time that the pointer was
    // created. The GC is not aware of LongPtr values since they exist on the C
    // stack, so this counter provides a way of checking that the value couldn't
    // be dangling.
    uint16_t gcPotentialRunCounter;

    // If the pointer was computed from a VM value, then this is the value
    DynamicPtr dpValue;

    // If the target region is known, this is the memory offset within that region
    // (e.g. bytecode offset or GC memory offset)
    uint16_t offset;
  } LongPtr;
#endif

/**
 * Short Pointer
 *
 * Hungarian prefix: sp
 *
 * A ShortPtr is a 16-bit **non-nullable** reference which can refer to GC
 * memory, but not to data memory or bytecode.
 *
 * Note: To avoid confusion of when to use different kinds of null values,
 * ShortPtr should be considered non-nullable. When null is required, use
 * VM_VALUE_NULL for consistency, which is not defined as a short pointer.
 *
 * Note: At runtime, pointers _to_ GC memory must always be encoded as
 * `ShortPtr` or indirectly through a BytecodeMappedPtr to a global variable.
 * This is to improve efficiency of the GC, since it can assume that only values
 * with the lower bit `0` need to be traced/moved.
 *
 * On 16-bit architectures, while the script is running, ShortPtr can be a
 * native pointer, allowing for fast access. On other architectures, ShortPtr is
 * encoded as an offset from the beginning of the virtual heap.
 *
 * Note: the bytecode image is independent of target architecture, and always
 * stores ShortPtr as an offset from the beginning of the virtual heap. If the
 * runtime representation is a native pointer, the translation occurs in
 * `loadPointers`.
 *
 * A ShortPtr must never exist in a ROM slot, since they need to have a
 * consistent representation in all cases, and ROM slots are not visited by
 * `loadPointers`. Also because short pointers are used iff they point to GC
 * memory, which is subject to relocation and therefore cannot be referenced
 * from an immutable medium.
 *
 * If the lowest bit of the `ShortPtr` is 0 (i.e. points to an even boundary),
 * then the `ShortPtr` is also a valid `Value`.
 *
 * NULL short pointers are only allowed in some special circumstances, but are
 * mostly not valid.
 */
typedef uint16_t ShortPtr;

/**
 * Bytecode-mapped Pointer
 *
 * Hungarian prefix: `dp` (because BytecodeMappedPtr is generally used as a
 * DynamicPtr)
 *
 * A `BytecodeMappedPtr` is a 16-bit reference to something in ROM or RAM. It is
 * interpreted as an offset into the bytecode image, and its interpretation
 * depends where in the image it points to.
 *
 * If the offset points to the BCS_ROM section of bytecode, it is interpreted as
 * pointing to that ROM allocation or function.
 *
 * If the offset points to the BCS_GLOBALS region of the bytecode image, the
 * `BytecodeMappedPtr` is treated being a reference to the allocation referenced
 * by the corresponding global variable. This allows ROM Values, such as
 * literal, exports, and builtins, to reference RAM allocations. *Note*: for the
 * moment, behavior is not defined if the corresponding global has non-pointer
 * contents, such as an Int14 or well-known value. In future this may be
 * explicitly allowed.
 *
 * A `BytecodeMappedPtr` is only a pointer type and is not defined to encode the
 * well-known values or null.
 */
typedef uint16_t BytecodeMappedPtr;

/**
 * Dynamic Pointer
 *
 * Hungarian prefix: `dp`
 *
 * A `Value` that is a pointer. I.e. its lowest bits are not `11` and it does
 * not encode a well-known value. Can be one of:
 *
 *  - `ShortPtr`
 *  - `BytecodeMappedPtr`
 *  - `VM_VALUE_NULL`
 *
 * Note that the only valid representation of null for this pointer is
 * `VM_VALUE_NULL`, not 0.
 */
#pragma message ("X4")
typedef uint16_t DynamicPtr;

/**
 * ROM Pointer
 *
 * Hungarian prefix: none
 *
 * A `DynamicPtr` which is known to only point to ROM
 */
typedef uint16_t RomPtr;

/**
 * Int14 encoded as a Value
 *
 * Hungarian prefix: `vi`
 *
 * A 14-bit signed integer represented in the high 14 bits of a 16-bit Value,
 * with the low 2 bits set to the bits `11`, as per the `Value` type.
 */
typedef uint16_t VirtualInt14;


#define READ_FIELD_2(longPtr, structType, fieldName) \
  LongPtr_read2_aligned(LongPtr_add(longPtr, OFFSETOF(structType, fieldName)))

#define READ_FIELD_1(longPtr, structType, fieldName) \
  LongPtr_read1(LongPtr_add(longPtr, OFFSETOF(structType, fieldName)))

#if MVM_POINTER_CHECKING
  void vm_validateLongPtr(VM* vm, LongPtr lp) {
    /*
    Each allocation is a potential cause of GC collection, so recording the number
    of allocations when a pointer is created vs when it is accessed tells us if
    the pointer _could have been_ dangling if the GC had run during that time.
    */
    VM_ASSERT(vm, (lp.targetRegion != MVM_MR_GC) || (vm->gcPotentialRunCounter == lp.gcPotentialRunCounter));
  }
#endif

#if MVM_POINTER_CHECKING
  void vm_validateShortPtr(VM* vm, ShortPtr lp) {
    uint16_t maskByte = lp >> 4;
    uint16_t maskBit = lp & 0xF;
    VM_ASSERT(vm, maskByte < vm->gcAllocationMaskSize);
    VM_ASSERT(vm, vm->gcAllocationMask[maskByte] & ((uint16_t)1 << maskBit));
  }
#endif

#if !MVM_POINTER_CHECKING
  #define vm_crcCheck_long(vm, lpData, size, expected) MVM_CHECK_CRC16_CCITT(lpData, size, expected)
#else
  static bool vm_crcCheck_long(VM* vm, LongPtr lpData, uint16_t size, uint16_t expected) {
    vm_validateLongPtr(vm, lpData);
    return MVM_CHECK_CRC16_CCITT(lpData.target, size, expected);
  }
#endif

#if !MVM_POINTER_CHECKING
  #define LongPtr_lt(vm, x, y) ((x) < (y))
#else
  static bool LongPtr_lt(VM* vm, LongPtr x, LongPtr y) {
    vm_validateLongPtr(vm, x);
    vm_validateLongPtr(vm, y);
    // This assumes that MVM_LONG_PTR_TYPE is ordinal
    return x.target < y.target;
  }
#endif

#if !MVM_POINTER_CHECKING
  #define vm_longPtr_null 0
#else
  static const LongPtr vm_longPtr_null = {
    0,             // target
    MVM_MR_NULL,   // targetRegion
    0,             // gcPotentialRunCounter
    VM_VALUE_NULL, // dpValue
    0,             // offset
  };
#endif

#if !MVM_POINTER_CHECKING
  #define LongPtr_new(vm, p, r) (MVM_LONG_PTR_NEW((p)))
#else
  static inline LongPtr LongPtr_new(VM* vm, void* p, vm_TeMemoryRegion targetRegion) {
    CODE_COVERAGE(284); // Hit
    LongPtr result = {
      MVM_LONG_PTR_NEW(p), // target
      targetRegion, // targetRegion
      vm->gcPotentialRunCounter, // gcPotentialRunCounter
      0, // dpValue
      0, // offset
    };
    vm_validateLongPtr(vm, result);
    return result;
  }
#endif

#if !MVM_POINTER_CHECKING
  #define LongPtr_truncateToNative(vm, lp) (MVM_LONG_PTR_TRUNCATE((lp)))
#else
  static void* LongPtr_truncateToNative(VM* vm, LongPtr lp) {
    CODE_COVERAGE(332); // Hit
    vm_validateLongPtr(vm, lp);
    void* p = (void*)(MVM_LONG_PTR_TRUNCATE((lp.target)));
    return p;
  }
#endif

#if !MVM_POINTER_CHECKING
  static bool LongPtr_tryTruncateToNative(mvm_VM* vm, LongPtr lp, void** out_p) {
    vm_validateLongPtr(vm, lp);
    void* p = (void*)(MVM_LONG_PTR_TRUNCATE((lp)));
    if (MVM_LONG_PTR_NEW(p) == lp) {
      *out_p = p;
      return true;
    } else {
      *out_p = NULL;
      return false;
    }
  }
#else
  static bool LongPtr_tryTruncateToNative(mvm_VM* vm, LongPtr lp, void** out_p) {
    CODE_COVERAGE(); // Hit
    vm_validateLongPtr(vm, lp);
    void* p = (void*)(MVM_LONG_PTR_TRUNCATE((lp.target)));
    if (MVM_LONG_PTR_NEW(p) == lp.target) {
      *out_p = p;
      return true;
    } else {
      *out_p = NULL;
      return false;
    }
  }
#endif

static ShortPtr LongPtr_truncateToShort(mvm_VM* vm, LongPtr lp) {
  CODE_COVERAGE(); // Hit
  vm_validateLongPtr(vm, lp);
  void* p = LongPtr_truncateToNative(vm, lp);
  ShortPtr sp = ShortPtr_encode(vm, p);
  return sp;
}

static LongPtr ShortPtr_extendToLong(mvm_VM* vm, ShortPtr sp) {
  CODE_COVERAGE(); // Hit
  VM_ASSERT(vm, Value_isShortPtr(sp));
  vm_validateShortPtr(vm, sp);
  LongPtr result = LongPtr_new(vm, ShortPtr_decode(vm, sp), MVM_MR_GC);
  return result;
}

#if !MVM_POINTER_CHECKING
  #define LongPtr_add(vm, lp, offset) (MVM_LONG_PTR_ADD((lp), (offset)))
#else
  static LongPtr LongPtr_add(VM* vm, LongPtr lp, int16_t offset) {
    CODE_COVERAGE(333); // Hit
    vm_validateLongPtr(vm, lp);
    LongPtr result = lp;
    result.target = MVM_LONG_PTR_ADD((result.target), offset);
    return result;
  }
#endif

#if !MVM_POINTER_CHECKING
  #define LongPtr_sub(vm, lp, offset) (MVM_LONG_PTR_SUB((lp2), (lp1)))
#else
  static uint16_t LongPtr_sub(VM* vm, LongPtr lp2, LongPtr lp1) {
    CODE_COVERAGE(333); // Hit
    vm_validateLongPtr(vm, lp2);
    vm_validateLongPtr(vm, lp1);
    VM_ASSERT(vm, lp2.targetRegion == lp1.targetRegion);
    intptr_t diff = (intptr_t)MVM_LONG_PTR_SUB((lp2.target), (lp1.target));
    VM_ASSERT(vm, (diff & 0xFFFF) == diff);
    return (uint16_t)diff;
  }
#endif

#if !MVM_POINTER_CHECKING
  #define LongPtr_read1(vm, lp) ((uint8_t)(MVM_READ_LONG_PTR_1((lp))))
#else
  static uint8_t LongPtr_read1(VM* vm, LongPtr lp) {
    CODE_COVERAGE(335); // Hit
    vm_validateLongPtr(vm, lp);
    uint8_t result = (uint8_t)(MVM_READ_LONG_PTR_1((lp.target)));
    return result;
  }
#endif

// TODO: Check that we have some kind of unit tests (or add them) for all the non-pointer-checked paths
#if !MVM_POINTER_CHECKING
  #define LongPtr_read2_aligned(vm, lp) ((uint16_t)(MVM_READ_LONG_PTR_2(lp)))
#else
  // Read a 16-bit value from a long pointer, if the target is 16-bit aligned
  static uint16_t LongPtr_read2_aligned(VM* vm, LongPtr lp) {
    CODE_COVERAGE(336); // Hit
    vm_validateLongPtr(vm, lp);
    // Expect an even boundary. Weird things happen on some platforms if you try
    // to read unaligned memory through aligned instructions.
    VM_ASSERT(vm, ((uint16_t)lp.target & 1) == 0);

    uint16_t result = (uint16_t)(MVM_READ_LONG_PTR_2(lp.target));
    return result;
  }
#endif

#if !MVM_POINTER_CHECKING
  static inline uint16_t LongPtr_read2_unaligned(mvm_VM* vm, LongPtr lp) {
    return (uint32_t)(MVM_READ_LONG_PTR_1(lp)) |
      ((uint32_t)(MVM_READ_LONG_PTR_1((MVM_LONG_PTR_ADD(lp, 1)))) << 8);
  }
#else
  // Read a 16-bit value from a long pointer, if the target is not 16-bit aligned
  static uint16_t LongPtr_read2_unaligned(VM* vm, LongPtr lp) {
    CODE_COVERAGE(626); // Hit
    vm_validateLongPtr(vm, lp);

    uint16_t result = (uint32_t)(MVM_READ_LONG_PTR_1(lp.target)) |
      ((uint32_t)(MVM_READ_LONG_PTR_1((MVM_LONG_PTR_ADD(lp.target, 1)))) << 8);
    return result;
  }
#endif

#if !MVM_POINTER_CHECKING
  static inline uint32_t LongPtr_read4(LongPtr lp) {
    return (uint32_t)(MVM_READ_LONG_PTR_2(lp)) |
      ((uint32_t)(MVM_READ_LONG_PTR_2((MVM_LONG_PTR_ADD(lp, 2)))) << 16);
  }
#else
  static uint32_t LongPtr_read4(VM* vm, LongPtr lp) {
    CODE_COVERAGE(337); // Hit
    vm_validateLongPtr(vm, lp);

    // We don't often read 4 bytes, since the word size for microvium is 2 bytes.
    // When we do need to, I think it's safer to just read it as 2 separate words
    // since we don't know for sure that we're not executing on a 32 bit machine
    // that can't do unaligned access. All memory in microvium is at least 16-bit
    // aligned, with the exception of bytecode instructions, but those do not
    // contain 32-bit literals.
    VM_ASSERT(vm, ((uint16_t)lp.target & 1) == 0);

    uint32_t result = (uint32_t)(MVM_READ_LONG_PTR_2((lp.target))) |
      ((uint32_t)(MVM_READ_LONG_PTR_2((MVM_LONG_PTR_ADD((lp.target), 2)))) << 16);
    return result;
  }
#endif

static bool Value_encodesBytecodeMappedPtr(Value value) {
  CODE_COVERAGE(37); // Hit
  return ((value & 3) == 1) && value >= VM_VALUE_WELLKNOWN_END;
}

static LongPtr DynamicPtr_decode_long(mvm_VM* vm, DynamicPtr ptr) {
  CODE_COVERAGE(217); // Hit

  if (Value_isShortPtr(ptr))  {
    CODE_COVERAGE(218); // Hit
    return ShortPtr_extendToLong(vm, ptr);
  }

  if (ptr == VM_VALUE_NULL) {
    CODE_COVERAGE(219); // Hit
    return LongPtr_new(vm, NULL, MVM_MR_NULL);
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
static void* DynamicPtr_decode_native(mvm_VM* vm, DynamicPtr ptr) {
  CODE_COVERAGE(253); // Hit
  LongPtr lp = DynamicPtr_decode_long(vm, ptr);
  void* p = LongPtr_truncateToNative(vm, lp);
  return p;
}

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
  static void* ShortPtr_decode(mvm_VM* vm, ShortPtr shortPtr) {
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
  static inline ShortPtr ShortPtr_encode_generic(mvm_VM* vm, TsBucket* pLastBucket, void* ptr) {
    CODE_COVERAGE(209); // Hit
    return pointerOffsetInHeap(vm, pLastBucket, ptr);
  }

  // Encodes a pointer as pointing to a value in the current heap
  static inline ShortPtr ShortPtr_encode(mvm_VM* vm, void* ptr) {
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

  static LongPtr BytecodeMappedPtr_decode_long(mvm_VM* vm, BytecodeMappedPtr ptr) {
    CODE_COVERAGE(214); // Hit

    // BytecodeMappedPtr values are treated as offsets into a bytecode image
    uint16_t offsetInBytecode = ptr;

    LongPtr lpBytecode = vm->lpBytecode;
    LongPtr lpTarget = LongPtr_add(vm, lpBytecode, offsetInBytecode);

    // A BytecodeMappedPtr can either point to ROM or via a global variable to
    // RAM. Here to discriminate the two, we're assuming the handles section comes
    // first
    VM_ASSERT(vm, BCS_ROM < BCS_GLOBALS);
    uint16_t globalsOffset = getSectionOffset(vm, lpBytecode, BCS_GLOBALS);

    if (offsetInBytecode < globalsOffset) { // Points to ROM section?
      CODE_COVERAGE(215); // Hit
      VM_ASSERT(vm, offsetInBytecode >= getSectionOffset(vm, lpBytecode, BCS_ROM));
      VM_ASSERT(vm, offsetInBytecode < getSectionOffset(vm, lpBytecode, sectionAfter(vm, BCS_ROM)));
      VM_ASSERT(vm, (ptr & 1) == 0);

      // The pointer just references ROM
      return lpTarget;
    }
    else { // Else, must point to RAM via a global variable
      CODE_COVERAGE(216); // Hit
      VM_ASSERT(vm, offsetInBytecode >= getSectionOffset(vm, lpBytecode, BCS_GLOBALS));
      VM_ASSERT(vm, offsetInBytecode < getSectionOffset(vm, lpBytecode, sectionAfter(vm, BCS_GLOBALS)));
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

#define READ_FIELD_2(vm, longPtr, structType, fieldName) \
  LongPtr_read2_aligned(vm, LongPtr_add(vm, longPtr, OFFSETOF(structType, fieldName)))

#define READ_FIELD_1(vm, longPtr, structType, fieldName) \
  LongPtr_read1(vm, LongPtr_add(vm, longPtr, OFFSETOF(structType, fieldName)))

#if !MVM_POINTER_CHECKING
#define LongPtr_notNull(vm, lp) ((lp) != 0)
#else
  static bool LongPtr_notNull(mvm_VM* vm, LongPtr lp) {
    vm_validateLongPtr(vm, lp);
    return lp.target != 0;
  }
#endif