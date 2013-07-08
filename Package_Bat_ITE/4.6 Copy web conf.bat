::@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

set "CurrentPATH=%~dp0"
set "NB_ROOT=%CurrentPATH%..\.."
set "NB_ESinstall=%NB_ROOT%\ESinstall"
set "NB_ES=%NB_ROOT%\ES"
set "NB_DEV=%NB_ROOT%\DEV"
set "NB_ES_ESData=%NB_ES%\ESData"
set "NB_ES_CLIC=%NB_ES%\NBCLIC"
set "NB_ES_NBWSP=%NB_ES%\NBWSP"
set "NB_ES_NBWSPGW=%NB_ES%\NBWSPGW"
set "NB_ES_NBWSPLib=%NB_ES%\NBWSPLib"

set "NB_ES_CLIC_PRODUCTS=%NB_ES_CLIC%\Products"
set "NB_ES_NBWSP_PRODUCTS=%NB_ES_NBWSP%\Products"

set "NB_ES_CLIC_PRODUCTS_Current=%NB_ES_CLIC%\Products\ITE"
set "NB_ES_NBWSP_PRODUCTS_Current=%NB_ES_NBWSP%\Products\ITE"

::@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


xcopy "%NB_ES_CLIC_PRODUCTS_Current%" "%NB_ES_CLIC%"      /Y /S /F

xcopy "%NB_ES_NBWSP_PRODUCTS_Current%" "%NB_ES_NBWSP%"    /Y /S /F
