\connect "nbws"

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

update system_devicespec set strshowcamcmd='show mac-address-table||show mac address-table', strmemoid='$1.3.6.1.2.1.25.2.3.1.6.2*100.0/$1.3.6.1.2.1.25.2.3.1.5.2' where idevicetype=2013;


update system_info set ver=414;

