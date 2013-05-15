\connect nbclic

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;


CREATE TRIGGER userinfo_p
  BEFORE INSERT OR UPDATE OR DELETE
  ON "user"
  FOR EACH ROW
  EXECUTE PROCEDURE process_userinfo_p();


SELECT pg_catalog.setval('user_id_seq', [userindex], true);
SELECT pg_catalog.setval('user2role_id_seq', [user2roleindex], true);
SELECT pg_catalog.setval('role_id_seq', [roleindex], true);
SELECT pg_catalog.setval('role2virtualfunction_id_seq', [role2functionindex], true);
