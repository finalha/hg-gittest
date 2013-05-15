\connect "nbws"

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;


------------- trigger start -------------
DROP TRIGGER devicegroup_dt ON devicegroup;
DROP FUNCTION process_devicegroup_dt();
DROP TRIGGER devicegroupdevice_dt ON devicegroupdevice;
DROP FUNCTION process_devicegroupdevice_dt();
------------- trigger end -------------

------------- function start -------------
DROP FUNCTION devicegroup_upsert(devicegroup);
DROP FUNCTION devicegroupnameexists(character varying, integer, integer);
DROP FUNCTION view_devicegroup_retrieve(integer, integer, timestamp without time zone, integer, character varying);
DROP FUNCTION view_devicegroupdevicegroupview_retrieve(integer, integer, timestamp without time zone, integer, character varying);
DROP FUNCTION view_devicegroupdeviceview_retrieve(integer, integer, timestamp without time zone, integer, character varying);
DROP FUNCTION view_devicegroupsiteview_retrieve(integer, integer, timestamp without time zone, integer, character varying);
DROP FUNCTION view_devicegroupsystemdevicegroupview_retrieve(integer, integer, timestamp without time zone, integer, character varying);
------------- function end -------------

------------- view start -------------
DROP VIEW devicegroupview;
------------- view end -------------


------------- add column -------------
ALTER TABLE devicegroup ADD COLUMN licguid character varying(128);
ALTER TABLE devicegroup ALTER COLUMN licguid SET STORAGE EXTENDED;
update devicegroup set licguid='-1' where userid=-1;
update devicegroup set licguid=:licguid where userid<>-1;
------------- add column -------------


------------- view start -------------
CREATE OR REPLACE VIEW devicegroupview AS 
 SELECT devicegroup.id, devicegroup.strname, devicegroup.strdesc, devicegroup.userid, devicegroup.showcolor, ( SELECT count(*) AS count
           FROM ( SELECT DISTINCT devicegroupdevice.devicegroupid, devicegroupdevice.deviceid
                   FROM devicegroupdevice) uniqdevicegroupdevice
          WHERE uniqdevicegroupdevice.devicegroupid = devicegroup.id) AS irefcount, devicegroup.searchcondition, devicegroup.searchcontainer, devicegroup.licguid
   FROM devicegroup
  ORDER BY devicegroup.id;

ALTER TABLE devicegroupview OWNER TO postgres;
------------- view end -------------


------------- trigger start -------------
CREATE OR REPLACE FUNCTION process_devicegroup_dt()
  RETURNS trigger AS
