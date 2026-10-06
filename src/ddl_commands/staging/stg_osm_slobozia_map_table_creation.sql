create table stg_osm_map (
   load_date  timestamp default systimestamp not null,
   bbox_north number(10,7) not null,
   bbox_west  number(10,7) not null,
   bbox_south number(10,7) not null,
   bbox_east  number(10,7) not null,
   payload    json not null
);