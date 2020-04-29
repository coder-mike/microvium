import { assert } from "chai";
import { Microvium, ModuleSource, fetchEntryModule } from "../../lib";
import { ModuleOptions } from "../../lib/fetcher";

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
          moduleObject: aModule
        }
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

  test('module-source-import', () => {
    const m1: ModuleSource = {
      sourceText: `
        import { y } from './m2';
        print('m1 importing');
        export const x = 5;
        print(y); // print 6
      `,
      fetchDependency: specifier => {
        assert.equal(specifier, './m2');
        return { moduleSource: m2 };
      }
    };

    const m2: ModuleSource = {
      sourceText: `
        import { x } from './m1'
        print('m2 importing');
        export const y = 6;
        print(x); // Should print 'undefined' if the module cache is working
      `,
      fetchDependency: specifier => {
        assert.equal(specifier, './m1');
        return { moduleSource: m1 };
      }
    }

    let printLog: any[] = [];
    const vm = Microvium.create();
    vm.globalThis.print = (s: any) => printLog.push(s);

    vm.module(m1);

    assert.deepEqual(printLog, [
      'm2 importing',
      undefined,
      'm1 importing',
      6
    ]);
  });

  test('default-fetcher', () => {
    const moduleOptions: ModuleOptions = {
      accessFromFileSystem: 'subdir-only',
      basedir: 'test/modules/src',
      includes: ['**/*.mvms'],
      allowNodeCoreModules: true,
      coreModules: {
        'core': './a-core-module.mvms'
      }
    };

    let printLog: any[] = [];
    const vm = Microvium.create();
    vm.globalThis.print = (s: any) => printLog.push(s);

    const m1 = fetchEntryModule('./m1', moduleOptions);
    vm.module(m1);

    assert.deepEqual(printLog, [
      'importing m3',
      'importing m2',
      'importing m1',
    ]);
  });
});
