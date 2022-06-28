import { addDefaultGlobals, defaultHostEnvironment, HostImportTable, VirtualMachineFriendly } from "../../lib";
import { NativeVM, Value } from "../../lib/native-vm";
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

  test('object manipulation', () => {
    const snapshot = compileJs`
      const newObject = () => ({});
      const getProp = (o, p) => o[p];
      const setProp = (o, p, v) => o[p] = v;

      vmExport(1, newObject);
      vmExport(2, getProp);
      vmExport(3, setProp);
    `

    const vm = new NativeVM(snapshot.data, () => unexpected());

    const newObject_ = vm.resolveExport(1);
    const getProp_ = vm.resolveExport(2);
    const setProp_ = vm.resolveExport(3);
    const newObject = () => vm.call(newObject_, []);
    const getProp = (o: Value, p: string) => vm.call(getProp_, [o, vm.newString(p)])
    const setProp = (o: Value, p: string, v: Value) => vm.call(setProp_, [o, vm.newString(p), v])

    // Note: the node bindings for Value
    // ([Value.cc](../../native-vm-bindings/Value.cc)) wraps a Microvium GC
    // handle. If you were doing this in C, you would need to create and release
    // the handles yourself.

    // myObject1 = { x: 5, y: 6 }
    const myObject1 = newObject();
    setProp(myObject1, 'x', vm.newNumber(5));
    setProp(myObject1, 'y', vm.newNumber(6));

    // myObject2 = { x: 'hello', y: myObject1 }
    const myObject2 = newObject();
    setProp(myObject2, 'x', vm.newString('hello'));
    setProp(myObject2, 'y', myObject1);

    // assert.equal(myObject1.x, 5)
    assert.equal(getProp(myObject1, 'x').toNumber(), 5)
    // assert.equal(myObject1.y, 6)
    assert.equal(getProp(myObject1, 'y').toNumber(), 6)
    // assert.equal(myObject2.x, 'hello')
    assert.equal(getProp(myObject2, 'x').toString(), 'hello')
    // assert.equal(myObject2.y.x, 5)
    assert.equal(getProp(getProp(myObject2, 'y'), 'x').toNumber(), 5)
  })
})

function compileJs(src: TemplateStringsArray) {
  src.length === 1 || unexpected();
  const vm = VirtualMachineFriendly.create()
  addDefaultGlobals(vm);
  vm.evaluateModule({ sourceText: src[0] })
  return vm.createSnapshot();
}