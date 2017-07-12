#!/bin/bash

set -e


currentDir=`pwd`

export repoBaseDir=$currentDir/../..

cd $repoBaseDir

docker build -t conan_gmock . 

cd $currentDir
