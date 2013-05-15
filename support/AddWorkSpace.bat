set workspace=%~1
set TargetDir=%~2

if  exist "%CommonProgramFiles%\WPS.xml" (
 set xmlfile=%CommonProgramFiles%\WPS.xml
) else if exist "%CommonProgramFiles(x86)%\WPS.xml" (
 set xmlfile=%CommonProgramFiles(x86)%\WPS.xml
) else (
 echo "xmlfile does not exist"
)


ES5WpsTool.exe -m noguiGoc -n "%workspace%" -g id1 -l "%TargetDir%" -x "%xmlfile%" -t "%xmlfile%.ini"


WorkSpace.exe "WorkSpace=%workspace%" "TargetDir=%TargetDir%" "InfoFile=%xmlfile%.ini%"



::WorkSpace.exe "%workspace%" "%TargetDir%" "%InstanceID%"  /hide_progress 