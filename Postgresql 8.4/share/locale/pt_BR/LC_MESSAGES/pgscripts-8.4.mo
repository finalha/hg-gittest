��    �        �   �	      H  K   I     �  f   �  
     >     >   \  =   �  -   �  C     A   K     �  #   �     �  (   �       <   +  9   h  6   �  H   �  E   "  B   h  9   �  C   �  9   )  4   c  E   �  =   �  .     ;   K  E   �  :   �  5     7   >  9   v  7   �  4   �  L     J   j  5   �  2   �  7     2   V  2   �  J   �  :     5   B  G   x  0   �  <   �  0   .  M   _  J   �  G   �  4   @  H   u  E   �  9     v   >  <   �  I   �  @   <  5   }  4   �  1   �  ;     5   V  6   �  3   �  4   �  =   ,  8   j  8   �  8   �  2     9   H  6   �  9   �     �  /   �  <   /  #   l  #   �  ?   �  %   �  #         >   3   ^   &   �   5   �   E   �   I   5!  5   !  I   �!  5   �!  E   5"  F   {"  4   �"  D   �"     <#  *   Z#  8   �#  6   �#  %   �#  (   $  (   D$  8   m$  #   �$      �$     �$  8   %  4   D%  $   y%     �%  ,   �%  ,   �%  ;   &  9   T&     �&     �&     �&  *   �&  8   �&  ,   8'  8   e'  #   �'  G   �'  4   
(     ?(  )   \(  7   �(     �(     �(  !   �(  +   )     /)     @)     \)     y)     �)     �)  
   �)     �)     �)     �)  '   *  "   7*  2   Z*  7   �*     �*  &   �*     �*     �*     �*     +  :   +     L+     N+  �  R+  H   �,     !-  v   9-     �-  @   �-  @   �-  ?   >.  -   ~.  O   �.  M   �.     J/  %   e/     �/  )   �/     �/  >   �/  ;   /0  8   k0  P   �0  M   �0  J   C1  G   �1  H   �1  E   2  ;   e2  V   �2  9   �2  9   23  @   l3  W   �3  :   4  =   @4  ;   ~4  D   �4  ?   �4  ?   ?5  a   5  c   �5  +   E6  +   q6  >   �6  <   �6  >   7  M   X7  B   �7  =   �7  N   '8  :   v8  C   �8  <   �8  J   29  G   }9  D   �9  ;   
