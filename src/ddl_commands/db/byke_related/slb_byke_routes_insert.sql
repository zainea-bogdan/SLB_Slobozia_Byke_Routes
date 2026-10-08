insert into slb_byke_routes (
   from_station_uid,
   to_station_uid,
   route_profile,
   length_m,
   duration_s,
   geom
)
   select stg.from_station_uid,
          stg.to_station_uid,
          stg.route_profile,
          json_value(stg.payload,
                     '$.features[0].properties."track-length"' returning number) as length_m,
          json_value(stg.payload,
                     '$.features[0].properties."total-time"' returning number) as duration_s,
          sdo_cs.make_2d(
             sdo_util.from_geojson(json_query(stg.payload,
                  '$.features[0].geometry' returning clob)),
             8307
          ) as geom
     from stg_ideal_routes_between_byke_stations stg
    where json_value(stg.payload,
           '$.features[0].properties."track-length"' returning number) > 0;

commit;