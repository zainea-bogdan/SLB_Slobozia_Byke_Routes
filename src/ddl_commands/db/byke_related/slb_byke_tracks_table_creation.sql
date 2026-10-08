create table slb_byke_tracks (
   track_code varchar2(30) not null,
   track_name varchar2(200 char) not null,
   length_m   number(10,2),
   duration_s number(10),
   geom       mdsys.sdo_geometry,
   constraint slb_byke_tracks_pk primary key ( track_code )
);