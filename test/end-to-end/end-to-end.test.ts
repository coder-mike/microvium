import glob from 'glob';
import * as path from 'path';
import fs from 'fs-extra';
import { createVirtualMachine } from '../../lib/virtual-machine-proxy';
import { snapshotToBytecode, stringifySnapshot } from '../../lib/snapshot';
import { htmlTemplate as htmlPageTemplate } from '../../lib/general';

const testDir = './test/end-to-end/tests';
const rootArtifactDir = './test/end-to-end/artifacts';
const testFiles = glob.sync(testDir + '/**/*.test.mvms');

suite('end-to-end', function () {
  for (let filename of testFiles) {
    const testFilenameFull = path.resolve(filename);
    const testFilenameRelativeToTestDir = path.relative(testDir, testFilenameFull);
    const testFilenameRelativeToCurDir = './' + path.relative(process.cwd(), testFilenameFull).replace(/\\/g, '/');
    const testFriendlyName = testFilenameRelativeToTestDir.slice(0, -10);
    const testArtifactDir = path.resolve(rootArtifactDir, testFilenameRelativeToTestDir.slice(0, -10));
    fs.ensureDirSync(testArtifactDir);

    test(testFriendlyName, () => {
      const src = fs.readFileSync(testFilenameRelativeToCurDir, 'utf8')
      const vm = createVirtualMachine({
        print: () => {} // TODO
      });
      vm.importModuleSourceText(src, path.basename(testFilenameRelativeToCurDir));

      const snapshot = vm.createSnapshot();

      fs.writeFileSync(path.resolve(testArtifactDir, '1.post-load.snapshot'), stringifySnapshot(snapshot), null);

      const { bytecode, html } = snapshotToBytecode(snapshot, true);

      fs.writeFileSync(path.resolve(testArtifactDir, '2.post-load.mvm-bc'), bytecode, null);
      fs.writeFileSync(path.resolve(testArtifactDir, '2.post-load.mvm-bc.html'), htmlPageTemplate(html!), null);
    });
  }
});
