\connect "nbws"

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

INSERT INTO objtimestamp(typename, modifytime, userid) VALUES ('FixUpNatInfo', '1900-01-01 00:00:00', -1);
INSERT INTO objtimestamp(typename, modifytime, userid) VALUES ('FixUpRouteTable', '1900-01-01 00:00:00', -1);
INSERT INTO objtimestamp(typename, modifytime, userid) VALUES ('FixUpRouteTablePriority', '1900-01-01 00:00:00', -1);



CREATE OR REPLACE FUNCTION view_fixupnatinfo_retrieve(dt timestamp without time zone, stypename character varying)
  RETURNS SETOF fixupnatinfo AS
$BODY$
declare
	r fixupnatinfo%rowtype;
	t timestamp without time zone;
BEGIN		
        select modifytime into t from objtimestamp where typename=stypename;
	if t is null or t>dt then
		for r in SELECT * FROM fixupnatinfo order by ipri loop
		return next r;
		end loop;	
	End IF;
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION view_fixupnatinfo_retrieve(timestamp without time zone, character varying) OWNER TO postgres;



CREATE OR REPLACE FUNCTION view_fixuproutetable_retrieve(dt timestamp without time zone, stypename character varying)
  RETURNS SETOF fixuproutetable AS
$BODY$
declare
	r fixuproutetable%rowtype;
	t timestamp without time zone;
BEGIN		
        select modifytime into t from objtimestamp where typename=stypename;
	if t is null or t>dt then
		for r in SELECT * FROM fixuproutetable order by id loop
		return next r;
		end loop;	
	End IF;
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION view_fixuproutetable_retrieve(timestamp without time zone, character varying) OWNER TO postgres;



CREATE OR REPLACE FUNCTION view_fixuproutetablepriority_retrieve(dt timestamp without time zone, stypename character varying)
  RETURNS SETOF fixuproutetablepriority AS
$BODY$
declare
	r fixuproutetablepriority%rowtype;
	t timestamp without time zone;
BEGIN		
        select modifytime into t from objtimestamp where typename=stypename;
	if t is null or t>dt then
		for r in SELECT * FROM fixuproutetablepriority order by id loop
		return next r;
		end loop;	
	End IF;
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION view_fixuproutetablepriority_retrieve(timestamp without time zone, character varying) OWNER TO postgres;




-- Sequence: l2switchport_temp_id_seq

-- DROP SEQUENCE l2switchport_temp_id_seq;

CREATE SEQUENCE l2switchport_temp_id_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER TABLE l2switchport_temp_id_seq OWNER TO postgres;


-- Table: l2switchport_temp

-- DROP TABLE l2switchport_temp;

CREATE TABLE l2switchport_temp
(
  id serial NOT NULL,
  switchname character varying(64) NOT NULL,
  portname character varying(64) NOT NULL,
  status character varying(32),
  speed character varying(64),
  duplex integer NOT NULL DEFAULT 2,
  portmode character varying DEFAULT 64,
  trunkencapsulation character varying(64),
  stpstatus character varying(64),
  vlans character varying(254),
  description character varying(254),
  nb_timestamp timestamp without time zone NOT NULL DEFAULT now(),
  usermodifed integer NOT NULL DEFAULT 0, -- 0: org  1: discovery  2: manual
  channelgroupmode integer NOT NULL DEFAULT 0,
  channelgroupname character varying(128) NOT NULL DEFAULT 0,
  exclude_vlans character varying(254),
  CONSTRAINT l2switchport_temp_pk PRIMARY KEY (id),
  CONSTRAINT l2switchport_temp_un UNIQUE (switchname, portname)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE l2switchport_temp OWNER TO postgres;
COMMENT ON COLUMN l2switchport_temp.usermodifed IS '0: org  1: discovery  2: manual';


-- Index: l2switchport_temp_idx_dev

-- DROP INDEX l2switchport_temp_idx_dev;

CREATE INDEX l2switchport_temp_idx_dev
  ON l2switchport_temp
  USING btree
  (switchname);

-- Index: l2switchport_temp_idx_dev_portname

-- DROP INDEX l2switchport_temp_idx_dev_portname;

CREATE UNIQUE INDEX l2switchport_temp_idx_dev_portname
  ON l2switchport_temp
  USING btree
  (switchname, portname);


-- Function: view_l2switchport_temp_retrieve(integer, integer, timestamp without time zone, character varying)
 
-- DROP FUNCTION view_l2switchport_temp_retrieve(integer, integer, timestamp without time zone, character varying);
 
CREATE OR REPLACE FUNCTION view_l2switchport_temp_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying)
  RETURNS SETOF l2switchport_temp AS
