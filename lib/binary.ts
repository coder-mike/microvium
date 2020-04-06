import { SmartBuffer } from "smart-buffer";
import { assert } from "./utils";

export type DelayedLike<T> = T | Delayed<T>;

type SmartBufferWriteOp = (this: SmartBuffer, value: number, offset?: number) => void;

// A class roughly like SmartBuffer for writing buffers, except that you can
// write values that will only be finalized later
export class BufferWriter {
  #postProcessing = new Array<{
    start: Delayed<number>,
    end: Delayed<number>,
    process: (buffer: Buffer) => any,
    result: Delayed<any>
  }>();
  #data = new Array<SmartBuffer | Marker | DelayedWrite | BufferWriter>();
  #appendTo?: SmartBuffer; // Cache of the last data item if it's a SmartBuffer

  writeUInt16LE(value: DelayedLike<number>) {
    this.writeGeneric(value, SmartBuffer.prototype.writeUInt16LE);
  }

  writeInt16LE(value: DelayedLike<number>) {
    this.writeGeneric(value, SmartBuffer.prototype.writeInt16LE);
  }

  writeInt8(value: DelayedLike<number>) {
    this.writeGeneric(value, SmartBuffer.prototype.writeInt8);
  }

  writeUInt8(value: DelayedLike<number>) {
    this.writeGeneric(value, SmartBuffer.prototype.writeUInt8);
  }

  writeDoubleLE(value: DelayedLike<number>) {
    this.writeGeneric(value, SmartBuffer.prototype.writeDoubleLE);
  }

  writeInt32LE(value: DelayedLike<number>) {
    this.writeGeneric(value, SmartBuffer.prototype.writeInt32LE);
  }

  writeUInt32LE(value: DelayedLike<number>) {
    this.writeGeneric(value, SmartBuffer.prototype.writeUInt32LE);
  }

  writeStringNT(value: string, encoding: BufferEncoding) {
    this.getSmartBuffer().writeStringNT(value, encoding);
  }

  private writeGeneric(value: DelayedLike<number>, op: SmartBufferWriteOp) {
    if (value instanceof Delayed) {
      const delayedWrite = new DelayedWrite(value, op);
      this.#data.push(delayedWrite);
      this.#appendTo = undefined;
    } else {
      assert(typeof value === 'number');
      op.call(this.getSmartBuffer(), value);
    }
  }

  private getSmartBuffer(): SmartBuffer {
    if (!this.#appendTo) {
      this.#appendTo = new SmartBuffer();
      this.#data.push(this.#appendTo);
    }
    return this.#appendTo;
  }

  writeBuffer(buffer: Buffer | BufferWriter) {
    if (Buffer.isBuffer(buffer)) {
      this.getSmartBuffer().writeBuffer(buffer);
    } else {
      assert(buffer instanceof BufferWriter);
      this.#appendTo = undefined;
      this.#data.push(buffer);
    }
  }

  postProcess<T>(start: Delayed<number>, end: Delayed<number>, process: (buffer: Buffer) => T): Delayed<T> {
    const result = new Delayed<number>();
    this.#postProcessing.push({
      start, end, process, result
    })
  }

  get currentAddress(): Delayed<number> {
    const marker = new Marker();
    this.#appendTo = undefined;
    this.#data.push(marker);
    return marker.position;
  }

  private writeToBuffer(buffer: SmartBuffer, delayedWrites: DelayedWrite[]) {
    for (const d of this.#data) {
      if (d instanceof SmartBuffer) {
        buffer.writeBuffer(d.toBuffer());
      } else if (d instanceof Marker) {
        d.position.resolve(buffer.writeOffset);
      } else if (d instanceof BufferWriter) {
        d.writeToBuffer(buffer, delayedWrites);
      } else if (d instanceof DelayedWrite) {
        d.write(buffer);
      } else {
        throw new Error('Unexpected');
      }
    }
  }

  toBuffer(): Buffer {
    const delayedWrites: DelayedWrite[] = [];
    const buffer = new SmartBuffer();

    this.writeToBuffer(buffer, delayedWrites);

    if (delayedWrites.some(d => !d.isFinalized)) {
      throw new Error('Not all delayed writes were finalized');
    }

    for (const postProcessingStep of this.#postProcessing) {
      const start = postProcessingStep.start.value;
      const end = postProcessingStep.start.value;
      const data = buffer.toBuffer().slice(start, end);
      const result = postProcessingStep.process(data);
      postProcessingStep.result.resolve(result);
    }

    return buffer.toBuffer();
  }
}

