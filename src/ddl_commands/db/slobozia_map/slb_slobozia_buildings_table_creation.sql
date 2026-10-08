create table slb_slobozia_buildings (
   osm_id        number primary key,
   building_name varchar2(200 char),
   building_type varchar2(30),
   levels        number(3), -- numarul de etaje
   geom          mdsys.sdo_geometry
);