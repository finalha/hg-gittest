


set "BINPATH=..\..\Dev\bin_release.Pro"
set "ESPath=..\..\Enterprise Server"

set "DESPATH=%ESPath%\WorkSpace\WebServer\bin"

xcopy "%BINPATH%" "%DESPATH%" /U /Y /F

xcopy  "%BINPATH%\ipworks6.dll"  "%DESPATH%"    /y /f

xcopy  "%BINPATH%\snmp_pp.dll"  "%DESPATH%"     /y /f

xcopy  "%BINPATH%\NBProbe.dll"  "%DESPATH%"     /y /f

xcopy  "%BINPATH%\NBLogger.dll"  "%DESPATH%"    /y /f

xcopy  "%BINPATH%\NBLiveAccess.dll"  "%DESPATH%"    /y /f

xcopy  "%BINPATH%\NBLiveTool.dll"  "%DESPATH%"      /y /f


set "DESPATH=%ESPath%\License Server\bin"

xcopy "%BINPATH%" "%DESPATH%" /U /Y /F


set "DESPATH=%ESPath%\WorkSpace Server\bin"

xcopy "%BINPATH%" "%DESPATH%" /U /Y /F



