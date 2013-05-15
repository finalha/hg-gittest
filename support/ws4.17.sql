\connect "nbws"

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

ALTER TABLE system_vendormodel ADD COLUMN strdriverid varchar(255);
ALTER TABLE system_vendormodel ADD COLUMN strcpuoid text;
ALTER TABLE system_vendormodel ADD COLUMN strmemoid text;
ALTER TABLE system_vendormodel ADD COLUMN autoupdate integer;

update system_vendormodel set strdriverid='' where strdriverid is null;
update system_vendormodel set strmemoid='' where strmemoid is null;
update system_vendormodel set strcpuoid='' where strcpuoid is null;
update system_vendormodel set autoupdate=1 where autoupdate is null;

CREATE OR REPLACE VIEW userview AS 
 SELECT "user".id, "user".strname, "user".password, "user".description, "user".email, "user".telephone, "user".wsver, "user".can_use_global_telnet, "user".validtime, "user".validdate, "user".expired_days, "user".offline_minutes, "user".firstlogtime
   FROM "user"
  ORDER BY "user".id;

ALTER TABLE userview OWNER TO postgres;


CREATE OR REPLACE FUNCTION searchuser(keyval character varying, optionval integer)
  RETURNS SETOF userview AS
$BODY$
declare
	r userview%rowtype;
BEGIN
	IF optionval =0 THEN
	    FOR r IN select * from userview where (strname ~* keyval or email ~* keyval) and strname not in ('default','system')  LOOP
		RETURN NEXT r;
	     END LOOP;		
	ELSIF optionval=1 then
	    FOR r IN select * from userview where (strname ~* keyval or email ~* keyval) and (validdate is null or validdate > now()) and strname not in ('default','system') LOOP
		RETURN NEXT r;
	     END LOOP;		
	ELSE
		FOR r IN select * from userview where (strname ~* keyval or email ~* keyval) and validdate is not null and validdate <now() and strname not in ('default','system') LOOP
		RETURN NEXT r;
	     END LOOP;		
	end if;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION searchuser(character varying, integer) OWNER TO postgres;

-- nomp_enablepassword add field start ----

DROP FUNCTION view_nomp_enablepasswd_retrieve(timestamp without time zone, character varying);
DROP VIEW nomp_enablepasswdview;

ALTER TABLE nomp_enablepasswd ADD COLUMN strenableusername character varying(255);
ALTER TABLE nomp_enablepasswd ALTER COLUMN strenableusername SET STORAGE EXTENDED;

DROP TRIGGER nomp_enablepasswd_dt ON nomp_enablepasswd;
update nomp_enablepasswd set strenableusername='' where strenableusername is null;
DROP FUNCTION process_nomp_enablepasswd_dt();

CREATE OR REPLACE FUNCTION process_nomp_enablepasswd_dt()
  RETURNS trigger AS
$BODY$

    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.stralias = NEW.stralias AND 
			OLD.strenablepasswd = NEW.strenablepasswd AND
			OLD.bmodified = NEW.bmodified AND			
			OLD.strenableusername = NEW.strenableusername AND
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


CREATE OR REPLACE VIEW nomp_enablepasswdview AS 
 SELECT nomp_enablepasswd.*, ( SELECT count(*) AS count
           FROM devicesetting
          WHERE devicesetting.enablepassword = nomp_enablepasswd.strenablepasswd) AS irefcount
   FROM nomp_enablepasswd
  ORDER BY nomp_enablepasswd.ipri;

ALTER TABLE nomp_enablepasswdview OWNER TO postgres;


CREATE OR REPLACE FUNCTION view_nomp_enablepasswd_retrieve(dt timestamp without time zone, stypename character varying)
  RETURNS SETOF nomp_enablepasswdview AS
$BODY$
declare
	r nomp_enablepasswdview%rowtype;
	t timestamp without time zone;
BEGIN		
        select modifytime into t from objtimestamp where typename=stypename;
	if t is null or t>dt then
		for r in SELECT * FROM nomp_enablepasswdview loop
		return next r;
		end loop;	
	End IF;
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION view_nomp_enablepasswd_retrieve(timestamp without time zone, character varying) OWNER TO postgres;

-- nomp_enablepassword add field end ----

-- devicesetting add field start ----
DROP FUNCTION searchdevicebygroupnofiler(character varying, integer, integer, integer[], character varying[]);
DROP FUNCTION searchdevicebygroupnofiler(character varying, integer);
DROP FUNCTION searchdevicebygroupnofiler(character varying, integer, integer, character varying[]);
DROP FUNCTION searchalldevicenofiler(character varying);
DROP FUNCTION searchalldevicenofiler(character varying, integer, integer[], character varying[]);
DROP FUNCTION searchalldevicenofiler(character varying, integer, character varying[]);
DROP FUNCTION view_device_setting_retrieve(integer, integer, timestamp without time zone);
DROP FUNCTION view_device_setting_retrieve_by_nap(integer, integer, timestamp without time zone, integer);
DROP FUNCTION device_settingview_retrieve_by_devs(character varying[]);
DROP VIEW devicesettingview;

ALTER TABLE devicesetting ADD COLUMN driverid character varying(255);
ALTER TABLE devicesetting ALTER COLUMN driverid SET STORAGE EXTENDED;

ALTER TABLE devicesetting ADD COLUMN enpasswordprompt character varying(255);
ALTER TABLE devicesetting ALTER COLUMN enpasswordprompt SET STORAGE EXTENDED;

ALTER TABLE devicesetting ADD COLUMN enableusername character varying(255);
ALTER TABLE devicesetting ALTER COLUMN enableusername SET STORAGE EXTENDED;

ALTER TABLE devicesetting ADD COLUMN enableusernameprompt character varying(255);
ALTER TABLE devicesetting ALTER COLUMN enableusernameprompt SET STORAGE EXTENDED;

ALTER TABLE devicesetting ADD COLUMN cpuexpression text;
ALTER TABLE devicesetting ALTER COLUMN cpuexpression SET STORAGE EXTENDED;

ALTER TABLE devicesetting ADD COLUMN memoryexpression text;
ALTER TABLE devicesetting ALTER COLUMN memoryexpression SET STORAGE EXTENDED;

ALTER TABLE devicesetting ADD COLUMN loginscript text;
ALTER TABLE devicesetting ALTER COLUMN loginscript SET STORAGE EXTENDED;

ALTER TABLE devicesetting ADD COLUMN loginscriptenable boolean;
ALTER TABLE devicesetting ALTER COLUMN loginscriptenable SET STORAGE PLAIN;
ALTER TABLE devicesetting ALTER COLUMN loginscriptenable SET DEFAULT false;

