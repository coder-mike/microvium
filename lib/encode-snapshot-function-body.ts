
import * as IL from './il';
import * as VM from './virtual-machine-types';
import { notImplemented, assertUnreachable, hardAssert, notUndefined, unexpected, invalidOperation } from './utils';
import * as _ from 'lodash';
import { mvm_Value, TeTypeCode, UInt8, UInt4, isUInt16, isUInt4, isSInt8, isUInt8, SInt8, isSInt16, UInt16, SInt16, UInt7  } from './runtime-types';
import { formatSourceLoc, stringifyOperation } from './stringify-il';
import { BinaryRegion, Future, FutureLike, Labelled } from './binary-region';
import { Format, BinaryData } from './visual-buffer';
import * as formats from './snapshot-binary-html-formats';
import escapeHTML from 'escape-html';
import { vm_TeOpcode, vm_TeOpcodeEx1, vm_TeOpcodeEx2, vm_TeOpcodeEx3, vm_TeSmallLiteralValue, vm_TeNumberOp, vm_TeBitwiseOp, vm_TeOpcodeEx4 } from './bytecode-opcodes';
import fs from 'fs';
import { Referenceable, programAddressToKey } from './encode-snapshot';

/*
writeFunctionBody is essentially concerned with the layout and emission of
bytecode instructions. It is a fairly complex process, and is broken down into
several passes. The complexity comes in part from the fact that Jump
instructions have different sizes depending on how far they jump, but how far
they jump depends on the address layout which in turn depends on the sizes of
the instructions in between the jump origin and target. This is a classic
chicken-and-egg problem, and the solution is to do multiple passes, refining the
estimates on each pass.

- Pass 1: Use the maximum possible instruction sizes to do an initial layout
  estimate. After this pass, instructions are allowed to get smaller but not
  allowed to get bigger, meaning that jump instructions will be overestimated.

- Pass 2 with isFinal=false: Use the initial layout estimate to get a more
  accurate upper bounds on the instruction sizes of instructions. In particular,
  Jump instructions will now be estimated based on the actual distance of the
  jump, although the distance could still get smaller. Like Pass 1, instructions
  are still allowed to get smaller after this pass but not bigger, and the
  addresses are not final.

- Pass 2 with isFinal=true: Call Pass 2 again for each instruction. The Jump
  instructions in this pass may be smaller than in Pass 2 because they consider
  the addresses with the smaller instructions that came out of the first Pass 2.
  During this pass, the address of each emitted instruction is final, so this is
  the pass where padding can be accurately calculated for instructions and
  blocks that require alignment. Prior to this pass, the maximum padding is
  assumed, since instructions (with their padding) are allowed to get smaller
  but not bigger, and padding is unpredictable so we also assume the worst
  padding until the final layout. The actual instructions can't be emitted yet
  because as we're performing this pass, we might know the final addresses of
  earlier instructions but not yet know the final addresses of later
  instructions, so Jump instructions can't be emitted yet. Instructions are not
  allowed to change size after this pass because their address layout is final.

- Pass 3: Using the final address layout of Pass 2, emit the actual
  instructions. Since this is the only pass where we have knowledge of all other
  instruction addresses in the function, this is the only pass where we can
  correctly emit Jump instructions. But the Jump instructions need to remain
  consistent with the final address layout of Pass 2, so the size of the jump
  instruction is not determined by the exact distance of the jump, but rather by
  the distance of the jump as estimated in Pass 2. This means that the Jump
  instructions may be larger than they need to be, but they will never be
  smaller than they need to be.

This is done on a per-function basis. Call operations do not change size, so we
do not need a similar process for inter-function calls like we do for jumps.

The output is appended to the given BinaryRegion, which is like a buffer but
also supports emitting future references to addresses that are not yet known,
which is used for Call operations since the address of other functions is not
yet known. The `ctx.offsetOfFunction` function returns the future address of a
function, which is used to emit the Call instruction.
*/
export function writeFunctionBody(
  output: BinaryRegion,
  func: IL.Function,
  ctx: InstructionEmitContext,
  resumeReferences: Map<string, Future<Referenceable>>
): void {

  const emitter = new InstructionEmitter();
  const funcId = func.id;

  const functionBodyStart = output.currentOffset;

  const metaByOperation = new Map<IL.Operation, OperationMeta>();
  const metaByBlock = new Map<IL.BlockID, BlockMeta>();
  const blockOutputOrder: string[] = []; // Will be filled in the first pass
  const requireBlockAlignment = new Map<IL.BlockID, '2-byte' | '4-minus-2-byte'>();

  ctx.requireBlockToBeAligned = (blockId, alignment) => {
    alignment === '2-byte' || '4-minus-2-byte' || unexpected();

    // This is a bit of a hack. So far, we're only using the required alignment
    // for the case of try-catch, where catch blocks need to be 2-byte aligned
    // in order for us to safely store a reference on the stack. Try-catch
    // blocks also have the property that the catch comes *later* than the
    // *try*, so we will encounter the first pass of the `StartTry` before
    // getting the address estimate of the catch block. This just saves us doing
    // an extra pass, but would break if we every required alignment on
    // backreferences.
    !metaByBlock.get(blockId) || unexpected();

    requireBlockAlignment.set(blockId, alignment);
  };

  pass1();

  // Run a second pass (for the first time) to refine the estimates
  pass2(false);
  // dumpInstructionEmitData('before-second-pass2.txt', func, blockOutputOrder, metaByOperation, metaByBlock);

  // Run the second pass again to refine the layout further. This is
  // particularly for the case of forward jumps, which were previously estimated
  // based on the maximum size of future operations but can now be based on a
  // better estimate of future operations
  for (const m of metaByOperation.values()) {
    m.addressEstimate = m.address;
    m.sizeEstimate = m.size;
    m.address = undefined as any;
    m.size = undefined as any;
  }
  for (const m of metaByBlock.values()) {
    m.paddingBeforeBlock = undefined;
    m.addressEstimate = m.address;
    m.address = undefined as any;
  }

  // On this run all the operations and blocks should have their final address,
  // so that on the final pass we know exactly what offsets to use for jumps and
  // branches.
  pass2(true);

  // dumpInstructionEmitData('before-output-pass.txt', func, blockOutputOrder, metaByOperation, metaByBlock);

  // Output pass to generate bytecode
  outputPass();

  ctx.requireBlockToBeAligned = undefined; // Outside the function, this doesn't make sense

  function pass1() {
    const blockQueue = Object.keys(func.blocks);
    ctx.preferBlockToBeNext = nextBlockID => {
      const originalIndex = blockQueue.indexOf(nextBlockID);
      if (originalIndex === - 1) {
        // The block position has already been secured, and can't be changed
        return;
      }
      // Move it to the beginning of the queue
      blockQueue.splice(originalIndex, 1);
      blockQueue.unshift(nextBlockID);
    };
    // The entry must be first
    ctx.preferBlockToBeNext(func.entryBlockID);

    // In a first pass, we estimate the layout based on the maximum possible size
    // of each instruction. Instructions such as JUMP can take different forms
    // depending on the distance of the jump, and the distance of the JUMP in turn
    // depends on size of other instructions in between the jump origin and
    // target, which may include other jumps etc.
    let addressEstimate = 0;

    while (blockQueue.length) {
      const blockId = blockQueue.shift()!;
      const block = func.blocks[blockId];
      blockOutputOrder.push(blockId); // The same order will be used for subsequent passes

      switch (requireBlockAlignment.get(blockId)) {
        case undefined: break;
        // We don't know how much padding will be required, but it could be up to 1 byte.
        case '2-byte': addressEstimate += 1; break;
        // 4-minus-2-byte means 2 bytes ahead of a 4 byte boundary. Up to 3 bytes of padding could be required.
        case '4-minus-2-byte': addressEstimate += 3; break;
        default: unexpected();
      }

      // Within the context of this block, operations can request that certain other blocks should be next
      metaByBlock.set(blockId, {
        addressEstimate,
        address: undefined as any
      });
      for (const [operationIndex, op] of block.operations.entries()) {
        const { maxSize, emitPass2 } = emitPass1(emitter, ctx, op);
        const operationMeta: OperationMeta = {
          op,
          ilAddress: { type: 'ProgramAddressValue', funcId, blockId, operationIndex },
          addressEstimate,
          address: undefined as any,
          sizeEstimate: maxSize,
          size: undefined as any,
          emitPass2,
          emitPass3: undefined as any
        };
        metaByOperation.set(op, operationMeta);
        addressEstimate += maxSize;
      }
    }
    // After this pass, the order is fixed
    ctx.preferBlockToBeNext = undefined;
  }

  function pass2(isFinal: boolean) {
    // Pass2 is where we calculate the final block addresses

    let currentOperationMeta: OperationMeta;
    const ctx: Pass2Context = {
      get address() { return address },
      get ilAddress() { return currentOperationMeta.ilAddress; },
      isFinal,
      tentativeOffsetOfBlock: (blockId: IL.BlockID) => {
        const targetBlock = notUndefined(metaByBlock.get(blockId));
        const blockAddress = targetBlock.addressEstimate;
        const operationAddress = currentOperationMeta.addressEstimate;
        const operationSize = currentOperationMeta.sizeEstimate;
        const jumpFrom = operationAddress + operationSize;
        // The jump offset is measured from the end of the current operation, but
        // we don't know exactly how big it is so we take the worst case distance
        const maxOffset = (blockAddress > jumpFrom
          ? blockAddress - (jumpFrom - operationSize) // Most positive
          : blockAddress - jumpFrom); // Most negative
        return maxOffset;
      }
    };

    let address = 0;
    for (const blockId of blockOutputOrder) {
      const block = func.blocks[blockId];
      const blockMeta = notUndefined(metaByBlock.get(blockId));
      blockMeta.paddingBeforeBlock = 0;

      switch (requireBlockAlignment.get(blockId)) {
        case undefined: break;
        // In the second run of pass2, we know exactly how much padding to add
        case '2-byte': {
          if (isFinal) {
            if ((address & 1) === 1) {
              address += 1;
              blockMeta.paddingBeforeBlock = 1;
            }
          } else {
            // Assume padding because we don't know whether there will be or not
            // until the address is final
            address += 1;
            blockMeta.paddingBeforeBlock = 1; // Don't know whether to pad or not
          }
          break;
        }
        case '4-minus-2-byte': {
          if (isFinal) {
            // Padding to 2 less than a 4 byte boundary.
            const paddingAmount = (4 - ((address + 2) % 4)) % 4;
            if (paddingAmount) {
              address += paddingAmount;
              blockMeta.paddingBeforeBlock = paddingAmount;
            }
          } else {
            // Assume maximum padding because we don't know whether there will
            // be or not until the address is final
            address += 3;
            blockMeta.paddingBeforeBlock = 3; // Don't know whether to pad or not
          }
          break;
        }
        default: unexpected();
      }

      blockMeta.address = address;

      for (const op of block.operations) {
        const opMeta = notUndefined(metaByOperation.get(op));
        currentOperationMeta = opMeta;
        const pass2Output = opMeta.emitPass2(ctx);
        opMeta.emitPass3 = pass2Output.emitPass3;
        opMeta.size = pass2Output.size;
        if (opMeta.size > opMeta.sizeEstimate) { // WIP
          debugger;
          opMeta.emitPass2(ctx);
        }
        hardAssert(opMeta.size <= opMeta.sizeEstimate);
        opMeta.address = address;
        address += pass2Output.size;
      }
    }
  }

  function outputPass() {
    let currentOperationMeta: OperationMeta;
    const innerCtx: Pass3Context = {
      region: output,
      get address() { return currentOperationMeta.address },
      get absoluteAddress() { return output.currentOffset },
      offsetOfBlock(blockId: string): number {
        const targetBlock = notUndefined(metaByBlock.get(blockId));
        const blockAddress = targetBlock.address;
        const operationAddress = currentOperationMeta.address;
        const operationSize = currentOperationMeta.size;
        const jumpFrom = operationAddress + operationSize;
        const offset = blockAddress - jumpFrom;
        return offset;
      },

      addressOfBlock(blockId: string): Future<number> {
        const targetBlock = notUndefined(metaByBlock.get(blockId));
        const blockAddress = targetBlock.address;
        // The addresses here are actually relative to the function start
        return functionBodyStart.map(functionBodyStart => functionBodyStart + blockAddress);
      },

      declareResumePoint(ilAddress: IL.ProgramAddressValue, physicalAddress: Future<number>) {
        // This code seems a little crazy. So many layers of futures and
        // wrappers. Is it really all necessary?
        const ref = resumeReferences.get(programAddressToKey(ilAddress)) ?? unexpected();
        const referenceable: Future<Referenceable> = physicalAddress.map<Referenceable>(physicalAddress => {
          const ref: Referenceable = {
            offset: Future.create(physicalAddress),
            debugName: `Resume point (${ilAddress.funcId}, ${ilAddress.blockId}, ${ilAddress.operationIndex})`,
            getPointer(sourceRegion, debugName) {
              hardAssert(sourceRegion === 'bytecode');
              hardAssert((physicalAddress & 0xFFFC) === physicalAddress);
              // Bytecode pointer encoding
              const value = physicalAddress | 1;
              return Future.create(value)
            },
          }
          return ref;
        })
        ref.assign(referenceable);
      }
    };

    for (const blockId of blockOutputOrder) {
      const block = func.blocks[blockId];
      const blockMeta = metaByBlock.get(blockId) ?? unexpected();

      const alignment = requireBlockAlignment.get(blockId);
      switch (alignment) {
        case undefined: break;
        case '2-byte': {
          if (blockMeta.paddingBeforeBlock) {
            output.append(1, 'pad-to-even', formats.paddingRow);
          }
          output.currentOffset.map(o => hardAssert(o % 2 === 0));
          break;
        }
        case '4-minus-2-byte': {
          if (blockMeta.paddingBeforeBlock) {
            output.append(blockMeta.paddingBeforeBlock, 'pad-to-(4n-2)', formats.paddingRow);
          }
          output.currentOffset.map(o => hardAssert((4 - ((o + 2) % 4)) % 4 === 0));
          break;
        }
        default: assertUnreachable(alignment);
      }


      // Assert that the address we're actually putting the block at matches what we calculated
      output.currentOffset.map(o => functionBodyStart.map(s => o - s === blockMeta.address))

      ctx.addName(output.currentOffset, 'block', blockId);

      for (const op of block.operations) {
        const opMeta = notUndefined(metaByOperation.get(op));
        currentOperationMeta = opMeta;
        const offsetBefore = output.currentOffset;
        opMeta.emitPass3(innerCtx);
        const offsetAfter = output.currentOffset;
        offsetBefore.bind(offsetBefore_ => offsetAfter.map(offsetAfter => {
          const measuredSize = offsetAfter - offsetBefore_;
          hardAssert(measuredSize === opMeta.size, `Operation changed from committed size of ${opMeta.size} to ${measuredSize}. at ${offsetBefore_}, ${op}, ${output}`);
        }));
        if (op.sourceLoc) {
          ctx.sourceMapAdd?.({
            start: offsetBefore,
            end: offsetAfter,
            source: op.sourceLoc,
            op,
          });
        }
      }
    }
  }
}


