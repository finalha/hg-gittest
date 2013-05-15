@echo off

@set Server=%~1
@set SiteIndex=%~2
@set SiteName=%~3
@set AppPool=%~4
@set Vdir=%~5
set Vdirroot=%~6


::IF exist IIS 6.0
(reg query HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\InetStp  /f "Version 6" /d) && (reg query HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\InetStp  /f "IIS 6" /d) && goto IIS6
 
::IF exist IIS 7.0
(reg query HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\InetStp  /f "Version 7" /d) && (reg query HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\InetStp  /f "IIS 7" /d) && goto IIS7


::If there is no IIS server
@echo there is no IIS server found
@exit /b 1

:IIS6
::call WritESLog.bat this is IIS 6 server
@call Removevrdir.bat "%Server%" "%SiteIndex%" "%AppPool%" "%Vdir%"  "%Vdirroot%"
goto checkstatus

:IIS7
::call WritESLog.bat this is IIS 7 server
@call RemovevrdirIis7.bat "%SiteName%" "%AppPool%" "%Vdir%"  "%Vdirroot%"
goto checkstatus


:checkstatus
@if %errorlevel% == 0 (
@echo Succeed to install web site 
)else (
@echo Failed to install web site
@set nret=-1
)

exit /b %nret%