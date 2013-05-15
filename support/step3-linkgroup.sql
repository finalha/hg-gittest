\connect "nbws"

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;


------------- trigger start -------------
DROP TRIGGER linkgroup_dt ON linkgroup;
DROP FUNCTION process_linkgroup_dt();
DROP TRIGGER linkgroup_param_dt ON linkgroup_param;
DROP FUNCTION process_linkgroup_param_dt();
DROP TRIGGER linkgroup_paramvalue_dt ON linkgroup_paramvalue;
DROP FUNCTION process_linkgroup_paramvalue_dt();
DROP TRIGGER linkgroupdevice_dt ON linkgroupdevice;
DROP FUNCTION process_linkgroupdevice_dt();
DROP TRIGGER linkgroupinterface_dt ON linkgroupinterface;
DROP FUNCTION process_linkgroupinterface_dt();
------------- trigger end -------------

------------- function start -------------
DROP FUNCTION linkgroup_upsert(linkgroup);
DROP FUNCTION linkgroupnameexists(character varying, integer, integer);
DROP FUNCTION view_linkgroup_dev_devicegroupview_retrieve(integer, integer, timestamp without time zone, integer, character varying);
DROP FUNCTION view_linkgroup_dev_siteview_retrieve(integer, integer, timestamp without time zone, integer, character varying);
DROP FUNCTION view_linkgroup_dev_systemdevicegroupview_retrieve(integer, integer, timestamp without time zone, integer, character varying);
DROP FUNCTION view_linkgroup_paramvalue_retrieve(integer, integer, timestamp without time zone, integer, character varying);
DROP FUNCTION view_linkgroup_retrieve(integer, integer, timestamp without time zone, integer, character varying);
DROP FUNCTION view_linkgroupdevicegroupview_retrieve(integer, integer, timestamp without time zone, integer, character varying);
DROP FUNCTION view_linkgroupdeviceview_retrieve(integer, integer, timestamp without time zone, integer, character varying);
DROP FUNCTION view_linkgroupinterfaceview_retrieve(integer, integer, timestamp without time zone, integer, character varying);
DROP FUNCTION view_linkgrouplinkgroupview_retrieve(integer, integer, timestamp without time zone, integer, character varying);
DROP FUNCTION view_linkgroupparam_retrieve(integer, integer, timestamp without time zone, integer, character varying);
DROP FUNCTION view_linkgroupsiteview_retrieve(integer, integer, timestamp without time zone, integer, character varying);
DROP FUNCTION view_linkgroupsystemdevicegroupview_retrieve(integer, integer, timestamp without time zone, integer, character varying);
------------- function end -------------

------------- view start -------------
DROP VIEW linkgroupview;
------------- view end -------------


------------- add column -------------
ALTER TABLE linkgroup ADD COLUMN licguid character varying(128);
ALTER TABLE linkgroup ALTER COLUMN licguid SET STORAGE EXTENDED;
update linkgroup set licguid='-1' where userid=-1;
update linkgroup set licguid=:licguid where userid<>-1;
------------- add column -------------


------------- trigger start -------------
CREATE OR REPLACE FUNCTION process_linkgroup_dt()
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
			OLD.showstyle =NEW.showstyle AND
			OLD.showwidth = NEW.showwidth AND
			OLD.searchcondition= NEW.searchcondition AND
			OLD.searchcontainer =NEW.searchcontainer AND
			OLD.dev_searchcondition =NEW.dev_searchcondition AND
			OLD.dev_searchcontainer =NEW.dev_searchcontainer AND
			OLD.is_map_auto_link =NEW.is_map_auto_link AND
			OLD.istemplate =NEW.istemplate AND
			OLD.licguid = NEW.licguid
		then
			return OLD;
		end IF;

		if(LinkGroupNameExists(New.strname,NEW.id,New.userid,New.licguid)=true) then
			RAISE EXCEPTION 'name exists';
		end if;

		if not NEW.userid=OLD.userid then
			update objtimestamp set modifytime=now() where typename='PublicLinkGroup';
			if new.userid=-1 then
				iguid=old.licguid;
				uid=old.userid;
			else 
				iguid=new.licguid;
				uid=new.userid;
			end if;
			select id into tid from objprivatetimestamp where typename='PrivateLinkGroup' and userid=uid and licguid=iguid;
			if tid is null then
				insert into objprivatetimestamp (typename,userid,modifytime,licguid) values('PrivateLinkGroup',uid,now(),iguid);
			else
				update objprivatetimestamp set modifytime=now() where typename='PrivateLinkGroup' and userid=uid and licguid=iguid;
			end if;
		elseif NEW.userid=-1 then
			update objtimestamp set modifytime=now() where typename='PublicLinkGroup';
		else
			select id into tid from objprivatetimestamp where typename='PrivateLinkGroup' and userid=new.userid and licguid=NEW.licguid;
			if tid is null then
				insert into objprivatetimestamp (typename,userid,modifytime,licguid) values('PrivateLinkGroup',new.userid,now(),NEW.licguid);
			else
				update objprivatetimestamp set modifytime=now() where typename='PrivateLinkGroup' and userid=new.userid and licguid=NEW.licguid;
			end if;	
		end if;		
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN

		if(LinkGroupNameExists(New.strname,0,New.userid,New.licguid)=true) then
			RAISE EXCEPTION 'name exists';
		end if;
		
		if NEW.userid=-1 then
			update objtimestamp set modifytime=now() where typename='PublicLinkGroup';
		else
			select id into tid from objprivatetimestamp where typename='PrivateLinkGroup' and userid=new.userid and licguid=New.licguid;
			if tid is null then
				insert into objprivatetimestamp (typename,userid,modifytime,licguid) values('PrivateLinkGroup',new.userid,now(),New.licguid);
			else
				update objprivatetimestamp set modifytime=now() where typename='PrivateLinkGroup' and userid=new.userid and licguid= New.licguid;
			end if;	
		end if;	
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		if OLD.userid=-1 then
			update objtimestamp set modifytime=now() where typename='PublicLinkGroup';
		else
				select id into tid from objprivatetimestamp where typename='PrivateLinkGroup' and userid=OLD.userid and licguid=OLD.licguid;
				if tid is null then
					insert into objprivatetimestamp (typename,userid,modifytime,licguid) values('PrivateLinkGroup',old.userid,now(),old.licguid);
				else
					update objprivatetimestamp set modifytime=now() where typename='PrivateLinkGroup' and userid=old.userid and licguid=OLD.licguid;
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


