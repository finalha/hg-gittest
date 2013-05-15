@cscript.exe xcacls.vbs %1 /E /T /G "NETWORK SERVICE":F
@set retval=0
@if %errorlevel% == 0 (
@echo Succeed to grant the access rights of server path
)else (
@echo Failed to grant the access rights of server path
@set retval=-2
)


@cacls.exe %Systemroot%\System32\netbrain_uap.ini /E /G "NETWORK SERVICE":F
@if %errorlevel% == 0 (
@echo Succeed to grant the access rights of lfile
)else (
@echo Failed to grant the access rights of lfile
@set retval=-1
)

@cacls.exe %Systemroot%\System32\netbrain_uap01.ini /E /G "NETWORK SERVICE":F
@if %errorlevel% == 0 (
@echo Succeed to grant the access rights of lfile
)else (
@echo Failed to grant the access rights of lfile
@set retval=-1
)


@cacls.exe %Systemroot%\System32\nbl /E /G "NETWORK SERVICE":F
@if %errorlevel% == 0 (
@echo Succeed to grant the access rights of lfile
)else (
@echo Failed to grant the access rights of lfile
@set retval=-1
)

@cacls.exe %Systemroot%\System32\nbl\nb10002.ini /E /G "NETWORK SERVICE":F
@if %errorlevel% == 0 (
@echo Succeed to grant the access rights of lfile
)else (
@echo Failed to grant the access rights of lfile
@set retval=-1
)

@cacls.exe %Systemroot%\System32\3201 /E /G "NETWORK SERVICE":F
@if %errorlevel% == 0 (
@echo Succeed to grant the access rights of lfile
)else (
@echo Failed to grant the access rights of lfile
@set retval=-1
)


@exit /b %retval%
