#!/bin/bash

echo "------------------ stop server conan ------------------"

pid=`ps | grep conan_server | grep -v grep | awk '{ print $1 }'`

kill $pid
