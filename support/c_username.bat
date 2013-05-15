del %1
for /f %%a in ('cscript //nologo username.vbs') do set aaa= %%a
echo %aaa%>>%1

