��    �        �   �	      H  K   I     �  f   �  
     >     >   \  =   �  -   �  C     A   K     �  #   �     �  (   �       <   +  9   h  6   �  H   �  E   "  B   h  9   �  C   �  9   )  4   c  E   �  =   �  .     ;   K  E   �  :   �  5     7   >  9   v  7   �  4   �  L     J   j  5   �  2   �  7     2   V  2   �  J   �  :     5   B  G   x  0   �  <   �  0   .  M   _  J   �  G   �  4   @  H   u  E   �  9     v   >  <   �  I   �  @   <  5   }  4   �  1   �  ;     5   V  6   �  3   �  4   �  =   ,  8   j  8   �  8   �  2     9   H  6   �  9   �     �  /   �  <   /  #   l  #   �  ?   �  %   �  #         >   3   ^   &   �   5   �   E   �   I   5!  5   !  I   �!  5   �!  E   5"  F   {"  4   �"  D   �"     <#  *   Z#  8   �#  6   �#  %   �#  (   $  (   D$  8   m$  #   �$      �$     �$  8   %  4   D%  $   y%     �%  ,   �%  ,   �%  ;   &  9   T&     �&     �&     �&  *   �&  8   �&  ,   8'  8   e'  #   �'  G   �'  4   
(     ?(  )   \(  7   �(     �(     �(  !   �(  +   )     /)     @)     \)     y)     �)     �)  
   �)     �)     �)     �)  '   *  "   7*  2   Z*  7   �*     �*  &   �*     �*     �*     �*     +  :   +     L+     N+  �  R+  T   K-     �-  k   �-     ".  M   +.  M   y.  L   �.  C   /  E   X/  C   �/     �/  '   �/     #0     >0     ^0  F   {0  C   �0  @   1  I   G1  F   �1  C   �1  ?   2  K   \2  K   �2  5   �2  J   *3  ;   u3  9   �3  ;   �3  \   '4  <   �4  9   �4  A   �4  ;   =5  B   y5  ?   �5  `   �5  `   ]6  7   �6  4   �6  @   +7  <   l7  ?   �7  P   �7  A   :8  <   |8  E   �8  8   �8  B   89  <   {9  L   �9  I   :  F   O:  =   �:  L   �:  I   !;  ;   k;  �   �;  A   +<  P   m<  E   �<  B   =  B   G=  ?   �=  <   �=  5   >  :   =>  =   x>  <   �>  D   �>  =   8?  A   v?  E   �?  ?   �?  8   >@  5   w@  I   �@     �@  %   A  G   )A  $   qA  #   �A  =   �A  -   �A  #   &B     JB  -   gB  5   �B  H   �B  W   C  ^   lC  N   �C  \   D  L   wD  [   �D  a    E  F   �E  U   �E  "   F  5   BF  D   xF  J   �F  2   G  5   ;G  :   qG  A   �G  0   �G  -   H  1   MH  <   H  ;   �H  -   �H  -   &I  0   TI  ,   �I  >   �I  <   �I  $   .J     SJ  &   pJ  9   �J  I   �J  ?   K  H   [K  /   �K  P   �K  4   %L      ZL  3   {L  B   �L     �L      M  1   M  /   QM     �M     �M  !   �M     �M     �M  %   �M     %N     .N  (   MN     vN  (   �N  *   �N  @   �N  :    O     [O  6   dO     �O     �O     �O     �O  F   �O     P     P     2   F   6   ]       m          �   8   _       t           �   �       P          �   Q   x                      <   e      c          k          >   l          �       �       ~   S   ;       %   @           !   r          C   K           �   f   3      G   Z   o      E   �       W   i   &   =   (      	   /   O   \   �   A           n   s   �       0      �   �   ^   }   d   �   �      �   #   J   Y   �             �   g   ?   :   y   +          {   1   w   �      �       z       -   4                   .                 q   �   5      `                      b       U   L   h   [      
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
POT-Creation-Date: 2011-09-24 13:17+0000
PO-Revision-Date: 2011-09-25 22:45+0200
Last-Translator: Begina Felicysym <begina.felicysym@wp.eu>
Language-Team: Begina Felicysym
Language: pl
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Plural-Forms: nplurals=3; plural=(n==1 ? 0 : n%10>=2 && n%10<=4 && (n%100<10 || n%100>=20) ? 1 : 2);
X-Generator: Virtaal 0.7.1-beta1
 
Domyślnie, jest tworzona baza danych o tej samej nazwie co bieżący użytkownik.
 
Opcje połączenia:
 
Jeśli jedna z -d, -D, -r, -R, -s, -S, i NAZWAROLI nie została wskazana,
będziesz pytany interaktywnie.
 
Opcje:
 
Przeczytaj opis polecenia SQL CLUSTER by uzyskać informacje szczegółowe.
 
Przeczytaj opis polecenia SQL REINDEX by uzyskać informacje szczegółowe.
 
