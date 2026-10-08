create table slb_byke_stations (
   station_uid    number not null,
   station_number number,
   station_name   varchar2(200 char) not null,
   station_type   varchar2(10) not null,
   bike_racks     number(3),
   longitude      number(10,7),
   latitude       number(10,7),
   geom           mdsys.sdo_geometry,
   constraint slb_byke_stations_pk primary key ( station_uid ),
   constraint slb_byke_stations_type_ck check ( station_type in ( 'docked',
                                                                  'dockless' ) )
);