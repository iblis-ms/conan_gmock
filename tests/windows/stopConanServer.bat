@ECHO off 

taskkill /F /fi "imagename eq python.exe"

for /f "tokens=2" %%a in (' tasklist /v  ^| findstr /i "conan_server_bat" ') do (
    taskkill /F /PID "%%a"
)

for /f "tokens=2" %%a in (' tasklist /v  ^| findstr /i "conan_server" ') do (
    taskkill /F /PID "%%a"
)

SET errorlevel=0