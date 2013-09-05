Option Explicit
On Error Resume Next

Const cdoSendUsingPort = 2
Const cdoSendUsingMethod = "http://schemas.microsoft.com/cdo/configuration/sendusing"
Const cdoSMTPServer = "http://schemas.microsoft.com/cdo/configuration/smtpserver"
Const cdoSMTPServerPort = "http://schemas.microsoft.com/cdo/configuration/smtpserverport"
Const SmtpServer = "10.10.10.10"
Const MailFrom = "service@networkbrain.com"

Dim WshShell, objArgs, objMsg, iConf, Flds
Dim textFile, strTo, strCC, strFrom, strSubject
Dim strAttachFile

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''''                 Pre-definition
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Function ReadAllTextFile(filename)
  Const ForReading = 1, ForWriting = 2
  Dim fso, f
  Set fso = CreateObject("Scripting.FileSystemObject")
  Set f = fso.OpenTextFile(filename, ForReading)
  ReadAllTextFile =   f.ReadAll
  f.close
End Function

Function GetFilePath(filename)
   Dim fso, d, f, s
   Set fso = CreateObject("Scripting.FileSystemObject")
   Set f = fso.GetFile(filename)   
   GetFilePath = f.Path
End Function

Function GetAnExtension(DriveSpec)
   Dim fso
   Set fso = CreateObject("Scripting.FileSystemObject")
   GetAnExtension = fso.GetExtensionName(Drivespec)
End Function
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

Set WshShell = CreateObject("WScript.Shell")

Set objArgs = WScript.Arguments
If objArgs.Count < 3 Then
   WScript.Echo "No File Input or Mail Address!"
   WScript.Quit (1)
End If

strSubject = objArgs(0)
textFile = objArgs(1)
strTo = objArgs(2)
If objArgs.Count >= 4 Then
		strCC = objArgs(3)
End If
If objArgs.Count = 5 Then
		strAttachFile = objArgs(4)
    strAttachFile = GetFilePath(strAttachFile)
End If


Set objMsg = WScript.CreateObject("CDO.Message")
Set iConf = WScript.CreateObject("CDO.Configuration")

Set Flds = iConf.Fields


' Set the configuration
Flds(cdoSendUsingMethod) = cdoSendUsingPort
Flds(cdoSMTPServer) = SmtpServer 'set smtp server
Flds.Update

strFrom = MailFrom

objMsg.From = strFrom
objMsg.To = strTo
objMsg.Cc = strCC
objMsg.Subject = strSubject

If  UCase("html") = UCase(GetAnExtension(textFile)) Then
  objMsg.CreateMHTMLBody "file://" & textFile
Else
  objMsg.TextBody = ReadAllTextFile(textFile)
End If

objMsg.Configuration = iConf

If Not IsNull(strAttachFile) And strAttachFile <> "" Then
  objMsg.AddAttachment(strAttachFile)
End If

objMsg.Send

'delete boject
Set objMsg = Nothing      