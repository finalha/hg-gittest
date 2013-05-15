Set   objArgs   =   WScript.Arguments

Set WshNetwork = CreateObject("WScript.Network")
wscript.echo WshNetwork.UserName
wscript.echo WshNetwork.UserDomain
tuser = WshNetwork.UserDomain+"\"+WshNetwork.UserName
tuser = WshNetwork.UserName

set WshShell = CreateObject("WScript.Shell") 

tdir=objArgs(0)
tindex = InStr(0+1,tdir,"\")
ncount=1
While tindex >0 And ncount<50
WshShell.RUN "checkcurusersright.bat """ +Left(tdir,tindex-1)+ """ " + objArgs(1) +" """ + tuser +"""",0,TRUE
tindex = InStr(tindex+1,tdir,"\") 
ncount= ncount+1
Wend 


if Right(tdir,1)<>"\" then
	WshShell.RUN "checkcurusersright.bat """ + tdir + """ " + objArgs(1)+" """ + tuser +"""",0,TRUE
end if

