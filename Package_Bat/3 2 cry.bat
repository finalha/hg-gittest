set cryexe="D:\Program Files\LogicNP Software\Crypto Obfuscator For .Net 2010 R2\co.exe"

%cryexe% projectfile="..\crypro\NBCLIC.obproj"
if not %errorlevel% == 0 goto end
%cryexe% projectfile="..\crypro\NBWSP.obproj"
if not %errorlevel% == 0 goto end
%cryexe% projectfile="..\crypro\NBWSPGW.obproj"
if not %errorlevel% == 0 goto end

xcopy ..\crypro\NBCLIC.dll "..\..\Enterprise Server\License Server\bin\" /Y /F
if not %errorlevel% == 0 goto end
xcopy ..\crypro\NBWSP.dll "..\..\Enterprise Server\WorkSpace\WebServer\bin\" /Y /F
if not %errorlevel% == 0 goto end
xcopy ..\crypro\NBWSPGW.dll "..\..\Enterprise Server\WorkSpace Server\bin\" /Y /F



:end
exit /b %errorlevel%