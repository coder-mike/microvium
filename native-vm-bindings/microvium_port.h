
// The example is actually designed for this exact environment
#include "../native-vm/microvium_port_example.h"

#ifdef __cplusplus
extern "C" {
#endif

void codeCoverage(int id, int mode, int indexInTable, int tableSize, int lineNumber);

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

