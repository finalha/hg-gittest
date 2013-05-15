Set   objArgs   =   WScript.Arguments

set WshShell = CreateObject("WScript.Shell") 

tdir=objArgs(0)
tindex = InStr(1,tdir,"\") 
WshShell.RUN "addusersrightroot.bat """ +Left(tdir,tindex-1)+ """ " + objArgs(1),0,TRUE
ncount=1
tindex = InStr(tindex+1,tdir,"\") 
While tindex >0 And ncount<50
WshShell.RUN "addusersright.bat """ +Left(tdir,tindex-1)+ """ " + objArgs(1),0,TRUE
tindex = InStr(tindex+1,tdir,"\") 
ncount= ncount+1
Wend 
if Right(tdir,1)<>"\" then
	WshShell.RUN "addusersright.bat """ + tdir + """ " + objArgs(1),0,TRUE
end if

tdir2=objArgs(2)
tindex = InStr(1,tdir,tdir2)
if tindex<1 then

tindex = InStr(1,tdir2,"\")
WshShell.RUN "addusersrightroot.bat """ +Left(tdir2,tindex-1)+ """ " + objArgs(1),0,TRUE
ncount=1
tindex = InStr(tindex+1,tdir2,"\") 
While tindex >0 And ncount<50
WshShell.RUN "addusersright.bat """ +Left(tdir2,tindex-1)+ """ " + objArgs(1),0,TRUE
tindex = InStr(tindex+1,tdir2,"\") 
ncount= ncount+1
Wend 
if Right(tdir2,1)<>"\" then
	WshShell.RUN "addusersright.bat """ + tdir2 + """ " + objArgs(1),0,TRUE
end if

end if