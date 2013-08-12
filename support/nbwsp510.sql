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


INSERT INTO object_file_path_info(path, lasttimestamp, path_update_time, object_type) VALUES ('EsCommandProcedureFolder_Built_in', now(), now(), 10);
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp,path_id, licguid)VALUES (-1, 10, 0, 'BGP Neighbors.qapp', 'btte74591a2bbaa1a818tt4r05d37axxdebxcv.qapp', now(), -1, '', now(),(select id from object_file_path_info where path='EsCommandProcedureFolder_Built_in'),'');
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp,path_id, licguid)VALUES (-1, 10, 0, 'EIGRP Neighbors.qapp', 'be4te74591a2bbaa1a818tt4r0ddd23veg34t34.qapp', now(), -1, '', now(),(select id from object_file_path_info where path='EsCommandProcedureFolder_Built_in'),'');
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp,path_id, licguid)VALUES (-1, 10, 0, 'IS-IS Neighbors.qapp', 'btte74591a2bbaa1a818tt4r05d37axxdebx11.qapp', now(), -1, '', now(),(select id from object_file_path_info where path='EsCommandProcedureFolder_Built_in'),'');
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp,path_id, licguid)VALUES (-1, 10, 0, 'LDP Neighbors.qapp', 'be4te74591a2bbaa1a818tt4r0ddd23veg34t22.qapp', now(), -1, '', now(),(select id from object_file_path_info where path='EsCommandProcedureFolder_Built_in'),'');
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp,path_id, licguid)VALUES (-1, 10, 0, 'OSPF Neighbors.qapp', 'btte74591a2bbaa1a818tt4r05d37axxde555.qapp', now(), -1, '', now(),(select id from object_file_path_info where path='EsCommandProcedureFolder_Built_in'),'');
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp,path_id, licguid)VALUES (-1, 10, 0, 'PIM Neighbors.qapp', 'be4te74591a2bbaa1a818tt4r0dddbbbrrg.qapp', now(), -1, '', now(),(select id from object_file_path_info where path='EsCommandProcedureFolder_Built_in'),'');
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp,path_id, licguid)VALUES (-1, 10, 0, 'Cisco Nexus VDC.qapp', 'b74te74591a2bbaa1avvvvt4r0dddbbbrr1111.qapp', now(), -1, '', now(),(select id from object_file_path_info where path='EsCommandProcedureFolder_Built_in'),'');
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp,path_id, licguid)VALUES (-1, 10, 0, 'Interface Information Brief.qapp', 'b999974591a2bbaa1avvvvt4r0dddbbbrr1111.qapp', now(), -1, '', now(),(select id from object_file_path_info where path='EsCommandProcedureFolder_Built_in'),'');
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp,path_id, licguid)VALUES (-1, 10, 0, 'Cisco IOS NAT Table.qapp', 'b777474591a2bbaa1avvvvt4r0dddbbbrr1111.qapp', now(), -1, '', now(),(select id from object_file_path_info where path='EsCommandProcedureFolder_Built_in'),'');
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp,path_id, licguid)VALUES (-1, 10, 0, 'Virtual Server Table.qapp', 'b889954474591a2bbtyimehttrbbrbguil.qapp', now(), -1, '', now(),(select id from object_file_path_info where path='EsCommandProcedureFolder_Built_in'),'');