CREATE OR REPLACE FUNCTION process_linkgroup_param_dt()
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
		IF 	OLD.linkgroupid = NEW.linkgroupid AND 				
			OLD.strname = NEW.strname AND
			OLD.strdesc = NEW.strdesc
		then
			return OLD;
		end IF;
		select userid into newuserid from linkgroup where id=NEW.linkgroupid;
		select userid into olduserid from linkgroup where id=old.linkgroupid;
		select licguid into newguid from linkgroup where id=NEW.linkgroupid;
		select licguid into oldguid from linkgroup where id=old.linkgroupid;

		if not (newuserid=olduserid and newguid=oldguid) then
			update objtimestamp set modifytime=now() where typename='PublicLinkGroup';
			if newuserid=-1 then
				iguid=oldguid;
				uid=olduserid;
			else 
				iguid=newguid;
				uid=newuserid;
			end if;
			select id into tid from objprivatetimestamp where typename='PrivateLinkGroup' and userid=uid and licguid=iguid;
			if tid is null then
				insert into objprivatetimestamp (typename,userid,modifytime,licguid) values('PrivateLinkGroup',uid,now(),iguid);
			else
				update objprivatetimestamp set modifytime=now() where typename='PrivateLinkGroup' and userid=uid and licguid=iguid;
			end if;
		elseif newuserid=-1 then
			update objtimestamp set modifytime=now() where typename='PublicLinkGroup';
		else
			select id into tid from objprivatetimestamp where typename='PrivateLinkGroup' and userid=newuserid and licguid=newguid;
			if tid is null then
				insert into objprivatetimestamp (typename,userid,modifytime,licguid) values('PrivateLinkGroup',newuserid,now(),newguid);
			else
				update objprivatetimestamp set modifytime=now() where typename='PrivateLinkGroup' and userid=newuserid and licguid=newguid;
			end if;	
		end if;		
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		select userid into newuserid from linkgroup where id=NEW.linkgroupid;
		if newuserid=-1 then
			update objtimestamp set modifytime=now() where typename='PublicLinkGroup';
		else
			select licguid into newguid from linkgroup where id=new.linkgroupid;
			select id into tid from objprivatetimestamp where typename='PrivateLinkGroup' and userid=newuserid and licguid=newguid;
			if tid is null then
				insert into objprivatetimestamp (typename,userid,modifytime,licguid) values('PrivateLinkGroup',newuserid,now(),newguid);
			else
				update objprivatetimestamp set modifytime=now() where typename='PrivateLinkGroup' and userid=newuserid  and licguid=newguid;
			end if;	
		end if;		
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		select userid into olduserid from linkgroup where id=old.linkgroupid;
		if not olduserid is null then
			if olduserid=-1 then
				update objtimestamp set modifytime=now() where typename='PublicLinkGroup';
			else
				select licguid into oldguid from linkgroup where id=old.linkgroupid;
				select id into tid from objprivatetimestamp where typename='PrivateLinkGroup' and userid=olduserid and licguid=oldguid;
				if tid is null then
					insert into objprivatetimestamp (typename,userid,modifytime,licguid) values('PrivateLinkGroup',olduserid,now(),oldguid);
				else
					update objprivatetimestamp set modifytime=now() where typename='PrivateLinkGroup' and userid=olduserid and licguid=oldguid;
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