DROP TRIGGER devicesetting_dt ON devicesetting;
update devicesetting set driverid='' where driverid is null;
update devicesetting set enpasswordprompt=''  where enpasswordprompt is null;
update devicesetting set enableusername=''  where enableusername is null;
update devicesetting set enableusernameprompt=''  where enableusernameprompt is null;
update devicesetting set cpuexpression=''  where cpuexpression is null;
update devicesetting set memoryexpression=''  where memoryexpression is null;
update devicesetting set loginscript=''  where loginscript is null;
update devicesetting set loginscriptenable=false  where loginscriptenable is null;

DROP FUNCTION process_devicessetting_dt();

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
			OLD.configfile_time=NEW.configfile_time AND
			OLD.driverid=NEW.driverid AND
			OLD.enpasswordprompt=NEW.enpasswordprompt AND
			OLD.enableusername=NEW.enableusername AND
			OLD.enableusernameprompt=NEW.enableusernameprompt AND
			OLD.cpuexpression=NEW.cpuexpression AND
			OLD.memoryexpression=NEW.memoryexpression AND
			OLD.loginscript=NEW.loginscript AND
			OLD.loginscriptenable=NEW.loginscriptenable
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
			authentication_mode,
			driverid,
			enpasswordprompt,
			enableusername,
			enableusernameprompt,
			cpuexpression,
			memoryexpression,
			loginscript,
			loginscriptenable
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
			ds.authentication_mode,
			ds.driverid,
			ds.enpasswordprompt,
			ds.enableusername,
			ds.enableusernameprompt,
			ds.cpuexpression,
			ds.memoryexpression,
			ds.loginscript,
			ds.loginscriptenable
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
			configfile_time,
			driverid,
			enpasswordprompt,
			enableusername,
			enableusernameprompt,
			cpuexpression,
			memoryexpression,
			loginscript,
			loginscriptenable
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
			ds.configfile_time,
			ds.driverid,
			ds.enpasswordprompt,
			ds.enableusername,
			ds.enableusernameprompt,
			ds.cpuexpression,
			ds.memoryexpression,
			ds.loginscript,
			ds.loginscriptenable
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
			authentication_mode,
			driverid,
			enpasswordprompt,
			enableusername,
			enableusernameprompt,
			cpuexpression,
			memoryexpression,
			loginscript,
			loginscriptenable
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
			ds.authentication_mode,
			ds.driverid,
			ds.enpasswordprompt,
			ds.enableusername,
			ds.enableusernameprompt,
			ds.cpuexpression,
			ds.memoryexpression,
			ds.loginscript,
			ds.loginscriptenable
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


-- devicesetting add field end ----

