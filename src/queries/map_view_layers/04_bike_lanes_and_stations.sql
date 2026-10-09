-- layer: bike lanes
select track_code,
       track_name,
       geom
  from slb_byke_tracks;

-- layer: bike stations
select station_uid,
       station_name,
       station_type,
       geom
  from slb_byke_stations;