CREATE OR REPLACE FUNCTION process_linkgroup_paramvalue_dt()
  RETURNS trigger AS
$BODY$declare tid integer;
declare uid integer;
DECLARE newuserid integer;
DECLARE olduserid integer;
DECLARE newguid character varying;
DECLARE oldguid character varying;
DECLARE iguid character varying;
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
		select linkgroup.licguid into newguid from linkgroup,linkgroup_param where linkgroup.id=linkgroup_param.linkgroupid and linkgroup_param.id=OLD.paramid;
		select linkgroup.licguid into oldguid from linkgroup,linkgroup_param where linkgroup.id=linkgroup_param.linkgroupid and linkgroup_param.id=OLD.paramid;

		if not (newuserid=olduserid and newguid=oldguid) then
			update objtimestamp set modifytime=now() where typename='PublicLinkGroup';
			if newuserid=-1 then
				iguid=oldguid;
				uid=olduserid;
			else 
				iguid=newguid;
				uid=newuserid;
			end if;
			select id into tid from objprivatetimestamp where typename='PrivateLinkGroup' and userid=uid and licguid=iguid;
			if tid is null then
				insert into objprivatetimestamp (typename,userid,modifytime,licguid) values('PrivateLinkGroup',uid,now(),iguid);
			else
				update objprivatetimestamp set modifytime=now() where typename='PrivateLinkGroup' and userid=uid and licguid=iguid;
			end if;
		elseif newuserid=-1 then
			update objtimestamp set modifytime=now() where typename='PublicLinkGroup';
		else
			select id into tid from objprivatetimestamp where typename='PrivateLinkGroup' and userid=newuserid and licguid=newguid;
			if tid is null then
				insert into objprivatetimestamp (typename,userid,modifytime,licguid) values('PrivateLinkGroup',newuserid,now(),newguid);
			else
				update objprivatetimestamp set modifytime=now() where typename='PrivateLinkGroup' and userid=newuserid and licguid=newguid;
			end if;	
		end if;		
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		select linkgroup.userid into newuserid from linkgroup,linkgroup_param where linkgroup.id=linkgroup_param.linkgroupid and linkgroup_param.id=NEW.paramid;		
		if newuserid=-1 then
			update objtimestamp set modifytime=now() where typename='PublicLinkGroup';
		else
			select linkgroup.licguid into newguid from linkgroup,linkgroup_param where linkgroup.id=linkgroup_param.linkgroupid and linkgroup_param.id=NEW.paramid;
			select id into tid from objprivatetimestamp where typename='PrivateLinkGroup' and userid=newuserid and licguid=newguid ;
			if tid is null then
				insert into objprivatetimestamp (typename,userid,modifytime,licguid) values('PrivateLinkGroup',newuserid,now(),newguid );
			else
				update objprivatetimestamp set modifytime=now() where typename='PrivateLinkGroup' and userid=newuserid and licguid=newguid ;
			end if;	
		end if;		
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		select linkgroup.userid into olduserid from linkgroup,linkgroup_param where linkgroup.id=linkgroup_param.linkgroupid and linkgroup_param.id=OLD.paramid;		
		if not olduserid is null then
			if olduserid=-1 then
				update objtimestamp set modifytime=now() where typename='PublicLinkGroup';
			else
				select linkgroup.licguid into oldguid from linkgroup,linkgroup_param where linkgroup.id=linkgroup_param.linkgroupid and linkgroup_param.id=OLD.paramid;
				select id into tid from objprivatetimestamp where typename='PrivateLinkGroup' and userid=olduserid and licguid=oldguid;
				if tid is null then
					insert into objprivatetimestamp (typename,userid,modifytime,licguid) values('PrivateLinkGroup',olduserid,now(),oldguid);
				else
					update objprivatetimestamp set modifytime=now() where typename='PrivateLinkGroup' and userid=olduserid and licguid=oldguid;
				end if;	
			end if;			
		end if;
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION process_linkgroup_paramvalue_dt() OWNER TO postgres;


CREATE TRIGGER linkgroup_paramvalue_dt
  BEFORE INSERT OR UPDATE OR DELETE
  ON linkgroup_paramvalue
  FOR EACH ROW
  EXECUTE PROCEDURE process_linkgroup_paramvalue_dt();