CREATE TABLE nd
(
  id serial NOT NULL,
  hostnameexpression character varying(256),
  isregularexpression boolean,
  ipranges character varying(256),
  devicetype integer,
  driverid character varying(128),
  CONSTRAINT nbpk PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE nd OWNER TO postgres;


CREATE OR REPLACE FUNCTION process_nd_dt()
  RETURNS trigger AS
$BODY$

    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.hostnameexpression = NEW.hostnameexpression AND 
			OLD.isregularexpression = NEW.isregularexpression AND
			OLD.ipranges = NEW.ipranges AND
			OLD.devicetype = NEW.devicetype AND
			OLD.driverid = NEW.driverid
		 then
			return OLD;
		end IF;
		update objtimestamp set modifytime=now() where typename='nd';
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='nd';		
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='nd';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION process_nd_dt() OWNER TO postgres;


CREATE TRIGGER nomp_nd_dt
  BEFORE INSERT OR UPDATE OR DELETE
  ON nd
  FOR EACH ROW
  EXECUTE PROCEDURE process_nd_dt();


CREATE OR REPLACE FUNCTION view_nd(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying)
  RETURNS SETOF nd AS
$BODY$
declare
	r nd%rowtype;
	t timestamp without time zone;
BEGIN
	select modifytime into t from objtimestamp where typename=stypename;
	
	if t is null or t>dt then
		if imax <0 then
			for r in SELECT * FROM nd where id>ibegin order by id loop
			return next r;
			end loop;
		else
			for r in SELECT * FROM nd where id>ibegin order by id limit imax loop
			return next r;
			end loop;

		end if;	
	end if;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION view_nd(integer, integer, timestamp without time zone, character varying) OWNER TO postgres;

insert into objtimestamp (typename,modifytime,userid) values ('nd','1900-01-01 00:00:00',-1);


CREATE TABLE checkupdate
(
  id serial NOT NULL,
  "version" integer NOT NULL,
  ini_filename character varying(64) NOT NULL,
  lasttimestamp timestamp without time zone NOT NULL DEFAULT now(),
  zip_filename character varying(64) NOT NULL,
  packageisexcuted boolean NOT NULL DEFAULT false,
  excutedstatus integer NOT NULL DEFAULT 0,
  CONSTRAINT checkupdate_pk PRIMARY KEY (id),
  CONSTRAINT checkupdate_unkey UNIQUE (version)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE checkupdate OWNER TO postgres;



insert into device_icon (icon_name, lasttimestamp) values ('Cisco Catalyst Switch',now());
insert into device_icon (icon_name, lasttimestamp) values ('Cisco Router',now());
insert into device_icon (icon_name, lasttimestamp) values ('Cisco IOS Switch',now());
insert into device_icon (icon_name, lasttimestamp) values ('Cisco PIX Firewall',now());
insert into device_icon (icon_name, lasttimestamp) values ('End System',now());
insert into device_icon (icon_name, lasttimestamp) values ('LAN',now());
insert into device_icon (icon_name, lasttimestamp) values ('WAN',now());
insert into device_icon (icon_name, lasttimestamp) values ('MPLS Cloud',now());
insert into device_icon (icon_name, lasttimestamp) values ('Call Manager',now());
insert into device_icon (icon_name, lasttimestamp) values ('IP Phone',now());
insert into device_icon (icon_name, lasttimestamp) values ('Cisco WAP',now());
insert into device_icon (icon_name, lasttimestamp) values ('Cisco ASA Firewall',now());
insert into device_icon (icon_name, lasttimestamp) values ('Juniper Router',now());
insert into device_icon (icon_name, lasttimestamp) values ('NetScreen Firewall',now());
insert into device_icon (icon_name, lasttimestamp) values ('Extreme Switch',now());
insert into device_icon (icon_name, lasttimestamp) values ('Unclassified Device',now());
insert into device_icon (icon_name, lasttimestamp) values ('Mute LAN',now());
insert into device_icon (icon_name, lasttimestamp) values ('Checkpoint Firewall',now());
insert into device_icon (icon_name, lasttimestamp) values ('F5 Load Balancer',now());
insert into device_icon (icon_name, lasttimestamp) values ('Unclassified Router',now());
insert into device_icon (icon_name, lasttimestamp) values ('Unclassified Switch',now());
insert into device_icon (icon_name, lasttimestamp) values ('CSS',now());
insert into device_icon (icon_name, lasttimestamp) values ('Cache Engine',now());
insert into device_icon (icon_name, lasttimestamp) values ('Unclassified Firewall',now());
insert into device_icon (icon_name, lasttimestamp) values ('Unclassified Load Balancer',now());
insert into device_icon (icon_name, lasttimestamp) values ('Unknown IP Device',now());
insert into device_icon (icon_name, lasttimestamp) values ('3Com Switch',now());
insert into device_icon (icon_name, lasttimestamp) values ('Cisco Nexus Switch',now());
insert into device_icon (icon_name, lasttimestamp) values ('DMVPN',now());
insert into device_icon (icon_name, lasttimestamp) values ('HP ProCurve Switch',now());
insert into device_icon (icon_name, lasttimestamp) values ('Juniper EX Switch',now());
insert into device_icon (icon_name, lasttimestamp) values ('Internet Wan',now());
insert into device_icon (icon_name, lasttimestamp) values ('WLC',now());
insert into device_icon (icon_name, lasttimestamp) values ('LWAP',now());
insert into device_icon (icon_name, lasttimestamp) values ('Arista Switch',now());
insert into device_icon (icon_name, lasttimestamp) values ('Brocade Switch',now());
insert into device_icon (icon_name, lasttimestamp) values ('Force10 Switch',now());
insert into device_icon (icon_name, lasttimestamp) values ('Cisco IOS XR',now());
insert into device_icon (icon_name, lasttimestamp) values ('Juniper SRX Firewall',now());


insert into symbol2deviceicon (symbolid,deviceicon_id,lasttimestamp) values (2018,(select id from device_icon where icon_name='Juniper SRX Firewall'),now());
insert into symbol2deviceicon (symbolid,deviceicon_id,lasttimestamp) values (45,(select id from device_icon where icon_name='Cisco Catalyst Switch'),now());
insert into symbol2deviceicon (symbolid,deviceicon_id,lasttimestamp) values (1,(select id from device_icon where icon_name='Cisco Router'),now());
insert into symbol2deviceicon (symbolid,deviceicon_id,lasttimestamp) values (68,(select id from device_icon where icon_name='Cisco IOS XR'),now());
insert into symbol2deviceicon (symbolid,deviceicon_id,lasttimestamp) values (2,(select id from device_icon where icon_name='Cisco IOS Switch'),now());
insert into symbol2deviceicon (symbolid,deviceicon_id,lasttimestamp) values (3,(select id from device_icon where icon_name='Cisco PIX Firewall'),now());
insert into symbol2deviceicon (symbolid,deviceicon_id,lasttimestamp) values (7,(select id from device_icon where icon_name='End System'),now());
insert into symbol2deviceicon (symbolid,deviceicon_id,lasttimestamp) values (4,(select id from device_icon where icon_name='LAN'),now());
insert into symbol2deviceicon (symbolid,deviceicon_id,lasttimestamp) values (5,(select id from device_icon where icon_name='WAN'),now());
insert into symbol2deviceicon (symbolid,deviceicon_id,lasttimestamp) values (51,(select id from device_icon where icon_name='MPLS Cloud'),now());
insert into symbol2deviceicon (symbolid,deviceicon_id,lasttimestamp) values (59,(select id from device_icon where icon_name='Call Manager'),now());
insert into symbol2deviceicon (symbolid,deviceicon_id,lasttimestamp) values (60,(select id from device_icon where icon_name='IP Phone'),now());
insert into symbol2deviceicon (symbolid,deviceicon_id,lasttimestamp) values (56,(select id from device_icon where icon_name='Cisco WAP'),now());
insert into symbol2deviceicon (symbolid,deviceicon_id,lasttimestamp) values (67,(select id from device_icon where icon_name='Cisco ASA Firewall'),now());
insert into symbol2deviceicon (symbolid,deviceicon_id,lasttimestamp) values (101,(select id from device_icon where icon_name='Juniper Router'),now());
insert into symbol2deviceicon (symbolid,deviceicon_id,lasttimestamp) values (104,(select id from device_icon where icon_name='NetScreen Firewall'),now());
insert into symbol2deviceicon (symbolid,deviceicon_id,lasttimestamp) values (64,(select id from device_icon where icon_name='Extreme Switch'),now());
insert into symbol2deviceicon (symbolid,deviceicon_id,lasttimestamp) values (47,(select id from device_icon where icon_name='Unclassified Device'),now());
insert into symbol2deviceicon (symbolid,deviceicon_id,lasttimestamp) values (100,(select id from device_icon where icon_name='Mute LAN'),now());
insert into symbol2deviceicon (symbolid,deviceicon_id,lasttimestamp) values (55,(select id from device_icon where icon_name='Checkpoint Firewall'),now());
insert into symbol2deviceicon (symbolid,deviceicon_id,lasttimestamp) values (43,(select id from device_icon where icon_name='F5 Load Balancer'),now());
insert into symbol2deviceicon (symbolid,deviceicon_id,lasttimestamp) values (50,(select id from device_icon where icon_name='Unclassified Router'),now());
insert into symbol2deviceicon (symbolid,deviceicon_id,lasttimestamp) values (54,(select id from device_icon where icon_name='Unclassified Switch'),now());
insert into symbol2deviceicon (symbolid,deviceicon_id,lasttimestamp) values (57,(select id from device_icon where icon_name='CSS'),now());
insert into symbol2deviceicon (symbolid,deviceicon_id,lasttimestamp) values (49,(select id from device_icon where icon_name='Cache Engine'),now());
insert into symbol2deviceicon (symbolid,deviceicon_id,lasttimestamp) values (103,(select id from device_icon where icon_name='Unclassified Firewall'),now());
insert into symbol2deviceicon (symbolid,deviceicon_id,lasttimestamp) values (102,(select id from device_icon where icon_name='Unclassified Load Balancer'),now());
insert into symbol2deviceicon (symbolid,deviceicon_id,lasttimestamp) values (105,(select id from device_icon where icon_name='Unknown IP Device'),now());
insert into symbol2deviceicon (symbolid,deviceicon_id,lasttimestamp) values (123,(select id from device_icon where icon_name='3Com Switch'),now());
insert into symbol2deviceicon (symbolid,deviceicon_id,lasttimestamp) values (124,(select id from device_icon where icon_name='Cisco Nexus Switch'),now());
insert into symbol2deviceicon (symbolid,deviceicon_id,lasttimestamp) values (125,(select id from device_icon where icon_name='DMVPN'),now());
insert into symbol2deviceicon (symbolid,deviceicon_id,lasttimestamp) values (200,(select id from device_icon where icon_name='HP ProCurve Switch'),now());
insert into symbol2deviceicon (symbolid,deviceicon_id,lasttimestamp) values (201,(select id from device_icon where icon_name='Juniper EX Switch'),now());
insert into symbol2deviceicon (symbolid,deviceicon_id,lasttimestamp) values (106,(select id from device_icon where icon_name='Internet Wan'),now());
insert into symbol2deviceicon (symbolid,deviceicon_id,lasttimestamp) values (202,(select id from device_icon where icon_name='WLC'),now());
insert into symbol2deviceicon (symbolid,deviceicon_id,lasttimestamp) values (203,(select id from device_icon where icon_name='LWAP'),now());
insert into symbol2deviceicon (symbolid,deviceicon_id,lasttimestamp) values (204,(select id from device_icon where icon_name='Arista Switch'),now());
insert into symbol2deviceicon (symbolid,deviceicon_id,lasttimestamp) values (65,(select id from device_icon where icon_name='Brocade Switch'),now());
insert into symbol2deviceicon (symbolid,deviceicon_id,lasttimestamp) values (206,(select id from device_icon where icon_name='Force10 Switch'),now());



insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Juniper SRX Firewall'),3,1,'Juniper SRX Firewall.emf','af1b881617554bfvgrg4272b634574915.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Juniper SRX Firewall'),3,1,'Juniper SRX Firewall_CheckFail.emf','af1b881617554b4ghhdc272b634574915.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Juniper SRX Firewall'),3,1,'Juniper SRX Firewall_Down.emf','af1b881617554b448d1272b63455t455.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Juniper SRX Firewall'),3,1,'Juniper SRX Firewall_Unstable.emf','af1b856485fd554b448d1272b634574915.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Juniper SRX Firewall'),3,1,'Juniper SRX Firewall_Up.emf','a5f4d81617554b448d1272b634574915.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Cisco IOS XR'),3,1,'Cisco IOS XR.emf','0001affeb5cc433a97fbb956932649b6.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Cisco IOS XR'),3,1,'Cisco IOS XR_CheckFail.emf','0002affeb5cc433a97fbb956932649b6.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Cisco IOS XR'),3,1,'Cisco IOS XR_Down.emf','0003affeb5cc433a97fbb956932649b6.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Cisco IOS XR'),3,1,'Cisco IOS XR_Unstable.emf','0004affeb5cc433a97fbb956932649b6.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Cisco IOS XR'),3,1,'Cisco IOS XR_Up.emf','0005affeb5cc433a97fbb956932649b6.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Cisco Catalyst Switch'),3,1,'Cisco Catalyst Switch.emf','a91f61ab9ea249b2abbe1b4052dda363.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Cisco Catalyst Switch'),3,1,'Cisco Catalyst Switch_CheckFail.emf','fae9848ce0cd40089236b7f482327b85.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Cisco Catalyst Switch'),3,1,'Cisco Catalyst Switch_Down.emf','8c3d1ecb2a4e40038b01e012f556e73a.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Cisco Catalyst Switch'),3,1,'Cisco Catalyst Switch_Unstable.emf','5c987700bccc47c7b84a6612c75422f9.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Cisco Catalyst Switch'),3,1,'Cisco Catalyst Switch_Up.emf','dcb7a47fb0cd4c08bd27a0bf2796c2c9.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Cisco Router'),3,1,'Cisco Router.emf','15a626425e984efea7ba25a4a0deefd0.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Cisco Router'),3,1,'Cisco Router_CheckFail.emf','4c8ae85e3193468da881893dad5705ef.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Cisco Router'),3,1,'Cisco Router_Down.emf','ff5889ba8ebb40099e88e7fd12819828.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Cisco Router'),3,1,'Cisco Router_Unstable.emf','ff441694507a4187891479aa1ba20d55.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Cisco Router'),3,1,'Cisco Router_Up.emf','e6b63a0360474679b41e9577ba189cbb.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Cisco IOS Switch'),3,1,'Cisco IOS Switch.emf','ddb31a466b064f7da440d8006f7f3064.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Cisco IOS Switch'),3,1,'Cisco IOS Switch_CheckFail.emf','30451613f01042ca84563f755f207273.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Cisco IOS Switch'),3,1,'Cisco IOS Switch_Down.emf','82492a151bed4b8baf908596baad0e1c.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Cisco IOS Switch'),3,1,'Cisco IOS Switch_Unstable.emf','b8719f1176ba4f5e818176e1d0b0b3a3.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Cisco IOS Switch'),3,1,'Cisco IOS Switch_Up.emf','e80453a89a4e42d9a5b3d2a6c11b371c.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Cisco IOS Switch'),3,1,'L3 IOS Switch.emf','80e85d3645c9458c9eb9d86d1e4ab560.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Cisco IOS Switch'),3,1,'L3 IOS Switch_CheckFail.emf','e61fb68914824a8aa174c60aa066e124.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Cisco IOS Switch'),3,1,'L3 IOS Switch_Down.emf','b3159d8c14c741f3b506e2ffc4db5219.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Cisco IOS Switch'),3,1,'L3 IOS Switch_Unstable.emf','e5b63c452b35428d89f940c04c0700b6.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Cisco IOS Switch'),3,1,'L3 IOS Switch_Up.emf','148574c656e5413ba8dc5bd8d1180d68.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Cisco PIX Firewall'),3,1,'Cisco PIX Firewall.emf','28c0cfdd5f6b4e8d81d6bfc589e9e37c.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Cisco PIX Firewall'),3,1,'Cisco PIX Firewall_CheckFail.emf','21257c8bf0ce42898b573290c33d5ab1.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Cisco PIX Firewall'),3,1,'Cisco PIX Firewall_Down.emf','ddb85a42cc0c408e88011d4557627e3d.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Cisco PIX Firewall'),3,1,'Cisco PIX Firewall_Unstable.emf','5708956704b64e42a55ce8f3c0c1e736.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Cisco PIX Firewall'),3,1,'Cisco PIX Firewall_Up.emf','02f2f1234be5448f9bafea854c6c7a4e.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='End System'),3,1,'End System.emf','ae549136b3fa45d7bf1aeab5cd405afa.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='End System'),3,1,'End System_CheckFail.emf','0f057537df5f4cc1be60e00f4dd9eb2f.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='End System'),3,1,'End System_Down.emf','cd1e4e2a5c3a417aa0bff632b0344b8c.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='End System'),3,1,'End System_Unstable.emf','97fb910ba09c49b0809ea1036e4656a4.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='End System'),3,1,'End System_Up.emf','b670bb4c99e94b6db6dd72da5f245786.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='LAN'),3,1,'LAN.emf','be99352194694462ab27c2b4d24d17ae.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='LAN'),3,1,'LAN_CheckFail.emf','bfee7c25335e406ca62fcd74a0426c4e.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='WAN'),3,1,'WAN.emf','4c0d6963583c4314b1c4840bc003e9d6.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='WAN'),3,1,'WAN_CheckFail.emf','3c669e9a699c4ae4a2cbb08dee52ada5.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='MPLS Cloud'),3,1,'MPLS Cloud.emf','2efc1da7de8c4eafa9d30c7061f3dc5d.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='MPLS Cloud'),3,1,'MPLS Cloud_CheckFail.emf','ae69ac7224ec4a6eab2c785396887887.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='MPLS Cloud'),3,1,'MPLS Cloud_Down.emf','0b7f990267cb4e71bb2e8ee1fddc498f.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='MPLS Cloud'),3,1,'MPLS Cloud_Unstable.emf','cce02cf16ec54608877b68e9dbef550a.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='MPLS Cloud'),3,1,'MPLS Cloud_Up.emf','897b2bcbb5bb4bb99d005aacb6f351a0.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Call Manager'),3,1,'Call Manager.emf','2ae6dad917394fdaa4d3834bd9bd9866.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Call Manager'),3,1,'Call Manager_CheckFail.emf','dd8430e166874c7a85f84f655f106437.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Call Manager'),3,1,'Call Manager_Down.emf','1ebdcd245f6648c7aa31c5bc22373240.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Call Manager'),3,1,'Call Manager_Unstable.emf','d7edeb84cf7547718da3ede4798952c2.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Call Manager'),3,1,'Call Manager_Up.emf','59f8a9f2d0ef477b857cbbd80ad3eaf9.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='IP Phone'),3,1,'IP Phone.emf','ec7205f600004a99931fbc80c2c0132e.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='IP Phone'),3,1,'IP Phone_CheckFail.emf','497a8b0bd02f48bdb939518d7fcc0ad0.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='IP Phone'),3,1,'IP Phone_Down.emf','5986e93d89164b538f2513a4eed4fb7d.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='IP Phone'),3,1,'IP Phone_Unstable.emf','3ccb33210b504650a601462221cd9583.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='IP Phone'),3,1,'IP Phone_Up.emf','c45e38abc05a409fbc7322d6410a0a58.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Cisco WAP'),3,1,'Cisco WAP.emf','af1b881617554b448d1272b634574915.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Cisco WAP'),3,1,'Cisco WAP_CheckFail.emf','4550326cae1f4728a8932d391595799f.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Cisco WAP'),3,1,'Cisco WAP_Down.emf','15906a5f2afc4d2eb023b308950ac3b5.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Cisco WAP'),3,1,'Cisco WAP_Unstable.emf','e0b015d3c4b44f7aa9387a6935d048e3.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Cisco WAP'),3,1,'Cisco WAP_Up.emf','6505a94b51244e85a9b6dde546bde8ad.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Cisco ASA Firewall'),3,1,'Cisco ASA Firewall.emf','f8ae34b6bed148e586aecac92148af69.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Cisco ASA Firewall'),3,1,'Cisco ASA Firewall_CheckFail.emf','b104e25461d24886baf026ecf3f924ad.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Cisco ASA Firewall'),3,1,'Cisco ASA Firewall_Down.emf','30323c40a3d346b4ba2b3a0e44c6f9ed.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Cisco ASA Firewall'),3,1,'Cisco ASA Firewall_Unstable.emf','ab75d9c50a464fa091f7bc419a09fab8.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Cisco ASA Firewall'),3,1,'Cisco ASA Firewall_Up.emf','d591b66b06634b6cb90cb1210717d84e.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Juniper Router'),3,1,'Juniper Router.emf','bad8de4f152247fd9fd635f155252d58.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Juniper Router'),3,1,'Juniper Router_CheckFail.emf','9386cbc18e0948d78909db5541ef94ec.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Juniper Router'),3,1,'Juniper Router_Down.emf','c2d24a9c2615488a9738b73d616681a9.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Juniper Router'),3,1,'Juniper Router_Unstable.emf','4f413236fdbf4d978cfd8ec20a96de38.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Juniper Router'),3,1,'Juniper Router_Up.emf','6e6a8d733fda4b97a4a927beacc25c31.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='NetScreen Firewall'),3,1,'NetScreen Firewall.emf','74bdf71fbe1f4be8a7fde4f841815805.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='NetScreen Firewall'),3,1,'NetScreen Firewall_CheckFail.emf','3f12dd96b3fd40189e59ef1a4d8d8618.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='NetScreen Firewall'),3,1,'NetScreen Firewall_Down.emf','6e076e1fb0944deeaccd638ec4230ae3.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='NetScreen Firewall'),3,1,'NetScreen Firewall_Unstable.emf','dd5e1bdebeae4d42870e5ef5cd0be5ac.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='NetScreen Firewall'),3,1,'NetScreen Firewall_Up.emf','5836b049256541f28c7a6c19a69dec60.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Extreme Switch'),3,1,'Extreme Switch.emf','e489a8276e9e45d995841cd9f3e80388.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Extreme Switch'),3,1,'Extreme Switch_CheckFail.emf','d8fb3b45888644768200158c8776659a.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Extreme Switch'),3,1,'Extreme Switch_Down.emf','223a2dd8920c4bfab8ac45250f45f585.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Extreme Switch'),3,1,'Extreme Switch_Unstable.emf','e67157432db543aa88d8e8baa801ffaf.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Extreme Switch'),3,1,'Extreme Switch_Up.emf','4da6703adb284f10b8d4d20d8044e06b.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Unclassified Device'),3,1,'Unclassified Device.emf','35ace9b2bfdd486fa1ab8e57699a58d5.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Unclassified Device'),3,1,'Unclassified Device_CheckFail.emf','89a2b950b7f84a818e7d6662dcc7da07.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Unclassified Device'),3,1,'Unclassified Device_Down.emf','35d3aa24f2c5473cbd41ee1b555cd4c9.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Unclassified Device'),3,1,'Unclassified Device_Unstable.emf','9d3d98d29f6e4b67b93116506dc9cbd9.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Unclassified Device'),3,1,'Unclassified Device_Up.emf','6752c8685070405ca9ef9cc85f36453f.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Mute LAN'),3,1,'Mute LAN.emf','fd751b9fb4f944df853abc1a33535c3b.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Mute LAN'),3,1,'Mute LAN_CheckFail.emf','b7ea37c551ac4e25b1c4c61040f90254.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Checkpoint Firewall'),3,1,'Checkpoint Firewall.emf','30539aab3cf249909f75ef644672b309.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Checkpoint Firewall'),3,1,'Checkpoint Firewall_CheckFail.emf','d7b3880a50fe4997b86820a42f175ba5.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Checkpoint Firewall'),3,1,'Checkpoint Firewall_Down.emf','587b72dd35c847c684ba61e58c7ab54b.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Checkpoint Firewall'),3,1,'Checkpoint Firewall_Unstable.emf','36caf8aabb014601b0bbfa7d3789cfa0.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Checkpoint Firewall'),3,1,'Checkpoint Firewall_Up.emf','180d8cf934f04dcbaca588a4751684f3.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='F5 Load Balancer'),3,1,'F5 Load Balancer.emf','61dc612a08dd4b9e9fc90c03da9378a0.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='F5 Load Balancer'),3,1,'F5 Load Balancer_CheckFail.emf','776c970626fc4a2abd02ef5213120158.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='F5 Load Balancer'),3,1,'F5 Load Balancer_Down.emf','5db5afef440a4821b8384c54eb554a57.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='F5 Load Balancer'),3,1,'F5 Load Balancer_Unstable.emf','c91dbb30134e46db8f605da3a1173f3f.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='F5 Load Balancer'),3,1,'F5 Load Balancer_Up.emf','a9b110434193484ea388452ad2ba7370.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Unclassified Router'),3,1,'Unclassified Router.emf','aaecf83c1c144a5eb282c82aeb5974d5.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Unclassified Router'),3,1,'Unclassified Router_CheckFail.emf','40608dafd4aa47bb8af4ef26690cc628.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Unclassified Router'),3,1,'Unclassified Router_Down.emf','f74eca7599a345bf87594eccb25ba071.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Unclassified Router'),3,1,'Unclassified Router_Unstable.emf','0991affeb5cc433a97fbb956932649b6.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Unclassified Router'),3,1,'Unclassified Router_Up.emf','84c8632f34cd4d86a84adf67fc7b9007.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Unclassified Switch'),3,1,'Unclassified Switch.emf','b73b21d8e0804fde99dc95f9d8180af1.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Unclassified Switch'),3,1,'Unclassified Switch_CheckFail.emf','71374840bd504ffdb074b9ece4a9b3c0.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Unclassified Switch'),3,1,'Unclassified Switch_Down.emf','64bcb77b97264ad5aaa8d66c8d1bdbc7.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Unclassified Switch'),3,1,'Unclassified Switch_Unstable.emf','5238574584af4973a5c018218708ee53.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Unclassified Switch'),3,1,'Unclassified Switch_Up.emf','129fa603c7824d94923bfde4f044dbca.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='CSS'),3,1,'CSS.emf','1f2eb3c19a264f75845ed7ff36a7a5e9.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='CSS'),3,1,'CSS_CheckFail.emf','b71a71e1bdc1439281751d4ac4003140.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='CSS'),3,1,'CSS_Down.emf','2d58db02217c496d94c5ae6444d2ff7f.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='CSS'),3,1,'CSS_Unstable.emf','0de06a550b404bda93f2b42df31e7589.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='CSS'),3,1,'CSS_Up.emf','ccbffece01a3436cb4d9db115b620905.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Cache Engine'),3,1,'Cache Engine.emf','826adeee91564f22a90fc333b2ba91c8.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Cache Engine'),3,1,'Cache Engine_CheckFail.emf','adb9691be3d04074966d3f4284feae53.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Cache Engine'),3,1,'Cache Engine_Down.emf','d07a7f75dd1243d6b61014d9dfd28962.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Cache Engine'),3,1,'Cache Engine_Unstable.emf','dba392dddd2b4deab6daf47e86d1b263.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Cache Engine'),3,1,'Cache Engine_Up.emf','401712fdf072471faf07c658aac729ec.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Unclassified Firewall'),3,1,'Unclassified Firewall.emf','4e59bead25684ae59edec0984d943c71.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Unclassified Firewall'),3,1,'Unclassified Firewall_CheckFail.emf','235ab381477249f5b2fefc46990a3997.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Unclassified Firewall'),3,1,'Unclassified Firewall_Down.emf','9eadb5c127aa458e83d71c7f5cf8d592.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Unclassified Firewall'),3,1,'Unclassified Firewall_Unstable.emf','6fa6f335427346f08e3764c870452217.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Unclassified Firewall'),3,1,'Unclassified Firewall_Up.emf','12f550bf11cb4a548b88375cd202c671.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Unclassified Load Balancer'),3,1,'Unclassified Load Balancer.emf','8968a5ac8c4542ad86d0f842059ff590.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Unclassified Load Balancer'),3,1,'Unclassified Load Balancer_CheckFail.emf','6af1bacf0ddf4045857666e584f2d8cc.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Unclassified Load Balancer'),3,1,'Unclassified Load Balancer_Down.emf','90f2cb500d7840898976ad96c089dad8.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Unclassified Load Balancer'),3,1,'Unclassified Load Balancer_Unstable.emf','6e9d6d64add4455b9da5e2a2d45780dc.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Unclassified Load Balancer'),3,1,'Unclassified Load Balancer_Up.emf','e1583410fb614de7a82197334d47adc9.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Unknown IP Device'),3,1,'Unknown IP Device.emf','d986bb7e1f9c47ef9716796ff1ed6ef8.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Unknown IP Device'),3,1,'Unknown IP Device_CheckFail.emf','64677d2094d4439e8f2001c9454ecfe4.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='3Com Switch'),3,1,'3Com Switch.emf','412212ba05444bf4bf215d81d1c94d25.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='3Com Switch'),3,1,'3Com Switch_CheckFail.emf','722ce8f057bf4cb99bcc6576ae196bc7.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='3Com Switch'),3,1,'3Com Switch_Down.emf','5fec8ca35b67405fa4b7c0310c915721.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='3Com Switch'),3,1,'3Com Switch_Unstable.emf','bfeeeb10f62c46c8a27704af5a6356f3.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='3Com Switch'),3,1,'3Com Switch_Up.emf','996f152125be454aa4e318b519721984.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Cisco Nexus Switch'),3,1,'Cisco Nexus Switch.emf','84fb278479fe42b0832b72a8d7a341d9.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Cisco Nexus Switch'),3,1,'Cisco Nexus Switch_CheckFail.emf','d46b6037752c450ba307805c0d530a29.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Cisco Nexus Switch'),3,1,'Cisco Nexus Switch_Down.emf','107505aee392451c9913bb43c34f1bb9.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Cisco Nexus Switch'),3,1,'Cisco Nexus Switch_Unstable.emf','0ce1100f01424bea942abc008c750c43.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Cisco Nexus Switch'),3,1,'Cisco Nexus Switch_Up.emf','5348d95259ea45d1b9bd4cf33ed0ee06.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='DMVPN'),3,1,'DMVPN.emf','c054a25e938a404199955cc7386874a4.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='DMVPN'),3,1,'DMVPN_CheckFail.emf','64aeb416704144aca8c1f80d4d849e44.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='HP ProCurve Switch'),3,1,'HP ProCurve Switch.emf','28970ac3bde24807ab438f7c0ce992cd.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='HP ProCurve Switch'),3,1,'HP ProCurve Switch_CheckFail.emf','1d2ba8f36d5043c396e3194b53995074.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='HP ProCurve Switch'),3,1,'HP ProCurve Switch_Down.emf','a731e9d5a3754c1999df869e0bda11a4.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='HP ProCurve Switch'),3,1,'HP ProCurve Switch_Unstable.emf','767598e885044626a51a0a00263b5d57.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='HP ProCurve Switch'),3,1,'HP ProCurve Switch_Up.emf','6c8dfac53e8b40568bb548607f49ac5a.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Juniper EX Switch'),3,1,'Juniper EX Switch.emf','1f9d28ec1b594c9dbc8c3aa8a91a19db.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Juniper EX Switch'),3,1,'Juniper EX Switch_CheckFail.emf','3ed3af5796d14e299bbf32535f1adb34.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Juniper EX Switch'),3,1,'Juniper EX Switch_Down.emf','cc123341240f409dae2eb54b5d079729.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Juniper EX Switch'),3,1,'Juniper EX Switch_Unstable.emf','a334ee5f239b45e8b4a66ce3d4d2543d.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Juniper EX Switch'),3,1,'Juniper EX Switch_Up.emf','aaf21195d01f4b09b6bc230c8632cf0f.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Internet Wan'),3,1,'Internet Wan.emf','3834f136017b47ab81fa3237f6496228.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Internet Wan'),3,1,'Internet Wan_CheckFail.emf','fe3fd52da8f84d4c883cfff7513e6eaa.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='WLC'),3,1,'WLC.emf','bd984768efe1425c85f73649d54a1b38.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='WLC'),3,1,'WLC_CheckFail.emf','4fa7cc174b9447aba4db80ae2bedc35c.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='WLC'),3,1,'WLC_Down.emf','8c8ac941459a493bb101b3a1aa59487d.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='WLC'),3,1,'WLC_Unstable.emf','549134f3f7af44abaa4fa63f036ee026.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='WLC'),3,1,'WLC_Up.emf','c5cb596ee9d647178b61d23752cc0a56.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='LWAP'),3,1,'LWAP.emf','6a9c79d38a31412daa1f524625e46f77.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='LWAP'),3,1,'LWAP_CheckFail.emf','a46a85eddec74df887c99bc3abdf9afd.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='LWAP'),3,1,'LWAP_Down.emf','610300a23ccb432aa6b8428316ae09eb.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='LWAP'),3,1,'LWAP_Unstable.emf','75ff4e5fc37d472c829cbc6dac06528d.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='LWAP'),3,1,'LWAP_Up.emf','7539ea32e27743fbb92368dc05d38c7a.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Arista Switch'),3,1,'Arista Switch.emf','ae8a9afcf5ed4e9eaf6da29262eeaf94.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Arista Switch'),3,1,'Arista Switch_CheckFail.emf','e8b313117cf846889c4e6e73e7cd4dd6.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Arista Switch'),3,1,'Arista Switch_Down.emf','a970eb6e76aa4648b6703c3fd52c46d8.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Arista Switch'),3,1,'Arista Switch_Unstable.emf','36085b18d7c9476bbc5e529189a54281.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Arista Switch'),3,1,'Arista Switch_Up.emf','6ee02973440047c3a36170f3fd125be4.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Brocade Switch'),3,1,'Brocade Switch.emf','210a1cc0bbbb42f1a7acf921404b6af4.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Brocade Switch'),3,1,'Brocade Switch_CheckFail.emf','99e58ca72eee4c8a9d345bc3e8e354f0.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Brocade Switch'),3,1,'Brocade Switch_Down.emf','f9c322d751b741618280f5ca6a95e3d2.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Brocade Switch'),3,1,'Brocade Switch_Unstable.emf','22a73d3dfd204fa2918ddd47b34de3dc.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Brocade Switch'),3,1,'Brocade Switch_Up.emf','52623eecd12d4f6ba7d6c1b1b56c60b4.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Force10 Switch'),3,1,'Force10 Switch.emf','274f73a442aa4c46a989250b003d5ac4.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Force10 Switch'),3,1,'Force10 Switch_CheckFail.emf','bc3d35124fe346cab2a9984556a0ac78.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Force10 Switch'),3,1,'Force10 Switch_Down.emf','efef55a7c6cc43d18f3556cfc5f8f3e2.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Force10 Switch'),3,1,'Force10 Switch_Unstable.emf','4fb0e2a2288b4276be78c8f51f424fbf.emf',now(),1,'',now(),null);
insert into object_file_info (object_id,object_type,file_type,file_real_name,file_save_name,file_update_time,file_update_userid,user_property,lasttimestamp,path_id) values ((select id from device_icon where icon_name='Force10 Switch'),3,1,'Force10 Switch_Up.emf','f4eba4eaf0bd47b19ae0e71dd8083872.emf',now(),1,'',now(),null);


