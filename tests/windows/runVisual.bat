@echo OFF

setlocal EnableDelayedExpansion


ECHO "------------------ test program: Visual Studio %VISUAL_STUDIO_VERSION%  ------------------"

SET "CURRENT_DIR=%~dp0"
SET "APP_DIR=%CURRENT_DIR%\..\app"

CD %APP_DIR%
CALL conan install --build -s compiler="Visual Studio" -s compiler.version=%VISUAL_STUDIO_VERSION% -s compiler.runtime=MT
IF %errorlevel% neq 0 EXIT /b %errorlevel%

SET "OUTPUT_DIR=%CURRENT_DIR%\..\output_visual%"
IF EXIST "%OUTPUT_DIR%" RD /q /s "%OUTPUT_DIR%"

MKDIR %OUTPUT_DIR%
CD %OUTPUT_DIR%

SET "CC=%VISUAL_STUDIO_COMPILER%"
SET "CXX=%VISUAL_STUDIO_COMPILER%"

cmake -G "Visual Studio %VISUAL_STUDIO_VERSION% %VISUAL_STUDIO_YEAR% Win64" -DCMAKE_BUILD_TYPE=Release %APP_DIR% 
IF %errorlevel% neq 0 EXIT /b %errorlevel%

cmake --build .
IF %errorlevel% neq 0 EXIT /b %errorlevel%

CD %OUTPUT_DIR%\bin
GMockTestProgram
IF %errorlevel% neq 0 EXIT /b %errorlevel%

CD %CURRENT_DIR%
