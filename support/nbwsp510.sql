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



INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, licguid)VALUES (-1, 14, 0, 'Juniper EX Switch.ob', '620f4a3c31d34a068425ad6975fa3220.ob', now(), -1, '', now(),'');
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, licguid)VALUES (-1, 15, 0, 'Juniper EX Switch.xml', '77a9c854b7e0402ca4ec34172b3912d9.xml', now(), -1, '', now(),'');
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, licguid)VALUES (-1, 14, 0, 'Cisco Nexus Switch.ob', '1396c6d2b73748909cb9e8f0254457ac.ob', now(), -1, '', now(),'');
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, licguid)VALUES (-1, 15, 0, 'Cisco Nexus Switch.xml', '47908b8a37d5491ea8d1a1c5d6041ab0.xml', now(), -1, '', now(),'');
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, licguid)VALUES (-1, 14, 0, 'Extreme Switch.ob', '7f3620fe72404685a6cc58effd7200c1.ob', now(), -1, '', now(),'');
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, licguid)VALUES (-1, 15, 0, 'Extreme Switch.xml', '0bd8772dbbc3487d9bf5122d06c2de29.xml', now(), -1, '', now(),'');
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, licguid)VALUES (-1, 14, 0, 'Juniper SRX Firewall.ob', '32cdeaebd6f1480f9470de95b8090ee5.ob', now(), -1, '', now(),'');
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, licguid)VALUES (-1, 15, 0, 'Juniper SRX Firewall.xml', 'bdf2ee3d1dc043bbbb3ec7c526bc940d.xml', now(), -1, '', now(),'');
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, licguid)VALUES (-1, 14, 0, 'Juniper Router.ob', 'fb255a24432c4c99ad2f1a7ef5ab3eb8.ob', now(), -1, '', now(),'');
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, licguid)VALUES (-1, 15, 0, 'Juniper Router.xml', '9a1ccbd906874eb5b1c2517e27defab0.xml', now(), -1, '', now(),'');
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, licguid)VALUES (-1, 14, 0, 'Cisco ASA Firewall.ob', 'ca873f44031d415698276324f0eef93a.ob', now(), -1, '', now(),'');
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, licguid)VALUES (-1, 15, 0, 'Cisco ASA Firewall.xml', '8553773934554e5ba3c1d509c45af3ed.xml', now(), -1, '', now(),'');
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, licguid)VALUES (-1, 14, 0, 'Dell Force10 Switch.ob', 'b1dd889f5b20482c840f7f4c35946ad3.ob', now(), -1, '', now(),'');
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, licguid)VALUES (-1, 15, 0, 'Dell Force10 Switch.xml', '6409c95eeda7492c817785dc2b28274c.xml', now(), -1, '', now(),'');
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, licguid)VALUES (-1, 14, 0, 'Cisco Router.ob', '0e6e00c9f1f04d7ba6a33a903d4d769f.ob', now(), -1, '', now(),'');
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, licguid)VALUES (-1, 15, 0, 'Cisco Router.xml', '3df30e1099db4c79a62cf790707283fe.xml', now(), -1, '', now(),'');
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, licguid)VALUES (-1, 14, 0, 'HP ProCurve Switch.ob', 'e9c60b023f3f49558b47843a4a53fe32.ob', now(), -1, '', now(),'');
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, licguid)VALUES (-1, 15, 0, 'HP ProCurve Switch.xml', 'eb3697a6d7b249d98cb49a9058e1bdf2.xml', now(), -1, '', now(),'');
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, licguid)VALUES (-1, 14, 0, 'Cisco Catalyst Switch.ob', '14541887d39d448595f9dd9e12dac5da.ob', now(), -1, '', now(),'');
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, licguid)VALUES (-1, 15, 0, 'Cisco Catalyst Switch.xml', '395d6390aa41476594e66a64973758dd.xml', now(), -1, '', now(),'');
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, licguid)VALUES (-1, 14, 0, 'Cisco IOS Switch.ob', 'd2570759520c44bbaf7906414fcbf55b.ob', now(), -1, '', now(),'');
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, licguid)VALUES (-1, 15, 0, 'Cisco IOS Switch.xml', '5dacb9691a4c4fb69096caabafa4bbda.xml', now(), -1, '', now(),'');
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, licguid)VALUES (-1, 14, 0, 'Checkpoint Firewall.ob', '50d37428351044f5bd5c8f1bd9beecf0.ob', now(), -1, '', now(),'');
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, licguid)VALUES (-1, 15, 0, 'Checkpoint Firewall.xml', 'bb3e74591a204aa1a818274c05d37a5d.xml', now(), -1, '', now(),'');
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, licguid)VALUES (-1, 14, 0, 'Nortel  Switch.ob', 'ccd028c38c8d4ddbaad69154f5af1094.ob', now(), -1, '', now(),'');
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, licguid)VALUES (-1, 15, 0, 'Nortel  Switch.xml', '90e04dd52b0a48a79436e0d1c7411978.xml', now(), -1, '', now(),'');
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, licguid)VALUES (-1, 14, 0, 'NetScreen Firewall.ob', '7aa58081dec44b6781f3a6a19dfb0937.ob', now(), -1, '', now(),'');
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, licguid)VALUES (-1, 15, 0, 'NetScreen Firewall.xml', '1b6e08826b5947d39ab728eae6b6be32.xml', now(), -1, '', now(),'');
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, licguid)VALUES (-1, 14, 0, 'F5 Load Balancer.ob', 'b5aabb080b0a413482233c3da6384aba.ob', now(), -1, '', now(),'');
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, licguid)VALUES (-1, 15, 0, 'F5 Load Balancer.xml', '4dc71444a8ee46519609d340e4f0be5f.xml', now(), -1, '', now(),'');
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, licguid)VALUES (-1, 14, 0, 'Cisco WAP.ob', '61d2b63973f1421fa309dc1c5c2319e3.ob', now(), -1, '', now(),'');
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, licguid)VALUES (-1, 15, 0, 'Cisco WAP.xml', '9c22e2386c954b1fa4b2369440eac0f5.xml', now(), -1, '', now(),'');
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, licguid)VALUES (-1, 14, 0, 'Cisco PIX Firewall.ob', '5c24604384ed460583c40b935ff1efcb.ob', now(), -1, '', now(),'');
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, licguid)VALUES (-1, 15, 0, 'Cisco PIX Firewall.xml', '2175956562f44741b9d4ded77e10f95f.xml', now(), -1, '', now(),'');
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, licguid)VALUES (-1, 14, 0, 'Cisco IOS XR.ob', 'd6be27a744044550ac2ee200068a6c9b.ob', now(), -1, '', now(),'');
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, licguid)VALUES (-1, 15, 0, 'Cisco IOS XR.xml', '0369fb8d26c44504aa96a6ee9b034ca8.xml', now(), -1, '', now(),'');
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, licguid)VALUES (-1, 14, 0, 'Ciena Switch.ob', '62ffd52a8b66484c96754a7c95a74a6b.ob', now(), -1, '', now(),'');
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, licguid)VALUES (-1, 15, 0, 'Ciena Switch.xml', '139ddee638274828b7ab379bc66d06ac.xml', now(), -1, '', now(),'');
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, licguid)VALUES (-1, 14, 0, 'Brocade Switch.ob', 'ea3aa964281246b9ad949d5cf2c6e3bd.ob', now(), -1, '', now(),'');
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, licguid)VALUES (-1, 15, 0, 'Brocade Switch.xml', 'efef3b4138a745639c575aaddcbc7cfd.xml', now(), -1, '', now(),'');
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, licguid)VALUES (-1, 14, 0, '3Com Switch.ob', 'bb3e3861f3e04d339f4fce7a69e73d9e.ob', now(), -1, '', now(),'');
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, licguid)VALUES (-1, 15, 0, '3Com Switch.xml', 'dce8d341bce14345aea0e2878bd01258.xml', now(), -1, '', now(),'');
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, licguid)VALUES (-1, 14, 0, 'Arista Switch.ob', 'bf33491f86164d1db92e2afb3403248c.ob', now(), -1, '', now(),'');
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, licguid)VALUES (-1, 15, 0, 'Arista Switch.xml', '3e6e8b636f504e59a1798aa71160979a.xml', now(), -1, '', now(),'');
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, licguid)VALUES (-1, 14, 0, 'Enterasys  Switch.ob', '72bf811167dc4c94a30916a51267d2da.ob', now(), -1, '', now(),'');
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, licguid)VALUES (-1, 15, 0, 'Enterasys  Switch.xml', 'caef6d2833e648fd877f631d42a24d39.xml', now(), -1, '', now(),'');
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, licguid)VALUES (-1, 14, 0, 'IP Phone.ob', 'e407ff423d5b464895f9b8722d7cef5d.ob', now(), -1, '', now(),'');
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, licguid)VALUES (-1, 15, 0, 'IP Phone.xml', '4b13d0652208433aa01710651539918a.xml', now(), -1, '', now(),'');




