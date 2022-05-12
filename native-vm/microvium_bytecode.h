#pragma once

#include "stdint.h"

#define MVM_BYTECODE_VERSION 4

// These sections appear in the bytecode in the order they appear in this
// enumeration.
typedef enum mvm_TeBytecodeSection {
  /**
   * Import Table
   *
   * List of host function IDs (vm_TsImportTableEntry) which are called by the
   * VM. References from the VM to host functions are represented as indexes
   * into this table. These IDs are resolved to their corresponding host
   * function pointers when a VM is restored.
   */
  BCS_IMPORT_TABLE,

  /**
   * A list of immutable `vm_TsExportTableEntry` that the VM exports, mapping
   * export IDs to their corresponding VM Value. Mostly these values will just
   * be function pointers.
   */
  // TODO: We need to test what happens if we export numbers and objects
  BCS_EXPORT_TABLE,

  /**
   * Short Call Table. Table of vm_TsShortCallTableEntry.
   *
   * To make the representation of function calls in IL more compact, up to 256
   * of the most frequent function calls are listed in this table, including the
   * function target and the argument count.
   *
   * See `LBL_CALL_SHORT`
   */
  BCS_SHORT_CALL_TABLE,

  /**
   * Builtins
   *
   * Table of `Value`s that need to be directly identifyable by the engine, such
   * as the Array prototype.
   *
   * These are not copied into RAM, they are just constant values like the
   * exports, but like other values in ROM they are permitted to hold mutable
   * values by pointing (as BytecodeMappedPtr) to the corresponding global
   * variable slot.
   *
   * Note: at one point, I had these as single-byte offsets into the global
   * variable space, but this made the assumption that all accessible builtins
   * are also mutable, which is probably not true. The new design makes the
   * opposite assumption: most builtins will be immutable at runtime (e.g.
   * nobody changes the array prototype), so they can be stored in ROM and
   * referenced by immutable Value pointers, making them usable but not
   * consuming RAM at all. It's the exception rather than the rule that some of
   * these may be mutable and require indirection through the global slot table.
   */
  BCS_BUILTINS,

  /**
   * Interned Strings Table
   *
   * To keep property lookup efficient, Microvium requires that strings used as
   * property keys can be compared using pointer equality. This requires that
   * there is only one instance of each string (see
   * https://en.wikipedia.org/wiki/String_interning). This table is the
   * alphabetical listing of all the strings in ROM (or at least, all those
   * which are valid property keys). See also TC_REF_INTERNED_STRING.
   *
   * There may be two string tables: one in ROM and one in RAM. The latter is
   * required in general if the program might use arbitrarily-computed strings
   * as property keys. For efficiency, the ROM string table is contiguous and
   * sorted, to allow for binary searching, while the RAM string table is a
   * linked list for efficiency in appending (expected to be used only
   * occasionally).
   */
  BCS_STRING_TABLE,

  /**
   * Functions and other immutable data structures.
   *
   * While the whole bytecode is essentially "ROM", only this ROM section
   * contains addressable allocations.
   */
  BCS_ROM,

  /**
   * Globals
   *
   * One `Value` entry for the initial value of each global variable. The number
   * of global variables is determined by the size of this section.
   *
   * This section will be copied into RAM at startup (restore).
   *
   * Note: the global slots are used both for global variables and for "handles"
   * (these are different to the user-defined handles for referencing VM objects
   * from user space). Handles allow ROM allocations to reference RAM
   * allocations, even though the ROM can't be updated when the RAM allocation
   * moves during a GC collection. A handle is a slot in the "globals" space,
   * where the slot itself is pointed to by a ROM value and it points to the
   * corresponding RAM value. During a GC cycle, the RAM value may move and the
   * handle slot is updated, but the handle slot itself doesn't move. See
   * `offsetToDynamicPtr` in `encode-snapshot.ts`.
   *
   * The handles appear as the *last* global slots, and will generally not be
   * referenced by `LOAD_GLOBAL` instructions.
   */
  BCS_GLOBALS,

  /**
   * Heap Section: heap allocations.
   *
   * This section is copied into RAM when the VM is restored. It becomes the
   * initial value of the GC heap. It contains allocations that are mutable
   * (like the DATA section) but also subject to garbage collection.
   *
   * Note: the heap must be at the end, because it is the only part that changes
   * size from one snapshot to the next. There is code that depends on this
   * being the last section because the size of this section is computed as
   * running to the end of the bytecode image.
   */
  BCS_HEAP,

  BCS_SECTION_COUNT,
} mvm_TeBytecodeSection;

typedef enum mvm_TeBuiltins {
  BIN_INTERNED_STRINGS,
  BIN_ARRAY_PROTO,

  BIN_BUILTIN_COUNT
} mvm_TeBuiltins;

// Minimal bytecode is 32 bytes (sizeof(mvm_TsBytecodeHeader) + BCS_SECTION_COUNT*2 + BIN_BUILTIN_COUNT*2)
typedef struct mvm_TsBytecodeHeader {
  uint8_t bytecodeVersion; // MVM_BYTECODE_VERSION
  uint8_t headerSize;
  uint8_t requiredEngineVersion;
  uint8_t reserved; // =0

  uint16_t bytecodeSize; // Including header
  uint16_t crc; // CCITT16 (header and data, of everything after the CRC)

  uint32_t requiredFeatureFlags;

  /*
  Note: the sections are assumed to be in order as per mvm_TeBytecodeSection, so
  that the size of a section can be computed as the difference between the
  adjacent offsets. The last section runs up until the end of the bytecode.
  */
  uint16_t sectionOffsets[BCS_SECTION_COUNT];
} mvm_TsBytecodeHeader;

typedef enum mvm_TeFeatureFlags {
  FF_FLOAT_SUPPORT = 0,
} mvm_TeFeatureFlags;

typedef struct vm_TsExportTableEntry {
  mvm_VMExportID exportID;
  mvm_Value exportValue;
} vm_TsExportTableEntry;

typedef struct vm_TsShortCallTableEntry {
  /* Note: the `function` field has been broken up into separate low and high
   * bytes, `functionL` and `functionH` respectively, for alignment purposes,
   * since this is a 3-byte structure occuring in a packed table.
   *
   * `functionL` and `functionH` together make an `mvm_Value` which should be a
   * callable value (a pointer to a `TsBytecodeFunc`, `TsHostFunc`, or
   * `TsClosure`). TODO: I don't think this currently works, and I'm not even
   * sure how we would test it. */
  uint8_t functionL;
  uint8_t functionH;
  uint8_t argCount;
} vm_TsShortCallTableEntry;
