arm-none-eabi-gcc \
  C:/Projects/third-party/elk/elk.c \
  -c \
  -o output/elk.o \
  -I. \
  -mcpu=cortex-m0 \
  -Os \
  -mthumb \
  -DCS_PLATFORM=10 \
  -nostdlib


arm-none-eabi-objdump output/elk.o --disassemble-all > output/disassembly.txt
arm-none-eabi-objdump output/elk.o --syms > output/symbols.txt
arm-none-eabi-size output/elk.o > output/size.txt