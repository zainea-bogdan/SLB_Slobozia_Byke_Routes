insert into slb_byke_tracks (
   track_code,
   track_name,
   length_m,
   duration_s,
   geom
)
   select stg.track_code,
          stg.track_name,
          json_value(stg.payload,
                     '$.features[0].properties."track-length"' returning number) as length_m,
          json_value(stg.payload,
                     '$.features[0].properties."total-time"' returning number) as duration_s,
          sdo_cs.make_2d(
             sdo_util.from_geojson(
                json_query(stg.payload,
                           '$.features[0].geometry' returning clob)
             ),
             8307
          ) as geom
     from stg_byke_tracks stg;

commit;

