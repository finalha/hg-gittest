��    �      <  �   \      (  R   )     |  
   �     �  -   �  �   �  �   n      A     5   X  J   �     �  6   �  P   ,  C   }  :   �  ]   �  4   Z  B   �  H   �  G     >   c  9   �  3   �  ?     /   P  -   �  E   �  y   �  (   n  #   �  7   �  (   �  ,     3   I  '   }  3   �  D   �  (     8   G  -   �  -   �  /   �  "     6   /  +   f     �  0   �  ;   �  $     /   ;     k  $   �  ~   �  1   -     _  /   }  J   �  �   �     �  C   �  -     8   E  !   ~  ,   �  /   �  4   �  A   2  @   t  ,   �  P   �  I   3  b   }     �     �  �     [   �     �     	     '  ;   ?  9   {  �   �  >   F  ;   �    �  u   �   q   H!  f   �!  s   !"  &   �"     �"     �"  &   �"  0   �"  .   +#  )   Z#  )   �#  "   �#  #   �#  "   �#      $  (   9$  "   b$     �$  "   �$  !   �$  ,   �$  $   %  *   7%  %   b%  !   �%     �%     �%     �%      �%     &     8&  -   S&  0   �&     �&     �&     �&  )   '     +'     /'  &   >'  %   e'     �'  +   �'  !   �'  �  �'  V   t)     �)     �)     �)  0   *  �   3*  �   �*  B  }+  w   �,  5   8-  O   n-     �-  7   �-  v   .  P   �.  D   �.  k   /  @   �/  C   �/  L   0  o   ]0  >   �0  :   1  7   G1  J   1  7   �1  0   2  O   32  �   �2  .   *3  +   Y3  <   �3  ,   �3  2   �3  @   "4  *   c4  S   �4  k   �4  7   N5  ?   �5  6   �5  8   �5  <   66  ,   s6  A   �6  %   �6      7  =   )7  Q   g7  /   �7  C   �7     -8  -   L8  �   z8  C   9  4   H9  G   }9  T   �9  �   :     �:  e   �:  0   L;  M   };  +   �;  ?   �;  A   7<  C   y<  ]   �<  G   =  0   c=  x   �=  l   >  �   z>     ?  .   +?  �   Z?  h   �?     L@     l@  "   �@  ;   �@  9   �@  �   #A  @   �A  ?   �A  <  <B  �   yC  x   �C  q   vD  v   �D  0   _E     �E     �E  /   �E  3   �E  4   F  .   MF  .   |F  "   �F  #   �F  '   �F  *   G  /   EG  (   uG     �G  '   �G  (   �G  6   H  -   FH  7   tH  (   �H  &   �H     �H     I     /I  &   MI     tI  "   �I  1   �I  7   �I     J     =J     ZJ  :   tJ     �J     �J  0   �J  /   �J     (K  6   FK  1   }K            X       m   C   U   e              q   Q   "       ^   ;   k       E   @   {   *       i          _           v          |   d      >   A   u      ?   +   o      t      h       J   �   c   [   Y   n   ]   1   a   P   W       b   D       j   �   !                         N           #   B   H      2   %   3   <          R   S   )   =   l   .             :              6      �   	   M              /       �   g      O              f               '       K   p      �      -   `   5   $   F   8              9   y   L   w   \       &       0       s             z   r       Z          
   G         V       I       ~              (   4       T          ,   }   x   7        
If the data directory is not specified, the environment variable PGDATA
is used.
 
Less commonly used options:
 
Options:
 
Other options:
 
Report bugs to <pgsql-bugs@postgresql.org>.
 
Success. You can now start the database server using:

    %s%s%spostgres%s -D %s%s%s
or
    %s%s%spg_ctl%s -D %s%s%s -l logfile start

 
WARNING: enabling "trust" authentication for local connections
You can change this by editing pg_hba.conf or using the -A option the
next time you run initdb.
       --lc-collate=, --lc-ctype=, --lc-messages=LOCALE
      --lc-monetary=, --lc-numeric=, --lc-time=LOCALE
                            set default locale in the respective category for
                            new databases (default taken from environment)
       --locale=LOCALE       set default locale for new databases
       --no-locale           equivalent to --locale=C
       --pwfile=FILE         read password for the new superuser from file
   %s [OPTION]... [DATADIR]
   -?, --help                show this help, then exit
   -A, --auth=METHOD         default authentication method for local connections
   -E, --encoding=ENCODING   set default encoding for new databases
   -L DIRECTORY              where to find the input files
   -T, --text-search-config=CFG
                            default text search configuration
   -U, --username=NAME       database superuser name
   -V, --version             output version information, then exit
   -W, --pwprompt            prompt for a password for the new superuser
   -X, --xlogdir=XLOGDIR     location for the transaction log directory
   -d, --debug               generate lots of debugging output
   -n, --noclean             do not clean up after errors
   -s, --show                show internal settings
  [-D, --pgdata=]DATADIR     location for this database cluster
 %s initializes a PostgreSQL database cluster.

 %s: "%s" is not a valid server encoding name
 %s: The password file was not generated. Please report this problem.
 %s: cannot be run as root
Please log in (using, e.g., "su") as the (unprivileged) user that will
own the server process.
 %s: could not access directory "%s": %s
 %s: could not access file "%s": %s
 %s: could not change permissions of directory "%s": %s
 %s: could not create directory "%s": %s
 %s: could not create symbolic link "%s": %s
 %s: could not determine valid short version string
 %s: could not execute command "%s": %s
 %s: could not find suitable encoding for locale %s
 %s: could not find suitable text search configuration for locale %s
 %s: could not get current user name: %s
 %s: could not obtain information about current user: %s
 %s: could not open file "%s" for reading: %s
 %s: could not open file "%s" for writing: %s
 %s: could not read password from file "%s": %s
 %s: could not write file "%s": %s
 %s: data directory "%s" not removed at user's request
 %s: directory "%s" exists but is not empty
 %s: encoding mismatch
 %s: failed to remove contents of data directory
 %s: failed to remove contents of transaction log directory
 %s: failed to remove data directory
 %s: failed to remove transaction log directory
 %s: file "%s" does not exist
 %s: file "%s" is not a regular file
 %s: input file "%s" does not belong to PostgreSQL %s
Check your installation or specify the correct path using the option -L.
 %s: input file location must be an absolute path
 %s: invalid locale name "%s"
 %s: locale %s requires unsupported encoding %s
 %s: must specify a password for the superuser to enable %s authentication
 %s: no data directory specified
You must identify the directory where the data for this database system
will reside.  Do this with either the invocation option -D or the
environment variable PGDATA.
 %s: out of memory
 %s: password prompt and password file cannot be specified together
 %s: removing contents of data directory "%s"
 %s: removing contents of transaction log directory "%s"
 %s: removing data directory "%s"
 %s: removing transaction log directory "%s"
 %s: symlinks are not supported on this platform %s: too many command-line arguments (first is "%s")
 %s: transaction log directory "%s" not removed at user's request
 %s: transaction log directory location must be an absolute path
 %s: unrecognized authentication method "%s"
 %s: warning: specified text search configuration "%s" might not match locale %s
 %s: warning: suitable text search configuration for locale %s is unknown
 Encoding %s is not allowed as a server-side encoding.
Rerun %s with a different locale selection.
 Enter it again:  Enter new superuser password:  If you want to create a new database system, either remove or empty
the directory "%s" or run %s
with an argument other than "%s".
 If you want to store the transaction log there, either
remove or empty the directory "%s".
 Passwords didn't match.
 Rerun %s with the -E option.
 Running in debug mode.
 Running in noclean mode.  Mistakes will not be cleaned up.
 The database cluster will be initialized with locale %s.
 The database cluster will be initialized with locales
  COLLATE:  %s
  CTYPE:    %s
  MESSAGES: %s
  MONETARY: %s
  NUMERIC:  %s
  TIME:     %s
 The default database encoding has accordingly been set to %s.
 The default text search configuration will be set to "%s".
 The encoding you selected (%s) and the encoding that the
selected locale uses (%s) do not match.  This would lead to
misbehavior in various character string processing functions.
Rerun %s and either do not specify an encoding explicitly,
or choose a matching combination.
 The files belonging to this database system will be owned by user "%s".
This user must also own the server process.

 The program "postgres" is needed by %s but was not found in the
same directory as "%s".
Check your installation.
 The program "postgres" was found by "%s"
but was not the same version as %s.
Check your installation.
 This might mean you have a corrupted installation or identified
the wrong directory with the invocation option -L.
 Try "%s --help" for more information.
 Usage:
 caught signal
 child process exited with exit code %d child process exited with unrecognized status %d child process was terminated by exception 0x%X child process was terminated by signal %d child process was terminated by signal %s copying template1 to postgres ...  copying template1 to template0 ...  could not change directory to "%s" could not find a "%s" to execute could not identify current directory: %s could not open directory "%s": %s
 could not read binary "%s" could not read directory "%s": %s
 could not read symbolic link "%s" could not remove file or directory "%s": %s
 could not set junction for "%s": %s
 could not stat file or directory "%s": %s
 could not write to child process: %s
 creating configuration files ...  creating conversions ...  creating dictionaries ...  creating directory %s ...  creating information schema ...  creating subdirectories ...  creating system views ...  creating template1 database in %s/base/1 ...  fixing permissions on existing directory %s ...  initializing dependencies ...  initializing pg_authid ...  invalid binary "%s" loading system objects' descriptions ...  ok
 out of memory
 selecting default max_connections ...  selecting default shared_buffers ...  setting password ...  setting privileges on built-in objects ...  vacuuming database template1 ...  Project-Id-Version: initdb (PostgreSQL 8.2)
Report-Msgid-Bugs-To: pgsql-bugs@postgresql.org
POT-Creation-Date: 2009-04-13 15:11+0000
PO-Revision-Date: 2009-04-13 17:21-0400
Last-Translator: �lvaro Herrera <alvherre@alvh.no-ip.org>
Language-Team: PgSQL-es-Ayuda <pgsql-es-ayuda@postgresql.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
 
Si el directorio de datos no es especificado, se usa la variable de
ambiente PGDATA.
 
Opciones menos usadas:
 
Opciones:
 
Otras opciones:
 
Reporte errores a <pgsql-bugs@postgresql.org>.
 
Completado. Puede iniciar el servidor de bases de datos usando:

    %s%s%spostgres%s -D %s%s%s
o
    %s%s%spg_ctl%s -D %s%s%s -l archivo_de_registro start

 
ATENCI�N: activando autentificaci�n �trust� para conexiones locales.
Puede cambiar esto editando pg_hba.conf o usando el par�metro -A
la pr�xima vez que ejecute initdb.
       --lc-collate=, --lc-ctype=, --lc-messages=LOCALE
      --lc-monetary=, --lc-numeric=, --lc-time=LOCALE
                            inicializar usando esta configuraci�n local
                            en la categor�a respectiva (el valor por omisi�n
                            es tomado de variables de ambiente)
       --locale=LOCALE       configuraci�n regional por omisi�n para 
                            nuevas bases de datos
       --no-locale           equivalente a --locale=C
       --pwfile=ARCHIVO      leer contrase�a del nuevo superusuario del archivo
   %s [OPCI�N]... [DATADIR]
   -?, --help                mostrar esta ayuda y salir
   -A, --auth=METODO         m�todo de autentificaci�n por omisi�n para
                            conexiones locales
   -E, --encoding=CODIF      codificaci�n por omisi�n para nuevas bases de datos
   -L DIRECTORIO             donde encontrar los archivos de entrada
   -T, --text-search-config=CONF
                            configuraci�n de b�squeda en texto por omisi�n
   -U, --username=USUARIO    nombre del superusuario del cluster
   -V, --version             mostrar informaci�n de version y salir
   -W, --pwprompt            pedir una contrase�a para el nuevo superusuario
   -X, --xlogdir=XLOGDIR     ubicaci�n del directorio del registro de
                            transacciones
   -d, --debug               genera mucha salida de depuraci�n
   -n, --noclean             no limpiar despu�s de errores
   -s, --show                muestra variables internas
  [-D, --pgdata=]DATADIR     ubicaci�n para este cluster de bases de datos
 %s inicializa un cluster de base de datos PostgreSQL.

 %s: �%s� no es un nombre v�lido de codificaci�n
 %s: El archivo de contrase�a no fue generado.
Por favor reporte este problema.
 %s: no se puede ejecutar como �root�
Por favor con�ctese (usando, por ejemplo, �su�) como un usuario sin
privilegios especiales, quien ejecutar� el proceso servidor.
 %s: no se pudo acceder al directorio �%s�: %s
 %s: no se pudo acceder al archivo �%s�: %s
 %s: no se pudo cambiar los permisos del directorio �%s�: %s
 %s: no se pudo crear el directorio �%s�: %s
 %s: no se pudo crear el enlace simb�lico �%s�: %s
 %s: no se pudo determinar una cadena corta de n�mero de versi�n
 %s: no se pudo ejecutar la orden �%s�: %s
 %s: no se pudo encontrar una codificaci�n apropiada para
la configuraci�n local %s
 %s: no se pudo encontrar una configuraci�n para b�squeda en texto apropiada
para la configuraci�n local %s
 %s: no se pudo obtener el nombre de usuario actual: %s
 %s: no se pudo obtener informaci�n sobre el usuario actual: %s
 %s: no se pudo abrir el archivo �%s� para lectura: %s
 %s: no se pudo abrir el archivo �%s� para escritura: %s
 %s: no se pudo leer la contrase�a desde el archivo �%s�: %s
 %s: no se pudo escribir el archivo �%s�: %s
 %s: directorio de datos �%s� no eliminado a petici�n del usuario
 %s: el directorio �%s� no est� vac�o
 %s: codificaciones no coinciden
 %s: no se pudo eliminar el contenido del directorio de datos
 %s: no se pudo eliminar el contenido del directorio de registro de transacciones
 %s: no se pudo eliminar el directorio de datos
 %s: no se pudo eliminar el directorio de registro de transacciones
 %s: el archivo �%s� no existe
 %s: el archivo �%s� no es un archivo regular
 %s: el archivo de entrada �%s� no pertenece a PostgreSQL %s
Verifique su instalaci�n o especifique la ruta correcta usando la opci�n -L.
 %s: la ubicaci�n de archivos de entrada debe ser una ruta absoluta
 %s: nombre de configuraci�n local �%s� no es v�lido
 %s: la configuraci�n local %s requiere la codificaci�n no soportada %s
 %s: debe especificar una contrase�a al superusuario para activar
autentificaci�n %s
 %s: no se especific� un directorio de datos.
Debe especificar el directorio donde residir�n los datos para este cluster.
H�galo usando la opci�n -D o la variable de ambiente PGDATA.
 %s: memoria agotada
 %s: la petici�n de contrase�a y el archivo de contrase�a no pueden
ser especificados simult�neamente
 %s: eliminando el contenido del directorio �%s�
 %s: eliminando el contenido del directorio de registro de transacciones �%s�
 %s: eliminando el directorio de datos �%s�
 %s: eliminando el directorio de registro de transacciones �%s�
 %s: los enlaces simb�licos no est�n soportados en esta plataforma %s: demasiados argumentos de l�nea de �rdenes (el primero es �%s�)
 %s: el directorio de registro de transacciones �%s� no fue eliminado 
a petici�n del usuario
 %s: la ubicaci�n de archivos de transacci�n debe ser una ruta absoluta
 %s: m�todo de autentificaci�n desconocido: �%s�
 %s: atenci�n: la configuraci�n de b�squeda en texto �%s� especificada
podr�a no coincidir con la configuraci�n local %s
 %s: atenci�n: la configuraci�n de b�squeda en texto apropiada para
la configuraci�n local %s es desconocida
 La codificaci�n %s no puede ser usada como codificaci�n del lado
del servidor.
Ejecute %s nuevamente con una selecci�n de configuraci�n local diferente.
 Ingr�sela nuevamente:  Ingrese la nueva contrase�a del superusuario:  Si quiere crear un nuevo cluster de bases de datos, elimine o vac�e
el directorio �%s�, o ejecute %s
con un argumento distinto de �%s�.
 Si quiere almacenar el directorio de registro de transacciones ah�,
elimine o vac�e el directorio �%s�.
 Las constrase�as no coinciden.
 Ejecute %s con la opci�n -E.
 Ejecutando en modo de depuraci�n.
 Ejecutando en modo sucio.  Los errores no ser�n limpiados.
 El cluster ser� inicializado con configuraci�n local %s.
 El cluster ser� inicializado con las configuraciones locales
  COLLATE:  %s
  CTYPE:    %s
  MESSAGES: %s
  MONETARY: %s
  NUMERIC:  %s
  TIME:     %s
 La codificaci�n por omisi�n ha sido por lo tanto definida a %s.
 La configuraci�n de b�squeda en texto ha sido definida a �%s�.
 La codificaci�n que seleccion� (%s) y la codificaci�n de la configuraci�n
local elegida (%s) no coinciden.  Esto llevar�a a comportamientos
err�ticos en ciertas funciones de procesamiento de cadenas de caracteres.
Ejecute %s nuevamente y no especifique una codificaci�n, o bien especifique
una combinaci�n adecuada.
 Los archivos de este cluster ser�n de propiedad del usuario �%s�.
Este usuario tambi�n debe ser quien ejecute el proceso servidor.
 %s necesita el programa �postgres�, pero no pudo encontrarlo en el mismo
directorio que �%s�.
Verifique su instalaci�n.
 El programa �postgres� fue encontrado por %s, pero no es
de la misma versi�n que �%s�.
Verifique su instalaci�n.
 Esto puede significar que tiene una instalaci�n corrupta o ha
identificado el directorio equivocado con la opci�n -L.
 Use �%s --help� para obtener mayor informaci�n.
 Empleo:
 se ha capturado una se�al
 el proceso hijo termin� con c�digo de salida %d el proceso hijo termin� con c�digo no reconocido %d el proceso hijo fue terminado por una excepci�n 0x%X el proceso hijo fue terminado por una se�al %d el proceso hijo fue terminado por una se�al %s copiando template1 a postgres ...  copiando template1 a template0 ...  no se pudo cambiar el directorio a �%s� no se pudo encontrar un �%s� para ejecutar no se pudo identificar el directorio actual: %s no se pudo abrir el directorio �%s�: %s
 no se pudo leer el binario �%s� no se pudo leer el directorio �%s�: %s
 no se pudo leer el enlace simb�lico �%s� no se pudo borrar el archivo o el directorio �%s�: %s
 no se pudo definir un junction para �%s�: %s
 no se pudo hacer stat al archivo o directorio �%s�: %s
 no se pudo escribir al proceso hijo: %s
 creando archivos de configuraci�n ...  creando conversiones ...  creando directorios ...  creando el directorio %s ...  creando el esquema de informaci�n ...  creando subdirectorios ...  creando las vistas de sistema ...  creando base de datos template1 en %s/base/1 ...  corrigiendo permisos en el directorio existente %s ...  inicializando dependencias ...  inicializando pg_authid ...  binario �%s� no es v�lido cargando las descripciones de los objetos del sistema ...  hecho
 memoria agotada
 seleccionando el valor para max_connections ...  seleccionando el valor para shared_buffers ...  estableciendo contrase�a ...  estableciendo privilegios en objetos predefinidos ...  haciendo vacuum a la base de datos template1 ...  