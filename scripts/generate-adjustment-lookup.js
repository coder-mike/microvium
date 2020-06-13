const fs = require('fs');

const table1 = [];
for (let i = 0; i < 16; i++) {
  table1[i] = count(i, false);
}

const table2 = [];
for (let i = 0; i < 16; i++) {
  table2[i] = count(i, true);
}

const cCode =
  `static const int8_t adjustmentLookup[2][16] = {{${table1.join(',')}}, {${table2.join(',')}}};`

fs.writeFileSync('adjustment-lookup-output.temp.c', cCode);

function count(bits, inAllocation) {
  let adjustment = 0;
  for (let i = 0; i < 4; i++) {
    if (bits & (0x8 >> i)) {
      if (inAllocation) {
        inAllocation = false;
        adjustment--; // Clear the adjustment flag
      } else {
        inAllocation = true;
        adjustment++; // Set the adjustment flag
      }
    } else if (!inAllocation) {
      adjustment += 2;
    }
  }
  return adjustment;
}