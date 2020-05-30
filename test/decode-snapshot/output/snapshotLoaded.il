export 42 = &function ['<no file>:run'];

slot ['<no file>:a'] = &allocation 6;
slot ['<no file>:o'] = &allocation 4;
slot ['global:print'] = host function 100;

function ['<no file>:run']() {
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

allocation 4 = {
  x: 'Hello, World!',
  y: &allocation 5,
};

allocation 5 = {
  z: 'Hello, World!',
};

allocation 6 = [
];