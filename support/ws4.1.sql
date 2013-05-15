\connect "nbws"

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

INSERT INTO objtimestamp (typename, modifytime, userid) VALUES ('discover_missdevice', '1900-01-01 00:00:00', -1);
INSERT INTO objtimestamp (typename, modifytime, userid) VALUES ('discover_newdevice', '1900-01-01 00:00:00', -1);
INSERT INTO objtimestamp (typename, modifytime, userid) VALUES ('discover_snmpdevice', '1900-01-01 00:00:00', -1);
INSERT INTO objtimestamp (typename, modifytime, userid) VALUES ('discover_unknowdevice', '1900-01-01 00:00:00', -1);
INSERT INTO objtimestamp (typename, modifytime, userid) VALUES ('unknownip', '1900-01-01 00:00:00', -1);


CREATE OR REPLACE VIEW discover_missdeviceview AS 
 SELECT discover_missdevice.id, discover_missdevice.mgrip, discover_missdevice.devtype, discover_missdevice.vendor, discover_missdevice.model, discover_missdevice.checktime, discover_missdevice.modifytime, discover_missdevice.deviceid, ( SELECT devices.strname
           FROM devices
          WHERE devices.id = discover_missdevice.deviceid) AS devicename
   FROM discover_missdevice;

ALTER TABLE discover_missdeviceview OWNER TO postgres;


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
		update objtimestamp set modifytime=now() where typename='discover_missdevice';
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='discover_missdevice';		
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='discover_missdevice';
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


CREATE OR REPLACE FUNCTION view_discover_missdeviceview(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying)
  RETURNS SETOF discover_missdeviceview AS
$BODY$
declare
	r discover_missdeviceview%rowtype;
	t timestamp without time zone;
BEGIN
	select modifytime into t from objtimestamp where typename=stypename;
	
	if t is null or t>dt then
		if imax <0 then
			for r in SELECT * FROM discover_missdeviceview where id>ibegin order by id loop
			return next r;
			end loop;
		else
			for r in SELECT * FROM discover_missdeviceview where id>ibegin order by id limit imax loop
			return next r;
			end loop;

		end if;	
	end if;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION view_discover_missdeviceview(integer, integer, timestamp without time zone, character varying) OWNER TO postgres;



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
			OLD.log = NEW.log
		 then
			return OLD;
		end IF;
		update objtimestamp set modifytime=now() where typename='discover_newdevice';
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='discover_newdevice';		
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='discover_newdevice';
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


CREATE OR REPLACE VIEW discover_newdeviceview AS 
 SELECT id, hostname, mgrip, devtype, vendor, model, findtime
  FROM discover_newdevice;
ALTER TABLE discover_newdeviceview OWNER TO postgres;


CREATE OR REPLACE FUNCTION view_discover_newdevice(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying)
  RETURNS SETOF discover_newdeviceview AS
$BODY$
declare
	r discover_newdeviceview%rowtype;
	t timestamp without time zone;
BEGIN
	select modifytime into t from objtimestamp where typename=stypename;
	
	if t is null or t>dt then
		if imax <0 then
			for r in SELECT * FROM discover_newdeviceview where id>ibegin order by id loop
			return next r;
			end loop;
		else
			for r in SELECT * FROM discover_newdeviceview where id>ibegin order by id limit imax loop
			return next r;
			end loop;

		end if;	
	end if;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION view_discover_newdevice(integer, integer, timestamp without time zone, character varying) OWNER TO postgres;



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
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='discover_snmpdevice';		
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='discover_snmpdevice';
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


CREATE OR REPLACE VIEW discover_snmpdeviceview AS 
 SELECT id, hostname, mgrip, snmpro, devtype, vendor, model, findtime
  FROM discover_snmpdevice;
ALTER TABLE discover_snmpdeviceview OWNER TO postgres;


CREATE OR REPLACE FUNCTION view_discover_snmpdevice(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying)
  RETURNS SETOF discover_snmpdeviceview AS
$BODY$
declare
	r discover_snmpdeviceview%rowtype;
	t timestamp without time zone;
BEGIN
	select modifytime into t from objtimestamp where typename=stypename;
	
	if t is null or t>dt then
		if imax <0 then
			for r in SELECT * FROM discover_snmpdeviceview where id>ibegin order by id loop
			return next r;
			end loop;
		else
			for r in SELECT * FROM discover_snmpdeviceview where id>ibegin order by id limit imax loop
			return next r;
			end loop;

		end if;	
	end if;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION view_discover_snmpdevice(integer, integer, timestamp without time zone, character varying) OWNER TO postgres;  


CREATE OR REPLACE FUNCTION process_discover_unknowdevice_dt()
  RETURNS trigger AS
$BODY$

    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF	OLD.mgrip = NEW.mgrip AND
			OLD.snmpro = NEW.snmpro AND
			OLD.devtype = NEW.devtype AND
			OLD.sysobjectid = NEW.sysobjectid AND
			OLD.discoverfrom = NEW.discoverfrom AND
			OLD.findtime = NEW.findtime AND
			OLD.log = NEW.log
		 then
			return OLD;
		end IF;
		update objtimestamp set modifytime=now() where typename='discover_unknowdevice';
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='discover_unknowdevice';		
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='discover_unknowdevice';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION process_discover_unknowdevice_dt() OWNER TO postgres;  


CREATE TRIGGER discover_unknowdevice_dt
  BEFORE INSERT OR UPDATE OR DELETE
  ON discover_unknowdevice
  FOR EACH ROW
  EXECUTE PROCEDURE process_discover_unknowdevice_dt();


  CREATE OR REPLACE VIEW discover_unknowdeviceview AS 
SELECT id, mgrip, snmpro, devtype, sysobjectid, discoverfrom, findtime
  FROM discover_unknowdevice;
ALTER TABLE discover_unknowdeviceview OWNER TO postgres;


CREATE OR REPLACE FUNCTION view_discover_unknowdevice(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying)
  RETURNS SETOF discover_unknowdeviceview AS
$BODY$
declare
	r discover_unknowdeviceview%rowtype;
	t timestamp without time zone;
BEGIN
	select modifytime into t from objtimestamp where typename=stypename;
	
	if t is null or t>dt then
		if imax <0 then
			for r in SELECT * FROM discover_unknowdeviceview where id>ibegin order by id loop
			return next r;
			end loop;
		else
			for r in SELECT * FROM discover_unknowdeviceview where id>ibegin order by id limit imax loop
			return next r;
			end loop;

		end if;	
	end if;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION view_discover_unknowdevice(integer, integer, timestamp without time zone, character varying) OWNER TO postgres;  


ALTER TABLE unknownip ADD COLUMN collectsource integer;
ALTER TABLE unknownip ALTER COLUMN collectsource SET STORAGE PLAIN;
update unknownip set collectsource=0 where collectsource is null;
ALTER TABLE unknownip ALTER COLUMN collectsource SET NOT NULL;
ALTER TABLE unknownip ALTER COLUMN collectsource SET DEFAULT 0;

ALTER TABLE unknownip ADD COLUMN description text;
ALTER TABLE unknownip ALTER COLUMN description SET STORAGE EXTENDED;
update unknownip set description='' where description is null;

