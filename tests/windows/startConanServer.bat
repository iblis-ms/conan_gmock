@ECHO off 

SET "CURRENT_PATH=%~dp0"

CD %REPO_BASE_DIR%
start conan_server
timeout 10 > NUL

CD %CURRENT_PATH%
CALL stopConanServer.bat

IF EXIST "%HOME%\.conan\data\GMock" RD /q /s "%HOME%\.conan\data\GMock"

IF EXIST "%HOME%\.conan_server\data\GMock" RD /q /s "%HOME%\.conan_server\data\GMock"

CD %REPO_BASE_DIR%
start conan_server

COPY %CURRENT_PATH%\..\server.conf %HOMEPATH%\.conan_server\server.conf
CALL conan export . GMock/1.8.0@iblis_ms/stable

SET FOUND_LOCAL_SERVER=
FOR /f %%a in ('conan remote list ^| findstr /i http://localhost:9300') DO (
    SET FOUND_LOCAL_SERVER=true
)

IF "%FOUND_LOCAL_SERVER%"=="" ( 
  CALL conan remote add local http://localhost:9300
) 

CALL conan user -p demo -r local demo
CALL conan upload GMock/1.8.0@iblis_ms/stable --all -r=local --force

CD %CURRENT_PATH%
