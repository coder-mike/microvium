#include <iostream>
#include <fstream>
#include <vector>
#include <filesystem>
#include <stdexcept>

#include "colors.h"
#include "../native-vm/microvium_internals.h"
#include "../native-vm/microvium.h"
#include "yaml-cpp/include/yaml-cpp/yaml.h"
#include "../native-vm-bindings/error_descriptions.hh"
#include "utils.h"

using namespace std;
using namespace filesystem;

// Set to the empty string "" if you want to run all tests
const string runOnlyTest = "arrays";
//const string runOnlyTest = "";

// Bytecode addresses to break on. To have no breakpoints, set to single value of { 0 }
uint16_t breakpoints[] = { 
  //0x505,
  //0x6c,
  //0x71,
  //0x0148,
  //0x0176,
  //0x0604,
  //0x1cc, 
  //0x1f3, 
  //0x201, 
  //0x01d9, 
  //0x0216, 
  //0x0206, 
  //0x023a,
  0
};
#define BREAKPOINT_COUNT (sizeof breakpoints / sizeof breakpoints[0])
#define IS_ANY_BREAKPOINTS ((BREAKPOINT_COUNT > 1) || (breakpoints[0] != 0))

string testInputDir = "../test/end-to-end/tests/";
string testArtifactsDir = "../test/end-to-end/artifacts/";

mvm_TsBytecodeHeader dummy; // Prevent debugger discarding this structure

struct HostFunction {
  mvm_HostFunctionID hostFunctionID;
  mvm_TfHostFunction hostFunction;
};

struct Context {
  string printout;
};

static int testFail(string message);
static void testPass(string message);
static mvm_TeError print(mvm_VM* vm, mvm_HostFunctionID hostFunctionID, mvm_Value* result, mvm_Value* args, uint8_t argCount);
static mvm_TeError vmAssert(mvm_VM* vm, mvm_HostFunctionID hostFunctionID, mvm_Value* result, mvm_Value* args, uint8_t argCount);
static mvm_TeError vmAssertEqual(mvm_VM* vm, mvm_HostFunctionID hostFunctionID, mvm_Value* result, mvm_Value* args, uint8_t argCount);
static mvm_TeError vmIsNaN(mvm_VM* vm, mvm_HostFunctionID hostFunctionID, mvm_Value* result, mvm_Value* args, uint8_t argCount);
static mvm_TeError vmGetHeapUsed(mvm_VM* vm, mvm_HostFunctionID hostFunctionID, mvm_Value* result, mvm_Value* args, uint8_t argCount);
static mvm_TeError vmRunGC(mvm_VM* vm, mvm_HostFunctionID hostFunctionID, mvm_Value* result, mvm_Value* args, uint8_t argCount);
static mvm_TeError resolveImport(mvm_HostFunctionID hostFunctionID, void* context, mvm_TfHostFunction* out_hostFunction);
static void breakpointCallback(mvm_VM* vm, uint16_t bytecodeAddress);
static void check(mvm_TeError err);

const HostFunction hostFunctions[] = {
  { 1, print },
  { 2, vmAssert },
  { 3, vmAssertEqual },
  { 4, vmGetHeapUsed },
  { 5, vmRunGC },
  { 0xFFFD, vmIsNaN },
};

constexpr size_t hostFunctionCount = sizeof hostFunctions / sizeof hostFunctions[0];

int main()
{
  for (const auto entry : directory_iterator(testInputDir)) {
    string pathString = entry.path().string();

    string ext = ".test.mvm.js";
    size_t indexOfExtension = pathString.rfind(ext);
    size_t indexOfDir = pathString.rfind(testInputDir);
    if (indexOfExtension == string::npos)
      continue; // Not a test case
    size_t truncateFrom = indexOfDir + testInputDir.length();
    string testName = pathString.substr(truncateFrom, indexOfExtension - truncateFrom);

    cout << testName << "... ";

    if (runOnlyTest != "") {
      if (testName != runOnlyTest) {
        cout << "skipping" << endl;
        continue;
      }
    }

    cout << "running" << endl;

    string artifactsDir = testArtifactsDir + testName + "/";

    string yamlFilename = artifactsDir + "0.meta.yaml";
    string bytecodeFilename = artifactsDir + "1.post-load.mvm-bc";

    YAML::Node meta = YAML::LoadFile(yamlFilename);

    if (meta["skip"] && meta["skip"].as<string>() == "true") {
      cout << "skipping " << testName << endl;
      continue;
    }

    // Read bytecode file
    ifstream bytecodeFile(bytecodeFilename, ios::binary | ios::ate);
    if (!bytecodeFile.is_open()) {
      std::cerr << "Problem opening file \"" << bytecodeFilename << "\"" << std::endl;
      return 1;
    }
    streamsize bytecodeSize = bytecodeFile.tellg();
    uint8_t* bytecode = new uint8_t[(size_t)bytecodeSize];
    bytecodeFile.seekg(0, ios::beg);
    if (!bytecodeFile.read((char*)bytecode, bytecodeSize)) return 1;

    // Create VM
    Context* context = new Context;
    mvm_VM* vm;
    check(mvm_restore(&vm, bytecode, (uint16_t)bytecodeSize, context, resolveImport));
    mvm_createSnapshot(vm, NULL);

    // Set breakpoints
    if (IS_ANY_BREAKPOINTS) {
      mvm_dbg_setBreakpointCallback(vm, breakpointCallback);
      for (int i = 0; i < BREAKPOINT_COUNT; i++)
        if (breakpoints[i])
          mvm_dbg_setBreakpoint(vm, breakpoints[i]);
    }

    // Run the garbage collector (shouldn't really change anything, since a collection was probably done before the snapshot was taken)
    // mvm_runGC(vm);

    if (meta["runExportedFunction"]) {
      uint16_t runExportedFunctionID = meta["runExportedFunction"].as<uint16_t>();
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

      if (meta["expectedPrintout"]) {
        auto expectedPrintout = meta["expectedPrintout"].as<string>();
        if (trim_copy(context->printout) == trim_copy(expectedPrintout)) {
          testPass("Expected printout matches");
        } else {
          return testFail("Expected printout does not match");
        }
      }
    }

    // vm_runGC(vm);
    mvm_free(vm);
    vm = nullptr;
    delete context;
    context = 0;
  }

  return 0;
}

