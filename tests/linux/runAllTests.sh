#!/bin/bash

set -e

export repoBaseDir=`pwd`/../..

export clangVersionMajor=5
export clangVersionMinor=0

export gccVersionMajor=7
export gccVersionMinor=3


export clangVersion=$clangVersionMajor.$clangVersionMinor
export clangCppBin=/usr/bin/clang++-$clangVersion
export clangCcBin=/usr/bin/clang-$clangVersion
export clangName="clang"

export gccVersion=$gccVersionMajor.$gccVersionMinor
export gccCppBin=/usr/bin/g++-$gccVersionMajor
export gccCcBin=/usr/bin/gcc-$gccVersionMajor
export gccName="gcc"

export sharedLibExt="so"
export staticLibExt="a"

./runConanPackageTest.sh

./runTestPrograms.sh

