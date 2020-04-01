# MicroVM

A compact scripting engine for executing small programs written in a subset of JavaScript.

(The name "MicroVM" is tentative)

## Install

```sh
npm install
npm build
```

## Usage

Nothing to use yet

## Run Tests

```sh
npm test
```
If you make changes to the code, some output files can be manually inspected and then running the following will update the expected output with the actual output (see `./scripts/pass.ts`):

```
npm run pass
```

Note: if you add a debug watch to evaluate `TraceFile.flushAll`, then the `TraceFile` outputs will all be up to date every time you breakpoint.