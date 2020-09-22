import { VirtualMachineFriendly } from "./virtual-machine-friendly";
import fs from 'fs';
import path from 'path';

export function addBuiltinGlobals(vm: VirtualMachineFriendly) {

  const runtimeLibText = fs.readFileSync(path.join(__dirname, './runtime-library.mvms'), 'utf8');
  const runtimeLib = vm.evaluateModule({ sourceText: runtimeLibText, debugFilename: path.join(__dirname, './runtime-library.mvms') });

  const global = vm.globalThis;
  global.Infinity = Infinity;
  global.NaN = NaN;
  global.undefined = undefined;
  const Number = global.Number = vm.newObject();
  Number.isNaN = runtimeLib.Number_isNaN;
  const objectConstructor = global.Object = vm.newObject();
  objectConstructor.prototype = vm.newObject();
  objectConstructor.prototype.toString = runtimeLib.defaultObjectStringify;
  objectConstructor.prototype.constructor = objectConstructor;
  const arrayPrototype = vm.newObject();
  arrayPrototype.push = runtimeLib.Array_push;
  vm.setArrayPrototype(arrayPrototype);
}
