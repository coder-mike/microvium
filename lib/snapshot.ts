import * as VM from './virtual-machine-types';
import * as IL from './il';
import { crc16ccitt } from 'crc';
import { notImplemented, assertUnreachable, assert, notUndefined, unexpected, invalidOperation } from './utils';
import * as _ from 'lodash';
import { BinaryRegion, Delayed, DelayedLike } from './binary-region';
import { vm_VMExportID, vm_Reference, vm_Value, vm_TeMetaType, vm_TeWellKnownValues, vm_TeTypeCode, vm_TeValueTag, vm_TeOpcode, vm_TeOpcodeEx1, UInt8, UInt4, isUInt12, isInt14, isInt32, isUInt16, isUInt4, isInt8, vm_TeOpcodeEx2, isUInt8, Int8, isInt16, vm_TeOpcodeEx3, UInt16, Int16 } from './runtime-types';

const bytecodeVersion = 1;
const requiredFeatureFlags = 0;
const requiredEngineVersion = 0;

/**
 * A snapshot represents the state of the machine captured at a specific moment
 * in time.
 *
 * Note: Anchors are not part of the snapshot. Anchors represent references from
 * the host into the VM. These references are severed at the time that VM is
 * snapshotted.
 */
export interface Snapshot {
  globalVariables: Map<VM.GlobalSlotID, VM.Value>;
  functions: Map<IL.FunctionID, IL.Function>;
  exports: Map<vm_VMExportID, VM.Value>;
  allocations: Map<VM.AllocationID, VM.Allocation>;
  metaTable: Map<VM.MetaID, VM.Meta>;
}

export function loadSnapshotFromBytecode(bytecode: Buffer): Snapshot {
  return notImplemented();
}

