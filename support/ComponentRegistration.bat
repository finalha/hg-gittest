@echo off

@set appcommand=%Systemroot%\system32\inetsrv\appcmd.exe
@set IISext=iisext.vbs
@set AspNet_IsApi=%Systemroot%\Microsoft.NET\Framework\v2.0.50727\aspnet_isapi.dll


if exist %Systemroot%\system32\cmdlib.wsc (
  set cmdlib=%Systemroot%\system32\cmdlib.wsc
  goto regcmdlib
)
if exist %Systemroot%\SysWOW64\cmdlib.wsc (
  set cmdlib=%Systemroot%\SysWOW64\cmdlib.wsc
  goto regcmdlib
)

echo Error: Can not find cmdlib.wsc from %Systemroot%

:regcmdlib
regsvr32 /s %cmdlib%
@if %errorlevel% == 0 (
@echo Succeed to regsvr32 cmdlib.wsc
)else (
@echo Failed to regsvr32 cmdlib.wsc
)

if exist %Systemroot%\system32\IIsScHlp.wsc (
  set IIsScHlp=%Systemroot%\system32\IIsScHlp.wsc
  goto regIISScHlp
)
if exist %Systemroot%\SysWOW64\IIsScHlp.wsc (
  set IIsScHlp=%Systemroot%\SysWOW64\IIsScHlp.wsc
  goto regIISScHlp
)

echo Error: Can not find IIsScHlp.wsc from %Systemroot%

:regIISScHlp
regsvr32 /s %IIsScHlp%
@if %errorlevel% == 0 (
@echo Succeed to regsvr32 IIsScHlp.wsc 
)else (
@echo Failed to regsvr32 IIsScHlp.wsc
)




RegAspStateStartKey.exe

sc config aspnet_state start= auto

RegCLSIDNetworkService.exe


::IF exist IIS 6.0 
(reg query HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\InetStp  /f "Version 6" /d) && (reg query HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\InetStp  /f "IIS 6" /d) && goto IIS6
 
::IF exist IIS 7.0
(reg query HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\InetStp  /f "Version 7" /d) && (reg query HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\InetStp  /f "IIS 7" /d) && goto IIS7

::IF exist IIS 8.0
(reg query HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\InetStp  /f "Version 8" /d) && (reg query HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\InetStp  /f "IIS 8" /d) && goto IIS7


::If there is no IIS server
@echo there is no IIS server found
@exit /b 1

:IIS6
@call InstalldotnetFramework3.5.bat 
@if %errorlevel% == 0 (
@echo Succeed to InstalldotnetFramework3.5 
)else (
@echo Failed to InstalldotnetFramework3.5
@set nret=-1
)

cscript.exe %IISext% /EnFile %AspNet_IsApi%
@if %errorlevel% == 0 (
@echo Succeed to allow asp 2.0
)else (
@echo Failed to allow asp 2.0
@set nret=-1
)

::goto :EOF

:IIS7



::goto :EOF

net start "ASP.NET State Service"
@if %errorlevel% == 0 (
@echo Succeed to start ASP.NET State Service 
)else (
@echo Failed to start ASP.NET State Service
)