
@echo off

@set "SiteName=%~1"
@set "AppPoolname=%~2"
@set "Vdirname=%~3"
@set "PhysicalPath=%~4"
@set "DisableFolderList=%~5"

@set "Vdirroot=%~6"

@set "nret=0"
@set "appcommand=%Systemroot%\system32\inetsrv\appcmd.exe"
@set "Framework64=%Systemroot%\Microsoft.NET\Framework64\v3.5"
@set "Framework=%Systemroot%\Microsoft.NET\Framework\v3.5"

@if NOT exist %appcommand% (
	echo can not find %appcommand%
	exit /b 1
)

::%Systemroot%\system32\inetsrv\appcmd delete app "%SiteName%/netbrain"
::@if %errorlevel% == 0 (
::@echo Succeed to remove old
::)else (
::@echo Failed to remove old
::)

::net start "World Wide Web Publishing Service"

::%Systemroot%\system32\inetsrv\appcmd list apppool "%AppPoolname%"

::if %errorlevel% == 0 %Systemroot%\system32\inetsrv\appcmd delete apppool "%AppPoolname%"

%appcommand% add apppool /name:"%AppPoolname%" /managedRuntimeVersion:v2.0 /managedPipelineMode:Classic
@if %errorlevel% == 0 (
@echo Succeed to add apppool
)else (
@echo Failed to add apppool
@set nret=-1
)

%appcommand% set config /section:applicationPools /[name='%AppPoolname%'].processModel.idleTimeout:0.00:00:00
@if %errorlevel% == 0 (
@echo Succeed to set apppool idleTimeout
)else (
@echo Failed to set apppool idleTimeout
)

%appcommand% set config /section:applicationPools /[name='%AppPoolname%'].recycling.periodicRestart.time:0.00:00:00
@if %errorlevel% == 0 (
@echo Succeed to set apppool periodicRestart.time
)else (
@echo Failed to set apppool periodicRestart.time
)

%appcommand% set config /section:applicationPools /[name='%AppPoolname%'].queueLength:10000
@if %errorlevel% == 0 (
@echo Succeed to set apppool queueLength
)else (
@echo Failed to set apppool queueLength
)

%appcommand% set config /section:applicationPools /[name='%AppPoolname%'].processModel.identityType:NetworkService
@if %errorlevel% == 0 (
@echo Succeed to set apppool identityType
)else (
@echo Failed to set apppool identityType
)

::%Vdirroot%

if not "%Vdirroot%" == "" (

mkdir "%ALLUSERSPROFILE%\netbrain"
call InstallUser.bat  "%ALLUSERSPROFILE%\netbrain"
%appcommand% add vdir /app.name:"%SiteName%/" /path:/%Vdirroot%  /physicalPath:"%ALLUSERSPROFILE%\netbrain" 
@if %errorlevel% == 0 (
@echo Succeed to assignappPooltoweb
)else (
@echo Failed to assignappPooltoweb
@set nret=-1
)


%appcommand% add app /site.name:"%SiteName%" /path:/%Vdirroot%/%Vdirname%  /physicalPath:"%PhysicalPath%" /applicationPool:"%AppPoolname%"
@if %errorlevel% == 0 (
@echo Succeed to assignappPooltoweb
)else (
@echo Failed to assignappPooltoweb
@set nret=-1
)

%appcommand% set config "%SiteName%/%Vdirroot%/%Vdirname%" /section:httpErrors /errorMode:Detailed
@if %errorlevel% == 0 (
@echo Succeed to set httperror errormode detailed
)else (
@echo Failed to set httperror errormode detailed
)

) else (

%appcommand% add app /site.name:"%SiteName%" /path:/%Vdirname%  /physicalPath:"%PhysicalPath%" /applicationPool:"%AppPoolname%"
@if %errorlevel% == 0 (
@echo Succeed to assignappPooltoweb
)else (
@echo Failed to assignappPooltoweb
@set nret=-1
)

%appcommand% set config "%SiteName%/%Vdirname%" /section:httpErrors /errorMode:Detailed
@if %errorlevel% == 0 (
@echo Succeed to set httperror errormode detailed
)else (
@echo Failed to set httperror errormode detailed
)


)


@if NOT exist %Framework64%  goto  Normal
%appcommand% set apppool /apppool.name:"%AppPoolname%" /enable32BitAppOnWin64:true
goto NextInstall

:Normal
@if NOT exist %Framework%  goto  FailedInstall
%appcommand% set apppool /apppool.name:"%AppPoolname%" /enable32BitAppOnWin64:false


:NextInstall
@if %errorlevel% == 0 (
@echo Succeed to enable32BitAppOnWin64
)else (
@echo Failed to enable32BitAppOnWin64
)


::for %%i in (%DisableFolderList%) do call IIS7DisableDir.bat "%SiteName%" "%Vdirname%" "%%~i"



@exit /b %nret%

:FailedInstall

@exit /b -1