import { SmartBuffer } from "smart-buffer";
import { assert } from "./utils";

type DelayedLike<T> = T | Delayed<T>;

type SmartBufferWriteOp = (this: SmartBuffer, value: number, offset?: number) => void;

export class BufferWriter {
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

  writeDoubleLE(value: DelayedLike<number>) {
    this.writeGeneric(value, SmartBuffer.prototype.writeDoubleLE);
  }

  private writeGeneric(value: DelayedLike<number>, op: SmartBufferWriteOp) {
    if (value instanceof Delayed) {
      const delayedWrite = new DelayedWrite(value, op);
      this.#data.push(delayedWrite);
      this.#appendTo = undefined;
    } else {
      assert(typeof value === 'number');
      if (!this.#appendTo) {
        this.#appendTo = new SmartBuffer();
        this.#data.push(this.#appendTo);
      }
      op.call(this.#appendTo, value);
    }
  }

  writeBuffer(buffer: Buffer | BufferWriter) {
    if (Buffer.isBuffer(buffer)) {
      if (!this.#appendTo) {
        this.#appendTo = new SmartBuffer();
        this.#data.push(this.#appendTo);
      }
      this.#appendTo.writeBuffer(buffer);
    } else {
      assert(buffer instanceof BufferWriter);
      this.#appendTo = undefined;
      this.#data.push(buffer);
    }
  }

  get writeOffset(): Delayed<number> {
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
      this._op.call(buffer, this._value);
      this.isFinalized = false;
    } else {
      // Write placeholder
      const offset = buffer.writeOffset;
      this._op.call(buffer, 0);
      this.isFinalized = false;
      this._value.onResolve(v => {
        const tempOffset = buffer.writeOffset;
        this._op.call(buffer, this._value, offset);
        buffer.writeOffset = tempOffset;
        this.isFinalized = true;
      });
    }
  }

  finalize(buffer: SmartBuffer, value: number, offset: number) {
    this.isFinalized = true;
  }
}

class Marker {
  position = new Delayed<number>();
}

class Delayed<T = unknown> {
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
    if (this.#resolved) {
      throw new Error('Trying to resolve multiple times');
    }
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
}