\connect :nbwsp

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;



CREATE OR REPLACE FUNCTION view_object_file_info_retrieve2(ibegin integer, imax integer, objtype integer,userid integer)
  RETURNS SETOF object_file_info AS
$BODY$
declare
	r object_file_info%rowtype;	
BEGIN
	if imax <0 then
			for r in select * from object_file_info where object_type=objtype and file_update_userid =userid and id>ibegin order by id loop
			return next r;
			end loop;
		else
			for r in select * from object_file_info where object_type=objtype and file_update_userid =userid and id>ibegin order by id limit imax loop			
			return next r;
			end loop;

		end if;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION view_object_file_info_retrieve2(integer, integer, integer,integer) OWNER TO postgres;



INSERT INTO objtimestamp(typename, modifytime) VALUES ('Observer_DeviceHostPicture', now());
INSERT INTO objtimestamp(typename, modifytime) VALUES ('Observer_DeviceTypePicture', now());
INSERT INTO objtimestamp(typename, modifytime) VALUES ('Observer_DeviceXml', now());



update system_info set ver=510;