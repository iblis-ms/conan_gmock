#!/bin/bash

set -e

compiler="$1"
stdlib="$2"
gmock=$3
gtest=$4
shared=$5
include_main=$6

name=output_${compiler}_${stdlib}_gmock_${gmock}_gtest_${gtest}_shared_${shared}_include_main_${include_main}

variableName="${compiler}Version"
compilerVersion="${!variableName}"

echo "------------------ test program: $compiler $compilerVersion $stdlib ------------------"

currentDir=`pwd`
runDir="$currentDir/.."
outputDir="$runDir/$name"
appDir="$runDir/app"

variableName="${compiler}CppBin"
export CXX="${!variableName}"
variableName="${compiler}CcBin"
export CC="${!variableName}"
variableName="${compiler}Name"
compilerName="${!variableName}"

if [ ! -e "$CXX" ]; then
  echo "NOT EXISTS: $CXX"
  exit 1
fi
if [ ! -e "$CC" ]; then
  echo "NOT EXISTS: $CC"
  exit 1
fi


cd "$appDir"


if [ -d "$outputDir" ]
then
  rm -rf "$outputDir"
fi

cat > conanfile.txt << EOL
[requires]
GMock/1.8.0@iblis_ms/stable

[options]
GMock:BUILD_SHARED_LIBS=${shared}
GMock:BUILD_GTEST=${gtest}
GMock:BUILD_GMOCK=${gmock}
GMock:include_main=${include_main}

[generators]
cmake

[imports]
bin, *.dll -> ../${name}/bin
lib, *.dylib* -> ../${name}/bin
lib, *.so -> ../${name}/bin
lib, *.a -> ../${name}/lib
lib, *.lib -> ../${name}/lib
docs, * -> ../${name}/docs
EOL

echo "conan install --build -s compiler=$compilerName -s compiler.version=$compilerVersion -s compiler.libcxx=$stdlib"
conan install --build -s compiler=$compilerName -s compiler.version=$compilerVersion -s compiler.libcxx=$stdlib

cd "$outputDir"

cmake -DCMAKE_BUILD_TYPE=Release -DSTDLIB="$stdlib" -DBUILD_GTEST=${gtest} -DBUILD_GMOCK=${gmock} -DINCLUDE_MAIN=${include_main} -DSHARED=${shared} "$appDir"
cmake --build .

if [ -d "$outputDir/bin" ]
then
  cd "$outputDir/bin"
  echo "################################### <run> ###################################"
  ./GMockTestProgram
  echo "################################### </run> ##################################"
  cd
else
  echo "################################### BUILD FAILED ###################################"
fi

if [ ! -d "$outputDir/docs" ]
then
  echo "Folder doc doesn't exists under location: $outputDir/docs"
  exit 1
fi

cd "$outputDir"

if [ "$shared" == "True" ]
then
  libSubfolder='bin'
  libExt=$sharedLibExt
else
  libSubfolder='lib'
  libExt=$staticLibExt
fi
if [ ! -d "$outputDir/$libSubfolder" ]
then
  echo "Library directory doesn't exist: $outputDir/$libSubfolder"
  exit 1
fi
libResult=`find $outputDir/$libSubfolder -name *.$libExt`

if [ -z $libResult ]
then
  echo "Library *.$libExt not found at $outputDir/$libSubfolder"
  exit 1
fi

cd "$currentDir"

