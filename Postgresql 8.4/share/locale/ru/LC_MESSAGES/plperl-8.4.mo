��          �   %   �      0     1  #   L     p  I   s  '   �  '   �  *     W   8  .   �  B   �  )     !   ,  J   N  '   �     �  E   �  P     >   f  0   �     �     �  !   
  !   ,    N  %   b  +   �     �  �   �  C   s	  E   �	  M   �	  �   K
  }   �
  �   k  ?   �  ,   >  �   k  U   �     J  v   h  �   �  �   �  f     '   s  #   �  J   �  ;   
                                                
                                                                       	        $_TD->{new} does not exist $_TD->{new} is not a hash reference %s If true, trusted and untrusted Perl code will be compiled in strict mode. PL/Perl functions cannot accept type %s PL/Perl functions cannot return type %s Perl hash contains nonexistent column "%s" SETOF-composite-returning PL/Perl function must call return_next with reference to hash cannot use return_next in a non-SETOF function composite-returning PL/Perl function must return reference to hash creation of Perl function "%s" failed: %s error from Perl function "%s": %s function returning record called in context that cannot accept type record ignoring modified row in DELETE trigger out of memory result of PL/Perl trigger function must be undef, "SKIP", or "MODIFY" set-returning PL/Perl function must return reference to array or use return_next set-valued function called in context that cannot accept a set trigger functions can only be called as triggers while executing PLC_TRUSTED while executing utf8fix while parsing Perl initialization while running Perl initialization Project-Id-Version: PostgreSQL 8.4
Report-Msgid-Bugs-To: pgsql-bugs@postgresql.org
POT-Creation-Date: 2012-07-10 22:40+0000
PO-Revision-Date: 2012-04-02 22:12+0400
Last-Translator: Alexander Lakhin <exclusion@gmail.com>
Language-Team: Russian <pgtranslation-translators@pgfoundry.org>
Language: ru
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Plural-Forms: nplurals=3; plural=(n%10==1 && n%100!=11 ? 0 : n%10>=2 && n%10<=4 && (n%100<10 || n%100>=20) ? 1 : 2);
X-Generator: Lokalize 1.4
 $_TD->{new} не существует $_TD->{new} - не ссылка на хэш %s Если этот параметр равен true, доверенный и не доверенный код Perl будет компилироваться в строгом режиме. функции PL/Perl не могут принимать тип %s функции PL/Perl не могут возвращать тип %s Perl-хэш содержит несуществующую колонку "%s" функция PL/Perl, возвращающая составное множество, должна вызывать return_next со ссылкой на хэш return_next можно использовать только в функциях, возвращающих множества функция PL/Perl, возвращающая составное множество, должна возвращать ссылку на хэш создать Perl-функцию "%s" не удалось: %s ошибка в Perl-функции "%s": %s функция, возвращающая запись, вызвана в контексте, не допускающем этот тип в триггере DELETE изменённая строка игнорируется нехватка памяти результатом триггерной функции PL/Perl должен быть undef, "SKIP" или "MODIFY" функция PL/Perl, возвращающая множество, должна возвращать ссылку на массив или вызывать return_next функция, возвращающая множество, вызвана в контексте, где ему нет места триггерные функции могут вызываться только в триггерах при выполнении PLC_TRUSTED при выполнении utf8fix при разборе параметров инициализации Perl при выполнении инициализации Perl 