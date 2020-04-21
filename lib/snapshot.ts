import { Snapshot as ISnapshot } from '../lib';
import * as fs from 'fs-extra';
import { invalidOperation } from './utils';
import { validateSnapshotBinary } from './snapshot-info';

/**
 * A snapshot of the state of a virtual machine
 */
export class Snapshot implements ISnapshot {
  constructor(data: Buffer) {
    const errInfo = validateSnapshotBinary(data);
    if (errInfo) {
      return invalidOperation('Snapshot bytecode is invalid: ' + errInfo);
    }
    this._data = data;
  }

  static fromFileSync(filename: string) {
    return new Snapshot(fs.readFileSync(filename, null));
  }

  static async fromFileAsync(filename: string) {
    return new Snapshot(await fs.promises.readFile(filename, null));
  }

  get data() { return this._data; }

  private _data: Buffer;
}