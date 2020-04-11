import { assert, invalidOperation, unexpected, stringifyStringLiteral } from "./utils";
import { VisualBuffer, Format, BinaryData, tableRow, HTML, HTMLFormat, VisualBufferHTMLContainer, BinaryFormat, binaryFormats } from "./visual-buffer";
import { EventEmitter } from "events";
import { TraceFile } from "./trace-file";
import { htmlTemplate } from "./general";
import escapeHTML from "escape-html";

export type FutureLike<T> = T | Future<T>;

// A class roughly like VisualBuffer for writing buffers, except that you are
// able to write placeholder values that will only get their final value later
// (`Future` values)
export class BinaryRegion3 {
  private _segments = new Array<Segment>();
  private _traceFile: TraceFile | undefined;

  constructor (traceFilename?: string) {
    this._traceFile = traceFilename !== undefined ? new TraceFile(traceFilename) : undefined;
    this.traceDump();
  }

  public writeInt8(value: FutureLike<number>, debugLabel?: string) {
    this.append(value, debugLabel, formats.sInt8);
  }

  public writeUInt8(value: FutureLike<number>, debugLabel?: string) {
    this.append(value, debugLabel, formats.uInt8);
  }

  public writeUInt16LE(value: FutureLike<number>, debugLabel?: string) {
    this.append(value, debugLabel, formats.uInt16LE);
  }

  public writeInt16LE(value: FutureLike<number>, debugLabel?: string) {
    this.append(value, debugLabel, formats.sInt16LE);
  }

  public writeDoubleLE(value: FutureLike<number>, debugLabel?: string) {
    this.append(value, debugLabel, formats.doubleLE);
  }

  public writeInt32LE(value: FutureLike<number>, debugLabel?: string) {
    this.append(value, debugLabel, formats.sInt32LE);
  }

  public writeUInt32LE(value: FutureLike<number>, debugLabel?: string) {
    this.append(value, debugLabel, formats.uInt32LE);
  }

  public writeStringUtf8NT(value: string, label?: string) {
    this.appendDirect<string>(value, label, formats.stringUtf8NT);
  }

  public append<T>(value: FutureLike<T>, label: string | undefined, format: Format<Labelled<T | undefined>>) {
    if (value instanceof Future) {
      this.appendFuture(value, label, format);
    } else {
      this.appendDirect(value, label, format);
    }
  }

  public appendBuffer(buffer: Buffer | BinaryRegion3, label?: string) {
    if (Buffer.isBuffer(buffer)) {
      this.appendDirect<Buffer>(buffer, label, formats.buffer);
    } else {
      assert(buffer instanceof BinaryRegion3);
      this.appendSegment(buffer.writeToBuffer);
    }
  }

  public toBuffer(enforceFinalized: boolean = true): Buffer {
    return this.toVisualBuffer(enforceFinalized).toBuffer();
  }

  public toHTML(): HTML {
    return this.toVisualBuffer(false).toHTML();
  }

  public get currentAddress(): Future<number> {
    const address = new Future<number>();
    this.appendSegment(b => {
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
    this._traceFile && this._traceFile.dump(() => htmlTemplate(this.toHTML()))
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
          assert(!isWriteFinalized);
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
      cleanups.forEach(cleanup => cleanup(checkFinalized));
    };

    return cleanup;
  }

  private toVisualBuffer(enforceFinalized: boolean): VisualBuffer {
    const buffer = new VisualBuffer();
    const cleanup = this.writeToBuffer(buffer);
    cleanup(enforceFinalized);
    return buffer;
  }
}

// A segment is something that can be written to a buffer and will give back a
// cleanup function to release any pending subscriptions
type Segment = (b: VisualBuffer) => CleanupFunction;
type CleanupFunction = (checkFinalized: boolean) => void;
const noCleanupRequired: CleanupFunction = () => {};

// Value to be calculated later
export class Future<T = number> extends EventEmitter {
  private _value: T;
  private _resolved: boolean = false;

