dim objshell
sfname= WScript.Arguments.item(0)
surl= WScript.Arguments.item(1)
Set objshell = CreateObject("Wscript.Shell")
set oUrlLink = objshell.CreateShortcut(sfname & "\License Home Page.url") 
oUrlLink.TargetPath = surl 
oUrlLink.Save 

