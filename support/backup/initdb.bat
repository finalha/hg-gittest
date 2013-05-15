runas /user:postgres "%1 -D %2 -A md5 -E EUC_CN --locale=C --encoding=SQL_ASCII -U %3 --pwfile=%4" | %5 postgres
