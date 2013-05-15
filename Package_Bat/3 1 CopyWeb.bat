set "SRCROOTPATH=..\..\ES"
set "DESROOTPATH=..\..\Enterprise Server"

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::                        Workspace
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
set "SRCPATH=%SRCROOTPATH%\NBWSP"
set "DESPATH=%DESROOTPATH%\WorkSpace\WebServer"
xcopy "%SRCPATH%" "%DESPATH%" /I /S /Y /F
if not %errorlevel% == 0 goto end
xcopy "%SRCPATH%\conf_setup" "%DESPATH%\conf" /I /S /Y /F
if not %errorlevel% == 0 goto end


::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::                        Workspace Server
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
set "SRCPATH=%SRCROOTPATH%\NBWSPGW"
set "DESPATH=%DESROOTPATH%\WorkSpace Server"
xcopy "%SRCPATH%" "%DESPATH%" /I /S /Y /F
if not %errorlevel% == 0 goto end


::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::                        License Server
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
set "SRCPATH=%SRCROOTPATH%\NBCLIC"
set "DESPATH=%DESROOTPATH%\License Server"
xcopy "%SRCPATH%" "%DESPATH%" /I /S /Y /F
if not %errorlevel% == 0 goto end
xcopy "%SRCPATH%\conf_setup" "%DESPATH%\conf"  /I /S /Y /F



:end
exit /b %errorlevel%








