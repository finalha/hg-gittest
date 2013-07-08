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
set "NB_ES_LicenseTool=%NB_ES%\LicenseTool"

set "NB_DEV_bin=%NB_DEV%\bin_release.Pro"
set "NB_ES_NBWSP_bin=%NB_ES_NBWSP%\bin"
set "NB_ES_NBWSPGW_bin=%NB_ES_NBWSPGW%\bin"
set "NB_ES_CLIC_bin=%NB_ES_CLIC%\bin"
set "NB_ES_LicenseTool_bin=%NB_ES_LicenseTool%\bin"

set "NB_ES_NBWSPLib_bin=%NB_ES_NBWSPLib%\bin\Release"

::@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


xcopy "%NB_DEV_bin%" "%NB_ES_CLIC_bin%"         /U /Y /F          || goto end
xcopy "%NB_DEV_bin%" "%NB_ES_NBWSP_bin%"        /U /Y /F          || goto end
xcopy "%NB_DEV_bin%" "%NB_ES_NBWSPGW_bin%"      /U /Y /F          || goto end
xcopy "%NB_DEV_bin%" "%NB_ES_LicenseTool_bin%"  /U /Y /F          || goto end

copy  "%NB_ES_NBWSPLib_bin%\NBWSPLib.dll" "%NB_ES_NBWSP_bin%" /y  || goto end

:end
exit /b %errorlevel%



