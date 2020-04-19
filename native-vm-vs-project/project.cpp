#include <iostream>
#include <fstream>
#include <vector>
#include <filesystem>

#include "../native-vm/vm_internals.h"
#include "../native-vm/vm.h"
#include "yaml-cpp/include/yaml-cpp/yaml.h"

using namespace std;
using namespace filesystem;

// https://stackoverflow.com/a/9158263/890587
#define RESET   "\033[0m"
#define BLACK   "\033[30m"      /* Black */
#define RED     "\033[31m"      /* Red */
#define GREEN   "\033[32m"      /* Green */
#define YELLOW  "\033[33m"      /* Yellow */
#define BLUE    "\033[34m"      /* Blue */
#define MAGENTA "\033[35m"      /* Magenta */
#define CYAN    "\033[36m"      /* Cyan */
#define WHITE   "\033[37m"      /* White */
#define BOLDBLACK   "\033[1m\033[30m"      /* Bold Black */
#define BOLDRED     "\033[1m\033[31m"      /* Bold Red */
#define BOLDGREEN   "\033[1m\033[32m"      /* Bold Green */
#define BOLDYELLOW  "\033[1m\033[33m"      /* Bold Yellow */
#define BOLDBLUE    "\033[1m\033[34m"      /* Bold Blue */
#define BOLDMAGENTA "\033[1m\033[35m"      /* Bold Magenta */
#define BOLDCYAN    "\033[1m\033[36m"      /* Bold Cyan */
#define BOLDWHITE   "\033[1m\033[37m"      /* Bold White */

// Comment this out to run all tests
const auto runOnlyTest = "if-else-statement";
#ifndef runOnlyTest
#define runOnlyTest false
#endif

string testInputDir = "../test/end-to-end/tests/";
string testArtifactsDir = "../test/end-to-end/artifacts/";

vm_TsBytecodeHeader dummy; // Prevent debugger discarding this structure

struct HostFunction {
  vm_HostFunctionID hostFunctionID;
  vm_TfHostFunction hostFunction;
};

struct Context {
  string printout;
};

int testFail(wstring message);
void testPass(wstring message);

static vm_TeError print(vm_VM* vm, vm_HostFunctionID hostFunctionID, vm_Value* result, vm_Value* args, uint8_t argCount) {
  // TODO(high): I need to give some thought to the semantics of imports in terms of signatures for the SI. The export signatures probably need to be in the bytecode
  vm_TeError err;
  Context* context = (Context*)vm_getContext(vm);
  if (argCount != 1) return VM_E_INVALID_ARGUMENTS;
  vm_Value messageArg = args[0];
  if (vm_typeOf(vm, messageArg) != VM_T_STRING) return VM_E_INVALID_ARGUMENTS;
  size_t messageSize;
  err = vm_stringSizeUtf8(vm, messageArg, &messageSize);
  if (err != VM_E_SUCCESS) return err;
  string message(messageSize, '\0');
  err = vm_stringReadUtf8(vm, &message[0], messageArg, messageSize);
  if (err != VM_E_SUCCESS) return err;

  cout << "    Prints: " << message << endl;
  if (context->printout != "") context->printout += "\n";
  context->printout += message;

  return VM_E_SUCCESS;
}

const HostFunction hostFunctions[] = {
  { 1, print }
};

constexpr size_t hostFunctionCount = sizeof hostFunctions / sizeof hostFunctions[0];

extern "C" void vm_error(vm_VM * vm, vm_TeError e) {
  printf("VM ERROR %i\n", e);
}

vm_TeError resolveImport(vm_HostFunctionID hostFunctionID, void* context, vm_TfHostFunction* out_hostFunction) {
  for (uint16_t i2 = 0; i2 < hostFunctionCount; i2++) {
    if (hostFunctions[i2].hostFunctionID == hostFunctionID) {
      *out_hostFunction = hostFunctions[i2].hostFunction;
      return VM_E_SUCCESS;
    }
  }
  return VM_E_UNRESOLVED_IMPORT;
}

int main()
{
  for (const auto entry : directory_iterator(testInputDir)) {
    string pathString = entry.path().string();

    string ext = ".test.mvms";
    size_t indexOfExtension = pathString.rfind(ext);
    size_t indexOfDir = pathString.rfind(testInputDir);
    if (indexOfExtension == string::npos)
      continue; // Not a test case
    size_t truncateFrom = indexOfDir + testInputDir.length();
    string testName = pathString.substr(truncateFrom, indexOfExtension - truncateFrom);

    cout << testName << "... ";

    if (runOnlyTest && (testName != string(runOnlyTest))) {
      cout << "skipping" << endl;
      continue;
    }

    cout << "running" << endl;

    string artifactsDir = testArtifactsDir + testName + "/";

    string yamlFilename = artifactsDir + "0.meta.yaml";
    string bytecodeFilename = artifactsDir + "2.post-gc.mvm-bc";

    // Read bytecode file
    ifstream bytecodeFile(bytecodeFilename, ios::binary | ios::ate);
    if (!bytecodeFile.is_open()) return 1;
    streamsize bytecodeSize = bytecodeFile.tellg();
    uint8_t* bytecode = new uint8_t[(size_t)bytecodeSize];
    bytecodeFile.seekg(0, ios::beg);
    if (!bytecodeFile.read((char*)bytecode, bytecodeSize)) return 1;

    // Create VM
    Context* context = new Context;
    vm_VM* vm;
    vm_TeError err = vm_restore(&vm, bytecode, (uint16_t)bytecodeSize, context, resolveImport);
    if (err != VM_E_SUCCESS) return err;

    YAML::Node meta = YAML::LoadFile(yamlFilename);
    if (meta["runExportedFunction"]) {
      uint16_t runExportedFunctionID = meta["runExportedFunction"].as<uint16_t>();
      cout << "    runExportedFunction: " << runExportedFunctionID << "\n";
      
      // Resolve exports from VM
      vm_Value exportedFunction;
      err = vm_resolveExports(vm, &runExportedFunctionID, &exportedFunction, 1);
      if (err != VM_E_SUCCESS) return err;

      // Invoke exported function
      vm_Value result;
      err = vm_call(vm, exportedFunction, &result, nullptr, 0);
      if (err != VM_E_SUCCESS) return err;

      if (meta["expectedPrintout"]) {
        auto expectedPrintout = meta["expectedPrintout"].as<string>();
        if (context->printout == expectedPrintout) {
          testPass(L"Expected printout matches");
        } else {
          return testFail(L"Expected printout does not match");
        }
      }
    }

    // vm_runGC(vm);
    vm_free(vm);
    vm = nullptr;
    delete context;
    context = 0;
  }

  return 0;
}

int testFail(wstring message) {
  wcout << RED << L"    Fail: " << message << RESET << endl;
  return -1;
}

void testPass(wstring message) {
  wcout << GREEN << L"    Pass: " << message << RESET << endl;
}