$BODY$
declare
 r l2switchport_temp%rowtype;
BEGIN 
  if imax <0 then
   for r in select * from l2switchport_temp where switchname in (SELECT devicename FROM l2switchinfo where id>ibegin and nb_timestamp>dt order by id)  loop
   return next r;
   end loop;
  else
   for r in select * from l2switchport_temp where switchname in (SELECT devicename FROM l2switchinfo where id>ibegin and nb_timestamp>dt order by id limit imax)  loop
   return next r;
   end loop;
 
  end if;  
END;
 
  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION view_l2switchport_temp_retrieve(integer, integer, timestamp without time zone, character varying) OWNER TO postgres;


CREATE OR REPLACE FUNCTION view_nattointf_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying)
  RETURNS SETOF nattointf AS
$BODY$
declare
	r nattointf%rowtype;
	t timestamp without time zone;
BEGIN		
	select modifytime into t from objtimestamp where typename=stypename;
	if t is null or t>dt then
		if imax <0 then
			for r in SELECT * FROM nattointf where id>ibegin order by id  loop
			return next r;
			end loop;
		else
			for r in SELECT * FROM nattointf where id>ibegin order by id limit imax loop
			return next r;
			end loop;

		end if;	
	End IF;		
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION view_nattointf_retrieve(integer, integer, timestamp without time zone, character varying) OWNER TO postgres;

INSERT INTO objtimestamp(typename, modifytime, userid) VALUES ('DeviceProtocols', '1900-01-01 00:00:00', -1);
INSERT INTO objtimestamp(typename, modifytime, userid) VALUES ('Nat', '1900-01-01 00:00:00', -1);

CREATE OR REPLACE FUNCTION process_fixupnatinfo_dt()
  RETURNS trigger AS
$BODY$
		
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.deviceid = NEW.deviceid AND 			
			OLD.ininfid = NEW.ininfid AND 			
			OLD.outinfid = NEW.outinfid AND 						
			OLD.insidelocal = NEW.insidelocal AND
			OLD.insideglobal = NEW.insideglobal AND
			OLD.outsidelocal=NEW.outsidelocal AND
			OLD.outsideglobal=NEW.outsideglobal AND
			OLD.ipri=NEW.ipri 
		 then
			return OLD;
		end IF;
		update objtimestamp set modifytime=now() where typename='FixUpNatInfo';
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='FixUpNatInfo';
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='FixUpNatInfo';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION process_fixupnatinfo_dt() OWNER TO postgres;

CREATE TRIGGER fixupnatinfo_dt
  BEFORE INSERT OR UPDATE OR DELETE
  ON fixupnatinfo
  FOR EACH ROW
  EXECUTE PROCEDURE process_fixupnatinfo_dt();


CREATE OR REPLACE FUNCTION process_fixuproutetable_dt()
  RETURNS trigger AS
$BODY$
		
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.deviceid = NEW.deviceid AND 			
			OLD.destip = NEW.destip AND 			
			OLD.destmask = NEW.destmask AND 						
			OLD.infname = NEW.infname AND
			OLD.nexthopip = NEW.nexthopip 
		 then
			return OLD;
		end IF;
		update objtimestamp set modifytime=now() where typename='FixUpRouteTable';
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='FixUpRouteTable';
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='FixUpRouteTable';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION process_fixuproutetable_dt() OWNER TO postgres;


CREATE TRIGGER fixuproutetable_dt
  BEFORE INSERT OR UPDATE OR DELETE
  ON fixuproutetable
  FOR EACH ROW
  EXECUTE PROCEDURE process_fixuproutetable_dt();


 CREATE OR REPLACE FUNCTION process_fixuproutetablepriority_dt()
  RETURNS trigger AS
$BODY$
		
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.deviceid = NEW.deviceid AND 			
			OLD.priority = NEW.priority 
		 then
			return OLD;
		end IF;
		update objtimestamp set modifytime=now() where typename='FixUpRouteTablePriority';
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='FixUpRouteTablePriority';
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='FixUpRouteTablePriority';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION process_fixuproutetablepriority_dt() OWNER TO postgres;


CREATE TRIGGER fixuproutetablepriority_dt
  BEFORE INSERT OR UPDATE OR DELETE
  ON fixuproutetablepriority
  FOR EACH ROW
  EXECUTE PROCEDURE process_fixuproutetablepriority_dt();


CREATE OR REPLACE VIEW deviceprotocolsview AS 
 SELECT deviceprotocols.id, deviceprotocols.deviceid, deviceprotocols.protocalname, deviceprotocols.lastmodifytime, devices.strname AS devicename, devices.isubtype
   FROM deviceprotocols, devices
  WHERE deviceprotocols.deviceid = devices.id
  ORDER BY devices.strname;

