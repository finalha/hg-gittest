��    k      t  �   �       	      !	     B	  &   T	     {	     �	  -   �	     �	     �	  |   
     �
  a   �
  K        f  A   �  !   �  3   �  ?     ?   Y  H   �  D   �  E   '  ?   m  >   �  9   �  B   &  <   i  z   �  0   !  F   R  >   �  8   �  2     O   D  7   �     �     �  �   �  !   m  C   �  y   �  C   M  D   �  >   �  A     *   W  /   �  %   �  /   �  #        ,  3   J  0   ~  ,   �  .   �  3     -   ?  0   m  5   �  "   �  $   �  J        g     �  3   �  0   �     �       !   1  $   S      x  -   �  4   �  %   �  $   "  "   G  F   j  F   �     �  7     )   D  q   n  f   �  %   G  &   m     �     �  &   �  0   �  .     )   B  )   l  "   �      �  (   �       !        @     X     l     �     �     �     �     �  "   �     �  ]    !   |     �  .   �  "   �  "     2   (     [     s  ~   �        b   /   J   �      �   B   �       ;!  9   \!  A   �!  ;   �!  C   "  L   X"  O   �"  @   �"  >   6#  9   u#  I   �#  E   �#  �   ?$  G   �$  I   %  B   [%  ;   �%  9   �%  E   &  2   Z&     �&     �&  �   �&     J'  >   g'  y   �'  A    (  7   b(  F   �(  ?   �(  2   !)  *   T)  &   )  .   �)  &   �)     �)  3   *  7   P*  /   �*  2   �*  7   �*  7   #+  /   [+  5   �+      �+  (   �+  M   ,     Y,     v,  7   �,  2   �,     �,     -     )-  '   E-  &   m-  &   �-  4   �-  !   �-  "   .     5.  P   S.  C   �.     �.  <   �.  +   3/  m   _/  g   �/  "   50  ,   X0     �0     �0      �0  ,   �0  '   �0  %   "1  %   H1  !   n1  !   �1  -   �1     �1  #   �1     2     :2     M2     b2     v2     �2     �2     �2  )   �2  %   �2               5      6         X                      (      9   .   #          d           '   R   Z   f   K   <   \   e      B   D   &       P   H          -   %              i   
   7       T   :                   G   A       4      C           [   *   b   Y   J                 c       _   	   F   @       !   "       ,   =      3       j               U   g      V                   S   L       1   $      ?   2       /      ]   O          N   k   8   +   >           a   h                 ^             Q   M       E   W           `   0       )   I   ;           
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
POT-Creation-Date: 2009-06-12 21:16+0000
PO-Revision-Date: 2009-06-13 22:44+0300
Last-Translator: Magnus Hagander <magnus@hagander.net>
Language-Team: Swedish <sv@li.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
 
Till�tna signalnamn f�r "kill":
 
Generella flaggor:
 
Flaggor f�r registrering och avregistrering:
 
Flaggor f�r start eller omstart:
 
Flaggor f�r stopp eller omstart:
 
Rapportera fel till <pgsql-bugs@postgresql.org>.
 
St�ngningsmetoder �r:
   %s kill    SIGNALNAMN PID
   %s register   [-N TJ�NSTNAMN] [-U ANV�NDARNAMN] [-P L�SENORD] [-D DATAKAT]
                    [-w] [-t SEK] [-o "FLAGGOR"]
   %s reload  [-D DATAKAT] [-s]
   %s restart [-w] [-t SEK] [-D DATAKAT] [-s] [-m ST�NGNINGSMETOD]
                 [-o "FLAGGOR"]
   %s start   [-w] [-t SEK] [-D DATAKAT] [-s] [-l FILENAMN] [-o "FLAGGOR"]
   %s status  [-D DATAKAT]
   %s stop    [-W] [-t SEK] [-D DATAKAT] [-s] [-m ST�NGNINGSMETOD]
   %s unregister [-N TJ�NSTNAMN]
   --help                 visa denna hj�lp, avsluta sedan
   --version              visa versionsinformation, avsluta sedan
   -D, --pgdata DATAKAT   plats f�r databasens lagringsarea
   -N TJ�NSTENAMN  tj�nstnamn att registrera PostgreSQL-servern med
   -P L�SENORD     l�senord f�r kontot att registrera PostgreSQL-servern med
   -U NAMN         anv�ndarnamn p� kontot att registrera PostgreSQL-servern med
   -W                     v�nta inte p� att operationen slutf�rs
   -c, --core-files       till�t postgres att skapa core-filer
   -c, --core-files       inte giltigt p� denna plattform
   -l, --log FILENAMN     skriv (eller addera) server-loggen till FILNAMN
   -m ST�NGNINGSMETOD     kan vara "smart", "fast", eller "immediate"
   -o FLAGGOR             kommandoradsflaggor som skickas vidare till postgres
                         (PostgreSQL-serverns k�rbara fil)
   -p S�KV�G-TILL-POSTGRES
                         beh�vs normalt inte
   -s, --silent           skriv bara ut fel, inga informationsmeddelanden
   -t SEK                 sekunder att v�nta om flaggan -w anv�nds
   -w                     v�nta p� att operationen slutf�rs
   fast        st�ng direkt, en kontrollerad nedst�ngning
   immediate   st�ng direkt; vid omstart kommer �terst�llning utf�ras
   smart       st�ng n�r alla klienter kopplat ner
 klar
  misslyckades
 %s �r ett verktyg f�r att starta, stoppa, starta om, ladda om
konfigureringsfiler, raportera statusen f�r en PostgreSQL-server
eller signalera en PostgreSQL-process.

 %s: PID-fil "%s" finns inte
 %s: en annan server verkar k�ra; f�rs�ker starta servern �nd�
 %s: kan inte k�ras som root
Logga in (t.ex. med "su") som den ickepriviligerade anv�ndare som
skall �ga serverprocessen.
 %s: kan inte ladda om servern; en-anv�ndar-server k�r (PID: %ld)
 %s: kan inte starta om servern; servern k�r (PID: %ld)
 %s: kan inte s�tta storlek p� core-fil; f�rbjudet av h�rd begr�nsning
 %s: kan inte stoppa servern; en-anv�ndar-server k�r (PID: %ld)
 %s: kunde inte hitta egna programmets k�rbara fil
 %s: kunde inte hitta postgres k�rbara fil
 %s: kunde inte �ppna PID-fil "%s": %s
 %s: kunde inte �ppna tj�nsten "%s": felkod %d
 %s: kunde inte �ppna tj�nsthanteraren
 %s: kunde inte l�sa filen "%s"
 %s: kunde inte registrera tj�nsten "%s": felkod %d
 %s: kunde inte skicka "reload"-signalen (PID: %ld): %s
 %s: kunde inte skicka signal %d (PID: %ld): %s
 %s: kunde inte skicka stopp-singal (PID: %ld): %s
 %s: kunde inte starta servern
Unders�k log-utskriften.
 %s: kunde inte starta servern: avslutningskoden var %d
 %s: kunde inte starta tj�nsten "%s": felkod %d
 %s: kunde inte avregistrera tj�nsten "%s": felkod %d
 %s: ogiltig data i PID-fil "%s"
 %s: saknar argumentet till "kill"-l�get
 %s: ingen databaskatalog angiven och omgivningsvariabeln PGDATA �r inte satt
 %s: ingen operation angiven
 %s: ingen server k�r
 %s: gamla serverprocessen (PID: %ld) verkar vara borta
 %s: inst�llningsfilen "%s" m�ste ha precis en rad
 %s: slut p� minnet
 %s: servern st�nger inte ner
 %s: servern k�r (PID: %ld)
 %s: tj�nsten "%s" �r redan registrerad
 %s: tj�nsten "%s" �r inte registrerad
 %s: en-anv�ndar-server k�r (PID: %ld)
 %s: f�r m�nga kommandoradsargument (f�rsta �r "%s")
 %s: ogiltigt operationsl�ge "%s"
 %s: ogiltigt st�ngningsmetod "%s"
 %s: ogiltigt signalnamn "%s"
 (Standard �r att v�nta p� nedst�ngning men inte v�nta p� start eller omstart.)

 Om flaggan -D inte angivits s� anv�nds omgivningsvariabeln PGDATA.
 K�r servern?
 Var v�nlig och stoppa en--anv�ndar-servern och f�rs�k igen.
 Server startad och accepterar anslutningar
 Programmet "postgres" beh�vs av %s men hittades inte i samma
katalog som "%s".
Kontrollera din installation.
 Programmet "postgres" hittades av "%s"
men �r inte samma version som %s.
Kontrollera din installation.
 Timeout vid v�ntan p� serverstart
 F�rs�k med "%s --help" f�r mer information.
 Anv�ndning:
 V�ntar p� serverstart...
 barnprocess avslutade med kod %d barnprocess avslutade med ok�nd statuskod %d barnprocess terminerades av felkod 0x%X barnprocess terminerades av signal %d barnprocess terminerades av signal %s kunde inte byta katalog till "%s" kunde inte hitta en "%s" att k�ra kunde inte identifiera aktuella katalogen: %s kunde inte l�sa bin�r "%s" kunde inte l�sa symbolisk l�nk "%s" kunde inte starta servern
 ogiltig bin�r "%s" servern st�nger ner
 servern signalerad
 servern startad
 servern startar
 servern stoppad
 startar servern �nd�
 v�ntar p� att servern skall st�nga ner... v�ntar p� att servern skall starta... 