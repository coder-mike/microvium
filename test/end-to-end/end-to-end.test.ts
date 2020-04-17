import glob from 'glob';
import * as path from 'path';
import fs from 'fs-extra';
import * as VM from '../../lib/virtual-machine';
import { VirtualMachineFriendly, PersistentHostFunction, persistentHostFunction } from '../../lib/virtual-machine-friendly';
import { encodeSnapshot, stringifySnapshot } from '../../lib/snapshot-info';
import { htmlPageTemplate } from '../../lib/general';
import YAML from 'yaml';
import { assertSameCode, unexpected, invalidOperation } from '../../lib/utils';
import * as Native from '../../lib/native-vm';
import { assert } from 'chai';

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
    const src = fs.readFileSync(testFilenameRelativeToCurDir, 'utf8');

    const yamlHeaderMatch = src.match(/\/\*---(.*?)---\*\//s);
    const meta: TestMeta = yamlHeaderMatch
      ? YAML.parse(yamlHeaderMatch[1])
      : {};

    test(testFriendlyName, () => {
      fs.emptyDirSync(testArtifactDir);

      // ------------------------- Set up Environment -------------------------

      const printLog: string[] = [];

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

      const globals = {
        print: persistentHostFunction(HOST_FUNCTION_PRINT_ID, print),
        assert: persistentHostFunction(HOST_FUNCTION_ASSERT_ID, vmAssert),
        vmExport
      };

      // ----------------------- Create Comprehensive VM ----------------------

      const comprehensiveVM = new VirtualMachineFriendly(globals);

      // ----------------------------- Load Source ----------------------------

      comprehensiveVM.importSourceText(src, path.basename(testFilenameRelativeToCurDir));

      const postLoadSnapshot = comprehensiveVM.createSnapshotInfo();
      fs.writeFileSync(path.resolve(testArtifactDir, '1.post-load.snapshot'), stringifySnapshot(postLoadSnapshot));
      const { bytecode: postLoadBytecode, html: postLoadHTML } = encodeSnapshot(postLoadSnapshot, true);
      fs.writeFileSync(path.resolve(testArtifactDir, '1.post-load.mvm-bc'), postLoadBytecode, null);
      fs.writeFileSync(path.resolve(testArtifactDir, '1.post-load.mvm-bc.html'), htmlPageTemplate(postLoadHTML!));

      // --------------------------- Garbage Collect --------------------------

      comprehensiveVM.garbageCollect();

      const postGarbageCollectSnapshot = comprehensiveVM.createSnapshotInfo();
      fs.writeFileSync(path.resolve(testArtifactDir, '2.post-gc.snapshot'), stringifySnapshot(postGarbageCollectSnapshot));
      const { bytecode: postGarbageCollectBytecode, html: postGarbageCollectHTML } = encodeSnapshot(postGarbageCollectSnapshot, true);
      fs.writeFileSync(path.resolve(testArtifactDir, '2.post-gc.mvm-bc'), postGarbageCollectBytecode, null);
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

      // --------------------- Run function in compact VM ---------------------

      const nativePrintLog: string[] = [];
      const nativeVM = Native.MicroVM.resume(postGarbageCollectBytecode, (hostFunctionID: Native.HostFunctionID): Native.HostFunction => {
        if (HOST_FUNCTION_PRINT_ID === 1) return printNative;
        return unexpected();
      });

      if (meta.runExportedFunction !== undefined) {
        const run = nativeVM.resolveExport(meta.runExportedFunction);
        assert.equal(run.type, Native.vm_TeType.VM_T_FUNCTION);
        nativeVM.call(run, []);

        fs.writeFileSync(path.resolve(testArtifactDir, '4.native-post-run.print.txt'), nativePrintLog.join('\n'));
        if (meta.expectedPrintout !== undefined) {
          assertSameCode(nativePrintLog.join('\n'), meta.expectedPrintout);
        }
      }

      function printNative(_object: Native.Value, args: Native.Value[]): Native.Value {
        if (args.length < 1) return invalidOperation('Invalid number of arguments to `print`');
        const messageArg = args[0];
        if (messageArg.type !== Native.vm_TeType.VM_T_STRING) return invalidOperation('Expected first argument to `print` to be a string');
        const message = messageArg.asString();
        nativePrintLog.push(message);
        return nativeVM.undefined;
      }
    });

    // TODO: Test native garbage collection
  }
});
