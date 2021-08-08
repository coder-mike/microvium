const makeIncrementor = () => {
  let w = 0; // Local
  let x = 0; // Scoped
  let y = 0; // Scoped
  let z = 0; // Unused
  w++;
  return () => x++ + y++;
}

const incrementor = makeIncrementor();
const x = incrementor();
const y = incrementor();