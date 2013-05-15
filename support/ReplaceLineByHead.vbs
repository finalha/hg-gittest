Dim FileName,DesFileName
Dim Oldpatrn,Newpatrn,Text
Dim Args

set Args=wscript.arguments

if Args.count<>4 Then
	WScript.echo "Please use format:Progarm Filename OldPatrn Newpatrn DesFilename"
	WScript.Quit (1)
End if

FileName=Args(0)
Oldpatrn=Args(1)
Newpatrn=Args(2)
DesFileName=Args(3)


Function ReadAllTextFile(filename)
  Const ForReading = 1, ForWriting = 2
  Dim fso, f
  Set fso = CreateObject("Scripting.FileSystemObject")
  Set f = fso.OpenTextFile(filename, ForReading)
  ReadAllTextFile =   f.ReadAll
  f.close
End Function

Function ReplaceText(str,headstr, replStr)
  Dim regEx, str1  
  patrn="^ *?" & headstr & ".*?$"             
  Set regEx = New RegExp               
  regEx.Pattern = patrn   
  regEx.Global = True            
  'regEx.IgnoreCase = True
  regEx.multiline = True               
  ReplaceText = regEx.Replace(str, replStr)        
End Function

Sub WriteToTextFile(filename,textstr)
   Const ForReading = 1, ForWriting = 2, ForAppending = 8
   Dim fso, f
   Set fso = CreateObject("Scripting.FileSystemObject")
   Set f = fso.OpenTextFile(filename, ForWriting, True)
   f.Write textstr
   f.Close
End Sub

Text = ReadAllTextFile(filename)

Text = ReplaceText(Text,Oldpatrn,Newpatrn)

'WScript.Echo text

WriteToTextFile DesFileName,text