void error(mvm_TeError err) {
  auto errorDescription = errorDescriptions.find(err);
  if (errorDescription != errorDescriptions.end()) {
    throw std::runtime_error(errorDescription->second);
  }
  else {
    throw std::runtime_error(std::string("VM error code: ") + std::to_string(err));
  }
}

extern "C" void fatalError(void* vm, int e) {
  error((mvm_TeError)e);
}

void check(mvm_TeError err) {
  if (err != MVM_E_SUCCESS) {
    error(err);
  }
}

int testFail(string message) {
  cout << RED << "    Fail: " << message << RESET << endl;
  return -1;
}

void testPass(string message) {
  cout << GREEN << "    Pass: " << message << RESET << endl;
}

mvm_TeError print(mvm_VM* vm, mvm_HostFunctionID hostFunctionID, mvm_Value* result, mvm_Value* args, uint8_t argCount) {
  Context* context = (Context*)mvm_getContext(vm);
  if (argCount != 1)
    return MVM_E_INVALID_ARGUMENTS;
  string message = (char*)mvm_toStringUtf8(vm, args[0], NULL);
  cout << "    Prints: " << message << endl;
  if (context->printout != "") context->printout += "\n";
  context->printout += message;

  return MVM_E_SUCCESS;
}

mvm_TeError vmAssert(mvm_VM* vm, mvm_HostFunctionID hostFunctionID, mvm_Value* result, mvm_Value* args, uint8_t argCount) {
  Context* context = (Context*)mvm_getContext(vm);
  if (argCount < 1)
    return MVM_E_INVALID_ARGUMENTS;
  bool assertion = mvm_toBool(vm, args[0]);
  string message = argCount >= 2 ? (char*)mvm_toStringUtf8(vm, args[1], NULL) : "Assertion";
  if (assertion) {
    testPass(message);
  }
  else {
    testFail(message);
  }

  return MVM_E_SUCCESS;
}

mvm_TeError vmAssertEqual(mvm_VM* vm, mvm_HostFunctionID hostFunctionID, mvm_Value* result, mvm_Value* args, uint8_t argCount) {
  Context* context = (Context*)mvm_getContext(vm);
  if (argCount < 2)
    return MVM_E_INVALID_ARGUMENTS;

  if (mvm_equal(vm, args[0], args[1]))
    testPass("Expected equal");
  else
    testFail("Expected equal");

  return MVM_E_SUCCESS;
}

mvm_TeError vmIsNaN(mvm_VM* vm, mvm_HostFunctionID hostFunctionID, mvm_Value* result, mvm_Value* args, uint8_t argCount) {
  if (argCount < 1) {
    *result = mvm_newBoolean(true);
    return MVM_E_SUCCESS;
  }
  *result = mvm_newBoolean(mvm_isNaN(args[0]));
  return MVM_E_SUCCESS;
}

mvm_TeError resolveImport(mvm_HostFunctionID hostFunctionID, void* context, mvm_TfHostFunction* out_hostFunction) {
  for (uint16_t i2 = 0; i2 < hostFunctionCount; i2++) {
    if (hostFunctions[i2].hostFunctionID == hostFunctionID) {
      *out_hostFunction = hostFunctions[i2].hostFunction;
      return MVM_E_SUCCESS;
    }
  }
  return MVM_E_UNRESOLVED_IMPORT;
}

static mvm_TeError vmGetHeapUsed(mvm_VM* vm, mvm_HostFunctionID hostFunctionID, mvm_Value* result, mvm_Value* args, uint8_t argCount) {
  mvm_TsMemoryStats stats;
  mvm_getMemoryStats(vm, &stats);
  *result = mvm_newInt32(vm, stats.virtualHeapUsed);
  return MVM_E_SUCCESS;
}

static mvm_TeError vmRunGC(mvm_VM* vm, mvm_HostFunctionID hostFunctionID, mvm_Value* result, mvm_Value* args, uint8_t argCount) {
  bool strict = (argCount >= 1) && mvm_toBool(vm, args[0]);
  mvm_runGC(vm, strict);
  return MVM_E_SUCCESS;
}

static void breakpointCallback(mvm_VM* vm, uint16_t bytecodeAddress) {
  __debugbreak();
}