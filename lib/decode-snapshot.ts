import * as VM from './virtual-machine-types';
import * as IL from './il';
import { Snapshot } from "./snapshot";
import { SnapshotInfo, BYTECODE_VERSION, HEADER_SIZE, ENGINE_VERSION } from "./snapshot-info";
import { notImplemented, invalidOperation, unexpected, assert, assertUnreachable, notUndefined } from "./utils";
import { SmartBuffer } from 'smart-buffer';
import { crc16ccitt } from "crc";
import { vm_TeWellKnownValues, vm_TeValueTag, UInt16, TeTypeCode } from './runtime-types';
import * as _ from 'lodash';
import { stringifyValue } from './stringify-il';

type SnapshotMappingComponent =
  | { type: 'Region', regionName: string, value: SnapshotMappingComponents }
  | { type: 'Reference', value: IL.ReferenceValue, label: string, address: number }
  | { type: 'Value', label: string, value: IL.Value }
  | { type: 'Allocation' } // TODO: Remove this placeholder
  | { type: 'Attribute', label: string, value: any }
  | { type: 'Annotation', text: string }
  | { type: 'HeaderField', name: string, value: number, isOffset: boolean }
  | { type: 'DeletedValue' }
  | { type: 'UnusedSpace' }
  | { type: 'RegionOverflow' }
  | { type: 'OverlapWarning', addressStart: number, addressEnd: number }

interface SnapshotMappingComponentsItem {
  offset: number;
  size: number;
  logicalAddress?: number;
  content: SnapshotMappingComponent;
}

