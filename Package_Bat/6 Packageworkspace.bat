
set "ISPATH=D:\Program Files\InstallShield\2010\System"
set "PROPATH=..\Package\WorkSpace.ism"
"%ISPATH%\ISCmdBld.exe" -p "%PROPATH%" -r "Release 2" -c COMP
if not %errorlevel% == 0 goto end

set "srcdisk=..\Package\WorkSpace\Media\Release 2\Package\WorkSpace.exe"

call Sign_File.bat "netbrain enterprise server" "%srcdisk%"
if not %errorlevel% == 0 goto end

xcopy "%srcdisk%" "..\..\Enterprise Server\WorkSpace Server\WSfiles\" /y /f
if not %errorlevel% == 0 goto end

:end
exit /b %errorlevel%


 
