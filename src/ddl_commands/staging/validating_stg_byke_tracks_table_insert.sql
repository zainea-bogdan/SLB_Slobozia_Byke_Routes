select track_code,
       track_name,
       json_value(payload,
                  '$.features[0].properties."track-length"' returning number) as length_m
  from stg_byke_tracks
 order by track_code;