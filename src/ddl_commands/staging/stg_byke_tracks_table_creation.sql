create table stg_byke_tracks (
   track_code    varchar2(30) not null,
   track_name    varchar2(200 char) not null,
   waypoints     varchar2(4000) not null,
   route_profile varchar2(30) not null,
   payload       json not null,
   load_date     timestamp default systimestamp not null
);