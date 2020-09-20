import { hardAssert, invalidOperation, unexpected, stringifyStringLiteral } from "./utils";
import { VisualBuffer, Format, BinaryData, HTML, HTMLFormat, BinaryFormat, VisualBufferHTMLContainer } from "./visual-buffer";
import { EventEmitter } from "events";
import { TraceFile } from "./trace-file";
import { htmlPageTemplate } from "./general";
import { tableRow } from "./snapshot-binary-html-formats";

export type FutureLike<T> = T | Future<T>;

// A class roughly like VisualBuffer for writing buffers, except that you are
// able to write placeholder values that will only get their final value later
// (`Future` values)
export class BinaryRegion {
  private _segments = new Array<Segment>();
  private _traceFile: TraceFile | undefined;

  constructor (private htmlTemplate?: VisualBufferHTMLContainer, traceFilename?: string) {
    this._traceFile = traceFilename !== undefined ? new TraceFile(traceFilename) : undefined;
    this.traceDump();
  }

  public append<T>(value: FutureLike<T>, label: string | undefined, format: Format<Labelled<T | undefined>>) {
    if (value instanceof Future) {
      this.appendFuture(value, label, format);
    } else {
      this.appendDirect(value, label, format);
    }
  }

  // Add padding to an even boundary
  public padToEven(format: Format<Labelled<number | undefined>>) {
    this.appendSegment(b => {
      if (b.writeOffset % 2 !== 0) {
        const count = 1;
        b.append<Labelled<number | undefined>>({ value: count }, format);
      }
    });
  }

  public appendBuffer(buffer: BinaryRegion, label?: string) {
    hardAssert(buffer instanceof BinaryRegion);
    this.appendSegment(buffer.writeToBuffer);
  }

  public toBuffer(enforceFinalized: boolean = true): Buffer {
    return this.toVisualBuffer(enforceFinalized).toBuffer();
  }

  public toHTML(): HTML {
    return this.toVisualBuffer(false).toHTML();
  }

  public get currentOffset(): Future<number> {
    const address = new Future<number>();
    this.appendSegment(b => {
      if (address.isResolved) address.unresolve();
      address.resolve(b.writeOffset);
      return () => address.unresolve()
    });
    return address;
  }

  // Post processing is for things like CRC values. Post processing steps only
  // get evaluated at the end.
  public postProcess<T>(start: Future<number>, end: Future<number>, process: (buffer: Buffer) => T): Future<T> {
    const result = new Future<T>();
    // Insert a segment just to hook into the "cleanup" phase at the end, which
    // is where the post processing will be done.
    this.appendSegment(buffer => {
      const cleanup: CleanupFunction = enforceFinalized => {
        if (!start.isResolved || !end.isResolved) {
          if (enforceFinalized) {
            throw new Error('Post processing cannot be done with unresolved range');
          }
          return;
        }
        const data = buffer.toBuffer().slice(start.value, end.value);
        result.resolve(process(data));
        // Since we're in the cleanup phase, we need to unresolve immediately.
        // This is valid since post-processing occurs after all appends to the
        // buffer, so there is no "future" beyond this point at which the result
        // may still be used.
        result.unresolve();
      };
      return cleanup;
    });

    return result;
  }

  private appendSegment(item: Segment) {
    this._segments.push(item);
    this.traceDump();
  }

  private traceDump() {
    this._traceFile && this._traceFile.dump(() => htmlPageTemplate(this.toHTML()))
  }

  private appendDirect<T>(value: T, label: string | undefined, format: Format<Labelled<T | undefined>>) {
    const labelledValue: Labelled<T> = { value, label };
    this.appendSegment((b => (b.append(labelledValue, format), noCleanupRequired)));
  }

  private appendFuture<T>(value: Future<T>, label: string | undefined, format: Format<Labelled<T | undefined>>) {
    this.appendSegment((buffer: VisualBuffer) => {
      // If it's already resolved, we can just write the value itself
      if (value.isResolved) {
        buffer.append({ value: value.value, label }, format);
        return noCleanupRequired;
      } else {
        // If it's not yet resolved, then we write a placeholder and then
        // subscribe to be notified when we have the final value, so we can
        // overwrite the placeholder with the actual value.

        // The placeholder renders with a value of "undefined" but still has the label
        const bufferOnWhichToOverwrite = buffer;
        const whereToOverwrite = buffer.writeOffset;
        let isWriteFinalized = false;
        buffer.append({ value: undefined, label }, format);
        value.once('resolve', resolve);

        return cleanup;

        function resolve(value: T) {
          hardAssert(!isWriteFinalized);
          isWriteFinalized = true;
          bufferOnWhichToOverwrite.overwrite({ value, label }, format, whereToOverwrite);
        }

        function cleanup(checkFinalized: boolean) {
          // Cleanup is called after a buffer is produced. We need to unsubscribe
          // from the source value because otherwise we'll mutate this buffer on
          // future calls to `toBuffer`
          value.off('resolve', resolve);
          if (checkFinalized && !isWriteFinalized) {
            return invalidOperation('Expected future value to be resolved, but it is not.');
          }
        }
      }
    });
  }