ALTER TABLE deviceprotocolsview OWNER TO postgres;


CREATE OR REPLACE FUNCTION view_deviceprotocolsview_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying)
  RETURNS SETOF deviceprotocolsview AS
$BODY$
declare
	r deviceprotocolsview%rowtype;
	t timestamp without time zone;
BEGIN
	select modifytime into t from objtimestamp where typename=stypename;
	
	if t is null or t>dt then
		if imax <0 then
			for r in SELECT * FROM deviceprotocolsview where id>ibegin order by id  loop
			return next r;
			end loop;
		else
			for r in SELECT * FROM deviceprotocolsview where id>ibegin order by id limit imax loop
			return next r;
			end loop;

		end if;	
	end if;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION view_deviceprotocolsview_retrieve(integer, integer, timestamp without time zone, character varying) OWNER TO postgres;


ALTER TABLE userdevicesetting
add column jumpboxid integer DEFAULT 0;

ALTER TABLE nomp_jumpbox
add column userid integer NOT NULL DEFAULT 1;

ALTER TABLE nomp_jumpbox
add CONSTRAINT nomp_jumpbox_fk_userid FOREIGN KEY (userid)
      REFERENCES "user" (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE DEFERRABLE INITIALLY IMMEDIATE;



DROP FUNCTION view_nomp_jumpbox_retrieve(timestamp without time zone, character varying);

DROP VIEW nomp_jumpboxview;

CREATE OR REPLACE VIEW nomp_jumpboxview AS 
 SELECT nomp_jumpbox.*, ( SELECT count(*) AS count FROM devicesetting WHERE devicesetting.telnetproxyid = nomp_jumpbox.id) AS irefcount
   FROM nomp_jumpbox
  ORDER BY nomp_jumpbox.ipri;

ALTER TABLE nomp_jumpboxview OWNER TO postgres;

CREATE OR REPLACE FUNCTION view_nomp_jumpbox_retrieve(dt timestamp without time zone, stypename character varying)
  RETURNS SETOF nomp_jumpboxview AS
$BODY$
declare
	r nomp_jumpboxview%rowtype;
	t timestamp without time zone;
BEGIN		
        select modifytime into t from objtimestamp where typename=stypename;
	if t is null or t>dt then
		for r in SELECT * FROM nomp_jumpboxview loop
		return next r;
		end loop;	
	End IF;
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION view_nomp_jumpbox_retrieve(timestamp without time zone, character varying) OWNER TO postgres;


DROP FUNCTION view_userdevicesetting_retrieve(integer, integer, timestamp without time zone, integer);

DROP VIEW userdevicesettingview;

CREATE OR REPLACE VIEW userdevicesettingview AS 
 SELECT userdevicesetting.*, devices.strname AS devicename FROM userdevicesetting, devices WHERE devices.id = userdevicesetting.deviceid;

ALTER TABLE userdevicesettingview OWNER TO postgres;

CREATE OR REPLACE FUNCTION view_userdevicesetting_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer)
  RETURNS SETOF userdevicesettingview AS
$BODY$
declare
	r userdevicesettingview%rowtype;
BEGIN
	if imax <0 then
		for r in SELECT * FROM userdevicesettingview where id>ibegin and userid=uid AND dtstamp>dt order by id loop
		return next r;
		end loop;
	else
		for r in SELECT * FROM userdevicesettingview where id>ibegin and userid=uid AND dtstamp>dt order by id limit imax loop
		return next r;
		end loop;

	end if;
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION view_userdevicesetting_retrieve(integer, integer, timestamp without time zone, integer) OWNER TO postgres;


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



DROP TRIGGER userdevicesetting_dt ON userdevicesetting;

DROP FUNCTION process_userdevicesetting_dt();

CREATE OR REPLACE FUNCTION process_userdevicesetting_dt()
  RETURNS trigger AS
$BODY$
declare tid integer;
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
  select id into tid from objtimestamp where typename='PrivateDeviceSetting' and userid=old.userid;
  if tid is null then
   insert into objtimestamp (typename,userid,modifytime) values('PrivateDeviceSetting',old.userid,now());
  else
   update objtimestamp set modifytime=now() where typename='PrivateDeviceSetting' and userid=old.userid;
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


DROP FUNCTION view_nomp_jumpbox_retrieve(dt timestamp without time zone, stypename character varying);

CREATE OR REPLACE FUNCTION view_nomp_jumpbox_retrieve(dt timestamp without time zone, stypename character varying, ids integer[])
  RETURNS SETOF nomp_jumpboxview AS
