import glob from 'glob';
import * as path from 'path';
import fs from 'fs-extra';
import * as VM from '../../lib/virtual-machine';
import { VirtualMachineFriendly } from '../../lib/virtual-machine-friendly';
import { encodeSnapshot, stringifySnapshotInfo } from '../../lib/snapshot-info';
import { htmlPageTemplate } from '../../lib/general';
import YAML from 'yaml';
import { microvium, ImportTable } from '../../lib';
import { assertSameCode } from '../common';

const testDir = './test/end-to-end/tests';
const rootArtifactDir = './test/end-to-end/artifacts';
const testFiles = glob.sync(testDir + '/**/*.test.mvms');

const HOST_FUNCTION_PRINT_ID: VM.HostFunctionID = 1;
const HOST_FUNCTION_ASSERT_ID: VM.HostFunctionID = 2;

interface TestMeta {
  description?: string;
  runExportedFunction?: VM.ExportID;
  expectedPrintout?: string;
  testOnly?: boolean;
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

    (meta.testOnly ? test.only : test)(testFriendlyName, () => {
      fs.emptyDirSync(testArtifactDir);
      fs.writeFileSync(path.resolve(testArtifactDir, '0.meta.yaml'), yamlText);

      // ------------------------- Set up Environment -------------------------

      let printLog: string[] = [];

      function print(v: any) {
        printLog.push(typeof v === 'string' ? v : JSON.stringify(v));
      }

      function vmExport(exportID: VM.ExportID, fn: any) {
        comprehensiveVM.exportValue(exportID, fn);
      }

      function vmAssert(predicate: boolean, message: string) {
        if (!predicate) {
          throw new Error('Failed assertion' + (message ? ' ' + message : ''));
        }
      }

      const importMap: ImportTable = {
        [HOST_FUNCTION_PRINT_ID]: print,
        [HOST_FUNCTION_ASSERT_ID]: vmAssert,
      };

      // ----------------------- Create Comprehensive VM ----------------------

      const comprehensiveVM = VirtualMachineFriendly.create(importMap);
      comprehensiveVM.global.print = comprehensiveVM.importHostFunction(HOST_FUNCTION_PRINT_ID);
      comprehensiveVM.global.assert = comprehensiveVM.importHostFunction(HOST_FUNCTION_ASSERT_ID);
      comprehensiveVM.global.vmExport = vmExport;

      // ----------------------------- Load Source ----------------------------

      comprehensiveVM.importSourceText(src, path.basename(testFilenameRelativeToCurDir));

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
        functionToRun();
        fs.writeFileSync(path.resolve(testArtifactDir, '3.post-run.print.txt'), printLog.join('\n'));
        if (meta.expectedPrintout !== undefined) {
          assertSameCode(printLog.join('\n'), meta.expectedPrintout);
        }
      }

      // --------------------- Run function in native VM ---------------------

      printLog = [];
      const nativeVM = microvium.restore(postGarbageCollectSnapshot, importMap);

      if (meta.runExportedFunction !== undefined) {
        const run = nativeVM.resolveExport(meta.runExportedFunction);
        run();

        fs.writeFileSync(path.resolve(testArtifactDir, '4.native-post-run.print.txt'), printLog.join('\n'));
        if (meta.expectedPrintout !== undefined) {
          assertSameCode(printLog.join('\n'), meta.expectedPrintout);
        }
      }
    });

    // TODO(test): Test native garbage collection
  }
});
