# Stack Layout (in the native VM)

The Microvium engine starts out with no virtual call stack and also has no virtual call stack when its idle (when no calls are active).

Microvium does not use the C stack to make JavaScript/bytecode calls. There is a virtual call stack allocated from the host using `malloc`, and this is used for storing JavaScript stack frames.

The Microvium virtual call stack grows upwards.

To keep the GC simple, the slots on the stack all strictly of type `mvm_Value` (using the Microvium value encoding, where each slot is 16 bits and a low bit of zero indicates that it's a reference to the virtual heap), except the 8 bytes between frames which is used to save the machine register values during a CALL.

(WIP: vm_setupCallFromExternal is gone now)

Key points in the code:

  - `vm_TsStack`, `vm_TsRegisters`
  - `VM_FRAME_SAVE_STATE_SHAPE_VERSION` (marks all the places in code that are coupled to the saved register layout on the stack)
  - `vm_setupCallFromExternal`
  - `VM_OP1_RETURN`
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

## Allocation of the stack (first call from host)

When a call to the VM is made from the host, the VM allocates a stack and then deletes it again when the call is complete. This may be inefficient since it requires a malloc/free for each call to the VM, but it fits the general philosophy of the VM "staying out of your way" when its not running (consuming as little memory as possible).

When the call stack is malloc'd from the host, the VM registers are also malloc'd in the same block, since these are always required at the same time. See `vm_TsStack` and `vm_TsRegisters`.

The initial allocation of the stack is done in `vm_setupCallFromExternal`.

## Nested calls from host

Microvium is strictly not multi-threaded, but it is reentrant, meaning that if the VM calls the host, the host can call back into the VM again, so multiple calls from the host can be active simultaneously in the same call stack.

The call stack is only allocated on the first entry in the stack of entries and then only freed when the first call returns.

## Layout of first frame

`vm_setupCallFromExternal` does not save any previous call state, but it does push the arguments onto the stack.

The arguments from the host need to be on the VM stack because the `pArgs` register is not saved on successive CALL instructions but is instead inferred during a RETURN instruction.

Unlike CALL operations from bytecode, when the VM is called from the host there is no 8-byte register-saving block after the arguments. (TODO: would the code be more efficient if we added this block for consistency?)

## Saving register state on call

When bytecode calls other bytecode or the host, it saves the current VM register states to the stack. The shape and order of these saved registers changes occasionally, so there is a `VM_FRAME_SAVE_STATE_SHAPE_VERSION` definition to keep track of all the places that are coupled to the shape