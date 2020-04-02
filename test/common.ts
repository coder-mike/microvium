export interface TestFilenames {
  [key: string]: TestFilenamePair;
};

export interface TestFilenamePair {
  output: string;
  expected: string;
}
