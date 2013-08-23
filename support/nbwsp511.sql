\connect :nbwsp;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;



ALTER TABLE site DROP CONSTRAINT site_uniq_name;


DROP FUNCTION site_olddelete(integer[], integer);

CREATE OR REPLACE FUNCTION site_olddelete(siteids integer[], site_mid integer)
  RETURNS boolean AS
$BODY$

BEGIN
	delete from clustersite2site where clustersiteid in  (select id from site where sitemanagerid= site_mid);
	delete from site2sitecluster where siteid in  (select id from site where sitemanagerid= site_mid);
	delete from site2site where siteid in (select id from site where sitemanagerid= site_mid);
	delete from devicesitedevice where siteid in (select id from site where sitemanagerid= site_mid);
	delete from site_customized_borderinterface where siteid in (select id from site where sitemanagerid= site_mid);
	delete from site_customized_info where objectid in (select id from site where sitemanagerid= site_mid);
	delete from site where sitemanagerid=site_mid and id <> all(siteids);
	return true;
EXCEPTION    
	WHEN OTHERS THEN   
		return false;		
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION site_olddelete(integer[], integer) OWNER TO postgres;



update system_info set ver=511;