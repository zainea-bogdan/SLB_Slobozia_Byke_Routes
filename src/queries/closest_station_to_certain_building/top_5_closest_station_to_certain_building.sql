select s.station_uid,
       s.station_name,
       round(
          sdo_geom.sdo_distance(
             b.geom,
             s.geom,
             0.05,
             'unit=M'
          ),
          2
       ) as distance_m
  from slb_slobozia_buildings b
 cross join slb_byke_stations s
 where b.osm_id = 254133133
 order by distance_m
 fetch first 5 rows only;