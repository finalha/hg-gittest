��    �        �   �	      H  K   I     �  f   �  
     >     >   \  =   �  -   �  C     A   K     �  #   �     �  (   �       <   +  9   h  6   �  H   �  E   "  B   h  9   �  C   �  9   )  4   c  E   �  =   �  .     ;   K  E   �  :   �  5     7   >  9   v  7   �  4   �  L     J   j  5   �  2   �  7     2   V  2   �  J   �  :     5   B  G   x  0   �  <   �  0   .  M   _  J   �  G   �  4   @  H   u  E   �  9     v   >  <   �  I   �  @   <  5   }  4   �  1   �  ;     5   V  6   �  3   �  4   �  =   ,  8   j  8   �  8   �  2     9   H  6   �  9   �     �  /   �  <   /  #   l  #   �  ?   �  %   �  #         >   3   ^   &   �   5   �   E   �   I   5!  5   !  I   �!  5   �!  E   5"  F   {"  4   �"  D   �"     <#  *   Z#  8   �#  6   �#  %   �#  (   $  (   D$  8   m$  #   �$      �$     �$  8   %  4   D%  $   y%     �%  ,   �%  ,   �%  ;   &  9   T&     �&     �&     �&  *   �&  8   �&  ,   8'  8   e'  #   �'  G   �'  4   
(     ?(  )   \(  7   �(     �(     �(  !   �(  +   )     /)     @)     \)     y)     �)     �)  
   �)     �)     �)     �)  '   *  "   7*  2   Z*  7   �*     �*  &   �*     �*     �*     �*     +  :   +     L+     N+  �  R+  ^   �,     ;-  X   T-     �-  O   �-  O   	.  N   Y.  0   �.  L   �.  J   &/      q/  +   �/  "   �/  *   �/     0  7   %0  7   ]0  9   �0  C   �0  C   1  G   W1  B   �1  H   �1  @   +2  >   l2  3   �2  9   �2  8   3  @   R3  J   �3  A   �3  ?    4  <   `4  <   �4  @   �4  @   5  y   \5  }   �5  ?   T6  ?   �6  <   �6  ?   7  >   Q7  x   �7  ?   	8  4   I8  s   ~8  6   �8  F   )9  6   p9  F   �9  F   �9  J   5:  1   �:  I   �:  I   �:  7   F;  �   ~;  8   <  H   H<  J   �<  F   �<  0   #=  0   T=  2   �=  8   �=  <   �=  9   .>  @   h>  W   �>  7   ?  7   9?  C   q?  C   �?  4   �?  4   .@  9   c@     �@  ;   �@  L   �@  '   2A  %   ZA  D   �A  +   �A  -   �A  "   B  9   BB  4   |B  L   �B  b   �B  _   aC  M   �C  ^   D  L   nD  b   �D  b   E  L   �E  `   �E  (   /F  ;   XF  N   �F  H   �F  .   ,G  1   [G  7   �G  @   �G  )   H  /   0H  2   `H  E   �H  E   �H  +   I  +   KI  /   wI  *   �I  @   �I  >   J     RJ     mJ  (   �J  :   �J  M   �J  =   8K  M   vK  -   �K  ]   �K  1   PL  &   �L  5   �L  H   �L     (M  "   8M  0   [M  9   �M     �M  %   �M  &   N  *   +N     VN  %   ]N     �N  *   �N  $   �N     �N  /   �N  %   (O  ;   NO  8   �O  
   �O  +   �O     �O     P     P     P  =   P     WP     YP     2   F   6   ]       m          �   8   _       t           �   �       P          �   Q   x                      <   e      c          k          >   l          �       �       ~   S   ;       %   @           !   r          C   K           �   f   3      G   Z   o      E   �       W   i   &   =   (      	   /   O   \   �   A           n   s   �       0      �   �   ^   }   d   �   �      �   #   J   Y   �             �   g   ?   :   y   +          {   1   w   �      �       z       -   4                   .                 q   �   5      `                      b       U   L   h   [      
   )       �   H   �   �   �   I   9      �           M   �   R   N           V   a   �   p   v          j   X               �       ,   �   "      |   �       *      �   B   $   7      u      '       T          D    
