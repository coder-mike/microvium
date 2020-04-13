#include <iostream>
#include <fstream>
#include <vector>

#include "../vm.h"

extern "C" void vm_error(vm_VM * vm, vm_TeError e) {
  printf("VM ERROR %i\n", e);
}

int main()
{
  std::ifstream bytecodeFile("../../test/virtual-machine/output/hello-world.bin", std::ios::binary | std::ios::ate);
  if (!bytecodeFile.is_open()) return 1;
  std::streamsize bytecodeSize = bytecodeFile.tellg();
  uint8_t* bytecode = new uint8_t[(size_t)bytecodeSize];
  bytecodeFile.seekg(0, std::ios::beg);
  if (!bytecodeFile.read((char*)bytecode, bytecodeSize)) return 1;

  vm_VM* vm;
  vm_create(&vm, bytecode, NULL, NULL, 0);
  vm_runGC(vm);
  vm_free(vm);
  return 0;
}
