/*---
description: >
  Tests various branching instructions
runExportedFunction: 0
expectedPrintout: |
  #1: This is the alternate
  #2: This is the consequent
---*/
function run() {
  if (false) {
    $$MicroviumNopInstruction(200);
    print("#1: This is the consequent");
  } else {
    $$MicroviumNopInstruction(200);
    print("#1: This is the alternate");
  }

  if (true) {
    $$MicroviumNopInstruction(200);
    print("#2: This is the consequent");
  } else {
    $$MicroviumNopInstruction(200);
    print("#2: This is the alternate");
  }
}
$$MicroviumNopInstruction(200);

vmExport(0, run);