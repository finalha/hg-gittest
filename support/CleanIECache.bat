echo clean IE cache >> %1
echo del /f /s /q "%userprofile%\Local Settings\Temporary Internet Files\*.*" /S /Q /F >> %1
del "%userprofile%\Local Settings\Temporary Internet Files\*.*" /S /Q /F
echo "%userprofile%\AppData\Local\Microsoft\Windows\Temporary Internet Files\*.*" /S /Q /F >> %1
del "%userprofile%\AppData\Local\Microsoft\Windows\Temporary Internet Files\*.*" /S /Q /F
echo clean IE cache ok >> %1