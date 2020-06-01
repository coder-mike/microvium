# Memory Usage

See also: [./memory-management.md](./memory-management.md).

(This will be filled in later when there's more data)

Note: Everything in this file is an implementation detail and subject to change without notice.

The memory usage of a Microvium program changes over time. A typical memory profile on a microcontroller may be as follows:

![Memory profile](../images/memory-usage.svg)

Each region will be discussed in more detail in the following sections. The minimum size needed for each section (i.e. the space used by an empty VM) is as follows:

  - **Microvium engine**: `16 kB`
  - **Bytecode**: `64 B`
  - **Data memory**: `20 B`
  - **Heap memory**: `0 B` (if there are no heap allocations)
  - **Stack and register memory**: 8 B + stack size configured in port file, while VM is active. `0 B` while VM is inactive
  - **GC Temporary Memory**: `0 B` (if there are no heap allocations)

Allocations in the heap incur additional memory overhead of 2 bytes per allocation, plus 10 bits per byte of heap memory at collection time. For example, a heap of 800 Bytes will require up to 1000 B of temporary space during a garbage collection cycle.

## Microvium Engine

The Microvium engine is provided as C code ([microvium.c](https://github.com/coder-mike/microvium/blob/master/native-vm/microvium.c)) and takes in the order of 16 kB of ROM on a microcontroller when compiled, depending on the compilation settings and architecture.

## Bytecode

The bytecode representation of the snapshot of a virtual machine can be downloaded or compiled into ROM. The bytecode has a fixed-size header in the order of 64 bytes, and its final size depends on the amount of code and data in the snapshot.

The bytecode file contains regions for:

  1. Compiled functions as bytecode instructions
  2. A copy of the data memory corresponding to when the snapshot was captured
  3. A copy of the heap memory corresponding to when the snapshot was captured
  4. Metadata recording the imports and exports of the VM, engine requirements, etc.

## Data Memory

The data memory of the VM is `malloc`'d from the host when the VM is restored from the snapshot at runtime. The `malloc`'d space includes space for:

  1. Global variables for the VM script (2 bytes per variable)
  2. Internal structures required by the engine to host a virtual machine (about 20 bytes of memory, depending on the architecture).

The initial values of the global variables are copied from the bytecode image when the VM is restored.

## Heap Memory

The VM heap includes objects which are eligible for garbage collection. The size of the heap may change over time and is allocated from the host in chunks (e.g. of 256 B each) as needed by the VM.

VM values existing in the heap have a 2-byte header and are rounded up in size to the nearest 2-byte boundary.

There is no minimum heap memory size. If there are no object allocated in the heap, the region for the heap will not be allocated from the host at all.

## Stack and Registers

When the host needs to call into the VM, the VM will allocate temporary space for the stack and running registers (e.g. program counter, stack pointer, etc). The stack size is fixed but configurable for each host by the [port file](https://github.com/coder-mike/microvium/blob/master/native-vm/microvium_port_example.h) (defaulting to 256 B).

Each stack frame is a minimum of 6 bytes, plus space for local variables, arguments, and temporary values. Each local variable is 2 bytes on the stack.

Microvium is currently optimized for the case where the VM is idle most of the time, with small bursts of activity. This is the case where a large C firmware host already does most of the work for the application and only consults the VM for small pieces of scripted behavior when specific events occur.

To serve this objective, the stack and working registers are freed while the VM is idle.

## GC Temporary Memory

Microvium is currently optimized for the case where garbage collection is manually triggered by the host when the VM is idle (i.e. while the VM does not have stack memory allocated). A garbage collection cycle temporarily requires the following additional memory:

  1. `1` bit per byte of allocated memory for mark tables. For example, if the heap is `512 B` at the time that GC is triggered, then the GC will allocate `64 B` for mark tables

  2. Temporary space to copy all _live_ (reachable) objects. For example, if `128 B` out of the above `512 B` of heap space are reachable, then the GC will require an additional `128 B` of space during collection.


# Size used by different value types

Basic values use 2 bytes each:

  1. Integers in the range `-8192` to `8191` (14-bit signed range)
  2. Boolean values `true` and `false`
  3. `undefined`, `null`, `NaN` and an empty string

Other values are represented internally as a 2-byte pointer into the heap, and consume the following memory:

  - **Strings:** UTF-8 encoded string, `+1B` extra null terminator, `+2B` allocation header, `+2B` pointer to refer to it from a variable.

    - Chars in Microvium are single-character strings, and so consume `6B` of space each.

  - **Int32:** Integers exceeding the 14-bit range will be stored as 32-bit integers on the VM heap, `+2B` allocation header, `+2B` pointer to refer to it from a variable (total of `8B`)







