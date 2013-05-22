@echo off

set "pghost=%~1"
set "pgport=%~2"
set "dbname=%~3"
set "pguser=%~4"
set "pgpwd=%~5"

set "selfpath=%~dp0"

set "pgauthfile=pgauth.exe"
set "pgauthfile=%selfpath%%pgauthfile%"

set "pgsqlfile=psql.exe"
set "pgsqlfile=%selfpath%%pgsqlfile%"

set "ReplaceProc=replacefiletext.vbs"
set "ReplaceProc=%selfpath%%ReplaceProc%"

call WritESLog.bat Try to process Postgres auth 
"%pgauthfile%" -pwd "%pgpwd%" -h "%pghost%" -p "%pgport%" -U "%pguser%"
if NOT %ERRORLEVEL% == 0 ( 
echo "Failed to process postgres auth"
call WritESLog.bat Failed in processing Postgres auth
exit /b 1
)
call WritESLog.bat Succeed in processing Postgres auth

call WritESLog.bat Please wait a moment...
cscript.exe sleep.vbs 30000

call WritESLog.bat Try to connect to DB: postgres
"%pgsqlfile%" -h "%pghost%" -p %pgport% -q -U "%pguser%" < testconn.sql
if NOT %ERRORLEVEL% == 0 ( 
echo "Failed to connect postgres"
call WritESLog.bat Failed in connecting DB: postgres
exit /b 1
)
call WritESLog.bat Succeed in connecting to DB: postgres

"%pgsqlfile%" -h "%pghost%" -p %pgport% -U "%pguser%" -q -t -v nbws='%dbname%'< Findpgdb.sql > sqltmp.txt
if NOT %ERRORLEVEL% == 0 ( 
echo "Error ocurr when finding %dbname%"
exit /b 1
)

findstr "%dbname%" sqltmp.txt
if NOT %ERRORLEVEL% == 0 ( 
echo "There is no DB: %dbname%" >&2
goto createdb
) 


set /p dbnametmp=<sqltmp.txt
echo dbname: "%dbname%" >&2
echo dbnametmp: "%dbnametmp%"  >&2
call :StrTrim "%dbnametmp%" "dbnametmp"
if exist sqltmp.txt del sqltmp.txt

set dbver=0

if not "%dbnametmp%" == "%dbname%"  (
  goto createdb
) else (
  call WritESLog.bat We will use the old DB: %dbname%  
  goto updatedb
)

:createdb
call WritESLog.bat Now create DB: %dbname%
call WritESLog.bat Please wait a moment... 
"%pgsqlfile%" -h "%pghost%" -p %pgport% -U "%pguser%" -v nbwsp=%dbname%< nbwsp.sql

:updatedb

"%pgsqlfile%" -h "%pghost%" -p %pgport% -U "%pguser%" -q -t -v nbwsp=%dbname%< Retrivever.sql > sqltmp.txt
FOR /F "eol= tokens=1,2 delims= " %%i in (sqltmp.txt) do set "dbver=%%i"
if exist sqltmp.txt del sqltmp.txt
echo dbver: %dbver% >&2 

if not "%dbnametmp%" == "nbws" goto next
if exist "%windir%\SysWOW64\NetBrain\Common\CLIC.xml" (
 set "xmlfile=%windir%\SysWOW64\NetBrain\Common\CLIC.xml"
) else if exist "%windir%\System32\NetBrain\Common\CLIC.xml" (
 set "xmlfile=%windir%\System32\NetBrain\Common\CLIC.xml"
) else (
 echo "Error: CLIC.xml file missing"
 exit /b 6
)

findstr "^.*<GUID>.*</GUID>$" "%xmlfile%" > guidlist

for /f "usebackq delims=" %%i in ("guidlist") do (
set "tempstr=%%i"
)
set "tempstr=%tempstr:<GUID>=%"
set "tempstr=%tempstr:</GUID>=%"
set "tempstr=%tempstr: =%"
set "tempstr=%tempstr:	=%"

set "LICGuid=%tempstr%"

echo License GUID: %LICGuid%

if exist guidlist del /f /q guidlist
cscript "%ReplaceProc%" step1.sql :licguid '%LICGuid%' step1.sql
"%pgsqlfile%" -h "%pghost%" -p %pgport% -U "%pguser%" < step1.sql
"%pgsqlfile%" -h "%pghost%" -p %pgport% -U "%pguser%" -v licguid='%LICGuid%'< step2-devicegroup.sql
"%pgsqlfile%" -h "%pghost%" -p %pgport% -U "%pguser%" -v licguid='%LICGuid%'< step3-linkgroup.sql
"%pgsqlfile%" -h "%pghost%" -p %pgport% -U "%pguser%" -v licguid='%LICGuid%'< step4.sql
"%pgsqlfile%" -h "%pghost%" -p %pgport% -U "%pguser%" -v licguid='%LICGuid%'< step5.sql

goto :EOF

:next
if %dbver% LSS 420 (
"%pgsqlfile%" -h "%pghost%" -p %pgport% -U "%pguser%" -v nbwsp=%dbname%< nbwsp420.sql
)

if %dbver% LSS 500 (
"%pgsqlfile%" -h "%pghost%" -p %pgport% -U "%pguser%" -v nbwsp=%dbname%< nbwsp500.sql
)

if %dbver% LSS 501 (
"%pgsqlfile%" -h "%pghost%" -p %pgport% -U "%pguser%" -v nbwsp=%dbname%< nbwsp500a.sql
)

if %dbver% LSS 502 (
"%pgsqlfile%" -h "%pghost%" -p %pgport% -U "%pguser%" -v nbwsp=%dbname%< nbwsp500b.sql
)

if %dbver% LSS 503 (
"%pgsqlfile%" -h "%pghost%" -p %pgport% -U "%pguser%" -v nbwsp=%dbname%< nbwsp500c.sql
)

if %dbver% LSS 510 (
"%pgsqlfile%" -h "%pghost%" -p %pgport% -U "%pguser%" -v nbwsp=%dbname%< nbwsp510.sql
)


"%pgsqlfile%" -h "%pghost%" -p %pgport% -U "%pguser%" -v nbwsp=%dbname%< ws_oi.sql
"%pgsqlfile%" -h "%pghost%" -p %pgport% -U "%pguser%" -v nbwsp=%dbname%< ws_tpp.sql
"%pgsqlfile%" -h "%pghost%" -p %pgport% -U "%pguser%" -v nbwsp=%dbname%< ws_vm.sql

if NOT %ERRORLEVEL% == 0 ( 
echo "Error ocurr when create DB : %dbname%"
if exist sqltmp.txt del sqltmp.txt
exit /b 1
)
call WritESLog.bat Succeed in Processing DB: %dbname%
if exist sqltmp.txt del sqltmp.txt


goto :EOF
:::::::::::::::::::::::::::::::::::::::::::::::::::
::       function StrTrim
:::::::::::::::::::::::::::::::::::::::::::::::::::
:StrTrim
set "str=%~1"
set "var=%~2"

if "%str%" == "" goto endfunction
if "%str%" == " " goto endfunction

:lTrim
if "%str:~0,1%" == " " set "str=%str:~1%" && goto lTrim

:rTrim
if "%str:~-1%" == " " set "str=%str:~0,-1%" && goto rTrim

:endfunction
set "%var%=%str%"

goto :EOF