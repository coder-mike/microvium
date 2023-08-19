# Alternatives

Some alternatives to consider to run scripts on microcontrollers:

  - [EmbedVM](https://embedvm.com) - the most compact scripting engine I've come across. Very feature restricted, and not JS. See also [microvium-vs-embedvm.md](microvium-vs-embedvm.md).
  - [Cesanta mJS](https://github.com/cesanta/mjs) - the most similar to Microvium in their objective to run a subset of ES6 in the smallest space possible. See also [microvium-vs-mjs.md](microvium-vs-mjs.md)
  - [Moddable XS](https://github.com/Moddable-OpenSource/moddable) - the most complete JavaScript engine. XS is robust and feature complete, supporting the latest ECMAScript standard. Moddable are the only company listed here to participate in the TC39 JavaScript language committee. XS is also much larger and heavier than Microvium.
  - [Cesanta ELK](https://github.com/cesanta/elk) - similar to mJS but sacrifices more features to obtain a smaller footprint.
  - [MicroPython](https://micropython.org/)
  - [Duktape](https://duktape.org/)
  - [Espruino](https://www.espruino.com/)
  - [JerryScript](https://jerryscript.net/)
  - [MuJS](https://mujs.com/)
  - [LowJS](https://www.neonious-iot.com/lowjs/) - runs a stripped down version of node on ESP32 devices.
  - [eLua](http://www.eluaproject.net/)

The different options have different pros and cons. Microvium's key features amongst the crowd are:

  - [Small size and RAM usage](./native-host/memory-usage.md). As little as 22 bytes of RAM per idle virtual machine.
  - Easy to [get started](https://microvium.com/getting-started/).
    - No third-party tools need to be installed, no environment variables need to be set up.
    - Runtime engine is a single, self-contained, portable `.c` file
    - No need to clone the Microvium repo or get stuck into its source code (if you're on Windows, just use [the Windows installer](https://microvium.com/download/))
  - [Its snapshotting mechanism](./concepts.md) for pre-compiling the source code before sending it to the device. This is in contrast to solutions which require extra metadata/configuration/manifest files to describe which files to compile, or to solutions which run a full interpreter on the device at the cost of extra runtime overhead.
  - Out-of-the-box support for ES6 modules (`import` and `export`) so script code can be divided into multiple files.
  - Portability.
    - Uses standard C code without requiring GNU extensions.
    - Access to flash is completely abstracted through READ/WRITE macros that the host can override, so RAM and flash can be in different address spaces (a so-called "Harvard Architecture" such as AVR8 used in Arduino), or on devices with a near/far mixed-memory model like MSP430X, or in cases where flash is not memory-mapped at all (e.g. when using an external flash chip or file system).
  - Documentation
  - [Permissive license](https://tldrlegal.com/license/mit-license) - both the engine and compiler use the non-viral MIT license and are free to use and modify in commercial products.

See also [What about Microvium alternatives?](https://coder-mike.com/behind-microvium/#what-about-microvium-alternatives)
