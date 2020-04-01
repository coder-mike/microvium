#include <iostream>

#include "../vm.h"

uint8_t bytecode[] = {
  18, 0, // headerSize
  1, 0,  // bytecodeVersion
  10, 0, // dataSize
  18, 0, // initialDataOffset
  8, 0,  // initialDataSize
  26, 0, // initialHeapOffset
  16, 0, // initialHeapSize
  42, 0, // layoutTableOffset
  3, 0, // layoutTableSize

  // Initial data
  1, 0,
  0x12, 0x40, // Points to 2nd word
  3, 0,
  0x18, 0x40, // Points to 6th word

  // Initial heap
  1, 0,

  2, 0, // Int32
  3, 0,

  4, 0,
  
  4, 'H', // alloc size length
  'E', 0,

  7, 0,
  8, 0,

  // Layout table
  0x11, // VM_PTC_INT32, VM_PTC_INT32
  0x12, // VM_PTC_INT32, VM_PTC_STRING
  0x0F, // VM_PTC_NONE, VM_PTC_END
};

extern "C" void vm_error(vm_VM * vm, vm_TeError e) {
  printf("VM ERROR %i\n", e);
}


int main()
{
  vm_VM* vm;
  vm_create(&vm, &bytecode, NULL, NULL, 0);
  vm_runGC(vm);
  vm_free(vm);
}
