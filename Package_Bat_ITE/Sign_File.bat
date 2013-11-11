
set "signname=%~1"
set "filepath=%~2"

set "signexe=signcode.exe"

set /a n=0

:SignAgain
if %n% == 5 goto Error 
"%signexe%" /cn "NetBrain Technologies Inc." /t "http://timestamp.globalsign.com/scripts/timstamp.dll" -i "http://www.netbraintech.com" /n "%signname%" "%filepath%"
if not %errorlevel% == 0 set /a n+=1 && goto SignAgain 

echo sign  "%filepath%" OK.
exit /b 0


:Error
echo Error: sign "%filepath%" failed
exit /b 1