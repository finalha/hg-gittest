
set confile=%~1

findstr "OnceIISConfig=1" "%confile%"

if not %errorlevel% == 0 echo OnceIISConfig=1 >>"%confile%"