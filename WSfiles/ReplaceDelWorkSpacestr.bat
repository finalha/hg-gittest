


set selfpath=%~fs0
set selfname=%~nxs0
set "installfilename=DelWorkSpace.bat"
setlocal enabledelayedexpansion
set installfilepath=!selfpath:%selfname%=%installfilename%! 
setlocal DISABLEDELAYEDEXPANSION

set "vbsfilename=replacefiletext.vbs"
setlocal enabledelayedexpansion
set vbsfilepath=!selfpath:%selfname%=%vbsfilename%! 
setlocal DISABLEDELAYEDEXPANSION

set "vbsinstallfilename=DelWorkSpace.vbs"
setlocal enabledelayedexpansion
set vbsinstallfilepath=!selfpath:%selfname%=%vbsinstallfilename%! 
setlocal DISABLEDELAYEDEXPANSION


cscript %vbsfilepath% %vbsinstallfilepath% DelWorkSpace.bat  %installfilepath% %vbsinstallfilepath%






