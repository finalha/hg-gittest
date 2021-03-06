��    L      |  e   �      p  9   q  -   �  ,   �  8     3   ?  0   s  *   �  N   �  /     N   N     �  *   �  +   �     	  !   0	  +   R	  )   ~	  #   �	  &   �	  -   �	  !   !
  !   C
  +   e
  "   �
  (   �
     �
  S   �
  #   F  #   j  #   �  #   �  #   �  #   �  \     +   {  0   �      �  @   �  D   :  &     -   �     �  )   �  )     )   8  )   b  )   �  )   �  )   �  )   
  )   4  )   ^     �  V   �  )   �  )   &  )   P  ,   z  )   �  )   �  )   �  )   %  )   O  	   y  �   �     $  &   ;  !   b  )   �  -   �     �     �     �     	  )     _  H  ^   �  6     5   >  ?   t  ;   �  8   �  %   )  Z   O  6   �  J   �  %   ,  1   R  1   �     �  ,   �  2     0   6  (   g  -   �  1   �  '   �  &     4   ?  *   t  0   �     �  Z   �  &   A  &   h  &   �  &   �  &   �  &     t   +  0   �  5   �  $     K   ,  V   x  +   �  3   �     /  -   A  -   o  -   �  -   �  -   �  -   '  -   U  -   �  -   �  -   �       t   ,  -   �  -   �  -   �  0   +   -   \   -   �   -   �   -   �   -   !  
   B!  �   M!  %   &"  5   L"  +   �"  -   �"  2   �"     #     #     #     .#  -   B#     @       E                 =   L      7   <   (   9      G          I   &       ,   4      H   $       B      .      2      D           '             C   K         %             	   J   !   A                            #   )          ;   ?      F   :                    0       1   -   *           >              
      8      +       6      3   5       "              /    
If these values seem acceptable, use -f to force reset.
 
Report bugs to <pgsql-bugs@postgresql.org>.
   --help          show this help, then exit
   --version       output version information, then exit
   -O OFFSET       set next multitransaction offset
   -e XIDEPOCH     set next transaction ID epoch
   -f              force update to be done
   -l TLI,FILE,SEG force minimum WAL starting location for new transaction log
   -m XID          set next multitransaction ID
   -n              no update, just show extracted control values (for testing)
   -o OID          set next OID
   -x XID          set next transaction ID
 %s resets the PostgreSQL transaction log.

 %s: OID (-o) must not be 0
 %s: cannot be executed by "root"
 %s: could not change directory to "%s": %s
 %s: could not create pg_control file: %s
 %s: could not delete file "%s": %s
 %s: could not open directory "%s": %s
 %s: could not open file "%s" for reading: %s
 %s: could not open file "%s": %s
 %s: could not read file "%s": %s
 %s: could not read from directory "%s": %s
 %s: could not write file "%s": %s
 %s: could not write pg_control file: %s
 %s: fsync error: %s
 %s: internal error -- sizeof(ControlFileData) is too large ... fix PG_CONTROL_SIZE
 %s: invalid argument for option -O
 %s: invalid argument for option -e
 %s: invalid argument for option -l
 %s: invalid argument for option -m
 %s: invalid argument for option -o
 %s: invalid argument for option -x
 %s: lock file "%s" exists
Is a server running?  If not, delete the lock file and try again.
 %s: multitransaction ID (-m) must not be 0
 %s: multitransaction offset (-O) must not be -1
 %s: no data directory specified
 %s: pg_control exists but has invalid CRC; proceed with caution
 %s: pg_control exists but is broken or unknown version; ignoring it
 %s: transaction ID (-x) must not be 0
 %s: transaction ID epoch (-e) must not be -1
 64-bit integers Blocks per segment of large relation: %u
 Bytes per WAL segment:                %u
 Catalog version number:               %u
 Database block size:                  %u
 Database system identifier:           %s
 Date/time type storage:               %s
 First log file ID after reset:        %u
 First log file segment after reset:   %u
 Float4 argument passing:              %s
 Float8 argument passing:              %s
 Guessed pg_control values:

 If you are sure the data directory path is correct, execute
  touch %s
and try again.
 Latest checkpoint's NextMultiOffset:  %u
 Latest checkpoint's NextMultiXactId:  %u
 Latest checkpoint's NextOID:          %u
 Latest checkpoint's NextXID:          %u/%u
 Latest checkpoint's TimeLineID:       %u
 Maximum columns in an index:          %u
 Maximum data alignment:               %u
 Maximum length of identifiers:        %u
 Maximum size of a TOAST chunk:        %u
 Options:
 The database server was not shut down cleanly.
Resetting the transaction log might cause data to be lost.
If you want to proceed anyway, use -f to force reset.
 Transaction log reset
 Try "%s --help" for more information.
 Usage:
  %s [OPTION]... DATADIR

 WAL block size:                       %u
 You must run %s as the PostgreSQL superuser.
 by reference by value floating-point numbers pg_control values:

 pg_control version number:            %u
 Project-Id-Version: PostgreSQL 8.4
Report-Msgid-Bugs-To: pgsql-bugs@postgresql.org
POT-Creation-Date: 2009-01-19 19:14+0000
PO-Revision-Date: 2009-01-19 23:07+0200
Last-Translator: Peter Eisentraut <peter_e@gmx.net>
Language-Team: German <peter_e@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
 
Wenn diese Werte akzeptabel scheinen, dann benutzen Sie -f um das
Zur�cksetzen zu erzwingen.
 
Berichten Sie Fehler an <pgsql-bugs@postgresql.org>.
   --help          diese Hilfe anzeigen, dann beenden
   --version       Versionsinformationen anzeigen, dann beenden
   -O OFFSET       n�chsten Multitransaktions-Offset setzen
   -e XIDEPOCHE    n�chste Transaktions-ID-Epoche setzen
   -f              �nderung erzwingen
   -l TLI,DATEIID,SEG
                  minimale WAL-Startposition f�r neuen Log erzwingen
   -m XID          n�chste Multitransaktions-ID setzen
   -n              keine �nderung, nur Kontrolldaten anzeigen (zum Testen)
   -o OID          n�chste OID setzen
   -x XID          n�chste Transaktions-ID setzen
 %s setzt den PostgreSQL-Transaktionslog zur�ck.

 %s: OID (-o) darf nicht 0 sein
 %s: kann nicht von �root� ausgef�hrt werden
 %s: konnte nicht in Verzeichnis �%s� wechseln: %s
 %s: konnte pg_control-Datei nicht erstellen: %s
 %s: konnte Datei �%s� nicht l�schen: %s
 %s: konnte Verzeichnis �%s� nicht �ffnen: %s
 %s: konnte Datei �%s� nicht zum Lesen �ffnen: %s
 %s: konnte Datei �%s� nicht �ffnen: %s
 %s: konnte Datei �%s� nicht lesen: %s
 %s: konnte aus dem Verzeichnis �%s� nicht lesen: %s
 %s: konnte Datei �%s� nicht schreiben: %s
 %sL konnte pg_control-Datei nicht schreiben: %s
 %s: fsync-Fehler: %s
 %s: interner Fehler -- sizeof(ControlFileData) ist zu gro� ... PG_CONTROL_SIZE reparieren
 %s: ung�ltiges Argument f�r Option -O
 %s: ung�ltiges Argument f�r Option -e
 %s: ung�ltiges Argument f�r Option -l
 %s: ung�ltiges Argument f�r Option -m
 %s: ung�ltiges Argument f�r Option -o
 %s: ung�ltiges Argument f�r Option -x
 %s: Sperrdatei �%s� existiert bereits
L�uft der Server?  Wenn nicht, dann Sperrdatei l�schen und nochmal versuchen.
 %s: Multitransaktions-ID (-m) darf nicht 0 sein
 %s: Multitransaktions-Offset (-O) darf nicht -1 sein
 %s: kein Datenverzeichnis angegeben
 %s: pg_control existiert, aber mit ung�ltiger CRC; mit Vorsicht fortfahren
 %s: pg_control existiert, aber ist kaputt oder hat unbekannte Version; wird ignoriert
 %s: Transaktions-ID (-x) darf nicht 0 sein
 %s: Transaktions-ID-Epoche (-e) darf nicht -1 sein
 64-Bit-Ganzzahlen Bl�cke pro Segment:                       %u
 Bytes pro WAL-Segment:                    %u
 Katalogversionsnummer:                    %u
 Datenbankblockgr��e:                      %u
 Datenbanksystemidentifikation:            %s
 Speicherung von Datum/Zeit-Typen:         %s
 Erste Logdatei-ID nach Zur�cksetzen:      %u
 Erstes Logdateisegment nach Zur�cksetzen: %u
 �bergabe von Float4-Argumenten:           %s
 �bergabe von Float8-Argumenten:           %s
 Gesch�tzte pg_control-Werte:

 Wenn Sie sicher sind, dass das Datenverzeichnis korrekt ist, f�hren Sie
  touch %s
aus und versuchen Sie es erneut.
 NextMultiOffset des letzten Checkpoints:  %u
 NextMultiXactId des letzten Checkpoints:  %u
 NextOID des letzten Checkpoints:          %u
 NextXID des letzten Checkpoints:          %u/%u
 TimeLineID des letzten Checkpoints:       %u
 Maximale Spalten in einem Index:          %u
 Maximale Datenausrichtung (Alignment):    %u
 Maximale Bezeichnerl�nge:                 %u
 Maximale Gr��e eines St�cks TOAST:        %u
 Optionen:
 Der Datenbankserver wurde nicht sauber heruntergefahren.
Beim Zur�cksetzen des Transaktionslogs k�nnen Daten verloren gehen.
Wenn Sie trotzdem weiter machen wollen, benutzen Sie -f, um das
Zur�cksetzen zu erzwingen.
 Transaktionslog wurde zur�ck gesetzt
 Versuchen Sie �%s --help� f�r weitere Informationen.
 Aufruf:
  %s [OPTION]... DATENVERZEICHNIS

 WAL-Blockgr��e:                           %u
 Sie m�ssen %s als PostgreSQL-Superuser ausf�hren.
 Referenz Wert Gleitkommazahlen pg_control-Werte:

 pg_control-Versionsnummer:                %u
 