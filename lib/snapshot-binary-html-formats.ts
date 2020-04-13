import { VisualBufferHTMLContainer, HTMLFormat, BinaryFormat, Format, BinaryData, VisualBuffer, HTML } from "./visual-buffer";
import escapeHTML from 'escape-html';
import { stringifyStringLiteral } from "./utils";
import { SInt8, UInt16, SInt16, UInt32, SInt32 } from "./runtime-types";
import { Labelled, Future } from "./binary-region";

export const tableContainer: VisualBufferHTMLContainer = (content, totalSize) => `
  <table class="visual-buffer">
    <colgroup>
      <col>
      <col>
      <col>
      <col>
    </colgroup>
    <tbody>
      ${content}
      ${
        // Final row to show the trailing address
        tableRow(() => '')({ value: 0 as any }, [], totalSize)
      }
    </tbody>
  </table>`

export const tableRow = <T>(formatValue: (v: T) => string): HTMLFormat<Labelled<T | undefined>> =>
  (value, binary, offset) => {
    const addressID = `address${offset.toString(16).padStart(4, '0').toUpperCase()}`;
    return `
      <tr>
        <td class="address">
          <a class="address-text" id="${addressID}" href="#${addressID}">
            ${offset.toString(16).padStart(4, '0').toUpperCase()}
          </a>
        </td>
        <td class="data">
          ${value.value !== undefined
            ? binary
              .map(b => b.toString(16).padStart(2, '0').toUpperCase())
              .map(s => `<span class="byte">${s}</span>`)
              .join('<wbr>')
            : binary
              .map(() => `<span class="byte pending"></span>`)
              .join('<wbr>')}
        </td>
        <td class="label">
          ${value.label ? value.label + ': ' : ''}
        </td>
        ${value.value !== undefined
          ? `<td class="value">${formatValue(value.value)}</td>`
          : '<td class="value pending-value"></td>'}
      </tr>`
  };

class HTMLFormats {
  hexRow = (digits: number, add0x: boolean = true, addBaseSubscript: boolean = false) =>
    tableRow<number>(value =>
      (add0x ? '0x' : '') +
      (value.toString(16).padStart(digits, '0').toUpperCase()) +
      (addBaseSubscript ? '<sub>16</sub>': ''));

  intRow = tableRow<number>(s => s.toFixed(0));

  doubleRow = tableRow<number>(s => s.toString());

  stringRow = tableRow<string>(s => escapeHTML(stringifyStringLiteral(s)))
}


class BinaryFormats {
  // 8-bit unsigned integer
  uInt8: BinaryFormat<number> = v => [v];
  // 8-bit signed integer
  sInt8: BinaryFormat<number> = v => [SInt8(v) & 0xFF];
  // Little-endian 16-bit unsigned integer
  uInt16LE: BinaryFormat<number> = v => (UInt16(v), [v & 0xFF, (v >> 8) & 0xFF]);
  // Little-endian 16-bit signed integer
  sInt16LE: BinaryFormat<number> = v => (SInt16(v), [v & 0xFF, (v >> 8) & 0xFF]);
  // Little-endian 32-bit unsigned integer
  uInt32LE: BinaryFormat<number> = v => (UInt32(v), [v & 0xFF, (v >> 8) & 0xFF, (v >> 16) & 0xFF, (v >> 24) & 0xFF]);
  // Little-endian 32-bit signed integer
  sInt32LE: BinaryFormat<number> = v => (SInt32(v), [v & 0xFF, (v >> 8) & 0xFF, (v >> 16) & 0xFF, (v >> 24) & 0xFF]);
  // Little-endian 64-bit floating point
  doubleLE: BinaryFormat<number> = v => { const b = Buffer.allocUnsafe(8); b.writeDoubleLE(v); return [...b] };
  // UTF8, null-terminated string
  stringUtf8NT: BinaryFormat<string> = v => [...Buffer.from(v, 'utf8'), 0];
}

export interface Preformatted {
  binary: BinaryData;
  html: HTML;
}

const renderInt = (s: number) => s.toFixed(0);
const renderHex = (digits: number) => (value: number) => `0x${value.toString(16).padStart(digits, '0').toUpperCase()}`;
const renderDouble = (value: number) => value.toString();
const renderString = (value: string) => escapeHTML(stringifyStringLiteral(value));
const renderBuffer = (value: Buffer) => '<Buffer>';

export const binaryFormats = new BinaryFormats();
export const htmlFormats = new HTMLFormats();

export const uHex8Row = rowFormat(binaryFormats.uInt8, 1, renderHex(2));
export const uInt8Row = rowFormat(binaryFormats.uInt8, 1, renderInt);
export const sInt8Row = rowFormat(binaryFormats.sInt8, 1, renderInt);

export const uHex16LERow = rowFormat(binaryFormats.uInt16LE, 2, renderHex(4));
export const uInt16LERow = rowFormat(binaryFormats.uInt16LE, 2, renderInt);
export const sInt16LERow = rowFormat(binaryFormats.sInt16LE, 2, renderInt);

export const uHex32LERow = rowFormat(binaryFormats.uInt32LE, 4, renderHex(8));
export const uInt32LERow = rowFormat(binaryFormats.uInt32LE, 4, renderInt);
export const sInt32LERow = rowFormat(binaryFormats.sInt32LE, 4, renderInt);

export const doubleLERow = rowFormat(binaryFormats.doubleLE, 8, renderDouble);

export const stringUtf8NTRow = rowFormat(binaryFormats.stringUtf8NT, 1, renderString);

export const bufferRow = rowFormat(b => BinaryData([...b]), 0, renderBuffer);

export const preformatted = (byteCount: number) => rowFormat<Preformatted>(v => v.binary, byteCount, v => v.html);
export const preformatted1 = preformatted(1);
export const preformatted2 = preformatted(2);
export const preformatted3 = preformatted(3);

function rowFormat<T>(renderBin: BinaryFormat<T>, byteCount: number, renderValue: (s: T) => HTML) {
  return Format<Labelled<T | undefined>>(
    v => v.value !== undefined ? renderBin(v.value) : zeros(byteCount),
    tableRow(renderValue)
  )
}

function zeros(length: number): BinaryData {
  const result = [];
  while (length--) {
    result.push(0);
  }
  return result;
}