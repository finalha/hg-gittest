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

set "NB_ESinstall_WSfiles=%NB_ESinstall%\WSfiles"
set "NB_ESinstall_WSfiles_ES5WpsTool=%NB_ESinstall_WSfiles%\ES5WpsTool.exe"
set "NB_ES_LicenseTool_bin_LicenseTool=%NB_ES_LicenseTool_bin%\LicenseTool.exe"
set "NB_ESinstall_Package=%NB_ESinstall%\Package_ITE"
set "SetupFile_WorkSpace=%NB_ESinstall_WSfiles%\WorkSpace.exe"


set "Sign_File=%CurrentPATH%Sign_File.bat"
set "Sign_Name=Netbrain Enterprise Server"

::@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


call Sign_File.bat "%Sign_Name%" "%NB_ESinstall_WSfiles_ES5WpsTool%"            || goto end
call Sign_File.bat "%Sign_Name%" "%NB_ES_LicenseTool_bin_LicenseTool%"          || goto end
call Sign_File.bat "%Sign_Name%" "%SetupFile_WorkSpace%"                        || goto end


:end
exit /b %errorlevel%
