@echo off              

set "flag=%~1"
set "Ver=ES5.0a"

if not "%flag%" == "Package" (
Color A
echo Now start package %Ver% setup file ,pls do not close this window
if not exist "%~dp0Log" mkdir "%~dp0Log"
"%~f0" "Package" 1>"%~dp0Log\ES_%date:~0,10%-%time::=-%.log" 2>&1
goto :EOF
) 

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

@echo on

pushd %~dp0

call "1 1  UpdateWeb.bat"

@if %errorlevel% == 0 (
@echo Succeed to update web
)else (
set ErrMsg=Failed to update web
goto :Error
)

call "2 BuildWeb.bat"

@if %errorlevel% == 0 (
@echo Succeed to Build Web
)else (
set ErrMsg=Failed to Build Web
goto :Error
)


call "3 1 CopyWeb.bat"

@if %errorlevel% == 0 (
@echo Succeed to Copy Web
)else (
set ErrMsg=Failed to CopyWeb
goto :Error
)


call "3 2 cry.bat"

@if %errorlevel% == 0 (
@echo Succeed to cry
)else (
set ErrMsg=Failed to cry
goto :Error
)


call "3 3 Copy ESdata.bat"

@if %errorlevel% == 0 (
@echo Succeed to Copy ESdata
)else (
set ErrMsg=Failed to Copy ESdata
goto :Error
)


call "3 4 Copy Sql Script.bat"

@if %errorlevel% == 0 (
@echo Succeed to Copy Sql Scripts
)else (
set ErrMsg=Failed to Copy Sql Scripts
goto :Error
)


call "3 5 Copy Python from Dev.bat"

@if %errorlevel% == 0 (
@echo Succeed to Copy Python from Dev
)else (
set ErrMsg=Failed to Copy Python from Dev
goto :Error
)


call "3 6 Copy WSfiles.bat"

@if %errorlevel% == 0 (
@echo Succeed to Copy wsfiles
)else (
set ErrMsg=Failed to Copy WSfiles
goto :Error
)


call "4 1 CopyBin.bat"

@if %errorlevel% == 0 (
@echo Succeed to Copy Bin
)else (
set ErrMsg=Failed to Copy Bin
goto :Error
)


call "4 2 CopyBinToLisenceTool.bat"

@if %errorlevel% == 0 (
@echo Succeed to Copy Bin To LisenceTool
)else (
set ErrMsg=Failed to Copy Bin To LisenceTool
goto :Error
)


call "5 CopyOENS.bat" 

@if %errorlevel% == 0 (
@echo Succeed to Copy OENS
)else (
set ErrMsg=Failed to Copy OENS
goto :Error
)


call "6 Packageworkspace.bat"

@if %errorlevel% == 0 (
@echo Succeed to Package workspace
)else (
set ErrMsg=Failed to Package workspace
goto :Error
)



call "7 SignFiles.bat"

@if %errorlevel% == 0 (
@echo Succeed to Sign Files
)else (
set ErrMsg=Failed to Sign Files
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
cscript SendEMail.vbs "%Ver% setup package %date:~0,10% %time:~0,8%" "%Ver% setup package can be downloaded and installed. %desfile% "  wangzhiyuan@networkbrain.com myu@networkbrain.com;ywang@networkbrain.com

goto :EOF

:Error
cscript SendEMail.vbs "Error:%Ver% setup package %date:~0,10% %time:~0,8%" "Failed to package %Ver% setup file! Message:%ErrMsg%"  wangzhiyuan@networkbrain.com myu@networkbrain.com;ywang@networkbrain.com


