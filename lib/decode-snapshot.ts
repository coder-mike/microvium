import * as VM from './virtual-machine-types';
import * as IL from './il';
import { Snapshot } from "./snapshot";
import { SnapshotInfo, BYTECODE_VERSION, HEADER_SIZE, ENGINE_VERSION } from "./snapshot-info";
import { notImplemented, invalidOperation, unexpected, assert, assertUnreachable, notUndefined } from "./utils";
import { SmartBuffer } from 'smart-buffer';
import { crc16ccitt } from "crc";
import { vm_TeWellKnownValues, vm_TeValueTag, UInt16 } from './runtime-types';
import * as _ from 'lodash';
import { stringifyValue } from './stringify-il';

export type SnapshotMappingComponent =
  | { type: 'Region', regionName: string, value: SnapshotMappingComponents }
  | { type: 'Reference', value: IL.ReferenceValue, label: string, address: number }
  | { type: 'Value', label: string, value: IL.Value }
  | { type: 'HeaderField', name: string, value: number, isOffset: boolean }
  | { type: 'DeletedValue' }
  | { type: 'UnusedSpace' }
  | { type: 'OverlapWarning', addressStart: number, addressEnd: number }

export type SnapshotMappingComponents = Array<{
  offset: number;
  size: number;
  logicalAddress: number | undefined;
  content: SnapshotMappingComponent;
}>;

export interface SnapshotMapping {
  bytecodeSize: number;
  components: SnapshotMappingComponents;
}

