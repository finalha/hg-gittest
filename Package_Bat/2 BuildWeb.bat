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

set "NB_ES_NBWSP_bin=%NB_ES_NBWSP%\bin"
set "NB_ES_NBWSPGW_bin=%NB_ES_NBWSPGW%\bin"
set "NB_ES_CLIC_bin=%NB_ES_CLIC%\bin"
set "NB_ES_LicenseTool_bin=%NB_ES_LicenseTool%\bin"
set "NB_ES_NBWSPLib_bin=%NB_ES_NBWSPLib%\bin\Release"

set "RemoteDir=\\10.10.10.68"
set "RemoteDir_USER=administrator"
set "RemoteDir_PWD=nb@233"
set "SES=%RemoteDir%\e$\Netbrain_5.1\ES"


set "SES_NBCLIC=%SES%\NBCLIC"
set "SES_NBWSP=%SES%\NBWSP"
set "SES_NBWSPGW=%SES%\NBWSPGW"
set "SES_LicenseTool=%SES%\LicenseTool"
set "SES_NBWSPLib=%SES%\NBWSPLib"


::@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


net use %RemoteDir%\IPC$ %RemoteDir_PWD% /user:%RemoteDir_USER%     || goto end

xcopy   "%SES_NBCLIC%\bin"              "%NB_ES_CLIC_bin%"                  /Y /F        || goto end
xcopy   "%SES_NBWSP%\bin"               "%NB_ES_NBWSP_bin%"                 /Y /F        || goto end
xcopy   "%SES_NBWSPGW%\bin"             "%NB_ES_NBWSPGW_bin%"               /Y /F        || goto end
xcopy   "%SES_LicenseTool%\bin"         "%NB_ES_LicenseTool_bin%"           /Y /F        || goto end
::xcopy   "%SES_NBWSPGW%\bin\Release"     "%NB_ES_NBWSPLib_bin%"              /Y /F        || goto end


:end
exit /b %errorlevel%