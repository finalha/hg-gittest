��    0      �  C         (  X   )  C   �  -   �  !   �           7  )   G  )   q  )   �  )   �  )   �  )     )   C  )   m  )   �  ,   �  )   �  )     )   B  ,   l  ,   �  )   �  )   �  )     )   D  )   n  ,   �  ,   �  ,   �  )   	  &   I	  �   p	  )   �	  �   &
    �
     �     
          *     >     P  )   ^  )   �  	   �     �     �     �  �  �  j   u  U   �  3   6  $   j  ,   �     �  6   �  4     7   <  4   t  4   �  4   �  5     4   I  4   ~  8   �  5   �  5   "  5   X  8   �  8   �  5      6   6  5   m  5   �  5   �  :     7   J  ,   �  5   �  7   �  �     4   �  �   �  @  �       	        &     B     \     u  7   �  6   �  	   �  
   �  	             $   0              
                           !   ,      )   *   (   "             .   /   	   '                                      #   +   -   %                                          &                                              
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
 by reference by value floating-point numbers in archive recovery in crash recovery in production pg_control last modified:             %s
 pg_control version number:            %u
 shut down shutting down starting up unrecognized status code Project-Id-Version: PostgreSQL 8.4
Report-Msgid-Bugs-To: pgsql-bugs@postgresql.org
POT-Creation-Date: 2009-05-06 20:17-0300
PO-Revision-Date: 2005-10-04 23:00-0300
Last-Translator: Euler Taveira de Oliveira <euler@timbira.com>
Language-Team: Brazilian Portuguese <pgbr-dev@listas.postgresql.org.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
 
Se o diretório de dados (DIRDADOS) não for especificado, a variável de ambiente PGDATA
é utilizada.

 %s mostra informações de controle de um agrupamento de banco de dados PostgreSQL.

 %s: não pôde abrir arquivo "%s" para leitura: %s
 %s: não pôde ler arquivo "%s": %s
 %s: nenhum diretório de dados especificado
 inteiros de 64 bits Blocos por segmento da relação grande:           %u
 Bytes por segmento do WAL:                       %u
 Número da versão do catálogo:                    %u
 Tamanho do bloco do banco de dados:              %u
 Estado do agrupamento de banco de dados:         %s
 Identificador do sistema de banco de dados:      %s
 Tipo de data/hora do repositório:                %s
 Passagem de argumento float4:                    %s
 Passagem de argumento float8:                    %s
 Último local do ponto de controle:               %X/%X
 Último ponto de controle NextMultiOffset:        %u
 Último ponto de controle NextMultiXactId:        %u
 Último ponto de controle NextOID:                %u
 Último ponto de controle NextXID:                %u/%u
 Último local do ponto de controle REDO:          %X/%X
 Último ponto de controle TimeLineID:             %u
 Máximo de colunas em um índice:                  %u
 Máximo alinhamento de dado:                      %u
 Tamanho máximo de identificadores:               %u
 Tamanho máximo do bloco TOAST:                   %u
 Local final mínimo de recuperação:               %X/%X
 Local do ponto de controle anterior:             %X/%X
 Relate erros a <pgsql-bugs@postgresql.org>.
 Hora do último ponto de controle:                %s
 Tente "%s --help" para obter informações adicionais.
 Uso:
  %s [OPÇÃO] [DIRDADOS]

Opções:
  --help         mostra esta ajuda e termina
  --version      mostra informação sobre a versão e termina
 Tamanho do bloco do WAL:                         %u
 AVISO: A soma de verificação de CRC não é a mesma do valor armazenado no arquivo.
O arquivo está corrompido ou tem um formato diferente do que este programa
está esperando.  Os resultados abaixo não são confiáveis.

 AVISO: possível não correspondência da ordenação dos bits
A ordenação dos bits utilizada para armazenar o arquivo pg_control pode não 
corresponder com a utilizada por este programa. Neste caso os resultados abaixo
seriam incorretos, e a instalação do PostgreSQL seria incompatível com o diretório de dados.
 por referência por valor números de ponto flutuante recuperando de uma cópia recuperando de uma queda em produção Última modificação do pg_control:                %s
 número da versão do pg_control:                  %u
 desligado desligando iniciando código de status desconhecido 