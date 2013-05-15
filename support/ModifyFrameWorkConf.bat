

if exist "%windir%\Microsoft.NET\Framework\v2.0.50727\CONFIG\machine.config" (
cacls %windir%\Microsoft.NET\Framework\v2.0.50727\CONFIG\machine.config /E /G Everyone:F
cscript replacefiletext.vbs "%windir%\Microsoft.NET\Framework\v2.0.50727\CONFIG\machine.config" "^<processModel autoConfig="true"/^>" "^<processModel maxWorkerThreads="100" maxIoThreads="100" minWorkerThreads="50"^>" "%windir%\Microsoft.NET\Framework\v2.0.50727\CONFIG\machine.config"
)

if exist "%windir%\Microsoft.NET\Framework64\v2.0.50727\CONFIG\machine.config" (
cacls %windir%\Microsoft.NET\Framework64\v2.0.50727\CONFIG\machine.config /E /G Everyone:F
cscript replacefiletext.vbs "%windir%\Microsoft.NET\Framework64\v2.0.50727\CONFIG\machine.config" "^<processModel autoConfig="true"/^>" "^<processModel maxWorkerThreads="100" maxIoThreads="100" minWorkerThreads="50"^>" "%windir%\Microsoft.NET\Framework64\v2.0.50727\CONFIG\machine.config"
)