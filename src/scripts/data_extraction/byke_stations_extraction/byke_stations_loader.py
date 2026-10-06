import json
import os
from pathlib import Path

import oracledb
from dotenv import load_dotenv

INPUT_FILE = Path(__file__).parents[3] / "data_sample" / "slobozia_bike_stations.json"

INSERT_SQL = """
    INSERT INTO stg_bykes_stations_coordinates
        (station_uid, station_number, station_name, longitude, latitude, bike_racks)
    VALUES (:station_uid, :num, :name, :lon, :lat, :racks)
"""

with open(INPUT_FILE, encoding="utf-8") as f:
    stations = json.load(f)

print("Stations in file:", len(stations))

rows = [
    {
        "station_uid": s["uid"],
        "num": s["number"],
        "name": s["name"].strip(),
        "lon": s["lng"],
        "lat": s["lat"],
        "racks": s["bike_racks"],
    }
    for s in stations
]

load_dotenv()

with oracledb.connect(
    user=os.environ["ORACLE_USER"],
    password=os.environ["ORACLE_PASSWORD"],
    dsn=os.environ["ORACLE_DSN"],
) as connection:
    with connection.cursor() as cursor:
        cursor.executemany(INSERT_SQL, rows)
    connection.commit()
    print("Inserted", len(rows), "stations")
