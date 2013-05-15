
set confile=%~1
set svHost=%~2
set svDBPort=%~3
set DBname=%~4
set svDBUserName=%~5
set svDBPwd=%~6
set confile1=%~7

set tmpfile=consrc.dat
set desfile=condes.dat

set svConnectionGraphics=Provider=PostgreSQL OLE DB Provider;Password=%svDBPwd%;User ID=%svDBUserName%;Data Source=%svHost%:%svDBPort%;Location=%DBname%;

set svConnectionWeb=server=%svHost%;port=%svDBPort%;user id=%svDBUserName%;password=%svDBPwd%;database=%DBname%;commandtimeout=600;

echo %svConnectionGraphics% >%tmpfile%

if exist %desfile% del /f /q %desfile%

EncryptFile.exe %tmpfile% %desfile%

set /p tempstr=<%desfile%

if exist %tmpfile% del /f /q %tmpfile%
if exist %desfile% del /f /q %desfile%

cscript ReplaceLineByHead.vbs "%confile%" "CONNStrEn=" "CONNStrEn=1" "%confile%"

cscript ReplaceLineByHead.vbs "%confile%" "CONNStr=" "CONNStr=^"%tempstr%^"" "%confile%"


echo %svConnectionWeb% >%tmpfile%

if exist %desfile% del /f /q %desfile%

EncryptFile.exe %tmpfile% %desfile%

set /p tempstr=<%desfile%

if exist %tmpfile% del /f /q %tmpfile%
if exist %desfile% del /f /q %desfile%

cscript ReplaceLineByHead.vbs "%confile1%" "^<dbConn connectionStr=" "^<dbConn connectionStr=^"%svConnectionWeb%^" dll=^"Npgsql^" type=^"Npgsql.NpgsqlConnection^" CONNStrEn=^"1^"^>" "%confile1%"





