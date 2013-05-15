
if  exist "%windir%\SysWOW64\NetBrain\Common\WPS.xml" (
 set "xmlfile=%windir%\SysWOW64\NetBrain\Common\WPS.xml"
) else if exist "%windir%\System32\NetBrain\Common\WPS.xml" (
 set "xmlfile=%windir%\System32\NetBrain\Common\WPS.xml"
) else (
 echo "xmlfile does not exist"
)

set selfpath=%~fs0
set selfname=%~nxs0
set "installfilename=test.bat"
setlocal enabledelayedexpansion
set installfilepath=!selfpath:%selfname%=%installfilename%! 
setlocal DISABLEDELAYEDEXPANSION

set Esproname=ES5WpsTool.exe
setlocal enabledelayedexpansion
set EsproPath=!selfpath:%selfname%=%Esproname%! 
setlocal DISABLEDELAYEDEXPANSION

%EsproPath% -m guiInstall -b %installfilepath% -x "%xmlfile%" 

