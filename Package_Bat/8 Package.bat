
set "ISPATH=D:\Program Files\InstallShield\2010\System"
set "PROPATH=..\Package\ES.ism"
"%ISPATH%\ISCmdBld.exe" -p "%PROPATH%" -r "Release 1" -c COMP -a "Product Configuration 1"  
exit /b %errorlevel%   

