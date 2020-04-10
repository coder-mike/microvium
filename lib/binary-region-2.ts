import { assert, invalidOperation } from "./utils";
import { VisualBuffer, Format, formats, BinaryData, tableRow, HTML } from "./visual-buffer";
import { encode } from "punycode";

export type FutureLike<T> = T | Future<T>;

class FutureResolutionContext extends WeakMap<Future<any>, FutureValue<any>> {}

// A class roughly like VisualBuffer for writing buffers, except that you can
// write values that will only be finalized later
export class BinaryRegion2 {
  #postProcessing = new Array<{
    start: Future<number>,
    end: Future<number>,
    process: (buffer: Buffer) => any,
    result: Future<any>
  }>();
  #data = new Array<DirectWrite<any> | FutureWrite<any> | Marker | BinaryRegion2>();

  writeInt8(value: FutureLike<number>) {
    this.append(value, formats.sInt8);
  }

  writeUInt8(value: FutureLike<number>) {
    this.append(value, formats.uInt8);
  }

  writeUInt16LE(value: FutureLike<number>) {
    this.append(value, formats.uInt16LE);
  }

  writeInt16LE(value: FutureLike<number>) {
    this.append(value, formats.sInt16LE);
  }

  writeDoubleLE(value: FutureLike<number>) {
    this.append(value, formats.doubleLE);
  }

  writeInt32LE(value: FutureLike<number>) {
    this.append(value, formats.sInt32LE);
  }

  writeUInt32LE(value: FutureLike<number>) {
    this.append(value, formats.uInt32LE);
  }

  writeStringUtf8NT(value: string) {
    this.#data.push(new DirectWrite(value, formats.stringUtf8NT));
  }

  private append<T>(value: FutureLike<T>, format: Format<T | undefined>) {
    if (value instanceof Future) {
      const delayedWrite = new FutureWrite(value, format);
      this.#data.push(delayedWrite);
    } else {
      this.#data.push(new DirectWrite(value, format))
    }
  }

  writeBuffer(buffer: Buffer | BinaryRegion2) {
    if (Buffer.isBuffer(buffer)) {
      this.#data.push(new DirectWrite(buffer, genericBufferFormat));
    } else {
      assert(buffer instanceof BinaryRegion2);
      this.#data.push(buffer);
    }
  }

  postProcess<T>(start: Future<number>, end: Future<number>, process: (buffer: Buffer) => T): Future<T> {
    const result = new Future<T>();
    this.#postProcessing.push({
      start, end, process, result
    })
    return result;
  }

  get currentAddress(): Future<number> {
    const marker = new Marker();
    this.#data.push(marker);
    return marker.position;
  }

  private writeToBuffer(buffer: VisualBuffer, delayedWrites: FutureWrite<any>[], context: FutureResolutionContext) {
    for (const d of this.#data) {
      if (d instanceof DirectWrite) {
        buffer.append(d.value, d.format);
      } else if (d instanceof Marker) {
        d.position.resolve(context, buffer.writeOffset);
      } else if (d instanceof BinaryRegion2) {
        d.writeToBuffer(buffer, delayedWrites, context);
      } else if (d instanceof FutureWrite) {
        d.write(buffer, context);
      } else {
        throw new Error('Unexpected');
      }
    }
  }

  toVisualBuffer(enforceFinalized: boolean): VisualBuffer {
    const delayedWrites: FutureWrite<any>[] = [];
    const buffer = new VisualBuffer();
    const context = new FutureResolutionContext();

    this.writeToBuffer(buffer, delayedWrites, context);

    if (enforceFinalized && delayedWrites.some(d => !d.isFinalized)) {
      throw new Error('Not all delayed writes were finalized');
    }

    for (const postProcessingStep of this.#postProcessing) {
      const start = postProcessingStep.start.valueInContext(context).value;
      const end = postProcessingStep.start.valueInContext(context).value;
      const data = buffer.toBuffer().slice(start, end);
      const result = postProcessingStep.process(data);
      postProcessingStep.result.resolve(context, result);
    }

    return buffer;
  }

  toBuffer(): Buffer {
    return this.toVisualBuffer(true).toBuffer();
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
  isFinalized = false;

  constructor (
    private _value: Future<T>,
    private _format: Format<T | undefined>
  ) {
  }

  write(buffer: VisualBuffer, context: FutureResolutionContext) {
    const value = this._value.valueInContext(context);
    if (value.isResolved) {
      buffer.append(value.value, this._format);
      this.isFinalized = true;
    } else {
      // Write placeholder
      const offset = buffer.writeOffset;
      buffer.append(undefined, this._format);
      value.onResolve(v => {
        buffer.overwrite(v, this._format, offset);
        this.isFinalized = true;
      });
    }
  }
}

