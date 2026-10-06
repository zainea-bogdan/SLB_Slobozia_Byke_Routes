create table stg_bykes_stations_coordinates (
   station_uid    number not null,
   station_number number,
   station_name   varchar2(200 char) not null,
   longitude      number(10,7) not null,
   latitude       number(10,7) not null,
   bike_racks     number,
   load_date      timestamp default systimestamp not null
);