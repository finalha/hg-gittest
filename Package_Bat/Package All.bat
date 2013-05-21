
::@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@echo off              
set "flag=%~1"
set "VersionInfo=ES5.1"

if not "%flag%" == "Package" (
Color A
echo Now start package %VersionInfo% setup file ,pls do not close this window
if not exist "%~dp0Log" mkdir "%~dp0Log"
"%~f0" "Package" 1>"%~dp0Log\ES_%date:~0,10%-%time::=-%.log" 2>&1
goto :EOF
) 
::@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

@echo on

set "CurrentPATH=%~dp0"

set "MailTO=wangzhiyuan@networkbrain.com"
set "MailCC="
set "MailSubject=Build Server:%COMPUTERNAME%, %VersionInfo% setup package %date:~0,10% %time:~0,8%"
set "MailText=%VersionInfo% Release SetUp Package can be downloaded and installed. %ErrMessage% %DesPath%"
set "Mail=%CurrentPATH%SendEMail.vbs"
set "MailTextFile=%~dpn0MailText"

::@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


pushd %CurrentPATH%

call "1 UpdateWeb.bat"                              2>"%MailTextFile%"          || goto Error

call "2 BuildWeb.bat"                               2>"%MailTextFile%"          || goto Error

call "3 cry.bat"                                    2>"%MailTextFile%"          || goto Error          

call "4.1 Copy ESdata.bat"                          2>"%MailTextFile%"          || goto Error

call "4.2 Copy Sql Script.bat"                      2>"%MailTextFile%"          || goto Error

call "4.3 CopyBin.bat"                              2>"%MailTextFile%"          || goto Error

call "4.4 Copy Python from Dev.bat"                 2>"%MailTextFile%"          || goto Error

call "4.5 CopyOENS.bat"                             2>"%MailTextFile%"          || goto Error

call "5 Packageworkspace.bat"                       2>"%MailTextFile%"          || goto Error

call "6 SignFiles.bat"                              2>"%MailTextFile%"          || goto Error

call "7 Package.bat"                                          

if exist "%MailTextFile%" del /f /q "%MailTextFile%"

goto :EOF


:Error
cscript "%Mail%" "Failed! %MailSubject%" "%MailTextFile%" "%MailTO%" "%MailCC%"
if exist "%MailTextFile%" del /f /q "%MailTextFile%"