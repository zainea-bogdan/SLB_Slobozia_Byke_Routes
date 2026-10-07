create table slb_slobozia_points (
   osm_id       number primary key,
   poi_name     varchar2(200 char),
   category     varchar2(30),
   sub_category varchar2(100),
   longitude    number(10,7),
   latitude     number(10,7),
   geom         mdsys.sdo_geometry
);
