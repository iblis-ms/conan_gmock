@ECHO off 
SETLOCAL EnableDelayedExpansion

ECHO "------------------ program tests ------------------"

SET "CURRENT_PATH=%~dp0"

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
                    
                    CALL runVisual.bat !GMOCK! !GTEST! !SHARED! !INCLUDE_MAIN! || exit /b 1
                    
                    CALL runGcc.bat !GMOCK! !GTEST! !SHARED! !INCLUDE_MAIN! libstdc++ || exit /b 1
                    
                    CALL runGcc.bat !GMOCK! !GTEST! !SHARED! !INCLUDE_MAIN! libstdc++11 || exit /b 1
                )
            )
        )
    )
)

CD %CURRENT_PATH%
