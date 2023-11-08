import glob from 'glob';
import * as path from 'path';
import fs from 'fs-extra';
import * as IL from '../../lib/il';
import { VirtualMachineFriendly } from '../../lib/virtual-machine-friendly';
import { stringifySnapshotIL } from '../../lib/snapshot-il';
import { htmlPageTemplate } from '../../lib/general';
import YAML from 'yaml';
import { Microvium, HostImportTable, addDefaultGlobals } from '../../lib';
import { assertSameCode } from '../common';
import { assert } from 'chai';
import { NativeVM } from '../../lib/native-vm';
import { unexpected, writeTextFile } from '../../lib/utils';
import { encodeSnapshot } from '../../lib/encode-snapshot';
import { decodeSnapshot } from '../../lib/decode-snapshot';
import { compileScript, parseToAst } from '../../lib/src-to-il/src-to-il';
import { stringifyUnit } from '../../lib/stringify-il';
import { stringifyAnalysis } from '../../lib/src-to-il/analyze-scopes/stringify-analysis';
import { analyzeScopes } from '../../lib/src-to-il/analyze-scopes';
import { normalizeIL } from '../../lib/normalize-il';
import { anyGrepSelector } from '../code-coverage.test';
import nodeVM from 'vm';
import { mvm_TeType } from '../../lib/runtime-types';
import { stringifySourceMap } from '../../lib/source-map';

const testDir = './test/end-to-end/tests';
const rootArtifactDir = './test/end-to-end/artifacts';
const testFiles = glob.sync(testDir + '/**/*.test.mvm.js');

const HOST_FUNCTION_PRINT_ID: IL.HostFunctionID = 1;
const HOST_FUNCTION_ASSERT_ID: IL.HostFunctionID = 2;
const HOST_FUNCTION_ASSERT_EQUAL_ID: IL.HostFunctionID = 3;
const HOST_FUNCTION_GET_HEAP_USED_ID: IL.HostFunctionID = 4;
const HOST_FUNCTION_RUN_GC_ID: IL.HostFunctionID = 5;
const HOST_FUNCTION_ASYNC_TEST_COMPLETE: IL.HostFunctionID = 6;

interface TestMeta {
  description?: string;
  runExportedFunction?: IL.ExportID;
  expectedPrintout?: string;
  expectException?: string;
  testOnly?: boolean;
  skip?: boolean;
  skipNative?: boolean;
  nativeOnly?: boolean;
  assertionCount?: number; // Expected assertion count for each call of the runExportedFunction function
  dontCompareDisassembly?: boolean;
  isAsync?: boolean; // Test must call asyncTestComplete
}

suite('end-to-end', function () {
  // The main reason to enumerate the cases in advance is so we can determine
  // `anySkips` in advance
  const cases = [...enumerateCases(testFiles)];

  const anySkips = cases.some(({ meta }) => !!meta.skip || !!meta.skipNative || !!meta.testOnly)

  for (const testCase of cases) {
    const {
      meta,
      testFriendlyName,
      testArtifactDir,
      yamlText,
      src,
      testFilenameRelativeToCurDir,
    } = testCase;

    if (meta.skip) {
      // If a test is skipped, it's good to still output the updated yaml file
      // so that the C++ tests can access this yaml file and know that they also
      // need to skip the tests
      writeTextFile(path.resolve(testArtifactDir, '0.meta.yaml'), yamlText || '');
    }

    const runner =
      meta.skip ? test.skip :
      meta.testOnly ? test.only :
      test;

    // The reason I'm using this container is just when you're debugging it's
    // nice to see the test case name show up in the call stack, which requires
    // that we can name the function dynamically
    const testContainer = {
      async [testFriendlyName]() {
        // It's convenient not to wipe the test output if we're only running a
        // subset of the cases, otherwise un-run cases show up in the git diff as
        // "deleted" files. But it's good to remove the test output before a full
        // run confirm that no test output is the result of an old run.
        await runTest(anySkips, testArtifactDir, yamlText, src, testFilenameRelativeToCurDir, meta);
      }
    };

    runner(testFriendlyName, testContainer[testFriendlyName]);
  }
});

