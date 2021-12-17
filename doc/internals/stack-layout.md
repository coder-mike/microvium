# Stack Layout (in the native VM)

The Microvium engine starts out with no virtual call stack and also has no virtual call stack when its idle (when no calls are active).

Microvium does not use the C stack to make JavaScript/bytecode calls. There is a virtual call stack allocated from the host using `malloc`, and this is used for storing JavaScript stack frames.

The Microvium virtual call stack grows upwards.

To keep the GC simple, the slots on the stack are all strictly of type `mvm_Value` (using the Microvium value encoding, where each slot is 16 bits and a low bit of zero indicates if it's a reference to the virtual heap), except the `8 bytes` frame boundary which is used to save the machine register values during a CALL. See `VM_FRAME_BOUNDARY_VERSION` which is referenced everywhere that is coupled to the frame boundary layout.

(WIP: review this list, since I've made some changes)

Key points in the code:

  - `vm_TsStack`, `vm_TsRegisters`
  - `VM_FRAME_BOUNDARY_VERSION`
  - `VM_OP1_RETURN`
  - `PUSH_REGISTERS`
  - `LBL_CALL_HOST_COMMON`
  - `LBL_CALL_BYTECODE_FUNC`
  - `LBL_CALL_SHORT` (calling into short-call table)
  - `mvm_runGC` (`// Roots on the stack`)
  - Opcodes:
    - `VM_OP_CALL_1`
    - `VM_OP2_CALL_3`
    - `VM_OP_CALL_5`
    - `VM_OP2_CALL_6`
    - `VM_OP2_CALL_HOST`

## General shape of the stack

The stack is a repeating sequence of the following (growing upwards):

  1. A list of arguments
  2. A frame boundary (8-byte block to save the previous frame's state)
  3. A list of working variables for the current frame

(With this model, the term "frame boundary" is a bit confusing)

Each argument and each working variable is a 16-bit slot conforming to `mvm_Value`. For example, the low bit indicates if the value is a pointer.

The "frame boundary" words do not conform to `mvm_Value`, and the GC understands this.

Each function call to a bytecode function always follows this pattern:

  1. Push the arguments to the stack (which may be the empty stack if this is the first call)
  2. Push a frame boundary (`PUSH_REGISTERS`), which may be pushing the "null" register values if this is the first call
  3. Run the bytecode
  4. A RETURN instruction pops the frame boundary and pops the arguments (and pushes the return value). And if the callee frame was flagged as `AF_CALLED_FROM_HOST` then the run-loop terminates and control is passed back to the host (along with the popped return value).

Invocations of bytecode instructions always follow this pattern:

  1. Push the operands
  2. Invoke the instruction, which will pop the operands and push the result

Calls from the VM to the host follow the pattern of instructions rather than calls. There is no frame boundary and the host does not push any variables to the stack.

However, if the called host function in turn calls a bytecode function, this follows the pattern of a function call.

What this means is that there is exactly one frame boundary per invoked bytecode function.

Frames may be flagged with `AF_CALLED_FROM_HOST` to indicate that a RETURN from that frame should also return control to the host. Naturally, every frame is either called from the host or from the another VM function.

## Allocation of the stack (first call from host)

When a call to the VM is made from the host (to `mvm_call`), the VM allocates a stack and then frees it again when the call is complete. This may be inefficient since it requires a malloc/free for each call to the VM, but it fits the general philosophy of the VM "staying out of your way" when its not running (consuming as little memory as possible).

When the call stack is malloc'd from the host, the VM registers are also malloc'd in the same block, since these are always required at the same time. See `vm_TsStack` and `vm_TsRegisters`.

The some registers are cached in local variables in `mvm_call`. See `CACHE_REGISTERS` and `FLUSH_REGISTER_CACHE`.

The initial allocation of the stack is done in `vm_createStackAndRegisters`. The initial stack is empty and the program counter points to the beginning of the bytecode image as a kind of "null" value (it doesn't yet point to the function being called).

## Layout of first frame

 1. The arguments from the host are pushed onto the empty stack
 2. Control is passed to `LBL_CALL` which saves the standard 8-byte inter-frame words (as well as setting up the program counter and closure `scope`).

The arguments from the host need to be on the VM stack because the `pArgs` register is not saved on successive CALL instructions but is instead inferred during a RETURN instruction.

## Calls from the VM to the VM

These will land up at `LBL_CALL_BYTECODE_FUNC`, through various paths depending on what instruction was used. `LBL_CALL_BYTECODE_FUNC` calls `PUSH_REGISTERS` which saves the standard 8-byte frame boundary to the stack before it sets up the new frame (new program counter). As always, it is assumed that the arguments were pushed prior to the CALL instruction.

## Calls from the VM to the host

These will land up at `LBL_CALL_HOST_COMMON`, through various paths depending on what instruction was used.

Calls from the VM to the host can be thought of more like _instructions_ than calls. They do NOT save a frame boundary. The host function executes as if in the frame of the caller, but this is invisible to it since it cannot access the frame.

A VM in Microvium is not multi-threaded, but it is reentrant, meaning that if the VM calls the host, the host can call back into the VM again, so multiple calls from the host can be active simultaneously in the same call stack.

The call stack is only allocated on the first entry in the stack of entries and then only freed when the first call returns.

A special case to think about is that `mvm_call` may legally provide a `targetFunc` that is also a host function, so the host can call itself via the VM. And we can take this example further by imagining that the called host function in turn calls a VM function:

  1. When the host calls `mvm_call`, the arguments will be pushed into the initial empty host frame.

  2. `LBL_CALL` will defer to `LBL_CALL_HOST_COMMON` which does NOT push a frame boundary and instead directly calls the target host function.

  3. The second host function now calls `mvm_call` again, which recognizes that the stack already exists so it does not allocate it.

  4. `mvm_call` pushes the new arguments to the stack directly on top of the previous arguments and sets the program counter at the target bytecode.

  5. When the bytecode invokes a `RETURN` instruction, the machine pops off the top frame and frame boundary, and then pops off the arguments. It then recognizes that `AF_CALLED_FROM_HOST` is true and so `returns` from `mvm_call` back to the host which in turn returns to the previous `mvm_call` which is still in `LBL_CALL_HOST_COMMON`. At this point, the machine is exactly in its previous state before it called the host function.

  6. In `LBL_CALL_HOST_COMMON`, it finishes off by popping the remaining arguments off the stack and returning to the host again.

