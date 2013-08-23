\connect :nbwsp;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;



ALTER TABLE site ADD COLUMN newguid character varying(256);
ALTER TABLE site ALTER COLUMN newguid SET STORAGE EXTENDED;


CREATE OR REPLACE FUNCTION uuid_generate_v4()
  RETURNS uuid AS
'$libdir/uuid-ossp', 'uuid_generate_v4'
  LANGUAGE 'c' VOLATILE STRICT
  COST 1;
ALTER FUNCTION uuid_generate_v4() OWNER TO postgres;


DROP TRIGGER site_dt ON site;
DROP FUNCTION process_site_dt();

CREATE OR REPLACE FUNCTION build_site_guid()
  RETURNS boolean AS
$BODY$

DECLARE
    guid character;
    r site%rowtype;
BEGIN
    for r in select * from site loop		
	update site set newguid=UPPER('{'|| uuid_generate_v4() || '}');
    END LOOP;    
    RETURN true;
    
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION build_site_guid() OWNER TO postgres;
select * from build_site_guid();
DROP FUNCTION build_site_guid();

update objtimestamp set modifytime=now() where typename='site';
update site set lasttimestamp=now();


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
			OLD.searchcontainer = NEW.searchcontainer and
			OLD.sitemanagerid = NEW.sitemanagerid and
			OLD.class = NEW.class and
			OLD.description = NEW.description and
			OLD.isclosegroup = NEW.isclosegroup and
			OLD.matchtype =NEW.matchtype and
			OLD.searchcontainertype=NEW.searchcontainertype and
			OLD.newguid=NEW.newguid
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
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION process_site_dt() OWNER TO postgres;

CREATE TRIGGER site_dt
  BEFORE INSERT OR UPDATE OR DELETE
  ON site
  FOR EACH ROW
  EXECUTE PROCEDURE process_site_dt();


DROP FUNCTION view_site_retrieve(integer, integer, timestamp without time zone, character varying);
DROP VIEW siteview;


CREATE OR REPLACE VIEW siteview AS 
 SELECT site.*, site2site.parentid, ( SELECT count(*) AS count
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


DROP FUNCTION site_update(site, integer);

CREATE OR REPLACE FUNCTION site_update(r site, parent_id integer)
  RETURNS integer AS
$BODY$
declare	
	ds_id integer;
BEGIN		
	select id into ds_id from site where id=r.id and sitemanagerid=r.sitemanagerid;
	if ds_id IS NULL THEN
		insert into site(
			  id,
			  name,			  
			  region,			  
			  location_address,			  
			  employee_number,			  
			  contact_name,			  
			  phone_number,			  
			  email,			  
			  type,			  
			  color,			  
			  comment,			  
			  lasttimestamp,			  
			  searchcondition,			  
			  searchcontainer,			  
			  class,			  
			  description,
			  isclosegroup,
			  sitemanagerid,
			  searchcontainertype,
			  matchtype,
			  newguid				  
			  )
			  values( 
			  r.id,			  
			  r.name,			  
			  r.region,			  
			  r.location_address,			  
			  r.employee_number,			  
			  r.contact_name,			  
			  r.phone_number,			  
			  r.email,			  
			  r.type,			  
			  r.color,			  
			  r.comment,			  
			  now(),  
			  r.searchcondition,			  
			  r.searchcontainer,			  
			  r.class,			  
			  r.description,
			  r.isclosegroup,
			  r.sitemanagerid,
			  r.searchcontainertype,
			  r.matchtype,
			  r.newguid	
			  );
		
	else
		update site set(
			  name,			  
			  region,			  
			  location_address,			  
			  employee_number,			  
			  contact_name,			  
			  phone_number,			  
			  email,			  
			  type,			  
			  color,			  
			  comment,			  
			  lasttimestamp,			  
			  searchcondition,			  
			  searchcontainer,			  
			  class,			  
			  description,
			  isclosegroup,
			  matchtype,
			  searchcontainertype,
			  newguid
			  ) = ( 			 
			  r.name,			  
			  r.region,			  
			  r.location_address,			  
			  r.employee_number,			  
			  r.contact_name,			  
			  r.phone_number,			  
			  r.email,			  
			  r.type,			  
			  r.color,			  
			  r.comment,			  
			  now(),
			  r.searchcondition,			  
			  r.searchcontainer,			  
			  r.class,			  
			  r.description,
			  r.isclosegroup,
			  r.matchtype,
			  r.searchcontainertype,
			  r.newguid
			  ) 
			  where id = r.id;		
	end if;

        delete from site2site where siteid=r.id;
        insert into site2site(siteid,parentid)values( r.id,parent_id);        

	return r.id;
EXCEPTION
	WHEN OTHERS THEN 
		RETURN -2;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION site_update(site, integer) OWNER TO postgres;


DROP FUNCTION view_devicegroupsiteview_retrieve(integer, integer, timestamp without time zone, integer, character varying, character varying);
DROP VIEW devicegroupsiteview;


CREATE OR REPLACE VIEW devicegroupsiteview AS 
 SELECT devicegroupsite.id, devicegroupsite.groupid AS devicegroupid, ( SELECT devicegroup.strname
           FROM devicegroup
          WHERE devicegroup.id = devicegroupsite.groupid) AS devicegroupname, devicegroupsite.siteid AS devicegroupsiteid, ( SELECT site.newguid
           FROM site
          WHERE site.id = devicegroupsite.siteid) AS devicegroupsitenameguid, devicegroupsite.sitechild
   FROM devicegroupsite;

ALTER TABLE devicegroupsiteview OWNER TO postgres;


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


DROP FUNCTION view_linkgroupsiteview_retrieve(integer, integer, timestamp without time zone, integer, character varying, character varying);
DROP VIEW linkgroupsiteview;


CREATE OR REPLACE VIEW linkgroupsiteview AS 
 SELECT linkgroup.id, linkgroupsite.siteid, ( SELECT site.newguid
           FROM site
          WHERE site.id = linkgroupsite.siteid) AS sitenameguid, linkgroupsite.sitechild
   FROM linkgroup, linkgroupsite
  WHERE linkgroupsite.groupid = linkgroup.id;

ALTER TABLE linkgroupsiteview OWNER TO postgres;


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


DROP FUNCTION view_linkgroup_dev_siteview_retrieve(integer, integer, timestamp without time zone, integer, character varying, character varying);
DROP VIEW linkgroup_dev_siteview;


CREATE OR REPLACE VIEW linkgroup_dev_siteview AS 
 SELECT linkgroup_dev_site.id, linkgroup_dev_site.groupid AS linkgroupid, ( SELECT linkgroup.strname
           FROM linkgroup
          WHERE linkgroup.id = linkgroup_dev_site.groupid) AS linkgroupname, linkgroup_dev_site.siteid, ( SELECT site.newguid
           FROM site
          WHERE site.id = linkgroup_dev_site.siteid) AS sitenameguid, linkgroup_dev_site.sitechild
   FROM linkgroup_dev_site;

ALTER TABLE linkgroup_dev_siteview OWNER TO postgres;


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



update system_info set ver=512;