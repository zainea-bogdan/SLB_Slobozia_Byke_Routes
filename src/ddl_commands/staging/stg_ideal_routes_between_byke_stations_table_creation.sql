create table stg_ideal_routes_between_byke_stations (
   from_station_uid number not null,
   to_station_uid   number not null,
   route_profile    varchar2(30) not null,
   payload          json not null,
   load_date        timestamp default systimestamp not null
);