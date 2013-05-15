Set TypeLib = CreateObject("Scriptlet.TypeLib")
strGUID = TypeLib.Guid
strGUID = Left(TypeLib.Guid,38)
WScript.Echo strGUID

'Set TypeLib1 = CreateObject("Scriptlet.TypeLib")
'strGUID1 = TypeLib1.Guid
'strGUID = Left(TypeLib.Guid,38)
'WScript.Echo strGUID1