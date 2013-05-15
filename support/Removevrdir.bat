
@set Server=%~1
@set SiteIndex=%~2
@set AppPool=%~3
@set Vdir=%~4

@set Vdirroot=%~5

@set nret=0
@regsvr32 /s %Systemroot%\system32\cmdlib.wsc
@if %errorlevel% == 0 (
@echo Succeed to regsvr32 cmdlib.wsc
)else (
@echo Failed to regsvr32 cmdlib.wsc
@set nret=-1
)

@regsvr32 /s %Systemroot%\system32\IIsScHlp.wsc
@if %errorlevel% == 0 (
@echo Succeed to regsvr32 IIsScHlp.wsc
)else (
@echo Failed to regsvr32 IIsScHlp.wsc
@set nret=-1
)

echo stop apppool:%AppPool% >>&3
@cscript.exe stop-app-pool.vbs "%AppPool%" "%Vdir%"
@if %errorlevel% == 0 (
@echo Succeed to stop apppool
)else (
@echo Failed to stop apppool
@set nret=-1
)
echo Succeed stop apppool:%AppPool% >>&3

echo delete vdir:%Vdir% >>&3

if "%Vdirroot%" == "" (
@cscript.exe iisvdir.vbs /s "%Server%" /delete w3svc/%SiteIndex%/ROOT/%Vdir%
@if %errorlevel% == 0 (
@echo Succeed to delete virual dir
)else (
@echo Failed to delete virual dir
@set nret=-1
)


) else (

@cscript.exe iisvdir.vbs /s "%Server%" /delete w3svc/%SiteIndex%/ROOT/%Vdirroot%/%Vdir%
@if %errorlevel% == 0 (
@echo Succeed to delete virual dir
)else (
@echo Failed to delete virual dir
@set nret=-1
)


)


echo Succeed delete vdir:%Vdir% >>&3


echo delete apppool:%AppPool% >>&3
@cscript.exe un-app-pool.vbs "%AppPool%" "%Vdir%"
@if %errorlevel% == 0 (
@echo Succeed to delete apppool
)else (
@echo Failed to delete apppool
@set nret=-1
)
echo Succeed delete vdir:%Vdir% >>&3


@exit /b %nret%
