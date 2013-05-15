\connect nbclic

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;


CREATE TABLE role2workspace
(
  id serial NOT NULL,
  roleid integer NOT NULL,
  workspaceguid character(128) NOT NULL,
  CONSTRAINT role2workspace_pk PRIMARY KEY (id),
  CONSTRAINT role2workspace_fkrole FOREIGN KEY (roleid)
      REFERENCES "role" (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT role2workspace_un UNIQUE (roleid, workspaceguid)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE role2workspace OWNER TO postgres;

-- Index: fki_role2workspace_fkrole

-- DROP INDEX fki_role2workspace_fkrole;

CREATE INDEX fki_role2workspace_fkrole
  ON role2workspace
  USING btree
  (roleid);


ALTER TABLE serverauthenticationtype ALTER COLUMN address type character varying(256);


update "user" set offline_minutes=1440 where id<=2;


update role set name='Admins' where name='Admin';
update role set name='PowerUsers' where name='PowerUser';
update role set name='Engineers' where name='Engineer';
update role set name='Guests' where name='Guest';



DROP FUNCTION importuser(userview, character varying, character varying);

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
			  offline_minutes,
			  email,
			  telephone			  		 
			  )
			  values( 			  
			  r.strname,
			  r.password,			  
			  r.can_use_global_telnet,			  		 
			  r.authentication_type,
			  r.description,
			  r.offline_minutes,
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



DROP FUNCTION importuser(userview, character varying, character varying);

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
			  offline_minutes,
			  email,
			  telephone			  		 
			  )
			  values( 			  
			  r.strname,
			  r.password,			  
			  r.can_use_global_telnet,			  		 
			  r.authentication_type,
			  r.description,
			  r.offline_minutes,
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
			  description,
			  email,
			  telephone,				  
			  authentication_type			  			  	
			  ) = ( 			  
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


update system_info set version=501;