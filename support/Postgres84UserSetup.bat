
@echo %* | find "debug=on" 
@if %errorlevel% == 0 (
 @echo on
) else (
 @echo off
)

set PGpath=%~1

set usernamecur=%username%
set domaincur=%USERDNSDOMAIN%

for /f %%a in ('cscript //nologo GetCurrentUserName.vbs') do set usernamecur=%%a
echo username :%usernamecur%
for /f %%a in ('cscript //nologo GetCurrentDomain.vbs') do set domaincur=%%a
echo domain :%domaincur%

cscript.exe xcacls.vbs "%PGpath%"

echo Begin to grant the local user access rights - "%PGpath%"
cacls "%PGpath%" /E /T /G "%usernamecur%":F
if %errorlevel% == 0 (
echo Succeed to grant the local user access rights - "%PGpath%"
)else (
echo Failed to grant the local user access rights - "%PGpath%" 
)

echo Begin to grant the domain user access rights - "%PGpath%"
cacls "%PGpath%" /E /T /G "%usernamecur%@%domaincur%":F
if %errorlevel% == 0 (
echo Succeed to grant the domain user access rights - "%PGpath%"
)else (
echo Failed to grant the domain user access rights - "%PGpath%"
)

if %errorlevel% == 0 (
exit /b %errorlevel%
)else (
goto labelfat32
)

:labelfat32
echo off
cacls "%PGpath%" /E /T /G "%usernamecur%@%domaincur%":F >>$.txt
for /f "delims=" %%i in ($.txt) do set a=%%i
del $.txt
if "%a%" == "The Cacls command can be run only on disk drives that use the NTFS file system." (
exit /b 0
)else (
exit /b 1
)

