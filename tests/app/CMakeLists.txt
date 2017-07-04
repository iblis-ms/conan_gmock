# Author: Marcin Serwach
# https://github.com/iblis-ms/conan_gbenchmark

cmake_minimum_required(VERSION 2.8.12)

project(GMockTestProgram CXX)

set(CMAKE_VERBOSE_MAKEFILE ON)
include(conanbuildinfo.cmake)
conan_basic_setup()

set(PROGRAM_NAME "${PROJECT_NAME}")

message(STATUS "Program name: ${PROGRAM_NAME}")

add_executable(${PROGRAM_NAME} GMockExample.cpp)

find_package(Threads)

target_link_libraries(${PROGRAM_NAME} PRIVATE ${CONAN_LIBS} ${CMAKE_THREAD_LIBS_INIT})

set_target_properties(${PROGRAM_NAME} PROPERTIES CXX_STANDARD 11)

# Conan sets D_GLIBCXX_USE_CXX11_ABI=1 for stdlibc++11. 
# You can't mix D_GLIBCXX_USE_CXX11_ABI=0 library with D_GLIBCXX_USE_CXX11_ABI=1 program because of runtime crashes.
if (${CMAKE_CXX_COMPILER_ID} STREQUAL "Clang")
  if (${STDLIB} STREQUAL "libc++")
    target_compile_options(${PROGRAM_NAME} PUBLIC "-stdlib=libc++")
    set_target_properties(${PROGRAM_NAME} PROPERTIES LINK_FLAGS "-stdlib=libc++")
  elseif (${STDLIB} STREQUAL "libstdc++")
    target_compile_options(${PROGRAM_NAME} PUBLIC "-stdlib=libstdc++" "-D_GLIBCXX_USE_CXX11_ABI=0")
    set_target_properties(${PROGRAM_NAME} PROPERTIES LINK_FLAGS "-stdlib=libstdc++")
  elseif (${STDLIB} STREQUAL "libstdc++11")
    target_compile_options(${PROGRAM_NAME} PUBLIC "-stdlib=libstdc++" "-D_GLIBCXX_USE_CXX11_ABI=1")
    set_target_properties(${PROGRAM_NAME} PROPERTIES LINK_FLAGS "-stdlib=libstdc++")
  endif()
elseif (${CMAKE_CXX_COMPILER_ID} STREQUAL "GNU")
  if (${STDLIB} STREQUAL "libstdc++")
    target_compile_options(${PROGRAM_NAME} PUBLIC "-D_GLIBCXX_USE_CXX11_ABI=0")
  elseif (${STDLIB} STREQUAL "libstdc++11")
    target_compile_options(${PROGRAM_NAME} PUBLIC "-D_GLIBCXX_USE_CXX11_ABI=1")
  endif()
elseif (${CMAKE_CXX_COMPILER_ID} STREQUAL "MSVC")
  target_compile_options(${PROGRAM_NAME} PUBLIC  "/MT")
endif()

