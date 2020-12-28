import { assert } from "chai";
import { Microvium, ModuleSource, nodeStyleImporter } from "../../lib";
import { ModuleOptions } from "../../lib/node-style-importer";
import fs from 'fs-extra';

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

    const module = vm.evaluateModule({
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
      importDependency(specifier) {
        assert.equal(specifier, 'aModule');
        return aModule;
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
      importDependency: specifier => {
        assert.equal(specifier, './m2');
        return vm.evaluateModule(m2);
      }
    };

    const m2: ModuleSource = {
      sourceText: `
        import { x } from './m1'
        print('m2 importing');
        export const y = 6;
        print(x); // Should print 'undefined' if the module cache is working
      `,
      importDependency: specifier => {
        assert.equal(specifier, './m1');
        return vm.evaluateModule(m1);
      }
    }

    let printLog: any[] = [];
    const vm = Microvium.create();
    vm.globalThis.print = (s: any) => printLog.push(s);

    vm.evaluateModule(m1);

    assert.deepEqual(printLog, [
      'm2 importing',
      undefined,
      'm1 importing',
      6
    ]);
  });

  test('shared-import', () => {
    const m1: ModuleSource = {
      sourceText: `
        import { x } from './m3';
        export function inc() { x++; }
        vmExport(1, inc);
      `,
      importDependency: specifier => {
        assert.equal(specifier, './m3');
        return vm.evaluateModule(m3);
      }
    };

    const m2: ModuleSource = {
      sourceText: `
        import { x } from './m3';
        export function printX() { print(x); }
        vmExport(2, printX);
      `,
      importDependency: specifier => {
        assert.equal(specifier, './m3');
        return vm.evaluateModule(m3);
      }
    }

    const m3: ModuleSource = {
      sourceText: `
        export let x = 1;
      `
    }

    let printLog: any[] = [];
    const vm = Microvium.create();
    vm.globalThis.vmExport = vm.vmExport;
    vm.globalThis.print = (s: any) => printLog.push(s);

    const { inc } = vm.evaluateModule(m1);
    const { printX } = vm.evaluateModule(m2);

    printX(); // Prints 1
    inc();
    printX(); // Prints 2, showing that x is shared

    assert.deepEqual(printLog, [
      1,
      2,
    ]);

  })

  test('default-fetcher', () => {
    const moduleOptions: ModuleOptions = {
      fileSystemAccess: 'subdir-only',
      basedir: 'test/modules/src',
      includes: ['**/*.mvm.js'],
      allowNodeCoreModules: true,
      coreModules: {
        'core': './a-core-module.mvm.js'
      }
    };

    let printLog: any[] = [];
    const vm = Microvium.create();

    const importer = nodeStyleImporter(vm, moduleOptions);

    vm.globalThis.print = (s: any) => printLog.push(s);

    if (fs.existsSync('test/modules/output.txt'))
      fs.removeSync('test/modules/output.txt');

    importer('./m1');

    assert.deepEqual(printLog, [
      'importing m3',
      'Writing to a file',
      'importing m2',
      'importing m1',
    ]);

    const output = fs.readFileSync('test/modules/output.txt', 'utf8')
    assert.equal(output, 'This is some output');
  });
});
