\connect "nbws"

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;


---------------- delete user foreign key ----------------
ALTER TABLE devicegroup DROP CONSTRAINT devicegroup_fk_user;
ALTER TABLE objtimestamp DROP CONSTRAINT fk_objtimestamp_userid;
ALTER TABLE nomp_telnetinfo DROP CONSTRAINT nomp_telnetinfo_fk_userid;
ALTER TABLE userdevicesetting DROP CONSTRAINT userdevicesetting_fk_userid;
ALTER TABLE nomp_jumpbox DROP CONSTRAINT nomp_jumpbox_fk_userid;
ALTER TABLE object_file_info DROP CONSTRAINT file_info_fk;
ALTER TABLE showcommandtemplate DROP CONSTRAINT showcommandtemplate_fk;


---------------- publicobjtimestamp,privateobjtimestamp ----------------
ALTER TABLE objtimestamp DROP COLUMN userid;
INSERT INTO objtimestamp (typename, modifytime) VALUES ('ForceDataStore', '1900-01-01 00:00:00');
INSERT INTO objtimestamp (typename, modifytime) VALUES ('NewDataStore', '1900-01-01 00:00:00');
INSERT INTO objtimestamp (typename, modifytime) VALUES ('Procedure', '1900-01-01 00:00:00');
INSERT INTO objtimestamp (typename, modifytime) VALUES ('SystemVariable', '1900-01-01 00:00:00');

------- 1
CREATE TABLE objprivatetimestamp
(
  id serial NOT NULL,
  typename character varying(200) NOT NULL,
  modifytime timestamp without time zone NOT NULL,
  userid integer NOT NULL,
  licguid character varying(128) NOT NULL,
  CONSTRAINT objprivatetimestamp_pk PRIMARY KEY (id),
  CONSTRAINT objprivatetimestamp_un UNIQUE (userid, typename, licguid)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE objprivatetimestamp OWNER TO postgres;

------- 2
CREATE OR REPLACE FUNCTION updateprivateversion(tn character varying, uid integer, guid character varying)
  RETURNS boolean AS
$BODY$

declare
	r_id integer;
BEGIN
    select id into r_id from objprivatetimestamp where typename=tn and userid=uid and licguid=guid; 
	if r_id IS NULL THEN
		return -1;
	end if;

   if ds_id IS NULL THEN
	insert into objprivatetimestamp (modifytime,typename,userid,licguid) values (now(),tn,uid,guid);
   else
	update objprivatetimestamp set modifytime=now() where typename=tn and userid=uid and licguid=guid; 	
   end if;		
        
    RETURN true;
EXCEPTION
    WHEN OTHERS THEN 
 RETURN false;    
 
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION updateprivateversion(character varying, integer, character varying) OWNER TO postgres;

------- 3
CREATE OR REPLACE FUNCTION updatepublicversion(tn character varying)
  RETURNS boolean AS
$BODY$

BEGIN
    update objtimestamp set modifytime=now() where typename=tn;	
    
    RETURN true;
EXCEPTION
    WHEN OTHERS THEN 
	RETURN false;    
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION updatepublicversion(character varying) OWNER TO postgres;

------- 4
CREATE OR REPLACE FUNCTION valid_privateversion_time(dt timestamp without time zone, stypename character varying, uid integer, sguid character varying)
  RETURNS boolean AS
$BODY$
 
DECLARE
    t timestamp without time zone;
BEGIN
    select modifytime into t from objprivatetimestamp where typename=stypename and userid=uid and licguid=sguid;
 
    if(t>dt) then 
 RETURN true;
    else
 return false;
    end if;
EXCEPTION
    WHEN OTHERS THEN 
 RETURN false;    
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION valid_privateversion_time(timestamp without time zone, character varying, integer, character varying) OWNER TO postgres;

------- 5
DROP FUNCTION valid_version_time(timestamp without time zone, character varying, integer);
CREATE OR REPLACE FUNCTION valid_version_time(dt timestamp without time zone, stypename character varying)
  RETURNS boolean AS
$BODY$
 
DECLARE
    t timestamp without time zone;
BEGIN
    
  select modifytime into t from objtimestamp where typename=stypename;
 
 
    if(t>dt) then 
 RETURN true;
    else
 return false;
    end if;
EXCEPTION
    WHEN OTHERS THEN 
 RETURN false;    
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION valid_version_time(timestamp without time zone, character varying) OWNER TO postgres;

------ 6
CREATE OR REPLACE FUNCTION mergeprivatetime()
  RETURNS boolean AS
$BODY$
declare
	r_id integer;
	r userdevicesetting%rowtype;
	r1 devicegroup%rowtype;
	r2 linkgroup%rowtype;
	r3 showcommandtemplate%rowtype;
BEGIN
	for r in SELECT * FROM userdevicesetting  loop
		select id into r_id from objprivatetimestamp where typename='PrivateDeviceSetting' and userid=r.userid and licguid=:licguid;
		if r_id is null then
			insert into objprivatetimestamp (typename,userid,modifytime,licguid) values('PrivateDeviceSetting',r.userid,now(),:licguid);			
		end if;			
	end loop;

	for r1 in SELECT * FROM devicegroup where userid<>-1 loop
		select id into r_id from objprivatetimestamp where typename='PrivateDeviceGroup' and userid= r1.userid and licguid=:licguid;
		if r_id is null then
			insert into objprivatetimestamp (typename,userid,modifytime,licguid) values('PrivateDeviceGroup',r1.userid,now(),:licguid);			
		end if;			 
	end loop;

	for r2 in SELECT * FROM linkgroup where userid<>-1 loop
		select id into r_id from objprivatetimestamp where typename='PrivateLinkGroup' and userid= r2.userid and licguid=:licguid;
		if r_id is null then
			insert into objprivatetimestamp (typename,userid,modifytime,licguid) values('PrivateLinkGroup',r2.userid,now(),:licguid);			
		end if;			 
	end loop;

	for r3 in SELECT * FROM showcommandtemplate where userid<>-1 loop
		select id into r_id from objprivatetimestamp where typename='showcommandtemplate' and userid= r3.userid and licguid=:licguid;
		if r_id is null then
			update showcommandtemplate set lasttimestamp=now() where id=r3.id;
			update objtimestamp set modifytime=now() where typename='showcommandtemplate';
			insert into objprivatetimestamp (typename,userid,modifytime,licguid) values('showcommandtemplate',r3.userid,now(),:licguid);			
		end if;			 
	end loop;
		
	return true;
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION mergeprivatetime() OWNER TO postgres;

select * from mergeprivatetime();
DROP FUNCTION mergeprivatetime();


