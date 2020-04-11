import { assert, invalidOperation, unexpected } from "./utils";
import { VisualBuffer, Format, formats, BinaryData, tableRow, HTML, HTMLFormat } from "./visual-buffer";
import { EventEmitter } from "events";
import { TraceFile } from "./trace-file";
import { htmlTemplate } from "./general";

export type FutureLike<T> = T | Future<T>;

// A class roughly like VisualBuffer for writing buffers, except that you can
// write values that will only be finalized later
export class BinaryRegion3 {
  private _postProcessing = new Array<{
    start: Future<number>,
    end: Future<number>,
    process: (buffer: Buffer) => any,
    result: Future<any>
  }>();
  private _data = new Array<DirectWrite<any> | FutureWrite<any> | Marker | BinaryRegion3>();
  private _traceFile: TraceFile | undefined;

  constructor (traceFilename?: string) {
    this._traceFile = traceFilename !== undefined ? new TraceFile(traceFilename) : undefined;
    this.traceDump();
  }

  private push(item: DirectWrite<any> | FutureWrite<any> | Marker | BinaryRegion3) {
    this._data.push(item);
    this.traceDump();
  }

  private traceDump() {
    this._traceFile && this._traceFile.dump(() => htmlTemplate(this.toHTML()))
  }

  writeInt8(value: FutureLike<number>) {
    this.append(value, futurableFormats.sInt8);
  }

  writeUInt8(value: FutureLike<number>) {
    this.append(value, futurableFormats.uInt8);
  }

  writeUInt16LE(value: FutureLike<number>) {
    this.append(value, futurableFormats.uInt16LE);
  }

  writeInt16LE(value: FutureLike<number>) {
    this.append(value, futurableFormats.sInt16LE);
  }

  writeDoubleLE(value: FutureLike<number>) {
    this.append(value, futurableFormats.doubleLE);
  }

  writeInt32LE(value: FutureLike<number>) {
    this.append(value, futurableFormats.sInt32LE);
  }

  writeUInt32LE(value: FutureLike<number>) {
    this.append(value, futurableFormats.uInt32LE);
  }

  writeStringUtf8NT(value: string) {
    this.push(new DirectWrite(value, formats.stringUtf8NT));
  }

  private append<T>(value: FutureLike<T>, format: Format<T | undefined>) {
    if (value instanceof Future) {
      const futureWrite = new FutureWrite(value, format);
      this.push(futureWrite);
    } else {
      this.push(new DirectWrite(value, format))
    }
  }

  writeBuffer(buffer: Buffer | BinaryRegion3) {
    if (Buffer.isBuffer(buffer)) {
      this.push(new DirectWrite(buffer, genericBufferFormat));
    } else {
      assert(buffer instanceof BinaryRegion3);
      this.push(buffer);
    }
  }

  postProcess<T>(start: Future<number>, end: Future<number>, process: (buffer: Buffer) => T): Future<T> {
    const result = new Future<T>();
    this._postProcessing.push({
      start, end, process, result
    })
    return result;
  }

  get currentAddress(): Future<number> {
    const marker = new Marker();
    this.push(marker);
    return marker.position;
  }

  private writeToBuffer(buffer: VisualBuffer, futureWrites: FutureWrite<any>[]) {
    for (const d of this._data) {
      if (d instanceof DirectWrite) {
        buffer.append(d.value, d.format);
      } else if (d instanceof Marker) {
        d.position.resolve(buffer.writeOffset);
      } else if (d instanceof BinaryRegion3) {
        d.writeToBuffer(buffer, futureWrites);
      } else if (d instanceof FutureWrite) {
        d.write(buffer);
      } else {
        throw new Error('Unexpected');
      }
    }
  }

