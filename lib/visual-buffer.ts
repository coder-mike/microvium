import { SmartBuffer } from 'smart-buffer';
import * as _ from 'lodash';
import { notUndefined, invalidOperation, assert } from './utils';
import { isUInt8 } from './runtime-types';

export type BinaryFormat<T> = (value: T) => BinaryData;
export type HTMLFormat<T> = (value: T, binary: BinaryData, offset: number) => HTML;
export type VisualBufferHTMLContainer = (content: HTML, totalBinarySize: number) => HTML;

export type HTML = string;

interface Segment<T = any> {
  value: T;
  binaryData: BinaryData;
  htmlFormat: HTMLFormat<T>;
}

export type Byte = number;
export const Byte = (b: number) => (assert(isUInt8(b)), b);

export type BinaryData = readonly Byte[];
export const BinaryData = (bytes: readonly Byte[]): BinaryData => Object.freeze(bytes.map(Byte));

export class VisualBuffer {
  private segments = new Map<number, Segment>();
  private totalSize = 0;

  get writeOffset() { return this.totalSize; }

  constructor (private htmlTemplate: VisualBufferHTMLContainer = noContainer) {
  }

  append<T>(value: T, format: Format<T>) {
    const offset = this.totalSize;
    const binaryData = BinaryData(format.binaryFormat(value));
    this.totalSize += binaryData.length;
    this.segments.set(offset, {
      value, binaryData, htmlFormat: format.htmlFormat
    });
  }

  overwrite<T>(value: T, format: Format<T>, offset: number) {
    const segment = this.segments.get(offset);
    if (segment === undefined) {
      return invalidOperation('Can only overwrite a region that exactly matches of the offset of a previous `append`')
    }
    const binaryData = BinaryData(format.binaryFormat(value));
    if (binaryData.length !== segment.binaryData.length) {
      return invalidOperation('An `overwrite` must have exactly the same size as the original `append`')
    }
    this.segments.set(offset, {
      value, binaryData, htmlFormat: format.htmlFormat
    });
  }

  toBuffer() {
    const buffer = new SmartBuffer();
    const segments = _.sortBy([...this.segments.entries()], s => s[0]);
    for (const [offset, segment] of segments) {
      segment.binaryData.forEach(b => buffer.writeUInt8(b));
    }
    return buffer.toBuffer();
  }

  toHTML(): string {
    const offsets = _.sortBy([...this.segments.keys()], o => o);
    const content = offsets
      .map(offset => renderHtmlSegment(notUndefined(this.segments.get(offset)), offset))
      .join('\n');
    return this.htmlTemplate(content, this.totalSize);

    function renderHtmlSegment({ value, htmlFormat, binaryData }: Segment, offset: number) {
      return htmlFormat(value, binaryData, offset);
    }
  }
}

export interface Format<T> {
  binaryFormat: BinaryFormat<T>;
  htmlFormat: HTMLFormat<T>;
}

export const noContainer: VisualBufferHTMLContainer = content => content;
