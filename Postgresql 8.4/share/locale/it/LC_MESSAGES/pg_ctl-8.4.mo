��    l      |  �   �      0	      1	     R	  &   d	     �	     �	  -   �	     �	     
  |   +
     �
  a   �
  K   *     v  A   �  !   �  3   �  ?   )  ?   i  H   �  D   �  E   7  ?   }  >   �  9   �  B   6  <   y  z   �  0   1  F   b  >   �  8   �  2   !  O   T  7   �     �     �  �   �  !   }  C   �  y   �  C   ]  D   �  >   �  A   %  *   g  /   �  %   �  /   �  #        <  3   Z  0   �  ,   �  .   �  3     -   O  0   }  5   �  "   �  $     J   ,     w     �  3   �  0   �          "  !   A  $   c      �  -   �  4   �  %     $   2  "   W  F   z  F   �       7     )   T  q   ~  f   �  %   W  &   }     �  d   �       &   0  0   W  .   �  )   �  )   �  "         .  (   O     x  !   �     �     �     �     �               )     9  "   Q     t  �  �  $   _     �  $   �  $   �  +   �  0         =      [   |   x      �   a   !  K   w!     �!  A   �!  !    "  2   B"  I   u"  M   �"  Q   #  V   _#  V   �#  M   $  D   [$  ?   �$  L   �$  A   -%  �   o%  4   �%  P   (&  I   y&  N   �&  I   '  c   \'  C   �'     (     (  �   (      �(  c   �(  �   Y)  x   �)  o   l*  a   �*  l   >+  8   �+  >   �+  1   #,  ?   U,  /   �,  *   �,  D   �,  A   5-  :   w-  ?   �-  C   �-  B   6.  @   y.  E   �.  &    /  /   '/  l   W/  #   �/  #   �/  L   0  A   Y0     �0  #   �0  *   �0  (    1  (   )1  H   R1  >   �1  -   �1  3   2  +   <2  c   h2  G   �2     3  K   13  +   }3  |   �3  p   &4  5   �4  /   �4  
   �4  ~   5  '   �5  /   �5  >   �5  9   6  4   X6  +   �6  &   �6  '   �6  2   7  #   ;7  *   _7  #   �7     �7     �7     �7     �7     8     ,8  #   J8  '   n8  #   �8               5      6         Y                      (      9   .   #          e           '   R   [   W   K   <   ]   f      B   D   &       P   H          -   %              j   
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
POT-Creation-Date: 2009-07-11 05:56+0000
PO-Revision-Date: 2009-07-23 23:17:10+0200
Last-Translator: Emanuele Zamprogno <ez@medicinaopen.info>
Language-Team: Gruppo traduzioni ITPUG <traduzioni@itpug.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Poedit-Language: Italian
X-Poedit-Country: ITALY
X-Poedit-SourceCharset: utf-8
 
Nomi permessi ai segnali per kill:
 
Opzioni comuni:
 
Opzioni per register e unregister:
 
Opzioni per l'avvio od il riavvio:
 
Opzioni per lo spegnimento od il riavvio:
 
Segnalare bachi a <pgsql-bugs@postgresql.org>.
 
I modi di spegnimento sono:
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
   --help                 mostra l'help e poi esci
   --version              mostra le informazioni della versione, poi esci
   -D, --pgdata DATADIR   locazione dell' area di archiviazione del database 
   -N SERVICENAME  nome del servizio con cui ci si registra sul server PostgreSQL
   -P PASSWORD     password per l'account con cui ci si registra sul server PostgreSQL
   -U USERNAME     user name dell'account con cui ci si registra sul server PostgreSQL
   -W                     non aspettare finchè l'operazione non è terminata
   -c, --core-files       permette a postgres di produrre core files
   -c, --core-files       non applicabile su questa piattaforma
   -l, --log FILENAME     scrivi (o aggiungi) il log del server nel FILENAME
   -m SHUTDOWN-MODE   può essere "smart", "fast", o  "immediate"
   -o OPTIONS             opzioni da linea di comando da passare a postgres
                         (server PostgreSQL eseguibile)
   -p PATH-TO-POSTGRES    normalmente non necessario
   -s, --silent           mostra solo gli errori, non i messaggi di informazione
   -t SECS                secondi da aspettare quando si usa l'opzione -w
   -w                     aspetta finchè l'opeazione non sia stata completata
   fast        spegni direttamente, con una corretta procedura di arresto
   immediate   chiudere senza terminare il server: ciò porterà ad un recupero dei dati al riavvio
   smart       chiudere dopo che tutti i clients si sono disconessi
  fatto
 fallito
 %s è un proramma di utilità per avviare, spegnere, riavviare, ricaricare file di configurazione,
