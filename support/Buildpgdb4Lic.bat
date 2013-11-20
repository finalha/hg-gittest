@echo off

set "pghost=%~1"
set "pgport=%~2"
set "dbname=%~3"
set "pguser=%~4"
set "pgpwd=%~5"

set pgauthfile=pgauth.exe
call :getfullpath "%pgauthfile%" "pgauthfile"
echo "%pgauthfile%"

set pgsqlfile=psql.exe
call :getfullpath "%pgsqlfile%" "pgsqlfile"
echo "%pgsqlfile%"

"%pgauthfile%" -pwd "%pgpwd%" -h "%pghost%" -p "%pgport%" -U "%pguser%"
if NOT %ERRORLEVEL% == 0 ( 
echo "Failed to process postgres auth: " %ERRORLEVEL%
exit /b %ERRORLEVEL%
) else (
echo "Succeed to process postgres auth" %ERRORLEVEL%
)

cscript.exe sleep.vbs 30000

"%pgsqlfile%" -h "%pghost%" -p %pgport% -q -U "%pguser%" < testconn.sql
if NOT %ERRORLEVEL% == 0 ( 
echo "Failed to connect postgres" %ERRORLEVEL%
exit /b %ERRORLEVEL%
) else (
echo "Succeed to connect postgres" %ERRORLEVEL%
)

"%pgsqlfile%" -h "%pghost%" -p %pgport% -U "%pguser%" -q -t -v nbws='%dbname%'< Findpgdb.sql > sqltmp.txt
if NOT %ERRORLEVEL% == 0 ( 
echo "Error ocurr when finding nbclic"  %ERRORLEVEL%
exit /b %ERRORLEVEL%
) else (
echo "Succeed to found nbclic" %ERRORLEVEL%
)

echo dbname "%dbnametmp%"
find "%dbname%" sqltmp.txt
if NOT %ERRORLEVEL% == 0 ( 
echo "There is no DB: %dbname%"
goto createdb
) 

set /p dbnametmp=<sqltmp.txt
call :trim "%dbnametmp%" "dbnametmp"
echo dbname "%dbnametmp%"

if exist sqltmp.txt del sqltmp.txt

if not "%dbnametmp%" == "%dbname%"  (
  echo now create new db %dbname%
  goto createdb
) else (
  echo now upgrade db %dbname%
  goto checkversion
)

:createdb
echo Now create new db %dbname%
"%pgsqlfile%" -h "%pghost%" -p %pgport% -U "%pguser%" < nbclic.sql
if NOT %ERRORLEVEL% == 0 ( 
echo "Error ocurr when create DB : %dbname%" %ERRORLEVEL%
exit /b %ERRORLEVEL%
) else (
echo "Succeed to create DB : %dbname%"  %ERRORLEVEL%
)

set "dbver=0"
goto excuupdate

:checkversion

set "dbver=0"

"%pgsqlfile%" -h "%pghost%" -p %pgport% -U "%pguser%" -q -t < findtable.sql > sqltmp.txt
if NOT %ERRORLEVEL% == 0 ( 
echo "Error ocurr when find table : system_info" %ERRORLEVEL%
exit /b %ERRORLEVEL%
) else (
echo "Succeed to find table system_info" %ERRORLEVEL%
)

set /p tablename=<sqltmp.txt
call :trim "%tablename%" "tablename"
if exist sqltmp.txt del /f /q sqltmp.txt

if not "%tablename%" == "system_info" set "dbver=0" && echo can not find system_info table ,db version 0 && goto excuupdate 

"%pgsqlfile%" -h "%pghost%" -p %pgport% -U "%pguser%" -q -t -v dbname=%dbname%< getver.sql > sqltmp.txt
if NOT %ERRORLEVEL% == 0 ( 
echo "Error ocurr when get db version " %ERRORLEVEL%
exit /b %ERRORLEVEL%
) else (
echo "Succeed to get db version" %ERRORLEVEL%
)

set /p dbver=<sqltmp.txt
call :trim "%dbver%" "dbver"
if exist sqltmp.txt del /f /q sqltmp.txt

if "%dbver%" == "" set "dbver=0" && echo dbver is null ,db verison 0



:excuupdate
echo Now update db ,db version  %dbver%

if %dbver% LSS 500 (
"%pgsqlfile%" -h "%pghost%" -p %pgport% -U "%pguser%"  < nbclic500.sql
)


if %dbver% LSS 501 (
"%pgsqlfile%" -h "%pghost%" -p %pgport% -U "%pguser%"  < nbclic500a.sql
)

if %dbver% LSS 502 (
"%pgsqlfile%" -h "%pghost%" -p %pgport% -U "%pguser%"  < nbclic500b.sql
)

if %dbver% LSS 503 (
"%pgsqlfile%" -h "%pghost%" -p %pgport% -U "%pguser%"  < nbclic500c.sql
)

if %dbver% LSS 510 (
"%pgsqlfile%" -h "%pghost%" -p %pgport% -U "%pguser%"  < nbclic510.sql
)

if %dbver% LSS 511 (
"%pgsqlfile%" -h "%pghost%" -p %pgport% -U "%pguser%"  < nbclic511.sql
)

if %dbver% LSS 512 (
"%pgsqlfile%" -h "%pghost%" -p %pgport% -U "%pguser%"  < nbclic512.sql
)

if %dbver% LSS 513 (
"%pgsqlfile%" -h "%pghost%" -p %pgport% -U "%pguser%"  < nbclic513.sql
)

if %dbver% LSS 514 (
"%pgsqlfile%" -h "%pghost%" -p %pgport% -U "%pguser%"  < nbclic514.sql
)


echo %date% %time%

exit /b %ERRORLEVEL%

goto :EOF
:::::::::::::::::::::::::::::::::::::::::::::::::::
::  function get_full_path
:::::::::::::::::::::::::::::::::::::::::::::::::::
:getfullpath 
set "var=%~2"
set "%var%=%~dps0%~1"
goto :EOF
:::::::::::::::::::::::::::::::::::::::::::::::::::
::   function trim
:::::::::::::::::::::::::::::::::::::::::::::::::::
:trim
set "str=%~1"
set "var=%~2"

if "%str%" == "" set "%var%= " && goto :EOF

if "%str: =%" == ""  set "%var%= " && goto :EOF 

:ltrim
if "%str:~0,1%" == " " set "str=%str:~1%" && goto ltrim

:rtrim
if "%str:~-1%" == " " set "str=%str:~0,-1%" && goto rtrim

set "%var%=%str%" 

goto :EOF


