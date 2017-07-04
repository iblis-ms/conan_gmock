@echo OFF

setlocal EnableDelayedExpansion

SET "LIB_STD=%1"

ECHO "------------------ test program: GCC $GCC_VERSION $LIB_STD ------------------"

SET "CURRENT_DIR=%~dp0"
SET "APP_DIR=%CURRENT_DIR%\..\app"

CD %APP_DIR%
CALL conan install --build -s compiler=gcc -s compiler.version=%GCC_VERSION% -s compiler.libcxx=%LIB_STD%
IF %errorlevel% neq 0 EXIT /b %errorlevel%

SET "OUTPUT_DIR=%CURRENT_DIR%\..\output_gcc_%LIB_STD%"
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
