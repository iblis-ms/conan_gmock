@ECHO off 

SET "CONAN_FOLDER_NAME=conanCode"
SET "CURRENT_DIR=%~dp0"
SET "CONAN_DIR=%CURRENT_DIR%%CONAN_FOLDER_NAME%"

IF EXIST "%CONAN_DIR%" RD /q /s "%CONAN_DIR%"
git clone https://github.com/conan-io/conan.git "%CONAN_FOLDER_NAME%"
CD %CONAN_DIR%
git checkout tags/0.24.0
pip install -r %CONAN_DIR%\conans\requirements.txt
pip install -r %CONAN_DIR%\conans\requirements_server.txt
pip install -r %CONAN_DIR%\conans\requirements_dev.txt

ECHO "COPY %CURRENT_DIR%\conan.bat %CONAN_DIR%\conan.bat"
COPY %CURRENT_DIR%\conanResources\conan.bat %CONAN_DIR%\conan.bat
COPY %CURRENT_DIR%\conanResources\conan.py %CONAN_DIR%\conan.py
COPY %CURRENT_DIR%\conanResources\conan_server.bat %CONAN_DIR%\conan_server.bat
COPY %CURRENT_DIR%\conanResources\conan_server.py %CONAN_DIR%\conan_server.py

SET "PATH=%CONAN_DIR%;%PATH%"

CD "%CURRENT_DIR%"