ALTER TABLE unknownip ADD COLUMN itype integer;
ALTER TABLE unknownip ALTER COLUMN itype SET STORAGE PLAIN;
update unknownip set itype=0 where itype is null;
ALTER TABLE unknownip ALTER COLUMN itype SET NOT NULL;


CREATE OR REPLACE FUNCTION process_unknownip_dt()
  RETURNS trigger AS
$BODY$

    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF	OLD.nexthopip = NEW.nexthopip AND
			OLD.edgedevice = NEW.edgedevice AND
			OLD.edgeintf = NEW.edgeintf AND
			OLD.ipfrom = NEW.ipfrom AND
			OLD.ipmask = NEW.ipmask AND
			OLD.intfdesc = NEW.intfdesc AND
			OLD.findtime = NEW.findtime AND
			OLD.collectsource=NEW.collectsource AND
			OLD.description=NEW.description AND
			OLD.itype=NEW.itype
		 then
			return OLD;
		end IF;
		update objtimestamp set modifytime=now() where typename='unknownip';	
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN		
		update objtimestamp set modifytime=now() where typename='unknownip';		
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='unknownip';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION process_unknownip_dt() OWNER TO postgres;


CREATE TRIGGER unknownip_dt
  BEFORE INSERT OR UPDATE OR DELETE
  ON unknownip
  FOR EACH ROW
  EXECUTE PROCEDURE process_unknownip_dt();


CREATE OR REPLACE FUNCTION view_unknownip(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying)
  RETURNS SETOF unknownip AS
$BODY$
declare
	r unknownip%rowtype;
	t timestamp without time zone;
BEGIN
	select modifytime into t from objtimestamp where typename=stypename;
	
	if t is null or t>dt then
		if imax <0 then
			for r in SELECT * FROM unknownip where id>ibegin order by id loop
			return next r;
			end loop;
		else
			for r in SELECT * FROM unknownip where id>ibegin order by id limit imax loop
			return next r;
			end loop;

		end if;	
	end if;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION view_unknownip(integer, integer, timestamp without time zone, character varying) OWNER TO postgres;


INSERT INTO objtimestamp (typename, modifytime, userid) VALUES ('internetboundaryinterface', '1900-01-01 00:00:00', -1);

CREATE TABLE internetboundaryinterface
(
  id serial NOT NULL,
  deviceid integer NOT NULL,
  interfaceid integer NOT NULL,
  interfaceip character varying(100) NOT NULL,
  CONSTRAINT internetboundaryinterface_pk PRIMARY KEY (id),
  CONSTRAINT internetboundaryinterface_un UNIQUE (deviceid, interfaceid,interfaceip)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE internetboundaryinterface OWNER TO postgres;


CREATE OR REPLACE FUNCTION process_internetboundaryinterface_dt()
  RETURNS trigger AS
$BODY$

    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF	OLD.deviceid = NEW.deviceid AND
			OLD.interfaceid = NEW.interfaceid AND
			OLD.interfaceip = NEW.interfaceip
		 then
			return OLD;
		end IF;
		update objtimestamp set modifytime=now() where typename='internetboundaryinterface';
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='internetboundaryinterface';		
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='internetboundaryinterface';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION process_internetboundaryinterface_dt() OWNER TO postgres;  


CREATE TRIGGER internetboundaryinterface_dt
  BEFORE INSERT OR UPDATE OR DELETE
  ON internetboundaryinterface
  FOR EACH ROW
  EXECUTE PROCEDURE process_internetboundaryinterface_dt();


CREATE OR REPLACE VIEW internetboundaryinterfaceview AS 
 select internetboundaryinterface.*,devices.strname as devicename,interfacesetting.interfacename,interfacesetting.description 
    from internetboundaryinterface,devices,interfacesetting where internetboundaryinterface.deviceid=devices.id and 
      internetboundaryinterface.interfaceid=interfacesetting.id;

ALTER TABLE internetboundaryinterfaceview OWNER TO postgres;


CREATE OR REPLACE FUNCTION view_internetboundaryinterfaceview_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying)
  RETURNS SETOF internetboundaryinterfaceview AS
$BODY$
declare
	r internetboundaryinterfaceview%rowtype;
	t timestamp without time zone;
BEGIN		
	select modifytime into t from objtimestamp where typename=stypename;
	if t is null or t>dt then
		if imax <0 then
			for r in SELECT * FROM internetboundaryinterfaceview where id>ibegin order by id  loop
			return next r;
			end loop;
		else
			for r in SELECT * FROM internetboundaryinterfaceview where id>ibegin order by id limit imax loop
			return next r;
			end loop;

		end if;	
	End IF;		
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION view_internetboundaryinterfaceview_retrieve(integer, integer, timestamp without time zone, character varying) OWNER TO postgres;



