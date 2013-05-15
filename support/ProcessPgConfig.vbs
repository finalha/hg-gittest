If WScript.Arguments.Count < 2 Then
    WScript.Echo "args file port"
    WScript.Quit(-1)
End If

Set objFSO = CreateObject("Scripting.FileSystemObject")
On Error Resume Next
Set objTextFile = objFSO.OpenTextFile( WScript.Arguments.item(0), 1)
If   Err.Number   <>   0   Then 
    WScript.Echo "Failed to open the file-read"
    WScript.Quit(-1)
End If	

strContent = objTextFile.ReadAll
If   Err.Number   <>   0   Then 
    WScript.Echo "Failed to read content"
    WScript.Quit(-1)
End If	
objTextFile.Close

dFileContents = replace(strContent, "#port = 5432", "port = " + WScript.Arguments.item(1), 1, -1, 1)

Set objTextFile = objFSO.OpenTextFile( WScript.Arguments.item(0), 2)
If   Err.Number   <>   0   Then 
    WScript.Echo "Failed to open the file-write"
    WScript.Quit(-1)
End If	

objTextFile.Write( dFileContents )
If   Err.Number   <>   0   Then 
    WScript.Echo "Failed to write content"
    WScript.Quit(-1)
End If	

objTextFile.Close

WScript.Quit(0)