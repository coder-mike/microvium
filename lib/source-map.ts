import * as IL from './il';
import path from 'path';

export interface SourceMap {
  operations: Array<{
    start: number;
    end: number;
    source: IL.OperationSourceLoc;
    op: IL.Operation;
  }>;
}

// export function stringifySourceMap(sourceMap: SourceMap) {
//   const aggregated: SourceMap['operations'] = [];

//   // Merge adjacent operations with the same source location.
//   for (const op of sourceMap.operations) {
//     const last = aggregated[aggregated.length - 1];
//     if (aggregated.length > 0 &&
//       op.start === last.end &&
//       sourceEqual(last.source, op.source)
//     ) {
//       last.end = op.end;
//     } else {
//       aggregated.push(op);
//     }
//   }

//   const lines: string[] = [];
//   const cwd = process.cwd();
//   for (const [i, op] of aggregated.entries()) {
//     // Gap between operations.
//     if (i > 0 && aggregated[i - 1].end !== op.start) {
//       lines.push(aggregated[i - 1].end.toString(16).padStart(4, '0'));
//       lines.push('');
//     }
//     lines.push(`${
//       op.start.toString(16).padStart(4, '0')
//     } ${stringifyLoc(op.source)}`);
//   }

//   return lines.join('\n');

//   function stringifyLoc(loc: IL.OperationSourceLoc){
//     return `${
//       path.relative(cwd, loc.filename)
//     }:${
//       loc.line
//     }:${
//       loc.column + 1
//     }`;
//   }

//   function sourceEqual(a: IL.OperationSourceLoc, b: IL.OperationSourceLoc) {
//     return a.filename === b.filename && a.line === b.line && a.column === b.column;
//   }
// }

export function stringifySourceMap(sourceMap: SourceMap) {
  const lines: string[] = [];
  const cwd = process.cwd();
  const operations = sourceMap.operations
  for (const [i, op] of operations.entries()) {
    // Gap between operations.
    if (i > 0 && operations[i - 1].end !== op.start) {
      lines.push(operations[i - 1].end.toString(16).padStart(4, '0'));
      lines.push('');
    }
    lines.push(`${
      op.start.toString(16).padStart(4, '0')
    } ${
      op.op.opcode.padEnd(13, ' ')
    } ${
      stringifyLoc(op.source)
    }`);
  }

  return lines.join('\n');

  function stringifyLoc(loc: IL.OperationSourceLoc){
    return `${
      path.relative(cwd, loc.filename)
    }:${
      loc.line
    }:${
      loc.column + 1
    }`;
  }

  function sourceEqual(a: IL.OperationSourceLoc, b: IL.OperationSourceLoc) {
    return a.filename === b.filename && a.line === b.line && a.column === b.column;
  }
}