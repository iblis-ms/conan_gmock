#!/bin/bash

set -e

echo "------------------ program tests ------------------"

callDir=`pwd`

if [ -d ~/.conan_server/data/GMock ]
then
  rm -rf ~/.conan_server/data/GMock
fi

if [ -d ~/.conan/data/GMock ]
then
  rm -rf ~/.conan/data/GMock
fi

./startConanServer.sh

./run.sh clang libc++

./stopConanServer.sh

cd "$callDir"
