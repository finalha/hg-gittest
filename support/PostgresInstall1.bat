@echo off
echo %5 %2
call Postgres84UserSetup.bat %5 %2

set rootpath=%1
set rootpath1=%rootpath:~1,-1%
if ^%rootpath:~-1%==^" set rootpath=%rootpath1%

call Postgres84UserSetup.bat "%rootpath%" %2

:: @"%rootpath%\bin\initdb.exe" -U %3 --pwfile=%4 --locale=us %5
set dirtmplast=%5
set dirtmplast1tmp=%dirtmplast:~-2,1%
if %dirtmplast1tmp%==\ (
set dirtmprelace=%5
)else (
set dirtmprelace="%dirtmplast:~1,-1%\"
)
xcopy "%rootpath%\pgdbbak\*.*" %dirtmprelace% /E /Y

if %errorlevel% == 0 (
echo Succeed to copy the postgresql database
)else (
echo Failed to copy the postgresql database
exit /b %errorlevel%
)

set datapath=%5
set datapath1=%datapath:~1,-1%
if ^%datapath:~-1%==^" set datapath=%datapath1%

cscript.exe ProcessPgConfig.vbs "%datapath%\postgresql.conf" %6
if %errorlevel% == 0 (
echo Succeed to config port
)else (
echo Failed to config port
exit /b %errorlevel%
)

@exit /b 0
