arm-none-eabi-gcc \
  C:/Projects/third-party/mjs/mjs.c \
  -c \
  -o output/mjs.o \
  -I. \
  -mcpu=cortex-m0 \
  -Os \
  -mthumb \
  -DCS_PLATFORM=10 \
  -nostdlib


arm-none-eabi-objdump output/mjs.o --disassemble-all > output/disassembly.txt
arm-none-eabi-objdump output/mjs.o --syms > output/symbols.txt
arm-none-eabi-size output/mjs.o > output/size.txt