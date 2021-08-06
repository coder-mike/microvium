import { srcToIlFilenames } from '../test/src-to-il/filenames';
import { virtualMachineTestFilenames } from '../test/virtual-machine/filenames';
import { binaryRegionFilenames } from './binary-region/filenames';
import { decodeSnapshotTestFilenames } from './decode-snapshot/filenames';
import { tests as scopeAnalysisTests } from './scope-analysis/tests';

export const testFilenames = {
  'src-to-il': srcToIlFilenames,
  'virtual-machine': virtualMachineTestFilenames,
  'binary-region': binaryRegionFilenames,
  'decode-snapshot': decodeSnapshotTestFilenames,
  'scope-analysis': scopeAnalysisTests.filenames
};