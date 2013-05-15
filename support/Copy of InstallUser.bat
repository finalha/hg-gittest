@echo off & setlocal Enabledelayedexpansion

set defaultRootDir=%1
set RootDir=%defaultRootDir:~1,-1%

set WebServerDir="%RootDir%\WebServer"
set ESDataDir="%RootDir%\ESData"

echo %WebServerDir%
echo %ESDataDir%



echo Add user Privilege to folder %WebServerDir% 
for /f "delims=" %%i in ('cscript.exe xcacls.vbs %ESDataDir%') do (
set tm=%%i
echo %%i|find "NETWORK SE" |find "Full Control">nul&&set baohan=true
if "!baohan!"=="true" goto nn0
)
:nn0
@echo on & setlocal disabledelayedexpansion
@set retval=0
set full=false
echo %tm%|find "Full Control">nul&&set full=true

if "%full%"=="true" goto dd0
if "%full%"=="false" goto hh0

:hh0
cscript.exe xcacls.vbs %ESDataDir% /E /T /G "NETWORK SERVICE":F
set retval=0
@if %errorlevel% == 0 (
@echo Succeed to grant the access rights of ESData path
)else (
@echo Failed to grant the access rights of ESData path
@set retval=-2
)
:dd0

for /f "delims=" %%i in ('cscript.exe xcacls.vbs %WebServerDir%') do (
set tm=%%i
echo %%i|find "NETWORK SE" |find "Full Control">nul&&set baohan=true
if "!baohan!"=="true" goto nn
)
:nn
@echo on & setlocal disabledelayedexpansion
@set retval=0
set full=false
echo %tm%|find "Full Control">nul&&set full=true

if "%full%"=="true" goto dd
if "%full%"=="false" goto hh

:hh
cscript.exe xcacls.vbs %WebServerDir% /E /T /G "NETWORK SERVICE":F
set retval=0
@if %errorlevel% == 0 (
@echo Succeed to grant the access rights of server path
)else (
@echo Failed to grant the access rights of server path
@set retval=-2
)
:dd


cacls.exe %Systemroot%\System32\netbrain_uap.ini /E /G "NETWORK SERVICE":F
@if %errorlevel% == 0 (
@echo Succeed to grant the access rights of lfile
)else (
@echo Failed to grant the access rights of lfile
@set retval=-1
)


cacls.exe %Systemroot%\System32\nbl /E /G "NETWORK SERVICE":F
@if %errorlevel% == 0 (
@echo Succeed to grant the access rights of lfile
)else (
@echo Failed to grant the access rights of lfile
@set retval=-1
)

cacls.exe %Systemroot%\System32\nbl\nb10002.ini /E /G "NETWORK SERVICE":F
@if %errorlevel% == 0 (
@echo Succeed to grant the access rights of lfile
)else (
@echo Failed to grant the access rights of lfile
@set retval=-1
)

cacls.exe %Systemroot%\System32\3201 /E /G "NETWORK SERVICE":F
@if %errorlevel% == 0 (
@echo Succeed to grant the access rights of lfile
)else (
@echo Failed to grant the access rights of lfile
@set retval=-1
)

cacls.exe %Systemroot%\System32\NBAppData.ini /E /G "NETWORK SERVICE":F
@if %errorlevel% == 0 (
@echo Succeed to grant the access rights of lfile
)else (
@echo Failed to grant the access rights of lfile
@set retval=-1
)

if %retval% == 0 (
@exit /b %retval%
)else (
goto labelfat32
)

:labelfat32
if %retval% == -2 goto labelfat32web
if %retval% == -1 goto labelfat32system

:labelfat32web
@cacls %1 /E /G "NETWORK SERVICE":F >>$.txt
for /f "delims=" %%i in ($.txt) do set a=%%i
del $.txt
@if "%a%" == "The Cacls command can be run only on disk drives that use the NTFS file system." (
@exit /b 0
)else (
@exit /b 1
)

:labelfat32system
@cacls %Systemroot%\System32\NBAppData.ini /E /G "NETWORK SERVICE":F >>$.txt
for /f "delims=" %%i in ($.txt) do set a=%%i
del $.txt
@if "%a%" == "The Cacls command can be run only on disk drives that use the NTFS file system." (
@exit /b 0
)else (
@exit /b 1
)