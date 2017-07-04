#!/bin/bash

set -e

echo "------------------ package tests ------------------"

currentScriptPath=$(readlink -f "$0")
export currentDir=$(dirname "$currentScriptPath")

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
conan test_package -s compiler=$clangName -s compiler.version=$clangVersion -s compiler.libcxx=libc++
echo "----------------------- test package: CLANG: libstdc++ -----------------------"
conan test_package -s compiler=$clangName -s compiler.version=$clangVersion -s compiler.libcxx=libstdc++
echo "----------------------- test package: CLANG: libstdc++11 -----------------------"
conan test_package -s compiler=$clangName -s compiler.version=$clangVersion -s compiler.libcxx=libstdc++11

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
conan test_package -s compiler=gcc -s compiler.version=$gccVersion -s compiler.libcxx=libstdc++
echo "----------------------- test package: GCC: libstdc++11 -----------------------"
conan test_package -s compiler=gcc -s compiler.version=$gccVersion -s compiler.libcxx=libstdc++11

cd $currentDir
