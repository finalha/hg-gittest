��    l      |  �   �      0	      1	     R	  &   d	     �	     �	  -   �	     �	     
  |   +
     �
  a   �
  K   *     v  A   �  !   �  3   �  ?   )  ?   i  H   �  D   �  E   7  ?   }  >   �  9   �  B   6  <   y  z   �  0   1  F   b  >   �  8   �  2   !  O   T  7   �     �     �  �   �  !   }  C   �  y   �  C   ]  D   �  >   �  A   %  *   g  /   �  %   �  /   �  #        <  3   Z  0   �  ,   �  .   �  3     -   O  0   }  5   �  "   �  $     J   ,     w     �  3   �  0   �          "  !   A  $   c      �  -   �  4   �  %     $   2  "   W  F   z  F   �       7     )   T  q   ~  f   �  %   W  &   }     �  d   �       &   0  0   W  .   �  )   �  )   �  "         .  (   O     x  !   �     �     �     �     �               )     9  "   Q     t  q  �  C          I   G   j   >   �   B   �   W   4!  "   �!     �!  �   �!  3   �"  �   �"  �   M#  .   �#  g   $  )   k$  N   �$  E   �$  `   *%  g   �%  y   �%  v   m&  O   �&  \   4'  Q   �'  {   �'  ^   _(  �   �(  C   })  |   �)  p   >*  J   �*  L   �*  �   G+  h   ,     t,     �,  F  �,  0   �-  �   
