select
   listagg(s.station_name,
           ' -> ') within group(
    order by ch.step)
   || ' -> '
   || max(
   case
      when ch.step = 1 then
         s.station_name
   end
) as loop_path
  from slb_byke_chain ch
  join slb_byke_stations s
on s.station_uid = ch.from_station_uid;


-- select ch.step,
--        sf.station_name as from_station,
--        st.station_name as to_station,
--        r.length_m as route_m,
--        round(
--           sdo_geom.sdo_distance(
--              sf.geom,
--              st.geom,
--              0.05,
--              'unit=M'
--           ),
--           2
--        ) as straight_line_m
--   from slb_byke_chain ch
--   join slb_byke_stations sf
-- on sf.station_uid = ch.from_station_uid
--   join slb_byke_stations st
-- on st.station_uid = ch.to_station_uid
--   join slb_byke_routes r
-- on r.from_station_uid = least(
--       ch.from_station_uid,
--       ch.to_station_uid
--    )
--    and r.to_station_uid = greatest(
--    ch.from_station_uid,
--    ch.to_station_uid
-- )
--  order by ch.step;