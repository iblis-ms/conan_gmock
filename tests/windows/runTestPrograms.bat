@ECHO off 
SETLOCAL EnableDelayedExpansion

ECHO "------------------ program tests ------------------"

SET "CURRENT_PATH=%~dp0"

CALL startConanServer.bat
IF %errorlevel% neq 0 EXIT /b %errorlevel%

FOR %%m IN (True False) DO (
    SET "GMOCK=%%m"
    FOR %%t IN (True False) DO (
        SET "GTEST=%%t"
        FOR %%s IN (True False) DO (
            SET "SHARED=%%s"
            
            SET "RUN=False"
            IF "!GTEST!" == "True" (
                SET "RUN=True"
            )
            IF "!GMOCK!" == "True" (
                SET "RUN=True"
            )
            
            IF "!RUN!" == "True" (
                FOR %%a IN (True False) DO (
                    SET "INCLUDE_MAIN=%%a"
                    ECHO "GMOCK=!GMOCK! GTEST=!GTEST! SHARED=!SHARED! INCLUDE_MAIN=!INCLUDE_MAIN!"
                    
                    ECHO "--------------------------------------------"
                    ECHO "-------------------- compiler: Visual Studio"
                    REM echo "-------------------- stdlib: ${stdlib}"
                    ECHO "-------------------- gmock: !GMOCK!"
                    ECHO "-------------------- gtest: !GTEST!
                    ECHO "-------------------- shared: !SHARED!"
                    ECHO "-------------------- include_main: !INCLUDE_MAIN!"
                    
                    CALL runVisual.bat !GMOCK! !GTEST! !SHARED! !INCLUDE_MAIN!
                    IF %errorlevel% neq 0 EXIT /b %errorlevel%
                    REM CALL runGcc.bat !GMOCK! !GTEST! !SHARED! !INCLUDE_MAIN! libstdc++
                    REM IF %errorlevel% neq 0 EXIT /b %errorlevel%
                    REM CALL runGcc.bat !GMOCK! !GTEST! !SHARED! !INCLUDE_MAIN! libstdc++11
                    REM IF %errorlevel% neq 0 EXIT /b %errorlevel%
                )
            )
            
        )
    )
)

CALL stopConanServer.bat
IF %errorlevel% neq 0 EXIT /b %errorlevel%

CD %CURRENT_PATH%
