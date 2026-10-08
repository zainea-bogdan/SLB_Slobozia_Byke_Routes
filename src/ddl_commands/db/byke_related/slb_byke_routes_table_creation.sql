create table slb_byke_routes (
   from_station_uid number       not null,
   to_station_uid   number       not null,
   route_profile    varchar2(30) not null,
   length_m         number(10,2) not null,
   duration_s       number(10),
   geom             mdsys.sdo_geometry,
   constraint slb_byke_routes_pk primary key ( from_station_uid, to_station_uid ),
   constraint slb_byke_routes_from_fk foreign key ( from_station_uid )
      references slb_byke_stations ( station_uid ),
   constraint slb_byke_routes_to_fk foreign key ( to_station_uid )
      references slb_byke_stations ( station_uid ),
   constraint slb_byke_routes_order_ck check ( from_station_uid < to_station_uid )
);
