import { VirtualMachineFriendly } from "./virtual-machine-friendly";
import { HostImportTable } from "../lib";

export function addBuiltinGlobals(vm: VirtualMachineFriendly) {
  const global = vm.globalThis;
  global.Infinity = Infinity;
  global.NaN = NaN;
  global.undefined = undefined;
  // TODO: There has to be a better way to encapsulate this
  global.isNaN = vm.importHostFunction(0xFFFD)
}

export const builtGlobalImports: HostImportTable = {
  [0xFFFD]: (arg: any) => isNaN(arg)
}