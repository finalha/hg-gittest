@echo off

echo %*

set "pghost=%~1"
set "pgport=%~2"
set "dbname=%~3"
set "pguser=%~4"
set "pgpwd=%~5"
set "sqlname=%~6"

set "selfpath=%~dp0"

set "pgsqlfile=psql.exe"
set "pgsqlfile=%selfpath%%pgsqlfile%"

"%pgsqlfile%" -h "%pghost%" -p %pgport% -U "%pguser%" < %sqlname%
