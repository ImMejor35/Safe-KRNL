@echo off
start mediaplayer.exe
set /p DUMMY=After closing KRNL press enter.
powershell Remove-Item '%localappdata%\krnlss' -Recurse
powershell Remove-Item '.\krnl\' -Recurse
