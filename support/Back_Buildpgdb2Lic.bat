echo on

set pghost=%~1
set pgport=%~2
set dbname=%~3
set pguser=%~4
set pgpwd=%~5

set pgauthfile=pgauth.exe
call :getfullpath "%pgauthfile%"
set /p pgauthfile=<pathtmp
del /f /q pathtmp

set pgsqlfile=psql.exe
call :getfullpath "%pgsqlfile%"
set /p pgsqlfile=<pathtmp
del /f /q pathtmp

%pgauthfile%  -pwd "%pgpwd%" -h "%pghost%" -p "%pgport%" -U "%pguser%"
if NOT %ERRORLEVEL% == 0 ( 
echo "Failed to process postgres auth"
exit /b 1
)

cscript.exe sleep.vbs 30000

set dbver=0
set sqlfolder=.
set sqltmpfolder=sqltmp

if exist %sqltmpfolder% del /s /f /q %sqltmpfolder%
if not exist %sqltmpfolder% mkdir %sqltmpfolder%

for /f "usebackq delims=" %%i in (`dir %sqlfolder%\*.sql /b`) do (
cscript replacefiletext.vbs %sqlfolder%\%%i nbws %dbname% %sqltmpfolder%\%%i
)

pushd  %sqltmpfolder%

%pgsqlfile% -h "%pghost%" -p %pgport% -q -U "%pguser%" < testconn.sql
if NOT %ERRORLEVEL% == 0 ( 
echo "Failed to connect postgres"
exit /b 1
)

::%pgsqlfile% -h "%pghost%" -p %pgport% -q -t< Findpgdb.sql > sqltmp.txt
::if NOT %ERRORLEVEL% == 0 ( 
::echo "Error ocurr when finding nbws"
::exit /b 1
::)
::set dbname=""
::FOR /F "eol= tokens=1,2 delims= " %%i in (sqltmp.txt) do set dbname="%%i"
::del sqltmp.txt


%pgsqlfile% -h "%pghost%" -p %pgport% < ws3.sql
echo ALTER USER postgres WITH ENCRYPTED PASSWORD '%pgpwd%'; > sqltmp.txt
%pgsqlfile% -h "%pghost%" -p %pgport% < sqltmp.txt
del sqltmp.txt

::if "%dbname%" == "" (
::%pgsqlfile% -h "%pghost%" -p %pgport% < ws3.sql.tmp
::echo ALTER USER postgres WITH ENCRYPTED PASSWORD '%pgpwd%'; > sqltmp.txt
::%pgsqlfile% -h "%pghost%" -p %pgport% < sqltmp.txt
::del sqltmp.txt
::del /f /q  ws3.sql.tmp
::) else (
::%pgsqlfile% -h "%pghost%" -p %pgport% -q -t < Retrivever.sql > sqltmp.txt
::if NOT %ERRORLEVEL% == 0 ( 
::	echo "Failed to get db version"
::	del sqltmp.txt
::	exit /b 1
::)
::@FOR /F "eol= tokens=1,2 delims= " %%i in (sqltmp.txt) do @set dbver=%%i
::del sqltmp.txt
::echo %dbver%
::)

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
%pgsqlfile% -h "%pghost%" -p %pgport% <ws_vm.sql
%pgsqlfile% -h "%pghost%" -p %pgport% <ws_oi.sql
%pgsqlfile% -h "%pghost%" -p %pgport% <ws_tpp.sql
)

popd

goto :EOF

:::::::::::::::::::::::::::::::::::::::::::::::::::
::  function get_full_path
:::::::::::::::::::::::::::::::::::::::::::::::::::
:getfullpath 
echo %~fs1 >pathtmp
goto :EOF