��    �        �   �	      H  K   I     �  f   �  
     >     >   \  =   �  -   �  C     A   K     �  #   �     �  (   �       <   +  9   h  6   �  H   �  E   "  B   h  9   �  C   �  9   )  4   c  E   �  =   �  .     ;   K  E   �  :   �  5     7   >  9   v  7   �  4   �  L     J   j  5   �  2   �  7     2   V  2   �  J   �  :     5   B  G   x  0   �  <   �  0   .  M   _  J   �  G   �  4   @  H   u  E   �  9     v   >  <   �  I   �  @   <  5   }  4   �  1   �  ;     5   V  6   �  3   �  4   �  =   ,  8   j  8   �  8   �  2     9   H  6   �  9   �     �  /   �  <   /  #   l  #   �  ?   �  %   �  #         >   3   ^   &   �   5   �   E   �   I   5!  5   !  I   �!  5   �!  E   5"  F   {"  4   �"  D   �"     <#  *   Z#  8   �#  6   �#  %   �#  (   $  (   D$  8   m$  #   �$      �$     �$  8   %  4   D%  $   y%     �%  ,   �%  ,   �%  ;   &  9   T&     �&     �&     �&  *   �&  8   �&  ,   8'  8   e'  #   �'  G   �'  4   
(     ?(  )   \(  7   �(     �(     �(  !   �(  +   )     /)     @)     \)     y)     �)     �)  
   �)     �)     �)     �)  '   *  "   7*  2   Z*  7   �*     �*  &   �*     �*     �*     �*     +  :   +     L+     N+  _  R+  l   �,     -  e   6-     �-  U   �-  U   �-  R   T.  6   �.  H   �.  F   '/     n/  "   �/     �/  )   �/     �/  E   0  B   T0  ?   �0  O   �0  L   '1  I   t1  B   �1  A   2  ;   C2  C   2  M   �2  9   3  ;   K3  I   �3  >   �3  B   4  =   S4  6   �4  @   �4  5   	5  2   ?5  �   r5  �   �5  7   �6  4   �6  H   �6  6   >7  9   u7  ~   �7  A   .8  G   p8  l   �8  4   %9  n   Z9  8   �9  y   :  s   |:  m   �:  <   ^;  Q   �;  N   �;  @   <<  �   }<  H   =  K   O=  F   �=  F   �=  9   )>  6   c>  @   �>  :   �>  <   ?  1   S?  7   �?  h   �?  @   &@  C   g@  :   �@  4   �@  <   A  9   XA  K   �A     �A  6   �A  C   !B  '   eB  (   �B  H   �B  +   �B  &   +C  "   RC  9   uC  *   �C  D   �C  I   D  S   iD  H   �D  S   E  H   ZE  M   �E  M   �E  D   ?F  I   �F     �F  2   �F  B   G  M   aG  ,   �G  /   �G  7   H  E   DH  0   �H  2   �H  ,   �H  ;   I  9   WI  /   �I  *   �I  %   �I  $   J  E   7J  C   }J     �J     �J     �J  6   K  D   LK  6   �K  F   �K  -   L  J   =L  :   �L  '   �L  0   �L  @   M     ]M     sM  +   �M  4   �M     �M  )   N  1   ;N  ,   mN     �N  ,   �N  
   �N  #   �N  $   �N      O  0   5O  '   fO  0   �O  8   �O  	   �O  5   P     8P     AP     CP     HP  =   _P     �P     �P     2   F   6   ]       m          �   8   _       t           �   �       P          �   Q   x                      <   e      c          k          >   l          �       �       ~   S   ;       %   @           !   r          C   K           �   f   3      G   Z   o      E   �       W   i   &   =   (      	   /   O   \   �   A           n   s   �       0      �   �   ^   }   d   �   �      �   #   J   Y   �             �   g   ?   :   y   +          {   1   w   �      �       z       -   4                   .                 q   �   5      `                      b       U   L   h   [      
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
 y yes Project-Id-Version: PostgreSQL 8.4
Report-Msgid-Bugs-To: pgsql-bugs@postgresql.org
POT-Creation-Date: 2009-03-01 07:22+0000
PO-Revision-Date: 2013-03-08 00:22-0500
Last-Translator: Peter Eisentraut <peter_e@gmx.net>
Language-Team: German <peter_e@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
 
Wenn nichts anderes angegeben ist, dann wird eine Datenbank mit dem Namen
des aktuellen Benutzers erzeugt.
 
Verbindungsoptionen:
 
Wenn -d, -D, -r, -R, -s, -S oder ROLLENNAME nicht angegeben wird, dann wird
interaktiv nachgefragt.
 
Optionen:
 
F�r weitere Informationen lesen Sie bitte die Beschreibung des
SQL-Befehls CLUSTER.
 
F�r weitere Informationen lesen Sie bitte die Beschreibung des
SQL-Befehls REINDEX.
 
F�r weitere Information lesen Sie bitte die Beschreibung des
SQL-Befehls VACUUM.
 
