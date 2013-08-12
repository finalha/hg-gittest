\connect nbclic

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;


CREATE TABLE user_advance
(
  id serial NOT NULL,
  loginfailuretimesbyseatlicense integer NOT NULL DEFAULT 0,
  loginfailuretimesbylocalnodes integer NOT NULL DEFAULT 0,
  userid integer NOT NULL,
  lasttimestamp timestamp without time zone NOT NULL DEFAULT now(),
  CONSTRAINT user_advance_pk PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE user_advance OWNER TO postgres;


CREATE TABLE userloginhistory
(
  id serial NOT NULL,
  logintime timestamp without time zone DEFAULT now(),
  logouttime timestamp without time zone,
  userid integer NOT NULL,
  workspace_guid character varying(128),
  ip character varying(128) NOT NULL,
  logintype integer NOT NULL DEFAULT 0, -- 0:online; 1:offline;
  sessionid character varying(128) NOT NULL,
  lasttimestamp timestamp without time zone NOT NULL DEFAULT now(),
  CONSTRAINT userloginhistory_pk PRIMARY KEY (id),
  CONSTRAINT userloginhistory_fk FOREIGN KEY (userid)
      REFERENCES "user" (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
ALTER TABLE userloginhistory OWNER TO postgres;
COMMENT ON COLUMN userloginhistory.logintype IS '0:online; 1:offline;';


-- Index: fki_userloginhistory_fk

-- DROP INDEX fki_userloginhistory_fk;

CREATE INDEX fki_userloginhistory_fk
  ON userloginhistory
  USING btree
  (userid);



DROP FUNCTION checkuser(character varying, character varying);

CREATE OR REPLACE FUNCTION checkuser(username character varying, pwd character varying)
  RETURNS integer AS
$BODY$
 DECLARE
	r_id integer;
BEGIN
	select id into r_id from "user" where lower(strname)=lower(username) AND password=md5(pwd);
	if r_id IS NULL THEN
		return -1;
	ELSE
		return r_id;
	END if;
	
EXCEPTION
	WHEN OTHERS THEN 
		RETURN -1;
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION checkuser(character varying, character varying) OWNER TO postgres;



update system_info set version=510;