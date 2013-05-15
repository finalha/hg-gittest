
(reg query HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\InetStp  /f "Version 6" /d) && (reg query HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\InetStp  /f "IIS 6" /d) && goto IIS6

%Systemroot%\system32\inetsrv\appcmd delete vdir  "Default Web Site/Workspace" 

:IIS6
@cscript.exe iisvdir.vbs /s "127.0.0.1" /delete w3svc/1/ROOT/Workspace