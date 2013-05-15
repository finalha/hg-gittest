@net user nbpostgres /delete

@net user nbpostgres nbP0stgres /add /PASSWORDCHG:NO

@net localgroup users nbpostgres /delete

@netuser.exe nbpostgres /pwnexp:y

@ntrights.exe -u nbpostgres +r SeServiceLogonRight

@cacls %1 /E /T /D nbpostgres > c:\temp0009.txt
@cacls %1 /E /T /G nbpostgres:R > c:\temp0009.txt
@cacls %2 /E /T /P nbpostgres:C > c:\temp0009.txt

@del c:\temp0009.txt