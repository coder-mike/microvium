import * as IL from './il';
import { SnapshotInfo, BYTECODE_VERSION, HEADER_SIZE, ENGINE_VERSION } from "./snapshot-info";
import { notImplemented, invalidOperation, unexpected, assert, assertUnreachable, notUndefined, reserved, entries } from "./utils";
import { SmartBuffer } from 'smart-buffer';
import { crc16ccitt } from "crc";
import { vm_TeWellKnownValues, vm_TeValueTag, UInt16, TeTypeCode } from './runtime-types';
import * as _ from 'lodash';
import { stringifyValue, stringifyOperation } from './stringify-il';
import { vm_TeOpcode, vm_TeSmallLiteralValue, vm_TeOpcodeEx1, vm_TeOpcodeEx2, vm_TeOpcodeEx3, vm_TeBitwiseOp, vm_TeNumberOp } from './bytecode-opcodes';
import { Snapshot } from '../lib';
import { SnapshotClass } from './snapshot';

// TODO: Everything "notImplemented" in this file.

const deleted = Symbol('Deleted');
type Deleted = typeof deleted;
type Offset = number;

interface Pointer {
  type: 'Pointer';
  address: number;
  logical: IL.Value;
}

type Component =
  | { type: 'Region', regionName: string, value: Region }
  | { type: 'Value', value: IL.Value | Pointer | Deleted }
  | { type: 'LabeledValue', label: string, value: IL.Value | Pointer | Deleted }
  | { type: 'AllocationHeaderAttribute', text: string }
  | { type: 'Attribute', label: string, value: any }
  | { type: 'Annotation', text: string }
  | { type: 'HeaderField', name: string, value: number, isOffset: boolean }
  | { type: 'UnusedSpace' }
  | { type: 'RegionOverflow' }
  | { type: 'OverlapWarning', addressStart: number, addressEnd: number }

interface RegionItem {
  offset: number;
  size: number;
  logicalAddress?: number;
  content: Component;
}

export type Region = RegionItem[];

export interface SnapshotDisassembly {
  bytecodeSize: number;
  components: Region;
}

export interface SnapshotReconstructionInfo {
  names: { [offset: number]: string };
}