Przeczytaj opis polecenia SQL VACUUM by uzyskać informacje szczegółowe.
 
Błędy proszę przesyłać na adres <pgsql-bugs@postgresql.org>.
       --lc-collate=LOKALIZACJA ustawienie LC_COLLATE dla bazy danych
       --lc-ctype=LOKALIZACJA   ustawienie LC_CTYPE dla bazy danych
   %s [OPCJA]... NAZWADB
   %s [OPCJA]... NAZWAJĘZYKA [NAZWADB]
   %s [OPCJA]... [NAZWADB]
   %s [OPCJA]... [NAZWA] [OPIS]
   %s [OPCJA]... [NAZWAROLI]
   --help                          pokazuje ten ekran pomocy i kończy
   --help                       pokazuje ten ekran pomocy i kończy
   --help                    pokazuje ten ekran pomocy i kończy
   --version                       pokazuje informacje o wersji i kończy
   --version                    pokazuje informacje o wersji i kończy
   --version                 pokazuje informacje o wersji i kończy
   -D, --no-createdb         rola nie może tworzyć baz danych
   -D, --tablespace=TABLESPACE  domyślna przestrzeń tabel dla bazy danych
   -E, --encoding=KODOWANIE     ustawia domyślne kodowanie dla bazy danych
   -E, --encrypted           szyfruje zapisane hasło
   -F, --freeze                    zamraża informację transakcji wiersza
   -I, --no-inherit          rola nie dziedziczy uprawnień
   -L, --no-login            rola nie może się logować
   -N, --unencrypted         nie szyfruje zapisanego hasła
   -O, --owner=WŁAŚCICIEL       użytkownik bazy danych będący właścicielem nowej bazy
   -P, --pwprompt            przypisuje hasło do nowej roli
   -R, --no-createrole       rola nie może tworzyć ról
   -S, --no-superuser        rola nie będzie superużytkownikiem
   -T, --template=SZABLON       szablon bazy do skopiowania
   -U, --username=NAZWAUZYTK    nazwa użytkownika do połączenia
   -U, --username=NAZWAUZYTK nazwa użytkownika do połączenia
   -U, --username=USERNAME   nazwa użytkownika do połączenia z bazą (nie tego do utworzenia)
   -U, --username=USERNAME   nazwa użytkownika do połączenia z bazą (nie tego do skasowania)
   -W, --password               wymuś pytanie o hasło
   -W, --password            wymuś pytanie o hasło
   -a, --all                       odkurza wszystkie bazy danych
   -a, --all                 sklastruj wszystkie bazy danych
   -a, --all                 przeindeksuj wszystkie bazy danych
   -c, --connection-limit=N  limit połączeń dla roli (domyślnie: bez limitu)
   -d, --createdb            rola może tworzyć nowe bazy danych
   -d, --dbname=NAZWADB            baza danych do odkurzenia
   -d, --dbname=NAZWADB      baza danych z której usunie się język
   -d, --dbname=NAZWADB      baza danych do klastrowania
   -d, --dbname=NAZWADB      baza danych do zainstalowania języka
   -d, --dbname=NAZWADB      baza danych do przeindeksowania
   -e, --echo                      pokazuje polecenia przesyłane do serwera
   -e, --echo                   pokazuje polecenia przesyłane do serwera
   -e, --echo                pokazuje polecenia przesyłane do serwera
   -f, --full                      wykonuje pełne odkurzenie
   -h, --host=NAZWAHOSTA        host serwera bazy danych lub katalog gniazda
   -h, --host=NAZWAHOSTA     host serwera bazy danych lub katalog gniazda
   -i, --index=INDEKS        odtwórz tylko wskazany indeks
   -i, --inherit             rola dziedziczy uprawnienia od ról, których
                            jest członkiem (domyślnie)
   -i, --interactive         monit przed usunięciem czegokolwiek
   -l, --list                pokazuje listę aktualnie zainstalowanych języków
   -l, --locale=LOKALIZACJA     ustawienia regionalne dla bazy danych
   -l, --login               rola może się logować (domyślnie)
   -p, --port=PORT              numer portu na serwera bazy dnaych
   -p, --port=PORT           numer portu na serwera bazy dnaych
   -q, --quiet                     nie wypisuje komunikatów
   -q, --quiet               nie wypisuj komunikatów
   -r, --createrole          rola może tworzyć nowe role
   -s, --superuser           rola będzie superużytkownikiem
   -s, --system              przeindeksuj katalogi systemowe
   -t, --table='TABLE[(COLUMNS)]'  odkurza tylko określoną tabelę
   -t, --table=TABELA        klastruj tylko wskazaną tabelę
   -t, --table=TABELA        przeindeksuj tylko wskazaną tabelę
   -v, --verbose                   wypisuje dużo danych wyjściowych
   -v, --verbose             wypisuje dużo danych wyjściowych
   -w, --no-password            nie pytaj nigdy o hasło
   -w, --no-password         nie pytaj nigdy o hasło
   -z, --analyze                   aktualizuje podpowiedzi optymalizatora
 %s (%s/%s)  %s czyści bazę danych PostgreSQL.

 %s klastruje wszystkie poprzednio sklastrowane tabele w bazie danych.

 %s tworzy bazę danych PostgreSQL.

 %s tworzy nową rolę PostgreSQL.

 %s instaluje język proceduralny w bazie danych PostgreSQL.

 %s przeindeksowuje bazę danych PostgreSQL.

 %s usuwa bazę danych PostgreSQL.

 %s usuwa rolę PostgreSQL.

 %s usuwa język proceduralny z bazy danych.

 %s: "%s" nie jest poprawną nazwą kodowania serwera
 %s: nie można klastrować wskazanej tabeli we wszystkich bazach danych
 %s: nie można klastrować wszystkich baz danych i jednej wskazanej w tym samym czasie
 %s: nie można przeindeksować wskazanego indeksu i katalogów systemowych w tym samym czasie
 %s: nie można przeindeksować wskazanego indeksu we wszystkich bazach danych
 %s: nie można przeindeksować wskazanej tabeli i katalogów systemowych w tym samym czasie
 %s: nie można przeindeksować wskazanej tabeli we wszystkich bazach danych
 %s: nie można przeindeksować wszystkich baz danych i jednej wskazanej w tym samym czasie
 %s: nie można przeindeksować wszystkich baz danych i katalogów systemowych w tym samym czasie
 %s: nie można odkurzyć wskazanej tabeli we wszystkich bazach danych
 %s: nie można odkurzyć wszystkich baz danych i jednej wskazanej w tym samym czasie
 %s: klastrowanie bazy danych "%s"
 %s: klastrowanie bazy danych "%s" nie udało się: %s %s: klastrowanie tabeli "%s" w bazie danych "%s" nie udało się: %s %s: nie udało się utworzyć notatki (baza danych została utworzona): %s %s: nie można połączyć się do bazy danych %s
 %s: nie można połączyć się do bazy danych %s: %s %s: nie można pobrać nazwy bieżącego użytkownika: %s
 %s: nie można uzyskać informacji o bieżącym użytkowniku: %s
 %s: utworzenie nowej roli nie powiodło się: %s %s: nie udało się utworzyć bazy danych: %s %s: usunięcie bazy danych nie powiodło się: %s %s: język "%s" jest już zainstalowany w bazie danych "%s"
 %s: język "%s" nie jest zainstalowany w bazie danych "%s"
 %s: instalacja języka nie powiodła się: %s %s: usunięcie języka nie powiodło się: %s %s: brak wymaganego argumentu nazwy bazy danych
 %s: brak wymaganego argumentu nazwy języka
 %s: tylko jedna z --locale i --lc-collate może być wskazany
 %s: tylko jedna z --locale i --lc-ctype może być wskazany
 %s: zapytanie nie powiodło się: %s %s: zapytanie brzmiało: %s
 %s: przeindeksowanie bazy danych "%s"
 %s: przeindeksowanie bazy danych "%s" nie udało się: %s %s: przeindeksowanie indeksu "%s" w bazie danych "%s" nie udało się: %s %s: przeindeksowanie katalogów systemowych nie udało się: %s %s: przeindeksowanie tabeli "%s" w bazie danych "%s" nie udało się: %s %s: usunięcie roli "%s" nie powiodło się: %s %s: pozostało %s funkcji zadeklarowanych w języku "%s"; nie usunięto języka
 %s: za duża ilość parametrów (pierwszy to "%s")
 %s: odkurzenie bazy danych "%s"
 %s: odkurzenie bazy danych "%s" nie udało się: %s %s: odkurzenie tabeli "%s" w bazie danych "%s" nie udało się: %s Czy na pewno? Wysłano żądanie anulowania
 Nie udało się wysłać żądania anulowania: %s Baza danych "%s" zostanie usunięta na stałe.
 Powtórz podane hasło:  Wpisz nazwę roli do dodania:  Wpisz nazwę roli do skasowania:  Podaj hasło dla nowej roli:  Nazwa Nie udało się zaszyfrować hasła.
 Hasło:  Podane hasła różnią się.
 Wymagana jest odpowiedź "%s" lub "%s".
 Języki Proceduralne Rola "%s" zostanie usunięta na stałe.
 Czy nowa rola ma być superużytkownikiem? Czy nowa rola ma mieć możliwość tworzenia nowych baz danych? Czy nowa rola ma mieć możliwość tworzenia nowych ról? Zaufany? Spróbuj "%s --help" aby uzyskać więcej informacji.
 Składnia:
 n nie brak pamięci
 pg_strdup: nie można powielić pustego wskazania (bład wewnętrzny)
 t tak 