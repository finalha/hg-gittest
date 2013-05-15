\connect "nbws"

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

UPDATE device_icon SET icon_name='Dell Force10 Switch' WHERE icon_name='Force10 Switch';

UPDATE object_file_info SET file_real_name='Dell Force10 Switch.emf' WHERE file_real_name='Force10 Switch.emf';
UPDATE object_file_info SET file_real_name='Dell Force10 Switch_CheckFail.emf' WHERE file_real_name='Force10 Switch_CheckFail.emf';
UPDATE object_file_info SET file_real_name='Dell Force10 Switch_Down.emf' WHERE file_real_name='Force10 Switch_Down.emf';
UPDATE object_file_info SET file_real_name='Dell Force10 Switch_Unstable.emf' WHERE file_real_name='Force10 Switch_Unstable.emf';
UPDATE object_file_info SET file_real_name='Dell Force10 Switch_Up.emf' WHERE file_real_name='Force10 Switch_Up.emf';


DROP TRIGGER device_property_dt ON device_property;
DROP FUNCTION process_device_property_dt();

update device_property set manageif_mac='' where manageif_mac is null;
update device_property set vendor='' where vendor is null;
update device_property set model='' where model is null;
update device_property set sysobjectid='' where sysobjectid is null;
update device_property set software_version='' where software_version is null;
update device_property set serial_number='' where serial_number is null;
update device_property set asset_tag='' where asset_tag is null;
update device_property set system_memory='' where system_memory is null;
update device_property set location='' where location is null;
update device_property set network_cluster='' where network_cluster is null;
update device_property set contact='' where contact is null;
update device_property set hierarchy_layer='' where hierarchy_layer is null;
update device_property set description='' where description is null;
update device_property set management_interface='' where management_interface is null;
update device_property set extradata='' where extradata is null;

CREATE OR REPLACE FUNCTION process_device_property_dt()
  RETURNS trigger AS
$BODY$
		
    BEGIN
        IF (TG_OP = 'UPDATE') THEN			
		IF 	OLD.deviceid = NEW.deviceid AND 
			OLD.manageif_mac = NEW.manageif_mac AND
			OLD.vendor = NEW.vendor AND
			OLD.model = NEW.model AND 
			OLD.sysobjectid = NEW.sysobjectid AND
			OLD.software_version = NEW.software_version AND
			OLD.serial_number = NEW.serial_number AND 
			OLD.asset_tag = NEW.asset_tag AND
			OLD.system_memory = NEW.system_memory AND
			OLD.location = NEW.location AND
			OLD.network_cluster = NEW.network_cluster AND
			OLD.contact = NEW.contact AND 
			OLD.hierarchy_layer = NEW.hierarchy_layer AND
			OLD.description = NEW.description AND
			OLD.management_interface = NEW.management_interface AND			
			OLD.extradata = NEW.extradata 
		 then
			return OLD;
		end IF;	
		update objtimestamp set modifytime=now() where typename='device_property';		
		NEW.lasttimestamp=now();	
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='device_property';
		NEW.lasttimestamp=now();
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
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


CREATE OR REPLACE FUNCTION deleteoneiptalbe(dt timestamp without time zone)
  RETURNS boolean AS
$BODY$

DECLARE
BEGIN		
	DELETE FROM ip2mac WHERE userflag<>1 and dt>retrievedate; 	        
	return true;
EXCEPTION    
	WHEN OTHERS THEN   
		return false;		
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION deleteoneiptalbe(timestamp without time zone) OWNER TO postgres;


update system_info set ver=418;