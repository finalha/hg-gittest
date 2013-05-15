\connect "postgres"

select pg_terminate_backend(procpid) from pg_stat_activity where datname=:nbwsp 
