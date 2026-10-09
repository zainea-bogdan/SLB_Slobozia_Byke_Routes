   set serveroutput on;

delete from slb_byke_mst;

declare
   type t_group_map is
      table of number index by pls_integer;
   v_group      t_group_map;
   v_from_group number;
   v_to_group   number;
   v_uid        pls_integer;
   v_kept       pls_integer := 0;
begin
-- incarc toate statiile in tabela indexata pe baza careia iterez in bloc
   for st in (
      select station_uid
        from slb_byke_stations
   ) loop
      v_group(st.station_uid) := st.station_uid;
   end loop;

   dbms_output.put_line('Stations loaded: ' || v_group.count);

-- ///////////////////////////////////////////////

   for rt in (
      -- toate rutele dintre statiil in ordine crescatoare a lungimii lor.
      select from_station_uid,
             to_station_uid,
             length_m
        from slb_byke_routes
       order by length_m
   ) loop
      v_from_group := v_group(rt.from_station_uid);
      v_to_group := v_group(rt.to_station_uid);
      if v_from_group <> v_to_group then
         dbms_output.put_line('KEEP '
                              || rt.from_station_uid
                              || '-'
                              || rt.to_station_uid
                              || ' ('
                              || rt.length_m || ' m)');
         -- counter cate rute au fost retinute
         v_kept := v_kept + 1;
         -- salveaza ruta dintre cele doua statii in mst ( minimum span tree )
         insert into slb_byke_mst (
            from_station_uid,
            to_station_uid,
            pick_order
         ) values
            ( rt.from_station_uid,
              rt.to_station_uid,
              v_kept );
         -- 
         v_uid := v_group.first;
         while v_uid is not null loop
            if v_group(v_uid) = v_to_group then
               v_group(v_uid) := v_from_group;
            end if;
            v_uid := v_group.next(v_uid);
         end loop;
      else
         dbms_output.put_line('SKIP '
                              || rt.from_station_uid
                              || '-'
                              || rt.to_station_uid
                              || ' ('
                              || rt.length_m || ' m)');
      end if;

   end loop;
   commit;
   dbms_output.put_line('Routes kept: ' || v_kept);
end;
/