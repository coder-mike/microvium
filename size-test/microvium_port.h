#include "../native-vm/microvium_port_example.h"

#undef MVM_NATIVE_POINTER_IS_16_BIT
#define MVM_NATIVE_POINTER_IS_16_BIT 0

#undef MVM_SUPPORT_FLOAT
#define MVM_SUPPORT_FLOAT 1

#undef MVM_PORT_INT32_OVERFLOW_CHECKS
#define MVM_PORT_INT32_OVERFLOW_CHECKS 1

#undef MVM_SAFE_MODE
#define MVM_SAFE_MODE 0

#undef MVM_DONT_TRUST_BYTECODE
#define MVM_DONT_TRUST_BYTECODE 0

#undef MVM_VERY_EXPENSIVE_MEMORY_CHECKS
#define MVM_VERY_EXPENSIVE_MEMORY_CHECKS 0

#undef MVM_INCLUDE_SNAPSHOT_CAPABILITY
#define MVM_INCLUDE_SNAPSHOT_CAPABILITY 0

#undef MVM_INCLUDE_DEBUG_CAPABILITY
#define MVM_INCLUDE_DEBUG_CAPABILITY 0

extern void fatalError(void* vm, int e);
#undef MVM_FATAL_ERROR
#define MVM_FATAL_ERROR(vm, e) fatalError(vm, e)

#undef MVM_USE_SINGLE_RAM_PAGE
#define MVM_USE_SINGLE_RAM_PAGE 1

#undef MVM_RAM_PAGE_ADDR
#define MVM_RAM_PAGE_ADDR 0x20000000

