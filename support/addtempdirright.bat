@echo "ADD TEMP DIR RIGHTS" >>%1
cacls "%windir%\Microsoft.NET\Framework\v2.0.50727\Temporary ASP.NET Files" /E /G "NetWork Service":F >>%1
cacls "%windir%\Microsoft.NET\Framework64\v2.0.50727\Temporary ASP.NET Files" /E /G "NetWork Service":F>>%1
cacls %windir%\TEMP /E /G "NetWork Service":F >>%1
cacls "%windir%\Microsoft.NET\Framework\v2.0.50727\Temporary ASP.NET Files" /E /G users:F >>%1
cacls "%windir%\Microsoft.NET\Framework64\v2.0.50727\Temporary ASP.NET Files" /E /G users:F>>%1
cacls "%windir%\TEMP" /E /G users:F >>%1
cacls "%windir%\Microsoft.NET\Framework\v2.0.50727\CONFIG\machine.config" /E /G users:F >>%1
cacls "%windir%\Microsoft.NET\Framework64\v2.0.50727\CONFIG\machine.config" /E /G users:F >>%1

