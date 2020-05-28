import * as VM from './virtual-machine-types';
import * as IL from './il';
import { Snapshot } from "./snapshot";
import { SnapshotInfo, BYTECODE_VERSION, HEADER_SIZE, ENGINE_VERSION } from "./snapshot-info";
import { notImplemented, invalidOperation, unexpected, assert, assertUnreachable, notUndefined, reserved } from "./utils";
import { SmartBuffer } from 'smart-buffer';
import { crc16ccitt } from "crc";
import { vm_TeWellKnownValues, vm_TeValueTag, UInt16, TeTypeCode } from './runtime-types';
import * as _ from 'lodash';
import { stringifyValue } from './stringify-il';
import { vm_TeOpcode, vm_TeSmallLiteralValue } from './bytecode-opcodes';

const deleted = Symbol('Deleted');
type Deleted = typeof deleted;

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

/** Decode a snapshot (bytecode) to IL */
export function decodeSnapshot(snapshot: Snapshot): { snapshotInfo: SnapshotInfo, disassembly: SnapshotDisassembly } {
  const buffer = SmartBuffer.fromBuffer(snapshot.data);
  let region: Region = [];
  let regionStack: { region: Region, regionName: string | undefined, regionStart: number }[] = [];
  let regionName: string | undefined;
  let regionStart = 0;
  const dataAllocationsRegion: Region = [];
  const gcAllocationsRegion: Region = [];
  const romAllocationsRegion: Region = [];
  const processedAllocations = new Map<UInt16, IL.Value>();

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
  decodeGCRoots();
  decodeImportTable();
  decodeExportTable();
  decodeShortCallTable();
  decodeStringTable();

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

  return {
    snapshotInfo,
    disassembly: {
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

  function decodeGlobalSlots() {
    buffer.readOffset = initialDataOffset;
    beginRegion('Globals');
    for (let i = 0; i < globalVariableCount; i++) {
      let value = readValue(`[${i}]`)!;
      if (value === deleted) continue;
      snapshotInfo.globalSlots.set(`global${i}`, {
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
            region.push({
              offset: component.offset,
              size: finalizeResult.offset - component.offset,
              logicalAddress: getLogicalAddress(component.offset, finalizeResult.offset - component.offset),
              content: { type: 'RegionOverflow' }
            });
          }
          if (component.size === undefined) {
            component.size = finalizeResult.size;
          } else if (finalizeResult.size > component.size) {
            region.push({
              offset: component.offset + finalizeResult.size,
              size: component.size - finalizeResult.size,
              logicalAddress: getLogicalAddress(component.offset + finalizeResult.size, component.size - finalizeResult.size),
              content: { type: 'RegionOverflow' }
            });
          }
          component.logicalAddress = getLogicalAddress(component.offset, component.size);
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
        case vm_TeWellKnownValues.VM_VALUE_NAN: return { type: 'NumberValue', value: NaN }; break;
        case vm_TeWellKnownValues.VM_VALUE_NEG_ZERO: return { type: 'NumberValue', value: -0 }; break;
        case vm_TeWellKnownValues.VM_VALUE_DELETED: return deleted; break;
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
    return address;
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
    let arrayLength = 0;

    // Arrays are special in that they have a length prefix
    if (typeCode === TeTypeCode.TC_REF_ARRAY) {
      arrayLength = buffer.readUInt16LE(offset - 4);
      // Array length
      region.push({
        offset: offset - 4,
        size: 2,
        content: { type: 'AllocationHeaderAttribute', text: `Array length: ${arrayLength}` }
      });
    }

    // Allocation header
    region.push({
      offset: offset - 2,
      size: 2,
      content: { type: 'AllocationHeaderAttribute', text: `Size: ${size}, Type: ${TeTypeCode[typeCode]}` }
    });

    switch (typeCode) {
      case TeTypeCode.TC_REF_NONE: return notImplemented();
      case TeTypeCode.TC_REF_INT32: return notImplemented();
      case TeTypeCode.TC_REF_FLOAT64: return notImplemented();
      case TeTypeCode.TC_REF_STRING: return notImplemented();
      case TeTypeCode.TC_REF_UNIQUE_STRING: return decodeUniqueString(region, address, offset, size);
      case TeTypeCode.TC_REF_PROPERTY_LIST: return decodePropertyList(region, address, offset, size);
      case TeTypeCode.TC_REF_ARRAY: return decodeArray(region, address, offset, size, arrayLength);
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

  function decodeFunction(region: Region, address: number, offset: number, size: number): IL.Value {
    const functionID = stringifyAddress(address);
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
      entryBlockID: stringifyAddress(address + 1),
    };
    snapshotInfo.functions.set(ilFunc.id, ilFunc);

    // Extract instructions
    const instructions = decodeInstructions(region, address + 1, size - 1);

    // Determine blocks (anything that is jumped to)
    // TODO

    // Compute stackDepthBefore and stackDepthAfter for each instruction

    region.push({
      offset,
      size,
      content: {
        type: 'Region',
        regionName: 'Function',
        value: [{
          offset,
          size: 1,
          content: {
            type: 'Attribute',
            label: 'maxStackDepth',
            value: maxStackDepth
          }
        }]
      }
    });

    return functionValue;
  }

  function decodeInstructions(region: Region, offset: number, size: number) {
    const originalReadOffset = buffer.readOffset;
    // while (buffer.readOffset < offset + size) {
    //   decodeInstruction(buffer, region);
    // }
    buffer.readOffset = originalReadOffset;
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
        value: `Import Table [${hostFunctionIndex}] (&${stringifyAddress(getLogicalAddress(hostFunctionIDOffset, 1))})`
      }
    });
    return hostFunctionValue;
  }

  function decodeUniqueString(region: Region, address: number, offset: number, size: number): IL.Value {
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

  function decodeArray(region: Region, address: number, offset: number, size: number, length: number): IL.Value {
    const memoryRegion = getMemoryRegion(region);
    const allocationID = addressToAllocationID(address);
    const object: IL.ArrayAllocation = {
      type: 'ArrayAllocation',
      allocationID,
      items: [],
      memoryRegion,
      lengthIsFixed: memoryRegion !== 'gc'
    };
    snapshotInfo.allocations.set(allocationID, object);
    snapshotInfo.allocations.set(allocationID, object);

    const ref: IL.ReferenceValue = {
      type: 'ReferenceValue',
      value: allocationID
    };
    processedAllocations.set(address, ref);

    region.push({
      offset,
      size: size,
      content: {
        type: 'Region',
        regionName: `Array`,
        value: [
          ...(length > 0
            ? [notImplemented()]
            : [{ offset, size: 0, content: { type: 'Annotation' as 'Annotation', text: '<no array items>' } }])
        ]
      }
    });

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
}

export function stringifySnapshotMapping(mapping: SnapshotDisassembly): string {
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
      case 'Value': {
        if (component.value === deleted) {
          return '<deleted>';
        } else if (component.value.type === 'Pointer') {
          return `&${stringifyAddress(component.value.address)}`
        } else {
          return stringifyValue(component.value);
        }
      }
      case 'LabeledValue': {
        if (component.value === deleted) {
          return `${component.label}: <deleted>`;
        } else if (component.value.type === 'Pointer') {
          return `${component.label}: &${stringifyAddress(component.value.address)}`
        } else {
          return `${component.label}: ${stringifyValue(component.value)}`;
        }
      }
      case 'Attribute': return `${component.label}: ${component.value}`;
      case 'AllocationHeaderAttribute': return `Header [${component.text}]`;
      case 'UnusedSpace': return '<unused>';
      case 'Annotation': return component.text;
      case 'RegionOverflow': return `!! WARNING: Region overflow`
      case 'OverlapWarning': return `!! WARNING: Overlapping regions from address ${stringifyAddress(component.addressStart)} to ${stringifyAddress(component.addressEnd)}`
      default: assertUnreachable(component);
    }
  }

  function stringifyOffset(offset: number): string {
    return offset !== undefined
      ? Math.trunc(offset).toString(16).padStart(4, '0')
      : '????'
  }

  function stringifySize(size: number | undefined, isTotal: boolean) {
    return size !== undefined
      ? isTotal
        ? col(4, size) + col(3, '-')
        : col(7, size)
      : '????'
  }
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

function decodeInstruction(buffer: SmartBuffer, region: Region): {
  operation: IL.Operation,
  disassembly?: string
} {
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
          opcode: 'Literal', operands: [{
            type: 'LiteralOperand',
            literal: literalValue
          }],
          stackDepthBefore: undefined as any,
          stackDepthAfter: undefined as any,
        }
      }
    }
    case vm_TeOpcode.VM_OP_LOAD_VAR_1: {
      return notImplemented(); // TODO
    }
    case vm_TeOpcode.VM_OP_LOAD_GLOBAL_1: {
      return notImplemented(); // TODO
    }
    case vm_TeOpcode.VM_OP_LOAD_ARG_1: {
      return notImplemented(); // TODO
    }
    case vm_TeOpcode.VM_OP_CALL_1: {
      return notImplemented(); // TODO
    }
    case vm_TeOpcode.VM_OP_EXTENDED_1: {
      return notImplemented(); // TODO
    }
    case vm_TeOpcode.VM_OP_EXTENDED_2: {
      return notImplemented(); // TODO
    }
    case vm_TeOpcode.VM_OP_EXTENDED_3: {
      return notImplemented(); // TODO
    }
    case vm_TeOpcode.VM_OP_POP: {
      return notImplemented(); // TODO
    }
    case vm_TeOpcode.VM_OP_STORE_VAR_1: {
      return notImplemented(); // TODO
    }
    case vm_TeOpcode.VM_OP_STORE_GLOBAL_1: {
      return notImplemented(); // TODO
    }
    case vm_TeOpcode.VM_OP_STRUCT_GET_1: {
      return notImplemented(); // TODO
    }
    case vm_TeOpcode.VM_OP_STRUCT_SET_1: {
      return notImplemented(); // TODO
    }
    case vm_TeOpcode.VM_OP_NUM_OP: {
      return notImplemented(); // TODO
    }
    case vm_TeOpcode.VM_OP_BIT_OP: {
      return notImplemented(); // TODO
    }
    case vm_TeOpcode.VM_OP_END: {
      return unexpected();
    }
    default: assertUnreachable(opcode);
  }
}