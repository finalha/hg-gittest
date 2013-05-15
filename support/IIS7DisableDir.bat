
set SiteName=%~1
set VdirName=%~2
set DirName=%~3

set Vdirroot=netbrain

if "%DirName%" == "" exit /b 1

set AppCommond=%Systemroot%\system32\inetsrv\appcmd.exe

%AppCommond% set config "%SiteName%/%Vdirroot%/%VdirName%/%DirName%" -section:system.webServer/security/authentication/anonymousAuthentication /enabled:"False" /commit:apphost
