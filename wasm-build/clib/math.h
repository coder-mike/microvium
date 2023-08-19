#pragma once

// Implement in JS
extern double fmod(double x, double y);
extern double pow(double x, double y);


#define INFINITY  __builtin_inff()

#define isfinite(x) (__builtin_isfinite(x))
#define isnan(x) (__builtin_isnan(x))
#define signbit(x) (__builtin_signbit(x))

