@ECHO off 

ECHO "------------------ program tests ------------------"

SET "CURRENT_PATH=%~dp0"

CALL startConanServer.bat
IF %errorlevel% neq 0 EXIT /b %errorlevel%


CALL runVisual.bat 

CALL stopConanServer.bat
IF %errorlevel% neq 0 EXIT /b %errorlevel%

CD %CURRENT_PATH%
