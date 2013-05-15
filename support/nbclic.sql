SET client_encoding = 'SQL_ASCII';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

--
-- TOC entry 2622 (class 1262 OID 88282)
-- Name: nbws; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE nbclic WITH TEMPLATE = template0 ENCODING = 'SQL_ASCII';


ALTER DATABASE nbclic OWNER TO postgres;

\connect nbclic


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
-- TOC entry 19 (class 1255 OID 630079)
-- Dependencies: 349 6
-- Name: checkuser(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION checkuser(username character varying, pwd character varying) RETURNS integer
    LANGUAGE plpgsql
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
$$;


ALTER FUNCTION public.checkuser(username character varying, pwd character varying) OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 1536 (class 1259 OID 630080)
-- Dependencies: 1837 1838 6
-- Name: role; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE role (
    id integer NOT NULL,
    name character varying(256) NOT NULL,
    isdisplay boolean DEFAULT true,
    description text,
    authentication_type integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.role OWNER TO postgres;

--
-- TOC entry 20 (class 1255 OID 630088)
-- Dependencies: 349 6 311
-- Name: importrole(role); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE OR REPLACE FUNCTION importrole(r role)
  RETURNS integer AS
$BODY$
declare	
	ds_id integer;
	r_authtype integer;
BEGIN		
	select id into ds_id from role where name=r.name;
	if ds_id IS NULL THEN
		insert into role(
			  name,
			  isdisplay,
			  description,
			  authentication_type
			  )
			  values( 			  
			  r.name,
			  r.isdisplay,
			  r.description,
			  r.authentication_type
			  );
			  return lastval();
	else
		select authentication_type into r_authtype from role where id=ds_id;
		
		update role set(
			  description,
			  authentication_type
			  ) = ( 
			  r.description,
			  r.authentication_type
			  ) 
			  where id = ds_id ;
				
		if r_authtype = 0 then			
			delete from role2virtualfunction where roleid=ds_id;		
		end if;	
			  
		return ds_id;
	end if;
EXCEPTION
	WHEN OTHERS THEN 
		RETURN -2;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION importrole(role) OWNER TO postgres;

--
-- TOC entry 1537 (class 1259 OID 630091)
-- Dependencies: 1840 1841 1842 1843 1844 6
-- Name: user; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE "user" (
    id integer NOT NULL,
    strname character varying(256) NOT NULL,
    password character varying(256) NOT NULL,
    description text,
    email character varying(128),
    telephone character varying(64),
    can_use_global_telnet boolean DEFAULT false NOT NULL,
    offline_minutes integer DEFAULT 120,
    expired_days integer,
    authentication_type integer DEFAULT 0 NOT NULL,
    create_time timestamp without time zone DEFAULT now() NOT NULL,
    wsver integer DEFAULT 0 NOT NULL,
    validtime time with time zone,
    validdate timestamp without time zone,
    firstlogtime timestamp without time zone,
    localnode integer
);


ALTER TABLE public."user" OWNER TO postgres;

--
-- TOC entry 1538 (class 1259 OID 630102)
-- Dependencies: 1644 6
-- Name: userview; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW userview AS
    SELECT "user".id, "user".strname, "user".password, "user".description, "user".email, "user".telephone, "user".wsver, "user".can_use_global_telnet, "user".validtime, "user".validdate, "user".expired_days, "user".offline_minutes, "user".firstlogtime, "user".authentication_type FROM "user" ORDER BY "user".id;


ALTER TABLE public.userview OWNER TO postgres;

--
-- TOC entry 27 (class 1255 OID 630263)
-- Dependencies: 317 6 349
-- Name: importuser(userview, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE OR REPLACE FUNCTION importuser(r userview, wssguid character varying, rolename character varying)
  RETURNS integer AS
$BODY$
declare	
	ds_id integer;
	t_id integer;
	r_authtype integer;
BEGIN	
	select id into ds_id from "user" where lower(strname)=lower(r.strname);
	if ds_id IS NULL THEN
		insert into "user"(
			  strname,
			  "password",			  
			  can_use_global_telnet,			  		 
			  authentication_type,
			  description,
			  email,
			  telephone			  		 
			  )
			  values( 			  
			  r.strname,
			  r.password,			  
			  r.can_use_global_telnet,			  		 
			  r.authentication_type,
			  r.description,
			  r.email,
			  r.telephone
			  );
		select lastval() into ds_id;	  
		insert into user2role (userid,roleid) values (ds_id,(select id from role where lower(name)=lower(rolename)));	  
		insert into user2workspace (userid,workspaceguid) values (ds_id,wssguid);	  
		return ds_id;
			  
	else
		select authentication_type into r_authtype from "user" where id = ds_id ;		
		
		update "user" set(
			  "password",
			  description,
			  email,
			  telephone,				  
			  authentication_type			  			  	
			  ) = ( 
			  r.password,
			  r.description,
			  r.email,
			  r.telephone,			  			 
			  r.authentication_type
			  ) 
			  where id = ds_id ;

		if r_authtype = 0 then			
			delete from user2role where userid=ds_id;		
			delete from user2workspace where userid=ds_id;

			select id into t_id from user2workspace where userid=ds_id and workspaceguid=wssguid;	
			if t_id IS NULL then
				insert into user2workspace (userid,workspaceguid) values (ds_id,wssguid);	  
			end if;                				
		end if;		  

		select id into t_id from user2role where userid=ds_id and roleid=(select id from role where lower(name)=lower(rolename));	
		if t_id IS NULL then
			insert into user2role (userid,roleid) values (ds_id,(select id from role where lower(name)=lower(rolename)));	  
		end if;
			  
		return ds_id;
	end if;
EXCEPTION
	WHEN OTHERS THEN 
		RETURN -2;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION importuser(userview, character varying, character varying) OWNER TO postgres;

--
-- TOC entry 21 (class 1255 OID 630090)
-- Dependencies: 6 349
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
		NEW.create_time=now();		
		RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
		IF OLD.strname = 'system' or OLD.strname='admin' THEN
			RAISE EXCEPTION 'Can not delete the system default user';
		END IF;
		RETURN OLD;		
        END IF;
        RETURN NULL;
    END;
$$;


ALTER FUNCTION public.process_userinfo_p() OWNER TO postgres;

--
-- TOC entry 22 (class 1255 OID 630106)
-- Dependencies: 317 6 349
-- Name: searchuser(character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION searchuser(keyval character varying, optionval integer) RETURNS SETOF userview
    LANGUAGE plpgsql
    AS $$
declare
	r userview%rowtype;
BEGIN
	IF optionval =0 THEN
	    FOR r IN select * from userview where (strname ~* keyval or email ~* keyval) and strname not in ('default','system')  LOOP
		RETURN NEXT r;
	     END LOOP;		
	ELSIF optionval=1 then
	    FOR r IN select * from userview where (strname ~* keyval or email ~* keyval) and (validdate is null or validdate > now()) and strname not in ('default','system') LOOP
		RETURN NEXT r;
	     END LOOP;
	ELSIF optionval=2 then
	    FOR r IN select * from userview where (strname ~* keyval or email ~* keyval) and validdate is not null and validdate <now() and strname not in ('default','system') LOOP
		RETURN NEXT r;
	     END LOOP;	
	ELSIF optionval=3 then
	    FOR r IN select * from userview where (strname ~* keyval or email ~* keyval) and authentication_type=0 and strname not in ('default','system') LOOP
		RETURN NEXT r;
	     END LOOP;       		
	ELSIF optionval=4 then
	    FOR r IN select * from userview where (strname ~* keyval or email ~* keyval) and authentication_type=2 and strname not in ('default','system') LOOP
		RETURN NEXT r;
	     END LOOP;       		
	ELSE
	    FOR r IN select * from userview where (strname ~* keyval or email ~* keyval) and authentication_type=1 and strname not in ('default','system') LOOP
		RETURN NEXT r;
	     END LOOP;		
	end if;
END;

  $$;


ALTER FUNCTION public.searchuser(keyval character varying, optionval integer) OWNER TO postgres;

--
-- TOC entry 23 (class 1255 OID 630107)
-- Dependencies: 349 6
-- Name: setworkspaceadmin(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION setworkspaceadmin(wssguid character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
declare	
	ds_id integer;
BEGIN		
	select id into ds_id from user2workspace where workspaceguid=wssguid and userid = (select id from "user" where strname='admin');
	if ds_id IS NULL THEN	
		insert into user2workspace (userid,workspaceguid) values ((select id from "user" where strname='admin'),wssguid);
		RETURN true;					
	else
		RETURN true;
	end if;
EXCEPTION
	WHEN OTHERS THEN 
		RETURN false;	
END;

  $$;


ALTER FUNCTION public.setworkspaceadmin(wssguid character varying) OWNER TO postgres;

--
-- TOC entry 24 (class 1255 OID 630108)
-- Dependencies: 6 349
-- Name: updaterole2function(integer, integer[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION updaterole2function(rid integer, functionids integer[]) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
declare	
	ds_id integer;
BEGIN		
	for r in  1..array_length(functionids,1) loop
		select id into ds_id from role2virtualfunction where roleid=rid and virtualfunctionid = functionids[r];
		if ds_id IS NULL THEN
			insert into role2virtualfunction (roleid,virtualfunctionid) values (rid,functionids[r]);
		end if;	       
	end loop;	
	return true;	
EXCEPTION
	WHEN OTHERS THEN 
		RETURN false;	
END;

  $$;


ALTER FUNCTION public.updaterole2function(rid integer, functionids integer[]) OWNER TO postgres;

--
-- TOC entry 25 (class 1255 OID 630109)
-- Dependencies: 6 349
-- Name: updateuser2role(integer, integer[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION updateuser2role(uid integer, roleids integer[]) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
declare	
	ds_id integer;
BEGIN		
	for r in  1..array_length(roleids,1) loop
		select id into ds_id from user2role where userid=uid and roleid = roleids[r];
		if ds_id IS NULL THEN
			insert into user2role (userid,roleid) values (uid,roleids[r]);
		end if;	       
	end loop;	
	return true;	
EXCEPTION
	WHEN OTHERS THEN 
		RETURN false;	
END;

  $$;


ALTER FUNCTION public.updateuser2role(uid integer, roleids integer[]) OWNER TO postgres;

--
-- TOC entry 26 (class 1255 OID 630110)
-- Dependencies: 6 349
-- Name: updateuser2workspace(integer, character varying[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION updateuser2workspace(uid integer, guids character varying[]) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
declare	
	ds_id integer;
BEGIN		
	for r in  1..array_length(guids,1) loop
		select id into ds_id from user2workspace where userid=uid and workspaceguid = guids[r];
		if ds_id IS NULL THEN
			insert into user2workspace (userid,workspaceguid) values (uid,guids[r]);
		end if;	       
	end loop;	
	return true;	
EXCEPTION
	WHEN OTHERS THEN 
		RETURN false;	
END;

  $$;


ALTER FUNCTION public.updateuser2workspace(uid integer, guids character varying[]) OWNER TO postgres;

--
-- TOC entry 1539 (class 1259 OID 630111)
-- Dependencies: 1846 1847 1848 6
-- Name: function; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE function (
    id integer NOT NULL,
    strname text NOT NULL,
    wsver integer DEFAULT (-1) NOT NULL,
    description text,
    sidname text NOT NULL,
    isdisplay boolean DEFAULT true,
    kval text NOT NULL,
    is_apply_all boolean DEFAULT false NOT NULL
);


ALTER TABLE public.function OWNER TO postgres;

--
-- TOC entry 1540 (class 1259 OID 630120)
-- Dependencies: 1539 6
-- Name: function_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE function_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.function_id_seq OWNER TO postgres;

--
-- TOC entry 1924 (class 0 OID 0)
-- Dependencies: 1540
-- Name: function_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE function_id_seq OWNED BY function.id;


--
-- TOC entry 1925 (class 0 OID 0)
-- Dependencies: 1540
-- Name: function_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('function_id_seq', 29, true);


--
-- TOC entry 1541 (class 1259 OID 630122)
-- Dependencies: 6
-- Name: role2virtualfunction; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE role2virtualfunction (
    id integer NOT NULL,
    roleid integer NOT NULL,
    virtualfunctionid integer NOT NULL
);


ALTER TABLE public.role2virtualfunction OWNER TO postgres;

--
-- TOC entry 1542 (class 1259 OID 630125)
-- Dependencies: 6
-- Name: virtualfunction2function; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE virtualfunction2function (
    id integer NOT NULL,
    virtualfunctionid integer NOT NULL,
    functionid integer NOT NULL
);


ALTER TABLE public.virtualfunction2function OWNER TO postgres;

--
-- TOC entry 1543 (class 1259 OID 630128)
-- Dependencies: 1645 6
-- Name: role2function; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW role2function AS
    SELECT role2virtualfunction.id, role2virtualfunction.roleid, function.id AS functionid FROM role2virtualfunction, virtualfunction2function, function WHERE ((role2virtualfunction.virtualfunctionid = virtualfunction2function.virtualfunctionid) AND (virtualfunction2function.functionid = function.id)) ORDER BY role2virtualfunction.roleid, role2virtualfunction.virtualfunctionid, function.id;


ALTER TABLE public.role2function OWNER TO postgres;

--
-- TOC entry 1544 (class 1259 OID 630132)
-- Dependencies: 1541 6
-- Name: role2virtualfunction_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE role2virtualfunction_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.role2virtualfunction_id_seq OWNER TO postgres;

--
-- TOC entry 1926 (class 0 OID 0)
-- Dependencies: 1544
-- Name: role2virtualfunction_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE role2virtualfunction_id_seq OWNED BY role2virtualfunction.id;


--
-- TOC entry 1927 (class 0 OID 0)
-- Dependencies: 1544
-- Name: role2virtualfunction_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('role2virtualfunction_id_seq', 27, true);


--
-- TOC entry 1545 (class 1259 OID 630134)
-- Dependencies: 1536 6
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
-- TOC entry 1928 (class 0 OID 0)
-- Dependencies: 1545
-- Name: role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE role_id_seq OWNED BY role.id;


--
-- TOC entry 1929 (class 0 OID 0)
-- Dependencies: 1545
-- Name: role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('role_id_seq', 5, true);


--
-- TOC entry 1546 (class 1259 OID 630136)
-- Dependencies: 1852 6
-- Name: serverauthenticationtype; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE serverauthenticationtype (
    id integer NOT NULL,
    authentication_type integer DEFAULT 0 NOT NULL,
    address character varying(64),
    connectype integer,
    connectname character varying(64),
    connectpwd character varying(64),
    port integer NOT NULL
);


ALTER TABLE public.serverauthenticationtype OWNER TO postgres;

--
-- TOC entry 1547 (class 1259 OID 630140)
-- Dependencies: 1546 6
-- Name: serverauthenticationtype_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE serverauthenticationtype_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.serverauthenticationtype_id_seq OWNER TO postgres;

--
-- TOC entry 1930 (class 0 OID 0)
-- Dependencies: 1547
-- Name: serverauthenticationtype_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE serverauthenticationtype_id_seq OWNED BY serverauthenticationtype.id;


--
-- TOC entry 1931 (class 0 OID 0)
-- Dependencies: 1547
-- Name: serverauthenticationtype_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('serverauthenticationtype_id_seq', 1, true);


--
-- TOC entry 1548 (class 1259 OID 630142)
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
-- TOC entry 1549 (class 1259 OID 630145)
-- Dependencies: 1548 6
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
-- TOC entry 1932 (class 0 OID 0)
-- Dependencies: 1549
-- Name: sys_option_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE sys_option_id_seq OWNED BY sys_option.id;


--
-- TOC entry 1933 (class 0 OID 0)
-- Dependencies: 1549
-- Name: sys_option_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sys_option_id_seq', 4, true);


--
-- TOC entry 1550 (class 1259 OID 630147)
-- Dependencies: 6
-- Name: user2role; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE user2role (
    userid integer NOT NULL,
    roleid integer NOT NULL,
    id integer NOT NULL
);


ALTER TABLE public.user2role OWNER TO postgres;

--
-- TOC entry 1551 (class 1259 OID 630150)
-- Dependencies: 1550 6
-- Name: user2role_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE user2role_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.user2role_id_seq OWNER TO postgres;

--
-- TOC entry 1934 (class 0 OID 0)
-- Dependencies: 1551
-- Name: user2role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE user2role_id_seq OWNED BY user2role.id;


--
-- TOC entry 1935 (class 0 OID 0)
-- Dependencies: 1551
-- Name: user2role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('user2role_id_seq', 3, true);


--
-- TOC entry 1552 (class 1259 OID 630152)
-- Dependencies: 6
-- Name: user2workspace; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE user2workspace (
    id integer NOT NULL,
    userid integer NOT NULL,
    workspaceguid character varying(128) NOT NULL
);


ALTER TABLE public.user2workspace OWNER TO postgres;

--
-- TOC entry 1553 (class 1259 OID 630155)
-- Dependencies: 6 1552
-- Name: user2workspace_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE user2workspace_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.user2workspace_id_seq OWNER TO postgres;

--
-- TOC entry 1936 (class 0 OID 0)
-- Dependencies: 1553
-- Name: user2workspace_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE user2workspace_id_seq OWNED BY user2workspace.id;


--
-- TOC entry 1937 (class 0 OID 0)
-- Dependencies: 1553
-- Name: user2workspace_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('user2workspace_id_seq', 1, true);


--
-- TOC entry 1554 (class 1259 OID 630157)
-- Dependencies: 1537 6
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.user_id_seq OWNER TO postgres;

--
-- TOC entry 1938 (class 0 OID 0)
-- Dependencies: 1554
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE user_id_seq OWNED BY "user".id;


--
-- TOC entry 1939 (class 0 OID 0)
-- Dependencies: 1554
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('user_id_seq', 2, true);


--
-- TOC entry 1555 (class 1259 OID 630159)
-- Dependencies: 1857 1858 1859 6
-- Name: virtualfunction; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE virtualfunction (
    id integer NOT NULL,
    strname text NOT NULL,
    wsver integer DEFAULT (-1) NOT NULL,
    description text,
    sidname text NOT NULL,
    isdisplay boolean DEFAULT true,
    is_apply_all boolean DEFAULT false NOT NULL
);


ALTER TABLE public.virtualfunction OWNER TO postgres;

--
-- TOC entry 1556 (class 1259 OID 630168)
-- Dependencies: 6 1542
-- Name: virtualfunction2function_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE virtualfunction2function_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.virtualfunction2function_id_seq OWNER TO postgres;

--
-- TOC entry 1940 (class 0 OID 0)
-- Dependencies: 1556
-- Name: virtualfunction2function_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE virtualfunction2function_id_seq OWNED BY virtualfunction2function.id;


--
-- TOC entry 1941 (class 0 OID 0)
-- Dependencies: 1556
-- Name: virtualfunction2function_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('virtualfunction2function_id_seq', 26, true);


--
-- TOC entry 1557 (class 1259 OID 630170)
-- Dependencies: 1555 6
-- Name: virtualfunction_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE virtualfunction_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.virtualfunction_id_seq OWNER TO postgres;

--
-- TOC entry 1942 (class 0 OID 0)
-- Dependencies: 1557
-- Name: virtualfunction_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE virtualfunction_id_seq OWNED BY virtualfunction.id;


--
-- TOC entry 1943 (class 0 OID 0)
-- Dependencies: 1557
-- Name: virtualfunction_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('virtualfunction_id_seq', 8, true);


--
-- TOC entry 1849 (class 2604 OID 630172)
-- Dependencies: 1540 1539
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE function ALTER COLUMN id SET DEFAULT nextval('function_id_seq'::regclass);


--
-- TOC entry 1839 (class 2604 OID 630173)
-- Dependencies: 1545 1536
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE role ALTER COLUMN id SET DEFAULT nextval('role_id_seq'::regclass);


--
-- TOC entry 1850 (class 2604 OID 630174)
-- Dependencies: 1544 1541
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE role2virtualfunction ALTER COLUMN id SET DEFAULT nextval('role2virtualfunction_id_seq'::regclass);


--
-- TOC entry 1853 (class 2604 OID 630175)
-- Dependencies: 1547 1546
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE serverauthenticationtype ALTER COLUMN id SET DEFAULT nextval('serverauthenticationtype_id_seq'::regclass);


--
-- TOC entry 1854 (class 2604 OID 630176)
-- Dependencies: 1549 1548
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE sys_option ALTER COLUMN id SET DEFAULT nextval('sys_option_id_seq'::regclass);


--
-- TOC entry 1845 (class 2604 OID 630177)
-- Dependencies: 1554 1537
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE "user" ALTER COLUMN id SET DEFAULT nextval('user_id_seq'::regclass);


--
-- TOC entry 1855 (class 2604 OID 630178)
-- Dependencies: 1551 1550
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE user2role ALTER COLUMN id SET DEFAULT nextval('user2role_id_seq'::regclass);


--
-- TOC entry 1856 (class 2604 OID 630179)
-- Dependencies: 1553 1552
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE user2workspace ALTER COLUMN id SET DEFAULT nextval('user2workspace_id_seq'::regclass);


--
-- TOC entry 1860 (class 2604 OID 630180)
-- Dependencies: 1557 1555
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE virtualfunction ALTER COLUMN id SET DEFAULT nextval('virtualfunction_id_seq'::regclass);


--
-- TOC entry 1851 (class 2604 OID 630181)
-- Dependencies: 1556 1542
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE virtualfunction2function ALTER COLUMN id SET DEFAULT nextval('virtualfunction2function_id_seq'::regclass);


--
-- TOC entry 1911 (class 0 OID 630111)
-- Dependencies: 1539
-- Data for Name: function; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO function (id, strname, wsver, description, sidname, isdisplay, kval, is_apply_all) VALUES (1, 'Enterprise Server Management', -1, NULL, 'Appliance_Management', true, '385A3A6B6D726E6D74766D4E7A5F7A78767A766F676B2D54', false);
INSERT INTO function (id, strname, wsver, description, sidname, isdisplay, kval, is_apply_all) VALUES (15, 'Advance Troubleshooting', 0, '', 'Advance_Troubleshooting', true, '395A7465726D6C767347766C79666F69685F6C78677A6D773A52', false);
INSERT INTO function (id, strname, wsver, description, sidname, isdisplay, kval, is_apply_all) VALUES (16, 'Network Documentation', 0, '', 'Documentation', true, '39576D78726E7A6D677667666C6C3A3F', false);
INSERT INTO function (id, strname, wsver, description, sidname, isdisplay, kval, is_apply_all) VALUES (11, 'Simulation for Local Workspace', 1, '', 'Local_Simulation', false, '384F6D78726F7A48666E726F5F677A6C6C3A59', false);
INSERT INTO function (id, strname, wsver, description, sidname, isdisplay, kval, is_apply_all) VALUES (12, 'Network Documentation for Local Workspace', 1, '', 'Local_Documentation', false, '384F6D78726F7A576D786E66766C675F677A6C6C3A56', false);
INSERT INTO function (id, strname, wsver, description, sidname, isdisplay, kval, is_apply_all) VALUES (13, 'Live Network Discovery for Local Workspace', 1, '', 'Local_Live_Network_Discovery', false, '384F6278766F6C4F6865575F70766C6467694D5F767272785F657A696C3A4D', false);
INSERT INTO function (id, strname, wsver, description, sidname, isdisplay, kval, is_apply_all) VALUES (14, 'Advance Troubleshooting for Local Workspace', 1, '', 'Local_Advance_Troubleshooting', false, '384F7478726F6C5A7365766D79766C47695F66786F7A68776C5F677A6D6C3A4C', false);
INSERT INTO function (id, strname, wsver, description, sidname, isdisplay, kval, is_apply_all) VALUES (17, 'Monitor for Local Workspace', 1, '', 'Local_Monitor', false, '384F6978676F6D4E6C5F727A6C6C3A3F', false);
INSERT INTO function (id, strname, wsver, description, sidname, isdisplay, kval, is_apply_all) VALUES (18, 'Monitor for Share Workspace', 0, '', 'Monitor', false, '344E336D32673569393A336C3072346C3530', false);
INSERT INTO function (id, strname, wsver, description, sidname, isdisplay, kval, is_apply_all) VALUES (19, 'Path for Local Workspace', 1, '', 'Local_Path', false, '384F73787A6F5F4B7A676C3A3C', false);
INSERT INTO function (id, strname, wsver, description, sidname, isdisplay, kval, is_apply_all) VALUES (20, 'Path for Share Workspace', 0, '', 'Path', false, '344B3367323A3533393073347A3533', false);
INSERT INTO function (id, strname, wsver, description, sidname, isdisplay, kval, is_apply_all) VALUES (21, 'Public Link Group Management', 0, '', 'LinkGroup', false, '394F6B6D6C54697066723A3B', false);
INSERT INTO function (id, strname, wsver, description, sidname, isdisplay, kval, is_apply_all) VALUES (22, 'Site Management', 0, '', 'Site', false, '34483367323A353339307634723533', false);
INSERT INTO function (id, strname, wsver, description, sidname, isdisplay, kval, is_apply_all) VALUES (23, 'Shared Map', 0, '', 'SharedMap', false, '39486B7A4E7677697A733A3B', false);
INSERT INTO function (id, strname, wsver, description, sidname, isdisplay, kval, is_apply_all) VALUES (24, 'Auto Update Shared Map', 0, '', 'Update_Shared_Map', false, '39466B774E67775F69737A4876765F7A7A6B3A58', false);
INSERT INTO function (id, strname, wsver, description, sidname, isdisplay, kval, is_apply_all) VALUES (25, 'Network Design', 0, '', 'Design_Module', true, '3957766866746C5F4E6D77726F763A3F', false);
INSERT INTO function (id, strname, wsver, description, sidname, isdisplay, kval, is_apply_all) VALUES (2, 'L2 Topology Management', 0, NULL, 'L2_Topology_Management', true, '394F675F766C766C7A6C7A625F4E746D6F746B6E476D373A53', false);
INSERT INTO function (id, strname, wsver, description, sidname, isdisplay, kval, is_apply_all) VALUES (3, 'Live Network Discovery', 0, NULL, 'Live_Network_Discovery', true, '394F6265765F6C7668645769705F6C7267784D657669723A53', false);
INSERT INTO function (id, strname, wsver, description, sidname, isdisplay, kval, is_apply_all) VALUES (5, 'Server Benchmark', 0, NULL, 'Benchmark', true, '3959706D7A736E7869763A3B', false);
INSERT INTO function (id, strname, wsver, description, sidname, isdisplay, kval, is_apply_all) VALUES (6, 'Public Device Setting Management', 0, NULL, 'Common_Device_Setting_Management', true, '3958676E766C765F7A767A725F766D48676776725F74784E656D57746D6E6E6D6C3A49', false);
INSERT INTO function (id, strname, wsver, description, sidname, isdisplay, kval, is_apply_all) VALUES (7, 'Network Device Management', 0, NULL, 'Configuration_File_Management', true, '3958676D767276667A7A7A725F6D6F55725F766C4E676D6974746E756D6C3A4C', false);
INSERT INTO function (id, strname, wsver, description, sidname, isdisplay, kval, is_apply_all) VALUES (8, 'Topology Stitching Management', 0, NULL, 'Topology_Stitching_Management', true, '3947676B766F76747A5F7A675F676D73727874724E486D62746C6E6C6D6C3A4C', false);
INSERT INTO function (id, strname, wsver, description, sidname, isdisplay, kval, is_apply_all) VALUES (9, 'Traffic Stitching Management', 0, NULL, 'Traffic_Stitching_Management', true, '3947677A767576787A487A725F786D727374674E676D5F74726E756D693A4D', false);
INSERT INTO function (id, strname, wsver, description, sidname, isdisplay, kval, is_apply_all) VALUES (10, 'Device Group Management', 0, NULL, 'Device_Group_Management', true, '395767657678765F7A697A665F6B4E6C6D5474766E726D763A52', false);
INSERT INTO function (id, strname, wsver, description, sidname, isdisplay, kval, is_apply_all) VALUES (26, 'Device Icon', 0, '', 'DeviceIcon', false, '39576D6578787652726C763A3C', false);
INSERT INTO function (id, strname, wsver, description, sidname, isdisplay, kval, is_apply_all) VALUES (27, 'Show Command Template', 0, '', 'ShowCommand_Template', false, '3948766C7A586B6E767A5F776D476E6E6C6F6467733A55', false);
INSERT INTO function (id, strname, wsver, description, sidname, isdisplay, kval, is_apply_all) VALUES (28, 'Access to Live Network', 0, '', 'Live_Access', false, '394F6865765F785A787668723A3D', false);
INSERT INTO function (id, strname, wsver, description, sidname, isdisplay, kval, is_apply_all) VALUES (29, 'View Shared Device Settings', 0, '', 'View_Shared_Device_Settings', false, '394568766D5F677376695F7778576576725F7676487A6748726474723A4E', false);


--
-- TOC entry 1909 (class 0 OID 630080)
-- Dependencies: 1536
-- Data for Name: role; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO role (id, name, isdisplay, description, authentication_type) VALUES (1, 'Admin', true, NULL, 0);
INSERT INTO role (id, name, isdisplay, description, authentication_type) VALUES (5, 'Architect Role', false, NULL, 0);
INSERT INTO role (id, name, isdisplay, description, authentication_type) VALUES (2, 'PowerUser', true, NULL, 0);
INSERT INTO role (id, name, isdisplay, description, authentication_type) VALUES (4, 'Guest', true, NULL, 0);
INSERT INTO role (id, name, isdisplay, description, authentication_type) VALUES (3, 'Engineer', true, NULL, 0);


--
-- TOC entry 1912 (class 0 OID 630122)
-- Dependencies: 1541
-- Data for Name: role2virtualfunction; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO role2virtualfunction (id, roleid, virtualfunctionid) VALUES (1, 1, 1);
INSERT INTO role2virtualfunction (id, roleid, virtualfunctionid) VALUES (2, 1, 2);
INSERT INTO role2virtualfunction (id, roleid, virtualfunctionid) VALUES (3, 1, 3);
INSERT INTO role2virtualfunction (id, roleid, virtualfunctionid) VALUES (4, 1, 4);
INSERT INTO role2virtualfunction (id, roleid, virtualfunctionid) VALUES (5, 1, 5);
INSERT INTO role2virtualfunction (id, roleid, virtualfunctionid) VALUES (6, 1, 6);
INSERT INTO role2virtualfunction (id, roleid, virtualfunctionid) VALUES (7, 1, 7);
INSERT INTO role2virtualfunction (id, roleid, virtualfunctionid) VALUES (8, 1, 8);
INSERT INTO role2virtualfunction (id, roleid, virtualfunctionid) VALUES (9, 2, 2);
INSERT INTO role2virtualfunction (id, roleid, virtualfunctionid) VALUES (10, 2, 3);
INSERT INTO role2virtualfunction (id, roleid, virtualfunctionid) VALUES (11, 2, 4);
INSERT INTO role2virtualfunction (id, roleid, virtualfunctionid) VALUES (12, 2, 5);
INSERT INTO role2virtualfunction (id, roleid, virtualfunctionid) VALUES (13, 2, 6);
INSERT INTO role2virtualfunction (id, roleid, virtualfunctionid) VALUES (14, 2, 7);
INSERT INTO role2virtualfunction (id, roleid, virtualfunctionid) VALUES (15, 2, 8);
INSERT INTO role2virtualfunction (id, roleid, virtualfunctionid) VALUES (16, 3, 3);
INSERT INTO role2virtualfunction (id, roleid, virtualfunctionid) VALUES (17, 3, 4);
INSERT INTO role2virtualfunction (id, roleid, virtualfunctionid) VALUES (18, 3, 5);
INSERT INTO role2virtualfunction (id, roleid, virtualfunctionid) VALUES (19, 3, 7);
INSERT INTO role2virtualfunction (id, roleid, virtualfunctionid) VALUES (20, 4, 3);
INSERT INTO role2virtualfunction (id, roleid, virtualfunctionid) VALUES (21, 5, 2);
INSERT INTO role2virtualfunction (id, roleid, virtualfunctionid) VALUES (22, 5, 3);
INSERT INTO role2virtualfunction (id, roleid, virtualfunctionid) VALUES (23, 5, 4);
INSERT INTO role2virtualfunction (id, roleid, virtualfunctionid) VALUES (24, 5, 5);
INSERT INTO role2virtualfunction (id, roleid, virtualfunctionid) VALUES (25, 5, 6);
INSERT INTO role2virtualfunction (id, roleid, virtualfunctionid) VALUES (26, 5, 7);
INSERT INTO role2virtualfunction (id, roleid, virtualfunctionid) VALUES (27, 5, 8);


--
-- TOC entry 1914 (class 0 OID 630136)
-- Dependencies: 1546
-- Data for Name: serverauthenticationtype; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 1915 (class 0 OID 630142)
-- Dependencies: 1548
-- Data for Name: sys_option; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO sys_option (id, op_name, op_value) VALUES (2, 'passwordexpireday', 0);
INSERT INTO sys_option (id, op_name, op_value) VALUES (3, 'minimumpasswordlength', 6);
INSERT INTO sys_option (id, op_name, op_value) VALUES (1, 'strongpassword', 0);
INSERT INTO sys_option (id, op_name, op_value) VALUES (4, 'ldapauthentication', 0);


--
-- TOC entry 1910 (class 0 OID 630091)
-- Dependencies: 1537
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "user" (id, strname, password, description, email, telephone, can_use_global_telnet, offline_minutes, expired_days, authentication_type, create_time, wsver, validtime, validdate, firstlogtime, localnode) VALUES (-1, 'default', 'f18b2a06eb4bcef438df616fbae5546c', NULL, NULL, NULL, true, 120, NULL, 0, '2012-08-30 16:23:07.545', 0, NULL, NULL, NULL, NULL);
INSERT INTO "user" (id, strname, password, description, email, telephone, can_use_global_telnet, offline_minutes, expired_days, authentication_type, create_time, wsver, validtime, validdate, firstlogtime, localnode) VALUES (2, 'system', '697beb9e76a832288817ad18212bbf6a', '', '', '', true, 120, NULL, 0, '2012-09-14 13:20:07.77', 0, NULL, NULL, NULL, NULL);
INSERT INTO "user" (id, strname, password, description, email, telephone, can_use_global_telnet, offline_minutes, expired_days, authentication_type, create_time, wsver, validtime, validdate, firstlogtime, localnode) VALUES (1, 'admin', '21232f297a57a5a743894a0e4a801fc3', '', '', '', true, 120, NULL, 0, '2012-08-30 16:23:07.545', 0, NULL, NULL, NULL, 200);


--
-- TOC entry 1916 (class 0 OID 630147)
-- Dependencies: 1550
-- Data for Name: user2role; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO user2role (userid, roleid, id) VALUES (1, 1, 3);


--
-- TOC entry 1917 (class 0 OID 630152)
-- Dependencies: 1552
-- Data for Name: user2workspace; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 1918 (class 0 OID 630159)
-- Dependencies: 1555
-- Data for Name: virtualfunction; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO virtualfunction (id, strname, wsver, description, sidname, isdisplay, is_apply_all) VALUES (1, 'System Management', -1, NULL, 'System Management', true, false);
INSERT INTO virtualfunction (id, strname, wsver, description, sidname, isdisplay, is_apply_all) VALUES (2, 'Shared Workspace Management', -1, NULL, 'Shared Workspace Management', true, false);
INSERT INTO virtualfunction (id, strname, wsver, description, sidname, isdisplay, is_apply_all) VALUES (3, 'Network Documentation', -1, NULL, 'Network Documentation', true, false);
INSERT INTO virtualfunction (id, strname, wsver, description, sidname, isdisplay, is_apply_all) VALUES (5, 'Default', -1, NULL, 'Default', false, true);
INSERT INTO virtualfunction (id, strname, wsver, description, sidname, isdisplay, is_apply_all) VALUES (6, 'Network Design', -1, NULL, 'Network Design', false, false);
INSERT INTO virtualfunction (id, strname, wsver, description, sidname, isdisplay, is_apply_all) VALUES (7, 'Access to Live Network', -1, NULL, 'Live_Access', true, false);
INSERT INTO virtualfunction (id, strname, wsver, description, sidname, isdisplay, is_apply_all) VALUES (8, 'View Shared Device Settings', -1, NULL, 'View_Shared_Device_Settings', true, false);
INSERT INTO virtualfunction (id, strname, wsver, description, sidname, isdisplay, is_apply_all) VALUES (4, 'IP SLA, Netflow, and IP Accounting', -1, NULL, 'IP SLA and IP Accounting', true, false);


--
-- TOC entry 1913 (class 0 OID 630125)
-- Dependencies: 1542
-- Data for Name: virtualfunction2function; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO virtualfunction2function (id, virtualfunctionid, functionid) VALUES (1, 1, 1);
INSERT INTO virtualfunction2function (id, virtualfunctionid, functionid) VALUES (2, 2, 7);
INSERT INTO virtualfunction2function (id, virtualfunctionid, functionid) VALUES (3, 2, 3);
INSERT INTO virtualfunction2function (id, virtualfunctionid, functionid) VALUES (4, 2, 2);
INSERT INTO virtualfunction2function (id, virtualfunctionid, functionid) VALUES (5, 2, 6);
INSERT INTO virtualfunction2function (id, virtualfunctionid, functionid) VALUES (6, 2, 5);
INSERT INTO virtualfunction2function (id, virtualfunctionid, functionid) VALUES (7, 2, 8);
INSERT INTO virtualfunction2function (id, virtualfunctionid, functionid) VALUES (8, 2, 9);
INSERT INTO virtualfunction2function (id, virtualfunctionid, functionid) VALUES (9, 2, 10);
INSERT INTO virtualfunction2function (id, virtualfunctionid, functionid) VALUES (10, 2, 21);
INSERT INTO virtualfunction2function (id, virtualfunctionid, functionid) VALUES (11, 2, 22);
INSERT INTO virtualfunction2function (id, virtualfunctionid, functionid) VALUES (12, 2, 23);
INSERT INTO virtualfunction2function (id, virtualfunctionid, functionid) VALUES (13, 2, 24);
INSERT INTO virtualfunction2function (id, virtualfunctionid, functionid) VALUES (14, 2, 26);
INSERT INTO virtualfunction2function (id, virtualfunctionid, functionid) VALUES (15, 2, 27);
INSERT INTO virtualfunction2function (id, virtualfunctionid, functionid) VALUES (16, 3, 12);
INSERT INTO virtualfunction2function (id, virtualfunctionid, functionid) VALUES (17, 3, 16);
INSERT INTO virtualfunction2function (id, virtualfunctionid, functionid) VALUES (18, 4, 14);
INSERT INTO virtualfunction2function (id, virtualfunctionid, functionid) VALUES (19, 4, 15);
INSERT INTO virtualfunction2function (id, virtualfunctionid, functionid) VALUES (20, 5, 17);
INSERT INTO virtualfunction2function (id, virtualfunctionid, functionid) VALUES (21, 5, 18);
INSERT INTO virtualfunction2function (id, virtualfunctionid, functionid) VALUES (22, 5, 19);
INSERT INTO virtualfunction2function (id, virtualfunctionid, functionid) VALUES (23, 5, 20);
INSERT INTO virtualfunction2function (id, virtualfunctionid, functionid) VALUES (24, 6, 25);
INSERT INTO virtualfunction2function (id, virtualfunctionid, functionid) VALUES (25, 7, 28);
INSERT INTO virtualfunction2function (id, virtualfunctionid, functionid) VALUES (26, 8, 29);


--
-- TOC entry 1868 (class 2606 OID 630183)
-- Dependencies: 1539 1539
-- Name: function_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY function
    ADD CONSTRAINT function_pkey PRIMARY KEY (id);


--
-- TOC entry 1872 (class 2606 OID 630185)
-- Dependencies: 1541 1541
-- Name: role2virtualfunction_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY role2virtualfunction
    ADD CONSTRAINT role2virtualfunction_pk PRIMARY KEY (id);


--
-- TOC entry 1874 (class 2606 OID 630187)
-- Dependencies: 1541 1541 1541
-- Name: role2virtualfunction_un; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY role2virtualfunction
    ADD CONSTRAINT role2virtualfunction_un UNIQUE (roleid, virtualfunctionid);


--
-- TOC entry 1862 (class 2606 OID 630189)
-- Dependencies: 1536 1536
-- Name: role_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY role
    ADD CONSTRAINT role_pk PRIMARY KEY (id);


--
-- TOC entry 1882 (class 2606 OID 630191)
-- Dependencies: 1546 1546
-- Name: serverauthenticationtype_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY serverauthenticationtype
    ADD CONSTRAINT serverauthenticationtype_pk PRIMARY KEY (id);


--
-- TOC entry 1884 (class 2606 OID 630193)
-- Dependencies: 1548 1548
-- Name: sys_option_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY sys_option
    ADD CONSTRAINT sys_option_pk PRIMARY KEY (id);


--
-- TOC entry 1886 (class 2606 OID 630195)
-- Dependencies: 1548 1548
-- Name: sys_option_un; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY sys_option
    ADD CONSTRAINT sys_option_un UNIQUE (op_name);


--
-- TOC entry 1889 (class 2606 OID 630197)
-- Dependencies: 1550 1550
-- Name: user2role_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY user2role
    ADD CONSTRAINT user2role_pk PRIMARY KEY (id);


--
-- TOC entry 1891 (class 2606 OID 630199)
-- Dependencies: 1550 1550 1550
-- Name: user2role_unique; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY user2role
    ADD CONSTRAINT user2role_unique UNIQUE (userid, roleid);


--
-- TOC entry 1894 (class 2606 OID 630201)
-- Dependencies: 1552 1552
-- Name: user2workspace_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY user2workspace
    ADD CONSTRAINT user2workspace_pk PRIMARY KEY (id);


--
-- TOC entry 1896 (class 2606 OID 630203)
-- Dependencies: 1552 1552 1552
-- Name: user2workspace_un; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY user2workspace
    ADD CONSTRAINT user2workspace_un UNIQUE (userid, workspaceguid);


--
-- TOC entry 1864 (class 2606 OID 630205)
-- Dependencies: 1537 1537
-- Name: user_name_uk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT user_name_uk UNIQUE (strname);


--
-- TOC entry 1866 (class 2606 OID 630207)
-- Dependencies: 1537 1537
-- Name: user_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT user_pk PRIMARY KEY (id);


--
-- TOC entry 1878 (class 2606 OID 630209)
-- Dependencies: 1542 1542
-- Name: virtualfunction2function_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY virtualfunction2function
    ADD CONSTRAINT virtualfunction2function_pk PRIMARY KEY (id);


--
-- TOC entry 1880 (class 2606 OID 630211)
-- Dependencies: 1542 1542 1542
-- Name: virtualfunction2function_un; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY virtualfunction2function
    ADD CONSTRAINT virtualfunction2function_un UNIQUE (virtualfunctionid, functionid);


--
-- TOC entry 1898 (class 2606 OID 630213)
-- Dependencies: 1555 1555
-- Name: virtualfunction_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY virtualfunction
    ADD CONSTRAINT virtualfunction_pk PRIMARY KEY (id);


--
-- TOC entry 1900 (class 2606 OID 630215)
-- Dependencies: 1555 1555
-- Name: virtualfunction_un; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY virtualfunction
    ADD CONSTRAINT virtualfunction_un UNIQUE (sidname);


--
-- TOC entry 1870 (class 2606 OID 630217)
-- Dependencies: 1539 1539
-- Name: wsfunction_uniq_name_ver; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY function
    ADD CONSTRAINT wsfunction_uniq_name_ver UNIQUE (strname);


--
-- TOC entry 1887 (class 1259 OID 630218)
-- Dependencies: 1550
-- Name: fki_user2role_fk_roleid; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_user2role_fk_roleid ON user2role USING btree (roleid);


--
-- TOC entry 1892 (class 1259 OID 630219)
-- Dependencies: 1552
-- Name: fki_user2workspace_fkuser; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_user2workspace_fkuser ON user2workspace USING btree (userid);


--
-- TOC entry 1875 (class 1259 OID 630220)
-- Dependencies: 1542
-- Name: fki_virtualfunction2function_function_fk; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_virtualfunction2function_function_fk ON virtualfunction2function USING btree (functionid);


--
-- TOC entry 1876 (class 1259 OID 630221)
-- Dependencies: 1542
-- Name: fki_virtualfunction2function_role_fk; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_virtualfunction2function_role_fk ON virtualfunction2function USING btree (virtualfunctionid);


--
-- TOC entry 1908 (class 2620 OID 630222)
-- Dependencies: 21 1537
-- Name: userinfo_p; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER userinfo_p
    BEFORE INSERT OR DELETE OR UPDATE ON "user"
    FOR EACH ROW
    EXECUTE PROCEDURE process_userinfo_p();


--
-- TOC entry 1901 (class 2606 OID 630223)
-- Dependencies: 1536 1541 1861
-- Name: role2virtualfunction_role_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY role2virtualfunction
    ADD CONSTRAINT role2virtualfunction_role_fk FOREIGN KEY (roleid) REFERENCES role(id) ON DELETE CASCADE;


--
-- TOC entry 1902 (class 2606 OID 630228)
-- Dependencies: 1555 1897 1541
-- Name: role2virtualfunction_virtualfunction_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY role2virtualfunction
    ADD CONSTRAINT role2virtualfunction_virtualfunction_fk FOREIGN KEY (virtualfunctionid) REFERENCES virtualfunction(id) ON DELETE CASCADE;


--
-- TOC entry 1905 (class 2606 OID 630233)
-- Dependencies: 1536 1550 1861
-- Name: user2role_fk_roleid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user2role
    ADD CONSTRAINT user2role_fk_roleid FOREIGN KEY (roleid) REFERENCES role(id) ON DELETE CASCADE;


--
-- TOC entry 1906 (class 2606 OID 630238)
-- Dependencies: 1865 1537 1550
-- Name: user2role_fk_userid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user2role
    ADD CONSTRAINT user2role_fk_userid FOREIGN KEY (userid) REFERENCES "user"(id) ON DELETE CASCADE;


--
-- TOC entry 1907 (class 2606 OID 630243)
-- Dependencies: 1552 1537 1865
-- Name: user2workspace_fkuser; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user2workspace
    ADD CONSTRAINT user2workspace_fkuser FOREIGN KEY (userid) REFERENCES "user"(id) ON DELETE CASCADE;


--
-- TOC entry 1903 (class 2606 OID 630248)
-- Dependencies: 1539 1867 1542
-- Name: virtualfunction2function_function_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY virtualfunction2function
    ADD CONSTRAINT virtualfunction2function_function_fk FOREIGN KEY (functionid) REFERENCES function(id) ON DELETE CASCADE;


--
-- TOC entry 1904 (class 2606 OID 630253)
-- Dependencies: 1897 1542 1555
-- Name: virtualfunction2function_role_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY virtualfunction2function
    ADD CONSTRAINT virtualfunction2function_role_fk FOREIGN KEY (virtualfunctionid) REFERENCES virtualfunction(id) ON DELETE CASCADE;


--
-- TOC entry 1923 (class 0 OID 0)
-- Dependencies: 6
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2012-09-28 10:10:42

--
-- PostgreSQL database dump complete
--