  assign(value: FutureLike<T>) {
    if (value instanceof Future) {
      value.on('resolve', v => this.resolve(v));
      value.on('unresolve', v => this.unresolve());
    } else {
      this.resolve(value);
    }
  }

  map<U>(f: (v: T) => U): Future<U> {
    const result = new Future<U>();
    this.on('resolve', v => result.resolve(f(v)));
    this.on('unresolve', v => result.unresolve());
    return result;
  }


  bind<U>(f: (v: T) => Future<U>): Future<U> {
    const result = new Future<U>();
    this.on('resolve', v => {
      const v2 = f(v);
      v2.on('resolve', v2 => result.resolve(v2))
      v2.on('unresolve', () => result.unresolve());
    });
    this.on('unresolve', () => result.unresolve());
    return result;
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
      return invalidOperation('Cannot resolve a future multiple times in the same context')
    }
    this._value = value;
    this._resolved = true;
    this.emit('resolve', value);
  }

  unresolve() {
    this._value = undefined as any;
    this._resolved = false;
    this.emit('unresolve');
  }
}

const nestedVisualBufferFormat: Format<VisualBuffer> = {
  binaryFormat: b => BinaryData([...b.toBuffer()]),
  htmlFormat: tableRow<VisualBuffer>(b => b.toHTML())
};

function format<T>(binaryFormat: BinaryFormat<T>, htmlFormat: (v: T) => string, sizeBytes: number): Format<Labelled<undefined | T>> {
  const placeholderData = zeros(sizeBytes);
  return {
    binaryFormat: value =>
      value.value === undefined ? placeholderData : binaryFormat(value.value),
    htmlFormat: (value: Labelled<undefined | T>, binary, offset) =>
      value.value === undefined
        ? placeholderRow(value, binary, offset)
        : tableRow<T>(v => (value.label ? value.label + ': ' : '') + htmlFormat(v))(value.value, binary, offset)
  }
}

function zeros(length: number): BinaryData {
  const result = [];
  while (length--) {
    result.push(0);
  }
  return result;
}

const placeholderRow: HTMLFormat<any> = (_value, binary, offset) => {
  const addressID = `address${offset.toString(16).padStart(4, '0').toUpperCase()}`;
  return `
    <tr>
      <td class="address">
        <a class="address-text" id="${addressID}" href="#${addressID}">
          ${offset.toString(16).padStart(4, '0').toUpperCase()}
        </a>
      </td>
      <td class="data">
        ${binary
          .map(() => `<span class="byte pending"></span>`)
          .join('<wbr>')}
      </td>
      <td class="value pending-value">
        Pending
      </td>
    </tr>`
}

const renderInt = (s: number) => s.toFixed(0);
const renderHex = (digits: number) => (value: number) => `0x${value.toString(16).padStart(digits, '0').toUpperCase()}`;
const renderDouble = (value: number) => value.toString();
const renderString = (value: string) => escapeHTML(stringifyStringLiteral(value));
const renderBuffer = (value: Buffer) => value.toString();

export const formats = {
  uHex8: format(binaryFormats.uInt8, renderHex(2), 1),
  uInt8: format(binaryFormats.uInt8, renderInt, 1),
  sInt8: format(binaryFormats.sInt8, renderInt, 1),

  uHex16LE: format(binaryFormats.uInt16LE, renderHex(4), 2),
  uInt16LE: format(binaryFormats.uInt16LE, renderInt, 2),
  sInt16LE: format(binaryFormats.sInt16LE, renderInt, 2),

  uHex32LE: format(binaryFormats.uInt32LE, renderHex(8), 4),
  uInt32LE: format(binaryFormats.uInt32LE, renderInt, 4),
  sInt32LE: format(binaryFormats.sInt32LE, renderInt, 4),

  doubleLE: format(binaryFormats.doubleLE, renderDouble, 8),

  stringUtf8NT: format(binaryFormats.stringUtf8NT, renderString, 1),

  buffer: format(b => BinaryData([...b]), renderBuffer, 1)
}

interface Labelled<T> {
  label?: string;
  value: T;
}