interface OperationMeta {
  op: IL.Operation; // For debug purposes
  addressEstimate: number;
  address: number;
  ilAddress: IL.ProgramAddressValue;
  sizeEstimate: number;
  size: number;
  emitPass2: EmitPass2;
  emitPass3: EmitPass3;
};

interface BlockMeta {
  addressEstimate: number;
  address: number; // Address relative to function body
  paddingBeforeBlock?: number;
}

export interface FutureInstructionSourceMapping {
  start: Future<number>;
  end: Future<number>;
  source: IL.OperationSourceLoc;
  op: IL.Operation;
}

export interface InstructionEmitContext {
  getShortCallIndex(callInfo: CallInfo): number;
  offsetOfFunction: (id: IL.FunctionID) => Future<number>;
  indexOfGlobalSlot: (globalSlotID: VM.GlobalSlotID) => number;
  getImportIndexOfHostFunctionID: (hostFunctionID: IL.HostFunctionID) => HostFunctionIndex;
  encodeValue: (value: IL.Value) => FutureLike<mvm_Value>;
  preferBlockToBeNext?: (blockId: IL.BlockID) => void;
  addName(offset: Future, type: string, name: string): void;
  requireBlockToBeAligned?: (blockId: IL.BlockID, alignment: '2-byte') => void;
  sourceMapAdd?(mapping: FutureInstructionSourceMapping): void;
}

