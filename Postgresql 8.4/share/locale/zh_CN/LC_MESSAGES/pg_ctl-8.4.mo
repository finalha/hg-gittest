Þ    l      |     Ü      0	      1	     R	  &   d	     	     «	  -   Ê	     ø	     
  |   +
     ¨
  a   È
  K   *     v  A     !   Ó  3   õ  ?   )  ?   i  H   ©  D   ò  E   7  ?   }  >   ½  9   ü  B   6  <   y  z   ¶  0   1  F   b  >   ©  8   è  2   !  O   T  7   ¤     Ü     ã     ì  !   }  C     y   ã  C   ]  D   ¡  >   æ  A   %  *   g  /     %   Â  /   è  #        <  3   Z  0     ,   ¿  .   ì  3     -   O  0   }  5   ®  "   ä  $     J   ,     w       3   ª  0   Þ          "  !   A  $   c        -   ©  4   ×  %     $   2  "   W  F   z  F   Á       7     )   T  q   ~  f   ð  %   W  &   }     ¤  d   ¬       &   0  0   W  .     )   ·  )   á  "         .  (   O     x  !        µ     Í     á     ÷               )     9  "   Q     t  j       þ          -     I     e  .        °  $   Ï  |   ô  $   q   e      S   ü      P!  G   p!  "   ¸!  =   Û!  :   "  3   T"  D   "  B   Í"  F   #  2   W#  @   #  5   Ë#  N   $  C   P$  }   $  /   %  C   B%  D   %  2   Ë%  ,   þ%  8   +&  3   d&     &     ¡&     ª&     /'  I   N'  m   '  a   (  W   h(  B   À(  W   )     [)  .   y)  %   ¨)  *   Î)      ù)     *  *   7*  ,   b*  )   *  ,   ¹*  4   æ*  1   +  *   M+  *   x+  )   £+     Í+  E   ë+     1,  %   I,  6   o,  &   ¦,     Í,     ß,  *   ý,      (-     I-  :   g-  .   ¢-     Ñ-     ñ-     .  4   ..  :   c.  #   .  ;   Â.  +   þ.  ]   */  Q   /  "   Ú/  *   ý/     (0  l   70      ¤0  #   Å0  #   é0  )   1     71     T1     q1  !   1     «1     È1     æ1     2     !2     <2     Y2     v2     2     °2     Í2     ê2     
