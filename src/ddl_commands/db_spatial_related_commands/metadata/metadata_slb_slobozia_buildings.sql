insert into user_sdo_geom_metadata (
   table_name,
   column_name,
   diminfo,
   srid
) values
   ( 'SLB_SLOBOZIA_BUILDINGS',
     'GEOM',
     mdsys.sdo_dim_array(
        mdsys.sdo_dim_element(
           'X',
           -180,
           180,
           0.05
        ),
        mdsys.sdo_dim_element(
           'Y',
           -90,
           90,
           0.05
        )
     ),
     8307 );

commit;

-- drop index slb_slobozia_buildings_sidx;

-- delete from user_sdo_geom_metadata
--  where table_name = 'SLB_SLOBOZIA_BUILDINGS'
--    and column_name = 'GEOM';

-- commit;