@echo off & setlocal Enabledelayedexpansion
set baohan=false
for /f "delims=" %%i in ('cacls %1') do (
set tm=%%i
echo %%i|find "\Users:">nul&&set baohan=true
if "!baohan!"=="true" goto nextcheck
)
if "!baohan!"=="false" goto next

:nextcheck
@echo on & setlocal disabledelayedexpansion
@echo %tm%
@set fullc=false
@if "%tm:~-2,1%"=="F" set fullc=true
@if "%fullc%"=="true" goto endline

:next
@echo on & setlocal disabledelayedexpansion

@echo %1 >> %2
::echo Users no right >>%2

:endline
@echo on & setlocal disabledelayedexpansion
