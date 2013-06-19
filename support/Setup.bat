
@echo off

set "SiteName=Default Web Site"

set "flag=%~1"
set "SiteName=%~2"
set "workspace=%~3"
set "installdir=%~4"
set "DBName=%~5"
set "AppPool=%~6"
set "Vdir=%~7"
set "Log=%~8"

echo %Log%>netbrainlogfile

::@if "%flag%" == "" goto showhelp
::@if "%workspace%" == "" goto showhelp
::@if "%installdir%" == "" goto showhelp

::@set installdir=%~2
::@set DBname=%~3
::@set AppPool=%~4
::@set Vdir=%~5

::set flag=-install
::set workspace=test
::set installdir=C:\tester
::set DBname=test
::set AppPool=test
::set Vdir=test

::if  exist "%CommonProgramFiles%\WPS.xml" (
:: set xmlfile=%CommonProgramFiles%\WPS.xml
::) else if exist "%CommonProgramFiles(x86)%\WPS.xml" (
:: set xmlfile=%CommonProgramFiles(x86)%\WPS.xml
::) else (
:: echo "xmlfile does not exist"
::)

::if exist "%xmlfile%.ini" del /f /q "%xmlfile%.ini"

::ES5WpsTool.exe -m noguiGoc -n "%workspace%" -g id1 -l "%installdir%" -x %xmlfile% -t "%xmlfile%.ini"


::WPSUtil.exe -m gorc -n "%workspace%" -s "%installdir%" -xl %xmlfile% -tf "%xmlfile%.ini"

::@for /f "usebackq tokens=1,2 delims==" %%i in ("%info%") do set %%i=%%j

::set DBName=%DBName%
::set AppPool=%IISAppPool%
::set installdir=%Location%
::set Vdir=%VirtualDir%

::@if "%flag%" == "" goto showhelp
::@if "%installdir%" == "" goto showhelp
::@if "%DBname%" == "" goto showhelp
::@if "%AppPool%" == "" goto showhelp
::@if "%Vdir%" == "" goto showhelp


::set StepLogFile=Process.log

::set zipsourcefile=WebServer.zip
::call :getfullpath "%zipsourcefile%"
::set /p zipsourcefile=<pathtmp
::del /f /q pathtmp

set DisableFolderList=
set Server=127.0.0.1
set SiteIndex=1
set pghost=127.0.0.1


:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: 		Get DB info from Reg
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
set "rPath=HKEY_LOCAL_MACHINE\SOFTWARE\netbrain"

call :get_value_from_reg "%rPath%" "EAPPostgresDataPort"                                                                                                
if %errorlevel% == 0 (
set /p pgport=<valuetemp
del /f /q valuetemp
) else (
echo can not get pgport from reg. 
exit /b 1
)

call :get_value_from_reg "%rPath%" "EAPPostgresDataUserName"
if %errorlevel% == 0  (
set /p pguser=<valuetemp
del /f /q valuetemp
) else (
echo can not get pguser from reg. 
exit /b 1
)

call :get_value_from_reg "%rPath%" "EAPPostgresDataPwd"
if %errorlevel% == 0  (
set /p pgpwd=<valuetemp
del /f /q valuetemp
) else (
echo can not get pgpwd from reg. 
exit /b 1
)
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::            end of  get conf files from webserver
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::             get conf files from webserver
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::if not %installdir:~-1,1% == "\" (
::set confile=%installdir%\WebServer\conf\fix_Graphics.ini
::) else (
::set confile=%installdir%WebServer\conf\fix_Graphics.ini
::)
::if not %installdir:~-1,1% == "\" (
::set confile1=%installdir%\WebServer\web.config
::) else (
::set confile1=%installdir%WebServer\web.config
::)


::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::            end of get conf files from webserver
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::



::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::                    installation
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
if not "%flag%" == "-install" goto uninstall

::echo 1. copy files to install dir >> %StepLogFile%
::mkdir "%installdir%"
:: if not exist "%testpath%" (
::cscript unzip.vbs "%zipsourcefile%" "%installdir%"
::)

::echo Buildpgdb for workspace server >> %StepLogFile%
::echo Create DB "%DBname%" for workspace server >>"%Log%"
::echo Buildpgdb for workspace >>&3
call WritESLog.bat  Create database for workspace
call Buildpgdb4wsp.bat "%pghost%" "%pgport%" "%DBname%" "%pguser%" "%pgpwd%"  1>nul
call WritESLog.bat Succeed in building Postgres database 

::echo 3. Process Conf files >> %StepLogFile%
::call WritESLog.bat Process some files for web server 
::call ProcessConfile.bat "%confile%" "%pghost%" "%pgport%" "%DBname%" "%pguser%" "%pgpwd%" "%confile1%"
::call WritESLog.bat Succeed Process Conf files 

::echo 3. Install Users >> %StepLogFile%
call WritESLog.bat Add user privilege to installation folder  
call InstallUser.bat "%installdir%" 
if Not %ERRORLEVEL% == 0 (
echo "Failed in adding user privilege to installation folder! "
exit /b 1
)
call WritESLog.bat Succeed in adding user privilege to installation folder

::echo 4. Install workspace server >> %StepLogFile%
call WritESLog.bat Install web server... 
call InstallGW.bat "%SiteIndex%" "%SiteName%" "%AppPool%" "%Vdir%" "%installdir%\WebServer" "%DisableFolderList%"  "Workspace"
if Not %ERRORLEVEL% == 0 (
echo Failed in installing web server
exit /b 1
)
call WritESLog.bat Succeed in installing web server 

::call WritESLog.bat Clear IE cache...
::call CleanIECache.bat
::call WritESLog.bat Clear IE cache is done.


::WPSUtil.exe -m set -n "%workspace%" -s "%installdir%" -xl info.xml -tf info.ini

goto :EOF
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::                 end of installation
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::




:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::                 begin of Uninstall
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:uninstall
if not "%flag%" == "-Uninstall"  goto :EOF
::call WritESLog.bat UnInstall web server... 
call EAPUninstall.bat "%Server%" "%SiteIndex%" "%SiteName%" "%AppPool%" "%Vdir%"  "Workspace"
::call WritESLog.bat UnInstall web server done
goto :EOF
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::                 end of Uninstall
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::




:::::::::::::::::::::::::::::::::::::::::::::::::::
::  function get_value_from_reg
:::::::::::::::::::::::::::::::::::::::::::::::::::
:get_value_from_reg
set reg_path=%~1
set reg_KeyName=%~2

reg query %reg_path% /v %reg_KeyName% | find "%reg_KeyName%" >temp
if not %errorlevel% == 0 exit /b 1

for /f "usebackq tokens=3 delims= " %%i in ("temp") do set value=%%i
if not %errorlevel% == 0 exit /b 1
del /f /q temp

echo %value%>valuetemp
goto :EOF

:::::::::::::::::::::::::::::::::::::::::::::::::::
::  function get_full_path
:::::::::::::::::::::::::::::::::::::::::::::::::::
:getfullpath 
echo %~f1 >pathtmp
goto :EOF

:::::::::::::::::::::::::::::::::::::::::::::::::::
::  function show help
:::::::::::::::::::::::::::::::::::::::::::::::::::
:showhelp
@echo Useage: program (-install/-Uninstall) "Workspacename" 
@goto :EOF
