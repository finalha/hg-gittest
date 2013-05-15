@echo off

set "BINPATH=..\..\Dev\bin_release.Pro"
set "DESPATH=..\..\Enterprise Server\LicenseTool\bin"


xcopy "%BINPATH%" "%DESPATH%" /U /Y /F 




