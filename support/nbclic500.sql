\connect nbclic

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;


CREATE TABLE system_info
(
  id serial NOT NULL,
  "version" integer NOT NULL,
  CONSTRAINT system_info_pk PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE system_info OWNER TO postgres;

INSERT INTO system_info("version")VALUES (500);



INSERT INTO function(strname, wsver, description, sidname, isdisplay, kval, is_apply_all) VALUES ('Define Change Management', 0, '', 'Define_Change_Management', true, '39576775766D765F7A737A6D5F76744E7A6D5874766E726D763A51', false);
INSERT INTO function(strname, wsver, description, sidname, isdisplay, kval, is_apply_all) VALUES ('Execute Network Change', 0, '', 'Execute_Change_Management', true, '39566776766676767A587A7A5F74766D4E736D5F74676E786D633A50', false);

INSERT INTO virtualfunction (strname, wsver, description, sidname, isdisplay, is_apply_all) VALUES ('Define Change Management', -1, NULL, 'Define Change Management', false, false);
INSERT INTO virtualfunction (strname, wsver, description, sidname, isdisplay, is_apply_all) VALUES ('Execute Network Change', -1, NULL, 'Execute Change Management', true, false);

INSERT INTO virtualfunction2function (virtualfunctionid, functionid) VALUES ( (select id from virtualfunction where sidname = 'Define Change Management'),  (select id from function where sidname = 'Define_Change_Management'));
INSERT INTO virtualfunction2function (virtualfunctionid, functionid) VALUES ( (select id from virtualfunction where sidname = 'Execute Change Management'),  (select id from function where sidname = 'Execute_Change_Management'));

INSERT INTO role2virtualfunction(roleid, virtualfunctionid) VALUES ((select id from role where name='PowerUser'), (select id from virtualfunction where sidname='Define Change Management'));
INSERT INTO role2virtualfunction(roleid, virtualfunctionid) VALUES ((select id from role where name='PowerUser'), (select id from virtualfunction where sidname='Execute Change Management'));

INSERT INTO role2virtualfunction(roleid, virtualfunctionid) VALUES ((select id from role where name='Admin'), (select id from virtualfunction where sidname='Define Change Management'));
INSERT INTO role2virtualfunction(roleid, virtualfunctionid) VALUES ((select id from role where name='Admin'), (select id from virtualfunction where sidname='Execute Change Management'));



DROP FUNCTION searchuser(character varying, integer);
DROP FUNCTION importuser(userview, character varying, character varying);
DROP VIEW userview;

CREATE OR REPLACE VIEW userview AS 
	SELECT * FROM "user" order by id;
ALTER TABLE userview OWNER TO postgres;


CREATE OR REPLACE FUNCTION importuser(r userview, wssguid character varying, rolename character varying)
  RETURNS integer AS
$BODY$
declare	
	ds_id integer;
	t_id integer;
	r_authtype integer;
BEGIN	
	select id into ds_id from "user" where lower(strname)=lower(r.strname);
	if ds_id IS NULL THEN
		insert into "user"(
			  strname,
			  "password",			  
			  can_use_global_telnet,			  		 
			  authentication_type,
			  description,
			  email,
			  telephone			  		 
			  )
			  values( 			  
			  r.strname,
			  r.password,			  
			  r.can_use_global_telnet,			  		 
			  r.authentication_type,
			  r.description,
			  r.email,
			  r.telephone
			  );
		select lastval() into ds_id;	  
		insert into user2role (userid,roleid) values (ds_id,(select id from role where lower(name)=lower(rolename)));	  
		insert into user2workspace (userid,workspaceguid) values (ds_id,wssguid);	  
		return ds_id;
			  
	else
		select authentication_type into r_authtype from "user" where id = ds_id ;		
		
		update "user" set(
			  "password",
			  description,
			  email,
			  telephone,				  
			  authentication_type			  			  	
			  ) = ( 
			  r.password,
			  r.description,
			  r.email,
			  r.telephone,			  			 
			  r.authentication_type
			  ) 
			  where id = ds_id ;

		if r_authtype = 0 then			
			delete from user2role where userid=ds_id;		
			delete from user2workspace where userid=ds_id;

			select id into t_id from user2workspace where userid=ds_id and workspaceguid=wssguid;	
			if t_id IS NULL then
				insert into user2workspace (userid,workspaceguid) values (ds_id,wssguid);	  
			end if;                				
		end if;		  

		select id into t_id from user2role where userid=ds_id and roleid=(select id from role where lower(name)=lower(rolename));	
		if t_id IS NULL then
			insert into user2role (userid,roleid) values (ds_id,(select id from role where lower(name)=lower(rolename)));	  
		end if;
			  
		return ds_id;
	end if;
EXCEPTION
	WHEN OTHERS THEN 
		RETURN -2;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION importuser(userview, character varying, character varying) OWNER TO postgres;

CREATE OR REPLACE FUNCTION searchuser(keyval character varying, optionval integer)
  RETURNS SETOF userview AS
$BODY$
declare
	r userview%rowtype;
BEGIN
	IF optionval =0 THEN
	    FOR r IN select * from userview where (strname ~* keyval or email ~* keyval) and strname not in ('default','system')  LOOP
		RETURN NEXT r;
	     END LOOP;		
	ELSIF optionval=1 then
	    FOR r IN select * from userview where (strname ~* keyval or email ~* keyval) and (validdate is null or validdate > now()) and strname not in ('default','system') LOOP
		RETURN NEXT r;
	     END LOOP;
	ELSIF optionval=2 then
	    FOR r IN select * from userview where (strname ~* keyval or email ~* keyval) and validdate is not null and validdate <now() and strname not in ('default','system') LOOP
		RETURN NEXT r;
	     END LOOP;	
	ELSIF optionval=3 then
	    FOR r IN select * from userview where (strname ~* keyval or email ~* keyval) and authentication_type=0 and strname not in ('default','system') LOOP
		RETURN NEXT r;
	     END LOOP;       		
	ELSIF optionval=4 then
	    FOR r IN select * from userview where (strname ~* keyval or email ~* keyval) and authentication_type=2 and strname not in ('default','system') LOOP
		RETURN NEXT r;
	     END LOOP;       		
	ELSE
	    FOR r IN select * from userview where (strname ~* keyval or email ~* keyval) and authentication_type=1 and strname not in ('default','system') LOOP
		RETURN NEXT r;
	     END LOOP;		
	end if;
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION searchuser(character varying, integer) OWNER TO postgres;

ALTER TABLE serverauthenticationtype  ALTER COLUMN address type character varying(256);