CREATE OR REPLACE FUNCTION process_linkgroupdevice_dt()
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
		IF 	OLD.linkgroupid = NEW.linkgroupid AND 				
			OLD.deviceid = NEW.deviceid AND
			OLD."type" = NEW."type"
		then
			return OLD;
		end IF;
		select userid into newuserid from linkgroup where id=NEW.linkgroupid;
		select userid into olduserid from linkgroup where id=old.linkgroupid;
		select licguid into newguid from linkgroup where id=NEW.linkgroupid;
		select licguid into oldguid from linkgroup where id=old.linkgroupid;

		if not newuserid=olduserid then
			update objtimestamp set modifytime=now() where typename='PublicLinkGroup';
			if newuserid=-1 then
				iguid=oldguid;
				uid=olduserid;
			else 
				iguid=newguid;
				uid=newuserid;
			end if;
			select id into tid from objprivatetimestamp where typename='PrivateLinkGroup' and userid=uid and licguid=iguid;
			if tid is null then
				insert into objprivatetimestamp (typename,userid,modifytime,licguid) values('PrivateLinkGroup',uid,now(),iguid);
			else
				update objprivatetimestamp set modifytime=now() where typename='PrivateLinkGroup' and userid=uid and licguid=iguid;
			end if;
		elseif newuserid=-1 then
			update objtimestamp set modifytime=now() where typename='PublicLinkGroup';
		else
			select id into tid from objprivatetimestamp where typename='PrivateLinkGroup' and userid=newuserid and licguid=newguid;
			if tid is null then
				insert into objprivatetimestamp (typename,userid,modifytime,licguid) values('PrivateLinkGroup',newuserid,now(),newguid);
			else
				update objprivatetimestamp set modifytime=now() where typename='PrivateLinkGroup' and userid=newuserid and licguid=newguid;
			end if;	
		end if;		
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		select userid into newuserid from linkgroup where id=NEW.linkgroupid;
		if newuserid=-1 then
			update objtimestamp set modifytime=now() where typename='PublicLinkGroup';
		else
			select licguid into newguid from linkgroup where id=NEW.linkgroupid;
			select id into tid from objprivatetimestamp where typename='PrivateLinkGroup' and userid=newuserid and licguid=newguid;
			if tid is null then
				insert into objprivatetimestamp (typename,userid,modifytime,licguid) values('PrivateLinkGroup',newuserid,now(),newguid);
			else
				update objprivatetimestamp set modifytime=now() where typename='PrivateLinkGroup' and userid=newuserid and licguid=newguid;
			end if;	
		end if;		
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		select userid into olduserid from linkgroup where id=old.linkgroupid;
		if not olduserid is null then
			if olduserid=-1 then
				update objtimestamp set modifytime=now() where typename='PublicLinkGroup';
			else
				select licguid into oldguid from linkgroup where id=old.linkgroupid;
				select id into tid from objprivatetimestamp where typename='PrivateLinkGroup' and userid=olduserid and licguid=oldguid;
				if tid is null then
					insert into objprivatetimestamp (typename,userid,modifytime,licguid) values('PrivateLinkGroup',olduserid,now(),oldguid);
				else
					update objprivatetimestamp set modifytime=now() where typename='PrivateLinkGroup' and userid=olduserid and licguid=oldguid;
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


CREATE OR REPLACE FUNCTION process_linkgroupinterface_dt()
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
		select licguid into newguid from linkgroup where id=NEW.groupid;
		select licguid into oldguid from linkgroup where id=old.groupid;

		if not newuserid=olduserid then
			update objtimestamp set modifytime=now() where typename='PublicLinkGroup';
			if newuserid=-1 then
				iguid=oldguid;
				uid=olduserid;
			else 
				iguid=newguid;
				uid=newuserid;
			end if;
			select id into tid from objprivatetimestamp where typename='PrivateLinkGroup' and userid=uid and licguid=iguid;
			if tid is null then
				insert into objprivatetimestamp (typename,userid,modifytime,licguid) values('PrivateLinkGroup',uid,now(),iguid);
			else
				update objprivatetimestamp set modifytime=now() where typename='PrivateLinkGroup' and userid=uid and licguid=iguid;
			end if;
		elseif newuserid=-1 then
			update objtimestamp set modifytime=now() where typename='PublicLinkGroup';
		else
			select id into tid from objprivatetimestamp where typename='PrivateLinkGroup' and userid=newuserid and licguid=newguid;
			if tid is null then
				insert into objprivatetimestamp (typename,userid,modifytime,licguid) values('PrivateLinkGroup',newuserid,now(),newguid);
			else
				update objprivatetimestamp set modifytime=now() where typename='PrivateLinkGroup' and userid=newuserid and licguid=newguid;
			end if;	
		end if;		
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		select userid into newuserid from linkgroup where id=NEW.groupid;
		if newuserid=-1 then
			update objtimestamp set modifytime=now() where typename='PublicLinkGroup';
		else
			select licguid into newguid from linkgroup where id=NEW.groupid;
			select id into tid from objprivatetimestamp where typename='PrivateLinkGroup' and userid=newuserid and licguid=newguid;
			if tid is null then
				insert into objprivatetimestamp (typename,userid,modifytime,licguid) values('PrivateLinkGroup',newuserid,now(),newguid);
			else
				update objprivatetimestamp set modifytime=now() where typename='PrivateLinkGroup' and userid=newuserid and licguid=newguid;
			end if;	
		end if;		
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		select userid into olduserid from linkgroup where id=old.groupid;
		if not olduserid is null then
			if olduserid=-1 then
				update objtimestamp set modifytime=now() where typename='PublicLinkGroup';
			else
				select licguid into oldguid from linkgroup where id=old.groupid;
				select id into tid from objprivatetimestamp where typename='PrivateLinkGroup' and userid=olduserid and licguid=oldguid;
				if tid is null then
					insert into objprivatetimestamp (typename,userid,modifytime,licguid) values('PrivateLinkGroup',olduserid,now(),oldguid);
				else
					update objprivatetimestamp set modifytime=now() where typename='PrivateLinkGroup' and userid=olduserid and licguid=oldguid;
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
------------- trigger end -------------


