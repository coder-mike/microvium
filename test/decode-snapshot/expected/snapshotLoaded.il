export 42 = &function c080;

slot ['<no file>:a'] = &allocation 16414;
slot ['<no file>:o'] = &allocation 16386;
slot ['global:print'] = host function 100;

function c080() {
  c081:
    LoadGlobal(name 'global:print');
    Literal(lit undefined);
    LoadGlobal(name '<no file>:o');
    Literal(lit 'x');
    ObjectGet();
    Call(count 2);
    Pop(count 0);
    LoadGlobal(name 'global:print');
    Literal(lit undefined);
    LoadGlobal(name '<no file>:a');
    Literal(lit 0);
    ObjectGet();
    Call(count 2);
    Pop(count 0);
    Literal(lit undefined);
    Return();
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