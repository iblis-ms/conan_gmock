#!/bin/bash

set -e

cd tests/$TRAVIS_OS_NAME

./testRun.sh

cd ../..
