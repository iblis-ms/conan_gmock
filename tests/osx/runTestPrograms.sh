#!/bin/bash

set -e

echo "------------------ program tests ------------------"

currentDir=`pwd`



for shared in True False
do
  for gtest in True False
  do
    for gmock in True False
    do
      if [ "$gtest" != "False" ] || [ "$gmock" != "False" ]
      then
        for include_main in True False
        do

          for compiler in clang
          do
            for stdlib in libc++
            do
              if [ "$compiler" != "gcc" ] || [ "$stdlib" != "libc++" ]
              then
                echo "--------------------------------------------"
                echo "-------------------- compiler: ${compiler}"
                echo "-------------------- stdlib: ${stdlib}"
                echo "-------------------- gmock: ${gmock}"
                echo "-------------------- gtest: ${gtest}"
                echo "-------------------- shared: ${shared}"
                echo "-------------------- include_main: ${include_main}"
                ./run.sh $compiler $stdlib $gmock $gtest $shared $include_main
              fi
            done
          done
        done
      fi
    done
  done
done


cd "$currentDir"
