@echo off

echo start ocsetup netfx3
"%windir%\system32\OCSetup.exe" NetFx3 /quiet /norestart
if %errorlevel% == 0 (
echo Succeed to ocsetup netfx3
)else (
echo Failed to ocsetup netfx3
)

exit /b %errorlevel%

