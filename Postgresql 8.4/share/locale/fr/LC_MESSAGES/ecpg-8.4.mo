��    v      �  �   |      �	  ~   �	  -   p
  +   �
  0   �
  7   �
  g   3     �  4   �  s   �  .   d  G   �  4   �  )     w   :  4   �     �  @   �  =   ;  !   y     �  ,   �  1   �  *     -   C  -   q  1   �  '   �  &   �  +      "   L      o     �  #   �     �  )   �  =     '   B  '   j  	   �     �  &   �  <   �  !     	   >  -   H  9   v  +   �  "   �     �  ,        G     f  *   �  "   �  '   �     �       !   *     L  !   e     �      �  3   �  /   �  '   !  ,   I  /   v  *   �  T   �  '   &     N     i     �     �     �  -   �  ,   �  ,   #  5   P     �  )   �  ?   �  8     �   E  0   �  5        C  A   X  L   �     �  6   �  '   ,  #   T     x  (   �  4   �  )   �          *      C  $   d     �  "   �  ,   �     �     	  '   )     Q     p  $   �  0   �     �  8         9     W  &   u      �  �  �  �   u  5   &   .   \   <   �   .   �   v   �   !   n!  C   �!     �!  >   T"  S   �"  A   �"  0   )#  �   Z#  C   �#     /$  K   H$  @   �$  .   �$  %   %  <   *%  ;   g%  4   �%  7   �%  7   &  ;   H&  1   �&  0   �&  5   �&  "   '  #   @'      d'  )   �'  	   �'  1   �'  M   �'  9   9(  9   s(  	   �(     �(  0   �(  Y   )  $   ^)     �)  :   �)  ?   �)  =   *  1   I*     {*  -   �*  !   �*  "   �*  6   +  ;   D+  2   �+     �+     �+  '   �+     ,  %   5,     [,     r,  @   �,  9   �,  ,   -  3   5-  7   i-  4   �-  d   �-  *   ;.     f.     �.     �.     �.     �.  5   �.  4   )/  4   ^/  A   �/     �/  5   �/  X   #0  I   |0  �   �0  M   p1  5   �1     �1  Y   2  f   g2     �2  <   �2  K   3  +   g3     �3  3   �3  ?   �3  ,   4     F4     e4  .   ~4  /   �4     �4  '   �4  6   5     U5     p5  *   �5  '   �5  $   �5  2   6  6   ;6  (   r6  H   �6  '   �6  %   7  -   27  #   `7         ?   q       ;   R   ,   X          N      ^              f   b   7       9          $   g          	                    
   l              v                  d   c   =   !       k   _   j   t   3   8      O   a   i      `   \      A                 e   1   W   m   .      ]               u          P   )   M   0   I   H   h      K   G          #   %   o   Y          S   <   -   [       Z   4       (           D               L   '      r   J       *             5   &       :   F   >   C   n   V   6       U   T   Q   /       +   B       p   @   "   E                    2             s    
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
 AT option not allowed in CLOSE DATABASE statement AT option not allowed in CONNECT statement AT option not allowed in DEALLOCATE statement AT option not allowed in DISCONNECT statement AT option not allowed in SET CONNECTION statement AT option not allowed in TYPE statement AT option not allowed in VAR statement AT option not allowed in WHENEVER statement COPY FROM STDIN is not implemented COPY FROM STDOUT is not possible COPY TO STDIN is not possible CREATE TABLE AS cannot specify INTO ERROR:  EXEC SQL INCLUDE ... search starts here:
 Error: include path "%s/%s" is too long on line %d, skipping
 NEW used in query that is not in a rule OLD used in query that is not in a rule Options:
 SHOW ALL is not implemented Try "%s --help" for more information.
 Unix-domain sockets only work on "localhost" but not on "%s" Usage:
  %s [OPTION]... FILE...

 WARNING:  arrays of indicators are not allowed on input constraint declared INITIALLY DEFERRED must be DEFERRABLE could not open include file "%s" on line %d could not remove output file "%s"
 cursor "%s" does not exist cursor "%s" has been declared but not opened cursor "%s" is already defined descriptor "%s" does not exist descriptor header item "%d" does not exist descriptor item "%s" cannot be set descriptor item "%s" is not implemented end of search list
 expected "://", found "%s" expected "@" or "://", found "%s" expected "@", found "%s" expected "postgresql", found "%s" incomplete statement incorrectly formed variable "%s" indicator for array/pointer has to be array/pointer indicator for simple data type has to be simple indicator for struct has to be a struct indicator variable must have an integer type initializer not allowed in EXEC SQL VAR command initializer not allowed in type definition internal error: unreachable state; please report this to <pgsql-bugs@postgresql.org> interval specification not allowed here invalid bit string literal invalid connection type: %s invalid data type key_member is always 0 missing "EXEC SQL ENDIF;" missing identifier in EXEC SQL DEFINE command missing identifier in EXEC SQL IFDEF command missing identifier in EXEC SQL UNDEF command missing matching "EXEC SQL IFDEF" / "EXEC SQL IFNDEF" more than one EXEC SQL ELSE multidimensional arrays are not supported multidimensional arrays for simple data types are not supported multidimensional arrays for structures are not supported multilevel pointers (more than 2 levels) are not supported; found %d level multilevel pointers (more than 2 levels) are not supported; found %d levels nested arrays are not supported (except strings) no longer supported LIMIT #,# syntax passed to server nullable is always 1 only data types numeric and decimal have precision/scale argument only protocols "tcp" and "unix" and database type "postgresql" are supported out of memory pointer to pointer is not supported for this data type pointers to varchar are not implemented subquery in FROM must have an alias syntax error syntax error in EXEC SQL INCLUDE command too many levels in nested structure/union definition too many nested EXEC SQL IFDEF conditions type "%s" is already defined unmatched EXEC SQL ENDIF unrecognized data type name "%s" unrecognized descriptor item code %d unrecognized token "%s" unrecognized variable type code %d unsupported feature will be passed to server unterminated /* comment unterminated bit string literal unterminated hexadecimal string literal unterminated quoted identifier unterminated quoted string using unsupported DESCRIBE statement variable "%s" is neither a structure nor a union variable "%s" is not a pointer variable "%s" is not a pointer to a structure or a union variable "%s" is not an array variable "%s" is not declared variable "%s" must have a numeric type zero-length delimited identifier Project-Id-Version: PostgreSQL 8.4
Report-Msgid-Bugs-To: pgsql-bugs@postgresql.org
POT-Creation-Date: 2009-06-12 21:16+0000
PO-Revision-Date: 2009-04-15 22:21+0200
Last-Translator: St�phane Schildknecht <stephane.schildknecht@dalibo.com>
Language-Team: PostgreSQLfr <pgsql-fr-generale@postgresql.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Plural-Forms: nplurals=2; plural=(n > 1);
 
Si aucun nom de fichier en sortie n'est fourni, le nom est format� en
ajoutant le suffixe .c au nom du fichier en entr�e apr�s avoir supprim� le
suffixe .pgc s'il est pr�sent
 
Rapporter les bogues � <pgsql-bugs@postgresql.org>.
   --help         affiche cette aide et quitte
   --regression   s'ex�cute en mode de tests des r�gressions
   --version      affiche la version et quitte
   -C MODE        configure le mode de compatibilit� ; MODE peut �tre
                 � INFORMIX � ou � INFORMIX_SE �
   -D SYMBOLE     d�finit SYMBOLE
   -I R�PERTOIRE  recherche les fichiers d'en-t�tes dans R�PERTOIRE
   -c             produit automatiquement le code C � partir du code SQL embarqu� ;
                 ceci affecte EXEC SQL TYPE
   -d             produit la sortie de d�bogage de l'analyseur
   -h             analyse un fichier d'en-t�te, cette option inclut l'option � -c �
   -i             analyse en plus les fichiers d'en-t�te syst�mes
   -o FICHIER     �crit le r�sultat dans FICHIER
   -r OPTION      indique le comportement � l'ex�cution ; OPTION peut valoir :
                 � no_indicator �, � prepare �, � questionmarks �
   -t             active la validation automatique des transactions
 %s sur ou pr�s de � %s � %s est le pr�processeur SQL embarqu� de PostgreSQL pour les programmes C.

 %s, le pr�processeur C embarqu� de PostgreSQL, version %d.%d.%d
 %s : n'a pas pu ouvrir le fichier � %s � : %s
 %s : aucun fichier pr�cis� en entr�e
 %s : support de d�bogage de l'analyseur (-d) non disponible
 option AT non autoris�e dans une instruction CLOSE DATABASE option AT non autoris�e dans une instruction CONNECT option AT non autoris�e dans une instruction DEALLOCATE option AT non autoris�e dans une instruction DISCONNECT option AT non autoris�e dans une instruction SET CONNECTION option AT non autoris�e dans une instruction TYPE option AT non autoris�e dans une instruction VAR option AT non autoris�e dans une instruction WHENEVER COPY FROM STDIN n'est pas implant� COPY FROM STDOUT n'est pas possible COPY TO STDIN n'est pas possible CREATE TABLE AS ne peut pas indiquer INTO ERREUR :  la recherche EXEC SQL INCLUDE ... commence ici :
 Erreur : le chemin d'en-t�te � %s/%s � est trop long sur la ligne %d,
ignor�
 NEW utilis� dans une requ�te qui n'est pas dans une r�gle OLD utilis� dans une requ�te qui n'est pas dans une r�gle Options:
 SHOW ALL n'est pas implant� Essayer � %s --help � pour plus d'informations.
 les sockets de domaine Unix fonctionnent seulement sur � localhost �, mais pas sur � %s � Usage:
  %s [OPTION]... FICHIER...

 ATTENTION :  les tableaux d'indicateurs ne sont pas autoris�s en entr�e une contrainte d�clar�e INITIALLY DEFERRED doit �tre DEFERRABLE n'a pas pu ouvrir le fichier d'en-t�te � %s � sur la ligne %d n'a pas pu supprimer le fichier � %s � en sortie
 le curseur � %s � n'existe pas le curseur � %s � est d�clar� mais non ouvert le curseur � %s � est d�j� d�fini le descripteur � %s � n'existe pas l'�l�ment d'en-t�te du descripteur � %d � n'existe pas l'�l�ment du descripteur � %s � ne peut pas �tre initialis� l'�l�ment du descripteur � %s � n'est pas implant� fin de la liste de recherche
 � :// � attendu, � %s � trouv� � @ � ou � :// � attendu, � %s � trouv� � @ � attendu, � %s � trouv� � postgresql � attendu, � %s � trouv� instruction incompl�te variable � %s � mal form�e l'indicateur pour le tableau/pointeur doit �tre tableau/pointeur l'indicateur d'un type de donn�es simple doit �tre simple l'indicateur d'un struct doit �tre un struct la variable d'indicateur doit avoir un type integer initialiseur non autoris� dans la commande EXEC SQL VAR initialiseur non autoris� dans la d�finition du type erreur interne : l'�tat ne peut �tre atteint ; merci de rapporter ceci �
<pgsql-bugs@postgresql.org> interval de sp�cification non autoris� ici cha�ne bit lit�ral invalide type de connexion invalide : %s type de donn�es invalide key_member vaut toujours 0 � EXEC SQL ENDIF; � manquant identifiant manquant dans la commande EXEC SQL DEFINE identifiant manquant dans la commande EXEC SQL IFDEF identifiant manquant dans la commande EXEC SQL UNDEF correspondance manquante � EXEC SQL IFDEF � / � EXEC SQL IFNDEF � plusieurs EXEC SQL ELSE les tableaux multidimensionnels ne sont pas support�s les tableaux multi-dimensionnels pour les types de donn�es simples ne sont
pas support�s les tableaux multidimensionnels ne sont pas support�s pour les structures les pointeurs multi-niveaux (plus de deux) ne sont pas support�s :
%d niveau trouv� les pointeurs multi-niveaux (plus de deux) ne sont pas support�s :
%d niveaux trouv�s les tableaux imbriqu�s ne sont pas support�s (sauf les cha�nes de
caract�res) la syntaxe obsol�te LIMIT #,# a �t� pass�e au serveur nullable vaut toujours 1 seuls les types de donn�es numeric et decimal ont des arguments de
pr�cision et d'�chelle seuls les protocoles � tcp � et � unix � et les types de base de donn�es
� postgresql � sont support�s m�moire �puis�e ce type de donn�es ne supporte pas les pointeurs de pointeur les pointeurs sur des cha�nes de caract�res (varchar) ne sont pas implant�s la sous-requ�te du FROM doit avoir un alias erreur de syntaxe erreur de syntaxe dans la commande EXEC SQL INCLUDE trop de niveaux dans la d�finition de structure/union imbriqu�e trop de conditions EXEC SQL IFDEF imbriqu�es le type � %s � est d�j� d�fini EXEC SQL ENDIF diff�rent nom � %s � non reconnu pour un type de donn�es code %d de l'�l�ment du descripteur non reconnu jeton � %s � non reconnu code %d du type de variable non reconnu la fonctionnalit� non support�e sera pass�e au serveur commentaire /* non termin� cha�ne bit lit�ral non termin�e cha�ne hexad�cimale lit�ralle non termin�e identifiant entre guillemet non termin� cha�ne entre guillemets non termin�e utilisation de l'instruction DESCRIBE non support� la variable � %s � n'est ni une structure ni une union la variable � %s � n'est pas un pointeur la variable � %s � n'est pas un pointeur vers une structure ou une union la variable � %s � n'est pas un tableau la variable � %s � n'est pas d�clar�e la variable � %s � doit avoir un type numeric identifiant d�limit� de taille z�ro 