$BODY$
declare tid integer;
declare uid integer;
declare iguid character varying;
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.strname = NEW.strname AND 
			OLD.strdesc = NEW.strdesc AND
			OLD.userid = NEW.userid AND			
			OLD.showcolor = NEW.showcolor AND
			OLD.searchcondition= NEW.searchcondition AND
			OLD.searchcontainer = NEW.searchcontainer AND
			OLD.licguid=NEW.licguid
		then
			return OLD;
		end IF;

		if(DeviceGroupNameExists(New.strname,NEW.id,New.userid,NEW.licguid)=true) then
			RAISE EXCEPTION 'name exists';
		end if;

		if not (NEW.userid=OLD.userid and NEW.licguid=OLD.licguid) then
			update objtimestamp set modifytime=now() where typename='PublicDeviceGroup';
			if new.userid=-1 then
				iguid=old.licguid;
				uid=old.userid;
			else 
				iguid=new.licguid;
				uid=new.userid;
			end if;
			select id into tid from objprivatetimestamp where typename='PrivateDeviceGroup' and userid=uid and licguid=iguid;
			if tid is null then
				insert into objprivatetimestamp (typename,userid,modifytime,licguid) values('PrivateDeviceGroup',uid,now(),iguid);
			else
				update objprivatetimestamp set modifytime=now() where typename='PrivateDeviceGroup' and userid=uid and licguid=iguid;
			end if;	
		elseif NEW.userid=-1 then
			update objtimestamp set modifytime=now() where typename='PublicDeviceGroup';
		else
			select id into tid from objprivatetimestamp where typename='PrivateDeviceGroup' and userid=new.userid and licguid=NEW.licguid;
			if tid is null then
				insert into objprivatetimestamp (typename,userid,modifytime,licguid) values('PrivateDeviceGroup',new.userid,now(),NEW.licguid);
			else
				update objprivatetimestamp set modifytime=now() where typename='PrivateDeviceGroup' and userid=new.userid and licguid=NEW.licguid;
			end if;	
		end if;		
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		if(DeviceGroupNameExists(New.strname,0,New.userid,NEW.licguid)=true) then
			RAISE EXCEPTION 'name exists';
		end if;
		if NEW.userid=-1 then
			update objtimestamp set modifytime=now() where typename='PublicDeviceGroup';
		else
			select id into tid from objprivatetimestamp where typename='PrivateDeviceGroup' and userid=new.userid and licguid=NEW.licguid;
			if tid is null then
				insert into objprivatetimestamp (typename,userid,modifytime,licguid) values('PrivateDeviceGroup',new.userid,now(),NEW.licguid);
			else
				update objprivatetimestamp set modifytime=now() where typename='PrivateDeviceGroup' and userid=new.userid and licguid=NEW.licguid;
			end if;	
		end if;	
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		if OLD.userid=-1 then
			update objtimestamp set modifytime=now() where typename='PublicDeviceGroup';
		else
				select id into tid from objprivatetimestamp where typename='PrivateDeviceGroup' and userid=OLD.userid and licguid=OLD.licguid;
				if tid is null then
					insert into objprivatetimestamp (typename,userid,modifytime,licguid) values('PrivateDeviceGroup',old.userid,now(),old.licguid);
				else
					update objprivatetimestamp set modifytime=now() where typename='PrivateDeviceGroup' and userid=old.userid and licguid=OLD.licguid;
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


CREATE TRIGGER devicegroup_dt
  BEFORE INSERT OR UPDATE OR DELETE
  ON devicegroup
  FOR EACH ROW
  EXECUTE PROCEDURE process_devicegroup_dt();


CREATE OR REPLACE FUNCTION process_devicegroupdevice_dt()
  RETURNS trigger AS
