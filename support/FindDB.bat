@echo off

echo %*

set "pghost=%~1"
set "pgport=%~2"
set "dbname=%~3"
set "pguser=%~4"
set "pgpwd=%~5"

set "selfpath=%~dp0"

set "pgsqlfile=psql.exe"
set "pgsqlfile=%selfpath%%pgsqlfile%"

"%pgsqlfile%" -h "%pghost%" -p %pgport% -U "%pguser%" -q -t -v nbws='%dbname%'< Findpgdb.sql > sqltmp1.txt
if NOT %ERRORLEVEL% == 0 ( 
echo "Error ocurr when finding %dbname%"
exit /b 1
)

findstr "%dbname%" sqltmp1.txt
set "returnvalue=%ERRORLEVEL%"

if exist sqltmp1.txt del /f /q sqltmp1.txt

exit /b %returnvalue%