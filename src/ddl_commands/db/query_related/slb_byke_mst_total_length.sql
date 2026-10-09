select count(*) as nr_routes,
       round(
          sum(r.length_m) / 1000,
          3
       ) as mst_km,
       round(
          sum(sdo_geom.sdo_length(
             r.geom,
             0.05,
             'unit=M'
          )) / 1000,
          3
       ) as mst_km_spatial
  from slb_byke_mst m
  join slb_byke_routes r
on r.from_station_uid = m.from_station_uid
   and r.to_station_uid = m.to_station_uid;