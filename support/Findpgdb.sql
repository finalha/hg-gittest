\connect "postgres"

SET client_min_messages = warning;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET escape_string_warning = off;

select datname from pg_database where datname=:nbws;


