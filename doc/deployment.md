# Deployment

This package is deployed with the prebuilt binaries using [prebuildify](https://github.com/prebuild/prebuildify).

## Preparation

 1. Make sure that node-gyp is installed globally (`npm install -g node-gyp`), since, as of this writing, `prebuildify` doesn't seem to use the locally installed instance.

 2. `npm install -g prebuildify`

If running prebuilds on linux on Windows, see here to install the build tools:

  - https://tecadmin.net/install-development-tools-on-ubuntu/


## Deployment

First, bump the version number in [package.json](../package.json). I don't commit to git yet because the following steps could find errors that you want to clean up first.

I'm deploying from a Windows machine, but I want to pre-build the linux binary files as well so I open up an [ubuntu shell](https://www.microsoft.com/en-us/store/p/ubuntu/9nblggh4msv6) and run the following shell command to generate the linux release binaries:

```sh
prebuildify --napi
```

Going back into Windows, I run:

```sh
npm run build-and-deploy
```

This makes the prebuilds for Windows, runs some tests, and **publishes to npm**.

Then I commit to git, and create git tag on the commit with the following command:

```sh
git tag -a "vX.X.X" -m "vX.X.X"
```

Then go to github and and create a new release:

https://github.com/coder-mike/microvium/releases