\connect "nbws"

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;


----------- nomp_jumpbox -----------
DROP FUNCTION view_nomp_jumpbox_retrieve(timestamp without time zone, character varying, integer[]);
DROP VIEW nomp_jumpboxview;
DROP TRIGGER nomp_jumpbox_dt ON nomp_jumpbox;
DROP FUNCTION process_nomp_jumpbox_dt();


ALTER TABLE nomp_jumpbox ADD COLUMN licguid character varying(128);
ALTER TABLE nomp_jumpbox ALTER COLUMN licguid SET STORAGE EXTENDED;
update nomp_jumpbox set licguid=:licguid;


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
			OLD.userid= NEW.userid AND
			OLD.licguid=NEW.licguid			
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


CREATE OR REPLACE VIEW nomp_jumpboxview AS 
 SELECT nomp_jumpbox.id, nomp_jumpbox.strname, nomp_jumpbox.itype, nomp_jumpbox.stripaddr, nomp_jumpbox.iport, nomp_jumpbox.imode, nomp_jumpbox.strusername, nomp_jumpbox.strpasswd, nomp_jumpbox.strloginprompt, nomp_jumpbox.strpasswdprompt, nomp_jumpbox.strcommandprompt, nomp_jumpbox.stryesnoprompt, nomp_jumpbox.bmodified, nomp_jumpbox.strenablecmd, nomp_jumpbox.strenablepasswordprompt, nomp_jumpbox.strenablepassword, nomp_jumpbox.strenableprompt, nomp_jumpbox.ipri, nomp_jumpbox.userid, ( SELECT count(*) AS count
           FROM devicesetting
          WHERE devicesetting.telnetproxyid = nomp_jumpbox.id) AS irefcount, nomp_jumpbox.licguid
   FROM nomp_jumpbox
  ORDER BY nomp_jumpbox.ipri;

ALTER TABLE nomp_jumpboxview OWNER TO postgres;


CREATE OR REPLACE FUNCTION view_nomp_jumpbox_retrieve(dt timestamp without time zone, stypename character varying, ids integer[], sguid character varying)
  RETURNS SETOF nomp_jumpboxview AS
$BODY$
declare
	r nomp_jumpboxview%rowtype;
	t timestamp without time zone;
BEGIN		
        select modifytime into t from objtimestamp where typename=stypename;
	if t is null or t>dt then
		for r in SELECT * FROM nomp_jumpboxview where userid = any(ids) and licguid=sguid loop
		return next r;
		end loop;	
	End IF;
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION view_nomp_jumpbox_retrieve(timestamp without time zone, character varying, integer[], character varying) OWNER TO postgres;
----------- nomp_jumpbox -----------


----------- nomp_telnetinfo -----------
DROP FUNCTION view_nomp_telnetinfo_retrieve(timestamp without time zone, character varying, integer, character varying);
DROP VIEW nomp_telnetinfoview;
DROP TRIGGER nomp_telnetinfo_dt ON nomp_telnetinfo;
DROP FUNCTION process_nomp_telnetinfo_dt();


ALTER TABLE nomp_telnetinfo ADD COLUMN licguid character varying(128);
ALTER TABLE nomp_telnetinfo ALTER COLUMN licguid SET STORAGE EXTENDED;
update nomp_telnetinfo set licguid=:licguid;


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
			OLD.ipri = NEW.ipri AND
			OLD.licguid=NEW.licguid
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


CREATE OR REPLACE VIEW nomp_telnetinfoview AS 
 SELECT nomp_telnetinfo.id, nomp_telnetinfo.stralias, nomp_telnetinfo.idevicetype, nomp_telnetinfo.strusername, nomp_telnetinfo.strpasswd, nomp_telnetinfo.bmodified, nomp_telnetinfo.userid, nomp_telnetinfo.ipri, nomp_telnetinfo.id AS irefcount, nomp_telnetinfo.licguid
   FROM nomp_telnetinfo
  ORDER BY nomp_telnetinfo.ipri;

ALTER TABLE nomp_telnetinfoview OWNER TO postgres;


CREATE OR REPLACE FUNCTION view_nomp_telnetinfo_retrieve(dt timestamp without time zone, stypename character varying, uid integer, funcname character varying, sguid character varying)
  RETURNS SETOF nomp_telnetinfoview AS
