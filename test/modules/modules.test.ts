import { assert } from "chai";
import { Microvium } from "../../lib";

suite('modules', function () {
  test('basic-import', () => {
    const printLog: any[] = [];

    const vm = Microvium.create();
    vm.globalThis.print = (s: any) => printLog.push(s);

    const aModule = {
      default: 1,
      b: 2,
      d: 3,
      f: 4
    };

    vm.module({
      sourceText: `
        import a from 'aModule';
        import { b } from 'aModule';
        import c, { d } from 'aModule';
        import * as e from 'aModule';
        import { f as g } from 'aModule';
        print(a); // 1
        print(b); // 2
        print(c); // 1
        print(3); // 3
        print(e); // { ... }
        print(g); // 4
      `,
      fetchDependency(specifier) {
        assert.equal(specifier, 'aModule');
        return {
          exports: aModule
        };
      }
    });

    assert.deepEqual(printLog, [
      1,
      2,
      1,
      3,
      { default: 1, b: 2, d: 3, f: 4 },
      4
    ]);
  });
});
