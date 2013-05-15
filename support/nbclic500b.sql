\connect nbclic

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;


ALTER TABLE serverauthenticationtype ALTER COLUMN address type text;
ALTER TABLE serverauthenticationtype ALTER COLUMN connectname type text;
ALTER TABLE serverauthenticationtype ALTER COLUMN connectpwd type character varying(256);

UPDATE "role" SET name='Admins' WHERE name='Admin';
UPDATE "role" SET name='PowerUsers' WHERE name='PowerUser';
UPDATE "role" SET name='Engineer' WHERE name='Engineers';
UPDATE "role" SET name='Guests' WHERE name='Guest';


DROP FUNCTION importuser(userview, character varying, character varying);
DROP FUNCTION searchuser(character varying, integer);
DROP VIEW userview;

ALTER TABLE "user" ALTER COLUMN validtime type time without time zone;

CREATE OR REPLACE VIEW userview AS 
 SELECT "user".id, "user".strname, "user".password, "user".description, "user".email, "user".telephone, "user".can_use_global_telnet, "user".offline_minutes, "user".expired_days, "user".authentication_type, "user".create_time, "user".wsver, "user".validtime, "user".validdate, "user".firstlogtime, "user".localnode
   FROM "user"
  ORDER BY "user".id;

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


update system_info set version=502;