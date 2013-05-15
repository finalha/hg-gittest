set guidfile=%~1
set replacefile=%~2
set xmlfile=%~3
set guid=%~4


cscript //nologo "%guidfile%">temp

set /p guid1=<temp

cscript "%replacefile%" "%xmlfile%" %guid% %guid1% "%xmlfile%"


::cscript //nologo "%guidfile%">temp1

::set /p guid2=<temp1

::cscript "%replacefile%" "%xmlfile%" {FC497978-CEE9-4d21-BA65-705A01DF6B25} %guid2% "%xmlfile%"



if exit temp del /f /q temp
::if exit temp1 del /f /q temp1