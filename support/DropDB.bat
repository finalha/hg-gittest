set DBhost=%~1
set DBport=%~2
set DBuser=%~3
set DBname=%~4

dropdb -h %DBhost% -p %DBport% -U %DBuser% %DBname%