��    l      |  �   �      0	      1	     R	  &   d	     �	     �	  -   �	     �	     
  |   +
     �
  a   �
  K   *     v  A   �  !   �  3   �  ?   )  ?   i  H   �  D   �  E   7  ?   }  >   �  9   �  B   6  <   y  z   �  0   1  F   b  >   �  8   �  2   !  O   T  7   �     �     �  �   �  !   }  C   �  y   �  C   ]  D   �  >   �  A   %  *   g  /   �  %   �  /   �  #        <  3   Z  0   �  ,   �  .   �  3     -   O  0   }  5   �  "   �  $     J   ,     w     �  3   �  0   �          "  !   A  $   c      �  -   �  4   �  %     $   2  "   W  F   z  F   �       7     )   T  q   ~  f   �  %   W  &   }     �  d   �       &   0  0   W  .   �  )   �  )   �  "         .  (   O     x  !   �     �     �     �     �               )     9  "   Q     t  �  �     !     A  5   W  /   �  *   �  5   �        $   9   �   ^   &   �   d   !  e   p!  !   �!  E   �!  !   >"  8   `"  8   �"  >   �"  y   #  �   �#  �   $  >   �$  J   �$  =   !%  o   _%  @   �%  �   &  6   �&  s   �&  x   I'  8   �'  F   �'  �   B(  H   �(  
   )  
   )  �   #)  +   �)  d   *  �   }*  i   :+  h   �+  _   ,  g   m,  2   �,  .   -  5   7-  =   m-  3   �-  '   �-  A   .  C   I.  6   �.  ;   �.  D    /  ?   E/  >   �/  ?   �/  5   0  *   :0  e   e0     �0  (   �0  >   1  F   S1     �1  $   �1  5   �1  +   2  ,   72  F   d2  E   �2  )   �2  %   3     A3  R   a3  K   �3  )    4  =   *4  *   h4  �   �4  t   5  2   �5  0   �5     �5  |   �5  &   |6  4   �6  8   �6  4   7  0   F7  0   w7  '   �7  '   �7  0   �7  !   )8  )   K8     u8     �8     �8     �8     �8     �8     9  !   %9  #   G9  %   k9               5      6         Y                      (      9   .   #          e           '   R   [   W   K   <   ]   f      B   D   &       P   H          -   %              j   
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
POT-Creation-Date: 2009-04-16 03:18+0000
PO-Revision-Date: 2009-04-16 16:19+0200
Last-Translator: St�phane Schildknecht <stephane.schildknecht@dalibo.com>
Language-Team: PostgreSQLfr <pgsql-fr-generale@postgresql.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
 
Signaux autoris�s pour kill :
 
Options g�n�rales :
 
Options d'enregistrement ou de d�s-enregistrement :
 
Options pour le d�marrage ou le red�marrage :
 
Options pour l'arr�t ou le red�marrage :
 
Rapporter les bogues � <pgsql-bugs@postgresql.org>.
 
Les modes d'arr�t sont :
   %s kill       SIGNAL ID_PROCESSUS
   %s register   [-N NOM_SERVICE] [-U NOM_UTILISATEUR] [-P MOTDEPASSE]
                [-D R�P_DONN�ES] [-w] [-t SECS] [-o "OPTIONS"]
   %s reload     [-D R�P_DONN�ES] [-s]
   %s restart    [-w] [-t SECS] [-D R�P_DONN�ES] [-s] [-m MODE_ARRET]
                [-o "OPTIONS"]
   %s start      [-w] [-t SECS] [-D R�P_DONN�ES] [-s] [-l NOM_FICHIER]
                [-o "OPTIONS"]
   %s status     [-D R�P_DONN�ES]
   %s stop       [-W] [-t SECS] [-D R�P_DONN�ES] [-s] [-m MODE_ARRET]
   %s unregister [-N NOM_SERVICE]
   --help                   affiche cette aide et quitte
   --version                affiche la version et quitte
   -D, --pgdata R�P_DONN�ES emplacement de stockage du cluster
   -N NOM_SERVICE           nom du service utilis� pour l'enregistrement du
                           serveur PostgreSQL
   -P MOT_DE_PASSE          mot de passe du compte utilis� pour
                           l'enregistrement du serveur PostgreSQL
   -U NOM_UTILISATEUR       nom de l'utilisateur du compte utilis� pour
                           l'enregistrement du serveur PostgreSQL
   -W                       n'attend pas la fin de l'op�ration
   -c, --core-files         autorise postgres � produire des fichiers core
   -c, --core-files         non applicable � cette plateforme
   -l, --log NOM_FICHIER    �crit (ou ajoute) le journal du serveur dans
                           NOM_FICHIER
   -m MODE_ARRET            � smart �, � fast � ou � immediate �
   -o OPTIONS               options de la ligne de commande � passer �
                           postgres (ex�cutable du serveur PostgreSQL)
   -p CHEMIN_POSTGRES       normalement pas n�cessaire
   -s, --silent             affiche uniquement les erreurs, aucun message
                           d'informations
   -t SECS                  dur�e en secondes � attendre lors de
                           l'utilisation de l'option -w
   -w                       attend la fin de l'op�ration
   fast                     quitte directement, et arr�te correctement
   immediate                quitte sans arr�t complet ; entra�ne une
                           restauration au d�marrage suivant
   smart                    quitte apr�s d�connexion de tous les clients
  effectu�
  a �chou�
 %s est un outil qui permet de d�marrer, arr�ter, red�marrer, recharger les