/** Decode a snapshot (bytecode) to IL */
export function decodeSnapshot(snapshot: Snapshot): { snapshotInfo: SnapshotInfo, mapping: SnapshotMapping } {
  const buffer = SmartBuffer.fromBuffer(snapshot.data);
  let region: SnapshotMappingComponents = [];
  let regionStack: { region: SnapshotMappingComponents, regionName: string | undefined, regionStart: number }[] = [];
  let regionName: string | undefined;
  let regionStart = 0;
  const dataAllocationsMapping: SnapshotMappingComponents = [];

  let nextAllocationID = 1;
  const allocationIDByAddress = new Map<number, number>();

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

  endRegion('Header');

  if (requiredEngineVersion !== ENGINE_VERSION) {
    return invalidOperation(`Engine version ${requiredEngineVersion} is not supported (expected ${ENGINE_VERSION})`);
  }

  const snapshotInfo: SnapshotInfo = {
    globalSlots: new Map(),
    functions: new Map(),
    exports: new Map(),
    allocations: new Map(),
    flags: new Set()
  };

  decodeFlags();
  decodeDataRegion();

  assert(regionStack.length === 0); // Make sure all regions have ended
  assert(regionStart === 0);

  finalizeRegions(region, regionStart);

  return {
    snapshotInfo,
    mapping: {
      bytecodeSize: snapshot.data.length,
      components: region
    }
  };

  function decodeFlags() {
    for (let i = 0; i < 32; i++) {
      if (requiredFeatureFlags & (1 << i)) {
        snapshotInfo.flags.add(i);
      }
    }
  }

  function decodeDataRegion() {
    buffer.readOffset = initialDataOffset;
    beginRegion('Data Section');
    beginRegion('Global Slots');
    for (let i = 0; i < globalVariableCount; i++) {
      const value = decodeValue(`Global slot ${i}`)!;
      snapshotInfo.globalSlots.set(`global${i}`, {
        value,
        indexHint: i
      })
    }
    endRegion('Global Slots');
    region.push({
      offset: buffer.readOffset,
      size: undefined as any,
      logicalAddress: getLogicalAddress(buffer.readOffset),
      content: {
        type: 'Region',
        regionName: 'Data allocations',
        value: dataAllocationsMapping
      }
    });
    endRegion('Data Section');
  }

  function beginRegion(name: string, computeLogical: boolean = true) {
    regionStack.push({ region, regionName, regionStart });
    const newRegion: SnapshotMappingComponents = [];
    region.push({
      offset: buffer.readOffset,
      size: undefined as any, // Will be filled in later
      logicalAddress: computeLogical ? getLogicalAddress(buffer.readOffset) : undefined,
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

  function finalizeRegions(region: SnapshotMappingComponents, regionStart: number) {
    const sortedComponents = _.sortBy(region, component => component.offset);
    region.splice(0, region.length, ...sortedComponents);
    let cursor = regionStart;
    for (const component of sortedComponents) {
      if (component.offset > cursor) {
        region.push({
          offset: cursor,
          size: component.offset - cursor,
          logicalAddress: getLogicalAddress(cursor),
          content: { type: 'UnusedSpace' }
        });
      } else if (cursor > component.offset) {
        region.push({
          offset: cursor,
          size: 0,
          logicalAddress: undefined,
          content: { type: 'OverlapWarning', addressStart: component.offset, addressEnd: cursor }
        });
      }
      // Nested region
      if (component.content.type === 'Region') {
        component.size = finalizeRegions(component.content.value, component.offset).size;
      }
      cursor = component.offset + component.size;
    }
    return { size: cursor - regionStart };
  }

  function decodeValue(label: string): IL.Value | undefined {
    const address = buffer.readOffset;
    const u16 = buffer.readUInt16LE();
    let value: IL.Value | undefined;
    if ((u16 & 0xC000) === 0) {
      value = { type: 'NumberValue', value: u16 > 0x2000 ? u16 - 0x4000 : u16 };
    } else if ((u16 & 0xC000) === vm_TeValueTag.VM_TAG_PGM_P && u16 < vm_TeWellKnownValues.VM_VALUE_WELLKNOWN_END) {
      switch (u16) {
        case vm_TeWellKnownValues.VM_VALUE_UNDEFINED: value = IL.undefinedValue; break;
        case vm_TeWellKnownValues.VM_VALUE_NULL: value = IL.nullValue; break;
        case vm_TeWellKnownValues.VM_VALUE_TRUE: value = IL.trueValue; break;
        case vm_TeWellKnownValues.VM_VALUE_FALSE: value = IL.falseValue; break;
        case vm_TeWellKnownValues.VM_VALUE_NAN: value = { type: 'NumberValue', value: NaN }; break;
        case vm_TeWellKnownValues.VM_VALUE_NEG_ZERO: value = { type: 'NumberValue', value: -0 }; break;
        case vm_TeWellKnownValues.VM_VALUE_DELETED: value = undefined; break;
        default: return unexpected();
      }
    } else {
      value = { type: 'ReferenceValue', value: addressToAllocationID(u16) };
      decodeAllocation(u16);
    }
    region.push({
      offset: address,
      size: 2,
      logicalAddress: getLogicalAddress(address),
      content: value
        ? value.type === 'ReferenceValue'
          ? { type: 'Reference', label, value, address: u16 }
          : { type: 'Value', label, value }
        : { type: 'DeletedValue' }
    });

    return value;
  }

  function addressToAllocationID(address: number): IL.AllocationID {
    if (allocationIDByAddress.has(address)) {
      return allocationIDByAddress.get(address)!;
    }

    const allocationID = nextAllocationID++;
    allocationIDByAddress.set(address, allocationID);
    return allocationID
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

  function getLogicalAddress(offset: number): number | undefined {
    if (offset >= initialHeapOffset && offset < initialHeapOffset + initialHeapSize) {
      return 0x4000 + offset - initialHeapOffset;
    }

    if (offset >= initialDataOffset && offset < initialDataOffset + initialDataSize) {
      return 0x8000 + offset - initialDataOffset;
    }

    return 0xC000 + offset;
  }

  function decodeAllocation(address: UInt16) {
    const section: vm_TeValueTag = address & 0xC000;
    switch (section) {
      case vm_TeValueTag.VM_TAG_INT: return unexpected();
      case vm_TeValueTag.VM_TAG_DATA_P:
    }
  }
}

export function stringifySnapshotMapping(mapping: SnapshotMapping): string {
  return `Bytecode size: ${mapping.bytecodeSize} B\n\nOfst Addr Size\n==== ==== ====\n${stringifySnapshotMappingComponents(mapping.components)}`;
}

function stringifyAddress(address: number | undefined): string {
  return address !== undefined
    ? address.toString(16).padStart(4, '0')
    : '    '
}

function stringifySnapshotMappingComponents(mapping: SnapshotMappingComponents, indent = ''): string {
  return _.sortBy(mapping, component => component.offset)
    .map(({ offset, logicalAddress, size, content }) => `${
      stringifyOffset(offset)
    } ${
      stringifyAddress(logicalAddress)
    } ${
      stringifySize(size)
    } ${indent}${
      stringifyComponent(content)
    }`).join('\n');

  function stringifyComponent(component: SnapshotMappingComponent): string {
    switch (component.type) {
      case 'DeletedValue': return '<deleted>';
      case 'HeaderField': return `${component.name}: ${component.isOffset ? stringifyOffset(component.value) : component.value}`;
      case 'Region': return `# ${component.regionName}\n${stringifySnapshotMappingComponents(component.value, '    ' + indent)}`
      case 'Value': return `${component.label}: ${stringifyValue(component.value)}`;
      case 'Reference': return `${component.label}: ${stringifyValue(component.value)} (&${stringifyAddress(component.address)})`
      case 'UnusedSpace': return '<unused>'
      case 'OverlapWarning': return `!! WARNING: Overlapping regions from address ${stringifyAddress(component.addressStart)} to ${stringifyAddress(component.addressEnd)}`
      default: assertUnreachable(component);
    }
  }

  function stringifyOffset(offset: number): string {
    return offset.toString(16).padStart(4, '0');
  }

  function stringifySize(size: number | undefined) {
    return size !== undefined
      ? size.toString().padStart(4, ' ')
      : '????'
  }
}