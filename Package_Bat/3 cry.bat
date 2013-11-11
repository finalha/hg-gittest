
::@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

set "CurrentPATH=%~dp0"
set "NB_ROOT=%CurrentPATH%..\.."
set "NB_ESinstall=%NB_ROOT%\ESinstall"
set "NB_ES=%NB_ROOT%\ES"
set "NB_ES_ESData=%NB_ES%\ESData"
set "NB_ES_CLIC=%NB_ES%\NBCLIC"
set "NB_ES_NBWSP=%NB_ES%\NBWSP"
set "NB_ES_NBWSPGW=%NB_ES%\NBWSPGW"
set "NB_ES_NBWSPLib=%NB_ES%\NBWSPLib"

set "CryproPath=%NB_ESinstall%\crypro"

set "cryexe=C:\Program Files (x86)\LogicNP Software\Crypto Obfuscator For .Net 2010 R2\co.exe"

::@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


"%cryexe%" projectfile="%CryproPath%\NBCLIC.obproj"     || goto end
"%cryexe%" projectfile="%CryproPath%\NBWSP.obproj"      || goto end
"%cryexe%" projectfile="%CryproPath%\NBWSPGW.obproj"    || goto end

xcopy "%CryproPath%\NBCLIC.dll" "%NB_ES_CLIC%\bin\" /Y /F         || goto end       
xcopy "%CryproPath%\NBWSP.dll" "%NB_ES_NBWSP%\bin\" /Y /F         || goto end
xcopy "%CryproPath%\\NBWSPGW.dll" "%NB_ES_NBWSPGW%\bin\" /Y /F    || goto end


:end
exit /b %errorlevel%