\connect "nbws"

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;


INSERT INTO system_devicespec(strvendorname, strmodelname, idevicetype, strcpuoid, strmemoid, strshowruncmd, strshowiproutecmd, strshowroutecountcmd, strshowarpcmd, strshowcamcmd, strpage1cmd, strloginprompt, strpasswordprompt, strprivilegeprompt, strnonprivilegeprompt, strconfigprompt, strtoenablecmd, strtoconfigcmd, stryesnoprompt, ipasswordinterval, iflag, bmodified, strshowcdpcmd, strinvalidcommandkey, strquit, strshowstpcmd) VALUES ('Force10', '', 2015, '$1.3.6.1.4.1.6027.3.1.1.3.7.1.4', '$1.3.6.1.4.1.6027.3.1.1.3.7.1.6', 'show run', 'show ip route', 'show ip route summary', 'show arp||show arp switch', 'show mac-addr-table||show mac-address-table', 'ter len 0', '', '', '', '', '', 'enable', '', '', 0, 0, 0, 'show lldp neighbors detail', 'Ambiguous||Incorrect||Incomplete||%', 'quit', '');
            
INSERT INTO system_devicespec(strvendorname, strmodelname, idevicetype, strcpuoid, strmemoid, strshowruncmd, strshowiproutecmd, strshowroutecountcmd, strshowarpcmd, strshowcamcmd, strpage1cmd, strloginprompt, strpasswordprompt, strprivilegeprompt, strnonprivilegeprompt, strconfigprompt, strtoenablecmd, strtoconfigcmd, stryesnoprompt, ipasswordinterval, iflag, bmodified, strshowcdpcmd, strinvalidcommandkey, strquit, strshowstpcmd) VALUES ('Arista', '', 2013, '$1.3.6.1.2.1.25.3.3.1.2', '$1.3.6.1.2.1.25.2.3.1.6.2/1.3.6.1.2.1.25.2.3.1.5.2*100%', 'show run', 'show ip route', 'show ip route summary', 'show arp', 'show mac-address-table', 'ter len 0', '', '', '', '', '', 'enable', '', '', 0, 0, 0, 'show lldp neighbors detail', 'Incomplete||Unknown||Invalid||Ambiguous||%', 'exit', 'show spanning-tree blockedports');

update system_devicespec set strvendorname ='Brocade',strshowruncmd='show run',strshowiproutecmd='show ip route',strshowroutecountcmd='show ip route summary',strshowarpcmd='show arp',strshowcamcmd='show mac-address',strshowcdpcmd='show fdp neighbors detail',strshowstpcmd='show spanning-tree brief',strpage1cmd='skip',strquit='exit',strtoenablecmd='enable',strinvalidcommandkey='Ambiguous||Invalid||Unrecognized||Error' where strvendorname='Foundry' and idevicetype=2024;

update system_devicespec set strshowcdpcmd='show fdp neighbors detail' where strvendorname='Brocade' and idevicetype=2024;

update system_devicespec set strquit='exit' where strvendorname='Juniper' and idevicetype=102;

update system_devicespec set strshowiproutecmd='show route table inet.0|no-more' where strvendorname='Juniper' and idevicetype=2012;

update system_devicespec set strshowcdpcmd='show cdp neighbors detail||show lldp info remote all' where strvendorname='HP' and idevicetype=2011 and strshowcdpcmd='show cdp neighbors detail';


update system_info set ver=413;

