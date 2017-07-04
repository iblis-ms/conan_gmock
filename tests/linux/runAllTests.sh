#!/bin/bash

set -e

export repoBaseDir=`pwd`/../..

export clangVersionMajor=4
export clangVersionMinor=0

export gccVersionMajor=6
export gccVersionMinor=3


export clangVersion=$clangVersionMajor.$clangVersionMinor
export clangCppBin=/usr/bin/clang++-$clangVersion
export clangCcBin=/usr/bin/clang-$clangVersion
export clangName="clang"

export gccVersion=$gccVersionMajor.$gccVersionMinor
export gccCppBin=/usr/bin/g++-$gccVersionMajor
export gccCcBin=/usr/bin/gcc-$gccVersionMajor


./runConanPackageTest.sh

./runTestPrograms.sh


