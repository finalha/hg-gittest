set "path_wsfiles=..\WSfiles"

set "Path_DES=..\..\Enterprise Server\WorkSpace Server\WSfiles"

xcopy "%path_wsfiles%" "%Path_DES%\" /y /f

exit /b %errorlevel% 
