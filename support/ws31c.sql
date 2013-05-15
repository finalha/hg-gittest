\connect "nbws"

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

INSERT INTO "function"(strname, wsver, description, sidname, kval, isdisplay )
    VALUES ( 'Public Link Group Management', 0, '', 'LinkGroup','394F6B6D6C54697066723A3B', FALSE);

INSERT INTO "function"(strname, wsver, description, sidname, kval, isdisplay )
    VALUES ( 'Site Management', 0, '', 'Site','34483367323A353339307634723533', FALSE);


INSERT INTO "function"(strname, wsver, description, sidname, kval, isdisplay )
    VALUES ( 'Shared Map', 0, '', 'SharedMap','39486B7A4E7677697A733A3B', FALSE);


INSERT INTO "function"(strname, wsver, description, sidname, kval, isdisplay )
    VALUES ( 'Auto Update Shared Map', 0, '', 'Update_Shared_Map','39466B774E67775F69737A4876765F7A7A6B3A58', FALSE);
    

INSERT INTO "function"(strname, wsver, description, sidname, kval, isdisplay )
    VALUES ( 'Network Design', 0, '', 'Design_Module','3957766866746C5F4E6D77726F763A3F', TRUE);
    
INSERT INTO role2function( roleid, functionid) VALUES (( select id from "role" where name='Admin'), (select id from function where sidname='Design_Module') );
INSERT INTO role2function( roleid, functionid) VALUES (( select id from "role" where name='Architect Role'), (select id from function where sidname='Design_Module') );


INSERT INTO system_devicespec(
            strvendorname, strmodelname, idevicetype, strcpuoid, strmemoid, 
            strshowruncmd, strshowiproutecmd, strshowroutecountcmd, strshowarpcmd, 
            strshowcamcmd, strpage1cmd, strloginprompt, strpasswordprompt, 
            strprivilegeprompt, strnonprivilegeprompt, strconfigprompt, strtoenablecmd, 
            strtoconfigcmd, stryesnoprompt, ipasswordinterval, iflag, bmodified, 
            strshowcdpcmd, strinvalidcommandkey, strquit)
    VALUES ('RuggedCom', 'unclassfied switch', 2061, '$1.3.6.1.4.1.15004.4.2.2.2.0*100.0/$1.3.6.1.4.1.15004.4.2.3.5.0', '$1.3.6.1.4.1.15004.4.2.2.6.0', 
            '', '', '', '', 
            '', '', '', '', 
            '', '', '', '', 
            '', '', 0, 0, 0, 
            '', '', '');

ALTER TABLE system_devicespec ALTER COLUMN strshowarpcmd TYPE character varying(512);
ALTER TABLE system_devicespec ALTER COLUMN strshowcamcmd TYPE character varying(512);


update system_devicespec set strshowarpcmd='display arp all||display arp' where strshowarpcmd='display arp all|display arp';
update system_devicespec set strshowcamcmd='show cam dynamic||show cam static' where strshowcamcmd='show cam dynamic|show cam static';


INSERT INTO system_devicespec(
            strvendorname, strmodelname, idevicetype, strcpuoid, strmemoid, 
            strshowruncmd, strshowiproutecmd, strshowroutecountcmd, strshowarpcmd, 
            strshowcamcmd, strpage1cmd, strloginprompt, strpasswordprompt, 
            strprivilegeprompt, strnonprivilegeprompt, strconfigprompt, strtoenablecmd, 
            strtoconfigcmd, stryesnoprompt, ipasswordinterval, iflag, bmodified, 
            strshowcdpcmd, strinvalidcommandkey, strquit)
    VALUES ('cisco','',2004,'$1.3.6.1.4.1.9.2.1.56.0','$1.3.6.1.4.1.9.9.48.1.1.1.5.1*100.0/($1.3.6.1.4.1.9.9.48.1.1.1.6.1+$1.3.6.1.4.1.9.9.48.1.1.1.5.1)','show run','show ip route','show ip route summary','show ip arp','show mac-address-table||sh mac add','','Username:','Password:','#','>','(config)#','enable','config terminal','(yes/no)NULL',0,0,0,'show cdp neighbor detail','Incomplete|Unknown|Invalid|Ambiguous','exit' );

                                             

ALTER TABLE nomp_jumpbox DROP CONSTRAINT nomp_jumpbox_pk;

ALTER TABLE nomp_jumpbox
  ADD CONSTRAINT nomp_jumpbox_pk PRIMARY KEY(id);

ALTER TABLE nomp_jumpbox
  ADD CONSTRAINT nomp_jumpbox_strname_userid_un UNIQUE(strname, userid);



update system_devicespec set strinvalidcommandkey='?|%' where idevicetype=2002 and strinvalidcommandkey='?';

