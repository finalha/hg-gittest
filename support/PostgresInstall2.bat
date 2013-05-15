@set rootpath=%1
@set rootpath1=%rootpath:~1,-1%
@if ^%rootpath:~-1%==^" set rootpath=%rootpath1%

@"%rootpath%\bin\pg_ctl.exe" register -N "PostgreSQL Database Server 8.4 for NetBrain" -D %2
@if %errorlevel% == 0 (
@echo Succeed to register PostgreSQL Database Server 8.4 for NetBrain
)else (
@echo Failed to register PostgreSQL Database Server 8.4 for NetBrain %errorlevel%
)

@net start "PostgreSQL Database Server 8.4 for NetBrain"
@if %errorlevel% == 0 (
@echo Succeed to start PostgreSQL Database Server 8.4 for NetBrain
)else (
@echo Failed to start PostgreSQL Database Server 8.4 for NetBrain %errorlevel%
)

@exit /b 0

