export 42 = undefined;

slot global0 = host function 100;
slot global1 = &allocation 16386;
slot global2 = &allocation 16414;



allocation 16386 = {
  x: 'Hello, World!',
  y: &allocation 16402,
};

allocation 16402 = {
  z: 'Hello, World!',
};

allocation 16414 = [
];