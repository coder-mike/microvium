#include <string.h>

int memcmp(const void *vl, const void *vr, size_t n) {
	const unsigned char *l = (const unsigned char*)vl;
  const unsigned char *r = (const unsigned char*)vr;
	for (; n && *l == *r; n--, l++, r++);
	return n ? *l-*r : 0;
}

size_t strlen(const char *s) {
	const char *a = s;
	for (; *s; s++);
	return s-a;
}