:  ]   F:  ]   �:  E   ;  ~   H;  :   �;  E   <  O   H<  >   �<  @   �<  @   =  >   Y=  8   �=  8   �=  6   
>  >   A>  G   �>  A   �>  C   
?  :   N?  4   �?  1   �?  1   �?  E   "@     h@  2   t@  G   �@  '   �@  &   A  C   >A  +   �A  )   �A  #   �A  6   �A  2   3B  I   fB  O   �B  Y    C  K   ZC  Y   �C  K    D  Q   LD  [   �D  H   �D  N   CE  "   �E  1   �E  @   �E  C   (F  -   lF  0   �F  0   �F  ;   �F  %   8G  *   ^G  *   �G  >   �G  ?   �G  (   3H  %   \H  5   �H  0   �H  K   �H  I   5I     I     �I  $   �I  3   �I  C   J  6   JJ  B   �J  %   �J  U   �J  ?   @K  !   �K  -   �K  <   �K     L  %    L  2   FL  4   yL     �L  (   �L  &   �L  !   M     5M     :M     YM     aM  !   |M     �M  *   �M  ,   �M  *   N  &   8N     _N  7   kN     �N     �N     �N     �N  ;   �N     �N     �N     2   F   6   ]       m          �   8   _       t           �   �       P          �   Q   x                      <   e      c          k          >   l          �       �       ~   S   ;       %   @           !   r          C   K           �   f   3      G   Z   o      E   �       W   i   &   =   (      	   /   O   \   �   A           n   s   �       0      �   �   ^   }   d   �   �      �   #   J   Y   �             �   g   ?   :   y   +          {   1   w   �      �       z       -   4                   .                 q   �   5      `                      b       U   L   h   [      
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
POT-Creation-Date: 2009-05-06 20:24-0300
PO-Revision-Date: 2005-10-06 00:21-0300
Last-Translator: Euler Taveira de Oliveira <euler@timbira.com>
Language-Team: Brazilian Portuguese <pgbr-dev@listas.postgresql.org.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
 
Por padrão, um banco de dados com o mesmo nome do usuário é criado.
 
Opções de conexão:
 
Se nenhuma das opções -d, -D, -r, -R, -s, -S e NOME_ROLE for especificada, você será
perguntado interativamente.
 
Opções:
 
Leia a descrição do comando SQL CLUSTER para obter detalhes.
 
Leia a descrição do comando SQL REINDEX para obter detalhes.
 
Leia a descrição do comando SQL VACUUM para obter detalhes.
 
Relate erros a <pgsql-bugs@postgresql.org>.
       --lc-collate=LOCALE      configuração LC_COLLATE para o banco de dados
       --lc-ctype=LOCALE        configuração LC_CTYPE para o banco de dados
   %s [OPÇÃO]... NOMEBD]
   %s [OPÇÃO]... LINGUAGEM [NOMEBD]
   %s [OPÇÃO]... [NOMEBD]
   %s [OPÇÃO]... [NOMEBD] [DESCRIÇÃO]
   %s [OPÇÃO]... [NOME_ROLE]
   --help                          mostra esta ajuda e termina
   --help                       mostra esta ajuda e termina
   --help                    mostra esta ajuda e termina
   --version                       mostra informação sobre a versão e termina
   --version                    mostra informação sobre a versão e termina
   --version                 mostra informação sobre a versão e termina
   -D, --no-createdb         role não pode criar novos bancos de dados
   -D, --tablespace=TABLESPACE  tablespace padrão para o banco de dados
   -E, --encoding=CODIFICAÇÃO   codificação para o banco de dados
   -E, --encrypted           criptografa a senha armazenada
   -F, --freeze                    congela informação sobre transação de registros
   -I, --no-inherit          role não herda privilégios
   -L, --no-login            role não pode efetuar login
   -N, --unencrypted         não criptografa a senha armazenada
   -O, --owner=DONO             usuário do banco que será dono do novo banco de dados
   -P, --pwprompt            atribui uma senha a nova role
   -R, --no-createrole       role não pode criar novas roles
   -S, --no-superuser        role não será super-usuário
   -T, --template=MODELO        modelo de banco de dados para copiar
   -U, --username=USUÁRIO    nome do usuário para se conectar
   -U, --username=USUÁRIO    nome do usuário para se conectar
   -U, --username=USUÁRIO    nome do usuário para se conectar (não é o usuário a ser criado)
   -U, --username=USUÁRIO    nome do usuário para se conectar (não é o usuário a ser removido)
   -W, --password            pergunta senha
   -W, --password            pergunta senha
   -a, --all                       limpa todos bancos de dados
   -a, --all                 agrupa todos os bancos de dados
   -a, --all                 reindexa todos os bancos de dados
   -c, --connection-limit=N  limite de conexão por role (padrão: ilimitado)
   -d, --createdb            role pode criar novos bancos de dados
   -d, --dbname=NOMEBD             banco de dados a ser limpo
   -d, --dbname=NOMEBD       banco de dados no qual será removido a linguagem
   -d, --dbname=NOMEBD       banco de dados a ser agrupado
   -d, --dbname=NOMEBD       banco de dados para instalar linguagem
   -d, --dbname=NOMEBD       banco de dados a ser reindexado
   -e, --echo                      mostra os comandos enviados ao servidor
   -e, --echo                   mostra os comandos enviados ao servidor
   -e, --echo                mostra os comandos enviados ao servidor
   -f, --full                      faz uma limpeza completa
   -h, --host=MÁQUINA        máquina do servidor de banco de dados ou diretório do soquete
   -h, --host=MÁQUINA        máquina do servidor de banco de dados ou diretório do soquete
   -i, --index=ÍNDICE        reindexa somente o índice especificado
   -i, --inherit             role herda privilégios de roles das quais ela
                            é um membro (padrão)
   -i, --interactive         pergunta antes de apagar algo
   -l, --list                mostra a lista das linguagens instaladas
   -l, --locale=LOCALE          configurações regionais para o banco de dados
   -l, --login               role pode efetuar login (padrão)
   -p, --port=PORTA          porta do servidor de banco de dados
   -p, --port=PORTA          porta do servidor de banco de dados
   -q, --quiet                     não exibe nenhuma mensagem
   -q, --quiet               não exibe nenhuma mensagem
   -r, --createrole          role pode criar novas roles
   -s, --superuser           role será super-usuário
   -s, --system              reindexa os catálogos do sistema
   -t, --table='TABELA[(COLUNAS)]' limpa somente uma tabela específica
   -t, --table=TABELA        agrupa somente a tabela especificada
   -t, --table=TABELA        reindexa somente a tabela especificada
   -v, --verbose                   mostra muitas mensagens
   -v, --verbose             mostra muitas mensagens
   -w, --no-password         nunca pergunta senha
   -w, --no-password         nunca pergunta senha
   -z, --analyze                   atualiza indicadores do otimizador
 %s (%s/%s)  %s limpa e analisa um banco de dados PostgreSQL.

 %s agrupa todas as tabelas agrupadas anteriormente no banco de dados.

 %s cria um banco de dados PostgreSQL.

 %s cria uma nova role do PostgreSQL.

 %s instala uma linguagem procedural no banco de dados PostgreSQL.

 %s reindexa um banco de dados PostgreSQL.

 %s remove um banco de dados PostgreSQL.

 %s remove uma role do PostgreSQL.

 %s remove uma linguagem procedural do banco de dados.
 %s: "%s" não é um nome de codificação válido
 %s: não pode agrupar uma tabela específica em todos os bancos de dados
 %s: não pode agrupar todos os bancos de dados e um específico ao mesmo tempo
 %s: não pode reindexar um índice específico e os catálogos do sistema ao mesmo tempo
 %s: não pode reindexar um índice específico em todos os bancos de dados
 %s: não pode reindexar uma tabela específica e os catálogos do sistema ao mesmo tempo
 %s: não pode reindexar uma tabela específica em todos os bancos de dados
 %s: não pode reindexar todos os bancos de dados e um específico ao mesmo tempo
 %s: não pode reindexar todos os bancos de dados e os catálogos do sistema ao mesmo tempo
 %s: não pode limpar uma tabela específica em todos os bancos de dados
 %s: não pode limpar todos os bancos de dados e um específico ao mesmo tempo
 %s: agrupando banco de dados "%s"
 %s: agrupamento do banco de dados "%s" falhou: %s %s: agrupamento da tabela "%s" no banco de dados "%s" falhou: %s %s: criação de comentário falhou (banco de dados foi criado): %s %s: não pôde conectar ao banco de dados %s
 %s: não pôde conectar ao banco de dados %s: %s %s: não pôde obter nome de usuário atual: %s
 %s: não pôde obter informação sobre usuário atual: %s
 %s: criação de nova role falhou: %s %s: criação do banco de dados falhou: %s %s: remoção do banco de dados falhou: %s %s: linguagem "%s" já está instalada no banco de dados "%s"
 %s: linguagem "%s" não está instalada no banco de dados "%s"
 %s: instalação de linguagem falhou: %s %s: remoção da linguagem falhou: %s %s: nome do banco de dados é um argumento requerido
 %s: nome da linguagem é um argumento requerido
 %s: somente uma das opções --locale e --lc-collate pode ser especificada
 %s: somente uma das opções --locale e --lc-ctype pode ser especificada
 %s: consulta falhou: %s %s: consulta foi: %s
 %s: reindexando banco de dados "%s"
 %s: reindexação do banco de dados "%s" falhou: %s %s: reindexação do índice "%s" no banco de dados "%s" falhou: %s %s: reindexação dos catálogos do sistema falhou: %s %s: reindexação da tabela "%s" no banco de dados "%s" falhou: %s %s: remoção da role "%s" falhou: %s %s: ainda há %s funções declaradas na linguagem "%s"; linguagem não foi removida
 %s: muitos argumentos para linha de comando (primeiro é "%s")
 %s: limpando banco de dados "%s"
 %s: limpeza no banco de dados "%s" falhou: %s %s: limpeza na tabela "%s" no banco de dados "%s" falhou: %s Você tem certeza? Requisição de cancelamento enviada
 Não pôde enviar requisição de cancelamento: %s Banco de dados "%s" será permanentemente removido.
 Digite-a novamente:  Digite o nome da role a ser adicionada:  Digite o nome da role a ser removida:  Digite a senha para a nova role:  Nome Criptografia de senha falhou.
 Senha:  Senhas não correspondem.
 Por favor responda "%s" ou "%s".
 Linguagens Procedurais Role "%s" será permanentemente removida.
 A nova role poderá criar um super-usuário? A nova role poderá criar bancos de dados? A nova role poderá criar novas roles? Confiável? Tente "%s --help" para obter informações adicionais.
 Uso:
 n não sem memória
 pg_strdup: não pode duplicar ponteiro nulo (erro interno)
 s sim 