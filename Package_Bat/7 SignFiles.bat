@echo off

set "Lictool=..\..\Enterprise Server\LicenseTool\bin\LicenseTool.exe"
set "EStool=..\..\Enterprise Server\Workspace Server\WSfiles\ES5WpsTool.exe"

call Sign_File.bat "netbrain enterprise server" "%Lictool%"
if not %errorlevel% == 0 goto end
call Sign_File.bat "netbrain enterprise server" "%EStool%"
if not %errorlevel% == 0 goto end

:end
exit /b %errorlevel%
