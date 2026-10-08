create index slb_byke_stations_sidx on
   slb_byke_stations (
      geom
   )
      indextype is mdsys.spatial_index_v2;

-- drop index slb_byke_stations_sidx force;

-- delete from user_sdo_geom_metadata
--  where table_name = 'SLB_BYKE_STATIONS'
--    and column_name = 'GEOM';

-- commit;

-- drop table slb_byke_stations purge;