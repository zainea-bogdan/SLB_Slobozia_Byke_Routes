delete from slb_byke_chain;

insert into slb_byke_chain (
   step,
   from_station_uid,
   to_station_uid
)
   with routes_2way as (
      select from_station_uid as station_a,
             to_station_uid as station_b,
             length_m
        from slb_byke_routes
      union all
      select to_station_uid,
             from_station_uid,
             length_m
        from slb_byke_routes
   ),chain (
      step,
      from_uid,
      station_uid,
      visited,
      rn
   ) as (
      select 0,
             cast(null as number),
             station_uid,
             cast('/'
                  || station_uid
                  || '/' as varchar2(4000)),
             1
        from slb_byke_stations
       where station_uid = 377930642
      union all
      select c.step + 1,
             c.station_uid,
             r.station_b,
             c.visited
             || r.station_b
             || '/',
             row_number()
             over(partition by c.step
                  order by r.length_m,
                           r.station_b
             )
        from chain c
        join routes_2way r
      on r.station_a = c.station_uid
       where c.rn = 1
         and instr(
         c.visited,
         '/'
         || r.station_b
         || '/'
      ) = 0
   )
   select step,
          from_uid,
          station_uid
     from chain
    where rn = 1
      and step > 0;

commit;

insert into slb_byke_chain (
   step,
   from_station_uid,
   to_station_uid
)
   select l.step + 1,
          l.to_station_uid,
          f.from_station_uid
     from slb_byke_chain l
     join slb_byke_chain f
   on f.step = 1
    where l.step = (
      select max(step)
        from slb_byke_chain
   );

commit;