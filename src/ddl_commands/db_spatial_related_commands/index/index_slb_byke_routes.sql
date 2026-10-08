create index slb_byke_routes_sidx on
   slb_byke_routes (
      geom
   )
      indextype is mdsys.spatial_index_v2;