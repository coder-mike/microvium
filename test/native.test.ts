import MicroVM from '../vm-napi-wrapper';
import { assert } from 'chai';
import * as fs from 'fs-extra';

suite('napi', function () {
  test('napi', () => {
    const bytecode = fs.readFileSync('./test/end-to-end/artifacts/hello-world/2.post-gc.mvm-bc', null);
    const imports = {};
    // const result = MicroVM.resume(bytecode, imports);
    // assert(result);
  });
});