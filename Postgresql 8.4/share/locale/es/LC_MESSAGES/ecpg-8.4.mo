��    u      �  �   l      �	  ~   �	  -   `
  +   �
  0   �
  7   �
  g   #     �  4   �  s   �  .   T  G   �  4   �  )      w   *  4   �     �  @   �  =   +  !   i     �  ,   �  1   �  *     -   3  1   a  '   �  &   �  +   �  "         1     R  #   p     �  )   �  =   �  '     '   ,  	   T     ^  &   z  <   �  !   �  	      -   
  9   8  +   r  "   �     �  ,   �     	     (  *   G  "   r  '   �     �     �  !   �       !   '     I      ^  3     /   �  '   �  ,     /   8  *   h  T   �  '   �          +     G     Y     p  -   �  ,   �  ,   �  5        H  )   d  ?   �  8   �  �     0   �  5   �       A     L   \     �  6   �  '   �  #        :  (   G  4   p  )   �     �     �        $   &     K  "   c  ,   �     �     �  '   �          2  $   M  0   r     �  8   �     �       &   7      ^  �    �   +  0   �  0   �  9      A   R   p   �      !  A   %!     g!  7   �!  E   "  G   e"  .   �"  �   �"  L   �#     �#  M   �#  F   ;$  +   �$  ,   �$  D   �$  ?    %  8   `%  ;   �%  ?   �%  5   &  4   K&  9   �&  %   �&     �&     �&  )   '     E'  2   M'  R   �'  /   �'  /   (  
   3(     >(  7   ](  M   �(  &   �(     
)  6   )  A   M)  <   �)  0   �)     �)  .   *  "   G*     j*  7   �*  8   �*  4   �*     /+  (   M+  0   v+  &   �+  /   �+     �+  '   ,  3   ;,  2   o,  (   �,  D   �,  3   -  1   D-  R   v-  8   �-     .      .     =.     U.     m.  2   �.  1   �.  1   �.  1   !/     S/  2   p/  N   �/  C   �/  �   60  >   �0  J   1     W1  O   m1  a   �1     2  B   /2  .   r2  -   �2     �2  +   �2  A   3  .   O3      ~3     �3  ,   �3  2   �3     4  ,   =4  5   j4     �4  #   �4  '   �4  -   5  '   35  *   [5  5   �5  #   �5  =   �5  !   6  %   @6  ,   f6  )   �6         >   p       :   Q   +   W          M      ]              e   a   6       8          #   f          	                    
   k               u                  c   b   <           j   ^   i   s   2   7      N   `   h      _   [      @                 d   0   V   l   -      \               t          O   (   L   /   H   G   g      J   F          "   $   n   X          R   ;   ,   Z       Y   3       '           C              K   &      q   I       )             4   %       9   E   =   B   m   U   5       T   S   P   .       *   A       o   ?   !   D                    1             r    
If no output file is specified, the name is formed by adding .c to the
input file name, after stripping off .pgc if present.
 
Report bugs to <pgsql-bugs@postgresql.org>.
   --help         show this help, then exit
   --regression   run in regression testing mode
   --version      output version information, then exit
   -C MODE        set compatibility mode; MODE can be one of
                 "INFORMIX", "INFORMIX_SE"
   -D SYMBOL      define SYMBOL
   -I DIRECTORY   search DIRECTORY for include files
   -c             automatically generate C code from embedded SQL code;
                 this affects EXEC SQL TYPE
   -d             generate parser debug output
   -h             parse a header file, this option includes option "-c"
   -i             parse system include files as well
   -o OUTFILE     write result to OUTFILE
   -r OPTION      specify run-time behavior; OPTION can be:
                 "no_indicator", "prepare", "questionmarks"
   -t             turn on autocommit of transactions
 %s at or near "%s" %s is the PostgreSQL embedded SQL preprocessor for C programs.

 %s, the PostgreSQL embedded C preprocessor, version %d.%d.%d
 %s: could not open file "%s": %s
 %s: no input files specified
 %s: parser debug support (-d) not available
 AT option not allowed in CLOSE DATABASE statement AT option not allowed in CONNECT statement AT option not allowed in DISCONNECT statement AT option not allowed in SET CONNECTION statement AT option not allowed in TYPE statement AT option not allowed in VAR statement AT option not allowed in WHENEVER statement COPY FROM STDIN is not implemented COPY FROM STDOUT is not possible COPY TO STDIN is not possible CREATE TABLE AS cannot specify INTO ERROR:  EXEC SQL INCLUDE ... search starts here:
 Error: include path "%s/%s" is too long on line %d, skipping
 NEW used in query that is not in a rule OLD used in query that is not in a rule Options:
 SHOW ALL is not implemented Try "%s --help" for more information.
 Unix-domain sockets only work on "localhost" but not on "%s" Usage:
  %s [OPTION]... FILE...

 WARNING:  arrays of indicators are not allowed on input constraint declared INITIALLY DEFERRED must be DEFERRABLE could not open include file "%s" on line %d could not remove output file "%s"
 cursor "%s" does not exist cursor "%s" has been declared but not opened cursor "%s" is already defined descriptor "%s" does not exist descriptor header item "%d" does not exist descriptor item "%s" cannot be set descriptor item "%s" is not implemented end of search list
 expected "://", found "%s" expected "@" or "://", found "%s" expected "@", found "%s" expected "postgresql", found "%s" incomplete statement incorrectly formed variable "%s" indicator for array/pointer has to be array/pointer indicator for simple data type has to be simple indicator for struct has to be a struct indicator variable must have an integer type initializer not allowed in EXEC SQL VAR command initializer not allowed in type definition internal error: unreachable state; please report this to <pgsql-bugs@postgresql.org> interval specification not allowed here invalid bit string literal invalid connection type: %s invalid data type key_member is always 0 missing "EXEC SQL ENDIF;" missing identifier in EXEC SQL DEFINE command missing identifier in EXEC SQL IFDEF command missing identifier in EXEC SQL UNDEF command missing matching "EXEC SQL IFDEF" / "EXEC SQL IFNDEF" more than one EXEC SQL ELSE multidimensional arrays are not supported multidimensional arrays for simple data types are not supported multidimensional arrays for structures are not supported multilevel pointers (more than 2 levels) are not supported; found %d level multilevel pointers (more than 2 levels) are not supported; found %d levels nested arrays are not supported (except strings) no longer supported LIMIT #,# syntax passed to server nullable is always 1 only data types numeric and decimal have precision/scale argument only protocols "tcp" and "unix" and database type "postgresql" are supported out of memory pointer to pointer is not supported for this data type pointers to varchar are not implemented subquery in FROM must have an alias syntax error syntax error in EXEC SQL INCLUDE command too many levels in nested structure/union definition too many nested EXEC SQL IFDEF conditions type "%s" is already defined unmatched EXEC SQL ENDIF unrecognized data type name "%s" unrecognized descriptor item code %d unrecognized token "%s" unrecognized variable type code %d unsupported feature will be passed to server unterminated /* comment unterminated bit string literal unterminated hexadecimal string literal unterminated quoted identifier unterminated quoted string using unsupported DESCRIBE statement variable "%s" is neither a structure nor a union variable "%s" is not a pointer variable "%s" is not a pointer to a structure or a union variable "%s" is not an array variable "%s" is not declared variable "%s" must have a numeric type zero-length delimited identifier Project-Id-Version: PostgreSQL 8.4
Report-Msgid-Bugs-To: pgsql-bugs@postgresql.org
POT-Creation-Date: 2013-01-29 13:19+0000
PO-Revision-Date: 2010-09-24 18:07-0400
Last-Translator: Álvaro Herrera <alvherre@alvh.no-ip.org>
Language-Team: PgSQL-es-Ayuda <pgsql-es-ayuda@postgresql.org>
Language: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Plural-Forms: nplurals=2; plural=n != 1;
 
Si no se especifica un archivo de salida, el nombre se forma agregando .c al
archivo de entrada, luego de quitar .pgc si está presente.
 
Reporte errores a <pgsql-bugs@postgresql.org>.
   --help         muestra esta ayuda, luego sale
   --regression   ejecuta en modo de prueba de regresión
   --version      muestra información de la versión, luego sale
   -C MODO        establece el modo de compatibilidad;
                 MODO puede ser "INFORMIX", "INFORMIX_SE"
   -D SYMBOL      define SYMBOL
   -I DIRECTORIO   busca los archivos de inclusión en DIRECTORIO
   -c             genera automáticamente código en C desde código SQL
                 incrustado; esto afecta EXEC SQL TYPE
   -d             genera salida depurada del analizador
   -h             analiza un archivo de cabecera; esto incluye «-c»
   -i             analiza además los archivos de inclusión de sistema
   -o ARCHIVO     escribe la salida en ARCHIVO
   -r OPCIÓN      especifica el comportamiento en tiempo de ejecución;
                 OPCIÓN puede ser: «no_indicator», «prepare»,
                 «questionmarks»
   -t             activa el compromiso (commit) automático de transacciones
 %s en o cerca «%s» %s es el preprocesador de SQL incrustado para programas en C de PostgreSQL.

 %s, el preprocesador de C incrustado de PostgreSQL, versión %d.%d.%d
 %s: no se pudo abrir el archivo «%s»: %s
 %s: no se especificaron archivos de entrada
 %s: la depuración del analizador (parser, -d) no está disponible)
 la opción AT no está permitida en la sentencia CLOSE DATABASE la opción AT no está permitida en la sentencia CONNECT la opción AT no está permitida en la sentencia DISCONNECT la opción AT no está permitida en la sentencia SET CONNECTION la opción AT no está permitida en la sentencia TYPE la opción AT no está permitida en la sentencia VAR la opción AT no está permitida en la sentencia WHENEVER COPY FROM STDIN no está implementado COPY FROM STDOUT no es posible COPY TO STDIN no es posible CREATE TABLE AS no puede especificar INTO ERROR:  EXEC SQL INCLUDE ... la búsqueda comienza aquí:
 Error: ruta de inclusión «%s/%s» es demasiada larga en la línea %d, omitiendo
 se usó NEW en una consulta que no es una regla se usó OLD en una consulta que no es una regla Opciones:
 SHOW ALL no está implementado Utilice «%s --help» para obtener mayor información.
 los sockets de dominio unix sólo trabajan en «localhost» pero no en «%s» Empleo:
  %s [OPCIÓN]... ARCHIVO...

 ATENCIÓN:  no se permiten los arrays de indicadores en la entrada una restricción declarada INITIALLY DEFERRED debe ser DEFERRABLE no se pudo abrir el archivo a incluir «%s» en la línea %d no se pudo eliminar el archivo de salida «%s»
 no existe el cursor «%s» el cursor «%s» fue declarado pero no abierto el cursor «%s» ya está definido no existe el descriptor «%s» no existe el descriptor del elemento de cabecera «%d» no se puede establecer el elemento del descriptor «%s» elemento del descriptor «%s» no está implementado fin de la lista de búsqueda
 se esperaba «://», se encontró «%s» se esperaba «@» o «://», se encontró «%s» se esperaba «@», se encontró «%s» se esperaba «postgresql», se encontró «%s» sentencia incompleta variable formada incorrectamente «%s» indicador para array/puntero debe ser array/puntero el indicador para tipo dato simple debe ser simple el indicador para struct debe ser struct la variable de un indicador debe ser de algún tipo numérico entero inicializador no permitido en la orden EXEC SQL VAR inicializador no permitido en definición de tipo Error Interno: estado no esperado; por favor reporte a <pgsql-bugs@postgresql.org> la especificación de intervalo no está permitida aquí cadena de bits no válida tipo de conexión no válido: %s tipo de dato no válido key_member es siempre 0 falta el «EXEC SQL ENDIF;» identificador faltante en la orden EXEC SQL DEFINE identificador faltante en la orden EXEC SQL IFDEF falta un identificador en la orden EXEC SQL UNDEF falta el «EXEC SQL IFDEF» / «EXEC SQL IFNDEF» hay más de un EXEC SQL ELSE los arrays multidimensionales no están soportados los arrays multidimensionales para tipos de datos simples no están soportados los arrays multidimensionales para estructuras no están soportados no se soportan los punteros multinivel (más de 2); se encontró 1 nivel no se soportan los punteros multinivel (más de 2); se encontraron %d niveles no se permiten arrays anidados (excepto cadenas de caracteres) la sintaxis LIMIT #,# que ya no está soportada ha sido pasada al servidor nullable es siempre 1 sólo los tipos de dato numeric y decimal tienen argumento de precisión/escala sólo los protocolos «tcp» y «unix» y tipo de bases de datos «postgresql» están soportados memoria agotada los punteros a puntero no están soportados para este tipo de dato los punteros a varchar no están implementados las subconsultas en FROM deben tener un alias error de sintaxis error de sintaxis en orden EXEC SQL INCLUDE demasiados niveles en la definición anidada de estructura/unión demasiadas condiciones EXEC SQL IFDEF anidadas el tipo «%s» ya está definido EXEC SQL ENDIF sin coincidencia nombre de tipo de datos «%s» no reconocido código de descriptor de elemento %d no reconocido elemento «%s» no reconocido código de tipo de variable %d no reconocido característica no soportada será pasada al servidor comentario /* no cerrado una cadena de bits está inconclusa una cadena hexadecimal está inconclusa un identificador en comillas está inconcluso una cadena en comillas está inconclusa utilizando sentencia DESCRIBE no soportada la variable «%s» no es una estructura ni una unión la variable «%s» no es un puntero la variable «%s» no es un puntero a una estructura o unión la variable «%s» no es un array la variable «%s» no está declarada la variable «%s» debe tener tipo numérico identificador delimitado de longitud cero 