class InstructionEmitter {
  operationArrayNew(_ctx: InstructionEmitContext, op: IL.ArrayNewOperation) {
    return instructionEx2Unsigned(vm_TeOpcodeEx2.VM_OP2_ARRAY_NEW, (op.staticInfo && op.staticInfo.minCapacity) || 0, op);
  }

  operationBinOp(_ctx: InstructionEmitContext, op: IL.OtherOperation, param: IL.BinOpCode) {
    const [opcode1, opcode2] = ilBinOpCodeToVm[param];
    return instructionPrimary(opcode1, opcode2, op);
  }

  operationBranch(
    ctx: InstructionEmitContext,
    op: IL.Operation,
    consequentTargetBlockID: string,
    alternateTargetBlockID: string
  ): InstructionWriter {
    ctx.preferBlockToBeNext!(alternateTargetBlockID);
    // Note: branch IL instructions are a bit more complicated than most because
    // they consist of two bytecode instructions
    return {
      maxSize: 6,
      emitPass2: ctx => {
        let tentativeConseqOffset = ctx.tentativeOffsetOfBlock(consequentTargetBlockID);
        /* 😨😨😨 The offset is measured from the end of the bytecode
         * instruction, but since this is a composite instruction, we need to
         * compensate for the fact that we're branching from halfway through the
         * composite instruction.
         */
        if (tentativeConseqOffset < 0) {
          tentativeConseqOffset += 3; // 3 is the max size of the jump part of the composite instruction
        }

        const tentativeConseqOffsetIsFar = !isSInt8(tentativeConseqOffset);
        const sizeOfBranchInstr = tentativeConseqOffsetIsFar ? 3 : 2;

        const tentativeAltOffset = ctx.tentativeOffsetOfBlock(alternateTargetBlockID);
        const tentativeAltOffsetDistance = getJumpDistance(tentativeAltOffset);
        const sizeOfJumpInstr =
          tentativeAltOffsetDistance === 'far' ? 3 :
          tentativeAltOffsetDistance === 'close' ? 2 :
          tentativeAltOffsetDistance === 'zero' ? 0 :
          unexpected();

        const size = sizeOfBranchInstr + sizeOfJumpInstr;

        return {
          size,
          emitPass3: ctx => {
            let label = '';
            let binary: UInt8[] = [];
            const finalOffsetOfConseq = ctx.offsetOfBlock(consequentTargetBlockID) + sizeOfJumpInstr;
            const finalOffsetOfAlt = ctx.offsetOfBlock(alternateTargetBlockID);
            hardAssert(Math.abs(finalOffsetOfConseq) <= Math.abs(tentativeConseqOffset));
            hardAssert(Math.abs(finalOffsetOfAlt) <= Math.abs(tentativeAltOffset));

            // Stick to our committed shape for the BRANCH instruction
            if (tentativeConseqOffsetIsFar) {
              label += `VM_OP3_BRANCH_2(0x${finalOffsetOfConseq.toString(16)})`;
              binary.push(
                (vm_TeOpcode.VM_OP_EXTENDED_3 << 4) | vm_TeOpcodeEx3.VM_OP3_BRANCH_2,
                finalOffsetOfConseq & 0xFF,
                (finalOffsetOfConseq >> 8) & 0xFF
              )
            } else {
              label += `VM_OP2_BRANCH_1(0x${finalOffsetOfConseq.toString(16)})`;
              binary.push(
                (vm_TeOpcode.VM_OP_EXTENDED_2 << 4) | vm_TeOpcodeEx2.VM_OP2_BRANCH_1,
                finalOffsetOfConseq & 0xFF
              )
            }

            // Stick to our committed shape for the JUMP instruction
            switch (tentativeAltOffsetDistance) {
              case 'zero': break; // No instruction at all
              case 'close': {
                label += `, VM_OP2_JUMP_1(0x${finalOffsetOfAlt.toString(16)})`;
                binary.push(
                  (vm_TeOpcode.VM_OP_EXTENDED_2 << 4) | vm_TeOpcodeEx2.VM_OP2_JUMP_1,
                  finalOffsetOfAlt & 0xFF
                )
                break;
              }
              case 'far': {
                label += `, VM_OP3_JUMP_2(0x${finalOffsetOfAlt.toString(16)})`;
                binary.push(
                  (vm_TeOpcode.VM_OP_EXTENDED_3 << 4) | vm_TeOpcodeEx3.VM_OP3_JUMP_2,
                  finalOffsetOfAlt & 0xFF,
                  (finalOffsetOfAlt >> 8) & 0xFF
                )
                break;
              }
              default: assertUnreachable(tentativeAltOffsetDistance);
            }

            const html = escapeHTML(stringifyOperation(op));
            ctx.region.append({ binary: BinaryData(binary), html }, label, formats.preformatted2);
          }
        }
      }
    }
  }

  operationClosureNew(ctx: InstructionEmitContext, op: IL.Operation) {
    return instructionEx1(vm_TeOpcodeEx1.VM_OP1_CLOSURE_NEW, op);
  }

  operationCall(ctx: InstructionEmitContext, op: IL.CallOperation, argCount: number, isVoidCall: boolean) {
    const staticInfo = op.staticInfo;
    if (staticInfo?.target) {
      const target = staticInfo.target;
      if (target.type === 'FunctionValue') {
        const functionID = target.value;
        if (staticInfo.shortCall) {
          // Short calls are single-byte instructions that use a nibble to
          // reference into the short-call table, which provides the information
          // about the function target and argument count
          const shortCallIndex = ctx.getShortCallIndex({ type: 'InternalFunction', functionID: target.value, argCount });
          return instructionPrimary(vm_TeOpcode.VM_OP_CALL_1, shortCallIndex, op);
        } else {
          if (argCount <= 15) {
            const targetOffset = ctx.offsetOfFunction(functionID);
            return customInstruction(op, vm_TeOpcode.VM_OP_CALL_5, argCount, {
              type: 'UInt16',
              value: targetOffset
            });
          } else {
            /* Fall back to dynamic call */
          }
        }
      } else if (target.type === 'HostFunctionValue') {
        const hostFunctionID = target.value;
        const hostFunctionIndex = ctx.getImportIndexOfHostFunctionID(hostFunctionID);
        if (staticInfo.shortCall) {
          // Short calls are single-byte instructions that use a nibble to
          // reference into the short-call table, which provides the information
          // about the function target and argument count
          const shortCallIndex = ctx.getShortCallIndex({ type: 'HostFunction', hostFunctionIndex, argCount });
          return instructionPrimary(vm_TeOpcode.VM_OP_CALL_1, shortCallIndex, op);
        } else {
          return instructionEx2Unsigned(vm_TeOpcodeEx2.VM_OP2_CALL_HOST, hostFunctionIndex, op);
        }
      } else {
        return invalidOperation('Static call target can only be a function');
      }
    }

    argCount = UInt8(argCount);
    if (argCount > 127) {
      invalidOperation(`Too many arguments: ${argCount}`);
    }

    // The void-call flag is the high bit in the argument count
    const param = argCount | (isVoidCall ? 0x80 : 0);

    return instructionEx2Unsigned(vm_TeOpcodeEx2.VM_OP2_CALL_3, param, op);
  }

