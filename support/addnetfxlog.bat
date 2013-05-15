set netlog=%temp%\dd_dotnetfx35install.txt
set neterrlog=%temp%\dd_dotnetfx35error.txt

@if NOT exist "%netlog%" (
goto netfx35
) else (
goto copylog
)

:netfx35
set netlog=%Systemroot%\Microsoft.NET\Framework\v3.5\Microsoft .NET Framework 3.5 SP1\Logs\dd_dotnetfx35install.txt
set neterrlog=%Systemroot%\Microsoft.NET\Framework\v3.5\Microsoft .NET Framework 3.5 SP1\Logs\dd_dotnetfx35error.txt

@if NOT exist "%netlog%" (
goto netfx3564
) else (
goto copylog
)

:netfx3564
set netlog=%Systemroot%\Microsoft.NET\Framework64\v3.5\Microsoft .NET Framework 3.5 SP1\Logs\dd_dotnetfx35install.txt
set neterrlog=%Systemroot%\Microsoft.NET\Framework64\v3.5\Microsoft .NET Framework 3.5 SP1\Logs\dd_dotnetfx35error.txt

:copylog
set logtxt=%1
copy "%netlog%" "%windir%\..\nbesinstall_netsetup.log" /y
copy "%neterrlog%" "%windir%\..\nbesinstall_netsetuperror.log" /y

