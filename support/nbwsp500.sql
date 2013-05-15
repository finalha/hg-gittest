\connect :nbwsp

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;
  
ALTER TABLE benchmarktask ADD COLUMN bgpnbr integer;
ALTER TABLE benchmarktask ALTER COLUMN bgpnbr SET STORAGE PLAIN;
ALTER TABLE benchmarktask ALTER COLUMN bgpnbr SET DEFAULT 1;
update benchmarktask set bgpnbr=0;
ALTER TABLE benchmarktask ALTER COLUMN bgpnbr SET NOT NULL;


INSERT INTO objtimestamp (typename, modifytime) VALUES ('SystemVariable', '1900-01-01 00:00:00');


CREATE OR REPLACE FUNCTION processSystemVariable_dt()
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
ALTER FUNCTION processSystemVariable_dt() OWNER TO postgres;


CREATE TRIGGER domain_name_dt
  BEFORE INSERT OR UPDATE OR DELETE
  ON domain_name
  FOR EACH ROW
  EXECUTE PROCEDURE processSystemVariable_dt();


CREATE TRIGGER domain_option_dt
  BEFORE INSERT OR UPDATE OR DELETE
  ON domain_option
  FOR EACH ROW
  EXECUTE PROCEDURE processSystemVariable_dt();


CREATE TRIGGER sys_environmentvariable_dt
  BEFORE INSERT OR UPDATE OR DELETE
  ON sys_environmentvariable
  FOR EACH ROW
  EXECUTE PROCEDURE processSystemVariable_dt();



DROP FUNCTION view_site_retrieve(integer, integer, timestamp without time zone, character varying);
DROP VIEW siteview;
DROP TRIGGER site_dt ON site;
DROP FUNCTION process_site_dt();



ALTER TABLE site ADD COLUMN searchcondition text;
ALTER TABLE site ALTER COLUMN searchcondition SET STORAGE EXTENDED;
update site set searchcondition='';

ALTER TABLE site ADD COLUMN searchcontainer integer;
ALTER TABLE site ALTER COLUMN searchcontainer SET STORAGE PLAIN;
ALTER TABLE site ALTER COLUMN searchcontainer SET DEFAULT (-1);
update site set searchcontainer=-1;


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


DROP FUNCTION site_addormodify(integer, site);

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


CREATE OR REPLACE VIEW siteview AS 
 SELECT site.id, site2site.parentid, site.name, site.region, site.location_address, site.employee_number, site.contact_name, site.phone_number, site.email, site.type, site.color, site.comment, site.lasttimestamp,site.searchcondition,site.searchcontainer, ( SELECT count(*) AS count
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



INSERT INTO object_file_path_info(path, lasttimestamp, path_update_time, object_type) VALUES ('ReviewTaskProperty', now(), now(), 10);
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 10, 0, 'ReviewTaskProperty.zip', '0211e9bbec2c4347a4f2393c838702a1.zip', now(), 1,'',now(),(select id from object_file_path_info where path='ReviewTaskProperty' ));



