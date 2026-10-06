SELECT longitude, latitude,
       COUNT(*) AS stations_here,
       LISTAGG(station_name, ' | ') WITHIN GROUP (ORDER BY station_name) AS names
FROM stg_bykes_stations_coordinates
GROUP BY longitude, latitude
HAVING COUNT(*) > 1;
