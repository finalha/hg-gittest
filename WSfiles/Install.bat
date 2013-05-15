@echo off

set "workspace1=%~1"
set "TargetDir1=%~2"
set "xmlfile1=%~3"
set "SiteName1=%~4"
set "DBName1=%~5"

set "%workspace1%"
set "%TargetDir1%"
set "%xmlfile1%"
set "%SiteName1%"


(reg query HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\InetStp  /f "Version 7" /d) && (reg query HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\InetStp  /f "IIS 7" /d) && goto IIS7

goto NEXT

:IIS7

for /f usebackq^ tokens^=2^ delims^=^" %%i in (`%Systemroot%\system32\inetsrv\appcmd.exe list sites`) do set "SiteName=%%i" && goto NEXT

:NEXT

echo workspace: %workspace%
echo TargetDir: %TargetDir%
echo xmlfile: %xmlfile%
echo SiteName: %SiteName%

set "selfpath=%~dp0"

set "logfilename=__ExeCmdWithLog__.log"
set "logfilepath=%selfpath%%logfilename%" 

set "Esproname=ES5WpsTool.exe"
set "EsproPath=%selfpath%%Esproname%" 

set "PackageName=WorkSpace.exe"
set "PackagePath=%selfpath%%PackageName%" 

set "replacefiletext=replacefiletext.vbs"
set "repfiletextpath=%selfpath%%replacefiletext%"

set "OEPath=%selfpath%OEpath"
set "NSPath=%selfpath%NSpath" 

set "inifilename=WPS.ini"
call :GetFolderPath "%xmlfile%" "xmlfilefolder" 
set "inifilepath=%xmlfilefolder%%inifilename%" 

set /p OEFilePath=<"%OEPath%"
set /p NSFilePath=<"%NSPath%"

call :StrTrim %OEFilePath% "OEFilePath"
call :StrTrim %NSFilePath% "NSFilePath"

"%EsproPath%" -m noguiGoc -n "%workspace%" -g id1 -l "%TargetDir%" -x "%xmlfile%" -t "%inifilepath%"
for /f "usebackq tokens=1 delims=" %%i in ("%inifilepath%") do set "%%i"
if not "%DBName1%" == "" set "%DBName1%" && "%repfiletextpath%" "%inifilepath%" "DBName=workspace1" "DBName=nbws" "%inifilepath%"

echo WorkSpace: %workspace%
echo GUID:      %GUID%
echo TargetDir: %Location%
echo DBName:    %DBName%
echo AppPool:   %IISAppPool%
echo Vdir:      %VirtualDir%
echo Log:       %logfilepath%
echo WSsite:    %SiteName%

echo Now start the install program. Workspace:%WorkSpace% >> "%logfilepath%"
"%PackagePath%" WorkSpace="%workspace%";TargetDir="%Location%";DBName="%DBName%";AppPool="%IISAppPool%";Vdir="%VirtualDir%";Log="%logfilepath%";OEfile=%OEFilePath%;NSfile=%NSFilePath%;WSsite="%SiteName%" /ig%GUID% /hide_progress /hide_splash /hide_usd
if not %errorlevel% == 0  (
if exist "%inifilepath%" del /f /q "%inifilepath%"
exit /b -1
)

echo Install new workspace successfully.  >> "%logfilepath%"
"%EsproPath%" -m noguiSet -n "%workspace%" -x "%xmlfile%" -t "%inifilepath%" 
if exist "%inifilepath%" del /f /q "%inifilepath%"
exit /b 0

goto :EOF
:::::::::::::::::::::::::::::::::::::::::::::::::::
::       function StrTrim
:::::::::::::::::::::::::::::::::::::::::::::::::::
:StrTrim
set "str=%~1"
set "var=%~2"

:lTrim
if "%str:~0,1%" == " " set "str=%str:~1%" && goto lTrim

:rTrim
if "%str:~-1%" == " " set "str=%str:~0,-1%" && goto rTrim

set "%var%=%str%"

goto :EOF

:::::::::::::::::::::::::::::::::::::::::::::::::::
::  function get_folder_path
:::::::::::::::::::::::::::::::::::::::::::::::::::
:GetFolderPath 
set "var=%~2"
set "%var%=%~dp1"
goto :EOF 