update "user" set offline_minutes=120 where strname='admin';

insert into objtimestamp (typename,modifytime,userid) values ('Visio','1900-01-01 00:00:00',-1);


CREATE OR REPLACE FUNCTION donotscan_delete(subnets character varying[])
  RETURNS boolean AS
$BODY$

BEGIN
	delete from donotscan where subnetmask = any(subnets);	
	return true;
EXCEPTION    
	WHEN OTHERS THEN   
		return false;		
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION donotscan_delete(character varying[]) OWNER TO postgres;


CREATE OR REPLACE FUNCTION view_deviceiconview_retrieve2(symbols integer[], dt timestamp without time zone)
  RETURNS SETOF deviceiconview AS
$BODY$
declare	
	r deviceiconview%rowtype;
	t timestamp without time zone;
BEGIN
	if array_length( symbols, 1 ) = 1 and symbols[1]=-1 then
		for r in  select * from deviceiconview where lasttimestamp>dt loop				
			return next r;								
		end loop;
	else
		for r in  select * from deviceiconview where symbolid = any (symbols) and lasttimestamp>dt loop				
			return next r;								
		end loop;
	end if;
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION view_deviceiconview_retrieve2(integer[], timestamp without time zone) OWNER TO postgres;


insert into object_customized_attribute ( objectid, "name", alias, allow_export, "type", allow_modify_exported ) values( 1, 'driver', 'Driver', false, 1, false );


