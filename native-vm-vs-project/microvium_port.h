
// The example is actually designed for this exact environment
#include "../native-vm/microvium_port_example.h"

#ifdef __cplusplus
extern "C" {
#endif

  void fatalError(void* vm, int e);

#ifdef __cplusplus
}
#endif

#define MVM_DEBUG 1
#undef MVM_FATAL_ERROR
#define MVM_FATAL_ERROR(vm, e) fatalError(vm, (int)e)