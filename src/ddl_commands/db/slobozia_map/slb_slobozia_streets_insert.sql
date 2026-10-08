insert into slb_slobozia_streets (
   osm_id,
   street_name,
   highway_type,
   geom
)
   with way_nodes as (
      select jt.way_id,
             jt.street_name,
             jt.highway_type,
             jt.node_seq,
             jt.node_ref
        from stg_osm_map s,
             json_table ( s.payload,'$.elements[*]'
                columns (
                   elem_type varchar2 ( 10 ) path '$.type',
                   way_id number path '$.id',
                   street_name varchar2 ( 200 char ) path '$.tags.name',
                   highway_type varchar2 ( 30 ) path '$.tags.highway',
                   nested path '$.nodes[*]'
                      columns (
                         node_seq for ordinality,
                         node_ref number path '$'
                      )
                )
             )
          jt
       where jt.elem_type = 'way'
         and jt.highway_type is not null
         and jt.highway_type not in ( 'proposed',
                                      'corridor' )
   ),street_points as (
      select wn.way_id,
             wn.street_name,
             wn.highway_type,
             wn.node_seq,
             nc.node_lon,
             nc.node_lat
        from way_nodes wn
        join slb_slobozia_streets_nodes_lookup nc
      on nc.node_id = wn.node_ref
   ),street_nodes_convertor as (
      select sp.way_id,
             sp.street_name,
             sp.highway_type,
             'LINESTRING ('
             ||
             listagg(sp.node_lon
                     || ' '
                     || sp.node_lat,
                     ', ') within group(
                 order by sp.node_seq)
             || ')' as nodes_formated
        from street_points sp
       group by sp.way_id,
                sp.street_name,
                sp.highway_type
   )
   select sw.way_id,
          nvl(
             sw.street_name,
             'No Name'
          ),
          sw.highway_type,
          mdsys.sdo_geometry(
             sw.nodes_formated,
             8307
          ) as geom
     from street_nodes_convertor sw;

commit;
