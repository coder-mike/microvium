/*

arm-none-eabi-gcc -O3 -c test.c -o test.o && arm-none-eabi-objdump -D test.o
arm-none-eabi-gcc -mcpu=cortex-m4 -O3 -c test.c -o test.o && arm-none-eabi-objdump -D test.o
arm-none-eabi-gcc -mcpu=cortex-m0 -O3 -mthumb -o test.o test.c -nostdlib && arm-none-eabi-objdump -D test.o
*/

int foo1(short x) {
  int* p = (int*)((int)x | ((int)0x2000 << 16));
  return *p;
}

int foo2(short x) {
  int* p = (int*)((int)x | 0x20000000);
  return *p;
}

int foo3(short x) {
  int* p = (int*)((int)x + 0x20000000);
  return *p;
}

int bar(short x) {
  int* p = (int*)((int)x + ((int)0x12345678));
  return *p;
}

int baz(int* p) {
  return *p;
}

int qux(short x) {
  int* p = (int*)((int)x | ((int)0x8765 << 16));
  return *p;
}