export function saveSnapshotToBytecode(snapshot: Snapshot): Buffer {
  const bytecode = new BinaryRegion();
  const largePrimitives = new BinaryRegion();
  const romAllocations = new BinaryRegion();
  const dataAllocations = new BinaryRegion();
  const importTable = new BinaryRegion();
  const functionCode = new BinaryRegion();

  const largePrimitivesMemoizationTable = new Array<{ data: Buffer, reference: Delayed<vm_Value> }>();
  const importLookup = new Map<VM.ExternalFunctionID, number>();
  const strings = new Map<string, Delayed<vm_Reference>>();

  // The GC roots are the offsets in data memory of values that can point to GC,
  // not including the global variables
  const gcRoots = new Array<Delayed>();

  let importCount = 0;

  const headerSize = new Delayed();
  const bytecodeSize = new Delayed();
  const crcRangeStart = new Delayed();
  const crcRangeEnd = new Delayed();
  const dataMemorySize = new Delayed();
  const initialDataOffset = new Delayed();
  const initialDataSize = new Delayed();
  const initialHeapOffset = new Delayed();
  const initialHeapSize = new Delayed();
  const gcRootsOffset = new Delayed();
  const gcRootsCount = new Delayed();
  const importTableOffset = new Delayed();
  const importTableSize = new Delayed();
  const exportTableOffset = new Delayed();
  const exportTableSize = new Delayed();
  const shortCallTableOffset = new Delayed();
  const shortCallTableSize = new Delayed();
  const stringTableOffset = new Delayed();
  const stringTableSize = new Delayed();

  const functionReferences = new Map([...snapshot.functions.keys()]
    .map(k => [k, new Delayed<vm_Value>()]));

  const functionOffsets = new Map([...snapshot.functions.keys()]
    .map(k => [k, new Delayed()]));

  const allocationReferences = new Map([...snapshot.allocations.keys()]
    .map(k => [k, new Delayed<vm_Value>()]));

  const metaAddresses = new Map([...snapshot.metaTable.keys()]
    .map(k => [k, new Delayed()]));

  const globalVariableCount = snapshot.globalVariables.size;

  encodeFunctions();

  // Header
  bytecode.writeUInt8(bytecodeVersion);
  bytecode.writeUInt8(headerSize);
  bytecode.writeUInt16LE(bytecodeSize);
  bytecode.writeUInt16LE(bytecode.postProcess(crcRangeStart, crcRangeEnd, crc16ccitt));
  crcRangeStart.assign(bytecode.currentAddress);
  bytecode.writeUInt32LE(requiredFeatureFlags);
  bytecode.writeUInt16LE(requiredEngineVersion);
  bytecode.writeUInt16LE(globalVariableCount);
  bytecode.writeUInt16LE(dataMemorySize);
  bytecode.writeUInt16LE(initialDataOffset);
  bytecode.writeUInt16LE(initialDataSize);
  bytecode.writeUInt16LE(initialHeapOffset);
  bytecode.writeUInt16LE(initialHeapSize);
  bytecode.writeUInt16LE(gcRootsOffset);
  bytecode.writeUInt16LE(gcRootsCount);
  bytecode.writeUInt16LE(importTableOffset);
  bytecode.writeUInt16LE(importTableSize);
  bytecode.writeUInt16LE(exportTableOffset);
  bytecode.writeUInt16LE(exportTableSize);
  bytecode.writeUInt16LE(shortCallTableOffset);
  bytecode.writeUInt16LE(shortCallTableSize);
  bytecode.writeUInt16LE(stringTableOffset);
  bytecode.writeUInt16LE(stringTableSize);
  headerSize.assign(bytecode.currentAddress);

  // VTables (occurs early in bytecode because VTable references are only 12-bit)
  writeMetaTable();

  // Initial data memory
  initialDataOffset.assign(bytecode.currentAddress);
  writeGlobalVariables();
  bytecode.writeBuffer(dataAllocations);
  const initialDataEnd = bytecode.currentAddress;
  initialDataSize.assign(initialDataEnd.subtract(initialDataOffset));

  // Initial heap
  initialHeapOffset.assign(bytecode.currentAddress);
  const initialHeap = createInitialHeap();
  // Note: the initial heap has it's own memory space, so we need to use `toBuffer` so that its addresses start at zero
  bytecode.writeBuffer(initialHeap.toBuffer());
  const initialHeapEnd = bytecode.currentAddress;
  initialHeapSize.assign(initialHeapEnd.subtract(initialHeapOffset));

  // GC Roots
  gcRootsOffset.assign(bytecode.currentAddress);
  gcRootsCount.assign(gcRoots.length);
  for (const gcRoot of gcRoots) {
    bytecode.writeUInt16LE(gcRoot.subtract(initialDataOffset));
  }

  // Import table
  const importTableStart = bytecode.currentAddress;
  importTableOffset.assign(importTableStart);
  bytecode.writeBuffer(importTable);
  const importTableEnd = bytecode.currentAddress;
  importTableSize.assign(importTableEnd.subtract(importTableStart));

  // Export table
  const exportTableStart = bytecode.currentAddress;
  exportTableOffset.assign(exportTableStart);
  writeExportTable();
  const exportTableEnd = bytecode.currentAddress;
  exportTableSize.assign(exportTableEnd.subtract(exportTableStart));

  // Short call table
  const shortCallTableStart = bytecode.currentAddress;
  shortCallTableOffset.assign(shortCallTableStart);
  writeShortCallTable();
  const shortCallTableEnd = bytecode.currentAddress;
  shortCallTableSize.assign(shortCallTableEnd.subtract(shortCallTableStart));

  // String table
  const stringTableStart = bytecode.currentAddress;
  stringTableOffset.assign(stringTableStart);
  writeStringTable();
  const stringTableEnd = bytecode.currentAddress;
  stringTableSize.assign(stringTableEnd.subtract(stringTableStart));

  // Dynamically-sized primitives
  bytecode.writeBuffer(largePrimitives);

  // Functions
  bytecode.writeBuffer(functionCode);

  // ROM allocations
  bytecode.writeBuffer(romAllocations);

  // Finalize
  const bytecodeEnd = bytecode.currentAddress;
  bytecodeSize.assign(bytecodeEnd);
  crcRangeEnd.assign(bytecodeEnd);

  return bytecode.toBuffer();

  function writeMetaTable() {
    for (const [k, v] of snapshot.metaTable) {
      const address = notUndefined(metaAddresses.get(k));
      address.map(a => assert(isUInt12(a)));
      address.assign(bytecode.currentAddress);
      switch (v.type) {
        case 'StructKeysMeta': {
          bytecode.writeUInt16LE(vm_TeMetaType.VM_MT_STRUCT);
          bytecode.writeUInt16LE(v.propertyKeys.length);
          for (const p of v.propertyKeys) {
            bytecode.writeUInt16LE(getString(p));
          }
          break;
        }
        default: return assertUnreachable(v.type);
      }
    }
  }

  function writeGlobalVariables() {
    const globalVariables = snapshot.globalVariables;
    const globalVariableNames = [...globalVariables.keys()];
    const globalVariableCount = globalVariableNames.length;
    dataMemorySize.resolve(globalVariableCount * 2);

    const globalVariableIndexMapping = new Map<string, number>();
    const globalVariableIsUndefined = (k: string) => notUndefined(globalVariables.get(k)).type === 'UndefinedValue';
    const globalsNeedingInitialization = globalVariableNames.filter(k => !globalVariableIsUndefined(k));
    const globalsNotNeedingInitialization = globalVariableNames.filter(globalVariableIsUndefined);

    let globalVariableIndex = 0;
    for (const k of globalsNeedingInitialization) {
      const i = globalVariableIndex++;
      globalVariableIndexMapping.set(k, i);
      writeValue(bytecode, notUndefined(globalVariables.get(k)), false);
    }

    for (const k of globalsNotNeedingInitialization) {
      const i = globalVariableIndex++;
      globalVariableIndexMapping.set(k, i);
    }
  }

  function writeValue(region: BinaryRegion, value: VM.Value, inDataAllocation: boolean) {
    if (inDataAllocation) {
      gcRoots.push(region.currentAddress);
    }
    region.writeUInt16LE(encodeValue(value));
  }

  function encodeValue(value: VM.Value): DelayedLike<vm_Value> {
    switch (value.type) {
      case 'UndefinedValue': return vm_TeWellKnownValues.VM_VALUE_UNDEFINED;
      case 'BooleanValue': return value.value ? vm_TeWellKnownValues.VM_VALUE_TRUE : vm_TeWellKnownValues.VM_VALUE_FALSE;
      case 'NullValue': return vm_TeWellKnownValues.VM_VALUE_NULL;
      case 'NumberValue': {
        if (isNaN(value.value)) return vm_TeWellKnownValues.VM_VALUE_NAN;
        if (value.value === Infinity) return vm_TeWellKnownValues.VM_VALUE_INF;
        if (value.value === -Infinity) return vm_TeWellKnownValues.VM_VALUE_NEG_INF;
        if (Object.is(value.value, -0)) return vm_TeWellKnownValues.VM_VALUE_NEG_ZERO;
        if (isInt14(value.value)) return value.value & 0x3FFF;
        if (isInt32(value.value)) return allocateLargePrimitive(vm_TeTypeCode.VM_TC_INT32, b => b.writeInt32LE(value.value));
        return allocateLargePrimitive(vm_TeTypeCode.VM_TC_DOUBLE, b => b.writeDoubleLE(value.value));
      };
      case 'StringValue': return getString(value.value);
      case 'FunctionValue': {
        return notUndefined(functionReferences.get(value.value));
      }
      case 'ReferenceValue': {
        const allocationID = value.value;
        return notUndefined(allocationReferences.get(allocationID));
      }
      case 'ExternalFunctionValue': {
        const externalFunctionID = value.value;
        let importIndex = getImportIndexOfExternalFunctionID(externalFunctionID);
        return allocateLargePrimitive(vm_TeTypeCode.VM_TC_EXT_FUNC, w => w.writeInt16LE(importIndex));
      }
      default: return assertUnreachable(value);
    }
  }

  function getString(s: string): Delayed<vm_Value> {
    if (s === '') return Delayed.create(vm_TeWellKnownValues.VM_VALUE_EMPTY_STRING);

    let ref = strings.get(s);
    if (ref) return ref;

    // Note: for simplicity, all strings in the bytecode are uniqued, rather
    // than figuring out which strings are used as property keys and which aren't
    const r = allocateLargePrimitive(vm_TeTypeCode.VM_TC_UNIQUED_STRING, w => w.writeStringNT(s, 'utf8'));
    strings.set(s, r);
    return r;
  }

  function getImportIndexOfExternalFunctionID(externalFunctionID: VM.ExternalFunctionID): number {
    let importIndex = importLookup.get(externalFunctionID);
    if (importIndex !== undefined) {
      return importIndex;
    }
    importIndex = importCount++;
    importLookup.set(externalFunctionID, importIndex);
    assert(isUInt16(externalFunctionID));
    importTable.writeUInt16LE(externalFunctionID);
    return importIndex;
  }

  function allocateLargePrimitive(typeCode: vm_TeTypeCode, writer: (buffer: BinaryRegion) => void): Delayed<vm_Value> {
    // Encode as heap allocation
    const buffer = new BinaryRegion();
    const headerWord = new Delayed();
    buffer.writeUInt16LE(headerWord);
    writer(buffer);
    const size = buffer.currentAddress;
    size.map(size => assert(size <= 0xFFF));
    headerWord.assign(size.map(size => size | (typeCode << 12)));
    const newAllocationData = buffer.toBuffer();
    const existingAllocation = largePrimitivesMemoizationTable.find(a => a.data.equals(newAllocationData));
    if (existingAllocation) {
      return existingAllocation.reference;
    } else {
      const address = largePrimitives.currentAddress;
      largePrimitives.writeBuffer(newAllocationData);
      const reference = addressToReference(address, vm_TeValueTag.VM_TAG_GC_P);
      largePrimitivesMemoizationTable.push({ data: newAllocationData, reference });
      return reference;
    }
  }

  function addressToReference(address: Delayed<number>, region: vm_TeValueTag) {
    return address.map(address => {
      assert(address <= 0x3FFF);
      return address | region
    });
  }

  function createInitialHeap(): BinaryRegion {
    const initialHeap = new BinaryRegion();
    for (const [allocationID, allocation] of snapshot.allocations.entries()) {
      const reference = notUndefined(allocationReferences.get(allocationID));
      const writeToROM = allocation.readonly;
      if (writeToROM) {
        const r = writeAllocation(romAllocations, allocation, vm_TeValueTag.VM_TAG_PGM_P);
        reference.assign(r);
      } else if (allocation.structureReadonly) {
        const r = writeAllocation(dataAllocations, allocation, vm_TeValueTag.VM_TAG_DATA_P);
        reference.assign(r);
      } else {
        const r = writeAllocation(initialHeap, allocation, vm_TeValueTag.VM_TAG_GC_P);
        reference.assign(r);
      }
    }
    return initialHeap;
  }

  function writeAllocation(region: BinaryRegion, allocation: VM.Allocation, memoryRegion: vm_TeValueTag): Delayed<vm_Reference> {
    switch (allocation.type) {
      case 'ArrayAllocation': return writeArray(region, allocation, memoryRegion);
      case 'ObjectAllocation': return writeObject(region, allocation, memoryRegion);
      case 'StructAllocation': return writeStruct(region, allocation, memoryRegion);
      default: return assertUnreachable(allocation);
    }
  }

  function writeObject(region: BinaryRegion, allocation: VM.ObjectAllocation, memoryRegion: vm_TeValueTag): Delayed<vm_Reference> {
    const contents = allocation.properties;
    const typeCode = vm_TeTypeCode.VM_TC_PROPERTY_LIST;
    const keys = Object.keys(contents);
    const keyCount = keys.length;
    assert(isUInt12(keyCount));
    assert(isUInt4(typeCode));
    const headerWord = keyCount | (typeCode << 12);
    region.writeUInt16LE(headerWord);
    const objectAddress = region.currentAddress;

    // A "VM_TC_PROPERTY_LIST" is a linked list of property cells
    let pNext = new Delayed();
    region.writeUInt16LE(pNext); // Address of first cell
    for (const k of Object.keys(contents)) {
      pNext.assign(region.currentAddress);
      pNext = new Delayed(); // Address of next cell
      region.writeUInt16LE(pNext);
      region.writeUInt16LE(encodePropertyKey(k));
      const inDataAllocation = memoryRegion === vm_TeValueTag.VM_TAG_DATA_P;
      writeValue(region, contents[k], inDataAllocation);
    }
    // The last cell has no next pointer
    pNext.assign(vm_TeWellKnownValues.VM_VALUE_UNDEFINED);

    return addressToReference(objectAddress, memoryRegion);
  }

  function writeStruct(region: BinaryRegion, allocation: VM.StructAllocation, memoryRegion: vm_TeValueTag): Delayed<vm_Reference> {
    const propertyValues = allocation.propertyValues;
    const typeCode = vm_TeTypeCode.VM_TC_VIRTUAL;
    const vTableAddress = notUndefined(metaAddresses.get(allocation.layoutMetaID));
    const headerWord = vTableAddress.map(vTableAddress => {
      assert(isUInt12(vTableAddress));
      assert(typeCode === vm_TeTypeCode.VM_TC_VIRTUAL);
      return vTableAddress | (typeCode << 12);
    });
    region.writeUInt16LE(headerWord);
    const structAddress = region.currentAddress;

    const vTable = notUndefined(snapshot.metaTable.get(allocation.layoutMetaID));
    assert(allocation.propertyValues.length === vTable.propertyKeys.length);

    // A struct has the fields stored contiguously
    for (const v of propertyValues) {
      const inDataAllocation = memoryRegion === vm_TeValueTag.VM_TAG_DATA_P;
      writeValue(region, v, inDataAllocation);
    }

    return addressToReference(structAddress, memoryRegion);
  }

  function encodePropertyKey(k: string): Delayed<vm_Reference> {
    return getString(k);
  }

  function writeArray(region: BinaryRegion, allocation: VM.ArrayAllocation, memoryRegion: vm_TeValueTag): Delayed<vm_Reference> {
    const inDataAllocation = memoryRegion === vm_TeValueTag.VM_TAG_DATA_P;
    const typeCode = allocation.structureReadonly ? vm_TeTypeCode.VM_TC_ARRAY : vm_TeTypeCode.VM_TC_LIST;
    const contents = allocation.items;
    const len = contents.length;
    assert(isUInt12(len));
    assert(isUInt4(typeCode));
    const headerWord = len | (typeCode << 12);
    region.writeUInt16LE(headerWord);

    // Address comes after the header word
    const arrayAddress = region.currentAddress;

    if (typeCode === vm_TeTypeCode.VM_TC_ARRAY) {
      for (const item of contents) {
        writeValue(region, item, inDataAllocation);
      }
    } else if (typeCode === vm_TeTypeCode.VM_TC_LIST) {
      let pNext = new Delayed();
      region.writeUInt16LE(pNext); // Address of first cell
      for (const item of contents) {
        pNext.assign(region.currentAddress);
        pNext = new Delayed(); // Address of next cell
        region.writeUInt16LE(pNext);
        writeValue(region, item, inDataAllocation);
      }
      // The last cell has no next pointer
      pNext.assign(0);
    } else assertUnreachable(typeCode);

    return addressToReference(arrayAddress, memoryRegion);
  }

  function writeExportTable() {
    for (const [exportID, value] of snapshot.exports) {
      assert(isUInt16(exportID));
      bytecode.writeUInt16LE(exportID);
      writeValue(bytecode, value, false);
    }
  }

  function writeShortCallTable() {
    return notImplemented();
  }

  function writeStringTable() {
    return notImplemented();
  }

  function encodeFunctions() {
    for (const [name, func] of snapshot.functions.entries()) {
      const ref = notUndefined(functionReferences.get(name));
      const offset = notUndefined(functionOffsets.get(name));
      const startAddress = new Delayed();
      ref.assign(addressToReference(startAddress, vm_TeValueTag.VM_TAG_PGM_P));
      offset.assign(startAddress);
      const endAddress = new Delayed();
      const size = endAddress.subtract(startAddress);
      const typeCode = vm_TeTypeCode.VM_TC_FUNCTION;
      const headerWord = size.map(size => {
        assert(isUInt12(size));
        return size | (typeCode << 12)
      });
      functionCode.writeUInt16LE(headerWord);
      startAddress.assign(functionCode.currentAddress);
      functionCode.writeUInt8(func.maxStackDepth);

      const body = assembleFunctionBody(func, offsetOfFunction);
      functionCode.writeBuffer(body);

      endAddress.assign(functionCode.currentAddress);
    }
  }

  function offsetOfFunction(id: IL.FunctionID): Delayed {
    return notUndefined(functionOffsets.get(id));
  }
}