------------- view start -------------
CREATE OR REPLACE VIEW linkgroupview AS 
 SELECT linkgroup.id, linkgroup.strname, linkgroup.strdesc, linkgroup.showcolor, linkgroup.showstyle, linkgroup.showwidth, linkgroup.searchcondition, linkgroup.userid, ( SELECT count(*) AS count
           FROM linkgroupinterface
          WHERE linkgroupinterface.groupid = linkgroup.id) AS irefcount, linkgroup.searchcontainer, linkgroup.dev_searchcondition, linkgroup.dev_searchcontainer, linkgroup.is_map_auto_link, linkgroup.istemplate, linkgroup.licguid
   FROM linkgroup;

ALTER TABLE linkgroupview OWNER TO postgres;
------------- view end -------------


------------- function start -------------
CREATE OR REPLACE FUNCTION linkgroup_upsert(vm linkgroup)
  RETURNS integer AS
$BODY$
declare
	vm_id integer;
BEGIN
	select id into vm_id from linkgroup where strname=vm.strname;
	
	if vm_id IS NULL THEN
		insert into linkgroup(
			strname, strdesc, showcolor, showstyle, showwidth,userid,searchcondition,searchcontainer,dev_searchcondition,dev_searchcontainer,is_map_auto_link,istemplate,licguid)
			values( 
			vm.strname, vm.strdesc, vm.showcolor, vm.showstyle, vm.showwidth,vm.userid,vm.searchcondition,vm.searchcontainer,vm.dev_searchcondition,vm.dev_searchcontainer,vm.is_map_auto_link,vm.istemplate,vm.licguid
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


CREATE OR REPLACE FUNCTION linkgroupnameexists(sname character varying, nid integer, uid integer, iguid character varying)
  RETURNS boolean AS
$BODY$
BEGIN
	if((select count(*) from linkgroup where id<>nid and lower(strname) =lower(sname) and userid=uid and licguid=iguid)=0) then
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
ALTER FUNCTION linkgroupnameexists(character varying, integer, integer, character varying) OWNER TO postgres;


CREATE OR REPLACE FUNCTION view_linkgroup_dev_devicegroupview_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer, stypename character varying, sguid character varying)
  RETURNS SETOF linkgroup_dev_devicegroupview AS
$BODY$
declare
	r linkgroup_dev_devicegroupview%rowtype;
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
				for r in select * from linkgroup_dev_devicegroupview where linkgroupid in (SELECT id FROM linkgroup where id>ibegin and userid=uid and (licguid=sguid or licguid='-1') order by id) order by linkgroupid loop
				return next r;
				end loop;
			else
				for r in select * from linkgroup_dev_devicegroupview where linkgroupid in (SELECT id FROM linkgroup where id>ibegin and userid=uid and licguid=sguid order by id) order by linkgroupid loop
				return next r;
				end loop;
			end if;			
		else
			if uid=-1 then
				for r in select * from linkgroup_dev_devicegroupview where linkgroupid in (SELECT id FROM linkgroup where id>ibegin and userid=uid and (licguid=sguid or licguid='-1') order by id limit imax) order by linkgroupid loop			
				return next r;
				end loop;
			else
				for r in select * from linkgroup_dev_devicegroupview where linkgroupid in (SELECT id FROM linkgroup where id>ibegin and userid=uid and licguid=sguid order by id limit imax) order by linkgroupid loop			
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
ALTER FUNCTION view_linkgroup_dev_devicegroupview_retrieve(integer, integer, timestamp without time zone, integer, character varying, character varying) OWNER TO postgres;


CREATE OR REPLACE FUNCTION view_linkgroup_dev_siteview_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer, stypename character varying, sguid character varying)
  RETURNS SETOF linkgroup_dev_siteview AS