les fichiers de configuration, rapporter le statut d'un serveur PostgreSQL
ou d'envoyer un signal � un processus PostgreSQL

 %s : le fichier de PID � %s � n'existe pas
 %s : un autre serveur semble en cours d'ex�cution ; le d�marrage du serveur
va toutefois �tre tent�
 %s : ne peut pas �tre ex�cut� en tant qu'utilisateur root
Connectez-vous (par exemple en utilisant � su �) sous l'utilisateur (non
 privil�gi�) qui sera propri�taire du processus serveur.
 %s : ne peut pas recharger le serveur ; le serveur mono-utilisateur est en
cours d'ex�cution (PID : %ld)
 %s : ne peut pas relancer le serveur ; le serveur mono-utilisateur est en
cours d'ex�cution (PID : %ld)
 %s : n'a pas pu initialiser la taille des fichiers core, ceci est interdit
par une limite dure
 %s : ne peut pas arr�ter le serveur ; le serveur mono-utilisateur est en
cours d'ex�cution (PID : %ld)
 %s : n'a pas pu trouver l'ex�cutable du programme
 %s : n'a pas pu trouver l'ex�cutable postgres
 %s : n'a pas pu ouvrir le fichier de PID � %s � : %s
 %s :  n'a pas pu ouvrir le service � %s � : code d'erreur %d
 %s : n'a pas pu ouvrir le gestionnaire de services
 %s : n'a pas pu lire le fichier � %s �
 %s : n'a pas pu enregistrer le service � %s � : code d'erreur %d
 %s : n'a pas pu envoyer le signal de rechargement (PID : %ld) : %s
 %s : n'a pas pu envoyer le signal %d (PID : %ld) : %s
 %s : n'a pas pu envoyer le signal d'arr�t (PID : %ld) : %s
 %s : n'a pas pu d�marrer le serveur
Examinez le journal applicatif.
 %s : n'a pas pu d�marrer le serveur : le code de sortie est %d
 %s : n'a pas pu d�marrer le service � %s � : code d'erreur %d
 %s : n'a pas pu supprimer le service � %s � : code d'erreur %d
 %s : donn�es invalides dans le fichier de PID � %s �
 %s : arguments manquant pour le mode kill
 %s : aucun r�pertoire de bases de donn�es indiqu� et variable
d'environnement PGDATA non initialis�e
 %s : aucune op�ration indiqu�e
 %s : aucun serveur en cours d'ex�cution
 %s : l'ancien processus serveur (PID : %ld) semble �tre parti
 %s : le fichier d'options � %s � ne doit comporter qu'une seule ligne
 %s : m�moire �puis�e
 %s : le serveur ne s'est pas arr�t�
 %s : le serveur est en cours d'ex�cution (PID : %ld)
 %s : le service � %s � est d�j� enregistr�
 %s : le service � %s � n'est pas enregistr�
 %s : le serveur mono-utilisateur est en cours d'ex�cution (PID : %ld)
 %s : trop d'arguments en ligne de commande (le premier �tant � %s �)
 %s : mode d'op�ration � %s � non reconnu
 %s : mode d'arr�t non reconnu � %s �
 %s : signal non reconnu � %s �
 (Le comportement par d�faut attend l'arr�t, pas le d�marrage ou le
red�marrage.)

 Si l'option -D est omise, la variable d'environnement PGDATA est utilis�e.
 Le serveur est-il en cours d'ex�cution ?
 Merci d'arr�ter le serveur mono-utilisateur et de r�essayer.
 Serveur lanc� et acceptant les connexions
 %s a besoin du programme � postgres �, mais celui-ci n'a pas �t� trouv�
dans le m�me r�pertoire que � %s �.
V�rifiez votre installation.
 Le programme � postgres �, trouv� par � %s �, n'est pas de la m�me version
que � %s �.
V�rifiez votre installation.
 D�passement du d�lai pour le d�marrage du serveur
 Essayer � %s --help � pour plus d'informations.
 Usage :
 ATTENTION : le mode de sauvegarde en ligne est activ�.
L'arr�t ne surviendra qu'au moment o� pg_stop_backup() sera appel�.

 En attente du d�marrage du serveur...
 le processus fils a quitt� avec le code de sortie %d le processus fils a quitt� avec un statut %d non reconnu le processus fils a �t� termin� par l'exception 0x%X le processus fils a �t� termin� par le signal %d le processus fils a �t� termin� par le signal %s n'a pas pu acc�der au r�pertoire � %s � n'a pas pu trouver un � %s � � ex�cuter n'a pas pu identifier le r�pertoire courant : %s n'a pas pu lire le binaire � %s � n'a pas pu lire le lien symbolique � %s � n'a pas pu d�marrer le serveur
 binaire � %s � invalide serveur en cours d'arr�t
 envoi d'un signal au serveur
 serveur d�marr�
 serveur en cours de d�marrage
 serveur arr�t�
 lancement du serveur malgr� tout
 en attente de l'arr�t du serveur... en attente du d�marrage du serveur... 