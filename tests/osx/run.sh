#!/bin/bash

set -e

compiler="$1"
stdlib="$2"

variableName="${compiler}Version"
compilerVersion="${!variableName}"

echo "------------------ test program: $compiler $compilerVersion $stdlib ------------------"

currentDir=`pwd`
runDir="$currentDir/.."
outputDir="$runDir/output_${compiler}_${stdlib}"
appDir="$runDir/app"

variableName="${compiler}CppBin"
export CXX="${!variableName}"
variableName="${compiler}CcBin"
export CC="${!variableName}"
variableName="${compiler}Name"
compilerName="${!variableName}"

if [ ! -e "$CXX" ]; then
  echo "NOT EXISTS: $CXX"
  exit 1
fi
if [ ! -e "$CC" ]; then
  echo "NOT EXISTS: $CC"
  exit 1
fi

cd "$appDir"
echo "conan install --build -s compiler=$compilerName -s compiler.version=$compilerVersion -s compiler.libcxx=$stdlib"
conan install --build -s compiler=$compilerName -s compiler.version=$compilerVersion -s compiler.libcxx=$stdlib

if [ -d "$outputDir" ]
then
  rm -rf "$outputDir"
fi

mkdir "$outputDir"
cd "$outputDir"
cmake -DCMAKE_BUILD_TYPE=Release -DSTDLIB="$stdlib" "$appDir"
cmake --build .
cd "$outputDir/bin"
./GMockTestProgram

cd "$callDir"

