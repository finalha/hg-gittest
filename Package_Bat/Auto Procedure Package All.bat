@echo off              

set "flag=%~1"
set "Ver=ES5.0a"

if not "%flag%" == "Package" (
Color A
echo Now start package %Ver% setup file ,pls do not close this window
if not exist "%~dp0Log" mkdir "%~dp0Log"
"%~f0"  "Package" 1>"%~dp0Log\ES_%date:~0,10%-%time::=-%.log" 2>&1
goto :EOF
) 

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

@echo on

pushd %~dp0


call "5 CopyOENS.bat" 

@if %errorlevel% == 0 (
@echo Succeed to Copy OENS
)else (
set ErrMsg=Failed to Copy OENS
goto :Error
)


call "8 Package.bat"

@if %errorlevel% == 0 (
@echo Succeed to Package  ES
)else (
set ErrMsg=Failed to Package ES
goto :Error
)


call "9 Publish.bat" 3>temp

@if %errorlevel% == 0 (
@echo Succeed to Publish
)else (
set ErrMsg=Failed to Publish
goto :Error
)


set /p desfile=<temp
del temp
cscript SendEMail.vbs "%Ver% Newest Procdure setup package %date:~0,10% %time:~0,8%" "%Ver% Newest Procdure setup package can be downloaded and installed. %desfile% "  wangzhiyuan@networkbrain.com ywang@networkbrain.com

goto :EOF

:Error
cscript SendEMail.vbs "Error:%Ver% Newest Procdure setup package %date:~0,10% %time:~0,8%" "Failed to package %Ver% Newest Procdure setup file! Message:%ErrMsg%"  wangzhiyuan@networkbrain.com ywang@networkbrain.com


