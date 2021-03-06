��    l      |  �   �      0	      1	     R	  &   d	     �	     �	  -   �	     �	     
  |   +
     �
  a   �
  K   *     v  A   �  !   �  3   �  ?   )  ?   i  H   �  D   �  E   7  ?   }  >   �  9   �  B   6  <   y  z   �  0   1  F   b  >   �  8   �  2   !  O   T  7   �     �     �  �   �  !   }  C   �  y   �  C   ]  D   �  >   �  A   %  *   g  /   �  %   �  /   �  #        <  3   Z  0   �  ,   �  .   �  3     -   O  0   }  5   �  "   �  $     J   ,     w     �  3   �  0   �          "  !   A  $   c      �  -   �  4   �  %     $   2  "   W  F   z  F   �       7     )   T  q   ~  f   �  %   W  &   }     �  d   �       &   0  0   W  .   �  )   �  )   �  "         .  (   O     x  !   �     �     �     �     �               )     9  "   Q     t  �  �  $   ]     �  $   �  #   �  *   �  =         F      d   |   �      �   a   !  K   �!     �!  A   �!  !   )"  5   K"  D   �"  K   �"  L   #  Q   _#  S   �#  M   $  C   S$  ?   �$  I   �$  ?   !%  �   a%  4   �%  P   &  I   p&  O   �&  J   
