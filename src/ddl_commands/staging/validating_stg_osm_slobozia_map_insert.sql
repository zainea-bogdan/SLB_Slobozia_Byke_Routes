select load_date,
       bbox_north,
       bbox_west,
       bbox_south,
       bbox_east,
       json_value(payload,
                  '$.generator') as generator
  from stg_osm_map;

select jt.el_type,
       count(*) as cnt
  from stg_osm_map s,
       json_table ( s.payload,'$.elements[*]'
          columns (
             el_type varchar2 ( 10 ) path '$.type'
          )
       )
    jt
 group by jt.el_type
 order by cnt desc;