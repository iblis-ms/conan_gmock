# Conan.io with GoogleMock (GMock) & GoogleTest (GTest)

Linux/OSx
[![Build Status](https://travis-ci.org/iblis-ms/conan_gmock.svg?branch=master)](https://travis-ci.org/iblis-ms/conan_gmock)

Windows
[![Build status](https://ci.appveyor.com/api/projects/status/github/iblis-ms/conan_gmock?branch=master&svg=true)](https://ci.appveyor.com/project/iblis-ms/conan-gmock)


Conan.io ([version 0.24.0](https://www.conan.io/downloads)) is a C/C++ package manager. It allows downloading, compiling external libraries for specific operating system, architecture or with given compilation flags. Conan.io can be extremely helpful with big project with many components by automatic downloading (and building if required) dependency components.
This repository contains configuration files to use Googlemock/Googletest (GTest/GMock) version 1.8.0 with your code. 

# How to use it?

Conan.io's documentation of uploading packages to your server is on [http://docs.conan.io/en/latest/packaging/upload.html].
However, you can easily follow steps below:
* Download this repository
* Check if you have write permission in file *~/.conan_server/server.conf* (there is meaningful description about its syntax). If you don't have this file (or entire folder), run Conan.io server.
* run Conan.io server: 
```
conan_server&
```
* Login to your Conan.io server (default: password: *demo* login *demo* - you can add users in *~/.conan_server/server.conf*):
```
conan user -p demo -r local demo
```
* Add local server to remote list:
```
conan remote add local http://localhost:9300
```
* Enter to directory with *conanfile.py*.
* Export *conanfile.py* to cache:
```
conan export iblis_ms/stable
```
* Upload package:
```
conan upload GMock/1.8.0@iblis_ms/stable --all -r=local
```
* To test if it is working correctly. Enter to *tests/app* folder.
* Run Conan.io to link program with GoogleMock
```
conan install --build
```
* See *conaninfo.txt* to check what you have already built.

# Options
You can specify CMake configuration that will be used to compile GMock/GTest by Conan.io's options. All of options have the same name as GMock/GTest's CMake arguments.

| Option | Default | Comment |
|--------|---------|---------|
| BUILD_SHARED_LIBS | False | True means building shared GTest/GMock libraries. Static libs are built by default. |
| BUILD_GTEST | False | True means building GTest libs. GMock contains GTest source, so False is default. Specify True if you want to build GTest only. |
| BUILD_GMOCK | True | True means building GMock libs. |
| include_main | True | If True GMock/GTest library with main method is building. |
| gmock_build_tests | False | If True, GMock tests are building. |
| gtest_build_tests | False | If True, GTest tests are building. |
| gtest_build_samples | False | If True, GTest samples are building. |
| gtest_disable_pthreads | False | If True, GTest doesn't use pthread. |
| gtest_hide_internal_symbols | False | If True, internal symbols are hidden. |

## Examples
* Basic usage - GTest & GMock
```
[requires]
GMock/1.8.0@iblis_ms/stable

[generators]
cmake

[imports]
lib, *.a -> ./lib
lib, *.lib -> ./lib
docs, * -> ./docs
```
Imports section copies static libraries and documentation.

* GTest only
```
[requires]
GMock/1.8.0@iblis_ms/stable

[options]
GMock:BUILD_GTEST=True
GMock:BUILD_GMOCK=False

[generators]
cmake

[imports]
lib, *.a -> ./lib
lib, *.lib -> ./lib
docs, * -> ./docs
```

* GTest & GMock without main function as shared libs
```
[requires]
GMock/1.8.0@iblis_ms/stable

[options]
GMock:BUILD_SHARED_LIBS=True
GMock:include_main=False

[generators]
cmake

[imports]
bin, *.dll -> ./bin
lib, *.dylib* -> ./bin
lib, *.so -> ./bin
lib, *.a -> ./lib
lib, *.lib -> ./lib
docs, * -> ./docs
```

# Supported platforms and compilers
There are automatic tests for operating systems and compilers below. For each case there is checked if program is compiling and running using GTest/GMock with True/False values for options:  BUILD_GTEST, BUILD_GMOCK, BUILD_SHARED_LIBS, include_main.

## Windows 7 64bits

CMake version: 3.8.1

* MinGW x86_64 (Conan.io automatically adds required option: gtest_disable_pthreads=True)
  * version: 6.3.0
    - conan test_package -s compiler=gcc -s compiler.version=6.3 -s compiler.libcxx=libstdc++11
    - conan test_package -s compiler=gcc -s compiler.version=6.3 -s compiler.libcxx=libstdc++
    
* Visual Studio Community 
  * version: 2017
    - conan test_package -s compiler="Visual Studio" -s compiler.version=15 -s compiler.runtime=MD
  * version: 2015
    - conan test_package -s compiler="Visual Studio" -s compiler.version=14 -s compiler.runtime=MD

## Ubuntu 17.04 64bits

CMake version: 3.7.2

* GCC
  * version: 6.3
    - conan test_package -s compiler=gcc -s compiler.version=6.3 -s compiler.libcxx=libstdc++
    - conan test_package -s compiler=gcc -s compiler.version=6.3 -s compiler.libcxx=libstdc++11

* Clang
  * version: 4.0
    - conan test_package -s compiler=clang -s compiler.version=4.0 -s compiler.libcxx=libc++
    - conan test_package -s compiler=clang -s compiler.version=4.0 -s compiler.libcxx=libstdc++
    - conan test_package -s compiler=clang -s compiler.version=4.0 -s compiler.libcxx=libstdc++11

## OSX Sierra 64bits

CMake version: 3.8.2

* Clang (apple-clang in Conan.io)
  * version: 8.1 (based on Clang 3.1)
    - conan test_package -s compiler=apple-clang -s compiler.version=8.1 -s compiler.libcxx=libc++