'  p   U'  B   �'     	(  	   (  �   (      �(  c   �(  �   I)  x   �)  n   Y*  `   �*  l   )+  9   �+  :   �+  +   ,  E   7,  )   },  "   �,  J   �,  3   -  0   I-  8   z-  <   �-  8   �-  @   ).  Z   j.  &   �.  3   �.  l    /  #   �/      �/  L   �/  <   0     \0  "   r0  *   �0  (   �0  '   �0  H   1  >   Z1  -   �1  *   �1  &   �1  ]   2  G   w2     �2  L   �2  +   )3  �   U3  t   �3  5   M4  -   �4  
   �4  �   �4  $   >5  .   c5  4   �5  +   �5  '   �5  '   6  (   C6  &   l6  4   �6      �6  '   �6     7     +7      C7     d7     7     �7     �7  #   �7  %   �7  #   8               5      6         Y                      (      9   .   #          e           '   R   [   W   K   <   ]   f      B   D   &       P   H          -   %              j   
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
 waiting for server to shut down... waiting for server to start... Project-Id-Version: pg_ctl (PostgreSQL) 8.4
Report-Msgid-Bugs-To: pgsql-bugs@postgresql.org
POT-Creation-Date: 2013-01-29 13:23+0000
PO-Revision-Date: 2012-12-03 17:32+0100
Last-Translator: Daniele Varrazzo <daniele.varrazzo@gmail.com>
Language-Team: Gruppo traduzioni ITPUG <traduzioni@itpug.org>
Language: it
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Poedit-SourceCharset: utf-8
X-Generator: Poedit 1.5.4
 
Nomi di segnali permessi per kill:
 
Opzioni comuni:
 
Opzioni per register e unregister:
 
Opzioni per l'avvio o il riavvio:
 
Opzioni per lo spegnimento o il riavvio:
 
Puoi segnalare eventuali bug a <pgsql-bugs@postgresql.org>.
 
I modi di spegnimento sono:
   %s kill    SIGNALNAME PID
   %s register   [-N SERVICENAME] [-U USERNAME] [-P PASSWORD] [-D DATADIR]
                    [-w] [-t SECS] [-o "OPZIONI"]
   %s reload  [-D DATADIR] [-s]
   %s restart [-w] [-t SECS] [-D DATADIR] [-s] [-m SHUTDOWN-MODE]
                 [-o "OPTIONS"]
   %s start   [-w] [-t SECS] [-D DATADIR] [-s] [-l FILENAME] [-o "OPTIONS"]
   %s status  [-D DATADIR]
   %s stop    [-W] [-t SECS] [-D DATADIR] [-s] [-m SHUTDOWN-MODE]
   %s unregister [-N SERVICENAME]
   --help                 mostra questo aiuto ed esci
   --version              mostra informazioni sulla versione ed esci
   -D, --pgdata DATADIR   locazione dell'area di archiviazione del database
   -N SERVICENAME  nome del servizio con cui registrare il server PostgreSQL
   -P PASSWORD     password per l'account con cui registrare il server PostgreSQL
   -U USERNAME     nome utente dell'account con cui registrare il server PostgreSQL
   -W                     non aspettare finché l'operazione non è terminata
   -c, --core-files       permette a postgres di produrre core file
   -c, --core-files       non disponibile su questa piattaforma
   -l, --log FILENAME     scrivi (o accoda) il log del server in FILENAME
   -m SHUTDOWN-MODE   può essere "smart", "fast" o "immediate"
   -o OPTIONS             opzioni di riga di comando da passare a postgres
                         (l'eseguibile del server PostgreSQL)
   -p PATH-TO-POSTGRES    normalmente non necessario
   -s, --silent           mostra solo gli errori, non i messaggi di informazione
   -t SECS                secondi da aspettare quando si usa l'opzione -w
   -w                     aspetta finché l'operazione non sia stata completata
   fast        termina direttamente, con una corretta procedura di arresto
   immediate   termina senza un arresto completo: ciò porterà ad un recupero
              dei dati al riavvio
   smart       termina dopo che tutti i client si sono disconnessi
  fatto
  fallito
 %s è un'utility per avviare, fermare, riavviare, ricaricare la configurazione,
riportare lo stato di un server PostgreSQL o inviare segnali a un processo PostgreSQL.

 %s: il file PID "%s" non esiste
 %s: un altro server potrebbe essere in esecuzione; si sta provando ad avviare il server ugualmente
 %s: non può essere eseguito da root
Effettua il login (usando per esempio "su") con l'utente
(non privilegiato) che controllerà il processo server.
 %s: non è possibile eseguire il reload del server; il server è in esecuzione in modalità a singolo utente (PID: %ld)
 %s: non è possibile riavviare il server; il server è in esecuzione in modalità a singolo utente (PID: %ld)
 %s: non è possibile configurare il limite di grandezza dei core file; impedito dall'hard limit
 %s: non è possibile fermare il server; il server è in esecuzione in modalità a singolo utente (PID: %ld)
 %s: il proprio programma eseguibile non è stato trovato
 %s: il programma eseguibile postgres non è stato trovato
 %s: apertura del file PID "%s" fallita: %s
 %s: non è stato possibile aprire il servizio "%s": codice errore %d
 %s: apertura del service manager fallita
 %s: lettura del file "%s" fallita
 %s: non è stato possibile registrare il servizio  "%s": codice errore %d
 %s: invio segnale di reload fallito (PID: %ld): %s
 %s: invio del segnale %d fallito (PID: %ld): %s
 %s: invio del segnale di arresto fallito (PID: %ld): %s
 %s: l'avvio del server è fallito
Esamina il log di output.
 %s: avvio del server fallito: il codice di uscita è %d
 %s: non è possibile avviare il servizio "%s": codice errore %d
 %s: non è stato possibile rimuovere la registrazione del servizio "%s": codice errore %d
 %s: dati non validi nel file PID "%s"
 %s: mancano gli argomenti per la modalità di kill
 %s: nessuna directory del database è stata specificata e la variabile d'ambiente PGDATA non è configurata
 %s: nessuna operazione specificata
 %s: nessun server in esecuzione
 %s: il vecchio processo del server (PID: %ld) sembra non essere più attivo
 %s: il file di opzione "%s" deve avere esattamente una riga
 %s: memoria esaurita
 %s: il server non si è arrestato
 %s: il server è in esecuzione (PID: %ld)
 %s: il servizio "%s" è già registrato
 %s: il servizio "%s" non è registrato
 %s: il server è in esecuzione in modalità a singolo utente (PID: %ld)
 %s: troppi argomenti nella riga di comando (il primo è "%s")
 %s: modalità di operazione sconosciuta "%s"
 %s: modalità di arresto sconosciuta "%s"
 %s: nome del segnale sconosciuto "%s"
 (Il comportamento predefinito è di aspettare lo spegnimento, ma non
l'avvio o il riavvio.)

 Se l'opzione -D è omessa, viene usata la variabile d'ambiente PGDATA.
 Il server è in esecuzione?
 Si prega di terminare il server in modalità singolo utente e di riprovare.
 Il server è avviato e accetta connessioni
 Il programma "postgres" è richiesto da %s ma non è stato trovato
nella stessa directory di "%s".
Verifica la tua installazione.
 Il programma "postgres" è stato trovato in "%s"
ma non è la stessa versione di %s.
Verifica la tua installazione.
 Il tempo di attesa per l'avvio del server è scaduto
 Prova "%s --help" per maggiori informazioni.
 Utilizzo:
 ATTENZIONE: è attiva la modalità di backup online
L'arresto non sarà completato finché non sarà chiamata pg_stop_backup().

 In attesa che il server si avvii...
 processo figlio uscito con codice di uscita %d processo figlio uscito con stato non riconosciuto %d processo figlio terminato da eccezione 0x%X processo figlio terminato da segnale %d processo figlio terminato da segnale %s spostamento nella directory "%s" fallito programma "%s" da eseguire non trovato identificazione della directory corrente fallita: %s lettura del binario "%s" fallita lettura del link simbolico "%s" fallita avvio del server fallito
 binario non valido "%s" il server è in fase di arresto
 segnale inviato al server
 il server è stato avviato
 il server si sta avviando
 il server è stato arrestato
 il server si sta avviando comunque
 in attesa dell'arresto del server.... in attesa che il server si avvii... 