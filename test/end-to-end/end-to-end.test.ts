import glob from 'glob';
import * as path from 'path';
import fs from 'fs-extra';
import * as VM from '../../lib/virtual-machine';
import { VirtualMachineWithMembrane, giveHostFunctionAPersistentID } from '../../lib/virtual-machine-proxy';
import { snapshotToBytecode, stringifySnapshot } from '../../lib/snapshot';
import { htmlPageTemplate } from '../../lib/general';
import YAML from 'yaml';
import { assertSameCode } from '../../lib/utils';

const testDir = './test/end-to-end/tests';
const rootArtifactDir = './test/end-to-end/artifacts';
const testFiles = glob.sync(testDir + '/**/*.test.mvms');

const HOST_FUNCTION_PRINT_ID: VM.HostFunctionID = 1;
const HOST_FUNCTION_ASSERT_ID: VM.HostFunctionID = 2;

interface TestMeta {
  description?: string;
  runExportedFunction?: VM.ExportID;
  expectedPrintout?: string;
}

suite('end-to-end', function () {
  for (let filename of testFiles) {
    const testFilenameFull = path.resolve(filename);
    const testFilenameRelativeToTestDir = path.relative(testDir, testFilenameFull);
    const testFilenameRelativeToCurDir = './' + path.relative(process.cwd(), testFilenameFull).replace(/\\/g, '/');
    const testFriendlyName = testFilenameRelativeToTestDir.slice(0, -10);
    const testArtifactDir = path.resolve(rootArtifactDir, testFilenameRelativeToTestDir.slice(0, -10));
    const src = fs.readFileSync(testFilenameRelativeToCurDir, 'utf8')

    fs.ensureDirSync(testArtifactDir);

    const yamlHeaderMatch = src.match(/\/\*---(.*?)---\*\//s);
    const meta: TestMeta = yamlHeaderMatch
      ? YAML.parse(yamlHeaderMatch[1])
      : {};

    test(testFriendlyName, () => {

      // ------------------------- Set up Environment -------------------------

      const printLog: string[] = [];

      function print(v: any) {
        printLog.push(typeof v === 'string' ? v : JSON.stringify(v));
      }
      giveHostFunctionAPersistentID(HOST_FUNCTION_PRINT_ID, print);

      function vmExport(exportID: VM.ExportID, fn: any) {
        vm.exportValue(exportID, fn);
      }

      function assert(predicate: boolean, message: string) {
        if (!predicate) {
          throw new Error('Failed assertion' + (message ? ' ' + message : ''));
        }
      }
      giveHostFunctionAPersistentID(HOST_FUNCTION_ASSERT_ID, assert);

      const globals = {
        print,
        assert,
        vmExport
      };

      // ----------------------- Create Comprehensive VM ----------------------

      const vm = new VirtualMachineWithMembrane(globals);

      // ----------------------------- Load Source ----------------------------

      vm.importModuleSourceText(src, path.basename(testFilenameRelativeToCurDir));

      const postLoadSnapshot = vm.createSnapshot();
      fs.writeFileSync(path.resolve(testArtifactDir, '1.post-load.snapshot'), stringifySnapshot(postLoadSnapshot));
      const { bytecode: postLoadBytecode, html: postLoadHTML } = snapshotToBytecode(postLoadSnapshot, true);
      fs.writeFileSync(path.resolve(testArtifactDir, '1.post-load.mvm-bc'), postLoadBytecode, null);
      fs.writeFileSync(path.resolve(testArtifactDir, '1.post-load.mvm-bc.html'), htmlPageTemplate(postLoadHTML!));

      // --------------------------- Garbage Collect --------------------------

      vm.garbageCollect();

      const postGarbageCollectSnapshot = vm.createSnapshot();
      fs.writeFileSync(path.resolve(testArtifactDir, '2.post-gc.snapshot'), stringifySnapshot(postGarbageCollectSnapshot));
      const { bytecode: postGarbageCollectBytecode, html: postGarbageCollectHTML } = snapshotToBytecode(postGarbageCollectSnapshot, true);
      fs.writeFileSync(path.resolve(testArtifactDir, '2.post-gc.mvm-bc'), postGarbageCollectBytecode, null);
      fs.writeFileSync(path.resolve(testArtifactDir, '2.post-gc.mvm-bc.html'), htmlPageTemplate(postGarbageCollectHTML!));

      // ---------------------------- Run Function ----------------------------

      if (meta.runExportedFunction !== undefined) {
        const functionToRun = vm.resolveExport(meta.runExportedFunction);
        functionToRun();
        fs.writeFileSync(path.resolve(testArtifactDir, '3.post-run.print.txt'), printLog.join('\n'));
        if (meta.expectedPrintout !== undefined) {
          assertSameCode(printLog.join('\n'), meta.expectedPrintout);
        }
      }
    });
  }
});
