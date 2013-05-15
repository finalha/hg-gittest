��    l      |  �   �      0	      1	     R	  &   d	     �	     �	  -   �	     �	     
  |   +
     �
  a   �
  K   *     v  A   �  !   �  3   �  ?   )  ?   i  H   �  D   �  E   7  ?   }  >   �  9   �  B   6  <   y  z   �  0   1  F   b  >   �  8   �  2   !  O   T  7   �     �     �  �   �  !   }  C   �  y   �  C   ]  D   �  >   �  A   %  *   g  /   �  %   �  /   �  #        <  3   Z  0   �  ,   �  .   �  3     -   O  0   }  5   �  "   �  $     J   ,     w     �  3   �  0   �          "  !   A  $   c      �  -   �  4   �  %     $   2  "   W  F   z  F   �       7     )   T  q   ~  f   �  %   W  &   }     �  d   �       &   0  0   W  .   �  )   �  )   �  "         .  (   O     x  !   �     �     �     �     �               )     9  "   Q     t  �  �  *        B  (   V  "     %   �  0   �     �  (      y   <      �   e   �   K   <!     �!  B   �!     �!  4   "  C   :"  G   ~"  r   �"  w   9#  ~   �#  N   0$  k   $  9   �$  F   %%  A   l%  �   �%  5   ;&  J   q&  G   �&  K   '  8   P'  h   �'  I   �'     <(     D(  �   L(  %   �(  S   %)  �   y)  d   *  e   s*  Y   �*  c   3+  .   �+  0   �+  0   �+  :   (,  ,   c,  $   �,  >   �,  -   �,  1   "-  /   T-  F   �-  @   �-  <   .  @   I.  ,   �.  -   �.  O   �.     5/  !   U/  ;   w/  >   �/     �/     0  -   &0  (   T0  +   }0  B   �0  C   �0  )   01  '   Z1  '   �1  O   �1  C   �1      >2  A   _2  )   �2  x   �2  q   D3  4   �3  .   �3     4  �   #4  '   �4  /   �4  3   �4  4   25  .   g5  .   �5  '   �5  *   �5  /   6     H6  (   h6     �6     �6     �6  $   �6     7     7     17  '   D7  '   l7  &   �7               5      6         Y                      (      9   .   #          e           '   R   [   W   K   <   ]   f      B   D   &       P   H          -   %              j   
   7       T   :                   G   A       4      C           \   *   c   Z   J                 d       `   	   F   @       !   "       ,   =      3       k               U   h      V                   S   L       1   $      ?   2       /      ^   O          N   l   8   +   >           b   i                 _             Q   M   g   E   X           a   0       )   I   ;           
Allowed signal names for kill:
 
Common options:
 
Options for register and unregister:
 
Options for start or restart:
 
Options for stop or restart:
 
Report bugs to <pgsql-bugs@postgresql.org>.
 
Shutdown modes are:
   %s kill    SIGNALNAME PID
   %s register   [-N SERVICENAME] [-U USERNAME] [-P PASSWORD] [-D DATADIR]
                    [-w] [-t SECS] [-o "OPTIONS"]
   %s reload  [-D DATADIR] [-s]
   %s restart [-w] [-t SECS] [-D DATADIR] [-s] [-m SHUTDOWN-MODE]
                 [-o "OPTIONS"]
   %s start   [-w] [-t SECS] [-D DATADIR] [-s] [-l FILENAME] [-o "OPTIONS"]
   %s status  [-D DATADIR]
   %s stop    [-W] [-t SECS] [-D DATADIR] [-s] [-m SHUTDOWN-MODE]
   %s unregister [-N SERVICENAME]
   --help                 show this help, then exit
   --version              output version information, then exit
   -D, --pgdata DATADIR   location of the database storage area
   -N SERVICENAME  service name with which to register PostgreSQL server
   -P PASSWORD     password of account to register PostgreSQL server
   -U USERNAME     user name of account to register PostgreSQL server
   -W                     do not wait until operation completes
   -c, --core-files       allow postgres to produce core files
   -c, --core-files       not applicable on this platform
   -l, --log FILENAME     write (or append) server log to FILENAME
   -m SHUTDOWN-MODE   can be "smart", "fast", or "immediate"
   -o OPTIONS             command line options to pass to postgres
                         (PostgreSQL server executable)
   -p PATH-TO-POSTGRES    normally not necessary
   -s, --silent           only print errors, no informational messages
   -t SECS                seconds to wait when using -w option
   -w                     wait until operation completes
   fast        quit directly, with proper shutdown
   immediate   quit without complete shutdown; will lead to recovery on restart
   smart       quit after all clients have disconnected
  done
  failed
 %s is a utility to start, stop, restart, reload configuration files,
report the status of a PostgreSQL server, or signal a PostgreSQL process.

 %s: PID file "%s" does not exist
 %s: another server might be running; trying to start server anyway
 %s: cannot be run as root
Please log in (using, e.g., "su") as the (unprivileged) user that will
own the server process.
 %s: cannot reload server; single-user server is running (PID: %ld)
 %s: cannot restart server; single-user server is running (PID: %ld)
 %s: cannot set core file size limit; disallowed by hard limit
 %s: cannot stop server; single-user server is running (PID: %ld)
 %s: could not find own program executable
 %s: could not find postgres program executable
 %s: could not open PID file "%s": %s
 %s: could not open service "%s": error code %d
 %s: could not open service manager
 %s: could not read file "%s"
 %s: could not register service "%s": error code %d
 %s: could not send reload signal (PID: %ld): %s
 %s: could not send signal %d (PID: %ld): %s
 %s: could not send stop signal (PID: %ld): %s
 %s: could not start server
Examine the log output.
 %s: could not start server: exit code was %d
 %s: could not start service "%s": error code %d
 %s: could not unregister service "%s": error code %d
 %s: invalid data in PID file "%s"
 %s: missing arguments for kill mode
 %s: no database directory specified and environment variable PGDATA unset
 %s: no operation specified
 %s: no server running
 %s: old server process (PID: %ld) seems to be gone
 %s: option file "%s" must have exactly one line
 %s: out of memory
 %s: server does not shut down
 %s: server is running (PID: %ld)
 %s: service "%s" already registered
 %s: service "%s" not registered
 %s: single-user server is running (PID: %ld)
 %s: too many command-line arguments (first is "%s")
 %s: unrecognized operation mode "%s"
 %s: unrecognized shutdown mode "%s"
 %s: unrecognized signal name "%s"
 (The default is to wait for shutdown, but not for start or restart.)

 If the -D option is omitted, the environment variable PGDATA is used.
 Is server running?
 Please terminate the single-user server and try again.
 Server started and accepting connections
 The program "postgres" is needed by %s but was not found in the
same directory as "%s".
Check your installation.
 The program "postgres" was found by "%s"
but was not the same version as %s.
Check your installation.
 Timed out waiting for server startup
 Try "%s --help" for more information.
 Usage:
 WARNING: online backup mode is active
Shutdown will not complete until pg_stop_backup() is called.

 Waiting for server startup...
 child process exited with exit code %d child process exited with unrecognized status %d child process was terminated by exception 0x%X child process was terminated by signal %d child process was terminated by signal %s could not change directory to "%s" could not find a "%s" to execute could not identify current directory: %s could not read binary "%s" could not read symbolic link "%s" could not start server
 invalid binary "%s" server shutting down
 server signaled
 server started
 server starting
 server stopped
 starting server anyway
 waiting for server to shut down... waiting for server to start... Project-Id-Version: pg_ctl (PostgreSQL 8.4)
Report-Msgid-Bugs-To: pgsql-bugs@postgresql.org
POT-Creation-Date: 2009-04-16 03:18+0000
PO-Revision-Date: 2009-04-16 13:19-0400
Last-Translator: �lvaro Herrera <alvherre@alvh.no-ip.org>
Language-Team: PgSQL Espa�ol <pgsql-es-ayuda@postgresql.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
 
Nombres de se�ales permitidos para kill:
 
Opciones comunes:
 
Opciones para registrar y dar de baja:
 
Opciones para inicio y reinicio:
 
Opciones para detenci�n y reinicio:
 
Reporte errores a <pgsql-bugs@postgresql.org>.
 
Modos de detenci�n son:
   %s kill    NOMBRE-SE�AL ID-DE-PROCESO
   %s register   [-N SERVICIO] [-U USUARIO] [-P PASSWORD] [-D DATADIR]
                    [-w] [-t SEGS] [-o �OPCIONES�]
   %s reload  [-D DATADIR] [-s]
   %s restart [-w] [-t SEGS] [-D DATADIR] [-s] [-m MODO-DETENCI�N]
                   [-o �OPCIONES�]
   %s start   [-w] [-t SEGS] [-D DATADIR] [-s] [-l ARCHIVO] [-o �OPCIONES�]
   %s status  [-D DATADIR]
   %s stop    [-W] [-t SEGS] [-D DATADIR] [-s] [-m MODO-DETENCI�N]
   %s unregister [-N SERVICIO]
   --help                 mostrar este texto y salir
   --version              mostrar informaci�n sobre versi�n y salir
   -D, --pgdata DATADIR   ubicaci�n del �rea de almacenamiento de datos
   -N SERVICIO            nombre de servicio con el cual registrar
                         el servidor PostgreSQL
   -P CONTRASE�A          contrase�a de la cuenta con la cual registrar
                         el servidor PostgreSQL
   -U USUARIO             nombre de usuario de la cuenta con la cual
                         registrar el servidor PostgreSQL
   -W                     no esperar hasta que la operaci�n se haya completado
   -c, --core-files       permite que postgres produzca archivos
                         de volcado (core)
   -c, --core-files       no aplicable en esta plataforma
   -l  --log ARCHIVO      guardar el registro del servidor en ARCHIVO.
   -m MODO-DE-DETENCI�N   puede ser �smart�, �fast� o �immediate�
   -o OPCIONES            par�metros de l�nea de �rdenes a pasar a postgres
                         (ejecutable del servidor de PostgreSQL)
   -p RUTA-A-POSTGRES     normalmente no es necesario
   -s, --silent           mostrar s�lo errores, no mensajes de informaci�n
   -t SEGS                segundos a esperar cuando se use la opci�n -w
   -w                     esperar hasta que la operaci�n se haya completado
   fast        salir directamente, con apagado apropiado
   immediate   salir sin apagado completo; se ejecutar� recuperaci�n
              en el pr�ximo inicio

   smart       salir despu�s que todos los clientes se hayan desconectado
  listo
  fall�
 %s es un programa para iniciar, detener, reiniciar, recargar archivos de
configuraci�n, reportar el estado de un servidor PostgreSQL o enviar una
se�al a un proceso PostgreSQL.

 %s: el archivo de PID �%s� no existe
 %s: otro servidor puede estar en ejecuci�n; tratando de iniciarlo de todas formas.
 %s: no puede ser ejecutado como root
Por favor con�ctese (por ej. usando �su�) con un usuario no privilegiado,
quien ejecutar� el proceso servidor.
 %s: no se puede recargar el servidor;
un servidor en modo mono-usuario est� en ejecuci�n (PID: %ld)
 %s: no se puede reiniciar el servidor;
un servidor en modo mono-usuario est� en ejecuci�n (PID: %ld)
 %s: no se puede establecer el l�mite de archivos de volcado;
impedido por un l�mite duro
 %s: no se puede detener el servidor;
un servidor en modo mono-usuario est� en ejecuci�n (PID: %ld)
 %s: no se pudo encontrar el propio ejecutable
 %s: no se pudo encontrar el ejecutable postgres
 %s: no se pudo abrir el archivo de PID �%s�: %s
 %s: no se pudo abrir el servicio �%s�: c�digo de error %d
 %s: no se pudo abrir el gestor de servicios
 %s: no se pudo leer el archivo �%s�
 %s: no se pudo registrar el servicio �%s�: c�digo de error %d
 %s: la se�al de recarga fall� (PID: %ld): %s
 %s: no se pudo enviar la se�al %d (PID: %ld): %s
 %s: fall� la se�al de detenci�n (PID: %ld): %s
 %s: no se pudo iniciar el servidor.
Examine el registro del servidor.
 %s: no se pudo iniciar el servidor: el c�digo de retorno fue %d
 %s: no se pudo iniciar el servicio �%s�: c�digo de error %d
 %s: no se pudo dar de baja el servicio �%s�: c�digo de error %d
 %s: datos no v�lidos en archivo de PID �%s�
 %s: argumentos faltantes para env�o de se�al
 %s: no se especific� directorio de datos y la variable PGDATA no est� definida
 %s: no se especific� operaci�n
 %s: no hay servidor en ejecuci�n
 %s: el proceso servidor antiguo (PID: %ld) parece no estar
 %s: archivo de opciones �%s� debe tener exactamente una l�nea
 %s: memoria agotada
 %s: el servidor no se detiene
 %s: el servidor est� en ejecuci�n (PID: %ld)
 %s: el servicio �%s� ya est� registrado
 %s: el servicio �%s� no ha sido registrado
 %s: un servidor en modo mono-usuario est� en ejecuci�n (PID: %ld)
 %s: demasiados argumentos de l�nea de �rdenes (el primero es �%s�)
 %s: modo de operaci�n �%s� no reconocido
 %s: modo de apagado �%s� no reconocido
 %s: nombre de se�al �%s� no reconocido
 (Por omisi�n se espera para las detenciones, pero no los inicios o reinicios)

 Si la opci�n -D es omitida, se usa la variable de ambiente PGDATA.
 �Est� el servidor en ejecuci�n?
 Por favor termine el servidor mono-usuario e intente nuevamente.
 Servidor iniciado y aceptando conexiones
 %s necesita el programa �postgres�, pero no pudo encontrarlo en el mismo
directorio que �%s�.
Verifique su instalaci�n.
 El programa �postgres� fue encontrado por %s, pero no es
de la misma versi�n que �%s�.
Verifique su instalaci�n.
 Se agot� el tiempo de espera al inicio del servidor
 Use �%s --help� para obtener m�s informaci�n.
 Empleo:
 ATENCI�N: el modo de respaldo en l�nea est� activo
El apagado no se completar� hasta que se invoque la funci�n pg_stop_backup().

 Esperando que el servidor se inicie...
 el proceso hijo termin� con c�digo de salida %d el proceso hijo termin� con c�digo no reconocido %d el proceso hijo fue terminado por una excepci�n 0x%X el proceso hijo fue terminado por una se�al %d el proceso hijo fue terminado por una se�al %s no se pudo cambiar el directorio a �%s� no se pudo encontrar un �%s� para ejecutar no se pudo identificar el directorio actual: %s no se pudo leer el binario �%s� no se pudo leer el enlace simb�lico �%s� no se pudo iniciar el servidor
 el binario %s no es v�lida servidor deteni�ndose
 se ha enviado una se�al al servidor
 servidor iniciado
 servidor inici�ndose
 servidor detenido
 iniciando el servidor de todas maneras
 esperando que el servidor se detenga... esperando que el servidor se inicie... 