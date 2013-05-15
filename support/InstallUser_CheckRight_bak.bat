@echo off & setlocal Enabledelayedexpansion
for /f "delims=" %%i in ('cscript.exe xcacls.vbs %1') do (
set tm=%%i
echo %%i|find "NETWORK SE" |find "Full Control">nul&&set baohan=true
if "!baohan!"=="true" goto nn
)
:nn
@echo on & setlocal disabledelayedexpansion
set full=false
echo %tm%|find "Full Control">nul&&set full=true

if "%full%"=="true" goto dd
if "%full%"=="false" goto hh

@set retval=0

:hh
@cscript.exe xcacls.vbs %1 /E /T /G "NETWORK SERVICE":F
@set retval=0
@if %errorlevel% == 0 (
@echo Succeed to grant the access rights of server path
)else (
@echo Failed to grant the access rights of server path
@set retval=-2
)
:dd

@cacls.exe %Systemroot%\System32\netbrain_uap.ini /E /G "NETWORK SERVICE":F
@if %errorlevel% == 0 (
@echo Succeed to grant the access rights of lfile
)else (
@echo Failed to grant the access rights of lfile
@set retval=-1
)


@cacls.exe %Systemroot%\System32\nbl /E /G "NETWORK SERVICE":F
@if %errorlevel% == 0 (
@echo Succeed to grant the access rights of lfile
)else (
@echo Failed to grant the access rights of lfile
@set retval=-1
)

@cacls.exe %Systemroot%\System32\nbl\nb10002.ini /E /G "NETWORK SERVICE":F
@if %errorlevel% == 0 (
@echo Succeed to grant the access rights of lfile
)else (
@echo Failed to grant the access rights of lfile
@set retval=-1
)

@cacls.exe %Systemroot%\System32\3201 /E /G "NETWORK SERVICE":F
@if %errorlevel% == 0 (
@echo Succeed to grant the access rights of lfile
)else (
@echo Failed to grant the access rights of lfile
@set retval=-1
)


@exit /b %retval%
