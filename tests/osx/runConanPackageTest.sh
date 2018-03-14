#!/bin/bash

set -e

echo "------------------ package tests ------------------"

currentDir=`pwd`
cd $repoBaseDir

########################## CLANG ##########################

export CXX=$clangCppBin
export CC=$clangCcBin

if [ ! -e "$CXX" ]; then
  echo "NOT EXISTS: $CXX"
  exit 1
fi
if [ ! -e "$CC" ]; then
  echo "NOT EXISTS: $CC"
  exit 1
fi

echo "----------------------- test package: CLANG: libc++ -----------------------"
conan test test_package -s compiler=$clangName -s compiler.version=$clangVersion -s compiler.libcxx=libc++ GMock/1.8.0@iblis_ms/stable --build

cd $currentDir
