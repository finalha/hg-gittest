
::@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

set "CurrentPATH=%~dp0"
set "NB_ROOT=%CurrentPATH%..\.."
set "NB_ES=%NB_ROOT%\ES"
set "NB_ES_ESData=%NB_ES%\ESData"

::@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


::del /f /q /s "%NB_ES_ESData%" && rmdir /s /q  "%NB_ES_ESData%" || goto end

pushd %NB_ES%

hg pull && hg update -C || goto end

popd


:end
exit /b %errorlevel%








