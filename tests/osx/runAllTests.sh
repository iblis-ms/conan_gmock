#!/bin/bash

set -e

export repoBaseDir=`pwd`/../..

export clangVersionMajor=8
export clangVersionMinor=1

export clangVersion=$clangVersionMajor.$clangVersionMinor
export clangCppBin=/usr/bin/clang++
export clangCcBin=/usr/bin/clang
export clangName="apple-clang"

./runConanPackageTest.sh

./runTestPrograms.sh

