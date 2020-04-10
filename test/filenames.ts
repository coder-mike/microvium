import { srcToIlFilenames } from '../test/src-to-il/filenames';
import { virtualMachineFilenames } from '../test/virtual-machine/filenames';
import { visualBufferFilenames } from '../test/visual-buffer/filenames';
import { binaryRegionFilenames } from './binary-region/filenames';

export const testFilenames = {
  'src-to-il': srcToIlFilenames,
  'virtual-machine': virtualMachineFilenames,
  'visual-buffer': visualBufferFilenames,
  'binary-region': binaryRegionFilenames,
};