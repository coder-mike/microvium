#!/usr/bin/env bash

sudo apt-get -y install gcc-arm-none-eabi binutils-arm-none-eabi
cd size-test && ./build.sh