  operationNew(ctx: InstructionEmitContext, op: IL.CallOperation, argCount: number) {
    return customInstruction(op, vm_TeOpcode.VM_OP_EXTENDED_1, vm_TeOpcodeEx1.VM_OP1_NEW, {
      type: 'UInt8', value: UInt8(argCount)
    });
  }

  operationJump(ctx: InstructionEmitContext, op: IL.Operation, targetBlockId: string): InstructionWriter {
    ctx.preferBlockToBeNext!(targetBlockId);
    return {
      maxSize: 3,
      emitPass2: ctx => {
        const tentativeOffset = ctx.tentativeOffsetOfBlock(targetBlockId);
        const distance = getJumpDistance(tentativeOffset);
        const size = distance === 'zero' ? 0 :
          distance === 'close' ? 2 :
          distance === 'far' ? 3 :
          unexpected();
        return {
          size,
          emitPass3: ctx => {
            const offset = ctx.offsetOfBlock(targetBlockId);
            hardAssert(Math.abs(offset) <= Math.abs(tentativeOffset));
            // Stick to our committed shape
            switch (distance) {
              case 'zero': return; // Jumping to where we are already, so no instruction required
              case 'close': appendInstructionEx2Signed(ctx.region, vm_TeOpcodeEx2.VM_OP2_JUMP_1, offset, op); break;
              case 'far': appendInstructionEx3Signed(ctx.region, vm_TeOpcodeEx3.VM_OP3_JUMP_2, offset, op); break;
              default: return assertUnreachable(distance);
            }
          }
        }
      }
    }
  }

  operationScopePush(ctx: InstructionEmitContext, op: IL.Operation, count: number) {
    return customInstruction(op,
      vm_TeOpcode.VM_OP_EXTENDED_2,
      vm_TeOpcodeEx2.VM_OP2_EXTENDED_4,
      { type: 'UInt8', value: vm_TeOpcodeEx4.VM_OP4_SCOPE_PUSH },
      { type: 'UInt8', value: count },
    );
  }

  operationStartTry(ctx: InstructionEmitContext, op: IL.Operation, catchBlockId: string): InstructionWriter {
    ctx.requireBlockToBeAligned!(catchBlockId, '2-byte'); // WIP: this will need to change to 4n-2-byte alignment
    // The StartTry instruction is always 4 bytes
    const size = 4;
    return {
      maxSize: size,
      emitPass2: () => ({
        size,
        emitPass3: ctx => {
          const address = ctx.addressOfBlock(catchBlockId);
          // We already signalled above that the catch block must be 2-byte aligned
          address.map(address => hardAssert((address & 1) === 0));

          appendCustomInstruction(ctx.region, op, vm_TeOpcode.VM_OP_EXTENDED_2, vm_TeOpcodeEx2.VM_OP2_EXTENDED_4, {
            type: 'UInt8',
            value: vm_TeOpcodeEx4.VM_OP4_START_TRY
          }, {
            type: 'UInt16',
            value: address.map(address => address + 1) // Encode with a +1 so that when we push to the stack the GC will ignore it
          })
        }
      })
    }
  }

  operationEndTry(ctx: InstructionEmitContext, op: IL.Operation): InstructionWriter {
    return instructionEx4(vm_TeOpcodeEx4.VM_OP4_END_TRY, op);
  }

  operationScopeClone(ctx: InstructionEmitContext, op: IL.Operation) {
    return customInstruction(op, vm_TeOpcode.VM_OP_EXTENDED_3, vm_TeOpcodeEx3.VM_OP3_SCOPE_CLONE);
  }

  operationScopeDiscard(ctx: InstructionEmitContext, op: IL.Operation) {
    return customInstruction(op, vm_TeOpcode.VM_OP_EXTENDED_3, vm_TeOpcodeEx3.VM_OP3_SCOPE_DISCARD);
  }

  operationScopeNew(ctx: InstructionEmitContext, op: IL.Operation, count: number) {
    return customInstruction(op,
      vm_TeOpcode.VM_OP_EXTENDED_1,
      vm_TeOpcodeEx1.VM_OP1_SCOPE_NEW,
      { type: 'UInt8', value: count },
    );
  }

  operationScopePop(ctx: InstructionEmitContext, op: IL.Operation) {
    return customInstruction(op,
      vm_TeOpcode.VM_OP_EXTENDED_2,
      vm_TeOpcodeEx2.VM_OP2_EXTENDED_4,
      { type: 'UInt8', value: vm_TeOpcodeEx4.VM_OP4_SCOPE_POP }
    );
  }

  operationScopeSave(ctx: InstructionEmitContext, op: IL.Operation) {
    return customInstruction(op,
      vm_TeOpcode.VM_OP_EXTENDED_2,
      vm_TeOpcodeEx2.VM_OP2_EXTENDED_4,
      { type: 'UInt8', value: vm_TeOpcodeEx4.VM_OP4_SCOPE_SAVE }
    );
  }

  operationClassCreate(ctx: InstructionEmitContext, op: IL.Operation) {
    return instructionEx4(vm_TeOpcodeEx4.VM_OP4_CLASS_CREATE, op);
  }

  operationAsyncReturn(ctx: InstructionEmitContext, op: IL.Operation) {
    return instructionEx4(vm_TeOpcodeEx4.VM_OP4_ASYNC_RETURN, op);
  }

  operationAsyncComplete(ctx: InstructionEmitContext, op: IL.Operation) {
    return instructionEx4(vm_TeOpcodeEx4.VM_OP4_ASYNC_COMPLETE, op);
  }

  operationAsyncResume(outerCtx: InstructionEmitContext, op: IL.Operation, slotCount: number, catchTarget: number): InstructionWriter {
    /*
    The VM_OP3_ASYNC_RESUME instruction is the first instruction to be executed
    in the continuation of an async function. In the bytecode, to make the
    resume instruction callback, its address must be aligned to 4 bytes and it
    must be preceded by a function header.
    */
    return {
      maxSize:
        + 3 // 0-3 bytes padding for function header
        + 2 // 2 bytes for function header
        + 3 // 3 byte for VM_OP3_ASYNC_RESUME instruction
      ,
      emitPass2: ctx => {
        const containingFunctionOffset = outerCtx.offsetOfFunction(ctx.ilAddress.funcId);
        const ilAddress = ctx.ilAddress;

        // Address aligned such that the _end_ of the function header is 4-byte
        // aligned.
        const alignedAddress = ((ctx.address + 3 + 2) & 0xFFFC) - 2;
        const padding = ctx.isFinal
          ? alignedAddress - ctx.address
          : 3; // If the positioning is not final, the padding could increase later so assume worst
        hardAssert(padding >= 0 && padding <= 3);
        const size =
          + padding
          + 2 // function header
          + 3 // VM_OP3_ASYNC_RESUME instruction
        return {
          size,
          emitPass3: ctx => {
            ctx.region.append(padding, 'Padding before function header', formats.paddingRow);
            const currentAddress: Future<number> = ctx.absoluteAddress;
            const functionHeaderWord = containingFunctionOffset.bind(containingFunctionOffset =>
              currentAddress.map(currentAddress => {
                const backDistance = currentAddress + 2 - containingFunctionOffset;
                hardAssert(backDistance > 0 && backDistance % 4 === 0);
                hardAssert((backDistance & 0x1FFC) === backDistance)
                const functionHeaderWord = 0
                  | TeTypeCode.TC_REF_FUNCTION << 12 // TypeCode
                  | 1 << 11 // Flag to indicate continuation function
                  | backDistance >> 2 // Encodes number of quad-words to go back to find the original function
                return functionHeaderWord;
              }))
            ctx.region.append(functionHeaderWord, 'Continuation header', formats.uHex16LERow);
            // Note: the address of the resume point is the address after the
            // function header, which is also the address of the resume
            // instruction itself. We need to associate the logical IL address
            // with the absolute bytecode address that satisfies it.
            ctx.declareResumePoint(ilAddress, ctx.absoluteAddress);
            const html = escapeHTML(stringifyOperation(op));
            const binary = [
              UInt4(vm_TeOpcodeEx3.VM_OP3_ASYNC_RESUME) |
              (UInt4(vm_TeOpcode.VM_OP_EXTENDED_3) << 4),
              UInt8(slotCount),
              UInt8(catchTarget),
            ];
            ctx.region.append({ html, binary },
              `VM_OP3_ASYNC_RESUME(${slotCount})`,
              formats.preformatted(3)
            );
          }
        }
      }
    }
  }