.    �.  �   �/  �   10  �   �0  {   B1  L   �1  L   2  =   X2  Q   �2  C   �2  9   ,3  c   f3  `   �3  J   +4  Z   v4  n   �4  U   @5  U   �5  S   �5  9   @6  G   z6  �   �6  '   J7  '   r7  ^   �7  c   �7  "   ]8  5   �8  -   �8  >   �8  <   #9  T   `9  h   �9  >   :  >   ]:  <   �:  �   �:  t   b;  "   �;  X   �;  I   S<  �   �<  �   G=  M   �=  [   I>     �>  �   �>  2   t?  V   �?  l   �?  J   k@  G   �@  G   �@  9   FA  C   �A  J   �A  K   B  S   [B  4   �B  5   �B  ,   C  /   GC     wC  $   �C  "   �C  B   �C  D   D  1   dD               5      6         Y                      (      9   .   #          e           '   R   [   W   K   <   ]   f      B   D   &       P   H          -   %              j   
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
POT-Creation-Date: 2012-07-10 22:45+0000
PO-Revision-Date: 2012-04-02 22:12+0400
Last-Translator: Alexander Lakhin <exclusion@gmail.com>
Language-Team: Russian <pgtranslation-translators@pgfoundry.org>
Language: ru
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Poedit-Language: Russian
X-Poedit-Country: RUSSIAN FEDERATION
X-Poedit-SourceCharset: utf-8
Plural-Forms: nplurals=3; plural=(n%10==1 && n%100!=11 ? 0 : n%10>=2 && n%10<=4 && (n%100<10 || n%100>=20) ? 1 : 2);
X-Generator: Lokalize 1.4
 
Разрешённые сигналы для команды kill:
 
Общие параметры:
 
Параметры для регистрации и удаления:
 
Параметры запуска и перезапуска:
 
Параметры остановки и перезапуска:
 
Об ошибках сообщайте по адресу <pgsql-bugs@postgresql.org>.
 
Режимы остановки:
   %s kill    СИГНАЛ PID
   %s register   [-N ИМЯ-СЛУЖБЫ] [-U ПОЛЬЗОВАТЕЛЬ] [-P ПАРОЛЬ]
                  [-D КАТАЛОГ-ДАННЫХ] [-w] [-t СЕК] [-o "ПАРАМЕТРЫ"]
   %s reload  [-D КАТАЛОГ-ДАННЫХ] [-s]
   %s restart [-w] [-t СЕК] [-D КАТАЛОГ-ДАННЫХ] [-s] [-m РЕЖИМ-ОСТАНОВКИ]
                 [-o "ПАРАМЕТРЫ"]
   %s start   [-w] [-t СЕК] [-D КАТАЛОГ-ДАННЫХ] [-s] [-l ИМЯ-ФАЙЛА]
                 [-o "ПАРАМЕТРЫ"]
   %s status  [-D КАТАЛОГ-ДАННЫХ]
   %s stop    [-W] [-t СЕК] [-D КАТАЛОГ-ДАННЫХ] [-s] [-m РЕЖИМ-ОСТАНОВКИ]
   %s unregister [-N ИМЯ-СЛУЖБЫ]
   --help                 показать эту справку и выйти
   --version              показать версию и выйти
   -D, --pgdata КАТАЛОГ   расположение хранилища баз данных
   -N ИМЯ-СЛУЖБЫ   имя службы для регистрации сервера PostgreSQL
   -P ПАРОЛЬ       пароль учётной записи для регистрации сервера PostgreSQL
   -U ПОЛЬЗОВАТЕЛЬ имя пользователя для регистрации сервера PostgreSQL
   -W                     не ждать завершения операции
   -c, --core-files       указать postgres создавать дампы памяти
   -c, --core-files       неприменимо на этой платформе
   -l, --log ФАЙЛ         записывать (или добавлять) протокол сервера в ФАЙЛ.
   -m РЕЖИМ-ОСТАНОВКИ     может быть "smart", "fast" или "immediate"
   -o ПАРАМЕТРЫ           параметры командной строки для postgres
                         (исполняемого файла сервера PostgreSQL)
   -p ПУТЬ-К-POSTGRES     обычно не требуется
   -s, --silent           выводить только ошибки, без информационных сообщений
   -t СЕК                 время ожидания при использовании параметра -w
   -w                     ждать завершения операции
   fast        закончить сразу, в штатном режиме
   immediate   закончить немедленно, в экстренном режиме; влечёт за собой
              восстановление при перезапуске
   smart       закончить работу после отключения всех клиентов
  готово
  ошибка
 %s - утилита, позволяющая запускать, останавливать, перезапускать сервер
PostgreSQL, узнать его состояние, перезагрузить конфигурационные файлы
или отправить сигналы процессу PostgreSQL.

 %s: файл PID "%s" не существует
 %s: возможно, уже работает другой сервер, всё же пробуем запустить этот сервер
 Запускать %s от имени root нельзя.
Пожалуйста, переключитесь на обычного пользователя (например,
используя "su"), который будет запускать серверный процесс.
 %s: перезагрузить сервер с PID %ld нельзя - он запущен в монопольном режиме
 %s: перезапустить сервер с PID %ld нельзя - он запущен в монопольном режиме
 %s: не удалось ограничить размер дампа памяти; запрещено жёстким ограничением
 %s: остановить сервер с PID %ld нельзя - он запущен в монопольном режиме
 %s: не удалось найти свой исполняемый файл
 %s: не удалось найти исполняемый файл postgres
 %s: не удалось открыть файл PID "%s": %s
 %s: не удалось открыть службу "%s": код ошибки %d
 %s: не удалось открыть менеджер служб
 %s: не удалось прочитать файл "%s"
 %s: не удалось зарегистрировать службу "%s": код ошибки %d
 %s: не удалось отправить сигнал перезагрузки (PID: %ld): %s
 %s: не удалось отправить сигнал %d (PID: %ld): %s
 %s: не удалось отправить сигнал остановки (PID: %ld): %s
 %s: не удалось запустить сервер
Изучите протокол выполнения.
 %s: не удалось запустить сервер, код возврата: %d
 %s: не удалось запустить службу "%s": код ошибки %d
 %s: ошибка при удалении службы "%s": код ошибки %d
 %s: неверные данные в файле PID "%s"
 %s: отсутствуют аргументы для режима kill
 %s: каталог баз данных не указан и переменная окружения PGDATA не установлена
 %s: команда не указана
 %s: сервер не работает
 %s: похоже, что старый серверный процесс (PID: %ld) исчез
 %s: в файле параметров "%s" должна быть ровно одна строка
 %s: нехватка памяти
 %s: сервер не останавливается
 %s: сервер работает (PID: %ld)
 %s: служба "%s" уже зарегистрирована
 %s: служба "%s" не зарегистрирована
 %s: сервер работает в монопольном режиме (PID: %ld)
 %s: слишком много аргументов командной строки (первый: "%s")
 %s: нераспознанный режим работы "%s"
 %s: неизвестный режим остановки "%s"
 %s: нераспознанное имя сигнала "%s"
 (По умолчанию ожидание имеет место при остановке, но не при (пере)запуске.)

 Если параметр -D опущен, используется переменная окружения PGDATA.
 Запущен ли сервер?
 Пожалуйста, остановите его и повторите попытку.
 Сервер запущен и принимает подключения
 Программа "postgres" нужна для %s, но она не найдена
в каталоге "%s".
Проверьте вашу установку PostgreSQL.
 Программа "postgres" найдена в "%s",
но её версия отличается от версии %s.
Проверьте вашу установку PostgreSQL.
 Превышено время ожидания запуска сервера
 Для дополнительной информации попробуйте "%s --help".
 Использование:
 ВНИМАНИЕ: активен режим копирования "на ходу"
Выключение произойдёт только при вызове pg_stop_backup().

 Ожидание запуска сервера...
 дочерний процесс завершился с кодом возврата %d дочерний процесс завершился с нераспознанным состоянием %d дочерний процесс прерван исключением 0x%X дочерний процесс завершён по сигналу %d дочерний процесс завершён по сигналу %s не удалось перейти в каталог "%s" не удалось найти запускаемый файл "%s" не удалось определить текущий каталог: %s не удалось прочитать исполняемый файл "%s" не удалось прочитать символическую ссылку "%s" не удалось запустить сервер
 неверный исполняемый файл "%s" сервер останавливается
 сигнал отправлен серверу
 сервер запущен
 сервер запускается
 сервер остановлен
 сервер запускается, несмотря на это
 ожидание завершения работы сервера... ожидание запуска сервера... 