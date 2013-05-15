set usernamecur=%username%
set domaincur=%USERDNSDOMAIN%

for /f %%a in ('cscript //nologo GetCurrentUserName.vbs') do set usernamecur=%%a
@echo username :%usernamecur% >> %2
for /f %%a in ('cscript //nologo GetCurrentDomain.vbs') do set domaincur=%%a
@echo domain :%domaincur%  >> %2

%1
cd \
@echo add users rights to directory: %1 >> %2
@cacls %1 /E /C /G Users:F >> %2

@echo add disk current user permission >> %2
cacls %1 /E /C /G "%usernamecur%":F >> %2

cacls %1 /E /C /G "%usernamecur%@%domaincur%":F >> %2

