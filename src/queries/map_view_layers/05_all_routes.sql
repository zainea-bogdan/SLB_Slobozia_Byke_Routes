-- layer: all routes between stations
select from_station_uid,
       to_station_uid,
       length_m,
       geom
  from slb_byke_routes;
