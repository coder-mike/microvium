// TODO: This module should be removed
import { assert, invalidOperation } from "./utils";
import { VisualBuffer, Format, formats, BinaryData, tableRow, HTML, HTMLFormat } from "./visual-buffer";
export type ComputedLike<T> = T | Computed<T>;
export type PlaceholderLike<T> = T | Computed<T> | Placeholder<T>;

class ComputedResolutionContext extends WeakMap<Computed<any>, ComputedValue<any>> {}

// A class roughly like VisualBuffer for writing buffers, except that you can
// write values that will only be finalized later
export class BinaryRegion2 {
  #postProcessing = new Array<{
    start: Computed<number>,
    end: Computed<number>,
    process: (buffer: Buffer) => any,
    result: Computed<any>
  }>();
  #data = new Array<DirectWrite<any> | ComputedWrite<any> | PlaceholderWrite<any> | Marker | BinaryRegion2>();
  #placeholders = new Array<Placeholder<any>>();

  createPlaceholder<T = number>(): Placeholder<T> {
    const placeholder = new Placeholder<T>();
    this.#placeholders.push(placeholder);
    return placeholder;
  }

  writeInt8(value: PlaceholderLike<number>) {
    this.append(value, futurableFormats.sInt8);
  }

  writeUInt8(value: PlaceholderLike<number>) {
    this.append(value, futurableFormats.uInt8);
  }

  writeUInt16LE(value: PlaceholderLike<number>) {
    this.append(value, futurableFormats.uInt16LE);
  }

  writeInt16LE(value: PlaceholderLike<number>) {
    this.append(value, futurableFormats.sInt16LE);
  }

  writeDoubleLE(value: PlaceholderLike<number>) {
    this.append(value, futurableFormats.doubleLE);
  }

  writeInt32LE(value: PlaceholderLike<number>) {
    this.append(value, futurableFormats.sInt32LE);
  }

  writeUInt32LE(value: PlaceholderLike<number>) {
    this.append(value, futurableFormats.uInt32LE);
  }

  writeStringUtf8NT(value: string) {
    this.#data.push(new DirectWrite(value, formats.stringUtf8NT));
  }

  private append<T>(value: PlaceholderLike<T>, format: Format<T | undefined>) {
    if (value instanceof Computed) {
      const delayedWrite = new ComputedWrite(value, format);
      this.#data.push(delayedWrite);
    } else if (value instanceof Placeholder) {
      const placeholderWrite = new PlaceholderWrite(value, format);
      this.#data.push(placeholderWrite);
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

  postProcess<T>(start: Computed<number>, end: Computed<number>, process: (buffer: Buffer) => T): Computed<T> {
    const result = new Computed<T>();
    this.#postProcessing.push({
      start, end, process, result
    })
    return result;
  }

  get currentAddress(): Computed<number> {
    const marker = new Marker();
    this.#data.push(marker);
    return marker.position;
  }

  private writeToBuffer(buffer: VisualBuffer, delayedWrites: ComputedWrite<any>[], context: ComputedResolutionContext) {
    for (const d of this.#data) {
      if (d instanceof DirectWrite) {
        buffer.append(d.value, d.format);
      } else if (d instanceof Marker) {
        d.position.resolve(context, buffer.writeOffset);
      } else if (d instanceof PlaceholderWrite) {
        d.write(buffer, context);
      } else if (d instanceof BinaryRegion2) {
        d.writeToBuffer(buffer, delayedWrites, context);
      } else if (d instanceof ComputedWrite) {
        d.write(buffer, context);
      } else {
        throw new Error('Unexpected');
      }
    }
  }

  toVisualBuffer(enforceFinalized: boolean): VisualBuffer {
    const delayedWrites: ComputedWrite<any>[] = [];
    const buffer = new VisualBuffer();
    const context = new ComputedResolutionContext();

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

export class Placeholder<T = number> {
  value = new Computed<T>();

  assign(value: ComputedLike<T>) {
    this.value = Computed.create(value);
  }
}

class DirectWrite<T> {
  constructor (
    public value: T,
    public format: Format<T>
  ) {
  }
}

class PlaceholderWrite<T> {
  constructor (
    public placeholder: Placeholder<T>,
    public format: Format<T>
  ) {
  }

  write(buffer: VisualBuffer, context: ComputedResolutionContext) {
    const value = this.placeholder.value.valueInContext(context);
    if (value.isResolved) {
      buffer.append(value.value, this.format);
    } else {
      // Write placeholder
      const offset = buffer.writeOffset;
      buffer.append(undefined, this.format);
      value.onResolve(v => {
        buffer.overwrite(v, this.format, offset);
      });
    }
  }
}

class ComputedWrite<T> {
  isFinalized = false;

  constructor (
    private _value: Computed<T>,
    private _format: Format<T | undefined>
  ) {
  }

  write(buffer: VisualBuffer, context: ComputedResolutionContext) {
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
  public position = new Computed<number>();
}

// Value to be calculated later
export class Computed<T = number> {
  constructor (
    // private instance: (context: ComputedResolutionContext, resolve: (value: T) => void) => void,
    public instantiate?: (context: ComputedResolutionContext) => ComputedValue<T>
  ) {
  }

  public valueInContext(context: ComputedResolutionContext): ComputedValue<T> {
    let value = context.get(this);
    if (value === undefined) {
      value = this.instantiate ? this.instantiate(context) : new ComputedValue<T>();
      context.set(this, value);
    }
    return value;
  }

  // Resolve in a given context
  resolve(context: ComputedResolutionContext, value: T): void {
    this.valueInContext(context).resolve(value);
  }

  // Subscribe in a given context
  onResolve(context: ComputedResolutionContext, handler: (value: T) => void): void {
    this.valueInContext(context).onResolve(handler);
  }

  map<U>(f: (v: T) => U): Computed<U> {
    return new Computed<U>(ctx => {
      const value = new ComputedValue<U>();
      this.onResolve(ctx, v => value.resolve(f(v)));
      return value;
    });
  }


  bind<U>(f: (v: T) => Computed<U>): Computed<U> {
    const result = new Computed<U>(ctx => {
      const value = new ComputedValue<U>();
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

  subtract(this: Computed<number>, that: Computed<number>): Computed<number> {
    return this.bind(a => that.map(b => a - b));
  }

  static create<T>(value: ComputedLike<T>): Computed<T> {
    if (value instanceof Computed) return value;
    // Create a value that is independent of any context
    return new Computed<T>(() => ComputedValue.create(value));
  }

  static isComputed<T>(value: ComputedLike<T>): value is Computed<T> {
    return value instanceof Computed;
  }

  static map<T, U>(value: ComputedLike<T>, f: (v: T) => U): ComputedLike<U> {
    if (Computed.isComputed(value)) return value.map(f);
    else return f(value);
  }

  static bind<T, U>(value: ComputedLike<T>, f: (v: T) => ComputedLike<U>): ComputedLike<U> {
    if (Computed.isComputed(value)) {
      return value.bind<U>(v => Computed.create(f(v)));
    }
    else return f(value);
  }

  static lift<T, U>(operation: (v: T) => U): (v: ComputedLike<T>) => ComputedLike<U> {
    return (v: ComputedLike<T>) => Computed.bind(v, operation);
  }
}

// The value of a Computed within the given context
class ComputedValue<T = number> {
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
      return invalidOperation('Cannot resolve a Computed multiple times in the same context')
    }
    this.#value = value;
    this.#resolved = true;
    if (this.#onResolve) {
      this.#onResolve.forEach(r => r(value));
      this.#onResolve = undefined;
    }
  }

  static create<T>(value: T): ComputedValue<T> {
    const result = new ComputedValue<T>();
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

function ComputedFormat<T>(format: Format<T>, sizeBytes: number): Format<undefined | T> {
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
  uHex8: ComputedFormat(formats.uHex8, 1),
  uInt8: ComputedFormat(formats.uInt8, 1),
  sInt8: ComputedFormat(formats.sInt8, 1),

  uHex16LE: ComputedFormat(formats.uHex16LE, 2),
  uInt16LE: ComputedFormat(formats.uInt16LE, 2),
  sInt16LE: ComputedFormat(formats.sInt16LE, 2),

  uHex32LE: ComputedFormat(formats.uHex32LE, 4),
  uInt32LE: ComputedFormat(formats.uInt32LE, 4),
  sInt32LE: ComputedFormat(formats.sInt32LE, 4),

  doubleLE: ComputedFormat(formats.doubleLE, 8),
}
