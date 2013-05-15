
@echo off & setlocal Enabledelayedexpansion

@set WebPath=%~1
@set SystemPath=%~2

@set re=0

if "%WebPath%" == "" goto ProcessSystem

for /f "delims=" %%i in ('cscript.exe xcacls.vbs "%WebPath%"') do (
set tm=%%i
echo %%i|find "NETWORK SE" |find "Full Control">nul&&set baohan=true
if "!baohan!"=="true" goto nn
)

:nn
@echo ff & setlocal disabledelayedexpansion
@set retval=0
set full=false
echo %tm%|find "Full Control">nul&&set full=true

if "%full%"=="true" goto dd
if "%full%"=="false" goto hh

:hh
cscript.exe xcacls.vbs "%WebPath%" /E /T /G "NETWORK SERVICE":F
set retval=0
@if %errorlevel% == 0 (
@echo Succeed to grant the access rights of server path
)else (

@cacls "%WebPath%" /E /G "NETWORK SERVICE":F >>$.txt
for /f "delims=" %%i in ($.txt) do set a=%%i
del $.txt
@if "%a%" == "The Cacls command can be run only on disk drives that use the NTFS file system." (
@echo Failed to grant the access rights of lfile
set re=1
)

)


:dd

:ProcessSystem

if "%SystemPath%" == "" exit /b %re% 

cacls.exe "%SystemPath%" /E /G "NETWORK SERVICE":F
@if %errorlevel% == 0 (
@echo Succeed to grant the access rights of lfile
)else (

@cacls "%SystemPath%" /E /G "NETWORK SERVICE":F >>$.txt
for /f "delims=" %%i in ($.txt) do set a=%%i
del $.txt
@if "%a%" == "The Cacls command can be run only on disk drives that use the NTFS file system." (

@echo Failed to grant the access rights of lfile
set re=1
)

)

exit /b %re%