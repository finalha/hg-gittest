��    G      T  a   �        9     -   K  ,   y  8   �  3   �  *     N   >  /   �  N   �       *   ,  +   W     �  !   �  +   �  )   �  #   	  &   ;	  -   b	  !   �	  !   �	  +   �	  "    
  (   #
     L
  J   a
     �
     �
  #   �
  #     #   2  #   V  #   z  \   �  +   �  0   '      X  @   y  D   �  &   �     &  )   6  )   `  )   �  )   �  )   �  )        2  V   O  )   �  )   �  )   �  )   $  )   N  )   x  )   �  )   �  )   �  )      )   J  )   t  	   �  �   �     G  &   ^  !   �  -   �     �     �  )     [  +  Q   �  3   �  3     C   A  E   �  (   �  Z   �  >   O  _   �  (   �  5     7   M  )   �  )   �  1   �  /     +   ;  -   g  9   �  +   �  )   �  /   %  )   U  /        �  R   �           9  )   X  )   �  )   �  )   �  )      t   *  @   �  E   �  (   &  T   O  Q   �  7   �     .  )   D  )   n  )   �  )   �  )   �  )        @  q   ]  )   �  )   �  5   #  5   Y  )   �  )   �  )   �  4     ,   B  )   o  )   �  )   �  	   �  �   �  %   �   3   �   &   !  D   @!     �!     �!  )   �!     
      $       B         '   &          <   -   4   C       +          ;      D                        0   1   ,   3            6                  .      2           /      !       =                     "          :       A             5       @   9              >   ?   *   7   %      (   8            )   G       #              E   F      	               
If these values seem acceptable, use -f to force reset.
 
Report bugs to <pgsql-bugs@postgresql.org>.
   --help          show this help, then exit
   --version       output version information, then exit
   -O OFFSET       set next multitransaction offset
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
 %s: internal error -- sizeof(ControlFileData) is too large ... fix xlog.c
 %s: invalid LC_COLLATE setting
 %s: invalid LC_CTYPE setting
 %s: invalid argument for option -O
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
 64-bit integers Blocks per segment of large relation: %u
 Catalog version number:               %u
 Current log file ID:                  %u
 Database block size:                  %u
 Database system identifier:           %s
 Date/time type storage:               %s
 Guessed pg_control values:

 If you are sure the data directory path is correct, execute
  touch %s
and try again.
 LC_COLLATE:                           %s
 LC_CTYPE:                             %s
 Latest checkpoint's NextMultiOffset:  %u
 Latest checkpoint's NextMultiXactId:  %u
 Latest checkpoint's NextOID:          %u
 Latest checkpoint's NextXID:          %u
 Latest checkpoint's TimeLineID:       %u
 Maximum columns in an index:          %u
 Maximum data alignment:               %u
 Maximum length of identifiers:        %u
 Maximum length of locale name:        %u
 Next log file segment:                %u
 Options:
 The database server was not shut down cleanly.
Resetting the transaction log may cause data to be lost.
If you want to proceed anyway, use -f to force reset.
 Transaction log reset
 Try "%s --help" for more information.
 Usage:
  %s [OPTION]... DATADIR

 You must run %s as the PostgreSQL superuser.
 floating-point numbers pg_control values:

 pg_control version number:            %u
 Project-Id-Version: pg_resetxlog-ro
Report-Msgid-Bugs-To: 
POT-Creation-Date: 2006-01-24 15:25+0100
PO-Revision-Date: 2006-02-05 22:42+0200
Last-Translator: Alin Vaida <alin.vaida@gmail.com>
Language-Team: Rom�n� <en@li.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
X-Generator: KBabel 1.11.2
 
Dac� aceste valori sunt acceptabile, folosi�i -f pentru a for�a reini�ializarea
 
Raporta�i erorile la <pgsql-bugs@postgresql.org>.
   --help          afi�eaz� acest ajutor, apoi iese
   --version       afi�eaz� informa�iile despre versiune, apoi iese
   -O OFFSET       seteaz� urm�toarea decalare de tranzac�ie multipl�
   -f              for�eaz� actualizarea
   -l TLI,FI�IER,SEG for�eaz� loca�ia de start minim� WAL pentru noul jurnal de tranzac�ii
   -m XID          seteaz� urm�torul ID de tranzac�ie multipl�
   -n              f�r� actualizare, doar afi�eaz� valorile de control extrase (pentru testare)
   -o OID          seteaz� urm�torul OID
   -x XID          seteaz� urm�torul ID de tranzac�ie
 %s reini�ializeaz� jurnalul de tranzac�ii PostgreSQL.

 %s: OID (-o) trebuie s� fie diferit de 0
 %s: nu poate fi executat de c�tre "root"
 %s: imposibil de schimbat directorul �n "%s": %s
 %s: imposibil de creat fi�ierul pg_control: %s
 %s: imposibil de �ters directorul "%s": %s
 %s: imposibil de deschis directorul "%s": %s
 %s: imposibil de deschis fi�ierul "%s" pentru citire: %s
 %s: imposibil de deschis fi�ierul "%s": %s
 %s: imposibil de citit fi�ierul "%s": %s
 %s: imposibil de citit din directorul "%s": %s
 %s: imposibil de scris fi�ierul "%s": %s
 %s: imposibil de scris fi�ierul pg_control: %s
 %s: eroare fsync: %s
 %s: eroare intern� -- sizeof(ControlFileData) este prea mare ... corecta�i xlog.c
 %s: setare LC_COLLATE incorect�
 %s: setare LC_CTYPE incorect�
 %s: argument incorect pentru op�iunea -O
 %s: argument incorect pentru op�iunea -l
 %s: argument incorect pentru op�iunea -m
 %s: argument incorect pentru op�iunea -o
 %s: argument incorect pentru op�iunea -x
 %s: fi�ierul de blocare "%s" exist�
Ruleaz� un server?  Dac� nu, �terge�i fi�ierul de blocare �i �ncerca�i din nou.
 %s: ID-ul tranzac�iei multiple (-m) trebuie s� fie diferit de 0
 %s: decalarea tranzac�iei multiple (-O) trebuie s� fie diferit de -1
 %s: nici un director de date specificat
 %s: pg_control exist�, dar are suma de control CRC incorect�; continua�i cu aten�ie
 %s: pg_control exist�, dar este defect sau are o versiune necunoscut�; se ignor�
 %s: ID-ul tranzac�iei (-x) trebuie s� fie diferit de 0
 �ntregi pe 64 de bi�i Blocuri/segment pentru rela�ii mari:  %u
 Num�r versiune catalog:               %u
 ID fi�ier jurnal curent:              %u
 Dimensiune bloc baz� de date:         %u
 Identificator sistem baze de date:    %s
 Stocare tip dat�/timp:                %s
 Valori pg_control ghicite:

 Dac� sunte�i convins de corectitudinea c�ii c�tre directorul de date, executa�i
  touch %s
�i �ncerca�i din nou.
 LC_COLLATE:                           %s
 LC_CTYPE:                             %s
 NextMultiOffset al ultimulului punct de control:  %u
 NextMultiXactId al ultimulului punct de control:  %u
 NextOID ultimul punct de salvare:     %u
 NextXID ultimul punct de salvare:     %u
 TimeLineID ultimul punct de salvare:  %u
 Num�rul maxim de coloane �ntr-un index:          %u
 Aliniere maxim� a datelor:               %u
 Lungime maxim� a identificatorilor:   %u
 Lungime maxim� a numelui localiz�rii: %u
 Segment fi�ier jurnal urm�tor:        %u
 Op�iuni:
 Serverul de baze de date nu a fost �nchis corect.
Reini�ializarea jurnalului de tranzac�ii poate cauza pierderi de date.
Dac� dori�i s� continua�i oricum, folosi�i -f pentru a for�a reini�ializarea.
 Jurnalul de tranzac�ii reini�ializat
 �ncerca�i "%s --help" pentru mai multe informa�ii.
 Utilizare:
  %s [OP�IUNE]... DIRDATE

 Trebuie s� rula�i %s ca utilizatorul privilegiat pentru PostgreSQL.
 numere �n virgul� mobil� Valori pg_control:

 Num�r versiune pg_control:            %u
 