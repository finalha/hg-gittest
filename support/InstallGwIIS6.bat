
@echo off

@set "nret=0"
@set "SiteIndex=%~1"
@set "AppPool=%~2"
@set "Vdir=%~3"
@set "PhysicalPath=%~4"
@set "DisableFolderList=%~5"

@set VdirRoot=%~6


@set IISext=iisext.vbs
@set IISVdir=iisvdir.vbs
@set AspNet_IsApi=%Systemroot%\Microsoft.NET\Framework\v2.0.50727\aspnet_isapi.dll
@set AspNet_RegIIS=%Systemroot%\Microsoft.NET\Framework\v2.0.50727\aspnet_regiis.exe
@set App-Pool=app-pool.vbs
@set IIS6DisableDir=IIS6DisableDir.vbs
@set Adsutil=adsutil.vbs

::cscript.exe iisvdir.vbs /s 127.0.0.1 /delete w3svc/1/ROOT/netbrain
::@if %errorlevel% == 0 (
::@echo Succeed to remove old
::)else (
::@echo Failed to remove old
::)



if not "%VdirRoot%" == "" ( 


cscript.exe %IISVdir% /create W3SVC/%SiteIndex%/ROOT/%VdirRoot% "%Vdir%" "%PhysicalPath%"
@if %errorlevel% == 0 (
@echo Succeed to create virtual dir   "%Vdir%"  %errorlevel%
)else (
@echo Failed to create virtual dir    "%Vdir%"  %errorlevel%
@set nret=%errorlevel%
)



) else (

cscript.exe %IISVdir% /create W3SVC/%SiteIndex%/ROOT "%Vdir%" "%PhysicalPath%"
@if %errorlevel% == 0 (
@echo Succeed to create virtual dir   "%Vdir%"  %errorlevel%
)else (
@echo Failed to create virtual dir   "%Vdir%"   %errorlevel%
@set nret=%errorlevel%
)

%AspNet_RegIIS% -s W3SVC/%SiteIndex%/ROOT/%Vdir%
@if %errorlevel% == 0 (
@echo Succeed to assign asp2.0  to "%Vdir%"   %errorlevel%
)else (
@echo Failed to assign asp2.0   to "%Vdir%"  %errorlevel%
@set nret=%errorlevel%
)

if "%Vdir%" == "Workspaces" (
mkdir "%ALLUSERSPROFILE%\netbrain"
call InstallUser.bat  "%ALLUSERSPROFILE%\netbrain"
cscript.exe %IISVdir% /create W3SVC/%SiteIndex%/ROOT "Workspace" "%ALLUSERSPROFILE%\netbrain"
@if %errorlevel% == 0 (
@echo Succeed to create virtual dir Workspace   %errorlevel%
)else (
@echo Failed to create virtual dir  Workspace   %errorlevel%
@set nret=%errorlevel%
)

%AspNet_RegIIS% -s W3SVC/%SiteIndex%/ROOT/Workspace
@if %errorlevel% == 0 (
@echo  Succeed to assign asp2.0  to Workspace   %errorlevel%
)else (
@echo Failed to assign asp2.0   to Workspace   %errorlevel%
@set nret=%errorlevel%
)
)

)




cscript.exe %App-Pool% "%AppPool%" "%Vdir%"  %VdirRoot%
@if %errorlevel% == 0 (
@echo Succeed to build apppool    %errorlevel%
)else (
@echo Failed to build apppool     %errorlevel%
@set nret=%errorlevel%
)


::cscript.exe %Adsutil% start_server W3SVC/%SiteIndex%

::for %%i in (%DisableFolderList%) do cscript.exe %IIS6DisableDir% "%SiteIndex%" "%Vdir%" "%%~i"  "%VdirRoot%"


@exit /b %nret%
