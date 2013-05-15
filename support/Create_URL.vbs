dim objshell
sfname= WScript.Arguments.item(0)
surl= WScript.Arguments.item(1)
Set objshell = CreateObject("Wscript.Shell")
set oUrlLink = objshell.CreateShortcut(sfname) 
oUrlLink.TargetPath = surl 
oUrlLink.Save 
