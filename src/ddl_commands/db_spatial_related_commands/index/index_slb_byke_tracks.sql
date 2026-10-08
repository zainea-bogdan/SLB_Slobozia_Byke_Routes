create index slb_byke_tracks_sidx on
   slb_byke_tracks (
      geom
   )
      indextype is mdsys.spatial_index_v2;