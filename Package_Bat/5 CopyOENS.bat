set "DESPATH=..\..\Enterprise Server\SetupFiles\"

set "OEDIR=\\10.10.10.200\Netbrain-Setup\OE5.0\"
set "NSDIR=\\10.10.10.200\Netbrain-Setup\NS5.0\"

net use \\10.10.10.200\IPC$ netbrain /user:administrator

echo off
for /f "delims=" %%i in ('dir "%OEDIR%" /B /AD /TC /O-D') do (
 set "OEPATH=%OEDIR%%%~nxi\setup.exe"
 goto copyoe 
) 

:copyoe
echo on
xcopy "%OEPATH%" "%DESPATH%OESetup.exe" /Y /f

echo off
for /f "delims=" %%i in ('dir "%NSDIR%" /B /AD /TC /O-D') do (
 set "NSPATH=%NSDIR%%%~nxi\setup.exe"
 goto copyns 
) 


:copyns
echo on
xcopy "%NSPATH%" "%DESPATH%NSSetup.exe" /Y /f
