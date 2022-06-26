#!/usr/bin/env bash

pushd size-test
./build.sh
awk '/microvium.o/ {printf "\n\n--------------------------------------------\n      Microvium flash size: \033[36m %.2f kB\033[0m\n--------------------------------------------\n", $4/1024 }' output/size.txt