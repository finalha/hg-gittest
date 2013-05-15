set signexe=G:\SignTool\signcode.exe

set EStool=H:\ESinstall\ESinstall_NoInitdb\Enterprise Server\Workspace Server\WSfiles\ES5WpsTool.exe

"%signexe%" /cn "NetBrain Technologies Inc." /t "http://timestamp.verisign.com/scripts/timstamp.dll" -i "http://www.netbraintech.com" /n "netbrain enterprise server" "%EStool%"

pause