$BODY$
declare
	r nomp_telnetinfoview%rowtype;
	t timestamp without time zone;
	ispublic integer;
BEGIN
	select 0 into  ispublic;		
	--select c.count into ispublic from (select count(a.id) as count from (select user2role.roleid as id from "user",user2role where "user".id=uid and "user".id =user2role.userid) as a where a.id in (select role2function.roleid as id from role2function,"function" where "function".sidname=funcname and "function".id=role2function.functionid)) as c;
  select modifytime into t from objtimestamp where typename=stypename;
	if t is null or t>dt then
		for r in SELECT * FROM nomp_telnetinfoview where userid=uid and licguid=sguid loop
			if ispublic>0 then 
				select a.count into r.iRefCount from (select count(id) as count from devicesetting where username=r.STRuseRnaMe and UserPassword=r.STRpAssWD) as a;								
			else
				select a.count into r.iRefCount from (select count(id) as count from userdevicesetting where TeLNetUserName=r.STRuseRnaMe and TeLNetPwD=r.STRpAssWD) as a;								
			end if;			
			return next r;
		end loop;	
	End IF;
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION view_nomp_telnetinfo_retrieve(timestamp without time zone, character varying, integer, character varying, character varying) OWNER TO postgres;
----------- nomp_telnetinfo -----------


----------- userdevicesetting -----------
DROP FUNCTION user_device_setting_retrieve(character varying, integer);
DROP FUNCTION user_device_setting_update(character varying, integer, userdevicesetting);
DROP FUNCTION user_device_setting_upsert(character varying, integer, userdevicesetting);
DROP FUNCTION view_userdevicesetting_retrieve(integer, integer, timestamp without time zone, integer);
DROP VIEW userdevicesettingview;
DROP TRIGGER userdevicesetting_dt ON userdevicesetting;
DROP FUNCTION process_userdevicesetting_dt();


ALTER TABLE userdevicesetting ADD COLUMN licguid character varying(128);
ALTER TABLE userdevicesetting ALTER COLUMN licguid SET STORAGE EXTENDED;
update userdevicesetting set licguid=:licguid;


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
		   OLD.jumpboxid = NEW.jumpboxid AND
		   OLD.licguid=NEW.licguid
		   then
			return OLD;
		end IF;
		NEW.dtstamp=now();
		  select id into tid from objprivatetimestamp where typename='PrivateDeviceSetting' and userid=new.userid and licguid=new.licguid;
		  if tid is null then
		   insert into objprivatetimestamp (typename,userid,modifytime,licguid) values('PrivateDeviceSetting',new.userid,now(),new.licguid);
		  else
		   update objprivatetimestamp set modifytime=now() where typename='PrivateDeviceSetting' and userid=new.userid and licguid=new.licguid;
		  end if;
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
	  select id into tid from objprivatetimestamp where typename='PrivateDeviceSetting' and userid=new.userid and licguid=new.licguid;
	  if tid is null then
	   insert into objprivatetimestamp (typename,userid,modifytime,licguid) values('PrivateDeviceSetting',new.userid,now(),new.licguid);
	  else
	   update objprivatetimestamp set modifytime=now() where typename='PrivateDeviceSetting' and userid=new.userid and licguid=new.licguid;
	  end if;
	  NEW.dtstamp=now();
  RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
			select id into tid from objprivatetimestamp where typename='PrivateDeviceSetting' and userid=old.userid and licguid=OLD.licguid;
			if tid is null then
				insert into objprivatetimestamp (typename,userid,modifytime,licguid) values('PrivateDeviceSetting',old.userid,now(),old.licguid);
			else
				update objprivatetimestamp set modifytime=now() where typename='PrivateDeviceSetting' and userid=old.userid and licguid=OLD.licguid;
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


CREATE OR REPLACE VIEW userdevicesettingview AS 
 SELECT userdevicesetting.id, userdevicesetting.deviceid, userdevicesetting.userid, userdevicesetting.managerip, userdevicesetting.telnetusername, userdevicesetting.telnetpwd, userdevicesetting.dtstamp, userdevicesetting.jumpboxid, devices.strname AS devicename, userdevicesetting.licguid
   FROM userdevicesetting, devices
  WHERE devices.id = userdevicesetting.deviceid;

ALTER TABLE userdevicesettingview OWNER TO postgres;


