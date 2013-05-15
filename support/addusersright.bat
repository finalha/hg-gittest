@echo add users rights to directory: %1 >> %2
cacls %1 /E /C /G Users:F >> %2


