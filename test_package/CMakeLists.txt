# Author: Marcin Serwach
# https://github.com/iblis-ms/conan_gbenchmark

cmake_minimum_required(VERSION 2.8.12)

project(GMockPackageTest CXX)

include(${CMAKE_BINARY_DIR}/conanbuildinfo.cmake)
conan_basic_setup()

set(EXE_NAME "example")

add_executable(${EXE_NAME} GMockExample.cpp)

find_package(Threads)

target_link_libraries(${EXE_NAME} PRIVATE ${CONAN_LIBS} PRIVATE ${CMAKE_THREAD_LIBS_INIT})

set_target_properties(${EXE_NAME} PROPERTIES CXX_STANDARD 11)

