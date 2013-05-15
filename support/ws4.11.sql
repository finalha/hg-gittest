\connect "nbws"

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

insert into object_customized_attribute ( objectid, "name", alias, allow_export, "type", allow_modify_exported ) values( 1, 'sysobjectid', 'sysObjectID', true, 1, true );
insert into object_customized_attribute ( objectid, "name", alias, allow_export, "type", allow_modify_exported ) values( 1, 'findtime', 'First Discovered At', true, 1, true );
insert into object_customized_attribute ( objectid, "name", alias, allow_export, "type", allow_modify_exported ) values( 1, 'lasttime', 'Last Discovered At', true, 1, true );


update linkgroup_param set strdesc='Specify the SNMP RO string.' where linkgroupid in (select id from linkgroup where strname='Devices with specified SNMP RO');
update linkgroup_param set strdesc='Specify the BGP AS number.' where linkgroupid in (select id from linkgroup where strname='Devices in specified BGP AS');
update linkgroup_param set strdesc='Specify the VRF name.' where linkgroupid in (select id from linkgroup where strname='VRF Network');


update system_info set ver=411;