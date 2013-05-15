\connect :nbwsp

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

INSERT INTO objtimestamp (typename, modifytime) VALUES ('ForceDataStore', '1900-01-01 00:00:00');
INSERT INTO objtimestamp (typename, modifytime) VALUES ('NewDataStore', '1900-01-01 00:00:00');

DROP TRIGGER device_property_dt ON device_property;
DROP FUNCTION process_device_property_dt();

DROP TRIGGER discover_missdevice_dt ON discover_missdevice;
DROP FUNCTION process_discover_missdevice_dt();

DROP TRIGGER discover_newdevice_dt ON discover_newdevice;
DROP FUNCTION process_discover_newdevice_dt();

DROP TRIGGER discover_snmpdevice_dt ON discover_snmpdevice;
DROP FUNCTION process_discover_snmpdevice_dt();



CREATE OR REPLACE FUNCTION process_discover_snmpdevice_dt()
  RETURNS trigger AS
$BODY$

    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.hostname = NEW.hostname AND 
			OLD.mgrip = NEW.mgrip AND
			OLD.snmpro = NEW.snmpro AND
			OLD.devtype = NEW.devtype AND
			OLD.vendor = NEW.vendor AND
			OLD.model = NEW.model AND
			OLD.findtime = NEW.findtime AND
			OLD.log = NEW.log
		 then
			return OLD;
		end IF;
		update objtimestamp set modifytime=now() where typename='discover_snmpdevice';		
		update objtimestamp set modifytime=now() where typename='discover_newdevice';
		update objtimestamp set modifytime=now() where typename='discover_missdevice';
		update objtimestamp set modifytime=now() where typename='device_property';
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='discover_snmpdevice';		
		update objtimestamp set modifytime=now() where typename='discover_newdevice';
		update objtimestamp set modifytime=now() where typename='discover_missdevice';
		update objtimestamp set modifytime=now() where typename='device_property';
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='discover_snmpdevice';		
		update objtimestamp set modifytime=now() where typename='discover_newdevice';
		update objtimestamp set modifytime=now() where typename='discover_missdevice';
		update objtimestamp set modifytime=now() where typename='device_property';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION process_discover_snmpdevice_dt() OWNER TO postgres;


CREATE TRIGGER discover_snmpdevice_dt
  BEFORE INSERT OR UPDATE OR DELETE
  ON discover_snmpdevice
  FOR EACH ROW
  EXECUTE PROCEDURE process_discover_snmpdevice_dt();


CREATE OR REPLACE FUNCTION process_discover_newdevice_dt()
  RETURNS trigger AS
$BODY$

    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.hostname = NEW.hostname AND 
			OLD.mgrip = NEW.mgrip AND
			OLD.devtype = NEW.devtype AND
			OLD.vendor = NEW.vendor AND
			OLD.model = NEW.model AND
			OLD.findtime = NEW.findtime AND
			OLD.log = NEW.log AND
			OLD.lasttime=NEW.lasttime
		 then
			return OLD;
		end IF;
		update objtimestamp set modifytime=now() where typename='discover_snmpdevice';		
		update objtimestamp set modifytime=now() where typename='discover_newdevice';
		update objtimestamp set modifytime=now() where typename='discover_missdevice';
		update objtimestamp set modifytime=now() where typename='device_property';
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='discover_snmpdevice';		
		update objtimestamp set modifytime=now() where typename='discover_newdevice';
		update objtimestamp set modifytime=now() where typename='discover_missdevice';
		update objtimestamp set modifytime=now() where typename='device_property';
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='discover_snmpdevice';		
		update objtimestamp set modifytime=now() where typename='discover_newdevice';
		update objtimestamp set modifytime=now() where typename='discover_missdevice';
		update objtimestamp set modifytime=now() where typename='device_property';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION process_discover_newdevice_dt() OWNER TO postgres;


CREATE TRIGGER discover_newdevice_dt
  BEFORE INSERT OR UPDATE OR DELETE
  ON discover_newdevice
  FOR EACH ROW
  EXECUTE PROCEDURE process_discover_newdevice_dt();



CREATE OR REPLACE FUNCTION process_discover_missdevice_dt()
  RETURNS trigger AS
$BODY$

    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.mgrip = NEW.mgrip AND 
			OLD.devtype = NEW.devtype AND
			OLD.vendor = NEW.vendor AND
			OLD.model = NEW.model AND
			OLD.checktime = NEW.checktime AND
			OLD.log = NEW.log AND
			OLD.modifytime = NEW.modifytime AND
			OLD.deviceid = NEW.deviceid		
		 then
			return OLD;
		end IF;
		update objtimestamp set modifytime=now() where typename='discover_snmpdevice';		
		update objtimestamp set modifytime=now() where typename='discover_newdevice';
		update objtimestamp set modifytime=now() where typename='discover_missdevice';
		update objtimestamp set modifytime=now() where typename='device_property';
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='discover_snmpdevice';		
		update objtimestamp set modifytime=now() where typename='discover_newdevice';
		update objtimestamp set modifytime=now() where typename='discover_missdevice';
		update objtimestamp set modifytime=now() where typename='device_property';
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='discover_snmpdevice';		
		update objtimestamp set modifytime=now() where typename='discover_newdevice';
		update objtimestamp set modifytime=now() where typename='discover_missdevice';
		update objtimestamp set modifytime=now() where typename='device_property';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION process_discover_missdevice_dt() OWNER TO postgres;


CREATE TRIGGER discover_missdevice_dt
  BEFORE INSERT OR UPDATE OR DELETE
  ON discover_missdevice
  FOR EACH ROW
  EXECUTE PROCEDURE process_discover_missdevice_dt();


CREATE OR REPLACE FUNCTION process_device_property_dt()
  RETURNS trigger AS
$BODY$
		
    BEGIN
        IF (TG_OP = 'UPDATE') THEN	
		update objtimestamp set modifytime=now() where typename='discover_snmpdevice';		
		update objtimestamp set modifytime=now() where typename='discover_newdevice';
		update objtimestamp set modifytime=now() where typename='discover_missdevice';
		update objtimestamp set modifytime=now() where typename='device_property';
		NEW.lasttimestamp=now();	
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='discover_snmpdevice';		
		update objtimestamp set modifytime=now() where typename='discover_newdevice';
		update objtimestamp set modifytime=now() where typename='discover_missdevice';
		update objtimestamp set modifytime=now() where typename='device_property';
		NEW.lasttimestamp=now();
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='discover_snmpdevice';		
		update objtimestamp set modifytime=now() where typename='discover_newdevice';
		update objtimestamp set modifytime=now() where typename='discover_missdevice';
		update objtimestamp set modifytime=now() where typename='device_property';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION process_device_property_dt() OWNER TO postgres;

CREATE TRIGGER device_property_dt
  BEFORE INSERT OR UPDATE OR DELETE
  ON device_property
  FOR EACH ROW
  EXECUTE PROCEDURE process_device_property_dt();
  
  

update system_info set ver=420;