class DelayedWrite {
  isFinalized = false;

  constructor (
    private _value: Delayed<number>,
    private _op: SmartBufferWriteOp
  ) {
  }

  write(buffer: SmartBuffer) {
    if (this._value.isResolved) {
      this._op.call(buffer, this._value.value);
      this.isFinalized = false;
    } else {
      // Write placeholder
      const offset = buffer.writeOffset;
      this._op.call(buffer, 0);
      this.isFinalized = false;
      this._value.onResolve(v => {
        const tempOffset = buffer.writeOffset;
        this._op.call(buffer, v, offset);
        buffer.writeOffset = tempOffset;
        this.isFinalized = true;
      });
    }
  }
}

class Marker {
  position = new Delayed<number>();
}

// Value to be calculated later
export class Delayed<T = number> {
  #value: T;
  #resolved: boolean = false;
  #onResolve?: Array<(value: T) => void>;

  get isResolved() { return this.#resolved; }
  get value() {
    if (!this.#resolved) {
      throw new Error('Value not resolved');
    }
    return this.#value;
  }

  resolve(value: T) {
    this.#value = value;
    this.#resolved = true;
    if (this.#onResolve) {
      this.#onResolve.forEach(r => r(value));
      this.#onResolve = undefined;
    }
  }

  onResolve(callback: (value: T) => void) {
    if (this.#resolved) {
      callback(this.#value);
    } else {
      this.#onResolve = this.#onResolve ?? [];
      this.#onResolve.push(callback);
    }
  }

  map<U>(f: (v: T) => U): Delayed<U> {
    const result = new Delayed<U>();
    this.onResolve(v => result.resolve(f(v)));
    return result;
  }

  bind<U>(f: (v: T) => Delayed<U>): Delayed<U> {
    const result = new Delayed<U>();
    this.onResolve(v => f(v).onResolve(v2 => result.resolve(v2)));
    return result;
  }

  subtract(this: Delayed<number>, that: Delayed<number>): Delayed<number> {
    return this.bind(a => that.map(b => a - b));
  }

  assign(value: DelayedLike<T>) {
    if (value instanceof Delayed) {
      value.onResolve(v => this.resolve(v));
    } else {
      this.resolve(value);
    }
  }

  static create<T>(value: DelayedLike<T>): Delayed<T> {
    if (value instanceof Delayed) return value;
    const result = new Delayed<T>();
    result.resolve(value);
    return result;
  }

  static isDelayed<T>(value: DelayedLike<T>): value is Delayed<T> {
    return value instanceof Delayed;
  }

  static map<T, U>(value: DelayedLike<T>, f: (v: T) => U): DelayedLike<U> {
    if (Delayed.isDelayed(value)) return value.map(f);
    else return f(value);
  }

  static bind<T, U>(value: DelayedLike<T>, f: (v: T) => DelayedLike<U>): DelayedLike<U> {
    if (Delayed.isDelayed(value)) {
      if (value.isResolved) return f(value.value);
      const result = new Delayed<U>();
      value.onResolve(v => {
        const r = f(v);
        if (Delayed.isDelayed(r)) result.assign(r);
        else result.resolve(r);
      });
      return result;
    }
    else return f(value);
  }

  static lift<T, U>(operation: (v: T) => U): (v: DelayedLike<T>) => DelayedLike<U> {

  }
}