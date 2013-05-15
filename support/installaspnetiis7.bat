echo install iis7 asp.net >>%1
copy %2 servermanagercmd.exe /y >>%1
servermanagercmd -install web-asp-net>>%1
echo servermanagercmd over >>%1