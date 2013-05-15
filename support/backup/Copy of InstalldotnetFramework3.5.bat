@if NOT exist   %Systemroot%\Microsoft.NET\Framework\v3.5 dotnetfx35.exe

@if NOT exist   %Systemroot%\Microsoft.NET\Framework\v3.5  goto  FailedInstall
  
%Systemroot%\Microsoft.NET\Framework\v2.0.50727\aspnet_regiis.exe -i
@if NOT %errorlevel% == 0 goto FailedInstall

@exit /b 0

:FailedInstall
@exit /b 1