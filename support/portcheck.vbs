function regexfind(patrn, strng)
  dim regex, match, matches   ' ����������
  set regex = new regexp     ' ����������ʽ��
  regex.pattern = patrn     ' ����ģʽ��
  regex.ignorecase = true     ' �����Ƿ������ַ���Сд��
  regex.global = true     ' ����ȫ�ֿ����ԡ�
  set matches = regex.execute(strng)  ' ִ��������
  for each match in matches   ' ����ƥ�伯�ϡ�
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

