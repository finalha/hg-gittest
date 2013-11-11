
::@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

set "CurrentPATH=%~dp0"
set "NB_ROOT=%CurrentPATH%..\.."
set "NB_ES=%NB_ROOT%\ES"

set "LogFolder=%CurrentPATH%log"
call :formatdatetime now
set "LogFile=%LogFolder%\%now%.log"

set "VSPATH=C:\Program Files (x86)\Microsoft Visual Studio 9.0\Common7\IDE"
set "devenv=%VSPATH%\devenv"
set "SLNPATH=%NB_ES%\NBAP.sln"


::@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

if not exist "%LogFolder%" mkdir "%LogFolder%" || goto end

"%devenv%" "%SLNPATH%" /rebuild release /out "%LogFile%"

:end
exit /b %errorlevel% 

goto :EOF
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::
::		formate date time
::    
::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:formatdatetime
set "var=%~1"

FOR /F "usebackq" %%i IN (`showdatetime`) DO set "%var%=%%i" && goto :EOF

goto :EOF

