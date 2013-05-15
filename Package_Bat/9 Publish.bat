set "srcdisk=..\Package\ES\Product Configuration 1\Release 1\DiskImages\DISK1\setup.exe"

call Sign_File.bat "netbrain enterprise server" "%srcdisk%"
if not %errorlevel% == 0 goto end

set "desdisk=\\10.10.10.200\Netbrain-Setup\ES5.0\setup-%date:~0,10%-1.exe"

@if exist "%desdisk%" set "desdisk=\\10.10.10.200\Netbrain-Setup\ES5.0\setup-%date:~0,10%-2.exe"
@if exist "%desdisk%" set "desdisk=\\10.10.10.200\Netbrain-Setup\ES5.0\setup-%date:~0,10%-3.exe"
@if exist "%desdisk%" set "desdisk=\\10.10.10.200\Netbrain-Setup\ES5.0\setup-%date:~0,10%-4.exe"
@if exist "%desdisk%" set "desdisk=\\10.10.10.200\Netbrain-Setup\ES5.0\setup-%date:~0,10%-5.exe"
@if exist "%desdisk%" set "desdisk=\\10.10.10.200\Netbrain-Setup\ES5.0\setup-%date:~0,10%-6.exe"
@if exist "%desdisk%" set "desdisk=\\10.10.10.200\Netbrain-Setup\ES5.0\setup-%date:~0,10%-7.exe"
@if exist "%desdisk%" set "desdisk=\\10.10.10.200\Netbrain-Setup\ES5.0\setup-%date:~0,10%-8.exe"
@if exist "%desdisk%" set "desdisk=\\10.10.10.200\Netbrain-Setup\ES5.0\setup-%date:~0,10%-9.exe"
@if exist "%desdisk%" set "desdisk=\\10.10.10.200\Netbrain-Setup\ES5.0\setup-%date:~0,10%-10.exe"
@if exist "%desdisk%" set "desdisk=\\10.10.10.200\Netbrain-Setup\ES5.0\setup-%date:~0,10%-11.exe"

copy "%srcdisk%" "%desdisk%" 
if not %errorlevel% == 0 goto end

echo "%desdisk%" >&3

:end
exit /b %errorlevel%