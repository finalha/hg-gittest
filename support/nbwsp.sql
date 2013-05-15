SET client_encoding = 'SQL_ASCII';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

--
-- TOC entry 2622 (class 1262 OID 88282)
-- Name: nbws; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE :nbwsp WITH TEMPLATE = template0 ENCODING = 'SQL_ASCII';


ALTER DATABASE :nbwsp OWNER TO postgres;

\connect :nbwsp


--
-- PostgreSQL database dump
--

-- Started on 2012-08-27 19:44:31

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
-- TOC entry 19 (class 1255 OID 619533)
-- Dependencies: 6 1057
-- Name: adddevice_configfile(character varying, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION adddevice_configfile(devname character varying, configcontent text) RETURNS integer
    LANGUAGE plpgsql
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
  $$;


ALTER FUNCTION public.adddevice_configfile(devname character varying, configcontent text) OWNER TO postgres;

--
-- TOC entry 20 (class 1255 OID 619534)
-- Dependencies: 1057 6
-- Name: adddevicegroupdevice(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION adddevicegroupdevice(_deviceid integer, _devicegroupid integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN
	INSERT INTO napdevice(deviceid, devicegroupid) VALUES (_deviceid, _devicegroupid);
	return 1;
End;
$$;


ALTER FUNCTION public.adddevicegroupdevice(_deviceid integer, _devicegroupid integer) OWNER TO postgres;

--
-- TOC entry 21 (class 1255 OID 619535)
-- Dependencies: 1057 6
-- Name: addnapdevice(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION addnapdevice(_deviceid integer, _napid integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN
	INSERT INTO napdevice(deviceid, napid) VALUES (_deviceid, _napid);
	return 1;
End;
$$;


ALTER FUNCTION public.addnapdevice(_deviceid integer, _napid integer) OWNER TO postgres;

--
-- TOC entry 22 (class 1255 OID 619536)
-- Dependencies: 6 1057
-- Name: addswtichgroupdevice(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION addswtichgroupdevice(_deviceid integer, _switchgroupid integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN
	INSERT INTO swtichgroupdevice(deviceid, switchgroupid) VALUES (_deviceid, _switchgroupid);
	return 1;
End;
$$;


ALTER FUNCTION public.addswtichgroupdevice(_deviceid integer, _switchgroupid integer) OWNER TO postgres;

--
-- TOC entry 23 (class 1255 OID 619537)
-- Dependencies: 6 1057
-- Name: changepri(character varying, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION changepri(tablename character varying, id1 integer, id2 integer) RETURNS boolean
    LANGUAGE plpgsql
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
$$;


ALTER FUNCTION public.changepri(tablename character varying, id1 integer, id2 integer) OWNER TO postgres;

--
-- TOC entry 24 (class 1255 OID 619538)
-- Dependencies: 6 1057
-- Name: checkadminpwd(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION checkadminpwd(pwd_in character varying) RETURNS integer
    LANGUAGE plpgsql
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
$$;


ALTER FUNCTION public.checkadminpwd(pwd_in character varying) OWNER TO postgres;

--
-- TOC entry 298 (class 1255 OID 621879)
-- Dependencies: 1057 6
-- Name: deleteoneiptalbe(timestamp without time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION deleteoneiptalbe(dt timestamp without time zone) RETURNS boolean
    LANGUAGE plpgsql
    AS $$

DECLARE
BEGIN		
	DELETE FROM ip2mac WHERE userflag<>1 and dt>retrievedate; 	        
	return true;
EXCEPTION    
	WHEN OTHERS THEN   
		return false;		
END;

  $$;


ALTER FUNCTION public.deleteoneiptalbe(dt timestamp without time zone) OWNER TO postgres;

--
-- TOC entry 2244 (class 1259 OID 619539)
-- Dependencies: 6
-- Name: devices_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE devices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.devices_id_seq OWNER TO postgres;

--
-- TOC entry 3814 (class 0 OID 0)
-- Dependencies: 2244
-- Name: devices_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('devices_id_seq', 1, true);


SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 2245 (class 1259 OID 619541)
-- Dependencies: 2855 6
-- Name: devices; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE devices (
    id integer DEFAULT nextval('devices_id_seq'::regclass) NOT NULL,
    strname character varying(256) NOT NULL,
    isubtype integer NOT NULL
);


ALTER TABLE public.devices OWNER TO postgres;

--
-- TOC entry 25 (class 1255 OID 619545)
-- Dependencies: 1057 6 584
-- Name: devciebyapplianceid(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION devciebyapplianceid(appid integer) RETURNS SETOF devices
    LANGUAGE plpgsql
    AS $$

DECLARE
    r devices%rowtype;
BEGIN	
             FOR r IN select deviceid as id,(select strname from devices where devices.id=devicesetting.deviceid)as strname,subtype as isubtype from devicesetting where appliceid=appid order by strname LOOP
		RETURN NEXT r;
	     END LOOP;	     		
END;
$$;


ALTER FUNCTION public.devciebyapplianceid(appid integer) OWNER TO postgres;

--
-- TOC entry 2246 (class 1259 OID 619546)
-- Dependencies: 2856 2857 2858 6
-- Name: devicegroup; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE devicegroup (
    id integer NOT NULL,
    strname character varying(256) NOT NULL,
    strdesc character varying(512),
    userid integer DEFAULT (-1) NOT NULL,
    showcolor integer DEFAULT 16777215 NOT NULL,
    searchcondition text,
    searchcontainer integer DEFAULT (-1),
    licguid character varying(128)
);


ALTER TABLE public.devicegroup OWNER TO postgres;

--
-- TOC entry 2247 (class 1259 OID 619555)
-- Dependencies: 2861 6
-- Name: devicegroupdevice; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE devicegroupdevice (
    devicegroupid integer NOT NULL,
    deviceid integer NOT NULL,
    id integer NOT NULL,
    type integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.devicegroupdevice OWNER TO postgres;

--
-- TOC entry 3815 (class 0 OID 0)
-- Dependencies: 2247
-- Name: COLUMN devicegroupdevice.type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN devicegroupdevice.type IS '1 static 2 dynamic';


--
-- TOC entry 2248 (class 1259 OID 619559)
-- Dependencies: 2613 6
-- Name: devicegroupdeviceview; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW devicegroupdeviceview AS
    SELECT devicegroupdevice.devicegroupid, devicegroupdevice.deviceid, devicegroupdevice.id, (SELECT devices.strname FROM devices WHERE (devices.id = devicegroupdevice.deviceid)) AS devicename, (SELECT devicegroup.strname FROM devicegroup WHERE (devicegroup.id = devicegroupdevice.devicegroupid)) AS devicegroupname, (SELECT devices.isubtype FROM devices WHERE (devices.id = devicegroupdevice.deviceid)) AS isubtype, devicegroupdevice.type FROM devicegroupdevice;


ALTER TABLE public.devicegroupdeviceview OWNER TO postgres;

--
-- TOC entry 26 (class 1255 OID 619563)
-- Dependencies: 6 1057 591
-- Name: devciebygroupid(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION devciebygroupid(dgroupid integer) RETURNS SETOF devicegroupdeviceview
    LANGUAGE plpgsql
    AS $$

DECLARE
    r devicegroupdeviceview%rowtype;
BEGIN	
             FOR r IN select * from  devicegroupdeviceview where devicegroupid=dgroupid order by devicename LOOP
		RETURN NEXT r;
	     END LOOP;	     		
END;
$$;


ALTER FUNCTION public.devciebygroupid(dgroupid integer) OWNER TO postgres;

--
-- TOC entry 2249 (class 1259 OID 619564)
-- Dependencies: 2863 6
-- Name: device_customized_info; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE device_customized_info (
    id integer NOT NULL,
    objectid integer NOT NULL,
    attributeid integer NOT NULL,
    attribute_value character varying(256),
    lasttimestamp timestamp without time zone DEFAULT now()
);


ALTER TABLE public.device_customized_info OWNER TO postgres;

--
-- TOC entry 2250 (class 1259 OID 619568)
-- Dependencies: 2865 6
-- Name: device_property; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE device_property (
    id integer NOT NULL,
    deviceid integer NOT NULL,
    manageif_mac character varying(64),
    vendor character varying(256),
    model character varying(256),
    sysobjectid character varying(256),
    software_version character varying(256),
    serial_number character varying(256),
    asset_tag character varying(256),
    system_memory character varying(256),
    location character varying(256),
    network_cluster character varying(256),
    contact character varying(256),
    hierarchy_layer character varying(256),
    description character varying(256),
    management_interface character varying(256),
    lasttimestamp timestamp without time zone DEFAULT now() NOT NULL,
    extradata text
);


ALTER TABLE public.device_property OWNER TO postgres;

--
-- TOC entry 2251 (class 1259 OID 619575)
-- Dependencies: 2614 6
-- Name: devicepropertyview; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW devicepropertyview AS
    SELECT device_property.id, device_property.deviceid, device_property.manageif_mac, device_property.vendor, device_property.model, device_property.sysobjectid, device_property.software_version, device_property.serial_number, device_property.asset_tag, device_property.system_memory, device_property.location, device_property.network_cluster, device_property.contact, device_property.hierarchy_layer, device_property.description, device_property.management_interface, device_property.lasttimestamp, device_property.extradata, devices.strname AS devicename, devices.isubtype AS itype FROM device_property, devices WHERE (device_property.deviceid = devices.id) ORDER BY device_property.id;


ALTER TABLE public.devicepropertyview OWNER TO postgres;

--
-- TOC entry 2252 (class 1259 OID 619579)
-- Dependencies: 2615 6
-- Name: device_customized_infoview; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW device_customized_infoview AS
    SELECT device_customized_info.id, device_customized_info.objectid, device_customized_info.attributeid, device_customized_info.attribute_value, device_customized_info.lasttimestamp, devicepropertyview.devicename FROM device_customized_info, devicepropertyview WHERE (device_customized_info.objectid = devicepropertyview.id) ORDER BY device_customized_info.id;


ALTER TABLE public.device_customized_infoview OWNER TO postgres;

--
-- TOC entry 27 (class 1255 OID 619583)
-- Dependencies: 6 1057 600
-- Name: device_customized_info_delete(device_customized_infoview); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION device_customized_info_delete(dp device_customized_infoview) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
declare
	r_id integer;
	ds_id integer;
BEGIN
	select id into r_id from devices where strname=dp.devicename;
	if r_id IS NULL THEN
		return false;
	end if;

	select id into ds_id from device_property where deviceid=r_id;
	if ds_id IS NULL THEN
		return false;
	end if;
	
	delete from device_customized_info where objectid=ds_id;	
	return true;
END;

  $$;


ALTER FUNCTION public.device_customized_info_delete(dp device_customized_infoview) OWNER TO postgres;

--
-- TOC entry 28 (class 1255 OID 619584)
-- Dependencies: 1057 600 6
-- Name: device_customized_infoview_upsert(device_customized_infoview); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION device_customized_infoview_upsert(dciv device_customized_infoview) RETURNS integer
    LANGUAGE plpgsql
    AS $$
declare
	r_id integer;
	ds_id integer;
	t_id integer;
BEGIN
	select id into r_id from devices where strname=dciv.devicename;
	if r_id IS NULL THEN
		return -1;
	end if;

	select id into ds_id from device_property where deviceid=r_id;
	if ds_id IS NULL THEN
		return -1;
	end if;

	select id into t_id from device_customized_info where objectid=ds_id and attributeid=dciv.attributeid ;
	if t_id IS NULL THEN		
		insert into device_customized_info(
			objectid,
			attributeid,
			attribute_value
			)
			values ( 
			ds_id,
			dciv.attributeid,
			dciv.attribute_value
		);

		return lastval();
	ELSE
		update device_customized_info set ( attribute_value)=( dciv.attribute_value ) where id = t_id;
		return t_id;
	end if;
END;

  $$;


ALTER FUNCTION public.device_customized_infoview_upsert(dciv device_customized_infoview) OWNER TO postgres;

--
-- TOC entry 29 (class 1255 OID 619585)
-- Dependencies: 1057 6 598
-- Name: device_property_update(devicepropertyview); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION device_property_update(dp devicepropertyview) RETURNS integer
    LANGUAGE plpgsql
    AS $$
declare
	r_id integer;
	ds_id integer;
BEGIN
	select id into r_id from devices where strname=dp.devicename;
	if r_id IS NULL THEN
		return -1;
	end if;

	select id into ds_id from device_property where deviceid=r_id;
	if ds_id IS NULL THEN
		return -1;
	ELSE
		update device_property set ( 
			manageif_mac,
			vendor,
			model,
			sysobjectid,
			software_version,
			serial_number,
			asset_tag,
			system_memory,
			"location",
			network_cluster,
			contact,
			hierarchy_layer,
			description,
			management_interface,
			extradata			
			)
			=( 
			dp.manageif_mac,
			dp.vendor,
			dp.model,
			dp.sysobjectid,
			dp.software_version,
			dp.serial_number,
			dp.asset_tag,
			dp.system_memory,
			dp.location,
			dp.network_cluster,
			dp.contact,
			dp.hierarchy_layer,
			dp.description,
			dp.management_interface,
			dp.extradata			
			) 
			where id = ds_id;
		return ds_id;
	end if;
END;

  $$;


ALTER FUNCTION public.device_property_update(dp devicepropertyview) OWNER TO postgres;

--
-- TOC entry 30 (class 1255 OID 619586)
-- Dependencies: 1057 598 6
-- Name: device_property_upsert(devicepropertyview); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION device_property_upsert(dp devicepropertyview) RETURNS integer
    LANGUAGE plpgsql
    AS $$
declare
	r_id integer;
	ds_id integer;
BEGIN
	select id into r_id from devices where strname=dp.devicename;
	if r_id IS NULL THEN
		return -1;
	end if;

	select id into ds_id from device_property where deviceid=r_id;
	if ds_id IS NULL THEN
		insert into device_property(
			deviceid,
			manageif_mac,
			vendor,
			model,
			sysobjectid,
			software_version,
			serial_number,
			asset_tag,
			system_memory,
			"location",
			network_cluster,
			contact,
			hierarchy_layer,
			description,
			management_interface,
			extradata
		)
		values (
			r_id,
			dp.manageif_mac,
			dp.vendor,
			dp.model,
			dp.sysobjectid,
			dp.software_version,
			dp.serial_number,
			dp.asset_tag,
			dp.system_memory,
			dp.location,
			dp.network_cluster,
			dp.contact,
			dp.hierarchy_layer,
			dp.description,
			dp.management_interface,
			dp.extradata	
		);

		return lastval();
	ELSE
		update device_property set ( 
			manageif_mac,
			vendor,
			model,
			sysobjectid,
			software_version,
			serial_number,
			asset_tag,
			system_memory,
			"location",
			network_cluster,
			contact,
			hierarchy_layer,
			description,
			management_interface,
			extradata			
			)
			=( 
			dp.manageif_mac,
			dp.vendor,
			dp.model,
			dp.sysobjectid,
			dp.software_version,
			dp.serial_number,
			dp.asset_tag,
			dp.system_memory,
			dp.location,
			dp.network_cluster,
			dp.contact,
			dp.hierarchy_layer,
			dp.description,
			dp.management_interface,
			dp.extradata			
			) 
			where id = ds_id and ( manageif_mac != dp.manageif_mac or manageif_mac is null or vendor != dp.vendor or vendor is null or model != dp.model or model is null or sysobjectid != dp.sysobjectid or sysobjectid is null or software_version != dp.software_version or software_version is null or serial_number != dp.serial_number or serial_number is null or asset_tag != dp.asset_tag or asset_tag is null or system_memory != dp.system_memory or system_memory is null or location != dp.location or location is null or network_cluster != dp.network_cluster or network_cluster is null or  contact != dp.contact or contact is null or hierarchy_layer != dp.hierarchy_layer or hierarchy_layer is null or description != dp.description or description is null or management_interface != dp.management_interface or management_interface is null or  extradata != dp.extradata or extradata is null );
		return ds_id;
	end if;
END;

  $$;


ALTER FUNCTION public.device_property_upsert(dp devicepropertyview) OWNER TO postgres;

--
-- TOC entry 2253 (class 1259 OID 619587)
-- Dependencies: 2866 2867 2868 2869 2870 2871 2872 2873 2874 2875 2876 2877 2878 2879 2880 2881 2882 2883 2884 2885 2886 2887 2888 2889 2890 2891 2892 2893 2894 2895 2896 6
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
    livestatuas integer DEFAULT (-1),
    telnetproxyid integer DEFAULT (-1),
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
    cmdbserverid integer DEFAULT 0,
    authentication_method integer DEFAULT 0 NOT NULL,
    encryption_method integer DEFAULT 0 NOT NULL,
    authentication_mode integer DEFAULT 0 NOT NULL,
    snmpv3_username character varying(256),
    snmpv3_authentication character varying(256),
    snmpv3_encryption character varying(256),
    configfile_time timestamp without time zone DEFAULT now(),
    driverid character varying(255),
    enpasswordprompt character varying(255),
    enableusername character varying(255),
    enableusernameprompt character varying(255),
    cpuexpression text,
    memoryexpression text,
    loginscript text,
    loginscriptenable boolean DEFAULT false
);


ALTER TABLE public.devicesetting OWNER TO postgres;

--
-- TOC entry 31 (class 1255 OID 619624)
-- Dependencies: 6 1057 602
-- Name: device_setting_retrieve(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION device_setting_retrieve(devname character varying) RETURNS devicesetting
    LANGUAGE plpgsql
    AS $$
declare
	r devicesetting%rowtype;
BEGIN
	SELECT * into r FROM devicesetting where deviceid IN ( select id from devices where strname=devname );
	return r;
END;

  $$;


ALTER FUNCTION public.device_setting_retrieve(devname character varying) OWNER TO postgres;

--
-- TOC entry 32 (class 1255 OID 619625)
-- Dependencies: 1057 6
-- Name: device_setting_retrieve0(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION device_setting_retrieve0(devname character varying) RETURNS SETOF record
    LANGUAGE plpgsql
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

  $$;


ALTER FUNCTION public.device_setting_retrieve0(devname character varying) OWNER TO postgres;

--
-- TOC entry 33 (class 1255 OID 619626)
-- Dependencies: 1057 6
-- Name: device_setting_retrieve1(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION device_setting_retrieve1(devname character varying) RETURNS SETOF refcursor
    LANGUAGE plpgsql
    AS $$

DECLARE 
	ref1 refcursor;
BEGIN
	OPEN ref1 FOR 
	 SELECT * FROM devicesetting;
	RETURN NEXT ref1;
	return; 
END;

  $$;


ALTER FUNCTION public.device_setting_retrieve1(devname character varying) OWNER TO postgres;

--
-- TOC entry 34 (class 1255 OID 619627)
-- Dependencies: 6 1057 602
-- Name: device_setting_retrieve_by_devs(character varying[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION device_setting_retrieve_by_devs(devnames character varying[]) RETURNS SETOF devicesetting
    LANGUAGE plpgsql
    AS $$
declare
	r devicesetting%rowtype;
BEGIN
	for r in SELECT * FROM devicesetting where deviceid IN ( select id from devices where strname = any( devnames ) ) loop
	return next r;
	end loop;	
END;

  $$;


ALTER FUNCTION public.device_setting_retrieve_by_devs(devnames character varying[]) OWNER TO postgres;

--
-- TOC entry 35 (class 1255 OID 619628)
-- Dependencies: 1057 602 6
-- Name: device_setting_update(character varying, devicesetting); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION device_setting_update(devname character varying, ds devicesetting) RETURNS integer
    LANGUAGE plpgsql
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
			cmdbserverid,
			authentication_method,
			encryption_method,
			snmpv3_username,
			snmpv3_authentication,
			snmpv3_encryption,
			authentication_mode,
			driverid,
			enpasswordprompt,
			enableusername,
			enableusernameprompt,
			cpuexpression,
			memoryexpression,
			loginscript,
			loginscriptenable
			)
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
			ds.cmdbserverid,
			ds.authentication_method,
			ds.encryption_method,
			ds.snmpv3_username,
			ds.snmpv3_authentication,
			ds.snmpv3_encryption,
			ds.authentication_mode,
			ds.driverid,
			ds.enpasswordprompt,
			ds.enableusername,
			ds.enableusernameprompt,
			ds.cpuexpression,
			ds.memoryexpression,
			ds.loginscript,
			ds.loginscriptenable
			) 
			where id = ds_id;

		update device_property set vendor=ds.vendor, model=ds.model where deviceid=ds_id;	
		return ds_id;
	end if;
EXCEPTION
	WHEN OTHERS THEN 
		RETURN -2;
END;

  $$;


ALTER FUNCTION public.device_setting_update(devname character varying, ds devicesetting) OWNER TO postgres;

--
-- TOC entry 36 (class 1255 OID 619629)
-- Dependencies: 6 602 1057
-- Name: device_setting_upsert(character varying, devicesetting); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION device_setting_upsert(devname character varying, ds devicesetting) RETURNS integer
    LANGUAGE plpgsql
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
			cmdbserverid,
			authentication_method,
			encryption_method,
			snmpv3_username,
			snmpv3_authentication,
			snmpv3_encryption,
			authentication_mode,
			configfile_time,
			driverid,
			enpasswordprompt,
			enableusername,
			enableusernameprompt,
			cpuexpression,
			memoryexpression,
			loginscript,
			loginscriptenable
			)
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
			ds.cmdbserverid,
			ds.authentication_method,
			ds.encryption_method,
			ds.snmpv3_username,
			ds.snmpv3_authentication,
			ds.snmpv3_encryption,
			ds.authentication_mode,		
			ds.configfile_time,
			ds.driverid,
			ds.enpasswordprompt,
			ds.enableusername,
			ds.enableusernameprompt,
			ds.cpuexpression,
			ds.memoryexpression,
			ds.loginscript,
			ds.loginscriptenable
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
			cmdbserverid,
			authentication_method,
			encryption_method,
			snmpv3_username,
			snmpv3_authentication,
			snmpv3_encryption,
			authentication_mode,
			driverid,
			enpasswordprompt,
			enableusername,
			enableusernameprompt,
			cpuexpression,
			memoryexpression,
			loginscript,
			loginscriptenable
			)
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
			ds.cmdbserverid,
			ds.authentication_method,
			ds.encryption_method,
			ds.snmpv3_username,
			ds.snmpv3_authentication,
			ds.snmpv3_encryption,
			ds.authentication_mode,
			ds.driverid,
			ds.enpasswordprompt,
			ds.enableusername,
			ds.enableusernameprompt,
			ds.cpuexpression,
			ds.memoryexpression,
			ds.loginscript,
			ds.loginscriptenable
			) 
			where id = ds_id;
		return ds_id;
	end if;
EXCEPTION
	WHEN OTHERS THEN 
		RETURN -2;
END;

  $$;


ALTER FUNCTION public.device_setting_upsert(devname character varying, ds devicesetting) OWNER TO postgres;

--
-- TOC entry 2254 (class 1259 OID 619630)
-- Dependencies: 6
-- Name: appliance_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE appliance_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.appliance_id_seq OWNER TO postgres;

--
-- TOC entry 3816 (class 0 OID 0)
-- Dependencies: 2254
-- Name: appliance_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('appliance_id_seq', 1, true);


--
-- TOC entry 2255 (class 1259 OID 619632)
-- Dependencies: 2898 2899 2900 6
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
-- TOC entry 2256 (class 1259 OID 619638)
-- Dependencies: 2616 6
-- Name: devicesettingview; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW devicesettingview AS
    SELECT devicesetting.id, devicesetting.deviceid, devicesetting.alias, devicesetting.curversion, devicesetting.usermodifiedflag, devicesetting.subtype, devicesetting.accessmethod, devicesetting.accessability, devicesetting.livestatuas, devicesetting.telnetproxyid, devicesetting.snmpversion, devicesetting.appliceid, devicesetting.smarttelnetmethod, devicesetting.backtelnetmethod, devicesetting.monitormethod, devicesetting.telnetport, devicesetting.sshport, devicesetting.manageip, devicesetting.livehostname, devicesetting.vendor, devicesetting.model, devicesetting.username, devicesetting.userpassword, devicesetting.enablepassword, devicesetting.loginprompt, devicesetting.passwordprompt, devicesetting.nonprivilegeprompt, devicesetting.privilegeprompt, devicesetting.snmpro, devicesetting.snmprw, devicesetting.keyword, devicesetting.proxy, devicesetting.devicemode, devicesetting.lasttimestamp, devicesetting.snmpport, devicesetting.serialnumber, devicesetting.softwareversion, devicesetting.contactor, devicesetting.currentlocation, devicesetting.keepitem1, devicesetting.keepitem2, devicesetting.keepitem3, devicesetting.keepitem4, devicesetting.keepitem5, devicesetting.keepitem6, devicesetting.keepitem7, devicesetting.telnettooltype, devicesetting.telnettoolsession, devicesetting.telnetcommandline, devicesetting.cmdbserverid, devicesetting.authentication_method, devicesetting.encryption_method, devicesetting.authentication_mode, devicesetting.snmpv3_username, devicesetting.snmpv3_authentication, devicesetting.snmpv3_encryption, devicesetting.configfile_time, devicesetting.driverid, devicesetting.enpasswordprompt, devicesetting.enableusername, devicesetting.enableusernameprompt, devicesetting.cpuexpression, devicesetting.memoryexpression, devicesetting.loginscript, devicesetting.loginscriptenable, devices.strname AS devicename, nomp_appliance.strhostname AS hostname FROM devicesetting, devices, nomp_appliance WHERE ((devices.id = devicesetting.deviceid) AND (nomp_appliance.id = devicesetting.appliceid));


ALTER TABLE public.devicesettingview OWNER TO postgres;

--
-- TOC entry 37 (class 1255 OID 619643)
-- Dependencies: 608 6 1057
-- Name: device_settingview_retrieve_by_devs(character varying[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION device_settingview_retrieve_by_devs(devnames character varying[]) RETURNS SETOF devicesettingview
    LANGUAGE plpgsql
    AS $$
declare
	r devicesettingview%rowtype;
BEGIN
	for r in SELECT * FROM devicesettingview where devicename = any( devnames ) loop
	return next r;
	end loop;	
END;

  $$;


ALTER FUNCTION public.device_settingview_retrieve_by_devs(devnames character varying[]) OWNER TO postgres;

--
-- TOC entry 39 (class 1255 OID 619644)
-- Dependencies: 6 1057
-- Name: device_site_move(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION device_site_move(nsiteidfrom integer, nsiteidto integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$

BEGIN
	update devicesitedevice set siteid=nsiteidto where siteid =nsiteidfrom;
	update site set lasttimestamp=now() where id=nsiteidto;
	update objtimestamp set modifytime=now() where typename='site';
	return 1;
EXCEPTION
	WHEN OTHERS THEN 
		RETURN -1;
END;
$$;


ALTER FUNCTION public.device_site_move(nsiteidfrom integer, nsiteidto integer) OWNER TO postgres;

--
-- TOC entry 40 (class 1255 OID 619645)
-- Dependencies: 1057 6
-- Name: device_site_set(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION device_site_set(nsiteid integer, ndeviceid integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$

BEGIN
	if (select count(*) from devicesitedevice where deviceid =ndeviceid)<1 then
		INSERT INTO devicesitedevice(siteid, deviceid)VALUES (nsiteid, ndeviceid);
	end if;
	update devicesitedevice set siteid=nsiteid where deviceid =ndeviceid;
	update site set lasttimestamp=now() where id=nsiteid;
	update objtimestamp set modifytime=now() where typename='site';
	return 1;
EXCEPTION
	WHEN OTHERS THEN 
		RETURN -1;
END;
$$;


ALTER FUNCTION public.device_site_set(nsiteid integer, ndeviceid integer) OWNER TO postgres;

--
-- TOC entry 41 (class 1255 OID 619646)
-- Dependencies: 6 1057
-- Name: device_site_set2(integer, character varying[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION device_site_set2(nsiteid integer, devnames character varying[]) RETURNS integer
    LANGUAGE plpgsql
    AS $$
declare
	nparentid integer;
	ndeviceid integer;
BEGIN	
	select parentid into nparentid from site2site where siteid=nsiteid;
	
	if nparentid IS NULL THEN
		return -1;
	end if;

	if nparentid >0 THEN
		update devicesitedevice set siteid=nparentid where siteid=nsiteid ;
	end if;

	for ndeviceid in select id from devices where strname = any( devnames ) LOOP	       
		if (select count(*) from devicesitedevice where deviceid =ndeviceid)<1 then
			INSERT INTO devicesitedevice(siteid, deviceid)VALUES (nsiteid, ndeviceid);
		end if;
		update devicesitedevice set siteid=nsiteid where deviceid =ndeviceid;             
	end loop;

	update site set lasttimestamp=now() where id=nsiteid;
	update objtimestamp set modifytime=now() where typename='site';
	return 1;

END;
$$;


ALTER FUNCTION public.device_site_set2(nsiteid integer, devnames character varying[]) OWNER TO postgres;

--
-- TOC entry 42 (class 1255 OID 619647)
-- Dependencies: 586 6 1057
-- Name: devicegroup_upsert(devicegroup); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION devicegroup_upsert(vm devicegroup) RETURNS integer
    LANGUAGE plpgsql
    AS $$
declare
	vm_id integer;
BEGIN
	select id into vm_id from devicegroup where strname=vm.strname;
	
	if vm_id IS NULL THEN
		insert into devicegroup(
			strname, strdesc, userid, showcolor, searchcondition,searchcontainer,licguid)
			values( 
			vm.strname, vm.strdesc, vm.userid, vm.showcolor, vm.searchcondition,vm.searchcontainer,vm.licguid
			);
			return lastval();	
	end if;
EXCEPTION
	WHEN OTHERS THEN 
		RETURN -2;	
END;

  $$;


ALTER FUNCTION public.devicegroup_upsert(vm devicegroup) OWNER TO postgres;

--
-- TOC entry 43 (class 1255 OID 619648)
-- Dependencies: 6 1057
-- Name: devicegroupclearsearchcontainerids(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION devicegroupclearsearchcontainerids(lid integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$			
BEGIN
	delete from devicegroupdevicegroup where groupid=lid;
	delete from devicegroupsite where groupid=lid;
	delete from devicegroupsystemdevicegroup where groupid=lid;
	return 1;
End;
$$;


ALTER FUNCTION public.devicegroupclearsearchcontainerids(lid integer) OWNER TO postgres;

--
-- TOC entry 44 (class 1255 OID 619649)
-- Dependencies: 1057 6
-- Name: devicegroupdevice_delete(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION devicegroupdevice_delete(gid integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$

BEGIN
	delete from  devicegroupdevice where devicegroupid=gid;	
	return true;
END;

  $$;


ALTER FUNCTION public.devicegroupdevice_delete(gid integer) OWNER TO postgres;

--
-- TOC entry 45 (class 1255 OID 619650)
-- Dependencies: 6 1057
-- Name: devicegroupdevice_delete_dynamic(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION devicegroupdevice_delete_dynamic(gid integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$

BEGIN
	delete from  devicegroupdevice where devicegroupid=gid and "type"=2;
	return true;
END;

  $$;


ALTER FUNCTION public.devicegroupdevice_delete_dynamic(gid integer) OWNER TO postgres;

--
-- TOC entry 46 (class 1255 OID 619651)
-- Dependencies: 1057 6
-- Name: devicegroupdevice_delete_static(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION devicegroupdevice_delete_static(gid integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$

BEGIN
	delete from  devicegroupdevice where devicegroupid=gid and "type"=1;
	return true;
END;

  $$;


ALTER FUNCTION public.devicegroupdevice_delete_static(gid integer) OWNER TO postgres;

--
-- TOC entry 47 (class 1255 OID 619652)
-- Dependencies: 1057 6
-- Name: devicegroupdevice_upsert2(integer, integer[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION devicegroupdevice_upsert2(gid integer, ds integer[]) RETURNS boolean
    LANGUAGE plpgsql
    AS $$

BEGIN
	for r in  1..array_length(ds,1) loop
	       insert into devicegroupdevice (devicegroupid,deviceid) values (gid,ds[r]);              
	end loop;	
	return true;
EXCEPTION    
	WHEN OTHERS THEN   
		return false;		
END;

  $$;


ALTER FUNCTION public.devicegroupdevice_upsert2(gid integer, ds integer[]) OWNER TO postgres;

--
-- TOC entry 48 (class 1255 OID 619653)
-- Dependencies: 1057 6
-- Name: devicegroupdevice_upsert3(integer, character varying[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION devicegroupdevice_upsert3(gid integer, ds character varying[]) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    r integer;
BEGIN
	for r in select id from devicegroup where strname = any(ds) LOOP
	       insert into devicegroupdevice (devicegroupid,deviceid) values (gid, r );              
	end loop;	
	return true;
EXCEPTION    
	WHEN OTHERS THEN   
		return false;		
END;

  $$;


ALTER FUNCTION public.devicegroupdevice_upsert3(gid integer, ds character varying[]) OWNER TO postgres;

--
-- TOC entry 49 (class 1255 OID 619654)
-- Dependencies: 6 1057
-- Name: devicegroupdevice_upsert_dynamic(integer, character varying[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION devicegroupdevice_upsert_dynamic(gid integer, ds character varying[]) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    r integer;
    dg_id integer;
BEGIN
	for r in select id from devices where strname = any(ds) LOOP
		select id into dg_id from devicegroupdevice where devicegroupid = gid and deviceid = r and "type" = 2;
		if dg_id is null then
			insert into devicegroupdevice (devicegroupid,deviceid,"type") values (gid, r, 2);              
		end if;
	end loop;	
	return true;
END;

  $$;


ALTER FUNCTION public.devicegroupdevice_upsert_dynamic(gid integer, ds character varying[]) OWNER TO postgres;

--
-- TOC entry 50 (class 1255 OID 619655)
-- Dependencies: 6 1057
-- Name: devicegroupdevice_upsert_static(integer, character varying[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION devicegroupdevice_upsert_static(gid integer, ds character varying[]) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    r integer;
    dg_id integer;
BEGIN
	for r in select id from devices where strname = any(ds) LOOP
		select id into dg_id from devicegroupdevice where devicegroupid = gid and deviceid = r and "type" = 1;
		if dg_id is null then
			insert into devicegroupdevice (devicegroupid,deviceid,"type") values (gid, r, 1);              
		end if;
	end loop;	
	return true;
END;

  $$;


ALTER FUNCTION public.devicegroupdevice_upsert_static(gid integer, ds character varying[]) OWNER TO postgres;

--
-- TOC entry 51 (class 1255 OID 619656)
-- Dependencies: 1057 6
-- Name: devicegroupnameexists(character varying, integer, integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION devicegroupnameexists(sname character varying, nid integer, uid integer, guid character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
	if((select count(*) from devicegroup where id<>nid and lower(strname) =lower(sname) and userid=uid and licguid=guid)=0) then
		return false;
	end if;
    
    RETURN true;
EXCEPTION
    WHEN OTHERS THEN 
	RETURN false;    
END;
$$;


ALTER FUNCTION public.devicegroupnameexists(sname character varying, nid integer, uid integer, guid character varying) OWNER TO postgres;

--
-- TOC entry 2257 (class 1259 OID 619657)
-- Dependencies: 2617 6
-- Name: devicesettingview_weblist; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW devicesettingview_weblist AS
    SELECT devicesetting.id, devicesetting.deviceid, devicesetting.manageip, devicesetting.subtype, devicesetting.appliceid, devices.strname AS devicename, (SELECT nomp_appliance.strhostname FROM nomp_appliance WHERE (nomp_appliance.id = devicesetting.appliceid)) AS hostname, (SELECT device_property.vendor FROM device_property WHERE (devicesetting.deviceid = device_property.deviceid)) AS vendor, (SELECT device_property.model FROM device_property WHERE (devicesetting.deviceid = device_property.deviceid)) AS model, (SELECT device_property.software_version FROM device_property WHERE (devicesetting.deviceid = device_property.deviceid)) AS softwareversion, (SELECT device_property.serial_number FROM device_property WHERE (devicesetting.deviceid = device_property.deviceid)) AS serialnumber, (SELECT device_property.contact FROM device_property WHERE (devicesetting.deviceid = device_property.deviceid)) AS contactor, (SELECT device_property.location FROM device_property WHERE (devicesetting.deviceid = device_property.deviceid)) AS currentlocation FROM devicesetting, devices WHERE (devices.id = devicesetting.deviceid);


ALTER TABLE public.devicesettingview_weblist OWNER TO postgres;

--
-- TOC entry 52 (class 1255 OID 619662)
-- Dependencies: 1057 6 610
-- Name: devicelist(character varying[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION devicelist(devnames character varying[]) RETURNS SETOF devicesettingview_weblist
    LANGUAGE plpgsql
    AS $$

DECLARE
    r devicesettingview_weblist%rowtype;
BEGIN			     
		     FOR r IN select * from devicesettingview_weblist where devicename= any(devnames)  order by lower(devicename) LOOP
			RETURN NEXT r;
		     END LOOP;			     
END;
$$;


ALTER FUNCTION public.devicelist(devnames character varying[]) OWNER TO postgres;

--
-- TOC entry 53 (class 1255 OID 619663)
-- Dependencies: 1057 584 6
-- Name: devices_retrieve(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION devices_retrieve() RETURNS SETOF devices
    LANGUAGE plpgsql
    AS $$
declare
	r devices%rowtype;
BEGIN
   for r in SELECT * FROM devices loop
   return next r;
   end loop;
END;

  $$;


ALTER FUNCTION public.devices_retrieve() OWNER TO postgres;

--
-- TOC entry 2258 (class 1259 OID 619664)
-- Dependencies: 6
-- Name: discover_missdevice; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE discover_missdevice (
    id integer NOT NULL,
    mgrip character varying(16),
    devtype integer,
    vendor character varying(64),
    model character varying(64),
    checktime character varying(20) NOT NULL,
    log text,
    modifytime timestamp without time zone,
    deviceid integer
);


ALTER TABLE public.discover_missdevice OWNER TO postgres;

--
-- TOC entry 2259 (class 1259 OID 619670)
-- Dependencies: 2618 6
-- Name: discover_missdeviceview2; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW discover_missdeviceview2 AS
    SELECT discover_missdevice.id, discover_missdevice.mgrip, discover_missdevice.devtype, discover_missdevice.vendor, discover_missdevice.model, discover_missdevice.checktime, discover_missdevice.log, discover_missdevice.modifytime, discover_missdevice.deviceid, (SELECT devices.strname FROM devices WHERE (devices.id = discover_missdevice.deviceid)) AS hostname FROM discover_missdevice;


ALTER TABLE public.discover_missdeviceview2 OWNER TO postgres;

--
-- TOC entry 56 (class 1255 OID 619674)
-- Dependencies: 6 1057 615
-- Name: discovereport_missdevice(discover_missdeviceview2); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION discovereport_missdevice(r discover_missdeviceview2) RETURNS integer
    LANGUAGE plpgsql
    AS $$
declare
	r_id integer;
	ds_id integer;
BEGIN
	select id into r_id from devices where strname=r.hostname;
	if r_id IS NULL THEN
		return -1;
	end if;
	
	select id into ds_id from discover_missdevice where deviceid=r_id;
	if ds_id IS NULL THEN
		insert into discover_missdevice(
			  mgrip,
			  devtype,
			  vendor,
			  model,
			  checktime,
			  "log",
			  modifytime,
			  deviceid
			  )
			  values( 
			  r.mgrip,
			  r.devtype,
			  r.vendor,
			  r.model,
			  r.checktime,
			  r.log,
			  r.modifytime,
			  r_id
			  );
			  return lastval();
	else
		update discover_missdevice set(
			  mgrip,
			  devtype,
			  vendor,
			  model,
			  checktime,
			  "log",
			  modifytime
			  ) = ( 			 
			  r.mgrip,
			  r.devtype,
			  r.vendor,
			  r.model,
			  r.checktime,
			  r.log,
			  r.modifytime
			  ) 
			  where id = ds_id;
		return ds_id;
	end if;
EXCEPTION
	WHEN OTHERS THEN 
		RETURN -2;	
END;

  $$;


ALTER FUNCTION public.discovereport_missdevice(r discover_missdeviceview2) OWNER TO postgres;

--
-- TOC entry 2260 (class 1259 OID 619675)
-- Dependencies: 6
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
    log text,
    lasttime character varying(20) NOT NULL
);


ALTER TABLE public.discover_newdevice OWNER TO postgres;

--
-- TOC entry 57 (class 1255 OID 619681)
-- Dependencies: 1057 6 617
-- Name: discovereport_newdevice(discover_newdevice); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION discovereport_newdevice(r discover_newdevice) RETURNS integer
    LANGUAGE plpgsql
    AS $$
declare	
	ds_id integer;
BEGIN		
	select id into ds_id from discover_newdevice where hostname=r.hostname;
	if ds_id IS NULL THEN
		insert into discover_newdevice(
			  mgrip,
			  devtype,
			  vendor,
			  model,
			  findtime,
			  "log",
			  lasttime,
			  hostname
			  )
			  values( 
			  r.mgrip,
			  r.devtype,
			  r.vendor,
			  r.model,
			  r.findtime,
			  r.log,
			  r.lasttime,
			  r.hostname
			  );
			  return lastval();
	else
		update discover_newdevice set(			  
			  "log",
			  lasttime
			  ) = ( 			 			  
			  r.log,
			  r.lasttime
			  ) 
			  where id = ds_id;
		return ds_id;
	end if;
EXCEPTION
	WHEN OTHERS THEN 
		RETURN -2;	
END;

  $$;


ALTER FUNCTION public.discovereport_newdevice(r discover_newdevice) OWNER TO postgres;

--
-- TOC entry 2261 (class 1259 OID 619682)
-- Dependencies: 6
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
-- TOC entry 58 (class 1255 OID 619688)
-- Dependencies: 6 620 1057
-- Name: discovereport_snmpdevice(discover_snmpdevice); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION discovereport_snmpdevice(r discover_snmpdevice) RETURNS integer
    LANGUAGE plpgsql
    AS $$
declare	
	ds_id integer;
BEGIN		
	select id into ds_id from discover_snmpdevice where hostname=r.hostname;
	if ds_id IS NULL THEN
		insert into discover_snmpdevice(
			  mgrip,
			  devtype,
			  vendor,
			  model,
			  findtime,
			  "log",
			  snmpro,
			  hostname
			  )
			  values( 
			  r.mgrip,
			  r.devtype,
			  r.vendor,
			  r.model,
			  r.findtime,
			  r.log,
			  r.snmpro,
			  r.hostname
			  );
			  return lastval();
	else
		update discover_snmpdevice set(
			  mgrip,
			  devtype,
			  vendor,
			  model,
			  findtime,
			  "log",
			  snmpro
			  ) = ( 			 
			  r.mgrip,
			  r.devtype,
			  r.vendor,
			  r.model,
			  r.findtime,
			  r.log,
			  r.snmpro
			  ) 
			  where id = ds_id;
		return ds_id;
	end if;
EXCEPTION
	WHEN OTHERS THEN 
		RETURN -2;	
END;

  $$;


ALTER FUNCTION public.discovereport_snmpdevice(r discover_snmpdevice) OWNER TO postgres;

--
-- TOC entry 2262 (class 1259 OID 619689)
-- Dependencies: 6
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
    log text,
    devname character varying(256)
);


ALTER TABLE public.discover_unknowdevice OWNER TO postgres;

--
-- TOC entry 59 (class 1255 OID 619695)
-- Dependencies: 1057 623 6
-- Name: discovereport_unknowdevice(discover_unknowdevice); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION discovereport_unknowdevice(r discover_unknowdevice) RETURNS integer
    LANGUAGE plpgsql
    AS $$
declare	
	ds_id integer;
BEGIN		
	select id into ds_id from discover_unknowdevice where mgrip=r.mgrip;
	if ds_id IS NULL THEN
		insert into discover_unknowdevice(
			  mgrip,
			  snmpro,
			  devtype,	
			  sysobjectid,
			  discoverfrom,
			  findtime,
			  "log",
			  devname			  
			  )
			  values( 
			  r.mgrip,
			  r.snmpro,		
			  r.devtype,
			  r.sysobjectid,
			  r.discoverfrom,
			  r.findtime,			  
			  r.log,
			  r.devname			  
			  );
			  return lastval();
	else
		update discover_unknowdevice set(
			  snmpro,
			  devtype,	
			  sysobjectid,
			  discoverfrom,
			  findtime,
			  "log",
			  devname
			  ) = ( 			 
			  r.snmpro,		
			  r.devtype,
			  r.sysobjectid,
			  r.discoverfrom,
			  r.findtime,			  
			  r.log,
			  r.devname
			  ) 
			  where id = ds_id;
		return ds_id;
	end if;
EXCEPTION
	WHEN OTHERS THEN 
		RETURN -2;	
END;

  $$;


ALTER FUNCTION public.discovereport_unknowdevice(r discover_unknowdevice) OWNER TO postgres;

--
-- TOC entry 2263 (class 1259 OID 619696)
-- Dependencies: 6
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
-- TOC entry 3817 (class 0 OID 0)
-- Dependencies: 2263
-- Name: unknownip_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('unknownip_id_seq', 1, false);


--
-- TOC entry 2264 (class 1259 OID 619698)
-- Dependencies: 2905 2906 6
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
    findtime character varying(32),
    collectsource integer DEFAULT 0 NOT NULL,
    description text,
    itype integer NOT NULL
);


ALTER TABLE public.unknownip OWNER TO postgres;

--
-- TOC entry 60 (class 1255 OID 619706)
-- Dependencies: 627 6 1057
-- Name: discovereport_unknownip(unknownip); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION discovereport_unknownip(r unknownip) RETURNS integer
    LANGUAGE plpgsql
    AS $$
declare	
	ds_id integer;
BEGIN		
	select id into ds_id from unknownip where nexthopip=r.nexthopip;
	if ds_id IS NULL THEN
		insert into unknownip(
			  nexthopip,
			  edgedevice,
			  edgeintf,	
			  ipfrom,
			  ipmask,
			  intfdesc,
			  findtime,
			  collectsource,
			  description,
			  itype			  
			  )
			  values( 
			  r.nexthopip,
			  r.edgedevice,
			  r.edgeintf,	
			  r.ipfrom,
			  r.ipmask,
			  r.intfdesc,
			  r.findtime,
			  r.collectsource,
			  r.description,
			  r.itype			  
			  );
			  return lastval();
	else
		update unknownip set(
			  edgedevice,
			  edgeintf,	
			  ipfrom,
			  ipmask,
			  intfdesc,
			  findtime,
			  collectsource,
			  description,
			  itype	
			  ) = ( 			 
			  r.edgedevice,
			  r.edgeintf,	
			  r.ipfrom,
			  r.ipmask,
			  r.intfdesc,
			  r.findtime,
			  r.collectsource,
			  r.description,
			  r.itype	
			  ) 
			  where id = ds_id;
		return ds_id;
	end if;
EXCEPTION
	WHEN OTHERS THEN 
		RETURN -2;	
END;

  $$;


ALTER FUNCTION public.discovereport_unknownip(r unknownip) OWNER TO postgres;

--
-- TOC entry 61 (class 1255 OID 619707)
-- Dependencies: 1057 6
-- Name: discoverymisdevice_delete(character varying[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION discoverymisdevice_delete(hostname character varying[]) RETURNS boolean
    LANGUAGE plpgsql
    AS $$

BEGIN
	delete from discover_missdevice where deviceid = any(select id from devices where strname= any(hostname));	
	return true;
EXCEPTION    
	WHEN OTHERS THEN   
		return false;		
END;

  $$;


ALTER FUNCTION public.discoverymisdevice_delete(hostname character varying[]) OWNER TO postgres;

--
-- TOC entry 62 (class 1255 OID 619708)
-- Dependencies: 6
-- Name: domain_name_removeall(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION domain_name_removeall() RETURNS void
    LANGUAGE sql
    AS $$delete from domain_name$$;


ALTER FUNCTION public.domain_name_removeall() OWNER TO postgres;

--
-- TOC entry 63 (class 1255 OID 619709)
-- Dependencies: 1057 6
-- Name: donotscan_delete(character varying[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION donotscan_delete(subnets character varying[]) RETURNS boolean
    LANGUAGE plpgsql
    AS $$

BEGIN
	delete from donotscan where subnetmask = any(subnets);	
	return true;
EXCEPTION    
	WHEN OTHERS THEN   
		return false;		
END;

  $$;


ALTER FUNCTION public.donotscan_delete(subnets character varying[]) OWNER TO postgres;

--
-- TOC entry 2265 (class 1259 OID 619710)
-- Dependencies: 6
-- Name: donotscan_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE donotscan_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.donotscan_id_seq OWNER TO postgres;

--
-- TOC entry 3818 (class 0 OID 0)
-- Dependencies: 2265
-- Name: donotscan_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('donotscan_id_seq', 1, true);


--
-- TOC entry 2266 (class 1259 OID 619712)
-- Dependencies: 2907 2908 6
-- Name: donotscan; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE donotscan (
    id integer DEFAULT nextval('donotscan_id_seq'::regclass) NOT NULL,
    groupid integer NOT NULL,
    subnetmask character varying(32) NOT NULL,
    scanfrom integer DEFAULT (-1) NOT NULL,
    snmpro character varying(128)
);


ALTER TABLE public.donotscan OWNER TO postgres;

--
-- TOC entry 64 (class 1255 OID 619717)
-- Dependencies: 1057 631 6
-- Name: donotscan_retrieve(timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION donotscan_retrieve(dt timestamp without time zone, stypename character varying) RETURNS SETOF donotscan
    LANGUAGE plpgsql
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

  $$;


ALTER FUNCTION public.donotscan_retrieve(dt timestamp without time zone, stypename character varying) OWNER TO postgres;

--
-- TOC entry 65 (class 1255 OID 619718)
-- Dependencies: 631 6 1057
-- Name: donotscan_upsert(donotscan); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION donotscan_upsert(oui donotscan) RETURNS integer
    LANGUAGE plpgsql
    AS $$
declare	
	t_id integer;
BEGIN	
	select id into t_id from donotscan where subnetmask=oui.subnetmask;
	if t_id IS NULL THEN
		insert into donotscan(
			groupid,
			subnetmask,
			scanfrom,
			snmpro			
			)
			values ( 
			oui.groupid,
			oui.subnetmask,
			oui.scanfrom,
			oui.snmpro
		);

		return lastval();
	ELSE
		update donotscan set ( 
			groupid,
			subnetmask,
			scanfrom,
			snmpro
			)
			=( 
			oui.groupid,
			oui.subnetmask,
			oui.scanfrom,
			oui.snmpro
			) 
			where id = t_id;
		return t_id;
	end if;
EXCEPTION
	WHEN OTHERS THEN 
		RETURN -2;
END;

  $$;


ALTER FUNCTION public.donotscan_upsert(oui donotscan) OWNER TO postgres;

--
-- TOC entry 2267 (class 1259 OID 619719)
-- Dependencies: 2910 6
-- Name: interface_customized_info; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE interface_customized_info (
    id integer NOT NULL,
    objectid integer NOT NULL,
    attributeid integer NOT NULL,
    attribute_value character varying(256),
    lasttimestamp timestamp without time zone DEFAULT now()
);


ALTER TABLE public.interface_customized_info OWNER TO postgres;

--
-- TOC entry 2268 (class 1259 OID 619723)
-- Dependencies: 2911 2912 2913 2914 2915 2916 2917 2918 2919 2920 2921 2922 6
-- Name: interfacesetting; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE interfacesetting (
    id integer NOT NULL,
    deviceid integer NOT NULL,
    interfacename text NOT NULL,
    usermodifiedflag integer DEFAULT 0,
    livestatus integer DEFAULT (-1),
    mibindex integer DEFAULT (-1),
    bandwidth integer DEFAULT (-1),
    macaddress text,
    lasttimestamp timestamp without time zone DEFAULT now() NOT NULL,
    interface_ip character varying(64),
    module_slot character varying(256) DEFAULT '-1'::character varying NOT NULL,
    module_type character varying(256),
    interface_status character varying(256),
    speed_int character varying(256) DEFAULT '-1'::character varying,
    duplex character varying(256) DEFAULT '-1'::character varying,
    description character varying(256),
    mpls_vrf character varying(256),
    vlan character varying(256),
    voice_vlan character varying(256),
    mask integer DEFAULT 32,
    routing_protocol character varying(256),
    portmode character varying(256),
    multicast_mode character varying(256),
    counter character varying(255),
    isphysical integer DEFAULT 0 NOT NULL,
    interfacefullname text DEFAULT ''::text NOT NULL,
    ordernumber integer DEFAULT (-1) NOT NULL
);
ALTER TABLE ONLY interfacesetting ALTER COLUMN module_slot SET STORAGE PLAIN;


ALTER TABLE public.interfacesetting OWNER TO postgres;

--
-- TOC entry 3819 (class 0 OID 0)
-- Dependencies: 2268
-- Name: COLUMN interfacesetting.mpls_vrf; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN interfacesetting.mpls_vrf IS 'search item';


--
-- TOC entry 3820 (class 0 OID 0)
-- Dependencies: 2268
-- Name: COLUMN interfacesetting.vlan; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN interfacesetting.vlan IS 'search item';


--
-- TOC entry 3821 (class 0 OID 0)
-- Dependencies: 2268
-- Name: COLUMN interfacesetting.voice_vlan; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN interfacesetting.voice_vlan IS 'search item';


--
-- TOC entry 3822 (class 0 OID 0)
-- Dependencies: 2268
-- Name: COLUMN interfacesetting.multicast_mode; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN interfacesetting.multicast_mode IS 'search item';


--
-- TOC entry 2269 (class 1259 OID 619741)
-- Dependencies: 2619 6
-- Name: interface_customized_infoview; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW interface_customized_infoview AS
    SELECT interface_customized_info.id, interface_customized_info.objectid, interface_customized_info.attributeid, interface_customized_info.attribute_value, interface_customized_info.lasttimestamp, interfacesetting.interfacename, (SELECT devices.strname FROM devices WHERE (devices.id = interfacesetting.deviceid)) AS devicename FROM interface_customized_info, interfacesetting WHERE (interface_customized_info.objectid = interfacesetting.id) ORDER BY interface_customized_info.id;


ALTER TABLE public.interface_customized_infoview OWNER TO postgres;

--
-- TOC entry 66 (class 1255 OID 619745)
-- Dependencies: 6 1057 638
-- Name: interface_customized_infoview_delete(interface_customized_infoview); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION interface_customized_infoview_delete(dp interface_customized_infoview) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
declare
	r_id integer;
	ds_id integer;
BEGIN
	select id into r_id from devices where strname=dp.devicename;
	if r_id IS NULL THEN
		return false;
	end if;

	select id into ds_id from interfacesetting where deviceid=r_id and interfacename=dp.interfacename ;
	if ds_id IS NULL THEN
		return false;
	end if;
	
	delete from interface_customized_info where objectid=ds_id;	
	return true;
END;

  $$;


ALTER FUNCTION public.interface_customized_infoview_delete(dp interface_customized_infoview) OWNER TO postgres;

--
-- TOC entry 67 (class 1255 OID 619746)
-- Dependencies: 1057 638 6
-- Name: interface_customized_infoview_upsert(interface_customized_infoview); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION interface_customized_infoview_upsert(dciv interface_customized_infoview) RETURNS integer
    LANGUAGE plpgsql
    AS $$
declare
	r_id integer;
	ds_id integer;
	t_id integer;
BEGIN
	select id into r_id from devices where strname=dciv.devicename;
	if r_id IS NULL THEN
		return -1;
	end if;

	select id into ds_id from interfacesetting where deviceid=r_id and interfacename=dciv.interfacename ;
	if ds_id IS NULL THEN
		return -1;
	end if;

	select id into t_id from interface_customized_info where objectid=ds_id and attributeid=dciv.attributeid ;
	if t_id IS NULL THEN		
		insert into interface_customized_info(
			objectid,
			attributeid,
			attribute_value
			)
			values ( 
			ds_id,
			dciv.attributeid,
			dciv.attribute_value
		);

		return lastval();
	ELSE
		update interface_customized_info set ( attribute_value)=( dciv.attribute_value ) where id = t_id;
		return t_id;
	end if;
END;

  $$;


ALTER FUNCTION public.interface_customized_infoview_upsert(dciv interface_customized_infoview) OWNER TO postgres;

--
-- TOC entry 2270 (class 1259 OID 619747)
-- Dependencies: 2620 6
-- Name: interfacenameview; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW interfacenameview AS
    SELECT interfacesetting.interfacename FROM interfacesetting;


ALTER TABLE public.interfacenameview OWNER TO postgres;

--
-- TOC entry 68 (class 1255 OID 619751)
-- Dependencies: 640 1057 6
-- Name: interface_list_groupbydevice(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION interface_list_groupbydevice(devname character varying) RETURNS SETOF interfacenameview
    LANGUAGE plpgsql
    AS $$
declare
	rec interfacenameview;
	indextmp integer;
	ndevcount integer;
BEGIN
	for rec in select interfacename from interfacesettingview where devicename=devname loop
		return next rec;
	end loop;
	return;
END;

  $$;


ALTER FUNCTION public.interface_list_groupbydevice(devname character varying) OWNER TO postgres;

--
-- TOC entry 69 (class 1255 OID 619752)
-- Dependencies: 635 6 1057
-- Name: interface_setting_retrieve(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION interface_setting_retrieve(devname character varying, ifname character varying) RETURNS SETOF interfacesetting
    LANGUAGE plpgsql
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

  $$;


ALTER FUNCTION public.interface_setting_retrieve(devname character varying, ifname character varying) OWNER TO postgres;

--
-- TOC entry 70 (class 1255 OID 619753)
-- Dependencies: 635 6 1057
-- Name: interface_setting_retrieve_by_devs(character varying[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION interface_setting_retrieve_by_devs(devnames character varying[]) RETURNS SETOF interfacesetting
    LANGUAGE plpgsql
    AS $$
declare
	r interfacesetting%rowtype;
BEGIN
	for r in SELECT * FROM interfacesetting where deviceid IN ( select id from devices where strname = any( devnames ) ) loop
	return next r;
	end loop;
END;

  $$;


ALTER FUNCTION public.interface_setting_retrieve_by_devs(devnames character varying[]) OWNER TO postgres;

--
-- TOC entry 71 (class 1255 OID 619754)
-- Dependencies: 6 635 1057
-- Name: interface_setting_update(character varying, interfacesetting); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION interface_setting_update(devname character varying, ins interfacesetting) RETURNS integer
    LANGUAGE plpgsql
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
		  lasttimestamp,
		  interface_ip,
			  module_slot,
			  module_type,
			  interface_status,
			  speed_int,
			  duplex,
			  description,
			  mpls_vrf,
			  vlan,
			  voice_vlan,
			  mask,
			  routing_protocol,
			  portmode,
			  multicast_mode,
			  counter,
			  isphysical,
			  interfacefullname,
			ordernumber
		  ) = ( 
		  ins.usermodifiedflag,
		  ins.livestatus,
		  ins.mibindex,
		  ins.bandwidth,
		  ins.macaddress,
		  ins.lasttimestamp,
		  ins.interface_ip,
			  ins.module_slot,
			  ins.module_type,
			  ins.interface_status,
			  ins.speed_int,
			  ins.duplex,
			  ins.description,
			  ins.mpls_vrf,
			  ins.vlan,
			  ins.voice_vlan,
			  ins.mask,
			  ins.routing_protocol,
			  ins.portmode,
			  ins.multicast_mode,
			  ins.counter,
			  ins.isphysical,
			  ins.interfacefullname,
			ins.ordernumber
		  ) 
		  where id = ds_id;
		return ds_id;
	end if;
EXCEPTION
	WHEN OTHERS THEN 
		RETURN -2;	
END;

  $$;


ALTER FUNCTION public.interface_setting_update(devname character varying, ins interfacesetting) OWNER TO postgres;

--
-- TOC entry 72 (class 1255 OID 619755)
-- Dependencies: 635 1057 6
-- Name: interface_setting_upsert(character varying, interfacesetting); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION interface_setting_upsert(devname character varying, ins interfacesetting) RETURNS integer
    LANGUAGE plpgsql
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
			  macaddress,
			  interface_ip,
			  module_slot,
			  module_type,
			  interface_status,
			  speed_int,
			  duplex,
			  description,
			  mpls_vrf,
			  vlan,
			  voice_vlan,
			  mask,
			  routing_protocol,
			  portmode,
			  multicast_mode,
			  counter,
			  isphysical,
			  interfacefullname,
			  ordernumber
			  )
			  values( 
			  r_id,
			  ins.interfacename,
			  ins.usermodifiedflag,
			  ins.livestatus,
			  ins.mibindex,
			  ins.bandwidth,
			  ins.macaddress,
			  ins.interface_ip,
			  ins.module_slot,
			  ins.module_type,
			  ins.interface_status,
			  ins.speed_int,
			  ins.duplex,
			  ins.description,
			  ins.mpls_vrf,
			  ins.vlan,
			  ins.voice_vlan,
			  ins.mask,
			  ins.routing_protocol,
			  ins.portmode,
			  ins.multicast_mode,
			  ins.counter,
			  ins.isphysical,
			  ins.interfacefullname,
			  ins.ordernumber
			  );
			  return lastval();
	else
		update interfacesetting set(
			  usermodifiedflag,
			  livestatus,
			  mibindex,
			  bandwidth,
			  macaddress,
			  lasttimestamp,
			  interface_ip,
			  module_slot,
			  module_type,
			  interface_status,
			  speed_int,
			  duplex,
			  description,
			  mpls_vrf,
			  vlan,
			  voice_vlan,
			  mask,
			  routing_protocol,
			  portmode,
			  multicast_mode,
			  counter,
			  isphysical,
			  interfacefullname,
			  ordernumber
			  ) = ( 
			  ins.usermodifiedflag,
			  ins.livestatus,
			  ins.mibindex,
			  ins.bandwidth,
			  ins.macaddress,
			  now(),
			  ins.interface_ip,
			  ins.module_slot,
			  ins.module_type,
			  ins.interface_status,
			  ins.speed_int,
			  ins.duplex,
			  ins.description,
			  ins.mpls_vrf,
			  ins.vlan,
			  ins.voice_vlan,
			  ins.mask,
			  ins.routing_protocol,
			  ins.portmode,
			  ins.multicast_mode,
			  ins.counter,
			  ins.isphysical,
			  ins.interfacefullname,
			  ins.ordernumber
			  ) 
			  where id = ds_id and ( usermodifiedflag != ins.usermodifiedflag or livestatus != ins.livestatus or mibindex != ins.mibindex or bandwidth != ins.bandwidth or macaddress != ins.macaddress or interface_ip != ins.interface_ip or module_slot != ins.module_slot or module_type != ins.module_type or interface_status != ins.interface_status or speed_int != ins.speed_int or duplex != ins.duplex or description != ins.description or mpls_vrf != ins.mpls_vrf or vlan != ins.vlan or voice_vlan != ins.voice_vlan or mask != ins.mask or routing_protocol != ins.routing_protocol or portmode != ins.portmode or multicast_mode != ins.multicast_mode or counter != ins.counter or isphysical !=ins.isphysical or interfacefullname != ins.interfacefullname or ordernumber != ins.ordernumber );
		return ds_id;
	end if;
EXCEPTION
	WHEN OTHERS THEN 
		RETURN -2;	
END;

  $$;


ALTER FUNCTION public.interface_setting_upsert(devname character varying, ins interfacesetting) OWNER TO postgres;

--
-- TOC entry 2271 (class 1259 OID 619756)
-- Dependencies: 2621 6
-- Name: interfacesettingview; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW interfacesettingview AS
    SELECT interfacesetting.id, interfacesetting.deviceid, interfacesetting.interfacename, interfacesetting.usermodifiedflag, interfacesetting.livestatus, interfacesetting.mibindex, interfacesetting.bandwidth, interfacesetting.macaddress, interfacesetting.lasttimestamp, interfacesetting.interface_ip, interfacesetting.module_slot, interfacesetting.module_type, interfacesetting.interface_status, interfacesetting.speed_int, interfacesetting.duplex, interfacesetting.description, interfacesetting.mpls_vrf, interfacesetting.vlan, interfacesetting.voice_vlan, interfacesetting.mask, interfacesetting.routing_protocol, interfacesetting.portmode, interfacesetting.multicast_mode, interfacesetting.counter, interfacesetting.isphysical, devices.strname AS devicename, interfacesetting.interfacefullname, interfacesetting.ordernumber FROM interfacesetting, devices WHERE (devices.id = interfacesetting.deviceid) ORDER BY interfacesetting.id;


ALTER TABLE public.interfacesettingview OWNER TO postgres;

--
-- TOC entry 73 (class 1255 OID 619761)
-- Dependencies: 642 6 1057
-- Name: interface_setting_upsert2(character varying, interfacesettingview); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION interface_setting_upsert2(devname character varying, ins interfacesettingview) RETURNS integer
    LANGUAGE plpgsql
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
			  macaddress,
			  interface_ip,
			  module_slot,
			  module_type,
			  interface_status,
			  speed_int,
			  duplex,
			  description,
			  mpls_vrf,
			  vlan,
			  voice_vlan,
			  mask,
			  routing_protocol,
			  portmode,
			  multicast_mode,
			  counter,
			  isphysical,
			  interfacefullname,
			  ordernumber
			  )
			  values( 
			  r_id,
			  ins.interfacename,
			  ins.usermodifiedflag,
			  ins.livestatus,
			  ins.mibindex,
			  ins.bandwidth,
			  ins.macaddress,
			  ins.interface_ip,
			  ins.module_slot,
			  ins.module_type,
			  ins.interface_status,
			  ins.speed_int,
			  ins.duplex,
			  ins.description,
			  ins.mpls_vrf,
			  ins.vlan,
			  ins.voice_vlan,
			  ins.mask,
			  ins.routing_protocol,
			  ins.portmode,
			  ins.multicast_mode,
			  ins.counter,
			  ins.isphysical,
			  ins.interfacefullname,
			  ins.ordernumber
			  );
			  return lastval();
	else
		update interfacesetting set(
			  usermodifiedflag,
			  livestatus,
			  mibindex,
			  bandwidth,
			  macaddress,
			  lasttimestamp,
			  interface_ip,
			  module_slot,
			  module_type,
			  interface_status,
			  speed_int,
			  duplex,
			  description,
			  mpls_vrf,
			  vlan,
			  voice_vlan,
			  mask,
			  routing_protocol,
			  portmode,
			  multicast_mode,
			  counter,
			  isphysical,
			  interfacefullname,
			  ordernumber
			  ) = ( 
			  ins.usermodifiedflag,
			  ins.livestatus,
			  ins.mibindex,
			  ins.bandwidth,
			  ins.macaddress,
			  now(),
			  ins.interface_ip,
			  ins.module_slot,
			  ins.module_type,
			  ins.interface_status,
			  ins.speed_int,
			  ins.duplex,
			  ins.description,
			  ins.mpls_vrf,
			  ins.vlan,
			  ins.voice_vlan,
			  ins.mask,
			  ins.routing_protocol,
			  ins.portmode,
			  ins.multicast_mode,
			  ins.counter,
			  ins.isphysical,
			  ins.interfacefullname,
			  ins.ordernumber
			  ) 
			  where id = ds_id and ( usermodifiedflag != ins.usermodifiedflag or livestatus != ins.livestatus or mibindex != ins.mibindex or bandwidth != ins.bandwidth or macaddress != ins.macaddress or interface_ip != ins.interface_ip or module_slot != ins.module_slot or module_type != ins.module_type or interface_status != ins.interface_status or speed_int != ins.speed_int or duplex != ins.duplex or description != ins.description or mpls_vrf != ins.mpls_vrf or vlan != ins.vlan or voice_vlan != ins.voice_vlan or mask != ins.mask or routing_protocol != ins.routing_protocol or portmode != ins.portmode or multicast_mode != ins.multicast_mode or counter != ins.counter or isphysical !=ins.isphysical or interfacefullname != ins.interfacefullname or ordernumber != ins.ordernumber );
		return ds_id;
	end if;
EXCEPTION
	WHEN OTHERS THEN 
		RETURN -2;	
END;

  $$;


ALTER FUNCTION public.interface_setting_upsert2(devname character varying, ins interfacesettingview) OWNER TO postgres;

--
-- TOC entry 74 (class 1255 OID 619762)
-- Dependencies: 1057 6
-- Name: ip_2_mac_delete_by_key(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ip_2_mac_delete_by_key(rip character varying, rmac character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN
	delete from ip2mac where ip=rip AND mac=rmac;
	return 0;
END;

  $$;


ALTER FUNCTION public.ip_2_mac_delete_by_key(rip character varying, rmac character varying) OWNER TO postgres;

--
-- TOC entry 75 (class 1255 OID 619763)
-- Dependencies: 1057 6
-- Name: ip_2_mac_delete_by_lan(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ip_2_mac_delete_by_lan(l character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN
	delete from ip2mac where lan = l;
	return 0;
END;

  $$;


ALTER FUNCTION public.ip_2_mac_delete_by_lan(l character varying) OWNER TO postgres;

--
-- TOC entry 2272 (class 1259 OID 619764)
-- Dependencies: 2924 2925 6
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
    interfacename text,
    switchname character varying(64),
    portname character varying(64),
    vlan integer DEFAULT 1,
    userflag integer DEFAULT 0,
    servertype integer NOT NULL,
    retrievedate timestamp without time zone NOT NULL
);


ALTER TABLE public.ip2mac OWNER TO postgres;

--
-- TOC entry 76 (class 1255 OID 619772)
-- Dependencies: 644 1057 6
-- Name: ip_2_mac_retrieve_by_device(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ip_2_mac_retrieve_by_device(i character varying) RETURNS SETOF ip2mac
    LANGUAGE plpgsql
    AS $$
declare
	r ip2mac%rowtype;
BEGIN
   for r in SELECT * FROM ip2mac where devicename = i loop
   return next r;
   end loop;
END;

  $$;


ALTER FUNCTION public.ip_2_mac_retrieve_by_device(i character varying) OWNER TO postgres;

--
-- TOC entry 77 (class 1255 OID 619773)
-- Dependencies: 644 1057 6
-- Name: ip_2_mac_retrieve_by_device_interface(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ip_2_mac_retrieve_by_device_interface(d character varying, i character varying) RETURNS SETOF ip2mac
    LANGUAGE plpgsql
    AS $$
declare
	r ip2mac%rowtype;
BEGIN
   for r in SELECT * FROM ip2mac where devicename = d AND interfacename = i loop
   return next r;
   end loop;
END;

  $$;


ALTER FUNCTION public.ip_2_mac_retrieve_by_device_interface(d character varying, i character varying) OWNER TO postgres;

--
-- TOC entry 78 (class 1255 OID 619774)
-- Dependencies: 1057 6 644
-- Name: ip_2_mac_retrieve_by_ip(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ip_2_mac_retrieve_by_ip(i character varying) RETURNS SETOF ip2mac
    LANGUAGE plpgsql
    AS $$
declare
	r ip2mac%rowtype;
BEGIN
   for r in SELECT * FROM ip2mac where ip = i loop
   return next r;
   end loop;
END;

  $$;


ALTER FUNCTION public.ip_2_mac_retrieve_by_ip(i character varying) OWNER TO postgres;

--
-- TOC entry 38 (class 1255 OID 619775)
-- Dependencies: 644 6 1057
-- Name: ip_2_mac_retrieve_by_lan(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ip_2_mac_retrieve_by_lan(lanname character varying) RETURNS SETOF ip2mac
    LANGUAGE plpgsql
    AS $$
declare
	r ip2mac%rowtype;
BEGIN
   for r in SELECT * FROM ip2mac where lan = lanname loop
   return next r;
   end loop;
END;

  $$;


ALTER FUNCTION public.ip_2_mac_retrieve_by_lan(lanname character varying) OWNER TO postgres;

--
-- TOC entry 54 (class 1255 OID 619776)
-- Dependencies: 1057 6 644
-- Name: ip_2_mac_retrieve_by_mac(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ip_2_mac_retrieve_by_mac(m character varying) RETURNS SETOF ip2mac
    LANGUAGE plpgsql
    AS $$
declare
	r ip2mac%rowtype;
BEGIN
   for r in SELECT * FROM ip2mac where mac = m loop
   return next r;
   end loop;
END;

  $$;


ALTER FUNCTION public.ip_2_mac_retrieve_by_mac(m character varying) OWNER TO postgres;

--
-- TOC entry 55 (class 1255 OID 619777)
-- Dependencies: 1057 6 644
-- Name: ip_2_mac_retrieve_by_switch(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ip_2_mac_retrieve_by_switch(i character varying) RETURNS SETOF ip2mac
    LANGUAGE plpgsql
    AS $$
declare
	r ip2mac%rowtype;
BEGIN
   for r in SELECT * FROM ip2mac where switchname = i loop
   return next r;
   end loop;
END;

  $$;


ALTER FUNCTION public.ip_2_mac_retrieve_by_switch(i character varying) OWNER TO postgres;

--
-- TOC entry 79 (class 1255 OID 619778)
-- Dependencies: 1057 6 644
-- Name: ip_2_mac_retrieve_by_switch_port(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ip_2_mac_retrieve_by_switch_port(s character varying, p character varying) RETURNS SETOF ip2mac
    LANGUAGE plpgsql
    AS $$
declare
	r ip2mac%rowtype;
BEGIN
   for r in SELECT * FROM ip2mac where switchname = s AND portname=p loop
   return next r;
   end loop;
END;

  $$;


ALTER FUNCTION public.ip_2_mac_retrieve_by_switch_port(s character varying, p character varying) OWNER TO postgres;

--
-- TOC entry 80 (class 1255 OID 619779)
-- Dependencies: 1057 6 644
-- Name: ip_2_mac_retrieve_like_ip(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ip_2_mac_retrieve_like_ip(i character varying) RETURNS SETOF ip2mac
    LANGUAGE plpgsql
    AS $$
declare
	r ip2mac%rowtype;
BEGIN
	for r in SELECT * FROM ip2mac where ip like '%'||i||'%' loop
	return next r;
	end loop;
END;

  $$;


ALTER FUNCTION public.ip_2_mac_retrieve_like_ip(i character varying) OWNER TO postgres;

--
-- TOC entry 81 (class 1255 OID 619780)
-- Dependencies: 1057 6 644
-- Name: ip_2_mac_retrieve_like_lan(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ip_2_mac_retrieve_like_lan(l character varying) RETURNS SETOF ip2mac
    LANGUAGE plpgsql
    AS $$
declare
	r ip2mac%rowtype;
BEGIN
	for r in SELECT * FROM ip2mac where lan like '%'||l||'%' loop
	return next r;
	end loop;
END;

  $$;


ALTER FUNCTION public.ip_2_mac_retrieve_like_lan(l character varying) OWNER TO postgres;

--
-- TOC entry 82 (class 1255 OID 619781)
-- Dependencies: 1057 6 644
-- Name: ip_2_mac_retrieve_like_mac(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ip_2_mac_retrieve_like_mac(m character varying) RETURNS SETOF ip2mac
    LANGUAGE plpgsql
    AS $$
declare
	r ip2mac%rowtype;
BEGIN
	for r in SELECT * FROM ip2mac where mac like '%'||m||'%' loop
	return next r;
	end loop;
END;

  $$;


ALTER FUNCTION public.ip_2_mac_retrieve_like_mac(m character varying) OWNER TO postgres;

--
-- TOC entry 83 (class 1255 OID 619782)
-- Dependencies: 1057 6 644
-- Name: ip_2_mac_upsert(ip2mac); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ip_2_mac_upsert(r ip2mac) RETURNS integer
    LANGUAGE plpgsql
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

  $$;


ALTER FUNCTION public.ip_2_mac_upsert(r ip2mac) OWNER TO postgres;

--
-- TOC entry 84 (class 1255 OID 619783)
-- Dependencies: 1057 6 644
-- Name: ip_2_mac_upsert(ip2mac, integer, integer[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ip_2_mac_upsert(r ip2mac, onlymac integer, subtypes integer[]) RETURNS integer
    LANGUAGE plpgsql
    AS $$
declare
	ds_id integer;
BEGIN
        if onlymac = 0 then
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
				  ip,
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
				  r.ip,
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
	else
		delete from ip2mac where mac=r.mac and servertype =any(subtypes);
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
	end if;		
EXCEPTION
	WHEN OTHERS THEN 
		RETURN -2;	
END;

  $$;


ALTER FUNCTION public.ip_2_mac_upsert(r ip2mac, onlymac integer, subtypes integer[]) OWNER TO postgres;

--
-- TOC entry 85 (class 1255 OID 619784)
-- Dependencies: 6 1057
-- Name: l2_connectivity_delete_by_group(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION l2_connectivity_delete_by_group(g character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN
	delete from l2connectivity where sourcedevice in ( select strname from devices where id in ( select deviceid from swtichgroupdevice where switchgroupid in ( select id from switchgroup where strname = g ) ) );
	delete from l2connectivity where destdevice in ( select strname from devices where id in ( select deviceid from swtichgroupdevice where switchgroupid in ( select id from switchgroup where strname = g ) ) );
	return 0;
END;

  $$;


ALTER FUNCTION public.l2_connectivity_delete_by_group(g character varying) OWNER TO postgres;

--
-- TOC entry 86 (class 1255 OID 619785)
-- Dependencies: 6 1057
-- Name: l2_connectivity_delete_by_key(character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION l2_connectivity_delete_by_key(sd character varying, sp character varying, dd character varying, dp character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN
	delete from l2connectivity where ( sourcedevice=sd AND sourceport=sp AND destdevice=dd AND destport=dp ) OR ( sourcedevice=dd AND sourceport=dp AND destdevice=sd AND destport=sp );
	return 0;
END;

  $$;


ALTER FUNCTION public.l2_connectivity_delete_by_key(sd character varying, sp character varying, dd character varying, dp character varying) OWNER TO postgres;

--
-- TOC entry 2273 (class 1259 OID 619786)
-- Dependencies: 2927 2928 2929 2930 6
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
-- TOC entry 87 (class 1255 OID 619793)
-- Dependencies: 6 1057 647
-- Name: l2_connectivity_retrieve_by_switch_port(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION l2_connectivity_retrieve_by_switch_port(s character varying, p character varying) RETURNS SETOF l2connectivity
    LANGUAGE plpgsql
    AS $$
declare
	r l2connectivity%rowtype;
BEGIN
	for r in SELECT * FROM l2connectivity where ( sourcedevice = s AND sourceport=p ) OR (destdevice = s AND destport=p) loop
	return next r;
	end loop;
END;

  $$;


ALTER FUNCTION public.l2_connectivity_retrieve_by_switch_port(s character varying, p character varying) OWNER TO postgres;

--
-- TOC entry 88 (class 1255 OID 619794)
-- Dependencies: 647 6 1057
-- Name: l2_connectivity_retrieve_like_device(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION l2_connectivity_retrieve_like_device(d character varying) RETURNS SETOF l2connectivity
    LANGUAGE plpgsql
    AS $$
declare
	r l2connectivity%rowtype;
BEGIN
	for r in SELECT * FROM l2connectivity where sourcedevice like '%'||d||'%' OR destdevice like '%'||d||'%' loop
	return next r;
	end loop;
END;

  $$;


ALTER FUNCTION public.l2_connectivity_retrieve_like_device(d character varying) OWNER TO postgres;

--
-- TOC entry 89 (class 1255 OID 619795)
-- Dependencies: 1057 6 647
-- Name: l2_connectivity_upsert(l2connectivity); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION l2_connectivity_upsert(r l2connectivity) RETURNS integer
    LANGUAGE plpgsql
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

  $$;


ALTER FUNCTION public.l2_connectivity_upsert(r l2connectivity) OWNER TO postgres;

--
-- TOC entry 2274 (class 1259 OID 619796)
-- Dependencies: 2933 6
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
-- TOC entry 3823 (class 0 OID 0)
-- Dependencies: 2274
-- Name: COLUMN l2switchinfo.usermodifed; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN l2switchinfo.usermodifed IS '0: org  1: discovery  2: manual';


--
-- TOC entry 90 (class 1255 OID 619800)
-- Dependencies: 1057 6 649
-- Name: l2_switchinfo_upsert(l2switchinfo); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION l2_switchinfo_upsert(r l2switchinfo) RETURNS integer
    LANGUAGE plpgsql
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

  $$;


ALTER FUNCTION public.l2_switchinfo_upsert(r l2switchinfo) OWNER TO postgres;

--
-- TOC entry 91 (class 1255 OID 619801)
-- Dependencies: 6 1057
-- Name: lan_switch_delete_by_key(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION lan_switch_delete_by_key(l character varying, s character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN
	delete from lanswitch where lanname=l AND switchname=s;
	return 0;
END;

  $$;


ALTER FUNCTION public.lan_switch_delete_by_key(l character varying, s character varying) OWNER TO postgres;

--
-- TOC entry 92 (class 1255 OID 619802)
-- Dependencies: 6 1057
-- Name: lan_switch_delete_by_lan(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION lan_switch_delete_by_lan(l character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN
	delete from lanswitch where lanname=l;
	return 0;
EXCEPTION
	WHEN OTHERS THEN 
		RETURN -2;	
END;

  $$;


ALTER FUNCTION public.lan_switch_delete_by_lan(l character varying) OWNER TO postgres;

--
-- TOC entry 2275 (class 1259 OID 619803)
-- Dependencies: 2934 2935 6
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
-- TOC entry 93 (class 1255 OID 619811)
-- Dependencies: 1057 6 651
-- Name: lan_switch_retrieve_by_lan(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION lan_switch_retrieve_by_lan(lan character varying) RETURNS SETOF lanswitch
    LANGUAGE plpgsql
    AS $$
declare
	r lanswitch%rowtype;
BEGIN
   for r in SELECT * FROM lanswitch where lanname = lan loop
   return next r;
   end loop;
END;

  $$;


ALTER FUNCTION public.lan_switch_retrieve_by_lan(lan character varying) OWNER TO postgres;

--
-- TOC entry 94 (class 1255 OID 619812)
-- Dependencies: 1057 6 651
-- Name: lan_switch_upsert(lanswitch); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION lan_switch_upsert(r lanswitch) RETURNS integer
    LANGUAGE plpgsql
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

  $$;


ALTER FUNCTION public.lan_switch_upsert(r lanswitch) OWNER TO postgres;

--
-- TOC entry 95 (class 1255 OID 619813)
-- Dependencies: 6 1057
-- Name: linkgroup_param_delete(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION linkgroup_param_delete(lid integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
	delete from linkgroup_param where linkgroupid = lid;
	return true;
END;
$$;


ALTER FUNCTION public.linkgroup_param_delete(lid integer) OWNER TO postgres;

--
-- TOC entry 2276 (class 1259 OID 619814)
-- Dependencies: 2937 2938 2939 2940 2941 6
-- Name: linkgroup; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE linkgroup (
    id integer NOT NULL,
    strname character varying(64),
    strdesc character varying(256),
    showcolor integer,
    showstyle integer,
    showwidth integer,
    userid integer DEFAULT (-1) NOT NULL,
    searchcondition text,
    searchcontainer integer DEFAULT (-1),
    dev_searchcondition text,
    dev_searchcontainer integer DEFAULT 1,
    is_map_auto_link boolean DEFAULT true NOT NULL,
    istemplate boolean DEFAULT false NOT NULL,
    licguid character varying(128)
);


ALTER TABLE public.linkgroup OWNER TO postgres;

--
-- TOC entry 96 (class 1255 OID 619825)
-- Dependencies: 1057 6 654
-- Name: linkgroup_upsert(linkgroup); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION linkgroup_upsert(vm linkgroup) RETURNS integer
    LANGUAGE plpgsql
    AS $$
declare
	vm_id integer;
BEGIN
	select id into vm_id from linkgroup where strname=vm.strname;
	
	if vm_id IS NULL THEN
		insert into linkgroup(
			strname, strdesc, showcolor, showstyle, showwidth,userid,searchcondition,searchcontainer,dev_searchcondition,dev_searchcontainer,is_map_auto_link,istemplate,licguid)
			values( 
			vm.strname, vm.strdesc, vm.showcolor, vm.showstyle, vm.showwidth,vm.userid,vm.searchcondition,vm.searchcontainer,vm.dev_searchcondition,vm.dev_searchcontainer,vm.is_map_auto_link,vm.istemplate,vm.licguid
			);
			return lastval();	
	end if;
EXCEPTION
	WHEN OTHERS THEN 
		RETURN -2;	
END;

  $$;


ALTER FUNCTION public.linkgroup_upsert(vm linkgroup) OWNER TO postgres;

--
-- TOC entry 97 (class 1255 OID 619826)
-- Dependencies: 6 1057
-- Name: linkgroupclear_dev_searchcontainerids(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION linkgroupclear_dev_searchcontainerids(lid integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$			
BEGIN
	delete from linkgroup_dev_devicegroup where groupid=lid;
	delete from linkgroup_dev_site where groupid=lid;
	delete from linkgroup_dev_systemdevicegroup where groupid=lid;
	return 1;
End;
$$;


ALTER FUNCTION public.linkgroupclear_dev_searchcontainerids(lid integer) OWNER TO postgres;

--
-- TOC entry 98 (class 1255 OID 619827)
-- Dependencies: 6 1057
-- Name: linkgroupclearsearchcontainerids(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION linkgroupclearsearchcontainerids(lid integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$			
BEGIN
	delete from linkgroupdevicegroup where groupid=lid;
	delete from linkgroupsite where groupid=lid;
	delete from linkgrouplinkgroup where groupid=lid;
	delete from linkgroupsystemdevicegroup where groupid=lid;
	return 1;
End;
$$;


ALTER FUNCTION public.linkgroupclearsearchcontainerids(lid integer) OWNER TO postgres;

--
-- TOC entry 99 (class 1255 OID 619828)
-- Dependencies: 1057 6
-- Name: linkgroupdevice_delete_bytype(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION linkgroupdevice_delete_bytype(lid integer, ntype integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
	delete from linkgroupdevice where linkgroupid = lid and "type" =ntype;
	return true;
END;
$$;


ALTER FUNCTION public.linkgroupdevice_delete_bytype(lid integer, ntype integer) OWNER TO postgres;

--
-- TOC entry 100 (class 1255 OID 619829)
-- Dependencies: 1057 6
-- Name: linkgroupdevice_delete_dynamic(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION linkgroupdevice_delete_dynamic(lid integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
	delete from linkgroupdevice where linkgroupid = lid and ( "type" = 2  or "type"=4);
	return true;
END;
$$;


ALTER FUNCTION public.linkgroupdevice_delete_dynamic(lid integer) OWNER TO postgres;

--
-- TOC entry 101 (class 1255 OID 619830)
-- Dependencies: 6 1057
-- Name: linkgroupdevice_upsert_bytype2(integer, integer, character varying[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION linkgroupdevice_upsert_bytype2(lid integer, ntype integer, devs character varying[]) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
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
		
		select id into lgi_id from linkgroupdevice where linkgroupid = lid and deviceid = dev_id  and "type" =ntype;
		if lgi_id is null then
			insert into linkgroupdevice (linkgroupid,deviceid,"type") values (lid, dev_id,ntype);
		end if;
	end loop;	
	return true;
END;

  $$;


ALTER FUNCTION public.linkgroupdevice_upsert_bytype2(lid integer, ntype integer, devs character varying[]) OWNER TO postgres;

--
-- TOC entry 102 (class 1255 OID 619831)
-- Dependencies: 6 1057
-- Name: linkgroupdevice_upsert_dynamic(integer, character varying[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION linkgroupdevice_upsert_dynamic(lid integer, devs character varying[]) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    i integer;
    lgd_id integer;
    dev_id integer;
    ex_id integer;
    r_type integer;
BEGIN
	for i in 1..array_length(devs, 1) LOOP
	
		select id into dev_id from devices where strname = devs[i];
		if dev_id is null then
			continue;
		end if;
	
		select id into ex_id from linkgroupdevice where linkgroupid = lid and "type" = 3 and deviceid=dev_id;

		r_type=4;
		if ex_id is null then 
			r_type=2;
		end if;
		
		select id into lgd_id from linkgroupdevice where linkgroupid = lid and "type" = r_type and deviceid=dev_id;
		if lgd_id is null then
			insert into linkgroupdevice (linkgroupid,"type",deviceid) values (lid, r_type, dev_id);
		end if;
		
	end loop;	
	return true;
END;

  $$;


ALTER FUNCTION public.linkgroupdevice_upsert_dynamic(lid integer, devs character varying[]) OWNER TO postgres;

--
-- TOC entry 103 (class 1255 OID 619832)
-- Dependencies: 1057 6
-- Name: linkgroupinterface_delete_bytype(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION linkgroupinterface_delete_bytype(lid integer, ntype integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
	delete from linkgroupinterface where groupid = lid and "type" =ntype;
	return true;
END;
$$;


ALTER FUNCTION public.linkgroupinterface_delete_bytype(lid integer, ntype integer) OWNER TO postgres;

--
-- TOC entry 104 (class 1255 OID 619833)
-- Dependencies: 6 1057
-- Name: linkgroupinterface_delete_dynamic(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION linkgroupinterface_delete_dynamic(lid integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
	delete from linkgroupinterface where groupid = lid and ( "type" = 2  or "type"=4);
	return true;
END;
$$;


ALTER FUNCTION public.linkgroupinterface_delete_dynamic(lid integer) OWNER TO postgres;

--
-- TOC entry 105 (class 1255 OID 619834)
-- Dependencies: 6 1057
-- Name: linkgroupinterface_upsert_bytype2(integer, integer, character varying[], character varying[], character varying[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION linkgroupinterface_upsert_bytype2(lid integer, ntype integer, devs character varying[], intfs character varying[], intfips character varying[]) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
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

  $$;


ALTER FUNCTION public.linkgroupinterface_upsert_bytype2(lid integer, ntype integer, devs character varying[], intfs character varying[], intfips character varying[]) OWNER TO postgres;

--
-- TOC entry 106 (class 1255 OID 619835)
-- Dependencies: 6 1057
-- Name: linkgroupinterface_upsert_dynamic(integer, character varying[], character varying[], character varying[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION linkgroupinterface_upsert_dynamic(lid integer, devs character varying[], intfs character varying[], intfips character varying[]) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
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

  $$;


ALTER FUNCTION public.linkgroupinterface_upsert_dynamic(lid integer, devs character varying[], intfs character varying[], intfips character varying[]) OWNER TO postgres;

--
-- TOC entry 107 (class 1255 OID 619836)
-- Dependencies: 6 1057
-- Name: linkgroupnameexists(character varying, integer, integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION linkgroupnameexists(sname character varying, nid integer, uid integer, iguid character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
	if((select count(*) from linkgroup where id<>nid and lower(strname) =lower(sname) and userid=uid and licguid=iguid)=0) then
		return false;
	end if;
    
    RETURN true;
EXCEPTION
    WHEN OTHERS THEN 
	RETURN false;    
END;
$$;


ALTER FUNCTION public.linkgroupnameexists(sname character varying, nid integer, uid integer, iguid character varying) OWNER TO postgres;

--
-- TOC entry 2277 (class 1259 OID 619837)
-- Dependencies: 2944 6
-- Name: module_customized_info; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE module_customized_info (
    id integer NOT NULL,
    objectid integer NOT NULL,
    attributeid integer NOT NULL,
    attribute_value character varying(256),
    lasttimestamp timestamp without time zone DEFAULT now()
);


ALTER TABLE public.module_customized_info OWNER TO postgres;

--
-- TOC entry 2278 (class 1259 OID 619841)
-- Dependencies: 2945 2946 6
-- Name: module_property; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE module_property (
    id integer NOT NULL,
    deviceid integer NOT NULL,
    slot character varying(256),
    card_type character varying(256),
    ports character varying(256),
    serial_number character varying(256),
    hwrev character varying(256),
    rwrev character varying(256),
    swrev character varying(256),
    card_description character varying(256),
    lasttimestamp timestamp without time zone DEFAULT now() NOT NULL,
    role character varying(256),
    macaddress character varying(256),
    swversion character varying(256),
    swimage character varying(256),
    stackport1conn character varying(256),
    stackport2conn character varying(256),
    isswitch boolean DEFAULT false NOT NULL
);


ALTER TABLE public.module_property OWNER TO postgres;

--
-- TOC entry 2279 (class 1259 OID 619849)
-- Dependencies: 2622 6
-- Name: module_propertyview; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW module_propertyview AS
    SELECT module_property.id, module_property.deviceid, module_property.slot, module_property.card_type, module_property.ports, module_property.serial_number, module_property.hwrev, module_property.rwrev, module_property.swrev, module_property.card_description, module_property.lasttimestamp, module_property.role, module_property.macaddress, module_property.swversion, module_property.swimage, module_property.stackport1conn, module_property.stackport2conn, module_property.isswitch, devices.strname AS devicename FROM module_property, devices WHERE (module_property.deviceid = devices.id) ORDER BY module_property.id;


ALTER TABLE public.module_propertyview OWNER TO postgres;

--
-- TOC entry 2280 (class 1259 OID 619853)
-- Dependencies: 2623 6
-- Name: module_customized_infoview; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW module_customized_infoview AS
    SELECT module_customized_info.id, module_customized_info.objectid, module_customized_info.attributeid, module_customized_info.attribute_value, module_customized_info.lasttimestamp, module_propertyview.devicename, module_propertyview.slot FROM module_customized_info, module_propertyview WHERE (module_customized_info.objectid = module_propertyview.id) ORDER BY module_customized_info.id;


ALTER TABLE public.module_customized_infoview OWNER TO postgres;

--
-- TOC entry 108 (class 1255 OID 619857)
-- Dependencies: 1057 6 664
-- Name: module_customized_infoview_delete(module_customized_infoview); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION module_customized_infoview_delete(dp module_customized_infoview) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
declare
	r_id integer;
	ds_id integer;
BEGIN
	select id into r_id from devices where strname=dp.devicename;
	if r_id IS NULL THEN
		return false;
	end if;

	select id into ds_id from module_property where deviceid=r_id and slot=dp.slot ;
	if ds_id IS NULL THEN
		return false;
	end if;
	
	delete from module_customized_info where objectid=ds_id;	
	return true;
END;

  $$;


ALTER FUNCTION public.module_customized_infoview_delete(dp module_customized_infoview) OWNER TO postgres;

--
-- TOC entry 109 (class 1255 OID 619858)
-- Dependencies: 1057 6 664
-- Name: module_customized_infoview_upsert(module_customized_infoview); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION module_customized_infoview_upsert(dciv module_customized_infoview) RETURNS integer
    LANGUAGE plpgsql
    AS $$
declare
	r_id integer;
	ds_id integer;
	t_id integer;
BEGIN
	select id into r_id from devices where strname=dciv.devicename;
	if r_id IS NULL THEN
		return -1;
	end if;

	select id into ds_id from module_property where deviceid=r_id and slot=dciv.slot ;
	if ds_id IS NULL THEN
		return -1;
	end if;

	select id into t_id from module_customized_info where objectid=ds_id and attributeid=dciv.attributeid ;
	if t_id IS NULL THEN		
		insert into module_customized_info(
			objectid,
			attributeid,
			attribute_value
			)
			values ( 
			ds_id,
			dciv.attributeid,
			dciv.attribute_value
		);

		return lastval();
	ELSE
		update module_customized_info set ( attribute_value)=( dciv.attribute_value ) where id = t_id;
		return t_id;
	end if;
END;

  $$;


ALTER FUNCTION public.module_customized_infoview_upsert(dciv module_customized_infoview) OWNER TO postgres;

--
-- TOC entry 110 (class 1255 OID 619859)
-- Dependencies: 6 662 1057
-- Name: module_property_update(module_propertyview); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION module_property_update(dp module_propertyview) RETURNS integer
    LANGUAGE plpgsql
    AS $$
declare
	r_id integer;
	ds_id integer;
BEGIN
	select id into r_id from devices where strname=dp.devicename;
	if r_id IS NULL THEN
		return -1;
	end if;

	select id into ds_id from module_property where deviceid=r_id and slot=dp.slot;
	if ds_id IS NULL THEN
		return -1;
	ELSE
		update module_property set ( 
			card_type,
			ports,
			serial_number,
			hwrev,
			rwrev,
			swrev,
			card_description,
			"role",
			macaddress,
			swversion,
			swimage,
			stackport1conn,
			stackport2conn,
			isswitch
			)
			=( 
			dp.card_type,
			dp.ports,
			dp.serial_number,
			dp.hwrev,
			dp.rwrev,
			dp.swrev,
			dp.card_description,
			dp.role,
			dp.macaddress,
			dp.swversion,
			dp.swimage,
			dp.stackport1conn,
			dp.stackport2conn,
			dp.isswitch
			) 
			where id = ds_id;
		return ds_id;
	end if;
END;

  $$;


ALTER FUNCTION public.module_property_update(dp module_propertyview) OWNER TO postgres;

--
-- TOC entry 111 (class 1255 OID 619860)
-- Dependencies: 662 6 1057
-- Name: module_property_update2(module_propertyview); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION module_property_update2(dp module_propertyview) RETURNS integer
    LANGUAGE plpgsql
    AS $$
declare
	r_id integer;
	ds_id integer;
BEGIN
	select id into r_id from devices where strname=dp.devicename;
	if r_id IS NULL THEN
		return -1;
	end if;

	select id into ds_id from module_property where deviceid=r_id and slot=dp.slot;
	if ds_id IS NULL THEN
		insert into module_property(
			deviceid,
			slot,
			card_type,
			ports,
			serial_number,
			hwrev,
			rwrev,
			swrev,
			card_description,
			lasttimestamp,
			"role",
			macaddress,
			swversion,
			swimage,
			stackport1conn,
			stackport2conn,
			isswitch
			)
			values ( 
			r_id,
			dp.slot,
			dp.card_type,
			dp.ports,
			dp.serial_number,
			dp.hwrev,
			dp.rwrev,
			dp.swrev,
			dp.card_description,
			now(),
			dp.role,
			dp.macaddress,
			dp.swversion,
			dp.swimage,
			dp.stackport1conn,
			dp.stackport2conn,
			dp.isswitch
		);

		return lastval();
	ELSE
		update module_property set ( 
			card_type,
			ports,
			serial_number,
			hwrev,
			rwrev,
			swrev,
			card_description,
			"role",
			macaddress,
			swversion,
			swimage,
			stackport1conn,
			stackport2conn,
			isswitch
			)
			=( 
			dp.card_type,
			dp.ports,
			dp.serial_number,
			dp.hwrev,
			dp.rwrev,
			dp.swrev,
			dp.card_description,
			dp.role,
			dp.macaddress,
			dp.swversion,
			dp.swimage,
			dp.stackport1conn,
			dp.stackport2conn,
			dp.isswitch
			) 
			where id = ds_id;
		return ds_id;
	end if;
END;

  $$;


ALTER FUNCTION public.module_property_update2(dp module_propertyview) OWNER TO postgres;

--
-- TOC entry 112 (class 1255 OID 619861)
-- Dependencies: 6 1057 662
-- Name: module_property_upsert(module_propertyview); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION module_property_upsert(ds module_propertyview) RETURNS integer
    LANGUAGE plpgsql
    AS $$
declare
	r_id integer;
	ds_id integer;
BEGIN
	select id into r_id from devices where strname=ds.devicename;
	if r_id IS NULL THEN
		return -1;
	end if;

	insert into module_property(
			deviceid,
			slot,
			card_type,
			ports,
			serial_number,
			hwrev,
			rwrev,
			swrev,
			card_description,
			lasttimestamp,
			"role",
			macaddress,
			swversion,
			swimage,
			stackport1conn,
			stackport2conn,
			isswitch
			)
			values ( 
			r_id,
			ds.slot,
			ds.card_type,
			ds.ports,
			ds.serial_number,
			ds.hwrev,
			ds.rwrev,
			ds.swrev,
			ds.card_description,
			now(),
			ds.role,
			ds.macaddress,
			ds.swversion,
			ds.swimage,
			ds.stackport1conn,
			ds.stackport2conn,
			ds.isswitch
		);

		return lastval();

	
END;

  $$;


ALTER FUNCTION public.module_property_upsert(ds module_propertyview) OWNER TO postgres;

--
-- TOC entry 2281 (class 1259 OID 619862)
-- Dependencies: 6
-- Name: object_file_info; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE object_file_info (
    id integer NOT NULL,
    object_id integer NOT NULL,
    object_type integer NOT NULL,
    file_type integer NOT NULL,
    file_real_name character varying(200),
    file_save_name character varying(200) NOT NULL,
    file_update_time timestamp without time zone NOT NULL,
    file_update_userid integer NOT NULL,
    user_property text,
    lasttimestamp timestamp without time zone NOT NULL,
    path_id integer,
    licguid character varying(128)
);


ALTER TABLE public.object_file_info OWNER TO postgres;

--
-- TOC entry 3824 (class 0 OID 0)
-- Dependencies: 2281
-- Name: COLUMN object_file_info.object_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN object_file_info.object_type IS '0-site,1-devicegroup,2-linkgroup';


--
-- TOC entry 3825 (class 0 OID 0)
-- Dependencies: 2281
-- Name: COLUMN object_file_info.file_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN object_file_info.file_type IS '0-map,1-extend doc';


--
-- TOC entry 113 (class 1255 OID 619868)
-- Dependencies: 666 1057 6
-- Name: object_file_info_insert(object_file_info); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION object_file_info_insert(ofile object_file_info) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN	
		insert into object_file_info(
			  object_id,
			  object_type,
			  file_type,
			  file_real_name,
			  file_save_name,
			  file_update_time,
			  file_update_userid,
			  user_property,
			  lasttimestamp,
			  path_id,
			  licguid
			  )
			  values( 			  
			  ofile.object_id,
			  ofile.object_type,
			  ofile.file_type,
			  ofile.file_real_name,
			  ofile.file_save_name,
			  now(),
			  ofile.file_update_userid,
			  ofile.user_property,
			  now(),
			  ofile.path_id,
			  ofile.licguid
			  );
			  return lastval();	
END;

  $$;


ALTER FUNCTION public.object_file_info_insert(ofile object_file_info) OWNER TO postgres;

--
-- TOC entry 114 (class 1255 OID 619869)
-- Dependencies: 666 6 1057
-- Name: object_file_info_update(object_file_info); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION object_file_info_update(ofile object_file_info) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN	
		update object_file_info set ( 
			object_id,
			object_type,
			file_type,
			file_real_name,
			file_save_name,
			file_update_userid,
			user_property,
			lasttimestamp,
			path_id)
			=( 
			ofile.object_id,
			ofile.object_type,
			ofile.file_type,
			ofile.file_real_name,
			ofile.file_save_name,
			ofile.file_update_userid,
			ofile.user_property, 
			now(),
			ofile.path_id
			) 
			where id =ofile.id;
		return ofile.id;	
END;

  $$;


ALTER FUNCTION public.object_file_info_update(ofile object_file_info) OWNER TO postgres;

--
-- TOC entry 2282 (class 1259 OID 619870)
-- Dependencies: 2950 6
-- Name: ouinfo; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ouinfo (
    id integer NOT NULL,
    mac_prefix character varying(10) NOT NULL,
    vendor character varying(256),
    flag boolean DEFAULT false NOT NULL
);


ALTER TABLE public.ouinfo OWNER TO postgres;

--
-- TOC entry 115 (class 1255 OID 619874)
-- Dependencies: 669 1057 6
-- Name: ouinfo_upsert(ouinfo); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ouinfo_upsert(oui ouinfo) RETURNS integer
    LANGUAGE plpgsql
    AS $$
declare	
	oui_id integer;
BEGIN	
	select id into oui_id from ouinfo where mac_prefix=oui.mac_prefix;
	if oui_id IS NULL THEN
		insert into ouinfo(
			mac_prefix,
			vendor,
			flag
			)
			values ( 
			oui.mac_prefix,
			oui.vendor,
			oui.flag
		);

		return lastval();
	ELSE
		update ouinfo set ( 
			mac_prefix,
			vendor,
			flag
			)
			=( 
			oui.mac_prefix,
			oui.vendor,
			oui.flag
			) 
			where id = oui_id;
		return oui_id;
	end if;
EXCEPTION
	WHEN OTHERS THEN 
		RETURN -2;
END;

  $$;


ALTER FUNCTION public.ouinfo_upsert(oui ouinfo) OWNER TO postgres;

--
-- TOC entry 116 (class 1255 OID 619875)
-- Dependencies: 1057 6
-- Name: process_adminpwd_p(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_adminpwd_p() RETURNS trigger
    LANGUAGE plpgsql
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
$$;


ALTER FUNCTION public.process_adminpwd_p() OWNER TO postgres;

--
-- TOC entry 117 (class 1255 OID 619876)
-- Dependencies: 1057 6
-- Name: process_device_customized_info_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_device_customized_info_dt() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
		
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.objectid = NEW.objectid AND 			
			OLD.attributeid = NEW.attributeid AND 			
			OLD.attribute_value = NEW.attribute_value		
		 then
			return OLD;
		end IF;
		update objtimestamp set modifytime=now() where typename='device_customized_info';
		NEW.lasttimestamp=now();	
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='device_customized_info';
		NEW.lasttimestamp=now();
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='device_customized_info';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$$;


ALTER FUNCTION public.process_device_customized_info_dt() OWNER TO postgres;

--
-- TOC entry 118 (class 1255 OID 619877)
-- Dependencies: 6 1057
-- Name: process_device_icon_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_device_icon_dt() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
		
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.icon_name = NEW.icon_name			
		then
			return OLD;
		end IF;		
		NEW.lasttimestamp=now();	
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN				
		NEW.lasttimestamp=now();
		RETURN NEW;        
	ELSIF (TG_OP = 'DELETE') THEN		
		RETURN OLD;		        
        END IF;
        RETURN NULL;
    END;
$$;


ALTER FUNCTION public.process_device_icon_dt() OWNER TO postgres;

--
-- TOC entry 119 (class 1255 OID 619878)
-- Dependencies: 1057 6
-- Name: process_device_property_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_device_property_dt() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
		
    BEGIN
        IF (TG_OP = 'UPDATE') THEN	
		update objtimestamp set modifytime=now() where typename='device_property';
		NEW.lasttimestamp=now();	
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='device_property';
		NEW.lasttimestamp=now();
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='device_property';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$$;


ALTER FUNCTION public.process_device_property_dt() OWNER TO postgres;

--
-- TOC entry 120 (class 1255 OID 619879)
-- Dependencies: 1057 6
-- Name: process_devicegroup_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_devicegroup_dt() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare tid integer;
declare uid integer;
declare iguid character varying;
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.strname = NEW.strname AND 
			OLD.strdesc = NEW.strdesc AND
			OLD.userid = NEW.userid AND			
			OLD.showcolor = NEW.showcolor AND
			OLD.searchcondition= NEW.searchcondition AND
			OLD.searchcontainer = NEW.searchcontainer AND
			OLD.licguid=NEW.licguid
		then
			return OLD;
		end IF;

		if(DeviceGroupNameExists(New.strname,NEW.id,New.userid,NEW.licguid)=true) then
			RAISE EXCEPTION 'name exists';
		end if;

		if not (NEW.userid=OLD.userid and NEW.licguid=OLD.licguid) then
			update objtimestamp set modifytime=now() where typename='PublicDeviceGroup';
			if new.userid=-1 then
				iguid=old.licguid;
				uid=old.userid;
			else 
				iguid=new.licguid;
				uid=new.userid;
			end if;
			select id into tid from objprivatetimestamp where typename='PrivateDeviceGroup' and userid=uid and licguid=iguid;
			if tid is null then
				insert into objprivatetimestamp (typename,userid,modifytime,licguid) values('PrivateDeviceGroup',uid,now(),iguid);
			else
				update objprivatetimestamp set modifytime=now() where typename='PrivateDeviceGroup' and userid=uid and licguid=iguid;
			end if;	
		elseif NEW.userid=-1 then
			update objtimestamp set modifytime=now() where typename='PublicDeviceGroup';
		else
			select id into tid from objprivatetimestamp where typename='PrivateDeviceGroup' and userid=new.userid and licguid=NEW.licguid;
			if tid is null then
				insert into objprivatetimestamp (typename,userid,modifytime,licguid) values('PrivateDeviceGroup',new.userid,now(),NEW.licguid);
			else
				update objprivatetimestamp set modifytime=now() where typename='PrivateDeviceGroup' and userid=new.userid and licguid=NEW.licguid;
			end if;	
		end if;		
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		if(DeviceGroupNameExists(New.strname,0,New.userid,NEW.licguid)=true) then
			RAISE EXCEPTION 'name exists';
		end if;
		if NEW.userid=-1 then
			update objtimestamp set modifytime=now() where typename='PublicDeviceGroup';
		else
			select id into tid from objprivatetimestamp where typename='PrivateDeviceGroup' and userid=new.userid and licguid=NEW.licguid;
			if tid is null then
				insert into objprivatetimestamp (typename,userid,modifytime,licguid) values('PrivateDeviceGroup',new.userid,now(),NEW.licguid);
			else
				update objprivatetimestamp set modifytime=now() where typename='PrivateDeviceGroup' and userid=new.userid and licguid=NEW.licguid;
			end if;	
		end if;	
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		if OLD.userid=-1 then
			update objtimestamp set modifytime=now() where typename='PublicDeviceGroup';
		else
				select id into tid from objprivatetimestamp where typename='PrivateDeviceGroup' and userid=OLD.userid and licguid=OLD.licguid;
				if tid is null then
					insert into objprivatetimestamp (typename,userid,modifytime,licguid) values('PrivateDeviceGroup',old.userid,now(),old.licguid);
				else
					update objprivatetimestamp set modifytime=now() where typename='PrivateDeviceGroup' and userid=old.userid and licguid=OLD.licguid;
				end if;	
		end if;			
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;

$$;


ALTER FUNCTION public.process_devicegroup_dt() OWNER TO postgres;

--
-- TOC entry 121 (class 1255 OID 619880)
-- Dependencies: 1057 6
-- Name: process_devicegroupdevice_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_devicegroupdevice_dt() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare tid integer;
declare uid integer;
DECLARE newuserid integer;
DECLARE olduserid integer;
DECLARE newguid character varying;
DECLARE oldguid character varying;
DECLARE iguid character varying;
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.devicegroupid = NEW.devicegroupid AND 				
			OLD.deviceid = NEW.deviceid AND
			OLD."type" = NEW."type"
		then
			return OLD;
		end IF;
		select userid into newuserid from devicegroup where id=NEW.devicegroupid;
		select userid into olduserid from devicegroup where id=old.devicegroupid;
		select licguid into newguid from devicegroup where id=NEW.devicegroupid;
		select licguid into oldguid from devicegroup where id=old.devicegroupid;

		if not (newuserid=olduserid and newguid=oldguid) then
			update objtimestamp set modifytime=now() where typename='PublicDeviceGroup';
			if newuserid=-1 then
				iguid=oldguid;
				uid=olduserid;
			else 
				iguid=newguid;
				uid=newuserid;
			end if;
			select id into tid from objprivatetimestamp where typename='PrivateDeviceGroup' and userid=uid and licguid=iguid;
			if tid is null then
				insert into objprivatetimestamp (typename,userid,modifytime,licguid) values('PrivateDeviceGroup',uid,now(),iguid);
			else
				update objprivatetimestamp set modifytime=now() where typename='PrivateDeviceGroup' and userid=uid and licguid=iguid;
			end if;
		elseif newuserid=-1 then
			update objtimestamp set modifytime=now() where typename='PublicDeviceGroup';
		else
			select licguid into iguid from devicegroup where id=NEW.devicegroupid;
			select id into tid from objprivatetimestamp where typename='PrivateDeviceGroup' and userid=newuserid and licguid=newguid;
			if tid is null then
				insert into objprivatetimestamp (typename,userid,modifytime,licguid) values('PrivateDeviceGroup',newuserid,now(),newguid);
			else
				update objprivatetimestamp set modifytime=now() where typename='PrivateDeviceGroup' and userid=newuserid and licguid=newguid;
			end if;	
		end if;		
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		select userid into newuserid from devicegroup where id=NEW.devicegroupid;
		if newuserid=-1 then
			update objtimestamp set modifytime=now() where typename='PublicDeviceGroup';
		else
			select licguid into iguid from devicegroup where id=NEW.devicegroupid;
			select id into tid from objprivatetimestamp where typename='PrivateDeviceGroup' and userid=newuserid and licguid=iguid;
			if tid is null then
				insert into objprivatetimestamp (typename,userid,modifytime,licguid) values('PrivateDeviceGroup',newuserid,now(),iguid);
			else
				update objprivatetimestamp set modifytime=now() where typename='PrivateDeviceGroup' and userid=newuserid and licguid=iguid;
			end if;	
		end if;		
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		select userid into olduserid from devicegroup where id=old.devicegroupid;		
		if not olduserid is null then
			if olduserid=-1 then
				update objtimestamp set modifytime=now() where typename='PublicDeviceGroup';
			else
				select licguid into iguid from devicegroup where id=old.devicegroupid;		
				select id into tid from objprivatetimestamp where typename='PrivateDeviceGroup' and userid=olduserid and licguid=iguid;
				if tid is null then
					insert into objprivatetimestamp (typename,userid,modifytime,licguid) values('PrivateDeviceGroup',olduserid,now(),iguid);
				else
					update objprivatetimestamp set modifytime=now() where typename='PrivateDeviceGroup' and userid=olduserid and licguid=iguid;
				end if;	
			end if;			
		end if;
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
    $$;


ALTER FUNCTION public.process_devicegroupdevice_dt() OWNER TO postgres;

--
-- TOC entry 122 (class 1255 OID 619881)
-- Dependencies: 1057 6
-- Name: process_devicessetting_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_devicessetting_dt() RETURNS trigger
    LANGUAGE plpgsql
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
			OLD.cmdbserverid = NEW.cmdbserverid AND
			OLD.authentication_method=NEW.authentication_method AND
			OLD.encryption_method=NEW.encryption_method AND
			OLD.snmpv3_username=NEW.snmpv3_username AND
			OLD.snmpv3_authentication=NEW.snmpv3_authentication AND
			OLD.snmpv3_encryption=NEW.snmpv3_encryption AND
			OLD.authentication_mode=NEW.authentication_mode AND
			OLD.configfile_time=NEW.configfile_time AND
			OLD.driverid=NEW.driverid AND
			OLD.enpasswordprompt=NEW.enpasswordprompt AND
			OLD.enableusername=NEW.enableusername AND
			OLD.enableusernameprompt=NEW.enableusernameprompt AND
			OLD.cpuexpression=NEW.cpuexpression AND
			OLD.memoryexpression=NEW.memoryexpression AND
			OLD.loginscript=NEW.loginscript AND
			OLD.loginscriptenable=NEW.loginscriptenable
		 then
			return OLD;
		end IF;
		if OLD.configfile_time != NEW.configfile_time then
			update device_property set lasttimestamp=now() where deviceid=OLD.deviceid;
		end if;    
		NEW.lasttimestamp=now();
		update objtimestamp set modifytime=now() where typename='DeviceSetting';				
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='DeviceSetting' or typename='site';		
		NEW.configfile_time=now();
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='DeviceSetting' or typename='site';		
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$$;


ALTER FUNCTION public.process_devicessetting_dt() OWNER TO postgres;

--
-- TOC entry 123 (class 1255 OID 619882)
-- Dependencies: 6 1057
-- Name: process_discover_missdevice_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_discover_missdevice_dt() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.mgrip = NEW.mgrip AND 
			OLD.devtype = NEW.devtype AND
			OLD.vendor = NEW.vendor AND
			OLD.model = NEW.model AND
			OLD.checktime = NEW.checktime AND
			OLD.log = NEW.log AND
			OLD.modifytime = NEW.modifytime AND
			OLD.deviceid = NEW.deviceid		
		 then
			return OLD;
		end IF;
		update objtimestamp set modifytime=now() where typename='discover_missdevice';
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='discover_missdevice';		
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='discover_missdevice';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$$;


ALTER FUNCTION public.process_discover_missdevice_dt() OWNER TO postgres;

--
-- TOC entry 124 (class 1255 OID 619883)
-- Dependencies: 1057 6
-- Name: process_discover_newdevice_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_discover_newdevice_dt() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.hostname = NEW.hostname AND 
			OLD.mgrip = NEW.mgrip AND
			OLD.devtype = NEW.devtype AND
			OLD.vendor = NEW.vendor AND
			OLD.model = NEW.model AND
			OLD.findtime = NEW.findtime AND
			OLD.log = NEW.log AND
			OLD.lasttime=NEW.lasttime
		 then
			return OLD;
		end IF;
		update objtimestamp set modifytime=now() where typename='discover_newdevice';
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='discover_newdevice';		
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='discover_newdevice';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$$;


ALTER FUNCTION public.process_discover_newdevice_dt() OWNER TO postgres;

--
-- TOC entry 125 (class 1255 OID 619884)
-- Dependencies: 6 1057
-- Name: process_discover_snmpdevice_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_discover_snmpdevice_dt() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.hostname = NEW.hostname AND 
			OLD.mgrip = NEW.mgrip AND
			OLD.snmpro = NEW.snmpro AND
			OLD.devtype = NEW.devtype AND
			OLD.vendor = NEW.vendor AND
			OLD.model = NEW.model AND
			OLD.findtime = NEW.findtime AND
			OLD.log = NEW.log
		 then
			return OLD;
		end IF;
		update objtimestamp set modifytime=now() where typename='discover_snmpdevice';
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='discover_snmpdevice';		
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='discover_snmpdevice';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$$;


ALTER FUNCTION public.process_discover_snmpdevice_dt() OWNER TO postgres;

--
-- TOC entry 126 (class 1255 OID 619885)
-- Dependencies: 6 1057
-- Name: process_discover_unknowdevice_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_discover_unknowdevice_dt() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF	OLD.mgrip = NEW.mgrip AND
			OLD.snmpro = NEW.snmpro AND
			OLD.devtype = NEW.devtype AND
			OLD.sysobjectid = NEW.sysobjectid AND
			OLD.discoverfrom = NEW.discoverfrom AND
			OLD.findtime = NEW.findtime AND
			OLD.log = NEW.log AND
			OLD.devname = NEW.devname
		 then
			return OLD;
		end IF;
		update objtimestamp set modifytime=now() where typename='discover_unknowdevice';
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='discover_unknowdevice';		
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='discover_unknowdevice';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$$;


ALTER FUNCTION public.process_discover_unknowdevice_dt() OWNER TO postgres;

--
-- TOC entry 127 (class 1255 OID 619886)
-- Dependencies: 1057 6
-- Name: process_donotscan_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_donotscan_dt() RETURNS trigger
    LANGUAGE plpgsql
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
$$;


ALTER FUNCTION public.process_donotscan_dt() OWNER TO postgres;

--
-- TOC entry 128 (class 1255 OID 619887)
-- Dependencies: 6 1057
-- Name: process_duplicateip_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_duplicateip_dt() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.ipaddr = NEW.ipaddr AND
			OLD.interfaceid = NEW.interfaceid AND
			OLD.deviceid = NEW.deviceid AND			
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
$$;


ALTER FUNCTION public.process_duplicateip_dt() OWNER TO postgres;

--
-- TOC entry 129 (class 1255 OID 619888)
-- Dependencies: 6 1057
-- Name: process_fixupnatinfo(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_fixupnatinfo() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
        IF (TG_OP = 'UPDATE') THEN		
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN                
		NEW.ipri=nextval('fixupnatinfo_ipri_seq'::regclass);						                				
		RETURN NEW;        
        END IF;
        RETURN NULL;
    END;
$$;


ALTER FUNCTION public.process_fixupnatinfo() OWNER TO postgres;

--
-- TOC entry 130 (class 1255 OID 619889)
-- Dependencies: 6 1057
-- Name: process_fixupnatinfo_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_fixupnatinfo_dt() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
		
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.deviceid = NEW.deviceid AND 			
			OLD.ininfid = NEW.ininfid AND 			
			OLD.outinfid = NEW.outinfid AND 						
			OLD.insidelocal = NEW.insidelocal AND
			OLD.insideglobal = NEW.insideglobal AND
			OLD.outsidelocal=NEW.outsidelocal AND
			OLD.outsideglobal=NEW.outsideglobal AND
			OLD.ipri=NEW.ipri 
		 then
			return OLD;
		end IF;
		update objtimestamp set modifytime=now() where typename='FixUpNatInfo';
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='FixUpNatInfo';
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='FixUpNatInfo';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$$;


ALTER FUNCTION public.process_fixupnatinfo_dt() OWNER TO postgres;

--
-- TOC entry 131 (class 1255 OID 619890)
-- Dependencies: 1057 6
-- Name: process_fixuproutetable_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_fixuproutetable_dt() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
		
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.deviceid = NEW.deviceid AND 			
			OLD.destip = NEW.destip AND 			
			OLD.destmask = NEW.destmask AND 						
			OLD.infname = NEW.infname AND
			OLD.nexthopip = NEW.nexthopip 
		 then
			return OLD;
		end IF;
		update objtimestamp set modifytime=now() where typename='FixUpRouteTable';
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='FixUpRouteTable';
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='FixUpRouteTable';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$$;


ALTER FUNCTION public.process_fixuproutetable_dt() OWNER TO postgres;

--
-- TOC entry 133 (class 1255 OID 619891)
-- Dependencies: 1057 6
-- Name: process_fixuproutetablepriority_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_fixuproutetablepriority_dt() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
		
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.deviceid = NEW.deviceid AND 			
			OLD.priority = NEW.priority 
		 then
			return OLD;
		end IF;
		update objtimestamp set modifytime=now() where typename='FixUpRouteTablePriority';
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='FixUpRouteTablePriority';
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='FixUpRouteTablePriority';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$$;


ALTER FUNCTION public.process_fixuproutetablepriority_dt() OWNER TO postgres;

--
-- TOC entry 134 (class 1255 OID 619892)
-- Dependencies: 6 1057
-- Name: process_fixupunnumberedinterface_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_fixupunnumberedinterface_dt() RETURNS trigger
    LANGUAGE plpgsql
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
$$;


ALTER FUNCTION public.process_fixupunnumberedinterface_dt() OWNER TO postgres;

--
-- TOC entry 135 (class 1255 OID 619893)
-- Dependencies: 1057 6
-- Name: process_interface_customized_info_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_interface_customized_info_dt() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
		
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.objectid = NEW.objectid AND 			
			OLD.attributeid = NEW.attributeid AND 			
			OLD.attribute_value = NEW.attribute_value		
		 then
			return OLD;
		end IF;
		update objtimestamp set modifytime=now() where typename='interface_customized_info';
		NEW.lasttimestamp=now();	
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='interface_customized_info';
		NEW.lasttimestamp=now();
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='interface_customized_info';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$$;


ALTER FUNCTION public.process_interface_customized_info_dt() OWNER TO postgres;

--
-- TOC entry 136 (class 1255 OID 619894)
-- Dependencies: 6 1057
-- Name: process_interfacesetting_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_interfacesetting_dt() RETURNS trigger
    LANGUAGE plpgsql
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
$$;


ALTER FUNCTION public.process_interfacesetting_dt() OWNER TO postgres;

--
-- TOC entry 137 (class 1255 OID 619895)
-- Dependencies: 6 1057
-- Name: process_internetboundaryinterface_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_internetboundaryinterface_dt() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF	OLD.deviceid = NEW.deviceid AND
			OLD.interfaceid = NEW.interfaceid AND
			OLD.interfaceip = NEW.interfaceip
		 then
			return OLD;
		end IF;
		update objtimestamp set modifytime=now() where typename='internetboundaryinterface';
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='internetboundaryinterface';		
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='internetboundaryinterface';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$$;


ALTER FUNCTION public.process_internetboundaryinterface_dt() OWNER TO postgres;

--
-- TOC entry 138 (class 1255 OID 619896)
-- Dependencies: 6 1057
-- Name: process_ip2mac_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_ip2mac_dt() RETURNS trigger
    LANGUAGE plpgsql
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
$$;


ALTER FUNCTION public.process_ip2mac_dt() OWNER TO postgres;

--
-- TOC entry 139 (class 1255 OID 619897)
-- Dependencies: 1057 6
-- Name: process_ip2mac_userflag(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_ip2mac_userflag() RETURNS trigger
    LANGUAGE plpgsql
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
$$;


ALTER FUNCTION public.process_ip2mac_userflag() OWNER TO postgres;

--
-- TOC entry 140 (class 1255 OID 619898)
-- Dependencies: 6 1057
-- Name: process_ipphone_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_ipphone_dt() RETURNS trigger
    LANGUAGE plpgsql
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
		NEW.lasttimestamp=NOW();
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
$$;


ALTER FUNCTION public.process_ipphone_dt() OWNER TO postgres;

--
-- TOC entry 141 (class 1255 OID 619899)
-- Dependencies: 1057 6
-- Name: process_l2connectivity_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_l2connectivity_dt() RETURNS trigger
    LANGUAGE plpgsql
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
$$;


ALTER FUNCTION public.process_l2connectivity_dt() OWNER TO postgres;

--
-- TOC entry 143 (class 1255 OID 619900)
-- Dependencies: 1057 6
-- Name: process_l2switchinfo_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_l2switchinfo_dt() RETURNS trigger
    LANGUAGE plpgsql
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
    END;$$;


ALTER FUNCTION public.process_l2switchinfo_dt() OWNER TO postgres;

--
-- TOC entry 144 (class 1255 OID 619901)
-- Dependencies: 1057 6
-- Name: process_l2switchport_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_l2switchport_dt() RETURNS trigger
    LANGUAGE plpgsql
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
$$;


ALTER FUNCTION public.process_l2switchport_dt() OWNER TO postgres;

--
-- TOC entry 145 (class 1255 OID 619902)
-- Dependencies: 6 1057
-- Name: process_l2switchvlan_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_l2switchvlan_dt() RETURNS trigger
    LANGUAGE plpgsql
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
$$;


ALTER FUNCTION public.process_l2switchvlan_dt() OWNER TO postgres;

--
-- TOC entry 146 (class 1255 OID 619903)
-- Dependencies: 6 1057
-- Name: process_lanswitch_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_lanswitch_dt() RETURNS trigger
    LANGUAGE plpgsql
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
$$;


ALTER FUNCTION public.process_lanswitch_dt() OWNER TO postgres;

--
-- TOC entry 147 (class 1255 OID 619904)
-- Dependencies: 1057 6
-- Name: process_linkgroup_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_linkgroup_dt() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare tid integer;
declare uid integer;
declare iguid character varying;
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.strname = NEW.strname AND 
			OLD.strdesc = NEW.strdesc AND
			OLD.userid = NEW.userid AND			
			OLD.showcolor = NEW.showcolor AND
			OLD.showstyle =NEW.showstyle AND
			OLD.showwidth = NEW.showwidth AND
			OLD.searchcondition= NEW.searchcondition AND
			OLD.searchcontainer =NEW.searchcontainer AND
			OLD.dev_searchcondition =NEW.dev_searchcondition AND
			OLD.dev_searchcontainer =NEW.dev_searchcontainer AND
			OLD.is_map_auto_link =NEW.is_map_auto_link AND
			OLD.istemplate =NEW.istemplate AND
			OLD.licguid = NEW.licguid
		then
			return OLD;
		end IF;

		if(LinkGroupNameExists(New.strname,NEW.id,New.userid,New.licguid)=true) then
			RAISE EXCEPTION 'name exists';
		end if;

		if not NEW.userid=OLD.userid then
			update objtimestamp set modifytime=now() where typename='PublicLinkGroup';
			if new.userid=-1 then
				iguid=old.licguid;
				uid=old.userid;
			else 
				iguid=new.licguid;
				uid=new.userid;
			end if;
			select id into tid from objprivatetimestamp where typename='PrivateLinkGroup' and userid=uid and licguid=iguid;
			if tid is null then
				insert into objprivatetimestamp (typename,userid,modifytime,licguid) values('PrivateLinkGroup',uid,now(),iguid);
			else
				update objprivatetimestamp set modifytime=now() where typename='PrivateLinkGroup' and userid=uid and licguid=iguid;
			end if;
		elseif NEW.userid=-1 then
			update objtimestamp set modifytime=now() where typename='PublicLinkGroup';
		else
			select id into tid from objprivatetimestamp where typename='PrivateLinkGroup' and userid=new.userid and licguid=NEW.licguid;
			if tid is null then
				insert into objprivatetimestamp (typename,userid,modifytime,licguid) values('PrivateLinkGroup',new.userid,now(),NEW.licguid);
			else
				update objprivatetimestamp set modifytime=now() where typename='PrivateLinkGroup' and userid=new.userid and licguid=NEW.licguid;
			end if;	
		end if;		
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN

		if(LinkGroupNameExists(New.strname,0,New.userid,New.licguid)=true) then
			RAISE EXCEPTION 'name exists';
		end if;
		
		if NEW.userid=-1 then
			update objtimestamp set modifytime=now() where typename='PublicLinkGroup';
		else
			select id into tid from objprivatetimestamp where typename='PrivateLinkGroup' and userid=new.userid and licguid=New.licguid;
			if tid is null then
				insert into objprivatetimestamp (typename,userid,modifytime,licguid) values('PrivateLinkGroup',new.userid,now(),New.licguid);
			else
				update objprivatetimestamp set modifytime=now() where typename='PrivateLinkGroup' and userid=new.userid and licguid= New.licguid;
			end if;	
		end if;	
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		if OLD.userid=-1 then
			update objtimestamp set modifytime=now() where typename='PublicLinkGroup';
		else
				select id into tid from objprivatetimestamp where typename='PrivateLinkGroup' and userid=OLD.userid and licguid=OLD.licguid;
				if tid is null then
					insert into objprivatetimestamp (typename,userid,modifytime,licguid) values('PrivateLinkGroup',old.userid,now(),old.licguid);
				else
					update objprivatetimestamp set modifytime=now() where typename='PrivateLinkGroup' and userid=old.userid and licguid=OLD.licguid;
				end if;	
		end if;			
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$$;


ALTER FUNCTION public.process_linkgroup_dt() OWNER TO postgres;

--
-- TOC entry 148 (class 1255 OID 619905)
-- Dependencies: 6 1057
-- Name: process_linkgroup_param_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_linkgroup_param_dt() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare tid integer;
declare uid integer;
DECLARE newuserid integer;
DECLARE olduserid integer;
DECLARE newguid character varying;
DECLARE oldguid character varying;
DECLARE iguid character varying;
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.linkgroupid = NEW.linkgroupid AND 				
			OLD.strname = NEW.strname AND
			OLD.strdesc = NEW.strdesc
		then
			return OLD;
		end IF;
		select userid into newuserid from linkgroup where id=NEW.linkgroupid;
		select userid into olduserid from linkgroup where id=old.linkgroupid;
		select licguid into newguid from linkgroup where id=NEW.linkgroupid;
		select licguid into oldguid from linkgroup where id=old.linkgroupid;

		if not (newuserid=olduserid and newguid=oldguid) then
			update objtimestamp set modifytime=now() where typename='PublicLinkGroup';
			if newuserid=-1 then
				iguid=oldguid;
				uid=olduserid;
			else 
				iguid=newguid;
				uid=newuserid;
			end if;
			select id into tid from objprivatetimestamp where typename='PrivateLinkGroup' and userid=uid and licguid=iguid;
			if tid is null then
				insert into objprivatetimestamp (typename,userid,modifytime,licguid) values('PrivateLinkGroup',uid,now(),iguid);
			else
				update objprivatetimestamp set modifytime=now() where typename='PrivateLinkGroup' and userid=uid and licguid=iguid;
			end if;
		elseif newuserid=-1 then
			update objtimestamp set modifytime=now() where typename='PublicLinkGroup';
		else
			select id into tid from objprivatetimestamp where typename='PrivateLinkGroup' and userid=newuserid and licguid=newguid;
			if tid is null then
				insert into objprivatetimestamp (typename,userid,modifytime,licguid) values('PrivateLinkGroup',newuserid,now(),newguid);
			else
				update objprivatetimestamp set modifytime=now() where typename='PrivateLinkGroup' and userid=newuserid and licguid=newguid;
			end if;	
		end if;		
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		select userid into newuserid from linkgroup where id=NEW.linkgroupid;
		if newuserid=-1 then
			update objtimestamp set modifytime=now() where typename='PublicLinkGroup';
		else
			select licguid into newguid from linkgroup where id=new.linkgroupid;
			select id into tid from objprivatetimestamp where typename='PrivateLinkGroup' and userid=newuserid and licguid=newguid;
			if tid is null then
				insert into objprivatetimestamp (typename,userid,modifytime,licguid) values('PrivateLinkGroup',newuserid,now(),newguid);
			else
				update objprivatetimestamp set modifytime=now() where typename='PrivateLinkGroup' and userid=newuserid  and licguid=newguid;
			end if;	
		end if;		
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		select userid into olduserid from linkgroup where id=old.linkgroupid;
		if not olduserid is null then
			if olduserid=-1 then
				update objtimestamp set modifytime=now() where typename='PublicLinkGroup';
			else
				select licguid into oldguid from linkgroup where id=old.linkgroupid;
				select id into tid from objprivatetimestamp where typename='PrivateLinkGroup' and userid=olduserid and licguid=oldguid;
				if tid is null then
					insert into objprivatetimestamp (typename,userid,modifytime,licguid) values('PrivateLinkGroup',olduserid,now(),oldguid);
				else
					update objprivatetimestamp set modifytime=now() where typename='PrivateLinkGroup' and userid=olduserid and licguid=oldguid;
				end if;	
			end if;			
		end if;
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
    $$;


ALTER FUNCTION public.process_linkgroup_param_dt() OWNER TO postgres;

--
-- TOC entry 149 (class 1255 OID 619906)
-- Dependencies: 6 1057
-- Name: process_linkgroup_paramvalue_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_linkgroup_paramvalue_dt() RETURNS trigger
    LANGUAGE plpgsql
    AS $$declare tid integer;
declare uid integer;
DECLARE newuserid integer;
DECLARE olduserid integer;
DECLARE newguid character varying;
DECLARE oldguid character varying;
DECLARE iguid character varying;
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.paramid = NEW.paramid AND 				
			OLD.strvalue = NEW.strvalue AND
			OLD.strdesc = NEW.strdesc
		then
			return OLD;
		end IF;
		select linkgroup.userid into newuserid from linkgroup,linkgroup_param where linkgroup.id=linkgroup_param.linkgroupid and linkgroup_param.id=NEW.paramid;
		select linkgroup.userid into olduserid from linkgroup,linkgroup_param where linkgroup.id=linkgroup_param.linkgroupid and linkgroup_param.id=OLD.paramid;
		select linkgroup.licguid into newguid from linkgroup,linkgroup_param where linkgroup.id=linkgroup_param.linkgroupid and linkgroup_param.id=OLD.paramid;
		select linkgroup.licguid into oldguid from linkgroup,linkgroup_param where linkgroup.id=linkgroup_param.linkgroupid and linkgroup_param.id=OLD.paramid;

		if not (newuserid=olduserid and newguid=oldguid) then
			update objtimestamp set modifytime=now() where typename='PublicLinkGroup';
			if newuserid=-1 then
				iguid=oldguid;
				uid=olduserid;
			else 
				iguid=newguid;
				uid=newuserid;
			end if;
			select id into tid from objprivatetimestamp where typename='PrivateLinkGroup' and userid=uid and licguid=iguid;
			if tid is null then
				insert into objprivatetimestamp (typename,userid,modifytime,licguid) values('PrivateLinkGroup',uid,now(),iguid);
			else
				update objprivatetimestamp set modifytime=now() where typename='PrivateLinkGroup' and userid=uid and licguid=iguid;
			end if;
		elseif newuserid=-1 then
			update objtimestamp set modifytime=now() where typename='PublicLinkGroup';
		else
			select id into tid from objprivatetimestamp where typename='PrivateLinkGroup' and userid=newuserid and licguid=newguid;
			if tid is null then
				insert into objprivatetimestamp (typename,userid,modifytime,licguid) values('PrivateLinkGroup',newuserid,now(),newguid);
			else
				update objprivatetimestamp set modifytime=now() where typename='PrivateLinkGroup' and userid=newuserid and licguid=newguid;
			end if;	
		end if;		
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		select linkgroup.userid into newuserid from linkgroup,linkgroup_param where linkgroup.id=linkgroup_param.linkgroupid and linkgroup_param.id=NEW.paramid;		
		if newuserid=-1 then
			update objtimestamp set modifytime=now() where typename='PublicLinkGroup';
		else
			select linkgroup.licguid into newguid from linkgroup,linkgroup_param where linkgroup.id=linkgroup_param.linkgroupid and linkgroup_param.id=NEW.paramid;
			select id into tid from objprivatetimestamp where typename='PrivateLinkGroup' and userid=newuserid and licguid=newguid ;
			if tid is null then
				insert into objprivatetimestamp (typename,userid,modifytime,licguid) values('PrivateLinkGroup',newuserid,now(),newguid );
			else
				update objprivatetimestamp set modifytime=now() where typename='PrivateLinkGroup' and userid=newuserid and licguid=newguid ;
			end if;	
		end if;		
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		select linkgroup.userid into olduserid from linkgroup,linkgroup_param where linkgroup.id=linkgroup_param.linkgroupid and linkgroup_param.id=OLD.paramid;		
		if not olduserid is null then
			if olduserid=-1 then
				update objtimestamp set modifytime=now() where typename='PublicLinkGroup';
			else
				select linkgroup.licguid into oldguid from linkgroup,linkgroup_param where linkgroup.id=linkgroup_param.linkgroupid and linkgroup_param.id=OLD.paramid;
				select id into tid from objprivatetimestamp where typename='PrivateLinkGroup' and userid=olduserid and licguid=oldguid;
				if tid is null then
					insert into objprivatetimestamp (typename,userid,modifytime,licguid) values('PrivateLinkGroup',olduserid,now(),oldguid);
				else
					update objprivatetimestamp set modifytime=now() where typename='PrivateLinkGroup' and userid=olduserid and licguid=oldguid;
				end if;	
			end if;			
		end if;
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;$$;


ALTER FUNCTION public.process_linkgroup_paramvalue_dt() OWNER TO postgres;

--
-- TOC entry 150 (class 1255 OID 619907)
-- Dependencies: 6 1057
-- Name: process_linkgroupdevice_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_linkgroupdevice_dt() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare tid integer;
declare uid integer;
DECLARE newuserid integer;
DECLARE olduserid integer;
DECLARE newguid character varying;
DECLARE oldguid character varying;
DECLARE iguid character varying;
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.linkgroupid = NEW.linkgroupid AND 				
			OLD.deviceid = NEW.deviceid AND
			OLD."type" = NEW."type"
		then
			return OLD;
		end IF;
		select userid into newuserid from linkgroup where id=NEW.linkgroupid;
		select userid into olduserid from linkgroup where id=old.linkgroupid;
		select licguid into newguid from linkgroup where id=NEW.linkgroupid;
		select licguid into oldguid from linkgroup where id=old.linkgroupid;

		if not newuserid=olduserid then
			update objtimestamp set modifytime=now() where typename='PublicLinkGroup';
			if newuserid=-1 then
				iguid=oldguid;
				uid=olduserid;
			else 
				iguid=newguid;
				uid=newuserid;
			end if;
			select id into tid from objprivatetimestamp where typename='PrivateLinkGroup' and userid=uid and licguid=iguid;
			if tid is null then
				insert into objprivatetimestamp (typename,userid,modifytime,licguid) values('PrivateLinkGroup',uid,now(),iguid);
			else
				update objprivatetimestamp set modifytime=now() where typename='PrivateLinkGroup' and userid=uid and licguid=iguid;
			end if;
		elseif newuserid=-1 then
			update objtimestamp set modifytime=now() where typename='PublicLinkGroup';
		else
			select id into tid from objprivatetimestamp where typename='PrivateLinkGroup' and userid=newuserid and licguid=newguid;
			if tid is null then
				insert into objprivatetimestamp (typename,userid,modifytime,licguid) values('PrivateLinkGroup',newuserid,now(),newguid);
			else
				update objprivatetimestamp set modifytime=now() where typename='PrivateLinkGroup' and userid=newuserid and licguid=newguid;
			end if;	
		end if;		
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		select userid into newuserid from linkgroup where id=NEW.linkgroupid;
		if newuserid=-1 then
			update objtimestamp set modifytime=now() where typename='PublicLinkGroup';
		else
			select licguid into newguid from linkgroup where id=NEW.linkgroupid;
			select id into tid from objprivatetimestamp where typename='PrivateLinkGroup' and userid=newuserid and licguid=newguid;
			if tid is null then
				insert into objprivatetimestamp (typename,userid,modifytime,licguid) values('PrivateLinkGroup',newuserid,now(),newguid);
			else
				update objprivatetimestamp set modifytime=now() where typename='PrivateLinkGroup' and userid=newuserid and licguid=newguid;
			end if;	
		end if;		
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		select userid into olduserid from linkgroup where id=old.linkgroupid;
		if not olduserid is null then
			if olduserid=-1 then
				update objtimestamp set modifytime=now() where typename='PublicLinkGroup';
			else
				select licguid into oldguid from linkgroup where id=old.linkgroupid;
				select id into tid from objprivatetimestamp where typename='PrivateLinkGroup' and userid=olduserid and licguid=oldguid;
				if tid is null then
					insert into objprivatetimestamp (typename,userid,modifytime,licguid) values('PrivateLinkGroup',olduserid,now(),oldguid);
				else
					update objprivatetimestamp set modifytime=now() where typename='PrivateLinkGroup' and userid=olduserid and licguid=oldguid;
				end if;	
			end if;			
		end if;
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
    $$;


ALTER FUNCTION public.process_linkgroupdevice_dt() OWNER TO postgres;

--
-- TOC entry 151 (class 1255 OID 619908)
-- Dependencies: 6 1057
-- Name: process_linkgroupinterface_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_linkgroupinterface_dt() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare tid integer;
declare uid integer;
DECLARE newuserid integer;
DECLARE olduserid integer;
DECLARE newguid character varying;
DECLARE oldguid character varying;
DECLARE iguid character varying;
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.groupid = NEW.groupid AND 				
			OLD.interfaceid = NEW.interfaceid AND
			OLD."type" = NEW."type" AND
			OLD.interfaceip= NEW.interfaceip AND
			OLD.deviceid= NEW.deviceid
		then
			return OLD;
		end IF;
		select userid into newuserid from linkgroup where id=NEW.groupid;
		select userid into olduserid from linkgroup where id=old.groupid;
		select licguid into newguid from linkgroup where id=NEW.groupid;
		select licguid into oldguid from linkgroup where id=old.groupid;

		if not newuserid=olduserid then
			update objtimestamp set modifytime=now() where typename='PublicLinkGroup';
			if newuserid=-1 then
				iguid=oldguid;
				uid=olduserid;
			else 
				iguid=newguid;
				uid=newuserid;
			end if;
			select id into tid from objprivatetimestamp where typename='PrivateLinkGroup' and userid=uid and licguid=iguid;
			if tid is null then
				insert into objprivatetimestamp (typename,userid,modifytime,licguid) values('PrivateLinkGroup',uid,now(),iguid);
			else
				update objprivatetimestamp set modifytime=now() where typename='PrivateLinkGroup' and userid=uid and licguid=iguid;
			end if;
		elseif newuserid=-1 then
			update objtimestamp set modifytime=now() where typename='PublicLinkGroup';
		else
			select id into tid from objprivatetimestamp where typename='PrivateLinkGroup' and userid=newuserid and licguid=newguid;
			if tid is null then
				insert into objprivatetimestamp (typename,userid,modifytime,licguid) values('PrivateLinkGroup',newuserid,now(),newguid);
			else
				update objprivatetimestamp set modifytime=now() where typename='PrivateLinkGroup' and userid=newuserid and licguid=newguid;
			end if;	
		end if;		
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		select userid into newuserid from linkgroup where id=NEW.groupid;
		if newuserid=-1 then
			update objtimestamp set modifytime=now() where typename='PublicLinkGroup';
		else
			select licguid into newguid from linkgroup where id=NEW.groupid;
			select id into tid from objprivatetimestamp where typename='PrivateLinkGroup' and userid=newuserid and licguid=newguid;
			if tid is null then
				insert into objprivatetimestamp (typename,userid,modifytime,licguid) values('PrivateLinkGroup',newuserid,now(),newguid);
			else
				update objprivatetimestamp set modifytime=now() where typename='PrivateLinkGroup' and userid=newuserid and licguid=newguid;
			end if;	
		end if;		
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		select userid into olduserid from linkgroup where id=old.groupid;
		if not olduserid is null then
			if olduserid=-1 then
				update objtimestamp set modifytime=now() where typename='PublicLinkGroup';
			else
				select licguid into oldguid from linkgroup where id=old.groupid;
				select id into tid from objprivatetimestamp where typename='PrivateLinkGroup' and userid=olduserid and licguid=oldguid;
				if tid is null then
					insert into objprivatetimestamp (typename,userid,modifytime,licguid) values('PrivateLinkGroup',olduserid,now(),oldguid);
				else
					update objprivatetimestamp set modifytime=now() where typename='PrivateLinkGroup' and userid=olduserid and licguid=oldguid;
				end if;	
			end if;			
		end if;
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
    $$;


ALTER FUNCTION public.process_linkgroupinterface_dt() OWNER TO postgres;

--
-- TOC entry 152 (class 1255 OID 619909)
-- Dependencies: 6 1057
-- Name: process_lwap_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_lwap_dt() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.hostname = NEW.hostname AND 
			OLD.version = NEW.version AND
			OLD.ipaddress = NEW.ipaddress AND
			OLD.macaddress = NEW.macaddress AND
			OLD.sgroup = NEW.sgroup AND
			OLD.primarycontroller = NEW.primarycontroller AND
			OLD.secondarycontroll = NEW.secondarycontroll AND
			OLD.defaultgateway = NEW.defaultgateway AND
			OLD.vendor = NEW.vendor AND
			OLD.module = NEW.module AND
			OLD.softwareversion = NEW.softwareversion AND			
			OLD.config = NEW.config AND
			OLD.serialnumber = NEW.serialnumber		
		 then
			return OLD;
		end IF;
		update objtimestamp set modifytime=now() where typename='lwap';
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='lwap';		
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='lwap';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$$;


ALTER FUNCTION public.process_lwap_dt() OWNER TO postgres;

--
-- TOC entry 153 (class 1255 OID 619910)
-- Dependencies: 6 1057
-- Name: process_module_customized_info_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_module_customized_info_dt() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
		
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.objectid = NEW.objectid AND 			
			OLD.attributeid = NEW.attributeid AND 			
			OLD.attribute_value = NEW.attribute_value		
		 then
			return OLD;
		end IF;
		update objtimestamp set modifytime=now() where typename='module_customized_info';
		NEW.lasttimestamp=now();	
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='module_customized_info';
		NEW.lasttimestamp=now();
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='module_customized_info';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$$;


ALTER FUNCTION public.process_module_customized_info_dt() OWNER TO postgres;

--
-- TOC entry 154 (class 1255 OID 619911)
-- Dependencies: 1057 6
-- Name: process_module_property_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_module_property_dt() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
		
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.deviceid = NEW.deviceid AND 			
			OLD.slot = NEW.slot AND 			
			OLD.card_type = NEW.card_type AND		
			OLD.ports = NEW.ports AND
			OLD.serial_number = NEW.serial_number AND
			OLD.hwrev = NEW.hwrev AND
			OLD.rwrev = NEW.rwrev AND
			OLD.swrev = NEW.swrev AND
			OLD.card_description=NEW.card_description AND
			OLD.role=NEW.role AND
			OLD.macaddress=NEW.macaddress AND
			OLD.swversion=NEW.swversion AND
			OLD.swimage=NEW.swimage AND
			OLD.stackport1conn=NEW.stackport1conn AND
			OLD.stackport2conn=NEW.stackport2conn AND
			OLD.isswitch=NEW.isswitch
		 then
			return OLD;
		end IF;

		IF 	OLD.card_type != NEW.card_type 
		then
			update interfacesetting set module_type=NEW.card_type,lasttimestamp=now() where deviceid=NEW.deviceid and module_slot=NEW.slot;
			update objtimestamp set modifytime=now() where typename='InterfaceSetting';			
		end IF;	
		
		update objtimestamp set modifytime=now() where typename='module_property';
		NEW.lasttimestamp=now();	
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='module_property';
		NEW.lasttimestamp=now();
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='module_property';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$$;


ALTER FUNCTION public.process_module_property_dt() OWNER TO postgres;

--
-- TOC entry 155 (class 1255 OID 619912)
-- Dependencies: 6 1057
-- Name: process_nd_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_nd_dt() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.hostnameexpression = NEW.hostnameexpression AND 
			OLD.isregularexpression = NEW.isregularexpression AND
			OLD.ipranges = NEW.ipranges AND
			OLD.devicetype = NEW.devicetype AND
			OLD.driverid = NEW.driverid
		 then
			return OLD;
		end IF;
		update objtimestamp set modifytime=now() where typename='nd';
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='nd';		
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='nd';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$$;


ALTER FUNCTION public.process_nd_dt() OWNER TO postgres;

--
-- TOC entry 156 (class 1255 OID 619913)
-- Dependencies: 6 1057
-- Name: process_nomp_appliance_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_nomp_appliance_dt() RETURNS trigger
    LANGUAGE plpgsql
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
			OLD.ibapport=NEW.ibapport AND
			OLD.telnet_pwd = NEW.telnet_pwd			
		 then
			return OLD;
		end IF;
		update objtimestamp set modifytime=now() where typename='NetworkSetting';
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='NetworkSetting';
		NEW.ipri=nextval('nomp_appliance_ipri_seq'::regclass);
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='NetworkSetting';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$$;


ALTER FUNCTION public.process_nomp_appliance_dt() OWNER TO postgres;

--
-- TOC entry 158 (class 1255 OID 619914)
-- Dependencies: 6 1057
-- Name: process_nomp_enablepasswd_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_nomp_enablepasswd_dt() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.stralias = NEW.stralias AND 
			OLD.strenablepasswd = NEW.strenablepasswd AND
			OLD.bmodified = NEW.bmodified AND			
			OLD.strenableusername = NEW.strenableusername AND
			OLD.ipri = NEW.ipri			
		 then
			return OLD;
		end IF;
		update objtimestamp set modifytime=now() where typename='NetworkSetting';
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='NetworkSetting';
		NEW.ipri=nextval('nomp_enablepasswd_ipri_seq'::regclass);
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='NetworkSetting';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$$;


ALTER FUNCTION public.process_nomp_enablepasswd_dt() OWNER TO postgres;

--
-- TOC entry 159 (class 1255 OID 619915)
-- Dependencies: 1057 6
-- Name: process_nomp_jumpbox_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_nomp_jumpbox_dt() RETURNS trigger
    LANGUAGE plpgsql
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
			OLD.ipri = NEW.ipri AND
			OLD.userid= NEW.userid AND
			OLD.licguid=NEW.licguid			
		 then
			return OLD;
		end IF;
		update objtimestamp set modifytime=now() where typename='NetworkSetting';
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='NetworkSetting';
		NEW.ipri=nextval('nomp_jumpbox_ipri_seq'::regclass);
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='NetworkSetting';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$$;


ALTER FUNCTION public.process_nomp_jumpbox_dt() OWNER TO postgres;

--
-- TOC entry 160 (class 1255 OID 619916)
-- Dependencies: 6 1057
-- Name: process_nomp_snmproinfo_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_nomp_snmproinfo_dt() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.strrostring = NEW.strrostring AND 			
			OLD.bmodified = NEW.bmodified AND			
			OLD.ipri = NEW.ipri AND
			OLD.stralias=NEW.stralias AND
			OLD.authentication_method=NEW.authentication_method AND
			OLD.encryption_method=NEW.encryption_method AND
			OLD.snmpv3_username=NEW.snmpv3_username AND
			OLD.snmpv3_authentication=NEW.snmpv3_authentication AND
			OLD.snmpv3_encryption=NEW.snmpv3_encryption AND
			OLD.version=NEW.version AND
			OLD.authentication_mode=NEW.authentication_mode			
		 then
			return OLD;
		end IF;
		update objtimestamp set modifytime=now() where typename='NetworkSetting';
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='NetworkSetting';
		NEW.ipri=nextval('nomp_snmproinfo_ipri_seq'::regclass);
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='NetworkSetting';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$$;


ALTER FUNCTION public.process_nomp_snmproinfo_dt() OWNER TO postgres;

--
-- TOC entry 161 (class 1255 OID 619917)
-- Dependencies: 1057 6
-- Name: process_nomp_telnetinfo_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_nomp_telnetinfo_dt() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.stralias = NEW.stralias AND 			
			OLD.idevicetype = NEW.idevicetype AND 			
			OLD.strusername = NEW.strusername AND 			
			OLD.strpasswd = NEW.strpasswd AND 			
			OLD.bmodified = NEW.bmodified AND 			
			OLD.userid = NEW.userid AND 			
			OLD.ipri = NEW.ipri AND
			OLD.licguid=NEW.licguid
		 then
			return OLD;
		end IF;
		update objtimestamp set modifytime=now() where typename='NetworkSetting';
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='NetworkSetting';
		NEW.ipri=nextval('nomp_telnetinfo_ipri_seq'::regclass);
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='NetworkSetting';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$$;


ALTER FUNCTION public.process_nomp_telnetinfo_dt() OWNER TO postgres;

--
-- TOC entry 162 (class 1255 OID 619918)
-- Dependencies: 6 1057
-- Name: process_object_customized_attribute_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_object_customized_attribute_dt() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.objectid = NEW.objectid AND 
			OLD.name = NEW.name AND
			OLD.alias = NEW.alias AND
			OLD.allow_export = NEW.allow_export AND
			OLD.type = NEW.type AND
			OLD.allow_modify_exported = NEW.allow_modify_exported
		 then
			return OLD;
		end IF;
		update objtimestamp set modifytime=now() where typename='object_customized_attribute';
		NEW.lasttimestamp=now();
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='object_customized_attribute';
		NEW.lasttimestamp=now();
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='object_customized_attribute';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$$;


ALTER FUNCTION public.process_object_customized_attribute_dt() OWNER TO postgres;

--
-- TOC entry 163 (class 1255 OID 619919)
-- Dependencies: 6 1057
-- Name: process_object_file_path_info_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_object_file_path_info_dt() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		NEW.path_update_time=now();	
		update objtimestamp set modifytime=now() where typename='Shared_Map';
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		NEW.path_update_time=now();
		NEW.lasttimestamp=now();
		update objtimestamp set modifytime=now() where typename='Shared_Map';
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='Shared_Map';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$$;


ALTER FUNCTION public.process_object_file_path_info_dt() OWNER TO postgres;

--
-- TOC entry 164 (class 1255 OID 619920)
-- Dependencies: 6 1057
-- Name: process_showcommandtemplate_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_showcommandtemplate_dt() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		NEW.lasttimestamp=now();
		update objtimestamp set modifytime=now() where typename='showcommandtemplate';
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN		
		NEW.lasttimestamp=now();
		update objtimestamp set modifytime=now() where typename='showcommandtemplate';
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='showcommandtemplate';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$$;


ALTER FUNCTION public.process_showcommandtemplate_dt() OWNER TO postgres;

--
-- TOC entry 165 (class 1255 OID 619921)
-- Dependencies: 6 1057
-- Name: process_site2site_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_site2site_dt() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
		
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.id = NEW.id AND 			
			OLD.siteid = NEW.siteid AND 			
			OLD.parentid = NEW.parentid 			
		 then
			return OLD;
		end IF;
		update objtimestamp set modifytime=now() where typename='site';
		update site set lasttimestamp=now() where id=NEW.siteid;
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='site';
		update site set lasttimestamp=now() where id=NEW.siteid;
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='site';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$$;


ALTER FUNCTION public.process_site2site_dt() OWNER TO postgres;

--
-- TOC entry 166 (class 1255 OID 619922)
-- Dependencies: 1057 6
-- Name: process_site_customized_info_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_site_customized_info_dt() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
		
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.objectid = NEW.objectid AND 			
			OLD.attributeid = NEW.attributeid AND 			
			OLD.attribute_value = NEW.attribute_value		
		 then
			return OLD;
		end IF;
		update objtimestamp set modifytime=now() where typename='site_customized_info';
		NEW.lasttimestamp=now();	
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
		update objtimestamp set modifytime=now() where typename='site_customized_info';
		NEW.lasttimestamp=now();
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='site_customized_info';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$$;


ALTER FUNCTION public.process_site_customized_info_dt() OWNER TO postgres;

--
-- TOC entry 167 (class 1255 OID 619923)
-- Dependencies: 6 1057
-- Name: process_site_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_site_dt() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
		
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.id = NEW.id AND 			
			OLD.name = NEW.name AND 			
			OLD.region = NEW.region AND 						
			OLD.location_address = NEW.location_address AND
			OLD.employee_number = NEW.employee_number AND
			OLD.contact_name = NEW.contact_name AND
			OLD.phone_number = NEW.phone_number AND
			OLD.email = NEW.email AND
			OLD.type = NEW.type AND
			OLD.color = NEW.color AND
			OLD.comment = NEW.comment 			
		 then
			return OLD;
		end IF;
		
		if(SiteNameExists(New.name,NEW.id)=true) then
			RAISE EXCEPTION 'name exists';
		end if;
		
		update objtimestamp set modifytime=now() where typename='site';
		NEW.lasttimestamp=now();	
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN

		if(SiteNameExists(New.name,0)=true) then
			RAISE EXCEPTION 'name exists';
		end if;

		update objtimestamp set modifytime=now() where typename='site';
		NEW.lasttimestamp=now();
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='site';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$$;


ALTER FUNCTION public.process_site_dt() OWNER TO postgres;

--
-- TOC entry 168 (class 1255 OID 619924)
-- Dependencies: 1057 6
-- Name: process_snmprwstring(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_snmprwstring() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
                NEW.ipri=OLD.ipri;		
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN                
		NEW.ipri=nextval('nomp_snmprwinfo_ipri_seq'::regclass);						                				
		RETURN NEW;        
        END IF;
        RETURN NULL;
    END;
$$;


ALTER FUNCTION public.process_snmprwstring() OWNER TO postgres;

--
-- TOC entry 169 (class 1255 OID 619925)
-- Dependencies: 1057 6
-- Name: process_switchgroup_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_switchgroup_dt() RETURNS trigger
    LANGUAGE plpgsql
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
$$;


ALTER FUNCTION public.process_switchgroup_dt() OWNER TO postgres;

--
-- TOC entry 170 (class 1255 OID 619926)
-- Dependencies: 6 1057
-- Name: process_swtichgroupdevice_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_swtichgroupdevice_dt() RETURNS trigger
    LANGUAGE plpgsql
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
$$;


ALTER FUNCTION public.process_swtichgroupdevice_dt() OWNER TO postgres;

--
-- TOC entry 171 (class 1255 OID 619927)
-- Dependencies: 6 1057
-- Name: process_symbol2deviceicon_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_symbol2deviceicon_dt() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
		
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.symbolid = NEW.symbolid AND
			OLD.deviceicon_id=NEW.deviceicon_id			
		then
			return OLD;
		end IF;		
		NEW.lasttimestamp=now();	
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN		
		NEW.lasttimestamp=now();
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN		
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$$;


ALTER FUNCTION public.process_symbol2deviceicon_dt() OWNER TO postgres;

--
-- TOC entry 172 (class 1255 OID 619928)
-- Dependencies: 6 1057
-- Name: process_symbol2deviceicon_selected_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_symbol2deviceicon_selected_dt() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
		
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.symbolid = NEW.symbolid AND
			OLD.default_deviceicon_id=NEW.default_deviceicon_id AND
			OLD.selected_deviceicon_id=NEW.selected_deviceicon_id			
		then
			return OLD;
		end IF;		
		NEW.lasttimestamp=now();	
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN		
		NEW.lasttimestamp=now();
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN		
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$$;


ALTER FUNCTION public.process_symbol2deviceicon_selected_dt() OWNER TO postgres;

--
-- TOC entry 173 (class 1255 OID 619929)
-- Dependencies: 6 1057
-- Name: process_system_devicespec_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_system_devicespec_dt() RETURNS trigger
    LANGUAGE plpgsql
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
			OLD.strquit = NEW.strquit AND
			OLD.strshowstpcmd = NEW.strshowstpcmd
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
$$;


ALTER FUNCTION public.process_system_devicespec_dt() OWNER TO postgres;

--
-- TOC entry 174 (class 1255 OID 619930)
-- Dependencies: 6 1057
-- Name: process_system_vendormodel2device_icon_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_system_vendormodel2device_icon_dt() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
		
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.vendormodel_id = NEW.vendormodel_id AND
			OLD.deviceicon_id=NEW.deviceicon_id			
		then
			return OLD;
		end IF;		
		NEW.lasttimestamp=now();	
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN		
		NEW.lasttimestamp=now();
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN		
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$$;


ALTER FUNCTION public.process_system_vendormodel2device_icon_dt() OWNER TO postgres;

--
-- TOC entry 175 (class 1255 OID 619931)
-- Dependencies: 1057 6
-- Name: process_system_vendormodel_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_system_vendormodel_dt() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF 	OLD.idevicetype = NEW.idevicetype AND 
			OLD.strvendorname = NEW.strvendorname AND
			OLD.bmodified = NEW.bmodified AND
			OLD.stroid = NEW.stroid AND
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
$$;


ALTER FUNCTION public.process_system_vendormodel_dt() OWNER TO postgres;

--
-- TOC entry 176 (class 1255 OID 619932)
-- Dependencies: 1057 6
-- Name: process_systemdevicegroup_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_systemdevicegroup_dt() RETURNS trigger
    LANGUAGE plpgsql
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
$$;


ALTER FUNCTION public.process_systemdevicegroup_dt() OWNER TO postgres;

--
-- TOC entry 177 (class 1255 OID 619933)
-- Dependencies: 6 1057
-- Name: process_systemdevicegroupdevice_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_systemdevicegroupdevice_dt() RETURNS trigger
    LANGUAGE plpgsql
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
$$;


ALTER FUNCTION public.process_systemdevicegroupdevice_dt() OWNER TO postgres;

--
-- TOC entry 178 (class 1255 OID 619934)
-- Dependencies: 1057 6
-- Name: process_unknownip_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_unknownip_dt() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF	OLD.nexthopip = NEW.nexthopip AND
			OLD.edgedevice = NEW.edgedevice AND
			OLD.edgeintf = NEW.edgeintf AND
			OLD.ipfrom = NEW.ipfrom AND
			OLD.ipmask = NEW.ipmask AND
			OLD.intfdesc = NEW.intfdesc AND
			OLD.findtime = NEW.findtime AND
			OLD.collectsource=NEW.collectsource AND
			OLD.description=NEW.description AND
			OLD.itype=NEW.itype
		 then
			return OLD;
		end IF;
		update objtimestamp set modifytime=now() where typename='unknownip';	
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN		
		update objtimestamp set modifytime=now() where typename='unknownip';		
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		update objtimestamp set modifytime=now() where typename='unknownip';
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$$;


ALTER FUNCTION public.process_unknownip_dt() OWNER TO postgres;

--
-- TOC entry 179 (class 1255 OID 619935)
-- Dependencies: 1057 6
-- Name: process_userdevicesetting_dt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_userdevicesetting_dt() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare tid integer;
declare uid integer;
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
		IF  OLD.deviceid = NEW.deviceid AND 
		   OLD.userid = NEW.userid AND
		   OLD.managerip = NEW.managerip AND
		   OLD.telnetusername = NEW.telnetusername AND 
		   OLD.telnetpwd = NEW.telnetpwd AND
		   OLD.jumpboxid = NEW.jumpboxid AND
		   OLD.licguid=NEW.licguid
		   then
			return OLD;
		end IF;
		NEW.dtstamp=now();
		  select id into tid from objprivatetimestamp where typename='PrivateDeviceSetting' and userid=new.userid and licguid=new.licguid;
		  if tid is null then
		   insert into objprivatetimestamp (typename,userid,modifytime,licguid) values('PrivateDeviceSetting',new.userid,now(),new.licguid);
		  else
		   update objprivatetimestamp set modifytime=now() where typename='PrivateDeviceSetting' and userid=new.userid and licguid=new.licguid;
		  end if;
		RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
	  select id into tid from objprivatetimestamp where typename='PrivateDeviceSetting' and userid=new.userid and licguid=new.licguid;
	  if tid is null then
	   insert into objprivatetimestamp (typename,userid,modifytime,licguid) values('PrivateDeviceSetting',new.userid,now(),new.licguid);
	  else
	   update objprivatetimestamp set modifytime=now() where typename='PrivateDeviceSetting' and userid=new.userid and licguid=new.licguid;
	  end if;
	  NEW.dtstamp=now();
  RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
			select id into tid from objprivatetimestamp where typename='PrivateDeviceSetting' and userid=old.userid and licguid=OLD.licguid;
			if tid is null then
				insert into objprivatetimestamp (typename,userid,modifytime,licguid) values('PrivateDeviceSetting',old.userid,now(),old.licguid);
			else
				update objprivatetimestamp set modifytime=now() where typename='PrivateDeviceSetting' and userid=old.userid and licguid=OLD.licguid;
			end if;
	  RETURN OLD;  
        END IF;
        RETURN NULL;
    END;
    $$;


ALTER FUNCTION public.process_userdevicesetting_dt() OWNER TO postgres;

--
-- TOC entry 180 (class 1255 OID 619936)
-- Dependencies: 1057 6
-- Name: process_userinfo_p(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION process_userinfo_p() RETURNS trigger
    LANGUAGE plpgsql
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
$$;


ALTER FUNCTION public.process_userinfo_p() OWNER TO postgres;

--
-- TOC entry 181 (class 1255 OID 619937)
-- Dependencies: 6 1057
-- Name: removedevicesetting_applianceid(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION removedevicesetting_applianceid(appid integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN
	UPDATE devicesetting SET appliceid=0 WHERE appliceid=appid;
	return 1;
End;
$$;


ALTER FUNCTION public.removedevicesetting_applianceid(appid integer) OWNER TO postgres;

--
-- TOC entry 182 (class 1255 OID 619938)
-- Dependencies: 584 6 1057
-- Name: retrieve_all_devices_by_siteid(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION retrieve_all_devices_by_siteid(id integer) RETURNS SETOF devices
    LANGUAGE plpgsql
    AS $$

DECLARE
    r devices%rowtype;
    r1 integer;
    idt integer[];
    idt1 integer[];
    c integer;
BEGIN		
	if 1 = id then
		for r in SELECT * FROM devices loop
		return next r;
		end loop;
	else
		for r in select * from devices, devicesitedevice where devices.id=devicesitedevice.deviceid and devicesitedevice.siteid=id loop
		return next r;
		end loop;
	
		c=1;
		idt=array[id];
		while c > 0 loop 
			for r in select * from retrieve_only_unassign_devices_by_parentsiteids( idt ) loop
			return next r;
			end loop;

			idt1=NULL;
			c=0;
			for r1 in select siteid from site2site where parentid = any( idt ) loop
				c=1;
				idt1=idt1||r1;
			end loop;
			idt=idt1;
		end loop;
	end if;
END;
$$;


ALTER FUNCTION public.retrieve_all_devices_by_siteid(id integer) OWNER TO postgres;

--
-- TOC entry 183 (class 1255 OID 619939)
-- Dependencies: 584 6 1057
-- Name: retrieve_all_devices_by_siteids(integer[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION retrieve_all_devices_by_siteids(ids integer[]) RETURNS SETOF devices
    LANGUAGE plpgsql
    AS $$

DECLARE
    r devices%rowtype;
    idps integer[];
    idps1 integer[];
    pid integer;
    f1 integer;
    f2 integer;
    f3 integer;    
    idv integer;
    len integer;
BEGIN		
	idps = ids;
	select array_length( idps, 1 ) into len;
	f1=0;
	while f1 < len loop
		idv=idps[f1+1];
		f2=1;
		while f2 > 0 loop
			select parentid into pid from site2site where siteid=idv;
			f3=0;
			if pid is null then
				f3=1;
			elsif  pid = 0 then 
				f2=0;
				f1 = f1 + 1;
			elsif pid = any( idps ) then
				f3=1;
			else
				idv=pid;
			end if;

			if f3=1 then
				f2=0;
				idps1=array[]::integer[];
				while f2 < len loop
					if f2 <> f1 then
						idps1=idps1||idps[f2+1];
					end if;
					f2 = f2 + 1;
				end loop;
				idps=idps1;
				f2=0;
				len = len -1;
			end if;
		end loop;
	end loop;

	select array_length( idps, 1 ) into len;
	f1=0;
	while f1 < len loop
		idv=idps[f1+1];
		for r in select * from retrieve_all_devices_by_siteid( idv ) loop
			return next r;
		end loop;
		f1 = f1 + 1;
	end loop;
END;
$$;


ALTER FUNCTION public.retrieve_all_devices_by_siteids(ids integer[]) OWNER TO postgres;

--
-- TOC entry 184 (class 1255 OID 619940)
-- Dependencies: 6 1057 584
-- Name: retrieve_all_devices_only_unassign_devices_by_siteids(integer[], integer[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION retrieve_all_devices_only_unassign_devices_by_siteids(ids integer[], uids integer[]) RETURNS SETOF devices
    LANGUAGE plpgsql
    AS $$

DECLARE
    r devices%rowtype;
BEGIN		
	for r in ( select * from retrieve_all_devices_by_siteids( ids ) union select * from retrieve_only_unassign_devices_by_siteids( uids ) )loop
	return next r;
	end loop;
	
END;
$$;


ALTER FUNCTION public.retrieve_all_devices_only_unassign_devices_by_siteids(ids integer[], uids integer[]) OWNER TO postgres;

--
-- TOC entry 185 (class 1255 OID 619941)
-- Dependencies: 6 584 1057
-- Name: retrieve_device_by_dgids(integer[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION retrieve_device_by_dgids(iddg integer[]) RETURNS SETOF devices
    LANGUAGE plpgsql
    AS $$

DECLARE
    r devices%rowtype;
BEGIN		
		     FOR r IN select distinct * from 
		     (select devices.* from devices, devicegroupdevice where devices.id=devicegroupdevice.deviceid and devicegroupdevice.devicegroupid = any(iddg) 
			) c LOOP
			RETURN NEXT r;
		     END LOOP;	     		    
END;
$$;


ALTER FUNCTION public.retrieve_device_by_dgids(iddg integer[]) OWNER TO postgres;

--
-- TOC entry 142 (class 1255 OID 619942)
-- Dependencies: 1057 6 584
-- Name: retrieve_device_by_dgids_systemdgids(integer[], integer[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION retrieve_device_by_dgids_systemdgids(iddg integer[], idsysdg integer[]) RETURNS SETOF devices
    LANGUAGE plpgsql
    AS $$

DECLARE
    r devices%rowtype;
BEGIN		
		     FOR r IN select distinct * from 
		     (select devices.* from devices, devicegroupdevice where devices.id=devicegroupdevice.deviceid and devicegroupdevice.devicegroupid = any(iddg) 
		     union 
		     select devices.* from devices, systemdevicegroupdevice where devices.id=systemdevicegroupdevice.deviceid and systemdevicegroupdevice.systemdevicegroupid = any(idsysdg) ) c LOOP
			RETURN NEXT r;
		     END LOOP;	     		    
END;
$$;


ALTER FUNCTION public.retrieve_device_by_dgids_systemdgids(iddg integer[], idsysdg integer[]) OWNER TO postgres;

--
-- TOC entry 157 (class 1255 OID 619943)
-- Dependencies: 6 584 1057
-- Name: retrieve_device_by_siteanddgids(integer[], integer[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION retrieve_device_by_siteanddgids(iddg integer[], idsite integer[]) RETURNS SETOF devices
    LANGUAGE plpgsql
    AS $$

DECLARE
    r devices%rowtype;
BEGIN		
		     FOR r IN select distinct * from 
		     (select devices.* from devices, devicegroupdevice where devices.id=devicegroupdevice.deviceid and devicegroupdevice.devicegroupid = any(iddg) 
		     union 
		     select devices.* from devices, devicesitedeviceview where devices.id=devicesitedeviceview.deviceid and devicesitedeviceview.siteid = any(idsite)) c LOOP
			RETURN NEXT r;
		     END LOOP;	     		    
END;
$$;


ALTER FUNCTION public.retrieve_device_by_siteanddgids(iddg integer[], idsite integer[]) OWNER TO postgres;

--
-- TOC entry 186 (class 1255 OID 619944)
-- Dependencies: 6 584 1057
-- Name: retrieve_device_by_siteanddgidswithappid(integer[], integer[], integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION retrieve_device_by_siteanddgidswithappid(iddg integer[], idsite integer[], iappid integer) RETURNS SETOF devices
    LANGUAGE plpgsql
    AS $$

DECLARE
    r devices%rowtype;
BEGIN		
		     FOR r IN select distinct * from 
		     (select devices.* from devices, devicegroupdevice,devicesetting where devicesetting.appliceid=iappid and devicesetting.deviceid=devices.id and devices.id=devicegroupdevice.deviceid and devicegroupdevice.devicegroupid = any(iddg) 
		     union 
		     select devices.* from devices, devicesitedeviceview,devicesetting where devicesetting.appliceid=iappid and devicesetting.deviceid=devices.id and devices.id=devicesitedeviceview.deviceid and devicesitedeviceview.siteid = any(idsite)) c LOOP
			RETURN NEXT r;
		     END LOOP;	     		    
END;
$$;


ALTER FUNCTION public.retrieve_device_by_siteanddgidswithappid(iddg integer[], idsite integer[], iappid integer) OWNER TO postgres;

--
-- TOC entry 187 (class 1255 OID 619945)
-- Dependencies: 1057 584 6
-- Name: retrieve_device_by_siteids(integer[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION retrieve_device_by_siteids(ids integer[]) RETURNS SETOF devices
    LANGUAGE plpgsql
    AS $$

DECLARE
    r devices%rowtype;
BEGIN		
		     FOR r IN select devices.* from devices, devicesitedevice where devices.id=devicesitedevice.deviceid and devicesitedevice.siteid = any(ids) LOOP
			RETURN NEXT r;
		     END LOOP;	     		    
END;
$$;


ALTER FUNCTION public.retrieve_device_by_siteids(ids integer[]) OWNER TO postgres;

--
-- TOC entry 188 (class 1255 OID 619946)
-- Dependencies: 584 1057 6
-- Name: retrieve_device_by_systemdgids(integer[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION retrieve_device_by_systemdgids(iddg integer[]) RETURNS SETOF devices
    LANGUAGE plpgsql
    AS $$

DECLARE
    r devices%rowtype;
BEGIN		
		     FOR r IN select distinct * from 
		     (select devices.* from devices, systemdevicegroupdevice where devices.id=systemdevicegroupdevice.deviceid and systemdevicegroupdevice.systemdevicegroupid = any(iddg) 
			) c LOOP
			RETURN NEXT r;
		     END LOOP;	     		    
END;
$$;


ALTER FUNCTION public.retrieve_device_by_systemdgids(iddg integer[]) OWNER TO postgres;

--
-- TOC entry 189 (class 1255 OID 619947)
-- Dependencies: 6 602 1057
-- Name: retrieve_device_setting(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION retrieve_device_setting(devname character varying) RETURNS SETOF devicesetting
    LANGUAGE plpgsql
    AS $$
declare
	r devicesetting%rowtype;
BEGIN
   for r in SELECT * FROM devicesetting where deviceid IN ( select id from devices where strname=devname ) loop
   return next r;
   end loop;
END;

  $$;


ALTER FUNCTION public.retrieve_device_setting(devname character varying) OWNER TO postgres;

--
-- TOC entry 190 (class 1255 OID 619948)
-- Dependencies: 1057 6 584
-- Name: retrieve_only_unassign_devices_by_parentsiteids(integer[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION retrieve_only_unassign_devices_by_parentsiteids(ids integer[]) RETURNS SETOF devices
    LANGUAGE plpgsql
    AS $$

DECLARE
    r devices%rowtype;
BEGIN		
	for r in select devices.* from devices, devicesitedevice where devices.id = devicesitedevice.deviceid and  devicesitedevice.siteid in
		( select siteid from site2site where parentid = any(ids) ) loop
		RETURN NEXT r;
	END LOOP;	    	
END;
$$;


ALTER FUNCTION public.retrieve_only_unassign_devices_by_parentsiteids(ids integer[]) OWNER TO postgres;

--
-- TOC entry 191 (class 1255 OID 619949)
-- Dependencies: 6 584 1057
-- Name: retrieve_only_unassign_devices_by_siteids(integer[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION retrieve_only_unassign_devices_by_siteids(ids integer[]) RETURNS SETOF devices
    LANGUAGE plpgsql
    AS $$

DECLARE
    r devices%rowtype;
    len integer;
    i integer;
BEGIN
	for r in select devices.* from devices, devicesitedevice where devices.id = devicesitedevice.deviceid and  devicesitedevice.siteid = any( ids ) loop
		RETURN NEXT r;
	END LOOP;	    	

	if 1=any(ids ) then
		for r in select devices.* from devices where devices.id not in ( select deviceid from devicesitedevice) loop
			RETURN NEXT r;
		END LOOP;	    
	end if;

END;
$$;


ALTER FUNCTION public.retrieve_only_unassign_devices_by_siteids(ids integer[]) OWNER TO postgres;

--
-- TOC entry 192 (class 1255 OID 619950)
-- Dependencies: 6 1057 584
-- Name: searchalldevice(character varying, integer[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION searchalldevice(devname character varying, filer integer[]) RETURNS SETOF devices
    LANGUAGE plpgsql
    AS $$

DECLARE
    r devices%rowtype;
BEGIN	
	
             FOR r IN select * from (select deviceid as id,(select strname from devices where devices.id=devicesetting.deviceid) as strname from devicesetting where subtype = any( filer ) order by strname ) as a where lower(a.strname) like '%'||devname||'%' order by a.strname limit 1 LOOP
		RETURN NEXT r;
	     END LOOP;	     		
END;
$$;


ALTER FUNCTION public.searchalldevice(devname character varying, filer integer[]) OWNER TO postgres;

--
-- TOC entry 193 (class 1255 OID 619951)
-- Dependencies: 6 1057 608
-- Name: searchalldevicenofiler(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION searchalldevicenofiler(devname character varying) RETURNS SETOF devicesettingview
    LANGUAGE plpgsql
    AS $$

DECLARE
    r devicesettingview%rowtype;
BEGIN	
	
             FOR r IN select * from devicesettingview  where lower(devicename) like '%'||devname||'%' order by lower(devicename) limit 1 LOOP
		RETURN NEXT r;
	     END LOOP;	     		
END;
$$;


ALTER FUNCTION public.searchalldevicenofiler(devname character varying) OWNER TO postgres;

--
-- TOC entry 194 (class 1255 OID 619952)
-- Dependencies: 6 1057 608
-- Name: searchalldevicenofiler(character varying, integer, integer[], character varying[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION searchalldevicenofiler(devname character varying, preid integer, types integer[], devnames character varying[]) RETURNS SETOF devicesettingview
    LANGUAGE plpgsql
    AS $$

DECLARE
    r devicesettingview%rowtype;
    npreid integer;
BEGIN	
     npreid:=0;
     FOR r IN select * from devicesettingview  where devicename=any(devnames) and lower(devicename) like '%'||devname||'%' and subtype = any( types ) order by lower(devicename) LOOP
	if npreid=preid then 
	    return next r;
	    return;
	end if;
	npreid := r.id;	
     END LOOP;
     return ;
END;

$$;


ALTER FUNCTION public.searchalldevicenofiler(devname character varying, preid integer, types integer[], devnames character varying[]) OWNER TO postgres;

--
-- TOC entry 195 (class 1255 OID 619953)
-- Dependencies: 6 1057 608
-- Name: searchalldevicenofiler(character varying, integer, character varying[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION searchalldevicenofiler(devname character varying, preid integer, devnames character varying[]) RETURNS SETOF devicesettingview
    LANGUAGE plpgsql
    AS $$

DECLARE
    r devicesettingview%rowtype;
    npreid integer;
BEGIN	
     npreid:=0;
     FOR r IN select * from devicesettingview  where devicename=any(devnames) and lower(devicename) like '%'||devname||'%' order by lower(devicename) LOOP
	if npreid=preid then 
	    return next r;
	    return;
	end if;
	npreid := r.id;	
     END LOOP;
     return ;
END;

$$;


ALTER FUNCTION public.searchalldevicenofiler(devname character varying, preid integer, devnames character varying[]) OWNER TO postgres;

--
-- TOC entry 196 (class 1255 OID 619954)
-- Dependencies: 6 1057 584
-- Name: searchdevicebygroup(character varying, integer, integer[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION searchdevicebygroup(devname character varying, gid integer, filer integer[]) RETURNS SETOF devices
    LANGUAGE plpgsql
    AS $$

DECLARE
    r devices%rowtype;
BEGIN	
             FOR r IN select * from (select deviceid as id,(select strname from devices where devices.id=devicesetting.deviceid) as strname  from devicesetting where subtype = any( filer ) and deviceid in (select deviceid from devicegroupdevice where devicegroupdevice.devicegroupid=gid) order by strname ) as a where lower(a.strname) like '%'||devname||'%' order by a.strname limit 1 LOOP
		RETURN NEXT r;
	     END LOOP;	     		
END;
$$;


ALTER FUNCTION public.searchdevicebygroup(devname character varying, gid integer, filer integer[]) OWNER TO postgres;

--
-- TOC entry 197 (class 1255 OID 619955)
-- Dependencies: 6 1057 608
-- Name: searchdevicebygroupnofiler(character varying, integer, integer, character varying[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION searchdevicebygroupnofiler(devname character varying, gid integer, preid integer, devnames character varying[]) RETURNS SETOF devicesettingview
    LANGUAGE plpgsql
    AS $$

DECLARE
    r devicesettingview%rowtype;
    npreid integer;
BEGIN
     npreid:=0;	
     FOR r IN select * from devicesettingview where deviceid in (select deviceid from devicegroupdeviceview where devicename=any(devnames) and devicegroupid=gid and lower(devicename) like '%'||devname||'%') order by lower(devicename)   LOOP
	if npreid=preid then 
	    return next r;
	    return;
	end if;
	npreid := r.id;	
     END LOOP;
     return ;		
END;
$$;


ALTER FUNCTION public.searchdevicebygroupnofiler(devname character varying, gid integer, preid integer, devnames character varying[]) OWNER TO postgres;

--
-- TOC entry 198 (class 1255 OID 619956)
-- Dependencies: 6 608 1057
-- Name: searchdevicebygroupnofiler(character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION searchdevicebygroupnofiler(devname character varying, gid integer) RETURNS SETOF devicesettingview
    LANGUAGE plpgsql
    AS $$

DECLARE
    r devicesettingview%rowtype;
BEGIN	
             FOR r IN select * from devicesettingview where deviceid in (select deviceid from devicegroupdeviceview where devicegroupid=gid and lower(devicename) like '%'||devname||'%' order by devicename limit 1 )  LOOP
		RETURN NEXT r;
	     END LOOP;	     		
END;
$$;


ALTER FUNCTION public.searchdevicebygroupnofiler(devname character varying, gid integer) OWNER TO postgres;

--
-- TOC entry 200 (class 1255 OID 619957)
-- Dependencies: 608 6 1057
-- Name: searchdevicebygroupnofiler(character varying, integer, integer, integer[], character varying[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION searchdevicebygroupnofiler(devname character varying, gid integer, preid integer, types integer[], devnames character varying[]) RETURNS SETOF devicesettingview
    LANGUAGE plpgsql
    AS $$

DECLARE
    r devicesettingview%rowtype;
    npreid integer;
BEGIN
     npreid:=0;	
     FOR r IN select * from devicesettingview where devicename=any(devnames) and subtype = any( types ) and  deviceid in (select deviceid from devicegroupdeviceview where devicename=any(devnames) and devicegroupid=gid and subtype = any( types ) and lower(devicename) like '%'||devname||'%' ) order by lower(devicename)  LOOP
	if npreid=preid then 
	    return next r;
	    return;
	end if;
	npreid := r.id;	
     END LOOP;
     return ;		
END;
$$;


ALTER FUNCTION public.searchdevicebygroupnofiler(devname character varying, gid integer, preid integer, types integer[], devnames character varying[]) OWNER TO postgres;

--
-- TOC entry 2283 (class 1259 OID 619958)
-- Dependencies: 2951 2952 2953 2954 2955 6
-- Name: showcommandbenchmarktask; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE showcommandbenchmarktask (
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
    lastruntime timestamp without time zone,
    description character varying(256) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.showcommandbenchmarktask OWNER TO postgres;

--
-- TOC entry 201 (class 1255 OID 619966)
-- Dependencies: 6 671 1057
-- Name: showcmdbtaskadd(character varying[], integer[], integer[], showcommandbenchmarktask); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION showcmdbtaskadd(cmds character varying[], dgids integer[], siteids integer[], showbtask showcommandbenchmarktask) RETURNS integer
    LANGUAGE plpgsql
    AS $$
declare
	t_id integer;
BEGIN
	INSERT INTO showcommandbenchmarktask(itype
            , strname
            , creator
            , createtime
            , modifytime
            , imode
            , startday
            , starttime
            , every
            , iselect
            , monthday
            , benable
            , lastruntime
            ,description)
    VALUES ( showbtask.itype
    , showbtask.strname
    ,showbtask.creator
    ,showbtask.createtime
    ,showbtask.modifytime
    ,showbtask.imode
    ,showbtask.startday
    ,showbtask.starttime
    ,showbtask.every
    ,showbtask.iselect
    ,showbtask.monthday
    ,showbtask.benable
    , showbtask.lastruntime
    ,showbtask.description);
 t_id=lastval();
 
	if char_length(cmds[1])>0 then
		for r in  1..array_length(cmds,1) loop
		       insert into showcommandbenchmarktaskcmddetail (taskid,showcommandinfo) values (t_id,cmds[r]);              
		end loop;
	end if;

	if dgids[1]>-1 then
		for r in  1..array_length(dgids,1) loop
		       insert into showcommandbenchmarktaskdgdetail (taskid,devicegroupid) values (t_id,dgids[r]);              
		end loop;
	end if;

	if siteids[1]>-1 then
	for r in  1..array_length(siteids,1) loop
	       insert into showcommandbenchmarktasksitedetail (taskid,siteid) values (t_id,siteids[r]);              
	end loop;
	end if;
	
	return t_id;

End;
$$;


ALTER FUNCTION public.showcmdbtaskadd(cmds character varying[], dgids integer[], siteids integer[], showbtask showcommandbenchmarktask) OWNER TO postgres;

--
-- TOC entry 202 (class 1255 OID 619967)
-- Dependencies: 6 671 1057
-- Name: showcmdbtaskmodify(character varying[], integer[], integer[], showcommandbenchmarktask); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION showcmdbtaskmodify(cmds character varying[], dgids integer[], siteids integer[], showbtask showcommandbenchmarktask) RETURNS integer
    LANGUAGE plpgsql
    AS $$
declare
	t_id integer;
BEGIN
	t_id = showbtask.id;
	UPDATE showcommandbenchmarktask
	SET itype=showbtask.itype
            , strname=showbtask.strname
            , creator=showbtask.creator
            , createtime=showbtask.createtime
            , modifytime=showbtask.modifytime
            , imode=showbtask.imode
            , startday=showbtask.startday
            , starttime=showbtask.starttime
            , every=showbtask.every
            , iselect=showbtask.iselect
            , monthday=showbtask.monthday
            , benable=showbtask.benable
            , lastruntime=showbtask.lastruntime
            ,description=showbtask.description
       WHERE id=showbtask.id;

	delete from showcommandbenchmarktaskcmddetail where taskid=showbtask.id;
	if char_length(cmds[1])>0 then
		for r in  1..array_length(cmds,1) loop
		       insert into showcommandbenchmarktaskcmddetail (taskid,showcommandinfo) values (t_id,cmds[r]);              
		end loop;
	end if;

	delete from showcommandbenchmarktaskdgdetail where taskid=showbtask.id;
	if dgids[1]>-1 then
		for r in  1..array_length(dgids,1) loop
		       insert into showcommandbenchmarktaskdgdetail (taskid,devicegroupid) values (t_id,dgids[r]);              
		end loop;
	end if;

	delete from showcommandbenchmarktasksitedetail where taskid=showbtask.id;
	if siteids[1]>-1 then
		for r in  1..array_length(siteids,1) loop
		       insert into showcommandbenchmarktasksitedetail (taskid,siteid) values (t_id,siteids[r]);              
		end loop;
	end if;

	return t_id;

End;
$$;


ALTER FUNCTION public.showcmdbtaskmodify(cmds character varying[], dgids integer[], siteids integer[], showbtask showcommandbenchmarktask) OWNER TO postgres;

--
-- TOC entry 2284 (class 1259 OID 619968)
-- Dependencies: 2958 6
-- Name: site; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE site (
    id integer NOT NULL,
    name character varying(64),
    region character varying(256),
    location_address character varying(256),
    employee_number integer,
    contact_name character varying(256),
    phone_number character varying(256),
    email character varying(256),
    type character varying(256),
    color integer,
    comment character varying(256),
    lasttimestamp timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.site OWNER TO postgres;

--
-- TOC entry 203 (class 1255 OID 619972)
-- Dependencies: 673 6 1057
-- Name: site_addormodify(integer, site); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION site_addormodify(nparent integer, ssite site) RETURNS integer
    LANGUAGE plpgsql
    AS $$
declare
	r_id integer;
	site_id integer;	
BEGIN
	select id into site_id from site where id=ssite.id;
	if site_id IS NULL THEN--insert 
		select id into r_id from site where id=nparent;
		if r_id is NULL THEN
			return -1;
		end if;
		insert into site (
		"name",
		region,
		location_address,
		employee_number,
		contact_name,
		phone_number,
		email,
		"type",
		color,
		"comment",
		lasttimestamp
		) values (
		ssite."name",
		ssite.region,
		ssite.location_address,
		ssite.employee_number,
		ssite.contact_name,
		ssite.phone_number,
		ssite.email,
		ssite."type",
		ssite.color,
		ssite."comment",
		now()
		);
		site_id:=lastval();
		insert into site2site (siteid,parentid) values(site_id,nparent);
		return site_id;
	ELSE -- update
		update site set(
		"name",
		region,
		location_address,
		employee_number,
		contact_name,
		phone_number,
		email,
		"type",
		color,
		"comment",
		lasttimestamp
		) =(
		ssite."name",
		ssite.region,
		ssite.location_address,
		ssite.employee_number,
		ssite.contact_name,
		ssite.phone_number,
		ssite.email,
		ssite."type",
		ssite.color,
		ssite."comment",
		now()
		)
		where id = site_id;
		return site_id;
	end if;
END;

  $$;


ALTER FUNCTION public.site_addormodify(nparent integer, ssite site) OWNER TO postgres;

--
-- TOC entry 2285 (class 1259 OID 619973)
-- Dependencies: 2960 6
-- Name: site_customized_info; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE site_customized_info (
    id integer NOT NULL,
    objectid integer NOT NULL,
    attributeid integer NOT NULL,
    attribute_value character varying(256),
    lasttimestamp timestamp without time zone DEFAULT now()
);


ALTER TABLE public.site_customized_info OWNER TO postgres;

--
-- TOC entry 2286 (class 1259 OID 619977)
-- Dependencies: 2624 6
-- Name: site_customized_infoview; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW site_customized_infoview AS
    SELECT site_customized_info.id, site_customized_info.objectid, site_customized_info.attributeid, site_customized_info.attribute_value, site_customized_info.lasttimestamp, site.name AS sitename FROM site_customized_info, site WHERE (site_customized_info.objectid = site.id);


ALTER TABLE public.site_customized_infoview OWNER TO postgres;

--
-- TOC entry 204 (class 1255 OID 619981)
-- Dependencies: 6 1057 677
-- Name: site_customized_infoview_upsert(site_customized_infoview); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION site_customized_infoview_upsert(dciv site_customized_infoview) RETURNS integer
    LANGUAGE plpgsql
    AS $$
declare		
	t_id integer;
BEGIN	
	select id into t_id from site_customized_infoview where objectid=dciv.objectid and attributeid=dciv.attributeid ;
	if t_id IS NULL THEN		
		insert into site_customized_info(
			objectid,
			attributeid,
			attribute_value
			)
			values ( 
			dciv.objectid,
			dciv.attributeid,
			dciv.attribute_value
		);

		return lastval();
	ELSE
		update site_customized_info set ( attribute_value)=( dciv.attribute_value ) where id = t_id;
		return t_id;
	end if;
END;

  $$;


ALTER FUNCTION public.site_customized_infoview_upsert(dciv site_customized_infoview) OWNER TO postgres;

--
-- TOC entry 205 (class 1255 OID 619982)
-- Dependencies: 1057 6 673
-- Name: site_devices_addormodify(integer, character varying[], site); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION site_devices_addormodify(nparent integer, devnames character varying[], ssite site) RETURNS integer
    LANGUAGE plpgsql
    AS $$
declare
	r_id integer;
	site_id integer;	
BEGIN
	site_id = site_addormodify(nparent , ssite);
	if site_id >0 THEN	

		r_id=device_site_set2(site_id,devnames);
	end if;
	
	return site_id;
END;

  $$;


ALTER FUNCTION public.site_devices_addormodify(nparent integer, devnames character varying[], ssite site) OWNER TO postgres;

--
-- TOC entry 206 (class 1255 OID 619983)
-- Dependencies: 1057 6
-- Name: site_remove(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION site_remove(nsiteid integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$

BEGIN
	delete from site2site where siteid=nsiteid;
	delete from site_customized_info where objectid=nsiteid;
	delete from site where id=nsiteid;		
	update objtimestamp set modifytime=now() where typename='site';
	return 1;
EXCEPTION
	WHEN OTHERS THEN 
		RETURN -1;
END;
$$;


ALTER FUNCTION public.site_remove(nsiteid integer) OWNER TO postgres;

--
-- TOC entry 207 (class 1255 OID 619984)
-- Dependencies: 1057 6
-- Name: sitenameexists(character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sitenameexists(sname character varying, nid integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
	if((select count(*) from site where id<>nid and lower("name") =lower(sname))=0) then
		return false;
	end if;
    
    RETURN true;
EXCEPTION
    WHEN OTHERS THEN 
	RETURN false;    
END;
$$;


ALTER FUNCTION public.sitenameexists(sname character varying, nid integer) OWNER TO postgres;

--
-- TOC entry 2287 (class 1259 OID 619985)
-- Dependencies: 6
-- Name: system_devicespec_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE system_devicespec_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.system_devicespec_id_seq OWNER TO postgres;

--
-- TOC entry 3826 (class 0 OID 0)
-- Dependencies: 2287
-- Name: system_devicespec_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('system_devicespec_id_seq', 25, true);


--
-- TOC entry 2288 (class 1259 OID 619987)
-- Dependencies: 2961 6
-- Name: system_devicespec; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE system_devicespec (
    id integer DEFAULT nextval('system_devicespec_id_seq'::regclass) NOT NULL,
    strvendorname character varying(64),
    strmodelname character varying(64),
    idevicetype integer,
    strcpuoid character varying(512),
    strmemoid character varying(512),
    strshowruncmd character varying(512),
    strshowiproutecmd character varying(32),
    strshowroutecountcmd character varying(512),
    strshowarpcmd character varying(512),
    strshowcamcmd character varying(64),
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
    strshowcdpcmd character varying(512),
    strinvalidcommandkey character varying(128),
    strquit character varying(32),
    strshowstpcmd character varying(100)
);


ALTER TABLE public.system_devicespec OWNER TO postgres;

--
-- TOC entry 199 (class 1255 OID 619994)
-- Dependencies: 680 6 1057
-- Name: system_devicespec_retrieve(timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION system_devicespec_retrieve(dt timestamp without time zone, stypename character varying) RETURNS SETOF system_devicespec
    LANGUAGE plpgsql
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

  $$;


ALTER FUNCTION public.system_devicespec_retrieve(dt timestamp without time zone, stypename character varying) OWNER TO postgres;

--
-- TOC entry 2289 (class 1259 OID 619995)
-- Dependencies: 6
-- Name: system_vendormodel_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE system_vendormodel_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.system_vendormodel_id_seq OWNER TO postgres;

--
-- TOC entry 3827 (class 0 OID 0)
-- Dependencies: 2289
-- Name: system_vendormodel_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('system_vendormodel_id_seq', 6001, true);


--
-- TOC entry 2290 (class 1259 OID 619997)
-- Dependencies: 2962 6
-- Name: system_vendormodel; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE system_vendormodel (
    id integer DEFAULT nextval('system_vendormodel_id_seq'::regclass) NOT NULL,
    stroid character varying(256),
    idevicetype integer,
    strvendorname character varying(64),
    strmodelname character varying(64),
    bmodified integer,
    strdriverid character varying(255),
    strcpuoid text,
    strmemoid text,
    autoupdate integer
);


ALTER TABLE public.system_vendormodel OWNER TO postgres;

--
-- TOC entry 132 (class 1255 OID 620004)
-- Dependencies: 6 1057 684
-- Name: system_vendormodel_retrieve(timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION system_vendormodel_retrieve(dt timestamp without time zone, stypename character varying) RETURNS SETOF system_vendormodel
    LANGUAGE plpgsql
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

  $$;


ALTER FUNCTION public.system_vendormodel_retrieve(dt timestamp without time zone, stypename character varying) OWNER TO postgres;

--
-- TOC entry 209 (class 1255 OID 620005)
-- Dependencies: 1057 6 684
-- Name: system_vendormodel_update2(system_vendormodel); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION system_vendormodel_update2(vm system_vendormodel) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
declare
	vm_id integer;	
	r discover_unknowdevice%rowtype;
BEGIN
	select id into vm_id from system_vendormodel where stroid=vm.stroid;

	if vm_id IS NULL THEN
		insert into system_vendormodel(	
			stroid, idevicetype, strvendorname, strmodelname, bmodified, strdriverid, strcpuoid, strmemoid, autoupdate 
		)
		values( 
			vm.stroid, vm.idevicetype, vm.strvendorname, vm.strmodelname, vm.bmodified, vm.strdriverid, vm.strcpuoid, vm.strmemoid, vm.autoupdate 	
		);	

		for r in SELECT * FROM discover_unknowdevice where sysobjectid = vm.stroid loop
			INSERT INTO unknownip(nexthopip, edgedevice, edgeintf, ipfrom, ipmask, intfdesc, findtime, collectsource, description, itype)VALUES (r.mgrip, '', '', '', '', '', r.findtime, 0, '', r.devtype);
		end loop;					

		delete from discover_unknowdevice where sysobjectid = vm.stroid;
	else
		update system_vendormodel set(
			idevicetype,
			strvendorname,
			strmodelname,
			bmodified,
			strdriverid,
			strcpuoid,
			strmemoid,
			autoupdate
		) = ( 
			vm.idevicetype,  
			vm.strvendorname,
			vm.strmodelname,
			vm.bmodified,
			vm.strdriverid,
			vm.strcpuoid,
			vm.strmemoid,
			vm.autoupdate
		) where id = vm_id;				
	end if;	
	
	return true;
END;

  $$;


ALTER FUNCTION public.system_vendormodel_update2(vm system_vendormodel) OWNER TO postgres;

--
-- TOC entry 210 (class 1255 OID 620006)
-- Dependencies: 6 684 1057
-- Name: system_vendormodel_upsert(system_vendormodel); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION system_vendormodel_upsert(oui system_vendormodel) RETURNS integer
    LANGUAGE plpgsql
    AS $$
declare	
	t_id integer;
BEGIN	
	select id into t_id from system_vendormodel where stroid=oui.stroid;
	if t_id IS NULL THEN
		insert into system_vendormodel(
			stroid,
			idevicetype,
			strvendorname,
			strmodelname,
			bmodified			
			)
			values ( 
			oui.stroid,
			oui.idevicetype,
			oui.strvendorname,
			oui.strmodelname,
			oui.bmodified
		);

		return lastval();
	ELSE
		update system_vendormodel set ( 
			stroid,
			idevicetype,
			strvendorname,
			strmodelname,
			bmodified
			)
			=( 
			oui.stroid,
			oui.idevicetype,
			oui.strvendorname,
			oui.strmodelname,
			oui.bmodified
			) 
			where id = t_id;
		return t_id;
	end if;
EXCEPTION
	WHEN OTHERS THEN 
		RETURN -2;
END;

  $$;


ALTER FUNCTION public.system_vendormodel_upsert(oui system_vendormodel) OWNER TO postgres;

--
-- TOC entry 2291 (class 1259 OID 620007)
-- Dependencies: 2964 6
-- Name: transport_protocol_port; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE transport_protocol_port (
    id integer NOT NULL,
    servername character varying(100) NOT NULL,
    portnumber integer NOT NULL,
    protocol character varying(50) NOT NULL,
    description character varying(250),
    userflag integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.transport_protocol_port OWNER TO postgres;

--
-- TOC entry 211 (class 1255 OID 620011)
-- Dependencies: 6 687 1057
-- Name: transport_protocol_port_upsert(transport_protocol_port); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION transport_protocol_port_upsert(oui transport_protocol_port) RETURNS integer
    LANGUAGE plpgsql
    AS $$
declare	
	t_id integer;
BEGIN	
	select id into t_id from transport_protocol_port where portnumber=oui.portnumber and protocol=oui.protocol;
	if t_id IS NULL THEN
		insert into transport_protocol_port(
			servername,
			portnumber,
			protocol,
			description,
			userflag
			)
			values ( 
			oui.servername,
			oui.portnumber,
			oui.protocol,
			oui.description,
			oui.userflag
		);

		return lastval();
	ELSE
		update transport_protocol_port set ( 
			servername,
			portnumber,
			protocol,
			description,
			userflag
			)
			=( 
			oui.servername,
			oui.portnumber,
			oui.protocol,
			oui.description,
			oui.userflag
			) 
			where id = t_id;
		return t_id;
	end if;
EXCEPTION
	WHEN OTHERS THEN 
		RETURN -2;
END;

  $$;


ALTER FUNCTION public.transport_protocol_port_upsert(oui transport_protocol_port) OWNER TO postgres;

--
-- TOC entry 212 (class 1255 OID 620012)
-- Dependencies: 6 1057
-- Name: updata_device_type(character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION updata_device_type(devname character varying, devtype integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$

BEGIN
        update devices set isubtype=devtype where strname=devname;				
	return true;
END;

  $$;


ALTER FUNCTION public.updata_device_type(devname character varying, devtype integer) OWNER TO postgres;

--
-- TOC entry 213 (class 1255 OID 620013)
-- Dependencies: 6 1057
-- Name: update_object_file_info_time(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION update_object_file_info_time(oid integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$

BEGIN    
    update object_file_info set file_update_time=now() where id=oid;
    RETURN true;
EXCEPTION
    WHEN OTHERS THEN 
	RETURN false;    
END;
$$;


ALTER FUNCTION public.update_object_file_info_time(oid integer) OWNER TO postgres;

--
-- TOC entry 214 (class 1255 OID 620014)
-- Dependencies: 1057 6
-- Name: update_object_file_path_info_time(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION update_object_file_path_info_time(oid integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$

BEGIN    
    update object_file_path_info set path_update_time=now() where id=oid;
    RETURN true;
EXCEPTION
    WHEN OTHERS THEN 
	RETURN false;    
END;
$$;


ALTER FUNCTION public.update_object_file_path_info_time(oid integer) OWNER TO postgres;

--
-- TOC entry 215 (class 1255 OID 620015)
-- Dependencies: 6 1057
-- Name: update_swticth_version(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION update_swticth_version(sn character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$

BEGIN
	update l2switchinfo set nb_timestamp=now() where devicename =sn;	
	update objtimestamp set modifytime=now() where typename='L2Switch';	
	RETURN true;
EXCEPTION
	WHEN OTHERS THEN 
	RETURN false;    
END;
$$;


ALTER FUNCTION public.update_swticth_version(sn character varying) OWNER TO postgres;

--
-- TOC entry 216 (class 1255 OID 620016)
-- Dependencies: 6 1057 602
-- Name: updatedevicepropertytmp(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION updatedevicepropertytmp() RETURNS SETOF devicesetting
    LANGUAGE plpgsql
    AS $$
DECLARE
    r devicesetting%rowtype;
    rc integer;
BEGIN	
	select count(*) into rc from device_property;

	if rc <1 THEN 		
		FOR r IN select * from devicesetting order by id LOOP
			INSERT INTO device_property(			 
			deviceid,
			manageif_mac, 
			vendor, 
			model, 
			sysobjectid, 
			software_version,
			serial_number, 
			asset_tag, 
			system_memory, 
			"location", 
			network_cluster, 
			contact, 
			hierarchy_layer, 
			description, 
			management_interface, 
			lasttimestamp)
			VALUES (			 
			r.deviceid, 
			'', 
			substring(r.vendor from 1 for 255), 
			substring(r.model from 1 for 255), 
			'', 
			substring(r.softwareversion from 1 for 255),
			substring(r.serialnumber from 1 for 255),
			'',
			'',
			substring(r.currentlocation from 1 for 255),
			'', 
			substring(r.contactor from 1 for 255),
			'',
			'',
			'',		
			now());		  
			return next r;
		  END LOOP;
	
	END if;
	       		
END;
$$;


ALTER FUNCTION public.updatedevicepropertytmp() OWNER TO postgres;

--
-- TOC entry 217 (class 1255 OID 620017)
-- Dependencies: 6 1057
-- Name: updatedevicesetting_applianceid(integer, integer[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION updatedevicesetting_applianceid(appid integer, deviceids integer[]) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN	
	UPDATE devicesetting SET appliceid=appid, lasttimestamp=now() WHERE deviceid = any (deviceids);
	return 1;
End;
$$;


ALTER FUNCTION public.updatedevicesetting_applianceid(appid integer, deviceids integer[]) OWNER TO postgres;

--
-- TOC entry 218 (class 1255 OID 620018)
-- Dependencies: 6 1057
-- Name: updateinterfacesettingtime(character varying[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION updateinterfacesettingtime(names character varying[]) RETURNS boolean
    LANGUAGE plpgsql
    AS $$

BEGIN
    update interfacesetting set lasttimestamp=now() where deviceid in (select id from devices where strname = any(names));
    
    RETURN true;
EXCEPTION
    WHEN OTHERS THEN 
	RETURN false;    
END;
$$;


ALTER FUNCTION public.updateinterfacesettingtime(names character varying[]) OWNER TO postgres;

--
-- TOC entry 219 (class 1255 OID 620019)
-- Dependencies: 6 1057
-- Name: updatel2switchtime(character varying[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION updatel2switchtime(names character varying[]) RETURNS boolean
    LANGUAGE plpgsql
    AS $$

BEGIN
    update l2switchinfo set nb_timestamp=now() where devicename = any(names);
    
    RETURN true;
EXCEPTION
    WHEN OTHERS THEN 
	RETURN false;    
END;
$$;


ALTER FUNCTION public.updatel2switchtime(names character varying[]) OWNER TO postgres;

--
-- TOC entry 220 (class 1255 OID 620020)
-- Dependencies: 6 1057
-- Name: updateprivateversion(character varying, integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION updateprivateversion(tn character varying, uid integer, guid character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$

declare
	r_id integer;
BEGIN
    select id into r_id from objprivatetimestamp where typename=tn and userid=uid and licguid=guid; 
	if r_id IS NULL THEN
		return -1;
	end if;

   if ds_id IS NULL THEN
	insert into objprivatetimestamp (modifytime,typename,userid,licguid) values (now(),tn,uid,guid);
   else
	update objprivatetimestamp set modifytime=now() where typename=tn and userid=uid and licguid=guid; 	
   end if;		
        
    RETURN true;
EXCEPTION
    WHEN OTHERS THEN 
 RETURN false;    
 
END;
$$;


ALTER FUNCTION public.updateprivateversion(tn character varying, uid integer, guid character varying) OWNER TO postgres;

--
-- TOC entry 221 (class 1255 OID 620021)
-- Dependencies: 6 1057
-- Name: updatepublicversion(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION updatepublicversion(tn character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$

BEGIN
    update objtimestamp set modifytime=now() where typename=tn;	
    
    RETURN true;
EXCEPTION
    WHEN OTHERS THEN 
	RETURN false;    
END;
$$;


ALTER FUNCTION public.updatepublicversion(tn character varying) OWNER TO postgres;

--
-- TOC entry 299 (class 1255 OID 621880)
-- Dependencies: 1057 6
-- Name: updateversion(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION updateversion(tn character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$

BEGIN
    update objtimestamp set modifytime=now() where typename=tn;	
    
    RETURN true;
EXCEPTION
    WHEN OTHERS THEN 
	RETURN false;    
END;
$$;


ALTER FUNCTION public.updateversion(tn character varying) OWNER TO postgres;

--
-- TOC entry 2292 (class 1259 OID 620022)
-- Dependencies: 2965 2966 2967 6
-- Name: userdevicesetting; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE userdevicesetting (
    id integer NOT NULL,
    deviceid integer NOT NULL,
    userid integer DEFAULT (-1) NOT NULL,
    managerip integer NOT NULL,
    telnetusername character varying(64),
    telnetpwd character varying(64),
    dtstamp timestamp without time zone DEFAULT now() NOT NULL,
    jumpboxid integer DEFAULT 0,
    licguid character varying(128)
);


ALTER TABLE public.userdevicesetting OWNER TO postgres;

--
-- TOC entry 208 (class 1255 OID 620028)
-- Dependencies: 6 1057 689
-- Name: user_device_setting_retrieve(character varying, integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION user_device_setting_retrieve(devname character varying, user_id integer, lic_guid character varying) RETURNS userdevicesetting
    LANGUAGE plpgsql
    AS $$
declare
	r userdevicesetting%rowtype;
BEGIN
   SELECT * into r FROM userdevicesetting where deviceid IN ( select id from devices where strname=devname ) AND userid=user_id and licguid=lic_guid;
   return r;
   
END;

  $$;


ALTER FUNCTION public.user_device_setting_retrieve(devname character varying, user_id integer, lic_guid character varying) OWNER TO postgres;

--
-- TOC entry 222 (class 1255 OID 620029)
-- Dependencies: 6 1057 689
-- Name: user_device_setting_update(character varying, integer, character varying, userdevicesetting); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION user_device_setting_update(devname character varying, u_id integer, lic_guid character varying, ds userdevicesetting) RETURNS integer
    LANGUAGE plpgsql
    AS $$
declare
	r_id integer;
	ds_id integer;
BEGIN
	select id into r_id from devices where strname=devname;
	if r_id IS NULL THEN
		return -1;
	end if;

	select id into ds_id from userdevicesetting where deviceid=r_id AND userid=u_id AND licguid=lic_guid;
	if ds_id IS NULL THEN
		return -1;
	ELSE
		update userdevicesetting set ( 
			  managerip,
			  telnetusername,
			  telnetpwd,
			  dtstamp,
			  jumpboxid
			)
			=( 
			ds.managerip,
			ds.telnetusername,
			ds.telnetpwd,
			now(),
			ds.jumpboxid
			) 
			where id = ds_id;
		return ds_id;
	end if;
EXCEPTION
	WHEN OTHERS THEN 
		RETURN -2;
END;

  $$;


ALTER FUNCTION public.user_device_setting_update(devname character varying, u_id integer, lic_guid character varying, ds userdevicesetting) OWNER TO postgres;

--
-- TOC entry 223 (class 1255 OID 620030)
-- Dependencies: 6 1057 689
-- Name: user_device_setting_upsert(character varying, integer, character varying, userdevicesetting); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION user_device_setting_upsert(devname character varying, u_id integer, lic_guid character varying, ds userdevicesetting) RETURNS integer
    LANGUAGE plpgsql
    AS $$
declare
	r_id integer;
	ds_id integer;
BEGIN
	select id into r_id from devices where strname=devname;
	if r_id IS NULL THEN
		return -1;
	end if;

	select id into ds_id from userdevicesetting where deviceid=r_id AND userid=u_id AND licguid=lic_guid;
	if ds_id IS NULL THEN
		insert into userdevicesetting(
			  deviceid,
			  userid,
			  managerip,
			  telnetusername,
			  telnetpwd,
			  dtstamp,
			  jumpboxid,
			  licguid
			)
			values ( 
			r_id,
			u_id,
			ds.managerip,
			ds.telnetusername,
			ds.telnetpwd,
			now(),
			ds.jumpboxid,
			lic_guid
		);

		return lastval();
	ELSE
		update userdevicesetting set ( 
			  managerip,
			  telnetusername,
			  telnetpwd,
			  dtstamp,
			  jumpboxid
			)
			=( 
			ds.managerip,
			ds.telnetusername,
			ds.telnetpwd,
			now(),
			ds.jumpboxid
			) 
			where id = ds_id;
		return ds_id;
	end if;
EXCEPTION
	WHEN OTHERS THEN 
		RETURN -2;
END;

  $$;


ALTER FUNCTION public.user_device_setting_upsert(devname character varying, u_id integer, lic_guid character varying, ds userdevicesetting) OWNER TO postgres;

--
-- TOC entry 224 (class 1255 OID 620031)
-- Dependencies: 6 1057
-- Name: valid_privateversion_time(timestamp without time zone, character varying, integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION valid_privateversion_time(dt timestamp without time zone, stypename character varying, uid integer, sguid character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
 
DECLARE
    t timestamp without time zone;
BEGIN
    select modifytime into t from objprivatetimestamp where typename=stypename and userid=uid and licguid=sguid;
 
    if(t>dt) then 
 RETURN true;
    else
 return false;
    end if;
EXCEPTION
    WHEN OTHERS THEN 
 RETURN false;    
END;
$$;


ALTER FUNCTION public.valid_privateversion_time(dt timestamp without time zone, stypename character varying, uid integer, sguid character varying) OWNER TO postgres;

--
-- TOC entry 225 (class 1255 OID 620032)
-- Dependencies: 6 1057
-- Name: valid_version_time(timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION valid_version_time(dt timestamp without time zone, stypename character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
 
DECLARE
    t timestamp without time zone;
BEGIN
    
  select modifytime into t from objtimestamp where typename=stypename;
 
 
    if(t>dt) then 
 RETURN true;
    else
 return false;
    end if;
EXCEPTION
    WHEN OTHERS THEN 
 RETURN false;    
END;
$$;


ALTER FUNCTION public.valid_version_time(dt timestamp without time zone, stypename character varying) OWNER TO postgres;

--
-- TOC entry 2293 (class 1259 OID 620033)
-- Dependencies: 2970 6
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
-- TOC entry 2294 (class 1259 OID 620037)
-- Dependencies: 2625 6
-- Name: bgpneighborview; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW bgpneighborview AS
    SELECT bgpneighbor.id, bgpneighbor.deviceid, devices.strname AS devicename, bgpneighbor.remoteasnum, bgpneighbor.neighborip, bgpneighbor.localasnum FROM bgpneighbor, devices WHERE (((devices.id = bgpneighbor.deviceid) AND (bgpneighbor.neighborip IS NOT NULL)) AND (bgpneighbor.localasnum IS NOT NULL)) ORDER BY bgpneighbor.id;


ALTER TABLE public.bgpneighborview OWNER TO postgres;

--
-- TOC entry 226 (class 1255 OID 620041)
-- Dependencies: 6 1057 693
-- Name: view_bgpneighbor_retrieve(integer, integer, timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_bgpneighbor_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) RETURNS SETOF bgpneighborview
    LANGUAGE plpgsql
    AS $$
declare
	r bgpneighborview%rowtype;
	t timestamp without time zone;
BEGIN
	select modifytime into t from objtimestamp where typename=stypename;
	
	if t is null or t>dt then
		if imax <0 then
			for r in SELECT * FROM bgpneighborview where id>ibegin order by id  loop
			return next r;
			end loop;
		else
			for r in SELECT * FROM bgpneighborview where id>ibegin order by id limit imax loop
			return next r;
			end loop;

		end if;	
	end if;	
END;

  $$;


ALTER FUNCTION public.view_bgpneighbor_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) OWNER TO postgres;

--
-- TOC entry 227 (class 1255 OID 620042)
-- Dependencies: 6 1057 600
-- Name: view_device_customized_info_retrieve(integer, integer, timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_device_customized_info_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) RETURNS SETOF device_customized_infoview
    LANGUAGE plpgsql
    AS $$
declare
	r device_customized_infoview%rowtype;
	t timestamp without time zone;
BEGIN
	select modifytime into t from objtimestamp where typename=stypename;
	
	if t is null or t>dt then
		if imax <0 then
			for r in SELECT * FROM device_customized_infoview where id>ibegin and lasttimestamp>dt loop
			return next r;
			end loop;
		else
			for r in SELECT * FROM device_customized_infoview where id>ibegin and lasttimestamp>dt limit imax loop
			return next r;
			end loop;

		end if;	
	end if;	
END;

  $$;


ALTER FUNCTION public.view_device_customized_info_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) OWNER TO postgres;

--
-- TOC entry 228 (class 1255 OID 620043)
-- Dependencies: 6 1057 598
-- Name: view_device_property_retrieve(integer, integer, timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_device_property_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) RETURNS SETOF devicepropertyview
    LANGUAGE plpgsql
    AS $$
declare
	r devicepropertyview%rowtype;
	t timestamp without time zone;
BEGIN
	select modifytime into t from objtimestamp where typename=stypename;
	
	if t is null or t>dt then
		if imax <0 then
			for r in SELECT * FROM devicepropertyview where id>ibegin and lasttimestamp>dt loop
			return next r;
			end loop;
		else
			for r in SELECT * FROM devicepropertyview where id>ibegin and lasttimestamp>dt limit imax loop
			return next r;
			end loop;

		end if;	
	end if;	
END;

  $$;


ALTER FUNCTION public.view_device_property_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) OWNER TO postgres;

--
-- TOC entry 2295 (class 1259 OID 620044)
-- Dependencies: 2626 6
-- Name: devicepropertyviewfdown; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW devicepropertyviewfdown AS
    SELECT device_property.id, device_property.deviceid, device_property.manageif_mac, device_property.vendor, device_property.model, device_property.sysobjectid, device_property.software_version, device_property.serial_number, device_property.asset_tag, device_property.system_memory, device_property.location, device_property.network_cluster, device_property.contact, device_property.hierarchy_layer, device_property.description, device_property.management_interface, device_property.lasttimestamp, device_property.extradata, devices.strname AS devicename, devices.isubtype AS itype, devicesetting.configfile_time FROM device_property, devices, devicesetting WHERE ((device_property.deviceid = devices.id) AND (device_property.deviceid = devicesetting.deviceid)) ORDER BY device_property.id;


ALTER TABLE public.devicepropertyviewfdown OWNER TO postgres;

--
-- TOC entry 229 (class 1255 OID 620049)
-- Dependencies: 6 1057 695
-- Name: view_device_property_retrieve2(integer, integer, timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_device_property_retrieve2(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) RETURNS SETOF devicepropertyviewfdown
    LANGUAGE plpgsql
    AS $$
declare
	r devicepropertyviewfdown%rowtype;
	t timestamp without time zone;
BEGIN
	select modifytime into t from objtimestamp where typename=stypename;
	
	if t is null or t>dt then
		if imax <0 then
			for r in SELECT * FROM devicepropertyviewfdown where id>ibegin and lasttimestamp>dt loop
			return next r;
			end loop;
		else
			for r in SELECT * FROM devicepropertyviewfdown where id>ibegin and lasttimestamp>dt limit imax loop
			return next r;
			end loop;

		end if;	
	end if;	
END;

  $$;


ALTER FUNCTION public.view_device_property_retrieve2(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) OWNER TO postgres;

--
-- TOC entry 230 (class 1255 OID 620050)
-- Dependencies: 6 1057 608
-- Name: view_device_setting_retrieve(integer, integer, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_device_setting_retrieve(ibegin integer, imax integer, dt timestamp without time zone) RETURNS SETOF devicesettingview
    LANGUAGE plpgsql
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

  $$;


ALTER FUNCTION public.view_device_setting_retrieve(ibegin integer, imax integer, dt timestamp without time zone) OWNER TO postgres;

--
-- TOC entry 231 (class 1255 OID 620051)
-- Dependencies: 1057 608 6
-- Name: view_device_setting_retrieve_by_nap(integer, integer, timestamp without time zone, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_device_setting_retrieve_by_nap(ibegin integer, imax integer, dt timestamp without time zone, napid integer) RETURNS SETOF devicesettingview
    LANGUAGE plpgsql
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
 
  $$;


ALTER FUNCTION public.view_device_setting_retrieve_by_nap(ibegin integer, imax integer, dt timestamp without time zone, napid integer) OWNER TO postgres;

--
-- TOC entry 2296 (class 1259 OID 620052)
-- Dependencies: 2627 6
-- Name: devicegroupview; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW devicegroupview AS
    SELECT devicegroup.id, devicegroup.strname, devicegroup.strdesc, devicegroup.userid, devicegroup.showcolor, (SELECT count(*) AS count FROM (SELECT DISTINCT devicegroupdevice.devicegroupid, devicegroupdevice.deviceid FROM devicegroupdevice) uniqdevicegroupdevice WHERE (uniqdevicegroupdevice.devicegroupid = devicegroup.id)) AS irefcount, devicegroup.searchcondition, devicegroup.searchcontainer, devicegroup.licguid FROM devicegroup ORDER BY devicegroup.id;


ALTER TABLE public.devicegroupview OWNER TO postgres;

--
-- TOC entry 281 (class 1255 OID 621862)
-- Dependencies: 1057 697 6
-- Name: view_devicegroup_retrieve(integer, integer, timestamp without time zone, integer, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_devicegroup_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer, stypename character varying, sguid character varying) RETURNS SETOF devicegroupview
    LANGUAGE plpgsql
    AS $$
declare
	r devicegroupview%rowtype;	
	t timestamp without time zone;
BEGIN		
	if uid=-1 then
		select modifytime into t from objtimestamp where typename=stypename;
	else
		select modifytime into t from objprivatetimestamp where typename=stypename and userid=uid and licguid=sguid;
	end if;
	
	if t is null or t>dt then
		if imax <0 then
			if uid=-1 then
				for r in SELECT * FROM devicegroupview where id>ibegin and userid=uid and (licguid=sguid or licguid='-1') loop
				return next r;
				end loop;
			else
				for r in SELECT * FROM devicegroupview where id>ibegin and userid=uid and licguid=sguid loop
				return next r;
				end loop;
			end if;			
		else
			if uid=-1 then
				for r in SELECT * FROM devicegroupview where id>ibegin and userid=uid and (licguid=sguid or licguid='-1') limit imax loop
				return next r;
				end loop;
			else
				for r in SELECT * FROM devicegroupview where id>ibegin and userid=uid and licguid=sguid limit imax loop
				return next r;
				end loop;
			end if;			
		end if;	
	end if;	
END;

  $$;


ALTER FUNCTION public.view_devicegroup_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer, stypename character varying, sguid character varying) OWNER TO postgres;

--
-- TOC entry 2297 (class 1259 OID 620057)
-- Dependencies: 6
-- Name: devicegroupdevicegroup; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE devicegroupdevicegroup (
    id integer NOT NULL,
    groupid integer,
    groupidbelone integer
);


ALTER TABLE public.devicegroupdevicegroup OWNER TO postgres;

--
-- TOC entry 2298 (class 1259 OID 620060)
-- Dependencies: 2628 6
-- Name: devicegroupdevicegroupview; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW devicegroupdevicegroupview AS
    SELECT devicegroupdevicegroup.id, devicegroupdevicegroup.groupid AS devicegroupid, (SELECT devicegroup.strname FROM devicegroup WHERE (devicegroup.id = devicegroupdevicegroup.groupid)) AS devicegroupname, devicegroupdevicegroup.groupidbelone AS devicegroupdevicegroupid, (SELECT devicegroup.strname FROM devicegroup WHERE (devicegroup.id = devicegroupdevicegroup.groupidbelone)) AS devicegroupdevicegroupname FROM devicegroupdevicegroup;


ALTER TABLE public.devicegroupdevicegroupview OWNER TO postgres;

--
-- TOC entry 284 (class 1255 OID 621863)
-- Dependencies: 701 1057 6
-- Name: view_devicegroupdevicegroupview_retrieve(integer, integer, timestamp without time zone, integer, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_devicegroupdevicegroupview_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer, stypename character varying, sguid character varying) RETURNS SETOF devicegroupdevicegroupview
    LANGUAGE plpgsql
    AS $$
declare
	r devicegroupdevicegroupview%rowtype;	
	t timestamp without time zone;
BEGIN		
	if uid=-1 then
		select modifytime into t from objtimestamp where typename=stypename;
	else
		select modifytime into t from objprivatetimestamp where typename=stypename and userid=uid and licguid=sguid;
	end if;
	
	if t is null or t>dt then
		if imax <0 then
			if uid=-1 then
				for r in select * from devicegroupdevicegroupview where devicegroupid in (SELECT id FROM devicegroup where id>ibegin and userid=uid and (licguid=sguid or licguid='-1') order by id) order by devicegroupid loop
				return next r;
				end loop;
			else
				for r in select * from devicegroupdevicegroupview where devicegroupid in (SELECT id FROM devicegroup where id>ibegin and userid=uid and licguid=sguid order by id) order by devicegroupid loop
				return next r;
				end loop;
			end if;			
		else
			if uid=-1 then
				for r in select * from devicegroupdevicegroupview where devicegroupid in (SELECT id FROM devicegroup where id>ibegin and userid=uid and (licguid=sguid or licguid='-1') order by id limit imax) order by devicegroupid loop			
				return next r;
				end loop;
			else
				for r in select * from devicegroupdevicegroupview where devicegroupid in (SELECT id FROM devicegroup where id>ibegin and userid=uid and licguid=sguid order by id limit imax) order by devicegroupid loop			
				return next r;
				end loop;
			end if;			
		end if;	
	end if;	
END;

  $$;


ALTER FUNCTION public.view_devicegroupdevicegroupview_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer, stypename character varying, sguid character varying) OWNER TO postgres;

--
-- TOC entry 283 (class 1255 OID 621861)
-- Dependencies: 1057 6 591
-- Name: view_devicegroupdeviceview_retrieve(integer, integer, timestamp without time zone, integer, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_devicegroupdeviceview_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer, stypename character varying, sguid character varying) RETURNS SETOF devicegroupdeviceview
    LANGUAGE plpgsql
    AS $$
declare
	r devicegroupdeviceview%rowtype;
	t timestamp without time zone;
BEGIN
	if uid=-1 then
		select modifytime into t from objtimestamp where typename=stypename;
	else
		select modifytime into t from objprivatetimestamp where typename=stypename and userid=uid and licguid=sguid;
	end if;
	
	if t is null or t>dt then
		if imax <0 then
			if uid=-1 then
				for r in select * from devicegroupdeviceview where devicegroupid in (SELECT id FROM devicegroup where id>ibegin and userid=uid and (licguid=sguid or licguid='-1') order by id) order by devicegroupid loop
				return next r;
				end loop;
			else
				for r in select * from devicegroupdeviceview where devicegroupid in (SELECT id FROM devicegroup where id>ibegin and userid=uid and licguid=sguid order by id) order by devicegroupid loop
				return next r;
				end loop;
			end if;			
		else
			if uid=-1 then
				for r in select * from devicegroupdeviceview where devicegroupid in (SELECT id FROM devicegroup where id>ibegin and userid=uid and (licguid=sguid or licguid='-1') order by id limit imax) order by devicegroupid loop			
				return next r;
				end loop;
			else
				for r in select * from devicegroupdeviceview where devicegroupid in (SELECT id FROM devicegroup where id>ibegin and userid=uid and licguid=sguid order by id limit imax) order by devicegroupid loop			
				return next r;
				end loop;
			end if;			
		end if;	
	end if;	
END;

  $$;


ALTER FUNCTION public.view_devicegroupdeviceview_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer, stypename character varying, sguid character varying) OWNER TO postgres;

--
-- TOC entry 2299 (class 1259 OID 620066)
-- Dependencies: 2973 6
-- Name: devicegroupsite; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE devicegroupsite (
    id integer NOT NULL,
    groupid integer,
    siteid integer,
    sitechild integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.devicegroupsite OWNER TO postgres;

--
-- TOC entry 2300 (class 1259 OID 620070)
-- Dependencies: 2629 6
-- Name: devicegroupsiteview; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW devicegroupsiteview AS
    SELECT devicegroupsite.id, devicegroupsite.groupid AS devicegroupid, (SELECT devicegroup.strname FROM devicegroup WHERE (devicegroup.id = devicegroupsite.groupid)) AS devicegroupname, devicegroupsite.siteid AS devicegroupsiteid, (SELECT site.name FROM site WHERE (site.id = devicegroupsite.siteid)) AS devicegroupsitename, devicegroupsite.sitechild FROM devicegroupsite;


ALTER TABLE public.devicegroupsiteview OWNER TO postgres;

--
-- TOC entry 285 (class 1255 OID 621864)
-- Dependencies: 6 705 1057
-- Name: view_devicegroupsiteview_retrieve(integer, integer, timestamp without time zone, integer, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_devicegroupsiteview_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer, stypename character varying, sguid character varying) RETURNS SETOF devicegroupsiteview
    LANGUAGE plpgsql
    AS $$
declare
	r devicegroupsiteview%rowtype;
	t timestamp without time zone;
BEGIN
	if uid=-1 then
		select modifytime into t from objtimestamp where typename=stypename;
	else
		select modifytime into t from objprivatetimestamp where typename=stypename and userid=uid and licguid=sguid;
	end if;
	
	if t is null or t>dt then
		if imax <0 then
			if uid=-1 then
				for r in select * from devicegroupsiteview where devicegroupid in (SELECT id FROM devicegroup where id>ibegin and userid=uid and (licguid=sguid or licguid='-1') order by id) order by devicegroupid loop
				return next r;
				end loop;
			else
				for r in select * from devicegroupsiteview where devicegroupid in (SELECT id FROM devicegroup where id>ibegin and userid=uid and licguid=sguid order by id) order by devicegroupid loop
				return next r;
				end loop;
			end if;			
		else
			if uid=-1 then
				for r in select * from devicegroupsiteview where devicegroupid in (SELECT id FROM devicegroup where id>ibegin and userid=uid and (licguid=sguid or licguid='-1') order by id limit imax) order by devicegroupid loop			
				return next r;
				end loop;
			else
				for r in select * from devicegroupsiteview where devicegroupid in (SELECT id FROM devicegroup where id>ibegin and userid=uid and licguid=sguid order by id limit imax) order by devicegroupid loop			
				return next r;
				end loop;
			end if;			
		end if;	
	end if;	
END;

  $$;


ALTER FUNCTION public.view_devicegroupsiteview_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer, stypename character varying, sguid character varying) OWNER TO postgres;

--
-- TOC entry 2301 (class 1259 OID 620075)
-- Dependencies: 6
-- Name: devicegroupsystemdevicegroup; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE devicegroupsystemdevicegroup (
    id integer NOT NULL,
    groupid integer,
    groupidbelone integer
);


ALTER TABLE public.devicegroupsystemdevicegroup OWNER TO postgres;

--
-- TOC entry 2302 (class 1259 OID 620078)
-- Dependencies: 2975 2976 6
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
-- TOC entry 2303 (class 1259 OID 620083)
-- Dependencies: 2630 6
-- Name: devicegroupsystemdevicegroupview; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW devicegroupsystemdevicegroupview AS
    SELECT devicegroupsystemdevicegroup.id, devicegroupsystemdevicegroup.groupid, (SELECT devicegroup.strname FROM devicegroup WHERE (devicegroup.id = devicegroupsystemdevicegroup.groupid)) AS groupname, devicegroupsystemdevicegroup.groupidbelone, (SELECT systemdevicegroup.strname FROM systemdevicegroup WHERE (systemdevicegroup.id = devicegroupsystemdevicegroup.groupidbelone)) AS groupnamebelone FROM devicegroupsystemdevicegroup;


ALTER TABLE public.devicegroupsystemdevicegroupview OWNER TO postgres;

--
-- TOC entry 286 (class 1255 OID 621865)
-- Dependencies: 1057 711 6
-- Name: view_devicegroupsystemdevicegroupview_retrieve(integer, integer, timestamp without time zone, integer, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_devicegroupsystemdevicegroupview_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer, stypename character varying, sguid character varying) RETURNS SETOF devicegroupsystemdevicegroupview
    LANGUAGE plpgsql
    AS $$
declare
	r devicegroupsystemdevicegroupview%rowtype;
	t timestamp without time zone;
BEGIN
	if uid=-1 then
		select modifytime into t from objtimestamp where typename=stypename;
	else
		select modifytime into t from objprivatetimestamp where typename=stypename and userid=uid and licguid=sguid;
	end if;
	
	if t is null or t>dt then
		if imax <0 then
			if uid=-1 then
				for r in select * from devicegroupsystemdevicegroupview where groupid in (SELECT id FROM devicegroup where id>ibegin and (licguid=sguid or licguid='-1') order by id) order by groupid loop
				return next r;
				end loop;
			else
				for r in select * from devicegroupsystemdevicegroupview where groupid in (SELECT id FROM devicegroup where id>ibegin and licguid=sguid order by id) order by groupid loop
				return next r;
				end loop;
			end if;			
		else
			if uid=-1 then
				for r in select * from devicegroupsystemdevicegroupview where groupid in (SELECT id FROM devicegroup where id>ibegin and (licguid=sguid or licguid='-1') order by id limit imax) order by groupid loop			
				return next r;
				end loop;
			else
				for r in select * from devicegroupsystemdevicegroupview where groupid in (SELECT id FROM devicegroup where id>ibegin and licguid=sguid order by id limit imax) order by groupid loop			
				return next r;
				end loop;
			end if;			
		end if;	
	end if;	
END;

  $$;


ALTER FUNCTION public.view_devicegroupsystemdevicegroupview_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer, stypename character varying, sguid character varying) OWNER TO postgres;

--
-- TOC entry 2304 (class 1259 OID 620088)
-- Dependencies: 2979 6
-- Name: device_icon; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE device_icon (
    id integer NOT NULL,
    icon_name character varying(100) NOT NULL,
    lasttimestamp timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.device_icon OWNER TO postgres;

--
-- TOC entry 2305 (class 1259 OID 620092)
-- Dependencies: 6
-- Name: symbol2deviceicon; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE symbol2deviceicon (
    id integer NOT NULL,
    symbolid integer NOT NULL,
    deviceicon_id integer NOT NULL,
    lasttimestamp timestamp without time zone NOT NULL
);


ALTER TABLE public.symbol2deviceicon OWNER TO postgres;

--
-- TOC entry 2306 (class 1259 OID 620095)
-- Dependencies: 2631 6
-- Name: deviceiconview; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW deviceiconview AS
    SELECT object_file_info.id AS objectfileid, object_file_info.file_update_time AS lasttimestamp, object_file_info.file_real_name, object_file_info.file_save_name, device_icon.icon_name, symbol2deviceicon.symbolid FROM object_file_info, device_icon, symbol2deviceicon WHERE (((object_file_info.object_id = device_icon.id) AND (object_file_info.object_type = 3)) AND (object_file_info.object_id = symbol2deviceicon.deviceicon_id)) ORDER BY object_file_info.id;


ALTER TABLE public.deviceiconview OWNER TO postgres;

--
-- TOC entry 232 (class 1255 OID 620099)
-- Dependencies: 6 1057 717
-- Name: view_deviceiconview_retrieve(integer, integer, timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_deviceiconview_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) RETURNS SETOF deviceiconview
    LANGUAGE plpgsql
    AS $$
declare	
	r deviceiconview%rowtype;
	t timestamp without time zone;
BEGIN
	select modifytime into t from objtimestamp where typename=stypename;
	
	if t is null or t>dt then
		if imax <0 then
			for r in  select * from deviceiconview where objectfileid >ibegin and lasttimestamp>dt loop				
				return next r;								
			end loop;
		else
			for r in select * from deviceiconview where objectfileid >ibegin and lasttimestamp>dt limit imax loop				
				return next r;				
			end loop;

		end if;	
	end if;	
END;

  $$;


ALTER FUNCTION public.view_deviceiconview_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) OWNER TO postgres;

--
-- TOC entry 233 (class 1255 OID 620100)
-- Dependencies: 6 717 1057
-- Name: view_deviceiconview_retrieve2(integer[], timestamp without time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_deviceiconview_retrieve2(symbols integer[], dt timestamp without time zone) RETURNS SETOF deviceiconview
    LANGUAGE plpgsql
    AS $$
declare	
	r deviceiconview%rowtype;
	t timestamp without time zone;
BEGIN
	if array_length( symbols, 1 ) = 1 and symbols[1]=-1 then
		for r in  select * from deviceiconview where lasttimestamp>dt loop				
			return next r;								
		end loop;
	else
		for r in  select * from deviceiconview where symbolid = any (symbols) and lasttimestamp>dt loop				
			return next r;								
		end loop;
	end if;
END;

  $$;


ALTER FUNCTION public.view_deviceiconview_retrieve2(symbols integer[], dt timestamp without time zone) OWNER TO postgres;

--
-- TOC entry 234 (class 1255 OID 620101)
-- Dependencies: 1057 6 584
-- Name: view_deviceinterfacesetting_retrieve(integer, integer, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_deviceinterfacesetting_retrieve(ibegin integer, imax integer, dt timestamp without time zone) RETURNS SETOF devices
    LANGUAGE plpgsql
    AS $$
declare
	r devices%rowtype;	
BEGIN		
	if imax <0 then
			for r in SELECT * FROM devices where id in (select deviceid from interfacesetting where lasttimestamp>dt) and id>ibegin order by id loop
			return next r;
			end loop;
		else
			for r in SELECT * FROM devices where id in (select deviceid from interfacesetting where lasttimestamp>dt) and id>ibegin order by id limit imax loop
			return next r;
			end loop;

		end if;	
END;

  $$;


ALTER FUNCTION public.view_deviceinterfacesetting_retrieve(ibegin integer, imax integer, dt timestamp without time zone) OWNER TO postgres;

--
-- TOC entry 2307 (class 1259 OID 620102)
-- Dependencies: 2982 6
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
-- TOC entry 3828 (class 0 OID 0)
-- Dependencies: 2307
-- Name: COLUMN deviceprotocols.deviceid; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN deviceprotocols.deviceid IS 'refrence to the id in devices table';


--
-- TOC entry 2308 (class 1259 OID 620106)
-- Dependencies: 2632 6
-- Name: deviceprotocolsview; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW deviceprotocolsview AS
    SELECT deviceprotocols.id, deviceprotocols.deviceid, deviceprotocols.protocalname, deviceprotocols.lastmodifytime, devices.strname AS devicename, devices.isubtype FROM deviceprotocols, devices WHERE (deviceprotocols.deviceid = devices.id) ORDER BY devices.strname;


ALTER TABLE public.deviceprotocolsview OWNER TO postgres;

--
-- TOC entry 235 (class 1255 OID 620110)
-- Dependencies: 1057 721 6
-- Name: view_deviceprotocolsview_retrieve(integer, integer, timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_deviceprotocolsview_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) RETURNS SETOF deviceprotocolsview
    LANGUAGE plpgsql
    AS $$
declare
	r deviceprotocolsview%rowtype;
	t timestamp without time zone;
BEGIN
	select modifytime into t from objtimestamp where typename=stypename;
	
	if t is null or t>dt then
		if imax <0 then
			for r in SELECT * FROM deviceprotocolsview where id>ibegin order by id  loop
			return next r;
			end loop;
		else
			for r in SELECT * FROM deviceprotocolsview where id>ibegin order by id limit imax loop
			return next r;
			end loop;

		end if;	
	end if;	
END;

  $$;


ALTER FUNCTION public.view_deviceprotocolsview_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) OWNER TO postgres;

--
-- TOC entry 2309 (class 1259 OID 620111)
-- Dependencies: 6
-- Name: devicesitedevice; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE devicesitedevice (
    id integer NOT NULL,
    siteid integer,
    deviceid integer
);


ALTER TABLE public.devicesitedevice OWNER TO postgres;

--
-- TOC entry 2310 (class 1259 OID 620114)
-- Dependencies: 2633 6
-- Name: devicesitedeviceview; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW devicesitedeviceview AS
    SELECT devicesitedevice.siteid, devicesitedevice.deviceid, 1 AS id, (SELECT devices.strname FROM devices WHERE (devices.id = devicesitedevice.deviceid)) AS devicename, (SELECT site.name FROM site WHERE (site.id = devicesitedevice.siteid)) AS sitename, (SELECT devices.isubtype FROM devices WHERE (devices.id = devicesitedevice.deviceid)) AS isubtype FROM devicesitedevice UNION ALL SELECT 1 AS siteid, devices.id AS deviceid, 1 AS id, devices.strname AS devicename, (SELECT site.name FROM site WHERE (site.id = 1)) AS sitename, devices.isubtype FROM devices WHERE (NOT (devices.id IN (SELECT devicesitedevice.deviceid FROM devicesitedevice)));


ALTER TABLE public.devicesitedeviceview OWNER TO postgres;

--
-- TOC entry 236 (class 1255 OID 620119)
-- Dependencies: 6 725 1057
-- Name: view_devicesitedeviceview_retrieve(integer, integer, timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_devicesitedeviceview_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) RETURNS SETOF devicesitedeviceview
    LANGUAGE plpgsql
    AS $$
declare
	r devicesitedeviceview%rowtype;
	t timestamp without time zone;
BEGIN
		
	if t is null or t>dt then
		if imax <0 then
			for r in select * from devicesitedeviceview where siteid in (SELECT id FROM site where id>ibegin order by id) order by siteid loop
			return next r;
			end loop;
		else
			for r in select * from devicesitedeviceview where siteid in (SELECT id FROM site where id>ibegin order by id limit imax) order by siteid loop			
			return next r;
			end loop;

		end if;	
	end if;	
END;

  $$;


ALTER FUNCTION public.view_devicesitedeviceview_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) OWNER TO postgres;

--
-- TOC entry 2311 (class 1259 OID 620120)
-- Dependencies: 2634 6
-- Name: discover_missdeviceview; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW discover_missdeviceview AS
    SELECT discover_missdevice.id, discover_missdevice.mgrip, discover_missdevice.devtype, discover_missdevice.vendor, discover_missdevice.model, discover_missdevice.checktime, discover_missdevice.modifytime, discover_missdevice.deviceid, devices.strname AS devicename FROM discover_missdevice, devices WHERE ((discover_missdevice.deviceid = devices.id) AND (discover_missdevice.modifytime IS NOT NULL));


ALTER TABLE public.discover_missdeviceview OWNER TO postgres;

--
-- TOC entry 237 (class 1255 OID 620124)
-- Dependencies: 1057 727 6
-- Name: view_discover_missdeviceview(integer, integer, timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_discover_missdeviceview(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) RETURNS SETOF discover_missdeviceview
    LANGUAGE plpgsql
    AS $$
declare
	r discover_missdeviceview%rowtype;
	t timestamp without time zone;
BEGIN
	select modifytime into t from objtimestamp where typename=stypename;
	
	if t is null or t>dt then
		if imax <0 then
			for r in SELECT * FROM discover_missdeviceview where id>ibegin order by id loop
			return next r;
			end loop;
		else
			for r in SELECT * FROM discover_missdeviceview where id>ibegin order by id limit imax loop
			return next r;
			end loop;

		end if;	
	end if;	
END;

  $$;


ALTER FUNCTION public.view_discover_missdeviceview(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) OWNER TO postgres;

--
-- TOC entry 2312 (class 1259 OID 620125)
-- Dependencies: 2635 6
-- Name: discover_newdeviceview; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW discover_newdeviceview AS
    SELECT discover_newdevice.id, discover_newdevice.hostname, discover_newdevice.mgrip, discover_newdevice.devtype, discover_newdevice.vendor, discover_newdevice.model, discover_newdevice.findtime, discover_newdevice.lasttime FROM discover_newdevice;


ALTER TABLE public.discover_newdeviceview OWNER TO postgres;

--
-- TOC entry 238 (class 1255 OID 620129)
-- Dependencies: 6 729 1057
-- Name: view_discover_newdevice(integer, integer, timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_discover_newdevice(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) RETURNS SETOF discover_newdeviceview
    LANGUAGE plpgsql
    AS $$
declare
	r discover_newdeviceview%rowtype;
	t timestamp without time zone;
BEGIN
	select modifytime into t from objtimestamp where typename=stypename;
	
	if t is null or t>dt then
		if imax <0 then
			for r in SELECT * FROM discover_newdeviceview where id>ibegin order by id loop
			return next r;
			end loop;
		else
			for r in SELECT * FROM discover_newdeviceview where id>ibegin order by id limit imax loop
			return next r;
			end loop;

		end if;	
	end if;	
END;

  $$;


ALTER FUNCTION public.view_discover_newdevice(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) OWNER TO postgres;

--
-- TOC entry 2313 (class 1259 OID 620130)
-- Dependencies: 2636 6
-- Name: discover_snmpdeviceview; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW discover_snmpdeviceview AS
    SELECT discover_snmpdevice.id, discover_snmpdevice.hostname, discover_snmpdevice.mgrip, discover_snmpdevice.snmpro, discover_snmpdevice.devtype, discover_snmpdevice.vendor, discover_snmpdevice.model, discover_snmpdevice.findtime FROM discover_snmpdevice;


ALTER TABLE public.discover_snmpdeviceview OWNER TO postgres;

--
-- TOC entry 239 (class 1255 OID 620134)
-- Dependencies: 6 731 1057
-- Name: view_discover_snmpdevice(integer, integer, timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_discover_snmpdevice(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) RETURNS SETOF discover_snmpdeviceview
    LANGUAGE plpgsql
    AS $$
declare
	r discover_snmpdeviceview%rowtype;
	t timestamp without time zone;
BEGIN
	select modifytime into t from objtimestamp where typename=stypename;
	
	if t is null or t>dt then
		if imax <0 then
			for r in SELECT * FROM discover_snmpdeviceview where id>ibegin order by id loop
			return next r;
			end loop;
		else
			for r in SELECT * FROM discover_snmpdeviceview where id>ibegin order by id limit imax loop
			return next r;
			end loop;

		end if;	
	end if;	
END;

  $$;


ALTER FUNCTION public.view_discover_snmpdevice(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) OWNER TO postgres;

--
-- TOC entry 2314 (class 1259 OID 620135)
-- Dependencies: 2637 6
-- Name: discover_unknowdeviceview; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW discover_unknowdeviceview AS
    SELECT discover_unknowdevice.id, discover_unknowdevice.mgrip, discover_unknowdevice.snmpro, discover_unknowdevice.devtype, discover_unknowdevice.sysobjectid, discover_unknowdevice.discoverfrom, discover_unknowdevice.findtime, discover_unknowdevice.devname FROM discover_unknowdevice;


ALTER TABLE public.discover_unknowdeviceview OWNER TO postgres;

--
-- TOC entry 240 (class 1255 OID 620139)
-- Dependencies: 733 1057 6
-- Name: view_discover_unknowdevice(integer, integer, timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_discover_unknowdevice(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) RETURNS SETOF discover_unknowdeviceview
    LANGUAGE plpgsql
    AS $$
declare
	r discover_unknowdeviceview%rowtype;
	t timestamp without time zone;
BEGIN
	select modifytime into t from objtimestamp where typename=stypename;
	
	if t is null or t>dt then
		if imax <0 then
			for r in SELECT * FROM discover_unknowdeviceview where id>ibegin order by id loop
			return next r;
			end loop;
		else
			for r in SELECT * FROM discover_unknowdeviceview where id>ibegin order by id limit imax loop
			return next r;
			end loop;

		end if;	
	end if;	
END;

  $$;


ALTER FUNCTION public.view_discover_unknowdevice(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) OWNER TO postgres;

--
-- TOC entry 2315 (class 1259 OID 620140)
-- Dependencies: 2985 6
-- Name: duplicateip; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE duplicateip (
    id integer NOT NULL,
    ipaddr integer NOT NULL,
    interfaceid integer,
    flag integer DEFAULT 0 NOT NULL,
    deviceid integer
);


ALTER TABLE public.duplicateip OWNER TO postgres;

--
-- TOC entry 2316 (class 1259 OID 620144)
-- Dependencies: 2638 6
-- Name: duplicateipview; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW duplicateipview AS
    SELECT duplicateip.id, duplicateip.ipaddr, duplicateip.interfaceid, duplicateip.flag, duplicateip.deviceid, (SELECT interfacesetting.interfacename FROM interfacesetting WHERE (interfacesetting.id = duplicateip.interfaceid)) AS interfacename, (SELECT devices.strname FROM devices WHERE (duplicateip.deviceid = devices.id)) AS devicename FROM duplicateip;


ALTER TABLE public.duplicateipview OWNER TO postgres;

--
-- TOC entry 241 (class 1255 OID 620148)
-- Dependencies: 737 1057 6
-- Name: view_duplicateip_retrieve(timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_duplicateip_retrieve(dt timestamp without time zone, stypename character varying) RETURNS SETOF duplicateipview
    LANGUAGE plpgsql
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

  $$;


ALTER FUNCTION public.view_duplicateip_retrieve(dt timestamp without time zone, stypename character varying) OWNER TO postgres;

--
-- TOC entry 2317 (class 1259 OID 620149)
-- Dependencies: 6
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
-- TOC entry 242 (class 1255 OID 620155)
-- Dependencies: 739 6 1057
-- Name: view_fixupnatinfo_retrieve(timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_fixupnatinfo_retrieve(dt timestamp without time zone, stypename character varying) RETURNS SETOF fixupnatinfo
    LANGUAGE plpgsql
    AS $$
declare
	r fixupnatinfo%rowtype;
	t timestamp without time zone;
BEGIN		
        select modifytime into t from objtimestamp where typename=stypename;
	if t is null or t>dt then
		for r in SELECT * FROM fixupnatinfo order by ipri loop
		return next r;
		end loop;	
	End IF;
END;

  $$;


ALTER FUNCTION public.view_fixupnatinfo_retrieve(dt timestamp without time zone, stypename character varying) OWNER TO postgres;

--
-- TOC entry 2318 (class 1259 OID 620156)
-- Dependencies: 6
-- Name: fixuproutetable; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE fixuproutetable (
    id integer NOT NULL,
    deviceid integer NOT NULL,
    destip integer NOT NULL,
    destmask integer NOT NULL,
    infname character varying(128) NOT NULL,
    nexthopip integer NOT NULL
);


ALTER TABLE public.fixuproutetable OWNER TO postgres;

--
-- TOC entry 243 (class 1255 OID 620159)
-- Dependencies: 742 1057 6
-- Name: view_fixuproutetable_retrieve(timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_fixuproutetable_retrieve(dt timestamp without time zone, stypename character varying) RETURNS SETOF fixuproutetable
    LANGUAGE plpgsql
    AS $$
declare
	r fixuproutetable%rowtype;
	t timestamp without time zone;
BEGIN		
        select modifytime into t from objtimestamp where typename=stypename;
	if t is null or t>dt then
		for r in SELECT * FROM fixuproutetable order by id loop
		return next r;
		end loop;	
	End IF;
END;

  $$;


ALTER FUNCTION public.view_fixuproutetable_retrieve(dt timestamp without time zone, stypename character varying) OWNER TO postgres;

--
-- TOC entry 2319 (class 1259 OID 620160)
-- Dependencies: 6
-- Name: fixuproutetablepriority; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE fixuproutetablepriority (
    deviceid integer NOT NULL,
    priority integer,
    id integer NOT NULL
);


ALTER TABLE public.fixuproutetablepriority OWNER TO postgres;

--
-- TOC entry 3829 (class 0 OID 0)
-- Dependencies: 2319
-- Name: COLUMN fixuproutetablepriority.priority; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN fixuproutetablepriority.priority IS '0 is lower then routetable
1 is upper then routetable';


--
-- TOC entry 244 (class 1255 OID 620163)
-- Dependencies: 1057 6 744
-- Name: view_fixuproutetablepriority_retrieve(timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_fixuproutetablepriority_retrieve(dt timestamp without time zone, stypename character varying) RETURNS SETOF fixuproutetablepriority
    LANGUAGE plpgsql
    AS $$
declare
	r fixuproutetablepriority%rowtype;
	t timestamp without time zone;
BEGIN		
        select modifytime into t from objtimestamp where typename=stypename;
	if t is null or t>dt then
		for r in SELECT * FROM fixuproutetablepriority order by id loop
		return next r;
		end loop;	
	End IF;
END;

  $$;


ALTER FUNCTION public.view_fixuproutetablepriority_retrieve(dt timestamp without time zone, stypename character varying) OWNER TO postgres;

--
-- TOC entry 2320 (class 1259 OID 620164)
-- Dependencies: 2990 6
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
-- TOC entry 245 (class 1255 OID 620168)
-- Dependencies: 746 1057 6
-- Name: view_fixupunnumberedinterface_retrieve(timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_fixupunnumberedinterface_retrieve(dt timestamp without time zone, stypename character varying) RETURNS SETOF fixupunnumberedinterface
    LANGUAGE plpgsql
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

  $$;


ALTER FUNCTION public.view_fixupunnumberedinterface_retrieve(dt timestamp without time zone, stypename character varying) OWNER TO postgres;

--
-- TOC entry 246 (class 1255 OID 620169)
-- Dependencies: 1057 638 6
-- Name: view_interface_customized_info_retrieve(integer, integer, timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_interface_customized_info_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) RETURNS SETOF interface_customized_infoview
    LANGUAGE plpgsql
    AS $$
declare
	r interface_customized_infoview%rowtype;
	t timestamp without time zone;
BEGIN
	select modifytime into t from objtimestamp where typename=stypename;
	
	if t is null or t>dt then
		if imax <0 then
			for r in SELECT * FROM interface_customized_infoview where id>ibegin and lasttimestamp>dt loop
			return next r;
			end loop;
		else
			for r in SELECT * FROM interface_customized_infoview where id>ibegin and lasttimestamp>dt limit imax loop
			return next r;
			end loop;

		end if;	
	end if;	
END;

  $$;


ALTER FUNCTION public.view_interface_customized_info_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) OWNER TO postgres;

--
-- TOC entry 247 (class 1255 OID 620170)
-- Dependencies: 6 1057 642
-- Name: view_interface_setting_retrieve(integer, integer, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_interface_setting_retrieve(ibegin integer, imax integer, dt timestamp without time zone) RETURNS SETOF interfacesettingview
    LANGUAGE plpgsql
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

  $$;


ALTER FUNCTION public.view_interface_setting_retrieve(ibegin integer, imax integer, dt timestamp without time zone) OWNER TO postgres;

--
-- TOC entry 2321 (class 1259 OID 620171)
-- Dependencies: 6
-- Name: internetboundaryinterface; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE internetboundaryinterface (
    id integer NOT NULL,
    deviceid integer NOT NULL,
    interfaceid integer NOT NULL,
    interfaceip character varying(100) NOT NULL
);


ALTER TABLE public.internetboundaryinterface OWNER TO postgres;

--
-- TOC entry 2322 (class 1259 OID 620174)
-- Dependencies: 2639 6
-- Name: internetboundaryinterfaceview; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW internetboundaryinterfaceview AS
    SELECT internetboundaryinterface.id, internetboundaryinterface.deviceid, internetboundaryinterface.interfaceid, internetboundaryinterface.interfaceip, devices.strname AS devicename, interfacesetting.interfacename, interfacesetting.description FROM internetboundaryinterface, devices, interfacesetting WHERE ((internetboundaryinterface.deviceid = devices.id) AND (internetboundaryinterface.interfaceid = interfacesetting.id));


ALTER TABLE public.internetboundaryinterfaceview OWNER TO postgres;

--
-- TOC entry 248 (class 1255 OID 620178)
-- Dependencies: 1057 750 6
-- Name: view_internetboundaryinterfaceview_retrieve(integer, integer, timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_internetboundaryinterfaceview_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) RETURNS SETOF internetboundaryinterfaceview
    LANGUAGE plpgsql
    AS $$
declare
	r internetboundaryinterfaceview%rowtype;
	t timestamp without time zone;
BEGIN		
	select modifytime into t from objtimestamp where typename=stypename;
	if t is null or t>dt then
		if imax <0 then
			for r in SELECT * FROM internetboundaryinterfaceview where id>ibegin order by id  loop
			return next r;
			end loop;
		else
			for r in SELECT * FROM internetboundaryinterfaceview where id>ibegin order by id limit imax loop
			return next r;
			end loop;

		end if;	
	End IF;		
END;

  $$;


ALTER FUNCTION public.view_internetboundaryinterfaceview_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) OWNER TO postgres;

--
-- TOC entry 250 (class 1255 OID 620179)
-- Dependencies: 644 1057 6
-- Name: view_ip2mac_retrieve(integer, integer, timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_ip2mac_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) RETURNS SETOF ip2mac
    LANGUAGE plpgsql
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

  $$;


ALTER FUNCTION public.view_ip2mac_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) OWNER TO postgres;

--
-- TOC entry 2323 (class 1259 OID 620180)
-- Dependencies: 2993 6
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
-- TOC entry 251 (class 1255 OID 620184)
-- Dependencies: 752 6 1057
-- Name: view_ipphone_retrieve(integer, integer, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_ipphone_retrieve(ibegin integer, imax integer, dt timestamp without time zone) RETURNS SETOF ipphone
    LANGUAGE plpgsql
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

  $$;


ALTER FUNCTION public.view_ipphone_retrieve(ibegin integer, imax integer, dt timestamp without time zone) OWNER TO postgres;

--
-- TOC entry 252 (class 1255 OID 620185)
-- Dependencies: 647 6 1057
-- Name: view_l2connectivity_retrieve(integer, integer, timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_l2connectivity_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) RETURNS SETOF l2connectivity
    LANGUAGE plpgsql
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

  $$;


ALTER FUNCTION public.view_l2connectivity_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) OWNER TO postgres;

--
-- TOC entry 253 (class 1255 OID 620186)
-- Dependencies: 1057 649 6
-- Name: view_l2switchinfo_retrieve(integer, integer, timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_l2switchinfo_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) RETURNS SETOF l2switchinfo
    LANGUAGE plpgsql
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

  $$;


ALTER FUNCTION public.view_l2switchinfo_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) OWNER TO postgres;

--
-- TOC entry 2324 (class 1259 OID 620187)
-- Dependencies: 2994 2995 2996 2997 2998 2999 6
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
    exclude_vlans character varying(254),
    voicevlan character varying(100)
);


ALTER TABLE public.l2switchport OWNER TO postgres;

--
-- TOC entry 3830 (class 0 OID 0)
-- Dependencies: 2324
-- Name: COLUMN l2switchport.usermodifed; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN l2switchport.usermodifed IS '0: org  1: discovery  2: manual';


--
-- TOC entry 254 (class 1255 OID 620200)
-- Dependencies: 6 754 1057
-- Name: view_l2switchport_retrieve(integer, integer, timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_l2switchport_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) RETURNS SETOF l2switchport
    LANGUAGE plpgsql
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

  $$;


ALTER FUNCTION public.view_l2switchport_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) OWNER TO postgres;

--
-- TOC entry 2325 (class 1259 OID 620201)
-- Dependencies: 3001 3002 3003 3004 3005 3006 6
-- Name: l2switchport_temp; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE l2switchport_temp (
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


ALTER TABLE public.l2switchport_temp OWNER TO postgres;

--
-- TOC entry 3831 (class 0 OID 0)
-- Dependencies: 2325
-- Name: COLUMN l2switchport_temp.usermodifed; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN l2switchport_temp.usermodifed IS '0: org  1: discovery  2: manual';


--
-- TOC entry 255 (class 1255 OID 620213)
-- Dependencies: 757 6 1057
-- Name: view_l2switchport_temp_retrieve(integer, integer, timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_l2switchport_temp_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) RETURNS SETOF l2switchport_temp
    LANGUAGE plpgsql
    AS $$
declare
 r l2switchport_temp%rowtype;
BEGIN 
  if imax <0 then
   for r in select * from l2switchport_temp where switchname in (SELECT devicename FROM l2switchinfo where id>ibegin and nb_timestamp>dt order by id)  loop
   return next r;
   end loop;
  else
   for r in select * from l2switchport_temp where switchname in (SELECT devicename FROM l2switchinfo where id>ibegin and nb_timestamp>dt order by id limit imax)  loop
   return next r;
   end loop;
 
  end if;  
END;
 
  $$;


ALTER FUNCTION public.view_l2switchport_temp_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) OWNER TO postgres;

--
-- TOC entry 2326 (class 1259 OID 620214)
-- Dependencies: 3008 3009 6
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
    usermodifed integer DEFAULT 0 NOT NULL,
    ivoicevlan character varying(64)
);


ALTER TABLE public.l2switchvlan OWNER TO postgres;

--
-- TOC entry 3832 (class 0 OID 0)
-- Dependencies: 2326
-- Name: COLUMN l2switchvlan.usermodifed; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN l2switchvlan.usermodifed IS '0: org  1: discovery  2: danual';


--
-- TOC entry 256 (class 1255 OID 620219)
-- Dependencies: 1057 6 760
-- Name: view_l2switchvlan_retrieve(integer, integer, timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_l2switchvlan_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) RETURNS SETOF l2switchvlan
    LANGUAGE plpgsql
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

  $$;


ALTER FUNCTION public.view_l2switchvlan_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) OWNER TO postgres;

--
-- TOC entry 257 (class 1255 OID 620220)
-- Dependencies: 6 651 1057
-- Name: view_lanswitch_retrieve(integer, integer, timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_lanswitch_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) RETURNS SETOF lanswitch
    LANGUAGE plpgsql
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

  $$;


ALTER FUNCTION public.view_lanswitch_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) OWNER TO postgres;

--
-- TOC entry 2327 (class 1259 OID 620221)
-- Dependencies: 6
-- Name: linkgroup_dev_devicegroup; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE linkgroup_dev_devicegroup (
    id integer NOT NULL,
    groupid integer,
    groupidbelone integer
);


ALTER TABLE public.linkgroup_dev_devicegroup OWNER TO postgres;

--
-- TOC entry 2328 (class 1259 OID 620224)
-- Dependencies: 2640 6
-- Name: linkgroup_dev_devicegroupview; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW linkgroup_dev_devicegroupview AS
    SELECT linkgroup_dev_devicegroup.id, linkgroup_dev_devicegroup.groupid AS linkgroupid, (SELECT linkgroup.strname FROM linkgroup WHERE (linkgroup.id = linkgroup_dev_devicegroup.groupid)) AS linkgroupname, linkgroup_dev_devicegroup.groupidbelone AS devicegroupid, (SELECT devicegroup.strname FROM devicegroup WHERE (devicegroup.id = linkgroup_dev_devicegroup.groupidbelone)) AS devicegroupname FROM linkgroup_dev_devicegroup;


ALTER TABLE public.linkgroup_dev_devicegroupview OWNER TO postgres;

--
-- TOC entry 287 (class 1255 OID 621866)
-- Dependencies: 6 764 1057
-- Name: view_linkgroup_dev_devicegroupview_retrieve(integer, integer, timestamp without time zone, integer, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_linkgroup_dev_devicegroupview_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer, stypename character varying, sguid character varying) RETURNS SETOF linkgroup_dev_devicegroupview
    LANGUAGE plpgsql
    AS $$
declare
	r linkgroup_dev_devicegroupview%rowtype;
	t timestamp without time zone;
BEGIN
	if uid=-1 then
		select modifytime into t from objtimestamp where typename=stypename;
	else
		select modifytime into t from objprivatetimestamp where typename=stypename and userid=uid and licguid=sguid;
	end if;
	
	if t is null or t>dt then
		if imax <0 then
			if uid=-1 then
				for r in select * from linkgroup_dev_devicegroupview where linkgroupid in (SELECT id FROM linkgroup where id>ibegin and userid=uid and (licguid=sguid or licguid='-1') order by id) order by linkgroupid loop
				return next r;
				end loop;
			else
				for r in select * from linkgroup_dev_devicegroupview where linkgroupid in (SELECT id FROM linkgroup where id>ibegin and userid=uid and licguid=sguid order by id) order by linkgroupid loop
				return next r;
				end loop;
			end if;			
		else
			if uid=-1 then
				for r in select * from linkgroup_dev_devicegroupview where linkgroupid in (SELECT id FROM linkgroup where id>ibegin and userid=uid and (licguid=sguid or licguid='-1') order by id limit imax) order by linkgroupid loop			
				return next r;
				end loop;
			else
				for r in select * from linkgroup_dev_devicegroupview where linkgroupid in (SELECT id FROM linkgroup where id>ibegin and userid=uid and licguid=sguid order by id limit imax) order by linkgroupid loop			
				return next r;
				end loop;
			end if;			
		end if;	
	end if;	
END;

  $$;


ALTER FUNCTION public.view_linkgroup_dev_devicegroupview_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer, stypename character varying, sguid character varying) OWNER TO postgres;

--
-- TOC entry 2329 (class 1259 OID 620229)
-- Dependencies: 3013 6
-- Name: linkgroup_dev_site; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE linkgroup_dev_site (
    id integer NOT NULL,
    groupid integer,
    siteid integer,
    sitechild integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.linkgroup_dev_site OWNER TO postgres;

--
-- TOC entry 2330 (class 1259 OID 620233)
-- Dependencies: 2641 6
-- Name: linkgroup_dev_siteview; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW linkgroup_dev_siteview AS
    SELECT linkgroup_dev_site.id, linkgroup_dev_site.groupid AS linkgroupid, (SELECT linkgroup.strname FROM linkgroup WHERE (linkgroup.id = linkgroup_dev_site.groupid)) AS linkgroupname, linkgroup_dev_site.siteid, (SELECT site.name FROM site WHERE (site.id = linkgroup_dev_site.siteid)) AS sitename, linkgroup_dev_site.sitechild FROM linkgroup_dev_site;


ALTER TABLE public.linkgroup_dev_siteview OWNER TO postgres;

--
-- TOC entry 288 (class 1255 OID 621867)
-- Dependencies: 6 1057 768
-- Name: view_linkgroup_dev_siteview_retrieve(integer, integer, timestamp without time zone, integer, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_linkgroup_dev_siteview_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer, stypename character varying, sguid character varying) RETURNS SETOF linkgroup_dev_siteview
    LANGUAGE plpgsql
    AS $$
declare
	r linkgroup_dev_siteview%rowtype;
	t timestamp without time zone;
BEGIN
	if uid=-1 then
		select modifytime into t from objtimestamp where typename=stypename;
	else
		select modifytime into t from objprivatetimestamp where typename=stypename and userid=uid and licguid=sguid;
	end if;
	
	if t is null or t>dt then
		if imax <0 then
			if uid=-1 then
				for r in select * from linkgroup_dev_siteview where linkgroupid in (SELECT id FROM linkgroup where id>ibegin and userid=uid and (licguid=sguid or licguid='-1') order by id) order by linkgroupid loop
				return next r;
				end loop;
			else
				for r in select * from linkgroup_dev_siteview where linkgroupid in (SELECT id FROM linkgroup where id>ibegin and userid=uid and licguid=sguid order by id) order by linkgroupid loop
				return next r;
				end loop;
			end if;			
		else
			if uid=-1 then
				for r in select * from linkgroup_dev_siteview where linkgroupid in (SELECT id FROM linkgroup where id>ibegin and userid=uid and (licguid=sguid or licguid='-1') order by id limit imax) order by linkgroupid loop			
				return next r;
				end loop;
			else
				for r in select * from linkgroup_dev_siteview where linkgroupid in (SELECT id FROM linkgroup where id>ibegin and userid=uid and licguid=sguid order by id limit imax) order by linkgroupid loop			
				return next r;
				end loop;
			end if;			
		end if;	
	end if;	
END;

  $$;


ALTER FUNCTION public.view_linkgroup_dev_siteview_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer, stypename character varying, sguid character varying) OWNER TO postgres;

--
-- TOC entry 2331 (class 1259 OID 620238)
-- Dependencies: 6
-- Name: linkgroup_dev_systemdevicegroup; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE linkgroup_dev_systemdevicegroup (
    id integer NOT NULL,
    groupid integer,
    groupidbelone integer
);


ALTER TABLE public.linkgroup_dev_systemdevicegroup OWNER TO postgres;

--
-- TOC entry 2332 (class 1259 OID 620241)
-- Dependencies: 2642 6
-- Name: linkgroup_dev_systemdevicegroupview; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW linkgroup_dev_systemdevicegroupview AS
    SELECT linkgroup_dev_systemdevicegroup.id, linkgroup_dev_systemdevicegroup.groupid AS linkgroupid, (SELECT devicegroup.strname FROM devicegroup WHERE (devicegroup.id = linkgroup_dev_systemdevicegroup.groupid)) AS groupname, linkgroup_dev_systemdevicegroup.groupidbelone AS systemdevicegroup, (SELECT systemdevicegroup.strname FROM systemdevicegroup WHERE (systemdevicegroup.id = linkgroup_dev_systemdevicegroup.groupidbelone)) AS systemdevicegroupname FROM linkgroup_dev_systemdevicegroup;


ALTER TABLE public.linkgroup_dev_systemdevicegroupview OWNER TO postgres;

--
-- TOC entry 289 (class 1255 OID 621868)
-- Dependencies: 6 772 1057
-- Name: view_linkgroup_dev_systemdevicegroupview_retrieve(integer, integer, timestamp without time zone, integer, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_linkgroup_dev_systemdevicegroupview_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer, stypename character varying, sguid character varying) RETURNS SETOF linkgroup_dev_systemdevicegroupview
    LANGUAGE plpgsql
    AS $$
declare
	r linkgroup_dev_systemdevicegroupview%rowtype;
	t timestamp without time zone;
BEGIN
	if uid=-1 then
		select modifytime into t from objtimestamp where typename=stypename;
	else
		select modifytime into t from objprivatetimestamp where typename=stypename and userid=uid and licguid=sguid;
	end if;
	
	if t is null or t>dt then
		if imax <0 then
			if uid=-1 then
				for r in select * from linkgroup_dev_systemdevicegroupview where linkgroupid in (SELECT id FROM linkgroup where id>ibegin and (licguid=sguid or licguid='-1') order by id) order by linkgroupid loop
				return next r;
				end loop;
			else
				for r in select * from linkgroup_dev_systemdevicegroupview where linkgroupid in (SELECT id FROM linkgroup where id>ibegin and licguid=sguid order by id) order by linkgroupid loop
				return next r;
				end loop;
			end if;			
		else
			if uid=-1 then
				for r in select * from linkgroup_dev_systemdevicegroupview where linkgroupid in (SELECT id FROM linkgroup where id>ibegin and (licguid=sguid or licguid='-1') order by id limit imax) order by linkgroupid loop			
				return next r;
				end loop;
			else
				for r in select * from linkgroup_dev_systemdevicegroupview where linkgroupid in (SELECT id FROM linkgroup where id>ibegin and licguid=sguid order by id limit imax) order by linkgroupid loop			
				return next r;
				end loop;
			end if;			
		end if;	
	end if;	
END;

  $$;


ALTER FUNCTION public.view_linkgroup_dev_systemdevicegroupview_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer, stypename character varying, sguid character varying) OWNER TO postgres;

--
-- TOC entry 2333 (class 1259 OID 620246)
-- Dependencies: 6
-- Name: linkgroup_paramvalue; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE linkgroup_paramvalue (
    id integer NOT NULL,
    paramid integer NOT NULL,
    strvalue text NOT NULL,
    strdesc text
);


ALTER TABLE public.linkgroup_paramvalue OWNER TO postgres;

--
-- TOC entry 290 (class 1255 OID 621869)
-- Dependencies: 1057 774 6
-- Name: view_linkgroup_paramvalue_retrieve(integer, integer, timestamp without time zone, integer, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_linkgroup_paramvalue_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer, stypename character varying, sguid character varying) RETURNS SETOF linkgroup_paramvalue
    LANGUAGE plpgsql
    AS $$
declare
	r linkgroup_paramvalue%rowtype;
	t timestamp without time zone;
BEGIN	
	if uid=-1 then
		select modifytime into t from objtimestamp where typename=stypename;
	else
		select modifytime into t from objprivatetimestamp where typename=stypename and userid=uid and licguid=sguid;
	end if;
	
	if t is null or t>dt then
		if imax <0 then
			if uid=-1 then
				for r in select * from linkgroup_paramvalue where paramid in (SELECT linkgroup_param.id FROM linkgroup,linkgroup_param where linkgroup.id=linkgroup_param.linkgroupid and linkgroup.id>ibegin and linkgroup.userid=uid and (licguid=sguid or licguid='-1') order by linkgroup.id) order by id loop
				return next r;
				end loop;
			else
				for r in select * from linkgroup_paramvalue where paramid in (SELECT linkgroup_param.id FROM linkgroup,linkgroup_param where linkgroup.id=linkgroup_param.linkgroupid and linkgroup.id>ibegin and linkgroup.userid=uid and licguid=sguid order by linkgroup.id) order by id loop
				return next r;
				end loop;
			end if;			
		else
			if uid=-1 then
				for r in select * from linkgroup_paramvalue where paramid in (SELECT linkgroup_param.id FROM linkgroup,linkgroup_param where linkgroup.id=linkgroup_param.linkgroupid and linkgroup.id>ibegin and linkgroup.userid=uid and (licguid=sguid or licguid='-1') order by linkgroup.id limit imax) order by id loop			
				return next r;
				end loop;
			else
				for r in select * from linkgroup_paramvalue where paramid in (SELECT linkgroup_param.id FROM linkgroup,linkgroup_param where linkgroup.id=linkgroup_param.linkgroupid and linkgroup.id>ibegin and linkgroup.userid=uid and licguid=sguid order by linkgroup.id limit imax) order by id loop			
				return next r;
				end loop;
			end if;			
		end if;	
	end if;	
END;

  $$;


ALTER FUNCTION public.view_linkgroup_paramvalue_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer, stypename character varying, sguid character varying) OWNER TO postgres;

--
-- TOC entry 2334 (class 1259 OID 620253)
-- Dependencies: 6
-- Name: linkgroupinterface; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE linkgroupinterface (
    id integer NOT NULL,
    groupid integer NOT NULL,
    interfaceid integer NOT NULL,
    type integer NOT NULL,
    interfaceip character varying(255),
    deviceid integer
);


ALTER TABLE public.linkgroupinterface OWNER TO postgres;

--
-- TOC entry 3833 (class 0 OID 0)
-- Dependencies: 2334
-- Name: COLUMN linkgroupinterface.type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN linkgroupinterface.type IS '1 static 2 dynamic';


--
-- TOC entry 2335 (class 1259 OID 620256)
-- Dependencies: 2643 6
-- Name: linkgroupview; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW linkgroupview AS
    SELECT linkgroup.id, linkgroup.strname, linkgroup.strdesc, linkgroup.showcolor, linkgroup.showstyle, linkgroup.showwidth, linkgroup.searchcondition, linkgroup.userid, (SELECT count(*) AS count FROM linkgroupinterface WHERE (linkgroupinterface.groupid = linkgroup.id)) AS irefcount, linkgroup.searchcontainer, linkgroup.dev_searchcondition, linkgroup.dev_searchcontainer, linkgroup.is_map_auto_link, linkgroup.istemplate, linkgroup.licguid FROM linkgroup;


ALTER TABLE public.linkgroupview OWNER TO postgres;

--
-- TOC entry 282 (class 1255 OID 621870)
-- Dependencies: 1057 6 779
-- Name: view_linkgroup_retrieve(integer, integer, timestamp without time zone, integer, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_linkgroup_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer, stypename character varying, sguid character varying) RETURNS SETOF linkgroupview
    LANGUAGE plpgsql
    AS $$
declare
	r linkgroupview%rowtype;
	t timestamp without time zone;
BEGIN	
	if uid=-1 then
		select modifytime into t from objtimestamp where typename=stypename;
	else
		select modifytime into t from objprivatetimestamp where typename=stypename and userid=uid and licguid=sguid;
	end if;
	if t is null or t>dt then
		if imax <0 then
			if uid=-1 then
				for r in SELECT * FROM linkgroupview where id>ibegin and userid=uid and (licguid=sguid or licguid='-1') loop
				return next r;
				end loop;
			else
				for r in SELECT * FROM linkgroupview where id>ibegin and userid=uid and licguid=sguid loop
				return next r;
				end loop;
			end if;		
		else
			if uid=-1 then
				for r in SELECT * FROM linkgroupview where id>ibegin and userid=uid and (licguid=sguid or licguid='-1') limit imax loop
				return next r;
				end loop;
			else
				for r in SELECT * FROM linkgroupview where id>ibegin and userid=uid and licguid=sguid limit imax loop
				return next r;
				end loop;
			end if;		
		end if;	
	end if;	
END;

  $$;


ALTER FUNCTION public.view_linkgroup_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer, stypename character varying, sguid character varying) OWNER TO postgres;

--
-- TOC entry 2336 (class 1259 OID 620261)
-- Dependencies: 6
-- Name: linkgroupdevicegroup; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE linkgroupdevicegroup (
    id integer NOT NULL,
    groupid integer,
    groupidbelone integer
);


ALTER TABLE public.linkgroupdevicegroup OWNER TO postgres;

--
-- TOC entry 2337 (class 1259 OID 620264)
-- Dependencies: 2644 6
-- Name: linkgroupdevicegroupview; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW linkgroupdevicegroupview AS
    SELECT linkgroup.id, linkgroupdevicegroup.groupidbelone, (SELECT devicegroup.strname FROM devicegroup WHERE (devicegroup.id = linkgroupdevicegroup.groupidbelone)) AS devicegroupname FROM linkgroup, linkgroupdevicegroup WHERE (linkgroupdevicegroup.groupid = linkgroup.id);


ALTER TABLE public.linkgroupdevicegroupview OWNER TO postgres;

--
-- TOC entry 291 (class 1255 OID 621872)
-- Dependencies: 1057 6 783
-- Name: view_linkgroupdevicegroupview_retrieve(integer, integer, timestamp without time zone, integer, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_linkgroupdevicegroupview_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer, stypename character varying, sguid character varying) RETURNS SETOF linkgroupdevicegroupview
    LANGUAGE plpgsql
    AS $$
declare
	r linkgroupdevicegroupview%rowtype;
	t timestamp without time zone;
BEGIN	
	if uid=-1 then
		select modifytime into t from objtimestamp where typename=stypename;
	else
		select modifytime into t from objprivatetimestamp where typename=stypename and userid=uid and licguid=sguid;
	end if;
	
	if t is null or t>dt then
		if imax <0 then
			if uid=-1 then
				for r in select * from linkgroupdevicegroupview where id in (SELECT id FROM linkgroup where id>ibegin and userid=uid and (licguid=sguid or licguid='-1') order by id) order by id loop
				return next r;
				end loop;
			else
				for r in select * from linkgroupdevicegroupview where id in (SELECT id FROM linkgroup where id>ibegin and userid=uid and licguid=sguid order by id) order by id loop
				return next r;
				end loop;
			end if;			
		else
			if uid=-1 then
				for r in select * from linkgroupdevicegroupview where id in (SELECT id FROM linkgroup where id>ibegin and userid=uid and (licguid=sguid or licguid='-1') order by id limit imax) order by id loop			
				return next r;
				end loop;
			else
				for r in select * from linkgroupdevicegroupview where id in (SELECT id FROM linkgroup where id>ibegin and userid=uid and licguid=sguid order by id limit imax) order by id loop			
				return next r;
				end loop;
			end if;			
		end if;	
	end if;	
END;

  $$;


ALTER FUNCTION public.view_linkgroupdevicegroupview_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer, stypename character varying, sguid character varying) OWNER TO postgres;

--
-- TOC entry 2338 (class 1259 OID 620269)
-- Dependencies: 3019 6
-- Name: linkgroupdevice; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE linkgroupdevice (
    id integer NOT NULL,
    linkgroupid integer NOT NULL,
    deviceid integer NOT NULL,
    type integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.linkgroupdevice OWNER TO postgres;

--
-- TOC entry 3834 (class 0 OID 0)
-- Dependencies: 2338
-- Name: COLUMN linkgroupdevice.type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN linkgroupdevice.type IS '1 static 2 dynamic 3 exclude';


--
-- TOC entry 2339 (class 1259 OID 620273)
-- Dependencies: 2645 6
-- Name: linkgroupdeviceview; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW linkgroupdeviceview AS
    SELECT linkgroupdevice.linkgroupid, linkgroupdevice.deviceid, linkgroupdevice.id, (SELECT devices.strname FROM devices WHERE (devices.id = linkgroupdevice.deviceid)) AS devicename, (SELECT linkgroup.strname FROM linkgroup WHERE (linkgroup.id = linkgroupdevice.linkgroupid)) AS linkgroupname, (SELECT devices.isubtype FROM devices WHERE (devices.id = linkgroupdevice.deviceid)) AS isubtype, linkgroupdevice.type FROM linkgroupdevice;


ALTER TABLE public.linkgroupdeviceview OWNER TO postgres;

--
-- TOC entry 292 (class 1255 OID 621873)
-- Dependencies: 1057 787 6
-- Name: view_linkgroupdeviceview_retrieve(integer, integer, timestamp without time zone, integer, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_linkgroupdeviceview_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer, stypename character varying, sguid character varying) RETURNS SETOF linkgroupdeviceview
    LANGUAGE plpgsql
    AS $$
declare
	r linkgroupdeviceview%rowtype;
	t timestamp without time zone;
BEGIN
	if uid=-1 then
		select modifytime into t from objtimestamp where typename=stypename;
	else
		select modifytime into t from objprivatetimestamp where typename=stypename and userid=uid and licguid=sguid;
	end if;
	
	if t is null or t>dt then
		if imax <0 then
			if uid=-1 then
				for r in select * from linkgroupdeviceview where linkgroupid in (SELECT id FROM linkgroup where id>ibegin and userid=uid and (licguid=sguid or licguid='-1') order by id) order by linkgroupid loop
				return next r;
				end loop;
			else
				for r in select * from linkgroupdeviceview where linkgroupid in (SELECT id FROM linkgroup where id>ibegin and userid=uid and licguid=sguid order by id) order by linkgroupid loop
				return next r;
				end loop;
			end if;			
		else
			if uid=-1 then
				for r in select * from linkgroupdeviceview where linkgroupid in (SELECT id FROM linkgroup where id>ibegin and userid=uid and (licguid=sguid or licguid='-1') order by id limit imax) order by linkgroupid loop			
				return next r;
				end loop;
			else
				for r in select * from linkgroupdeviceview where linkgroupid in (SELECT id FROM linkgroup where id>ibegin and userid=uid and licguid=sguid order by id limit imax) order by linkgroupid loop			
				return next r;
				end loop;
			end if;			
		end if;	
	end if;	
END;

  $$;


ALTER FUNCTION public.view_linkgroupdeviceview_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer, stypename character varying, sguid character varying) OWNER TO postgres;

--
-- TOC entry 2340 (class 1259 OID 620278)
-- Dependencies: 2646 6
-- Name: linkgroupinterfaceview; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW linkgroupinterfaceview AS
    SELECT linkgroupinterface.id, linkgroupinterface.groupid, linkgroupinterface.interfaceid, linkgroupinterface.interfaceip, linkgroupinterface.type, (SELECT interfacesetting.interfacename FROM interfacesetting WHERE (interfacesetting.id = linkgroupinterface.interfaceid)) AS interfacename, linkgroupinterface.deviceid, (SELECT devices.strname FROM devices WHERE (devices.id = linkgroupinterface.deviceid)) AS devicename, (SELECT devices.isubtype FROM devices WHERE (devices.id = linkgroupinterface.deviceid)) AS isubtype FROM linkgroupinterface;


ALTER TABLE public.linkgroupinterfaceview OWNER TO postgres;

--
-- TOC entry 293 (class 1255 OID 621874)
-- Dependencies: 1057 789 6
-- Name: view_linkgroupinterfaceview_retrieve(integer, integer, timestamp without time zone, integer, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_linkgroupinterfaceview_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer, stypename character varying, sguid character varying) RETURNS SETOF linkgroupinterfaceview
    LANGUAGE plpgsql
    AS $$
declare
	r linkgroupinterfaceview%rowtype;
	t timestamp without time zone;
BEGIN
	if uid=-1 then
		select modifytime into t from objtimestamp where typename=stypename;
	else
		select modifytime into t from objprivatetimestamp where typename=stypename and userid=uid and licguid=sguid;
	end if;
		
	if t is null or t>dt then
		if imax <0 then
			if uid=-1 then
				for r in select * from linkgroupinterfaceview where groupid in (SELECT id FROM linkgroup where id>ibegin and userid=uid and (licguid=sguid or licguid='-1') order by id) order by groupid loop
				return next r;
				end loop;
			else
				for r in select * from linkgroupinterfaceview where groupid in (SELECT id FROM linkgroup where id>ibegin and userid=uid and licguid=sguid order by id) order by groupid loop
				return next r;
				end loop;
			end if;			
		else
			if uid=-1 then
				for r in select * from linkgroupinterfaceview where groupid in (SELECT id FROM linkgroup where id>ibegin and userid=uid and (licguid=sguid or licguid='-1') order by id limit imax) order by groupid loop			
				return next r;
				end loop;
			else
				for r in select * from linkgroupinterfaceview where groupid in (SELECT id FROM linkgroup where id>ibegin and userid=uid and licguid=sguid order by id limit imax) order by groupid loop			
				return next r;
				end loop;
			end if;			
		end if;	
	end if;	
END;

  $$;


ALTER FUNCTION public.view_linkgroupinterfaceview_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer, stypename character varying, sguid character varying) OWNER TO postgres;

--
-- TOC entry 2341 (class 1259 OID 620283)
-- Dependencies: 6
-- Name: linkgrouplinkgroup; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE linkgrouplinkgroup (
    id integer NOT NULL,
    groupid integer,
    groupidbelone integer
);


ALTER TABLE public.linkgrouplinkgroup OWNER TO postgres;

--
-- TOC entry 2342 (class 1259 OID 620286)
-- Dependencies: 2647 6
-- Name: linkgrouplinkgroupview; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW linkgrouplinkgroupview AS
    SELECT linkgroup.id, linkgrouplinkgroup.groupidbelone, (SELECT linkgroup.strname FROM linkgroup WHERE (linkgroup.id = linkgrouplinkgroup.groupidbelone)) AS linkgroupname FROM linkgroup, linkgrouplinkgroup WHERE (linkgrouplinkgroup.groupid = linkgroup.id);


ALTER TABLE public.linkgrouplinkgroupview OWNER TO postgres;

--
-- TOC entry 294 (class 1255 OID 621875)
-- Dependencies: 6 793 1057
-- Name: view_linkgrouplinkgroupview_retrieve(integer, integer, timestamp without time zone, integer, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_linkgrouplinkgroupview_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer, stypename character varying, sguid character varying) RETURNS SETOF linkgrouplinkgroupview
    LANGUAGE plpgsql
    AS $$
declare
	r linkgrouplinkgroupview%rowtype;
	t timestamp without time zone;
BEGIN	
	if uid=-1 then
		select modifytime into t from objtimestamp where typename=stypename;
	else
		select modifytime into t from objprivatetimestamp where typename=stypename and userid=uid and licguid=sguid;
	end if;

	if t is null or t>dt then
		if imax <0 then
			if uid=-1 then
				for r in select * from linkgrouplinkgroupview where id in (SELECT id FROM linkgroup where id>ibegin and userid=uid and (licguid=sguid or licguid='-1') order by id) order by id loop
				return next r;
				end loop;
			else
				for r in select * from linkgrouplinkgroupview where id in (SELECT id FROM linkgroup where id>ibegin and userid=uid and licguid=sguid order by id) order by id loop
				return next r;
				end loop;
			end if;			
		else
			if uid=-1 then
				for r in select * from linkgrouplinkgroupview where id in (SELECT id FROM linkgroup where id>ibegin and userid=uid and (licguid=sguid or licguid='-1') order by id limit imax) order by id loop			
				return next r;
				end loop;
			else
				for r in select * from linkgrouplinkgroupview where id in (SELECT id FROM linkgroup where id>ibegin and userid=uid and licguid=sguid order by id limit imax) order by id loop			
				return next r;
				end loop;
			end if;			
		end if;	
	end if;	
END;

  $$;


ALTER FUNCTION public.view_linkgrouplinkgroupview_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer, stypename character varying, sguid character varying) OWNER TO postgres;

--
-- TOC entry 2343 (class 1259 OID 620291)
-- Dependencies: 6
-- Name: linkgroup_param; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE linkgroup_param (
    id integer NOT NULL,
    linkgroupid integer NOT NULL,
    strname text NOT NULL,
    strdesc text
);


ALTER TABLE public.linkgroup_param OWNER TO postgres;

--
-- TOC entry 295 (class 1255 OID 621876)
-- Dependencies: 1057 6 795
-- Name: view_linkgroupparam_retrieve(integer, integer, timestamp without time zone, integer, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_linkgroupparam_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer, stypename character varying, sguid character varying) RETURNS SETOF linkgroup_param
    LANGUAGE plpgsql
    AS $$
declare
	r linkgroup_param%rowtype;
	t timestamp without time zone;
BEGIN	
	if uid=-1 then
		select modifytime into t from objtimestamp where typename=stypename;
	else
		select modifytime into t from objprivatetimestamp where typename=stypename and userid=uid and licguid=sguid;
	end if;
	
	if t is null or t>dt then
		if imax <0 then
			if uid=-1 then
				for r in select * from linkgroup_param where linkgroupid in (SELECT id FROM linkgroup where id>ibegin and userid=uid and (licguid=sguid or licguid='-1') order by id) order by id loop
				return next r;
				end loop;
			else
				for r in select * from linkgroup_param where linkgroupid in (SELECT id FROM linkgroup where id>ibegin and userid=uid and licguid=sguid order by id) order by id loop
				return next r;
				end loop;
			end if;			
		else
			if uid=-1 then
				for r in select * from linkgroup_param where linkgroupid in (SELECT id FROM linkgroup where id>ibegin and userid=uid and (licguid=sguid or licguid='-1') order by id limit imax) order by id loop			
				return next r;
				end loop;
			else
				for r in select * from linkgroup_param where linkgroupid in (SELECT id FROM linkgroup where id>ibegin and userid=uid and licguid=sguid order by id limit imax) order by id loop			
				return next r;
				end loop;
			end if;		
		end if;	
	end if;	
END;

  $$;


ALTER FUNCTION public.view_linkgroupparam_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer, stypename character varying, sguid character varying) OWNER TO postgres;

--
-- TOC entry 2344 (class 1259 OID 620298)
-- Dependencies: 3023 6
-- Name: linkgroupsite; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE linkgroupsite (
    id integer NOT NULL,
    groupid integer,
    siteid integer,
    sitechild integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.linkgroupsite OWNER TO postgres;

--
-- TOC entry 2345 (class 1259 OID 620302)
-- Dependencies: 2648 6
-- Name: linkgroupsiteview; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW linkgroupsiteview AS
    SELECT linkgroup.id, linkgroupsite.siteid, (SELECT site.name FROM site WHERE (site.id = linkgroupsite.siteid)) AS sitename, linkgroupsite.sitechild FROM linkgroup, linkgroupsite WHERE (linkgroupsite.groupid = linkgroup.id);


ALTER TABLE public.linkgroupsiteview OWNER TO postgres;

--
-- TOC entry 296 (class 1255 OID 621877)
-- Dependencies: 1057 800 6
-- Name: view_linkgroupsiteview_retrieve(integer, integer, timestamp without time zone, integer, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_linkgroupsiteview_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer, stypename character varying, sguid character varying) RETURNS SETOF linkgroupsiteview
    LANGUAGE plpgsql
    AS $$
declare
	r linkgroupsiteview%rowtype;
	t timestamp without time zone;
BEGIN	
	if uid=-1 then
		select modifytime into t from objtimestamp where typename=stypename;
	else
		select modifytime into t from objprivatetimestamp where typename=stypename and userid=uid and licguid=sguid;
	end if;
	
	if t is null or t>dt then
		if imax <0 then
			if uid=-1 then
				for r in select * from linkgroupsiteview where id in (SELECT id FROM linkgroup where id>ibegin and userid=uid and (licguid=sguid or licguid='-1') order by id) order by id loop
				return next r;
				end loop;
			else
				for r in select * from linkgroupsiteview where id in (SELECT id FROM linkgroup where id>ibegin and userid=uid and licguid=sguid order by id) order by id loop
				return next r;
				end loop;
			end if;			
		else
			if uid=-1 then
				for r in select * from linkgroupsiteview where id in (SELECT id FROM linkgroup where id>ibegin and userid=uid and (licguid=sguid or licguid='-1') order by id limit imax) order by id loop			
				return next r;
				end loop;
			else
				for r in select * from linkgroupsiteview where id in (SELECT id FROM linkgroup where id>ibegin and userid=uid and licguid=sguid order by id limit imax) order by id loop			
				return next r;
				end loop;
			end if;			
		end if;	
	end if;	
END;

  $$;


ALTER FUNCTION public.view_linkgroupsiteview_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer, stypename character varying, sguid character varying) OWNER TO postgres;

--
-- TOC entry 2346 (class 1259 OID 620307)
-- Dependencies: 6
-- Name: linkgroupsystemdevicegroup; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE linkgroupsystemdevicegroup (
    id integer NOT NULL,
    groupid integer,
    groupidbelone integer
);


ALTER TABLE public.linkgroupsystemdevicegroup OWNER TO postgres;

--
-- TOC entry 2347 (class 1259 OID 620310)
-- Dependencies: 2649 6
-- Name: linkgroupsystemdevicegroupview; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW linkgroupsystemdevicegroupview AS
    SELECT linkgroupsystemdevicegroup.id, linkgroupsystemdevicegroup.groupid, (SELECT linkgroup.strname FROM linkgroup WHERE (linkgroup.id = linkgroupsystemdevicegroup.groupid)) AS groupname, linkgroupsystemdevicegroup.groupidbelone, (SELECT systemdevicegroup.strname FROM systemdevicegroup WHERE (systemdevicegroup.id = linkgroupsystemdevicegroup.groupidbelone)) AS groupnamebelone FROM linkgroupsystemdevicegroup;


ALTER TABLE public.linkgroupsystemdevicegroupview OWNER TO postgres;

--
-- TOC entry 297 (class 1255 OID 621878)
-- Dependencies: 1057 804 6
-- Name: view_linkgroupsystemdevicegroupview_retrieve(integer, integer, timestamp without time zone, integer, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_linkgroupsystemdevicegroupview_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer, stypename character varying, sguid character varying) RETURNS SETOF linkgroupsystemdevicegroupview
    LANGUAGE plpgsql
    AS $$
declare
	r linkgroupsystemdevicegroupview%rowtype;
	t timestamp without time zone;
BEGIN	
	if uid=-1 then
		select modifytime into t from objtimestamp where typename=stypename;
	else
		select modifytime into t from objprivatetimestamp where typename=stypename and userid=uid and licguid=sguid;
	end if;
	
	if t is null or t>dt then
		if imax <0 then
			if uid=-1 then
				for r in select * from linkgroupsystemdevicegroupview where groupid in (SELECT id FROM linkgroup where id>ibegin and userid=uid and (licguid=sguid or licguid='-1') order by id) order by id loop
				return next r;
				end loop;
			else
				for r in select * from linkgroupsystemdevicegroupview where groupid in (SELECT id FROM linkgroup where id>ibegin and userid=uid and licguid=sguid order by id) order by id loop
				return next r;
				end loop;
			end if;			
		else
			if uid=-1 then
				for r in select * from linkgroupsystemdevicegroupview where groupid in (SELECT id FROM linkgroup where id>ibegin and userid=uid and (licguid=sguid or licguid='-1') order by id limit imax) order by id loop			
				return next r;
				end loop;
			else
				for r in select * from linkgroupsystemdevicegroupview where groupid in (SELECT id FROM linkgroup where id>ibegin and userid=uid and licguid=sguid order by id limit imax) order by id loop			
				return next r;
				end loop;
			end if;			
		end if;	
	end if;	
END;

  $$;


ALTER FUNCTION public.view_linkgroupsystemdevicegroupview_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer, stypename character varying, sguid character varying) OWNER TO postgres;

--
-- TOC entry 2348 (class 1259 OID 620315)
-- Dependencies: 6
-- Name: lwap; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE lwap (
    id integer NOT NULL,
    hostname character varying(64) NOT NULL,
    version character varying(64),
    ipaddress character varying(64),
    macaddress character varying(64),
    sgroup character varying(64),
    primarycontroller character varying(64),
    secondarycontroll character varying(64),
    defaultgateway character varying(64),
    vendor character varying(64),
    module character varying(64),
    softwareversion character varying(64),
    serialnumber character varying(64),
    config text
);


ALTER TABLE public.lwap OWNER TO postgres;

--
-- TOC entry 258 (class 1255 OID 620321)
-- Dependencies: 806 1057 6
-- Name: view_lwap(integer, integer, timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_lwap(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) RETURNS SETOF lwap
    LANGUAGE plpgsql
    AS $$
declare
	r lwap%rowtype;
	t timestamp without time zone;
BEGIN
	select modifytime into t from objtimestamp where typename=stypename;
	
	if t is null or t>dt then
		if imax <0 then
			for r in SELECT * FROM lwap where id>ibegin order by id loop
			return next r;
			end loop;
		else
			for r in SELECT * FROM lwap where id>ibegin order by id limit imax loop
			return next r;
			end loop;

		end if;	
	end if;	
END;

  $$;


ALTER FUNCTION public.view_lwap(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) OWNER TO postgres;

--
-- TOC entry 259 (class 1255 OID 620322)
-- Dependencies: 6 1057 664
-- Name: view_module_customized_info_retrieve(integer, integer, timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_module_customized_info_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) RETURNS SETOF module_customized_infoview
    LANGUAGE plpgsql
    AS $$
declare
	r module_customized_infoview%rowtype;
	t timestamp without time zone;
BEGIN
	select modifytime into t from objtimestamp where typename=stypename;
	
	if t is null or t>dt then
		if imax <0 then
			for r in SELECT * FROM module_customized_infoview where id>ibegin and lasttimestamp>dt loop
			return next r;
			end loop;
		else
			for r in SELECT * FROM module_customized_infoview where id>ibegin and lasttimestamp>dt limit imax loop
			return next r;
			end loop;

		end if;	
	end if;	
END;

  $$;


ALTER FUNCTION public.view_module_customized_info_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) OWNER TO postgres;

--
-- TOC entry 260 (class 1255 OID 620323)
-- Dependencies: 662 1057 6
-- Name: view_module_property_retrieve(integer, integer, timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_module_property_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) RETURNS SETOF module_propertyview
    LANGUAGE plpgsql
    AS $$
declare
	r module_propertyview%rowtype;
	t timestamp without time zone;
BEGIN
	select modifytime into t from objtimestamp where typename=stypename;
	
	if t is null or t>dt then
		if imax <0 then
			for r in SELECT * FROM module_propertyview where id>ibegin and lasttimestamp>dt loop
			return next r;
			end loop;
		else
			for r in SELECT * FROM module_propertyview where id>ibegin and lasttimestamp>dt limit imax loop
			return next r;
			end loop;

		end if;	
	end if;	
END;

  $$;


ALTER FUNCTION public.view_module_property_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) OWNER TO postgres;

--
-- TOC entry 2349 (class 1259 OID 620324)
-- Dependencies: 6
-- Name: nattointf; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE nattointf (
    id integer NOT NULL,
    natid integer,
    natintfid integer
);


ALTER TABLE public.nattointf OWNER TO postgres;

--
-- TOC entry 261 (class 1255 OID 620327)
-- Dependencies: 809 1057 6
-- Name: view_nattointf_retrieve(integer, integer, timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_nattointf_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) RETURNS SETOF nattointf
    LANGUAGE plpgsql
    AS $$
declare
	r nattointf%rowtype;
	t timestamp without time zone;
BEGIN		
	select modifytime into t from objtimestamp where typename=stypename;
	if t is null or t>dt then
		if imax <0 then
			for r in SELECT * FROM nattointf where id>ibegin order by id  loop
			return next r;
			end loop;
		else
			for r in SELECT * FROM nattointf where id>ibegin order by id limit imax loop
			return next r;
			end loop;

		end if;	
	End IF;		
END;

  $$;


ALTER FUNCTION public.view_nattointf_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) OWNER TO postgres;

--
-- TOC entry 2350 (class 1259 OID 620328)
-- Dependencies: 3028 6
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
-- TOC entry 3835 (class 0 OID 0)
-- Dependencies: 2350
-- Name: COLUMN nat.itype; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN nat.itype IS '1-static 2-dynamic';


--
-- TOC entry 2351 (class 1259 OID 620335)
-- Dependencies: 6
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
-- TOC entry 2352 (class 1259 OID 620338)
-- Dependencies: 2650 6
-- Name: nattointfview; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW nattointfview AS
    SELECT nattointf.id, (SELECT nat.insideglobal FROM nat WHERE (nat.id = nattointf.natid)) AS insideglobal, (SELECT nat.insidelocal FROM nat WHERE (nat.id = nattointf.natid)) AS insidelocal, (SELECT nat.outsideglobal FROM nat WHERE (nat.id = nattointf.natid)) AS outsideglobal, (SELECT nat.outsidelocal FROM nat WHERE (nat.id = nattointf.natid)) AS outsidelocal, (SELECT devices.strname FROM devices WHERE (devices.id = (SELECT nat.deviceid FROM nat WHERE (nat.id = nattointf.natid)))) AS devicename, (SELECT interfacesetting.interfacename FROM interfacesetting WHERE (interfacesetting.id = (SELECT natinterface.inintfid FROM natinterface WHERE (natinterface.id = nattointf.natintfid)))) AS ininfname, (SELECT interfacesetting.interfacename FROM interfacesetting WHERE (interfacesetting.id = (SELECT natinterface.outintfid FROM natinterface WHERE (natinterface.id = nattointf.natintfid)))) AS outinfname, (SELECT nat.itype FROM nat WHERE (nat.id = nattointf.natid)) AS itype FROM nattointf;


ALTER TABLE public.nattointfview OWNER TO postgres;

--
-- TOC entry 262 (class 1255 OID 620343)
-- Dependencies: 1057 816 6
-- Name: view_nattointf_view_retrieve(integer, integer, timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_nattointf_view_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) RETURNS SETOF nattointfview
    LANGUAGE plpgsql
    AS $$
declare
	r nattointfview%rowtype;
	t timestamp without time zone;
BEGIN		
	select modifytime into t from objtimestamp where typename=stypename;
	if t is null or t>dt then
		if imax <0 then
			for r in SELECT * FROM nattointfview where id>ibegin order by id  loop
			return next r;
			end loop;
		else
			for r in SELECT * FROM nattointfview where id>ibegin order by id limit imax loop
			return next r;
			end loop;

		end if;	
	End IF;		
END;

  $$;


ALTER FUNCTION public.view_nattointf_view_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) OWNER TO postgres;

--
-- TOC entry 2353 (class 1259 OID 620344)
-- Dependencies: 6
-- Name: nd; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE nd (
    id integer NOT NULL,
    hostnameexpression character varying(256),
    isregularexpression boolean,
    ipranges character varying(256),
    devicetype integer,
    driverid character varying(128)
);


ALTER TABLE public.nd OWNER TO postgres;

--
-- TOC entry 263 (class 1255 OID 620347)
-- Dependencies: 818 6 1057
-- Name: view_nd(integer, integer, timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_nd(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) RETURNS SETOF nd
    LANGUAGE plpgsql
    AS $$
declare
	r nd%rowtype;
	t timestamp without time zone;
BEGIN
	select modifytime into t from objtimestamp where typename=stypename;
	
	if t is null or t>dt then
		if imax <0 then
			for r in SELECT * FROM nd where id>ibegin order by id loop
			return next r;
			end loop;
		else
			for r in SELECT * FROM nd where id>ibegin order by id limit imax loop
			return next r;
			end loop;

		end if;	
	end if;	
END;

  $$;


ALTER FUNCTION public.view_nd(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) OWNER TO postgres;

--
-- TOC entry 2354 (class 1259 OID 620348)
-- Dependencies: 2651 6
-- Name: nomp_applianceview; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW nomp_applianceview AS
    SELECT nomp_appliance.id, nomp_appliance.strhostname, nomp_appliance.strdescription, nomp_appliance.stripaddr, nomp_appliance.iserveport, nomp_appliance.bhome, nomp_appliance.blive, nomp_appliance.bmodified, nomp_appliance.imaxdevicecount, nomp_appliance.ibapport, nomp_appliance.ipri, nomp_appliance.telnet_user, nomp_appliance.telnet_pwd, (SELECT count(*) AS count FROM devicesetting WHERE (devicesetting.appliceid = nomp_appliance.id)) AS irefcount FROM nomp_appliance ORDER BY nomp_appliance.ipri;


ALTER TABLE public.nomp_applianceview OWNER TO postgres;

--
-- TOC entry 264 (class 1255 OID 620353)
-- Dependencies: 820 1057 6
-- Name: view_nomp_appliance_retrieve(timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_nomp_appliance_retrieve(dt timestamp without time zone, stypename character varying) RETURNS SETOF nomp_applianceview
    LANGUAGE plpgsql
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

  $$;


ALTER FUNCTION public.view_nomp_appliance_retrieve(dt timestamp without time zone, stypename character varying) OWNER TO postgres;

--
-- TOC entry 2355 (class 1259 OID 620354)
-- Dependencies: 6
-- Name: nomp_enablepasswd_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE nomp_enablepasswd_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.nomp_enablepasswd_id_seq OWNER TO postgres;

--
-- TOC entry 3836 (class 0 OID 0)
-- Dependencies: 2355
-- Name: nomp_enablepasswd_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('nomp_enablepasswd_id_seq', 1, true);


--
-- TOC entry 2356 (class 1259 OID 620356)
-- Dependencies: 3031 6
-- Name: nomp_enablepasswd; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE nomp_enablepasswd (
    id integer DEFAULT nextval('nomp_enablepasswd_id_seq'::regclass) NOT NULL,
    stralias character varying(32) NOT NULL,
    strenablepasswd text NOT NULL,
    bmodified integer,
    ipri integer NOT NULL,
    strenableusername character varying(255)
);


ALTER TABLE public.nomp_enablepasswd OWNER TO postgres;

--
-- TOC entry 2357 (class 1259 OID 620363)
-- Dependencies: 2652 6
-- Name: nomp_enablepasswdview; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW nomp_enablepasswdview AS
    SELECT nomp_enablepasswd.id, nomp_enablepasswd.stralias, nomp_enablepasswd.strenablepasswd, nomp_enablepasswd.bmodified, nomp_enablepasswd.ipri, nomp_enablepasswd.strenableusername, (SELECT count(*) AS count FROM devicesetting WHERE (devicesetting.enablepassword = nomp_enablepasswd.strenablepasswd)) AS irefcount FROM nomp_enablepasswd ORDER BY nomp_enablepasswd.ipri;


ALTER TABLE public.nomp_enablepasswdview OWNER TO postgres;

--
-- TOC entry 249 (class 1255 OID 620367)
-- Dependencies: 6 1057 826
-- Name: view_nomp_enablepasswd_retrieve(timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_nomp_enablepasswd_retrieve(dt timestamp without time zone, stypename character varying) RETURNS SETOF nomp_enablepasswdview
    LANGUAGE plpgsql
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

  $$;


ALTER FUNCTION public.view_nomp_enablepasswd_retrieve(dt timestamp without time zone, stypename character varying) OWNER TO postgres;

--
-- TOC entry 2358 (class 1259 OID 620368)
-- Dependencies: 6
-- Name: nomp_jumpbox_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE nomp_jumpbox_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.nomp_jumpbox_id_seq OWNER TO postgres;

--
-- TOC entry 3837 (class 0 OID 0)
-- Dependencies: 2358
-- Name: nomp_jumpbox_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('nomp_jumpbox_id_seq', 1, true);


--
-- TOC entry 2359 (class 1259 OID 620370)
-- Dependencies: 3032 3033 6
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
    ipri integer NOT NULL,
    userid integer DEFAULT (-1) NOT NULL,
    licguid character varying(128)
);


ALTER TABLE public.nomp_jumpbox OWNER TO postgres;

--
-- TOC entry 2360 (class 1259 OID 620378)
-- Dependencies: 2653 6
-- Name: nomp_jumpboxview; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW nomp_jumpboxview AS
    SELECT nomp_jumpbox.id, nomp_jumpbox.strname, nomp_jumpbox.itype, nomp_jumpbox.stripaddr, nomp_jumpbox.iport, nomp_jumpbox.imode, nomp_jumpbox.strusername, nomp_jumpbox.strpasswd, nomp_jumpbox.strloginprompt, nomp_jumpbox.strpasswdprompt, nomp_jumpbox.strcommandprompt, nomp_jumpbox.stryesnoprompt, nomp_jumpbox.bmodified, nomp_jumpbox.strenablecmd, nomp_jumpbox.strenablepasswordprompt, nomp_jumpbox.strenablepassword, nomp_jumpbox.strenableprompt, nomp_jumpbox.ipri, nomp_jumpbox.userid, (SELECT count(*) AS count FROM devicesetting WHERE (devicesetting.telnetproxyid = nomp_jumpbox.id)) AS irefcount, nomp_jumpbox.licguid FROM nomp_jumpbox ORDER BY nomp_jumpbox.ipri;


ALTER TABLE public.nomp_jumpboxview OWNER TO postgres;

--
-- TOC entry 265 (class 1255 OID 620383)
-- Dependencies: 1057 6 832
-- Name: view_nomp_jumpbox_retrieve(timestamp without time zone, character varying, integer[], character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_nomp_jumpbox_retrieve(dt timestamp without time zone, stypename character varying, ids integer[], sguid character varying) RETURNS SETOF nomp_jumpboxview
    LANGUAGE plpgsql
    AS $$
declare
	r nomp_jumpboxview%rowtype;
	t timestamp without time zone;
BEGIN		
        select modifytime into t from objtimestamp where typename=stypename;
	if t is null or t>dt then
		for r in SELECT * FROM nomp_jumpboxview where userid = any(ids) and licguid=sguid loop
		return next r;
		end loop;	
	End IF;
END;

  $$;


ALTER FUNCTION public.view_nomp_jumpbox_retrieve(dt timestamp without time zone, stypename character varying, ids integer[], sguid character varying) OWNER TO postgres;

--
-- TOC entry 2361 (class 1259 OID 620384)
-- Dependencies: 6
-- Name: nomp_snmproinfo_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE nomp_snmproinfo_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.nomp_snmproinfo_id_seq OWNER TO postgres;

--
-- TOC entry 3838 (class 0 OID 0)
-- Dependencies: 2361
-- Name: nomp_snmproinfo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('nomp_snmproinfo_id_seq', 1, true);


--
-- TOC entry 2362 (class 1259 OID 620386)
-- Dependencies: 3034 3035 3036 3037 3038 6
-- Name: nomp_snmproinfo; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE nomp_snmproinfo (
    id integer DEFAULT nextval('nomp_snmproinfo_id_seq'::regclass) NOT NULL,
    strrostring text NOT NULL,
    bmodified integer,
    ipri integer NOT NULL,
    stralias character varying(255),
    authentication_method integer DEFAULT 0 NOT NULL,
    encryption_method integer DEFAULT 0 NOT NULL,
    authentication_mode integer DEFAULT 0 NOT NULL,
    snmpv3_username character varying(256),
    snmpv3_authentication character varying(256),
    snmpv3_encryption character varying(256),
    version integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.nomp_snmproinfo OWNER TO postgres;

--
-- TOC entry 2363 (class 1259 OID 620397)
-- Dependencies: 2654 6
-- Name: nomp_snmproinfoview; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW nomp_snmproinfoview AS
    SELECT nomp_snmproinfo.id, nomp_snmproinfo.strrostring, nomp_snmproinfo.bmodified, nomp_snmproinfo.ipri, nomp_snmproinfo.stralias, nomp_snmproinfo.authentication_method, nomp_snmproinfo.encryption_method, nomp_snmproinfo.authentication_mode, nomp_snmproinfo.snmpv3_username, nomp_snmproinfo.snmpv3_authentication, nomp_snmproinfo.snmpv3_encryption, nomp_snmproinfo.version, (SELECT count(*) AS count FROM devicesetting WHERE (devicesetting.snmpro = nomp_snmproinfo.strrostring)) AS irefcount FROM nomp_snmproinfo ORDER BY nomp_snmproinfo.ipri;


ALTER TABLE public.nomp_snmproinfoview OWNER TO postgres;

--
-- TOC entry 266 (class 1255 OID 620402)
-- Dependencies: 1057 838 6
-- Name: view_nomp_snmproinfo_retrieve(timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_nomp_snmproinfo_retrieve(dt timestamp without time zone, stypename character varying) RETURNS SETOF nomp_snmproinfoview
    LANGUAGE plpgsql
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

  $$;


ALTER FUNCTION public.view_nomp_snmproinfo_retrieve(dt timestamp without time zone, stypename character varying) OWNER TO postgres;

--
-- TOC entry 2364 (class 1259 OID 620403)
-- Dependencies: 6
-- Name: nomp_telnetinfo_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE nomp_telnetinfo_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.nomp_telnetinfo_id_seq OWNER TO postgres;

--
-- TOC entry 3839 (class 0 OID 0)
-- Dependencies: 2364
-- Name: nomp_telnetinfo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('nomp_telnetinfo_id_seq', 1, true);


--
-- TOC entry 2365 (class 1259 OID 620405)
-- Dependencies: 3039 6
-- Name: nomp_telnetinfo; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE nomp_telnetinfo (
    id integer DEFAULT nextval('nomp_telnetinfo_id_seq'::regclass) NOT NULL,
    stralias character varying(32) NOT NULL,
    idevicetype integer,
    strusername character varying(256),
    strpasswd character varying(256) NOT NULL,
    bmodified integer,
    userid integer,
    ipri integer NOT NULL,
    licguid character varying(128)
);


ALTER TABLE public.nomp_telnetinfo OWNER TO postgres;

--
-- TOC entry 2366 (class 1259 OID 620409)
-- Dependencies: 2655 6
-- Name: nomp_telnetinfoview; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW nomp_telnetinfoview AS
    SELECT nomp_telnetinfo.id, nomp_telnetinfo.stralias, nomp_telnetinfo.idevicetype, nomp_telnetinfo.strusername, nomp_telnetinfo.strpasswd, nomp_telnetinfo.bmodified, nomp_telnetinfo.userid, nomp_telnetinfo.ipri, nomp_telnetinfo.id AS irefcount, nomp_telnetinfo.licguid FROM nomp_telnetinfo ORDER BY nomp_telnetinfo.ipri;


ALTER TABLE public.nomp_telnetinfoview OWNER TO postgres;

--
-- TOC entry 267 (class 1255 OID 620413)
-- Dependencies: 1057 843 6
-- Name: view_nomp_telnetinfo_retrieve(timestamp without time zone, character varying, integer, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_nomp_telnetinfo_retrieve(dt timestamp without time zone, stypename character varying, uid integer, funcname character varying, sguid character varying) RETURNS SETOF nomp_telnetinfoview
    LANGUAGE plpgsql
    AS $$
declare
	r nomp_telnetinfoview%rowtype;
	t timestamp without time zone;
	ispublic integer;
BEGIN
	select 0 into  ispublic;		
	--select c.count into ispublic from (select count(a.id) as count from (select user2role.roleid as id from "user",user2role where "user".id=uid and "user".id =user2role.userid) as a where a.id in (select role2function.roleid as id from role2function,"function" where "function".sidname=funcname and "function".id=role2function.functionid)) as c;
  select modifytime into t from objtimestamp where typename=stypename;
	if t is null or t>dt then
		for r in SELECT * FROM nomp_telnetinfoview where userid=uid and licguid=sguid loop
			if ispublic>0 then 
				select a.count into r.iRefCount from (select count(id) as count from devicesetting where username=r.STRuseRnaMe and UserPassword=r.STRpAssWD) as a;								
			else
				select a.count into r.iRefCount from (select count(id) as count from userdevicesetting where TeLNetUserName=r.STRuseRnaMe and TeLNetPwD=r.STRpAssWD) as a;								
			end if;			
			return next r;
		end loop;	
	End IF;
END;

  $$;


ALTER FUNCTION public.view_nomp_telnetinfo_retrieve(dt timestamp without time zone, stypename character varying, uid integer, funcname character varying, sguid character varying) OWNER TO postgres;

--
-- TOC entry 268 (class 1255 OID 620414)
-- Dependencies: 1057 6 666
-- Name: view_object_file_info_retrieve(integer[], integer, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_object_file_info_retrieve(objectids integer[], objecttypeid integer, dt timestamp without time zone) RETURNS SETOF object_file_info
    LANGUAGE plpgsql
    AS $$
declare
	r object_file_info%rowtype;	
BEGIN	
	for r in SELECT * FROM object_file_info where object_id=any(objectids) and object_type=objecttypeid  and lasttimestamp>dt loop
		return next r;
	end loop;		
END;

  $$;


ALTER FUNCTION public.view_object_file_info_retrieve(objectids integer[], objecttypeid integer, dt timestamp without time zone) OWNER TO postgres;

--
-- TOC entry 269 (class 1255 OID 620415)
-- Dependencies: 669 1057 6
-- Name: view_ouinfo(integer, integer, timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_ouinfo(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) RETURNS SETOF ouinfo
    LANGUAGE plpgsql
    AS $$
declare
	r ouinfo%rowtype;
	t timestamp without time zone;
BEGIN
	select modifytime into t from objtimestamp where typename=stypename;
	
	if t is null or t>dt then
		if imax <0 then
			for r in SELECT * FROM ouinfo where id>ibegin order by id loop
			return next r;
			end loop;
		else
			for r in SELECT * FROM ouinfo where id>ibegin order by id limit imax loop
			return next r;
			end loop;

		end if;	
	end if;	
END;

  $$;


ALTER FUNCTION public.view_ouinfo(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) OWNER TO postgres;

--
-- TOC entry 2367 (class 1259 OID 620416)
-- Dependencies: 3041 6
-- Name: showcommandtemplate; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE showcommandtemplate (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    commands text,
    userid integer NOT NULL,
    lasttimestamp timestamp without time zone DEFAULT now() NOT NULL,
    licguid character varying(128)
);


ALTER TABLE public.showcommandtemplate OWNER TO postgres;

--
-- TOC entry 270 (class 1255 OID 620423)
-- Dependencies: 1057 6 845
-- Name: view_showcommandtemplate_retrieve(integer, integer, timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_showcommandtemplate_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) RETURNS SETOF showcommandtemplate
    LANGUAGE plpgsql
    AS $$
declare	
	r showcommandtemplate%rowtype;
	t timestamp without time zone;
BEGIN
	select modifytime into t from objtimestamp where typename=stypename;
	
	if t is null or t>dt then
		if imax <0 then
			for r in  select * from showcommandtemplate where id >ibegin order by id loop				
				return next r;								
			end loop;
		else
			for r in select * from showcommandtemplate where id >ibegin order by id limit imax loop				
				return next r;				
			end loop;

		end if;	
	end if;	
END;

  $$;


ALTER FUNCTION public.view_showcommandtemplate_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) OWNER TO postgres;

--
-- TOC entry 271 (class 1255 OID 620424)
-- Dependencies: 677 1057 6
-- Name: view_site_customized_info_retrieve(integer, integer, timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_site_customized_info_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) RETURNS SETOF site_customized_infoview
    LANGUAGE plpgsql
    AS $$
declare
	r site_customized_infoview%rowtype;
	t timestamp without time zone;
BEGIN
	select modifytime into t from objtimestamp where typename=stypename;
	
	if t is null or t>dt then
		if imax <0 then
			for r in SELECT * FROM site_customized_infoview where id>ibegin and lasttimestamp>dt order by id loop
			return next r;
			end loop;
		else
			for r in SELECT * FROM site_customized_infoview where id>ibegin and lasttimestamp>dt order by id limit imax loop
			return next r;
			end loop;

		end if;	
	end if;	
END;

  $$;


ALTER FUNCTION public.view_site_customized_info_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) OWNER TO postgres;

--
-- TOC entry 2368 (class 1259 OID 620425)
-- Dependencies: 6
-- Name: site2site; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE site2site (
    id integer NOT NULL,
    siteid integer,
    parentid integer
);


ALTER TABLE public.site2site OWNER TO postgres;

--
-- TOC entry 2369 (class 1259 OID 620428)
-- Dependencies: 2656 6
-- Name: siteview; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW siteview AS
    SELECT site.id, site2site.parentid, site.name, site.region, site.location_address, site.employee_number, site.contact_name, site.phone_number, site.email, site.type, site.color, site.comment, site.lasttimestamp, (SELECT count(*) AS count FROM devicesitedeviceview WHERE (devicesitedeviceview.siteid = site.id)) AS irefcount FROM site2site, site WHERE (site2site.siteid = site.id);


ALTER TABLE public.siteview OWNER TO postgres;

--
-- TOC entry 272 (class 1255 OID 620432)
-- Dependencies: 1057 850 6
-- Name: view_site_retrieve(integer, integer, timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_site_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) RETURNS SETOF siteview
    LANGUAGE plpgsql
    AS $$
declare
	r siteview%rowtype;
	t timestamp without time zone;
BEGIN
	select modifytime into t from objtimestamp where typename=stypename;
	
	if t is null or t>dt then
		if imax <0 then
			for r in SELECT * FROM siteview where id>ibegin order by id loop
			return next r;
			end loop;
		else
			for r in SELECT * FROM siteview where id>ibegin order by id limit imax loop
			return next r;
			end loop;

		end if;	
	end if;	
END;

  $$;


ALTER FUNCTION public.view_site_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) OWNER TO postgres;

--
-- TOC entry 2370 (class 1259 OID 620433)
-- Dependencies: 3044 6
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
-- TOC entry 2371 (class 1259 OID 620437)
-- Dependencies: 6
-- Name: swtichgroupdevice; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE swtichgroupdevice (
    switchgroupid integer NOT NULL,
    deviceid integer NOT NULL,
    id integer NOT NULL
);


ALTER TABLE public.swtichgroupdevice OWNER TO postgres;

--
-- TOC entry 2372 (class 1259 OID 620440)
-- Dependencies: 2657 6
-- Name: switchgroupview; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW switchgroupview AS
    SELECT switchgroup.id, switchgroup.strname, switchgroup.description, switchgroup.showcolor, (SELECT count(*) AS count FROM swtichgroupdevice WHERE (swtichgroupdevice.switchgroupid = switchgroup.id)) AS irefcount FROM switchgroup ORDER BY switchgroup.id;


ALTER TABLE public.switchgroupview OWNER TO postgres;

--
-- TOC entry 273 (class 1255 OID 620444)
-- Dependencies: 856 1057 6
-- Name: view_switchgroup_retrieve(integer, integer, timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_switchgroup_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) RETURNS SETOF switchgroupview
    LANGUAGE plpgsql
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

  $$;


ALTER FUNCTION public.view_switchgroup_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) OWNER TO postgres;

--
-- TOC entry 2373 (class 1259 OID 620445)
-- Dependencies: 2658 6
-- Name: swtichgroupdeviceview; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW swtichgroupdeviceview AS
    SELECT swtichgroupdevice.switchgroupid, swtichgroupdevice.deviceid, swtichgroupdevice.id, (SELECT devices.strname FROM devices WHERE (devices.id = swtichgroupdevice.deviceid)) AS devicename, (SELECT switchgroup.strname FROM switchgroup WHERE (switchgroup.id = swtichgroupdevice.switchgroupid)) AS swtichdevicegroupname, (SELECT devices.isubtype FROM devices WHERE (devices.id = swtichgroupdevice.deviceid)) AS isubtype FROM swtichgroupdevice;


ALTER TABLE public.swtichgroupdeviceview OWNER TO postgres;

--
-- TOC entry 274 (class 1255 OID 620449)
-- Dependencies: 6 858 1057
-- Name: view_swtichgroupdevice_retrieve(integer, integer, timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_swtichgroupdevice_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) RETURNS SETOF swtichgroupdeviceview
    LANGUAGE plpgsql
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

  $$;


ALTER FUNCTION public.view_swtichgroupdevice_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) OWNER TO postgres;

--
-- TOC entry 2374 (class 1259 OID 620450)
-- Dependencies: 3047 6
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
-- TOC entry 2375 (class 1259 OID 620454)
-- Dependencies: 2659 6
-- Name: systemdevicegroupview; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW systemdevicegroupview AS
    SELECT systemdevicegroup.id, systemdevicegroup.strname, systemdevicegroup.strdesc, systemdevicegroup.showcolor, systemdevicegroup.lasttimestamp, (SELECT count(*) AS count FROM systemdevicegroupdevice WHERE (systemdevicegroupdevice.systemdevicegroupid = systemdevicegroup.id)) AS irefcount FROM systemdevicegroup ORDER BY systemdevicegroup.id;


ALTER TABLE public.systemdevicegroupview OWNER TO postgres;

--
-- TOC entry 275 (class 1255 OID 620458)
-- Dependencies: 6 1057 862
-- Name: view_systemdevicegroup_retrieve(integer, integer, timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_systemdevicegroup_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) RETURNS SETOF systemdevicegroupview
    LANGUAGE plpgsql
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

  $$;


ALTER FUNCTION public.view_systemdevicegroup_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) OWNER TO postgres;

--
-- TOC entry 2376 (class 1259 OID 620459)
-- Dependencies: 2660 6
-- Name: systemdevicegroupdeviceview; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW systemdevicegroupdeviceview AS
    SELECT systemdevicegroupdevice.systemdevicegroupid, systemdevicegroupdevice.deviceid, systemdevicegroupdevice.id, systemdevicegroupdevice.lasttimestamp, (SELECT devices.strname FROM devices WHERE (devices.id = systemdevicegroupdevice.deviceid)) AS devicename, (SELECT systemdevicegroup.strname FROM systemdevicegroup WHERE (systemdevicegroup.id = systemdevicegroupdevice.systemdevicegroupid)) AS systemdevicegroupname, (SELECT devices.isubtype FROM devices WHERE (devices.id = systemdevicegroupdevice.deviceid)) AS isubtype FROM systemdevicegroupdevice;


ALTER TABLE public.systemdevicegroupdeviceview OWNER TO postgres;

--
-- TOC entry 276 (class 1255 OID 620463)
-- Dependencies: 6 864 1057
-- Name: view_systemdevicegroupdevice_retrieve(integer, integer, timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_systemdevicegroupdevice_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) RETURNS SETOF systemdevicegroupdeviceview
    LANGUAGE plpgsql
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

  $$;


ALTER FUNCTION public.view_systemdevicegroupdevice_retrieve(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) OWNER TO postgres;

--
-- TOC entry 277 (class 1255 OID 620464)
-- Dependencies: 1057 687 6
-- Name: view_transport_protocol_port(integer, integer, timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_transport_protocol_port(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) RETURNS SETOF transport_protocol_port
    LANGUAGE plpgsql
    AS $$
declare
	r transport_protocol_port%rowtype;
	t timestamp without time zone;
BEGIN
	select modifytime into t from objtimestamp where typename=stypename;
	
	if t is null or t>dt then
		if imax <0 then
			for r in SELECT * FROM transport_protocol_port where id>ibegin order by id loop
			return next r;
			end loop;
		else
			for r in SELECT * FROM transport_protocol_port where id>ibegin order by id limit imax loop
			return next r;
			end loop;

		end if;	
	end if;	
END;

  $$;


ALTER FUNCTION public.view_transport_protocol_port(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) OWNER TO postgres;

--
-- TOC entry 278 (class 1255 OID 620465)
-- Dependencies: 627 6 1057
-- Name: view_unknownip(integer, integer, timestamp without time zone, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_unknownip(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) RETURNS SETOF unknownip
    LANGUAGE plpgsql
    AS $$
declare
	r unknownip%rowtype;
	t timestamp without time zone;
BEGIN
	select modifytime into t from objtimestamp where typename=stypename;
	
	if t is null or t>dt then
		if imax <0 then
			for r in SELECT * FROM unknownip where id>ibegin order by id loop
			return next r;
			end loop;
		else
			for r in SELECT * FROM unknownip where id>ibegin order by id limit imax loop
			return next r;
			end loop;

		end if;	
	end if;	
END;

  $$;


ALTER FUNCTION public.view_unknownip(ibegin integer, imax integer, dt timestamp without time zone, stypename character varying) OWNER TO postgres;

--
-- TOC entry 2377 (class 1259 OID 620466)
-- Dependencies: 2661 6
-- Name: userdevicesettingview; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW userdevicesettingview AS
    SELECT userdevicesetting.id, userdevicesetting.deviceid, userdevicesetting.userid, userdevicesetting.managerip, userdevicesetting.telnetusername, userdevicesetting.telnetpwd, userdevicesetting.dtstamp, userdevicesetting.jumpboxid, devices.strname AS devicename, userdevicesetting.licguid FROM userdevicesetting, devices WHERE (devices.id = userdevicesetting.deviceid);


ALTER TABLE public.userdevicesettingview OWNER TO postgres;

--
-- TOC entry 279 (class 1255 OID 620470)
-- Dependencies: 6 1057 866
-- Name: view_userdevicesetting_retrieve(integer, integer, timestamp without time zone, integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION view_userdevicesetting_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer, sguid character varying) RETURNS SETOF userdevicesettingview
    LANGUAGE plpgsql
    AS $$
declare
	r userdevicesettingview%rowtype;
BEGIN
	if imax <0 then
		for r in SELECT * FROM userdevicesettingview where id>ibegin and userid=uid and licguid=sguid AND dtstamp>dt order by id loop
		return next r;
		end loop;
	else
		for r in SELECT * FROM userdevicesettingview where id>ibegin and userid=uid AND licguid=sguid and dtstamp>dt order by id limit imax loop
		return next r;
		end loop;

	end if;
END;

  $$;


ALTER FUNCTION public.view_userdevicesetting_retrieve(ibegin integer, imax integer, dt timestamp without time zone, uid integer, sguid character varying) OWNER TO postgres;

--
-- TOC entry 280 (class 1255 OID 620471)
-- Dependencies: 6 1057
-- Name: workspace_reset(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION workspace_reset() RETURNS integer
    LANGUAGE plpgsql
    AS $$
declare
	r character varying(256);
	retsv character varying(256);
	indextempty integer;
BEGIN
	retsv='';
	indextempty=0;
	FOR r IN SELECT tablename FROM pg_tables WHERE tablename NOT LIKE 'pg%' AND tablename NOT LIKE 'sql_%' ORDER BY tablename LOOP
		EXECUTE 'select count(*) from' || r ;
		retsv=r;
		if retsv!='adminpwd' AND retsv!='benchmarktask' AND retsv!='function' AND retsv!='globeinfo'
			AND retsv!='objtimestamp' AND retsv!='role' AND retsv!='role2virtualfunction' AND retsv!='user' 
			AND retsv!='user2role' AND retsv!='virtualfunction' AND retsv!='virtualfunction2function' 
			AND retsv!='system_devicespec' AND retsv!='system_vendormodel'  AND retsv!='site' 
			AND retsv!='nomp_appliance' AND retsv!='site2site' AND retsv!='system_info' then
			execute 'delete from ' || r ||' CASCADE';
			execute 'truncate table ' || r||' CASCADE';			
			indextempty=indextempty +1;		
		end if;
	END LOOP;
	delete from site CASCADE where id>1;
	delete from site2site CASCADE where id>1;
	delete from nomp_appliance CASCADE where id>0;
	EXECUTE 'SELECT pg_catalog.setval(''devices_id_seq'', 1, true)';
	update objtimestamp set modifytime=now();
	delete from system_info CASCADE where id>1;
	--return sret;
	return indextempty;
End;
$$;


ALTER FUNCTION public.workspace_reset() OWNER TO postgres;

--
-- TOC entry 2378 (class 1259 OID 620472)
-- Dependencies: 6
-- Name: adminpwd; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE adminpwd (
    id integer NOT NULL,
    pwd character varying(256)
);


ALTER TABLE public.adminpwd OWNER TO postgres;

--
-- TOC entry 2379 (class 1259 OID 620475)
-- Dependencies: 2378 6
-- Name: adminpwd_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE adminpwd_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.adminpwd_id_seq OWNER TO postgres;

--
-- TOC entry 3840 (class 0 OID 0)
-- Dependencies: 2379
-- Name: adminpwd_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE adminpwd_id_seq OWNED BY adminpwd.id;


--
-- TOC entry 3841 (class 0 OID 0)
-- Dependencies: 2379
-- Name: adminpwd_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('adminpwd_id_seq', 1, true);


--
-- TOC entry 2380 (class 1259 OID 620477)
-- Dependencies: 6
-- Name: benchmarkfolder; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE benchmarkfolder (
    id integer NOT NULL,
    tdstamp time without time zone NOT NULL
);


ALTER TABLE public.benchmarkfolder OWNER TO postgres;

--
-- TOC entry 2381 (class 1259 OID 620480)
-- Dependencies: 6 2380
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
-- TOC entry 3842 (class 0 OID 0)
-- Dependencies: 2381
-- Name: benchmarkfolder_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE benchmarkfolder_id_seq OWNED BY benchmarkfolder.id;


--
-- TOC entry 3843 (class 0 OID 0)
-- Dependencies: 2381
-- Name: benchmarkfolder_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('benchmarkfolder_id_seq', 1, false);


--
-- TOC entry 2382 (class 1259 OID 620482)
-- Dependencies: 3050 3051 3052 3053 3054 3055 3056 3057 6
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
    lastruntime timestamp without time zone,
    defined_source integer DEFAULT 0 NOT NULL,
    stptable integer DEFAULT 1 NOT NULL,
    inventoryinfo integer DEFAULT 1 NOT NULL,    
    buildcontent integer DEFAULT 15 NOT NULL
);


ALTER TABLE public.benchmarktask OWNER TO postgres;

--
-- TOC entry 2383 (class 1259 OID 620493)
-- Dependencies: 6 2382
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
-- TOC entry 3844 (class 0 OID 0)
-- Dependencies: 2383
-- Name: benchmarktask_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE benchmarktask_id_seq OWNED BY benchmarktask.id;


--
-- TOC entry 3845 (class 0 OID 0)
-- Dependencies: 2383
-- Name: benchmarktask_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('benchmarktask_id_seq', 1, false);


--
-- TOC entry 2384 (class 1259 OID 620495)
-- Dependencies: 6
-- Name: benchmarktaskstatus; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE benchmarktaskstatus (
    id integer NOT NULL,
    taskid integer NOT NULL,
    runbegintime timestamp without time zone,
    runendtime timestamp without time zone,
    result integer,
    tasktype integer NOT NULL
);


ALTER TABLE public.benchmarktaskstatus OWNER TO postgres;

--
-- TOC entry 2385 (class 1259 OID 620498)
-- Dependencies: 2384 6
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
-- TOC entry 3846 (class 0 OID 0)
-- Dependencies: 2385
-- Name: benchmarktaskstatus_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE benchmarktaskstatus_id_seq OWNED BY benchmarktaskstatus.id;


--
-- TOC entry 3847 (class 0 OID 0)
-- Dependencies: 2385
-- Name: benchmarktaskstatus_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('benchmarktaskstatus_id_seq', 1, false);


--
-- TOC entry 2386 (class 1259 OID 620500)
-- Dependencies: 6
-- Name: benchmarktaskstatusstep; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE benchmarktaskstatusstep (
    id integer NOT NULL,
    statusid integer,
    steptype integer NOT NULL,
    begintime timestamp without time zone,
    endtime timestamp without time zone,
    result integer
);


ALTER TABLE public.benchmarktaskstatusstep OWNER TO postgres;

--
-- TOC entry 2387 (class 1259 OID 620503)
-- Dependencies: 2386 6
-- Name: benchmarktaskstatusstep_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE benchmarktaskstatusstep_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.benchmarktaskstatusstep_id_seq OWNER TO postgres;

--
-- TOC entry 3848 (class 0 OID 0)
-- Dependencies: 2387
-- Name: benchmarktaskstatusstep_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE benchmarktaskstatusstep_id_seq OWNED BY benchmarktaskstatusstep.id;


--
-- TOC entry 3849 (class 0 OID 0)
-- Dependencies: 2387
-- Name: benchmarktaskstatusstep_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('benchmarktaskstatusstep_id_seq', 1, false);


--
-- TOC entry 2388 (class 1259 OID 620505)
-- Dependencies: 3061 3062 6
-- Name: benchmarktaskstatussteplog; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE benchmarktaskstatussteplog (
    id integer NOT NULL,
    stepid integer NOT NULL,
    loglevel integer DEFAULT 0 NOT NULL,
    strlog text,
    stamp timestamp without time zone DEFAULT now()
);


ALTER TABLE public.benchmarktaskstatussteplog OWNER TO postgres;

--
-- TOC entry 2389 (class 1259 OID 620513)
-- Dependencies: 2388 6
-- Name: benchmarktaskstatussteplog_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE benchmarktaskstatussteplog_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.benchmarktaskstatussteplog_id_seq OWNER TO postgres;

--
-- TOC entry 3850 (class 0 OID 0)
-- Dependencies: 2389
-- Name: benchmarktaskstatussteplog_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE benchmarktaskstatussteplog_id_seq OWNED BY benchmarktaskstatussteplog.id;


--
-- TOC entry 3851 (class 0 OID 0)
-- Dependencies: 2389
-- Name: benchmarktaskstatussteplog_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('benchmarktaskstatussteplog_id_seq', 1, false);


--
-- TOC entry 2390 (class 1259 OID 620515)
-- Dependencies: 2293 6
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
-- TOC entry 3852 (class 0 OID 0)
-- Dependencies: 2390
-- Name: bgpneighbor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE bgpneighbor_id_seq OWNED BY bgpneighbor.id;


--
-- TOC entry 3853 (class 0 OID 0)
-- Dependencies: 2390
-- Name: bgpneighbor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('bgpneighbor_id_seq', 1, false);


--
-- TOC entry 2391 (class 1259 OID 620517)
-- Dependencies: 3064 3065 3066 6
-- Name: checkupdate; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE checkupdate (
    id integer NOT NULL,
    version integer NOT NULL,
    ini_filename character varying(64) NOT NULL,
    lasttimestamp timestamp without time zone DEFAULT now() NOT NULL,
    zip_filename character varying(64) NOT NULL,
    packageisexcuted boolean DEFAULT false NOT NULL,
    excutedstatus integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.checkupdate OWNER TO postgres;

--
-- TOC entry 2392 (class 1259 OID 620523)
-- Dependencies: 6 2391
-- Name: checkupdate_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE checkupdate_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.checkupdate_id_seq OWNER TO postgres;

--
-- TOC entry 3854 (class 0 OID 0)
-- Dependencies: 2392
-- Name: checkupdate_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE checkupdate_id_seq OWNED BY checkupdate.id;


--
-- TOC entry 3855 (class 0 OID 0)
-- Dependencies: 2392
-- Name: checkupdate_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('checkupdate_id_seq', 1, false);


--
-- TOC entry 2393 (class 1259 OID 620525)
-- Dependencies: 3068 3069 6
-- Name: datastoragesetting; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE datastoragesetting (
    id integer NOT NULL,
    kindname character varying(100) NOT NULL,
    ischeck boolean DEFAULT false NOT NULL,
    beforedays integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.datastoragesetting OWNER TO postgres;

--
-- TOC entry 2394 (class 1259 OID 620530)
-- Dependencies: 6 2393
-- Name: datastoragesetting_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE datastoragesetting_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.datastoragesetting_id_seq OWNER TO postgres;

--
-- TOC entry 3856 (class 0 OID 0)
-- Dependencies: 2394
-- Name: datastoragesetting_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE datastoragesetting_id_seq OWNED BY datastoragesetting.id;


--
-- TOC entry 3857 (class 0 OID 0)
-- Dependencies: 2394
-- Name: datastoragesetting_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('datastoragesetting_id_seq', 2, true);


--
-- TOC entry 2395 (class 1259 OID 620532)
-- Dependencies: 6
-- Name: device_config; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE device_config (
    deviceid integer NOT NULL,
    configfile text NOT NULL,
    dtstamp timestamp without time zone NOT NULL
);


ALTER TABLE public.device_config OWNER TO postgres;

--
-- TOC entry 2396 (class 1259 OID 620538)
-- Dependencies: 2249 6
-- Name: device_customized_info_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE device_customized_info_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.device_customized_info_id_seq OWNER TO postgres;

--
-- TOC entry 3858 (class 0 OID 0)
-- Dependencies: 2396
-- Name: device_customized_info_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE device_customized_info_id_seq OWNED BY device_customized_info.id;


--
-- TOC entry 3859 (class 0 OID 0)
-- Dependencies: 2396
-- Name: device_customized_info_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('device_customized_info_id_seq', 1, false);


--
-- TOC entry 2397 (class 1259 OID 620540)
-- Dependencies: 2304 6
-- Name: device_icon_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE device_icon_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.device_icon_id_seq OWNER TO postgres;

--
-- TOC entry 3860 (class 0 OID 0)
-- Dependencies: 2397
-- Name: device_icon_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE device_icon_id_seq OWNED BY device_icon.id;


--
-- TOC entry 3861 (class 0 OID 0)
-- Dependencies: 2397
-- Name: device_icon_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('device_icon_id_seq', 39, true);


--
-- TOC entry 2398 (class 1259 OID 620542)
-- Dependencies: 6
-- Name: device_maintype; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE device_maintype (
    maintype integer NOT NULL,
    strname character varying(512) NOT NULL
);


ALTER TABLE public.device_maintype OWNER TO postgres;

--
-- TOC entry 2399 (class 1259 OID 620545)
-- Dependencies: 2250 6
-- Name: device_property_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE device_property_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.device_property_id_seq OWNER TO postgres;

--
-- TOC entry 3862 (class 0 OID 0)
-- Dependencies: 2399
-- Name: device_property_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE device_property_id_seq OWNED BY device_property.id;


--
-- TOC entry 3863 (class 0 OID 0)
-- Dependencies: 2399
-- Name: device_property_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('device_property_id_seq', 1, false);


--
-- TOC entry 2400 (class 1259 OID 620547)
-- Dependencies: 3071 6
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
-- TOC entry 2401 (class 1259 OID 620551)
-- Dependencies: 6 2400
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
-- TOC entry 3864 (class 0 OID 0)
-- Dependencies: 2401
-- Name: device_subtype_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE device_subtype_id_seq OWNED BY device_subtype.id;


--
-- TOC entry 3865 (class 0 OID 0)
-- Dependencies: 2401
-- Name: device_subtype_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('device_subtype_id_seq', 1, false);


--
-- TOC entry 2402 (class 1259 OID 620553)
-- Dependencies: 6 2246
-- Name: devicegroup_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE devicegroup_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.devicegroup_id_seq OWNER TO postgres;

--
-- TOC entry 3866 (class 0 OID 0)
-- Dependencies: 2402
-- Name: devicegroup_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE devicegroup_id_seq OWNED BY devicegroup.id;


--
-- TOC entry 3867 (class 0 OID 0)
-- Dependencies: 2402
-- Name: devicegroup_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('devicegroup_id_seq', 13, true);


--
-- TOC entry 2403 (class 1259 OID 620555)
-- Dependencies: 2247 6
-- Name: devicegroupdevice_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE devicegroupdevice_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.devicegroupdevice_id_seq OWNER TO postgres;

--
-- TOC entry 3868 (class 0 OID 0)
-- Dependencies: 2403
-- Name: devicegroupdevice_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE devicegroupdevice_id_seq OWNED BY devicegroupdevice.id;


--
-- TOC entry 3869 (class 0 OID 0)
-- Dependencies: 2403
-- Name: devicegroupdevice_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('devicegroupdevice_id_seq', 1, true);


--
-- TOC entry 2404 (class 1259 OID 620557)
-- Dependencies: 2297 6
-- Name: devicegroupdevicegroup_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE devicegroupdevicegroup_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.devicegroupdevicegroup_id_seq OWNER TO postgres;

--
-- TOC entry 3870 (class 0 OID 0)
-- Dependencies: 2404
-- Name: devicegroupdevicegroup_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE devicegroupdevicegroup_id_seq OWNED BY devicegroupdevicegroup.id;


--
-- TOC entry 3871 (class 0 OID 0)
-- Dependencies: 2404
-- Name: devicegroupdevicegroup_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('devicegroupdevicegroup_id_seq', 1, false);


--
-- TOC entry 2405 (class 1259 OID 620559)
-- Dependencies: 6 2299
-- Name: devicegroupsite_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE devicegroupsite_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.devicegroupsite_id_seq OWNER TO postgres;

--
-- TOC entry 3872 (class 0 OID 0)
-- Dependencies: 2405
-- Name: devicegroupsite_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE devicegroupsite_id_seq OWNED BY devicegroupsite.id;


--
-- TOC entry 3873 (class 0 OID 0)
-- Dependencies: 2405
-- Name: devicegroupsite_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('devicegroupsite_id_seq', 1, false);


--
-- TOC entry 2406 (class 1259 OID 620561)
-- Dependencies: 6 2301
-- Name: devicegroupsystemdevicegroup_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE devicegroupsystemdevicegroup_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.devicegroupsystemdevicegroup_id_seq OWNER TO postgres;

--
-- TOC entry 3874 (class 0 OID 0)
-- Dependencies: 2406
-- Name: devicegroupsystemdevicegroup_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE devicegroupsystemdevicegroup_id_seq OWNED BY devicegroupsystemdevicegroup.id;


--
-- TOC entry 3875 (class 0 OID 0)
-- Dependencies: 2406
-- Name: devicegroupsystemdevicegroup_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('devicegroupsystemdevicegroup_id_seq', 1, false);


--
-- TOC entry 2407 (class 1259 OID 620563)
-- Dependencies: 6 2307
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
-- TOC entry 3876 (class 0 OID 0)
-- Dependencies: 2407
-- Name: deviceprotocols_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE deviceprotocols_id_seq OWNED BY deviceprotocols.id;


--
-- TOC entry 3877 (class 0 OID 0)
-- Dependencies: 2407
-- Name: deviceprotocols_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('deviceprotocols_id_seq', 1, false);


--
-- TOC entry 2408 (class 1259 OID 620565)
-- Dependencies: 6 2253
-- Name: devicesetting_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE devicesetting_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.devicesetting_id_seq OWNER TO postgres;

--
-- TOC entry 3878 (class 0 OID 0)
-- Dependencies: 2408
-- Name: devicesetting_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE devicesetting_id_seq OWNED BY devicesetting.id;


--
-- TOC entry 3879 (class 0 OID 0)
-- Dependencies: 2408
-- Name: devicesetting_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('devicesetting_id_seq', 1, true);


--
-- TOC entry 2409 (class 1259 OID 620567)
-- Dependencies: 2309 6
-- Name: devicesitedevice_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE devicesitedevice_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.devicesitedevice_id_seq OWNER TO postgres;

--
-- TOC entry 3880 (class 0 OID 0)
-- Dependencies: 2409
-- Name: devicesitedevice_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE devicesitedevice_id_seq OWNED BY devicesitedevice.id;


--
-- TOC entry 3881 (class 0 OID 0)
-- Dependencies: 2409
-- Name: devicesitedevice_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('devicesitedevice_id_seq', 1, false);


--
-- TOC entry 2410 (class 1259 OID 620569)
-- Dependencies: 3074 6
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
-- TOC entry 2411 (class 1259 OID 620573)
-- Dependencies: 6 2410
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
-- TOC entry 3882 (class 0 OID 0)
-- Dependencies: 2411
-- Name: devicevpns_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE devicevpns_id_seq OWNED BY devicevpns.id;


--
-- TOC entry 3883 (class 0 OID 0)
-- Dependencies: 2411
-- Name: devicevpns_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('devicevpns_id_seq', 1, false);


SET default_with_oids = true;

--
-- TOC entry 2412 (class 1259 OID 620575)
-- Dependencies: 3076 6
-- Name: disableinterface; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE disableinterface (
    id integer NOT NULL,
    interfaceid integer NOT NULL,
    flag integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.disableinterface OWNER TO postgres;

--
-- TOC entry 2413 (class 1259 OID 620579)
-- Dependencies: 6 2412
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
-- TOC entry 3884 (class 0 OID 0)
-- Dependencies: 2413
-- Name: disableinterface_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE disableinterface_id_seq OWNED BY disableinterface.id;


--
-- TOC entry 3885 (class 0 OID 0)
-- Dependencies: 2413
-- Name: disableinterface_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('disableinterface_id_seq', 1, false);


--
-- TOC entry 2414 (class 1259 OID 620581)
-- Dependencies: 6
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
-- TOC entry 3886 (class 0 OID 0)
-- Dependencies: 2414
-- Name: discover_missdevice_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('discover_missdevice_id_seq', 5, false);


--
-- TOC entry 2415 (class 1259 OID 620583)
-- Dependencies: 2258 6
-- Name: discover_missdevice_id_seq1; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE discover_missdevice_id_seq1
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.discover_missdevice_id_seq1 OWNER TO postgres;

--
-- TOC entry 3887 (class 0 OID 0)
-- Dependencies: 2415
-- Name: discover_missdevice_id_seq1; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE discover_missdevice_id_seq1 OWNED BY discover_missdevice.id;


--
-- TOC entry 3888 (class 0 OID 0)
-- Dependencies: 2415
-- Name: discover_missdevice_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('discover_missdevice_id_seq1', 1, true);


--
-- TOC entry 2416 (class 1259 OID 620585)
-- Dependencies: 6
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
-- TOC entry 3889 (class 0 OID 0)
-- Dependencies: 2416
-- Name: discover_newdevice_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('discover_newdevice_id_seq', 1, false);


--
-- TOC entry 2417 (class 1259 OID 620587)
-- Dependencies: 2260 6
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
-- TOC entry 3890 (class 0 OID 0)
-- Dependencies: 2417
-- Name: discover_newdevice_id_seq1; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE discover_newdevice_id_seq1 OWNED BY discover_newdevice.id;


--
-- TOC entry 3891 (class 0 OID 0)
-- Dependencies: 2417
-- Name: discover_newdevice_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('discover_newdevice_id_seq1', 1, false);


SET default_with_oids = false;

--
-- TOC entry 2418 (class 1259 OID 620589)
-- Dependencies: 3077 3078 3079 6
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
    starttime timestamp without time zone,
    licguid character varying(128) NOT NULL
);


ALTER TABLE public.discover_schedule OWNER TO postgres;

--
-- TOC entry 2419 (class 1259 OID 620595)
-- Dependencies: 6
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
-- TOC entry 3892 (class 0 OID 0)
-- Dependencies: 2419
-- Name: discover_schedule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('discover_schedule_id_seq', 1, false);


--
-- TOC entry 2420 (class 1259 OID 620597)
-- Dependencies: 2418 6
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
-- TOC entry 3893 (class 0 OID 0)
-- Dependencies: 2420
-- Name: discover_schedule_id_seq1; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE discover_schedule_id_seq1 OWNED BY discover_schedule.id;


--
-- TOC entry 3894 (class 0 OID 0)
-- Dependencies: 2420
-- Name: discover_schedule_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('discover_schedule_id_seq1', 1, false);


--
-- TOC entry 2421 (class 1259 OID 620599)
-- Dependencies: 6
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
-- TOC entry 3895 (class 0 OID 0)
-- Dependencies: 2421
-- Name: discover_snmpdevice_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('discover_snmpdevice_id_seq', 1, false);


--
-- TOC entry 2422 (class 1259 OID 620601)
-- Dependencies: 2261 6
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
-- TOC entry 3896 (class 0 OID 0)
-- Dependencies: 2422
-- Name: discover_snmpdevice_id_seq1; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE discover_snmpdevice_id_seq1 OWNED BY discover_snmpdevice.id;


--
-- TOC entry 3897 (class 0 OID 0)
-- Dependencies: 2422
-- Name: discover_snmpdevice_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('discover_snmpdevice_id_seq1', 1, false);


--
-- TOC entry 2423 (class 1259 OID 620603)
-- Dependencies: 6
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
-- TOC entry 3898 (class 0 OID 0)
-- Dependencies: 2423
-- Name: discover_unknowdevice_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('discover_unknowdevice_id_seq', 1, false);


--
-- TOC entry 2424 (class 1259 OID 620605)
-- Dependencies: 6 2262
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
-- TOC entry 3899 (class 0 OID 0)
-- Dependencies: 2424
-- Name: discover_unknowdevice_id_seq1; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE discover_unknowdevice_id_seq1 OWNED BY discover_unknowdevice.id;


--
-- TOC entry 3900 (class 0 OID 0)
-- Dependencies: 2424
-- Name: discover_unknowdevice_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('discover_unknowdevice_id_seq1', 1, false);


--
-- TOC entry 2425 (class 1259 OID 620607)
-- Dependencies: 6
-- Name: domain_name; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE domain_name (
    id integer NOT NULL,
    str_name text NOT NULL
);


ALTER TABLE public.domain_name OWNER TO postgres;

--
-- TOC entry 2426 (class 1259 OID 620613)
-- Dependencies: 6 2425
-- Name: domain_name_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE domain_name_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.domain_name_id_seq OWNER TO postgres;

--
-- TOC entry 3901 (class 0 OID 0)
-- Dependencies: 2426
-- Name: domain_name_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE domain_name_id_seq OWNED BY domain_name.id;


--
-- TOC entry 3902 (class 0 OID 0)
-- Dependencies: 2426
-- Name: domain_name_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('domain_name_id_seq', 1, false);


--
-- TOC entry 2427 (class 1259 OID 620615)
-- Dependencies: 3083 6
-- Name: domain_option; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE domain_option (
    id integer NOT NULL,
    op_val integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.domain_option OWNER TO postgres;

--
-- TOC entry 2428 (class 1259 OID 620619)
-- Dependencies: 6 2427
-- Name: domain_option_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE domain_option_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.domain_option_id_seq OWNER TO postgres;

--
-- TOC entry 3903 (class 0 OID 0)
-- Dependencies: 2428
-- Name: domain_option_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE domain_option_id_seq OWNED BY domain_option.id;


--
-- TOC entry 3904 (class 0 OID 0)
-- Dependencies: 2428
-- Name: domain_option_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('domain_option_id_seq', 1, false);


--
-- TOC entry 2429 (class 1259 OID 620621)
-- Dependencies: 6 2315
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
-- TOC entry 3905 (class 0 OID 0)
-- Dependencies: 2429
-- Name: duplicateip_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE duplicateip_id_seq OWNED BY duplicateip.id;


--
-- TOC entry 3906 (class 0 OID 0)
-- Dependencies: 2429
-- Name: duplicateip_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('duplicateip_id_seq', 1, false);


--
-- TOC entry 2430 (class 1259 OID 620623)
-- Dependencies: 2317 6
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
-- TOC entry 3907 (class 0 OID 0)
-- Dependencies: 2430
-- Name: fixupnatinfo_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE fixupnatinfo_id_seq OWNED BY fixupnatinfo.id;


--
-- TOC entry 3908 (class 0 OID 0)
-- Dependencies: 2430
-- Name: fixupnatinfo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('fixupnatinfo_id_seq', 1, false);


--
-- TOC entry 2431 (class 1259 OID 620625)
-- Dependencies: 6 2317
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
-- TOC entry 3909 (class 0 OID 0)
-- Dependencies: 2431
-- Name: fixupnatinfo_ipri_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE fixupnatinfo_ipri_seq OWNED BY fixupnatinfo.ipri;


--
-- TOC entry 3910 (class 0 OID 0)
-- Dependencies: 2431
-- Name: fixupnatinfo_ipri_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('fixupnatinfo_ipri_seq', 1, false);


--
-- TOC entry 2432 (class 1259 OID 620627)
-- Dependencies: 2318 6
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
-- TOC entry 3911 (class 0 OID 0)
-- Dependencies: 2432
-- Name: fixuproutetable_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE fixuproutetable_id_seq OWNED BY fixuproutetable.id;


--
-- TOC entry 3912 (class 0 OID 0)
-- Dependencies: 2432
-- Name: fixuproutetable_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('fixuproutetable_id_seq', 1, false);


--
-- TOC entry 2433 (class 1259 OID 620629)
-- Dependencies: 2319 6
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
-- TOC entry 3913 (class 0 OID 0)
-- Dependencies: 2433
-- Name: fixuproutetablepriority_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE fixuproutetablepriority_id_seq OWNED BY fixuproutetablepriority.id;


--
-- TOC entry 3914 (class 0 OID 0)
-- Dependencies: 2433
-- Name: fixuproutetablepriority_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('fixuproutetablepriority_id_seq', 1, false);


--
-- TOC entry 2434 (class 1259 OID 620631)
-- Dependencies: 6 2320
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
-- TOC entry 3915 (class 0 OID 0)
-- Dependencies: 2434
-- Name: fixupunnumberedinterface_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE fixupunnumberedinterface_id_seq OWNED BY fixupunnumberedinterface.id;


--
-- TOC entry 3916 (class 0 OID 0)
-- Dependencies: 2434
-- Name: fixupunnumberedinterface_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('fixupunnumberedinterface_id_seq', 1, false);


--
-- TOC entry 2435 (class 1259 OID 620633)
-- Dependencies: 6
-- Name: globeinfo; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE globeinfo (
    id integer NOT NULL,
    workspacename character varying(200) NOT NULL,
    workspacedescription character varying(256)
);


ALTER TABLE public.globeinfo OWNER TO postgres;

--
-- TOC entry 2436 (class 1259 OID 620636)
-- Dependencies: 6 2435
-- Name: globeinfo_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE globeinfo_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.globeinfo_id_seq OWNER TO postgres;

--
-- TOC entry 3917 (class 0 OID 0)
-- Dependencies: 2436
-- Name: globeinfo_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE globeinfo_id_seq OWNED BY globeinfo.id;


--
-- TOC entry 3918 (class 0 OID 0)
-- Dependencies: 2436
-- Name: globeinfo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('globeinfo_id_seq', 1, false);


--
-- TOC entry 2437 (class 1259 OID 620638)
-- Dependencies: 2267 6
-- Name: interface_customized_info_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE interface_customized_info_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.interface_customized_info_id_seq OWNER TO postgres;

--
-- TOC entry 3919 (class 0 OID 0)
-- Dependencies: 2437
-- Name: interface_customized_info_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE interface_customized_info_id_seq OWNED BY interface_customized_info.id;


--
-- TOC entry 3920 (class 0 OID 0)
-- Dependencies: 2437
-- Name: interface_customized_info_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('interface_customized_info_id_seq', 1, false);


--
-- TOC entry 2438 (class 1259 OID 620640)
-- Dependencies: 2268 6
-- Name: interfacesetting_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE interfacesetting_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.interfacesetting_id_seq OWNER TO postgres;

--
-- TOC entry 3921 (class 0 OID 0)
-- Dependencies: 2438
-- Name: interfacesetting_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE interfacesetting_id_seq OWNED BY interfacesetting.id;


--
-- TOC entry 3922 (class 0 OID 0)
-- Dependencies: 2438
-- Name: interfacesetting_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('interfacesetting_id_seq', 1, true);


--
-- TOC entry 2439 (class 1259 OID 620642)
-- Dependencies: 6 2321
-- Name: internetboundaryinterface_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE internetboundaryinterface_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.internetboundaryinterface_id_seq OWNER TO postgres;

--
-- TOC entry 3923 (class 0 OID 0)
-- Dependencies: 2439
-- Name: internetboundaryinterface_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE internetboundaryinterface_id_seq OWNED BY internetboundaryinterface.id;


--
-- TOC entry 3924 (class 0 OID 0)
-- Dependencies: 2439
-- Name: internetboundaryinterface_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('internetboundaryinterface_id_seq', 1, false);


--
-- TOC entry 2440 (class 1259 OID 620644)
-- Dependencies: 6 2272
-- Name: ip2mac_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ip2mac_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ip2mac_id_seq OWNER TO postgres;

--
-- TOC entry 3925 (class 0 OID 0)
-- Dependencies: 2440
-- Name: ip2mac_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ip2mac_id_seq OWNED BY ip2mac.id;


--
-- TOC entry 3926 (class 0 OID 0)
-- Dependencies: 2440
-- Name: ip2mac_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('ip2mac_id_seq', 1, true);


--
-- TOC entry 2441 (class 1259 OID 620646)
-- Dependencies: 6 2323
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
-- TOC entry 3927 (class 0 OID 0)
-- Dependencies: 2441
-- Name: ipphone_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ipphone_id_seq OWNED BY ipphone.id;


--
-- TOC entry 3928 (class 0 OID 0)
-- Dependencies: 2441
-- Name: ipphone_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('ipphone_id_seq', 1, false);


--
-- TOC entry 2442 (class 1259 OID 620648)
-- Dependencies: 6 2273
-- Name: l2connectivity_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE l2connectivity_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.l2connectivity_id_seq OWNER TO postgres;

--
-- TOC entry 3929 (class 0 OID 0)
-- Dependencies: 2442
-- Name: l2connectivity_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE l2connectivity_id_seq OWNED BY l2connectivity.id;


--
-- TOC entry 3930 (class 0 OID 0)
-- Dependencies: 2442
-- Name: l2connectivity_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('l2connectivity_id_seq', 1, true);


--
-- TOC entry 2443 (class 1259 OID 620650)
-- Dependencies: 2274 6
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
-- TOC entry 3931 (class 0 OID 0)
-- Dependencies: 2443
-- Name: l2switchinfo_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE l2switchinfo_id_seq OWNED BY l2switchinfo.id;


--
-- TOC entry 3932 (class 0 OID 0)
-- Dependencies: 2443
-- Name: l2switchinfo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('l2switchinfo_id_seq', 1, false);


--
-- TOC entry 2444 (class 1259 OID 620652)
-- Dependencies: 2324 6
-- Name: l2switchport_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE l2switchport_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.l2switchport_id_seq OWNER TO postgres;

--
-- TOC entry 3933 (class 0 OID 0)
-- Dependencies: 2444
-- Name: l2switchport_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE l2switchport_id_seq OWNED BY l2switchport.id;


--
-- TOC entry 3934 (class 0 OID 0)
-- Dependencies: 2444
-- Name: l2switchport_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('l2switchport_id_seq', 1, true);


--
-- TOC entry 2445 (class 1259 OID 620654)
-- Dependencies: 6
-- Name: l2switchport_temp_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE l2switchport_temp_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.l2switchport_temp_id_seq OWNER TO postgres;

--
-- TOC entry 3935 (class 0 OID 0)
-- Dependencies: 2445
-- Name: l2switchport_temp_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('l2switchport_temp_id_seq', 1, false);


--
-- TOC entry 2446 (class 1259 OID 620656)
-- Dependencies: 6 2325
-- Name: l2switchport_temp_id_seq1; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE l2switchport_temp_id_seq1
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.l2switchport_temp_id_seq1 OWNER TO postgres;

--
-- TOC entry 3936 (class 0 OID 0)
-- Dependencies: 2446
-- Name: l2switchport_temp_id_seq1; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE l2switchport_temp_id_seq1 OWNED BY l2switchport_temp.id;


--
-- TOC entry 3937 (class 0 OID 0)
-- Dependencies: 2446
-- Name: l2switchport_temp_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('l2switchport_temp_id_seq1', 1, false);


--
-- TOC entry 2447 (class 1259 OID 620658)
-- Dependencies: 6 2326
-- Name: l2switchvlan_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE l2switchvlan_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.l2switchvlan_id_seq OWNER TO postgres;

--
-- TOC entry 3938 (class 0 OID 0)
-- Dependencies: 2447
-- Name: l2switchvlan_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE l2switchvlan_id_seq OWNED BY l2switchvlan.id;


--
-- TOC entry 3939 (class 0 OID 0)
-- Dependencies: 2447
-- Name: l2switchvlan_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('l2switchvlan_id_seq', 1, true);


--
-- TOC entry 2448 (class 1259 OID 620660)
-- Dependencies: 6 2275
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
-- TOC entry 3940 (class 0 OID 0)
-- Dependencies: 2448
-- Name: lanswitch_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE lanswitch_id_seq OWNED BY lanswitch.id;


--
-- TOC entry 3941 (class 0 OID 0)
-- Dependencies: 2448
-- Name: lanswitch_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('lanswitch_id_seq', 1, false);


--
-- TOC entry 2449 (class 1259 OID 620662)
-- Dependencies: 6 2327
-- Name: linkgroup_dev_devicegroup_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE linkgroup_dev_devicegroup_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.linkgroup_dev_devicegroup_id_seq OWNER TO postgres;

--
-- TOC entry 3942 (class 0 OID 0)
-- Dependencies: 2449
-- Name: linkgroup_dev_devicegroup_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE linkgroup_dev_devicegroup_id_seq OWNED BY linkgroup_dev_devicegroup.id;


--
-- TOC entry 3943 (class 0 OID 0)
-- Dependencies: 2449
-- Name: linkgroup_dev_devicegroup_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('linkgroup_dev_devicegroup_id_seq', 1, false);


--
-- TOC entry 2450 (class 1259 OID 620664)
-- Dependencies: 6 2329
-- Name: linkgroup_dev_site_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE linkgroup_dev_site_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.linkgroup_dev_site_id_seq OWNER TO postgres;

--
-- TOC entry 3944 (class 0 OID 0)
-- Dependencies: 2450
-- Name: linkgroup_dev_site_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE linkgroup_dev_site_id_seq OWNED BY linkgroup_dev_site.id;


--
-- TOC entry 3945 (class 0 OID 0)
-- Dependencies: 2450
-- Name: linkgroup_dev_site_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('linkgroup_dev_site_id_seq', 1, false);


--
-- TOC entry 2451 (class 1259 OID 620666)
-- Dependencies: 6 2331
-- Name: linkgroup_dev_systemdevicegroup_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE linkgroup_dev_systemdevicegroup_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.linkgroup_dev_systemdevicegroup_id_seq OWNER TO postgres;

--
-- TOC entry 3946 (class 0 OID 0)
-- Dependencies: 2451
-- Name: linkgroup_dev_systemdevicegroup_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE linkgroup_dev_systemdevicegroup_id_seq OWNED BY linkgroup_dev_systemdevicegroup.id;


--
-- TOC entry 3947 (class 0 OID 0)
-- Dependencies: 2451
-- Name: linkgroup_dev_systemdevicegroup_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('linkgroup_dev_systemdevicegroup_id_seq', 1, false);


--
-- TOC entry 2452 (class 1259 OID 620668)
-- Dependencies: 6 2276
-- Name: linkgroup_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE linkgroup_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.linkgroup_id_seq OWNER TO postgres;

--
-- TOC entry 3948 (class 0 OID 0)
-- Dependencies: 2452
-- Name: linkgroup_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE linkgroup_id_seq OWNED BY linkgroup.id;


--
-- TOC entry 3949 (class 0 OID 0)
-- Dependencies: 2452
-- Name: linkgroup_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('linkgroup_id_seq', 16, true);


--
-- TOC entry 2453 (class 1259 OID 620670)
-- Dependencies: 2343 6
-- Name: linkgroup_param_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE linkgroup_param_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.linkgroup_param_id_seq OWNER TO postgres;

--
-- TOC entry 3950 (class 0 OID 0)
-- Dependencies: 2453
-- Name: linkgroup_param_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE linkgroup_param_id_seq OWNED BY linkgroup_param.id;


--
-- TOC entry 3951 (class 0 OID 0)
-- Dependencies: 2453
-- Name: linkgroup_param_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('linkgroup_param_id_seq', 4, true);


--
-- TOC entry 2454 (class 1259 OID 620672)
-- Dependencies: 2333 6
-- Name: linkgroup_paramvalue_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE linkgroup_paramvalue_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.linkgroup_paramvalue_id_seq OWNER TO postgres;

--
-- TOC entry 3952 (class 0 OID 0)
-- Dependencies: 2454
-- Name: linkgroup_paramvalue_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE linkgroup_paramvalue_id_seq OWNED BY linkgroup_paramvalue.id;


--
-- TOC entry 3953 (class 0 OID 0)
-- Dependencies: 2454
-- Name: linkgroup_paramvalue_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('linkgroup_paramvalue_id_seq', 6, true);


--
-- TOC entry 2455 (class 1259 OID 620674)
-- Dependencies: 2338 6
-- Name: linkgroupdevice_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE linkgroupdevice_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.linkgroupdevice_id_seq OWNER TO postgres;

--
-- TOC entry 3954 (class 0 OID 0)
-- Dependencies: 2455
-- Name: linkgroupdevice_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE linkgroupdevice_id_seq OWNED BY linkgroupdevice.id;


--
-- TOC entry 3955 (class 0 OID 0)
-- Dependencies: 2455
-- Name: linkgroupdevice_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('linkgroupdevice_id_seq', 1, false);


--
-- TOC entry 2456 (class 1259 OID 620676)
-- Dependencies: 2336 6
-- Name: linkgroupdevicegroup_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE linkgroupdevicegroup_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.linkgroupdevicegroup_id_seq OWNER TO postgres;

--
-- TOC entry 3956 (class 0 OID 0)
-- Dependencies: 2456
-- Name: linkgroupdevicegroup_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE linkgroupdevicegroup_id_seq OWNED BY linkgroupdevicegroup.id;


--
-- TOC entry 3957 (class 0 OID 0)
-- Dependencies: 2456
-- Name: linkgroupdevicegroup_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('linkgroupdevicegroup_id_seq', 1, false);


--
-- TOC entry 2457 (class 1259 OID 620678)
-- Dependencies: 2334 6
-- Name: linkgroupinterface_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE linkgroupinterface_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.linkgroupinterface_id_seq OWNER TO postgres;

--
-- TOC entry 3958 (class 0 OID 0)
-- Dependencies: 2457
-- Name: linkgroupinterface_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE linkgroupinterface_id_seq OWNED BY linkgroupinterface.id;


--
-- TOC entry 3959 (class 0 OID 0)
-- Dependencies: 2457
-- Name: linkgroupinterface_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('linkgroupinterface_id_seq', 1, false);


--
-- TOC entry 2458 (class 1259 OID 620680)
-- Dependencies: 2341 6
-- Name: linkgrouplinkgroup_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE linkgrouplinkgroup_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.linkgrouplinkgroup_id_seq OWNER TO postgres;

--
-- TOC entry 3960 (class 0 OID 0)
-- Dependencies: 2458
-- Name: linkgrouplinkgroup_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE linkgrouplinkgroup_id_seq OWNED BY linkgrouplinkgroup.id;


--
-- TOC entry 3961 (class 0 OID 0)
-- Dependencies: 2458
-- Name: linkgrouplinkgroup_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('linkgrouplinkgroup_id_seq', 1, false);


--
-- TOC entry 2459 (class 1259 OID 620682)
-- Dependencies: 2344 6
-- Name: linkgroupsite_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE linkgroupsite_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.linkgroupsite_id_seq OWNER TO postgres;

--
-- TOC entry 3962 (class 0 OID 0)
-- Dependencies: 2459
-- Name: linkgroupsite_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE linkgroupsite_id_seq OWNED BY linkgroupsite.id;


--
-- TOC entry 3963 (class 0 OID 0)
-- Dependencies: 2459
-- Name: linkgroupsite_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('linkgroupsite_id_seq', 1, false);


--
-- TOC entry 2460 (class 1259 OID 620684)
-- Dependencies: 2346 6
-- Name: linkgroupsystemdevicegroup_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE linkgroupsystemdevicegroup_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.linkgroupsystemdevicegroup_id_seq OWNER TO postgres;

--
-- TOC entry 3964 (class 0 OID 0)
-- Dependencies: 2460
-- Name: linkgroupsystemdevicegroup_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE linkgroupsystemdevicegroup_id_seq OWNED BY linkgroupsystemdevicegroup.id;


--
-- TOC entry 3965 (class 0 OID 0)
-- Dependencies: 2460
-- Name: linkgroupsystemdevicegroup_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('linkgroupsystemdevicegroup_id_seq', 1, false);


--
-- TOC entry 2461 (class 1259 OID 620686)
-- Dependencies: 6
-- Name: livesetting_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE livesetting_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.livesetting_id_seq OWNER TO postgres;

--
-- TOC entry 3966 (class 0 OID 0)
-- Dependencies: 2461
-- Name: livesetting_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('livesetting_id_seq', 1, true);


--
-- TOC entry 2462 (class 1259 OID 620688)
-- Dependencies: 2348 6
-- Name: lwap_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE lwap_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.lwap_id_seq OWNER TO postgres;

--
-- TOC entry 3967 (class 0 OID 0)
-- Dependencies: 2462
-- Name: lwap_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE lwap_id_seq OWNED BY lwap.id;


--
-- TOC entry 3968 (class 0 OID 0)
-- Dependencies: 2462
-- Name: lwap_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('lwap_id_seq', 1, false);


--
-- TOC entry 2463 (class 1259 OID 620690)
-- Dependencies: 6 2277
-- Name: module_customized_info_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE module_customized_info_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.module_customized_info_id_seq OWNER TO postgres;

--
-- TOC entry 3969 (class 0 OID 0)
-- Dependencies: 2463
-- Name: module_customized_info_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE module_customized_info_id_seq OWNED BY module_customized_info.id;


--
-- TOC entry 3970 (class 0 OID 0)
-- Dependencies: 2463
-- Name: module_customized_info_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('module_customized_info_id_seq', 1, false);


--
-- TOC entry 2464 (class 1259 OID 620692)
-- Dependencies: 2278 6
-- Name: module_property_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE module_property_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.module_property_id_seq OWNER TO postgres;

--
-- TOC entry 3971 (class 0 OID 0)
-- Dependencies: 2464
-- Name: module_property_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE module_property_id_seq OWNED BY module_property.id;


--
-- TOC entry 3972 (class 0 OID 0)
-- Dependencies: 2464
-- Name: module_property_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('module_property_id_seq', 1, false);


--
-- TOC entry 2465 (class 1259 OID 620694)
-- Dependencies: 6
-- Name: nap_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE nap_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.nap_id_seq OWNER TO postgres;

--
-- TOC entry 3973 (class 0 OID 0)
-- Dependencies: 2465
-- Name: nap_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('nap_id_seq', 1, true);


--
-- TOC entry 2466 (class 1259 OID 620696)
-- Dependencies: 6
-- Name: napdevice_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE napdevice_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.napdevice_id_seq OWNER TO postgres;

--
-- TOC entry 3974 (class 0 OID 0)
-- Dependencies: 2466
-- Name: napdevice_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('napdevice_id_seq', 1, true);


--
-- TOC entry 2467 (class 1259 OID 620698)
-- Dependencies: 6 2350
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
-- TOC entry 3975 (class 0 OID 0)
-- Dependencies: 2467
-- Name: nat_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE nat_id_seq OWNED BY nat.id;


--
-- TOC entry 3976 (class 0 OID 0)
-- Dependencies: 2467
-- Name: nat_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('nat_id_seq', 1, false);


--
-- TOC entry 2468 (class 1259 OID 620700)
-- Dependencies: 6 2351
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
-- TOC entry 3977 (class 0 OID 0)
-- Dependencies: 2468
-- Name: natinterface_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE natinterface_id_seq OWNED BY natinterface.id;


--
-- TOC entry 3978 (class 0 OID 0)
-- Dependencies: 2468
-- Name: natinterface_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('natinterface_id_seq', 1, false);


--
-- TOC entry 2469 (class 1259 OID 620702)
-- Dependencies: 6 2349
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
-- TOC entry 3979 (class 0 OID 0)
-- Dependencies: 2469
-- Name: nattointf_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE nattointf_id_seq OWNED BY nattointf.id;


--
-- TOC entry 3980 (class 0 OID 0)
-- Dependencies: 2469
-- Name: nattointf_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('nattointf_id_seq', 1, false);


--
-- TOC entry 2470 (class 1259 OID 620704)
-- Dependencies: 2353 6
-- Name: nd_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE nd_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.nd_id_seq OWNER TO postgres;

--
-- TOC entry 3981 (class 0 OID 0)
-- Dependencies: 2470
-- Name: nd_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE nd_id_seq OWNED BY nd.id;


--
-- TOC entry 3982 (class 0 OID 0)
-- Dependencies: 2470
-- Name: nd_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('nd_id_seq', 1, false);


--
-- TOC entry 2471 (class 1259 OID 620706)
-- Dependencies: 6 2255
-- Name: nomp_appliance_ipri_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE nomp_appliance_ipri_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.nomp_appliance_ipri_seq OWNER TO postgres;

--
-- TOC entry 3983 (class 0 OID 0)
-- Dependencies: 2471
-- Name: nomp_appliance_ipri_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE nomp_appliance_ipri_seq OWNED BY nomp_appliance.ipri;


--
-- TOC entry 3984 (class 0 OID 0)
-- Dependencies: 2471
-- Name: nomp_appliance_ipri_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('nomp_appliance_ipri_seq', 1, true);


--
-- TOC entry 2472 (class 1259 OID 620708)
-- Dependencies: 2356 6
-- Name: nomp_enablepasswd_ipri_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE nomp_enablepasswd_ipri_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.nomp_enablepasswd_ipri_seq OWNER TO postgres;

--
-- TOC entry 3985 (class 0 OID 0)
-- Dependencies: 2472
-- Name: nomp_enablepasswd_ipri_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE nomp_enablepasswd_ipri_seq OWNED BY nomp_enablepasswd.ipri;


--
-- TOC entry 3986 (class 0 OID 0)
-- Dependencies: 2472
-- Name: nomp_enablepasswd_ipri_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('nomp_enablepasswd_ipri_seq', 1, true);


--
-- TOC entry 2473 (class 1259 OID 620710)
-- Dependencies: 6 2359
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
-- TOC entry 3987 (class 0 OID 0)
-- Dependencies: 2473
-- Name: nomp_jumpbox_ipri_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE nomp_jumpbox_ipri_seq OWNED BY nomp_jumpbox.ipri;


--
-- TOC entry 3988 (class 0 OID 0)
-- Dependencies: 2473
-- Name: nomp_jumpbox_ipri_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('nomp_jumpbox_ipri_seq', 1, false);


--
-- TOC entry 2474 (class 1259 OID 620712)
-- Dependencies: 6 2362
-- Name: nomp_snmproinfo_ipri_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE nomp_snmproinfo_ipri_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.nomp_snmproinfo_ipri_seq OWNER TO postgres;

--
-- TOC entry 3989 (class 0 OID 0)
-- Dependencies: 2474
-- Name: nomp_snmproinfo_ipri_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE nomp_snmproinfo_ipri_seq OWNED BY nomp_snmproinfo.ipri;


--
-- TOC entry 3990 (class 0 OID 0)
-- Dependencies: 2474
-- Name: nomp_snmproinfo_ipri_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('nomp_snmproinfo_ipri_seq', 1, true);


--
-- TOC entry 2475 (class 1259 OID 620714)
-- Dependencies: 6
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
-- TOC entry 3991 (class 0 OID 0)
-- Dependencies: 2475
-- Name: nomp_snmprwinfo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('nomp_snmprwinfo_id_seq', 1, false);


--
-- TOC entry 2476 (class 1259 OID 620716)
-- Dependencies: 3085 6
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
-- TOC entry 2477 (class 1259 OID 620720)
-- Dependencies: 2476 6
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
-- TOC entry 3992 (class 0 OID 0)
-- Dependencies: 2477
-- Name: nomp_snmprwinfo_ipri_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE nomp_snmprwinfo_ipri_seq OWNED BY nomp_snmprwinfo.ipri;


--
-- TOC entry 3993 (class 0 OID 0)
-- Dependencies: 2477
-- Name: nomp_snmprwinfo_ipri_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('nomp_snmprwinfo_ipri_seq', 1, false);


--
-- TOC entry 2478 (class 1259 OID 620722)
-- Dependencies: 2365 6
-- Name: nomp_telnetinfo_ipri_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE nomp_telnetinfo_ipri_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.nomp_telnetinfo_ipri_seq OWNER TO postgres;

--
-- TOC entry 3994 (class 0 OID 0)
-- Dependencies: 2478
-- Name: nomp_telnetinfo_ipri_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE nomp_telnetinfo_ipri_seq OWNED BY nomp_telnetinfo.ipri;


--
-- TOC entry 3995 (class 0 OID 0)
-- Dependencies: 2478
-- Name: nomp_telnetinfo_ipri_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('nomp_telnetinfo_ipri_seq', 1, true);


--
-- TOC entry 2479 (class 1259 OID 620724)
-- Dependencies: 3086 3087 6
-- Name: object_customized_attribute; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE object_customized_attribute (
    id integer NOT NULL,
    objectid integer NOT NULL,
    name character varying(64) NOT NULL,
    alias character varying(256),
    allow_export boolean NOT NULL,
    type integer DEFAULT 1 NOT NULL,
    allow_modify_exported boolean NOT NULL,
    lasttimestamp timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.object_customized_attribute OWNER TO postgres;

--
-- TOC entry 3996 (class 0 OID 0)
-- Dependencies: 2479
-- Name: COLUMN object_customized_attribute.objectid; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN object_customized_attribute.objectid IS '0-Site,1-device,2-interface,3-link,4-moudle
';


--
-- TOC entry 3997 (class 0 OID 0)
-- Dependencies: 2479
-- Name: COLUMN object_customized_attribute.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN object_customized_attribute.name IS 'field name';


--
-- TOC entry 3998 (class 0 OID 0)
-- Dependencies: 2479
-- Name: COLUMN object_customized_attribute.alias; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN object_customized_attribute.alias IS 'display name';


--
-- TOC entry 3999 (class 0 OID 0)
-- Dependencies: 2479
-- Name: COLUMN object_customized_attribute.allow_export; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN object_customized_attribute.allow_export IS 'Export to asset report
';


--
-- TOC entry 4000 (class 0 OID 0)
-- Dependencies: 2479
-- Name: COLUMN object_customized_attribute.type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN object_customized_attribute.type IS '1,system field 2,customize field
';


--
-- TOC entry 4001 (class 0 OID 0)
-- Dependencies: 2479
-- Name: COLUMN object_customized_attribute.allow_modify_exported; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN object_customized_attribute.allow_modify_exported IS 'Whether to allow the changes exported property';


--
-- TOC entry 2480 (class 1259 OID 620729)
-- Dependencies: 6 2479
-- Name: object_customized_attribute_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE object_customized_attribute_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.object_customized_attribute_id_seq OWNER TO postgres;

--
-- TOC entry 4002 (class 0 OID 0)
-- Dependencies: 2480
-- Name: object_customized_attribute_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE object_customized_attribute_id_seq OWNED BY object_customized_attribute.id;


--
-- TOC entry 4003 (class 0 OID 0)
-- Dependencies: 2480
-- Name: object_customized_attribute_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('object_customized_attribute_id_seq', 75, true);


--
-- TOC entry 2481 (class 1259 OID 620731)
-- Dependencies: 6 2281
-- Name: object_file_info_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE object_file_info_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.object_file_info_id_seq OWNER TO postgres;

--
-- TOC entry 4004 (class 0 OID 0)
-- Dependencies: 2481
-- Name: object_file_info_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE object_file_info_id_seq OWNED BY object_file_info.id;


--
-- TOC entry 4005 (class 0 OID 0)
-- Dependencies: 2481
-- Name: object_file_info_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('object_file_info_id_seq', 182, true);


--
-- TOC entry 2482 (class 1259 OID 620733)
-- Dependencies: 6
-- Name: object_file_path_info; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE object_file_path_info (
    id integer NOT NULL,
    parentid integer,
    path character varying(256) NOT NULL,
    lasttimestamp timestamp without time zone NOT NULL,
    path_update_time timestamp without time zone NOT NULL,
    object_type integer NOT NULL
);


ALTER TABLE public.object_file_path_info OWNER TO postgres;

--
-- TOC entry 4006 (class 0 OID 0)
-- Dependencies: 2482
-- Name: COLUMN object_file_path_info.object_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN object_file_path_info.object_type IS '3-shared map';


--
-- TOC entry 2483 (class 1259 OID 620736)
-- Dependencies: 2482 6
-- Name: object_file_path_info_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE object_file_path_info_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.object_file_path_info_id_seq OWNER TO postgres;

--
-- TOC entry 4007 (class 0 OID 0)
-- Dependencies: 2483
-- Name: object_file_path_info_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE object_file_path_info_id_seq OWNED BY object_file_path_info.id;


--
-- TOC entry 4008 (class 0 OID 0)
-- Dependencies: 2483
-- Name: object_file_path_info_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('object_file_path_info_id_seq', 1, false);


--
-- TOC entry 2484 (class 1259 OID 620738)
-- Dependencies: 6
-- Name: objprivatetimestamp; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE objprivatetimestamp (
    id integer NOT NULL,
    typename character varying(200) NOT NULL,
    modifytime timestamp without time zone NOT NULL,
    userid integer NOT NULL,
    licguid character varying(128) NOT NULL
);


ALTER TABLE public.objprivatetimestamp OWNER TO postgres;

--
-- TOC entry 2485 (class 1259 OID 620741)
-- Dependencies: 2484 6
-- Name: objprivatetimestamp_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE objprivatetimestamp_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.objprivatetimestamp_id_seq OWNER TO postgres;

--
-- TOC entry 4009 (class 0 OID 0)
-- Dependencies: 2485
-- Name: objprivatetimestamp_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE objprivatetimestamp_id_seq OWNED BY objprivatetimestamp.id;


--
-- TOC entry 4010 (class 0 OID 0)
-- Dependencies: 2485
-- Name: objprivatetimestamp_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('objprivatetimestamp_id_seq', 1, true);


--
-- TOC entry 2486 (class 1259 OID 620743)
-- Dependencies: 6
-- Name: objtimestamp; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE objtimestamp (
    id integer NOT NULL,
    typename character varying(200) NOT NULL,
    modifytime timestamp without time zone NOT NULL
);


ALTER TABLE public.objtimestamp OWNER TO postgres;

--
-- TOC entry 2487 (class 1259 OID 620746)
-- Dependencies: 6 2486
-- Name: objtimestamp_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE objtimestamp_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.objtimestamp_id_seq OWNER TO postgres;

--
-- TOC entry 4011 (class 0 OID 0)
-- Dependencies: 2487
-- Name: objtimestamp_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE objtimestamp_id_seq OWNED BY objtimestamp.id;


--
-- TOC entry 4012 (class 0 OID 0)
-- Dependencies: 2487
-- Name: objtimestamp_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('objtimestamp_id_seq', 47, true);


--
-- TOC entry 2488 (class 1259 OID 620748)
-- Dependencies: 2282 6
-- Name: ouinfo_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ouinfo_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ouinfo_id_seq OWNER TO postgres;

--
-- TOC entry 4013 (class 0 OID 0)
-- Dependencies: 2488
-- Name: ouinfo_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ouinfo_id_seq OWNED BY ouinfo.id;


--
-- TOC entry 4014 (class 0 OID 0)
-- Dependencies: 2488
-- Name: ouinfo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('ouinfo_id_seq', 1, false);


--
-- TOC entry 2489 (class 1259 OID 620750)
-- Dependencies: 6
-- Name: role_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE role_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.role_id_seq OWNER TO postgres;

--
-- TOC entry 4015 (class 0 OID 0)
-- Dependencies: 2489
-- Name: role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('role_id_seq', 6, true);


--
-- TOC entry 2490 (class 1259 OID 620752)
-- Dependencies: 6
-- Name: seq_userid; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE seq_userid
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.seq_userid OWNER TO postgres;

--
-- TOC entry 4016 (class 0 OID 0)
-- Dependencies: 2490
-- Name: seq_userid; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('seq_userid', 3, true);


--
-- TOC entry 2491 (class 1259 OID 620754)
-- Dependencies: 6 2283
-- Name: showcommandbenchmarktask_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE showcommandbenchmarktask_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.showcommandbenchmarktask_id_seq OWNER TO postgres;

--
-- TOC entry 4017 (class 0 OID 0)
-- Dependencies: 2491
-- Name: showcommandbenchmarktask_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE showcommandbenchmarktask_id_seq OWNED BY showcommandbenchmarktask.id;


--
-- TOC entry 4018 (class 0 OID 0)
-- Dependencies: 2491
-- Name: showcommandbenchmarktask_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('showcommandbenchmarktask_id_seq', 1, false);


--
-- TOC entry 2492 (class 1259 OID 620756)
-- Dependencies: 3093 6
-- Name: showcommandbenchmarktaskcmddetail; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE showcommandbenchmarktaskcmddetail (
    id integer NOT NULL,
    taskid integer NOT NULL,
    showcommandinfo character varying(256) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.showcommandbenchmarktaskcmddetail OWNER TO postgres;

--
-- TOC entry 2493 (class 1259 OID 620760)
-- Dependencies: 2492 6
-- Name: showcommandbenchmarktaskcmddetail_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE showcommandbenchmarktaskcmddetail_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.showcommandbenchmarktaskcmddetail_id_seq OWNER TO postgres;

--
-- TOC entry 4019 (class 0 OID 0)
-- Dependencies: 2493
-- Name: showcommandbenchmarktaskcmddetail_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE showcommandbenchmarktaskcmddetail_id_seq OWNED BY showcommandbenchmarktaskcmddetail.id;


--
-- TOC entry 4020 (class 0 OID 0)
-- Dependencies: 2493
-- Name: showcommandbenchmarktaskcmddetail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('showcommandbenchmarktaskcmddetail_id_seq', 1, false);


--
-- TOC entry 2494 (class 1259 OID 620762)
-- Dependencies: 6
-- Name: showcommandbenchmarktaskdgdetail; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE showcommandbenchmarktaskdgdetail (
    id integer NOT NULL,
    taskid integer NOT NULL,
    devicegroupid integer NOT NULL
);


ALTER TABLE public.showcommandbenchmarktaskdgdetail OWNER TO postgres;

--
-- TOC entry 2495 (class 1259 OID 620765)
-- Dependencies: 2494 6
-- Name: showcommandbenchmarktaskdgdetail_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE showcommandbenchmarktaskdgdetail_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.showcommandbenchmarktaskdgdetail_id_seq OWNER TO postgres;

--
-- TOC entry 4021 (class 0 OID 0)
-- Dependencies: 2495
-- Name: showcommandbenchmarktaskdgdetail_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE showcommandbenchmarktaskdgdetail_id_seq OWNED BY showcommandbenchmarktaskdgdetail.id;


--
-- TOC entry 4022 (class 0 OID 0)
-- Dependencies: 2495
-- Name: showcommandbenchmarktaskdgdetail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('showcommandbenchmarktaskdgdetail_id_seq', 1, false);


--
-- TOC entry 2496 (class 1259 OID 620767)
-- Dependencies: 6
-- Name: showcommandbenchmarktasksitedetail; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE showcommandbenchmarktasksitedetail (
    id integer NOT NULL,
    taskid integer NOT NULL,
    siteid integer NOT NULL
);


ALTER TABLE public.showcommandbenchmarktasksitedetail OWNER TO postgres;

--
-- TOC entry 2497 (class 1259 OID 620770)
-- Dependencies: 2496 6
-- Name: showcommandbenchmarktasksitedetail_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE showcommandbenchmarktasksitedetail_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.showcommandbenchmarktasksitedetail_id_seq OWNER TO postgres;

--
-- TOC entry 4023 (class 0 OID 0)
-- Dependencies: 2497
-- Name: showcommandbenchmarktasksitedetail_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE showcommandbenchmarktasksitedetail_id_seq OWNED BY showcommandbenchmarktasksitedetail.id;


--
-- TOC entry 4024 (class 0 OID 0)
-- Dependencies: 2497
-- Name: showcommandbenchmarktasksitedetail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('showcommandbenchmarktasksitedetail_id_seq', 1, false);


--
-- TOC entry 2498 (class 1259 OID 620772)
-- Dependencies: 2367 6
-- Name: showcommandtemplate_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE showcommandtemplate_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.showcommandtemplate_id_seq OWNER TO postgres;

--
-- TOC entry 4025 (class 0 OID 0)
-- Dependencies: 2498
-- Name: showcommandtemplate_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE showcommandtemplate_id_seq OWNED BY showcommandtemplate.id;


--
-- TOC entry 4026 (class 0 OID 0)
-- Dependencies: 2498
-- Name: showcommandtemplate_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('showcommandtemplate_id_seq', 1, false);


--
-- TOC entry 2499 (class 1259 OID 620774)
-- Dependencies: 6 2368
-- Name: site2site_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE site2site_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.site2site_id_seq OWNER TO postgres;

--
-- TOC entry 4027 (class 0 OID 0)
-- Dependencies: 2499
-- Name: site2site_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE site2site_id_seq OWNED BY site2site.id;


--
-- TOC entry 4028 (class 0 OID 0)
-- Dependencies: 2499
-- Name: site2site_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('site2site_id_seq', 1, true);


--
-- TOC entry 2500 (class 1259 OID 620776)
-- Dependencies: 2285 6
-- Name: site_customized_info_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE site_customized_info_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.site_customized_info_id_seq OWNER TO postgres;

--
-- TOC entry 4029 (class 0 OID 0)
-- Dependencies: 2500
-- Name: site_customized_info_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE site_customized_info_id_seq OWNED BY site_customized_info.id;


--
-- TOC entry 4030 (class 0 OID 0)
-- Dependencies: 2500
-- Name: site_customized_info_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('site_customized_info_id_seq', 1, false);


--
-- TOC entry 2501 (class 1259 OID 620778)
-- Dependencies: 2284 6
-- Name: site_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE site_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.site_id_seq OWNER TO postgres;

--
-- TOC entry 4031 (class 0 OID 0)
-- Dependencies: 2501
-- Name: site_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE site_id_seq OWNED BY site.id;


--
-- TOC entry 4032 (class 0 OID 0)
-- Dependencies: 2501
-- Name: site_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('site_id_seq', 1, true);


--
-- TOC entry 2502 (class 1259 OID 620780)
-- Dependencies: 2662 6
-- Name: siteviewsimple; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW siteviewsimple AS
    SELECT site.id, site2site.parentid, site.name, (SELECT count(*) AS count FROM devicesitedeviceview WHERE (devicesitedeviceview.siteid = site.id)) AS irefcount FROM site2site, site WHERE (site2site.siteid = site.id) ORDER BY site.id;


ALTER TABLE public.siteviewsimple OWNER TO postgres;

--
-- TOC entry 2503 (class 1259 OID 620784)
-- Dependencies: 6 2370
-- Name: switchgroup_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE switchgroup_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.switchgroup_id_seq OWNER TO postgres;

--
-- TOC entry 4033 (class 0 OID 0)
-- Dependencies: 2503
-- Name: switchgroup_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE switchgroup_id_seq OWNED BY switchgroup.id;


--
-- TOC entry 4034 (class 0 OID 0)
-- Dependencies: 2503
-- Name: switchgroup_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('switchgroup_id_seq', 3, true);


--
-- TOC entry 2504 (class 1259 OID 620786)
-- Dependencies: 2371 6
-- Name: swtichgroupdevice_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE swtichgroupdevice_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.swtichgroupdevice_id_seq OWNER TO postgres;

--
-- TOC entry 4035 (class 0 OID 0)
-- Dependencies: 2504
-- Name: swtichgroupdevice_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE swtichgroupdevice_id_seq OWNED BY swtichgroupdevice.id;


--
-- TOC entry 4036 (class 0 OID 0)
-- Dependencies: 2504
-- Name: swtichgroupdevice_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('swtichgroupdevice_id_seq', 1, true);


--
-- TOC entry 2505 (class 1259 OID 620788)
-- Dependencies: 6 2305
-- Name: symbol2deviceicon_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE symbol2deviceicon_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.symbol2deviceicon_id_seq OWNER TO postgres;

--
-- TOC entry 4037 (class 0 OID 0)
-- Dependencies: 2505
-- Name: symbol2deviceicon_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE symbol2deviceicon_id_seq OWNED BY symbol2deviceicon.id;


--
-- TOC entry 4038 (class 0 OID 0)
-- Dependencies: 2505
-- Name: symbol2deviceicon_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('symbol2deviceicon_id_seq', 39, true);


--
-- TOC entry 2506 (class 1259 OID 620790)
-- Dependencies: 6
-- Name: symbol2deviceicon_selected; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE symbol2deviceicon_selected (
    id integer NOT NULL,
    symbolid integer NOT NULL,
    default_deviceicon_id integer NOT NULL,
    selected_deviceicon_id integer NOT NULL,
    lasttimestamp timestamp without time zone NOT NULL
);


ALTER TABLE public.symbol2deviceicon_selected OWNER TO postgres;

--
-- TOC entry 2507 (class 1259 OID 620793)
-- Dependencies: 6 2506
-- Name: symbol2deviceicon_selected_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE symbol2deviceicon_selected_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.symbol2deviceicon_selected_id_seq OWNER TO postgres;

--
-- TOC entry 4039 (class 0 OID 0)
-- Dependencies: 2507
-- Name: symbol2deviceicon_selected_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE symbol2deviceicon_selected_id_seq OWNED BY symbol2deviceicon_selected.id;


--
-- TOC entry 4040 (class 0 OID 0)
-- Dependencies: 2507
-- Name: symbol2deviceicon_selected_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('symbol2deviceicon_selected_id_seq', 1, false);


--
-- TOC entry 2508 (class 1259 OID 620795)
-- Dependencies: 6
-- Name: sys_environmentvariable; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE sys_environmentvariable (
    id integer NOT NULL,
    variable character varying(256) NOT NULL,
    value character varying(256)
);


ALTER TABLE public.sys_environmentvariable OWNER TO postgres;

--
-- TOC entry 2509 (class 1259 OID 620798)
-- Dependencies: 2508 6
-- Name: sys_environmentvariable_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sys_environmentvariable_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sys_environmentvariable_id_seq OWNER TO postgres;

--
-- TOC entry 4041 (class 0 OID 0)
-- Dependencies: 2509
-- Name: sys_environmentvariable_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE sys_environmentvariable_id_seq OWNED BY sys_environmentvariable.id;


--
-- TOC entry 4042 (class 0 OID 0)
-- Dependencies: 2509
-- Name: sys_environmentvariable_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sys_environmentvariable_id_seq', 2, true);


--
-- TOC entry 2510 (class 1259 OID 620800)
-- Dependencies: 6
-- Name: sys_option; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE sys_option (
    id integer NOT NULL,
    op_name character varying(100) NOT NULL,
    op_value integer NOT NULL
);


ALTER TABLE public.sys_option OWNER TO postgres;

--
-- TOC entry 2511 (class 1259 OID 620803)
-- Dependencies: 6 2510
-- Name: sys_option_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sys_option_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sys_option_id_seq OWNER TO postgres;

--
-- TOC entry 4043 (class 0 OID 0)
-- Dependencies: 2511
-- Name: sys_option_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE sys_option_id_seq OWNED BY sys_option.id;


--
-- TOC entry 4044 (class 0 OID 0)
-- Dependencies: 2511
-- Name: sys_option_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sys_option_id_seq', 5, true);


--
-- TOC entry 2512 (class 1259 OID 620805)
-- Dependencies: 6
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
-- TOC entry 2513 (class 1259 OID 620808)
-- Dependencies: 6
-- Name: system_info_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE system_info_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.system_info_id_seq OWNER TO postgres;

--
-- TOC entry 4045 (class 0 OID 0)
-- Dependencies: 2513
-- Name: system_info_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('system_info_id_seq', 2, true);


--
-- TOC entry 2514 (class 1259 OID 620810)
-- Dependencies: 3099 3100 3101 3102 6
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
-- TOC entry 2515 (class 1259 OID 620817)
-- Dependencies: 6
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
-- TOC entry 2516 (class 1259 OID 620820)
-- Dependencies: 3104 6
-- Name: system_vendormodel2device_icon; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE system_vendormodel2device_icon (
    id integer NOT NULL,
    vendormodel_id integer NOT NULL,
    deviceicon_id integer NOT NULL,
    lasttimestamp timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.system_vendormodel2device_icon OWNER TO postgres;

--
-- TOC entry 2517 (class 1259 OID 620824)
-- Dependencies: 2516 6
-- Name: system_vendormodel2device_icon_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE system_vendormodel2device_icon_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.system_vendormodel2device_icon_id_seq OWNER TO postgres;

--
-- TOC entry 4046 (class 0 OID 0)
-- Dependencies: 2517
-- Name: system_vendormodel2device_icon_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE system_vendormodel2device_icon_id_seq OWNED BY system_vendormodel2device_icon.id;


--
-- TOC entry 4047 (class 0 OID 0)
-- Dependencies: 2517
-- Name: system_vendormodel2device_icon_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('system_vendormodel2device_icon_id_seq', 1, false);


--
-- TOC entry 2518 (class 1259 OID 620826)
-- Dependencies: 6 2302
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
-- TOC entry 4048 (class 0 OID 0)
-- Dependencies: 2518
-- Name: systemdevicegroup_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE systemdevicegroup_id_seq OWNED BY systemdevicegroup.id;


--
-- TOC entry 4049 (class 0 OID 0)
-- Dependencies: 2518
-- Name: systemdevicegroup_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('systemdevicegroup_id_seq', 1, false);


--
-- TOC entry 2519 (class 1259 OID 620828)
-- Dependencies: 2374 6
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
-- TOC entry 4050 (class 0 OID 0)
-- Dependencies: 2519
-- Name: systemdevicegroupdevice_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE systemdevicegroupdevice_id_seq OWNED BY systemdevicegroupdevice.id;


--
-- TOC entry 4051 (class 0 OID 0)
-- Dependencies: 2519
-- Name: systemdevicegroupdevice_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('systemdevicegroupdevice_id_seq', 1, false);


--
-- TOC entry 2520 (class 1259 OID 620830)
-- Dependencies: 2663 6
-- Name: systemvendormodeliconview; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW systemvendormodeliconview AS
    SELECT device_icon.icon_name, system_vendormodel.id, system_vendormodel.stroid, system_vendormodel.idevicetype, system_vendormodel.strvendorname, system_vendormodel.strmodelname, system_vendormodel.bmodified FROM system_vendormodel2device_icon, device_icon, system_vendormodel WHERE ((system_vendormodel2device_icon.deviceicon_id = device_icon.id) AND (system_vendormodel2device_icon.vendormodel_id = system_vendormodel.id));


ALTER TABLE public.systemvendormodeliconview OWNER TO postgres;

--
-- TOC entry 2521 (class 1259 OID 620834)
-- Dependencies: 2291 6
-- Name: transport_protocol_port_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE transport_protocol_port_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.transport_protocol_port_id_seq OWNER TO postgres;

--
-- TOC entry 4052 (class 0 OID 0)
-- Dependencies: 2521
-- Name: transport_protocol_port_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE transport_protocol_port_id_seq OWNED BY transport_protocol_port.id;


--
-- TOC entry 4053 (class 0 OID 0)
-- Dependencies: 2521
-- Name: transport_protocol_port_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('transport_protocol_port_id_seq', 1, false);


--
-- TOC entry 2522 (class 1259 OID 620836)
-- Dependencies: 2292 6
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
-- TOC entry 4054 (class 0 OID 0)
-- Dependencies: 2522
-- Name: userdevicesetting_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE userdevicesetting_id_seq OWNED BY userdevicesetting.id;


--
-- TOC entry 4055 (class 0 OID 0)
-- Dependencies: 2522
-- Name: userdevicesetting_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('userdevicesetting_id_seq', 1, false);


--
-- TOC entry 2523 (class 1259 OID 620838)
-- Dependencies: 6
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
-- TOC entry 2524 (class 1259 OID 620841)
-- Dependencies: 2523 6
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
-- TOC entry 4056 (class 0 OID 0)
-- Dependencies: 2524
-- Name: wanlink_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE wanlink_id_seq OWNED BY wanlink.id;


--
-- TOC entry 4057 (class 0 OID 0)
-- Dependencies: 2524
-- Name: wanlink_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('wanlink_id_seq', 1, false);


--
-- TOC entry 2525 (class 1259 OID 620843)
-- Dependencies: 6
-- Name: wans; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE wans (
    id integer NOT NULL,
    strname text NOT NULL
);


ALTER TABLE public.wans OWNER TO postgres;

--
-- TOC entry 2526 (class 1259 OID 620849)
-- Dependencies: 6 2525
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
-- TOC entry 4058 (class 0 OID 0)
-- Dependencies: 2526
-- Name: wans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE wans_id_seq OWNED BY wans.id;


--
-- TOC entry 4059 (class 0 OID 0)
-- Dependencies: 2526
-- Name: wans_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('wans_id_seq', 1, false);


--
-- TOC entry 3048 (class 2604 OID 620851)
-- Dependencies: 2379 2378
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE adminpwd ALTER COLUMN id SET DEFAULT nextval('adminpwd_id_seq'::regclass);


--
-- TOC entry 3049 (class 2604 OID 620852)
-- Dependencies: 2381 2380
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE benchmarkfolder ALTER COLUMN id SET DEFAULT nextval('benchmarkfolder_id_seq'::regclass);


--
-- TOC entry 3058 (class 2604 OID 620853)
-- Dependencies: 2383 2382
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE benchmarktask ALTER COLUMN id SET DEFAULT nextval('benchmarktask_id_seq'::regclass);


--
-- TOC entry 3059 (class 2604 OID 620854)
-- Dependencies: 2385 2384
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE benchmarktaskstatus ALTER COLUMN id SET DEFAULT nextval('benchmarktaskstatus_id_seq'::regclass);


--
-- TOC entry 3060 (class 2604 OID 620855)
-- Dependencies: 2387 2386
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE benchmarktaskstatusstep ALTER COLUMN id SET DEFAULT nextval('benchmarktaskstatusstep_id_seq'::regclass);


--
-- TOC entry 3063 (class 2604 OID 620856)
-- Dependencies: 2389 2388
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE benchmarktaskstatussteplog ALTER COLUMN id SET DEFAULT nextval('benchmarktaskstatussteplog_id_seq'::regclass);


--
-- TOC entry 2969 (class 2604 OID 620857)
-- Dependencies: 2390 2293
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE bgpneighbor ALTER COLUMN id SET DEFAULT nextval('bgpneighbor_id_seq'::regclass);


--
-- TOC entry 3067 (class 2604 OID 620858)
-- Dependencies: 2392 2391
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE checkupdate ALTER COLUMN id SET DEFAULT nextval('checkupdate_id_seq'::regclass);


--
-- TOC entry 3070 (class 2604 OID 620859)
-- Dependencies: 2394 2393
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE datastoragesetting ALTER COLUMN id SET DEFAULT nextval('datastoragesetting_id_seq'::regclass);


--
-- TOC entry 2862 (class 2604 OID 620860)
-- Dependencies: 2396 2249
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE device_customized_info ALTER COLUMN id SET DEFAULT nextval('device_customized_info_id_seq'::regclass);


--
-- TOC entry 2978 (class 2604 OID 620861)
-- Dependencies: 2397 2304
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE device_icon ALTER COLUMN id SET DEFAULT nextval('device_icon_id_seq'::regclass);


--
-- TOC entry 2864 (class 2604 OID 620862)
-- Dependencies: 2399 2250
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE device_property ALTER COLUMN id SET DEFAULT nextval('device_property_id_seq'::regclass);


--
-- TOC entry 3072 (class 2604 OID 620863)
-- Dependencies: 2401 2400
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE device_subtype ALTER COLUMN id SET DEFAULT nextval('device_subtype_id_seq'::regclass);


--
-- TOC entry 2859 (class 2604 OID 620864)
-- Dependencies: 2402 2246
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE devicegroup ALTER COLUMN id SET DEFAULT nextval('devicegroup_id_seq'::regclass);


--
-- TOC entry 2860 (class 2604 OID 620865)
-- Dependencies: 2403 2247
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE devicegroupdevice ALTER COLUMN id SET DEFAULT nextval('devicegroupdevice_id_seq'::regclass);


--
-- TOC entry 2971 (class 2604 OID 620866)
-- Dependencies: 2404 2297
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE devicegroupdevicegroup ALTER COLUMN id SET DEFAULT nextval('devicegroupdevicegroup_id_seq'::regclass);


--
-- TOC entry 2972 (class 2604 OID 620867)
-- Dependencies: 2405 2299
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE devicegroupsite ALTER COLUMN id SET DEFAULT nextval('devicegroupsite_id_seq'::regclass);


--
-- TOC entry 2974 (class 2604 OID 620868)
-- Dependencies: 2406 2301
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE devicegroupsystemdevicegroup ALTER COLUMN id SET DEFAULT nextval('devicegroupsystemdevicegroup_id_seq'::regclass);


--
-- TOC entry 2981 (class 2604 OID 620869)
-- Dependencies: 2407 2307
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE deviceprotocols ALTER COLUMN id SET DEFAULT nextval('deviceprotocols_id_seq'::regclass);


--
-- TOC entry 2897 (class 2604 OID 620870)
-- Dependencies: 2408 2253
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE devicesetting ALTER COLUMN id SET DEFAULT nextval('devicesetting_id_seq'::regclass);


--
-- TOC entry 2983 (class 2604 OID 620871)
-- Dependencies: 2409 2309
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE devicesitedevice ALTER COLUMN id SET DEFAULT nextval('devicesitedevice_id_seq'::regclass);


--
-- TOC entry 3073 (class 2604 OID 620872)
-- Dependencies: 2411 2410
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE devicevpns ALTER COLUMN id SET DEFAULT nextval('devicevpns_id_seq'::regclass);


--
-- TOC entry 3075 (class 2604 OID 620873)
-- Dependencies: 2413 2412
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE disableinterface ALTER COLUMN id SET DEFAULT nextval('disableinterface_id_seq'::regclass);


--
-- TOC entry 2901 (class 2604 OID 620874)
-- Dependencies: 2415 2258
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE discover_missdevice ALTER COLUMN id SET DEFAULT nextval('discover_missdevice_id_seq1'::regclass);


--
-- TOC entry 2902 (class 2604 OID 620875)
-- Dependencies: 2417 2260
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE discover_newdevice ALTER COLUMN id SET DEFAULT nextval('discover_newdevice_id_seq1'::regclass);


--
-- TOC entry 3080 (class 2604 OID 620876)
-- Dependencies: 2420 2418
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE discover_schedule ALTER COLUMN id SET DEFAULT nextval('discover_schedule_id_seq1'::regclass);


--
-- TOC entry 2903 (class 2604 OID 620877)
-- Dependencies: 2422 2261
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE discover_snmpdevice ALTER COLUMN id SET DEFAULT nextval('discover_snmpdevice_id_seq1'::regclass);


--
-- TOC entry 2904 (class 2604 OID 620878)
-- Dependencies: 2424 2262
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE discover_unknowdevice ALTER COLUMN id SET DEFAULT nextval('discover_unknowdevice_id_seq1'::regclass);


--
-- TOC entry 3081 (class 2604 OID 620879)
-- Dependencies: 2426 2425
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE domain_name ALTER COLUMN id SET DEFAULT nextval('domain_name_id_seq'::regclass);


--
-- TOC entry 3082 (class 2604 OID 620880)
-- Dependencies: 2428 2427
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE domain_option ALTER COLUMN id SET DEFAULT nextval('domain_option_id_seq'::regclass);


--
-- TOC entry 2984 (class 2604 OID 620881)
-- Dependencies: 2429 2315
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE duplicateip ALTER COLUMN id SET DEFAULT nextval('duplicateip_id_seq'::regclass);


--
-- TOC entry 2986 (class 2604 OID 620882)
-- Dependencies: 2430 2317
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE fixupnatinfo ALTER COLUMN id SET DEFAULT nextval('fixupnatinfo_id_seq'::regclass);


--
-- TOC entry 2987 (class 2604 OID 620883)
-- Dependencies: 2432 2318
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE fixuproutetable ALTER COLUMN id SET DEFAULT nextval('fixuproutetable_id_seq'::regclass);


--
-- TOC entry 2988 (class 2604 OID 620884)
-- Dependencies: 2433 2319
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE fixuproutetablepriority ALTER COLUMN id SET DEFAULT nextval('fixuproutetablepriority_id_seq'::regclass);


--
-- TOC entry 2989 (class 2604 OID 620885)
-- Dependencies: 2434 2320
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE fixupunnumberedinterface ALTER COLUMN id SET DEFAULT nextval('fixupunnumberedinterface_id_seq'::regclass);


--
-- TOC entry 3084 (class 2604 OID 620886)
-- Dependencies: 2436 2435
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE globeinfo ALTER COLUMN id SET DEFAULT nextval('globeinfo_id_seq'::regclass);


--
-- TOC entry 2909 (class 2604 OID 620887)
-- Dependencies: 2437 2267
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE interface_customized_info ALTER COLUMN id SET DEFAULT nextval('interface_customized_info_id_seq'::regclass);


--
-- TOC entry 2923 (class 2604 OID 620888)
-- Dependencies: 2438 2268
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE interfacesetting ALTER COLUMN id SET DEFAULT nextval('interfacesetting_id_seq'::regclass);


--
-- TOC entry 2991 (class 2604 OID 620889)
-- Dependencies: 2439 2321
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE internetboundaryinterface ALTER COLUMN id SET DEFAULT nextval('internetboundaryinterface_id_seq'::regclass);


--
-- TOC entry 2926 (class 2604 OID 620890)
-- Dependencies: 2440 2272
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ip2mac ALTER COLUMN id SET DEFAULT nextval('ip2mac_id_seq'::regclass);


--
-- TOC entry 2992 (class 2604 OID 620891)
-- Dependencies: 2441 2323
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ipphone ALTER COLUMN id SET DEFAULT nextval('ipphone_id_seq'::regclass);


--
-- TOC entry 2931 (class 2604 OID 620892)
-- Dependencies: 2442 2273
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE l2connectivity ALTER COLUMN id SET DEFAULT nextval('l2connectivity_id_seq'::regclass);


--
-- TOC entry 2932 (class 2604 OID 620893)
-- Dependencies: 2443 2274
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE l2switchinfo ALTER COLUMN id SET DEFAULT nextval('l2switchinfo_id_seq'::regclass);


--
-- TOC entry 3000 (class 2604 OID 620894)
-- Dependencies: 2444 2324
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE l2switchport ALTER COLUMN id SET DEFAULT nextval('l2switchport_id_seq'::regclass);


--
-- TOC entry 3007 (class 2604 OID 620895)
-- Dependencies: 2446 2325
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE l2switchport_temp ALTER COLUMN id SET DEFAULT nextval('l2switchport_temp_id_seq1'::regclass);


--
-- TOC entry 3010 (class 2604 OID 620896)
-- Dependencies: 2447 2326
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE l2switchvlan ALTER COLUMN id SET DEFAULT nextval('l2switchvlan_id_seq'::regclass);


--
-- TOC entry 2936 (class 2604 OID 620897)
-- Dependencies: 2448 2275
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE lanswitch ALTER COLUMN id SET DEFAULT nextval('lanswitch_id_seq'::regclass);


--
-- TOC entry 2942 (class 2604 OID 620898)
-- Dependencies: 2452 2276
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE linkgroup ALTER COLUMN id SET DEFAULT nextval('linkgroup_id_seq'::regclass);


--
-- TOC entry 3011 (class 2604 OID 620899)
-- Dependencies: 2449 2327
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE linkgroup_dev_devicegroup ALTER COLUMN id SET DEFAULT nextval('linkgroup_dev_devicegroup_id_seq'::regclass);


--
-- TOC entry 3012 (class 2604 OID 620900)
-- Dependencies: 2450 2329
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE linkgroup_dev_site ALTER COLUMN id SET DEFAULT nextval('linkgroup_dev_site_id_seq'::regclass);


--
-- TOC entry 3014 (class 2604 OID 620901)
-- Dependencies: 2451 2331
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE linkgroup_dev_systemdevicegroup ALTER COLUMN id SET DEFAULT nextval('linkgroup_dev_systemdevicegroup_id_seq'::regclass);


--
-- TOC entry 3021 (class 2604 OID 620902)
-- Dependencies: 2453 2343
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE linkgroup_param ALTER COLUMN id SET DEFAULT nextval('linkgroup_param_id_seq'::regclass);


--
-- TOC entry 3015 (class 2604 OID 620903)
-- Dependencies: 2454 2333
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE linkgroup_paramvalue ALTER COLUMN id SET DEFAULT nextval('linkgroup_paramvalue_id_seq'::regclass);


--
-- TOC entry 3018 (class 2604 OID 620904)
-- Dependencies: 2455 2338
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE linkgroupdevice ALTER COLUMN id SET DEFAULT nextval('linkgroupdevice_id_seq'::regclass);


--
-- TOC entry 3017 (class 2604 OID 620905)
-- Dependencies: 2456 2336
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE linkgroupdevicegroup ALTER COLUMN id SET DEFAULT nextval('linkgroupdevicegroup_id_seq'::regclass);


--
-- TOC entry 3016 (class 2604 OID 620906)
-- Dependencies: 2457 2334
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE linkgroupinterface ALTER COLUMN id SET DEFAULT nextval('linkgroupinterface_id_seq'::regclass);


--
-- TOC entry 3020 (class 2604 OID 620907)
-- Dependencies: 2458 2341
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE linkgrouplinkgroup ALTER COLUMN id SET DEFAULT nextval('linkgrouplinkgroup_id_seq'::regclass);


--
-- TOC entry 3022 (class 2604 OID 620908)
-- Dependencies: 2459 2344
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE linkgroupsite ALTER COLUMN id SET DEFAULT nextval('linkgroupsite_id_seq'::regclass);


--
-- TOC entry 3024 (class 2604 OID 620909)
-- Dependencies: 2460 2346
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE linkgroupsystemdevicegroup ALTER COLUMN id SET DEFAULT nextval('linkgroupsystemdevicegroup_id_seq'::regclass);


--
-- TOC entry 3025 (class 2604 OID 620910)
-- Dependencies: 2462 2348
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE lwap ALTER COLUMN id SET DEFAULT nextval('lwap_id_seq'::regclass);


--
-- TOC entry 2943 (class 2604 OID 620911)
-- Dependencies: 2463 2277
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE module_customized_info ALTER COLUMN id SET DEFAULT nextval('module_customized_info_id_seq'::regclass);


--
-- TOC entry 2947 (class 2604 OID 620912)
-- Dependencies: 2464 2278
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE module_property ALTER COLUMN id SET DEFAULT nextval('module_property_id_seq'::regclass);


--
-- TOC entry 3027 (class 2604 OID 620913)
-- Dependencies: 2467 2350
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE nat ALTER COLUMN id SET DEFAULT nextval('nat_id_seq'::regclass);


--
-- TOC entry 3029 (class 2604 OID 620914)
-- Dependencies: 2468 2351
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE natinterface ALTER COLUMN id SET DEFAULT nextval('natinterface_id_seq'::regclass);


--
-- TOC entry 3026 (class 2604 OID 620915)
-- Dependencies: 2469 2349
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE nattointf ALTER COLUMN id SET DEFAULT nextval('nattointf_id_seq'::regclass);


--
-- TOC entry 3030 (class 2604 OID 620916)
-- Dependencies: 2470 2353
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE nd ALTER COLUMN id SET DEFAULT nextval('nd_id_seq'::regclass);


--
-- TOC entry 3088 (class 2604 OID 620917)
-- Dependencies: 2480 2479
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE object_customized_attribute ALTER COLUMN id SET DEFAULT nextval('object_customized_attribute_id_seq'::regclass);


--
-- TOC entry 2948 (class 2604 OID 620918)
-- Dependencies: 2481 2281
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE object_file_info ALTER COLUMN id SET DEFAULT nextval('object_file_info_id_seq'::regclass);


--
-- TOC entry 3089 (class 2604 OID 620919)
-- Dependencies: 2483 2482
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE object_file_path_info ALTER COLUMN id SET DEFAULT nextval('object_file_path_info_id_seq'::regclass);


--
-- TOC entry 3090 (class 2604 OID 620920)
-- Dependencies: 2485 2484
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE objprivatetimestamp ALTER COLUMN id SET DEFAULT nextval('objprivatetimestamp_id_seq'::regclass);


--
-- TOC entry 3091 (class 2604 OID 620921)
-- Dependencies: 2487 2486
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE objtimestamp ALTER COLUMN id SET DEFAULT nextval('objtimestamp_id_seq'::regclass);


--
-- TOC entry 2949 (class 2604 OID 620922)
-- Dependencies: 2488 2282
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ouinfo ALTER COLUMN id SET DEFAULT nextval('ouinfo_id_seq'::regclass);


--
-- TOC entry 2956 (class 2604 OID 620923)
-- Dependencies: 2491 2283
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE showcommandbenchmarktask ALTER COLUMN id SET DEFAULT nextval('showcommandbenchmarktask_id_seq'::regclass);


--
-- TOC entry 3092 (class 2604 OID 620924)
-- Dependencies: 2493 2492
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE showcommandbenchmarktaskcmddetail ALTER COLUMN id SET DEFAULT nextval('showcommandbenchmarktaskcmddetail_id_seq'::regclass);


--
-- TOC entry 3094 (class 2604 OID 620925)
-- Dependencies: 2495 2494
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE showcommandbenchmarktaskdgdetail ALTER COLUMN id SET DEFAULT nextval('showcommandbenchmarktaskdgdetail_id_seq'::regclass);


--
-- TOC entry 3095 (class 2604 OID 620926)
-- Dependencies: 2497 2496
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE showcommandbenchmarktasksitedetail ALTER COLUMN id SET DEFAULT nextval('showcommandbenchmarktasksitedetail_id_seq'::regclass);


--
-- TOC entry 3040 (class 2604 OID 620927)
-- Dependencies: 2498 2367
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE showcommandtemplate ALTER COLUMN id SET DEFAULT nextval('showcommandtemplate_id_seq'::regclass);


--
-- TOC entry 2957 (class 2604 OID 620928)
-- Dependencies: 2501 2284
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE site ALTER COLUMN id SET DEFAULT nextval('site_id_seq'::regclass);


--
-- TOC entry 3042 (class 2604 OID 620929)
-- Dependencies: 2499 2368
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE site2site ALTER COLUMN id SET DEFAULT nextval('site2site_id_seq'::regclass);


--
-- TOC entry 2959 (class 2604 OID 620930)
-- Dependencies: 2500 2285
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE site_customized_info ALTER COLUMN id SET DEFAULT nextval('site_customized_info_id_seq'::regclass);


--
-- TOC entry 3043 (class 2604 OID 620931)
-- Dependencies: 2503 2370
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE switchgroup ALTER COLUMN id SET DEFAULT nextval('switchgroup_id_seq'::regclass);


--
-- TOC entry 3045 (class 2604 OID 620932)
-- Dependencies: 2504 2371
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE swtichgroupdevice ALTER COLUMN id SET DEFAULT nextval('swtichgroupdevice_id_seq'::regclass);


--
-- TOC entry 2980 (class 2604 OID 620933)
-- Dependencies: 2505 2305
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE symbol2deviceicon ALTER COLUMN id SET DEFAULT nextval('symbol2deviceicon_id_seq'::regclass);


--
-- TOC entry 3096 (class 2604 OID 620934)
-- Dependencies: 2507 2506
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE symbol2deviceicon_selected ALTER COLUMN id SET DEFAULT nextval('symbol2deviceicon_selected_id_seq'::regclass);


--
-- TOC entry 3097 (class 2604 OID 620935)
-- Dependencies: 2509 2508
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE sys_environmentvariable ALTER COLUMN id SET DEFAULT nextval('sys_environmentvariable_id_seq'::regclass);


--
-- TOC entry 3098 (class 2604 OID 620936)
-- Dependencies: 2511 2510
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE sys_option ALTER COLUMN id SET DEFAULT nextval('sys_option_id_seq'::regclass);


--
-- TOC entry 3103 (class 2604 OID 620937)
-- Dependencies: 2517 2516
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE system_vendormodel2device_icon ALTER COLUMN id SET DEFAULT nextval('system_vendormodel2device_icon_id_seq'::regclass);


--
-- TOC entry 2977 (class 2604 OID 620938)
-- Dependencies: 2518 2302
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE systemdevicegroup ALTER COLUMN id SET DEFAULT nextval('systemdevicegroup_id_seq'::regclass);


--
-- TOC entry 3046 (class 2604 OID 620939)
-- Dependencies: 2519 2374
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE systemdevicegroupdevice ALTER COLUMN id SET DEFAULT nextval('systemdevicegroupdevice_id_seq'::regclass);


--
-- TOC entry 2963 (class 2604 OID 620940)
-- Dependencies: 2521 2291
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE transport_protocol_port ALTER COLUMN id SET DEFAULT nextval('transport_protocol_port_id_seq'::regclass);


--
-- TOC entry 2968 (class 2604 OID 620941)
-- Dependencies: 2522 2292
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE userdevicesetting ALTER COLUMN id SET DEFAULT nextval('userdevicesetting_id_seq'::regclass);


--
-- TOC entry 3105 (class 2604 OID 620942)
-- Dependencies: 2524 2523
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE wanlink ALTER COLUMN id SET DEFAULT nextval('wanlink_id_seq'::regclass);


--
-- TOC entry 3106 (class 2604 OID 620943)
-- Dependencies: 2526 2525
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE wans ALTER COLUMN id SET DEFAULT nextval('wans_id_seq'::regclass);


--
-- TOC entry 3775 (class 0 OID 620472)
-- Dependencies: 2378
-- Data for Name: adminpwd; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO adminpwd (id, pwd) VALUES (1, '21232f297a57a5a743894a0e4a801fc3');


--
-- TOC entry 3776 (class 0 OID 620477)
-- Dependencies: 2380
-- Data for Name: benchmarkfolder; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3777 (class 0 OID 620482)
-- Dependencies: 2382
-- Data for Name: benchmarktask; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO benchmarktask (id, itype, strname, creator, createtime, modifytime, imode, startday, starttime, every, iselect, monthday, benable, lastruntime, defined_source, stptable, inventoryinfo, buildcontent) VALUES (1, 2, 'System Benchmark', 'admin', '2010-01-29 13:38:43.984375', '2010-02-03 16:13:35.6875', 0, '2010-01-01 13:38:43', '12:00:00', 1, 1, 0, false, NULL, 0, 1, 1,15);


--
-- TOC entry 3778 (class 0 OID 620495)
-- Dependencies: 2384
-- Data for Name: benchmarktaskstatus; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3779 (class 0 OID 620500)
-- Dependencies: 2386
-- Data for Name: benchmarktaskstatusstep; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3780 (class 0 OID 620505)
-- Dependencies: 2388
-- Data for Name: benchmarktaskstatussteplog; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3731 (class 0 OID 620033)
-- Dependencies: 2293
-- Data for Name: bgpneighbor; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3781 (class 0 OID 620517)
-- Dependencies: 2391
-- Data for Name: checkupdate; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3782 (class 0 OID 620525)
-- Dependencies: 2393
-- Data for Name: datastoragesetting; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO datastoragesetting (id, kindname, ischeck, beforedays) VALUES (1, 'DataFolder', false, 30);
INSERT INTO datastoragesetting (id, kindname, ischeck, beforedays) VALUES (2, 'OneIPTable', false, 7);


--
-- TOC entry 3783 (class 0 OID 620532)
-- Dependencies: 2395
-- Data for Name: device_config; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3703 (class 0 OID 619564)
-- Dependencies: 2249
-- Data for Name: device_customized_info; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3736 (class 0 OID 620088)
-- Dependencies: 2304
-- Data for Name: device_icon; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO device_icon (id, icon_name, lasttimestamp) VALUES (1, 'Cisco Catalyst Switch', '2012-09-04 10:41:43.479');
INSERT INTO device_icon (id, icon_name, lasttimestamp) VALUES (2, 'Cisco Router', '2012-09-04 10:41:43.479');
INSERT INTO device_icon (id, icon_name, lasttimestamp) VALUES (3, 'Cisco IOS Switch', '2012-09-04 10:41:43.494');
INSERT INTO device_icon (id, icon_name, lasttimestamp) VALUES (4, 'Cisco PIX Firewall', '2012-09-04 10:41:43.494');
INSERT INTO device_icon (id, icon_name, lasttimestamp) VALUES (5, 'End System', '2012-09-04 10:41:43.494');
INSERT INTO device_icon (id, icon_name, lasttimestamp) VALUES (6, 'LAN', '2012-09-04 10:41:43.494');
INSERT INTO device_icon (id, icon_name, lasttimestamp) VALUES (7, 'WAN', '2012-09-04 10:41:43.494');
INSERT INTO device_icon (id, icon_name, lasttimestamp) VALUES (8, 'MPLS Cloud', '2012-09-04 10:41:43.494');
INSERT INTO device_icon (id, icon_name, lasttimestamp) VALUES (9, 'Call Manager', '2012-09-04 10:41:43.494');
INSERT INTO device_icon (id, icon_name, lasttimestamp) VALUES (10, 'IP Phone', '2012-09-04 10:41:43.494');
INSERT INTO device_icon (id, icon_name, lasttimestamp) VALUES (11, 'Cisco WAP', '2012-09-04 10:41:43.494');
INSERT INTO device_icon (id, icon_name, lasttimestamp) VALUES (12, 'Cisco ASA Firewall', '2012-09-04 10:41:43.494');
INSERT INTO device_icon (id, icon_name, lasttimestamp) VALUES (13, 'Juniper Router', '2012-09-04 10:41:43.494');
INSERT INTO device_icon (id, icon_name, lasttimestamp) VALUES (14, 'NetScreen Firewall', '2012-09-04 10:41:43.51');
INSERT INTO device_icon (id, icon_name, lasttimestamp) VALUES (15, 'Extreme Switch', '2012-09-04 10:41:43.51');
INSERT INTO device_icon (id, icon_name, lasttimestamp) VALUES (16, 'Unclassified Device', '2012-09-04 10:41:43.51');
INSERT INTO device_icon (id, icon_name, lasttimestamp) VALUES (17, 'Mute LAN', '2012-09-04 10:41:43.51');
INSERT INTO device_icon (id, icon_name, lasttimestamp) VALUES (18, 'Checkpoint Firewall', '2012-09-04 10:41:43.51');
INSERT INTO device_icon (id, icon_name, lasttimestamp) VALUES (19, 'F5 Load Balancer', '2012-09-04 10:41:43.51');
INSERT INTO device_icon (id, icon_name, lasttimestamp) VALUES (20, 'Unclassified Router', '2012-09-04 10:41:43.526');
INSERT INTO device_icon (id, icon_name, lasttimestamp) VALUES (21, 'Unclassified Switch', '2012-09-04 10:41:43.526');
INSERT INTO device_icon (id, icon_name, lasttimestamp) VALUES (22, 'CSS', '2012-09-04 10:41:43.526');
INSERT INTO device_icon (id, icon_name, lasttimestamp) VALUES (23, 'Cache Engine', '2012-09-04 10:41:43.526');
INSERT INTO device_icon (id, icon_name, lasttimestamp) VALUES (24, 'Unclassified Firewall', '2012-09-04 10:41:43.526');
INSERT INTO device_icon (id, icon_name, lasttimestamp) VALUES (25, 'Unclassified Load Balancer', '2012-09-04 10:41:43.526');
INSERT INTO device_icon (id, icon_name, lasttimestamp) VALUES (26, 'Unknown IP Device', '2012-09-04 10:41:43.526');
INSERT INTO device_icon (id, icon_name, lasttimestamp) VALUES (27, '3Com Switch', '2012-09-04 10:41:43.526');
INSERT INTO device_icon (id, icon_name, lasttimestamp) VALUES (28, 'Cisco Nexus Switch', '2012-09-04 10:41:43.526');
INSERT INTO device_icon (id, icon_name, lasttimestamp) VALUES (29, 'DMVPN', '2012-09-04 10:41:43.526');
INSERT INTO device_icon (id, icon_name, lasttimestamp) VALUES (30, 'HP ProCurve Switch', '2012-09-04 10:41:43.541');
INSERT INTO device_icon (id, icon_name, lasttimestamp) VALUES (31, 'Juniper EX Switch', '2012-09-04 10:41:43.541');
INSERT INTO device_icon (id, icon_name, lasttimestamp) VALUES (32, 'Internet Wan', '2012-09-04 10:41:43.541');
INSERT INTO device_icon (id, icon_name, lasttimestamp) VALUES (33, 'WLC', '2012-09-04 10:41:43.541');
INSERT INTO device_icon (id, icon_name, lasttimestamp) VALUES (34, 'LWAP', '2012-09-04 10:41:43.541');
INSERT INTO device_icon (id, icon_name, lasttimestamp) VALUES (35, 'Arista Switch', '2012-09-04 10:41:43.557');
INSERT INTO device_icon (id, icon_name, lasttimestamp) VALUES (36, 'Brocade Switch', '2012-09-04 10:41:43.572');
INSERT INTO device_icon (id, icon_name, lasttimestamp) VALUES (38, 'Cisco IOS XR', '2012-09-04 10:41:43.572');
INSERT INTO device_icon (id, icon_name, lasttimestamp) VALUES (39, 'Juniper SRX Firewall', '2012-09-04 10:41:43.572');
INSERT INTO device_icon (id, icon_name, lasttimestamp) VALUES (37, 'Dell Force10 Switch', '2012-09-04 10:41:45.416');


--
-- TOC entry 3784 (class 0 OID 620542)
-- Dependencies: 2398
-- Data for Name: device_maintype; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3704 (class 0 OID 619568)
-- Dependencies: 2250
-- Data for Name: device_property; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3785 (class 0 OID 620547)
-- Dependencies: 2400
-- Data for Name: device_subtype; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3701 (class 0 OID 619546)
-- Dependencies: 2246
-- Data for Name: devicegroup; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO devicegroup (id, strname, strdesc, userid, showcolor, searchcondition, searchcontainer, licguid) VALUES (2, 'Device with only static routing', '', -1, 6266528, '<?xml version="1.0" encoding="UTF-8"?>
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
</DyCompoment>', 1, '-1');
INSERT INTO devicegroup (id, strname, strdesc, userid, showcolor, searchcondition, searchcontainer, licguid) VALUES (3, 'BGP reflector', '', -1, 2142890, '<?xml version="1.0" encoding="UTF-8"?>
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
</DyCompoment>', 1, '-1');
INSERT INTO devicegroup (id, strname, strdesc, userid, showcolor, searchcondition, searchcontainer, licguid) VALUES (4, 'OSPF backbone Area', '', -1, 3050327, '<?xml version="1.0" encoding="UTF-8"?>
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
</DyCompoment>', 1, '-1');
INSERT INTO devicegroup (id, strname, strdesc, userid, showcolor, searchcondition, searchcontainer, licguid) VALUES (5, 'OSPF routing summary', '', -1, 9419915, '<?xml version="1.0" encoding="UTF-8"?>
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
</DyCompoment>', 1, '-1');
INSERT INTO devicegroup (id, strname, strdesc, userid, showcolor, searchcondition, searchcontainer, licguid) VALUES (6, 'All EIGRP Devices', '', -1, 14315734, '<?xml version="1.0" encoding="UTF-8"?>
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
</DyCompoment>', 1, '-1');
INSERT INTO devicegroup (id, strname, strdesc, userid, showcolor, searchcondition, searchcontainer, licguid) VALUES (7, 'All BGP Devices', '', -1, 2142890, '<?xml version="1.0" encoding="UTF-8"?>
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
</DyCompoment>', 1, '-1');
INSERT INTO devicegroup (id, strname, strdesc, userid, showcolor, searchcondition, searchcontainer, licguid) VALUES (8, 'BGP route summary', '', -1, 139, '<?xml version="1.0" encoding="UTF-8"?>
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
</DyCompoment>', 1, '-1');
INSERT INTO devicegroup (id, strname, strdesc, userid, showcolor, searchcondition, searchcontainer, licguid) VALUES (12, 'All OSPF Devices', '', -1, 8900331, '<?xml version="1.0" encoding="UTF-8"?>
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
</DyCompoment>', 1, '-1');
INSERT INTO devicegroup (id, strname, strdesc, userid, showcolor, searchcondition, searchcontainer, licguid) VALUES (10, 'All devices without TACACS-Radius authentication', '', -1, 8421376, '<?xml version="1.0" encoding="UTF-8"?>
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
</DyCompoment>', 1, '-1');
INSERT INTO devicegroup (id, strname, strdesc, userid, showcolor, searchcondition, searchcontainer, licguid) VALUES (11, 'All RIP Devices', '', -1, 32896, '<?xml version="1.0" encoding="UTF-8"?>
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
</DyCompoment>', 1, '-1');
INSERT INTO devicegroup (id, strname, strdesc, userid, showcolor, searchcondition, searchcontainer, licguid) VALUES (13, 'All multicasting routers', '', -1, 15761536, '<?xml version="1.0" encoding="UTF-8"?>
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
</DyCompoment>', 1, '-1');


--
-- TOC entry 3702 (class 0 OID 619555)
-- Dependencies: 2247
-- Data for Name: devicegroupdevice; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3732 (class 0 OID 620057)
-- Dependencies: 2297
-- Data for Name: devicegroupdevicegroup; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3733 (class 0 OID 620066)
-- Dependencies: 2299
-- Data for Name: devicegroupsite; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3734 (class 0 OID 620075)
-- Dependencies: 2301
-- Data for Name: devicegroupsystemdevicegroup; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3738 (class 0 OID 620102)
-- Dependencies: 2307
-- Data for Name: deviceprotocols; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3700 (class 0 OID 619541)
-- Dependencies: 2245
-- Data for Name: devices; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3705 (class 0 OID 619587)
-- Dependencies: 2253
-- Data for Name: devicesetting; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3739 (class 0 OID 620111)
-- Dependencies: 2309
-- Data for Name: devicesitedevice; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3786 (class 0 OID 620569)
-- Dependencies: 2410
-- Data for Name: devicevpns; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3787 (class 0 OID 620575)
-- Dependencies: 2412
-- Data for Name: disableinterface; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3707 (class 0 OID 619664)
-- Dependencies: 2258
-- Data for Name: discover_missdevice; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3708 (class 0 OID 619675)
-- Dependencies: 2260
-- Data for Name: discover_newdevice; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3788 (class 0 OID 620589)
-- Dependencies: 2418
-- Data for Name: discover_schedule; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3709 (class 0 OID 619682)
-- Dependencies: 2261
-- Data for Name: discover_snmpdevice; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3710 (class 0 OID 619689)
-- Dependencies: 2262
-- Data for Name: discover_unknowdevice; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3789 (class 0 OID 620607)
-- Dependencies: 2425
-- Data for Name: domain_name; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3790 (class 0 OID 620615)
-- Dependencies: 2427
-- Data for Name: domain_option; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO domain_option (id, op_val) VALUES (1, 1);


--
-- TOC entry 3712 (class 0 OID 619712)
-- Dependencies: 2266
-- Data for Name: donotscan; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3740 (class 0 OID 620140)
-- Dependencies: 2315
-- Data for Name: duplicateip; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3741 (class 0 OID 620149)
-- Dependencies: 2317
-- Data for Name: fixupnatinfo; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3742 (class 0 OID 620156)
-- Dependencies: 2318
-- Data for Name: fixuproutetable; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3743 (class 0 OID 620160)
-- Dependencies: 2319
-- Data for Name: fixuproutetablepriority; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3744 (class 0 OID 620164)
-- Dependencies: 2320
-- Data for Name: fixupunnumberedinterface; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3791 (class 0 OID 620633)
-- Dependencies: 2435
-- Data for Name: globeinfo; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO globeinfo (id, workspacename, workspacedescription) VALUES (0, 'Enterprise Network', 'This is a shared workspace on the enterprise server.');


--
-- TOC entry 3713 (class 0 OID 619719)
-- Dependencies: 2267
-- Data for Name: interface_customized_info; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3714 (class 0 OID 619723)
-- Dependencies: 2268
-- Data for Name: interfacesetting; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3745 (class 0 OID 620171)
-- Dependencies: 2321
-- Data for Name: internetboundaryinterface; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3715 (class 0 OID 619764)
-- Dependencies: 2272
-- Data for Name: ip2mac; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3746 (class 0 OID 620180)
-- Dependencies: 2323
-- Data for Name: ipphone; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3716 (class 0 OID 619786)
-- Dependencies: 2273
-- Data for Name: l2connectivity; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3717 (class 0 OID 619796)
-- Dependencies: 2274
-- Data for Name: l2switchinfo; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3747 (class 0 OID 620187)
-- Dependencies: 2324
-- Data for Name: l2switchport; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3748 (class 0 OID 620201)
-- Dependencies: 2325
-- Data for Name: l2switchport_temp; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3749 (class 0 OID 620214)
-- Dependencies: 2326
-- Data for Name: l2switchvlan; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3718 (class 0 OID 619803)
-- Dependencies: 2275
-- Data for Name: lanswitch; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3719 (class 0 OID 619814)
-- Dependencies: 2276
-- Data for Name: linkgroup; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO linkgroup (id, strname, strdesc, showcolor, showstyle, showwidth, userid, searchcondition, searchcontainer, dev_searchcondition, dev_searchcontainer, is_map_auto_link, istemplate, licguid) VALUES (1, 'All PIM interface', '', 14423100, 0, 6, -1, '<?xml version="1.0" encoding="UTF-8"?>
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
</filter>', 1, '<?xml version="1.0" encoding="UTF-8"?>
<filter>
<expression/>
</filter>', 1, true, false, '-1');
INSERT INTO linkgroup (id, strname, strdesc, showcolor, showstyle, showwidth, userid, searchcondition, searchcontainer, dev_searchcondition, dev_searchcontainer, is_map_auto_link, istemplate, licguid) VALUES (2, 'EIGRP summary routers', '', 4251856, 0, 6, -1, '<?xml version="1.0" encoding="UTF-8"?>
<filter>
<expression>A</expression>
<condition variable="A" type="106">
<operator>4</operator>
<expression>ip summary-address eigrp</expression>
</condition>
</filter>', 1, '<?xml version="1.0" encoding="UTF-8"?>
<filter>
<expression/>
</filter>', 1, true, false, '-1');
INSERT INTO linkgroup (id, strname, strdesc, showcolor, showstyle, showwidth, userid, searchcondition, searchcontainer, dev_searchcondition, dev_searchcontainer, is_map_auto_link, istemplate, licguid) VALUES (3, 'All ISIS devices', '', 1644912, 0, 6, -1, '<?xml version="1.0" encoding="UTF-8"?>
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
</filter>', 1, '<?xml version="1.0" encoding="UTF-8"?>
<filter>
<expression/>
</filter>', 1, true, false, '-1');
INSERT INTO linkgroup (id, strname, strdesc, showcolor, showstyle, showwidth, userid, searchcondition, searchcontainer, dev_searchcondition, dev_searchcontainer, is_map_auto_link, istemplate, licguid) VALUES (4, 'ISIS backbone area', '', 9109643, 0, 6, -1, '<?xml version="1.0" encoding="UTF-8"?>
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
</filter>', 1, '<?xml version="1.0" encoding="UTF-8"?>
<filter>
<expression/>
</filter>', 1, true, false, '-1');
INSERT INTO linkgroup (id, strname, strdesc, showcolor, showstyle, showwidth, userid, searchcondition, searchcontainer, dev_searchcondition, dev_searchcontainer, is_map_auto_link, istemplate, licguid) VALUES (7, 'PIM RP points', '', 205, 0, 6, -1, '<?xml version="1.0" encoding="UTF-8"?>
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
</filter>', 1, '<?xml version="1.0" encoding="UTF-8"?>
<filter>
<expression/>
</filter>', 1, true, false, '-1');
INSERT INTO linkgroup (id, strname, strdesc, showcolor, showstyle, showwidth, userid, searchcondition, searchcontainer, dev_searchcondition, dev_searchcontainer, is_map_auto_link, istemplate, licguid) VALUES (5, 'ISIS L2 and L1-L2 devices', '', 12357519, 0, 6, -1, '<?xml version="1.0" encoding="UTF-8"?>
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
</filter>', 1, '<?xml version="1.0" encoding="UTF-8"?>
<filter>
<expression/>
</filter>', 1, true, false, '-1');
INSERT INTO linkgroup (id, strname, strdesc, showcolor, showstyle, showwidth, userid, searchcondition, searchcontainer, dev_searchcondition, dev_searchcontainer, is_map_auto_link, istemplate, licguid) VALUES (8, 'Devices with 10G interfaces', '', 13458524, 0, 6, -1, '<?xml version="1.0" encoding="UTF-8"?>
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
</filter>', 1, '<?xml version="1.0" encoding="UTF-8"?>
<filter>
<expression/>
</filter>', 1, true, false, '-1');
INSERT INTO linkgroup (id, strname, strdesc, showcolor, showstyle, showwidth, userid, searchcondition, searchcontainer, dev_searchcondition, dev_searchcontainer, is_map_auto_link, istemplate, licguid) VALUES (10, 'CBWFQ devices', '', 255, 0, 6, -1, '<?xml version="1.0" encoding="UTF-8"?>
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
</filter>', 1, '<?xml version="1.0" encoding="UTF-8"?>
<filter>
<expression/>
</filter>', 1, true, false, '-1');
INSERT INTO linkgroup (id, strname, strdesc, showcolor, showstyle, showwidth, userid, searchcondition, searchcontainer, dev_searchcondition, dev_searchcontainer, is_map_auto_link, istemplate, licguid) VALUES (9, 'VoIP Auto-QOS', '', 13047173, 0, 6, -1, '<?xml version="1.0" encoding="UTF-8"?>
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
</filter>', 1, '<?xml version="1.0" encoding="UTF-8"?>
<filter>
<expression/>
</filter>', 1, true, false, '-1');
INSERT INTO linkgroup (id, strname, strdesc, showcolor, showstyle, showwidth, userid, searchcondition, searchcontainer, dev_searchcondition, dev_searchcontainer, is_map_auto_link, istemplate, licguid) VALUES (12, 'All NAT routers', '', 11584734, 0, 6, -1, '<?xml version="1.0" encoding="UTF-8"?>
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
</filter>', 1, '<?xml version="1.0" encoding="UTF-8"?>
<filter>
<expression/>
</filter>', 1, true, false, '-1');
INSERT INTO linkgroup (id, strname, strdesc, showcolor, showstyle, showwidth, userid, searchcondition, searchcontainer, dev_searchcondition, dev_searchcontainer, is_map_auto_link, istemplate, licguid) VALUES (11, 'All HSRP routers', '', 14315734, 0, 6, -1, '<?xml version="1.0" encoding="UTF-8"?>
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
</filter>', 1, '<?xml version="1.0" encoding="UTF-8"?>
<filter>
<expression/>
</filter>', 1, true, false, '-1');
INSERT INTO linkgroup (id, strname, strdesc, showcolor, showstyle, showwidth, userid, searchcondition, searchcontainer, dev_searchcondition, dev_searchcontainer, is_map_auto_link, istemplate, licguid) VALUES (16, 'Multicasting PIM interfaces', '', 4734347, 0, 6, -1, '<?xml version="1.0" encoding="UTF-8"?>
<filter>
<expression>A</expression>
<condition variable="A" type="106">
<operator>4</operator>
<expression>ip pim #PIM_Mode</expression>
</condition>
</filter>', 1, '<?xml version="1.0" encoding="UTF-8"?>
<filter>
<expression/>
</filter>', 1, true, true, '-1');
INSERT INTO linkgroup (id, strname, strdesc, showcolor, showstyle, showwidth, userid, searchcondition, searchcontainer, dev_searchcondition, dev_searchcontainer, is_map_auto_link, istemplate, licguid) VALUES (15, 'Devices in specified BGP AS', '', 32896, 0, 6, -1, '<?xml version="1.0" encoding="UTF-8"?>
<filter>
<expression/>
</filter>', 1, '<?xml version="1.0" encoding="UTF-8"?>
<filter>
<expression>A</expression>
<condition variable="A" type="9">
<operator>2</operator>
<expression>router bgp #AS_Number</expression>
</condition>
</filter>', 1, true, true, '-1');
INSERT INTO linkgroup (id, strname, strdesc, showcolor, showstyle, showwidth, userid, searchcondition, searchcontainer, dev_searchcondition, dev_searchcontainer, is_map_auto_link, istemplate, licguid) VALUES (14, 'VRF Network', '', 16753920, 0, 6, -1, '<?xml version="1.0" encoding="UTF-8"?>
<filter>
<expression>A</expression>
<condition variable="A" type="104">
<operator>4</operator>
<expression>#VRF_Name</expression>
</condition>
</filter>', 1, '<?xml version="1.0" encoding="UTF-8"?>
<filter>
<expression>A</expression>
<condition variable="A" type="9">
<operator>4</operator>
<expression>mpls ip;tag-switching</expression>
</condition>
</filter>', 1, true, true, '-1');
INSERT INTO linkgroup (id, strname, strdesc, showcolor, showstyle, showwidth, userid, searchcondition, searchcontainer, dev_searchcondition, dev_searchcontainer, is_map_auto_link, istemplate, licguid) VALUES (13, 'Devices with specified SNMP RO', '', 9127187, 0, 6, -1, '<?xml version="1.0" encoding="UTF-8"?>
<filter>
<expression/>
</filter>', 1, '<?xml version="1.0" encoding="UTF-8"?>
<filter>
<expression>A and B</expression>
<condition variable="A" type="0">
<operator>-1</operator>
<expression>2;2001;</expression>
</condition>
<condition variable="B" type="9">
<operator>4</operator>
<expression>snmp-server community #RO_String ro</expression>
</condition>
</filter>', 1, true, true, '-1');


--
-- TOC entry 3750 (class 0 OID 620221)
-- Dependencies: 2327
-- Data for Name: linkgroup_dev_devicegroup; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3751 (class 0 OID 620229)
-- Dependencies: 2329
-- Data for Name: linkgroup_dev_site; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3752 (class 0 OID 620238)
-- Dependencies: 2331
-- Data for Name: linkgroup_dev_systemdevicegroup; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3758 (class 0 OID 620291)
-- Dependencies: 2343
-- Data for Name: linkgroup_param; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3753 (class 0 OID 620246)
-- Dependencies: 2333
-- Data for Name: linkgroup_paramvalue; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3756 (class 0 OID 620269)
-- Dependencies: 2338
-- Data for Name: linkgroupdevice; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3755 (class 0 OID 620261)
-- Dependencies: 2336
-- Data for Name: linkgroupdevicegroup; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3754 (class 0 OID 620253)
-- Dependencies: 2334
-- Data for Name: linkgroupinterface; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3757 (class 0 OID 620283)
-- Dependencies: 2341
-- Data for Name: linkgrouplinkgroup; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3759 (class 0 OID 620298)
-- Dependencies: 2344
-- Data for Name: linkgroupsite; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3760 (class 0 OID 620307)
-- Dependencies: 2346
-- Data for Name: linkgroupsystemdevicegroup; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3761 (class 0 OID 620315)
-- Dependencies: 2348
-- Data for Name: lwap; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3720 (class 0 OID 619837)
-- Dependencies: 2277
-- Data for Name: module_customized_info; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3721 (class 0 OID 619841)
-- Dependencies: 2278
-- Data for Name: module_property; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3763 (class 0 OID 620328)
-- Dependencies: 2350
-- Data for Name: nat; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3764 (class 0 OID 620335)
-- Dependencies: 2351
-- Data for Name: natinterface; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3762 (class 0 OID 620324)
-- Dependencies: 2349
-- Data for Name: nattointf; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3765 (class 0 OID 620344)
-- Dependencies: 2353
-- Data for Name: nd; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3706 (class 0 OID 619632)
-- Dependencies: 2255
-- Data for Name: nomp_appliance; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO nomp_appliance (id, strhostname, strdescription, stripaddr, iserveport, bhome, blive, bmodified, imaxdevicecount, ibapport, ipri, telnet_user, telnet_pwd) VALUES (0, '0a5de35861244af0a7744f73da892b4f', NULL, NULL, 0, 0, 0, 0, 1500, 7813, 1, NULL, NULL);


--
-- TOC entry 3766 (class 0 OID 620356)
-- Dependencies: 2356
-- Data for Name: nomp_enablepasswd; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3767 (class 0 OID 620370)
-- Dependencies: 2359
-- Data for Name: nomp_jumpbox; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3768 (class 0 OID 620386)
-- Dependencies: 2362
-- Data for Name: nomp_snmproinfo; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3792 (class 0 OID 620716)
-- Dependencies: 2476
-- Data for Name: nomp_snmprwinfo; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3769 (class 0 OID 620405)
-- Dependencies: 2365
-- Data for Name: nomp_telnetinfo; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3793 (class 0 OID 620724)
-- Dependencies: 2479
-- Data for Name: object_customized_attribute; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO object_customized_attribute (id, objectid, name, alias, allow_export, type, allow_modify_exported, lasttimestamp) VALUES (1, 1, 'devicename', 'Hostname', true, 1, false, '2012-09-04 10:41:38.932');
INSERT INTO object_customized_attribute (id, objectid, name, alias, allow_export, type, allow_modify_exported, lasttimestamp) VALUES (2, 1, 'managementip', 'Management IP', true, 1, false, '2012-09-04 10:41:38.932');
INSERT INTO object_customized_attribute (id, objectid, name, alias, allow_export, type, allow_modify_exported, lasttimestamp) VALUES (3, 1, 'managementinterfacename', 'Management Interface', true, 1, false, '2012-09-04 10:41:38.932');
INSERT INTO object_customized_attribute (id, objectid, name, alias, allow_export, type, allow_modify_exported, lasttimestamp) VALUES (4, 1, 'devicetype', 'Device Type', true, 1, true, '2012-09-04 10:41:38.932');
INSERT INTO object_customized_attribute (id, objectid, name, alias, allow_export, type, allow_modify_exported, lasttimestamp) VALUES (5, 1, 'vendor', 'Vendor', true, 1, true, '2012-09-04 10:41:38.932');
INSERT INTO object_customized_attribute (id, objectid, name, alias, allow_export, type, allow_modify_exported, lasttimestamp) VALUES (6, 1, 'model', 'Model', true, 1, true, '2012-09-04 10:41:38.932');
INSERT INTO object_customized_attribute (id, objectid, name, alias, allow_export, type, allow_modify_exported, lasttimestamp) VALUES (7, 1, 'softwareversion', 'Software Version', true, 1, true, '2012-09-04 10:41:38.932');
INSERT INTO object_customized_attribute (id, objectid, name, alias, allow_export, type, allow_modify_exported, lasttimestamp) VALUES (8, 1, 'serialnumber', 'Serial Number', true, 1, true, '2012-09-04 10:41:38.932');
INSERT INTO object_customized_attribute (id, objectid, name, alias, allow_export, type, allow_modify_exported, lasttimestamp) VALUES (9, 1, 'assettag', 'Asset Tag', true, 1, true, '2012-09-04 10:41:38.932');
INSERT INTO object_customized_attribute (id, objectid, name, alias, allow_export, type, allow_modify_exported, lasttimestamp) VALUES (10, 1, 'systemmemory', 'System Memory', true, 1, true, '2012-09-04 10:41:38.932');
INSERT INTO object_customized_attribute (id, objectid, name, alias, allow_export, type, allow_modify_exported, lasttimestamp) VALUES (11, 1, 'location', 'Location', true, 1, true, '2012-09-04 10:41:38.932');
INSERT INTO object_customized_attribute (id, objectid, name, alias, allow_export, type, allow_modify_exported, lasttimestamp) VALUES (12, 1, 'contact', 'Contact', true, 1, true, '2012-09-04 10:41:38.932');
INSERT INTO object_customized_attribute (id, objectid, name, alias, allow_export, type, allow_modify_exported, lasttimestamp) VALUES (13, 1, 'site', 'In Site', true, 1, true, '2012-09-04 10:41:38.932');
INSERT INTO object_customized_attribute (id, objectid, name, alias, allow_export, type, allow_modify_exported, lasttimestamp) VALUES (14, 1, 'hierarchylayer', 'Hierarchy Layer', true, 1, true, '2012-09-04 10:41:38.932');
INSERT INTO object_customized_attribute (id, objectid, name, alias, allow_export, type, allow_modify_exported, lasttimestamp) VALUES (15, 1, 'description', 'Description', true, 1, true, '2012-09-04 10:41:38.932');
INSERT INTO object_customized_attribute (id, objectid, name, alias, allow_export, type, allow_modify_exported, lasttimestamp) VALUES (16, 1, 'Field1', 'Field1', true, 2, true, '2012-09-04 10:41:38.932');
INSERT INTO object_customized_attribute (id, objectid, name, alias, allow_export, type, allow_modify_exported, lasttimestamp) VALUES (17, 1, 'Field2', 'Field2', true, 2, true, '2012-09-04 10:41:38.932');
INSERT INTO object_customized_attribute (id, objectid, name, alias, allow_export, type, allow_modify_exported, lasttimestamp) VALUES (18, 1, 'Field3', 'Field3', true, 2, true, '2012-09-04 10:41:38.932');
INSERT INTO object_customized_attribute (id, objectid, name, alias, allow_export, type, allow_modify_exported, lasttimestamp) VALUES (19, 4, 'devicename', 'Device Name', true, 1, true, '2012-09-04 10:41:38.932');
INSERT INTO object_customized_attribute (id, objectid, name, alias, allow_export, type, allow_modify_exported, lasttimestamp) VALUES (20, 4, 'slot', 'Slot', true, 1, false, '2012-09-04 10:41:38.932');
INSERT INTO object_customized_attribute (id, objectid, name, alias, allow_export, type, allow_modify_exported, lasttimestamp) VALUES (21, 4, 'cardtype', 'Module Type', true, 1, false, '2012-09-04 10:41:38.932');
INSERT INTO object_customized_attribute (id, objectid, name, alias, allow_export, type, allow_modify_exported, lasttimestamp) VALUES (22, 4, 'ports', 'Ports', true, 1, true, '2012-09-04 10:41:38.932');
INSERT INTO object_customized_attribute (id, objectid, name, alias, allow_export, type, allow_modify_exported, lasttimestamp) VALUES (23, 4, 'serialnumber', 'Serial Number', true, 1, true, '2012-09-04 10:41:38.932');
INSERT INTO object_customized_attribute (id, objectid, name, alias, allow_export, type, allow_modify_exported, lasttimestamp) VALUES (24, 4, 'hwrev', 'HW Rev', true, 1, true, '2012-09-04 10:41:38.932');
INSERT INTO object_customized_attribute (id, objectid, name, alias, allow_export, type, allow_modify_exported, lasttimestamp) VALUES (25, 4, 'fwrev', 'FW Rev', true, 1, true, '2012-09-04 10:41:38.932');
INSERT INTO object_customized_attribute (id, objectid, name, alias, allow_export, type, allow_modify_exported, lasttimestamp) VALUES (26, 4, 'swrev', 'SW Rev', true, 1, true, '2012-09-04 10:41:38.932');
INSERT INTO object_customized_attribute (id, objectid, name, alias, allow_export, type, allow_modify_exported, lasttimestamp) VALUES (27, 4, 'carddescription', 'Description', true, 1, true, '2012-09-04 10:41:38.932');
INSERT INTO object_customized_attribute (id, objectid, name, alias, allow_export, type, allow_modify_exported, lasttimestamp) VALUES (28, 4, 'Field1', 'Field1', true, 2, true, '2012-09-04 10:41:38.932');
INSERT INTO object_customized_attribute (id, objectid, name, alias, allow_export, type, allow_modify_exported, lasttimestamp) VALUES (29, 4, 'Field2', 'Field2', true, 2, true, '2012-09-04 10:41:38.932');
INSERT INTO object_customized_attribute (id, objectid, name, alias, allow_export, type, allow_modify_exported, lasttimestamp) VALUES (30, 4, 'Field3', 'Field3', true, 2, true, '2012-09-04 10:41:38.932');
INSERT INTO object_customized_attribute (id, objectid, name, alias, allow_export, type, allow_modify_exported, lasttimestamp) VALUES (31, 2, 'devicename', 'Device Name', true, 1, true, '2012-09-04 10:41:38.932');
INSERT INTO object_customized_attribute (id, objectid, name, alias, allow_export, type, allow_modify_exported, lasttimestamp) VALUES (32, 2, 'interfacename', 'Interface Name', true, 1, false, '2012-09-04 10:41:38.932');
INSERT INTO object_customized_attribute (id, objectid, name, alias, allow_export, type, allow_modify_exported, lasttimestamp) VALUES (33, 2, 'interfaceip', 'Interface IP', true, 1, false, '2012-09-04 10:41:38.932');
INSERT INTO object_customized_attribute (id, objectid, name, alias, allow_export, type, allow_modify_exported, lasttimestamp) VALUES (34, 2, 'mibindex', 'MIB Index', true, 1, true, '2012-09-04 10:41:38.932');
INSERT INTO object_customized_attribute (id, objectid, name, alias, allow_export, type, allow_modify_exported, lasttimestamp) VALUES (35, 2, 'bandwidth', 'Bandwidth', true, 1, true, '2012-09-04 10:41:38.932');
INSERT INTO object_customized_attribute (id, objectid, name, alias, allow_export, type, allow_modify_exported, lasttimestamp) VALUES (36, 2, 'speed', 'Speed', true, 1, true, '2012-09-04 10:41:38.932');
INSERT INTO object_customized_attribute (id, objectid, name, alias, allow_export, type, allow_modify_exported, lasttimestamp) VALUES (37, 2, 'duplex', 'Duplex', true, 1, true, '2012-09-04 10:41:38.932');
INSERT INTO object_customized_attribute (id, objectid, name, alias, allow_export, type, allow_modify_exported, lasttimestamp) VALUES (38, 2, 'interfacestatus', 'Live Status', true, 1, true, '2012-09-04 10:41:38.932');
INSERT INTO object_customized_attribute (id, objectid, name, alias, allow_export, type, allow_modify_exported, lasttimestamp) VALUES (39, 2, 'macaddress', 'MAC Address', true, 1, true, '2012-09-04 10:41:38.932');
INSERT INTO object_customized_attribute (id, objectid, name, alias, allow_export, type, allow_modify_exported, lasttimestamp) VALUES (40, 2, 'moduleslot', 'Slot#', true, 1, true, '2012-09-04 10:41:38.932');
INSERT INTO object_customized_attribute (id, objectid, name, alias, allow_export, type, allow_modify_exported, lasttimestamp) VALUES (41, 2, 'moduletype', 'Module Type', true, 1, true, '2012-09-04 10:41:38.932');
INSERT INTO object_customized_attribute (id, objectid, name, alias, allow_export, type, allow_modify_exported, lasttimestamp) VALUES (42, 2, 'description', 'Description', true, 1, true, '2012-09-04 10:41:38.932');
INSERT INTO object_customized_attribute (id, objectid, name, alias, allow_export, type, allow_modify_exported, lasttimestamp) VALUES (43, 2, 'Field1', 'Field1', true, 2, true, '2012-09-04 10:41:38.932');
INSERT INTO object_customized_attribute (id, objectid, name, alias, allow_export, type, allow_modify_exported, lasttimestamp) VALUES (44, 2, 'Field2', 'Field2', true, 2, true, '2012-09-04 10:41:38.932');
INSERT INTO object_customized_attribute (id, objectid, name, alias, allow_export, type, allow_modify_exported, lasttimestamp) VALUES (45, 2, 'Field3', 'Field3', true, 2, true, '2012-09-04 10:41:38.932');
INSERT INTO object_customized_attribute (id, objectid, name, alias, allow_export, type, allow_modify_exported, lasttimestamp) VALUES (46, 5, 'Name', 'Name', true, 1, false, '2012-09-04 10:41:38.932');
INSERT INTO object_customized_attribute (id, objectid, name, alias, allow_export, type, allow_modify_exported, lasttimestamp) VALUES (47, 5, 'Region', 'Region', true, 1, true, '2012-09-04 10:41:38.932');
INSERT INTO object_customized_attribute (id, objectid, name, alias, allow_export, type, allow_modify_exported, lasttimestamp) VALUES (48, 5, 'Location/Address', 'Location/Address', true, 1, true, '2012-09-04 10:41:38.932');
INSERT INTO object_customized_attribute (id, objectid, name, alias, allow_export, type, allow_modify_exported, lasttimestamp) VALUES (49, 5, 'Employee Number', 'Employee Number', true, 1, true, '2012-09-04 10:41:38.932');
INSERT INTO object_customized_attribute (id, objectid, name, alias, allow_export, type, allow_modify_exported, lasttimestamp) VALUES (50, 5, 'Device Count', 'Device Count', true, 1, true, '2012-09-04 10:41:38.932');
INSERT INTO object_customized_attribute (id, objectid, name, alias, allow_export, type, allow_modify_exported, lasttimestamp) VALUES (51, 5, 'Contact Name', 'Contact Name', true, 1, true, '2012-09-04 10:41:38.932');
INSERT INTO object_customized_attribute (id, objectid, name, alias, allow_export, type, allow_modify_exported, lasttimestamp) VALUES (52, 5, 'Phone Number', 'Phone Number', true, 1, true, '2012-09-04 10:41:38.932');
INSERT INTO object_customized_attribute (id, objectid, name, alias, allow_export, type, allow_modify_exported, lasttimestamp) VALUES (53, 5, 'Email', 'Email', true, 1, true, '2012-09-04 10:41:38.932');
INSERT INTO object_customized_attribute (id, objectid, name, alias, allow_export, type, allow_modify_exported, lasttimestamp) VALUES (54, 5, 'Type', 'Type', true, 1, true, '2012-09-04 10:41:38.932');
INSERT INTO object_customized_attribute (id, objectid, name, alias, allow_export, type, allow_modify_exported, lasttimestamp) VALUES (55, 5, 'Description', 'Description', true, 1, true, '2012-09-04 10:41:38.932');
INSERT INTO object_customized_attribute (id, objectid, name, alias, allow_export, type, allow_modify_exported, lasttimestamp) VALUES (56, 5, 'Field1', 'Field1', true, 2, true, '2012-09-04 10:41:38.932');
INSERT INTO object_customized_attribute (id, objectid, name, alias, allow_export, type, allow_modify_exported, lasttimestamp) VALUES (57, 5, 'Field2', 'Field2', true, 2, true, '2012-09-04 10:41:38.932');
INSERT INTO object_customized_attribute (id, objectid, name, alias, allow_export, type, allow_modify_exported, lasttimestamp) VALUES (58, 5, 'Field3', 'Field3', true, 2, true, '2012-09-04 10:41:38.932');
INSERT INTO object_customized_attribute (id, objectid, name, alias, allow_export, type, allow_modify_exported, lasttimestamp) VALUES (59, 6, 'Circuite ID', 'Circuite ID', true, 1, true, '2012-09-04 10:41:38.932');
INSERT INTO object_customized_attribute (id, objectid, name, alias, allow_export, type, allow_modify_exported, lasttimestamp) VALUES (60, 6, 'Data rate', 'Data rate', true, 1, true, '2012-09-04 10:41:38.932');
INSERT INTO object_customized_attribute (id, objectid, name, alias, allow_export, type, allow_modify_exported, lasttimestamp) VALUES (61, 6, 'Carrier', 'Carrier', true, 1, true, '2012-09-04 10:41:38.932');
INSERT INTO object_customized_attribute (id, objectid, name, alias, allow_export, type, allow_modify_exported, lasttimestamp) VALUES (62, 6, 'SLA', 'SLA', true, 1, true, '2012-09-04 10:41:38.932');
INSERT INTO object_customized_attribute (id, objectid, name, alias, allow_export, type, allow_modify_exported, lasttimestamp) VALUES (63, 6, 'Field1', 'Field1', true, 2, true, '2012-09-04 10:41:38.932');
INSERT INTO object_customized_attribute (id, objectid, name, alias, allow_export, type, allow_modify_exported, lasttimestamp) VALUES (64, 6, 'Field2', 'Field2', true, 2, true, '2012-09-04 10:41:38.932');
INSERT INTO object_customized_attribute (id, objectid, name, alias, allow_export, type, allow_modify_exported, lasttimestamp) VALUES (65, 6, 'Field3', 'Field3', true, 2, true, '2012-09-04 10:41:38.932');
INSERT INTO object_customized_attribute (id, objectid, name, alias, allow_export, type, allow_modify_exported, lasttimestamp) VALUES (67, 1, 'macaddress', 'MAC Address', true, 1, true, '2012-09-04 10:41:38.932');
INSERT INTO object_customized_attribute (id, objectid, name, alias, allow_export, type, allow_modify_exported, lasttimestamp) VALUES (68, 1, 'group', 'Group', true, 1, true, '2012-09-04 10:41:38.932');
INSERT INTO object_customized_attribute (id, objectid, name, alias, allow_export, type, allow_modify_exported, lasttimestamp) VALUES (69, 1, 'primarycontroller', 'Primary Controller', true, 1, true, '2012-09-04 10:41:38.932');
INSERT INTO object_customized_attribute (id, objectid, name, alias, allow_export, type, allow_modify_exported, lasttimestamp) VALUES (70, 1, 'secondarycontroller', 'Secondary Controller', true, 1, true, '2012-09-04 10:41:38.932');
INSERT INTO object_customized_attribute (id, objectid, name, alias, allow_export, type, allow_modify_exported, lasttimestamp) VALUES (71, 1, 'defaultgateway', 'Default Gateway', true, 1, true, '2012-09-04 10:41:38.932');
INSERT INTO object_customized_attribute (id, objectid, name, alias, allow_export, type, allow_modify_exported, lasttimestamp) VALUES (72, 1, 'sysobjectid', 'sysObjectID', true, 1, true, '2012-09-04 10:41:39.994');
INSERT INTO object_customized_attribute (id, objectid, name, alias, allow_export, type, allow_modify_exported, lasttimestamp) VALUES (73, 1, 'findtime', 'First Discovered At', true, 1, true, '2012-09-04 10:41:40.025');
INSERT INTO object_customized_attribute (id, objectid, name, alias, allow_export, type, allow_modify_exported, lasttimestamp) VALUES (74, 1, 'lasttime', 'Last Discovered At', true, 1, true, '2012-09-04 10:41:40.025');
INSERT INTO object_customized_attribute (id, objectid, name, alias, allow_export, type, allow_modify_exported, lasttimestamp) VALUES (75, 1, 'driver', 'Driver', false, 1, false, '2012-09-04 10:41:44.135');


--
-- TOC entry 3722 (class 0 OID 619862)
-- Dependencies: 2281
-- Data for Name: object_file_info; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (1, 39, 3, 1, 'Juniper SRX Firewall.emf', 'af1b881617554bfvgrg4272b634574915.emf', '2012-09-04 10:41:43.682', 1, '', '2012-09-04 10:41:43.682', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (2, 39, 3, 1, 'Juniper SRX Firewall_CheckFail.emf', 'af1b881617554b4ghhdc272b634574915.emf', '2012-09-04 10:41:43.697', 1, '', '2012-09-04 10:41:43.697', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (3, 39, 3, 1, 'Juniper SRX Firewall_Down.emf', 'af1b881617554b448d1272b63455t455.emf', '2012-09-04 10:41:43.713', 1, '', '2012-09-04 10:41:43.713', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (4, 39, 3, 1, 'Juniper SRX Firewall_Unstable.emf', 'af1b856485fd554b448d1272b634574915.emf', '2012-09-04 10:41:43.713', 1, '', '2012-09-04 10:41:43.713', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (5, 39, 3, 1, 'Juniper SRX Firewall_Up.emf', 'a5f4d81617554b448d1272b634574915.emf', '2012-09-04 10:41:43.713', 1, '', '2012-09-04 10:41:43.713', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (6, 38, 3, 1, 'Cisco IOS XR.emf', '0001affeb5cc433a97fbb956932649b6.emf', '2012-09-04 10:41:43.713', 1, '', '2012-09-04 10:41:43.713', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (7, 38, 3, 1, 'Cisco IOS XR_CheckFail.emf', '0002affeb5cc433a97fbb956932649b6.emf', '2012-09-04 10:41:43.713', 1, '', '2012-09-04 10:41:43.713', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (8, 38, 3, 1, 'Cisco IOS XR_Down.emf', '0003affeb5cc433a97fbb956932649b6.emf', '2012-09-04 10:41:43.729', 1, '', '2012-09-04 10:41:43.729', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (9, 38, 3, 1, 'Cisco IOS XR_Unstable.emf', '0004affeb5cc433a97fbb956932649b6.emf', '2012-09-04 10:41:43.729', 1, '', '2012-09-04 10:41:43.729', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (10, 38, 3, 1, 'Cisco IOS XR_Up.emf', '0005affeb5cc433a97fbb956932649b6.emf', '2012-09-04 10:41:43.729', 1, '', '2012-09-04 10:41:43.729', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (11, 1, 3, 1, 'Cisco Catalyst Switch.emf', 'a91f61ab9ea249b2abbe1b4052dda363.emf', '2012-09-04 10:41:43.729', 1, '', '2012-09-04 10:41:43.729', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (12, 1, 3, 1, 'Cisco Catalyst Switch_CheckFail.emf', 'fae9848ce0cd40089236b7f482327b85.emf', '2012-09-04 10:41:43.729', 1, '', '2012-09-04 10:41:43.729', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (13, 1, 3, 1, 'Cisco Catalyst Switch_Down.emf', '8c3d1ecb2a4e40038b01e012f556e73a.emf', '2012-09-04 10:41:43.729', 1, '', '2012-09-04 10:41:43.729', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (14, 1, 3, 1, 'Cisco Catalyst Switch_Unstable.emf', '5c987700bccc47c7b84a6612c75422f9.emf', '2012-09-04 10:41:43.729', 1, '', '2012-09-04 10:41:43.729', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (15, 1, 3, 1, 'Cisco Catalyst Switch_Up.emf', 'dcb7a47fb0cd4c08bd27a0bf2796c2c9.emf', '2012-09-04 10:41:43.744', 1, '', '2012-09-04 10:41:43.744', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (16, 2, 3, 1, 'Cisco Router.emf', '15a626425e984efea7ba25a4a0deefd0.emf', '2012-09-04 10:41:43.744', 1, '', '2012-09-04 10:41:43.744', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (17, 2, 3, 1, 'Cisco Router_CheckFail.emf', '4c8ae85e3193468da881893dad5705ef.emf', '2012-09-04 10:41:43.744', 1, '', '2012-09-04 10:41:43.744', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (18, 2, 3, 1, 'Cisco Router_Down.emf', 'ff5889ba8ebb40099e88e7fd12819828.emf', '2012-09-04 10:41:43.744', 1, '', '2012-09-04 10:41:43.744', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (19, 2, 3, 1, 'Cisco Router_Unstable.emf', 'ff441694507a4187891479aa1ba20d55.emf', '2012-09-04 10:41:43.744', 1, '', '2012-09-04 10:41:43.744', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (20, 2, 3, 1, 'Cisco Router_Up.emf', 'e6b63a0360474679b41e9577ba189cbb.emf', '2012-09-04 10:41:43.744', 1, '', '2012-09-04 10:41:43.744', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (21, 3, 3, 1, 'Cisco IOS Switch.emf', 'ddb31a466b064f7da440d8006f7f3064.emf', '2012-09-04 10:41:43.744', 1, '', '2012-09-04 10:41:43.744', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (22, 3, 3, 1, 'Cisco IOS Switch_CheckFail.emf', '30451613f01042ca84563f755f207273.emf', '2012-09-04 10:41:43.744', 1, '', '2012-09-04 10:41:43.744', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (23, 3, 3, 1, 'Cisco IOS Switch_Down.emf', '82492a151bed4b8baf908596baad0e1c.emf', '2012-09-04 10:41:43.76', 1, '', '2012-09-04 10:41:43.76', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (24, 3, 3, 1, 'Cisco IOS Switch_Unstable.emf', 'b8719f1176ba4f5e818176e1d0b0b3a3.emf', '2012-09-04 10:41:43.76', 1, '', '2012-09-04 10:41:43.76', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (25, 3, 3, 1, 'Cisco IOS Switch_Up.emf', 'e80453a89a4e42d9a5b3d2a6c11b371c.emf', '2012-09-04 10:41:43.76', 1, '', '2012-09-04 10:41:43.76', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (26, 3, 3, 1, 'L3 IOS Switch.emf', '80e85d3645c9458c9eb9d86d1e4ab560.emf', '2012-09-04 10:41:43.76', 1, '', '2012-09-04 10:41:43.76', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (27, 3, 3, 1, 'L3 IOS Switch_CheckFail.emf', 'e61fb68914824a8aa174c60aa066e124.emf', '2012-09-04 10:41:43.76', 1, '', '2012-09-04 10:41:43.76', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (28, 3, 3, 1, 'L3 IOS Switch_Down.emf', 'b3159d8c14c741f3b506e2ffc4db5219.emf', '2012-09-04 10:41:43.776', 1, '', '2012-09-04 10:41:43.776', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (29, 3, 3, 1, 'L3 IOS Switch_Unstable.emf', 'e5b63c452b35428d89f940c04c0700b6.emf', '2012-09-04 10:41:43.776', 1, '', '2012-09-04 10:41:43.776', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (30, 3, 3, 1, 'L3 IOS Switch_Up.emf', '148574c656e5413ba8dc5bd8d1180d68.emf', '2012-09-04 10:41:43.776', 1, '', '2012-09-04 10:41:43.776', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (31, 4, 3, 1, 'Cisco PIX Firewall.emf', '28c0cfdd5f6b4e8d81d6bfc589e9e37c.emf', '2012-09-04 10:41:43.776', 1, '', '2012-09-04 10:41:43.776', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (32, 4, 3, 1, 'Cisco PIX Firewall_CheckFail.emf', '21257c8bf0ce42898b573290c33d5ab1.emf', '2012-09-04 10:41:43.776', 1, '', '2012-09-04 10:41:43.776', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (33, 4, 3, 1, 'Cisco PIX Firewall_Down.emf', 'ddb85a42cc0c408e88011d4557627e3d.emf', '2012-09-04 10:41:43.776', 1, '', '2012-09-04 10:41:43.776', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (34, 4, 3, 1, 'Cisco PIX Firewall_Unstable.emf', '5708956704b64e42a55ce8f3c0c1e736.emf', '2012-09-04 10:41:43.791', 1, '', '2012-09-04 10:41:43.791', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (35, 4, 3, 1, 'Cisco PIX Firewall_Up.emf', '02f2f1234be5448f9bafea854c6c7a4e.emf', '2012-09-04 10:41:43.791', 1, '', '2012-09-04 10:41:43.791', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (36, 5, 3, 1, 'End System.emf', 'ae549136b3fa45d7bf1aeab5cd405afa.emf', '2012-09-04 10:41:43.791', 1, '', '2012-09-04 10:41:43.791', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (37, 5, 3, 1, 'End System_CheckFail.emf', '0f057537df5f4cc1be60e00f4dd9eb2f.emf', '2012-09-04 10:41:43.791', 1, '', '2012-09-04 10:41:43.791', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (38, 5, 3, 1, 'End System_Down.emf', 'cd1e4e2a5c3a417aa0bff632b0344b8c.emf', '2012-09-04 10:41:43.791', 1, '', '2012-09-04 10:41:43.791', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (39, 5, 3, 1, 'End System_Unstable.emf', '97fb910ba09c49b0809ea1036e4656a4.emf', '2012-09-04 10:41:43.791', 1, '', '2012-09-04 10:41:43.791', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (40, 5, 3, 1, 'End System_Up.emf', 'b670bb4c99e94b6db6dd72da5f245786.emf', '2012-09-04 10:41:43.791', 1, '', '2012-09-04 10:41:43.791', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (41, 6, 3, 1, 'LAN.emf', 'be99352194694462ab27c2b4d24d17ae.emf', '2012-09-04 10:41:43.791', 1, '', '2012-09-04 10:41:43.791', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (42, 6, 3, 1, 'LAN_CheckFail.emf', 'bfee7c25335e406ca62fcd74a0426c4e.emf', '2012-09-04 10:41:43.791', 1, '', '2012-09-04 10:41:43.791', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (43, 7, 3, 1, 'WAN.emf', '4c0d6963583c4314b1c4840bc003e9d6.emf', '2012-09-04 10:41:43.791', 1, '', '2012-09-04 10:41:43.791', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (44, 7, 3, 1, 'WAN_CheckFail.emf', '3c669e9a699c4ae4a2cbb08dee52ada5.emf', '2012-09-04 10:41:43.807', 1, '', '2012-09-04 10:41:43.807', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (45, 8, 3, 1, 'MPLS Cloud.emf', '2efc1da7de8c4eafa9d30c7061f3dc5d.emf', '2012-09-04 10:41:43.807', 1, '', '2012-09-04 10:41:43.807', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (46, 8, 3, 1, 'MPLS Cloud_CheckFail.emf', 'ae69ac7224ec4a6eab2c785396887887.emf', '2012-09-04 10:41:43.807', 1, '', '2012-09-04 10:41:43.807', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (47, 8, 3, 1, 'MPLS Cloud_Down.emf', '0b7f990267cb4e71bb2e8ee1fddc498f.emf', '2012-09-04 10:41:43.807', 1, '', '2012-09-04 10:41:43.807', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (48, 8, 3, 1, 'MPLS Cloud_Unstable.emf', 'cce02cf16ec54608877b68e9dbef550a.emf', '2012-09-04 10:41:43.807', 1, '', '2012-09-04 10:41:43.807', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (49, 8, 3, 1, 'MPLS Cloud_Up.emf', '897b2bcbb5bb4bb99d005aacb6f351a0.emf', '2012-09-04 10:41:43.807', 1, '', '2012-09-04 10:41:43.807', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (50, 9, 3, 1, 'Call Manager.emf', '2ae6dad917394fdaa4d3834bd9bd9866.emf', '2012-09-04 10:41:43.807', 1, '', '2012-09-04 10:41:43.807', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (51, 9, 3, 1, 'Call Manager_CheckFail.emf', 'dd8430e166874c7a85f84f655f106437.emf', '2012-09-04 10:41:43.822', 1, '', '2012-09-04 10:41:43.822', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (52, 9, 3, 1, 'Call Manager_Down.emf', '1ebdcd245f6648c7aa31c5bc22373240.emf', '2012-09-04 10:41:43.822', 1, '', '2012-09-04 10:41:43.822', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (53, 9, 3, 1, 'Call Manager_Unstable.emf', 'd7edeb84cf7547718da3ede4798952c2.emf', '2012-09-04 10:41:43.822', 1, '', '2012-09-04 10:41:43.822', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (54, 9, 3, 1, 'Call Manager_Up.emf', '59f8a9f2d0ef477b857cbbd80ad3eaf9.emf', '2012-09-04 10:41:43.822', 1, '', '2012-09-04 10:41:43.822', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (55, 10, 3, 1, 'IP Phone.emf', 'ec7205f600004a99931fbc80c2c0132e.emf', '2012-09-04 10:41:43.822', 1, '', '2012-09-04 10:41:43.822', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (56, 10, 3, 1, 'IP Phone_CheckFail.emf', '497a8b0bd02f48bdb939518d7fcc0ad0.emf', '2012-09-04 10:41:43.822', 1, '', '2012-09-04 10:41:43.822', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (57, 10, 3, 1, 'IP Phone_Down.emf', '5986e93d89164b538f2513a4eed4fb7d.emf', '2012-09-04 10:41:43.838', 1, '', '2012-09-04 10:41:43.838', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (58, 10, 3, 1, 'IP Phone_Unstable.emf', '3ccb33210b504650a601462221cd9583.emf', '2012-09-04 10:41:43.838', 1, '', '2012-09-04 10:41:43.838', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (59, 10, 3, 1, 'IP Phone_Up.emf', 'c45e38abc05a409fbc7322d6410a0a58.emf', '2012-09-04 10:41:43.838', 1, '', '2012-09-04 10:41:43.838', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (60, 11, 3, 1, 'Cisco WAP.emf', 'af1b881617554b448d1272b634574915.emf', '2012-09-04 10:41:43.854', 1, '', '2012-09-04 10:41:43.854', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (61, 11, 3, 1, 'Cisco WAP_CheckFail.emf', '4550326cae1f4728a8932d391595799f.emf', '2012-09-04 10:41:43.854', 1, '', '2012-09-04 10:41:43.854', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (62, 11, 3, 1, 'Cisco WAP_Down.emf', '15906a5f2afc4d2eb023b308950ac3b5.emf', '2012-09-04 10:41:43.854', 1, '', '2012-09-04 10:41:43.854', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (63, 11, 3, 1, 'Cisco WAP_Unstable.emf', 'e0b015d3c4b44f7aa9387a6935d048e3.emf', '2012-09-04 10:41:43.854', 1, '', '2012-09-04 10:41:43.854', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (64, 11, 3, 1, 'Cisco WAP_Up.emf', '6505a94b51244e85a9b6dde546bde8ad.emf', '2012-09-04 10:41:43.854', 1, '', '2012-09-04 10:41:43.854', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (65, 12, 3, 1, 'Cisco ASA Firewall.emf', 'f8ae34b6bed148e586aecac92148af69.emf', '2012-09-04 10:41:43.869', 1, '', '2012-09-04 10:41:43.869', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (66, 12, 3, 1, 'Cisco ASA Firewall_CheckFail.emf', 'b104e25461d24886baf026ecf3f924ad.emf', '2012-09-04 10:41:43.869', 1, '', '2012-09-04 10:41:43.869', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (67, 12, 3, 1, 'Cisco ASA Firewall_Down.emf', '30323c40a3d346b4ba2b3a0e44c6f9ed.emf', '2012-09-04 10:41:43.869', 1, '', '2012-09-04 10:41:43.869', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (68, 12, 3, 1, 'Cisco ASA Firewall_Unstable.emf', 'ab75d9c50a464fa091f7bc419a09fab8.emf', '2012-09-04 10:41:43.869', 1, '', '2012-09-04 10:41:43.869', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (69, 12, 3, 1, 'Cisco ASA Firewall_Up.emf', 'd591b66b06634b6cb90cb1210717d84e.emf', '2012-09-04 10:41:43.869', 1, '', '2012-09-04 10:41:43.869', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (70, 13, 3, 1, 'Juniper Router.emf', 'bad8de4f152247fd9fd635f155252d58.emf', '2012-09-04 10:41:43.885', 1, '', '2012-09-04 10:41:43.885', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (71, 13, 3, 1, 'Juniper Router_CheckFail.emf', '9386cbc18e0948d78909db5541ef94ec.emf', '2012-09-04 10:41:43.885', 1, '', '2012-09-04 10:41:43.885', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (72, 13, 3, 1, 'Juniper Router_Down.emf', 'c2d24a9c2615488a9738b73d616681a9.emf', '2012-09-04 10:41:43.885', 1, '', '2012-09-04 10:41:43.885', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (73, 13, 3, 1, 'Juniper Router_Unstable.emf', '4f413236fdbf4d978cfd8ec20a96de38.emf', '2012-09-04 10:41:43.885', 1, '', '2012-09-04 10:41:43.885', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (74, 13, 3, 1, 'Juniper Router_Up.emf', '6e6a8d733fda4b97a4a927beacc25c31.emf', '2012-09-04 10:41:43.885', 1, '', '2012-09-04 10:41:43.885', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (75, 14, 3, 1, 'NetScreen Firewall.emf', '74bdf71fbe1f4be8a7fde4f841815805.emf', '2012-09-04 10:41:43.885', 1, '', '2012-09-04 10:41:43.885', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (76, 14, 3, 1, 'NetScreen Firewall_CheckFail.emf', '3f12dd96b3fd40189e59ef1a4d8d8618.emf', '2012-09-04 10:41:43.885', 1, '', '2012-09-04 10:41:43.885', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (77, 14, 3, 1, 'NetScreen Firewall_Down.emf', '6e076e1fb0944deeaccd638ec4230ae3.emf', '2012-09-04 10:41:43.885', 1, '', '2012-09-04 10:41:43.885', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (78, 14, 3, 1, 'NetScreen Firewall_Unstable.emf', 'dd5e1bdebeae4d42870e5ef5cd0be5ac.emf', '2012-09-04 10:41:43.901', 1, '', '2012-09-04 10:41:43.901', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (79, 14, 3, 1, 'NetScreen Firewall_Up.emf', '5836b049256541f28c7a6c19a69dec60.emf', '2012-09-04 10:41:43.901', 1, '', '2012-09-04 10:41:43.901', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (80, 15, 3, 1, 'Extreme Switch.emf', 'e489a8276e9e45d995841cd9f3e80388.emf', '2012-09-04 10:41:43.901', 1, '', '2012-09-04 10:41:43.901', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (81, 15, 3, 1, 'Extreme Switch_CheckFail.emf', 'd8fb3b45888644768200158c8776659a.emf', '2012-09-04 10:41:43.901', 1, '', '2012-09-04 10:41:43.901', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (82, 15, 3, 1, 'Extreme Switch_Down.emf', '223a2dd8920c4bfab8ac45250f45f585.emf', '2012-09-04 10:41:43.901', 1, '', '2012-09-04 10:41:43.901', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (83, 15, 3, 1, 'Extreme Switch_Unstable.emf', 'e67157432db543aa88d8e8baa801ffaf.emf', '2012-09-04 10:41:43.901', 1, '', '2012-09-04 10:41:43.901', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (84, 15, 3, 1, 'Extreme Switch_Up.emf', '4da6703adb284f10b8d4d20d8044e06b.emf', '2012-09-04 10:41:43.901', 1, '', '2012-09-04 10:41:43.901', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (85, 16, 3, 1, 'Unclassified Device.emf', '35ace9b2bfdd486fa1ab8e57699a58d5.emf', '2012-09-04 10:41:43.916', 1, '', '2012-09-04 10:41:43.916', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (86, 16, 3, 1, 'Unclassified Device_CheckFail.emf', '89a2b950b7f84a818e7d6662dcc7da07.emf', '2012-09-04 10:41:43.916', 1, '', '2012-09-04 10:41:43.916', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (87, 16, 3, 1, 'Unclassified Device_Down.emf', '35d3aa24f2c5473cbd41ee1b555cd4c9.emf', '2012-09-04 10:41:43.916', 1, '', '2012-09-04 10:41:43.916', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (88, 16, 3, 1, 'Unclassified Device_Unstable.emf', '9d3d98d29f6e4b67b93116506dc9cbd9.emf', '2012-09-04 10:41:43.916', 1, '', '2012-09-04 10:41:43.916', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (89, 16, 3, 1, 'Unclassified Device_Up.emf', '6752c8685070405ca9ef9cc85f36453f.emf', '2012-09-04 10:41:43.916', 1, '', '2012-09-04 10:41:43.916', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (90, 17, 3, 1, 'Mute LAN.emf', 'fd751b9fb4f944df853abc1a33535c3b.emf', '2012-09-04 10:41:43.916', 1, '', '2012-09-04 10:41:43.916', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (91, 17, 3, 1, 'Mute LAN_CheckFail.emf', 'b7ea37c551ac4e25b1c4c61040f90254.emf', '2012-09-04 10:41:43.916', 1, '', '2012-09-04 10:41:43.916', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (92, 18, 3, 1, 'Checkpoint Firewall.emf', '30539aab3cf249909f75ef644672b309.emf', '2012-09-04 10:41:43.932', 1, '', '2012-09-04 10:41:43.932', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (93, 18, 3, 1, 'Checkpoint Firewall_CheckFail.emf', 'd7b3880a50fe4997b86820a42f175ba5.emf', '2012-09-04 10:41:43.932', 1, '', '2012-09-04 10:41:43.932', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (94, 18, 3, 1, 'Checkpoint Firewall_Down.emf', '587b72dd35c847c684ba61e58c7ab54b.emf', '2012-09-04 10:41:43.932', 1, '', '2012-09-04 10:41:43.932', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (95, 18, 3, 1, 'Checkpoint Firewall_Unstable.emf', '36caf8aabb014601b0bbfa7d3789cfa0.emf', '2012-09-04 10:41:43.932', 1, '', '2012-09-04 10:41:43.932', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (96, 18, 3, 1, 'Checkpoint Firewall_Up.emf', '180d8cf934f04dcbaca588a4751684f3.emf', '2012-09-04 10:41:43.932', 1, '', '2012-09-04 10:41:43.932', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (97, 19, 3, 1, 'F5 Load Balancer.emf', '61dc612a08dd4b9e9fc90c03da9378a0.emf', '2012-09-04 10:41:43.932', 1, '', '2012-09-04 10:41:43.932', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (98, 19, 3, 1, 'F5 Load Balancer_CheckFail.emf', '776c970626fc4a2abd02ef5213120158.emf', '2012-09-04 10:41:43.932', 1, '', '2012-09-04 10:41:43.932', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (99, 19, 3, 1, 'F5 Load Balancer_Down.emf', '5db5afef440a4821b8384c54eb554a57.emf', '2012-09-04 10:41:43.947', 1, '', '2012-09-04 10:41:43.947', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (100, 19, 3, 1, 'F5 Load Balancer_Unstable.emf', 'c91dbb30134e46db8f605da3a1173f3f.emf', '2012-09-04 10:41:43.947', 1, '', '2012-09-04 10:41:43.947', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (101, 19, 3, 1, 'F5 Load Balancer_Up.emf', 'a9b110434193484ea388452ad2ba7370.emf', '2012-09-04 10:41:43.947', 1, '', '2012-09-04 10:41:43.947', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (102, 20, 3, 1, 'Unclassified Router.emf', 'aaecf83c1c144a5eb282c82aeb5974d5.emf', '2012-09-04 10:41:43.947', 1, '', '2012-09-04 10:41:43.947', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (103, 20, 3, 1, 'Unclassified Router_CheckFail.emf', '40608dafd4aa47bb8af4ef26690cc628.emf', '2012-09-04 10:41:43.947', 1, '', '2012-09-04 10:41:43.947', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (104, 20, 3, 1, 'Unclassified Router_Down.emf', 'f74eca7599a345bf87594eccb25ba071.emf', '2012-09-04 10:41:43.947', 1, '', '2012-09-04 10:41:43.947', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (105, 20, 3, 1, 'Unclassified Router_Unstable.emf', '0991affeb5cc433a97fbb956932649b6.emf', '2012-09-04 10:41:43.947', 1, '', '2012-09-04 10:41:43.947', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (106, 20, 3, 1, 'Unclassified Router_Up.emf', '84c8632f34cd4d86a84adf67fc7b9007.emf', '2012-09-04 10:41:43.947', 1, '', '2012-09-04 10:41:43.947', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (107, 21, 3, 1, 'Unclassified Switch.emf', 'b73b21d8e0804fde99dc95f9d8180af1.emf', '2012-09-04 10:41:43.963', 1, '', '2012-09-04 10:41:43.963', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (108, 21, 3, 1, 'Unclassified Switch_CheckFail.emf', '71374840bd504ffdb074b9ece4a9b3c0.emf', '2012-09-04 10:41:43.963', 1, '', '2012-09-04 10:41:43.963', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (109, 21, 3, 1, 'Unclassified Switch_Down.emf', '64bcb77b97264ad5aaa8d66c8d1bdbc7.emf', '2012-09-04 10:41:43.963', 1, '', '2012-09-04 10:41:43.963', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (110, 21, 3, 1, 'Unclassified Switch_Unstable.emf', '5238574584af4973a5c018218708ee53.emf', '2012-09-04 10:41:43.963', 1, '', '2012-09-04 10:41:43.963', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (111, 21, 3, 1, 'Unclassified Switch_Up.emf', '129fa603c7824d94923bfde4f044dbca.emf', '2012-09-04 10:41:43.963', 1, '', '2012-09-04 10:41:43.963', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (112, 22, 3, 1, 'CSS.emf', '1f2eb3c19a264f75845ed7ff36a7a5e9.emf', '2012-09-04 10:41:43.963', 1, '', '2012-09-04 10:41:43.963', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (113, 22, 3, 1, 'CSS_CheckFail.emf', 'b71a71e1bdc1439281751d4ac4003140.emf', '2012-09-04 10:41:43.963', 1, '', '2012-09-04 10:41:43.963', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (114, 22, 3, 1, 'CSS_Down.emf', '2d58db02217c496d94c5ae6444d2ff7f.emf', '2012-09-04 10:41:43.963', 1, '', '2012-09-04 10:41:43.963', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (115, 22, 3, 1, 'CSS_Unstable.emf', '0de06a550b404bda93f2b42df31e7589.emf', '2012-09-04 10:41:43.979', 1, '', '2012-09-04 10:41:43.979', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (116, 22, 3, 1, 'CSS_Up.emf', 'ccbffece01a3436cb4d9db115b620905.emf', '2012-09-04 10:41:43.979', 1, '', '2012-09-04 10:41:43.979', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (117, 23, 3, 1, 'Cache Engine.emf', '826adeee91564f22a90fc333b2ba91c8.emf', '2012-09-04 10:41:43.979', 1, '', '2012-09-04 10:41:43.979', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (118, 23, 3, 1, 'Cache Engine_CheckFail.emf', 'adb9691be3d04074966d3f4284feae53.emf', '2012-09-04 10:41:43.979', 1, '', '2012-09-04 10:41:43.979', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (119, 23, 3, 1, 'Cache Engine_Down.emf', 'd07a7f75dd1243d6b61014d9dfd28962.emf', '2012-09-04 10:41:43.979', 1, '', '2012-09-04 10:41:43.979', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (120, 23, 3, 1, 'Cache Engine_Unstable.emf', 'dba392dddd2b4deab6daf47e86d1b263.emf', '2012-09-04 10:41:43.979', 1, '', '2012-09-04 10:41:43.979', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (121, 23, 3, 1, 'Cache Engine_Up.emf', '401712fdf072471faf07c658aac729ec.emf', '2012-09-04 10:41:43.979', 1, '', '2012-09-04 10:41:43.979', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (122, 24, 3, 1, 'Unclassified Firewall.emf', '4e59bead25684ae59edec0984d943c71.emf', '2012-09-04 10:41:43.994', 1, '', '2012-09-04 10:41:43.994', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (123, 24, 3, 1, 'Unclassified Firewall_CheckFail.emf', '235ab381477249f5b2fefc46990a3997.emf', '2012-09-04 10:41:43.994', 1, '', '2012-09-04 10:41:43.994', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (124, 24, 3, 1, 'Unclassified Firewall_Down.emf', '9eadb5c127aa458e83d71c7f5cf8d592.emf', '2012-09-04 10:41:43.994', 1, '', '2012-09-04 10:41:43.994', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (125, 24, 3, 1, 'Unclassified Firewall_Unstable.emf', '6fa6f335427346f08e3764c870452217.emf', '2012-09-04 10:41:43.994', 1, '', '2012-09-04 10:41:43.994', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (126, 24, 3, 1, 'Unclassified Firewall_Up.emf', '12f550bf11cb4a548b88375cd202c671.emf', '2012-09-04 10:41:43.994', 1, '', '2012-09-04 10:41:43.994', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (127, 25, 3, 1, 'Unclassified Load Balancer.emf', '8968a5ac8c4542ad86d0f842059ff590.emf', '2012-09-04 10:41:43.994', 1, '', '2012-09-04 10:41:43.994', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (128, 25, 3, 1, 'Unclassified Load Balancer_CheckFail.emf', '6af1bacf0ddf4045857666e584f2d8cc.emf', '2012-09-04 10:41:43.994', 1, '', '2012-09-04 10:41:43.994', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (129, 25, 3, 1, 'Unclassified Load Balancer_Down.emf', '90f2cb500d7840898976ad96c089dad8.emf', '2012-09-04 10:41:43.994', 1, '', '2012-09-04 10:41:43.994', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (130, 25, 3, 1, 'Unclassified Load Balancer_Unstable.emf', '6e9d6d64add4455b9da5e2a2d45780dc.emf', '2012-09-04 10:41:43.994', 1, '', '2012-09-04 10:41:43.994', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (131, 25, 3, 1, 'Unclassified Load Balancer_Up.emf', 'e1583410fb614de7a82197334d47adc9.emf', '2012-09-04 10:41:44.01', 1, '', '2012-09-04 10:41:44.01', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (132, 26, 3, 1, 'Unknown IP Device.emf', 'd986bb7e1f9c47ef9716796ff1ed6ef8.emf', '2012-09-04 10:41:44.01', 1, '', '2012-09-04 10:41:44.01', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (133, 26, 3, 1, 'Unknown IP Device_CheckFail.emf', '64677d2094d4439e8f2001c9454ecfe4.emf', '2012-09-04 10:41:44.01', 1, '', '2012-09-04 10:41:44.01', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (134, 27, 3, 1, '3Com Switch.emf', '412212ba05444bf4bf215d81d1c94d25.emf', '2012-09-04 10:41:44.01', 1, '', '2012-09-04 10:41:44.01', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (135, 27, 3, 1, '3Com Switch_CheckFail.emf', '722ce8f057bf4cb99bcc6576ae196bc7.emf', '2012-09-04 10:41:44.01', 1, '', '2012-09-04 10:41:44.01', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (136, 27, 3, 1, '3Com Switch_Down.emf', '5fec8ca35b67405fa4b7c0310c915721.emf', '2012-09-04 10:41:44.01', 1, '', '2012-09-04 10:41:44.01', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (137, 27, 3, 1, '3Com Switch_Unstable.emf', 'bfeeeb10f62c46c8a27704af5a6356f3.emf', '2012-09-04 10:41:44.026', 1, '', '2012-09-04 10:41:44.026', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (138, 27, 3, 1, '3Com Switch_Up.emf', '996f152125be454aa4e318b519721984.emf', '2012-09-04 10:41:44.026', 1, '', '2012-09-04 10:41:44.026', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (139, 28, 3, 1, 'Cisco Nexus Switch.emf', '84fb278479fe42b0832b72a8d7a341d9.emf', '2012-09-04 10:41:44.041', 1, '', '2012-09-04 10:41:44.041', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (140, 28, 3, 1, 'Cisco Nexus Switch_CheckFail.emf', 'd46b6037752c450ba307805c0d530a29.emf', '2012-09-04 10:41:44.041', 1, '', '2012-09-04 10:41:44.041', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (141, 28, 3, 1, 'Cisco Nexus Switch_Down.emf', '107505aee392451c9913bb43c34f1bb9.emf', '2012-09-04 10:41:44.041', 1, '', '2012-09-04 10:41:44.041', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (142, 28, 3, 1, 'Cisco Nexus Switch_Unstable.emf', '0ce1100f01424bea942abc008c750c43.emf', '2012-09-04 10:41:44.041', 1, '', '2012-09-04 10:41:44.041', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (143, 28, 3, 1, 'Cisco Nexus Switch_Up.emf', '5348d95259ea45d1b9bd4cf33ed0ee06.emf', '2012-09-04 10:41:44.041', 1, '', '2012-09-04 10:41:44.041', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (144, 29, 3, 1, 'DMVPN.emf', 'c054a25e938a404199955cc7386874a4.emf', '2012-09-04 10:41:44.041', 1, '', '2012-09-04 10:41:44.041', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (145, 29, 3, 1, 'DMVPN_CheckFail.emf', '64aeb416704144aca8c1f80d4d849e44.emf', '2012-09-04 10:41:44.057', 1, '', '2012-09-04 10:41:44.057', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (146, 30, 3, 1, 'HP ProCurve Switch.emf', '28970ac3bde24807ab438f7c0ce992cd.emf', '2012-09-04 10:41:44.057', 1, '', '2012-09-04 10:41:44.057', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (147, 30, 3, 1, 'HP ProCurve Switch_CheckFail.emf', '1d2ba8f36d5043c396e3194b53995074.emf', '2012-09-04 10:41:44.057', 1, '', '2012-09-04 10:41:44.057', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (148, 30, 3, 1, 'HP ProCurve Switch_Down.emf', 'a731e9d5a3754c1999df869e0bda11a4.emf', '2012-09-04 10:41:44.057', 1, '', '2012-09-04 10:41:44.057', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (149, 30, 3, 1, 'HP ProCurve Switch_Unstable.emf', '767598e885044626a51a0a00263b5d57.emf', '2012-09-04 10:41:44.057', 1, '', '2012-09-04 10:41:44.057', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (150, 30, 3, 1, 'HP ProCurve Switch_Up.emf', '6c8dfac53e8b40568bb548607f49ac5a.emf', '2012-09-04 10:41:44.057', 1, '', '2012-09-04 10:41:44.057', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (151, 31, 3, 1, 'Juniper EX Switch.emf', '1f9d28ec1b594c9dbc8c3aa8a91a19db.emf', '2012-09-04 10:41:44.072', 1, '', '2012-09-04 10:41:44.072', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (152, 31, 3, 1, 'Juniper EX Switch_CheckFail.emf', '3ed3af5796d14e299bbf32535f1adb34.emf', '2012-09-04 10:41:44.072', 1, '', '2012-09-04 10:41:44.072', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (153, 31, 3, 1, 'Juniper EX Switch_Down.emf', 'cc123341240f409dae2eb54b5d079729.emf', '2012-09-04 10:41:44.072', 1, '', '2012-09-04 10:41:44.072', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (154, 31, 3, 1, 'Juniper EX Switch_Unstable.emf', 'a334ee5f239b45e8b4a66ce3d4d2543d.emf', '2012-09-04 10:41:44.072', 1, '', '2012-09-04 10:41:44.072', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (155, 31, 3, 1, 'Juniper EX Switch_Up.emf', 'aaf21195d01f4b09b6bc230c8632cf0f.emf', '2012-09-04 10:41:44.072', 1, '', '2012-09-04 10:41:44.072', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (156, 32, 3, 1, 'Internet Wan.emf', '3834f136017b47ab81fa3237f6496228.emf', '2012-09-04 10:41:44.072', 1, '', '2012-09-04 10:41:44.072', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (157, 32, 3, 1, 'Internet Wan_CheckFail.emf', 'fe3fd52da8f84d4c883cfff7513e6eaa.emf', '2012-09-04 10:41:44.072', 1, '', '2012-09-04 10:41:44.072', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (158, 33, 3, 1, 'WLC.emf', 'bd984768efe1425c85f73649d54a1b38.emf', '2012-09-04 10:41:44.072', 1, '', '2012-09-04 10:41:44.072', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (159, 33, 3, 1, 'WLC_CheckFail.emf', '4fa7cc174b9447aba4db80ae2bedc35c.emf', '2012-09-04 10:41:44.072', 1, '', '2012-09-04 10:41:44.072', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (160, 33, 3, 1, 'WLC_Down.emf', '8c8ac941459a493bb101b3a1aa59487d.emf', '2012-09-04 10:41:44.088', 1, '', '2012-09-04 10:41:44.088', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (161, 33, 3, 1, 'WLC_Unstable.emf', '549134f3f7af44abaa4fa63f036ee026.emf', '2012-09-04 10:41:44.088', 1, '', '2012-09-04 10:41:44.088', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (162, 33, 3, 1, 'WLC_Up.emf', 'c5cb596ee9d647178b61d23752cc0a56.emf', '2012-09-04 10:41:44.088', 1, '', '2012-09-04 10:41:44.088', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (163, 34, 3, 1, 'LWAP.emf', '6a9c79d38a31412daa1f524625e46f77.emf', '2012-09-04 10:41:44.088', 1, '', '2012-09-04 10:41:44.088', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (164, 34, 3, 1, 'LWAP_CheckFail.emf', 'a46a85eddec74df887c99bc3abdf9afd.emf', '2012-09-04 10:41:44.088', 1, '', '2012-09-04 10:41:44.088', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (165, 34, 3, 1, 'LWAP_Down.emf', '610300a23ccb432aa6b8428316ae09eb.emf', '2012-09-04 10:41:44.088', 1, '', '2012-09-04 10:41:44.088', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (166, 34, 3, 1, 'LWAP_Unstable.emf', '75ff4e5fc37d472c829cbc6dac06528d.emf', '2012-09-04 10:41:44.088', 1, '', '2012-09-04 10:41:44.088', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (167, 34, 3, 1, 'LWAP_Up.emf', '7539ea32e27743fbb92368dc05d38c7a.emf', '2012-09-04 10:41:44.104', 1, '', '2012-09-04 10:41:44.104', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (168, 35, 3, 1, 'Arista Switch.emf', 'ae8a9afcf5ed4e9eaf6da29262eeaf94.emf', '2012-09-04 10:41:44.104', 1, '', '2012-09-04 10:41:44.104', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (169, 35, 3, 1, 'Arista Switch_CheckFail.emf', 'e8b313117cf846889c4e6e73e7cd4dd6.emf', '2012-09-04 10:41:44.104', 1, '', '2012-09-04 10:41:44.104', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (170, 35, 3, 1, 'Arista Switch_Down.emf', 'a970eb6e76aa4648b6703c3fd52c46d8.emf', '2012-09-04 10:41:44.104', 1, '', '2012-09-04 10:41:44.104', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (171, 35, 3, 1, 'Arista Switch_Unstable.emf', '36085b18d7c9476bbc5e529189a54281.emf', '2012-09-04 10:41:44.104', 1, '', '2012-09-04 10:41:44.104', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (172, 35, 3, 1, 'Arista Switch_Up.emf', '6ee02973440047c3a36170f3fd125be4.emf', '2012-09-04 10:41:44.104', 1, '', '2012-09-04 10:41:44.104', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (173, 36, 3, 1, 'Brocade Switch.emf', '210a1cc0bbbb42f1a7acf921404b6af4.emf', '2012-09-04 10:41:44.104', 1, '', '2012-09-04 10:41:44.104', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (174, 36, 3, 1, 'Brocade Switch_CheckFail.emf', '99e58ca72eee4c8a9d345bc3e8e354f0.emf', '2012-09-04 10:41:44.104', 1, '', '2012-09-04 10:41:44.104', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (175, 36, 3, 1, 'Brocade Switch_Down.emf', 'f9c322d751b741618280f5ca6a95e3d2.emf', '2012-09-04 10:41:44.104', 1, '', '2012-09-04 10:41:44.104', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (176, 36, 3, 1, 'Brocade Switch_Unstable.emf', '22a73d3dfd204fa2918ddd47b34de3dc.emf', '2012-09-04 10:41:44.119', 1, '', '2012-09-04 10:41:44.119', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (177, 36, 3, 1, 'Brocade Switch_Up.emf', '52623eecd12d4f6ba7d6c1b1b56c60b4.emf', '2012-09-04 10:41:44.119', 1, '', '2012-09-04 10:41:44.119', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (178, 37, 3, 1, 'Dell Force10 Switch.emf', '274f73a442aa4c46a989250b003d5ac4.emf', '2012-09-04 10:41:44.119', 1, '', '2012-09-04 10:41:44.119', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (179, 37, 3, 1, 'Dell Force10 Switch_CheckFail.emf', 'bc3d35124fe346cab2a9984556a0ac78.emf', '2012-09-04 10:41:44.119', 1, '', '2012-09-04 10:41:44.119', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (180, 37, 3, 1, 'Dell Force10 Switch_Down.emf', 'efef55a7c6cc43d18f3556cfc5f8f3e2.emf', '2012-09-04 10:41:44.119', 1, '', '2012-09-04 10:41:44.119', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (181, 37, 3, 1, 'Dell Force10 Switch_Unstable.emf', '4fb0e2a2288b4276be78c8f51f424fbf.emf', '2012-09-04 10:41:44.119', 1, '', '2012-09-04 10:41:44.119', NULL, NULL);
INSERT INTO object_file_info (id, object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, path_id, licguid) VALUES (182, 37, 3, 1, 'Dell Force10 Switch_Up.emf', 'f4eba4eaf0bd47b19ae0e71dd8083872.emf', '2012-09-04 10:41:44.119', 1, '', '2012-09-04 10:41:44.119', NULL, NULL);


--
-- TOC entry 3794 (class 0 OID 620733)
-- Dependencies: 2482
-- Data for Name: object_file_path_info; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3795 (class 0 OID 620738)
-- Dependencies: 2484
-- Data for Name: objprivatetimestamp; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3796 (class 0 OID 620743)
-- Dependencies: 2486
-- Data for Name: objtimestamp; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO objtimestamp (id, typename, modifytime) VALUES (1, 'Topo', '1900-01-01 00:00:00');
INSERT INTO objtimestamp (id, typename, modifytime) VALUES (4, 'SystemDeviceGroup', '1900-01-01 00:00:00');
INSERT INTO objtimestamp (id, typename, modifytime) VALUES (6, 'ConfigFile', '1900-01-01 00:00:00');
INSERT INTO objtimestamp (id, typename, modifytime) VALUES (7, 'L2Switch', '1900-01-01 00:00:00');
INSERT INTO objtimestamp (id, typename, modifytime) VALUES (8, 'IpPhone', '1900-01-01 00:00:00');
INSERT INTO objtimestamp (id, typename, modifytime) VALUES (9, 'DuplicateIp', '1900-01-01 00:00:00');
INSERT INTO objtimestamp (id, typename, modifytime) VALUES (10, 'FixupUnnumberInterface', '1900-01-01 00:00:00');
INSERT INTO objtimestamp (id, typename, modifytime) VALUES (11, 'DeviceSetting', '1900-01-01 00:00:00');
INSERT INTO objtimestamp (id, typename, modifytime) VALUES (12, 'InterfaceSetting', '1900-01-01 00:00:00');
INSERT INTO objtimestamp (id, typename, modifytime) VALUES (13, 'NetworkSetting', '1900-01-01 00:00:00');
INSERT INTO objtimestamp (id, typename, modifytime) VALUES (15, 'OneIpTable', '1900-01-01 00:00:00');
INSERT INTO objtimestamp (id, typename, modifytime) VALUES (16, 'L2SwitchConnectivity', '1900-01-01 00:00:00');
INSERT INTO objtimestamp (id, typename, modifytime) VALUES (17, 'L2Domain', '1900-01-01 00:00:00');
INSERT INTO objtimestamp (id, typename, modifytime) VALUES (5, 'SwitchGroup', '1900-01-01 00:00:00');
INSERT INTO objtimestamp (id, typename, modifytime) VALUES (18, 'FixUpNatInfo', '1900-01-01 00:00:00');
INSERT INTO objtimestamp (id, typename, modifytime) VALUES (19, 'FixUpRouteTable', '1900-01-01 00:00:00');
INSERT INTO objtimestamp (id, typename, modifytime) VALUES (20, 'FixUpRouteTablePriority', '1900-01-01 00:00:00');
INSERT INTO objtimestamp (id, typename, modifytime) VALUES (21, 'DeviceProtocols', '1900-01-01 00:00:00');
INSERT INTO objtimestamp (id, typename, modifytime) VALUES (22, 'Nat', '1900-01-01 00:00:00');
INSERT INTO objtimestamp (id, typename, modifytime) VALUES (45, 'nd', '1900-01-01 00:00:00');
INSERT INTO objtimestamp (id, typename, modifytime) VALUES (46, 'Visio', '1900-01-01 00:00:00');
INSERT INTO objtimestamp (id, typename, modifytime) VALUES (23, 'BGpNeighbor', '1900-01-01 00:00:00');
INSERT INTO objtimestamp (id, typename, modifytime) VALUES (25, 'device_property', '1900-01-01 00:00:00');
INSERT INTO objtimestamp (id, typename, modifytime) VALUES (26, 'device_customized_info', '1900-01-01 00:00:00');
INSERT INTO objtimestamp (id, typename, modifytime) VALUES (27, 'interface_customized_info', '1900-01-01 00:00:00');
INSERT INTO objtimestamp (id, typename, modifytime) VALUES (28, 'module_property', '1900-01-01 00:00:00');
INSERT INTO objtimestamp (id, typename, modifytime) VALUES (29, 'module_customized_info', '1900-01-01 00:00:00');
INSERT INTO objtimestamp (id, typename, modifytime) VALUES (30, 'site', '1900-01-01 00:00:00');
INSERT INTO objtimestamp (id, typename, modifytime) VALUES (31, 'site_customized_info', '1900-01-01 00:00:00');
INSERT INTO objtimestamp (id, typename, modifytime) VALUES (33, 'DeviceIcon', '1900-01-01 00:00:00');
INSERT INTO objtimestamp (id, typename, modifytime) VALUES (14, 'VendorModel_DeviceSpec', '1900-01-01 00:00:00');
INSERT INTO objtimestamp (id, typename, modifytime) VALUES (34, 'Shared_Map', '1900-01-01 00:00:00');
INSERT INTO objtimestamp (id, typename, modifytime) VALUES (35, 'showcommandtemplate', '1900-01-01 00:00:00');
INSERT INTO objtimestamp (id, typename, modifytime) VALUES (36, 'discover_missdevice', '1900-01-01 00:00:00');
INSERT INTO objtimestamp (id, typename, modifytime) VALUES (37, 'discover_newdevice', '1900-01-01 00:00:00');
INSERT INTO objtimestamp (id, typename, modifytime) VALUES (38, 'discover_snmpdevice', '1900-01-01 00:00:00');
INSERT INTO objtimestamp (id, typename, modifytime) VALUES (39, 'discover_unknowdevice', '1900-01-01 00:00:00');
INSERT INTO objtimestamp (id, typename, modifytime) VALUES (40, 'unknownip', '1900-01-01 00:00:00');
INSERT INTO objtimestamp (id, typename, modifytime) VALUES (41, 'internetboundaryinterface', '1900-01-01 00:00:00');
INSERT INTO objtimestamp (id, typename, modifytime) VALUES (42, 'transport_protocol_port', '1900-01-01 00:00:00');
INSERT INTO objtimestamp (id, typename, modifytime) VALUES (43, 'ouinfo', '1900-01-01 00:00:00');
INSERT INTO objtimestamp (id, typename, modifytime) VALUES (44, 'lwap', '1900-01-01 00:00:00');
INSERT INTO objtimestamp (id, typename, modifytime) VALUES (24, 'object_customized_attribute', '2012-09-21 19:44:58.138');
INSERT INTO objtimestamp (id, typename, modifytime) VALUES (2, 'PublicDeviceGroup', '2012-09-21 19:51:04.084');
INSERT INTO objtimestamp (id, typename, modifytime) VALUES (32, 'PublicLinkGroup', '2012-09-21 19:51:18.569');
INSERT INTO objtimestamp (id, typename, modifytime) VALUES (47, 'Procedure', '1900-01-01 00:00:00');

--
-- TOC entry 3723 (class 0 OID 619870)
-- Dependencies: 2282
-- Data for Name: ouinfo; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3724 (class 0 OID 619958)
-- Dependencies: 2283
-- Data for Name: showcommandbenchmarktask; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3797 (class 0 OID 620756)
-- Dependencies: 2492
-- Data for Name: showcommandbenchmarktaskcmddetail; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3798 (class 0 OID 620762)
-- Dependencies: 2494
-- Data for Name: showcommandbenchmarktaskdgdetail; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3799 (class 0 OID 620767)
-- Dependencies: 2496
-- Data for Name: showcommandbenchmarktasksitedetail; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3770 (class 0 OID 620416)
-- Dependencies: 2367
-- Data for Name: showcommandtemplate; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3725 (class 0 OID 619968)
-- Dependencies: 2284
-- Data for Name: site; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO site (id, name, region, location_address, employee_number, contact_name, phone_number, email, type, color, comment, lasttimestamp) VALUES (1, 'Entire Network', '', '', 0, '', '', '', '', 0, '', '2012-09-04 10:41:24.244');


--
-- TOC entry 3771 (class 0 OID 620425)
-- Dependencies: 2368
-- Data for Name: site2site; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO site2site (id, siteid, parentid) VALUES (1, 1, 0);


--
-- TOC entry 3726 (class 0 OID 619973)
-- Dependencies: 2285
-- Data for Name: site_customized_info; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3772 (class 0 OID 620433)
-- Dependencies: 2370
-- Data for Name: switchgroup; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3773 (class 0 OID 620437)
-- Dependencies: 2371
-- Data for Name: swtichgroupdevice; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3737 (class 0 OID 620092)
-- Dependencies: 2305
-- Data for Name: symbol2deviceicon; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO symbol2deviceicon (id, symbolid, deviceicon_id, lasttimestamp) VALUES (1, 2018, 39, '2012-09-04 10:41:43.572');
INSERT INTO symbol2deviceicon (id, symbolid, deviceicon_id, lasttimestamp) VALUES (2, 45, 1, '2012-09-04 10:41:43.588');
INSERT INTO symbol2deviceicon (id, symbolid, deviceicon_id, lasttimestamp) VALUES (3, 1, 2, '2012-09-04 10:41:43.588');
INSERT INTO symbol2deviceicon (id, symbolid, deviceicon_id, lasttimestamp) VALUES (4, 68, 38, '2012-09-04 10:41:43.604');
INSERT INTO symbol2deviceicon (id, symbolid, deviceicon_id, lasttimestamp) VALUES (5, 2, 3, '2012-09-04 10:41:43.604');
INSERT INTO symbol2deviceicon (id, symbolid, deviceicon_id, lasttimestamp) VALUES (6, 3, 4, '2012-09-04 10:41:43.604');
INSERT INTO symbol2deviceicon (id, symbolid, deviceicon_id, lasttimestamp) VALUES (7, 7, 5, '2012-09-04 10:41:43.604');
INSERT INTO symbol2deviceicon (id, symbolid, deviceicon_id, lasttimestamp) VALUES (8, 4, 6, '2012-09-04 10:41:43.604');
INSERT INTO symbol2deviceicon (id, symbolid, deviceicon_id, lasttimestamp) VALUES (9, 5, 7, '2012-09-04 10:41:43.604');
INSERT INTO symbol2deviceicon (id, symbolid, deviceicon_id, lasttimestamp) VALUES (10, 51, 8, '2012-09-04 10:41:43.604');
INSERT INTO symbol2deviceicon (id, symbolid, deviceicon_id, lasttimestamp) VALUES (11, 59, 9, '2012-09-04 10:41:43.619');
INSERT INTO symbol2deviceicon (id, symbolid, deviceicon_id, lasttimestamp) VALUES (12, 60, 10, '2012-09-04 10:41:43.619');
INSERT INTO symbol2deviceicon (id, symbolid, deviceicon_id, lasttimestamp) VALUES (13, 56, 11, '2012-09-04 10:41:43.619');
INSERT INTO symbol2deviceicon (id, symbolid, deviceicon_id, lasttimestamp) VALUES (14, 67, 12, '2012-09-04 10:41:43.619');
INSERT INTO symbol2deviceicon (id, symbolid, deviceicon_id, lasttimestamp) VALUES (15, 101, 13, '2012-09-04 10:41:43.619');
INSERT INTO symbol2deviceicon (id, symbolid, deviceicon_id, lasttimestamp) VALUES (16, 104, 14, '2012-09-04 10:41:43.619');
INSERT INTO symbol2deviceicon (id, symbolid, deviceicon_id, lasttimestamp) VALUES (17, 64, 15, '2012-09-04 10:41:43.635');
INSERT INTO symbol2deviceicon (id, symbolid, deviceicon_id, lasttimestamp) VALUES (18, 47, 16, '2012-09-04 10:41:43.635');
INSERT INTO symbol2deviceicon (id, symbolid, deviceicon_id, lasttimestamp) VALUES (19, 100, 17, '2012-09-04 10:41:43.635');
INSERT INTO symbol2deviceicon (id, symbolid, deviceicon_id, lasttimestamp) VALUES (20, 55, 18, '2012-09-04 10:41:43.635');
INSERT INTO symbol2deviceicon (id, symbolid, deviceicon_id, lasttimestamp) VALUES (21, 43, 19, '2012-09-04 10:41:43.635');
INSERT INTO symbol2deviceicon (id, symbolid, deviceicon_id, lasttimestamp) VALUES (22, 50, 20, '2012-09-04 10:41:43.635');
INSERT INTO symbol2deviceicon (id, symbolid, deviceicon_id, lasttimestamp) VALUES (23, 54, 21, '2012-09-04 10:41:43.635');
INSERT INTO symbol2deviceicon (id, symbolid, deviceicon_id, lasttimestamp) VALUES (24, 57, 22, '2012-09-04 10:41:43.651');
INSERT INTO symbol2deviceicon (id, symbolid, deviceicon_id, lasttimestamp) VALUES (25, 49, 23, '2012-09-04 10:41:43.651');
INSERT INTO symbol2deviceicon (id, symbolid, deviceicon_id, lasttimestamp) VALUES (26, 103, 24, '2012-09-04 10:41:43.651');
INSERT INTO symbol2deviceicon (id, symbolid, deviceicon_id, lasttimestamp) VALUES (27, 102, 25, '2012-09-04 10:41:43.651');
INSERT INTO symbol2deviceicon (id, symbolid, deviceicon_id, lasttimestamp) VALUES (28, 105, 26, '2012-09-04 10:41:43.651');
INSERT INTO symbol2deviceicon (id, symbolid, deviceicon_id, lasttimestamp) VALUES (29, 123, 27, '2012-09-04 10:41:43.666');
INSERT INTO symbol2deviceicon (id, symbolid, deviceicon_id, lasttimestamp) VALUES (30, 124, 28, '2012-09-04 10:41:43.666');
INSERT INTO symbol2deviceicon (id, symbolid, deviceicon_id, lasttimestamp) VALUES (31, 125, 29, '2012-09-04 10:41:43.666');
INSERT INTO symbol2deviceicon (id, symbolid, deviceicon_id, lasttimestamp) VALUES (32, 200, 30, '2012-09-04 10:41:43.666');
INSERT INTO symbol2deviceicon (id, symbolid, deviceicon_id, lasttimestamp) VALUES (33, 201, 31, '2012-09-04 10:41:43.666');
INSERT INTO symbol2deviceicon (id, symbolid, deviceicon_id, lasttimestamp) VALUES (34, 106, 32, '2012-09-04 10:41:43.666');
INSERT INTO symbol2deviceicon (id, symbolid, deviceicon_id, lasttimestamp) VALUES (35, 202, 33, '2012-09-04 10:41:43.682');
INSERT INTO symbol2deviceicon (id, symbolid, deviceicon_id, lasttimestamp) VALUES (36, 203, 34, '2012-09-04 10:41:43.682');
INSERT INTO symbol2deviceicon (id, symbolid, deviceicon_id, lasttimestamp) VALUES (37, 204, 35, '2012-09-04 10:41:43.682');
INSERT INTO symbol2deviceicon (id, symbolid, deviceicon_id, lasttimestamp) VALUES (38, 65, 36, '2012-09-04 10:41:43.682');
INSERT INTO symbol2deviceicon (id, symbolid, deviceicon_id, lasttimestamp) VALUES (39, 206, 37, '2012-09-04 10:41:43.682');


--
-- TOC entry 3800 (class 0 OID 620790)
-- Dependencies: 2506
-- Data for Name: symbol2deviceicon_selected; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3801 (class 0 OID 620795)
-- Dependencies: 2508
-- Data for Name: sys_environmentvariable; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO sys_environmentvariable (id, variable, value) VALUES (1, 'donotscan', NULL);
INSERT INTO sys_environmentvariable (id, variable, value) VALUES (2, 'managementip', NULL);


--
-- TOC entry 3802 (class 0 OID 620800)
-- Dependencies: 2510
-- Data for Name: sys_option; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO sys_option (id, op_name, op_value) VALUES (1, 'strongpwd', 0);
INSERT INTO sys_option (id, op_name, op_value) VALUES (2, 'passwordexpireday', 0);
INSERT INTO sys_option (id, op_name, op_value) VALUES (3, 'minimum_password_length', 6);
INSERT INTO sys_option (id, op_name, op_value) VALUES (4, 'autostopbenchmarktimer', 0);
INSERT INTO sys_option (id, op_name, op_value) VALUES (5, 'issetautostopbenchmarktimer', 0);


--
-- TOC entry 3803 (class 0 OID 620805)
-- Dependencies: 2512
-- Data for Name: system_cmdconfig; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3727 (class 0 OID 619987)
-- Dependencies: 2288
-- Data for Name: system_devicespec; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3804 (class 0 OID 620810)
-- Dependencies: 2514
-- Data for Name: system_info; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO system_info (id, ver, itelnetsshtimeout, isnmptimeout, iroutetablemaxentries) VALUES (1, 418, 60, 10, 10000);


--
-- TOC entry 3805 (class 0 OID 620817)
-- Dependencies: 2515
-- Data for Name: system_interfacecfg; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3728 (class 0 OID 619997)
-- Dependencies: 2290
-- Data for Name: system_vendormodel; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3806 (class 0 OID 620820)
-- Dependencies: 2516
-- Data for Name: system_vendormodel2device_icon; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3735 (class 0 OID 620078)
-- Dependencies: 2302
-- Data for Name: systemdevicegroup; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3774 (class 0 OID 620450)
-- Dependencies: 2374
-- Data for Name: systemdevicegroupdevice; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3729 (class 0 OID 620007)
-- Dependencies: 2291
-- Data for Name: transport_protocol_port; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3711 (class 0 OID 619698)
-- Dependencies: 2264
-- Data for Name: unknownip; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3730 (class 0 OID 620022)
-- Dependencies: 2292
-- Data for Name: userdevicesetting; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3807 (class 0 OID 620838)
-- Dependencies: 2523
-- Data for Name: wanlink; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3808 (class 0 OID 620843)
-- Dependencies: 2525
-- Data for Name: wans; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3446 (class 2606 OID 620945)
-- Dependencies: 2378 2378
-- Name: adminpwd_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY adminpwd
    ADD CONSTRAINT adminpwd_pk PRIMARY KEY (id);


--
-- TOC entry 3448 (class 2606 OID 620947)
-- Dependencies: 2380 2380
-- Name: benchmarkfolder_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY benchmarkfolder
    ADD CONSTRAINT benchmarkfolder_pk PRIMARY KEY (tdstamp);


--
-- TOC entry 3450 (class 2606 OID 620949)
-- Dependencies: 2382 2382
-- Name: benchmarktask_pki; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY benchmarktask
    ADD CONSTRAINT benchmarktask_pki PRIMARY KEY (id);


--
-- TOC entry 3455 (class 2606 OID 620951)
-- Dependencies: 2386 2386
-- Name: benchmarktaskstatusstep_pk_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY benchmarktaskstatusstep
    ADD CONSTRAINT benchmarktaskstatusstep_pk_id PRIMARY KEY (id);


--
-- TOC entry 3457 (class 2606 OID 620953)
-- Dependencies: 2386 2386 2386
-- Name: benchmarktaskstatusstep_statusid; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY benchmarktaskstatusstep
    ADD CONSTRAINT benchmarktaskstatusstep_statusid UNIQUE (statusid, steptype);


--
-- TOC entry 3459 (class 2606 OID 620955)
-- Dependencies: 2388 2388
-- Name: benchmarktaskstatussteplog_pk_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY benchmarktaskstatussteplog
    ADD CONSTRAINT benchmarktaskstatussteplog_pk_id PRIMARY KEY (id);


--
-- TOC entry 3260 (class 2606 OID 620957)
-- Dependencies: 2293 2293
-- Name: bgpneighbor_pk_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY bgpneighbor
    ADD CONSTRAINT bgpneighbor_pk_id PRIMARY KEY (id);


--
-- TOC entry 3262 (class 2606 OID 620959)
-- Dependencies: 2293 2293 2293
-- Name: bgpneighbor_uniq_asnum; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY bgpneighbor
    ADD CONSTRAINT bgpneighbor_uniq_asnum UNIQUE (deviceid, remoteasnum);


--
-- TOC entry 3462 (class 2606 OID 620961)
-- Dependencies: 2391 2391
-- Name: checkupdate_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY checkupdate
    ADD CONSTRAINT checkupdate_pk PRIMARY KEY (id);


--
-- TOC entry 3464 (class 2606 OID 620963)
-- Dependencies: 2391 2391
-- Name: checkupdate_unkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY checkupdate
    ADD CONSTRAINT checkupdate_unkey UNIQUE (version);


--
-- TOC entry 3466 (class 2606 OID 620965)
-- Dependencies: 2393 2393
-- Name: datastoragesetting_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY datastoragesetting
    ADD CONSTRAINT datastoragesetting_pk PRIMARY KEY (id);


--
-- TOC entry 3468 (class 2606 OID 620967)
-- Dependencies: 2393 2393
-- Name: datastoragesetting_un; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY datastoragesetting
    ADD CONSTRAINT datastoragesetting_un UNIQUE (kindname);


--
-- TOC entry 3470 (class 2606 OID 620969)
-- Dependencies: 2395 2395
-- Name: device_config_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY device_config
    ADD CONSTRAINT device_config_pk PRIMARY KEY (deviceid);


--
-- TOC entry 3126 (class 2606 OID 620971)
-- Dependencies: 2249 2249
-- Name: device_customized_info_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY device_customized_info
    ADD CONSTRAINT device_customized_info_pk PRIMARY KEY (id);


--
-- TOC entry 3128 (class 2606 OID 620973)
-- Dependencies: 2249 2249 2249
-- Name: device_customized_info_un; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY device_customized_info
    ADD CONSTRAINT device_customized_info_un UNIQUE (objectid, attributeid);


--
-- TOC entry 3278 (class 2606 OID 620975)
-- Dependencies: 2304 2304
-- Name: device_icon_name_un; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY device_icon
    ADD CONSTRAINT device_icon_name_un UNIQUE (icon_name);


--
-- TOC entry 3280 (class 2606 OID 620977)
-- Dependencies: 2304 2304
-- Name: device_icon_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY device_icon
    ADD CONSTRAINT device_icon_pk PRIMARY KEY (id);


--
-- TOC entry 3472 (class 2606 OID 620979)
-- Dependencies: 2398 2398
-- Name: device_maintype_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY device_maintype
    ADD CONSTRAINT device_maintype_pk PRIMARY KEY (maintype);


--
-- TOC entry 3474 (class 2606 OID 620981)
-- Dependencies: 2398 2398
-- Name: device_maintype_uniq_name; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY device_maintype
    ADD CONSTRAINT device_maintype_uniq_name UNIQUE (maintype);


--
-- TOC entry 3132 (class 2606 OID 620983)
-- Dependencies: 2250 2250
-- Name: device_property_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY device_property
    ADD CONSTRAINT device_property_pk PRIMARY KEY (id);


--
-- TOC entry 3476 (class 2606 OID 620985)
-- Dependencies: 2400 2400
-- Name: device_subtype_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY device_subtype
    ADD CONSTRAINT device_subtype_pk PRIMARY KEY (id);


--
-- TOC entry 3478 (class 2606 OID 620987)
-- Dependencies: 2400 2400 2400
-- Name: device_subtype_uniq_miantype_subtype; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY device_subtype
    ADD CONSTRAINT device_subtype_uniq_miantype_subtype UNIQUE (maintype, subtype);


--
-- TOC entry 3480 (class 2606 OID 620989)
-- Dependencies: 2400 2400
-- Name: device_subtype_uniq_name; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY device_subtype
    ADD CONSTRAINT device_subtype_uniq_name UNIQUE (subtype_name);


--
-- TOC entry 3119 (class 2606 OID 620991)
-- Dependencies: 2246 2246
-- Name: devicegroup_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY devicegroup
    ADD CONSTRAINT devicegroup_pk PRIMARY KEY (id);


--
-- TOC entry 3121 (class 2606 OID 620993)
-- Dependencies: 2247 2247
-- Name: devicegroupdevice_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY devicegroupdevice
    ADD CONSTRAINT devicegroupdevice_pk PRIMARY KEY (id);


--
-- TOC entry 3123 (class 2606 OID 620995)
-- Dependencies: 2247 2247 2247 2247
-- Name: devicegroupdevice_unique; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY devicegroupdevice
    ADD CONSTRAINT devicegroupdevice_unique UNIQUE (devicegroupid, deviceid, type);


--
-- TOC entry 3264 (class 2606 OID 620997)
-- Dependencies: 2297 2297
-- Name: devicegroupdevicegroup_pk_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY devicegroupdevicegroup
    ADD CONSTRAINT devicegroupdevicegroup_pk_id PRIMARY KEY (id);


--
-- TOC entry 3266 (class 2606 OID 620999)
-- Dependencies: 2299 2299
-- Name: devicegroupsite_pk_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY devicegroupsite
    ADD CONSTRAINT devicegroupsite_pk_id PRIMARY KEY (id);


--
-- TOC entry 3268 (class 2606 OID 621001)
-- Dependencies: 2299 2299 2299 2299
-- Name: devicegroupsite_uniq_groupid; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY devicegroupsite
    ADD CONSTRAINT devicegroupsite_uniq_groupid UNIQUE (groupid, siteid, sitechild);


--
-- TOC entry 3270 (class 2606 OID 621003)
-- Dependencies: 2301 2301
-- Name: devicegroupsystemdevicegroup_pk_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY devicegroupsystemdevicegroup
    ADD CONSTRAINT devicegroupsystemdevicegroup_pk_id PRIMARY KEY (id);


--
-- TOC entry 3290 (class 2606 OID 621005)
-- Dependencies: 2307 2307
-- Name: deviceprotocols_pk_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY deviceprotocols
    ADD CONSTRAINT deviceprotocols_pk_id PRIMARY KEY (id);


--
-- TOC entry 3292 (class 2606 OID 621007)
-- Dependencies: 2307 2307 2307
-- Name: deviceprotocols_uniq_protocal; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY deviceprotocols
    ADD CONSTRAINT deviceprotocols_uniq_protocal UNIQUE (deviceid, protocalname);


--
-- TOC entry 3108 (class 2606 OID 621009)
-- Dependencies: 2245 2245
-- Name: devices_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY devices
    ADD CONSTRAINT devices_pk PRIMARY KEY (id);


--
-- TOC entry 3110 (class 2606 OID 621011)
-- Dependencies: 2245 2245
-- Name: devices_un_name; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY devices
    ADD CONSTRAINT devices_un_name UNIQUE (strname);


--
-- TOC entry 3112 (class 2606 OID 621013)
-- Dependencies: 2245 2245 2245
-- Name: devices_un_name_type; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY devices
    ADD CONSTRAINT devices_un_name_type UNIQUE (strname, isubtype);


--
-- TOC entry 3136 (class 2606 OID 621015)
-- Dependencies: 2253 2253
-- Name: devicesetting_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY devicesetting
    ADD CONSTRAINT devicesetting_pk PRIMARY KEY (id);


--
-- TOC entry 3138 (class 2606 OID 621017)
-- Dependencies: 2253 2253
-- Name: devicesetting_un_deviceid; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY devicesetting
    ADD CONSTRAINT devicesetting_un_deviceid UNIQUE (deviceid);


--
-- TOC entry 3294 (class 2606 OID 621019)
-- Dependencies: 2309 2309
-- Name: devicesitedevice_uniq_deviceid; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY devicesitedevice
    ADD CONSTRAINT devicesitedevice_uniq_deviceid UNIQUE (deviceid);


--
-- TOC entry 3483 (class 2606 OID 621021)
-- Dependencies: 2410 2410
-- Name: devicevpns_pk_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY devicevpns
    ADD CONSTRAINT devicevpns_pk_id PRIMARY KEY (id);


--
-- TOC entry 3485 (class 2606 OID 621023)
-- Dependencies: 2410 2410 2410
-- Name: devicevpns_uniq_vpn; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY devicevpns
    ADD CONSTRAINT devicevpns_uniq_vpn UNIQUE (deviceid, vpnname);


--
-- TOC entry 3487 (class 2606 OID 621025)
-- Dependencies: 2412 2412
-- Name: disableinterface_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY disableinterface
    ADD CONSTRAINT disableinterface_pk PRIMARY KEY (id);


--
-- TOC entry 3489 (class 2606 OID 621027)
-- Dependencies: 2412 2412
-- Name: disableinterface_uniq_infid; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY disableinterface
    ADD CONSTRAINT disableinterface_uniq_infid UNIQUE (interfaceid);


--
-- TOC entry 3147 (class 2606 OID 621029)
-- Dependencies: 2258 2258
-- Name: discover_missdevice_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY discover_missdevice
    ADD CONSTRAINT discover_missdevice_pkey PRIMARY KEY (id);


--
-- TOC entry 3149 (class 2606 OID 621031)
-- Dependencies: 2260 2260
-- Name: discover_newdevice_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY discover_newdevice
    ADD CONSTRAINT discover_newdevice_pkey PRIMARY KEY (id);


--
-- TOC entry 3151 (class 2606 OID 621033)
-- Dependencies: 2260 2260
-- Name: discover_newdevice_unique; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY discover_newdevice
    ADD CONSTRAINT discover_newdevice_unique UNIQUE (hostname);


--
-- TOC entry 3492 (class 2606 OID 621035)
-- Dependencies: 2418 2418
-- Name: discover_schedule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY discover_schedule
    ADD CONSTRAINT discover_schedule_pkey PRIMARY KEY (id);


--
-- TOC entry 3153 (class 2606 OID 621037)
-- Dependencies: 2261 2261
-- Name: discover_snmpdevice_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY discover_snmpdevice
    ADD CONSTRAINT discover_snmpdevice_pkey PRIMARY KEY (id);


--
-- TOC entry 3155 (class 2606 OID 621039)
-- Dependencies: 2261 2261
-- Name: discover_snmpdevice_unique; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY discover_snmpdevice
    ADD CONSTRAINT discover_snmpdevice_unique UNIQUE (hostname);


--
-- TOC entry 3157 (class 2606 OID 621041)
-- Dependencies: 2262 2262
-- Name: discover_unknowdevice_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY discover_unknowdevice
    ADD CONSTRAINT discover_unknowdevice_pkey PRIMARY KEY (id);


--
-- TOC entry 3159 (class 2606 OID 621043)
-- Dependencies: 2262 2262
-- Name: discover_unknowdevice_unique; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY discover_unknowdevice
    ADD CONSTRAINT discover_unknowdevice_unique UNIQUE (mgrip);


--
-- TOC entry 3496 (class 2606 OID 621045)
-- Dependencies: 2427 2427
-- Name: domain_option_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY domain_option
    ADD CONSTRAINT domain_option_pk PRIMARY KEY (id);


--
-- TOC entry 3165 (class 2606 OID 621047)
-- Dependencies: 2266 2266
-- Name: donotscan_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY donotscan
    ADD CONSTRAINT donotscan_pk PRIMARY KEY (id);


--
-- TOC entry 3167 (class 2606 OID 621049)
-- Dependencies: 2266 2266
-- Name: donotscan_un; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY donotscan
    ADD CONSTRAINT donotscan_un UNIQUE (subnetmask);


--
-- TOC entry 3297 (class 2606 OID 621051)
-- Dependencies: 2315 2315
-- Name: duplicateip_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY duplicateip
    ADD CONSTRAINT duplicateip_pk PRIMARY KEY (id);


--
-- TOC entry 3299 (class 2606 OID 621053)
-- Dependencies: 2315 2315 2315 2315
-- Name: duplicateip_un; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY duplicateip
    ADD CONSTRAINT duplicateip_un UNIQUE (ipaddr, interfaceid, deviceid);


--
-- TOC entry 3221 (class 2606 OID 621055)
-- Dependencies: 2281 2281
-- Name: file_info_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY object_file_info
    ADD CONSTRAINT file_info_pk PRIMARY KEY (id);


--
-- TOC entry 3223 (class 2606 OID 621057)
-- Dependencies: 2281 2281 2281 2281 2281 2281
-- Name: file_info_uk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY object_file_info
    ADD CONSTRAINT file_info_uk UNIQUE (object_id, object_type, file_type, file_real_name, path_id);


--
-- TOC entry 3302 (class 2606 OID 621059)
-- Dependencies: 2317 2317
-- Name: fixupnatinfo_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY fixupnatinfo
    ADD CONSTRAINT fixupnatinfo_pk PRIMARY KEY (id);


--
-- TOC entry 3307 (class 2606 OID 621061)
-- Dependencies: 2318 2318
-- Name: fixuproutetable_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY fixuproutetable
    ADD CONSTRAINT fixuproutetable_pk PRIMARY KEY (id);


--
-- TOC entry 3309 (class 2606 OID 621063)
-- Dependencies: 2318 2318 2318 2318 2318 2318
-- Name: fixuproutetable_uniq_item; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY fixuproutetable
    ADD CONSTRAINT fixuproutetable_uniq_item UNIQUE (deviceid, destip, destmask, infname, nexthopip);


--
-- TOC entry 3312 (class 2606 OID 621065)
-- Dependencies: 2319 2319
-- Name: fixuproutetablepriority_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY fixuproutetablepriority
    ADD CONSTRAINT fixuproutetablepriority_pkey PRIMARY KEY (id);


--
-- TOC entry 3314 (class 2606 OID 621067)
-- Dependencies: 2319 2319
-- Name: fixuproutetablepriority_un; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY fixuproutetablepriority
    ADD CONSTRAINT fixuproutetablepriority_un UNIQUE (deviceid);


--
-- TOC entry 3321 (class 2606 OID 621069)
-- Dependencies: 2320 2320
-- Name: fixupunnumberedinterface_pk_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY fixupunnumberedinterface
    ADD CONSTRAINT fixupunnumberedinterface_pk_id PRIMARY KEY (id);


--
-- TOC entry 3323 (class 2606 OID 621071)
-- Dependencies: 2320 2320 2320 2320 2320
-- Name: fixupunnumberedinterface_uniq_connect; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY fixupunnumberedinterface
    ADD CONSTRAINT fixupunnumberedinterface_uniq_connect UNIQUE (sourcedevice, sourceport, destdevice, destport);


--
-- TOC entry 3498 (class 2606 OID 621073)
-- Dependencies: 2435 2435
-- Name: globeinfo_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY globeinfo
    ADD CONSTRAINT globeinfo_pk PRIMARY KEY (id);


--
-- TOC entry 3171 (class 2606 OID 621075)
-- Dependencies: 2267 2267
-- Name: interface_customized_info_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY interface_customized_info
    ADD CONSTRAINT interface_customized_info_pk PRIMARY KEY (id);


--
-- TOC entry 3173 (class 2606 OID 621077)
-- Dependencies: 2267 2267 2267
-- Name: interface_customized_info_un; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY interface_customized_info
    ADD CONSTRAINT interface_customized_info_un UNIQUE (objectid, attributeid);


--
-- TOC entry 3178 (class 2606 OID 621079)
-- Dependencies: 2268 2268
-- Name: interfacesetting_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY interfacesetting
    ADD CONSTRAINT interfacesetting_pkey PRIMARY KEY (id);


--
-- TOC entry 3180 (class 2606 OID 621081)
-- Dependencies: 2268 2268 2268
-- Name: interfacesetting_un; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY interfacesetting
    ADD CONSTRAINT interfacesetting_un UNIQUE (deviceid, interfacename);


--
-- TOC entry 3325 (class 2606 OID 621083)
-- Dependencies: 2321 2321
-- Name: internetboundaryinterface_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY internetboundaryinterface
    ADD CONSTRAINT internetboundaryinterface_pk PRIMARY KEY (id);


--
-- TOC entry 3327 (class 2606 OID 621085)
-- Dependencies: 2321 2321 2321 2321
-- Name: internetboundaryinterface_un; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY internetboundaryinterface
    ADD CONSTRAINT internetboundaryinterface_un UNIQUE (deviceid, interfaceid, interfaceip);


--
-- TOC entry 3187 (class 2606 OID 621087)
-- Dependencies: 2272 2272
-- Name: ip2mac_pk_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ip2mac
    ADD CONSTRAINT ip2mac_pk_id PRIMARY KEY (id);


--
-- TOC entry 3189 (class 2606 OID 621089)
-- Dependencies: 2272 2272 2272
-- Name: ip2mac_uniq_lan; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ip2mac
    ADD CONSTRAINT ip2mac_uniq_lan UNIQUE (ip, mac);


--
-- TOC entry 3329 (class 2606 OID 621091)
-- Dependencies: 2323 2323
-- Name: ipphone_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ipphone
    ADD CONSTRAINT ipphone_pkey PRIMARY KEY (id);


--
-- TOC entry 3331 (class 2606 OID 621093)
-- Dependencies: 2323 2323
-- Name: ipphone_un; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ipphone
    ADD CONSTRAINT ipphone_un UNIQUE (phone_name);


--
-- TOC entry 3196 (class 2606 OID 621095)
-- Dependencies: 2273 2273
-- Name: l2connectivity_pk_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY l2connectivity
    ADD CONSTRAINT l2connectivity_pk_id PRIMARY KEY (id);


--
-- TOC entry 3199 (class 2606 OID 621097)
-- Dependencies: 2274 2274
-- Name: l2switchinfo_pk_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY l2switchinfo
    ADD CONSTRAINT l2switchinfo_pk_id PRIMARY KEY (id);


--
-- TOC entry 3335 (class 2606 OID 621099)
-- Dependencies: 2324 2324
-- Name: l2switchport_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY l2switchport
    ADD CONSTRAINT l2switchport_pk PRIMARY KEY (id);


--
-- TOC entry 3341 (class 2606 OID 621101)
-- Dependencies: 2325 2325
-- Name: l2switchport_temp_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY l2switchport_temp
    ADD CONSTRAINT l2switchport_temp_pk PRIMARY KEY (id);


--
-- TOC entry 3343 (class 2606 OID 621103)
-- Dependencies: 2325 2325 2325
-- Name: l2switchport_temp_un; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY l2switchport_temp
    ADD CONSTRAINT l2switchport_temp_un UNIQUE (switchname, portname);


--
-- TOC entry 3337 (class 2606 OID 621105)
-- Dependencies: 2324 2324 2324
-- Name: l2switchport_un; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY l2switchport
    ADD CONSTRAINT l2switchport_un UNIQUE (switchname, portname);


--
-- TOC entry 3347 (class 2606 OID 621107)
-- Dependencies: 2326 2326
-- Name: l2switchvlan_pk_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY l2switchvlan
    ADD CONSTRAINT l2switchvlan_pk_id PRIMARY KEY (id);


--
-- TOC entry 3349 (class 2606 OID 621109)
-- Dependencies: 2326 2326 2326
-- Name: l2switchvlan_uniq_name; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY l2switchvlan
    ADD CONSTRAINT l2switchvlan_uniq_name UNIQUE (switchname, vlannumber);


--
-- TOC entry 3204 (class 2606 OID 621111)
-- Dependencies: 2275 2275
-- Name: lanswitch_pk_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY lanswitch
    ADD CONSTRAINT lanswitch_pk_id PRIMARY KEY (id);


--
-- TOC entry 3206 (class 2606 OID 621113)
-- Dependencies: 2275 2275 2275
-- Name: lanswitch_uniq_name; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY lanswitch
    ADD CONSTRAINT lanswitch_uniq_name UNIQUE (lanname, switchname);


--
-- TOC entry 3351 (class 2606 OID 621115)
-- Dependencies: 2327 2327
-- Name: linkgroup_dev_devicegroup_pk_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY linkgroup_dev_devicegroup
    ADD CONSTRAINT linkgroup_dev_devicegroup_pk_id PRIMARY KEY (id);


--
-- TOC entry 3353 (class 2606 OID 621117)
-- Dependencies: 2329 2329
-- Name: linkgroup_dev_site_pk_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY linkgroup_dev_site
    ADD CONSTRAINT linkgroup_dev_site_pk_id PRIMARY KEY (id);


--
-- TOC entry 3355 (class 2606 OID 621119)
-- Dependencies: 2329 2329 2329 2329
-- Name: linkgroup_dev_site_uniq_lkgroupid; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY linkgroup_dev_site
    ADD CONSTRAINT linkgroup_dev_site_uniq_lkgroupid UNIQUE (groupid, siteid, sitechild);


--
-- TOC entry 3357 (class 2606 OID 621121)
-- Dependencies: 2331 2331
-- Name: linkgroup_dev_systemdevicegroup_pk_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY linkgroup_dev_systemdevicegroup
    ADD CONSTRAINT linkgroup_dev_systemdevicegroup_pk_id PRIMARY KEY (id);


--
-- TOC entry 3374 (class 2606 OID 621123)
-- Dependencies: 2343 2343 2343
-- Name: linkgroup_param_name_un; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY linkgroup_param
    ADD CONSTRAINT linkgroup_param_name_un UNIQUE (strname, linkgroupid);


--
-- TOC entry 3376 (class 2606 OID 621125)
-- Dependencies: 2343 2343
-- Name: linkgroup_param_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY linkgroup_param
    ADD CONSTRAINT linkgroup_param_pk PRIMARY KEY (id);


--
-- TOC entry 3359 (class 2606 OID 621127)
-- Dependencies: 2333 2333
-- Name: linkgroup_paramvalue_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY linkgroup_paramvalue
    ADD CONSTRAINT linkgroup_paramvalue_pk PRIMARY KEY (id);


--
-- TOC entry 3208 (class 2606 OID 621129)
-- Dependencies: 2276 2276
-- Name: linkgroup_pk_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY linkgroup
    ADD CONSTRAINT linkgroup_pk_id PRIMARY KEY (id);


--
-- TOC entry 3368 (class 2606 OID 621131)
-- Dependencies: 2338 2338
-- Name: linkgroupdevice_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY linkgroupdevice
    ADD CONSTRAINT linkgroupdevice_pk PRIMARY KEY (id);


--
-- TOC entry 3370 (class 2606 OID 621133)
-- Dependencies: 2338 2338 2338 2338
-- Name: linkgroupdevice_unique; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY linkgroupdevice
    ADD CONSTRAINT linkgroupdevice_unique UNIQUE (linkgroupid, deviceid, type);


--
-- TOC entry 3365 (class 2606 OID 621135)
-- Dependencies: 2336 2336
-- Name: linkgroupdevicegroup_pk_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY linkgroupdevicegroup
    ADD CONSTRAINT linkgroupdevicegroup_pk_id PRIMARY KEY (id);


--
-- TOC entry 3361 (class 2606 OID 621137)
-- Dependencies: 2334 2334
-- Name: linkgroupinterface_pk_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY linkgroupinterface
    ADD CONSTRAINT linkgroupinterface_pk_id PRIMARY KEY (id);


--
-- TOC entry 3363 (class 2606 OID 621139)
-- Dependencies: 2334 2334 2334 2334 2334 2334
-- Name: linkgroupinterface_uniq_git; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY linkgroupinterface
    ADD CONSTRAINT linkgroupinterface_uniq_git UNIQUE (groupid, type, interfaceid, interfaceip, deviceid);


--
-- TOC entry 3372 (class 2606 OID 621141)
-- Dependencies: 2341 2341
-- Name: linkgrouplinkgroup_pk_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY linkgrouplinkgroup
    ADD CONSTRAINT linkgrouplinkgroup_pk_id PRIMARY KEY (id);


--
-- TOC entry 3378 (class 2606 OID 621143)
-- Dependencies: 2344 2344
-- Name: linkgroupsite_pk_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY linkgroupsite
    ADD CONSTRAINT linkgroupsite_pk_id PRIMARY KEY (id);


--
-- TOC entry 3380 (class 2606 OID 621145)
-- Dependencies: 2344 2344 2344 2344
-- Name: linkgroupsite_uniq_lkgroupid; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY linkgroupsite
    ADD CONSTRAINT linkgroupsite_uniq_lkgroupid UNIQUE (groupid, siteid, sitechild);


--
-- TOC entry 3382 (class 2606 OID 621147)
-- Dependencies: 2346 2346
-- Name: linkgroupsystemdevicegroup_pk_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY linkgroupsystemdevicegroup
    ADD CONSTRAINT linkgroupsystemdevicegroup_pk_id PRIMARY KEY (id);


--
-- TOC entry 3384 (class 2606 OID 621149)
-- Dependencies: 2348 2348
-- Name: lwap_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY lwap
    ADD CONSTRAINT lwap_pk PRIMARY KEY (id);


--
-- TOC entry 3386 (class 2606 OID 621151)
-- Dependencies: 2348 2348
-- Name: lwap_un; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY lwap
    ADD CONSTRAINT lwap_un UNIQUE (hostname);


--
-- TOC entry 3212 (class 2606 OID 621153)
-- Dependencies: 2277 2277
-- Name: module_customized_info_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY module_customized_info
    ADD CONSTRAINT module_customized_info_pk PRIMARY KEY (id);


--
-- TOC entry 3214 (class 2606 OID 621155)
-- Dependencies: 2277 2277 2277
-- Name: module_customized_info_un; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY module_customized_info
    ADD CONSTRAINT module_customized_info_un UNIQUE (objectid, attributeid);


--
-- TOC entry 3217 (class 2606 OID 621157)
-- Dependencies: 2278 2278
-- Name: module_property_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY module_property
    ADD CONSTRAINT module_property_pk PRIMARY KEY (id);


--
-- TOC entry 3219 (class 2606 OID 621159)
-- Dependencies: 2278 2278 2278
-- Name: module_property_un; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY module_property
    ADD CONSTRAINT module_property_un UNIQUE (deviceid, slot);


--
-- TOC entry 3394 (class 2606 OID 621161)
-- Dependencies: 2350 2350
-- Name: nat_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY nat
    ADD CONSTRAINT nat_pk PRIMARY KEY (id);


--
-- TOC entry 3399 (class 2606 OID 621163)
-- Dependencies: 2351 2351
-- Name: natinterface_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY natinterface
    ADD CONSTRAINT natinterface_pkey PRIMARY KEY (id);


--
-- TOC entry 3390 (class 2606 OID 621165)
-- Dependencies: 2349 2349
-- Name: nattointf_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY nattointf
    ADD CONSTRAINT nattointf_pkey PRIMARY KEY (id);


--
-- TOC entry 3401 (class 2606 OID 621167)
-- Dependencies: 2353 2353
-- Name: nbpk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY nd
    ADD CONSTRAINT nbpk PRIMARY KEY (id);


--
-- TOC entry 3141 (class 2606 OID 621169)
-- Dependencies: 2255 2255
-- Name: nomp_appliance_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY nomp_appliance
    ADD CONSTRAINT nomp_appliance_pk PRIMARY KEY (id);


--
-- TOC entry 3143 (class 2606 OID 621171)
-- Dependencies: 2255 2255
-- Name: nomp_appliance_un_houstname; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY nomp_appliance
    ADD CONSTRAINT nomp_appliance_un_houstname UNIQUE (strhostname);


--
-- TOC entry 3145 (class 2606 OID 621173)
-- Dependencies: 2255 2255
-- Name: nomp_appliance_un_ip; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY nomp_appliance
    ADD CONSTRAINT nomp_appliance_un_ip UNIQUE (stripaddr);


--
-- TOC entry 3403 (class 2606 OID 621175)
-- Dependencies: 2356 2356
-- Name: nomp_enablepasswd_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY nomp_enablepasswd
    ADD CONSTRAINT nomp_enablepasswd_pk PRIMARY KEY (id);


--
-- TOC entry 3405 (class 2606 OID 621177)
-- Dependencies: 2356 2356
-- Name: nomp_enablepasswd_un_alias; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY nomp_enablepasswd
    ADD CONSTRAINT nomp_enablepasswd_un_alias UNIQUE (stralias);


--
-- TOC entry 3407 (class 2606 OID 621179)
-- Dependencies: 2359 2359
-- Name: nomp_jumpbox_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY nomp_jumpbox
    ADD CONSTRAINT nomp_jumpbox_pk PRIMARY KEY (id);


--
-- TOC entry 3409 (class 2606 OID 621181)
-- Dependencies: 2359 2359 2359 2359
-- Name: nomp_jumpbox_strname_userid_un; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY nomp_jumpbox
    ADD CONSTRAINT nomp_jumpbox_strname_userid_un UNIQUE (strname, userid, licguid);


--
-- TOC entry 3411 (class 2606 OID 621183)
-- Dependencies: 2359 2359 2359 2359 2359
-- Name: nomp_jumpbox_unique_type_ipaddr_port; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY nomp_jumpbox
    ADD CONSTRAINT nomp_jumpbox_unique_type_ipaddr_port UNIQUE (itype, stripaddr, iport, userid);


--
-- TOC entry 3413 (class 2606 OID 621185)
-- Dependencies: 2362 2362
-- Name: nomp_snmpro_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY nomp_snmproinfo
    ADD CONSTRAINT nomp_snmpro_pkey PRIMARY KEY (id);


--
-- TOC entry 3415 (class 2606 OID 621187)
-- Dependencies: 2362 2362
-- Name: nomp_snmpro_uniqalias; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY nomp_snmproinfo
    ADD CONSTRAINT nomp_snmpro_uniqalias UNIQUE (stralias);


--
-- TOC entry 3500 (class 2606 OID 621189)
-- Dependencies: 2476 2476
-- Name: nomp_snmprwinfo_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY nomp_snmprwinfo
    ADD CONSTRAINT nomp_snmprwinfo_pk PRIMARY KEY (id);


--
-- TOC entry 3502 (class 2606 OID 621191)
-- Dependencies: 2476 2476
-- Name: nomp_snmprwinfo_un_rwstring; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY nomp_snmprwinfo
    ADD CONSTRAINT nomp_snmprwinfo_un_rwstring UNIQUE (strrwstring);


--
-- TOC entry 3418 (class 2606 OID 621193)
-- Dependencies: 2365 2365
-- Name: nomp_telnetinfo_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY nomp_telnetinfo
    ADD CONSTRAINT nomp_telnetinfo_pk PRIMARY KEY (id);


--
-- TOC entry 3420 (class 2606 OID 621195)
-- Dependencies: 2365 2365 2365 2365
-- Name: nomp_telnetinfo_uniq_item; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY nomp_telnetinfo
    ADD CONSTRAINT nomp_telnetinfo_uniq_item UNIQUE (userid, licguid, stralias);


--
-- TOC entry 3504 (class 2606 OID 621197)
-- Dependencies: 2479 2479 2479
-- Name: object_customized_attribute_object_alias_un; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY object_customized_attribute
    ADD CONSTRAINT object_customized_attribute_object_alias_un UNIQUE (objectid, alias);


--
-- TOC entry 3506 (class 2606 OID 621199)
-- Dependencies: 2479 2479 2479
-- Name: object_customized_attribute_object_name_un; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY object_customized_attribute
    ADD CONSTRAINT object_customized_attribute_object_name_un UNIQUE (objectid, name);


--
-- TOC entry 3508 (class 2606 OID 621201)
-- Dependencies: 2479 2479
-- Name: object_customized_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY object_customized_attribute
    ADD CONSTRAINT object_customized_attribute_pk PRIMARY KEY (id);


--
-- TOC entry 3510 (class 2606 OID 621203)
-- Dependencies: 2482 2482
-- Name: object_file_path_info_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY object_file_path_info
    ADD CONSTRAINT object_file_path_info_pk PRIMARY KEY (id);


--
-- TOC entry 3512 (class 2606 OID 621205)
-- Dependencies: 2482 2482 2482 2482
-- Name: object_file_path_info_un; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY object_file_path_info
    ADD CONSTRAINT object_file_path_info_un UNIQUE (parentid, path, object_type);


--
-- TOC entry 3514 (class 2606 OID 621207)
-- Dependencies: 2484 2484
-- Name: objprivatetimestamp_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY objprivatetimestamp
    ADD CONSTRAINT objprivatetimestamp_pk PRIMARY KEY (id);


--
-- TOC entry 3516 (class 2606 OID 621209)
-- Dependencies: 2484 2484 2484 2484
-- Name: objprivatetimestamp_un; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY objprivatetimestamp
    ADD CONSTRAINT objprivatetimestamp_un UNIQUE (userid, typename, licguid);


--
-- TOC entry 3226 (class 2606 OID 621211)
-- Dependencies: 2282 2282
-- Name: ouinfo_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ouinfo
    ADD CONSTRAINT ouinfo_pk PRIMARY KEY (id);


--
-- TOC entry 3228 (class 2606 OID 621213)
-- Dependencies: 2282 2282
-- Name: ouinfo_un; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ouinfo
    ADD CONSTRAINT ouinfo_un UNIQUE (mac_prefix);


--
-- TOC entry 3453 (class 2606 OID 621215)
-- Dependencies: 2384 2384
-- Name: pk_benchmarktaskstatus_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY benchmarktaskstatus
    ADD CONSTRAINT pk_benchmarktaskstatus_id PRIMARY KEY (id);


--
-- TOC entry 3494 (class 2606 OID 621217)
-- Dependencies: 2425 2425
-- Name: pk_domain_name_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY domain_name
    ADD CONSTRAINT pk_domain_name_id PRIMARY KEY (id);


--
-- TOC entry 3518 (class 2606 OID 621219)
-- Dependencies: 2486 2486
-- Name: pk_objtimestamp_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY objtimestamp
    ADD CONSTRAINT pk_objtimestamp_id PRIMARY KEY (id);


--
-- TOC entry 3549 (class 2606 OID 621221)
-- Dependencies: 2514 2514
-- Name: pk_system_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY system_info
    ADD CONSTRAINT pk_system_id PRIMARY KEY (id);


--
-- TOC entry 3523 (class 2606 OID 621223)
-- Dependencies: 2494 2494
-- Name: showcmdbtaskdgpk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY showcommandbenchmarktaskdgdetail
    ADD CONSTRAINT showcmdbtaskdgpk PRIMARY KEY (id);


--
-- TOC entry 3520 (class 2606 OID 621225)
-- Dependencies: 2492 2492
-- Name: showcmdbtaskpk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY showcommandbenchmarktaskcmddetail
    ADD CONSTRAINT showcmdbtaskpk PRIMARY KEY (id);


--
-- TOC entry 3528 (class 2606 OID 621227)
-- Dependencies: 2496 2496
-- Name: showcmdbtasksitepk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY showcommandbenchmarktasksitedetail
    ADD CONSTRAINT showcmdbtasksitepk PRIMARY KEY (id);


--
-- TOC entry 3525 (class 2606 OID 621229)
-- Dependencies: 2494 2494 2494
-- Name: showcmdbtaskuni; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY showcommandbenchmarktaskdgdetail
    ADD CONSTRAINT showcmdbtaskuni UNIQUE (taskid, devicegroupid);


--
-- TOC entry 3530 (class 2606 OID 621231)
-- Dependencies: 2496 2496 2496
-- Name: showcmdtasksiteuni; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY showcommandbenchmarktasksitedetail
    ADD CONSTRAINT showcmdtasksiteuni UNIQUE (taskid, siteid);


--
-- TOC entry 3230 (class 2606 OID 621233)
-- Dependencies: 2283 2283
-- Name: showcommandbenchmarktask_pki; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY showcommandbenchmarktask
    ADD CONSTRAINT showcommandbenchmarktask_pki PRIMARY KEY (id);


--
-- TOC entry 3423 (class 2606 OID 621235)
-- Dependencies: 2367 2367
-- Name: showcommandtemplate_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY showcommandtemplate
    ADD CONSTRAINT showcommandtemplate_pk PRIMARY KEY (id);


--
-- TOC entry 3425 (class 2606 OID 621237)
-- Dependencies: 2367 2367 2367
-- Name: showcommandtemplate_un; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY showcommandtemplate
    ADD CONSTRAINT showcommandtemplate_un UNIQUE (name, licguid);


--
-- TOC entry 3427 (class 2606 OID 621239)
-- Dependencies: 2368 2368
-- Name: site2site_pk_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY site2site
    ADD CONSTRAINT site2site_pk_id PRIMARY KEY (id);


--
-- TOC entry 3429 (class 2606 OID 621241)
-- Dependencies: 2368 2368
-- Name: site2site_uniq_siteid; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY site2site
    ADD CONSTRAINT site2site_uniq_siteid UNIQUE (siteid);


--
-- TOC entry 3232 (class 2606 OID 621243)
-- Dependencies: 2284 2284
-- Name: site_pk_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY site
    ADD CONSTRAINT site_pk_id PRIMARY KEY (id);


--
-- TOC entry 3234 (class 2606 OID 621245)
-- Dependencies: 2284 2284
-- Name: site_uniq_name; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY site
    ADD CONSTRAINT site_uniq_name UNIQUE (name);


--
-- TOC entry 3236 (class 2606 OID 621247)
-- Dependencies: 2285 2285
-- Name: sitecustomizedinfo_pk_Id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY site_customized_info
    ADD CONSTRAINT "sitecustomizedinfo_pk_Id" PRIMARY KEY (id);


--
-- TOC entry 3238 (class 2606 OID 621249)
-- Dependencies: 2285 2285 2285
-- Name: sitecustomizeinfo_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY site_customized_info
    ADD CONSTRAINT sitecustomizeinfo_uniq UNIQUE (objectid, attributeid);


--
-- TOC entry 3432 (class 2606 OID 621251)
-- Dependencies: 2370 2370
-- Name: switchgroup_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY switchgroup
    ADD CONSTRAINT switchgroup_pk PRIMARY KEY (id);


--
-- TOC entry 3434 (class 2606 OID 621253)
-- Dependencies: 2370 2370
-- Name: switchgroup_un; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY switchgroup
    ADD CONSTRAINT switchgroup_un UNIQUE (strname);


--
-- TOC entry 3437 (class 2606 OID 621255)
-- Dependencies: 2371 2371
-- Name: swtichgroupdevice_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY swtichgroupdevice
    ADD CONSTRAINT swtichgroupdevice_pk PRIMARY KEY (id);


--
-- TOC entry 3439 (class 2606 OID 621257)
-- Dependencies: 2371 2371 2371
-- Name: swtichgroupdevice_un; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY swtichgroupdevice
    ADD CONSTRAINT swtichgroupdevice_un UNIQUE (deviceid, switchgroupid);


--
-- TOC entry 3283 (class 2606 OID 621259)
-- Dependencies: 2305 2305
-- Name: symbol2deviceicon_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY symbol2deviceicon
    ADD CONSTRAINT symbol2deviceicon_pk PRIMARY KEY (id);


--
-- TOC entry 3533 (class 2606 OID 621261)
-- Dependencies: 2506 2506
-- Name: symbol2deviceicon_selected_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY symbol2deviceicon_selected
    ADD CONSTRAINT symbol2deviceicon_selected_pk PRIMARY KEY (id);


--
-- TOC entry 3535 (class 2606 OID 621263)
-- Dependencies: 2506 2506 2506 2506
-- Name: symbol2deviceicon_selected_symbol_icon_un; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY symbol2deviceicon_selected
    ADD CONSTRAINT symbol2deviceicon_selected_symbol_icon_un UNIQUE (symbolid, default_deviceicon_id, selected_deviceicon_id);


--
-- TOC entry 3537 (class 2606 OID 621265)
-- Dependencies: 2506 2506
-- Name: symbol2deviceicon_selected_symbol_un; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY symbol2deviceicon_selected
    ADD CONSTRAINT symbol2deviceicon_selected_symbol_un UNIQUE (symbolid);


--
-- TOC entry 3539 (class 2606 OID 621267)
-- Dependencies: 2506 2506
-- Name: symbol2deviceicon_selected_un; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY symbol2deviceicon_selected
    ADD CONSTRAINT symbol2deviceicon_selected_un UNIQUE (selected_deviceicon_id);


--
-- TOC entry 3285 (class 2606 OID 621269)
-- Dependencies: 2305 2305 2305
-- Name: symbol2deviceicon_un; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY symbol2deviceicon
    ADD CONSTRAINT symbol2deviceicon_un UNIQUE (symbolid, deviceicon_id);


--
-- TOC entry 3541 (class 2606 OID 621271)
-- Dependencies: 2508 2508
-- Name: sys_environmentvariable_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY sys_environmentvariable
    ADD CONSTRAINT sys_environmentvariable_pk PRIMARY KEY (id);


--
-- TOC entry 3543 (class 2606 OID 621273)
-- Dependencies: 2508 2508
-- Name: sys_environmentvariable_un; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY sys_environmentvariable
    ADD CONSTRAINT sys_environmentvariable_un UNIQUE (variable);


--
-- TOC entry 3545 (class 2606 OID 621275)
-- Dependencies: 2510 2510
-- Name: sys_option_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY sys_option
    ADD CONSTRAINT sys_option_pk PRIMARY KEY (id);


--
-- TOC entry 3547 (class 2606 OID 621277)
-- Dependencies: 2510 2510
-- Name: sys_option_un; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY sys_option
    ADD CONSTRAINT sys_option_un UNIQUE (op_name);


--
-- TOC entry 3240 (class 2606 OID 621279)
-- Dependencies: 2288 2288
-- Name: system_devicespec_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY system_devicespec
    ADD CONSTRAINT system_devicespec_pk PRIMARY KEY (id);


--
-- TOC entry 3242 (class 2606 OID 621281)
-- Dependencies: 2288 2288 2288
-- Name: system_devicespec_un; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY system_devicespec
    ADD CONSTRAINT system_devicespec_un UNIQUE (idevicetype, strmodelname);


--
-- TOC entry 3551 (class 2606 OID 621283)
-- Dependencies: 2515 2515
-- Name: system_interfacecfg_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY system_interfacecfg
    ADD CONSTRAINT system_interfacecfg_pk PRIMARY KEY (id);


--
-- TOC entry 3554 (class 2606 OID 621285)
-- Dependencies: 2516 2516
-- Name: system_vendormodel2device_icon_icon_un; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY system_vendormodel2device_icon
    ADD CONSTRAINT system_vendormodel2device_icon_icon_un UNIQUE (deviceicon_id);


--
-- TOC entry 3556 (class 2606 OID 621287)
-- Dependencies: 2516 2516
-- Name: system_vendormodel2device_icon_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY system_vendormodel2device_icon
    ADD CONSTRAINT system_vendormodel2device_icon_pk PRIMARY KEY (id);


--
-- TOC entry 3558 (class 2606 OID 621289)
-- Dependencies: 2516 2516 2516
-- Name: system_vendormodel2device_icon_un; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY system_vendormodel2device_icon
    ADD CONSTRAINT system_vendormodel2device_icon_un UNIQUE (vendormodel_id, deviceicon_id);


--
-- TOC entry 3560 (class 2606 OID 621291)
-- Dependencies: 2516 2516
-- Name: system_vendormodel2device_icon_vendor_un; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY system_vendormodel2device_icon
    ADD CONSTRAINT system_vendormodel2device_icon_vendor_un UNIQUE (vendormodel_id);


--
-- TOC entry 3244 (class 2606 OID 621293)
-- Dependencies: 2290 2290
-- Name: system_vendormodel_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY system_vendormodel
    ADD CONSTRAINT system_vendormodel_pk PRIMARY KEY (id);


--
-- TOC entry 3246 (class 2606 OID 621295)
-- Dependencies: 2290 2290
-- Name: system_vendormodel_un; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY system_vendormodel
    ADD CONSTRAINT system_vendormodel_un UNIQUE (stroid);


--
-- TOC entry 3274 (class 2606 OID 621297)
-- Dependencies: 2302 2302
-- Name: systemdevicegroup_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY systemdevicegroup
    ADD CONSTRAINT systemdevicegroup_pk PRIMARY KEY (id);


--
-- TOC entry 3276 (class 2606 OID 621299)
-- Dependencies: 2302 2302
-- Name: systemdevicegroup_un_name; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY systemdevicegroup
    ADD CONSTRAINT systemdevicegroup_un_name UNIQUE (strname);


--
-- TOC entry 3442 (class 2606 OID 621301)
-- Dependencies: 2374 2374
-- Name: systemdevicegroupdevice_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY systemdevicegroupdevice
    ADD CONSTRAINT systemdevicegroupdevice_pk PRIMARY KEY (id);


--
-- TOC entry 3444 (class 2606 OID 621303)
-- Dependencies: 2374 2374 2374
-- Name: systemdevicegroupdevice_unique; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY systemdevicegroupdevice
    ADD CONSTRAINT systemdevicegroupdevice_unique UNIQUE (systemdevicegroupid, deviceid);


--
-- TOC entry 3248 (class 2606 OID 621305)
-- Dependencies: 2291 2291
-- Name: transport_protocol_port_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY transport_protocol_port
    ADD CONSTRAINT transport_protocol_port_pk PRIMARY KEY (id);


--
-- TOC entry 3250 (class 2606 OID 621307)
-- Dependencies: 2291 2291 2291
-- Name: transport_protocol_port_un; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY transport_protocol_port
    ADD CONSTRAINT transport_protocol_port_un UNIQUE (portnumber, protocol);


--
-- TOC entry 3161 (class 2606 OID 621309)
-- Dependencies: 2264 2264
-- Name: unknownip_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY unknownip
    ADD CONSTRAINT unknownip_pk PRIMARY KEY (id);


--
-- TOC entry 3163 (class 2606 OID 621311)
-- Dependencies: 2264 2264
-- Name: unknownip_un_nexthopip; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY unknownip
    ADD CONSTRAINT unknownip_un_nexthopip UNIQUE (nexthopip);


--
-- TOC entry 3254 (class 2606 OID 621313)
-- Dependencies: 2292 2292
-- Name: userdevicesetting_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY userdevicesetting
    ADD CONSTRAINT userdevicesetting_pk PRIMARY KEY (id);


--
-- TOC entry 3256 (class 2606 OID 621315)
-- Dependencies: 2292 2292 2292 2292
-- Name: userdevicesetting_unique; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY userdevicesetting
    ADD CONSTRAINT userdevicesetting_unique UNIQUE (deviceid, userid, licguid);


--
-- TOC entry 3565 (class 2606 OID 621317)
-- Dependencies: 2523 2523
-- Name: wanlink_pk_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY wanlink
    ADD CONSTRAINT wanlink_pk_id PRIMARY KEY (id);


--
-- TOC entry 3567 (class 2606 OID 621319)
-- Dependencies: 2523 2523 2523 2523
-- Name: wanlink_uniq_wan_infs; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY wanlink
    ADD CONSTRAINT wanlink_uniq_wan_infs UNIQUE (wanid, inf1id, inf2id);


--
-- TOC entry 3570 (class 2606 OID 621321)
-- Dependencies: 2525 2525
-- Name: wans_pk_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY wans
    ADD CONSTRAINT wans_pk_id PRIMARY KEY (id);


--
-- TOC entry 3451 (class 1259 OID 621322)
-- Dependencies: 2384 2384
-- Name: benchmarktaskstatus_index_tasktypeid; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX benchmarktaskstatus_index_tasktypeid ON benchmarktaskstatus USING btree (taskid, tasktype);


--
-- TOC entry 3257 (class 1259 OID 621323)
-- Dependencies: 2293
-- Name: bgpneighbor_idx_deviceid; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX bgpneighbor_idx_deviceid ON bgpneighbor USING btree (deviceid);


--
-- TOC entry 3258 (class 1259 OID 621324)
-- Dependencies: 2293
-- Name: bgpneighbor_idx_remoteas; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX bgpneighbor_idx_remoteas ON bgpneighbor USING btree (remoteasnum);


--
-- TOC entry 3286 (class 1259 OID 621325)
-- Dependencies: 2307
-- Name: devicegroup_idx_protocolname; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX devicegroup_idx_protocolname ON deviceprotocols USING btree (protocalname);


--
-- TOC entry 3115 (class 1259 OID 621326)
-- Dependencies: 2246
-- Name: devicegroup_index_lower_name; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX devicegroup_index_lower_name ON devicegroup USING btree (lower((strname)::text));


--
-- TOC entry 3116 (class 1259 OID 621327)
-- Dependencies: 2246 2246
-- Name: devicegroup_index_name_userid; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX devicegroup_index_name_userid ON devicegroup USING btree (strname, userid);


--
-- TOC entry 3117 (class 1259 OID 621328)
-- Dependencies: 2246
-- Name: devicegroup_index_userid; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX devicegroup_index_userid ON devicegroup USING btree (userid);


--
-- TOC entry 3287 (class 1259 OID 621329)
-- Dependencies: 2307
-- Name: deviceprotocol_idx_deviceid; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX deviceprotocol_idx_deviceid ON deviceprotocols USING btree (deviceid);


--
-- TOC entry 3288 (class 1259 OID 621330)
-- Dependencies: 2307 2307
-- Name: deviceprotocol_idx_timestamp; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX deviceprotocol_idx_timestamp ON deviceprotocols USING btree (deviceid, lastmodifytime);


--
-- TOC entry 3133 (class 1259 OID 621331)
-- Dependencies: 2253
-- Name: devicesetting_idx_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX devicesetting_idx_id ON devicesetting USING btree (id);


--
-- TOC entry 3134 (class 1259 OID 621332)
-- Dependencies: 2253
-- Name: devicesetting_idx_timestamp; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX devicesetting_idx_timestamp ON devicesetting USING btree (lasttimestamp);


--
-- TOC entry 3481 (class 1259 OID 621333)
-- Dependencies: 2410
-- Name: devicevpnname_idx_deviceid; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX devicevpnname_idx_deviceid ON devicevpns USING btree (deviceid);


--
-- TOC entry 3113 (class 1259 OID 621334)
-- Dependencies: 2245
-- Name: devies_index_lower_name; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX devies_index_lower_name ON devices USING btree (lower((strname)::text));


--
-- TOC entry 3114 (class 1259 OID 621335)
-- Dependencies: 2245
-- Name: devies_index_name; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX devies_index_name ON devices USING btree (strname);


--
-- TOC entry 3295 (class 1259 OID 621336)
-- Dependencies: 2315
-- Name: duplicateip_index_ip; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX duplicateip_index_ip ON duplicateip USING btree (ipaddr);


--
-- TOC entry 3300 (class 1259 OID 621337)
-- Dependencies: 2317 2317
-- Name: fixupnatinfo_index_infs; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fixupnatinfo_index_infs ON fixupnatinfo USING btree (ininfid, outinfid);


--
-- TOC entry 3315 (class 1259 OID 621338)
-- Dependencies: 2320
-- Name: fixupunnumberedinterface_idx_destdevice; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fixupunnumberedinterface_idx_destdevice ON fixupunnumberedinterface USING btree (destdevice);


--
-- TOC entry 3316 (class 1259 OID 621339)
-- Dependencies: 2320
-- Name: fixupunnumberedinterface_idx_destport; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fixupunnumberedinterface_idx_destport ON fixupunnumberedinterface USING btree (destport);


--
-- TOC entry 3317 (class 1259 OID 621340)
-- Dependencies: 2320
-- Name: fixupunnumberedinterface_idx_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fixupunnumberedinterface_idx_id ON fixupunnumberedinterface USING btree (id);


--
-- TOC entry 3318 (class 1259 OID 621341)
-- Dependencies: 2320
-- Name: fixupunnumberedinterface_idx_sourcedevice; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fixupunnumberedinterface_idx_sourcedevice ON fixupunnumberedinterface USING btree (sourcedevice);


--
-- TOC entry 3319 (class 1259 OID 621342)
-- Dependencies: 2320
-- Name: fixupunnumberedinterface_idx_sourceport; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fixupunnumberedinterface_idx_sourceport ON fixupunnumberedinterface USING btree (sourceport);


--
-- TOC entry 3460 (class 1259 OID 621343)
-- Dependencies: 2388
-- Name: fki_benchmarktaskstatussteplog_fk_stepid; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_benchmarktaskstatussteplog_fk_stepid ON benchmarktaskstatussteplog USING btree (stepid);


--
-- TOC entry 3129 (class 1259 OID 621344)
-- Dependencies: 2249
-- Name: fki_device_customized_info_attributeid_fk; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_device_customized_info_attributeid_fk ON device_customized_info USING btree (attributeid);


--
-- TOC entry 3130 (class 1259 OID 621345)
-- Dependencies: 2249
-- Name: fki_device_customized_info_objectid_fk; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_device_customized_info_objectid_fk ON device_customized_info USING btree (objectid);


--
-- TOC entry 3124 (class 1259 OID 621346)
-- Dependencies: 2247
-- Name: fki_devicegroupdevice_fk_deviceid; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_devicegroupdevice_fk_deviceid ON devicegroupdevice USING btree (deviceid);


--
-- TOC entry 3139 (class 1259 OID 621347)
-- Dependencies: 2253
-- Name: fki_devicesetting_fk_applicid; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_devicesetting_fk_applicid ON devicesetting USING btree (appliceid);


--
-- TOC entry 3490 (class 1259 OID 621348)
-- Dependencies: 2412
-- Name: fki_disableinterface_fk_infid; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_disableinterface_fk_infid ON disableinterface USING btree (interfaceid);


--
-- TOC entry 3224 (class 1259 OID 621349)
-- Dependencies: 2281
-- Name: fki_file_info_fk; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_file_info_fk ON object_file_info USING btree (file_update_userid);


--
-- TOC entry 3303 (class 1259 OID 621350)
-- Dependencies: 2317
-- Name: fki_fixupnatinfo_fk_deviceid; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_fixupnatinfo_fk_deviceid ON fixupnatinfo USING btree (deviceid);


--
-- TOC entry 3304 (class 1259 OID 621351)
-- Dependencies: 2317
-- Name: fki_fixupnatinfo_fk_ininfid; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_fixupnatinfo_fk_ininfid ON fixupnatinfo USING btree (ininfid);


--
-- TOC entry 3305 (class 1259 OID 621352)
-- Dependencies: 2317
-- Name: fki_fixupnatinfo_fk_outinfid; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_fixupnatinfo_fk_outinfid ON fixupnatinfo USING btree (outinfid);


--
-- TOC entry 3310 (class 1259 OID 621353)
-- Dependencies: 2318
-- Name: fki_fixuproutetable_fk_deviceid; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_fixuproutetable_fk_deviceid ON fixuproutetable USING btree (deviceid);


--
-- TOC entry 3168 (class 1259 OID 621354)
-- Dependencies: 2267
-- Name: fki_interface_customized_info_attributeid_fk; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_interface_customized_info_attributeid_fk ON interface_customized_info USING btree (attributeid);


--
-- TOC entry 3169 (class 1259 OID 621355)
-- Dependencies: 2267
-- Name: fki_interface_customized_info_info_objectid_fk; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_interface_customized_info_info_objectid_fk ON interface_customized_info USING btree (objectid);


--
-- TOC entry 3366 (class 1259 OID 621356)
-- Dependencies: 2338
-- Name: fki_linkgroupdevice_fk_deviceid; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_linkgroupdevice_fk_deviceid ON linkgroupdevice USING btree (deviceid);


--
-- TOC entry 3209 (class 1259 OID 621357)
-- Dependencies: 2277
-- Name: fki_module_customized_info_attributeid_fk; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_module_customized_info_attributeid_fk ON module_customized_info USING btree (attributeid);


--
-- TOC entry 3210 (class 1259 OID 621358)
-- Dependencies: 2277
-- Name: fki_module_customized_info_objectid_fk; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_module_customized_info_objectid_fk ON module_customized_info USING btree (objectid);


--
-- TOC entry 3215 (class 1259 OID 621359)
-- Dependencies: 2278
-- Name: fki_module_property_fk; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_module_property_fk ON module_property USING btree (deviceid);


--
-- TOC entry 3391 (class 1259 OID 621360)
-- Dependencies: 2350
-- Name: fki_nat_pk_deviceid; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_nat_pk_deviceid ON nat USING btree (deviceid);


--
-- TOC entry 3395 (class 1259 OID 621361)
-- Dependencies: 2351
-- Name: fki_natinterface_fk_ininf; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_natinterface_fk_ininf ON natinterface USING btree (inintfid);


--
-- TOC entry 3396 (class 1259 OID 621362)
-- Dependencies: 2351
-- Name: fki_natinterface_fk_outinfid; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_natinterface_fk_outinfid ON natinterface USING btree (outintfid);


--
-- TOC entry 3387 (class 1259 OID 621363)
-- Dependencies: 2349
-- Name: fki_nattointf; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_nattointf ON nattointf USING btree (natid);


--
-- TOC entry 3388 (class 1259 OID 621364)
-- Dependencies: 2349
-- Name: fki_nattointf_fk_natinfid; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_nattointf_fk_natinfid ON nattointf USING btree (natintfid);


--
-- TOC entry 3521 (class 1259 OID 621365)
-- Dependencies: 2494
-- Name: fki_showcmdbtaskdgdgid; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_showcmdbtaskdgdgid ON showcommandbenchmarktaskdgdetail USING btree (devicegroupid);


--
-- TOC entry 3526 (class 1259 OID 621366)
-- Dependencies: 2496
-- Name: fki_showcmdbtasksiteid; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_showcmdbtasksiteid ON showcommandbenchmarktasksitedetail USING btree (siteid);


--
-- TOC entry 3421 (class 1259 OID 621367)
-- Dependencies: 2367
-- Name: fki_showcommandtemplate_fk; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_showcommandtemplate_fk ON showcommandtemplate USING btree (userid);


--
-- TOC entry 3181 (class 1259 OID 621368)
-- Dependencies: 2272
-- Name: fki_switchname; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_switchname ON ip2mac USING btree (switchname);


--
-- TOC entry 3435 (class 1259 OID 621369)
-- Dependencies: 2371
-- Name: fki_swtichgroupdevice_fk_deviceid; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_swtichgroupdevice_fk_deviceid ON swtichgroupdevice USING btree (deviceid);


--
-- TOC entry 3281 (class 1259 OID 621370)
-- Dependencies: 2305
-- Name: fki_symbol2deviceicon_fk; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_symbol2deviceicon_fk ON symbol2deviceicon USING btree (deviceicon_id);


--
-- TOC entry 3531 (class 1259 OID 621371)
-- Dependencies: 2506
-- Name: fki_symbol2deviceicon_selected_fk; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_symbol2deviceicon_selected_fk ON symbol2deviceicon_selected USING btree (default_deviceicon_id);


--
-- TOC entry 3552 (class 1259 OID 621372)
-- Dependencies: 2516
-- Name: fki_system_vendormodel2device_icon_deviceicon_id_fk; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_system_vendormodel2device_icon_deviceicon_id_fk ON system_vendormodel2device_icon USING btree (deviceicon_id);


--
-- TOC entry 3440 (class 1259 OID 621373)
-- Dependencies: 2374
-- Name: fki_systemdevicegroupdevice_fk_deviceid; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_systemdevicegroupdevice_fk_deviceid ON systemdevicegroupdevice USING btree (deviceid);


--
-- TOC entry 3251 (class 1259 OID 621374)
-- Dependencies: 2292
-- Name: fki_userdevicesetting_fk_deviceid; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_userdevicesetting_fk_deviceid ON userdevicesetting USING btree (deviceid);


--
-- TOC entry 3561 (class 1259 OID 621375)
-- Dependencies: 2523
-- Name: fki_wanlink_fk_inf2id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_wanlink_fk_inf2id ON wanlink USING btree (inf2id);


--
-- TOC entry 3562 (class 1259 OID 621376)
-- Dependencies: 2523
-- Name: fki_wanlink_fk_wanid; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_wanlink_fk_wanid ON wanlink USING btree (wanid);


--
-- TOC entry 3174 (class 1259 OID 621377)
-- Dependencies: 2268
-- Name: interfacesetting_idx_dev; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX interfacesetting_idx_dev ON interfacesetting USING btree (deviceid);


--
-- TOC entry 3175 (class 1259 OID 621378)
-- Dependencies: 2268 2268
-- Name: interfacesetting_idx_dev_inf; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX interfacesetting_idx_dev_inf ON interfacesetting USING btree (deviceid, interfacename);


--
-- TOC entry 3176 (class 1259 OID 621379)
-- Dependencies: 2268
-- Name: interfacesetting_idx_lower_mac; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX interfacesetting_idx_lower_mac ON interfacesetting USING btree (lower(macaddress));


--
-- TOC entry 3182 (class 1259 OID 621380)
-- Dependencies: 2272
-- Name: ip2mac_idx_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ip2mac_idx_id ON ip2mac USING btree (id);


--
-- TOC entry 3183 (class 1259 OID 621381)
-- Dependencies: 2272
-- Name: ip2mac_idx_lan; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ip2mac_idx_lan ON ip2mac USING btree (lan);


--
-- TOC entry 3184 (class 1259 OID 621382)
-- Dependencies: 2272
-- Name: ip2mac_idx_switchname; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ip2mac_idx_switchname ON ip2mac USING btree (switchname);


--
-- TOC entry 3185 (class 1259 OID 621383)
-- Dependencies: 2272 2272
-- Name: ip2mac_index_ipmac; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ip2mac_index_ipmac ON ip2mac USING btree (ip, mac);


--
-- TOC entry 3190 (class 1259 OID 621384)
-- Dependencies: 2273
-- Name: l2connectivity_idx_destdevice; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX l2connectivity_idx_destdevice ON l2connectivity USING btree (destdevice);


--
-- TOC entry 3191 (class 1259 OID 621385)
-- Dependencies: 2273
-- Name: l2connectivity_idx_destport; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX l2connectivity_idx_destport ON l2connectivity USING btree (destport);


--
-- TOC entry 3192 (class 1259 OID 621386)
-- Dependencies: 2273
-- Name: l2connectivity_idx_sourcedevice; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX l2connectivity_idx_sourcedevice ON l2connectivity USING btree (sourcedevice);


--
-- TOC entry 3193 (class 1259 OID 621387)
-- Dependencies: 2273
-- Name: l2connectivity_idx_sourceport; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX l2connectivity_idx_sourceport ON l2connectivity USING btree (sourceport);


--
-- TOC entry 3194 (class 1259 OID 621388)
-- Dependencies: 2273 2273 2273 2273
-- Name: l2connectivity_index_content; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX l2connectivity_index_content ON l2connectivity USING btree (sourcedevice, sourceport, destdevice, destport);


--
-- TOC entry 3197 (class 1259 OID 621389)
-- Dependencies: 2274
-- Name: l2switchinfo_idx_devicealias; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX l2switchinfo_idx_devicealias ON l2switchinfo USING btree (devicealias);


--
-- TOC entry 3332 (class 1259 OID 621390)
-- Dependencies: 2324
-- Name: l2switchport_idx_dev; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX l2switchport_idx_dev ON l2switchport USING btree (switchname);


--
-- TOC entry 3333 (class 1259 OID 621391)
-- Dependencies: 2324 2324
-- Name: l2switchport_idx_dev_portname; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX l2switchport_idx_dev_portname ON l2switchport USING btree (switchname, portname);


--
-- TOC entry 3338 (class 1259 OID 621392)
-- Dependencies: 2325
-- Name: l2switchport_temp_idx_dev; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX l2switchport_temp_idx_dev ON l2switchport_temp USING btree (switchname);


--
-- TOC entry 3339 (class 1259 OID 621393)
-- Dependencies: 2325 2325
-- Name: l2switchport_temp_idx_dev_portname; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX l2switchport_temp_idx_dev_portname ON l2switchport_temp USING btree (switchname, portname);


--
-- TOC entry 3344 (class 1259 OID 621394)
-- Dependencies: 2326
-- Name: l2switchvlan_idx_vlannumber; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX l2switchvlan_idx_vlannumber ON l2switchvlan USING btree (vlannumber);


--
-- TOC entry 3345 (class 1259 OID 621395)
-- Dependencies: 2326
-- Name: l2switchvlan_index_devicename; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX l2switchvlan_index_devicename ON l2switchvlan USING btree (switchname);


--
-- TOC entry 3200 (class 1259 OID 621396)
-- Dependencies: 2275
-- Name: lanswitch_idx_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX lanswitch_idx_id ON lanswitch USING btree (id);


--
-- TOC entry 3201 (class 1259 OID 621397)
-- Dependencies: 2275
-- Name: lanswitch_idx_lanname; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX lanswitch_idx_lanname ON lanswitch USING btree (lanname);


--
-- TOC entry 3202 (class 1259 OID 621398)
-- Dependencies: 2275
-- Name: lanswitch_idx_switchname; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX lanswitch_idx_switchname ON lanswitch USING btree (switchname);


--
-- TOC entry 3392 (class 1259 OID 621399)
-- Dependencies: 2350 2350 2350 2350 2350
-- Name: nat_index_na; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX nat_index_na ON nat USING btree (deviceid, insidelocal, insideglobal, outsidelocal, outsideglobal);


--
-- TOC entry 3397 (class 1259 OID 621400)
-- Dependencies: 2351 2351 2351
-- Name: natinterface_idx_deviceid; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX natinterface_idx_deviceid ON natinterface USING btree (deviceid, inintfid, outintfid);


--
-- TOC entry 3416 (class 1259 OID 621401)
-- Dependencies: 2365
-- Name: nomp_telnetinfo_index_userid; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX nomp_telnetinfo_index_userid ON nomp_telnetinfo USING btree (userid);


--
-- TOC entry 3430 (class 1259 OID 621402)
-- Dependencies: 2370
-- Name: switchgroup_index_name; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX switchgroup_index_name ON switchgroup USING btree (strname);


--
-- TOC entry 3271 (class 1259 OID 621403)
-- Dependencies: 2302
-- Name: systemdevicegroup_index_lower_name; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX systemdevicegroup_index_lower_name ON systemdevicegroup USING btree (lower((strname)::text));


--
-- TOC entry 3272 (class 1259 OID 621404)
-- Dependencies: 2302
-- Name: systemdevicegroup_index_name; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX systemdevicegroup_index_name ON systemdevicegroup USING btree (strname);


--
-- TOC entry 3252 (class 1259 OID 621405)
-- Dependencies: 2292
-- Name: userdevicesetting_index_userid; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX userdevicesetting_index_userid ON userdevicesetting USING btree (userid);


--
-- TOC entry 3563 (class 1259 OID 621406)
-- Dependencies: 2523 2523
-- Name: wanlink_index_infs; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX wanlink_index_infs ON wanlink USING btree (inf1id, inf2id);


--
-- TOC entry 3568 (class 1259 OID 621407)
-- Dependencies: 2525
-- Name: wans_index_name; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX wans_index_name ON wans USING btree (strname);


--
-- TOC entry 3694 (class 2620 OID 621408)
-- Dependencies: 116 2378
-- Name: adminpwd_p; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER adminpwd_p
    BEFORE INSERT OR UPDATE ON adminpwd
    FOR EACH ROW
    EXECUTE PROCEDURE process_adminpwd_p();


--
-- TOC entry 3652 (class 2620 OID 621409)
-- Dependencies: 117 2249
-- Name: device_customized_info_dt; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER device_customized_info_dt
    BEFORE INSERT OR DELETE OR UPDATE ON device_customized_info
    FOR EACH ROW
    EXECUTE PROCEDURE process_device_customized_info_dt();


--
-- TOC entry 3670 (class 2620 OID 621410)
-- Dependencies: 2304 118
-- Name: device_icon_dt; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER device_icon_dt
    BEFORE INSERT OR DELETE OR UPDATE ON device_icon
    FOR EACH ROW
    EXECUTE PROCEDURE process_device_icon_dt();


--
-- TOC entry 3653 (class 2620 OID 621411)
-- Dependencies: 119 2250
-- Name: device_property_dt; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER device_property_dt
    BEFORE INSERT OR DELETE OR UPDATE ON device_property
    FOR EACH ROW
    EXECUTE PROCEDURE process_device_property_dt();


--
-- TOC entry 3650 (class 2620 OID 621412)
-- Dependencies: 120 2246
-- Name: devicegroup_dt; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER devicegroup_dt
    BEFORE INSERT OR DELETE OR UPDATE ON devicegroup
    FOR EACH ROW
    EXECUTE PROCEDURE process_devicegroup_dt();


--
-- TOC entry 3651 (class 2620 OID 621413)
-- Dependencies: 2247 121
-- Name: devicegroupdevice_dt; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER devicegroupdevice_dt
    BEFORE INSERT OR DELETE OR UPDATE ON devicegroupdevice
    FOR EACH ROW
    EXECUTE PROCEDURE process_devicegroupdevice_dt();


--
-- TOC entry 3654 (class 2620 OID 621414)
-- Dependencies: 2253 122
-- Name: devicesetting_dt; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER devicesetting_dt
    BEFORE INSERT OR DELETE OR UPDATE ON devicesetting
    FOR EACH ROW
    EXECUTE PROCEDURE process_devicessetting_dt();


--
-- TOC entry 3656 (class 2620 OID 621415)
-- Dependencies: 2258 123
-- Name: discover_missdevice_dt; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER discover_missdevice_dt
    BEFORE INSERT OR DELETE OR UPDATE ON discover_missdevice
    FOR EACH ROW
    EXECUTE PROCEDURE process_discover_missdevice_dt();


--
-- TOC entry 3657 (class 2620 OID 621416)
-- Dependencies: 124 2260
-- Name: discover_newdevice_dt; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER discover_newdevice_dt
    BEFORE INSERT OR DELETE OR UPDATE ON discover_newdevice
    FOR EACH ROW
    EXECUTE PROCEDURE process_discover_newdevice_dt();


--
-- TOC entry 3658 (class 2620 OID 621417)
-- Dependencies: 2261 125
-- Name: discover_snmpdevice_dt; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER discover_snmpdevice_dt
    BEFORE INSERT OR DELETE OR UPDATE ON discover_snmpdevice
    FOR EACH ROW
    EXECUTE PROCEDURE process_discover_snmpdevice_dt();


--
-- TOC entry 3659 (class 2620 OID 621418)
-- Dependencies: 2262 126
-- Name: discover_unknowdevice_dt; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER discover_unknowdevice_dt
    BEFORE INSERT OR DELETE OR UPDATE ON discover_unknowdevice
    FOR EACH ROW
    EXECUTE PROCEDURE process_discover_unknowdevice_dt();


--
-- TOC entry 3672 (class 2620 OID 621419)
-- Dependencies: 128 2315
-- Name: duplicateip_dt; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER duplicateip_dt
    BEFORE INSERT OR DELETE OR UPDATE ON duplicateip
    FOR EACH ROW
    EXECUTE PROCEDURE process_duplicateip_dt();


--
-- TOC entry 3673 (class 2620 OID 621420)
-- Dependencies: 2317 130
-- Name: fixupnatinfo_dt; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER fixupnatinfo_dt
    BEFORE INSERT OR DELETE OR UPDATE ON fixupnatinfo
    FOR EACH ROW
    EXECUTE PROCEDURE process_fixupnatinfo_dt();


--
-- TOC entry 3674 (class 2620 OID 621421)
-- Dependencies: 2317 129
-- Name: fixupnatinfo_pri; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER fixupnatinfo_pri
    BEFORE INSERT OR UPDATE ON fixupnatinfo
    FOR EACH ROW
    EXECUTE PROCEDURE process_fixupnatinfo();


--
-- TOC entry 3675 (class 2620 OID 621422)
-- Dependencies: 2318 131
-- Name: fixuproutetable_dt; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER fixuproutetable_dt
    BEFORE INSERT OR DELETE OR UPDATE ON fixuproutetable
    FOR EACH ROW
    EXECUTE PROCEDURE process_fixuproutetable_dt();


--
-- TOC entry 3676 (class 2620 OID 621423)
-- Dependencies: 133 2319
-- Name: fixuproutetablepriority_dt; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER fixuproutetablepriority_dt
    BEFORE INSERT OR DELETE OR UPDATE ON fixuproutetablepriority
    FOR EACH ROW
    EXECUTE PROCEDURE process_fixuproutetablepriority_dt();


--
-- TOC entry 3677 (class 2620 OID 621424)
-- Dependencies: 134 2320
-- Name: fixupunnumberedinterface_dt; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER fixupunnumberedinterface_dt
    BEFORE INSERT OR DELETE OR UPDATE ON fixupunnumberedinterface
    FOR EACH ROW
    EXECUTE PROCEDURE process_fixupunnumberedinterface_dt();


--
-- TOC entry 3661 (class 2620 OID 621425)
-- Dependencies: 135 2267
-- Name: interface_customized_info_dt; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER interface_customized_info_dt
    BEFORE INSERT OR DELETE OR UPDATE ON interface_customized_info
    FOR EACH ROW
    EXECUTE PROCEDURE process_interface_customized_info_dt();


--
-- TOC entry 3678 (class 2620 OID 621426)
-- Dependencies: 2321 137
-- Name: internetboundaryinterface_dt; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER internetboundaryinterface_dt
    BEFORE INSERT OR DELETE OR UPDATE ON internetboundaryinterface
    FOR EACH ROW
    EXECUTE PROCEDURE process_internetboundaryinterface_dt();


--
-- TOC entry 3662 (class 2620 OID 621427)
-- Dependencies: 2272 139
-- Name: ip2mac_userflag; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER ip2mac_userflag
    BEFORE UPDATE ON ip2mac
    FOR EACH ROW
    EXECUTE PROCEDURE process_ip2mac_userflag();


--
-- TOC entry 3679 (class 2620 OID 621428)
-- Dependencies: 2323 140
-- Name: ipphone_dt; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER ipphone_dt
    BEFORE INSERT OR DELETE OR UPDATE ON ipphone
    FOR EACH ROW
    EXECUTE PROCEDURE process_ipphone_dt();


--
-- TOC entry 3663 (class 2620 OID 621429)
-- Dependencies: 147 2276
-- Name: linkgroup_dt; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER linkgroup_dt
    BEFORE INSERT OR DELETE OR UPDATE ON linkgroup
    FOR EACH ROW
    EXECUTE PROCEDURE process_linkgroup_dt();


--
-- TOC entry 3683 (class 2620 OID 621430)
-- Dependencies: 2343 148
-- Name: linkgroup_param_dt; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER linkgroup_param_dt
    BEFORE INSERT OR DELETE OR UPDATE ON linkgroup_param
    FOR EACH ROW
    EXECUTE PROCEDURE process_linkgroup_param_dt();


--
-- TOC entry 3680 (class 2620 OID 621431)
-- Dependencies: 2333 149
-- Name: linkgroup_paramvalue_dt; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER linkgroup_paramvalue_dt
    BEFORE INSERT OR DELETE OR UPDATE ON linkgroup_paramvalue
    FOR EACH ROW
    EXECUTE PROCEDURE process_linkgroup_paramvalue_dt();


--
-- TOC entry 3682 (class 2620 OID 621432)
-- Dependencies: 2338 150
-- Name: linkgroupdevice_dt; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER linkgroupdevice_dt
    BEFORE INSERT OR DELETE OR UPDATE ON linkgroupdevice
    FOR EACH ROW
    EXECUTE PROCEDURE process_linkgroupdevice_dt();


--
-- TOC entry 3681 (class 2620 OID 621433)
-- Dependencies: 151 2334
-- Name: linkgroupinterface_dt; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER linkgroupinterface_dt
    BEFORE INSERT OR DELETE OR UPDATE ON linkgroupinterface
    FOR EACH ROW
    EXECUTE PROCEDURE process_linkgroupinterface_dt();


--
-- TOC entry 3684 (class 2620 OID 621434)
-- Dependencies: 152 2348
-- Name: lwap_dt; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER lwap_dt
    BEFORE INSERT OR DELETE OR UPDATE ON lwap
    FOR EACH ROW
    EXECUTE PROCEDURE process_lwap_dt();


--
-- TOC entry 3664 (class 2620 OID 621435)
-- Dependencies: 2277 153
-- Name: module_customized_info_dt; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER module_customized_info_dt
    BEFORE INSERT OR DELETE OR UPDATE ON module_customized_info
    FOR EACH ROW
    EXECUTE PROCEDURE process_module_customized_info_dt();


--
-- TOC entry 3665 (class 2620 OID 621436)
-- Dependencies: 2278 154
-- Name: module_property_dt; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER module_property_dt
    BEFORE INSERT OR DELETE OR UPDATE ON module_property
    FOR EACH ROW
    EXECUTE PROCEDURE process_module_property_dt();


--
-- TOC entry 3655 (class 2620 OID 621437)
-- Dependencies: 156 2255
-- Name: nomp_appliance_dt; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER nomp_appliance_dt
    BEFORE INSERT OR DELETE OR UPDATE ON nomp_appliance
    FOR EACH ROW
    EXECUTE PROCEDURE process_nomp_appliance_dt();


--
-- TOC entry 3686 (class 2620 OID 621438)
-- Dependencies: 158 2356
-- Name: nomp_enablepasswd_dt; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER nomp_enablepasswd_dt
    BEFORE INSERT OR DELETE OR UPDATE ON nomp_enablepasswd
    FOR EACH ROW
    EXECUTE PROCEDURE process_nomp_enablepasswd_dt();


--
-- TOC entry 3687 (class 2620 OID 621439)
-- Dependencies: 2359 159
-- Name: nomp_jumpbox_dt; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER nomp_jumpbox_dt
    BEFORE INSERT OR DELETE OR UPDATE ON nomp_jumpbox
    FOR EACH ROW
    EXECUTE PROCEDURE process_nomp_jumpbox_dt();


--
-- TOC entry 3685 (class 2620 OID 621440)
-- Dependencies: 2353 155
-- Name: nomp_nd_dt; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER nomp_nd_dt
    BEFORE INSERT OR DELETE OR UPDATE ON nd
    FOR EACH ROW
    EXECUTE PROCEDURE process_nd_dt();


--
-- TOC entry 3688 (class 2620 OID 621441)
-- Dependencies: 160 2362
-- Name: nomp_snmproinfo_dt; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER nomp_snmproinfo_dt
    BEFORE INSERT OR DELETE OR UPDATE ON nomp_snmproinfo
    FOR EACH ROW
    EXECUTE PROCEDURE process_nomp_snmproinfo_dt();


--
-- TOC entry 3689 (class 2620 OID 621442)
-- Dependencies: 161 2365
-- Name: nomp_telnetinfo_dt; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER nomp_telnetinfo_dt
    BEFORE INSERT OR DELETE OR UPDATE ON nomp_telnetinfo
    FOR EACH ROW
    EXECUTE PROCEDURE process_nomp_telnetinfo_dt();


--
-- TOC entry 3696 (class 2620 OID 621443)
-- Dependencies: 2479 162
-- Name: object_customized_attribute_dt; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER object_customized_attribute_dt
    BEFORE INSERT OR DELETE OR UPDATE ON object_customized_attribute
    FOR EACH ROW
    EXECUTE PROCEDURE process_object_customized_attribute_dt();


--
-- TOC entry 3697 (class 2620 OID 621444)
-- Dependencies: 163 2482
-- Name: object_file_path_info_dt; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER object_file_path_info_dt
    BEFORE INSERT OR DELETE OR UPDATE ON object_file_path_info
    FOR EACH ROW
    EXECUTE PROCEDURE process_object_file_path_info_dt();


--
-- TOC entry 3690 (class 2620 OID 621445)
-- Dependencies: 164 2367
-- Name: showcommandtemplate_dt; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER showcommandtemplate_dt
    BEFORE INSERT OR DELETE OR UPDATE ON showcommandtemplate
    FOR EACH ROW
    EXECUTE PROCEDURE process_showcommandtemplate_dt();


--
-- TOC entry 3691 (class 2620 OID 621446)
-- Dependencies: 165 2368
-- Name: site2site_dt; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER site2site_dt
    BEFORE INSERT OR DELETE OR UPDATE ON site2site
    FOR EACH ROW
    EXECUTE PROCEDURE process_site2site_dt();


--
-- TOC entry 3667 (class 2620 OID 621447)
-- Dependencies: 166 2285
-- Name: site_customized_info_dt; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER site_customized_info_dt
    BEFORE INSERT OR DELETE OR UPDATE ON site_customized_info
    FOR EACH ROW
    EXECUTE PROCEDURE process_site_customized_info_dt();


--
-- TOC entry 3666 (class 2620 OID 621448)
-- Dependencies: 2284 167
-- Name: site_dt; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER site_dt
    BEFORE INSERT OR DELETE OR UPDATE ON site
    FOR EACH ROW
    EXECUTE PROCEDURE process_site_dt();


--
-- TOC entry 3695 (class 2620 OID 621449)
-- Dependencies: 2476 168
-- Name: snmprw_pri; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER snmprw_pri
    BEFORE INSERT OR UPDATE ON nomp_snmprwinfo
    FOR EACH ROW
    EXECUTE PROCEDURE process_snmprwstring();


--
-- TOC entry 3692 (class 2620 OID 621450)
-- Dependencies: 169 2370
-- Name: switchgroup_dt; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER switchgroup_dt
    BEFORE INSERT OR DELETE OR UPDATE ON switchgroup
    FOR EACH ROW
    EXECUTE PROCEDURE process_switchgroup_dt();


--
-- TOC entry 3693 (class 2620 OID 621451)
-- Dependencies: 2371 170
-- Name: swtichgroupdevice_dt; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER swtichgroupdevice_dt
    BEFORE INSERT OR DELETE OR UPDATE ON swtichgroupdevice
    FOR EACH ROW
    EXECUTE PROCEDURE process_swtichgroupdevice_dt();


--
-- TOC entry 3671 (class 2620 OID 621452)
-- Dependencies: 2305 171
-- Name: symbol2deviceicon_dt; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER symbol2deviceicon_dt
    BEFORE INSERT OR DELETE OR UPDATE ON symbol2deviceicon
    FOR EACH ROW
    EXECUTE PROCEDURE process_symbol2deviceicon_dt();


--
-- TOC entry 3698 (class 2620 OID 621453)
-- Dependencies: 2506 172
-- Name: symbol2deviceicon_selected_dt; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER symbol2deviceicon_selected_dt
    BEFORE INSERT OR DELETE OR UPDATE ON symbol2deviceicon_selected
    FOR EACH ROW
    EXECUTE PROCEDURE process_symbol2deviceicon_selected_dt();


--
-- TOC entry 3668 (class 2620 OID 621454)
-- Dependencies: 173 2288
-- Name: system_devicespec_dt; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER system_devicespec_dt
    BEFORE INSERT OR DELETE OR UPDATE ON system_devicespec
    FOR EACH ROW
    EXECUTE PROCEDURE process_system_devicespec_dt();


--
-- TOC entry 3699 (class 2620 OID 621455)
-- Dependencies: 174 2516
-- Name: system_vendormodel2device_icon_dt; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER system_vendormodel2device_icon_dt
    BEFORE INSERT OR DELETE OR UPDATE ON system_vendormodel2device_icon
    FOR EACH ROW
    EXECUTE PROCEDURE process_system_vendormodel2device_icon_dt();


--
-- TOC entry 3660 (class 2620 OID 621456)
-- Dependencies: 178 2264
-- Name: unknownip_dt; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER unknownip_dt
    BEFORE INSERT OR DELETE OR UPDATE ON unknownip
    FOR EACH ROW
    EXECUTE PROCEDURE process_unknownip_dt();


--
-- TOC entry 3669 (class 2620 OID 621457)
-- Dependencies: 2292 179
-- Name: userdevicesetting_dt; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER userdevicesetting_dt
    BEFORE INSERT OR DELETE OR UPDATE ON userdevicesetting
    FOR EACH ROW
    EXECUTE PROCEDURE process_userdevicesetting_dt();


--
-- TOC entry 3636 (class 2606 OID 621458)
-- Dependencies: 2386 3452 2384
-- Name: benchmarktaskstatusstep_fk_statusid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY benchmarktaskstatusstep
    ADD CONSTRAINT benchmarktaskstatusstep_fk_statusid FOREIGN KEY (statusid) REFERENCES benchmarktaskstatus(id) ON DELETE CASCADE;


--
-- TOC entry 3637 (class 2606 OID 621463)
-- Dependencies: 3454 2386 2388
-- Name: benchmarktaskstatussteplog_fk_stepid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY benchmarktaskstatussteplog
    ADD CONSTRAINT benchmarktaskstatussteplog_fk_stepid FOREIGN KEY (stepid) REFERENCES benchmarktaskstatusstep(id) ON DELETE CASCADE;


--
-- TOC entry 3588 (class 2606 OID 621468)
-- Dependencies: 2245 3107 2293
-- Name: bgpneighbor_deviceid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY bgpneighbor
    ADD CONSTRAINT bgpneighbor_deviceid FOREIGN KEY (deviceid) REFERENCES devices(id) ON DELETE CASCADE;


--
-- TOC entry 3638 (class 2606 OID 621473)
-- Dependencies: 2395 2245 3107
-- Name: device_config_fk_device; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY device_config
    ADD CONSTRAINT device_config_fk_device FOREIGN KEY (deviceid) REFERENCES devices(id) ON DELETE CASCADE;


--
-- TOC entry 3573 (class 2606 OID 621478)
-- Dependencies: 3507 2479 2249
-- Name: device_customized_info_attributeid_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY device_customized_info
    ADD CONSTRAINT device_customized_info_attributeid_fk FOREIGN KEY (attributeid) REFERENCES object_customized_attribute(id) ON DELETE CASCADE;


--
-- TOC entry 3574 (class 2606 OID 621483)
-- Dependencies: 2250 2249 3131
-- Name: device_customized_info_objectid_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY device_customized_info
    ADD CONSTRAINT device_customized_info_objectid_fk FOREIGN KEY (objectid) REFERENCES device_property(id) ON DELETE CASCADE;


--
-- TOC entry 3578 (class 2606 OID 621488)
-- Dependencies: 2258 2245 3107
-- Name: device_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY discover_missdevice
    ADD CONSTRAINT device_fk FOREIGN KEY (deviceid) REFERENCES devices(id) ON DELETE CASCADE;


--
-- TOC entry 3575 (class 2606 OID 621493)
-- Dependencies: 2245 3107 2250
-- Name: device_property_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY device_property
    ADD CONSTRAINT device_property_fk FOREIGN KEY (deviceid) REFERENCES devices(id) ON DELETE CASCADE;


--
-- TOC entry 3639 (class 2606 OID 621498)
-- Dependencies: 3471 2398 2400
-- Name: device_subtype_fk_maintype; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY device_subtype
    ADD CONSTRAINT device_subtype_fk_maintype FOREIGN KEY (maintype) REFERENCES device_maintype(maintype);


--
-- TOC entry 3571 (class 2606 OID 621503)
-- Dependencies: 2247 3118 2246
-- Name: devicegroupdevice_devicegroupid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY devicegroupdevice
    ADD CONSTRAINT devicegroupdevice_devicegroupid FOREIGN KEY (devicegroupid) REFERENCES devicegroup(id) ON DELETE CASCADE;


--
-- TOC entry 3572 (class 2606 OID 621508)
-- Dependencies: 2247 2245 3107
-- Name: devicegroupdevice_fk_device; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY devicegroupdevice
    ADD CONSTRAINT devicegroupdevice_fk_device FOREIGN KEY (deviceid) REFERENCES devices(id) ON DELETE CASCADE;


--
-- TOC entry 3589 (class 2606 OID 621513)
-- Dependencies: 3118 2246 2297
-- Name: devicegroupdevicegroup_fk_group; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY devicegroupdevicegroup
    ADD CONSTRAINT devicegroupdevicegroup_fk_group FOREIGN KEY (groupid) REFERENCES devicegroup(id) ON DELETE CASCADE;


--
-- TOC entry 3590 (class 2606 OID 621518)
-- Dependencies: 2246 3118 2297
-- Name: devicegroupdevicegroup_fk_groupbelone; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY devicegroupdevicegroup
    ADD CONSTRAINT devicegroupdevicegroup_fk_groupbelone FOREIGN KEY (groupidbelone) REFERENCES devicegroup(id) ON DELETE CASCADE;


--
-- TOC entry 3591 (class 2606 OID 621523)
-- Dependencies: 2246 2299 3118
-- Name: devicegroupsite_fk_group; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY devicegroupsite
    ADD CONSTRAINT devicegroupsite_fk_group FOREIGN KEY (groupid) REFERENCES devicegroup(id) ON DELETE CASCADE;


--
-- TOC entry 3592 (class 2606 OID 621528)
-- Dependencies: 2299 3231 2284
-- Name: devicegroupsite_fk_site; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY devicegroupsite
    ADD CONSTRAINT devicegroupsite_fk_site FOREIGN KEY (siteid) REFERENCES site(id) ON DELETE CASCADE;


--
-- TOC entry 3593 (class 2606 OID 621533)
-- Dependencies: 2246 2301 3118
-- Name: devicegroupsystemdevicegroup_fk_group; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY devicegroupsystemdevicegroup
    ADD CONSTRAINT devicegroupsystemdevicegroup_fk_group FOREIGN KEY (groupid) REFERENCES devicegroup(id) ON DELETE CASCADE;


--
-- TOC entry 3594 (class 2606 OID 621538)
-- Dependencies: 2301 2302 3273
-- Name: devicegroupsystemdevicegroup_fk_groupbelone; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY devicegroupsystemdevicegroup
    ADD CONSTRAINT devicegroupsystemdevicegroup_fk_groupbelone FOREIGN KEY (groupidbelone) REFERENCES systemdevicegroup(id) ON DELETE CASCADE;


--
-- TOC entry 3596 (class 2606 OID 621543)
-- Dependencies: 3107 2307 2245
-- Name: deviceprotocol_deviceid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY deviceprotocols
    ADD CONSTRAINT deviceprotocol_deviceid FOREIGN KEY (deviceid) REFERENCES devices(id) ON DELETE CASCADE;


--
-- TOC entry 3576 (class 2606 OID 621548)
-- Dependencies: 2255 2253 3140
-- Name: devicesetting_fk_applicid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY devicesetting
    ADD CONSTRAINT devicesetting_fk_applicid FOREIGN KEY (appliceid) REFERENCES nomp_appliance(id) ON DELETE SET DEFAULT;


--
-- TOC entry 3577 (class 2606 OID 621553)
-- Dependencies: 2245 2253 3107
-- Name: devicesetting_fk_device; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY devicesetting
    ADD CONSTRAINT devicesetting_fk_device FOREIGN KEY (deviceid) REFERENCES devices(id) ON DELETE CASCADE;


--
-- TOC entry 3597 (class 2606 OID 621558)
-- Dependencies: 2245 2309 3107
-- Name: devicesitedevice_fk_device; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY devicesitedevice
    ADD CONSTRAINT devicesitedevice_fk_device FOREIGN KEY (deviceid) REFERENCES devices(id) ON DELETE CASCADE;


--
-- TOC entry 3598 (class 2606 OID 621563)
-- Dependencies: 2309 2284 3231
-- Name: devicesitedevice_fk_siteid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY devicesitedevice
    ADD CONSTRAINT devicesitedevice_fk_siteid FOREIGN KEY (siteid) REFERENCES site(id) ON DELETE CASCADE;


--
-- TOC entry 3640 (class 2606 OID 621568)
-- Dependencies: 2245 3107 2410
-- Name: devicevpnname_deviceid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY devicevpns
    ADD CONSTRAINT devicevpnname_deviceid FOREIGN KEY (deviceid) REFERENCES devices(id) ON DELETE CASCADE;


--
-- TOC entry 3641 (class 2606 OID 621573)
-- Dependencies: 3177 2268 2412
-- Name: disableinterface_fk_infid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY disableinterface
    ADD CONSTRAINT disableinterface_fk_infid FOREIGN KEY (interfaceid) REFERENCES interfacesetting(id) ON DELETE CASCADE;


--
-- TOC entry 3599 (class 2606 OID 621578)
-- Dependencies: 2317 3107 2245
-- Name: fixupnatinfo_fk_deviceid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY fixupnatinfo
    ADD CONSTRAINT fixupnatinfo_fk_deviceid FOREIGN KEY (deviceid) REFERENCES devices(id) ON DELETE CASCADE;


--
-- TOC entry 3600 (class 2606 OID 621583)
-- Dependencies: 2317 2268 3177
-- Name: fixupnatinfo_fk_ininfid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY fixupnatinfo
    ADD CONSTRAINT fixupnatinfo_fk_ininfid FOREIGN KEY (ininfid) REFERENCES interfacesetting(id) ON DELETE CASCADE;


--
-- TOC entry 3601 (class 2606 OID 621588)
-- Dependencies: 2268 3177 2317
-- Name: fixupnatinfo_fk_outinfid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY fixupnatinfo
    ADD CONSTRAINT fixupnatinfo_fk_outinfid FOREIGN KEY (outinfid) REFERENCES interfacesetting(id) ON DELETE CASCADE;


--
-- TOC entry 3602 (class 2606 OID 621593)
-- Dependencies: 2318 2245 3107
-- Name: fixuproutetable_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY fixuproutetable
    ADD CONSTRAINT fixuproutetable_fk FOREIGN KEY (deviceid) REFERENCES devices(id) ON DELETE CASCADE;


--
-- TOC entry 3603 (class 2606 OID 621598)
-- Dependencies: 2319 2245 3107
-- Name: fixuproutetablepriority_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY fixuproutetablepriority
    ADD CONSTRAINT fixuproutetablepriority_fk FOREIGN KEY (deviceid) REFERENCES devices(id) ON DELETE CASCADE;


--
-- TOC entry 3579 (class 2606 OID 621603)
-- Dependencies: 2267 2479 3507
-- Name: interface_customized_info_attributeid_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY interface_customized_info
    ADD CONSTRAINT interface_customized_info_attributeid_fk FOREIGN KEY (attributeid) REFERENCES object_customized_attribute(id) ON DELETE CASCADE;


--
-- TOC entry 3580 (class 2606 OID 621608)
-- Dependencies: 2267 2268 3177
-- Name: interface_customized_info_objectid_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY interface_customized_info
    ADD CONSTRAINT interface_customized_info_objectid_fk FOREIGN KEY (objectid) REFERENCES interfacesetting(id) ON DELETE CASCADE;


--
-- TOC entry 3581 (class 2606 OID 621613)
-- Dependencies: 2268 2245 3107
-- Name: interfacesetting_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY interfacesetting
    ADD CONSTRAINT interfacesetting_fk FOREIGN KEY (deviceid) REFERENCES devices(id) ON DELETE CASCADE;


--
-- TOC entry 3604 (class 2606 OID 621618)
-- Dependencies: 2327 2276 3207
-- Name: linkgroup_dev_devicegroup_fk_group; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY linkgroup_dev_devicegroup
    ADD CONSTRAINT linkgroup_dev_devicegroup_fk_group FOREIGN KEY (groupid) REFERENCES linkgroup(id) ON DELETE CASCADE;


--
-- TOC entry 3605 (class 2606 OID 621623)
-- Dependencies: 2327 2246 3118
-- Name: linkgroup_dev_devicegroupbelone_fk_group; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY linkgroup_dev_devicegroup
    ADD CONSTRAINT linkgroup_dev_devicegroupbelone_fk_group FOREIGN KEY (groupidbelone) REFERENCES devicegroup(id) ON DELETE CASCADE;


--
-- TOC entry 3606 (class 2606 OID 621628)
-- Dependencies: 3207 2276 2329
-- Name: linkgroup_dev_site_fk_group; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY linkgroup_dev_site
    ADD CONSTRAINT linkgroup_dev_site_fk_group FOREIGN KEY (groupid) REFERENCES linkgroup(id) ON DELETE CASCADE;


--
-- TOC entry 3607 (class 2606 OID 621633)
-- Dependencies: 2329 2284 3231
-- Name: linkgroup_dev_site_fk_site; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY linkgroup_dev_site
    ADD CONSTRAINT linkgroup_dev_site_fk_site FOREIGN KEY (siteid) REFERENCES site(id) ON DELETE CASCADE;


--
-- TOC entry 3608 (class 2606 OID 621638)
-- Dependencies: 2331 2276 3207
-- Name: linkgroup_dev_systemdevicegroup_fk_group; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY linkgroup_dev_systemdevicegroup
    ADD CONSTRAINT linkgroup_dev_systemdevicegroup_fk_group FOREIGN KEY (groupid) REFERENCES linkgroup(id) ON DELETE CASCADE;


--
-- TOC entry 3609 (class 2606 OID 621643)
-- Dependencies: 2331 2302 3273
-- Name: linkgroup_dev_systemdevicegroupbelone_fk_group; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY linkgroup_dev_systemdevicegroup
    ADD CONSTRAINT linkgroup_dev_systemdevicegroupbelone_fk_group FOREIGN KEY (groupidbelone) REFERENCES systemdevicegroup(id) ON DELETE CASCADE;


--
-- TOC entry 3620 (class 2606 OID 621648)
-- Dependencies: 2343 2276 3207
-- Name: linkgroup_param_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY linkgroup_param
    ADD CONSTRAINT linkgroup_param_fk FOREIGN KEY (linkgroupid) REFERENCES linkgroup(id) ON DELETE CASCADE;


--
-- TOC entry 3610 (class 2606 OID 621653)
-- Dependencies: 2333 2343 3375
-- Name: linkgroup_paramvalue_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY linkgroup_paramvalue
    ADD CONSTRAINT linkgroup_paramvalue_fk FOREIGN KEY (paramid) REFERENCES linkgroup_param(id) ON DELETE CASCADE;


--
-- TOC entry 3616 (class 2606 OID 621658)
-- Dependencies: 2338 2245 3107
-- Name: linkgroupdevice_fk_device; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY linkgroupdevice
    ADD CONSTRAINT linkgroupdevice_fk_device FOREIGN KEY (deviceid) REFERENCES devices(id) ON DELETE CASCADE;


--
-- TOC entry 3617 (class 2606 OID 621663)
-- Dependencies: 2338 2276 3207
-- Name: linkgroupdevice_linkgroupid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY linkgroupdevice
    ADD CONSTRAINT linkgroupdevice_linkgroupid FOREIGN KEY (linkgroupid) REFERENCES linkgroup(id) ON DELETE CASCADE;


--
-- TOC entry 3614 (class 2606 OID 621668)
-- Dependencies: 2336 2276 3207
-- Name: linkgroupdevicegroup_fk_group; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY linkgroupdevicegroup
    ADD CONSTRAINT linkgroupdevicegroup_fk_group FOREIGN KEY (groupid) REFERENCES linkgroup(id) ON DELETE CASCADE;


--
-- TOC entry 3615 (class 2606 OID 621673)
-- Dependencies: 2336 2246 3118
-- Name: linkgroupdevicegroupbelone_fk_group; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY linkgroupdevicegroup
    ADD CONSTRAINT linkgroupdevicegroupbelone_fk_group FOREIGN KEY (groupidbelone) REFERENCES devicegroup(id) ON DELETE CASCADE;


--
-- TOC entry 3611 (class 2606 OID 621678)
-- Dependencies: 2334 2245 3107
-- Name: linkgroupinterface_fk_devices; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY linkgroupinterface
    ADD CONSTRAINT linkgroupinterface_fk_devices FOREIGN KEY (deviceid) REFERENCES devices(id) ON DELETE CASCADE;


--
-- TOC entry 3612 (class 2606 OID 621683)
-- Dependencies: 2334 2268 3177
-- Name: linkgroupinterface_fk_interfaceid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY linkgroupinterface
    ADD CONSTRAINT linkgroupinterface_fk_interfaceid FOREIGN KEY (interfaceid) REFERENCES interfacesetting(id) ON DELETE CASCADE;


--
-- TOC entry 3613 (class 2606 OID 621688)
-- Dependencies: 2334 2276 3207
-- Name: linkgroupinterface_fk_linkgroup; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY linkgroupinterface
    ADD CONSTRAINT linkgroupinterface_fk_linkgroup FOREIGN KEY (groupid) REFERENCES linkgroup(id) ON DELETE CASCADE;


--
-- TOC entry 3618 (class 2606 OID 621693)
-- Dependencies: 2341 2276 3207
-- Name: linkgrouplinkgroup_fk_group; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY linkgrouplinkgroup
    ADD CONSTRAINT linkgrouplinkgroup_fk_group FOREIGN KEY (groupid) REFERENCES linkgroup(id) ON DELETE CASCADE;


--
-- TOC entry 3619 (class 2606 OID 621698)
-- Dependencies: 2341 2276 3207
-- Name: linkgrouplinkgroupbelone_fk_group; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY linkgrouplinkgroup
    ADD CONSTRAINT linkgrouplinkgroupbelone_fk_group FOREIGN KEY (groupidbelone) REFERENCES linkgroup(id) ON DELETE CASCADE;


--
-- TOC entry 3621 (class 2606 OID 621703)
-- Dependencies: 3207 2276 2344
-- Name: linkgroupsite_fk_group; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY linkgroupsite
    ADD CONSTRAINT linkgroupsite_fk_group FOREIGN KEY (groupid) REFERENCES linkgroup(id) ON DELETE CASCADE;


--
-- TOC entry 3622 (class 2606 OID 621708)
-- Dependencies: 2344 2284 3231
-- Name: linkgroupsite_fk_site; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY linkgroupsite
    ADD CONSTRAINT linkgroupsite_fk_site FOREIGN KEY (siteid) REFERENCES site(id) ON DELETE CASCADE;


--
-- TOC entry 3623 (class 2606 OID 621713)
-- Dependencies: 3207 2346 2276
-- Name: linkgroupsystemdevicegroup_fk_group; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY linkgroupsystemdevicegroup
    ADD CONSTRAINT linkgroupsystemdevicegroup_fk_group FOREIGN KEY (groupid) REFERENCES linkgroup(id) ON DELETE CASCADE;


--
-- TOC entry 3624 (class 2606 OID 621718)
-- Dependencies: 3273 2302 2346
-- Name: linkgroupsystemdevicegroupbelone_fk_group; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY linkgroupsystemdevicegroup
    ADD CONSTRAINT linkgroupsystemdevicegroupbelone_fk_group FOREIGN KEY (groupidbelone) REFERENCES systemdevicegroup(id) ON DELETE CASCADE;


--
-- TOC entry 3582 (class 2606 OID 621723)
-- Dependencies: 2277 2479 3507
-- Name: module_customized_info_attributeid_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY module_customized_info
    ADD CONSTRAINT module_customized_info_attributeid_fk FOREIGN KEY (attributeid) REFERENCES object_customized_attribute(id) ON DELETE CASCADE;


--
-- TOC entry 3583 (class 2606 OID 621728)
-- Dependencies: 2278 2277 3216
-- Name: module_customized_info_objectid_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY module_customized_info
    ADD CONSTRAINT module_customized_info_objectid_fk FOREIGN KEY (objectid) REFERENCES module_property(id) ON DELETE CASCADE;


--
-- TOC entry 3584 (class 2606 OID 621733)
-- Dependencies: 2278 2245 3107
-- Name: module_property_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY module_property
    ADD CONSTRAINT module_property_fk FOREIGN KEY (deviceid) REFERENCES devices(id) ON DELETE CASCADE;


--
-- TOC entry 3627 (class 2606 OID 621738)
-- Dependencies: 2350 2245 3107
-- Name: nat_pk_deviceid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY nat
    ADD CONSTRAINT nat_pk_deviceid FOREIGN KEY (deviceid) REFERENCES devices(id) ON DELETE CASCADE;


--
-- TOC entry 3628 (class 2606 OID 621743)
-- Dependencies: 2245 2351 3107
-- Name: natinterface_fk_deviceid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY natinterface
    ADD CONSTRAINT natinterface_fk_deviceid FOREIGN KEY (deviceid) REFERENCES devices(id) ON DELETE CASCADE;


--
-- TOC entry 3629 (class 2606 OID 621748)
-- Dependencies: 2351 2268 3177
-- Name: natinterface_fk_ininf; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY natinterface
    ADD CONSTRAINT natinterface_fk_ininf FOREIGN KEY (inintfid) REFERENCES interfacesetting(id) ON DELETE CASCADE;


--
-- TOC entry 3630 (class 2606 OID 621753)
-- Dependencies: 2351 2268 3177
-- Name: natinterface_fk_outinfid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY natinterface
    ADD CONSTRAINT natinterface_fk_outinfid FOREIGN KEY (outintfid) REFERENCES interfacesetting(id) ON DELETE CASCADE;


--
-- TOC entry 3625 (class 2606 OID 621758)
-- Dependencies: 2349 2350 3393
-- Name: nattointf_fk_natid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY nattointf
    ADD CONSTRAINT nattointf_fk_natid FOREIGN KEY (natid) REFERENCES nat(id) ON DELETE CASCADE;


--
-- TOC entry 3626 (class 2606 OID 621763)
-- Dependencies: 2349 2351 3398
-- Name: nattointf_fk_natinfid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY nattointf
    ADD CONSTRAINT nattointf_fk_natinfid FOREIGN KEY (natintfid) REFERENCES natinterface(id) ON DELETE CASCADE;


--
-- TOC entry 3642 (class 2606 OID 621768)
-- Dependencies: 2494 2246 3118
-- Name: showcmdbtaskdgdgid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY showcommandbenchmarktaskdgdetail
    ADD CONSTRAINT showcmdbtaskdgdgid FOREIGN KEY (devicegroupid) REFERENCES devicegroup(id) ON DELETE CASCADE;


--
-- TOC entry 3643 (class 2606 OID 621773)
-- Dependencies: 2496 2284 3231
-- Name: showcmdbtasksiteid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY showcommandbenchmarktasksitedetail
    ADD CONSTRAINT showcmdbtasksiteid FOREIGN KEY (siteid) REFERENCES site(id) ON DELETE CASCADE;


--
-- TOC entry 3631 (class 2606 OID 621778)
-- Dependencies: 2284 2368 3231
-- Name: site2site_fk_site; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY site2site
    ADD CONSTRAINT site2site_fk_site FOREIGN KEY (siteid) REFERENCES site(id) ON DELETE CASCADE;


--
-- TOC entry 3585 (class 2606 OID 621783)
-- Dependencies: 2285 2479 3507
-- Name: sitecustomizedinfo_fk_att; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY site_customized_info
    ADD CONSTRAINT sitecustomizedinfo_fk_att FOREIGN KEY (attributeid) REFERENCES object_customized_attribute(id) ON DELETE CASCADE;


--
-- TOC entry 3586 (class 2606 OID 621788)
-- Dependencies: 2285 2284 3231
-- Name: sitecustomizedinfo_fk_siteid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY site_customized_info
    ADD CONSTRAINT sitecustomizedinfo_fk_siteid FOREIGN KEY (objectid) REFERENCES site(id) ON DELETE CASCADE;


--
-- TOC entry 3632 (class 2606 OID 621793)
-- Dependencies: 2371 2245 3107
-- Name: swtichgroupdevice_fk_device; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY swtichgroupdevice
    ADD CONSTRAINT swtichgroupdevice_fk_device FOREIGN KEY (deviceid) REFERENCES devices(id) ON DELETE CASCADE;


--
-- TOC entry 3633 (class 2606 OID 621798)
-- Dependencies: 2371 2370 3431
-- Name: swtichgroupdevice_fk_switchgroupid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY swtichgroupdevice
    ADD CONSTRAINT swtichgroupdevice_fk_switchgroupid FOREIGN KEY (switchgroupid) REFERENCES switchgroup(id) ON DELETE CASCADE;


--
-- TOC entry 3595 (class 2606 OID 621803)
-- Dependencies: 2305 2304 3279
-- Name: symbol2deviceicon_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY symbol2deviceicon
    ADD CONSTRAINT symbol2deviceicon_fk FOREIGN KEY (deviceicon_id) REFERENCES device_icon(id) ON DELETE CASCADE;


--
-- TOC entry 3644 (class 2606 OID 621808)
-- Dependencies: 2506 2304 3279
-- Name: symbol2deviceicon_selected_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY symbol2deviceicon_selected
    ADD CONSTRAINT symbol2deviceicon_selected_fk FOREIGN KEY (default_deviceicon_id) REFERENCES device_icon(id) ON DELETE CASCADE;


--
-- TOC entry 3645 (class 2606 OID 621813)
-- Dependencies: 2516 2304 3279
-- Name: system_vendormodel2device_icon_deviceicon_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY system_vendormodel2device_icon
    ADD CONSTRAINT system_vendormodel2device_icon_deviceicon_id_fk FOREIGN KEY (deviceicon_id) REFERENCES device_icon(id) ON DELETE CASCADE;


--
-- TOC entry 3646 (class 2606 OID 621818)
-- Dependencies: 2516 2290 3243
-- Name: system_vendormodel2device_icon_vendormodel_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY system_vendormodel2device_icon
    ADD CONSTRAINT system_vendormodel2device_icon_vendormodel_id_fk FOREIGN KEY (vendormodel_id) REFERENCES system_vendormodel(id) ON DELETE CASCADE;


--
-- TOC entry 3634 (class 2606 OID 621823)
-- Dependencies: 2374 2245 3107
-- Name: systemdevicegroupdevice_fk_device; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY systemdevicegroupdevice
    ADD CONSTRAINT systemdevicegroupdevice_fk_device FOREIGN KEY (deviceid) REFERENCES devices(id) ON DELETE CASCADE;


--
-- TOC entry 3635 (class 2606 OID 621828)
-- Dependencies: 2374 2302 3273
-- Name: systemdevicegroupdevice_systemdevicegroupid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY systemdevicegroupdevice
    ADD CONSTRAINT systemdevicegroupdevice_systemdevicegroupid FOREIGN KEY (systemdevicegroupid) REFERENCES systemdevicegroup(id) ON DELETE CASCADE;


--
-- TOC entry 3587 (class 2606 OID 621833)
-- Dependencies: 2292 2245 3107
-- Name: userdevicesetting_fk_device; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY userdevicesetting
    ADD CONSTRAINT userdevicesetting_fk_device FOREIGN KEY (deviceid) REFERENCES devices(id) ON DELETE CASCADE;


--
-- TOC entry 3647 (class 2606 OID 621838)
-- Dependencies: 2523 2268 3177
-- Name: wanlink_fk_inf1id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY wanlink
    ADD CONSTRAINT wanlink_fk_inf1id FOREIGN KEY (inf1id) REFERENCES interfacesetting(id) ON DELETE CASCADE;


--
-- TOC entry 3648 (class 2606 OID 621843)
-- Dependencies: 2523 2268 3177
-- Name: wanlink_fk_inf2id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY wanlink
    ADD CONSTRAINT wanlink_fk_inf2id FOREIGN KEY (inf2id) REFERENCES interfacesetting(id) ON DELETE CASCADE;


--
-- TOC entry 3649 (class 2606 OID 621848)
-- Dependencies: 2525 3569 2523
-- Name: wanlink_fk_wanid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY wanlink
    ADD CONSTRAINT wanlink_fk_wanid FOREIGN KEY (wanid) REFERENCES wans(id) ON DELETE CASCADE;


--
-- TOC entry 3813 (class 0 OID 0)
-- Dependencies: 6
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2012-09-23 17:10:11

--
-- PostgreSQL database dump complete
--