$BODY$
declare
	r nomp_jumpboxview%rowtype;
	t timestamp without time zone;
BEGIN		
        select modifytime into t from objtimestamp where typename=stypename;
	if t is null or t>dt then
		for r in SELECT * FROM nomp_jumpboxview where userid = any(ids) loop
		return next r;
		end loop;	
	End IF;
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION view_nomp_jumpbox_retrieve(timestamp without time zone, character varying, integer[]) OWNER TO postgres;


ALTER TABLE "user" ADD COLUMN offline_minutes integer;
ALTER TABLE "user" ALTER COLUMN offline_minutes SET STORAGE PLAIN;
ALTER TABLE "user" ALTER COLUMN offline_minutes SET DEFAULT 120;

update "user" set offline_minutes=120 where offline_minutes is null;
update "user" set wsver=1 where strname='admin';
UPDATE "user" SET  wsver=0 WHERE strname='admin';

ALTER TABLE "function" add column isdisplay boolean DEFAULT true;
ALTER TABLE "function" ADD COLUMN kval text;
ALTER TABLE "function" ALTER COLUMN kval SET STORAGE EXTENDED;

INSERT INTO "function"(strname, wsver, description, sidname)
    VALUES ('Simulation for Local Workspace', 1, '', 'Local_Simulation');

INSERT INTO "function"(strname, wsver, description, sidname)
    VALUES ('Network Documentation for Local Workspace', 1, '', 'Local_Documentation');

INSERT INTO "function"(strname, wsver, description, sidname)
    VALUES ('Live Network Discovery for Local Workspace', 1, '', 'Local_Live_Network_Discovery');

update "function" set kval='385A3A6B6D726E6D74766D4E7A5F7A78767A766F676B2D54' where sidname='Appliance_Management';
update "function" set kval='384F3A5F6D6C6E6C746C6D624E5F7A747A6F766B764767372D52' where sidname='L2_Topology_Management';
update "function" set kval='384F3A65695F6576786472695F70576C68676C4D767662722D52' where sidname='Live_Network_Discovery';
update "function" set kval='38593A6D69736E7A7870762D3C' where sidname='Benchmark';
update "function" set kval='38583A6E6D6C6E5F74766D724E767448726767766D5F5F787A657A57766D766E676C2D48' where sidname='Common_Device_Setting_Management';
update "function" set kval='38583A6D6D726E66747A6D724E6D7655726F5F5F6C7A677A6976747675676C2D4B' where sidname='Configuration_File_Management';
update "function" set kval='38473A6B6D6F6E74745F6D674E677473726D785F727A487A62766C766C676C2D4B' where sidname='Topology_Stitching_Management';
update "function" set kval='38473A7A6D756E7874486D724E7874726D735F677A677A5F7672767567692D4C' where sidname='Traffic_Stitching_Management';
update "function" set kval='38573A656D786E5F74696D664E5F6B7A6C7A547676767267762D51' where sidname='Device_Group_Management';
update "function" set kval='384F6D78726F7A48666E726F5F677A6C6C3A59' where sidname='Local_Simulation';
update "function" set kval='384F6D78726F7A576D786E66766C675F677A6C6C3A56' where sidname='Local_Documentation';
update "function" set kval='384F6278766F6C4F6865575F70766C6467694D5F767272785F657A696C3A4D' where sidname='Local_Live_Network_Discovery';

ALTER TABLE "function" ALTER COLUMN kval SET NOT NULL;


INSERT INTO "function"(strname, wsver, description, sidname, kval, isdisplay )
    VALUES ( 'Advance Troubleshooting for Local Workspace', 1, '', 'Local_Advance_Troubleshooting','384F7478726F6C5A7365766D79766C47695F66786F7A68776C5F677A6D6C3A4C', TRUE);

INSERT INTO "function"(strname, wsver, description, sidname, kval, isdisplay )
    VALUES ( 'Advance Troubleshooting', 0, '', 'Advance_Troubleshooting','395A7465726D6C767347766C79666F69685F6C78677A6D773A52', TRUE);
    
INSERT INTO "function"(strname, wsver, description, sidname, kval, isdisplay )
    VALUES ( 'Network Documentation',0, '', 'Documentation','39576D78726E7A6D677667666C6C3A3F', TRUE);
    
update "function" set isdisplay=false where sidname='Local_Simulation';
update "function" set isdisplay=false where sidname='Local_Documentation';
update "function" set isdisplay=false where sidname='Local_Live_Network_Discovery';    
update "function" set isdisplay=false where sidname='Local_Advance_Troubleshooting';    
    

ALTER TABLE "role" ADD COLUMN isdisplay boolean DEFAULT true;

