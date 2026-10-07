SELECT COUNT(*) AS routes,
       SUM(JSON_VALUE(payload, '$.features[0].properties."track-length"' RETURNING NUMBER)) / 1000 AS total_km
FROM stg_ideal_routes_between_byke_stations;