  operationAwaitCall(ctx: InstructionEmitContext, op: IL.Operation, argCount: number) {
    return customInstruction(op, vm_TeOpcode.VM_OP_EXTENDED_3, vm_TeOpcodeEx3.VM_OP3_AWAIT_CALL,
      { type: 'UInt8', value: UInt7(argCount) });
  }

  operationAwait(ctx: InstructionEmitContext, op: IL.Operation) {
    return customInstruction(op, vm_TeOpcode.VM_OP_EXTENDED_3, vm_TeOpcodeEx3.VM_OP3_AWAIT);
  }

  operationAsyncStart(ctx: InstructionEmitContext, op: IL.Operation, slotCount: number, captureParent: boolean) {
    const param = UInt7(slotCount) | (captureParent ? 0x80 : 0);
    return customInstruction(op,
      vm_TeOpcode.VM_OP_EXTENDED_2,
      vm_TeOpcodeEx2.VM_OP2_EXTENDED_4,
      { type: 'UInt8', value: vm_TeOpcodeEx4.VM_OP4_ASYNC_START },
      { type: 'UInt8', value: param },
    );
  }

  operationTypeCodeOf(ctx: InstructionEmitContext, op: IL.Operation) {
    return instructionEx4(vm_TeOpcodeEx4.VM_OP4_TYPE_CODE_OF, op);
  }

  operationLiteral(ctx: InstructionEmitContext, op: IL.Operation, param: IL.Value) {
    const smallLiteralCode = tryGetSmallLiteralCode(param);
    if (smallLiteralCode !== undefined) {
      return instructionPrimary(vm_TeOpcode.VM_OP_LOAD_SMALL_LITERAL, smallLiteralCode, op);
    } else {
      return instructionEx3Unsigned(vm_TeOpcodeEx3.VM_OP3_LOAD_LITERAL, ctx.encodeValue(param), op);
    }

    function tryGetSmallLiteralCode(param: IL.Value): vm_TeSmallLiteralValue | undefined {
      switch (param.type) {
        case 'NullValue': return vm_TeSmallLiteralValue.VM_SLV_NULL;
        case 'UndefinedValue': return vm_TeSmallLiteralValue.VM_SLV_UNDEFINED;
        case 'NumberValue':
          if (Object.is(param.value, -0)) return undefined;
          switch (param.value) {
            case -1: return vm_TeSmallLiteralValue.VM_SLV_INT_MINUS_1;
            case 0: return vm_TeSmallLiteralValue.VM_SLV_INT_0;
            case 1: return vm_TeSmallLiteralValue.VM_SLV_INT_1;
            case 2: return vm_TeSmallLiteralValue.VM_SLV_INT_2;
            case 3: return vm_TeSmallLiteralValue.VM_SLV_INT_3;
            case 4: return vm_TeSmallLiteralValue.VM_SLV_INT_4;
            case 5: return vm_TeSmallLiteralValue.VM_SLV_INT_5;
            default: return undefined;
          }
        case 'StringValue':
          return undefined;
        case 'BooleanValue':
          return param.value
            ? vm_TeSmallLiteralValue.VM_SLV_TRUE
            : vm_TeSmallLiteralValue.VM_SLV_FALSE;
        case 'EphemeralFunctionValue':
        case 'EphemeralObjectValue':
        case 'ClassValue':
        case 'FunctionValue':
        case 'HostFunctionValue':
        case 'DeletedValue':
        case 'ReferenceValue':
        case 'ProgramAddressValue':
        case 'ResumePoint':
        case 'NoOpFunction':
          return undefined;
        default:
          return assertUnreachable(param);
      }
    }
  }

  operationLoadArg(_ctx: InstructionEmitContext, op: IL.Operation, index: number) {
    if (isUInt4(index)) {
      return instructionPrimary(vm_TeOpcode.VM_OP_LOAD_ARG_1, index, op);
    } else {
      hardAssert(isUInt8(index));
      return instructionEx2Unsigned(vm_TeOpcodeEx2.VM_OP2_LOAD_ARG_2, index, op);
    }
  }

  operationLoadGlobal(ctx: InstructionEmitContext, op: IL.Operation, globalSlotID: VM.GlobalSlotID) {
    const slotIndex = ctx.indexOfGlobalSlot(globalSlotID);
    return instructionEx3Unsigned(vm_TeOpcodeEx3.VM_OP3_LOAD_GLOBAL_3, slotIndex, op);
  }

  operationArrayGet(_ctx: InstructionEmitContext, _op: IL.Operation) {
    // The ArrayGet operation can only really be emitted by an optimizer,
    // otherwise normal functioning will just use `ObjectGet`. So we
    // don't support this yet.
    return notImplemented();
  }

  operationArraySet(_ctx: InstructionEmitContext, _op: IL.Operation) {
    // The ArraySet operation can only really be emitted by an optimizer,
    // otherwise normal functioning will just use `ObjectSet`. So we
    // don't support this yet.
    return notImplemented();
  }

  operationLoadScoped(ctx: InstructionEmitContext, op: IL.Operation, index: number) {
    if (isUInt4(index)) {
      return instructionPrimary(vm_TeOpcode.VM_OP_LOAD_SCOPED_1, index, op);
    } else if (isUInt8(index)) {
      return instructionEx2Unsigned(vm_TeOpcodeEx2.VM_OP2_LOAD_SCOPED_2, index, op);
    } else if (isUInt16(index)) {
      return instructionEx3Unsigned(vm_TeOpcodeEx3.VM_OP3_LOAD_SCOPED_3, index, op);
    } else {
      return unexpected();
    }
  }

  operationLoadVar(ctx: InstructionEmitContext, op: IL.Operation, index: number) {
    // In the IL, the index is relative to the stack base, while in the
    // bytecode, it's relative to the stack pointer
    const positionRelativeToSP = op.stackDepthBefore - index - 1;
    if (isUInt4(positionRelativeToSP)) {
      return instructionPrimary(vm_TeOpcode.VM_OP_LOAD_VAR_1, positionRelativeToSP, op);
    } if (isUInt8(positionRelativeToSP)) {
      return instructionEx2Unsigned(vm_TeOpcodeEx2.VM_OP2_LOAD_VAR_2, positionRelativeToSP, op);
    } else {
      return invalidOperation('Variable index out of bounds: ' + index);
    }
  }

