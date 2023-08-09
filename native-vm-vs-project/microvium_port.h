
#include "microvium_port_test.h"
#include "allocator.h"

#ifdef __cplusplus
extern "C" {
#endif

void fatalError(void* vm, int e);

#ifdef __cplusplus
}
#endif

#define MVM_DEBUG 1

#undef MVM_INCLUDE_DEBUG_CAPABILITY
#define MVM_INCLUDE_DEBUG_CAPABILITY 1

// Note: don't use MVM_VERY_EXPENSIVE_MEMORY_CHECKS on the "gc" test case.
#undef MVM_VERY_EXPENSIVE_MEMORY_CHECKS
#define MVM_VERY_EXPENSIVE_MEMORY_CHECKS 1

#undef MVM_FATAL_ERROR
#define MVM_FATAL_ERROR(vm, e) fatalError(vm, (int)e)

#undef MVM_USE_SINGLE_RAM_PAGE
#define MVM_USE_SINGLE_RAM_PAGE 1

#undef MVM_RAM_PAGE_ADDR
#define MVM_RAM_PAGE_ADDR ALLOCATOR_PAGE

#undef MVM_MALLOC
#define MVM_MALLOC allocator_malloc

#undef MVM_FREE
#define MVM_FREE allocator_free

#define MVM_DEBUG_UTILS 1