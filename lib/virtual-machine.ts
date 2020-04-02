import { Snapshot } from "./snapshot";
import { notImplemented } from "./utils";
import { compileScript } from "./src-to-il";
import fs from 'fs-extra';

export class VirtualMachine {
  private globals: string[];

  constructor (resumeFromSnapshot?: Snapshot | undefined, globals?: string[]) {
    if (resumeFromSnapshot) {
      return notImplemented();
    }
    this.globals = globals ?? [];
  }

  public async importFile(filename: string) {
    const sourceText = await fs.readFile(filename, 'utf-8');
    const unit = compileScript(filename, sourceText, this.globals);

    return notImplemented();
  }

  public createSnapshot(): Snapshot {
    return notImplemented();
  }
}