export 42 = &function ['<no file>:run'];

slot ['<no file>:a'] = &allocation 7;
slot ['<no file>:o'] = &allocation 5;
slot ['global:print'] = host function 100;

function ['<builtin>:Array_push']() {
  entry:
    LoadArg(index 1);
    LoadVar(index 0);
    LoadArg(index 0);
    LoadArg(index 0);
    Literal(lit 'length');
    ObjectGet();
    LoadVar(index 1);
    ObjectSet();
    Pop(count 1);
    Literal(lit undefined);
    Return();
}

function ['<no file>:run']() {
  entry:
    LoadGlobal(name 'global:print');
    Literal(lit undefined);
    LoadGlobal(name '<no file>:o');
    Literal(lit 'x');
    ObjectGet();
    Call(count 2);
    Pop(count 1);
    LoadGlobal(name 'global:print');
    Literal(lit undefined);
    LoadGlobal(name '<no file>:a');
    Literal(lit 0);
    ObjectGet();
    Call(count 2);
    Pop(count 1);
    Literal(lit undefined);
    Return();
}

allocation 3 = {
  push: &function ['<builtin>:Array_push'],
};

allocation 5 = {
  x: 'Hello, World!',
  y: &allocation 6,
};

allocation 6 = {
  z: 'Hello, World!',
};

allocation 7 = [
];