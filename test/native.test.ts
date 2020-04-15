import MicroVM from '../vm-napi-wrapper';
import { assert } from 'chai';

suite('napi', function () {
  test('napi', () => {
    const result = MicroVM("hello");
    assert.equal(result, 'world')
  });
});