#pragma once

#include "stdint.h"

typedef struct mvm_TsBytecodeHeader {
  /* TODO: I think the performance of accessing this header would improve
  slightly if the offsets were stored as auto-relative-offsets. My reasoning is
  that we don't need to keep the pBytecode pointer for the second lookup. But
  it's maybe worth doing some tests.
  */
  uint8_t bytecodeVersion; // VM_BYTECODE_VERSION
  uint8_t headerSize;
  uint16_t bytecodeSize;
  uint16_t crc; // CCITT16 (header and data, of everything after the CRC)
  uint16_t requiredEngineVersion;
  uint32_t requiredFeatureFlags;
  uint16_t globalVariableCount;
  uint16_t dataMemorySize; // Includes global variables // TODO(low): I don't think this is useful.
  uint16_t initialDataOffset;
  uint16_t initialDataSize; // Data memory that is not covered by the initial data is zero-filled
  uint16_t initialHeapOffset;
  uint16_t initialHeapSize;
  uint16_t gcRootsOffset; // Points to a table of pointers to GC roots in data memory (to use in addition to the global variables as roots)
  uint16_t gcRootsCount;
  uint16_t importTableOffset; // vm_TsImportTableEntry
  uint16_t importTableSize;
  uint16_t exportTableOffset; // vm_TsExportTableEntry
  uint16_t exportTableSize;
  uint16_t shortCallTableOffset; // vm_TsShortCallTableEntry
  uint16_t shortCallTableSize;
  uint16_t stringTableOffset; // Alphabetical index of UNIQUED_STRING values (TODO: Check these are always generated at 2-byte alignment)
  uint16_t stringTableSize;
} mvm_TsBytecodeHeader;