/** Decode a snapshot (bytecode) to IL */
export function decodeSnapshot(snapshot: Snapshot): { snapshotInfo: SnapshotInfo, disassembly: string } {
  const buffer = SmartBuffer.fromBuffer(snapshot.data);
  let region: Region = [];
  let regionStack: { region: Region, regionName: string | undefined, regionStart: number }[] = [];
  let regionName: string | undefined;
  let regionStart = 0;
  const dataAllocationsRegion: Region = [];
  const gcAllocationsRegion: Region = [];
  const romAllocationsRegion: Region = [];
  const processedAllocations = new Map<UInt16, IL.Value>();
  const reconstructionInfo = (snapshot instanceof SnapshotClass
    ? snapshot.reconstructionInfo
    : undefined);

  beginRegion('Header', false);

  const bytecodeVersion = readHeaderField8('bytecodeVersion');
  const headerSize = readHeaderField8('headerSize');
  const bytecodeSize = readHeaderField16('bytecodeSize', false);
  const expectedCRC = readHeaderField16('expectedCRC', true);

  if (bytecodeSize !== buffer.length) {
    return invalidOperation(`Invalid bytecode file (bytecode size mismatch)`);
  }

  if (headerSize !== HEADER_SIZE) {
    return invalidOperation(`Invalid bytecode file (header size unexpected)`);
  }

  const actualCRC = crc16ccitt(snapshot.data.slice(6));
  if (actualCRC !== expectedCRC) {
    return invalidOperation(`Invalid bytecode file (CRC mismatch)`);
  }

  if (bytecodeVersion !== BYTECODE_VERSION) {
    return invalidOperation(`Bytecode version ${bytecodeVersion} is not supported`);
  }

  // Read the rest of the header

  const requiredEngineVersion = readHeaderField16('requiredEngineVersion', false);
  const requiredFeatureFlags = readHeaderField32('requiredFeatureFlags', false);
  const globalVariableCount = readHeaderField16('globalVariableCount', false);
  const initialDataOffset = readHeaderField16('initialDataOffset', true);
  const initialDataSize = readHeaderField16('initialDataSize', false);
  const initialHeapOffset = readHeaderField16('initialHeapOffset', true);
  const initialHeapSize = readHeaderField16('initialHeapSize', false);
  const gcRootsOffset = readHeaderField16('gcRootsOffset', true);
  const gcRootsCount = readHeaderField16('gcRootsCount', false);
  const importTableOffset = readHeaderField16('importTableOffset', true);
  const importTableSize = readHeaderField16('importTableSize', false);
  const exportTableOffset = readHeaderField16('exportTableOffset', true);
  const exportTableSize = readHeaderField16('exportTableSize', false);
  const shortCallTableOffset = readHeaderField16('shortCallTableOffset', true);
  const shortCallTableSize = readHeaderField16('shortCallTableSize', false);
  const stringTableOffset = readHeaderField16('stringTableOffset', true);
  const stringTableSize = readHeaderField16('stringTableSize', false);

  const arrayProtoPointerEncoded = buffer.readUInt16LE();
  const arrayProtoPointer = decodeValue(arrayProtoPointerEncoded);
  region.push({
    offset: buffer.readOffset - 2,
    size: 2,
    content: { type: 'LabeledValue', label: 'arrayProtoPointer', value: arrayProtoPointer }
  });

  endRegion('Header');

  if (requiredEngineVersion !== ENGINE_VERSION) {
    return invalidOperation(`Engine version ${requiredEngineVersion} is not supported (expected ${ENGINE_VERSION})`);
  }

  const snapshotInfo: SnapshotInfo = {
    globalSlots: new Map(),
    functions: new Map(),
    exports: new Map(),
    allocations: new Map(),
    flags: new Set(),
    builtins: {
      arrayPrototype: IL.undefinedValue
    }
  };

  decodeFlags();
  decodeGlobalSlots();
  decodeGCRoots();
  decodeImportTable();
  decodeExportTable();
  decodeShortCallTable();
  decodeStringTable();
  decodeBuiltins();

  region.push({
    offset: buffer.readOffset,
    size: undefined as any,
    content: {
      type: 'Region',
      regionName: 'Data allocations',
      value: dataAllocationsRegion
    }
  });

  region.push({
    offset: undefined as any,
    size: undefined as any,
    content: {
      type: 'Region',
      regionName: 'GC allocations',
      value: gcAllocationsRegion
    }
  });

  region.push({
    offset: undefined as any,
    size: undefined as any,
    content: {
      type: 'Region',
      regionName: 'ROM allocations',
      value: romAllocationsRegion
    }
  });

  assert(regionStack.length === 0); // Make sure all regions have ended

  finalizeRegions(region, 0, buffer.length);

  const disassembly: SnapshotDisassembly = {
    bytecodeSize: snapshot.data.length,
    components: region
  };

  return {
    snapshotInfo,
    disassembly: stringifyDisassembly(disassembly)
  };

  function decodeBuiltins() {
    const arrayPrototype = getLogicalValue(arrayProtoPointer);
    if (arrayPrototype === deleted) {
      return invalidOperation('Invalid bytecode: array prototype');
    }
    snapshotInfo.builtins.arrayPrototype = arrayPrototype;
  }

  function decodeFlags() {
    for (let i = 0; i < 32; i++) {
      if (requiredFeatureFlags & (1 << i)) {
        snapshotInfo.flags.add(i);
      }
    }
  }

  function decodeExportTable() {
    buffer.readOffset = exportTableOffset;
    const exportCount = exportTableSize / 4;
    beginRegion('Export Table');
    for (let i = 0; i < exportCount; i++) {
      const offset = buffer.readOffset;
      const exportID = buffer.readUInt16LE();
      const exportValue = buffer.readUInt16LE();
      const value = decodeValue(exportValue);
      region.push({
        offset,
        size: 4,
        content: {
          type: 'LabeledValue',
          label: `[${exportID}]`,
          value
        }
      });
      const logicalValue = getLogicalValue(value);
      if (logicalValue !== deleted) {
        snapshotInfo.exports.set(exportID, logicalValue);
      }
    }
    endRegion('Export Table');
  }

  function decodeShortCallTable() {
    if (shortCallTableSize > 0) {
      return notImplemented(); // TODO
    }
  }

  function decodeStringTable() {
    buffer.readOffset = stringTableOffset;
    beginRegion('String Table');
    const stringTableCount = stringTableSize / 2;
    for (let i = 0; i < stringTableCount; i++) {
      let value = readValue(`[${i}]`)!;
    }
    endRegion('String Table');
  }

  function getName(offset: Offset): string | undefined {
    if (reconstructionInfo) {
      const name = reconstructionInfo.names[offset];
      if (!name) {
        // Note: Names should either come consistently from the reconstruction
        // info or not at all. We can't mix unless we do extra work for
        // namespace clashes.
        return invalidOperation(`Name not found for bytecode offset ${stringifyOffset(offset)}`);
      } else {
        return name;
      }
    } else {
      return undefined;
    }
  }

  function hasName(offset: Offset) : boolean | undefined {
    if (reconstructionInfo) {
      return offset in reconstructionInfo.names;
    } else {
      return undefined;
    }
  }

  function decodeGlobalSlots() {
    buffer.readOffset = initialDataOffset;
    beginRegion('Globals');
    for (let i = 0; i < globalVariableCount; i++) {
      let value = readValue(`[${i}]`)!;
      if (value === deleted) continue;
      snapshotInfo.globalSlots.set(getNameOfGlobal(i), {
        value,
        indexHint: i
      })
    }
    endRegion('Globals');
  }

  function decodeGCRoots() {
    buffer.readOffset = gcRootsOffset;
    beginRegion('GC Roots');
    for (let i = 0; i < gcRootsCount; i++) {
      const offset = buffer.readOffset;
      const u16 = buffer.readUInt16LE();
      const value = decodeValue(u16);
      region.push({
        offset,
        size: 2,
        content: {
          type: 'Value',
          value
        }
      });
    }
    endRegion('GC Roots');
  }

  function decodeImportTable() {
    buffer.readOffset = importTableOffset;
    const importCount = importTableSize / 2;
    beginRegion('Import Table');
    for (let i = 0; i < importCount; i++) {
      const offset = buffer.readOffset;
      const u16 = buffer.readUInt16LE();
      region.push({
        offset,
        size: 2,
        content: {
          type: 'Attribute',
          label: `[${i}]`,
          value: u16
        }
      });
    }
    endRegion('Import Table');
  }

  function beginRegion(name: string, computeLogical: boolean = true) {
    regionStack.push({ region, regionName, regionStart });
    const newRegion: Region = [];
    region.push({
      offset: buffer.readOffset,
      size: undefined as any, // Will be filled in later
      content: {
        type: 'Region',
        regionName: name,
        value: newRegion
      }
    });
    region = newRegion;
    regionStart = buffer.readOffset;
    regionName = name;
  }

  function endRegion(name: string) {
    assert(regionName === name);
    assert(regionStack.length > 0);
    ({ region, regionName, regionStart } = regionStack.pop()!);
  }

  function finalizeRegions(region: Region, start?: number, end?: number) {
    if (region.length === 0) return undefined;

    // Calculate offset for nested regions
    for (const component of region) {
      // Nested region
      if (component.content.type === 'Region') {
        const finalizeResult = finalizeRegions(component.content.value);
        // Delete empty region
        if (!finalizeResult) {
          component.size = 0;
        } else {
          if (component.offset === undefined) {
            component.offset = finalizeResult.offset;
          } else if (finalizeResult.offset < component.offset) {
            component.content.value.push({
              offset: component.offset,
              size: finalizeResult.offset - component.offset,
              logicalAddress: offsetToAddress(component.offset, finalizeResult.offset - component.offset),
              content: { type: 'RegionOverflow' }
            });
          }
          if (component.size === undefined) {
            component.size = finalizeResult.size;
          } else if (finalizeResult.size > component.size) {
            component.content.value.push({
              offset: component.offset + finalizeResult.size,
              size: component.size - finalizeResult.size,
              logicalAddress: offsetToAddress(component.offset + finalizeResult.size, component.size - finalizeResult.size),
              content: { type: 'RegionOverflow' }
            });
          } else if (component.size > finalizeResult.size) {
            component.content.value.push({
              offset: component.offset + component.size,
              size: component.size - finalizeResult.size,
              logicalAddress: offsetToAddress(component.offset + component.size, component.size - finalizeResult.size),
              content: { type: 'UnusedSpace' }
            });
          }
          component.logicalAddress = offsetToAddress(component.offset, component.size);
        }
      }
    }

    const sortedComponents = _.sortBy(region, component => component.offset);

    // Clear out and rebuild
    region.splice(0, region.length);

    const regionStart = start !== undefined ? start : sortedComponents[0].offset;

    let cursor = regionStart;
    for (const component of sortedComponents) {
      // Skip empty regions
      if (component.content.type === 'Region' && component.content.value.length === 0) {
        continue;
      }

      component.logicalAddress = offsetToAddress(component.offset, component.size);

      if (component.offset > cursor) {
        region.push({
          offset: cursor,
          size: component.offset - cursor,
          logicalAddress: offsetToAddress(cursor, component.offset - cursor),
          content: { type: 'UnusedSpace' }
        });
      } else if (cursor > component.offset) {
        region.push({
          offset: cursor,
          size: - (cursor - component.offset), // Negative size
          logicalAddress: undefined,
          content: { type: 'OverlapWarning', addressStart: component.offset, addressEnd: cursor }
        });
      }

      region.push(component);
      cursor = component.offset + component.size;
    }

    if (end !== undefined && cursor < end) {
      region.push({
        offset: cursor,
        size: end - cursor,
        logicalAddress: offsetToAddress(cursor, end - cursor),
        content: { type: 'UnusedSpace' }
      });
      cursor = end;
    }
    return { size: cursor - regionStart, offset: regionStart };
  }

  function readValue(label: string): IL.Value | Deleted {
    const offset = buffer.readOffset;
    const u16 = buffer.readUInt16LE();
    const value = decodeValue(u16);

    region.push({
      offset,
      size: 2,
      content: { type: 'LabeledValue', label, value }
    });

    return getLogicalValue(value);
  }

  function decodeValue(u16: UInt16): IL.Value | Pointer | Deleted {
    if ((u16 & 0xC000) === 0) {
      return { type: 'NumberValue', value: u16 > 0x2000 ? u16 - 0x4000 : u16 };
    } else if ((u16 & 0xC000) === vm_TeValueTag.VM_TAG_PGM_P && u16 < vm_TeWellKnownValues.VM_VALUE_WELLKNOWN_END) {
      switch (u16) {
        case vm_TeWellKnownValues.VM_VALUE_UNDEFINED: return IL.undefinedValue; break;
        case vm_TeWellKnownValues.VM_VALUE_NULL: return IL.nullValue; break;
        case vm_TeWellKnownValues.VM_VALUE_TRUE: return IL.trueValue; break;
        case vm_TeWellKnownValues.VM_VALUE_FALSE: return IL.falseValue; break;
        case vm_TeWellKnownValues.VM_VALUE_NAN: return IL.numberValue(NaN); break;
        case vm_TeWellKnownValues.VM_VALUE_NEG_ZERO: return IL.numberValue(-0); break;
        case vm_TeWellKnownValues.VM_VALUE_DELETED: return deleted; break;
        case vm_TeWellKnownValues.VM_VALUE_STR_LENGTH: return IL.stringValue('length'); break;
        case vm_TeWellKnownValues.VM_VALUE_STR_PROTO: return IL.stringValue('__proto__'); break;
        default: return unexpected();
      }
    } else {
      return {
        type: 'Pointer',
        address: u16,
        logical: decodeAllocation(u16)
      };
    }
  }

  function addressToAllocationID(address: number): IL.AllocationID {
    const offset = addressToOffset(address);
    const name = getName(offset);
    return name !== undefined ? parseInt(name) : address;
  }

  function addressToOffset(address: number): Offset {
    return locateAddress(address).offset;
  }

  function readHeaderField8(name: string) {
    const address = buffer.readOffset;
    const value = buffer.readUInt8();
    region.push({
      offset: address,
      logicalAddress: undefined,
      size: 1,
      content: {
        type: 'HeaderField',
        name,
        isOffset: false,
        value
      }
    });
    return value;
  }

  function readHeaderField16(name: string, isOffset: boolean) {
    const address = buffer.readOffset;
    const value = buffer.readUInt16LE();
    region.push({
      offset: address,
      logicalAddress: undefined,
      size: 2,
      content: {
        type: 'HeaderField',
        name,
        isOffset,
        value
      }
    });
    return value;
  }

  function readHeaderField32(name: string, isOffset: boolean) {
    const address = buffer.readOffset;
    const value = buffer.readUInt32LE();
    region.push({
      offset: address,
      logicalAddress: undefined,
      size: 4,
      content: {
        type: 'HeaderField',
        name,
        isOffset,
        value
      }
    });
    return value;
  }

  function offsetToAddress(offset: number, size: number = 1): number | undefined {
    // If the size is zero, it's slightly more intuitive that the value appears
    // to be in the preceding region, since empty values are unlikely to be at
    // the beginning of a region.
    const assumedOffset = size === 0 ? offset - 1 : offset;

    if (assumedOffset >= initialHeapOffset && assumedOffset < initialHeapOffset + initialHeapSize) {
      return 0x4000 + offset - initialHeapOffset;
    }

    if (assumedOffset >= initialDataOffset && assumedOffset < initialDataOffset + initialDataSize) {
      return 0x8000 + offset - initialDataOffset;
    }

    if (assumedOffset >= HEADER_SIZE) {
      return 0xC000 + offset;
    }

    return undefined;
  }

  function decodeAllocation(address: UInt16): IL.Value {
    if (processedAllocations.has(address)) {
      return processedAllocations.get(address)!;
    }

    const { offset, region } = locateAddress(address);

    const value = decodeAllocationContent(address, offset, region);
    // The decode is supposed to insert the value. It needs to do this itself
    // because it needs to happen before nested allocations are pursued
    assert(processedAllocations.get(address) === value);
    return value;
  }

  function locateAddress(address: number): { region: Region, offset: number } {
    const sectionCode: vm_TeValueTag = address & 0xC000;
    let offset: number;
    let region: Region;

    switch (sectionCode) {
      case vm_TeValueTag.VM_TAG_INT: return unexpected();
      case vm_TeValueTag.VM_TAG_GC_P: {
        offset = initialHeapOffset + (address - vm_TeValueTag.VM_TAG_GC_P);
        region = gcAllocationsRegion;
        break;
      }
      case vm_TeValueTag.VM_TAG_PGM_P: {
        offset = address - vm_TeValueTag.VM_TAG_PGM_P;
        region = romAllocationsRegion;
        break;
      }
      case vm_TeValueTag.VM_TAG_DATA_P: {
        offset = initialDataOffset + (address - vm_TeValueTag.VM_TAG_DATA_P);
        region = dataAllocationsRegion;
        break;
      }
      default: return assertUnreachable(sectionCode);
    }
    return { offset, region };
  }

  function decodeAllocationContent(address: number, offset: number, region: Region): IL.Value {
    const headerWord = buffer.readUInt16LE(offset - 2);
    const size = (headerWord & 0xFFF); // Size excluding header
    const typeCode: TeTypeCode = headerWord >> 12;

    // Allocation header
    region.push({
      offset: offset - 2,
      size: 2,
      content: { type: 'AllocationHeaderAttribute', text: `Size: ${size}, Type: ${TeTypeCode[typeCode]}` }
    });

    switch (typeCode) {
      case TeTypeCode.TC_REF_NONE: return unexpected();
      case TeTypeCode.TC_REF_INT32: return decodeInt32(region, address, offset, size);
      case TeTypeCode.TC_REF_FLOAT64: return decodeFloat64(region, address, offset, size);
      case TeTypeCode.TC_REF_STRING:
      case TeTypeCode.TC_REF_UNIQUE_STRING: return decodeString(region, address, offset, size);
      case TeTypeCode.TC_REF_PROPERTY_LIST: return decodePropertyList(region, address, offset, size);
      case TeTypeCode.TC_REF_ARRAY: return decodeArray(region, address, offset, size);
      case TeTypeCode.TC_REF_RESERVED_0: return reserved();
      case TeTypeCode.TC_REF_FUNCTION: return decodeFunction(region, address, offset, size);
      case TeTypeCode.TC_REF_HOST_FUNC: return decodeHostFunction(region, address, offset, size);
      case TeTypeCode.TC_REF_STRUCT: return reserved();
      case TeTypeCode.TC_REF_BIG_INT: return reserved();
      case TeTypeCode.TC_REF_SYMBOL: return reserved();
      case TeTypeCode.TC_REF_RESERVED_1: return reserved();
      case TeTypeCode.TC_REF_RESERVED_2: return reserved();
      case TeTypeCode.TC_REF_RESERVED_3: return reserved();
      default: return unexpected();
    }
  }

  function decodeInt32(region: Region, address: number, offset: number, size: number): IL.Value {
    const i = buffer.readInt32LE(offset);
    const value: IL.NumberValue = {
      type: 'NumberValue',
      value: i
    };
    processedAllocations.set(address, value);
    region.push({
      offset: offset,
      size: size,
      content: {
        type: 'LabeledValue',
        label: 'Value',
        value
      }
    });
    return value;
  }

  function decodeFloat64(region: Region, address: number, offset: number, size: number): IL.Value {
    const n = buffer.readDoubleLE(offset);
    const value: IL.NumberValue = {
      type: 'NumberValue',
      value: n
    };
    processedAllocations.set(address, value);
    region.push({
      offset: offset,
      size: size,
      content: {
        type: 'LabeledValue',
        label: 'Value',
        value
      }
    });
    return value;
  }

  function decodeFunction(region: Region, address: number, offset: number, size: number): IL.Value {
    const functionID = getName(offset) || stringifyAddress(address);
    const functionValue: IL.FunctionValue = {
      type: 'FunctionValue',
      value: functionID
    };
    processedAllocations.set(address, functionValue);

    const maxStackDepth = buffer.readUInt8(offset);

    const ilFunc: IL.Function = {
      type: 'Function',
      id: functionID,
      blocks: {},
      maxStackDepth: maxStackDepth,
      entryBlockID: offsetToBlockID(offset + 1),
    };
    snapshotInfo.functions.set(ilFunc.id, ilFunc);

    const functionBodyRegion: Region = [{
      offset,
      size: 1,
      content: {
        type: 'Attribute',
        label: 'maxStackDepth',
        value: maxStackDepth
      }
    }];
    const { blocks } = decodeInstructions(functionBodyRegion, offset + 1, size - 1);
    assert(Object.values(blocks).every(b => b.operations.every(o => o.stackDepthAfter <= maxStackDepth)));
    ilFunc.blocks = blocks;

    region.push({
      offset,
      size,
      content: {
        type: 'Region',
        regionName: `Function ${functionID}`,
        value: functionBodyRegion
      }
    });

    return functionValue;
  }

  function decodeInstructions(region: Region, offset: number, size: number) {
    const originalReadOffset = buffer.readOffset;
    buffer.readOffset = offset;
    const instructionsCovered = new Set<number>();
    const blockEntryOffsets = new Set<number>();
    const instructionsByOffset = new Map<number, [IL.Operation, string, number]>();
    // The entry point is at the beginning
    decodeBlock(offset, 0);
    buffer.readOffset = originalReadOffset;

    const blocks = divideInstructionsIntoBlocks();

    return { blocks };

    function divideInstructionsIntoBlocks() {
      const blocks: { [name: string]: IL.Block } = {};
      const instructionsInOrder = _.sortBy([...instructionsByOffset], ([offset]) => offset);

      assert(instructionsInOrder.length > 0);
      const [firstOffset, [firstInstruction, firstInstrDisassembly]] = instructionsInOrder[0];
      let block: IL.Block = {
        expectedStackDepthAtEntry: firstInstruction.stackDepthBefore,
        id: offsetToBlockID(firstOffset),
        operations: []
      };
      let blockRegion: Region = [];
      region.push({
        offset: firstOffset,
        size: undefined as any,
        content: {
          type: 'Region',
          regionName: `Block ${block.id}`,
          value: blockRegion
        }
      })
      blocks[block.id] = block;

      const iter = instructionsInOrder[Symbol.iterator]();
      let iterResult = iter.next();
      while (!iterResult.done) {
        const [instructionOffset, [instruction, disassembly, instructionSize]] = iterResult.value;
        block.operations.push(instruction);
        blockRegion.push({
          offset: instructionOffset,
          size: instructionSize,
          content: {
            type: 'Annotation',
            text: disassembly
          }
        });

        iterResult = iter.next();
        if (!iterResult.done) {
          const [nextOffset, [nextInstruction]] = iterResult.value;
          // Start a new block?
          if (blockEntryOffsets.has(nextOffset)) {
            // End off previous block
            if (instruction.opcode !== 'Jump' && instruction.opcode !== 'Branch' && instruction.opcode !== 'Return') {
              // Add implicit jump/fall-through
              block.operations.push({
                opcode: 'Jump',
                stackDepthBefore: instruction.stackDepthAfter,
                stackDepthAfter: instruction.stackDepthAfter,
                operands: [{
                  type: 'LabelOperand',
                  targetBlockID: offsetToBlockID(nextOffset)
                }]
              });
              blockRegion.push({
                offset: nextOffset,
                size: 0,
                content: {
                  type: 'Annotation',
                  text: '<implicit fallthrough>'
                }
              });
            }

            // Create new block
            block = {
              expectedStackDepthAtEntry: nextInstruction.stackDepthBefore,
              id: offsetToBlockID(nextOffset),
              operations: []
            };
            blocks[block.id] = block;
            blockRegion = [];
            region.push({
              offset: nextOffset,
              size: undefined as any,
              content: {
                type: 'Region',
                regionName: `Block ${block.id}`,
                value: blockRegion
              }
            })
          }
        }
      }

      return blocks;
    }

    function decodeBlock(offset: number, stackDepth: number) {
      const prevOffset = buffer.readOffset;
      buffer.readOffset = offset;
      blockEntryOffsets.add(offset);
      while (true) {
        if (instructionsCovered.has(buffer.readOffset)) {
          break;
        }
        instructionsCovered.add(buffer.readOffset);

        const instructionOffset = buffer.readOffset;
        const stackDepthBefore = stackDepth;
        const decodeResult = decodeInstruction(region, stackDepthBefore);
        const op: IL.Operation = {
          ...decodeResult.operation,
          stackDepthBefore,
          stackDepthAfter: undefined as any,
        };
        stackDepth += IL.calcStackChangeOfOp(op);
        op.stackDepthAfter = stackDepth;
        const size = buffer.readOffset - instructionOffset;
        const disassembly = decodeResult.disassembly || stringifyOperation(op);
        instructionsByOffset.set(instructionOffset, [op, disassembly, size]);

        // Control flow operations
        if (decodeResult.jumpTo) {
          decodeResult.jumpTo.forEach(offset => decodeBlock(offset, stackDepth));
          break;
        }
      }
      buffer.readOffset = prevOffset;
    }
  }

  function decodeHostFunction(region: Region, address: number, offset: number, size: number): IL.Value {
    const hostFunctionIndex = buffer.readUInt16LE(offset);
    const hostFunctionIDOffset = importTableOffset + hostFunctionIndex * 2;
    assert(hostFunctionIDOffset < importTableOffset + importTableSize);
    const hostFunctionID = buffer.readUInt16LE(hostFunctionIDOffset);
    const hostFunctionValue: IL.HostFunctionValue = {
      type: 'HostFunctionValue',
      value: hostFunctionID
    }
    processedAllocations.set(address, hostFunctionValue);
    region.push({
      offset: offset,
      size: size,
      content: {
        type: 'Attribute',
        label: 'Value',
        value: `Import Table [${hostFunctionIndex}] (&${stringifyAddress(offsetToAddress(hostFunctionIDOffset, 1))})`
      }
    });
    return hostFunctionValue;
  }

  function decodeString(region: Region, address: number, offset: number, size: number): IL.Value {
    const origOffset = buffer.readOffset;
    buffer.readOffset = offset;
    const str = buffer.readString(size - 1, 'utf8');
    buffer.readOffset = origOffset;
    const value: IL.StringValue = {
      type: 'StringValue',
      value: str
    };
    processedAllocations.set(address, value);
    region.push({
      offset: offset,
      size: size,
      content: {
        type: 'LabeledValue',
        label: 'Value',
        value
      }
    });
    return value;
  }

  function decodePropertyList(region: Region, address: number, offset: number, size: number): IL.Value {
    const allocationID = addressToAllocationID(address);

    const object: IL.ObjectAllocation = {
      type: 'ObjectAllocation',
      allocationID,
      properties: {},
      memoryRegion: getMemoryRegion(region),
      keysAreFixed: false,
      immutableProperties: new Set()
    };
    snapshotInfo.allocations.set(allocationID, object);

    const ref: IL.ReferenceValue = {
      type: 'ReferenceValue',
      value: allocationID
    };
    processedAllocations.set(address, ref);

    const first = buffer.readUInt16LE(offset);
    region.push({
      offset: offset,
      size: size,
      content: {
        type: 'Region',
        regionName: `Object as TsPropertyList`,
        value: [
          { offset, size: 2, content: { type: 'Attribute', label: 'first', value: `&${stringifyAddress(first)}` } },
        ]
      }
    });

    // Follow linked list of cells
    let cellAddress = first;
    while (cellAddress) {
      const { offset, region } = locateAddress(cellAddress);
      const next = buffer.readUInt16LE(offset);
      let key = decodeValue(buffer.readUInt16LE(offset + 2));
      let propValue = decodeValue(buffer.readUInt16LE(offset + 4));
      const logicalKey = getLogicalValue(key);
      if (logicalKey === deleted || logicalKey.type !== 'StringValue') {
        return invalidOperation('Only string keys supported')
      }
      const logicalPropValue = getLogicalValue(propValue);
      if (logicalPropValue !== deleted) {
        object.properties[logicalKey.value] = logicalPropValue;
      }

      region.push({
        offset,
        size: 6,
        content: {
          type: 'Region',
          regionName: `TsPropertyCell`,
          value: [
            {
              offset: offset + 0,
              size: 2,
              content: { type: 'Attribute', label: 'next', value: `&${stringifyAddress(next)}` }
            },
            {
              offset: offset + 2,
              size: 2,
              content: { type: 'LabeledValue', label: 'key', value: key }
            },
            {
              offset: offset + 4,
              size: 2,
              content: { type: 'LabeledValue', label: 'value', value: propValue }
            }
          ]
        }
      });
      cellAddress = next;
    }

    return ref;
  }

  function decodeArray(region: Region, address: number, offset: number, size: number): IL.Value {
    const memoryRegion = getMemoryRegion(region);
    const allocationID = addressToAllocationID(address);
    const array: IL.ArrayAllocation = {
      type: 'ArrayAllocation',
      allocationID,
      items: [],
      memoryRegion,
      lengthIsFixed: memoryRegion === 'rom'
    };
    snapshotInfo.allocations.set(allocationID, array);

    const ref: IL.ReferenceValue = {
      type: 'ReferenceValue',
      value: allocationID
    };
    processedAllocations.set(address, ref);

    const dataPtr = buffer.readUInt16LE(offset);
    const length = buffer.readUInt16LE(offset + 2);
    const capacity = buffer.readUInt16LE(offset + 4);

    region.push({
      offset,
      size: size,
      content: {
        type: 'Region',
        regionName: `Array`,
        value: [{
          offset: offset,
          size: 2,
          content: {
            type: 'Attribute',
            label: 'data',
            value: `&${stringifyAddress(dataPtr)}`
          }
        }, {
          offset: offset + 2,
          size: 2,
          content: {
            type: 'Attribute',
            label: 'length',
            value: length.toString()
          }
        }, {
          offset: offset + 4,
          size: 2,
          content: {
            type: 'Attribute',
            label: 'capacity',
            value: capacity.toString()
          }
        }]
      }
    });


    if (dataPtr !== 0) {
      array.items.length = length;
      const dataOffset = addressToOffset(dataPtr);

      const itemsDisassembly: Region = [];
      for (let i = 0; i < length; i++) {
        const itemOffset = dataOffset + i * 2;
        const itemRaw = buffer.readUInt16LE(itemOffset);
        const item = decodeValue(itemRaw);
        const logical = getLogicalValue(item);
        if (logical !== deleted) {
          array.items[i] = logical;
        } else {
          array.items[i] = undefined;
        }
        itemsDisassembly.push({
          offset: itemOffset,
          size: 2,
          content: {
            type: 'LabeledValue',
            label: `[${i}]`,
            value: item
          }
        })
      }

      region.push({
        offset: dataOffset,
        size: length * 2,
        content: {
          type: 'Region',
          regionName: `Array items`,
          value: itemsDisassembly
        }
      });
    }

    return ref;
  }

  function getMemoryRegion(region: Region) {
    const memoryRegion: IL.ObjectAllocation['memoryRegion'] =
      region === dataAllocationsRegion ? 'data':
      region === gcAllocationsRegion ? 'gc':
      region === romAllocationsRegion ? 'rom':
      unexpected();

    return memoryRegion;
  }

  function decodeInstruction(region: Region, stackDepthBefore: number): DecodeInstructionResult {
    let x = buffer.readUInt8();
    const opcode: vm_TeOpcode = x >> 4;
    const param = x & 0xF;
    switch (opcode) {
      case vm_TeOpcode.VM_OP_LOAD_SMALL_LITERAL: {
        let literalValue: IL.Value;
        const valueCode: vm_TeSmallLiteralValue = param;
        switch (valueCode) {
          case vm_TeSmallLiteralValue.VM_SLV_NULL: literalValue = IL.nullValue; break;
          case vm_TeSmallLiteralValue.VM_SLV_UNDEFINED: literalValue = IL.undefinedValue; break;
          case vm_TeSmallLiteralValue.VM_SLV_FALSE: literalValue = IL.falseValue; break;
          case vm_TeSmallLiteralValue.VM_SLV_TRUE: literalValue = IL.trueValue; break;
          case vm_TeSmallLiteralValue.VM_SLV_INT_0: literalValue = IL.numberValue(0); break;
          case vm_TeSmallLiteralValue.VM_SLV_INT_1: literalValue = IL.numberValue(1); break;
          case vm_TeSmallLiteralValue.VM_SLV_INT_2: literalValue = IL.numberValue(2); break;
          case vm_TeSmallLiteralValue.VM_SLV_INT_MINUS_1: literalValue = IL.numberValue(-1); break;
          default: assertUnreachable(valueCode);
        }
        return {
          operation: {
            opcode: 'Literal',
            operands: [{
              type: 'LiteralOperand',
              literal: literalValue
            }]
          }
        }
      }
      case vm_TeOpcode.VM_OP_LOAD_VAR_1: {
        return opLoadVar(param);
      }
      case vm_TeOpcode.VM_OP_LOAD_GLOBAL_1: {
        return opLoadGlobal(param);
      }
      case vm_TeOpcode.VM_OP_LOAD_ARG_1: {
        return opLoadArg(param);
      }
      case vm_TeOpcode.VM_OP_CALL_1: {
        return notImplemented(); // TODO
      }
      case vm_TeOpcode.VM_OP_EXTENDED_1: {
        const subOp: vm_TeOpcodeEx1 = param;
        switch (subOp) {
          case vm_TeOpcodeEx1.VM_OP1_RETURN_1: {
            return notImplemented();
          }
          case vm_TeOpcodeEx1.VM_OP1_RETURN_2: {
            return {
              operation: {
                opcode: 'Return',
                operands: [],
                staticInfo: {
                  targetIsOnTheStack: true,
                  returnUndefined: false
                }
              },
              jumpTo: []
            }
          }
          case vm_TeOpcodeEx1.VM_OP1_RETURN_3: {
            return notImplemented();
          }
          case vm_TeOpcodeEx1.VM_OP1_RETURN_4: {
            return notImplemented();
          }
          case vm_TeOpcodeEx1.VM_OP1_OBJECT_NEW: {
            return {
              operation: {
                opcode: 'ObjectNew',
                operands: []
              }
            }
          }
          case vm_TeOpcodeEx1.VM_OP1_LOGICAL_NOT: {
            return {
              operation: {
                opcode: 'UnOp',
                operands: [{
                  type: 'OpOperand',
                  subOperation: '!'
                }]
              }
            };
          }
          case vm_TeOpcodeEx1.VM_OP1_OBJECT_GET_1: {
            return {
              operation: {
                opcode: 'ObjectGet',
                operands: []
              }
            };
          }
          case vm_TeOpcodeEx1.VM_OP1_ADD: {
            return {
              operation: {
                opcode: 'BinOp',
                operands: [{
                  type: 'OpOperand',
                  subOperation: '+'
                }]
              }
            };
          }
          case vm_TeOpcodeEx1.VM_OP1_EQUAL: {
            return {
              operation: {
                opcode: 'BinOp',
                operands: [{
                  type: 'OpOperand',
                  subOperation: '==='
                }]
              }
            };
          }
          case vm_TeOpcodeEx1.VM_OP1_NOT_EQUAL: {
            return {
              operation: {
                opcode: 'BinOp',
                operands: [{
                  type: 'OpOperand',
                  subOperation: '!=='
                }]
              }
            };
          }
          case vm_TeOpcodeEx1.VM_OP1_OBJECT_SET_1: {
            return {
              operation: {
                opcode: 'ObjectSet',
                operands: []
              }
            };
          }
          default:
            return unexpected();
        }
      }
      case vm_TeOpcode.VM_OP_EXTENDED_2: {
        const subOp: vm_TeOpcodeEx2 = param;
        switch (subOp) {
          case vm_TeOpcodeEx2.VM_OP2_BRANCH_1: {
            const offsetFromCurrent = buffer.readInt8();
            const offset = buffer.readOffset + offsetFromCurrent;
            return opBranch(offset);
          }
          case vm_TeOpcodeEx2.VM_OP2_STORE_ARG: {
            return notImplemented();
          }
          case vm_TeOpcodeEx2.VM_OP2_STORE_GLOBAL_2: {
            return notImplemented();
          }
          case vm_TeOpcodeEx2.VM_OP2_STORE_VAR_2: {
            return notImplemented();
          }
          case vm_TeOpcodeEx2.VM_OP2_STRUCT_GET_2: {
            return notImplemented();
          }
          case vm_TeOpcodeEx2.VM_OP2_STRUCT_SET_2: {
            return notImplemented();
          }
          case vm_TeOpcodeEx2.VM_OP2_JUMP_1: {
            const offsetFromCurrent = buffer.readInt8();
            const offset = buffer.readOffset + offsetFromCurrent;
            return opJump(offset);
          }
          case vm_TeOpcodeEx2.VM_OP2_CALL_HOST: {
            return notImplemented();
          }
          case vm_TeOpcodeEx2.VM_OP2_CALL_3: {
            const argCount = buffer.readUInt8();
            return {
              operation: {
                opcode: 'Call',
                operands: [{ type: 'CountOperand', count: argCount }]
              }
            }
          }
          case vm_TeOpcodeEx2.VM_OP2_CALL_2: {
            return notImplemented();
          }
          case vm_TeOpcodeEx2.VM_OP2_LOAD_GLOBAL_2: {
            const index = buffer.readUInt8();
            return opLoadGlobal(index);
          }
          case vm_TeOpcodeEx2.VM_OP2_LOAD_VAR_2: {
            const index = buffer.readUInt8();
            return opLoadVar(index);
          }
          case vm_TeOpcodeEx2.VM_OP2_LOAD_ARG_2: {
            const index = buffer.readUInt8();
            return opLoadArg(index);
          }
          case vm_TeOpcodeEx2.VM_OP2_RETURN_ERROR: {
            return notImplemented();
          }
          case vm_TeOpcodeEx2.VM_OP2_ARRAY_NEW: {
            const capacity = buffer.readUInt8();
            return {
              operation: {
                opcode: 'ArrayNew',
                operands: [],
                staticInfo: {
                  minCapacity: capacity
                }
              },
              disassembly: `ArrayNew() [capacity=${capacity}]`
            }
          }
          default: {
            return unexpected();
          }
        }
      }
      case vm_TeOpcode.VM_OP_EXTENDED_3: {
        const subOp: vm_TeOpcodeEx3 = param;
        switch (subOp) {
          case vm_TeOpcodeEx3.VM_OP3_JUMP_2: {
            const offsetFromCurrent = buffer.readInt16LE();
            const offset = buffer.readOffset + offsetFromCurrent;
            return opJump(offset);
          }
          case vm_TeOpcodeEx3.VM_OP3_LOAD_LITERAL: {
            const u16 = buffer.readUInt16LE();
            const value = decodeValue(u16);
            const logical = getLogicalValue(value);
            if (logical === deleted) return unexpected();
            return {
              operation: {
                opcode: 'Literal',
                operands: [{
                  type: 'LiteralOperand',
                  literal: logical
                }]
              },
              disassembly: `Literal(${stringifyBytecodeValue(value)})`
            }
          }
          case vm_TeOpcodeEx3.VM_OP3_LOAD_GLOBAL_3: {
            const index = buffer.readUInt16LE();
            return opLoadGlobal(index);
          }
          case vm_TeOpcodeEx3.VM_OP3_BRANCH_2: {
            const offsetFromCurrent = buffer.readInt16LE();
            const offsetInBytecode = buffer.readOffset + offsetFromCurrent;
            return opBranch(offsetInBytecode);
          }
          case vm_TeOpcodeEx3.VM_OP3_STORE_GLOBAL_3: {
            const index = buffer.readUInt16LE();
            return opStoreGlobal(index);
          }
          case vm_TeOpcodeEx3.VM_OP3_OBJECT_GET_2: {
            return notImplemented(); // TODO
          }
          case vm_TeOpcodeEx3.VM_OP3_OBJECT_SET_2: {
            return notImplemented(); // TODO
          }
          default: {
            return unexpected();
          }
        }
      }
      case vm_TeOpcode.VM_OP_POP: {
        return {
          operation: {
            opcode: 'Pop',
            operands: [{ type: 'CountOperand', count: param + 1 }]
          }
        }
      }
      case vm_TeOpcode.VM_OP_STORE_VAR_1: {
        return opStoreVar(param);
      }
      case vm_TeOpcode.VM_OP_STORE_GLOBAL_1: {
        const index = param;
        return opStoreGlobal(index);
      }
      case vm_TeOpcode.VM_OP_STRUCT_GET_1: {
        return notImplemented(); // TODO
      }
      case vm_TeOpcode.VM_OP_STRUCT_SET_1: {
        return notImplemented(); // TODO
      }
      case vm_TeOpcode.VM_OP_NUM_OP: {
        const subOp: vm_TeNumberOp = param;
        let binOp: IL.BinOpCode | undefined;
        let unOp: IL.UnOpCode | undefined;
        switch (subOp) {
          case vm_TeNumberOp.VM_NUM_OP_LESS_THAN: binOp = '<'; break;
          case vm_TeNumberOp.VM_NUM_OP_GREATER_THAN: binOp = '>'; break;
          case vm_TeNumberOp.VM_NUM_OP_LESS_EQUAL: binOp = '<='; break;
          case vm_TeNumberOp.VM_NUM_OP_GREATER_EQUAL: binOp = '>='; break;
          case vm_TeNumberOp.VM_NUM_OP_ADD_NUM: return reserved();
          case vm_TeNumberOp.VM_NUM_OP_SUBTRACT: binOp = '-'; break;
          case vm_TeNumberOp.VM_NUM_OP_MULTIPLY: binOp = '*'; break;
          case vm_TeNumberOp.VM_NUM_OP_DIVIDE: binOp = '/'; break;
          case vm_TeNumberOp.VM_NUM_OP_DIVIDE_AND_TRUNC: binOp = 'DIVIDE_AND_TRUNC'; break;
          case vm_TeNumberOp.VM_NUM_OP_REMAINDER: binOp = '%'; break;
          case vm_TeNumberOp.VM_NUM_OP_POWER: binOp = '**'; break;
          case vm_TeNumberOp.VM_NUM_OP_NEGATE: unOp = '-'; break;
          case vm_TeNumberOp.VM_NUM_OP_UNARY_PLUS: unOp = '+'; break;
        }
        if (binOp !== undefined) {
          return {
            operation: {
              opcode: 'BinOp',
              operands: [{
                type: 'OpOperand',
                subOperation: binOp
              }]
            }
          }
        }
        if (unOp !== undefined) {
          return {
            operation: {
              opcode: 'UnOp',
              operands: [{
                type: 'OpOperand',
                subOperation: unOp
              }]
            }
          }
        }
        return unexpected();
      }
      case vm_TeOpcode.VM_OP_BIT_OP: {
        const subOp: vm_TeBitwiseOp = param;
        let binOp: IL.BinOpCode;
        switch (subOp) {
          case vm_TeBitwiseOp.VM_BIT_OP_SHR_ARITHMETIC: binOp = '>>'; break;
          case vm_TeBitwiseOp.VM_BIT_OP_SHR_LOGICAL: binOp = '>>>'; break;
          case vm_TeBitwiseOp.VM_BIT_OP_SHL: binOp = '<<'; break;
          case vm_TeBitwiseOp.VM_BIT_OP_OR: binOp = '|'; break;
          case vm_TeBitwiseOp.VM_BIT_OP_AND: binOp = '&'; break;
          case vm_TeBitwiseOp.VM_BIT_OP_XOR: binOp = '^'; break;
          case vm_TeBitwiseOp.VM_BIT_OP_NOT: {
            return {
              operation: {
                opcode: 'UnOp',
                operands: [{ type: 'OpOperand', subOperation: '~' }]
              }
            }
          }
          default: return unexpected();
        }
        return {
          operation: {
            opcode: 'BinOp',
            operands: [{ type: 'OpOperand', subOperation: binOp }]
          }
        }
      }
      case vm_TeOpcode.VM_OP_END: {
        return unexpected();
      }
      default: assertUnreachable(opcode);
    }

    function opLoadVar(index: number): DecodeInstructionResult {
      return {
        operation: {
          opcode: 'LoadVar',
          operands: [{
            type: 'IndexOperand',
            index: stackDepthBefore - index - 1
          }]
        }
      }
    }

    function opStoreVar(index: number): DecodeInstructionResult {
      return {
        operation: {
          opcode: 'StoreVar',
          operands: [{
            type: 'IndexOperand',
            index: stackDepthBefore - index - 2
          }]
        }
      }
    }

    function opLoadGlobal(index: number): DecodeInstructionResult {
      return {
        operation: {
          opcode: 'LoadGlobal',
          operands: [{
            type: 'NameOperand',
            name: getNameOfGlobal(index)
          }]
        },
        disassembly: `LoadGlobal [${index}]`
      }
    }

    function opStoreGlobal(index: number): DecodeInstructionResult {
      return {
        operation: {
          opcode: 'StoreGlobal',
          operands: [{
            type: 'NameOperand',
            name: getNameOfGlobal(index)
          }]
        },
        disassembly: `StoreGlobal [${index}]`
      }
    }

    function opLoadArg(index: number): DecodeInstructionResult {
      return {
        operation: {
          opcode: 'LoadArg',
          operands: [{
            type: 'IndexOperand',
            index
          }]
        }
      }
    }

    function opBranch(offset: number): DecodeInstructionResult {
      const offsetAlternate = buffer.readOffset;
      return {
        operation: {
          opcode: 'Branch',
          operands: [{
            type: 'LabelOperand',
            targetBlockID: offsetToBlockID(offset)
          }, {
            type: 'LabelOperand',
            targetBlockID: offsetToBlockID(offsetAlternate)
          }]
        },
        disassembly: `Branch &${stringifyAddress(offsetToAddress(offset))}`,
        jumpTo: [offset, offsetAlternate]
      }
    }

    function opJump(offset: number): DecodeInstructionResult {
      // Special case for "Nop" which is the only time there is a valid jump to an anonymous offset
      if (hasName(offset) === false) {
        assert(offset > 0);
        const nopSize = offset + 3 - buffer.readOffset;
        buffer.readOffset = offset;
        return {
          operation: {
            opcode: 'Nop',
            operands: [{
              type: 'CountOperand',
              count: nopSize
            }]
          },
          disassembly: `Nop as Jump &${stringifyAddress(offsetToAddress(offset))}`
        }
      }
      return {
        operation: {
          opcode: 'Jump',
          operands: [{
            type: 'LabelOperand',
            targetBlockID: offsetToBlockID(offset)
          }]
        },
        disassembly: `Jump &${stringifyAddress(offsetToAddress(offset))}`,
        jumpTo: [offset]
      }
    }
  }

  function getNameOfGlobal(index: number) {
    const offset = initialDataOffset + index * 2;
    return getName(offset) || `global${index}`;
  }

  function offsetToBlockID(offset: Offset): string {
    return getName(offset) || stringifyAddress(offsetToAddress(offset));
  }
}