$BODY$
declare
	r linkgroup_dev_siteview%rowtype;
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
				for r in select * from linkgroup_dev_siteview where linkgroupid in (SELECT id FROM linkgroup where id>ibegin and userid=uid and (licguid=sguid or licguid='-1') order by id) order by linkgroupid loop
				return next r;
				end loop;
			else
				for r in select * from linkgroup_dev_siteview where linkgroupid in (SELECT id FROM linkgroup where id>ibegin and userid=uid and licguid=sguid order by id) order by linkgroupid loop
				return next r;
				end loop;
			end if;			
		else
			if uid=-1 then
				for r in select * from linkgroup_dev_siteview where linkgroupid in (SELECT id FROM linkgroup where id>ibegin and userid=uid and (licguid=sguid or licguid='-1') order by id limit imax) order by linkgroupid loop			
				return next r;
				end loop;
			else
				for r in select * from linkgroup_dev_siteview where linkgroupid in (SELECT id FROM linkgroup where id>ibegin and userid=uid and licguid=sguid order by id limit imax) order by linkgroupid loop			
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
ALTER FUNCTION view_linkgroup_dev_siteview_retrieve(integer, integer, timestamp without time zone, integer, character varying, character varying) OWNER TO postgres;


CREATE OR REPLACE FUNCTION view_linkgroup_dev_systemdevicegroupview_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer, stypename character varying, sguid character varying)
  RETURNS SETOF linkgroup_dev_systemdevicegroupview AS
$BODY$
declare
	r linkgroup_dev_systemdevicegroupview%rowtype;
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
				for r in select * from linkgroup_dev_systemdevicegroupview where linkgroupid in (SELECT id FROM linkgroup where id>ibegin and (licguid=sguid or licguid='-1') order by id) order by linkgroupid loop
				return next r;
				end loop;
			else
				for r in select * from linkgroup_dev_systemdevicegroupview where linkgroupid in (SELECT id FROM linkgroup where id>ibegin and licguid=sguid order by id) order by linkgroupid loop
				return next r;
				end loop;
			end if;			
		else
			if uid=-1 then
				for r in select * from linkgroup_dev_systemdevicegroupview where linkgroupid in (SELECT id FROM linkgroup where id>ibegin and (licguid=sguid or licguid='-1') order by id limit imax) order by linkgroupid loop			
				return next r;
				end loop;
			else
				for r in select * from linkgroup_dev_systemdevicegroupview where linkgroupid in (SELECT id FROM linkgroup where id>ibegin and licguid=sguid order by id limit imax) order by linkgroupid loop			
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
ALTER FUNCTION view_linkgroup_dev_systemdevicegroupview_retrieve(integer, integer, timestamp without time zone, integer, character varying, character varying) OWNER TO postgres;


CREATE OR REPLACE FUNCTION view_linkgroup_paramvalue_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer, stypename character varying, sguid character varying)
  RETURNS SETOF linkgroup_paramvalue AS
$BODY$
declare
	r linkgroup_paramvalue%rowtype;
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
				for r in select * from linkgroup_paramvalue where paramid in (SELECT linkgroup_param.id FROM linkgroup,linkgroup_param where linkgroup.id=linkgroup_param.linkgroupid and linkgroup.id>ibegin and linkgroup.userid=uid and (licguid=sguid or licguid='-1') order by linkgroup.id) order by id loop
				return next r;
				end loop;
			else
				for r in select * from linkgroup_paramvalue where paramid in (SELECT linkgroup_param.id FROM linkgroup,linkgroup_param where linkgroup.id=linkgroup_param.linkgroupid and linkgroup.id>ibegin and linkgroup.userid=uid and licguid=sguid order by linkgroup.id) order by id loop
				return next r;
				end loop;
			end if;			
		else
			if uid=-1 then
				for r in select * from linkgroup_paramvalue where paramid in (SELECT linkgroup_param.id FROM linkgroup,linkgroup_param where linkgroup.id=linkgroup_param.linkgroupid and linkgroup.id>ibegin and linkgroup.userid=uid and (licguid=sguid or licguid='-1') order by linkgroup.id limit imax) order by id loop			
				return next r;
				end loop;
			else
				for r in select * from linkgroup_paramvalue where paramid in (SELECT linkgroup_param.id FROM linkgroup,linkgroup_param where linkgroup.id=linkgroup_param.linkgroupid and linkgroup.id>ibegin and linkgroup.userid=uid and licguid=sguid order by linkgroup.id limit imax) order by id loop			
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
ALTER FUNCTION view_linkgroup_paramvalue_retrieve(integer, integer, timestamp without time zone, integer, character varying, character varying) OWNER TO postgres;


CREATE OR REPLACE FUNCTION view_linkgroup_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer, stypename character varying, sguid character varying)
  RETURNS SETOF linkgroupview AS
$BODY$
declare
	r linkgroupview%rowtype;
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
				for r in SELECT * FROM linkgroupview where id>ibegin and userid=uid and (licguid=sguid or licguid='-1') loop
				return next r;
				end loop;
			else
				for r in SELECT * FROM linkgroupview where id>ibegin and userid=uid and licguid=sguid loop
				return next r;
				end loop;
			end if;		
		else
			if uid=-1 then
				for r in SELECT * FROM linkgroupview where id>ibegin and userid=uid and (licguid=sguid or licguid='-1') limit imax loop
				return next r;
				end loop;
			else
				for r in SELECT * FROM linkgroupview where id>ibegin and userid=uid and licguid=sguid limit imax loop
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
ALTER FUNCTION view_linkgroup_retrieve(integer, integer, timestamp without time zone, integer, character varying, character varying) OWNER TO postgres;