  toVisualBuffer(enforceFinalized: boolean): VisualBuffer {
    const futureWrites: FutureWrite<any>[] = [];
    const buffer = new VisualBuffer();

    this.writeToBuffer(buffer, futureWrites);

    if (enforceFinalized && futureWrites.some(d => d.state.type !== 'unused')) {
      throw new Error('Not all future writes were finalized');
    }

    for (const postProcessingStep of this._postProcessing) {
      if (!postProcessingStep.start.isResolved || !postProcessingStep.end.isResolved) {
        if (enforceFinalized) {
          throw new Error('Post processing cannot be done with unresolved range');
        }
        continue;
      }
      const start = postProcessingStep.start.value;
      const end = postProcessingStep.start.value;
      const data = buffer.toBuffer().slice(start, end);
      const result = postProcessingStep.process(data);
      postProcessingStep.result.resolve(result);
    }

    // Clean up
    for (const item of this._data) {
      if (item instanceof Marker) {
        item.position.unresolve();
      } else if (item instanceof FutureWrite) {
        item.unsubscribe();
      }
    }

    return buffer;
  }

  toBuffer(enforceFinalized: boolean = true): Buffer {
    return this.toVisualBuffer(enforceFinalized).toBuffer();
  }

  toHTML(): HTML {
    return this.toVisualBuffer(false).toHTML();
  }
}
class DirectWrite<T> {
  constructor (
    public value: T,
    public format: Format<T>
  ) {
  }
}

class FutureWrite<T> {
  state: { type: 'unused' } | { type: 'placed', buffer: VisualBuffer, offset: number } = { type: 'unused' };

  constructor (
    private _value: Future<T>,
    private _format: Format<T | undefined>
  ) {
  }

  write(buffer: VisualBuffer) {
    if (this.state.type !== 'unused') {
      return unexpected();
    }
    const value = this._value;
    if (value.isResolved) {
      buffer.append(value.value, this._format);
    } else {
      // Write placeholder
      const offset = buffer.writeOffset;
      buffer.append(undefined, this._format);
      this.state = {
        type: 'placed',
        buffer,
        offset
      };
      value.once('resolve', v => this.resolve(v));
    }
  }

  unsubscribe() {
    if (this.state.type === 'placed') {
      this.state = { type: 'unused' };
    }
  }

  resolve = (value: T) => {
    if (this.state.type !== 'placed') {
      return unexpected();
    }
    this.state.buffer.overwrite(value, this._format, this.state.offset);
    this.state = { type: 'unused' };
  }
}

class Marker {
  public position = new Future<number>();
}

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
      throw new Error('Value not resolved');
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

const genericBufferFormat: Format<Buffer> = {
  binaryFormat: b => BinaryData([...b]),
  htmlFormat: tableRow<Buffer>(b => b.toString())
};

const nestedVisualBufferFormat: Format<VisualBuffer> = {
  binaryFormat: b => BinaryData([...b.toBuffer()]),
  htmlFormat: tableRow<VisualBuffer>(b => b.toHTML())
};

function FutureFormat<T>(format: Format<T>, sizeBytes: number): Format<undefined | T> {
  const placeholderData = zeros(sizeBytes);
  return {
    binaryFormat: (value: T | undefined) =>
      value === undefined ? placeholderData : format.binaryFormat(value),
    htmlFormat: (value: T | undefined, binary: BinaryData, offset: number) =>
      value === undefined ? placeholderRow(value, binary, offset) : format.htmlFormat(value, binary, offset)
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

const futurableFormats = {
  uHex8: FutureFormat(formats.uHex8, 1),
  uInt8: FutureFormat(formats.uInt8, 1),
  sInt8: FutureFormat(formats.sInt8, 1),

  uHex16LE: FutureFormat(formats.uHex16LE, 2),
  uInt16LE: FutureFormat(formats.uInt16LE, 2),
  sInt16LE: FutureFormat(formats.sInt16LE, 2),

  uHex32LE: FutureFormat(formats.uHex32LE, 4),
  uInt32LE: FutureFormat(formats.uInt32LE, 4),
  sInt32LE: FutureFormat(formats.sInt32LE, 4),

  doubleLE: FutureFormat(formats.doubleLE, 8),
}