INSERT INTO object_file_path_info(parentid, path, lasttimestamp, path_update_time, object_type)VALUES (null,'Qmap Learning Center',now(),now(),7);
INSERT INTO object_file_path_info(parentid, path, lasttimestamp, path_update_time, object_type)VALUES ((select id from object_file_path_info where path='Qmap Learning Center'),'All Essential Qmaps',now(),now(),7);
INSERT INTO object_file_path_info(parentid, path, lasttimestamp, path_update_time, object_type)VALUES ((select id from object_file_path_info where path='All Essential Qmaps'),'BGP',now(),now(),7);
INSERT INTO object_file_path_info(parentid, path, lasttimestamp, path_update_time, object_type)VALUES ((select id from object_file_path_info where path='All Essential Qmaps'),'EIGRP',now(),now(),7);
INSERT INTO object_file_path_info(parentid, path, lasttimestamp, path_update_time, object_type)VALUES ((select id from object_file_path_info where path='All Essential Qmaps'),'Frame Relay',now(),now(),7);
INSERT INTO object_file_path_info(parentid, path, lasttimestamp, path_update_time, object_type)VALUES ((select id from object_file_path_info where path='All Essential Qmaps'),'MPLS',now(),now(),7);
INSERT INTO object_file_path_info(parentid, path, lasttimestamp, path_update_time, object_type)VALUES ((select id from object_file_path_info where path='All Essential Qmaps'),'Multicast',now(),now(),7);
INSERT INTO object_file_path_info(parentid, path, lasttimestamp, path_update_time, object_type)VALUES ((select id from object_file_path_info where path='All Essential Qmaps'),'OSPF',now(),now(),7);
INSERT INTO object_file_path_info(parentid, path, lasttimestamp, path_update_time, object_type)VALUES ((select id from object_file_path_info where path='All Essential Qmaps'),'RIP',now(),now(),7);
INSERT INTO object_file_path_info(parentid, path, lasttimestamp, path_update_time, object_type)VALUES ((select id from object_file_path_info where path='Qmap Learning Center'),'All Trap Qmaps',now(),now(),7);
INSERT INTO object_file_path_info(parentid, path, lasttimestamp, path_update_time, object_type)VALUES ((select id from object_file_path_info where path='All Trap Qmaps'),'BGP',now(),now(),7);
INSERT INTO object_file_path_info(parentid, path, lasttimestamp, path_update_time, object_type)VALUES ((select id from object_file_path_info where path='All Trap Qmaps'),'EIGRP',now(),now(),7);
INSERT INTO object_file_path_info(parentid, path, lasttimestamp, path_update_time, object_type)VALUES ((select id from object_file_path_info where path='All Trap Qmaps'),'Frame Relay',now(),now(),7);
INSERT INTO object_file_path_info(parentid, path, lasttimestamp, path_update_time, object_type)VALUES ((select id from object_file_path_info where path='All Trap Qmaps'),'MPLS',now(),now(),7);
INSERT INTO object_file_path_info(parentid, path, lasttimestamp, path_update_time, object_type)VALUES ((select id from object_file_path_info where path='All Trap Qmaps'),'Multicast',now(),now(),7);
INSERT INTO object_file_path_info(parentid, path, lasttimestamp, path_update_time, object_type)VALUES ((select id from object_file_path_info where path='All Trap Qmaps'),'OSPF',now(),now(),7);
INSERT INTO object_file_path_info(parentid, path, lasttimestamp, path_update_time, object_type)VALUES ((select id from object_file_path_info where path='All Trap Qmaps'),'RIP',now(),now(),7);
INSERT INTO object_file_path_info(parentid, path, lasttimestamp, path_update_time, object_type)VALUES ((select id from object_file_path_info where path='All Trap Qmaps'),'Routing Protocol Redistribution and Filtering',now(),now(),7);
INSERT INTO object_file_path_info(parentid, path, lasttimestamp, path_update_time, object_type)VALUES ((select id from object_file_path_info where path='All Trap Qmaps'),'Security',now(),now(),7);
INSERT INTO object_file_path_info(parentid, path, lasttimestamp, path_update_time, object_type)VALUES ((select id from object_file_path_info where path='All Trap Qmaps'),'Switching',now(),now(),7);
INSERT INTO object_file_path_info(parentid, path, lasttimestamp, path_update_time, object_type)VALUES ((select id from object_file_path_info where path='All Trap Qmaps'),'Wan',now(),now(),7);


INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'BGP Aggregation.qmap', '26b7ba4da3244c03bf4066f51405c2b0.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='BGP' and parentid=(select id from object_file_path_info where path='All Essential Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'BGP Aggregation with Summary Only.qmap', '51a5e4259ac7473ba6bed4b2c26686f8.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='BGP' and parentid=(select id from object_file_path_info where path='All Essential Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'BGP Aggregation with Suppress Maps.qmap', '8730dee6755e42beaed9a028c045043a.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='BGP' and parentid=(select id from object_file_path_info where path='All Essential Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'BGP Bestpath Selection - AS-Path.qmap', '9ab466eebb1146098121b89639dde4dd.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='BGP' and parentid=(select id from object_file_path_info where path='All Essential Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'BGP Local Preference.qmap', 'd00e933f3c8a4ea98b88bd9709300cc9.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='BGP' and parentid=(select id from object_file_path_info where path='All Essential Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'BGP Bestpath Selection - MED.qmap', '20ca6cae798c4d1f9871e477aba22cab.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='BGP' and parentid=(select id from object_file_path_info where path='All Essential Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'BGP Bestpath Selection - Origin.qmap', 'a5e083facaf44d7bac994416c106ef37.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='BGP' and parentid=(select id from object_file_path_info where path='All Essential Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'BGP Communities-Local AS.qmap', '7d5349a262c64fc5b798816511a4d8d9.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='BGP' and parentid=(select id from object_file_path_info where path='All Essential Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'BGP Communities-no advertise.qmap', 'c6f1bd4600744c3889e91a391dc2689e.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='BGP' and parentid=(select id from object_file_path_info where path='All Essential Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'BGP Community - Local Precedence.qmap', '558df0fbba1d4b14a80fcb15621b1823.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='BGP' and parentid=(select id from object_file_path_info where path='All Essential Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'BGP Community Values.qmap', '3e928bc4c48748269cc289964ef7b1ca.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='BGP' and parentid=(select id from object_file_path_info where path='All Essential Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'BGP confederation.qmap', 'b74113321db4457d97513ecb616b6326.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='BGP' and parentid=(select id from object_file_path_info where path='All Essential Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'BGP Dampening.qmap', '513f37d44ad744fd9c80cb4aa608cf07.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='BGP' and parentid=(select id from object_file_path_info where path='All Essential Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'BGP Default Routing.qmap', 'af3670289b764351aa5c12dea7da54e9.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='BGP' and parentid=(select id from object_file_path_info where path='All Essential Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'BGP Peer Groups and Backdoors.qmap', 'd4b72da7af89470291cc8328026e19cc.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='BGP' and parentid=(select id from object_file_path_info where path='All Essential Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'BGP Redistributing OSPF.qmap', '765c64642ef04d8c989a12477fd8d65f.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='BGP' and parentid=(select id from object_file_path_info where path='All Essential Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'BGP Route Filtering.qmap', 'c83d6bff947e4560874705a26e543047.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='BGP' and parentid=(select id from object_file_path_info where path='All Essential Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'BGP Route Reflector.qmap', '96830fe8d9f14d2b9df323c0884f6f22.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='BGP' and parentid=(select id from object_file_path_info where path='All Essential Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'EIGRP Default-Route Propagation.qmap', 'b8173b478eb24058bbebe25fda9ecdb9.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='EIGRP' and parentid=(select id from object_file_path_info where path='All Essential Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'EIGRP Duplicate Router-ID.qmap', 'fd2114d5bfa64f729349b4e4abb56594.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='EIGRP' and parentid=(select id from object_file_path_info where path='All Essential Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'EIGRP Filtering by Metric.qmap', 'eacc46e920c142e6a29e652c0dc6d1c2.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='EIGRP' and parentid=(select id from object_file_path_info where path='All Essential Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'EIGRP Filtering by Route Tag.qmap', '72f137d17aee412c94672e3c9e3ec9b9.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='EIGRP' and parentid=(select id from object_file_path_info where path='All Essential Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'EIGRP Link Backup with Summarization.qmap', '9845beb6beaa4e829ed8ac0ab0eaf070.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='EIGRP' and parentid=(select id from object_file_path_info where path='All Essential Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'EIGRP Passive Interfaces.qmap', 'f9ae667449ea40dcbca7fefa479b0cec.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='EIGRP' and parentid=(select id from object_file_path_info where path='All Essential Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'EIGRP Stub with Leak-Map.qmap', '8c81aeae7bdb4fe3be7209ea63e43c92.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='EIGRP' and parentid=(select id from object_file_path_info where path='All Essential Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'EIGRP Unequal Cost Load-Balancing.qmap', '0d93ccf1bf6f43929a36304cd8ba8031.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='EIGRP' and parentid=(select id from object_file_path_info where path='All Essential Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'EIGRP Unreachable Loopback.qmap', '107366cf3f904f268cab5f72159729f1.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='EIGRP' and parentid=(select id from object_file_path_info where path='All Essential Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'Frame Relay Using Inverse ARP.qmap', 'a40c3d65d405489087acd5f88a5336da.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='Frame Relay' and parentid=(select id from object_file_path_info where path='All Essential Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'Frame Relay without Using Inverse ARP.qmap', 'da8c3eb5a0854a6686c42063e58b8eff.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='Frame Relay' and parentid=(select id from object_file_path_info where path='All Essential Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'MPLS VRF Lite.qmap', 'fd6509e77d6f415c9dd161673e70f96c.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='MPLS' and parentid=(select id from object_file_path_info where path='All Essential Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'Designated Router.qmap', 'f12970c6a68f4357965f24e7d506093e.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='Multicast' and parentid=(select id from object_file_path_info where path='All Essential Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'IGMP Filter.qmap', '80f201cea5cf4db49cc9842ee60290ed.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='Multicast' and parentid=(select id from object_file_path_info where path='All Essential Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'PIM Dense Mode.qmap', 'aee6221aca6542b48c62c5ce599a2b70.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='Multicast' and parentid=(select id from object_file_path_info where path='All Essential Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'PIM Sparse Mode.qmap', '609efa27b2d043a88bbcdfdb5fc54f46.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='Multicast' and parentid=(select id from object_file_path_info where path='All Essential Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'PIM Sparse-Dense Mode.qmap', '9c96615374304c4e80d6e96891f53a1a.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='Multicast' and parentid=(select id from object_file_path_info where path='All Essential Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'OSPF Database Filter.qmap', 'a26eca01dfd94bba9edefb36c1eb2577.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='OSPF' and parentid=(select id from object_file_path_info where path='All Essential Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'OSPF Default Routing.qmap', '77c90f01e6a64cdc9d878b1abb4d5ed5.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='OSPF' and parentid=(select id from object_file_path_info where path='All Essential Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'OSPF Distribute-List.qmap', '32306d15e3a34fd39bbb3851dd308deb.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='OSPF' and parentid=(select id from object_file_path_info where path='All Essential Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'OSPF External Summarization.qmap', 'd612c5a15a7647059fba617fda1504aa.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='OSPF' and parentid=(select id from object_file_path_info where path='All Essential Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'OSPF Filtering with AD.qmap', 'dc3793b8fa6843a98b058fcdd283c52c.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='OSPF' and parentid=(select id from object_file_path_info where path='All Essential Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'OSPF Filtering with Route-Maps.qmap', 'e509320899dd4c6ea0cbad79a035a070.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='OSPF' and parentid=(select id from object_file_path_info where path='All Essential Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'OSPF Internal Summarization.qmap', '7bde6f721bf0484dbaeb7c03f1749de9.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='OSPF' and parentid=(select id from object_file_path_info where path='All Essential Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'OSPF LSA Type-3 Filtering.qmap', '61d63cd482304e5b81d2ac5fe3a1b127.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='OSPF' and parentid=(select id from object_file_path_info where path='All Essential Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'OSPF MD5 authentication.qmap', '14e8c5c43b4c4f1c848eacd47dd77374.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='OSPF' and parentid=(select id from object_file_path_info where path='All Essential Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'OSPF Not-So-Stubby Areas.qmap', '938073bcf3e14f3888be2719c31d6531.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='OSPF' and parentid=(select id from object_file_path_info where path='All Essential Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'OSPF over FR P-to-P Network.qmap', 'e246d8b49b814f00ba7e58fdc7c7908f.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='OSPF' and parentid=(select id from object_file_path_info where path='All Essential Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'OSPF over Broadcast Media.qmap', 'ab8d1fd383844a7abdd51266813ffcc8.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='OSPF' and parentid=(select id from object_file_path_info where path='All Essential Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'OSPF over Non-Broadcast Media.qmap', '0c0489aa95cf442e8102212aabb528b9.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='OSPF' and parentid=(select id from object_file_path_info where path='All Essential Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'OSPF Path Selection with Bandwidth.qmap', 'a5d647bc463548a2b58b295556a3350d.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='OSPF' and parentid=(select id from object_file_path_info where path='All Essential Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'OSPF Path Selection with cost.qmap', '6fd60edfbbf44278ae73f1a58dbb0ea4.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='OSPF' and parentid=(select id from object_file_path_info where path='All Essential Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'OSPF Stub Area.qmap', '2ed01320440c4075b025c8fcc608c87a.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='OSPF' and parentid=(select id from object_file_path_info where path='All Essential Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'OSPF Summarization and Discard Route.qmap', 'b0ee58f1ca434516a388be458c17f69a.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='OSPF' and parentid=(select id from object_file_path_info where path='All Essential Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'OSPF Totally Stubby Areas.qmap', 'c81429ed5c2f4225b3efa1926abcd62f.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='OSPF' and parentid=(select id from object_file_path_info where path='All Essential Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'OSPF Virtual links.qmap', '17fd0adc20b448b7a7446ca54ea9bd9c.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='OSPF' and parentid=(select id from object_file_path_info where path='All Essential Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'RIP and OSPF Redistribution.qmap', '54ee9451031b48e69ca248fe20a2950b.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='RIP' and parentid=(select id from object_file_path_info where path='All Essential Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'RIP Default Routing.qmap', 'fcccb382d47446c9ac4ca43231a83fe0.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='RIP' and parentid=(select id from object_file_path_info where path='All Essential Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'RIP Filter with per neigbor AD.qmap', 'c301f3bea9494c4bb9f8e2d59a4f62e9.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='RIP' and parentid=(select id from object_file_path_info where path='All Essential Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'RIP Route Filtering using distribute-list.qmap', '7a0f8525503c4511a33f6e481d1fbd97.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='RIP' and parentid=(select id from object_file_path_info where path='All Essential Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'RIP send and receive versions.qmap', '098d78b28879425083a57ed5e7ec5c42.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='RIP' and parentid=(select id from object_file_path_info where path='All Essential Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'RIPv2 Authentication.qmap', '4a192fec00c746ecbd701e6b3e1e652b.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='RIP' and parentid=(select id from object_file_path_info where path='All Essential Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'RIPv2 Auto-summary.qmap', 'cf54590a6d5248a29b089268add3cdaa.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='RIP' and parentid=(select id from object_file_path_info where path='All Essential Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'RIPV2 Filtering with Prefix-list.qmap', '423da8430c2a49e6973b092fcede46ea.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='RIP' and parentid=(select id from object_file_path_info where path='All Essential Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'RIPv2 Offset List.qmap', '877fdcae092247328d7f3b9bbc45e771.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='RIP' and parentid=(select id from object_file_path_info where path='All Essential Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'RIPv2 Unicast Update.qmap', 'b744cc5d948841f28250658d4aad997d.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='RIP' and parentid=(select id from object_file_path_info where path='All Essential Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'BGP Aggregation.qmap', 'c3d2534b847742178d26118896ab91b7.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='BGP' and parentid=(select id from object_file_path_info where path='All Trap Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'BGP AS path prepending.qmap', '9e8ba9e2dc1a42e9bf7a4ac5dd3074d3.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='BGP' and parentid=(select id from object_file_path_info where path='All Trap Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'EBGP neighbors across frame-relay.qmap', '48a5405de68f4e98ac0769d363f20673.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='BGP' and parentid=(select id from object_file_path_info where path='All Trap Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'BGP aggregate-address.qmap', '93ba214767ac4eda9425e7c1b79f3e9d.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='BGP' and parentid=(select id from object_file_path_info where path='All Trap Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'Peer with ''strangers'' in BGP.qmap', '57ea1700a362442f9bac71654fb934da.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='BGP' and parentid=(select id from object_file_path_info where path='All Trap Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'Peering with EBGP.qmap', 'ee86f98864064354a8836286f72290a0.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='BGP' and parentid=(select id from object_file_path_info where path='All Trap Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'Redistributing connected routes into BGP.qmap', 'd0794de55e3a4eab9d50cfc3797f4df8.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='BGP' and parentid=(select id from object_file_path_info where path='All Trap Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'Configure EIGRP hello & hold time.qmap', 'd855c5645bd34111ae89a10e90e56b82.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='EIGRP' and parentid=(select id from object_file_path_info where path='All Trap Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'EIGRP Auto-Summary & Split-Horizon.qmap', '215037fecb0e4cf0a833f552a4119691.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='EIGRP' and parentid=(select id from object_file_path_info where path='All Trap Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'Hub-and-Spoke EIGRP over Frame-Relay.qmap', '87c05155cd5f4807a30385608e18cfe2.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='EIGRP' and parentid=(select id from object_file_path_info where path='All Trap Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'Secure VLAN for EIGRP Neighbor.qmap', 'f914bf0a990c496dbf1c6a281f215700.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='EIGRP' and parentid=(select id from object_file_path_info where path='All Trap Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'Stub Routers with ''connected''.qmap', '681d3d56d90148fd84201474aa34c868.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='EIGRP' and parentid=(select id from object_file_path_info where path='All Trap Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'Unequal Load Balance for EIGRP.qmap', '935a3471aed947bdb89542319639314d.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='EIGRP' and parentid=(select id from object_file_path_info where path='All Trap Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'Broadcast_keyword_in_frame-relay_map.qmap', '3ad5c7e03ef6461aab18e9213e163a3f.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='Frame Relay' and parentid=(select id from object_file_path_info where path='All Trap Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'Frame Relay with Inverse ARP.qmap', 'd69594549c3b4a13a760e90379f9e493.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='Frame Relay' and parentid=(select id from object_file_path_info where path='All Trap Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'Frame-relay traffic fragmentation.qmap', '5581ff8ac011458d9a135777dbd04df1.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='Frame Relay' and parentid=(select id from object_file_path_info where path='All Trap Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'Pinging oneself in Frame-Relay.qmap', 'a9f0cdca24864cac9e83852aa34292a7.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='Frame Relay' and parentid=(select id from object_file_path_info where path='All Trap Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'Shape Frame-Relay traffic with the DE bit.qmap', '34fc6440935d43628e2feb11939273fe.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='Frame Relay' and parentid=(select id from object_file_path_info where path='All Trap Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'OSPF between MPLS PE and CE.qmap', '6368f8b904454c2aaf545f4304f1b8ce.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='MPLS' and parentid=(select id from object_file_path_info where path='All Trap Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'Control Multicast Flow.qmap', 'a11ccb9c3b814b399c9f7b06f6501de0.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='Multicast' and parentid=(select id from object_file_path_info where path='All Trap Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'Conditional OSPF default route.qmap', 'b7e8fa8481054f8daf12ef4a4e3e2a1b.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='OSPF' and parentid=(select id from object_file_path_info where path='All Trap Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'Configure OSPF over GRE Tunnel.qmap', 'fa3bdc024419456a8ddce7ea7960c54c.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='OSPF' and parentid=(select id from object_file_path_info where path='All Trap Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'Configuring MAC filter.qmap', '464696befc6747c6bcaa88a9d1a1682d.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='OSPF' and parentid=(select id from object_file_path_info where path='All Trap Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'Configuring Voice VLAN.qmap', '0cbe5031b73d4469be7233b55e076b2f.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='OSPF' and parentid=(select id from object_file_path_info where path='All Trap Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'Hub-and-Spoke OSPF.qmap', '9fe6ca4310a14fd7971855ca94d666ef.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='OSPF' and parentid=(select id from object_file_path_info where path='All Trap Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'MTU mismatch in OSPF area.qmap', 'b49c2931dc8b45998d9994f40c81de7e.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='OSPF' and parentid=(select id from object_file_path_info where path='All Trap Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'OSPF in NBMA environment.qmap', '31993574ef27473eb546045bc19f5276.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='OSPF' and parentid=(select id from object_file_path_info where path='All Trap Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'Secondary Addresses.qmap', 'e3a7026c39a44826bb2cbf394d1399e5.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='OSPF' and parentid=(select id from object_file_path_info where path='All Trap Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'OSPF Path Selection with cost.qmap', '985f230312244d509f5fa0f38ff63a97.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='OSPF' and parentid=(select id from object_file_path_info where path='All Trap Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'OSPF redistribution metric-type.qmap', 'a17abbef8df4485a95861aa8dd1a3491.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='OSPF' and parentid=(select id from object_file_path_info where path='All Trap Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'OSPF sub-second hello interval.qmap', '4e56ee4fb3f34e4e894942daa3b1b435.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='OSPF' and parentid=(select id from object_file_path_info where path='All Trap Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'Stub router.qmap', '34884ca20b8c4fc2ac62ae861b1fc14b.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='OSPF' and parentid=(select id from object_file_path_info where path='All Trap Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'Virtual-link in OSPF.qmap', 'a24cfdded2a6440687de3324cbf0c986.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='OSPF' and parentid=(select id from object_file_path_info where path='All Trap Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'Filter RIP routes without distribute-list.qmap', '565c647629a644c29cb11bcc8d46faf1.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='RIP' and parentid=(select id from object_file_path_info where path='All Trap Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'RIP triggered updates.qmap', '1ea430d4c77e40feb63dd297975f6e7c.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='RIP' and parentid=(select id from object_file_path_info where path='All Trap Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'RIP unicast updates with ip NAT.qmap', '206dc42d06b44f888d21104ecf67ccf2.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='RIP' and parentid=(select id from object_file_path_info where path='All Trap Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'How to ignore odd routes.qmap', 'a92fa7b2ea2b43a1adb8198ee062ef7a.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='RIP' and parentid=(select id from object_file_path_info where path='All Trap Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'ACL with ''established'' keyword.qmap', '4eacae28fb584694b3f4c8f2127f1eb0.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='Routing Protocol Redistribution and Filtering' and parentid=(select id from object_file_path_info where path='All Trap Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'Use ''distance'' in Redistribution.qmap', 'fa95520b03d648a79bcee9ea62e64756.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='Routing Protocol Redistribution and Filtering' and parentid=(select id from object_file_path_info where path='All Trap Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'Control Redistribution Range.qmap', 'bcccc15bef0d4e2193745b459d822aba.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='Routing Protocol Redistribution and Filtering' and parentid=(select id from object_file_path_info where path='All Trap Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'Use Route Tag.qmap', '050ca71907fd4bc4aa4a2b41a3987500.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='Routing Protocol Redistribution and Filtering' and parentid=(select id from object_file_path_info where path='All Trap Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'Alias and grep commands.qmap', 'ab776dc4d56b4ea28008e01b6c5f9712.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='Security' and parentid=(select id from object_file_path_info where path='All Trap Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'Configuring Embedded Event Manager.qmap', 'c51317ec83c4434eb77561b729a2aa3f.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='Security' and parentid=(select id from object_file_path_info where path='All Trap Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'Using MQC.qmap', 'e6fc1d8b74b1480db282b5044ff4318f.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='Security' and parentid=(select id from object_file_path_info where path='All Trap Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'Stub Routers with ''connected''.qmap', '4afcca5d74124ee9929f902b0f614b26.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='Security' and parentid=(select id from object_file_path_info where path='All Trap Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'Time-Based ACL.qmap', 'dd8fa5626ac5401ea17ed1b62117f761.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='Security' and parentid=(select id from object_file_path_info where path='All Trap Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, '802.1Q Trunk Native VLAN.qmap', 'd8163478fe624bc1b65771d97370b3a1.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='Switching' and parentid=(select id from object_file_path_info where path='All Trap Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'Change_Spanning-tree_Root_Bridge.qmap', 'a7d4d0c6978f4dc59d44b93775534a0f.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='Switching' and parentid=(select id from object_file_path_info where path='All Trap Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'Configuring Flex Links.qmap', '0d60486d41144b0fa6612e2621958154.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='Switching' and parentid=(select id from object_file_path_info where path='All Trap Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'Configuring MAC filter.qmap', '99c2e00a69434f28b903b46e4c010807.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='Switching' and parentid=(select id from object_file_path_info where path='All Trap Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'Configuring Port Security (2).qmap', 'c0446214c4db4ed0b254bf6853f2d317.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='Switching' and parentid=(select id from object_file_path_info where path='All Trap Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'Configuring_DHCP_Relay_Agent.qmap', '309ae1c3b72d470780a9c261ecb49189.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='Switching' and parentid=(select id from object_file_path_info where path='All Trap Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'Configuring_EtherChannels.qmap', '36e9b66b000b4067bd00b11b1cd34d96.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='Switching' and parentid=(select id from object_file_path_info where path='All Trap Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'Configuring_Flex_Links.qmap', '35fb0e312b9f4f0eab95891e060a282c.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='Switching' and parentid=(select id from object_file_path_info where path='All Trap Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'Configuring_HSRP.qmap', 'd439a50594134a888546e31aa1791c77.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='Switching' and parentid=(select id from object_file_path_info where path='All Trap Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'Configuring_HSRP_version_2.qmap', '9f8af51bb47544c19ea5491445b625fc.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='Switching' and parentid=(select id from object_file_path_info where path='All Trap Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'Configuring_HSRP_with_ip_Track.qmap', '560401ade81b4b3ba7fa93f389691071.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='Switching' and parentid=(select id from object_file_path_info where path='All Trap Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'Configuring_MSDP.qmap', '0ae8a5dede1d400a93bf280b786f3fc5.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='Switching' and parentid=(select id from object_file_path_info where path='All Trap Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'Configuring_Port_Security.qmap', '1167f04320b94cb39bd1e8a29a13cf18.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='Switching' and parentid=(select id from object_file_path_info where path='All Trap Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'Configuring_Private_VLANs.qmap', 'e92a04b5d13148aea5c7c0f4e25d5874.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='Switching' and parentid=(select id from object_file_path_info where path='All Trap Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'Configuring_Voice_VLAN.qmap', '04de3bb9254249f1b09af2daf2329b43.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='Switching' and parentid=(select id from object_file_path_info where path='All Trap Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'Configuring_VRRP.qmap', '14106d5538154662a542ef0b5beba4af.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='Switching' and parentid=(select id from object_file_path_info where path='All Trap Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'Disabling_DTP_Negotiation.qmap', 'd477fe56001d4d85aa60df9a3b11e82c.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='Switching' and parentid=(select id from object_file_path_info where path='All Trap Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'IEEE_802.1Q_Tunneling.qmap', '4d5c4c21dbd34805b444a285551ab014.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='Switching' and parentid=(select id from object_file_path_info where path='All Trap Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'IEEE_802.1x_Port-Based_Authentication.qmap', '3f3cda50fa024340a614ec67176cb3ee.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='Switching' and parentid=(select id from object_file_path_info where path='All Trap Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'MTU_mismatch_in_OSPF_area.qmap', 'b84f8a9df5b040959abeb02c8d7acdb3.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='Switching' and parentid=(select id from object_file_path_info where path='All Trap Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'NTP_with_Authentication.qmap', '225018c35a07490eaca85a1ef36b3e4d.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='Switching' and parentid=(select id from object_file_path_info where path='All Trap Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'Remote_SPAN_(RSPAN).qmap', '71ba7ddc00484f8f8a8b230e9f46e637.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='Switching' and parentid=(select id from object_file_path_info where path='All Trap Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'VTP_to_simplify_vlan_configuration.qmap', 'e725cdfde7074059ac39d51c21f080ae.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='Switching' and parentid=(select id from object_file_path_info where path='All Trap Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'Build PPP Multilink for VOIP Traffic.qmap', '5eebd66900db40b3b69799e1d8b96181.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='Wan' and parentid=(select id from object_file_path_info where path='All Trap Qmaps')));
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid,user_property, lasttimestamp, path_id)VALUES (-1, 7, 0, 'Enable PPPoE.qmap', 'af65177e3b8d4b10950ca0e73704e477.qmap', now(), 1,'',now(),(select id from object_file_path_info where path='Wan' and parentid=(select id from object_file_path_info where path='All Trap Qmaps')));



ALTER TABLE bgpneighbor DROP CONSTRAINT bgpneighbor_uniq_asnum;

ALTER TABLE bgpneighbor
  ADD CONSTRAINT bgpneighbor_uniq_asnum UNIQUE(deviceid, remoteasnum,neighborip);


update system_info set ver=500;