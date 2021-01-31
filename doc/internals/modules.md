# Modules

This document explains how modules work in Microvium.

Note that modules do not exist at "runtime" on the firmware device. By the time the snapshot is taken, all modules have been loaded and evaluated, and there are no module features of the runtime VM.

Modules are "linked" by calling `VirtualMachine.evaluateModule`, giving it the source code to evaluate and a import hook to fetch dependencies.

`evaluateModule` compiles the source text to a `Unit`, and then transitively loads (and evaluates) the imported dependencies of the module.

## Compilation Units

A source code file is compiled to IL using the `compileScript` function, the output of which is an `IL.Unit`. This compilation is completely independent of other modules.

Compiled Units have a entry IL function referenced by `Unit.entryFunctionID`. This is the function that will be run to evaluate the module (the module's root-level code).

Modules are not "linked" at compile time like in a C compiler, but rather _loaded_ into a running VM using `VirtualMachine.loadUnit`.

During loading, a new global slot in the VM is allocated for each module-level variable, and similarly a globally-unique function name is found for each function in the module (the function namespace and variable namespace are orthogonal). The IL for each function is then "relocated":

  - Function names are remapped to their new globally-unique names
  - References to module level variables are similarly remapped
  - And the same for references to imported modules