INSERT INTO object_file_path_info(path, lasttimestamp, path_update_time, object_type) VALUES ('EsProfiles', now(), now(), 10);
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp,path_id, licguid)VALUES (-1, 10, 0, 'BGP Routing.monprofile', 'c24c0da0efa74e23858ed4496bc0882b.monprofile', now(), -1, '', now(),(select id from object_file_path_info where path='EsProfiles'),'');
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp,path_id, licguid)VALUES (-1, 10, 0, 'IS-IS Routing.monprofile', '2125ed3bfd264baabe200e46dfdd002b.monprofile', now(), -1, '', now(),(select id from object_file_path_info where path='EsProfiles'),'');
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp,path_id, licguid)VALUES (-1, 10, 0, 'Multicast Monitoring for Specified Group.monprofile', 'd7a378cb04d6453e80c4f29458814879.monprofile', now(), -1, '', now(),(select id from object_file_path_info where path='EsProfiles'),'');
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp,path_id, licguid)VALUES (-1, 10, 0, 'Multicast Monitoring without Specified Group.monprofile', '6e883136230d4e85b2ca6f63e13b75db.monprofile', now(), -1, '', now(),(select id from object_file_path_info where path='EsProfiles'),'');
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp,path_id, licguid)VALUES (-1, 10, 0, 'OSPF Routing.monprofile', 'a8e326c9df924375986d45f051dbdd0c.monprofile', now(), -1, '', now(),(select id from object_file_path_info where path='EsProfiles'),'');
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp,path_id, licguid)VALUES (-1, 10, 0, 'Interface Error Check.monprofile', '217b080f49d244e89bf2ba6828d396ea.monprofile', now(), -1, '', now(),(select id from object_file_path_info where path='EsProfiles'),'');
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp,path_id, licguid)VALUES (-1, 10, 0, 'RIP Routing.monprofile', '3f396991a0d547da8ec536ff45fe01ea.monprofile', now(), -1, '', now(),(select id from object_file_path_info where path='EsProfiles'),'');
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp,path_id, licguid)VALUES (-1, 10, 0, 'STP Monitoring.monprofile', '3yy396991w0d547bxec536ff45fe01111.monprofile', now(), -1, '', now(),(select id from object_file_path_info where path='EsProfiles'),'');
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp,path_id, licguid)VALUES (-1, 10, 0, 'General Routes.monprofile', 'aty39ehe991wdfge47bxdgs6ff45werwv.monprofile', now(), -1, '', now(),(select id from object_file_path_info where path='EsProfiles'),'');
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp,path_id, licguid)VALUES (-1, 10, 0, 'EIGRP Routing.monprofile', '3xx396991w0d547bxec536ff45nn333.monprofile', now(), -1, '', now(),(select id from object_file_path_info where path='EsProfiles'),'');
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp,path_id, licguid)VALUES (-1, 10, 0, 'QoS Monitoring.monprofile', '444fer91w0d547bxec536ff45n444.monprofile', now(), -1, '', now(),(select id from object_file_path_info where path='EsProfiles'),'');


DROP FUNCTION site_olddelete(integer[], integer);
CREATE OR REPLACE FUNCTION site_olddelete(siteids integer[], site_mid integer)
  RETURNS boolean AS
$BODY$

BEGIN
	delete from clustersite2site where clustersiteid in  (select id from site where sitemanagerid= site_mid);
	delete from site2sitecluster where siteid in  (select id from site where sitemanagerid= site_mid);
	delete from site2site where siteid in  (select id from site where sitemanagerid= site_mid);
	delete from devicesitedevice where siteid in (select id from site where sitemanagerid= site_mid);
	delete from site_customized_borderinterface where siteid in (select id from site where sitemanagerid= site_mid);	
	delete from site_customized_info where objectid in (select id from site where sitemanagerid= site_mid);
	delete from site where sitemanagerid=site_mid;
	return true;
EXCEPTION    
	WHEN OTHERS THEN   
		return false;		
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION site_olddelete(integer[], integer) OWNER TO postgres;


CREATE OR REPLACE FUNCTION site_customized_info_check(atrrnames character varying[])
  RETURNS boolean AS
$BODY$
declare	
        attr_id integer;	
BEGIN		
	for r in  1..array_length(atrrnames,1) loop
		select id into attr_id from object_customized_attribute where name=atrrnames[r] and objectid=5;
		if attr_id IS NULL THEN
			insert into object_customized_attribute (objectid,name,alias,allow_export,type,allow_modify_exported,lasttimestamp) values (5,atrrnames[r],atrrnames[r],'true',2,'true',now());			
		end if;		
	end loop;		
	return true;
EXCEPTION
	WHEN OTHERS THEN 
		RETURN false;	
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION site_customized_info_check(character varying[]) OWNER TO postgres;



CREATE OR REPLACE FUNCTION set_local_cli_settings_for_ite_user_automatically(new_user_id integer, temp_user_id integer)
  RETURNS boolean AS
