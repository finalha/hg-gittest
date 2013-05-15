function regexfind(patrn, strng)
  dim regex, match, matches   ' 建立变量。
  set regex = new regexp     ' 建立正则表达式。
  regex.pattern = patrn     ' 设置模式。
  regex.ignorecase = true     ' 设置是否区分字符大小写。
  regex.global = true     ' 设置全局可用性。
  set matches = regex.execute(strng)  ' 执行搜索。
  for each match in matches   ' 遍历匹配集合。
    retstr = retstr & "match found at position "
    retstr = retstr & match.firstindex & ". match value is '"
    retstr = retstr & match.value & "'." & vbcrlf
  next
  regexfind = retstr
end Function


Function ReadFile(sFilePathAndName) 

   dim sFileContents 

   Set oFS = CreateObject("Scripting.FileSystemObject") 

   If oFS.FileExists(sFilePathAndName) = True Then 
       
      Set oTextStream = oFS.OpenTextFile(sFilePathAndName,1) 
       
      sFileContents = oTextStream.ReadAll 
     
      oTextStream.Close 

      Set oTextStream = nothing 
   
   End if 
   
   Set oFS = nothing 

   ReadFile = sFileContents 

End Function 


sfname= WScript.Arguments.item(1)
Set objShell = CreateObject("Wscript.Shell") 
objShell.Run("%comspec% /c del "+sfname), 0, TRUE
objShell.Run("%comspec% /c netstat -nao > "+sfname), 0, TRUE

FileContent = ReadFile( sfname )

Set   objArgs   =   WScript.Arguments

strFind = regexfind( "(^|\n)\s+((TCP)|(UDP))\s+[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}:" & objArgs(0) & " ", FileContent )

If strFind = "" Then
	WScript.Quit 1
End If

WScript.Quit 0

