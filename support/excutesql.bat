@echo off

set "pgsqlfile=%~1"
set "pgport=%~2"
set "pguser=%~3"
set "sql=%~4"

"%pgsqlfile%" -h 127.0.0.1 -p %pgport% -U "%pguser%" < "%sql%"