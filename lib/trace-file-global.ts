declare module NodeJS {
  class TraceFile {
    static readonly dumpAll: string;
  }
  interface Global {
    TraceFile: TraceFile;
  }
}