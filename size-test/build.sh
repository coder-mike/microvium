
arm-none-eabi-gcc \
  ../native-vm/microvium.c \
  -c \
  -o output/microvium.o \
  -I. \
  -mcpu=cortex-m0 \
  -Os \
  -mthumb \
  -nostdlib

arm-none-eabi-objdump output/microvium.o --disassemble-all > output/disassembly.txt
arm-none-eabi-objdump output/microvium.o --syms > output/symbols.txt
arm-none-eabi-size output/microvium.o > output/size.txt