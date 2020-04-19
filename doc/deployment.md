# Deployment

This package is deployed with the prebuilt binaries using [prebuildify](https://github.com/prebuild/prebuildify).

## Preparation

 1. Make sure that node-gyp is installed globally (`npm install -g node-gyp`), since, as of this writing, `prebuildify` doesn't seem to use the locally installed instance.

 2. `npm install -g prebuildify`

## Deployment

`npm run deploy`

The npm `prepublishOnly` script will create a set of binary prebuilds using prebuildify.

If running prebuilds on linux on Windows, see here to install the build tools:

  - https://tecadmin.net/install-development-tools-on-ubuntu/
