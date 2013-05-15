set "SRCROOTPATH=..\..\ES"
set "DESROOTPATH=..\.."
set "zipexe=E:\Program Files\7-Zip\7z.exe"

set "ESDATASRCPATH=%SRCROOTPATH%\ESData"
set "ESDATADESPATH=%DESROOTPATH%\Enterprise Server\WorkSpace\ESData"
set "WebServerDESPATH=%DESROOTPATH%\Enterprise Server\WorkSpace\WebServer"

del "%ESDATADESPATH%" /Q /S /F
rmdir "%ESDATADESPATH%" /Q /S
if not %errorlevel% == 0 goto end
mkdir "%ESDATADESPATH%"

del /s /q "%WebServerDESPATH%\resource\DeviceType\*.*"
rmdir /s /q "%WebServerDESPATH%\resource\DeviceType\"
if not %errorlevel% == 0 goto end
mkdir  "%WebServerDESPATH%\resource\DeviceType\"

xcopy "%ESDATASRCPATH%\DataStore"  "%ESDATADESPATH%\DataStore\"  /S /f /Y /i
if not %errorlevel% == 0 goto end
xcopy "%ESDATASRCPATH%\LiveData" "%ESDATADESPATH%\LiveData\"   /S /f /Y /i
if not %errorlevel% == 0 goto end

set "DT_DES=..\..\Dev\resource\DeviceType"
set "D_DES=..\..\Dev\userData\Drivers"

if exist "%DT_DES%\.svn" (
rmdir /S /Q "%DT_DES%\.svn"
)
if not %errorlevel% == 0 goto end

if exist "%D_DES%\.svn" (
rmdir /S /Q "%D_DES%\.svn"
)
if not %errorlevel% == 0 goto end

if exist "%D_DES%\__init__.py" (
del /Q  "%D_DES%\__init__.py"
)
if not %errorlevel% == 0 goto end

mkdir "%ESDATADESPATH%\ZipDeviceTypes\"
mkdir "%ESDATADESPATH%\Drivers\"
mkdir "%ESDATADESPATH%\ZipDrivers\"


for /f "delims=" %%i in ('dir "%DT_DES%\*" /b ') do (
if exist "%DT_DES%\%%~nxi\.svn" ( 
rmdir /S /Q "%DT_DES%\%%~nxi\.svn"
)
xcopy /S /f /Y /i "%DT_DES%\%%~nxi" "%WebServerDESPATH%\resource\DeviceType\%%~nxi\"
"%zipexe%" a -tzip "%ESDATADESPATH%\ZipDeviceTypes\%%~nxi.zip" "%DT_DES%\%%~nxi" || goto end
)


for /f "delims=" %%i in ('dir "%D_DES%\*" /b ') do (
if exist "%D_DES%\%%~nxi\.svn" (
rmdir /S /Q "%D_DES%\%%~nxi\.svn"
)
xcopy /S /f /Y /i "%D_DES%\%%~nxi" "%ESDATADESPATH%\Drivers\%%~nxi\"
"%zipexe%" a -tzip "%ESDATADESPATH%\ZipDrivers\%%~nxi.zip" "%D_DES%\%%~nxi" || goto end
)


echo "flag" > "%ESDATADESPATH%\ZipDrivers\dt.txt"
echo "flag" > "%ESDATADESPATH%\ZipDeviceTypes\dt.txt"


:end
exit /b %errorlevel%