By default, a database with the same name as the current user is created.
 
Connection options:
 
If one of -d, -D, -r, -R, -s, -S, and ROLENAME is not specified, you will
be prompted interactively.
 
Options:
 
Read the description of the SQL command CLUSTER for details.
 
Read the description of the SQL command REINDEX for details.
 
Read the description of the SQL command VACUUM for details.
 
Report bugs to <pgsql-bugs@postgresql.org>.
       --lc-collate=LOCALE      LC_COLLATE setting for the database
       --lc-ctype=LOCALE        LC_CTYPE setting for the database
   %s [OPTION]... DBNAME
   %s [OPTION]... LANGNAME [DBNAME]
   %s [OPTION]... [DBNAME]
   %s [OPTION]... [DBNAME] [DESCRIPTION]
   %s [OPTION]... [ROLENAME]
   --help                          show this help, then exit
   --help                       show this help, then exit
   --help                    show this help, then exit
   --version                       output version information, then exit
   --version                    output version information, then exit
   --version                 output version information, then exit
   -D, --no-createdb         role cannot create databases
   -D, --tablespace=TABLESPACE  default tablespace for the database
   -E, --encoding=ENCODING      encoding for the database
   -E, --encrypted           encrypt stored password
   -F, --freeze                    freeze row transaction information
   -I, --no-inherit          role does not inherit privileges
   -L, --no-login            role cannot login
   -N, --unencrypted         do not encrypt stored password
   -O, --owner=OWNER            database user to own the new database
   -P, --pwprompt            assign a password to new role
   -R, --no-createrole       role cannot create roles
   -S, --no-superuser        role will not be superuser
   -T, --template=TEMPLATE      template database to copy
   -U, --username=USERNAME      user name to connect as
   -U, --username=USERNAME   user name to connect as
   -U, --username=USERNAME   user name to connect as (not the one to create)
   -U, --username=USERNAME   user name to connect as (not the one to drop)
   -W, --password               force password prompt
   -W, --password            force password prompt
   -a, --all                       vacuum all databases
   -a, --all                 cluster all databases
   -a, --all                 reindex all databases
   -c, --connection-limit=N  connection limit for role (default: no limit)
   -d, --createdb            role can create new databases
   -d, --dbname=DBNAME             database to vacuum
   -d, --dbname=DBNAME       database from which to remove the language
   -d, --dbname=DBNAME       database to cluster
   -d, --dbname=DBNAME       database to install language in
   -d, --dbname=DBNAME       database to reindex
   -e, --echo                      show the commands being sent to the server
   -e, --echo                   show the commands being sent to the server
   -e, --echo                show the commands being sent to the server
   -f, --full                      do full vacuuming
   -h, --host=HOSTNAME          database server host or socket directory
   -h, --host=HOSTNAME       database server host or socket directory
   -i, --index=INDEX         recreate specific index only
   -i, --inherit             role inherits privileges of roles it is a
                            member of (default)
   -i, --interactive         prompt before deleting anything
   -l, --list                show a list of currently installed languages
   -l, --locale=LOCALE          locale settings for the database
   -l, --login               role can login (default)
   -p, --port=PORT              database server port
   -p, --port=PORT           database server port
   -q, --quiet                     don't write any messages
   -q, --quiet               don't write any messages
   -r, --createrole          role can create new roles
   -s, --superuser           role will be superuser
   -s, --system              reindex system catalogs
   -t, --table='TABLE[(COLUMNS)]'  vacuum specific table only
   -t, --table=TABLE         cluster specific table only
   -t, --table=TABLE         reindex specific table only
   -v, --verbose                   write a lot of output
   -v, --verbose             write a lot of output
   -w, --no-password            never prompt for password
   -w, --no-password         never prompt for password
   -z, --analyze                   update optimizer hints
 %s (%s/%s)  %s cleans and analyzes a PostgreSQL database.

 %s clusters all previously clustered tables in a database.

 %s creates a PostgreSQL database.

 %s creates a new PostgreSQL role.

 %s installs a procedural language into a PostgreSQL database.

 %s reindexes a PostgreSQL database.

 %s removes a PostgreSQL database.

 %s removes a PostgreSQL role.

 %s removes a procedural language from a database.

 %s: "%s" is not a valid encoding name
 %s: cannot cluster a specific table in all databases
 %s: cannot cluster all databases and a specific one at the same time
 %s: cannot reindex a specific index and system catalogs at the same time
 %s: cannot reindex a specific index in all databases
 %s: cannot reindex a specific table and system catalogs at the same time
 %s: cannot reindex a specific table in all databases
 %s: cannot reindex all databases and a specific one at the same time
 %s: cannot reindex all databases and system catalogs at the same time
 %s: cannot vacuum a specific table in all databases
 %s: cannot vacuum all databases and a specific one at the same time
 %s: clustering database "%s"
 %s: clustering of database "%s" failed: %s %s: clustering of table "%s" in database "%s" failed: %s %s: comment creation failed (database was created): %s %s: could not connect to database %s
 %s: could not connect to database %s: %s %s: could not get current user name: %s
 %s: could not obtain information about current user: %s
 %s: creation of new role failed: %s %s: database creation failed: %s %s: database removal failed: %s %s: language "%s" is already installed in database "%s"
 %s: language "%s" is not installed in database "%s"
 %s: language installation failed: %s %s: language removal failed: %s %s: missing required argument database name
 %s: missing required argument language name
 %s: only one of --locale and --lc-collate can be specified
 %s: only one of --locale and --lc-ctype can be specified
 %s: query failed: %s %s: query was: %s
 %s: reindexing database "%s"
 %s: reindexing of database "%s" failed: %s %s: reindexing of index "%s" in database "%s" failed: %s %s: reindexing of system catalogs failed: %s %s: reindexing of table "%s" in database "%s" failed: %s %s: removal of role "%s" failed: %s %s: still %s functions declared in language "%s"; language not removed
 %s: too many command-line arguments (first is "%s")
 %s: vacuuming database "%s"
 %s: vacuuming of database "%s" failed: %s %s: vacuuming of table "%s" in database "%s" failed: %s Are you sure? Cancel request sent
 Could not send cancel request: %s Database "%s" will be permanently removed.
 Enter it again:  Enter name of role to add:  Enter name of role to drop:  Enter password for new role:  Name Password encryption failed.
 Password:  Passwords didn't match.
 Please answer "%s" or "%s".
 Procedural Languages Role "%s" will be permanently removed.
 Shall the new role be a superuser? Shall the new role be allowed to create databases? Shall the new role be allowed to create more new roles? Trusted? Try "%s --help" for more information.
 Usage:
 n no out of memory
 pg_strdup: cannot duplicate null pointer (internal error)
 y yes Project-Id-Version: pgscripts (PostgreSQL 8.4)
