# Author: Marcin Serwach
# https://github.com/iblis-ms/conan_gmock

cmake_minimum_required(VERSION 2.8)
project(conanGoogleMockTest)

set(CMAKE_VERBOSE_MAKEFILE ON)

include(conanbuildinfo.cmake)
CONAN_BASIC_SETUP()

add_subdirectory("googletest-release-1.8.0")
