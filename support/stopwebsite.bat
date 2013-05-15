
@echo off

set siteindex=%~1
set sitename=%~2

set appcommand=%Systemroot%\system32\inetsrv\appcmd.exe

::IF exist IIS 6.0 
(reg query HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\InetStp  /f "Version 6" /d) && (reg query HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\InetStp  /f "IIS 6" /d) && goto IIS6
 
::IF exist IIS 7.0
(reg query HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\InetStp  /f "Version 7" /d) && (reg query HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\InetStp  /f "IIS 7" /d) && goto IIS7


::If there is no IIS server
@echo there is no IIS server found
@exit /b 1

:IIS6
net start "W3SVC"
@if %errorlevel% == 0 (
@echo Succeed to start World Wide Web service
)else (
@echo Failed to start World Wide Web service %errorlevel%
)
cscript iisweb.vbs /stop w3svc/%siteindex%
@if %errorlevel% == 0 (
@echo Succeed to stop SITE "%sitename%"
)else (
@echo Failed to stop SITE "%sitename%" %errorlevel%
)
goto checkstatus

:IIS7
net start "World Wide Web Publishing Service"
@if %errorlevel% == 0 (
@echo Succeed to start World Wide Web service
)else (
@echo Failed to start World Wide Web service %errorlevel%
)
"%appcommand%" stop SITE "%sitename%"
@if %errorlevel% == 0 (
@echo Succeed to stop SITE "%sitename%"
)else (
@echo Failed to stop SITE "%sitename%"  %errorlevel%
)
goto checkstatus


:checkstatus
@if %errorlevel% == 0 (
@echo Succeed to stop web site 
)else (
@echo Failed to stop web site
@set nret=-1
)