::@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

set "VersionInfo=ITE_ES5.1"

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

set "NB_ESinstall_Package=%NB_ESinstall%\Package_ITE"
set "SetupFile_ES=%NB_ESinstall_Package%\ES\Product Configuration 1\Release 1\DiskImages\DISK1\setup.exe"

set "Sign_File=%CurrentPATH%Sign_File.bat"
set "Sign_Name=Netbrain Enterprise Server"

set "ISCmdBld=D:\Program Files\InstallShield\2010\System\ISCmdBld.exe"
set "Pro_ES=%NB_ESinstall_Package%\ES.ism"

set "RemoteDir=\\10.10.10.6"
set "RemoteDir_USER=netbrain"
set "RemoteDir_PWD=netbrain"
set "ESDIR=%RemoteDir%\Netbrain-Setup\ITE_ES5.1\"

set "MailTO=QA@networkbrain.com;dev@networkbrain.com"
set "MailCC=wbi@networkbrain.com;fgan@networkbrain.com;yzhao@networkbrain.com;zwang@networkbrain.com"
set "MailSubject=Build Server:%COMPUTERNAME%, %VersionInfo% setup package %date:~0,10% %time:~0,8%"
set "MailText=%VersionInfo% Release SetUp Package can be downloaded and installed. %ErrMessage% %DesPath%"
set "Mail=%CurrentPATH%SendEMail.vbs"
set "MailTextFile=%~dpn0MailText"

::@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

"%ISCmdBld%" -p "%Pro_ES%" -r "Release 1" -c COMP -a "Product Configuration 1"  2>"%MailTextFile%"   || goto Error

call Sign_File.bat "%Sign_Name%" "%SetupFile_ES%"                               2>"%MailTextFile%"   || goto Error

net use %RemoteDir%\IPC$ %RemoteDir_PWD% /user:%RemoteDir_USER%                 2>"%MailTextFile%"   || goto Error

call :GenerateFileName "%ESDIR%" "ES_Des_Path"                                  2>"%MailTextFile%"   || goto Error 

copy "%SetupFile_ES%" "%ES_Des_Path%"   /y                                      2>"%MailTextFile%"   || goto Error  


echo %VersionInfo% Release SetUp Package can be downloaded and installed. >"%MailTextFile%"
echo %ES_Des_Path%                                                       >>"%MailTextFile%"
cscript  "%Mail%" "Succeed! %MailSubject%" "%MailTextFile%" "%MailTO%" "%MailCC%"
if exist "%MailTextFile%" del /f /q "%MailTextFile%"


exit /b 0

goto :EOF

:Error
cscript  "%Mail%" "Failed! %MailSubject%" "%MailTextFile%" "%MailTO%" "%MailCC%"
if exist "%MailTextFile%" del /f /q "%MailTextFile%"


exit /b 1

:end
exit /b %errorlevel%                                                            


goto :EOF
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::
::                   Generate File name 
::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:GenerateFileName
set "tmppath=%~1"
set "var=%~2"

if not %tmppath:~-1% == \ set "tmppath=%tmppath%\"

set /a n=0

:again
set /a n+=1
if exist "%tmppath%setup-%date:~0,10%-%n%.exe"  goto again 

set "%var%=%tmppath%setup-%date:~0,10%-%n%.exe"

goto :EOF