3               5      6         Y                      (      9   .   #          e           '   R   [   W   K   <   ]   f      B   D   &       P   H          -   %              j   
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
 waiting for server to shut down... waiting for server to start... Project-Id-Version: pg_ctl (PostgreSQL 8.4)
Report-Msgid-Bugs-To: pgsql-bugs@postgresql.org
POT-Creation-Date: 2010-10-01 14:52+0000
PO-Revision-Date: 2010-03-30 14:02+0800
Last-Translator: Weibin <ssmei_2000@yahoo.com>
Language-Team: Chinese (Simplified)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Language: zh_CN
 
åè®¸å³é­çä¿¡å·åç§°:
 
æ®ééé¡¹:
 
æ³¨åææ³¨éçéé¡¹:
 
å¯å¨æéå¯çéé¡¹:
 
åæ­¢æéå¯çéé¡¹:
 
è­è«æ¥åè³ <pgsql-bugs@postgresql.org>.
 
å³é­æ¨¡å¼æå¦ä¸å ç§:
   %s kill    ä¿¡å·åç§° è¿ç¨å·
   %s register   [-N æå¡åç§°] [-U ç¨æ·å] [-P å£ä»¤] [-D æ°æ®ç®å½]
              [-w] [-t ç§æ°] [-o "éé¡¹"]
   %s reload  [-D æ°æ®ç®å½] [-s]
   %s restart [-w] [-t ç§æ°] [-D æ°æ®ç®å½] [-s] [-m å³é­æ¨¡å¼]
                [-o "éé¡¹"]
   %s start   [-w]  [-t ç§æ°] [-D æ°æ®ç®å½] [-s] [-l æä»¶å] [-o "éé¡¹"]
   %s status  [-D æ°æ®ç®å½]
   %s stop   [-w]  [-t ç§æ°] [-D æ°æ®ç®å½] [-s] [-m å³é­æ¨¡å¼]
   %s unregister [-N æå¡åç§°]
   --help                 æ¾ç¤ºæ­¤å¸®å©ä¿¡æ¯, ç¶åéåº
   --version              æ¾ç¤ºçæ¬ä¿¡æ¯, ç¶åéåº
   -D, --pgdata æ°æ®ç®å½  æ°æ®å­å¨çä½ç½®
   -N æå¡åç§°     æ³¨åå° PostgreSQL æå¡å¨çæå¡åç§°
   -P å£ä»¤         æ³¨åå° PostgreSQL æå¡å¨å¸æ·çå£ä»¤
   -U ç¨æ·å       æ³¨åå° PostgreSQL æå¡å¨å¸æ·çç¨æ·å
   -W                     ä¸ç¨ç­å¾æä½å®æ
   -c, --core-files       åè®¸postgresè¿ç¨äº§çæ ¸å¿æä»¶
   -c, --core-files       å¨è¿ç§å¹³å°ä¸ä¸å¯ç¨
   -l, --log FILENAME     åå¥ (æè¿½å ) æå¡å¨æ¥å¿å°æä»¶ FILENAME
   -m SHUTDOWN-MODE   å¯ä»¥æ¯ "smart", "fast", æè "immediate"
   -o OPTIONS             ä¼ éç» postmaster çå½ä»¤è¡éé¡¹
                         (PostgreSQL æå¡å¨æ§è¡æä»¶)
   -p PATH-TO-POSTMASTER  æ­£å¸¸æåµä¸å¿è¦
   -s, --silent           åªæå°éè¯¯ä¿¡æ¯, æ²¡æå¶ä»ä¿¡æ¯
   -t SECS                å½ä½¿ç¨-w éé¡¹æ¶éè¦ç­å¾çç§æ°
   -w                     ç­å¾ç´å°æä½å®æ
   fast        ç´æ¥éåº, æ­£ç¡®çå³é­
   immediate   ä¸å®å¨çå³é­éåº; éå¯åæ¢å¤
   smart       ææå®¢æ·ç«¯æ­å¼è¿æ¥åéåº
  å®æ
  å¤±è´¥
 %s æ¯ä¸ä¸ªå¯å¨, åæ­¢, éå¯, éè½½éç½®æä»¶, æ¥å PostgreSQL æå¡å¨ç¶æ,
æèææ PostgreSQL è¿ç¨çå·¥å·

 %s: PID æä»¶ "%s" ä¸å­å¨
 %s: å¶ä»æå¡å¨è¿ç¨å¯è½æ­£å¨è¿è¡; å°è¯å¯å¨æå¡å¨è¿ç¨
 %s: æ æ³ä»¥ root ç¨æ·è¿è¡
è¯·ä»¥æå¡å¨è¿ç¨æå±ç¨æ· (éç¹æç¨æ·) ç»å½ (æä½¿ç¨ "su")

 %s: æ æ³éæ°å è½½æå¡å¨è¿ç¨ï¼æ­£å¨è¿è¡åç¨æ·æ¨¡å¼çæå¡å¨è¿ç¨ (PID: %ld)
 %s: æ æ³éå¯æå¡å¨è¿ç¨; åç¨æ·æ¨¡å¼æå¡å¨è¿ç¨æ­£å¨è¿è¡ (PID: %ld)
 %s: ä¸è½è®¾ç½®æ ¸å¿æä»¶å¤§å°çéå¶;ç£çéé¢ä¸åè®¸
 %s: æ æ³åæ­¢æå¡å¨è¿ç¨; æ­£å¨è¿è¡ åç¨æ·æ¨¡å¼æå¡å¨è¿ç¨(PID: %ld)
 %s: æ æ³æ¾å°æ§è¡æä»¶
 %s: æ æ³æ¾å°postgresç¨åºçæ§è¡æä»¶
 %s: æ æ³æå¼ PID æä»¶ "%s": %s
 %s: æ æ³æå¼æå¡ "%s": éè¯¯ç  %d
 %s: æ æ³æå¼æå¡ç®¡çå¨
 %s: æ æ³è¯»åæä»¶ "%s"
 %s: æ æ³æ³¨åæå¡ "%s": éè¯¯ç  %d
 %s: æ æ³åééè½½ä¿¡å· (PID: %ld): %s
 %s: æ æ³åéä¿¡å· %d (PID: %ld): %s
 %s: æ æ³åéåæ­¢ä¿¡å· (PID: %ld): %s
 %s: æ æ³å¯å¨æå¡å¨è¿ç¨
æ£æ¥æ¥å¿è¾åº.
 %s: æ æ³å¯å¨æå¡å¨è¿ç¨: éåºç ä¸º %d
 %s: æ æ³å¯å¨æå¡ "%s": éè¯¯ç  %d
 %s: æ æ³æ³¨éæå¡ "%s": éè¯¯ç  %d
 %s: PIDæä»¶ "%s" ä¸­å­å¨æ ææ°æ®
 %s: ç¼ºå° kill æ¨¡å¼åæ°
 %s: æ²¡ææå®æ°æ®ç®å½, å¹¶ä¸æ²¡æè®¾ç½® PGDATA ç¯å¢åé
 %s: æ²¡ææå®æä½
 %s:æ²¡ææå¡å¨è¿ç¨æ­£å¨è¿è¡
 %s: åæçè¿ç¨(PID: %ld)å¯è½å·²ç»ä¸å­å¨äº
 %s: éé¡¹æä»¶ "%s" åªè½æä¸è¡
 %s: åå­æº¢åº
 %s: serverè¿ç¨æ²¡æå³é­
 %s: æ­£å¨è¿è¡æå¡å¨è¿ç¨(PID: %ld)
 %s: æå¡ "%s" å·²ç»æ³¨åäº
 %s: æå¡ "%s" æ²¡ææ³¨å
 %s: æ­£å¨è¿è¡åç¨æ·æ¨¡å¼æå¡å¨è¿ç¨ (PID: %ld)
 %s: å½ä»¤è¡åæ°å¤ªå¤ (ç¬¬ä¸ä¸ªæ¯ "%s")
 %s: æ æçæä½æ¨¡å¼ "%s"
 %s: æ æçå³é­æ¨¡å¼ "%s"
 %s: æ æä¿¡å·åç§° "%s"
 (é»è®¤ä¸ºå³é­ç­å¾, ä½ä¸æ¯å¯å¨æéå¯.)

 å¦æçç¥äº -D éé¡¹, å°ä½¿ç¨ PGDATA ç¯å¢åé.
 æå¡å¨è¿ç¨æ¯å¦æ­£å¨è¿è¡?
 è¯·ç»æ­¢åç¨æ·æ¨¡å¼æå¡å¨è¿ç¨ï¼ç¶ååéè¯.
 æå¡å¨è¿ç¨å·²å¯å¨å¹¶ä¸æ¥åè¿æ¥
 %s éè¦ç¨åº "postgres", ä½æ¯å¨åä¸ä¸ªç®å½ "%s" ä¸­æ²¡æ¾å°.

æ£æ¥æ¨çå®è£.
 %s æ¾å°ç¨åº "postgres", ä½æ¯åçæ¬ "%s" ä¸ä¸è´.

æ£æ¥æ¨çå®è£.
 å¨ç­å¾æå¡å¨å¯å¨æ¶è¶æ¶
 è¯ç¨ "%s --help" è·åæ´å¤çä¿¡æ¯.
 ä½¿ç¨æ¹æ³:
 è­¦å: å¨çº¿å¤ä»½æ¨¡å¼å¤äºæ¿æ´»ç¶æ
å³é­å½ä»¤å°ä¸ä¼å®æï¼ç´å°è°ç¨äºpg_stop_backup().
 ç­å¾æå¡å¨è¿ç¨å¯å¨ ...
 å­è¿ç¨å·²éåº, éåºç ä¸º %d å­è¿ç¨å·²éåº, æªç¥ç¶æ %d å­è¿ç¨è¢«ä¾å¤(exception) 0x%X ç»æ­¢ å­è¿ç¨è¢«ä¿¡å· %d ç»æ­¢ å­è¿ç¨è¢«ä¿¡å· %s ç»æ­¢ æ æ³è¿å¥ç®å½ "%s" æªè½æ¾å°ä¸ä¸ª "%s" æ¥æ§è¡ æ æ³ç¡®è®¤å½åç®å½: %s æ æ³è¯»åäºè¿å¶ç  "%s" æ æ³è¯»åç¬¦å·é¾ç» "%s" æ æ³å¯å¨æå¡å¨è¿ç¨
 æ æçäºè¿å¶ç  "%s" æ­£å¨å³é­æå¡å¨è¿ç¨
 æå¡å¨è¿ç¨ååºä¿¡å·
 æå¡å¨è¿ç¨å·²ç»å¯å¨
 æ­£å¨å¯å¨æå¡å¨è¿ç¨
 æå¡å¨è¿ç¨å·²ç»å³é­
 æ­£å¨å¯å¨æå¡å¨è¿ç¨
 ç­å¾æå¡å¨è¿ç¨å³é­ ... ç­å¾æå¡å¨è¿ç¨å¯å¨ ... 