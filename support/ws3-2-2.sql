\connect "nbws"

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;


ALTER TABLE system_devicespec ADD CONSTRAINT system_devicespec_un UNIQUE(idevicetype, strmodelname);
update system_devicespec set strcpuoid='$9.9.109.1.1.1.1.3.1' where idevicetype = 1025;


SELECT pg_catalog.setval('system_devicespec_id_seq',(select max(id)+1 from system_devicespec), true);
INSERT INTO system_devicespec(
            strvendorname, strmodelname, idevicetype, strcpuoid, strmemoid, 
            strshowruncmd, strshowiproutecmd, strshowroutecountcmd, strshowarpcmd, 
            strshowcamcmd, strpage1cmd, strloginprompt, strpasswordprompt, 
            strprivilegeprompt, strnonprivilegeprompt, strconfigprompt, strtoenablecmd, 
            strtoconfigcmd, stryesnoprompt, ipasswordinterval, iflag, bmodified, 
            strshowcdpcmd, strinvalidcommandkey, strquit)
VALUES ('3Com', 's5100', 3333, '$2011.2.23.1.18.1.3.0', '($2011.6.1.2.1.1.2.65536-$2011.6.1.2.1.1.3.65536)*100.0/$2011.6.1.2.1.1.2.65536', 'display cur', 'display ip rout', '', 'display arp', 'display mac-address', '', 'Username:', 'Password:', '>', '>', ']', 'su', 'sys','', 0,	0,0, '', '%','quit');
