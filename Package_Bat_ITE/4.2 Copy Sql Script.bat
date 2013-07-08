::@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

set "CurrentPATH=%~dp0"
set "NB_ROOT=%CurrentPATH%..\.."
set "NB_ESinstall=%NB_ROOT%\ESinstall"
set "NB_ES=%NB_ROOT%\ES"
set "NB_DEV=%NB_ROOT%\DEV"
set "NB_ES_ESData=%NB_ES%\ESData"
set "NB_ES_CLIC=%NB_ES%\NBCLIC"
set "NB_ES_NBWSP=%NB_ES%\NBWSP"
set "NB_ES_NBWSPGW=%NB_ES%\NBWSPGW"
set "NB_ES_NBWSPLib=%NB_ES%\NBWSPLib"

set "NB_ESinstall_support=%NB_ESinstall%\support"
set "NB_ES_CLIC_sqldir=%NB_ES_CLIC%\pgsqlfile"
set "NB_ES_NBWSP_sqldir=%NB_ES_NBWSP%\pgsqlfile"

set "replacefiletext=%CurrentPATH%replacefiletext.vbs"

::@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

xcopy "%NB_ES_CLIC_sqldir%\*.sql" "%NB_ESinstall_support%" /Y /F || goto end

for /R "%NB_ES_NBWSP_sqldir%" %%i in (*.sql) do  cscript "%replacefiletext%" "%%~i" nbwsp :nbwsp "%NB_ESinstall_support%\%%~nxi"  || goto end

:end
exit /b %errorlevel%

