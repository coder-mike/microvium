import fs from 'fs';

// The native opcodes are duplicated in C headers and typescript files. This
// synchronizes them. The C header is the single source of truth

const cOpcodesHeader = fs.readFileSync('./native-vm/microvium_opcodes.h', 'utf8');
const cMicroviumHeader = fs.readFileSync('./native-vm/microvium.h', 'utf8');
const cMicroviumInternals = fs.readFileSync('./native-vm/microvium_internals.h', 'utf8');
const cMicroviumBytecode = fs.readFileSync('./native-vm/microvium_bytecode.h', 'utf8');
let tsBytecodeOpcodes = fs.readFileSync('./lib/bytecode-opcodes.ts', 'utf8');

tsBytecodeOpcodes = copyInto(cOpcodesHeader, tsBytecodeOpcodes,
  'typedef enum vm_TeOpcode {', '} vm_TeOpcode;',
  'export enum vm_TeOpcode {', '};');

tsBytecodeOpcodes = copyInto(cOpcodesHeader, tsBytecodeOpcodes,
  'typedef enum vm_TeOpcodeEx1 {', '} vm_TeOpcodeEx1;',
  'export enum vm_TeOpcodeEx1 {', '};');

tsBytecodeOpcodes = copyInto(cOpcodesHeader, tsBytecodeOpcodes,
  'typedef enum vm_TeOpcodeEx2 {', '} vm_TeOpcodeEx2;',
  'export enum vm_TeOpcodeEx2 {', '};');

tsBytecodeOpcodes = copyInto(cOpcodesHeader, tsBytecodeOpcodes,
  'typedef enum vm_TeOpcodeEx3 {', '} vm_TeOpcodeEx3;',
  'export enum vm_TeOpcodeEx3 {', '};');

tsBytecodeOpcodes = copyInto(cOpcodesHeader, tsBytecodeOpcodes,
  'typedef enum vm_TeNumberOp {', '} vm_TeNumberOp;',
  'export enum vm_TeNumberOp {', '};');

tsBytecodeOpcodes = copyInto(cOpcodesHeader, tsBytecodeOpcodes,
  'typedef enum vm_TeBitwiseOp {', '} vm_TeBitwiseOp;',
  'export enum vm_TeBitwiseOp {', '};');

fs.writeFileSync('./lib/bytecode-opcodes.ts', tsBytecodeOpcodes);

let tsRuntimeTypes = fs.readFileSync('./lib/runtime-types.ts', 'utf8');

tsRuntimeTypes = copyInto(cMicroviumHeader, tsRuntimeTypes,
  'typedef enum mvm_TeError {', '} mvm_TeError;',
  'export enum mvm_TeError {', '};');

tsRuntimeTypes = copyInto(cMicroviumInternals, tsRuntimeTypes,
  'typedef enum TeTypeCode {', '} TeTypeCode;',
  'export enum TeTypeCode {', '};');

tsRuntimeTypes = copyInto(cMicroviumHeader, tsRuntimeTypes,
  'typedef enum mvm_TeType {', '} mvm_TeType;',
  'export enum mvm_TeType {', '};');

tsRuntimeTypes = copyInto(cMicroviumBytecode, tsRuntimeTypes,
  'typedef enum mvm_TeBytecodeSection {', '} mvm_TeBytecodeSection;',
  'export enum mvm_TeBytecodeSection {', '};');

fs.writeFileSync('./lib/runtime-types.ts', tsRuntimeTypes);

let tsSnapshotIL = fs.readFileSync('./lib/snapshot-il.ts', 'utf8');

tsSnapshotIL = copyInto(cMicroviumBytecode, tsSnapshotIL,
  '#define MVM_BYTECODE_VERSION ', '\r\n',
  'export const BYTECODE_VERSION = ', ';');

fs.writeFileSync('./lib/snapshot-il.ts', tsSnapshotIL);

function copyInto(src: string, target: string, srcPrefix: string, srcSuffix: string, targetPrefix: string, targetSuffix: string) {
  const srcRegExp = new RegExp(`${escapeRegExp(srcPrefix)}(.*?)${escapeRegExp(srcSuffix)}`, 's');
  const match = srcRegExp.exec(src);
  if (!match) {
    throw new Error('Error synchronizing. Source pattern not found');
  }
  const body = match[1];

  const targetRegExp = new RegExp(`(${escapeRegExp(targetPrefix)}).*?(${escapeRegExp(targetSuffix)})`, 's');
  if (!targetRegExp.test(target)) {
    throw new Error('Error synchronizing. Target pattern not found: ' + targetRegExp)
  }
  return target.replace(targetRegExp, () => `${targetPrefix}${body}${targetSuffix}`);
}

// https://stackoverflow.com/a/6969486
function escapeRegExp(s: string) {
  return s.replace(/[.*+?^${}()|[\]\\]/g, '\\$&'); // $& means the whole matched string
}