INSERT INTO objtimestamp(typename, modifytime) VALUES ('Observer_DeviceHostPicture', now());
INSERT INTO objtimestamp(typename, modifytime) VALUES ('Observer_DeviceTypePicture', now());
INSERT INTO objtimestamp(typename, modifytime) VALUES ('Observer_DeviceXml', now());



INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, licguid)VALUES (-1, 14, 0, 'Default.bmp', '4ecaec3965cd41519f6ed952c3abe950.bmp', now(), -1, '', now(), '');


CREATE TABLE benchmark2cmdproce
(
  id serial NOT NULL,
  cmdproce_objectfileid integer NOT NULL,
  CONSTRAINT benchmark2cmdproce_pk PRIMARY KEY (id),
  CONSTRAINT benchmark2cmdproce_un UNIQUE (cmdproce_objectfileid)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE benchmark2cmdproce OWNER TO postgres;


update site set description="comment" where "comment"<>'' and (description is null or description='' );


INSERT INTO object_file_path_info(path, lasttimestamp, path_update_time, object_type) VALUES ('CommandProcedure', now(), now(), 10);
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp,path_id, licguid)VALUES (-1, 10, 0, 'Check Interfaces.qapp', 'btte74591a2bbaa1a818tt4r05d37axxdebxcv.qapp', now(), -1, '', now(),(select id from object_file_path_info where path='CommandProcedure'),'');
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp,path_id, licguid)VALUES (-1, 10, 0, 'Route Protocols.qapp', 'be4te74591a2bbaa1a818tt4r0ddd23veg34t34.qapp', now(), -1, '', now(),(select id from object_file_path_info where path='CommandProcedure'),'');



update system_info set ver=510;