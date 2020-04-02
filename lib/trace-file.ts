/*
A TraceFile is used for debug output. Writes to the file are batched for
efficiency, but if the global `TraceFile.flushAll` _property_ is accessed, the
getter performs a flush synchronously.

To use this module as intended, add `TraceFile.flushAll` as a watch in the
debugger. Then any time the debugger steps or hits a breakpoint, the contents of
all the TraceFiles will be flushed to disk (e.g. to be visible in the IDE if
they're open).
*/
import * as fs from 'fs';
import * as path from 'path';

export type LazyString = (...state: any[]) => string;

export class TraceFile {
  static all = new Set<TraceFile>();
  private buffer = new Array<string>();
  private filename: string;
  private nextFlushThreshold: number;
  private dumpContent?: LazyString;
  private globalConstructor: any;

  // Hint: add `TraceFile.flushAll` to the debug watch list to automatically flush on breakpoints
  public static get flushAll() {
    for (const file of TraceFile.all) {
      file.flush();
    }
    return new Date().toString();
  }

  constructor(
    filename: string,
    private automaticFlushDelayMs: number = 1000
  ) {
    // Keeping track of the global constructor because if this module is
    // included multiple times then we need to make sure all instances share the
    // same TraceFile "all" set, and that we remove ourselves (in dispose) from
    // the correct instance.
    this.globalConstructor = (globalThis as any).TraceFile;
    this.globalConstructor.all.add(this);

    this.filename = path.resolve(filename);
    // Wipe file
    fs.writeFileSync(this.filename, '');
    this.nextFlushThreshold = Date.now() + this.automaticFlushDelayMs;
  }

  dispose() {
    this.flush();
    this.globalConstructor.all.delete(this);
  }

  // Hint: add `TraceFile.flushAll` to the debug watch list to automatically flush on breakpoints
  flush() {
    if (!this.dumpContent && this.buffer.length === 0) {
      return;
    }
    let toFlush = this.buffer;
    this.buffer = [];
    if (this.dumpContent) {
      toFlush.unshift(this.dumpContent());
      this.dumpContent = undefined;
      fs.writeFileSync(this.filename, toFlush.join(''));
    } else {
      fs.appendFileSync(this.filename, toFlush.join(''));
    }
    this.nextFlushThreshold = Date.now() + 1000;
  }

  private checkFlush() {
    if (Date.now() >= this.nextFlushThreshold) {
      this.flush();
    }
  }

  // Hint: add `TraceFile.flushAll` to the debug watch list to automatically flush on breakpoints
  // (Accessible as an instance method because the class name may be inaccessible to the watch list in some contexts)
  get flushAll() {
    return TraceFile.flushAll;
  }

  // Append content to the file
  write(content: string): void {
    this.buffer.push(content);
    this.checkFlush();
  }

  // Append a line of content to the file
  writeLine(line: string) {
    this.write(line + '\n');
  }

  // Wipes the file and replaces its content with `content`.
  // Note: the callback will only be invoked at the time that it flushes. This
  // is to improve efficiency when you need to logically dump at high frequency
  // but only need it to show up when you hit a breakpoint (or occasionally).
  dump(content: string | LazyString, ...state: any[]) {
    if (typeof content === 'string') {
      const str = content;
      content = () => str;
    }
    if (state.length > 0) {
      const inner = content;
      content = () => inner(...state);
    }
    this.buffer = [];
    this.dumpContent = content;
    this.checkFlush();
  }
}

(globalThis as any).TraceFile = TraceFile;
