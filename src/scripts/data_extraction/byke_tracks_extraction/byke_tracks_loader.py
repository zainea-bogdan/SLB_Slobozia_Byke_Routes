import json
import os
from pathlib import Path

import oracledb
from dotenv import load_dotenv

TRACKS_DIR = Path(__file__).parents[3] / "data_sample" / "brouter_byke_tracks"
DEFINITION_FILE = TRACKS_DIR / "byke_tracks_definition.json"
ROUTE_PROFILE = "trekking"

INSERT_SQL = """
    INSERT INTO stg_byke_tracks
        (track_code, track_name, waypoints, route_profile, payload)
    VALUES (:track_code, :track_name, :waypoints, :route_profile, :payload)
"""

with open(DEFINITION_FILE, encoding="utf-8") as f:
    tracks = json.load(f)

rows = []
for track in tracks:
    route_file = TRACKS_DIR / f"{track['track_code']}.geojson"
    rows.append({
        "track_code": track["track_code"],
        "track_name": track["track_name"],
        "waypoints": track["waypoints"],
        "route_profile": ROUTE_PROFILE,
        "payload": route_file.read_text(encoding="utf-8"),
    })

print("Tracks:", len(rows))

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
    print("Inserted", len(rows), "tracks")