  operationLoadReg(ctx: InstructionEmitContext, op: IL.Operation, name: string) {
    switch (name) {
      case 'closure': return instructionEx4(vm_TeOpcodeEx4.VM_OP4_LOAD_REG_CLOSURE, op);
      default: unexpected();
    }
  }

  operationNop(_ctx: InstructionEmitContext, op: IL.Operation, nopSize: number) {
    if (nopSize < 2) return invalidOperation('Cannot have less than 2-byte NOP instruction');
    return fixedSizeInstruction(nopSize, region => {
      if (nopSize === 2) {
        // JUMP (0)
        appendInstructionEx2Signed(region, vm_TeOpcodeEx2.VM_OP2_JUMP_1, 0, op);
        return;
      }
      // JUMP
      const offset = nopSize - 3; // The nop size less the size of the jump
      hardAssert(isSInt16(offset));
      const label = `VM_OP3_JUMP_2(${offset})`;
      const value = Future.map(offset, offset => {
        const html = escapeHTML(stringifyOperation(op));
        const binary = [
          (vm_TeOpcode.VM_OP_EXTENDED_3 << 4) | vm_TeOpcodeEx3.VM_OP3_JUMP_2,
          offset & 0xFF,
          (offset >> 8) & 0xFF
        ];
        while (binary.length < nopSize) binary.push(0);
        return { html, binary };
      });
      region.append(value, label, formats.preformatted3);
    });
  }

  operationObjectGet(_ctx: InstructionEmitContext, op: IL.Operation) {
    return instructionEx1(vm_TeOpcodeEx1.VM_OP1_OBJECT_GET_1, op);
  }

  operationObjectNew(_ctx: InstructionEmitContext, op: IL.Operation) {
    return instructionEx1(vm_TeOpcodeEx1.VM_OP1_OBJECT_NEW, op);
  }

  operationObjectSet(_ctx: InstructionEmitContext, op: IL.Operation) {
    return instructionEx1(vm_TeOpcodeEx1.VM_OP1_OBJECT_SET_1, op);
  }

  operationPop(_ctx: InstructionEmitContext, op: IL.Operation, count: number) {
    if (count > 1) {
      return customInstruction(op, vm_TeOpcode.VM_OP_EXTENDED_3, vm_TeOpcodeEx3.VM_OP3_POP_N, { type: 'UInt8', value: count })
    } else {
      return instructionEx1(vm_TeOpcodeEx1.VM_OP1_POP, op);
    }
  }

  operationReturn(_ctx: InstructionEmitContext, op: IL.Operation) {
    if (op.opcode !== 'Return') return unexpected();
    return instructionEx1(vm_TeOpcodeEx1.VM_OP1_RETURN, op);
  }

  operationThrow(_ctx: InstructionEmitContext, op: IL.Operation) {
    if (op.opcode !== 'Throw') return unexpected();
    return instructionEx1(vm_TeOpcodeEx1.VM_OP1_THROW, op);
  }

  operationObjectKeys(_ctx: InstructionEmitContext, op: IL.Operation) {
    if (op.opcode !== 'ObjectKeys') return unexpected();
    return instructionEx4(vm_TeOpcodeEx4.VM_OP4_OBJECT_KEYS, op);
  }

  operationUint8ArrayNew(_ctx: InstructionEmitContext, op: IL.Operation) {
    if (op.opcode !== 'Uint8ArrayNew') return unexpected();
    return instructionEx4(vm_TeOpcodeEx4.VM_OP4_UINT8_ARRAY_NEW, op);
  }

  operationStoreGlobal(ctx: InstructionEmitContext, op: IL.Operation, globalSlotID: VM.GlobalSlotID) {
    const index = ctx.indexOfGlobalSlot(globalSlotID);
    hardAssert(isUInt16(index));
    return instructionEx3Unsigned(vm_TeOpcodeEx3.VM_OP3_STORE_GLOBAL_3, index, op);
  }

  operationStoreScoped(ctx: InstructionEmitContext, op: IL.Operation, index: number) {
    if (isUInt4(index)) {
      return instructionPrimary(vm_TeOpcode.VM_OP_STORE_SCOPED_1, index, op);
    } else if (isUInt8(index)) {
      return instructionEx2Unsigned(vm_TeOpcodeEx2.VM_OP2_STORE_SCOPED_2, index, op);
    } else {
      hardAssert(isUInt16(index));
      return instructionEx3Unsigned(vm_TeOpcodeEx3.VM_OP3_STORE_SCOPED_3, index, op);
    }
  }

  operationStoreVar(_ctx: InstructionEmitContext, op: IL.OtherOperation, index: number) {
    // Note: the index is relative to the stack depth _after_ popping
    const indexRelativeToSP = op.stackDepthBefore - 2 - index;
    if (isUInt4(indexRelativeToSP)) {
      return instructionPrimary(vm_TeOpcode.VM_OP_STORE_VAR_1, indexRelativeToSP, op)
    }
    if (!isUInt8(indexRelativeToSP)) {
      return invalidOperation('Too many stack variables');
    }
    return instructionEx2Unsigned(vm_TeOpcodeEx2.VM_OP2_STORE_VAR_2, indexRelativeToSP, op)
  }

  operationUnOp(_ctx: InstructionEmitContext, op: IL.OtherOperation, param: IL.UnOpCode) {
    const [opcode1, opcode2] = ilUnOpCodeToVm[param];
    return instructionPrimary(opcode1, opcode2, op);
  }

  operationEnqueueJob(_ctx: InstructionEmitContext, op: IL.OtherOperation) {
    return instructionEx4(vm_TeOpcodeEx4.VM_OP4_ENQUEUE_JOB, op);
  }
}

interface InstructionWriter {
  maxSize: number;
  requireAlignment?: '2-byte';
  emitPass2: EmitPass2;
}

type EmitPass2 = (ctx: Pass2Context) => EmitPass2Output;

interface EmitPass2Output {
  size: number;
  emitPass3: EmitPass3;
}

type EmitPass3 = (ctx: Pass3Context) => void;

interface Pass2Context {
  isFinal: boolean;
  address: number; // For debug purposes
  ilAddress: IL.ProgramAddressValue;
  // Estimated Offset relative to address after the current operation
  tentativeOffsetOfBlock(blockId: string): number;
}

interface Pass3Context {
  region: BinaryRegion;
  address: number; // Address in function (debug purposes)
  absoluteAddress: Future<number>; // Address in bytecode
  // Offset relative to address after the current operation
  offsetOfBlock(blockId: string): number;
  // Absolute address of the target block as a 16-bit unsigned number
  addressOfBlock(blockId: string): Future<number>;
  // Associate an IL address with the corresponding physical address. At the
  // moment this is only to resolve resume points
  declareResumePoint(ilAddress: IL.ProgramAddressValue, physicalAddress: Future<number>): void;
}

function instructionPrimary(opcode: vm_TeOpcode, param: UInt4, op: IL.Operation): InstructionWriter {
  hardAssert(isUInt4(opcode));
  hardAssert(isUInt4(param));
  const label = `${vm_TeOpcode[opcode]}(0x${param.toString(16)})`;
  const html = escapeHTML(stringifyOperation(op));
  const binary = BinaryData([(opcode << 4) | param]);
  return fixedSizeInstruction(1, r => r.append({ binary, html }, label, formats.preformatted1));
}

function instructionEx1(opcode: vm_TeOpcodeEx1, op: IL.Operation): InstructionWriter {
  return fixedSizeInstruction(1, r => appendInstructionEx1(r, opcode, op));
}

function appendInstructionEx1(region: BinaryRegion, opcode: vm_TeOpcodeEx1, op: IL.Operation): void {
  appendCustomInstruction(region, op, vm_TeOpcode.VM_OP_EXTENDED_1, opcode);
}

