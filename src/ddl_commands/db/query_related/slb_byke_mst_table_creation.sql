create table slb_byke_mst (
   from_station_uid number not null,
   to_station_uid   number not null,
   pick_order       number(3) not null,
   constraint slb_byke_mst_pk primary key ( from_station_uid,
                                            to_station_uid ),
   constraint slb_byke_mst_route_fk
      foreign key ( from_station_uid,
                    to_station_uid )
         references slb_byke_routes ( from_station_uid,
                                      to_station_uid ),
   constraint slb_byke_mst_order_uk unique ( pick_order )
);