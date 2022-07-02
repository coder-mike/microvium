# Supported Builtins

### Standard builtin functions and objects

`Reflect.ownKeys` - returns an array of keys for an object (only supported on non-array, non-function objects)

## Additional builtin function and objects

### vmExport(id, func)

Export a function to be accessible to the host at the given ID.

The ID can be any integer in the range 0 to 65535.

(This function is only available at compile-time)

### vmImport(id)

Import a host function to be accessed by JS code in the VM.

The ID can be any integer in the range 0 to 65535.

(This function is only available at compile-time)

### Microvium.newUint8Array(size)

Create a Uint8Array buffer with the given size. Sizes up to 4095 bytes are supported.
