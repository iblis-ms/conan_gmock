@echo OFF

setlocal EnableDelayedExpansion

SET GMOCK=%1
SET GTEST=%2
SET SHARED=%3
SET INCLUDE_MAIN=%4

SET "LIB_STD=%5"

SET "CC=%GCC%"
SET "CXX=%GPP%"

ECHO "------------------ test program: GCC %GCC% %LIB_STD% ------------------"

SET "CURRENT_DIR=%~dp0"
SET "APP_DIR=%CURRENT_DIR%\..\app"

CD %APP_DIR%

SET "NAME=output_GCC_gmock_!GMOCK!_gtest_!GTEST!_shared_!SHARED!_include_main_!INCLUDE_MAIN!_%LIB_STD%"
(
ECHO [requires]
ECHO GMock/1.8.0@iblis_ms/stable
ECHO [options]
ECHO GMock:BUILD_SHARED_LIBS=!SHARED!
ECHO GMock:BUILD_GTEST=!GTEST!
ECHO GMock:BUILD_GMOCK=!GMOCK!
ECHO GMock:include_main=!INCLUDE_MAIN!
ECHO [generators]
ECHO cmake
ECHO [imports]
ECHO lib, *.dll -^> ../!NAME!/bin
ECHO lib, *.dylib* -^> ../!NAME!/bin
ECHO lib, *.so -^> ../!NAME!/bin
ECHO lib, *.a -^> ../!NAME!/lib
ECHO lib, *.lib -^> ../!NAME!/lib
ECHO docs, * -^> ../!NAME!/docs
) > "conanfile.txt"

CALL conan install --build -s compiler=gcc -s compiler.version=%GCC_VERSION% -s compiler.libcxx=%LIB_STD%
IF %errorlevel% neq 0 EXIT /b %errorlevel%

SET "OUTPUT_DIR=%CURRENT_DIR%\..\%NAME%"
IF EXIST "%OUTPUT_DIR%" RD /q /s "%OUTPUT_DIR%"

MKDIR %OUTPUT_DIR%
CD %OUTPUT_DIR%

SET "CC=%GCC%"
SET "CXX=%GPP%"

cmake -G "MinGW Makefiles" -DCMAKE_BUILD_TYPE=Release -DSTDLIB=%LIB_STD% %APP_DIR% 
IF %errorlevel% neq 0 EXIT /b %errorlevel%

cmake --build .
IF %errorlevel% neq 0 EXIT /b %errorlevel%

CD bin
GMockTestProgram
IF %errorlevel% neq 0 EXIT /b %errorlevel%

CD %CURRENT_DIR%
