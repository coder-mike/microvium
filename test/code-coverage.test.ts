import { CoverageHitInfos, getCoveragePoints, updateCoverageMarkers } from '../lib/code-coverage-utils';
import { NativeVM, CoverageCaseMode } from '../lib/native-vm';
import { notUndefined, writeTextFile } from '../lib/utils';
import path from 'path';
import fs from 'fs';
import os from 'os';
import colors from 'colors';

const microviumCFilename = './native-vm/microvium.c';
const coverageHits: CoverageHitInfos = {};
let anySkips = false;
let anyFailures = false;
const rootArtifactDir = './test/end-to-end/artifacts';
const coveragePoints = getCoveragePoints(fs.readFileSync(microviumCFilename, 'utf8').split(/\r?\n/g), microviumCFilename);
export const anyGrepSelector = process.argv.some(x => x === '-g' || x === '--grep');

const allTestsFilename = path.join(rootArtifactDir, 'all-tests.json')
const allTests = fs.existsSync(allTestsFilename)
  ? new Set<string>(JSON.parse(fs.readFileSync(allTestsFilename, 'utf8')))
  : new Set<string>()
const remainingTests = new Set([...allTests])

let isFirstSetup = true;

// Note: I couldn't figure out a builtin way of doing a global setup and
// teardown across all tests, so I'm just keeping a list of tests and running
// the global teardown when we've done all of them. This will have issues if we
// delete or rename tests. If that happens, delete the `all-tests.json` output
// file and it will recreate it on the next run.

setup(function () {
  if (isFirstSetup) {
    globalSetup();
    isFirstSetup = false;
  }
})


teardown(function() {
  if (this.currentTest && this.currentTest.isFailed()) {
    anyFailures = true;
  }

  if (this.currentTest) {
    const titlePath = this.currentTest.titlePath().join(' ');
    allTests.add(titlePath)
    if (remainingTests.has(titlePath)) {
      remainingTests.delete(titlePath)
      if (remainingTests.size === 0) {
        globalTeardown()
      }
    } else {
      // Otherwise, there's a change to the set of test cases
      writeTextFile(allTestsFilename, JSON.stringify([...allTests], null, 4))
    }
  }
})

process.on('beforeExit', () => {
  // If there are remaining tests when the process is exiting, it means we haven't run the teardown
  if (remainingTests.size > 0) {
    globalTeardown();
  }
});


function globalSetup() {
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
}

function globalTeardown() {
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

  if (!anyGrepSelector && !anySkips && !anyFailures) {
    const coverageOneLiner = `${coverageHitLocations} of ${coveragePossibleHitLocations} (${(coverageHitLocations / coveragePossibleHitLocations * 100).toFixed(1)}%)`;
    const microviumCFilenameRelative = path.relative(process.cwd(), microviumCFilename);
    writeTextFile(path.resolve(rootArtifactDir, 'code-coverage-details.json'), JSON.stringify(coverageHits));
    const summaryLines = [`microvium.c code coverage: ${coverageOneLiner}`];
    writeTextFile(summaryPath, summaryLines.join(os.EOL));

    const expectedButNotHit = coveragePoints
      .filter(p => (p.type === 'normal') && !coverageHits[p.id]);
    updateCoverageMarkers(true, !anySkips && !anyFailures && !anyGrepSelector);
    if (expectedButNotHit.length) {
      throw new Error('The following coverage points were expected but not hit in the tests\n' +
        expectedButNotHit
          .map(p => `      at ${microviumCFilenameRelative}:${p.lineI + 1} ID(${p.id})`)
          .join('\n  '))
    }
    console.log(`\n  ${colors.green('√')} ${colors.gray('microvium.c code coverage: ')}${coverageOneLiner}`);
  }
}