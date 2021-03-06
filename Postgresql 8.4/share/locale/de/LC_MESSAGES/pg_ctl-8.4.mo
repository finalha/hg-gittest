��    l      |  �   �      0	      1	     R	  &   d	     �	     �	  -   �	     �	     
  |   +
     �
  a   �
  K   *     v  A   �  !   �  3   �  ?   )  ?   i  H   �  D   �  E   7  ?   }  >   �  9   �  B   6  <   y  z   �  0   1  F   b  >   �  8   �  2   !  O   T  7   �     �     �  �   �  !   }  C   �  y   �  C   ]  D   �  >   �  A   %  *   g  /   �  %   �  /   �  #        <  3   Z  0   �  ,   �  .   �  3     -   O  0   }  5   �  "   �  $     J   ,     w     �  3   �  0   �          "  !   A  $   c      �  -   �  4   �  %     $   2  "   W  F   z  F   �       7     )   T  q   ~  f   �  %   W  &   }     �  d   �       &   0  0   W  .   �  )   �  )   �  "         .  (   O     x  !   �     �     �     �     �               )     9  "   Q     t  i  �  "   �        ,   :  #   g  &   �  6   �     �     �  �      !   �   d   �   N   &!     u!  C   �!  !   �!  <   �!  F   5"  .   |"  C   �"  N   �"  D   >#  E   �#  C   �#  8   $  w   F$  @   �$  s   �$  7   s%  G   �%  :   �%  ?   .&  4   n&  e   �&  F   	'     P'     Y'  �   b'  #   8(  J   \(  �   �(  G   N)  I   �)  V   �)  F   7*  -   ~*  1   �*  +   �*  4   
