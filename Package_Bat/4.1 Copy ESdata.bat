::@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

set "CurrentPATH=%~dp0"
set "NB_ROOT=%CurrentPATH%..\.."
set "NB_ESinstall=%NB_ROOT%\ESinstall"
set "NB_ES=%NB_ROOT%\ES"
set "NB_DEV=%NB_ROOT%\DEV"
set "NB_ES_ESData=%NB_ES%\ESData"
set "NB_ES_CLIC=%NB_ES%\NBCLIC"
set "NB_ES_NBWSP=%NB_ES%\NBWSP"
set "NB_ES_NBWSPGW=%NB_ES%\NBWSPGW"
set "NB_ES_NBWSPLib=%NB_ES%\NBWSPLib"

set "NB_DEV_DeviceType=%NB_DEV%\resource\DeviceType"
set "NB_DEV_Drivers=%NB_DEV%\userData\Drivers"

set "NB_ES_DeviceType=%NB_ES_NBWSP%\resource\DeviceType"
set "NB_ES_Drivers=%NB_ES_ESData%\Drivers"
set "NB_ES_ZipDeviceTypes=%NB_ES_ESData%\ZipDeviceTypes"
set "NB_ES_ZipDrivers=%NB_ES_ESData%\ZipDrivers"

set "zipexe=C:\Program Files\7-Zip\7z.exe"

::@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

del /f /q /s "%NB_ES_DeviceType%"       &&  rmdir /s /q "%NB_ES_DeviceType%"          && mkdir "%NB_ES_DeviceType%"            || goto end
del /f /q /s "%NB_ES_Drivers%"          &&  rmdir /s /q "%NB_ES_Drivers%"             && mkdir "%NB_ES_Drivers%"               || goto end
del /f /q /s "%NB_ES_ZipDeviceTypes%"   &&  rmdir /s /q "%NB_ES_ZipDeviceTypes%"      && mkdir "%NB_ES_ZipDeviceTypes%"        || goto end
del /f /q /s "%NB_ES_ZipDrivers%"       &&  rmdir /s /q "%NB_ES_ZipDrivers%"          && mkdir "%NB_ES_ZipDrivers%"            || goto end

xcopy "%NB_DEV_Drivers%" "%NB_ES_Drivers%" /y /e /i /f               || goto end
xcopy "%NB_DEV_DeviceType%" "%NB_ES_DeviceType%" /y /e /i /f         || goto end
del /f /q "%NB_ES_Drivers%\__init__.py"                              || goto end

for /d %%i in ("%NB_DEV_DeviceType%\*") do (
"%zipexe%" a -tzip "%NB_ES_ZipDeviceTypes%\%%~ni.zip" "%NB_DEV_DeviceType%\%%~ni" || goto end
)


for /d %%i in ("%NB_DEV_Drivers%\*") do (
"%zipexe%" a -tzip "%NB_ES_ZipDrivers%\%%~ni.zip" "%NB_DEV_Drivers%\%%~ni" || goto end
)


echo "flag" > "%NB_ES_ZipDeviceTypes%\dt.txt"
echo "flag" > "%NB_ES_ZipDrivers%\dt.txt"


:end
exit /b %errorlevel%



