create index slb_slobozia_points_sidx
   on slb_slobozia_points (geom)
   indextype is mdsys.spatial_index_v2;
