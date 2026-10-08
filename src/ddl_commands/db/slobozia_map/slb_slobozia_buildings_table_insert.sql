insert into slb_slobozia_buildings (
   osm_id,
   building_name,
   building_type,
   levels,
   geom
)
   with way_nodes as (
      select jt.way_id,
             jt.building_name,
             jt.building_type,
             jt.levels,
             jt.node_seq,
             jt.node_ref
        from stg_osm_map s,
             json_table ( s.payload,'$.elements[*]'
                columns (
                   elem_type varchar2 ( 10 ) path '$.type',
                   way_id number path '$.id',
                   building_name varchar2 ( 200 char ) path '$.tags.name',
                   building_type varchar2 ( 30 ) path '$.tags.building',
                   levels number path '$.tags."building:levels"',
                   nested path '$.nodes[*]'
                      columns (
                         node_seq for ordinality,
                         node_ref number path '$'
                      )
                )
             )
          jt
       where jt.elem_type = 'way'
         and jt.building_type is not null
         and jt.building_type <> 'no'
   ),building_points as (
      select wn.way_id,
             wn.building_name,
             wn.building_type,
             wn.levels,
             wn.node_seq,
             nc.node_lon,
             nc.node_lat
        from way_nodes wn
        join slb_slobozia_streets_nodes_lookup nc
      on nc.node_id = wn.node_ref
   ),building_wkt as (
      select bp.way_id,
             bp.building_name,
             bp.building_type,
             bp.levels,
             'POLYGON (('
             ||
             listagg(bp.node_lon
                     || ' '
                     || bp.node_lat,
                     ', ') within group(
                 order by bp.node_seq)
             || '))' as wkt
        from building_points bp
       group by bp.way_id,
                bp.building_name,
                bp.building_type,
                bp.levels
   )
   select bw.way_id,
          nvl(
             bw.building_name,
             'No Name'
          ),
          bw.building_type,
          bw.levels,
          sdo_util.rectify_geometry(
             mdsys.sdo_geometry(
                bw.wkt,
                8307
             ),
             0.05
          )
     from building_wkt bw;

commit;


