@echo off

set "pghost=%~1"
set "pgport=%~2"
set "dbname=%~3"
set "pguser=%~4"
set "pgpwd=%~5"

set "pgauthfile=pgauth.exe"
call :getfullpath "%pgauthfile%" "pgauthfile"
echo "%pgauthfile%"

set "pgsqlfile=psql.exe"
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
echo "Error ocurr when finding %dbname%"  %ERRORLEVEL%
exit /b %ERRORLEVEL%
) else (
echo "Succeed to found %dbname%" %ERRORLEVEL%
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
  echo Error: can not find db %dbname%
  exit /b 1
) else (
  echo now upgrade db %dbname%
  goto checkversion
)


:checkversion

set "dbver=0"

"%pgsqlfile%" -h "%pghost%" -p %pgport% -U "%pguser%" -q -t -v nbwsp=%dbname%< Retrivever.sql > sqltmp.txt
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

if %dbver% LSS 401 (
%pgsqlfile% -h "%pghost%" -p %pgport% <ws3-1.sql
%pgsqlfile% -h "%pghost%" -p %pgport% <ws3-2.sql
%pgsqlfile% -h "%pghost%" -p %pgport% <ws3-2-2.sql
%pgsqlfile% -h "%pghost%" -p %pgport% <ws3-3.sql
%pgsqlfile% -h "%pghost%" -p %pgport% <ws3-4.sql
%pgsqlfile% -h "%pghost%" -p %pgport% <ws311.sql
%pgsqlfile% -h "%pghost%" -p %pgport% <ws31c.sql
%pgsqlfile% -h "%pghost%" -p %pgport% <ws3.2.sql
%pgsqlfile% -h "%pghost%" -p %pgport% <ws4.01.sql
)


if %dbver% LSS 402 (
%pgsqlfile% -h "%pghost%" -p %pgport% <ws4.02.sql
)

if %dbver% LSS 403 (
%pgsqlfile% -h "%pghost%" -p %pgport% <ws4.03.sql
)

if %dbver% LSS 410 (
%pgsqlfile% -h "%pghost%" -p %pgport% <ws4.1.sql
)

if %dbver% LSS 411 (
%pgsqlfile% -h "%pghost%" -p %pgport% <ws4.11.sql
)

if %dbver% LSS 412 (
%pgsqlfile% -h "%pghost%" -p %pgport% <ws4.12.sql
)

if %dbver% LSS 413 (
%pgsqlfile% -h "%pghost%" -p %pgport% <ws4.13.sql
)

if %dbver% LSS 414 (
%pgsqlfile% -h "%pghost%" -p %pgport% <ws4.14.sql
)

if %dbver% LSS 417 (
%pgsqlfile% -h "%pghost%" -p %pgport% <ws4.17.sql
)

if %dbver% LSS 418 (
%pgsqlfile% -h "%pghost%" -p %pgport% <ws4.18.sql
)

if %dbver% LSS 420 (
%pgsqlfile% -h "%pghost%" -p %pgport% <ws_vm41m2.sql
%pgsqlfile% -h "%pghost%" -p %pgport% <ws_oi41m2.sql
%pgsqlfile% -h "%pghost%" -p %pgport% <ws_tpp41m2.sql
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


