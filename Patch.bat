@echo off
color fc
setlocal enabledelayedexpansion

:: Check for administrative permissions
echo Checking for administrative privileges...
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] Administrative permissions required! Run this script as Administrator.
    pause >nul
    exit /b 1
)

cls
echo [INFO] Administrative permissions confirmed.
title ZOMBIU Patcher pdm[Patcher]

:: Ask for ZOMBIU installation directory
echo.
echo Example: C:\Program Files (x86)\Steam\steamapps\common\ZOMBI
echo Example: D:\steamapps\common\ZOMBI
set /p M=Enter your ZOMBIU Install Directory: 

:: Check if directory exists
if not exist "%M%" (
    echo [ERROR] Directory "%M%" does not exist! Please check your path.
    pause
    exit /b 1
)

:: Apply firewall rules and log results
echo.
echo [INFO] Applying firewall rules...

for %%F in (r1.exe ZOMBI.exe) do (
    netsh advfirewall firewall add rule name="ZOMBI_Patcher" dir=out program="%M%\%%F" profile=any action=block >nul 2>&1
    if !errorlevel! neq 0 (
        echo [ERROR] Failed to block outgoing traffic for %%F
    ) else (
        echo [SUCCESS] Blocked outgoing traffic for %%F
    )

    netsh advfirewall firewall add rule name="ZOMBI_Patcher" dir=in program="%M%\%%F" profile=any action=block >nul 2>&1
    if !errorlevel! neq 0 (
        echo [ERROR] Failed to block incoming traffic for %%F
    ) else (
        echo [SUCCESS] Blocked incoming traffic for %%F
    )
)

echo.
echo [INFO] Patching complete.
pause
exit /b 0
