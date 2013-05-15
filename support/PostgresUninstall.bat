@echo Begin to stop the PostgreSQL Database Server 8.4 for NetBrain

@set rootpath=%1
@set rootpath1=%rootpath:~1,-1%
@if ^%rootpath:~-1%==^" set rootpath=%rootpath1%

@net stop "PostgreSQL Database Server 8.4 for NetBrain"
@if %errorlevel% == 0 (
echo Succeed to stop the PostgreSQL Database Server 8.4 for NetBrain
)else (
echo Failed to stop the PostgreSQL Database Server 8.4 for NetBrain
)

@echo Begin to remove the PostgreSQL Database Server 8.4 for NetBrain
@"%rootpath%\bin\pg_ctl.exe" unregister -N "PostgreSQL Database Server 8.4 for NetBrain"

@if %errorlevel% == 0 (
echo Succeed to remove the PostgreSQL Database Server 8.4 for NetBrain
)else (
echo Failed to remove the PostgreSQL Database Server 8.4 for NetBrain
)

@exit /b %errorlevel%