function stringifyDisassembly(mapping: SnapshotDisassembly): string {
  return `Bytecode size: ${mapping.bytecodeSize} B\n\nOfst Addr    Size\n==== ==== =======\n${stringifySnapshotMappingComponents(mapping.components)}`;
}

function stringifyAddress(address: number | undefined): string {
  return address !== undefined
    ? Math.trunc(address).toString(16).padStart(4, '0')
    : '    '
}

function stringifySnapshotMappingComponents(region: Region, indent = ''): string {
  return region
    .map(({ offset, logicalAddress, size, content }) => `${
      stringifyOffset(offset)
    } ${
      stringifyAddress(logicalAddress)
    } ${
      stringifySize(size, content.type === 'Region')
    } ${indent}${
      stringifyComponent(content)
    }`).join('\n');

  function stringifyComponent(component: Component): string {
    switch (component.type) {
      case 'HeaderField': return `${component.name}: ${component.isOffset ? stringifyOffset(component.value) : component.value}`;
      case 'Region': return `# ${component.regionName}\n${stringifySnapshotMappingComponents(component.value, '    ' + indent)}`
      case 'Value': return stringifyBytecodeValue(component.value);
      case 'LabeledValue': return `${component.label}: ${stringifyBytecodeValue(component.value)}`;
      case 'Attribute': return `${component.label}: ${component.value}`;
      case 'AllocationHeaderAttribute': return `Header [${component.text}]`;
      case 'UnusedSpace': return '<unused>';
      case 'Annotation': return component.text;
      case 'RegionOverflow': return `!! WARNING: Region overflow`
      case 'OverlapWarning': return `!! WARNING: Overlapping regions from address ${stringifyAddress(component.addressStart)} to ${stringifyAddress(component.addressEnd)}`
      default: assertUnreachable(component);
    }
  }

  function stringifySize(size: number | undefined, isTotal: boolean) {
    return size !== undefined
      ? isTotal
        ? col(4, size) + col(3, '-')
        : col(7, size)
      : '????'
  }
}

function stringifyBytecodeValue(value: IL.Value | Pointer | Deleted): string {
  if (value === deleted) {
    return '<deleted>';
  } else if (value.type === 'Pointer') {
    return `&${stringifyAddress(value.address)}`
  } else {
    return stringifyValue(value);
  }
}

function stringifyOffset(offset: number): string {
  return offset !== undefined
    ? Math.trunc(offset).toString(16).padStart(4, '0')
    : '????'
}

function stringifyHex4(value: number): string {
  return '0x' + value.toString(16).padStart(4, '0');
}

function col(width: number, value: any) {
  return value.toString().padStart(width, ' ');
}

function getLogicalValue(value: IL.Value | Deleted | Pointer): IL.Value | Deleted {
  if (value !== deleted && value.type === 'Pointer') {
    return value.logical;
  } else {
    return value;
  }
}

interface DecodeInstructionResult {
  operation: Omit<IL.Operation, 'stackDepthBefore' | 'stackDepthAfter'>;
  disassembly?: string;
  jumpTo?: Offset[];
}