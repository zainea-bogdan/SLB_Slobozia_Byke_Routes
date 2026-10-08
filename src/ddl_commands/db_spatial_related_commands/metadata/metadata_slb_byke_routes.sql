insert into user_sdo_geom_metadata (table_name, column_name, diminfo, srid)
values (
   'SLB_BYKE_ROUTES',
   'GEOM',
   mdsys.sdo_dim_array(
      mdsys.sdo_dim_element('X', -180, 180, 0.05),
      mdsys.sdo_dim_element('Y', -90, 90, 0.05)
   ),
   8307
);

commit;
