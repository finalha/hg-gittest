@echo off

if exist netbrainlogfile (
	set /p logfile=<netbrainlogfile
) else (
	exit 
)

set message=%*

echo %message% >>"%logfile%"

