'GetUrlReturnCode.vbs

args = WScript.Arguments.Count

if args <> 1 then
  Wscript.Echo "usage: GetUrlReturnCode.vbs URL"
  wscript.Quit
end if

URL = WScript.Arguments.Item(0)

Set WshShell = WScript.CreateObject("WScript.Shell")

Set http = CreateObject("MSXML2.ServerXMLHTTP")
http.open "GET", URL, FALSE
http.send ""
'WScript.Echo http.responseText
WScript.Echo http.status

set WshShell = nothing
set http = nothing