INSERT INTO "role"("name") VALUES ( 'Architect Role');
update "role" set isdisplay=false where "name"='Architect Role';


INSERT INTO role2function( roleid, functionid) VALUES (( select id from "role" where name='Admin'), (select id from function where sidname='Local_Simulation') );
INSERT INTO role2function( roleid, functionid) VALUES (( select id from "role" where name='Admin'), (select id from function where sidname='Local_Documentation') );
INSERT INTO role2function( roleid, functionid) VALUES (( select id from "role" where name='Admin'), (select id from function where sidname='Local_Live_Network_Discovery') );

INSERT INTO role2function( roleid, functionid) VALUES (( select id from "role" where name='Admin'), (select id from function where sidname='Local_Advance_Troubleshooting') );
INSERT INTO role2function( roleid, functionid) VALUES (( select id from "role" where name='Admin'), (select id from function where sidname='Advance_Troubleshooting') );
INSERT INTO role2function( roleid, functionid) VALUES (( select id from "role" where name='Admin'), (select id from function where sidname='Documentation') );

INSERT INTO role2function( roleid, functionid) VALUES (( select id from "role" where name='Architect Role'), (select id from function where sidname='L2_Topology_Management') );
INSERT INTO role2function( roleid, functionid) VALUES (( select id from "role" where name='Architect Role'), (select id from function where sidname='Live_Network_Discovery') );
INSERT INTO role2function( roleid, functionid) VALUES (( select id from "role" where name='Architect Role'), (select id from function where sidname='Benchmark') );
INSERT INTO role2function( roleid, functionid) VALUES (( select id from "role" where name='Architect Role'), (select id from function where sidname='Common_Device_Setting_Management') );
INSERT INTO role2function( roleid, functionid) VALUES (( select id from "role" where name='Architect Role'), (select id from function where sidname='Configuration_File_Management') );
INSERT INTO role2function( roleid, functionid) VALUES (( select id from "role" where name='Architect Role'), (select id from function where sidname='Topology_Stitching_Management') );
INSERT INTO role2function( roleid, functionid) VALUES (( select id from "role" where name='Architect Role'), (select id from function where sidname='Traffic_Stitching_Management') );
INSERT INTO role2function( roleid, functionid) VALUES (( select id from "role" where name='Architect Role'), (select id from function where sidname='Device_Group_Management') );
INSERT INTO role2function( roleid, functionid) VALUES (( select id from "role" where name='Architect Role'), (select id from function where sidname='Local_Simulation') );
INSERT INTO role2function( roleid, functionid) VALUES (( select id from "role" where name='Architect Role'), (select id from function where sidname='Local_Documentation') );
INSERT INTO role2function( roleid, functionid) VALUES (( select id from "role" where name='Architect Role'), (select id from function where sidname='Local_Live_Network_Discovery') );
INSERT INTO role2function( roleid, functionid) VALUES (( select id from "role" where name='Architect Role'), (select id from function where sidname='Local_Advance_Troubleshooting') );


CREATE OR REPLACE FUNCTION devicebygrouplist(grouplist integer[])
  RETURNS SETOF devices AS
$BODY$

DECLARE
    r devices%rowtype;
BEGIN		
		     FOR r IN select devices.* from devices,devicegroupdevice where devices.id=devicegroupdevice.deviceid and devicegroupdevice.devicegroupid = any(grouplist) LOOP
			RETURN NEXT r;
		     END LOOP;	     		    
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION devicebygrouplist( integer[]) OWNER TO postgres;

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



CREATE OR REPLACE FUNCTION process_fixupnatinfo()
  RETURNS trigger AS
$BODY$
    BEGIN
        IF (TG_OP = 'UPDATE') THEN		
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN                
		NEW.ipri=nextval('fixupnatinfo_ipri_seq'::regclass);						                				
		RETURN NEW;        
        END IF;
        RETURN NULL;
    END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION process_fixupnatinfo() OWNER TO postgres;

CREATE TRIGGER fixupnatinfo_pri
  BEFORE INSERT OR UPDATE
  ON fixupnatinfo
  FOR EACH ROW
  EXECUTE PROCEDURE process_fixupnatinfo();

ALTER TABLE fixupnatinfo ALTER COLUMN ipri SET DEFAULT null;  


DROP FUNCTION user_device_setting_upsert(character varying, integer, userdevicesetting);

CREATE OR REPLACE FUNCTION user_device_setting_upsert(devname character varying, u_id integer, ds userdevicesetting)
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
		insert into userdevicesetting(
			  deviceid,
			  userid,
			  managerip,
			  telnetusername,
			  telnetpwd,
			  dtstamp,
			  jumpboxid
			)
			values ( 
			r_id,
			u_id,
			ds.managerip,
			ds.telnetusername,
			ds.telnetpwd,
			now(),
			ds.jumpboxid
		);

		return lastval();
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
ALTER FUNCTION user_device_setting_upsert(character varying, integer, userdevicesetting) OWNER TO postgres;

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
			jumpboxid
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

