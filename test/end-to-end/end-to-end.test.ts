import glob from 'glob';
import * as path from 'path';
import fs from 'fs-extra';
import * as VM from '../../lib/virtual-machine';
import { VirtualMachineWithMembrane, giveHostFunctionAPersistentID } from '../../lib/virtual-machine-proxy';
import { snapshotToBytecode, stringifySnapshot } from '../../lib/snapshot';
import { htmlPageTemplate } from '../../lib/general';

const testDir = './test/end-to-end/tests';
const rootArtifactDir = './test/end-to-end/artifacts';
const testFiles = glob.sync(testDir + '/**/*.test.mvms');

const HOST_FUNCTION_PRINT_ID: VM.HostFunctionID = 1;
const HOST_FUNCTION_ASSERT_ID: VM.HostFunctionID = 2;

suite('end-to-end', function () {
  for (let filename of testFiles) {
    const testFilenameFull = path.resolve(filename);
    const testFilenameRelativeToTestDir = path.relative(testDir, testFilenameFull);
    const testFilenameRelativeToCurDir = './' + path.relative(process.cwd(), testFilenameFull).replace(/\\/g, '/');
    const testFriendlyName = testFilenameRelativeToTestDir.slice(0, -10);
    const testArtifactDir = path.resolve(rootArtifactDir, testFilenameRelativeToTestDir.slice(0, -10));
    fs.ensureDirSync(testArtifactDir);

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

      const src = fs.readFileSync(testFilenameRelativeToCurDir, 'utf8')
      vm.importModuleSourceText(src, path.basename(testFilenameRelativeToCurDir));

      const postLoadSnapshot = vm.createSnapshot();
      fs.writeFileSync(path.resolve(testArtifactDir, '1.post-load.snapshot'), stringifySnapshot(postLoadSnapshot), null);
      const { bytecode: postLoadBytecode, html: postLoadHTML } = snapshotToBytecode(postLoadSnapshot, true);
      fs.writeFileSync(path.resolve(testArtifactDir, '1.post-load.mvm-bc'), postLoadBytecode, null);
      fs.writeFileSync(path.resolve(testArtifactDir, '1.post-load.mvm-bc.html'), htmlPageTemplate(postLoadHTML!), null);

      // --------------------------- Garbage Collect --------------------------

      vm.garbageCollect();

      const postGarbageCollectSnapshot = vm.createSnapshot();
      fs.writeFileSync(path.resolve(testArtifactDir, '2.post-gc.snapshot'), stringifySnapshot(postGarbageCollectSnapshot), null);
      const { bytecode: postGarbageCollectBytecode, html: postGarbageCollectHTML } = snapshotToBytecode(postGarbageCollectSnapshot, true);
      fs.writeFileSync(path.resolve(testArtifactDir, '2.post-gc.mvm-bc'), postGarbageCollectBytecode, null);
      fs.writeFileSync(path.resolve(testArtifactDir, '2.post-gc.mvm-bc.html'), htmlPageTemplate(postGarbageCollectHTML!), null);
    });
  }
});
