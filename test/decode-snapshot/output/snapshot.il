export 42 = &function c080;

slot global0 = host function 100;
slot global1 = &allocation 16386;
slot global2 = &allocation 16414;

function c080() {
  c081:
    LoadGlobal(name 'global0');
}

allocation 16386 = {
  x: 'Hello, World!',
  y: &allocation 16402,
};

allocation 16402 = {
  z: 'Hello, World!',
};

allocation 16414 = [
];