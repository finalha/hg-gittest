\connect "nbws"

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

ALTER TABLE fixuproutetable rename column interface to infname;


----------------------------------- object_customized_attribute
INSERT INTO objtimestamp(
            typename, modifytime, userid)
    VALUES ( 'object_customized_attribute', '1900-01-01 00:00:00', -1);


CREATE TABLE object_customized_attribute
(
  id serial NOT NULL,
  objectid integer NOT NULL, -- 0-Site,1-device,2-interface,3-link,4-moudle...
  name character varying(64) NOT NULL, -- field name
  alias character varying(256), -- display name
  allow_export boolean NOT NULL, -- Export to asset report...
  "type" integer NOT NULL DEFAULT 1, -- 1,system field 2,customize field...
  allow_modify_exported boolean NOT NULL, -- Whether to allow the changes exported property
  lasttimestamp timestamp without time zone NOT NULL DEFAULT now(),
  CONSTRAINT object_customized_attribute_pk PRIMARY KEY (id),
  CONSTRAINT object_customized_attribute_object_alias_un UNIQUE (objectid,alias),
  CONSTRAINT object_customized_attribute_object_name_un UNIQUE (objectid, name)
) 
WITHOUT OIDS;
ALTER TABLE object_customized_attribute OWNER TO postgres;
COMMENT ON COLUMN object_customized_attribute.objectid IS '0-Site,1-device,2-interface,3-link,4-moudle
';
COMMENT ON COLUMN object_customized_attribute.name IS 'field name';
COMMENT ON COLUMN object_customized_attribute.alias IS 'display name';
COMMENT ON COLUMN object_customized_attribute.allow_export IS 'Export to asset report
';
COMMENT ON COLUMN object_customized_attribute."type" IS '1,system field 2,customize field
';
COMMENT ON COLUMN object_customized_attribute.allow_modify_exported IS 'Whether to allow the changes exported property';



CREATE OR REPLACE FUNCTION process_object_customized_attribute_dt()
  RETURNS trigger AS
$BODY$

    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.objectid = NEW.objectid AND 
			OLD.name = NEW.name AND
			OLD.alias = NEW.alias AND
			OLD.allow_export = NEW.allow_export AND
			OLD.type = NEW.type AND
			OLD.allow_modify_exported = NEW.allow_modify_exported
		 then
			return OLD;
		end IF;
		update objtimestamp set modifytime=now() where typename='object_customized_attribute';
		NEW.lasttimestamp=now();
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='object_customized_attribute';
		NEW.lasttimestamp=now();
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='object_customized_attribute';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;
ALTER FUNCTION process_object_customized_attribute_dt() OWNER TO postgres;


CREATE TRIGGER object_customized_attribute_dt
  BEFORE INSERT OR UPDATE OR DELETE
  ON object_customized_attribute
  FOR EACH ROW
  EXECUTE PROCEDURE process_object_customized_attribute_dt();


--------------------------------device property

INSERT INTO objtimestamp(
            typename, modifytime, userid)
    VALUES ( 'device_property', '1900-01-01 00:00:00', -1);

CREATE TABLE device_property
(
  id serial NOT NULL,
  deviceid integer NOT NULL,
  manageif_mac character varying(64),
  vendor character varying(256),
  model character varying(256),
  sysobjectid character varying(256),
  software_version character varying(256),
  serial_number character varying(256),
  asset_tag character varying(256),
  system_memory character varying(256),
  "location" character varying(256),
  network_cluster character varying(256),
  contact character varying(256),
  hierarchy_layer character varying(256),
  description character varying(256),
  management_interface character varying(256),
  lasttimestamp timestamp without time zone NOT NULL DEFAULT now(),
  CONSTRAINT device_property_pk PRIMARY KEY (id),
  CONSTRAINT device_property_fk FOREIGN KEY (deviceid)
      REFERENCES devices (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
) 
WITHOUT OIDS;
ALTER TABLE device_property OWNER TO postgres;


CREATE OR REPLACE FUNCTION process_device_property_dt()
  RETURNS trigger AS
$BODY$
		
    BEGIN
        IF (TG_OP = 'UPDATE') THEN	
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
  LANGUAGE 'plpgsql' VOLATILE;
ALTER FUNCTION process_device_property_dt() OWNER TO postgres;


CREATE TRIGGER device_property_dt
  BEFORE INSERT OR UPDATE OR DELETE
  ON device_property
  FOR EACH ROW
  EXECUTE PROCEDURE process_device_property_dt();



CREATE OR REPLACE VIEW devicepropertyview AS 
 SELECT device_property.*, devices.strname AS devicename,devices.isubtype as itype
   FROM device_property, devices
  WHERE device_property.deviceid = devices.id order by device_property.id;



CREATE OR REPLACE FUNCTION view_device_property_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying)
  RETURNS SETOF devicepropertyview AS
$BODY$
declare
	r devicepropertyview%rowtype;
	t timestamp without time zone;
BEGIN
	select modifytime into t from objtimestamp where typename=stypename;
	
	if t is null or t>dt then
		if imax <0 then
			for r in SELECT * FROM devicepropertyview where id>ibegin and lasttimestamp>dt loop
			return next r;
			end loop;
		else
			for r in SELECT * FROM devicepropertyview where id>ibegin and lasttimestamp>dt limit imax loop
			return next r;
			end loop;

		end if;	
	end if;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE;
ALTER FUNCTION view_device_property_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) OWNER TO postgres;




----------------------------------- device_customized_info

INSERT INTO objtimestamp(
            typename, modifytime, userid)
    VALUES ( 'device_customized_info', '1900-01-01 00:00:00', -1);
    

