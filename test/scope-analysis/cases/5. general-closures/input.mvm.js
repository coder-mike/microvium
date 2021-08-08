const makeIncrementor = () => {
  let x = 0;
  return () => x++;
}

const incrementor = makeIncrementor();
const x = incrementor();
const y = incrementor();