$BODY$
declare tid integer;
declare uid integer;
DECLARE newuserid integer;
DECLARE olduserid integer;
DECLARE newguid character varying;
DECLARE oldguid character varying;
DECLARE iguid character varying;
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
		select licguid into newguid from devicegroup where id=NEW.devicegroupid;
		select licguid into oldguid from devicegroup where id=old.devicegroupid;

		if not (newuserid=olduserid and newguid=oldguid) then
			update objtimestamp set modifytime=now() where typename='PublicDeviceGroup';
			if newuserid=-1 then
				iguid=oldguid;
				uid=olduserid;
			else 
				iguid=newguid;
				uid=newuserid;
			end if;
			select id into tid from objprivatetimestamp where typename='PrivateDeviceGroup' and userid=uid and licguid=iguid;
			if tid is null then
				insert into objprivatetimestamp (typename,userid,modifytime,licguid) values('PrivateDeviceGroup',uid,now(),iguid);
			else
				update objprivatetimestamp set modifytime=now() where typename='PrivateDeviceGroup' and userid=uid and licguid=iguid;
			end if;
		elseif newuserid=-1 then
			update objtimestamp set modifytime=now() where typename='PublicDeviceGroup';
		else
			select licguid into iguid from devicegroup where id=NEW.devicegroupid;
			select id into tid from objprivatetimestamp where typename='PrivateDeviceGroup' and userid=newuserid and licguid=newguid;
			if tid is null then
				insert into objprivatetimestamp (typename,userid,modifytime,licguid) values('PrivateDeviceGroup',newuserid,now(),newguid);
			else
				update objprivatetimestamp set modifytime=now() where typename='PrivateDeviceGroup' and userid=newuserid and licguid=newguid;
			end if;	
		end if;		
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		select userid into newuserid from devicegroup where id=NEW.devicegroupid;
		if newuserid=-1 then
			update objtimestamp set modifytime=now() where typename='PublicDeviceGroup';
		else
			select licguid into iguid from devicegroup where id=NEW.devicegroupid;
			select id into tid from objprivatetimestamp where typename='PrivateDeviceGroup' and userid=newuserid and licguid=iguid;
			if tid is null then
				insert into objprivatetimestamp (typename,userid,modifytime,licguid) values('PrivateDeviceGroup',newuserid,now(),iguid);
			else
				update objprivatetimestamp set modifytime=now() where typename='PrivateDeviceGroup' and userid=newuserid and licguid=iguid;
			end if;	
		end if;		
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		select userid into olduserid from devicegroup where id=old.devicegroupid;		
		if not olduserid is null then
			if olduserid=-1 then
				update objtimestamp set modifytime=now() where typename='PublicDeviceGroup';
			else
				select licguid into iguid from devicegroup where id=old.devicegroupid;		
				select id into tid from objprivatetimestamp where typename='PrivateDeviceGroup' and userid=olduserid and licguid=iguid;
				if tid is null then
					insert into objprivatetimestamp (typename,userid,modifytime,licguid) values('PrivateDeviceGroup',olduserid,now(),iguid);
				else
					update objprivatetimestamp set modifytime=now() where typename='PrivateDeviceGroup' and userid=olduserid and licguid=iguid;
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


CREATE TRIGGER devicegroupdevice_dt
  BEFORE INSERT OR UPDATE OR DELETE
  ON devicegroupdevice
  FOR EACH ROW
  EXECUTE PROCEDURE process_devicegroupdevice_dt();

------------- trigger end -------------


------------- function start -------------
CREATE OR REPLACE FUNCTION devicegroupnameexists(sname character varying, nid integer, uid integer, guid character varying)
  RETURNS boolean AS
$BODY$
BEGIN
	if((select count(*) from devicegroup where id<>nid and lower(strname) =lower(sname) and userid=uid and licguid=guid)=0) then
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
ALTER FUNCTION devicegroupnameexists(character varying, integer, integer, character varying) OWNER TO postgres;


CREATE OR REPLACE FUNCTION devicegroup_upsert(vm devicegroup)
  RETURNS integer AS
$BODY$
declare
	vm_id integer;
BEGIN
	select id into vm_id from devicegroup where strname=vm.strname;
	
	if vm_id IS NULL THEN
		insert into devicegroup(
			strname, strdesc, userid, showcolor, searchcondition,searchcontainer,licguid)
			values( 
			vm.strname, vm.strdesc, vm.userid, vm.showcolor, vm.searchcondition,vm.searchcontainer,vm.licguid
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
ALTER FUNCTION devicegroup_upsert(devicegroup) OWNER TO postgres;


CREATE OR REPLACE FUNCTION view_devicegroup_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer, stypename character varying, sguid character varying)
  RETURNS SETOF devicegroupview AS
$BODY$
declare
	r devicegroupview%rowtype;	
	t timestamp without time zone;
