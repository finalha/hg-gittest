set xmlfile=%~1
set DelAll=%~2

set selfpath=%~fs0
set selfname=%~nxs0

set Esproname=ES5WpsTool.exe
setlocal enabledelayedexpansion
set EsproPath=!selfpath:%selfname%=%Esproname%! 
setlocal DISABLEDELAYEDEXPANSION

set Uninstallfilename=Uninstall.bat
setlocal enabledelayedexpansion
set Uninstallfile=!selfpath:%selfname%=%Uninstallfilename%! 
setlocal DISABLEDELAYEDEXPANSION

if "%DelAll%" == "DelAll=Yes" goto UNDEL


%EsproPath% -m noguiUninstallAll -b "%Uninstallfile%" -x "%xmlfile%"
goto :EOF


:UNDEL
%EsproPath% -m noguiUninstallAll -b "%Uninstallfile%" -x "%xmlfile%" -d