  private writeToBuffer = (buffer: VisualBuffer): CleanupFunction => {
    const cleanups = this._segments.map(segment => segment(buffer));

    const cleanup: CleanupFunction = checkFinalized => {
      cleanups.forEach(cleanup => cleanup && cleanup(checkFinalized));
    };

    return cleanup;
  }

  private toVisualBuffer(enforceFinalized: boolean): VisualBuffer {
    const buffer = new VisualBuffer(this.htmlTemplate);
    const cleanup = this.writeToBuffer(buffer);
    cleanup(enforceFinalized);
    return buffer;
  }
}

// A segment is something that can be written to a buffer and will give back a
// cleanup function to release any pending subscriptions
type Segment = (b: VisualBuffer) => CleanupFunction | void;
type CleanupFunction = (checkFinalized: boolean) => void;
const noCleanupRequired: CleanupFunction = () => {};

// Value to be calculated later
export class Future<T = number> extends EventEmitter {
  private _value: T;
  private _resolved: boolean = false;
  private _assigned = false;

  constructor() {
    super();
    this.setMaxListeners(100);
  }

  assign(value: FutureLike<T>) {
    if (this._assigned) {
      return invalidOperation('Cannot assign multiple times');
    }
    if (this._resolved) {
      return invalidOperation('Future has already been resolved');
    }
    this._assigned = true;
    if (value instanceof Future) {
      value.on('resolve', v => this.resolve(v));
      value.on('unresolve', () => this.unresolve());
      if (value.isResolved) this.resolve(value.value);
      else this.unresolve();
    } else {
      this.resolve(value);
    }
  }

  map<U>(f: (v: T) => U): Future<U> {
    const result = new Future<U>();
    if (this.isResolved) {
      result.resolve(f(this.value));
    }
    this.on('resolve', v => result.resolve(f(v)));
    this.on('unresolve', () => result.unresolve());
    return result;
  }


  bind<U>(f: (v: T) => Future<U>): Future<U> {
    let state: 'not-resolved' | 'outer-resolved' | 'resolved' = 'not-resolved';

    const result = new Future<U>();
    let inner: Future<U> | undefined;

    this.on('resolve', outerResolve);
    this.on('unresolve', outerUnresolve);

    if (this.isResolved) {
      outerResolve(this.value);
    }

    return result;

    function outerResolve(value: T) {
      if (state !== 'not-resolved') return unexpected();
      inner = f(value);
      inner.on('resolve', innerResolve);
      inner.on('unresolve', innerUnresolve);
      if (inner.isResolved) {
        state = 'resolved';
        result.resolve(inner.value);
      } else {
        state = 'outer-resolved';
      }
    }

    function outerUnresolve() {
      if (state === 'not-resolved') return unexpected();
      if (!inner) return unexpected();
      inner.off('resolve', innerResolve);
      inner.off('unresolve', innerUnresolve);
      inner = undefined;
      if (state === 'resolved') {
        result.unresolve();
      }
      state = 'not-resolved';
    }

    function innerResolve(value: U) {
      if (state !== 'outer-resolved') return unexpected();
      state = 'resolved';
      result.resolve(value);
    }

    function innerUnresolve() {
      if (state !== 'resolved') return unexpected();
      state = 'outer-resolved';
      result.unresolve();
    }
  }

  subtract(this: Future<number>, that: Future<number>): Future<number> {
    return this.bind(a => that.map(b => a - b));
  }

  static create<T>(value: FutureLike<T>): Future<T> {
    if (value instanceof Future) return value;
    const result = new Future<T>();
    result.resolve(value);
    return result;
  }

  static isFuture<T>(value: FutureLike<T>): value is Future<T> {
    return value instanceof Future;
  }

  static map<T, U>(value: FutureLike<T>, f: (v: T) => U): FutureLike<U> {
    if (Future.isFuture(value)) return value.map(f);
    else return f(value);
  }

  static bind<T, U>(value: FutureLike<T>, f: (v: T) => FutureLike<U>): FutureLike<U> {
    if (Future.isFuture(value)) {
      return value.bind<U>(v => Future.create(f(v)));
    }
    else return f(value);
  }

  static lift<T, U>(operation: (v: T) => U): (v: FutureLike<T>) => FutureLike<U> {
    return (v: FutureLike<T>) => Future.bind(v, operation);
  }

  get isResolved() { return this._resolved; }

  get value() {
    if (!this._resolved) {
      return invalidOperation('Value not resolved');
    }
    return this._value;
  }

  resolve(value: T) {
    if (this._resolved) {
      this.unresolve();
    }
    this._value = value;
    this._resolved = true;
    this.emit('resolve', value);
  }

  unresolve() {
    if (!this._resolved) return;
    this._value = undefined as any;
    this._resolved = false;
    this.emit('unresolve');
  }
}

export interface Labelled<T> {
  label?: string;
  value: T;
}