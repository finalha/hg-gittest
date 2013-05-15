set slogpath=%1
@echo off
echo ***************************************************************
echo.
echo  Check system information via systeminfo command

echo start seclogon >> %slogpath%
net start seclogon >> %slogpath% 2>&1

systeminfo >> %slogpath%

echo Check system information succeed.
echo.
echo ***************************************************************
echo.

whoami /user /Groups >> %slogpath%

whoami /all >>%slogpath%

echo check IIS service status
echo check IIS service status >> %slogpath%
sc query w3svc >> %slogpath%

echo check IIS service status
echo check IIS service status >> %slogpath%
iisreset /status >> %slogpath%

echo check IISAdmin service status
echo IISAdmin service status >> %slogpath%
sc query IISadmin >> %slogpath%

echo check Secondary Logon service status
echo Secondary Logon service status>> %slogpath%
sc query seclogon >> %slogpath%

echo check ASP.NET State Service status
echo ASP.NET State Service status >> %slogpath%
sc query aspnet_state >> %slogpath%

echo check all running service
echo All running service >> %slogpath%
net start >> %slogpath%

echo check detail service information 
echo Detail service information >> %slogpath%
sc query >> %slogpath%

if not exist %HOMEDRIVE%\netbrain (
echo check Group Policy 
echo Group Policy information >> %slogpath%
gpresult /user administrator /v >> %slogpath%
)

echo environment variables
set >> %slogpath%

@echo off