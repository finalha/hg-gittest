\connect :nbwsp;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;
  


--------- site ---------
DROP TRIGGER site_dt ON site;
DROP FUNCTION process_site_dt();


ALTER TABLE site ADD COLUMN sitemanagerid integer;
ALTER TABLE site ALTER COLUMN sitemanagerid SET STORAGE PLAIN;
update site set sitemanagerid=0;
ALTER TABLE site ALTER COLUMN sitemanagerid SET NOT NULL;
ALTER TABLE site ALTER COLUMN sitemanagerid SET DEFAULT 0;


ALTER TABLE site ADD COLUMN matchtype integer;
ALTER TABLE site ALTER COLUMN matchtype SET STORAGE PLAIN;
update site set matchtype=0;
ALTER TABLE site ALTER COLUMN matchtype SET NOT NULL;
ALTER TABLE site ALTER COLUMN matchtype SET DEFAULT 0;


ALTER TABLE site ADD COLUMN searchcontainertype integer;
ALTER TABLE site ALTER COLUMN searchcontainertype SET STORAGE PLAIN;
update site set searchcontainertype=0;
ALTER TABLE site ALTER COLUMN searchcontainertype SET NOT NULL;
ALTER TABLE site ALTER COLUMN searchcontainertype SET DEFAULT 0;


ALTER TABLE site ADD COLUMN "class" integer;
ALTER TABLE site ALTER COLUMN "class" SET STORAGE PLAIN;
update site set "class"=0;
ALTER TABLE site ALTER COLUMN "class" SET NOT NULL;


ALTER TABLE site ADD COLUMN description text;
ALTER TABLE site ALTER COLUMN description SET STORAGE EXTENDED;


ALTER TABLE site ADD COLUMN isclosegroup boolean;
ALTER TABLE site ALTER COLUMN isclosegroup SET STORAGE PLAIN;
update site set isclosegroup=true;
ALTER TABLE site ALTER COLUMN isclosegroup SET NOT NULL;


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
			OLD.searchcontainertype=NEW.searchcontainertype
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
  
  
  
CREATE OR REPLACE FUNCTION site_update(r site, parent_id integer)
  RETURNS integer AS
$BODY$
declare	
	ds_id integer;
BEGIN		
	select id into ds_id from site where name=r.name and sitemanagerid=r.sitemanagerid;
	if ds_id IS NULL THEN
		insert into site(			  
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
			  matchtype				  
			  )
			  values( 			  
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
			  r.matchtype	
			  );
		select lastval() into ds_id;		
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
			  searchcontainertype
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
			  r.searchcontainertype
			  ) 
			  where id = ds_id;		
	end if;

        delete from site2site where siteid=ds_id;
        insert into site2site(siteid,parentid)values( ds_id,parent_id);        

	return ds_id;
EXCEPTION
	WHEN OTHERS THEN 
		RETURN -2;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION site_update(site, integer) OWNER TO postgres;




CREATE OR REPLACE FUNCTION site_delete(mid integer)
  RETURNS boolean AS
$BODY$
BEGIN	 
	delete from site2site where siteid in (select id from site where sitemanagerid=mid);
	delete from site where sitemanagerid=mid;
    RETURN true;
EXCEPTION
    WHEN OTHERS THEN 
	RETURN false;    
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION site_delete(integer) OWNER TO postgres;