function assembleFunctionBody(func: IL.Function, offsetOfFunction: (id: IL.FunctionID) => Delayed): BinaryRegion {
  const code = new BinaryRegion();
  const emitter = new InstructionEmitter();

  interface OperationMeta {
    addressEstimate: number;
    address: number;
    sizeEstimate: number;
    size: number;
    emitPass2: EmitPass2;
    emitPass3: EmitPass3;
  };

  interface BlockMeta {
    addressEstimate: number;
    address: number;
  }

  const metaByOperation = new Map<IL.Operation, OperationMeta>();
  const metaByBlock = new Map<IL.BlockID, BlockMeta>();
  const shortCallTable = new Array<{
    functionID: string,
    argCount: number
  }>();

  pass1();

  // Run a second pass to refine the estimates
  pass2();

  // Run the second pass again to refine the layout further. This is
  // particularly for the case of forward jumps, which were previously estimated
  // based on the maximum size of future operations but can now be based on a
  // better estimate of future operations
  for (const m of metaByOperation.values()) {
    m.addressEstimate = m.address;
    m.sizeEstimate = m.size;
  }
  for (const m of metaByBlock.values()) {
    m.addressEstimate = m.address;
  }
  pass2();

  // Output pass to generate bytecode
  outputPass();

  return code;

  function pass1() {
    const ctx: InstructionEmitContext = {
      getShortCallIndex(functionID: IL.FunctionID, argCount: UInt8) {
        let index = shortCallTable.findIndex(s => s.functionID === functionID && s.argCount === argCount);
        if (index !== undefined) {
          return index;
        }
        if (shortCallTable.length >= 16) {
          return invalidOperation('Maximum number of short calls exceeded');
        }
        index = shortCallTable.length;
        shortCallTable.push({ functionID, argCount });
        return index;
      },
      offsetOfFunction
    };

    // In a first pass, we estimate the layout based on the maximum possible size
    // of each instruction. Instructions such as JUMP can take different forms
    // depending on the distance of the jump, and the distance of the JUMP in turn
    // depends on size of other instructions in between the jump origin and
    // target, which may include other jumps etc.
    let addressEstimate = 0;
    for (const [blockID, block] of Object.entries(func.blocks)) {
      metaByBlock.set(blockID, {
        addressEstimate,
        address: undefined as any
      });
      for (const op of block.operations) {
        const { maxSize, emitPass2 } = emitPass1(emitter, ctx, op);
        const operationMeta: OperationMeta = {
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
  }

  function pass2() {
    let currentOperationMeta: OperationMeta;
    const ctx: Pass2Context = {
      tentativeOffsetOfBlock: (blockID: IL.BlockID) => {
        const targetBlock = notUndefined(metaByBlock.get(blockID));
        const blockAddress = targetBlock.addressEstimate;
        const operationAddress = currentOperationMeta.addressEstimate;
        const operationSize = currentOperationMeta.sizeEstimate;
        // The jump offset is measured from the end of the current operation, but
        // we don't know exactly how big it is so we take the worst case distance
        let maxOffset = (blockAddress > operationAddress
          ? blockAddress - operationAddress
          : blockAddress - (operationAddress + operationSize));
        return maxOffset;
      }
    };

    let addressEstimate = 0;
    for (const [blockID, block] of Object.entries(func.blocks)) {
      const blockMeta = notUndefined(metaByBlock.get(blockID));
      blockMeta.address = addressEstimate;
      for (const op of block.operations) {
        const opMeta = notUndefined(metaByOperation.get(op));
        currentOperationMeta = opMeta;
        const pass2Output = opMeta.emitPass2(ctx);
        opMeta.emitPass3 = pass2Output.emitPass3;
        opMeta.size = pass2Output.size;
        opMeta.address = addressEstimate;
        addressEstimate += pass2Output.size;
      }
    }
  }

  function outputPass() {
    let currentOperationMeta: OperationMeta;
    const ctx: Pass3Context = {
      region: code,
      offsetOfBlock(blockID: string): number {
        const targetBlock = notUndefined(metaByBlock.get(blockID));
        const blockAddress = targetBlock.address;
        const operationAddress = currentOperationMeta.address;
        const operationSize = currentOperationMeta.size;
        const jumpFrom = operationAddress + operationSize;
        const offset = blockAddress - jumpFrom;
        return offset;
      }
    };

    for (const [, block] of Object.entries(func.blocks)) {
      for (const op of block.operations) {
        const opMeta = notUndefined(metaByOperation.get(op));
        currentOperationMeta = opMeta;
        const offsetBefore = code.currentAddress;
        opMeta.emitPass3(ctx);
        const offsetAfter = code.currentAddress;
        const measuredSize = offsetAfter.subtract(offsetBefore);
        measuredSize.map(m => assert(m === opMeta.size));
      }
    }
  }
}

function emitPass1(emitter: InstructionEmitter, ctx: InstructionEmitContext, op: IL.Operation): EmitPass1Output {
  const operationMeta = IL.opcodes[op.opcode];
  if (!operationMeta) {
    return invalidOperation(`Unknown opcode "${op.opcode}".`);
  }
  const operands = op.operands.map((o, i) =>
    resolveOperand(o, operationMeta.operands[i] as IL.OperandType));

  const method = (emitter as any)[`operation${op.opcode}`] as globalThis.Function;
  if (!method) {
    return notImplemented(`Opcode not implemented in bytecode emitter: "${op.opcode}"`)
  }
  if (operands.length !== method.length - 2) {
    return unexpected();
  }

  return method(ctx, op, ...operands);
}

function resolveOperand(operand: IL.Operand, expectedType: IL.OperandType) {
  switch (expectedType) {
    case 'LabelOperand':
      if (operand.type !== 'LabelOperand') {
        return invalidOperation('Expected label operand');
      }
      return operand.targetBlockID;
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
    default: assertUnreachable(expectedType);
  }
}

interface InstructionEmitContext {
  getShortCallIndex(target: IL.FunctionID, argCount: number): number;
  offsetOfFunction: (id: IL.FunctionID) => Delayed<number>;
}

class InstructionEmitter {
  operationArrayGet() {
    return notImplemented();
  }

  operationArrayNew() {
    return notImplemented();
  }

  operationArraySet() {
    return notImplemented();
  }

  operationBinOp() {
    return notImplemented();
  }

  operationBranch() {
    return notImplemented();
  }

  operationCall(ctx: InstructionEmitContext, op: IL.CallOperation, argCount: number) {
    const staticInfo = op.staticInfo;
    if (staticInfo && staticInfo.target.type === 'StaticEncoding') {
      const target = staticInfo.target.value;
      if (target.type !== 'FunctionValue') return invalidOperation('Static call target can only be a function');
      const functionID = target.value;
      if (staticInfo.shortCall) {
        // Short calls are single-byte instructions that use a nibble to
        // reference into the short-call table, which provides the information
        // about the function target and argument count
        const shortCallIndex = ctx.getShortCallIndex(target.value, argCount);
        return fixedSizeInstruction(1, region => {
          assert(isUInt4(shortCallIndex));
          writeOpcode(region, vm_TeOpcode.VM_OP_CALL_1, shortCallIndex);
        });
      } else {
        const targetOffset = ctx.offsetOfFunction(functionID);
        return fixedSizeInstruction(4, region => {
          writeOpcodeEx3Unsigned(region, vm_TeOpcodeEx3.VM_OP3_CALL_2, targetOffset);
          assert(isUInt8(argCount));
          region.writeUInt8(argCount);
        });
      }
    }
    return notImplemented();
  }

  operationCallMethod() {
    return notImplemented();
  }

  operationDecr() {
    return notImplemented();
  }

  operationDup() {
    return notImplemented();
  }

  operationIncr() {
    return notImplemented();
  }

  operationJump(_ctx: InstructionEmitContext, _op: IL.Operation, targetBlockID: string): EmitPass1Output {
    return {
      maxSize: 3,
      emitPass2: ctx => {
        const tentativeOffset = ctx.tentativeOffsetOfBlock(targetBlockID);
        const isFar = !isInt8(tentativeOffset);
        return {
          size: isFar ? 3 : 2,
          emitPass3: ctx => {
            const offset = ctx.offsetOfBlock(targetBlockID);
            // Stick to our committed shape
            if (isFar) {
              writeOpcodeEx3Signed(ctx.region, vm_TeOpcodeEx3.VM_OP3_JUMP_2, offset);
            } else {
              writeOpcodeEx2Signed(ctx.region, vm_TeOpcodeEx2.VM_OP2_JUMP_1, offset);
            }
          }
        }
      }
    }
  }

  operationLiteral() {
    return notImplemented();
  }

  operationLoadArg() {
    return notImplemented();
  }

  operationLoadGlobal() {
    return notImplemented();
  }

  operationLoadVar() {
    return notImplemented();
  }

  operationObjectGet() {
    return notImplemented();
  }

  operationObjectNew() {
    return notImplemented();
  }

  operationObjectSet() {
    return notImplemented();
  }

  operationPop() {
    return notImplemented();
  }

  operationReturn() {
    return notImplemented();
  }

  operationStoreGlobal() {
    return notImplemented();
  }

  operationStoreVar() {
    return notImplemented();
  }

  operationUnOp() {
    return notImplemented();
  }
}

interface EmitPass1Output {
  maxSize: number;
  emitPass2: EmitPass2;
}

type EmitPass2 = (ctx: Pass2Context) => EmitPass2Output;

interface EmitPass2Output {
  size: number;
  emitPass3: EmitPass3;
}

type EmitPass3 = (ctx: Pass3Context) => void;

interface Pass2Context {
  tentativeOffsetOfBlock(blockID: string): number;
}

interface Pass3Context {
  region: BinaryRegion;
  offsetOfBlock(blockID: string): number;
}

function writeOpcode(region: BinaryRegion, opcode: vm_TeOpcode, n2: UInt4) {
  assert(isUInt4(opcode));
  assert(isUInt4(n2));
  region.writeUInt8((opcode << 4) | n2);
}

function writeOpcodeEx1(region: BinaryRegion, opcode: vm_TeOpcodeEx1) {
  assert(isUInt4(opcode));
  writeOpcode(region, vm_TeOpcode.VM_OP_EXTENDED_1, opcode);
}

function writeOpcodeEx2Unsigned(region: BinaryRegion, opcode: vm_TeOpcodeEx2, param: UInt8) {
  assert(isUInt4(opcode));
  assert(isUInt8(param));
  writeOpcode(region, vm_TeOpcode.VM_OP_EXTENDED_2, opcode);
  region.writeUInt8(param);
}

function writeOpcodeEx2Signed(region: BinaryRegion, opcode: vm_TeOpcodeEx2, param: Int8) {
  assert(isUInt4(opcode));
  assert(isInt8(param));
  writeOpcode(region, vm_TeOpcode.VM_OP_EXTENDED_2, opcode);
  region.writeUInt8(param);
}

function writeOpcodeEx3Unsigned(region: BinaryRegion, opcode: vm_TeOpcodeEx3, param: DelayedLike<UInt16>) {
  assert(isUInt4(opcode));
  assertUInt16(param);
  writeOpcode(region, vm_TeOpcode.VM_OP_EXTENDED_3, opcode);
  region.writeUInt16LE(param);
}

function writeOpcodeEx3Signed(region: BinaryRegion, opcode: vm_TeOpcodeEx3, param: Int16) {
  assert(isUInt4(opcode));
  assert(isInt16(param));
  writeOpcode(region, vm_TeOpcode.VM_OP_EXTENDED_3, opcode);
  region.writeUInt16LE(param);
}

function fixedSizeInstruction(size: number, write: (region: BinaryRegion) => void): EmitPass1Output {
  return {
    maxSize: size,
    emitPass2: () => ({
      size,
      emitPass3: ctx => write(ctx.region)
    })
  }
}

const assertUInt16 = Delayed.lift((v: number) => assert(isUInt16(v)));