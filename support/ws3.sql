--
-- PostgreSQL database dump
--

-- Started on 2010-04-13 15:59:37

SET client_encoding = 'SQL_ASCII';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

--
-- TOC entry 2622 (class 1262 OID 88282)
-- Name: nbws; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE nbws WITH TEMPLATE = template0 ENCODING = 'SQL_ASCII';


ALTER DATABASE nbws OWNER TO postgres;

\connect nbws

SET client_encoding = 'SQL_ASCII';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

--
-- TOC entry 558 (class 2612 OID 16386)
-- Name: plpgsql; Type: PROCEDURAL LANGUAGE; Schema: -; Owner: postgres
--

CREATE PROCEDURAL LANGUAGE plpgsql;


ALTER PROCEDURAL LANGUAGE plpgsql OWNER TO postgres;

SET search_path = public, pg_catalog;

--
-- TOC entry 18 (class 1255 OID 88283)
-- Dependencies: 5 558
-- Name: adddevice_configfile(character varying, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION adddevice_configfile(devname character varying, configcontent text) RETURNS integer
    AS $$
DECLARE 
	r_id integer;
BEGIN
	select id into r_id from devices where strname=devname;
	if r_id IS NULL THEN 
		return -1;
	END if;

	if EXISTS( select deviceid from device_config where deviceid=r_id ) THEN
		UPDATE device_config
		   SET configfile=configcontent, dtstamp=now()
		 WHERE deviceid=r_id;

	ELSE
		INSERT INTO device_config(
			    deviceid, configfile, dtstamp )
		    VALUES (r_id, configcontent, now());
	END if;

	return 0;
EXCEPTION
	WHEN OTHERS THEN 
		RETURN -100;
		
END;
  $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.adddevice_configfile(devname character varying, configcontent text) OWNER TO postgres;

--
-- TOC entry 19 (class 1255 OID 88284)
-- Dependencies: 558 5
-- Name: adddevicegroupdevice(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION adddevicegroupdevice(_deviceid integer, _devicegroupid integer) RETURNS integer
    AS $$
BEGIN
	INSERT INTO napdevice(deviceid, devicegroupid) VALUES (_deviceid, _devicegroupid);
	return 1;
End;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.adddevicegroupdevice(_deviceid integer, _devicegroupid integer) OWNER TO postgres;

--
-- TOC entry 20 (class 1255 OID 88285)
-- Dependencies: 558 5
-- Name: addnapdevice(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION addnapdevice(_deviceid integer, _napid integer) RETURNS integer
    AS $$
BEGIN
	INSERT INTO napdevice(deviceid, napid) VALUES (_deviceid, _napid);
	return 1;
End;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.addnapdevice(_deviceid integer, _napid integer) OWNER TO postgres;

--
-- TOC entry 21 (class 1255 OID 88286)
-- Dependencies: 558 5
-- Name: addswtichgroupdevice(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION addswtichgroupdevice(_deviceid integer, _switchgroupid integer) RETURNS integer
    AS $$
BEGIN
	INSERT INTO swtichgroupdevice(deviceid, switchgroupid) VALUES (_deviceid, _switchgroupid);
	return 1;
End;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.addswtichgroupdevice(_deviceid integer, _switchgroupid integer) OWNER TO postgres;

--
-- TOC entry 26 (class 1255 OID 90298)
-- Dependencies: 558 5
-- Name: changepri(character varying, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION changepri(tablename character varying, id1 integer, id2 integer) RETURNS boolean
    AS $$

DECLARE
    query  text;
    ipri1 integer;
    ipri2 integer;
BEGIN
    query := 'SELECT ipri FROM ' || tablename || ' where id ='||id1;
    EXECUTE query INTO ipri1;
    if ipri1 IS NULL THEN
	return false;	
    END if;

    query := 'SELECT ipri FROM ' || tablename || ' where id ='||id2;
    EXECUTE query INTO ipri2;
    if ipri2 IS NULL THEN
	return false;	
    END if;

    query := 'update ' || tablename || ' set ipri='|| ipri2 ||' where id ='||id1;
    EXECUTE query;
    
    query := 'update ' || tablename || ' set ipri='|| ipri1 ||' where id ='||id2;
    EXECUTE query;
    
    RETURN true;
EXCEPTION
    WHEN OTHERS THEN 
	RETURN false;    
END;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.changepri(tablename character varying, id1 integer, id2 integer) OWNER TO postgres;

--
-- TOC entry 22 (class 1255 OID 88287)
-- Dependencies: 558 5
-- Name: checkadminpwd(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION checkadminpwd(pwd_in character varying) RETURNS integer
    AS $$
 DECLARE
	r_id integer;
BEGIN
	select id into r_id from adminpwd where pwd=md5(pwd_in);
	if r_id IS NULL THEN
		return -1;
	ELSE
		return r_id;
	END if;
	
EXCEPTION
	WHEN OTHERS THEN 
		RETURN -1;
END;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.checkadminpwd(pwd_in character varying) OWNER TO postgres;

--
-- TOC entry 23 (class 1255 OID 88288)
-- Dependencies: 558 5
-- Name: checkuser(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION checkuser(username character varying, pwd character varying) RETURNS integer
    AS $$
 DECLARE
	r_id integer;
BEGIN
	select id into r_id from "user" where strname=username AND password=md5(pwd);
	if r_id IS NULL THEN
		return -1;
	ELSE
		return r_id;
	END if;
	
EXCEPTION
	WHEN OTHERS THEN 
		RETURN -1;
END;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.checkuser(username character varying, pwd character varying) OWNER TO postgres;

--
-- TOC entry 1576 (class 1259 OID 88328)
-- Dependencies: 5
-- Name: devices_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE devices_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.devices_id_seq OWNER TO postgres;

--
-- TOC entry 2625 (class 0 OID 0)
-- Dependencies: 1576
-- Name: devices_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('devices_id_seq', 1, true);


SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 1577 (class 1259 OID 88330)
-- Dependencies: 2066 5
-- Name: devices; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE devices (
    id integer DEFAULT nextval('devices_id_seq'::regclass) NOT NULL,
    strname character varying(256) NOT NULL,
    isubtype integer NOT NULL
);


ALTER TABLE public.devices OWNER TO postgres;

--
-- TOC entry 70 (class 1255 OID 120729)
-- Dependencies: 403 558 5
-- Name: devciebyapplianceid(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION devciebyapplianceid(appid integer) RETURNS SETOF devices
    AS $$

DECLARE
    r devices%rowtype;
BEGIN	
             FOR r IN select deviceid as id,(select strname from devices where devices.id=devicesetting.deviceid)as strname,subtype as isubtype from devicesetting where appliceid=appid order by strname LOOP
		RETURN NEXT r;
	     END LOOP;	     		
END;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.devciebyapplianceid(appid integer) OWNER TO postgres;

--
-- TOC entry 71 (class 1255 OID 120730)
-- Dependencies: 403 558 5
-- Name: devciebygroupid(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION devciebygroupid(dgroupid integer) RETURNS SETOF devices
    AS $$

DECLARE
    r devices%rowtype;
BEGIN	
             FOR r IN select deviceid as id,(select strname from devices where devices.id=devicesetting.deviceid) as strname from devicesetting where deviceid in (select deviceid from devicegroupdevice where devicegroupdevice.devicegroupid=dgroupid) order by strname LOOP
		RETURN NEXT r;
	     END LOOP;	     		
END;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.devciebygroupid(dgroupid integer) OWNER TO postgres;

--
-- TOC entry 1578 (class 1259 OID 88333)
-- Dependencies: 2067 2068 2069 2070 2071 2072 2073 2074 2075 2076 2077 2078 2079 2080 2081 2082 2083 2084 2085 2086 2087 2088 2089 2090 2091 2093 5
-- Name: devicesetting; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE devicesetting (
    id integer NOT NULL,
    deviceid integer NOT NULL,
    alias text,
    curversion integer DEFAULT 0,
    usermodifiedflag integer DEFAULT 0,
    subtype integer DEFAULT 2,
    accessmethod integer DEFAULT 6144 NOT NULL,
    accessability integer DEFAULT 0,
    livestatuas integer DEFAULT -1,
    telnetproxyid integer DEFAULT -1,
    snmpversion integer DEFAULT 0,
    appliceid integer DEFAULT 0,
    smarttelnetmethod integer DEFAULT 0,
    backtelnetmethod integer DEFAULT 0,
    monitormethod integer DEFAULT 0,
    telnetport integer DEFAULT 23,
    sshport integer DEFAULT 22,
    manageip integer DEFAULT 0,
    livehostname text,
    vendor text,
    model text,
    username text,
    userpassword text,
    enablepassword text,
    loginprompt text DEFAULT 'Username:'::text,
    passwordprompt text DEFAULT 'Password:'::text,
    nonprivilegeprompt text DEFAULT '>'::text,
    privilegeprompt text DEFAULT '#'::text,
    snmpro text,
    snmprw text,
    keyword text,
    proxy text,
    devicemode text,
    lasttimestamp timestamp without time zone DEFAULT now() NOT NULL,
    snmpport integer DEFAULT 161,
    serialnumber text,
    softwareversion text,
    contactor text,
    currentlocation text,
    keepitem1 integer DEFAULT 0,
    keepitem2 integer DEFAULT 0,
    keepitem3 integer DEFAULT 0,
    keepitem4 text,
    keepitem5 text,
    keepitem6 text,
    keepitem7 text,
    telnettooltype integer DEFAULT 0,
    telnettoolsession text,
    telnetcommandline text,
    cmdbserverid integer DEFAULT 0
);


ALTER TABLE public.devicesetting OWNER TO postgres;

--
-- TOC entry 46 (class 1255 OID 109487)
-- Dependencies: 404 558 5
-- Name: device_setting_retrieve(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION device_setting_retrieve(devname character varying) RETURNS devicesetting
    AS $$
declare
	r devicesetting%rowtype;
BEGIN
	SELECT * into r FROM devicesetting where deviceid IN ( select id from devices where strname=devname );
	return r;
END;

  $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.device_setting_retrieve(devname character varying) OWNER TO postgres;

--
-- TOC entry 45 (class 1255 OID 109486)
-- Dependencies: 5 558
-- Name: device_setting_retrieve0(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION device_setting_retrieve0(devname character varying) RETURNS SETOF record
    AS $$
declare
rec record;
begin
FOR rec IN SELECT * FROM devicesetting where deviceid IN ( select id from devices where strname=devname )
LOOP
RETURN next rec;
END LOOP;
return;
END;

  $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.device_setting_retrieve0(devname character varying) OWNER TO postgres;

--
-- TOC entry 44 (class 1255 OID 109485)
-- Dependencies: 558 5
-- Name: device_setting_retrieve1(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION device_setting_retrieve1(devname character varying) RETURNS SETOF refcursor
    AS $$

DECLARE 
	ref1 refcursor;
BEGIN
	OPEN ref1 FOR 
	 SELECT * FROM devicesetting;
	RETURN NEXT ref1;
	return; 
END;

  $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.device_setting_retrieve1(devname character varying) OWNER TO postgres;

--
-- TOC entry 56 (class 1255 OID 111556)
-- Dependencies: 5 558 404
-- Name: device_setting_retrieve_by_devs(character varying[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION device_setting_retrieve_by_devs(devnames character varying[]) RETURNS SETOF devicesetting
    AS $$
declare
	r devicesetting%rowtype;
BEGIN
	for r in SELECT * FROM devicesetting where deviceid IN ( select id from devices where strname = any( devnames ) ) loop
	return next r;
	end loop;	
END;

  $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.device_setting_retrieve_by_devs(devnames character varying[]) OWNER TO postgres;

--
-- TOC entry 43 (class 1255 OID 109484)
-- Dependencies: 5 558 404
-- Name: device_setting_update(character varying, devicesetting); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION device_setting_update(devname character varying, ds devicesetting) RETURNS integer
    AS $$
declare
	r_id integer;
	ds_id integer;
BEGIN
	select id into r_id from devices where strname=devname;
	if r_id IS NULL THEN
		return -1;
	end if;

	select id into ds_id from devicesetting where deviceid=r_id;
	if ds_id IS NULL THEN
		return -1;
	ELSE
		update devicesetting set ( 
			alias,
			curversion,
			usermodifiedflag,
			subtype,
			accessmethod,
			accessability,
			livestatuas,
			telnetproxyid,
			snmpversion,
			appliceid,
			smarttelnetmethod,
			backtelnetmethod,
			monitormethod,
			telnetport,
			sshport,
			manageip,
			livehostname,
			vendor,
			model,
			username,
			userpassword,
			enablepassword,
			loginprompt,
			passwordprompt,
			nonprivilegeprompt,
			privilegeprompt,
			snmpro,
			snmprw,
			keyword,
			proxy,
			devicemode,
			lasttimestamp,
			snmpport,
			serialnumber,
			softwareversion,
			contactor,
			currentlocation,
			keepitem1,
			keepitem2,
			keepitem3,
			keepitem4,
			keepitem5,
			keepitem6,
			keepitem7,
			telnettooltype,
			telnettoolsession,
			telnetcommandline,
			cmdbserverid)
			=( 
			ds.alias,
			ds.curversion,
			ds.usermodifiedflag,
			ds.subtype,
			ds.accessmethod,
			ds.accessability,
			ds.livestatuas, 
			ds.telnetproxyid,
			ds.snmpversion, 
			ds.appliceid,   
			ds.smarttelnetmethod,
			ds.backtelnetmethod,
			ds.monitormethod,
			ds.telnetport,  
			ds.sshport,     
			ds.manageip,    
			ds.livehostname,
			ds.vendor,                
			ds.model,                 
			ds.username,              
			ds.userpassword,          
			ds.enablepassword,        
			ds.loginprompt,           
			ds.passwordprompt,        
			ds.nonprivilegeprompt,    
			ds.privilegeprompt,       
			ds.snmpro,                
			ds.snmprw,                
			ds.keyword,               
			ds.proxy,                 
			ds.devicemode,            
			now(),         
			ds.snmpport,              
			ds.serialnumber,          
			ds.softwareversion,       
			ds.contactor,             
			ds.currentlocation,       
			ds.keepitem1,             
			ds.keepitem2,             
			ds.keepitem3,             
			ds.keepitem4,             
			ds.keepitem5,             
			ds.keepitem6,             
			ds.keepitem7,             
			ds.telnettooltype,        
			ds.telnettoolsession,     
			ds.telnetcommandline,     
			ds.cmdbserverid
			) 
			where id = ds_id;
		return ds_id;
	end if;
EXCEPTION
	WHEN OTHERS THEN 
		RETURN -2;
END;

  $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.device_setting_update(devname character varying, ds devicesetting) OWNER TO postgres;

--
-- TOC entry 42 (class 1255 OID 109483)
-- Dependencies: 5 404 558
-- Name: device_setting_upsert(character varying, devicesetting); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION device_setting_upsert(devname character varying, ds devicesetting) RETURNS integer
    AS $$
declare
	r_id integer;
	ds_id integer;
BEGIN
	select id into r_id from devices where strname=devname;
	if r_id IS NULL THEN
		return -1;
	end if;

	select id into ds_id from devicesetting where deviceid=r_id;
	if ds_id IS NULL THEN
		insert into devicesetting(
			deviceid,
			alias,
			curversion,
			usermodifiedflag,
			subtype,
			accessmethod,
			accessability,
			livestatuas,
			telnetproxyid,
			snmpversion,
			appliceid,
			smarttelnetmethod,
			backtelnetmethod,
			monitormethod,
			telnetport,
			sshport,
			manageip,
			livehostname,
			vendor,
			model,
			username,
			userpassword,
			enablepassword,
			loginprompt,
			passwordprompt,
			nonprivilegeprompt,
			privilegeprompt,
			snmpro,
			snmprw,
			keyword,
			proxy,
			devicemode,
			lasttimestamp,
			snmpport,
			serialnumber,
			softwareversion,
			contactor,
			currentlocation,
			keepitem1,
			keepitem2,
			keepitem3,
			keepitem4,
			keepitem5,
			keepitem6,
			keepitem7,
			telnettooltype,
			telnettoolsession,
			telnetcommandline,
			cmdbserverid)
			values ( 
			r_id,
			ds.alias,
			ds.curversion,
			ds.usermodifiedflag,
			ds.subtype,
			ds.accessmethod,
			ds.accessability,
			ds.livestatuas, 
			ds.telnetproxyid,
			ds.snmpversion, 
			ds.appliceid,   
			ds.smarttelnetmethod,
			ds.backtelnetmethod,
			ds.monitormethod,
			ds.telnetport,  
			ds.sshport,     
			ds.manageip,    
			ds.livehostname,
			ds.vendor,                
			ds.model,                 
			ds.username,              
			ds.userpassword,          
			ds.enablepassword,        
			ds.loginprompt,           
			ds.passwordprompt,        
			ds.nonprivilegeprompt,    
			ds.privilegeprompt,       
			ds.snmpro,                
			ds.snmprw,                
			ds.keyword,               
			ds.proxy,                 
			ds.devicemode,            
			now(),         
			ds.snmpport,              
			ds.serialnumber,          
			ds.softwareversion,       
			ds.contactor,             
			ds.currentlocation,       
			ds.keepitem1,             
			ds.keepitem2,             
			ds.keepitem3,             
			ds.keepitem4,             
			ds.keepitem5,             
			ds.keepitem6,             
			ds.keepitem7,             
			ds.telnettooltype,        
			ds.telnettoolsession,     
			ds.telnetcommandline,     
			ds.cmdbserverid
		);

		return lastval();
	ELSE
		update devicesetting set ( 
			alias,
			curversion,
			usermodifiedflag,
			subtype,
			accessmethod,
			accessability,
			livestatuas,
			telnetproxyid,
			snmpversion,
			appliceid,
			smarttelnetmethod,
			backtelnetmethod,
			monitormethod,
			telnetport,
			sshport,
			manageip,
			livehostname,
			vendor,
			model,
			username,
			userpassword,
			enablepassword,
			loginprompt,
			passwordprompt,
			nonprivilegeprompt,
			privilegeprompt,
			snmpro,
			snmprw,
			keyword,
			proxy,
			devicemode,
			lasttimestamp,
			snmpport,
			serialnumber,
			softwareversion,
			contactor,
			currentlocation,
			keepitem1,
			keepitem2,
			keepitem3,
			keepitem4,
			keepitem5,
			keepitem6,
			keepitem7,
			telnettooltype,
			telnettoolsession,
			telnetcommandline,
			cmdbserverid)
			=( 
			ds.alias,
			ds.curversion,
			ds.usermodifiedflag,
			ds.subtype,
			ds.accessmethod,
			ds.accessability,
			ds.livestatuas, 
			ds.telnetproxyid,
			ds.snmpversion, 
			ds.appliceid,   
			ds.smarttelnetmethod,
			ds.backtelnetmethod,
			ds.monitormethod,
			ds.telnetport,  
			ds.sshport,     
			ds.manageip,    
			ds.livehostname,
			ds.vendor,                
			ds.model,                 
			ds.username,              
			ds.userpassword,          
			ds.enablepassword,        
			ds.loginprompt,           
			ds.passwordprompt,        
			ds.nonprivilegeprompt,    
			ds.privilegeprompt,       
			ds.snmpro,                
			ds.snmprw,                
			ds.keyword,               
			ds.proxy,                 
			ds.devicemode,            
			now(),         
			ds.snmpport,              
			ds.serialnumber,          
			ds.softwareversion,       
			ds.contactor,             
			ds.currentlocation,       
			ds.keepitem1,             
			ds.keepitem2,             
			ds.keepitem3,             
			ds.keepitem4,             
			ds.keepitem5,             
			ds.keepitem6,             
			ds.keepitem7,             
			ds.telnettooltype,        
			ds.telnettoolsession,     
			ds.telnetcommandline,     
			ds.cmdbserverid
			) 
			where id = ds_id;
		return ds_id;
	end if;
EXCEPTION
	WHEN OTHERS THEN 
		RETURN -2;
END;

  $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.device_setting_upsert(devname character varying, ds devicesetting) OWNER TO postgres;

--
-- TOC entry 132 (class 1255 OID 121399)
-- Dependencies: 5 558 404
-- Name: devicelist(integer, integer, integer[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION devicelist(pageindexsize integer, pagesize integer, filer integer[]) RETURNS SETOF devicesetting
    AS $$

DECLARE
    r devicesetting%rowtype;
BEGIN		
		     FOR r IN select * from devicesetting where id in (select id from (SELECT id,(select strname from devices where devices.id=devicesetting.deviceid) as devicename FROM devicesetting where subtype = any( filer ) order by devicename) as a where a.devicename not in (SELECT (select strname from devices where devices.id=devicesetting.deviceid) as devicename FROM devicesetting where subtype = any( filer ) order by devicename limit pageindexsize ) order by a.devicename limit pagesize) LOOP
			RETURN NEXT r;
		     END LOOP;	     		    
END;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.devicelist(pageindexsize integer, pagesize integer, filer integer[]) OWNER TO postgres;

--
-- TOC entry 133 (class 1255 OID 121400)
-- Dependencies: 5 558 404
-- Name: devicelistbygroup(integer, integer, integer, integer[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION devicelistbygroup(groupid integer, pageindexsize integer, pagesize integer, filer integer[]) RETURNS SETOF devicesetting
    AS $$

DECLARE
    r devicesetting%rowtype;
BEGIN		
		     FOR r IN select * from devicesetting where id in (select id from (SELECT id,(select strname from devices where devices.id=devicesetting.deviceid) as devicename,deviceid FROM devicesetting where subtype =any( filer )  order by devicename) as a where a.deviceid in (select deviceid from devicegroupdevice where devicegroupdevice.devicegroupid=groupid)  and a.devicename not in (select devicename from ( SELECT deviceid,(select strname from devices where devices.id=devicesetting.deviceid) as devicename  FROM devicesetting where subtype =any( filer ) and deviceid in (select deviceid from devicegroupdevice where devicegroupdevice.devicegroupid=groupid)) as c order by c.devicename limit pageindexsize ) order by a.devicename limit pagesize) LOOP
			RETURN NEXT r;
		     END LOOP;	     			     
END;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.devicelistbygroup(groupid integer, pageindexsize integer, pagesize integer, filer integer[]) OWNER TO postgres;

--
-- TOC entry 1565 (class 1259 OID 88295)
-- Dependencies: 5
-- Name: appliance_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE appliance_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.appliance_id_seq OWNER TO postgres;

--
-- TOC entry 2626 (class 0 OID 0)
-- Dependencies: 1565
-- Name: appliance_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('appliance_id_seq', 1, true);


--
-- TOC entry 1605 (class 1259 OID 88459)
-- Dependencies: 2126 2127 2128 5
-- Name: nomp_appliance; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE nomp_appliance (
    id integer DEFAULT nextval('appliance_id_seq'::regclass) NOT NULL,
    strhostname character varying(32),
    strdescription character varying(128),
    stripaddr character varying(16),
    iserveport integer,
    bhome integer,
    blive integer,
    bmodified integer,
    imaxdevicecount integer DEFAULT 1500 NOT NULL,
    ibapport integer DEFAULT 7813 NOT NULL,
    ipri integer NOT NULL,
    telnet_user character varying(256),
    telnet_pwd character varying(256)
);


ALTER TABLE public.nomp_appliance OWNER TO postgres;

--
-- TOC entry 1712 (class 1259 OID 122976)
-- Dependencies: 1801 5
-- Name: devicesettingview; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW devicesettingview AS
    SELECT devicesetting.id, devicesetting.deviceid, devicesetting.alias, devicesetting.curversion, devicesetting.usermodifiedflag, devicesetting.subtype, devicesetting.accessmethod, devicesetting.accessability, devicesetting.livestatuas, devicesetting.telnetproxyid, devicesetting.snmpversion, devicesetting.appliceid, devicesetting.smarttelnetmethod, devicesetting.backtelnetmethod, devicesetting.monitormethod, devicesetting.telnetport, devicesetting.sshport, devicesetting.manageip, devicesetting.livehostname, devicesetting.vendor, devicesetting.model, devicesetting.username, devicesetting.userpassword, devicesetting.enablepassword, devicesetting.loginprompt, devicesetting.passwordprompt, devicesetting.nonprivilegeprompt, devicesetting.privilegeprompt, devicesetting.snmpro, devicesetting.snmprw, devicesetting.keyword, devicesetting.proxy, devicesetting.devicemode, devicesetting.lasttimestamp, devicesetting.snmpport, devicesetting.serialnumber, devicesetting.softwareversion, devicesetting.contactor, devicesetting.currentlocation, devicesetting.keepitem1, devicesetting.keepitem2, devicesetting.keepitem3, devicesetting.keepitem4, devicesetting.keepitem5, devicesetting.keepitem6, devicesetting.keepitem7, devicesetting.telnettooltype, devicesetting.telnettoolsession, devicesetting.telnetcommandline, devicesetting.cmdbserverid, devices.strname AS devicename, nomp_appliance.strhostname AS hostname FROM devicesetting, devices, nomp_appliance WHERE ((devices.id = devicesetting.deviceid) AND (nomp_appliance.id = devicesetting.appliceid));


ALTER TABLE public.devicesettingview OWNER TO postgres;

--
-- TOC entry 138 (class 1255 OID 122982)
-- Dependencies: 558 5 557
-- Name: devicelistbygroupnofiler(integer, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION devicelistbygroupnofiler(groupid integer, pageindexsize integer, pagesize integer) RETURNS SETOF devicesettingview
    AS $$

DECLARE
    r devicesettingview%rowtype;
BEGIN			     
		     FOR r IN select * from devicesettingview where deviceid in (select deviceid from devicegroupdeviceview where devicegroupid =groupid and deviceid not in (select deviceid from devicegroupdeviceview where devicegroupid =groupid order by lower(devicename) limit pageindexsize) order by lower(devicename) limit pagesize ) order by lower(devicename) LOOP
			RETURN NEXT r;
		     END LOOP;			     
END;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.devicelistbygroupnofiler(groupid integer, pageindexsize integer, pagesize integer) OWNER TO postgres;

--
-- TOC entry 137 (class 1255 OID 122981)
-- Dependencies: 558 5 557
-- Name: devicelistnofiler(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION devicelistnofiler(pageindexsize integer, pagesize integer) RETURNS SETOF devicesettingview
    AS $$

DECLARE
    r devicesettingview%rowtype;
BEGIN				     
		    FOR r IN select * from devicesettingview where id not in ( select id from devicesettingview order by lower(devicename) limit pageindexsize ) order by lower(devicename) limit pagesize LOOP
			RETURN NEXT r;
		     END LOOP;		     		
END;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.devicelistnofiler(pageindexsize integer, pagesize integer) OWNER TO postgres;

--
-- TOC entry 51 (class 1255 OID 111539)
-- Dependencies: 558 5 403
-- Name: devices_retrieve(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION devices_retrieve() RETURNS SETOF devices
    AS $$
declare
	r devices%rowtype;
BEGIN
   for r in SELECT * FROM devices loop
   return next r;
   end loop;
END;

  $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.devices_retrieve() OWNER TO postgres;

--
-- TOC entry 1580 (class 1259 OID 88366)
-- Dependencies: 5
-- Name: donotscan_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE donotscan_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.donotscan_id_seq OWNER TO postgres;

--
-- TOC entry 2627 (class 0 OID 0)
-- Dependencies: 1580
-- Name: donotscan_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('donotscan_id_seq', 1, true);


--
-- TOC entry 1581 (class 1259 OID 88368)
-- Dependencies: 2094 2095 5
-- Name: donotscan; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE donotscan (
    id integer DEFAULT nextval('donotscan_id_seq'::regclass) NOT NULL,
    groupid integer NOT NULL,
    subnetmask character varying(32) NOT NULL,
    scanfrom integer DEFAULT -1 NOT NULL,
    snmpro character varying(128)
);


ALTER TABLE public.donotscan OWNER TO postgres;

--
-- TOC entry 108 (class 1255 OID 120820)
-- Dependencies: 5 407 558
-- Name: donotscan_retrieve(timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION donotscan_retrieve(dt timestamp without time zone, stypename character varying) RETURNS SETOF donotscan
    AS $$
declare
	r donotscan%rowtype;
	t timestamp without time zone;
BEGIN		
        select modifytime into t from objtimestamp where typename=stypename;
	if t is null or t>dt then
		for r in SELECT * FROM donotscan order by id loop
		return next r;
		end loop;	
	End IF;
END;

  $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.donotscan_retrieve(dt timestamp without time zone, stypename character varying) OWNER TO postgres;

--
-- TOC entry 131 (class 1255 OID 122715)
-- Dependencies: 558 5
-- Name: getdevicelistcountbygroup(integer, integer[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION getdevicelistcountbygroup(groupid integer, filer integer[]) RETURNS integer
    AS $$
declare
	t integer;			
BEGIN
	SELECT count(deviceid) as c into t FROM devicesetting where deviceid in (select deviceid from devicegroupdevice where devicegroupdevice.devicegroupid=groupid) and subtype = any( filer );	
	return t;
End;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.getdevicelistcountbygroup(groupid integer, filer integer[]) OWNER TO postgres;

--
-- TOC entry 134 (class 1255 OID 122724)
-- Dependencies: 558 5
-- Name: getdevicelistcountbygroupnofiler(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION getdevicelistcountbygroupnofiler(groupid integer) RETURNS integer
    AS $$
declare
	t integer;			
BEGIN
	SELECT count(deviceid) as c into t FROM devicesetting where deviceid in (select deviceid from devicegroupdevice where devicegroupdevice.devicegroupid=groupid);	
	return t;
End;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.getdevicelistcountbygroupnofiler(groupid integer) OWNER TO postgres;

--
-- TOC entry 1590 (class 1259 OID 88397)
-- Dependencies: 2102 2103 2104 2105 2107 5
-- Name: interfacesetting; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE interfacesetting (
    id integer NOT NULL,
    deviceid integer NOT NULL,
    interfacename text NOT NULL,
    usermodifiedflag integer DEFAULT 0,
    livestatus integer DEFAULT -1,
    mibindex integer DEFAULT -1,
    bandwidth integer DEFAULT -1,
    macaddress text,
    lasttimestamp timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.interfacesetting OWNER TO postgres;

--
-- TOC entry 41 (class 1255 OID 109482)
-- Dependencies: 558 5 417
-- Name: interface_setting_retrieve(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION interface_setting_retrieve(devname character varying, ifname character varying) RETURNS SETOF interfacesetting
    AS $$
declare
	r interfacesetting%rowtype;
BEGIN
	if ifname IS null then
		for r in SELECT * FROM interfacesetting where deviceid IN ( select id from devices where strname=devname ) loop
		return next r;
		end loop;
	else
		for r in SELECT * FROM interfacesetting where deviceid IN ( select id from devices where strname=devname ) AND interfacename=ifname loop
		return next r;
		end loop;
	end if;
END;

  $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.interface_setting_retrieve(devname character varying, ifname character varying) OWNER TO postgres;

--
-- TOC entry 55 (class 1255 OID 111555)
-- Dependencies: 5 558 417
-- Name: interface_setting_retrieve_by_devs(character varying[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION interface_setting_retrieve_by_devs(devnames character varying[]) RETURNS SETOF interfacesetting
    AS $$
declare
	r interfacesetting%rowtype;
BEGIN
	for r in SELECT * FROM interfacesetting where deviceid IN ( select id from devices where strname = any( devnames ) ) loop
	return next r;
	end loop;
END;

  $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.interface_setting_retrieve_by_devs(devnames character varying[]) OWNER TO postgres;

--
-- TOC entry 40 (class 1255 OID 109481)
-- Dependencies: 5 417 558
-- Name: interface_setting_update(character varying, interfacesetting); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION interface_setting_update(devname character varying, ins interfacesetting) RETURNS integer
    AS $$
declare
	r_id integer;
	ds_id integer;
BEGIN
	select id into r_id from devices where strname=devname;
	if r_id IS NULL THEN
		return -1;
	end if;

	select id into ds_id from interfacesetting where deviceid=r_id AND interfacename=ins.interfacename;
	if ds_id IS NULL THEN
		return -1;
	else
		update interfacesetting set(
		  usermodifiedflag,
		  livestatus,
		  mibindex,
		  bandwidth,
		  macaddress,
		  lasttimestamp
		  ) = ( 
		  ins.usermodifiedflag,
		  ins.livestatus,
		  ins.mibindex,
		  ins.bandwidth,
		  ins.macaddress,
		  ins.lasttimestamp
		  ) 
		  where id = ds_id;
		return ds_id;
	end if;
EXCEPTION
	WHEN OTHERS THEN 
		RETURN -2;	
END;

  $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.interface_setting_update(devname character varying, ins interfacesetting) OWNER TO postgres;

--
-- TOC entry 39 (class 1255 OID 109480)
-- Dependencies: 558 5 417
-- Name: interface_setting_upsert(character varying, interfacesetting); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION interface_setting_upsert(devname character varying, ins interfacesetting) RETURNS integer
    AS $$
declare
	r_id integer;
	ds_id integer;
BEGIN
	select id into r_id from devices where strname=devname;
	if r_id IS NULL THEN
		return -1;
	end if;

	select id into ds_id from interfacesetting where deviceid=r_id AND interfacename=ins.interfacename;
	if ds_id IS NULL THEN
		insert into interfacesetting(
			  deviceid,
			  interfacename,
			  usermodifiedflag,
			  livestatus,
			  mibindex,
			  bandwidth,
			  macaddress)
			  values( 
			  r_id,
			  ins.interfacename,
			  ins.usermodifiedflag,
			  ins.livestatus,
			  ins.mibindex,
			  ins.bandwidth,
			  ins.macaddress
			  );
			  return lastval();
	else
		update interfacesetting set(
			  usermodifiedflag,
			  livestatus,
			  mibindex,
			  bandwidth,
			  macaddress,
			  lasttimestamp
			  ) = ( 
			  ins.usermodifiedflag,
			  ins.livestatus,
			  ins.mibindex,
			  ins.bandwidth,
			  ins.macaddress,
			  ins.lasttimestamp
			  ) 
			  where id = ds_id;
		return ds_id;
	end if;
EXCEPTION
	WHEN OTHERS THEN 
		RETURN -2;	
END;

  $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.interface_setting_upsert(devname character varying, ins interfacesetting) OWNER TO postgres;

--
-- TOC entry 38 (class 1255 OID 109479)
-- Dependencies: 558 5
-- Name: ip_2_mac_delete_by_key(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ip_2_mac_delete_by_key(rip character varying, rmac character varying) RETURNS integer
    AS $$
BEGIN
	delete from ip2mac where ip=rip AND mac=rmac;
	return 0;
END;

  $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.ip_2_mac_delete_by_key(rip character varying, rmac character varying) OWNER TO postgres;

--
-- TOC entry 49 (class 1255 OID 109509)
-- Dependencies: 558 5
-- Name: ip_2_mac_delete_by_lan(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ip_2_mac_delete_by_lan(l character varying) RETURNS integer
    AS $$
BEGIN
	delete from ip2mac where lan = l;
	return 0;
END;

  $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.ip_2_mac_delete_by_lan(l character varying) OWNER TO postgres;

--
-- TOC entry 1592 (class 1259 OID 88409)
-- Dependencies: 2108 2109 5
-- Name: ip2mac; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ip2mac (
    id integer NOT NULL,
    alias text NOT NULL,
    lan character varying(50) NOT NULL,
    gateway character varying(50) NOT NULL,
    ip character varying(50) NOT NULL,
    mac character varying(50) NOT NULL,
    devicename character varying(64),
    interfacename character varying(64),
    switchname character varying(64),
    portname character varying(64),
    vlan integer DEFAULT 1,
    userflag integer DEFAULT 0,
    servertype integer NOT NULL,
    retrievedate timestamp without time zone NOT NULL
);


ALTER TABLE public.ip2mac OWNER TO postgres;

--
-- TOC entry 58 (class 1255 OID 112642)
-- Dependencies: 5 558 419
-- Name: ip_2_mac_retrieve_by_device(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ip_2_mac_retrieve_by_device(i character varying) RETURNS SETOF ip2mac
    AS $$
declare
	r ip2mac%rowtype;
BEGIN
   for r in SELECT * FROM ip2mac where devicename = i loop
   return next r;
   end loop;
END;

  $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.ip_2_mac_retrieve_by_device(i character varying) OWNER TO postgres;

--
-- TOC entry 59 (class 1255 OID 112643)
-- Dependencies: 419 5 558
-- Name: ip_2_mac_retrieve_by_device_interface(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ip_2_mac_retrieve_by_device_interface(d character varying, i character varying) RETURNS SETOF ip2mac
    AS $$
declare
	r ip2mac%rowtype;
BEGIN
   for r in SELECT * FROM ip2mac where devicename = d AND interfacename = i loop
   return next r;
   end loop;
END;

  $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.ip_2_mac_retrieve_by_device_interface(d character varying, i character varying) OWNER TO postgres;

--
-- TOC entry 37 (class 1255 OID 109478)
-- Dependencies: 419 5 558
-- Name: ip_2_mac_retrieve_by_ip(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ip_2_mac_retrieve_by_ip(i character varying) RETURNS SETOF ip2mac
    AS $$
declare
	r ip2mac%rowtype;
BEGIN
   for r in SELECT * FROM ip2mac where ip = i loop
   return next r;
   end loop;
END;

  $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.ip_2_mac_retrieve_by_ip(i character varying) OWNER TO postgres;

--
-- TOC entry 36 (class 1255 OID 109477)
-- Dependencies: 419 5 558
-- Name: ip_2_mac_retrieve_by_lan(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ip_2_mac_retrieve_by_lan(lanname character varying) RETURNS SETOF ip2mac
    AS $$
declare
	r ip2mac%rowtype;
BEGIN
   for r in SELECT * FROM ip2mac where lan = lanname loop
   return next r;
   end loop;
END;

  $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.ip_2_mac_retrieve_by_lan(lanname character varying) OWNER TO postgres;

--
-- TOC entry 35 (class 1255 OID 109476)
-- Dependencies: 558 5 419
-- Name: ip_2_mac_retrieve_by_mac(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ip_2_mac_retrieve_by_mac(m character varying) RETURNS SETOF ip2mac
    AS $$
declare
	r ip2mac%rowtype;
BEGIN
   for r in SELECT * FROM ip2mac where mac = m loop
   return next r;
   end loop;
END;

  $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.ip_2_mac_retrieve_by_mac(m character varying) OWNER TO postgres;

--
-- TOC entry 60 (class 1255 OID 113641)
-- Dependencies: 419 558 5
-- Name: ip_2_mac_retrieve_by_switch(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ip_2_mac_retrieve_by_switch(i character varying) RETURNS SETOF ip2mac
    AS $$
declare
	r ip2mac%rowtype;
BEGIN
   for r in SELECT * FROM ip2mac where switchname = i loop
   return next r;
   end loop;
END;

  $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.ip_2_mac_retrieve_by_switch(i character varying) OWNER TO postgres;

--
-- TOC entry 47 (class 1255 OID 109488)
-- Dependencies: 558 5 419
-- Name: ip_2_mac_retrieve_by_switch_port(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ip_2_mac_retrieve_by_switch_port(s character varying, p character varying) RETURNS SETOF ip2mac
    AS $$
declare
	r ip2mac%rowtype;
BEGIN
   for r in SELECT * FROM ip2mac where switchname = s AND portname=p loop
   return next r;
   end loop;
END;

  $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.ip_2_mac_retrieve_by_switch_port(s character varying, p character varying) OWNER TO postgres;

--
-- TOC entry 34 (class 1255 OID 109475)
-- Dependencies: 558 5 419
-- Name: ip_2_mac_retrieve_like_ip(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ip_2_mac_retrieve_like_ip(i character varying) RETURNS SETOF ip2mac
    AS $$
declare
	r ip2mac%rowtype;
BEGIN
	for r in SELECT * FROM ip2mac where ip like '%'||i||'%' loop
	return next r;
	end loop;
END;

  $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.ip_2_mac_retrieve_like_ip(i character varying) OWNER TO postgres;

--
-- TOC entry 33 (class 1255 OID 109474)
-- Dependencies: 558 5 419
-- Name: ip_2_mac_retrieve_like_lan(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ip_2_mac_retrieve_like_lan(l character varying) RETURNS SETOF ip2mac
    AS $$
declare
	r ip2mac%rowtype;
BEGIN
	for r in SELECT * FROM ip2mac where lan like '%'||l||'%' loop
	return next r;
	end loop;
END;

  $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.ip_2_mac_retrieve_like_lan(l character varying) OWNER TO postgres;

--
-- TOC entry 32 (class 1255 OID 109473)
-- Dependencies: 558 5 419
-- Name: ip_2_mac_retrieve_like_mac(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ip_2_mac_retrieve_like_mac(m character varying) RETURNS SETOF ip2mac
    AS $$
declare
	r ip2mac%rowtype;
BEGIN
	for r in SELECT * FROM ip2mac where mac like '%'||m||'%' loop
	return next r;
	end loop;
END;

  $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.ip_2_mac_retrieve_like_mac(m character varying) OWNER TO postgres;

--
-- TOC entry 31 (class 1255 OID 109472)
-- Dependencies: 558 5 419
-- Name: ip_2_mac_upsert(ip2mac); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ip_2_mac_upsert(r ip2mac) RETURNS integer
    AS $$
declare
	ds_id integer;
BEGIN
	select id into ds_id from ip2mac where ip=r.ip AND mac=r.mac;
	if ds_id IS NULL THEN
		insert into ip2mac(
			  alias,
			  lan,
			  gateway,
			  ip,
			  mac,
			  devicename,
			  interfacename,
			  switchname,
			  portname,
			  vlan,
			  userflag,
			  servertype,
			  retrievedate
			  )
			  values( 
			  r.alias,
			  r.lan,
			  r.gateway,
			  r.ip,
			  r.mac,
			  r.devicename,
			  r.interfacename,
			  r.switchname,
			  r.portname,
			  r.vlan,
			  r.userflag,
			  r.servertype,
			  now()
			  );
			  return lastval();
	else
		update ip2mac set(
			  alias,
			  lan,
			  gateway,
			  devicename,
			  interfacename,
			  switchname,
			  portname,
			  vlan,
			  userflag,
			  servertype,
			  retrievedate
			  ) = ( 
			  r.alias,
			  r.lan,
			  r.gateway,
			  r.devicename,
			  r.interfacename,
			  r.switchname,
			  r.portname,
			  r.vlan,
			  r.userflag,
			  r.servertype,
			  now()
			  ) 
			  where id = ds_id;
		return ds_id;
	end if;
EXCEPTION
	WHEN OTHERS THEN 
		RETURN -2;	
END;

  $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.ip_2_mac_upsert(r ip2mac) OWNER TO postgres;

--
-- TOC entry 48 (class 1255 OID 109508)
-- Dependencies: 5 558
-- Name: l2_connectivity_delete_by_group(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION l2_connectivity_delete_by_group(g character varying) RETURNS integer
    AS $$
BEGIN
	delete from l2connectivity where sourcedevice in ( select strname from devices where id in ( select deviceid from swtichgroupdevice where switchgroupid in ( select id from switchgroup where strname = g ) ) );
	delete from l2connectivity where destdevice in ( select strname from devices where id in ( select deviceid from swtichgroupdevice where switchgroupid in ( select id from switchgroup where strname = g ) ) );
	return 0;
END;

  $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.l2_connectivity_delete_by_group(g character varying) OWNER TO postgres;

--
-- TOC entry 57 (class 1255 OID 109471)
-- Dependencies: 558 5
-- Name: l2_connectivity_delete_by_key(character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION l2_connectivity_delete_by_key(sd character varying, sp character varying, dd character varying, dp character varying) RETURNS integer
    AS $$
BEGIN
	delete from l2connectivity where ( sourcedevice=sd AND sourceport=sp AND destdevice=dd AND destport=dp ) OR ( sourcedevice=dd AND sourceport=dp AND destdevice=sd AND destport=sp );
	return 0;
END;

  $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.l2_connectivity_delete_by_key(sd character varying, sp character varying, dd character varying, dp character varying) OWNER TO postgres;

--
-- TOC entry 1656 (class 1259 OID 90758)
-- Dependencies: 2160 2161 2162 2163 5
-- Name: l2connectivity; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE l2connectivity (
    id integer NOT NULL,
    sourcedevice character varying(64) NOT NULL,
    sourceport character varying(64) NOT NULL,
    destdevice character varying(64) NOT NULL,
    destport character varying(64) NOT NULL,
    userflag integer DEFAULT 0,
    retrievedate timestamp without time zone DEFAULT now(),
    isrctype integer DEFAULT 2001 NOT NULL,
    idesttype integer DEFAULT 2001 NOT NULL
);


ALTER TABLE public.l2connectivity OWNER TO postgres;

--
-- TOC entry 30 (class 1255 OID 109470)
-- Dependencies: 5 485 558
-- Name: l2_connectivity_retrieve_by_switch_port(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION l2_connectivity_retrieve_by_switch_port(s character varying, p character varying) RETURNS SETOF l2connectivity
    AS $$
declare
	r l2connectivity%rowtype;
BEGIN
	for r in SELECT * FROM l2connectivity where ( sourcedevice = s AND sourceport=p ) OR (destdevice = s AND destport=p) loop
	return next r;
	end loop;
END;

  $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.l2_connectivity_retrieve_by_switch_port(s character varying, p character varying) OWNER TO postgres;

--
-- TOC entry 61 (class 1255 OID 109469)
-- Dependencies: 485 558 5
-- Name: l2_connectivity_retrieve_like_device(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION l2_connectivity_retrieve_like_device(d character varying) RETURNS SETOF l2connectivity
    AS $$
declare
	r l2connectivity%rowtype;
BEGIN
	for r in SELECT * FROM l2connectivity where sourcedevice like '%'||d||'%' OR destdevice like '%'||d||'%' loop
	return next r;
	end loop;
END;

  $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.l2_connectivity_retrieve_like_device(d character varying) OWNER TO postgres;

--
-- TOC entry 53 (class 1255 OID 109468)
-- Dependencies: 485 558 5
-- Name: l2_connectivity_upsert(l2connectivity); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION l2_connectivity_upsert(r l2connectivity) RETURNS integer
    AS $$
declare
	ds_id integer;
BEGIN
	select id into ds_id from l2connectivity where ( sourcedevice=r.sourcedevice AND sourceport=r.sourceport AND destdevice=r.destdevice AND destport=r.destport ) OR ( sourcedevice=r.destdevice AND sourceport=r.destport AND destdevice=r.sourcedevice AND destport=r.sourceport );
	if ds_id IS NULL THEN
		insert into l2connectivity(
			  sourcedevice,
			  sourceport,
			  destdevice,
			  destport,
			  userflag,
			  retrievedate,
			  isrctype,
			  idesttype
			  )
			  values( 
			  r.sourcedevice,
			  r.sourceport,
			  r.destdevice,
			  r.destport,
			  r.userflag,
			  now(),
			  r.isrctype,
			  r.idesttype
			  );
			  return lastval();
	else
		update l2connectivity set(
			  userflag,
			  retrievedate,
			  isrctype,
			  idesttype
			  ) = ( 
			  r.userflag,
			  now(),
			  r.isrctype,
			  r.idesttype
			  ) 
			  where id = ds_id;
		return ds_id;
	end if;
EXCEPTION
	WHEN OTHERS THEN 
		RETURN -2;	
END;

  $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.l2_connectivity_upsert(r l2connectivity) OWNER TO postgres;

--
-- TOC entry 1658 (class 1259 OID 90773)
-- Dependencies: 2165 5
-- Name: l2switchinfo; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE l2switchinfo (
    id integer NOT NULL,
    devicename character varying(64) NOT NULL,
    devicealias character varying(128),
    managementip character varying(50) NOT NULL,
    managementmask character varying(50) NOT NULL,
    switchtype integer NOT NULL,
    subtype integer NOT NULL,
    isiosswitch integer NOT NULL,
    ios_version character varying(64),
    snmpro character varying(50),
    snmprw character varying(50),
    description character varying(512),
    nb_timestamp timestamp without time zone DEFAULT now() NOT NULL,
    usermodifed integer NOT NULL,
    iproutecmds character varying(256)
);


ALTER TABLE public.l2switchinfo OWNER TO postgres;

--
-- TOC entry 2628 (class 0 OID 0)
-- Dependencies: 1658
-- Name: COLUMN l2switchinfo.usermodifed; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN l2switchinfo.usermodifed IS '0: org  1: discovery  2: manual';


--
-- TOC entry 143 (class 1255 OID 112635)
-- Dependencies: 558 5 487
-- Name: l2_switchinfo_upsert(l2switchinfo); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION l2_switchinfo_upsert(r l2switchinfo) RETURNS integer
    AS $$
declare
	ds_id integer;
BEGIN
	select id into ds_id from l2switchinfo where devicename = r.devicename ;
	if ds_id IS NULL THEN
		insert into l2switchinfo(
			devicename,
			devicealias,
			managementip,
			managementmask,
			switchtype,
			subtype,
			isiosswitch,
			ios_version,
			snmpro,
			snmprw,
			description,
			nb_timestamp,
			usermodifed,
			iproutecmds
			)
			values( 
			r.devicename,
			r.devicealias,
			r.managementip,
			r.managementmask,
			r.switchtype,
			r.subtype,
			r.isiosswitch,
			r.ios_version,
			r.snmpro,
			r.snmprw,
			r.description,
			now(),
			r.usermodifed,
			r.iproutecmds
			);
			select * from updateversion('L2Switch' );
			return lastval();
	else
		update l2switchinfo set(
			devicealias,
			managementip,
			managementmask,
			switchtype,
			subtype,
			isiosswitch,
			ios_version,
			snmpro,
			snmprw,
			description,
			nb_timestamp,
			usermodifed,
			iproutecmds
			) = ( 
			r.devicealias,
			r.managementip,
			r.managementmask,
			r.switchtype,
			r.subtype,
			r.isiosswitch,
			r.ios_version,
			r.snmpro,
			r.snmprw,
			r.description,
			now(),
			r.usermodifed,
			r.iproutecmds
			) 
			where id = ds_id;

		select * from updateversion('L2Switch' );
		return ds_id;
	end if;
EXCEPTION
	WHEN OTHERS THEN 
		RETURN -2;	
END;

  $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.l2_switchinfo_upsert(r l2switchinfo) OWNER TO postgres;

--
-- TOC entry 54 (class 1255 OID 109467)
-- Dependencies: 558 5
-- Name: lan_switch_delete_by_key(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION lan_switch_delete_by_key(l character varying, s character varying) RETURNS integer
    AS $$
BEGIN
	delete from lanswitch where lanname=l AND switchname=s;
	return 0;
END;

  $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.lan_switch_delete_by_key(l character varying, s character varying) OWNER TO postgres;

--
-- TOC entry 52 (class 1255 OID 109507)
-- Dependencies: 558 5
-- Name: lan_switch_delete_by_lan(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION lan_switch_delete_by_lan(l character varying) RETURNS integer
    AS $$
BEGIN
	delete from lanswitch where lanname=l;
	return 0;
EXCEPTION
	WHEN OTHERS THEN 
		RETURN -2;	
END;

  $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.lan_switch_delete_by_lan(l character varying) OWNER TO postgres;

--
-- TOC entry 1600 (class 1259 OID 88448)
-- Dependencies: 2123 2125 5
-- Name: lanswitch; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE lanswitch (
    id integer NOT NULL,
    lanname character varying(64) NOT NULL,
    gateway character varying(64),
    switchname character varying(64) NOT NULL,
    ports text,
    userflag integer DEFAULT 0,
    retrievedate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.lanswitch OWNER TO postgres;

--
-- TOC entry 29 (class 1255 OID 109466)
-- Dependencies: 427 5 558
-- Name: lan_switch_retrieve_by_lan(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION lan_switch_retrieve_by_lan(lan character varying) RETURNS SETOF lanswitch
    AS $$
declare
	r lanswitch%rowtype;
BEGIN
   for r in SELECT * FROM lanswitch where lanname = lan loop
   return next r;
   end loop;
END;

  $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.lan_switch_retrieve_by_lan(lan character varying) OWNER TO postgres;

--
-- TOC entry 28 (class 1255 OID 109465)
-- Dependencies: 427 558 5
-- Name: lan_switch_upsert(lanswitch); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION lan_switch_upsert(r lanswitch) RETURNS integer
    AS $$
declare
	ds_id integer;
BEGIN
	select id into ds_id from lanswitch where lanname=r.lanname AND switchname=r.switchname;
	if ds_id IS NULL THEN
		insert into lanswitch(
			lanname,
			gateway,
			switchname,
			ports,
			userflag,
			retrievedate
			)
			values( 
			r.lanname,
			r.gateway,
			r.switchname,
			r.ports,
			r.userflag,
			now()
			);
			return lastval();
	else
		update lanswitch set(
			gateway,
			ports,
			userflag,
			retrievedate
			) = ( 
			r.gateway,
			r.ports,
			r.userflag,
			now()
			) 
			where id = ds_id;
		return ds_id;
	end if;
EXCEPTION
	WHEN OTHERS THEN 
		RETURN -2;	
END;

  $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.lan_switch_upsert(r lanswitch) OWNER TO postgres;

--
-- TOC entry 24 (class 1255 OID 88289)
-- Dependencies: 558 5
-- Name: process_adminpwd_p(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_adminpwd_p() RETURNS "trigger"
    AS $$
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF NEW.pwd IS NOT NULL THEN 
			NEW.pwd = md5( NEW.pwd );
		END IF;
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		NEW.pwd = md5( NEW.pwd );
		RETURN NEW;
        END IF;
        RETURN NULL;
    END;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.process_adminpwd_p() OWNER TO postgres;

--
-- TOC entry 66 (class 1255 OID 113668)
-- Dependencies: 5 558
-- Name: process_appliance(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_appliance() RETURNS "trigger"
    AS $$
    BEGIN
        IF (TG_OP = 'UPDATE') THEN		
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN                
		NEW.ipri=nextval('nomp_appliance_ipri_seq'::regclass);						                				
		RETURN NEW;        
        END IF;
        RETURN NULL;
    END;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.process_appliance() OWNER TO postgres;

--
-- TOC entry 116 (class 1255 OID 121131)
-- Dependencies: 558 5
-- Name: process_devicegroup_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_devicegroup_dt() RETURNS "trigger"
    AS $$
declare tid integer;
declare uid integer;
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.strname = NEW.strname AND 
			OLD.strdesc = NEW.strdesc AND
			OLD.userid = NEW.userid AND			
			OLD.showcolor = NEW.showcolor 
		then
			return OLD;
		end IF;

		if not NEW.userid=OLD.userid then
			update objtimestamp set modifytime=now() where typename='PublicDeviceGroup';
			if new.userid=-1 then
				uid=old.userid;
			else 
				uid=new.userid;
			end if;
			select id into tid from objtimestamp where typename='PrivateDeviceGroup' and userid=uid;
			if tid is null then
				insert into objtimestamp (typename,userid,modifytime) values('PrivateDeviceGroup',uid,now());
			else
				update objtimestamp set modifytime=now() where typename='PrivateDeviceGroup' and userid=uid;
			end if;
		elseif NEW.userid=-1 then
			update objtimestamp set modifytime=now() where typename='PublicDeviceGroup';
		else
			select id into tid from objtimestamp where typename='PrivateDeviceGroup' and userid=new.userid;
			if tid is null then
				insert into objtimestamp (typename,userid,modifytime) values('PrivateDeviceGroup',new.userid,now());
			else
				update objtimestamp set modifytime=now() where typename='PrivateDeviceGroup' and userid=new.userid;
			end if;	
		end if;		
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		if NEW.userid=-1 then
			update objtimestamp set modifytime=now() where typename='PublicDeviceGroup';
		else
			select id into tid from objtimestamp where typename='PrivateDeviceGroup' and userid=new.userid;
			if tid is null then
				insert into objtimestamp (typename,userid,modifytime) values('PrivateDeviceGroup',new.userid,now());
			else
				update objtimestamp set modifytime=now() where typename='PrivateDeviceGroup' and userid=new.userid;
			end if;	
		end if;	
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		if OLD.userid=-1 then
			update objtimestamp set modifytime=now() where typename='PublicDeviceGroup';
		else
			select id into tid from objtimestamp where typename='PrivateDeviceGroup' and userid=OLD.userid;
			if tid is null then
				insert into objtimestamp (typename,userid,modifytime) values('PrivateDeviceGroup',old.userid,now());
			else
				update objtimestamp set modifytime=now() where typename='PrivateDeviceGroup' and userid=old.userid;
			end if;	
		end if;			
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.process_devicegroup_dt() OWNER TO postgres;

--
-- TOC entry 124 (class 1255 OID 121176)
-- Dependencies: 558 5
-- Name: process_devicegroupdevice_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_devicegroupdevice_dt() RETURNS "trigger"
    AS $$
declare tid integer;
declare uid integer;
DECLARE newuserid integer;
DECLARE olduserid integer;
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.devicegroupid = NEW.devicegroupid AND 				
			OLD.deviceid = NEW.deviceid 
		then
			return OLD;
		end IF;
		select userid into newuserid from devicegroup where id=NEW.devicegroupid;
		select userid into olduserid from devicegroup where id=old.devicegroupid;

		if not newuserid=olduserid then
			update objtimestamp set modifytime=now() where typename='PublicDeviceGroup';
			if newuserid=-1 then
				uid=olduserid;
			else 
				uid=newuserid;
			end if;
			select id into tid from objtimestamp where typename='PrivateDeviceGroup' and userid=uid;
			if tid is null then
				insert into objtimestamp (typename,userid,modifytime) values('PrivateDeviceGroup',uid,now());
			else
				update objtimestamp set modifytime=now() where typename='PrivateDeviceGroup' and userid=uid;
			end if;
		elseif newuserid=-1 then
			update objtimestamp set modifytime=now() where typename='PublicDeviceGroup';
		else
			select id into tid from objtimestamp where typename='PrivateDeviceGroup' and userid=newuserid;
			if tid is null then
				insert into objtimestamp (typename,userid,modifytime) values('PrivateDeviceGroup',newuserid,now());
			else
				update objtimestamp set modifytime=now() where typename='PrivateDeviceGroup' and userid=newuserid;
			end if;	
		end if;		
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		select userid into newuserid from devicegroup where id=NEW.devicegroupid;
		if newuserid=-1 then
			update objtimestamp set modifytime=now() where typename='PublicDeviceGroup';
		else
			select id into tid from objtimestamp where typename='PrivateDeviceGroup' and userid=newuserid;
			if tid is null then
				insert into objtimestamp (typename,userid,modifytime) values('PrivateDeviceGroup',newuserid,now());
			else
				update objtimestamp set modifytime=now() where typename='PrivateDeviceGroup' and userid=newuserid;
			end if;	
		end if;		
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		select userid into olduserid from devicegroup where id=old.devicegroupid;
		if not olduserid is null then
			if olduserid=-1 then
				update objtimestamp set modifytime=now() where typename='PublicDeviceGroup';
			else
				select id into tid from objtimestamp where typename='PrivateDeviceGroup' and userid=olduserid;
				if tid is null then
					insert into objtimestamp (typename,userid,modifytime) values('PrivateDeviceGroup',olduserid,now());
				else
					update objtimestamp set modifytime=now() where typename='PrivateDeviceGroup' and userid=olduserid;
				end if;	
			end if;			
		end if;
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.process_devicegroupdevice_dt() OWNER TO postgres;

--
-- TOC entry 117 (class 1255 OID 121082)
-- Dependencies: 558 5
-- Name: process_devicessetting_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_devicessetting_dt() RETURNS "trigger"
    AS $$

    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.alias = NEW.alias AND 
			OLD.curversion = NEW.curversion AND
			OLD.usermodifiedflag = NEW.usermodifiedflag AND
			OLD.subtype = NEW.subtype AND 
			OLD.accessmethod = NEW.accessmethod AND
			OLD.accessability = NEW.accessability AND
			OLD.livestatuas = NEW.livestatuas AND 
			OLD.telnetproxyid = NEW.telnetproxyid AND
			OLD.snmpversion = NEW.snmpversion AND
			OLD.appliceid = NEW.appliceid AND
			OLD.smarttelnetmethod = NEW.smarttelnetmethod AND
			OLD.backtelnetmethod = NEW.backtelnetmethod AND 
			OLD.monitormethod = NEW.monitormethod AND
			OLD.telnetport = NEW.telnetport AND
			OLD.sshport = NEW.sshport AND
			OLD.manageip = NEW.manageip AND
			OLD.livehostname = NEW.livehostname AND 
			OLD.vendor = NEW.vendor AND
			OLD.model = NEW.model AND
			OLD.username = NEW.username AND
			OLD.userpassword = NEW.userpassword AND
			OLD.enablepassword = NEW.enablepassword AND 
			OLD.loginprompt = NEW.loginprompt AND
			OLD.passwordprompt = NEW.passwordprompt AND
			OLD.nonprivilegeprompt = NEW.nonprivilegeprompt AND
			OLD.privilegeprompt = NEW.privilegeprompt AND
			OLD.snmpro = NEW.snmpro AND 
			OLD.snmprw = NEW.snmprw AND
			OLD.keyword = NEW.keyword AND
			OLD.proxy = NEW.proxy AND
			OLD.devicemode = NEW.devicemode AND
			OLD.snmpport = NEW.snmpport AND
			OLD.serialnumber = NEW.serialnumber AND
			OLD.softwareversion = NEW.softwareversion AND
			OLD.contactor = NEW.contactor AND
			OLD.currentlocation = NEW.currentlocation AND
			OLD.keepitem1 = NEW.keepitem1 AND
			OLD.keepitem2 = NEW.keepitem2 AND
			OLD.keepitem3 = NEW.keepitem3 AND
			OLD.keepitem4 = NEW.keepitem4 AND
			OLD.keepitem5 = NEW.keepitem5 AND
			OLD.keepitem6 = NEW.keepitem6 AND
			OLD.keepitem7 = NEW.keepitem7 AND
			OLD.telnettooltype = NEW.telnettooltype AND
			OLD.telnettoolsession = NEW.telnettoolsession AND
			OLD.telnetcommandline= NEW.telnetcommandline AND
			OLD.cmdbserverid = NEW.cmdbserverid 
		 then
			return OLD;
		end IF;
		NEW.lasttimestamp=now();
		update objtimestamp set modifytime=now() where typename='DeviceSetting';
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='DeviceSetting';
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='DeviceSetting';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.process_devicessetting_dt() OWNER TO postgres;

--
-- TOC entry 81 (class 1255 OID 120826)
-- Dependencies: 5 558
-- Name: process_donotscan_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_donotscan_dt() RETURNS "trigger"
    AS $$
		
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.groupid = NEW.groupid AND 			
			OLD.subnetmask = NEW.subnetmask AND 			
			OLD.scanfrom = NEW.scanfrom AND 						
			OLD.snmpro = NEW.snmpro
		 then
			return OLD;
		end IF;
		update objtimestamp set modifytime=now() where typename='NetworkSetting';
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='NetworkSetting';
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='NetworkSetting';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.process_donotscan_dt() OWNER TO postgres;

--
-- TOC entry 82 (class 1255 OID 121020)
-- Dependencies: 558 5
-- Name: process_duplicateip_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_duplicateip_dt() RETURNS "trigger"
    AS $$

    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.ipaddr = NEW.ipaddr AND
			OLD.interfaceid = NEW.interfaceid AND			
			OLD.flag = NEW.flag			
		 then
			return OLD;
		end IF;
		update objtimestamp set modifytime=now() where typename='DuplicateIp';
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='DuplicateIp';
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='DuplicateIp';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.process_duplicateip_dt() OWNER TO postgres;

--
-- TOC entry 65 (class 1255 OID 113667)
-- Dependencies: 5 558
-- Name: process_enablepasswd(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_enablepasswd() RETURNS "trigger"
    AS $$
    BEGIN
        IF (TG_OP = 'UPDATE') THEN		
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN                
		NEW.ipri=nextval('nomp_enablepasswd_ipri_seq'::regclass);						                				
		RETURN NEW;        
        END IF;
        RETURN NULL;
    END;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.process_enablepasswd() OWNER TO postgres;

--
-- TOC entry 83 (class 1255 OID 121058)
-- Dependencies: 558 5
-- Name: process_fixupunnumberedinterface_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_fixupunnumberedinterface_dt() RETURNS "trigger"
    AS $$

    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.sourcedevice = NEW.sourcedevice AND
			OLD.sourceport = NEW.sourceport AND			
			OLD.destdevice = NEW.destdevice AND			
			OLD.destport = NEW.destport AND			
			OLD.userflag = NEW.userflag 
		 then
			return OLD;
		end IF;
		update objtimestamp set modifytime=now() where typename='FixupUnnumberInterface';
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='FixupUnnumberInterface';
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='FixupUnnumberInterface';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.process_fixupunnumberedinterface_dt() OWNER TO postgres;

--
-- TOC entry 84 (class 1255 OID 121091)
-- Dependencies: 558 5
-- Name: process_interfacesetting_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_interfacesetting_dt() RETURNS "trigger"
    AS $$

    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.livestatus = NEW.livestatus AND 
			OLD.mibindex = NEW.mibindex AND
			OLD.bandwidth = NEW.bandwidth AND
			OLD.macaddress = NEW.macaddress
		 then
			return OLD;
		end IF;
		update objtimestamp set modifytime=now() where typename='InterfaceSetting';
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='InterfaceSetting';
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='InterfaceSetting';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.process_interfacesetting_dt() OWNER TO postgres;

--
-- TOC entry 85 (class 1255 OID 121062)
-- Dependencies: 558 5
-- Name: process_ip2mac_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_ip2mac_dt() RETURNS "trigger"
    AS $$

    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.alias = NEW.alias AND 
			OLD.lan = NEW.lan AND
			OLD.gateway = NEW.gateway AND
			OLD.ip = NEW.ip AND
			OLD.mac = NEW.mac AND
			OLD.devicename = NEW.devicename AND
			OLD.interfacename = NEW.interfacename AND
			OLD.switchname = NEW.switchname AND
			OLD.portname = NEW.portname AND
			OLD.vlan = NEW.vlan AND
			OLD.userflag = NEW.userflag AND
			OLD.servertype = NEW.servertype
		 then
			return OLD;
		end IF;
		update objtimestamp set modifytime=now() where typename='OneIpTable';
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='OneIpTable';
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='OneIpTable';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.process_ip2mac_dt() OWNER TO postgres;

--
-- TOC entry 72 (class 1255 OID 120739)
-- Dependencies: 5 558
-- Name: process_ip2mac_userflag(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_ip2mac_userflag() RETURNS "trigger"
    AS $$
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF NEW.userflag < OLD.userflag THEN 
			RETURN OLD;
		END IF;
		RETURN NEW;
        END IF;
        RETURN NULL;
    END;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.process_ip2mac_userflag() OWNER TO postgres;

--
-- TOC entry 80 (class 1255 OID 121066)
-- Dependencies: 5 558
-- Name: process_ipphone_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_ipphone_dt() RETURNS "trigger"
    AS $$

    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.phone_name = NEW.phone_name AND
			OLD.ipaddr = NEW.ipaddr AND
			OLD.macaddr = NEW.macaddr AND
			OLD.phone_number = NEW.phone_number AND
			OLD.call_manager = NEW.call_manager AND
			OLD.switch_name = NEW.switch_name AND
			OLD.vendor = NEW.vendor AND
			OLD.model = NEW.model AND
			OLD.version = NEW.version AND
			OLD.software_version = NEW.software_version		
		 then
			return OLD;
		end IF;
		update objtimestamp set modifytime=now() where typename='IpPhone';
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='IpPhone';
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='IpPhone';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.process_ipphone_dt() OWNER TO postgres;

--
-- TOC entry 64 (class 1255 OID 113664)
-- Dependencies: 5 558
-- Name: process_jumpbox(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_jumpbox() RETURNS "trigger"
    AS $$
    BEGIN
        IF (TG_OP = 'UPDATE') THEN		
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN                
		NEW.ipri=nextval('nomp_jumpbox_ipri_seq'::regclass);						                				
		RETURN NEW;        
        END IF;
        RETURN NULL;
    END;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.process_jumpbox() OWNER TO postgres;

--
-- TOC entry 86 (class 1255 OID 121070)
-- Dependencies: 558 5
-- Name: process_l2connectivity_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_l2connectivity_dt() RETURNS "trigger"
    AS $$

    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.sourcedevice = NEW.sourcedevice AND 
			OLD.sourceport = NEW.sourceport AND
			OLD.destdevice = NEW.destdevice AND
			OLD.destport= NEW.destport AND
			OLD.userflag = NEW.userflag AND			
			OLD.isrctype = NEW.isrctype AND			
			OLD.idesttype = NEW.idesttype
		 then
			return OLD;
		end IF;
		update objtimestamp set modifytime=now() where typename='L2SwitchConnectivity';
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='L2SwitchConnectivity';
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='L2SwitchConnectivity';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.process_l2connectivity_dt() OWNER TO postgres;

--
-- TOC entry 121 (class 1255 OID 121050)
-- Dependencies: 558 5
-- Name: process_l2switchinfo_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_l2switchinfo_dt() RETURNS "trigger"
    AS $$BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.devicename = NEW.devicename AND 
			OLD.devicealias = NEW.devicealias AND
			OLD.managementip = NEW.managementip AND
			OLD.managementmask= NEW.managementmask AND
			OLD.switchtype = NEW.switchtype AND
			OLD.subtype = NEW.subtype AND			
			OLD.isiosswitch = NEW.isiosswitch AND
			OLD.ios_version = NEW.ios_version AND
			OLD.snmpro = NEW.snmpro AND
			OLD.snmprw = NEW.snmprw AND
			OLD.description = NEW.description AND			
			OLD.usermodifed = NEW.usermodifed AND
			OLD.iproutecmds = NEW.iproutecmds 			
		 then
			return new;
		end IF;
		new.nb_timestamp=now();		
		update objtimestamp set modifytime=now() where typename='L2Switch';
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='L2Switch';
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='L2Switch';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.process_l2switchinfo_dt() OWNER TO postgres;

--
-- TOC entry 122 (class 1255 OID 121045)
-- Dependencies: 5 558
-- Name: process_l2switchport_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_l2switchport_dt() RETURNS "trigger"
    AS $$

    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.switchname = NEW.switchname AND 
			OLD.portname = NEW.portname AND
			OLD.status = NEW.status AND
			OLD.speed= NEW.speed AND
			OLD.duplex = NEW.duplex AND
			OLD.portmode = NEW.portmode AND			
			OLD.trunkencapsulation = NEW.trunkencapsulation AND
			OLD.stpstatus = NEW.stpstatus AND
			OLD.vlans = NEW.vlans AND
			OLD.description = NEW.description AND
			OLD.usermodifed = NEW.usermodifed AND			
			OLD.channelgroupmode = NEW.channelgroupmode AND
			OLD.channelgroupname = NEW.channelgroupname AND
			OLD.exclude_vlans = NEW.exclude_vlans			
		 then
			return new;
		end IF;
		update l2switchinfo set nb_timestamp=now() where devicename=OLD.switchname;
		update l2switchinfo set nb_timestamp=now() where devicename=new.switchname;
		new.nb_timestamp=now();		
		update objtimestamp set modifytime=now() where typename='L2Switch';
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='L2Switch';
		update l2switchinfo set nb_timestamp=now() where devicename=NEW.switchname;
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='L2Switch';
		update l2switchinfo set nb_timestamp=now() where devicename=OLD.switchname;
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.process_l2switchport_dt() OWNER TO postgres;

--
-- TOC entry 123 (class 1255 OID 121054)
-- Dependencies: 558 5
-- Name: process_l2switchvlan_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_l2switchvlan_dt() RETURNS "trigger"
    AS $$

    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.switchname = NEW.switchname AND 
			OLD.vlannumber = NEW.vlannumber AND
			OLD.vlantype = NEW.vlantype AND
			OLD.mtu= NEW.mtu AND
			OLD.vlanstatus = NEW.vlanstatus AND
			OLD.switchports = NEW.switchports AND			
			OLD.parentvlan = NEW.parentvlan AND
			OLD.vlanmode = NEW.vlanmode AND
			OLD.said = NEW.said AND
			OLD.description = NEW.description AND
			OLD.usermodifed = NEW.usermodifed
		 then
			return new;
		end IF;
		update l2switchinfo set nb_timestamp=now() where devicename=OLD.switchname;		
		update l2switchinfo set nb_timestamp=now() where devicename=new.switchname;		
		new.nb_timestamp=now();		
		update objtimestamp set modifytime=now() where typename='L2Switch';
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='L2Switch';
		update l2switchinfo set nb_timestamp=now() where devicename=NEW.switchname;
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='L2Switch';
		update l2switchinfo set nb_timestamp=now() where devicename=OLD.switchname;
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.process_l2switchvlan_dt() OWNER TO postgres;

--
-- TOC entry 87 (class 1255 OID 121074)
-- Dependencies: 558 5
-- Name: process_lanswitch_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_lanswitch_dt() RETURNS "trigger"
    AS $$

    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.lanname = NEW.lanname AND 
			OLD.gateway = NEW.gateway AND
			OLD.switchname = NEW.switchname AND
			OLD.ports= NEW.ports AND
			OLD.userflag = NEW.userflag
		 then
			return OLD;
		end IF;
		update objtimestamp set modifytime=now() where typename='L2Domain';
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='L2Domain';
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='L2Domain';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.process_lanswitch_dt() OWNER TO postgres;

--
-- TOC entry 88 (class 1255 OID 120827)
-- Dependencies: 558 5
-- Name: process_nomp_appliance_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_nomp_appliance_dt() RETURNS "trigger"
    AS $$

    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.strhostname = NEW.strhostname AND 
			OLD.strdescription = NEW.strdescription AND
			OLD.stripaddr = NEW.stripaddr AND
			OLD.iserveport = NEW.iserveport AND
			OLD.bhome = NEW.bhome AND
			OLD.blive = NEW.blive AND
			OLD.bmodified = NEW.bmodified AND
			OLD.imaxdevicecount = NEW.imaxdevicecount AND
			OLD.ipri = NEW.ipri AND
			OLD.telnet_user = NEW.telnet_user AND
			OLD.telnet_pwd = NEW.telnet_pwd			
		 then
			return OLD;
		end IF;
		update objtimestamp set modifytime=now() where typename='NetworkSetting';
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='NetworkSetting';
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='NetworkSetting';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.process_nomp_appliance_dt() OWNER TO postgres;

--
-- TOC entry 89 (class 1255 OID 120830)
-- Dependencies: 558 5
-- Name: process_nomp_enablepasswd_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_nomp_enablepasswd_dt() RETURNS "trigger"
    AS $$

    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.stralias = NEW.stralias AND 
			OLD.strenablepasswd = NEW.strenablepasswd AND
			OLD.bmodified = NEW.bmodified AND			
			OLD.ipri = NEW.ipri			
		 then
			return OLD;
		end IF;
		update objtimestamp set modifytime=now() where typename='NetworkSetting';
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='NetworkSetting';
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='NetworkSetting';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.process_nomp_enablepasswd_dt() OWNER TO postgres;

--
-- TOC entry 90 (class 1255 OID 120831)
-- Dependencies: 558 5
-- Name: process_nomp_jumpbox_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_nomp_jumpbox_dt() RETURNS "trigger"
    AS $$

    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.strname = NEW.strname AND 
			OLD.itype = NEW.itype AND
			OLD.stripaddr = NEW.stripaddr AND
			OLD.iport = NEW.iport AND
			OLD.imode = NEW.imode AND
			OLD.strusername = NEW.strusername AND
			OLD.strpasswd = NEW.strpasswd AND
			OLD.strloginprompt = NEW.strloginprompt AND
			OLD.strpasswdprompt = NEW.strpasswdprompt AND
			OLD.strcommandprompt = NEW.strcommandprompt AND
			OLD.stryesnoprompt = NEW.stryesnoprompt AND
			OLD.bmodified = NEW.bmodified AND
			OLD.strenablecmd = NEW.strenablecmd AND
			OLD.strenablepasswordprompt = NEW.strenablepasswordprompt AND
			OLD.strenablepassword = NEW.strenablepassword AND
			OLD.strenableprompt = NEW.strenableprompt AND
			OLD.ipri = NEW.ipri			
		 then
			return OLD;
		end IF;
		update objtimestamp set modifytime=now() where typename='NetworkSetting';
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='NetworkSetting';
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='NetworkSetting';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.process_nomp_jumpbox_dt() OWNER TO postgres;

--
-- TOC entry 91 (class 1255 OID 120834)
-- Dependencies: 558 5
-- Name: process_nomp_snmproinfo_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_nomp_snmproinfo_dt() RETURNS "trigger"
    AS $$

    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.strrostring = NEW.strrostring AND 			
			OLD.bmodified = NEW.bmodified AND			
			OLD.ipri = NEW.ipri			
		 then
			return OLD;
		end IF;
		update objtimestamp set modifytime=now() where typename='NetworkSetting';
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='NetworkSetting';
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='NetworkSetting';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.process_nomp_snmproinfo_dt() OWNER TO postgres;

--
-- TOC entry 92 (class 1255 OID 120835)
-- Dependencies: 5 558
-- Name: process_nomp_telnetinfo_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_nomp_telnetinfo_dt() RETURNS "trigger"
    AS $$

    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.stralias = NEW.stralias AND 			
			OLD.idevicetype = NEW.idevicetype AND 			
			OLD.strusername = NEW.strusername AND 			
			OLD.strpasswd = NEW.strpasswd AND 			
			OLD.bmodified = NEW.bmodified AND 			
			OLD.userid = NEW.userid AND 			
			OLD.ipri = NEW.ipri
		 then
			return OLD;
		end IF;
		update objtimestamp set modifytime=now() where typename='NetworkSetting';
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='NetworkSetting';
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='NetworkSetting';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.process_nomp_telnetinfo_dt() OWNER TO postgres;

--
-- TOC entry 62 (class 1255 OID 113661)
-- Dependencies: 558 5
-- Name: process_snmprostring(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_snmprostring() RETURNS "trigger"
    AS $$
    BEGIN
        IF (TG_OP = 'UPDATE') THEN		
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN                
		NEW.ipri=nextval('nomp_snmproinfo_ipri_seq'::regclass);						                				
		RETURN NEW;        
        END IF;
        RETURN NULL;
    END;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.process_snmprostring() OWNER TO postgres;

--
-- TOC entry 63 (class 1255 OID 113663)
-- Dependencies: 5 558
-- Name: process_snmprwstring(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_snmprwstring() RETURNS "trigger"
    AS $$
    BEGIN
        IF (TG_OP = 'UPDATE') THEN		
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN                
		NEW.ipri=nextval('nomp_snmprwinfo_ipri_seq'::regclass);						                				
		RETURN NEW;        
        END IF;
        RETURN NULL;
    END;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.process_snmprwstring() OWNER TO postgres;

--
-- TOC entry 93 (class 1255 OID 121008)
-- Dependencies: 558 5
-- Name: process_switchgroup_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_switchgroup_dt() RETURNS "trigger"
    AS $$

    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.strname = NEW.strname AND 
			OLD.description = NEW.description AND			
			OLD.showcolor = NEW.showcolor			
		 then
			return OLD;
		end IF;
		update objtimestamp set modifytime=now() where typename='SwitchGroup';
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='SwitchGroup';
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='SwitchGroup';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.process_switchgroup_dt() OWNER TO postgres;

--
-- TOC entry 94 (class 1255 OID 121012)
-- Dependencies: 5 558
-- Name: process_swtichgroupdevice_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_swtichgroupdevice_dt() RETURNS "trigger"
    AS $$

    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.switchgroupid = NEW.switchgroupid AND 			
			OLD.deviceid = NEW.deviceid			
		 then
			return OLD;
		end IF;
		update objtimestamp set modifytime=now() where typename='SwitchGroup';
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='SwitchGroup';
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='SwitchGroup';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.process_swtichgroupdevice_dt() OWNER TO postgres;

--
-- TOC entry 95 (class 1255 OID 120838)
-- Dependencies: 558 5
-- Name: process_system_devicespec_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_system_devicespec_dt() RETURNS "trigger"
    AS $$

    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.strvendorname = NEW.strvendorname AND 
			OLD.strmodelname = NEW.strmodelname AND
			OLD.idevicetype = NEW.idevicetype AND
			OLD.strcpuoid = NEW.strcpuoid AND
			OLD.strmemoid = NEW.strmemoid AND
			OLD.strshowruncmd = NEW.strshowruncmd AND
			OLD.strshowiproutecmd = NEW.strshowiproutecmd AND
			OLD.strshowroutecountcmd = NEW.strshowroutecountcmd AND
			OLD.strshowarpcmd = NEW.strshowarpcmd AND
			OLD.strshowcamcmd = NEW.strshowcamcmd AND
			OLD.strpage1cmd = NEW.strpage1cmd AND
			OLD.strloginprompt = NEW.strloginprompt AND
			OLD.strpasswordprompt = NEW.strpasswordprompt AND
			OLD.strprivilegeprompt = NEW.strprivilegeprompt AND
			OLD.strnonprivilegeprompt = NEW.strnonprivilegeprompt AND
			OLD.strconfigprompt = NEW.strconfigprompt AND
			OLD.strtoenablecmd = NEW.strtoenablecmd AND
			OLD.strtoconfigcmd = NEW.strtoconfigcmd AND
			OLD.stryesnoprompt = NEW.stryesnoprompt AND
			OLD.ipasswordinterval = NEW.ipasswordinterval AND
			OLD.iflag = NEW.iflag AND
			OLD.bmodified = NEW.bmodified AND
			OLD.strshowcdpcmd = NEW.strshowcdpcmd AND
			OLD.strinvalidcommandkey = NEW.strinvalidcommandkey AND
			OLD.strquit = NEW.strquit 
		 then
			return OLD;
		end IF;
		update objtimestamp set modifytime=now() where typename='VendorModel_DeviceSpec';
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='VendorModel_DeviceSpec';
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='VendorModel_DeviceSpec';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.process_system_devicespec_dt() OWNER TO postgres;

--
-- TOC entry 96 (class 1255 OID 120839)
-- Dependencies: 5 558
-- Name: process_system_vendormodel_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_system_vendormodel_dt() RETURNS "trigger"
    AS $$

    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.idevicetype = NEW.idevicetype AND 
			OLD.strvendorname = NEW.strvendorname AND
			OLD.bmodified = NEW.bmodified AND
			OLD.strmodelname = NEW.strmodelname
		 then
			return OLD;
		end IF;
		update objtimestamp set modifytime=now() where typename='VendorModel_DeviceSpec';
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='VendorModel_DeviceSpec';
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='VendorModel_DeviceSpec';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.process_system_vendormodel_dt() OWNER TO postgres;

--
-- TOC entry 97 (class 1255 OID 121000)
-- Dependencies: 558 5
-- Name: process_systemdevicegroup_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_systemdevicegroup_dt() RETURNS "trigger"
    AS $$

    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.strname = NEW.strname AND 
			OLD.strdesc = NEW.strdesc AND
			OLD.showcolor = NEW.showcolor
		 then
			return OLD;
		end IF;
		update objtimestamp set modifytime=now() where typename='SystemDeviceGroup';
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='SystemDeviceGroup';
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='SystemDeviceGroup';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.process_systemdevicegroup_dt() OWNER TO postgres;

--
-- TOC entry 98 (class 1255 OID 121004)
-- Dependencies: 558 5
-- Name: process_systemdevicegroupdevice_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_systemdevicegroupdevice_dt() RETURNS "trigger"
    AS $$

    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.systemdevicegroupid = NEW.systemdevicegroupid AND 
			OLD.deviceid = NEW.deviceid
		 then
			return OLD;
		end IF;
		update objtimestamp set modifytime=now() where typename='SystemDeviceGroup';
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='SystemDeviceGroup';
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='SystemDeviceGroup';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.process_systemdevicegroupdevice_dt() OWNER TO postgres;

--
-- TOC entry 67 (class 1255 OID 113671)
-- Dependencies: 5 558
-- Name: process_telnetinfo(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_telnetinfo() RETURNS "trigger"
    AS $$
    BEGIN
        IF (TG_OP = 'UPDATE') THEN		
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN                
		NEW.ipri=nextval('nomp_telnetinfo_ipri_seq'::regclass);						                				
		RETURN NEW;        
        END IF;
        RETURN NULL;
    END;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.process_telnetinfo() OWNER TO postgres;

--
-- TOC entry 145 (class 1255 OID 123054)
-- Dependencies: 558 5
-- Name: process_userdevicesetting_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_userdevicesetting_dt() RETURNS "trigger"
    AS $$
declare tid integer;
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
  IF  OLD.deviceid = NEW.deviceid AND 
   OLD.userid = NEW.userid AND
   OLD.managerip = NEW.managerip AND
   OLD.telnetusername = NEW.telnetusername AND 
   OLD.telnetpwd = NEW.telnetpwd
   then
   return OLD;
  end IF;
  NEW.dtstamp=now();
  select id into tid from objtimestamp where typename='PrivateDeviceSetting' and userid=new.userid;
  if tid is null then
   insert into objtimestamp (typename,userid,modifytime) values('PrivateDeviceSetting',new.userid,now());
  else
   update objtimestamp set modifytime=now() where typename='PrivateDeviceSetting' and userid=new.userid;
  end if;
  RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
  select id into tid from objtimestamp where typename='PrivateDeviceSetting' and userid=new.userid;
  if tid is null then
   insert into objtimestamp (typename,userid,modifytime) values('PrivateDeviceSetting',new.userid,now());
  else
   update objtimestamp set modifytime=now() where typename='PrivateDeviceSetting' and userid=new.userid;
  end if;
  NEW.dtstamp=now();
  RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
  select id into tid from objtimestamp where typename='PrivateDeviceSetting' and userid=old.userid;
  if tid is null then
   insert into objtimestamp (typename,userid,modifytime) values('PrivateDeviceSetting',old.userid,now());
  else
   update objtimestamp set modifytime=now() where typename='PrivateDeviceSetting' and userid=old.userid;
  end if;
  RETURN OLD;  
        END IF;
        RETURN NULL;
    END;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.process_userdevicesetting_dt() OWNER TO postgres;

--
-- TOC entry 50 (class 1255 OID 88290)
-- Dependencies: 5 558
-- Name: process_userinfo_p(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_userinfo_p() RETURNS "trigger"
    AS $$
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF NEW.password IS NOT NULL THEN 
			IF OLD.password <> NEW.password then
				NEW.password = md5( NEW.password );												
			END IF;
		END IF;
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		NEW.password = md5( NEW.password );
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		IF OLD.strname = 'system' THEN
			RAISE EXCEPTION 'Can not delete the system user';
		END IF;
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.process_userinfo_p() OWNER TO postgres;

--
-- TOC entry 69 (class 1255 OID 120721)
-- Dependencies: 5 558
-- Name: removedevicesetting_applianceid(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION removedevicesetting_applianceid(appid integer) RETURNS integer
    AS $$
BEGIN
	UPDATE devicesetting SET appliceid=0 WHERE appliceid=appid;
	return 1;
End;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.removedevicesetting_applianceid(appid integer) OWNER TO postgres;

--
-- TOC entry 27 (class 1255 OID 109464)
-- Dependencies: 558 5 404
-- Name: retrieve_device_setting(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION retrieve_device_setting(devname character varying) RETURNS SETOF devicesetting
    AS $$
declare
	r devicesetting%rowtype;
BEGIN
   for r in SELECT * FROM devicesetting where deviceid IN ( select id from devices where strname=devname ) loop
   return next r;
   end loop;
END;

  $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.retrieve_device_setting(devname character varying) OWNER TO postgres;

--
-- TOC entry 126 (class 1255 OID 121403)
-- Dependencies: 403 5 558
-- Name: searchalldevice(character varying, integer[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION searchalldevice(devname character varying, filer integer[]) RETURNS SETOF devices
    AS $$

DECLARE
    r devices%rowtype;
BEGIN	
	
             FOR r IN select * from (select deviceid as id,(select strname from devices where devices.id=devicesetting.deviceid) as strname from devicesetting where subtype = any( filer ) order by strname ) as a where lower(a.strname) like '%'||devname||'%' order by a.strname limit 1 LOOP
		RETURN NEXT r;
	     END LOOP;	     		
END;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.searchalldevice(devname character varying, filer integer[]) OWNER TO postgres;

--
-- TOC entry 139 (class 1255 OID 122983)
-- Dependencies: 558 5 557
-- Name: searchalldevicenofiler(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION searchalldevicenofiler(devname character varying) RETURNS SETOF devicesettingview
    AS $$

DECLARE
    r devicesettingview%rowtype;
BEGIN	
	
             FOR r IN select * from devicesettingview  where lower(devicename) like '%'||devname||'%' order by lower(devicename) limit 1 LOOP
		RETURN NEXT r;
	     END LOOP;	     		
END;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.searchalldevicenofiler(devname character varying) OWNER TO postgres;

--
-- TOC entry 125 (class 1255 OID 121404)
-- Dependencies: 5 558 403
-- Name: searchdevicebygroup(character varying, integer, integer[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION searchdevicebygroup(devname character varying, gid integer, filer integer[]) RETURNS SETOF devices
    AS $$

DECLARE
    r devices%rowtype;
BEGIN	
             FOR r IN select * from (select deviceid as id,(select strname from devices where devices.id=devicesetting.deviceid) as strname  from devicesetting where subtype = any( filer ) and deviceid in (select deviceid from devicegroupdevice where devicegroupdevice.devicegroupid=gid) order by strname ) as a where lower(a.strname) like '%'||devname||'%' order by a.strname limit 1 LOOP
		RETURN NEXT r;
	     END LOOP;	     		
END;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.searchdevicebygroup(devname character varying, gid integer, filer integer[]) OWNER TO postgres;

--
-- TOC entry 140 (class 1255 OID 122984)
-- Dependencies: 558 5 557
-- Name: searchdevicebygroupnofiler(character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION searchdevicebygroupnofiler(devname character varying, gid integer) RETURNS SETOF devicesettingview
    AS $$

DECLARE
    r devicesettingview%rowtype;
BEGIN	
             FOR r IN select * from devicesettingview where deviceid in (select deviceid from devicegroupdeviceview where devicegroupid=gid and lower(devicename) like '%'||devname||'%' order by devicename limit 1 )  LOOP
		RETURN NEXT r;
	     END LOOP;	     		
END;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.searchdevicebygroupnofiler(devname character varying, gid integer) OWNER TO postgres;

--
-- TOC entry 1689 (class 1259 OID 107180)
-- Dependencies: 5
-- Name: system_devicespec_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE system_devicespec_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.system_devicespec_id_seq OWNER TO postgres;

--
-- TOC entry 2629 (class 0 OID 0)
-- Dependencies: 1689
-- Name: system_devicespec_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('system_devicespec_id_seq', 20, true);


--
-- TOC entry 1630 (class 1259 OID 88523)
-- Dependencies: 2138 5
-- Name: system_devicespec; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE system_devicespec (
    id integer DEFAULT nextval('system_devicespec_id_seq'::regclass) NOT NULL,
    strvendorname character varying(64),
    strmodelname character varying(64),
    idevicetype integer,
    strcpuoid character varying(128),
    strmemoid character varying(128),
    strshowruncmd character varying(32),
    strshowiproutecmd character varying(32),
    strshowroutecountcmd character varying(32),
    strshowarpcmd character varying(32),
    strshowcamcmd character varying(32),
    strpage1cmd character varying(32),
    strloginprompt character varying(16),
    strpasswordprompt character varying(16),
    strprivilegeprompt character varying(16),
    strnonprivilegeprompt character varying(16),
    strconfigprompt character varying(16),
    strtoenablecmd character varying(16),
    strtoconfigcmd character varying(16),
    stryesnoprompt character varying(16),
    ipasswordinterval integer,
    iflag integer,
    bmodified integer,
    strshowcdpcmd character varying(32),
    strinvalidcommandkey character varying(128),
    strquit character varying(32)
);


ALTER TABLE public.system_devicespec OWNER TO postgres;

--
-- TOC entry 99 (class 1255 OID 121160)
-- Dependencies: 558 458 5
-- Name: system_devicespec_retrieve(timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION system_devicespec_retrieve(dt timestamp without time zone, stypename character varying) RETURNS SETOF system_devicespec
    AS $$
declare
	r system_devicespec%rowtype;
	t timestamp without time zone;
BEGIN		
        select modifytime into t from objtimestamp where typename=stypename;
	if t is null or t>dt then
		for r in SELECT * FROM system_devicespec order by id loop
		return next r;
		end loop;	
	End IF;
END;

  $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.system_devicespec_retrieve(dt timestamp without time zone, stypename character varying) OWNER TO postgres;

--
-- TOC entry 1634 (class 1259 OID 88535)
-- Dependencies: 5
-- Name: system_vendormodel_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE system_vendormodel_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.system_vendormodel_id_seq OWNER TO postgres;

--
-- TOC entry 2630 (class 0 OID 0)
-- Dependencies: 1634
-- Name: system_vendormodel_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('system_vendormodel_id_seq', 6001, true);


--
-- TOC entry 1635 (class 1259 OID 88537)
-- Dependencies: 2143 5
-- Name: system_vendormodel; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE system_vendormodel (
    id integer DEFAULT nextval('system_vendormodel_id_seq'::regclass) NOT NULL,
    stroid character varying(64),
    idevicetype integer,
    strvendorname character varying(64),
    strmodelname character varying(64),
    bmodified integer
);


ALTER TABLE public.system_vendormodel OWNER TO postgres;

--
-- TOC entry 100 (class 1255 OID 121161)
-- Dependencies: 463 5 558
-- Name: system_vendormodel_retrieve(timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION system_vendormodel_retrieve(dt timestamp without time zone, stypename character varying) RETURNS SETOF system_vendormodel
    AS $$
declare
	r system_vendormodel%rowtype;
	t timestamp without time zone;
BEGIN		
        select modifytime into t from objtimestamp where typename=stypename;
	if t is null or t>dt then
		for r in SELECT * FROM system_vendormodel order by id loop
		return next r;
		end loop;	
	End IF;
END;

  $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.system_vendormodel_retrieve(dt timestamp without time zone, stypename character varying) OWNER TO postgres;

--
-- TOC entry 144 (class 1255 OID 123051)
-- Dependencies: 5 558
-- Name: update_swticth_version(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION update_swticth_version(sn character varying) RETURNS boolean
    AS $$

BEGIN
	update l2switchinfo set nb_timestamp=now() where devicename =sn;	
	update objtimestamp set modifytime=now() where typename='L2Switch';	
	RETURN true;
EXCEPTION
	WHEN OTHERS THEN 
	RETURN false;    
END;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.update_swticth_version(sn character varying) OWNER TO postgres;

--
-- TOC entry 68 (class 1255 OID 120718)
-- Dependencies: 558 5
-- Name: updatedevicesetting_applianceid(integer, integer[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION updatedevicesetting_applianceid(appid integer, deviceids integer[]) RETURNS integer
    AS $$
BEGIN	
	UPDATE devicesetting SET appliceid=appid, lasttimestamp=now() WHERE deviceid = any (deviceids);
	return 1;
End;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.updatedevicesetting_applianceid(appid integer, deviceids integer[]) OWNER TO postgres;

--
-- TOC entry 128 (class 1255 OID 121409)
-- Dependencies: 558 5
-- Name: updateinterfacesettingtime(character varying[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION updateinterfacesettingtime(names character varying[]) RETURNS boolean
    AS $$

BEGIN
    update interfacesetting set lasttimestamp=now() where deviceid in (select id from devices where strname = any(names));
    
    RETURN true;
EXCEPTION
    WHEN OTHERS THEN 
	RETURN false;    
END;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.updateinterfacesettingtime(names character varying[]) OWNER TO postgres;

--
-- TOC entry 129 (class 1255 OID 121410)
-- Dependencies: 558 5
-- Name: updatel2switchtime(character varying[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION updatel2switchtime(names character varying[]) RETURNS boolean
    AS $$

BEGIN
    update l2switchinfo set nb_timestamp=now() where devicename = any(names);
    
    RETURN true;
EXCEPTION
    WHEN OTHERS THEN 
	RETURN false;    
END;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.updatel2switchtime(names character varying[]) OWNER TO postgres;

--
-- TOC entry 127 (class 1255 OID 121407)
-- Dependencies: 5 558
-- Name: updateversion(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION updateversion(tn character varying) RETURNS boolean
    AS $$

BEGIN
    update objtimestamp set modifytime=now() where typename=tn;	
    
    RETURN true;
EXCEPTION
    WHEN OTHERS THEN 
	RETURN false;    
END;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.updateversion(tn character varying) OWNER TO postgres;

--
-- TOC entry 135 (class 1255 OID 122975)
-- Dependencies: 558 5
-- Name: updateversionwithuserid(character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION updateversionwithuserid(tn character varying, uid integer) RETURNS boolean
    AS $$
 
BEGIN
    update objtimestamp set modifytime=now() where typename=tn and userid=uid; 
    
    RETURN true;
EXCEPTION
    WHEN OTHERS THEN 
 RETURN false;    
END;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.updateversionwithuserid(tn character varying, uid integer) OWNER TO postgres;

--
-- TOC entry 1708 (class 1259 OID 121219)
-- Dependencies: 2197 2198 5
-- Name: userdevicesetting; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE userdevicesetting (
    id integer NOT NULL,
    deviceid integer NOT NULL,
    userid integer DEFAULT -1 NOT NULL,
    managerip integer NOT NULL,
    telnetusername character varying(64),
    telnetpwd character varying(64),
    dtstamp timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.userdevicesetting OWNER TO postgres;

--
-- TOC entry 111 (class 1255 OID 121343)
-- Dependencies: 549 558 5
-- Name: user_device_setting_retrieve(character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION user_device_setting_retrieve(devname character varying, user_id integer) RETURNS userdevicesetting
    AS $$
declare
	r userdevicesetting%rowtype;
BEGIN
   SELECT * into r FROM userdevicesetting where deviceid IN ( select id from devices where strname=devname ) AND userid=user_id;
   return r;
   
END;

  $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.user_device_setting_retrieve(devname character varying, user_id integer) OWNER TO postgres;

--
-- TOC entry 112 (class 1255 OID 121344)
-- Dependencies: 558 5 549
-- Name: user_device_setting_update(character varying, integer, userdevicesetting); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION user_device_setting_update(devname character varying, u_id integer, ds userdevicesetting) RETURNS integer
    AS $$
declare
	r_id integer;
	ds_id integer;
BEGIN
	select id into r_id from devices where strname=devname;
	if r_id IS NULL THEN
		return -1;
	end if;

	select id into ds_id from userdevicesetting where deviceid=r_id AND userid=u_id;
	if ds_id IS NULL THEN
		return -1;
	ELSE
		update userdevicesetting set ( 
			  managerip,
			  telnetusername,
			  telnetpwd,
			  dtstamp
			)
			=( 
			ds.managerip,
			ds.telnetusername,
			ds.telnetpwd,
			now()
			) 
			where id = ds_id;
		return ds_id;
	end if;
EXCEPTION
	WHEN OTHERS THEN 
		RETURN -2;
END;

  $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.user_device_setting_update(devname character varying, u_id integer, ds userdevicesetting) OWNER TO postgres;

--
-- TOC entry 113 (class 1255 OID 121347)
-- Dependencies: 549 558 5
-- Name: user_device_setting_upsert(character varying, integer, userdevicesetting); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION user_device_setting_upsert(devname character varying, u_id integer, ds userdevicesetting) RETURNS integer
    AS $$
declare
	r_id integer;
	ds_id integer;
BEGIN
	select id into r_id from devices where strname=devname;
	if r_id IS NULL THEN
		return -1;
	end if;

	select id into ds_id from userdevicesetting where deviceid=r_id AND userid=u_id;
	if ds_id IS NULL THEN
		insert into userdevicesetting(
			  deviceid,
			  userid,
			  managerip,
			  telnetusername,
			  telnetpwd,
			  dtstamp
			)
			values ( 
			r_id,
			u_id,
			ds.managerip,
			ds.telnetusername,
			ds.telnetpwd,
			now()
		);

		return lastval();
	ELSE
		update userdevicesetting set ( 
			  managerip,
			  telnetusername,
			  telnetpwd,
			  dtstamp
			)
			=( 
			ds.managerip,
			ds.telnetusername,
			ds.telnetpwd,
			now()
			) 
			where id = ds_id;
		return ds_id;
	end if;
EXCEPTION
	WHEN OTHERS THEN 
		RETURN -2;
END;

  $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.user_device_setting_upsert(devname character varying, u_id integer, ds userdevicesetting) OWNER TO postgres;

--
-- TOC entry 141 (class 1255 OID 122985)
-- Dependencies: 5 558
-- Name: valid_version_time(timestamp without time zone, character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION valid_version_time(dt timestamp without time zone, stypename character varying, uid integer) RETURNS boolean
    AS $$
 
DECLARE
    t timestamp without time zone;
BEGIN
    if uid=-1 then
  select modifytime into t from objtimestamp where typename=stypename;
 else
  select modifytime into t from objtimestamp where typename=stypename and userid=uid;
 end if;
 
    if(t>dt) then 
 RETURN true;
    else
 return false;
    end if;
EXCEPTION
    WHEN OTHERS THEN 
 RETURN false;    
END;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.valid_version_time(dt timestamp without time zone, stypename character varying, uid integer) OWNER TO postgres;

--
-- TOC entry 136 (class 1255 OID 122980)
-- Dependencies: 5 558 557
-- Name: view_device_setting_retrieve(integer, integer, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_device_setting_retrieve(ibegin integer, imax integer, dt timestamp without time zone) RETURNS SETOF devicesettingview
    AS $$
declare
	r devicesettingview%rowtype;
BEGIN
	if imax <0 then
		for r in SELECT * FROM devicesettingview where id>ibegin AND lasttimestamp>dt order by id loop
		return next r;
		end loop;
	else
		for r in SELECT * FROM devicesettingview where id>ibegin AND lasttimestamp>dt order by id limit imax loop
		return next r;
		end loop;

	end if;
END;

  $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.view_device_setting_retrieve(ibegin integer, imax integer, dt timestamp without time zone) OWNER TO postgres;

--
-- TOC entry 142 (class 1255 OID 123049)
-- Dependencies: 5 558 557
-- Name: view_device_setting_retrieve_by_nap(integer, integer, timestamp without time zone, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_device_setting_retrieve_by_nap(ibegin integer, imax integer, dt timestamp without time zone, napid integer) RETURNS SETOF devicesettingview
    AS $$
declare
 r devicesettingview%rowtype;
BEGIN
 if imax <0 then
  for r in SELECT * FROM devicesettingview where id>ibegin AND lasttimestamp>dt and appliceid=napid order by id loop
  return next r;
  end loop;
 else
  for r in SELECT * FROM devicesettingview where id>ibegin AND lasttimestamp>dt and appliceid=napid order by id limit imax loop
  return next r;
  end loop;
 
 end if;
END;
 
  $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.view_device_setting_retrieve_by_nap(ibegin integer, imax integer, dt timestamp without time zone, napid integer) OWNER TO postgres;

--
-- TOC entry 1572 (class 1259 OID 88319)
-- Dependencies: 2062 2064 5
-- Name: devicegroup; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE devicegroup (
    id integer NOT NULL,
    strname character varying(256) NOT NULL,
    strdesc character varying(512),
    userid integer DEFAULT -1 NOT NULL,
    showcolor integer DEFAULT 16777215 NOT NULL
);


ALTER TABLE public.devicegroup OWNER TO postgres;

--
-- TOC entry 1574 (class 1259 OID 88324)
-- Dependencies: 5
-- Name: devicegroupdevice; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE devicegroupdevice (
    devicegroupid integer NOT NULL,
    deviceid integer NOT NULL,
    id integer NOT NULL
);


ALTER TABLE public.devicegroupdevice OWNER TO postgres;

--
-- TOC entry 1700 (class 1259 OID 120915)
-- Dependencies: 1793 5
-- Name: devicegroupview; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW devicegroupview AS
    SELECT devicegroup.id, devicegroup.strname, devicegroup.strdesc, devicegroup.userid, devicegroup.showcolor, (SELECT count(*) AS count FROM devicegroupdevice WHERE (devicegroupdevice.devicegroupid = devicegroup.id)) AS irefcount FROM devicegroup ORDER BY devicegroup.id;


ALTER TABLE public.devicegroupview OWNER TO postgres;

--
-- TOC entry 114 (class 1255 OID 120987)
-- Dependencies: 5 541 558
-- Name: view_devicegroup_retrieve(integer, integer, timestamp without time zone, integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_devicegroup_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer, stypename character varying) RETURNS SETOF devicegroupview
    AS $$
declare
	r devicegroupview%rowtype;
	t timestamp without time zone;
BEGIN
	if uid=-1 then
		select modifytime into t from objtimestamp where typename=stypename;
	else
		select modifytime into t from objtimestamp where typename=stypename and userid=uid;
	end if;
	
	if t is null or t>dt then
		if imax <0 then
			for r in SELECT * FROM devicegroupview where id>ibegin and userid=uid loop
			return next r;
			end loop;
		else
			for r in SELECT * FROM devicegroupview where id>ibegin and userid=uid limit imax loop
			return next r;
			end loop;

		end if;	
	end if;	
END;

  $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.view_devicegroup_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer, stypename character varying) OWNER TO postgres;

--
-- TOC entry 1704 (class 1259 OID 121135)
-- Dependencies: 1797 5
-- Name: devicegroupdeviceview; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW devicegroupdeviceview AS
    SELECT devicegroupdevice.devicegroupid, devicegroupdevice.deviceid, devicegroupdevice.id, (SELECT devices.strname FROM devices WHERE (devices.id = devicegroupdevice.deviceid)) AS devicename, (SELECT devicegroup.strname FROM devicegroup WHERE (devicegroup.id = devicegroupdevice.devicegroupid)) AS devicegroupname, (SELECT devices.isubtype FROM devices WHERE (devices.id = devicegroupdevice.deviceid)) AS isubtype FROM devicegroupdevice;


ALTER TABLE public.devicegroupdeviceview OWNER TO postgres;

--
-- TOC entry 115 (class 1255 OID 121164)
-- Dependencies: 5 558 545
-- Name: view_devicegroupdeviceview_retrieve(integer, integer, timestamp without time zone, integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_devicegroupdeviceview_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer, stypename character varying) RETURNS SETOF devicegroupdeviceview
    AS $$
declare
	r devicegroupdeviceview%rowtype;
	t timestamp without time zone;
BEGIN
	if uid=-1 then
		select modifytime into t from objtimestamp where typename=stypename;
	else
		select modifytime into t from objtimestamp where typename=stypename and userid=uid;
	end if;
	
	if t is null or t>dt then
		if imax <0 then
			for r in select * from devicegroupdeviceview where devicegroupid in (SELECT id FROM devicegroup where id>ibegin and userid=uid order by id) order by devicegroupid loop
			return next r;
			end loop;
		else
			for r in select * from devicegroupdeviceview where devicegroupid in (SELECT id FROM devicegroup where id>ibegin and userid=uid order by id limit imax) order by devicegroupid loop			
			return next r;
			end loop;

		end if;	
	end if;	
END;

  $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.view_devicegroupdeviceview_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer, stypename character varying) OWNER TO postgres;

--
-- TOC entry 1652 (class 1259 OID 90720)
-- Dependencies: 2156 5
-- Name: duplicateip; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE duplicateip (
    id integer NOT NULL,
    ipaddr integer NOT NULL,
    interfaceid integer NOT NULL,
    flag integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.duplicateip OWNER TO postgres;

--
-- TOC entry 1703 (class 1259 OID 120971)
-- Dependencies: 1796 5
-- Name: duplicateipview; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW duplicateipview AS
    SELECT duplicateip.id, duplicateip.ipaddr, duplicateip.interfaceid, duplicateip.flag, (SELECT interfacesetting.interfacename FROM interfacesetting WHERE (interfacesetting.id = duplicateip.interfaceid)) AS interfacename, (SELECT devices.strname FROM devices, interfacesetting WHERE ((interfacesetting.deviceid = devices.id) AND (interfacesetting.id = duplicateip.interfaceid))) AS devicename FROM duplicateip;


ALTER TABLE public.duplicateipview OWNER TO postgres;

--
-- TOC entry 101 (class 1255 OID 121165)
-- Dependencies: 5 544 558
-- Name: view_duplicateip_retrieve(timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_duplicateip_retrieve(dt timestamp without time zone, stypename character varying) RETURNS SETOF duplicateipview
    AS $$
declare
	r duplicateipview%rowtype;
	t timestamp without time zone;
BEGIN		
        select modifytime into t from objtimestamp where typename=stypename;
	if t is null or t>dt then
		for r in SELECT * FROM duplicateipview order by id loop
		return next r;
		end loop;	
	End IF;
END;

  $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.view_duplicateip_retrieve(dt timestamp without time zone, stypename character varying) OWNER TO postgres;

--
-- TOC entry 1586 (class 1259 OID 88384)
-- Dependencies: 2098 5
-- Name: fixupunnumberedinterface; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE fixupunnumberedinterface (
    id integer NOT NULL,
    sourcedevice character varying(64) NOT NULL,
    sourceport character varying(64) NOT NULL,
    destdevice character varying(64) NOT NULL,
    destport character varying(64) NOT NULL,
    userflag integer DEFAULT 0,
    retrievedate timestamp without time zone
);


ALTER TABLE public.fixupunnumberedinterface OWNER TO postgres;

--
-- TOC entry 102 (class 1255 OID 121168)
-- Dependencies: 412 558 5
-- Name: view_fixupunnumberedinterface_retrieve(timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_fixupunnumberedinterface_retrieve(dt timestamp without time zone, stypename character varying) RETURNS SETOF fixupunnumberedinterface
    AS $$
declare
	r fixupunnumberedinterface%rowtype;
	t timestamp without time zone;
BEGIN		
        select modifytime into t from objtimestamp where typename=stypename;
	if t is null or t>dt then
		for r in SELECT * FROM fixupunnumberedinterface order by id loop
		return next r;
		end loop;	
	End IF;
END;

  $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.view_fixupunnumberedinterface_retrieve(dt timestamp without time zone, stypename character varying) OWNER TO postgres;

--
-- TOC entry 1692 (class 1259 OID 120782)
-- Dependencies: 1787 5
-- Name: interfacesettingview; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW interfacesettingview AS
    SELECT interfacesetting.id, interfacesetting.deviceid, interfacesetting.interfacename, interfacesetting.usermodifiedflag, interfacesetting.livestatus, interfacesetting.mibindex, interfacesetting.bandwidth, interfacesetting.macaddress, interfacesetting.lasttimestamp, devices.strname AS devicename FROM interfacesetting, devices WHERE (devices.id = interfacesetting.deviceid) ORDER BY interfacesetting.id;


ALTER TABLE public.interfacesettingview OWNER TO postgres;

--
-- TOC entry 73 (class 1255 OID 120785)
-- Dependencies: 5 533 558
-- Name: view_interface_setting_retrieve(integer, integer, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_interface_setting_retrieve(ibegin integer, imax integer, dt timestamp without time zone) RETURNS SETOF interfacesettingview
    AS $$
declare
	r interfacesettingview%rowtype;
BEGIN
	if imax <0 then
		for r in SELECT * FROM interfacesettingview where id>ibegin AND lasttimestamp>dt loop
		return next r;
		end loop;
	else
		for r in SELECT * FROM interfacesettingview where id>ibegin AND lasttimestamp>dt limit imax loop
		return next r;
		end loop;

	end if;
END;

  $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.view_interface_setting_retrieve(ibegin integer, imax integer, dt timestamp without time zone) OWNER TO postgres;

--
-- TOC entry 103 (class 1255 OID 121169)
-- Dependencies: 419 558 5
-- Name: view_ip2mac_retrieve(integer, integer, timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_ip2mac_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) RETURNS SETOF ip2mac
    AS $$
declare
	r ip2mac%rowtype;
	t timestamp without time zone;
BEGIN
	select modifytime into t from objtimestamp where typename=stypename;
	
	if t is null or t>dt then
		if imax <0 then
			for r in SELECT * FROM ip2mac where id>ibegin order by id  loop
			return next r;
			end loop;
		else
			for r in SELECT * FROM ip2mac where id>ibegin order by id limit imax loop
			return next r;
			end loop;

		end if;	
	end if;	
END;

  $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.view_ip2mac_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) OWNER TO postgres;

--
-- TOC entry 1594 (class 1259 OID 88415)
-- Dependencies: 2112 5
-- Name: ipphone; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ipphone (
    phone_name character varying(128) NOT NULL,
    ipaddr character varying(64),
    macaddr character varying(64),
    phone_number character varying(64),
    call_manager character varying(128),
    switch_name character varying(128),
    vendor character varying(64),
    model character varying(64),
    version character varying(64),
    software_version character varying(64),
    id integer NOT NULL,
    lasttimestamp timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.ipphone OWNER TO postgres;

--
-- TOC entry 110 (class 1255 OID 121172)
-- Dependencies: 5 421 558
-- Name: view_ipphone_retrieve(integer, integer, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_ipphone_retrieve(ibegin integer, imax integer, dt timestamp without time zone) RETURNS SETOF ipphone
    AS $$
declare
	r ipphone%rowtype;
BEGIN
	if imax <0 then
		for r in SELECT * FROM ipphone where id>ibegin AND lasttimestamp>dt order by id loop
		return next r;
		end loop;
	else
		for r in SELECT * FROM ipphone where id>ibegin AND lasttimestamp>dt order by id limit imax loop
		return next r;
		end loop;

	end if;
END;

  $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.view_ipphone_retrieve(ibegin integer, imax integer, dt timestamp without time zone) OWNER TO postgres;

--
-- TOC entry 104 (class 1255 OID 121173)
-- Dependencies: 558 5 485
-- Name: view_l2connectivity_retrieve(integer, integer, timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_l2connectivity_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) RETURNS SETOF l2connectivity
    AS $$
declare
	r l2connectivity%rowtype;
	t timestamp without time zone;
BEGIN
	select modifytime into t from objtimestamp where typename=stypename;
	
	if t is null or t>dt then
		if imax <0 then
			for r in SELECT * FROM l2connectivity where id>ibegin order by id loop
			return next r;
			end loop;
		else
			for r in SELECT * FROM l2connectivity where id>ibegin order by id limit imax loop
			return next r;
			end loop;

		end if;	
	end if;	
END;

  $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.view_l2connectivity_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) OWNER TO postgres;

--
-- TOC entry 120 (class 1255 OID 120995)
-- Dependencies: 487 5 558
-- Name: view_l2switchinfo_retrieve(integer, integer, timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_l2switchinfo_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) RETURNS SETOF l2switchinfo
    AS $$
declare
	r l2switchinfo%rowtype;
BEGIN		
		if imax <0 then
			for r in SELECT * FROM l2switchinfo where id>ibegin and nb_timestamp>dt order by id  loop
			return next r;
			end loop;
		else
			for r in SELECT * FROM l2switchinfo where id>ibegin and nb_timestamp>dt order by id limit imax loop
			return next r;
			end loop;

		end if;	
END;

  $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.view_l2switchinfo_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) OWNER TO postgres;

--
-- TOC entry 1596 (class 1259 OID 88429)
-- Dependencies: 2113 2114 2115 2116 2117 2119 5
-- Name: l2switchport; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE l2switchport (
    id integer NOT NULL,
    switchname character varying(64) NOT NULL,
    portname character varying(64) NOT NULL,
    status character varying(32),
    speed character varying(64),
    duplex integer DEFAULT 2 NOT NULL,
    portmode character varying DEFAULT 64,
    trunkencapsulation character varying(64),
    stpstatus character varying(64),
    vlans character varying(254),
    description character varying(254),
    nb_timestamp timestamp without time zone DEFAULT now() NOT NULL,
    usermodifed integer DEFAULT 0 NOT NULL,
    channelgroupmode integer DEFAULT 0 NOT NULL,
    channelgroupname character varying(128) DEFAULT 0 NOT NULL,
    exclude_vlans character varying(254)
);


ALTER TABLE public.l2switchport OWNER TO postgres;

--
-- TOC entry 2631 (class 0 OID 0)
-- Dependencies: 1596
-- Name: COLUMN l2switchport.usermodifed; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN l2switchport.usermodifed IS '0: org  1: discovery  2: manual';


--
-- TOC entry 119 (class 1255 OID 120999)
-- Dependencies: 423 5 558
-- Name: view_l2switchport_retrieve(integer, integer, timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_l2switchport_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) RETURNS SETOF l2switchport
    AS $$
declare
	r l2switchport%rowtype;
BEGIN	
		if imax <0 then
			for r in select * from l2switchport where switchname in (SELECT devicename FROM l2switchinfo where id>ibegin and nb_timestamp>dt order by id)  loop
			return next r;
			end loop;
		else
			for r in select * from l2switchport where switchname in (SELECT devicename FROM l2switchinfo where id>ibegin and nb_timestamp>dt order by id limit imax)  loop
			return next r;
			end loop;

		end if;		
END;

  $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.view_l2switchport_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) OWNER TO postgres;

--
-- TOC entry 1598 (class 1259 OID 88442)
-- Dependencies: 2120 2122 5
-- Name: l2switchvlan; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE l2switchvlan (
    id integer NOT NULL,
    switchname character varying(64) NOT NULL,
    vlannumber integer NOT NULL,
    vlantype character varying(64),
    mtu integer,
    vlanstatus character varying(64),
    switchports character varying(254),
    parentvlan integer,
    vlanmode character varying(64),
    said integer,
    description character varying(254),
    nb_timestamp timestamp without time zone DEFAULT now() NOT NULL,
    usermodifed integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.l2switchvlan OWNER TO postgres;

--
-- TOC entry 2632 (class 0 OID 0)
-- Dependencies: 1598
-- Name: COLUMN l2switchvlan.usermodifed; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN l2switchvlan.usermodifed IS '0: org  1: discovery  2: danual';


--
-- TOC entry 118 (class 1255 OID 120996)
-- Dependencies: 558 425 5
-- Name: view_l2switchvlan_retrieve(integer, integer, timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_l2switchvlan_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) RETURNS SETOF l2switchvlan
    AS $$
declare
	r l2switchvlan%rowtype;	
BEGIN

		if imax <0 then
			for r in select * from l2switchvlan where switchname in (SELECT devicename FROM l2switchinfo where id>ibegin and nb_timestamp>dt order by id)  loop
			return next r;
			end loop;
		else
			for r in select * from l2switchvlan where switchname in (SELECT devicename FROM l2switchinfo where id>ibegin and nb_timestamp>dt order by id limit imax)  loop
			return next r;
			end loop;

		end if;	
END;

  $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.view_l2switchvlan_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) OWNER TO postgres;

--
-- TOC entry 105 (class 1255 OID 120983)
-- Dependencies: 427 558 5
-- Name: view_lanswitch_retrieve(integer, integer, timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_lanswitch_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) RETURNS SETOF lanswitch
    AS $$
declare
	r lanswitch%rowtype;
	t timestamp without time zone;
BEGIN
	select modifytime into t from objtimestamp where typename=stypename;
	
	if t is null or t>dt then
		if imax <0 then
			for r in SELECT * FROM lanswitch where id>ibegin order by id loop
			return next r;
			end loop;
		else
			for r in SELECT * FROM lanswitch where id>ibegin order by id limit imax loop
			return next r;
			end loop;

		end if;	
	end if;	
END;

  $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.view_lanswitch_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) OWNER TO postgres;

--
-- TOC entry 1695 (class 1259 OID 120857)
-- Dependencies: 1788 5
-- Name: nomp_applianceview; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW nomp_applianceview AS
    SELECT nomp_appliance.id, nomp_appliance.strhostname, nomp_appliance.strdescription, nomp_appliance.stripaddr, nomp_appliance.iserveport, nomp_appliance.bhome, nomp_appliance.blive, nomp_appliance.bmodified, nomp_appliance.imaxdevicecount, nomp_appliance.ibapport, nomp_appliance.ipri, nomp_appliance.telnet_user, nomp_appliance.telnet_pwd, (SELECT count(*) AS count FROM devicesetting WHERE (devicesetting.appliceid = nomp_appliance.id)) AS irefcount FROM nomp_appliance ORDER BY nomp_appliance.ipri;


ALTER TABLE public.nomp_applianceview OWNER TO postgres;

--
-- TOC entry 79 (class 1255 OID 120958)
-- Dependencies: 536 5 558
-- Name: view_nomp_appliance_retrieve(timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_nomp_appliance_retrieve(dt timestamp without time zone, stypename character varying) RETURNS SETOF nomp_applianceview
    AS $$
declare
	r nomp_applianceview%rowtype;
	t timestamp without time zone;
BEGIN		
        select modifytime into t from objtimestamp where typename=stypename;
	if t is null or t>dt then
		for r in SELECT * FROM nomp_applianceview loop
		return next r;
		end loop;	
	End IF;
END;

  $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.view_nomp_appliance_retrieve(dt timestamp without time zone, stypename character varying) OWNER TO postgres;

--
-- TOC entry 1607 (class 1259 OID 88466)
-- Dependencies: 5
-- Name: nomp_enablepasswd_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE nomp_enablepasswd_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.nomp_enablepasswd_id_seq OWNER TO postgres;

--
-- TOC entry 2633 (class 0 OID 0)
-- Dependencies: 1607
-- Name: nomp_enablepasswd_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('nomp_enablepasswd_id_seq', 1, true);


--
-- TOC entry 1608 (class 1259 OID 88468)
-- Dependencies: 2129 5
-- Name: nomp_enablepasswd; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE nomp_enablepasswd (
    id integer DEFAULT nextval('nomp_enablepasswd_id_seq'::regclass) NOT NULL,
    stralias character varying(32) NOT NULL,
    strenablepasswd text NOT NULL,
    bmodified integer,
    ipri integer NOT NULL
);


ALTER TABLE public.nomp_enablepasswd OWNER TO postgres;

--
-- TOC entry 1696 (class 1259 OID 120866)
-- Dependencies: 1789 5
-- Name: nomp_enablepasswdview; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW nomp_enablepasswdview AS
    SELECT nomp_enablepasswd.id, nomp_enablepasswd.stralias, nomp_enablepasswd.strenablepasswd, nomp_enablepasswd.bmodified, nomp_enablepasswd.ipri, (SELECT count(*) AS count FROM devicesetting WHERE (devicesetting.enablepassword = nomp_enablepasswd.strenablepasswd)) AS irefcount FROM nomp_enablepasswd ORDER BY nomp_enablepasswd.ipri;


ALTER TABLE public.nomp_enablepasswdview OWNER TO postgres;

--
-- TOC entry 78 (class 1255 OID 120959)
-- Dependencies: 537 5 558
-- Name: view_nomp_enablepasswd_retrieve(timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_nomp_enablepasswd_retrieve(dt timestamp without time zone, stypename character varying) RETURNS SETOF nomp_enablepasswdview
    AS $$
declare
	r nomp_enablepasswdview%rowtype;
	t timestamp without time zone;
BEGIN		
        select modifytime into t from objtimestamp where typename=stypename;
	if t is null or t>dt then
		for r in SELECT * FROM nomp_enablepasswdview loop
		return next r;
		end loop;	
	End IF;
END;

  $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.view_nomp_enablepasswd_retrieve(dt timestamp without time zone, stypename character varying) OWNER TO postgres;

--
-- TOC entry 1610 (class 1259 OID 88473)
-- Dependencies: 5
-- Name: nomp_jumpbox_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE nomp_jumpbox_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.nomp_jumpbox_id_seq OWNER TO postgres;

--
-- TOC entry 2634 (class 0 OID 0)
-- Dependencies: 1610
-- Name: nomp_jumpbox_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('nomp_jumpbox_id_seq', 1, true);


--
-- TOC entry 1611 (class 1259 OID 88475)
-- Dependencies: 2130 5
-- Name: nomp_jumpbox; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE nomp_jumpbox (
    id integer DEFAULT nextval('nomp_jumpbox_id_seq'::regclass) NOT NULL,
    strname character varying(32) NOT NULL,
    itype integer NOT NULL,
    stripaddr character varying(16) NOT NULL,
    iport integer NOT NULL,
    imode integer,
    strusername character varying(64),
    strpasswd text,
    strloginprompt character varying(64),
    strpasswdprompt character varying(64),
    strcommandprompt character varying(64),
    stryesnoprompt character varying(64),
    bmodified integer,
    strenablecmd character varying(64),
    strenablepasswordprompt character varying(64),
    strenablepassword text,
    strenableprompt character varying(64),
    ipri integer NOT NULL
);


ALTER TABLE public.nomp_jumpbox OWNER TO postgres;

--
-- TOC entry 1697 (class 1259 OID 120869)
-- Dependencies: 1790 5
-- Name: nomp_jumpboxview; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW nomp_jumpboxview AS
    SELECT nomp_jumpbox.id, nomp_jumpbox.strname, nomp_jumpbox.itype, nomp_jumpbox.stripaddr, nomp_jumpbox.iport, nomp_jumpbox.imode, nomp_jumpbox.strusername, nomp_jumpbox.strpasswd, nomp_jumpbox.strloginprompt, nomp_jumpbox.strpasswdprompt, nomp_jumpbox.strcommandprompt, nomp_jumpbox.stryesnoprompt, nomp_jumpbox.bmodified, nomp_jumpbox.strenablecmd, nomp_jumpbox.strenablepasswordprompt, nomp_jumpbox.strenablepassword, nomp_jumpbox.strenableprompt, nomp_jumpbox.ipri, (SELECT count(*) AS count FROM devicesetting WHERE (devicesetting.telnetproxyid = nomp_jumpbox.id)) AS irefcount FROM nomp_jumpbox ORDER BY nomp_jumpbox.ipri;


ALTER TABLE public.nomp_jumpboxview OWNER TO postgres;

--
-- TOC entry 77 (class 1255 OID 120962)
-- Dependencies: 538 558 5
-- Name: view_nomp_jumpbox_retrieve(timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_nomp_jumpbox_retrieve(dt timestamp without time zone, stypename character varying) RETURNS SETOF nomp_jumpboxview
    AS $$
declare
	r nomp_jumpboxview%rowtype;
	t timestamp without time zone;
BEGIN		
        select modifytime into t from objtimestamp where typename=stypename;
	if t is null or t>dt then
		for r in SELECT * FROM nomp_jumpboxview loop
		return next r;
		end loop;	
	End IF;
END;

  $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.view_nomp_jumpbox_retrieve(dt timestamp without time zone, stypename character varying) OWNER TO postgres;

--
-- TOC entry 1613 (class 1259 OID 88480)
-- Dependencies: 5
-- Name: nomp_snmproinfo_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE nomp_snmproinfo_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.nomp_snmproinfo_id_seq OWNER TO postgres;

--
-- TOC entry 2635 (class 0 OID 0)
-- Dependencies: 1613
-- Name: nomp_snmproinfo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('nomp_snmproinfo_id_seq', 1, true);


--
-- TOC entry 1614 (class 1259 OID 88482)
-- Dependencies: 2131 5
-- Name: nomp_snmproinfo; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE nomp_snmproinfo (
    id integer DEFAULT nextval('nomp_snmproinfo_id_seq'::regclass) NOT NULL,
    strrostring text NOT NULL,
    bmodified integer,
    ipri integer NOT NULL
);


ALTER TABLE public.nomp_snmproinfo OWNER TO postgres;

--
-- TOC entry 1698 (class 1259 OID 120880)
-- Dependencies: 1791 5
-- Name: nomp_snmproinfoview; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW nomp_snmproinfoview AS
    SELECT nomp_snmproinfo.id, nomp_snmproinfo.strrostring, nomp_snmproinfo.bmodified, nomp_snmproinfo.ipri, (SELECT count(*) AS count FROM devicesetting WHERE (devicesetting.snmpro = nomp_snmproinfo.strrostring)) AS irefcount FROM nomp_snmproinfo ORDER BY nomp_snmproinfo.ipri;


ALTER TABLE public.nomp_snmproinfoview OWNER TO postgres;

--
-- TOC entry 76 (class 1255 OID 120963)
-- Dependencies: 5 539 558
-- Name: view_nomp_snmproinfo_retrieve(timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_nomp_snmproinfo_retrieve(dt timestamp without time zone, stypename character varying) RETURNS SETOF nomp_snmproinfoview
    AS $$
declare
	r nomp_snmproinfoview%rowtype;
	t timestamp without time zone;
BEGIN		
        select modifytime into t from objtimestamp where typename=stypename;
	if t is null or t>dt then
		for r in SELECT * FROM nomp_snmproinfoview loop
		return next r;
		end loop;	
	End IF;
END;

  $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.view_nomp_snmproinfo_retrieve(dt timestamp without time zone, stypename character varying) OWNER TO postgres;

--
-- TOC entry 1619 (class 1259 OID 88494)
-- Dependencies: 5
-- Name: nomp_telnetinfo_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE nomp_telnetinfo_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.nomp_telnetinfo_id_seq OWNER TO postgres;

--
-- TOC entry 2636 (class 0 OID 0)
-- Dependencies: 1619
-- Name: nomp_telnetinfo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('nomp_telnetinfo_id_seq', 1, true);


--
-- TOC entry 1620 (class 1259 OID 88496)
-- Dependencies: 2133 5
-- Name: nomp_telnetinfo; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE nomp_telnetinfo (
    id integer DEFAULT nextval('nomp_telnetinfo_id_seq'::regclass) NOT NULL,
    stralias character varying(32) NOT NULL,
    idevicetype integer,
    strusername character varying(32),
    strpasswd character varying(100) NOT NULL,
    bmodified integer,
    userid integer,
    ipri integer NOT NULL
);


ALTER TABLE public.nomp_telnetinfo OWNER TO postgres;

--
-- TOC entry 1699 (class 1259 OID 120883)
-- Dependencies: 1792 5
-- Name: nomp_telnetinfoview; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW nomp_telnetinfoview AS
    SELECT nomp_telnetinfo.id, nomp_telnetinfo.stralias, nomp_telnetinfo.idevicetype, nomp_telnetinfo.strusername, nomp_telnetinfo.strpasswd, nomp_telnetinfo.bmodified, nomp_telnetinfo.userid, nomp_telnetinfo.ipri, nomp_telnetinfo.id AS irefcount FROM nomp_telnetinfo ORDER BY nomp_telnetinfo.ipri;


ALTER TABLE public.nomp_telnetinfoview OWNER TO postgres;

--
-- TOC entry 130 (class 1255 OID 122713)
-- Dependencies: 540 5 558
-- Name: view_nomp_telnetinfo_retrieve(timestamp without time zone, character varying, integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_nomp_telnetinfo_retrieve(dt timestamp without time zone, stypename character varying, uid integer, funcname character varying) RETURNS SETOF nomp_telnetinfoview
    AS $$
declare
	r nomp_telnetinfoview%rowtype;
	t timestamp without time zone;
	ispublic integer;
BEGIN		
	select c.count into ispublic from (select count(a.id) as count from (select user2role.roleid as id from "user",user2role where "user".id=uid and "user".id =user2role.userid) as a where a.id in (select role2function.roleid as id from role2function,"function" where "function".sidname=funcname and "function".id=role2function.functionid)) as c;
        select modifytime into t from objtimestamp where typename=stypename;
	if t is null or t>dt then
		for r in SELECT * FROM nomp_telnetinfoview where userid=uid loop
			if ispublic>0 then 
				select a.count into r.iRefCount from (select count(id) as count from devicesetting where username=r.STRuseRnaMe and UserPassword=r.STRpAssWD) as a;								
			else
				select a.count into r.iRefCount from (select count(id) as count from userdevicesetting where TeLNetUserName=r.STRuseRnaMe and TeLNetPwD=r.STRpAssWD) as a;								
			end if;			
			return next r;
		end loop;	
	End IF;
END;

  $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.view_nomp_telnetinfo_retrieve(dt timestamp without time zone, stypename character varying, uid integer, funcname character varying) OWNER TO postgres;

--
-- TOC entry 1625 (class 1259 OID 88513)
-- Dependencies: 2136 5
-- Name: switchgroup; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE switchgroup (
    id integer NOT NULL,
    strname character varying(64) NOT NULL,
    description character varying(256),
    showcolor integer DEFAULT 16777215 NOT NULL
);


ALTER TABLE public.switchgroup OWNER TO postgres;

--
-- TOC entry 1627 (class 1259 OID 88517)
-- Dependencies: 5
-- Name: swtichgroupdevice; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE swtichgroupdevice (
    switchgroupid integer NOT NULL,
    deviceid integer NOT NULL,
    id integer NOT NULL
);


ALTER TABLE public.swtichgroupdevice OWNER TO postgres;

--
-- TOC entry 1702 (class 1259 OID 120944)
-- Dependencies: 1795 5
-- Name: switchgroupview; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW switchgroupview AS
    SELECT switchgroup.id, switchgroup.strname, switchgroup.description, switchgroup.showcolor, (SELECT count(*) AS count FROM swtichgroupdevice WHERE (swtichgroupdevice.switchgroupid = switchgroup.id)) AS irefcount FROM switchgroup ORDER BY switchgroup.id;


ALTER TABLE public.switchgroupview OWNER TO postgres;

--
-- TOC entry 75 (class 1255 OID 120954)
-- Dependencies: 5 558 543
-- Name: view_switchgroup_retrieve(integer, integer, timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_switchgroup_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) RETURNS SETOF switchgroupview
    AS $$
declare
	r switchgroupview%rowtype;
	t timestamp without time zone;
BEGIN
	select modifytime into t from objtimestamp where typename=stypename;
	
	if t is null or t>dt then
		if imax <0 then
			for r in SELECT * FROM switchgroupview where id>ibegin  loop
			return next r;
			end loop;
		else
			for r in SELECT * FROM switchgroupview where id>ibegin limit imax loop
			return next r;
			end loop;

		end if;	
	end if;	
END;

  $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.view_switchgroup_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) OWNER TO postgres;

--
-- TOC entry 1705 (class 1259 OID 121144)
-- Dependencies: 1798 5
-- Name: swtichgroupdeviceview; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW swtichgroupdeviceview AS
    SELECT swtichgroupdevice.switchgroupid, swtichgroupdevice.deviceid, swtichgroupdevice.id, (SELECT devices.strname FROM devices WHERE (devices.id = swtichgroupdevice.deviceid)) AS devicename, (SELECT switchgroup.strname FROM switchgroup WHERE (switchgroup.id = swtichgroupdevice.switchgroupid)) AS swtichdevicegroupname, (SELECT devices.isubtype FROM devices WHERE (devices.id = swtichgroupdevice.deviceid)) AS isubtype FROM swtichgroupdevice;


ALTER TABLE public.swtichgroupdeviceview OWNER TO postgres;

--
-- TOC entry 106 (class 1255 OID 121155)
-- Dependencies: 558 5 546
-- Name: view_swtichgroupdevice_retrieve(integer, integer, timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_swtichgroupdevice_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) RETURNS SETOF swtichgroupdeviceview
    AS $$
declare
	r swtichgroupdeviceview%rowtype;
	t timestamp without time zone;
BEGIN
	select modifytime into t from objtimestamp where typename=stypename;
	
	if t is null or t>dt then
		if imax <0 then
			for r in select * from swtichgroupdeviceview where switchgroupid in (SELECT id FROM switchgroup where id>ibegin order by id) order by switchgroupid loop
			return next r;
			end loop;
		else
			for r in select * from swtichgroupdeviceview where switchgroupid in (SELECT id FROM switchgroup where id>ibegin order by id limit imax) order by switchgroupid loop			
			return next r;
			end loop;

		end if;	
	end if;	
END;

  $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.view_swtichgroupdevice_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) OWNER TO postgres;

--
-- TOC entry 1682 (class 1259 OID 92190)
-- Dependencies: 2186 2187 5
-- Name: systemdevicegroup; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE systemdevicegroup (
    id integer NOT NULL,
    strname character varying(256) NOT NULL,
    strdesc character varying(512),
    showcolor integer DEFAULT 16777215 NOT NULL,
    lasttimestamp timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.systemdevicegroup OWNER TO postgres;

--
-- TOC entry 1684 (class 1259 OID 92203)
-- Dependencies: 2189 5
-- Name: systemdevicegroupdevice; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE systemdevicegroupdevice (
    systemdevicegroupid integer NOT NULL,
    deviceid integer NOT NULL,
    id integer NOT NULL,
    lasttimestamp timestamp without time zone DEFAULT now()
);


ALTER TABLE public.systemdevicegroupdevice OWNER TO postgres;

--
-- TOC entry 1701 (class 1259 OID 120928)
-- Dependencies: 1794 5
-- Name: systemdevicegroupview; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW systemdevicegroupview AS
    SELECT systemdevicegroup.id, systemdevicegroup.strname, systemdevicegroup.strdesc, systemdevicegroup.showcolor, systemdevicegroup.lasttimestamp, (SELECT count(*) AS count FROM systemdevicegroupdevice WHERE (systemdevicegroupdevice.systemdevicegroupid = systemdevicegroup.id)) AS irefcount FROM systemdevicegroup ORDER BY systemdevicegroup.id;


ALTER TABLE public.systemdevicegroupview OWNER TO postgres;

--
-- TOC entry 74 (class 1255 OID 120938)
-- Dependencies: 558 5 542
-- Name: view_systemdevicegroup_retrieve(integer, integer, timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_systemdevicegroup_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) RETURNS SETOF systemdevicegroupview
    AS $$
declare
	r systemdevicegroupview%rowtype;
	t timestamp without time zone;
BEGIN
	select modifytime into t from objtimestamp where typename=stypename;
	
	if t is null or t>dt then
		if imax <0 then
			for r in SELECT * FROM systemdevicegroupview where id>ibegin  loop
			return next r;
			end loop;
		else
			for r in SELECT * FROM systemdevicegroupview where id>ibegin limit imax loop
			return next r;
			end loop;

		end if;	
	end if;	
END;

  $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.view_systemdevicegroup_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) OWNER TO postgres;

--
-- TOC entry 1706 (class 1259 OID 121147)
-- Dependencies: 1799 5
-- Name: systemdevicegroupdeviceview; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW systemdevicegroupdeviceview AS
    SELECT systemdevicegroupdevice.systemdevicegroupid, systemdevicegroupdevice.deviceid, systemdevicegroupdevice.id, systemdevicegroupdevice.lasttimestamp, (SELECT devices.strname FROM devices WHERE (devices.id = systemdevicegroupdevice.deviceid)) AS devicename, (SELECT systemdevicegroup.strname FROM systemdevicegroup WHERE (systemdevicegroup.id = systemdevicegroupdevice.systemdevicegroupid)) AS systemdevicegroupname, (SELECT devices.isubtype FROM devices WHERE (devices.id = systemdevicegroupdevice.deviceid)) AS isubtype FROM systemdevicegroupdevice;


ALTER TABLE public.systemdevicegroupdeviceview OWNER TO postgres;

--
-- TOC entry 107 (class 1255 OID 121158)
-- Dependencies: 558 5 547
-- Name: view_systemdevicegroupdevice_retrieve(integer, integer, timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_systemdevicegroupdevice_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) RETURNS SETOF systemdevicegroupdeviceview
    AS $$
declare
	r systemdevicegroupdeviceview%rowtype;
	t timestamp without time zone;
BEGIN
	select modifytime into t from objtimestamp where typename=stypename;
	
	if t is null or t>dt then
		if imax <0 then
			for r in select * from systemdevicegroupdeviceview where systemdevicegroupid in (SELECT id FROM systemdevicegroup where id>ibegin order by id) order by systemdevicegroupid loop
			return next r;
			end loop;
		else
			for r in select * from systemdevicegroupdeviceview where systemdevicegroupid in (SELECT id FROM systemdevicegroup where id>ibegin order by id limit imax) order by systemdevicegroupid loop			
			return next r;
			end loop;

		end if;	
	end if;	
END;

  $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.view_systemdevicegroupdevice_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) OWNER TO postgres;

--
-- TOC entry 1709 (class 1259 OID 121240)
-- Dependencies: 1800 5
-- Name: userdevicesettingview; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW userdevicesettingview AS
    SELECT userdevicesetting.id, userdevicesetting.deviceid, userdevicesetting.userid, userdevicesetting.managerip, userdevicesetting.telnetusername, userdevicesetting.telnetpwd, userdevicesetting.dtstamp, devices.strname AS devicename FROM userdevicesetting, devices WHERE (devices.id = userdevicesetting.deviceid);


ALTER TABLE public.userdevicesettingview OWNER TO postgres;

--
-- TOC entry 109 (class 1255 OID 121249)
-- Dependencies: 5 558 550
-- Name: view_userdevicesetting_retrieve(integer, integer, timestamp without time zone, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_userdevicesetting_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer) RETURNS SETOF userdevicesettingview
    AS $$
declare
	r userdevicesettingview%rowtype;
BEGIN
	if imax <0 then
		for r in SELECT * FROM userdevicesettingview where id>ibegin and userid=uid AND dtstamp>dt order by id loop
		return next r;
		end loop;
	else
		for r in SELECT * FROM userdevicesettingview where id>ibegin and userid=uid AND dtstamp>dt order by id limit imax loop
		return next r;
		end loop;

	end if;
END;

  $$
    LANGUAGE plpgsql;


ALTER FUNCTION public.view_userdevicesetting_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer) OWNER TO postgres;

--
-- TOC entry 1563 (class 1259 OID 88291)
-- Dependencies: 5
-- Name: adminpwd; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE adminpwd (
    id integer NOT NULL,
    pwd character varying(256)
);


ALTER TABLE public.adminpwd OWNER TO postgres;

--
-- TOC entry 1564 (class 1259 OID 88293)
-- Dependencies: 5 1563
-- Name: adminpwd_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE adminpwd_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.adminpwd_id_seq OWNER TO postgres;

--
-- TOC entry 2637 (class 0 OID 0)
-- Dependencies: 1564
-- Name: adminpwd_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE adminpwd_id_seq OWNED BY adminpwd.id;


--
-- TOC entry 2638 (class 0 OID 0)
-- Dependencies: 1564
-- Name: adminpwd_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('adminpwd_id_seq', 1, true);


--
-- TOC entry 1566 (class 1259 OID 88297)
-- Dependencies: 5
-- Name: benchmarkfolder; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE benchmarkfolder (
    id integer NOT NULL,
    tdstamp time without time zone NOT NULL
);


ALTER TABLE public.benchmarkfolder OWNER TO postgres;

--
-- TOC entry 1567 (class 1259 OID 88299)
-- Dependencies: 5 1566
-- Name: benchmarkfolder_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE benchmarkfolder_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.benchmarkfolder_id_seq OWNER TO postgres;

--
-- TOC entry 2639 (class 0 OID 0)
-- Dependencies: 1567
-- Name: benchmarkfolder_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE benchmarkfolder_id_seq OWNED BY benchmarkfolder.id;


--
-- TOC entry 2640 (class 0 OID 0)
-- Dependencies: 1567
-- Name: benchmarkfolder_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('benchmarkfolder_id_seq', 1, false);


--
-- TOC entry 1661 (class 1259 OID 90871)
-- Dependencies: 2167 2168 2169 2170 2171 2172 5
-- Name: benchmarktask; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE benchmarktask (
    id integer NOT NULL,
    itype integer NOT NULL,
    strname character varying(256) NOT NULL,
    creator character varying(256),
    createtime timestamp without time zone NOT NULL,
    modifytime timestamp without time zone NOT NULL,
    imode integer NOT NULL,
    startday timestamp without time zone NOT NULL,
    starttime time without time zone NOT NULL,
    every integer DEFAULT 1 NOT NULL,
    iselect integer DEFAULT 1 NOT NULL,
    monthday integer DEFAULT 1 NOT NULL,
    benable boolean DEFAULT true NOT NULL,
    buildl2 integer DEFAULT 1,
    buildl3 integer DEFAULT 1,
    lastruntime timestamp without time zone
);


ALTER TABLE public.benchmarktask OWNER TO postgres;

--
-- TOC entry 1660 (class 1259 OID 90869)
-- Dependencies: 5 1661
-- Name: benchmarktask_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE benchmarktask_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.benchmarktask_id_seq OWNER TO postgres;

--
-- TOC entry 2641 (class 0 OID 0)
-- Dependencies: 1660
-- Name: benchmarktask_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE benchmarktask_id_seq OWNED BY benchmarktask.id;


--
-- TOC entry 2642 (class 0 OID 0)
-- Dependencies: 1660
-- Name: benchmarktask_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('benchmarktask_id_seq', 1, false);


--
-- TOC entry 1711 (class 1259 OID 121331)
-- Dependencies: 5
-- Name: benchmarktaskstatus; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE benchmarktaskstatus (
    id integer NOT NULL,
    taskid integer NOT NULL,
    runbegintime timestamp without time zone,
    runendtime timestamp without time zone,
    runstatus character varying(1024)
);


ALTER TABLE public.benchmarktaskstatus OWNER TO postgres;

--
-- TOC entry 1710 (class 1259 OID 121329)
-- Dependencies: 1711 5
-- Name: benchmarktaskstatus_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE benchmarktaskstatus_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.benchmarktaskstatus_id_seq OWNER TO postgres;

--
-- TOC entry 2643 (class 0 OID 0)
-- Dependencies: 1710
-- Name: benchmarktaskstatus_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE benchmarktaskstatus_id_seq OWNED BY benchmarktaskstatus.id;


--
-- TOC entry 2644 (class 0 OID 0)
-- Dependencies: 1710
-- Name: benchmarktaskstatus_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('benchmarktaskstatus_id_seq', 1, false);


--
-- TOC entry 1691 (class 1259 OID 109575)
-- Dependencies: 2193 5
-- Name: bgpneighbor; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE bgpneighbor (
    id integer NOT NULL,
    deviceid integer NOT NULL,
    remoteasnum integer NOT NULL,
    neighborip integer,
    localasnum integer,
    lastmodifytime timestamp without time zone DEFAULT now()
);


ALTER TABLE public.bgpneighbor OWNER TO postgres;

--
-- TOC entry 1690 (class 1259 OID 109573)
-- Dependencies: 1691 5
-- Name: bgpneighbor_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE bgpneighbor_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.bgpneighbor_id_seq OWNER TO postgres;

--
-- TOC entry 2645 (class 0 OID 0)
-- Dependencies: 1690
-- Name: bgpneighbor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE bgpneighbor_id_seq OWNED BY bgpneighbor.id;


--
-- TOC entry 2646 (class 0 OID 0)
-- Dependencies: 1690
-- Name: bgpneighbor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('bgpneighbor_id_seq', 1, false);


--
-- TOC entry 1568 (class 1259 OID 88307)
-- Dependencies: 5
-- Name: device_config; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE device_config (
    deviceid integer NOT NULL,
    configfile text NOT NULL,
    dtstamp timestamp without time zone NOT NULL
);


ALTER TABLE public.device_config OWNER TO postgres;

--
-- TOC entry 1569 (class 1259 OID 88312)
-- Dependencies: 5
-- Name: device_maintype; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE device_maintype (
    maintype integer NOT NULL,
    strname character varying(512) NOT NULL
);


ALTER TABLE public.device_maintype OWNER TO postgres;

--
-- TOC entry 1570 (class 1259 OID 88314)
-- Dependencies: 2060 5
-- Name: device_subtype; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE device_subtype (
    maintype integer NOT NULL,
    subtype integer NOT NULL,
    subtype_name character varying(128) NOT NULL,
    is_benchmarkserver_used integer,
    is_server_used integer DEFAULT 0,
    id integer NOT NULL
);


ALTER TABLE public.device_subtype OWNER TO postgres;

--
-- TOC entry 1571 (class 1259 OID 88317)
-- Dependencies: 5 1570
-- Name: device_subtype_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE device_subtype_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.device_subtype_id_seq OWNER TO postgres;

--
-- TOC entry 2647 (class 0 OID 0)
-- Dependencies: 1571
-- Name: device_subtype_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE device_subtype_id_seq OWNED BY device_subtype.id;


--
-- TOC entry 2648 (class 0 OID 0)
-- Dependencies: 1571
-- Name: device_subtype_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('device_subtype_id_seq', 1, false);


--
-- TOC entry 1573 (class 1259 OID 88322)
-- Dependencies: 5 1572
-- Name: devicegroup_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE devicegroup_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.devicegroup_id_seq OWNER TO postgres;

--
-- TOC entry 2649 (class 0 OID 0)
-- Dependencies: 1573
-- Name: devicegroup_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE devicegroup_id_seq OWNED BY devicegroup.id;


--
-- TOC entry 2650 (class 0 OID 0)
-- Dependencies: 1573
-- Name: devicegroup_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('devicegroup_id_seq', 1, true);


--
-- TOC entry 1575 (class 1259 OID 88326)
-- Dependencies: 1574 5
-- Name: devicegroupdevice_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE devicegroupdevice_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.devicegroupdevice_id_seq OWNER TO postgres;

--
-- TOC entry 2651 (class 0 OID 0)
-- Dependencies: 1575
-- Name: devicegroupdevice_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE devicegroupdevice_id_seq OWNED BY devicegroupdevice.id;


--
-- TOC entry 2652 (class 0 OID 0)
-- Dependencies: 1575
-- Name: devicegroupdevice_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('devicegroupdevice_id_seq', 1, true);


--
-- TOC entry 1678 (class 1259 OID 92156)
-- Dependencies: 2182 5
-- Name: deviceprotocols; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE deviceprotocols (
    id integer NOT NULL,
    deviceid integer NOT NULL,
    protocalname character varying(64) NOT NULL,
    lastmodifytime timestamp without time zone DEFAULT now()
);


ALTER TABLE public.deviceprotocols OWNER TO postgres;

--
-- TOC entry 2653 (class 0 OID 0)
-- Dependencies: 1678
-- Name: COLUMN deviceprotocols.deviceid; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN deviceprotocols.deviceid IS 'refrence to the id in devices table';


--
-- TOC entry 1677 (class 1259 OID 92154)
-- Dependencies: 5 1678
-- Name: deviceprotocols_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE deviceprotocols_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.deviceprotocols_id_seq OWNER TO postgres;

--
-- TOC entry 2654 (class 0 OID 0)
-- Dependencies: 1677
-- Name: deviceprotocols_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE deviceprotocols_id_seq OWNED BY deviceprotocols.id;


--
-- TOC entry 2655 (class 0 OID 0)
-- Dependencies: 1677
-- Name: deviceprotocols_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('deviceprotocols_id_seq', 1, false);


--
-- TOC entry 1579 (class 1259 OID 88364)
-- Dependencies: 5 1578
-- Name: devicesetting_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE devicesetting_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.devicesetting_id_seq OWNER TO postgres;

--
-- TOC entry 2656 (class 0 OID 0)
-- Dependencies: 1579
-- Name: devicesetting_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE devicesetting_id_seq OWNED BY devicesetting.id;


--
-- TOC entry 2657 (class 0 OID 0)
-- Dependencies: 1579
-- Name: devicesetting_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('devicesetting_id_seq', 1, true);


--
-- TOC entry 1680 (class 1259 OID 92174)
-- Dependencies: 2184 5
-- Name: devicevpns; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE devicevpns (
    id integer NOT NULL,
    deviceid integer NOT NULL,
    vpnname character varying(64) NOT NULL,
    lastmodifytime timestamp without time zone DEFAULT now()
);


ALTER TABLE public.devicevpns OWNER TO postgres;

--
-- TOC entry 1679 (class 1259 OID 92172)
-- Dependencies: 1680 5
-- Name: devicevpns_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE devicevpns_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.devicevpns_id_seq OWNER TO postgres;

--
-- TOC entry 2658 (class 0 OID 0)
-- Dependencies: 1679
-- Name: devicevpns_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE devicevpns_id_seq OWNED BY devicevpns.id;


--
-- TOC entry 2659 (class 0 OID 0)
-- Dependencies: 1679
-- Name: devicevpns_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('devicevpns_id_seq', 1, false);


SET default_with_oids = true;

--
-- TOC entry 1654 (class 1259 OID 90737)
-- Dependencies: 2158 5
-- Name: disableinterface; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE disableinterface (
    id integer NOT NULL,
    interfaceid integer NOT NULL,
    flag integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.disableinterface OWNER TO postgres;

--
-- TOC entry 1653 (class 1259 OID 90735)
-- Dependencies: 5 1654
-- Name: disableinterface_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE disableinterface_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.disableinterface_id_seq OWNER TO postgres;

--
-- TOC entry 2660 (class 0 OID 0)
-- Dependencies: 1653
-- Name: disableinterface_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE disableinterface_id_seq OWNED BY disableinterface.id;


--
-- TOC entry 2661 (class 0 OID 0)
-- Dependencies: 1653
-- Name: disableinterface_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('disableinterface_id_seq', 1, false);


SET default_with_oids = false;

--
-- TOC entry 1668 (class 1259 OID 91097)
-- Dependencies: 5
-- Name: discover_missdevice; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE discover_missdevice (
    id integer NOT NULL,
    hostname character varying(255) NOT NULL,
    mgrip character varying(16),
    devtype integer,
    vendor character varying(64),
    model character varying(64),
    checktime character varying(20) NOT NULL,
    log text
);


ALTER TABLE public.discover_missdevice OWNER TO postgres;

--
-- TOC entry 1662 (class 1259 OID 91085)
-- Dependencies: 5
-- Name: discover_missdevice_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE discover_missdevice_id_seq
    START WITH 5
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.discover_missdevice_id_seq OWNER TO postgres;

--
-- TOC entry 2662 (class 0 OID 0)
-- Dependencies: 1662
-- Name: discover_missdevice_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('discover_missdevice_id_seq', 5, false);


--
-- TOC entry 1667 (class 1259 OID 91095)
-- Dependencies: 1668 5
-- Name: discover_missdevice_id_seq1; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE discover_missdevice_id_seq1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.discover_missdevice_id_seq1 OWNER TO postgres;

--
-- TOC entry 2663 (class 0 OID 0)
-- Dependencies: 1667
-- Name: discover_missdevice_id_seq1; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE discover_missdevice_id_seq1 OWNED BY discover_missdevice.id;


--
-- TOC entry 2664 (class 0 OID 0)
-- Dependencies: 1667
-- Name: discover_missdevice_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('discover_missdevice_id_seq1', 1, true);


--
-- TOC entry 1670 (class 1259 OID 91109)
-- Dependencies: 5
-- Name: discover_newdevice; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE discover_newdevice (
    id integer NOT NULL,
    hostname character varying(255) NOT NULL,
    mgrip character varying(16),
    devtype integer,
    vendor character varying(64),
    model character varying(64),
    findtime character varying(20) NOT NULL,
    log text
);


ALTER TABLE public.discover_newdevice OWNER TO postgres;

--
-- TOC entry 1663 (class 1259 OID 91087)
-- Dependencies: 5
-- Name: discover_newdevice_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE discover_newdevice_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.discover_newdevice_id_seq OWNER TO postgres;

--
-- TOC entry 2665 (class 0 OID 0)
-- Dependencies: 1663
-- Name: discover_newdevice_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('discover_newdevice_id_seq', 1, false);


--
-- TOC entry 1669 (class 1259 OID 91107)
-- Dependencies: 5 1670
-- Name: discover_newdevice_id_seq1; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE discover_newdevice_id_seq1
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.discover_newdevice_id_seq1 OWNER TO postgres;

--
-- TOC entry 2666 (class 0 OID 0)
-- Dependencies: 1669
-- Name: discover_newdevice_id_seq1; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE discover_newdevice_id_seq1 OWNED BY discover_newdevice.id;


--
-- TOC entry 2667 (class 0 OID 0)
-- Dependencies: 1669
-- Name: discover_newdevice_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('discover_newdevice_id_seq1', 1, false);


--
-- TOC entry 1672 (class 1259 OID 91121)
-- Dependencies: 2176 2177 2178 5
-- Name: discover_schedule; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE discover_schedule (
    id integer NOT NULL,
    doesuseautotask integer DEFAULT 0 NOT NULL,
    autotasktype integer DEFAULT 3 NOT NULL,
    days integer,
    weekday integer,
    monthday integer,
    useid integer,
    excutetime timestamp without time zone NOT NULL,
    isrunning integer DEFAULT 0,
    starttime timestamp without time zone
);


ALTER TABLE public.discover_schedule OWNER TO postgres;

--
-- TOC entry 1664 (class 1259 OID 91089)
-- Dependencies: 5
-- Name: discover_schedule_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE discover_schedule_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.discover_schedule_id_seq OWNER TO postgres;

--
-- TOC entry 2668 (class 0 OID 0)
-- Dependencies: 1664
-- Name: discover_schedule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('discover_schedule_id_seq', 1, false);


--
-- TOC entry 1671 (class 1259 OID 91119)
-- Dependencies: 1672 5
-- Name: discover_schedule_id_seq1; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE discover_schedule_id_seq1
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.discover_schedule_id_seq1 OWNER TO postgres;

--
-- TOC entry 2669 (class 0 OID 0)
-- Dependencies: 1671
-- Name: discover_schedule_id_seq1; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE discover_schedule_id_seq1 OWNED BY discover_schedule.id;


--
-- TOC entry 2670 (class 0 OID 0)
-- Dependencies: 1671
-- Name: discover_schedule_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('discover_schedule_id_seq1', 1, false);


--
-- TOC entry 1674 (class 1259 OID 91131)
-- Dependencies: 5
-- Name: discover_snmpdevice; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE discover_snmpdevice (
    id integer NOT NULL,
    hostname character varying(255) NOT NULL,
    mgrip character varying(16),
    snmpro character varying(64),
    devtype integer,
    vendor character varying(64),
    model character varying(64),
    findtime character varying(20) NOT NULL,
    log text
);


ALTER TABLE public.discover_snmpdevice OWNER TO postgres;

--
-- TOC entry 1665 (class 1259 OID 91091)
-- Dependencies: 5
-- Name: discover_snmpdevice_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE discover_snmpdevice_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.discover_snmpdevice_id_seq OWNER TO postgres;

--
-- TOC entry 2671 (class 0 OID 0)
-- Dependencies: 1665
-- Name: discover_snmpdevice_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('discover_snmpdevice_id_seq', 1, false);


--
-- TOC entry 1673 (class 1259 OID 91129)
-- Dependencies: 5 1674
-- Name: discover_snmpdevice_id_seq1; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE discover_snmpdevice_id_seq1
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.discover_snmpdevice_id_seq1 OWNER TO postgres;

--
-- TOC entry 2672 (class 0 OID 0)
-- Dependencies: 1673
-- Name: discover_snmpdevice_id_seq1; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE discover_snmpdevice_id_seq1 OWNED BY discover_snmpdevice.id;


--
-- TOC entry 2673 (class 0 OID 0)
-- Dependencies: 1673
-- Name: discover_snmpdevice_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('discover_snmpdevice_id_seq1', 1, false);


--
-- TOC entry 1676 (class 1259 OID 91143)
-- Dependencies: 5
-- Name: discover_unknowdevice; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE discover_unknowdevice (
    id integer NOT NULL,
    mgrip character varying(16) NOT NULL,
    snmpro character varying(64),
    devtype integer,
    sysobjectid character varying(128),
    discoverfrom character varying(16),
    findtime character varying(20),
    log text
);


ALTER TABLE public.discover_unknowdevice OWNER TO postgres;

--
-- TOC entry 1666 (class 1259 OID 91093)
-- Dependencies: 5
-- Name: discover_unknowdevice_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE discover_unknowdevice_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.discover_unknowdevice_id_seq OWNER TO postgres;

--
-- TOC entry 2674 (class 0 OID 0)
-- Dependencies: 1666
-- Name: discover_unknowdevice_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('discover_unknowdevice_id_seq', 1, false);


--
-- TOC entry 1675 (class 1259 OID 91141)
-- Dependencies: 5 1676
-- Name: discover_unknowdevice_id_seq1; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE discover_unknowdevice_id_seq1
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.discover_unknowdevice_id_seq1 OWNER TO postgres;

--
-- TOC entry 2675 (class 0 OID 0)
-- Dependencies: 1675
-- Name: discover_unknowdevice_id_seq1; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE discover_unknowdevice_id_seq1 OWNED BY discover_unknowdevice.id;


--
-- TOC entry 2676 (class 0 OID 0)
-- Dependencies: 1675
-- Name: discover_unknowdevice_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('discover_unknowdevice_id_seq1', 1, false);


--
-- TOC entry 1651 (class 1259 OID 90718)
-- Dependencies: 5 1652
-- Name: duplicateip_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE duplicateip_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.duplicateip_id_seq OWNER TO postgres;

--
-- TOC entry 2677 (class 0 OID 0)
-- Dependencies: 1651
-- Name: duplicateip_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE duplicateip_id_seq OWNED BY duplicateip.id;


--
-- TOC entry 2678 (class 0 OID 0)
-- Dependencies: 1651
-- Name: duplicateip_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('duplicateip_id_seq', 1, false);


--
-- TOC entry 1650 (class 1259 OID 90691)
-- Dependencies: 5
-- Name: fixupnatinfo; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE fixupnatinfo (
    id integer NOT NULL,
    deviceid integer NOT NULL,
    ininfid integer NOT NULL,
    outinfid integer,
    insidelocal text,
    insideglobal text,
    outsidelocal text,
    outsideglobal text,
    ipri integer NOT NULL
);


ALTER TABLE public.fixupnatinfo OWNER TO postgres;

--
-- TOC entry 1649 (class 1259 OID 90689)
-- Dependencies: 1650 5
-- Name: fixupnatinfo_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE fixupnatinfo_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.fixupnatinfo_id_seq OWNER TO postgres;

--
-- TOC entry 2679 (class 0 OID 0)
-- Dependencies: 1649
-- Name: fixupnatinfo_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE fixupnatinfo_id_seq OWNED BY fixupnatinfo.id;


--
-- TOC entry 2680 (class 0 OID 0)
-- Dependencies: 1649
-- Name: fixupnatinfo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('fixupnatinfo_id_seq', 1, false);


--
-- TOC entry 1659 (class 1259 OID 90807)
-- Dependencies: 1650 5
-- Name: fixupnatinfo_ipri_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE fixupnatinfo_ipri_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.fixupnatinfo_ipri_seq OWNER TO postgres;

--
-- TOC entry 2681 (class 0 OID 0)
-- Dependencies: 1659
-- Name: fixupnatinfo_ipri_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE fixupnatinfo_ipri_seq OWNED BY fixupnatinfo.ipri;


--
-- TOC entry 2682 (class 0 OID 0)
-- Dependencies: 1659
-- Name: fixupnatinfo_ipri_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('fixupnatinfo_ipri_seq', 1, false);


--
-- TOC entry 1582 (class 1259 OID 88376)
-- Dependencies: 5
-- Name: fixuproutetable; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE fixuproutetable (
    id integer NOT NULL,
    deviceid integer NOT NULL,
    destip integer NOT NULL,
    destmask integer NOT NULL,
    interface character varying(128) NOT NULL,
    nexthopip integer NOT NULL
);


ALTER TABLE public.fixuproutetable OWNER TO postgres;

--
-- TOC entry 1583 (class 1259 OID 88378)
-- Dependencies: 5 1582
-- Name: fixuproutetable_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE fixuproutetable_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.fixuproutetable_id_seq OWNER TO postgres;

--
-- TOC entry 2683 (class 0 OID 0)
-- Dependencies: 1583
-- Name: fixuproutetable_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE fixuproutetable_id_seq OWNED BY fixuproutetable.id;


--
-- TOC entry 2684 (class 0 OID 0)
-- Dependencies: 1583
-- Name: fixuproutetable_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('fixuproutetable_id_seq', 1, false);


--
-- TOC entry 1584 (class 1259 OID 88380)
-- Dependencies: 5
-- Name: fixuproutetablepriority; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE fixuproutetablepriority (
    deviceid integer NOT NULL,
    priority integer,
    id integer NOT NULL
);


ALTER TABLE public.fixuproutetablepriority OWNER TO postgres;

--
-- TOC entry 2685 (class 0 OID 0)
-- Dependencies: 1584
-- Name: COLUMN fixuproutetablepriority.priority; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN fixuproutetablepriority.priority IS '0 is lower then routetable
1 is upper then routetable';


--
-- TOC entry 1585 (class 1259 OID 88382)
-- Dependencies: 5 1584
-- Name: fixuproutetablepriority_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE fixuproutetablepriority_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.fixuproutetablepriority_id_seq OWNER TO postgres;

--
-- TOC entry 2686 (class 0 OID 0)
-- Dependencies: 1585
-- Name: fixuproutetablepriority_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE fixuproutetablepriority_id_seq OWNED BY fixuproutetablepriority.id;


--
-- TOC entry 2687 (class 0 OID 0)
-- Dependencies: 1585
-- Name: fixuproutetablepriority_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('fixuproutetablepriority_id_seq', 1, false);


--
-- TOC entry 1587 (class 1259 OID 88387)
-- Dependencies: 5 1586
-- Name: fixupunnumberedinterface_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE fixupunnumberedinterface_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.fixupunnumberedinterface_id_seq OWNER TO postgres;

--
-- TOC entry 2688 (class 0 OID 0)
-- Dependencies: 1587
-- Name: fixupunnumberedinterface_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE fixupunnumberedinterface_id_seq OWNED BY fixupunnumberedinterface.id;


--
-- TOC entry 2689 (class 0 OID 0)
-- Dependencies: 1587
-- Name: fixupunnumberedinterface_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('fixupunnumberedinterface_id_seq', 1, false);


--
-- TOC entry 1588 (class 1259 OID 88389)
-- Dependencies: 2100 5
-- Name: function; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE function (
    id integer NOT NULL,
    strname text NOT NULL,
    wsver integer DEFAULT -1 NOT NULL,
    description text,
    sidname text NOT NULL
);


ALTER TABLE public.function OWNER TO postgres;

--
-- TOC entry 2690 (class 0 OID 0)
-- Dependencies: 1588
-- Name: COLUMN function.wsver; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN function.wsver IS '1--OE  2--EE -1--all';


--
-- TOC entry 1589 (class 1259 OID 88395)
-- Dependencies: 1588 5
-- Name: function_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE function_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.function_id_seq OWNER TO postgres;

--
-- TOC entry 2691 (class 0 OID 0)
-- Dependencies: 1589
-- Name: function_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE function_id_seq OWNED BY function.id;


--
-- TOC entry 2692 (class 0 OID 0)
-- Dependencies: 1589
-- Name: function_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('function_id_seq', 10, true);


--
-- TOC entry 1591 (class 1259 OID 88407)
-- Dependencies: 5 1590
-- Name: interfacesetting_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE interfacesetting_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.interfacesetting_id_seq OWNER TO postgres;

--
-- TOC entry 2693 (class 0 OID 0)
-- Dependencies: 1591
-- Name: interfacesetting_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE interfacesetting_id_seq OWNED BY interfacesetting.id;


--
-- TOC entry 2694 (class 0 OID 0)
-- Dependencies: 1591
-- Name: interfacesetting_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('interfacesetting_id_seq', 1, true);


--
-- TOC entry 1593 (class 1259 OID 88413)
-- Dependencies: 1592 5
-- Name: ip2mac_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ip2mac_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ip2mac_id_seq OWNER TO postgres;

--
-- TOC entry 2695 (class 0 OID 0)
-- Dependencies: 1593
-- Name: ip2mac_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ip2mac_id_seq OWNED BY ip2mac.id;


--
-- TOC entry 2696 (class 0 OID 0)
-- Dependencies: 1593
-- Name: ip2mac_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('ip2mac_id_seq', 1, true);


--
-- TOC entry 1595 (class 1259 OID 88417)
-- Dependencies: 1594 5
-- Name: ipphone_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ipphone_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ipphone_id_seq OWNER TO postgres;

--
-- TOC entry 2697 (class 0 OID 0)
-- Dependencies: 1595
-- Name: ipphone_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ipphone_id_seq OWNED BY ipphone.id;


--
-- TOC entry 2698 (class 0 OID 0)
-- Dependencies: 1595
-- Name: ipphone_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('ipphone_id_seq', 1, false);


--
-- TOC entry 1655 (class 1259 OID 90756)
-- Dependencies: 5 1656
-- Name: l2connectivity_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE l2connectivity_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.l2connectivity_id_seq OWNER TO postgres;

--
-- TOC entry 2699 (class 0 OID 0)
-- Dependencies: 1655
-- Name: l2connectivity_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE l2connectivity_id_seq OWNED BY l2connectivity.id;


--
-- TOC entry 2700 (class 0 OID 0)
-- Dependencies: 1655
-- Name: l2connectivity_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('l2connectivity_id_seq', 1, true);


--
-- TOC entry 1657 (class 1259 OID 90771)
-- Dependencies: 1658 5
-- Name: l2switchinfo_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE l2switchinfo_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.l2switchinfo_id_seq OWNER TO postgres;

--
-- TOC entry 2701 (class 0 OID 0)
-- Dependencies: 1657
-- Name: l2switchinfo_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE l2switchinfo_id_seq OWNED BY l2switchinfo.id;


--
-- TOC entry 2702 (class 0 OID 0)
-- Dependencies: 1657
-- Name: l2switchinfo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('l2switchinfo_id_seq', 1, false);


--
-- TOC entry 1597 (class 1259 OID 88440)
-- Dependencies: 5 1596
-- Name: l2switchport_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE l2switchport_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.l2switchport_id_seq OWNER TO postgres;

--
-- TOC entry 2703 (class 0 OID 0)
-- Dependencies: 1597
-- Name: l2switchport_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE l2switchport_id_seq OWNED BY l2switchport.id;


--
-- TOC entry 2704 (class 0 OID 0)
-- Dependencies: 1597
-- Name: l2switchport_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('l2switchport_id_seq', 1, true);


--
-- TOC entry 1599 (class 1259 OID 88446)
-- Dependencies: 1598 5
-- Name: l2switchvlan_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE l2switchvlan_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.l2switchvlan_id_seq OWNER TO postgres;

--
-- TOC entry 2705 (class 0 OID 0)
-- Dependencies: 1599
-- Name: l2switchvlan_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE l2switchvlan_id_seq OWNED BY l2switchvlan.id;


--
-- TOC entry 2706 (class 0 OID 0)
-- Dependencies: 1599
-- Name: l2switchvlan_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('l2switchvlan_id_seq', 1, true);


--
-- TOC entry 1601 (class 1259 OID 88451)
-- Dependencies: 5 1600
-- Name: lanswitch_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE lanswitch_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.lanswitch_id_seq OWNER TO postgres;

--
-- TOC entry 2707 (class 0 OID 0)
-- Dependencies: 1601
-- Name: lanswitch_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE lanswitch_id_seq OWNED BY lanswitch.id;


--
-- TOC entry 2708 (class 0 OID 0)
-- Dependencies: 1601
-- Name: lanswitch_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('lanswitch_id_seq', 1, false);


--
-- TOC entry 1602 (class 1259 OID 88453)
-- Dependencies: 5
-- Name: livesetting_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE livesetting_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.livesetting_id_seq OWNER TO postgres;

--
-- TOC entry 2709 (class 0 OID 0)
-- Dependencies: 1602
-- Name: livesetting_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('livesetting_id_seq', 1, true);


--
-- TOC entry 1603 (class 1259 OID 88455)
-- Dependencies: 5
-- Name: nap_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE nap_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.nap_id_seq OWNER TO postgres;

--
-- TOC entry 2710 (class 0 OID 0)
-- Dependencies: 1603
-- Name: nap_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('nap_id_seq', 1, true);


--
-- TOC entry 1604 (class 1259 OID 88457)
-- Dependencies: 5
-- Name: napdevice_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE napdevice_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.napdevice_id_seq OWNER TO postgres;

--
-- TOC entry 2711 (class 0 OID 0)
-- Dependencies: 1604
-- Name: napdevice_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('napdevice_id_seq', 1, true);


--
-- TOC entry 1644 (class 1259 OID 90609)
-- Dependencies: 2150 5
-- Name: nat; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE nat (
    id integer NOT NULL,
    deviceid integer NOT NULL,
    insidelocal text NOT NULL,
    insideglobal text NOT NULL,
    outsidelocal text NOT NULL,
    outsideglobal text NOT NULL,
    itype integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.nat OWNER TO postgres;

--
-- TOC entry 2712 (class 0 OID 0)
-- Dependencies: 1644
-- Name: COLUMN nat.itype; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN nat.itype IS '1-static 2-dynamic';


--
-- TOC entry 1643 (class 1259 OID 90607)
-- Dependencies: 1644 5
-- Name: nat_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE nat_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.nat_id_seq OWNER TO postgres;

--
-- TOC entry 2713 (class 0 OID 0)
-- Dependencies: 1643
-- Name: nat_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE nat_id_seq OWNED BY nat.id;


--
-- TOC entry 2714 (class 0 OID 0)
-- Dependencies: 1643
-- Name: nat_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('nat_id_seq', 1, false);


--
-- TOC entry 1646 (class 1259 OID 90626)
-- Dependencies: 5
-- Name: natinterface; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE natinterface (
    id integer NOT NULL,
    deviceid integer,
    inintfid integer,
    outintfid integer
);


ALTER TABLE public.natinterface OWNER TO postgres;

--
-- TOC entry 1645 (class 1259 OID 90624)
-- Dependencies: 1646 5
-- Name: natinterface_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE natinterface_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.natinterface_id_seq OWNER TO postgres;

--
-- TOC entry 2715 (class 0 OID 0)
-- Dependencies: 1645
-- Name: natinterface_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE natinterface_id_seq OWNED BY natinterface.id;


--
-- TOC entry 2716 (class 0 OID 0)
-- Dependencies: 1645
-- Name: natinterface_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('natinterface_id_seq', 1, false);


--
-- TOC entry 1648 (class 1259 OID 90651)
-- Dependencies: 5
-- Name: nattointf; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE nattointf (
    id integer NOT NULL,
    natid integer,
    natintfid integer
);


ALTER TABLE public.nattointf OWNER TO postgres;

--
-- TOC entry 1647 (class 1259 OID 90649)
-- Dependencies: 1648 5
-- Name: nattointf_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE nattointf_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.nattointf_id_seq OWNER TO postgres;

--
-- TOC entry 2717 (class 0 OID 0)
-- Dependencies: 1647
-- Name: nattointf_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE nattointf_id_seq OWNED BY nattointf.id;


--
-- TOC entry 2718 (class 0 OID 0)
-- Dependencies: 1647
-- Name: nattointf_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('nattointf_id_seq', 1, false);


--
-- TOC entry 1606 (class 1259 OID 88464)
-- Dependencies: 5 1605
-- Name: nomp_appliance_ipri_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE nomp_appliance_ipri_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.nomp_appliance_ipri_seq OWNER TO postgres;

--
-- TOC entry 2719 (class 0 OID 0)
-- Dependencies: 1606
-- Name: nomp_appliance_ipri_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE nomp_appliance_ipri_seq OWNED BY nomp_appliance.ipri;


--
-- TOC entry 2720 (class 0 OID 0)
-- Dependencies: 1606
-- Name: nomp_appliance_ipri_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('nomp_appliance_ipri_seq', 1, true);


--
-- TOC entry 1609 (class 1259 OID 88471)
-- Dependencies: 5 1608
-- Name: nomp_enablepasswd_ipri_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE nomp_enablepasswd_ipri_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.nomp_enablepasswd_ipri_seq OWNER TO postgres;

--
-- TOC entry 2721 (class 0 OID 0)
-- Dependencies: 1609
-- Name: nomp_enablepasswd_ipri_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE nomp_enablepasswd_ipri_seq OWNED BY nomp_enablepasswd.ipri;


--
-- TOC entry 2722 (class 0 OID 0)
-- Dependencies: 1609
-- Name: nomp_enablepasswd_ipri_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('nomp_enablepasswd_ipri_seq', 1, true);


--
-- TOC entry 1612 (class 1259 OID 88478)
-- Dependencies: 1611 5
-- Name: nomp_jumpbox_ipri_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE nomp_jumpbox_ipri_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.nomp_jumpbox_ipri_seq OWNER TO postgres;

--
-- TOC entry 2723 (class 0 OID 0)
-- Dependencies: 1612
-- Name: nomp_jumpbox_ipri_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE nomp_jumpbox_ipri_seq OWNED BY nomp_jumpbox.ipri;


--
-- TOC entry 2724 (class 0 OID 0)
-- Dependencies: 1612
-- Name: nomp_jumpbox_ipri_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('nomp_jumpbox_ipri_seq', 1, false);


--
-- TOC entry 1615 (class 1259 OID 88485)
-- Dependencies: 1614 5
-- Name: nomp_snmproinfo_ipri_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE nomp_snmproinfo_ipri_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.nomp_snmproinfo_ipri_seq OWNER TO postgres;

--
-- TOC entry 2725 (class 0 OID 0)
-- Dependencies: 1615
-- Name: nomp_snmproinfo_ipri_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE nomp_snmproinfo_ipri_seq OWNED BY nomp_snmproinfo.ipri;


--
-- TOC entry 2726 (class 0 OID 0)
-- Dependencies: 1615
-- Name: nomp_snmproinfo_ipri_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('nomp_snmproinfo_ipri_seq', 1, true);


--
-- TOC entry 1616 (class 1259 OID 88487)
-- Dependencies: 5
-- Name: nomp_snmprwinfo_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE nomp_snmprwinfo_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.nomp_snmprwinfo_id_seq OWNER TO postgres;

--
-- TOC entry 2727 (class 0 OID 0)
-- Dependencies: 1616
-- Name: nomp_snmprwinfo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('nomp_snmprwinfo_id_seq', 1, false);


--
-- TOC entry 1617 (class 1259 OID 88489)
-- Dependencies: 2132 5
-- Name: nomp_snmprwinfo; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE nomp_snmprwinfo (
    id integer DEFAULT nextval('nomp_snmprwinfo_id_seq'::regclass) NOT NULL,
    strrwstring character varying(32) NOT NULL,
    bmodified integer,
    ipri integer NOT NULL
);


ALTER TABLE public.nomp_snmprwinfo OWNER TO postgres;

--
-- TOC entry 1618 (class 1259 OID 88492)
-- Dependencies: 5 1617
-- Name: nomp_snmprwinfo_ipri_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE nomp_snmprwinfo_ipri_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.nomp_snmprwinfo_ipri_seq OWNER TO postgres;

--
-- TOC entry 2728 (class 0 OID 0)
-- Dependencies: 1618
-- Name: nomp_snmprwinfo_ipri_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE nomp_snmprwinfo_ipri_seq OWNED BY nomp_snmprwinfo.ipri;


--
-- TOC entry 2729 (class 0 OID 0)
-- Dependencies: 1618
-- Name: nomp_snmprwinfo_ipri_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('nomp_snmprwinfo_ipri_seq', 1, false);


--
-- TOC entry 1621 (class 1259 OID 88499)
-- Dependencies: 5 1620
-- Name: nomp_telnetinfo_ipri_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE nomp_telnetinfo_ipri_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.nomp_telnetinfo_ipri_seq OWNER TO postgres;

--
-- TOC entry 2730 (class 0 OID 0)
-- Dependencies: 1621
-- Name: nomp_telnetinfo_ipri_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE nomp_telnetinfo_ipri_seq OWNED BY nomp_telnetinfo.ipri;


--
-- TOC entry 2731 (class 0 OID 0)
-- Dependencies: 1621
-- Name: nomp_telnetinfo_ipri_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('nomp_telnetinfo_ipri_seq', 1, true);


--
-- TOC entry 1694 (class 1259 OID 120790)
-- Dependencies: 2195 5
-- Name: objtimestamp; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE objtimestamp (
    id integer NOT NULL,
    typename character varying(200) NOT NULL,
    modifytime timestamp without time zone NOT NULL,
    userid integer DEFAULT -1 NOT NULL
);


ALTER TABLE public.objtimestamp OWNER TO postgres;

--
-- TOC entry 1693 (class 1259 OID 120788)
-- Dependencies: 5 1694
-- Name: objtimestamp_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE objtimestamp_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.objtimestamp_id_seq OWNER TO postgres;

--
-- TOC entry 2732 (class 0 OID 0)
-- Dependencies: 1693
-- Name: objtimestamp_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE objtimestamp_id_seq OWNED BY objtimestamp.id;


--
-- TOC entry 2733 (class 0 OID 0)
-- Dependencies: 1693
-- Name: objtimestamp_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('objtimestamp_id_seq', 17, true);


--
-- TOC entry 1622 (class 1259 OID 88501)
-- Dependencies: 5
-- Name: role_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE role_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.role_id_seq OWNER TO postgres;

--
-- TOC entry 2734 (class 0 OID 0)
-- Dependencies: 1622
-- Name: role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('role_id_seq', 4, true);


--
-- TOC entry 1623 (class 1259 OID 88503)
-- Dependencies: 2134 5
-- Name: role; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE role (
    id integer DEFAULT nextval('role_id_seq'::regclass) NOT NULL,
    name text NOT NULL,
    description text
);


ALTER TABLE public.role OWNER TO postgres;

--
-- TOC entry 1642 (class 1259 OID 89615)
-- Dependencies: 5
-- Name: role2function; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE role2function (
    id integer NOT NULL,
    roleid integer NOT NULL,
    functionid integer NOT NULL
);


ALTER TABLE public.role2function OWNER TO postgres;

--
-- TOC entry 1641 (class 1259 OID 89613)
-- Dependencies: 5 1642
-- Name: role2function_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE role2function_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.role2function_id_seq OWNER TO postgres;

--
-- TOC entry 2735 (class 0 OID 0)
-- Dependencies: 1641
-- Name: role2function_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE role2function_id_seq OWNED BY role2function.id;


--
-- TOC entry 2736 (class 0 OID 0)
-- Dependencies: 1641
-- Name: role2function_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('role2function_id_seq', 23, true);


--
-- TOC entry 1624 (class 1259 OID 88511)
-- Dependencies: 5
-- Name: seq_userid; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE seq_userid
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.seq_userid OWNER TO postgres;

--
-- TOC entry 2737 (class 0 OID 0)
-- Dependencies: 1624
-- Name: seq_userid; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('seq_userid', 3, true);


--
-- TOC entry 1626 (class 1259 OID 88515)
-- Dependencies: 1625 5
-- Name: switchgroup_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE switchgroup_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.switchgroup_id_seq OWNER TO postgres;

--
-- TOC entry 2738 (class 0 OID 0)
-- Dependencies: 1626
-- Name: switchgroup_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE switchgroup_id_seq OWNED BY switchgroup.id;


--
-- TOC entry 2739 (class 0 OID 0)
-- Dependencies: 1626
-- Name: switchgroup_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('switchgroup_id_seq', 3, true);


--
-- TOC entry 1628 (class 1259 OID 88519)
-- Dependencies: 1627 5
-- Name: swtichgroupdevice_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE swtichgroupdevice_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.swtichgroupdevice_id_seq OWNER TO postgres;

--
-- TOC entry 2740 (class 0 OID 0)
-- Dependencies: 1628
-- Name: swtichgroupdevice_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE swtichgroupdevice_id_seq OWNED BY swtichgroupdevice.id;


--
-- TOC entry 2741 (class 0 OID 0)
-- Dependencies: 1628
-- Name: swtichgroupdevice_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('swtichgroupdevice_id_seq', 1, true);


--
-- TOC entry 1629 (class 1259 OID 88521)
-- Dependencies: 5
-- Name: system_cmdconfig; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE system_cmdconfig (
    id integer,
    strdevicemodel character varying(32),
    strcommand character varying(32),
    strregexp character varying(128),
    strsampleoutfile character varying(32),
    bmodified integer
);


ALTER TABLE public.system_cmdconfig OWNER TO postgres;

--
-- TOC entry 1631 (class 1259 OID 88525)
-- Dependencies: 5
-- Name: system_info_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE system_info_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.system_info_id_seq OWNER TO postgres;

--
-- TOC entry 2742 (class 0 OID 0)
-- Dependencies: 1631
-- Name: system_info_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('system_info_id_seq', 2, true);


--
-- TOC entry 1632 (class 1259 OID 88527)
-- Dependencies: 2139 2140 2141 2142 5
-- Name: system_info; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE system_info (
    id integer DEFAULT nextval('system_info_id_seq'::regclass) NOT NULL,
    ver integer NOT NULL,
    itelnetsshtimeout integer DEFAULT 30 NOT NULL,
    isnmptimeout integer DEFAULT 5,
    iroutetablemaxentries integer DEFAULT 10000 NOT NULL
);


ALTER TABLE public.system_info OWNER TO postgres;

--
-- TOC entry 1633 (class 1259 OID 88533)
-- Dependencies: 5
-- Name: system_interfacecfg; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE system_interfacecfg (
    id integer NOT NULL,
    strfullname character varying(64),
    strshortname character varying(16),
    strmibname character varying(16),
    ibandwidth integer,
    idelay integer,
    iospfnetworktype integer,
    bhasmac integer,
    bserialif integer,
    bbroadcastlif integer,
    bwanif integer
);


ALTER TABLE public.system_interfacecfg OWNER TO postgres;

--
-- TOC entry 1681 (class 1259 OID 92188)
-- Dependencies: 5 1682
-- Name: systemdevicegroup_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE systemdevicegroup_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.systemdevicegroup_id_seq OWNER TO postgres;

--
-- TOC entry 2743 (class 0 OID 0)
-- Dependencies: 1681
-- Name: systemdevicegroup_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE systemdevicegroup_id_seq OWNED BY systemdevicegroup.id;


--
-- TOC entry 2744 (class 0 OID 0)
-- Dependencies: 1681
-- Name: systemdevicegroup_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('systemdevicegroup_id_seq', 1, false);


--
-- TOC entry 1683 (class 1259 OID 92201)
-- Dependencies: 1684 5
-- Name: systemdevicegroupdevice_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE systemdevicegroupdevice_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.systemdevicegroupdevice_id_seq OWNER TO postgres;

--
-- TOC entry 2745 (class 0 OID 0)
-- Dependencies: 1683
-- Name: systemdevicegroupdevice_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE systemdevicegroupdevice_id_seq OWNED BY systemdevicegroupdevice.id;


--
-- TOC entry 2746 (class 0 OID 0)
-- Dependencies: 1683
-- Name: systemdevicegroupdevice_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('systemdevicegroupdevice_id_seq', 1, false);


--
-- TOC entry 1636 (class 1259 OID 88540)
-- Dependencies: 5
-- Name: unknownip_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE unknownip_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.unknownip_id_seq OWNER TO postgres;

--
-- TOC entry 2747 (class 0 OID 0)
-- Dependencies: 1636
-- Name: unknownip_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('unknownip_id_seq', 1, false);


--
-- TOC entry 1637 (class 1259 OID 88542)
-- Dependencies: 2144 5
-- Name: unknownip; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE unknownip (
    id integer DEFAULT nextval('unknownip_id_seq'::regclass) NOT NULL,
    nexthopip character varying(16) NOT NULL,
    edgedevice character varying(64),
    edgeintf character varying(64),
    ipfrom character varying(16) NOT NULL,
    ipmask character varying(16) NOT NULL,
    intfdesc character varying(256),
    findtime character varying(32)
);


ALTER TABLE public.unknownip OWNER TO postgres;

--
-- TOC entry 1638 (class 1259 OID 88545)
-- Dependencies: 2145 2146 5
-- Name: user; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE "user" (
    id integer DEFAULT nextval('seq_userid'::regclass) NOT NULL,
    strname character varying(256) NOT NULL,
    password character varying(256) NOT NULL,
    description text,
    email text,
    telephone text,
    wsver integer NOT NULL,
    can_use_global_telnet boolean DEFAULT false NOT NULL,
    validtime time without time zone,
    validdate timestamp without time zone
);


ALTER TABLE public."user" OWNER TO postgres;

--
-- TOC entry 2748 (class 0 OID 0)
-- Dependencies: 1638
-- Name: COLUMN "user".wsver; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN "user".wsver IS '0--OE 1--EE';


--
-- TOC entry 1639 (class 1259 OID 88551)
-- Dependencies: 5
-- Name: user2role; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE user2role (
    userid integer NOT NULL,
    roleid integer NOT NULL,
    id integer NOT NULL
);


ALTER TABLE public.user2role OWNER TO postgres;

--
-- TOC entry 1640 (class 1259 OID 88553)
-- Dependencies: 5 1639
-- Name: user2role_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE user2role_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.user2role_id_seq OWNER TO postgres;

--
-- TOC entry 2749 (class 0 OID 0)
-- Dependencies: 1640
-- Name: user2role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE user2role_id_seq OWNED BY user2role.id;


--
-- TOC entry 2750 (class 0 OID 0)
-- Dependencies: 1640
-- Name: user2role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('user2role_id_seq', 5, true);


--
-- TOC entry 1707 (class 1259 OID 121217)
-- Dependencies: 5 1708
-- Name: userdevicesetting_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE userdevicesetting_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.userdevicesetting_id_seq OWNER TO postgres;

--
-- TOC entry 2751 (class 0 OID 0)
-- Dependencies: 1707
-- Name: userdevicesetting_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE userdevicesetting_id_seq OWNED BY userdevicesetting.id;


--
-- TOC entry 2752 (class 0 OID 0)
-- Dependencies: 1707
-- Name: userdevicesetting_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('userdevicesetting_id_seq', 1, false);


--
-- TOC entry 1688 (class 1259 OID 92234)
-- Dependencies: 5
-- Name: wanlink; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE wanlink (
    id integer NOT NULL,
    wanid integer NOT NULL,
    inf1id integer NOT NULL,
    inf2id integer NOT NULL,
    flag integer
);


ALTER TABLE public.wanlink OWNER TO postgres;

--
-- TOC entry 1687 (class 1259 OID 92232)
-- Dependencies: 1688 5
-- Name: wanlink_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE wanlink_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.wanlink_id_seq OWNER TO postgres;

--
-- TOC entry 2753 (class 0 OID 0)
-- Dependencies: 1687
-- Name: wanlink_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE wanlink_id_seq OWNED BY wanlink.id;


--
-- TOC entry 2754 (class 0 OID 0)
-- Dependencies: 1687
-- Name: wanlink_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('wanlink_id_seq', 1, false);


--
-- TOC entry 1686 (class 1259 OID 92223)
-- Dependencies: 5
-- Name: wans; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE wans (
    id integer NOT NULL,
    strname text NOT NULL
);


ALTER TABLE public.wans OWNER TO postgres;

--
-- TOC entry 1685 (class 1259 OID 92221)
-- Dependencies: 1686 5
-- Name: wans_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE wans_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.wans_id_seq OWNER TO postgres;

--
-- TOC entry 2755 (class 0 OID 0)
-- Dependencies: 1685
-- Name: wans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE wans_id_seq OWNED BY wans.id;


--
-- TOC entry 2756 (class 0 OID 0)
-- Dependencies: 1685
-- Name: wans_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('wans_id_seq', 1, false);


--
-- TOC entry 2058 (class 2604 OID 88560)
-- Dependencies: 1564 1563
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE adminpwd ALTER COLUMN id SET DEFAULT nextval('adminpwd_id_seq'::regclass);


--
-- TOC entry 2059 (class 2604 OID 88561)
-- Dependencies: 1567 1566
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE benchmarkfolder ALTER COLUMN id SET DEFAULT nextval('benchmarkfolder_id_seq'::regclass);


--
-- TOC entry 2166 (class 2604 OID 90873)
-- Dependencies: 1660 1661 1661
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE benchmarktask ALTER COLUMN id SET DEFAULT nextval('benchmarktask_id_seq'::regclass);


--
-- TOC entry 2199 (class 2604 OID 121333)
-- Dependencies: 1711 1710 1711
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE benchmarktaskstatus ALTER COLUMN id SET DEFAULT nextval('benchmarktaskstatus_id_seq'::regclass);


--
-- TOC entry 2192 (class 2604 OID 109577)
-- Dependencies: 1691 1690 1691
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE bgpneighbor ALTER COLUMN id SET DEFAULT nextval('bgpneighbor_id_seq'::regclass);


--
-- TOC entry 2061 (class 2604 OID 88563)
-- Dependencies: 1571 1570
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE device_subtype ALTER COLUMN id SET DEFAULT nextval('device_subtype_id_seq'::regclass);


--
-- TOC entry 2063 (class 2604 OID 88564)
-- Dependencies: 1573 1572
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE devicegroup ALTER COLUMN id SET DEFAULT nextval('devicegroup_id_seq'::regclass);


--
-- TOC entry 2065 (class 2604 OID 88565)
-- Dependencies: 1575 1574
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE devicegroupdevice ALTER COLUMN id SET DEFAULT nextval('devicegroupdevice_id_seq'::regclass);


--
-- TOC entry 2181 (class 2604 OID 92158)
-- Dependencies: 1678 1677 1678
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE deviceprotocols ALTER COLUMN id SET DEFAULT nextval('deviceprotocols_id_seq'::regclass);


--
-- TOC entry 2092 (class 2604 OID 88566)
-- Dependencies: 1579 1578
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE devicesetting ALTER COLUMN id SET DEFAULT nextval('devicesetting_id_seq'::regclass);


--
-- TOC entry 2183 (class 2604 OID 92176)
-- Dependencies: 1680 1679 1680
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE devicevpns ALTER COLUMN id SET DEFAULT nextval('devicevpns_id_seq'::regclass);


--
-- TOC entry 2157 (class 2604 OID 90739)
-- Dependencies: 1653 1654 1654
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE disableinterface ALTER COLUMN id SET DEFAULT nextval('disableinterface_id_seq'::regclass);


--
-- TOC entry 2173 (class 2604 OID 91099)
-- Dependencies: 1668 1667 1668
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE discover_missdevice ALTER COLUMN id SET DEFAULT nextval('discover_missdevice_id_seq1'::regclass);


--
-- TOC entry 2174 (class 2604 OID 91111)
-- Dependencies: 1669 1670 1670
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE discover_newdevice ALTER COLUMN id SET DEFAULT nextval('discover_newdevice_id_seq1'::regclass);


--
-- TOC entry 2175 (class 2604 OID 91123)
-- Dependencies: 1672 1671 1672
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE discover_schedule ALTER COLUMN id SET DEFAULT nextval('discover_schedule_id_seq1'::regclass);


--
-- TOC entry 2179 (class 2604 OID 91133)
-- Dependencies: 1674 1673 1674
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE discover_snmpdevice ALTER COLUMN id SET DEFAULT nextval('discover_snmpdevice_id_seq1'::regclass);


--
-- TOC entry 2180 (class 2604 OID 91145)
-- Dependencies: 1676 1675 1676
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE discover_unknowdevice ALTER COLUMN id SET DEFAULT nextval('discover_unknowdevice_id_seq1'::regclass);


--
-- TOC entry 2155 (class 2604 OID 90722)
-- Dependencies: 1651 1652 1652
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE duplicateip ALTER COLUMN id SET DEFAULT nextval('duplicateip_id_seq'::regclass);


--
-- TOC entry 2153 (class 2604 OID 90693)
-- Dependencies: 1649 1650 1650
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE fixupnatinfo ALTER COLUMN id SET DEFAULT nextval('fixupnatinfo_id_seq'::regclass);


--
-- TOC entry 2154 (class 2604 OID 90809)
-- Dependencies: 1659 1650
-- Name: ipri; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE fixupnatinfo ALTER COLUMN ipri SET DEFAULT nextval('fixupnatinfo_ipri_seq'::regclass);


--
-- TOC entry 2096 (class 2604 OID 88568)
-- Dependencies: 1583 1582
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE fixuproutetable ALTER COLUMN id SET DEFAULT nextval('fixuproutetable_id_seq'::regclass);


--
-- TOC entry 2097 (class 2604 OID 88569)
-- Dependencies: 1585 1584
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE fixuproutetablepriority ALTER COLUMN id SET DEFAULT nextval('fixuproutetablepriority_id_seq'::regclass);


--
-- TOC entry 2099 (class 2604 OID 88570)
-- Dependencies: 1587 1586
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE fixupunnumberedinterface ALTER COLUMN id SET DEFAULT nextval('fixupunnumberedinterface_id_seq'::regclass);


--
-- TOC entry 2101 (class 2604 OID 88571)
-- Dependencies: 1589 1588
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE function ALTER COLUMN id SET DEFAULT nextval('function_id_seq'::regclass);


--
-- TOC entry 2106 (class 2604 OID 88572)
-- Dependencies: 1591 1590
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE interfacesetting ALTER COLUMN id SET DEFAULT nextval('interfacesetting_id_seq'::regclass);


--
-- TOC entry 2110 (class 2604 OID 88573)
-- Dependencies: 1593 1592
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ip2mac ALTER COLUMN id SET DEFAULT nextval('ip2mac_id_seq'::regclass);


--
-- TOC entry 2111 (class 2604 OID 88574)
-- Dependencies: 1595 1594
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ipphone ALTER COLUMN id SET DEFAULT nextval('ipphone_id_seq'::regclass);


--
-- TOC entry 2159 (class 2604 OID 90760)
-- Dependencies: 1656 1655 1656
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE l2connectivity ALTER COLUMN id SET DEFAULT nextval('l2connectivity_id_seq'::regclass);


--
-- TOC entry 2164 (class 2604 OID 90775)
-- Dependencies: 1658 1657 1658
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE l2switchinfo ALTER COLUMN id SET DEFAULT nextval('l2switchinfo_id_seq'::regclass);


--
-- TOC entry 2118 (class 2604 OID 88577)
-- Dependencies: 1597 1596
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE l2switchport ALTER COLUMN id SET DEFAULT nextval('l2switchport_id_seq'::regclass);


--
-- TOC entry 2121 (class 2604 OID 88578)
-- Dependencies: 1599 1598
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE l2switchvlan ALTER COLUMN id SET DEFAULT nextval('l2switchvlan_id_seq'::regclass);


--
-- TOC entry 2124 (class 2604 OID 88579)
-- Dependencies: 1601 1600
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE lanswitch ALTER COLUMN id SET DEFAULT nextval('lanswitch_id_seq'::regclass);


--
-- TOC entry 2149 (class 2604 OID 90611)
-- Dependencies: 1644 1643 1644
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE nat ALTER COLUMN id SET DEFAULT nextval('nat_id_seq'::regclass);


--
-- TOC entry 2151 (class 2604 OID 90628)
-- Dependencies: 1646 1645 1646
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE natinterface ALTER COLUMN id SET DEFAULT nextval('natinterface_id_seq'::regclass);


--
-- TOC entry 2152 (class 2604 OID 90653)
-- Dependencies: 1648 1647 1648
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE nattointf ALTER COLUMN id SET DEFAULT nextval('nattointf_id_seq'::regclass);


--
-- TOC entry 2194 (class 2604 OID 120792)
-- Dependencies: 1693 1694 1694
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE objtimestamp ALTER COLUMN id SET DEFAULT nextval('objtimestamp_id_seq'::regclass);


--
-- TOC entry 2148 (class 2604 OID 89617)
-- Dependencies: 1641 1642 1642
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE role2function ALTER COLUMN id SET DEFAULT nextval('role2function_id_seq'::regclass);


--
-- TOC entry 2135 (class 2604 OID 88586)
-- Dependencies: 1626 1625
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE switchgroup ALTER COLUMN id SET DEFAULT nextval('switchgroup_id_seq'::regclass);


--
-- TOC entry 2137 (class 2604 OID 88587)
-- Dependencies: 1628 1627
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE swtichgroupdevice ALTER COLUMN id SET DEFAULT nextval('swtichgroupdevice_id_seq'::regclass);


--
-- TOC entry 2185 (class 2604 OID 92192)
-- Dependencies: 1681 1682 1682
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE systemdevicegroup ALTER COLUMN id SET DEFAULT nextval('systemdevicegroup_id_seq'::regclass);


--
-- TOC entry 2188 (class 2604 OID 92205)
-- Dependencies: 1684 1683 1684
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE systemdevicegroupdevice ALTER COLUMN id SET DEFAULT nextval('systemdevicegroupdevice_id_seq'::regclass);


--
-- TOC entry 2147 (class 2604 OID 88588)
-- Dependencies: 1640 1639
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE user2role ALTER COLUMN id SET DEFAULT nextval('user2role_id_seq'::regclass);


--
-- TOC entry 2196 (class 2604 OID 121221)
-- Dependencies: 1707 1708 1708
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE userdevicesetting ALTER COLUMN id SET DEFAULT nextval('userdevicesetting_id_seq'::regclass);


--
-- TOC entry 2191 (class 2604 OID 92236)
-- Dependencies: 1688 1687 1688
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE wanlink ALTER COLUMN id SET DEFAULT nextval('wanlink_id_seq'::regclass);


--
-- TOC entry 2190 (class 2604 OID 92225)
-- Dependencies: 1685 1686 1686
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE wans ALTER COLUMN id SET DEFAULT nextval('wans_id_seq'::regclass);


--
-- TOC entry 2558 (class 0 OID 88291)
-- Dependencies: 1563
-- Data for Name: adminpwd; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY adminpwd (id, pwd) FROM stdin;
1	21232f297a57a5a743894a0e4a801fc3
\.


--
-- TOC entry 2559 (class 0 OID 88297)
-- Dependencies: 1566
-- Data for Name: benchmarkfolder; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY benchmarkfolder (id, tdstamp) FROM stdin;
\.


--
-- TOC entry 2604 (class 0 OID 90871)
-- Dependencies: 1661
-- Data for Name: benchmarktask; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY benchmarktask (id, itype, strname, creator, createtime, modifytime, imode, startday, starttime, every, iselect, monthday, benable, buildl2, buildl3, lastruntime) FROM stdin;
1	2	BenchmarkTask	admin	2010-01-29 13:38:43.984375	2010-02-03 16:13:35.6875	0	2010-01-01 13:38:43	12:00:00	1	1	0	f	0	0	\N
\.


--
-- TOC entry 2619 (class 0 OID 121331)
-- Dependencies: 1711
-- Data for Name: benchmarktaskstatus; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY benchmarktaskstatus (id, taskid, runbegintime, runendtime, runstatus) FROM stdin;
\.


--
-- TOC entry 2616 (class 0 OID 109575)
-- Dependencies: 1691
-- Data for Name: bgpneighbor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY bgpneighbor (id, deviceid, remoteasnum, neighborip, localasnum, lastmodifytime) FROM stdin;
\.


--
-- TOC entry 2560 (class 0 OID 88307)
-- Dependencies: 1568
-- Data for Name: device_config; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY device_config (deviceid, configfile, dtstamp) FROM stdin;
\.


--
-- TOC entry 2561 (class 0 OID 88312)
-- Dependencies: 1569
-- Data for Name: device_maintype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY device_maintype (maintype, strname) FROM stdin;
\.


--
-- TOC entry 2562 (class 0 OID 88314)
-- Dependencies: 1570
-- Data for Name: device_subtype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY device_subtype (maintype, subtype, subtype_name, is_benchmarkserver_used, is_server_used, id) FROM stdin;
\.


--
-- TOC entry 2563 (class 0 OID 88319)
-- Dependencies: 1572
-- Data for Name: devicegroup; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY devicegroup (id, strname, strdesc, userid, showcolor) FROM stdin;
\.


--
-- TOC entry 2564 (class 0 OID 88324)
-- Dependencies: 1574
-- Data for Name: devicegroupdevice; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY devicegroupdevice (devicegroupid, deviceid, id) FROM stdin;
\.


--
-- TOC entry 2610 (class 0 OID 92156)
-- Dependencies: 1678
-- Data for Name: deviceprotocols; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY deviceprotocols (id, deviceid, protocalname, lastmodifytime) FROM stdin;
\.


--
-- TOC entry 2565 (class 0 OID 88330)
-- Dependencies: 1577
-- Data for Name: devices; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY devices (id, strname, isubtype) FROM stdin;
\.


--
-- TOC entry 2566 (class 0 OID 88333)
-- Dependencies: 1578
-- Data for Name: devicesetting; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY devicesetting (id, deviceid, alias, curversion, usermodifiedflag, subtype, accessmethod, accessability, livestatuas, telnetproxyid, snmpversion, appliceid, smarttelnetmethod, backtelnetmethod, monitormethod, telnetport, sshport, manageip, livehostname, vendor, model, username, userpassword, enablepassword, loginprompt, passwordprompt, nonprivilegeprompt, privilegeprompt, snmpro, snmprw, keyword, proxy, devicemode, lasttimestamp, snmpport, serialnumber, softwareversion, contactor, currentlocation, keepitem1, keepitem2, keepitem3, keepitem4, keepitem5, keepitem6, keepitem7, telnettooltype, telnettoolsession, telnetcommandline, cmdbserverid) FROM stdin;
\.


--
-- TOC entry 2611 (class 0 OID 92174)
-- Dependencies: 1680
-- Data for Name: devicevpns; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY devicevpns (id, deviceid, vpnname, lastmodifytime) FROM stdin;
\.


--
-- TOC entry 2601 (class 0 OID 90737)
-- Dependencies: 1654
-- Data for Name: disableinterface; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY disableinterface (id, interfaceid, flag) FROM stdin;
\.


--
-- TOC entry 2605 (class 0 OID 91097)
-- Dependencies: 1668
-- Data for Name: discover_missdevice; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY discover_missdevice (id, hostname, mgrip, devtype, vendor, model, checktime, log) FROM stdin;
\.


--
-- TOC entry 2606 (class 0 OID 91109)
-- Dependencies: 1670
-- Data for Name: discover_newdevice; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY discover_newdevice (id, hostname, mgrip, devtype, vendor, model, findtime, log) FROM stdin;
\.


--
-- TOC entry 2607 (class 0 OID 91121)
-- Dependencies: 1672
-- Data for Name: discover_schedule; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY discover_schedule (id, doesuseautotask, autotasktype, days, weekday, monthday, useid, excutetime, isrunning, starttime) FROM stdin;
\.


--
-- TOC entry 2608 (class 0 OID 91131)
-- Dependencies: 1674
-- Data for Name: discover_snmpdevice; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY discover_snmpdevice (id, hostname, mgrip, snmpro, devtype, vendor, model, findtime, log) FROM stdin;
\.


--
-- TOC entry 2609 (class 0 OID 91143)
-- Dependencies: 1676
-- Data for Name: discover_unknowdevice; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY discover_unknowdevice (id, mgrip, snmpro, devtype, sysobjectid, discoverfrom, findtime, log) FROM stdin;
\.


--
-- TOC entry 2567 (class 0 OID 88368)
-- Dependencies: 1581
-- Data for Name: donotscan; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY donotscan (id, groupid, subnetmask, scanfrom, snmpro) FROM stdin;
\.


--
-- TOC entry 2600 (class 0 OID 90720)
-- Dependencies: 1652
-- Data for Name: duplicateip; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY duplicateip (id, ipaddr, interfaceid, flag) FROM stdin;
\.


--
-- TOC entry 2599 (class 0 OID 90691)
-- Dependencies: 1650
-- Data for Name: fixupnatinfo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY fixupnatinfo (id, deviceid, ininfid, outinfid, insidelocal, insideglobal, outsidelocal, outsideglobal, ipri) FROM stdin;
\.


--
-- TOC entry 2568 (class 0 OID 88376)
-- Dependencies: 1582
-- Data for Name: fixuproutetable; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY fixuproutetable (id, deviceid, destip, destmask, interface, nexthopip) FROM stdin;
\.


--
-- TOC entry 2569 (class 0 OID 88380)
-- Dependencies: 1584
-- Data for Name: fixuproutetablepriority; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY fixuproutetablepriority (deviceid, priority, id) FROM stdin;
\.


--
-- TOC entry 2570 (class 0 OID 88384)
-- Dependencies: 1586
-- Data for Name: fixupunnumberedinterface; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY fixupunnumberedinterface (id, sourcedevice, sourceport, destdevice, destport, userflag, retrievedate) FROM stdin;
\.


--
-- TOC entry 2571 (class 0 OID 88389)
-- Dependencies: 1588
-- Data for Name: function; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY function (id, strname, wsver, description, sidname) FROM stdin;
2	L2 Topology Management	-1	\N	L2_Topology_Management
3	Live Network Discovery	-1	\N	Live_Network_Discovery
5	Benchmark	-1	\N	Benchmark
8	Topology Stitching Management	-1	\N	Topology_Stitching_Management
9	Traffic Stitching Management	-1	\N	Traffic_Stitching_Management
10	Device Group Management	-1	\N	Device_Group_Management
7	Network Device Management	-1	\N	Configuration_File_Management
6	Public Device Setting Management	-1	\N	Common_Device_Setting_Management
1	Enterprise Server Management	-1	\N	Appliance_Management
\.


--
-- TOC entry 2572 (class 0 OID 88397)
-- Dependencies: 1590
-- Data for Name: interfacesetting; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY interfacesetting (id, deviceid, interfacename, usermodifiedflag, livestatus, mibindex, bandwidth, macaddress, lasttimestamp) FROM stdin;
\.


--
-- TOC entry 2573 (class 0 OID 88409)
-- Dependencies: 1592
-- Data for Name: ip2mac; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY ip2mac (id, alias, lan, gateway, ip, mac, devicename, interfacename, switchname, portname, vlan, userflag, servertype, retrievedate) FROM stdin;
\.


--
-- TOC entry 2574 (class 0 OID 88415)
-- Dependencies: 1594
-- Data for Name: ipphone; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY ipphone (phone_name, ipaddr, macaddr, phone_number, call_manager, switch_name, vendor, model, version, software_version, id, lasttimestamp) FROM stdin;
\.


--
-- TOC entry 2602 (class 0 OID 90758)
-- Dependencies: 1656
-- Data for Name: l2connectivity; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY l2connectivity (id, sourcedevice, sourceport, destdevice, destport, userflag, retrievedate, isrctype, idesttype) FROM stdin;
\.


--
-- TOC entry 2603 (class 0 OID 90773)
-- Dependencies: 1658
-- Data for Name: l2switchinfo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY l2switchinfo (id, devicename, devicealias, managementip, managementmask, switchtype, subtype, isiosswitch, ios_version, snmpro, snmprw, description, nb_timestamp, usermodifed, iproutecmds) FROM stdin;
\.


--
-- TOC entry 2575 (class 0 OID 88429)
-- Dependencies: 1596
-- Data for Name: l2switchport; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY l2switchport (id, switchname, portname, status, speed, duplex, portmode, trunkencapsulation, stpstatus, vlans, description, nb_timestamp, usermodifed, channelgroupmode, channelgroupname, exclude_vlans) FROM stdin;
\.


--
-- TOC entry 2576 (class 0 OID 88442)
-- Dependencies: 1598
-- Data for Name: l2switchvlan; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY l2switchvlan (id, switchname, vlannumber, vlantype, mtu, vlanstatus, switchports, parentvlan, vlanmode, said, description, nb_timestamp, usermodifed) FROM stdin;
\.


--
-- TOC entry 2577 (class 0 OID 88448)
-- Dependencies: 1600
-- Data for Name: lanswitch; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY lanswitch (id, lanname, gateway, switchname, ports, userflag, retrievedate) FROM stdin;
\.


--
-- TOC entry 2596 (class 0 OID 90609)
-- Dependencies: 1644
-- Data for Name: nat; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY nat (id, deviceid, insidelocal, insideglobal, outsidelocal, outsideglobal, itype) FROM stdin;
\.


--
-- TOC entry 2597 (class 0 OID 90626)
-- Dependencies: 1646
-- Data for Name: natinterface; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY natinterface (id, deviceid, inintfid, outintfid) FROM stdin;
\.


--
-- TOC entry 2598 (class 0 OID 90651)
-- Dependencies: 1648
-- Data for Name: nattointf; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY nattointf (id, natid, natintfid) FROM stdin;
\.


--
-- TOC entry 2578 (class 0 OID 88459)
-- Dependencies: 1605
-- Data for Name: nomp_appliance; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY nomp_appliance (id, strhostname, strdescription, stripaddr, iserveport, bhome, blive, bmodified, imaxdevicecount, ibapport, ipri, telnet_user, telnet_pwd) FROM stdin;
0	0a5de35861244af0a7744f73da892b4f	\N	\N	0	0	0	0	1500	7813	1	\N	\N
\.


--
-- TOC entry 2579 (class 0 OID 88468)
-- Dependencies: 1608
-- Data for Name: nomp_enablepasswd; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY nomp_enablepasswd (id, stralias, strenablepasswd, bmodified, ipri) FROM stdin;
\.


--
-- TOC entry 2580 (class 0 OID 88475)
-- Dependencies: 1611
-- Data for Name: nomp_jumpbox; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY nomp_jumpbox (id, strname, itype, stripaddr, iport, imode, strusername, strpasswd, strloginprompt, strpasswdprompt, strcommandprompt, stryesnoprompt, bmodified, strenablecmd, strenablepasswordprompt, strenablepassword, strenableprompt, ipri) FROM stdin;
\.


--
-- TOC entry 2581 (class 0 OID 88482)
-- Dependencies: 1614
-- Data for Name: nomp_snmproinfo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY nomp_snmproinfo (id, strrostring, bmodified, ipri) FROM stdin;
\.


--
-- TOC entry 2582 (class 0 OID 88489)
-- Dependencies: 1617
-- Data for Name: nomp_snmprwinfo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY nomp_snmprwinfo (id, strrwstring, bmodified, ipri) FROM stdin;
\.


--
-- TOC entry 2583 (class 0 OID 88496)
-- Dependencies: 1620
-- Data for Name: nomp_telnetinfo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY nomp_telnetinfo (id, stralias, idevicetype, strusername, strpasswd, bmodified, userid, ipri) FROM stdin;
\.


--
-- TOC entry 2617 (class 0 OID 120790)
-- Dependencies: 1694
-- Data for Name: objtimestamp; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY objtimestamp (id, typename, modifytime, userid) FROM stdin;
1	Topo	1900-01-01 00:00:00	-1
2	PublicDeviceGroup	1900-01-01 00:00:00	-1
4	SystemDeviceGroup	1900-01-01 00:00:00	-1
6	ConfigFile	1900-01-01 00:00:00	-1
7	L2Switch	1900-01-01 00:00:00	-1
8	IpPhone	1900-01-01 00:00:00	-1
9	DuplicateIp	1900-01-01 00:00:00	-1
10	FixupUnnumberInterface	1900-01-01 00:00:00	-1
11	DeviceSetting	1900-01-01 00:00:00	-1
12	InterfaceSetting	1900-01-01 00:00:00	-1
13	NetworkSetting	1900-01-01 00:00:00	-1
15	OneIpTable	1900-01-01 00:00:00	-1
16	L2SwitchConnectivity	1900-01-01 00:00:00	-1
17	L2Domain	1900-01-01 00:00:00	-1
5	SwitchGroup	1900-01-01 00:00:00	-1
14	VendorModel_DeviceSpec	1900-01-01 00:00:00	-1
\.


--
-- TOC entry 2584 (class 0 OID 88503)
-- Dependencies: 1623
-- Data for Name: role; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY role (id, name, description) FROM stdin;
1	Admin	\N
2	PowerUser	\N
4	Engineer	\N
\.


--
-- TOC entry 2595 (class 0 OID 89615)
-- Dependencies: 1642
-- Data for Name: role2function; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY role2function (id, roleid, functionid) FROM stdin;
2	1	1
3	1	2
4	1	3
7	1	5
8	1	6
9	1	7
10	1	8
12	1	9
13	1	10
14	2	2
16	2	5
17	2	6
19	2	7
21	2	8
22	2	9
23	2	10
\.


--
-- TOC entry 2585 (class 0 OID 88513)
-- Dependencies: 1625
-- Data for Name: switchgroup; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY switchgroup (id, strname, description, showcolor) FROM stdin;
\.


--
-- TOC entry 2586 (class 0 OID 88517)
-- Dependencies: 1627
-- Data for Name: swtichgroupdevice; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY swtichgroupdevice (switchgroupid, deviceid, id) FROM stdin;
\.


--
-- TOC entry 2587 (class 0 OID 88521)
-- Dependencies: 1629
-- Data for Name: system_cmdconfig; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY system_cmdconfig (id, strdevicemodel, strcommand, strregexp, strsampleoutfile, bmodified) FROM stdin;
\.


--
-- TOC entry 2588 (class 0 OID 88523)
-- Dependencies: 1630
-- Data for Name: system_devicespec; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY system_devicespec (id, strvendorname, strmodelname, idevicetype, strcpuoid, strmemoid, strshowruncmd, strshowiproutecmd, strshowroutecountcmd, strshowarpcmd, strshowcamcmd, strpage1cmd, strloginprompt, strpasswordprompt, strprivilegeprompt, strnonprivilegeprompt, strconfigprompt, strtoenablecmd, strtoconfigcmd, stryesnoprompt, ipasswordinterval, iflag, bmodified, strshowcdpcmd, strinvalidcommandkey, strquit) FROM stdin;
8	cisco		2001	$9.2.1.56.0	$9.9.48.1.1.1.5.1*100.0/($9.9.48.1.1.1.6.1+$9.9.48.1.1.1.5.1)	show run	show ip route	show ip route summary	show arp	show mac-address-table	terminal length 0	Username:	Password:	#	>	(config)#	enable	config terminal	(yes/no)NULL	0	0	0	show cdp neighbor detail	Incomplete|Unknown|Invalid|Ambiguous	exit
9	F5		2003	$3375.1.1.83.0	$3375.1.1.77.0*100.0/$3375.1.1.78.0															0	0	0			exit
13	Extreme		2023	$1916.1.1.1.28.0		show config					disable clipaging	Username:	Password:	#	>				(yes/no)?	0	0	0		Syntax error	quit
2	cisco		2002	$9.9.109.1.1.1.1.3.1	$9.9.48.1.1.1.5.1*100.0/($9.9.48.1.1.1.6.1+$9.9.48.1.1.1.5.1)	write terminal	show route		show arp	show mac-address-table dynamic	no pager	Username:	Password:	#	>	(config)#	enable	config terminal	(yes/no)NULL	0	0	0	show cdp neighbor detail	?	exit
11	cisco		2009	$9.9.109.1.1.1.1.3.1	$9.9.48.1.1.1.5.1*100.0/($9.9.48.1.1.1.6.1+$9.9.48.1.1.1.5.1)	show run	show route				no terminal pager 0	Username:	Password:	#	>	(config)#	enable	config terminal	(yes/no)NULL	0	0	0		Incomplete|Unknown|Invalid|Ambiguous	exit
5	netscreen		2008	$3224.16.1.4.0	$3224.16.2.1.0*100.0/($3224.16.1.1.0+$3224.16.2.2.0)	get config	get route				set console page 0									0	0	0		^-	
0	Checkpoint		2007	$2620.1.6.7.2.4.0	$2620.1.6.7.1.4.0*100.0/$2620.1.6.7.1.3.0															0	0	0			
3	cisco		2060	$9.9.109.1.1.1.1.5.9	$9.9.48.1.1.1.5.1*100.0/($9.9.48.1.1.1.6.1+$9.9.48.1.1.1.5.1)	show config	show route		show arp	show cam dynamic|show cam static	set length 0	Username:	Password:	> (enable)	>	> (enable)	enable		(yes/no)NULL	300	0	0	show cdp neighbor detail	Unknown command	exit
12	cisco		1025	$9.2.1.56.0	$9.9.48.1.1.1.5.1*100.0/($9.9.48.1.1.1.6.1+$9.9.48.1.1.1.5.1)	show run	show ip route	show ip route summary	show arp	show mac-address-table	terminal length 0	Username:	Password:	#	>	(config)#	enable	config terminal	(yes/no)NULL	0	0	0	show cdp neighbor detail	Incomplete|Unknown|Invalid|Ambiguous	exit
1	cisco		2	$9.2.1.56.0	$9.9.48.1.1.1.5.1*100.0/($9.9.48.1.1.1.6.1+$9.9.48.1.1.1.5.1)	show run	show ip route	show ip route summary	show arp	\N	terminal length 0	Username:	Password:	#	>	(config)#	enable	config terminal	(yes/no)NULL	0	0	0	show cdp neighbor detail	Incomplete|Unknown|Invalid|Ambiguous	exit
15	3Com		3333	$43.45.1.6.1.1.1.2	$43.45.1.6.1.2.1.1.4*100.0/$43.45.1.6.1.2.1.1.2	display cur	display ip rout		display arp	display mac-address		Username:	Password:	>	>	]	su	sys		0	0	0		%	quit
10	Juniper		102			show config|no-more	show route table inet.0|no-more				set cli screen-length 0									0	0	0			
\.


--
-- TOC entry 2589 (class 0 OID 88527)
-- Dependencies: 1632
-- Data for Name: system_info; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY system_info (id, ver, itelnetsshtimeout, isnmptimeout, iroutetablemaxentries) FROM stdin;
1	1	30	5	10000
\.


--
-- TOC entry 2590 (class 0 OID 88533)
-- Dependencies: 1633
-- Data for Name: system_interfacecfg; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY system_interfacecfg (id, strfullname, strshortname, strmibname, ibandwidth, idelay, iospfnetworktype, bhasmac, bserialif, bbroadcastlif, bwanif) FROM stdin;
\.


--
-- TOC entry 2612 (class 0 OID 92190)
-- Dependencies: 1682
-- Data for Name: systemdevicegroup; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY systemdevicegroup (id, strname, strdesc, showcolor, lasttimestamp) FROM stdin;
\.


--
-- TOC entry 2613 (class 0 OID 92203)
-- Dependencies: 1684
-- Data for Name: systemdevicegroupdevice; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY systemdevicegroupdevice (systemdevicegroupid, deviceid, id, lasttimestamp) FROM stdin;
\.


--
-- TOC entry 2592 (class 0 OID 88542)
-- Dependencies: 1637
-- Data for Name: unknownip; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY unknownip (id, nexthopip, edgedevice, edgeintf, ipfrom, ipmask, intfdesc, findtime) FROM stdin;
\.


--
-- TOC entry 2593 (class 0 OID 88545)
-- Dependencies: 1638
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "user" (id, strname, password, description, email, telephone, wsver, can_use_global_telnet, validtime, validdate) FROM stdin;
-1	default	39f88a96c493e2d0b1797ba55d97bf77	\N	\N	\N	0	t	\N	\N
1	admin	21232f297a57a5a743894a0e4a801fc3				0	t	\N	\N
2	system	697beb9e76a832288817ad18212bbf6a	system user			0	t	\N	\N
\.


--
-- TOC entry 2594 (class 0 OID 88551)
-- Dependencies: 1639
-- Data for Name: user2role; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY user2role (userid, roleid, id) FROM stdin;
1	1	4
\.


--
-- TOC entry 2618 (class 0 OID 121219)
-- Dependencies: 1708
-- Data for Name: userdevicesetting; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY userdevicesetting (id, deviceid, userid, managerip, telnetusername, telnetpwd, dtstamp) FROM stdin;
\.


--
-- TOC entry 2615 (class 0 OID 92234)
-- Dependencies: 1688
-- Data for Name: wanlink; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY wanlink (id, wanid, inf1id, inf2id, flag) FROM stdin;
\.


--
-- TOC entry 2614 (class 0 OID 92223)
-- Dependencies: 1686
-- Data for Name: wans; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY wans (id, strname) FROM stdin;
\.


--
-- TOC entry 2201 (class 2606 OID 88591)
-- Dependencies: 1563 1563
-- Name: adminpwd_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY adminpwd
    ADD CONSTRAINT adminpwd_pk PRIMARY KEY (id);


--
-- TOC entry 2203 (class 2606 OID 88593)
-- Dependencies: 1566 1566
-- Name: benchmarkfolder_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY benchmarkfolder
    ADD CONSTRAINT benchmarkfolder_pk PRIMARY KEY (tdstamp);


--
-- TOC entry 2422 (class 2606 OID 90879)
-- Dependencies: 1661 1661
-- Name: benchmarktask_pki; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY benchmarktask
    ADD CONSTRAINT benchmarktask_pki PRIMARY KEY (id);


--
-- TOC entry 2477 (class 2606 OID 109580)
-- Dependencies: 1691 1691
-- Name: bgpneighbor_pk_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY bgpneighbor
    ADD CONSTRAINT bgpneighbor_pk_id PRIMARY KEY (id);


--
-- TOC entry 2479 (class 2606 OID 109582)
-- Dependencies: 1691 1691 1691
-- Name: bgpneighbor_uniq_asnum; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY bgpneighbor
    ADD CONSTRAINT bgpneighbor_uniq_asnum UNIQUE (deviceid, remoteasnum);


--
-- TOC entry 2205 (class 2606 OID 88597)
-- Dependencies: 1568 1568
-- Name: device_config_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY device_config
    ADD CONSTRAINT device_config_pk PRIMARY KEY (deviceid);


--
-- TOC entry 2207 (class 2606 OID 88599)
-- Dependencies: 1569 1569
-- Name: device_maintype_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY device_maintype
    ADD CONSTRAINT device_maintype_pk PRIMARY KEY (maintype);


--
-- TOC entry 2209 (class 2606 OID 88601)
-- Dependencies: 1569 1569
-- Name: device_maintype_uniq_name; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY device_maintype
    ADD CONSTRAINT device_maintype_uniq_name UNIQUE (maintype);


--
-- TOC entry 2211 (class 2606 OID 88603)
-- Dependencies: 1570 1570
-- Name: device_subtype_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY device_subtype
    ADD CONSTRAINT device_subtype_pk PRIMARY KEY (id);


--
-- TOC entry 2213 (class 2606 OID 88605)
-- Dependencies: 1570 1570 1570
-- Name: device_subtype_uniq_miantype_subtype; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY device_subtype
    ADD CONSTRAINT device_subtype_uniq_miantype_subtype UNIQUE (maintype, subtype);


--
-- TOC entry 2215 (class 2606 OID 88607)
-- Dependencies: 1570 1570
-- Name: device_subtype_uniq_name; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY device_subtype
    ADD CONSTRAINT device_subtype_uniq_name UNIQUE (subtype_name);


--
-- TOC entry 2220 (class 2606 OID 88609)
-- Dependencies: 1572 1572
-- Name: devicegroup_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY devicegroup
    ADD CONSTRAINT devicegroup_pk PRIMARY KEY (id);


--
-- TOC entry 2222 (class 2606 OID 88613)
-- Dependencies: 1574 1574
-- Name: devicegroupdevice_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY devicegroupdevice
    ADD CONSTRAINT devicegroupdevice_pk PRIMARY KEY (id);


--
-- TOC entry 2224 (class 2606 OID 88615)
-- Dependencies: 1574 1574 1574
-- Name: devicegroupdevice_unique; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY devicegroupdevice
    ADD CONSTRAINT devicegroupdevice_unique UNIQUE (devicegroupid, deviceid);


--
-- TOC entry 2445 (class 2606 OID 92161)
-- Dependencies: 1678 1678
-- Name: deviceprotocols_pk_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY deviceprotocols
    ADD CONSTRAINT deviceprotocols_pk_id PRIMARY KEY (id);


--
-- TOC entry 2447 (class 2606 OID 92163)
-- Dependencies: 1678 1678 1678
-- Name: deviceprotocols_uniq_protocal; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY deviceprotocols
    ADD CONSTRAINT deviceprotocols_uniq_protocal UNIQUE (deviceid, protocalname);


--
-- TOC entry 2227 (class 2606 OID 88617)
-- Dependencies: 1577 1577
-- Name: devices_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY devices
    ADD CONSTRAINT devices_pk PRIMARY KEY (id);


--
-- TOC entry 2229 (class 2606 OID 123063)
-- Dependencies: 1577 1577
-- Name: devices_un_name; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY devices
    ADD CONSTRAINT devices_un_name UNIQUE (strname);


--
-- TOC entry 2231 (class 2606 OID 88621)
-- Dependencies: 1577 1577 1577
-- Name: devices_un_name_type; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY devices
    ADD CONSTRAINT devices_un_name_type UNIQUE (strname, isubtype);


--
-- TOC entry 2237 (class 2606 OID 88623)
-- Dependencies: 1578 1578
-- Name: devicesetting_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY devicesetting
    ADD CONSTRAINT devicesetting_pk PRIMARY KEY (id);


--
-- TOC entry 2239 (class 2606 OID 88625)
-- Dependencies: 1578 1578
-- Name: devicesetting_un_deviceid; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY devicesetting
    ADD CONSTRAINT devicesetting_un_deviceid UNIQUE (deviceid);


--
-- TOC entry 2450 (class 2606 OID 92179)
-- Dependencies: 1680 1680
-- Name: devicevpns_pk_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY devicevpns
    ADD CONSTRAINT devicevpns_pk_id PRIMARY KEY (id);


--
-- TOC entry 2452 (class 2606 OID 92181)
-- Dependencies: 1680 1680 1680
-- Name: devicevpns_uniq_vpn; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY devicevpns
    ADD CONSTRAINT devicevpns_uniq_vpn UNIQUE (deviceid, vpnname);


--
-- TOC entry 2407 (class 2606 OID 90742)
-- Dependencies: 1654 1654
-- Name: disableinterface_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY disableinterface
    ADD CONSTRAINT disableinterface_pk PRIMARY KEY (id);


--
-- TOC entry 2409 (class 2606 OID 90744)
-- Dependencies: 1654 1654
-- Name: disableinterface_uniq_infid; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY disableinterface
    ADD CONSTRAINT disableinterface_uniq_infid UNIQUE (interfaceid);


--
-- TOC entry 2424 (class 2606 OID 91104)
-- Dependencies: 1668 1668
-- Name: discover_missdevice_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY discover_missdevice
    ADD CONSTRAINT discover_missdevice_pkey PRIMARY KEY (id);


--
-- TOC entry 2426 (class 2606 OID 91106)
-- Dependencies: 1668 1668
-- Name: discover_missdevice_unique; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY discover_missdevice
    ADD CONSTRAINT discover_missdevice_unique UNIQUE (hostname);


--
-- TOC entry 2428 (class 2606 OID 91116)
-- Dependencies: 1670 1670
-- Name: discover_newdevice_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY discover_newdevice
    ADD CONSTRAINT discover_newdevice_pkey PRIMARY KEY (id);


--
-- TOC entry 2430 (class 2606 OID 91118)
-- Dependencies: 1670 1670
-- Name: discover_newdevice_unique; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY discover_newdevice
    ADD CONSTRAINT discover_newdevice_unique UNIQUE (hostname);


--
-- TOC entry 2432 (class 2606 OID 91128)
-- Dependencies: 1672 1672
-- Name: discover_schedule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY discover_schedule
    ADD CONSTRAINT discover_schedule_pkey PRIMARY KEY (id);


--
-- TOC entry 2434 (class 2606 OID 91138)
-- Dependencies: 1674 1674
-- Name: discover_snmpdevice_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY discover_snmpdevice
    ADD CONSTRAINT discover_snmpdevice_pkey PRIMARY KEY (id);


--
-- TOC entry 2436 (class 2606 OID 91140)
-- Dependencies: 1674 1674
-- Name: discover_snmpdevice_unique; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY discover_snmpdevice
    ADD CONSTRAINT discover_snmpdevice_unique UNIQUE (hostname);


--
-- TOC entry 2438 (class 2606 OID 91150)
-- Dependencies: 1676 1676
-- Name: discover_unknowdevice_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY discover_unknowdevice
    ADD CONSTRAINT discover_unknowdevice_pkey PRIMARY KEY (id);


--
-- TOC entry 2440 (class 2606 OID 91152)
-- Dependencies: 1676 1676
-- Name: discover_unknowdevice_unique; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY discover_unknowdevice
    ADD CONSTRAINT discover_unknowdevice_unique UNIQUE (mgrip);


--
-- TOC entry 2242 (class 2606 OID 88627)
-- Dependencies: 1581 1581
-- Name: donotscan_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY donotscan
    ADD CONSTRAINT donotscan_pk PRIMARY KEY (id);


--
-- TOC entry 2244 (class 2606 OID 88629)
-- Dependencies: 1581 1581
-- Name: donotscan_un; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY donotscan
    ADD CONSTRAINT donotscan_un UNIQUE (subnetmask);


--
-- TOC entry 2402 (class 2606 OID 90725)
-- Dependencies: 1652 1652
-- Name: duplicateip_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY duplicateip
    ADD CONSTRAINT duplicateip_pk PRIMARY KEY (id);


--
-- TOC entry 2404 (class 2606 OID 90727)
-- Dependencies: 1652 1652 1652
-- Name: duplicateip_uniq_ip_inf; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY duplicateip
    ADD CONSTRAINT duplicateip_uniq_ip_inf UNIQUE (id, interfaceid);


--
-- TOC entry 2396 (class 2606 OID 90698)
-- Dependencies: 1650 1650
-- Name: fixupnatinfo_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY fixupnatinfo
    ADD CONSTRAINT fixupnatinfo_pk PRIMARY KEY (id);


--
-- TOC entry 2246 (class 2606 OID 88635)
-- Dependencies: 1582 1582
-- Name: fixuproutetable_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY fixuproutetable
    ADD CONSTRAINT fixuproutetable_pk PRIMARY KEY (id);


--
-- TOC entry 2248 (class 2606 OID 88637)
-- Dependencies: 1582 1582 1582 1582 1582 1582
-- Name: fixuproutetable_uniq_item; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY fixuproutetable
    ADD CONSTRAINT fixuproutetable_uniq_item UNIQUE (deviceid, destip, destmask, interface, nexthopip);


--
-- TOC entry 2251 (class 2606 OID 88639)
-- Dependencies: 1584 1584
-- Name: fixuproutetablepriority_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY fixuproutetablepriority
    ADD CONSTRAINT fixuproutetablepriority_pkey PRIMARY KEY (id);


--
-- TOC entry 2253 (class 2606 OID 88641)
-- Dependencies: 1584 1584
-- Name: fixuproutetablepriority_un; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY fixuproutetablepriority
    ADD CONSTRAINT fixuproutetablepriority_un UNIQUE (deviceid);


--
-- TOC entry 2260 (class 2606 OID 88643)
-- Dependencies: 1586 1586
-- Name: fixupunnumberedinterface_pk_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY fixupunnumberedinterface
    ADD CONSTRAINT fixupunnumberedinterface_pk_id PRIMARY KEY (id);


--
-- TOC entry 2262 (class 2606 OID 88645)
-- Dependencies: 1586 1586 1586 1586 1586
-- Name: fixupunnumberedinterface_uniq_connect; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY fixupunnumberedinterface
    ADD CONSTRAINT fixupunnumberedinterface_uniq_connect UNIQUE (sourcedevice, sourceport, destdevice, destport);


--
-- TOC entry 2264 (class 2606 OID 88647)
-- Dependencies: 1588 1588
-- Name: function_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY function
    ADD CONSTRAINT function_pkey PRIMARY KEY (id);


--
-- TOC entry 2271 (class 2606 OID 88649)
-- Dependencies: 1590 1590
-- Name: interfacesetting_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY interfacesetting
    ADD CONSTRAINT interfacesetting_pkey PRIMARY KEY (id);


--
-- TOC entry 2273 (class 2606 OID 88651)
-- Dependencies: 1590 1590 1590
-- Name: interfacesetting_un; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY interfacesetting
    ADD CONSTRAINT interfacesetting_un UNIQUE (deviceid, interfacename);


--
-- TOC entry 2280 (class 2606 OID 88653)
-- Dependencies: 1592 1592
-- Name: ip2mac_pk_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ip2mac
    ADD CONSTRAINT ip2mac_pk_id PRIMARY KEY (id);


--
-- TOC entry 2282 (class 2606 OID 88655)
-- Dependencies: 1592 1592 1592
-- Name: ip2mac_uniq_lan; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ip2mac
    ADD CONSTRAINT ip2mac_uniq_lan UNIQUE (ip, mac);


--
-- TOC entry 2284 (class 2606 OID 88657)
-- Dependencies: 1594 1594
-- Name: ipphone_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ipphone
    ADD CONSTRAINT ipphone_pkey PRIMARY KEY (id);


--
-- TOC entry 2286 (class 2606 OID 88659)
-- Dependencies: 1594 1594
-- Name: ipphone_un; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ipphone
    ADD CONSTRAINT ipphone_un UNIQUE (phone_name);


--
-- TOC entry 2417 (class 2606 OID 90765)
-- Dependencies: 1656 1656
-- Name: l2connectivity_pk_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY l2connectivity
    ADD CONSTRAINT l2connectivity_pk_id PRIMARY KEY (id);


--
-- TOC entry 2420 (class 2606 OID 90778)
-- Dependencies: 1658 1658
-- Name: l2switchinfo_pk_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY l2switchinfo
    ADD CONSTRAINT l2switchinfo_pk_id PRIMARY KEY (id);


--
-- TOC entry 2290 (class 2606 OID 88663)
-- Dependencies: 1596 1596
-- Name: l2switchport_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY l2switchport
    ADD CONSTRAINT l2switchport_pk PRIMARY KEY (id);


--
-- TOC entry 2292 (class 2606 OID 88665)
-- Dependencies: 1596 1596 1596
-- Name: l2switchport_un; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY l2switchport
    ADD CONSTRAINT l2switchport_un UNIQUE (switchname, portname);


--
-- TOC entry 2296 (class 2606 OID 88667)
-- Dependencies: 1598 1598
-- Name: l2switchvlan_pk_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY l2switchvlan
    ADD CONSTRAINT l2switchvlan_pk_id PRIMARY KEY (id);


--
-- TOC entry 2298 (class 2606 OID 88669)
-- Dependencies: 1598 1598 1598
-- Name: l2switchvlan_uniq_name; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY l2switchvlan
    ADD CONSTRAINT l2switchvlan_uniq_name UNIQUE (switchname, vlannumber);


--
-- TOC entry 2303 (class 2606 OID 90300)
-- Dependencies: 1600 1600
-- Name: lanswitch_pk_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY lanswitch
    ADD CONSTRAINT lanswitch_pk_id PRIMARY KEY (id);


--
-- TOC entry 2305 (class 2606 OID 90302)
-- Dependencies: 1600 1600 1600
-- Name: lanswitch_uniq_name; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY lanswitch
    ADD CONSTRAINT lanswitch_uniq_name UNIQUE (lanname, switchname);


--
-- TOC entry 2384 (class 2606 OID 90616)
-- Dependencies: 1644 1644
-- Name: nat_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY nat
    ADD CONSTRAINT nat_pk PRIMARY KEY (id);


--
-- TOC entry 2389 (class 2606 OID 90630)
-- Dependencies: 1646 1646
-- Name: natinterface_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY natinterface
    ADD CONSTRAINT natinterface_pkey PRIMARY KEY (id);


--
-- TOC entry 2393 (class 2606 OID 90655)
-- Dependencies: 1648 1648
-- Name: nattointf_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY nattointf
    ADD CONSTRAINT nattointf_pkey PRIMARY KEY (id);


--
-- TOC entry 2307 (class 2606 OID 88673)
-- Dependencies: 1605 1605
-- Name: nomp_appliance_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY nomp_appliance
    ADD CONSTRAINT nomp_appliance_pk PRIMARY KEY (id);


--
-- TOC entry 2309 (class 2606 OID 88675)
-- Dependencies: 1605 1605
-- Name: nomp_appliance_un_houstname; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY nomp_appliance
    ADD CONSTRAINT nomp_appliance_un_houstname UNIQUE (strhostname);


--
-- TOC entry 2311 (class 2606 OID 112639)
-- Dependencies: 1605 1605
-- Name: nomp_appliance_un_ip; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY nomp_appliance
    ADD CONSTRAINT nomp_appliance_un_ip UNIQUE (stripaddr);


--
-- TOC entry 2313 (class 2606 OID 88677)
-- Dependencies: 1608 1608
-- Name: nomp_enablepasswd_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY nomp_enablepasswd
    ADD CONSTRAINT nomp_enablepasswd_pk PRIMARY KEY (id);


--
-- TOC entry 2315 (class 2606 OID 88679)
-- Dependencies: 1608 1608
-- Name: nomp_enablepasswd_un_alias; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY nomp_enablepasswd
    ADD CONSTRAINT nomp_enablepasswd_un_alias UNIQUE (stralias);


--
-- TOC entry 2317 (class 2606 OID 112570)
-- Dependencies: 1608 1608
-- Name: nomp_enablepasswd_uniq_password; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY nomp_enablepasswd
    ADD CONSTRAINT nomp_enablepasswd_uniq_password UNIQUE (strenablepasswd);


--
-- TOC entry 2319 (class 2606 OID 88683)
-- Dependencies: 1611 1611
-- Name: nomp_jumpbox_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY nomp_jumpbox
    ADD CONSTRAINT nomp_jumpbox_pk PRIMARY KEY (id);


--
-- TOC entry 2321 (class 2606 OID 88685)
-- Dependencies: 1611 1611
-- Name: nomp_jumpbox_un_name; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY nomp_jumpbox
    ADD CONSTRAINT nomp_jumpbox_un_name UNIQUE (strname);


--
-- TOC entry 2323 (class 2606 OID 88687)
-- Dependencies: 1611 1611 1611 1611
-- Name: nomp_jumpbox_unique_type_ipaddr_port; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY nomp_jumpbox
    ADD CONSTRAINT nomp_jumpbox_unique_type_ipaddr_port UNIQUE (itype, stripaddr, iport);


--
-- TOC entry 2326 (class 2606 OID 88689)
-- Dependencies: 1614 1614
-- Name: nomp_snmpro_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY nomp_snmproinfo
    ADD CONSTRAINT nomp_snmpro_pkey PRIMARY KEY (id);


--
-- TOC entry 2328 (class 2606 OID 112541)
-- Dependencies: 1614 1614
-- Name: nomp_snmpro_un_rostring; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY nomp_snmproinfo
    ADD CONSTRAINT nomp_snmpro_un_rostring UNIQUE (strrostring);


--
-- TOC entry 2330 (class 2606 OID 88693)
-- Dependencies: 1617 1617
-- Name: nomp_snmprwinfo_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY nomp_snmprwinfo
    ADD CONSTRAINT nomp_snmprwinfo_pk PRIMARY KEY (id);


--
-- TOC entry 2332 (class 2606 OID 88695)
-- Dependencies: 1617 1617
-- Name: nomp_snmprwinfo_un_rwstring; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY nomp_snmprwinfo
    ADD CONSTRAINT nomp_snmprwinfo_un_rwstring UNIQUE (strrwstring);


--
-- TOC entry 2335 (class 2606 OID 88697)
-- Dependencies: 1620 1620
-- Name: nomp_telnetinfo_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY nomp_telnetinfo
    ADD CONSTRAINT nomp_telnetinfo_pk PRIMARY KEY (id);


--
-- TOC entry 2337 (class 2606 OID 88701)
-- Dependencies: 1620 1620 1620
-- Name: nomp_telnetinfo_uniq_item; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY nomp_telnetinfo
    ADD CONSTRAINT nomp_telnetinfo_uniq_item UNIQUE (stralias, userid);


--
-- TOC entry 2491 (class 2606 OID 121335)
-- Dependencies: 1711 1711
-- Name: pk_benchmarktaskstatus_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY benchmarktaskstatus
    ADD CONSTRAINT pk_benchmarktaskstatus_id PRIMARY KEY (id);


--
-- TOC entry 2482 (class 2606 OID 120794)
-- Dependencies: 1694 1694
-- Name: pk_objtimestamp_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY objtimestamp
    ADD CONSTRAINT pk_objtimestamp_id PRIMARY KEY (id);


--
-- TOC entry 2354 (class 2606 OID 88705)
-- Dependencies: 1632 1632
-- Name: pk_system_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY system_info
    ADD CONSTRAINT pk_system_id PRIMARY KEY (id);


--
-- TOC entry 2378 (class 2606 OID 89632)
-- Dependencies: 1642 1642
-- Name: role2function_pk_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY role2function
    ADD CONSTRAINT role2function_pk_id PRIMARY KEY (id);


--
-- TOC entry 2380 (class 2606 OID 89634)
-- Dependencies: 1642 1642 1642
-- Name: role2function_uniq_ids; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY role2function
    ADD CONSTRAINT role2function_uniq_ids UNIQUE (roleid, functionid);


--
-- TOC entry 2340 (class 2606 OID 88709)
-- Dependencies: 1623 1623
-- Name: role_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY role
    ADD CONSTRAINT role_pkey PRIMARY KEY (id);


--
-- TOC entry 2343 (class 2606 OID 88713)
-- Dependencies: 1625 1625
-- Name: switchgroup_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY switchgroup
    ADD CONSTRAINT switchgroup_pk PRIMARY KEY (id);


--
-- TOC entry 2345 (class 2606 OID 88715)
-- Dependencies: 1625 1625
-- Name: switchgroup_un; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY switchgroup
    ADD CONSTRAINT switchgroup_un UNIQUE (strname);


--
-- TOC entry 2348 (class 2606 OID 88717)
-- Dependencies: 1627 1627
-- Name: swtichgroupdevice_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY swtichgroupdevice
    ADD CONSTRAINT swtichgroupdevice_pk PRIMARY KEY (id);


--
-- TOC entry 2350 (class 2606 OID 88719)
-- Dependencies: 1627 1627 1627
-- Name: swtichgroupdevice_un; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY swtichgroupdevice
    ADD CONSTRAINT swtichgroupdevice_un UNIQUE (deviceid, switchgroupid);


--
-- TOC entry 2352 (class 2606 OID 88721)
-- Dependencies: 1630 1630
-- Name: system_devicespec_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY system_devicespec
    ADD CONSTRAINT system_devicespec_pk PRIMARY KEY (id);


--
-- TOC entry 2356 (class 2606 OID 88723)
-- Dependencies: 1633 1633
-- Name: system_interfacecfg_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY system_interfacecfg
    ADD CONSTRAINT system_interfacecfg_pk PRIMARY KEY (id);


--
-- TOC entry 2358 (class 2606 OID 88725)
-- Dependencies: 1635 1635
-- Name: system_vendormodel_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY system_vendormodel
    ADD CONSTRAINT system_vendormodel_pk PRIMARY KEY (id);


--
-- TOC entry 2360 (class 2606 OID 88727)
-- Dependencies: 1635 1635
-- Name: system_vendormodel_un; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY system_vendormodel
    ADD CONSTRAINT system_vendormodel_un UNIQUE (stroid);


--
-- TOC entry 2456 (class 2606 OID 92196)
-- Dependencies: 1682 1682
-- Name: systemdevicegroup_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY systemdevicegroup
    ADD CONSTRAINT systemdevicegroup_pk PRIMARY KEY (id);


--
-- TOC entry 2458 (class 2606 OID 92198)
-- Dependencies: 1682 1682
-- Name: systemdevicegroup_un_name; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY systemdevicegroup
    ADD CONSTRAINT systemdevicegroup_un_name UNIQUE (strname);


--
-- TOC entry 2461 (class 2606 OID 92207)
-- Dependencies: 1684 1684
-- Name: systemdevicegroupdevice_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY systemdevicegroupdevice
    ADD CONSTRAINT systemdevicegroupdevice_pk PRIMARY KEY (id);


--
-- TOC entry 2463 (class 2606 OID 92209)
-- Dependencies: 1684 1684 1684
-- Name: systemdevicegroupdevice_unique; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY systemdevicegroupdevice
    ADD CONSTRAINT systemdevicegroupdevice_unique UNIQUE (systemdevicegroupid, deviceid);


--
-- TOC entry 2362 (class 2606 OID 88729)
-- Dependencies: 1637 1637
-- Name: unknownip_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY unknownip
    ADD CONSTRAINT unknownip_pk PRIMARY KEY (id);


--
-- TOC entry 2364 (class 2606 OID 88731)
-- Dependencies: 1637 1637
-- Name: unknownip_un_nexthopip; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY unknownip
    ADD CONSTRAINT unknownip_un_nexthopip UNIQUE (nexthopip);


--
-- TOC entry 2372 (class 2606 OID 88735)
-- Dependencies: 1639 1639
-- Name: user2role_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY user2role
    ADD CONSTRAINT user2role_pk PRIMARY KEY (id);


--
-- TOC entry 2374 (class 2606 OID 88737)
-- Dependencies: 1639 1639 1639
-- Name: user2role_unique; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY user2role
    ADD CONSTRAINT user2role_unique UNIQUE (userid, roleid);


--
-- TOC entry 2367 (class 2606 OID 88739)
-- Dependencies: 1638 1638
-- Name: user_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT user_pk PRIMARY KEY (id);


--
-- TOC entry 2369 (class 2606 OID 88741)
-- Dependencies: 1638 1638
-- Name: user_un; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT user_un UNIQUE (strname);


--
-- TOC entry 2486 (class 2606 OID 121225)
-- Dependencies: 1708 1708
-- Name: userdevicesetting_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY userdevicesetting
    ADD CONSTRAINT userdevicesetting_pk PRIMARY KEY (id);


--
-- TOC entry 2488 (class 2606 OID 121227)
-- Dependencies: 1708 1708 1708
-- Name: userdevicesetting_unique; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY userdevicesetting
    ADD CONSTRAINT userdevicesetting_unique UNIQUE (userid, deviceid);


--
-- TOC entry 2471 (class 2606 OID 92238)
-- Dependencies: 1688 1688
-- Name: wanlink_pk_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY wanlink
    ADD CONSTRAINT wanlink_pk_id PRIMARY KEY (id);


--
-- TOC entry 2473 (class 2606 OID 92240)
-- Dependencies: 1688 1688 1688 1688
-- Name: wanlink_uniq_wan_infs; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY wanlink
    ADD CONSTRAINT wanlink_uniq_wan_infs UNIQUE (wanid, inf1id, inf2id);


--
-- TOC entry 2466 (class 2606 OID 92230)
-- Dependencies: 1686 1686
-- Name: wans_pk_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY wans
    ADD CONSTRAINT wans_pk_id PRIMARY KEY (id);


--
-- TOC entry 2266 (class 2606 OID 88747)
-- Dependencies: 1588 1588
-- Name: wsfunction_uniq_name_ver; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY function
    ADD CONSTRAINT wsfunction_uniq_name_ver UNIQUE (strname);


--
-- TOC entry 2474 (class 1259 OID 109588)
-- Dependencies: 1691
-- Name: bgpneighbor_idx_deviceid; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX bgpneighbor_idx_deviceid ON bgpneighbor USING btree (deviceid);


--
-- TOC entry 2475 (class 1259 OID 109589)
-- Dependencies: 1691
-- Name: bgpneighbor_idx_remoteas; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX bgpneighbor_idx_remoteas ON bgpneighbor USING btree (remoteasnum);


--
-- TOC entry 2441 (class 1259 OID 92169)
-- Dependencies: 1678
-- Name: devicegroup_idx_protocolname; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX devicegroup_idx_protocolname ON deviceprotocols USING btree (protocalname);


--
-- TOC entry 2216 (class 1259 OID 88748)
-- Dependencies: 1572
-- Name: devicegroup_index_lower_name; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX devicegroup_index_lower_name ON devicegroup USING btree (lower((strname)::text));


--
-- TOC entry 2217 (class 1259 OID 109495)
-- Dependencies: 1572 1572
-- Name: devicegroup_index_name_userid; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX devicegroup_index_name_userid ON devicegroup USING btree (strname, userid);


--
-- TOC entry 2218 (class 1259 OID 88750)
-- Dependencies: 1572
-- Name: devicegroup_index_userid; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX devicegroup_index_userid ON devicegroup USING btree (userid);


--
-- TOC entry 2442 (class 1259 OID 92170)
-- Dependencies: 1678
-- Name: deviceprotocol_idx_deviceid; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX deviceprotocol_idx_deviceid ON deviceprotocols USING btree (deviceid);


--
-- TOC entry 2443 (class 1259 OID 92171)
-- Dependencies: 1678 1678
-- Name: deviceprotocol_idx_timestamp; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX deviceprotocol_idx_timestamp ON deviceprotocols USING btree (deviceid, lastmodifytime);


--
-- TOC entry 2234 (class 1259 OID 88752)
-- Dependencies: 1578
-- Name: devicesetting_idx_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX devicesetting_idx_id ON devicesetting USING btree (id);


--
-- TOC entry 2235 (class 1259 OID 108236)
-- Dependencies: 1578
-- Name: devicesetting_idx_timestamp; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX devicesetting_idx_timestamp ON devicesetting USING btree (lasttimestamp);


--
-- TOC entry 2448 (class 1259 OID 92187)
-- Dependencies: 1680
-- Name: devicevpnname_idx_deviceid; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX devicevpnname_idx_deviceid ON devicevpns USING btree (deviceid);


--
-- TOC entry 2232 (class 1259 OID 88754)
-- Dependencies: 1577
-- Name: devies_index_lower_name; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX devies_index_lower_name ON devices USING btree (lower((strname)::text));


--
-- TOC entry 2233 (class 1259 OID 88755)
-- Dependencies: 1577
-- Name: devies_index_name; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX devies_index_name ON devices USING btree (strname);


--
-- TOC entry 2400 (class 1259 OID 90733)
-- Dependencies: 1652
-- Name: duplicateip_index_ip; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX duplicateip_index_ip ON duplicateip USING btree (ipaddr);


--
-- TOC entry 2394 (class 1259 OID 90714)
-- Dependencies: 1650 1650
-- Name: fixupnatinfo_index_infs; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fixupnatinfo_index_infs ON fixupnatinfo USING btree (ininfid, outinfid);


--
-- TOC entry 2254 (class 1259 OID 88756)
-- Dependencies: 1586
-- Name: fixupunnumberedinterface_idx_destdevice; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fixupunnumberedinterface_idx_destdevice ON fixupunnumberedinterface USING btree (destdevice);


--
-- TOC entry 2255 (class 1259 OID 88757)
-- Dependencies: 1586
-- Name: fixupunnumberedinterface_idx_destport; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fixupunnumberedinterface_idx_destport ON fixupunnumberedinterface USING btree (destport);


--
-- TOC entry 2256 (class 1259 OID 88758)
-- Dependencies: 1586
-- Name: fixupunnumberedinterface_idx_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fixupunnumberedinterface_idx_id ON fixupunnumberedinterface USING btree (id);


--
-- TOC entry 2257 (class 1259 OID 88759)
-- Dependencies: 1586
-- Name: fixupunnumberedinterface_idx_sourcedevice; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fixupunnumberedinterface_idx_sourcedevice ON fixupunnumberedinterface USING btree (sourcedevice);


--
-- TOC entry 2258 (class 1259 OID 88760)
-- Dependencies: 1586
-- Name: fixupunnumberedinterface_idx_sourceport; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fixupunnumberedinterface_idx_sourceport ON fixupunnumberedinterface USING btree (sourceport);


--
-- TOC entry 2225 (class 1259 OID 88761)
-- Dependencies: 1574
-- Name: fki_devicegroupdevice_fk_deviceid; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_devicegroupdevice_fk_deviceid ON devicegroupdevice USING btree (deviceid);


--
-- TOC entry 2240 (class 1259 OID 88762)
-- Dependencies: 1578
-- Name: fki_devicesetting_fk_applicid; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_devicesetting_fk_applicid ON devicesetting USING btree (appliceid);


--
-- TOC entry 2410 (class 1259 OID 90750)
-- Dependencies: 1654
-- Name: fki_disableinterface_fk_infid; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_disableinterface_fk_infid ON disableinterface USING btree (interfaceid);


--
-- TOC entry 2405 (class 1259 OID 90734)
-- Dependencies: 1652
-- Name: fki_duplicateip_fk_infid; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_duplicateip_fk_infid ON duplicateip USING btree (interfaceid);


--
-- TOC entry 2397 (class 1259 OID 90715)
-- Dependencies: 1650
-- Name: fki_fixupnatinfo_fk_deviceid; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_fixupnatinfo_fk_deviceid ON fixupnatinfo USING btree (deviceid);


--
-- TOC entry 2398 (class 1259 OID 90716)
-- Dependencies: 1650
-- Name: fki_fixupnatinfo_fk_ininfid; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_fixupnatinfo_fk_ininfid ON fixupnatinfo USING btree (ininfid);


--
-- TOC entry 2399 (class 1259 OID 90717)
-- Dependencies: 1650
-- Name: fki_fixupnatinfo_fk_outinfid; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_fixupnatinfo_fk_outinfid ON fixupnatinfo USING btree (outinfid);


--
-- TOC entry 2249 (class 1259 OID 88763)
-- Dependencies: 1582
-- Name: fki_fixuproutetable_fk_deviceid; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_fixuproutetable_fk_deviceid ON fixuproutetable USING btree (deviceid);


--
-- TOC entry 2489 (class 1259 OID 121371)
-- Dependencies: 1711
-- Name: fki_fki_ benchmarktaskstatus_taskid; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX "fki_fki_ benchmarktaskstatus_taskid" ON benchmarktaskstatus USING btree (taskid);


--
-- TOC entry 2381 (class 1259 OID 90622)
-- Dependencies: 1644
-- Name: fki_nat_pk_deviceid; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_nat_pk_deviceid ON nat USING btree (deviceid);


--
-- TOC entry 2385 (class 1259 OID 90646)
-- Dependencies: 1646
-- Name: fki_natinterface_fk_ininf; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_natinterface_fk_ininf ON natinterface USING btree (inintfid);


--
-- TOC entry 2386 (class 1259 OID 90647)
-- Dependencies: 1646
-- Name: fki_natinterface_fk_outinfid; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_natinterface_fk_outinfid ON natinterface USING btree (outintfid);


--
-- TOC entry 2390 (class 1259 OID 90666)
-- Dependencies: 1648
-- Name: fki_nattointf; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_nattointf ON nattointf USING btree (natid);


--
-- TOC entry 2391 (class 1259 OID 90667)
-- Dependencies: 1648
-- Name: fki_nattointf_fk_natinfid; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_nattointf_fk_natinfid ON nattointf USING btree (natintfid);


--
-- TOC entry 2480 (class 1259 OID 121267)
-- Dependencies: 1694
-- Name: fki_objtimestamp_userid; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_objtimestamp_userid ON objtimestamp USING btree (userid);


--
-- TOC entry 2375 (class 1259 OID 89630)
-- Dependencies: 1642
-- Name: fki_role2function_fk_functionid; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_role2function_fk_functionid ON role2function USING btree (functionid);


--
-- TOC entry 2274 (class 1259 OID 88765)
-- Dependencies: 1592
-- Name: fki_switchname; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_switchname ON ip2mac USING btree (switchname);


--
-- TOC entry 2346 (class 1259 OID 88766)
-- Dependencies: 1627
-- Name: fki_swtichgroupdevice_fk_deviceid; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_swtichgroupdevice_fk_deviceid ON swtichgroupdevice USING btree (deviceid);


--
-- TOC entry 2459 (class 1259 OID 92220)
-- Dependencies: 1684
-- Name: fki_systemdevicegroupdevice_fk_deviceid; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_systemdevicegroupdevice_fk_deviceid ON systemdevicegroupdevice USING btree (deviceid);


--
-- TOC entry 2370 (class 1259 OID 88767)
-- Dependencies: 1639
-- Name: fki_user2role_fk_roleid; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_user2role_fk_roleid ON user2role USING btree (roleid);


--
-- TOC entry 2483 (class 1259 OID 121238)
-- Dependencies: 1708
-- Name: fki_userdevicesetting_fk_deviceid; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_userdevicesetting_fk_deviceid ON userdevicesetting USING btree (deviceid);


--
-- TOC entry 2467 (class 1259 OID 92256)
-- Dependencies: 1688
-- Name: fki_wanlink_fk_inf2id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_wanlink_fk_inf2id ON wanlink USING btree (inf2id);


--
-- TOC entry 2468 (class 1259 OID 92257)
-- Dependencies: 1688
-- Name: fki_wanlink_fk_wanid; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_wanlink_fk_wanid ON wanlink USING btree (wanid);


--
-- TOC entry 2267 (class 1259 OID 109510)
-- Dependencies: 1590
-- Name: interfacesetting_idx_dev; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX interfacesetting_idx_dev ON interfacesetting USING btree (deviceid);


--
-- TOC entry 2268 (class 1259 OID 109511)
-- Dependencies: 1590 1590
-- Name: interfacesetting_idx_dev_inf; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX interfacesetting_idx_dev_inf ON interfacesetting USING btree (deviceid, interfacename);


--
-- TOC entry 2269 (class 1259 OID 111558)
-- Dependencies: 1590
-- Name: interfacesetting_idx_lower_mac; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX interfacesetting_idx_lower_mac ON interfacesetting USING btree (lower(macaddress));


--
-- TOC entry 2275 (class 1259 OID 88771)
-- Dependencies: 1592
-- Name: ip2mac_idx_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ip2mac_idx_id ON ip2mac USING btree (id);


--
-- TOC entry 2276 (class 1259 OID 88772)
-- Dependencies: 1592
-- Name: ip2mac_idx_lan; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ip2mac_idx_lan ON ip2mac USING btree (lan);


--
-- TOC entry 2277 (class 1259 OID 88773)
-- Dependencies: 1592
-- Name: ip2mac_idx_switchname; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ip2mac_idx_switchname ON ip2mac USING btree (switchname);


--
-- TOC entry 2278 (class 1259 OID 88774)
-- Dependencies: 1592 1592
-- Name: ip2mac_index_ipmac; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ip2mac_index_ipmac ON ip2mac USING btree (ip, mac);


--
-- TOC entry 2411 (class 1259 OID 90766)
-- Dependencies: 1656
-- Name: l2connectivity_idx_destdevice; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX l2connectivity_idx_destdevice ON l2connectivity USING btree (destdevice);


--
-- TOC entry 2412 (class 1259 OID 90767)
-- Dependencies: 1656
-- Name: l2connectivity_idx_destport; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX l2connectivity_idx_destport ON l2connectivity USING btree (destport);


--
-- TOC entry 2413 (class 1259 OID 90768)
-- Dependencies: 1656
-- Name: l2connectivity_idx_sourcedevice; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX l2connectivity_idx_sourcedevice ON l2connectivity USING btree (sourcedevice);


--
-- TOC entry 2414 (class 1259 OID 90769)
-- Dependencies: 1656
-- Name: l2connectivity_idx_sourceport; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX l2connectivity_idx_sourceport ON l2connectivity USING btree (sourceport);


--
-- TOC entry 2415 (class 1259 OID 90770)
-- Dependencies: 1656 1656 1656 1656
-- Name: l2connectivity_index_content; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX l2connectivity_index_content ON l2connectivity USING btree (sourcedevice, sourceport, destdevice, destport);


--
-- TOC entry 2418 (class 1259 OID 90779)
-- Dependencies: 1658
-- Name: l2switchinfo_idx_devicealias; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX l2switchinfo_idx_devicealias ON l2switchinfo USING btree (devicealias);


--
-- TOC entry 2287 (class 1259 OID 109513)
-- Dependencies: 1596
-- Name: l2switchport_idx_dev; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX l2switchport_idx_dev ON l2switchport USING btree (switchname);


--
-- TOC entry 2288 (class 1259 OID 109515)
-- Dependencies: 1596 1596
-- Name: l2switchport_idx_dev_portname; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX l2switchport_idx_dev_portname ON l2switchport USING btree (switchname, portname);


--
-- TOC entry 2293 (class 1259 OID 88782)
-- Dependencies: 1598
-- Name: l2switchvlan_idx_vlannumber; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX l2switchvlan_idx_vlannumber ON l2switchvlan USING btree (vlannumber);


--
-- TOC entry 2294 (class 1259 OID 88783)
-- Dependencies: 1598
-- Name: l2switchvlan_index_devicename; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX l2switchvlan_index_devicename ON l2switchvlan USING btree (switchname);


--
-- TOC entry 2299 (class 1259 OID 88784)
-- Dependencies: 1600
-- Name: lanswitch_idx_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX lanswitch_idx_id ON lanswitch USING btree (id);


--
-- TOC entry 2300 (class 1259 OID 88785)
-- Dependencies: 1600
-- Name: lanswitch_idx_lanname; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX lanswitch_idx_lanname ON lanswitch USING btree (lanname);


--
-- TOC entry 2301 (class 1259 OID 88786)
-- Dependencies: 1600
-- Name: lanswitch_idx_switchname; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX lanswitch_idx_switchname ON lanswitch USING btree (switchname);


--
-- TOC entry 2382 (class 1259 OID 90623)
-- Dependencies: 1644 1644 1644 1644
-- Name: nat_index_na; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX nat_index_na ON nat USING btree (insidelocal, insideglobal, outsidelocal, outsideglobal);


--
-- TOC entry 2387 (class 1259 OID 90648)
-- Dependencies: 1646 1646 1646
-- Name: natinterface_idx_deviceid; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX natinterface_idx_deviceid ON natinterface USING btree (deviceid, inintfid, outintfid);


--
-- TOC entry 2333 (class 1259 OID 88787)
-- Dependencies: 1620
-- Name: nomp_telnetinfo_index_userid; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX nomp_telnetinfo_index_userid ON nomp_telnetinfo USING btree (userid);


--
-- TOC entry 2324 (class 1259 OID 88788)
-- Dependencies: 1611
-- Name: nomp_telnetproxy_index_name; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX nomp_telnetproxy_index_name ON nomp_jumpbox USING btree (strname);


--
-- TOC entry 2376 (class 1259 OID 89635)
-- Dependencies: 1642
-- Name: role2function_index_roleid; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX role2function_index_roleid ON role2function USING btree (roleid);


--
-- TOC entry 2338 (class 1259 OID 88789)
-- Dependencies: 1623
-- Name: role_index_name; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX role_index_name ON "role" USING btree (name);


--
-- TOC entry 2341 (class 1259 OID 88790)
-- Dependencies: 1625
-- Name: switchgroup_index_name; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX switchgroup_index_name ON switchgroup USING btree (strname);


--
-- TOC entry 2453 (class 1259 OID 92199)
-- Dependencies: 1682
-- Name: systemdevicegroup_index_lower_name; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX systemdevicegroup_index_lower_name ON systemdevicegroup USING btree (lower((strname)::text));


--
-- TOC entry 2454 (class 1259 OID 92200)
-- Dependencies: 1682
-- Name: systemdevicegroup_index_name; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX systemdevicegroup_index_name ON systemdevicegroup USING btree (strname);


--
-- TOC entry 2365 (class 1259 OID 88791)
-- Dependencies: 1638
-- Name: user_index_name; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX user_index_name ON "user" USING btree (strname);


--
-- TOC entry 2484 (class 1259 OID 121239)
-- Dependencies: 1708
-- Name: userdevicesetting_index_userid; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX userdevicesetting_index_userid ON userdevicesetting USING btree (userid);


--
-- TOC entry 2469 (class 1259 OID 92258)
-- Dependencies: 1688 1688
-- Name: wanlink_index_infs; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX wanlink_index_infs ON wanlink USING btree (inf1id, inf2id);


--
-- TOC entry 2464 (class 1259 OID 92231)
-- Dependencies: 1686
-- Name: wans_index_name; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX wans_index_name ON wans USING btree (strname);


--
-- TOC entry 2532 (class 2620 OID 88793)
-- Dependencies: 1563 24
-- Name: adminpwd_p; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER adminpwd_p
    BEFORE INSERT OR UPDATE ON adminpwd
    FOR EACH ROW
    EXECUTE PROCEDURE process_adminpwd_p();


--
-- TOC entry 2540 (class 2620 OID 113682)
-- Dependencies: 66 1605
-- Name: appliance_pri; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER appliance_pri
    BEFORE INSERT OR UPDATE ON nomp_appliance
    FOR EACH ROW
    EXECUTE PROCEDURE process_appliance();


--
-- TOC entry 2533 (class 2620 OID 121133)
-- Dependencies: 1572 116
-- Name: devicegroup_dt; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER devicegroup_dt
    BEFORE INSERT OR DELETE OR UPDATE ON devicegroup
    FOR EACH ROW
    EXECUTE PROCEDURE process_devicegroup_dt();


--
-- TOC entry 2534 (class 2620 OID 121178)
-- Dependencies: 1574 124
-- Name: devicegroupdevice_dt; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER devicegroupdevice_dt
    BEFORE INSERT OR DELETE OR UPDATE ON devicegroupdevice
    FOR EACH ROW
    EXECUTE PROCEDURE process_devicegroupdevice_dt();


--
-- TOC entry 2535 (class 2620 OID 121085)
-- Dependencies: 117 1578
-- Name: devicesetting_dt; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER devicesetting_dt
    BEFORE INSERT OR DELETE OR UPDATE ON devicesetting
    FOR EACH ROW
    EXECUTE PROCEDURE process_devicessetting_dt();


--
-- TOC entry 2536 (class 2620 OID 122711)
-- Dependencies: 1581 81
-- Name: donotscan_dt; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER donotscan_dt
    BEFORE INSERT OR DELETE OR UPDATE ON donotscan
    FOR EACH ROW
    EXECUTE PROCEDURE process_donotscan_dt();


--
-- TOC entry 2556 (class 2620 OID 121088)
-- Dependencies: 1652 82
-- Name: duplicateip_dt; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER duplicateip_dt
    BEFORE INSERT OR DELETE OR UPDATE ON duplicateip
    FOR EACH ROW
    EXECUTE PROCEDURE process_duplicateip_dt();


--
-- TOC entry 2542 (class 2620 OID 113681)
-- Dependencies: 1608 65
-- Name: enablepassword_pri; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER enablepassword_pri
    BEFORE INSERT OR UPDATE ON nomp_enablepasswd
    FOR EACH ROW
    EXECUTE PROCEDURE process_enablepasswd();


--
-- TOC entry 2537 (class 2620 OID 121090)
-- Dependencies: 83 1586
-- Name: fixupunnumberedinterface_dt; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER fixupunnumberedinterface_dt
    BEFORE INSERT OR DELETE OR UPDATE ON fixupunnumberedinterface
    FOR EACH ROW
    EXECUTE PROCEDURE process_fixupunnumberedinterface_dt();


--
-- TOC entry 2538 (class 2620 OID 120740)
-- Dependencies: 1592 72
-- Name: ip2mac_userflag; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER ip2mac_userflag
    BEFORE UPDATE ON ip2mac
    FOR EACH ROW
    EXECUTE PROCEDURE process_ip2mac_userflag();


--
-- TOC entry 2539 (class 2620 OID 121098)
-- Dependencies: 80 1594
-- Name: ipphone_dt; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER ipphone_dt
    BEFORE INSERT OR DELETE OR UPDATE ON ipphone
    FOR EACH ROW
    EXECUTE PROCEDURE process_ipphone_dt();


--
-- TOC entry 2544 (class 2620 OID 113680)
-- Dependencies: 64 1611
-- Name: jumpbox_pri; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER jumpbox_pri
    BEFORE INSERT OR UPDATE ON nomp_jumpbox
    FOR EACH ROW
    EXECUTE PROCEDURE process_jumpbox();


--
-- TOC entry 2541 (class 2620 OID 121112)
-- Dependencies: 88 1605
-- Name: nomp_appliance_dt; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER nomp_appliance_dt
    BEFORE INSERT OR DELETE OR UPDATE ON nomp_appliance
    FOR EACH ROW
    EXECUTE PROCEDURE process_nomp_appliance_dt();


--
-- TOC entry 2543 (class 2620 OID 121110)
-- Dependencies: 89 1608
-- Name: nomp_enablepasswd_dt; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER nomp_enablepasswd_dt
    BEFORE INSERT OR DELETE OR UPDATE ON nomp_enablepasswd
    FOR EACH ROW
    EXECUTE PROCEDURE process_nomp_enablepasswd_dt();


--
-- TOC entry 2545 (class 2620 OID 121114)
-- Dependencies: 1611 90
-- Name: nomp_jumpbox_dt; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER nomp_jumpbox_dt
    BEFORE INSERT OR DELETE OR UPDATE ON nomp_jumpbox
    FOR EACH ROW
    EXECUTE PROCEDURE process_nomp_jumpbox_dt();


--
-- TOC entry 2546 (class 2620 OID 121116)
-- Dependencies: 1614 91
-- Name: nomp_snmproinfo_dt; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER nomp_snmproinfo_dt
    BEFORE INSERT OR DELETE OR UPDATE ON nomp_snmproinfo
    FOR EACH ROW
    EXECUTE PROCEDURE process_nomp_snmproinfo_dt();


--
-- TOC entry 2549 (class 2620 OID 121118)
-- Dependencies: 92 1620
-- Name: nomp_telnetinfo_dt; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER nomp_telnetinfo_dt
    BEFORE INSERT OR DELETE OR UPDATE ON nomp_telnetinfo
    FOR EACH ROW
    EXECUTE PROCEDURE process_nomp_telnetinfo_dt();


--
-- TOC entry 2547 (class 2620 OID 113679)
-- Dependencies: 1614 62
-- Name: rostring_pri; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER rostring_pri
    BEFORE INSERT OR UPDATE ON nomp_snmproinfo
    FOR EACH ROW
    EXECUTE PROCEDURE process_snmprostring();


--
-- TOC entry 2548 (class 2620 OID 113678)
-- Dependencies: 1617 63
-- Name: snmprw_pri; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER snmprw_pri
    BEFORE INSERT OR UPDATE ON nomp_snmprwinfo
    FOR EACH ROW
    EXECUTE PROCEDURE process_snmprwstring();


--
-- TOC entry 2551 (class 2620 OID 121120)
-- Dependencies: 93 1625
-- Name: switchgroup_dt; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER switchgroup_dt
    BEFORE INSERT OR DELETE OR UPDATE ON switchgroup
    FOR EACH ROW
    EXECUTE PROCEDURE process_switchgroup_dt();


--
-- TOC entry 2552 (class 2620 OID 121122)
-- Dependencies: 1627 94
-- Name: swtichgroupdevice_dt; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER swtichgroupdevice_dt
    BEFORE INSERT OR DELETE OR UPDATE ON swtichgroupdevice
    FOR EACH ROW
    EXECUTE PROCEDURE process_swtichgroupdevice_dt();


--
-- TOC entry 2553 (class 2620 OID 121124)
-- Dependencies: 95 1630
-- Name: system_devicespec_dt; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER system_devicespec_dt
    BEFORE INSERT OR DELETE OR UPDATE ON system_devicespec
    FOR EACH ROW
    EXECUTE PROCEDURE process_system_devicespec_dt();


--
-- TOC entry 2554 (class 2620 OID 121126)
-- Dependencies: 1635 96
-- Name: system_vendormodel_dt; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER system_vendormodel_dt
    BEFORE INSERT OR DELETE OR UPDATE ON system_vendormodel
    FOR EACH ROW
    EXECUTE PROCEDURE process_system_vendormodel_dt();


--
-- TOC entry 2550 (class 2620 OID 113677)
-- Dependencies: 67 1620
-- Name: telent_pri; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER telent_pri
    BEFORE INSERT OR UPDATE ON nomp_telnetinfo
    FOR EACH ROW
    EXECUTE PROCEDURE process_telnetinfo();


--
-- TOC entry 2557 (class 2620 OID 123055)
-- Dependencies: 1708 145
-- Name: userdevicesetting_dt; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER userdevicesetting_dt
    BEFORE INSERT OR DELETE OR UPDATE ON userdevicesetting
    FOR EACH ROW
    EXECUTE PROCEDURE process_userdevicesetting_dt();


--
-- TOC entry 2555 (class 2620 OID 111525)
-- Dependencies: 1638 50
-- Name: userinfo_p; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER userinfo_p
    BEFORE INSERT OR DELETE OR UPDATE ON "user"
    FOR EACH ROW
    EXECUTE PROCEDURE process_userinfo_p();


--
-- TOC entry 2527 (class 2606 OID 109583)
-- Dependencies: 2226 1577 1691
-- Name: bgpneighbor_deviceid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY bgpneighbor
    ADD CONSTRAINT bgpneighbor_deviceid FOREIGN KEY (deviceid) REFERENCES devices(id) ON DELETE CASCADE;


--
-- TOC entry 2492 (class 2606 OID 88795)
-- Dependencies: 1568 1577 2226
-- Name: device_config_fk_device; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY device_config
    ADD CONSTRAINT device_config_fk_device FOREIGN KEY (deviceid) REFERENCES devices(id) ON DELETE CASCADE;


--
-- TOC entry 2493 (class 2606 OID 88800)
-- Dependencies: 1570 1569 2206
-- Name: device_subtype_fk_maintype; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY device_subtype
    ADD CONSTRAINT device_subtype_fk_maintype FOREIGN KEY (maintype) REFERENCES device_maintype(maintype);


--
-- TOC entry 2494 (class 2606 OID 122562)
-- Dependencies: 2366 1572 1638
-- Name: devicegroup_fk_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY devicegroup
    ADD CONSTRAINT devicegroup_fk_user FOREIGN KEY (userid) REFERENCES "user"(id) ON DELETE CASCADE;


--
-- TOC entry 2495 (class 2606 OID 88810)
-- Dependencies: 1574 2219 1572
-- Name: devicegroupdevice_devicegroupid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY devicegroupdevice
    ADD CONSTRAINT devicegroupdevice_devicegroupid FOREIGN KEY (devicegroupid) REFERENCES devicegroup(id) ON DELETE CASCADE;


--
-- TOC entry 2496 (class 2606 OID 88815)
-- Dependencies: 1574 2226 1577
-- Name: devicegroupdevice_fk_device; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY devicegroupdevice
    ADD CONSTRAINT devicegroupdevice_fk_device FOREIGN KEY (deviceid) REFERENCES devices(id) ON DELETE CASCADE;


--
-- TOC entry 2520 (class 2606 OID 92164)
-- Dependencies: 2226 1678 1577
-- Name: deviceprotocol_deviceid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY deviceprotocols
    ADD CONSTRAINT deviceprotocol_deviceid FOREIGN KEY (deviceid) REFERENCES devices(id) ON DELETE CASCADE;


--
-- TOC entry 2497 (class 2606 OID 88820)
-- Dependencies: 1605 2306 1578
-- Name: devicesetting_fk_applicid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY devicesetting
    ADD CONSTRAINT devicesetting_fk_applicid FOREIGN KEY (appliceid) REFERENCES nomp_appliance(id) ON DELETE SET DEFAULT;


--
-- TOC entry 2498 (class 2606 OID 88825)
-- Dependencies: 2226 1578 1577
-- Name: devicesetting_fk_device; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY devicesetting
    ADD CONSTRAINT devicesetting_fk_device FOREIGN KEY (deviceid) REFERENCES devices(id) ON DELETE CASCADE;


--
-- TOC entry 2521 (class 2606 OID 92182)
-- Dependencies: 2226 1577 1680
-- Name: devicevpnname_deviceid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY devicevpns
    ADD CONSTRAINT devicevpnname_deviceid FOREIGN KEY (deviceid) REFERENCES devices(id) ON DELETE CASCADE;


--
-- TOC entry 2519 (class 2606 OID 90745)
-- Dependencies: 1590 2270 1654
-- Name: disableinterface_fk_infid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY disableinterface
    ADD CONSTRAINT disableinterface_fk_infid FOREIGN KEY (interfaceid) REFERENCES interfacesetting(id) ON DELETE CASCADE;


--
-- TOC entry 2518 (class 2606 OID 90728)
-- Dependencies: 1590 2270 1652
-- Name: duplicateip_fk_infid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY duplicateip
    ADD CONSTRAINT duplicateip_fk_infid FOREIGN KEY (interfaceid) REFERENCES interfacesetting(id) ON DELETE CASCADE;


--
-- TOC entry 2515 (class 2606 OID 108471)
-- Dependencies: 1650 1577 2226
-- Name: fixupnatinfo_fk_deviceid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY fixupnatinfo
    ADD CONSTRAINT fixupnatinfo_fk_deviceid FOREIGN KEY (deviceid) REFERENCES devices(id) ON DELETE CASCADE;


--
-- TOC entry 2516 (class 2606 OID 108476)
-- Dependencies: 1650 1590 2270
-- Name: fixupnatinfo_fk_ininfid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY fixupnatinfo
    ADD CONSTRAINT fixupnatinfo_fk_ininfid FOREIGN KEY (ininfid) REFERENCES interfacesetting(id) ON DELETE CASCADE;


--
-- TOC entry 2517 (class 2606 OID 108481)
-- Dependencies: 1650 1590 2270
-- Name: fixupnatinfo_fk_outinfid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY fixupnatinfo
    ADD CONSTRAINT fixupnatinfo_fk_outinfid FOREIGN KEY (outinfid) REFERENCES interfacesetting(id) ON DELETE CASCADE;


--
-- TOC entry 2499 (class 2606 OID 88835)
-- Dependencies: 1582 2226 1577
-- Name: fixuproutetable_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY fixuproutetable
    ADD CONSTRAINT fixuproutetable_fk FOREIGN KEY (deviceid) REFERENCES devices(id) ON DELETE CASCADE;


--
-- TOC entry 2500 (class 2606 OID 113652)
-- Dependencies: 1577 1584 2226
-- Name: fixuproutetablepriority_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY fixuproutetablepriority
    ADD CONSTRAINT fixuproutetablepriority_fk FOREIGN KEY (deviceid) REFERENCES devices(id) ON DELETE CASCADE;


--
-- TOC entry 2528 (class 2606 OID 121262)
-- Dependencies: 2366 1694 1638
-- Name: fk_objtimestamp_userid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY objtimestamp
    ADD CONSTRAINT fk_objtimestamp_userid FOREIGN KEY (userid) REFERENCES "user"(id) ON DELETE CASCADE;


--
-- TOC entry 2531 (class 2606 OID 121366)
-- Dependencies: 1711 2421 1661
-- Name: fki_ benchmarktaskstatus_taskid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY benchmarktaskstatus
    ADD CONSTRAINT "fki_ benchmarktaskstatus_taskid" FOREIGN KEY (taskid) REFERENCES benchmarktask(id);


--
-- TOC entry 2501 (class 2606 OID 88845)
-- Dependencies: 1577 1590 2226
-- Name: interfacesetting_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY interfacesetting
    ADD CONSTRAINT interfacesetting_fk FOREIGN KEY (deviceid) REFERENCES devices(id) ON DELETE CASCADE;


--
-- TOC entry 2509 (class 2606 OID 90617)
-- Dependencies: 2226 1644 1577
-- Name: nat_pk_deviceid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY nat
    ADD CONSTRAINT nat_pk_deviceid FOREIGN KEY (deviceid) REFERENCES devices(id) ON DELETE CASCADE;


--
-- TOC entry 2510 (class 2606 OID 90631)
-- Dependencies: 2226 1646 1577
-- Name: natinterface_fk_deviceid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY natinterface
    ADD CONSTRAINT natinterface_fk_deviceid FOREIGN KEY (deviceid) REFERENCES devices(id) ON DELETE CASCADE;


--
-- TOC entry 2511 (class 2606 OID 90636)
-- Dependencies: 2270 1646 1590
-- Name: natinterface_fk_ininf; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY natinterface
    ADD CONSTRAINT natinterface_fk_ininf FOREIGN KEY (inintfid) REFERENCES interfacesetting(id) ON DELETE CASCADE;


--
-- TOC entry 2512 (class 2606 OID 90641)
-- Dependencies: 1646 2270 1590
-- Name: natinterface_fk_outinfid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY natinterface
    ADD CONSTRAINT natinterface_fk_outinfid FOREIGN KEY (outintfid) REFERENCES interfacesetting(id) ON DELETE CASCADE;


--
-- TOC entry 2513 (class 2606 OID 90656)
-- Dependencies: 1648 2383 1644
-- Name: nattointf_fk_natid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY nattointf
    ADD CONSTRAINT nattointf_fk_natid FOREIGN KEY (natid) REFERENCES nat(id) ON DELETE CASCADE;


--
-- TOC entry 2514 (class 2606 OID 90661)
-- Dependencies: 1646 1648 2388
-- Name: nattointf_fk_natinfid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY nattointf
    ADD CONSTRAINT nattointf_fk_natinfid FOREIGN KEY (natintfid) REFERENCES natinterface(id) ON DELETE CASCADE;


--
-- TOC entry 2502 (class 2606 OID 88850)
-- Dependencies: 1620 2366 1638
-- Name: nomp_telnetinfo_fk_userid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY nomp_telnetinfo
    ADD CONSTRAINT nomp_telnetinfo_fk_userid FOREIGN KEY (userid) REFERENCES "user"(id) ON DELETE CASCADE DEFERRABLE;


--
-- TOC entry 2507 (class 2606 OID 89620)
-- Dependencies: 2263 1642 1588
-- Name: role2function_fk_functionid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY role2function
    ADD CONSTRAINT role2function_fk_functionid FOREIGN KEY (functionid) REFERENCES "function"(id) ON DELETE CASCADE;


--
-- TOC entry 2508 (class 2606 OID 89625)
-- Dependencies: 2339 1642 1623
-- Name: role2function_pk_roleid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY role2function
    ADD CONSTRAINT role2function_pk_roleid FOREIGN KEY (roleid) REFERENCES "role"(id) ON DELETE CASCADE;


--
-- TOC entry 2503 (class 2606 OID 88865)
-- Dependencies: 1627 1577 2226
-- Name: swtichgroupdevice_fk_device; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY swtichgroupdevice
    ADD CONSTRAINT swtichgroupdevice_fk_device FOREIGN KEY (deviceid) REFERENCES devices(id) ON DELETE CASCADE;


--
-- TOC entry 2504 (class 2606 OID 88870)
-- Dependencies: 1627 2342 1625
-- Name: swtichgroupdevice_fk_switchgroupid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY swtichgroupdevice
    ADD CONSTRAINT swtichgroupdevice_fk_switchgroupid FOREIGN KEY (switchgroupid) REFERENCES switchgroup(id) ON DELETE CASCADE;


--
-- TOC entry 2522 (class 2606 OID 92210)
-- Dependencies: 1577 1684 2226
-- Name: systemdevicegroupdevice_fk_device; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY systemdevicegroupdevice
    ADD CONSTRAINT systemdevicegroupdevice_fk_device FOREIGN KEY (deviceid) REFERENCES devices(id) ON DELETE CASCADE;


--
-- TOC entry 2523 (class 2606 OID 92215)
-- Dependencies: 1682 2455 1684
-- Name: systemdevicegroupdevice_systemdevicegroupid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY systemdevicegroupdevice
    ADD CONSTRAINT systemdevicegroupdevice_systemdevicegroupid FOREIGN KEY (systemdevicegroupid) REFERENCES systemdevicegroup(id) ON DELETE CASCADE;


--
-- TOC entry 2505 (class 2606 OID 88875)
-- Dependencies: 1639 1623 2339
-- Name: user2role_fk_roleid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user2role
    ADD CONSTRAINT user2role_fk_roleid FOREIGN KEY (roleid) REFERENCES "role"(id) ON DELETE CASCADE;


--
-- TOC entry 2506 (class 2606 OID 88880)
-- Dependencies: 1638 1639 2366
-- Name: user2role_fk_userid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user2role
    ADD CONSTRAINT user2role_fk_userid FOREIGN KEY (userid) REFERENCES "user"(id) ON DELETE CASCADE;


--
-- TOC entry 2529 (class 2606 OID 121228)
-- Dependencies: 2226 1708 1577
-- Name: userdevicesetting_fk_device; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY userdevicesetting
    ADD CONSTRAINT userdevicesetting_fk_device FOREIGN KEY (deviceid) REFERENCES devices(id) ON DELETE CASCADE;


--
-- TOC entry 2530 (class 2606 OID 121233)
-- Dependencies: 1708 2366 1638
-- Name: userdevicesetting_fk_userid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY userdevicesetting
    ADD CONSTRAINT userdevicesetting_fk_userid FOREIGN KEY (userid) REFERENCES "user"(id) ON DELETE CASCADE;


--
-- TOC entry 2524 (class 2606 OID 92241)
-- Dependencies: 2270 1590 1688
-- Name: wanlink_fk_inf1id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY wanlink
    ADD CONSTRAINT wanlink_fk_inf1id FOREIGN KEY (inf1id) REFERENCES interfacesetting(id) ON DELETE CASCADE;


--
-- TOC entry 2525 (class 2606 OID 92246)
-- Dependencies: 1590 1688 2270
-- Name: wanlink_fk_inf2id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY wanlink
    ADD CONSTRAINT wanlink_fk_inf2id FOREIGN KEY (inf2id) REFERENCES interfacesetting(id) ON DELETE CASCADE;


--
-- TOC entry 2526 (class 2606 OID 92251)
-- Dependencies: 2465 1686 1688
-- Name: wanlink_fk_wanid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY wanlink
    ADD CONSTRAINT wanlink_fk_wanid FOREIGN KEY (wanid) REFERENCES wans(id) ON DELETE CASCADE;


--
-- TOC entry 2624 (class 0 OID 0)
-- Dependencies: 5
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2010-04-13 15:59:39

--
-- PostgreSQL database dump complete
--

-----------------------------------------fix bug 32183 编辑Group中的devices之后，Dynamic devices消失
-- Function: devicegroupdevice_delete(integer)

-- DROP FUNCTION devicegroupdevice_delete(integer);

CREATE OR REPLACE FUNCTION devicegroupdevice_delete_static(gid integer)
  RETURNS boolean AS
$BODY$

BEGIN
	delete from  devicegroupdevice where devicegroupid=gid and "type"=1;
	return true;
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION devicegroupdevice_delete_static(integer) OWNER TO postgres;
