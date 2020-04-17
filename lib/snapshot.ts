import { Snapshot as ISnapshot } from '../lib';
import * as fs from 'fs-extra';

/**
 * A snapshot of the state of a virtual machine
 */
export class Snapshot implements ISnapshot {
  constructor(data: Buffer) {
    // TODO: Validate data
    this._data = data;
  }

  get data() { return this._data; }

  private _data: Buffer;
}