+  '   ?+  "   g+  :   �+  ;   �+  1   ,  4   3,  ;   h,  1   �,  5   �,  <   -  &   I-  (   p-  S   �-     �-     .  @   #.  2   d.     �.      �.     �.  %   �.  #   /  *   :/  :   e/  %   �/  $   �/      �/  _   0  W   l0     �0  M   �0  1   %1  �   W1  }   �1  5   \2  5   �2     �2  ~   �2     P3  #   p3  1   �3  -   �3  '   �3  '   4  )   D4  %   n4  0   �4  %   �4  /   �4     5     85     U5     l5     �5     �5     �5     �5  '   �5     �5               5      6         Y                      (      9   .   #          e           '   R   [   W   K   <   ]   f      B   D   &       P   H          -   %              j   
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
 waiting for server to shut down... waiting for server to start... Project-Id-Version: PostgreSQL 8.4
Report-Msgid-Bugs-To: pgsql-bugs@postgresql.org
POT-Creation-Date: 2009-01-16 08:56+0000
PO-Revision-Date: 2009-01-16 11:29+0200
Last-Translator: Peter Eisentraut <peter_e@gmx.net>
Language-Team: Peter Eisentraut <peter_e@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
 
Erlaubte Signalnamen f�r �kill�:
 
Optionen f�r alle Modi:
 
Optionen f�r �register� oder �unregister�:
 
Optionen f�r Start oder Neustart:
 
Optionen f�r Anhalten oder Neustart:
 
Berichten Sie Fehler an <pgsql-bugs@postgresql.org>.
 
Shutdown-Modi sind:
   %s kill    SIGNALNAME PID
   %s register   [-N SERVICENAME] [-U BENUTZERNAME] [-P PASSWORT]
                    [-D DATENVERZ] [-t SEK] [-w] [-o "OPTIONEN"]
   %s reload  [-D DATENVERZ] [-s]
   %s restart [-w] [-t SEK] [-D DATENVERZ] [-s] [-m SHUTDOWN-MODUS]
                 [-o "OPTIONEN"]
   %s start   [-w] [-t SEK] [-D DATENVERZ] [-s] [-l DATEINAME] [-o "OPTIONEN"]
   %s status  [-D DATENVERZ]
   %s stop    [-W] [-t SEK] [-D DATENVERZ] [-s] [-m SHUTDOWN-MODUS]
   %s unregister [-N SERVICENAME]
   --help                 diese Hilfe anzeigen, dann beenden
   --version              Versionsinformationen anzeigen, dann beenden
   -D, --pgdata DATENVERZ Datenbankverzeichnis
   -N SERVICENAME  Servicename um PostgreSQL-Server zu registrieren
   -P PASSWORD     Passwort des Benutzers um PostgreSQL-Server zu registrieren
   -U USERNAME     Benutzername um PostgreSQL-Server zu registrieren
   -W                     warte nicht bis Operation abgeschlossen ist
   -c, --core-files       erlaubt postgres Core-Dateien zu erzeugen
   -c, --core-files       betrifft diese Plattform nicht
   -l, --log DATEINAME    schreibe Serverlog in DATEINAME (wird an
                         bestehende Datei angeh�ngt)
   -m SHUTDOWN-MODUS  kann �smart�, �fast� oder �immediate� sein
   -o OPTIONEN            Kommandozeilenoptionen f�r postgres (PostgreSQL-
                         Serverprogramm)
   -p PFAD-ZU-POSTGRES    normalerweise nicht notwendig
   -s, --silent           zeige nur Fehler, keine Informationsmeldungen
   -t SEK                 Sekunden zu warten bei Option -w
   -w                     warte bis Operation abgeschlossen ist
   fast        beende direkt, mit richtigem Shutdown
   immediate   beende ohne vollst�ndigen Shutdown; f�hrt zu Recovery-Lauf
              beim Neustart
   smart       beende nachdem alle Clientverbindungen geschlossen sind
  fertig
  Fehler
 %s ist ein Hilfsprogramm, um einen PostgreSQL-Server zu starten,
anzuhalten, neu zu starten, Konfigurationsdateien neu zu laden, den
Serverstatus auszugeben oder ein Signal an einen PostgreSQL-Prozess zu
senden.

 %s: PID-Datei �%s� existiert nicht
 %s: ein anderer Server l�uft m�glicherweise; versuche trotzdem zu starten
 %s: kann nicht als root ausgef�hrt werden
Bitte loggen Sie sich (z.B. mit �su�) als der (unprivilegierte) Benutzer
ein, der Eigent�mer des Serverprozesses sein soll.
 %s: kann Server nicht neu laden; Einzelbenutzerserver l�uft (PID: %ld)
 %s: kann Server nicht neu starten; Einzelbenutzerserver l�uft (PID: %ld)
 %s: kann Grenzwert f�r Core-Datei-Gr��e nicht setzen; durch harten Grenzwert verboten
 %s: kann Server nicht anhalten; Einzelbenutzerserver l�uft (PID: %ld)
 %s: konnte eigene Programmdatei nicht finden
 %s: konnte �postgres� Programmdatei nicht finden
 %s: konnte PID-Datei �%s� nicht �ffnen: %s
 %s: konnte Service �%s� nicht �ffnen: Fehlercode %d
 %s: konnte Servicemanager nicht �ffnen
 %s: konnte Datei �%s� nicht lesen
 %s: konnte Service �%s� nicht registrieren: Fehlercode %d
 %s: konnte Signal zum Neuladen nicht senden (PID: %ld): %s
 %s: konnte Signal %d nicht senden (PID: %ld): %s
 %s: konnte Stopp-Signal nicht senden (PID: %ld): %s
 %s: konnte Server nicht starten
Pr�fen Sie die Logausgabe.
 %s: konnte Server nicht starten: Exitcode war %d
 %s: konnte Service �%s� nicht starten: Fehlercode %d
 %s: konnte Service �%s� nicht deregistrieren: Fehlercode %d
 %s: ung�ltige Daten in PID-Datei �%s�
 %s: fehlende Argumente f�r �kill�-Modus
 %s: kein Datenbankverzeichnis angegeben und Umgebungsvariable PGDATA nicht gesetzt
 %s: keine Operation angegeben
 %s: kein Server l�uft
 %s: alter Serverprozess (PID: %ld) scheint verschwunden zu sein
 %s: Optionsdatei �%s� muss genau eine Zeile haben
 %s: Speicher aufgebraucht
 %s: Server f�hrt nicht herunter
 %s: Server l�uft (PID: %ld)
 %s: Service �%s� bereits registriert
 %s: Service �%s� nicht registriert
 %s: Einzelbenutzerserver l�uft (PID: %ld)
 %s: zu viele Kommandozeilenargumente (das erste ist �%s�)
 %s: unbekannter Operationsmodus �%s�
 %s: unbekannter Shutdown-Modus �%s�
 %s: unbekannter Signalname �%s�
 (Die Voreinstellung ist, beim Herunterfahren zu warten, aber nicht beim
Start oder Neustart.)

 Wenn die Option -D weggelassen wird, dann wird die Umgebungsvariable
PGDATA verwendet.
 L�uft der Server?
 Bitte beenden Sie den Einzelbenutzerserver und versuchen Sie es noch einmal.
 Server wurde gestartet und nimmt Verbindungen an
 Das Programm �postgres� wird von %s ben�tigt, aber wurde nicht im
selben Verzeichnis wie �%s� gefunden.
Pr�fen Sie Ihre Installation.
 Das Programm �postgres� wurde von %s gefunden,
aber es hatte nicht die gleiche Version wie %s.
Pr�fen Sie Ihre Installation.
 Zeit�berschreitung beim Warten auf Start des Servers
 Versuchen Sie �%s --help� f�r weitere Informationen.
 Aufruf:
 WARNUNG: Online-Backup-Modus ist aktiv
Herunterfahren wird erst abgeschlossen werden, wenn pg_stop_backup() aufgerufen wird.

 Warte auf Start des Servers...
 Kindprozess hat mit Code %d beendet Kindprozess hat mit unbekanntem Status %d beendet Kindprozess wurde durch Ausnahme 0x%X beendet Kindprozess wurde von Signal %d beendet Kindprozess wurde von Signal %s beendet konnte nicht in Verzeichnis �%s� wechseln konnte kein �%s� zum Ausf�hren finden konnte aktuelles Verzeichnis nicht ermitteln: %s konnte Programmdatei �%s� nicht lesen konnte symbolische Verkn�pfung �%s� nicht lesen konnte Server nicht starten
 ung�ltige Programmdatei �%s� Server f�hrt herunter
 Signal an Server gesendet
 Server gestartet
 Server startet
 Server angehalten
 starte Server trotzdem
 warte auf Herunterfahren des Servers... warte auf Start des Servers... 