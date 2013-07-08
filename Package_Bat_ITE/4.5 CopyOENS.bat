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

set "NB_ES_SetupFiles=%NB_ES%\SetupFiles"

set "RemoteDir=\\10.10.10.6"
set "RemoteDir_USER=netbrain"
set "RemoteDir_PWD=netbrain"
set "OEDIR=%RemoteDir%\Netbrain-Setup\ITE5.1\"
set "NSDIR=%RemoteDir%\Netbrain-Setup\NS5.1\"


::@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

if not exist "%NB_ES_SetupFiles%" mkdir "%NB_ES_SetupFiles%"        || goto end

net use %RemoteDir%\IPC$ %RemoteDir_PWD% /user:%RemoteDir_USER%     || goto end


for /f "delims=" %%i in ('dir "%OEDIR%" /B /AD /TC /O-D') do (
 set "OEPATH=%OEDIR%%%~nxi\setup.exe"
 goto copyoe 
) 

:copyoe
copy "%OEPATH%" "%NB_ES_SetupFiles%\ITESetup.exe" /Y                 || goto end


for /f "delims=" %%i in ('dir "%NSDIR%" /B /AD /TC /O-D') do (
 set "NSPATH=%NSDIR%%%~nxi\setup.exe"
 goto copyns 
) 


:copyns
copy "%NSPATH%" "%NB_ES_SetupFiles%\NSSetup.exe" /Y                 || goto end


:end
exit /b %errorlevel%