/**
 * @file microvium_port_test.h
 *
 * This file is used for running the tests, except the getting-started tests
 * which use the example port file like the getting-started guide does.
 *
 * This test port file should be the same as the example port file for the most
 * part, but just with some extra tests enabled.
 */

#include "microvium_port_example.h"

// WIP run tests with this enabled.
#undef MVM_VERY_EXPENSIVE_MEMORY_CHECKS
#define MVM_VERY_EXPENSIVE_MEMORY_CHECKS 1

#undef MVM_DEBUG_CONTIGUOUS_ALIGNED_MEMORY
#define MVM_DEBUG_CONTIGUOUS_ALIGNED_MEMORY 1

#undef MVM_ALL_ERRORS_FATAL
#define MVM_ALL_ERRORS_FATAL 1