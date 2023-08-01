# Objects and Classes

Microvium objects are represented by the `TC_REF_PROPERTY_LIST` type (`TsPropertyList`). Arrays and closures are not objects -- you cannot attach arbitrary properties to them, although `typeof array === 'object'`.

Classes are represented by `TC_REF_CLASS`. Classes are a tuple of a constructor function and an object (see `TsClass`). The object part of the tuple stores the properties of the class. Property access is delegated to the object, while construction is delegated to the constructor function (which may or may not be a closure).

Objects and arrays can both expand, but they do so very differently. Arrays are represented as two distinct allocations: one that is a fixed size and holds the array length and a pointer to the second allocation which holds the elements (see `TsArray`). By design it's guaranteed that the pointer to the elements allocations is unique, so we can reallocate it and know that there is only one pointer to it which needs to be updated it (as opposed to the array itself which is represented by the first allocation and may have many references to it).

Objects expand instead as linked-list. Each `TsPropertyList` has a `dpNext` pointer which points to another property list or null. Each `TsPropertyList` in the chain can contain an arbitrary number of properties, but when you add a property to an object, like `obj.prop = 42`, it adds a `TsPropertyList` with just the single property. This is very space inefficient but then a garbage collection cycle will compact all the `TsPropertyList` lists in the chain into a single `TsPropertyList` that contains all the properties.

The `TsPropertyList` also contains a `dpProto` pointer which references the prototype. Only the `dpProto` of the first `TsPropertyList` in the chain is used. The others are wasted space but will be cleaned up on a GC collection when the whole object is compacted.

The properties in `TsPropertyList` are stored as key-value pairs. The number of properties in a `TsPropertyList` is can be inferred by the allocation size.

Properties can be accessed in two ways:

1. Normal properties are accessed using `getProperty`.
2. Internal slots are accessed using positionally (see the later section).


## Property keys

Property keys of normal properties can be interned strings (`TC_REF_INTERNED_STRING`) or non-negative int14. Property keys will never be non-interned strings (`TC_REF_STRING`) since property lookup is done by reference equality.

It is illegal for an interned string `TC_REF_INTERNED_STRING` to be numeric. Numeric strings at compile time will be compiled to `TC_REF_STRING` in the bytecode and at runtime if such a `TC_REF_STRING` is used for property indexing it throw an error.

The reason for this is that we can guarantee that no valid property name is the string form of an equivalent integer, which means we can use integers directly as property keys. If you access `obj[0] = 42`, this is stored on the object using int14 `42` rather than the string equivalent. Only non-negative int14 is permitted as a property key.

The non-negative int14 properties are meant for array indexing, but it happens to work on objects as well, which is a little bit non-compliant if you enumerate the properties with `Reflect.ownKeys()` (this could be fixed in future by having `Reflect.ownKeys()` do the conversion dynamically).

Coincidentally this means that if you need to store properties dynamically (e.g. `obj[prop]`) it's significantly more efficient if `prop` is an int14, since it doesn't need to do string interning.

The property keys `"length"` and `"__proto__"` are special and actually have their own distinct types (`TC_VAL_STR_LENGTH` and `TC_VAL_STR_PROTO`). These have special meaning to `getProperty` depending on the type (e.g. array vs object). `VM_VALUE_STR_LENGTH` is valid as a normal property key for objects, but when used on arrays will instead get the length of the array. `VM_VALUE_STR_PROTO` has special meaning on both arrays and objects -- for arrays it will return the array prototype object. For objects it will return the value of the `dpProto` slot.

## Property attributes and Reflect.ownKeys

All properties in Microvium are enumerable and configurable, and none are have getters or setters (all are just plain values). This is done for storage efficiency since properties can be represented as a simple 2-slot key-value pair.

For this reason, Microvium doesn't implement `Object.keys()` but instead `Reflect.ownKeys()`. The difference being that `Object.keys` returns only enumerable properties while `Reflect.ownKeys` returns both enumerable and non-enumerable properties. This means that whether a key is enumerable or not in Microvium is not actually observable. There is no `for .. in` loop, and no `Object.keys`, or any other way to determine if a property is enumerable or not, so the absence of the enumerable attribute is not observable.


## Builtins, Branding and Internal Slots

As mentioned, objects in Microvium have a prototype stored in the `dpProto` slot which is read-only accessible by the `__proto__` special string. Objects can be constructed with a prototype in only 2 ways in Microvium:

1. Instantiating a user-defined class using `new`.
2. When the VM instantiates a built-in object, such as an instance of `Promise`.

These two mechanisms produce completely disjoint prototypes, meaning that it's impossible for a user to "manually" instantiate an object with a builtin prototype. This is unlike other engines where a user could manually instantiate an object with a builtin prototype by setting `__proto__` (which is readonly in Microvium) or by `Object.create(proto)`. What I mean by "manually" here is to instantiate the object by a means other than the builtin constructor, if the builtin constructor is exposed at all.

What this means is that the prototype of an object can be used as a safe brand check for builtin object types. For example, if an object's prototype is the internal `Promise.prototype` then the object must have been constructed by the `Promise` constructor or other internal engine mechanism, and not by a user using `Object.create` or `__proto__`.

This is done to save space -- we do not need extra identification mechanisms to do a brand-check on a builtin object, and can instead just check the prototype.

Builtin objects may have internal "slots" according to the ECMAScript spec. In Microvium these are just stored like normal properties, but where the key of the property is a negative int14. `Reflect.ownKeys` ignores these properties when it enumerates the properties.

When an internal object is first allocated, it will be allocated with all of its internal slots present and in a known order. That is, the internal slots will never appear in later `TsPropertyList` segments of the linked list, and thus they can always be indexed by position in the allocation rather than by iterating the properties linearly to find the given key.

As such, the property key of internal properties is not used for property lookup and can instead by used for storage, as long as the property key is always a negative int14. Promises, for example, use this to store the promise state in a property-key slot while storing the subscribers in the corresponding property value slot, thus reducing the amount of memory required.

Be aware that properties start at slot 2 in the object (byte 4) since the first 2 slots in an object are the `dpProto` and `dpNext` pointers.