import glob from 'glob';
import * as path from 'path';
import os from 'os';
import fs from 'fs-extra';
import * as IL from '../../lib/il';
import { VirtualMachineFriendly } from '../../lib/virtual-machine-friendly';
import { stringifySnapshotIL } from '../../lib/snapshot-il';
import { htmlPageTemplate } from '../../lib/general';
import YAML from 'yaml';
import { Microvium, HostImportTable } from '../../lib';
import { assertSameCode } from '../common';
import { assert } from 'chai';
import { NativeVM, CoverageCaseMode } from '../../lib/native-vm';
import colors from 'colors';
import { getCoveragePoints, updateCoverageMarkers, CoverageHitInfos } from '../../lib/code-coverage-utils';
import { notUndefined, writeTextFile } from '../../lib/utils';
import { encodeSnapshot } from '../../lib/encode-snapshot';
import { decodeSnapshot } from '../../lib/decode-snapshot';

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
  skipNative?: boolean;
  assertionCount?: number; // Expected assertion count for each call of the runExportedFunction function
}

const microviumCFilename = './native-vm/microvium.c';
const coveragePoints = getCoveragePoints(fs.readFileSync(microviumCFilename, 'utf8').split(/\r?\n/g), microviumCFilename);

suite('end-to-end', function () {
  let anySkips = false;
  let anyFailures = false;

  const coverageHits: CoverageHitInfos = {};

  this.beforeAll(() => {
    NativeVM.setCoverageCallback((id, mode, indexInTable, tableSize, line) => {
      let hitInfo = coverageHits[id];
      if (!hitInfo) {
        hitInfo = { lineHitCount: 0 };
        if (mode === CoverageCaseMode.TABLE) {
          hitInfo.hitCountByTableEntry = {};
          hitInfo.tableSize = tableSize;
        }
        coverageHits[id] = hitInfo;
      }
      hitInfo.lineHitCount++;
      if (mode === CoverageCaseMode.TABLE) {
        const tableHitCount = notUndefined(hitInfo.hitCountByTableEntry);
        tableHitCount[indexInTable] = (tableHitCount[indexInTable] || 0) + 1;
      }
    });
  })

  this.afterEach(function() {
    if (this.currentTest && this.currentTest.isFailed()) {
      anyFailures = true;
    }
  })

  this.afterAll(function() {
    NativeVM.setCoverageCallback(undefined);

    const summaryPath = path.resolve(rootArtifactDir, 'code-coverage-summary.txt');

    let coverageHitLocations = 0;
    let coveragePossibleHitLocations = 0;
    for (const c of coveragePoints) {
      const hitInfo = coverageHits[c.id];
      if (!hitInfo) {
        coveragePossibleHitLocations++;
      } else {
        if (hitInfo.tableSize !== undefined) {
          coveragePossibleHitLocations += hitInfo.tableSize;
        } else {
          coveragePossibleHitLocations++;
        }
        if (hitInfo.hitCountByTableEntry !== undefined) {
          const numberOfItemsInTableThatWereHit = Object.keys(hitInfo.hitCountByTableEntry).length;
          coverageHitLocations += numberOfItemsInTableThatWereHit;
        } else {
          // Else we just say that the line was hit
          coverageHitLocations++;
        }
      }
    }
    const coverageOneLiner = `${coverageHitLocations} of ${coveragePossibleHitLocations} (${(coverageHitLocations / coveragePossibleHitLocations * 100).toFixed(1)}%)`;
    const microviumCFilenameRelative = path.relative(process.cwd(), microviumCFilename);
    writeTextFile(path.resolve(rootArtifactDir, 'code-coverage-details.json'), JSON.stringify(coverageHits));
    const summaryLines = [`microvium.c code coverage: ${coverageOneLiner}`];
    writeTextFile(summaryPath, summaryLines.join(os.EOL));
    const expectedButNotHit = coveragePoints
      .filter(p => (p.type === 'normal') && !coverageHits[p.id]);
    updateCoverageMarkers(true, !anySkips && !anyFailures);
    if (!anySkips && !anyFailures && expectedButNotHit.length) {
      throw new Error('The following coverage points were expected but not hit in the tests\n' +
        expectedButNotHit
          .map(p => `      at ${microviumCFilenameRelative}:${p.lineI + 1} ID(${p.id})`)
          .join('\n  '))
    }
    console.log(`    ${colors.green('√')} ${colors.gray('end-to-end microvium.c code coverage: ')}${coverageOneLiner}`);
  });

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

    anySkips = anySkips || !!meta.skip || !!meta.skipNative || !!meta.testOnly;

    (meta.skip ? test.skip : meta.testOnly ? test.only : test)(testFriendlyName, () => {
      // console.log(testFriendlyName)
      fs.emptyDirSync(testArtifactDir);
      writeTextFile(path.resolve(testArtifactDir, '0.meta.yaml'), yamlText || '');

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
          throw new Error(`Expected ${b} to equal ${a}`);
        }
      }

      const importMap: HostImportTable = {
        [HOST_FUNCTION_PRINT_ID]: print,
        [HOST_FUNCTION_ASSERT_ID]: vmAssert,
        [HOST_FUNCTION_ASSERT_EQUAL_ID]: vmAssertEqual
      };

      // ----------------------- Create Comprehensive VM ----------------------

      const comprehensiveVM = VirtualMachineFriendly.create(importMap, {
        // Match behavior of NativeVM for overflow checking. This allows us to
        // compile with either overflow checks enabled or not and have
        // consistent results from the tests.
        overflowChecks: NativeVM.MVM_PORT_INT32_OVERFLOW_CHECKS
      });
      const vmGlobal = comprehensiveVM.globalThis;
      vmGlobal.print = comprehensiveVM.importHostFunction(HOST_FUNCTION_PRINT_ID);
      vmGlobal.assert = comprehensiveVM.importHostFunction(HOST_FUNCTION_ASSERT_ID);
      vmGlobal.assertEqual = comprehensiveVM.importHostFunction(HOST_FUNCTION_ASSERT_EQUAL_ID);
      vmGlobal.vmExport = vmExport;
      vmGlobal.overflowChecks = NativeVM.MVM_PORT_INT32_OVERFLOW_CHECKS;
      const vmConsole = vmGlobal.console = comprehensiveVM.newObject();
      vmConsole.log = vmGlobal.print; // Alternative way of accessing the print function


      // ----------------------------- Load Source ----------------------------

      // TODO: Nested import
      comprehensiveVM.evaluateModule({ sourceText: src, debugFilename: testFilenameRelativeToCurDir });

      const postLoadSnapshotInfo = comprehensiveVM.createSnapshotIL();
      writeTextFile(path.resolve(testArtifactDir, '1.post-load.snapshot'), stringifySnapshotIL(postLoadSnapshotInfo));
      const { snapshot: postLoadSnapshot, html: postLoadHTML } = encodeSnapshot(postLoadSnapshotInfo, true);
      fs.writeFileSync(path.resolve(testArtifactDir, '1.post-load.mvm-bc'), postLoadSnapshot.data, null);
      writeTextFile(path.resolve(testArtifactDir, '1.post-load.mvm-bc.html'), htmlPageTemplate(postLoadHTML!));
      const decoded = decodeSnapshot(postLoadSnapshot);
      writeTextFile(path.resolve(testArtifactDir, '1.post-load.mvm-bc.disassembly'), decoded.disassembly);
      assertSameCode(
        stringifySnapshotIL(decoded.snapshotInfo),
        stringifySnapshotIL(postLoadSnapshotInfo, { comments: false, cullUnreachableBlocks: true }));

      // ---------------------------- Run Function ----------------------------

      if (meta.runExportedFunction !== undefined) {
        const functionToRun = comprehensiveVM.resolveExport(meta.runExportedFunction);
        assertionCount = 0;
        functionToRun();
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
          run();
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
    });
  }
});