CREATE OR REPLACE FUNCTION view_linkgroupdevicegroupview_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer, stypename character varying, sguid character varying)
  RETURNS SETOF linkgroupdevicegroupview AS
$BODY$
declare
	r linkgroupdevicegroupview%rowtype;
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
				for r in select * from linkgroupdevicegroupview where id in (SELECT id FROM linkgroup where id>ibegin and userid=uid and (licguid=sguid or licguid='-1') order by id) order by id loop
				return next r;
				end loop;
			else
				for r in select * from linkgroupdevicegroupview where id in (SELECT id FROM linkgroup where id>ibegin and userid=uid and licguid=sguid order by id) order by id loop
				return next r;
				end loop;
			end if;			
		else
			if uid=-1 then
				for r in select * from linkgroupdevicegroupview where id in (SELECT id FROM linkgroup where id>ibegin and userid=uid and (licguid=sguid or licguid='-1') order by id limit imax) order by id loop			
				return next r;
				end loop;
			else
				for r in select * from linkgroupdevicegroupview where id in (SELECT id FROM linkgroup where id>ibegin and userid=uid and licguid=sguid order by id limit imax) order by id loop			
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
ALTER FUNCTION view_linkgroupdevicegroupview_retrieve(integer, integer, timestamp without time zone, integer, character varying, character varying) OWNER TO postgres;


CREATE OR REPLACE FUNCTION view_linkgroupdeviceview_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer, stypename character varying, sguid character varying)
  RETURNS SETOF linkgroupdeviceview AS
$BODY$
declare
	r linkgroupdeviceview%rowtype;
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
				for r in select * from linkgroupdeviceview where linkgroupid in (SELECT id FROM linkgroup where id>ibegin and userid=uid and (licguid=sguid or licguid='-1') order by id) order by linkgroupid loop
				return next r;
				end loop;
			else
				for r in select * from linkgroupdeviceview where linkgroupid in (SELECT id FROM linkgroup where id>ibegin and userid=uid and licguid=sguid order by id) order by linkgroupid loop
				return next r;
				end loop;
			end if;			
		else
			if uid=-1 then
				for r in select * from linkgroupdeviceview where linkgroupid in (SELECT id FROM linkgroup where id>ibegin and userid=uid and (licguid=sguid or licguid='-1') order by id limit imax) order by linkgroupid loop			
				return next r;
				end loop;
			else
				for r in select * from linkgroupdeviceview where linkgroupid in (SELECT id FROM linkgroup where id>ibegin and userid=uid and licguid=sguid order by id limit imax) order by linkgroupid loop			
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
ALTER FUNCTION view_linkgroupdeviceview_retrieve(integer, integer, timestamp without time zone, integer, character varying, character varying) OWNER TO postgres;


CREATE OR REPLACE FUNCTION view_linkgroupinterfaceview_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer, stypename character varying, sguid character varying)
  RETURNS SETOF linkgroupinterfaceview AS
$BODY$
declare
	r linkgroupinterfaceview%rowtype;
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
				for r in select * from linkgroupinterfaceview where groupid in (SELECT id FROM linkgroup where id>ibegin and userid=uid and (licguid=sguid or licguid='-1') order by id) order by groupid loop
				return next r;
				end loop;
			else
				for r in select * from linkgroupinterfaceview where groupid in (SELECT id FROM linkgroup where id>ibegin and userid=uid and licguid=sguid order by id) order by groupid loop
				return next r;
				end loop;
			end if;			
		else
			if uid=-1 then
				for r in select * from linkgroupinterfaceview where groupid in (SELECT id FROM linkgroup where id>ibegin and userid=uid and (licguid=sguid or licguid='-1') order by id limit imax) order by groupid loop			
				return next r;
				end loop;
			else
				for r in select * from linkgroupinterfaceview where groupid in (SELECT id FROM linkgroup where id>ibegin and userid=uid and licguid=sguid order by id limit imax) order by groupid loop			
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
ALTER FUNCTION view_linkgroupinterfaceview_retrieve(integer, integer, timestamp without time zone, integer, character varying, character varying) OWNER TO postgres;


CREATE OR REPLACE FUNCTION view_linkgrouplinkgroupview_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer, stypename character varying, sguid character varying)
  RETURNS SETOF linkgrouplinkgroupview AS
