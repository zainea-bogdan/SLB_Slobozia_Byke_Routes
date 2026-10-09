select count(*) as nr_legs,
       round(
          sum(r.length_m) / 1000,
          3
       ) as loop_km
  from slb_byke_chain ch
  join slb_byke_routes r
on r.from_station_uid = least(
      ch.from_station_uid,
      ch.to_station_uid
   )
   and r.to_station_uid = greatest(
   ch.from_station_uid,
   ch.to_station_uid
);
