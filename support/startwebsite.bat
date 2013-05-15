@echo off

set siteindex=%~1
set sitename=%~2

@set appcommand=%Systemroot%\system32\inetsrv\appcmd.exe
@set IISext=iisext.vbs
@set IISVdir=iisvdir.vbs
@set AspNet_IsApi=%Systemroot%\Microsoft.NET\Framework\v2.0.50727\aspnet_isapi.dll
@set AspNet_RegIIS=%Systemroot%\Microsoft.NET\Framework\v2.0.50727\aspnet_regiis.exe
@set App-Pool=app-pool.vbs
@set IIS6DisableDir=IIS6DisableDir.vbs
@set Adsutil=adsutil.vbs
@set Framework64=%Systemroot%\Microsoft.NET\Framework64\v3.5
@set Framework=%Systemroot%\Microsoft.NET\Framework\v3.5



::IF exist IIS 6.0 
(reg query HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\InetStp  /f "Version 6" /d) && (reg query HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\InetStp  /f "IIS 6" /d) && goto IIS6
 
::IF exist IIS 7.0
(reg query HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\InetStp  /f "Version 7" /d) && (reg query HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\InetStp  /f "IIS 7" /d) && goto IIS7


::If there is no IIS server
@echo there is no IIS server found
@exit /b 1


:IIS6
cscript.exe %Adsutil% set w3svc/%SiteIndex%/MaxConnections 4294967295
@if %errorlevel% == 0 (
@echo Succeed to set max connections %errorlevel%
)else (
@echo Failed to set max connections %errorlevel%
)

cscript iisweb.vbs /start w3svc/%siteindex%
goto checkstatus

:IIS7
%appcommand% set site "%SiteName%" /limits.maxConnections:4294967295
@if %errorlevel% == 0 (
@echo Succeed to set default web site maxConnections %errorlevel%
)else (
@echo Failed to set default web site maxConnections %errorlevel%
)

"%appcommand%" start SITE "%sitename%"
goto checkstatus


:checkstatus
@if %errorlevel% == 0 (
@echo Succeed to start web site 
)else (
@echo Failed to start web site
@set nret=-1
)


