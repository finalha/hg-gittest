��    �        �   �	      H  K   I     �  f   �  
     >     >   \  =   �  -   �  C     A   K     �  #   �     �  (   �       <   +  9   h  6   �  H   �  E   "  B   h  9   �  C   �  9   )  4   c  E   �  =   �  .     ;   K  E   �  :   �  5     7   >  9   v  7   �  4   �  L     J   j  5   �  2   �  7     2   V  2   �  J   �  :     5   B  G   x  0   �  <   �  0   .  M   _  J   �  G   �  4   @  H   u  E   �  9     v   >  <   �  I   �  @   <  5   }  4   �  1   �  ;     5   V  6   �  3   �  4   �  =   ,  8   j  8   �  8   �  2     9   H  6   �  9   �     �  /   �  <   /  #   l  #   �  ?   �  %   �  #         >   3   ^   &   �   5   �   E   �   I   5!  5   !  I   �!  5   �!  E   5"  F   {"  4   �"  D   �"     <#  *   Z#  8   �#  6   �#  %   �#  (   $  (   D$  8   m$  #   �$      �$     �$  8   %  4   D%  $   y%     �%  ,   �%  ,   �%  ;   &  9   T&     �&     �&     �&  *   �&  8   �&  ,   8'  8   e'  #   �'  G   �'  4   
(     ?(  )   \(  7   �(     �(     �(  !   �(  +   )     /)     @)     \)     y)     �)     �)  
   �)     �)     �)     �)  '   *  "   7*  2   Z*  7   �*     �*  &   �*     �*     �*     �*     +  :   +     L+     N+  S  R+  �   �-  ,   (.  �   U.     /  �   %/  �   �/  v   +0  W   �0  ^   �0  \   Y1      �1  2   �1  )   
2  <   42  -   q2  W   �2  T   �2  Q   L3  N   �3  K   �3  H   94  \   �4  �   �4  Q   j5  W   �5  x   6  H   �6  N   �6  X   %7  r   ~7  P   �7  S   B8  d   �8  j   �8  r   f9  o   �9  �   I:  �   �:  ?   �;  <   �;  P   .<  I   <  \   �<  �   &=  Z   �=  a   >  m   �>  `   �>  j   O?  R   �?  o   @  l   }@  i   �@  S   TA  q   �A  n   B  f   �B  �   �B  U   �C  b   D  O   fD  x   �D  O   /E  L   E  K   �E  T   F  ^   mF  d   �F  c   1G  m   �G  o   H  u   sH  a   �H  [   KI  H   �I  E   �I  [   6J     �J  O   �J  }   �J  5   |K  A   �K  n   �K  E   cL  5   �L  (   �L  O   M  R   XM  s   �M  x   N  �   �N  v   -O  �   �O  o   ;P  �   �P  �   7Q  f   �Q  y   0R  -   �R  F   �R  ]   S  q   }S  @   �S  C   0T  Z   tT  m   �T  3   =U  @   qU  B   �U  N   �U  `   DV  N   �V  J   �V  a   ?W  `   �W  D   X  F   GX  ?   �X     �X  <   �X  Y   !Y  a   {Y  b   �Y  c   @Z  :   �Z  d   �Z  h   D[  .   �[  G   �[  Q   $\     v\  -   �\  D   �\  O   ]     T]  +   p]  3   �]  8   �]     	^  7   ^     H^  &   W^  7   ~^  !   �^  B   �^  i   _  `   �_  `   �_     G`  [   ]`     �`     �`     �`     �`  |   �`     {a     }a     2   F   6   ]       m          �   8   _       t           �   �       P          �   Q   x                      <   e      c          k          >   l          �       �       ~   S   ;       %   @           !   r          C   K           �   f   3      G   Z   o      E   �       W   i   &   =   (      	   /   O   \   �   A           n   s   �       0      �   �   ^   }   d   �   �      �   #   J   Y   �             �   g   ?   :   y   +          {   1   w   �      �       z       -   4                   .                 q   �   5      `                      b       U   L   h   [      
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
POT-Creation-Date: 2012-07-10 22:45+0000
PO-Revision-Date: 2012-04-03 08:52+0400
Last-Translator: Alexander Lakhin <exclusion@gmail.com>
Language-Team: Russian <pgtranslation-translators@pgfoundry.org>
Language: ru
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Poedit-Language: Russian
X-Poedit-Country: RUSSIAN FEDERATION
Plural-Forms: nplurals=3; plural=(n%10==1 && n%100!=11 ? 0 : n%10>=2 && n%10<=4 && (n%100<10 || n%100>=20) ? 1 : 2);
X-Generator: Lokalize 1.4
 
