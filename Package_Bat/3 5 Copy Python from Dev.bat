set "DevROOTPATH=..\..\Dev"
set "DESPATH=..\..\Enterprise Server\WorkSpace\WebServer"

xcopy "%DevROOTPATH%\Resource\Python" "%DESPATH%\Resource\Python" /I /S /Y /E /F
exit /b %errorlevel%


