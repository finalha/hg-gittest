set "DelAll1=%~1"
set "WorkSpace1=%~2"
set "TargetDir1=%~3"
set "Guid1=%~4"
set "DBName1=%~5"
set "AppPool1=%~6"
set "Vdir1=%~7"

set "selfpath=%~dp0"

set "logfilename=__ExeCmdWithLog__.log"
set "logfilepath=%selfpath%%logfilename%" 

set "PackageName=WorkSpace.exe"
set "PackagePath=%selfpath%%PackageName%" 

set "dropdbfile=dropdb.exe"
set "dropdbfilepath=%selfpath%%dropdbfile%" 

set "pgsqlfile=psql.exe"
set "pgsqlfilePath=%selfpath%%pgsqlfile%" 

set "sqlfile=KillPro.sql"
set "sqlfilePath=%selfpath%%sqlfile%" 

set "appcommand=%Systemroot%\system32\inetsrv\appcmd.exe"

(reg query HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\InetStp  /f "Version 7" /d) && (reg query HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\InetStp  /f "IIS 7" /d) && goto IIS7

goto NEXT

:IIS7

for /f usebackq^ tokens^=2^ delims^=^" %%i in (`%appcommand% list sites`) do set "SiteName=%%i" && goto NEXT

:NEXT


set "%WorkSpace1%"
set "%TargetDir1%"
set "%Guid1%"
set "%DBName1%" 
set "%AppPool1%"
set "%Vdir1%"


echo Now start the uninstall program. WorkSpace:%WorkSpace% >> "%logfilepath%"

if not "%DelAll1%" == "DelAll=Yes" goto DelWorkspace

reg query HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\NETBRAIN /v EAPPostgresDataPort >temp
if %errorlevel% == 0 goto SetDBport

reg query HKEY_LOCAL_MACHINE\SOFTWARE\NETBRAIN /v EAPPostgresDataPort >temp
if %errorlevel% == 0 goto SetDBport

:SetDBport
for /f "usebackq tokens=3 delims= " %%i in ("temp") do set "dbport=%%i"

if exist temp del /f /q temp
 

::IF exist IIS 6.0 
(reg query HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\InetStp  /f "Version 6" /d) && (reg query HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\InetStp  /f "IIS 6" /d) && (set IISver=6 & goto IIS6)
 
::IF exist IIS 7.0
(reg query HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\InetStp  /f "Version 7" /d) && (reg query HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\InetStp  /f "IIS 7" /d) && (set IISver=7 & goto IIS7)

:IIS6
echo Try to stop AppPool: %AppPool% >> "%logfilepath%"
@cscript.exe stop-app-pool.vbs "%AppPool%"  "test"
@if %errorlevel% == 0 (
@echo Succeed in stoping  AppPool: %AppPool% >> "%logfilepath%"
)else (
@echo Failed in stoping  AppPool: %AppPool% >> "%logfilepath%"
exit /b -1
)
goto next


:IIS7
echo Try to stop AppPool: %AppPool% >> "%logfilepath%"
%appcommand% stop apppool "%AppPool%"
@if %errorlevel% == 0 (
@echo Succeed in stoping  AppPool: %AppPool% >> "%logfilepath%"
)else (
@echo Failed in stoping  AppPool: %AppPool% >> "%logfilepath%"
exit /b -1
)


:next
echo Try to delete DB: %DBName% >> "%logfilepath%"


set DBNametmp='%DBName%'

"%pgsqlfilePath%" -h 127.0.0.1 -p %dbport% -U postgres -v nbwsp=%DBNametmp% <"%sqlfilePath%"

"%dropdbfilepath%" -h 127.0.0.1 -p %dbport% -U postgres %DBName% 
@if %errorlevel% == 0 (
@echo Succeed in deleteing DB: %DBName% >> "%logfilepath%"
)else (
@echo Failed in deleteing DB: %DBName% >> "%logfilepath%"

if %IISver% == 6 @cscript.exe start-app-pool.vbs "%AppPool%"  "test"

if %IISver% == 7 %appcommand% start apppool "%AppPool%"

exit /b -1
)

:DelWorkspace
@echo UnInstall web server...  >> "%logfilepath%"
"%PackagePath%" WorkSpace="%WorkSpace%";TargetDir="%TargetDir%";DBName="%DBName%";AppPool="%AppPool%";Vdir="%Vdir%";Log="%logfilepath%";WSsite="%SiteName%";%DelAll1%;Uninstall=Yes  /ig%GUID% /hide_splash /hide_usd /hide_progress  
::@echo Succeed in uninstalling web server...  >> "%logfilepath%"

echo Uninstall workspace successfully.  >> "%logfilepath%"
exit /b 0