function instructionEx2Unsigned(opcode: vm_TeOpcodeEx2, param: UInt8, op: IL.Operation): InstructionWriter {
  return fixedSizeInstruction(2, r => appendInstructionEx2Unsigned(r, opcode, param, op));
}

function appendInstructionEx2Signed(region: BinaryRegion, opcode: vm_TeOpcodeEx2, param: SInt8, op: IL.Operation) {
  appendCustomInstruction(region, op, vm_TeOpcode.VM_OP_EXTENDED_2, opcode, { type: 'SInt8', value: param });
}

function appendInstructionEx2Unsigned(region: BinaryRegion, opcode: vm_TeOpcodeEx2, param: UInt8, op: IL.Operation) {
  appendCustomInstruction(region, op, vm_TeOpcode.VM_OP_EXTENDED_2, opcode, { type: 'UInt8', value: param });
}

function instructionEx3Unsigned(opcode: vm_TeOpcodeEx3, param: FutureLike<UInt16>, op: IL.Operation): InstructionWriter {
  return fixedSizeInstruction(3, r => appendInstructionEx3Unsigned(r, opcode, param, op));
}

function appendInstructionEx3Signed(region: BinaryRegion, opcode: vm_TeOpcodeEx3, param: SInt16, op: IL.Operation) {
  appendCustomInstruction(region, op, vm_TeOpcode.VM_OP_EXTENDED_3, opcode, { type: 'SInt16', value: param });
}

function appendInstructionEx3Unsigned(region: BinaryRegion, opcode: vm_TeOpcodeEx3, param: FutureLike<UInt16>, op: IL.Operation) {
  appendCustomInstruction(region, op, vm_TeOpcode.VM_OP_EXTENDED_3, opcode, { type: 'UInt16', value: param });
}

function appendInstructionEx4(region: BinaryRegion, opcode: vm_TeOpcodeEx4, op: IL.Operation) {
  appendCustomInstruction(region, op, vm_TeOpcode.VM_OP_EXTENDED_2, vm_TeOpcodeEx2.VM_OP2_EXTENDED_4, {
    type: 'UInt8',
    value: opcode
  })
}

function instructionEx4(opcode: vm_TeOpcodeEx4, op: IL.Operation): InstructionWriter {
  return fixedSizeInstruction(2, r => appendInstructionEx4(r, opcode, op));
}

type InstructionPayloadPart =
  | { type: 'UInt8', value: FutureLike<number> }
  | { type: 'SInt8', value: FutureLike<number> }
  | { type: 'UInt16', value: FutureLike<number> }
  | { type: 'SInt16', value: FutureLike<number> }

export function customInstruction(op: IL.Operation, nibble1: vm_TeOpcode, nibble2: UInt4, ...payload: InstructionPayloadPart[]): InstructionWriter {
  let size: number = 1;
  for (const payloadPart of payload) {
    switch (payloadPart.type) {
      case 'UInt8': size += 1; break;
      case 'SInt8': size += 1; break;
      case 'UInt16': size += 2; break;
      case 'SInt16': size += 2; break;
      default: return assertUnreachable(payloadPart);
    }
  }
  return fixedSizeInstruction(size, r => appendCustomInstruction(r, op, nibble1, nibble2, ...payload));
}

export function appendCustomInstruction(region: BinaryRegion, op: IL.Operation, nibble1: vm_TeOpcode, nibble2: UInt4, ...payload: InstructionPayloadPart[]) {
  hardAssert(isUInt4(nibble1));
  hardAssert(isUInt4(nibble2));
  let nibble1Label = vm_TeOpcode[nibble1];
  let nibble2Label: string;
  switch (nibble1) {
    case vm_TeOpcode.VM_OP_EXTENDED_1: nibble2Label = vm_TeOpcodeEx1[nibble2]; break;
    case vm_TeOpcode.VM_OP_EXTENDED_2: nibble2Label = vm_TeOpcodeEx2[nibble2]; break;
    case vm_TeOpcode.VM_OP_EXTENDED_3: nibble2Label = vm_TeOpcodeEx3[nibble2]; break;
    case vm_TeOpcode.VM_OP_BIT_OP: nibble2Label = vm_TeBitwiseOp[nibble2]; break;
    case vm_TeOpcode.VM_OP_NUM_OP: nibble2Label = vm_TeNumberOp[nibble2]; break;
    case vm_TeOpcode.VM_OP_LOAD_SMALL_LITERAL: nibble2Label = vm_TeSmallLiteralValue[nibble2]; break;
    default: nibble2Label = `0x${nibble2.toString(16)}`; break;
  }

  const label = `${nibble1Label}(${nibble2Label})`;
  let size: number = 1;
  for (const payloadPart of payload) {
    switch (payloadPart.type) {
      case 'UInt8': size += 1; break;
      case 'SInt8': size += 1; break;
      case 'UInt16': size += 2; break;
      case 'SInt16': size += 2; break;
      default: return assertUnreachable(payloadPart);
    }
  }

  const html = escapeHTML(stringifyOperation(op));
  let binary: FutureLike<BinaryData> = [(UInt4(nibble1) << 4) | UInt4(nibble2)];

  for (const payloadPart of payload) {
    binary = Future.bind(binary, binary => {
      const binaryPart = instructionPartToBinary(payloadPart);
      return Future.bind(binaryPart, binaryPart => [...binary, ...binaryPart])
    })
  }

  const value = Future.map(binary, binary => ({ html, binary }));

  region.append(value, label, formats.preformatted(size));

  function instructionPartToBinary(part: InstructionPayloadPart): FutureLike<BinaryData> {
    return Future.map(part.value, partValue => {
      switch (part.type) {
        case 'UInt8': return formats.binaryFormats.uInt8(partValue);
        case 'SInt8': return formats.binaryFormats.sInt8(partValue);
        case 'UInt16': return formats.binaryFormats.uInt16LE(partValue);
        case 'SInt16': return formats.binaryFormats.sInt16LE(partValue);
        default: return assertUnreachable(part);
      }
    })
  }
}

function fixedSizeInstruction(size: number, write: (region: BinaryRegion) => void): InstructionWriter {
  return {
    maxSize: size,
    emitPass2: () => ({
      size,
      emitPass3: ctx => write(ctx.region)
    })
  }
}

const instructionNotImplemented: InstructionWriter = {
  maxSize: 1,
  emitPass2: () => ({
    size: 1,
    emitPass3: ctx => ctx.region.append(undefined, undefined, instructionNotImplementedFormat)
  })
}

const instructionNotImplementedFormat: Format<Labelled<undefined>> = {
  binaryFormat: () => [0],
  htmlFormat: formats.tableRow(() => 'Instruction not implemented')
}

const ilUnOpCodeToVm: Record<IL.UnOpCode, [vm_TeOpcode, vm_TeOpcodeEx1 | vm_TeNumberOp | vm_TeBitwiseOp]> = {
  ["-"]: [vm_TeOpcode.VM_OP_NUM_OP    , vm_TeNumberOp.VM_NUM_OP_NEGATE    ],
  ["+"]: [vm_TeOpcode.VM_OP_NUM_OP    , vm_TeNumberOp.VM_NUM_OP_UNARY_PLUS],
  ["!"]: [vm_TeOpcode.VM_OP_EXTENDED_1, vm_TeOpcodeEx1.VM_OP1_LOGICAL_NOT ],
  ["~"]: [vm_TeOpcode.VM_OP_BIT_OP    , vm_TeBitwiseOp.VM_BIT_OP_NOT      ],
  ["typeof"]: [vm_TeOpcode.VM_OP_EXTENDED_1, vm_TeOpcodeEx1.VM_OP1_TYPEOF],
  ["typeCodeOf"]: [vm_TeOpcode.VM_OP_EXTENDED_1, vm_TeOpcodeEx1.VM_OP1_TYPE_CODE_OF],
}

