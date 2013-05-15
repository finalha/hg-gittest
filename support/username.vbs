Set WshNetwork = CreateObject("WScript.Network")
wscript.echo WshNetwork.UserDomain+"\"+WshNetwork.UserName
