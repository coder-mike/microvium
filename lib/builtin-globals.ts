import { VirtualMachineFriendly } from "./virtual-machine-friendly";
import fs from 'fs';
import path from 'path';
import { mvm_TeType } from "./runtime-types";

export function addBuiltinGlobals(vm: VirtualMachineFriendly) {
  // Note: There is also a VirtualMachine.addBuiltinGlobals which can be used
  // when a global requires custom IL.

  const runtimeLibText = fs.readFileSync(path.join(__dirname, './runtime-library.mvm.js'), 'utf8');
  const runtimeLib = vm.evaluateModule({ sourceText: runtimeLibText, debugFilename: '<builtin>' });

  const global = vm.globalThis;
  global.Infinity = Infinity;
  global.NaN = NaN;
  global.undefined = undefined;
  const Number = global.Number = vm.newObject();
  Number.isNaN = runtimeLib.Number_isNaN;

  const arrayPrototype = vm.newObject();
  arrayPrototype.push = runtimeLib.Array_push;
  vm.setArrayPrototype(arrayPrototype);
}
