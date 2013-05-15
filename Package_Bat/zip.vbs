'Get command-line arguments.
Set objArgs = WScript.Arguments

Set CurPath = CreateObject("Scripting.FileSystemObject").GetFolder(".")
CurPath = CurPath + "\"
InputFolder = CurPath + objArgs(0)
ZipFile = CurPath + objArgs(1)

'Create empty ZIP file.
CreateObject("Scripting.FileSystemObject").CreateTextFile(ZipFile, True).Write "PK" & Chr(5) & Chr(6) & String(18, vbNullChar)

Set objShell = CreateObject("Shell.Application")

'Set source = objShell.NameSpace(InputFolder).Items
Set source = objShell.NameSpace(InputFolder)

objShell.NameSpace(ZipFile).CopyHere(source)

'Required!
wScript.Sleep 500