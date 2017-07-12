@ECHO off 

SET "CURRENT_PATH=%~dp0"

ECHO "Enter to startConanServer"
CALL conan remove -f GMock*
ECHO "Previous GMock was removed"

start conan_server
ECHO "1st Conan.io server run"
timeout 5 > NUL

CALL stopConanServer.bat
ECHO "1st Conan.io server stop"

COPY %CURRENT_PATH%\..\server.conf %HOMEPATH%\.conan_server\server.conf


start conan_server
ECHO "2nd Conan.io server run"
timeout 5 > NUL

CD %REPO_BASE_DIR%
CALL conan export iblis_ms/stable

SET FOUND_LOCAL_SERVER=
FOR /f %%a in ('conan remote list ^| findstr /i http://localhost:9300') DO (
    SET FOUND_LOCAL_SERVER=true
)

IF "%FOUND_LOCAL_SERVER%" == "" ( 
  CALL conan remote add local http://localhost:9300
) 

ECHO "Export package from %REPO_BASE_DIR%"

CALL conan user -p demo -r local demo
CALL conan upload GMock/1.8.0@iblis_ms/stable --all -r=local --force

CD %CURRENT_PATH%
