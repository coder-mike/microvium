#pragma once

typedef unsigned long size_t;

int memcmp(const void *vl, const void *vr, size_t n);
size_t strlen(const char *s);

static inline void *memcpy(void * dest, const void * src, size_t n) {
  return __builtin_memcpy(dest, src, n);
}

static inline void *memset(void *dest, int c, size_t n) {
  return __builtin_memset(dest, c, n);
}

