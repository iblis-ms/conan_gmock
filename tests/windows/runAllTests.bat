@ECHO off 

SET "CURRENT_PATH=%~dp0"
SET "REPO_BASE_DIR=%CURRENT_PATH%\..\.."
SET GCC_VERSION_MAJOR=6
SET GCC_VERSION_MINOR=3
SET GCC_VERSION=%GCC_VERSION_MAJOR%.%GCC_VERSION_MINOR%
SET "CONAN_FOLDER_NAME=conanCode"
SET "CONAN_DIR=%CURRENT_PATH%\%CONAN_FOLDER_NAME%"

IF "%CI%"=="" (
  SET VISUAL_STUDIO_YEAR=2017
  SET VISUAL_STUDIO_VERSION=15
  SET "VISUAL_STUDIO_COMPILER_DIR=C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Tools\MSVC\14.10.25017\bin\HostX64\x64"
  
  SET "MINGW_DIR=C:\Program Files\mingw-w64\x86_64-6.3.0-posix-seh-rt_v5-rev2"
  
) ELSE (
  SET VISUAL_STUDIO_YEAR=2015
  SET VISUAL_STUDIO_VERSION=14
  SET "VISUAL_STUDIO_COMPILER_DIR=C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\bin\x86_amd64"
  
  SET "MINGW_DIR=C:\mingw-w64\x86_64-6.3.0-posix-seh-rt_v5-rev1"
  
  SET "PATH=C:\Program Files (x86)\CMake\bin"
)
SET "MINGW_BIN_DIR=%MINGW_DIR%\mingw64\bin"
SET "GCC=%MINGW_BIN_DIR%\gcc.exe"
SET "GPP=%MINGW_BIN_DIR%\g++.exe"
SET "VISUAL_STUDIO_COMPILER=%VISUAL_STUDIO_COMPILER_DIR%\cl.exe"

SET "PATH=%MINGW_BIN_DIR%;%VISUAL_STUDIO_COMPILER_DIR%;%CONAN_DIR%;C:\Python27;%PATH%;C:\Windows\System32"

CALL runConanPackageTest.bat
IF %errorlevel% neq 0 EXIT /b %errorlevel%

CALL runTestPrograms.bat
IF %errorlevel% neq 0 EXIT /b %errorlevel%

ECHO "Success"
