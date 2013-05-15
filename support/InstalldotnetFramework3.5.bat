if NOT exist   %Systemroot%\Microsoft.NET\Framework64\v3.5  goto  NormalInstall
cscript.exe adsutil.vbs set W3SVC/AppPools/Enable32bitAppOnWin64 0
%Systemroot%\Microsoft.NET\Framework64\v2.0.50727\aspnet_regiis.exe -i

:NormalInstall
if NOT exist   %Systemroot%\Microsoft.NET\Framework\v3.5  goto  FailedInstall
cscript.exe adsutil.vbs set W3SVC/AppPools/Enable32bitAppOnWin64 1
%Systemroot%\Microsoft.NET\Framework\v2.0.50727\aspnet_regiis.exe -i
if NOT %errorlevel% == 0 goto FailedInstall

@exit /b 0

:FailedInstall
@exit /b -1