По умолчанию именем базы данных считается имя текущего пользователя.
 
Параметры подключения:
 
Если параметры -d, -D, -r, -R, -s, -S или ИМЯ_РОЛИ не определены, вам будет
предложено ввести их интерактивно.
 
Параметры:
 
Подробнее о кластеризации вы можете узнать в описании SQL-команды CLUSTER.
 
Подробнее о переиндексации вы можете узнать в описании SQL-команды REINDEX.
 
Подробнее об очистке вы можете узнать в описании SQL-команды VACUUM.
 
Об ошибках сообщайте по адресу <pgsql-bugs@postgresql.org>.
       --lc-collate=ЛОКАЛЬ      параметр LC_COLLATE для базы данных
       --lc-ctype=ЛОКАЛЬ        параметр LC_CTYPE для базы данных
   %s [ПАРАМЕТР]... БД
   %s [ПАРАМЕТР]... ЯЗЫК [ИМЯ_БД]
   %s [ПАРАМЕТР]... [ИМЯ_БД]
   %s [ПАРАМЕТР]... [ИМЯ_БД] [ОПИСАНИЕ]
   %s [ПАРАМЕТР]... [ИМЯ_РОЛИ]
   --help                          показать эту справку и выйти
   --help                       показать эту справку и выйти
   --help                    показать эту справку и выйти
   --version                       показать версию и выйти
   --version                    показать версию и выйти
   --version                 показать версию и выйти
   -D, --no-createdb         роль без права создания баз данных
   -D, --tablespace=ТАБЛ_ПРОСТР табличное пространство по умолчанию для базы данных
   -E, --encoding=КОДИРОВКА     кодировка базы данных
   -E, --encrypted           зашифровать сохранённый пароль
   -F, --freeze                    заморозить информацию о транзакциях в строках
   -I, --no-inherit          роль не наследует права
   -L, --no-login            роль без права подключения
   -N, --unencrypted         не шифровать сохранённый пароль
   -O, --owner=ВЛАДЕЛЕЦ         пользователь-владелец новой базы данных
   -P, --pwprompt            назначить пароль новой роли
   -R, --no-createrole       роль без права создания ролей
   -S, --no-superuser        роль без полномочий суперпользователя
   -T, --template=ШАБЛОН        исходная база данных для копирования
   -U, --username=ИМЯ           имя пользователя для подключения к серверу
   -U, --username=ИМЯ        имя пользователя для подключения к серверу
   -U, --username=ИМЯ        имя пользователя для выполнения операции
                            (но не имя новой роли)
   -U, --username=ИМЯ        имя пользователя для выполнения операции
                            (но не имя удаляемой роли)
   -W, --password               запросить пароль
   -W, --password            запросить пароль
   -a, --all                       очистить все базы данных
   -a, --all                 кластеризовать все базы
   -a, --all                 переиндексировать все базы данных
   -c, --connection-limit=N  предел подключений для роли
                            (по умолчанию предела нет)
   -d, --createdb            роль с правом создания баз данных
   -d, --dbname=ИМЯ_БД             очистить указанную базу данных
   -d, --dbname=ИМЯ_БД       база данных, из которой будет удалён язык
   -d, --dbname=ИМЯ_БД       имя базы данных для кластеризации
   -d, --dbname=ИМЯ_БД       база данных, куда будет установлен язык
   -d, --dbname=БД           имя базы для переиндексации
   -e, --echo                      отображать команды, отправляемые серверу
   -e, --echo                   отображать команды, отправляемые серверу
   -e, --echo                отображать команды, отправляемые серверу
   -f, --full                      произвести полную очистку
   -h, --host=ИМЯ               имя сервера баз данных или каталог сокетов
   -h, --host=ИМЯ            имя сервера баз данных или каталог сокетов
   -i, --index=ИНДЕКС        пересоздать только указанный индекс
   -i, --inherit             роль наследует права ролей (групп), в которые она
                            включена (по умолчанию)
   -i, --interactive         подтвердить операцию удаления
   -l, --list                показать список установленных языков
   -l, --locale=ЛОКАЛЬ          локаль для базы данных
   -l, --login               роль с правом подключения к серверу (по умолчанию)
   -p, --port=ПОРТ              порт сервера баз данных
   -p, --port=ПОРТ           порт сервера баз данных
   -q, --quiet                     не выводить сообщения
   -q, --quiet               не выводить никакие сообщения
   -r, --createrole          роль с правом создания других ролей
   -s, --superuser           роль с полномочиями суперпользователя
   -s, --system              переиндексировать системные каталоги
   -t, --table='ТАБЛ[(КОЛОНКИ)]'   очистить только указанную таблицу
   -t, --table=ТАБЛИЦА       кластеризовать только указанную таблицу
   -t, --table=ТАБЛИЦА       переиндексировать только указанную таблицу
   -v, --verbose                   выводить исчерпывающие сообщения
   -v, --verbose             выводить исчерпывающие сообщения
   -w, --no-password            не запрашивать пароль
   -w, --no-password         не запрашивать пароль
   -z, --analyze                   обновить метрики оптимизатора
 %s (%s - да/%s - нет)  %s очищает и анализирует базу данных PostgreSQL.

 %s упорядочивает данные всех кластеризованных таблиц в базе данных.

 %s создаёт базу данных PostgreSQL.

 %s создаёт роль пользователя PostgreSQL.

 %s устанавливает поддержку процедурного языка в базу PostgreSQL.

 %s переиндексирует базу данных PostgreSQL.

 %s удаляет базу данных PostgreSQL.

 %s удаляет роль PostgreSQL.

 %s удаляет процедурный язык из базы данных.

 %s: "%s" не является верным названием кодировки
 %s: нельзя  кластеризовать одну указанную таблицу во всех базах
 %s: нельзя кластеризовать все базы и одну конкретную одновременно
 %s: нельзя переиндексировать указанный индекс и системные каталоги одновременно
 %s: нельзя переиндексировать один указанный индекс во всех базах
 %s: нельзя переиндексировать указанную таблицу и системные каталоги одновременно
 %s: нельзя переиндексировать указанную таблицу во всех базах
 %s: нельзя переиндексировать все базы данных и одну конкретную одновременно
 %s: нельзя переиндексировать все базы данных и системные каталоги одновременно
 %s: нельзя очистить одну указанную таблицу во всех базах
 %s: нельзя очистить все базы данных и одну конкретную одновременно
 %s: кластеризация базы "%s"
 %s: кластеризовать базу "%s" не удалось: %s %s: кластеризовать таблицу "%s" в базе "%s" не удалось: %s %s: создать комментарий не удалось (база данных была создана): %s %s: не удалось подключиться к базе %s
 %s: не удалось подключиться к базе %s: %s %s: не удалось узнать имя текущего пользователя: %s
 %s: не удалось получить информацию о текущем пользователе: %s
 %s: создать роль не удалось: %s %s: создать базу данных не удалось: %s %s: ошибка при удалении базы данных: %s %s: поддержка языка "%s" уже имеется в базе "%s"
 %s: поддержка языка "%s" не установлена в базе данных"%s"
 %s: установить поддержку языка не удалось: %s %s: ошибка при удалении поддержки языка: %s %s: отсутствует необходимый аргумент: имя базы данных
 %s: отсутствует необходимый аргумент: название языка
 %s: можно указать только --locale и --lc-collate
 %s: можно указать только --locale или --lc-ctype
 %s: ошибка при выполнении запроса: %s %s: запрос: %s
 %s: переиндексация базы данных "%s"
 %s: переиндексировать базу данных "%s" не удалось: %s %s: переиндексировать индекс "%s" в базе "%s" не удалось: %s %s: переиндексировать системные каталоги не удалось: %s %s: переиндексировать таблицу "%s" в базе "%s" не удалось: %s %s: ошибка при удалении роли "%s": %s %s: функции (%s) языка "%s" ещё используются; язык не удалён
 %s: слишком много аргументов командной строки (первый: "%s")
 %s: очистка базы данных "%s"
 %s: очистить базу данных "%s" не удалось: %s %s: очистить таблицу "%s" в базе "%s" не удалось: %s Вы уверены? (y/n) Сигнал отмены отправлен
 Отправить сигнал отмены не удалось: %s База данных "%s" будет удалена безвозвратно.
 Повторите его:  Введите имя новой роли:  Введите имя удаляемой роли:  Введите пароль для новой роли:  Имя Ошибка при шифровании пароля.
 Пароль:  Пароли не совпадают.
 Пожалуйста, введите "%s" или "%s".
 Процедурные языки Роль "%s" будет удалена безвозвратно.
 Должна ли новая роль иметь полномочия суперпользователя? Новая роль должна иметь право создавать базы данных? Новая роль должна иметь право создавать другие роли? Доверенный? Для дополнительной информации попробуйте "%s --help".
 Использование:
 n нет нехватка памяти
 pg_strdup: попытка сделать копию нулевого указателя (внутренняя ошибка)
 y да 