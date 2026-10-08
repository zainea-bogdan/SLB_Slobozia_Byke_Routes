create table slb_slobozia_streets_nodes_lookup
   as
      select jt.node_id,
             jt.node_lon,
             jt.node_lat
        from stg_osm_map s,
             json_table ( s.payload,'$.elements[*]'
                columns (
                   elem_type varchar2 ( 10 ) path '$.type',
                   node_id number path '$.id',
                   node_lon number path '$.lon',
                   node_lat number path '$.lat'
                )
             )
          jt
       where jt.elem_type = 'node';

drop table slb_slobozia_streets_nodes_lookup