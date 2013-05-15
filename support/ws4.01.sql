\connect "nbws"

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;


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
			  where id = ds_id and ( usermodifiedflag != ins.usermodifiedflag or livestatus != ins.livestatus or mibindex != ins.mibindex or bandwidth != ins.bandwidth or macaddress != ins.macaddress or interface_ip != ins.interface_ip or module_slot != ins.module_slot or module_type != ins.module_type or interface_status != ins.interface_status or speed_int != ins.speed_int or duplex != ins.duplex or description != ins.description or mpls_vrf != ins.mpls_vrf or vlan != ins.vlan or voice_vlan != ins.voice_vlan or mask != ins.mask or routing_protocol != ins.routing_protocol or portmode != ins.portmode or multicast_mode != ins.multicast_mode or counter != ins.counter or isphysical !=ins.isphysical or interfacefullname != ins.interfacefullname or ordernumber != ins.ordernumber );
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
			  where id = ds_id and ( usermodifiedflag != ins.usermodifiedflag or livestatus != ins.livestatus or mibindex != ins.mibindex or bandwidth != ins.bandwidth or macaddress != ins.macaddress or interface_ip != ins.interface_ip or module_slot != ins.module_slot or module_type != ins.module_type or interface_status != ins.interface_status or speed_int != ins.speed_int or duplex != ins.duplex or description != ins.description or mpls_vrf != ins.mpls_vrf or vlan != ins.vlan or voice_vlan != ins.voice_vlan or mask != ins.mask or routing_protocol != ins.routing_protocol or portmode != ins.portmode or multicast_mode != ins.multicast_mode or counter != ins.counter or isphysical !=ins.isphysical or interfacefullname != ins.interfacefullname or ordernumber != ins.ordernumber );
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
   
    
INSERT INTO "function"(strname, wsver, description, sidname, kval, isdisplay ) VALUES ( 'Access to Live Network', 0, '', 'Live_Access','394F6865765F785A787668723A3D', FALSE);
insert into virtualfunction (strname,sidname) values ('Access to Live Network','Live_Access');
INSERT INTO virtualfunction2function( virtualfunctionid, functionid) VALUES (( select id from virtualfunction where sidname='Live_Access'), (select id from "function" where sidname='Live_Access') ); 


INSERT INTO "function"(strname, wsver, description, sidname, kval, isdisplay ) VALUES ( 'View Shared Device Settings', 0, '', 'View_Shared_Device_Settings','394568766D5F677376695F7778576576725F7676487A6748726474723A4E', FALSE);
insert into virtualfunction (strname,sidname) values ('View Shared Device Settings','View_Shared_Device_Settings');
INSERT INTO virtualfunction2function( virtualfunctionid, functionid) VALUES (( select id from virtualfunction where sidname='View_Shared_Device_Settings'), (select id from "function" where sidname='View_Shared_Device_Settings') ); 

INSERT INTO "role"( "name", description, isdisplay)  VALUES ('Guest', '', true);

CREATE OR REPLACE FUNCTION mergerole()
  RETURNS boolean AS
$BODY$
DECLARE
    r4 "role"%rowtype;
BEGIN
		insert into role2virtualfunction (roleid,virtualfunctionid) values ((select id from "role" where name='Guest'),(select id from virtualfunction where sidname='Network Documentation'));
    
    for r4 in SELECT id FROM "role"  where name != 'Guest' loop	
			insert into role2virtualfunction (roleid,virtualfunctionid) values (r4.id,(select id from virtualfunction where sidname='Live_Access'));
    end loop;	
    
    for r4 in SELECT id FROM "role"  where name != 'Guest' and name != 'Engineer' loop	
			insert into role2virtualfunction (roleid,virtualfunctionid) values (r4.id,(select id from virtualfunction where sidname='View_Shared_Device_Settings'));
    end loop;	
    
    RETURN true;
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION mergerole() OWNER TO postgres;