CREATE OR REPLACE FUNCTION user_device_setting_retrieve(devname character varying, user_id integer, lic_guid character varying)
  RETURNS userdevicesetting AS
$BODY$
declare
	r userdevicesetting%rowtype;
BEGIN
   SELECT * into r FROM userdevicesetting where deviceid IN ( select id from devices where strname=devname ) AND userid=user_id and licguid=lic_guid;
   return r;
   
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION user_device_setting_retrieve(character varying, integer, character varying) OWNER TO postgres;


CREATE OR REPLACE FUNCTION user_device_setting_update(devname character varying, u_id integer, lic_guid character varying, ds userdevicesetting)
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

	select id into ds_id from userdevicesetting where deviceid=r_id AND userid=u_id AND licguid=lic_guid;
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
ALTER FUNCTION user_device_setting_update(character varying, integer, character varying, userdevicesetting) OWNER TO postgres;


CREATE OR REPLACE FUNCTION user_device_setting_upsert(devname character varying, u_id integer, lic_guid character varying, ds userdevicesetting)
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

	select id into ds_id from userdevicesetting where deviceid=r_id AND userid=u_id AND licguid=lic_guid;
	if ds_id IS NULL THEN
		insert into userdevicesetting(
			  deviceid,
			  userid,
			  managerip,
			  telnetusername,
			  telnetpwd,
			  dtstamp,
			  jumpboxid,
			  licguid
			)
			values ( 
			r_id,
			u_id,
			ds.managerip,
			ds.telnetusername,
			ds.telnetpwd,
			now(),
			ds.jumpboxid,
			lic_guid
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
ALTER FUNCTION user_device_setting_upsert(character varying, integer, character varying, userdevicesetting) OWNER TO postgres;


CREATE OR REPLACE FUNCTION view_userdevicesetting_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer, sguid character varying)
  RETURNS SETOF userdevicesettingview AS
$BODY$
declare
	r userdevicesettingview%rowtype;
BEGIN
	if imax <0 then
		for r in SELECT * FROM userdevicesettingview where id>ibegin and userid=uid and licguid=sguid AND dtstamp>dt order by id loop
		return next r;
		end loop;
	else
		for r in SELECT * FROM userdevicesettingview where id>ibegin and userid=uid AND licguid=sguid and dtstamp>dt order by id limit imax loop
		return next r;
		end loop;

	end if;
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION view_userdevicesetting_retrieve(integer, integer, timestamp without time zone, integer, character varying) OWNER TO postgres;
----------- userdevicesetting -----------


----------- site -----------
DROP FUNCTION view_site_retrieve(integer, integer, timestamp without time zone, character varying);
DROP FUNCTION site_addormodify(integer, site);
DROP VIEW siteview;
DROP TRIGGER site_dt ON site;
DROP FUNCTION process_site_dt();


ALTER TABLE site ADD COLUMN searchcondition text;
ALTER TABLE site ALTER COLUMN searchcondition SET STORAGE EXTENDED;
update site set searchcondition='';

ALTER TABLE site ADD COLUMN searchcontainer integer;
ALTER TABLE site ALTER COLUMN searchcontainer SET STORAGE PLAIN;
update site set searchcontainer=-1;
ALTER TABLE site ALTER COLUMN searchcontainer SET DEFAULT (-1);


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
			OLD.comment = NEW.comment AND
			OLD.searchcondition = NEW.searchcondition AND
			OLD.searchcontainer = NEW.searchcontainer
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


CREATE TRIGGER site_dt
  BEFORE INSERT OR UPDATE OR DELETE
  ON site
  FOR EACH ROW
  EXECUTE PROCEDURE process_site_dt();


CREATE OR REPLACE VIEW siteview AS 
 SELECT site.id, site2site.parentid, site.name, site.region, site.location_address, site.employee_number, site.contact_name, site.phone_number, site.email, site.type, site.color, site.comment, site.lasttimestamp, site.searchcondition, site.searchcontainer, ( SELECT count(*) AS count
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
		lasttimestamp,
		searchcondition,
		searchcontainer
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
		now(),
		ssite.searchcondition,
		ssite.searchcontainer
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
		lasttimestamp,
		searchcondition,
		searchcontainer
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
		now(),
		ssite.searchcondition,
		ssite.searchcontainer
		)
		where id = site_id;
		return site_id;
	end if;
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION site_addormodify(integer, site) OWNER TO postgres;
----------- site -----------


