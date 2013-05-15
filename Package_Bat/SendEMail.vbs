Option Explicit
'On Error Resume Next

Const cdoSendUsingPort = 2
Const cdoSendUsingMethod = "http://schemas.microsoft.com/cdo/configuration/sendusing"
Const cdoSMTPServer = "http://schemas.microsoft.com/cdo/configuration/smtpserver"
Const cdoSMTPServerPort = "http://schemas.microsoft.com/cdo/configuration/smtpserverport"

Dim WshShell, objArgs, objMsg, iConf, Flds
Dim strMsg, strTo, strCC, strFrom, strSubject
Set WshShell = CreateObject("WScript.Shell")

Set objArgs = WScript.Arguments
'No Argument then Quit
If objArgs.Count < 2 Then
   WshShell.Popup "No File Input or Mail Address!"
   WScript.Quit
End If


' Send Mail
strFrom = "service@networkbrain.com"

strSubject = objArgs(0)
strMsg = objArgs(1)
strTo = objArgs(2)
If objArgs.Count = 4 Then
		strCC = objArgs(3)
End If


Set objMsg = WScript.CreateObject("CDO.Message")
Set iConf = WScript.CreateObject("CDO.Configuration")

Set Flds = iConf.Fields

' Set the configuration
Flds(cdoSendUsingMethod) = cdoSendUsingPort
Flds(cdoSMTPServer) = "10.10.10.10" 'set smtp server
Flds.Update

objMsg.From = strFrom
objMsg.To = strTo
objMsg.Cc = strCC
objMsg.Subject = strSubject
objMsg.TextBody = strMsg
objMsg.Configuration = iConf
objMsg.Send

'delete boject
Set objMsg = Nothing