DROP FUNCTION view_showcommandtemplate_retrieve(integer, integer, timestamp without time zone, character varying);

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
			for r in  select * from showcommandtemplate where id >ibegin order by id loop				
				return next r;								
			end loop;
		else
			for r in select * from showcommandtemplate where id >ibegin order by id limit imax loop				
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

DELETE FROM system_devicespec;


CREATE OR REPLACE FUNCTION system_vendormodel_update2(vm system_vendormodel)
  RETURNS boolean AS
$BODY$
declare
	vm_id integer;	
	r discover_unknowdevice%rowtype;
BEGIN
	select id into vm_id from system_vendormodel where stroid=vm.stroid;

	if vm_id IS NULL THEN
		insert into system_vendormodel(	
			stroid, idevicetype, strvendorname, strmodelname, bmodified, strdriverid, strcpuoid, strmemoid, autoupdate 
		)
		values( 
			vm.stroid, vm.idevicetype, vm.strvendorname, vm.strmodelname, vm.bmodified, vm.strdriverid, vm.strcpuoid, vm.strmemoid, vm.autoupdate 	
		);	

		for r in SELECT * FROM discover_unknowdevice where sysobjectid = vm.stroid loop
			INSERT INTO unknownip(nexthopip, edgedevice, edgeintf, ipfrom, ipmask, intfdesc, findtime, collectsource, description, itype)VALUES (r.mgrip, '', '', '', '', '', r.findtime, 0, '', r.devtype);
		end loop;					

		delete from discover_unknowdevice where sysobjectid = vm.stroid;
	else
		update system_vendormodel set(
			idevicetype,
			strvendorname,
			strmodelname,
			bmodified,
			strdriverid,
			strcpuoid,
			strmemoid,
			autoupdate
		) = ( 
			vm.idevicetype,  
			vm.strvendorname,
			vm.strmodelname,
			vm.bmodified,
			vm.strdriverid,
			vm.strcpuoid,
			vm.strmemoid,
			vm.autoupdate
		) where id = vm_id;				
	end if;	
	
	return true;
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION system_vendormodel_update2(system_vendormodel) OWNER TO postgres;

