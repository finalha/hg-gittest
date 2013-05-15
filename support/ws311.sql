\connect "nbws"

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

INSERT INTO "function"(strname, wsver, description, sidname, kval, isdisplay)
    VALUES ('Monitor for Local Workspace', 1, '', 'Local_Monitor', '384F6978676F6D4E6C5F727A6C6C3A3F', false);

INSERT INTO "function"(strname, wsver, description, sidname, kval, isdisplay)
    VALUES ('Monitor for Share Workspace', 0, '', 'Monitor', '344E336D32673569393A336C3072346C3530', false);

INSERT INTO "function"(strname, wsver, description, sidname, kval, isdisplay)
    VALUES ('Path for Local Workspace', 1, '', 'Local_Path', '384F73787A6F5F4B7A676C3A3C', false);


INSERT INTO "function"(strname, wsver, description, sidname, kval, isdisplay)
    VALUES ('Path for Share Workspace', 0, '', 'Path', '344B3367323A3533393073347A3533', false);
    

INSERT INTO role2function( roleid, functionid) VALUES (( select id from "role" where name='Admin'), (select id from function where sidname='Local_Monitor') );
INSERT INTO role2function( roleid, functionid) VALUES (( select id from "role" where name='Admin'), (select id from function where sidname='Monitor') );
INSERT INTO role2function( roleid, functionid) VALUES (( select id from "role" where name='Admin'), (select id from function where sidname='Local_Path') );
INSERT INTO role2function( roleid, functionid) VALUES (( select id from "role" where name='Admin'), (select id from function where sidname='Path') );

INSERT INTO role2function( roleid, functionid) VALUES (( select id from "role" where name='Architect Role'), (select id from function where sidname='Local_Monitor') );
INSERT INTO role2function( roleid, functionid) VALUES (( select id from "role" where name='Architect Role'), (select id from function where sidname='Local_Path') );


ALTER TABLE benchmarktaskstatus ADD COLUMN logdetail text;

ALTER TABLE globeinfo ADD COLUMN workspacedescription character varying(256);

update "function" set strname='Server Benchmark' where sidname='Benchmark';


DROP TRIGGER userdevicesetting_dt ON userdevicesetting;
DROP FUNCTION process_userdevicesetting_dt();


CREATE OR REPLACE FUNCTION process_userdevicesetting_dt()
  RETURNS trigger AS
$BODY$
declare tid integer;
declare uid integer;
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF  OLD.deviceid = NEW.deviceid AND 
		   OLD.userid = NEW.userid AND
		   OLD.managerip = NEW.managerip AND
		   OLD.telnetusername = NEW.telnetusername AND 
		   OLD.telnetpwd = NEW.telnetpwd AND
		   OLD.jumpboxid = NEW.jumpboxid
		   then
			return OLD;
		end IF;
		NEW.dtstamp=now();
		  select id into tid from objtimestamp where typename='PrivateDeviceSetting' and userid=new.userid;
		  if tid is null then
		   insert into objtimestamp (typename,userid,modifytime) values('PrivateDeviceSetting',new.userid,now());
		  else
		   update objtimestamp set modifytime=now() where typename='PrivateDeviceSetting' and userid=new.userid;
		  end if;
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
	  select id into tid from objtimestamp where typename='PrivateDeviceSetting' and userid=new.userid;
	  if tid is null then
	   insert into objtimestamp (typename,userid,modifytime) values('PrivateDeviceSetting',new.userid,now());
	  else
	   update objtimestamp set modifytime=now() where typename='PrivateDeviceSetting' and userid=new.userid;
	  end if;
	  NEW.dtstamp=now();
  RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
	      select id into uid from "user" where id=OLD.userid;
	     if( uid is not null) then 
			select id into tid from objtimestamp where typename='PrivateDeviceSetting' and userid=old.userid;
			if tid is null then
				insert into objtimestamp (typename,userid,modifytime) values('PrivateDeviceSetting',old.userid,now());
			else
				update objtimestamp set modifytime=now() where typename='PrivateDeviceSetting' and userid=old.userid;
			end if;
	     end if;					 
	  RETURN OLD;  
        END IF;
        RETURN NULL;
    END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION process_userdevicesetting_dt() OWNER TO postgres;


CREATE TRIGGER userdevicesetting_dt
  BEFORE INSERT OR UPDATE OR DELETE
  ON userdevicesetting
  FOR EACH ROW
  EXECUTE PROCEDURE process_userdevicesetting_dt();
