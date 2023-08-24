/*---
runExportedFunction: 0
assertionCount: 8
---*/

vmExport(0, run);

function run() {
  const nof = Microvium.noOpFunction;
  assertEqual(typeof nof, 'function');
  assertEqual(Microvium.typeCodeOf(nof), 5);
  assertEqual(nof(), undefined);
  assertEqual(nof(42), undefined);
  assertEqual('' + nof, Microvium.isMicrovium ? '[Function]' : '() => undefined');
  assertEqual(nof === nof, true);
  assertEqual(nof !== nof, false);
  assert(Number.isNaN(+nof));
}