Berichten Sie Fehler an <pgsql-bugs@postgresql.org>.
       --lc-collate=LOCALE      LC_COLLATE-Einstellung f�r die Datenbank
       --lc-ctype=LOCALE        LC_CTYPE-Einstellung f�r die Datenbank
   %s [OPTION]... DBNAME
   %s [OPTION]... SPRACHE [DBNAME]
   %s [OPTION]... [DBNAME]
   %s [OPTION]... [DBNAME] [BESCHREIBUNG]
   %s [OPTION]... [ROLLENNAME]
   --help                          diese Hilfe anzeigen, dann beenden
   --help                       diese Hilfe anzeigen, dann beenden
   --help                    diese Hilfe anzeigen, dann beenden
   --version                       Versionsinformationen anzeigen, dann beenden
   --version                    Versionsinformationen anzeigen, dann beenden
   --version                 Versionsinformationen anzeigen, dann beenden
   -D, --no-createdb         Rolle kann keine Datenbanken erzeugen
   -D, --tablespace=TABLESPACE  Standard-Tablespace der Datenbank
   -E, --encoding=KODIERUNG     Kodierung f�r die Datenbank
   -E, --encrypted           verschl�ssle das gespeicherte Passwort
   -F, --freeze                    Zeilentransaktionsinformationen einfrieren
   -I, --no-inherit          Rolle erbt keine Privilegien
   -L, --no-login            Rolle kann sich nicht anmelden
   -N, --unencrypted         verschl�ssle das gespeicherte Passwort nicht
   -O, --owner=EIGENT�MER       Eigent�mer der neuen Datenbank
   -P, --pwprompt            weise der neuen Rolle ein Passwort zu
   -R, --no-createrole       Rolle kann keine Rollen erzeugen
   -S, --no-superuser        Rolle wird kein Superuser
   -T, --template=TEMPLATE      zu kopierende Template-Datenbank
   -U, --username=NAME          Datenbankbenutzername
   -U, --username=NAME       Datenbankbenutzername
   -U, --username=BENUTZER   Datenbankbenutzername f�r die Verbindung
                            (nicht der Name des neuen Benutzers)
   -U, --username=BENUTZER   Datenbankbenutzername f�r die Verbindung
                            (nicht der Name des zu l�schenden Benutzers)
   -W, --password               Passwortfrage erzwingen
   -W, --password            Passwortfrage erzwingen
   -a, --all                       f�hre Vacuum in allen Datenbanken aus
   -a, --all                 clustere alle Datenbanken
   -a, --all                 reindiziere alle Datenbanken
   -c, --connection-limit=N  Hochzahl an Verbindungen f�r Rolle
                            (Voreinstellung: keine Begrenzung)
   -d, --createdb            Rolle kann neue Datenbanken erzeugen
   -d, --dbname=DBNAME             f�hre Vacuum in dieser Datenbank aus
   -d, --dbname=DBNAME       Datenbank, aus der die Sprache gel�scht
                            werden soll
   -d, --dbname=DBNAME       zu clusternde Datenbank
   -d, --dbname=DBNAME       Datenbank, in der die Sprache installiert
                            werden soll
   -d, --dbname=DBNAME       zu reindizierende Datenbank
   -e, --echo                      zeige die Befehle, die an den Server
                                  gesendet werden
   -e, --echo                   zeige die Befehle, die an den Server
                               gesendet werden
   -e, --echo                zeige die Befehle, die an den Server
                            gesendet werden
   -f, --full                      f�hre volles Vacuum durch
   -h, --host=HOSTNAME          Name des Datenbankservers oder Socket-Verzeichnis
   -h, --host=HOSTNAME       Name des Datenbankservers oder Socket-Verzeichnis
   -i, --index=INDEX         erneuere nur einen bestimmten Index
   -i, --inherit             Rolle erbt alle Privilegien von Rollen, deren
                            Mitglied sie ist (Voreinstellung)
   -i, --interactive         frage nach, bevor irgendetwas gel�scht wird
   -l, --list                zeige Liste gegenw�rtig installierter Sprachen
   -l, --locale=LOCALE          Lokale-Einstellungen f�r die Datenbank
   -l, --login               Rolle kann sich anmelden (Voreinstellung)
   -p, --port=PORT              Port des Datenbankservers
   -p, --port=PORT           Port des Datenbankservers
   -q, --quiet                     unterdr�cke alle Mitteilungen
   -q, --quiet               unterdr�cke alle Mitteilungen
   -r, --createrole          Rolle kann neue Rollen erzeugen
   -s, --superuser           Rolle wird Superuser
   -s, --system              reindiziere Systemkataloge
   -t, --table='TABELLE[(SPALTEN)]'
                                  f�hre Vacuum f�r diese Tabelle aus
   -t, --table=TABELLE       clustere nur eine bestimmte Tabelle
   -t, --table=TABELLE       reindiziere nur eine bestimmte Tabelle
   -v, --verbose                   erzeuge viele Meldungen
   -v, --verbose             erzeuge viele Meldungen
   -w, --no-password            niemals nach Passwort fragen
   -w, --no-password         niemals nach Passwort fragen
   -z, --analyze                   aktualisiere Hinweise f�r den Optimierer
 %s (%s/%s)  %s s�ubert und analysiert eine PostgreSQL-Datenbank.

 %s clustert alle vorher geclusterten Tabellen in einer Datenbank.

 %s erzeugt eine PostgreSQL-Datenbank.

 %s erzeugt eine neue PostgreSQL-Rolle.

 %s installiert eine prozedurale Sprache in einer PostgreSQL-Datenbank.

 %s reindiziert eine PostgreSQL-Datenbank.

 %s l�scht eine PostgreSQL-Datenbank.

 %s l�scht eine PostgreSQL-Rolle.

 %s l�scht eine prozedurale Sprache aus einer Datenbank.

 %s: �%s� ist kein g�ltiger Kodierungsname
 %s: kann nicht eine bestimmte Tabelle in allen Datenbanken clustern
 %s: kann nicht alle Datenbanken und eine bestimmte gleichzeitig clustern
 %s: kann nicht einen bestimmten Index und Systemkataloge gleichzeitig reindizieren
 %s: kann nicht einen bestimmten Index in allen Datenbanken reindizieren
 %s: kann nicht eine bestimmte Tabelle und Systemkataloge gleichzeitig reindizieren
 %s: kann nicht eine bestimmte Tabelle in allen Datenbanken reindizieren
 %s: kann nicht alle Datenbanken und eine bestimmte gleichzeitig reindizieren
 %s: kann nicht alle Datenbanken und Systemkataloge gleichzeitig reindizieren
 %s: kann nicht eine bestimmte Tabelle in allen Datenbanken vacuumen
 %s: kann nicht alle Datenbanken und eine bestimmte gleichzeitig vacuumen
 %s: clustere Datenbank �%s�
 %s: Clustern der Datenbank �%s� fehlgeschlagen: %s %s: Clustern der Tabelle �%s� in Datenbank �%s� fehlgeschlagen: %s %s: Erzeugung des Kommentars ist fehlgeschlagen (Datenbank wurde erzeugt): %s %s: konnte nicht mit Datenbank %s verbinden
 %s: konnte nicht mit Datenbank %s verbinden: %s %s: konnte aktuellen Benutzernamen nicht ermitteln: %s
 %s: konnte Informationen �ber aktuellen Benutzer nicht ermitteln: %s
 %s: Erzeugung der neuen Rolle fehlgeschlagen: %s %s: Erzeugung der Datenbank ist fehlgeschlagen: %s %s: L�schen der Datenbank fehlgeschlagen: %s %s: Sprache �%s� ist bereits in Datenbank �%s� installiert
 %s: Sprache �%s� ist nicht in Datenbank �%s� installiert
 %s: Installation der Sprache fehlgeschlagen: %s %s: L�schen der Sprache fehlgeschlagen: %s %s: Datenbankname als Argument fehlt
 %s: Sprachenname als Argument fehlt
 %s: --locale und --lc-collate k�nnen nicht zusammen angegeben werden
 %s: --locale und --lc-ctype k�nnen nicht zusammen angegeben werden
 %s: Anfrage fehlgeschlagen: %s %s: Anfrage war: %s
 %s: reindiziere Datenbank �%s�
 %s: Reindizieren der Datenbank �%s� fehlgeschlagen: %s %s: Reindizieren des Index �%s� in Datenbank �%s� fehlgeschlagen: %s %s: Reindizieren der Systemkataloge fehlgeschlagen: %s %s: Reindizieren der Tabelle �%s� in Datenbank �%s� fehlgeschlagen: %s %s: L�schen der Rolle �%s� fehlgeschlagen: %s %s: noch %s Funktionen in Sprache �%s� deklariert; Sprache nicht gel�scht
 %s: zu viele Kommandozeilenargumente (das erste ist �%s�)
 %s: f�hre Vacuum in Datenbank �%s� aus
 %s: Vacuum der Datenbank �%s� fehlgeschlagen: %s %s: Vacuum der Tabelle �%s� in Datenbank �%s� fehlgeschlagen: %s Sind Sie sich sicher? Abbruchsanforderung gesendet
 Konnte Abbruchsanforderung nicht senden: %s Datenbank �%s� wird unwiderruflich gel�scht werden.
 Geben Sie es noch einmal ein:  Geben Sie den Namen der neuen Rolle ein:  Geben Sie den Namen der zu l�schenden Rolle ein:  Geben Sie das Passwort der neuen Rolle ein:  Name Passwortverschl�sselung ist fehlgeschlagen.
 Passwort:  Passw�rter stimmten nicht �berein.
 Bitte antworten Sie �%s� oder �%s�.
 Prozedurale Sprachen Rolle �%s� wird unwiderruflich gel�scht werden.
 Soll die neue Rolle ein Superuser sein? Soll die neue Rolle Datenbanken erzeugen d�rfen? Soll die neue Rolle weitere neue Rollen erzeugen d�rfen? Vertraut? Versuchen Sie �%s --help� f�r weitere Informationen.
 Aufruf:
 n nein Speicher aufgebraucht
 pg_strdup: kann NULL-Zeiger nicht kopieren (interner Fehler)
 j ja 