#include "../native-vm/microvium_port_test.h"

#define MVM_PORT_INT32_OVERFLOW_CHECKS 1

#ifdef __cplusplus
extern "C" {
#endif

void codeCoverage(int id, int mode, int indexInTable, int tableSize, int lineNumber);
void fatalError(void* vm, int error);

#ifdef __cplusplus
} // extern "C"
#endif

#define COVERAGE_MODE_NORMAL 1
#define COVERAGE_MODE_UNTESTED 2
#define COVERAGE_MODE_UNIMPLEMENTED 3
#define COVERAGE_MODE_TABLE 4
#define COVERAGE_MODE_ERROR_PATH 5

// See CODE_COVERAGE in microvium_internals.h for an explanation of these
#define CODE_COVERAGE(id) codeCoverage(id, COVERAGE_MODE_NORMAL, 0, 0, __LINE__)
#define CODE_COVERAGE_UNTESTED(id) codeCoverage(id, COVERAGE_MODE_UNTESTED, 0, 0, __LINE__)
#define CODE_COVERAGE_ERROR_PATH(id) codeCoverage(id, COVERAGE_MODE_ERROR_PATH, 0, 0, __LINE__)
#define CODE_COVERAGE_UNIMPLEMENTED(id) codeCoverage(id, COVERAGE_MODE_UNIMPLEMENTED, 0, 0, __LINE__)
#define TABLE_COVERAGE(indexInTable, tableSize, id) codeCoverage(id, COVERAGE_MODE_TABLE, indexInTable, tableSize, __LINE__)

#undef MVM_FATAL_ERROR
#define MVM_FATAL_ERROR(vm, e) fatalError(vm, e)
