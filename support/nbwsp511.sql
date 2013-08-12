\connect workspace1

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;



ALTER TABLE site ADD COLUMN newguid character varying(256);
ALTER TABLE site ALTER COLUMN newguid SET STORAGE EXTENDED;

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


update system_info set ver=511;