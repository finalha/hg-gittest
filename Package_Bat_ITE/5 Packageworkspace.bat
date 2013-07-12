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

set "NB_ESinstall_WSfiles=%NB_ESinstall%\WSfiles"
set "NB_ESinstall_Package=%NB_ESinstall%\Package_ITE"
set "Pro_WorkSpace=%NB_ESinstall_Package%\WorkSpace.ism"
set "SetupFile_WorkSpace_sou=%NB_ESinstall_Package%\WorkSpace\Media\Release 2\Package\WorkSpace.exe"

set "ISCmdBld=D:\Program Files\InstallShield\2010\System\ISCmdBld.exe"

::@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


"%ISCmdBld%" -p "%Pro_WorkSpace%" -r "Release 2" -c COMP      || goto end

copy "%SetupFile_WorkSpace_sou%" "%NB_ESinstall_WSfiles%" /y      || goto end

:end
exit /b %errorlevel%


 
