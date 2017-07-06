#!/bin/bash

set -e

currentDir=`pwd`

export repoBaseDir=$currentDir/../..

cd $repoBaseDir
docker run conan_gbenchmark /bin/bash -c "cd /test/tests/linux && ./runAllTests.sh"

cd $currentDir
