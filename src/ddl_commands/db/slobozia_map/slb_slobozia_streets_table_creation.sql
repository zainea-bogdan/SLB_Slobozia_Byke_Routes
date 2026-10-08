create table slb_slobozia_streets (
   osm_id       number primary key,
   street_name  varchar2(200 char),
   highway_type varchar2(30),
   geom         mdsys.sdo_geometry
);