Report-Msgid-Bugs-To: pgsql-bugs@postgresql.org
POT-Creation-Date: 2013-01-29 13:24+0000
PO-Revision-Date: 2010-09-24 18:07-0400
Last-Translator: Ávaro Herrera <alvherre@alvh.no-ip.org>
Language-Team: Castellano <pgsql-es-ayuda@postgresql.org>
Language: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
 
Si no se especifica, se creará una base de datos con el mismo nombre que
el usuario actual.
 
Opciones de conexión:
 
Si no se especifican -d, -D, -r, -R, -s, -S o el ROL, se preguntará
interactivamente.
 
Opciones:
 
Lea la descripción de la orden CLUSTER de SQL para obtener mayores detalles.
 
Lea la descripción de la orden REINDEX de SQL para obtener mayores detalles.
 
Lea la descripción de la orden VACUUM de SQL para obtener mayores detalles.
 
Reporte errores a <pgsql-bugs@postgresql.org>.
       --lc-collate=LOCALE   configuración LC_COLLATE para la base de datos
       --lc-ctype=LOCALE     configuración LC_CTYPE para la base de datos
   %s [OPCIÓN]... BASE-DE-DATOS
   %s [OPCIÓN]... LENGUAJE [BASE-DE-DATOS]
   %s [OPCIÓN]... [BASE-DE-DATOS]
   %s [OPCIÓN]... [NOMBRE] [DESCRIPCIÓN]
   %s [OPCIÓN]... [ROL]
   --help                    mostrar esta ayuda y salir
   --help                    mostrar esta ayuda y salir
   --help                    desplegar esta ayuda y salir
   --version                 mostrar el número de versión y salir
   --version                 mostrar el número de versión y salir
   --version                 desplegar información de versión y salir
   -D, --no-createdb         el rol no podrá crear bases de datos
   -D, --tablespace=TBLSPC   tablespace por omisión de la base de datos
   -E, --encoding=CODIF      codificación para la base de datos
   -E, --encrypted           almacenar la constraseña cifrada
   -F, --freeze              usar «vacuum freeze»
   -I, --no-inherit          rol no heredará privilegios
   -L, --no-login            el rol no podrá conectarse
   -N, --unencrypted         almacenar la contraseña sin cifrar
   -O, --owner=DUEÑO         usuario que será dueño de la base de datos
   -P, --pwprompt            asignar una contraseña al nuevo rol
   -R, --no-createrole       el rol no podrá crear otros roles
   -S, --no-superuser        el rol no será un superusuario
   -T, --template=PATRÓN     base de datos patrón a copiar
   -U, --username=USUARIO    nombre de usuario para la conexión
   -U, --username=USUARIO    nombre de usuario para la conexión
   -U, --username=NOMBRE     nombre de usuario con el cual conectarse
                            (no el usuario a crear)
   -U, --username=USUARIO    nombre del usuario con el cual conectarse
                            (no el usuario a eliminar)
   -W, --password            forzar la petición de contraseña
   -W, --password            forzar la petición de contraseña
   -a, --all                 limpia todas las bases de datos
   -a, --all                 reordenar todas las bases de datos
   -a, --all                 reindexa todas las bases de datos
   -c, --connection-limit=N  límite de conexiones para el rol
                            (predeterminado: sin límite)
   -d, --createdb            el rol podrá crear bases de datos
   -d, --dbname=BASE         base de datos a limpiar
   -d, --dbname=BASE         nombre de la base de datos de la cual
                            eliminar el lenguaje
   -d, --dbname=BASE         base de datos a reordenar
   -d, --dbname=BASE         base de datos en que instalar el lenguaje
   -d, --dbname=DBNAME       base de datos a reindexar
   -e, --echo                mostrar las órdenes enviadas al servidor
   -e, --echo                mostrar las órdenes enviadas al servidor
   -e, --echo                mostrar las órdenes a medida que se ejecutan
   -f, --full                usar «vacuum full»
   -h, --host=ANFITRIÓN      nombre del servidor o directorio del socket
   -h, --host=ANFITRIÓN      nombre del servidor o directorio del socket
   -i, --index=INDEX         recrear sólo este índice
   -i, --inherit             el rol heredará los privilegios de los roles de
                            los cuales es miembro (predeterminado)
   -i, --interactive         preguntar antes de eliminar
   -l, --list                listar los lenguajes instalados actualmente
   -l, --locale=LOCALE       configuración regional para la base de datos
   -l, --login               el rol podrá conectarse (predeterminado)
   -p, --port=PUERTO         puerto del servidor
   -p, --port=PUERTO         puerto del servidor
   -q, --quiet               no desplegar mensajes
   -q, --quiet               no escribir ningún mensaje
   -r, --createrole          el rol podrá crear otros roles
   -s, --superuser           el rol será un superusuario
   -s, --system              reindexa los catálogos del sistema
   -t, --table='TABLA[(COLUMNAS)]'
                            limpiar sólo esta tabla
   -t, --table=TABLA         reordenar sólo esta tabla
   -t, --table=TABLE         reindexar sólo esta tabla
   -v, --verbose             desplegar varios mensajes informativos
   -v, --verbose             desplegar varios mensajes informativos
   -w, --no-password         nunca pedir contraseña
   -w, --no-password         nunca pedir contraseña
   -z, --analyze             actualizar las estadísticas
 %s (%s/%s)  %s limpia (VACUUM) y analiza una base de datos PostgreSQL.
 %s reordena todas las tablas previamente reordenadas
