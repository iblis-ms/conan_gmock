#!/bin/bash

set -e

cd tests/$TRAVIS_OS_NAME

./setUp.sh

cd ../..
