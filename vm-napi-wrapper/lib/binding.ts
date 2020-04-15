const addon = require('../build/Release/micro-vm-native');

class MicroVM {
  private _native: any;

  static resume(snapshotBytecode: Buffer, imports: any): MicroVM {
    if (!Buffer.isBuffer(snapshotBytecode)) {
      throw new Error('Invalid snapshot bytecode');
    }
    return new MicroVM(snapshotBytecode, imports);
  }

  private constructor (snapshotBytecode: Buffer, imports: any) {
    this._native = new addon.MicroVM(snapshotBytecode, imports);
  }
}

export = MicroVM;
