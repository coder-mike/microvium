import { VirtualMachineFriendly } from "./virtual-machine-friendly";
import fs from 'fs';
import path from 'path';

export function addBuiltinGlobals(vm: VirtualMachineFriendly, noLib: boolean = false) {
  // Note: There is also a VirtualMachine.addBuiltinGlobals which can be used
  // when a global requires custom IL.

  // Note: even with noLib, we can add these globals because they're pretty
  // important but also the garbage collector will remove these if they aren't
  // used (which not true of Array.prototype since it's dynamically accessible)

  const runtimeLibText = fs.readFileSync(path.join(__dirname, './runtime-library.mvm.js'), 'utf8');
  const runtimeLib = vm.evaluateModule({ sourceText: runtimeLibText, debugFilename: '<builtin>' });

  const global = vm.globalThis;
  global.Infinity = Infinity;
  global.NaN = NaN;
  global.undefined = undefined;
  const Number = global.Number = vm.newObject();
  Number.isNaN = runtimeLib.Number_isNaN;

  if (!noLib) {
    const arrayPrototype = vm.newObject();
    arrayPrototype.push = runtimeLib.Array_push;
    vm.setArrayPrototype(arrayPrototype);
  }

}
