-- layer: MST network (25 routes that connect all stations with minimum km)
select r.from_station_uid,
       r.to_station_uid,
       r.length_m,
       r.geom
  from slb_byke_routes r
 where ( r.from_station_uid,
         r.to_station_uid ) in (
   select from_station_uid,
          to_station_uid
     from slb_byke_mst
);
