��    �      <  �   \      (  R   )     |  
   �     �  -   �  �   �  �   n      A     5   X  J   �     �  6   �  P   ,  C   }  :   �  ]   �  4   Z  B   �  H   �  G     >   c  9   �  3   �  ?     /   P  -   �  E   �  y   �  (   n  #   �  7   �  (   �  ,     3   I  '   }  3   �  D   �  (     8   G  -   �  -   �  /   �  "     6   /  +   f     �  0   �  ;   �  $     /   ;     k  $   �  ~   �  1   -     _  /   }  J   �  �   �     �  C   �  -     8   E  !   ~  ,   �  /   �  4   �  A   2  @   t  ,   �  P   �  I   3  b   }     �     �  �     [   �     �     	     '  ;   ?  9   {  �   �  >   F  ;   �    �  u   �   q   H!  f   �!  s   !"  &   �"     �"     �"  &   �"  0   �"  .   +#  )   Z#  )   �#  "   �#  #   �#  "   �#      $  (   9$  "   b$     �$  "   �$  !   �$  ,   �$  $   %  *   7%  %   b%  !   �%     �%     �%     �%      �%     &     8&  -   S&  0   �&     �&     �&     �&  )   '     +'     /'  &   >'  %   e'     �'  +   �'  !   �'  i  �'  ]   Y)  %   �)     �)     �)  6   �)  �   4*  �   �*  3  �+  F   �,  2   -  I   4-  $   ~-  ?   �-  Z   �-  I   >.  A   �.  Z   �.  4   %/  I   Z/  D   �/  @   �/  >   *0  9   i0  8   �0  I   �0  5   &1  +   \1  P   �1  �   �1  4   �2  .   �2  ;   �2  /    3  ;   P3  >   �3  +   �3  ;   �3  H   34  7   |4  E   �4  1   �4  5   ,5  3   b5  *   �5  B   �5  3   6     86  :   T6  D   �6  ,   �6  6   7     87  '   X7  �   �7  +   
8      68  7   W8  S   �8  �   �8     �9  L   �9  1   $:  ;   V:  #   �:  -   �:  K   �:  :   0;  L   k;  9   �;  .   �;  _   !<  K   �<  q   �<     ?=  +   ^=  �   �=  b   (>  #   �>  ,   �>     �>  9   �>  B   +?  �   n?  B   @  :   R@  ;  �@  �   �A  �   VB  }   �B  �   [C  5   �C     $D     -D  #   @D  1   dD  -   �D  '   �D  '   �D  $   E  %   9E  )   _E  %   �E  0   �E  )   �E  %   
F  (   0F  /   YF  7   �F  ,   �F  B   �F  *   1G  "   \G     G     �G     �G     �G     �G     H  -   *H  @   XH  !   �H     �H     �H  $   �H     I     I  *   5I  )   `I     �I  .   �I  .   �I            X       m   C   U   e              q   Q   "       ^   ;   k       E   @   {   *       i          _           v          |   d      >   A   u      ?   +   o      t      h       J   �   c   [   Y   n   ]   1   a   P   W       b   D       j   �   !                         N           #   B   H      2   %   3   <          R   S   )   =   l   .             :              6      �   	   M              /       �   g      O              f               '       K   p      �      -   `   5   $   F   8              9   y   L   w   \       &       0       s             z   r       Z          
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
 selecting default max_connections ...  selecting default shared_buffers ...  setting password ...  setting privileges on built-in objects ...  vacuuming database template1 ...  Project-Id-Version: PostgreSQL 8.4
Report-Msgid-Bugs-To: pgsql-bugs@postgresql.org
POT-Creation-Date: 2009-04-10 19:10+0000
PO-Revision-Date: 2012-05-03 22:09+0300
Last-Translator: Peter Eisentraut <peter_e@gmx.net>
Language-Team: Peter Eisentraut <peter_e@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
 
Wenn kein Datenverzeichnis angegeben ist, dann wird die Umgebungsvariable
PGDATA verwendet.
 
Weniger h�ufig verwendete Optionen:
 
Optionen:
 
Weitere Optionen:
 
Berichten Sie Fehler an <pgsql-bugs@postgresql.org>.
 
Erfolg. Sie k�nnen den Datenbankserver jetzt mit

    %s%s%spostgres%s -D %s%s%s
oder
    %s%s%spg_ctl%s -D %s%s%s -l logdatei start

starten.

 
WARNUNG: Authentifizierung f�r lokale Verbindungen auf �trust� gesetzt
Sie k�nnen dies �ndern, indem Sie pg_hba.conf bearbeiten oder beim
n�chsten Aufruf von initdb die Option -A verwenden.
       --lc-collate=, --lc-ctype=, --lc-messages=LOCALE
      --lc-monetary=, --lc-numeric=, --lc-time=LOCALE
                            setze Standardlocale in der jeweiligen Kategorie
                            f�r neue Datenbanken (Voreinstellung aus der
                            Umgebung entnommen)
       --locale=LOCALE       setze Standardlocale f�r neue Datenbanken
       --no-locale           entspricht --locale=C
       --pwfile=DATEI        lese Passwort des neuen Superusers aus Datei
   %s [OPTION]... [DATENVERZEICHNIS]
   -?, --help                diese Hilfe anzeigen, dann beenden
   -A, --auth=METHODE        vorgegebene Authentifizierungsmethode f�r lokale Verbindungen
   -E, --encoding=KODIERUNG  setze Standardkodierung f�r neue Datenbanken
   -L VERZEICHNIS            wo sind die Eingabedateien zu finden
   -T, --text-search-config=KFG
                            Standardtextsuchekonfiguration
   -U, --username=NAME       Datenbank-Superusername
   -V, --version             Versionsinformationen anzeigen, dann beenden
   -W, --pwprompt            frage nach Passwort f�r neuen Superuser
   -X, --xlogdir=XLOGVERZ    Verzeichnis f�r den Transaktionslog
   -d, --debug               erzeuge eine Menge Debug-Ausgaben
   -n, --noclean             nach Fehlern nicht aufr�umen
   -s, --show                zeige interne Einstellungen
  [-D, --pgdata=]DATENVERZ   Datenverzeichnis f�r diesen Datenbankcluster
 %s initialisiert einen PostgreSQL-Datenbankcluster.

 %s: �%s� ist keine g�ltige Serverkodierung
 %s: Die Passwortdatei wurde nicht erzeugt. Bitte teilen Sie dieses Problem mit.
 %s: kann nicht als root ausgef�hrt werden
Bitte loggen Sie sich (z.B. mit �su�) als der (unprivilegierte) Benutzer
ein, der Eigent�mer des Serverprozesses sein soll.
 %s: konnte nicht auf Verzeichnis �%s� zugreifen: %s
 %s: konnte nicht auf Datei �%s� zugreifen: %s
 %s: konnte Rechte des Verzeichnisses �%s� nicht �ndern: %s
 %s: konnte Verzeichnis �%s� nicht erzeugen: %s
 %s: konnte symbolische Verkn�pfung �%s� nicht erzeugen: %s
 %s: konnte keine g�ltige kurze Versionszeichenkette ermitteln
 %s: konnte Befehl �%s� nicht ausf�hren: %s
 %s: konnte keine passende Kodierung f�r Locale �%s� finden
 %s: konnte keine passende Textsuchekonfiguration f�r Locale �%s� finden
 %s: konnte aktuellen Benutzernamen nicht ermitteln: %s
 %s: konnte Informationen �ber aktuellen Benutzer nicht ermitteln: %s
 %s: konnte Datei �%s� nicht zum Lesen �ffnen: %s
 %s: konnte Datei �%s� nicht zum Schreiben �ffnen: %s
 %s: konnte Passwort nicht aus Datei �%s� lesen: %s
 %s: konnte Datei �%s� nicht schreiben: %s
 %s: Datenverzeichnis �%s� wurde auf Anwenderwunsch nicht entfernt
 %s: Verzeichnis �%s� existiert aber ist nicht leer
 %s: unpassende Kodierungen
 %s: konnte Inhalt des Datenverzeichnisses nicht entfernen
 %s: konnte Inhalt des Transaktionslogverzeichnisses nicht entfernen
 %s: konnte Datenverzeichnis nicht entfernen
 %s: konnte Transaktionslogverzeichnis nicht entfernen
 %s: Datei �%s� existiert nicht
 %s: Datei �%s� ist keine normale Datei
 %s: Eingabedatei �%s� geh�rt nicht zu PostgreSQL %s
Pr�fen Sie Ihre Installation oder geben Sie den korrekten Pfad mit der
Option -L an.
 %s: Eingabedatei muss absoluten Pfad haben
 %s: ung�ltiger Locale-Name �%s�
 %s: Locale %s ben�tigt nicht unterst�tzte Kodierung %s
 %s: Superuser-Passwort muss angegeben werden um %s-Authentifizierung einzuschalten
 %s: kein Datenverzeichnis angegeben
Sie m�ssen das Verzeichnis angeben, wo dieses Datenbanksystem abgelegt
werden soll. Machen Sie dies entweder mit der Kommandozeilenoption -D
oder mit der Umgebungsvariable PGDATA.
 %s: Speicher aufgebraucht
 %s: Passwortprompt und Passwortdatei k�nnen nicht zusammen angegeben werden
 %s: entferne Inhalt des Datenverzeichnisses �%s�
 %s: entferne Inhalt des Transaktionslogverzeichnisses �%s�
 %s: entferne Datenverzeichnis �%s�
 %s: entferne Transaktionslogverzeichnis �%s�
 %s: symbolische Verkn�pfungen werden auf dieser Plattform nicht unterst�tzt %s: zu viele Kommandozeilenargumente (das erste ist �%s�)
 %s: Transaktionslogverzeichnis �%s� wurde auf Anwenderwunsch nicht entfernt
 %s: Transaktionslogverzeichnis muss absoluten Pfad haben
 %s: unbekannte Authentifizierungsmethode �%s�
 %s: Warnung: angegebene Textsuchekonfiguration �%s� passt m�glicherweise nicht zur Locale �%s�
 %s: Warnung: passende Textsuchekonfiguration f�r Locale �%s� ist unbekannt
 Kodierung %s ist nicht als serverseitige Kodierung erlaubt.
Starten Sie %s erneut mit einer anderen Locale-Wahl.
 Geben Sie es noch einmal ein:  Geben Sie das neue Superuser-Passwort ein:  Wenn Sie ein neues Datenbanksystem erzeugen wollen, entfernen oder leeren
Sie das Verzeichnis �%s� or f�hren Sie %s
mit einem anderen Argument als �%s� aus.
 Wenn Sie dort den Transaktionslog ablegen wollen, entfernen oder leeren
Sie das Verzeichnis �%s�.
 Passw�rter stimmten nicht �berein.
 F�hren Sie %s erneut mit der Option -E aus.
 Debug-Modus ist an.
 Noclean-Modus ist an. Bei Fehlern wird nicht aufger�umt.
 Der Datenbankcluster wird mit der Locale %s initialisiert werden.
 Der Datenbankcluster wird mit folgenden Locales initialisiert werden:
  COLLATE:  %s
  CTYPE:    %s
  MESSAGES: %s
  MONETARY: %s
  NUMERIC:  %s
  TIME:     %s
 Die Standarddatenbankkodierung wurde entsprechend auf %s gesetzt.
 Die Standardtextsuchekonfiguration wird auf �%s� gesetzt.
 Die von Ihnen gew�hlte Kodierung (%s) und die von der gew�hlten
Locale verwendete Kodierung (%s) passen nicht zu einander. Das
w�rde in verschiedenen Zeichenkettenfunktionen zu Fehlverhalten
f�hren. Starten Sie %s erneut und geben Sie entweder keine
Kodierung explizit an oder w�hlen Sie eine passende Kombination.
 Die Dateien, die zu diesem Datenbanksystem geh�ren, werden dem Benutzer
�%s� geh�ren. Diesem Benutzer muss auch der Serverprozess geh�ren.

 Das Programm �postgres� wird von %s ben�tigt, aber wurde nicht im
selben Verzeichnis wie �%s� gefunden.
Pr�fen Sie Ihre Installation.
 Das Programm �postgres� wurde von %s gefunden,
aber es hatte nicht die gleiche Version wie %s.
Pr�fen Sie Ihre Installation.
 Das k�nnte bedeuten, dass Ihre Installation fehlerhaft ist oder dass Sie das
falsche Verzeichnis mit der Kommandozeilenoption -L angegeben haben.
 Versuchen Sie �%s --help� f�r weitere Informationen.
 Aufruf:
 Signal abgefangen
 Kindprozess hat mit Code %d beendet Kindprozess hat mit unbekanntem Status %d beendet Kindprozess wurde durch Ausnahme 0x%X beendet Kindprozess wurde von Signal %d beendet Kindprozess wurde von Signal %s beendet kopiere template1 nach postgres ...  kopiere template1 nach template0 ...  konnte nicht in Verzeichnis �%s� wechseln konnte kein �%s� zum Ausf�hren finden konnte aktuelles Verzeichnis nicht ermitteln: %s konnte Verzeichnis �%s� nicht �ffnen: %s
 konnte Programmdatei �%s� nicht lesen konnte Verzeichnis �%s� nicht lesen: %s
 konnte symbolische Verkn�pfung �%s� nicht lesen konnte Datei oder Verzeichnis �%s� nicht entfernen: %s
 konnte Junction f�r �%s� nicht erzeugen: %s
 konnte �stat� f�r Datei oder Verzeichnis �%s� nicht ausf�hren: %s
 konnte nicht an Kindprozess schreiben: %s
 erzeuge Konfigurationsdateien ...  erzeuge Konversionen ...  erzeuge W�rterb�cher ...  erzeuge Verzeichnis %s ...  erzeuge Informationsschema ...  erzeuge Unterverzeichnisse ...  erzeuge Systemsichten ...  erzeuge Datenbank template1 in %s/base/1 ...  berichtige Zugriffsrechte des bestehenden Verzeichnisses %s ...  initialisiere Abh�ngigkeiten ...  initialisiere pg_authid ...  ung�ltige Programmdatei �%s� lade Systemobjektbeschreibungen ...  ok
 Speicher aufgebraucht
 w�hle Vorgabewert f�r max_connections ...  w�hle Vorgabewert f�r shared_buffers ...  setze das Passwort ...  setze Privilegien der eingebauten Objekte ...  f�hre Vacuum in Datenbank template1 durch ...  