class Marker {
  public position = new Future<number>();
}

// Value to be calculated later
export class Future<T = number> {
  #onContext = new Array<(context: FutureResolutionContext) => void>();

  constructor (
    // private instance: (context: FutureResolutionContext, resolve: (value: T) => void) => void,
    public instantiate?: (context: FutureResolutionContext) => FutureValue<T>
  ) {
  }

  public valueInContext(context: FutureResolutionContext): FutureValue<T> {
    let value = context.get(this);
    if (value === undefined) {
      value = this.instantiate ? this.instantiate(context) : new FutureValue<T>();
      context.set(this, value);
      this.#onContext.forEach(f => f(context));
    }
    return value;
  }

  // Resolve in a given context
  resolve(context: FutureResolutionContext, value: T): void {
    this.valueInContext(context).resolve(value);
  }

  // Subscribe in a given context
  onResolve(context: FutureResolutionContext, handler: (value: T) => void): void {
    this.valueInContext(context).onResolve(handler);
  }

  map<U>(f: (v: T) => U): Future<U> {
    return new Future<U>(ctx => {
      const value = new FutureValue<U>();
      this.onResolve(ctx, v => value.resolve(f(v)));
      return value;
    });
  }


  bind<U>(f: (v: T) => Future<U>): Future<U> {
    const result = new Future<U>(ctx => {
      const value = new FutureValue<U>();
      this.onResolve(ctx, v => {
        const v2 = f(v);
        v2.onResolve(ctx, v2 => {
          value.resolve(v2)
        })
      });
      return value;
    });
    return result;
  }

  subtract(this: Future<number>, that: Future<number>): Future<number> {
    return this.bind(a => that.map(b => a - b));
  }

  // Somewhat imperative style, but useful
  assign(value: Future<T>) {
    value.#onContext.push(ctx => {
      value.valueInContext(ctx).assign(this.valueInContext(ctx));
    });
  }

  static create<T>(value: FutureLike<T>): Future<T> {
    if (value instanceof Future) return value;
    // Create a value that is independent of any context
    return new Future<T>(() => FutureValue.create(value));
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
}

// The value of a future within the given context
class FutureValue<T = number> {
  #onResolve?: Array<(value: T) => void>;

  #value: T;
  #resolved: boolean = false;

  get isResolved() { return this.#resolved; }

  get value() {
    if (!this.#resolved) {
      throw new Error('Value not resolved');
    }
    return this.#value;
  }

  onResolve(callback: (value: T) => void) {
    if (this.#resolved) {
      callback(this.#value);
    } else {
      this.#onResolve = this.#onResolve || [];
      this.#onResolve.push(callback);
    }
  }

  resolve(value: T) {
    if (this.#resolved) {
      return invalidOperation('Cannot resolve a Future multiple times in the same context')
    }
    this.#value = value;
    this.#resolved = true;
    if (this.#onResolve) {
      this.#onResolve.forEach(r => r(value));
      this.#onResolve = undefined;
    }
  }

  assign(value: FutureValue<T>) {
    value.onResolve(v => this.resolve(v));
  }

  static create<T>(value: T): FutureValue<T> {
    const result = new FutureValue<T>();
    result.resolve(value);
    return result;
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
