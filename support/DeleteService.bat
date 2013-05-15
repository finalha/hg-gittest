set servicename=%~1

sc stop "%servicename%"


sc delete "%servicename%"