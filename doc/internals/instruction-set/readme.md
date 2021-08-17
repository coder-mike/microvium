# Instruction Set Documentation

The instruction set documentation for Microvium is written [instruction-set.js](./script/instruction-set.js) and viewed by opening [index.html](./index.html) in a browser and which uses in-page JavaScript to generate the SVG diagrams for the documentation.

The in-page JavaScript also accesses some of the built JS files from the project itself, which it uses to create empty sections for opcodes that aren't yet documented and to know the bit pattern to render for the native opcodes.

It would be nice at some point if the build pipeline could render this into a static HTML page.