DROP FUNCTION view_site_retrieve(integer, integer, timestamp without time zone, character varying);
DROP VIEW siteview;
CREATE OR REPLACE VIEW siteview AS 
 SELECT site.*,site2site.parentid, ( SELECT count(*) AS count
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




CREATE OR REPLACE FUNCTION site_503upgrade()
  RETURNS SETOF integer AS
$BODY$
declare
	r integer;
	dg_id integer;
BEGIN		
        for r in select id from site  LOOP
		select id into dg_id from site2site where parentid = r;
		if dg_id is null then
			update site set class=1 where id=r;			
		end if;
	end loop;	
	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION site_503upgrade() OWNER TO postgres;

--------- site ---------



--------- site border interface ---------
CREATE TABLE site_customized_borderinterface
(
  id serial NOT NULL,
  siteid integer NOT NULL,
  interfaceid integer NOT NULL,
  devicename character varying(256) NOT NULL,
  devicetype integer NOT NULL,
  interfacename character varying(256) NOT NULL,  
  inetfaceip character varying(128) NOT NULL,
  lasttimestamp timestamp without time zone NOT NULL DEFAULT now(), 
  CONSTRAINT site_customized_borderinterface_pk PRIMARY KEY (id),
  CONSTRAINT site_customized_borderinterface_site FOREIGN KEY (siteid)
      REFERENCES site (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT site_customized_borderinterface_un UNIQUE (siteid, devicename,interfacename)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE site_customized_borderinterface OWNER TO postgres;


CREATE OR REPLACE VIEW site_customized_borderinterfaceview AS 
select site_customized_borderinterface.*,site.sitemanagerid from site_customized_borderinterface,site where site_customized_borderinterface.siteid=site.id;
ALTER TABLE site_customized_borderinterfaceview OWNER TO postgres;



CREATE OR REPLACE FUNCTION site_customized_borderinterface_update(r site_customized_borderinterface)
  RETURNS integer AS
$BODY$
declare	
	ds_id integer;
BEGIN		
	select id into ds_id from site_customized_borderinterface where siteid=r.siteid and devicename=r.devicename and interfacename=r.interfacename ;
	if ds_id IS NULL THEN
		insert into site_customized_borderinterface(
			  siteid,
			  interfaceid,
			  devicename,
			  devicetype,
			  inetfaceip,
			  interfacename,			  			 
			  lasttimestamp				  
			  )
			  values( 
			  r.siteid,
			  r.interfaceid,
			  r.devicename,
			  r.devicetype,
			  r.inetfaceip,
			  r.interfacename,			  
			  now()
			  );
		return lastval();
	else		
		return ds_id;
	end if;
EXCEPTION
	WHEN OTHERS THEN 
		RETURN -2;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION site_customized_borderinterface_update(site_customized_borderinterface) OWNER TO postgres;
--------- site border interface ---------



--------- site device ---------
ALTER TABLE devicesitedevice ADD COLUMN "type" integer;
ALTER TABLE devicesitedevice ALTER COLUMN "type" SET STORAGE PLAIN;
COMMENT ON COLUMN devicesitedevice."type" IS 'Add/exclude/ calculate /dynamic';
update devicesitedevice set "type"=0;
ALTER TABLE devicesitedevice ALTER COLUMN "type" SET NOT NULL;


ALTER TABLE devicesitedevice ADD COLUMN lasttimestamp timestamp without time zone;
ALTER TABLE devicesitedevice ALTER COLUMN lasttimestamp SET STORAGE PLAIN;
ALTER TABLE devicesitedevice ALTER COLUMN lasttimestamp SET DEFAULT now();
update devicesitedevice set lasttimestamp=now();
ALTER TABLE devicesitedevice ALTER COLUMN lasttimestamp SET NOT NULL;


CREATE OR REPLACE VIEW devicesitedeviceview2 AS 
 select devicesitedevice.*,devices.strname, devices.isubtype,site.sitemanagerid from devicesitedevice, devices,site where devicesitedevice.deviceid = devices.id and devicesitedevice.siteid=site.id;
ALTER TABLE devicesitedeviceview2 OWNER TO postgres;



CREATE OR REPLACE FUNCTION devicesitedevice_delete(site_id integer)
  RETURNS boolean AS
$BODY$
BEGIN	 
	delete from devicesitedevice where siteid= site_id;
    RETURN true;
EXCEPTION
    WHEN OTHERS THEN 
	RETURN false;    
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION devicesitedevice_delete(integer) OWNER TO postgres;


CREATE OR REPLACE FUNCTION devicesitedevice_update(site_id integer, devtype integer[], devnames character varying[])
  RETURNS boolean AS
$BODY$
declare	
        site_to_device_id integer;
	device_id integer;
	r integer;
BEGIN		

	for r in  1..array_length(devnames,1) loop
		select id into device_id from devices where strname =devnames[r];
		if device_id IS NOT NULL THEN
			select id into site_to_device_id from devicesitedevice where siteid=site_id and deviceid =device_id;
			if site_to_device_id IS NULL THEN
				insert into devicesitedevice(
					  siteid,
					  deviceid,
					  type,				  		 
					  lasttimestamp				  
					  )
					  values( 
					  site_id,
					  device_id,
					  devtype[r],
					  now()
					  );
			else
				update devicesitedevice set(
				  type,
				  lasttimestamp
				  ) = ( 			 
				  devtype[r],		
				  now()			  
				  ) 
				  where id = site_to_device_id;	
			end if;				
		end if;	
		
	end loop;					
	return true;

	
EXCEPTION
	WHEN OTHERS THEN 
		return false;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION devicesitedevice_update(integer, integer[], character varying[]) OWNER TO postgres;


--------- site device ---------



--------- cluster ---------
CREATE TABLE sitecluster
(
  id serial NOT NULL,
  clustername character varying(256) NOT NULL,
  lasttimestamp timestamp without time zone NOT NULL DEFAULT now(),
  sitemanagerid integer NOT NULL DEFAULT 0,
  CONSTRAINT sitecluster_pk PRIMARY KEY (id),
  CONSTRAINT sitecluster_un UNIQUE (clustername, sitemanagerid)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE sitecluster OWNER TO postgres;


CREATE OR REPLACE FUNCTION siteclusterdelete(mid integer)
  RETURNS boolean AS
$BODY$
BEGIN	 
	delete from sitecluster where sitemanagerid=mid;
    RETURN true;
EXCEPTION
    WHEN OTHERS THEN 
	RETURN false;    
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION siteclusterdelete(integer) OWNER TO postgres;


CREATE OR REPLACE FUNCTION sitecluster_update(r sitecluster)
  RETURNS integer AS
$BODY$
declare	
	ds_id integer;
BEGIN		
	select id into ds_id from sitecluster where clustername=r.clustername and sitemanagerid=r.sitemanagerid;
	if ds_id IS NULL THEN
		insert into sitecluster(			  
			  clustername,
			  sitemanagerid,			  
			  lasttimestamp				  
			  )
			  values( 			  
			  r.clustername,
			  r.sitemanagerid,			  
			  now()
			  );
		return lastval();
	else		
		return ds_id;
	end if;
EXCEPTION
	WHEN OTHERS THEN 
		RETURN -2;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION sitecluster_update(sitecluster) OWNER TO postgres;



CREATE OR REPLACE FUNCTION view_sitecluster_retrieve(sid integer,mid integer)
  RETURNS SETOF sitecluster AS
$BODY$
declare
	r sitecluster%rowtype;	
BEGIN		
	for r in SELECT * FROM sitecluster where sitemanagerid=mid and  id in (select clusterid from site2sitecluster where siteid=sid) loop
		return next r;
	end loop;
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION view_sitecluster_retrieve(integer,integer) OWNER TO postgres;

--------- cluster ---------



--------- site to cluster ---------
CREATE TABLE site2sitecluster
(
  id serial NOT NULL,
  siteid integer NOT NULL,
  clusterid integer NOT NULL,
  lasttimestamp timestamp without time zone NOT NULL DEFAULT now(),
  CONSTRAINT site2sitecluster_pk PRIMARY KEY (id),
  CONSTRAINT site2sitecluster_cluster FOREIGN KEY (clusterid)
      REFERENCES sitecluster (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT site2sitecluster_site FOREIGN KEY (siteid)
      REFERENCES site (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT site2sitecluster_un UNIQUE (siteid, clusterid)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE site2sitecluster OWNER TO postgres;

-- Index: fki_site2sitecluster_cluster

-- DROP INDEX fki_site2sitecluster_cluster;

CREATE INDEX fki_site2sitecluster_cluster
  ON site2sitecluster
  USING btree
  (clusterid);

-- Index: fki_site2sitecluster_site

-- DROP INDEX fki_site2sitecluster_site;

CREATE INDEX fki_site2sitecluster_site
  ON site2sitecluster
  USING btree
  (siteid);


--------- site to cluster ---------




--------- cluster device ---------
CREATE TABLE sitecluster2device
(
  id serial NOT NULL,
  siteclusterid integer NOT NULL,
  deviceid integer NOT NULL,  
  lasttimestamp timestamp without time zone NOT NULL DEFAULT now(),
  CONSTRAINT sitecluster2device_pk PRIMARY KEY (id),
  CONSTRAINT sitecluster2device_cluster FOREIGN KEY (siteclusterid)
      REFERENCES sitecluster (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT sitecluster2device_device FOREIGN KEY (deviceid)
      REFERENCES devices (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT sitecluster2device_un UNIQUE (siteclusterid, deviceid)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE sitecluster2device OWNER TO postgres;

-- Index: fki_sitecluster2device_device

-- DROP INDEX fki_sitecluster2device_device;

CREATE INDEX fki_sitecluster2device_device
  ON sitecluster2device
  USING btree
  (deviceid);
  
  
  
 CREATE OR REPLACE VIEW sitecluster2deviceview AS 
 select sitecluster2device.*,devices.strname,devices.isubtype as devicetype,sitecluster.sitemanagerid from sitecluster2device,devices,sitecluster where sitecluster2device.deviceid=devices.id and sitecluster2device.siteclusterid=sitecluster.id;
ALTER TABLE sitecluster2deviceview OWNER TO postgres;


CREATE OR REPLACE FUNCTION sitecluster2device_delete(mid integer)
  RETURNS boolean AS
$BODY$
BEGIN	 
	delete from sitecluster2device where siteclusterid in (select id from  sitecluster where sitemanagerid=mid);
    RETURN true;
EXCEPTION
    WHEN OTHERS THEN 
	RETURN false;    
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION sitecluster2device_delete(integer) OWNER TO postgres;


CREATE OR REPLACE FUNCTION sitecluster2device_update(cluster_id integer, devnames character varying[])
  RETURNS boolean AS
$BODY$
declare		
	cluster_to_device_id integer;
	device_id integer;
	r integer;
BEGIN			
	for r in  1..array_length(devnames,1) loop
		select id into device_id from devices where strname =devnames[r];
		if device_id IS NOT NULL THEN
			select id into cluster_to_device_id from sitecluster2device where siteclusterid=cluster_id and deviceid =device_id;
			if cluster_to_device_id IS NULL THEN
				insert into sitecluster2device(
					  siteclusterid,
					  deviceid,				  	 
					  lasttimestamp				  
					  )
					  values( 
					  cluster_id,
					  device_id,				  
					  now()
					  );
			end if;				
		end if;	
		
	end loop;		
	return true;
EXCEPTION
	WHEN OTHERS THEN 
		RETURN false;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION sitecluster2device_update(integer, character varying[]) OWNER TO postgres;

--------- cluster device ---------



--------- global border interface ---------
CREATE TABLE globalborderinterface
(
  id serial NOT NULL,
  sitemanagerid integer NOT NULL DEFAULT 0,
  fieldtype integer NOT NULL,
  fieldvalue character varying(256) NOT NULL,
  lasttimestamp timestamp without time zone NOT NULL DEFAULT now(),  
  CONSTRAINT globalborderinterface_pk PRIMARY KEY (id),
  CONSTRAINT globalborderinterface_un UNIQUE (fieldtype, sitemanagerid,fieldvalue)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE globalborderinterface OWNER TO postgres;


CREATE OR REPLACE FUNCTION globalborderinterface_delete(mid integer)
  RETURNS boolean AS
$BODY$
BEGIN
	DELETE FROM globalborderinterface where sitemanagerid=mid;	
    RETURN true;
EXCEPTION
    WHEN OTHERS THEN 
	RETURN false;    
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION globalborderinterface_delete(integer) OWNER TO postgres;

CREATE OR REPLACE FUNCTION globalborderinterface_update(r globalborderinterface)
  RETURNS integer AS
$BODY$
declare	
	ds_id integer;
BEGIN		
	select id into ds_id from globalborderinterface where sitemanagerid=r.sitemanagerid and fieldtype=r.fieldtype and fieldvalue=r.fieldvalue;
	if ds_id IS NULL THEN
		insert into globalborderinterface(
			  sitemanagerid,
			  fieldtype,
			  fieldvalue,
			  lasttimestamp				  
			  )
			  values( 
			  r.sitemanagerid,
			  r.fieldtype,
			  r.fieldvalue,			  
			  now()
			  );
		return lastval();
	else		
		return ds_id;
	end if;
EXCEPTION
	WHEN OTHERS THEN 
		RETURN -2;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION globalborderinterface_update(globalborderinterface) OWNER TO postgres;






CREATE TABLE globalborderinterface_calculateresult
(
  id serial NOT NULL,
  sitemanagerid integer NOT NULL DEFAULT 0,
  interfaceid integer NOT NULL,
  deivcetype integer NOT NULL,
  devicename character varying(256) NOT NULL,
  interfacename character varying(256) NOT NULL,
  ip character varying(128) NOT NULL,
  description text,
  "type" integer NOT NULL, -- calculate /add/exclude
  lasttimestamp timestamp without time zone NOT NULL DEFAULT now(),  
  CONSTRAINT globalborderinterface_calculateresult_pk PRIMARY KEY (id),
  CONSTRAINT globalborderinterface_calculateresult_un UNIQUE (sitemanagerid,devicename, interfacename)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE globalborderinterface_calculateresult OWNER TO postgres;
COMMENT ON COLUMN globalborderinterface_calculateresult."type" IS 'calculate /add/exclude';


CREATE OR REPLACE FUNCTION globalborderinterfaceresult_delete(mid integer)
  RETURNS boolean AS
$BODY$
BEGIN
	DELETE FROM globalborderinterface_calculateresult WHERE sitemanagerid=mid;
    RETURN true;
EXCEPTION
    WHEN OTHERS THEN 
	RETURN false;    
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION globalborderinterfaceresult_delete(integer) OWNER TO postgres;

CREATE OR REPLACE FUNCTION globalborderinterfaceresult_update(r globalborderinterface_calculateresult)
  RETURNS integer AS
$BODY$
declare	
	ds_id integer;
BEGIN		
	select id into ds_id from globalborderinterface_calculateresult where sitemanagerid=r.sitemanagerid and interfacename=r.interfacename and devicename=r.devicename;
	if ds_id IS NULL THEN
		insert into globalborderinterface_calculateresult(
			  interfaceid,
			  ip,
			  description,
			  lasttimestamp,
			  sitemanagerid,
			  deivcetype,
			  interfacename,
			  devicename,
			  type				  
			  )
			  values( 
			  r.interfaceid,
			  r.ip,
			  r.description,			  
			  now(),
			  r.sitemanagerid,
			  r.deivcetype,
			  r.interfacename,
			  r.devicename,
			  r.type			  
			  );
		return lastval();
	else
		update globalborderinterface_calculateresult set(
			  ip,
			  description,
			  deivcetype,
			  type,			  
			  lasttimestamp
			  ) = ( 			 
			  r.ip,	
			  r.description,
			  r.deivcetype,	
			  r.type,			 
			  now()			  
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
ALTER FUNCTION globalborderinterfaceresult_update(globalborderinterface_calculateresult) OWNER TO postgres;
--------- global border interface ---------


--------- other ---------
CREATE OR REPLACE FUNCTION getdevicebyname(devname character varying)
  RETURNS integer AS
$BODY$
declare	
	ds_id integer;
BEGIN		
	select id into ds_id from devices where lower(strname)=lower(devname);
	
	if ds_id IS NULL THEN
		return -1;
	else		
		return ds_id;
	end if;
EXCEPTION
	WHEN OTHERS THEN 
		RETURN -2;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION getdevicebyname(character varying) OWNER TO postgres;

--------- other ---------




--------- site customeliza info -------------
CREATE OR REPLACE VIEW site_customized_infoview2 AS 
 select site_customized_info.*,object_customized_attribute.name,object_customized_attribute.alias,object_customized_attribute.allow_export,object_customized_attribute.type,object_customized_attribute.allow_modify_exported,site.name as sitename,site.sitemanagerid from site_customized_info,object_customized_attribute,site where site_customized_info.attributeid=object_customized_attribute.id and object_customized_attribute.objectid=5 and site_customized_info.objectid=site.id;

ALTER TABLE site_customized_infoview2 OWNER TO postgres;


CREATE OR REPLACE FUNCTION site_customized_info_update(r site_customized_info, filedname character varying)
  RETURNS integer AS
$BODY$
declare	
	attr_id integer;
	ds_id integer;
BEGIN		
	select id into attr_id from object_customized_attribute where name=filedname and objectid=5;
	if attr_id IS NULL THEN
		insert into object_customized_attribute (objectid,name,alias,allow_export,type,allow_modify_exported,lasttimestamp) values (5,filedname,filedname,'true',2,'true',now());
		select id into attr_id from object_customized_attribute where name=filedname;
	end if;

	select id into ds_id from site_customized_info where objectid=r.objectid and attributeid=attr_id;
	if ds_id IS NULL THEN
		insert into site_customized_info(
			  objectid,
			  attributeid,
			  attribute_value,			  			  			
			  lasttimestamp				  
			  )
			  values( 
			  r.objectid,
			  attr_id,
			  r.attribute_value,			  
			  now()
			  );
		return lastval();
	else		
	        update site_customized_info set attribute_value=r.attribute_value where id=ds_id;
		return ds_id;
	end if;
	
	
EXCEPTION
	WHEN OTHERS THEN 
		RETURN -2;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION site_customized_info_update(site_customized_info, character varying) OWNER TO postgres;

--------- site customeliza info -------------



CREATE TABLE clustersite2site
(
  id serial NOT NULL,
  clustersiteid integer NOT NULL,
  siteid integer NOT NULL,
  lasttimestamp timestamp without time zone NOT NULL DEFAULT now(),
  CONSTRAINT clustersite2site_pk PRIMARY KEY (id),
  CONSTRAINT clustersite2site_clustersite_fk FOREIGN KEY (clustersiteid)
      REFERENCES site (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT clustersite2site_site_fk FOREIGN KEY (siteid)
      REFERENCES site (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT clustersite2site_un UNIQUE (clustersiteid, siteid)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE clustersite2site OWNER TO postgres;

-- Index: fki_clustersite2site_clustersite_fk

-- DROP INDEX fki_clustersite2site_clustersite_fk;

CREATE INDEX fki_clustersite2site_clustersite_fk
  ON clustersite2site
  USING btree
  (clustersiteid);

-- Index: fki_clustersite2site_site_fk

-- DROP INDEX fki_clustersite2site_site_fk;

CREATE INDEX fki_clustersite2site_site_fk
  ON clustersite2site
  USING btree
  (siteid);





CREATE OR REPLACE VIEW site2siteclusterview AS 
         select site2sitecluster.*,sitecluster.clustername,site.name as sitename,site.sitemanagerid from site2sitecluster ,sitecluster,site where site2sitecluster.clusterid=sitecluster.id and site2sitecluster.siteid=site.id;

ALTER TABLE site2siteclusterview OWNER TO postgres;


CREATE OR REPLACE VIEW clustersite2siteview AS 
         select clustersite2site.*,(select name from site where id=clustersite2site.clustersiteid) as clustersitename,(select name from site where id=clustersite2site.siteid) as sitename,(select sitemanagerid from site where id=clustersite2site.clustersiteid) as sitemanagerid from clustersite2site;

ALTER TABLE clustersite2siteview OWNER TO postgres;


CREATE OR REPLACE FUNCTION site2sitecluster_update(site_id integer, cluname character varying[])
  RETURNS boolean AS
$BODY$
declare	
        clu_id integer;
	ds_id integer;
	r integer;
BEGIN		
	for r in  1..array_length(cluname,1) loop
		select id into clu_id from sitecluster where clustername =cluname[r];
		if clu_id IS NOT NULL THEN
			select id into ds_id from site2sitecluster where siteid=site_id and clusterid=clu_id ;
			if ds_id IS NULL THEN
				insert into site2sitecluster(
				  siteid,
				  clusterid,			  			  	
				  lasttimestamp				  
				  )
				  values(
				  site_id, 			  
				  clu_id,			  		   
				  now()
				  );
			end if;				
		end if;			
	end loop;		
	return true;
EXCEPTION
	WHEN OTHERS THEN 
		RETURN false;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION site2sitecluster_update(integer, character varying[]) OWNER TO postgres;


CREATE OR REPLACE FUNCTION clustersite2site_update(clustersite_id integer, sitename character varying[])
  RETURNS boolean AS
$BODY$
declare		
        site_id integer;
	ds_id integer;
	r integer;
BEGIN		
	for r in  1..array_length(sitename,1) loop
		select id into site_id from site where name= sitename[r];	
		if site_id IS NOT NULL THEN
			select id into ds_id from clustersite2site where siteid=site_id and clustersiteid=clustersite_id ;
			if ds_id IS NULL THEN
				insert into clustersite2site(
					  siteid,
					  clustersiteid,			  			  		
					  lasttimestamp				  
					  )
					  values( 
					  site_id,
					  clustersite_id,			   
					  now()
				);
			end if;	
		end if;			
	end loop;
	return true;
EXCEPTION
	WHEN OTHERS THEN 
		RETURN false;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION clustersite2site_update(integer, character varying[]) OWNER TO postgres;




CREATE OR REPLACE FUNCTION sitecluster_olddelete(clusternames character varying[])
  RETURNS boolean AS
$BODY$

BEGIN
	delete from sitecluster where clustername <> all(clusternames);
	return true;
EXCEPTION    
	WHEN OTHERS THEN   
		return false;
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION sitecluster_olddelete(character varying[]) OWNER TO postgres;



CREATE OR REPLACE FUNCTION site_olddelete(sitenames character varying[])
  RETURNS boolean AS
$BODY$

BEGIN
	delete from site where "name" <> all(sitenames);	
	return true;
EXCEPTION    
	WHEN OTHERS THEN   
		return false;		
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION site_olddelete(character varying[]) OWNER TO postgres;



CREATE OR REPLACE FUNCTION sitecluster2device_delete(cluster_id integer)
  RETURNS boolean AS
$BODY$
BEGIN	 
	delete from sitecluster2device where siteclusterid =cluster_id;
    RETURN true;
EXCEPTION
    WHEN OTHERS THEN 
	RETURN false;    
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION sitecluster2device_delete(integer) OWNER TO postgres;


CREATE OR REPLACE FUNCTION site_customized_borderinterface_delete(site_id integer)
  RETURNS boolean AS
$BODY$
BEGIN	 
	delete from site_customized_borderinterface where siteid =site_id;
    RETURN true;
EXCEPTION
    WHEN OTHERS THEN 
	RETURN false;    
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION site_customized_borderinterface_delete(integer) OWNER TO postgres;


CREATE OR REPLACE FUNCTION site_customized_attribute_delete(site_id integer)
  RETURNS boolean AS
$BODY$
BEGIN	 
	delete from object_customized_attribute where objectid=5 and objectid=site_id;
    RETURN true;
EXCEPTION
    WHEN OTHERS THEN 
	RETURN false;    
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION site_customized_attribute_delete(integer) OWNER TO postgres;


CREATE OR REPLACE FUNCTION site2sitecluster_delete(site_id integer)
  RETURNS boolean AS
$BODY$
BEGIN	 
	delete from site2sitecluster where siteid=site_id;
    RETURN true;
EXCEPTION
    WHEN OTHERS THEN 
	RETURN false;    
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION site2sitecluster_delete(integer) OWNER TO postgres;


CREATE OR REPLACE FUNCTION clustersite2site_delete(site_id integer)
  RETURNS boolean AS
$BODY$
BEGIN	 
	delete from clustersite2site where clustersiteid=site_id;
    RETURN true;
EXCEPTION
    WHEN OTHERS THEN 
	RETURN false;    
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION clustersite2site_delete(integer) OWNER TO postgres;




INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, lasttimestamp)VALUES ( -1, 11, 0, 'SiteActionPane.xml', 'e61f01xfwg64a8aa17wefwtsg066e124.xml', now(), -1,now());


INSERT INTO globalborderinterface(sitemanagerid, fieldtype, fieldvalue, lasttimestamp) VALUES (0, 0, 'Serial;ATM;POS;Multilink;Dialer', now());


ALTER TABLE sys_option ADD COLUMN op_strvalue character varying(256);
ALTER TABLE sys_option ALTER COLUMN op_strvalue SET STORAGE EXTENDED;


INSERT INTO sys_option(op_name, op_value, op_strvalue)VALUES ('startpageoption',0, '');



update system_info set ver=503;