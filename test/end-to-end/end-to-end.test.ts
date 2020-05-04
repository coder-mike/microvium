import glob from 'glob';
import * as path from 'path';
import fs from 'fs-extra';
import * as VM from '../../lib/virtual-machine';
import * as IL from '../../lib/il';
import { VirtualMachineFriendly } from '../../lib/virtual-machine-friendly';
import { encodeSnapshot, stringifySnapshotInfo } from '../../lib/snapshot-info';
import { htmlPageTemplate } from '../../lib/general';
import YAML from 'yaml';
import { Microvium, HostImportTable } from '../../lib';
import { assertSameCode } from '../common';
import { assert } from 'chai';

const testDir = './test/end-to-end/tests';
const rootArtifactDir = './test/end-to-end/artifacts';
const testFiles = glob.sync(testDir + '/**/*.test.mvms');

const HOST_FUNCTION_PRINT_ID: IL.HostFunctionID = 1;
const HOST_FUNCTION_ASSERT_ID: IL.HostFunctionID = 2;
const HOST_FUNCTION_ASSERT_EQUAL_ID: IL.HostFunctionID = 3;

interface TestMeta {
  description?: string;
  runExportedFunction?: IL.ExportID;
  expectedPrintout?: string;
  testOnly?: boolean;
  skip?: boolean;
  skipNativeTest?: boolean;
  assertionCount?: number; // Expected assertion count for each call of the runExportedFunction function
}

suite('end-to-end', function () {
  for (let filename of testFiles) {
    const testFilenameFull = path.resolve(filename);
    const testFilenameRelativeToTestDir = path.relative(testDir, testFilenameFull);
    const testFilenameRelativeToCurDir = './' + path.relative(process.cwd(), testFilenameFull).replace(/\\/g, '/');
    const testFriendlyName = testFilenameRelativeToTestDir.slice(0, -10);
    const testArtifactDir = path.resolve(rootArtifactDir, testFilenameRelativeToTestDir.slice(0, -10));
    const src = fs.readFileSync(testFilenameRelativeToCurDir, 'utf8');

    const yamlHeaderMatch = src.match(/\/\*---(.*?)---\*\//s);
    const yamlText = yamlHeaderMatch
      ? yamlHeaderMatch[1].trim()
      : undefined;
    const meta: TestMeta = yamlText
      ? YAML.parse(yamlText)
      : {};

    (meta.skip ? test.skip : meta.testOnly ? test.only : test)(testFriendlyName, () => {
      fs.emptyDirSync(testArtifactDir);
      fs.writeFileSync(path.resolve(testArtifactDir, '0.meta.yaml'), yamlText);

      // ------------------------- Set up Environment -------------------------

      let printLog: string[] = [];
      let assertionCount = 0;

      function print(v: any) {
        printLog.push(typeof v === 'string' ? v : JSON.stringify(v));
      }

      function vmExport(exportID: IL.ExportID, fn: any) {
        comprehensiveVM.exportValue(exportID, fn);
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

      const importMap: HostImportTable = {
        [HOST_FUNCTION_PRINT_ID]: print,
        [HOST_FUNCTION_ASSERT_ID]: vmAssert,
        [HOST_FUNCTION_ASSERT_EQUAL_ID]: vmAssertEqual,
      };

      // ----------------------- Create Comprehensive VM ----------------------

      const comprehensiveVM = VirtualMachineFriendly.create(importMap);
      comprehensiveVM.globalThis.print = comprehensiveVM.importHostFunction(HOST_FUNCTION_PRINT_ID);
      comprehensiveVM.globalThis.assert = comprehensiveVM.importHostFunction(HOST_FUNCTION_ASSERT_ID);
      comprehensiveVM.globalThis.assertEqual = comprehensiveVM.importHostFunction(HOST_FUNCTION_ASSERT_EQUAL_ID);
      comprehensiveVM.globalThis.vmExport = vmExport;

      // ----------------------------- Load Source ----------------------------

      // TODO: Nested import
      comprehensiveVM.evaluateModule({ sourceText: src, debugFilename: path.basename(testFilenameRelativeToCurDir) });

      const postLoadSnapshotInfo = comprehensiveVM.createSnapshotInfo();
      fs.writeFileSync(path.resolve(testArtifactDir, '1.post-load.snapshot'), stringifySnapshotInfo(postLoadSnapshotInfo));
      const { snapshot: postLoadSnapshot, html: postLoadHTML } = encodeSnapshot(postLoadSnapshotInfo, true);
      fs.writeFileSync(path.resolve(testArtifactDir, '1.post-load.mvm-bc'), postLoadSnapshot.data, null);
      fs.writeFileSync(path.resolve(testArtifactDir, '1.post-load.mvm-bc.html'), htmlPageTemplate(postLoadHTML!));

      // --------------------------- Garbage Collect --------------------------

      comprehensiveVM.garbageCollect();

      const postGarbageCollectSnapshotInfo = comprehensiveVM.createSnapshotInfo();
      fs.writeFileSync(path.resolve(testArtifactDir, '2.post-gc.snapshot'), stringifySnapshotInfo(postGarbageCollectSnapshotInfo));
      const { snapshot: postGarbageCollectSnapshot, html: postGarbageCollectHTML } = encodeSnapshot(postGarbageCollectSnapshotInfo, true);
      fs.writeFileSync(path.resolve(testArtifactDir, '2.post-gc.mvm-bc'), postGarbageCollectSnapshot.data, null);
      fs.writeFileSync(path.resolve(testArtifactDir, '2.post-gc.mvm-bc.html'), htmlPageTemplate(postGarbageCollectHTML!));

      // ---------------------------- Run Function ----------------------------

      if (meta.runExportedFunction !== undefined) {
        const functionToRun = comprehensiveVM.resolveExport(meta.runExportedFunction);
        assertionCount = 0;
        functionToRun();
        fs.writeFileSync(path.resolve(testArtifactDir, '3.post-run.print.txt'), printLog.join('\n'));
        if (meta.expectedPrintout !== undefined) {
          assertSameCode(printLog.join('\n'), meta.expectedPrintout);
        }
        if (meta.assertionCount !== undefined) {
          assert.equal(assertionCount, meta.assertionCount, 'Expected assertion count');
        }
      }

      // --------------------- Run function in native VM ---------------------

      if (!meta.skipNativeTest) {
        printLog = [];
        const nativeVM = Microvium.restore(postGarbageCollectSnapshot, importMap);

        if (meta.runExportedFunction !== undefined) {
          const run = nativeVM.resolveExport(meta.runExportedFunction);
          assertionCount = 0;
          run();

          fs.writeFileSync(path.resolve(testArtifactDir, '4.native-post-run.print.txt'), printLog.join('\n'));
          if (meta.expectedPrintout !== undefined) {
            assertSameCode(printLog.join('\n'), meta.expectedPrintout);
          }
          if (meta.assertionCount !== undefined) {
            assert.equal(assertionCount, meta.assertionCount, 'Expected assertion count');
          }
        }
      }
    });

    // TODO(test): Test native garbage collection
  }
});
