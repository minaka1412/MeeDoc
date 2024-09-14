@echo off
setlocal enabledelayedexpansion

set TOOL_FILE_PATH=%~dp0tools\edit_html.py
set EDIT_FILE_PATH=build/web/index.html

cd %~dp0
call :main
exit

:BuildFlutter
(
    call flutter build web --release --web-renderer html --source-maps
    @REM call flutter build web
    exit /b
)

:EditHTML
(
    call python %TOOL_FILE_PATH% %EDIT_FILE_PATH%
    exit /b
)

:Deploy
(
    rmdir docs /s /q
    move build/web docs
    exit /b
)

:main
(
    call :BuildFlutter
    call :EditHTML
    call :Deploy
    exit /b
)
