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

conan export . GMock/1.8.0@iblis_ms/stable

echo "----------------------- test package: CLANG: libc++ -----------------------"
#conan test test_package -s compiler=$clangName -s compiler.version=$clangVersion -s compiler.libcxx=libc++ GMock/1.8.0@iblis_ms/stable --build
echo "----------------------- test package: CLANG: libstdc++ -----------------------"
conan test test_package -s compiler=$clangName -s compiler.version=$clangVersion -s compiler.libcxx=libstdc++ GMock/1.8.0@iblis_ms/stable --build
echo "----------------------- test package: CLANG: libstdc++11 -----------------------"
conan test test_package -s compiler=$clangName -s compiler.version=$clangVersion -s compiler.libcxx=libstdc++11 GMock/1.8.0@iblis_ms/stable --build

########################## GCC ##########################

export CXX=$gccCppBin
export CC=$gccCcBin

if [ ! -e "$CXX" ]; then
  echo "NOT EXISTS: $CXX"
  exit 1
fi
if [ ! -e "$CC" ]; then
  echo "NOT EXISTS: $CC"
  exit 1
fi

echo "----------------------- test package: GCC: libstdc++ -----------------------"
conan test test_package -s compiler=$gccName -s compiler.version=$gccVersion -s compiler.libcxx=libstdc++ GMock/1.8.0@iblis_ms/stable --build
echo "----------------------- test package: GCC: libstdc++11 -----------------------"
conan test test_package -s compiler=$gccName -s compiler.version=$gccVersion -s compiler.libcxx=libstdc++11 GMock/1.8.0@iblis_ms/stable --build

cd $currentDir