CREATE TABLE device_customized_info
(
  id serial NOT NULL,
  objectid integer NOT NULL,
  attributeid integer NOT NULL,
  attribute_value character varying(256),
  lasttimestamp timestamp without time zone DEFAULT now(),
  CONSTRAINT device_customized_info_pk PRIMARY KEY (id),
  CONSTRAINT device_customized_info_attributeid_fk FOREIGN KEY (attributeid)
      REFERENCES object_customized_attribute (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT device_customized_info_objectid_fk FOREIGN KEY (objectid)
      REFERENCES device_property (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT device_customized_info_un UNIQUE (objectid, attributeid)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE device_customized_info OWNER TO postgres;

CREATE INDEX fki_device_customized_info_attributeid_fk
  ON device_customized_info
  USING btree
  (attributeid);

CREATE INDEX fki_device_customized_info_objectid_fk
  ON device_customized_info
  USING btree
  (objectid);



CREATE OR REPLACE FUNCTION process_device_customized_info_dt()
  RETURNS trigger AS
$BODY$
		
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.objectid = NEW.objectid AND 			
			OLD.attributeid = NEW.attributeid AND 			
			OLD.attribute_value = NEW.attribute_value		
		 then
			return OLD;
		end IF;
		update objtimestamp set modifytime=now() where typename='device_customized_info';
		NEW.lasttimestamp=now();	
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='device_customized_info';
		NEW.lasttimestamp=now();
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='device_customized_info';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION process_device_customized_info_dt() OWNER TO postgres;



CREATE TRIGGER device_customized_info_dt
  BEFORE INSERT OR UPDATE OR DELETE
  ON device_customized_info
  FOR EACH ROW
  EXECUTE PROCEDURE process_device_customized_info_dt();
  

CREATE OR REPLACE VIEW device_customized_infoview AS 
 SELECT device_customized_info.*, devicepropertyview.devicename
   FROM device_customized_info, devicepropertyview
  WHERE device_customized_info.objectid = devicepropertyview.id order by device_customized_info.id; 

ALTER TABLE device_customized_infoview OWNER TO postgres;


CREATE OR REPLACE FUNCTION view_device_customized_info_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying)
  RETURNS SETOF device_customized_infoview AS
$BODY$
declare
	r device_customized_infoview%rowtype;
	t timestamp without time zone;
BEGIN
	select modifytime into t from objtimestamp where typename=stypename;
	
	if t is null or t>dt then
		if imax <0 then
			for r in SELECT * FROM device_customized_infoview where id>ibegin and lasttimestamp>dt loop
			return next r;
			end loop;
		else
			for r in SELECT * FROM device_customized_infoview where id>ibegin and lasttimestamp>dt limit imax loop
			return next r;
			end loop;

		end if;	
	end if;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION view_device_customized_info_retrieve(integer, integer, timestamp without time zone, character varying) OWNER TO postgres;


----------------------------------------- interfacesetting

ALTER TABLE interfacesetting ADD COLUMN interface_ip character varying(64);
ALTER TABLE interfacesetting ALTER COLUMN interface_ip SET STORAGE EXTENDED;

ALTER TABLE interfacesetting ADD COLUMN module_slot character varying(256) NOT NULL default '-1';
ALTER TABLE interfacesetting ALTER COLUMN module_slot SET STORAGE PLAIN;

ALTER TABLE interfacesetting ADD COLUMN module_type character varying(256);
ALTER TABLE interfacesetting ALTER COLUMN module_type SET STORAGE EXTENDED;

ALTER TABLE interfacesetting ADD COLUMN interface_status character varying(256);
ALTER TABLE interfacesetting ALTER COLUMN interface_status SET STORAGE EXTENDED;

ALTER TABLE interfacesetting ADD COLUMN speed_int character varying(256) default '-1';
ALTER TABLE interfacesetting ALTER COLUMN speed_int SET STORAGE EXTENDED;

ALTER TABLE interfacesetting ADD COLUMN duplex character varying(256) default '-1';
ALTER TABLE interfacesetting ALTER COLUMN duplex SET STORAGE EXTENDED;

ALTER TABLE interfacesetting ADD COLUMN description character varying(256);
ALTER TABLE interfacesetting ALTER COLUMN description SET STORAGE EXTENDED;

ALTER TABLE interfacesetting ADD COLUMN mpls_vrf character varying(256);
ALTER TABLE interfacesetting ALTER COLUMN mpls_vrf SET STORAGE EXTENDED;
COMMENT ON COLUMN interfacesetting.mpls_vrf IS 'search item';

ALTER TABLE interfacesetting ADD COLUMN vlan character varying(256);
ALTER TABLE interfacesetting ALTER COLUMN vlan SET STORAGE EXTENDED;
COMMENT ON COLUMN interfacesetting.vlan IS 'search item';

ALTER TABLE interfacesetting ADD COLUMN voice_vlan character varying(256);
ALTER TABLE interfacesetting ALTER COLUMN voice_vlan SET STORAGE EXTENDED;
COMMENT ON COLUMN interfacesetting.voice_vlan IS 'search item';

ALTER TABLE interfacesetting ADD COLUMN mask integer default 32;
ALTER TABLE interfacesetting ALTER COLUMN mask SET STORAGE PLAIN;

ALTER TABLE interfacesetting ADD COLUMN routing_protocol character varying(256);
ALTER TABLE interfacesetting ALTER COLUMN routing_protocol SET STORAGE EXTENDED;

ALTER TABLE interfacesetting ADD COLUMN portmode character varying(256);
ALTER TABLE interfacesetting ALTER COLUMN portmode SET STORAGE EXTENDED;

ALTER TABLE interfacesetting ADD COLUMN multicast_mode character varying(256);
ALTER TABLE interfacesetting ALTER COLUMN multicast_mode SET STORAGE EXTENDED;
COMMENT ON COLUMN interfacesetting.multicast_mode IS 'search item';

ALTER TABLE interfacesetting ADD COLUMN counter character varying(255);
ALTER TABLE interfacesetting ALTER COLUMN counter SET STORAGE EXTENDED;

ALTER TABLE interfacesetting ADD COLUMN isphysical integer not null default 0;


DROP FUNCTION view_interface_setting_retrieve(integer, integer, timestamp without time zone);
DROP VIEW interfacesettingview;

CREATE OR REPLACE VIEW interfacesettingview AS 
 SELECT interfacesetting.*, devices.strname AS devicename
   FROM interfacesetting, devices
  WHERE devices.id = interfacesetting.deviceid
  ORDER BY interfacesetting.id;

ALTER TABLE interfacesettingview OWNER TO postgres;

CREATE OR REPLACE FUNCTION view_interface_setting_retrieve(ibegin integer, imax integer, dt timestamp without time zone)
  RETURNS SETOF interfacesettingview AS
$BODY$
declare
	r interfacesettingview%rowtype;
BEGIN
	if imax <0 then
		for r in SELECT * FROM interfacesettingview where id>ibegin AND lasttimestamp>dt loop
		return next r;
		end loop;
	else
		for r in SELECT * FROM interfacesettingview where id>ibegin AND lasttimestamp>dt limit imax loop
		return next r;
		end loop;

	end if;
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION view_interface_setting_retrieve(integer, integer, timestamp without time zone) OWNER TO postgres;


DROP FUNCTION interface_setting_upsert(character varying, interfacesetting);

CREATE OR REPLACE FUNCTION interface_setting_upsert(devname character varying, ins interfacesetting)
  RETURNS integer AS
$BODY$
declare
	r_id integer;
	ds_id integer;
BEGIN
	select id into r_id from devices where strname=devname;
	if r_id IS NULL THEN
		return -1;
	end if;

	select id into ds_id from interfacesetting where deviceid=r_id AND interfacename=ins.interfacename;
	if ds_id IS NULL THEN
		insert into interfacesetting(
			  deviceid,
			  interfacename,
			  usermodifiedflag,
			  livestatus,
			  mibindex,
			  bandwidth,
			  macaddress,
			  interface_ip,
			  module_slot,
			  module_type,
			  interface_status,
			  speed_int,
			  duplex,
			  description,
			  mpls_vrf,
			  vlan,
			  voice_vlan,
			  mask,
			  routing_protocol,
			  portmode,
			  multicast_mode,
			  counter,
			  isphysical
			  )
			  values( 
			  r_id,
			  ins.interfacename,
			  ins.usermodifiedflag,
			  ins.livestatus,
			  ins.mibindex,
			  ins.bandwidth,
			  ins.macaddress,
			  ins.interface_ip,
			  ins.module_slot,
			  ins.module_type,
			  ins.interface_status,
			  ins.speed_int,
			  ins.duplex,
			  ins.description,
			  ins.mpls_vrf,
			  ins.vlan,
			  ins.voice_vlan,
			  ins.mask,
			  ins.routing_protocol,
			  ins.portmode,
			  ins.multicast_mode,
			  ins.counter,
			  ins.isphysical
			  );
			  return lastval();
	else
		update interfacesetting set(
			  usermodifiedflag,
			  livestatus,
			  mibindex,
			  bandwidth,
			  macaddress,
			  lasttimestamp,
			  interface_ip,
			  module_slot,
			  module_type,
			  interface_status,
			  speed_int,
			  duplex,
			  description,
			  mpls_vrf,
			  vlan,
			  voice_vlan,
			  mask,
			  routing_protocol,
			  portmode,
			  multicast_mode,
			  counter,
			  isphysical
			  ) = ( 
			  ins.usermodifiedflag,
			  ins.livestatus,
			  ins.mibindex,
			  ins.bandwidth,
			  ins.macaddress,
			  now(),
			  ins.interface_ip,
			  ins.module_slot,
			  ins.module_type,
			  ins.interface_status,
			  ins.speed_int,
			  ins.duplex,
			  ins.description,
			  ins.mpls_vrf,
			  ins.vlan,
			  ins.voice_vlan,
			  ins.mask,
			  ins.routing_protocol,
			  ins.portmode,
			  ins.multicast_mode,
			  ins.counter,
			  ins.isphysical
			  ) 
			  where id = ds_id;
		return ds_id;
	end if;
EXCEPTION
	WHEN OTHERS THEN 
		RETURN -2;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION interface_setting_upsert(character varying, interfacesetting) OWNER TO postgres;



DROP FUNCTION interface_setting_update(character varying, interfacesetting);

CREATE OR REPLACE FUNCTION interface_setting_update(devname character varying, ins interfacesetting)
  RETURNS integer AS
$BODY$
declare
	r_id integer;
	ds_id integer;
BEGIN
	select id into r_id from devices where strname=devname;
	if r_id IS NULL THEN
		return -1;
	end if;

	select id into ds_id from interfacesetting where deviceid=r_id AND interfacename=ins.interfacename;
	if ds_id IS NULL THEN
		return -1;
	else
		update interfacesetting set(
		  usermodifiedflag,
		  livestatus,
		  mibindex,
		  bandwidth,
		  macaddress,
		  lasttimestamp,
		  interface_ip,
			  module_slot,
			  module_type,
			  interface_status,
			  speed_int,
			  duplex,
			  description,
			  mpls_vrf,
			  vlan,
			  voice_vlan,
			  mask,
			  routing_protocol,
			  portmode,
			  multicast_mode,
			  counter,
			  isphysical
		  ) = ( 
		  ins.usermodifiedflag,
		  ins.livestatus,
		  ins.mibindex,
		  ins.bandwidth,
		  ins.macaddress,
		  now(),
		  ins.interface_ip,
			  ins.module_slot,
			  ins.module_type,
			  ins.interface_status,
			  ins.speed_int,
			  ins.duplex,
			  ins.description,
			  ins.mpls_vrf,
			  ins.vlan,
			  ins.voice_vlan,
			  ins.mask,
			  ins.routing_protocol,
			  ins.portmode,
			  ins.multicast_mode,
			  ins.counter,
			  ins.isphysical
		  ) 
		  where id = ds_id;
		return ds_id;
	end if;
EXCEPTION
	WHEN OTHERS THEN 
		RETURN -2;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION interface_setting_update(character varying, interfacesetting) OWNER TO postgres;



----------------------------- interface customized info


INSERT INTO objtimestamp(
            typename, modifytime, userid)
    VALUES ( 'interface_customized_info', '1900-01-01 00:00:00', -1);
    

CREATE TABLE interface_customized_info
(
  id serial NOT NULL,
  objectid integer NOT NULL,
  attributeid integer NOT NULL,
  attribute_value character varying(256),
  lasttimestamp timestamp without time zone DEFAULT now(),
  CONSTRAINT interface_customized_info_pk PRIMARY KEY (id),
  CONSTRAINT interface_customized_info_attributeid_fk FOREIGN KEY (attributeid)
      REFERENCES object_customized_attribute (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT interface_customized_info_objectid_fk FOREIGN KEY (objectid)
      REFERENCES interfacesetting (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT interface_customized_info_un UNIQUE (objectid, attributeid)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE interface_customized_info OWNER TO postgres;


CREATE INDEX fki_interface_customized_info_attributeid_fk
  ON interface_customized_info
  USING btree
  (attributeid);


CREATE INDEX fki_interface_customized_info_info_objectid_fk
  ON interface_customized_info
  USING btree
  (objectid);


CREATE OR REPLACE FUNCTION process_interface_customized_info_dt()
  RETURNS trigger AS
$BODY$
		
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.objectid = NEW.objectid AND 			
			OLD.attributeid = NEW.attributeid AND 			
			OLD.attribute_value = NEW.attribute_value		
		 then
			return OLD;
		end IF;
		update objtimestamp set modifytime=now() where typename='interface_customized_info';
		NEW.lasttimestamp=now();	
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='interface_customized_info';
		NEW.lasttimestamp=now();
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='interface_customized_info';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION process_interface_customized_info_dt() OWNER TO postgres;



CREATE TRIGGER interface_customized_info_dt
  BEFORE INSERT OR UPDATE OR DELETE
  ON interface_customized_info
  FOR EACH ROW
  EXECUTE PROCEDURE process_interface_customized_info_dt();
  

CREATE OR REPLACE VIEW interface_customized_infoview AS 
 SELECT interface_customized_info.*,interfacesetting.interfacename, (select strname from devices where id=interfacesetting.deviceid) AS devicename
   FROM interface_customized_info, interfacesetting
  WHERE interface_customized_info.objectid = interfacesetting.id order by interface_customized_info.id;

ALTER TABLE interface_customized_infoview OWNER TO postgres;


CREATE OR REPLACE FUNCTION view_interface_customized_info_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying)
  RETURNS SETOF interface_customized_infoview AS
$BODY$
declare
	r interface_customized_infoview%rowtype;
	t timestamp without time zone;
BEGIN
	select modifytime into t from objtimestamp where typename=stypename;
	
	if t is null or t>dt then
		if imax <0 then
			for r in SELECT * FROM interface_customized_infoview where id>ibegin and lasttimestamp>dt loop
			return next r;
			end loop;
		else
			for r in SELECT * FROM interface_customized_infoview where id>ibegin and lasttimestamp>dt limit imax loop
			return next r;
			end loop;

		end if;	
	end if;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION view_interface_customized_info_retrieve(integer, integer, timestamp without time zone, character varying) OWNER TO postgres;



----------------------------------- module_property
INSERT INTO objtimestamp(
            typename, modifytime, userid)
    VALUES ( 'module_property', '1900-01-01 00:00:00', -1);


CREATE TABLE module_property
(
  id serial NOT NULL,
  deviceid integer NOT NULL,
  slot character varying(256),
  card_type character varying(256),
  ports character varying(256),
  serial_number character varying(256),
  hwrev character varying(256),
  rwrev character varying(256),
  swrev character varying(256),
  card_description character varying(256),
  lasttimestamp timestamp without time zone NOT NULL DEFAULT now(),
  "role" character varying(256),
  macaddress character varying(256),
  swversion character varying(256),
  swimage character varying(256),
  stackport1conn character varying(256),
  stackport2conn character varying(256),
  isswitch boolean NOT NULL DEFAULT false,
  CONSTRAINT module_property_pk PRIMARY KEY (id),
  CONSTRAINT module_property_fk FOREIGN KEY (deviceid)
      REFERENCES devices (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT module_property_un UNIQUE (deviceid, slot)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE module_property OWNER TO postgres;

CREATE INDEX fki_module_property_fk
  ON module_property
  USING btree
  (deviceid);



CREATE OR REPLACE FUNCTION process_module_property_dt()
  RETURNS trigger AS
$BODY$
		
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.deviceid = NEW.deviceid AND 			
			OLD.slot = NEW.slot AND 			
			OLD.card_type = NEW.card_type AND		
			OLD.ports = NEW.ports AND
			OLD.serial_number = NEW.serial_number AND
			OLD.hwrev = NEW.hwrev AND
			OLD.rwrev = NEW.rwrev AND
			OLD.swrev = NEW.swrev AND
			OLD.card_description=NEW.card_description AND
			OLD.role=NEW.role AND
			OLD.macaddress=NEW.macaddress AND
			OLD.swversion=NEW.swversion AND
			OLD.swimage=NEW.swimage AND
			OLD.stackport1conn=NEW.stackport1conn AND
			OLD.stackport2conn=NEW.stackport2conn AND
			OLD.isswitch=NEW.isswitch
		 then
			return OLD;
		end IF;

		IF 	OLD.card_type != NEW.card_type 
		then
			update interfacesetting set module_type=NEW.card_type,lasttimestamp=now() where deviceid=NEW.deviceid and module_slot=NEW.slot::int;
			update objtimestamp set modifytime=now() where typename='InterfaceSetting';			
		end IF;	
		
		update objtimestamp set modifytime=now() where typename='module_property';
		NEW.lasttimestamp=now();	
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='module_property';
		NEW.lasttimestamp=now();
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='module_property';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION process_module_property_dt() OWNER TO postgres;


CREATE TRIGGER module_property_dt
  BEFORE INSERT OR UPDATE OR DELETE
  ON module_property
  FOR EACH ROW
  EXECUTE PROCEDURE process_module_property_dt();  


CREATE OR REPLACE VIEW module_propertyview AS 
 SELECT module_property.*, devices.strname AS devicename
   FROM module_property, devices
  WHERE module_property.deviceid = devices.id order by module_property.id;

ALTER TABLE module_propertyview OWNER TO postgres;


  
CREATE OR REPLACE FUNCTION view_module_property_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying)
  RETURNS SETOF module_propertyview AS
$BODY$
declare
	r module_propertyview%rowtype;
	t timestamp without time zone;
BEGIN
	select modifytime into t from objtimestamp where typename=stypename;
	
	if t is null or t>dt then
		if imax <0 then
			for r in SELECT * FROM module_propertyview where id>ibegin and lasttimestamp>dt loop
			return next r;
			end loop;
		else
			for r in SELECT * FROM module_propertyview where id>ibegin and lasttimestamp>dt limit imax loop
			return next r;
			end loop;

		end if;	
	end if;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION view_module_property_retrieve(integer, integer, timestamp without time zone, character varying) OWNER TO postgres;



----------------------------------- module_customized_info

INSERT INTO objtimestamp(
            typename, modifytime, userid)
    VALUES ( 'module_customized_info', '1900-01-01 00:00:00', -1);
    

CREATE TABLE module_customized_info
(
  id serial NOT NULL,
  objectid integer NOT NULL,
  attributeid integer NOT NULL,
  attribute_value character varying(256),
  lasttimestamp timestamp without time zone DEFAULT now(),
  CONSTRAINT module_customized_info_pk PRIMARY KEY (id),
  CONSTRAINT module_customized_info_attributeid_fk FOREIGN KEY (attributeid)
      REFERENCES object_customized_attribute (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT module_customized_info_objectid_fk FOREIGN KEY (objectid)
      REFERENCES module_property (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT module_customized_info_un UNIQUE (objectid, attributeid)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE module_customized_info OWNER TO postgres;


CREATE INDEX fki_module_customized_info_attributeid_fk
  ON module_customized_info
  USING btree
  (attributeid);


CREATE INDEX fki_module_customized_info_objectid_fk
  ON module_customized_info
  USING btree
  (objectid);


CREATE OR REPLACE FUNCTION process_module_customized_info_dt()
  RETURNS trigger AS
$BODY$
		
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.objectid = NEW.objectid AND 			
			OLD.attributeid = NEW.attributeid AND 			
			OLD.attribute_value = NEW.attribute_value		
		 then
			return OLD;
		end IF;
		update objtimestamp set modifytime=now() where typename='module_customized_info';
		NEW.lasttimestamp=now();	
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='module_customized_info';
		NEW.lasttimestamp=now();
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='module_customized_info';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION process_module_customized_info_dt() OWNER TO postgres;



CREATE TRIGGER module_customized_info_dt
  BEFORE INSERT OR UPDATE OR DELETE
  ON module_customized_info
  FOR EACH ROW
  EXECUTE PROCEDURE process_module_customized_info_dt();
  

CREATE OR REPLACE VIEW module_customized_infoview AS 
 SELECT module_customized_info.*, module_propertyview.devicename,module_propertyview.slot
   FROM module_customized_info, module_propertyview
  WHERE module_customized_info.objectid = module_propertyview.id order by module_customized_info.id;

ALTER TABLE module_customized_infoview OWNER TO postgres;


CREATE OR REPLACE FUNCTION view_module_customized_info_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying)
  RETURNS SETOF module_customized_infoview AS
$BODY$
declare
	r module_customized_infoview%rowtype;
	t timestamp without time zone;
BEGIN
	select modifytime into t from objtimestamp where typename=stypename;
	
	if t is null or t>dt then
		if imax <0 then
			for r in SELECT * FROM module_customized_infoview where id>ibegin and lasttimestamp>dt loop
			return next r;
			end loop;
		else
			for r in SELECT * FROM module_customized_infoview where id>ibegin and lasttimestamp>dt limit imax loop
			return next r;
			end loop;

		end if;	
	end if;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION view_module_customized_info_retrieve(integer, integer, timestamp without time zone, character varying) OWNER TO postgres;


------------ nomp_snmpro
ALTER TABLE nomp_snmproinfo ADD COLUMN stralias character varying(255),
ADD CONSTRAINT nomp_snmpro_uniqalias UNIQUE(stralias);

ALTER TABLE nomp_snmproinfo ADD COLUMN authentication_method integer NOT NULL DEFAULT 0;
ALTER TABLE nomp_snmproinfo ALTER COLUMN authentication_method SET STORAGE PLAIN;

ALTER TABLE nomp_snmproinfo ADD COLUMN encryption_method integer NOT NULL DEFAULT 0;
ALTER TABLE nomp_snmproinfo ALTER COLUMN encryption_method SET STORAGE PLAIN;

ALTER TABLE nomp_snmproinfo ADD COLUMN authentication_mode integer NOT NULL DEFAULT 0;
ALTER TABLE nomp_snmproinfo ALTER COLUMN authentication_mode SET STORAGE PLAIN;

ALTER TABLE nomp_snmproinfo ADD COLUMN snmpv3_username character varying(256);
ALTER TABLE nomp_snmproinfo ALTER COLUMN snmpv3_username SET STORAGE EXTENDED;

ALTER TABLE nomp_snmproinfo ADD COLUMN snmpv3_authentication character varying(256);
ALTER TABLE nomp_snmproinfo ALTER COLUMN snmpv3_authentication SET STORAGE EXTENDED;

ALTER TABLE nomp_snmproinfo ADD COLUMN snmpv3_encryption character varying(256);
ALTER TABLE nomp_snmproinfo ALTER COLUMN snmpv3_encryption SET STORAGE EXTENDED;

ALTER TABLE nomp_snmproinfo ADD COLUMN "version" integer NOT NULL DEFAULT 1;
ALTER TABLE nomp_snmproinfo ALTER COLUMN "version" SET STORAGE PLAIN;
ALTER TABLE nomp_snmproinfo ALTER COLUMN "version" SET NOT NULL;
ALTER TABLE nomp_snmproinfo ALTER COLUMN "version" SET DEFAULT 1;

DROP TRIGGER nomp_snmproinfo_dt ON nomp_snmproinfo;
DROP FUNCTION process_nomp_snmproinfo_dt();

CREATE OR REPLACE FUNCTION process_nomp_snmproinfo_dt()
  RETURNS trigger AS
$BODY$

    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.strrostring = NEW.strrostring AND 			
			OLD.bmodified = NEW.bmodified AND			
			OLD.ipri = NEW.ipri AND
			OLD.stralias=NEW.stralias AND
			OLD.authentication_method=NEW.authentication_method AND
			OLD.encryption_method=NEW.encryption_method AND
			OLD.snmpv3_username=NEW.snmpv3_username AND
			OLD.snmpv3_authentication=NEW.snmpv3_authentication AND
			OLD.snmpv3_encryption=NEW.snmpv3_encryption AND
			OLD.version=NEW.version AND
			OLD.authentication_mode=NEW.authentication_mode			
		 then
			return OLD;
		end IF;
		update objtimestamp set modifytime=now() where typename='NetworkSetting';
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='NetworkSetting';
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='NetworkSetting';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION process_nomp_snmproinfo_dt() OWNER TO postgres;


CREATE TRIGGER nomp_snmproinfo_dt
  BEFORE INSERT OR UPDATE OR DELETE
  ON nomp_snmproinfo
  FOR EACH ROW
  EXECUTE PROCEDURE process_nomp_snmproinfo_dt();


DROP FUNCTION view_nomp_snmproinfo_retrieve(timestamp without time zone, character varying);
DROP VIEW nomp_snmproinfoview;


CREATE OR REPLACE VIEW nomp_snmproinfoview AS 
 SELECT nomp_snmproinfo.*, ( SELECT count(*) AS count
           FROM devicesetting
          WHERE devicesetting.snmpro = nomp_snmproinfo.strrostring) AS irefcount
   FROM nomp_snmproinfo
  ORDER BY nomp_snmproinfo.ipri;

ALTER TABLE nomp_snmproinfoview OWNER TO postgres;


CREATE OR REPLACE FUNCTION view_nomp_snmproinfo_retrieve(dt timestamp without time zone, stypename character varying)
  RETURNS SETOF nomp_snmproinfoview AS
$BODY$
declare
	r nomp_snmproinfoview%rowtype;
	t timestamp without time zone;
BEGIN		
        select modifytime into t from objtimestamp where typename=stypename;
	if t is null or t>dt then
		for r in SELECT * FROM nomp_snmproinfoview loop
		return next r;
		end loop;	
	End IF;
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION view_nomp_snmproinfo_retrieve(timestamp without time zone, character varying) OWNER TO postgres;
  

-----------------------devicesetting
ALTER TABLE devicesetting ADD COLUMN authentication_method integer NOT NULL DEFAULT 0;
ALTER TABLE devicesetting ALTER COLUMN authentication_method SET STORAGE PLAIN;
ALTER TABLE devicesetting ALTER COLUMN authentication_method SET NOT NULL;
ALTER TABLE devicesetting ALTER COLUMN authentication_method SET DEFAULT 0;

ALTER TABLE devicesetting ADD COLUMN encryption_method integer NOT NULL DEFAULT 0;
ALTER TABLE devicesetting ALTER COLUMN encryption_method SET STORAGE PLAIN;
ALTER TABLE devicesetting ALTER COLUMN encryption_method SET NOT NULL;
ALTER TABLE devicesetting ALTER COLUMN encryption_method SET DEFAULT 0;

ALTER TABLE devicesetting ADD COLUMN authentication_mode integer NOT NULL DEFAULT 0;
ALTER TABLE devicesetting ALTER COLUMN authentication_mode SET STORAGE PLAIN;
ALTER TABLE devicesetting ALTER COLUMN authentication_mode SET NOT NULL;
ALTER TABLE devicesetting ALTER COLUMN authentication_mode SET DEFAULT 0;

ALTER TABLE devicesetting ADD COLUMN snmpv3_username character varying(256);
ALTER TABLE devicesetting ALTER COLUMN snmpv3_username SET STORAGE EXTENDED;

ALTER TABLE devicesetting ADD COLUMN snmpv3_authentication character varying(256);
ALTER TABLE devicesetting ALTER COLUMN snmpv3_authentication SET STORAGE EXTENDED;

ALTER TABLE devicesetting ADD COLUMN snmpv3_encryption character varying(256);
ALTER TABLE devicesetting ALTER COLUMN snmpv3_encryption SET STORAGE EXTENDED;

ALTER TABLE devicesetting ADD COLUMN configfile_time timestamp without time zone;
ALTER TABLE devicesetting ALTER COLUMN configfile_time SET STORAGE PLAIN;
ALTER TABLE devicesetting ALTER COLUMN configfile_time SET DEFAULT now();


DROP TRIGGER devicesetting_dt ON devicesetting;

DROP FUNCTION process_devicessetting_dt();

update devicesetting  set configfile_time =now();

CREATE OR REPLACE FUNCTION process_devicessetting_dt()
  RETURNS trigger AS
$BODY$

    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.alias = NEW.alias AND 
			OLD.curversion = NEW.curversion AND
			OLD.usermodifiedflag = NEW.usermodifiedflag AND
			OLD.subtype = NEW.subtype AND 
			OLD.accessmethod = NEW.accessmethod AND
			OLD.accessability = NEW.accessability AND
			OLD.livestatuas = NEW.livestatuas AND 
			OLD.telnetproxyid = NEW.telnetproxyid AND
			OLD.snmpversion = NEW.snmpversion AND
			OLD.appliceid = NEW.appliceid AND
			OLD.smarttelnetmethod = NEW.smarttelnetmethod AND
			OLD.backtelnetmethod = NEW.backtelnetmethod AND 
			OLD.monitormethod = NEW.monitormethod AND
			OLD.telnetport = NEW.telnetport AND
			OLD.sshport = NEW.sshport AND
			OLD.manageip = NEW.manageip AND
			OLD.livehostname = NEW.livehostname AND 
			OLD.vendor = NEW.vendor AND
			OLD.model = NEW.model AND
			OLD.username = NEW.username AND
			OLD.userpassword = NEW.userpassword AND
			OLD.enablepassword = NEW.enablepassword AND 
			OLD.loginprompt = NEW.loginprompt AND
			OLD.passwordprompt = NEW.passwordprompt AND
			OLD.nonprivilegeprompt = NEW.nonprivilegeprompt AND
			OLD.privilegeprompt = NEW.privilegeprompt AND
			OLD.snmpro = NEW.snmpro AND 
			OLD.snmprw = NEW.snmprw AND
			OLD.keyword = NEW.keyword AND
			OLD.proxy = NEW.proxy AND
			OLD.devicemode = NEW.devicemode AND
			OLD.snmpport = NEW.snmpport AND
			OLD.serialnumber = NEW.serialnumber AND
			OLD.softwareversion = NEW.softwareversion AND
			OLD.contactor = NEW.contactor AND
			OLD.currentlocation = NEW.currentlocation AND
			OLD.keepitem1 = NEW.keepitem1 AND
			OLD.keepitem2 = NEW.keepitem2 AND
			OLD.keepitem3 = NEW.keepitem3 AND
			OLD.keepitem4 = NEW.keepitem4 AND
			OLD.keepitem5 = NEW.keepitem5 AND
			OLD.keepitem6 = NEW.keepitem6 AND
			OLD.keepitem7 = NEW.keepitem7 AND
			OLD.telnettooltype = NEW.telnettooltype AND
			OLD.telnettoolsession = NEW.telnettoolsession AND
			OLD.telnetcommandline= NEW.telnetcommandline AND
			OLD.cmdbserverid = NEW.cmdbserverid AND
			OLD.authentication_method=NEW.authentication_method AND
			OLD.encryption_method=NEW.encryption_method AND
			OLD.snmpv3_username=NEW.snmpv3_username AND
			OLD.snmpv3_authentication=NEW.snmpv3_authentication AND
			OLD.snmpv3_encryption=NEW.snmpv3_encryption AND
			OLD.authentication_mode=NEW.authentication_mode AND
			OLD.configfile_time=NEW.configfile_time
		 then
			return OLD;
		end IF;
		if OLD.configfile_time != NEW.configfile_time then
			update device_property set lasttimestamp=now() where deviceid=OLD.deviceid;
		end if;    
		NEW.lasttimestamp=now();
		update objtimestamp set modifytime=now() where typename='DeviceSetting';				
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='DeviceSetting' or typename='site';		
		NEW.configfile_time=now();
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='DeviceSetting' or typename='site';		
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION process_devicessetting_dt() OWNER TO postgres;


CREATE TRIGGER devicesetting_dt
  BEFORE INSERT OR UPDATE OR DELETE
  ON devicesetting
  FOR EACH ROW
  EXECUTE PROCEDURE process_devicessetting_dt();


DROP FUNCTION device_setting_update(character varying, devicesetting);

CREATE OR REPLACE FUNCTION device_setting_update(devname character varying, ds devicesetting)
  RETURNS integer AS
$BODY$
declare
	r_id integer;
	ds_id integer;
BEGIN
	select id into r_id from devices where strname=devname;
	if r_id IS NULL THEN
		return -1;
	end if;

	select id into ds_id from devicesetting where deviceid=r_id;
	if ds_id IS NULL THEN
		return -1;
	ELSE
		update devicesetting set ( 
			alias,
			curversion,
			usermodifiedflag,
			subtype,
			accessmethod,
			accessability,
			livestatuas,
			telnetproxyid,
			snmpversion,
			appliceid,
			smarttelnetmethod,
			backtelnetmethod,
			monitormethod,
			telnetport,
			sshport,
			manageip,
			livehostname,
			vendor,
			model,
			username,
			userpassword,
			enablepassword,
			loginprompt,
			passwordprompt,
			nonprivilegeprompt,
			privilegeprompt,
			snmpro,
			snmprw,
			keyword,
			proxy,
			devicemode,
			lasttimestamp,
			snmpport,
			serialnumber,
			softwareversion,
			contactor,
			currentlocation,
			keepitem1,
			keepitem2,
			keepitem3,
			keepitem4,
			keepitem5,
			keepitem6,
			keepitem7,
			telnettooltype,
			telnettoolsession,
			telnetcommandline,
			cmdbserverid,
			authentication_method,
			encryption_method,
			snmpv3_username,
			snmpv3_authentication,
			snmpv3_encryption,
			authentication_mode
			)
			=( 
			ds.alias,
			ds.curversion,
			ds.usermodifiedflag,
			ds.subtype,
			ds.accessmethod,
			ds.accessability,
			ds.livestatuas, 
			ds.telnetproxyid,
			ds.snmpversion, 
			ds.appliceid,   
			ds.smarttelnetmethod,
			ds.backtelnetmethod,
			ds.monitormethod,
			ds.telnetport,  
			ds.sshport,     
			ds.manageip,    
			ds.livehostname,
			ds.vendor,                
			ds.model,                 
			ds.username,              
			ds.userpassword,          
			ds.enablepassword,        
			ds.loginprompt,           
			ds.passwordprompt,        
			ds.nonprivilegeprompt,    
			ds.privilegeprompt,       
			ds.snmpro,                
			ds.snmprw,                
			ds.keyword,               
			ds.proxy,                 
			ds.devicemode,            
			now(),         
			ds.snmpport,              
			ds.serialnumber,          
			ds.softwareversion,       
			ds.contactor,             
			ds.currentlocation,       
			ds.keepitem1,             
			ds.keepitem2,             
			ds.keepitem3,             
			ds.keepitem4,             
			ds.keepitem5,             
			ds.keepitem6,             
			ds.keepitem7,             
			ds.telnettooltype,        
			ds.telnettoolsession,     
			ds.telnetcommandline,     
			ds.cmdbserverid,
			ds.authentication_method,
			ds.encryption_method,
			ds.snmpv3_username,
			ds.snmpv3_authentication,
			ds.snmpv3_encryption,
			ds.authentication_mode
			) 
			where id = ds_id;

		update device_property set vendor=ds.vendor, model=ds.model where deviceid=ds_id;	
		return ds_id;
	end if;
EXCEPTION
	WHEN OTHERS THEN 
		RETURN -2;
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION device_setting_update(character varying, devicesetting) OWNER TO postgres;


DROP FUNCTION device_setting_upsert(character varying, devicesetting);

CREATE OR REPLACE FUNCTION device_setting_upsert(devname character varying, ds devicesetting)
  RETURNS integer AS
$BODY$
declare
	r_id integer;
	ds_id integer;
BEGIN
	select id into r_id from devices where strname=devname;
	if r_id IS NULL THEN
		return -1;
	end if;

	select id into ds_id from devicesetting where deviceid=r_id;
	if ds_id IS NULL THEN
		insert into devicesetting(
			deviceid,
			alias,
			curversion,
			usermodifiedflag,
			subtype,
			accessmethod,
			accessability,
			livestatuas,
			telnetproxyid,
			snmpversion,
			appliceid,
			smarttelnetmethod,
			backtelnetmethod,
			monitormethod,
			telnetport,
			sshport,
			manageip,
			livehostname,
			vendor,
			model,
			username,
			userpassword,
			enablepassword,
			loginprompt,
			passwordprompt,
			nonprivilegeprompt,
			privilegeprompt,
			snmpro,
			snmprw,
			keyword,
			proxy,
			devicemode,
			lasttimestamp,
			snmpport,
			serialnumber,
			softwareversion,
			contactor,
			currentlocation,
			keepitem1,
			keepitem2,
			keepitem3,
			keepitem4,
			keepitem5,
			keepitem6,
			keepitem7,
			telnettooltype,
			telnettoolsession,
			telnetcommandline,
			cmdbserverid,
			authentication_method,
			encryption_method,
			snmpv3_username,
			snmpv3_authentication,
			snmpv3_encryption,
			authentication_mode,
			configfile_time
			)
			values ( 
			r_id,
			ds.alias,
			ds.curversion,
			ds.usermodifiedflag,
			ds.subtype,
			ds.accessmethod,
			ds.accessability,
			ds.livestatuas, 
			ds.telnetproxyid,
			ds.snmpversion, 
			ds.appliceid,   
			ds.smarttelnetmethod,
			ds.backtelnetmethod,
			ds.monitormethod,
			ds.telnetport,  
			ds.sshport,     
			ds.manageip,    
			ds.livehostname,
			ds.vendor,                
			ds.model,                 
			ds.username,              
			ds.userpassword,          
			ds.enablepassword,        
			ds.loginprompt,           
			ds.passwordprompt,        
			ds.nonprivilegeprompt,    
			ds.privilegeprompt,       
			ds.snmpro,                
			ds.snmprw,                
			ds.keyword,               
			ds.proxy,                 
			ds.devicemode,            
			now(),         
			ds.snmpport,              
			ds.serialnumber,          
			ds.softwareversion,       
			ds.contactor,             
			ds.currentlocation,       
			ds.keepitem1,             
			ds.keepitem2,             
			ds.keepitem3,             
			ds.keepitem4,             
			ds.keepitem5,             
			ds.keepitem6,             
			ds.keepitem7,             
			ds.telnettooltype,        
			ds.telnettoolsession,     
			ds.telnetcommandline,     
			ds.cmdbserverid,
			ds.authentication_method,
			ds.encryption_method,
			ds.snmpv3_username,
			ds.snmpv3_authentication,
			ds.snmpv3_encryption,
			ds.authentication_mode,		
			ds.configfile_time
		);

		return lastval();
	ELSE
		update devicesetting set ( 
			alias,
			curversion,
			usermodifiedflag,
			subtype,
			accessmethod,
			accessability,
			livestatuas,
			telnetproxyid,
			snmpversion,
			appliceid,
			smarttelnetmethod,
			backtelnetmethod,
			monitormethod,
			telnetport,
			sshport,
			manageip,
			livehostname,
			vendor,
			model,
			username,
			userpassword,
			enablepassword,
			loginprompt,
			passwordprompt,
			nonprivilegeprompt,
			privilegeprompt,
			snmpro,
			snmprw,
			keyword,
			proxy,
			devicemode,
			lasttimestamp,
			snmpport,
			serialnumber,
			softwareversion,
			contactor,
			currentlocation,
			keepitem1,
			keepitem2,
			keepitem3,
			keepitem4,
			keepitem5,
			keepitem6,
			keepitem7,
			telnettooltype,
			telnettoolsession,
			telnetcommandline,
			cmdbserverid,
			authentication_method,
			encryption_method,
			snmpv3_username,
			snmpv3_authentication,
			snmpv3_encryption,
			authentication_mode
			)
			=( 
			ds.alias,
			ds.curversion,
			ds.usermodifiedflag,
			ds.subtype,
			ds.accessmethod,
			ds.accessability,
			ds.livestatuas, 
			ds.telnetproxyid,
			ds.snmpversion, 
			ds.appliceid,   
			ds.smarttelnetmethod,
			ds.backtelnetmethod,
			ds.monitormethod,
			ds.telnetport,  
			ds.sshport,     
			ds.manageip,    
			ds.livehostname,
			ds.vendor,                
			ds.model,                 
			ds.username,              
			ds.userpassword,          
			ds.enablepassword,        
			ds.loginprompt,           
			ds.passwordprompt,        
			ds.nonprivilegeprompt,    
			ds.privilegeprompt,       
			ds.snmpro,                
			ds.snmprw,                
			ds.keyword,               
			ds.proxy,                 
			ds.devicemode,            
			now(),         
			ds.snmpport,              
			ds.serialnumber,          
			ds.softwareversion,       
			ds.contactor,             
			ds.currentlocation,       
			ds.keepitem1,             
			ds.keepitem2,             
			ds.keepitem3,             
			ds.keepitem4,             
			ds.keepitem5,             
			ds.keepitem6,             
			ds.keepitem7,             
			ds.telnettooltype,        
			ds.telnettoolsession,     
			ds.telnetcommandline,     
			ds.cmdbserverid,
			ds.authentication_method,
			ds.encryption_method,
			ds.snmpv3_username,
			ds.snmpv3_authentication,
			ds.snmpv3_encryption,
			ds.authentication_mode
			) 
			where id = ds_id;
		return ds_id;
	end if;
EXCEPTION
	WHEN OTHERS THEN 
		RETURN -2;
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION device_setting_upsert(character varying, devicesetting) OWNER TO postgres;



--------------------------------site
INSERT INTO objtimestamp(
            typename, modifytime, userid)
    VALUES ( 'site', '1900-01-01 00:00:00', -1);

-- Table: site

-- DROP TABLE site;

CREATE TABLE site
(
  id serial NOT NULL,
  "name" character varying(64),
  region character varying(256),
  location_address character varying(256),
  employee_number integer,
  contact_name character varying(256),
  phone_number character varying(256),
  email character varying(256),
  "type" character varying(64),
  color integer,
  "comment" character varying(256),
  lasttimestamp timestamp without time zone NOT NULL DEFAULT now(),
  CONSTRAINT site_pk_id PRIMARY KEY (id),
  CONSTRAINT site_uniq_name UNIQUE (name)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE site OWNER TO postgres;

CREATE OR REPLACE FUNCTION process_site_dt()
  RETURNS trigger AS
$BODY$
		
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.id = NEW.id AND 			
			OLD.name = NEW.name AND 			
			OLD.region = NEW.region AND 						
			OLD.location_address = NEW.location_address AND
			OLD.employee_number = NEW.employee_number AND
			OLD.contact_name = NEW.contact_name AND
			OLD.phone_number = NEW.phone_number AND
			OLD.email = NEW.email AND
			OLD.type = NEW.type AND
			OLD.color = NEW.color AND
			OLD.comment = NEW.comment 			
		 then
			return OLD;
		end IF;
		update objtimestamp set modifytime=now() where typename='site';
		NEW.lasttimestamp=now();	
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='site';
		NEW.lasttimestamp=now();
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='site';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;
ALTER FUNCTION process_site_dt() OWNER TO postgres;

CREATE TRIGGER site_dt
  BEFORE INSERT OR UPDATE OR DELETE
  ON site
  FOR EACH ROW
  EXECUTE PROCEDURE process_site_dt();


INSERT INTO site("name", region, location_address, employee_number, contact_name,phone_number, email, "type", color, "comment", lasttimestamp) VALUES ( 'Entire Network', '','',0,'','','','', 0, '', now());

--------------------------------site2site

CREATE TABLE site2site
(
  id serial NOT NULL,
  siteid integer,
  parentid integer,
  CONSTRAINT site2site_pk_id PRIMARY KEY (id),
  CONSTRAINT site2site_fk_site FOREIGN KEY (siteid)
      REFERENCES site (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT site2site_uniq_siteid UNIQUE (siteid)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE site2site OWNER TO postgres;

--------------------------------devicesitedevice

CREATE TABLE devicesitedevice
(
  id serial NOT NULL,
  siteid integer,
  deviceid integer,
  CONSTRAINT devicesitedevice_fk_device FOREIGN KEY (deviceid)
      REFERENCES devices (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT devicesitedevice_fk_siteid FOREIGN KEY (siteid)
      REFERENCES site (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT devicesitedevice_uniq_deviceid UNIQUE (deviceid)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE devicesitedevice OWNER TO postgres;


-- View: siteview

-- DROP VIEW siteview;
CREATE OR REPLACE VIEW siteview AS 
 SELECT site.id, site2site.parentid, site.name, site.region, site.location_address, site.employee_number, site.contact_name, site.phone_number, site.email, site.type, site.color, site.comment, site.lasttimestamp, ( SELECT count(*) AS count
           FROM devicesitedevice
          WHERE devicesitedevice.siteid = site.id) AS irefcount
   FROM site2site, site
  WHERE site2site.siteid = site.id;

ALTER TABLE siteview OWNER TO postgres;

CREATE OR REPLACE FUNCTION view_site_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying)
  RETURNS SETOF siteview AS
$BODY$
declare
	r siteview%rowtype;
	t timestamp without time zone;
BEGIN
	select modifytime into t from objtimestamp where typename=stypename;
	
	if t is null or t>dt then
		if imax <0 then
			for r in SELECT * FROM siteview where id>ibegin order by id loop
			return next r;
			end loop;
		else
			for r in SELECT * FROM siteview where id>ibegin order by id limit imax loop
			return next r;
			end loop;

		end if;	
	end if;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE;
ALTER FUNCTION view_site_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) OWNER TO postgres;

CREATE OR REPLACE FUNCTION process_site2site_dt()
  RETURNS trigger AS
$BODY$
		
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.id = NEW.id AND 			
			OLD.siteid = NEW.siteid AND 			
			OLD.parentid = NEW.parentid 			
		 then
			return OLD;
		end IF;
		update objtimestamp set modifytime=now() where typename='site';
		update site set lasttimestamp=now() where id=NEW.siteid;
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='site';
		update site set lasttimestamp=now() where id=NEW.siteid;
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='site';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION process_site2site_dt() OWNER TO postgres;

CREATE TRIGGER site2site_dt
  BEFORE INSERT OR UPDATE OR DELETE
  ON site2site
  FOR EACH ROW
  EXECUTE PROCEDURE process_site2site_dt();

INSERT INTO site2site(siteid, parentid) VALUES ( 1, 0);


CREATE OR REPLACE FUNCTION device_site_set(nsiteid integer,ndeviceid integer)
  RETURNS integer AS
$BODY$

BEGIN
	if (select count(*) from devicesitedevice where deviceid =ndeviceid)<1 then
		INSERT INTO devicesitedevice(siteid, deviceid)VALUES (nsiteid, ndeviceid);
	end if;
	update devicesitedevice set siteid=nsiteid where deviceid =ndeviceid;
	update site set lasttimestamp=now() where id=nsiteid;
	update objtimestamp set modifytime=now() where typename='site';
	return 1;
EXCEPTION
	WHEN OTHERS THEN 
		RETURN -1;
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION device_site_set(nsiteid integer,ndeviceid integer) OWNER TO postgres;

-- Function: device_site_move(integer, integer)

-- DROP FUNCTION device_site_move(integer, integer);

CREATE OR REPLACE FUNCTION device_site_move(nsiteidfrom integer, nsiteidto integer)
  RETURNS integer AS
$BODY$

BEGIN
	update devicesitedevice set siteid=nsiteidto where siteid =nsiteidfrom;
	update site set lasttimestamp=now() where id=nsiteidto;
	update objtimestamp set modifytime=now() where typename='site';
	return 1;
EXCEPTION
	WHEN OTHERS THEN 
		RETURN -1;
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION device_site_move(integer, integer) OWNER TO postgres;

-- Function: site_remove(integer)

-- DROP FUNCTION site_remove(integer);

CREATE OR REPLACE FUNCTION site_remove(nsiteid integer)
  RETURNS integer AS
$BODY$

BEGIN
	delete from site2site where siteid=nsiteid;
	delete from site_customized_info where objectid=nsiteid;
	delete from site where id=nsiteid;		
	update objtimestamp set modifytime=now() where typename='site';
	return 1;
EXCEPTION
	WHEN OTHERS THEN 
		RETURN -1;
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION site_remove(integer) OWNER TO postgres;

--------------------------------site_customized_info
INSERT INTO objtimestamp(
            typename, modifytime, userid)
    VALUES ( 'site_customized_info', '1900-01-01 00:00:00', -1);

CREATE TABLE site_customized_info
(
  id serial NOT NULL,
  objectid integer NOT NULL,
  attributeid integer NOT NULL,
  attribute_value character varying(256),
  lasttimestamp timestamp without time zone DEFAULT now(),
  CONSTRAINT "sitecustomizedinfo_pk_Id" PRIMARY KEY (id),
  CONSTRAINT sitecustomizedinfo_fk_att FOREIGN KEY (attributeid)
      REFERENCES object_customized_attribute (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT sitecustomizedinfo_fk_siteid FOREIGN KEY (objectid)
      REFERENCES site (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT sitecustomizeinfo_uniq UNIQUE (objectid, attributeid)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE site_customized_info OWNER TO postgres;


CREATE OR REPLACE FUNCTION process_site_customized_info_dt()
  RETURNS trigger AS
$BODY$
		
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.objectid = NEW.objectid AND 			
			OLD.attributeid = NEW.attributeid AND 			
			OLD.attribute_value = NEW.attribute_value		
		 then
			return OLD;
		end IF;
		update objtimestamp set modifytime=now() where typename='site_customized_info';
		NEW.lasttimestamp=now();	
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='site_customized_info';
		NEW.lasttimestamp=now();
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='site_customized_info';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION process_site_customized_info_dt() OWNER TO postgres;

CREATE TRIGGER site_customized_info_dt
  BEFORE INSERT OR UPDATE OR DELETE
  ON site_customized_info
  FOR EACH ROW
  EXECUTE PROCEDURE process_site_customized_info_dt();

CREATE OR REPLACE VIEW site_customized_infoview AS 
 SELECT site_customized_info.id, site_customized_info.objectid, site_customized_info.attributeid, site_customized_info.attribute_value, site_customized_info.lasttimestamp, site."name" AS sitename
   FROM site_customized_info, site
  WHERE site_customized_info.objectid = site.id;

ALTER TABLE site_customized_infoview OWNER TO postgres;

CREATE OR REPLACE FUNCTION view_site_customized_info_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying)
  RETURNS SETOF site_customized_infoview AS
$BODY$
declare
	r site_customized_infoview%rowtype;
	t timestamp without time zone;
BEGIN
	select modifytime into t from objtimestamp where typename=stypename;
	
	if t is null or t>dt then
		if imax <0 then
			for r in SELECT * FROM site_customized_infoview where id>ibegin and lasttimestamp>dt order by id loop
			return next r;
			end loop;
		else
			for r in SELECT * FROM site_customized_infoview where id>ibegin and lasttimestamp>dt order by id limit imax loop
			return next r;
			end loop;

		end if;	
	end if;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION view_site_customized_info_retrieve(integer, integer, timestamp without time zone, character varying) OWNER TO postgres;

CREATE OR REPLACE VIEW devicesitedeviceview AS 
         SELECT devicesitedevice.siteid, devicesitedevice.deviceid, 1 AS id, ( SELECT devices.strname
                   FROM devices
                  WHERE devices.id = devicesitedevice.deviceid) AS devicename, ( SELECT site.name
                   FROM site
                  WHERE site.id = devicesitedevice.siteid) AS sitename, ( SELECT devices.isubtype
                   FROM devices
                  WHERE devices.id = devicesitedevice.deviceid) AS isubtype
           FROM devicesitedevice
UNION ALL 
         SELECT 1 AS siteid, devices.id AS deviceid, 1 AS id, devices.strname AS devicename, ( SELECT site.name
                   FROM site
                  WHERE site.id = 1) AS sitename, devices.isubtype
           FROM devices
          WHERE NOT (devices.id IN ( SELECT devicesitedevice.deviceid
                   FROM devicesitedevice));

ALTER TABLE devicesitedeviceview OWNER TO postgres;


-- Function: view_devicesitedeviceview_retrieve(integer, integer, timestamp without time zone, integer, character varying)

-- DROP FUNCTION view_devicesitedeviceview_retrieve(integer, integer, timestamp without time zone, integer, character varying);

CREATE OR REPLACE FUNCTION view_devicesitedeviceview_retrieve(ibegin integer, imax integer, dt timestamp without time zone,stypename character varying)
  RETURNS SETOF devicesitedeviceview AS
$BODY$
declare
	r devicesitedeviceview%rowtype;
	t timestamp without time zone;
BEGIN
		
	if t is null or t>dt then
		if imax <0 then
			for r in select * from devicesitedeviceview where siteid in (SELECT id FROM site where id>ibegin order by id) order by siteid loop
			return next r;
			end loop;
		else
			for r in select * from devicesitedeviceview where siteid in (SELECT id FROM site where id>ibegin order by id limit imax) order by siteid loop			
			return next r;
			end loop;

		end if;	
	end if;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION view_devicesitedeviceview_retrieve(integer, integer, timestamp without time zone, character varying) OWNER TO postgres;

--------------------------------devicegroup

ALTER TABLE devicegroup ADD COLUMN searchcondition text;

ALTER TABLE devicegroup ADD COLUMN Searchcontainer integer;

ALTER TABLE devicegroupdevice ADD COLUMN "type" integer NOT NULL DEFAULT 1;

COMMENT ON COLUMN devicegroupdevice."type" IS '1 static 2 dynamic';


-- Table: devicegroupdevicegroup


CREATE TABLE devicegroupdevicegroup
(
  id serial NOT NULL,
  groupid integer,
  groupidbelone integer,
  CONSTRAINT devicegroupdevicegroup_pk_id PRIMARY KEY (id),
  CONSTRAINT devicegroupdevicegroup_fk_group FOREIGN KEY (groupid)
      REFERENCES devicegroup (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT devicegroupdevicegroup_fk_groupbelone FOREIGN KEY (groupidbelone)
      REFERENCES devicegroup (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
ALTER TABLE devicegroupdevicegroup OWNER TO postgres;

-- Table: devicegroupsite

-- DROP TABLE devicegroupsite;

CREATE TABLE devicegroupsite
(
  id serial NOT NULL,
  groupid integer,
  siteid integer,
  CONSTRAINT devicegroupsite_pk_id PRIMARY KEY (id),
  CONSTRAINT devicegroupsite_fk_group FOREIGN KEY (groupid)
      REFERENCES devicegroup (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT devicegroupsite_fk_site FOREIGN KEY (siteid)
      REFERENCES site (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,    
  CONSTRAINT devicegroupsite_uniq_groupid UNIQUE (groupid)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE devicegroupsite OWNER TO postgres;


CREATE OR REPLACE VIEW devicegroupdevicegroupview AS 
 SELECT id, devicegroupdevicegroup.groupid AS devicegroupid,
	( SELECT devicegroup.strname FROM devicegroup WHERE devicegroup.id = devicegroupdevicegroup.groupid) AS devicegroupname, 
        devicegroupdevicegroup.groupidbelone AS devicegroupdevicegroupid, 
        ( SELECT devicegroup.strname FROM devicegroup WHERE devicegroup.id = devicegroupdevicegroup.groupidbelone) AS devicegroupdevicegroupname 
    FROM devicegroupdevicegroup;

ALTER TABLE devicegroupdevicegroupview OWNER TO postgres;


CREATE OR REPLACE VIEW devicegroupsiteview AS 
 SELECT id, devicegroupsite.groupid AS devicegroupid,
	( SELECT devicegroup.strname FROM devicegroup WHERE devicegroup.id = devicegroupsite.groupid) AS devicegroupname, 
        devicegroupsite.siteid AS devicegroupsiteid, 
        ( SELECT site.name FROM site WHERE site.id = devicegroupsite.siteid) AS devicegroupsitename 
    FROM devicegroupsite;


ALTER TABLE devicegroupsiteview OWNER TO postgres;

-- Function: view_devicegroupdevicegroupview_retrieve(integer, integer, timestamp without time zone, integer, character varying)

-- DROP FUNCTION view_devicegroupdevicegroupview_retrieve(integer, integer, timestamp without time zone, integer, character varying);

CREATE OR REPLACE FUNCTION view_devicegroupdevicegroupview_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer, stypename character varying)
  RETURNS SETOF devicegroupdevicegroupview AS
$BODY$
declare
	r devicegroupdevicegroupview%rowtype;
	t timestamp without time zone;
BEGIN
	if uid=-1 then
		select modifytime into t from objtimestamp where typename=stypename;
	else
		select modifytime into t from objtimestamp where typename=stypename and userid=uid;
	end if;
	
	if t is null or t>dt then
		if imax <0 then
			for r in select * from devicegroupdevicegroupview where devicegroupid in (SELECT id FROM devicegroup where id>ibegin and userid=uid order by id) order by devicegroupid loop
			return next r;
			end loop;
		else
			for r in select * from devicegroupdevicegroupview where devicegroupid in (SELECT id FROM devicegroup where id>ibegin and userid=uid order by id limit imax) order by devicegroupid loop			
			return next r;
			end loop;

		end if;	
	end if;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION view_devicegroupdevicegroupview_retrieve(integer, integer, timestamp without time zone, integer, character varying) OWNER TO postgres;

-- Function: view_devicegroupsiteview_retrieve(integer, integer, timestamp without time zone, integer, character varying)

-- DROP FUNCTION view_devicegroupsiteview_retrieve(integer, integer, timestamp without time zone, integer, character varying);

CREATE OR REPLACE FUNCTION view_devicegroupsiteview_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer, stypename character varying)
  RETURNS SETOF devicegroupsiteview AS
$BODY$
declare
	r devicegroupsiteview%rowtype;
	t timestamp without time zone;
BEGIN
	if uid=-1 then
		select modifytime into t from objtimestamp where typename=stypename;
	else
		select modifytime into t from objtimestamp where typename=stypename and userid=uid;
	end if;
	
	if t is null or t>dt then
		if imax <0 then
			for r in select * from devicegroupsiteview where devicegroupid in (SELECT id FROM devicegroup where id>ibegin and userid=uid order by id) order by devicegroupid loop
			return next r;
			end loop;
		else
			for r in select * from devicegroupsiteview where devicegroupid in (SELECT id FROM devicegroup where id>ibegin and userid=uid order by id limit imax) order by devicegroupid loop			
			return next r;
			end loop;

		end if;	
	end if;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION view_devicegroupsiteview_retrieve(integer, integer, timestamp without time zone, integer, character varying) OWNER TO postgres;

--------------------------------linkgroup
INSERT INTO objtimestamp(
            typename, modifytime, userid)
    VALUES ( 'PublicLinkGroup', '1900-01-01 00:00:00', -1);
CREATE TABLE linkgroup
(
  id serial NOT NULL,
  strname character varying(64),
  strdesc character varying(256),
  showcolor integer,
  showstyle integer,
  showwidth integer,
  userid integer NOT NULL DEFAULT (-1),
  searchcondition text,
  searchcontainer integer,
  CONSTRAINT linkgroup_pk_id PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE linkgroup OWNER TO postgres;


CREATE TABLE linkgroupdevicegroup
(
  id serial NOT NULL,
  groupid integer,
  groupidbelone integer,
  CONSTRAINT linkgroupdevicegroup_pk_id PRIMARY KEY (id),
  CONSTRAINT linkgroupdevicegroup_fk_group FOREIGN KEY (groupid)
      REFERENCES linkgroup (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT linkgroupdevicegroupbelone_fk_group FOREIGN KEY (groupidbelone)
      REFERENCES devicegroup (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
ALTER TABLE linkgroupdevicegroup OWNER TO postgres;

-- Table: linkgrouplinkgroup

-- DROP TABLE linkgrouplinkgroup;

CREATE TABLE linkgrouplinkgroup
(
  id serial NOT NULL,
  groupid integer,
  groupidbelone integer,
  CONSTRAINT linkgrouplinkgroup_pk_id PRIMARY KEY (id),
  CONSTRAINT linkgrouplinkgroup_fk_group FOREIGN KEY (groupid)
      REFERENCES linkgroup (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT linkgrouplinkgroupbelone_fk_group FOREIGN KEY (groupidbelone)
      REFERENCES linkgroup (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
ALTER TABLE linkgrouplinkgroup OWNER TO postgres;

-- Table: linkgroupsite

-- DROP TABLE linkgroupsite;

CREATE TABLE linkgroupsite
(
  id serial NOT NULL,
  groupid integer,
  siteid integer,
  CONSTRAINT linkgroupsite_pk_id PRIMARY KEY (id),
  CONSTRAINT linkgroupsite_fk_group FOREIGN KEY (groupid)
      REFERENCES linkgroup (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT linkgroupsite_fk_site FOREIGN KEY (siteid)
      REFERENCES site (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE    
)
WITH (
  OIDS=FALSE
);
ALTER TABLE linkgroupsite OWNER TO postgres;

CREATE TABLE linkgroupinterface
(
  id serial NOT NULL,
  groupid integer NOT NULL,
  interfaceid integer NOT NULL,
  "type" integer NOT NULL,
  interfaceip character varying(255),
  CONSTRAINT linkgroupinterface_pk_id PRIMARY KEY (id),
  CONSTRAINT linkgroupinterface_fk_interface FOREIGN KEY (interfaceid)
      REFERENCES interfacesetting (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT linkgroupinterface_fk_linkgroup FOREIGN KEY (groupid)
      REFERENCES linkgroup (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT linkgroupinterface_uniq_git UNIQUE (groupid, type, interfaceid, interfaceip)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE linkgroupinterface OWNER TO postgres;
COMMENT ON COLUMN linkgroupinterface."type" IS '1 static 2 dynamic';

CREATE OR REPLACE VIEW linkgroupview AS 
SELECT linkgroup.id, linkgroup.strname, linkgroup.strdesc, linkgroup.showcolor, linkgroup.showstyle, linkgroup.showwidth, linkgroup.searchcondition,linkgroup.userid, ( SELECT count(*) AS count
           FROM linkgroupinterface
          WHERE linkgroupinterface.groupid = linkgroup.id) AS irefcount
  FROM linkgroup;

ALTER TABLE linkgroupview OWNER TO postgres;

CREATE OR REPLACE VIEW linkgrouplinkgroupview AS 
 SELECT linkgroup.id, linkgrouplinkgroup.groupidbelone,(select strname from linkgroup where id=linkgrouplinkgroup.groupidbelone) as linkgroupname 
   FROM linkgroup, linkgrouplinkgroup
  WHERE linkgrouplinkgroup.groupid = linkgroup.id;

ALTER TABLE linkgrouplinkgroupview OWNER TO postgres;

CREATE OR REPLACE VIEW linkgroupdevicegroupview AS 
 SELECT linkgroup.id, linkgroupdevicegroup.groupidbelone,(select strname from devicegroup where id=linkgroupdevicegroup.groupidbelone) as devicegroupname 
   FROM linkgroup, linkgroupdevicegroup
  WHERE linkgroupdevicegroup.groupid = linkgroup.id;

ALTER TABLE linkgroupdevicegroupview OWNER TO postgres;

CREATE OR REPLACE VIEW linkgroupsiteview AS 
 SELECT linkgroup.id, linkgroupsite.siteid,(select "name" from site where id=linkgroupsite.siteid) as sitename 
   FROM linkgroup, linkgroupsite
  WHERE linkgroupsite.siteid = linkgroup.id;

ALTER TABLE linkgroupsiteview OWNER TO postgres;


CREATE OR REPLACE FUNCTION view_linkgroup_retrieve(ibegin integer, imax integer, dt timestamp without time zone,uid integer, stypename character varying)
  RETURNS SETOF linkgroupview AS
$BODY$
declare
	r linkgroupview%rowtype;
	t timestamp without time zone;
BEGIN	
	if uid=-1 then
		select modifytime into t from objtimestamp where typename=stypename;
	else
		select modifytime into t from objtimestamp where typename=stypename and userid=uid;
	end if;
	if t is null or t>dt then
		if imax <0 then
			for r in SELECT * FROM linkgroupview where id>ibegin and userid=uid loop
			return next r;
			end loop;
		else
			for r in SELECT * FROM linkgroupview where id>ibegin and userid=uid limit imax loop
			return next r;
			end loop;

		end if;	
	end if;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION view_linkgroup_retrieve(integer, integer, timestamp without time zone,uid integer, character varying) OWNER TO postgres;

CREATE OR REPLACE FUNCTION view_linkgrouplinkgroupview_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer, stypename character varying)
  RETURNS SETOF linkgrouplinkgroupview AS
$BODY$
declare
	r linkgrouplinkgroupview%rowtype;
	t timestamp without time zone;
BEGIN	
	if uid=-1 then
		select modifytime into t from objtimestamp where typename=stypename;
	else
		select modifytime into t from objtimestamp where typename=stypename and userid=uid;
	end if;

	if t is null or t>dt then
		if imax <0 then
			for r in select * from linkgrouplinkgroupview where id in (SELECT id FROM linkgroup where id>ibegin and userid=uid order by id) order by id loop
			return next r;
			end loop;
		else
			for r in select * from linkgrouplinkgroupview where id in (SELECT id FROM linkgroup where id>ibegin and userid=uid order by id limit imax) order by id loop			
			return next r;
			end loop;

		end if;	
	end if;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION view_linkgrouplinkgroupview_retrieve(integer, integer, timestamp without time zone, integer, character varying) OWNER TO postgres;


CREATE OR REPLACE FUNCTION view_linkgroupdevicegroupview_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer, stypename character varying)
  RETURNS SETOF linkgroupdevicegroupview AS
$BODY$
declare
	r linkgroupdevicegroupview%rowtype;
	t timestamp without time zone;
BEGIN	
	if uid=-1 then
		select modifytime into t from objtimestamp where typename=stypename;
	else
		select modifytime into t from objtimestamp where typename=stypename and userid=uid;
	end if;
	
	if t is null or t>dt then
		if imax <0 then
			for r in select * from linkgroupdevicegroupview where id in (SELECT id FROM linkgroup where id>ibegin and userid=uid order by id) order by id loop
			return next r;
			end loop;
		else
			for r in select * from linkgroupdevicegroupview where id in (SELECT id FROM linkgroup where id>ibegin and userid=uid order by id limit imax) order by id loop			
			return next r;
			end loop;

		end if;	
	end if;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION view_linkgroupdevicegroupview_retrieve(integer, integer, timestamp without time zone, integer, character varying) OWNER TO postgres;


CREATE OR REPLACE FUNCTION view_linkgroupsiteview_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer, stypename character varying)
  RETURNS SETOF linkgroupsiteview AS
$BODY$
declare
	r linkgroupsiteview%rowtype;
	t timestamp without time zone;
BEGIN	
	if uid=-1 then
		select modifytime into t from objtimestamp where typename=stypename;
	else
		select modifytime into t from objtimestamp where typename=stypename and userid=uid;
	end if;
	
	if t is null or t>dt then
		if imax <0 then
			for r in select * from linkgroupsiteview where id in (SELECT id FROM linkgroup where id>ibegin and userid=uid order by id) order by id loop
			return next r;
			end loop;
		else
			for r in select * from linkgroupsiteview where id in (SELECT id FROM linkgroup where id>ibegin and userid=uid order by id limit imax) order by id loop			
			return next r;
			end loop;

		end if;	
	end if;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION view_linkgroupsiteview_retrieve(integer, integer, timestamp without time zone, integer, character varying) OWNER TO postgres;

CREATE OR REPLACE VIEW linkgroupinterfaceview AS 
 SELECT linkgroupinterface.id, linkgroupinterface.groupid, linkgroupinterface.interfaceid, linkgroupinterface.interfaceip, linkgroupinterface.type, ( SELECT interfacesetting.interfacename
           FROM interfacesetting
          WHERE interfacesetting.id = linkgroupinterface.interfaceid) AS interfacename, ( SELECT interfacesetting.deviceid
           FROM interfacesetting
          WHERE interfacesetting.id = linkgroupinterface.interfaceid) AS deviceid, ( SELECT devices.strname
           FROM devices
          WHERE devices.id = (( SELECT interfacesetting.deviceid
                   FROM interfacesetting
                  WHERE interfacesetting.id = linkgroupinterface.interfaceid))) AS devicename, ( SELECT devices.isubtype
           FROM devices
          WHERE devices.id = (( SELECT interfacesetting.deviceid
                   FROM interfacesetting
                  WHERE interfacesetting.id = linkgroupinterface.interfaceid))) AS isubtype
   FROM linkgroupinterface;

ALTER TABLE linkgroupinterfaceview OWNER TO postgres;


CREATE OR REPLACE FUNCTION view_linkgroupinterfaceview_retrieve(ibegin integer, imax integer, dt timestamp without time zone,uid integer, stypename character varying)
  RETURNS SETOF linkgroupinterfaceview AS
$BODY$
declare
	r linkgroupinterfaceview%rowtype;
	t timestamp without time zone;
BEGIN
	if uid=-1 then
		select modifytime into t from objtimestamp where typename=stypename;
	else
		select modifytime into t from objtimestamp where typename=stypename and userid=uid;
	end if;
		
	if t is null or t>dt then
		if imax <0 then
			for r in select * from linkgroupinterfaceview where groupid in (SELECT id FROM linkgroup where id>ibegin and userid=uid order by id) order by groupid loop
			return next r;
			end loop;
		else
			for r in select * from linkgroupinterfaceview where groupid in (SELECT id FROM linkgroup where id>ibegin and userid=uid order by id limit imax) order by groupid loop			
			return next r;
			end loop;

		end if;	
	end if;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION view_linkgroupinterfaceview_retrieve(integer, integer, timestamp without time zone,uid integer, character varying) OWNER TO postgres;


-----------------------object_file_info

CREATE TABLE object_file_info
(
  id serial NOT NULL ,
  object_id integer NOT NULL,
  object_type integer NOT NULL, -- 0-site,1-devicegroup,2-linkgroup
  file_type integer NOT NULL, -- 0-map,1-extend doc
  file_real_name character varying(200),
  file_save_name character varying(200) NOT NULL,
  file_update_time timestamp without time zone NOT NULL,
  file_update_userid integer NOT NULL,
  user_property text,
  lasttimestamp timestamp without time zone NOT NULL,
  path_id integer,
  CONSTRAINT file_info_pk PRIMARY KEY (id),
  CONSTRAINT file_info_fk FOREIGN KEY (file_update_userid)
      REFERENCES "user" (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE DEFERRABLE INITIALLY IMMEDIATE,
  CONSTRAINT file_info_uk UNIQUE (object_id, object_type, file_type, file_real_name,path_id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE object_file_info OWNER TO postgres;
COMMENT ON COLUMN object_file_info.object_type IS '0-site,1-devicegroup,2-linkgroup';
COMMENT ON COLUMN object_file_info.file_type IS '0-map,1-extend doc';


CREATE INDEX fki_file_info_fk
  ON object_file_info
  USING btree
  (file_update_userid);
  
CREATE OR REPLACE FUNCTION object_file_info_insert(ofile object_file_info)
  RETURNS integer AS
$BODY$
BEGIN	
		insert into object_file_info(
			  object_id,
			  object_type,
			  file_type,
			  file_real_name,
			  file_save_name,
			  file_update_time,
			  file_update_userid,
			  user_property,
			  lasttimestamp,
			  path_id
			  )
			  values( 			  
			  ofile.object_id,
			  ofile.object_type,
			  ofile.file_type,
			  ofile.file_real_name,
			  ofile.file_save_name,
			  now(),
			  ofile.file_update_userid,
			  ofile.user_property,
			  now(),
			  ofile.path_id
			  );
			  return lastval();	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION object_file_info_insert(object_file_info) OWNER TO postgres;


CREATE OR REPLACE FUNCTION object_file_info_update(ofile object_file_info)
  RETURNS integer AS
$BODY$
BEGIN	
		update object_file_info set ( 
			object_id,
			object_type,
			file_type,
			file_real_name,
			file_save_name,
			file_update_userid,
			user_property,
			lasttimestamp,
			path_id)
			=( 
			ofile.object_id,
			ofile.object_type,
			ofile.file_type,
			ofile.file_real_name,
			ofile.file_save_name,
			ofile.file_update_userid,
			ofile.user_property, 
			now(),
			ofile.path_id
			) 
			where id =ofile.id;
		return ofile.id;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION object_file_info_update(object_file_info) OWNER TO postgres;


  

 CREATE OR REPLACE FUNCTION update_object_file_info_time(oid integer)
  RETURNS boolean AS
$BODY$

BEGIN    
    update object_file_info set file_update_time=now() where id=oid;
    RETURN true;
EXCEPTION
    WHEN OTHERS THEN 
	RETURN false;    
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION update_object_file_info_time(integer) OWNER TO postgres;
 

-----------------------ivoicevlan
ALTER TABLE l2switchvlan ADD COLUMN ivoicevlan character varying(64);
ALTER TABLE l2switchvlan ALTER COLUMN ivoicevlan SET STORAGE EXTENDED;


CREATE OR REPLACE VIEW devicegroupdeviceview AS 
 SELECT devicegroupdevice.devicegroupid, devicegroupdevice.deviceid, devicegroupdevice.id, ( SELECT devices.strname
           FROM devices
          WHERE devices.id = devicegroupdevice.deviceid) AS devicename, ( SELECT devicegroup.strname
           FROM devicegroup
          WHERE devicegroup.id = devicegroupdevice.devicegroupid) AS devicegroupname, ( SELECT devices.isubtype
           FROM devices
          WHERE devices.id = devicegroupdevice.deviceid) AS isubtype, type
   FROM devicegroupdevice;

ALTER TABLE devicegroupdeviceview OWNER TO postgres;


CREATE OR REPLACE VIEW devicegroupview AS 
 SELECT devicegroup.id, devicegroup.strname, devicegroup.strdesc, devicegroup.userid, devicegroup.showcolor, ( SELECT count(*) AS count
           FROM devicegroupdevice
          WHERE devicegroupdevice.devicegroupid = devicegroup.id) AS irefcount, devicegroup.searchcondition,devicegroup.searchcontainer
   FROM devicegroup
  ORDER BY devicegroup.id;

ALTER TABLE devicegroupview OWNER TO postgres;



-- Function: process_devicegroupdevice_dt()

-- DROP FUNCTION process_devicegroupdevice_dt();

CREATE OR REPLACE FUNCTION process_devicegroupdevice_dt()
  RETURNS trigger AS
$BODY$
declare tid integer;
declare uid integer;
DECLARE newuserid integer;
DECLARE olduserid integer;
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.devicegroupid = NEW.devicegroupid AND 				
			OLD.deviceid = NEW.deviceid AND
			OLD."type" = NEW."type"
		then
			return OLD;
		end IF;
		select userid into newuserid from devicegroup where id=NEW.devicegroupid;
		select userid into olduserid from devicegroup where id=old.devicegroupid;

		if not newuserid=olduserid then
			update objtimestamp set modifytime=now() where typename='PublicDeviceGroup';
			if newuserid=-1 then
				uid=olduserid;
			else 
				uid=newuserid;
			end if;
			select id into tid from objtimestamp where typename='PrivateDeviceGroup' and userid=uid;
			if tid is null then
				insert into objtimestamp (typename,userid,modifytime) values('PrivateDeviceGroup',uid,now());
			else
				update objtimestamp set modifytime=now() where typename='PrivateDeviceGroup' and userid=uid;
			end if;
		elseif newuserid=-1 then
			update objtimestamp set modifytime=now() where typename='PublicDeviceGroup';
		else
			select id into tid from objtimestamp where typename='PrivateDeviceGroup' and userid=newuserid;
			if tid is null then
				insert into objtimestamp (typename,userid,modifytime) values('PrivateDeviceGroup',newuserid,now());
			else
				update objtimestamp set modifytime=now() where typename='PrivateDeviceGroup' and userid=newuserid;
			end if;	
		end if;		
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		select userid into newuserid from devicegroup where id=NEW.devicegroupid;
		if newuserid=-1 then
			update objtimestamp set modifytime=now() where typename='PublicDeviceGroup';
		else
			select id into tid from objtimestamp where typename='PrivateDeviceGroup' and userid=newuserid;
			if tid is null then
				insert into objtimestamp (typename,userid,modifytime) values('PrivateDeviceGroup',newuserid,now());
			else
				update objtimestamp set modifytime=now() where typename='PrivateDeviceGroup' and userid=newuserid;
			end if;	
		end if;		
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		select userid into olduserid from devicegroup where id=old.devicegroupid;
		if not olduserid is null then
			if olduserid=-1 then
				update objtimestamp set modifytime=now() where typename='PublicDeviceGroup';
			else
				select id into tid from objtimestamp where typename='PrivateDeviceGroup' and userid=olduserid;
				if tid is null then
					insert into objtimestamp (typename,userid,modifytime) values('PrivateDeviceGroup',olduserid,now());
				else
					update objtimestamp set modifytime=now() where typename='PrivateDeviceGroup' and userid=olduserid;
				end if;	
			end if;			
		end if;
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION process_devicegroupdevice_dt() OWNER TO postgres;



CREATE OR REPLACE FUNCTION process_linkgroup_dt()
  RETURNS trigger AS
$BODY$
declare tid integer;
declare uid integer;
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.strname = NEW.strname AND 
			OLD.strdesc = NEW.strdesc AND
			OLD.userid = NEW.userid AND			
			OLD.showcolor = NEW.showcolor AND
			OLD.showstyle =NEW.showstyle AND
			OLD.showwidth = NEW.showwidth AND
			OLD.searchcondition= NEW.searchcondition AND
			OLD.searchcontainer =NEW.searchcontainer
		then
			return OLD;
		end IF;

		if not NEW.userid=OLD.userid then
			update objtimestamp set modifytime=now() where typename='PublicLinkGroup';
			if new.userid=-1 then
				uid=old.userid;
			else 
				uid=new.userid;
			end if;
			select id into tid from objtimestamp where typename='PrivateLinkGroup' and userid=uid;
			if tid is null then
				insert into objtimestamp (typename,userid,modifytime) values('PrivateLinkGroup',uid,now());
			else
				update objtimestamp set modifytime=now() where typename='PrivateLinkGroup' and userid=uid;
			end if;
		elseif NEW.userid=-1 then
			update objtimestamp set modifytime=now() where typename='PublicLinkGroup';
		else
			select id into tid from objtimestamp where typename='PrivateLinkGroup' and userid=new.userid;
			if tid is null then
				insert into objtimestamp (typename,userid,modifytime) values('PrivateLinkGroup',new.userid,now());
			else
				update objtimestamp set modifytime=now() where typename='PrivateLinkGroup' and userid=new.userid;
			end if;	
		end if;		
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		if NEW.userid=-1 then
			update objtimestamp set modifytime=now() where typename='PublicLinkGroup';
		else
			select id into tid from objtimestamp where typename='PrivateLinkGroup' and userid=new.userid;
			if tid is null then
				insert into objtimestamp (typename,userid,modifytime) values('PrivateLinkGroup',new.userid,now());
			else
				update objtimestamp set modifytime=now() where typename='PrivateLinkGroup' and userid=new.userid;
			end if;	
		end if;	
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		if OLD.userid=-1 then
			update objtimestamp set modifytime=now() where typename='PublicLinkGroup';
		else
			select id into uid from "user" where id=OLD.userid;
			if( uid is not null) then 
				select id into tid from objtimestamp where typename='PrivateLinkGroup' and userid=OLD.userid;
				if tid is null then
					insert into objtimestamp (typename,userid,modifytime) values('PrivateLinkGroup',old.userid,now());
				else
					update objtimestamp set modifytime=now() where typename='PrivateLinkGroup' and userid=old.userid;
				end if;	
			end if;	
		end if;			
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION process_linkgroup_dt() OWNER TO postgres;


CREATE TRIGGER linkgroup_dt
  BEFORE INSERT OR UPDATE OR DELETE
  ON linkgroup
  FOR EACH ROW
  EXECUTE PROCEDURE process_linkgroup_dt();

-- Function: process_linkgroupinterface_dt()

-- DROP FUNCTION process_linkgroupinterface_dt();

CREATE OR REPLACE FUNCTION process_linkgroupinterface_dt()
  RETURNS trigger AS
$BODY$
declare tid integer;
declare uid integer;
DECLARE newuserid integer;
DECLARE olduserid integer;
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.groupid = NEW.groupid AND 				
			OLD.interfaceid = NEW.interfaceid AND
			OLD."type" = NEW."type" AND
			OLD.interfaceip= NEW.interfaceip
		then
			return OLD;
		end IF;
		select userid into newuserid from linkgroup where id=NEW.groupid;
		select userid into olduserid from linkgroup where id=old.groupid;

		if not newuserid=olduserid then
			update objtimestamp set modifytime=now() where typename='PublicLinkGroup';
			if newuserid=-1 then
				uid=olduserid;
			else 
				uid=newuserid;
			end if;
			select id into tid from objtimestamp where typename='PrivateLinkGroup' and userid=uid;
			if tid is null then
				insert into objtimestamp (typename,userid,modifytime) values('PrivateLinkGroup',uid,now());
			else
				update objtimestamp set modifytime=now() where typename='PrivateLinkGroup' and userid=uid;
			end if;
		elseif newuserid=-1 then
			update objtimestamp set modifytime=now() where typename='PublicLinkGroup';
		else
			select id into tid from objtimestamp where typename='PrivateLinkGroup' and userid=newuserid;
			if tid is null then
				insert into objtimestamp (typename,userid,modifytime) values('PrivateLinkGroup',newuserid,now());
			else
				update objtimestamp set modifytime=now() where typename='PrivateLinkGroup' and userid=newuserid;
			end if;	
		end if;		
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		select userid into newuserid from linkgroup where id=NEW.groupid;
		if newuserid=-1 then
			update objtimestamp set modifytime=now() where typename='PublicLinkGroup';
		else
			select id into tid from objtimestamp where typename='PrivateLinkGroup' and userid=newuserid;
			if tid is null then
				insert into objtimestamp (typename,userid,modifytime) values('PrivateLinkGroup',newuserid,now());
			else
				update objtimestamp set modifytime=now() where typename='PrivateLinkGroup' and userid=newuserid;
			end if;	
		end if;		
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		select userid into olduserid from linkgroup where id=old.groupid;
		if not olduserid is null then
			if olduserid=-1 then
				update objtimestamp set modifytime=now() where typename='PublicLinkGroup';
			else
				select id into tid from objtimestamp where typename='PrivateLinkGroup' and userid=olduserid;
				if tid is null then
					insert into objtimestamp (typename,userid,modifytime) values('PrivateLinkGroup',olduserid,now());
				else
					update objtimestamp set modifytime=now() where typename='PrivateLinkGroup' and userid=olduserid;
				end if;	
			end if;			
		end if;
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION process_linkgroupinterface_dt() OWNER TO postgres;


CREATE TRIGGER linkgroupinterface_dt
  BEFORE INSERT OR UPDATE OR DELETE
  ON linkgroupinterface
  FOR EACH ROW
  EXECUTE PROCEDURE process_linkgroupinterface_dt();

-- Function: devciebygroupid(integer, integer)

CREATE OR REPLACE FUNCTION devciebygroupid(dgroupid integer, dtype integer)
  RETURNS SETOF devices AS
$BODY$
DECLARE
    r devices%rowtype;
BEGIN	
             FOR r IN select deviceid as id,(select strname from devices where devices.id=devicesetting.deviceid) as strname from devicesetting where deviceid in (select deviceid from devicegroupdevice where devicegroupdevice.devicegroupid=dgroupid and "type"=dtype) order by strname LOOP
		RETURN NEXT r;
	     END LOOP;	     		
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION devciebygroupid(integer, integer) OWNER TO postgres;

----------------------------------- process_devicegroup_dt()

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
			OLD.showcolor = NEW.showcolor AND
			OLD.searchcondition= NEW.searchcondition AND
			OLD.searchcontainer = NEW.searchcontainer
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
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION process_devicegroup_dt() OWNER TO postgres;


ALTER TABLE devicegroupdevice DROP CONSTRAINT devicegroupdevice_unique;

ALTER TABLE devicegroupdevice
  ADD CONSTRAINT devicegroupdevice_unique UNIQUE(devicegroupid, deviceid, type);


INSERT INTO "function"(strname, wsver, description, sidname, kval, isdisplay )
    VALUES ( 'Device Icon', 0, '', 'DeviceIcon','39576D6578787652726C763A3C', FALSE);


INSERT INTO "function"(strname, wsver, description, sidname, kval, isdisplay )
    VALUES ( 'Show Command Template', 0, '', 'ShowCommand_Template','3948766C7A586B6E767A5F776D476E6E6C6F6467733A55', FALSE);

----------------------------------------  virtualfunction
CREATE TABLE virtualfunction
(
  id serial NOT NULL,
  strname text NOT NULL,
  wsver integer NOT NULL DEFAULT (-1), -- 1--OE  2--EE -1--all
  description text,
  sidname text NOT NULL,
  isdisplay boolean DEFAULT true,
  is_apply_all boolean NOT NULL DEFAULT false,
  CONSTRAINT virtualfunction_pk PRIMARY KEY (id),
  CONSTRAINT virtualfunction_un UNIQUE (sidname)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE virtualfunction OWNER TO postgres;


insert into virtualfunction (strname,sidname) values ('System Management','System Management');
insert into virtualfunction (strname,sidname) values ('Shared Workspace Management','Shared Workspace Management');
insert into virtualfunction (strname,sidname) values ('Network Documentation','Network Documentation');
insert into virtualfunction (strname,sidname) values ('IP SLA and IP Accounting','IP SLA and IP Accounting');

insert into virtualfunction (strname,sidname,isdisplay,is_apply_all) values ('Default','Default',false,true);
-----------------------------------------  virtualfunction2function 
CREATE TABLE virtualfunction2function
(
  id serial NOT NULL,
  virtualfunctionid integer NOT NULL,
  functionid integer NOT NULL,
  CONSTRAINT virtualfunction2function_pk PRIMARY KEY (id),
  CONSTRAINT virtualfunction2function_function_fk FOREIGN KEY (functionid)
      REFERENCES "function" (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT virtualfunction2function_role_fk FOREIGN KEY (virtualfunctionid)
      REFERENCES "virtualfunction" (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT virtualfunction2function_un UNIQUE (virtualfunctionid, functionid)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE virtualfunction2function OWNER TO postgres;
CREATE INDEX fki_virtualfunction2function_function_fk
  ON virtualfunction2function
  USING btree
  (functionid);
CREATE INDEX fki_virtualfunction2function_role_fk
  ON virtualfunction2function
  USING btree
  (virtualfunctionid);

  
INSERT INTO virtualfunction2function( virtualfunctionid, functionid) VALUES (( select id from virtualfunction where sidname='System Management'), (select id from "function" where sidname='Appliance_Management') ); 

INSERT INTO virtualfunction2function( virtualfunctionid, functionid) VALUES (( select id from virtualfunction where sidname='Shared Workspace Management'), (select id from "function" where sidname='Configuration_File_Management') ); 
INSERT INTO virtualfunction2function( virtualfunctionid, functionid) VALUES (( select id from virtualfunction where sidname='Shared Workspace Management'), (select id from "function" where sidname='Live_Network_Discovery') ); 
INSERT INTO virtualfunction2function( virtualfunctionid, functionid) VALUES (( select id from virtualfunction where sidname='Shared Workspace Management'), (select id from "function" where sidname='L2_Topology_Management') ); 
INSERT INTO virtualfunction2function( virtualfunctionid, functionid) VALUES (( select id from virtualfunction where sidname='Shared Workspace Management'), (select id from "function" where sidname='Common_Device_Setting_Management') ); 
INSERT INTO virtualfunction2function( virtualfunctionid, functionid) VALUES (( select id from virtualfunction where sidname='Shared Workspace Management'), (select id from "function" where sidname='Benchmark') ); 
INSERT INTO virtualfunction2function( virtualfunctionid, functionid) VALUES (( select id from virtualfunction where sidname='Shared Workspace Management'), (select id from "function" where sidname='Topology_Stitching_Management') ); 
INSERT INTO virtualfunction2function( virtualfunctionid, functionid) VALUES (( select id from virtualfunction where sidname='Shared Workspace Management'), (select id from "function" where sidname='Traffic_Stitching_Management') ); 
INSERT INTO virtualfunction2function( virtualfunctionid, functionid) VALUES (( select id from virtualfunction where sidname='Shared Workspace Management'), (select id from "function" where sidname='Device_Group_Management') ); 
INSERT INTO virtualfunction2function( virtualfunctionid, functionid) VALUES (( select id from virtualfunction where sidname='Shared Workspace Management'), (select id from "function" where sidname='LinkGroup') ); 
INSERT INTO virtualfunction2function( virtualfunctionid, functionid) VALUES (( select id from virtualfunction where sidname='Shared Workspace Management'), (select id from "function" where sidname='Site') ); 
INSERT INTO virtualfunction2function( virtualfunctionid, functionid) VALUES (( select id from virtualfunction where sidname='Shared Workspace Management'), (select id from "function" where sidname='SharedMap') ); 
INSERT INTO virtualfunction2function( virtualfunctionid, functionid) VALUES (( select id from virtualfunction where sidname='Shared Workspace Management'), (select id from "function" where sidname='Update_Shared_Map') ); 
INSERT INTO virtualfunction2function( virtualfunctionid, functionid) VALUES (( select id from virtualfunction where sidname='Shared Workspace Management'), (select id from "function" where sidname='DeviceIcon') ); 
INSERT INTO virtualfunction2function( virtualfunctionid, functionid) VALUES (( select id from virtualfunction where sidname='Shared Workspace Management'), (select id from "function" where sidname='ShowCommand_Template') ); 


INSERT INTO virtualfunction2function( virtualfunctionid, functionid) VALUES (( select id from virtualfunction where sidname='Network Documentation'), (select id from "function" where sidname='Local_Documentation') ); 
INSERT INTO virtualfunction2function( virtualfunctionid, functionid) VALUES (( select id from virtualfunction where sidname='Network Documentation'), (select id from "function" where sidname='Documentation') ); 

INSERT INTO virtualfunction2function( virtualfunctionid, functionid) VALUES (( select id from virtualfunction where sidname='IP SLA and IP Accounting'), (select id from "function" where sidname='Local_Advance_Troubleshooting') ); 
INSERT INTO virtualfunction2function( virtualfunctionid, functionid) VALUES (( select id from virtualfunction where sidname='IP SLA and IP Accounting'), (select id from "function" where sidname='Advance_Troubleshooting') ); 

INSERT INTO virtualfunction2function( virtualfunctionid, functionid) VALUES (( select id from virtualfunction where sidname='Default'), (select id from "function" where sidname='Local_Monitor') ); 
INSERT INTO virtualfunction2function( virtualfunctionid, functionid) VALUES (( select id from virtualfunction where sidname='Default'), (select id from "function" where sidname='Monitor') ); 
INSERT INTO virtualfunction2function( virtualfunctionid, functionid) VALUES (( select id from virtualfunction where sidname='Default'), (select id from "function" where sidname='Local_Path') ); 
INSERT INTO virtualfunction2function( virtualfunctionid, functionid) VALUES (( select id from virtualfunction where sidname='Default'), (select id from "function" where sidname='Path') ); 


-------------------- role2virtualfunction
CREATE TABLE role2virtualfunction
(
  id serial NOT NULL,
  roleid integer NOT NULL,
  virtualfunctionid integer NOT NULL,
  CONSTRAINT role2virtualfunction_pk PRIMARY KEY (id),
  CONSTRAINT role2virtualfunction_role_fk FOREIGN KEY (roleid)
      REFERENCES "role" (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT role2virtualfunction_virtualfunction_fk FOREIGN KEY (virtualfunctionid)
      REFERENCES virtualfunction (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT role2virtualfunction_un UNIQUE (roleid, virtualfunctionid)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE role2virtualfunction OWNER TO postgres;


CREATE INDEX fki_role2virtualfunction_function_fk
  ON role2virtualfunction
  USING btree
  (virtualfunctionid);


CREATE INDEX fki_role2virtualfunction_role_fk
  ON role2virtualfunction
  USING btree
  (roleid);


CREATE OR REPLACE VIEW role2functionview AS 
 SELECT role2virtualfunction.roleid, role2virtualfunction.virtualfunctionid, ( SELECT virtualfunction.sidname
           FROM virtualfunction
          WHERE virtualfunction.id = role2virtualfunction.virtualfunctionid) AS virtualfunctionname, ( SELECT virtualfunction.isdisplay
           FROM virtualfunction
          WHERE virtualfunction.id = role2virtualfunction.virtualfunctionid) AS isdisplay, function.id AS fid, function.strname, function.sidname, function.is_apply_all
   FROM role2virtualfunction, virtualfunction2function, function
  WHERE role2virtualfunction.virtualfunctionid = virtualfunction2function.virtualfunctionid AND virtualfunction2function.functionid = function.id
  ORDER BY role2virtualfunction.roleid, role2virtualfunction.virtualfunctionid, function.id;

ALTER TABLE role2functionview OWNER TO postgres;


 CREATE OR REPLACE VIEW functionmergevirtulafunctionview AS 
 SELECT role2function.roleid, role2function.functionid, function.sidname
   FROM role2function, function
  WHERE role2function.functionid = function.id
  ORDER BY role2function.roleid;

ALTER TABLE functionmergevirtulafunctionview OWNER TO postgres;


INSERT INTO virtualfunction(
            strname, wsver, description, sidname, isdisplay, is_apply_all)
    VALUES ('Network Design', -1, null, 'Network Design', true, false);


INSERT INTO virtualfunction2function(
            virtualfunctionid, functionid)
    VALUES ( (select id from virtualfunction where sidname='Network Design'), (select id from function where sidname='Design_Module' ));

CREATE OR REPLACE FUNCTION mergerole()
  RETURNS boolean AS
$BODY$
DECLARE
    r functionmergevirtulafunctionview%rowtype;	
    r1 functionmergevirtulafunctionview%rowtype;	
    r2 functionmergevirtulafunctionview%rowtype;	
    r3 functionmergevirtulafunctionview%rowtype;
    r6 functionmergevirtulafunctionview%rowtype;	

    t integer;
    r4 "role"%rowtype;
BEGIN
    for r4 in SELECT id FROM "role" loop	
	insert into role2virtualfunction (roleid,virtualfunctionid) values (r4.id,(select id from virtualfunction where sidname='Default'));
    end loop;	

    for r in SELECT DISTINCT (roleid) FROM functionmergevirtulafunctionview where sidname='Appliance_Management' loop	
	insert into role2virtualfunction (roleid,virtualfunctionid) values (r.roleid,(select id from virtualfunction where sidname='System Management'));
    end loop;

    for r1 in SELECT DISTINCT (roleid) FROM functionmergevirtulafunctionview where sidname='Local_Advance_Troubleshooting' or sidname='Advance_Troubleshooting' loop	
	insert into role2virtualfunction (roleid,virtualfunctionid) values (r1.roleid,(select id from virtualfunction where sidname='IP SLA and IP Accounting'));
    end loop;

    for r2 in SELECT DISTINCT (roleid) FROM functionmergevirtulafunctionview where sidname='Local_Documentation' or sidname='Documentation' loop	
	insert into role2virtualfunction (roleid,virtualfunctionid) values (r2.roleid,(select id from virtualfunction where sidname='Network Documentation'));
    end loop;

    for r3 in SELECT DISTINCT (roleid) FROM functionmergevirtulafunctionview where sidname='Configuration_File_Management' or sidname='Live_Network_Discovery' or sidname='L2_Topology_Management' or sidname='Common_Device_Setting_Management' or sidname='Benchmark' or sidname='Topology_Stitching_Management' or sidname='Traffic_Stitching_Management' or sidname='Device_Group_Management' or sidname='LinkGroup' or sidname='Site' or sidname='SharedMap' or sidname='Update_Shared_Map' or sidname='Monitor' or sidname='Path' loop	
	insert into role2virtualfunction (roleid,virtualfunctionid) values (r3.roleid,(select id from virtualfunction where sidname='Shared Workspace Management'));
    end loop;

    for r6 in SELECT DISTINCT (roleid) FROM functionmergevirtulafunctionview where sidname='Design_Module' loop	
	insert into role2virtualfunction (roleid,virtualfunctionid) values (r6.roleid,(select id from virtualfunction where sidname='Network Design'));
    end loop;

    select id into t from role2virtualfunction where roleid=(select id from "role" where name='Engineer') and virtualfunctionid=(select id from virtualfunction where sidname='Network Documentation');
    IF t IS NULL THEN 
	insert into role2virtualfunction (roleid,virtualfunctionid) values ((select id from "role" where name='Engineer'),(select id from virtualfunction where sidname='Network Documentation'));
    END IF;

    select id into t from role2virtualfunction where roleid=(select id from "role" where name='Engineer') and virtualfunctionid=(select id from virtualfunction where sidname='IP SLA and IP Accounting');
    IF t IS NULL THEN 
	insert into role2virtualfunction (roleid,virtualfunctionid) values ((select id from "role" where name='Engineer'),(select id from virtualfunction where sidname='IP SLA and IP Accounting'));
    END IF;

    select id into t from role2virtualfunction where roleid=(select id from "role" where name='PowerUser') and virtualfunctionid=(select id from virtualfunction where sidname='Network Documentation');
    IF t IS NULL THEN 
	insert into role2virtualfunction (roleid,virtualfunctionid) values ((select id from "role" where name='PowerUser'),(select id from virtualfunction where sidname='Network Documentation'));
    END IF;

    select id into t from role2virtualfunction where roleid=(select id from "role" where name='PowerUser') and virtualfunctionid=(select id from virtualfunction where sidname='IP SLA and IP Accounting');
    IF t IS NULL THEN 
	insert into role2virtualfunction (roleid,virtualfunctionid) values ((select id from "role" where name='PowerUser'),(select id from virtualfunction where sidname='IP SLA and IP Accounting'));
    END IF;

    select id into t from role2virtualfunction where roleid=(select id from "role" where name='PowerUser') and virtualfunctionid=(select id from virtualfunction where sidname='Shared Workspace Management');
    IF t IS NULL THEN 
	insert into role2virtualfunction (roleid,virtualfunctionid) values ((select id from "role" where name='PowerUser'),(select id from virtualfunction where sidname='Shared Workspace Management'));
    END IF;

    select id into t from role2virtualfunction where roleid=(select id from "role" where name='Admin') and virtualfunctionid=(select id from virtualfunction where sidname='Shared Workspace Management');
    IF t IS NULL THEN 
	insert into role2virtualfunction (roleid,virtualfunctionid) values ((select id from "role" where name='Admin'),(select id from virtualfunction where sidname='Shared Workspace Management'));
    END IF;

    select id into t from role2virtualfunction where roleid=(select id from "role" where name='Admin') and virtualfunctionid=(select id from virtualfunction where sidname='System Management');
    IF t IS NULL THEN 
	insert into role2virtualfunction (roleid,virtualfunctionid) values ((select id from "role" where name='Admin'),(select id from virtualfunction where sidname='System Management'));
    END IF;

    select id into t from role2virtualfunction where roleid=(select id from "role" where name='Admin') and virtualfunctionid=(select id from virtualfunction where sidname='Network Documentation');
    IF t IS NULL THEN 
	insert into role2virtualfunction (roleid,virtualfunctionid) values ((select id from "role" where name='Admin'),(select id from virtualfunction where sidname='Network Documentation'));
    END IF;

    select id into t from role2virtualfunction where roleid=(select id from "role" where name='Admin') and virtualfunctionid=(select id from virtualfunction where sidname='IP SLA and IP Accounting');
    IF t IS NULL THEN 
	insert into role2virtualfunction (roleid,virtualfunctionid) values ((select id from "role" where name='Admin'),(select id from virtualfunction where sidname='IP SLA and IP Accounting'));
    END IF;
    
    RETURN true;
--EXCEPTION
--    WHEN OTHERS THEN 
--	RETURN false;    
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION mergerole() OWNER TO postgres;

select * from mergerole();


INSERT INTO role2virtualfunction(
            roleid, virtualfunctionid)
    VALUES ((select id from role where name='PowerUser'), (select id from virtualfunction where sidname='Network Design'));


drop function mergerole();
drop VIEW functionmergevirtulafunctionview;
DROP TABLE role2function;

CREATE OR REPLACE VIEW role2function AS 
 SELECT role2virtualfunction.id,role2virtualfunction.roleid, function.id AS functionid
   FROM role2virtualfunction, virtualfunction2function, function
  WHERE role2virtualfunction.virtualfunctionid = virtualfunction2function.virtualfunctionid AND virtualfunction2function.functionid = function.id
  ORDER BY role2virtualfunction.roleid, role2virtualfunction.virtualfunctionid, function.id;

ALTER TABLE role2function OWNER TO postgres;

     

CREATE OR REPLACE FUNCTION devicegroupdevice_upsert3(gid integer, ds character varying[])
  RETURNS boolean AS
$BODY$
DECLARE
    r integer;
BEGIN
	for r in select id from devicegroup where strname = any(ds) LOOP
	       insert into devicegroupdevice (devicegroupid,deviceid) values (gid, r );              
	end loop;	
	return true;
EXCEPTION    
	WHEN OTHERS THEN   
		return false;		
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION devicegroupdevice_upsert3(integer, character varying[]) OWNER TO postgres;


-- Function: devicebygrouplist(integer[])

-- DROP FUNCTION devicebygrouplist(integer[]);

CREATE OR REPLACE FUNCTION retrieve_device_by_siteids( ids integer[])
  RETURNS SETOF devices AS
$BODY$

DECLARE
    r devices%rowtype;
BEGIN		
		     FOR r IN select devices.* from devices, devicesitedevice where devices.id=devicesitedevice.deviceid and devicesitedevice.siteid = any(ids) LOOP
			RETURN NEXT r;
		     END LOOP;	     		    
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION retrieve_device_by_siteids(integer[]) OWNER TO postgres;


------------------------- optimize

CREATE OR REPLACE FUNCTION device_property_update(dp devicepropertyview)
  RETURNS integer AS
$BODY$
declare
	r_id integer;
	ds_id integer;
BEGIN
	select id into r_id from devices where strname=dp.devicename;
	if r_id IS NULL THEN
		return -1;
	end if;

	select id into ds_id from device_property where deviceid=r_id;
	if ds_id IS NULL THEN
		return -1;
	ELSE
		update device_property set ( 
			manageif_mac,
			vendor,
			model,
			sysobjectid,
			software_version,
			serial_number,
			asset_tag,
			system_memory,
			"location",
			network_cluster,
			contact,
			hierarchy_layer,
			description,
			management_interface			
			)
			=( 
			dp.manageif_mac,
			dp.vendor,
			dp.model,
			dp.sysobjectid,
			dp.software_version,
			dp.serial_number,
			dp.asset_tag,
			dp.system_memory,
			dp.location,
			dp.network_cluster,
			dp.contact,
			dp.hierarchy_layer,
			dp.description,
			dp.management_interface			
			) 
			where id = ds_id;
		return ds_id;
	end if;
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION device_property_update(devicepropertyview) OWNER TO postgres;


CREATE OR REPLACE FUNCTION device_customized_info_delete(dp device_customized_infoview)
  RETURNS boolean AS
$BODY$
declare
	r_id integer;
	ds_id integer;
BEGIN
	select id into r_id from devices where strname=dp.devicename;
	if r_id IS NULL THEN
		return false;
	end if;

	select id into ds_id from device_property where deviceid=r_id;
	if ds_id IS NULL THEN
		return false;
	end if;
	
	delete from device_customized_info where objectid=ds_id;	
	return true;
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION device_customized_info_delete(device_customized_infoview) OWNER TO postgres;


CREATE OR REPLACE FUNCTION device_customized_infoview_upsert(dciv device_customized_infoview)
  RETURNS integer AS
$BODY$
declare
	r_id integer;
	ds_id integer;
	t_id integer;
BEGIN
	select id into r_id from devices where strname=dciv.devicename;
	if r_id IS NULL THEN
		return -1;
	end if;

	select id into ds_id from device_property where deviceid=r_id;
	if ds_id IS NULL THEN
		return -1;
	end if;

	select id into t_id from device_customized_info where objectid=ds_id and attributeid=dciv.attributeid ;
	if t_id IS NULL THEN		
		insert into device_customized_info(
			objectid,
			attributeid,
			attribute_value
			)
			values ( 
			ds_id,
			dciv.attributeid,
			dciv.attribute_value
		);

		return lastval();
	ELSE
		update device_customized_info set ( attribute_value)=( dciv.attribute_value ) where id = t_id;
		return t_id;
	end if;
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION device_customized_infoview_upsert(device_customized_infoview) OWNER TO postgres;


CREATE OR REPLACE FUNCTION interface_customized_infoview_delete(dp interface_customized_infoview)
  RETURNS boolean AS
$BODY$
declare
	r_id integer;
	ds_id integer;
BEGIN
	select id into r_id from devices where strname=dp.devicename;
	if r_id IS NULL THEN
		return false;
	end if;

	select id into ds_id from interfacesetting where deviceid=r_id and interfacename=dp.interfacename ;
	if ds_id IS NULL THEN
		return false;
	end if;
	
	delete from interface_customized_info where objectid=ds_id;	
	return true;
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION interface_customized_infoview_delete(interface_customized_infoview) OWNER TO postgres;



CREATE OR REPLACE FUNCTION interface_customized_infoview_upsert(dciv interface_customized_infoview)
  RETURNS integer AS
$BODY$
declare
	r_id integer;
	ds_id integer;
	t_id integer;
BEGIN
	select id into r_id from devices where strname=dciv.devicename;
	if r_id IS NULL THEN
		return -1;
	end if;

	select id into ds_id from interfacesetting where deviceid=r_id and interfacename=dciv.interfacename ;
	if ds_id IS NULL THEN
		return -1;
	end if;

	select id into t_id from interface_customized_info where objectid=ds_id and attributeid=dciv.attributeid ;
	if t_id IS NULL THEN		
		insert into interface_customized_info(
			objectid,
			attributeid,
			attribute_value
			)
			values ( 
			ds_id,
			dciv.attributeid,
			dciv.attribute_value
		);

		return lastval();
	ELSE
		update interface_customized_info set ( attribute_value)=( dciv.attribute_value ) where id = t_id;
		return t_id;
	end if;
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION interface_customized_infoview_upsert(interface_customized_infoview) OWNER TO postgres;



CREATE OR REPLACE FUNCTION module_customized_infoview_delete(dp module_customized_infoview)
  RETURNS boolean AS
$BODY$
declare
	r_id integer;
	ds_id integer;
BEGIN
	select id into r_id from devices where strname=dp.devicename;
	if r_id IS NULL THEN
		return false;
	end if;

	select id into ds_id from module_property where deviceid=r_id and slot=dp.slot ;
	if ds_id IS NULL THEN
		return false;
	end if;
	
	delete from module_customized_info where objectid=ds_id;	
	return true;
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION module_customized_infoview_delete(module_customized_infoview) OWNER TO postgres;



CREATE OR REPLACE FUNCTION module_customized_infoview_upsert(dciv module_customized_infoview)
  RETURNS integer AS
$BODY$
declare
	r_id integer;
	ds_id integer;
	t_id integer;
BEGIN
	select id into r_id from devices where strname=dciv.devicename;
	if r_id IS NULL THEN
		return -1;
	end if;

	select id into ds_id from module_property where deviceid=r_id and slot=dciv.slot ;
	if ds_id IS NULL THEN
		return -1;
	end if;

	select id into t_id from module_customized_info where objectid=ds_id and attributeid=dciv.attributeid ;
	if t_id IS NULL THEN		
		insert into module_customized_info(
			objectid,
			attributeid,
			attribute_value
			)
			values ( 
			ds_id,
			dciv.attributeid,
			dciv.attribute_value
		);

		return lastval();
	ELSE
		update module_customized_info set ( attribute_value)=( dciv.attribute_value ) where id = t_id;
		return t_id;
	end if;
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION module_customized_infoview_upsert(module_customized_infoview) OWNER TO postgres;


CREATE OR REPLACE FUNCTION module_property_update(dp module_propertyview)
  RETURNS integer AS
$BODY$
declare
	r_id integer;
	ds_id integer;
BEGIN
	select id into r_id from devices where strname=dp.devicename;
	if r_id IS NULL THEN
		return -1;
	end if;

	select id into ds_id from module_property where deviceid=r_id and slot=dp.slot;
	if ds_id IS NULL THEN
		return -1;
	ELSE
		update module_property set ( 
			card_type,
			ports,
			serial_number,
			hwrev,
			rwrev,
			swrev,
			card_description,
			"role",
			macaddress,
			swversion,
			swimage,
			stackport1conn,
			stackport2conn,
			isswitch
			)
			=( 
			dp.card_type,
			dp.ports,
			dp.serial_number,
			dp.hwrev,
			dp.rwrev,
			dp.swrev,
			dp.card_description,
			dp.role,
			dp.macaddress,
			dp.swversion,
			dp.swimage,
			dp.stackport1conn,
			dp.stackport2conn,
			dp.isswitch
			) 
			where id = ds_id;
		return ds_id;
	end if;
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION module_property_update(module_propertyview) OWNER TO postgres;


CREATE OR REPLACE FUNCTION module_property_upsert(ds module_propertyview)
  RETURNS integer AS
$BODY$
declare
	r_id integer;
	ds_id integer;
BEGIN
	select id into r_id from devices where strname=ds.devicename;
	if r_id IS NULL THEN
		return -1;
	end if;

	insert into module_property(
			deviceid,
			slot,
			card_type,
			ports,
			serial_number,
			hwrev,
			rwrev,
			swrev,
			card_description,
			lasttimestamp,
			"role",
			macaddress,
			swversion,
			swimage,
			stackport1conn,
			stackport2conn,
			isswitch
			)
			values ( 
			r_id,
			ds.slot,
			ds.card_type,
			ds.ports,
			ds.serial_number,
			ds.hwrev,
			ds.rwrev,
			ds.swrev,
			ds.card_description,
			now(),
			ds.role,
			ds.macaddress,
			ds.swversion,
			ds.swimage,
			ds.stackport1conn,
			ds.stackport2conn,
			ds.isswitch
		);

		return lastval();

	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION module_property_upsert(module_propertyview) OWNER TO postgres;


-- Function: site_addormodify(integer, site)

-- DROP FUNCTION site_addormodify(integer, site);

CREATE OR REPLACE FUNCTION site_addormodify(nparent integer, ssite site)
  RETURNS integer AS
$BODY$
declare
	r_id integer;
	site_id integer;	
BEGIN
	select id into site_id from site where id=ssite.id;
	if site_id IS NULL THEN--insert 
		select id into r_id from site where id=nparent;
		if r_id is NULL THEN
			return -1;
		end if;
		insert into site (
		"name",
		region,
		location_address,
		employee_number,
		contact_name,
		phone_number,
		email,
		"type",
		color,
		"comment",
		lasttimestamp
		) values (
		ssite."name",
		ssite.region,
		ssite.location_address,
		ssite.employee_number,
		ssite.contact_name,
		ssite.phone_number,
		ssite.email,
		ssite."type",
		ssite.color,
		ssite."comment",
		now()
		);
		site_id:=lastval();
		insert into site2site (siteid,parentid) values(site_id,nparent);
		return site_id;
	ELSE -- update
		update site set(
		"name",
		region,
		location_address,
		employee_number,
		contact_name,
		phone_number,
		email,
		"type",
		color,
		"comment",
		lasttimestamp
		) =(
		ssite."name",
		ssite.region,
		ssite.location_address,
		ssite.employee_number,
		ssite.contact_name,
		ssite.phone_number,
		ssite.email,
		ssite."type",
		ssite.color,
		ssite."comment",
		now()
		)
		where id = site_id;
		return site_id;
	end if;
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION site_addormodify(integer, site) OWNER TO postgres;




ALTER TABLE l2switchport ADD COLUMN voicevlan character varying(100);
ALTER TABLE l2switchport ALTER COLUMN voicevlan SET STORAGE EXTENDED;


ALTER TABLE devicegroup ALTER COLUMN searchcontainer SET Default(-1);
update devicegroup set searchcontainer=-1 where searchcontainer is null;

ALTER TABLE linkgroup ALTER COLUMN searchcontainer SET Default(-1);
update linkgroup set searchcontainer=-1 where searchcontainer is null;



----- devicessettingview-web list
CREATE OR REPLACE VIEW devicesettingview_weblist AS
SELECT devicesetting.id, devicesetting.deviceid, devicesetting.manageip, devicesetting.subtype, devicesetting.appliceid, devices.strname AS devicename, 
 (select strhostname from nomp_appliance where nomp_appliance.id = devicesetting.appliceid ) as hostname,
 (select vendor from device_property where devicesetting.deviceid = device_property.deviceid) as vendor,
 (select model from device_property where devicesetting.deviceid = device_property.deviceid) as model,
 (select software_version from device_property where devicesetting.deviceid = device_property.deviceid) as softwareversion,
 (select serial_number from device_property where devicesetting.deviceid = device_property.deviceid) as serialnumber,
 (select contact from device_property where devicesetting.deviceid = device_property.deviceid) as contactor,
 (select location from device_property where devicesetting.deviceid = device_property.deviceid) as currentlocation    
   FROM devicesetting, devices
  WHERE devices.id = devicesetting.deviceid ;

ALTER TABLE devicesettingview_weblist OWNER TO postgres;


DROP FUNCTION devicelistnofiler(integer, integer);
CREATE OR REPLACE FUNCTION devicelistnofiler(pageindexsize integer, pagesize integer)
  RETURNS SETOF devicesettingview_weblist AS
$BODY$

DECLARE
    r devicesettingview_weblist%rowtype;
BEGIN				     
		    FOR r IN select * from devicesettingview_weblist where id not in ( select id from devicesettingview_weblist order by lower(devicename) limit pageindexsize ) order by lower(devicename) limit pagesize LOOP
			RETURN NEXT r;
		     END LOOP;		     		
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION devicelistnofiler(integer, integer) OWNER TO postgres;


DROP FUNCTION devicelistbygroupnofilerbytype(integer, integer, integer);
CREATE OR REPLACE FUNCTION devicelistbygroupnofilerbytype(pageindexsize integer, pagesize integer, types integer)
  RETURNS SETOF devicesettingview_weblist AS
$BODY$

DECLARE
    r devicesettingview_weblist%rowtype;
BEGIN			     		     
		     FOR r IN select * from devicesettingview_weblist where subtype = types and  id not in ( select id from devicesettingview_weblist where subtype = types order by lower(devicename) limit pageindexsize ) order by lower(devicename) limit pagesize LOOP
			RETURN NEXT r;
		     END LOOP;		     				     
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION devicelistbygroupnofilerbytype(integer, integer, integer) OWNER TO postgres;


drop FUNCTION devicelistbygroupnofiler(integer, integer, integer);
CREATE OR REPLACE FUNCTION devicelistbygroupnofiler(groupid integer, pageindexsize integer, pagesize integer)
  RETURNS SETOF devicesettingview_weblist AS
$BODY$

DECLARE
    r devicesettingview_weblist%rowtype;
BEGIN			     
		     FOR r IN select * from devicesettingview_weblist where deviceid in (select deviceid from devicegroupdeviceview where devicegroupid =groupid and deviceid not in (select deviceid from devicegroupdeviceview where devicegroupid =groupid order by lower(devicename) limit pageindexsize) order by lower(devicename) limit pagesize ) order by lower(devicename) LOOP
			RETURN NEXT r;
		     END LOOP;			     
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION devicelistbygroupnofiler(integer, integer, integer) OWNER TO postgres;



--------------------         device icon

INSERT INTO objtimestamp(
            typename, modifytime, userid)
    VALUES ( 'DeviceIcon', '1900-01-01 00:00:00', -1);

CREATE TABLE device_icon
(
  id serial NOT NULL,
  icon_name character varying(100) NOT NULL,
  lasttimestamp timestamp without time zone NOT NULL DEFAULT now(),
  CONSTRAINT device_icon_pk PRIMARY KEY (id),
  CONSTRAINT device_icon_name_un UNIQUE (icon_name)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE device_icon OWNER TO postgres;


CREATE OR REPLACE FUNCTION process_device_icon_dt()
  RETURNS trigger AS
$BODY$
		
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.icon_name = NEW.icon_name			
		then
			return OLD;
		end IF;		
		NEW.lasttimestamp=now();	
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN				
		NEW.lasttimestamp=now();
		RETURN NEW;        
	ELSIF (TG_OP = 'DELETE') THEN		
		RETURN OLD;		        
        END IF;
        RETURN NULL;
    END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION process_device_icon_dt() OWNER TO postgres;


CREATE TRIGGER device_icon_dt
  BEFORE INSERT OR UPDATE OR DELETE
  ON device_icon
  FOR EACH ROW
  EXECUTE PROCEDURE process_device_icon_dt();
 

CREATE TABLE symbol2deviceicon
(
  id serial NOT NULL,
  symbolid integer NOT NULL,
  deviceicon_id integer NOT NULL,
  lasttimestamp timestamp without time zone NOT NULL,
  CONSTRAINT symbol2deviceicon_pk PRIMARY KEY (id),
  CONSTRAINT symbol2deviceicon_fk FOREIGN KEY (deviceicon_id)
      REFERENCES device_icon (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT symbol2deviceicon_un UNIQUE (symbolid, deviceicon_id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE symbol2deviceicon OWNER TO postgres;

-- Index: fki_symbol2deviceicon_fk

-- DROP INDEX fki_symbol2deviceicon_fk;

CREATE INDEX fki_symbol2deviceicon_fk
  ON symbol2deviceicon
  USING btree
  (deviceicon_id);

CREATE OR REPLACE FUNCTION process_symbol2deviceicon_dt()
  RETURNS trigger AS
$BODY$
		
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.symbolid = NEW.symbolid AND
			OLD.deviceicon_id=NEW.deviceicon_id			
		then
			return OLD;
		end IF;		
		NEW.lasttimestamp=now();	
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN		
		NEW.lasttimestamp=now();
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN		
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION process_symbol2deviceicon_dt() OWNER TO postgres;

-- Trigger: symbol2deviceicon_dt on symbol2deviceicon

-- DROP TRIGGER symbol2deviceicon_dt ON symbol2deviceicon;

CREATE TRIGGER symbol2deviceicon_dt
  BEFORE INSERT OR UPDATE OR DELETE
  ON symbol2deviceicon
  FOR EACH ROW
  EXECUTE PROCEDURE process_symbol2deviceicon_dt();


  CREATE TABLE symbol2deviceicon_selected
(
  id serial NOT NULL,
  symbolid integer NOT NULL,
  default_deviceicon_id integer NOT NULL,
  selected_deviceicon_id integer NOT NULL,
  lasttimestamp timestamp without time zone NOT NULL,
  CONSTRAINT symbol2deviceicon_selected_pk PRIMARY KEY (id),
  CONSTRAINT symbol2deviceicon_selected_fk FOREIGN KEY (default_deviceicon_id)
      REFERENCES device_icon (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT symbol2deviceicon_selected_symbol_icon_un UNIQUE (symbolid, default_deviceicon_id, selected_deviceicon_id),
  CONSTRAINT symbol2deviceicon_selected_symbol_un UNIQUE (symbolid),
  CONSTRAINT symbol2deviceicon_selected_un UNIQUE (selected_deviceicon_id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE symbol2deviceicon_selected OWNER TO postgres;

-- Index: fki_symbol2deviceicon_selected_fk

-- DROP INDEX fki_symbol2deviceicon_selected_fk;

CREATE INDEX fki_symbol2deviceicon_selected_fk
  ON symbol2deviceicon_selected
  USING btree
  (default_deviceicon_id);


-- Trigger: symbol2deviceicon_selected_dt on symbol2deviceicon_selected

-- DROP TRIGGER symbol2deviceicon_selected_dt ON symbol2deviceicon_selected;


CREATE OR REPLACE FUNCTION process_symbol2deviceicon_selected_dt()
  RETURNS trigger AS
$BODY$
		
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.symbolid = NEW.symbolid AND
			OLD.default_deviceicon_id=NEW.default_deviceicon_id AND
			OLD.selected_deviceicon_id=NEW.selected_deviceicon_id			
		then
			return OLD;
		end IF;		
		NEW.lasttimestamp=now();	
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN		
		NEW.lasttimestamp=now();
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN		
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION process_symbol2deviceicon_selected_dt() OWNER TO postgres;

CREATE TRIGGER symbol2deviceicon_selected_dt
  BEFORE INSERT OR UPDATE OR DELETE
  ON symbol2deviceicon_selected
  FOR EACH ROW
  EXECUTE PROCEDURE process_symbol2deviceicon_selected_dt();

CREATE OR REPLACE FUNCTION view_object_file_info_retrieve(objectids integer[], objecttypeid integer, dt timestamp without time zone)
  RETURNS SETOF object_file_info AS
$BODY$
declare
	r object_file_info%rowtype;	
BEGIN	
	for r in SELECT * FROM object_file_info where object_id=any(objectids) and object_type=objecttypeid  and lasttimestamp>dt loop
		return next r;
	end loop;		
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION view_object_file_info_retrieve(integer[], integer, timestamp without time zone) OWNER TO postgres;


CREATE OR REPLACE VIEW deviceiconview AS 
 SELECT object_file_info.id AS objectfileid, object_file_info.file_update_time as lasttimestamp, object_file_info.file_real_name, object_file_info.file_save_name, device_icon.icon_name, symbol2deviceicon.symbolid
   FROM object_file_info, device_icon, symbol2deviceicon
  WHERE object_file_info.object_id = device_icon.id AND object_file_info.object_type = 3 AND object_file_info.object_id = symbol2deviceicon.deviceicon_id
  ORDER BY object_file_info.id;

ALTER TABLE deviceiconview OWNER TO postgres;


CREATE OR REPLACE FUNCTION view_deviceiconview_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying)
  RETURNS SETOF deviceiconview AS
$BODY$
declare	
	r deviceiconview%rowtype;
	t timestamp without time zone;
BEGIN
	select modifytime into t from objtimestamp where typename=stypename;
	
	if t is null or t>dt then
		if imax <0 then
			for r in  select * from deviceiconview where objectfileid >ibegin and lasttimestamp>dt loop				
				return next r;								
			end loop;
		else
			for r in select * from deviceiconview where objectfileid >ibegin and lasttimestamp>dt limit imax loop				
				return next r;				
			end loop;

		end if;	
	end if;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION view_deviceiconview_retrieve(integer, integer, timestamp without time zone, character varying) OWNER TO postgres;




  ----------------------------        system_vendormodel2device_icon
CREATE TABLE system_vendormodel2device_icon
(
  id serial NOT NULL,
  vendormodel_id integer NOT NULL,
  deviceicon_id integer NOT NULL,
  lasttimestamp timestamp without time zone NOT NULL DEFAULT now(),
  CONSTRAINT system_vendormodel2device_icon_pk PRIMARY KEY (id),
  CONSTRAINT system_vendormodel2device_icon_deviceicon_id_fk FOREIGN KEY (deviceicon_id)
      REFERENCES device_icon (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT system_vendormodel2device_icon_vendormodel_id_fk FOREIGN KEY (vendormodel_id)
      REFERENCES system_vendormodel (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT system_vendormodel2device_icon_icon_un UNIQUE (deviceicon_id),
  CONSTRAINT system_vendormodel2device_icon_un UNIQUE (vendormodel_id, deviceicon_id),
  CONSTRAINT system_vendormodel2device_icon_vendor_un UNIQUE (vendormodel_id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE system_vendormodel2device_icon OWNER TO postgres;

-- Index: fki_system_vendormodel2device_icon_deviceicon_id_fk

-- DROP INDEX fki_system_vendormodel2device_icon_deviceicon_id_fk;

CREATE INDEX fki_system_vendormodel2device_icon_deviceicon_id_fk
  ON system_vendormodel2device_icon
  USING btree
  (deviceicon_id);


CREATE OR REPLACE FUNCTION process_system_vendormodel2device_icon_dt()
  RETURNS trigger AS
$BODY$
		
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.vendormodel_id = NEW.vendormodel_id AND
			OLD.deviceicon_id=NEW.deviceicon_id			
		then
			return OLD;
		end IF;		
		NEW.lasttimestamp=now();	
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN		
		NEW.lasttimestamp=now();
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN		
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION process_system_vendormodel2device_icon_dt() OWNER TO postgres;


CREATE OR REPLACE VIEW systemvendormodeliconview AS 
 SELECT device_icon.icon_name, system_vendormodel.id, system_vendormodel.stroid, system_vendormodel.idevicetype, system_vendormodel.strvendorname, system_vendormodel.strmodelname, system_vendormodel.bmodified
   FROM system_vendormodel2device_icon, device_icon, system_vendormodel
  WHERE system_vendormodel2device_icon.deviceicon_id = device_icon.id AND system_vendormodel2device_icon.vendormodel_id = system_vendormodel.id;

ALTER TABLE systemvendormodeliconview OWNER TO postgres;




CREATE TRIGGER system_vendormodel2device_icon_dt
  BEFORE INSERT OR UPDATE OR DELETE
  ON system_vendormodel2device_icon
  FOR EACH ROW
  EXECUTE PROCEDURE process_system_vendormodel2device_icon_dt();



----------------------------------------dynamic devicegroup systemdevicegroup
-- Table: devicegroupsystemdevicegroup

-- DROP TABLE devicegroupsystemdevicegroup;

CREATE TABLE devicegroupsystemdevicegroup
(
  id serial NOT NULL,
  groupid integer,
  groupidbelone integer,
  CONSTRAINT devicegroupsystemdevicegroup_pk_id PRIMARY KEY (id),
  CONSTRAINT devicegroupsystemdevicegroup_fk_group FOREIGN KEY (groupid)
      REFERENCES devicegroup (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT devicegroupsystemdevicegroup_fk_groupbelone FOREIGN KEY (groupidbelone)
      REFERENCES systemdevicegroup (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
ALTER TABLE devicegroupsystemdevicegroup OWNER TO postgres;


-- Table: linkgroupsystemdevicegroup

-- DROP TABLE linkgroupsystemdevicegroup;

CREATE TABLE linkgroupsystemdevicegroup
(
  id serial NOT NULL,
  groupid integer,
  groupidbelone integer,
  CONSTRAINT linkgroupsystemdevicegroup_pk_id PRIMARY KEY (id),
  CONSTRAINT linkgroupsystemdevicegroup_fk_group FOREIGN KEY (groupid)
      REFERENCES linkgroup (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT linkgroupsystemdevicegroupbelone_fk_group FOREIGN KEY (groupidbelone)
      REFERENCES systemdevicegroup (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
ALTER TABLE linkgroupsystemdevicegroup OWNER TO postgres;


-- Function: devicegroupclearsearchcontainerids(integer)

-- DROP FUNCTION devicegroupclearsearchcontainerids(integer);

CREATE OR REPLACE FUNCTION devicegroupclearsearchcontainerids(lid integer)
  RETURNS integer AS
$BODY$			
BEGIN
	delete from devicegroupdevicegroup where groupid=lid;
	delete from devicegroupsite where groupid=lid;
	delete from devicegroupsystemdevicegroup where groupid=lid;
	return 1;
End;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION devicegroupclearsearchcontainerids(integer) OWNER TO postgres;


-- Function: linkgroupclearsearchcontainerids(integer)

-- DROP FUNCTION linkgroupclearsearchcontainerids(integer);

CREATE OR REPLACE FUNCTION linkgroupclearsearchcontainerids(lid integer)
  RETURNS integer AS
$BODY$			
BEGIN
	delete from linkgroupdevicegroup where groupid=lid;
	delete from linkgroupsite where groupid=lid;
	delete from linkgrouplinkgroup where groupid=lid;
	delete from linkgroupsystemdevicegroup where groupid=lid;
	return 1;
End;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION linkgroupclearsearchcontainerids(integer) OWNER TO postgres;

-- View: devicegroupsystemdevicegroupview

-- DROP VIEW devicegroupsystemdevicegroupview;

CREATE OR REPLACE VIEW devicegroupsystemdevicegroupview AS 
 SELECT devicegroupsystemdevicegroup.id, devicegroupsystemdevicegroup.groupid, ( SELECT systemdevicegroup.strname
           FROM systemdevicegroup
          WHERE systemdevicegroup.id = devicegroupsystemdevicegroup.groupid) AS groupname, devicegroupsystemdevicegroup.groupidbelone, ( SELECT systemdevicegroup.strname
           FROM systemdevicegroup
          WHERE systemdevicegroup.id = devicegroupsystemdevicegroup.groupidbelone) AS groupnamebelone
   FROM devicegroupsystemdevicegroup;

ALTER TABLE devicegroupsystemdevicegroupview OWNER TO postgres;

-- View: linkgroupsystemdevicegroupview

-- DROP VIEW linkgroupsystemdevicegroupview;

CREATE OR REPLACE VIEW linkgroupsystemdevicegroupview AS 
 SELECT linkgroupsystemdevicegroup.id, linkgroupsystemdevicegroup.groupid, ( SELECT linkgroup.strname
           FROM linkgroup
          WHERE id = linkgroupsystemdevicegroup.groupid) AS groupname, linkgroupsystemdevicegroup.groupidbelone, ( SELECT systemdevicegroup.strname
           FROM systemdevicegroup
          WHERE systemdevicegroup.id = linkgroupsystemdevicegroup.groupidbelone) AS groupnamebelone
   FROM linkgroupsystemdevicegroup;

ALTER TABLE linkgroupsystemdevicegroupview OWNER TO postgres;

-- Function: view_devicegroupsystemdevicegroupview_retrieve(integer, integer, timestamp without time zone, integer, character varying)

-- DROP FUNCTION view_devicegroupsystemdevicegroupview_retrieve(integer, integer, timestamp without time zone, integer, character varying);

CREATE OR REPLACE FUNCTION view_devicegroupsystemdevicegroupview_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer, stypename character varying)
  RETURNS SETOF devicegroupsystemdevicegroupview AS
$BODY$
declare
	r devicegroupsystemdevicegroupview%rowtype;
	t timestamp without time zone;
BEGIN
	if uid=-1 then
		select modifytime into t from objtimestamp where typename=stypename;
	else
		select modifytime into t from objtimestamp where typename=stypename and userid=uid;
	end if;
	
	if t is null or t>dt then
		if imax <0 then
			for r in select * from devicegroupsystemdevicegroupview where groupid in (SELECT id FROM devicegroup where id>ibegin order by id) order by groupid loop
			return next r;
			end loop;
		else
			for r in select * from devicegroupsystemdevicegroupview where groupid in (SELECT id FROM devicegroup where id>ibegin order by id limit imax) order by groupid loop			
			return next r;
			end loop;

		end if;	
	end if;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION view_devicegroupsystemdevicegroupview_retrieve(integer, integer, timestamp without time zone, integer, character varying) OWNER TO postgres;

-- Function: view_linkgroupsystemdevicegroupview_retrieve(integer, integer, timestamp without time zone, integer, character varying)

-- DROP FUNCTION view_linkgroupsystemdevicegroupview_retrieve(integer, integer, timestamp without time zone, integer, character varying);

CREATE OR REPLACE FUNCTION view_linkgroupsystemdevicegroupview_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer, stypename character varying)
  RETURNS SETOF linkgroupsystemdevicegroupview AS
$BODY$
declare
	r linkgroupsystemdevicegroupview%rowtype;
	t timestamp without time zone;
BEGIN	
	if uid=-1 then
		select modifytime into t from objtimestamp where typename=stypename;
	else
		select modifytime into t from objtimestamp where typename=stypename and userid=uid;
	end if;
	
	if t is null or t>dt then
		if imax <0 then
			for r in select * from linkgroupsystemdevicegroupview where groupid in (SELECT id FROM linkgroup where id>ibegin and userid=uid order by id) order by id loop
			return next r;
			end loop;
		else
			for r in select * from linkgroupsystemdevicegroupview where groupid in (SELECT id FROM linkgroup where id>ibegin and userid=uid order by id limit imax) order by id loop			
			return next r;
			end loop;

		end if;	
	end if;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION view_linkgroupsystemdevicegroupview_retrieve(integer, integer, timestamp without time zone, integer, character varying) OWNER TO postgres;



--------------   system_devicespec
ALTER TABLE system_devicespec ADD COLUMN strshowstpcmd character varying(100);
ALTER TABLE system_devicespec ALTER COLUMN strshowstpcmd SET STORAGE EXTENDED;


DROP TRIGGER system_devicespec_dt ON system_devicespec;
DROP FUNCTION process_system_devicespec_dt();

CREATE OR REPLACE FUNCTION process_system_devicespec_dt()
  RETURNS trigger AS
$BODY$

    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.strvendorname = NEW.strvendorname AND 
			OLD.strmodelname = NEW.strmodelname AND
			OLD.idevicetype = NEW.idevicetype AND
			OLD.strcpuoid = NEW.strcpuoid AND
			OLD.strmemoid = NEW.strmemoid AND
			OLD.strshowruncmd = NEW.strshowruncmd AND
			OLD.strshowiproutecmd = NEW.strshowiproutecmd AND
			OLD.strshowroutecountcmd = NEW.strshowroutecountcmd AND
			OLD.strshowarpcmd = NEW.strshowarpcmd AND
			OLD.strshowcamcmd = NEW.strshowcamcmd AND
			OLD.strpage1cmd = NEW.strpage1cmd AND
			OLD.strloginprompt = NEW.strloginprompt AND
			OLD.strpasswordprompt = NEW.strpasswordprompt AND
			OLD.strprivilegeprompt = NEW.strprivilegeprompt AND
			OLD.strnonprivilegeprompt = NEW.strnonprivilegeprompt AND
			OLD.strconfigprompt = NEW.strconfigprompt AND
			OLD.strtoenablecmd = NEW.strtoenablecmd AND
			OLD.strtoconfigcmd = NEW.strtoconfigcmd AND
			OLD.stryesnoprompt = NEW.stryesnoprompt AND
			OLD.ipasswordinterval = NEW.ipasswordinterval AND
			OLD.iflag = NEW.iflag AND
			OLD.bmodified = NEW.bmodified AND
			OLD.strshowcdpcmd = NEW.strshowcdpcmd AND
			OLD.strinvalidcommandkey = NEW.strinvalidcommandkey AND
			OLD.strquit = NEW.strquit AND
			OLD.strshowstpcmd = NEW.strshowstpcmd
		 then
			return OLD;
		end IF;
		update objtimestamp set modifytime=now() where typename='VendorModel_DeviceSpec';
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='VendorModel_DeviceSpec';
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='VendorModel_DeviceSpec';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION process_system_devicespec_dt() OWNER TO postgres;   


CREATE TRIGGER system_devicespec_dt
  BEFORE INSERT OR UPDATE OR DELETE
  ON system_devicespec
  FOR EACH ROW
  EXECUTE PROCEDURE process_system_devicespec_dt();

-----------------------------stp show command
UPDATE system_devicespec SET strshowstpcmd='show spanning-tree blockedports' WHERE idevicetype=2001 AND strshowstpcmd is null;
UPDATE system_devicespec SET strshowstpcmd='show spantree blockedports' WHERE idevicetype=2060 AND strshowstpcmd is null;


-- Function: devicegroupdevice_delete_static(integer)

-- DROP FUNCTION devicegroupdevice_delete_static(integer);

CREATE OR REPLACE FUNCTION devicegroupdevice_delete_static(gid integer)
  RETURNS boolean AS
$BODY$

BEGIN
	delete from  devicegroupdevice where devicegroupid=gid and "type"=1;
	return true;
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION devicegroupdevice_delete_static(integer) OWNER TO postgres;

---------------------------------------dynamic device group site child

ALTER TABLE devicegroupsite ADD COLUMN sitechild integer NOT NULL DEFAULT 0;
ALTER TABLE devicegroupsite ALTER COLUMN sitechild SET STORAGE PLAIN;
ALTER TABLE devicegroupsite ALTER COLUMN sitechild SET NOT NULL;
ALTER TABLE devicegroupsite ALTER COLUMN sitechild SET DEFAULT 0;

ALTER TABLE linkgroupsite ADD COLUMN sitechild integer NOT NULL DEFAULT 0;
ALTER TABLE linkgroupsite ALTER COLUMN sitechild SET STORAGE PLAIN;
ALTER TABLE linkgroupsite ALTER COLUMN sitechild SET NOT NULL;
ALTER TABLE linkgroupsite ALTER COLUMN sitechild SET DEFAULT 0;

CREATE OR REPLACE VIEW devicegroupsiteview AS 
 SELECT devicegroupsite.id, devicegroupsite.groupid AS devicegroupid, ( SELECT devicegroup.strname
           FROM devicegroup
          WHERE devicegroup.id = devicegroupsite.groupid) AS devicegroupname, devicegroupsite.siteid AS devicegroupsiteid, ( SELECT site.name
           FROM site
          WHERE site.id = devicegroupsite.siteid) AS devicegroupsitename, devicegroupsite.sitechild
   FROM devicegroupsite;

ALTER TABLE devicegroupsiteview OWNER TO postgres;

CREATE OR REPLACE VIEW linkgroupsiteview AS 
 SELECT linkgroup.id, linkgroupsite.siteid, ( SELECT site.name
           FROM site
          WHERE site.id = linkgroupsite.siteid) AS sitename, linkgroupsite.sitechild
   FROM linkgroup, linkgroupsite
  WHERE linkgroupsite.groupid = linkgroup.id;

ALTER TABLE linkgroupsiteview OWNER TO postgres;

ALTER TABLE devicegroupsite DROP CONSTRAINT devicegroupsite_uniq_groupid;

ALTER TABLE devicegroupsite
  ADD CONSTRAINT devicegroupsite_uniq_groupid UNIQUE(groupid, siteid, sitechild);

ALTER TABLE linkgroupsite
  ADD CONSTRAINT linkgroupsite_uniq_lkgroupid UNIQUE(groupid, siteid, sitechild);

-------------------------------------fix bug  devicegroup devices count incorrect

DROP FUNCTION view_devicegroup_retrieve(integer, integer, timestamp without time zone, integer, character varying);

DROP VIEW devicegroupview;

CREATE OR REPLACE VIEW devicegroupview AS 
SELECT devicegroup.id, devicegroup.strname, devicegroup.strdesc, devicegroup.userid, devicegroup.showcolor, ( SELECT count(*) AS count
           FROM  (
select distinct devicegroupdevice.devicegroupid ,devicegroupdevice.deviceid from devicegroupdevice
) as uniqdevicegroupdevice
          WHERE uniqdevicegroupdevice.devicegroupid = devicegroup.id) AS irefcount, devicegroup.searchcondition, devicegroup.searchcontainer
   FROM devicegroup
  ORDER BY devicegroup.id;

ALTER TABLE devicegroupview OWNER TO postgres;

CREATE OR REPLACE FUNCTION view_devicegroup_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer, stypename character varying)
  RETURNS SETOF devicegroupview AS
$BODY$
declare
	r devicegroupview%rowtype;
	t timestamp without time zone;
BEGIN
	if uid=-1 then
		select modifytime into t from objtimestamp where typename=stypename;
	else
		select modifytime into t from objtimestamp where typename=stypename and userid=uid;
	end if;
	
	if t is null or t>dt then
		if imax <0 then
			for r in SELECT * FROM devicegroupview where id>ibegin and userid=uid loop
			return next r;
			end loop;
		else
			for r in SELECT * FROM devicegroupview where id>ibegin and userid=uid limit imax loop
			return next r;
			end loop;

		end if;	
	end if;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION view_devicegroup_retrieve(integer, integer, timestamp without time zone, integer, character varying) OWNER TO postgres;



DROP FUNCTION devicelistnofiler(integer, integer);

CREATE OR REPLACE FUNCTION devicelistnofiler(pageindexsize integer, pagesize integer, devnames character varying[])
  RETURNS SETOF devicesettingview_weblist AS
$BODY$

DECLARE
    r devicesettingview_weblist%rowtype;
BEGIN				     
		    FOR r IN select * from devicesettingview_weblist where devicename= any(devnames) and id not in ( select id from devicesettingview_weblist where devicename= any(devnames) order by lower(devicename) limit pageindexsize ) order by lower(devicename) limit pagesize LOOP
			RETURN NEXT r;
		     END LOOP;		     		
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION devicelistnofiler(integer, integer, character varying[]) OWNER TO postgres;


DROP FUNCTION devicelistbygroupnofilerbytype(integer, integer, integer);

CREATE OR REPLACE FUNCTION devicelistbygroupnofilerbytype(pageindexsize integer, pagesize integer, types integer,devnames character varying[])
  RETURNS SETOF devicesettingview_weblist AS
$BODY$

DECLARE
    r devicesettingview_weblist%rowtype;
BEGIN			     		     
		     FOR r IN select * from devicesettingview_weblist where devicename= any(devnames) and subtype = types and  id not in ( select id from devicesettingview_weblist where devicename= any(devnames) and  subtype = types order by lower(devicename) limit pageindexsize ) order by lower(devicename) limit pagesize LOOP
			RETURN NEXT r;
		     END LOOP;		     				     
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION devicelistbygroupnofilerbytype(integer, integer, integer,character varying[]) OWNER TO postgres;



DROP FUNCTION devicelistbygroupnofiler(integer, integer, integer);

CREATE OR REPLACE FUNCTION devicelistbygroupnofiler(groupid integer, pageindexsize integer, pagesize integer,devnames character varying[])
  RETURNS SETOF devicesettingview_weblist AS
$BODY$

DECLARE
    r devicesettingview_weblist%rowtype;
BEGIN			     
		     FOR r IN select * from devicesettingview_weblist where devicename= any(devnames) and  deviceid in (select deviceid from devicegroupdeviceview where devicename= any(devnames) and  devicegroupid =groupid and deviceid not in (select deviceid from devicegroupdeviceview where devicename= any(devnames) and  devicegroupid =groupid order by lower(devicename) limit pageindexsize) order by lower(devicename) limit pagesize ) order by lower(devicename) LOOP
			RETURN NEXT r;
		     END LOOP;			     
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION devicelistbygroupnofiler(integer, integer, integer,character varying[]) OWNER TO postgres;

DROP FUNCTION devicelist(integer, integer, integer[]);

CREATE OR REPLACE FUNCTION devicelist(pageindexsize integer, pagesize integer, filer integer[], devnames character varying[])
  RETURNS SETOF devicesettingview AS
$BODY$

DECLARE
    r devicesettingview%rowtype;
BEGIN		
		     FOR r IN select * from devicesettingview where subtype=any( filer ) and devicename=any(devnames) and id not in (select id from devicesettingview where subtype=any( filer ) and devicename=any(devnames) order by lower(devicename) limit pageindexsize) order by lower(devicename) limit pagesize LOOP
			RETURN NEXT r;
		     END LOOP;	     		    
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION devicelist(integer, integer, integer[], character varying[]) OWNER TO postgres;


DROP FUNCTION devicelistbygroup(integer, integer, integer, integer[]);

CREATE OR REPLACE FUNCTION devicelistbygroup(groupid integer, pageindexsize integer, pagesize integer, filer integer[],devnames character varying[])
  RETURNS SETOF devicesettingview AS
$BODY$

DECLARE
    r devicesettingview%rowtype;
BEGIN		
		     FOR r IN select * from devicesettingview where deviceid in (select deviceid from devicegroupdeviceview where isubtype=any( filer ) and devicename=any(devnames) and devicegroupid=groupid and devicename not in (select devicename from devicegroupdeviceview where isubtype=any( filer ) and devicename=any(devnames) and devicegroupid=groupid order by lower(devicename) limit pageindexsize) order by lower(devicename) limit pagesize)  order by devicename LOOP
			RETURN NEXT r;
		     END LOOP;	     			     
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION devicelistbygroup(integer, integer, integer, integer[],character varying[]) OWNER TO postgres;


DROP FUNCTION searchalldevicenofiler(character varying, integer, integer[]);

CREATE OR REPLACE FUNCTION searchalldevicenofiler(devname character varying, preid integer, types integer[],devnames character varying[])
  RETURNS SETOF devicesettingview AS
$BODY$

DECLARE
    r devicesettingview%rowtype;
    npreid integer;
BEGIN	
     npreid:=0;
     FOR r IN select * from devicesettingview  where devicename=any(devnames) and lower(devicename) like '%'||devname||'%' and subtype = any( types ) order by lower(devicename) LOOP
	if npreid=preid then 
	    return next r;
	    return;
	end if;
	npreid := r.id;	
     END LOOP;
     return ;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION searchalldevicenofiler(character varying, integer, integer[],character varying[]) OWNER TO postgres;


DROP FUNCTION searchalldevicenofiler(character varying, integer);

CREATE OR REPLACE FUNCTION searchalldevicenofiler(devname character varying, preid integer,devnames character varying[])
  RETURNS SETOF devicesettingview AS
$BODY$

DECLARE
    r devicesettingview%rowtype;
    npreid integer;
BEGIN	
     npreid:=0;
     FOR r IN select * from devicesettingview  where devicename=any(devnames) and lower(devicename) like '%'||devname||'%' order by lower(devicename) LOOP
	if npreid=preid then 
	    return next r;
	    return;
	end if;
	npreid := r.id;	
     END LOOP;
     return ;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION searchalldevicenofiler(character varying, integer,character varying[]) OWNER TO postgres;


DROP FUNCTION searchdevicebygroupnofiler(character varying, integer, integer);

CREATE OR REPLACE FUNCTION searchdevicebygroupnofiler(devname character varying, gid integer, preid integer,devnames character varying[])
  RETURNS SETOF devicesettingview AS
$BODY$

DECLARE
    r devicesettingview%rowtype;
    npreid integer;
BEGIN
     npreid:=0;	
     FOR r IN select * from devicesettingview where deviceid in (select deviceid from devicegroupdeviceview where devicename=any(devnames) and devicegroupid=gid and lower(devicename) like '%'||devname||'%') order by lower(devicename)   LOOP
	if npreid=preid then 
	    return next r;
	    return;
	end if;
	npreid := r.id;	
     END LOOP;
     return ;		
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION searchdevicebygroupnofiler(character varying, integer, integer,character varying[]) OWNER TO postgres;


DROP FUNCTION searchdevicebygroupnofiler(character varying, integer, integer, integer[]);

CREATE OR REPLACE FUNCTION searchdevicebygroupnofiler(devname character varying, gid integer, preid integer, types integer[],devnames character varying[])
  RETURNS SETOF devicesettingview AS
$BODY$

DECLARE
    r devicesettingview%rowtype;
    npreid integer;
BEGIN
     npreid:=0;	
     FOR r IN select * from devicesettingview where devicename=any(devnames) and subtype = any( types ) and  deviceid in (select deviceid from devicegroupdeviceview where devicename=any(devnames) and devicegroupid=gid and subtype = any( types ) and lower(devicename) like '%'||devname||'%' ) order by lower(devicename)  LOOP
	if npreid=preid then 
	    return next r;
	    return;
	end if;
	npreid := r.id;	
     END LOOP;
     return ;		
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION searchdevicebygroupnofiler(character varying, integer, integer, integer[],character varying[]) OWNER TO postgres;


---------------------------------------------Reset Workspace

CREATE OR REPLACE FUNCTION workspace_reset()
  RETURNS integer AS
$BODY$
declare
	r character varying(256);
	retsv character varying(256);
	indextempty integer;
BEGIN
	retsv='';
	indextempty=0;
	FOR r IN SELECT tablename FROM pg_tables WHERE tablename NOT LIKE 'pg%' AND tablename NOT LIKE 'sql_%' ORDER BY tablename LOOP
		EXECUTE 'select count(*) from' || r ;
		retsv=r;
		if retsv!='adminpwd' AND retsv!='benchmarktask' AND retsv!='function' AND retsv!='globeinfo'
			AND retsv!='objtimestamp' AND retsv!='role' AND retsv!='role2virtualfunction' AND retsv!='user' 
			AND retsv!='user2role' AND retsv!='virtualfunction' AND retsv!='virtualfunction2function' 
			AND retsv!='system_devicespec' AND retsv!='system_vendormodel' then
			execute 'delete from ' || r ||' CASCADE';
			indextempty=indextempty +1;		
		end if;
	END LOOP;
		    
	update objtimestamp set modifytime=now();
	--return sret;
	return indextempty;
End;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION workspace_reset() OWNER TO postgres;


------------------  add by zyuan
-- Function: devicegroupdevice_delete_dynamic(integer)

-- DROP FUNCTION devicegroupdevice_delete_dynamic(integer);

CREATE OR REPLACE FUNCTION devicegroupdevice_delete_dynamic(gid integer)
  RETURNS boolean AS
$BODY$

BEGIN
	delete from  devicegroupdevice where devicegroupid=gid and "type"=2;
	return true;
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION devicegroupdevice_delete_dynamic(integer) OWNER TO postgres;

-- Function: devicegroupdevice_upsert_dynamic(integer, character varying[])

-- DROP FUNCTION devicegroupdevice_upsert_dynamic(integer, character varying[]);



CREATE OR REPLACE FUNCTION devicegroupdevice_upsert_dynamic(gid integer, ds character varying[])
  RETURNS boolean AS
$BODY$
DECLARE
    r integer;
    dg_id integer;
BEGIN
	for r in select id from devices where strname = any(ds) LOOP
		select id into dg_id from devicegroupdevice where devicegroupid = gid and deviceid = r and "type" = 2;
		if dg_id is null then
			insert into devicegroupdevice (devicegroupid,deviceid,"type") values (gid, r, 2);              
		end if;
	end loop;	
	return true;
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION devicegroupdevice_upsert_dynamic(integer, character varying[]) OWNER TO postgres;





-- Function: linkgroupinterface_delete_dynamic(integer)

-- DROP FUNCTION linkgroupinterface_delete_dynamic(integer);

CREATE OR REPLACE FUNCTION linkgroupinterface_delete_dynamic(lid integer)
  RETURNS boolean AS
$BODY$
BEGIN
	delete from linkgroupinterface where groupid = lid and "type" = 2;
	return true;
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION linkgroupinterface_delete_dynamic(integer) OWNER TO postgres;



-- Function: linkgroupinterface_upsert_dynamic(integer, character varying[], character varying[], character varying[])

-- DROP FUNCTION linkgroupinterface_upsert_dynamic(integer, character varying[], character varying[], character varying[]);

CREATE OR REPLACE FUNCTION linkgroupinterface_upsert_dynamic(lid integer, devs character varying[], intfs character varying[], intfips character varying[])
  RETURNS boolean AS
$BODY$
DECLARE
    i integer;
    intf_id integer;
    lgi_id integer;
BEGIN
	for i in 1..array_length(devs, 1) LOOP
		select id into intf_id from interfacesetting where interfacename = intfs[i] and deviceid = (select id from devices where strname = devs[i]);
		if intf_id is null then
			continue;
		end if;
		select id into lgi_id from linkgroupinterface where groupid = lid and interfaceid = intf_id and "type" = 2 and interfaceip = intfips[i];
		if lgi_id is null then
			insert into linkgroupinterface (groupid,interfaceid,"type",interfaceip) values (lid, intf_id, 2, intfips[i]);
		end if;
	end loop;	
	return true;
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION linkgroupinterface_upsert_dynamic(integer, character varying[], character varying[], character varying[]) OWNER TO postgres;

--------------------------------benchmark modify


ALTER TABLE benchmarktask ADD COLUMN stptable integer not null default 1;
ALTER TABLE benchmarktask ALTER COLUMN stptable SET STORAGE PLAIN;

ALTER TABLE benchmarktask ADD COLUMN inventoryinfo integer not null default 1;
ALTER TABLE benchmarktask ALTER COLUMN inventoryinfo SET STORAGE PLAIN;

ALTER TABLE benchmarktask drop COLUMN buildl2;
ALTER TABLE benchmarktask drop COLUMN buildl3;

ALTER TABLE benchmarktask ADD COLUMN buildcontent integer not null default 15;
ALTER TABLE benchmarktask ALTER COLUMN buildcontent SET STORAGE PLAIN;

update benchmarktask set strname='System Benchmark' where id =1;

-------------------------------------- remove snmpro un_key
ALTER TABLE nomp_snmproinfo DROP CONSTRAINT nomp_snmpro_un_rostring;

-------------------------------------- get device interfacename

CREATE OR REPLACE VIEW interfacenameview AS 
 SELECT interfacesetting.interfacename
   FROM interfacesetting;

ALTER TABLE interfacenameview OWNER TO postgres;


CREATE OR REPLACE FUNCTION interface_list_groupbydevice(devname character varying)
  RETURNS SETOF interfacenameview AS
$BODY$
declare
	rec interfacenameview;
	indextmp integer;
	ndevcount integer;
BEGIN
	for rec in select interfacename from interfacesettingview where devicename=devname loop
		return next rec;
	end loop;
	return;
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION interface_list_groupbydevice(character varying) OWNER TO postgres;


-------------------------
ALTER TABLE benchmarktaskstatus drop COLUMN runstatus;
ALTER TABLE benchmarktaskstatus drop COLUMN logdetail;
ALTER TABLE benchmarktaskstatus ADD COLUMN result integer;
ALTER TABLE benchmarktaskstatus ALTER COLUMN result SET STORAGE PLAIN;

update benchmarktaskstatus set result=1 where result is NULL;

CREATE TABLE benchmarktaskstatusstep
(
  id serial NOT NULL,
  statusid integer,
  steptype integer NOT NULL,
  begintime timestamp without time zone,
  endtime timestamp without time zone,
  result integer,
  CONSTRAINT benchmarktaskstatusstep_pk_id PRIMARY KEY (id),
  CONSTRAINT benchmarktaskstatusstep_fk_statusid FOREIGN KEY (statusid)
      REFERENCES benchmarktaskstatus (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT benchmarktaskstatusstep_statusid UNIQUE (statusid, steptype)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE benchmarktaskstatusstep OWNER TO postgres;

CREATE TABLE benchmarktaskstatussteplog
(
  id serial NOT NULL,
  stepid integer NOT NULL,
  loglevel integer NOT NULL DEFAULT 0,
  strlog text,
  stamp timestamp without time zone DEFAULT now(),
  CONSTRAINT benchmarktaskstatussteplog_pk_id PRIMARY KEY (id),
  CONSTRAINT benchmarktaskstatussteplog_fk_stepid FOREIGN KEY (stepid)
      REFERENCES benchmarktaskstatusstep (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
ALTER TABLE benchmarktaskstatussteplog OWNER TO postgres;

-- Index: fki_benchmarktaskstatussteplog_fk_stepid

-- DROP INDEX fki_benchmarktaskstatussteplog_fk_stepid;

CREATE INDEX fki_benchmarktaskstatussteplog_fk_stepid
  ON benchmarktaskstatussteplog
  USING btree
  (stepid);

---------------------------------------------workspace_reset();
CREATE OR REPLACE FUNCTION workspace_reset()
  RETURNS integer AS
$BODY$
declare
	r character varying(256);
	retsv character varying(256);
	indextempty integer;
BEGIN
	retsv='';
	indextempty=0;
	FOR r IN SELECT tablename FROM pg_tables WHERE tablename NOT LIKE 'pg%' AND tablename NOT LIKE 'sql_%' ORDER BY tablename LOOP
		EXECUTE 'select count(*) from' || r ;
		retsv=r;
		if retsv!='adminpwd' AND retsv!='benchmarktask' AND retsv!='function' AND retsv!='globeinfo'
			AND retsv!='objtimestamp' AND retsv!='role' AND retsv!='role2virtualfunction' AND retsv!='user' 
			AND retsv!='user2role' AND retsv!='virtualfunction' AND retsv!='virtualfunction2function' 
			AND retsv!='system_devicespec' AND retsv!='system_vendormodel'  AND retsv!='site' 
			AND retsv!='nomp_appliance' AND retsv!='site2site' AND retsv!='system_info' then
			execute 'delete from ' || r ||' CASCADE';
			execute 'truncate table ' || r||' CASCADE';			
			indextempty=indextempty +1;		
		end if;
	END LOOP;
	delete from site CASCADE where id>1;
	delete from site2site CASCADE where id>1;
	delete from nomp_appliance CASCADE where id>0;
	EXECUTE 'SELECT pg_catalog.setval(''devices_id_seq'', 1, true)';
	update objtimestamp set modifytime=now();
	delete from system_info CASCADE where id>1;
	--return sret;
	return indextempty;
End;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION workspace_reset() OWNER TO postgres;

--------------------------------------------bug 33103
alter table system_devicespec ALTER strshowcamcmd TYPE character varying(64);

UPDATE system_devicespec SET strshowcamcmd=strshowcamcmd || '||show mac add' WHERE idevicetype=2001 and position('||show mac add' in strshowcamcmd)<1;

-----------------------------------------device_site_set2
-- Function: device_site_set2(integer, character varying[])

-- DROP FUNCTION device_site_set2(integer, character varying[]);

CREATE OR REPLACE FUNCTION device_site_set2(nsiteid integer, devnames character varying[])
  RETURNS integer AS
$BODY$
declare
	nparentid integer;
	ndeviceid integer;
BEGIN	
	select parentid into nparentid from site2site where siteid=nsiteid;
	
	if nparentid IS NULL THEN
		return -1;
	end if;

	if nparentid >0 THEN
		update devicesitedevice set siteid=nparentid where siteid=nsiteid ;
	end if;

	for ndeviceid in select id from devices where strname = any( devnames ) LOOP	       
		if (select count(*) from devicesitedevice where deviceid =ndeviceid)<1 then
			INSERT INTO devicesitedevice(siteid, deviceid)VALUES (nsiteid, ndeviceid);
		end if;
		update devicesitedevice set siteid=nsiteid where deviceid =ndeviceid;             
	end loop;

	update site set lasttimestamp=now() where id=nsiteid;
	update objtimestamp set modifytime=now() where typename='site';
	return 1;

END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION device_site_set2(integer, character varying[]) OWNER TO postgres;

--------------------------------------------setdevicetodevicegroup  linkgroup 

CREATE OR REPLACE FUNCTION devicegroupdevice_upsert_static(gid integer, ds character varying[])
  RETURNS boolean AS
$BODY$
DECLARE
    r integer;
    dg_id integer;
BEGIN
	for r in select id from devices where strname = any(ds) LOOP
		select id into dg_id from devicegroupdevice where devicegroupid = gid and deviceid = r and "type" = 1;
		if dg_id is null then
			insert into devicegroupdevice (devicegroupid,deviceid,"type") values (gid, r, 1);              
		end if;
	end loop;	
	return true;
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION devicegroupdevice_upsert_static(integer, character varying[]) OWNER TO postgres;


CREATE OR REPLACE FUNCTION linkgroupinterface_delete_bytype(lid integer,ntype integer)
  RETURNS boolean AS
$BODY$
BEGIN
	delete from linkgroupinterface where groupid = lid and "type" =ntype;
	return true;
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION linkgroupinterface_delete_bytype(integer,integer) OWNER TO postgres;



CREATE OR REPLACE FUNCTION linkgroupinterface_upsert_bytype2(lid integer, ntype integer, devs character varying[], intfs character varying[], intfips character varying[])
  RETURNS boolean AS
$BODY$
DECLARE
    i integer;
    intf_id integer;
    lgi_id integer;
    dev_id integer;
BEGIN
	for i in 1..array_length(devs, 1) LOOP
		
		select id into dev_id from devices where strname = devs[i];
		if dev_id is null then
			continue;
		end if;
		
		select id into intf_id from interfacesetting where interfacename = intfs[i] and deviceid = (select id from devices where strname = devs[i]);
		if intf_id is null then
			continue;
		end if;
		select id into lgi_id from linkgroupinterface where groupid = lid and interfaceid = intf_id and "type" =ntype and interfaceip = intfips[i];
		if lgi_id is null then
			insert into linkgroupinterface (groupid,interfaceid,"type",interfaceip) values (lid, intf_id,ntype, intfips[i]);
		end if;
	end loop;	
	return true;
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION linkgroupinterface_upsert_bytype2(integer, integer, character varying[], character varying[], character varying[]) OWNER TO postgres;


---------------------------------------devicelistsearch

CREATE OR REPLACE FUNCTION devicelistsearch(devnamesearch character varying, filer integer[], devnames character varying[])
  RETURNS integer AS
$BODY$

DECLARE
    r_id integer;
    nid integer;
    r devicesettingview%rowtype;
BEGIN
	r_id=-1;
	nid=0;
     FOR r IN select * from devicesettingview where subtype=any( filer ) and devicename=any(devnames) order by lower(devicename) LOOP
	nid=nid +1;
	if position(devnamesearch in lower(r.devicename))>0 THEN
		if r_id <0 then
			r_id=nid;
		end if;
		return nid;
	end if;
     END LOOP;	
     return r_id;     		    
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION devicelistsearch(character varying, integer[], character varying[]) OWNER TO postgres;

---------------------------------------linkgroupinterface modify 
alter TABLE linkgroupinterface DROP CONSTRAINT linkgroupinterface_fk_interface;

ALTER TABLE linkgroupinterface ADD COLUMN deviceid integer;

ALTER TABLE linkgroupinterface ADD CONSTRAINT linkgroupinterface_fk_devices FOREIGN KEY (deviceid) REFERENCES devices (id) MATCH SIMPLE ON UPDATE NO ACTION ON DELETE CASCADE;

ALTER TABLE linkgroupinterface DROP CONSTRAINT linkgroupinterface_uniq_git;

ALTER TABLE linkgroupinterface  ADD CONSTRAINT linkgroupinterface_uniq_git UNIQUE(groupid, type, interfaceid, interfaceip,deviceid);


CREATE OR REPLACE VIEW linkgroupinterfaceview AS 
 SELECT linkgroupinterface.id, linkgroupinterface.groupid, linkgroupinterface.interfaceid, linkgroupinterface.interfaceip, linkgroupinterface.type, ( SELECT interfacesetting.interfacename
           FROM interfacesetting
          WHERE interfacesetting.id = linkgroupinterface.interfaceid) AS interfacename, linkgroupinterface.deviceid, ( SELECT devices.strname
           FROM devices
          WHERE devices.id = linkgroupinterface.deviceid) AS devicename, ( SELECT devices.isubtype
           FROM devices
          WHERE devices.id = linkgroupinterface.deviceid) AS isubtype
   FROM linkgroupinterface;

ALTER TABLE linkgroupinterfaceview OWNER TO postgres;


CREATE OR REPLACE FUNCTION linkgroupinterface_upsert_bytype2(lid integer, ntype integer, devs character varying[], intfs character varying[], intfips character varying[])
  RETURNS boolean AS
$BODY$
DECLARE
    i integer;
    intf_id integer;
    lgi_id integer;
    dev_id integer;
BEGIN
	for i in 1..array_length(devs, 1) LOOP
		
		select id into dev_id from devices where strname = devs[i];
		if dev_id is null then
			continue;
		end if;
		
		select id into intf_id from interfacesetting where interfacename = intfs[i] and deviceid = (select id from devices where strname = devs[i]);
		if intf_id is null then
			intf_id=0;
		end if;
		select id into lgi_id from linkgroupinterface where groupid = lid and interfaceid = intf_id and "type" =ntype and interfaceip = intfips[i] and deviceid=dev_id;
		if lgi_id is null then
			insert into linkgroupinterface (groupid,interfaceid,"type",interfaceip,deviceid) values (lid, intf_id,ntype, intfips[i],dev_id);
		end if;
	end loop;	
	return true;
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION linkgroupinterface_upsert_bytype2(integer, integer, character varying[], character varying[], character varying[]) OWNER TO postgres;


CREATE OR REPLACE FUNCTION linkgroupinterface_upsert_dynamic(lid integer, devs character varying[], intfs character varying[], intfips character varying[])
  RETURNS boolean AS
$BODY$
DECLARE
    i integer;
    intf_id integer;
    lgi_id integer;
    dev_id integer;
BEGIN
	for i in 1..array_length(devs, 1) LOOP
	
		select id into dev_id from devices where strname = devs[i];
		if dev_id is null then
			continue;
		end if;
		
		select id into intf_id from interfacesetting where interfacename = intfs[i] and deviceid = dev_id;
		
		if intf_id is null then
			intf_id=0;
		end if;
		select id into lgi_id from linkgroupinterface where groupid = lid and interfaceid = intf_id and "type" = 2 and interfaceip = intfips[i] and deviceid=dev_id;
		if lgi_id is null then
			insert into linkgroupinterface (groupid,interfaceid,"type",interfaceip,deviceid) values (lid, intf_id, 2, intfips[i],dev_id);
		end if;
	end loop;	
	return true;
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION linkgroupinterface_upsert_dynamic(integer, character varying[], character varying[], character varying[]) OWNER TO postgres;

--------------------------------------------------fix bug 33604 refresh时download NAT 

CREATE OR REPLACE VIEW nattointfview AS 
 select nattointf.id
,(select insideglobal from nat where nat.id=nattointf.natid) as insideglobal
,(select insidelocal from nat where nat.id=nattointf.natid) as insidelocal
,(select outsideglobal from nat where nat.id=nattointf.natid) as outsideglobal
,(select outsidelocal from nat where nat.id=nattointf.natid) as outsidelocal
 ,(select strname from devices where devices.id=(select deviceid from nat where nat.id=nattointf.natid))as devicename
,(select interfacename from interfacesetting where interfacesetting.id=(select natinterface.inintfid from natinterface where natinterface.id= nattointf.natintfid)) as ininfname
,(select interfacename from interfacesetting where interfacesetting.id=(select natinterface.outintfid from natinterface where natinterface.id= nattointf.natintfid)) as outinfname 
 ,(select itype from nat where nat.id=nattointf.natid) as itype
 from nattointf;

ALTER TABLE nattointfview OWNER TO postgres;


CREATE OR REPLACE FUNCTION view_nattointf_view_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying)
  RETURNS SETOF nattointfview AS
$BODY$
declare
	r nattointfview%rowtype;
	t timestamp without time zone;
BEGIN		
	select modifytime into t from objtimestamp where typename=stypename;
	if t is null or t>dt then
		if imax <0 then
			for r in SELECT * FROM nattointfview where id>ibegin order by id  loop
			return next r;
			end loop;
		else
			for r in SELECT * FROM nattointfview where id>ibegin order by id limit imax loop
			return next r;
			end loop;

		end if;	
	End IF;		
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION view_nattointf_view_retrieve(integer, integer, timestamp without time zone, character varying) OWNER TO postgres;


-------------------------------------------------------linkgroupinterface produce

CREATE OR REPLACE FUNCTION process_linkgroupinterface_dt()
  RETURNS trigger AS
$BODY$
declare tid integer;
declare uid integer;
DECLARE newuserid integer;
DECLARE olduserid integer;
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.groupid = NEW.groupid AND 				
			OLD.interfaceid = NEW.interfaceid AND
			OLD."type" = NEW."type" AND
			OLD.interfaceip= NEW.interfaceip AND
			OLD.deviceid= NEW.deviceid
		then
			return OLD;
		end IF;
		select userid into newuserid from linkgroup where id=NEW.groupid;
		select userid into olduserid from linkgroup where id=old.groupid;

		if not newuserid=olduserid then
			update objtimestamp set modifytime=now() where typename='PublicLinkGroup';
			if newuserid=-1 then
				uid=olduserid;
			else 
				uid=newuserid;
			end if;
			select id into tid from objtimestamp where typename='PrivateLinkGroup' and userid=uid;
			if tid is null then
				insert into objtimestamp (typename,userid,modifytime) values('PrivateLinkGroup',uid,now());
			else
				update objtimestamp set modifytime=now() where typename='PrivateLinkGroup' and userid=uid;
			end if;
		elseif newuserid=-1 then
			update objtimestamp set modifytime=now() where typename='PublicLinkGroup';
		else
			select id into tid from objtimestamp where typename='PrivateLinkGroup' and userid=newuserid;
			if tid is null then
				insert into objtimestamp (typename,userid,modifytime) values('PrivateLinkGroup',newuserid,now());
			else
				update objtimestamp set modifytime=now() where typename='PrivateLinkGroup' and userid=newuserid;
			end if;	
		end if;		
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		select userid into newuserid from linkgroup where id=NEW.groupid;
		if newuserid=-1 then
			update objtimestamp set modifytime=now() where typename='PublicLinkGroup';
		else
			select id into tid from objtimestamp where typename='PrivateLinkGroup' and userid=newuserid;
			if tid is null then
				insert into objtimestamp (typename,userid,modifytime) values('PrivateLinkGroup',newuserid,now());
			else
				update objtimestamp set modifytime=now() where typename='PrivateLinkGroup' and userid=newuserid;
			end if;	
		end if;		
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		select userid into olduserid from linkgroup where id=old.groupid;
		if not olduserid is null then
			if olduserid=-1 then
				update objtimestamp set modifytime=now() where typename='PublicLinkGroup';
			else
				select id into tid from objtimestamp where typename='PrivateLinkGroup' and userid=olduserid;
				if tid is null then
					insert into objtimestamp (typename,userid,modifytime) values('PrivateLinkGroup',olduserid,now());
				else
					update objtimestamp set modifytime=now() where typename='PrivateLinkGroup' and userid=olduserid;
				end if;	
			end if;			
		end if;
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION process_linkgroupinterface_dt() OWNER TO postgres;


ALTER TABLE linkgroupinterface DROP CONSTRAINT linkgroupinterface_fk_devices;

UPDATE linkgroupinterface SET deviceid=(select interfacesetting.deviceid from interfacesetting where interfacesetting.id= linkgroupinterface.interfaceid ) where deviceid=NULL;

delete from linkgroupinterface where deviceid not in (select id from devices);

ALTER TABLE linkgroupinterface ADD CONSTRAINT linkgroupinterface_fk_devices FOREIGN KEY (deviceid) REFERENCES devices (id) MATCH SIMPLE ON UPDATE NO ACTION ON DELETE CASCADE;


----------------------------------------------------------fix bug 33493
UPDATE system_devicespec SET strinvalidcommandkey='Incomplete||Unknown||Invalid||Ambiguous||%' where strinvalidcommandkey='Incomplete|Unknown|Invalid|Ambiguous';
UPDATE system_devicespec SET strinvalidcommandkey='?||%' where strinvalidcommandkey='?|%';



CREATE OR REPLACE FUNCTION devicelist(devnames character varying[])
  RETURNS SETOF devicesettingview_weblist AS
$BODY$

DECLARE
    r devicesettingview_weblist%rowtype;
BEGIN			     
		     FOR r IN select * from devicesettingview_weblist where devicename= any(devnames)  order by lower(devicename) LOOP
			RETURN NEXT r;
		     END LOOP;			     
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION devicelist(character varying[]) OWNER TO postgres;



DROP FUNCTION devciebygroupid(integer);

CREATE OR REPLACE FUNCTION devciebygroupid(dgroupid integer)
  RETURNS SETOF devicegroupdeviceview AS
$BODY$

DECLARE
    r devicegroupdeviceview%rowtype;
BEGIN	
             FOR r IN select * from  devicegroupdeviceview where devicegroupid=dgroupid order by devicename LOOP
		RETURN NEXT r;
	     END LOOP;	     		
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION devciebygroupid(integer) OWNER TO postgres;



DROP FUNCTION devciebygroupid(integer, integer);
DROP FUNCTION devicebygrouplist(integer[]);
DROP FUNCTION devicelist(integer, integer, integer[], character varying[]);
DROP FUNCTION devicelistbygroup(integer, integer, integer, integer[], character varying[]);
DROP FUNCTION devicelistbygroupnofiler(integer, integer, integer, character varying[]);
DROP FUNCTION devicelistbygroupnofilerbytype(integer, integer, integer, character varying[]);
DROP FUNCTION devicelistnofiler(integer, integer, character varying[]);
DROP FUNCTION devicelistsearch(character varying, integer[], character varying[]);
DROP FUNCTION getdevicelistcountbygroup(integer, integer[]);
DROP FUNCTION getdevicelistcountbygroupnofiler(integer);


CREATE OR REPLACE FUNCTION view_deviceInterfacesetting_retrieve(ibegin integer, imax integer, dt timestamp without time zone)
  RETURNS SETOF devices AS
$BODY$
declare
	r devices%rowtype;	
BEGIN		
	if imax <0 then
			for r in SELECT * FROM devices where id in (select deviceid from interfacesetting where lasttimestamp>dt) and id>ibegin order by id loop
			return next r;
			end loop;
		else
			for r in SELECT * FROM devices where id in (select deviceid from interfacesetting where lasttimestamp>dt) and id>ibegin order by id limit imax loop
			return next r;
			end loop;

		end if;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION view_deviceInterfacesetting_retrieve(integer, integer, timestamp without time zone) OWNER TO postgres;




-- Bug 34544 - OE编辑某SNMP或Network Server，提交之后，数据库中的nomp_snmpinfo表和nomp_appliance表中的ipri字段对于记录的值被清零。如图
DROP TRIGGER appliance_pri ON nomp_appliance;
DROP FUNCTION process_appliance();

CREATE OR REPLACE FUNCTION process_appliance()
  RETURNS trigger AS
$BODY$
    BEGIN
        IF (TG_OP = 'UPDATE') THEN		
                NEW.ipri=OLD.ipri;
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN                
		NEW.ipri=nextval('nomp_appliance_ipri_seq'::regclass);						                				
		RETURN NEW;        
        END IF;
        RETURN NULL;
    END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION process_appliance() OWNER TO postgres;

CREATE TRIGGER appliance_pri
  BEFORE INSERT OR UPDATE
  ON nomp_appliance
  FOR EACH ROW
  EXECUTE PROCEDURE process_appliance();




DROP TRIGGER enablepassword_pri ON nomp_enablepasswd;
DROP FUNCTION process_enablepasswd();

CREATE OR REPLACE FUNCTION process_enablepasswd()
  RETURNS trigger AS
$BODY$
    BEGIN
        IF (TG_OP = 'UPDATE') THEN	
                NEW.ipri=OLD.ipri;	
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN                
		NEW.ipri=nextval('nomp_enablepasswd_ipri_seq'::regclass);						                				
		RETURN NEW;        
        END IF;
        RETURN NULL;
    END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION process_enablepasswd() OWNER TO postgres;

CREATE TRIGGER enablepassword_pri
  BEFORE INSERT OR UPDATE
  ON nomp_enablepasswd
  FOR EACH ROW
  EXECUTE PROCEDURE process_enablepasswd();




DROP TRIGGER jumpbox_pri ON nomp_jumpbox;
DROP FUNCTION process_jumpbox();

CREATE OR REPLACE FUNCTION process_jumpbox()
  RETURNS trigger AS
$BODY$
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
                NEW.ipri=OLD.ipri;		
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN                
		NEW.ipri=nextval('nomp_jumpbox_ipri_seq'::regclass);						                				
		RETURN NEW;        
        END IF;
        RETURN NULL;
    END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION process_jumpbox() OWNER TO postgres;

CREATE TRIGGER jumpbox_pri
  BEFORE INSERT OR UPDATE
  ON nomp_jumpbox
  FOR EACH ROW
  EXECUTE PROCEDURE process_jumpbox();  




DROP TRIGGER rostring_pri ON nomp_snmproinfo;
DROP FUNCTION process_snmprostring();

CREATE OR REPLACE FUNCTION process_snmprostring()
  RETURNS trigger AS
$BODY$
    BEGIN
        IF (TG_OP = 'UPDATE') THEN	
                NEW.ipri=OLD.ipri;	
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN                
		NEW.ipri=nextval('nomp_snmproinfo_ipri_seq'::regclass);						                				
		RETURN NEW;        
        END IF;
        RETURN NULL;
    END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION process_snmprostring() OWNER TO postgres;  

CREATE TRIGGER rostring_pri
  BEFORE INSERT OR UPDATE
  ON nomp_snmproinfo
  FOR EACH ROW
  EXECUTE PROCEDURE process_snmprostring();




 DROP TRIGGER snmprw_pri ON nomp_snmprwinfo;
 DROP FUNCTION process_snmprwstring();

 CREATE OR REPLACE FUNCTION process_snmprwstring()
  RETURNS trigger AS
$BODY$
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
                NEW.ipri=OLD.ipri;		
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN                
		NEW.ipri=nextval('nomp_snmprwinfo_ipri_seq'::regclass);						                				
		RETURN NEW;        
        END IF;
        RETURN NULL;
    END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION process_snmprwstring() OWNER TO postgres;

CREATE TRIGGER snmprw_pri
  BEFORE INSERT OR UPDATE
  ON nomp_snmprwinfo
  FOR EACH ROW
  EXECUTE PROCEDURE process_snmprwstring();




DROP TRIGGER telent_pri ON nomp_telnetinfo;
DROP FUNCTION process_telnetinfo();

CREATE OR REPLACE FUNCTION process_telnetinfo()
  RETURNS trigger AS
$BODY$
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
                NEW.ipri=OLD.ipri;		
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN                
		NEW.ipri=nextval('nomp_telnetinfo_ipri_seq'::regclass);						                				
		RETURN NEW;        
        END IF;
        RETURN NULL;
    END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION process_telnetinfo() OWNER TO postgres;  

CREATE TRIGGER telent_pri
  BEFORE INSERT OR UPDATE
  ON nomp_telnetinfo
  FOR EACH ROW
  EXECUTE PROCEDURE process_telnetinfo();
 



--Bug 34450 - 性能-Import Data性能问题

CREATE OR REPLACE FUNCTION site_customized_infoview_upsert(dciv site_customized_infoview)
  RETURNS integer AS
$BODY$
declare	
	ds_id integer;
	t_id integer;
BEGIN
	select id into ds_id from site where 'name'=dciv.sitename;
	if ds_id IS NULL THEN
		return -1;
	end if;

	select id into t_id from site_customized_infoview where objectid=ds_id and attributeid=dciv.attributeid ;
	if t_id IS NULL THEN		
		insert into site_customized_info(
			objectid,
			attributeid,
			attribute_value
			)
			values ( 
			ds_id,
			dciv.attributeid,
			dciv.attribute_value
		);

		return lastval();
	ELSE
		update site_customized_info set ( attribute_value)=( dciv.attribute_value ) where id = t_id;
		return t_id;
	end if;
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION site_customized_infoview_upsert(site_customized_infoview) OWNER TO postgres;  


-------------------------------bug 34435 same name  

CREATE OR REPLACE FUNCTION SiteNameExists(sname character varying, nid integer)
  RETURNS boolean AS
$BODY$
BEGIN
	if((select count(*) from site where id<>nid and lower("name") =lower(sname))=0) then
		return false;
	end if;
    
    RETURN true;
EXCEPTION
    WHEN OTHERS THEN 
	RETURN false;    
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION SiteNameExists(sname character varying, nid integer) OWNER TO postgres;


CREATE OR REPLACE FUNCTION DeviceGroupNameExists(sname character varying, nid integer,uid integer)
  RETURNS boolean AS
$BODY$
BEGIN
	if((select count(*) from devicegroup where id<>nid and lower(strname) =lower(sname) and userid=uid )=0) then
		return false;
	end if;
    
    RETURN true;
EXCEPTION
    WHEN OTHERS THEN 
	RETURN false;    
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION DeviceGroupNameExists(sname character varying, nid integer,uid integer) OWNER TO postgres;


CREATE OR REPLACE FUNCTION LinkGroupNameExists(sname character varying, nid integer,uid integer)
  RETURNS boolean AS
$BODY$
BEGIN
	if((select count(*) from linkgroup where id<>nid and lower(strname) =lower(sname) and userid=uid )=0) then
		return false;
	end if;
    
    RETURN true;
EXCEPTION
    WHEN OTHERS THEN 
	RETURN false;    
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION LinkGroupNameExists(sname character varying, nid integer,uid integer) OWNER TO postgres;


-- Function: process_site_dt()

-- DROP FUNCTION process_site_dt();

CREATE OR REPLACE FUNCTION process_site_dt()
  RETURNS trigger AS
$BODY$
		
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.id = NEW.id AND 			
			OLD.name = NEW.name AND 			
			OLD.region = NEW.region AND 						
			OLD.location_address = NEW.location_address AND
			OLD.employee_number = NEW.employee_number AND
			OLD.contact_name = NEW.contact_name AND
			OLD.phone_number = NEW.phone_number AND
			OLD.email = NEW.email AND
			OLD.type = NEW.type AND
			OLD.color = NEW.color AND
			OLD.comment = NEW.comment 			
		 then
			return OLD;
		end IF;
		
		if(SiteNameExists(New.name,NEW.id)=true) then
			RAISE EXCEPTION 'name exists';
		end if;
		
		update objtimestamp set modifytime=now() where typename='site';
		NEW.lasttimestamp=now();	
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN

		if(SiteNameExists(New.name,0)=true) then
			RAISE EXCEPTION 'name exists';
		end if;

		update objtimestamp set modifytime=now() where typename='site';
		NEW.lasttimestamp=now();
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='site';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION process_site_dt() OWNER TO postgres;


-- Function: process_devicegroup_dt()

-- DROP FUNCTION process_devicegroup_dt();

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
			OLD.showcolor = NEW.showcolor AND
			OLD.searchcondition= NEW.searchcondition AND
			OLD.searchcontainer = NEW.searchcontainer
		then
			return OLD;
		end IF;

		if(DeviceGroupNameExists(New.strname,NEW.id,New.userid)=true) then
			RAISE EXCEPTION 'name exists';
		end if;

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
		if(DeviceGroupNameExists(New.strname,0,New.userid)=true) then
			RAISE EXCEPTION 'name exists';
		end if;
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
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION process_devicegroup_dt() OWNER TO postgres;



-- Function: process_linkgroup_dt()

-- DROP FUNCTION process_linkgroup_dt();

CREATE OR REPLACE FUNCTION process_linkgroup_dt()
  RETURNS trigger AS
$BODY$
declare tid integer;
declare uid integer;
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.strname = NEW.strname AND 
			OLD.strdesc = NEW.strdesc AND
			OLD.userid = NEW.userid AND			
			OLD.showcolor = NEW.showcolor AND
			OLD.showstyle =NEW.showstyle AND
			OLD.showwidth = NEW.showwidth AND
			OLD.searchcondition= NEW.searchcondition AND
			OLD.searchcontainer =NEW.searchcontainer
		then
			return OLD;
		end IF;

		if(LinkGroupNameExists(New.strname,NEW.id,New.userid)=true) then
			RAISE EXCEPTION 'name exists';
		end if;

		if not NEW.userid=OLD.userid then
			update objtimestamp set modifytime=now() where typename='PublicLinkGroup';
			if new.userid=-1 then
				uid=old.userid;
			else 
				uid=new.userid;
			end if;
			select id into tid from objtimestamp where typename='PrivateLinkGroup' and userid=uid;
			if tid is null then
				insert into objtimestamp (typename,userid,modifytime) values('PrivateLinkGroup',uid,now());
			else
				update objtimestamp set modifytime=now() where typename='PrivateLinkGroup' and userid=uid;
			end if;
		elseif NEW.userid=-1 then
			update objtimestamp set modifytime=now() where typename='PublicLinkGroup';
		else
			select id into tid from objtimestamp where typename='PrivateLinkGroup' and userid=new.userid;
			if tid is null then
				insert into objtimestamp (typename,userid,modifytime) values('PrivateLinkGroup',new.userid,now());
			else
				update objtimestamp set modifytime=now() where typename='PrivateLinkGroup' and userid=new.userid;
			end if;	
		end if;		
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN

		if(LinkGroupNameExists(New.strname,0,New.userid)=true) then
			RAISE EXCEPTION 'name exists';
		end if;
		
		if NEW.userid=-1 then
			update objtimestamp set modifytime=now() where typename='PublicLinkGroup';
		else
			select id into tid from objtimestamp where typename='PrivateLinkGroup' and userid=new.userid;
			if tid is null then
				insert into objtimestamp (typename,userid,modifytime) values('PrivateLinkGroup',new.userid,now());
			else
				update objtimestamp set modifytime=now() where typename='PrivateLinkGroup' and userid=new.userid;
			end if;	
		end if;	
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		if OLD.userid=-1 then
			update objtimestamp set modifytime=now() where typename='PublicLinkGroup';
		else
			select id into uid from "user" where id=OLD.userid;
			if( uid is not null) then 
				select id into tid from objtimestamp where typename='PrivateLinkGroup' and userid=OLD.userid;
				if tid is null then
					insert into objtimestamp (typename,userid,modifytime) values('PrivateLinkGroup',old.userid,now());
				else
					update objtimestamp set modifytime=now() where typename='PrivateLinkGroup' and userid=old.userid;
				end if;	
			end if;	
		end if;			
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION process_linkgroup_dt() OWNER TO postgres;

----------------------------------bug 34435  end 


ALTER TABLE nomp_jumpbox DROP CONSTRAINT nomp_jumpbox_un_name;
DROP INDEX nomp_telnetproxy_index_name;

ALTER TABLE nomp_jumpbox DROP CONSTRAINT nomp_jumpbox_unique_type_ipaddr_port;

ALTER TABLE nomp_jumpbox
  ADD CONSTRAINT nomp_jumpbox_unique_type_ipaddr_port UNIQUE(itype, stripaddr, iport,userid);


ALTER TABLE nomp_jumpbox ALTER COLUMN userid SET DEFAULT -1;


CREATE OR REPLACE FUNCTION test()
  RETURNS SETOF boolean AS
$BODY$
declare	
	r_id integer;
	r nomp_jumpbox%rowtype;
BEGIN
	for r in SELECT * FROM nomp_jumpbox where userid = any(select userid from User2Role where roleid in (select roleid from Role2Function where FunctionID in (SELECT id FROM "function" where sidname='Common_Device_Setting_Management'))) loop				
		select id into r_id from nomp_jumpbox where strname=r.strname AND userid=-1;
		if r_id IS NULL THEN
			update nomp_jumpbox set userid=-1 where id=r.id;			
		END if;					
		select id into r_id from nomp_jumpbox where strname=r.strname AND userid=r.userid;	
		if r_id IS NULL THEN
			insert into nomp_jumpbox (strname,itype,stripaddr,iport,imode,strusername,strpasswd,strloginprompt,strpasswdprompt,strcommandprompt,stryesnoprompt,bmodified,strenablecmd,strenablepasswordprompt,strenablepassword,strenableprompt,userid) values (r.strname,r.itype,r.stripaddr,r.iport,r.imode,r.strusername,r.strpasswd,r.strloginprompt,r.strpasswdprompt,r.strcommandprompt,r.stryesnoprompt,r.bmodified,r.strenablecmd,r.strenablepasswordprompt,r.strenablepassword,r.strenableprompt,r.userid);
		END if;					
	end loop; 
	return ;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION test() OWNER TO postgres;

select * from test();
DROP FUNCTION test();



CREATE OR REPLACE FUNCTION test()
  RETURNS SETOF boolean AS
$BODY$
declare	
	r nomp_telnetinfo%rowtype;
	r_id integer;
BEGIN
	for r in SELECT * FROM nomp_telnetinfo where userid = any(select id from "user" where strname ='admin' ) loop
		select id into r_id from nomp_telnetinfo where stralias=r.stralias AND userid=-1;
		if r_id IS NULL THEN
			insert into nomp_telnetinfo (stralias,idevicetype,strusername,strpasswd,bmodified,userid) values (r.stralias,r.idevicetype,r.strusername,r.strpasswd,r.bmodified,-1);		
		END if;					
	end loop; 
	return ;		
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION test() OWNER TO postgres;

select * from test();
DROP FUNCTION test();



ALTER TABLE discover_missdevice ADD COLUMN modifytime timestamp without time zone;
ALTER TABLE discover_missdevice ALTER COLUMN modifytime SET STORAGE PLAIN;



ALTER TABLE discover_missdevice ADD COLUMN deviceid integer;
ALTER TABLE discover_missdevice ALTER COLUMN deviceid SET STORAGE PLAIN;


CREATE OR REPLACE FUNCTION mergediscover_missdevice()
  RETURNS SETOF boolean AS
$BODY$
declare	
	r discover_missdevice%rowtype;
	r_id  integer;
BEGIN
	for r in SELECT * FROM discover_missdevice loop
		select id into r_id from devices where strname=r.hostname;
		if r_id IS NULL THEN
			delete from discover_missdevice where id=r.id;
		else
			update discover_missdevice set deviceid=id where id=r.id;	
		end if;		
	end loop; 
	return ;		
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION mergediscover_missdevice() OWNER TO postgres;

select * from mergediscover_missdevice();
drop function mergediscover_missdevice();


ALTER TABLE discover_missdevice DROP CONSTRAINT discover_missdevice_unique;
ALTER TABLE discover_missdevice DROP COLUMN hostname;


ALTER TABLE discover_missdevice
  ADD CONSTRAINT device_fk FOREIGN KEY (deviceid)
      REFERENCES devices (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE;


ALTER TABLE nomp_enablepasswd DROP CONSTRAINT nomp_enablepasswd_uniq_password;


--interfacesetting  moudle_slot modify 

DROP FUNCTION view_interface_setting_retrieve(integer, integer, timestamp without time zone);

DROP VIEW interfacesettingview;


-- View: interfacesettingview

CREATE OR REPLACE VIEW interfacesettingview AS 
 SELECT interfacesetting.id, interfacesetting.deviceid, interfacesetting.interfacename, interfacesetting.usermodifiedflag, interfacesetting.livestatus, interfacesetting.mibindex, interfacesetting.bandwidth, interfacesetting.macaddress, interfacesetting.lasttimestamp, interfacesetting.interface_ip, interfacesetting.module_slot, interfacesetting.module_type, interfacesetting.interface_status, interfacesetting.speed_int, interfacesetting.duplex, interfacesetting.description, interfacesetting.mpls_vrf, interfacesetting.vlan, interfacesetting.voice_vlan, interfacesetting.mask, interfacesetting.routing_protocol, interfacesetting.portmode, interfacesetting.multicast_mode, interfacesetting.counter, interfacesetting.isphysical, devices.strname AS devicename
   FROM interfacesetting, devices
  WHERE devices.id = interfacesetting.deviceid
  ORDER BY interfacesetting.id;

ALTER TABLE interfacesettingview OWNER TO postgres;

-- Function: view_interface_setting_retrieve(integer, integer, timestamp without time zone)

CREATE OR REPLACE FUNCTION view_interface_setting_retrieve(ibegin integer, imax integer, dt timestamp without time zone)
  RETURNS SETOF interfacesettingview AS
$BODY$
declare
	r interfacesettingview%rowtype;
BEGIN
	if imax <0 then
		for r in SELECT * FROM interfacesettingview where id>ibegin AND lasttimestamp>dt loop
		return next r;
		end loop;
	else
		for r in SELECT * FROM interfacesettingview where id>ibegin AND lasttimestamp>dt limit imax loop
		return next r;
		end loop;

	end if;
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION view_interface_setting_retrieve(integer, integer, timestamp without time zone) OWNER TO postgres;


-- Function: process_module_property_dt()

-- DROP FUNCTION process_module_property_dt();

CREATE OR REPLACE FUNCTION process_module_property_dt()
  RETURNS trigger AS
$BODY$
		
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.deviceid = NEW.deviceid AND 			
			OLD.slot = NEW.slot AND 			
			OLD.card_type = NEW.card_type AND		
			OLD.ports = NEW.ports AND
			OLD.serial_number = NEW.serial_number AND
			OLD.hwrev = NEW.hwrev AND
			OLD.rwrev = NEW.rwrev AND
			OLD.swrev = NEW.swrev AND
			OLD.card_description=NEW.card_description AND
			OLD.role=NEW.role AND
			OLD.macaddress=NEW.macaddress AND
			OLD.swversion=NEW.swversion AND
			OLD.swimage=NEW.swimage AND
			OLD.stackport1conn=NEW.stackport1conn AND
			OLD.stackport2conn=NEW.stackport2conn AND
			OLD.isswitch=NEW.isswitch
		 then
			return OLD;
		end IF;

		IF 	OLD.card_type != NEW.card_type 
		then
			update interfacesetting set module_type=NEW.card_type,lasttimestamp=now() where deviceid=NEW.deviceid and module_slot=NEW.slot;
			update objtimestamp set modifytime=now() where typename='InterfaceSetting';			
		end IF;	
		
		update objtimestamp set modifytime=now() where typename='module_property';
		NEW.lasttimestamp=now();	
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='module_property';
		NEW.lasttimestamp=now();
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='module_property';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION process_module_property_dt() OWNER TO postgres;


-----------------------------------------------------------------interfacesetting  moudle_slot modify  end

--------------------------------------------------------------------------showcommand benchmark task 
-- Table: showcommandbenchmarktask

-- DROP TABLE showcommandbenchmarktask;

CREATE TABLE showcommandbenchmarktask
(
  id serial NOT NULL,
  itype integer NOT NULL,
  strname character varying(256) NOT NULL,
  creator character varying(256),
  createtime timestamp without time zone NOT NULL,
  modifytime timestamp without time zone NOT NULL,
  imode integer NOT NULL,
  startday timestamp without time zone NOT NULL,
  starttime time without time zone NOT NULL,
  every integer NOT NULL DEFAULT 1,
  iselect integer NOT NULL DEFAULT 1,
  monthday integer NOT NULL DEFAULT 1,
  benable boolean NOT NULL DEFAULT true,
  lastruntime timestamp without time zone,
  CONSTRAINT showcommandbenchmarktask_pki PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE showcommandbenchmarktask OWNER TO postgres;

-- Table: showcommandbenchmarktaskcmddetail

-- DROP TABLE showcommandbenchmarktaskcmddetail;

CREATE TABLE showcommandbenchmarktaskcmddetail
(
  id serial NOT NULL,
  taskid integer NOT NULL,
  showcommandinfo character varying(256) NOT NULL DEFAULT ''::character varying,
  CONSTRAINT showcmdbtaskpk PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE showcommandbenchmarktaskcmddetail OWNER TO postgres;
-- Table: showcommandbenchmarktaskdgdetail

-- DROP TABLE showcommandbenchmarktaskdgdetail;

CREATE TABLE showcommandbenchmarktaskdgdetail
(
  id serial NOT NULL,
  taskid integer NOT NULL,
  devicegroupid integer NOT NULL,
  CONSTRAINT showcmdbtaskdgpk PRIMARY KEY (id),
  CONSTRAINT showcmdbtaskdgdgid FOREIGN KEY (devicegroupid)
      REFERENCES devicegroup (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT showcmdbtaskuni UNIQUE (taskid, devicegroupid)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE showcommandbenchmarktaskdgdetail OWNER TO postgres;

-- Index: fki_showcmdbtaskdgdgid

-- DROP INDEX fki_showcmdbtaskdgdgid;

CREATE INDEX fki_showcmdbtaskdgdgid
  ON showcommandbenchmarktaskdgdetail
  USING btree
  (devicegroupid);

-- Table: showcommandbenchmarktasksitedetail

-- DROP TABLE showcommandbenchmarktasksitedetail;

CREATE TABLE showcommandbenchmarktasksitedetail
(
  id serial NOT NULL,
  taskid integer NOT NULL,
  siteid integer NOT NULL,
  CONSTRAINT showcmdbtasksitepk PRIMARY KEY (id),
  CONSTRAINT showcmdbtasksiteid FOREIGN KEY (siteid)
      REFERENCES site (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT showcmdtasksiteuni UNIQUE (taskid, siteid)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE showcommandbenchmarktasksitedetail OWNER TO postgres;

-- Index: fki_showcmdbtasksiteid

-- DROP INDEX fki_showcmdbtasksiteid;

CREATE INDEX fki_showcmdbtasksiteid
  ON showcommandbenchmarktasksitedetail
  USING btree
  (siteid);


-- Function: showcmdbtaskadd(character varying[], integer[], integer[], showcommandbenchmarktask)

-- DROP FUNCTION showcmdbtaskadd(character varying[], integer[], integer[], showcommandbenchmarktask);

CREATE OR REPLACE FUNCTION showcmdbtaskadd(cmds character varying[], dgids integer[], siteids integer[], showbtask showcommandbenchmarktask)
  RETURNS integer AS
$BODY$
declare
	t_id integer;
BEGIN
	INSERT INTO showcommandbenchmarktask(itype
            , strname
            , creator
            , createtime
            , modifytime
            , imode
            , startday
            , starttime
            , every
            , iselect
            , monthday
            , benable
            , lastruntime
            ,description)
    VALUES ( showbtask.itype
    , showbtask.strname
    ,showbtask.creator
    ,showbtask.createtime
    ,showbtask.modifytime
    ,showbtask.imode
    ,showbtask.startday
    ,showbtask.starttime
    ,showbtask.every
    ,showbtask.iselect
    ,showbtask.monthday
    ,showbtask.benable
    , showbtask.lastruntime
    ,showbtask.description);
 t_id=lastval();
 
	if char_length(cmds[1])>0 then
		for r in  1..array_length(cmds,1) loop
		       insert into showcommandbenchmarktaskcmddetail (taskid,showcommandinfo) values (t_id,cmds[r]);              
		end loop;
	end if;

	if dgids[1]>-1 then
		for r in  1..array_length(dgids,1) loop
		       insert into showcommandbenchmarktaskdgdetail (taskid,devicegroupid) values (t_id,dgids[r]);              
		end loop;
	end if;

	if siteids[1]>-1 then
	for r in  1..array_length(siteids,1) loop
	       insert into showcommandbenchmarktasksitedetail (taskid,siteid) values (t_id,siteids[r]);              
	end loop;
	end if;
	
	return t_id;

End;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION showcmdbtaskadd(character varying[], integer[], integer[], showcommandbenchmarktask) OWNER TO postgres;

-- Function: showcmdbtaskmodify(character varying[], integer[], integer[], showcommandbenchmarktask)

-- DROP FUNCTION showcmdbtaskmodify(character varying[], integer[], integer[], showcommandbenchmarktask);

CREATE OR REPLACE FUNCTION showcmdbtaskmodify(cmds character varying[], dgids integer[], siteids integer[], showbtask showcommandbenchmarktask)
  RETURNS integer AS
$BODY$
declare
	t_id integer;
BEGIN
	t_id = showbtask.id;
	UPDATE showcommandbenchmarktask
	SET itype=showbtask.itype
            , strname=showbtask.strname
            , creator=showbtask.creator
            , createtime=showbtask.createtime
            , modifytime=showbtask.modifytime
            , imode=showbtask.imode
            , startday=showbtask.startday
            , starttime=showbtask.starttime
            , every=showbtask.every
            , iselect=showbtask.iselect
            , monthday=showbtask.monthday
            , benable=showbtask.benable
            , lastruntime=showbtask.lastruntime
            ,description=showbtask.description
       WHERE id=showbtask.id;

	delete from showcommandbenchmarktaskcmddetail where taskid=showbtask.id;
	if char_length(cmds[1])>0 then
		for r in  1..array_length(cmds,1) loop
		       insert into showcommandbenchmarktaskcmddetail (taskid,showcommandinfo) values (t_id,cmds[r]);              
		end loop;
	end if;

	delete from showcommandbenchmarktaskdgdetail where taskid=showbtask.id;
	if dgids[1]>-1 then
		for r in  1..array_length(dgids,1) loop
		       insert into showcommandbenchmarktaskdgdetail (taskid,devicegroupid) values (t_id,dgids[r]);              
		end loop;
	end if;

	delete from showcommandbenchmarktasksitedetail where taskid=showbtask.id;
	if siteids[1]>-1 then
		for r in  1..array_length(siteids,1) loop
		       insert into showcommandbenchmarktasksitedetail (taskid,siteid) values (t_id,siteids[r]);              
		end loop;
	end if;

	return t_id;

End;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION showcmdbtaskmodify(character varying[], integer[], integer[], showcommandbenchmarktask) OWNER TO postgres;


CREATE OR REPLACE FUNCTION retrieve_device_by_siteanddgids(iddg integer[], idsite integer[])
  RETURNS SETOF devices AS
$BODY$

DECLARE
    r devices%rowtype;
BEGIN		
		     FOR r IN select distinct * from 
		     (select devices.* from devices, devicegroupdevice where devices.id=devicegroupdevice.deviceid and devicegroupdevice.devicegroupid = any(iddg) 
		     union 
		     select devices.* from devices, devicesitedeviceview where devices.id=devicesitedeviceview.deviceid and devicesitedeviceview.siteid = any(idsite)) c LOOP
			RETURN NEXT r;
		     END LOOP;	     		    
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION retrieve_device_by_siteanddgids(integer[], integer[]) OWNER TO postgres;


ALTER TABLE showcommandbenchmarktask ADD COLUMN description character varying(256) NOT NULL DEFAULT '';

---------------------------------------------------------------showcommand benchmark task end



--------------  shared map


INSERT INTO objtimestamp(
            typename, modifytime, userid)
    VALUES ('Shared_Map','1900-01-01 00:00:00', -1);


CREATE TABLE object_file_path_info
(
  id serial NOT NULL,
  parentid integer,
  path character varying(256) NOT NULL,
  lasttimestamp timestamp without time zone NOT NULL,
  path_update_time timestamp without time zone NOT NULL,
  object_type integer NOT NULL, -- 3-shared map
  CONSTRAINT object_file_path_info_pk PRIMARY KEY (id),
  CONSTRAINT object_file_path_info_un UNIQUE (parentid, path, object_type)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE object_file_path_info OWNER TO postgres;
COMMENT ON COLUMN object_file_path_info.object_type IS '3-shared map';


CREATE OR REPLACE FUNCTION process_object_file_path_info_dt()
  RETURNS trigger AS
$BODY$

    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		NEW.path_update_time=now();	
		update objtimestamp set modifytime=now() where typename='Shared_Map';
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		NEW.path_update_time=now();
		NEW.lasttimestamp=now();
		update objtimestamp set modifytime=now() where typename='Shared_Map';
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='Shared_Map';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION process_object_file_path_info_dt() OWNER TO postgres;


CREATE TRIGGER object_file_path_info_dt
  BEFORE INSERT OR UPDATE OR DELETE
  ON object_file_path_info
  FOR EACH ROW
  EXECUTE PROCEDURE process_object_file_path_info_dt();



CREATE OR REPLACE FUNCTION update_object_file_path_info_time(oid integer)
  RETURNS boolean AS
$BODY$

BEGIN    
    update object_file_path_info set path_update_time=now() where id=oid;
    RETURN true;
EXCEPTION
    WHEN OTHERS THEN 
	RETURN false;    
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION update_object_file_path_info_time(integer) OWNER TO postgres;




--------------------- devicesettingview
DROP FUNCTION searchalldevicenofiler(character varying);
DROP FUNCTION searchdevicebygroupnofiler(character varying, integer);
DROP FUNCTION view_device_setting_retrieve(integer, integer, timestamp without time zone);
DROP FUNCTION view_device_setting_retrieve_by_nap(integer, integer, timestamp without time zone, integer);
DROP FUNCTION searchalldevicenofiler(character varying, integer, integer[], character varying[]);
DROP FUNCTION searchalldevicenofiler(character varying, integer, character varying[]);
DROP FUNCTION searchdevicebygroupnofiler(character varying, integer, integer, character varying[]);
DROP FUNCTION searchdevicebygroupnofiler(character varying, integer, integer, integer[], character varying[]);



DROP VIEW devicesettingview;

CREATE OR REPLACE VIEW devicesettingview AS 
 SELECT devicesetting.*, devices.strname AS devicename, nomp_appliance.strhostname AS hostname
   FROM devicesetting, devices, nomp_appliance
  WHERE devices.id = devicesetting.deviceid AND nomp_appliance.id = devicesetting.appliceid;

ALTER TABLE devicesettingview OWNER TO postgres;




CREATE OR REPLACE FUNCTION searchalldevicenofiler(devname character varying)
  RETURNS SETOF devicesettingview AS
$BODY$

DECLARE
    r devicesettingview%rowtype;
BEGIN	
	
             FOR r IN select * from devicesettingview  where lower(devicename) like '%'||devname||'%' order by lower(devicename) limit 1 LOOP
		RETURN NEXT r;
	     END LOOP;	     		
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION searchalldevicenofiler(character varying) OWNER TO postgres;


CREATE OR REPLACE FUNCTION searchdevicebygroupnofiler(devname character varying, gid integer)
  RETURNS SETOF devicesettingview AS
$BODY$

DECLARE
    r devicesettingview%rowtype;
BEGIN	
             FOR r IN select * from devicesettingview where deviceid in (select deviceid from devicegroupdeviceview where devicegroupid=gid and lower(devicename) like '%'||devname||'%' order by devicename limit 1 )  LOOP
		RETURN NEXT r;
	     END LOOP;	     		
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION searchdevicebygroupnofiler(character varying, integer) OWNER TO postgres;


CREATE OR REPLACE FUNCTION view_device_setting_retrieve(ibegin integer, imax integer, dt timestamp without time zone)
  RETURNS SETOF devicesettingview AS
$BODY$
declare
	r devicesettingview%rowtype;
BEGIN
	if imax <0 then
		for r in SELECT * FROM devicesettingview where id>ibegin AND lasttimestamp>dt order by id loop
		return next r;
		end loop;
	else
		for r in SELECT * FROM devicesettingview where id>ibegin AND lasttimestamp>dt order by id limit imax loop
		return next r;
		end loop;

	end if;
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION view_device_setting_retrieve(integer, integer, timestamp without time zone) OWNER TO postgres;


CREATE OR REPLACE FUNCTION view_device_setting_retrieve_by_nap(ibegin integer, imax integer, dt timestamp without time zone, napid integer)
  RETURNS SETOF devicesettingview AS
$BODY$
declare
 r devicesettingview%rowtype;
BEGIN
 if imax <0 then
  for r in SELECT * FROM devicesettingview where id>ibegin AND lasttimestamp>dt and appliceid=napid order by id loop
  return next r;
  end loop;
 else
  for r in SELECT * FROM devicesettingview where id>ibegin AND lasttimestamp>dt and appliceid=napid order by id limit imax loop
  return next r;
  end loop;
 
 end if;
END;
 
  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION view_device_setting_retrieve_by_nap(integer, integer, timestamp without time zone, integer) OWNER TO postgres;


CREATE OR REPLACE FUNCTION searchalldevicenofiler(devname character varying, preid integer, types integer[], devnames character varying[])
  RETURNS SETOF devicesettingview AS
$BODY$

DECLARE
    r devicesettingview%rowtype;
    npreid integer;
BEGIN	
     npreid:=0;
     FOR r IN select * from devicesettingview  where devicename=any(devnames) and lower(devicename) like '%'||devname||'%' and subtype = any( types ) order by lower(devicename) LOOP
	if npreid=preid then 
	    return next r;
	    return;
	end if;
	npreid := r.id;	
     END LOOP;
     return ;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION searchalldevicenofiler(character varying, integer, integer[], character varying[]) OWNER TO postgres;


CREATE OR REPLACE FUNCTION searchalldevicenofiler(devname character varying, preid integer, devnames character varying[])
  RETURNS SETOF devicesettingview AS
$BODY$

DECLARE
    r devicesettingview%rowtype;
    npreid integer;
BEGIN	
     npreid:=0;
     FOR r IN select * from devicesettingview  where devicename=any(devnames) and lower(devicename) like '%'||devname||'%' order by lower(devicename) LOOP
	if npreid=preid then 
	    return next r;
	    return;
	end if;
	npreid := r.id;	
     END LOOP;
     return ;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION searchalldevicenofiler(character varying, integer, character varying[]) OWNER TO postgres;


CREATE OR REPLACE FUNCTION searchdevicebygroupnofiler(devname character varying, gid integer, preid integer, devnames character varying[])
  RETURNS SETOF devicesettingview AS
$BODY$

DECLARE
    r devicesettingview%rowtype;
    npreid integer;
BEGIN
     npreid:=0;	
     FOR r IN select * from devicesettingview where deviceid in (select deviceid from devicegroupdeviceview where devicename=any(devnames) and devicegroupid=gid and lower(devicename) like '%'||devname||'%') order by lower(devicename)   LOOP
	if npreid=preid then 
	    return next r;
	    return;
	end if;
	npreid := r.id;	
     END LOOP;
     return ;		
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION searchdevicebygroupnofiler(character varying, integer, integer, character varying[]) OWNER TO postgres;


CREATE OR REPLACE FUNCTION searchdevicebygroupnofiler(devname character varying, gid integer, preid integer, types integer[], devnames character varying[])
  RETURNS SETOF devicesettingview AS
$BODY$

DECLARE
    r devicesettingview%rowtype;
    npreid integer;
BEGIN
     npreid:=0;	
     FOR r IN select * from devicesettingview where devicename=any(devnames) and subtype = any( types ) and  deviceid in (select deviceid from devicegroupdeviceview where devicename=any(devnames) and devicegroupid=gid and subtype = any( types ) and lower(devicename) like '%'||devname||'%' ) order by lower(devicename)  LOOP
	if npreid=preid then 
	    return next r;
	    return;
	end if;
	npreid := r.id;	
     END LOOP;
     return ;		
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION searchdevicebygroupnofiler(character varying, integer, integer, integer[], character varying[]) OWNER TO postgres;


INSERT INTO objtimestamp( typename, modifytime, userid) VALUES ('showcommandtemplate', '1900-01-01 00:00:00', -1);



CREATE TABLE showcommandtemplate
(
  id serial NOT NULL,
  "name" character varying(100) NOT NULL,
  description text,
  commands text,
  userid integer NOT NULL,
  lasttimestamp timestamp without time zone NOT NULL DEFAULT now(),
  CONSTRAINT showcommandtemplate_pk PRIMARY KEY (id),
  CONSTRAINT showcommandtemplate_fk FOREIGN KEY (userid)
      REFERENCES "user" (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT showcommandtemplate_un UNIQUE (name)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE showcommandtemplate OWNER TO postgres;

-- Index: fki_showcommandtemplate_fk

-- DROP INDEX fki_showcommandtemplate_fk;

CREATE INDEX fki_showcommandtemplate_fk
  ON showcommandtemplate
  USING btree
  (userid);


 CREATE OR REPLACE FUNCTION process_showcommandtemplate_dt()
  RETURNS trigger AS
$BODY$

    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		NEW.lasttimestamp=now();
		update objtimestamp set modifytime=now() where typename='showcommandtemplate';
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN		
		NEW.lasttimestamp=now();
		update objtimestamp set modifytime=now() where typename='showcommandtemplate';
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='showcommandtemplate';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION process_showcommandtemplate_dt() OWNER TO postgres;


CREATE TRIGGER showcommandtemplate_dt
  BEFORE INSERT OR UPDATE OR DELETE
  ON showcommandtemplate
  FOR EACH ROW
  EXECUTE PROCEDURE process_showcommandtemplate_dt();


CREATE OR REPLACE FUNCTION view_showcommandtemplate_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying)
  RETURNS SETOF showcommandtemplate AS
$BODY$
declare	
	r showcommandtemplate%rowtype;
	t timestamp without time zone;
BEGIN
	select modifytime into t from objtimestamp where typename=stypename;
	
	if t is null or t>dt then
		if imax <0 then
			for r in  select * from showcommandtemplate where id >ibegin loop				
				return next r;								
			end loop;
		else
			for r in select * from showcommandtemplate where id >ibegin limit imax loop				
				return next r;				
			end loop;

		end if;	
	end if;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION view_showcommandtemplate_retrieve(integer, integer, timestamp without time zone, character varying) OWNER TO postgres;
 



CREATE OR REPLACE FUNCTION device_settingview_retrieve_by_devs(devnames character varying[])
  RETURNS SETOF devicesettingview AS
$BODY$
declare
	r devicesettingview%rowtype;
BEGIN
	for r in SELECT * FROM devicesettingview where devicename = any( devnames ) loop
	return next r;
	end loop;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION device_settingview_retrieve_by_devs(character varying[]) OWNER TO postgres;



ALTER TABLE benchmarktaskstatus ADD COLUMN tasktype integer;
ALTER TABLE benchmarktaskstatus ALTER COLUMN tasktype SET STORAGE PLAIN;
update benchmarktaskstatus set tasktype = 2 where tasktype is NULL;
ALTER TABLE benchmarktaskstatus ALTER COLUMN tasktype SET NOT NULL;

ALTER TABLE benchmarktaskstatus DROP CONSTRAINT "fki_ benchmarktaskstatus_taskid";

DROP INDEX "fki_fki_ benchmarktaskstatus_taskid";

CREATE INDEX benchmarktaskstatus_index_tasktypeid
  ON benchmarktaskstatus
  USING btree
  (taskid, tasktype);


--------------------------------------------------fix bug 35437 Inventory Size 0  ----------------------------
CREATE OR REPLACE VIEW siteview AS 
 SELECT site.id, site2site.parentid, site.name, site.region, site.location_address, site.employee_number, site.contact_name, site.phone_number, site.email, site.type, site.color, site.comment, site.lasttimestamp, ( SELECT count(*) AS count
           FROM devicesitedeviceview
          WHERE devicesitedeviceview.siteid = site.id) AS irefcount
   FROM site2site, site
  WHERE site2site.siteid = site.id;

ALTER TABLE siteview OWNER TO postgres;

--------------------------------------------------fix bug 35584 Attribute Setting init------------------------

COPY object_customized_attribute (id, objectid, "name", alias, allow_export, "type", allow_modify_exported,lasttimestamp) FROM stdin;
1	1	devicename	Hostname	TRUE	1	FALSE	2011-05-17 13:37:30.202
2	1	managementip	Management IP	TRUE	1	FALSE	2011-05-17 13:37:30.874
3	1	managementinterfacename	Management Interface	TRUE	1	FALSE	2011-05-17 13:37:31.484
4	1	devicetype	Device Type	TRUE	1	TRUE	2011-05-17 13:37:32.062
5	1	vendor	Vendor	TRUE	1	TRUE	2011-05-17 13:37:32.687
6	1	model	Model	TRUE	1	TRUE	2011-05-17 13:37:33.249
7	1	softwareversion	Software Version	TRUE	1	TRUE	2011-05-17 13:37:33.843
8	1	serialnumber	Serial Number	TRUE	1	TRUE	2011-05-17 13:37:34.421
9	1	assettag	Asset Tag	TRUE	1	TRUE	2011-05-17 13:37:34.984
10	1	systemmemory	System Memory	TRUE	1	TRUE	2011-05-17 13:37:35.609
11	1	location	Location	TRUE	1	TRUE	2011-05-17 13:37:36.203
12	1	contact	Contact	TRUE	1	TRUE	2011-05-17 13:37:36.75
13	1	site	In Site	TRUE	1	TRUE	2011-05-17 13:37:37.328
14	1	hierarchylayer	Hierarchy Layer	TRUE	1	TRUE	2011-05-17 13:37:37.89
15	1	description	Description	TRUE	1	TRUE	2011-05-17 13:37:38.547
16	1	Field1	Field1	TRUE	2	TRUE	2011-05-17 13:37:40.109
17	1	Field2	Field2	TRUE	2	TRUE	2011-05-17 13:37:40.672
18	1	Field3	Field3	TRUE	2	TRUE	2011-05-17 13:37:41.219
19	4	devicename	Device Name	TRUE	1	TRUE	2011-05-17 13:37:41.828
20	4	slot	Slot	TRUE	1	FALSE	2011-05-17 13:37:42.422
21	4	cardtype	Module Type	TRUE	1	FALSE	2011-05-17 13:37:43.047
22	4	ports	Ports	TRUE	1	TRUE	2011-05-17 13:37:43.609
23	4	serialnumber	Serial Number	TRUE	1	TRUE	2011-05-17 13:37:44.172
24	4	hwrev	HW Rev	TRUE	1	TRUE	2011-05-17 13:37:44.719
25	4	fwrev	FW Rev	TRUE	1	TRUE	2011-05-17 13:37:45.359
26	4	swrev	SW Rev	TRUE	1	TRUE	2011-05-17 13:37:45.922
27	4	carddescription	Description	TRUE	1	TRUE	2011-05-17 13:37:46.484
28	4	Field1	Field1	TRUE	2	TRUE	2011-05-17 13:37:47.094
29	4	Field2	Field2	TRUE	2	TRUE	2011-05-17 13:37:47.656
30	4	Field3	Field3	TRUE	2	TRUE	2011-05-17 13:37:48.328
31	2	devicename	Device Name	TRUE	1	TRUE	2011-05-17 13:37:48.891
32	2	interfacename	Interface Name	TRUE	1	FALSE	2011-05-17 13:37:49.438
33	2	interfaceip	Interface IP	TRUE	1	FALSE	2011-05-17 13:37:50.032
34	2	mibindex	MIB Index	TRUE	1	TRUE	2011-05-17 13:37:50.594
35	2	bandwidth	Bandwidth	TRUE	1	TRUE	2011-05-17 13:37:51.172
36	2	speed	Speed	TRUE	1	TRUE	2011-05-17 13:37:51.86
37	2	duplex	Duplex	TRUE	1	TRUE	2011-05-17 13:37:52.438
38	2	interfacestatus	Live Status	TRUE	1	TRUE	2011-05-17 13:37:54.141
39	2	macaddress	MAC Address	TRUE	1	TRUE	2011-05-17 13:37:54.688
40	2	moduleslot	Slot#	TRUE	1	TRUE	2011-05-17 13:37:55.251
41	2	moduletype	Module Type	TRUE	1	TRUE	2011-05-17 13:37:55.891
42	2	description	Description	TRUE	1	TRUE	2011-05-17 13:37:56.454
43	2	Field1	Field1	TRUE	2	TRUE	2011-05-17 13:37:57.047
44	2	Field2	Field2	TRUE	2	TRUE	2011-05-17 13:37:57.594
45	2	Field3	Field3	TRUE	2	TRUE	2011-05-17 13:37:58.141
46	5	Name	Name	TRUE	1	FALSE	2011-05-17 13:37:58.704
47	5	Region	Region	TRUE	1	TRUE	2011-05-17 13:37:59.298
48	5	Location/Address	Location/Address	TRUE	1	TRUE	2011-05-17 13:37:59.938
49	5	Employee Number	Employee Number	TRUE	1	TRUE	2011-05-17 13:38:00.516
50	5	Device Count	Device Count	TRUE	1	TRUE	2011-05-17 13:38:01.079
51	5	Contact Name	Contact Name	TRUE	1	TRUE	2011-05-17 13:38:01.641
52	5	Phone Number	Phone Number	TRUE	1	TRUE	2011-05-17 13:38:02.204
53	5	Email	Email	TRUE	1	TRUE	2011-05-17 13:38:02.845
54	5	Type	Type	TRUE	1	TRUE	2011-05-17 13:38:03.407
55	5	Description	Description	TRUE	1	TRUE	2011-05-17 13:38:05.032
56	5	Field1	Field1	TRUE	2	TRUE	2011-05-17 13:38:05.595
57	5	Field2	Field2	TRUE	2	TRUE	2011-05-17 13:38:06.142
58	5	Field3	Field3	TRUE	2	TRUE	2011-05-17 13:38:06.72
59	6	Circuite ID	Circuite ID	TRUE	1	TRUE	2011-05-17 13:38:07.345
60	6	Data rate	Data rate	TRUE	1	TRUE	2011-05-17 13:38:07.892
61	6	Carrier	Carrier	TRUE	1	TRUE	2011-05-17 13:38:08.454
62	6	SLA	SLA	TRUE	1	TRUE	2011-05-17 13:38:09.032
63	6	Field1	Field1	TRUE	2	TRUE	2011-05-17 13:38:09.642
64	6	Field2	Field2	TRUE	2	TRUE	2011-05-17 13:38:10.22
65	6	Field3	Field3	TRUE	2	TRUE	2011-05-17 13:38:10.861
\.



--------------------------------------------------------Bug 36051 - 如附件：添加一条Customized info确定后没有保存刚刚Add的条目
SELECT pg_catalog.setval('object_customized_attribute_id_seq', 66, true);


--------------------------------------------------------interfacefullname--------------------------

ALTER TABLE interfacesetting ADD COLUMN interfacefullname text NOT NULL DEFAULT '';
ALTER TABLE interfacesetting ADD COLUMN ordernumber integer NOT NULL DEFAULT -1;


CREATE OR REPLACE VIEW interfacesettingview AS 
 SELECT interfacesetting.id, interfacesetting.deviceid, interfacesetting.interfacename, interfacesetting.usermodifiedflag, 
interfacesetting.livestatus, interfacesetting.mibindex, interfacesetting.bandwidth, interfacesetting.macaddress, 
interfacesetting.lasttimestamp, interfacesetting.interface_ip, interfacesetting.module_slot, interfacesetting.module_type, 
interfacesetting.interface_status, interfacesetting.speed_int, interfacesetting.duplex, interfacesetting.description, 
interfacesetting.mpls_vrf, interfacesetting.vlan, interfacesetting.voice_vlan, interfacesetting.mask, interfacesetting.routing_protocol,
 interfacesetting.portmode, interfacesetting.multicast_mode, interfacesetting.counter, interfacesetting.isphysical, 
devices.strname AS devicename,interfacesetting.interfacefullname,interfacesetting.ordernumber
   FROM interfacesetting, devices
  WHERE devices.id = interfacesetting.deviceid
  ORDER BY interfacesetting.id;

-- Function: interface_setting_update(character varying, interfacesetting)

-- DROP FUNCTION interface_setting_update(character varying, interfacesetting);

CREATE OR REPLACE FUNCTION interface_setting_update(devname character varying, ins interfacesetting)
  RETURNS integer AS
$BODY$
declare
	r_id integer;
	ds_id integer;
BEGIN
	select id into r_id from devices where strname=devname;
	if r_id IS NULL THEN
		return -1;
	end if;

	select id into ds_id from interfacesetting where deviceid=r_id AND interfacename=ins.interfacename;
	if ds_id IS NULL THEN
		return -1;
	else
		update interfacesetting set(
		  usermodifiedflag,
		  livestatus,
		  mibindex,
		  bandwidth,
		  macaddress,
		  lasttimestamp,
		  interface_ip,
			  module_slot,
			  module_type,
			  interface_status,
			  speed_int,
			  duplex,
			  description,
			  mpls_vrf,
			  vlan,
			  voice_vlan,
			  mask,
			  routing_protocol,
			  portmode,
			  multicast_mode,
			  counter,
			  isphysical,
			  interfacefullname,
			ordernumber
		  ) = ( 
		  ins.usermodifiedflag,
		  ins.livestatus,
		  ins.mibindex,
		  ins.bandwidth,
		  ins.macaddress,
		  ins.lasttimestamp,
		  ins.interface_ip,
			  ins.module_slot,
			  ins.module_type,
			  ins.interface_status,
			  ins.speed_int,
			  ins.duplex,
			  ins.description,
			  ins.mpls_vrf,
			  ins.vlan,
			  ins.voice_vlan,
			  ins.mask,
			  ins.routing_protocol,
			  ins.portmode,
			  ins.multicast_mode,
			  ins.counter,
			  ins.isphysical,
			  ins.interfacefullname,
			ins.ordernumber
		  ) 
		  where id = ds_id;
		return ds_id;
	end if;
EXCEPTION
	WHEN OTHERS THEN 
		RETURN -2;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION interface_setting_update(character varying, interfacesetting) OWNER TO postgres;

-- Function: interface_setting_upsert(character varying, interfacesetting)

-- DROP FUNCTION interface_setting_upsert(character varying, interfacesetting);

CREATE OR REPLACE FUNCTION interface_setting_upsert(devname character varying, ins interfacesetting)
  RETURNS integer AS
$BODY$
declare
	r_id integer;
	ds_id integer;
BEGIN
	select id into r_id from devices where strname=devname;
	if r_id IS NULL THEN
		return -1;
	end if;

	select id into ds_id from interfacesetting where deviceid=r_id AND interfacename=ins.interfacename;
	if ds_id IS NULL THEN
		insert into interfacesetting(
			  deviceid,
			  interfacename,
			  usermodifiedflag,
			  livestatus,
			  mibindex,
			  bandwidth,
			  macaddress,
			  interface_ip,
			  module_slot,
			  module_type,
			  interface_status,
			  speed_int,
			  duplex,
			  description,
			  mpls_vrf,
			  vlan,
			  voice_vlan,
			  mask,
			  routing_protocol,
			  portmode,
			  multicast_mode,
			  counter,
			  isphysical,
			  interfacefullname,
			  ordernumber
			  )
			  values( 
			  r_id,
			  ins.interfacename,
			  ins.usermodifiedflag,
			  ins.livestatus,
			  ins.mibindex,
			  ins.bandwidth,
			  ins.macaddress,
			  ins.interface_ip,
			  ins.module_slot,
			  ins.module_type,
			  ins.interface_status,
			  ins.speed_int,
			  ins.duplex,
			  ins.description,
			  ins.mpls_vrf,
			  ins.vlan,
			  ins.voice_vlan,
			  ins.mask,
			  ins.routing_protocol,
			  ins.portmode,
			  ins.multicast_mode,
			  ins.counter,
			  ins.isphysical,
			  ins.interfacefullname,
			  ins.ordernumber
			  );
			  return lastval();
	else
		update interfacesetting set(
			  usermodifiedflag,
			  livestatus,
			  mibindex,
			  bandwidth,
			  macaddress,
			  lasttimestamp,
			  interface_ip,
			  module_slot,
			  module_type,
			  interface_status,
			  speed_int,
			  duplex,
			  description,
			  mpls_vrf,
			  vlan,
			  voice_vlan,
			  mask,
			  routing_protocol,
			  portmode,
			  multicast_mode,
			  counter,
			  isphysical,
			  interfacefullname,
			  ordernumber
			  ) = ( 
			  ins.usermodifiedflag,
			  ins.livestatus,
			  ins.mibindex,
			  ins.bandwidth,
			  ins.macaddress,
			  ins.lasttimestamp,
			  ins.interface_ip,
			  ins.module_slot,
			  ins.module_type,
			  ins.interface_status,
			  ins.speed_int,
			  ins.duplex,
			  ins.description,
			  ins.mpls_vrf,
			  ins.vlan,
			  ins.voice_vlan,
			  ins.mask,
			  ins.routing_protocol,
			  ins.portmode,
			  ins.multicast_mode,
			  ins.counter,
			  ins.isphysical,
			  ins.interfacefullname,
			  ins.ordernumber
			  ) 
			  where id = ds_id;
		return ds_id;
	end if;
EXCEPTION
	WHEN OTHERS THEN 
		RETURN -2;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION interface_setting_upsert(character varying, interfacesetting) OWNER TO postgres;


--------------------------------------------------------interfacefullname end ---------------------

-----------------------------------------------------retrieve_device_by_siteanddgidswithappid------


CREATE OR REPLACE FUNCTION retrieve_device_by_siteanddgidswithappid(iddg integer[], idsite integer[], iappid int)
  RETURNS SETOF devices AS
$BODY$

DECLARE
    r devices%rowtype;
BEGIN		
		     FOR r IN select distinct * from 
		     (select devices.* from devices, devicegroupdevice,devicesetting where devicesetting.appliceid=iappid and devicesetting.deviceid=devices.id and devices.id=devicegroupdevice.deviceid and devicegroupdevice.devicegroupid = any(iddg) 
		     union 
		     select devices.* from devices, devicesitedeviceview,devicesetting where devicesetting.appliceid=iappid and devicesetting.deviceid=devices.id and devices.id=devicesitedeviceview.deviceid and devicesitedeviceview.siteid = any(idsite)) c LOOP
			RETURN NEXT r;
		     END LOOP;	     		    
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION retrieve_device_by_siteanddgidswithappid(integer[], integer[],int) OWNER TO postgres;

-------------------------------------------------retrieve_device_by_siteanddgidswithappid--------


-------------------------------------------------site_devices_addormodify----------------------------------------

CREATE OR REPLACE FUNCTION site_devices_addormodify(nparent integer,devnames character varying[], ssite site)
  RETURNS integer AS
$BODY$
declare
	r_id integer;
	site_id integer;	
BEGIN
	site_id = site_addormodify(nparent , ssite);
	if site_id >0 THEN	

		r_id=device_site_set2(site_id,devnames);
	end if;
	
	return site_id;
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION site_devices_addormodify(integer,character varying[], site) OWNER TO postgres;
---------------------------------------------end  site_devices_addormodify----------------------------------------



--------------------------------------------start duplicateip for chencx-----------------------------------
ALTER TABLE duplicateip DROP CONSTRAINT duplicateip_uniq_ip_inf;

ALTER TABLE duplicateip DROP CONSTRAINT duplicateip_fk_infid;
DROP INDEX fki_duplicateip_fk_infid;

ALTER TABLE duplicateip ADD COLUMN deviceid integer;
ALTER TABLE duplicateip ALTER COLUMN deviceid SET STORAGE PLAIN;

ALTER TABLE duplicateip ALTER COLUMN interfaceid drop not NULL;


DROP TRIGGER duplicateip_dt ON duplicateip;
DROP FUNCTION process_duplicateip_dt();

----------Bug 36846 - OE&ESv3.1B升级到OE&ESv4.0之后，OE refresh失败，提示同步数据失败。
update duplicateip set deviceid=(select deviceid from interfacesetting where id=interfaceid) ;

CREATE OR REPLACE FUNCTION process_duplicateip_dt()
  RETURNS trigger AS
$BODY$

    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.ipaddr = NEW.ipaddr AND
			OLD.interfaceid = NEW.interfaceid AND
			OLD.deviceid = NEW.deviceid AND			
			OLD.flag = NEW.flag			
		 then
			return OLD;
		end IF;
		update objtimestamp set modifytime=now() where typename='DuplicateIp';
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='DuplicateIp';
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='DuplicateIp';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION process_duplicateip_dt() OWNER TO postgres;

CREATE TRIGGER duplicateip_dt
  BEFORE INSERT OR UPDATE OR DELETE
  ON duplicateip
  FOR EACH ROW
  EXECUTE PROCEDURE process_duplicateip_dt();



DROP FUNCTION view_duplicateip_retrieve(timestamp without time zone, character varying);
DROP VIEW duplicateipview;

 CREATE OR REPLACE VIEW duplicateipview AS 
 select duplicateip.*,( SELECT interfacesetting.interfacename
           FROM interfacesetting
          WHERE interfacesetting.id = duplicateip.interfaceid) AS interfacename,( SELECT devices.strname
           FROM devices
          WHERE duplicateip.deviceid = devices.id ) AS devicename
          from duplicateip;

ALTER TABLE duplicateipview OWNER TO postgres;


CREATE OR REPLACE FUNCTION view_duplicateip_retrieve(dt timestamp without time zone, stypename character varying)
  RETURNS SETOF duplicateipview AS
$BODY$
declare
	r duplicateipview%rowtype;
	t timestamp without time zone;
BEGIN		
        select modifytime into t from objtimestamp where typename=stypename;
	if t is null or t>dt then
		for r in SELECT * FROM duplicateipview order by id loop
		return next r;
		end loop;	
	End IF;
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION view_duplicateip_retrieve(timestamp without time zone, character varying) OWNER TO postgres;


ALTER TABLE duplicateip ADD CONSTRAINT duplicateip_un UNIQUE(ipaddr, interfaceid, deviceid);
----------------------------------------------end duplicateip for chencx



-----------------------------------------------------bug 36513 -------------------

CREATE OR REPLACE FUNCTION updatedevicepropertytmp()
  RETURNS SETOF devicesetting AS
$BODY$
DECLARE
    r devicesetting%rowtype;
    rc integer;
BEGIN	
	select count(*) into rc from device_property;

	if rc <1 THEN 		
		FOR r IN select * from devicesetting order by id LOOP
			INSERT INTO device_property(			 
			deviceid,
			manageif_mac, 
			vendor, 
			model, 
			sysobjectid, 
			software_version,
			serial_number, 
			asset_tag, 
			system_memory, 
			"location", 
			network_cluster, 
			contact, 
			hierarchy_layer, 
			description, 
			management_interface, 
			lasttimestamp)
			VALUES (			 
			r.deviceid, 
			'', 
			substring(r.vendor from 1 for 255), 
			substring(r.model from 1 for 255), 
			'', 
			substring(r.softwareversion from 1 for 255),
			substring(r.serialnumber from 1 for 255),
			'',
			'',
			substring(r.currentlocation from 1 for 255),
			'', 
			substring(r.contactor from 1 for 255),
			'',
			'',
			'',		
			now());		  
			return next r;
		  END LOOP;
	
	END if;
	       		
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION updatedevicepropertytmp() OWNER TO postgres;

select count(*) from updatedevicepropertytmp();
-----------------------------------------------------bug 36513 end -------------------



------------------------------------start Bug 36514 ------------------
CREATE OR REPLACE FUNCTION upgradews_snmp()
  RETURNS boolean AS
$BODY$
DECLARE
	r nomp_snmproinfo%rowtype;
	step integer;
BEGIN
	step=0;
	for r in SELECT * FROM nomp_snmproinfo loop
		update nomp_snmproinfo set stralias=CAST(step AS integer) where stralias is null and id=r.id;
		step=step+1;
	end loop; 	
	return true;
EXCEPTION    
	WHEN OTHERS THEN   
		return false;		
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION upgradews_snmp() OWNER TO postgres;

select * from upgradews_snmp();

DROP FUNCTION upgradews_snmp();

-----------------------------------end bug 36514--------------------------=======

-----------------------------------bug Bug 36538  sitecustomized info failed-------------------------------------
DROP FUNCTION site_customized_infoview_upsert(site_customized_infoview);

CREATE OR REPLACE FUNCTION site_customized_infoview_upsert(dciv site_customized_infoview)
  RETURNS integer AS
$BODY$
declare		
	t_id integer;
BEGIN	
	select id into t_id from site_customized_infoview where objectid=dciv.objectid and attributeid=dciv.attributeid ;
	if t_id IS NULL THEN		
		insert into site_customized_info(
			objectid,
			attributeid,
			attribute_value
			)
			values ( 
			dciv.objectid,
			dciv.attributeid,
			dciv.attribute_value
		);

		return lastval();
	ELSE
		update site_customized_info set ( attribute_value)=( dciv.attribute_value ) where id = t_id;
		return t_id;
	end if;
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION site_customized_infoview_upsert(site_customized_infoview) OWNER TO postgres;
--------------------------------------Bug 36538 end---------------------------------------------------

DROP INDEX nat_index_na;

CREATE UNIQUE INDEX nat_index_na
  ON nat
  USING btree
  (deviceid, insidelocal, insideglobal, outsidelocal, outsideglobal);


------------------------------------bug  site alter column "type"-----------------------------
DROP FUNCTION view_site_retrieve(integer, integer, timestamp without time zone, character varying);
DROP VIEW siteview;

alter TABLE site alter column "type" TYPE character varying(256);

CREATE OR REPLACE VIEW siteview AS 
 SELECT site.id, site2site.parentid, site.name, site.region, site.location_address, site.employee_number, site.contact_name, site.phone_number, site.email, site.type, site.color, site.comment, site.lasttimestamp, ( SELECT count(*) AS count
           FROM devicesitedeviceview
          WHERE devicesitedeviceview.siteid = site.id) AS irefcount
   FROM site2site, site
  WHERE site2site.siteid = site.id;

ALTER TABLE siteview OWNER TO postgres;


CREATE OR REPLACE FUNCTION view_site_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying)
  RETURNS SETOF siteview AS
$BODY$
declare
	r siteview%rowtype;
	t timestamp without time zone;
BEGIN
	select modifytime into t from objtimestamp where typename=stypename;
	
	if t is null or t>dt then
		if imax <0 then
			for r in SELECT * FROM siteview where id>ibegin order by id loop
			return next r;
			end loop;
		else
			for r in SELECT * FROM siteview where id>ibegin order by id limit imax loop
			return next r;
			end loop;

		end if;	
	end if;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION view_site_retrieve(integer, integer, timestamp without time zone, character varying) OWNER TO postgres;

---------------------------------------end -----------------------------------------------------

CREATE TABLE domain_name
(
  id serial NOT NULL,
  str_name text NOT NULL,
  CONSTRAINT pk_domain_name_id PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE domain_name OWNER TO postgres;


CREATE OR REPLACE FUNCTION domain_name_removeall()
  RETURNS void AS
'delete from domain_name'
  LANGUAGE 'sql' VOLATILE
  COST 100;
ALTER FUNCTION domain_name_removeall() OWNER TO postgres;


-----------------------------------------siteviewsimple----------------------------------------------
CREATE OR REPLACE VIEW siteviewsimple AS 
 SELECT site.id, site2site.parentid, site.name, ( SELECT count(*) AS count
           FROM devicesitedeviceview
          WHERE devicesitedeviceview.siteid = site.id) AS irefcount
   FROM site2site, site
  WHERE site2site.siteid = site.id order by site.id;

ALTER TABLE siteviewsimple OWNER TO postgres;
-----------------------------------------siteviewsimple end-------------------------------------------------

ALTER TABLE ip2mac ALTER COLUMN interfacename type text;

-----------------------------------------devicepropertyviewfdown  configfile_time--------------------------

CREATE OR REPLACE VIEW devicepropertyviewfdown AS 
 SELECT device_property.id, device_property.deviceid, device_property.manageif_mac, device_property.vendor, device_property.model, device_property.sysobjectid, device_property.software_version, device_property.serial_number, device_property.asset_tag, device_property.system_memory, device_property.location, device_property.network_cluster, device_property.contact, device_property.hierarchy_layer, device_property.description, device_property.management_interface, device_property.lasttimestamp, devices.strname AS devicename, devices.isubtype AS itype, devicesetting.configfile_time
   FROM device_property, devices, devicesetting
  WHERE device_property.deviceid = devices.id AND device_property.deviceid = devicesetting.deviceid
  ORDER BY device_property.id;

ALTER TABLE devicepropertyviewfdown OWNER TO postgres;


CREATE OR REPLACE FUNCTION view_device_property_retrieve2(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying)
  RETURNS SETOF devicepropertyviewfdown AS
$BODY$
declare
	r devicepropertyviewfdown%rowtype;
	t timestamp without time zone;
BEGIN
	select modifytime into t from objtimestamp where typename=stypename;
	
	if t is null or t>dt then
		if imax <0 then
			for r in SELECT * FROM devicepropertyviewfdown where id>ibegin and lasttimestamp>dt loop
			return next r;
			end loop;
		else
			for r in SELECT * FROM devicepropertyviewfdown where id>ibegin and lasttimestamp>dt limit imax loop
			return next r;
			end loop;

		end if;	
	end if;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION view_device_property_retrieve2(integer, integer, timestamp without time zone, character varying) OWNER TO postgres;


-----------------------------------------end devicepropertyviewfdown----------------------------------------------



--------------------------------------- Bug 36969 - admin:discovery option:retreive device/interface info;import a IP list operated seed router discover; engineer用户设备的property信息为空

CREATE OR REPLACE FUNCTION device_property_upsert(dp devicepropertyview)
  RETURNS integer AS
$BODY$
declare
	r_id integer;
	ds_id integer;
BEGIN
	select id into r_id from devices where strname=dp.devicename;
	if r_id IS NULL THEN
		return -1;
	end if;

	select id into ds_id from device_property where deviceid=r_id;
	if ds_id IS NULL THEN
		insert into device_property(
			deviceid,
			manageif_mac,
			vendor,
			model,
			sysobjectid,
			software_version,
			serial_number,
			asset_tag,
			system_memory,
			"location",
			network_cluster,
			contact,
			hierarchy_layer,
			description,
			management_interface
		)
		values (
			r_id,
			dp.manageif_mac,
			dp.vendor,
			dp.model,
			dp.sysobjectid,
			dp.software_version,
			dp.serial_number,
			dp.asset_tag,
			dp.system_memory,
			dp.location,
			dp.network_cluster,
			dp.contact,
			dp.hierarchy_layer,
			dp.description,
			dp.management_interface	
		);

		return lastval();
	ELSE
		update device_property set ( 
			manageif_mac,
			vendor,
			model,
			sysobjectid,
			software_version,
			serial_number,
			asset_tag,
			system_memory,
			"location",
			network_cluster,
			contact,
			hierarchy_layer,
			description,
			management_interface			
			)
			=( 
			dp.manageif_mac,
			dp.vendor,
			dp.model,
			dp.sysobjectid,
			dp.software_version,
			dp.serial_number,
			dp.asset_tag,
			dp.system_memory,
			dp.location,
			dp.network_cluster,
			dp.contact,
			dp.hierarchy_layer,
			dp.description,
			dp.management_interface			
			) 
			where id = ds_id;
		return ds_id;
	end if;
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION device_property_upsert(devicepropertyview) OWNER TO postgres;



-----------------------------------------end 36969




---------------------------------Bug 37041 - 调整Live Network Setting中的username password的顺序后没有同步到其他机器上 ---

DROP TRIGGER appliance_pri ON nomp_appliance;
DROP FUNCTION process_appliance();

DROP TRIGGER enablepassword_pri ON nomp_enablepasswd;
DROP FUNCTION process_enablepasswd();

DROP TRIGGER jumpbox_pri ON nomp_jumpbox;
DROP FUNCTION process_jumpbox();

DROP TRIGGER rostring_pri ON nomp_snmproinfo;
DROP FUNCTION process_snmprostring();

DROP TRIGGER telent_pri ON nomp_telnetinfo;
DROP FUNCTION process_telnetinfo();


DROP TRIGGER nomp_appliance_dt ON nomp_appliance;
DROP FUNCTION process_nomp_appliance_dt();

CREATE OR REPLACE FUNCTION process_nomp_appliance_dt()
  RETURNS trigger AS
$BODY$

    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.strhostname = NEW.strhostname AND 
			OLD.strdescription = NEW.strdescription AND
			OLD.stripaddr = NEW.stripaddr AND
			OLD.iserveport = NEW.iserveport AND
			OLD.bhome = NEW.bhome AND
			OLD.blive = NEW.blive AND
			OLD.bmodified = NEW.bmodified AND
			OLD.imaxdevicecount = NEW.imaxdevicecount AND
			OLD.ipri = NEW.ipri AND
			OLD.telnet_user = NEW.telnet_user AND
			OLD.ibapport=NEW.ibapport AND
			OLD.telnet_pwd = NEW.telnet_pwd			
		 then
			return OLD;
		end IF;
		update objtimestamp set modifytime=now() where typename='NetworkSetting';
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='NetworkSetting';
		NEW.ipri=nextval('nomp_appliance_ipri_seq'::regclass);
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='NetworkSetting';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION process_nomp_appliance_dt() OWNER TO postgres;

CREATE TRIGGER nomp_appliance_dt
  BEFORE INSERT OR UPDATE OR DELETE
  ON nomp_appliance
  FOR EACH ROW
  EXECUTE PROCEDURE process_nomp_appliance_dt();



DROP TRIGGER nomp_enablepasswd_dt ON nomp_enablepasswd;
DROP FUNCTION process_nomp_enablepasswd_dt();

CREATE OR REPLACE FUNCTION process_nomp_enablepasswd_dt()
  RETURNS trigger AS
$BODY$

    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.stralias = NEW.stralias AND 
			OLD.strenablepasswd = NEW.strenablepasswd AND
			OLD.bmodified = NEW.bmodified AND			
			OLD.ipri = NEW.ipri			
		 then
			return OLD;
		end IF;
		update objtimestamp set modifytime=now() where typename='NetworkSetting';
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='NetworkSetting';
		NEW.ipri=nextval('nomp_enablepasswd_ipri_seq'::regclass);
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='NetworkSetting';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION process_nomp_enablepasswd_dt() OWNER TO postgres;

CREATE TRIGGER nomp_enablepasswd_dt
  BEFORE INSERT OR UPDATE OR DELETE
  ON nomp_enablepasswd
  FOR EACH ROW
  EXECUTE PROCEDURE process_nomp_enablepasswd_dt();



DROP TRIGGER nomp_jumpbox_dt ON nomp_jumpbox;
DROP FUNCTION process_nomp_jumpbox_dt();

CREATE OR REPLACE FUNCTION process_nomp_jumpbox_dt()
  RETURNS trigger AS
$BODY$

    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.strname = NEW.strname AND 
			OLD.itype = NEW.itype AND
			OLD.stripaddr = NEW.stripaddr AND
			OLD.iport = NEW.iport AND
			OLD.imode = NEW.imode AND
			OLD.strusername = NEW.strusername AND
			OLD.strpasswd = NEW.strpasswd AND
			OLD.strloginprompt = NEW.strloginprompt AND
			OLD.strpasswdprompt = NEW.strpasswdprompt AND
			OLD.strcommandprompt = NEW.strcommandprompt AND
			OLD.stryesnoprompt = NEW.stryesnoprompt AND
			OLD.bmodified = NEW.bmodified AND
			OLD.strenablecmd = NEW.strenablecmd AND
			OLD.strenablepasswordprompt = NEW.strenablepasswordprompt AND
			OLD.strenablepassword = NEW.strenablepassword AND
			OLD.strenableprompt = NEW.strenableprompt AND
			OLD.ipri = NEW.ipri AND
			OLD.userid= NEW.userid			
		 then
			return OLD;
		end IF;
		update objtimestamp set modifytime=now() where typename='NetworkSetting';
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='NetworkSetting';
		NEW.ipri=nextval('nomp_jumpbox_ipri_seq'::regclass);
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='NetworkSetting';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION process_nomp_jumpbox_dt() OWNER TO postgres;

CREATE TRIGGER nomp_jumpbox_dt
  BEFORE INSERT OR UPDATE OR DELETE
  ON nomp_jumpbox
  FOR EACH ROW
  EXECUTE PROCEDURE process_nomp_jumpbox_dt();



 DROP TRIGGER nomp_snmproinfo_dt ON nomp_snmproinfo;
DROP FUNCTION process_nomp_snmproinfo_dt();

CREATE OR REPLACE FUNCTION process_nomp_snmproinfo_dt()
  RETURNS trigger AS
$BODY$

    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.strrostring = NEW.strrostring AND 			
			OLD.bmodified = NEW.bmodified AND			
			OLD.ipri = NEW.ipri AND
			OLD.stralias=NEW.stralias AND
			OLD.authentication_method=NEW.authentication_method AND
			OLD.encryption_method=NEW.encryption_method AND
			OLD.snmpv3_username=NEW.snmpv3_username AND
			OLD.snmpv3_authentication=NEW.snmpv3_authentication AND
			OLD.snmpv3_encryption=NEW.snmpv3_encryption AND
			OLD.version=NEW.version AND
			OLD.authentication_mode=NEW.authentication_mode			
		 then
			return OLD;
		end IF;
		update objtimestamp set modifytime=now() where typename='NetworkSetting';
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='NetworkSetting';
		NEW.ipri=nextval('nomp_snmproinfo_ipri_seq'::regclass);
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='NetworkSetting';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION process_nomp_snmproinfo_dt() OWNER TO postgres;
CREATE TRIGGER nomp_snmproinfo_dt
  BEFORE INSERT OR UPDATE OR DELETE
  ON nomp_snmproinfo
  FOR EACH ROW
  EXECUTE PROCEDURE process_nomp_snmproinfo_dt(); 


 DROP TRIGGER nomp_telnetinfo_dt ON nomp_telnetinfo;
DROP FUNCTION process_nomp_telnetinfo_dt();

CREATE OR REPLACE FUNCTION process_nomp_telnetinfo_dt()
  RETURNS trigger AS
$BODY$

    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.stralias = NEW.stralias AND 			
			OLD.idevicetype = NEW.idevicetype AND 			
			OLD.strusername = NEW.strusername AND 			
			OLD.strpasswd = NEW.strpasswd AND 			
			OLD.bmodified = NEW.bmodified AND 			
			OLD.userid = NEW.userid AND 			
			OLD.ipri = NEW.ipri
		 then
			return OLD;
		end IF;
		update objtimestamp set modifytime=now() where typename='NetworkSetting';
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='NetworkSetting';
		NEW.ipri=nextval('nomp_telnetinfo_ipri_seq'::regclass);
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='NetworkSetting';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION process_nomp_telnetinfo_dt() OWNER TO postgres;

CREATE TRIGGER nomp_telnetinfo_dt
  BEFORE INSERT OR UPDATE OR DELETE
  ON nomp_telnetinfo
  FOR EACH ROW
  EXECUTE PROCEDURE process_nomp_telnetinfo_dt(); 



CREATE OR REPLACE FUNCTION interface_setting_upsert2(devname character varying, ins interfacesettingview)
  RETURNS integer AS
$BODY$
declare
	r_id integer;
	ds_id integer;
BEGIN
	select id into r_id from devices where strname=devname;
	if r_id IS NULL THEN
		return -1;
	end if;

	select id into ds_id from interfacesetting where deviceid=r_id AND interfacename=ins.interfacename;
	if ds_id IS NULL THEN
		insert into interfacesetting(
			  deviceid,
			  interfacename,
			  usermodifiedflag,
			  livestatus,
			  mibindex,
			  bandwidth,
			  macaddress,
			  interface_ip,
			  module_slot,
			  module_type,
			  interface_status,
			  speed_int,
			  duplex,
			  description,
			  mpls_vrf,
			  vlan,
			  voice_vlan,
			  mask,
			  routing_protocol,
			  portmode,
			  multicast_mode,
			  counter,
			  isphysical,
			  interfacefullname,
			  ordernumber
			  )
			  values( 
			  r_id,
			  ins.interfacename,
			  ins.usermodifiedflag,
			  ins.livestatus,
			  ins.mibindex,
			  ins.bandwidth,
			  ins.macaddress,
			  ins.interface_ip,
			  ins.module_slot,
			  ins.module_type,
			  ins.interface_status,
			  ins.speed_int,
			  ins.duplex,
			  ins.description,
			  ins.mpls_vrf,
			  ins.vlan,
			  ins.voice_vlan,
			  ins.mask,
			  ins.routing_protocol,
			  ins.portmode,
			  ins.multicast_mode,
			  ins.counter,
			  ins.isphysical,
			  ins.interfacefullname,
			  ins.ordernumber
			  );
			  return lastval();
	else
		update interfacesetting set(
			  usermodifiedflag,
			  livestatus,
			  mibindex,
			  bandwidth,
			  macaddress,
			  lasttimestamp,
			  interface_ip,
			  module_slot,
			  module_type,
			  interface_status,
			  speed_int,
			  duplex,
			  description,
			  mpls_vrf,
			  vlan,
			  voice_vlan,
			  mask,
			  routing_protocol,
			  portmode,
			  multicast_mode,
			  counter,
			  isphysical,
			  interfacefullname,
			  ordernumber
			  ) = ( 
			  ins.usermodifiedflag,
			  ins.livestatus,
			  ins.mibindex,
			  ins.bandwidth,
			  ins.macaddress,
			  now(),
			  ins.interface_ip,
			  ins.module_slot,
			  ins.module_type,
			  ins.interface_status,
			  ins.speed_int,
			  ins.duplex,
			  ins.description,
			  ins.mpls_vrf,
			  ins.vlan,
			  ins.voice_vlan,
			  ins.mask,
			  ins.routing_protocol,
			  ins.portmode,
			  ins.multicast_mode,
			  ins.counter,
			  ins.isphysical,
			  ins.interfacefullname,
			  ins.ordernumber
			  ) 
			  where id = ds_id;
		return ds_id;
	end if;
EXCEPTION
	WHEN OTHERS THEN 
		RETURN -2;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION interface_setting_upsert2(character varying, interfacesettingview) OWNER TO postgres;






CREATE TABLE domain_option
(
  id serial NOT NULL,
  op_val integer NOT NULL DEFAULT 0,
  CONSTRAINT domain_option_pk PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE domain_option OWNER TO postgres;

insert into domain_option (id,op_val) values (1,1);


------------------------------Bug 36949 ---------------

DROP FUNCTION user_device_setting_update(character varying, integer, userdevicesetting);

CREATE OR REPLACE FUNCTION user_device_setting_update(devname character varying, u_id integer, ds userdevicesetting)
  RETURNS integer AS
$BODY$
declare
	r_id integer;
	ds_id integer;
BEGIN
	select id into r_id from devices where strname=devname;
	if r_id IS NULL THEN
		return -1;
	end if;

	select id into ds_id from userdevicesetting where deviceid=r_id AND userid=u_id;
	if ds_id IS NULL THEN
		return -1;
	ELSE
		update userdevicesetting set ( 
			  managerip,
			  telnetusername,
			  telnetpwd,
			  dtstamp,
			  jumpboxid
			)
			=( 
			ds.managerip,
			ds.telnetusername,
			ds.telnetpwd,
			now(),
			ds.jumpboxid
			) 
			where id = ds_id;
		return ds_id;
	end if;
EXCEPTION
	WHEN OTHERS THEN 
		RETURN -2;
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION user_device_setting_update(character varying, integer, userdevicesetting) OWNER TO postgres;


-- DROP FUNCTION retrieve_device_by_dgids(integer[]);

CREATE OR REPLACE FUNCTION retrieve_device_by_dgids(iddg integer[])
  RETURNS SETOF devices AS
$BODY$

DECLARE
    r devices%rowtype;
BEGIN		
		     FOR r IN select distinct * from 
		     (select devices.* from devices, devicegroupdevice where devices.id=devicegroupdevice.deviceid and devicegroupdevice.devicegroupid = any(iddg) 
			) c LOOP
			RETURN NEXT r;
		     END LOOP;	     		    
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION retrieve_device_by_dgids(integer[]) OWNER TO postgres;


-- DROP FUNCTION retrieve_device_by_systemdgids(integer[]);

CREATE OR REPLACE FUNCTION retrieve_device_by_systemdgids(iddg integer[])
  RETURNS SETOF devices AS
$BODY$

DECLARE
    r devices%rowtype;
BEGIN		
		     FOR r IN select distinct * from 
		     (select devices.* from devices, systemdevicegroupdevice where devices.id=systemdevicegroupdevice.deviceid and systemdevicegroupdevice.systemdevicegroupid = any(iddg) 
			) c LOOP
			RETURN NEXT r;
		     END LOOP;	     		    
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION retrieve_device_by_systemdgids(integer[]) OWNER TO postgres;

-- DROP FUNCTION retrieve_device_by_dgids_systemdgids(integer[], integer[]);

CREATE OR REPLACE FUNCTION retrieve_device_by_dgids_systemdgids(iddg integer[], idsysdg integer[])
  RETURNS SETOF devices AS
$BODY$

DECLARE
    r devices%rowtype;
BEGIN		
		     FOR r IN select distinct * from 
		     (select devices.* from devices, devicegroupdevice where devices.id=devicegroupdevice.deviceid and devicegroupdevice.devicegroupid = any(iddg) 
		     union 
		     select devices.* from devices, systemdevicegroupdevice where devices.id=systemdevicegroupdevice.deviceid and systemdevicegroupdevice.systemdevicegroupid = any(idsysdg) ) c LOOP
			RETURN NEXT r;
		     END LOOP;	     		    
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION retrieve_device_by_dgids_systemdgids(integer[], integer[]) OWNER TO postgres;



-- DROP FUNCTION retrieve_only_unassign_devices_by_siteids(integer[]);

CREATE OR REPLACE FUNCTION retrieve_only_unassign_devices_by_siteids(ids integer[])
  RETURNS SETOF devices AS
$BODY$

DECLARE
    r devices%rowtype;
    len integer;
    i integer;
BEGIN
	for r in select devices.* from devices, devicesitedevice where devices.id = devicesitedevice.deviceid and  devicesitedevice.siteid = any( ids ) loop
		RETURN NEXT r;
	END LOOP;	    	

	if 1=any(ids ) then
		for r in select devices.* from devices where devices.id not in ( select deviceid from devicesitedevice) loop
			RETURN NEXT r;
		END LOOP;	    
	end if;

END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION retrieve_only_unassign_devices_by_siteids(integer[]) OWNER TO postgres;

-- DROP FUNCTION retrieve_only_unassign_devices_by_parentsiteids(integer[]);

CREATE OR REPLACE FUNCTION retrieve_only_unassign_devices_by_parentsiteids(ids integer[])
  RETURNS SETOF devices AS
$BODY$

DECLARE
    r devices%rowtype;
BEGIN		
	for r in select devices.* from devices, devicesitedevice where devices.id = devicesitedevice.deviceid and  devicesitedevice.siteid in
		( select siteid from site2site where parentid = any(ids) ) loop
		RETURN NEXT r;
	END LOOP;	    	
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION retrieve_only_unassign_devices_by_parentsiteids(integer[]) OWNER TO postgres;


-- DROP FUNCTION retrieve_all_devices_by_siteid(integer);

CREATE OR REPLACE FUNCTION retrieve_all_devices_by_siteid(id integer)
  RETURNS SETOF devices AS
$BODY$

DECLARE
    r devices%rowtype;
    r1 integer;
    idt integer[];
    idt1 integer[];
    c integer;
BEGIN		
	if 1 = id then
		for r in SELECT * FROM devices loop
		return next r;
		end loop;
	else
		for r in select * from devices, devicesitedevice where devices.id=devicesitedevice.deviceid and devicesitedevice.siteid=id loop
		return next r;
		end loop;
	
		c=1;
		idt=array[id];
		while c > 0 loop 
			for r in select * from retrieve_only_unassign_devices_by_parentsiteids( idt ) loop
			return next r;
			end loop;

			idt1=NULL;
			c=0;
			for r1 in select siteid from site2site where parentid = any( idt ) loop
				c=1;
				idt1=idt1||r1;
			end loop;
			idt=idt1;
		end loop;
	end if;
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION retrieve_all_devices_by_siteid(integer) OWNER TO postgres;

-- DROP FUNCTION retrieve_all_devices_by_siteids(integer[]);

CREATE OR REPLACE FUNCTION retrieve_all_devices_by_siteids(ids integer[])
  RETURNS SETOF devices AS
$BODY$

DECLARE
    r devices%rowtype;
    idps integer[];
    idps1 integer[];
    pid integer;
    f1 integer;
    f2 integer;
    f3 integer;    
    idv integer;
    len integer;
BEGIN		
	idps = ids;
	select array_length( idps, 1 ) into len;
	f1=0;
	while f1 < len loop
		idv=idps[f1+1];
		f2=1;
		while f2 > 0 loop
			select parentid into pid from site2site where siteid=idv;
			f3=0;
			if pid is null then
				f3=1;
			elsif  pid = 0 then 
				f2=0;
				f1 = f1 + 1;
			elsif pid = any( idps ) then
				f3=1;
			else
				idv=pid;
			end if;

			if f3=1 then
				f2=0;
				idps1=array[]::integer[];
				while f2 < len loop
					if f2 <> f1 then
						idps1=idps1||idps[f2+1];
					end if;
					f2 = f2 + 1;
				end loop;
				idps=idps1;
				f2=0;
				len = len -1;
			end if;
		end loop;
	end loop;

	select array_length( idps, 1 ) into len;
	f1=0;
	while f1 < len loop
		idv=idps[f1+1];
		for r in select * from retrieve_all_devices_by_siteid( idv ) loop
			return next r;
		end loop;
		f1 = f1 + 1;
	end loop;
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION retrieve_all_devices_by_siteids(integer[]) OWNER TO postgres;


-- DROP FUNCTION retrieve_all_devices_only_unassign_devices_by_siteids(integer[], integer[]);

CREATE OR REPLACE FUNCTION retrieve_all_devices_only_unassign_devices_by_siteids(ids integer[], uids integer[])
  RETURNS SETOF devices AS
$BODY$

DECLARE
    r devices%rowtype;
BEGIN		
	for r in ( select * from retrieve_all_devices_by_siteids( ids ) union select * from retrieve_only_unassign_devices_by_siteids( uids ) )loop
	return next r;
	end loop;
	
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION retrieve_all_devices_only_unassign_devices_by_siteids(integer[], integer[]) OWNER TO postgres;


CREATE OR REPLACE VIEW linkgroupview AS 
 SELECT linkgroup.id, linkgroup.strname, linkgroup.strdesc, linkgroup.showcolor, linkgroup.showstyle, linkgroup.showwidth, linkgroup.searchcondition, linkgroup.userid, ( SELECT count(*) AS count
           FROM linkgroupinterface
          WHERE linkgroupinterface.groupid = linkgroup.id) AS irefcount, linkgroup.searchcontainer
   FROM linkgroup;

ALTER TABLE linkgroupview OWNER TO postgres;


UPDATE system_devicespec SET strcpuoid='$2620.1.6.7.2.4.0',strmemoid='$2620.1.6.7.1.4.0*100.0/$2620.1.6.7.1.3.0',strshowruncmd='',strshowiproutecmd='',strshowroutecountcmd='',strshowarpcmd='',strshowcamcmd='',strpage1cmd='',strtoenablecmd='',strshowcdpcmd='',strinvalidcommandkey='',strquit='',strshowstpcmd='' WHERE strvendorname='Checkpoint' and strmodelname='' and idevicetype=2007;
UPDATE system_devicespec SET strcpuoid='$1.3.6.1.4.1.9.2.1.56.0',strmemoid='$1.3.6.1.4.1.9.9.48.1.1.1.5.1*100.0/($1.3.6.1.4.1.9.9.48.1.1.1.6.1+$1.3.6.1.4.1.9.9.48.1.1.1.5.1)',strshowruncmd='show run',strshowiproutecmd='show ip route',strshowroutecountcmd='show ip route summary',strshowarpcmd='show arp',strshowcamcmd='',strpage1cmd='terminal length 0',strtoenablecmd='enable',strshowcdpcmd='show cdp neighbor detail',strinvalidcommandkey='Incomplete||Unknown||Invalid||Ambiguous||%',strquit='exit',strshowstpcmd='' WHERE strvendorname='cisco' and strmodelname='' and idevicetype=2;
UPDATE system_devicespec SET strcpuoid='$1.3.6.1.4.1.9.9.109.1.1.1.1.3.1',strmemoid='$1.3.6.1.4.1.9.9.48.1.1.1.5.1*100.0/($1.3.6.1.4.1.9.9.48.1.1.1.6.1+$1.3.6.1.4.1.9.9.48.1.1.1.5.1)',strshowruncmd='write terminal',strshowiproutecmd='show route',strshowroutecountcmd='',strshowarpcmd='show arp',strshowcamcmd='',strpage1cmd='no pager',strtoenablecmd='enable',strshowcdpcmd='',strinvalidcommandkey='?||%',strquit='exit',strshowstpcmd='' WHERE strvendorname='cisco' and strmodelname='' and idevicetype=2002;
UPDATE system_devicespec SET strcpuoid='$1.3.6.1.4.1.9.9.109.1.1.1.1.5.9',strmemoid='$1.3.6.1.4.1.9.9.48.1.1.1.5.1*100.0/($1.3.6.1.4.1.9.9.48.1.1.1.6.1+$1.3.6.1.4.1.9.9.48.1.1.1.5.1)',strshowruncmd='show config',strshowiproutecmd='show route',strshowroutecountcmd='',strshowarpcmd='',strshowcamcmd='show cam dynamic||show cam static',strpage1cmd='set length 0',strtoenablecmd='enable',strshowcdpcmd='show cdp neighbor detail',strinvalidcommandkey='Unknown command',strquit='exit',strshowstpcmd='show spantree blockedports' WHERE strvendorname='cisco' and strmodelname='' and idevicetype=2060;
UPDATE system_devicespec SET strcpuoid='$1.3.6.1.4.1.3224.16.1.4.0',strmemoid='$1.3.6.1.4.1.3224.16.2.1.0*100.0/($1.3.6.1.4.1.3224.16.1.1.0+$1.3.6.1.4.1.3224.16.2.2.0)',strshowruncmd='get config',strshowiproutecmd='get route',strshowroutecountcmd='',strshowarpcmd='',strshowcamcmd='',strpage1cmd='set console page 0',strtoenablecmd='',strshowcdpcmd='',strinvalidcommandkey='^-',strquit='',strshowstpcmd='' WHERE strvendorname='netscreen' and strmodelname='' and idevicetype=2008;
UPDATE system_devicespec SET strcpuoid='$1.3.6.1.4.1.9.2.1.56.0',strmemoid='$1.3.6.1.4.1.9.9.48.1.1.1.5.1*100.0/($1.3.6.1.4.1.9.9.48.1.1.1.6.1+$1.3.6.1.4.1.9.9.48.1.1.1.5.1)',strshowruncmd='show run',strshowiproutecmd='show ip route',strshowroutecountcmd='show ip route summary',strshowarpcmd='show arp',strshowcamcmd='show mac-address-table||show mac address-table',strpage1cmd='terminal length 0',strtoenablecmd='enable',strshowcdpcmd='show cdp neighbor detail',strinvalidcommandkey='Incomplete||Unknown||Invalid||Ambiguous||%',strquit='exit',strshowstpcmd='show spanning-tree blockedports' WHERE strvendorname='cisco' and strmodelname='' and idevicetype=2001;
UPDATE system_devicespec SET strcpuoid='$1.3.6.1.4.1.3375.1.1.83.0',strmemoid='$1.3.6.1.4.1.3375.1.1.77.0*100.0/$1.3.6.1.4.1.3375.1.1.78.0',strshowruncmd='',strshowiproutecmd='',strshowroutecountcmd='',strshowarpcmd='',strshowcamcmd='',strpage1cmd='',strtoenablecmd='',strshowcdpcmd='',strinvalidcommandkey='',strquit='exit',strshowstpcmd='' WHERE strvendorname='F5' and strmodelname='' and idevicetype=2003;
UPDATE system_devicespec SET strcpuoid='',strmemoid='',strshowruncmd='show config|no-more',strshowiproutecmd='show route table inet.0|no-more',strshowroutecountcmd='show route summary',strshowarpcmd='',strshowcamcmd='',strpage1cmd='set cli screen-length 0',strtoenablecmd='',strshowcdpcmd='',strinvalidcommandkey='',strquit='',strshowstpcmd='' WHERE strvendorname='Juniper' and strmodelname='' and idevicetype=102;
UPDATE system_devicespec SET strcpuoid='$1.3.6.1.4.1.9.9.109.1.1.1.1.3.1',strmemoid='$1.3.6.1.4.1.9.9.48.1.1.1.5.1*100.0/($1.3.6.1.4.1.9.9.48.1.1.1.6.1+$1.3.6.1.4.1.9.9.48.1.1.1.5.1)',strshowruncmd='show run',strshowiproutecmd='show route',strshowroutecountcmd='',strshowarpcmd='show arp',strshowcamcmd='',strpage1cmd='no terminal pager 0',strtoenablecmd='enable',strshowcdpcmd='',strinvalidcommandkey='Incomplete||Unknown||Invalid||Ambiguous||%',strquit='exit',strshowstpcmd='' WHERE strvendorname='cisco' and strmodelname='' and idevicetype=2009;
UPDATE system_devicespec SET strcpuoid='$1.3.6.1.4.1.9.9.109.1.1.1.1.3.1',strmemoid='$1.3.6.1.4.1.9.9.48.1.1.1.5.1*100.0/($1.3.6.1.4.1.9.9.48.1.1.1.6.1+$1.3.6.1.4.1.9.9.48.1.1.1.5.1)',strshowruncmd='show run',strshowiproutecmd='show ip route',strshowroutecountcmd='show ip route summary',strshowarpcmd='show arp',strshowcamcmd='show dot11 association',strpage1cmd='terminal length 0',strtoenablecmd='enable',strshowcdpcmd='show cdp neighbor detail',strinvalidcommandkey='Incomplete||Unknown||Invalid||Ambiguous||%',strquit='exit',strshowstpcmd='' WHERE strvendorname='cisco' and strmodelname='' and idevicetype=1025;
UPDATE system_devicespec SET strcpuoid='$1916.1.1.1.28.0',strmemoid='',strshowruncmd='show config',strshowiproutecmd='',strshowroutecountcmd='',strshowarpcmd='',strshowcamcmd='',strpage1cmd='disable clipaging',strtoenablecmd='',strshowcdpcmd='',strinvalidcommandkey='Syntax error',strquit='quit',strshowstpcmd='' WHERE strvendorname='Extreme' and strmodelname='' and idevicetype=2023;
UPDATE system_devicespec SET strcpuoid='$1.3.6.1.4.1.43.45.1.6.1.1.1.2',strmemoid='$1.3.6.1.4.1.43.45.1.6.1.2.1.1.4*100.0/$1.3.6.1.4.1.43.45.1.6.1.2.1.1.2',strshowruncmd='display current-configuration',strshowiproutecmd='display ip routing-table',strshowroutecountcmd='display ip routing-table statistics',strshowarpcmd='display arp all||display arp',strshowcamcmd='display mac-address',strpage1cmd='',strtoenablecmd='super',strshowcdpcmd='display lldp neighbor-information',strinvalidcommandkey='%',strquit='quit',strshowstpcmd='' WHERE strvendorname='3Com' and strmodelname='' and idevicetype=3333;
UPDATE system_devicespec SET strcpuoid='$1.3.6.1.4.1.2011.2.23.1.18.1.3.0',strmemoid='($1.3.6.1.4.1.2011.6.1.2.1.1.2.65536-$1.3.6.1.4.1.2011.6.1.2.1.1.3.65536)*100.0/$1.3.6.1.4.1.2011.6.1.2.1.1.2.65536',strshowruncmd='display current-configuration',strshowiproutecmd='display ip routing-table',strshowroutecountcmd='display ip routing-table statistics',strshowarpcmd='display arp',strshowcamcmd='display mac-address',strpage1cmd='',strtoenablecmd='super',strshowcdpcmd='display lldp neighbor-information',strinvalidcommandkey='%',strquit='quit',strshowstpcmd='' WHERE strvendorname='3Com' and strmodelname='s5100' and idevicetype=3333;
UPDATE system_devicespec SET strcpuoid='$1.3.6.1.4.1.15004.4.2.2.2.0*100.0/$1.3.6.1.4.1.15004.4.2.3.5.0',strmemoid='$1.3.6.1.4.1.15004.4.2.2.6.0',strshowruncmd='',strshowiproutecmd='',strshowroutecountcmd='',strshowarpcmd='',strshowcamcmd='',strpage1cmd='',strtoenablecmd='',strshowcdpcmd='',strinvalidcommandkey='',strquit='',strshowstpcmd='' WHERE strvendorname='RuggedCom' and strmodelname='unclassfied switch' and idevicetype=2061;
UPDATE system_devicespec SET strcpuoid='$1.3.6.1.4.1.9.9.109.1.1.1.1.7.1',strmemoid='$1.3.6.1.4.1.9.9.305.1.1.2.0',strshowruncmd='show run',strshowiproutecmd='show ip route vrf all',strshowroutecountcmd='',strshowarpcmd='show ip arp vrf all',strshowcamcmd='show mac-address-table||show mac address-table',strpage1cmd='terminal length 0',strtoenablecmd='enable',strshowcdpcmd='show cdp neighbor detail',strinvalidcommandkey='Incomplete||Unknown||Invalid||Ambiguous||%',strquit='exit',strshowstpcmd='' WHERE strvendorname='cisco' and strmodelname='' and idevicetype=2004;
UPDATE system_devicespec SET strcpuoid='$1.3.6.1.4.1.9.9.109.1.1.1.1.8.1',strmemoid='$1.3.6.1.4.1.9.9.305.1.1.2.0',strshowruncmd='show run',strshowiproutecmd='show ip route vrf all',strshowroutecountcmd='',strshowarpcmd='show ip arp vrf all',strshowcamcmd='show mac-address-table||show mac address-table',strpage1cmd='terminal length 0',strtoenablecmd='enable',strshowcdpcmd='show cdp neighbor detail',strinvalidcommandkey='Incomplete||Unknown||Invalid||Ambiguous||%',strquit='exit',strshowstpcmd='' WHERE strvendorname='cisco' and strmodelname='N1KV' and idevicetype=2004;
UPDATE system_devicespec SET strcpuoid='$1.3.6.1.4.1.1991.1.1.2.1.51.0',strmemoid='($1.3.6.1.4.1.1991.1.1.2.1.54.0-$1.3.6.1.4.1.1991.1.1.2.1.55.0)*100/$1.3.6.1.4.1.1991.1.1.2.1.54.0',strshowruncmd='',strshowiproutecmd='',strshowroutecountcmd='',strshowarpcmd='',strshowcamcmd='',strpage1cmd='',strtoenablecmd='',strshowcdpcmd='',strinvalidcommandkey='',strquit='',strshowstpcmd='' WHERE strvendorname='Foundry' and strmodelname='' and idevicetype=2024;