CREATE TABLE globeinfo
(
  id serial NOT NULL,
  workspacename character varying(200) NOT NULL,
  CONSTRAINT globeinfo_pk PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE globeinfo OWNER TO postgres;
insert into globeinfo(id,workspacename)values(0,'Enterprise Network');


DROP TRIGGER system_vendormodel_dt ON system_vendormodel;

DROP FUNCTION process_system_vendormodel_dt();

CREATE OR REPLACE FUNCTION process_system_vendormodel_dt()
  RETURNS trigger AS
$BODY$

    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.idevicetype = NEW.idevicetype AND 
			OLD.strvendorname = NEW.strvendorname AND
			OLD.bmodified = NEW.bmodified AND
			OLD.stroid = NEW.stroid AND
			OLD.strmodelname = NEW.strmodelname
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
ALTER FUNCTION process_system_vendormodel_dt() OWNER TO postgres;

CREATE TRIGGER system_vendormodel_dt
  BEFORE INSERT OR UPDATE OR DELETE
  ON system_vendormodel
  FOR EACH ROW
  EXECUTE PROCEDURE process_system_vendormodel_dt();

ALTER TABLE system_vendormodel ALTER COLUMN stroid type character varying(256);
ALTER TABLE system_devicespec ALTER COLUMN strcpuoid type character varying(512);
ALTER TABLE system_devicespec ALTER COLUMN strmemoid type character varying(512);

update system_vendormodel set stroid='1.3.6.1.4.1.'||stroid where substring(stroid from 1 for 12) <> '1.3.6.1.4.1.';

delete from system_vendormodel where substring(stroid from 1 for 12) <> '1.3.6.1.4.1.';

delete from system_vendormodel where  stroid ='1.3.6.1.4.1.netbsd1';

UPDATE system_devicespec set strcpuoid='$1.3.6.1.4.1.9.2.1.56.0', strmemoid='$1.3.6.1.4.1.9.9.48.1.1.1.5.1*100.0/($1.3.6.1.4.1.9.9.48.1.1.1.6.1+$1.3.6.1.4.1.9.9.48.1.1.1.5.1)' where strvendorname='cisco' and strmodelname='' and idevicetype=2;
UPDATE system_devicespec set strcpuoid='$1.3.6.1.4.1.9.9.109.1.1.1.1.3.1', strmemoid='$1.3.6.1.4.1.9.9.48.1.1.1.5.1*100.0/($1.3.6.1.4.1.9.9.48.1.1.1.6.1+$1.3.6.1.4.1.9.9.48.1.1.1.5.1)' where strvendorname='cisco' and strmodelname='' and idevicetype=2002;
UPDATE system_devicespec set strcpuoid='$1.3.6.1.4.1.9.9.109.1.1.1.1.5.9', strmemoid='$1.3.6.1.4.1.9.9.48.1.1.1.5.1*100.0/($1.3.6.1.4.1.9.9.48.1.1.1.6.1+$1.3.6.1.4.1.9.9.48.1.1.1.5.1)' where strvendorname='cisco' and strmodelname='' and idevicetype=2060;
UPDATE system_devicespec set strcpuoid='$1.3.6.1.4.1.9.2.1.56.0', strmemoid='$1.3.6.1.4.1.9.9.48.1.1.1.5.1*100.0/($1.3.6.1.4.1.9.9.48.1.1.1.6.1+$1.3.6.1.4.1.9.9.48.1.1.1.5.1)' where strvendorname='cisco' and strmodelname='' and idevicetype=2001;
UPDATE system_devicespec set strcpuoid='$1.3.6.1.4.1.9.9.109.1.1.1.1.3.1', strmemoid='$1.3.6.1.4.1.9.9.48.1.1.1.5.1*100.0/($1.3.6.1.4.1.9.9.48.1.1.1.6.1+$1.3.6.1.4.1.9.9.48.1.1.1.5.1)' where strvendorname='cisco' and strmodelname='' and idevicetype=2009;
UPDATE system_devicespec set strcpuoid='$1.3.6.1.4.1.9.9.109.1.1.1.1.3.1', strmemoid='$1.3.6.1.4.1.9.9.48.1.1.1.5.1*100.0/($1.3.6.1.4.1.9.9.48.1.1.1.6.1+$1.3.6.1.4.1.9.9.48.1.1.1.5.1)' where strvendorname='cisco' and strmodelname='' and idevicetype=1025;
UPDATE system_devicespec set strcpuoid='$1.3.6.1.4.1.3224.16.1.4.0', strmemoid='$1.3.6.1.4.1.3224.16.2.1.0*100.0/($1.3.6.1.4.1.3224.16.1.1.0+$1.3.6.1.4.1.3224.16.2.2.0)' where strvendorname='netscreen' and strmodelname='' and idevicetype=2008;
UPDATE system_devicespec set strcpuoid='$1.3.6.1.4.1.3375.1.1.83.0', strmemoid='$1.3.6.1.4.1.3375.1.1.77.0*100.0/$1.3.6.1.4.1.3375.1.1.78.0' where strvendorname='F5' and strmodelname='' and idevicetype=2003;
UPDATE system_devicespec set strcpuoid='$1.3.6.1.4.1.43.45.1.6.1.1.1.2', strmemoid='$1.3.6.1.4.1.43.45.1.6.1.2.1.1.4*100.0/$1.3.6.1.4.1.43.45.1.6.1.2.1.1.2' where strvendorname='3Com' and strmodelname='' and idevicetype=3333;
UPDATE system_devicespec set strcpuoid='$1.3.6.1.4.1.2011.2.23.1.18.1.3.0', strmemoid='($1.3.6.1.4.1.2011.6.1.2.1.1.2.65536-$1.3.6.1.4.1.2011.6.1.2.1.1.3.65536)*100.0/$1.3.6.1.4.1.2011.6.1.2.1.1.2.65536' where strvendorname='3Com' and strmodelname='s5100' and idevicetype=3333;


ALTER TABLE system_devicespec ALTER COLUMN strshowroutecountcmd type character varying(512);
ALTER TABLE system_devicespec ALTER COLUMN strshowcdpcmd type character varying(512);

update system_devicespec set strshowroutecountcmd='show route summary' where  idevicetype=102;
update system_devicespec set strshowroutecountcmd='display ip routing-table statistics' where idevicetype=3333;
update system_devicespec set strshowcdpcmd='display lldp neighbor-information' where idevicetype=3333;
update system_devicespec set strshowcdpcmd='', strshowarpcmd='show arp', strshowcamcmd='' where idevicetype=2002;
update system_devicespec set strshowroutecountcmd='', strshowarpcmd='' where idevicetype=2060;
update system_devicespec set strshowcamcmd='' where idevicetype=1025;
update system_devicespec set strshowarpcmd='show arp' where idevicetype=2009;






-- Function: searchalldevicenofiler(character varying, integer)

-- DROP FUNCTION searchalldevicenofiler(character varying, integer);

CREATE OR REPLACE FUNCTION searchalldevicenofiler(devname character varying, preid integer)
  RETURNS SETOF devicesettingview AS
$BODY$

DECLARE
    r devicesettingview%rowtype;
    npreid integer;
BEGIN	
     npreid:=0;
     FOR r IN select * from devicesettingview  where lower(devicename) like '%'||devname||'%' order by lower(devicename) LOOP
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
ALTER FUNCTION searchalldevicenofiler(character varying, integer) OWNER TO postgres;

-- Function: searchdevicebygroupnofiler(character varying, integer, integer)

-- DROP FUNCTION searchdevicebygroupnofiler(character varying, integer, integer);

CREATE OR REPLACE FUNCTION searchdevicebygroupnofiler(devname character varying, gid integer, preid integer)
  RETURNS SETOF devicesettingview AS
$BODY$

DECLARE
    r devicesettingview%rowtype;
    npreid integer;
BEGIN
     npreid:=0;	
     FOR r IN select * from devicesettingview where deviceid in (select deviceid from devicegroupdeviceview where devicegroupid=gid and lower(devicename) like '%'||devname||'%') order by devicename   LOOP
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
ALTER FUNCTION searchdevicebygroupnofiler(character varying, integer, integer) OWNER TO postgres;

CREATE OR REPLACE FUNCTION devicelistbygroupnofilerbytype(pageindexsize integer, pagesize integer, types integer)
  RETURNS SETOF devicesettingview AS
$BODY$

DECLARE
    r devicesettingview%rowtype;
BEGIN			     		     
		     FOR r IN select * from devicesettingview where subtype = types and  id not in ( select id from devicesettingview where subtype = types order by lower(devicename) limit pageindexsize ) order by lower(devicename) limit pagesize LOOP
			RETURN NEXT r;
		     END LOOP;		     				     
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION devicelistbygroupnofilerbytype(integer, integer, integer) OWNER TO postgres;



CREATE OR REPLACE FUNCTION searchalldevicenofiler(devname character varying, preid integer,types integer[])
  RETURNS SETOF devicesettingview AS
$BODY$

DECLARE
    r devicesettingview%rowtype;
    npreid integer;
BEGIN	
     npreid:=0;
     FOR r IN select * from devicesettingview  where lower(devicename) like '%'||devname||'%' and subtype = any( types ) order by lower(devicename) LOOP
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
ALTER FUNCTION searchalldevicenofiler(character varying, integer,integer[]) OWNER TO postgres;


CREATE OR REPLACE FUNCTION searchdevicebygroupnofiler(devname character varying, gid integer, preid integer,types integer[])
  RETURNS SETOF devicesettingview AS
$BODY$

DECLARE
    r devicesettingview%rowtype;
    npreid integer;
BEGIN
     npreid:=0;	
     FOR r IN select * from devicesettingview where subtype = any( types ) and  deviceid in (select deviceid from devicegroupdeviceview where devicegroupid=gid and subtype = any( types ) and lower(devicename) like '%'||devname||'%' order by devicename )  LOOP
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
ALTER FUNCTION searchdevicebygroupnofiler(character varying, integer, integer,integer[]) OWNER TO postgres;


INSERT INTO objtimestamp(typename, modifytime, userid) VALUES ('BGpNeighbor', '1900-01-01 00:00:00', -1);

CREATE OR REPLACE VIEW bgpneighborview AS 
 SELECT bgpneighbor.id, bgpneighbor.deviceid, devices.strname AS devicename, bgpneighbor.remoteasnum, bgpneighbor.neighborip, bgpneighbor.localasnum
   FROM bgpneighbor, devices
  WHERE devices.id = bgpneighbor.deviceid AND bgpneighbor.neighborip IS NOT NULL AND bgpneighbor.localasnum IS NOT NULL
  ORDER BY bgpneighbor.id;

ALTER TABLE bgpneighborview OWNER TO postgres;

CREATE OR REPLACE FUNCTION view_bgpneighbor_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying)
  RETURNS SETOF bgpneighborview AS