en una base de datos.

 %s crea una base de datos PostgreSQL.

 %s crea un nuevo rol de PostgreSQL.

 %s instala un lenguaje procedural en una base de datos PostgreSQL.

 %s reindexa una base de datos PostgreSQL.

 %s elimina una base de datos de PostgreSQL.

 %s elimina un rol de PostgreSQL.

 %s elimina un lenguaje procedural de una base de datos.

 %s: «%s» no es un nombre de codificación válido
 %s: no se puede reordenar una tabla específica en todas
las bases de datos
 %s: no se pueden reordenar todas las bases de datos y una de ellas
en particular simultáneamente
 %s: no se puede reindexar un índice específico y los catálogos
del sistema simultáneamente
 %s: no se puede reindexar un índice específico en todas las bases de datos
 %s: no se puede reindexar una tabla específica y los catálogos
del sistema simultáneamente
 %s: no se puede reindexar una tabla específica en todas las bases de datos
 %s: no se pueden reindexar todas las bases de datos y una de ellas
en particular simultáneamente
 %s: no se pueden reindexar todas las bases de datos y los catálogos
del sistema simultáneamente
 %s: no se puede limpiar a una tabla específica en todas
las bases de datos
 %s: no se pueden limpiar todas las bases de datos y una de ellas
en particular simultáneamente
 %s: reordenando la base de datos «%s»
 %s: falló el reordenamiento de la base de datos «%s»:
