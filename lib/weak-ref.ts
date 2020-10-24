// This is a hack until node natively supports weakrefs

import * as path from 'path';

if ('WeakRef' in (globalThis as any)) {
  // TODO: Now is the time to change this
  /*disable-wip-check*/debugger; // The hope is that if we have native WeakRef support in future, eventually someone will hit this line and make a ticket to upgrade to the native implementation
}

const rootPath = __filename.endsWith('.ts') // Depends if this is pre-built or not
  ? path.join(__dirname, '/..')
  : path.join(__dirname, '/../..')
const addon = require('node-gyp-build')(rootPath); // https://github.com/prebuild/node-gyp-build

export interface WeakRefClass {
  new (value: any): WeakRef;
}

export interface WeakRef {
  deref(): any;
}

export const WeakRef: WeakRefClass = addon.WeakRef;

// For our purposes, I think this simple implementation is fine
export class FinalizationRegistry<T> {
  private registrations = new Set<{ weakRef: any, resource: T }>();
  private lengthOfRegistrationsAtLastCleanup: number = 0;

  constructor (private cleanupFunc: (value: T) => void) {
  }

  register(weakValue: any, resource: T) {
    this.registrations.add({ weakRef: new WeakRef(weakValue), resource });
    if (this.registrations.size > Math.max(this.lengthOfRegistrationsAtLastCleanup * 2, 1)) {
      this.cleanup();
    }
  }

  private cleanup() {
    for (const registration of this.registrations) {
      if (registration.weakRef.deref() === undefined) {
        this.cleanupFunc(registration.resource);
        this.registrations.delete(registration);
      }
    }
    this.lengthOfRegistrationsAtLastCleanup = this.registrations.size;
  }
}