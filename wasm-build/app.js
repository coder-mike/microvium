const print = vmImport(1);
vmExport(1, main);

function main() {
  print("hello, world")
}