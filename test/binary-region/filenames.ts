import { TestFilenames } from "../common";

export const binaryRegionFilenames = {
  empty: {
    binary: {
      output: './test/binary-region/output.empty.bin',
      expected: './test/binary-region/expected.empty.bin',
    },
    html: {
      output: './test/binary-region/output.empty.html',
      expected: './test/binary-region/expected.empty.html',
    }
  },
  basic: {
    binary: {
      output: './test/binary-region/output.basic.bin',
      expected: './test/binary-region/expected.basic.bin',
    },
    html: {
      output: './test/binary-region/output.basic.html',
      expected: './test/binary-region/expected.basic.html',
    },
  },
  futures: {
    binary: {
      output: './test/binary-region/output.futures.bin',
      expected: './test/binary-region/expected.futures.bin',
    },
    html: {
      output: './test/binary-region/output.futures.html',
      expected: './test/binary-region/expected.futures.html',
    },
  },
};