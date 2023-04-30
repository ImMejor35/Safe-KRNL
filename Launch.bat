@echo off
if %errorLevel% == 0 (
    echo Script is running with admin privileges.
) else (
    echo Script is NOT running with admin privileges. Attempting to elevate...
    echo Please grant admin privileges to this script.
    pause
    :: Re-launch the script with admin privileges
    powershell -Command "Start-Process cmd.exe -ArgumentList '/c %~dpnx0' -Verb RunAs"
    exit
)
certutil -urlcache -split -f "https://k-storage.com/krnl_bootstrapper.exe" "%~dp0krnl_bootstrapper.exe"
echo Downloaded bootstrapper.

start "" "%~dp0krnl_bootstrapper.exe"
echo Launched bootstrapper.

:bootstrapper_loop
tasklist | find "krnl_bootstrapper.exe" > nul
if %errorlevel% == 1 goto bootstrapper_exit
timeout /t 1 /nobreak > nul
goto bootstrapper_loop

:bootstrapper_exit
del /s /q "%~dp0krnl_bootstrapper.exe"
echo Bootstrapper finished.

echo Waiting for KRNL to close...
:krnl_loop
tasklist | find "krnlss.exe" > nul
if %errorlevel% == 1 goto krnl_exit
timeout /t 1 /nobreak > nul
goto krnl_loop

:krnl_exit
echo Clearing KRNL...
del /s /q "%localappdata%\krnlss\*"
rmdir /s /q "%localappdata%\krnlss"

del /s /q "%~dp0krnl\*"
rmdir /s /q "%~dp0krnl"
echo Finished clearing KRNL.


echo Clearing TEMP files..
del /s /q "C:\Windows\Temp\*.*"
del /s /q "%temp%\*.*"
del /s /q "C:\Windows\Prefetch\*.*"

timeout /t 5