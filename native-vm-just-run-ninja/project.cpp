#include <iostream>
#include <fstream>
#include <vector>
#include <filesystem>
#include <stdexcept>

#include "colors.h"
#include "../native-vm/microvium_internals.h"
#include "../native-vm/microvium.h"
#include "../native-vm-bindings/error_descriptions.hh"

using namespace std;

// Set to the empty string "" if you want to run all tests
const string runOnlyTest = "";
// const string runOnlyTest = "";

// Bytecode addresses to break on. To clear all breakpoints, set to single value of { 0 }
uint16_t breakpoints[] = {0};
#define BREAKPOINT_COUNT (sizeof breakpoints / sizeof breakpoints[0])
#define IS_ANY_BREAKPOINTS ((BREAKPOINT_COUNT > 1) || (breakpoints[0] != 0))

string testInputDir = "../test/end-to-end/tests/";
string testArtifactsDir = "../test/end-to-end/artifacts/";

mvm_TsBytecodeHeader dummy; // Prevent debugger discarding this structure

struct HostFunction
{
  mvm_HostFunctionID hostFunctionID;
  mvm_TfHostFunction hostFunction;
};

struct Context
{
  string printout;
};

static int testFail(string message);
static void testPass(string message);
static mvm_TeError print(mvm_VM *vm, mvm_HostFunctionID hostFunctionID, mvm_Value *result, mvm_Value *args, uint8_t argCount);
static mvm_TeError vmAssert(mvm_VM *vm, mvm_HostFunctionID hostFunctionID, mvm_Value *result, mvm_Value *args, uint8_t argCount);
static mvm_TeError vmAssertEqual(mvm_VM *vm, mvm_HostFunctionID hostFunctionID, mvm_Value *result, mvm_Value *args, uint8_t argCount);
static mvm_TeError vmIsNaN(mvm_VM *vm, mvm_HostFunctionID hostFunctionID, mvm_Value *result, mvm_Value *args, uint8_t argCount);
static mvm_TeError resolveImport(mvm_HostFunctionID hostFunctionID, void *context, mvm_TfHostFunction *out_hostFunction);
static void breakpointCallback(mvm_VM *vm, uint16_t bytecodeAddress);
static void check(mvm_TeError err);

const HostFunction hostFunctions[] = {
    {1, print},
    {2, vmAssert},
    {3, vmAssertEqual},
    {0xFFFD, vmIsNaN},
};

constexpr size_t hostFunctionCount = sizeof hostFunctions / sizeof hostFunctions[0];

int main(int argc, char **argv)
{
  const auto pathString = string(argv[1]);

  string ext = ".test.mvms";
  size_t indexOfExtension = pathString.rfind(ext);
  size_t indexOfDir = pathString.rfind(testInputDir);
  if (indexOfExtension == string::npos)
    return 1; // Not a test case
  size_t truncateFrom = indexOfDir + testInputDir.length();
  string testName = pathString.substr(truncateFrom, indexOfExtension - truncateFrom);

  cout << testName << "... ";

  if (runOnlyTest != "")
  {
    if (testName != runOnlyTest)
    {
      cout << "skipping" << endl;
      return 0;
    }
  }

  cout << "running" << endl;

  string artifactsDir = testArtifactsDir + testName + "/";

  string yamlFilename = artifactsDir + "0.meta.yaml";
  string bytecodeFilename = artifactsDir + "1.post-load.mvm-bc";

  // Read bytecode file
  ifstream bytecodeFile(bytecodeFilename, ios::binary | ios::ate);
  if (!bytecodeFile.is_open())
  {
    std::cerr << "Problem opening file \"" << bytecodeFilename << "\"" << std::endl;
    return 1;
  }
  streamsize bytecodeSize = bytecodeFile.tellg();
  uint8_t *bytecode = new uint8_t[(size_t)bytecodeSize];
  bytecodeFile.seekg(0, ios::beg);
  if (!bytecodeFile.read((char *)bytecode, bytecodeSize))
    return 1;

  // Create VM
  Context *context = new Context;
  mvm_VM *vm;
  check(mvm_restore(&vm, bytecode, (uint16_t)bytecodeSize, context, resolveImport));
  mvm_createSnapshot(vm, NULL);

  // Set breakpoints
  if (IS_ANY_BREAKPOINTS)
  {
    mvm_dbg_setBreakpointCallback(vm, breakpointCallback);
    for (int i = 0; i < BREAKPOINT_COUNT; i++)
      mvm_dbg_setBreakpoint(vm, breakpoints[i]);
  }

  // Run the garbage collector (shouldn't really change anything, since a collection was probably done before the snapshot was taken)
  // mvm_runGC(vm);

  uint16_t runExportedFunctionID = 0;
  cout << "    runExportedFunction: " << runExportedFunctionID << "\n";

  // Resolve exports from VM
  mvm_Value exportedFunction;
  check(mvm_resolveExports(vm, &runExportedFunctionID, &exportedFunction, 1));

  // Invoke exported function
  mvm_Value result;
  check(mvm_call(vm, exportedFunction, &result, nullptr, 0));

  // Just checking that the end state is still serializable
  mvm_createSnapshot(vm, NULL);

  // Run the garbage collector
  mvm_runGC(vm, true);
  mvm_createSnapshot(vm, NULL);

  // vm_runGC(vm);
  mvm_free(vm);
  vm = nullptr;
  delete context;
  context = 0;

  return 0;
}

