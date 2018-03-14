#!/bin/bash

set -e
set -v
cd tests/$TRAVIS_OS_NAME

./testRun.sh

cd ../..
