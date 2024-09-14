@echo off
setlocal enabledelayedexpansion

cd %~dp0
call :main
exit

:CreateSource
(
    call flutter gen-l10n
    exit /b
)

:main
(
    call :CreateSource
    exit /b
)
