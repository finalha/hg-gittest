set "SRCROOTPATH=..\..\ES\"
set "DESROOTPATH=..\..\ESInstall\"

set "PGDESPATH=%DESROOTPATH%support"
set "PGSRCPATH=%SRCROOTPATH%NBCLIC\pgsqlfile"
xcopy "%PGSRCPATH%\*.sql" "%PGDESPATH%" /Y /F
if not %errorlevel% == 0 goto end

set "PGSRCPATH=%SRCROOTPATH%NBWSP\pgsqlfile"
for /R "%PGSRCPATH%" %%i in (*.sql) do  cscript replacefiletext.vbs "%%~i" nbwsp :nbwsp "%PGDESPATH%\%%~nxi"  || goto end

:end
exit /b %errorlevel%