CREATE TABLE transport_protocol_port
(
  id serial NOT NULL,
  servername character varying(100) NOT NULL,
  portnumber integer NOT NULL,
  protocol character varying(50) NOT NULL,
  description character varying(250),
  userflag integer NOT NULL DEFAULT 0,
  CONSTRAINT transport_protocol_port_pk PRIMARY KEY (id),
  CONSTRAINT transport_protocol_port_un UNIQUE (portnumber, protocol)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE transport_protocol_port OWNER TO postgres;


CREATE OR REPLACE FUNCTION view_transport_protocol_port(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying)
  RETURNS SETOF transport_protocol_port AS
$BODY$
declare
	r transport_protocol_port%rowtype;
	t timestamp without time zone;
BEGIN
	select modifytime into t from objtimestamp where typename=stypename;
	
	if t is null or t>dt then
		if imax <0 then
			for r in SELECT * FROM transport_protocol_port where id>ibegin order by id loop
			return next r;
			end loop;
		else
			for r in SELECT * FROM transport_protocol_port where id>ibegin order by id limit imax loop
			return next r;
			end loop;

		end if;	
	end if;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION view_transport_protocol_port(integer, integer, timestamp without time zone, character varying) OWNER TO postgres; 


INSERT INTO objtimestamp (typename, modifytime, userid) VALUES ('transport_protocol_port', now(), -1);


CREATE TABLE sys_environmentvariable
(
  id serial NOT NULL,
  variable character varying(50) NOT NULL,
  "value" character varying(50),
  CONSTRAINT sys_environmentvariable_pk PRIMARY KEY (id),
  CONSTRAINT sys_environmentvariable_un UNIQUE (variable)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE sys_environmentvariable OWNER TO postgres;

INSERT INTO sys_environmentvariable(variable) VALUES ('donotscan');
INSERT INTO sys_environmentvariable(variable) VALUES ('managementip');



CREATE TABLE datastoragesetting
(
  id serial NOT NULL,
  kindname character varying(100) NOT NULL,
  ischeck boolean NOT NULL DEFAULT false,
  beforedays integer NOT NULL DEFAULT 0,
  CONSTRAINT datastoragesetting_pk PRIMARY KEY (id),
  CONSTRAINT datastoragesetting_un UNIQUE (kindname)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE datastoragesetting OWNER TO postgres;

INSERT INTO datastoragesetting(kindname, ischeck, beforedays) VALUES ('DataFolder', FALSE, 30);
INSERT INTO datastoragesetting(kindname, ischeck, beforedays) VALUES ('OneIPTable', FALSE, 7);



CREATE TABLE ouinfo
(
  id serial NOT NULL,
  mac_prefix character varying(10) NOT NULL,
  vendor character varying(256),
  flag boolean NOT NULL DEFAULT false,
  CONSTRAINT ouinfo_pk PRIMARY KEY (id),
  CONSTRAINT ouinfo_un UNIQUE (mac_prefix)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE ouinfo OWNER TO postgres;



CREATE OR REPLACE FUNCTION view_ouinfo(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying)
  RETURNS SETOF ouinfo AS
$BODY$
declare
	r ouinfo%rowtype;
	t timestamp without time zone;
BEGIN
	select modifytime into t from objtimestamp where typename=stypename;
	
	if t is null or t>dt then
		if imax <0 then
			for r in SELECT * FROM ouinfo where id>ibegin order by id loop
			return next r;
			end loop;
		else
			for r in SELECT * FROM ouinfo where id>ibegin order by id limit imax loop
			return next r;
			end loop;

		end if;	
	end if;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION view_ouinfo(integer, integer, timestamp without time zone, character varying) OWNER TO postgres; 


INSERT INTO objtimestamp (typename, modifytime, userid) VALUES ('ouinfo', now(), -1);


update system_devicespec set strshowstpcmd='show spanning-tree blockedports' where strvendorname='cisco' and idevicetype=2004 and strshowiproutecmd='';


INSERT INTO sys_option(op_name, op_value) VALUES ('autostopbenchmarktimer', 0);
INSERT INTO sys_option(op_name, op_value) VALUES ('issetautostopbenchmarktimer', 0);



/* --------------------------------   device property start   -----------------------------------*/


ALTER TABLE device_property ADD COLUMN extradata text;
ALTER TABLE device_property ALTER COLUMN extradata SET STORAGE EXTENDED;
update device_property set extradata='' where extradata is null;


DROP FUNCTION device_customized_infoview_upsert(device_customized_infoview);
DROP FUNCTION device_customized_info_delete(device_customized_infoview);
DROP FUNCTION view_device_customized_info_retrieve(integer, integer, timestamp without time zone, character varying);
DROP VIEW device_customized_infoview;
DROP FUNCTION device_property_update(devicepropertyview);
DROP FUNCTION device_property_upsert(devicepropertyview);
DROP FUNCTION view_device_property_retrieve(integer, integer, timestamp without time zone, character varying);
DROP FUNCTION view_device_property_retrieve2(integer, integer, timestamp without time zone, character varying);
DROP VIEW devicepropertyviewfdown;
DROP VIEW devicepropertyview;


CREATE OR REPLACE VIEW devicepropertyview AS 
 SELECT device_property.*, devices.strname AS devicename, devices.isubtype AS itype
   FROM device_property, devices
  WHERE device_property.deviceid = devices.id
  ORDER BY device_property.id;

ALTER TABLE devicepropertyview OWNER TO postgres;


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
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION view_device_property_retrieve(integer, integer, timestamp without time zone, character varying) OWNER TO postgres;


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
			management_interface,
			extradata			
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
			dp.management_interface,
			dp.extradata			
			) 
			where id = ds_id;
		return ds_id;
	end if;
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION device_property_update(devicepropertyview) OWNER TO postgres;


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
			management_interface,
			extradata
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
			dp.management_interface,
			dp.extradata	
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
			management_interface,
			extradata			
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
			dp.management_interface,
			dp.extradata			
			) 
			where id = ds_id;
		return ds_id;
	end if;
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION device_property_upsert(devicepropertyview) OWNER TO postgres;



CREATE OR REPLACE VIEW device_customized_infoview AS 
 SELECT device_customized_info.id, device_customized_info.objectid, device_customized_info.attributeid, device_customized_info.attribute_value, device_customized_info.lasttimestamp, devicepropertyview.devicename
   FROM device_customized_info, devicepropertyview
  WHERE device_customized_info.objectid = devicepropertyview.id
  ORDER BY device_customized_info.id;

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


CREATE OR REPLACE VIEW devicepropertyviewfdown AS 
 SELECT device_property.*, devices.strname AS devicename, devices.isubtype AS itype, devicesetting.configfile_time
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

/* --------------------------------   device property end   -----------------------------------*/

/* --------------------------------   discover_newdevice start   -----------------------------------*/
DROP FUNCTION view_discover_newdevice(integer, integer, timestamp without time zone, character varying);
DROP VIEW discover_newdeviceview;

ALTER TABLE discover_newdevice ADD COLUMN lasttime character varying(20);
ALTER TABLE discover_newdevice ALTER COLUMN lasttime SET STORAGE EXTENDED;

DROP TRIGGER discover_newdevice_dt ON discover_newdevice;
DROP FUNCTION process_discover_newdevice_dt();

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
		update objtimestamp set modifytime=now() where typename='discover_newdevice';
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='discover_newdevice';		
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='discover_newdevice';
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

update discover_newdevice set lasttime=findtime where lasttime is null;

ALTER TABLE discover_newdevice ALTER COLUMN lasttime SET NOT NULL;

CREATE OR REPLACE VIEW discover_newdeviceview AS 
 SELECT discover_newdevice.id, discover_newdevice.hostname, discover_newdevice.mgrip, discover_newdevice.devtype, discover_newdevice.vendor, discover_newdevice.model, discover_newdevice.findtime,discover_newdevice.lasttime 
   FROM discover_newdevice;

ALTER TABLE discover_newdeviceview OWNER TO postgres;

CREATE OR REPLACE FUNCTION view_discover_newdevice(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying)
  RETURNS SETOF discover_newdeviceview AS
$BODY$
declare
	r discover_newdeviceview%rowtype;
	t timestamp without time zone;
BEGIN
	select modifytime into t from objtimestamp where typename=stypename;
	
	if t is null or t>dt then
		if imax <0 then
			for r in SELECT * FROM discover_newdeviceview where id>ibegin order by id loop
			return next r;
			end loop;
		else
			for r in SELECT * FROM discover_newdeviceview where id>ibegin order by id limit imax loop
			return next r;
			end loop;

		end if;	
	end if;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION view_discover_newdevice(integer, integer, timestamp without time zone, character varying) OWNER TO postgres;

/* --------------------------------   discover_newdevice end   -----------------------------------*/

/* --------------------------------   discover_unknowdevice start   -----------------------------------*/
DROP FUNCTION view_discover_unknowdevice(integer, integer, timestamp without time zone, character varying);
DROP VIEW discover_unknowdeviceview;


ALTER TABLE discover_unknowdevice ADD COLUMN devname character varying(256);
ALTER TABLE discover_unknowdevice ALTER COLUMN devname SET STORAGE EXTENDED;

DROP TRIGGER discover_unknowdevice_dt ON discover_unknowdevice;
DROP FUNCTION process_discover_unknowdevice_dt();

update discover_unknowdevice set devname='' where devname is null;

CREATE OR REPLACE FUNCTION process_discover_unknowdevice_dt()
  RETURNS trigger AS
$BODY$

    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF	OLD.mgrip = NEW.mgrip AND
			OLD.snmpro = NEW.snmpro AND
			OLD.devtype = NEW.devtype AND
			OLD.sysobjectid = NEW.sysobjectid AND
			OLD.discoverfrom = NEW.discoverfrom AND
			OLD.findtime = NEW.findtime AND
			OLD.log = NEW.log AND
			OLD.devname = NEW.devname
		 then
			return OLD;
		end IF;
		update objtimestamp set modifytime=now() where typename='discover_unknowdevice';
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='discover_unknowdevice';		
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='discover_unknowdevice';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION process_discover_unknowdevice_dt() OWNER TO postgres;

CREATE TRIGGER discover_unknowdevice_dt
  BEFORE INSERT OR UPDATE OR DELETE
  ON discover_unknowdevice
  FOR EACH ROW
  EXECUTE PROCEDURE process_discover_unknowdevice_dt();


CREATE OR REPLACE VIEW discover_unknowdeviceview AS 
 SELECT discover_unknowdevice.id, discover_unknowdevice.mgrip, discover_unknowdevice.snmpro, discover_unknowdevice.devtype, discover_unknowdevice.sysobjectid, discover_unknowdevice.discoverfrom, discover_unknowdevice.findtime,discover_unknowdevice.devname 
   FROM discover_unknowdevice;

ALTER TABLE discover_unknowdeviceview OWNER TO postgres;


CREATE OR REPLACE FUNCTION view_discover_unknowdevice(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying)
  RETURNS SETOF discover_unknowdeviceview AS
$BODY$
declare
	r discover_unknowdeviceview%rowtype;
	t timestamp without time zone;
BEGIN
	select modifytime into t from objtimestamp where typename=stypename;
	
	if t is null or t>dt then
		if imax <0 then
			for r in SELECT * FROM discover_unknowdeviceview where id>ibegin order by id loop
			return next r;
			end loop;
		else
			for r in SELECT * FROM discover_unknowdeviceview where id>ibegin order by id limit imax loop
			return next r;
			end loop;

		end if;	
	end if;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION view_discover_unknowdevice(integer, integer, timestamp without time zone, character varying) OWNER TO postgres;

/* --------------------------------   discover_unknowdevice end   -----------------------------------*/


/* --------------------------------   lwap start   -----------------------------------*/
INSERT INTO objtimestamp (typename, modifytime, userid) VALUES ('lwap', '1900-01-01 00:00:00', -1);

CREATE TABLE lwap
(
  id serial NOT NULL,
  hostname character varying(64) NOT NULL,
  "version" character varying(64),
  ipaddress character varying(64),
  macaddress character varying(64),
  sgroup character varying(64),
  primarycontroller character varying(64),
  secondarycontroll character varying(64),
  defaultgateway character varying(64),
  vendor character varying(64),
  module character varying(64),
  softwareversion character varying(64),
  serialnumber character varying(64),
  config text,
  CONSTRAINT lwap_pk PRIMARY KEY (id),
  CONSTRAINT lwap_un UNIQUE (hostname)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE lwap OWNER TO postgres;


CREATE OR REPLACE FUNCTION process_lwap_dt()
  RETURNS trigger AS
$BODY$

    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.hostname = NEW.hostname AND 
			OLD.version = NEW.version AND
			OLD.ipaddress = NEW.ipaddress AND
			OLD.macaddress = NEW.macaddress AND
			OLD.sgroup = NEW.sgroup AND
			OLD.primarycontroller = NEW.primarycontroller AND
			OLD.secondarycontroll = NEW.secondarycontroll AND
			OLD.defaultgateway = NEW.defaultgateway AND
			OLD.vendor = NEW.vendor AND
			OLD.module = NEW.module AND
			OLD.softwareversion = NEW.softwareversion AND			
			OLD.config = NEW.config AND
			OLD.serialnumber = NEW.serialnumber		
		 then
			return OLD;
		end IF;
		update objtimestamp set modifytime=now() where typename='lwap';
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='lwap';		
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='lwap';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION process_lwap_dt() OWNER TO postgres;


CREATE TRIGGER lwap_dt
  BEFORE INSERT OR UPDATE OR DELETE
  ON lwap
  FOR EACH ROW
  EXECUTE PROCEDURE process_lwap_dt();


CREATE OR REPLACE FUNCTION view_lwap(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying)
  RETURNS SETOF lwap AS
$BODY$
declare
	r lwap%rowtype;
	t timestamp without time zone;
BEGIN
	select modifytime into t from objtimestamp where typename=stypename;
	
	if t is null or t>dt then
		if imax <0 then
			for r in SELECT * FROM lwap where id>ibegin order by id loop
			return next r;
			end loop;
		else
			for r in SELECT * FROM lwap where id>ibegin order by id limit imax loop
			return next r;
			end loop;

		end if;	
	end if;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION view_lwap(integer, integer, timestamp without time zone, character varying) OWNER TO postgres;
  



/* --------------------------------   lwap end   -----------------------------------*/


/* --------------------------------   discovery report end   -----------------------------------*/

CREATE OR REPLACE VIEW discover_missdeviceview2 AS 
 SELECT discover_missdevice.id, discover_missdevice.mgrip, discover_missdevice.devtype, discover_missdevice.vendor, discover_missdevice.model, discover_missdevice.checktime, discover_missdevice.log, discover_missdevice.modifytime, discover_missdevice.deviceid, ( SELECT devices.strname
           FROM devices
          WHERE devices.id = discover_missdevice.deviceid) AS hostname
   FROM discover_missdevice;

ALTER TABLE discover_missdeviceview2 OWNER TO postgres;

CREATE OR REPLACE FUNCTION discovereport_missdevice(r discover_missdeviceview2)
  RETURNS integer AS
$BODY$
declare
	r_id integer;
	ds_id integer;
BEGIN
	select id into r_id from devices where strname=r.hostname;
	if r_id IS NULL THEN
		return -1;
	end if;
	
	select id into ds_id from discover_missdevice where deviceid=r_id;
	if ds_id IS NULL THEN
		insert into discover_missdevice(
			  mgrip,
			  devtype,
			  vendor,
			  model,
			  checktime,
			  "log",
			  modifytime,
			  deviceid
			  )
			  values( 
			  r.mgrip,
			  r.devtype,
			  r.vendor,
			  r.model,
			  r.checktime,
			  r.log,
			  r.modifytime,
			  r_id
			  );
			  return lastval();
	else
		update discover_missdevice set(
			  mgrip,
			  devtype,
			  vendor,
			  model,
			  checktime,
			  "log",
			  modifytime
			  ) = ( 			 
			  r.mgrip,
			  r.devtype,
			  r.vendor,
			  r.model,
			  r.checktime,
			  r.log,
			  r.modifytime
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
ALTER FUNCTION discovereport_missdevice(discover_missdeviceview2) OWNER TO postgres;

CREATE OR REPLACE FUNCTION discovereport_newdevice(r discover_newdevice)
  RETURNS integer AS
$BODY$
declare	
	ds_id integer;
BEGIN		
	select id into ds_id from discover_newdevice where hostname=r.hostname;
	if ds_id IS NULL THEN
		insert into discover_newdevice(
			  mgrip,
			  devtype,
			  vendor,
			  model,
			  findtime,
			  "log",
			  lasttime,
			  hostname
			  )
			  values( 
			  r.mgrip,
			  r.devtype,
			  r.vendor,
			  r.model,
			  r.findtime,
			  r.log,
			  r.lasttime,
			  r.hostname
			  );
			  return lastval();
	else
		update discover_newdevice set(			  
			  "log",
			  lasttime
			  ) = ( 			 			  
			  r.log,
			  r.lasttime
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
ALTER FUNCTION discovereport_newdevice(discover_newdevice) OWNER TO postgres;

CREATE OR REPLACE FUNCTION discovereport_snmpdevice(r discover_snmpdevice)
  RETURNS integer AS
$BODY$
declare	
	ds_id integer;
BEGIN		
	select id into ds_id from discover_snmpdevice where hostname=r.hostname;
	if ds_id IS NULL THEN
		insert into discover_snmpdevice(
			  mgrip,
			  devtype,
			  vendor,
			  model,
			  findtime,
			  "log",
			  snmpro,
			  hostname
			  )
			  values( 
			  r.mgrip,
			  r.devtype,
			  r.vendor,
			  r.model,
			  r.findtime,
			  r.log,
			  r.snmpro,
			  r.hostname
			  );
			  return lastval();
	else
		update discover_snmpdevice set(
			  mgrip,
			  devtype,
			  vendor,
			  model,
			  findtime,
			  "log",
			  snmpro
			  ) = ( 			 
			  r.mgrip,
			  r.devtype,
			  r.vendor,
			  r.model,
			  r.findtime,
			  r.log,
			  r.snmpro
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
ALTER FUNCTION discovereport_snmpdevice(discover_snmpdevice) OWNER TO postgres;

CREATE OR REPLACE FUNCTION discovereport_unknowdevice(r discover_unknowdevice)
  RETURNS integer AS
$BODY$
declare	
	ds_id integer;
BEGIN		
	select id into ds_id from discover_unknowdevice where mgrip=r.mgrip;
	if ds_id IS NULL THEN
		insert into discover_unknowdevice(
			  mgrip,
			  snmpro,
			  devtype,	
			  sysobjectid,
			  discoverfrom,
			  findtime,
			  "log",
			  devname			  
			  )
			  values( 
			  r.mgrip,
			  r.snmpro,		
			  r.devtype,
			  r.sysobjectid,
			  r.discoverfrom,
			  r.findtime,			  
			  r.log,
			  r.devname			  
			  );
			  return lastval();
	else
		update discover_unknowdevice set(
			  snmpro,
			  devtype,	
			  sysobjectid,
			  discoverfrom,
			  findtime,
			  "log",
			  devname
			  ) = ( 			 
			  r.snmpro,		
			  r.devtype,
			  r.sysobjectid,
			  r.discoverfrom,
			  r.findtime,			  
			  r.log,
			  r.devname
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
ALTER FUNCTION discovereport_unknowdevice(discover_unknowdevice) OWNER TO postgres;


CREATE OR REPLACE FUNCTION discovereport_unknownip(r unknownip)
  RETURNS integer AS
$BODY$
declare	
	ds_id integer;
BEGIN		
	select id into ds_id from unknownip where nexthopip=r.nexthopip;
	if ds_id IS NULL THEN
		insert into unknownip(
			  nexthopip,
			  edgedevice,
			  edgeintf,	
			  ipfrom,
			  ipmask,
			  intfdesc,
			  findtime,
			  collectsource,
			  description,
			  itype			  
			  )
			  values( 
			  r.nexthopip,
			  r.edgedevice,
			  r.edgeintf,	
			  r.ipfrom,
			  r.ipmask,
			  r.intfdesc,
			  r.findtime,
			  r.collectsource,
			  r.description,
			  r.itype			  
			  );
			  return lastval();
	else
		update unknownip set(
			  edgedevice,
			  edgeintf,	
			  ipfrom,
			  ipmask,
			  intfdesc,
			  findtime,
			  collectsource,
			  description,
			  itype	
			  ) = ( 			 
			  r.edgedevice,
			  r.edgeintf,	
			  r.ipfrom,
			  r.ipmask,
			  r.intfdesc,
			  r.findtime,
			  r.collectsource,
			  r.description,
			  r.itype	
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
ALTER FUNCTION discovereport_unknownip(unknownip) OWNER TO postgres;


/* --------------------------------   discovery report end   -----------------------------------*/



/* --------------------------------   link group start   -----------------------------------*/

ALTER TABLE linkgroup ADD COLUMN istemplate boolean;
ALTER TABLE linkgroup ALTER COLUMN istemplate SET STORAGE PLAIN;

DROP TRIGGER linkgroup_dt ON linkgroup;
DROP FUNCTION process_linkgroup_dt();

update linkgroup set istemplate=false where istemplate is null;

ALTER TABLE linkgroup ALTER COLUMN istemplate SET NOT NULL;
ALTER TABLE linkgroup ALTER COLUMN istemplate SET DEFAULT false;

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
			OLD.searchcontainer =NEW.searchcontainer AND
			OLD.dev_searchcondition =NEW.dev_searchcondition AND
			OLD.dev_searchcontainer =NEW.dev_searchcontainer AND
			OLD.is_map_auto_link =NEW.is_map_auto_link AND
			OLD.istemplate =NEW.istemplate
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

CREATE TRIGGER linkgroup_dt
  BEFORE INSERT OR UPDATE OR DELETE
  ON linkgroup
  FOR EACH ROW
  EXECUTE PROCEDURE process_linkgroup_dt();

DROP FUNCTION view_linkgroup_retrieve(integer, integer, timestamp without time zone, integer, character varying);
DROP VIEW linkgroupview;

CREATE OR REPLACE VIEW linkgroupview AS 
 SELECT linkgroup.id, linkgroup.strname, linkgroup.strdesc, linkgroup.showcolor, linkgroup.showstyle, linkgroup.showwidth, linkgroup.searchcondition, linkgroup.userid, ( SELECT count(*) AS count
           FROM linkgroupinterface
          WHERE linkgroupinterface.groupid = linkgroup.id) AS irefcount, linkgroup.searchcontainer, linkgroup.dev_searchcondition, linkgroup.dev_searchcontainer, linkgroup.is_map_auto_link,linkgroup.istemplate
   FROM linkgroup;

ALTER TABLE linkgroupview OWNER TO postgres;

CREATE OR REPLACE FUNCTION view_linkgroup_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer, stypename character varying)
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
ALTER FUNCTION view_linkgroup_retrieve(integer, integer, timestamp without time zone, integer, character varying) OWNER TO postgres;


CREATE TABLE linkgroup_param
(
  id serial NOT NULL,
  linkgroupid integer NOT NULL,
  strname text NOT NULL,
  strdesc text,
  CONSTRAINT linkgroup_param_pk PRIMARY KEY (id),
  CONSTRAINT linkgroup_param_fk FOREIGN KEY (linkgroupid)
      REFERENCES linkgroup (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT linkgroup_param_name_un UNIQUE (strname,linkgroupid)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE linkgroup_param OWNER TO postgres;


CREATE OR REPLACE FUNCTION process_linkgroup_param_dt()
  RETURNS trigger AS
$BODY$
declare tid integer;
declare uid integer;
DECLARE newuserid integer;
DECLARE olduserid integer;
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.linkgroupid = NEW.linkgroupid AND 				
			OLD.strname = NEW.strname AND
			OLD.strdesc = NEW.strdesc
		then
			return OLD;
		end IF;
		select userid into newuserid from linkgroup where id=NEW.linkgroupid;
		select userid into olduserid from linkgroup where id=old.linkgroupid;

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
		select userid into newuserid from linkgroup where id=NEW.linkgroupid;
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
		select userid into olduserid from linkgroup where id=old.linkgroupid;
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
ALTER FUNCTION process_linkgroup_param_dt() OWNER TO postgres;



CREATE TRIGGER linkgroup_param_dt
  BEFORE INSERT OR UPDATE OR DELETE
  ON linkgroup_param
  FOR EACH ROW
  EXECUTE PROCEDURE process_linkgroup_param_dt();


CREATE TABLE linkgroup_paramvalue
(
  id serial NOT NULL,
  paramid integer NOT NULL,
  strvalue text NOT NULL,
  strdesc text,
  CONSTRAINT linkgroup_paramvalue_pk PRIMARY KEY (id),
  CONSTRAINT linkgroup_paramvalue_fk FOREIGN KEY (paramid)
      REFERENCES linkgroup_param (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
ALTER TABLE linkgroup_paramvalue OWNER TO postgres;


CREATE OR REPLACE FUNCTION process_linkgroup_paramvalue_dt()
  RETURNS trigger AS
$BODY$
declare tid integer;
declare uid integer;
DECLARE newuserid integer;
DECLARE olduserid integer;
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.paramid = NEW.paramid AND 				
			OLD.strvalue = NEW.strvalue AND
			OLD.strdesc = NEW.strdesc
		then
			return OLD;
		end IF;
		select linkgroup.userid into newuserid from linkgroup,linkgroup_param where linkgroup.id=linkgroup_param.linkgroupid and linkgroup_param.id=NEW.paramid;
		select linkgroup.userid into olduserid from linkgroup,linkgroup_param where linkgroup.id=linkgroup_param.linkgroupid and linkgroup_param.id=OLD.paramid;

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
		select linkgroup.userid into newuserid from linkgroup,linkgroup_param where linkgroup.id=linkgroup_param.linkgroupid and linkgroup_param.id=NEW.paramid;
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
		select linkgroup.userid into olduserid from linkgroup,linkgroup_param where linkgroup.id=linkgroup_param.linkgroupid and linkgroup_param.id=OLD.paramid;
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
ALTER FUNCTION process_linkgroup_paramvalue_dt() OWNER TO postgres;


CREATE TRIGGER linkgroup_paramvalue_dt
  BEFORE INSERT OR UPDATE OR DELETE
  ON linkgroup_paramvalue
  FOR EACH ROW
  EXECUTE PROCEDURE process_linkgroup_paramvalue_dt();

  
CREATE OR REPLACE FUNCTION linkgroup_param_delete(lid integer)
  RETURNS boolean AS
$BODY$
BEGIN
	delete from linkgroup_param where linkgroupid = lid;
	return true;
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION linkgroup_param_delete(integer) OWNER TO postgres;


CREATE OR REPLACE FUNCTION view_linkgroupparam_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer, stypename character varying)
  RETURNS SETOF linkgroup_param AS
$BODY$
declare
	r linkgroup_param%rowtype;
	t timestamp without time zone;
BEGIN	
	if uid=-1 then
		select modifytime into t from objtimestamp where typename=stypename;
	else
		select modifytime into t from objtimestamp where typename=stypename and userid=uid;
	end if;
	
	if t is null or t>dt then
		if imax <0 then
			for r in select * from linkgroup_param where linkgroupid in (SELECT id FROM linkgroup where id>ibegin and userid=uid order by id) order by id loop
			return next r;
			end loop;
		else
			for r in select * from linkgroup_param where linkgroupid in (SELECT id FROM linkgroup where id>ibegin and userid=uid order by id limit imax) order by id loop			
			return next r;
			end loop;

		end if;	
	end if;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION view_linkgroupparam_retrieve(integer, integer, timestamp without time zone, integer, character varying) OWNER TO postgres;


CREATE OR REPLACE FUNCTION view_linkgroup_paramvalue_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer, stypename character varying)
  RETURNS SETOF linkgroup_paramvalue AS
$BODY$
declare
	r linkgroup_paramvalue%rowtype;
	t timestamp without time zone;
BEGIN	
	if uid=-1 then
		select modifytime into t from objtimestamp where typename=stypename;
	else
		select modifytime into t from objtimestamp where typename=stypename and userid=uid;
	end if;
	
	if t is null or t>dt then
		if imax <0 then
			for r in select * from linkgroup_paramvalue where paramid in (SELECT linkgroup_param.id FROM linkgroup,linkgroup_param where linkgroup.id=linkgroup_param.linkgroupid and linkgroup.id>ibegin and linkgroup.userid=uid order by linkgroup.id) order by id loop
			return next r;
			end loop;
		else
			for r in select * from linkgroup_paramvalue where paramid in (SELECT linkgroup_param.id FROM linkgroup,linkgroup_param where linkgroup.id=linkgroup_param.linkgroupid and linkgroup.id>ibegin and linkgroup.userid=uid order by linkgroup.id limit imax) order by id loop			
			return next r;
			end loop;

		end if;	
	end if;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION view_linkgroup_paramvalue_retrieve(integer, integer, timestamp without time zone, integer, character varying) OWNER TO postgres;



update globeinfo set workspacedescription='This is a shared workspace on the enterprise server.' where workspacedescription is null or workspacedescription='';



/* --------------------------------   link group end   -----------------------------------*/

DROP TRIGGER object_customized_attribute_dt ON object_customized_attribute;
DROP FUNCTION process_object_customized_attribute_dt();

INSERT INTO object_customized_attribute(objectid, "name", alias, allow_export, "type", allow_modify_exported, lasttimestamp) VALUES (1, 'macaddress','MAC Address', true, 1, true, now());
INSERT INTO object_customized_attribute(objectid, "name", alias, allow_export, "type", allow_modify_exported, lasttimestamp) VALUES (1, 'group','Group', true, 1, true, now());
INSERT INTO object_customized_attribute(objectid, "name", alias, allow_export, "type", allow_modify_exported, lasttimestamp) VALUES (1, 'primarycontroller','Primary Controller', true, 1, true, now());
INSERT INTO object_customized_attribute(objectid, "name", alias, allow_export, "type", allow_modify_exported, lasttimestamp) VALUES (1, 'secondarycontroller','Secondary Controller', true, 1, true, now());
INSERT INTO object_customized_attribute(objectid, "name", alias, allow_export, "type", allow_modify_exported, lasttimestamp) VALUES (1, 'defaultgateway','Default Gateway', true, 1, true, now());

update object_customized_attribute set lasttimestamp=now();

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
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION process_object_customized_attribute_dt() OWNER TO postgres;


CREATE TRIGGER object_customized_attribute_dt
  BEFORE INSERT OR UPDATE OR DELETE
  ON object_customized_attribute
  FOR EACH ROW
  EXECUTE PROCEDURE process_object_customized_attribute_dt();


-----------------------  Bug 39911 ------------
DROP TRIGGER ipphone_dt ON ipphone;
DROP FUNCTION process_ipphone_dt();

CREATE OR REPLACE FUNCTION process_ipphone_dt()
  RETURNS trigger AS
$BODY$

    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.phone_name = NEW.phone_name AND
			OLD.ipaddr = NEW.ipaddr AND
			OLD.macaddr = NEW.macaddr AND
			OLD.phone_number = NEW.phone_number AND
			OLD.call_manager = NEW.call_manager AND
			OLD.switch_name = NEW.switch_name AND
			OLD.vendor = NEW.vendor AND
			OLD.model = NEW.model AND
			OLD.version = NEW.version AND
			OLD.software_version = NEW.software_version		
		 then
			return OLD;
		end IF;
		update objtimestamp set modifytime=now() where typename='IpPhone';
		NEW.lasttimestamp=NOW();
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='IpPhone';
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='IpPhone';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION process_ipphone_dt() OWNER TO postgres;

CREATE TRIGGER ipphone_dt
  BEFORE INSERT OR UPDATE OR DELETE
  ON ipphone
  FOR EACH ROW
  EXECUTE PROCEDURE process_ipphone_dt();

-----------------------------------------------

update virtualfunction set strname='IP SLA, Netflow, and IP Accounting' where sidname='IP SLA and IP Accounting';

DROP TRIGGER donotscan_dt ON donotscan;
DROP TRIGGER system_vendormodel_dt ON system_vendormodel;


CREATE OR REPLACE FUNCTION donotscan_upsert(oui donotscan)
  RETURNS integer AS
$BODY$
declare	
	t_id integer;
BEGIN	
	select id into t_id from donotscan where subnetmask=oui.subnetmask;
	if t_id IS NULL THEN
		insert into donotscan(
			groupid,
			subnetmask,
			scanfrom,
			snmpro			
			)
			values ( 
			oui.groupid,
			oui.subnetmask,
			oui.scanfrom,
			oui.snmpro
		);

		return lastval();
	ELSE
		update donotscan set ( 
			groupid,
			subnetmask,
			scanfrom,
			snmpro
			)
			=( 
			oui.groupid,
			oui.subnetmask,
			oui.scanfrom,
			oui.snmpro
			) 
			where id = t_id;
		return t_id;
	end if;
EXCEPTION
	WHEN OTHERS THEN 
		RETURN -2;
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION donotscan_upsert(donotscan) OWNER TO postgres;


CREATE OR REPLACE FUNCTION transport_protocol_port_upsert(oui transport_protocol_port)
  RETURNS integer AS
$BODY$
declare	
	t_id integer;
BEGIN	
	select id into t_id from transport_protocol_port where portnumber=oui.portnumber and protocol=oui.protocol;
	if t_id IS NULL THEN
		insert into transport_protocol_port(
			servername,
			portnumber,
			protocol,
			description,
			userflag
			)
			values ( 
			oui.servername,
			oui.portnumber,
			oui.protocol,
			oui.description,
			oui.userflag
		);

		return lastval();
	ELSE
		update transport_protocol_port set ( 
			servername,
			portnumber,
			protocol,
			description,
			userflag
			)
			=( 
			oui.servername,
			oui.portnumber,
			oui.protocol,
			oui.description,
			oui.userflag
			) 
			where id = t_id;
		return t_id;
	end if;
EXCEPTION
	WHEN OTHERS THEN 
		RETURN -2;
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION transport_protocol_port_upsert(transport_protocol_port) OWNER TO postgres;



CREATE OR REPLACE FUNCTION ouinfo_upsert(oui ouinfo)
  RETURNS integer AS
$BODY$
declare	
	oui_id integer;
BEGIN	
	select id into oui_id from ouinfo where mac_prefix=oui.mac_prefix;
	if oui_id IS NULL THEN
		insert into ouinfo(
			mac_prefix,
			vendor,
			flag
			)
			values ( 
			oui.mac_prefix,
			oui.vendor,
			oui.flag
		);

		return lastval();
	ELSE
		update ouinfo set ( 
			mac_prefix,
			vendor,
			flag
			)
			=( 
			oui.mac_prefix,
			oui.vendor,
			oui.flag
			) 
			where id = oui_id;
		return oui_id;
	end if;
EXCEPTION
	WHEN OTHERS THEN 
		RETURN -2;
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION ouinfo_upsert(ouinfo) OWNER TO postgres;


CREATE OR REPLACE FUNCTION system_vendormodel_upsert(oui system_vendormodel)
  RETURNS integer AS
$BODY$
declare	
	t_id integer;
BEGIN	
	select id into t_id from system_vendormodel where stroid=oui.stroid;
	if t_id IS NULL THEN
		insert into system_vendormodel(
			stroid,
			idevicetype,
			strvendorname,
			strmodelname,
			bmodified			
			)
			values ( 
			oui.stroid,
			oui.idevicetype,
			oui.strvendorname,
			oui.strmodelname,
			oui.bmodified
		);

		return lastval();
	ELSE
		update system_vendormodel set ( 
			stroid,
			idevicetype,
			strvendorname,
			strmodelname,
			bmodified
			)
			=( 
			oui.stroid,
			oui.idevicetype,
			oui.strvendorname,
			oui.strmodelname,
			oui.bmodified
			) 
			where id = t_id;
		return t_id;
	end if;
EXCEPTION
	WHEN OTHERS THEN 
		RETURN -2;
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION system_vendormodel_upsert(system_vendormodel) OWNER TO postgres;


DELETE FROM linkgroup WHERE strname='VRF ''boston'' network';
DELETE FROM devicegroup WHERE strname='All devices with ''public''  as community string';

DROP FUNCTION linkgroup_upsert(linkgroup);
CREATE OR REPLACE FUNCTION linkgroup_upsert(vm linkgroup)
  RETURNS integer AS
$BODY$
declare
	vm_id integer;
BEGIN
	select id into vm_id from linkgroup where strname=vm.strname;
	
	if vm_id IS NULL THEN
		insert into linkgroup(
			strname, strdesc, showcolor, showstyle, showwidth,userid,searchcondition,searchcontainer,dev_searchcondition,dev_searchcontainer,is_map_auto_link,istemplate)
			values( 
			vm.strname, vm.strdesc, vm.showcolor, vm.showstyle, vm.showwidth,vm.userid,vm.searchcondition,vm.searchcontainer,vm.dev_searchcondition,vm.dev_searchcontainer,vm.is_map_auto_link,vm.istemplate
			);
			return lastval();	
	end if;
EXCEPTION
	WHEN OTHERS THEN 
		RETURN -2;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION linkgroup_upsert(linkgroup) OWNER TO postgres;


select * from linkgroup_upsert((0,'Devices with specified SNMP RO','',9127187,0,6,-1,'<?xml version="1.0" encoding="UTF-8"?>
<filter>
<expression/>
</filter>',1,'<?xml version="1.0" encoding="UTF-8"?>
<filter>
<expression>A and B</expression>
<condition variable="A" type="0">
<operator>-1</operator>
<expression>2;2001;</expression>
</condition>
<condition variable="B" type="9">
<operator>4</operator>
<expression>snmp-server community #RO_String ro</expression>
</condition>
</filter>',1,True,True));

select * from linkgroup_upsert((0,'VRF Network','',16753920,0,6,-1,'<?xml version="1.0" encoding="UTF-8"?>
<filter>
<expression>A</expression>
<condition variable="A" type="104">
<operator>4</operator>
<expression>#VRF_Name</expression>
</condition>
</filter>',1,'<?xml version="1.0" encoding="UTF-8"?>
<filter>
<expression>A</expression>
<condition variable="A" type="9">
<operator>4</operator>
<expression>mpls ip;tag-switching</expression>
</condition>
</filter>',1,True,True));

select * from linkgroup_upsert((0,'Devices in specified BGP AS','',32896,0,6,-1,'<?xml version="1.0" encoding="UTF-8"?>
<filter>
<expression/>
</filter>',1,'<?xml version="1.0" encoding="UTF-8"?>
<filter>
<expression>A</expression>
<condition variable="A" type="9">
<operator>2</operator>
<expression>router bgp #AS_Number</expression>
</condition>
</filter>',1,True,True));

select * from linkgroup_upsert((0,'Multicasting PIM interfaces','',4734347,0,6,-1,'<?xml version="1.0" encoding="UTF-8"?>
<filter>
<expression>A</expression>
<condition variable="A" type="106">
<operator>4</operator>
<expression>ip pim #PIM_Mode</expression>
</condition>
</filter>',1,'<?xml version="1.0" encoding="UTF-8"?>
<filter>
<expression/>
</filter>',1,True,True));


INSERT INTO linkgroup_param( linkgroupid, strname, strdesc) VALUES ((select id from linkgroup where strname='Devices with specified SNMP RO'), 'RO_String', 'Specify your own value.');
INSERT INTO linkgroup_param( linkgroupid, strname, strdesc) VALUES ((select id from linkgroup where strname='Devices in specified BGP AS'), 'AS_Number', 'Specify your own value.');
INSERT INTO linkgroup_param( linkgroupid, strname, strdesc) VALUES ((select id from linkgroup where strname='Multicasting PIM interfaces'), 'PIM_Mode', 'Select PIM-SM, DM, SM-DM.');
INSERT INTO linkgroup_param( linkgroupid, strname, strdesc) VALUES ((select id from linkgroup where strname='VRF Network'), 'VRF_Name', 'Specify your own value.');

INSERT INTO linkgroup_paramvalue(paramid, strvalue, strdesc)VALUES ( (select id from linkgroup_param where strname ='RO_String'),'public', 'sample value');
INSERT INTO linkgroup_paramvalue(paramid, strvalue, strdesc)VALUES ( (select id from linkgroup_param where strname ='AS_Number'),'65535', 'sample value');
INSERT INTO linkgroup_paramvalue(paramid, strvalue, strdesc)VALUES ( (select id from linkgroup_param where strname ='PIM_Mode'),'dense-mode', 'PIM-DM');
INSERT INTO linkgroup_paramvalue(paramid, strvalue, strdesc)VALUES ( (select id from linkgroup_param where strname ='PIM_Mode'),'sparse-dense-mode', 'PIM-SM-DM');
INSERT INTO linkgroup_paramvalue(paramid, strvalue, strdesc)VALUES ( (select id from linkgroup_param where strname ='PIM_Mode'),'sparse-mode', 'PIM-DM');
INSERT INTO linkgroup_paramvalue(paramid, strvalue, strdesc)VALUES ( (select id from linkgroup_param where strname ='VRF_Name'),'Sales', 'sample value');


-- Function: module_property_update2(module_propertyview)

-- DROP FUNCTION module_property_update2(module_propertyview);

CREATE OR REPLACE FUNCTION module_property_update2(dp module_propertyview)
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
			dp.slot,
			dp.card_type,
			dp.ports,
			dp.serial_number,
			dp.hwrev,
			dp.rwrev,
			dp.swrev,
			dp.card_description,
			now(),
			dp.role,
			dp.macaddress,
			dp.swversion,
			dp.swimage,
			dp.stackport1conn,
			dp.stackport2conn,
			dp.isswitch
		);

		return lastval();
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
ALTER FUNCTION module_property_update2(module_propertyview) OWNER TO postgres;



UPDATE system_devicespec set strshowstpcmd='show spanning-tree blockedports' WHERE idevicetype=2004 and strmodelname='';
UPDATE system_devicespec set strshowstpcmd='show spanning-tree blockedports' WHERE idevicetype=2004 and strmodelname='N1KV';


CREATE OR REPLACE FUNCTION updata_device_type(devname character varying, devtype integer)
  RETURNS boolean AS
$BODY$

BEGIN
        update devices set isubtype=devtype where strname=devname;				
	return true;
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION updata_device_type(character varying, integer) OWNER TO postgres;


update discover_missdevice set modifytime=now() where modifytime is null;

DROP FUNCTION view_discover_missdeviceview(integer, integer, timestamp without time zone, character varying);

DROP VIEW discover_missdeviceview;

CREATE OR REPLACE VIEW discover_missdeviceview AS 
 SELECT discover_missdevice.id, discover_missdevice.mgrip, discover_missdevice.devtype, discover_missdevice.vendor, discover_missdevice.model, discover_missdevice.checktime, discover_missdevice.modifytime, discover_missdevice.deviceid,devices.strname as devicename from discover_missdevice,devices where discover_missdevice.deviceid=devices.id and discover_missdevice.modifytime is not null;

ALTER TABLE discover_missdeviceview OWNER TO postgres;

CREATE OR REPLACE FUNCTION view_discover_missdeviceview(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying)
  RETURNS SETOF discover_missdeviceview AS
$BODY$
declare
	r discover_missdeviceview%rowtype;
	t timestamp without time zone;
BEGIN
	select modifytime into t from objtimestamp where typename=stypename;
	
	if t is null or t>dt then
		if imax <0 then
			for r in SELECT * FROM discover_missdeviceview where id>ibegin order by id loop
			return next r;
			end loop;
		else
			for r in SELECT * FROM discover_missdeviceview where id>ibegin order by id limit imax loop
			return next r;
			end loop;

		end if;	
	end if;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION view_discover_missdeviceview(integer, integer, timestamp without time zone, character varying) OWNER TO postgres;

ALTER TABLE system_devicespec ALTER  strshowruncmd TYPE  character varying (256);

update system_info set ver=410;