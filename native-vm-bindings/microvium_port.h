
// The example is actually designed for this exact environment
#include "../native-vm/microvium_port_example.h"

#ifdef __cplusplus
extern "C" {
#endif

void codeCoverage(int id, int mode);

#ifdef __cplusplus
} // extern "C"
#endif

#define COVERAGE_MODE_NORMAL 1
#define COVERAGE_MODE_UNTESTED 2
#define COVERAGE_MODE_UNIMPLEMENTED 3

#define CODE_COVERAGE(id) codeCoverage(id, COVERAGE_MODE_NORMAL)
#define CODE_COVERAGE_UNTESTED(id) codeCoverage(id, COVERAGE_MODE_UNTESTED)
#define CODE_COVERAGE_UNIMPLEMENTED(id) codeCoverage(id, COVERAGE_MODE_UNIMPLEMENTED)
