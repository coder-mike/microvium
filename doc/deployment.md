# Deployment

This package is deployed with the prebuilt binaries using [prebuildify](https://github.com/prebuild/prebuildify).

## Preparation

 1. Make sure that node-gyp is installed globally (`npm install -g node-gyp`), since, as of this writing, `prebuildify` doesn't seem to use the locally installed instance.

 2. `npm install -g prebuildify`

If running prebuilds on linux on Windows, see here to install the build tools:

  - https://tecadmin.net/install-development-tools-on-ubuntu/


## Deployment

### 1. Bump version number

Note: make sure you test before bumping the version, because the version bump will modify the test output and require re-approval, and it's better not to have to sort through multiple changes in the test output.

First, bump the version number in [package.json](../package.json). I don't commit to git yet because the following steps could find errors that you want to clean up first.

Consider bumping the `MVM_ENGINE_MAJOR_VERSION` and `MVM_ENGINE_MINOR_VERSION` in `microvium.h`. I bump the major version if there is a breaking change to the bytecode, such that a new version of the engine is required to run it. I bump the minor version if there is a change to the engine but no change to the bytecode, so the new engine is compatible with the old bytecode.

I think going forward I will make the package version the same as the engine version, for simplicity, so you know what version of the compiler comes with what version of the engine and compiles what version of bytecode.

Build with the new version numbers:

```sh
npm run build
npm run test  # This will fail, but you need to run it to inspect the failures
```

Note: when you change the version numbers, it will change the binary output so you'll need to approve the output:

```sh
npm run approve
npm run test
```

### 2. Build for Linux

I'm deploying from a Windows machine, but I want to pre-build the linux binary files as well so I open up a WSL terminal and run the following to generate the linux release binaries:

```sh
prebuildify --napi
```

Note: this wipes the `build` directory and uses it for the Linux files. When you're done, you'll need to go back to Windows and run `node-gyp configure` to get the Windows files back. Or otherwise, continue with step `3`, since `npm run build-and-deploy` will rebuild the Windows files anyway.

### 3. Build for Windows and Deploy

Going back into Windows, I run:

```sh
npm run build-and-deploy
```

This makes the prebuilds for Windows, runs some tests, and **publishes to npm**.

### 4. Commit and Tag

Then I commit to git, and create git tag on the commit with the following command:

```sh
git commit -am "Bump version to vX.X.X"
git tag -a "vX.X.X" -m "vX.X.X"
git push --tags origin
```

### 5. GitHub Release

Then go to github and and create a new release off this tag, with the same naming format `vX.X.X`:

https://github.com/coder-mike/microvium/releases