update function set wsver=0, kval='394F675F766C766C7A6C7A625F4E746D6F746B6E476D373A53' where sidname='L2_Topology_Management';
update function set wsver=0, kval='394F6265765F6C7668645769705F6C7267784D657669723A53' where sidname='Live_Network_Discovery';
update function set wsver=0, kval='3959706D7A736E7869763A3B' where sidname='Benchmark';
update function set wsver=0, kval='3958676E766C765F7A767A725F766D48676776725F74784E656D57746D6E6E6D6C3A49' where sidname='Common_Device_Setting_Management';
update function set wsver=0, kval='3958676D767276667A7A7A725F6D6F55725F766C4E676D6974746E756D6C3A4C' where sidname='Configuration_File_Management';
update function set wsver=0, kval='3947676B766F76747A5F7A675F676D73727874724E486D62746C6E6C6D6C3A4C' where sidname='Topology_Stitching_Management';
update function set wsver=0, kval='3947677A767576787A487A725F786D727374674E676D5F74726E756D693A4D' where sidname='Traffic_Stitching_Management';
update function set wsver=0, kval='395767657678765F7A697A665F6B4E6C6D5474766E726D763A52' where sidname='Device_Group_Management';
  
  
update system_devicespec set strshowcamcmd='show dot11 association' where idevicetype=1025 and strshowcamcmd='';

update system_devicespec set strpage1cmd='terminal length 0' where idevicetype=2004 and (strpage1cmd='' or strpage1cmd  is null);

UPDATE system_devicespec SET strshowroutecountcmd='' WHERE idevicetype=2004 and strshowroutecountcmd='show ip route summary';

UPDATE system_devicespec SET strcpuoid='$1.3.6.1.4.1.9.9.109.1.1.1.1.7.1',strmemoid='$1.3.6.1.4.1.9.9.305.1.1.2.0' WHERE idevicetype=2004;


UPDATE system_devicespec SET strshowiproutecmd='show ip route vrf all' WHERE idevicetype=2004 and strshowiproutecmd='show ip route';

UPDATE system_devicespec SET strshowarpcmd='show ip arp vrf all' WHERE idevicetype=2004 and strshowarpcmd='show ip arp';


INSERT INTO system_devicespec(
            strvendorname, strmodelname, idevicetype, strcpuoid, strmemoid, 
            strshowruncmd, strshowiproutecmd, strshowroutecountcmd, strshowarpcmd, 
            strshowcamcmd, strpage1cmd, strloginprompt, strpasswordprompt, 
            strprivilegeprompt, strnonprivilegeprompt, strconfigprompt, strtoenablecmd, 
            strtoconfigcmd, stryesnoprompt, ipasswordinterval, iflag, bmodified, 
            strshowcdpcmd, strinvalidcommandkey, strquit)
    VALUES ('cisco', 'N1KV', 2004, '$1.3.6.1.4.1.9.9.109.1.1.1.1.8.1', '$1.3.6.1.4.1.9.9.305.1.1.2.0', 
            'show run', 'show ip route vrf all', '', 'show ip arp vrf all', 
            'show mac-address-table||sh mac add', 'terminal length 0', '', '', 
            '#', '>', '', 'enable', 
            '', '', 0, 0, 0, 
            'show cdp neighbor detail', 'Incomplete|Unknown|Invalid|Ambiguous', 'exit');
									
UPDATE system_devicespec SET strcpuoid='$1.3.6.1.4.1.9.9.109.1.1.1.1.8.1' WHERE idevicetype=2004 and strmodelname='N1KV';

INSERT INTO system_devicespec(
            strvendorname, strmodelname, idevicetype, strcpuoid, strmemoid, 
            strshowruncmd, strshowiproutecmd, strshowroutecountcmd, strshowarpcmd, 
            strshowcamcmd, strpage1cmd, strloginprompt, strpasswordprompt, 
            strprivilegeprompt, strnonprivilegeprompt, strconfigprompt, strtoenablecmd, 
            strtoconfigcmd, stryesnoprompt, ipasswordinterval, iflag, bmodified, 
            strshowcdpcmd, strinvalidcommandkey, strquit)
    VALUES ('Foundry', '', 2024, '$1.3.6.1.4.1.1991.1.1.2.1.51.0', '($1.3.6.1.4.1.1991.1.1.2.1.54.0-$1.3.6.1.4.1.1991.1.1.2.1.55.0)*100/$1.3.6.1.4.1.1991.1.1.2.1.54.0', 
            '', '', '', '', 
            '', '', '', '', 
            '#', '>', '', '', 
            '', '', 0, 0, 0, 
            '', '', '');

 UPDATE system_devicespec SET strshowcamcmd='show mac-address-table||show mac address-table' WHERE idevicetype=2001 and strshowcamcmd='show mac-address-table';
 
