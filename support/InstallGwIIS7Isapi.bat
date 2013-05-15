@echo off

@echo %1 %2 %3

set theos=%3
@if not %theos%=="win08" goto ExitInstall

@set nret=0

@if NOT exist %Systemroot%\system32\inetsrv\appcmd.exe exit /b 1

if NOT exist   %Systemroot%\Microsoft.NET\Framework64\v3.5  goto  Normal
%Systemroot%\system32\inetsrv\appcmd set config /section:isapiCgiRestriction /[path='%1\Microsoft.NET\Framework64\v2.0.50727\aspnet_isapi.dll'].allowed:true
goto NextInstall
:Normal
if NOT exist   %Systemroot%\Microsoft.NET\Framework\v3.5  goto  FailedInstall
%Systemroot%\system32\inetsrv\appcmd set config /section:isapiCgiRestriction /[path='%1\Microsoft.NET\Framework\v2.0.50727\aspnet_isapi.dll'].allowed:true

:NextInstall
@if %errorlevel% == 0 (
@echo Succeed to allow asp 2.0
)else (
@echo Failed to allow asp 2.0
)

:ExitInstall
@exit /b 0

:FailedInstall
@echo Failed to allow asp 2.0
@exit /b -1