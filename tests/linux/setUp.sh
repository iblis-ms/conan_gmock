#!/bin/bash

set -e


currentScriptPath=$(readlink -f "$0")
currentDir=$(dirname "$currentScriptPath")

export repoBaseDir=$currentDir/../..

cd $repoBaseDir
docker build -t conan_gbenchmark . 
cd $currentDir
