-- layer: return leg (last station back to Casa Armatei)
select ch.step,
       (
          select case
                    when ch.from_station_uid < ch.to_station_uid then
                       r.geom
                    else
                       sdo_util.reverse_linestring(r.geom)
                 end
            from slb_byke_routes r
           where r.from_station_uid = least(
                ch.from_station_uid,
                ch.to_station_uid
             )
             and r.to_station_uid = greatest(
             ch.from_station_uid,
             ch.to_station_uid
          )
       ) as geom
  from slb_byke_chain ch
 where ch.step = (
   select max(step)
     from slb_byke_chain
);