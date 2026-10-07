import os
from pathlib import Path

import oracledb
from dotenv import load_dotenv

ROUTES_DIR = Path(__file__).parents[3] / "data_sample" / "brouter_byke_ideal_routes"
ROUTE_PROFILE = "trekking"

INSERT_SQL = """
    INSERT INTO stg_ideal_routes_between_byke_stations
        (from_station_uid, to_station_uid, route_profile, payload)
    VALUES (:from_station_uid, :to_station_uid, :route_profile, :payload)
"""

rows = []
for route_file in sorted(ROUTES_DIR.glob("*.geojson")):
    from_uid, to_uid = route_file.stem.split("_")
    rows.append({
        "from_station_uid": int(from_uid),
        "to_station_uid": int(to_uid),
        "route_profile": ROUTE_PROFILE,
        "payload": route_file.read_text(encoding="utf-8"),
    })

print("Route files:", len(rows))

load_dotenv()

with oracledb.connect(
    user=os.environ["ORACLE_USER"],
    password=os.environ["ORACLE_PASSWORD"],
    dsn=os.environ["ORACLE_DSN"],
) as connection:
    with connection.cursor() as cursor:
        cursor.setinputsizes(payload=oracledb.DB_TYPE_CLOB)
        cursor.executemany(INSERT_SQL, rows)
    connection.commit()
    print("Inserted", len(rows), "routes")