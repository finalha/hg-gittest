
Dim path 
Dim Args
Dim SiteIndex
Dim Vdir
Dim DisableDirName

set Args = wscript.arguments


if Args.count<3 Then
	WScript.Quit (1)
End if

SiteIndex = Args(0)
Vdir = Args(1)
DisableDirName = Args(2)

if Args.count=3 Then
  PoolName = args(0)
  webName = args(1)
  rootname= args(2)	
  if  rootname <> "" Then
      webName= rootname & "/" & webName
  end if
Elseif Args.count=2  Then
  PoolName = args(0)
  webName = args(1) 
Elseif Then
  WScript.Quit (1)
End if



Path = "IIS://localhost/w3svc/" & SiteIndex & "/root" &"/netbrain"& "/" & Vdir
'msgbox path

Sub DisableAnonymousAccessForDir( dir )
	On Error Resume Next
	Err.Clear
	'WScript.Echo dir
	Dim IIsObject
	Set IIsObject = GetObject(Path)
	Set objItem = IIsObject.GetObject("IISWebDirectory", dir)
	if Err.Number <> 0 Then
		Err.Clear
		Set objItem = IIsObject.Create("IIsWebDirectory", dir)
	End if
	objItem.AuthAnonymous = "False"
	objItem.SetInfo
End Sub


DisableAnonymousAccessForDir( DisableDirName )
