��    .      �  =   �      �  X   �  C   J  -   �  !   �      �     �  )     )   9  )   c  )   �  )   �  )   �  )     )   5  )   _  ,   �  )   �  )   �  )   
  ,   4  ,   a  )   �  )   �  )   �  )     )   6  ,   `  ,   �  ,   �  )   �  &   	  �   8	  )   �	  �   �	    �
     �     �     �     �  )      )   *  	   T     ^     l     x  �  �  h     D   �  3   �  2   �  )   .     X  #   s  *   �  )   �  2   �  +     0   K  0   |  4   �  4   �  :     4   R  4   �  4   �  7   �  8   )  4   b  4   �  5   �  2     4   5  :   j  ;   �  B   �  3   $  5   X  �   �  6   #  �   Z         %     7     G     a  1   �  )   �     �     �                                 )   (   '                     +              "                
       	   .         $       -       ,                      #               *            &          !                %              
If no data directory (DATADIR) is specified, the environment variable PGDATA
is used.

 %s displays control information of a PostgreSQL database cluster.

 %s: could not open file "%s" for reading: %s
 %s: could not read file "%s": %s
 %s: no data directory specified
 64-bit integers Blocks per segment of large relation: %u
 Bytes per WAL segment:                %u
 Catalog version number:               %u
 Database block size:                  %u
 Database cluster state:               %s
 Database system identifier:           %s
 Date/time type storage:               %s
 Float4 argument passing:              %s
 Float8 argument passing:              %s
 Latest checkpoint location:           %X/%X
 Latest checkpoint's NextMultiOffset:  %u
 Latest checkpoint's NextMultiXactId:  %u
 Latest checkpoint's NextOID:          %u
 Latest checkpoint's NextXID:          %u/%u
 Latest checkpoint's REDO location:    %X/%X
 Latest checkpoint's TimeLineID:       %u
 Maximum columns in an index:          %u
 Maximum data alignment:               %u
 Maximum length of identifiers:        %u
 Maximum size of a TOAST chunk:        %u
 Minimum recovery ending location:     %X/%X
 Prior checkpoint location:            %X/%X
 Report bugs to <pgsql-bugs@postgresql.org>.
 Time of latest checkpoint:            %s
 Try "%s --help" for more information.
 Usage:
  %s [OPTION] [DATADIR]

Options:
  --help         show this help, then exit
  --version      output version information, then exit
 WAL block size:                       %u
 WARNING: Calculated CRC checksum does not match value stored in file.
Either the file is corrupt, or it has a different layout than this program
is expecting.  The results below are untrustworthy.

 WARNING: possible byte ordering mismatch
The byte ordering used to store the pg_control file might not match the one
used by this program.  In that case the results below would be incorrect, and
the PostgreSQL installation would be incompatible with this data directory.
 by reference by value floating-point numbers in production pg_control last modified:             %s
 pg_control version number:            %u
 shut down shutting down starting up unrecognized status code Project-Id-Version: pg_controldata (PostgreSQL 8.4)
Report-Msgid-Bugs-To: pgsql-bugs@postgresql.org
POT-Creation-Date: 2011-09-24 13:18+0000
PO-Revision-Date: 2005-01-10 1:47+0100
Last-Translator: Begina Felicysym <begina.felicysym@wp.eu>
Language-Team: TortoiseSVN Polish translation team
Language: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
 
W przypadku gdy katalog danych nie jest podany (DATADIR), zmienna środowiskowa PGDATA
jest używana.

 %s wyświetla informacje kontrolne klastra bazy danych PostgreSQL.

 %s: nie można otworzyć pliku "%s" do odczytu: %s
 %s: nie można otworzyć pliku "%s" do zapisu: %s
 %s: katalog danych nie został ustawiony
 64-bit'owe zmienne integer Bloki na segment są w relacji: %u
 Bajtów na segment WAL:                %u
 Katalog w wersji numer:               %u
 Wielkość bloku bazy danych:                  %u
 Stan klastra bazy danych:               %s
 Identyfikator systemu bazy danych:           %s
 Typ przechowywania daty/czasu:               %s
 Przekazywanie parametru float4:                  %s
 Przekazywanie parametru float8:                  %s
 Najnowsza lokalizacja punktu kontrolnego:           %X/%X
 NextMultiOffset najnowszego punktu kontrolnego:  %u
 NextMultiXactId najnowszego punktu kontrolnego:  %u
 NextOID najnowszego punktu kontrolnego:          %u
 NextXID najnowszego punktu kontrolnego:          %u/%u
 Najnowsza lokalizacja punktu kontrolnego REDO:    %X/%X
 TimeLineID najnowszego punktu kontrolnego:       %u
 Maksymalna liczba kolumn w indeksie:             %u
 Maksymalne wyrównanie danych:                    %u
 Maksymalna długość identyfikatorów:        %u
 Maksymalny rozmiar fragmentu TOAST:              %u
 Położenie zakończenia odzyskiwania minimalnego:  %X/%X
 Uprzednia lokalizacja punktu kontrolnego:            %X/%X
 Błędy proszę przesyłać na adres <pgsql-bugs@postgresql.org>.
 Czas najnowszego punktu kontrolnego:            %s
 Spróbuj "%s --help" aby uzykać więcej informacji.
 Składnia:
  %s [OPCJA] [KATALOG]

Opcje:
  --help         pokaż ekran pomocy i zakończ
  --version      wyświetl informacje o wersji i zakończ
 Wielkość bloku WAL:                              %u
 UWAGA: obliczona suma kontrolna CRC pliku nie zgadza się.
Albo plik jest uszkodzony albo posiada inny układ niż program spodziewał się.
Rezultaty mogą być niepewne.

 OSTRZEŻENIE: możliwe niepoprawna kolejność bajtów
Kolejność bajtów używana do przechowywania plików pg_control może nie pasować
do używanej przez ten program.  W tym przypadku wynik poniżej jest błędny,
a instalacja PostgreSQL byłaby niezgodna z tym folderem danych.
 przez referencję przez wartość liczby zmiennoprzecinkowe baza danych w trybie produkcji pg_control ostantio modyfikowano:             %s
 pg_control w wersji numer:            %u
 wyłącz bazę danych wyłączanie bazy danych włączanie nieznany kod statusu 