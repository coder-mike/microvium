import { addDefaultGlobals, defaultHostEnvironment, HostImportTable, VirtualMachineFriendly } from "../../lib";
import { NativeVM } from "../../lib/native-vm";
import { NativeVMFriendly } from "../../lib/native-vm-friendly"
import { unexpected } from "../../lib/utils";
import { assert } from 'chai';
import { mvm_TeType } from "../../lib/runtime-types";

suite('native-api', function () {
  test('mvm_typeOf', () => {
    const snapshot = compileJs`
      const values = [
        undefined,
        null,
        true,
        false,
        42,
        -42,
        0xffffffff,
        1.5,
        '',
        'hello',
        'length',
        '__proto__',
        { prop: 42 },
        [1, 2, 3],
        () => 'hey',
      ]
      for (let i = 0; i < values.length; i++) {
        let index = i;
        vmExport(index, () => values[index])
      }
    `

    const expectedTypes = [
      mvm_TeType.VM_T_UNDEFINED, // undefined,
      mvm_TeType.VM_T_NULL,      // null,
      mvm_TeType.VM_T_BOOLEAN,   // true,
      mvm_TeType.VM_T_BOOLEAN,   // false,
      mvm_TeType.VM_T_NUMBER,    // 42,
      mvm_TeType.VM_T_NUMBER,    // -42,
      mvm_TeType.VM_T_NUMBER,    // 0xffffffff,
      mvm_TeType.VM_T_NUMBER,    // 1.5,
      mvm_TeType.VM_T_STRING,    // '',
      mvm_TeType.VM_T_STRING,    // 'hello',
      mvm_TeType.VM_T_STRING,    // 'length',
      mvm_TeType.VM_T_STRING,    // '__proto__',
      mvm_TeType.VM_T_OBJECT,    // { prop: 42 },
      mvm_TeType.VM_T_ARRAY,     // [1, 2, 3],
      mvm_TeType.VM_T_FUNCTION,  // () => 'hey',
    ]

    const vm = new NativeVM(snapshot.data, () => unexpected());

    for (const [i, expectedTypeCode] of expectedTypes.entries()) {
      const f = vm.resolveExport(i);
      const value = vm.call(f, []);
      const typeCode = vm.typeOf(value);
      assert.equal(typeCode, expectedTypeCode);
    }
  })
})

function compileJs(src: TemplateStringsArray) {
  src.length === 1 || unexpected();
  const vm = VirtualMachineFriendly.create()
  addDefaultGlobals(vm);
  vm.evaluateModule({ sourceText: src[0] })
  return vm.createSnapshot();
}