@echo off & setlocal Enabledelayedexpansion

::set defaultRootDir=%1
::set RootDir=%defaultRootDir:~1,-1%

set RootDir=%~1

move /Y "%RootDir%\WebServer\Benchmarklog" "%RootDir%\ESData\Benchmarklog"
move /Y "%RootDir%\WebServer\LiveData" "%RootDir%\ESData\LiveData"
move /Y "%RootDir%\WebServer\TempFilePath" "%RootDir%\ESData\TempFilePath"
move /Y "%RootDir%\WebServer\TempTopo" "%RootDir%\ESData\TempTopo"
move /Y "%RootDir%\WebServer\TempZipLog" "%RootDir%\ESData\TempZipLog"