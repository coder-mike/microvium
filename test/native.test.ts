import { MicroVM, vm_TeType, Value } from '../vm-napi-wrapper';
import { assert } from 'chai';
import * as fs from 'fs-extra';
import { unexpected, invalidOperation } from '../lib/utils';

suite('napi', function () {
  test('napi', () => {
    // Still working on it.

    // const bytecode = fs.readFileSync('./test/end-to-end/artifacts/hello-world/2.post-gc.mvm-bc', null);
    // const printLog: string[] = [];
    // const vm = MicroVM.resume(bytecode, hostFunctionID => {
    //   if (hostFunctionID !== 1) return unexpected();
    //   return print;
    // });
    // assert(vm);

    // const run = vm.resolveExport(42);
    // assert(run.type !== vm_TeType.VM_T_FUNCTION);
    // vm.call(run, []);

    // assert.deepEqual(printLog, ['Hello, World!']);

    // function print(_object: Value, args: Value[]): Value {
    //   if (args.length < 1) return invalidOperation('Invalid number of arguments to `print`');
    //   const messageArg = args[0];
    //   if (messageArg.type !== vm_TeType.VM_T_STRING) return invalidOperation('Expected first argument to `print` to be a string');
    //   const message = messageArg.asString();
    //   printLog.push(message);
    //   return vm.undefined;
    // }
  });
});