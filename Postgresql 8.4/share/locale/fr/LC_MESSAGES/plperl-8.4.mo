��          �   %   �      0     1  #   L     p  I   s  '   �  '   �  *     W   8  .   �  B   �  )     !   ,  J   N  '   �     �  E   �  P     >   f  0   �     �     �  !   
  !   ,  |  N     �  .   �       Q     8   h  8   �  6   �  l   	  <   ~	  \   �	  4   
  '   M
  b   u
  /   �
       R     k   k  \   �  F   4  "   {     �  -   �  /   �                                                
                                                                       	        $_TD->{new} does not exist $_TD->{new} is not a hash reference %s If true, trusted and untrusted Perl code will be compiled in strict mode. PL/Perl functions cannot accept type %s PL/Perl functions cannot return type %s Perl hash contains nonexistent column "%s" SETOF-composite-returning PL/Perl function must call return_next with reference to hash cannot use return_next in a non-SETOF function composite-returning PL/Perl function must return reference to hash creation of Perl function "%s" failed: %s error from Perl function "%s": %s function returning record called in context that cannot accept type record ignoring modified row in DELETE trigger out of memory result of PL/Perl trigger function must be undef, "SKIP", or "MODIFY" set-returning PL/Perl function must return reference to array or use return_next set-valued function called in context that cannot accept a set trigger functions can only be called as triggers while executing PLC_TRUSTED while executing utf8fix while parsing Perl initialization while running Perl initialization Project-Id-Version: PostgreSQL 8.4
Report-Msgid-Bugs-To: pgsql-bugs@postgresql.org
POT-Creation-Date: 2010-12-11 09:02+0000
PO-Revision-Date: 2010-12-11 10:43+0100
Last-Translator: Guillaume Lelarge <guillaume@lelarge.info>
Language-Team: French <guillaume@lelarge.info>
Language: fr
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
 $_TD->{new} n'existe pas $_TD->{new} n'est pas une r�f�rence de hachage %s Si true, le code Perl de confiance et sans confiance sera compil� en mode
strict. Les fonctions PL/perl ne peuvent pas accepter le type %s Les fonctions PL/perl ne peuvent pas renvoyer le type %s Le hachage Perl contient la colonne � %s � inexistante une fonction PL/perl renvoyant des lignes composites doit appeler
return_next avec la r�f�rence � un hachage ne peut pas utiliser return_next dans une fonction non SETOF la fonction PL/perl renvoyant des valeurs composites doit renvoyer la
r�f�rence � un hachage �chec de la cr�ation de la fonction Perl � %s � : %s �chec dans la fonction Perl � %s � : %s fonction renvoyant le type record appel�e dans un contexte qui ne peut pas
accepter le type record ignore la ligne modifi�e dans le trigger DELETE m�moire �puis�e le r�sultat de la fonction trigger PL/perl doit �tre undef, � SKIP � ou
� MODIFY � la fonction PL/perl renvoyant des ensembles doit renvoyer la r�f�rence �
un tableau ou utiliser return_next fonction renvoyant un ensemble appel�e dans un contexte qui ne peut pas
accepter un ensemble les fonctions trigger peuvent seulement �tre appel�es par des triggers lors de l'ex�cution de PLC_TRUSTED lors de l'ex�cution d'utf8fix lors de l'analyse de l'initialisation de Perl lors de l'ex�cution de l'initialisation de Perl 