const ilBinOpCodeToVm: Record<IL.BinOpCode, [vm_TeOpcode, vm_TeOpcodeEx1 | vm_TeNumberOp | vm_TeBitwiseOp]> = {
  // Polymorphic ops
  ['+'  ]: [vm_TeOpcode.VM_OP_EXTENDED_1, vm_TeOpcodeEx1.VM_OP1_ADD              ],
  ['===']: [vm_TeOpcode.VM_OP_EXTENDED_1, vm_TeOpcodeEx1.VM_OP1_EQUAL            ],
  ['!==']: [vm_TeOpcode.VM_OP_EXTENDED_1, vm_TeOpcodeEx1.VM_OP1_NOT_EQUAL        ],

  // Number ops
  ['-'  ]: [vm_TeOpcode.VM_OP_NUM_OP    , vm_TeNumberOp.VM_NUM_OP_SUBTRACT       ],
  ['/'  ]: [vm_TeOpcode.VM_OP_NUM_OP    , vm_TeNumberOp.VM_NUM_OP_DIVIDE         ],
  ['DIVIDE_AND_TRUNC']: [vm_TeOpcode.VM_OP_NUM_OP, vm_TeNumberOp.VM_NUM_OP_DIVIDE_AND_TRUNC],
  ['%'  ]: [vm_TeOpcode.VM_OP_NUM_OP    , vm_TeNumberOp.VM_NUM_OP_REMAINDER      ],
  ['*'  ]: [vm_TeOpcode.VM_OP_NUM_OP    , vm_TeNumberOp.VM_NUM_OP_MULTIPLY       ],
  ['**' ]: [vm_TeOpcode.VM_OP_NUM_OP    , vm_TeNumberOp.VM_NUM_OP_POWER          ],
  ['<'  ]: [vm_TeOpcode.VM_OP_NUM_OP    , vm_TeNumberOp.VM_NUM_OP_LESS_THAN      ],
  ['>'  ]: [vm_TeOpcode.VM_OP_NUM_OP    , vm_TeNumberOp.VM_NUM_OP_GREATER_THAN   ],
  ['<=' ]: [vm_TeOpcode.VM_OP_NUM_OP    , vm_TeNumberOp.VM_NUM_OP_LESS_EQUAL     ],
  ['>=' ]: [vm_TeOpcode.VM_OP_NUM_OP    , vm_TeNumberOp.VM_NUM_OP_GREATER_EQUAL  ],

  // Bitwise ops
  ['>>' ]: [vm_TeOpcode.VM_OP_BIT_OP    , vm_TeBitwiseOp.VM_BIT_OP_SHR_ARITHMETIC],
  ['>>>']: [vm_TeOpcode.VM_OP_BIT_OP    , vm_TeBitwiseOp.VM_BIT_OP_SHR_LOGICAL   ],
  ['<<' ]: [vm_TeOpcode.VM_OP_BIT_OP    , vm_TeBitwiseOp.VM_BIT_OP_SHL           ],
  ['&'  ]: [vm_TeOpcode.VM_OP_BIT_OP    , vm_TeBitwiseOp.VM_BIT_OP_AND           ],
  ['|'  ]: [vm_TeOpcode.VM_OP_BIT_OP    , vm_TeBitwiseOp.VM_BIT_OP_OR            ],
  ['^'  ]: [vm_TeOpcode.VM_OP_BIT_OP    , vm_TeBitwiseOp.VM_BIT_OP_XOR           ],

  // Note: Logical AND and OR are implemented via the BRANCH opcode
}

function getJumpDistance(offset: SInt16) {
  const distance: 'zero' | 'close' | 'far' =
    offset === 0 ? 'zero' :
    isSInt8(offset) ? 'close' :
    'far';
  return distance;
}

function emitPass1(emitter: InstructionEmitter, ctx: InstructionEmitContext, op: IL.Operation): InstructionWriter {
  const operationMeta = IL.opcodes[op.opcode];
  if (!operationMeta) {
    return invalidOperation(`Unknown opcode "${op.opcode}".`);
  }
  const operands = op.operands.map((o, i) =>
    resolveOperand(o, operationMeta.operands[i] as IL.OperandType));

  const method = emitter[`operation${op.opcode}`];
  if (!method) {
    return notImplemented(`Opcode not implemented in bytecode emitter: "${op.opcode}"`)
  }
  if (method.length === 0) {
    return notImplemented('Implement opcode emitter: ' + op.opcode);
  }
  if (operands.length !== method.length - 2) {
    return unexpected();
  }

  return method.call(emitter, ctx, op, ...operands);
}

function resolveOperand(operand: IL.Operand, expectedType: IL.OperandType) {
  switch (expectedType) {
    case 'LabelOperand':
      if (operand.type !== 'LabelOperand') {
        return invalidOperation('Expected label operand');
      }
      return operand.targetBlockId;
    case 'CountOperand':
      if (operand.type !== 'CountOperand') {
        return invalidOperation('Expected count operand');
      }
      return operand.count;
    case 'IndexOperand':
      if (operand.type !== 'IndexOperand') {
        return invalidOperation('Expected index operand');
      }
      return operand.index;
    case 'NameOperand':
      if (operand.type !== 'NameOperand') {
        return invalidOperation('Expected name operand');
      }
      return operand.name;
    case 'LiteralOperand':
      if (operand.type !== 'LiteralOperand') {
        return invalidOperation('Expected literal operand');
      }
      return operand.literal;
    case 'OpOperand':
      if (operand.type !== 'OpOperand') {
        return invalidOperation('Expected sub-operation operand');
      }
      return operand.subOperation;
    case 'FlagOperand':
      if (operand.type !== 'FlagOperand') {
        return invalidOperation('Expected flag operand');
      }
      return operand.flag;
    default: assertUnreachable(expectedType);
  }
}

export type CallInfo = {
  type: 'InternalFunction'
  functionID: IL.FunctionID,
  argCount: UInt8
} | {
  type: 'HostFunction'
  hostFunctionIndex: HostFunctionIndex,
  argCount: UInt8
};

type HostFunctionIndex = number;

// For debugging
function dumpInstructionEmitData(
  filename: string,
  func: IL.Function,
  blockOutputOrder: string[],
  metaByOperation: Map<IL.Operation, OperationMeta>,
  metaByBlock: Map<IL.BlockID, BlockMeta>,
) {
  const result: string[] = [];
  result.push(`Function ${func.id} from ${func.sourceFilename}`)

  for (const blockId of blockOutputOrder) {
    const block = func.blocks[blockId];
    const blockMeta = notUndefined(metaByBlock.get(blockId));
    let line = `Block ${blockId}`;
    if (blockMeta.address !== undefined) line = `${blockMeta.address.toString().padStart(4, '0')} ${line}`;
    if (blockMeta.addressEstimate !== undefined) line += ` est ${blockMeta.addressEstimate}`;
    if (blockMeta.paddingBeforeBlock !== undefined) line += ` ${blockMeta.paddingBeforeBlock ? 'padded' : 'not-padded'}`;
    result.push(`  ${line}`);

    for (const op of block.operations) {
      const opMeta = notUndefined(metaByOperation.get(op));
      line = `${op.opcode}`
      if (opMeta.address !== undefined) line = `${opMeta.address.toString().padStart(4, '0')} ${line}`;
      if (opMeta.addressEstimate !== undefined) line += ` est ${opMeta.addressEstimate}`;
      if (op.sourceLoc !== undefined) line += ` ${formatSourceLoc(op.sourceLoc)}`;
      result.push(`    ${line}`)
    }
  }

  fs.writeFileSync(filename, result.join('\n'))
}