export type SnapshotMappingComponents = SnapshotMappingComponentsItem[];

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
  const gcAllocationsMapping: SnapshotMappingComponents = [];
  const romAllocationsMapping: SnapshotMappingComponents = [];
  const processedAllocations = new Set<UInt16>();

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
  decodeGlobalSlots();

  region.push({
    offset: buffer.readOffset,
    size: undefined as any,
    content: {
      type: 'Region',
      regionName: 'Data allocations',
      value: dataAllocationsMapping
    }
  });

  region.push({
    offset: undefined as any,
    size: undefined as any,
    content: {
      type: 'Region',
      regionName: 'GC allocations',
      value: gcAllocationsMapping
    }
  });

  region.push({
    offset: undefined as any,
    size: undefined as any,
    content: {
      type: 'Region',
      regionName: 'ROM allocations',
      value: romAllocationsMapping
    }
  });

  assert(regionStack.length === 0); // Make sure all regions have ended

  finalizeRegions(region, 0, buffer.length);

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

  function decodeGlobalSlots() {
    buffer.readOffset = initialDataOffset;
    beginRegion('Globals');
    for (let i = 0; i < globalVariableCount; i++) {
      const value = readValue(`[${i}]`)!;
      snapshotInfo.globalSlots.set(`global${i}`, {
        value,
        indexHint: i
      })
    }
    endRegion('Globals');
  }

  function beginRegion(name: string, computeLogical: boolean = true) {
    regionStack.push({ region, regionName, regionStart });
    const newRegion: SnapshotMappingComponents = [];
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

  function finalizeRegions(region: SnapshotMappingComponents, start?: number, end?: number) {
    if (region.length === 0) return undefined;

    const sortedComponents = _.sortBy(region, component => component.offset);
    // Clear out and rebuild
    region.splice(0, region.length);

    const regionStart = start !== undefined ? start : sortedComponents[0].offset;

    let cursor = regionStart;
    for (const component of sortedComponents) {
      // Nested region
      if (component.content.type === 'Region') {
        const finalizeResult = finalizeRegions(component.content.value);
        // Delete empty region
        if (!finalizeResult) {
          component.size = 0;
          continue;
        } else {
          if (component.offset === undefined) {
            component.offset = finalizeResult.offset;
          } else if (finalizeResult.offset < component.offset) {
            region.push({
              offset: component.offset,
              size: finalizeResult.offset - component.offset,
              logicalAddress: getLogicalAddress(cursor, finalizeResult.offset - component.offset),
              content: { type: 'RegionOverflow' }
            });
          }
          if (component.size === undefined) {
            component.size = finalizeResult.size;
          } else if (finalizeResult.size > component.size) {
            region.push({
              offset: component.offset + finalizeResult.size,
              size: component.size - finalizeResult.size,
              logicalAddress: getLogicalAddress(cursor, component.size - finalizeResult.size),
              content: { type: 'RegionOverflow' }
            });
          }
          component.logicalAddress = getLogicalAddress(component.offset, component.size);
        }
      }

      component.logicalAddress = getLogicalAddress(component.offset, component.size);

      if (component.offset > cursor) {
        region.push({
          offset: cursor,
          size: component.offset - cursor,
          logicalAddress: getLogicalAddress(cursor, component.offset - cursor),
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
        logicalAddress: getLogicalAddress(cursor, end - cursor),
        content: { type: 'UnusedSpace' }
      });
      cursor = end;
    }
    return { size: cursor - regionStart, offset: regionStart };
  }

  function readValue(label: string, offset?: number): IL.Value | undefined {
    const offsetResolved = offset === undefined ? buffer.readOffset : offset;
    const u16 = buffer.readUInt16LE(offset);
    const value = decodeValue(u16);

    region.push({
      offset: offsetResolved,
      size: 2,
      content: value
        ? value.type === 'ReferenceValue'
          ? { type: 'Reference', label, value, address: u16 }
          : { type: 'Value', label, value }
        : { type: 'DeletedValue' }
    });

    return value;
  }

  function decodeValue(u16: UInt16): IL.Value | undefined {
    if ((u16 & 0xC000) === 0) {
      return { type: 'NumberValue', value: u16 > 0x2000 ? u16 - 0x4000 : u16 };
    } else if ((u16 & 0xC000) === vm_TeValueTag.VM_TAG_PGM_P && u16 < vm_TeWellKnownValues.VM_VALUE_WELLKNOWN_END) {
      switch (u16) {
        case vm_TeWellKnownValues.VM_VALUE_UNDEFINED: return IL.undefinedValue; break;
        case vm_TeWellKnownValues.VM_VALUE_NULL: return IL.nullValue; break;
        case vm_TeWellKnownValues.VM_VALUE_TRUE: return IL.trueValue; break;
        case vm_TeWellKnownValues.VM_VALUE_FALSE: return IL.falseValue; break;
        case vm_TeWellKnownValues.VM_VALUE_NAN: return { type: 'NumberValue', value: NaN }; break;
        case vm_TeWellKnownValues.VM_VALUE_NEG_ZERO: return { type: 'NumberValue', value: -0 }; break;
        case vm_TeWellKnownValues.VM_VALUE_DELETED: return undefined; break;
        default: return unexpected();
      }
    } else {
      decodeAllocation(u16);
      return { type: 'ReferenceValue', value: addressToAllocationID(u16) };
    }
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

  function getLogicalAddress(offset: number, size: number): number | undefined {
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

  function decodeAllocation(address: UInt16) {
    if (processedAllocations.has(address)) {
      return;
    }
    processedAllocations.add(address);
    const { offset, section } = locateAddress(address);

    decodeAllocationContent(offset, address, section);
  }

  function locateAddress(address: number): { section: SnapshotMappingComponents, offset: number } {
    const sectionCode: vm_TeValueTag = address & 0xC000;
    let offset: number;
    let section: SnapshotMappingComponents;

    switch (sectionCode) {
      case vm_TeValueTag.VM_TAG_INT: return unexpected();
      case vm_TeValueTag.VM_TAG_GC_P: {
        offset = initialHeapOffset + (address - vm_TeValueTag.VM_TAG_GC_P);
        section = gcAllocationsMapping;
        break;
      }
      case vm_TeValueTag.VM_TAG_PGM_P: {
        offset = address - vm_TeValueTag.VM_TAG_PGM_P;
        section = romAllocationsMapping;
        break;
      }
      case vm_TeValueTag.VM_TAG_DATA_P: {
        offset = initialDataOffset + (address - vm_TeValueTag.VM_TAG_DATA_P);
        section = dataAllocationsMapping;
        break;
      }
      default: return assertUnreachable(sectionCode);
    }
    return { offset, section };
  }

  function decodeAllocationContent(offset: number, address: number, section: SnapshotMappingComponents): void {
    let startOffset = offset - 2;
    const headerWord = buffer.readUInt16LE(startOffset);
    const allocationHeader: SnapshotMappingComponentsItem = { offset: startOffset, size: 2, content: { type: 'Attribute', label: 'Allocation header', value: stringifyHex4(headerWord) } };
    const allocationSize = (headerWord & 0xFFF);
    let totalSize = allocationSize + 2;
    const typeCode: TeTypeCode = headerWord >> 12;
    const allocationID = addressToAllocationID(address);

    // Arrays are special in that they have a length prefix
    if (typeCode === TeTypeCode.TC_REF_ARRAY) {
      startOffset -= 2;
      totalSize += 2;
      const length = buffer.readUInt16LE(startOffset);
      const capacity = allocationSize / 2;
      section.push({
        offset: startOffset,
        size: totalSize,
        content: {
          type: 'Region',
          regionName: `allocation ${allocationID} (&${stringifyAddress(address)}): Array`,
          value: [
            { offset: startOffset, size: 2, content: { type: 'Attribute', label: 'length', value: length } },
            { offset: startOffset + 2, size: 2, content: { type: 'Attribute', label: 'capacity', value: capacity } },
            ...(length > 0
              ? [notImplemented()]
              : [{ offset, size: 0, content: { type: 'Annotation' as 'Annotation', text: '<no array items>' } }])
          ]
        }
      });
    } else if (typeCode === TeTypeCode.TC_REF_PROPERTY_LIST) {
      const first = buffer.readUInt16LE(offset);
      section.push({
        offset: startOffset,
        size: totalSize,
        content: {
          type: 'Region',
          regionName: `allocation ${allocationID} (&${stringifyAddress(address)}): Object as TsPropertyList`,
          value: [
            allocationHeader,
            { offset, size: 2, content: { type: 'Attribute', label: 'first', value: `&${stringifyAddress(first)}` } },
          ]
        }
      });

      // Follow linked list of cells
      let cellAddress = first;
      while (cellAddress) {
        const { offset, section } = locateAddress(cellAddress);
        const next = buffer.readUInt16LE(offset);
        const key = buffer.readUInt16LE(offset + 2);
        const value = buffer.readUInt16LE(offset + 4);
        section.push({
          offset,
          size: 6,
          content: {
            type: 'Region',
            regionName: `Property Cell @${stringifyAddress(cellAddress)}`,
            value: [
              {
                offset: offset + 0,
                size: 2,
                content: { type: 'Attribute', label: 'next', value: `&${stringifyAddress(next)}` }
              },
              {
                offset: offset + 2,
                size: 2,
                content: { type: 'Value', label: 'key', value: notUndefined(decodeValue(key)) }
              },
              {
                offset: offset + 4,
                size: 2,
                content: { type: 'Value', label: 'value', value: notUndefined(decodeValue(value)) }
              }
            ]
          }
        });
        cellAddress = next;
      }

    } else {
      section.push({
        offset: startOffset,
        size: totalSize,
        content: {
          type: 'Allocation',
        }
      });
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
      case 'Attribute': return `${component.label}: ${component.value}`;
      case 'UnusedSpace': return '<unused>';
      case 'Annotation': return component.text;
      case 'Allocation': return 'Allocation';
      case 'RegionOverflow': return `!! WARNING: Region overflow`
      case 'OverlapWarning': return `!! WARNING: Overlapping regions from address ${stringifyAddress(component.addressStart)} to ${stringifyAddress(component.addressEnd)}`
      default: assertUnreachable(component);
    }
  }

  function stringifyOffset(offset: number): string {
    return offset !== undefined
      ? offset.toString(16).padStart(4, '0')
      : '????'
  }

  function stringifySize(size: number | undefined) {
    return size !== undefined
      ? size.toString().padStart(4, ' ')
      : '????'
  }
}

function stringifyHex4(value: number): string {
  return '0x' + value.toString(16).padStart(4, '0');
}