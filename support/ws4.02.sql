\connect "nbws"

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

update system_devicespec set strshowiproutecmd='show ip route||show ip redirects' where strvendorname='cisco' and idevicetype=2001 and strshowiproutecmd='show ip route';


delete from linkgroupinterface where interfaceid not in ( select id from interfacesetting );

ALTER TABLE linkgroupinterface
  ADD CONSTRAINT linkgroupinterface_fk_interfaceid FOREIGN KEY (interfaceid)
      REFERENCES interfacesetting (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE;
      
      
-- Function: linkgroupinterface_upsert_dynamic(integer, character varying[], character varying[], character varying[])

-- DROP FUNCTION linkgroupinterface_upsert_dynamic(integer, character varying[], character varying[], character varying[]);

CREATE OR REPLACE FUNCTION linkgroupinterface_upsert_dynamic(lid integer, devs character varying[], intfs character varying[], intfips character varying[])
  RETURNS boolean AS
$BODY$
DECLARE
    i integer;
    intf_id integer;
    lgi_id integer;
    dev_id integer;
    ex_id integer;
    r_type integer;
BEGIN
	for i in 1..array_length(devs, 1) LOOP
	
		select id into dev_id from devices where strname = devs[i];
		if dev_id is null then
			continue;
		end if;
		
		select id into intf_id from interfacesetting where interfacename = intfs[i] and deviceid = dev_id;
		
		if intf_id is null then
			continue;
		end if;

		select id into ex_id from linkgroupinterface where groupid = lid and interfaceid = intf_id and "type" = 3 and interfaceip = intfips[i] and deviceid=dev_id;
		if ex_id is null then 
			select id into ex_id from linkgroupdevice where linkgroupid = lid and "type" = 3 and deviceid=dev_id;
		end if;

		r_type=4;
		if ex_id is null then 
			r_type=2;
		end if;
		select id into lgi_id from linkgroupinterface where groupid = lid and interfaceid = intf_id and "type" = r_type and interfaceip = intfips[i] and deviceid=dev_id;
		if lgi_id is null then
			insert into linkgroupinterface (groupid,interfaceid,"type",interfaceip,deviceid) values (lid, intf_id, r_type, intfips[i],dev_id);
		end if;

	end loop;	
	return true;
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION linkgroupinterface_upsert_dynamic(integer, character varying[], character varying[], character varying[]) OWNER TO postgres;


-- Function: linkgroupinterface_upsert_bytype2(integer, integer, character varying[], character varying[], character varying[])

-- DROP FUNCTION linkgroupinterface_upsert_bytype2(integer, integer, character varying[], character varying[], character varying[]);

CREATE OR REPLACE FUNCTION linkgroupinterface_upsert_bytype2(lid integer, ntype integer, devs character varying[], intfs character varying[], intfips character varying[])
  RETURNS boolean AS
$BODY$
DECLARE
    i integer;
    intf_id integer;
    lgi_id integer;
    dev_id integer;
BEGIN
	for i in 1..array_length(devs, 1) LOOP
		
		select id into dev_id from devices where strname = devs[i];
		if dev_id is null then
			continue;
		end if;
		
		select id into intf_id from interfacesetting where interfacename = intfs[i] and deviceid = (select id from devices where strname = devs[i]);
		if intf_id is null then
			continue;
		end if;
		select id into lgi_id from linkgroupinterface where groupid = lid and interfaceid = intf_id and "type" =ntype and interfaceip = intfips[i] and deviceid=dev_id;
		if lgi_id is null then
			insert into linkgroupinterface (groupid,interfaceid,"type",interfaceip,deviceid) values (lid, intf_id,ntype, intfips[i],dev_id);
		end if;
	end loop;	
	return true;
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION linkgroupinterface_upsert_bytype2(integer, integer, character varying[], character varying[], character varying[]) OWNER TO postgres;
      



CREATE OR REPLACE FUNCTION devicegroup_upsert(vm devicegroup)
  RETURNS integer AS
$BODY$
declare
	vm_id integer;
BEGIN
	select id into vm_id from devicegroup where strname=vm.strname;
	
	if vm_id IS NULL THEN
		insert into devicegroup(
			strname, strdesc, userid, showcolor, searchcondition,searchcontainer)
			values( 
			vm.strname, vm.strdesc, vm.userid, vm.showcolor, vm.searchcondition,vm.searchcontainer
			);
			return lastval();	
	end if;
EXCEPTION
	WHEN OTHERS THEN 
		RETURN -2;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION devicegroup_upsert(devicegroup) OWNER TO postgres;

CREATE OR REPLACE FUNCTION linkgroup_upsert(vm linkgroup)
  RETURNS integer AS
$BODY$
declare
	vm_id integer;
BEGIN
	select id into vm_id from linkgroup where strname=vm.strname;
	
	if vm_id IS NULL THEN
		insert into linkgroup(
			strname, strdesc, showcolor, showstyle, showwidth,userid,searchcondition,searchcontainer,dev_searchcondition,dev_searchcontainer,is_map_auto_link)
			values( 
			vm.strname, vm.strdesc, vm.showcolor, vm.showstyle, vm.showwidth,vm.userid,vm.searchcondition,vm.searchcontainer,vm.dev_searchcondition,vm.dev_searchcontainer,vm.is_map_auto_link
			);
			return lastval();	
	end if;
EXCEPTION
	WHEN OTHERS THEN 
		RETURN -2;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION linkgroup_upsert(linkgroup) OWNER TO postgres;


select * from linkgroup_upsert((0,'All PIM interface','',14423100,0,6,-1,'<?xml version="1.0" encoding="UTF-8"?>
<filter>
<expression>A and B</expression>
<condition variable="A" type="107">
<operator>-1</operator>
<expression>2;2001;</expression>
</condition>
<condition variable="B" type="105">
<operator>2</operator>
<expression>PIM-SM;PIM-DM;PIM-SDM;</expression>
</condition>
</filter>',1,'<?xml version="1.0" encoding="UTF-8"?>
<filter>
<expression/>
</filter>',1,True));


select * from linkgroup_upsert((0,'EIGRP summary routers','',4251856,0,6,-1,'<?xml version="1.0" encoding="UTF-8"?>
<filter>
<expression>A</expression>
<condition variable="A" type="106">
<operator>4</operator>
<expression>ip summary-address eigrp</expression>
</condition>
</filter>',1,'<?xml version="1.0" encoding="UTF-8"?>
<filter>
<expression/>
</filter>',1,True));

select * from linkgroup_upsert((0,'All ISIS devices','',1644912,0,6,-1,'<?xml version="1.0" encoding="UTF-8"?>
<filter>
<expression>A and B and C</expression>
<condition variable="A" type="107">
<operator>-1</operator>
<expression>2;2001;</expression>
</condition>
<condition variable="B" type="116">
<operator>4</operator>
<expression>router isis</expression>
</condition>
<condition variable="C" type="106">
<operator>4</operator>
<expression>ip router isis</expression>
</condition>
</filter>',1,'<?xml version="1.0" encoding="UTF-8"?>
<filter>
<expression/>
</filter>',1,True));

select * from linkgroup_upsert((0,'ISIS backbone area','',9109643,0,6,-1,'<?xml version="1.0" encoding="UTF-8"?>
<filter>
<expression>A and B and C</expression>
<condition variable="A" type="107">
<operator>-1</operator>
<expression>2;2001;</expression>
</condition>
<condition variable="B" type="116">
<operator>2</operator>
<expression>is-type level-2-only</expression>
</condition>
<condition variable="C" type="106">
<operator>4</operator>
<expression>ip router isis</expression>
</condition>
</filter>',1,'<?xml version="1.0" encoding="UTF-8"?>
<filter>
<expression/>
</filter>',1,True));


select * from linkgroup_upsert((0,'ISIS L2 and L1-L2 devices','',12357519,0,6,-1,'<?xml version="1.0" encoding="UTF-8"?>
<filter>
<expression>A and B and C</expression>
<condition variable="A" type="107">
<operator>-1</operator>
<expression>2;2001;</expression>
</condition>
<condition variable="B" type="116">
<operator>3</operator>
<expression>is-type level-1</expression>
</condition>
<condition variable="C" type="106">
<operator>4</operator>
<expression>ip router isis</expression>
</condition>
</filter>',1,'<?xml version="1.0" encoding="UTF-8"?>
<filter>
<expression/>
</filter>',1,True));


select * from linkgroup_upsert((0,'VRF \'boston\' network','',12092939,0,6,-1,'<?xml version="1.0" encoding="UTF-8"?>
<filter>
<expression>A</expression>
<condition variable="A" type="104">
<operator>4</operator>
<expression>boston</expression>
</condition>
</filter>',1,'<?xml version="1.0" encoding="UTF-8"?>
<filter>
<expression>A</expression>
<condition variable="A" type="9">
<operator>4</operator>
<expression>mpls ip;tag-switching</expression>
</condition>
</filter>',1,True));

select * from linkgroup_upsert((0,'PIM RP points','',205,0,6,-1,'<?xml version="1.0" encoding="UTF-8"?>
<filter>
<expression>(A or B or C or D) and E</expression>
<condition variable="A" type="116">
<operator>4</operator>
<expression>ip pim send-rp-announce</expression>
</condition>
<condition variable="B" type="116">
<operator>4</operator>
<expression>ip pim send-rp-discovery</expression>
</condition>
<condition variable="C" type="116">
<operator>4</operator>
<expression>ip pim bsr-candidate</expression>
</condition>
<condition variable="D" type="116">
<operator>4</operator>
<expression>ip pim rp-candidate</expression>
</condition>
<condition variable="E" type="107">
<operator>-1</operator>
<expression>2;2001;</expression>
</condition>
</filter>',1,'<?xml version="1.0" encoding="UTF-8"?>
<filter>
<expression/>
</filter>',1,True));


select * from linkgroup_upsert((0,'Devices with 10G interfaces','',13458524,0,6,-1,'<?xml version="1.0" encoding="UTF-8"?>
<filter>
<expression>A and B</expression>
<condition variable="A" type="107">
<operator>-1</operator>
<expression>2;2001;</expression>
</condition>
<condition variable="B" type="100">
<operator>4</operator>
<expression>tengigabitethernet</expression>
</condition>
</filter>',1,'<?xml version="1.0" encoding="UTF-8"?>
<filter>
<expression/>
</filter>',1,True));


select * from linkgroup_upsert((0,'VoIP Auto-QOS','',13047173,0,6,-1,'<?xml version="1.0" encoding="UTF-8"?>
<filter>
<expression>A and B</expression>
<condition variable="A" type="107">
<operator>-1</operator>
<expression>2;2001;</expression>
</condition>
<condition variable="B" type="116">
<operator>4</operator>
<expression>voip-rtp</expression>
</condition>
</filter>',1,'<?xml version="1.0" encoding="UTF-8"?>
<filter>
<expression/>
</filter>',1,True));


select * from linkgroup_upsert((0,'CBWFQ devices','',255,0,6,-1,'<?xml version="1.0" encoding="UTF-8"?>
<filter>
<expression>A and B</expression>
<condition variable="A" type="107">
<operator>-1</operator>
<expression>2;2001;</expression>
</condition>
<condition variable="B" type="106">
<operator>4</operator>
<expression>service-policy output</expression>
</condition>
</filter>',1,'<?xml version="1.0" encoding="UTF-8"?>
<filter>
<expression/>
</filter>',1,True));


select * from linkgroup_upsert((0,'All HSRP routers','',14315734,0,6,-1,'<?xml version="1.0" encoding="UTF-8"?>
<filter>
<expression>A and B</expression>
<condition variable="A" type="107">
<operator>-1</operator>
<expression>2;2001;</expression>
</condition>
<condition variable="B" type="106">
<operator>4</operator>
<expression>standby</expression>
</condition>
</filter>',1,'<?xml version="1.0" encoding="UTF-8"?>
<filter>
<expression/>
</filter>',1,True));

select * from linkgroup_upsert((0,'All NAT routers','',11584734,0,6,-1,'<?xml version="1.0" encoding="UTF-8"?>
<filter>
<expression>A and B</expression>
<condition variable="A" type="107">
<operator>-1</operator>
<expression>2;2001;</expression>
</condition>
<condition variable="B" type="106">
<operator>4</operator>
<expression>ip nat inside;ip nat outside</expression>
</condition>
</filter>',1,'<?xml version="1.0" encoding="UTF-8"?>
<filter>
<expression/>
</filter>',1,True));








select * from devicegroup_upsert(( 0,'Device with only static routing','',-1,6266528,'<?xml version="1.0" encoding="UTF-8"?>
<DyCompoment>
<ComplexCondition>&lt;?xml version="1.0" encoding="UTF-8"?&gt;
&lt;filter&gt;
&lt;expression&gt;A and B and C &lt;/expression&gt;
&lt;condition variable="A" type="0"&gt;
&lt;operator&gt;-1&lt;/operator&gt;
&lt;expression&gt;2;2001;&lt;/expression&gt;
&lt;/condition&gt;
&lt;condition variable="B" type="9"&gt;
&lt;operator&gt;2&lt;/operator&gt;
&lt;expression&gt;ip route&lt;/expression&gt;
&lt;/condition&gt;
&lt;condition variable="C" type="9"&gt;
&lt;operator&gt;5&lt;/operator&gt;
&lt;expression&gt;router rip;router igrp;router eigrp;router bgp;router ospf;router isis;router odr&lt;/expression&gt;
&lt;/condition&gt;
&lt;/filter&gt;
</ComplexCondition>
<RangeCondition>&lt;?xml version="1.0" encoding="UTF-8"?&gt;
&lt;Range type="0"&gt;
&lt;operator&gt;0&lt;/operator&gt;
&lt;expression/&gt;
&lt;/Range&gt;
</RangeCondition>
</DyCompoment>',1));


select * from devicegroup_upsert(( 0,'BGP reflector','',-1,2142890,'<?xml version="1.0" encoding="UTF-8"?>
<DyCompoment>
<ComplexCondition>&lt;?xml version="1.0" encoding="UTF-8"?&gt;
&lt;filter&gt;
&lt;expression&gt;A and B&lt;/expression&gt;
&lt;condition variable="A" type="0"&gt;
&lt;operator&gt;-1&lt;/operator&gt;
&lt;expression&gt;2;2001;&lt;/expression&gt;
&lt;/condition&gt;
&lt;condition variable="B" type="9"&gt;
&lt;operator&gt;2&lt;/operator&gt;
&lt;expression&gt;route-reflector-client&lt;/expression&gt;
&lt;/condition&gt;
&lt;/filter&gt;
</ComplexCondition>
<RangeCondition>&lt;?xml version="1.0" encoding="UTF-8"?&gt;
&lt;Range type="0"&gt;
&lt;operator&gt;0&lt;/operator&gt;
&lt;expression/&gt;
&lt;/Range&gt;
</RangeCondition>
</DyCompoment>',1));


select * from devicegroup_upsert((0,'OSPF backbone Area','',-1,3050327,'<?xml version="1.0" encoding="UTF-8"?>
<DyCompoment>
<ComplexCondition>&lt;?xml version="1.0" encoding="UTF-8"?&gt;
&lt;filter&gt;
&lt;expression&gt;A and B and C&lt;/expression&gt;
&lt;condition variable="A" type="0"&gt;
&lt;operator&gt;-1&lt;/operator&gt;
&lt;expression&gt;2;2001;&lt;/expression&gt;
&lt;/condition&gt;
&lt;condition variable="B" type="9"&gt;
&lt;operator&gt;4&lt;/operator&gt;
&lt;expression&gt;router ospf&lt;/expression&gt;
&lt;/condition&gt;
&lt;condition variable="C" type="9"&gt;
&lt;operator&gt;4&lt;/operator&gt;
&lt;expression&gt;area 0;virtual-link&lt;/expression&gt;
&lt;/condition&gt;
&lt;/filter&gt;
</ComplexCondition>
<RangeCondition>&lt;?xml version="1.0" encoding="UTF-8"?&gt;
&lt;Range type="0"&gt;
&lt;operator&gt;0&lt;/operator&gt;
&lt;expression/&gt;
&lt;/Range&gt;
</RangeCondition>
</DyCompoment>',1));

select * from devicegroup_upsert((0,'OSPF routing summary','',-1,9419915,'<?xml version="1.0" encoding="UTF-8"?>
<DyCompoment>
<ComplexCondition>&lt;?xml version="1.0" encoding="UTF-8"?&gt;
&lt;filter&gt;
&lt;expression&gt;A and B and C&lt;/expression&gt;
&lt;condition variable="A" type="0"&gt;
&lt;operator&gt;-1&lt;/operator&gt;
&lt;expression&gt;2;2001;&lt;/expression&gt;
&lt;/condition&gt;
&lt;condition variable="B" type="9"&gt;
&lt;operator&gt;4&lt;/operator&gt;
&lt;expression&gt;router ospf&lt;/expression&gt;
&lt;/condition&gt;
&lt;condition variable="C" type="9"&gt;
&lt;operator&gt;4&lt;/operator&gt;
&lt;expression&gt;summary-address&lt;/expression&gt;
&lt;/condition&gt;
&lt;/filter&gt;
</ComplexCondition>
<RangeCondition>&lt;?xml version="1.0" encoding="UTF-8"?&gt;
&lt;Range type="0"&gt;
&lt;operator&gt;0&lt;/operator&gt;
&lt;expression/&gt;
&lt;/Range&gt;
</RangeCondition>
</DyCompoment>',1));

select * from devicegroup_upsert((0,'All EIGRP Devices','',-1,14315734,'<?xml version="1.0" encoding="UTF-8"?>
<DyCompoment>
<ComplexCondition>&lt;?xml version="1.0" encoding="UTF-8"?&gt;
&lt;filter&gt;
&lt;expression&gt;A and B&lt;/expression&gt;
&lt;condition variable="A" type="0"&gt;
&lt;operator&gt;-1&lt;/operator&gt;
&lt;expression&gt;2;2001;&lt;/expression&gt;
&lt;/condition&gt;
&lt;condition variable="B" type="9"&gt;
&lt;operator&gt;4&lt;/operator&gt;
&lt;expression&gt;router eigrp&lt;/expression&gt;
&lt;/condition&gt;
&lt;/filter&gt;
</ComplexCondition>
<RangeCondition>&lt;?xml version="1.0" encoding="UTF-8"?&gt;
&lt;Range type="0"&gt;
&lt;operator&gt;0&lt;/operator&gt;
&lt;expression/&gt;
&lt;/Range&gt;
</RangeCondition>
</DyCompoment>',1));

select * from devicegroup_upsert((0,'All BGP Devices','',-1,2142890,'<?xml version="1.0" encoding="UTF-8"?>
<DyCompoment>
<ComplexCondition>&lt;?xml version="1.0" encoding="UTF-8"?&gt;
&lt;filter&gt;
&lt;expression&gt;A and B&lt;/expression&gt;
&lt;condition variable="A" type="0"&gt;
&lt;operator&gt;-1&lt;/operator&gt;
&lt;expression&gt;2;2001;&lt;/expression&gt;
&lt;/condition&gt;
&lt;condition variable="B" type="9"&gt;
&lt;operator&gt;4&lt;/operator&gt;
&lt;expression&gt;router bgp&lt;/expression&gt;
&lt;/condition&gt;
&lt;/filter&gt;
</ComplexCondition>
<RangeCondition>&lt;?xml version="1.0" encoding="UTF-8"?&gt;
&lt;Range type="0"&gt;
&lt;operator&gt;0&lt;/operator&gt;
&lt;expression/&gt;
&lt;/Range&gt;
</RangeCondition>
</DyCompoment>',1));

select * from devicegroup_upsert((0,'BGP route summary','',-1,139,'<?xml version="1.0" encoding="UTF-8"?>
<DyCompoment>
<ComplexCondition>&lt;?xml version="1.0" encoding="UTF-8"?&gt;
&lt;filter&gt;
&lt;expression&gt;A and B&lt;/expression&gt;
&lt;condition variable="A" type="0"&gt;
&lt;operator&gt;-1&lt;/operator&gt;
&lt;expression&gt;2;2001;&lt;/expression&gt;
&lt;/condition&gt;
&lt;condition variable="B" type="9"&gt;
&lt;operator&gt;2&lt;/operator&gt;
&lt;expression&gt;aggregate-address&lt;/expression&gt;
&lt;/condition&gt;
&lt;/filter&gt;
</ComplexCondition>
<RangeCondition>&lt;?xml version="1.0" encoding="UTF-8"?&gt;
&lt;Range type="0"&gt;
&lt;operator&gt;0&lt;/operator&gt;
&lt;expression/&gt;
&lt;/Range&gt;
</RangeCondition>
</DyCompoment>',1));

select * from devicegroup_upsert((0,'All devices with \'public\'  as community string','',-1,16737095,'<?xml version="1.0" encoding="UTF-8"?>
<DyCompoment>
<ComplexCondition>&lt;?xml version="1.0" encoding="UTF-8"?&gt;
&lt;filter&gt;
&lt;expression&gt;A and B&lt;/expression&gt;
&lt;condition variable="A" type="0"&gt;
&lt;operator&gt;-1&lt;/operator&gt;
&lt;expression&gt;2;2001;&lt;/expression&gt;
&lt;/condition&gt;
&lt;condition variable="B" type="9"&gt;
&lt;operator&gt;2&lt;/operator&gt;
&lt;expression&gt;snmp-server community public&lt;/expression&gt;
&lt;/condition&gt;
&lt;/filter&gt;
</ComplexCondition>
<RangeCondition>&lt;?xml version="1.0" encoding="UTF-8"?&gt;
&lt;Range type="0"&gt;
&lt;operator&gt;0&lt;/operator&gt;
&lt;expression/&gt;
&lt;/Range&gt;
</RangeCondition>
</DyCompoment>',1));

select * from devicegroup_upsert((0,'All devices without TACACS-Radius authentication','',-1,8421376,'<?xml version="1.0" encoding="UTF-8"?>
<DyCompoment>
<ComplexCondition>&lt;?xml version="1.0" encoding="UTF-8"?&gt;
&lt;filter&gt;
&lt;expression&gt;A and B&lt;/expression&gt;
&lt;condition variable="A" type="0"&gt;
&lt;operator&gt;-1&lt;/operator&gt;
&lt;expression&gt;2;2001;&lt;/expression&gt;
&lt;/condition&gt;
&lt;condition variable="B" type="9"&gt;
&lt;operator&gt;5&lt;/operator&gt;
&lt;expression&gt;tacacs-server host;radius-server host&lt;/expression&gt;
&lt;/condition&gt;
&lt;/filter&gt;
</ComplexCondition>
<RangeCondition>&lt;?xml version="1.0" encoding="UTF-8"?&gt;
&lt;Range type="0"&gt;
&lt;operator&gt;0&lt;/operator&gt;
&lt;expression/&gt;
&lt;/Range&gt;
</RangeCondition>
</DyCompoment>',1));

select * from devicegroup_upsert((0,'All RIP Devices','',-1,32896,'<?xml version="1.0" encoding="UTF-8"?>
<DyCompoment>
<ComplexCondition>&lt;?xml version="1.0" encoding="UTF-8"?&gt;
&lt;filter&gt;
&lt;expression&gt;A and B&lt;/expression&gt;
&lt;condition variable="A" type="0"&gt;
&lt;operator&gt;-1&lt;/operator&gt;
&lt;expression&gt;2;2001;&lt;/expression&gt;
&lt;/condition&gt;
&lt;condition variable="B" type="9"&gt;
&lt;operator&gt;4&lt;/operator&gt;
&lt;expression&gt;router rip&lt;/expression&gt;
&lt;/condition&gt;
&lt;/filter&gt;
</ComplexCondition>
<RangeCondition>&lt;?xml version="1.0" encoding="UTF-8"?&gt;
&lt;Range type="0"&gt;
&lt;operator&gt;0&lt;/operator&gt;
&lt;expression/&gt;
&lt;/Range&gt;
</RangeCondition>
</DyCompoment>',1));

select * from devicegroup_upsert((0,'All OSPF Devices','',-1,8900331,'<?xml version="1.0" encoding="UTF-8"?>
<DyCompoment>
<ComplexCondition>&lt;?xml version="1.0" encoding="UTF-8"?&gt;
&lt;filter&gt;
&lt;expression&gt;A and B&lt;/expression&gt;
&lt;condition variable="A" type="0"&gt;
&lt;operator&gt;-1&lt;/operator&gt;
&lt;expression&gt;2;2001;&lt;/expression&gt;
&lt;/condition&gt;
&lt;condition variable="B" type="9"&gt;
&lt;operator&gt;4&lt;/operator&gt;
&lt;expression&gt;router ospf&lt;/expression&gt;
&lt;/condition&gt;
&lt;/filter&gt;
</ComplexCondition>
<RangeCondition>&lt;?xml version="1.0" encoding="UTF-8"?&gt;
&lt;Range type="0"&gt;
&lt;operator&gt;0&lt;/operator&gt;
&lt;expression/&gt;
&lt;/Range&gt;
</RangeCondition>
</DyCompoment>',1));

select * from devicegroup_upsert((0,'All multicasting routers','',-1,15761536,'<?xml version="1.0" encoding="UTF-8"?>
<DyCompoment>
<ComplexCondition>&lt;?xml version="1.0" encoding="UTF-8"?&gt;
&lt;filter&gt;
&lt;expression&gt;A and B&lt;/expression&gt;
&lt;condition variable="A" type="0"&gt;
&lt;operator&gt;-1&lt;/operator&gt;
&lt;expression&gt;2;2001;&lt;/expression&gt;
&lt;/condition&gt;
&lt;condition variable="B" type="9"&gt;
&lt;operator&gt;4&lt;/operator&gt;
&lt;expression&gt;ip multicast-routing&lt;/expression&gt;
&lt;/condition&gt;
&lt;/filter&gt;
</ComplexCondition>
<RangeCondition>&lt;?xml version="1.0" encoding="UTF-8"?&gt;
&lt;Range type="0"&gt;
&lt;operator&gt;0&lt;/operator&gt;
&lt;expression/&gt;
&lt;/Range&gt;
</RangeCondition>
</DyCompoment>',1));



update system_info set ver=402;