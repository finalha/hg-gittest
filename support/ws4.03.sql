\connect "nbws"

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;


update system_devicespec set strcpuoid='$1.3.6.1.4.1.2636.3.1.13.1.8.9.1.0.0' where strvendorname='Juniper' and idevicetype=102 and strcpuoid='$1.3.6.1.4.1.2636.3.1.13.1.8.7.1.0.0';
update system_devicespec set strmemoid='$1.3.6.1.4.1.2636.3.1.13.1.11.9.1.0.0' where strvendorname='Juniper' and idevicetype=102 and strmemoid='$1.3.6.1.4.1.2636.3.1.13.1.11.7.1.0.0';

update system_info set ver=403;