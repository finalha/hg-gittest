
::@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

set "CurrentPATH=%~dp0"
set "NB_ROOT=%CurrentPATH%..\.."
set "NB_ES=%NB_ROOT%\ES"

set "LogFolder=%CurrentPATH%log"
call :formatedatedtime now
set "LogFile=%LogFolder%\%now%.log"

set "VSPATH=D:\Program Files\Microsoft Visual Studio 9.0\Common7\IDE"
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
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:formatedatedtime
set "var=%~1"

set "d=%date:~0,10%"
set "d=%d:/=-%"
set "d=%d::=-%"
set "d=%d: =%"

set "t=%time:~0,8%"
set "t=%t:/=-%"
set "t=%t::=-%"
set "t=%t: =%"

set "%var%=%d%_%t%"

goto :EOF