$BODY$
declare
	jumpbox nomp_jumpbox%rowtype;	
	telnet nomp_telnetinfo%rowtype;	
	userdevice userdevicesetting%rowtype;
	tmp_id integer;
	jumpbox_id integer;
BEGIN	
	for jumpbox in select * from nomp_jumpbox where userid =temp_user_id loop
		select id into tmp_id from nomp_jumpbox where strname= jumpbox.strname and licguid=jumpbox.licguid and userid=new_user_id;
		if tmp_id IS NULL then
			insert into nomp_jumpbox(
			  strname,
			  itype,
			  stripaddr,
			  iport,
			  imode,
			  strusername,
			  strpasswd,
			  strloginprompt,
			  strpasswdprompt,
			  strcommandprompt,
			  stryesnoprompt,
			  bmodified,
			  strenablecmd,
			  strenablepasswordprompt,
			  strenablepassword,
			  strenableprompt,
			  ipri,
			  userid,
			  licguid
			  )
			  values( 
			  jumpbox.strname,
			  jumpbox.itype,
			  jumpbox.stripaddr,
			  jumpbox.iport,
			  jumpbox.imode,
			  jumpbox.strusername,
			  jumpbox.strpasswd,
			  jumpbox.strloginprompt,
			  jumpbox.strpasswdprompt,
			  jumpbox.strcommandprompt,
			  jumpbox.stryesnoprompt,
			  jumpbox.bmodified,
			  jumpbox.strenablecmd,
			  jumpbox.strenablepasswordprompt,
			  jumpbox.strenablepassword,
			  jumpbox.strenableprompt,
			  jumpbox.ipri,
			  new_user_id,
			  jumpbox.licguid
			  );
		end if;	
		select id into jumpbox_id from nomp_jumpbox where strname= jumpbox.strname and licguid=jumpbox.licguid and userid=new_user_id;
	end loop;


	for telnet in select * from nomp_telnetinfo where userid =temp_user_id loop
		select id into tmp_id from nomp_telnetinfo where stralias= telnet.stralias and licguid=telnet.licguid and userid=new_user_id;
		if tmp_id IS NULL then
			insert into nomp_telnetinfo(
			  stralias,
			  idevicetype,
			  strusername,
			  strpasswd,
			  bmodified,
			  userid,
			  ipri,
			  licguid
			  )
			  values( 
			  telnet.stralias,
			  telnet.idevicetype,
			  telnet.strusername,
			  telnet.strpasswd,
			  telnet.bmodified,
			  new_user_id,
			  telnet.ipri,
			  telnet.licguid
			  );
		end if;	
	end loop;


	for userdevice in select * from userdevicesetting where userid =temp_user_id loop
		select id into tmp_id from userdevicesetting where deviceid= userdevice.deviceid and licguid=userdevice.licguid and userid=new_user_id;
		if tmp_id IS NULL then
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
			  values( 
			  userdevice.deviceid,
			  new_user_id,
			  userdevice.managerip,
			  userdevice.telnetusername,
			  userdevice.telnetpwd,
			  userdevice.dtstamp,
			  jumpbox_id,
			  userdevice.licguid
			  );
		end if;	
	end loop;
		
	
	return true;
EXCEPTION
	WHEN OTHERS THEN 
		RETURN false;	
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION set_local_cli_settings_for_ite_user_automatically(integer, integer) OWNER TO postgres;



INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp)VALUES ( -1, 14, 0, '9e0000000093e0.ob', 'ac2659e7789e44fda0aa60c9de1e813e.ob', now(), -1, '', now());
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp)VALUES ( -1, 14, 0, '9e0000000093e1.ob', '353705a3912f4f78b4757f384b34bdaf.ob', now(), -1, '', now());
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp)VALUES ( -1, 14, 0, '9e0000000093e2.ob', '884677fc2d84459e95978f2216f17aa9.ob', now(), -1, '', now());
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp)VALUES ( -1, 14, 0, '9e0000000093e3.ob', 'c4cbae8008274ed69cd61aa845fc9917.ob', now(), -1, '', now());
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp)VALUES ( -1, 14, 0, '9e0000000093e4.ob', 'a418e92704f142108876eb9bee44583a.ob', now(), -1, '', now());
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp)VALUES ( -1, 14, 0, '9e0000000093e5.ob', '2e901ed31ed04a0cb27750e4bd4dec43.ob', now(), -1, '', now());
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp)VALUES ( -1, 14, 0, '9e0000000093e6.ob', '60ca0239b0c8469ebbaa8d0d7abfe3d1.ob', now(), -1, '', now());
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp)VALUES ( -1, 14, 0, '9e0000000093e7.ob', '794286b4b265413e82e2b398f441ead9.ob', now(), -1, '', now());
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp)VALUES ( -1, 14, 0, '9e0000000093e8.ob', 'b8594ff9732f4d998e694c3492099136.ob', now(), -1, '', now());
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp)VALUES ( -1, 14, 0, '9e0000000093fc.ob', '24c5a55d2eb34e1387f8005395827074.ob', now(), -1, '', now());
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp)VALUES ( -1, 14, 0, '9e0000000093fd.ob', '1d12683564924ed6b07d80a15c95b489.ob', now(), -1, '', now());
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp)VALUES ( -1, 14, 0, '9e0000000093fe.ob', '1eb6af7c91b143e486998c60621b90d0.ob', now(), -1, '', now());
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp)VALUES ( -1, 14, 0, '9e0000000093ff.ob', 'cd4d0d9a8c9f4222a5465142a344f8cb.ob', now(), -1, '', now());
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp)VALUES ( -1, 14, 0, '9e000000009413.ob', '2aa3171701d24621b715eccb39ab2668.ob', now(), -1, '', now());
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp)VALUES ( -1, 14, 0, '9e000000009414.ob', '9361b76a1e884dccaeb7ef846d17a93d.ob', now(), -1, '', now());
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp)VALUES ( -1, 14, 0, '9e000000009415.ob', 'c1eef061e3934e01aff5cf344046d948.ob', now(), -1, '', now());
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp)VALUES ( -1, 14, 0, '9e000000009416.ob', 'b8d2ad5e03cd4a079f407430c1d7b9bd.ob', now(), -1, '', now());
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp)VALUES ( -1, 14, 0, '9e000000009417.ob', '61472901d620440888a7870a1b599195.ob', now(), -1, '', now());
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp)VALUES ( -1, 14, 0, '9e000000009418.ob', '7feb052765594a068c3b9e43e46447be.ob', now(), -1, '', now());
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp)VALUES ( -1, 14, 0, '9e000000009419.ob', '811b96c0e61745e8adcce2418fd4b3f6.ob', now(), -1, '', now());
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp)VALUES ( -1, 14, 0, '9e00000000941a.ob', 'c56e598bae594c3281e0787241ee934f.ob', now(), -1, '', now());
INSERT INTO object_file_info(object_id, object_type, file_type, file_real_name, file_save_name, file_update_time, file_update_userid, user_property, lasttimestamp, licguid)VALUES (-1, 15, 0, 'ApplyTo.xml', '66b4d6cbd9e343ce98e53c9b96954f3a.xml', now(), -1, '', now(),'');



ALTER TABLE site DROP CONSTRAINT site_uniq_name;


DROP FUNCTION site_olddelete(integer[], integer);

CREATE OR REPLACE FUNCTION site_olddelete(siteids integer[], site_mid integer)
  RETURNS boolean AS
$BODY$

BEGIN
	delete from clustersite2site where clustersiteid in  (select id from site where sitemanagerid= site_mid);
	delete from site2sitecluster where siteid in  (select id from site where sitemanagerid= site_mid);
	delete from site2site where siteid in (select id from site where sitemanagerid= site_mid);
	delete from devicesitedevice where siteid in (select id from site where sitemanagerid= site_mid);
	delete from site_customized_borderinterface where siteid in (select id from site where sitemanagerid= site_mid);
	delete from site_customized_info where objectid in (select id from site where sitemanagerid= site_mid);
	delete from site where sitemanagerid=site_mid and id <> all(siteids);
	return true;
EXCEPTION    
	WHEN OTHERS THEN   
		return false;		
END;

  $BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION site_olddelete(integer[], integer) OWNER TO postgres;



update system_info set ver=510;