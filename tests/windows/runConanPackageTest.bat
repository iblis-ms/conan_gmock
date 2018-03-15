 

REM ########################## gcc ##########################

SET "CURRENT_DIR=%~dp0"
ECHO "------------------ package tests ------------------"

CD %REPO_BASE_DIR%


SET "CC=%GCC%"
SET "CXX=%GPP%"

ECHO "----------------------- test package: GCC %GCC_VERSION%: libstdc++ ----------------------- "
CALL conan test test_package -s compiler=gcc -s compiler.version=%GCC_VERSION% -s compiler.libcxx=libstdc++ GMock/1.8.0@iblis_ms/stable --build
IF %errorlevel% neq 0 EXIT /b %errorlevel%

ECHO "----------------------- test package: GCC %GCC_VERSION%: libstdc++11 ----------------------- "
CALL conan test test_package -s compiler=gcc -s compiler.version=%GCC_VERSION% -s compiler.libcxx=libstdc++11 GMock/1.8.0@iblis_ms/stable --build
IF %errorlevel% neq 0 EXIT /b %errorlevel%


REM ########################## visual ##########################

SET "CC=%VISUAL_STUDIO_COMPILER%"
SET "CXX=%VISUAL_STUDIO_COMPILER%"

ECHO "----------------------- test package: Visual Studio %VISUAL_STUDIO_VERSION% %VISUAL_STUDIO_YEAR%----------------------- "
CALL conan test test_package -s compiler="Visual Studio" -s compiler.version=%VISUAL_STUDIO_VERSION% -s compiler.runtime=MT GMock/1.8.0@iblis_ms/stable --build
IF %errorlevel% neq 0 EXIT /b %errorlevel%


CD %CURRENT_DIR%