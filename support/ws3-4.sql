\connect "nbws"

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

-- 3com
--Extreme
--Foundary switch
--Nexus
--Cisco

delete from system_vendormodel where stroid ='1.3.6.1.4.1.9.5.1';
delete from system_vendormodel where stroid ='1.3.6.1.4.1.9.5.11';


DROP TRIGGER devicegroup_dt ON devicegroup;
DROP FUNCTION process_devicegroup_dt();

CREATE OR REPLACE FUNCTION process_devicegroup_dt()
  RETURNS trigger AS
$BODY$
declare tid integer;
declare uid integer;
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.strname = NEW.strname AND 
			OLD.strdesc = NEW.strdesc AND
			OLD.userid = NEW.userid AND			
			OLD.showcolor = NEW.showcolor 
		then
			return OLD;
		end IF;

		if not NEW.userid=OLD.userid then
			update objtimestamp set modifytime=now() where typename='PublicDeviceGroup';
			if new.userid=-1 then
				uid=old.userid;
			else 
				uid=new.userid;
			end if;
			select id into tid from objtimestamp where typename='PrivateDeviceGroup' and userid=uid;
			if tid is null then
				insert into objtimestamp (typename,userid,modifytime) values('PrivateDeviceGroup',uid,now());
			else
				update objtimestamp set modifytime=now() where typename='PrivateDeviceGroup' and userid=uid;
			end if;
		elseif NEW.userid=-1 then
			update objtimestamp set modifytime=now() where typename='PublicDeviceGroup';
		else
			select id into tid from objtimestamp where typename='PrivateDeviceGroup' and userid=new.userid;
			if tid is null then
				insert into objtimestamp (typename,userid,modifytime) values('PrivateDeviceGroup',new.userid,now());
			else
				update objtimestamp set modifytime=now() where typename='PrivateDeviceGroup' and userid=new.userid;
			end if;	
		end if;		
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		if NEW.userid=-1 then
			update objtimestamp set modifytime=now() where typename='PublicDeviceGroup';
		else
			select id into tid from objtimestamp where typename='PrivateDeviceGroup' and userid=new.userid;
			if tid is null then
				insert into objtimestamp (typename,userid,modifytime) values('PrivateDeviceGroup',new.userid,now());
			else
				update objtimestamp set modifytime=now() where typename='PrivateDeviceGroup' and userid=new.userid;
			end if;	
		end if;	
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		if OLD.userid=-1 then
			update objtimestamp set modifytime=now() where typename='PublicDeviceGroup';
		else
			select id into uid from "user" where id=OLD.userid;
			if( uid is not null) then 
				select id into tid from objtimestamp where typename='PrivateDeviceGroup' and userid=OLD.userid;
				if tid is null then
					insert into objtimestamp (typename,userid,modifytime) values('PrivateDeviceGroup',old.userid,now());
				else
					update objtimestamp set modifytime=now() where typename='PrivateDeviceGroup' and userid=old.userid;
				end if;	
			end if;	
		end if;			
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;
ALTER FUNCTION process_devicegroup_dt() OWNER TO postgres;

CREATE TRIGGER devicegroup_dt
  BEFORE INSERT OR UPDATE OR DELETE
  ON devicegroup
  FOR EACH ROW
  EXECUTE PROCEDURE process_devicegroup_dt();


ALTER TABLE "function"
   ADD COLUMN is_apply_all boolean NOT NULL DEFAULT false;


ALTER TABLE benchmarktask
   ADD COLUMN defined_source integer NOT NULL DEFAULT 0;
