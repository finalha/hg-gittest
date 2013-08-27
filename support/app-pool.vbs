function AppPoolExists(strAppPool)
	dim objPool
	on error resume next
	Set objPool = GetObject("IIS://localhost/w3svc/AppPools/" & strAppPool)
	if err.number <> 0 then
	AppPoolExists = false
	else
	AppPoolExists = true
	end if
end function 


function CreateNewAppPool(AppPoolName)
	dim AppPools, newAppPool
	err = 0
	set AppPools = GetObject("IIS://localhost/w3svc/AppPools")
	set newAppPool = AppPools.Create("IIsApplicationPool", AppPoolName)
'	newAppPool.WamUserName = username
'	newAppPool.WamUserPass = password
'	newAppPool.LogonMethod =1 
'	newAppPool.AppPoolIdentityType=3
	newAppPool.IdleTimeout=0
	newAppPool.PeriodicRestartTime=0
	newAppPool.AppPoolQueueLength=10000
	newAppPool.SetInfo
	if err = 0 Then
		CreateNewAppPool = True
	Else
		WScript.Echo err.number
		CreateNewAppPool = false
	end if
end function

function DeleteAppPool(AppPoolName)
	dim AppPools
	err = 0
	Set AppPools = GetObject("IIS://localhost/w3svc/AppPools")
	AppPools.Delete "IIsApplicationPool", AppPoolName 
	DeleteAppPool=true
End Function

function StopAppPool(AppPoolName)
	dim objAppPool 
	Dim Path
	err = 0
	Path = "IIS://localhost/W3SVC/AppPools/" & AppPoolName
	Set objAppPool = GetObject( Path )
	objAppPool.Stop()
	StopAppPool=true
End function

function StartAppPool(AppPoolName)
	dim objAppPool 
	Dim Path
	err = 0
	Path = "IIS://localhost/W3SVC/AppPools/" & AppPoolName
	Set objAppPool = GetObject( Path )
	objAppPool.Start()
	StartAppPool=true
End function

Function AssignAppPoolToWeb(AppPoolName, Index, name)
	Dim oRootApp
	Dim Path
	err = 0
	Path = "IIS://localhost/w3svc/" & Index  & "/root" & "/" & name
	Set oRootApp = GetObject( Path )
	oRootApp.AppPoolId = AppPoolName
	oRootApp.SetInfo()
	if err = 0 Then
		AssignAppPoolToWeb = True
	Else
		WScript.Echo err.number
		AssignAppPoolToWeb = false
	end if
end function

Dim PoolName,  webName ,rootname
Dim Index
Dim args

set args = wscript.arguments

'PoolName = "AppPool_NetbrainServer"
'webName = "netbrain"

'msgbox args(0)

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
End if

WScript.Echo  PoolName
WScript.Echo  webName
WScript.Echo  rootname

Index = 1

if AppPoolExists( PoolName ) Then
	WScript.Echo "Info: " & PoolName & " exists."
ElseIf	CreateNewAppPool( PoolName ) = false Then
	WScript.Echo "Error: " & PoolName & " create failed."
	WScript.Quit( -1 )
End If

If AssignAppPoolToWeb( PoolName, Index, webName)  = false Then 
	WScript.Echo "Error: AssignAppPoolToWeb failed."
	WScript.Quit( -1 )
End If


If StartAppPool( PoolName )  = false Then 
	WScript.Echo "Error: Start Pool failed."
	WScript.Quit( -1 )
End If

WScript.Echo  "Info: OK"