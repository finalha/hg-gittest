\connect nbclic

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;


DROP TRIGGER userinfo_p ON "user";


ALTER TABLE "user" DROP COLUMN validtime;
ALTER TABLE "user" ADD COLUMN validtime timestamp without time zone;
ALTER TABLE "user" ALTER COLUMN validtime SET STORAGE PLAIN;