async function runTest(anySkips: boolean, testArtifactDir: string, yamlText: string | undefined, src: string, testFilenameRelativeToCurDir: string, meta: TestMeta) {
  if (!anySkips && !anyGrepSelector) {
    fs.emptyDirSync(testArtifactDir);
  } else {
    fs.ensureDirSync(testArtifactDir);
  }
  writeTextFile(path.resolve(testArtifactDir, '0.meta.yaml'), yamlText || '');

  // ------------------------- Set up Environment -------------------------
  let printLog: string[] = [];
  let assertionCount = 0;
  let resolveTest: any;
  let rejectTest: any;
  let testCompletionPromise: Promise<any>;

  function print(v: any) {
    printLog.push(typeof v === 'string' ? v : JSON.stringify(v));
  }

  function vmExport(exportID: IL.ExportID, fn: any) {
    vm.vmExport(exportID, fn);
  }

  function vmAssert(predicate: boolean, message: string) {
    assertionCount++;
    if (!predicate) {
      throw new Error('Failed assertion' + (message ? ' ' + message : ''));
    }
  }

  function vmAssertEqual(a: any, b: any) {
    assertionCount++;
    if (a !== b) {
      throw new Error(`Expected ${a} to equal ${b}`);
    }
  }

  function asyncTestComplete(isSuccess: boolean, value: any) {
    if (isSuccess) resolveTest(value);
    else rejectTest(value);
  }

  function vmGetHeapUsed() {
    // We'll override this at runtime
    return 0;
  }

  function vmRunGC() {
    vm.garbageCollect();
  }

  const importMap: HostImportTable = {
    [HOST_FUNCTION_PRINT_ID]: print,
    [HOST_FUNCTION_ASSERT_ID]: vmAssert,
    [HOST_FUNCTION_ASSERT_EQUAL_ID]: vmAssertEqual,
    [HOST_FUNCTION_GET_HEAP_USED_ID]: vmGetHeapUsed,
    [HOST_FUNCTION_RUN_GC_ID]: vmRunGC,
    [HOST_FUNCTION_ASYNC_TEST_COMPLETE]: asyncTestComplete,
  };

  // ------------------------------- Node JS -----------------------------
  // Run the script in node.js first. If the behavior of these scripts is
  // wrong in node.js then it's wrong in general, since Microvium
  // implements a subset of JS that node.js also supports, but it's easier
  // to debug in node.js if there are failures so better to do this first.
  // These tests are also run against node.js to confirm that the behavior
  // of Microvium is the same as node.js.
  //
  // Note: this is is not a completely isolated execution through a
  // membrane, but we could develop this further to use a real membrane
  // and even emulated snapshotting using something [like this](https://gist.github.com/coder-mike/1ed193def4a20477558a181234328b97).
  const exportsInNode: any = {};
  const globalsForNode: any = {
    vmExport: (id: number, fn: any) => exportsInNode[id] = fn,
    print,
    assert: vmAssert,
    assertEqual: vmAssertEqual,
    asyncTestComplete,
    $$MicroviumNopInstruction: () => { },
    Number: { isNaN: Number.isNaN },
    NaN: NaN,
    Infinity,
    undefined,
    overflowChecks: true,
    getHeapUsed: undefined,
    runGC: undefined,
    console: { log: print },
    Reflect: { ownKeys: (obj: any) => Reflect.ownKeys(obj).filter(k => typeof k === 'string') },
    Promise: undefined, // Will be set later
    hostAsyncFunction: async (x: number) => x + 1,
    Microvium: {
      newUint8Array: (count: number) => new Uint8Array(count),
      noOpFunction: () => undefined,
      typeCodeOf: (value: any) => {
        switch (typeof value) {
          case 'undefined': return mvm_TeType.VM_T_UNDEFINED;
          case 'boolean': return mvm_TeType.VM_T_BOOLEAN;
          case 'number': return mvm_TeType.VM_T_NUMBER;
          case 'string': return mvm_TeType.VM_T_STRING;
          case 'function': {
            if (typeof value.prototype === 'object' && value.prototype.constructor === value) {
              return mvm_TeType.VM_T_CLASS;
            } else {
              return mvm_TeType.VM_T_FUNCTION;
            }
          }
          case 'object': {
            if (value === null) return mvm_TeType.VM_T_NULL;
            if (Array.isArray(value)) return mvm_TeType.VM_T_ARRAY;
            if (value instanceof Uint8Array) return mvm_TeType.VM_T_UINT8_ARRAY;
            return mvm_TeType.VM_T_OBJECT;
          }
          case 'symbol': return mvm_TeType.VM_T_SYMBOL;
          case 'bigint': return mvm_TeType.VM_T_BIG_INT;
          default: throw new Error(`Type not supported: ${typeof value}`);
        }
      }
    }
  };
  const globalProxyForNode: any = new Proxy({}, {
    has: (_, p) => true,
    get: (_, p) => globalsForNode[p],
    set: (_, p, v) => globalsForNode[p] = v,
  });
  globalProxyForNode.globalThis = globalProxyForNode;

  nodeVM.createContext(globalProxyForNode);

  // Need to use the Promise from the node.js context, not the one from
  // the outer, test context.
  const extractPromiseScript = new nodeVM.Script('(async ()=>{})().__proto__.constructor');
  const innerPromise = extractPromiseScript.runInContext(globalProxyForNode);
  globalsForNode.Promise = innerPromise;

  const script = new nodeVM.Script(`(function() {${src}\n})`, { filename: path.resolve(testFilenameRelativeToCurDir) });
  // Evaluate top-level code
  script.runInContext(globalProxyForNode)();

  if (meta.runExportedFunction !== undefined && !meta.nativeOnly) {
    assertionCount = 0;
    printLog = [];
    testCompletionPromise = new Promise((...a) => [resolveTest, rejectTest] = a);

    const functionToRun = exportsInNode[meta.runExportedFunction] ?? unexpected();

    if (meta.expectException) {
      let threw = undefined;
      try {
        functionToRun();
        if (meta.isAsync) await testCompletionPromise;
      } catch (e) {
        threw = e;
      }
      if (!threw) {
        assert(false, 'Expected exception to be thrown but none thrown');
      }
      assert.deepEqual(threw, meta.expectException);
    } else {
      functionToRun();
      if (meta.isAsync) await testCompletionPromise;
    }

    if (meta.expectedPrintout !== undefined) {
      assertSameCode(printLog.join('\n'), meta.expectedPrintout);
    }
    if (meta.assertionCount !== undefined) {
      assert.equal(assertionCount, meta.assertionCount, 'Expected assertion count');
    }
  }

  // End of Node.js test
  // ------------------- Analysis and Compilation ------------------
  // The `compileScript` pass also produces the same analysis but in case
  // the compilation fails, it's useful to have the scope analysis early.
  const analysis = analyzeScopes(parseToAst(testFilenameRelativeToCurDir, src), testFilenameRelativeToCurDir);
  writeTextFile(path.resolve(testArtifactDir, '0.scope-analysis'), stringifyAnalysis(analysis));

  // Note: this unit is not used for execution. It's just for generating diagnostic IL
  const { unit } = compileScript(testFilenameRelativeToCurDir, src);
  writeTextFile(path.resolve(testArtifactDir, '0.unit.il'), stringifyUnit(unit, {
    showComments: true,
    commentSourceLocations: true,
    showStackDepth: true,
    showVariableNameHints: true,
  }));

  // ------------------- Create VirtualMachineFriendly ------------------
  const vm = VirtualMachineFriendly.create(importMap, {
    // Match behavior of NativeVM for overflow checking. This allows us to
    // compile with either overflow checks enabled or not and have
    // consistent results from the tests.
    overflowChecks: NativeVM.MVM_PORT_INT32_OVERFLOW_CHECKS
  });
  addDefaultGlobals(vm);
  const vmGlobal = vm.globalThis;
  vmGlobal.print = vm.vmImport(HOST_FUNCTION_PRINT_ID);
  vmGlobal.assert = vm.vmImport(HOST_FUNCTION_ASSERT_ID);
  vmGlobal.assertEqual = vm.vmImport(HOST_FUNCTION_ASSERT_EQUAL_ID);
  vmGlobal.getHeapUsed = vm.vmImport(HOST_FUNCTION_GET_HEAP_USED_ID);
  vmGlobal.runGC = vm.vmImport(HOST_FUNCTION_RUN_GC_ID);
  vmGlobal.vmExport = vmExport;
  vmGlobal.overflowChecks = NativeVM.MVM_PORT_INT32_OVERFLOW_CHECKS;
  vmGlobal.textSupport = NativeVM.MVM_TEXT_SUPPORT;
  vmGlobal.asyncTestComplete = vm.vmImport(HOST_FUNCTION_ASYNC_TEST_COMPLETE);
  const vmConsole = vmGlobal.console = vm.newObject();
  vmConsole.log = vmGlobal.print; // Alternative way of accessing the print function



  // ---------------------------- Load Source ---------------------------
  vm.evaluateModule({ sourceText: src, debugFilename: testFilenameRelativeToCurDir });

  const postLoadSnapshotInfo = vm.createSnapshotIL();
  writeTextFile(path.resolve(testArtifactDir, '1.post-load.snapshot'), stringifySnapshotIL(postLoadSnapshotInfo, {
    // commentSourceLocations: true
  }));
  const { snapshot: postLoadSnapshot, html: postLoadHTML } = encodeSnapshot(postLoadSnapshotInfo, true, true);
  fs.writeFileSync(path.resolve(testArtifactDir, '1.post-load.mvm-bc'), postLoadSnapshot.data, null);
  writeTextFile(path.resolve(testArtifactDir, '1.post-load.mvm-bc.html'), htmlPageTemplate(postLoadHTML!));
  writeTextFile(path.resolve(testArtifactDir, '1.post-load.mvm-bc.source-map'), stringifySourceMap(postLoadSnapshot.sourceMap ?? unexpected()));
  const decoded = decodeSnapshot(postLoadSnapshot);
  writeTextFile(path.resolve(testArtifactDir, '1.post-load.mvm-bc.disassembly'), decoded.disassembly);
  if (!meta.dontCompareDisassembly) {
    // This checks that a round-trip serialization and deserialization of
    // the post-load snapshot gives us the same thing.
    assertSameCode(
      stringifySnapshotIL(normalizeIL(decoded.snapshotInfo), {
        showComments: false
      }),
      stringifySnapshotIL(normalizeIL(postLoadSnapshotInfo), {
        showComments: false
      })
    );
  }

  // ---------------------------- Run Function in build-time VM ----------------------------
  if (meta.runExportedFunction !== undefined && !meta.nativeOnly) {
    const functionToRun = vm.resolveExport(meta.runExportedFunction);
    assertionCount = 0;
    printLog = [];
    testCompletionPromise = new Promise((...a) => [resolveTest, rejectTest] = a);

    if (meta.expectException) {
      let threw = undefined;
      try {
        functionToRun();
        if (meta.isAsync) await testCompletionPromise;
      } catch (e) {
        threw = e;
      }
      if (!threw) {
        assert(false, 'Expected exception to be thrown but none thrown');
      }
      assert.deepEqual(threw, meta.expectException);
    } else {
      functionToRun();
      if (meta.isAsync) await testCompletionPromise;
    }

    writeTextFile(path.resolve(testArtifactDir, '2.post-run.print.txt'), printLog.join('\n'));
    if (meta.expectedPrintout !== undefined) {
      assertSameCode(printLog.join('\n'), meta.expectedPrintout);
    }
    if (meta.assertionCount !== undefined) {
      assert.equal(assertionCount, meta.assertionCount, 'Expected assertion count');
    }
  }

  // --------------------- Run function in native VM ---------------------
  if (!meta.skipNative) {
    printLog = [];
    testCompletionPromise = new Promise((...a) => [resolveTest, rejectTest] = a);

    function vmGetHeapUsed() {
      const memoryStats = nativeVM.getMemoryStats();
      return memoryStats.virtualHeapUsed;
    }

    function vmRunGC(squeeze?: boolean) {
      nativeVM.garbageCollect(squeeze);
    }

    importMap[HOST_FUNCTION_GET_HEAP_USED_ID] = vmGetHeapUsed;
    importMap[HOST_FUNCTION_RUN_GC_ID] = vmRunGC;
    importMap[HOST_FUNCTION_ASYNC_TEST_COMPLETE] = asyncTestComplete;

    const nativeVM = Microvium.restore(postLoadSnapshot, importMap);

    const preRunSnapshot = nativeVM.createSnapshot();
    writeTextFile(path.resolve(testArtifactDir, '3.native-pre-run.mvm-bc.disassembly'), decodeSnapshot(preRunSnapshot).disassembly);

    // The garbage collection here shouldn't do anything, because it's already compacted
    nativeVM.garbageCollect(true);

    // Note: after the GC, things may have moved around in memory
    writeTextFile(path.resolve(testArtifactDir, '3.native-post-gc.mvm-bc.disassembly'), decodeSnapshot(nativeVM.createSnapshot()).disassembly);

    if (meta.runExportedFunction !== undefined) {
      const run = nativeVM.resolveExport(meta.runExportedFunction);
      assertionCount = 0;

      if (meta.expectException) {
        let threw = undefined;
        try {
          run();
          if (meta.isAsync) await testCompletionPromise;
        } catch (e) {
          threw = e;
        }
        if (!threw) {
          assert(false, 'Expected exception to be thrown but none thrown');
        }
        assert.deepEqual(threw.message, meta.expectException);
      } else {
        run();
        if (meta.isAsync) await testCompletionPromise;
      }

      const postRunSnapshot = nativeVM.createSnapshot();
      fs.writeFileSync(path.resolve(testArtifactDir, '4.native-post-run.mvm-bc'), postRunSnapshot.data, null);

      writeTextFile(path.resolve(testArtifactDir, '4.native-post-run.mvm-bc.disassembly'), decodeSnapshot(postRunSnapshot).disassembly);

      writeTextFile(path.resolve(testArtifactDir, '4.native-post-run.print.txt'), printLog.join('\n'));
      if (meta.expectedPrintout !== undefined) {
        assertSameCode(printLog.join('\n'), meta.expectedPrintout);
      }
      if (meta.assertionCount !== undefined) {
        assert.equal(assertionCount, meta.assertionCount, 'Expected assertion count');
      }

      nativeVM.garbageCollect(true);
      const postGCSnapshot = nativeVM.createSnapshot();
      writeTextFile(path.resolve(testArtifactDir, '5.native-post-gc.mvm-bc.disassembly'), decodeSnapshot(postGCSnapshot).disassembly);
    }
  }
}

function* enumerateCases(testFiles: string[]) {
  for (const filename of testFiles) {
    const testFilenameFull = path.resolve(filename);
    const testFilenameRelativeToTestDir = path.relative(testDir, testFilenameFull);
    const testFilenameRelativeToCurDir = './' + path.relative(process.cwd(), testFilenameFull).replace(/\\/g, '/');
    const testFriendlyName = testFilenameRelativeToTestDir.slice(0, -12);
    const testArtifactDir = path.resolve(rootArtifactDir, testFilenameRelativeToTestDir.slice(0, -12));

    const src = fs.readFileSync(testFilenameRelativeToCurDir, 'utf8');

    const yamlHeaderMatch = src.match(/\/\*---(.*?)---\*\//s);
    const yamlText = yamlHeaderMatch
      ? yamlHeaderMatch[1].trim()
      : undefined;
    const meta: TestMeta = yamlText
      ? YAML.parse(yamlText)
      : {};

    yield {
      meta,
      testFriendlyName,
      testArtifactDir,
      yamlText,
      src,
      testFilenameRelativeToCurDir,
    }
  }
}