CREATE OR REPLACE FUNCTION discoverymisdevice_delete(hostname character varying[])
  RETURNS boolean AS
$BODY$

BEGIN
	delete from discover_missdevice where deviceid = any(select id from devices where strname= any(hostname));	
	return true;
EXCEPTION    
	WHEN OTHERS THEN   
		return false;		
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION discoverymisdevice_delete(character varying[]) OWNER TO postgres;

delete from system_devicespec;


-- Function: ip_2_mac_upsert(ip2mac)

-- DROP FUNCTION ip_2_mac_upsert(ip2mac);

CREATE OR REPLACE FUNCTION ip_2_mac_upsert(r ip2mac, onlymac integer, subtypes integer[] )
  RETURNS integer AS
$BODY$
declare
	ds_id integer;
BEGIN
        if onlymac = 0 then
		select id into ds_id from ip2mac where ip=r.ip AND mac=r.mac;

		if ds_id IS NULL THEN
			insert into ip2mac(
				  alias,
				  lan,
				  gateway,
				  ip,
				  mac,
				  devicename,
				  interfacename,
				  switchname,
				  portname,
				  vlan,
				  userflag,
				  servertype,
				  retrievedate
			)
			values( 
				  r.alias,
				  r.lan,
				  r.gateway,
				  r.ip,
				  r.mac,
				  r.devicename,
				  r.interfacename,
				  r.switchname,
				  r.portname,
				  r.vlan,
				  r.userflag,
				  r.servertype,
				  now()
			);
			return lastval();
		else
			update ip2mac set(
				  alias,
				  lan,
				  gateway,
				  ip,
				  devicename,
				  interfacename,
				  switchname,
				  portname,
				  vlan,
				  userflag,
				  servertype,
				  retrievedate
			) = ( 
				  r.alias,
				  r.lan,
				  r.gateway,
				  r.ip,
				  r.devicename,
				  r.interfacename,
				  r.switchname,
				  r.portname,
				  r.vlan,
				  r.userflag,
				  r.servertype,
				  now()
			) 
			where id = ds_id;
			return ds_id;
		end if;
	else
		delete from ip2mac where mac=r.mac and servertype =any(subtypes);
		insert into ip2mac(
				  alias,
				  lan,
				  gateway,
				  ip,
				  mac,
				  devicename,
				  interfacename,
				  switchname,
				  portname,
				  vlan,
				  userflag,
				  servertype,
				  retrievedate
			)
			values( 
				  r.alias,
				  r.lan,
				  r.gateway,
				  r.ip,
				  r.mac,
				  r.devicename,
				  r.interfacename,
				  r.switchname,
				  r.portname,
				  r.vlan,
				  r.userflag,
				  r.servertype,
				  now()
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
ALTER FUNCTION ip_2_mac_upsert(ip2mac, integer,integer[]) OWNER TO postgres;


DROP FUNCTION view_nomp_telnetinfo_retrieve(timestamp without time zone, character varying, integer, character varying);
DROP VIEW nomp_telnetinfoview;

ALTER TABLE nomp_telnetinfo ALTER COLUMN strusername type character varying(256);
ALTER TABLE nomp_telnetinfo ALTER COLUMN strpasswd type character varying(256);

CREATE OR REPLACE VIEW nomp_telnetinfoview AS 
 SELECT nomp_telnetinfo.id, nomp_telnetinfo.stralias, nomp_telnetinfo.idevicetype, nomp_telnetinfo.strusername, nomp_telnetinfo.strpasswd, nomp_telnetinfo.bmodified, nomp_telnetinfo.userid, nomp_telnetinfo.ipri, nomp_telnetinfo.id AS irefcount
   FROM nomp_telnetinfo
  ORDER BY nomp_telnetinfo.ipri;

ALTER TABLE nomp_telnetinfoview OWNER TO postgres;

CREATE OR REPLACE FUNCTION view_nomp_telnetinfo_retrieve(dt timestamp without time zone, stypename character varying, uid integer, funcname character varying)
  RETURNS SETOF nomp_telnetinfoview AS
$BODY$
declare
	r nomp_telnetinfoview%rowtype;
	t timestamp without time zone;
	ispublic integer;
BEGIN		
	select c.count into ispublic from (select count(a.id) as count from (select user2role.roleid as id from "user",user2role where "user".id=uid and "user".id =user2role.userid) as a where a.id in (select role2function.roleid as id from role2function,"function" where "function".sidname=funcname and "function".id=role2function.functionid)) as c;
        select modifytime into t from objtimestamp where typename=stypename;
	if t is null or t>dt then
		for r in SELECT * FROM nomp_telnetinfoview where userid=uid loop
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
ALTER FUNCTION view_nomp_telnetinfo_retrieve(timestamp without time zone, character varying, integer, character varying) OWNER TO postgres;


ALTER TABLE sys_environmentvariable ALTER COLUMN variable type character varying(256);
ALTER TABLE sys_environmentvariable ALTER COLUMN "value" type character varying(256);


update system_info set ver=417;