$BODY$
declare
	r bgpneighborview%rowtype;
	t timestamp without time zone;
BEGIN
	select modifytime into t from objtimestamp where typename=stypename;
	
	if t is null or t>dt then
		if imax <0 then
			for r in SELECT * FROM bgpneighborview where id>ibegin order by id  loop
			return next r;
			end loop;
		else
			for r in SELECT * FROM bgpneighborview where id>ibegin order by id limit imax loop
			return next r;
			end loop;

		end if;	
	end if;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION view_bgpneighbor_retrieve(integer, integer, timestamp without time zone, character varying) OWNER TO postgres;


update  system_devicespec set strshowarpcmd='display arp all|display arp' where strvendorname='3Com' and strmodelname='';

alter TABLE nomp_jumpbox DROP CONSTRAINT nomp_jumpbox_pk ;

alter TABLE nomp_jumpbox add CONSTRAINT nomp_jumpbox_pk PRIMARY KEY (strname,userid);


delete from system_vendormodel where stroid='1.3.6.1.4.1.4.1.9.1.1016';
delete from system_vendormodel where stroid='1.3.6.1.4.1.4.1.9.1.664';
delete from system_vendormodel where stroid='1.3.6.1.4.1.4.1.9.1.666';
delete from system_vendormodel where stroid='1.3.6.1.4.1.4.1.9.1.822';
delete from system_vendormodel where stroid='1.3.6.1.4.1.9..1.643';

update system_info set itelnetsshtimeout=60 where itelnetsshtimeout <= 30;
update system_info set isnmptimeout=10 where isnmptimeout <= 5;


-- Function: devicegroupdevice_upsert2(integer, integer[])

-- DROP FUNCTION devicegroupdevice_upsert2(integer, integer[]);

CREATE OR REPLACE FUNCTION devicegroupdevice_upsert2(gid integer, ds integer[])
  RETURNS boolean AS
$BODY$

BEGIN
	for r in  1..array_length(ds,1) loop
	       insert into devicegroupdevice (devicegroupid,deviceid) values (gid,ds[r]);              
	end loop;	
	return true;
EXCEPTION    
	WHEN OTHERS THEN   
		return false;		
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION devicegroupdevice_upsert2(integer, integer[]) OWNER TO postgres;


-- Function: devicegroupdevice_delete(integer)

-- DROP FUNCTION devicegroupdevice_delete(integer);

CREATE OR REPLACE FUNCTION devicegroupdevice_delete(gid integer)
  RETURNS boolean AS
$BODY$

BEGIN
	delete from  devicegroupdevice where devicegroupid=gid;	
	return true;
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION devicegroupdevice_delete(integer) OWNER TO postgres;

