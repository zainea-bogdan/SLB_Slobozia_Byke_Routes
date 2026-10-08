insert into slb_byke_stations (
   station_uid,
   station_number,
   station_name,
   station_type,
   bike_racks,
   longitude,
   latitude,
   geom
)
   select stg.station_uid,
          stg.station_number,
          trim(stg.station_name) as station_name,
          case
             when stg.bike_racks > 0 then
                'docked'
             else
                'dockless'
          end as station_type,
          stg.bike_racks,
          stg.longitude,
          stg.latitude,
          mdsys.sdo_geometry(
             2001,
             8307,
             mdsys.sdo_point_type(
                stg.longitude,
                stg.latitude,
                null
             ),
             null,
             null
          ) as geom
     from stg_bykes_stations_coordinates stg;

commit;

