create table slb_byke_chain (
   step             number(3) not null,
   from_station_uid number    not null,
   to_station_uid   number    not null,
   constraint slb_byke_chain_pk primary key ( step ),
   constraint slb_byke_chain_from_fk foreign key ( from_station_uid )
      references slb_byke_stations ( station_uid ),
   constraint slb_byke_chain_to_fk foreign key ( to_station_uid )
      references slb_byke_stations ( station_uid )
);
