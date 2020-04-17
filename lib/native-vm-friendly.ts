import { Snapshot, PersistentHostFunction, ResolveImport, ExportID } from "../lib";
import { notImplemented } from "./utils";

export class NativeVMFriendly {
  constructor (snapshot: Snapshot, resolveImport: ResolveImport) {
  }

  resolveExport(exportID: ExportID): any {
    return notImplemented();
  }
}