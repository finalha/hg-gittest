��    H      \  a   �         9   !  -   [  ,   �  8   �  3   �  0   #  *   T  N     /   �  N   �     M  *   m  +   �     �  !   �  +   	  )   .	  #   X	  &   |	  -   �	  !   �	  !   �	  +   
  "   A
  (   d
     �
  S   �
  #   �
  #     #   >  #   b  #   �  #   �  \   �  +   +  0   W      �  @   �  D   �  &   /  -   V     �  )   �  )   �  )   �  )     )   <  )   f  )   �  )   �     �  V     )   X  )   �  )   �  ,   �  )     )   -  )   W  )   �  )   �  	   �  �   �     �  &   �  !   �  )   �  -   
     8     O  )   d  Z  �  M   �  1   7  2   i  :   �  5   �  3     (   A  G   j  2   �  L   �  !   2  -   T  -   �     �  !   �  %   �  (     %   ?  &   e  .   �  "   �  !   �  *      #   +  )   O     y  U   �  &   �  &   	  &   0  &   W  &   ~  &   �  W   �  .   $  2   S     �  H   �  N   �  )   =  0   g     �  )   �  )   �  )   �  )   %  )   O  )   y  )   �  )   �     �  X     -   m  -   �  )   �  ,   �  )      )   J  )   t  )   �  )   �  	   �  �   �  $   �  ,   �  *   �  )   )   1   S      �      �   )   �            $   >   @   /      '   &   #       =   3      C       ,          <      E   	                    1   4   .   ?            7              D          5           0      !              B             "          ;       -             6       *                      2   +   8   %      (   A            )   H       :   F          9   G       
               
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
 floating-point numbers pg_control values:

 pg_control version number:            %u
 Project-Id-Version: PostgreSQL 8.4
Report-Msgid-Bugs-To: pgsql-bugs@postgresql.org
POT-Creation-Date: 2009-06-13 17:15+0000
PO-Revision-Date: 2009-06-13 22:37+0300
Last-Translator: Peter Eisentraut <peter_e@gmx.net>
Language-Team: Swedish <sv@li.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
 
Om dessa v�rden verkar acceptable, anv�nd -f f�r
att forcera �terst�llande.
 
Reportera fel till <pgsql-bugs@postgresql.org>.
   --help          visa denna hj�lp, avsluta sedan
   --version       visa versionsinformation, avsluta sedan
   -O OFFSET       s�tt n�sta multitransaktionsoffset
   -x XIDEPOCH     s�tt n�sta transaktions-ID-epoch
   -f              forcera �terst�llande
   -l TLI,FILID,SEG    ange minsta WAL-startposition f�r ny transaktion
   -m XID          s�tt n�sta multitransaktions-ID
   -n              ingen updatering, visa bara kontrollv�rden (f�r testning)
   -o OID          s�tt n�sta OID
   -x XID          s�tt n�sta transaktions-ID
 %s �terst�ller PostgreSQL transaktionslogg.

 %s: OID (-o) f�r inte vara 0
 %s: kan inte exekveras av "root"
 %s: kunde byta katalog till "%s": %s
 %s: kunde inte skapa pg_control-fil: %s
 %s: kunde inte radera filen "%s": %s
 %s: kunde inte �ppna katalog "%s": %s
 %s: kunde inte �ppna fil "%s" f�r l�sning: %s
 %s: kunde inte �ppna fil "%s": %s
 %s: kunde inte l�sa fil "%s": %s
 %s: kunde inte l�sa fr�n katalog "%s": %s
 %s: kunde inte skriva fil "%s": %s
 %s: kunde inte skriva pg_control-fil: %s
 %s: fsync fel: %s
 %s: internt fel -- sizeof(ControlFileData) �r f�r stor ... r�tt till PG_CONTROL_SIZE
 %s: ogiltigt argument till flaggan -O
 %s: felaktigt argument till flagga -e
 %s: ogiltigt argument till flaggan -l
 %s: ogiltigt argument till flaggan -m
 %s: ogiltigt argument till flaggan -o
 %s: ogiltigt argument till flaggan -x
 %s: l�sfil "%s" existerar
K�r servern redan? Om inte, radera l�sfilen och f�rs�k igen.
 %s: multitransaktions-ID (-m) f�r inte vara 0
 %s: multitransaktionsoffset (-O) f�r inte vara -1
 %s: ingen datakatalog angiven
 %s: pg_control existerar men har ogiltig CRC; forts�tt med f�rsiktighet
 %s: pg_control existerar men �r trasig eller har ok�nd version; ignorerar den
 %s: transaktions-ID (-x) f�r inte vara 0
 %s: transaktions-ID epoch (-e) f�r inte vara -1
 64-bits heltal Block per segment i stor relation:    %u
 Bytes per WAL-segment:                %u
 Katalogversionsnummer:                %u
 Databasens blockstorlek:              %u
 Databasens systemidentifierare:       %s
 Lagringstyp f�r datum/tid:            %s
 F�rsta loggfil efter nollst�llning:   %u
 F�rsta loggfilsegment efter nollst.:  %u
 Gissade pg_control-v�rden:

 Om du �r s�ker p� att datakatalogs�kv�gen �r korrekt s� g�r
  touch %s
och f�rs�k igen.
 Senaste kontrollpunktens NextMultiOffset: %u
 Senaste kontrollpunktens NextMultiXactId: %u
 Senaste kontrollpunktens NextOID:     %u
 Senaste kontrollpunktens NextXID:     %u/%u
 Senaste kontrollpunktens TimeLineID:  %u
 Maximalt antal kolumner i index:      %u
 Maximal data-alignment:               %u
 Maximal l�ngd p� identifierare:       %u
 Maximal storlek p� TOAST-bit:         %u
 Flaggor:
 Databasservern st�ngdes inte ner korrekt. Att �terst�lla
transaktionsloggen kan medf�ra att data f�rloras.
Om du vill forts�tta �nd�, anv�nd -f f�r att forcera
�terst�llande.
 �terst�llande fr�n transaktionslogg
 F�rs�k med "%s --help" f�r mer information.
 Anv�ndning:
  %s [FLAGGA]... DATAKATALOG

 WAL-blockstorlek:                     %u
 Du m�ste k�ra %s som PostgreSQLs superanv�ndare.
 flyttalsnummer pg_control-v�rden:

 pg_control versionsnummer:            %u
 