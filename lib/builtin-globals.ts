import { VirtualMachineFriendly } from "./virtual-machine-friendly";
import fs from 'fs';
import path from 'path';

export function addBuiltinGlobals(vm: VirtualMachineFriendly) {

  const runtimeLibText = fs.readFileSync(path.join(__dirname, './runtime-library.mvms'), 'utf8');
  const runtimeLib = vm.evaluateModule({ sourceText: runtimeLibText, debugFilename: '<builtin>' });

  const global = vm.globalThis;
  global.Infinity = Infinity;
  global.NaN = NaN;
  global.undefined = undefined;
  const Number = global.Number = vm.newObject();
  Number.isNaN = runtimeLib.Number_isNaN;
}
