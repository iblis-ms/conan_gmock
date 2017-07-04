cmake_minimum_required(VERSION 2.8)
project(conanGoogleBenchmark)

include(conanbuildinfo.cmake)
CONAN_BASIC_SETUP()

add_subdirectory("googletest-release-1.8.0")
