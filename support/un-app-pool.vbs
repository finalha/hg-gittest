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

Dim PoolName,  webName
'Dim Index
Dim Args

set args = wscript.arguments

'PoolName = "AppPool_NetbrainServer"
'webName = "netbrain"
'Index = 1

PoolName = args(0)
webName = args(1)

if AppPoolExists( PoolName ) = false Then
	WScript.Echo "Info: " & PoolName & " do not exists."
ElseIf	DeleteAppPool( PoolName ) = false Then
	WScript.Echo "Error: " & PoolName & " delete failed."
	WScript.Quit( -1 )
End If


WScript.Echo  "Info: OK"