dare un rapporto sullo stato di PostgreSQL server, o segnalare un processo di PostgreSQL.

 %s: il PID file "%s" non esiste
 %s: un altro server potrebbe essere in esecuzione; si sta provando ad avviare il server ugualmente
 %s: non puo' essere eseguito da root
Effettuate il log in (usando per esempio "su") con l'utente
(non privilegiato) che controllera' il processo server.
 %s: non è possibile eseguire il reload del server; il server è in esecuzione in modalità a singolo utente (PID: %ld)
 %s: non è possibile riavviare il server; il server è in esecuzione in modalità a singlolo utente (PID: %ld)
 %s: non è possibile configurare il limite di grandezza del core file; impedito dall' hard limit
 %s: non è possibile fermare il server; il server è in esecuzione in modalità a singolo utente (PID: %ld)
 %s: non si sta trovando il proprio programma eseguibile
 %s: non è possibile trovare il programma eseguibile postgres
 %s: non è possibile aprire il PID file "%s": %s
 %s: non è possibile aprire il servizio "%s": codice errore %d
 %s: non è possibile aprire il service manager
 %s: non è possibile leggere il file "%s"
 %s: non è possibile registrare il servizio  "%s": codice errore %d
 %s: non è  possibile mandare il segnale di reload(PID: %ld): %s
 %s: non è possibile mandare il segnale %d (PID: %ld): %s
 %s: non è possibile mandare il segnale di stop (PID: %ld): %s
 %s: non è possibile avviareil serverr
esaminare il log di output.
 %s: non è possibile avviare il server: il segnale d'uscita è %d
 %s: non è possibile avviare il servizio "%s": codice errore %d
 %s: non è possibile deregistrare il servizio "%s": codice errore %d
 %s: dati non validi nel PID file "%s"
 %s: mancano argomenti per la modalità di kill
 %s: nessuna directory del database è stata specificata e la variabile d'ambiente PGDATA non è configurata
 %s: nessuna operazione specificata
 %s: il server non è in esecuzione
 %s: il vecchio processo del server (PID: %ld) sembra non essere più attivo
 %s: il file opzionale file "%s" deve avere esattamente una linea
 %s: memoria esaurita
 %s: il server non si sta spegnendo
 %s: il server è in esecuzione (PID: %ld)
 %s: il servizio "%s" è già registrato
 %s: il servizio "%s" non è  registrato
 %s: il server è in esecuzione in modalità a singolo utente (PID: %ld)
 %s: troppi parametri dalla riga di comando (il primo è "%s")
 %s: modalità di operazione sconosciuta "%s"
 %s: modalità di spegnimento non riconosciuta "%s"
 %s: nome del segnale non riconosciuto "%s"
 (Il comportameeto di default è di aspettare lo spegnimento, ma non nel caso di avvio o riavvio.)

 se l'opzione -D è omessa, la variabile d'ambiente PGDATA viene usata.
 il server è in esecuzione?
 Si prega di terminare il server in modalità singolo utente e di riprovare
 Il server è avviato e accetta connessioni
 Il programma "postgres" e' richiesto da %s ma non e' stato trovato
nella stessa directory "%s".
Verificate l'installazione.
 Il programma "postgres" e' stato trovato da "%s" ma non ha
la stessa versione "%s".
Verificate l'installazione.
 il tempo di attesa per l'avvio del server è scaduto
 Prova "%s --help" per avere più informazioni.
 Utilizzo:
 ATTENZIONE: è attivo l'online backup mode 
Lo spegnimento non sarà completato finchè non sarà chiamata pg_stop_backup().

 Attendere il server si sta avviando...
 il processo figlio e' uscito con l'exit code %d il processo figlio e' uscito con uno stato non riconosciuto %d il processo figlio e' stato terminato dall'eccezione 0x%X il processo figlio e' stato terminato dal segnale %d il processo figlio terminato dal segnale %s impossibile cambiare directory in "%s" impossibile trovare un "%s" da eseguire impossibile identificare la directory corrente: %s impossibile leggere il binario "%s" impossibile leggere il link simbolico "%s" non è possibile avviare il server
 binario non valido "%s" il server è in spegnimento
 il server è segnalato
 il server è avviato
 il server si sta avviando
 il server è stato terminato
 il server si sta avviando comunque
 attendere lo spegnimento del server.... attendere che il server si avvii... 