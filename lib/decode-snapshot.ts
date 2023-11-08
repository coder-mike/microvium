import * as IL from './il';
import { SnapshotIL, ENGINE_MAJOR_VERSION, HEADER_SIZE, ENGINE_MINOR_VERSION } from "./snapshot-il";
import { notImplemented, invalidOperation, unexpected, hardAssert, assertUnreachable, notUndefined, reserved, entries } from "./utils";
import { SmartBuffer } from 'smart-buffer';
import { crc16ccitt } from "crc";
import { vm_TeWellKnownValues, UInt16, TeTypeCode, mvm_TeBytecodeSection, mvm_TeBuiltins, isUInt16, isSInt14 } from './runtime-types';
import * as _ from 'lodash';
import { stringifyValue, stringifyOperation, stringifyAllocation } from './stringify-il';
import { vm_TeOpcode, vm_TeSmallLiteralValue, vm_TeOpcodeEx1, vm_TeOpcodeEx2, vm_TeOpcodeEx3, vm_TeOpcodeEx4, vm_TeBitwiseOp, vm_TeNumberOp } from './bytecode-opcodes';
import { Snapshot } from '../lib';
import { SnapshotClass } from './snapshot';
import { blockTerminatingOpcodes } from './il-opcodes';

// TODO: Everything "notImplemented" in this file.

type Offset = number;
type Section = 'gc' | 'bytecode';

interface Pointer {
  type: 'Pointer';
  offset: Offset;
  // Note: a pointer can point to a pointer in the case of the double
  // indirection of a ROM handle pointing indirectly to a RAM allocation
  target: Pointer | IL.Value;
}

type Component =
  | { type: 'Region', regionName: string, value: Region }
  | { type: 'Value', value: IL.Value | Pointer }
  | { type: 'LabeledValue', label: string, value: IL.Value | Pointer }
  | { type: 'AllocationHeaderAttribute', text: string }
  | { type: 'Attribute', label: string, value: any }
  | { type: 'Annotation', text: string }
  | { type: 'HeaderField', name: string, value: number, isOffset: boolean }
  | { type: 'UnusedSpace' }
  | { type: 'RegionOverflow' }
  | { type: 'OverlapWarning', offsetStart: number, offsetEnd: number }

// To display the disassembly, the bytecode is broken up into "regions", which have a number of items.
interface RegionItem {
  offset: number;
  size: number;
  content: Component;
}

interface TryStack {
  stackDepthBeforeTry: number;
  outer: TryStack | undefined;
}

export type Region = RegionItem[];

export interface SnapshotDisassembly {
  bytecodeSize: number;
  components: Region;
}

export interface SnapshotReconstructionInfo {
  names: {
    // The type is to disambiguate multiple names at the same address. In
    // particular, the entry block of a function has the same address as the
    // function itself, so the block has the type `block` while the function has
    // type `allocation`
    [type: string]: {
      [offset: number]: string
    }
  };
}

