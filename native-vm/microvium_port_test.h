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

// TODO: Occassionally run the tests with this enabled to see we haven't
// introduced any dangling pointer issues
#undef MVM_VERY_EXPENSIVE_MEMORY_CHECKS
#define MVM_VERY_EXPENSIVE_MEMORY_CHECKS 0

#undef MVM_ALL_ERRORS_FATAL
#define MVM_ALL_ERRORS_FATAL 1
