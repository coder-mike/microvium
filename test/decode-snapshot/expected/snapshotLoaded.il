export 42 = &function run;

slot a = &allocation 9;
slot ['global:print'] = host function 100;
slot o = &allocation 7;

function Array_push() {
  entry:
    LoadArg(index 1);
    LoadArg(index 0);
    LoadArg(index 0);
    Literal(lit 'length');
    ObjectGet();
    LoadVar(index 0);
    ObjectSet();
    Pop(count 1);
    Literal(lit undefined);
    Return();
}

function run() {
  entry:
    LoadGlobal(name 'global:print');
    Literal(lit undefined);
    LoadGlobal(name 'o');
    Literal(lit 'x');
    ObjectGet();
    Call(count 2);
    Pop(count 1);
    LoadGlobal(name 'global:print');
    Literal(lit undefined);
    LoadGlobal(name 'a');
    Literal(lit 0);
    ObjectGet();
    Call(count 2);
    Pop(count 1);
    Literal(lit undefined);
    Return();
}

allocation 5 = {
  push: &function Array_push,
};

allocation 7 = {
  x: 'Hello, World!',
  y: &allocation 8,
};

allocation 8 = {
  z: 'Hello, World!',
};

allocation 9 = [
];