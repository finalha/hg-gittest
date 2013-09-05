


@echo off

@set SiteIndex=%~1
@set SiteName=%~2
@set AppPool=%~3
@set Vdir=%~4
@set PhysicalPath=%~5
@set DisableFolderList=%~6
@set Vdirroot=%~7

@set nret=0

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
echo This is IIS6 server ...>>&3
@call InstallGwIIS6.bat "%SiteIndex%" "%AppPool%" "%Vdir%" "%PhysicalPath%" "%DisableFolderList%" "%Vdirroot%"
goto checkstatus

:IIS7
echo This is IIS7 server ...>>&3
@call InstallGwIIS7.bat "%SiteName%" "%AppPool%" "%Vdir%" "%PhysicalPath%" "%DisableFolderList%"  "%Vdirroot%"
goto checkstatus


:checkstatus
@if %errorlevel% == 0 (
@echo Succeed to install web site 
)else (
@echo Failed to install web site
@set nret=-1
)


net start "ASP.NET State Service"

@if %errorlevel% == 0 (
@echo Succeed to start ASP.NET State Service 
)else (
@echo Failed to start ASP.NET State Service
)


::for /f "delims=" %%i in ('dir "%temp%" /B /O-D "ASPNETSetup_*.log"') do (
:: set asplog=%temp%\%%~nxi
:: goto copyaspnetreglog 
::)

::copyaspnetreglog
::copy "%asplog%" "%windir%\..\nbesinstall_netreg.log" /y

@exit /b %nret%
