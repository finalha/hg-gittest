\connect "nbws"

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

ALTER TABLE system_devicespec ALTER COLUMN strshowruncmd type character varying(512);

update system_devicespec set strmemoid='$1.3.6.1.4.1.3224.16.2.1.0*100.0/($1.3.6.1.4.1.3224.16.2.1.0+$1.3.6.1.4.1.3224.16.2.2.0)' where strvendorname='netscreen' and idevicetype=2008;
update system_devicespec set strshowruncmd='show config|no-more||show interface terse|no-more' where strvendorname='Juniper' and idevicetype=102 and strshowruncmd='show config|no-more';
update system_devicespec set strshowruncmd='show config|no-more||show interface terse|no-more' where strvendorname='Juniper' and idevicetype=2012 and strshowruncmd='show config|no-more';


update "user" set offline_minutes=10080 where strname='admin';

update system_info set ver=412;