void check(mvm_TeError err)
{
  if (err != MVM_E_SUCCESS)
  {
    auto errorDescription = errorDescriptions.find(err);
    if (errorDescription != errorDescriptions.end())
    {
      throw std::runtime_error(errorDescription->second);
    }
    else
    {
      throw std::runtime_error(std::string("VM error code: ") + std::to_string(err));
    }
  }
}

int testFail(string message)
{
  cout << RED << "    Fail: " << message << RESET << endl;
  return -1;
}

void testPass(string message)
{
  cout << GREEN << "    Pass: " << message << RESET << endl;
}

mvm_TeError print(mvm_VM *vm, mvm_HostFunctionID hostFunctionID, mvm_Value *result, mvm_Value *args, uint8_t argCount)
{
  Context *context = (Context *)mvm_getContext(vm);
  if (argCount != 1)
    return MVM_E_INVALID_ARGUMENTS;
  string message = (char *)mvm_toStringUtf8(vm, args[0], NULL);
  cout << "    Prints: " << message << endl;
  if (context->printout != "")
    context->printout += "\n";
  context->printout += message;

  return MVM_E_SUCCESS;
}

mvm_TeError vmAssert(mvm_VM *vm, mvm_HostFunctionID hostFunctionID, mvm_Value *result, mvm_Value *args, uint8_t argCount)
{
  Context *context = (Context *)mvm_getContext(vm);
  if (argCount < 1)
    return MVM_E_INVALID_ARGUMENTS;
  bool assertion = mvm_toBool(vm, args[0]);
  string message = argCount >= 2 ? (char *)mvm_toStringUtf8(vm, args[1], NULL) : "Assertion";
  if (assertion)
  {
    testPass(message);
  }
  else
  {
    testFail(message);
  }

  return MVM_E_SUCCESS;
}

mvm_TeError vmAssertEqual(mvm_VM *vm, mvm_HostFunctionID hostFunctionID, mvm_Value *result, mvm_Value *args, uint8_t argCount)
{
  Context *context = (Context *)mvm_getContext(vm);
  if (argCount < 2)
    return MVM_E_INVALID_ARGUMENTS;

  if (mvm_equal(vm, args[0], args[1]))
  {
    testPass("Expected equal");
  }
  else
  {
    testFail("Expected equal");
  }

  return MVM_E_SUCCESS;
}

mvm_TeError vmIsNaN(mvm_VM *vm, mvm_HostFunctionID hostFunctionID, mvm_Value *result, mvm_Value *args, uint8_t argCount)
{
  if (argCount < 1)
  {
    *result = mvm_newBoolean(true);
    return MVM_E_SUCCESS;
  }
  *result = mvm_newBoolean(mvm_isNaN(args[0]));
  return MVM_E_SUCCESS;
}

mvm_TeError resolveImport(mvm_HostFunctionID hostFunctionID, void *context, mvm_TfHostFunction *out_hostFunction)
{
  for (uint16_t i2 = 0; i2 < hostFunctionCount; i2++)
  {
    if (hostFunctions[i2].hostFunctionID == hostFunctionID)
    {
      *out_hostFunction = hostFunctions[i2].hostFunction;
      return MVM_E_SUCCESS;
    }
  }
  return MVM_E_UNRESOLVED_IMPORT;
}

static void breakpointCallback(mvm_VM *vm, uint16_t bytecodeAddress)
{
  asm volatile("int3");
}