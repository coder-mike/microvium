# Deployment

This package is deployed with the prebuilt binaries using [prebuildify](https://github.com/prebuild/prebuildify).

## Preparation

 1. Make sure that node-gyp is installed globally (`npm install -g node-gyp`), since, as of this writing, `prebuildify` doesn't seem to use the locally installed instance.

 2. `npm install -g prebuildify`

## Deployment

`npm publish --access=public`