/** Decode a snapshot (bytecode) to IL */
export function decodeSnapshot(snapshot: Snapshot): { snapshotInfo: SnapshotIL, disassembly: string } {
  const buffer = SmartBuffer.fromBuffer(snapshot.data);
  let region: Region = [];
  let regionStack: { region: Region, regionName: string | undefined, regionStart: number }[] = [];
  let regionName: string | undefined;
  let regionStart = 0;
  const gcAllocationsRegion: Region = [];
  const romAllocationsRegion: Region = [];
  const processedAllocationsByOffset = new Map<UInt16, IL.Value>();
  const resumePointByPhysicalAddress = new Map<UInt16, IL.ResumePoint>();
  const reconstructionInfo = (snapshot instanceof SnapshotClass
    ? snapshot.reconstructionInfo
    : undefined);
  let handlesBeginOffset = Infinity;

  beginRegion('Header');

  const bytecodeVersion = readHeaderField8('bytecodeVersion');
  const headerSize = readHeaderField8('headerSize');
  const requiredEngineVersion = readHeaderField8('requiredEngineVersion');
  readHeaderField8('reserved');
  const bytecodeSize = readHeaderField16('bytecodeSize', false);
  const expectedCRC = readHeaderField16('expectedCRC', true);
  const requiredFeatureFlags = readHeaderField32('requiredFeatureFlags', false);

  if (bytecodeSize !== buffer.length) {
    return invalidOperation(`Invalid bytecode file (bytecode size mismatch)`);
  }

  if (headerSize !== HEADER_SIZE) {
    return invalidOperation(`Invalid bytecode file (header size unexpected)`);
  }

  const actualCRC = crc16ccitt(snapshot.data.slice(8));
  if (actualCRC !== expectedCRC) {
    return invalidOperation(`Invalid bytecode file (CRC mismatch)`);
  }

  if (bytecodeVersion !== ENGINE_MAJOR_VERSION) {
    return invalidOperation(`Bytecode version ${bytecodeVersion} is not supported`);
  }

  const snapshotInfo: SnapshotIL = {
    globalSlots: new Map(),
    functions: new Map(),
    exports: new Map(),
    allocations: new Map(),
    flags: new Set(),
    builtins: {
      stringPrototype: IL.undefinedValue,
      promisePrototype: IL.undefinedValue,
      arrayPrototype: IL.undefinedValue,
      asyncCatchBlock: IL.undefinedValue,
      asyncContinue: IL.undefinedValue,
      asyncHostCallback: IL.undefinedValue,
    }
  };

  // Section offsets
  const sectionOffsets: Record<mvm_TeBytecodeSection, number> = {} as any;

  for (let i = 0 as mvm_TeBytecodeSection; i < mvm_TeBytecodeSection.BCS_SECTION_COUNT; i++) {
    sectionOffsets[i] = readHeaderField16(mvm_TeBytecodeSection[i], true);
  }

  endRegion('Header');

  if (requiredEngineVersion !== ENGINE_MINOR_VERSION) {
    return invalidOperation(`Engine version ${requiredEngineVersion} is not supported (expected ${ENGINE_MINOR_VERSION})`);
  }

  // Note: we could in future decode the ROM and HEAP sections explicitly, since
  // the heap is now parsable. But for the moment, just the reachable
  // allocations in these are decoded, and they're done so as part of
  // interpreting the corresponding pointers that reference each allocation.

  decodeFlags();
  decodeImportTable();
  decodeExportTable();
  decodeShortCallTable();
  decodeBuiltins();
  decodeStringTable();
  decodeGlobals();

  region.push({
    offset: undefined as any,
    size: undefined as any,
    content: {
      type: 'Region',
      regionName: 'ROM allocations',
      value: romAllocationsRegion
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

  hardAssert(regionStack.length === 0); // Make sure all regions have ended

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
    const { offset: builtinsOffset, size } = getSectionInfo(mvm_TeBytecodeSection.BCS_BUILTINS);
    hardAssert(size === mvm_TeBuiltins.BIN_BUILTIN_COUNT * 2);
    const builtins: Record<mvm_TeBuiltins, IL.Value> = {} as any;

    beginRegion('Builtins');
    for (let i = 0 as mvm_TeBuiltins; i < mvm_TeBuiltins.BIN_BUILTIN_COUNT; i++) {
      const builtinOffset = builtinsOffset + i * 2;
      const builtinValue = buffer.readUInt16LE(builtinOffset);
      const value = decodeValue(builtinValue);
      region.push({
        offset: builtinOffset,
        size: 2,
        content: {
          type: 'LabeledValue',
          label: `[${mvm_TeBuiltins[i]}]`,
          value
        }
      });
      const logicalValue = getLogicalValue(value);
      if (logicalValue.type === 'DeletedValue') {
        return unexpected();
      }
      builtins[i] = logicalValue;
    }
    endRegion('Builtins');

    snapshotInfo.builtins.stringPrototype = builtins[mvm_TeBuiltins.BIN_STRING_PROTOTYPE];
    snapshotInfo.builtins.promisePrototype = builtins[mvm_TeBuiltins.BIN_PROMISE_PROTOTYPE];
    snapshotInfo.builtins.arrayPrototype = builtins[mvm_TeBuiltins.BIN_ARRAY_PROTO];
    snapshotInfo.builtins.asyncCatchBlock = builtins[mvm_TeBuiltins.BIN_ASYNC_CATCH_BLOCK];
    snapshotInfo.builtins.asyncHostCallback = builtins[mvm_TeBuiltins.BIN_ASYNC_HOST_CALLBACK];
    snapshotInfo.builtins.asyncContinue = builtins[mvm_TeBuiltins.BIN_ASYNC_CONTINUE];
  }

  function decodeFlags() {
    for (let i = 0; i < 32; i++) {
      if (requiredFeatureFlags & (1 << i)) {
        snapshotInfo.flags.add(i);
      }
    }
  }

  function decodeExportTable() {
    const { offset, size } = getSectionInfo(mvm_TeBytecodeSection.BCS_EXPORT_TABLE);
    buffer.readOffset = offset;
    const exportCount = size / 4;
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
      if (logicalValue.type !== 'DeletedValue') {
        snapshotInfo.exports.set(exportID, logicalValue);
      }
    }
    endRegion('Export Table');
  }

  function decodeShortCallTable() {
    const { size } = getSectionInfo(mvm_TeBytecodeSection.BCS_SHORT_CALL_TABLE);
    if (size > 0) {
      return notImplemented(); // TODO
    }
  }

  function decodeStringTable() {
    const { size, offset } = getSectionInfo(mvm_TeBytecodeSection.BCS_STRING_TABLE);
    buffer.readOffset = offset;
    const stringTableCount = size / 2;
    beginRegion('String Table');
    for (let i = 0; i < stringTableCount; i++) {
      let value = readValue(`[${i}]`)!;
    }
    endRegion('String Table');
  }

  function getName(offset: Offset, type: string): string | undefined {
    if (reconstructionInfo) {
      const name = reconstructionInfo.names[type]?.[offset];
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

  function hasName(offset: Offset, type: string) : boolean | undefined {
    if (reconstructionInfo) {
      return offset in reconstructionInfo.names[type];
    } else {
      return undefined;
    }
  }

  function decodeGlobals() {
    const { offset, size } = getSectionInfo(mvm_TeBytecodeSection.BCS_GLOBALS);
    const globalVariableCount = size / 2;
    buffer.readOffset = offset;
    beginRegion('Globals');
    for (let i = 0; i < globalVariableCount; i++) {
      const slotOffset = offset + i * 2;
      // Handles are at the end of the globals
      const isHandle = slotOffset >= handlesBeginOffset;
      if (isHandle) {
        readValue(`Handle`);
      } else {
        const value = readValue(`[${i}]`)!;
        if (value.type === 'DeletedValue') continue;
        snapshotInfo.globalSlots.set(getNameOfGlobal(i), {
          value,
          indexHint: i
        })
      }
    }
    endRegion('Globals');
  }

  function decodeImportTable() {
    const { offset, size } = getSectionInfo(mvm_TeBytecodeSection.BCS_IMPORT_TABLE);
    buffer.readOffset = offset;
    const importCount = size / 2;
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

  function getSectionInfo(section: mvm_TeBytecodeSection) {
    const offset = getSectionOffset(section);
    const size = getSectionSize(section);
    const end = offset + size;
    return { offset, size, end };

    function getSectionOffset(section: mvm_TeBytecodeSection): number {
      return sectionOffsets[section] ?? unexpected();
    }

    function getSectionSize(section: mvm_TeBytecodeSection): number {
      if (section < mvm_TeBytecodeSection.BCS_SECTION_COUNT - 1) {
        return getSectionOffset(section + 1) - getSectionOffset(section);
      } else {
        hardAssert(section === mvm_TeBytecodeSection.BCS_SECTION_COUNT - 1);
        return bytecodeSize - getSectionOffset(section);
      }
    }
  }


  function beginRegion(name: string) {
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
    hardAssert(regionName === name);
    hardAssert(regionStack.length > 0);
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
              content: { type: 'RegionOverflow' }
            });
            console.error(`!! WARNING: Region overflow at 0x${finalizeResult.offset.toString(16).padStart(4, '0')} by ${component.offset - finalizeResult.offset} bytes`);
          }
          if (component.size === undefined) {
            component.size = finalizeResult.size;
          } else if (finalizeResult.size > component.size) {
            component.content.value.push({
              offset: component.offset + finalizeResult.size,
              size: component.size - finalizeResult.size,
              content: { type: 'RegionOverflow' }
            });
            console.error(`!! WARNING: Region overflow at 0x${(component.offset + component.size).toString(16).padStart(4, '0')} by ${component.offset - finalizeResult.offset} bytes`);
          } else if (component.size > finalizeResult.size) {
            component.content.value.push({
              offset: component.offset + component.size,
              size: component.size - finalizeResult.size,
              content: { type: 'UnusedSpace' }
            });
          }
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

      if (component.offset > cursor) {
        region.push({
          offset: cursor,
          size: component.offset - cursor,
          content: { type: 'UnusedSpace' }
        });
      } else if (cursor > component.offset) {
        region.push({
          offset: cursor,
          size: - (cursor - component.offset), // Negative size
          content: { type: 'OverlapWarning', offsetStart: component.offset, offsetEnd: cursor }
        });
        console.error(`!! WARNING: Entry overlap at 0x${component.offset} by ${cursor - component.offset} bytes`);
      }

      region.push(component);
      cursor = component.offset + component.size;
    }

    if (end !== undefined && cursor < end) {
      region.push({
        offset: cursor,
        size: end - cursor,
        content: { type: 'UnusedSpace' }
      });
      cursor = end;
    }
    return { size: cursor - regionStart, offset: regionStart };
  }

  function readValue(label: string): IL.Value {
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

  function readLogicalAt(offset: number, region: Region, label: string, shallow: boolean = false): IL.Value {
    const value = readValueAt(offset, region, label, shallow);
    const logical = getLogicalValue(value);
    return logical;
  }

  function readValueAt(offset: number, region: Region, label: string, shallow: boolean = false): IL.Value | Pointer {
    const u16 = buffer.readUInt16LE(offset);
    const value = decodeValue(u16, shallow);

    region.push({
      offset,
      size: 2,
      content: { type: 'LabeledValue', label, value }
    });

    return value;
  }

  function decodeValue(u16: UInt16, shallow: boolean = false): IL.Value | Pointer {
    if ((u16 & 1) === 0) {
      return decodeShortPtr(u16, shallow);
    } else if ((u16 & 3) === 1) {
      if (u16 < vm_TeWellKnownValues.VM_VALUE_WELLKNOWN_END) {
        return decodeWellKnown(u16);
      } else {
        return decodeBytecodeMappedPtr(u16 & 0xFFFC, shallow);
      }
    } else {
      hardAssert((u16 & 3) === 3);
      return decodeVirtualInt14(u16);
    }
  }

  function decodeBytecodeMappedPtr(offset: Offset, shallow: boolean): Pointer {
    // If the pointer points to a global variable, it is treated as logically
    // pointing to the thing that global variable points to.
    const { offset: globalsOffset, end: globalsEnd } = getSectionInfo(mvm_TeBytecodeSection.BCS_GLOBALS);
    const isHandle = offset >= globalsOffset && offset < globalsEnd;
    if (isHandle) {
      const handle16 = buffer.readUInt16LE(offset);
      handlesBeginOffset = Math.min(handlesBeginOffset, offset);
      const handleValue = decodeValue(handle16);
      if (handleValue.type === 'DeletedValue') return unexpected();
      return {
        type: 'Pointer',
        offset,
        target: handleValue
      }
    }

    const { offset: romOffset, end: romEnd } = getSectionInfo(mvm_TeBytecodeSection.BCS_ROM);
    if (offset >= romOffset && offset < romEnd) {
      return {
        type: 'Pointer',
        offset,
        target: decodeAllocationAtOffset(offset, 'bytecode', shallow)
      };
    }

    return invalidOperation('Pointer out of range')
  }

  function decodeWellKnown(u16: UInt16): IL.Value {
    const value = u16 as vm_TeWellKnownValues;
    switch (value) {
      case vm_TeWellKnownValues.VM_VALUE_UNDEFINED: return IL.undefinedValue;
      case vm_TeWellKnownValues.VM_VALUE_NULL: return IL.nullValue;
      case vm_TeWellKnownValues.VM_VALUE_TRUE: return IL.trueValue;
      case vm_TeWellKnownValues.VM_VALUE_FALSE: return IL.falseValue;
      case vm_TeWellKnownValues.VM_VALUE_NAN: return IL.numberValue(NaN);
      case vm_TeWellKnownValues.VM_VALUE_NEG_ZERO: return IL.numberValue(-0);
      case vm_TeWellKnownValues.VM_VALUE_DELETED: return IL.deletedValue;
      case vm_TeWellKnownValues.VM_VALUE_STR_LENGTH: return IL.stringValue('length');
      case vm_TeWellKnownValues.VM_VALUE_STR_PROTO: return IL.stringValue('__proto__');
      case vm_TeWellKnownValues.VM_VALUE_NO_OP_FUNC: return IL.noOpFunction;
      case vm_TeWellKnownValues.VM_VALUE_WELLKNOWN_END: return unexpected();
      default: return unexpected();
    }
  }

  function decodeShortPtr(u16: UInt16, shallow: boolean): Pointer {
    hardAssert((u16 & 0xFFFE) === u16);
    const offset = getSectionInfo(mvm_TeBytecodeSection.BCS_HEAP).offset + u16;
    return {
      type: 'Pointer',
      offset,
      target: decodeAllocationAtOffset(offset, 'gc', shallow)
    };
  }

  function decodeVirtualInt14(u16: UInt16): IL.NumberValue {
    u16 = u16 >> 2;
    const value = u16 >= 0x2000 ? u16 - 0x4000 : u16;
    return { type: 'NumberValue', value };
  }

  function offsetToAllocationID(offset: number): IL.AllocationID {
    const name = getName(offset, 'allocation');
    return name !== undefined ? parseInt(name) : offset;
  }

  function readHeaderField8(name: string) {
    const address = buffer.readOffset;
    const value = buffer.readUInt8();
    region.push({
      offset: address,
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

  function decodeAllocationAtOffset(offset: Offset, section: Section, shallow: boolean): IL.Value {
    if (shallow) {
      return undefined as any;
    }
    if (processedAllocationsByOffset.has(offset)) {
      return processedAllocationsByOffset.get(offset)!;
    }

    const value = decodeAllocationContent(offset, section);
    // The decode is supposed to insert the value. It needs to do this itself
    // because it needs to happen before nested allocations are pursued. The
    // exception is resume points which look like allocations at first but are
    // actually value types that reference into a function allocation.
    hardAssert(value.type === 'ResumePoint' || processedAllocationsByOffset.get(offset) === value);
    return value;
  }

  function readAllocationHeader(allocationOffset: Offset, region: Region) {
    const headerWord = buffer.readUInt16LE(allocationOffset - 2);
    const size = (headerWord & 0xFFF); // Size excluding header
    const typeCode: TeTypeCode = headerWord >> 12;

    // Allocation header
    region.push({
      offset: allocationOffset - 2,
      size: 2,
      content: { type: 'AllocationHeaderAttribute', text: `Size: ${size}, Type: ${TeTypeCode[typeCode]}` }
    });

    return { size, typeCode };
  }

  function getAllocationRegionForSection(section: Section): Region {
    switch (section) {
      case 'bytecode': return romAllocationsRegion;
      case 'gc': return gcAllocationsRegion;
      default: return assertUnreachable(section);
    }
  }

  function decodeAllocationContent(offset: Offset, section: Section): IL.Value {
    const region = getAllocationRegionForSection(section);
    // Note: in the case of functions, the size bits are repurposed and don't
    // represent the actual allocation size
    const { size, typeCode } = readAllocationHeader(offset, region);
    switch (typeCode) {
      case TeTypeCode.TC_REF_TOMBSTONE: return unexpected();
      case TeTypeCode.TC_REF_INT32: return decodeInt32(region, offset, size);
      case TeTypeCode.TC_REF_FLOAT64: return decodeFloat64(region, offset, size);
      case TeTypeCode.TC_REF_STRING:
      case TeTypeCode.TC_REF_INTERNED_STRING: return decodeString(region, offset, size);
      case TeTypeCode.TC_REF_PROPERTY_LIST: return decodePropertyList(region, offset, size, section);
      case TeTypeCode.TC_REF_ARRAY: return decodeArray(region, offset, size, false, section);
      case TeTypeCode.TC_REF_FIXED_LENGTH_ARRAY: return decodeArray(region, offset, size, true, section);
      case TeTypeCode.TC_REF_FUNCTION: return decodeFunction(region, offset, size);
      case TeTypeCode.TC_REF_HOST_FUNC: return decodeHostFunction(region, offset, size);
      case TeTypeCode.TC_REF_CLOSURE: return decodeClosure(region, offset, size, section);
      case TeTypeCode.TC_REF_SYMBOL: return reserved();
      case TeTypeCode.TC_REF_VIRTUAL: return reserved();
      case TeTypeCode.TC_REF_UINT8_ARRAY: return decodeUint8Array(region, offset, size, section);
      case TeTypeCode.TC_REF_CLASS: return decodeClass(region, offset, size);
      case TeTypeCode.TC_REF_RESERVED_1: return unexpected();
      default: return unexpected();
    }
  }

  function decodeInt32(region: Region, offset: number, size: number): IL.Value {
    const i = buffer.readInt32LE(offset);
    const value: IL.NumberValue = {
      type: 'NumberValue',
      value: i
    };
    processedAllocationsByOffset.set(offset, value);
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

  function decodeFloat64(region: Region, offset: number, size: number): IL.Value {
    const n = buffer.readDoubleLE(offset);
    const value: IL.NumberValue = {
      type: 'NumberValue',
      value: n
    };
    processedAllocationsByOffset.set(offset, value);
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

  function decodeFunction(region: Region, offset: number, sizeBits: number): IL.Value {
    /*
    `decodeFunction` is called when it finds an allocation with a
    TC_REF_FUNCTION header type-code. This used to mean that we've encountered
    the main entry point for a function, but now the introduction of async-await
    means that a function has multiple entry points.
    */
    const isResumePoint = Boolean(sizeBits & 0x0800);
    if (isResumePoint) {
      return decodeResumePoint(region, offset, sizeBits);
    } else {
      return decodeFunctionFromMainEntry(region, offset, sizeBits);
    }
  }

  function decodeResumePoint(region: Region, offset: number, sizeBits: number): IL.Value {
    // Hack: a resume point is the only thing that looks like an allocation but
    // actually points into an existing allocation. So even though there is a
    // header, we don't want this shown in the disassembly because it will show
    // up again when we decode the main function.
    const allocationHeader = region.pop();
    hardAssert(allocationHeader?.content.type === 'AllocationHeaderAttribute');

    const resumeAddress = offset;
    sizeBits = sizeBits & ~0x800;
    hardAssert((resumeAddress & 0xFFFC) == resumeAddress);
    // Read function header that precedes the instruction
    hardAssert(((TeTypeCode.TC_REF_FUNCTION << 12) | 0x0800 | sizeBits) === buffer.readUInt16LE(resumeAddress - 2));
    // The back-pointer reuses the bits that are normally used for the allocation size
    const backPointer = sizeBits << 2;
    const mainFunctionAddress = resumeAddress - backPointer;
    // Sanity-check that we've found the main function address correctly
    const mainHeader = buffer.readUInt16LE(mainFunctionAddress - 2);
    hardAssert(mainHeader >> 12 === TeTypeCode.TC_REF_FUNCTION);
    hardAssert((mainHeader & 0x0800) === 0); // Not a continuation

    // Synthesize an mvm_Value representing the function pointer so we
    // can use the common decoding logic
    const mainFunctionValue = mainFunctionAddress | 1;
    // Note: the `decodeValue` function as a side effect will actually decode
    // the main function, if it's not already decoding. This is because the
    // resume point is reachable independently of the main entry point to the
    // function, and so we could have encountered this `VM_OP3_ASYNC_RESUME`
    // before encountering the main function (or we might only encounter the
    // main function through one of its resume points).
    const mainFunction = getLogicalValue(decodeValue(mainFunctionValue));
    hardAssert(mainFunction.type === 'FunctionValue');

    // As a consequence of decoding the main function, all the resume points in
    // the function will also be decoded, so we can do a lookup to find this
    // resume point.
    const resumePoint = resumePointByPhysicalAddress.get(resumeAddress);
    hardAssert(resumePoint?.type === 'ResumePoint');
    return resumePoint!;
  }

  function decodeFunctionFromMainEntry(region: Region, offset: number, sizeBits: number): IL.Value {
    const functionID = getName(offset, 'allocation') || stringifyOffset(offset);
    const functionValue: IL.FunctionValue = {
      type: 'FunctionValue',
      value: functionID
    };
    processedAllocationsByOffset.set(offset, functionValue);

    // Note: for functions, the size bits have been repurposed
    const isContinuation = Boolean(sizeBits & 0x0800);
    hardAssert(!isContinuation); // Not supported yet
    const maxStackDepth = sizeBits & 0x00FF;

    const ilFunc: IL.Function = {
      type: 'Function',
      id: functionID,
      blocks: {},
      maxStackDepth: maxStackDepth,
      entryBlockID: offsetToBlockID(offset),
    };
    snapshotInfo.functions.set(ilFunc.id, ilFunc);

    const functionBodyRegion: Region = [{
      offset,
      size: 0,
      content: {
        type: 'Attribute',
        label: 'maxStackDepth',
        value: maxStackDepth
      }
    }, {
      offset,
      size: 0,
      content: {
        type: 'Attribute',
        label: 'isContinuation',
        value: isContinuation ? 1 : 0
      }
    }];
    const { blocks, size } = decodeInstructions(functionBodyRegion, offset, functionID);
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

  function decodeInstructions(region: Region, offset: number, functionID: IL.FunctionID) {
    const originalReadOffset = buffer.readOffset;
    buffer.readOffset = offset;
    // Because the size bits of the function header are repurposed, we need to
    // infer the size by the last reachable instruction in the instruction graph.
    let functionEndOffset = offset;
    const instructionsCovered = new Set<number>();
    const blockEntryOffsets = new Set<number>();
    const instructionsByOffset = new Map<number, [IL.Operation, string, number]>();
    const decodingBlock = new Map<Offset, { stackDepth: number | undefined }>();

    // The entry point is at the beginning (and this will also explore the whole
    // reachable instruction graph)
    decodeBlock(offset, 0, undefined);
    buffer.readOffset = originalReadOffset;

    const blocks = divideInstructionsIntoBlocks();

    const size = functionEndOffset - offset;

    return { blocks, size };

    function divideInstructionsIntoBlocks() {
      const blocks: { [name: string]: IL.Block } = {};
      const instructionsInOrder = _.sortBy([...instructionsByOffset], ([offset]) => offset);

      hardAssert(instructionsInOrder.length > 0);
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

        const isStartOfBlock = block.operations.length === 0;

        // Resume points are special because they're addressable, so we need to
        // register them globally. Catch blocks are also special because they're
        // addressable. We don't know which blocks are catch blocks, so we just
        // map all the blocks (the start of every block).
        if (instruction.opcode === 'AsyncResume' || isStartOfBlock) {
          resumePointByPhysicalAddress.set(instructionOffset, {
            type: 'ResumePoint',
            address: {
              type: 'ProgramAddressValue',
              funcId: functionID,
              blockId: block.id,
              operationIndex: block.operations.length
            }
          })
        }

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
            if (!blockTerminatingOpcodes.has(instruction.opcode)) {
              // Add implicit jump/fall-through
              block.operations.push({
                opcode: 'Jump',
                stackDepthBefore: instruction.stackDepthBefore,
                stackDepthAfter: instruction.stackDepthAfter,
                operands: [{
                  type: 'LabelOperand',
                  targetBlockId: offsetToBlockID(nextOffset)
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

    function decodeBlock(blockOffset: number, stackDepth: number, tryStack: TryStack | undefined) {
      if (decodingBlock.has(blockOffset)) {
        hardAssert(decodingBlock.get(blockOffset)!.stackDepth === stackDepth, `Inconsistent stack depth at block 0x${blockOffset.toString(16)}`);
        return;
      }
      decodingBlock.set(blockOffset, { stackDepth })
      const blockLinks: JumpTarget[] = [];
      const prevOffset = buffer.readOffset;
      buffer.readOffset = blockOffset;
      blockEntryOffsets.add(blockOffset);
      while (true) {
        if (instructionsCovered.has(buffer.readOffset)) {
          break;
        }
        instructionsCovered.add(buffer.readOffset);

        const instructionOffset = buffer.readOffset;
        const stackDepthBefore = stackDepth;
        const decodeResult = decodeInstruction(region, stackDepthBefore, tryStack);
        if (buffer.readOffset > functionEndOffset) {
          functionEndOffset = buffer.readOffset;
        }
        const opcode: IL.Operation['opcode'] = decodeResult.operation.opcode;
        const op: IL.Operation = {
          ...decodeResult.operation,
          opcode: opcode as any,
          stackDepthBefore: notUndefined(stackDepthBefore),
          stackDepthAfter: undefined as any,
        };

        // Special case for StartTry and EndTry because they jump stack depths
        if (opcode === 'StartTry') {
          tryStack = { outer: tryStack, stackDepthBeforeTry: stackDepth }
          stackDepth += 2;
        } else if (opcode === 'EndTry') {
          stackDepth = notUndefined(tryStack).stackDepthBeforeTry;
          tryStack = notUndefined(tryStack).outer;
        } else {
          const calculateStackDepthChange = IL.calcStaticStackChangeOfOp(op) ?? unexpected();
          stackDepth += calculateStackDepthChange;
        }

        op.stackDepthAfter = stackDepth;
        const size = buffer.readOffset - instructionOffset;
        const disassembly = decodeResult.disassembly || stringifyOperation(op);
        instructionsByOffset.set(instructionOffset, [op, disassembly, size]);

        // Control flow operations
        if (decodeResult.jumpTo) {
          blockLinks.push(...decodeResult.jumpTo.targets);
          if (!decodeResult.jumpTo.alsoContinue) break;
        }
      }
      buffer.readOffset = prevOffset;

      for (const { offset, stackDepth, tryStack } of blockLinks) {
        decodeBlock(offset, stackDepth, tryStack);
      }
    }
  }

  function decodeHostFunction(region: Region, offset: number, size: number): IL.Value {
    const hostFunctionIndex = buffer.readUInt16LE(offset);
    const { offset: importTableOffset, size: importTableSize } = getSectionInfo(mvm_TeBytecodeSection.BCS_IMPORT_TABLE);
    const hostFunctionIDOffset = importTableOffset + hostFunctionIndex * 2;
    hardAssert(hostFunctionIDOffset < importTableOffset + importTableSize);
    const hostFunctionID = buffer.readUInt16LE(hostFunctionIDOffset);
    const hostFunctionValue: IL.HostFunctionValue = {
      type: 'HostFunctionValue',
      value: hostFunctionID
    }
    processedAllocationsByOffset.set(offset, hostFunctionValue);
    region.push({
      offset: offset,
      size: size,
      content: {
        type: 'Attribute',
        label: 'Value',
        value: `Import Table [${hostFunctionIndex}] (&${stringifyOffset(hostFunctionIDOffset)})`
      }
    });
    return hostFunctionValue;
  }

  function decodeString(region: Region, offset: number, size: number): IL.Value {
    const origOffset = buffer.readOffset;
    buffer.readOffset = offset;
    const str = buffer.readString(size - 1, 'utf8');
    buffer.readOffset = origOffset;
    const value: IL.StringValue = {
      type: 'StringValue',
      value: str
    };
    processedAllocationsByOffset.set(offset, value);
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

  function decodePropertyList(region: Region, offset: number, size: number, section: Section): IL.Value {
    const allocationID = offsetToAllocationID(offset);

    const object: IL.ObjectAllocation = {
      type: 'ObjectAllocation',
      allocationID,
      prototype: undefined as any, // Will be populated below
      properties: {},
      memoryRegion: getAllocationMemoryRegion(section),
      keysAreFixed: false,
      internalSlots: [IL.deletedValue, IL.deletedValue]
    };
    snapshotInfo.allocations.set(allocationID, object);

    const ref: IL.ReferenceValue = {
      type: 'ReferenceValue',
      value: allocationID
    };
    processedAllocationsByOffset.set(offset, ref);

    const objRegion: Region = [];
    let groupRegion = objRegion;
    let groupOffset = offset;
    let groupSize = size;
    let internalSlotIndex = 2;
    while (true) {
      const dpNext = decodeValue(buffer.readUInt16LE(groupOffset), true);
      if (dpNext.type === 'DeletedValue') return unexpected();
      groupRegion.push({
        size: 2,
        offset: groupOffset,
        content: {
          type: 'LabeledValue',
          label: 'dpNext',
          value: dpNext
        }
      })
      const dpProto = readLogicalAt(groupOffset + 2, groupRegion, 'dpProto');
      if (groupOffset === offset) { // First group
        object.prototype = dpProto;
      } else if (dpProto.type !== 'NullValue') {
        return invalidOperation('Only the first TsPropertyList in the chain should have a prototype.');
      }

      const propsOffset = groupOffset + 4;
      const propCount = (groupSize - 4) / 4; // Each key-value pair is 4 bytes
      for (let i = 0; i < propCount; i++) {
        const propOffset = propsOffset + i * 4;
        const key = readLogicalAt(propOffset, groupRegion, 'key');
        const value = readValueAt(propOffset + 2, groupRegion, 'value');
        const logical = getLogicalValue(value);

        // Internal slots
        if (key.type === 'NumberValue' && isSInt14(key.value) && key.value < 0) {
          // Both the key and value are considered to be distinct internal
          // slots, so we can use the key slot for storage (as long as it's
          // storing a negative int14)
          object.internalSlots[internalSlotIndex++] = key;
          object.internalSlots[internalSlotIndex++] = logical;
          continue;
        }

        if (key.type !== 'StringValue') {
          return invalidOperation('Expected property key to be string')
        }
        const keyStr = key.value;
        if (logical.type !== 'DeletedValue') {
          object.properties[keyStr] = logical;
        }
      }
      // Next group, if there is one
      if (dpNext.type === 'NullValue') {
        break;
      }
      if (dpNext.type !== 'Pointer') {
        return unexpected();
      }
      // TODO: Test this path
      groupRegion = [];
      groupOffset = dpNext.offset;
      const { size, typeCode } = readAllocationHeader(groupOffset, region);
      groupSize = size;
      hardAssert(typeCode === TeTypeCode.TC_REF_PROPERTY_LIST);
      region.push({
        offset: groupOffset,
        size: undefined as any, // Inferred
        content: {
          type: 'Region',
          regionName: `Child TsPropertyList`,
          value: groupRegion
        }
      })
    }

    region.push({
      offset: offset,
      size: size,
      content: {
        type: 'Region',
        regionName: `TsPropertyList`,
        value: objRegion
      }
    });

    return ref;
  }

  function decodeClass(region: Region, offset: number, size: number): IL.Value {
    hardAssert(size === 4);
    const classRegion: Region = [];

    const constructorFunc = readLogicalAt(offset, classRegion, 'constructorFunc');
    const staticProps = readLogicalAt(offset + 2, classRegion, 'staticProps');

    region.push({
      offset,
      size,
      content: {
        type: 'Region',
        regionName: 'Class',
        value: classRegion
      }
    });

    const value: IL.ClassValue = {
      type: 'ClassValue',
      staticProps,
      constructorFunc
    }
    processedAllocationsByOffset.set(offset, value);

    return value;
  }

  function decodeClosure(region: Region, offset: number, size: number, section: Section): IL.Value {
    const memoryRegion = getAllocationMemoryRegion(section);
    const allocationID = offsetToAllocationID(offset);

    const closure: IL.ClosureAllocation = {
      type: 'ClosureAllocation',
      allocationID,
      slots: [],
      memoryRegion,
    };
    snapshotInfo.allocations.set(allocationID, closure);

    const ref: IL.ReferenceValue = {
      type: 'ReferenceValue',
      value: allocationID
    };
    processedAllocationsByOffset.set(offset, ref);

    const closureRegion: Region = [];

    const length = size / 2;
    for (let i = 0; i < length; i++) {
      const itemOffset = offset + i * 2;
      const itemRaw = buffer.readUInt16LE(itemOffset);
      const item = decodeValue(itemRaw);
      const logical = getLogicalValue(item);
      closure.slots[i] = logical;
      closureRegion.push({
        offset: itemOffset,
        size: 2,
        content: {
          type: 'LabeledValue',
          label: `closure[${i}]`,
          value: item
        }
      })
    }

    region.push({
      offset,
      size,
      content: {
        type: 'Region',
        regionName: 'TsClosure',
        value: closureRegion
      }
    });

    return ref;
  }

  function decodeArray(region: Region, offset: number, size: number, isFixedLengthArray: boolean, section: Section): IL.Value {
    const memoryRegion = getAllocationMemoryRegion(section);
    const allocationID = offsetToAllocationID(offset);
    const array: IL.ArrayAllocation = {
      type: 'ArrayAllocation',
      allocationID,
      items: [],
      memoryRegion,
      lengthIsFixed: isFixedLengthArray
    };
    snapshotInfo.allocations.set(allocationID, array);

    const ref: IL.ReferenceValue = {
      type: 'ReferenceValue',
      value: allocationID
    };
    processedAllocationsByOffset.set(offset, ref);

    const arrayRegion: Region = [];
    let regionName: string;

    if (isFixedLengthArray) {
      // See TsFixedLengthArray
      regionName = 'TsFixedLengthArray';
      const length = size / 2;
      const items = readArrayItems(offset, length, arrayRegion);
      array.items = items;
    } else {
      // See TsArray
      // Dynamic arrays have an extra wrapper that points to their items
      regionName = 'TsArray';
      const dpData = readValueAt(offset, arrayRegion, 'dpData', true);
      const lengthValue = readLogicalAt(offset + 2, arrayRegion, 'viLength');
      if (lengthValue.type !== 'NumberValue') return unexpected();
      const length = lengthValue.value;
      if (!isSInt14(length)) return unexpected();
      if (dpData.type === 'DeletedValue') return unexpected();
      if (dpData.type !== 'NullValue') {
        if (dpData.type !== 'Pointer') return unexpected();
        const itemsOffset = dpData.offset;
        const { size, typeCode } = readAllocationHeader(itemsOffset, region);
        hardAssert(typeCode === TeTypeCode.TC_REF_FIXED_LENGTH_ARRAY);
        hardAssert(length <= size / 2);
        const itemsRegion: Region = [];
        const items = readArrayItems(itemsOffset, length, itemsRegion);
        array.items = items;
        region.push({
          offset: itemsOffset,
          size,
          content: {
            type: 'Region',
            regionName: `TsFixedLengthArray`,
            value: itemsRegion
          }
        });
      }
    }

    region.push({
      offset,
      size,
      content: {
        type: 'Region',
        regionName: regionName,
        value: arrayRegion
      }
    });

    return ref;
  }

  function decodeUint8Array(region: Region, offset: number, size: number, section: Section): IL.Value {
    const memoryRegion = getAllocationMemoryRegion(section);
    const allocationID = offsetToAllocationID(offset);
    const uint8Array: IL.Uint8ArrayAllocation = {
      type: 'Uint8ArrayAllocation',
      allocationID,
      bytes: [],
      memoryRegion
    };

    const origOffset = buffer.readOffset;
    buffer.readOffset = offset;
    for (let i = 0; i < size; i++) {
      uint8Array.bytes.push(buffer.readUInt8());
    }
    buffer.readOffset = origOffset;

    snapshotInfo.allocations.set(allocationID, uint8Array);

    const value: IL.ReferenceValue = {
      type: 'ReferenceValue',
      value: allocationID
    };
    processedAllocationsByOffset.set(offset, value);

    region.push({
      offset,
      size,
      content: {
        type: 'Annotation',
        text: stringifyAllocation(uint8Array)
      }
    });

    return value;
  }

  function readArrayItems(offset: number, length: number, itemsRegion: Region): IL.ArrayAllocation['items'] {
    const items: IL.ArrayAllocation['items'] = [];
    for (let i = 0; i < length; i++) {
      const itemOffset = offset + i * 2;
      const itemRaw = buffer.readUInt16LE(itemOffset);
      const item = decodeValue(itemRaw);
      const logical = getLogicalValue(item);
      if (logical.type !== 'DeletedValue') {
        items[i] = logical;
      } else {
        items[i] = undefined;
      }
      itemsRegion.push({
        offset: itemOffset,
        size: 2,
        content: {
          type: 'LabeledValue',
          label: `[${i}]`,
          value: item
        }
      })
    }
    return items;
  }

  function getAllocationMemoryRegion(section: Section): IL.ObjectAllocation['memoryRegion'] {
    const memoryRegion: IL.ObjectAllocation['memoryRegion'] =
      section === 'gc' ? 'gc':
      section === 'bytecode' ? 'rom':
      unexpected();

    return memoryRegion;
  }

  function decodeInstruction(region: Region, stackDepthBefore: number | undefined, tryStack: TryStack | undefined): DecodeInstructionResult {
    let x = buffer.readUInt8();
    const opcode: vm_TeOpcode = x >> 4;
    const param = x & 0xF;
    switch (opcode) {
      case vm_TeOpcode.VM_OP_LOAD_SMALL_LITERAL: {
        let literalValue: IL.Value;
        const valueCode: vm_TeSmallLiteralValue = param;
        switch (valueCode) {
          case vm_TeSmallLiteralValue.VM_SLV_DELETED: literalValue = IL.deletedValue; break;
          case vm_TeSmallLiteralValue.VM_SLV_UNDEFINED: literalValue = IL.undefinedValue; break;
          case vm_TeSmallLiteralValue.VM_SLV_NULL: literalValue = IL.nullValue; break;
          case vm_TeSmallLiteralValue.VM_SLV_FALSE: literalValue = IL.falseValue; break;
          case vm_TeSmallLiteralValue.VM_SLV_TRUE: literalValue = IL.trueValue; break;
          case vm_TeSmallLiteralValue.VM_SLV_INT_MINUS_1: literalValue = IL.numberValue(-1); break;
          case vm_TeSmallLiteralValue.VM_SLV_INT_0: literalValue = IL.numberValue(0); break;
          case vm_TeSmallLiteralValue.VM_SLV_INT_1: literalValue = IL.numberValue(1); break;
          case vm_TeSmallLiteralValue.VM_SLV_INT_2: literalValue = IL.numberValue(2); break;
          case vm_TeSmallLiteralValue.VM_SLV_INT_3: literalValue = IL.numberValue(3); break;
          case vm_TeSmallLiteralValue.VM_SLV_INT_4: literalValue = IL.numberValue(4); break;
          case vm_TeSmallLiteralValue.VM_SLV_INT_5: literalValue = IL.numberValue(5); break;
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
      case vm_TeOpcode.VM_OP_LOAD_SCOPED_1: {
        return opLoadScoped(param);
      }
      case vm_TeOpcode.VM_OP_LOAD_ARG_1: {
        return opLoadArg(param);
      }
      case vm_TeOpcode.VM_OP_CALL_1: {
        return notImplemented(); // TODO
      }
      case vm_TeOpcode.VM_OP_FIXED_ARRAY_NEW_1: {
        return {
          operation: {
            opcode: 'ArrayNew',
            operands: [],
            staticInfo: {
              minCapacity: param,
              fixedLength: true
            }
          },
          disassembly: `ArrayNew() [length=${param}]`
        }
      }
      case vm_TeOpcode.VM_OP_EXTENDED_1: {
        const subOp: vm_TeOpcodeEx1 = param as vm_TeOpcodeEx1;
        switch (subOp) {
          case vm_TeOpcodeEx1.VM_OP1_RETURN: {
            return {
              operation: {
                opcode: 'Return',
                operands: [],
                staticInfo: {
                  returnUndefined: false
                }
              },
              jumpTo: { targets: [], alsoContinue: false }
            }
          }
          case vm_TeOpcodeEx1.VM_OP1_THROW: {
            return {
              operation: {
                opcode: 'Throw',
                operands: [],
                staticInfo: {
                  returnUndefined: true
                }
              },
              jumpTo: { targets: [], alsoContinue: false }
            }
          }
          case vm_TeOpcodeEx1.VM_OP1_CLOSURE_NEW: {
            return {
              operation: {
                opcode: 'ClosureNew',
                operands: []
              }
            };
          }
          case vm_TeOpcodeEx1.VM_OP1_TYPE_CODE_OF: {
            return {
              operation: {
                opcode: 'UnOp',
                operands: [{
                  type: 'OpOperand',
                  subOperation: 'typeCodeOf'
                }]
              }
            };
          }
          case vm_TeOpcodeEx1.VM_OP1_SCOPE_NEW: {
            return {
              operation: {
                opcode: 'ScopeNew',
                operands: [{
                  type: 'CountOperand',
                  count: buffer.readUInt8(),
                }]
              }
            };
          }
          case vm_TeOpcodeEx1.VM_OP1_POP: {
            return {
              operation: {
                opcode: 'Pop',
                operands: [{
                  type: 'CountOperand',
                  count: 1
                }]
              }
            };
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
          }case vm_TeOpcodeEx1.VM_OP1_OBJECT_GET_1: {
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
          case vm_TeOpcodeEx1.VM_OP1_END: {
            return unexpected();
          }
          case vm_TeOpcodeEx1.VM_OP1_NEW: {
            const argCount = buffer.readUInt8();
            return {
              operation: {
                opcode: 'New',
                operands: [{ type: 'CountOperand', count: argCount }]
              }
            }
          }
          case vm_TeOpcodeEx1.VM_OP1_RESERVED_VIRTUAL_NEW: {
            reserved();
          }
          case vm_TeOpcodeEx1.VM_OP1_TYPEOF: {
            return {
              operation: {
                opcode: 'UnOp',
                operands: [{
                  type: 'OpOperand',
                  subOperation: 'typeof'
                }]
              }
            };
          }
          default:
            return assertUnreachable(subOp);
        }
      }
      case vm_TeOpcode.VM_OP_EXTENDED_2: {
        const subOp: vm_TeOpcodeEx2 = param as vm_TeOpcodeEx2;
        switch (subOp) {
          case vm_TeOpcodeEx2.VM_OP2_BRANCH_1: {
            const offsetFromCurrent = buffer.readInt8();
            const offset = buffer.readOffset + offsetFromCurrent;
            return opBranch(offset);
          }
          case vm_TeOpcodeEx2.VM_OP2_STORE_ARG: {
            return notImplemented();
          }
          case vm_TeOpcodeEx2.VM_OP2_STORE_SCOPED_2: {
            const index = buffer.readUInt8();
            return opStoreScoped(index);
          }
          case vm_TeOpcodeEx2.VM_OP2_STORE_VAR_2: {
            return notImplemented();
          }
          case vm_TeOpcodeEx2.VM_OP2_ARRAY_GET_2_RESERVED: {
            return notImplemented();
          }
          case vm_TeOpcodeEx2.VM_OP2_ARRAY_SET_2_RESERVED: {
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
            const param = buffer.readUInt8();
            const argCount = param & 0x7F;
            const isVoidCall = Boolean(param & 0x80);
            return {
              operation: {
                opcode: 'Call',
                operands: [
                  { type: 'CountOperand', count: argCount },
                  { type: 'FlagOperand', flag: isVoidCall },
                ]
              }
            }
          }
          case vm_TeOpcodeEx2.VM_OP2_CALL_6: {
            return notImplemented(); // TODO
          }
          case vm_TeOpcodeEx2.VM_OP2_LOAD_SCOPED_2: {
            const index = buffer.readUInt8();
            return opLoadScoped(index);
          }
          case vm_TeOpcodeEx2.VM_OP2_LOAD_VAR_2: {
            const index = buffer.readUInt8();
            return opLoadVar(index);
          }
          case vm_TeOpcodeEx2.VM_OP2_LOAD_ARG_2: {
            const index = buffer.readUInt8();
            return opLoadArg(index);
          }
          case vm_TeOpcodeEx2.VM_OP2_EXTENDED_4: {
            const subOp: vm_TeOpcodeEx4 = buffer.readUInt8() as vm_TeOpcodeEx4;
            switch (subOp) {

              case vm_TeOpcodeEx4.VM_OP4_START_TRY: {
                // Subtract 1 because these addresses are encoded with a LSb of 1 to hide from the GC
                const catchAddress = buffer.readUInt16LE() - 1;
                hardAssert((catchAddress & 1) == 0)
                return {
                  operation: {
                    opcode: 'StartTry',
                    operands: [{
                      type: 'LabelOperand',
                      targetBlockId: offsetToBlockID(catchAddress)
                    }],
                  },
                  disassembly: `StartTry(&${stringifyOffset(catchAddress)})`,
                  jumpTo: {
                    targets: [{
                      offset: catchAddress,
                      stackDepth: notUndefined(stackDepthBefore) + 1,
                      tryStack: tryStack
                    }],
                    alsoContinue: true
                  }
                }
              }

              case vm_TeOpcodeEx4.VM_OP4_END_TRY: {
                return {
                  operation: {
                    opcode: 'EndTry',
                    operands: []
                  },
                  disassembly: `EndTry()`
                }
              }

              case vm_TeOpcodeEx4.VM_OP4_OBJECT_KEYS: {
                return {
                  operation: {
                    opcode: 'ObjectKeys',
                    operands: []
                  },
                  disassembly: `ObjectKeys()`
                }
              }

              case vm_TeOpcodeEx4.VM_OP4_UINT8_ARRAY_NEW: {
                return {
                  operation: {
                    opcode: 'Uint8ArrayNew',
                    operands: []
                  },
                  disassembly: `Uint8ArrayNew()`
                }
              }

              case vm_TeOpcodeEx4.VM_OP4_CLASS_CREATE: {
                return {
                  operation: {
                    opcode: 'ClassCreate',
                    operands: []
                  },
                  disassembly: `ClassCreate()`
                }
              }

              case vm_TeOpcodeEx4.VM_OP4_TYPE_CODE_OF: {
                return {
                  operation: {
                    opcode: 'TypeCodeOf',
                    operands: []
                  },
                  disassembly: `TypeCodeOf()`
                }
              }

              case vm_TeOpcodeEx4.VM_OP4_END: {
                return unexpected();
              }

              case vm_TeOpcodeEx4.VM_OP4_LOAD_REG_CLOSURE: {
                return {
                  operation: {
                    opcode: 'LoadReg',
                    operands: [{
                      type: 'NameOperand',
                      name: 'closure'
                    }]
                  },
                  disassembly: "LoadReg('closure')"
                }
              }

              case vm_TeOpcodeEx4.VM_OP4_SCOPE_PUSH: {
                const count = buffer.readUInt8();
                return {
                  operation: {
                    opcode: 'ScopePush',
                    operands: [{
                      type: 'CountOperand',
                      count,
                    }]
                  },
                  disassembly: `ScopePush(${count})`
                };
              }

              case vm_TeOpcodeEx4.VM_OP4_SCOPE_POP: {
                return {
                  operation: {
                    opcode: 'ScopePop',
                    operands: []
                  },
                  disassembly: 'ScopePop'
                };
              }

              case vm_TeOpcodeEx4.VM_OP4_SCOPE_SAVE: {
                return {
                  operation: {
                    opcode: 'ScopeSave',
                    operands: []
                  },
                  disassembly: 'ScopeSave'
                };
              }

              case vm_TeOpcodeEx4.VM_OP4_ASYNC_START: {
                const param = buffer.readUInt8();
                const slotCount = param & 0x7F;
                const captureParent = param & 0x80 ? true : false;
                return {
                  operation: {
                    opcode: 'AsyncStart',
                    operands: [{
                      type: 'CountOperand',
                      count: slotCount
                    }, {
                      type: 'FlagOperand',
                      flag: captureParent
                    }]
                  },
                  disassembly: `AsyncStart(${slotCount}, ${captureParent})`
                };
              }

              case vm_TeOpcodeEx4.VM_OP4_ASYNC_RETURN: {
                return {
                  operation: {
                    opcode: 'AsyncReturn',
                    operands: []
                  },
                  disassembly: 'AsyncReturn',
                  jumpTo: { targets: [], alsoContinue: false }
                };
              }

              case vm_TeOpcodeEx4.VM_OP4_ENQUEUE_JOB: {
                return {
                  operation: {
                    opcode: 'EnqueueJob',
                    operands: []
                  },
                  disassembly: 'EnqueueJob'
                };
              }

              case vm_TeOpcodeEx4.VM_OP4_ASYNC_COMPLETE: {
                return {
                  operation: {
                    opcode: 'AsyncComplete',
                    operands: []
                  },
                  jumpTo: { targets: [], alsoContinue: false },
                  disassembly: 'AsyncComplete',
                };
              }

              default: return assertUnreachable(subOp);
            }
          }
          case vm_TeOpcodeEx2.VM_OP2_ARRAY_NEW: {
            const capacity = buffer.readUInt8();
            return {
              operation: {
                opcode: 'ArrayNew',
                operands: [],
                staticInfo: {
                  minCapacity: capacity,
                  fixedLength: false
                }
              },
              disassembly: `ArrayNew() [capacity=${capacity}]`
            }
          }
          case vm_TeOpcodeEx2.VM_OP2_FIXED_ARRAY_NEW_2: {
            const length = buffer.readUInt8();
            return {
              operation: {
                opcode: 'ArrayNew',
                operands: [],
                staticInfo: {
                  minCapacity: length,
                  fixedLength: true
                }
              },
              disassembly: `ArrayNew() [length=${length}]`
            }
          }
          case vm_TeOpcodeEx2.VM_OP2_END: {
            return unexpected();
          }
          default: return assertUnreachable(subOp);
        }
      }
      case vm_TeOpcode.VM_OP_EXTENDED_3: {
        const subOp: vm_TeOpcodeEx3 = param;
        switch (subOp) {
          case vm_TeOpcodeEx3.VM_OP3_POP_N: {
            const count = buffer.readUInt8();
            return {
              operation: {
                opcode: 'Pop',
                operands: [{
                  type: 'CountOperand',
                  count
                }]
              }
            }
          }
          case vm_TeOpcodeEx3.VM_OP3_JUMP_2: {
            const offsetFromCurrent = buffer.readInt16LE();
            const offset = buffer.readOffset + offsetFromCurrent;
            return opJump(offset);
          }
          case vm_TeOpcodeEx3.VM_OP3_LOAD_LITERAL: {
            const u16 = buffer.readUInt16LE();
            const value = decodeValue(u16);
            const logical = getLogicalValue(value);
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
          case vm_TeOpcodeEx3.VM_OP3_END: {
            return unexpected();
          }
          case vm_TeOpcodeEx3.VM_OP3_LOAD_SCOPED_3: {
            const index = buffer.readUInt16LE();
            return opLoadScoped(index);
          }
          case vm_TeOpcodeEx3.VM_OP3_STORE_SCOPED_3: {
            const index = buffer.readUInt16LE();
            return opStoreScoped(index);
          }
          case vm_TeOpcodeEx3.VM_OP3_SCOPE_DISCARD: {
            return opScopeDiscard();
          }
          case vm_TeOpcodeEx3.VM_OP3_SCOPE_CLONE: {
            return opScopeClone();
          }
          case vm_TeOpcodeEx3.VM_OP3_AWAIT: {
            /*
            An await is followed by some padding and then a function header, and
            then the AsyncResume instruction. The decode loops expects to find
            an instruction at the next address, so we need to consume the
            padding and function header here.
            */
            const addr = buffer.readOffset;
            buffer.readOffset = (addr + 3 + 2) & 0xFFFC; // Skip padding and header
            return {
              operation: {
                opcode: 'Await',
                operands: []
              },
              disassembly: `Await()`
            }
          }
          case vm_TeOpcodeEx3.VM_OP3_AWAIT_CALL: {
            const argCount = buffer.readUInt8();
            return {
              operation: {
                opcode: 'AwaitCall',
                operands: [{
                  type: 'CountOperand',
                  count: argCount
                }]
              },
              disassembly: `AwaitCall(${argCount})`
            }
          }
          case vm_TeOpcodeEx3.VM_OP3_ASYNC_RESUME: {
            const slotCount = buffer.readUInt8();
            const catchTarget = buffer.readUInt8();
            // Note: we don't know the IL address of the current instruction
            // because the instructions are only grouped into blocks after
            // they're all decoded, so we can't yet register this location in
            // the `resumePointByPhysicalAddress` map.
            return {
              operation: {
                opcode: 'AsyncResume',
                operands: [{
                  type: 'CountOperand',
                  count: slotCount,
                }, {
                  type: 'CountOperand',
                  count: catchTarget,
                }]
              },
              disassembly: `AsyncResume(${slotCount})`
            }
          }
          case vm_TeOpcodeEx3.VM_OP3_RESERVED_3: {
            return notImplemented();
          }
          default: {
            return assertUnreachable(subOp);
          }
        }
      }
      case vm_TeOpcode.VM_OP_CALL_5: {
        const argCount = buffer.readUInt8();
        return {
          operation: {
            opcode: 'Call',
            operands: [{ type: 'CountOperand', count: argCount }]
          }
        }
      }
      case vm_TeOpcode.VM_OP_STORE_VAR_1: {
        return opStoreVar(param);
      }
      case vm_TeOpcode.VM_OP_STORE_SCOPED_1: {
        const index = param;
        return opStoreScoped(index);
      }
      case vm_TeOpcode.VM_OP_ARRAY_GET_1: {
        return notImplemented(); // TODO
      }
      case vm_TeOpcode.VM_OP_ARRAY_SET_1: {
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
            index: notUndefined(stackDepthBefore) - index - 1
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
            index: notUndefined(stackDepthBefore) - index - 2
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

    function opLoadScoped(index: number): DecodeInstructionResult {
      return {
        operation: {
          opcode: 'LoadScoped',
          operands: [{
            type: 'IndexOperand',
            index
          }]
        },
        disassembly: `LoadScoped [${index}]`
      }
    }

    function opStoreScoped(index: number): DecodeInstructionResult {
      return {
        operation: {
          opcode: 'StoreScoped',
          operands: [{
            type: 'IndexOperand',
            index
          }]
        },
        disassembly: `StoreScoped [${index}]`
      }
    }

    function opScopeDiscard(): DecodeInstructionResult {
      return {
        operation: {
          opcode: 'ScopeDiscard',
          operands: []
        },
        disassembly: `ScopeDiscard`
      }
    }

    function opScopeClone(): DecodeInstructionResult {
      return {
        operation: {
          opcode: 'ScopeClone',
          operands: []
        },
        disassembly: `ScopeClone`
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
            targetBlockId: offsetToBlockID(offset)
          }, {
            type: 'LabelOperand',
            targetBlockId: offsetToBlockID(offsetAlternate)
          }]
        },
        disassembly: `Branch &${stringifyOffset(offset)}`,
        jumpTo: {
          targets: [
            { offset, stackDepth: notUndefined(stackDepthBefore) - 1, tryStack },
            { offset: offsetAlternate, stackDepth: notUndefined(stackDepthBefore) - 1, tryStack }
          ],
          alsoContinue: false
        }
      }
    }

    function opJump(offset: number): DecodeInstructionResult {
      // Special case for "Nop" which is the only time there is a valid jump to
      // an anonymous offset. This is where a jump instruction jumps to
      if (hasName(offset, 'block') === false /* note: false not including undefined */) {
        hardAssert(offset > 0);
        const nopSize = offset + 3 - buffer.readOffset;
        hardAssert(nopSize > 0);
        buffer.readOffset = offset;
        return {
          operation: {
            opcode: 'Nop',
            operands: [{
              type: 'CountOperand',
              count: nopSize
            }]
          },
          disassembly: `Nop as Jump &${stringifyOffset(offset)}`
        }
      }
      return {
        operation: {
          opcode: 'Jump',
          operands: [{
            type: 'LabelOperand',
            targetBlockId: offsetToBlockID(offset)
          }]
        },
        disassembly: `Jump &${stringifyOffset(offset)}`,
        jumpTo: {
          targets: [{ offset, stackDepth: notUndefined(stackDepthBefore), tryStack }],
          alsoContinue: false,
        }
      }
    }
  }

  function getNameOfGlobal(index: number) {
    const globalsOffset = getSectionInfo(mvm_TeBytecodeSection.BCS_GLOBALS).offset;
    const offset = globalsOffset + index * 2;
    return getName(offset, 'global') || `global${index}`;
  }

  function offsetToBlockID(offset: Offset): string {
    return getName(offset, 'block') || stringifyOffset(offset);
  }
}

function stringifyDisassembly(mapping: SnapshotDisassembly): string {
  return `Bytecode size: ${mapping.bytecodeSize} B\n\nAddr    Size\n==== =======\n${stringifySnapshotMappingComponents(mapping.components)}`;
}

function stringifySnapshotMappingComponents(region: Region, indent = ''): string {
  return region
    .map(({ offset, size, content }) => `${
      stringifyOffset(offset)
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
      case 'OverlapWarning': return `!! WARNING: Overlapping regions from ${stringifyOffset(component.offsetStart)} to ${stringifyOffset(component.offsetEnd)}`
      default: assertUnreachable(component);
    }
  }

  function stringifySize(size: number | undefined, isTotal: boolean) {
    const sizeStr = size?.toString(16);
    return sizeStr !== undefined
      ? isTotal
        ? col(4, sizeStr) + col(3, '-')
        : col(7, sizeStr)
      : '????'
  }
}

function stringifyBytecodeValue(value: IL.Value | Pointer): string {
  if (value.type === 'Pointer') {
    return `&${stringifyOffset(value.offset)}`
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

/* Unwraps pointers */
function getLogicalValue(value: IL.Value | Pointer): IL.Value {
  if (value.type === 'Pointer') {
    const target = value.target;
    if (target.type === 'Pointer') {
      return getLogicalValue(target);
    } else {
      return target;
    }
  } else {
    return value;
  }
}

interface DecodeInstructionResult {
  operation: Omit<IL.Operation, 'stackDepthBefore' | 'stackDepthAfter'>;
  disassembly?: string;
  jumpTo?: {
    targets: JumpTarget[];
    alsoContinue: boolean;
  }
}

interface JumpTarget {
  offset: Offset;
  stackDepth: number;
  tryStack: TryStack | undefined;
}