----------- object_file_info -----------
DROP FUNCTION object_file_info_insert(object_file_info);


ALTER TABLE object_file_info ADD COLUMN licguid character varying(128);
ALTER TABLE object_file_info ALTER COLUMN licguid SET STORAGE EXTENDED;
update object_file_info set licguid=:licguid where id>182;


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
			  path_id,
			  licguid
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
			  ofile.path_id,
			  ofile.licguid
			  );
			  return lastval();	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION object_file_info_insert(object_file_info) OWNER TO postgres;
----------- object_file_info -----------


----------- data store -----------
DROP TRIGGER device_property_dt ON device_property;
DROP FUNCTION process_device_property_dt();

DROP TRIGGER discover_missdevice_dt ON discover_missdevice;
DROP FUNCTION process_discover_missdevice_dt();

DROP TRIGGER discover_newdevice_dt ON discover_newdevice;
DROP FUNCTION process_discover_newdevice_dt();

DROP TRIGGER discover_snmpdevice_dt ON discover_snmpdevice;
DROP FUNCTION process_discover_snmpdevice_dt();


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
----------- data store -----------


----------- fix bug -----------
DROP FUNCTION device_property_upsert(devicepropertyview);
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
			where id = ds_id and ( manageif_mac != dp.manageif_mac or manageif_mac is null or vendor != dp.vendor or vendor is null or model != dp.model or model is null or sysobjectid != dp.sysobjectid or sysobjectid is null or software_version != dp.software_version or software_version is null or serial_number != dp.serial_number or serial_number is null or asset_tag != dp.asset_tag or asset_tag is null or system_memory != dp.system_memory or system_memory is null or location != dp.location or location is null or network_cluster != dp.network_cluster or network_cluster is null or  contact != dp.contact or contact is null or hierarchy_layer != dp.hierarchy_layer or hierarchy_layer is null or description != dp.description or description is null or management_interface != dp.management_interface or management_interface is null or  extradata != dp.extradata or extradata is null );
		return ds_id;
	end if;
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION device_property_upsert(devicepropertyview) OWNER TO postgres;
----------- fix bug -----------


----------- other -----------
CREATE OR REPLACE FUNCTION processsystemvariable_dt()
  RETURNS trigger AS
$BODY$
		
    BEGIN
        IF (TG_OP = 'UPDATE') THEN					
		update objtimestamp set modifytime=now() where typename='SystemVariable';			
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='SystemVariable';
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='SystemVariable';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION processsystemvariable_dt() OWNER TO postgres;


CREATE TRIGGER sys_environmentvariable_dt
  BEFORE INSERT OR UPDATE OR DELETE
  ON sys_environmentvariable
  FOR EACH ROW
  EXECUTE PROCEDURE processsystemvariable_dt();


CREATE TRIGGER domain_name_dt
  BEFORE INSERT OR UPDATE OR DELETE
  ON domain_name
  FOR EACH ROW
  EXECUTE PROCEDURE processsystemvariable_dt();


CREATE TRIGGER domain_option_dt
  BEFORE INSERT OR UPDATE OR DELETE
  ON domain_option
  FOR EACH ROW
  EXECUTE PROCEDURE processsystemvariable_dt();




ALTER TABLE showcommandtemplate ADD COLUMN licguid character varying(128);
ALTER TABLE showcommandtemplate ALTER COLUMN licguid SET STORAGE EXTENDED;
update showcommandtemplate set licguid=:licguid;

ALTER TABLE discover_schedule ADD COLUMN licguid character varying(128);
ALTER TABLE discover_schedule ALTER COLUMN licguid SET STORAGE EXTENDED;
update discover_schedule set licguid=:licguid;
ALTER TABLE discover_schedule ALTER COLUMN licguid SET NOT NULL;

ALTER TABLE benchmarktask ADD COLUMN bgpnbr integer;
ALTER TABLE benchmarktask ALTER COLUMN bgpnbr SET STORAGE PLAIN;
update benchmarktask set  bgpnbr=0;
ALTER TABLE benchmarktask ALTER COLUMN bgpnbr SET NOT NULL;
ALTER TABLE benchmarktask ALTER COLUMN bgpnbr SET DEFAULT 1;
----------- other -----------