BEGIN		
	if uid=-1 then
		select modifytime into t from objtimestamp where typename=stypename;
	else
		select modifytime into t from objprivatetimestamp where typename=stypename and userid=uid and licguid=sguid;
	end if;
	
	if t is null or t>dt then
		if imax <0 then
			if uid=-1 then
				for r in SELECT * FROM devicegroupview where id>ibegin and userid=uid and (licguid=sguid or licguid='-1') loop
				return next r;
				end loop;
			else
				for r in SELECT * FROM devicegroupview where id>ibegin and userid=uid and licguid=sguid loop
				return next r;
				end loop;
			end if;			
		else
			if uid=-1 then
				for r in SELECT * FROM devicegroupview where id>ibegin and userid=uid and (licguid=sguid or licguid='-1') limit imax loop
				return next r;
				end loop;
			else
				for r in SELECT * FROM devicegroupview where id>ibegin and userid=uid and licguid=sguid limit imax loop
				return next r;
				end loop;
			end if;			
		end if;	
	end if;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION view_devicegroup_retrieve(integer, integer, timestamp without time zone, integer, character varying, character varying) OWNER TO postgres;


CREATE OR REPLACE FUNCTION view_devicegroupdevicegroupview_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer, stypename character varying, sguid character varying)
  RETURNS SETOF devicegroupdevicegroupview AS
$BODY$
declare
	r devicegroupdevicegroupview%rowtype;	
	t timestamp without time zone;
BEGIN		
	if uid=-1 then
		select modifytime into t from objtimestamp where typename=stypename;
	else
		select modifytime into t from objprivatetimestamp where typename=stypename and userid=uid and licguid=sguid;
	end if;
	
	if t is null or t>dt then
		if imax <0 then
			if uid=-1 then
				for r in select * from devicegroupdevicegroupview where devicegroupid in (SELECT id FROM devicegroup where id>ibegin and userid=uid and (licguid=sguid or licguid='-1') order by id) order by devicegroupid loop
				return next r;
				end loop;
			else
				for r in select * from devicegroupdevicegroupview where devicegroupid in (SELECT id FROM devicegroup where id>ibegin and userid=uid and licguid=sguid order by id) order by devicegroupid loop
				return next r;
				end loop;
			end if;			
		else
			if uid=-1 then
				for r in select * from devicegroupdevicegroupview where devicegroupid in (SELECT id FROM devicegroup where id>ibegin and userid=uid and (licguid=sguid or licguid='-1') order by id limit imax) order by devicegroupid loop			
				return next r;
				end loop;
			else
				for r in select * from devicegroupdevicegroupview where devicegroupid in (SELECT id FROM devicegroup where id>ibegin and userid=uid and licguid=sguid order by id limit imax) order by devicegroupid loop			
				return next r;
				end loop;
			end if;			
		end if;	
	end if;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION view_devicegroupdevicegroupview_retrieve(integer, integer, timestamp without time zone, integer, character varying, character varying) OWNER TO postgres;


CREATE OR REPLACE FUNCTION view_devicegroupdeviceview_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer, stypename character varying, sguid character varying)
  RETURNS SETOF devicegroupdeviceview AS
$BODY$
declare
	r devicegroupdeviceview%rowtype;
	t timestamp without time zone;
BEGIN
	if uid=-1 then
		select modifytime into t from objtimestamp where typename=stypename;
	else
		select modifytime into t from objprivatetimestamp where typename=stypename and userid=uid and licguid=sguid;
	end if;
	
	if t is null or t>dt then
		if imax <0 then
			if uid=-1 then
				for r in select * from devicegroupdeviceview where devicegroupid in (SELECT id FROM devicegroup where id>ibegin and userid=uid and (licguid=sguid or licguid='-1') order by id) order by devicegroupid loop
				return next r;
				end loop;
			else
				for r in select * from devicegroupdeviceview where devicegroupid in (SELECT id FROM devicegroup where id>ibegin and userid=uid and licguid=sguid order by id) order by devicegroupid loop
				return next r;
				end loop;
			end if;			
		else
			if uid=-1 then
				for r in select * from devicegroupdeviceview where devicegroupid in (SELECT id FROM devicegroup where id>ibegin and userid=uid and (licguid=sguid or licguid='-1') order by id limit imax) order by devicegroupid loop			
				return next r;
				end loop;
			else
				for r in select * from devicegroupdeviceview where devicegroupid in (SELECT id FROM devicegroup where id>ibegin and userid=uid and licguid=sguid order by id limit imax) order by devicegroupid loop			
				return next r;
				end loop;
			end if;			
		end if;	
	end if;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION view_devicegroupdeviceview_retrieve(integer, integer, timestamp without time zone, integer, character varying, character varying) OWNER TO postgres;