select * from mergerole();
drop function mergerole();


ALTER TABLE "user" ADD COLUMN firstlogtime timestamp without time zone;
ALTER TABLE "user" ALTER COLUMN firstlogtime SET STORAGE PLAIN;

CREATE TABLE sys_option
(
  id serial NOT NULL,
  op_name character varying(100) NOT NULL,
  op_value integer NOT NULL,
  CONSTRAINT sys_option_pk PRIMARY KEY (id),
  CONSTRAINT sys_option_un UNIQUE (op_name)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE sys_option OWNER TO postgres;

insert into sys_option (op_name,op_value) values ('strongpwd',0);
insert into sys_option (op_name,op_value) values ('passwordexpireday',0);
insert into sys_option (op_name,op_value) values ('minimum_password_length',6);


INSERT INTO system_devicespec(
            strvendorname, strmodelname, idevicetype, strcpuoid, strmemoid, 
            strshowruncmd, strshowiproutecmd, strshowroutecountcmd, strshowarpcmd, 
            strshowcamcmd, strpage1cmd, strloginprompt, strpasswordprompt, 
            strprivilegeprompt, strnonprivilegeprompt, strconfigprompt, strtoenablecmd, 
            strtoconfigcmd, stryesnoprompt, ipasswordinterval, iflag, bmodified, 
            strshowcdpcmd, strinvalidcommandkey, strquit, strshowstpcmd)
    VALUES ('HP', '', 2011, '$1.3.6.1.4.1.11.2.14.11.5.1.9.6.1.0', '$1.3.6.1.4.1.11.2.14.11.5.1.1.2.1.1.1.7.1*100.0/$1.3.6.1.4.1.11.2.14.11.5.1.1.2.1.1.1.5.1', 
            'show running-config', 'show ip route', '', 'show arp', 
            'show mac-address', 'no page', '', '', 
            '', '', '', 'enable', 
            '', '', 0, 0, 0, 
            'show cdp neighbors detail', 'Ambiguous||Invalid||Incomplete', 'exit', '');
            
INSERT INTO system_devicespec(
            strvendorname, strmodelname, idevicetype, strcpuoid, strmemoid, 
            strshowruncmd, strshowiproutecmd, strshowroutecountcmd, strshowarpcmd, 
            strshowcamcmd, strpage1cmd, strloginprompt, strpasswordprompt, 
            strprivilegeprompt, strnonprivilegeprompt, strconfigprompt, strtoenablecmd, 
            strtoconfigcmd, stryesnoprompt, ipasswordinterval, iflag, bmodified, 
            strshowcdpcmd, strinvalidcommandkey, strquit, strshowstpcmd)
    VALUES ('Juniper', '', 2012, '$1.3.6.1.4.1.2636.3.1.13.1.8.7.1.0.0', '$1.3.6.1.4.1.2636.3.1.13.1.11.7.1.0.0', 
            'show config|no-more', 'show route|no-more', 'show route summary', 'show arp|no-more', 
            'show ethernet-switching table|no-more||show vlans|no-more', 'set cli screen-length 0', '', '', 
            '', '', '', '', 
            '', '', 0, 0, 0, 
            'show lldp neighbors|no-more', 'Ambigous||unknown command||syntax error||error', 'exit', '');            

update system_devicespec set strshowarpcmd='get arp' where strvendorname='netscreen' and idevicetype=2008 and strshowarpcmd='';

update system_devicespec set strshowcdpcmd='show lldp neighbors|no-more' where strvendorname='Juniper' and idevicetype=102 and strshowcdpcmd='';

update system_devicespec set strshowarpcmd='show arp|no-more' where strvendorname='Juniper' and idevicetype=102 and strshowarpcmd='';

update system_devicespec set strinvalidcommandkey='Ambigous||unknown command||syntax error' where strvendorname='Juniper' and idevicetype=102 and strinvalidcommandkey='';

update system_devicespec set strcpuoid='$1.3.6.1.4.1.2636.3.1.13.1.8.7.1.0.0' where strvendorname='Juniper' and idevicetype=102 and strcpuoid='';

update system_devicespec set strmemoid='$1.3.6.1.4.1.2636.3.1.13.1.11.7.1.0.0' where strvendorname='Juniper' and idevicetype=102 and strmemoid='';


--new link group 

ALTER TABLE linkgroup ADD COLUMN dev_searchcondition text;
ALTER TABLE linkgroup ALTER COLUMN dev_searchcondition SET STORAGE EXTENDED;

ALTER TABLE linkgroup ADD COLUMN dev_searchcontainer integer;
ALTER TABLE linkgroup ALTER COLUMN dev_searchcontainer SET STORAGE PLAIN;
ALTER TABLE linkgroup ALTER COLUMN dev_searchcontainer SET DEFAULT 1;

ALTER TABLE linkgroup ADD COLUMN is_map_auto_link boolean;
ALTER TABLE linkgroup ALTER COLUMN is_map_auto_link SET STORAGE PLAIN;
ALTER TABLE linkgroup ALTER COLUMN is_map_auto_link SET NOT NULL;
ALTER TABLE linkgroup ALTER COLUMN is_map_auto_link SET DEFAULT true;


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
			OLD.is_map_auto_link =NEW.is_map_auto_link
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


update linkgroup set dev_searchcondition='', dev_searchcontainer=1, is_map_auto_link=true where  dev_searchcondition is null and dev_searchcontainer is null and is_map_auto_link is null;



CREATE OR REPLACE VIEW linkgroupview AS 
 SELECT linkgroup.id, linkgroup.strname, linkgroup.strdesc, linkgroup.showcolor, linkgroup.showstyle, linkgroup.showwidth, linkgroup.searchcondition, linkgroup.userid, ( SELECT count(*) AS count
           FROM linkgroupinterface
          WHERE linkgroupinterface.groupid = linkgroup.id) AS irefcount, linkgroup.searchcontainer, linkgroup.dev_searchcondition, linkgroup.dev_searchcontainer, linkgroup.is_map_auto_link
   FROM linkgroup;

ALTER TABLE linkgroupview OWNER TO postgres;



-- DROP TABLE linkgroupdevice;

CREATE TABLE linkgroupdevice
(
  id serial NOT NULL,
  linkgroupid integer NOT NULL,
  deviceid integer NOT NULL,
  "type" integer NOT NULL DEFAULT 1, -- 1 static 2 dynamic 3 exclude
  CONSTRAINT linkgroupdevice_pk PRIMARY KEY (id),
  CONSTRAINT linkgroupdevice_linkgroupid FOREIGN KEY (linkgroupid)
      REFERENCES linkgroup (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT linkgroupdevice_fk_device FOREIGN KEY (deviceid)
      REFERENCES devices (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT linkgroupdevice_unique UNIQUE (linkgroupid, deviceid, type)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE linkgroupdevice OWNER TO postgres;
COMMENT ON COLUMN linkgroupdevice."type" IS '1 static 2 dynamic 3 exclude';


-- Index: fki_devicegroupdevice_fk_deviceid

-- DROP INDEX fki_devicegroupdevice_fk_deviceid;

CREATE INDEX fki_linkgroupdevice_fk_deviceid
  ON linkgroupdevice
  USING btree
  (deviceid);



CREATE OR REPLACE FUNCTION process_linkgroupdevice_dt()
  RETURNS trigger AS
$BODY$
declare tid integer;
declare uid integer;
DECLARE newuserid integer;
DECLARE olduserid integer;
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.linkgroupid = NEW.linkgroupid AND 				
			OLD.deviceid = NEW.deviceid AND
			OLD."type" = NEW."type"
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
ALTER FUNCTION process_linkgroupdevice_dt() OWNER TO postgres;


CREATE TRIGGER linkgroupdevice_dt
  BEFORE INSERT OR UPDATE OR DELETE
  ON linkgroupdevice
  FOR EACH ROW
  EXECUTE PROCEDURE process_linkgroupdevice_dt();


CREATE TABLE linkgroup_dev_devicegroup
(
  id serial NOT NULL,
  groupid integer,
  groupidbelone integer,
  CONSTRAINT linkgroup_dev_devicegroup_pk_id PRIMARY KEY (id),
  CONSTRAINT linkgroup_dev_devicegroup_fk_group FOREIGN KEY (groupid)
      REFERENCES linkgroup (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT linkgroup_dev_devicegroupbelone_fk_group FOREIGN KEY (groupidbelone)
      REFERENCES devicegroup (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
ALTER TABLE linkgroup_dev_devicegroup OWNER TO postgres;


-- Table: linkgroup_dev_site

-- DROP TABLE linkgroup_dev_site;

CREATE TABLE linkgroup_dev_site
(
  id serial NOT NULL,
  groupid integer,
  siteid integer,
  sitechild integer NOT NULL DEFAULT 0,
  CONSTRAINT linkgroup_dev_site_pk_id PRIMARY KEY (id),
  CONSTRAINT linkgroup_dev_site_fk_group FOREIGN KEY (groupid)
      REFERENCES linkgroup (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT linkgroup_dev_site_fk_site FOREIGN KEY (siteid)
      REFERENCES site (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT linkgroup_dev_site_uniq_lkgroupid UNIQUE (groupid, siteid, sitechild)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE linkgroup_dev_site OWNER TO postgres;


-- Table: linkgroup_dev_systemdevicegroup
-- bug
CREATE OR REPLACE VIEW devicegroupsystemdevicegroupview AS 
 SELECT devicegroupsystemdevicegroup.id, devicegroupsystemdevicegroup.groupid, ( SELECT devicegroup.strname
           FROM devicegroup
          WHERE devicegroup.id = devicegroupsystemdevicegroup.groupid) AS groupname, devicegroupsystemdevicegroup.groupidbelone, ( SELECT systemdevicegroup.strname
           FROM systemdevicegroup
          WHERE systemdevicegroup.id = devicegroupsystemdevicegroup.groupidbelone) AS groupnamebelone
   FROM devicegroupsystemdevicegroup;

ALTER TABLE devicegroupsystemdevicegroupview OWNER TO postgres;

-- DROP TABLE linkgroup_dev_systemdevicegroup;

CREATE TABLE linkgroup_dev_systemdevicegroup
(
  id serial NOT NULL,
  groupid integer,
  groupidbelone integer,
  CONSTRAINT linkgroup_dev_systemdevicegroup_pk_id PRIMARY KEY (id),
  CONSTRAINT linkgroup_dev_systemdevicegroup_fk_group FOREIGN KEY (groupid)
      REFERENCES linkgroup (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT linkgroup_dev_systemdevicegroupbelone_fk_group FOREIGN KEY (groupidbelone)
      REFERENCES systemdevicegroup (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
ALTER TABLE linkgroup_dev_systemdevicegroup OWNER TO postgres;


-- Function: linkgroupclearsearchcontainerids(integer)

-- DROP FUNCTION linkgroupclearsearchcontainerids(integer);

CREATE OR REPLACE FUNCTION linkgroupclear_dev_searchcontainerids(lid integer)
  RETURNS integer AS
$BODY$			
BEGIN
	delete from linkgroup_dev_devicegroup where groupid=lid;
	delete from linkgroup_dev_site where groupid=lid;
	delete from linkgroup_dev_systemdevicegroup where groupid=lid;
	return 1;
End;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION linkgroupclear_dev_searchcontainerids(integer) OWNER TO postgres;


CREATE OR REPLACE VIEW linkgroupdeviceview AS 
 SELECT linkgroupdevice.linkgroupid, linkgroupdevice.deviceid, linkgroupdevice.id, ( SELECT devices.strname
           FROM devices
          WHERE devices.id = linkgroupdevice.deviceid) AS devicename, ( SELECT linkgroup.strname
           FROM linkgroup
          WHERE linkgroup.id = linkgroupdevice.linkgroupid) AS linkgroupname, ( SELECT devices.isubtype
           FROM devices
          WHERE devices.id = linkgroupdevice.deviceid) AS isubtype, linkgroupdevice.type
   FROM linkgroupdevice;

ALTER TABLE linkgroupdeviceview OWNER TO postgres;

CREATE OR REPLACE VIEW linkgroup_dev_devicegroupview AS 
 SELECT linkgroup_dev_devicegroup.id, linkgroup_dev_devicegroup.groupid AS linkgroupid, ( SELECT linkgroup.strname
           FROM linkgroup
          WHERE linkgroup.id = linkgroup_dev_devicegroup.groupid) AS linkgroupname, linkgroup_dev_devicegroup.groupidbelone AS devicegroupid, ( SELECT devicegroup.strname
           FROM devicegroup
          WHERE devicegroup.id = linkgroup_dev_devicegroup.groupidbelone) AS devicegroupname
   FROM linkgroup_dev_devicegroup;

ALTER TABLE linkgroup_dev_devicegroupview OWNER TO postgres;

CREATE OR REPLACE VIEW linkgroup_dev_siteview AS 
 SELECT linkgroup_dev_site.id, linkgroup_dev_site.groupid AS linkgroupid, ( SELECT linkgroup.strname
           FROM linkgroup
          WHERE linkgroup.id = linkgroup_dev_site.groupid) AS linkgroupname, linkgroup_dev_site.siteid AS siteid, ( SELECT site.name
           FROM site
          WHERE site.id = linkgroup_dev_site.siteid) AS sitename, linkgroup_dev_site.sitechild
   FROM linkgroup_dev_site;

ALTER TABLE linkgroup_dev_siteview OWNER TO postgres;


CREATE OR REPLACE VIEW linkgroup_dev_systemdevicegroupview AS 
 SELECT linkgroup_dev_systemdevicegroup.id, linkgroup_dev_systemdevicegroup.groupid AS linkgroupid, ( SELECT devicegroup.strname
           FROM devicegroup
          WHERE devicegroup.id = linkgroup_dev_systemdevicegroup.groupid) AS groupname, linkgroup_dev_systemdevicegroup.groupidbelone as systemdevicegroup, ( SELECT systemdevicegroup.strname
           FROM systemdevicegroup
          WHERE systemdevicegroup.id = linkgroup_dev_systemdevicegroup.groupidbelone) AS systemdevicegroupname
   FROM linkgroup_dev_systemdevicegroup;

ALTER TABLE linkgroup_dev_systemdevicegroupview OWNER TO postgres;


CREATE OR REPLACE FUNCTION view_linkgroupdeviceview_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer, stypename character varying)
  RETURNS SETOF linkgroupdeviceview AS
$BODY$
declare
	r linkgroupdeviceview%rowtype;
	t timestamp without time zone;
BEGIN
	if uid=-1 then
		select modifytime into t from objtimestamp where typename=stypename;
	else
		select modifytime into t from objtimestamp where typename=stypename and userid=uid;
	end if;
	
	if t is null or t>dt then
		if imax <0 then
			for r in select * from linkgroupdeviceview where linkgroupid in (SELECT id FROM linkgroup where id>ibegin and userid=uid order by id) order by linkgroupid loop
			return next r;
			end loop;
		else
			for r in select * from linkgroupdeviceview where linkgroupid in (SELECT id FROM linkgroup where id>ibegin and userid=uid order by id limit imax) order by linkgroupid loop			
			return next r;
			end loop;

		end if;	
	end if;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION view_linkgroupdeviceview_retrieve(integer, integer, timestamp without time zone, integer, character varying) OWNER TO postgres;


CREATE OR REPLACE FUNCTION view_linkgroup_dev_devicegroupview_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer, stypename character varying)
  RETURNS SETOF linkgroup_dev_devicegroupview AS
$BODY$
declare
	r linkgroup_dev_devicegroupview%rowtype;
	t timestamp without time zone;
BEGIN
	if uid=-1 then
		select modifytime into t from objtimestamp where typename=stypename;
	else
		select modifytime into t from objtimestamp where typename=stypename and userid=uid;
	end if;
	
	if t is null or t>dt then
		if imax <0 then
			for r in select * from linkgroup_dev_devicegroupview where linkgroupid in (SELECT id FROM linkgroup where id>ibegin and userid=uid order by id) order by linkgroupid loop
			return next r;
			end loop;
		else
			for r in select * from linkgroup_dev_devicegroupview where linkgroupid in (SELECT id FROM linkgroup where id>ibegin and userid=uid order by id limit imax) order by linkgroupid loop			
			return next r;
			end loop;

		end if;	
	end if;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION view_linkgroup_dev_devicegroupview_retrieve(integer, integer, timestamp without time zone, integer, character varying) OWNER TO postgres;

-- Function: view_linkgroup_dev_siteview_retrieve(integer, integer, timestamp without time zone, integer, character varying)

-- DROP FUNCTION view_linkgroup_dev_siteview_retrieve(integer, integer, timestamp without time zone, integer, character varying);

CREATE OR REPLACE FUNCTION view_linkgroup_dev_siteview_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer, stypename character varying)
  RETURNS SETOF linkgroup_dev_siteview AS
$BODY$
declare
	r linkgroup_dev_siteview%rowtype;
	t timestamp without time zone;
BEGIN
	if uid=-1 then
		select modifytime into t from objtimestamp where typename=stypename;
	else
		select modifytime into t from objtimestamp where typename=stypename and userid=uid;
	end if;
	
	if t is null or t>dt then
		if imax <0 then
			for r in select * from linkgroup_dev_siteview where linkgroupid in (SELECT id FROM linkgroup where id>ibegin and userid=uid order by id) order by linkgroupid loop
			return next r;
			end loop;
		else
			for r in select * from linkgroup_dev_siteview where linkgroupid in (SELECT id FROM linkgroup where id>ibegin and userid=uid order by id limit imax) order by linkgroupid loop			
			return next r;
			end loop;

		end if;	
	end if;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION view_linkgroup_dev_siteview_retrieve(integer, integer, timestamp without time zone, integer, character varying) OWNER TO postgres;

-- Function: view_linkgroup_dev_systemdevicegroupview_retrieve(integer, integer, timestamp without time zone, integer, character varying)

-- DROP FUNCTION view_linkgroup_dev_systemdevicegroupview_retrieve(integer, integer, timestamp without time zone, integer, character varying);

CREATE OR REPLACE FUNCTION view_linkgroup_dev_systemdevicegroupview_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer, stypename character varying)
  RETURNS SETOF linkgroup_dev_systemdevicegroupview AS
$BODY$
declare
	r linkgroup_dev_systemdevicegroupview%rowtype;
	t timestamp without time zone;
BEGIN
	if uid=-1 then
		select modifytime into t from objtimestamp where typename=stypename;
	else
		select modifytime into t from objtimestamp where typename=stypename and userid=uid;
	end if;
	
	if t is null or t>dt then
		if imax <0 then
			for r in select * from linkgroup_dev_systemdevicegroupview where linkgroupid in (SELECT id FROM linkgroup where id>ibegin order by id) order by linkgroupid loop
			return next r;
			end loop;
		else
			for r in select * from linkgroup_dev_systemdevicegroupview where linkgroupid in (SELECT id FROM linkgroup where id>ibegin order by id limit imax) order by linkgroupid loop			
			return next r;
			end loop;

		end if;	
	end if;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION view_linkgroup_dev_systemdevicegroupview_retrieve(integer, integer, timestamp without time zone, integer, character varying) OWNER TO postgres;

CREATE OR REPLACE FUNCTION linkgroupdevice_delete_bytype(lid integer, ntype integer)
  RETURNS boolean AS
$BODY$
BEGIN
	delete from linkgroupdevice where linkgroupid = lid and "type" =ntype;
	return true;
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION linkgroupdevice_delete_bytype(integer, integer) OWNER TO postgres;


CREATE OR REPLACE FUNCTION linkgroupdevice_upsert_bytype2(lid integer, ntype integer, devs character varying[])
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
		
		select id into lgi_id from linkgroupdevice where linkgroupid = lid and deviceid = dev_id  and "type" =ntype;
		if lgi_id is null then
			insert into linkgroupdevice (linkgroupid,deviceid,"type") values (lid, dev_id,ntype);
		end if;
	end loop;	
	return true;
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION linkgroupdevice_upsert_bytype2(integer, integer, character varying[]) OWNER TO postgres;


CREATE OR REPLACE FUNCTION linkgroupdevice_delete_dynamic(lid integer)
  RETURNS boolean AS
$BODY$
BEGIN
	delete from linkgroupdevice where linkgroupid = lid and ( "type" = 2  or "type"=4);
	return true;
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION linkgroupdevice_delete_dynamic(integer) OWNER TO postgres;


CREATE OR REPLACE FUNCTION linkgroupinterface_delete_dynamic(lid integer)
  RETURNS boolean AS
$BODY$
BEGIN
	delete from linkgroupinterface where groupid = lid and ( "type" = 2  or "type"=4);
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
    dev_id integer;
    ex_id integer;
    r_type integer;
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

		select id into ex_id from linkgroupinterface where groupid = lid and interfaceid = intf_id and "type" = 3 and interfaceip = intfips[i] and deviceid=dev_id;
		if ex_id is null then 
			select id into ex_id from linkgroupdevice where linkgroupid = lid and "type" = 3 and deviceid=dev_id;
		end if;

		r_type=4;
		if ex_id is null then 
			r_type=2;
		end if;
		select id into lgi_id from linkgroupinterface where groupid = lid and interfaceid = intf_id and "type" = r_type and interfaceip = intfips[i] and deviceid=dev_id;
		if lgi_id is null then
			insert into linkgroupinterface (groupid,interfaceid,"type",interfaceip,deviceid) values (lid, intf_id, r_type, intfips[i],dev_id);
		end if;

	end loop;	
	return true;
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION linkgroupinterface_upsert_dynamic(integer, character varying[], character varying[], character varying[]) OWNER TO postgres;



-- Function: linkgroupdevice_upsert_dynamic(integer, character varying[])

-- DROP FUNCTION linkgroupdevice_upsert_dynamic(integer, character varying[]);

CREATE OR REPLACE FUNCTION linkgroupdevice_upsert_dynamic(lid integer, devs character varying[])
  RETURNS boolean AS
$BODY$
DECLARE
    i integer;
    lgd_id integer;
    dev_id integer;
    ex_id integer;
    r_type integer;
BEGIN
	for i in 1..array_length(devs, 1) LOOP
	
		select id into dev_id from devices where strname = devs[i];
		if dev_id is null then
			continue;
		end if;
	
		select id into ex_id from linkgroupdevice where linkgroupid = lid and "type" = 3 and deviceid=dev_id;

		r_type=4;
		if ex_id is null then 
			r_type=2;
		end if;
		
		select id into lgd_id from linkgroupdevice where linkgroupid = lid and "type" = r_type and deviceid=dev_id;
		if lgd_id is null then
			insert into linkgroupdevice (linkgroupid,"type",deviceid) values (lid, r_type, dev_id);
		end if;
		
	end loop;	
	return true;
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION linkgroupdevice_upsert_dynamic(integer, character varying[]) OWNER TO postgres;



            
update system_info set ver=401;