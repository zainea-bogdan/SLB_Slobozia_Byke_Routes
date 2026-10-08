create index slb_slobozia_buildings_sidx
   on slb_slobozia_buildings (geom)
   indextype is mdsys.spatial_index_v2;

select index_name, status
  from user_indexes
 where index_name = 'SLB_SLOBOZIA_BUILDINGS_SIDX';