$BODY$
declare
	r linkgrouplinkgroupview%rowtype;
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
				for r in select * from linkgrouplinkgroupview where id in (SELECT id FROM linkgroup where id>ibegin and userid=uid and (licguid=sguid or licguid='-1') order by id) order by id loop
				return next r;
				end loop;
			else
				for r in select * from linkgrouplinkgroupview where id in (SELECT id FROM linkgroup where id>ibegin and userid=uid and licguid=sguid order by id) order by id loop
				return next r;
				end loop;
			end if;			
		else
			if uid=-1 then
				for r in select * from linkgrouplinkgroupview where id in (SELECT id FROM linkgroup where id>ibegin and userid=uid and (licguid=sguid or licguid='-1') order by id limit imax) order by id loop			
				return next r;
				end loop;
			else
				for r in select * from linkgrouplinkgroupview where id in (SELECT id FROM linkgroup where id>ibegin and userid=uid and licguid=sguid order by id limit imax) order by id loop			
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
ALTER FUNCTION view_linkgrouplinkgroupview_retrieve(integer, integer, timestamp without time zone, integer, character varying, character varying) OWNER TO postgres;


CREATE OR REPLACE FUNCTION view_linkgroupparam_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer, stypename character varying, sguid character varying)
  RETURNS SETOF linkgroup_param AS
$BODY$
declare
	r linkgroup_param%rowtype;
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
				for r in select * from linkgroup_param where linkgroupid in (SELECT id FROM linkgroup where id>ibegin and userid=uid and (licguid=sguid or licguid='-1') order by id) order by id loop
				return next r;
				end loop;
			else
				for r in select * from linkgroup_param where linkgroupid in (SELECT id FROM linkgroup where id>ibegin and userid=uid and licguid=sguid order by id) order by id loop
				return next r;
				end loop;
			end if;			
		else
			if uid=-1 then
				for r in select * from linkgroup_param where linkgroupid in (SELECT id FROM linkgroup where id>ibegin and userid=uid and (licguid=sguid or licguid='-1') order by id limit imax) order by id loop			
				return next r;
				end loop;
			else
				for r in select * from linkgroup_param where linkgroupid in (SELECT id FROM linkgroup where id>ibegin and userid=uid and licguid=sguid order by id limit imax) order by id loop			
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
ALTER FUNCTION view_linkgroupparam_retrieve(integer, integer, timestamp without time zone, integer, character varying, character varying) OWNER TO postgres;


CREATE OR REPLACE FUNCTION view_linkgroupsiteview_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer, stypename character varying, sguid character varying)
  RETURNS SETOF linkgroupsiteview AS
$BODY$
declare
	r linkgroupsiteview%rowtype;
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
				for r in select * from linkgroupsiteview where id in (SELECT id FROM linkgroup where id>ibegin and userid=uid and (licguid=sguid or licguid='-1') order by id) order by id loop
				return next r;
				end loop;
			else
				for r in select * from linkgroupsiteview where id in (SELECT id FROM linkgroup where id>ibegin and userid=uid and licguid=sguid order by id) order by id loop
				return next r;
				end loop;
			end if;			
		else
			if uid=-1 then
				for r in select * from linkgroupsiteview where id in (SELECT id FROM linkgroup where id>ibegin and userid=uid and (licguid=sguid or licguid='-1') order by id limit imax) order by id loop			
				return next r;
				end loop;
			else
				for r in select * from linkgroupsiteview where id in (SELECT id FROM linkgroup where id>ibegin and userid=uid and licguid=sguid order by id limit imax) order by id loop			
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
ALTER FUNCTION view_linkgroupsiteview_retrieve(integer, integer, timestamp without time zone, integer, character varying, character varying) OWNER TO postgres;


CREATE OR REPLACE FUNCTION view_linkgroupsystemdevicegroupview_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer, stypename character varying, sguid character varying)
  RETURNS SETOF linkgroupsystemdevicegroupview AS
$BODY$
declare
	r linkgroupsystemdevicegroupview%rowtype;
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
				for r in select * from linkgroupsystemdevicegroupview where groupid in (SELECT id FROM linkgroup where id>ibegin and userid=uid and (licguid=sguid or licguid='-1') order by id) order by id loop
				return next r;
				end loop;
			else
				for r in select * from linkgroupsystemdevicegroupview where groupid in (SELECT id FROM linkgroup where id>ibegin and userid=uid and licguid=sguid order by id) order by id loop
				return next r;
				end loop;
			end if;			
		else
			if uid=-1 then
				for r in select * from linkgroupsystemdevicegroupview where groupid in (SELECT id FROM linkgroup where id>ibegin and userid=uid and (licguid=sguid or licguid='-1') order by id limit imax) order by id loop			
				return next r;
				end loop;
			else
				for r in select * from linkgroupsystemdevicegroupview where groupid in (SELECT id FROM linkgroup where id>ibegin and userid=uid and licguid=sguid order by id limit imax) order by id loop			
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
ALTER FUNCTION view_linkgroupsystemdevicegroupview_retrieve(integer, integer, timestamp without time zone, integer, character varying, character varying) OWNER TO postgres;
------------- function end -------------

