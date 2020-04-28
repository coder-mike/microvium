import { assert } from "chai";
import { Microvium } from "../../lib";

suite('modules', function () {
  test('basic-import', () => {
    let printLog: any[] = [];

    const vm = Microvium.create();
    vm.globalThis.print = (s: any) => printLog.push(s);

    const aModule = {
      default: 1,
      b: 2,
      d: 3,
      f: 4
    };

    const module = vm.module({
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

        export const h = 5, i = 6;
        export function j() {
          print(h);
          return 7;
        }
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

    printLog = [];
    assert.equal(module.h, 5);
    assert.equal(module.i, 6);
    assert.equal(module.j(), 7);
    assert.deepEqual(printLog, [5]);
  });
});
