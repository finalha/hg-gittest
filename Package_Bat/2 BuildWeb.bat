
set "VSPATH=D:\Program Files\Microsoft Visual Studio 9.0\Common7\IDE"
set "SLNPATH=..\..\ES\NBAP.sln"

if not exist log mkdir log

"%VSPATH%\devenv" "%SLNPATH%" /rebuild release /out "log\%DATE:~0,10%-%TIME::=-%.log"

echo %errorlevel%  

exit /b %errorlevel% 

