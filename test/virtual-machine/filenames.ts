import { TestFilenames } from "../common";

export const virtualMachineTestFilenames = {
  ['hello-world']: {
    bytecode: {
      output: './test/virtual-machine/output/hello-world.bin',
      expected: './test/virtual-machine/expected/hello-world.bin',
    },
    snapshot: {
      output: './test/virtual-machine/output/hello-world.snapshot',
      expected: './test/virtual-machine/expected/hello-world.snapshot',
    },
    html: {
      output: './test/virtual-machine/output/hello-world.html',
      expected: './test/virtual-machine/expected/hello-world.html',
    }
  },
  ['addition']: {
    bytecode: {
      output: './test/virtual-machine/output/addition.bin',
      expected: './test/virtual-machine/expected/addition.bin',
    },
    snapshot: {
      output: './test/virtual-machine/output/addition.snapshot',
      expected: './test/virtual-machine/expected/addition.snapshot',
    },
    html: {
      output: './test/virtual-machine/output/addition.html',
      expected: './test/virtual-machine/expected/addition.html',
    }
  },
  ['simple-branching']: {
    bytecode: {
      output: './test/virtual-machine/output/simple-branching.bin',
      expected: './test/virtual-machine/expected/simple-branching.bin',
    },
    snapshot: {
      output: './test/virtual-machine/output/simple-branching.snapshot',
      expected: './test/virtual-machine/expected/simple-branching.snapshot',
    },
    html: {
      output: './test/virtual-machine/output/simple-branching.html',
      expected: './test/virtual-machine/expected/simple-branching.html',
    }
  },
};