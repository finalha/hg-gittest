\connect "nbws"

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;


ALTER TABLE "user" ADD COLUMN expired_days integer;
ALTER TABLE "user" ALTER COLUMN expired_days SET STORAGE PLAIN;
