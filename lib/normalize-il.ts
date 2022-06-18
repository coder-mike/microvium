import { IL, SnapshotIL } from "../lib";
import _ from 'lodash';
import { blockTerminatingOpcodes, labelOperandsOfOperation } from "./il-opcodes";
import { entriesInOrder, hardAssert, notUndefined, unexpected } from "./utils";

export interface NormalizeILOpts {
  cullUnreachableBlocks?: boolean;
  cullUnreachableInstructions?: boolean;
  inlineUnnecessaryJumps?: boolean;
}

/**
 * Normalize IL for the purposes of comparison during testing
 */
export function normalizeIL(unit: SnapshotIL, opts: NormalizeILOpts = {}): SnapshotIL {
  opts = {
    cullUnreachableBlocks: true,
    cullUnreachableInstructions: true,
    inlineUnnecessaryJumps: true,
    ...opts
  }
  return {
    ...unit,
    functions: new Map(entriesInOrder(unit.functions).map(([funcID, func]) =>
      [funcID, normalizeFunction(func)]))
  }

  function normalizeFunction(func: IL.Function): IL.Function {
    let blocks = func.blocks;

    if (opts.cullUnreachableBlocks) {
      blocks = cullUnreachableBlocks(blocks, func.entryBlockID);
    }

    if (opts.cullUnreachableInstructions) {
      blocks = cullUnreachableInstructions(blocks);
    }

    if (opts.inlineUnnecessaryJumps) {
      blocks = inlineUnnecessaryJumps(blocks);
    }

    return { ...func, blocks }
  }
}

function cullUnreachableBlocks(blocks: IL.Function['blocks'], entryBlockID: string): IL.Function['blocks'] {
  const blockIsReachableSet = new Set<IL.BlockID>();

  blockIsReachable(entryBlockID);

  return _.pickBy(blocks, b => blockIsReachableSet.has(b.id));

  function blockIsReachable(blockID: string) {
    if (blockIsReachableSet.has(blockID)) {
      return;
    }
    blockIsReachableSet.add(blockID);
    const block = notUndefined(blocks[blockID]);
    for (const op of block.operations) {
      for (const label of labelOperandsOfOperation(op)) {
        blockIsReachable(label.targetBlockId);
      }
    }
  }
}

function cullUnreachableInstructions(blocks: IL.Function['blocks']): IL.Function['blocks'] {
  // The purpose of this function is to remove extra terminating instructions
  // from the code. This can happen if the user has provided code that
  // explicitly terminates a block before the end of the block (e.g. using
  // `break`). This culling is not for performance optimization. The reason it's
  // needed is for testing purposes, to get the code into a canonical form for
  // comparison.

  return _.mapValues(blocks, block => ({
    ...block,
    operations: cullOperations(block.operations)
  }));

  function cullOperations(operations: IL.Operation[]): IL.Operation[] {
    // Find the first instruction that terminates the block
    const index = operations.findIndex(op => blockTerminatingOpcodes.has(op.opcode));
    // Blocks in IL do not have a defined order, so there is no such thing as
    // "falling through" to the next block. Every block must terminate with a
    // terminating instruction.
    if (index === -1) return unexpected();
    if (index === operations.length - 1) return operations;
    return operations.slice(0, index + 1);
  }
}

function inlineUnnecessaryJumps(blocks: IL.Function['blocks']): IL.Function['blocks'] {
  blocks = { ...blocks };

  // In the case where you jump to a block, and the block is only jumped to from
  // one source location, the jump can be removed and the blocks can just be
  // merged.
  const reachabilityCount = new Map<IL.BlockID, number>();
  const blockIsJumpedTo = new Map<IL.BlockID, { fromOperation: IL.Operation, fromBlockId: IL.BlockID }>();

  for (const [blockID, block] of Object.entries(blocks)) {
    for (const operation of block.operations) {
      for (const { targetBlockId } of labelOperandsOfOperation(operation)) {
        reachabilityCount.set(targetBlockId, (reachabilityCount.get(targetBlockId) ?? 0) + 1)
        if (operation.opcode === 'Jump') {
          blockIsJumpedTo.set(targetBlockId, {
            fromBlockId: blockID,
            fromOperation: operation
          });
        }
      }
    }
  }

  // "to" and "from" here refer to jumping to and jumping from
  for (const toBlockId of Object.keys(blocks)) {
    const toBlock = blocks[toBlockId];
    const shouldInlineBlock = reachabilityCount.get(toBlockId) === 1 && blockIsJumpedTo.has(toBlockId);
    if (shouldInlineBlock) {
      const { fromBlockId, fromOperation } = blockIsJumpedTo.get(toBlockId)!
      const fromBlock = blocks[fromBlockId];
      let operations = [...fromBlock.operations];
      // We're inlining at the end, so it's expected the last operation is at the end
      hardAssert(operations[operations.length - 1] === fromOperation);
      operations.splice(operations.length - 1, 1, ...toBlock.operations)

      delete blocks[toBlockId];
      blocks[fromBlockId] = { ...blocks[fromBlockId], operations }
    }
  }

  return blocks;
}