CREATE OR REPLACE FUNCTION view_devicegroupsiteview_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer, stypename character varying, sguid character varying)
  RETURNS SETOF devicegroupsiteview AS
$BODY$
declare
	r devicegroupsiteview%rowtype;
	t timestamp without time zone;
BEGIN
	if uid=-1 then
		select modifytime into t from objtimestamp where typename=stypename;
	else
		select modifytime into t from objprivatetimestamp where typename=stypename and userid=uid and licguid=sguid;
	end if;
	
	if t is null or t>dt then
		if imax <0 then
			if uid=-1 then
				for r in select * from devicegroupsiteview where devicegroupid in (SELECT id FROM devicegroup where id>ibegin and userid=uid and (licguid=sguid or licguid='-1') order by id) order by devicegroupid loop
				return next r;
				end loop;
			else
				for r in select * from devicegroupsiteview where devicegroupid in (SELECT id FROM devicegroup where id>ibegin and userid=uid and licguid=sguid order by id) order by devicegroupid loop
				return next r;
				end loop;
			end if;			
		else
			if uid=-1 then
				for r in select * from devicegroupsiteview where devicegroupid in (SELECT id FROM devicegroup where id>ibegin and userid=uid and (licguid=sguid or licguid='-1') order by id limit imax) order by devicegroupid loop			
				return next r;
				end loop;
			else
				for r in select * from devicegroupsiteview where devicegroupid in (SELECT id FROM devicegroup where id>ibegin and userid=uid and licguid=sguid order by id limit imax) order by devicegroupid loop			
				return next r;
				end loop;
			end if;			
		end if;	
	end if;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION view_devicegroupsiteview_retrieve(integer, integer, timestamp without time zone, integer, character varying, character varying) OWNER TO postgres;


CREATE OR REPLACE FUNCTION view_devicegroupsystemdevicegroupview_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer, stypename character varying, sguid character varying)
  RETURNS SETOF devicegroupsystemdevicegroupview AS
$BODY$
declare
	r devicegroupsystemdevicegroupview%rowtype;
	t timestamp without time zone;
BEGIN
	if uid=-1 then
		select modifytime into t from objtimestamp where typename=stypename;
	else
		select modifytime into t from objprivatetimestamp where typename=stypename and userid=uid and licguid=sguid;
	end if;
	
	if t is null or t>dt then
		if imax <0 then
			if uid=-1 then
				for r in select * from devicegroupsystemdevicegroupview where groupid in (SELECT id FROM devicegroup where id>ibegin and (licguid=sguid or licguid='-1') order by id) order by groupid loop
				return next r;
				end loop;
			else
				for r in select * from devicegroupsystemdevicegroupview where groupid in (SELECT id FROM devicegroup where id>ibegin and licguid=sguid order by id) order by groupid loop
				return next r;
				end loop;
			end if;			
		else
			if uid=-1 then
				for r in select * from devicegroupsystemdevicegroupview where groupid in (SELECT id FROM devicegroup where id>ibegin and (licguid=sguid or licguid='-1') order by id limit imax) order by groupid loop			
				return next r;
				end loop;
			else
				for r in select * from devicegroupsystemdevicegroupview where groupid in (SELECT id FROM devicegroup where id>ibegin and licguid=sguid order by id limit imax) order by groupid loop			
				return next r;
				end loop;
			end if;			
		end if;	
	end if;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION view_devicegroupsystemdevicegroupview_retrieve(integer, integer, timestamp without time zone, integer, character varying, character varying) OWNER TO postgres;
------------- function end -------------