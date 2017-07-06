@echo OFF

setlocal EnableDelayedExpansion

SET GMOCK=%1
SET GTEST=%2
SET SHARED=%3
SET INCLUDE_MAIN=%4

SET "CC=%VISUAL_STUDIO_COMPILER%"
SET "CXX=%VISUAL_STUDIO_COMPILER%"

ECHO "------------------ test program: Visual Studio %VISUAL_STUDIO_VERSION%  ------------------"

SET "CURRENT_DIR=%~dp0"
SET "APP_DIR=%CURRENT_DIR%\..\app"


CD %APP_DIR%

SET "NAME=output_Visual_gmock_!GMOCK!_gtest_!GTEST!_shared_!SHARED!_include_main_!INCLUDE_MAIN!"

SET "OUTPUT_DIR=%CURRENT_DIR%\..\%NAME%"
IF EXIST "%OUTPUT_DIR%" RD /q /s "%OUTPUT_DIR%"

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
ECHO bin, *.dll -^> ../!NAME!/bin
ECHO bin, *.dylib* -^> ../!NAME!/bin
ECHO bin, *.so -^> ../!NAME!/bin
ECHO lib, *.a -^> ../!NAME!/lib
ECHO lib, *.lib -^> ../!NAME!/lib
ECHO docs, * -^> ../!NAME!/docs
) > "conanfile.txt"
                    
CALL conan install --build -s compiler="Visual Studio" -s compiler.version=%VISUAL_STUDIO_VERSION% -s compiler.runtime=MT
IF %errorlevel% neq 0 EXIT /b %errorlevel%

MKDIR %OUTPUT_DIR%
CD %OUTPUT_DIR%

SET "CC=%VISUAL_STUDIO_COMPILER%"
SET "CXX=%VISUAL_STUDIO_COMPILER%"

ECHO "------ Generating Visual Studio project"
cmake -G "Visual Studio %VISUAL_STUDIO_VERSION% %VISUAL_STUDIO_YEAR% Win64" -DCMAKE_BUILD_TYPE=Release -DBUILD_GTEST=%GTEST% -DBUILD_GMOCK=%GMOCK% -DSHARED=%SHARED% -DINCLUDE_MAIN=%INCLUDE_MAIN% %APP_DIR% 
IF %errorlevel% neq 0 EXIT /b %errorlevel%

ECHO "------ Compiling Visual Studio project"
cmake --build .
IF %errorlevel% neq 0 EXIT /b %errorlevel%

CD %OUTPUT_DIR%\bin
GMockTestProgram
IF %errorlevel% neq 0 EXIT /b %errorlevel%

CD %CURRENT_DIR%
