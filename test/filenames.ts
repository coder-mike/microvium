import { srcToIlFilenames } from '../test/src-to-il/filenames';
import { virtualMachineTestFilenames } from '../test/virtual-machine/filenames';
import { binaryRegionFilenames } from './binary-region/filenames';

export const testFilenames = {
  'src-to-il': srcToIlFilenames,
  'virtual-machine': virtualMachineTestFilenames,
  'binary-region': binaryRegionFilenames,
};