%s %s: falló el reordenamiento de la tabla «%s» en
la base de datos «%s»:
%s %s: falló la creación del comentario (la base de datos fue creada):
%s %s: no se pudo conectar a la base de datos %s
 %s: no se pudo conectar a la base de datos %s: %s %s: no se pudo obtener el nombre de usuario actual: %s
 %s: no se pudo obtener información sobre el usuario actual: %s
 %s: falló la creación del nuevo rol:
%s %s: falló la creación de la base de datos:
%s %s: falló la eliminación de la base de datos: %s %s: el lenguaje «%s» ya está instalado en la base de datos «%s»
 %s: el lenguaje «%s» no está instalado en la base de datos «%s»
 %s: falló la instalación del lenguaje:
%s %s: falló la eliminación del lenguaje: %s %s: falta el nombre de base de datos requerido
 %s: falta el nombre de lenguaje requerido
 %s: sólo uno de --locale y --lc-collate puede ser especificado
 %s: sólo uno de --locale y --lc-ctype puede ser especificado
 %s: la consulta falló: %s %s: la consulta era: %s
 %s: reindexando la base de datos «%s»
 %s: falló la reindexación de la base de datos «%s»: %s %s: falló la reindexación del índice «%s» en la base de datos «%s»: %s %s: falló la reindexación de los catálogos del sistema: %s %s: falló la reindexación de la tabla «%s» en la base de datos «%s»: %s %s: falló la eliminación del rol «%s»:
%s %s: aún hay %s funciones declaradas en el lenguaje «%s»;
el lenguaje no ha sido eliminado
 %s: demasiados argumentos (el primero es «%s»)
 %s: limpiando la base de datos «%s»
 %s: falló la limpieza de la base de datos «%s»:
%s %s: falló la limpieza de la tabla «%s» en la base de datos «%s»:
%s ¿Está seguro? Petición de cancelación enviada
 No se pudo enviar el paquete de cancelación: %s La base de datos «%s» será eliminada permanentemente.
 Ingrésela nuevamente:  Ingrese el nombre del rol a agregar:  Ingrese el nombre del rol a eliminar:  Ingrese la contraseña para el nuevo rol:  Nombre El cifrado de la contraseña falló.
 Contraseña:  Las contraseñas ingresadas no coinciden.
 Por favor conteste «%s» o «%s».
 Lenguajes Procedurales El rol «%s» será eliminado permanentemente.
 ¿Será el nuevo rol un superusuario? ¿Debe permitírsele al rol la creación de bases de datos? ¿Debe permitírsele al rol la creación de otros roles? Confiable? Use «%s --help» para mayor información.
 Empleo:
 n no memoria agotada
 pg_strdup: no se puede duplicar puntero nulo (error interno)
 s sí 